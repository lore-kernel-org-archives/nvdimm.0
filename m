Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BC8E220979D2D
 for <linux-nvdimm@lists.01.org>; Tue, 26 Jun 2018 09:19:46 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH] ndctl: Use max_available_extent for creating namespaces
Date: Tue, 26 Jun 2018 16:19:28 +0000
Message-ID: <1530029963.27147.21.camel@intel.com>
References: <20180626153736.6770-1-keith.busch@intel.com>
 <20180626153736.6770-3-keith.busch@intel.com>
In-Reply-To: <20180626153736.6770-3-keith.busch@intel.com>
Content-Language: en-US
Content-ID: <7965E2CB6CF9FB479EAEDBEC76A9A060@intel.com>
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

On Tue, 2018-06-26 at 09:37 -0600, Keith Busch wrote:
> The available_size attribute returns all the unused regions, but a
> namespace has to use contiguous free regions. This patch uses the
> attribute returning the largest capacity that can be created for
> determining if the namespace can be created.
> 
> Signed-off-by: Keith Busch <keith.busch@intel.com>
> ---
>  ndctl/lib/libndctl.c   | 30 ++++++++++++++++++++++++++++++
>  ndctl/lib/libndctl.sym |  1 +
>  ndctl/libndctl.h       |  2 ++
>  ndctl/namespace.c      |  2 +-
>  4 files changed, 34 insertions(+), 1 deletion(-)

Hi Keith,

The patch looks good, but just a couple of 'meta' comments.
1. We typically send ndctl patches separately from kernel patches (i.e. not
thraded together).
2. for ndctl patches, an 'ndctl PATCH' prefix is recommended. You can set a
repo local config parameter for doing this automatically on git format-
patch.
	git config format.subjectprefix "ndctl PATCH"

I'm thinking the kernel changes will be queued for 4.19, which means the
ndctl changes will go into v62.

Thanks,
	-Vishal

> 
> diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
> index 47e005e..a820fb3 100644
> --- a/ndctl/lib/libndctl.c
> +++ b/ndctl/lib/libndctl.c
> @@ -2025,6 +2025,36 @@ NDCTL_EXPORT unsigned long long
> ndctl_region_get_available_size(
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
> +		     "%s/max_available_extent", region->region_path) >=
> len) {
> +		err(ctx, "%s: buffer too small!\n",
> +				ndctl_region_get_devname(region));
> +		return ULLONG_MAX;
> +	}
> +
> +	if (sysfs_read_attr(ctx, path, buf) < 0)
> +		return ULLONG_MAX;
> +
> +	return strtoull(buf, NULL, 0);
> +}
> +
>  NDCTL_EXPORT unsigned int ndctl_region_get_range_index(struct
> ndctl_region *region)
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
>  	ndctl_region_get_type;
>  	ndctl_region_get_namespace_seed;
>  	ndctl_region_get_btt_seed;
> diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
> index be997ac..624115d 100644
> --- a/ndctl/libndctl.h
> +++ b/ndctl/libndctl.h
> @@ -338,6 +338,8 @@ unsigned int ndctl_region_get_interleave_ways(struct
> ndctl_region *region);
>  unsigned int ndctl_region_get_mappings(struct ndctl_region *region);
>  unsigned long long ndctl_region_get_size(struct ndctl_region *region);
>  unsigned long long ndctl_region_get_available_size(struct ndctl_region
> *region);
> +unsigned long long ndctl_region_get_max_available_extent(
> +		struct ndctl_region *region);
>  unsigned int ndctl_region_get_range_index(struct ndctl_region *region);
>  unsigned int ndctl_region_get_type(struct ndctl_region *region);
>  struct ndctl_namespace *ndctl_region_get_namespace_seed(
> diff --git a/ndctl/namespace.c b/ndctl/namespace.c
> index fe86d82..4a562a2 100644
> --- a/ndctl/namespace.c
> +++ b/ndctl/namespace.c
> @@ -764,7 +764,7 @@ static int namespace_create(struct ndctl_region
> *region)
>  		return -EAGAIN;
>  	}
>  
> -	available = ndctl_region_get_available_size(region);
> +	available = ndctl_region_get_max_available_extent(region);
>  	if (!available || p.size > available) {
>  		debug("%s: insufficient capacity size: %llx avail:
> %llx\n",
>  			devname, p.size, available);
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
