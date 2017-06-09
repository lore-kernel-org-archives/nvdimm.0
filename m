Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x235.google.com (mail-ot0-x235.google.com
 [IPv6:2607:f8b0:4003:c0f::235])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1EE3321967BE9
 for <linux-nvdimm@lists.01.org>; Fri,  9 Jun 2017 12:05:22 -0700 (PDT)
Received: by mail-ot0-x235.google.com with SMTP id k4so43358299otd.0
 for <linux-nvdimm@lists.01.org>; Fri, 09 Jun 2017 12:06:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <23e2d0fe-105a-f102-8155-5324ee8de576@hpe.com>
References: <1497026071-46879-1-git-send-email-linda.knippers@hpe.com>
 <CAPcyv4grYufA9mUfApWVb3d0nnZ6GdO408PnSFk0uaAs7RO8Mw@mail.gmail.com>
 <34325df2-3c43-faaa-fa66-23d46782cf32@hpe.com>
 <CAPcyv4jaSGS49a-NiOOKLbo5z7gYHuzbug2aMrx41E1C4F8+LA@mail.gmail.com>
 <23e2d0fe-105a-f102-8155-5324ee8de576@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 9 Jun 2017 12:06:31 -0700
Message-ID: <CAPcyv4jUcwNNX3hCijo+u4mC7L5_1Rjbuf5dk5c+CiJ8sYAOMQ@mail.gmail.com>
Subject: Re: [ndctl PATCH] Report the Health Status Detail for the HPE1 DSM
 family
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Linda Knippers <linda.knippers@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 9, 2017 at 11:56 AM, Linda Knippers <linda.knippers@hpe.com> wrote:
> On 6/9/2017 2:10 PM, Dan Williams wrote:
>
>>>> This format for health_detail makes the json harder to consume for
>>>> upper-layer applications. Every field should be associated with a
>>>> key-id even if it's just a flag.
>>>
>>>
>>>
>>> Ok.  I thought we had discussed this format with my RFC patch a
>>> while back.  The only change I made was adding underscores instead
>>> of spaces as requested.
>>
>>
>> Yeah, I thought I had brought up the array of json-boolean objects vs
>> json-string objects before.
>
>
> Hmm...maybe I missed that, but ok.
>
>
>>> The items in the array are all associated with a single validation flag.
>>> There are some additional groups of fields that I plan to add as well,
>>> like a group of error counters, so do you want everything flat?
>>
>>
>> Yes, after writing some scripts to parse json I think flatter is
>> better unless the data itself is actually hierarchical.
>>
>>>
>>>> I think I'd like to keep the json
>>>> topology flatter. We already have support for the NFIT health state
>>>> flags in this form:
>>>>
>>>>         {
>>>>           "provider":"nfit_test.1",
>>>>           "dev":"ndbus3",
>>>>           "dimms":[
>>>>             {
>>>>               "dev":"nmem5",
>>>>               "id":"cdab-0a-07e0-fffffeff",
>>>>               "flag_failed_save":true,
>>>>               "flag_failed_arm":true,
>>>>               "flag_failed_restore":true,
>>>>               "flag_smart_event":true,
>>>>               "flag_failed_flush":true
>>>>             }
>>>>           ]
>>>>         }
>>>>
>>>> So, let's just add additional flag names and omit the ones that are
>>>> duplicates of the NFIT-level health state flags.
>>>
>>>
>>>
>>> None of them are duplicates because the NFIT state flags are static from
>>> boot
>>> time while the health status detail changes at runtime.
>>
>>
>> Yes, but it's a pain for applications that now have to deal with two
>> different flag names for similar indicators. So for example if
>> "flag_failed_arm" is false at startup, but "arm_error" triggers later
>> I would think that would just be reflected in "flag_failed_arm". In
>> other words override the static flag_failed_arm value with the dynamic
>> result so that monitor applications need only learn one json key for
>> the same data.
>
>
> But they're different things.  One represents boot time state and one
> represents
> runtime.  One is an NFIT flag, not even reported as health today, and one is
> runtime health.  Even your commit message says they're distinct from SMART
> health data.  Knowing that my NVDIMM came up healthy and then had an
>  issue,
> or vice versa, is important.

I agree, but I don't think it's ndctl's job to maintain that
distinction. The default case is "I want to know the present state of
my dimm", if an environment wants to know "has my state changed over
time" then it should be logging the health state snapshots and
comparing them.

> Maybe the state flags should be renamed to reflect what they really are.
> The "true" value for those is probably redundant too because I don't think

Yes, the 'true' value is redundant. The goal is to get the flag name
into a json-key rather than a json-value.

> you
> output anything if they're fault, although now I'm not sure those NFIT
> flags are being displayed properly at all.  On my system, /sys../nfit/flags
> shows "smart_notify", which I assume means I should see
> "flag_smart_event":true,
> but I don't.  I'll look at that separately.

The 'smart_notify' flag is whether the DIMM supports health state
notifications, the 'flag_smart_event' indicates if a smart event was
pending. So your system supports notifications and the NFIT says no
SMART event was pending.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
