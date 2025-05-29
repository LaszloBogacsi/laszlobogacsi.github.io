---
title: HomeHub, 2 – Raspberry Pi
author: Laszlo Bogacsi
type: post
date: 2020-02-21T01:20:06+00:00
url: /2020/02/21/homehub-2-raspberry-pi/
coverCaption: Photo by [Anna Tukhfatullina Food Photographer/Stylist](https://unsplash.com/@anna_tukhfatullina?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/collections/9443025/personal-site%2C-portfolio?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)
timeline_notification:
  - 1582248007
categories:
  - Home automation
tags:
  - Balena Etcher
  - Raspberry Pi
  - Raspbian
  - ssh
---

> I’ve built a home automation system from scratch.  
> This is the 2nd part of a series of posts explaining the Why, What and How with code details.

Raspberry Pi Setup – balena etcher, headless mode setup, ssh, host, terminal access

## Getting Started

When buying a Pi you’ve got two options, either get it with NOOBS pre-installed on an SD card, or install Raspbian yourself.

Since I had an SD card, I chose the latter.

#### Balena

To flash Raspbian to the SD card use [Balena Etcher](https://www.balena.io/etcher/).

First download your favourite flavour of OS from [here](https://www.raspberrypi.org/downloads/). I decided I’d go with Raspbian without NOOBS.

Then install etcher with one of the described methods [here](https://github.com/balena-io/etcher).

On a Mac:

```shell
brew install --cask balenaetcher
```

When done, select the previously downloaded OS image and flash!

{{< figure src="balenaetcherflash.png" alt="Balena Etcher flashing" >}}

#### Connect To the Pi

If you’re like me and don’t have spare monitors and keyboard lying around, then you’d want to connect to your Pi over the network with SSH.

By default SSH is disabled in Raspbian, so you’ll need to pop the SD card into your laptop or external card reader and add an empty file called `ssh` at this location:

```shell
/Volumes/boot
```

If the file exists ssh will be enabled.

The default username is `pi` and the password is `raspberry`.

Connect the Pi to your network, wired or wireless.

Figure out the IP address of the pi or use the hostname which might be `raspberrypi`.

```shell
ssh pi@192.168.1.10
```

Once in, run this command to configure the Pi:

```shell
sudo raspi-config
```

Change your password, do this at least.

#### ssh without a password

To make further logins easier, generate a public/private keypair, copy the public key to the pi and login without entering a password.

To generate a keypair use:

```shell
ssh-keygen
```

Then copy the **public** key to the pi with (replace with your Pi’s IP):

```shell
ssh-copy-id -i ~/.ssh/id_rsa.pub 192.168.1.10
```

On the Pi your key will be appended to `.ssh/authorized_key`.

And voila, now you should be able to ssh into your remote Pi without needing to type your password.

And finally edit your hosts file at `/etc/hosts` and add a line like this:

```shell
192.168.1.10    pi
```

Now `ssh pi` should get you logged in to the raspberry pi.

#### Conclusion

So far we have our new tiny computer up and running, connected to our network and have ssh access to it.