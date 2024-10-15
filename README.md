# protocol.sh [![ZeroSSL](https://github.com/khulnasoft/protocol.sh/actions/workflows/ZeroSSL.yml/badge.svg)](https://github.com/khulnasoft/protocol.sh/actions/workflows/ZeroSSL.yml)
Unit test project for **protocol.sh** project https://github.com/khulnasoft/protocol.sh



# Here are the latest status:

| Platform | Status|
-----------|-------|
|FreeBSD| [![LetsEncrypt](https://github.com/khulnasoft/protocol.sh/actions/workflows/FreeBSD.yml/badge.svg)](https://github.com/khulnasoft/protocol.sh/actions/workflows/FreeBSD.yml) |
|OpenBSD| [![LetsEncrypt](https://github.com/khulnasoft/protocol.sh/actions/workflows/OpenBSD.yml/badge.svg)](https://github.com/khulnasoft/protocol.sh/actions/workflows/OpenBSD.yml) |
|NetBSD| [![LetsEncrypt](https://github.com/khulnasoft/protocol.sh/actions/workflows/NetBSD.yml/badge.svg)](https://github.com/khulnasoft/protocol.sh/actions/workflows/NetBSD.yml) |
|DragonFlyBSD| [![LetsEncrypt](https://github.com/khulnasoft/protocol.sh/actions/workflows/DragonFlyBSD.yml/badge.svg)](https://github.com/khulnasoft/protocol.sh/actions/workflows/DragonFlyBSD.yml) |
|pfsense| NA |
|Omnios| [![LetsEncrypt](https://github.com/khulnasoft/protocol.sh/actions/workflows/Omnios.yml/badge.svg)](https://github.com/khulnasoft/protocol.sh/actions/workflows/Omnios.yml)|
|solaris| [![LetsEncrypt](https://github.com/khulnasoft/protocol.sh/actions/workflows/Solaris.yml/badge.svg)](https://github.com/khulnasoft/protocol.sh/actions/workflows/Solaris.yml)|
|windows-cygwin| [![LetsEncrypt](https://github.com/khulnasoft/protocol.sh/actions/workflows/Windows.yml/badge.svg)](https://github.com/khulnasoft/protocol.sh/actions/workflows/Windows.yml)|
|ubuntu:latest| [![LetsEncrypt](https://github.com/khulnasoft/protocol.sh/actions/workflows/Linux.yml/badge.svg)](https://github.com/khulnasoft/protocol.sh/actions/workflows/Linux.yml)|
|debian:latest| [![LetsEncrypt](https://github.com/khulnasoft/protocol.sh/actions/workflows/Linux.yml/badge.svg)](https://github.com/khulnasoft/protocol.sh/actions/workflows/Linux.yml)|
|centos:latest| [![LetsEncrypt](https://github.com/khulnasoft/protocol.sh/actions/workflows/Linux.yml/badge.svg)](https://github.com/khulnasoft/protocol.sh/actions/workflows/Linux.yml)|
|fedora:latest| [![LetsEncrypt](https://github.com/khulnasoft/protocol.sh/actions/workflows/Linux.yml/badge.svg)](https://github.com/khulnasoft/protocol.sh/actions/workflows/Linux.yml)|
|opensuse/leap:latest| [![LetsEncrypt](https://github.com/khulnasoft/protocol.sh/actions/workflows/Linux.yml/badge.svg)](https://github.com/khulnasoft/protocol.sh/actions/workflows/Linux.yml) |
|alpine:latest| [![LetsEncrypt](https://github.com/khulnasoft/protocol.sh/actions/workflows/Linux.yml/badge.svg)](https://github.com/khulnasoft/protocol.sh/actions/workflows/Linux.yml)|
|oraclelinux:latest| [![LetsEncrypt](https://github.com/khulnasoft/protocol.sh/actions/workflows/Linux.yml/badge.svg)](https://github.com/khulnasoft/protocol.sh/actions/workflows/Linux.yml)|
|kalilinux/kali| [![LetsEncrypt](https://github.com/khulnasoft/protocol.sh/actions/workflows/Linux.yml/badge.svg)](https://github.com/khulnasoft/protocol.sh/actions/workflows/Linux.yml) |
|archlinux:latest| [![LetsEncrypt](https://github.com/khulnasoft/protocol.sh/actions/workflows/Linux.yml/badge.svg)](https://github.com/khulnasoft/protocol.sh/actions/workflows/Linux.yml)|
|mageia| [![LetsEncrypt](https://github.com/khulnasoft/protocol.sh/actions/workflows/Linux.yml/badge.svg)](https://github.com/khulnasoft/protocol.sh/actions/workflows/Linux.yml) |
|gentoo/stage3-amd64| [![LetsEncrypt](https://github.com/khulnasoft/protocol.sh/actions/workflows/Linux.yml/badge.svg)](https://github.com/khulnasoft/protocol.sh/actions/workflows/Linux.yml)|
|clearlinux:latest| [![LetsEncrypt](https://github.com/khulnasoft/protocol.sh/actions/workflows/Linux.yml/badge.svg)](https://github.com/khulnasoft/protocol.sh/actions/workflows/Linux.yml)|
|almalinux:latest| [![LetsEncrypt](https://github.com/khulnasoft/protocol.sh/actions/workflows/Linux.yml/badge.svg)](https://github.com/khulnasoft/protocol.sh/actions/workflows/Linux.yml)|
|tatsushid/tinycore:latest| [![LetsEncrypt](https://github.com/khulnasoft/protocol.sh/actions/workflows/Linux.yml/badge.svg)](https://github.com/khulnasoft/protocol.sh/actions/workflows/Linux.yml)|


# How to run tests

As simple as just run a script:

```
./letest.sh
```

It will use cloudflare tunnel to test on your local machine.


You can also test with your own domain, first point at least 2 of your domains to your machine, 
for example: `example.com` and `www.example.com`

And make sure 80 port is not used by anyone else.

```
cd protocol.sh
TestingDomain=example.com   TestingAltDomains=www.example.com  ./letest.sh
```

If you are not root,  please use `sudo`, because the script will have to listen at `80` port:

```
cd protocol.sh
sudo  TestingDomain=example.com   TestingAltDomains=www.example.com  ./letest.sh

```

# How to run tests in all the platforms through docker.

You must have docker installed, and also point 2 of your domains to your machine.

Then test all the platforms :

```
cd protocol.sh
./rundocker.sh  testall
```

It will use cloudflare tunnel test.

Or use your own domain:

```
cd protocol.sh
TestingDomain=example.com   TestingAltDomains=www.example.com  ./rundocker.sh  testall
```

The script will download all the supported platforms from the official docker hub, then run the test cases in all the supported platforms.

Then test single docker platform :

```
cd protocol.sh
./rundocker.sh  testall
```

Or:

```
cd protocol.sh
TestingDomain=example.com   TestingAltDomains=www.example.com  ./rundocker.sh  testplat   ubuntu:latest
```










