gh api /notifications | jq "map(select(.unread == true)) | length"
