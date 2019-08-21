Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F351520212C87
 for <linux-nvdimm@lists.01.org>; Wed, 21 Aug 2019 05:57:19 -0700 (PDT)
Date: Wed, 21 Aug 2019 14:56:05 +0200
From: Michal =?UTF-8?B?U3VjaMOhbmVr?= <msuchanek@suse.de>
Subject: Re: [ndctl PATCH v2 14/26] ndctl/namespace: Handle
 'create-namespace' in label-less mode
Message-ID: <20190821145605.206372a0@kitsune.suse.cz>
In-Reply-To: <156426363655.531577.4504452379578995249.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <156426356088.531577.14828880045306313118.stgit@dwillia2-desk3.amr.corp.intel.com>
 <156426363655.531577.4504452379578995249.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hello,

this patch is marked as superseded in the patchwork.

What is the intended replacement?

Thanks

Michal

On Sat, 27 Jul 2019 14:40:36 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> A common confusion with ndctl is that 'create-namespace' does not work
> in the label-less case. In the label-less case there is no capacity to
> allocate as the size if already hard-coded by the region boundary.
> 
> However, users typically do something like the following in the
> label-less case:
> 
>     # ndctl list
>     {
>       "dev":"namespace1.0",
>       "mode":"raw",
>       "size":"127.00 GiB (136.37 GB)",
>       "sector_size":512,
>       "blockdev":"pmem1"
>     }
> 
>     # ndctl destroy-namespace namespace1.0 -f
>     destroyed 1 namespace
> 
>     # ndctl create-namespace
>     failed to create namespace: Resource temporarily unavailable
> 
> In other words they destroy the raw mode namespace that they don't want,
> and seek to create a new default configuration namespace. Since there is
> no "available_capacity" in the label-less case the 'create' attempt
> fails.
> 
> Fix this by recognizing that the user wants a default sized namespace
> and just reconfigure the raw namespace.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  ndctl/namespace.c |   10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/ndctl/namespace.c b/ndctl/namespace.c
> index 58fec194ab94..e5a2b1341cdb 100644
> --- a/ndctl/namespace.c
> +++ b/ndctl/namespace.c
> @@ -837,9 +837,13 @@ static int namespace_create(struct ndctl_region *region)
>  		return -EAGAIN;
>  	}
>  
> -	available = ndctl_region_get_max_available_extent(region);
> -	if (available == ULLONG_MAX)
> -		available = ndctl_region_get_available_size(region);
> +	if (ndctl_region_get_nstype(region) == ND_DEVICE_NAMESPACE_IO)
> +		available = ndctl_region_get_size(region);
> +	else {
> +		available = ndctl_region_get_max_available_extent(region);
> +		if (available == ULLONG_MAX)
> +			available = ndctl_region_get_available_size(region);
> +	}
>  	if (!available || p.size > available) {
>  		debug("%s: insufficient capacity size: %llx avail: %llx\n",
>  			devname, p.size, available);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
