## Summary

<!-- What does this PR do, and why? -->

## Related issues

<!-- e.g. Closes #123 -->

## Checklist

- [ ] PR title follows [Conventional Commits](https://www.conventionalcommits.org) (`type(scope): description`).
- [ ] `dart format .` reports no changes.
- [ ] `dart analyze` is clean.
- [ ] `dart test -x live` passes.
- [ ] Regenerated `*.g.dart` files (`dart run build_runner build --delete-conflicting-outputs`) if any `@JsonSerializable` model changed.
- [ ] Documentation / `CHANGELOG.md` updated if user-facing behavior changed.
- [ ] No secrets, credentials, or real account data are included in the diff.
