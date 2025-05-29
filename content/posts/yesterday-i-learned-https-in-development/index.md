---
title: Yesterday I learned… HTTPS in development
author: Laszlo Bogacsi
type: post
date: 2021-04-05T15:10:58+00:00
url: /2021/04/05/yesterday-i-learned-https-in-development/
categories:
  - Software Development
  - YesterdayILearned
tags:
  - CA
  - Certificate
  - development
  - HTTPS
  - local
  - localhost
  - Node
  - React
  - Secure
---
While working on a project I wanted to copy a generated link programmatically to the clipboard.

I figured I have 2 ways to do that either with the wildly supported `document.execCommand("copy")`:

```javascript
const input = document.getElementById("myInput");
input.select();
input.setSelectionRange(0, 99999);
document.execCommand("copy");
```

or using the async navigator api:

```javascript
navigator.clipboard.writeText(text)
```

Since I didn’t have an input field, just a piece of data in a react component, I went with the second option.

Little I know about the fact that the navigator object only has the clipboard accessible in a trusted environment. That means HTTPS.

## HTTPS in localhost?

To test the piece of code I looked for ways to use a secured connection in a dev environment.

With React and create react app, one can start the development server with https like this, but this is not quite enough.

```json
"scripts": {
  "start": "HTTPS=true react-scripts start",
  ...
},
```

This is half the story as I needed to start the backend service with https too. And somehow I had to convince Chrome that the self signed cert comes from a trusted CA.

## The plan

- Create a locally trusted Certificate Authority (CA) that can
- Create and sign a certificate for localhost, 127.0.0.1, ::1 domains
- So I can use this cert in my app to achieve the **S** in HTTP**S**.

## MKCERT

Found [this](https://www.npmjs.com/package/mkcert) as an alternative to OpenSSL, and I choose to install it as a global package with yarn, on macOS. There are other options with homebrew, and for Windows.

```sh
yarn global add mkcert
```

Create the CA and keep the generated key safe:

```sh
mkcert create-ca
```

And then generate a certificate for your localhost domains:

```sh
mkcert create-cert --ca-key <pathtocakey>/ca.key --ca-cert <pathtocacert>/ca.crt --domains localhost,127.0.0.1,::1
```

## React + Https

To use this with React (and CRA), create a .env file with the following:

```env
HTTPS=true
SSL_CRT_FILE=<pathToCert>/cert.crt
SSL_KEY_FILE=<pathToKey>/cert.key
```

## Node + Https

```javascript
const https = require('https');
const fs = require('fs');

const options = {
  key: fs.readFileSync('<pathToKey>/cert.key'),
  cert: fs.readFileSync('<pathToCert>/cert.crt')
};

const server = https.createServer(options, app);
```

## Chrome

At the time of writing: version 89.0.xx.

After setting up and starting your app in HTTPS mode, you might come across this:

{{< figure src="ChromeHTTPSInvalidCert.png" alt="not trusted cert" title="HTTPS but Invalid" >}}

Chrome doesn’t appear to accept our new shiny certificate and says it’s invalid. Click on the _Certificate (invalid)_ to find out more:

{{< figure src="BrowserCert.png" alt="Chrome issue" title="Chrome Invalid Cert details" >}}

Ahha, so it says the _Test CA_ certificate authority is not trusted. To solve this we need to add the CA to our trusted entities. On a mac open _Keychain Access_ find the CA and mark it as trusted:

{{< figure src="KeychainCert-edited.png" alt="Keychain Cert Trusted details" title="Mark the CA as trusted" >}}

If all went well now you should see the green lock in the browser:

{{< figure src="ChromeHTTPSValidCert.png" alt="valid cert" title="Valid and trusted" >}}

## Conclusion

I’ve learned how to use https in local development with React and Node, and since we aim to make our dev environment closer to production, this is a good way to tighten the gap and reveal issues related to https earlier.