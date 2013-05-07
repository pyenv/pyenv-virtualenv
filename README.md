# pyenv-virtualenv (a.k.a. [python-virtualenv](https://github.com/yyuu/python-virtualenv))

pyenv-virtualenv is a [pyenv](https://github.com/yyuu/pyenv) plugin
that provides an `pyenv virtualenv` command to create virtualenv for Python
on UNIX-like systems.

(NOTICE: If you are an existing user of [virtualenvwrapper](http://pypi.python.org/pypi/virtualenvwrapper)
and you love it, [pyenv-virtualenvwrapper](https://github.com/yyuu/pyenv-virtualenvwrapper) may help you
to manage your virtualenvs.)

## Installation

### Installing as a pyenv plugin

Installing pyenv-virtualenv as a pyenv plugin will give you access to the
`pyenv virtualenv` command.

    $ mkdir -p ~/.pyenv/plugins
    $ cd ~/.pyenv/plugins
    $ git clone git://github.com/yyuu/pyenv-virtualenv.git

This will install the latest development version of pyenv-virtualenv into
the `~/.pyenv/plugins/pyenv-virtualenv` directory. From that directory, you
can check out a specific release tag. To update pyenv-virtualenv, run `git
pull` to download the latest changes.

## Usage

### Using `pyenv virtualenv` with pyenv

To create a virtualenv for the Python version use with pyenv, run
`pyenv virtualenv` with tha exact name of the version you want to create
virtualenv. For example,

    $ pyenv virtualenv --distribute 2.7.3 venv27

virtualenvs will be created into a directory of the same name
under `~/.pyenv/versions`.


## Version History

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
