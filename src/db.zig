const std = @import("std");
const sqlite = @import("sqlite");
const Allocator = std.mem.Allocator;

pub fn executeSQLiteScripts(db: *sqlite.Db, gpa_allocator: Allocator) !void {
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
