const std = @import("std");
const sqlite = @import("sqlite");
const raylib = @import("raylib");
const Image = raylib.Image;
const Allocator = std.mem.Allocator;

const settings = @import("settings.zig");
const ColorTheme = settings.ColorTheme;
const menu_width = settings.menu_width;
const MenuItem = settings.MenuItem;
const MenuItemType = settings.MenuItemType;

const db = @import("db.zig");

var selected_index: usize = 0;
var haha: ?[]const MenuItem = null;

pub fn main() !void {
    // var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    // defer if (gpa.deinit() == .leak) @panic("found memory leaks");
    // const allocator: Allocator = gpa.allocator();

    try settings.init_globals();
    // defer settings.current_menu.deinit();

    // var db = try sqlite.Db.init(.{
    //     .mode = sqlite.Db.Mode{ .File = "/database.db" },
    //     .open_flags = .{
    //         .write = true,
    //         .create = true,
    //     },
    //     .threading_mode = .MultiThread,
    // });
    // defer db.deinit();
    //
    // try db.executeSQLiteScripts(&db, allocator);

    defer raylib.CloseWindow();

    const iconImage: Image = raylib.LoadImage("sailor.png");
    defer raylib.UnloadImage(iconImage);
    std.log.info("iconImage: {any}", .{iconImage});

    raylib.SetConfigFlags(raylib.ConfigFlags{ .FLAG_WINDOW_RESIZABLE = true });
    raylib.InitWindow(600, 600, "Anime collection.zig");
    raylib.SetWindowIcon(iconImage);
    raylib.SetTargetFPS(144);

    while (!raylib.WindowShouldClose()) {
        raylib.BeginDrawing();
        defer raylib.EndDrawing();

        raylib.ClearBackground(settings.colors[settings.selected_theme_index].background());
        raylib.DrawFPS(10, 10);
        if (raylib.IsMouseButtonPressed(raylib.MouseButton.MOUSE_BUTTON_RIGHT)) {
            // var current_menu = settings.current_menu;
            // settings.current_menu = settings.previous_menu;
            // settings.previous_menu = current_menu;
        }
        // renderSidebarMenu();
        var menu_item_y: i32 = 100;

        for (settings.current_menu, 0..) |item, menu_index| {
            // Determine the text color based on whether the item is selected or hovered
            var text_color: raylib.Color = undefined;

            // std.log.info("menu_item_y: {any}", .{menu_item_y});
            // Check if the mouse cursor is over the menu item
            if (cursorInColission(menu_item_y)) {
                text_color = settings.colors[settings.selected_theme_index].hover(); // Change the text color when hovered
                if (raylib.IsMouseButtonPressed(raylib.MouseButton.MOUSE_BUTTON_LEFT)) {
                    switch (item.type) {
                        .Nothing => {},
                        .Settings => {
                            if (item.items) |children_items| {
                                settings.previous_menu = settings.current_menu;
                                settings.current_menu = children_items;
                                break;
                            }
                        },
                        .ChangeTheme => {
                            settings.changeTheme();
                        },
                        .Return => {
                            var current_menu = settings.current_menu;
                            settings.current_menu = settings.previous_menu;
                            settings.previous_menu = current_menu;
                            break;
                        },
                    }
                    selected_index = menu_index;
                    // if (item.items) |item_children| {
                    //     // settings.current_menu = item_children.items;
                    //     haha = item_children;
                    // }
                }
            } else if (selected_index == menu_index) {
                text_color = settings.colors[settings.selected_theme_index].selected(); // Change the text color when selected
            } else {
                text_color = settings.colors[settings.selected_theme_index].text(); // Default text color
            }

            // Draw the menu item text
            raylib.DrawText(item.title, 10, menu_item_y, 20, text_color);

            // Increase the Y position for the next menu item
            menu_item_y += settings.menu_item_height;
        }

        // raylib.DrawText("hello world!", 100, 100, 20, raylib.YELLOW);
    }
}

fn cursorInColission(menu_item_y: i32) bool {
    return raylib.CheckCollisionPointRec(raylib.GetMousePosition(), raylib.Rectangle{
        .x = 0,
        .y = @floatFromInt(menu_item_y),
        .width = menu_width,
        .height = 20,
    });
}

// fn renderSidebarMenu() void {
//     // Calculate the position for the menu items
//     var menu_item_y: i32 = 100;
//
//     for (settings.current_menu, 0..) |item, menu_index| {
//         // Determine the text color based on whether the item is selected or hovered
//         var text_color: raylib.Color = undefined;
//
//         // Check if the mouse cursor is over the menu item
//         if (raylib.CheckCollisionPointRec(raylib.GetMousePosition(), raylib.Rectangle{
//             .x = 0,
//             .y = @floatFromInt(menu_item_y),
//             .width = menu_width,
//             .height = 20,
//         })) {
//             text_color = settings.colors[settings.selected_theme_index].hover(); // Change the text color when hovered
//
//             // Check if the left mouse button was clicked
//             if (raylib.IsMouseButtonPressed(raylib.MouseButton.MOUSE_BUTTON_LEFT)) {
//                 // Handle the click event here for the current menu item
//                 // You can use the `menu_index` variable to identify which item was clicked
//                 // For example:
//                 std.log.info("Clicked on menu item {d}", .{menu_index});
//                 selected_index = menu_index;
//                 std.log.info("item: {any}", .{item});
//                 if (item.items) |item_children| {
//                     // settings.current_menu = item_children.items;
//                     haha = item_children;
//                 }
//             }
//         } else if (selected_index == menu_index) {
//             text_color = settings.colors[settings.selected_theme_index].selected(); // Change the text color when selected
//         } else {
//             text_color = settings.colors[settings.selected_theme_index].text(); // Default text color
//         }
//
//         // Draw the menu item text
//         raylib.DrawText(item.title, 10, menu_item_y, 20, text_color);
//
//         // Increase the Y position for the next menu item
//         menu_item_y += 30;
//     }
// }
