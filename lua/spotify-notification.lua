local M = { }

local is_focused = true
local is_timer_running = false
local last_song_info = nil

-- Keep track of the instance of nvim that is focused so we don't have background instances
-- calling scripts unnecessarily.
vim.api.nvim_create_autocmd({'FocusGained', 'FocusLost'}, {
    callback = function(event)
        if event.event == 'FocusGained' then
            is_focused = true
        else
            is_focused = false
        end
    end
})

--- Check for song info changes but only notify into the active Neovim session.
local function notify_song_info()
    if is_focused then
        local file = vim.fn.stdpath 'config' .. '/scripts/now-playing.sh'
        local song_info = vim.trim(vim.fn.system('bash ' .. vim.fn.shellescape(file)))

        if song_info ~= last_song_info then
            vim.notify(song_info, vim.log.levels.INFO, { title = 'Spotify' })
            last_song_info = song_info
        end
    end
end

--- Polling for song info changes every 3 seconds.
local timer = nil
M.start_polling = function()
    timer = timer or vim.loop.new_timer()
    timer:start(0, 3000, vim.schedule_wrap(notify_song_info))
    is_timer_running = true
    vim.notify('Spotify Notification Started', vim.log.levels.INFO, { title = 'Spotify' })
end

M.stop_polling = function()
    timer:stop()
    timer:close()
    is_timer_running = false
    vim.notify('Spotify Notification Stopped', vim.log.levels.INFO, { title = 'Spotify' })
end

M.is_running = function()
    vim.notify(
        'Spotify Notification is ' .. (is_timer_running and 'on' or 'off'),
        vim.log.levels.INFO,
        { title = 'Spotify' }
    )
    return is_timer_running
end

return M


-- TODO: provide commands to start and stop polling
-- maybe zenmode pauses the polling
-- toggle and restore?
