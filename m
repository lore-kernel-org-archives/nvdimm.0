Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0222C63C5
	for <nvdimm@lists.linux.dev>; Fri,  9 Dec 2022 17:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670607027; x=1702143027;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+eDfnn6Xmsq/t/YriPqKyeOq86DpZRh5e35y/nIH5Bw=;
  b=ZBRoHtqCmaubZs2xh4T4tk+GRWq87LQ4EW1D8PAcwkuYm/svHI6UojNJ
   WlHVdOZy1QmYF1T8/CMpqmKsfjgtZ/fnfEvl7nz0iy5IiWLEhvRU9gt7m
   LiHU4ciimGQTs9wbvD3vyiWsFqisPTetFFgeEMwJn1FSNdi15TpBsycFX
   OzZEuLulQXe4J2atmHCL7cgFeMUzueHSG+PchF3Fc97gcINY8hW7wPVso
   Lp9ERLvIgTbySMlv4Bzo/2Hbmy+xyOOw9Rgc0UeDC1dzxX/HQy4KTN9BV
   76ypozuAtAK+3ACLavdDf49HlTzGxVocUGtyuhoY5wcnfezHXpnLT1ikS
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10556"; a="379721871"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="379721871"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2022 09:30:25 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10556"; a="678216234"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="678216234"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.212.227.125])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2022 09:30:25 -0800
Date: Fri, 9 Dec 2022 09:30:23 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-cxl@vger.kernel.org, vishal.l.verma@intel.com,
	nvdimm@lists.linux.dev
Subject: Re: [ndctl PATCH v2 12/18] cxl/region: Make granularity an integer
 argument
Message-ID: <Y5Nwr/7rQ5G4r+MV@aschofie-mobl2>
References: <167053487710.582963.17616889985000817682.stgit@dwillia2-xfh.jf.intel.com>
 <167053494873.582963.9998892394422308576.stgit@dwillia2-xfh.jf.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167053494873.582963.9998892394422308576.stgit@dwillia2-xfh.jf.intel.com>

On Thu, Dec 08, 2022 at 01:29:08PM -0800, Dan Williams wrote:
> Since --granularity does not take a unit value like --size, just make it an
> integer argument directly and skip the hand coded conversion.
> 

Reviewed-by: Alison Schofield <alison.schofield@intel.com>

> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  cxl/region.c |   26 +++++++++++---------------
>  1 file changed, 11 insertions(+), 15 deletions(-)
> 
> diff --git a/cxl/region.c b/cxl/region.c
> index 494da5139c05..c6d7d1a973a8 100644
> --- a/cxl/region.c
> +++ b/cxl/region.c
> @@ -21,24 +21,25 @@
>  static struct region_params {
>  	const char *bus;
>  	const char *size;
> -	const char *granularity;
>  	const char *type;
>  	const char *root_decoder;
>  	const char *region;
>  	int ways;
> +	int granularity;
>  	bool memdevs;
>  	bool force;
>  	bool human;
>  	bool debug;
>  } param = {
>  	.ways = INT_MAX,
> +	.granularity = INT_MAX,
>  };
>  
>  struct parsed_params {
>  	u64 size;
>  	u64 ep_min_size;
>  	int ways;
> -	unsigned int granularity;
> +	int granularity;
>  	const char **targets;
>  	int num_targets;
>  	struct cxl_decoder *root_decoder;
> @@ -67,9 +68,8 @@ OPT_STRING('s', "size", &param.size, \
>  	   "total size desired for the resulting region."), \
>  OPT_INTEGER('w', "ways", &param.ways, \
>  	    "number of memdevs participating in the regions interleave set"), \
> -OPT_STRING('g', "granularity", \
> -	   &param.granularity, "interleave granularity", \
> -	   "granularity of the interleave set"), \
> +OPT_INTEGER('g', "granularity", &param.granularity,  \
> +	    "granularity of the interleave set"), \
>  OPT_STRING('t', "type", &param.type, \
>  	   "region type", "region type - 'pmem' or 'ram'"), \
>  OPT_BOOLEAN('m', "memdevs", &param.memdevs, \
> @@ -140,18 +140,15 @@ static int parse_create_options(int argc, const char **argv,
>  		return -EINVAL;
>  	}
>  
> -	if (param.granularity) {
> -		unsigned long granularity = strtoul(param.granularity, NULL, 0);
> -
> -		if (granularity == ULONG_MAX || (int)granularity <= 0) {
> -			log_err(&rl, "Invalid interleave granularity: %s\n",
> +	if (param.granularity < INT_MAX) {
> +		if (param.granularity <= 0) {
> +			log_err(&rl, "Invalid interleave granularity: %d\n",
>  				param.granularity);
>  			return -EINVAL;
>  		}
> -		p->granularity = granularity;
> +		p->granularity = param.granularity;
>  	}
>  
> -
>  	if (argc > p->ways) {
>  		for (i = p->ways; i < argc; i++)
>  			log_err(&rl, "extra argument: %s\n", p->targets[i]);
> @@ -390,12 +387,11 @@ static int cxl_region_determine_granularity(struct cxl_region *region,
>  					    struct parsed_params *p)
>  {
>  	const char *devname = cxl_region_get_devname(region);
> -	unsigned int granularity;
> -	int ways;
> +	int granularity, ways;
>  
>  	/* Default granularity will be the root decoder's granularity */
>  	granularity = cxl_decoder_get_interleave_granularity(p->root_decoder);
> -	if (granularity == 0 || granularity == UINT_MAX) {
> +	if (granularity == 0 || granularity == -1) {
>  		log_err(&rl, "%s: unable to determine root decoder granularity\n",
>  			devname);
>  		return -ENXIO;
> 
