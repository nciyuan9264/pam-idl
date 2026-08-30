# PAM IDL layout

`manifest.json` is the source of truth for service entrypoints. Every service
owns one versioned directory and exposes exactly one `service.thrift`.
The Thrift service name is derived from the single `service` declaration in
that entrypoint and must not be duplicated in the schema version 4 manifest.
Every service declares a globally unique logical `psm`, which is the manifest
identity used for versioning and build association. Runtime
environments are kept separate by service discovery and are not part of the
PSM itself.

PSMs must contain exactly three lower-case segments:
`<domain>.<service>.<role>`. Public RPC services use `rpc`; a specialized
control-plane service may use `control`. Examples are `pam.auth.rpc`,
`pam.platform.rpc`, and `game.platform.control`. Branches, versions, and
environment names must not be encoded into the PSM.

Every RPC service owns one independent Go client repository. The manifest
stores the immutable generation target:

```json
{
  "psm": "pam.auth.rpc",
  "idl": "idl/auth/v1/service.thrift",
  "goClient": {
    "module": "github.com/nciyuan9264/pam-auth-client",
    "repository": "nciyuan9264/pam-auth-client",
    "baseRef": "main"
  }
}
```

`goClient.module` and `goClient.repository` must be unique across services.
PAM Client Builder creates a missing GitHub repository, initializes its base
branch with a matching `go.mod`, and then generates only that service and its
transitive Thrift includes. Existing repositories must keep the same module
path declared by the manifest.

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
