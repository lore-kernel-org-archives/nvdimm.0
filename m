Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32EE37F
	for <nvdimm@lists.linux.dev>; Wed,  8 Feb 2023 03:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675828612; x=1707364612;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=kqWfNoXHh2Vljcznmeh/e1jMABFcxaaZixBPOFy8uAw=;
  b=AnQj8dtlxG53Hx2PpAU/O8rUV0vUejCF2VjqQpe86hasSKc5g82jZPGi
   3G2dFNSgS3/d7OdnnNEadL/MM2NQC0GGr0y+EI+ubU+D9RDBCL4a76Gcz
   bVch+wHX1Wljw3otib//VCh9FHyt75BMN71k+YGqEoNMiOLcnrh6cEIRY
   VMaw4PjT9ZVqc5WIzkK1q+6CYgUcfd8NSuEx5OhPRlQpOVPMeqw/9Hgec
   V5WFGsz7HYZTWlZtyrOJu4XGKs8kWGnZgdlNA7ANOrnpm9I9+eyMRCknR
   gv2tHN/W6wwRCNAVQPo7Yt8gOukA2R2Ad3Oekuu8Wo9KYxsue3t8Ufjr0
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="330995621"
X-IronPort-AV: E=Sophos;i="5.97,279,1669104000"; 
   d="scan'208";a="330995621"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 19:56:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="791047696"
X-IronPort-AV: E=Sophos;i="5.97,279,1669104000"; 
   d="scan'208";a="791047696"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga004.jf.intel.com with ESMTP; 07 Feb 2023 19:56:51 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Feb 2023 19:56:51 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 7 Feb 2023 19:56:51 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 7 Feb 2023 19:56:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bP7MtvaLAyU0fhZLFwLIzhOvkQQeKKmrCboCvL3UKH5s8xP18sAXCnIbylwW3dase5HOsZwatItCoQSQPbirWu/OPHjPzvTidyHCRNOop1AaPJSfQXo6WQl8mRk3pNxVtvYL0dpOhmKlOCmPCmPBPEXQm6fBatDF6vs2LcYb7pbuH03tqXLvI+WvxscFaoD+2gXZ3cjxOgwrAtPvvtw4XkfB9u+Powo3EqDqmCB+BsCSaJVDKjM+2woH3rkuYSLfVXe21L7Z963DxjGoHvlIxEcgWlJXVW9J/hks58Z+zaF3vqqzm6ZGQNrO2/jqwRl+cxWCaFsXPc7TOPq6OUvTRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LQn+gvPdyTKgwaotrtnbESzk9mQHeHse0/AsCaEqaBk=;
 b=eebiS/GgWvLbU71BO+Ecq/DFe5r+b9isXFdtHOgHbrKMGzRzyzmAEj1hMqP1KKRFvhcig+hizbENavmZmSubuA1hYnYg1/dTkPeH8SOMmTsbFH9xY47TjyMoi0DPiJwCRkotwxCm+U3wgZ04vhIpCWK4aTlyP/btKEGkHuSRt+Hmy5oqMJQ5+0+Gf7V2MvT1WNE2bsODWNLT4gWTA1po6YpPhS2MYwZgv6VsdmUARB5Z/DUNx9Fw8SnII9sIvhQB8YdgqX0NUyjjq5fCW8NM3LyySQj0b7h/6F98xTYvVqRrApReph3cEBkjka+YWByD8uiRpP1H19mPack7CrUAxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by DS7PR11MB7949.namprd11.prod.outlook.com (2603:10b6:8:eb::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.36; Wed, 8 Feb
 2023 03:56:49 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::6851:3db2:1166:dda6]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::6851:3db2:1166:dda6%9]) with mapi id 15.20.6064.034; Wed, 8 Feb 2023
 03:56:49 +0000
Date: Tue, 7 Feb 2023 19:56:45 -0800
From: Ira Weiny <ira.weiny@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>
CC: Gregory Price <gregory.price@memverge.com>, Jonathan Cameron
	<Jonathan.Cameron@huawei.com>, Davidlohr Bueso <dave@stgolabs.net>, "Dan
 Williams" <dan.j.williams@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH ndctl 4/7] cxl/region: accept user-supplied UUIDs for
 pmem regions
Message-ID: <63e31d7d6ca6b_107e3f29448@iweiny-mobl.notmuch>
References: <20230120-vv-volatile-regions-v1-0-b42b21ee8d0b@intel.com>
 <20230120-vv-volatile-regions-v1-4-b42b21ee8d0b@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230120-vv-volatile-regions-v1-4-b42b21ee8d0b@intel.com>
X-ClientProxiedBy: BYAPR06CA0024.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::37) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|DS7PR11MB7949:EE_
X-MS-Office365-Filtering-Correlation-Id: 98e4a4e7-09f7-49e7-8944-08db09888128
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QzG6V5H3KX9rwkzLpcDuy1k5hBXqPzrZsYC1nCJXJnkxswZu7UxprkjhIiVRnUuSWv5vaviDkALKg9I7aKqvn6lvFVoK9VyA70H/KynDecmV/c0EUGTV6/EjjMoW3WWcbFOdVpjAiR4wVFi8cklSJq+4JOqD+Y7Qmr+z5igUCAVuyOqzb0bOkPc104+LY08jZ6Yjv3oSCY/xxZuLtu5FjOGfCUaa8uSAPZ/sRDfqoKtroKqe+3wOvt0uOG5O+C7s10jimwwjbCldwVZYSODZ1qRXEbh2mkKHcJXZvAJ7yKpo1gzIm5RdPA9m6UnMIAaJs4Fl9ngd554pMINcVeAyeIkmmwFPkjTXjTq+1dMykOSWhCLpIjpkN1BlgSuKHqbpofg7A1Bqf5qbRlUcyXeGCUlHgCPynzllnIQQdZ7XvbhZe9N6BKon5Me+vxiYQsHnmky3oVt7LqdRPh5uhnpNBoiYRmD4dWCZh7JzBAlNvHBdKysch6beg0zAR4ggknFnrzeY0DgX0Y8tuDqICPdA5Tbfuk/4lzCGYgnxhdLErtsLTzrMh7rDczMmyQyYCv1ZLoGDDfv6dogNjlOBgD8LdXS9+/vR2aLqamzLkIS5ZT+F/JEKzwwv/cIk57natLLgKLYEW5g717VxH8doM+749g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(376002)(346002)(366004)(39860400002)(136003)(451199018)(316002)(54906003)(83380400001)(86362001)(38100700002)(82960400001)(26005)(186003)(6512007)(6506007)(9686003)(6486002)(6666004)(478600001)(41300700001)(5660300002)(44832011)(8936002)(2906002)(8676002)(66476007)(4326008)(66946007)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DdSEl+DBLjuzwdCdvSv4KJ6Mn9oYfQy0i/k1gnjhGoK195eqUSb1y6BMLJmL?=
 =?us-ascii?Q?9V/XU+qnWslNSn4xD22Q/C2JvLjr3xkGycT0iC1UajGpFdDWqLEL5vWjqEyS?=
 =?us-ascii?Q?PgucVCUfmOxx+1oP4PUiseFfUX4vKKgbmkJxvaNJ0v0wDy/hRc0k+l0mS3C4?=
 =?us-ascii?Q?c1ytnJ5XzGLWLBPOPN6gWbsc79tv8Y9lieanBNPdGKCjy4uKVXyzTfB26G8w?=
 =?us-ascii?Q?dJOYlQNGXOwZlGXxjgbSWCXUh7NTqnY5eLZCur+srYspmXV39ZFFEXHsRB5r?=
 =?us-ascii?Q?inZmeCOFbWA7VrTlij+06LT55hZFLFkm6QU6cMMUBiDr81sjvWhBmYcbY560?=
 =?us-ascii?Q?x1lD3JGjLJEnr97sUmyp3zL5wGEJuOD8vt8izCl2sJcU1qwyuIPnmomXB8jN?=
 =?us-ascii?Q?AqdwM9sHHhQ1bHmT6Q4PKVCj3qanoC4bC5B2Xdo4yLy4c46/dzqHGLU5IqnQ?=
 =?us-ascii?Q?nyBOJLATHDGyYiFb8s2MvhlINISr2nRVQeA7/lmRa6M9Rb1MDq4G/RDFBUXR?=
 =?us-ascii?Q?LHiHGOvEGLB5jhqpbgMXoG/iNssQ+780/SwxjvXJ8gPOvn8h/iQXbhilYOyT?=
 =?us-ascii?Q?Nja+1rT1XZWTPW5lWNEq5NqZMuL1vAjOrYkfJBGai405yDgvowGZCDY/N7KY?=
 =?us-ascii?Q?YmEtcXwf0/a/Rk1ikLCYQeEXQCMlyU9Luq2TSObrzlhrowMMYFV4nLIfJ0xK?=
 =?us-ascii?Q?hPqqKrwMuNMtJVMj12/oefun1RkbKPMuZ1uEm3WFb1dnFWXHxG6mj6mjrxTy?=
 =?us-ascii?Q?wLJekxdoOxeY9E6aKJpWOywTbUPJZiurYp1tgbMbxvhom3NIUqWTgOsJryRC?=
 =?us-ascii?Q?cqBfBZNTVW+6pI8rjcj011P0sOj317G7TjCMxGOub6e9vt6ippP+EANAGmh2?=
 =?us-ascii?Q?hVzhiCuDY1M1RfjBfDbmiot2v5P5hkXgfpllHRZx9vGQ/4/rzWkywXdKY1KD?=
 =?us-ascii?Q?E+vV0HtoqGmhaTLYNLVGF9jXVexAhtnokM5hiDkaIZaQPRwuJ3xfUCFPz3My?=
 =?us-ascii?Q?XQfE+nlcJS/f2LjR2iesaBItwWfYBnRPLfpmI5C3pNbmV/t3kAscdb7qIBed?=
 =?us-ascii?Q?oxLknU8An291gmC8PQwUcOE57xZfeKc4Br3qkaS2bDRaLVnO+kU01e0o01bj?=
 =?us-ascii?Q?MZr4oHu2hwQ4ccFUpwteOUU9d+11lBl2YRZcEY4o9cRyrv/Z7BjlznyhAqqn?=
 =?us-ascii?Q?FBEAB8yrzL5iqDCrYD6PQyJyrJujdtF1FswsI8gkMvIYTNiuA1BIU1c4fQgl?=
 =?us-ascii?Q?JAOip/m+qrSBk3VDBsWbwWpZK0/zWdGQGzNlJyux6LAhBMqcmvtPFuSQpmVC?=
 =?us-ascii?Q?LdrTW+kZziWREYSZ1m4nH+lKOzC0ipj28cTu4Xf+VdgKUiO2vazikznA+Nlr?=
 =?us-ascii?Q?WjNx86+C5YV1uz815E7OPbeZqtqTa9X3LRaV+yM9fIApsbdfKwLCD22Sgp+H?=
 =?us-ascii?Q?GP/xe0IOmkrlya45Oo31D7+E7kc0JNmZ4B6NVBzy7lWj7/045KMx3cwVjKAy?=
 =?us-ascii?Q?o7P1tK76VrNqxQ9IGPil4Cw9wPTy01nX6aO9GdMj2JBm/9748In9WShVuwiK?=
 =?us-ascii?Q?5s9ttaxAJRanMXw/+dMYFevaYZPh/63dyMUx8H11?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 98e4a4e7-09f7-49e7-8944-08db09888128
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 03:56:49.2676
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z3UVbS596HaVRov9bmz0/HhNoD+T1DkAca847Snrrm5do8Q7tNjt8m0qXIOSSpBtdvmMjLwsfz1BsMaEb3lfDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7949
X-OriginatorOrg: intel.com

Vishal Verma wrote:
> Attempting to add additional checking around user-supplied UUIDs against
> 'ram' type regions revealed that commit 21b089025178 ("cxl: add a 'create-region' command")
> completely neglected to add the requisite support for accepting
> user-supplied UUIDs, even though the man page for cxl-create-region
> advertised the option.
> 
> Fix this by actually adding this option now, and add checks to validate
> the user-supplied UUID, and refuse it for ram regions.
> 
> Cc: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  cxl/region.c | 22 +++++++++++++++++++---
>  1 file changed, 19 insertions(+), 3 deletions(-)
> 
> diff --git a/cxl/region.c b/cxl/region.c
> index 0945a14..9079b2d 100644
> --- a/cxl/region.c
> +++ b/cxl/region.c
> @@ -22,6 +22,7 @@ static struct region_params {
>  	const char *bus;
>  	const char *size;
>  	const char *type;
> +	const char *uuid;
>  	const char *root_decoder;
>  	const char *region;
>  	int ways;
> @@ -40,6 +41,7 @@ struct parsed_params {
>  	u64 ep_min_size;
>  	int ways;
>  	int granularity;
> +	uuid_t uuid;
>  	struct json_object *memdevs;
>  	int num_memdevs;
>  	int argc;
> @@ -74,6 +76,8 @@ OPT_INTEGER('g', "granularity", &param.granularity,  \
>  	    "granularity of the interleave set"), \
>  OPT_STRING('t', "type", &param.type, \
>  	   "region type", "region type - 'pmem' or 'ram'"), \
> +OPT_STRING('U', "uuid", &param.uuid, \
> +	   "region uuid", "uuid for the new region (default: autogenerate)"), \
>  OPT_BOOLEAN('m', "memdevs", &param.memdevs, \
>  	    "non-option arguments are memdevs"), \
>  OPT_BOOLEAN('u', "human", &param.human, "use human friendly number formats")
> @@ -293,6 +297,11 @@ static int parse_create_options(struct cxl_ctx *ctx, int count,
>  
>  	if (param.type) {
>  		p->mode = cxl_decoder_mode_from_ident(param.type);
> +		if (p->mode == CXL_DECODER_MODE_RAM && param.uuid) {
> +			log_err(&rl,
> +				"can't set UUID for ram / volatile regions");
> +			return -EINVAL;
> +		}
>  		if (p->mode == CXL_DECODER_MODE_NONE) {
>  			log_err(&rl, "unsupported type: %s\n", param.type);
>  			return -EINVAL;
> @@ -341,6 +350,13 @@ static int parse_create_options(struct cxl_ctx *ctx, int count,
>  		}
>  	}
>  
> +	if (param.uuid) {
> +		if (uuid_parse(param.uuid, p->uuid)) {
> +			error("failed to parse uuid: '%s'\n", param.uuid);
> +			return -EINVAL;
> +		}
> +	}
> +
>  	return 0;
>  }
>  
> @@ -566,7 +582,6 @@ static int create_region(struct cxl_ctx *ctx, int *count,
>  	int i, rc, granularity;
>  	u64 size, max_extent;
>  	const char *devname;
> -	uuid_t uuid;
>  
>  	rc = create_region_validate_config(ctx, p);
>  	if (rc)
> @@ -627,8 +642,9 @@ static int create_region(struct cxl_ctx *ctx, int *count,
>  	try(cxl_region, set_interleave_granularity, region, granularity);
>  	try(cxl_region, set_interleave_ways, region, p->ways);
>  	if (p->mode == CXL_DECODER_MODE_PMEM) {
> -		uuid_generate(uuid);
> -		try(cxl_region, set_uuid, region, uuid);
> +		if (!param.uuid)
> +			uuid_generate(p->uuid);
> +		try(cxl_region, set_uuid, region, p->uuid);
>  	}
>  	try(cxl_region, set_size, region, size);
>  
> 
> -- 
> 2.39.1
> 
> 


