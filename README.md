<h2 align="center">
  <a href="https://smart-maas.eu/en/"><img src="https://github.com/SmartMaaS-Services/Transaction-Context-Manager/blob/main/docs/images/Header.jpeg" alt="Smart MaaS" width="500"></a>
  <br>
      SMART MOBILITY SERVICE PLATFORM
  <br>
  <a href="https://smart-maas.eu/en/"><img src="https://github.com/SmartMaaS-Services/Transaction-Context-Manager/blob/main/docs/images/Logos-Smart-MaaS.png" alt="Smart MaaS" width="250"></a>
  <br>
</h2>

<p align="center">
  <a href="mailto:info@smart-maas.eu">Contact</a> •
  <a href="https://github.com/SmartMaaS-Services/Transaction-Context-Manager/issues">Issues</a> •
  <a href="https://smart-maas.eu/en/">Project Page</a>
</p>


***

<h1 align="center">
  <a>
    Smart-Platform-Services (Slim Starter)
  </a>
</h1>

***

[![FIWARE Core Context Management](https://nexus.lab.fiware.org/static/badges/chapters/core.svg)](https://www.fiware.org/developers/catalogue/)
[![NGSI v2](https://img.shields.io/badge/NGSI-V2-red.svg)](http://fiware-ges.github.io/orion/api/v2/stable/)
[![NGSI-LD badge](https://img.shields.io/badge/NGSI-LD-red.svg)](https://www.etsi.org/deliver/etsi_gs/CIM/001_099/009/01.02.01_60/gs_cim009v010201p.pdf)
[![](https://nexus.lab.fiware.org/repository/raw/public/badges/chapters/processing.svg)](./processing/README.md)
[![](https://nexus.lab.fiware.org/repository/raw/public/badges/chapters/visualization.svg)](./processing/README.md)
[![](https://nexus.lab.fiware.org/repository/raw/public/badges/chapters/media-streams.svg)](./processing/README.md)
[![](https://nexus.lab.fiware.org/repository/raw/public/badges/chapters/api-management.svg)](./data-publication/README.md)
[![](https://nexus.lab.fiware.org/repository/raw/public/badges/chapters/data-publication.svg)](./data-publication/README.md)
[![](https://nexus.lab.fiware.org/repository/raw/public/badges/chapters/data-monetization.svg)](./data-publication/README.md)
[![](https://nexus.lab.fiware.org/repository/raw/public/badges/chapters/security.svg)](./security/README.md)
[![License badge](https://img.shields.io/github/license/telefonicaid/fiware-orion.svg)](https://opensource.org/licenses/AGPL-3.0)

> <b><i>NOTE:</i></b> This project is a forked and revised "slim starter" version of the original project which can be found here: https://github.com/SmartMaaS-Services/dev.smartmaas.services.
> 
> It contains several bug fixes and enhancements, but does <b>NOT</b> contain all of the services with the subdomains listed below! Only the core components such as [Keyrock](https://github.com/ging/fiware-idm), [APInf](https://github.com/apinf/platform), [Tenant-Manager](https://github.com/Profirator/tenant-manager), [Umbrella](https://github.com/Profirator/api-umbrella) as well as the two context brokers [Orion v2](https://github.com/telefonicaid/fiware-orion) and [Orion-LD](https://github.com/FIWARE/context.Orion-LD) and the [BAE Marketplace](https://github.com/FIWARE-TMForum/Business-API-Ecosystem) have been installed.

<b>Smart-Platform-Services</b> is a set of directories which contains Docker service YAMLs and configuration files of <b>FIWARE Foundation</b> Generic Enablers (GE) necessary to setup an initial Smart Platform. The whole stack is deployed and managed under a Docker Swarm Cluster.

Smart-Platform-Services consists of three directories, `services`, `config` and `scripts`:

- `services` directory consists of all the Docker YAML files which contain instructions for the deployment of the FIWARE GE.
- `config` directory consists of all the configuration files needed by the Docker services YAML files.
- `scripts` directory holds two setup scripts used for automatic configuration and setup/deployment of the platform.

> <i>NOTE:</i> The following manual was written for deployments on Ubuntu/Debian-alike systems. The scripts were tested on a system with Ubuntu 18.04. No warranty can be given for compatibility with other versions or linux distributions.

## Content ##
- [Smart-Platform-Services (Slim Starter)](#smart-platform-services-slim-starter)
	- [Content](#content)
	- [Prerequisites](#prerequisites)
		- [Technical requirements](#technical-requirements)
		- [Maxmind license](#maxmind-license)
		- [PayPal account](#paypal-account)
	- [Deployment](#deployment)
		- [Preperation of VM](#preperation-of-vm)
		- [Clone the project files](#clone-the-project-files)
		- [Setup script #1](#setup-script-1)
		- [Setup first Umbrella users](#setup-first-umbrella-users)
		- [Setup script #2](#setup-script-2)
	- [Configuration](#configuration)
		- [Configure Keyrock (Identity Manager)](#configure-keyrock-identity-manager)
			- [Change admin user credentials](#change-admin-user-credentials)
			- [Create a standard user](#create-a-standard-user)
			- [Organizations and applications](#organizations-and-applications)
			- [Roles and permissions](#roles-and-permissions)
				- [Standard roles](#standard-roles)
				- [Custom roles](#custom-roles)
				- [Create role](#create-role)
				- [Create permission](#create-permission)
				- [Assign permission to role](#assign-permission-to-role)
				- [Assign role to user](#assign-role-to-user)
		- [Configure Umbrella (API Management Framework)](#configure-umbrella-api-management-framework)
			- [Website Backends](#website-backends)
			- [API Backends](#api-backends)
				- [Tenant-Manager](#tenant-manager)
				- [Keyrock Token Service](#keyrock-token-service)
		- [Configure APInf (API Management Framework)](#configure-apinf-api-management-framework)
			- [Preferences](#preferences)
			- [API setup](#api-setup)
				- [Orion v2 Context Broker](#orion-v2-context-broker)
					- [Umbrella API Backend](#umbrella-api-backend)
			- [Tenant-Manager](#tenant-manager-1)
				- [Generate access token (Authorization tab)](#generate-access-token-authorization-tab)
				- [Manage Tenants (List tab)](#manage-tenants-list-tab)
					- [Effects on Keyrock settings](#effects-on-keyrock-settings)
		- [Configure Marketplace (based on Biz Framework)](#configure-marketplace-based-on-biz-framework)
			- [NGSI Plugin](#ngsi-plugin)
			- [Roles](#roles)
	- [Tests](#tests)
		- [NGSI v2 context data](#ngsi-v2-context-data)
			- [POST data](#post-data)
			- [GET data](#get-data)
	- [Services incorporated](#services-incorporated)
	- [Platform flowchart](#platform-flowchart)
	- [Known issues](#known-issues)
		- [Missing or unreplicated Docker services](#missing-or-unreplicated-docker-services)
	- [ToDo](#todo)
	- [Contribution](#contribution)
	- [License](#license)

## Prerequisites ##
Before you set up the platform on your VM or server, a few prerequisites must be fulfilled.

### Technical requirements ###

- Make sure that your machine has sufficient (V)CPU and RAM. We recommend as an <b>absolute minimum</b> a configuration of <b>8 (V)CPUs / 16 GB RAM</b>. However, <b>16 (V)CPUs / 32 GB RAM</b> or more are <b>better</b> to provide sufficient resources for all services. Practice has shown that a larger configuration significantly improves both response times and inter-service communication.
- You need a managable domain `<domain-name>` with control over DNS records and the possibility of creating additional subdomains. These subdomains will be used to access the various web interfaces and services the platform is composed of.  
The following subdomains (A records) must be created:

	* `accounts`.\<domain-name\>  
	<i>Needed for: [Keyrock - Identity Manager](https://github.com/ging/fiware-idm)</i>
	* `apis`.\<domain-name\>  
	<i>Needed for: [APInf - API Management Framework](https://github.com/apinf/platform)</i>
	* `cadvisor`.\<domain-name\>  
	<i>Needed for: [cAdvisor - Docker Monitoring](https://github.com/google/cadvisor)</i>
	* `charts`.\<domain-name\>  
	<i>Needed for: [Grafana - Open source analytics & monitoring](https://github.com/grafana/grafana)</i>
	* `context`.\<domain-name\>  
	<i>Needed for: [FIWARE Orion Context Broker](https://github.com/telefonicaid/fiware-orion)</i>
	* `context-ld`.\<domain-name\>  
	<i>Needed for: [FIWARE Orion-LD Context Broker](https://github.com/FIWARE/context.Orion-LD)</i>
	* `dashboards`.\<domain-name\>  
	<i>Needed for: [Wirecloud - Web dashboard platform](https://github.com/Wirecloud)</i>
	* `data`.\<domain-name\>  
	<i>Needed for: [CKAN - Open Data publication platform](https://github.com/conwetlab/FIWARE-CKAN-Extensions)</i>
	* `knowage`.\<domain-name\>  
	<i>Needed for: [Knowage - Business Intelligence platform](https://github.com/KnowageLabs)</i>
	* `market`.\<domain-name\>  
	<i>Needed for: [Marketplace based on Biz Framework - Context API/Data monetization](https://github.com/FIWARE-TMForum/Business-API-Ecosystem)</i>
	* `ngsiproxy`.\<domain-name\>  
	<i>Needed for: [NGSI Proxy - Redirection of NGSI notifications to web pages](https://github.com/conwetlab/ngsi-proxy)</i>
	* `nifi`.\<domain-name\>  
	<i>Needed for: [Apache NiFi - Data flow and transformation](https://github.com/apache/nifi)</i>
	* `perseo`.\<domain-name\>  
	<i>Needed for: [Perseo - Complex Event Processing (CEP)](https://github.com/telefonicaid/perseo-core)</i>
	* `sthdata`.\<domain-name\>  
	<i>Needed for: [QuantumLeap - FIWARE Generic Enabler to support the usage of NGSI data in time-series databases](https://github.com/orchestracities/ngsi-timeseries-api)</i>
	* `umbrella`.\<domain-name\>  
	<i>Needed for: [APInf Umbrella - open source API management platform (based on API Umbrella)](https://github.com/Profirator/api-umbrella)</i>

- Make sure you can provide an e-mail address used by certbot (tool for setting up [Let's Encrypt](https://letsencrypt.org) certificates) for account registration and recovery. All externally exposed services will be served via HTTPS.

- Allow incoming traffic on port 443 (HTTPS) on your VM.

- You must have a SMTP server ready for sending out e-mails to the platform users (register at a provider of your choice or set up a server on your own which won't be covered by this guide).

### Maxmind license ###

APInf Umbrella needs a Maxmind License in order to use GeoIP location information. Please request your own free license key at [Maxmind](https://www.maxmind.com/en/request-service-trial?service_geoip=1).

> <i>NOTE:</i> This step is very important, because the APInf Umbrella installation will not work - to be exact, the docker service would not even start up without a valid Maxmind license!
  
<p align="center">
	<img src="docs/img/setup/maxmind/maxmind_request_service_trial.png" alt="Image of sign-up page for free Maxmind service trial" width="80%">
</p>

After registration you will receive an e-mail with a link for password creation. Once the process is completed, you will be taken to the account overview where you can create the first license key:

<p align="center">
	<img src="docs/img/setup/maxmind/maxmind_generate_license_key.png" alt="Image of empty Maxmind license key list" width="80%">
</p>

On the confirmation page choose a name for the license key and select NOT to use `GeoIP Update`:

<p align="center">
	<img src="docs/img/setup/maxmind/maxmind_confirm_license_key.png" alt="Image of Maxmind license key confirmation page" width="80%">
</p>

During creation, the full license key is displayed only ONCE. Therefore it is important to copy it at this point and save it somewhere safe. The license key must be entered later during the platform installation:

<p align="center">
	<img src="docs/img/setup/maxmind/maxmind_license_key_full_view.png" alt="Image of page with full-length Maxmind license key" width="80%">
</p>

In the license overview, the created license keys are only displayed in abbreviated form:

<p align="center">
	<img src="docs/img/setup/maxmind/maxmind_license_key_overview.png" alt="Image of filled Maxmind license key list" width="80%">
</p>

Next signup for `GeoLite2` database access and agree to the terms of the EULA:

<p align="center">
	<img src="docs/img/setup/maxmind/maxmind_geolite2_signup.png" alt="Image of sign-up link for GeoLite2 database access" width="80%">
</p>

<p align="center">
	<img src="docs/img/setup/maxmind/maxmind_geolite2_eula.png" alt="Image of GeoLite2 EULA terms agreement" width="80%">
</p>

This completes the necessary preparations to grant Umbrella access to the GeoLite2 database.

### PayPal account ###

When the setup script is invoked, PayPal API credentials (a client ID and client secret) must be provided to connect the marketplace to the PayPal API for payment transactions. PayPal is currently the only supported payment provider.

> <i>NOTE:</i> This step is optional, but if no account is specified, only free products can be purchased in the marketplace.

## Deployment ##

### Preperation of VM ###
 
First of all, update/upgrade your VM and install some additional packages:

```bash
sudo apt-get update -y && sudo apt-get upgrade -y && sudo apt-get install -y zip unzip git software-properties-common
```

Add repository and install packages for certbot:

```bash
sudo add-apt-repository universe -y && sudo add-apt-repository ppa:certbot/certbot -y && sudo apt-get update -y && sudo apt-get install -y certbot python-certbot-nginx
```

Deploy wildcard certificates from Let's Encrypt for your domain:
> <i>NOTE:</i> Before executing the certbot command, please replace `<email>` with your e-mail address used for account registration and recovery of your certificates, e.g. `me@example.org`  
Please also change the placeholder `<domain-name>` to match your domain name, e.g. `example.org`

```bash
sudo certbot certonly --manual --preferred-challenges dns-01 --server https://acme-v02.api.letsencrypt.org/directory --email <email> --no-eff-email --manual-public-ip-logging-ok --agree-tos -d *.<domain-name>
```

After running the above command, add the DNS TXT record provided by Let’s Encrypt certbot to your DNS server.

### Clone the project files ###

Clone this remote repository with your Git credentials:

```bash
git clone https://github.com/SmartMaaS-Services/smart-platform-services_slim-starter.git
```

### Setup script #1 ###

Change to your local repo directory. It currently contains two setup scripts for configuration and setup of the platform services which are going to be deployed as Docker services. Be sure to have execution rights set for both scripts:

```bash
cd smart-platform-services_slim-starter
chmod u+x scripts/setup-part*
```
Deploy services in Docker Swarm by running the first script. The following options are supported:

<pre>
<i>Mandatory options:</i>  
<b>--login-user</b>   logged-in (or SSH) user that will be added to the docker user group  
<b>--smtp-server</b>  SMTP server address  
<b>--smtp-user</b>    SMTP account user  
<b>--smtp-pwd</b>     SMTP account password  
<b>--domain</b>       domain name  
<b>--maxmind-key</b>  Maxmind license key  
<b>--stack</b>        stack name for the Docker Swarm - can be chosen freely and will be used as name prefix for Docker container and networks 

<i>Optional options:</i>  
<b>--version</b>      prints out the script's version  
<b>--help</b>         prints out usage information and these options
</pre>

> <i>NOTE:</i> Put option values into single quotes ('') to prevent special characters from being interpreted by the shell.

```bash
./scripts/setup-part1.sh --login-user '<linux-login-user>' --smtp-server '<smtp-server>' --smtp-user '<smtp-user>' --smtp-pwd '<smtp-password>' --domain '<domain-name>' --maxmind-key '<maxmind-key>' --stack '<swarm-stack-name>'
```
Example:
```bash
./scripts/setup-part1.sh --login-user 'ubuntu' --smtp-server 'smtp.eu.mailgun.org' --smtp-user 'postmaster@example.org' --smtp-pwd '7ece38bb6651b3eeh8d3095184c5f518-87c35c41-49e42c7d' --domain 'example.org' --maxmind-key 'l7cKpzYee2ROoGDx' --stack 'swarm-test-stack'
```

> <i>NOTE:</i> You can check the deployment status at any time using the `sudo docker service ls` command. DO NOT proceed before ALL services for this stack have been replicated (all should read at least `1/X` and NOT `0/X`). This might take quite some time. Please be patient, otherwise dependency problems might occur.

<p align="center">
	<img src="docs/img/setup/docker_stack_service_replication_status.png" alt="Image of Docker service list with incomplete replication" width="80%">
</p>

### Setup first Umbrella users ###

Open <b><i>https://<span></span>umbrella.<code>&lt;domain-name&gt;</code>/admin</i></b> in your browser and register the first user - the admin - for the installed [APInf Umbrella](https://github.com/Profirator/api-umbrella) service. APInf Umbrella (a fork of [API Umbrella](https://apiumbrella.io/)) acts as a proxy that sits in front of the services of the Smart Platform and serves as a gatekeeper to enforce access control to the backend applications, supports rate limiting and analytics. 

<p align="center">
	<img src="docs/img/umbrella/umbrella_first_signup.png" alt="Image of first Umbrella signup" width="80%">
</p>

After creation of the admin user you should be redirected to the management dashboard of Umbrella. 

- Go to `'Users' -> 'Admin Accounts'` and select the admin account you've just created by clicking its e-mail address. Copy the Admin API Token and put it in place of `<admin-auth-token>` from the next command.

<p align="center">
	<img src="docs/img/umbrella/umbrella_edit_admin_marked.png" alt="Image of Umbrella Edit Admin mask" width="80%">
</p>

- The internal Admin API of Umbrella requires an additional standard user to perform admin requests. These requests will be sent by the second setup script to make the services of the platform (each addressed by one of the created subdomains) reachable behind Umbrella.  
Go to `'Users' -> 'API Users'` and add a new API user. Fill out the `User Info` section and click "Save".

> <i>NOTE:</i> You MUST use the same e-mail address as for the admin user!

<p align="center">
	<img src="docs/img/umbrella/umbrella_add_api_user.png" alt="Image of Umbrella Add API User mask" width="80%">
</p>

- The new account should appear in the list of API users. Open it, copy the user's API Key and replace the `<api-key>` placeholder in the shell command.

<p align="center">
	<img src="docs/img/umbrella/umbrella_edit_api_user_marked.png" alt="Image of Umbrella Edit API User mask" width="80%">
</p>

The initial configuration of Umbrella is now complete. In the [configuration section](#configure-umbrella-api-management-framework) we will come back to Umbrella for additional settings.

### Setup script #2 ###

Run the second script which will create Umbrella Website backends, Keyrock applications and roles. It also configures and deploys the remaining services of the platform. The following options are supported:

<pre>
<i>Mandatory options:</i>  
<b>--domain</b>             domain name (MUST be the same value as in first setup script!) 
<b>--api-key</b>            API Key of the first created Umbrella user  
<b>--token</b>              Admin API Token of the first created Umbrella admin  
<b>--stack</b>              stack name for the Docker Swarm - can be chosen freely and will be used as name prefix for Docker container and networks (MUST be the same value as in first setup script!) 

<i>Optional options:</i>  
<b>--bae-paypal-id</b>      PayPal client ID to be used when using PayPal as payment gateway in BAE Marketplace  
<b>--bae-paypal-secret</b>  PayPal client secret  
<b>--version</b>            prints out the script's version  
<b>--help</b>               prints out usage information and these options
</pre>

> <i>NOTE:</i> Options `--domain` and `--stack` must have assigned the same values as in first setup script. Omitting the `--bae-paypal*` options will disable marketplace payments. Also don't forget about the single quotes ('') here.

```bash
./scripts/setup-part2.sh --domain '<domain-name>' --api-key '<api-key>' --token '<admin-auth-token>' --bae-paypal-id '<bae-paypal-id>' --bae-paypal-secret '<bae-paypal-secret>' --stack '<swarm-stack-name>'
```

Example:
```bash
./scripts/setup-part2.sh --domain 'example.org' --api-key 'GKix62HPfoCtGyAV2CXTte4JvWrjvFJZwVl7e9EO' --token 'tUWTKOqbFDvgnA2oZgsxHQDk6j1G5se86aTYBrcS' --bae-paypal-id 'mOh69Fg852kXlY7vhkki62jTFlu7Nwbt' --bae-paypal-secret 'JpOrhdL7HXN6SP5Ve9uYup26iHeaSpYG' --stack 'swarm-test-stack'
```

> <i>NOTE:</i> Like in the first setup part, please keep checking the deployment status using the `sudo docker service ls` command. DO NOT proceed before ALL services for this stack have been replicated (all should read at least `1/X` and NOT `0/X`). This might take quite some time. Please be patient, otherwise dependency problems might occur.

## Configuration ##

### Configure Keyrock (Identity Manager) ###

Keyrock is the FIWARE component responsible for central Identity Management (IdM) on the platform.  
Go to following website: <b><i>https://<span></span>accounts.<code>&lt;domain-name&gt;</code></i></b>

#### Change admin user credentials ####

You can log in with the admin account that was automatically created with the second part of the setup script.

E-mail: `admin@test.com`  
Password: `1234`

> <i>NOTE:</i> It is strongly recommended to change the account. The e-mail address must correspond to a real one that you can actually access.

<p align="center">
	<img src="docs/img/keyrock/keyrock_sign_in_marked.png" alt="Image of Keyrock admin user sign-in" width="80%">
</p>

After logging in, click on `Users` in the main menu and then select the `Select action` field in the admin user entry.  
Select `Edit` and specify a new e-mail address in the window that opens. Apply the change by clicking on `Save`.
To change the password, select `'Select action' -> 'Change password'`, enter your new password and accept it by clicking `Save`.

<p align="center">
	<img src="docs/img/keyrock/keyrock_edit_admin_user_marked.png" alt="Image of Keyrock edit admin user action" width="80%">
</p>

Finally log out in the upper right corner via `'admin' -> 'Sign Out'`.

#### Create a standard user ####

Go to <b><i>https://<span></span>accounts.<code>&lt;domain-name&gt;</code>/sign_up</i></b> to sign up a first standard (non-admin) user on the platform:

<p align="center">
	<img src="docs/img/keyrock/keyrock_sign_up_marked.png" alt="Image of Keyrock standard user sign-up" width="80%">
</p>

You will then receive an e-mail with a confirmation link. Click this link to complete registration and you will be redirected to the Keyrock login page. Test your account creation by logging in with your registered credentials.  
The `Home` screen shows that the user is not yet a member of any organization. He is also not authorized by any application. This will change in the course of the following configuration sections.

<p align="center">
	<img src="docs/img/keyrock/keyrock_home_empty.png" alt="Image of Keyrock Home screen" width="80%">
</p>

#### Organizations and applications ####

After logging in to Keyrock as admin, you can see all registered applications and organizations on the `Home` screen. By default there are none, but in this case the setup script created two OAuth2 applications.

The `API Catalogue` application will authorize user access to the various API resources. The authorization is primarily defined by so-called tenants for which a user gets read and/or write access. A tenant corresponds to an organization in Keyrock. The setup of tenants (and thus Keyrock organizations) is explained in the section [Tenant-Manager](#tenant-manager-1) -> [Manage Tenants (List tab)](#manage-tenants-list-tab).

The `Market` application authorizes users to access the Smart Platform marketplace, where digital assets, such as access to certain API resources, can be offered and purchased as products. Marketplace users must be assigned to specific roles for this purpose as well. A brief overview of the marketplace is given in section [Configure Marketplace (based on Biz Framework)](#configure-marketplace-based-on-biz-framework).

<p align="center">
	<img src="docs/img/keyrock/keyrock_home_applications.png" alt="Image of Keyrocks application overview" width="80%">
</p>

#### Roles and permissions ####

##### Standard roles #####

There are some standard roles automatically created while running the second setup script. These roles are required by certain platform services and are created within a Keyrock application in order to allow role-based user authorization by that application. The roles themselves have permissions assigned specifying access rights for resources a user requests.

Standard roles `tenant-admin`, `data-provider`, `data-consumer` are required by the <b>Tenant-Manager</b> service that is integrated into APInf.  
Look into the [Tenant-Manager](#tenant-manager-1) section for more information.

Standard roles `seller`, `customer`, `orgAdmin`, `admin` are required by the <b>Marketplace</b> service.  
Look into the [Marketplace configuration](#configure-marketplace-based-on-biz-framework) section for more information.

Application <b>API Catalogue</b> uses these roles: `tenant-admin`, `data-provider`, `data-consumer`  
Application <b>Market</b> uses these roles: `seller`, `customer`, `orgAdmin`, `admin`, `data-provider`, `data-consumer`

##### Custom roles #####

Additional custom roles with different resource permissions can be added at any time.

> <i>NOTE:</i> In the case of the Smart Platform, an initial role `orionNGSIv2-provider` must be created in the application `API Catalogue`, which has permissions for full access via GET/POST/PUT/PATCH/DELETE to the API of the Orion v2 Context Broker.
The role allows the user acting as API provider to initially create, modify and delete data in Orion v2 via the platform. Of course, the scope of access should be customized to the actual needs.

Similarly, for the Orion LD Context Broker, one would create the role `orionNGSI-LD-provider` accordingly.

Which user is appointed as API provider is usually determined by the platform operator's company policy. Usually it is the administrator (e.g. the same person as the tenant admin) who sets up and maintains the platform and manages the access of users to data resources.

##### Create role #####

To create and assign such a custom `orionNGSI-LD-provider` role, bring up the `API Catalogue`s application view and click in the upper part of the window on `manage roles` to open the role management area for this specific application:

<p align="center">
	<img src="docs/img/keyrock/keyrock_apicatalogue_manage_roles.png" alt="Image of Keyrocks application overview" width="80%">
</p>

Press the + symbol above the left column to create a new role. Enter the name of the role - in this case `orionNGSIv2-provider` - and save it.  
The new role appears in the list. Select it to show the permissions list on the right:

<p align="center">
	<img src="docs/img/keyrock/keyrock_apicatalogue_add_role.png" alt="Image of Keyrocks application overview" width="80%">
</p>

##### Create permission #####

Press the + symbol above the permissions column to create a new permission.  
An input form appears where the HTTP method and the resource path for the access rule are defined. With the rule `GET /v2/.*` all Orion v2 resources below the path `/v2/` may be queried. It is important here that the checkbox `Is regular expression?` is checked, because we have defined a wildcard with the regular expression `.*`.

Save this permission and add four more rules for the HTTP methods POST, PUT, PATCH and DELETE in the same way.

<p align="center">
	<img src="docs/img/keyrock/keyrock_apicatalogue_add_role_permission.png" alt="Image of Keyrocks application overview" width="80%">
</p>

##### Assign permission to role #####

Now that all permissions for the new role have been defined, select them by clicking on them. A checkmark should appear in front of each selected permission. Make sure that the role you want to assign the permissions to is still selected (dark blue color), otherwise the assignment might not work. Finally click `Save` to save the permission assignment:

<p align="center">
	<img src="docs/img/keyrock/keyrock_apicatalogue_assign_role_permissions.png" alt="Image of Keyrocks application overview" width="80%">
</p>

##### Assign role to user #####

Go back to the `Authorized users` panel of the `API Catalogue` application. Click on `Authorize` and appoint a user as Orion v2 provider by assigning the new role via role selector.  
Theoretically you can assign any user to this role. However, it would be inconsistent to assign a role with full access to a user who, for example, has already been classified as a `data-consumer` by the tenant admin (see [Manage Tenants (List tab)](#manage-tenants-list-tab)).  
Therefore, to give users read-only rights, another role should be created that only allows access via HTTP method GET: e.g. `orionNGSIv2-consumer`.

<p align="center">
	<img src="docs/img/keyrock/keyrock_apicatalogue_authorize_user_custom_role_assignment.png" alt="Image of Keyrocks application overview" width="80%">
</p>

### Configure Umbrella (API Management Framework) ###

As already pointed out in the deployment chapter, Umbrella acts as a web proxy and layer above the Smart Platform APIs and serves as a gatekeeper to enforce access control to the backend applications. 

Login with the previously created Umbrella admin account to see/make the following settings.

#### Website Backends ####

In the `Website Backends` section, an entry is configured for each website / web application of the Smart Platform. This configuration is already done by the second setup script.

Each entry contains a frontend<->backend mapping, which sets the rule for forwarding from the external hostname to the internal backend server (including service port and protocol).
For example, `accounts.<domain-name>` forwards to the internal service with the hostname `keyrock`, which listens for HTTP traffic on port 3000:

<p align="center">
	<img src="docs/img/umbrella/umbrella_web_backends_list_and_edit_mask.png" alt="Image of Web Backend list in Umbrella and open edit mask of an entry" width="80%">
</p>

#### API Backends ####

`API Backends` are similar to website backends, except that they control access to APIs instead. These include internal adiministrative APIs such as the Umbrella Admin API or the Keyrock API, which were used during the setup of the platform to programmatically set up initial Website Backends or Keyrock applications.
But also requests to data services like the Orion Context Broker are controlled and authenticated or authorized here.

Umbrella distinguishes between two IdP (Identity Provider) modes.
In `Authentication` mode, only an identity check of the user takes place, based on his access data. Whether further requirements must be fulfilled (e.g. certain role memberships) so that he can access certain API resources, is decided afterwards by means of Umbrella request settings. 
In `Authorization` mode, the access authorization is checked by an external instance alone and granted if the prerequisites are met.

In the case of the Orion Context Broker, user authorization is to take place outside Umbrella in Keyrock as the central IdM. The API Backend needed for this is automatically created when setting up the Orion v2 API in APInf. For further configuration instructions, please refer to section [Orion v2 Context Broker](#orion-v2-context-broker) -> [Umbrella API Backend](#umbrella-api-backend).

Access to the Tenant-Manager and Keyrock internal APIs also requires API backend configurations. These are explained in the following sections.

##### Tenant-Manager #####

In order for a user to manage tenants in the Tenant-Manager of the APInf portal, he not only needs membership in the `tenant-admin` role, but also access to the `tenantmanager` backend service. For this purpose, the user is authenticated by Umbrella in the background at the Keyrock application `API Catalogue`.

Go to `'Configuration' -> 'API Backends'` and click `Add API Backend`. Configure the API Backend as shown, scroll down the page and press `Save`:

<p align="center">
	<img src="docs/img/umbrella/umbrella_api_backend_tenant_manager.png" alt="Image of Umbrella API Backend configuration for Tenant-Manager" width="80%">
</p>

Always publish the current configuration so that the changes take effect:

<p align="center">
	<img src="docs/img/umbrella/umbrella_api_backend_publish_changes.png" alt="Image of Umbrella API Backend configuration publishment" width="80%">
</p>

##### Keyrock Token Service #####

Each user registered with Keyrock needs a token to access the services secured by Keyrock applications. The access token can be queried via the Keyrock API and contains coded information about the user's permissions.
The connection to the Keyrock API must be implemented via another API Backend in Umbrella. The concrete usage takes place in APInf in the [Authorization tab](#generate-access-token-authorization-tab) of the Tenant-Manager.

Go to `'Configuration' -> 'API Backends'` and click `Add API Backend`. Configure the API Backend as shown, scroll down the page and press `Save`:

<p align="center">
	<img src="docs/img/umbrella/umbrella_api_backend_keyrock_token_service.png" alt="Image of Umbrella API Backend configuration for Keyrock Token Service" width="80%">
</p>

And as with the Tenant-Manager, you have to publish the current configuration so that the changes take effect:

<p align="center">
	<img src="docs/img/umbrella/umbrella_api_backend_publish_changes.png" alt="Image of Umbrella API Backend configuration publishment" width="80%">
</p>

### Configure APInf (API Management Framework) ###

Open <b><i>https://<span></span>apis.<code>&lt;domain-name&gt;</code>/sign-up</i></b> in your browser and register the first user - the admin - for the installed [APInf](https://github.com/apinf/platform) platform service. APInf is an API management framework that can be used to store APIs, manage their access, document endpoints, and view access analytics. 

<p align="center">
	<img src="docs/img/apinf/apinf_first_signup.png" alt="Image of first APInf signup" width="80%">
</p>

#### Preferences ####

After logging in, the dashboard appears. Click on the gear icon at the top right to make the first configurations.

The item `Branding` will not be looked at in more detail in this configuration guide. Here you would have the possibility to customize the appearance of the portal a bit and to further personalize it by uploading logos, social media links or your own privacy policies and terms of use. 

First select the menu item `Settings`, then we go to `Proxies` and finally we configure the `Login Platforms`.

<p align="center">
	<img src="docs/img/apinf/apinf_preferences_menu.png" alt="Image of APInf preferences menu" width="80%">
</p>

In the settings, you store an e-mail account if you want to send or receive e-mails on behalf of the portal. E.g. take the same SMTP data that was already passed during the execution of setup script #1.

If you want to allow standard users as well as administrators to add new APIs, check the first checkbox accordingly.

<p align="center">
	<img src="docs/img/apinf/apinf_settings_page_part1.png" alt="Image of APInf settings page - part one" width="80%">
</p>

Disable the login methods `Github` and `Hsl id` (this removes the buttons `Configure Github` and `Configure Hsl` from the sign-up page). After that, users can only sign up via OAuth 2.0 with FIWARE (Keyrock) or conventionally with username and password.  
The first variant applies to all Keyrock users who also want to log in to APInf.
The administrator of APInf (in our example `apinf_admin`) however has to log in with username and password, because his identity was created exclusively for the administration of APInf and is not managed by Keyrock.

<p align="center">
	<img src="docs/img/apinf/apinf_settings_page_part2.png" alt="Image of APInf settings page - part two" width="80%">
</p>

Create a proxy in Umbrella for the Orion Context Broker v2 service we are about to add. This will be used to configure which external URL will be used to access the Orion v2.  
In order for the configuration to be written to Umbrella via its Admin API, specify the API Key of the Umbrella standard user and the Auth Token of the Umbrella Admin, which were already used when running setup script #2.

<p align="center">
	<img src="docs/img/apinf/apinf_proxies_add.png" alt="Image of APInf proxy creation" width="80%">
</p>

With the configuration of the FIWARE login platform (OAuth 2.0 authorization server), we set Keyrock as the central authorization component. To do this, we specify the root URL to Keyrock and configure the application `API Catalogue` as the OAuth 2.0 client that authorizes user access to and in APInf.

<p align="center">
	<img src="docs/img/apinf/apinf_login_platforms.png" alt="Image of APInf login platform creation" width="80%">
</p>

Log into Keyrock with the admin account in a separate browser tab, click on `Applications`, then select the `API Catalogue` and expand the `OAuth2 Credentials` section to copy its `Client ID` and `Client Secret`:

<p align="center">
	<img src="docs/img/keyrock/keyrock_apicatalogue_oauth2_credentials.png" alt="Image of OAuth 2.0 credentials of Keyrock application 'API Catalogue'" width="80%">
</p>

For example, this application verifies if a user has the right to create a new tenant via the Tenant-Manager or to display a list of all existing tenants (see section [Tenant-Manager](#tenant-manager-1)).

It is also used to authorize the actual login to APinf. A successful configuration can be recognized by the sign-up or sign-in page. There is no longer `Configure Fiware` displayed, but `Register with Fiware` or `Sign In with Fiware`.
> <i>NOTE:</i> The configuration of the login platform is of fundamental importance for the OAuth 2.0 communication between APInf and Keyrock to work and for central components such as the Tenant-Manager to be used. 

Leave the rest of the settings untouched, scroll down the page and hit `Save`.

#### API setup ####

Switch to the `APIs` tab to add a new API:

<p align="center">
	<img src="docs/img/apinf/apinf_apis_add_new.png" alt="Image of button for API creation in APInf" width="80%">
</p>

##### Orion v2 Context Broker #####

We create an API entry for the Orion v2 Context Broker and specify `http://orion.docker` as the API Host URL:

<p align="center">
	<img src="docs/img/apinf/apinf_apis_orionv2_add_new_page.png" alt="Image of API creation for Orion v2 Context Broker in APInf" width="80%">
</p>

Go to `'Settings' -> 'General'` and change the visibility of the API to `PUBLIC`, so that the API is also accessible from outside the server:

<p align="center">
	<img src="docs/img/apinf/apinf_api_orionv2_general_settings.png" alt="Image of API general settings for Orion v2 Context Broker in APInf" width="80%">
</p>

Switch to the `Network` tab and adjust the base paths. These are `/v2/` by default for the Orion v2. The host part of the URLs are already taken from the corresponding proxy configuration or from the `API Host URL` setting of the API. The broker service listens on port 1026.

The API Key Requirement must be deactivated, because the access to the context broker is controlled by access tokens, which a user can generate in the `Authorization` Tab of the Tenant-Manager integration via the Keyrock API (see section [Generate access token (Authorization tab)](#generate-access-token-authorization-tab)).

<p align="center">
	<img src="docs/img/apinf/apinf_api_orionv2_network_settings_part1.png" alt="Image of API network settings - part one - for Orion v2 Context Broker in APInf" width="80%">
</p>

Open the `Advanced settings` and enter the client ID of the `API Catalogue` application in Keyrock under `IDP App Id` as well. This tells Umbrella in Authorization mode that all requests to the Orion v2 Context Broker must first be authorized by the `API Catalogue`.

<p align="center">
	<img src="docs/img/apinf/apinf_api_orionv2_network_settings_part2.png" alt="Image of API network settings - part two - for Orion v2 Context Broker in APInf" width="80%">
</p>

Leave the rest of the settings untouched, scroll down the page and press `SAVE CONFIGURATION`. This will create the API Backend for the Orion Context Broker v2 in Umbrella.

###### Umbrella API Backend ######

The API configuration in APInf automatically created an API backend in Umbrella.

Login to Umbrella, go to `'Configuration' -> 'API Backends'` and click the existing entry for `Orion Context Broker v2`. Adapt the `Global Request Settings` of the API Backend to have external authorization enabled:

<p align="center">
	<img src="docs/img/umbrella/umbrella_api_backend_orionv2_adaption.png" alt="Image of adapted Umbrella API Backend configuration for Orion Context Broker v2" width="80%">
</p>

Scroll down the page and press `Save`.  
And as with all API Backends, don't forget to publish the current configuration so that the changes take effect:

<p align="center">
	<img src="docs/img/umbrella/umbrella_api_backend_publish_changes.png" alt="Image of Umbrella API Backend configuration publishment" width="80%">
</p>

#### Tenant-Manager ####

The Tenant-Manager provides tenant-based access control to API resources. For this purpose, an organization with the same name is created in Keyrock for each tenant.  
The idea is to manage user groups per organizational unit and to provide the users with different access rights within these groups.  

The concept of the tenant manager is based on the multi-tenancy implementation of the Orion Context Broker. By specifying a special HTTP header `Fiware-Service`, it is also possible to store organization-specific context data in logically separated databases at the data storage level. To retrieve the data from a specific organization database, this header must also be specified.

> <i>NOTE:</i> At least one APInf standard user in the role `tenant-admin` is required to create tenants (Keyrock organizations) and to define other users in a tenant as `data-consumer` or `data-provider`.

Since the login platform (authorization server) in APInf has been configured with the client ID of the Keyrock application `API Catalogue`, requests from API users must also be authorized by this application. A user with the task of managing tenants must therefore be authorized in advance by assigning him the role `tenant-admin`.

Therefore, log in to Keyrock with the admin account and specify the first user to be tenant admin. 
Click on `Applications`, then select the `API Catalogue` and press the `Authorize` button in the `Authorized users` section:

<p align="center">
	<img src="docs/img/keyrock/keyrock_apicatalogue_authorize_user.png" alt="Image of user authorization in Keyrock application 'API Catalogue'" width="80%">
</p>

In the left pane, search for the user you want to authorize as the tenant manager. Add him to the list of authorized users with the + symbol and then assign him the role `tenant-admin` in the role selection.
Finally, save the changes and log out:

<p align="center">
	<img src="docs/img/keyrock/keyrock_apicatalogue_authorize_user_role_assignment.png" alt="Image of user authorization in Keyrock application 'API Catalogue' with role assignment" width="80%">
</p>

Next, log out the admin from APInf and log in the standard user in the role `tenant-admin`. Use the "Sign in with FIWARE" button to get authorized by Keyrock.

##### Generate access token (Authorization tab) #####

Like a consumer/provider who wants to gain access to the Orion Context Broker API, a tenant admin must first have an access token generated in order to be able to manage the tenants.

Go to the `Tenants` page and select the `Authorization` tab. Confirm your identity by providing your password and press `GET NEW TOKEN`. This should display a new access token in JSON format:

<p align="center">
	<img src="docs/img/apinf/apinf_tenant_manager_authorization_tab.png" alt="Image of Authorization tab in APInf's Tenant-Manager" width="80%">
</p>

> <i>NOTE:</i> Keep your access token in a safe place. It is your access key to the platform services. After generation, it will be displayed only once! If you forget it and come back to the page because you want to look it up, you won't see it and will have to have a new one generated instead.

> <i>NOTE:</i> An access token is invalidated every 48 hours. After that, a new one must be created. As an application provider in Keyrock (per default the admin user only) you could set the lifetime of an access token in an application under the `OAuth2 Credentials` section to `permanent`, but for security reasons we strongly discourage you to do this!

##### Manage Tenants (List tab) #####

Let's create a new tenant. Go to the `Tenants` page and select the `List` tab. Press `ADD TENANT`.

First of all, fill in the tenant information. Tenant names must contain only lowercase letters and numbers.  
Next, select a user from the list and add it to the tenant with `ADD USER FOR TENANT` (for demonstration purposes, the user `bob` has been additionally registered in Keyrock in the meantime).  
Decide whether the user has read-only (role `data-consumer`) or additional write access (role `data-provider`) to APIs and select the corresponding checkbox.  
Keep `Notify User` checked in case you want the user to be notified of the addition via email.

Finally, press `ADD TENANT` to complete the process.

<p align="center">
	<img src="docs/img/apinf/apinf_tenant_manager_add_tenant.png" alt="Image of tenant creation in APInf's Tenant-Manager" width="80%">
</p>

The new tenant should appear in the list:

<p align="center">
	<img src="docs/img/apinf/apinf_tenant_manager_list_tab.png" alt="Image of List tab in APInf's Tenant-Manager" width="80%">
</p>

> <i>NOTE / WARNING:</i> Due to the implementation, changes (user/role assignments) and deletions of tenants should ALWAYS be done via the Tenant-Manager in APInf, as currently changes are only synchronized towards Keyrock. The deletion of an organization in Keyrock, for example, would not lead to the deletion of the tenant in the Tenant-Manager!

###### Effects on Keyrock settings ######

Log back into Keyrock as admin to see the effect of the tenant creation.

In the `Home` screen, the first organization appears with the same name as the tenant. Select it to access its details page.  
You can see from the member list that besides `bob`, which was just added using the Tenant-Manager, `alice` and `admin` are also listed.  
This is because `alice` as the creator of the tenant is automatically added to the member list as an `owner` and admin users are allowed to do anything anyway and thus become an `owner` as well.  
`bob` and all other added users are "only" `member`s of the organization.

<p align="center">
	<img src="docs/img/keyrock/keyrock_organization_details.png" alt="Image of a Keyrock organisation's details page" width="80%">
</p>

A click on `Manage` opens the member manager of the organization, which makes this member classification clear:

<p align="center">
	<img src="docs/img/keyrock/keyrock_organization_members.png" alt="Image of a Keyrock organisation's member manager" width="80%">
</p>

We can also see that an organization created by Tenant-Manager automatically authorizes all existing applications and vice versa.

For example, under `Applications` we select `API Catalogue`. If we scroll down to the `Authorized organizations` section, the newly created organization will be listed there.  
Press the `Authorize` button. In the right pane of the window that opens, click on the role selector next to the new organization. The `owner` and `member` should be assigned there ONLY to the tenant roles `data-consumer` and `data-provider` respectively. The assignment should be the same as in the Tenant-Manager.

> <i>NOTE:</i> Any other role should be assigned directly to a user in the `Authorized users` area of the respective application as explained in section [Assign role to user](#assign-role-to-user).

<p align="center">
	<img src="docs/img/keyrock/keyrock_apicatalogue_authorize_org_role_assignment.png" alt="Image of organization authorization in Keyrock application 'API Catalogue' with role assignment" width="80%">
</p>

### Configure Marketplace (based on Biz Framework) ###

#### NGSI Plugin ####

The basic functionality and usage of the marketplace is not the subject of this section. For more information about the framework, please refer to its [main documentation](https://github.com/FIWARE-TMForum/Business-API-Ecosystem).

The platform is intended to provide the ability to monetize access to NGSI data. In the case of this Smart Platform, data is provided using APIs configured in the APInf portal. 
Access to specific data of an API can be offered and purchased in the form of a product on the marketplace. For this purpose, a plugin was developed that allows providers to sell certain NGSI v2 or NGSI-LD data via the marketplace of this platform. To learn more about the plugin used here, please refer to the documentation of the [BAE SmartMaaS NGSI Plugin](https://github.com/SmartMaaS-Services/bae-smartmaas-ngsi).

> <i>NOTE:</i> Since the plugin is designed to work with other components of the Smart Platform, such as Keyrock, the Tenant-Manager and Umbrella, it cannot be guaranteed to work in other environments.

#### Roles ####

As already pointed out in section [Standard Roles](#standard-roles), there are two standard roles that a marketplace user must have in order to be able to offer (role `seller`) or buy (role `customer`) products on the marketplace.  
In the role `admin` a user is allowed to do the global administration and as `orgAdmin` he is allowed to manage an organization in the marketplace.

In addition, all buyers of a product are assigned to a product-specific role, which is automatically created by the plugin in Keyrock during the product creation process. These roles contain permissions that restrict access to the purchased resource.

<p align="center">
	<img src="docs/img/marketplace/marketplace_customer_roles.png" alt="Image of Marketplace customer roles in Keyrock" width="80%">
</p>

## Tests ##

### NGSI v2 context data  ###

The following initial tests are only intended to check whether NGSI v2 context data can be successfully stored and also retrieved with the present platform configuration. For a detailed description of usage, please refer to the [NGSI v2 Specification](http://fiware.github.io/specifications/ngsiv2/stable/).

#### POST data ####

As an NGSI v2 provider, let's first load initial data into the Orion v2 Context Broker we set up in section [Orion v2 Context Broker](#orion-v2-context-broker) on the APInf platform.  
As user `alice` in tenant role `data-provider` and custom role `orionNGSIv2-provider`, we should have all necessary permissions to send data to Orion v2 using POST request. 

In the request header `Fiware-Service` we pass the name of the tenant for which we want to store context data in the broker as `data-provider`. The header must contain, followed by the word `Bearer` and a space, the access token, which we have generated as `alice` in the `Authorization tab` of the tenant manager.  
The HTTP body, the payload of the request, contains the actual data we want to send. As an example we send a `WeatherObserved` entity as JSON formated object:

```js
curl --location --request POST 'https://context.example.org/v2/entities' \
--header 'Content-Type: application/json' \
--header 'Fiware-Service: exampleinc' \
--header 'Authorization: Bearer 4543a954065073f235e776861e3d96bd8a8b49e3' \
--data-raw '{
    "id": "DHT22_8892",
    "type": "WeatherObserved",
    "dateObserved": {
        "type": "DateTime",
        "value": "2021-03-30T08:43:04.00Z",
        "metadata": {}
    },
    "location": {
        "type": "geo:json",
        "value": {
            "type": "Point",
            "coordinates": [
                10.118,
                54.332
            ]
        },
        "metadata": {}
    },
    "refDevice": {
        "type": "Relationship",
        "value": "Device_4482",
        "metadata": {}
    },
    "relativeHumidity": {
        "type": "Number",
        "value": 0.999,
        "metadata": {}
    },
    "stationName": {
        "type": "Text",
        "value": "DHT22_8892",
        "metadata": {}
    },
    "temperature": {
        "type": "Number",
        "value": 7.6,
        "metadata": {}
    }
}'
```

On success, the server should reply with a `201 Created` and an empty HTTP body.

#### GET data ####

Now to query the created entity with the same user, we send a GET request to the Orion v2, again specifying the `Fiware-Service` and the `Authorization` header as before:

```js
curl --location --request GET 'https://context.example.org/v2/entities?id=DHT22_8892' \
--header 'Fiware-Service: exampleinc' \
--header 'Authorization: Bearer 4543a954065073f235e776861e3d96bd8a8b49e3'
```

On success, the server should reply with a `200 OK` and contain the requested entity object in the HTTP body:

```js
[
    {
        "id": "DHT22_8892",
        "type": "WeatherObserved",
        "dateObserved": {
            "type": "DateTime",
            "value": "2021-03-30T08:43:04.00Z",
            "metadata": {}
        },
        "location": {
            "type": "geo:json",
            "value": {
                "type": "Point",
                "coordinates": [
                    10.118,
                    54.332
                ]
            },
            "metadata": {}
        },
        "refDevice": {
            "type": "Relationship",
            "value": "Device_4482",
            "metadata": {}
        },
        "relativeHumidity": {
            "type": "Number",
            "value": 0.999,
            "metadata": {}
        },
        "stationName": {
            "type": "Text",
            "value": "DHT22_8892",
            "metadata": {}
        },
        "temperature": {
            "type": "Number",
            "value": 7.6,
            "metadata": {}
        }
    }
]
```

> <i>TIP:</i> Experiment a bit with the permissions and see how the server responses change. E.g. you could remove the role `orionNGSIv2-provider` from the creating user or change its permissions. Also the use of an invalid or foreign access token of another user could be possible. 

## Services incorporated ##

```
apinf, bae, bae_apis, bae_charging, bae_elasticsearch, bae_mysql, bae_rss, cadvisor, ckan, datapusher, db, grafana, iot-agent, iotagent-lora, jobmanager, keyrock, keyrock_mysql, knowage, knowagedb, kurento, mail, mongo, mongo-ld, nginx, ngsiproxy, nifi, orion, orion-ld, perseo-core, perseo-fe, quantumleap, quantumleap_redis, quantumleapcrate, redis, solr, taskmanager, tenantmanager, tokenservice, umbrella, umbrella_elasticsearch, wirecloud, wirecloud_elasticsearch, wirecloud_memcached, wirecloud_postgres, wirecloudnginx, zookeeper
```

After executing both setup scripts, all of the following Docker services above (currently 46) should be up and running.

Verify using
```bash
sudo docker ps -a
```

<p align="center">
	<img src="docs/img/setup/docker_ps_a.png" alt="Output of command: sudo docker ps -a" width="80%">
</p>

or using
```bash
sudo docker service ls
```

<p align="center">
	<img src="docs/img/setup/docker_stack_service.png" alt="Output of command: sudo docker service ls" width="80%">
</p>

## Platform flowchart ##

<p align="center">
	<img src="docs/img/platform/platform_flowchart.png" alt="Flowchart for communication flow between platform components" width="80%">
</p>

## Known issues ##

### Missing or unreplicated Docker services ###

When checking the list of Docker services on your VM, you may notice that some of them are missing. While deploying the YML services for the Smart Platform by executing the command `sudo docker stack deploy -c <YML-file>...` in part 1 of the setup script, not all of the specified services make it into the Swarm stack for reasons unknown so far, which is why required containers are missing. This leads to other containers being continuously exited and restarted because the depending services they contain cannot be connected to the needed services.  
If you afterwards find one or more exited container for a specific service listed by `sudo docker ps -a`, you are safe removing these containers via `sudo docker rm <container>`.

Hence it may be necessary to manually repeat the `sudo docker stack deploy -c <YML-files>...` command several times to finally have all needed services in Docker Swarm. The output of this command should give a good hint whether deployment was successful or not. The line `Creating service <swarm-stack-name>_<service-name>` is usually a good sign.

The problem could be related to different start times during deployment. This is the case, for example, if a required service has not yet been placed in the Swarm stack because it is still being deployed, but another service that needs it is already operational.

> <i>NOTE:</i> It may also take some time to get ALL services up and running. The number of REPLICAS for a service may be displayed as 0 for a few minutes until the associated Docker container is finally created and started. Please be patient at this point and give the process some time to complete. Also keep checking the status using `sudo docker service ls`. Accordingly, it can happen that the containers remain in the "Created" state for quite a while before switching to "Up". This is not problematic per se, but could lead to the dependency problems mentioned above.

## ToDo ##

* <b>Configuration of Orion-LD</b>  
	
	...is not covered by this setup documentation. The steps required are analogous to those for Orion v2 setup (see affected configuration sections for [Keyrock](#configure-keyrock-identity-manager), [APInf](#configure-apinf-api-management-framework) and [Umbrella](#configure-umbrella-api-management-framework)).

	This being said, it should be clear that the `API Host URL` configured in APInf under `<Orion-LD API> -> 'Settings' -> 'General'` must be a different one (`http://orion-ld.docker`) and also that another platform proxy for the Orion-LD Context Broker must be added under `'Platform preferences' -> 'Proxies'`. This must accordingly have the URL `https://contextld.<domain-name>`.  
	The base path under `<Orion-LD API> -> 'Settings' -> 'Network'` must also be `/ngsi-ld/v1/` instead of `/v2/` so that in the end the API URLs differ as follows:

	Orion v2:

	<p align="center">
		<img src="docs/img/todo/todo_orionv2_api_url.png" alt="Output of command: sudo docker ps -a" width="80%">
	</p>

	Orion-LD:

	<p align="center">
		<img src="docs/img/todo/todo_orionld_api_url.png" alt="Output of command: sudo docker ps -a" width="80%">
	</p>

* <b>Clean project files</b>  
	
	There are still Docker YAML files left in the `services` directory which came from the original project, but are currently not used in this "slim starter" project. Same applies to some configuration files in the `config` directory. They should be edited or deleted.  
	And of course the list of [incorporated services](#services-incorporated) and needed subdomains in the [Technical requirements](#technical-requirements) section should be updated at some point.

## Contribution ##

Pull requests are welcome. Please make sure to update tests as appropriate.
Git conventions are being followed and changes go to development only from feature/bugfix branches.

## License ##

Smart-Platform-Services is licensed under Affero General Public License (GPL) version 3.

© 2020-2021 FIWARE Foundation
