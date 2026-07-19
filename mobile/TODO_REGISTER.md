# TODO - Register Screen Implementation (design/register)

- [ ] Update `mobile/lib/features/auth/presentation/screens/register_screen.dart` to match `design/register/code.html`.
  - [ ] Reuse AuthScaffold + Login’s hero/paper background composition (no network image).
  - [ ] Add desktop-only left/right decorative elements.
  - [ ] Implement full registration form UI: full name, email, password, confirm password, checkbox text.
  - [ ] Implement password field UI with visibility toggle already handled by AuthPasswordInput; ensure matches HTML.
  - [ ] Add social login section if present in HTML (or confirm it is not).
  - [ ] Match footer/dividers/typography.
  - [ ] Implement hover/focus/active states consistent with HTML.
- [ ] Run `flutter analyze`.
- [ ] Run `flutter test`.
- [ ] `flutter run` and visually compare with `design/register/screen.png`.

