const raylib = @import("raylib");
const Image = raylib.Image;

pub var is_dark_mode: bool = false;

pub const ColorTheme = struct {
    title: []const u8, // The text to display for the menu item
    dm_text_color: ?raylib.Color,
    lm_text_color: ?raylib.Color,
    dm_background_color: ?raylib.Color,
    lm_background_color: ?raylib.Color,
    dm_hover_color: ?raylib.Color,
    lm_hover_color: ?raylib.Color,
    dm_selected_color: ?raylib.Color,
    lm_selected_color: ?raylib.Color,

    pub fn text(self: ColorTheme) raylib.Color {
        if (is_dark_mode) {
            return self.dm_text_color orelse raylib.WHITE;
        } else {
            return self.lm_text_color orelse raylib.WHITE;
        }
    }

    pub fn background(self: ColorTheme) raylib.Color {
        if (is_dark_mode) {
            return self.dm_background_color orelse raylib.WHITE;
        } else {
            return self.lm_background_color orelse raylib.WHITE;
        }
    }

    pub fn hover(self: ColorTheme) raylib.Color {
        if (is_dark_mode) {
            return self.dm_hover_color orelse raylib.WHITE;
        } else {
            return self.lm_hover_color orelse raylib.WHITE;
        }
    }

    pub fn selected(self: ColorTheme) raylib.Color {
        if (is_dark_mode) {
            return self.dm_selected_color orelse raylib.WHITE;
        } else {
            return self.lm_selected_color orelse raylib.WHITE;
        }
    }
};

// Define a struct to represent menu items
pub const MenuItem = struct {
    title: [*:0]const u8, // The text to display for the menu item
    selected: bool, // Indicates whether the item is currently selected
};

pub var colors: [1]ColorTheme = undefined;

// Create an array of menu items
pub var menu_items: [3]MenuItem = undefined;

// pub var is_dark_mode: bool = true;
pub const menu_width = 200; // Width of the sidebar menu

pub fn init_globals() void {
    menu_items = [3]MenuItem{
        MenuItem{ .title = "Browse Anime", .selected = false },
        MenuItem{ .title = "Browse Manga", .selected = false },
        MenuItem{ .title = "Settings", .selected = false },
    };
    colors = [_]ColorTheme{
        ColorTheme{
            .title = "Menu items",
            .dm_text_color = raylib.RED, // Dark mode text color for this item
            .lm_text_color = raylib.BLACK, // Light mode text color for this item
            .dm_background_color = raylib.BLACK, // Dark mode background color (null for default)
            .lm_background_color = raylib.WHITE, // Light mode background color (null for default)
            .dm_hover_color = raylib.GREEN, // Dark mode hover color
            .lm_hover_color = raylib.LIME, // Light mode hover color
            .dm_selected_color = raylib.PURPLE, // Dark mode selected color
            .lm_selected_color = raylib.LIME, // Light mode selected color
        },
    };
}
