import asyncio
import pulsectl_asyncio as pulsectl
from dbus_next.aio.message_bus import MessageBus
import dbus_next.introspection as introspection


async def main():
    # Connect to MPRIS
    bus = await MessageBus().connect()
    introspection = await bus.introspect(
        "org.mpris.MediaPlayer2.spotify", "/org/mpris/MediaPlayer2"
    )

    # Connect to PulseAudio
    with pulsectl.PulseAsync("polybar-now-playing") as pulse:
        await pulse.connect()

        # Listen to changes
        metadata_change_iter = get_player_metadata_iter(bus, introspection)
        volume_change_iter = pulse.subscribe_events(
            pulsectl.pulsectl_async.PulseEventMaskEnum.sink_input
        )
        single_iter = single_none_iterator()

        async for _ in merge_async_iters(
            metadata_change_iter, volume_change_iter, single_iter
        ):
            # Output metadata and volume on any change
            metadata = await get_spotify_metadata(bus, introspection)
            volume = await get_spotify_volume(pulse)
            print(f"{metadata} {volume}", flush=True)


async def get_spotify_volume(pulse: pulsectl.PulseAsync):
    inputs = await pulse.sink_input_list()
    # FIXME: how do we know which sink to pick? sometimes there's multiple
    spotify_sink = [sink for sink in inputs if sink.name == "Spotify"][-1]
    volume = f"{round(spotify_sink.volume.value_flat * 100)}%"
    return "%{F#C9CBFF}" + volume + "%{F-}"


async def get_spotify_metadata(bus: MessageBus, introspection: introspection.Node):
    obj = bus.get_proxy_object(
        "org.mpris.MediaPlayer2.spotify", "/org/mpris/MediaPlayer2", introspection
    )
    player = obj.get_interface("org.mpris.MediaPlayer2.Player")

    metadata = await player.get_metadata()
    is_playing = await player.get_playback_status() == "Playing"

    icon = "" if is_playing else ""
    title = metadata["xesam:title"].value
    artists = ", ".join(metadata["xesam:artist"].value)

    section1 = f"{icon} {title} -"
    section2 = f" {artists}"

    return "%{F#A4B9EF}" + section1 + "%{F-}%{F#C9CBFF}" + section2 + "%{F-}"


def get_player_metadata_iter(bus: MessageBus, introspection: introspection.Node):
    obj = bus.get_proxy_object(
        "org.mpris.MediaPlayer2.spotify", "/org/mpris/MediaPlayer2", introspection
    )
    # player = obj.get_interface("org.mpris.MediaPlayer2.Player")
    properties = obj.get_interface("org.freedesktop.DBus.Properties")

    # listen to signals
    iter, put = make_iter()
    properties.on_properties_changed(lambda _, __, ___: put())
    return iter


# ----------
# Utils
def make_iter():
    loop = asyncio.get_event_loop()
    queue = asyncio.Queue()

    def put(*args):
        loop.call_soon_threadsafe(queue.put_nowait, args)

    async def get():
        while True:
            yield await queue.get()

    return get(), put


def merge_async_iters(*aiters):
    # merge async iterators, proof of concept
    queue = asyncio.Queue(1)

    async def drain(aiter):
        async for item in aiter:
            await queue.put(item)

    async def merged():
        while not all(task.done() for task in tasks):
            yield await queue.get()

    tasks = [asyncio.create_task(drain(aiter)) for aiter in aiters]
    return merged()


async def single_none_iterator():
    yield None


# ----------
# Run
asyncio.run(main())
