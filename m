Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D4A6D1B
	for <nvdimm@lists.linux.dev>; Thu,  9 Feb 2023 16:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675959874; x=1707495874;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=AfetUG7DeBy5MRGaqeqFqIJBhCnJquuzYyHx+GxnBMc=;
  b=ku5dxynQwzs5Shi1XWePQC+MBo6nZWzH5+W8Djph5Q6vGvAD4FTkvhBx
   RaEgdA8N8LV/Qi8xBsW7fqYV+PDs0fp8XAZD6+XNqzdM0grSoCCTyJhhY
   bbGs/TnMtU7hhyOOzihxhQozDojHyE6RMSdP1altebk87TEQbemgiH+kT
   wIJA9VoMjuHERkMxuNVje30Nx2TIXWs15KKTb623eBfEpQHyR92tm8w2K
   yZAj2fRnGLDXlqEjdgTKDnSU23c1TEwD/cH0fJ3AN3q1dfHrGs3u93OMn
   m2QtB8kgjgx2resFvTbLBiMMPW+3gU6Rd7g1JDB6Dn5YUldHnk+mVZ3TY
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="318173078"
X-IronPort-AV: E=Sophos;i="5.97,284,1669104000"; 
   d="scan'208";a="318173078"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2023 08:24:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="776539379"
X-IronPort-AV: E=Sophos;i="5.97,284,1669104000"; 
   d="scan'208";a="776539379"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga002.fm.intel.com with ESMTP; 09 Feb 2023 08:24:32 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 9 Feb 2023 08:24:31 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 9 Feb 2023 08:24:30 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 9 Feb 2023 08:24:30 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 9 Feb 2023 08:24:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aYSG/4Ht3kw5WOuShCt4RlWV/h8w0zJAmnZQyL7ndcdGjXHyALhholiOVwOVrJDLUBqirzo0sKe0tjeX70MM9rFNhDHN4jra8AHF64hF6NxGrYm6r8j/u3qombAnsH5+wPyzIOHRMmkC5hFNnNyumJzCeWbf//gH/Z29qXRyG/h5Y3bmz3EEu+Id+EGy3sQu+3r8JH5ioVVTDC+m6HBCcbv8jhkcW7hIOwV1D2fnTRU4JeNP7YdgNfblD3UdHqJqvzYDBDzqO3iCabBBeTQpMTzbqwPz7NZFQIdw3yqIwTDm8F52LynSZMh4arpaVzib7l00XJ7r5mp9LfzogT8fdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Wq5DGoR3JLi7//D/Ruw3Q18HChgE1g17WLJmvJanGs=;
 b=I1Zr7Uz+Kpo7ZMqhilO4RR+8qLvWNGipYA7q97T6oCT7Rm6tfSBOo6JAph+CZBbJPCzscVV8rqVr5X4uoM7wepzvIM+CylNlTVdL2CIN+0pkZ1ZDV/Kn2o7IhUhgo0fvFlv+k0cVhRakz8R6dCGdL03nS+i1EiMqbUrmWRooQm+U8qvCLMIfR8v6e89ezyHLg1bAclROZgJdDmhz6/1NJxsP89ycFz5IvQ67yGUWOfzDDR96uQ/lYXzDJVc5bfgBbDnrGLtq4tkvsSZhGviu1G/4x7yDX3JhZFY3xesjQRVszUZbSMOcdjGtQP1YlH28m/+U4kAhXHedLvgXZvKoow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by PH8PR11MB6707.namprd11.prod.outlook.com (2603:10b6:510:1c6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Thu, 9 Feb
 2023 16:24:28 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::6851:3db2:1166:dda6]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::6851:3db2:1166:dda6%9]) with mapi id 15.20.6086.019; Thu, 9 Feb 2023
 16:24:28 +0000
Date: Thu, 9 Feb 2023 08:24:23 -0800
From: Ira Weiny <ira.weiny@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>
CC: Gregory Price <gregory.price@memverge.com>, Jonathan Cameron
	<Jonathan.Cameron@huawei.com>, Davidlohr Bueso <dave@stgolabs.net>, "Dan
 Williams" <dan.j.williams@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH ndctl v2 3/7] cxl: add core plumbing for creation of ram
 regions
Message-ID: <63e51e37c3de2_12f1bb29470@iweiny-mobl.notmuch>
References: <20230120-vv-volatile-regions-v2-0-4ea6253000e5@intel.com>
 <20230120-vv-volatile-regions-v2-3-4ea6253000e5@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230120-vv-volatile-regions-v2-3-4ea6253000e5@intel.com>
X-ClientProxiedBy: CY5PR19CA0049.namprd19.prod.outlook.com
 (2603:10b6:930:1a::7) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|PH8PR11MB6707:EE_
X-MS-Office365-Filtering-Correlation-Id: 74cef95e-9f17-427c-a743-08db0aba1d74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gfD1ZSfggD+6/bazCwrp2j8Cqq0/zeW7Cv4fhssCmFcZWmilCBNRjYxWwVaHGeYZT1S9/DjpW2ME/Fl/ipzujeum6G7pcvMPr8uo2XtRUF18lm8Z+tTdriFvBbP3wrTKuVnJDDtlLivPPsZjeNscJVj9SZZ2AhHdoCm9vi+L3SXMUYaMItOLsn961tmPNf/sYnaKUaKkP9ajuQSkMvL0RSUqyyZxGhCKxcnSVNYzoYTiRslZYNkrvLNgOejkd1n5xm4BI4y8m0vvNHmx08f2+6qTdLGSUkUvuz6E5ttwTiH4jd90meZUsQALTj5YFvt2Tj1bVkkz4JFEQlr25cCU8q6SX/GjiSS7Iqi6yLoDA/SBhesMWWJqFk1A2ls+qCuJE5SOLSFjirJsFdHgGqb09hJ9GVxy7HyVvTE2jKRSDTqzED9FaJlSivHujme2M0lMg3LKWYuHKFmSShSfhSNdZnJJ1ktwEWyAIu3XXGgqk8/iklM5zUz7UA4nDbcvdVVBMYUC0uenH/PT8b6BIIk1El4pJeEUa2AUF8VyoZ03o3UI9f6ejPAYaunZTPqeHA15Tch5lTkfh125OxQnIy5F5I5ajgTWcCmRR3MEgdzSJlQoPHjV/Q0EFSAJuv6+8vpgxD6/6RCe7xUCkUKsjieRAg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(39860400002)(396003)(346002)(366004)(451199018)(86362001)(5660300002)(2906002)(38100700002)(8936002)(41300700001)(82960400001)(44832011)(6666004)(66946007)(4326008)(66476007)(8676002)(83380400001)(66556008)(316002)(54906003)(6486002)(9686003)(6506007)(26005)(186003)(6512007)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4+QJMNopz1DNuD2LMP4mVqLpr4HpBopCw7nR61qBT0mxCe56sMzdVmI6QA4V?=
 =?us-ascii?Q?6HqLzHlqsLamG/zlCtvDy9kYSgmJCZOxAPKbJ57A4SyWQg6NBpUGKjkb2EL7?=
 =?us-ascii?Q?yKQ6tcC7JgauPwg6BNzRMnO5R48trTUBT5UFMqeqh8mrobjOwb4tlfNbaEpE?=
 =?us-ascii?Q?EBx9mrIMZXMETjvQHL27CAZDyLtHF7Y6EH/EklH4+JKjZKFK4OSqvYK88e0I?=
 =?us-ascii?Q?uewNBv0/Jv8ctU6C8cMFSUTmDXkqmPL1czo6UzTPzhTJo2deIUiYGJK/7aT4?=
 =?us-ascii?Q?Kb9laYSGLVi/IxeADvARelCNtqCRW1wiR10snCa/rbmC/4WmiV6q4/ljWhWC?=
 =?us-ascii?Q?fHTe5/GWOgkHRF/JvZfEAjcRbqb0Ou27AdVbPupp5WdL6wNmrcdavHx9GwgC?=
 =?us-ascii?Q?/GJoDurq1Zs3h1ovrLCQVdTkqrgJNJH8A4STuJAXfFb1UR9LjCz867l0aajk?=
 =?us-ascii?Q?+7daQ9k6YFhxthSckYqrJyrzXfyVc/H4Rbz5Ig9vRAz5f4zZch7eJ4mlKgFV?=
 =?us-ascii?Q?u5FNxtfpkZxA3p92XCW6R4C2iWwE78mJGPD6mK1oNMi/HIPFT5XvUTnro2Ol?=
 =?us-ascii?Q?bwOLbWukI0/28zt+Tp/Btd8koohmHMIhTyCZIsTCxIQW0eyCB8sizyvuLXqO?=
 =?us-ascii?Q?c7xVr6TUZnvpJbuRp00rv2BZ604j9c8lBYLPGXIkwerA2874KEivq8THOweX?=
 =?us-ascii?Q?Mf9LjZh/Pt4oqofE0r3KCC9YKX5MaFmPptcsAxatI9p1zXco1XmnbNhBFLYf?=
 =?us-ascii?Q?R2Y1J04/OcmtSWtNVwfGj4cKb+8Kph7bAZJc2HjIi0cclLXBJCT97CWXGdpC?=
 =?us-ascii?Q?vhtN68v0tyuFXOInoLp/ia3GNsS2CQxWICq9A6Tu0JxrexyVZwKhO1RKsTU3?=
 =?us-ascii?Q?oVoCXEqd3k0XXMrX3joEMn08KlX2F6CXSvRHsur+xAmfzEeJB29+vSjTwuUa?=
 =?us-ascii?Q?fhMVhFxnkdHerMpHbv03/N+xA1lRBRSI7b60ZPSJTwfnRDIuGUirIxS5Wwtm?=
 =?us-ascii?Q?FspfNv8KZUUubu6LeO7Hi53SvxdTJd4Rpa+B5H+eGV+6zCyezB97uiQfIEaU?=
 =?us-ascii?Q?SIuJH1z0oJkKZ3EsjrNoIjx+GECTgerKDuemNukP0LUL3m6x2Gh60EV7qSSk?=
 =?us-ascii?Q?Sy6wOQmuakT/oYv6YilzCXeBApVi+JvXa5U307LWY93eeJGm5dYaeWrnIuUl?=
 =?us-ascii?Q?v2NZw1TFgDA5uE+8UCnPXIUyDlJFJe06Fvf4OtNLZH4xqw12pwMvXbHdLPtp?=
 =?us-ascii?Q?blERE9COtOiSZIqWiZwNO+JguoJwfmeJwaDByiLSpPo7UJHoa0WIsRG2XDsv?=
 =?us-ascii?Q?F782a7557lsYi9gu+QzRrOVuwE3hpW3gjBQMaqZWHQhAQYjk9U+V9u347Cyt?=
 =?us-ascii?Q?yOs66PUCxgqngSfkGOQdPFOcKqlAPHabWtzIu3DMVxsm/T2EBUxCAIc/1JaM?=
 =?us-ascii?Q?cok1HYdhCRVd50OZQqpiVdIncQSYPg/LpGxgTyoWDErfxNIAQR7vMk3Izy2K?=
 =?us-ascii?Q?Oe7BLuJ3+SooLsnchoV8/ugHdUfMZx4pjtkcpBiqQH2GawZGVy6kmZlrgv8n?=
 =?us-ascii?Q?5+ho7knsCMitTZvBRCghK/pqTBEKaoZe3OZLOSkJ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 74cef95e-9f17-427c-a743-08db0aba1d74
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 16:24:28.2122
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rykWa0m6S49SEAFI6yldUYL5hdk/nxsggUNElwFJwN+Qseam2x2AFco2l2E0YGkVKJAJUoRTW3YIkL0J/Gu4Eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6707
X-OriginatorOrg: intel.com

Vishal Verma wrote:
> Add support in libcxl to create ram regions through a new
> cxl_decoder_create_ram_region() API, which works similarly to its pmem
> sibling.
> 
> Enable ram region creation in cxl-cli, with the only differences from
> the pmem flow being:
>   1/ Use the above create_ram_region API, and
>   2/ Elide setting the UUID, since ram regions don't have one
> 
> Cc: Dan Williams <dan.j.williams@intel.com>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  Documentation/cxl/cxl-create-region.txt |  3 ++-
>  cxl/lib/libcxl.c                        | 22 +++++++++++++++++++---
>  cxl/libcxl.h                            |  1 +
>  cxl/region.c                            | 28 ++++++++++++++++++++++++----
>  cxl/lib/libcxl.sym                      |  1 +
>  5 files changed, 47 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/cxl/cxl-create-region.txt b/Documentation/cxl/cxl-create-region.txt
> index 286779e..ada0e52 100644
> --- a/Documentation/cxl/cxl-create-region.txt
> +++ b/Documentation/cxl/cxl-create-region.txt
> @@ -80,7 +80,8 @@ include::bus-option.txt[]
>  -U::
>  --uuid=::
>  	Specify a UUID for the new region. This shouldn't usually need to be
> -	specified, as one will be generated by default.
> +	specified, as one will be generated by default. Only applicable to
> +	pmem regions.
>  
>  -w::
>  --ways=::
> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> index 83f628b..c5b9b18 100644
> --- a/cxl/lib/libcxl.c
> +++ b/cxl/lib/libcxl.c
> @@ -2234,8 +2234,8 @@ cxl_decoder_get_region(struct cxl_decoder *decoder)
>  	return NULL;
>  }
>  
> -CXL_EXPORT struct cxl_region *
> -cxl_decoder_create_pmem_region(struct cxl_decoder *decoder)
> +static struct cxl_region *cxl_decoder_create_region(struct cxl_decoder *decoder,
> +						    enum cxl_decoder_mode mode)
>  {
>  	struct cxl_ctx *ctx = cxl_decoder_get_ctx(decoder);
>  	char *path = decoder->dev_buf;
> @@ -2243,7 +2243,11 @@ cxl_decoder_create_pmem_region(struct cxl_decoder *decoder)
>  	struct cxl_region *region;
>  	int rc;
>  
> -	sprintf(path, "%s/create_pmem_region", decoder->dev_path);
> +	if (mode == CXL_DECODER_MODE_PMEM)
> +		sprintf(path, "%s/create_pmem_region", decoder->dev_path);
> +	else if (mode == CXL_DECODER_MODE_RAM)
> +		sprintf(path, "%s/create_ram_region", decoder->dev_path);
> +
>  	rc = sysfs_read_attr(ctx, path, buf);
>  	if (rc < 0) {
>  		err(ctx, "failed to read new region name: %s\n",
> @@ -2282,6 +2286,18 @@ cxl_decoder_create_pmem_region(struct cxl_decoder *decoder)
>  	return region;
>  }
>  
> +CXL_EXPORT struct cxl_region *
> +cxl_decoder_create_pmem_region(struct cxl_decoder *decoder)
> +{
> +	return cxl_decoder_create_region(decoder, CXL_DECODER_MODE_PMEM);
> +}
> +
> +CXL_EXPORT struct cxl_region *
> +cxl_decoder_create_ram_region(struct cxl_decoder *decoder)
> +{
> +	return cxl_decoder_create_region(decoder, CXL_DECODER_MODE_RAM);
> +}
> +
>  CXL_EXPORT int cxl_decoder_get_nr_targets(struct cxl_decoder *decoder)
>  {
>  	return decoder->nr_targets;
> diff --git a/cxl/libcxl.h b/cxl/libcxl.h
> index e6cca11..904156c 100644
> --- a/cxl/libcxl.h
> +++ b/cxl/libcxl.h
> @@ -213,6 +213,7 @@ cxl_decoder_get_interleave_granularity(struct cxl_decoder *decoder);
>  unsigned int cxl_decoder_get_interleave_ways(struct cxl_decoder *decoder);
>  struct cxl_region *cxl_decoder_get_region(struct cxl_decoder *decoder);
>  struct cxl_region *cxl_decoder_create_pmem_region(struct cxl_decoder *decoder);
> +struct cxl_region *cxl_decoder_create_ram_region(struct cxl_decoder *decoder);
>  struct cxl_decoder *cxl_decoder_get_by_name(struct cxl_ctx *ctx,
>  					    const char *ident);
>  struct cxl_memdev *cxl_decoder_get_memdev(struct cxl_decoder *decoder);
> diff --git a/cxl/region.c b/cxl/region.c
> index 38aa142..c69cb9a 100644
> --- a/cxl/region.c
> +++ b/cxl/region.c
> @@ -380,7 +380,18 @@ static void collect_minsize(struct cxl_ctx *ctx, struct parsed_params *p)
>  		struct json_object *jobj =
>  			json_object_array_get_idx(p->memdevs, i);
>  		struct cxl_memdev *memdev = json_object_get_userdata(jobj);
> -		u64 size = cxl_memdev_get_pmem_size(memdev);
> +		u64 size = 0;
> +
> +		switch(p->mode) {
> +		case CXL_DECODER_MODE_RAM:
> +			size = cxl_memdev_get_ram_size(memdev);
> +			break;
> +		case CXL_DECODER_MODE_PMEM:
> +			size = cxl_memdev_get_pmem_size(memdev);
> +			break;
> +		default:
> +			/* Shouldn't ever get here */ ;
> +		}
>  
>  		if (!p->ep_min_size)
>  			p->ep_min_size = size;
> @@ -589,8 +600,15 @@ static int create_region(struct cxl_ctx *ctx, int *count,
>  				param.root_decoder);
>  			return -ENXIO;
>  		}
> +	} else if (p->mode == CXL_DECODER_MODE_RAM) {
> +		region = cxl_decoder_create_ram_region(p->root_decoder);
> +		if (!region) {
> +			log_err(&rl, "failed to create region under %s\n",
> +				param.root_decoder);
> +			return -ENXIO;
> +		}
>  	} else {
> -		log_err(&rl, "region type '%s' not supported yet\n",
> +		log_err(&rl, "region type '%s' is not supported\n",
>  			param.type);
>  		return -EOPNOTSUPP;
>  	}
> @@ -602,10 +620,12 @@ static int create_region(struct cxl_ctx *ctx, int *count,
>  		goto out;
>  	granularity = rc;
>  
> -	uuid_generate(uuid);
>  	try(cxl_region, set_interleave_granularity, region, granularity);
>  	try(cxl_region, set_interleave_ways, region, p->ways);
> -	try(cxl_region, set_uuid, region, uuid);
> +	if (p->mode == CXL_DECODER_MODE_PMEM) {
> +		uuid_generate(uuid);
> +		try(cxl_region, set_uuid, region, uuid);
> +	}
>  	try(cxl_region, set_size, region, size);
>  
>  	for (i = 0; i < p->ways; i++) {
> diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
> index 9832d09..84f60ad 100644
> --- a/cxl/lib/libcxl.sym
> +++ b/cxl/lib/libcxl.sym
> @@ -246,4 +246,5 @@ global:
>  LIBCXL_5 {
>  global:
>  	cxl_region_get_mode;
> +	cxl_decoder_create_ram_region;
>  } LIBCXL_4;
> 
> -- 
> 2.39.1
> 


