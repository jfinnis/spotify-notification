local M = {}

local last_song_info = nil
local is_timer_running = false

--- Check for song info changes but only notify into the active Neovim session.
local function notify_song_info()
    if require('spotify-notification.config').is_focused() then
        local file = vim.fn.stdpath 'data'
            .. '/lazy/spotify-notification.nvim/lua/spotify-notification/scripts/'
            .. 'now_playing.sh'
        local song_info = vim.trim(vim.fn.system('bash ' .. vim.fn.shellescape(file)))
        if song_info ~= last_song_info then
            vim.notify(song_info, vim.log.levels.INFO, { title = 'Spotify' })
            last_song_info = song_info
        end
    end
end

local timer = nil

--- Polling for song info changes every 3 seconds.
---@param debug? boolean
function M.start_polling(debug)
    debug = debug or false

    timer = timer or vim.loop.new_timer()
    timer:start(0, 5000, vim.schedule_wrap(notify_song_info))
    is_timer_running = true
    if debug then
        vim.notify('Spotify Notification Started', vim.log.levels.INFO, { title = 'Spotify' })
    end
end

---@param debug? boolean
function M.stop_polling(debug)
    debug = debug or false

    timer:stop()
    timer:close()
    timer = nil
    last_song_info = nil
    is_timer_running = false
    if debug then
        vim.notify('Spotify Notification Stopped', vim.log.levels.INFO, { title = 'Spotify' })
    end
end

function M.is_running()
    vim.notify(
        'Spotify Notification is ' .. (is_timer_running and 'on' or 'off'),
        vim.log.levels.INFO,
        { title = 'Spotify' }
    )
    return is_timer_running
end

return M
