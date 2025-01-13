local M = {}

---@param opts? spotifynotif.Config
M.setup = function(opts)
    require('spotify-notification.config').setup(opts)
end

return M
