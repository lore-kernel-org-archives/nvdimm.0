Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 87BD32270D343
 for <linux-nvdimm@lists.01.org>; Tue, 10 Apr 2018 08:59:58 -0700 (PDT)
Subject: Re: [PATCH] ndctl: fix daxctl list memory leak
References: <152331919110.20574.2359248862392897661.stgit@djiang5-desk3.ch.intel.com>
 <CAPcyv4jPDrVAa=BEHz_OU4xktGtRN36NwTZ48KOgkCMfXMQcYg@mail.gmail.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <9065c8ae-e78f-70b1-8919-8144025621a4@intel.com>
Date: Tue, 10 Apr 2018 08:59:57 -0700
MIME-Version: 1.0
In-Reply-To: <CAPcyv4jPDrVAa=BEHz_OU4xktGtRN36NwTZ48KOgkCMfXMQcYg@mail.gmail.com>
Content-Language: en-US
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
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



On 04/09/2018 07:39 PM, Dan Williams wrote:
> On Mon, Apr 9, 2018 at 5:13 PM, Dave Jiang <dave.jiang@intel.com> wrote:
>> daxctl list is not calling daxctl_unref() when executed succesfully. At the same
>> time, daxctl_region_unref() is not being called when daxctl_unref() executes.
>> Valgrind is reporting unfreed memory. Adding the appropriate calls to make sure
>> all memory allocated are freed for daxctl list.
>>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>> ---
>>  daxctl/lib/libdaxctl.c |    7 +++++++
>>  daxctl/list.c          |    1 +
>>  2 files changed, 8 insertions(+)
>>
>> diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
>> index 9e503201..0552f6d7 100644
>> --- a/daxctl/lib/libdaxctl.c
>> +++ b/daxctl/lib/libdaxctl.c
>> @@ -119,11 +119,18 @@ DAXCTL_EXPORT struct daxctl_ctx *daxctl_ref(struct daxctl_ctx *ctx)
>>   */
>>  DAXCTL_EXPORT void daxctl_unref(struct daxctl_ctx *ctx)
>>  {
>> +       struct daxctl_region *region;
>> +
>>         if (ctx == NULL)
>>                 return;
>>         ctx->refcount--;
>>         if (ctx->refcount > 0)
>>                 return;
>> +
>> +       while ((region = list_top(&ctx->regions, struct daxctl_region, list)) !=
>> +                       NULL)
>> +               daxctl_region_unref(region);
>> +
>>         info(ctx, "context %p released\n", ctx);
>>         free(ctx);
>>  }
>> diff --git a/daxctl/list.c b/daxctl/list.c
>> index 254f0ac9..9b18ae8d 100644
>> --- a/daxctl/list.c
>> +++ b/daxctl/list.c
>> @@ -134,6 +134,7 @@ int cmd_list(int argc, const char **argv, void *ctx)
>>         else if (jdevs)
>>                 util_display_json_array(stdout, jdevs, jflag);
>>
>> +       daxctl_unref(ctx);
> 
> This should move to daxctl/daxctl.c similar to the ndctl_unref() in
> ndctl/ndctl.c
> 
With the way things are coded right now that's the exit function and we
can't have it in daxctl.c. main_handle_internal_commands gets called and
that invokes exit() on the matched commands. We never return from that.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
