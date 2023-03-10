<div align="center">
  <img src="https://raw.githubusercontent.com/moreload/moreload/trunk/public/moreload_small.png"/>

A ShareX/file upload server that is easy to use, packed with features, and with an easy setup!

![Stars](https://img.shields.io/github/stars/moreload/moreload?logo=github&style=flat)
![Version](https://img.shields.io/github/package-json/v/moreload/moreload?logo=git&logoColor=white&style=flat)
![GitHub last commit (branch)](https://img.shields.io/github/last-commit/moreload/moreload/trunk?logo=git&logoColor=white&style=flat)
[![Discord](https://img.shields.io/discord/519024057874907156?color=%23777ed3&label=discord&logo=discord&logoColor=white&style=flat)](https://dyonic.me/discord)

![Build](https://img.shields.io/github/actions/workflow/status/moreload/moreload/build.yml?logo=github&style=flat&branch=trunk)
[![Docker Image (trunk)](https://img.shields.io/github/actions/workflow/status/moreload/moreload/docker.yml?label=Docker%20%28trunk%29&logo=github&style=flat&branch=trunk)](https://github.com/moreload/moreload/pkgs/container/moreload/?tag=trunk)
[![Docker Image (release)](https://img.shields.io/github/actions/workflow/status/moreload/moreload/docker-release.yml?label=Docker%20%28release%29&logo=github&style=flat&branch=trunk)](https://github.com/moreload/moreload/pkgs/container/moreload/?tag=latest)

</div>

## Features

- Configurable
- Fast
- Built with Next.js & React
- Token protected uploading
- Image uploading
- Image compression
- Password Protected Uploads
- URL shortening
- Text uploading
- URL Formats (uuid, dates, random alphanumeric, original name, zws)
- Discord embeds (OG metadata)
- Gallery viewer, and multiple file format support
- Code highlighting
- Fully customizable Discord webhook notifications
- OAuth2 registration (Discord and GitHub)
- Two-Factor authentication with Google Authenticator, Authy, etc (totp services).
- User invites
- File Chunking (for large files)
- File deletion once it reaches a certain amount of views
- Easy setup instructions on [docs](https://moreload.vercel.app/) (One command install `docker-compose up -d`)

# Usage

## Install & run with Docker

This section requires [Docker](https://docs.docker.com/get-docker/) and [docker-compose](https://docs.docker.com/compose/install/).

```shell
git clone https://github.com/moreload/moreload
cd moreload

docker-compose up -d
```

### After installing

After installing, please edit the `docker-compose.yml` file and find the line that says `SECRET=changethis` and replace `changethis` with a random string.
Ways you could generate the string could be from a password managers generator, or you could just slam your keyboard and hope for the best.

## Building & running from source

This section requires [nodejs](https://nodejs.org), [yarn](https://yarnpkg.com/) or [npm](https://npmjs.com).

```shell
git clone https://github.com/moreload/moreload
cd moreload

# npm install
yarn install
# npm run build
yarn build
# npm start
yarn start
```

# NGINX Proxy

This section requires [NGINX](https://nginx.org/).

```nginx
server {
  listen 80 default_server;
  client_max_body_size 100M;
  server_name <your domain (optional)>;
  location / {
    proxy_pass http://localhost:3000;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
  }
}
```

# Website

The default port is `3000`, once you have accessed it you can see a login screen. The default credentials are "administrator" and "password". Once you login please immediately change the details to something more secure. You can do this by clicking on the top right corner where it says "administrator" with a gear icon and clicking Manage Account.

# ShareX (Windows)

This section requires [ShareX](https://www.getsharex.com/).

After navigating to MoreLoad, click on the top right corner where it says your username and click Manage Account. Scroll down to see "ShareX Config", select the one you would prefer using. After this you can import the .sxcu into sharex. [More information here](https://moreload.vercel.app/docs/guides/uploaders/sharex)

# Flameshot (Linux)

This section requires [Flameshot](https://www.flameshot.org/), [jq](https://stedolan.github.io/jq/), and [xsel](https://github.com/kfish/xsel).

<details>
  <summary>Wayland instructions</summary>
  
If using wayland you will need to have [wl-clipboard](https://github.com/bugaevc/wl-clipboard) installed, for the `wl-copy` command.

If you are not using GNOME/KDE/Qtile/Sway, and are using something like a wlroots-based compositor (ex. [Hyprland](https://github.com/hyprwm/Hyprland/), [River](https://github.com/riverwm/river), etc), you will need to set the `XDG_CURRENT_DESKTOP` environment variable to `sway`, which will just override it for this script. Adding `export XDG_CURRENT_DESKTOP=sway` to the start of the script will work.

After this, replace the `xsel -ib` with `wl-copy` in the script.

</details>

You can either use the script below, or generate one directly from MoreLoad (just like how you can generate a ShareX config).
To upload files using flameshot we will use a script. Replace $TOKEN and $HOST with your own values, you probably know how to do this if you use linux.

```shell
DATE=$(date '+%h_%Y_%d_%I_%m_%S.png');
flameshot gui -r > ~/Pictures/$DATE;

curl -H "Content-Type: multipart/form-data" -H "authorization: $TOKEN" -F file=@$1 $HOST/api/upload | jq -r 'files[0].url' | xsel -ib
```

# Contributing

## Bug reports

Create an issue on GitHub and use the template, please include the following (if one of them is not applicable to the issue then it's not needed):

- The steps to reproduce the bug
- Logs of MoreLoad
- The version of MoreLoad
- Your OS & Browser including server OS
- What you were expecting to see

## Feature requests

Create a discussion on GitHub, please include the following:

- Brief explanation of the feature in the title (very brief please)
- How it would work (Be detailed!)

## Pull Requests (contributions to the codebase)

Create a pull request on GitHub. If your PR does not pass the action checks, then please fix the errors. If your PR was submitted before a release, and I have pushed a new release, please make sure to update your PR to reflect any changes, usually this is handled by GitHub.
