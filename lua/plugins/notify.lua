return {
	"rcarriga/nvim-notify",
	enabled = false,
	config = function()
		require("notify").setup({
			-- Animation style for notifications (try "fade_in_slide_out", "slide", etc.)
			stages = "fade_in_slide_out",
			-- Time (in ms) each notification is displayed
			timeout = 300,
			-- Render function for notifications; "default" works for most cases
			render = "default",
			-- Maximum width for the notification window (can also be set to a function)
			max_width = 120,
			-- Maximum height for the notification window (nil lets it auto-adjust)
			max_height = 40,
			-- Background colour of the notification window (if supported by your terminal)
			background_colour = "#000000",

			merge_duplicates = true,
		})
	end,
}
