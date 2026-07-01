# Changelog

## [0.3.5](https://github.com/leandrocp/req_embed/compare/v0.3.4...v0.3.5) (2026-07-01)


### Features

* update oembed providers ([#76](https://github.com/leandrocp/req_embed/issues/76)) ([2a393f3](https://github.com/leandrocp/req_embed/commit/2a393f3dbc65a3efc7ca61c9762ad312b6fce706))


### Bug Fixes

* respect discover: false ([e23ab1f](https://github.com/leandrocp/req_embed/commit/e23ab1f34f6ee379e26102c3d846d521c46e4c55))


### Documentation

* content security policy ([#75](https://github.com/leandrocp/req_embed/issues/75)) ([bdbfd7a](https://github.com/leandrocp/req_embed/commit/bdbfd7ad85f2efaf42b33a4b49c9a3a5f76b4f53))

## 0.3.4 - 2026-01-13

### Changed
- Update CodePen test expectations to match current oEmbed API response with `allowfullscreen` and `allowpaymentrequest` attributes
- Update providers: boxofficebuz, appforcestudio, satoplayer, clueso, programmingly, juntos, tella

## 0.3.3 - 2025-10-09

### Added
- Add usage-rules.md for LLMs

## 0.3.2 - 2025-09-30

### Added
- Added providers: Audius, ElevenLabs, GOOD FOR JOB.

## 0.3.1 - 2025-08-13

### Changed
- Add https://elixircasts.io/reqembed in documentation
- Improve documentation in overall

## 0.3.0 - 2025-08-12

### Added
- Add providers Beta QuellenSuche, Carbon, Everwall, Filestage, Form-Data, GW2 Fashions, Kubit, Naver Clip, QuellenSuche, SOOP, 

### Changed
- **Breaking:** Remove provider afreecaTV
- **Breaking:** Require minimum Elixir 1.15
- Update providers: Medienarchiv, Supercut, Webcrumbs

## 0.2.3 - 2025-05-30

### Added
- Ignite provider support
- marimo provider support

### Fixed
- Compilation error on Elixir 1.18.14 and OTP 28

## 0.2.2 - 2025-04-24

### Fixed
- Installation without `:phoenix_live_view` dependency

## 0.2.1 - 2025-03-19

### Changed
- Repository link

## 0.2.0 - 2025-03-19

### Added
- `html/2` function to display oEmbed content as raw HTML
- `embed/1` Phoenix component to display oEmbed content in HEEx templates

## 0.1.2 - 2025-03-13

### Removed
- `ReqEmbed.Content` module in favor of `ReqEmbed.Link`

## 0.1.1 - 2025-03-12

### Added
- `:discover` option to turn discovery on/off

## 0.1.0 - 2025-03-12

### Added
- Initial release with basic oEmbed functionality
