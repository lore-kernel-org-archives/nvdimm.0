Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F184C211E2BF5
 for <linux-nvdimm@lists.01.org>; Wed, 20 Mar 2019 18:41:56 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH v2 3/4] ndctl, lib: implement
 ndctl_dimm_get_cmd_family()
Date: Thu, 21 Mar 2019 01:41:54 +0000
Message-ID: <221ceaa03f0a46d020da7a1c7fcd4d521bf5e09e.camel@intel.com>
References: <PU1P153MB01696E7773E8C8129D8CCE8BBF7D0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
In-Reply-To: <PU1P153MB01696E7773E8C8129D8CCE8BBF7D0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
Content-Language: en-US
Content-ID: <8C74B6E8A39100479ECDAA42011DCFA8@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, "decui@microsoft.com" <decui@microsoft.com>, "Jiang, Dave" <dave.jiang@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "mikelley@microsoft.com" <mikelley@microsoft.com>, "qi.fuli@fujitsu.com" <qi.fuli@fujitsu.com>
List-ID: <linux-nvdimm@lists.01.org>


On Wed, 2019-02-20 at 05:11 +0000, Dexuan Cui wrote:
> Let's export the family info so we can do some family-specific
> handling in ndctl/monitor.c for Hyper-V NVDIMM.

s/Let's//

> 
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> ---
>  ndctl/lib/libndctl.c   | 5 +++++
>  ndctl/lib/libndctl.sym | 1 +
>  ndctl/libndctl.h       | 1 +
>  3 files changed, 7 insertions(+)
> 
> diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
> index 48bdb27..1186579 100644
> --- a/ndctl/lib/libndctl.c
> +++ b/ndctl/lib/libndctl.c
> @@ -1550,6 +1550,11 @@ NDCTL_EXPORT struct ndctl_dimm *ndctl_dimm_get_next(struct ndctl_dimm *dimm)
>  	return list_next(&bus->dimms, dimm, list);
>  }
>  
> +NDCTL_EXPORT unsigned long ndctl_dimm_get_cmd_family(struct ndctl_dimm *dimm)
> +{
> +	return dimm->cmd_family;
> +}
> +
>  NDCTL_EXPORT unsigned int ndctl_dimm_get_handle(struct ndctl_dimm *dimm)
>  {
>  	return dimm->handle;
> diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
> index cb9f769..470e895 100644
> --- a/ndctl/lib/libndctl.sym
> +++ b/ndctl/lib/libndctl.sym
> @@ -38,6 +38,7 @@ global:
>  	ndctl_bus_wait_probe;
>  	ndctl_dimm_get_first;
>  	ndctl_dimm_get_next;
> +	ndctl_dimm_get_cmd_family;

Any new APIs need to go in a new LIBNDCTL_XX section (for this release
that would be LIBNDCTL_20).
If you rebase to the current 'pending' branch on github, the section has
already been created at the bottom, and you can just add to that.

>  	ndctl_dimm_get_handle;
>  	ndctl_dimm_get_phys_id;
>  	ndctl_dimm_get_vendor;
> diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
> index 0debdb6..cb5a8fc 100644
> --- a/ndctl/libndctl.h
> +++ b/ndctl/libndctl.h
> @@ -145,6 +145,7 @@ struct ndctl_dimm *ndctl_dimm_get_next(struct ndctl_dimm *dimm);
>          for (dimm = ndctl_dimm_get_first(bus); \
>               dimm != NULL; \
>               dimm = ndctl_dimm_get_next(dimm))
> +unsigned long ndctl_dimm_get_cmd_family(struct ndctl_dimm *dimm);
>  unsigned int ndctl_dimm_get_handle(struct ndctl_dimm *dimm);
>  unsigned short ndctl_dimm_get_phys_id(struct ndctl_dimm *dimm);
>  unsigned short ndctl_dimm_get_vendor(struct ndctl_dimm *dimm);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
