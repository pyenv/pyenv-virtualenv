## Version History

#### 1.2.4
* Fix failing to detect `-m venv` when "python" is not provided by the distro by @native-api in https://github.com/pyenv/pyenv-virtualenv/pull/479
* README: Remove dollar signs from commands that are meant to be copied by @galonsky in https://github.com/pyenv/pyenv-virtualenv/pull/481
* Reflect pyenv-latest switch change in 2.4.8 by @native-api in https://github.com/pyenv/pyenv-virtualenv/pull/484

#### 1.2.3
* Fix: add `colorize` helper by @silverjam in https://github.com/pyenv/pyenv-virtualenv/pull/470
* Bump pyenv-virtualenv reporting version to match release by @ushuz in https://github.com/pyenv/pyenv-virtualenv/pull/471
* Add fish prompt changing by @romirk in https://github.com/pyenv/pyenv-virtualenv/pull/475
* Don't activate if a 3rd-party venv is activated over ours by @native-api in https://github.com/pyenv/pyenv-virtualenv/pull/478

#### 1.2.2
* Prompt removal was never done and is not planned anymore by @native-api in https://github.com/pyenv/pyenv-virtualenv/pull/447
* Update PYENV_VIRTUALENV_VERSION by @jack-mcivor in https://github.com/pyenv/pyenv-virtualenv/pull/449
* Add activate/deactivate hooks by @joshfrench in https://github.com/pyenv/pyenv-virtualenv/pull/452
* More helpful error message when requesting a nonexistent base version by @MarcinKonowalczyk in https://github.com/pyenv/pyenv-virtualenv/pull/454
* Add fish install oneliner by @ElijahLynn in https://github.com/pyenv/pyenv-virtualenv/pull/322
* Link python*-config into VE by @native-api in https://github.com/pyenv/pyenv-virtualenv/pull/460

#### 1.2.1
* Support prefixes resolved by pyenv-latest as base version names by @native-api in https://github.com/pyenv/pyenv-virtualenv/pull/446

#### 1.2.0
* ~/.*rc should be modified instead of ~/.*profile by @native-api in https://github.com/pyenv/pyenv-virtualenv/pull/384
* Fixes #394 - update pyenv virtualenvs to list virtualenvs start with dot prefixes by @Gauravtalreja1 in https://github.com/pyenv/pyenv-virtualenv/pull/395
* Fix installation steps to allow for Pyenv 2 by @native-api in https://github.com/pyenv/pyenv-virtualenv/pull/388
* Fix get-pip.py URLs for older versions of Python by @jivanf in https://github.com/pyenv/pyenv-virtualenv/pull/403
* Add (y/N) prompt help text by @sh-cho in https://github.com/pyenv/pyenv-virtualenv/pull/404
* perf(sh-activate): avoid a pyenv-version-name call by @scop in https://github.com/pyenv/pyenv-virtualenv/pull/380
* Fix unbound variable errors when running `pyenv activate` with `set -u` Use default empty value. This fixes #422. by @ackalker in https://github.com/pyenv/pyenv-virtualenv/pull/423
* Fix another unbound variable error by @ackalker in https://github.com/pyenv/pyenv-virtualenv/pull/424
* Update `get-pip.py` URLs in `pyenv-virtualenv` by @mcdonnnj in https://github.com/pyenv/pyenv-virtualenv/pull/426
* Deduplicate shims in $PATH for the fish shell during initialization by @ericvw in https://github.com/pyenv/pyenv-virtualenv/pull/430
* Upgrade uninstall hook after pyenv/pyenv#2432 by @laggardkernel in https://github.com/pyenv/pyenv-virtualenv/pull/438
* Stop delete force failing when virtualenv does not exist by @eganjs in https://github.com/pyenv/pyenv-virtualenv/pull/330
* fix: relative path to pyenv-realpath.dylib by @scop in https://github.com/pyenv/pyenv-virtualenv/pull/378
* Spelling fixes by @scop in https://github.com/pyenv/pyenv-virtualenv/pull/352
* Clone bats with --depth=1, gitignore it by @scop in https://github.com/pyenv/pyenv-virtualenv/pull/351
* set -u fixes by @scop in https://github.com/pyenv/pyenv-virtualenv/pull/350
* Set up Github Actions CI by @native-api in https://github.com/pyenv/pyenv-virtualenv/pull/440
* Enhance documentation about options for `pyenv virtualenv` by @pylipp in https://github.com/pyenv/pyenv-virtualenv/pull/425
* Return control to pyenv-uninstall in uninstall/envs.bash by @aiguofer in https://github.com/pyenv/pyenv-virtualenv/pull/321
* Use realpath of scripts to determine relative locations by @andrew-christianson in https://github.com/pyenv/pyenv-virtualenv/pull/308
* Shell detect improvements by @scop in https://github.com/pyenv/pyenv-virtualenv/pull/377

#### 1.1.5

* Fix install script (#290, #302)

#### 1.1.4

* Support newer conda (#290)
* Prefer `python3.x` executable if available (#206, #282, #296)

#### 1.1.3

* No code changes since 1.1.2

#### 1.1.2

* Use custom get-pip URL based on the target version (#253, #254, #255)
* Source conda 4.4.4 shell files (#251)
* Evaluate force flag before testing if venv exists (#232)

#### 1.1.1

* Set `CONDA_PREFIX` to make is useable in conda activate/deactivate scripts (#224)
* Generate `pydoc` executable after creating new virtualenv (#197, #230)

#### 1.1.0

* fish: use "set -gx" instead of "setenv" (#215, #216, #217, #218)

#### 1.0.0

* Use similar versioning scheme as pyenv; YYYYMMDD -> X.Y.Z

#### 20160716

* Suppress activate/deactivate messages by default (#169, #170, #171)
* Source conda package activate/deactivat scripts if exist (#173)
* Use `source` in favor of `.` for `fish` (#175)
* Use `python -m venv` instead of `pyvenv` due to deprecation of `pyvenv` after 3.6 (#184, #185)

#### 20160315

* Evaluate `${PATH}` when outputted code is eval'd. (#154)
* Set proper `CONDA_DEFAULT_ENV` for shorter name (#160)

#### 20160202

* Install virtualenv 13.1.2 for CPython/Stackless 3.2.x (yyuu/pyenv#531)

#### 20160112

* Fix problem with `virtualenv` to look up executables from source version with `--system-site-packages` (#62)

#### 20151229

* Fix `deactivate` error on `fish` (#136)

#### 20151222

* Improved interoperability with Anaconda/Miniconda (#103, #106, #107, #108)
* Create `virtualenv` inside `envs` directory of source version, like Anaconda/Miniconda (#103, #107)
* Rewrite `pyenv activate` and `pyenv deactivate` without using scripts provided by virtualenv and conda (#51, #69, #103, #104, #121)
* Improve the `pyenv activate` behaviour on multiple versions (#105, #111)
* Reject creating a virtualenv named `system` (yyuu/pyenv#475)
* Add `--skip-aliases` to `pyenv virtualenvs` (#120)
* Stop showing `version not installed` warning messages in precmd (#49)

#### 20151103

* Passing return value from executed command. (#100)
* Add workaround for commands installed in a virtual environment created by `pyvenv` (#62)
* init: zsh: prepend hook to `precmd_functions` (#101)

#### 20151006

* Ignore user's site-packages on ensurepip/get-pip (#89)
* Find `python-config` from source version if current version is a virtualenv
* Fix pyenv-virtualenv-init script for fish where command was in string and not being evaluated (#98)
* Add foolproof for `-p` argument. (yyuu/pyenv#98)

#### 20150719

* Add support for `conda` environments created by Anaconda/Miniconda (#91)
* Look up commands for original version as well if the environment is created with `--system-site-packages` (#62)
* Add error message if the source version is not installed (#83)

#### 20150526

* Use `typeset -g` with `precmd_functions` (#75)
* activate: display setup instructions only with `PYENV_VIRTUALENV_INIT=0` (#78)
* Ignore failure of pyenv activate (#68)

#### 20150119

 * Ignore errors from `pyenv-version-name` since it might fail if there is configuration error (yyuu/pyenv#291)
 * The _shell_ version set in `activate` should be unset in `deactivate` (#61)
 * Anaconda has `activate` script nevertheless it is not a virtual environment (#65)

#### 20141106

 * Stop creating after `ensurepip` since it has done by `ensurepip` itself
 * Suppress some useless warnings from `pyenv virtualenv-init`

#### 20141012

 * Fix warnings from `shellcheck` to improve support for POSIX sh (#40)
 * Do not allow whitespace in `VIRTUALENV_NAME` (#44)
 * Should not persist `PYENV_DEACTIVATE` after automatic deactivation (#47, #48)

#### 20140705

 * Display information on auto-(de)?activation
 * Support manual (de)?activation with auto-activation enabled (#32, #34)
 * Exit as error when (de)?activation failed
 * Use https://bootstrap.pypa.io/ to install setuptools and pip
 * Create backup of original virtualenv within `$(pyenv root)/versions` when `--upgrade`

#### 20140615

 * Fix incompatibility issue of `pyenv activate` and `pyenv deactivate` (#26)
 * Workaround for the issue with pyenv-which-ext (#26)

#### 20140614

 * Add `pyenv virtualenv-init` to enable auto-activation feature (#24)
 * Create symlinks for executables with version suffix (yyuu/pyenv#182)

#### 20140602

 * Use new style GH raw url to avoid redirects (raw.github.com -> raw.githubusercontent.com)
 * Repaired virtualenv activation and deactivation for the fish shell (#23)

#### 20140421

 * Display error if `pyenv activate` was invoked as a command
 * Fix completion of `pyenv activate` (#15)
 * Use `virtualenv` instead of `pyvenv` if `-p` has given (yyuu/pyenv#158)

#### 20140123

 * Add `activate` and `deactivate` to make `pyenv-virtualenv` work with [jedi](https://github.com/davidhalter/jedi) (#9)
 * Use `ensurepip` to install `pip` if it is available
 * Unset `PIP_REQUIRE_VENV` to avoid problem on the installation of `virtualenv` (#10)
 * Add tests

#### 20140110.1

 * Fix install script

#### 20140110

 * Support environment variables of `EZ_SETUP` and `GET_PIP`.
 * Support a short option `-p` of `virtualenv`.

#### 20131216

 * Use latest release of setuptools and pip if the version not given via environment variables.

#### 20130622

 * Removed bundled `virtualenv.py` script. Now pyenv-virtualenv installs `virtualenv` package into source version and then use it.
 * On Python 3.3+, use `pyvenv` as virtualenv command if `virtualenv` is not available.
 * Install setuptools and pip into environments created by `pyvenv`.

#### 20130614

 * Add `pyenv virtualenvs` to list all virtualenv versions.
 * *EXPERIMENTAL*: Add `--upgrade` option to re-create virtualenv with migrating packages

#### 20130527

 * Remove `python-virtualenv` which was no longer used.
 * Change the installation path of the `virtualenv.py` script. (`./libexec` -> `./libexec/pyenv-virtualenv/${VIRTUALENV_VERSION}`)
 * Download `virtualenv.py` if desired version has not been installed.

#### 20130507

 * Display virtualenv information in `--help` and `--version`
 * Update virtualenv version; 1.8.4 -> 1.9.1

#### 20130307

 * Rename the project; `s/python-virtualenv/pyenv-virtualenv/g`
 * The `pyenv-virtualenv` script is not depending on `python-virtualenv` now.
   `python-virtualenv` will left for compatibility and will not continue for future releases.
 * Update virtualenv version; 1.8.2 -> 1.8.4

#### 20130218

 * Add pyenv 0.2.x (rbenv 0.4.x) style help messages.

#### 20121023

 * Create virtualenv with exact name of python executables.
 * Changed command-line options of python-virtualenv.
   First argument should be a path to the python executable.
 * Add install script.

#### 20120927

 * Initial public release.

