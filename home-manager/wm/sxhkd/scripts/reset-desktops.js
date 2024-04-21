const { exec: execInternal } = require("child_process");

const exec = (command) =>
  new Promise((resolve) =>
    execInternal(command, (_, stdout) => resolve(stdout))
  );

if (process.argv.length < 4) {
  console.log(
    "Usage: node reset-desktops.js Monitor1 Monitor2\nEx: node reset-desktops.js DP-0 DP-2"
  );
  process.exit(1);
}

const correctMonitorOrder = [
  { name: process.argv[2], desktops: ["I", "II", "III", "IV", "V"] },
  {
    name: process.argv[3],
    desktops: ["VI", "VII", "VIII", "IX", "X"],
  },
];

async function run() {
  const result = await exec("bspc wm -g")
    .then((result) => result.slice(1)) // Removes the 'W' at the beginning
    .then((result) => result.split(":").filter(Boolean)); // Delimited by :
  const monitors = [];

  for (const entry of result) {
    const entryLC = entry.toLowerCase();
    if (entryLC.startsWith("m")) {
      monitors.push({ name: entry.slice(1), desktops: [] });
      continue;
    }
    if (entryLC.startsWith("f") || entryLC.startsWith("o")) {
      monitors.at(-1).desktops.push(entry.slice(1));
    }
  }

  for (const monitor of monitors) {
    const correctOrder = correctMonitorOrder.find(
      ({ name }) => name === monitor.name
    ).desktops;
    const incorrectDesktop = monitor.desktops
      .map((desktop, i) => ({ current: desktop, correct: correctOrder[i] }))
      .find((desktop) => desktop.current !== desktop.correct);
    if (!incorrectDesktop) return;

    await exec(
      `bspc desktop ${incorrectDesktop.current} -s ${incorrectDesktop.correct}`
    );
    return run();
  }
}

run();
