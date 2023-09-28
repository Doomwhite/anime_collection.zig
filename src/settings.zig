const std = @import("std");
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;

const raylib = @import("raylib");
const Image = raylib.Image;

pub var is_dark_mode: bool = false;

pub var selected_theme_index: usize = 0;

pub fn changeTheme() void {
    if (colors.len - 1 <= selected_theme_index) {
        selected_theme_index = 0;
    } else {
        selected_theme_index += 1;
    }
    std.log.info("selected_theme_index: {any}", .{selected_theme_index});
}

pub const ColorTheme = struct {
    title: []const u8, // The text to display for the menu item
    text_color: ?raylib.Color,
    background_color: ?raylib.Color,
    hover_color: ?raylib.Color,
    selected_color: ?raylib.Color,

    pub fn text(self: ColorTheme) raylib.Color {
        return self.text_color orelse raylib.WHITE;
    }

    pub fn background(self: ColorTheme) raylib.Color {
        return self.background_color orelse raylib.WHITE;
    }

    pub fn hover(self: ColorTheme) raylib.Color {
        return self.hover_color orelse raylib.WHITE;
    }

    pub fn selected(self: ColorTheme) raylib.Color {
        return self.selected_color orelse raylib.WHITE;
    }
};

// Define a struct to represent menu items
pub const MenuItem = struct {
    parent: ?*MenuItem, // Indicates whether the item is currently selected
    title: [*:0]const u8, // The text to display for the menu item
    selected: bool, // Indicates whether the item is currently selected
    items: ?[]const MenuItem, // Indicates whether the item is currently selected
};

pub var colors: [3]ColorTheme = undefined;

// Create an array of menu items
pub var menu_items: [3]MenuItem = undefined;

pub var current_menu: []const MenuItem = undefined;

// pub var is_dark_mode: bool = true;
pub const menu_width = 200; // Width of the sidebar menu

pub fn init_globals() !void {
    var settings_menu_item = MenuItem{ .parent = null, .title = "Settings", .selected = false, .items = undefined };
    var teste = MenuItem{ .parent = &settings_menu_item, .title = "Change theme", .selected = false, .items = null };
    settings_menu_item.items = &[1]MenuItem{teste};
    menu_items = [3]MenuItem{
        MenuItem{ .parent = null, .title = "Browse Anime", .selected = false, .items = null },
        MenuItem{ .parent = null, .title = "Browse Manga", .selected = false, .items = null },
        settings_menu_item,
    };
    // current_menu = ArrayList(MenuItem).init(allocator);
    // try current_menu.appendSlice(&menu_items);
    current_menu = &menu_items;

    colors = [_]ColorTheme{
        ColorTheme{
            .title = "Light theme",
            .text_color = raylib.BLACK,
            .background_color = raylib.WHITE,
            .hover_color = raylib.LIME,
            .selected_color = raylib.LIME,
        },
        ColorTheme{
            .title = "Dark theme",
            .text_color = raylib.RED,
            .background_color = raylib.BLACK,
            .hover_color = raylib.GREEN,
            .selected_color = raylib.PURPLE,
        },
        ColorTheme{
            .title = "Gray theme",
            .text_color = raylib.WHITE,
            .background_color = raylib.GRAY,
            .hover_color = raylib.GREEN,
            .selected_color = raylib.PURPLE,
        },
    };
}
