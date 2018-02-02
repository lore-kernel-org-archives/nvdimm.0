Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AE19C223CCF17
 for <linux-nvdimm@lists.01.org>; Fri,  2 Feb 2018 07:09:54 -0800 (PST)
From: "Plewa, Lukasz" <lukasz.plewa@intel.com>
Subject: RE: [ndctl PATCH] ndctl: fix leak of daxctl_region instances
Date: Fri, 2 Feb 2018 15:15:29 +0000
Message-ID: <A7FB1D6BACEF4D4EB3E2672A06076E736A6EB69A@irsmsx111.ger.corp.intel.com>
References: <151756015373.24501.12460100041032944306.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151756015373.24501.12460100041032944306.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
MIME-Version: 1.0
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
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

This fix will not work, as daxctl_ctx is freed before free_dax() and daxctl_region_unref() tries to update daxctl_ctx. 

> -----Original Message-----
> From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On Behalf
> Of Dan Williams
> Sent: Friday, February 2, 2018 09:29
> To: linux-nvdimm@lists.01.org
> Subject: [ndctl PATCH] ndctl: fix leak of daxctl_region instances
> 
> The daxctl_region returned by ndctl_dax_get_daxctl_region() should be
> automatically freed when its parent infrastructure is torn down.
> 
> Reported-by: Lukasz Plewa <lukasz.plewa@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  ndctl/lib/libndctl.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c index
> 4119a2e6b564..9314e8b8f81b 100644
> --- a/ndctl/lib/libndctl.c
> +++ b/ndctl/lib/libndctl.c
> @@ -434,6 +434,7 @@ static void free_pfn(struct ndctl_pfn *pfn, struct
> list_head *head)
> 
>  static void free_dax(struct ndctl_dax *dax, struct list_head *head)  {
> +	daxctl_region_unref(dax->region);
>  	__free_pfn(&dax->pfn, head, dax);
>  }
> 
> 
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
