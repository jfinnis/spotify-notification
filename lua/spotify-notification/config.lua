---@class spotifynotif.Config.mod: spotifynotif.Config
local M = {}

---@class spotifynotif.Config
local defaults = {
    ---@type boolean
    debug = false,
    ---@type boolean|(fun():boolean?)
    enabled = function()
        return vim.g.spotifynotif_enabled == nil and true or vim.g.spotifynotif_enabled
    end
}

---@type spotifynotif.Config
local options
local focused = true

---@param opts? spotifynotif.Config
function M.setup(opts)
    ---@type spotifynotif.Config
    options = vim.tbl_deep_extend('force', {}, options or defaults, opts or {})

    vim.api.nvim_create_user_command('SpotifyNotifStart', function()
        require('spotify-notification.commands').start_polling(options.debug)
    end, {})

    vim.api.nvim_create_user_command('SpotifyNotifStop', function()
        require('spotify-notification.commands').stop_polling(options.debug)
    end, {})

    vim.api.nvim_create_user_command('SpotifyNotifRunning', function()
        require('spotify-notification.commands').is_running()
    end, {})

    -- call with schedule?
    vim.api.nvim_command('SpotifyNotifStart')

    -- Keep track of the instance of nvim that is focused so we don't have background instances
    -- calling scripts unnecessarily.
    vim.api.nvim_create_autocmd({'FocusGained', 'FocusLost'}, {
        callback = function(event)
            if event.event == 'FocusGained' then
                focused = true
            else
                focused = false
            end
        end
    })

    return options
end

---@return boolean
function M.is_focused()
    return focused
end

-- Ensure that M.setup is called prior to any other plugin functions.
return setmetatable(M, {
  __index = function(_, key)
    options = options or M.setup()
    return options[key]
  end,
})
