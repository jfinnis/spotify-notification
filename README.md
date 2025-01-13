# `spotify-notification.nvim`

Popup a notification every time the Spotify song changes.

There are many other Spotify-based plugins that include extra features like Spotify controls...
All I want is a single notification when a new song plays.

## Installation/Configuration

```lua
{
    'jfinnis/spotify-notification.nvim',
    opts = {
        debug = false -- Show message when starting/stopping notifications
    },
}
```
## Commands

`SpotifyNotifStart`: Start the notifications

`SpotifyNotifStop`: Stop the notifications

`SpotifyNotifRunning`: Check if the notifications are running
