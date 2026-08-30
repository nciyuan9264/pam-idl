namespace go pam.reader.v1
namespace js pam.reader.v1

include "types.thrift"

service ReaderService {
  types.ListBooksResp ListBooks(1: types.ListBooksReq req) (
    api.get = "/reader/list",
    api.operation_id = "listBooks",
    api.summary = "获取当前用户的图书列表",
    api.auth_required = "true"
  )

  types.BookResp CreateBook(1: required types.CreateBookReq req) (
    api.post = "/reader/create",
    api.operation_id = "createBook",
    api.summary = "创建图书记录",
    api.auth_required = "true",
    api.content_type = "application/json"
  )

  types.BookResp UpdateBook(1: required types.UpdateBookReq req) (
    api.post = "/reader/update",
    api.operation_id = "updateBook",
    api.summary = "更新图书记录",
    api.auth_required = "true",
    api.content_type = "application/json"
  )

  types.BaseResp DeleteBook(1: types.DeleteBookReq req) (
    api.post = "/reader/delete",
    api.operation_id = "deleteBook",
    api.summary = "删除图书记录",
    api.auth_required = "true"
  )
} (
  pam.schema_version = "1",
  pam.psm = "pam.reader.rpc",
  pam.description = "阅读器图书管理 HTTP API IDL",
  pam.client.go.module = "github.com/nciyuan9264/pam-reader-client",
  pam.client.go.repository = "nciyuan9264/pam-reader-client",
  pam.client.go.base_ref = "main"
)
