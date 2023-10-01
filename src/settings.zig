const std = @import("std");
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;

const raylib = @import("raylib");
const Image = raylib.Image;

pub var is_dark_mode: bool = false;

pub var selected_theme_index: usize = 0;

pub const ColorTheme = struct {
    title: []const u8, // The text to display for the menu item
    text_color: ?raylib.Color,
    background_color: ?raylib.Color,
    hover_color: ?raylib.Color,

    pub fn text(self: ColorTheme) raylib.Color {
        return self.text_color orelse raylib.WHITE;
    }

    pub fn background(self: ColorTheme) raylib.Color {
        return self.background_color orelse raylib.WHITE;
    }

    pub fn hover(self: ColorTheme) raylib.Color {
        return self.hover_color orelse raylib.WHITE;
    }
};

pub fn changeTheme() void {
    if (colors.len - 1 <= selected_theme_index) {
        selected_theme_index = 0;
    } else {
        selected_theme_index += 1;
    }
}

// Define a struct to represent menu items
pub const MenuItem = struct {
    type: MenuItemType, // Indicates whether the item is currently selected
    parent: ?*MenuItem, // Indicates whether the item is currently selected
    title: [*:0]const u8, // The text to display for the menu item
    selected: bool, // Indicates whether the item is currently selected
    items: ?[]const MenuItem, // Indicates whether the item is currently selected
};

pub const menu_width = 200;
pub const menu_item_spacing_percent: f32 = 0.05;
pub const menu_item_height = 34;

pub var colors: []const ColorTheme = undefined;

// Create an array of menu items

pub var menu_items: []const MenuItem = undefined;
pub var current_menu: []const MenuItem = undefined;
pub var previous_menu: []const MenuItem = undefined;

pub const MenuItemType = enum {
    BrowserAnime,
    BrowserManga,
    Settings,
    SettingsChangeTheme,
    Return,
};

pub fn loadMenuImage(filename: [*:0]const u8) ?raylib.Texture2D {
    const image = raylib.LoadImage(filename);
    defer raylib.UnloadImage(image);

    return raylib.LoadTextureFromImage(image);
}

// pub var is_dark_mode: bool = true;

pub fn init_globals() !void {
    menu_items = &[_]MenuItem{
        MenuItem{ .type = .BrowserAnime, .parent = null, .title = "Browse Anime", .selected = false, .items = null },
        MenuItem{ .type = .BrowserManga, .parent = null, .title = "Browse Manga", .selected = false, .items = null },
        MenuItem{
            .type = .Settings,
            .parent = null,
            .title = "Settings",
            .selected = false,
            .items = &[_]MenuItem{
                MenuItem{ .type = .SettingsChangeTheme, .parent = null, .title = "Change theme", .selected = false, .items = null },
                MenuItem{ .type = .Return, .parent = null, .title = "Return", .selected = false, .items = null },
            },
        },
    };
    current_menu = menu_items;
    colors = &[_]ColorTheme{
        ColorTheme{
            .title = "Light theme",
            .text_color = raylib.BLACK,
            .background_color = raylib.WHITE,
            .hover_color = raylib.LIME,
        },
        ColorTheme{
            .title = "Dark theme",
            .text_color = raylib.RED,
            .background_color = raylib.BLACK,
            .hover_color = raylib.GREEN,
        },
        ColorTheme{
            .title = "Gray theme",
            .text_color = raylib.WHITE,
            .background_color = raylib.GRAY,
            .hover_color = raylib.GREEN,
        },
    };
}
