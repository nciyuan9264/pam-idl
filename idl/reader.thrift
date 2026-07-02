namespace go reader
namespace js reader

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

service ReaderService {
  ListBooksResp ListBooks(1: ListBooksReq req) (
    api.get = "/reader/list",
    api.operation_id = "listBooks",
    api.summary = "获取当前用户的图书列表",
    api.auth_required = "true"
  )

  BookResp CreateBook(1: required CreateBookReq req) (
    api.post = "/reader/create",
    api.operation_id = "createBook",
    api.summary = "创建图书记录",
    api.auth_required = "true",
    api.content_type = "application/json"
  )

  BookResp UpdateBook(1: required UpdateBookReq req) (
    api.post = "/reader/update",
    api.operation_id = "updateBook",
    api.summary = "更新图书记录",
    api.auth_required = "true",
    api.content_type = "application/json"
  )

  BaseResp DeleteBook(1: DeleteBookReq req) (
    api.post = "/reader/delete",
    api.operation_id = "deleteBook",
    api.summary = "删除图书记录",
    api.auth_required = "true"
  )
}
