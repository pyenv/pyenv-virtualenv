---
name: Bug report
about: Create a report to help us improve
title: ''
labels: ''
assignees: ''

---

### Prerequisite
* [ ] Make sure no duplicated issue has already been reported in [the pyenv-virtualenv issues](https://github.com/pyenv/pyenv-virtualenv/issues). You should look in closed issues, too.
* [ ] Make sure you are reporting a problem in Pyenv-Virtualenv and not seeking consultation with Pyenv-Virtualenv use.
  * GitHub issues are intended mainly for Pyenv-Virtualenv development purposes. If you are seeking help with Pyenv-Virtualenv use, check [Pyenv-Virtualenv documentation](https://github.com/pyenv/pyenv-virtualenv?tab=readme-ov-file#usage), go to a user community site like [Gitter](https://gitter.im/yyuu/pyenv), [StackOverflow](https://stackoverflow.com/questions/tagged/pyenv), etc, or to [Discussions](https://github.com/orgs/pyenv/discussions).
* [ ] Make sure your problem is not derived from packaging (e.g. [Homebrew](https://brew.sh)).
  * Please refer to the package documentation for the installation issues, etc.
* [ ] Make sure your problem is not derived from other plugins.
  * This repository is maintaining the `pyenv-virtualenv` plugin only. Please refrain from reporting issues of other plugins here.

### Describe the bug
A clear and concise description of what the bug is.
Do specify what the expected behaviour is if that's not obvious from the bug's nature.

#### Reproduction steps
Listing the commands to run in a new console session and their output is usually sufficient.
Please use a Markdown code block (three backticks on a line by themselves before and after the text) to denote a console output excerpt.

#### Diagnostic details
- [ ] Platform information (e.g. Ubuntu Linux 20.04):
- [ ] OS architecture (e.g. amd64):
- [ ] pyenv version:
- [ ] pyenv-virtualenv version:
- [ ] Python version:
- [ ] virtualenv version (if installed):
- [ ] Please attach the debug log of a faulty Pyenv invocation as a gist
  * If the problem happens in a Pyenv invocation, you can turn on debug logging by setting `PYENV_DEBUG=1`, e.g. `env PYENV_DEBUG=1 pyenv install -v 3.6.4`
  * If the problem happens outside of a Pyenv invocation, get the debug log like this:
     ```bash
     # for Bash
     export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
     # for Zsh
     export PS4='+(%x:%I): %N(%i): '

     set -x
     <reproduce the problem>
     set +x
     ```
