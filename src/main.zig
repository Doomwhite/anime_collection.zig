const std = @import("std");
const sqlite = @import("sqlite");
const raylib = @import("raylib");
const Image = raylib.Image;
const Allocator = std.mem.Allocator;

const settings = @import("settings.zig");
const ColorTheme = settings.ColorTheme;
const menu_width = settings.menu_width;
const MenuItem = settings.MenuItem;

var selected_index: usize = 0;

pub fn main() !void {
    settings.init_globals();
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer if (gpa.deinit() == .leak) @panic("found memory leaks");
    const allocator: Allocator = gpa.allocator();

    var db = try sqlite.Db.init(.{
        .mode = sqlite.Db.Mode{ .File = "/database.db" },
        .open_flags = .{
            .write = true,
            .create = true,
        },
        .threading_mode = .MultiThread,
    });
    defer db.deinit();

    try executeSQLiteScripts(&db, allocator);

    defer raylib.CloseWindow();

    const iconImage: Image = raylib.LoadImage("sailor.png");
    defer raylib.UnloadImage(iconImage);
    std.log.info("iconImage: {any}", .{iconImage});

    raylib.SetConfigFlags(raylib.ConfigFlags{ .FLAG_WINDOW_RESIZABLE = true });
    raylib.InitWindow(1600, 900, "Anime collection.zig");
    raylib.SetWindowIcon(iconImage);
    raylib.SetTargetFPS(144);

    while (!raylib.WindowShouldClose()) {
        raylib.BeginDrawing();
        defer raylib.EndDrawing();

        raylib.ClearBackground(settings.colors[0].background());
        raylib.DrawFPS(10, 10);
        renderSidebarMenu();

        // raylib.DrawText("hello world!", 100, 100, 20, raylib.YELLOW);
    }
}

fn renderSidebarMenu() void {
    // Calculate the position for the menu items
    var menu_item_y: i32 = 100;

    for (settings.menu_items, 0..) |item, menu_index| {
        // Determine the text color based on whether the item is selected or hovered
        var text_color: raylib.Color = undefined;

        if (raylib.IsMouseButtonPressed(raylib.MouseButton.MOUSE_BUTTON_RIGHT)) {
            settings.is_dark_mode = !settings.is_dark_mode;
        }
        // Check if the mouse cursor is over the menu item
        if (raylib.CheckCollisionPointRec(raylib.GetMousePosition(), raylib.Rectangle{
            .x = 0,
            .y = @floatFromInt(menu_item_y),
            .width = menu_width,
            .height = 20,
        })) {
            text_color = settings.colors[0].hover(); // Change the text color when hovered

            // Check if the left mouse button was clicked
            if (raylib.IsMouseButtonPressed(raylib.MouseButton.MOUSE_BUTTON_LEFT)) {
                // Handle the click event here for the current menu item
                // You can use the `menu_index` variable to identify which item was clicked
                // For example:
                std.log.info("Clicked on menu item {d}", .{menu_index});
                selected_index = menu_index;
            }
        } else if (selected_index == menu_index) {
            text_color = settings.colors[0].selected(); // Change the text color when selected
        } else {
            text_color = settings.colors[0].text(); // Default text color
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

    const row = try stmt.oneAlloc(
        struct {
            id: usize,
            title: []const u8,
            genre: []const u8,
        },
        allocator,
        .{},
        .{},
    );

    if (row) |row_value| {
        std.log.info("row2_value.id: {any}", .{row_value.id});
        std.log.info("row2_value.title: {s}", .{row_value.title});
        std.log.info("row2_value.genre: {s}", .{row_value.genre});
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
