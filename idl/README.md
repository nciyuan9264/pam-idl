# PAM IDL layout

Every service owns one versioned directory and exposes exactly one
`service.thrift`. PAM discovers service entrypoints recursively and reads
service metadata from Thrift service annotations. There is no central service
manifest.

PSMs must contain exactly three lower-case segments:
`<domain>.<service>.<role>`. Public RPC services use `rpc`; a specialized
control-plane service may use `control`. Examples are `pam.auth.rpc`,
`pam.platform.rpc`, and `game.platform.control`. Branches, versions, and
environment names must not be encoded into the PSM.

Every RPC service owns one independent Go client repository. The service
annotation stores its immutable identity and generation target:

```thrift
service AuthService {
  // RPC methods...
} (
  pam.schema_version = "1",
  pam.psm = "pam.auth.rpc",
  pam.description = "Authentication RPC and HTTP contract",
  pam.client.go.module = "github.com/nciyuan9264/pam-auth-client",
  pam.client.go.repository = "nciyuan9264/pam-auth-client",
  pam.client.go.base_ref = "main"
)
```

The service name and Go namespace come from native Thrift declarations. The
IDL path and major version come from the versioned directory. PAM annotations
contain only metadata that Thrift cannot otherwise express.

`pam.client.go.module` and `pam.client.go.repository` must be unique across services.
PAM Client Builder creates a missing GitHub repository, initializes its base
branch with a matching `go.mod`, and then generates only that service and its
transitive Thrift includes. Existing repositories must keep the same module
path declared by the service annotation.

```text
<service>/v1/
├── service.thrift  # includes plus the service definition
└── types.thrift    # service-owned structs, enums, unions and exceptions
```

Shared types live at the nearest common ownership boundary. For example,
`games/common/v1` is shared by game services but is not a platform-wide API.

## Versioning

- Git commit SHA identifies every immutable contract snapshot.
- `v1`, `v2`, and similar directories are only for incompatible wire or source
  changes, not routine releases.
- Never change or reuse an existing field ID.
- Add evolvable response fields as `optional`; adding a new `required` field is
  incompatible with old clients.
- Keep a removed field ID documented and unused.

## Includes and namespaces

- Include service-local files with a relative path such as `types.thrift`.
- Include domain-shared files from their owning directory.
- Do not include another service's private `types.thrift`.
- Keep includes acyclic.
- Go namespaces mirror the ownership path, for example
  `pam.games.acquire.v1`. Kitex uses the namespace to determine the generated
  package path.

## HTTP exposure

- Public routes must be globally unique within one gateway environment.
- Game routes use `/api/<game>/...`.
- Every service method must declare at least one argument. Kitex
  `HTTPThriftGeneric` rejects zero-argument functions; use the domain's
  `EmptyReq` for routes without request fields.
- Internal RPC methods use `api.internal = "true"` and must not define a public
  HTTP route.

Validate the complete IDL repository with:

```bash
node scripts/validate.js
```
