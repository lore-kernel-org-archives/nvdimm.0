Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x244.google.com (mail-oi0-x244.google.com
 [IPv6:2607:f8b0:4003:c06::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 75B1B20348620
 for <linux-nvdimm@lists.01.org>; Wed,  9 May 2018 16:26:53 -0700 (PDT)
Received: by mail-oi0-x244.google.com with SMTP id 11-v6so210709ois.8
 for <linux-nvdimm@lists.01.org>; Wed, 09 May 2018 16:26:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <279b4a0d-f9aa-a134-35a5-221ee6e43e4a@intel.com>
References: <152486678857.66587.12260245215754521561.stgit@djiang5-desk3.ch.intel.com>
 <152486690886.66587.10650176680608823926.stgit@djiang5-desk3.ch.intel.com>
 <1525907870.4429.3.camel@intel.com>
 <CAPcyv4gM-rtfHc=0OTQnSW9YO5z5JGm0LOwc73mhqS-i1njLEQ@mail.gmail.com>
 <279b4a0d-f9aa-a134-35a5-221ee6e43e4a@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 9 May 2018 16:26:52 -0700
Message-ID: <CAPcyv4g4oXgjPz=wiYpnOd725vPbyfAZT1LOmaxJ_A989bNUNw@mail.gmail.com>
Subject: Re: [PATCH v5 3/4] ndctl: convert region actions to use
 util_filter_walk()
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, May 9, 2018 at 4:24 PM, Dave Jiang <dave.jiang@intel.com> wrote:
>
>
> On 05/09/2018 04:23 PM, Dan Williams wrote:
>> On Wed, May 9, 2018 at 4:17 PM, Verma, Vishal L
>> <vishal.l.verma@intel.com> wrote:
>>> On Fri, 2018-04-27 at 15:08 -0700, Dave Jiang wrote:
>>>> util_filter_walk() does the looping through of busses and regions.
>>>> Removing
>>>> duplicate code in region ops and provide filter functions so we can
>>>> utilize util_filter_walk() and share common code.
>>>>
>>>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>>>> ---
>>>>  ndctl/region.c |   59 ++++++++++++++++++++++++++++++++++--------------
>>>> --------
>>>>  util/filter.h  |    6 ++++++
>>>>  2 files changed, 42 insertions(+), 23 deletions(-)
>>>>
>>>> diff --git a/ndctl/region.c b/ndctl/region.c
>>>> index 9fc90808..9fd07af6 100644
>>>> --- a/ndctl/region.c
>>>> +++ b/ndctl/region.c
>>>> @@ -19,10 +19,7 @@
>>>>  #include <util/parse-options.h>
>>>>  #include <ndctl/libndctl.h>
>>>>
>>>> -static struct {
>>>> -     const char *bus;
>>>> -     const char *type;
>>>> -} param;
>>>> +struct util_filter_params param;
>>>>
>>>>  static const struct option region_options[] = {
>>>>       OPT_STRING('b', "bus", &param.bus, "bus-id",
>>>> @@ -92,33 +89,49 @@ static int region_action(struct ndctl_region *region,
>>>> enum device_action mode)
>>>>       return 0;
>>>>  }
>>>>
>>>> +static bool filter_bus(struct ndctl_bus *bus, struct util_filter_ctx
>>>> *ctx)
>>>> +{
>>>> +     return true;
>>>> +}
>>>> +
>>>
>>> Instead of creating these trivial functions everywhere (also applies to
>>> namespaces.c, dimm.c), should we just leave fctx.bus_filter NULL. And fix
>>> util_filter_walk to check for fctx->ptr != NULL any time it calls one of
>>> the functions..
>>
>> I think I'd prefer a common nop routine. That way individual are
>> forced to decide to use the nop or implement something. Leaving it
>> NULL may just be a programming mistake. I.e. it's harder to get wrong
>> if it's required.
>>
>
> I'll add a common nop routine.

...but wait why would it be a nop in this case. Region action commands
take a --bus= option?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
