Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22c.google.com (mail-oi0-x22c.google.com
 [IPv6:2607:f8b0:4003:c06::22c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 44CD421A143C2
 for <linux-nvdimm@lists.01.org>; Fri,  9 Jun 2017 13:45:36 -0700 (PDT)
Received: by mail-oi0-x22c.google.com with SMTP id p7so35228109oif.2
 for <linux-nvdimm@lists.01.org>; Fri, 09 Jun 2017 13:46:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <a035bfc8-f8a5-4d0b-46e7-a1298f8a1bb2@hpe.com>
References: <1497026071-46879-1-git-send-email-linda.knippers@hpe.com>
 <CAPcyv4grYufA9mUfApWVb3d0nnZ6GdO408PnSFk0uaAs7RO8Mw@mail.gmail.com>
 <34325df2-3c43-faaa-fa66-23d46782cf32@hpe.com>
 <CAPcyv4jaSGS49a-NiOOKLbo5z7gYHuzbug2aMrx41E1C4F8+LA@mail.gmail.com>
 <23e2d0fe-105a-f102-8155-5324ee8de576@hpe.com>
 <CAPcyv4jUcwNNX3hCijo+u4mC7L5_1Rjbuf5dk5c+CiJ8sYAOMQ@mail.gmail.com>
 <a035bfc8-f8a5-4d0b-46e7-a1298f8a1bb2@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 9 Jun 2017 13:46:45 -0700
Message-ID: <CAPcyv4jntkch6nReSFMJ5uMxjwHFGzOB2mFzGurz1u4aOoCP3w@mail.gmail.com>
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

On Fri, Jun 9, 2017 at 12:52 PM, Linda Knippers <linda.knippers@hpe.com> wrote:
>
>
> On 6/9/2017 3:06 PM, Dan Williams wrote:
>>
>> On Fri, Jun 9, 2017 at 11:56 AM, Linda Knippers <linda.knippers@hpe.com>
>> wrote:
>>>
>>> On 6/9/2017 2:10 PM, Dan Williams wrote:
>>>
>>>>>> This format for health_detail makes the json harder to consume for
>>>>>> upper-layer applications. Every field should be associated with a
>>>>>> key-id even if it's just a flag.
>>>>>
>>>>>
>>>>>
>>>>>
>>>>> Ok.  I thought we had discussed this format with my RFC patch a
>>>>> while back.  The only change I made was adding underscores instead
>>>>> of spaces as requested.
>>>>
>>>>
>>>>
>>>> Yeah, I thought I had brought up the array of json-boolean objects vs
>>>> json-string objects before.
>>>
>>>
>>>
>>> Hmm...maybe I missed that, but ok.
>>>
>>>
>>>>> The items in the array are all associated with a single validation
>>>>> flag.
>>>>> There are some additional groups of fields that I plan to add as well,
>>>>> like a group of error counters, so do you want everything flat?
>>>>
>>>>
>>>>
>>>> Yes, after writing some scripts to parse json I think flatter is
>>>> better unless the data itself is actually hierarchical.
>>>>
>>>>>
>>>>>> I think I'd like to keep the json
>>>>>> topology flatter. We already have support for the NFIT health state
>>>>>> flags in this form:
>>>>>>
>>>>>>         {
>>>>>>           "provider":"nfit_test.1",
>>>>>>           "dev":"ndbus3",
>>>>>>           "dimms":[
>>>>>>             {
>>>>>>               "dev":"nmem5",
>>>>>>               "id":"cdab-0a-07e0-fffffeff",
>>>>>>               "flag_failed_save":true,
>>>>>>               "flag_failed_arm":true,
>>>>>>               "flag_failed_restore":true,
>>>>>>               "flag_smart_event":true,
>>>>>>               "flag_failed_flush":true
>>>>>>             }
>>>>>>           ]
>>>>>>         }
>>>>>>
>>>>>> So, let's just add additional flag names and omit the ones that are
>>>>>> duplicates of the NFIT-level health state flags.
>>>>>
>>>>>
>>>>>
>>>>>
>>>>> None of them are duplicates because the NFIT state flags are static
>>>>> from
>>>>> boot
>>>>> time while the health status detail changes at runtime.
>>>>
>>>>
>>>>
>>>> Yes, but it's a pain for applications that now have to deal with two
>>>> different flag names for similar indicators. So for example if
>>>> "flag_failed_arm" is false at startup, but "arm_error" triggers later
>>>> I would think that would just be reflected in "flag_failed_arm". In
>>>> other words override the static flag_failed_arm value with the dynamic
>>>> result so that monitor applications need only learn one json key for
>>>> the same data.
>>>
>>>
>>>
>>> But they're different things.  One represents boot time state and one
>>> represents
>>> runtime.  One is an NFIT flag, not even reported as health today, and one
>>> is
>>> runtime health.  Even your commit message says they're distinct from
>>> SMART
>>> health data.  Knowing that my NVDIMM came up healthy and then had an
>>>  issue,
>>> or vice versa, is important.
>>
>>
>> I agree, but I don't think it's ndctl's job to maintain that
>> distinction. The default case is "I want to know the present state of
>> my dimm", if an environment wants to know "has my state changed over
>> time" then it should be logging the health state snapshots and
>> comparing them.
>
>
> If you want to know the state of the NVDIMM, that's the health information
> for systems that provide this information.  Right now for the information
> we're talking about, that's systems that support the HPE1 DSM family.
>
> It is different from the NFIT device flag, which represents the state of
> the NVDIMM at the point at which the FW created the NFIT table, which would
> apply to all NFIT-commpliant platforms.
>
> If you try to combine the two, it's not clear what state you're getting
> because it's not obvious from ndctl whether it's static or dynamic data.
> I believe that's why you correctly didn't call the state flags "health"
> data.

True, ok, we do already have the distinction that the "health"
sub-object is live data. So how about a middle ground? For the live
detail flags that indicate the similar data as the static health-state
flags from the NFIT let call them the same name. So it would look like
this:

           {
             "dev":"nmem0",
             "health":{
               "flag_failed_arm":true,
             }
           }

Where a monitor application can see that we started with the DIMM
armed and it went unarmed, but it only ever needs to worry about one
key name for the "armed" state.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
