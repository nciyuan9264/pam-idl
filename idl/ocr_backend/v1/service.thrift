namespace go pam.ocr.v1
namespace js pam.ocr.v1

include "types.thrift"

service OCRBackendService {
  types.ArkChatCompletionResp OCR(1: required types.OCRReq req) (
    api.post = "/ai/ocr",
    api.operation_id = "ocr",
    api.summary = "图片 OCR 识别",
    api.content_type = "application/json"
  )

  types.ArkImageGenerationResp GenerateImage(1: required types.GenerateImageReq req) (
    api.post = "/ai/generate",
    api.operation_id = "generateImage",
    api.summary = "根据提示词生成图片",
    api.content_type = "application/json"
  )

  types.ArkChatCompletionResp Chat(1: required types.ChatReq req) (
    api.post = "/ai/chat",
    api.operation_id = "chat",
    api.summary = "文本对话生成",
    api.content_type = "application/json"
  )
} (
  pam.schema_version = "1",
  pam.psm = "pam.ocr.rpc",
  pam.description = "OCR Backend 火山方舟 HTTP API IDL",
  pam.client.go.module = "github.com/nciyuan9264/pam-ocr-client",
  pam.client.go.repository = "nciyuan9264/pam-ocr-client",
  pam.client.go.base_ref = "main"
)
