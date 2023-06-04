Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A31517C8
	for <nvdimm@lists.linux.dev>; Sun,  4 Jun 2023 02:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685847507; x=1717383507;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=GiZBGT99RhbMptiH4dNgX1eOq0Xcy08Qz3bixcIlrl0=;
  b=EqrZgQXsb0mdjxIKIi8d9sFHSwYZvPjD99HF1pNuElK3Ao4pREzBRx+e
   LjiffsVJUs5/8oZjsbv7q/G9+4AezuoyayTU7D7ZMGt8PhyGA4rNJ9fNS
   jc2g0PySpY13vTIElXBcnSKPIcfutoO/CMW6m931dWO5R75FOjMo/6N+n
   mj/JRZGmkFs9hcLRM9v1BphRqVg1wESX4tAetPJpwTdHe547IK8feglQl
   THSZIdjLK19JMz++aUoB8312GkcKe6J5BlzbFKdnDjMhgHgxX+H5BY60v
   lY+pYu+q74w0SwM00tnABYfvTpXWr6GoH21r/QGQyADECaxjNakrTpY+q
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10730"; a="358586100"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="358586100"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2023 19:58:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10730"; a="685719727"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="685719727"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga006.jf.intel.com with ESMTP; 03 Jun 2023 19:58:26 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sat, 3 Jun 2023 19:58:26 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sat, 3 Jun 2023 19:58:26 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sat, 3 Jun 2023 19:58:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lNQU0nEDGuw3JM3XR3zCctu+qC0VJGKSO0/Lwj9e3TySRDnfTL/glE4cP9oARQVlvSxhlX/3oeWHCnT4iBykPY+Gd1G916iLzeev+wqvRYWbWVju9JyeMsm/y+VPIZZAV2fXEFC7z3L1w4sncXd1E32CyshqIo1U/gXKUx9m1feaqW2mJyJAzYqgj3Hmb/DYLkBxQcn+jlwXJljJcnZ0Jzn7hf6u+ziPtX211Azwt6a1F3dfsIgvRt5Og4mOHEiF3mxCBt3qMJruFpWfBr85iwJmR4VBQZtbD6oVmLdKYiOA0AGglOXNTcdFtDH+Wr/AB7GrSiHXalP9WJOQ0PNzuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7ERs8k9rfN1masPU7aV1+jN5l2aC+q6z6J08E7eBlvw=;
 b=MtMxbvoT2NGrTeWSdMmZQtFy7ZGbQeO9/WIcq74PM19gjklwtf01Ik8cAJWOBbNZkJp23O8PMHz4OaI8+3ckcpe2OU1A9c4N4PlQQodvXQrZ+IzTXoLGcDH877VrO0qt7Tg69QSZ0PeW5muW9JoSkUfI3byekZmLTSqkdTWbrd3jQHeIBC24LPgpFClYIEiQEeuwTzyMVkmDViJwiSEb3RfczeW6dTLgsVs/Umn4GkGL9ilc5BVkoZi7sjxJsyMjlW8LPnj6MxGuNuDTH4Lt1DNlSymdOqcCZq4zoapAnDBQz1XRiOQ7FNGKjX2X1qBg/0yBlSHcb2p0Ijv5VvBLiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by CO1PR11MB5012.namprd11.prod.outlook.com (2603:10b6:303:90::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.31; Sun, 4 Jun
 2023 02:58:24 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::9679:34f7:f1b:1e7c]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::9679:34f7:f1b:1e7c%6]) with mapi id 15.20.6455.027; Sun, 4 Jun 2023
 02:58:24 +0000
Date: Sat, 3 Jun 2023 19:58:19 -0700
From: Ira Weiny <ira.weiny@intel.com>
To: Dan Williams <dan.j.williams@intel.com>, <nvdimm@lists.linux.dev>
CC: Ira Weiny <ira.weiny@intel.com>, <linux-cxl@vger.kernel.org>
Subject: Re: [PATCH 4/4] dax: Cleanup extra dax_region references
Message-ID: <647bfdcbdf0b6_4c984294ea@iweiny-mobl.notmuch>
References: <168577282846.1672036.13848242151310480001.stgit@dwillia2-xfh.jf.intel.com>
 <168577285161.1672036.8111253437794419696.stgit@dwillia2-xfh.jf.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <168577285161.1672036.8111253437794419696.stgit@dwillia2-xfh.jf.intel.com>
X-ClientProxiedBy: BYAPR07CA0045.namprd07.prod.outlook.com
 (2603:10b6:a03:60::22) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|CO1PR11MB5012:EE_
X-MS-Office365-Filtering-Correlation-Id: 381be7a4-b921-4984-060c-08db64a78fbd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KP26PuYY16FOOu6UlMFwwukzWkuEmX3/D0sJ38UTa0FQ1Ne/IMXOED04nQ/wFYM3x0EATXyVjpkdT8NucTv+frD+KH161KCWSUs51JgIH9IunDYYhwrI7wAvNscBBKd8wTTxmM5E9dKy9KLlvw4YAMWUhggCPx7zNrtAKLEX2zAM2nf4iXbh0oRpLBGWnKH/abbOvrePP9aUG88GVYcmP/706X80L2i4zeeKlC/JUH9Fv4sxFZZfX/+wSNAkneTLWMupuhprQNx/a3dUFdxy342rnfeC9nqh8+Xi3jpraOZSw4cNhruceDnIVnzibp8wuHi8gkmLi1XFM9ssJ7HJGQQO7f8/pNO4B9inSb7k0brlqDESg5sdq/c/LCE2ZhqvD5WQtjm5lK5v0fmZ0PamZh0Cw5Z9eMQwVxPzDHtpaw90YyZIOyJuJnPMav2m2Bsis1ve1Ry60+KHc5q+lHprbh0AB0IUI60uvf4037HEr0JEHFjBuGhKFIN6SWsmlhmRYeIbG/zi1JTdmUwMS1lnKvIVUixMGpYj6Y6RqpGKGDg6zRcYCYN/h66xbeOb60jS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(346002)(39860400002)(366004)(376002)(451199021)(82960400001)(8936002)(8676002)(4326008)(66476007)(66556008)(66946007)(38100700002)(5660300002)(41300700001)(316002)(44832011)(478600001)(83380400001)(2906002)(86362001)(6666004)(186003)(6506007)(6512007)(26005)(6486002)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jd2k0SETVcuezNgaegZ6xgs2Ko/L1W8EKonlS6PA41yQEZkLH8qs0nbxwixl?=
 =?us-ascii?Q?v1jo3QLg7NIWJ+LVI0nOw0yaG76YTasDzgBgeiioLAbDr2BcPDLjzj2aP9e1?=
 =?us-ascii?Q?OLe0XisOT8XrseL6P4gnJclmv++E53Yririh1EWwR7rfYulEvZx/2rQ6vHSA?=
 =?us-ascii?Q?Zz3gOuwKCAH6o7N0WQASViipC1HmTB3Lop0WEkqmIstBrLzNHuVOrqDCDfHe?=
 =?us-ascii?Q?HltCtzKstnNrpN/BGWz8kauOdraVzJrthmS9bbFMn2xQG2Mxpm9XUUFXe3UF?=
 =?us-ascii?Q?v0lhba924WmIFJvie9/0av8hjAAEYVFFTiwH+lVVborA3RTnm9sEx4pZ0yq/?=
 =?us-ascii?Q?YkUim6tCJiUVCRJhRMR5YhQDsaKnqQE85u7Td+N9o4Zt7ge5VjZTFpAxYXIK?=
 =?us-ascii?Q?n2SLp6KJthgLEeo9wqrMQAy9jLxEYPGMi7nvXIAZ+u9igiX/WOsmmgDjy0MP?=
 =?us-ascii?Q?rRTBKVv2d9GVdtcnMbWF2gbj4g6wxXRHJvl70BlHPh/JfBd7TrXe1ijsvPjN?=
 =?us-ascii?Q?9JrxPZ7yipzHGso7xj78tmuBL/MeVzFXCG6T1HSKOknL7vGLVT36wz4S8O3d?=
 =?us-ascii?Q?otXmJjpxEx/xB1RTE20yrTr2xsm+8DbBXjzjt6cySE8TrCu1ntSd8hbftSXu?=
 =?us-ascii?Q?6DIVB4KtRZMZ9b0UCqpjNSOkiWCLmDiH3uVQo1yUnBXMTbgXMjlX8kDSiu43?=
 =?us-ascii?Q?xxH/ISY6BXjjvSgtX+DmyprV8lWFlJGGBm0mab/+nKznpwSUYEHAFTvqNGid?=
 =?us-ascii?Q?bJL1eqtsaULVezT5JxwdtQfT1I6weLoPkCcWo0MI4p/kzWu/Au5NmqzzG3Ql?=
 =?us-ascii?Q?ruzfntXb2KVLk3KaJbvCpi71lEkoUuDbE5MeKLloqUaZeh8WAAiLfMyOiDTM?=
 =?us-ascii?Q?N6Z65gam1F4fh9cQp2TOJjx4qZFPzl4afxgik0vMyQvM7mvTKSGhwY29lyaW?=
 =?us-ascii?Q?m4mHshsiXwqRy+U57tFt2iGUy3Y4VF4CNp6yDiFrhGo0SVzSfxpAdSgNGaPP?=
 =?us-ascii?Q?hQl9PJFFe69goo1/w4gZyBRS8l0n64F0kxHzOuL5dVAGyEcd2XCWBS8fLPRT?=
 =?us-ascii?Q?mygXSgfnq7lU6PVTjJuIp3eiuPw4sHhMgcuF1ughR3myFhFWgnEsXQzaEg5D?=
 =?us-ascii?Q?uTEyRBpX1opO34q/ViU6ROC1ow2wgs2RTwvtUlwxZTGs2UgZOaBoQPH0nkvt?=
 =?us-ascii?Q?2icaW9PaYd/vHL8c7pqHktA6fJIzuD/pRlndF3ZB9ciUsaq6hfNIViOd11ea?=
 =?us-ascii?Q?KIik9WSGwegQqqNezjncaXfXnqmBjRTOGMvpxkozVB8hiv3t/s2L58biYkB0?=
 =?us-ascii?Q?3zHCkLmOXJq6m8tvTXND3X80wuSQGLouJCLbMnap9dIkWjZ8IUgoMWL4Mjs6?=
 =?us-ascii?Q?9yEjsalPyQN6UTTVTrZj1XBTy/yPM4YdwtT0UuY260xuPIPlDsODVznmsRc8?=
 =?us-ascii?Q?QfWSQ14j7BLI+zWWe4AR8HH/mQg+CmZlAOxc+QC9aVraQ52yYpRdXydynqsT?=
 =?us-ascii?Q?XoLtEG2hOP1vLAra5Pk9zcdUCgR7rSM19fCvsFNMCRsdGlhbGREIS6DXxmUk?=
 =?us-ascii?Q?+wnhpbNs2DgGZNip1SSc/ZU3P//5PqBet+iGpzHv?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 381be7a4-b921-4984-060c-08db64a78fbd
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2023 02:58:24.0367
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: akN67yfnuMKMDpxA1WuxM0LwQakwPEGMmANC4hNt9itilliQAdwgO6Ro/B+dlQx5i9eNvdzwXMMqrA8RQuA/7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5012
X-OriginatorOrg: intel.com

Dan Williams wrote:
> Now that free_dev_dax_id() internally manages the references it needs
> the extra references taken by the dax_region drivers are not needed.
> 
> Reported-by: Ira Weiny <ira.weiny@intel.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/dax/bus.c       |    4 +---
>  drivers/dax/bus.h       |    1 -
>  drivers/dax/cxl.c       |    8 +-------
>  drivers/dax/hmem/hmem.c |    8 +-------
>  drivers/dax/pmem.c      |    7 +------
>  5 files changed, 4 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index a4cc3eca774f..0ee96e6fc426 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -454,11 +454,10 @@ static void dax_region_free(struct kref *kref)
>  	kfree(dax_region);
>  }
>  
> -void dax_region_put(struct dax_region *dax_region)
> +static void dax_region_put(struct dax_region *dax_region)
>  {
>  	kref_put(&dax_region->kref, dax_region_free);
>  }
> -EXPORT_SYMBOL_GPL(dax_region_put);
>  
>  /* a return value >= 0 indicates this invocation invalidated the id */
>  static int __free_dev_dax_id(struct dev_dax *dev_dax)
> @@ -641,7 +640,6 @@ struct dax_region *alloc_dax_region(struct device *parent, int region_id,
>  		return NULL;
>  	}
>  
> -	kref_get(&dax_region->kref);
>  	if (devm_add_action_or_reset(parent, dax_region_unregister, dax_region))
>  		return NULL;
>  	return dax_region;
> diff --git a/drivers/dax/bus.h b/drivers/dax/bus.h
> index 8cd79ab34292..bdbf719df5c5 100644
> --- a/drivers/dax/bus.h
> +++ b/drivers/dax/bus.h
> @@ -9,7 +9,6 @@ struct dev_dax;
>  struct resource;
>  struct dax_device;
>  struct dax_region;
> -void dax_region_put(struct dax_region *dax_region);
>  
>  /* dax bus specific ioresource flags */
>  #define IORESOURCE_DAX_STATIC BIT(0)
> diff --git a/drivers/dax/cxl.c b/drivers/dax/cxl.c
> index ccdf8de85bd5..8bc9d04034d6 100644
> --- a/drivers/dax/cxl.c
> +++ b/drivers/dax/cxl.c
> @@ -13,7 +13,6 @@ static int cxl_dax_region_probe(struct device *dev)
>  	struct cxl_region *cxlr = cxlr_dax->cxlr;
>  	struct dax_region *dax_region;
>  	struct dev_dax_data data;
> -	struct dev_dax *dev_dax;
>  
>  	if (nid == NUMA_NO_NODE)
>  		nid = memory_add_physaddr_to_nid(cxlr_dax->hpa_range.start);
> @@ -28,13 +27,8 @@ static int cxl_dax_region_probe(struct device *dev)
>  		.id = -1,
>  		.size = range_len(&cxlr_dax->hpa_range),
>  	};
> -	dev_dax = devm_create_dev_dax(&data);
> -	if (IS_ERR(dev_dax))
> -		return PTR_ERR(dev_dax);
>  
> -	/* child dev_dax instances now own the lifetime of the dax_region */
> -	dax_region_put(dax_region);
> -	return 0;
> +	return PTR_ERR_OR_ZERO(devm_create_dev_dax(&data));
>  }
>  
>  static struct cxl_driver cxl_dax_region_driver = {
> diff --git a/drivers/dax/hmem/hmem.c b/drivers/dax/hmem/hmem.c
> index e5fe8b39fb94..5d2ddef0f8f5 100644
> --- a/drivers/dax/hmem/hmem.c
> +++ b/drivers/dax/hmem/hmem.c
> @@ -16,7 +16,6 @@ static int dax_hmem_probe(struct platform_device *pdev)
>  	struct dax_region *dax_region;
>  	struct memregion_info *mri;
>  	struct dev_dax_data data;
> -	struct dev_dax *dev_dax;
>  
>  	/*
>  	 * @region_idle == true indicates that an administrative agent
> @@ -38,13 +37,8 @@ static int dax_hmem_probe(struct platform_device *pdev)
>  		.id = -1,
>  		.size = region_idle ? 0 : range_len(&mri->range),
>  	};
> -	dev_dax = devm_create_dev_dax(&data);
> -	if (IS_ERR(dev_dax))
> -		return PTR_ERR(dev_dax);
>  
> -	/* child dev_dax instances now own the lifetime of the dax_region */
> -	dax_region_put(dax_region);
> -	return 0;
> +	return PTR_ERR_OR_ZERO(devm_create_dev_dax(&data));
>  }
>  
>  static struct platform_driver dax_hmem_driver = {
> diff --git a/drivers/dax/pmem.c b/drivers/dax/pmem.c
> index f050ea78bb83..ae0cb113a5d3 100644
> --- a/drivers/dax/pmem.c
> +++ b/drivers/dax/pmem.c
> @@ -13,7 +13,6 @@ static struct dev_dax *__dax_pmem_probe(struct device *dev)
>  	int rc, id, region_id;
>  	resource_size_t offset;
>  	struct nd_pfn_sb *pfn_sb;
> -	struct dev_dax *dev_dax;
>  	struct dev_dax_data data;
>  	struct nd_namespace_io *nsio;
>  	struct dax_region *dax_region;
> @@ -65,12 +64,8 @@ static struct dev_dax *__dax_pmem_probe(struct device *dev)
>  		.pgmap = &pgmap,
>  		.size = range_len(&range),
>  	};
> -	dev_dax = devm_create_dev_dax(&data);
>  
> -	/* child dev_dax instances now own the lifetime of the dax_region */
> -	dax_region_put(dax_region);
> -
> -	return dev_dax;
> +	return devm_create_dev_dax(&data);
>  }
>  
>  static int dax_pmem_probe(struct device *dev)
> 


