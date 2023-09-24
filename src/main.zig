const std = @import("std");
const sqlite = @import("sqlite");
const raylib = @import("raylib");
const Image = raylib.Image;
const Allocator = std.mem.Allocator;

// const settings = @import("settings");
// const ColorTheme = settings.ColorTheme;

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

const colors = [_]ColorTheme{
    ColorTheme{
        .title = "Menu items",
        .dm_text_color = raylib.RED, // Dark mode text color for this item
        .lm_text_color = raylib.BLACK, // Light mode text color for this item
        .dm_background_color = raylib.BLACK, // Dark mode background color (null for default)
        .lm_background_color = raylib.WHITE, // Light mode background color (null for default)
        .dm_hover_color = raylib.GREEN, // Dark mode hover color
        .lm_hover_color = raylib.LIME, // Light mode hover color
        .dm_selected_color = raylib.RED, // Dark mode selected color
        .lm_selected_color = raylib.RED, // Light mode selected color
    },
};

// Define a struct to represent menu items
const MenuItem = struct {
    title: [*:0]const u8, // The text to display for the menu item
    selected: bool, // Indicates whether the item is currently selected
};

// Create an array of menu items
var menu_items = [3]MenuItem{
    MenuItem{ .title = "Browse Anime", .selected = false },
    MenuItem{ .title = "Browse Manga", .selected = false },
    MenuItem{ .title = "Settings", .selected = false },
};

const menu_width = 200; // Width of the sidebar menu
pub var is_dark_mode: bool = true;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer if (gpa.deinit() == .leak) @panic("found memory leaks");
    const allocator: Allocator = gpa.allocator();

    var db = try sqlite.Db.init(.{
        // .mode = sqlite.Db.Mode{ .File = "/database.db" },
        .mode = sqlite.Db.Mode{ .File = "/database.db" },
        .open_flags = .{
            .write = true,
            .create = true,
        },
        .threading_mode = .MultiThread,
    });
    defer db.deinit();
    // defer std.log.info("gpa.deinit(): {any}", .{gpa.deinit()});
    // defer std.log.info("gpa.deinit(): {any}", .{gpa.detectLeaks()});
    // defer if (gpa.deinit() == .leak) {
    //     std.debug.panic("leaks detected", .{});
    // };

    try executeSQLiteScripts(&db, allocator);

    // defer raylib.CloseWindow();
    //
    // const iconImage: Image = raylib.LoadImage("sailor.png");
    // defer raylib.UnloadImage(iconImage);
    // std.log.info("iconImage: {any}", .{iconImage});
    //
    // raylib.SetConfigFlags(raylib.ConfigFlags{ .FLAG_WINDOW_RESIZABLE = true });
    // raylib.InitWindow(800, 800, "Anime collection.zig");
    // raylib.SetWindowIcon(iconImage);
    // raylib.SetTargetFPS(60);
    //
    // var selected_index: usize = 0;
    //
    // while (!raylib.WindowShouldClose()) {
    //     raylib.BeginDrawing();
    //     defer raylib.EndDrawing();
    //
    //     raylib.ClearBackground(colors[0].background());
    //     raylib.DrawFPS(10, 10);
    //     renderSidebarMenu(&selected_index);
    //
    //     // raylib.DrawText("hello world!", 100, 100, 20, raylib.YELLOW);
    // }
}

fn renderSidebarMenu(selected_index: *usize) void {
    // Calculate the position for the menu items
    var menu_item_y: i32 = 100;

    for (menu_items, 0..) |item, menu_index| {
        // Determine the text color based on whether the item is selected or hovered
        var text_color: raylib.Color = undefined;

        // Check if the mouse cursor is over the menu item
        if (raylib.CheckCollisionPointRec(raylib.GetMousePosition(), raylib.Rectangle{
            .x = 0,
            .y = @floatFromInt(menu_item_y),
            .width = menu_width,
            .height = 20,
        })) {
            text_color = colors[0].hover(); // Change the text color when hovered
        } else if (selected_index.* == menu_index) {
            text_color = colors[0].selected(); // Change the text color when selected
        } else {
            text_color = colors[0].text(); // Default text color
        }

        // Draw the menu item text
        raylib.DrawText(item.title, 10, menu_item_y, 20, text_color);

        // Increase the Y position for the next menu item
        menu_item_y += 30;
    }
}

fn executeSQLiteScripts(db: *sqlite.Db, gpa_allocator: Allocator) !void {
    var arena_allocator = std.heap.ArenaAllocator.init(gpa_allocator);
    defer arena_allocator.deinit();
    var allocator = arena_allocator.allocator();

    // SQL command to create the "Anime" table with columns
    // const createTableScript =
    //     \\CREATE TABLE IF NOT EXISTS Anime (
    //     \\id INTEGER PRIMARY KEY AUTOINCREMENT,
    //     \\title TEXT NOT NULL,
    //     \\genre TEXT,
    //     \\episode_count INTEGER
    //     \\)
    // ;
    //
    // // Execute the SQL command to create the table
    // try db.exec(createTableScript, .{}, .{});

    // const insertScript =
    //     \\INSERT INTO Anime (title
    //     \\,genre
    //     \\)
    //     \\VALUES(
    //     \\,$title{[]const u8}
    //     \\,$genre{[]const u8}
    //     \\)
    // ;

    // Execute the SQL command to create the table
    // try db.exec(insertScript, .{}, .{ @as([]const u8, "Kindaichi"), @as([]const u8, "Mystery") });
    //
    // const selectScript =
    //     \\ SELECT
    //     \\ id
    //     \\ ,title
    //     \\ FROM
    //     \\ Anime
    // ;

    // var stmt = try db.prepare(selectScript);
    // defer stmt.deinit();
    //
    // const row = try stmt.one(
    //     struct {
    //         id: usize,
    //         title: [128:0]u8,
    //     },
    //     .{},
    //     .{},
    // );
    //
    // if (row) |row_value| {
    //     std.log.info("row1: {s}", .{row_value.title});
    // }

    const query =
        \\SELECT 
        \\id 
        \\,title 
        \\,genre 
        \\FROM 
        \\Anime
    ;

    var stmt = try db.prepare(query);
    defer stmt.deinit();

    // const row2 = try db.oneAlloc(
    //     struct {
    //       id: usize,
    //       title: []const u8,
    //       genre: []const u8,
    //     },
    //     allocator,
    //     query,
    //     .{},
    //     .{},
    // );

    const row2 = try stmt.oneAlloc(
        struct {
            id: usize,
            title: []const u8,
            genre: []const u8,
        },
        allocator,
        .{},
        .{},
    );

    if (row2) |row2_value| {
        std.log.info("row2_value.id: {any}", .{row2_value.id});
        std.log.info("row2_value.title: {s}", .{row2_value.title});
        std.log.info("row2_value.genre: {s}", .{row2_value.genre});
    }

    var iter_stmt = try db.prepare(query);
    defer iter_stmt.deinit();

    var iter = try iter_stmt.iteratorAlloc(
        struct {
            id: usize,
            title: []const u8,
            genre: []const u8,
        },
        allocator,
        .{},
    );

    while (true) {
        // var arena = std.heap.ArenaAllocator.init(allocator);
        // defer arena.deinit();

        // const iter_value = try iter.nextAlloc(arena.allocator(), .{}) orelse break;
        const iter_value = try iter.nextAlloc(allocator, .{}) orelse break;
        std.log.info("iter_value.id: {any}", .{iter_value.id});
        std.log.info("iter_value.title: {s}", .{iter_value.title});
        std.log.info("iter_value.genre: {s}", .{iter_value.genre});
    }

    // const Anime = struct {
    //     id: usize,
    //     title: []const u8,
    //     genre: []const u8,
    //     episode_count: u32
    // };

    // const selectScript =
    //     \\ SELECT
    //     \\ id
    //     \\ ,title
    //     \\ ,genre
    //     \\ FROM
    //     \\ Anime
    //     \\ WHERE
    //     \\ id = 1
    // ;
    //
    // try db.exec(selectScript, .{}, .{});
    // std.log.info("result: {any}", .{result});

    // Check for errors
    // if (result != sqlite.Result.Done) {
    //     // Handle the error (e.g., log or return an error)
    //     // Note: In a production application, you should handle errors more gracefully.
    //     std.debug.print("Error creating Anime table: {s}\n", .{sqlite.errorMsg(db)});
    // } else {
    //     std.debug.print("Anime table created successfully!\n");
    // }
}
