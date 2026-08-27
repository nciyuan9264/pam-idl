namespace go pam.reader.v1
namespace js pam.reader.v1

struct Novel {
  1: optional i64 id,
  2: optional string title,
  3: optional string main_category,
  4: optional string sub_category,
  5: optional string tags,
  6: optional bool is_read,
  7: optional i32 rating,
  8: optional string review,
}

struct CreateBookReq {
  1: required string title,
  2: optional string main_category,
  3: optional string sub_category,
  4: optional string tags,
  5: optional bool is_read,
  6: optional i32 rating,
  7: optional string review,
}

struct UpdateBookReq {
  1: required i64 id,
  2: optional string title,
  3: optional string main_category,
  4: optional string sub_category,
  5: optional string tags,
  6: optional bool is_read,
  7: optional i32 rating,
  8: optional string review,
}

struct DeleteBookReq {
  1: required i64 id (api.query = "id"),
}

struct ListBooksReq {
  1: optional i32 page (api.query = "page"),
  2: optional i32 page_size (api.query = "page_size"),
  3: optional string title (api.query = "title"),
  4: optional string main_category (api.query = "main_category"),
  5: optional bool is_read (api.query = "is_read"),
}

struct BookResp {
  1: required i32 status_code,
  2: required string message,
  3: required Novel data,
}

struct BaseResp {
  1: required i32 status_code,
  2: required string message,
}

struct ListBooksResp {
  1: required i32 status_code,
  2: required string message,
  3: required list<Novel> data,
  4: required i64 total,
  5: required i32 page,
  6: required i32 page_size,
  7: required i32 total_pages,
}

