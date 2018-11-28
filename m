Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail1.bemta24.messagelabs.com (mail1.bemta24.messagelabs.com
 [67.219.250.3])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 57D6221A00AE6
 for <linux-nvdimm@lists.01.org>; Wed, 28 Nov 2018 00:06:32 -0800 (PST)
From: Ocean HY1 He <hehy1@lenovo.com>
Subject: RE: [External]  [ndctl PATCH] ndctl: recover from failed namespace
 creation
Date: Wed, 28 Nov 2018 08:06:14 +0000
Message-ID: <HK0PR03MB31706B351BB2BF094047B46B89D10@HK0PR03MB3170.apcprd03.prod.outlook.com>
References: <1536654669-23828-1-git-send-email-oceanhehy@gmail.com>
In-Reply-To: <1536654669-23828-1-git-send-email-oceanhehy@gmail.com>
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
To: "oceanhehy@gmail.com" <oceanhehy@gmail.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "vishal.l.verma@intel.com" <vishal.l.verma@intel.com>, "qi.fuli@jp.fujitsu.com" <qi.fuli@jp.fujitsu.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi Dan,

I am trying to track this patch and looking forward to get your comments.

Many thanks!

Ocean.

> -----Original Message-----
> From: oceanhehy@gmail.com <oceanhehy@gmail.com>
> Sent: Tuesday, September 11, 2018 4:31 PM
> To: dan.j.williams@intel.com; vishal.l.verma@intel.com; qi.fuli@jp.fujitsu.com;
> linux-nvdimm@lists.01.org
> Cc: Ocean HY1 He <hehy1@lenovo.com>
> Subject: [External] [ndctl PATCH] ndctl: recover from failed namespace
> creation
> 
> From: Ocean He <hehy1@lenovo.com>
> 
> When namespace creation failure occurs, the consumed namespace (seed or
> 0th
> idle) and pfn/dax seed would block next namespace creation. A recovery is
> needed to handle this type failure.
> 
> A symptom example (section size is 128MB) based on kernel 4.19-rc2 and
> ndctl v62:
> 	# ndctl create-namespace -r region1 -s 100m -t pmem -m fsdax
> 	{
> 	  "dev":"namespace1.0",
> 	  "mode":"fsdax",
> 	  "map":"dev",
> 	  "size":"96.00 MiB (100.66 MB)",
> 	  "uuid":"ef9a0556-a610-40b5-8c71-43991765a2cc",
> 	  "raw_uuid":"177b22e2-b7e8-482f-a063-2b8de876d979",
> 	  "sector_size":512,
> 	  "blockdev":"pmem1",
> 	  "numa_node":1
> 	}
> 	# ndctl create-namespace -r region1 -s 100m -t pmem -m fsdax
> 	libndctl: ndctl_pfn_enable: pfn1.1: failed to enable
> 	  Error: namespace1.1: failed to enable
> 	failed to create namespace: No such device or address
> 	# ndctl destroy-namespace namespace1.0 -f
> 	destroyed 1 namespace
> 	# ndctl create-namespace -r region1 -s 128m -t pmem -m fsdax
> 	failed to create namespace: Device or resource busy
> 
> Signed-off-by: Ocean He <hehy1@lenovo.com>
> ---
> Additional information:
> A kernel patch to fix this has been reviewed by Dan Williams, and he prefers
> to handle it in ndctl directly.
> https://www.spinics.net/lists/kernel/msg2901465.html
> 
>  ndctl/namespace.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/ndctl/namespace.c b/ndctl/namespace.c
> index 510553c..76ee2ed 100644
> --- a/ndctl/namespace.c
> +++ b/ndctl/namespace.c
> @@ -393,6 +393,8 @@ static int setup_namespace(struct ndctl_region
> *region,
>  			try(ndctl_pfn, set_align, pfn, p->align);
>  		try(ndctl_pfn, set_namespace, pfn, ndns);
>  		rc = ndctl_pfn_enable(pfn);
> +		if (rc)
> +			ndctl_pfn_set_namespace(pfn, NULL);
>  	} else if (p->mode == NDCTL_NS_MODE_DAX) {
>  		struct ndctl_dax *dax = ndctl_region_get_dax_seed(region);
> 
> @@ -402,6 +404,8 @@ static int setup_namespace(struct ndctl_region
> *region,
>  		try(ndctl_dax, set_align, dax, p->align);
>  		try(ndctl_dax, set_namespace, dax, ndns);
>  		rc = ndctl_dax_enable(dax);
> +		if (rc)
> +			ndctl_dax_set_namespace(dax, NULL);
>  	} else if (p->mode == NDCTL_NS_MODE_SAFE) {
>  		struct ndctl_btt *btt = ndctl_region_get_btt_seed(region);
> 
> @@ -783,7 +787,13 @@ static int namespace_create(struct ndctl_region
> *region)
>  		return -ENODEV;
>  	}
> 
> -	return setup_namespace(region, ndns, &p);
> +	rc = setup_namespace(region, ndns, &p);
> +	if (rc) {
> +		ndctl_namespace_set_enforce_mode(ndns,
> NDCTL_NS_MODE_RAW);
> +		ndctl_namespace_delete(ndns);
> +	}
> +
> +	return rc;
>  }
> 
>  static int zero_info_block(struct ndctl_namespace *ndns)
> --
> 1.8.3.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
