## Resubmission (Second)
Package: myrror
Version: 0.1.1
Maintainer: R.Andres Castaneda <acastanedaa@worldbank.org>

**Second resubmission note:** Fixed `\dontrun{}` issue in `print.myrror.Rd`. The problem was that after editing the source file (`R/print.R`), we failed to run `devtools::document()` to regenerate the `.Rd` file. This has now been corrected - `\dontrun{}` is replaced with `\donttest{}` in both the source and the generated documentation.

Additionally, `pair_columns()` — which had been temporarily exported to assist with example testing — has been converted back to an internal helper. Examples that previously relied on `pair_columns()` were modified to use exported wrappers or to demonstrate the same workflows using public functions, so no examples call unexported helpers directly.

---

**First resubmission - addressed all initial CRAN reviewer comments:**

1. **References in DESCRIPTION**: No methodological references exist for this package, as it provides practical tools for data frame comparison rather than implementing novel statistical methods.

2. **Missing `\value` documentation**: Added `\value` tag to `print.myrror.Rd` explaining that the function invisibly returns the myrror object and is called for side effects.

3. **Examples for unexported functions**: 
 - Exported `create_myrror_object()` and `pair_columns()` with runnable examples
 - Kept `prepare_df()` internal and removed its examples (no longer referenced in other .Rd files

4. **Commented-out examples**: Uncommented all examples in `create_myrror_object.Rd`, `pair_columns.Rd`. Examples in `iris_var1.Rd` were already documentation-only (no commented code). All examples now run successfully.

5. **`\dontrun{}` usage**: Replaced `\dontrun{}` with `\donttest{}` in `print.myrror.Rd` examples as they are executable but may take slightly longer in interactive mode.

All changes have been tested with `devtools::check()` and produce 0 errors, 0 warnings, 0 notes.

---

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
