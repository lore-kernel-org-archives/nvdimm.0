Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2353.austin.hpe.com (g2t2353.austin.hpe.com [15.233.44.26])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3DFD320D76485
 for <linux-nvdimm@lists.01.org>; Tue, 11 Apr 2017 13:45:50 -0700 (PDT)
Subject: Re: [RFC PATCH] Report the Health Status Detail for the HPE1 DSM
 family
References: <1490989421-20872-1-git-send-email-linda.knippers@hpe.com>
 <CAPcyv4gBBtfekmmgjn-CM-2UeD5-4fHXq2oBqx07WP9_dG_sbw@mail.gmail.com>
From: Linda Knippers <linda.knippers@hpe.com>
Message-ID: <58ED4074.90509@hpe.com>
Date: Tue, 11 Apr 2017 16:45:40 -0400
MIME-Version: 1.0
In-Reply-To: <CAPcyv4gBBtfekmmgjn-CM-2UeD5-4fHXq2oBqx07WP9_dG_sbw@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On 04/05/2017 04:53 PM, Dan Williams wrote:
> On Fri, Mar 31, 2017 at 12:43 PM, Linda Knippers <linda.knippers@hpe.com> wrote:
>> Dan,
>> This is an RFC because I'd like some initial feedback on the
>> approach.  I think this is what you had in mind from your last
>> exchanges with Brian but I wanted to check a few things before
>> going too far.
>>
>> 1) Do we want to export a library function for what could be a long
>> list of DSM-family-specific health information?  I think there
>> could be some common information between the HPE1 and MSFT DSM
>> but much will not be common.
> 
> Even for non-common information I want libndctl to hide the details
> about which DIMM families support which fields. Just extend the
> validity flags concept to make unsupported / family specific health
> data appear as just an invalid field to the library interface if the
> DIMM does not support it.
> 
>> 2) If we do export the functions, would we need to also export
>> the ndctl-hpe1.h include file or consolidate the information into
>> an already exported file?
> 
> I want to avoid libndctl ever exporting vendor-specific details. There
> may be json keys that only show up on one vendor's DIMMs, but that
> should be indistinguishable from a SMART payload that happens to clear
> a validity bit.
> 
>> 3) Do you want json-smart.c to keep growing or should new smart
>> functions provide their own matching json functions?
> 
> json-smart.c should understand the superset of all possible health
> fields, i.e. the union of all vendor fields that can possibly be
> returned. If this ever gets unwieldy it means we need to redouble
> standardization efforts.

Ok.  For the above 3, I think that's what my current patch does.
> 
>> 4) The code in json-smart.c with a macro was a quick prototype
>> but if you have feedback on the json parts, that would be appreciated.
>> Right now the detail is reported as a string if all is well and an
>> array if there are errors.  I'm not sure about that or whether
>> the strings should have spaces.
> 
> I think we should have all fields searchable as json keys in lowercase
> with underscores. 

Ok, will fix that.

> Lets handle these flags similar to the existing
> boolean alarm_temperature and alarm_spares flags, but with a small
> change. Since these flags are reporting some dimm-type-specific
> details I think we should only add them to the json when they are
> true. This way we won't have confusing entries like a
> '"energy_source_error":false' line for non-energy-source-backed dimms.

My current patch won't display an '*_error: false' for the field I added.
You'll either get "ok" (which means that the field is valid and no error bits
are set, like the health_state field) or you'll get just the specific errors.
If the field isn't valid at all, either because it's not supported by the NVDIMM
or because it wasn't marked as valid in the DSM output, nothing will added to
the json.

Going back to the example from my commit message (fixed the underscores), the
json for an NVDIMM for which the field isn't supported or isn't valid would be
unchanged.  For an NVDIMM that reports it and no bits are are,
this would be added:

      "health_status_detail":"ok"

For an NVDIMM that reports it and some bits are set, you'd get a json
array element for each bit that is set.  The worst case with all error
bits set is this:

      "health_status_detail":[
        "energy_source_error",
        "controller_error",
        "UC_ECC_error",
        "CE_trip",
        "save_error",
        "restore_error",
        "arm_error",
        "erase_error",
        "configuration_error",
        "firmware_error",
        "vendor_specific_error"
      ]

The more likely case is that there would just be one error, like
this:

      "health_status_detail":[
        "energy_source_error",
      ]

That could be "energy_source: error" or "energy_source_error: true".
I was trying to minimize the output on healthy systems and not add information
for non-errors. I wouldn't necessarily want to see a long list of
"energy_source_error: false".

> I'll go back and fix up 'alarm_spares' and 'alarm_temperature' to be
> hidden on DIMMs where they are always false.
> 
> Hmm, it seems like we need a "supported" vs "valid" distinction. Where
> supported but invalid shows flags in the 'false' state, but
> "unsupported" hides flags that are always going to be 'false'.

There are reasons that a field might be supported by the DSM family
but not valid for this particular device and it's not necessarily
an error.  At least for the fields I know about, unsupported and invalid
would make sense to treat the same way.  If something truly is broken,
the DSM would likely fail.

-- ljk
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
