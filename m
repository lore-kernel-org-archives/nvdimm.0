Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6EB6081F6F
 for <linux-nvdimm@lists.01.org>; Thu,  8 Dec 2016 16:22:07 -0800 (PST)
Date: Thu, 8 Dec 2016 17:20:55 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [PATCH 2 1/2] ndctl: introduce 4k allocation support for
 creating namespace
Message-ID: <20161209002055.GA8333@omniknight.lm.intel.com>
References: <148124119683.166989.2517425646704949235.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <148124119683.166989.2517425646704949235.stgit@djiang5-desk3.ch.intel.com>
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
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 12/08, Dave Jiang wrote:
> Existing implementation defaults all pages allocated as 2M superpages.
> For nfit_test dax device we need 4k pages allocated to work properly.
> Adding an --align,-a option to provide the alignment. Will accept
> 4k and 2M at the moment as proper parameter. No -a option still defaults
> to 2M.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  ndctl/builtin-xaction-namespace.c |   34 +++++++++++++++++++++++++++++++---
>  util/size.h                       |    1 +
>  2 files changed, 32 insertions(+), 3 deletions(-)

A patch for bash completiion for this is at the bottom.

A minor nit below, but other than that:

Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>

> 
> diff --git a/ndctl/builtin-xaction-namespace.c b/ndctl/builtin-xaction-namespace.c
> index 8257eb9..038e59f 100644
> --- a/ndctl/builtin-xaction-namespace.c
> +++ b/ndctl/builtin-xaction-namespace.c
> @@ -49,6 +49,7 @@ static struct parameters {
>  	const char *region;
>  	const char *reconfig;
>  	const char *sector_size;
> +	const char *align;
>  } param;
>  
>  void builtin_xaction_namespace_reset(void)
> @@ -71,6 +72,7 @@ struct parsed_parameters {
>  	enum ndctl_namespace_mode mode;
>  	unsigned long long size;
>  	unsigned long sector_size;
> +	unsigned long align;
>  };
>  
>  #define debug(fmt, ...) \
> @@ -104,6 +106,8 @@ OPT_STRING('l', "sector-size", &param.sector_size, "lba-size", \
>  	"specify the logical sector size in bytes"), \
>  OPT_STRING('t', "type", &param.type, "type", \
>  	"specify the type of namespace to create 'pmem' or 'blk'"), \
> +OPT_STRING('a', "align", &param.align, "align", \
> +	"specify the namespace alignment in bytes (default: 0x200000 (2M))"), \
>  OPT_BOOLEAN('f', "force", &force, "reconfigure namespace even if currently active")
>  
>  static const struct option base_options[] = {
> @@ -319,14 +323,13 @@ static int setup_namespace(struct ndctl_region *region,
>  
>  		try(ndctl_pfn, set_uuid, pfn, uuid);
>  		try(ndctl_pfn, set_location, pfn, p->loc);
> -
>  		/*
>  		 * TODO: when we allow setting a non-default alignment
>  		 * we'll need to check for "has_align" earlier and fail
>  		 * non-default attempts on older kernels.
>  		 */
>  		if (ndctl_pfn_has_align(pfn))
> -			try(ndctl_pfn, set_align, pfn, SZ_2M);
> +			try(ndctl_pfn, set_align, pfn, p->align);
>  		try(ndctl_pfn, set_namespace, pfn, ndns);
>  		rc = ndctl_pfn_enable(pfn);
>  	} else if (p->mode == NDCTL_NS_MODE_DAX) {
> @@ -335,7 +338,7 @@ static int setup_namespace(struct ndctl_region *region,
>  		try(ndctl_dax, set_uuid, dax, uuid);
>  		try(ndctl_dax, set_location, dax, p->loc);
>  		/* device-dax assumes 'align' attribute present */
> -		try(ndctl_dax, set_align, dax, SZ_2M);
> +		try(ndctl_dax, set_align, dax, p->align);
>  		try(ndctl_dax, set_namespace, dax, ndns);
>  		rc = ndctl_dax_enable(dax);
>  	} else if (p->mode == NDCTL_NS_MODE_SAFE) {
> @@ -439,6 +442,31 @@ static int validate_namespace_options(struct ndctl_region *region,
>  	} else if (ndns)
>  		p->mode = ndctl_namespace_get_mode(ndns);
>  
> +	if ((p->mode == NDCTL_NS_MODE_MEMORY) ||
> +			(p->mode == NDCTL_NS_MODE_DAX)) {
> +		struct ndctl_pfn *pfn = ndctl_region_get_pfn_seed(region);
> +
> +		if (!ndctl_pfn_has_align(pfn))
> +			return -EINVAL;
> +
> +		if (param.align) {
> +			p->align = parse_size64(param.align);
> +			switch (p->align) {
> +			case SZ_4K:
> +			case SZ_2M:
> +				break;
> +			case SZ_1G: /* unsupported yet... */
> +			default:
> +				debug("%s: invalid align\n", __func__);

s/align/alignment ?

<snip>

8<----

>From e705e371fd3c5ab00572db30955f2ee18ba74134 Mon Sep 17 00:00:00 2001
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Thu, 8 Dec 2016 17:16:45 -0700
Subject: [ndctl PATCH] ndctl: add the new --align option to bash completion

Add completion for --align, and provide only the expected options of 4K,
2M, and 1G.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 contrib/ndctl | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/contrib/ndctl b/contrib/ndctl
index ea7303c..162d47f 100755
--- a/contrib/ndctl
+++ b/contrib/ndctl
@@ -91,7 +91,7 @@ __ndctlcomp()
 
 	COMPREPLY=( $( compgen -W "$1" -- "$2" ) )
 	for cword in "${COMPREPLY[@]}"; do
-		if [[ "$cword" == @(--bus|--region|--type|--mode|--size|--dimm|--reconfig|--uuid|--name|--sector-size|--map|--namespace) ]]; then
+		if [[ "$cword" == @(--bus|--region|--type|--mode|--size|--dimm|--reconfig|--uuid|--name|--sector-size|--map|--namespace|--align) ]]; then
 			COMPREPLY[$i]="${cword}="
 		else
 			COMPREPLY[$i]="${cword} "
@@ -171,6 +171,9 @@ __ndctl_comp_options()
 		--map)
 			opts="mem dev"
 			;;
+		--align)
+			opts="4K 2M 1G"
+			;;
 		*)
 			return
 			;;
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
