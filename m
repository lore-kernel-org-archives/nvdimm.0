Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C76117F
	for <nvdimm@lists.linux.dev>; Wed,  8 Feb 2023 03:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675828530; x=1707364530;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Sqjp1PZUckSxK+kWUrMoaJLFUkAKzat/SftcO8Y1d0Y=;
  b=SyNnRiXaC0bM1POcZpV/rvP6xiTzpT4ZcnMVdRW/qS1DnlFRfnH3RGao
   ayguKCW+VqnF1x6yD0gBGX9DHXp4bxYZ295MyoMLrvnL2RarhUC5qo14H
   TrQccuj1FA60kAOPT/hJB/gA3tm7RlurSVgrqhE8hSTnRq+P4baLL1/q8
   41MGXYO/ICBJeXXzNlhVFACSvJLOAYL30b30IQR9PvApfVyPK8CIGFliJ
   7pSXwrmoYgaZM2Mjy95KjbudsZ80Gbby497RHHR8NW+5sVYhTilLhdd+2
   q7StxcgwVxL7fb4pk73UcVum40wqKjCmRO77o1Ryad87aNcSmiKEvc/dY
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="329727859"
X-IronPort-AV: E=Sophos;i="5.97,279,1669104000"; 
   d="scan'208";a="329727859"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 19:55:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="667087334"
X-IronPort-AV: E=Sophos;i="5.97,279,1669104000"; 
   d="scan'208";a="667087334"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 07 Feb 2023 19:55:29 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Feb 2023 19:55:29 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 7 Feb 2023 19:55:29 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 7 Feb 2023 19:55:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HR3h3CubNLbVvxGfsIN++2XdtXrAWgOtzva4UXKYLF3n6uJagJFnxaVIEcL7oRriqqZuL0lKlAOuS21FU4ryZPonhH+U1W4ZJ2iyFKx5qJWa+Er95ppcZukRjHmNGIu1PGvt2lvkZZH3NPnWjRLPnjETuTRdKvfeVXpiwnNS3JKxtgVnWmdeHwtKezdWh12A1dqCgRMfe8KaG4dSlONPuE07IhisjggPu4SDuMdMup8NZ58VYbGYsWQeT0FWBcjRG2Y+smuL1scaAiGYtGBwtDwqVHHLnhUxTgcXlv6Ms/hDN7ozWID+PrJl2HFxurOOQKCpeoDyrWyGlXRut/aoiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TqQQsuv6JqkB0K0FECxi9n+g7yTsMKm2zM4uQx1ck28=;
 b=RY/s+H8F3bYVQmrHi0JGKUsLn4WO3yyetgXAZoF9YIi5mn12+IlfgyeF73v79Lba/1U+QOXIyxhs5BTBOcwI2ySmudAGPitlHeaCXqIsbrCo66GAy2Pu1DN/qswEBlZ7RaxIG54bzQ1CcTyO7Xe7w6/vx6fR2IhlrkL6A8lZ1N6vjwlP5Bqb9ZrJ2VBFelX90CsczQp+ydzpmZ8QoDUzWEJN+kIIQDZOX5MgZx1urVeO6ZH6GQKK2IkiCCEpGaalfVr6z92mrlK7sEoeTJriPcekHuNdX/xX3+2DmBZN94cXiPr+gOv1CJQ+Y/VdxfmwYyUDL4LwCxmkeNVAqXEx+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by DS7PR11MB7949.namprd11.prod.outlook.com (2603:10b6:8:eb::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.36; Wed, 8 Feb
 2023 03:55:27 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::6851:3db2:1166:dda6]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::6851:3db2:1166:dda6%9]) with mapi id 15.20.6064.034; Wed, 8 Feb 2023
 03:55:27 +0000
Date: Tue, 7 Feb 2023 19:55:23 -0800
From: Ira Weiny <ira.weiny@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>
CC: Gregory Price <gregory.price@memverge.com>, Jonathan Cameron
	<Jonathan.Cameron@huawei.com>, Davidlohr Bueso <dave@stgolabs.net>, "Dan
 Williams" <dan.j.williams@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH ndctl 3/7] cxl: add core plumbing for creation of ram
 regions
Message-ID: <63e31d2bc5178_107e3f294e2@iweiny-mobl.notmuch>
References: <20230120-vv-volatile-regions-v1-0-b42b21ee8d0b@intel.com>
 <20230120-vv-volatile-regions-v1-3-b42b21ee8d0b@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230120-vv-volatile-regions-v1-3-b42b21ee8d0b@intel.com>
X-ClientProxiedBy: BYAPR02CA0009.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::22) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|DS7PR11MB7949:EE_
X-MS-Office365-Filtering-Correlation-Id: 2904a31d-baca-49fc-22b6-08db0988502f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5D3FtDq2AvnKP2FSyIe/H4413WSFHiub0AXRFffGLXfnqXmvtAqQTUy55BzVGyAtyvzR6sfpiVMmM/E5jgPGi4aSlOSxmkq+Q5fnZcmLhSE4NS7fQ1FB5O/memIN9hkmm0qCSqhtLjfcsIHBGr4ryHTpuYzVBBw6aRkGoREkZwj5k43WuyOLHT8OK+Xt0XM66y3dt25hYooFVO4FJ1eXQmBqjNS1HlJ3QVGUo76zmwET6W53bW/PjFlVD7KYUsEynPFdFcPGB5/r2raHAmUkOfAOVDxCDsgXngCZaIn97BX54A6dKEcc/ln8/O9u5I2fROH34jEN0Fb0ubF47x293j5IThvFPy81yvgWrbw60lIpWagnokQMR4k4IMQ9QSA9U1uuSuiIryHAPOg4Y9zj2fzLz6NZ+M4LHJzqUr+jYdXfVV46AfpdPrdo6wZmc2kZ4eCnMQjVngvfT+A9J4+1VMOExMkTH2RTAI42U/evbFBFVFiiWagIyt/C2K23YygqjLUdn2BB9tHwdWMj/THcFSql4oZHtWqYgn1ksM3r0Ch3d1z6PpC5bJLougN9shpDN2lFsstzU1ati++qjK2R+0Ae6mLYlOMo5iZ0sFcMmDqqxsq0hWiJfNuWJc4MToNVWBMCh55Su8Y1WaJM+e7xBA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(376002)(346002)(366004)(39860400002)(136003)(451199018)(316002)(54906003)(83380400001)(86362001)(38100700002)(82960400001)(26005)(186003)(6512007)(6506007)(9686003)(6486002)(6666004)(478600001)(41300700001)(5660300002)(44832011)(8936002)(2906002)(8676002)(66476007)(4326008)(66946007)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cjnc27oqgDJZYuWaiLRqcpfAw8yjn5TerqDzWOyIKPUhUa1Z5zyv9YJ4kqjz?=
 =?us-ascii?Q?j5HcD47ct1EkpxW0rvaglIdTJpXb9QuWhrk7bC3jRTZiCCFNSpoDBmCB5EG6?=
 =?us-ascii?Q?NnGmpnh+Dd/6Z1QxsSCsyeoylXGpA/byQSlIlrbVJvIt4sAfHy4DktzcNMMD?=
 =?us-ascii?Q?dhJvfblGY4lqWcqdNYX8ihjhZdh5z68b1oVOBvW+7668t4QP9eREAQ2+cOQF?=
 =?us-ascii?Q?62dt21ruhd387XpJi1oElh52rsadRAF61Hz7TgVItHBLpJ2oEvL62uugFrtt?=
 =?us-ascii?Q?oJ7L0VoFGo0iX/qXqQ5uqBY2ZGpCjWorC/GuGcpY6arJ8RpFnMrjt/hVT1Oc?=
 =?us-ascii?Q?p9le1AuB+cdgk/sTgdHakqHv7A1X8wSnOdkkCL4kSkJTHCRYuKQBUnPl3NQN?=
 =?us-ascii?Q?5R4mof00WbyujDmybZFapfmia7AoOBzP4MwpcxZ5+ne8RYbdaBiBsNj6JdvZ?=
 =?us-ascii?Q?QXuiVtG6KrrXzZJ9mAMvL1dsVS0zB0BrfL8+ofMdGczBi3CVv7zfy70HwAhP?=
 =?us-ascii?Q?6L9fZbkZzcbUNZS0tejBA8awD+cXEzYH2+u9u77W+WCmo+0ZQ2CUuUBmvciF?=
 =?us-ascii?Q?skf32HoN/WXgy+jqdMJyVnoOj+sl7TYElozTIUqYdyF2281tlv7NfjSxKkl2?=
 =?us-ascii?Q?KmN347y6f0unvCUhGQeURufZDUzAEn8c1ninbH6YjTdHyQG99ac5yErQR8Mu?=
 =?us-ascii?Q?7l/mohFfjTRYLxaDn0x7WoYHTqsOONq8N9rnglUsNlJywLG1qDHwWoRjpqvI?=
 =?us-ascii?Q?+sW2sDEcP1rPYaTl0IigyTdYn03jL7IzovGIVejF0MW9zVmDTFVhB5K+YaFl?=
 =?us-ascii?Q?eF3XR2qLQJDaZU8UwuUuzmwKt5Noeo6/NvsOq00JKmxJl4vMe32z7VDxxd/K?=
 =?us-ascii?Q?+VBdb3gE+157mx7srjlbL4w/wShvsoxPXh8YjNa/c3vx7Yt7jUs+D1kMIOqe?=
 =?us-ascii?Q?w3cfFNjp+T9PG5UMEeCVzkvyM/dQplzK4HQu0qSRLNsRCbaC6wilrNnJkPJc?=
 =?us-ascii?Q?9us4SDJtq0hIaTe3AAQVgNbzVjepiRUHeuljyrdkV68ZqZ/YcykLe+wIPi+/?=
 =?us-ascii?Q?3iU1yME5pDsub+3DZAfaiAttjqqL5zfYY/XICoiu+HwOKAVty/mS9RNd20xx?=
 =?us-ascii?Q?1E0cdN/J+tioNoGfV9rnE5uZpkR5/RmeeZbUzldzviVPv8/mpQGMl24Hqo3h?=
 =?us-ascii?Q?/i/yLes6vFkDEtLFAWjdDKUVbftlJDfmQx+Xi0Sf8rOlvSp97B9+1Var/Mf1?=
 =?us-ascii?Q?+6UopjDtZeqyOFkxut+jplJeu13k6LdSKP/KspVfASvUb1Xja+H6byGt+W23?=
 =?us-ascii?Q?2WQmO3LCjRvxUC+nN0XLU1RaFpHw2LCvdoAk5GlaRyToeU4Hdm1QJWSblgNc?=
 =?us-ascii?Q?UFlEzUWRh7bZtmGLsVCQMD0MENZ/7ReP/g0zD0F5WIUvV56hyOtCBKB43CMT?=
 =?us-ascii?Q?K6hvem+/BUn8cssqkfYNXa4DptbWn35EGOjaSjCiPxm31jm4V1QlKShEATHD?=
 =?us-ascii?Q?2bPm/UR2E5Hte+4HesUJD/xqQ44gjdtN/0hPQf6RTLI1ipHuZVSN5o+PuYE0?=
 =?us-ascii?Q?jNqQl1XQgqpBqBLfoef+Rc62Nh9JNi//lgrXqjWR?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2904a31d-baca-49fc-22b6-08db0988502f
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 03:55:27.0557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2WYLZEmG3BwEWhQhNfvRnYE2U/ynEdV+prjJSWDOMZvc/4POpexollu/1aTtWhOSygpNKyMbqMnTJsHFVbpIGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7949
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
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  Documentation/cxl/cxl-create-region.txt |  3 ++-
>  cxl/lib/libcxl.c                        | 22 +++++++++++++++++++---
>  cxl/libcxl.h                            |  1 +
>  cxl/region.c                            | 32 ++++++++++++++++++++++++++++----
>  cxl/lib/libcxl.sym                      |  1 +
>  5 files changed, 51 insertions(+), 8 deletions(-)
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
> index 38aa142..0945a14 100644
> --- a/cxl/region.c
> +++ b/cxl/region.c
> @@ -380,7 +380,22 @@ static void collect_minsize(struct cxl_ctx *ctx, struct parsed_params *p)
>  		struct json_object *jobj =
>  			json_object_array_get_idx(p->memdevs, i);
>  		struct cxl_memdev *memdev = json_object_get_userdata(jobj);
> -		u64 size = cxl_memdev_get_pmem_size(memdev);
> +		u64 size;
> +
> +		switch(p->mode) {
> +		case CXL_DECODER_MODE_RAM:
> +			size = cxl_memdev_get_ram_size(memdev);
> +			break;
> +		case CXL_DECODER_MODE_PMEM:
> +			size = cxl_memdev_get_pmem_size(memdev);
> +			break;
> +		default:
> +			/*
> +			 * This will 'poison' ep_min_size with a 0, and
> +			 * subsequently cause the region creation to fail.
> +			 */
> +			size = 0;

Why not change collect_minsize() to return int and propagate the error up
through create_region_validate_config()?

It seems more confusing to hide a special value in size like this.

Ira

> +		}
>  
>  		if (!p->ep_min_size)
>  			p->ep_min_size = size;
> @@ -589,8 +604,15 @@ static int create_region(struct cxl_ctx *ctx, int *count,
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
> @@ -602,10 +624,12 @@ static int create_region(struct cxl_ctx *ctx, int *count,
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


