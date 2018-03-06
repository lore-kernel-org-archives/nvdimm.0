Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 630E022283530
 for <linux-nvdimm@lists.01.org>; Mon,  5 Mar 2018 16:32:04 -0800 (PST)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH] ndctl, create-namespace: fix minimum alignment
 detection
Date: Tue, 6 Mar 2018 00:38:16 +0000
Message-ID: <1520296694.24924.69.camel@intel.com>
References: <152011374766.14937.7017387737157056826.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152011374766.14937.7017387737157056826.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
Content-ID: <7428F778E2BDCE47877555E798ABFA4B@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: "Ramotowski, Maciej" <maciej.ramotowski@intel.com>
List-ID: <linux-nvdimm@lists.01.org>


On Sat, 2018-03-03 at 13:49 -0800, Dan Williams wrote:
> Commit 0c31ce0a2875 "ndctl, create-namespace: fix --align=
> default..."
> tried to make casual testing with nfit_test easier by auto-detecting
> the
> alignment. However, this auto-detection always falls back to 4K
> alignment on kernels that do not export the region 'resource'
> attribute.
> Those kernels, like v4.9.4, may also be missing this fix: commit
> cd755677d944 "libnvdimm, pfn: fix memmap reservation size versus 4K
> alignment".
> 
> Given the chance to fail to initialize a namespace in the 4K case on
> older kernels, be more conservative about falling back to 4K
> alignment.
> 
> Link: https://github.com/pmem/ndctl/issues/34
> Reported-by: Maciej Ramotowski <maciej.ramotowski@intel.com>
> Fixes: 0c31ce0a2875 ("ndctl, create-namespace: fix --align=
> default...")
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  ndctl/namespace.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 

Looks good, queued for v60.

> diff --git a/ndctl/namespace.c b/ndctl/namespace.c
> index ceb9e7a9b8af..aef356abbee1 100644
> --- a/ndctl/namespace.c
> +++ b/ndctl/namespace.c
> @@ -462,7 +462,7 @@ static int validate_namespace_options(struct
> ndctl_region *region,
>  		struct ndctl_namespace *ndns, struct
> parsed_parameters *p)
>  {
>  	const char *region_name = ndctl_region_get_devname(region);
> -	unsigned long long size_align = SZ_4K, units = 1;
> +	unsigned long long size_align = SZ_4K, units = 1, resource;
>  	unsigned int ways;
>  	int rc = 0;
>  
> @@ -563,8 +563,9 @@ static int validate_namespace_options(struct
> ndctl_region *region,
>  		 * the nfit_test use case where it is backed by
> vmalloc
>  		 * memory.
>  		 */
> -		if (param.align_default &&
> (ndctl_region_get_resource(region)
> -					& (SZ_2M - 1))) {
> +		resource = ndctl_region_get_resource(region);
> +		if (param.align_default && resource < ULLONG_MAX
> +				&& (resource & (SZ_2M - 1))) {
>  			debug("%s: falling back to a 4K
> alignment\n",
>  					region_name);
>  			p->align = SZ_4K;
> 
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
