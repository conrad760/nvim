local status_ok, dadbod = pcall(require, "vim-dadbod-ui")
if not status_ok then
	return
end

dadbod.setup(
  {
  completion_matching_ignore_case = 1
  }
)
