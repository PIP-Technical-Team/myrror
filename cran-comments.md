## CRAN submission notes — first release

Package: myrror
Version: 0.1.0 
Maintainer: R.Andres Castaneda <acastanedaa@worldbank.org>

This file documents the checks, environments and special notes relevant to the
first CRAN submission of `myrror` (tools for comparing data frames).


Checks performed during development:

- `devtools::document()`
- `devtools::check()` (local: 0 errors | 0 warnings | 0 NOTES)
- `covr::package_coverage()` (development coverage > 80%)
- `spelling::spell_check_package()`
- `urlchecker::url_check()`
- `rcmdcheck::rcmdcheck(args = c("--as-cran"))`

Environments used: local (Windows 11, R 4.5.1) and GitHub Actions (windows, macOS, ubuntu).

Notes:

- Package uses interactive console output by default; set `options(myrror.interactive = FALSE)` to disable.
- The package stores the last comparison object in `.myrror_env`; clear with `clear_last_myrror_object()`.

The NOTE is the standard message for a first-time submission and is not indicative of a package problem.
