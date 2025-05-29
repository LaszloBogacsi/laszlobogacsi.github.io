---
title: Yesterday I learned… SSH Public key authentication
author: Laszlo Bogacsi
type: post
date: 2021-05-14T19:00:58+00:00
url: /2021/05/14/yesterday-i-learned-ssh-public-key-authentication/
categories:
  - Software Development
  - YesterdayILearned
tags:
  - auth
  - publickey
  - rsa
  - ssh
---
The other day, while working on a piece of service we had to provide access for a new team member to one of the servers.

While doing this, I automatically asked the person to generate a key-pair, and to pass me the public key part of it so I can paste it to a relevant file on the server.

And then it struck me, that I don’t exactly know why, or how does this work. And how can the server authenticate a client with the given public key. So here are my learnings on it. This was also one of the first times that I looked into an RFC document. This one is namely the [RFC 4252 Section 7](https://datatracker.ietf.org/doc/html/rfc4252#section-7).

## Prerequisites

You need to have a private – public key pair ready to go. For this purpose we’ll use:

```sh
ssh-keygen
```

to generate a key pair for us, [read more about it here](https://www.ssh.com/academy/ssh/keygen).

For the sake of the example, let’s generate an rsa key like this:

```sh
ssh-keygen -t rsa
```

> What you need for a public key cryptographic system to work is a set of algorithms that is easy to process in one direction, but difficult to undo. In the case of RSA, the easy algorithm multiplies two prime numbers. If multiplication is the easy algorithm, its difficult pair algorithm is factoring the product of the multiplication into its two component primes. Algorithms that have this characteristic — easy in one direction, hard the other — are known as [Trap door Functions](http://en.wikipedia.org/wiki/Trapdoor_function).
>
> [Source](https://blog.cloudflare.com/a-relatively-easy-to-understand-primer-on-elliptic-curve-cryptography/)

## Why is this good for you

- more secure than password
- don’t have to remember a password (maybe just one passphrase to protect the key)
- in case the server gets compromised and your key gets out, it’s is still just the public key part.

## Auth Flow

The flow can be broken down to 6 steps:

1. Using your ssh client to gain access to a server, the client first sends an authentication request for a username
2. The server looks up the username and returns the supported authentication methods [password, *publickey*]
3. If the *publickey* method is supported the client will send a public key authentication request with the following information:
   - username
   - key type (rsa)
   - signature algorithm (ssh-rsa)
   - and the public key itself (Unsigned)
4. Then the server checks that it has a matching public key and the signature algorithm is supported
   1. If all good it returns a PK_OK message
   2. or an Auth_failure message otherwise
5. In case of a PK_OK message the client sends a similar public key authentication request as before but this time it signs the public key with the private key.
6. The server validates the signature using its own copy of the public key. If the signature computes, then the authentication is successful.

{{< figure src="SSH-Public-Key-Authentiucation.png" title="SSH Public Key Auth flow – Image by author" >}}

To be more specific about the public key auth requests:  
The first unsigned one looks something like this:

```text
byte      SSH_MSG_USERAUTH_REQUEST
string    user name in ISO-10646 UTF-8 encoding &#91;RFC3629]
string    service name in US-ASCII
string    "publickey"
boolean   FALSE
string    public key algorithm name
string    public key blob
```

and the second signed one contains this information:

```text
byte      SSH_MSG_USERAUTH_REQUEST
string    user name
string    service name
string    "publickey"
boolean   TRUE
string    public key algorithm name
string    public key to be used for authentication
string    signature
```