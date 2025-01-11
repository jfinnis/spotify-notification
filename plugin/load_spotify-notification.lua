vim.api.nvim_create_user_command('SpotifyNotifStart', function()
    require('spotify-notification').start_polling()
end, {})

vim.api.nvim_create_user_command('SpotifyNotifStop', function()
    require('spotify-notification').stop_polling()
end, {})

vim.api.nvim_create_user_command('SpotifyNotifRunning', function()
    require('spotify-notification').is_running()
end, {})

vim.api.nvim_command('SpotifyNotifStart')
