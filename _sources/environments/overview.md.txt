# Local (development) environment 

To get a local copy up and running (http://localhost) follow these simple example steps.

## Prerequisites

* Install [docker-compose](https://docs.docker.com/compose/install/) to run this project.

## Installation

* linux or macOS: 

    ```sh
    # create a parent directory
    mkdir interlink && cd interlink
    # clone the main repository
    git clone https://github.com/interlink-project/interlink-project && cd interlink-project
    # clones all the github repositories in the parent folder
    make setup
    # set the necessary secret files
    cat <<EOF >>interlinker-googledrive/.secrets
    GOOGLE_PROJECT_ID=
    GOOGLE_PRIVATE_KEY_ID=
    # Google private key must be between double quotes and replace all the "\n" characters with "\\n"
    GOOGLE_PRIVATE_KEY=""
    GOOGLE_CLIENT_EMAIL=
    GOOGLE_CLIENT_ID=
    GOOGLE_CLIENT_X509=
    EOF

    cat <<EOF >>backend-auth/.secrets
    CLIENT_SECRET=
    EOF
    # start the containers
    make up
    ```

    Check [Google keys section](https://interlink-project.github.io/interlink-project/environments/google.html) for the obtention of the credentials to put in interlinker-googledrive/.secrets and ask FBK/DEUSTO in order to get the CLIENT_SECRET for the backend-auth/.secrets file.

    To STOP all containers:
    ```sh
    # from /interlink-project
    make down
    ```
* Windows:

    * Enable WSL2 (Windows Subsystem for Linux 2) on Windows as reported in https://pureinfotech.com/install-windows-subsystem-linux-2-windows-10/
    * Ensure that you have a bash profile available. For that, it is recommended that you install Ubunto on WSL2: https://ubuntu.com/tutorials/install-ubuntu-on-wsl2-on-windows-10#1-overview  
    * Open Docker Desktop/Settings/Resources/WSL integration and enable Ubutu o whatever Linux environment has been installed in your windows machine
    * Follow the steps for Linux

```sh
sudo apt-get update
```
## Development and Demo

* https://dev.interlink-project.eu
* https://demo.interlink-project.eu


## Pilots (mef / varam / zgz)
* https://mef.interlink-project.eu
* https://varam.interlink-project.eu
* https://zgz.interlink-project.eu



