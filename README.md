# python-virtualenv

python-virtualenv is an [pyenv](https://github.com/yyuu/pyenv) plugin
that provides an `pyenv virtualenv` command to create virtualenv for Python
on UNIX-like systems.


## Installation

### Installing as an pyenv plugin (recommended)

Installing python-virtualenv as an pyenv plugin will give you access to the
`pyenv virtualenv` command.

    $ mkdir -p ~/.pyenv/plugins
    $ cd ~/.pyenv/plugins
    $ git clone git://github.com/yyuu/python-virtualenv.git

This will install the latest development version of python-virtualenv into
the `~/.pyenv/plugins/python-virtualenv` directory. From that directory, you
can check out a specific release tag. To update python-virtualenv, run `git
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

#### 20120927

 * Initial public release.

### License

(The MIT License)

Copyright (c) 2012 Yamashita, Yuu
Copyright (c) 2011 Sam Stephenson

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
