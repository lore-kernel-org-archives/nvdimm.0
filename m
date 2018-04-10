Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x241.google.com (mail-ot0-x241.google.com
 [IPv6:2607:f8b0:4003:c0f::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 04B622270D33B
 for <linux-nvdimm@lists.01.org>; Tue, 10 Apr 2018 09:07:12 -0700 (PDT)
Received: by mail-ot0-x241.google.com with SMTP id m22-v6so10306948otf.8
 for <linux-nvdimm@lists.01.org>; Tue, 10 Apr 2018 09:07:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <9065c8ae-e78f-70b1-8919-8144025621a4@intel.com>
References: <152331919110.20574.2359248862392897661.stgit@djiang5-desk3.ch.intel.com>
 <CAPcyv4jPDrVAa=BEHz_OU4xktGtRN36NwTZ48KOgkCMfXMQcYg@mail.gmail.com>
 <9065c8ae-e78f-70b1-8919-8144025621a4@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 10 Apr 2018 09:07:11 -0700
Message-ID: <CAPcyv4jtS47PRW5h81K2fYWq3fnDWD7uk1VqjQ4aYA4vimv7=g@mail.gmail.com>
Subject: Re: [PATCH] ndctl: fix daxctl list memory leak
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
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Apr 10, 2018 at 8:59 AM, Dave Jiang <dave.jiang@intel.com> wrote:
>
>
> On 04/09/2018 07:39 PM, Dan Williams wrote:
>> On Mon, Apr 9, 2018 at 5:13 PM, Dave Jiang <dave.jiang@intel.com> wrote:
>>> daxctl list is not calling daxctl_unref() when executed succesfully. At the same
>>> time, daxctl_region_unref() is not being called when daxctl_unref() executes.
>>> Valgrind is reporting unfreed memory. Adding the appropriate calls to make sure
>>> all memory allocated are freed for daxctl list.
>>>
>>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>>> ---
>>>  daxctl/lib/libdaxctl.c |    7 +++++++
>>>  daxctl/list.c          |    1 +
>>>  2 files changed, 8 insertions(+)
>>>
>>> diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
>>> index 9e503201..0552f6d7 100644
>>> --- a/daxctl/lib/libdaxctl.c
>>> +++ b/daxctl/lib/libdaxctl.c
>>> @@ -119,11 +119,18 @@ DAXCTL_EXPORT struct daxctl_ctx *daxctl_ref(struct daxctl_ctx *ctx)
>>>   */
>>>  DAXCTL_EXPORT void daxctl_unref(struct daxctl_ctx *ctx)
>>>  {
>>> +       struct daxctl_region *region;
>>> +
>>>         if (ctx == NULL)
>>>                 return;
>>>         ctx->refcount--;
>>>         if (ctx->refcount > 0)
>>>                 return;
>>> +
>>> +       while ((region = list_top(&ctx->regions, struct daxctl_region, list)) !=
>>> +                       NULL)
>>> +               daxctl_region_unref(region);
>>> +
>>>         info(ctx, "context %p released\n", ctx);
>>>         free(ctx);
>>>  }
>>> diff --git a/daxctl/list.c b/daxctl/list.c
>>> index 254f0ac9..9b18ae8d 100644
>>> --- a/daxctl/list.c
>>> +++ b/daxctl/list.c
>>> @@ -134,6 +134,7 @@ int cmd_list(int argc, const char **argv, void *ctx)
>>>         else if (jdevs)
>>>                 util_display_json_array(stdout, jdevs, jflag);
>>>
>>> +       daxctl_unref(ctx);
>>
>> This should move to daxctl/daxctl.c similar to the ndctl_unref() in
>> ndctl/ndctl.c
>>
> With the way things are coded right now that's the exit function and we
> can't have it in daxctl.c. main_handle_internal_commands gets called and
> that invokes exit() on the matched commands. We never return from that.

Then we need to fix that. cmd_list() should not be releasing
references that it did not take. How is daxctl::cmd_list() leaky but
ndctl::cmd_list() is not?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
