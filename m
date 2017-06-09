Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5008.houston.hpe.com (g9t5008.houston.hpe.com [15.241.48.72])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6D88521967BC4
 for <linux-nvdimm@lists.01.org>; Fri,  9 Jun 2017 10:58:18 -0700 (PDT)
Subject: Re: [ndctl PATCH] Report the Health Status Detail for the HPE1 DSM
 family
References: <1497026071-46879-1-git-send-email-linda.knippers@hpe.com>
 <CAPcyv4grYufA9mUfApWVb3d0nnZ6GdO408PnSFk0uaAs7RO8Mw@mail.gmail.com>
From: Linda Knippers <linda.knippers@hpe.com>
Message-ID: <34325df2-3c43-faaa-fa66-23d46782cf32@hpe.com>
Date: Fri, 9 Jun 2017 13:58:59 -0400
MIME-Version: 1.0
In-Reply-To: <CAPcyv4grYufA9mUfApWVb3d0nnZ6GdO408PnSFk0uaAs7RO8Mw@mail.gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



On 6/9/2017 1:46 PM, Dan Williams wrote:
> On Fri, Jun 9, 2017 at 9:34 AM, Linda Knippers <linda.knippers@hpe.com> wrote:
>> This patch adds a new interface to provide additional Health Status Detail.
>> This information is reported as part of the Smart Health with the HPE1
>> DSM family so the function for the other families is NULL by default.  If
>> the field is available, the ndctl --health option will decode
>> the bits that make up the field.  If the DSM family doesn't support
>> this function, no additional information is provided.
>>
>> With this change a healthy NVDIMM-N that supports this information
>> would report something like this:
>>
>> {
>>     "dev":"nmem6",
>>     "id":"802c-0f-1612-122eb278",
>>     "health":{
>>       "health_state":"ok",
>>       "temperature_celsius":25.000000,
>>       "spares_percentage":99,
>>       "alarm_temperature":false,
>>       "alarm_spares":false,
>>       "temperature_threshold":50.000000,
>>       "spares_threshold":20,
>>       "life_used_percentage":0,
>>       "shutdown_state":"clean",
>>       "health_status_detail":[
>>         "ok"
>>       ]
>>     }
>>   }
>>
>> An ailing NVDIMM-N could report one or more health status
>> conditions, sometime like this:
>>
>> {
>>     "dev":"nmem6",
>>     "id":"802c-0f-1612-122eb278",
>>     "health":{
>>       "health_state":"ok",
>>       "temperature_celsius":25.000000,
>>       "spares_percentage":99,
>>       "alarm_temperature":false,
>>       "alarm_spares":false,
>>       "temperature_threshold":50.000000,
>>       "spares_threshold":20,
>>       "life_used_percentage":0,
>>       "shutdown_state":"clean",
>>       "health_status_detail":[
>>         "energy_source_error",
>>         "arm_error",
>>       ]
>>     }
>>   }
>
> This format for health_detail makes the json harder to consume for
> upper-layer applications. Every field should be associated with a
> key-id even if it's just a flag.

Ok.  I thought we had discussed this format with my RFC patch a
while back.  The only change I made was adding underscores instead
of spaces as requested.

The items in the array are all associated with a single validation flag.
There are some additional groups of fields that I plan to add as well,
like a group of error counters, so do you want everything flat?

> I think I'd like to keep the json
> topology flatter. We already have support for the NFIT health state
> flags in this form:
>
>         {
>           "provider":"nfit_test.1",
>           "dev":"ndbus3",
>           "dimms":[
>             {
>               "dev":"nmem5",
>               "id":"cdab-0a-07e0-fffffeff",
>               "flag_failed_save":true,
>               "flag_failed_arm":true,
>               "flag_failed_restore":true,
>               "flag_smart_event":true,
>               "flag_failed_flush":true
>             }
>           ]
>         }
>
> So, let's just add additional flag names and omit the ones that are
> duplicates of the NFIT-level health state flags.

None of them are duplicates because the NFIT state flags are static from boot
time while the health status detail changes at runtime.

-- ljk
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
