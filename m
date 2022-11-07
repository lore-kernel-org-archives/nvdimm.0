Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 922EC15C91
	for <nvdimm@lists.linux.dev>; Mon,  7 Nov 2022 22:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667861008; x=1699397008;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WBr/ODLmak37V+5k5Rj4YdeK0bKNwMyeBo7OieecAJM=;
  b=A0TS+LuHqQsbHKi0AEZjhyQR1n1cDWJftbV9JPLptqhEKmRldXL728NG
   USNPoDisrf24+1AO5soqNGWDieqTd7RVph9R39XwMOpg9EZ3UrvYoeT0d
   23RmXw/4RL0EFRcityOivc0wS/NqlR8YHakwhzzUcR1qqDrjtZ7PJbhaM
   lnvnP7ayuNCf4h6+SUEerpBo/RB9N64cZTV+8yjQkd9rqw3RjPkl2hkR0
   568Rl3ykt02nw/Ge/pH0WsNzlNjjqi3Usj5axCfECEbgXGETObPCHfH0O
   zG3Qf+YBYTv5NWMSw5eD+aDJEnka7WeTGTY8s7Bc0PxRFdLQrA/6yDT0g
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="290263573"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="290263573"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 14:43:27 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="587147375"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="587147375"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.209.100.77])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 14:43:26 -0800
Date: Mon, 7 Nov 2022 14:43:25 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: vishal.l.verma@intel.com, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: [ndctl PATCH 09/15] cxl/region: Make ways an integer argument
Message-ID: <Y2mKDV5MG3OZqwau@aschofie-mobl2>
References: <166777840496.1238089.5601286140872803173.stgit@dwillia2-xfh.jf.intel.com>
 <166777845733.1238089.4849744927692588680.stgit@dwillia2-xfh.jf.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166777845733.1238089.4849744927692588680.stgit@dwillia2-xfh.jf.intel.com>

On Sun, Nov 06, 2022 at 03:47:37PM -0800, Dan Williams wrote:
> Since --ways does not take a unit value like --size, just make it an
> integer argument directly and skip the hand coded conversion.

Just curious why not unsigned int for this and granularity?


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
