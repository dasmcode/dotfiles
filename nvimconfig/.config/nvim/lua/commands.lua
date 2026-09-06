vim.api.nvim_create_user_command("PackAdd", function(opts)
	vim.pack.add(opts.fargs)
end, { nargs = "+", desc = "Add plugins (:PackAdd user/repo1 user/repo2)" })

-- Pack Delete and Update cmds are built-in on Nightly 0.13
vim.api.nvim_create_user_command("PackDel", function(opts)
	local plugins = opts.fargs

	-- If no arguments were supplied, use the selected/current lines.
	if #plugins == 0 then
		local lines = vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, false)

		for _, line in ipairs(lines) do
			local plugin = line:match('Plugin "([^"]+)"')
			if plugin then
				table.insert(plugins, plugin)
			end
		end
	end

	if #plugins == 0 then
		vim.notify("No plugins found", vim.log.levels.WARN)
		return
	end

	vim.pack.del(plugins)
end, {
	nargs = "*",
	range = true,
	desc = "Delete plugins (:PackDel plugin1 plugin2 | visual selection)",
})
vim.api.nvim_create_user_command("PackUpdate", function(opts)
	-- checks if any argument is passed
	if opts.args:match("%S") then
		-- update specific plugins
		local plugins = vim.split(opts.args, "%s+", { trimempty = true })
		-- update only specified plugins
		vim.pack.update(plugins)
	else
		-- update all
		vim.pack.update()
	end
end, { nargs = "*", desc = "Update all plugins or specific ones" })
