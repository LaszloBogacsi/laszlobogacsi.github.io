---
title: HomeHub, 4 – Architecture
author: Laszlo Bogacsi
type: post
date: 2020-03-09T14:47:48+00:00
url: /2020/03/09/homehub-4-architecture/
coverCaption: Photo by <a href="https://unsplash.com/@killerfvith?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Alex wong</a> on <a href="https://unsplash.com/photos/worms-eye-view-of-buildings-l5Tzv1alcps?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Unsplash</a>
      
categories:
  - Home automation
tags:
  - Alexa
  - AWS
  - MQTT
  - Mqtt Bridge
  - Raspberry Pi
---

> I’ve built a home automation system from scratch. This is the 4th part of a series of posts discussing the architecture

## Cloud And LAN

{{< figure src="homehub-architecture-7.png" alt="Architecture" caption="Architecture" >}}

Wanted to separate the parts that are internet and cloud dependent. I wanted to be able to switch on my lights even when an internet connection is not available.

## MQTT Bridge

The connection between my home network and the cloud is a bridge between two MQTT brokers. The bridge lets you connect the brokers and share messages between the systems.

The idea was that a service called [Cloud MQTT][1], a hosted messaging service, would handle the traffic coming from Alexa and the messages would be bridged to Mosquitto running on the PI.

Cloud MQTT has a free tier, which is suitable for small home projects, they of course offer more with paid plans, but for this use-case the free offering of 5 connections and some minimal bandwidth is more than enough.

Since the free tier cloud service doesn’t allow to setup the bridge it’s a good thing that we only need to configure one broker to act as a bridge and the other one will act as a normal broker.

To do so, it’s surprisingly simple:

```conf
#Bridging with remote mqtt service
# mosquitto.conf
# Connection to RemoteMQTT

connection <connection name>
address <host:port>
topic <topic/name> both 0 "" remote/ 
remote_username <username>
remote_password <password>
try_private true
notifications false
cleansession true
start_type automatic
```

a little bit of magic is happening in this line:

`topic <topic/name>  both 0 "" remote/` 

remote/ is a forwarded rename eg “topic/name” will be forwarded as “remote/topic/name”, what this means is, since the bridge is set up locally to my pi (local broker from now on), the client subscribed to the local broker sends a message in a “sensors/temp” topic it will be forwarded to the remote broker in this topic: “remote/sensors/temp”. The local prefix is set to none so it will forward all messages, however because the remote prefix is set to “remote/” clients subscribed to the remote broker, sending messages in a topic not starting with “remote/” won’t be forwarded to the local broker.

For more information on setting up a bridge [this site][2] is really insightful and covers more scenarios.

## Mosquitto

I use [Mosquitto](https://mosquitto.org/) as my local broker running on the Raspberry Pi. This handles the messaging among the esp8266 boards and the hub and this is configured to act as a bridge.

All the sensors are publishers on certain topics and the relays are subscribers and publishers as well, they listen for an on/off message either from the hub or coming from the remote broker over the bridge and then publish their changed state.

## Alexa and the cloud bits

I have a 2nd gen echo dot, so it was the obvious choice. These devices are getting better and better at accurately recognizing and interpreting your voice commands so I thought I should create a skill. It seemed so cool from the advert to hear “alexa, living room on!” and “boom”, “tik”, “ts” stuff comes alive. But, quite early on in the process I had to realize, there is no way to create a skill and then invoke the skill command without the skill name. This makes this a little it clunky and occasionally very long to say. 

> Alexa, ask home hub to turn on the floor lamp in the living room.

Not very catchy, and honestly, it doesn’t come naturally to say. And I’m not using it very often. So usability is key. In name of usability and simplicity I explored other solutions available.

Can make your device implement the Smart Home Skill API. This will make your device discoverable and it will appear in the alexa “devices” list. And also could use the Alexa Connect Kit, but be aware this is a paid for service and might require additional hardware.

After all, I decided to go with clunkiness and complexity as I wanted a homegrown smart home platform with an Alexa extension and not the other way around. As frankly the point is to learn while having fun, so I wanted to tackle the challenges myself around messaging, event scheduling and keeping track of state and presentation.

Home-hub is too long to say, Jarvis, Kit and Hal is already taken, any suggestions?

So creating an Alexa skill is a fairly simple process, usual sign up on the amazon-developer portal. The most confusing bit is that an Amazon Developer and the AWS services are not the same or connected in any way.

When have a developer account ready, sign in, create a skill, give it an invocation name, and use the available hello world template to make it say something.

To make the skill appear on your Alexa device, use the same account for both. And for the skill use the same language region. Be aware that UK and US are different. If the device is in English(US) language region/mode and your skill is in English(UK) mode, the skill won’t show up on the devices companion app.

A skill in development mode is private, visible only to you (to your account), until you decide to publish it and make it public it won’t show up in the skill store.

To make an Alexa skill you have 2 options:

- Host your skill code in Alexa cloud
- Host your code on your own (I choose this)

## Lambdas

AWS Lambda is one of the compute resources available on AWS. This is an ephemeral compute service. This means this is a short lived execution environment for small pieces of code that can be executed quickly. A container spins up executes your function and shuts down afterwards.

This sounds perfect to use it as a skill handler.

A lambda function can be triggered by many other AWS services and amongst them the input can come from an Alexa skill.

For this to make it work you’ll need to connect the skill to the lambda. You’ll need to copy the lambdas ARN to the skill by pasting it to the **Custom > Endpoint** in the skill console.

And likewise you’ll need to mention the skills ARN in the trigger of the lambda.

A lambda can be programmed by many languages, like Javascript (node), python, java, and others. I went with python to stay consistent with the rest of the project.

## Serverless + Lambda + python

To write a few lines of simple code one can use the online code editor of the lambda console. But above a certain file size you can’t edit the code there. This is also the case when you feel the need to use external libraries.

#### first approach

“just to make things work” first, I wrote some code locally in my favorite editor. Ran it, tested it, great. How does it become a lambda function? Well, note the name of your function because that is the entry point into your program. It takes two arguments in python an event and a context object. these in our case are passed in from the Alexa service. And the trigger will invoke your function with these arguments.

Zip up your `function.py` that has your `myhandler(e, c):` method and upload it, using the lambda console. Specify the handler like function.myhandler, select the runtime and upload.

This is not a tutorial on AWS so I’ll skip the details of setting up execution roles, IAM roles and permissions, and other details.

Simple right? Or.. well not really, I mean try doing this is rapid development iteration, change code, zip, upload, test.. it gets tedious really quickly. especially when there are dependencies. Which you would have to include into your .zip upload bundle. Suppose you’re using `pipenv` to manage python versions and virtual environments, you’d have to copy all of it from the site-packages in `~/.local/share/virtualenvs/<project name>/lib/<python-version>/site-packages` (on a mac) and include them in your .zip.

So let’s automate this bit.

#### second try

I’ve found this nice [pip package](https://pypi.org/project/python-lambda/). It pretty much does the same process as I described above. This would need you to also install AWS-cli and boto3 to handle the upload (for auth, you need to have cli user).

But ohhh my it’s slow. As it’s installing all your dependencies from scratch from the pipfile every time you `lambda deploy`.

However it’s a great first step to understand what is going on in the background.

You can use this library to `invoke` your function locally with some test data.

Let’s go one step further.

#### final approach

> Use serverless

[Serverless](https://serverless.com/) is a fantastic framework that allows you to develop, test and deploy serverless applications and has a great abstraction on AWS cloud formation and supports other cloud providers like Azure and GCP and at the time of writing about a dozen other providers.

`npm i -g serverless`

```shell
serverless create --template aws-python3 --name <your lambda function name>
```

this will create a serverless.yml which contains the configs and the template to create resources and deployment information.

in a simple case about this much config would do:

```yaml
# serverless.yml
service: my-example-service

provider:
  name: aws
  runtime: python3.8

  stage: dev
  region: us-east-1

functions:
  my-function-name:
    handler: handler.hello
    events:
      - alexaSkill: <alexa-skill-ARN>
plugins:
  - serverless-python-requirements
```

provided your function is in us-east-1 region, and you have the cli and user permission set up already `sls deploy` does the job of creating or updating a lambda function, setting the Alexa skill as a trigger and uploading your code to the lambda environment.

I have a lambda that handles the events around device control like turn On/Off and another one that updates the Alexa interaction model when I add a new device this updates the names available for the interaction model, so I don’t have to manually enter a new name in the Alexa skill console every time I update or add a new device or group / scene. The later lambda requires Amazon login auth.

## Conclusion

Now, we have a bunch of esp8266 boards that `client.publish(temperature_topic, jsonMsg)` sensor data, and an Alexa skill that’s `self.mqtt_client.publish(topic=self.TOPIC, payload=payload)`. These messages are published on a topic and gets in the message queue of Mosquitto.

We saw how to deploy your lambdas using serverless, and touched on briefly [how to create an Alexa skill](https://developer.amazon.com/en-US/docs/alexa/custom-skills/steps-to-build-a-custom-skill.html).

In the upcoming parts of these series of posts will show how the backend looks like, how I deploy the code to “production”, and will see some visualizations for the sensor data.

[1]: https://www.cloudmqtt.com/
[2]: http://www.steves-internet-guide.com/mosquitto-bridge-configuration/