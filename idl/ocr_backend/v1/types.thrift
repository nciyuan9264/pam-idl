namespace go pam.ocr.v1
namespace js pam.ocr.v1

struct ErrorResp {
  1: required string error,
  2: optional string details,
  3: optional string hint,
}

struct ArkImageURL {
  1: required string url,
}

struct VisionContentPart {
  1: required string type,
  2: optional string text,
  3: optional ArkImageURL image_url,
}

struct VisionMessage {
  1: required string role,
  2: required list<VisionContentPart> content,
}

struct TextContentPart {
  1: required string type,
  2: optional string text,
}

struct ChatMessage {
  1: required string role,
  2: optional string content,
  3: optional list<TextContentPart> content_items,
}

struct OCRReq {
  1: optional string image_url,
  2: optional string image_base64,
  3: optional string text,
  4: optional string model,
  5: optional bool stream,
  6: optional list<VisionMessage> messages,
}

struct GenerateImageReq {
  1: optional string model,
  2: required string prompt,
  3: optional string size,
}

struct ChatReq {
  1: optional string text,
  2: optional string model,
  3: optional bool stream,
  4: optional list<ChatMessage> messages,
}

struct ArkUsage {
  1: optional i32 prompt_tokens,
  2: optional i32 completion_tokens,
  3: optional i32 total_tokens,
}

struct ArkChatMessage {
  1: optional string role,
  2: optional string content,
}

struct ArkChatChoice {
  1: optional i32 index,
  2: optional ArkChatMessage message,
  3: optional string finish_reason,
}

struct ArkChatCompletionResp {
  1: optional string id,
  2: optional string object,
  3: optional i64 created,
  4: optional string model,
  5: optional list<ArkChatChoice> choices,
  6: optional ArkUsage usage,
}

struct ArkGeneratedImage {
  1: optional string url,
  2: optional string b64_json,
  3: optional string revised_prompt,
}

struct ArkImageGenerationResp {
  1: optional i64 created,
  2: optional list<ArkGeneratedImage> data,
  3: optional ArkUsage usage,
}

