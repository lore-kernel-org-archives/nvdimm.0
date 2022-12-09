Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA8A63C5
	for <nvdimm@lists.linux.dev>; Fri,  9 Dec 2022 17:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670606961; x=1702142961;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SUseUFeN9BhTkTvhVphAr79L73HXlp9yYIv3HRmg3Q4=;
  b=g+KUndlWdhA9Tc73gUQR+CjNbmhnOJVXiPkxSpGXOVkg0o07JGFXQ1hZ
   tnotX3rVgOBG8G3vsuWOxySD9v4bU9gvCl0Rui0q3FE4pHw0v9T1gZ/R0
   IhFPFANa6qzUnHitsnd1dEvzz2ZUpjkZ37yn10PBC6Rkiew1k7QWPoAof
   KCl4wITjGxGeaOWwKG2phVCnecn/+t3W/xbmkoQwro45TzhVS5EFwf5LA
   zx5WmYmLCbpeBLjNre3f8CgE+MQ2VMI+cO2BhDh2eSqvFLtwzwMTMeX91
   W+2TcZVLrBMcXVBax3kt+A/5/Qdf8QvF3z/0SdWmDScz/8c61bSCSgWzC
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10556"; a="318660460"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="318660460"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2022 09:29:21 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10556"; a="647464152"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="647464152"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.212.227.125])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2022 09:29:21 -0800
Date: Fri, 9 Dec 2022 09:29:19 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-cxl@vger.kernel.org, vishal.l.verma@intel.com,
	nvdimm@lists.linux.dev
Subject: Re: [ndctl PATCH v2 11/18] cxl/region: Make ways an integer argument
Message-ID: <Y5Nwb3LruJIcfIxy@aschofie-mobl2>
References: <167053487710.582963.17616889985000817682.stgit@dwillia2-xfh.jf.intel.com>
 <167053494297.582963.8195034137436682440.stgit@dwillia2-xfh.jf.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167053494297.582963.8195034137436682440.stgit@dwillia2-xfh.jf.intel.com>

On Thu, Dec 08, 2022 at 01:29:03PM -0800, Dan Williams wrote:
> Since --ways does not take a unit value like --size, just make it an
> integer argument directly and skip the hand coded conversion.

Reviewed-by: Alison Schofield <alison.schofield@intel.com>
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  cxl/region.c |   41 +++++++++++++++++++----------------------
>  1 file changed, 19 insertions(+), 22 deletions(-)
> 
> diff --git a/cxl/region.c b/cxl/region.c
> index 334fcc291de7..494da5139c05 100644
> --- a/cxl/region.c
> +++ b/cxl/region.c
> @@ -21,21 +21,23 @@
>  static struct region_params {
>  	const char *bus;
>  	const char *size;
> -	const char *ways;
>  	const char *granularity;
>  	const char *type;
>  	const char *root_decoder;
>  	const char *region;
> +	int ways;
>  	bool memdevs;
>  	bool force;
>  	bool human;
>  	bool debug;
> -} param;
> +} param = {
> +	.ways = INT_MAX,
> +};
>  
>  struct parsed_params {
>  	u64 size;
>  	u64 ep_min_size;
> -	unsigned int ways;
> +	int ways;
>  	unsigned int granularity;
>  	const char **targets;
>  	int num_targets;
> @@ -63,9 +65,8 @@ OPT_BOOLEAN(0, "debug", &param.debug, "turn on debug")
>  OPT_STRING('s', "size", &param.size, \
>  	   "size in bytes or with a K/M/G etc. suffix", \
>  	   "total size desired for the resulting region."), \
> -OPT_STRING('w', "ways", &param.ways, \
> -	   "number of interleave ways", \
> -	   "number of memdevs participating in the regions interleave set"), \
> +OPT_INTEGER('w', "ways", &param.ways, \
> +	    "number of memdevs participating in the regions interleave set"), \
>  OPT_STRING('g', "granularity", \
>  	   &param.granularity, "interleave granularity", \
>  	   "granularity of the interleave set"), \
> @@ -126,15 +127,11 @@ static int parse_create_options(int argc, const char **argv,
>  		}
>  	}
>  
> -	if (param.ways) {
> -		unsigned long ways = strtoul(param.ways, NULL, 0);
> -
> -		if (ways == ULONG_MAX || (int)ways <= 0) {
> -			log_err(&rl, "Invalid interleave ways: %s\n",
> -				param.ways);
> -			return -EINVAL;
> -		}
> -		p->ways = ways;
> +	if (param.ways <= 0) {
> +		log_err(&rl, "Invalid interleave ways: %d\n", param.ways);
> +		return -EINVAL;
> +	} else if (param.ways < INT_MAX) {
> +		p->ways = param.ways;
>  	} else if (argc) {
>  		p->ways = argc;
>  	} else {
> @@ -155,13 +152,13 @@ static int parse_create_options(int argc, const char **argv,
>  	}
>  
>  
> -	if (argc > (int)p->ways) {
> +	if (argc > p->ways) {
>  		for (i = p->ways; i < argc; i++)
>  			log_err(&rl, "extra argument: %s\n", p->targets[i]);
>  		return -EINVAL;
>  	}
>  
> -	if (argc < (int)p->ways) {
> +	if (argc < p->ways) {
>  		log_err(&rl,
>  			"too few target arguments (%d) for interleave ways (%u)\n",
>  			argc, p->ways);
> @@ -253,7 +250,7 @@ static bool validate_memdev(struct cxl_memdev *memdev, const char *target,
>  
>  static int validate_config_memdevs(struct cxl_ctx *ctx, struct parsed_params *p)
>  {
> -	unsigned int i, matched = 0;
> +	int i, matched = 0;
>  
>  	for (i = 0; i < p->ways; i++) {
>  		struct cxl_memdev *memdev;
> @@ -393,7 +390,8 @@ static int cxl_region_determine_granularity(struct cxl_region *region,
>  					    struct parsed_params *p)
>  {
>  	const char *devname = cxl_region_get_devname(region);
> -	unsigned int granularity, ways;
> +	unsigned int granularity;
> +	int ways;
>  
>  	/* Default granularity will be the root decoder's granularity */
>  	granularity = cxl_decoder_get_interleave_granularity(p->root_decoder);
> @@ -408,7 +406,7 @@ static int cxl_region_determine_granularity(struct cxl_region *region,
>  		return granularity;
>  
>  	ways = cxl_decoder_get_interleave_ways(p->root_decoder);
> -	if (ways == 0 || ways == UINT_MAX) {
> +	if (ways == 0 || ways == -1) {
>  		log_err(&rl, "%s: unable to determine root decoder ways\n",
>  			devname);
>  		return -ENXIO;
> @@ -436,12 +434,11 @@ static int create_region(struct cxl_ctx *ctx, int *count,
>  {
>  	unsigned long flags = UTIL_JSON_TARGETS;
>  	struct json_object *jregion;
> -	unsigned int i, granularity;
>  	struct cxl_region *region;
> +	int i, rc, granularity;
>  	u64 size, max_extent;
>  	const char *devname;
>  	uuid_t uuid;
> -	int rc;
>  
>  	rc = create_region_validate_config(ctx, p);
>  	if (rc)
> 
