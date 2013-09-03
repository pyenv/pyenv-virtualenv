# pyenv-virtualenv (a.k.a. [python-virtualenv](https://github.com/yyuu/python-virtualenv))

pyenv-virtualenv is a [pyenv](https://github.com/yyuu/pyenv) plugin
that provides a `pyenv virtualenv` command to create virtualenv for Python
on UNIX-like systems.

(NOTICE: If you are an existing user of [virtualenvwrapper](http://pypi.python.org/pypi/virtualenvwrapper)
and you love it, [pyenv-virtualenvwrapper](https://github.com/yyuu/pyenv-virtualenvwrapper) may help you
to manage your virtualenvs.)

## Installation

### Installing as a pyenv plugin

Installing pyenv-virtualenv as a pyenv plugin will give you access to the
`pyenv virtualenv` command.

    $ git clone git://github.com/yyuu/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv

This will install the latest development version of pyenv-virtualenv into
the `~/.pyenv/plugins/pyenv-virtualenv` directory. 
**Important note:**  If you installed pyenv into a non-standard directory, make sure that you clone this
repo into the 'plugins' directory of wherever you installed into.

From inside that directory you can:
 - Check out a specific release tag. 
 - Get the latest development release by running `git pull` to download the latest changes.

### Installing with Homebrew (for OS X users)

Mac OS X users can install pyenv-virtualenv with the
[Homebrew](http://brew.sh) package manager. This
will give you access to the `pyenv-virtualenv` command. If you have pyenv
installed, you will also be able to use the `pyenv virtualenv` command.

*This is recommended method of installation if you installed pyenv
 with Homebrew.*

    brew install pyenv-virtualenv

Or, if you would like to install the latest development release:

    brew install --HEAD pyenv-virtualenv


## Usage

### Using `pyenv virtualenv` with pyenv

To create a virtualenv for the Python version use with pyenv, run
`pyenv virtualenv`, specifying the Python version you want and the name
of the virtualenv directory. For example,

    $ pyenv virtualenv 2.7.5 my-virtual-env-2.7.5

will create a virtualenv based on Python 2.7.5 
under `~/.pyenv/versions` in a folder called `my-virtual-env-2.7.5`. 


### Create virtualenv from current version

If there is only one argument is given to `pyenv virtualenv`,
virtualenv will be created with given name based on current
version.

    $ pyenv version
    3.3.2 (set by /home/yyuu/.pyenv/version)
    $ pyenv virtualenv venv33


### List existing virtualenvs

`pyenv virtualenvs` shows you the list of existing virtualenvs.

    $ pyenv shell venv27
    $ pyenv virtualenvs
    * venv27 (created from /home/yyuu/.pyenv/versions/2.7.5)
      venv33 (created from /home/yyuu/.pyenv/versions/3.3.2)


### Special environment variables

You can set certain environment variables to control the pyenv-virtualenv.

* `PYENV_VIRTUALENV_CACHE_PATH`, if set, specifies a directory to use for
  caching downloaded package files.
* `VIRTUALENV_VERSION`, if set, forces pyenv-virtualenv to install desired
  version of virtualenv. If the virtualenv has not been installed,
  pyenv-virtualenv will try to install the given version of virtualenv.
* `EZ_SETUP_URL` and `GET_PIP_URL`, if set and pyvenv is preferred
  than virtualenv, download `ez_setup.py` and `get_pip.py` from specified URL.
* `SETUPTOOLS_VERSION` and `PIP_VERSION`, if set and pyvenv is preferred
  than virtualenv, install specified version of setuptools and pip.


## Version History

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

### License

(The MIT License)

* Copyright (c) 2013 Yamashita, Yuu

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
