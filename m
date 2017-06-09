Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x234.google.com (mail-oi0-x234.google.com
 [IPv6:2607:f8b0:4003:c06::234])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DB00721967BC4
 for <linux-nvdimm@lists.01.org>; Fri,  9 Jun 2017 11:08:56 -0700 (PDT)
Received: by mail-oi0-x234.google.com with SMTP id p7so33811366oif.2
 for <linux-nvdimm@lists.01.org>; Fri, 09 Jun 2017 11:10:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <34325df2-3c43-faaa-fa66-23d46782cf32@hpe.com>
References: <1497026071-46879-1-git-send-email-linda.knippers@hpe.com>
 <CAPcyv4grYufA9mUfApWVb3d0nnZ6GdO408PnSFk0uaAs7RO8Mw@mail.gmail.com>
 <34325df2-3c43-faaa-fa66-23d46782cf32@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 9 Jun 2017 11:10:06 -0700
Message-ID: <CAPcyv4jaSGS49a-NiOOKLbo5z7gYHuzbug2aMrx41E1C4F8+LA@mail.gmail.com>
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

On Fri, Jun 9, 2017 at 10:58 AM, Linda Knippers <linda.knippers@hpe.com> wrote:
>
>
> On 6/9/2017 1:46 PM, Dan Williams wrote:
>>
>> On Fri, Jun 9, 2017 at 9:34 AM, Linda Knippers <linda.knippers@hpe.com>
>> wrote:
>>>
>>> This patch adds a new interface to provide additional Health Status
>>> Detail.
>>> This information is reported as part of the Smart Health with the HPE1
>>> DSM family so the function for the other families is NULL by default.  If
>>> the field is available, the ndctl --health option will decode
>>> the bits that make up the field.  If the DSM family doesn't support
>>> this function, no additional information is provided.
>>>
>>> With this change a healthy NVDIMM-N that supports this information
>>> would report something like this:
>>>
>>> {
>>>     "dev":"nmem6",
>>>     "id":"802c-0f-1612-122eb278",
>>>     "health":{
>>>       "health_state":"ok",
>>>       "temperature_celsius":25.000000,
>>>       "spares_percentage":99,
>>>       "alarm_temperature":false,
>>>       "alarm_spares":false,
>>>       "temperature_threshold":50.000000,
>>>       "spares_threshold":20,
>>>       "life_used_percentage":0,
>>>       "shutdown_state":"clean",
>>>       "health_status_detail":[
>>>         "ok"
>>>       ]
>>>     }
>>>   }
>>>
>>> An ailing NVDIMM-N could report one or more health status
>>> conditions, sometime like this:
>>>
>>> {
>>>     "dev":"nmem6",
>>>     "id":"802c-0f-1612-122eb278",
>>>     "health":{
>>>       "health_state":"ok",
>>>       "temperature_celsius":25.000000,
>>>       "spares_percentage":99,
>>>       "alarm_temperature":false,
>>>       "alarm_spares":false,
>>>       "temperature_threshold":50.000000,
>>>       "spares_threshold":20,
>>>       "life_used_percentage":0,
>>>       "shutdown_state":"clean",
>>>       "health_status_detail":[
>>>         "energy_source_error",
>>>         "arm_error",
>>>       ]
>>>     }
>>>   }
>>
>>
>> This format for health_detail makes the json harder to consume for
>> upper-layer applications. Every field should be associated with a
>> key-id even if it's just a flag.
>
>
> Ok.  I thought we had discussed this format with my RFC patch a
> while back.  The only change I made was adding underscores instead
> of spaces as requested.

Yeah, I thought I had brought up the array of json-boolean objects vs
json-string objects before.

> The items in the array are all associated with a single validation flag.
> There are some additional groups of fields that I plan to add as well,
> like a group of error counters, so do you want everything flat?

Yes, after writing some scripts to parse json I think flatter is
better unless the data itself is actually hierarchical.

>
>> I think I'd like to keep the json
>> topology flatter. We already have support for the NFIT health state
>> flags in this form:
>>
>>         {
>>           "provider":"nfit_test.1",
>>           "dev":"ndbus3",
>>           "dimms":[
>>             {
>>               "dev":"nmem5",
>>               "id":"cdab-0a-07e0-fffffeff",
>>               "flag_failed_save":true,
>>               "flag_failed_arm":true,
>>               "flag_failed_restore":true,
>>               "flag_smart_event":true,
>>               "flag_failed_flush":true
>>             }
>>           ]
>>         }
>>
>> So, let's just add additional flag names and omit the ones that are
>> duplicates of the NFIT-level health state flags.
>
>
> None of them are duplicates because the NFIT state flags are static from
> boot
> time while the health status detail changes at runtime.

Yes, but it's a pain for applications that now have to deal with two
different flag names for similar indicators. So for example if
"flag_failed_arm" is false at startup, but "arm_error" triggers later
I would think that would just be reflected in "flag_failed_arm". In
other words override the static flag_failed_arm value with the dynamic
result so that monitor applications need only learn one json key for
the same data.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
