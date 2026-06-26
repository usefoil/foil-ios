# T001 Scout - ShellCheck Hosted CI Feasibility

## Current Shell Surface

The repo currently has one tracked shell script:

```text
./scripts/ios-simulator-sanity.sh
```

`Repo hygiene ratchet` already runs `bash -n scripts/ios-simulator-sanity.sh`
inside the required `iOS Simulator Sanity (non-physical)` workflow.

## Local Prototype

Local ShellCheck:

```text
/opt/homebrew/bin/shellcheck
ShellCheck - shell script analysis tool
version: 0.11.0
```

Prototype command:

```sh
shellcheck scripts/ios-simulator-sanity.sh
```

Result: pass, no diagnostics.

## Hosted Runner Evidence

Official `actions/runner-images` documentation for `macos-15` lists the current
image as `20260622.0255.1`. The installed software list includes Homebrew and
SwiftLint, but does not list ShellCheck under utilities, tools, or linters:

- https://github.com/actions/runner-images/blob/main/images/macos/macos-15-Readme.md

That means relying on preinstalled `shellcheck` would be an unproven dependency.
Using `brew install shellcheck` would also be version-floating unless the formula
is pinned separately.

## Pinned Release Option

ShellCheck v0.11.0 has official Darwin release archives for both architectures:

```text
shellcheck-v0.11.0.darwin.aarch64.tar.xz
shellcheck-v0.11.0.darwin.x86_64.tar.xz
```

Source:

```sh
gh api repos/koalaman/shellcheck/releases/tags/v0.11.0
```

Downloaded archive SHA-256 values:

```text
56affdd8de5527894dca6dc3d7e0a99a873b0f004d7aabc30ae407d3f48b0a79  shellcheck-v0.11.0.darwin.aarch64.tar.xz
3c89db4edcab7cf1c27bff178882e0f6f27f7afdf54e859fa041fca10febe4c6  shellcheck-v0.11.0.darwin.x86_64.tar.xz
```

Archive layout:

```text
shellcheck-v0.11.0/LICENSE.txt
shellcheck-v0.11.0/README.txt
shellcheck-v0.11.0/shellcheck
```

Local dry-run of the exact install pattern passed:

```sh
curl -fsSL \
  "https://github.com/koalaman/shellcheck/releases/download/v0.11.0/shellcheck-v0.11.0.darwin.${asset_arch}.tar.xz" \
  -o "$archive"
echo "$expected_sha  $archive" | shasum -a 256 -c -
tar -xJf "$archive" -C "$install_dir" --strip-components 1
"$install_dir/shellcheck" --version
"$install_dir/shellcheck" scripts/ios-simulator-sanity.sh
```

Result: SHA check passed, ShellCheck reported version 0.11.0, and the repo script
linted cleanly.

## Recommendation

Required ShellCheck is honest if implemented as a pinned release download inside
the existing `Repo hygiene ratchet` job:

- version-pinned to `0.11.0`;
- SHA-pinned for both `arm64` and `x86_64` Darwin runners;
- architecture-selected via `uname -m`;
- added to `GITHUB_PATH` from `RUNNER_TEMP`;
- followed by a `shellcheck scripts/ios-simulator-sanity.sh` step.

Do not use unpinned Homebrew or assume the hosted image already has ShellCheck.

