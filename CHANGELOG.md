# Changelog

## Unreleased

## [0.3.10](https://github.com/leandrocp/req_embed/compare/v0.3.9...v0.3.10) (2026-08-29)

### Changed

- Include changed provider names in automated update pull requests and commits
- Group dependency updates into one pull request per ecosystem

### Features

- Update providers: Slidesfly, Tegula, u-poll by @leandrocp in [#93](https://github.com/leandrocp/req_embed/pull/93)
- Update providers: Castle, Mirame360 by @leandrocp in [#97](https://github.com/leandrocp/req_embed/pull/97)
- Update providers: EveryPage, Keystone Practice, Scibly, Tegula, amCharts, amCharts Live Editor by @leandrocp in [#98](https://github.com/leandrocp/req_embed/pull/98)

## [0.3.9](https://github.com/leandrocp/req_embed/compare/v0.3.8...v0.3.9) (2026-07-30)


### Features

* update providers: KakaoTv, Pyzia, Skhema, Subscribi, World Event Trading ([#84](https://github.com/leandrocp/req_embed/issues/84)) ([2984828](https://github.com/leandrocp/req_embed/commit/2984828eb3a25655372ee440f439dd9bff59f8da))
* update providers: ChanceIndex, Clipform, Coloring Monster ([#86](https://github.com/leandrocp/req_embed/issues/86)) ([02a3e06](https://github.com/leandrocp/req_embed/commit/02a3e069ba1e17a5bb4961f9511d37a075e8e74d))
* update providers: FrameRate, StemFM, Typecel, d.calculators ([#89](https://github.com/leandrocp/req_embed/issues/89)) ([1aceee8](https://github.com/leandrocp/req_embed/commit/1aceee83982ca66766b9f3c26a5fa7fc045e730a))
* update providers: Atlantis Data Solutions ([#92](https://github.com/leandrocp/req_embed/issues/92)) ([a622410](https://github.com/leandrocp/req_embed/commit/a622410596ecf629a10b32e84388a4c72b009865))

## [0.3.8](https://github.com/leandrocp/req_embed/compare/v0.3.7...v0.3.8) (2026-07-16)


### Features

* update oembed providers ([#81](https://github.com/leandrocp/req_embed/issues/81)) ([2094ce9](https://github.com/leandrocp/req_embed/commit/2094ce9e470398e9255e45ec2ab4220eb0267166))

## [0.3.7](https://github.com/leandrocp/req_embed/compare/v0.3.6...v0.3.7) (2026-07-08)


### Features

* update oembed providers ([#79](https://github.com/leandrocp/req_embed/issues/79)) ([d4fe0aa](https://github.com/leandrocp/req_embed/commit/d4fe0aa9bec15a45d7dc8a63d6ad0f0ce373cbaf))

## [0.3.6](https://github.com/leandrocp/req_embed/compare/v0.3.5...v0.3.6) (2026-07-08)


### Features

* support extra response fields ([#77](https://github.com/leandrocp/req_embed/issues/77)) ([c9de614](https://github.com/leandrocp/req_embed/commit/c9de6148b65237ec4d8725703743f3251631fa80))

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
