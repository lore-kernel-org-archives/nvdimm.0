Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F01B4C7A
	for <nvdimm@lists.linux.dev>; Tue,  6 Jun 2023 20:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686084164; x=1717620164;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ohIOdqOHwR7rfJZyHCoiVRwraNLX7XoEslnEJbZvqSA=;
  b=JiB0A/NudJNg8Ytt6dr8ghRKNwgO1Usm93qN+5IUBiN+cIcd7XDCNIop
   vMWxXFC4wTGcfgp40m5jLFnlS8h/E05CH2NuYovVL3w/ppcZIoaFigDzD
   p/aMzavqqtlu1msCU2Oa66jLzwNxcyWnSDWZPkFrx7KvnGkuTjGZ5/9DX
   vmoQLtaYqBcyjDiP5ThnGazwy8H2DsDxh0FM2RK2XRuwZuW+381hI6G6U
   9ZX8Rs7UVNqlbeEh1qVCmFxF+h5b0pYFYLC2yKt9GPslkJtsEaeBPGVVt
   2B0i1PSQ47GM7ubXkgzJEF6jv+Tm9sybDW19qDm+LbAYrjePwt13v28GM
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="443163261"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="443163261"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 13:42:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="738921737"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="738921737"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 06 Jun 2023 13:42:42 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 13:42:42 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 13:42:42 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 13:42:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XZK6xzGdA0YkKGIPgURTV/o0vWI+MI3nwSyI7xMvDWFLzv/OvWlAdDXadHFamhOC0iIhwok9ogRBXQTLeIXGAY0a/JgP9wwKxf21nYZi5CzGWM+rl5GFMY+YB8TPiydmu43BciPhAGmNs53I3i2qMoiwEAPtAZahyzEpCrDL7yVg7JkFnpW0TiOy1y+qVD2rs71st8jgLymla9BkzMj5CeH7Jt1dHzJJLcTCYUh2gIDPqSkKRF+uX+BjrtLtmVgtJOGFirkxN9OcUe0P7HWR8ZAFVm+lErAfepB28It/2YPz4lcFh7SavzaxE2UtgkCas+cWiiwpgC2LGYY1nQf3kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6L9lmbwklV6ox3xQ7MgRwATB6bKlyIF1Ulmvedq17kY=;
 b=hTdNDk23z4NjZumClMqjIV+QkRl2XXw5XFcJIjnVycu4mNy4xSWoRNote0ELJgehGrbjJJMfSx+MtBBSGmW8+vz1v9AvX+nUYqmENtCRSMibcS1zHlB94FabhWeZW7I1tUii29W2pGyB/cwPrVCm1aGotI1rOATIn2Spv09ZgdTIFrdFfBctHvsBggkknWCZiDtctZDZlcNP1/OvTjr3OJE0Nmq1QtQ59K592kTH9MBYNj/P2LuGqdU6/uV/chCunj3aI+Xv3EndDRbkpQxXgrijGl5q1dfqZvMX6J4b0JgqXmx9EBxqL70aXB2qnghAEO0fAMypoL54FPlcTdcQfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by DM4PR11MB8158.namprd11.prod.outlook.com (2603:10b6:8:18b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.19; Tue, 6 Jun
 2023 20:42:40 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::9679:34f7:f1b:1e7c]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::9679:34f7:f1b:1e7c%6]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 20:42:40 +0000
Date: Tue, 6 Jun 2023 13:42:35 -0700
From: Ira Weiny <ira.weiny@intel.com>
To: Fan Ni <nifan@outlook.com>, Dan Williams <dan.j.williams@intel.com>
CC: <nvdimm@lists.linux.dev>, Ira Weiny <ira.weiny@intel.com>,
	<linux-cxl@vger.kernel.org>, <a.manzanares@samsung.com>, <dave@stgolabs.net>,
	<nmtadam.samsung@gmail.com>, <nifan@outlook.com>, <fan.ni@samsung.com>
Subject: Re: [PATCH 4/4] dax: Cleanup extra dax_region references
Message-ID: <647f9a3b3c76c_bf1272945b@iweiny-mobl.notmuch>
References: <168577282846.1672036.13848242151310480001.stgit@dwillia2-xfh.jf.intel.com>
 <168577285161.1672036.8111253437794419696.stgit@dwillia2-xfh.jf.intel.com>
 <SG2PR06MB339779C9F301585300B0B4DEB252A@SG2PR06MB3397.apcprd06.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <SG2PR06MB339779C9F301585300B0B4DEB252A@SG2PR06MB3397.apcprd06.prod.outlook.com>
X-ClientProxiedBy: SJ0PR03CA0360.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::35) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|DM4PR11MB8158:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ec1c163-bfa3-4706-94fb-08db66ce91fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q+vcF8/heAeNx9d1YKLLJMYz3jWIKozn3qlbzYYli29iNwL3XTeR6EGmpL2Xa1m2VSAuv2eJJ1NZEFc3XJrOCAjHveMxjb8JhZvb0Z/J0tay4GLYraoVVNAVJeADx2epD4DR0Wfp7X+1h5NEBs4MRVwJ2LU4M83QxCJkNX+DHb9reIP8C99onY96kabC5o5Mb+R5p8kWyk2lnKOPYBZl4Jd/OjndRVmUk9sC47BUCtShxrTbxoD7kEC2ubxVFq4OQlZqZN6FySxyabgdciWXeE0HD7lShe6EwwMp1YOu3mLog+t3iKqb436vs+przYZCohDAa4cZp0f+BHlrfo8L9Adqzrakc9WGrMqF7cZEuUFc6d62rYEtd+Q1x7ekznxVVJPmJRrYrRy28oF/LAwCjD2kZggvEpmtphe8HAbLik6OEpAKxkLS5PTJ+/dJyoGBb5rQ7Z/uJZ85X4VlN8psH1W+kHEPYlwPM1lEbVsD6OxhO6UW/hzlIIhlpAirxLXJ0+rCiuYgjdlEnQqcGl7ErQMjwoAquSeMno1OV55pT9D7NKVpNtvVh9+Kl/0aJ8Hc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(136003)(366004)(39860400002)(346002)(451199021)(8676002)(8936002)(44832011)(110136005)(5660300002)(6666004)(66556008)(6636002)(66476007)(4326008)(38100700002)(316002)(6486002)(66946007)(82960400001)(41300700001)(86362001)(478600001)(186003)(6506007)(26005)(6512007)(2906002)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?04ppZqgfFFOXwwbaFqseCL+E9mp/MHAw48vhioW8klvmXFL/inIlh4PBzlTd?=
 =?us-ascii?Q?YRvAYsNxIoHwrfKHNrflSYEvF03HxCCINnLjFKmf/kvoTKXfGEELRViAYSlM?=
 =?us-ascii?Q?eaa02VQKbVz7h+teYRqj2ev2LRMetTTh5vjVQZ7X39MA0M34odjCCFknl/6k?=
 =?us-ascii?Q?ybK0e+1A27mADHAGXUphg1smJYjrh15D5olt+rgKnXep7bB3pqAo42bC7Icr?=
 =?us-ascii?Q?XbWUJwWtVCIxgw5fUKwzoT76xbkhogt2M5WkRzUhtXVxRFrsJh+3uZTJp4v+?=
 =?us-ascii?Q?h2b19Ny0hEk+m3lmO91OKrhxYTG34oScGtccW9ryI2wOP1RtaiYVvT5vD89N?=
 =?us-ascii?Q?RN5AlwXXLYXXQ/UmPT0NMvLQGcRccBmrHsjrX1e5DYdRwz5PLLbsonRj+q42?=
 =?us-ascii?Q?zRnh1kbx76Z+omLZedxFV7yZ8T1XZEkDf+u/In5JPb1qwkQBh7m34ZTd5Fb7?=
 =?us-ascii?Q?qO0EnAWdNT8MBeEdeaXQ2WxS9MtqwEXdaAFsRUVpDq5ulee44Azdeix4d+a/?=
 =?us-ascii?Q?5JSaSAb6+FxGOZxyHPJv61r0Xi/SYYLeQy8RpMpJIuA9s9m2gKPVTXocJbol?=
 =?us-ascii?Q?LT4DzpHjGIBHKX8xeGGRWhlIhLR0d3leB0XphXJwllRiMXNTqTKYHegU86ny?=
 =?us-ascii?Q?X5+1ERUGgCf0F+qVt5FHkQnjJ1r4K50ZPueDr+MuQNS+ThFYBmbb9L6z+0Ek?=
 =?us-ascii?Q?QMtyZt8G117YB2p/Zd7JotWTmaKhl+8vBcs5/i4LFdZUzm2DC0bbF/tztWbM?=
 =?us-ascii?Q?UUXXKXAjaU6yGAKgpBvXP0NeKypJw7WUXbQffQ9FV7zEo8ItC+h2ll4PHOcj?=
 =?us-ascii?Q?m3dx+Z77sBBe7Wn+IRp8zj9qGSRBZNOPugroFCHO4XNBa2CaRZovB0bFZAAN?=
 =?us-ascii?Q?ZdZ0DBOagANB+MdpYIjc+XlwlUzSoIE8igIZLnVHp6iiOewzeS6cm73ubeoq?=
 =?us-ascii?Q?aAROif8jEdyFteGQRtOGtDU+wbvwSgtedWtUUZ1FFFG3AjxT3ZQQtodqG0nz?=
 =?us-ascii?Q?XppB8h+4lY0HeZimoUUkEg1xE1cTXDWJK1FdfEwM/Jaaa+DKRwieLmLsuEQA?=
 =?us-ascii?Q?Xl3Ed7B/omaVkL1/wcK8PISQnBlaC2fnCK6gML6bi4LC34I7g/BxwxsGFHUa?=
 =?us-ascii?Q?21rUhGx1U1A+nNLFdvqOSLPUB4qxdIIucRH6jCu6XJFg1c9F+YmSjRxD8sg6?=
 =?us-ascii?Q?SXxRFn/43uqb0d094x5jGHrHRiA1MvwMXkb3mk6H3X0ACt5uXohkCQmzmv4o?=
 =?us-ascii?Q?2rr2R09O6p6TGPO8B3XhIDu4X28CraDU9/mC7WAHK4D2tdcBo5ICeKk8T9Fm?=
 =?us-ascii?Q?hlAm3HRU/0zCJ1IknD7aIveoQ4nyUAFu/iCOplhG4r7qTV70MMyNSp0IU9Vo?=
 =?us-ascii?Q?ba+OggqSqTmmJ1JEsslVOfKVu/ix5O4/q8EA+4Al5Ol3epxMh8OmHR0qtDLe?=
 =?us-ascii?Q?Jpn+emHMucEgM/DKV2KI0QUAmATcZGFFoljjj3E5HQsRLDiVgLNgEeQUAyGn?=
 =?us-ascii?Q?kpEuGCXXi4HDhz6Czi2xiwBezp8jeexNY4XCkpDRl1vlXycrtu5RPXuYBe8k?=
 =?us-ascii?Q?fGiGohZg5+i4u3GcDlvlid8LI+9RR7FduTpHAyIY?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ec1c163-bfa3-4706-94fb-08db66ce91fd
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 20:42:40.4716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PfZk6XsXyxbYqVWrENKRcjxNdZYMA9YW2+rcI4jiDmXuszllkTAswT6CgIotqcet0+DL4soVv62TNxA3dW/cqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8158
X-OriginatorOrg: intel.com

Fan Ni wrote:
> The 06/02/2023 23:14, Dan Williams wrote:
> > Now that free_dev_dax_id() internally manages the references it needs
> > the extra references taken by the dax_region drivers are not needed.
> > 
> > Reported-by: Ira Weiny <ira.weiny@intel.com>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> 
> Reviewed-by: Fan Ni <fan.ni@samsung.com>
> One minor comment as below.
> 

[snip]

> >  static struct platform_driver dax_hmem_driver = {
> > diff --git a/drivers/dax/pmem.c b/drivers/dax/pmem.c
> > index f050ea78bb83..ae0cb113a5d3 100644
> > --- a/drivers/dax/pmem.c
> > +++ b/drivers/dax/pmem.c
> > @@ -13,7 +13,6 @@ static struct dev_dax *__dax_pmem_probe(struct device *dev)
> >  	int rc, id, region_id;
> >  	resource_size_t offset;
> >  	struct nd_pfn_sb *pfn_sb;
> > -	struct dev_dax *dev_dax;
> >  	struct dev_dax_data data;
> >  	struct nd_namespace_io *nsio;
> >  	struct dax_region *dax_region;
> > @@ -65,12 +64,8 @@ static struct dev_dax *__dax_pmem_probe(struct device *dev)
> >  		.pgmap = &pgmap,
> >  		.size = range_len(&range),
> >  	};
> > -	dev_dax = devm_create_dev_dax(&data);
> >  
> > -	/* child dev_dax instances now own the lifetime of the dax_region */
> > -	dax_region_put(dax_region);
> > -
> > -	return dev_dax;
> > +	return devm_create_dev_dax(&data);
> 
> Not related to the patch, but why we do not need to check the returned
> value of devm_create_dev_dax as above?

__dax_pmem_probe() returns struct dev_dax * so we just pass the result on.

> Or do we really need the check as
> the function already returns ERR_PTR if failed?

Yea the caller of __dax_pmem_probe() needs to handle it.

Ira
