Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8B7177
	for <nvdimm@lists.linux.dev>; Wed, 30 Jun 2021 17:46:20 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10031"; a="188779773"
X-IronPort-AV: E=Sophos;i="5.83,312,1616482800"; 
   d="scan'208";a="188779773"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2021 10:46:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,312,1616482800"; 
   d="scan'208";a="408880104"
Received: from alison-desk.jf.intel.com ([10.54.74.53])
  by orsmga003.jf.intel.com with ESMTP; 30 Jun 2021 10:46:19 -0700
Date: Wed, 30 Jun 2021 10:41:25 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Cc: vishal.l.verma@intel.com, nvdimm@lists.linux.dev, linfeilong@huawei.com,
	lixiaokeng <lixiaokeng@huawei.com>
Subject: Re: [ndctl PATCH 1/2] libndctl: check return value of
 ndctl_pfn_get_namespace
Message-ID: <20210630174125.GA25123@alison-desk.jf.intel.com>
References: <d9881921-aef7-5410-1536-71df81227f4b@huawei.com>
 <b899e8ba-560c-88e6-3b49-2bdf14eab150@huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b899e8ba-560c-88e6-3b49-2bdf14eab150@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)

On Tue, Jun 15, 2021 at 08:38:33PM +0800, Zhiqiang Liu wrote:
> 
> ndctl_pfn_get_namespace() may return NULL, so callers
> should check return value of it. Otherwise, it may
> cause access NULL pointer problem.
> 

Hi Zhiqiang,

I see you mentioned this was found by Coverity in the cover letter.
Please repeat that in the commit log here.

What about the call path:
ndctl_dax_get_namespace() --> ndctl_pfn_get_namespace()

Seems like another place where ndctl_pfn_get_namespace() could
eventually lead to a NULL ptr dereference.

Alison

> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> ---
>  ndctl/namespace.c | 18 ++++++++++++++----
>  test/libndctl.c   |  4 ++--
>  util/json.c       |  2 ++
>  3 files changed, 18 insertions(+), 6 deletions(-)
> 
> diff --git a/ndctl/namespace.c b/ndctl/namespace.c
> index 0c8df9f..21089d7 100644
> --- a/ndctl/namespace.c
> +++ b/ndctl/namespace.c
> @@ -1417,11 +1417,16 @@ static int nstype_clear_badblocks(struct ndctl_namespace *ndns,
> 
>  static int dax_clear_badblocks(struct ndctl_dax *dax)
>  {
> -	struct ndctl_namespace *ndns = ndctl_dax_get_namespace(dax);
> -	const char *devname = ndctl_dax_get_devname(dax);
> +	struct ndctl_namespace *ndns;
> +	const char *devname;
>  	unsigned long long begin, size;
>  	int rc;
> 
> +	ndns = ndctl_dax_get_namespace(dax);
> +	if (!ndns)
> +		return -ENXIO;
> +
> +	devname = ndctl_dax_get_devname(dax);
>  	begin = ndctl_dax_get_resource(dax);
>  	if (begin == ULLONG_MAX)
>  		return -ENXIO;
> @@ -1441,11 +1446,16 @@ static int dax_clear_badblocks(struct ndctl_dax *dax)
> 
>  static int pfn_clear_badblocks(struct ndctl_pfn *pfn)
>  {
> -	struct ndctl_namespace *ndns = ndctl_pfn_get_namespace(pfn);
> -	const char *devname = ndctl_pfn_get_devname(pfn);
> +	struct ndctl_namespace *ndns;
> +	const char *devname;
>  	unsigned long long begin, size;
>  	int rc;
> 
> +	ndns = ndctl_pfn_get_namespace(pfn);
> +	if (!ndns)
> +		return -ENXIO;
> +
> +	devname = ndctl_pfn_get_devname(pfn);
>  	begin = ndctl_pfn_get_resource(pfn);
>  	if (begin == ULLONG_MAX)
>  		return -ENXIO;
> diff --git a/test/libndctl.c b/test/libndctl.c
> index 24d72b3..05e5ff2 100644
> --- a/test/libndctl.c
> +++ b/test/libndctl.c
> @@ -1275,7 +1275,7 @@ static int check_pfn_autodetect(struct ndctl_bus *bus,
>  		if (!ndctl_pfn_is_enabled(pfn))
>  			continue;
>  		pfn_ndns = ndctl_pfn_get_namespace(pfn);
> -		if (strcmp(ndctl_namespace_get_devname(pfn_ndns), devname) != 0)
> +		if (!pfn_ndns || strcmp(ndctl_namespace_get_devname(pfn_ndns), devname) != 0)
>  			continue;
>  		fprintf(stderr, "%s: pfn_ndns: %p ndns: %p\n", __func__,
>  				pfn_ndns, ndns);
> @@ -1372,7 +1372,7 @@ static int check_dax_autodetect(struct ndctl_bus *bus,
>  		if (!ndctl_dax_is_enabled(dax))
>  			continue;
>  		dax_ndns = ndctl_dax_get_namespace(dax);
> -		if (strcmp(ndctl_namespace_get_devname(dax_ndns), devname) != 0)
> +		if (!dax_ndns || strcmp(ndctl_namespace_get_devname(dax_ndns), devname) != 0)
>  			continue;
>  		fprintf(stderr, "%s: dax_ndns: %p ndns: %p\n", __func__,
>  				dax_ndns, ndns);
> diff --git a/util/json.c b/util/json.c
> index ca0167b..249f021 100644
> --- a/util/json.c
> +++ b/util/json.c
> @@ -1002,6 +1002,8 @@ static struct json_object *util_pfn_badblocks_to_json(struct ndctl_pfn *pfn,
>  	pfn_begin = ndctl_pfn_get_resource(pfn);
>  	if (pfn_begin == ULLONG_MAX) {
>  		struct ndctl_namespace *ndns = ndctl_pfn_get_namespace(pfn);
> +		if (!ndns)
> +			return NULL;
> 
>  		return util_namespace_badblocks_to_json(ndns, bb_count, flags);
>  	}
> -- 
> 2.23.0
> 
> 
> 
> 
> .
> 
> 
> 
