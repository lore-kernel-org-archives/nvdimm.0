Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E40612270D322
 for <linux-nvdimm@lists.01.org>; Tue, 10 Apr 2018 10:43:33 -0700 (PDT)
Subject: Re: [PATCH v2] ndctl: fix libdaxctl memory leak
References: <152338060678.17137.14896323871568581107.stgit@djiang5-desk3.ch.intel.com>
 <A7FB1D6BACEF4D4EB3E2672A06076E736A708556@irsmsx111.ger.corp.intel.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <d1e27bcd-2d91-017f-620d-fbd5284c0d00@intel.com>
Date: Tue, 10 Apr 2018 10:43:32 -0700
MIME-Version: 1.0
In-Reply-To: <A7FB1D6BACEF4D4EB3E2672A06076E736A708556@irsmsx111.ger.corp.intel.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: "Plewa, Lukasz" <lukasz.plewa@intel.com>, "Verma, Vishal L" <vishal.l.verma@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



On 04/10/2018 10:38 AM, Plewa, Lukasz wrote:
> On Tue, Apr 10, 2018 at 7:17 PM, Dave Jiang <dave.jiang@intel.com> wrote:
>> When daxctl_unref is releasing the context, we should make sure that the
>> regions and devices are also being released. free_region() will free all=
 the
>> devices under the region.
>>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>> ---
>>
>> v2: Use list_for_each_safe() for region removal. (Dan)
>>
>>  daxctl/lib/libdaxctl.c |    8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c index
>> 9e503201..22f4210a 100644
>> --- a/daxctl/lib/libdaxctl.c
>> +++ b/daxctl/lib/libdaxctl.c
>> @@ -29,6 +29,8 @@
>>
>>  static const char *attrs =3D "dax_region";
>>
>> +static void free_region(struct daxctl_region *region, struct list_head
>> +*head);
>> +
>>  /**
>>   * struct daxctl_ctx - library user context to find "nd" instances
>>   *
>> @@ -119,11 +121,17 @@ DAXCTL_EXPORT struct daxctl_ctx
>> *daxctl_ref(struct daxctl_ctx *ctx)
>>   */
>>  DAXCTL_EXPORT void daxctl_unref(struct daxctl_ctx *ctx)  {
>> +	struct daxctl_region *region, *_r;
>> +
>>  	if (ctx =3D=3D NULL)
>>  		return;
>>  	ctx->refcount--;
>>  	if (ctx->refcount > 0)
>>  		return;
>> +
>> +	list_for_each_safe(&ctx->regions, region, _r, list)
>> +		free_region(region, &ctx->regions);
>> +
>>  	info(ctx, "context %p released\n", ctx);
>>  	free(ctx);
>>  }
> =

> As daxctl_region has its own refcount, you need daxctl_ref() in add_dax_r=
egion() and daxctl_unref() in free_region().( or daxctl_ref() in daxctl_reg=
ion_ref() and daxctl_unref() in daxctl_region_unref())
> =

> Without it, this code will cause segfault:
>  =

> daxctl_new(&ctx);
> region =3D daxctl_new_region(...);
> daxctl_region_ref(region);
> daxctl_unref(ctx);
> daxctl_region_unref(region);

Shouldn't it go in this order:

daxctl_region_unref(region);
daxctl_unref(ctx);

In this case, you won't segfault right? I think ctx should be the very
last thing you free.

> =

> =A3ukasz
> =

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
