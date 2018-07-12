Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E8539209605D9
 for <linux-nvdimm@lists.01.org>; Wed, 11 Jul 2018 17:39:52 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCHv3] ndctl: Use max_available_extent for namespace
Date: Thu, 12 Jul 2018 00:38:16 +0000
Message-ID: <1531355894.7574.56.camel@intel.com>
References: <20180626182629.7333-1-keith.busch@intel.com>
In-Reply-To: <20180626182629.7333-1-keith.busch@intel.com>
Content-Language: en-US
Content-ID: <B363CBB1839AB347B052D789176D96D4@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "Busch, Keith" <keith.busch@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Jiang, Dave" <dave.jiang@intel.com>
Cc: "y-goto@jp.fujitsu.com" <y-goto@jp.fujitsu.com>
List-ID: <linux-nvdimm@lists.01.org>


On Tue, 2018-06-26 at 12:26 -0600, Keith Busch wrote:
> The available_size attribute returns all the unused regions, but a
> namespace has to use contiguous free regions. This patch uses the
> attribute returning the largest capacity that can be created for
> determining if the namespace can be created.
> 
> Signed-off-by: Keith Busch <keith.busch@intel.com>
> ---
> v2 -> v3:
> 
>   Added dbg() message to indicate kernel support
> 
>  ndctl/lib/libndctl.c   | 33 +++++++++++++++++++++++++++++++++
>  ndctl/lib/libndctl.sym |  1 +
>  ndctl/libndctl.h       |  2 ++
>  ndctl/namespace.c      |  2 +-
>  4 files changed, 37 insertions(+), 1 deletion(-)
> 
> diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
> index 47e005e..78c70d6 100644
> --- a/ndctl/lib/libndctl.c
> +++ b/ndctl/lib/libndctl.c
> @@ -2025,6 +2025,39 @@ NDCTL_EXPORT unsigned long long ndctl_region_get_available_size(
>  	return strtoull(buf, NULL, 0);
>  }
>  
> +NDCTL_EXPORT unsigned long long ndctl_region_get_max_available_extent(
> +		struct ndctl_region *region)
> +{
> +	unsigned int nstype = ndctl_region_get_nstype(region);
> +	struct ndctl_ctx *ctx = ndctl_region_get_ctx(region);
> +	char *path = region->region_buf;
> +	int len = region->buf_len;
> +	char buf[SYSFS_ATTR_SIZE];
> +
> +	switch (nstype) {
> +	case ND_DEVICE_NAMESPACE_PMEM:
> +	case ND_DEVICE_NAMESPACE_BLK:
> +		break;
> +	default:
> +		return 0;
> +	}
> +
> +	if (snprintf(path, len,
> +		     "%s/max_available_extent", region->region_path) >= len) {
> +		err(ctx, "%s: buffer too small!\n",
> +				ndctl_region_get_devname(region));
> +		return ULLONG_MAX;
> +	}
> +
> +	/* fall back to legacy behavior if max extents is not exported */
> +	if (sysfs_read_attr(ctx, path, buf) < 0) {
> +		dbg(ctx, "max extents attribute not exported on older kernels\n");
> +		return ndctl_region_get_available_size(region);
> +	}
> +
> +	return strtoull(buf, NULL, 0);
> +}
> +
>  NDCTL_EXPORT unsigned int ndctl_region_get_range_index(struct ndctl_region *region)
>  {
>  	return region->range_index;
> diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
> index c1228e5..22fd026 100644
> --- a/ndctl/lib/libndctl.sym
> +++ b/ndctl/lib/libndctl.sym
> @@ -123,6 +123,7 @@ global:
>  	ndctl_region_get_mappings;
>  	ndctl_region_get_size;
>  	ndctl_region_get_available_size;
> +	ndctl_region_get_max_available_extent;

The patch looks good - only one thing: The new symbol in the version
script needs to go in a new section. If you pull the latest
github/pending branch, I've created a new section LIBNDCTL_17 at the
bottom for a symbol I added. This should go in the same.

>  	ndctl_region_get_type;
>  	ndctl_region_get_namespace_seed;
>  	ndctl_region_get_btt_seed;
> diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
> index be997ac..624115d 100644
> --- a/ndctl/libndctl.h
> +++ b/ndctl/libndctl.h
> @@ -338,6 +338,8 @@ unsigned int ndctl_region_get_interleave_ways(struct ndctl_region *region);
>  unsigned int ndctl_region_get_mappings(struct ndctl_region *region);
>  unsigned long long ndctl_region_get_size(struct ndctl_region *region);
>  unsigned long long ndctl_region_get_available_size(struct ndctl_region *region);
> +unsigned long long ndctl_region_get_max_available_extent(
> +		struct ndctl_region *region);
>  unsigned int ndctl_region_get_range_index(struct ndctl_region *region);
>  unsigned int ndctl_region_get_type(struct ndctl_region *region);
>  struct ndctl_namespace *ndctl_region_get_namespace_seed(
> diff --git a/ndctl/namespace.c b/ndctl/namespace.c
> index fe86d82..4a562a2 100644
> --- a/ndctl/namespace.c
> +++ b/ndctl/namespace.c
> @@ -764,7 +764,7 @@ static int namespace_create(struct ndctl_region *region)
>  		return -EAGAIN;
>  	}
>  
> -	available = ndctl_region_get_available_size(region);
> +	available = ndctl_region_get_max_available_extent(region);
>  	if (!available || p.size > available) {
>  		debug("%s: insufficient capacity size: %llx avail: %llx\n",
>  			devname, p.size, available);
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
