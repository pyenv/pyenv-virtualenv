Too many issues will kill our team's development velocity, drastically.
Make sure you have checked all steps below.

### Prerequisite
* [ ] Make sure your problem is not listed in [the common build problems](https://github.com/pyenv/pyenv/wiki/Common-build-problems).
* [ ] Make sure no duplicated issue has already been reported in [the pyenv-virtualenv issues](https://github.com/pyenv/pyenv-virtualenv/issues). You should look in closed issues, too.
* [ ] Make sure you are not asking us to help solving your specific issue.
  * GitHub issues is opened mainly for development purposes. If you want to ask someone to help solving your problem, go to some community site like [Gitter](https://gitter.im/yyuu/pyenv), [StackOverflow](https://stackoverflow.com/questions/tagged/pyenv), etc.
* [ ] Make sure your problem is not derived from packaging (e.g. [Homebrew](https://brew.sh)).
  * Please refer to the package documentation for the installation issues, etc.
* [ ] Make sure your problem is not derived from other plugins.
  * This repository is maintaining the `pyenv-virtualenv` plugin only. Please refrain from reporting issues of other plugins here.

### Description
- [ ] Platform information (e.g. Ubuntu Linux 20.04):
- [ ] OS architecture (e.g. amd64):
- [ ] pyenv version:
- [ ] pyenv-virtualenv version:
- [ ] Python version:
- [ ] virtualenv version (if installed):
- [ ] Please attach the debug log of a faulty Pyenv invocation as a gist
  * If the problem happens in a Pyenv invocation, you can turn on debug logging by setting `PYENV_DEBUG=1`, e.g. `env PYENV_DEBUG=1 pyenv install -v 3.6.4`
  * If the problem happens outside of a Pyenv invocation, get the debug log like this:
     ```
     # for Bash
     export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
     # for Zsh
     export PS4='+(%x:%I): %N(%i): '

     set -x
     <reproduce the problem>
     set +x
     ```
