Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2692F7B
	for <nvdimm@lists.linux.dev>; Wed, 20 Jul 2022 01:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658280334; x=1689816334;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=k5uvTr6rfGV2bkpX1Ttdrid21uP76gPSMPu9oOxjhnk=;
  b=OwSM+T9zNhYwdYLEobInd1H3iINjE7g9QD5iu4TyeqnHEsmR6NKcKKHQ
   hUu54nhGx5wrTXzIi2aLkGPctCtNrzYwlVAAzODUThZ7ZWDbjI/N2Qyqe
   j0lp2+quDi+cFWXz3BnHTSdPCJtE3zfUvKqWov6EjOxSbfzYyqgtdBUDA
   sn7D37oW424Ms+xONo+F3dMckw+WeoLVNDcAXHrS9JO28rN4dpdwBWwI6
   IP0ODI3oduqIBBANLIHQlIUHKyS35NrcxFREIvj1sFe/H2TDZ36qZfULI
   org9c62evSgyOEFt/MY3hZMcFNjX/xMZsUbIyv8HUkOJ2fsKwOeg4M6Bc
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10413"; a="273485763"
X-IronPort-AV: E=Sophos;i="5.92,285,1650956400"; 
   d="scan'208";a="273485763"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 18:25:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,285,1650956400"; 
   d="scan'208";a="601787275"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga007.fm.intel.com with ESMTP; 19 Jul 2022 18:25:33 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 19 Jul 2022 18:25:33 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 19 Jul 2022 18:25:32 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Tue, 19 Jul 2022 18:25:32 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 19 Jul 2022 18:25:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QXTJpPKzDy+E5fPi0esyDqeT6pCcg0T98ph9131pUWSLuexi+Ye369LxKLNZ6mZ79PcWGt9Ix69Vcj0HccT90wlJ+5ppXIaELaoWW/SLofuqs8d1gDbjuYQP8jfl4kFOsBugBULROZfWxPJKdGf0NKoK/WGyftJuuee3+4NrER1Jr6ZNoT1tfSPQCm0Pa9OpXHCi1U1RARwT2nsJRpIIYusw+HLlZD6SiH/5iGfy38gzVmB+EurZKqcHKliND3AlIjUW548Y07WejFNTM2Na3nahhLDbz6Waq/+aXus5E4vlln1pCw6nIn/phJmHBjM0nc1Yo6AH6ADfRmXGMEP+2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FrgzIacp0HhPCw05akQ0WcOhmRW2f/KNzkJTNDE57Nc=;
 b=W2/YZGfstqRMkFb+AFE8CoVp1tG+58cDGKu2hbW59o3Kzez5NEqT2t90OQS7SFQZt+sUA8asiVrFPHMLhSQTbBv/DO11G6+2hmezwCvD/BkvtxqlSkrCuhRVsXDjrjTaVnuOgQ7EN+z5PXKCwdX8NVzXtMwcg54i+dQYMFg3D7TlOEGGkAunYFlZy4s/huKZZWxXZLPWO8RzlFKhmn84wWk9IiG22ftGbFtiSZqPIhGprSnUtLYtMnLFrTKOpQ83Q0CDWAfzYUzm5EF6W1RoaPoQc0jJFWaY/LTYQhSQYXaEKuEsns3w+mXGdULxOlFc4KswEfkVkcCUDbm0eZv89A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by DM6PR11MB3082.namprd11.prod.outlook.com
 (2603:10b6:5:6b::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Wed, 20 Jul
 2022 01:25:30 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf%11]) with mapi id 15.20.5438.024; Wed, 20 Jul
 2022 01:25:30 +0000
Date: Tue, 19 Jul 2022 18:25:27 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>
CC: <nvdimm@lists.linux.dev>, Dan Williams <dan.j.williams@intel.com>, "Alison
 Schofield" <alison.schofield@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
Subject: RE: [ndctl PATCH 5/8] libcxl: add low level APIs for region creation
Message-ID: <62d75987b2e24_11a1662949c@dwillia2-xfh.jf.intel.com.notmuch>
References: <20220715062550.789736-1-vishal.l.verma@intel.com>
 <20220715062550.789736-6-vishal.l.verma@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220715062550.789736-6-vishal.l.verma@intel.com>
X-ClientProxiedBy: BY3PR10CA0025.namprd10.prod.outlook.com
 (2603:10b6:a03:255::30) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 94ef7b10-c534-4f72-234c-08da69eebc09
X-MS-TrafficTypeDiagnostic: DM6PR11MB3082:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cfXh+qVaXVKuw1+yVDCaE9UIp8rLxB2VA2V4knq1zQXVRGGMtM2t3LSF2kzgqqt4lIuvNVK/2cpURjU48lzGER1I3N8HPeof9ut08vY209jQMk2Aghglbid/EkDAgmNv9uOyVEq3iHlWzS5VwwgcmszEvtOB+DYqYedYt+r2OVPAOh8oVmripvSa7I67CiTgjGjeV/40YpwoISRRTN7jlx+iGE31kjVHt5h2jCvua9pA3O+gg2v0ZAKDr/Kl3xtlRgG3QdBIGEGT07WkePf8BZM6jiclFpmoSC5GvbnoTPsmM9OnTTTTchrwkdr5ImDz+FL7xH33sJuMm5j2f8iiBMI1oOnRGgDj+id124Ij60jv9b0JhD2NiKRrXREAVdqf5P8xZR0n0zjVLZ4QCrhBq3GZqzbvsL9FdI08NsvOdjnwQCC3mtgSOulgxgIRSiOOyrAXctYqHUP0VL1xXJd1CnpDCGRwQi8VZm45FIO1HIh6/tHQStmUd8LjFbXLns0R9/LeSZYCgEVhXIbQlsBlx5QDJf97e9BLtDRo8/rDyQyVThqe6k6Wu6moEf2Yk4REE1hKZAOclcxPEEtfhFolqEWM34nFbaaKcfQqya+OYho7B1E8Xw4zgpJy9HJBgV1bC5wcoZY9R0goC8TQKCXlioO8eMlB92NIf4dmaAUfzxrghykZ/hpwbvi2Vgtmgy4tT/kGUYbY3fQz6bWkBErqnj4Xmr4Hc/CE9aujy5xp1itS6EFe5uyQQmqYA6Zbr6Wn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(376002)(136003)(366004)(346002)(39860400002)(26005)(6512007)(6666004)(41300700001)(9686003)(38100700002)(82960400001)(6506007)(2906002)(107886003)(5660300002)(83380400001)(66946007)(6486002)(66556008)(54906003)(86362001)(316002)(8936002)(478600001)(4326008)(8676002)(186003)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ljacKT9q/+I6Ba4MvF/5CYhXDeEvCaIdT3dhOKrOPF9nvmp9KtqOiX2Tjk0F?=
 =?us-ascii?Q?V/XxNbe2foHGlUdNdOsbEN0sn3lrc2p8/I1cxGcpIHRHoiJe17U4vHjiO9YC?=
 =?us-ascii?Q?qAKuGEz/rp19NLN5F8n31oydXfjhSVb+FeFwQcnzfG0EINomX19IkQ+2UJcR?=
 =?us-ascii?Q?NaFhPOye15BWZi3W3RODI3qUdpPB0yQyyhhTHgafe0B6rhHwPOJ47tLfqX/S?=
 =?us-ascii?Q?FTuLI7GzpCAih6HGvgZFafgAxE51TR9yo0U4hJePofGcailZ4GYrac5JS7sO?=
 =?us-ascii?Q?Y7DEyiqAC+5IG7y1zCCoeqo8e3SPlBNkkF9Yf8IHLOkWXL6Y2QnX7F89V8LS?=
 =?us-ascii?Q?wqCeTky4xfITZoz/EweVFhyQSotNp3BkPIUOIezvar+Hwb+p5OPD+sO8jfNM?=
 =?us-ascii?Q?Mbjy1Ii1/8jnITBpvxvDzhuWdfq3XQLKnBklFIRvmOBvyV14d+XRuDtaSJvu?=
 =?us-ascii?Q?SkJv4qcMPpMelVDatwlW+gB/Y+tmxcGSzInBJER3ZEOi6DERY7wLNqZJghDq?=
 =?us-ascii?Q?G7BD0X3K2zPIak8nMYTmxlaqRw4jxTDiYkWclQsAl39Z687Tn7jErvFc49aj?=
 =?us-ascii?Q?r+/vAE5CYoko4ImyagxF+WbMp6dDSHDfgdMZrjbS8XRjeUYtfSosiVoF1Dbh?=
 =?us-ascii?Q?q29ijoUw8Vx05I3CUXbue+28biqenirRJnKOQQYxoI1l6gQaig29nB/vEPtj?=
 =?us-ascii?Q?rbQGWFvdnRPAyfV61ha/RVjKJ+do9nbH8StXD4zUdpjkM8OLP6T2+644jaVu?=
 =?us-ascii?Q?lgmmk2QdXNh21PAqgVJpZQe1U9k8OP8bxYu6bPWrfxC8MIanvWyjy6m3Y7s4?=
 =?us-ascii?Q?R7/ZX/4T4LcwvcHDyXPVd9Ll+FFXVbiqWdfK60ju49xvqL7oE3HUqEhQgHwy?=
 =?us-ascii?Q?RX8xUigiOKpbUBGGHQ4G87xl+UM7YF9MipaAxhKG+vV4MUQg6bzgj2VVUcST?=
 =?us-ascii?Q?rdccXhyHKMwfeFw3oC7kZ5iIWLiaSzZjgkU3Ov9pm6xLhus/uobIiWBChnW/?=
 =?us-ascii?Q?dwsqh4B29bLAy3WAgtXQ2Pv3dNNaqzT4FzocwWIApIdE0HbGJKQzeLmIT4fO?=
 =?us-ascii?Q?mGO4jmPlZDV4MFmoCr001iYD/OEZEbvmDxN/RqfmeyYutmhMhYbKfMXQNOr2?=
 =?us-ascii?Q?wlN+H0teE+4BKy89KhhV7w1m/xiJQ48kT/CvfDZQYBfOm5me5LQDZXIwE2AK?=
 =?us-ascii?Q?xbOrH96NHXVGKdJLn/RvyG5WnT7xj+lYTqXjgM4B27i9+1ZDVRrNs9XxVtVc?=
 =?us-ascii?Q?b5/rSU78H0DZKsv8f58M0cm9velPWZC2w6SvpZDh5rzqh9BC7oPBONWjdbae?=
 =?us-ascii?Q?TympXXXVwCg5yW/Bu5QHnOj/H2q/niHMsTOJU96G76jHJ0ELR42WdnX7TQVd?=
 =?us-ascii?Q?UECW0VoDiXIdFnbE3OrWfE0pna3kelNHWwta0PGFrHRYj4NQz3kkK2HDfDL0?=
 =?us-ascii?Q?F1mUMzTw5B2v0P7OvFx9w1r7iPSJs8gxLcDASY9gpIomyrKTpK3dGFteLqrM?=
 =?us-ascii?Q?7zSaFXk6B30+dkvzRDeminaOx6SIsLZ8lrkdLNJscjAu0i/OImWcTqaTvSTI?=
 =?us-ascii?Q?YiDaLCxbAfNgQClmHNvh+qc2mwf6uOfeGIZa4iOQFggeu2KSsJF2yRTs1DJm?=
 =?us-ascii?Q?og=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 94ef7b10-c534-4f72-234c-08da69eebc09
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 01:25:30.6069
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NlPFF5sY79r5crxakE9rcb41K63nYdVtSTMF7IM0RPnHNgYPvuQ4Wtvd+WP+rs6oL/eHTN2OQEEsTe/5+3FVUYkDirY7sTefGbM4PXb9j9w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3082
X-OriginatorOrg: intel.com

Vishal Verma wrote:
> Add libcxl APIs to create a region under a given root decoder, and to
> set different attributes for the new region. These allow setting the
> size, interleave_ways, interleave_granularity, uuid, and the target
> devices for the newly minted cxl_region object.
> 
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
[..]
> +
> +CXL_EXPORT int cxl_region_commit(struct cxl_region *region)
> +{
> +	return do_region_commit(region, CXL_REGION_COMMIT);
> +}
> +
> +CXL_EXPORT int cxl_region_decommit(struct cxl_region *region)
> +{
> +	return do_region_commit(region, CXL_REGION_DECOMMIT);
> +}

Oh, here is a case where the "decommit" term escapes into the wild. I
think these should be cxl_region_decode_commit() and
cxl_region_decode_reset().

[..]
> diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
> index 47c1695..f1062b6 100644
> --- a/cxl/lib/libcxl.sym
> +++ b/cxl/lib/libcxl.sym
> @@ -140,6 +140,7 @@ global:
>  	cxl_decoder_is_mem_capable;
>  	cxl_decoder_is_accelmem_capable;
>  	cxl_decoder_is_locked;
> +	cxl_decoder_create_pmem_region;
>  	cxl_target_get_first;
>  	cxl_target_get_next;
>  	cxl_target_get_decoder;
> @@ -183,6 +184,7 @@ global:
>  	cxl_region_is_enabled;
>  	cxl_region_disable;
>  	cxl_region_enable;
> +	cxl_region_delete;
>  	cxl_region_get_ctx;
>  	cxl_region_get_decoder;
>  	cxl_region_get_id;
> @@ -192,9 +194,23 @@ global:
>  	cxl_region_get_resource;
>  	cxl_region_get_interleave_ways;
>  	cxl_region_get_interleave_granularity;
> +	cxl_region_get_target_decoder;
> +	cxl_region_set_size;
> +	cxl_region_set_uuid;
> +	cxl_region_set_interleave_ways;
> +	cxl_region_set_interleave_granularity;
> +	cxl_region_set_target;
> +	cxl_region_clear_target;
> +	cxl_region_clear_all_targets;
> +	cxl_region_commit;
> +	cxl_region_decommit;
>  	cxl_mapping_get_first;
>  	cxl_mapping_get_next;
>  	cxl_mapping_get_decoder;
>  	cxl_mapping_get_region;
>  	cxl_mapping_get_position;
> +	cxl_decoder_get_by_name;
> +	cxl_ep_decoder_get_memdev;
> +	cxl_decoder_get_interleave_granularity;
> +	cxl_decoder_get_interleave_ways;
>  } LIBCXL_2;

I had been adding small blurbs to Documentation/cxl/lib/libcxl.txt for
new API additions. We can handle a REGION section in that document as an
incremental follow-on.
