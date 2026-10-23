# Expands versions.json into the list of images to build:
# [{ tag, dockerfile, args, aliases }], shared by the CI workflow and build-and-push.sh
.aliases as $aliases
| [
    (.node[] as $node | .variants[] as $variant | {
      tag: "\($node)-\($variant)",
      dockerfile: "Dockerfile",
      args: "NODE_TAG=\(if $node == "latest" then $variant else "\($node)-\($variant)" end)"
    }),
    (.hardened[] | {
      tag: "\(.)-hardened",
      dockerfile: "Dockerfile.hardened",
      args: "NODE_VERSION=\(.)"
    }),
    (.bun | to_entries[] | {
      tag: .key,
      dockerfile: "Dockerfile.bun",
      args: "BUN_TAG=\(.value)"
    })
  ]
| map(. + { aliases: ($aliases[.tag] // []) })
