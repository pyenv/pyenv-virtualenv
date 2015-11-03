## Version History

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

