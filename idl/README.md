# PAM IDL layout

`manifest.json` is the source of truth for service entrypoints. Every service
owns one versioned directory and exposes exactly one `service.thrift`.

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
- Internal RPC methods use `api.internal = "true"` and must not define a public
  HTTP route.

Run all IDL and generated-code checks with:

```bash
../../pam-clients/scripts/generate.sh
```
