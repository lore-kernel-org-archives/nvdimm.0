Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 35CE7225FA07F
 for <linux-nvdimm@lists.01.org>; Tue, 10 Apr 2018 10:38:43 -0700 (PDT)
From: "Plewa, Lukasz" <lukasz.plewa@intel.com>
Subject: RE: [PATCH v2] ndctl: fix libdaxctl memory leak
Date: Tue, 10 Apr 2018 17:38:40 +0000
Message-ID: <A7FB1D6BACEF4D4EB3E2672A06076E736A708556@irsmsx111.ger.corp.intel.com>
References: <152338060678.17137.14896323871568581107.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <152338060678.17137.14896323871568581107.stgit@djiang5-desk3.ch.intel.com>
Content-Language: en-US
MIME-Version: 1.0
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
To: "Jiang, Dave" <dave.jiang@intel.com>, "Verma, Vishal L" <vishal.l.verma@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Apr 10, 2018 at 7:17 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> When daxctl_unref is releasing the context, we should make sure that the
> regions and devices are also being released. free_region() will free all =
the
> devices under the region.
> =

> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
> =

> v2: Use list_for_each_safe() for region removal. (Dan)
> =

>  daxctl/lib/libdaxctl.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> =

> diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c index
> 9e503201..22f4210a 100644
> --- a/daxctl/lib/libdaxctl.c
> +++ b/daxctl/lib/libdaxctl.c
> @@ -29,6 +29,8 @@
> =

>  static const char *attrs =3D "dax_region";
> =

> +static void free_region(struct daxctl_region *region, struct list_head
> +*head);
> +
>  /**
>   * struct daxctl_ctx - library user context to find "nd" instances
>   *
> @@ -119,11 +121,17 @@ DAXCTL_EXPORT struct daxctl_ctx
> *daxctl_ref(struct daxctl_ctx *ctx)
>   */
>  DAXCTL_EXPORT void daxctl_unref(struct daxctl_ctx *ctx)  {
> +	struct daxctl_region *region, *_r;
> +
>  	if (ctx =3D=3D NULL)
>  		return;
>  	ctx->refcount--;
>  	if (ctx->refcount > 0)
>  		return;
> +
> +	list_for_each_safe(&ctx->regions, region, _r, list)
> +		free_region(region, &ctx->regions);
> +
>  	info(ctx, "context %p released\n", ctx);
>  	free(ctx);
>  }

As daxctl_region has its own refcount, you need daxctl_ref() in add_dax_reg=
ion() and daxctl_unref() in free_region().( or daxctl_ref() in daxctl_regio=
n_ref() and daxctl_unref() in daxctl_region_unref())

Without it, this code will cause segfault:
 =

daxctl_new(&ctx);
region =3D daxctl_new_region(...);
daxctl_region_ref(region);
daxctl_unref(ctx);
daxctl_region_unref(region);

=A3ukasz
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
