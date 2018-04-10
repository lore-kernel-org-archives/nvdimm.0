Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5E0842270D350
 for <linux-nvdimm@lists.01.org>; Tue, 10 Apr 2018 10:05:58 -0700 (PDT)
Subject: Re: [PATCH] ndctl: fix libdaxctl memory leak
References: <152337938996.14344.7696749937613340141.stgit@djiang5-desk3.ch.intel.com>
 <CAPcyv4gXOzP-yFeBftc3T02r3hKNNJ0ENbuP0kKmMKOT3+PALw@mail.gmail.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <edc9108f-183c-ba75-dad3-5743523a1604@intel.com>
Date: Tue, 10 Apr 2018 10:05:57 -0700
MIME-Version: 1.0
In-Reply-To: <CAPcyv4gXOzP-yFeBftc3T02r3hKNNJ0ENbuP0kKmMKOT3+PALw@mail.gmail.com>
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



On 04/10/2018 10:01 AM, Dan Williams wrote:
> On Tue, Apr 10, 2018 at 9:56 AM, Dave Jiang <dave.jiang@intel.com> wrote:
>> When daxctl_unref is releasing the context, we should make sure that the
>> regions and devices are also being released.
>>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>> ---
>>  daxctl/lib/libdaxctl.c |    7 +++++++
>>  1 file changed, 7 insertions(+)
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
> 
> Sorry, should have mentioned this before. Why not use
> list_for_each_entry_safe() to iterate and delete regions like all the
> other free routines?
> 

Somehow I missed that even though I was looking for it. Will fix.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
