# pyenv-virtualenv

[![Join the chat at https://gitter.im/yyuu/pyenv-virtualenv](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/yyuu/pyenv-virtualenv?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

[![Build Status](https://travis-ci.org/yyuu/pyenv-virtualenv.svg?branch=master)](https://travis-ci.org/yyuu/pyenv-virtualenv)

pyenv-virtualenv is a [pyenv](https://github.com/yyuu/pyenv) plugin
that provides features to manage virtualenvs and conda environments
for Python on UNIX-like systems.

(NOTICE: If you are an existing user of [virtualenvwrapper](http://pypi.python.org/pypi/virtualenvwrapper)
and you love it, [pyenv-virtualenvwrapper](https://github.com/yyuu/pyenv-virtualenvwrapper) may help you
(additionally) to manage your virtualenvs.)

## Installation

### Installing as a pyenv plugin

This will install the latest development version of pyenv-virtualenv into
the `~/.pyenv/plugins/pyenv-virtualenv` directory.

**Important note:**  If you installed pyenv into a non-standard directory, make
sure that you clone this repo into the 'plugins' directory of wherever you
installed into.

From inside that directory you can:
 - Check out a specific release tag.
 - Get the latest development release by running `git pull` to download the
   latest changes.

1. **Check out pyenv-virtualenv into plugin directory**

    ```sh
    $ git clone https://github.com/yyuu/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv
    ```

2. (OPTIONAL) **Add `pyenv virtualenv-init` to your shell** to enable auto-activation of virtualenv. This is entirely optional but pretty useful.

    ```sh
    $ echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bash_profile
    ```

    **Zsh note**: Modify your `~/.zshenv` file instead of `~/.bash_profile`.
    **Pyenv note**: You may also need to add `eval "$(pyenv init -)"` to your profile if you haven't done so already.

3. **Restart your shell to enable pyenv-virtualenv**

    ```sh
    $ exec "$SHELL"
    ```


### Installing with Homebrew (for OS X users)

Mac OS X users can install pyenv-virtualenv with the
[Homebrew](http://brew.sh) package manager.
This will give you access to the `pyenv-virtualenv` command. If you have pyenv
installed, you will also be able to use the `pyenv virtualenv` command.

*This is the recommended method of installation if you installed pyenv
 with Homebrew.*

```sh
$ brew install pyenv-virtualenv
```

Or, if you would like to install the latest development release:

```sh
$ brew install --HEAD pyenv-virtualenv
```

After installation, you'll still need to add 
```sh
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
```
to your profile (as stated in the caveats). You'll only ever have to do this once.


## Usage

### Using `pyenv virtualenv` with pyenv

To create a virtualenv for the Python version used with pyenv, run
`pyenv virtualenv`, specifying the Python version you want and the name
of the virtualenv directory. For example,

```sh
$ pyenv virtualenv 2.7.10 my-virtual-env-2.7.10
```

will create a virtualenv based on Python 2.7.10 under `~/.pyenv/versions` in a
folder called `my-virtual-env-2.7.10`.


### Create virtualenv from current version

If there is only one argument given to `pyenv virtualenv`, the virtualenv will
be created with the given name based on the current pyenv Python version.

```sh
$ pyenv version
3.4.3 (set by /home/yyuu/.pyenv/version)
$ pyenv virtualenv venv34
```


### List existing virtualenvs

`pyenv virtualenvs` shows you the list of existing virtualenvs and `conda` environments.

```sh
$ pyenv shell venv27
$ pyenv virtualenvs
  miniconda3-3.9.1 (created from /home/yyuu/.pyenv/versions/miniconda3-3.9.1)
  miniconda3-3.9.1/envs/myenv (created from /home/yyuu/.pyenv/versions/miniconda3-3.9.1)
* venv27 (created from /home/yyuu/.pyenv/versions/2.7.10)
  venv34 (created from /home/yyuu/.pyenv/versions/3.4.3)
```


### Activate virtualenv

Some external tools (e.g. [jedi](https://github.com/davidhalter/jedi)) might
require you to `activate` the virtualenv and `conda` environments.

`pyenv-virtualenv` will automatically activate/deactivate the virtualenv if
the `eval "$(pyenv virtualenv-init -)"` is properly configured in your shell.

You can also activate and deactivate a pyenv virtualenv manually:

```sh
pyenv activate <name>
pyenv deactivate
```


### Delete existing virtualenv

Removing the directory in `~/.pyenv/versions` will delete the virtualenv, or you can run:

```sh
pyenv uninstall my-virtual-env
```


### virtualenv and pyvenv

There is a [venv](http://docs.python.org/3/library/venv.html) module available
for CPython 3.3 and newer.
It provides a command-line tool `pyvenv` which is the successor of `virtualenv`
and distributed by default.

`pyenv-virtualenv` uses `pyvenv` if it is available and the `virtualenv`
command is not available.


### Anaconda and Miniconda

You can manage `conda` environments by `conda create` as same manner as standard Anaconda/Miniconda installations.
To use those environments, you can use `pyenv activate` and `pyenv deactivate`.

```sh
$ pyenv version
miniconda3-3.9.1 (set by /home/yyuu/.pyenv/version)
$ conda env list
# conda environments:
#
myenv                    /home/yyuu/.pyenv/versions/miniconda3-3.9.1/envs/myenv
root                  *  /home/yyuu/.pyenv/versions/miniconda3-3.9.1
$ pyenv activate miniconda3-3.9.1/envs/myenv
discarding /home/yyuu/.pyenv/versions/miniconda3-3.9.1/bin from PATH
prepending /home/yyuu/.pyenv/versions/miniconda3-3.9.1/envs/myenv/bin to PATH
$ python --version
Python 3.4.3 :: Continuum Analytics, Inc.
$ pyenv deactivate
discarding /home/yyuu/.pyenv/versions/miniconda3-3.9.1/envs/myenv/bin from PATH
```

If `conda` is available, `pyenv virtualenv` will use it to create environment by `conda create`.

```sh
$ pyenv version
miniconda3-3.9.1 (set by /home/yyuu/.pyenv/version)
$ pyenv virtualenv myenv2
$ conda env list
# conda environments:
#
myenv                    /home/yyuu/.pyenv/versions/miniconda3-3.9.1/envs/myenv
myenv                    /home/yyuu/.pyenv/versions/miniconda3-3.9.1/envs/myenv2
root                  *  /home/yyuu/.pyenv/versions/miniconda3-3.9.1
```

You can use version like `miniconda3-3.9.1/envs/myenv` to specify `conda` environment as a version in pyenv.

```sh
$ pyenv version
miniconda3-3.9.1 (set by /home/yyuu/.pyenv/version)
$ pyenv shell miniconda3-3.9.1/envs/myenv
$ which python
/home/yyuu/.pyenv/versions/miniconda3-3.9.1/envs/myenv/bin/python
```


### Special environment variables

You can set certain environment variables to control pyenv-virtualenv.

* `PYENV_VIRTUALENV_CACHE_PATH`, if set, specifies a directory to use for
  caching downloaded package files.
* `VIRTUALENV_VERSION`, if set, forces pyenv-virtualenv to install the desired
  version of virtualenv. If `virtualenv` has not been installed,
  pyenv-virtualenv will try to install the given version of virtualenv.
* `GET_PIP`, if set and `pyvenv` is preferred over `virtualenv`,
  use `get_pip.py` from the specified location.
* `GET_PIP_URL`, if set and `pyvenv` is preferred over
  `virtualenv`, download `get_pip.py` from the specified URL.
* `PIP_VERSION`, if set and `pyvenv` is preferred
  over `virtualenv`, install the specified version of pip.


## Version History

See [CHANGELOG.md](CHANGELOG.md).


### License

(The MIT License)

* Copyright (c) 2015 Yamashita, Yuu

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
