# Makefile Template Synchronization Design

## Goal

Synchronize the current uncommitted sibling change from
`../Algorithm-Competitive-Codes/Templates/initialization_misc/makefile` into
the Typst codebook repository.

## Scope

- Replace `Templates/initialization_misc/makefile` byte-for-byte with the
  sibling template.
- Preserve `Templates/initialization_misc/main.typ`; it already has one
  deliberate `#raw(read("makefile"), lang: "makefile", block: true)` entry.
- Do not import `../Algorithm-Competitive-Codes/Environment/makefile`, because
  the target repository has no corresponding Environment subsystem.
- Regenerate README statistics after the Makefile grows from 2 to 11 lines.

## Behavior

The synchronized Makefile provides two pattern targets:

- `%: %.cpp` builds an optimized C++20 executable with common warnings and
  debug symbols.
- `%-asan: %.cpp` builds a C++20 AddressSanitizer/UndefinedBehaviorSanitizer
  executable with additional diagnostic and stack-protection flags.

## Validation

1. Compare source and target Makefiles byte-for-byte.
2. Use temporary `/tmp` source files and `make -n` to verify command expansion
   for both the ordinary and `-asan` pattern targets without producing a
   binary.
3. Compile both `codebook/wide/main.typ` and `codebook/compact/main.typ`.
4. Run `Generator.py`, repeat both Typst builds, and confirm the final Git
   worktree contains only planned committed changes.

