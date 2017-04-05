Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qt0-x229.google.com (mail-qt0-x229.google.com
 [IPv6:2607:f8b0:400d:c0d::229])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BCAC120D7783C
 for <linux-nvdimm@lists.01.org>; Wed,  5 Apr 2017 13:53:40 -0700 (PDT)
Received: by mail-qt0-x229.google.com with SMTP id r45so21471423qte.3
 for <linux-nvdimm@lists.01.org>; Wed, 05 Apr 2017 13:53:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1490989421-20872-1-git-send-email-linda.knippers@hpe.com>
References: <1490989421-20872-1-git-send-email-linda.knippers@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 5 Apr 2017 13:53:39 -0700
Message-ID: <CAPcyv4gBBtfekmmgjn-CM-2UeD5-4fHXq2oBqx07WP9_dG_sbw@mail.gmail.com>
Subject: Re: [RFC PATCH] Report the Health Status Detail for the HPE1 DSM
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

On Fri, Mar 31, 2017 at 12:43 PM, Linda Knippers <linda.knippers@hpe.com> wrote:
> Dan,
> This is an RFC because I'd like some initial feedback on the
> approach.  I think this is what you had in mind from your last
> exchanges with Brian but I wanted to check a few things before
> going too far.
>
> 1) Do we want to export a library function for what could be a long
> list of DSM-family-specific health information?  I think there
> could be some common information between the HPE1 and MSFT DSM
> but much will not be common.

Even for non-common information I want libndctl to hide the details
about which DIMM families support which fields. Just extend the
validity flags concept to make unsupported / family specific health
data appear as just an invalid field to the library interface if the
DIMM does not support it.

> 2) If we do export the functions, would we need to also export
> the ndctl-hpe1.h include file or consolidate the information into
> an already exported file?

I want to avoid libndctl ever exporting vendor-specific details. There
may be json keys that only show up on one vendor's DIMMs, but that
should be indistinguishable from a SMART payload that happens to clear
a validity bit.

> 3) Do you want json-smart.c to keep growing or should new smart
> functions provide their own matching json functions?

json-smart.c should understand the superset of all possible health
fields, i.e. the union of all vendor fields that can possibly be
returned. If this ever gets unwieldy it means we need to redouble
standardization efforts.

> 4) The code in json-smart.c with a macro was a quick prototype
> but if you have feedback on the json parts, that would be appreciated.
> Right now the detail is reported as a string if all is well and an
> array if there are errors.  I'm not sure about that or whether
> the strings should have spaces.

I think we should have all fields searchable as json keys in lowercase
with underscores. Lets handle these flags similar to the existing
boolean alarm_temperature and alarm_spares flags, but with a small
change. Since these flags are reporting some dimm-type-specific
details I think we should only add them to the json when they are
true. This way we won't have confusing entries like a
'"energy_source_error":false' line for non-energy-source-backed dimms.
I'll go back and fix up 'alarm_spares' and 'alarm_temperature' to be
hidden on DIMMs where they are always false.

Hmm, it seems like we need a "supported" vs "valid" distinction. Where
supported but invalid shows flags in the 'false' state, but
"unsupported" hides flags that are always going to be 'false'.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
