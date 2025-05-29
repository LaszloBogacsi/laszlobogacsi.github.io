---
title: Unveiling traverse mysteries – WIP
author: Laszlo Bogacsi
type: post
date: 2020-02-13T19:51:55+00:00
coverCaption: Photo by <a href="https://unsplash.com/@sunburned_surveyor?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Scott Blake</a> on <a href="https://unsplash.com/photos/man-standing-and-using-measuring-level-on-road-bKGpAV4gFnc?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Unsplash</a>
draft: true
timeline_notification:
  - 1581623517
categories:
  - Construction

---
My first ever post is about a surveying method (who'd have thought so..) called traverse.  
I'm writing this because recently I've been asked to carry out a measurement like this and before doing it I wanted to refresh my knowledge on the details, and as google is my friend, I tried to fetch some information. I wouldn't say I failed miserably but it was certainly hard to get some real life practical advice and how-tos. Most of the shared knowledge is quite academic or from the US with [feet] and [gon] or maybe just a video using the traverse program on a controller or using specialist software. But what if you need to do it manually, or just curious what is happening under the hood (or both): let's dive in.

<!--more-->

My perspective on this matter will be largely focused on construction sites and based on my recent experience.  
So next I'm going to write about:

- What's a traverse and why would you need one?
- What sort of kit you need to measure one
- What kind of input data you need
- How to calculate the traverse (horizontally)

## What is a traverse and why would you need one?

This is what Wikipedia says about traverse:

> **Traverse** is a method in the field of [surveying](https://en.wikipedia.org/wiki/Surveying) to establish [control networks](https://en.wikipedia.org/wiki/Control_networks).[1] It is also used in [geodesy](https://en.wikipedia.org/wiki/Geodesy). Traverse networks involve placing survey stations along a line or path of travel, and then using the previously surveyed points as a base for observing the next point. — source (Wikipedia)

Ok, but when do you need to do this and why?

Primarily when you're establishing a new control network (marked with nails/surveying points on the ground) and a connecting secondary network of retros (and other targets).  
Also it's important to carry out these measurements in the same session, because this way the measured stations are statistically connected and relevant.

There are two types of traverses:

1. Open traverse
2. Closed traverse and this is what I'm going to talk about.

//image of open / closed traverses.

Closed means the shape of your stations are geometrically closed: it starts and ends on the same point and is mathematically also closed (the opening and closing point is known). (The open traverse is geometrically open – it starts and finishes on different points and it can be mathematically open and closed as well depending on if we know the closing point's coordinate or not).

The closed traverse is carried out in an orderly fashion meaning the traverse has a direction either clockwise or counter-clockwise. The order of the measurements are: first you measure your back sight (BS) and then your foresight (FS) and later in case of a counter-clockwise traverse you represent the internal angles between two measured lines as a clockwise angle pointing from the BS line to the FS line.

{{< figure src="https://laszlobogacsi.files.wordpress.com/2017/07/ccwtraverse1.png" title="Counter clockwise traverse, clockwise internal angles" >}}

## What sort of kit you need to measure one?

1. A total-station on wooden legs
2. 2 sets of prisms and legs

## What kind of input data you need?

2 known points (S1 and S5 from above). And on one of them, which will be the starting point of the traverse (S1), you need to be able to set orientation as well, so practically it's good to have the two points in the same line of sight so they can serve as one side (line) of your traverse. This way you can set your instrument on the first known point and orientate from the second one.

## How to calculate the traverse?

First of all you need data.

To satisfy statistical needs and to eliminate as many instrument errors as you can, measure at least 3 sets (3 × (Face I + Face II)). You always can measure more if you want but 3 is enough to see if there was something wrong with one of the sets (traffic, pedestrians, birds, leaves, builders, etc. were in the way of the measurement).

Ok, you have done the survey, you have the data, need to export it from the instrument/controller.  
Many times the equipment we have to work with is either a hire kit for just that job, or has no means of access to customize the export format files (.frt) or recording masks because of either a restricted firmware or no access to Leica format manager or such software.

In this case I'm going to focus on a Leica instrument as probably most instruments in UK constructions are Leica ones. (Sorry Trimble, Topcon, Sokkia guys).

So you are not sure what sort of csv / ascii / text output your edm would produce? Or you know it well and it's not good for this job, the answer is the GSI format.  
Most default csv/ascii frt's are configured in a way to only show the most important fields for daily surveying and setting out like 'point id', 'E', 'N', 'H', 'codes..' and maybe a couple of more fields but this is not the ones we exactly need.

The data that is particularly interesting is 'point_id', 'horizontal distance', 'horizontal angle', 'vertical angle', 'height' or 'height difference' (these are the minimum data points needed).  
Good to have the 'target height' to double check if the target height offset was indeed correct, 'constants' to double check if the right kind of target was selected to the measurement (round prism, mini prism, tape, reflectorless) (these are the nice to haves).

The GSI format usually contains this information. There are 2 types of GSI's: the 8 bit and 16 bit, this is mainly down to the age of the instrument in use as the older ones support only the 8 bit, the newer ones are good to go 16 bit. This comes into play when the large coordinates 123456.789 like this will be truncated like -> 23456.789, and also point names (so careful when naming as the firmware might allow for longer names but the export can truncate it when set to 8 bit). So to read the GSI it's handy to have a GSI – ascii converter.

An 8-bit line from a GSI file looks something like this:

```
110007+00010007 21.324+34727200 22.324+05217220 31..00+00065075
51....-0000+034 81..00+04023282 82..00+03006382 83..00+00045517
```

The codes we need:

| Code | Description                       |
|------|-----------------------------------|
| 11   | Point number (includes block number) |
| 21   | Horizontal Circle (Hz)            |
| 22   | Vertical Angle (V)                |
| 31   | Slope Distance                    |
| 32   | Horizontal Distance               |
| 33   | Height Difference                 |
| 51   | Constants (ppm, mm)               |
| 87   | Reflector height (above ground)   |

Now you have all the data you need, in a plain text file.  
Next import it to Excel (OpenOffice or similar). Split the data by the default separator that the GSI-ASCII converter uses. So now you have one record per cell.  
Great. Let's average up the data and then calculate the index errors.  
When averaging pay attention to the data. The angles are in a format of deg.minsec: 28.2339 → 28°23'39", so it's not base 10! but Excel doesn't know that.  
I'll show you some tricks around this.

// some tricks

### Converting the angles

In order to make sure you won't lose any of the precious data, convert all the angles into decimal degrees and then convert them to radians (because Excel uses radians for most of its functions to manipulate angles like sin(), cos(), tan() ).

28°23'39" → to decimal degrees: **28** + **23**/60 + **39**/(60*60) = 28.3941666°  
From here Excel can do the deg → rad conversion for you or use the formula: rad = deg × π/180

### Calculating index errors

Hz: Hz II – Hz I == 180-00-00 — the difference should be 180, but there will be a little error (180-00-06) that is the index error (0-00-06") to balance this subtract (or add) half of it to the Hz I to make it equal to 180-00-00; that is your average index corrected Hz angle.

### Calculating internal angles

An internal angle on station 1 would be an angle between line 1-5 and 1-2.  
Can get this angle by calculating the difference between the corrected Hz angles.

// image of the internal angle

Do this calculation for every station.

### Checking points

angle misclosure, linear misclosure

- calculating distance from coordinates

### Calculating bearing

A line's bearing is the angle difference clockwise between the +N and the line.

{{< figure src="https://laszlobogacsi.files.wordpress.com/2017/07/bearing1.png" title="Bearing" >}}

#### Calculating the bearing for the FIRST point

First step is to calculate the bearing at S1 for the S1-S5 line using the 2 known points. For this you have to do the following:

> S1(E1, N1)
> 
> S5(E5, N5)
> 
> ΔE = E5 – E1
> 
> ΔN = N5 – N1
> 
> δ = arctan(ΔE/ΔN)

// add image with the quadrant for tangent correction

#### Calculating the bearing for intermediate points

For the following bearing we need a little bit of geometry magic and also we'll make good use of the similar triangles rule.

{{< figure src="https://laszlobogacsi.files.wordpress.com/2017/07/bearingcalc2.png" title="Calculating bearing on S2 for line 2-3" >}}

- using the time formatting

#### Calculating distance from coordinates

For this use the good old Pythagoras theorem. The square root of the square sums of the coordinate differences: √(ΔE²+ΔN²)

#### Calculating latitude and departure

Latitude: sin(bearing) × horizontal distance

Departure: cos(bearing) × horizontal distance

- explain bearing / azimuth

#### Calculating linear misclosure

Sum of all the: √(ΣLatitude²+ΣDeparture²)

#### Balancing the latitude and departure

Balance the above calculated error proportionate to the length of each traverse side by the total length of the traverse.

#### Calculating the traverse coordinates