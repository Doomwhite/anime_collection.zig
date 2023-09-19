// const raylib = @import("raylib");
// const Image = raylib.Image;
//
// extern const is_dark_mode: bool;

// pub const ColorTheme = struct {
//     title: []const u8, // The text to display for the menu item
//     dm_text_color: ?raylib.Color,
//     lm_text_color: ?raylib.Color,
//     dm_background_color: ?raylib.Color,
//     lm_background_color: ?raylib.Color,
//     dm_hover_color: ?raylib.Color,
//     lm_hover_color: ?raylib.Color,
//     dm_selected_color: ?raylib.Color,
//     lm_selected_color: ?raylib.Color,
//
//     pub fn text(self: ColorTheme) raylib.Color {
//         if (is_dark_mode) {
//             return self.dm_text_color orelse raylib.WHITE;
//         } else {
//             return self.lm_text_color orelse raylib.WHITE;
//         }
//     }
//
//     pub fn background(self: ColorTheme) raylib.Color {
//         if (is_dark_mode) {
//             return self.dm_background_color orelse raylib.WHITE;
//         } else {
//             return self.lm_background_color orelse raylib.WHITE;
//         }
//     }
//
//     pub fn hover(self: ColorTheme) raylib.Color {
//         if (is_dark_mode) {
//             return self.dm_hover_color orelse raylib.WHITE;
//         } else {
//             return self.lm_hover_color orelse raylib.WHITE;
//         }
//     }
//
//     pub fn selected(self: ColorTheme) raylib.Color {
//         if (is_dark_mode) {
//             return self.dm_selected_color orelse raylib.WHITE;
//         } else {
//             return self.lm_selected_color orelse raylib.WHITE;
//         }
//     }
// };
