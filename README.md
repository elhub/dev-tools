# DevXP Linux bootstrap script (devxp-linux)
[<img src="https://img.shields.io/badge/repo-github-blue" alt="">](https://github.com/elhub/devxp-linux)
[<img src="https://img.shields.io/badge/issues-jira-orange" alt="">](https://jira.elhub.cloud/issues/?jql=project%20%3D%20%22Team%20Dev%22%20AND%20component%20%3D%20devxp-linux%20AND%20status%20!%3D%20Done)
[<img src="https://teamcity.elhub.cloud/app/rest/builds/buildType:(id:DevXp_DevXpLinux_PublishDocs)/statusIcon" alt="">](https://teamcity.elhub.cloud/project/DevXp_DevXpLinux?mode=builds#all-projects)
[<img src="https://sonar.elhub.cloud/api/project_badges/measure?project=no.elhub.devxp%3Adevxp-linux&metric=alert_status" alt="">](https://sonar.elhub.cloud/dashboard?id=no.elhub.devxp%3Adevxp-linux)
[<img src="https://sonar.elhub.cloud/api/project_badges/measure?project=no.elhub.devxp%3Adevxp-linux&metric=ncloc" alt="">](https://sonar.elhub.cloud/dashboard?id=no.elhub.devxp%3Adevxp-linux)
[<img src="https://sonar.elhub.cloud/api/project_badges/measure?project=no.elhub.devxp%3Adevxp-linux&metric=bugs" alt="">](https://sonar.elhub.cloud/dashboard?id=no.elhub.devxp%3Adevxp-linux)
[<img src="https://sonar.elhub.cloud/api/project_badges/measure?project=no.elhub.devxp%3Adevxp-linux&metric=vulnerabilities" alt="">](https://sonar.elhub.cloud/dashboard?id=no.elhub.devxp%3Adevxp-linux)

## About

The ```devxp-linux``` script is used to bootstrap Ubuntu WSL on an Elhub developer PC. It ensures that all the required
tools, SDKs and scripts are installed and set up correctly. In addition, it is also used to upgrade an existing
developer PC setup; when rerun, the scripts will validate existing installations and upgrade tools and scripts as
appropriate.

## Getting Started

The following instructions assumes you have gotten a developer computer from 3020@statnett.no, which is a Lenovo ThinkPad-laptop that runs Windows 11 as its main operating system.

To install __Windows Subsystem for Linux__, run these commands inside __Windows PowerShell__ or __Windows Command Prompt__:

```powershell
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
```

which enables **WSL**, and

```powershell
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

which enables **Hyper-V** that **WSL** needs.

Then execute this line to install **Ubuntu 22.04.1 LTS**:

```powershell
wsl.exe --install -d Ubuntu
```

Determine where you will install the git-repository ```devxp-linux``` (we suggest ```$HOME/workspace/git```) on the file system inside Ubuntu in WSL (using __cd__ to navigate to your preferred directory and/or use __mkdir__ to create a new one), and then clone this repository in that location by executing:

```bash
git clone git@github.com:elhub/devxp-linux.git
```

To install necessary developer tools, execute:

```bash
./bootstrap.sh
```

The script will prompt you for your Ubuntu WSL sudo password while it is executing.

When the script is finished running, it should at the end output a text that is similar to this:

```bash
PLAY RECAP *********************************************************************
localhost                  : ok=88   changed=53   unreachable=0    failed=0    skipped=3    rescued=0    ignored=0
```

You can (and should) pull new commits (using *git pull*) and re-run this script from time to time to update your setup with new scripts and tools.

You should also set up the environment variable $EDITOR with your default text editor of your choice, if you haven't already done so. This can be done by executing:

```bash
sudo update-alternatives --config editor
```

## Usage

This project install a large number of tools, scripts, SDKs, and applications used for day-to-day development.

It installs the following programming languages/SDKs:

* Ansible
* Java
* Kotlin
* Node/Javascript
* Python

### adr

This is a Java implementation of the adr script-based toold by Nat Pryce. It allows for the simple creation and
maintenance of light-weight architecture decision records.

### arcanist

**Arcanist** is the command-line tool for [Phabricator](https://phabricator.elhub.cloud). It installs our
[arcanist extensions](https://github.com/elhub/devxo-arcanist) and sets up a global arcconfig file. The global
arcconfig contains a number of useful aliases:
* **cleanup**: Cleans up the directory. Be careful (in particular, don't use it with terraform projects).
* **init**: Use with parameters "none", "maven", or "gradle". This copies appropriate default files (arcconfig,
  gitignore, gitattributes, etc) for a project directory. This command can also be run using the arc-init script.
* **log**: Displays git log nicely.
* **patch-clean**: Cleans up arcpatch branches.
* **set-exe**: Use with filename. Sets it to be executable and updates the git index..
* **status**: When run in your workspace directory (i.e., the dir where you keep your repositories, will iterate
  through all available git repos and inform which repositories have modified or untracked files. This command can also
  be run using the arc-status script.

### Linters

This project installs a number of important linters, used by arcanist. These linters can also be used in a standalone
manner.

**Checkstyle** can be used as a command line tool to check that your Java code conforms with a given Java style.
Elhub's default checkstyle config is also installed. The script /usr/local/bin/checkstyle automatically uses our
default config.

See the [checkstyle documentation](https://checkstyle.org/) for more detailed information.

**Detekt** can be used as a command line tool to check that your Kotlin code conforms with a given code style. Elhub's
default kotlin config is also installed. The script in /usr/local/bin/detekt automatically uses our default config.

See the [detekt documentation](https://detekt.github.io/detekt/) for more detailed information.

It also install yamllint and ansible-lint.

### Git Utility Scripts

The project installs a number of git utility scripts on the dev box.

**git-clone-all** is a script that can be used to clone all development repositories from our git servers.

**git-mirror** is a simple script for mirroring repositories using ```git clone --mirror```.

**git-status-all** carries out a ```git status``` on all the repositories in a directory.

### Docker

To execute the subcommands in ```docker``` in WSL, you need to start the service ```docker``` which will run the Docker daemon:

```bash
sudo service docker start
```

then you will not get this error message when executing the subcommands in ```docker```:

```bash
Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?
```

There is no need for Docker Desktop or anything similar installed.

If you are getting the error above after starting the _docker_-service, execute

```bash
sudo service docker status
```

to see if it is running.

If not, it may not start due to a change to _iptables_ in Ubuntu 22.04 LTS that sets it to _iptables-nft_ by default which does not work in WSL2. To fix that, either [execute](https://askubuntu.com/a/1406159):

```
sudo update-alternatives --set iptables /usr/sbin/iptables-legacy
```

or [do](https://askubuntu.com/a/1437129):

1. Execute this command:

```bash
sudo update-alternatives --config iptables
```

2. Type number "1" and press Enter to select "iptables-legacy".

After _iptables_ has been set to _iptables-legacy_, then execute again

```bash
sudo service docker start
```

to see if it starts now.

## Testing

The project runs basic sanity tests automatically (the validate role) after installation.

### With Docker

```
docker build .
```

## Contributing

Contributing, issues and feature requests are welcome. See the
[Contributing](https://github.com/elhub/devxp-linux/blob/main/CONTRIBUTING.md) file.

## Owners

This project is developed by [Elhub](https://elhub.no). For the specific development group responsible for this
code, see the [Codeowners](https://github.com/elhub/devxp-linux/blob/main/CODEOWNERS) file.

## License

This project is [MIT](https://github.com/elhub/devxp-linux/blob/main/LICENSE.md) licensed.
