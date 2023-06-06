Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01olkn2025.outbound.protection.outlook.com [40.92.107.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C4D1ED55
	for <nvdimm@lists.linux.dev>; Tue,  6 Jun 2023 17:46:42 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W/lMvg42BM+qKuvPDFnYqD2iGGN6M23MKCYIvwCpyAnnFqYmXwCzWCwJUd+3Zpigv+lNoCkAaC6BZWvidBIBtwx/remMZV7aNnrZB6cVCcaSjXXhkiAbPsqcZFvraZRT/EnHwrL9F2crSo5DHDHlOxndyxUQWIhh3lALMZbH9WvAQ9V+4088Z9EIUQFEcaRghuWZ0FNHCnoY5rFZVr+J0ns+kiICrPej06s4j/dZeWVVkB0AdAhWD/5ykDgJ+WzBQulbdsP/yxR9vcvGM0KLC/P5X4q5kRpOGrRwvv6TJae5U/jhhB/AkVJ/+Y5K0PO3Pbq/3cddnw2ViswvdmjV1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qvD2DhG0YOfaNE6LS4X583mysyGXhT4FE7gsAfOibhQ=;
 b=eP0bs4uz7AfxYgUdGXSGykqWqgGPE94/xoR/3TJgK/Rz4DW6CsIxlTZGtodYfxGYaTTB8NOx4yXoUgOilUHZOTQ8aFlXkP2872wrnChTglLPyHNBpnSrE1oZ3pT2nsouIIeACccbrQPzHoPykDMKqCQj6kb+FSK3wcn6yPigrxYw7coVCI/toOXdv9lvdCT6W//0cSbhsWagOKwiZL8trpztfDu2TgWsAv9/mUIDGJPf4lIW1TwyGtYiVpk0sg13cZUPN0tWDK7xqwcr0u6+CmCdNr29TLK6s192AV4FTE97Zf4wPS/dq/EL+gK0k4uYuuoziMhhsl3tARkT61zpvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qvD2DhG0YOfaNE6LS4X583mysyGXhT4FE7gsAfOibhQ=;
 b=cxit+CkYMKrzy5zSg+iXC5zauDDAPFQsps8j3dJsS/dBcLh61BWN4jFgFLC+mwxEaGZ4jBTLqdh98GqDfw5epqAZb9QFygkbwY8EB8Zm6lS11Iwie1fDsNApsGhWqlL+1Bi10qZQtGCOt5ZWxksb1u3JdPhzhNgL1BB66n73pPwQdcsjK4vtBFz/zPk9J5Z52RcTjZcQe6QYPvAfOL6i18UVp98MqzqqwyoJkYDyHCtIw91POGLbpgXEU5dOBpOqP7hdvDKbQy5eUKDOy01292gATrV3x/OFP8ikMDehD1tSY01WEwFKZMPQ96MhwmdZhU8v35vxXMOu8Vhkv3H88A==
Received: from SG2PR06MB3397.apcprd06.prod.outlook.com (2603:1096:4:7a::17) by
 PUZPR06MB5473.apcprd06.prod.outlook.com (2603:1096:301:103::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.32; Tue, 6 Jun 2023 17:46:38 +0000
Received: from SG2PR06MB3397.apcprd06.prod.outlook.com
 ([fe80::33a7:c9e1:75ae:3227]) by SG2PR06MB3397.apcprd06.prod.outlook.com
 ([fe80::33a7:c9e1:75ae:3227%4]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 17:46:38 +0000
Date: Tue, 6 Jun 2023 10:46:25 -0700
From: Fan Ni <nifan@outlook.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: nvdimm@lists.linux.dev, Ira Weiny <ira.weiny@intel.com>,
	linux-cxl@vger.kernel.org, a.manzanares@samsung.com,
	dave@stgolabs.net, nmtadam.samsung@gmail.com, nifan@outlook.com,
	fan.ni@samsung.com
Subject: Re: [PATCH 4/4] dax: Cleanup extra dax_region references
Message-ID:
 <SG2PR06MB339779C9F301585300B0B4DEB252A@SG2PR06MB3397.apcprd06.prod.outlook.com>
References: <168577282846.1672036.13848242151310480001.stgit@dwillia2-xfh.jf.intel.com>
 <168577285161.1672036.8111253437794419696.stgit@dwillia2-xfh.jf.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <168577285161.1672036.8111253437794419696.stgit@dwillia2-xfh.jf.intel.com>
X-TMN: [E6YPmvUuvNnD94+VyEPeqho9yr/VsM5FI/Bj3znno7g=]
X-ClientProxiedBy: SJ0PR13CA0027.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::32) To SG2PR06MB3397.apcprd06.prod.outlook.com
 (2603:1096:4:7a::17)
X-Microsoft-Original-Message-ID: <ZH9w8QP7N4XpO0R2@outlook.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SG2PR06MB3397:EE_|PUZPR06MB5473:EE_
X-MS-Office365-Filtering-Correlation-Id: c64a7b3f-a75f-48d4-f0e4-08db66b5f9ed
X-MS-Exchange-SLBlob-MailProps:
	02NmSoc12DdH8aA1LsM3Aq3zIVVpATEmtdRcTXAkvPu8Umk2PeAIcY8etQKJp0ptTd2LyQxCoN+OpgsqNWqCVyGvILnTZaco+B/IdxbRlYiZ2W9KF+66Xk0J7CK91Yj5bVRH9QmPM5JHzxGVpRxHPSL7Up1Q3kHCxmRtILddEjWlR3sStfqRbdCAXCoBhLL9vBVDF2egtB6mhiicFhzVX11gK4Hpz5cIeiTz9onXxkpw/2GPWVM+5xYsquo0hYaiI3OThk8RZwy8tDdVtClvunKPV+G9DaIIQnLcUo9VT+hkFqkLM562XAT8TRy5HKWtyedRXHoqb2f9gzzEtGR8brTQtmV8zjy2v3r0Gl4Y+z/R4RlTKoYUiIGPNkv71nwgpz+Zj+lJWJZb9lnaZX/W2wDetpc9klFgP5soDSObqymjEUXad6hxVEd+qu1AkUQotnalihFdVGjDTgrdUg5XIMRn5qZUQK8XMKHQv5GiOvYh2pOK3XZVzaYhNHgYQaXdwOppfFBpw144hyHeWx8gJbHq4cg7cl5/ixe/ThLkUNi4GrFj3LGSXmngG+BpYXJjemf/VyRkVTgpNwXBvS+hx3u4Se4X6um7SDE93UlPowk73xxdF/zR2xnvJ2lM92ryUcJv21JfluxP8kjMtCsGQno//YXM85AIYTlEPkOtZoS8s3QqO6NXTl6QETPY2KKJeaQPSiFt9O5guHY/UpVQyGwKUfv5aKE7aXpud/xug4Sd3J8qKBuo8lF/rrKbqSmv
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	s32ORobZW5Nt2qbeLP94MysDxrdzXG+F4nQvIZZcrxJBSWMuW3lSqBPL8NyBN87M7NtEvioW9CV038QkW0+sqBcURZXbA0S4SrhfaaeD40cNeN9GtKZtAZeVWXYHFJP3u5QU+1KPmNhMC6jXm3eYeISQJm5GGIWvTfjLkHrEOpaWXhOWUQ8DwqgY2Jd6ZO8T6PyOIabSlY5oKF7y7iR9z5HpGkzVqvt2Jhr2LrUey0/PSE8NOfqg/lqqtAJkN/OqL+AXDJYFU3/bChrT7gMFDQubthf8F0EQV0EoDi9JITbkGGjucNRPjeKcknk2omCMzlVK2v3reLg+YmOjdcAfc78Ue0zIK0rfzsREYp/cMnEG91tExn2XWOqVqdVUFmS1aJNTxT2+eUkqtj2rPZRlnAG9A6++UcqHs8MqLZmPfQzqyl2/4ZY9xXDf0zaJ5DXARKqbtQ2bhpb2KYrbj7Ob6MrX0vjCHtEpMsi8fLzSHUZ+Au2zrcTWPYWbTiR0zWT1OaGKYmYdgriXgExSPluT9QWXjeNwI5qwJB9mhM2MpplYpDYxxbvZsQDOb1KPh2aaMbHVxLQ/wOXajvilMvX6QXqGXRLD+457n/I0RN4a459wD9AkKLZbFEXT0yeZQ/9uUef96sOSMDE4nlUkGJCvLQ==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NW5WNzJmSEh5b0ZUREsvOW5VUERaTjJtQVVPWmpjZ3h5aWF0dXZERGh6bHBG?=
 =?utf-8?B?Qyt6MmpJT0VQdFd3S2pvcU4raFpZMjA4Vjc4dm5OVUVLWTNkbzdlajMwcnlT?=
 =?utf-8?B?OVZQQnoxNXBYUENXT1dRS1ZuYTVqeGd6QmNoeXRxY1JQRzZnNXpzNnM4SVZV?=
 =?utf-8?B?VWlwc1lpMkJtNXByTWpkK2lkaExnU3dKQ2NhMzhpL1ZEcldpR1pLMDJja2hN?=
 =?utf-8?B?UWRjemVwc0hEK0dtR3ZlRTFSbmhYWERBZ0tiNnhsVzNubnJVR0NzejJSdDhZ?=
 =?utf-8?B?NE5zWW43NldIY05FeVByVkYxbEJFMTdnRkdUa05JQkIzNjJ6cUdYbkxqOGFB?=
 =?utf-8?B?aUVDKzdnQzNDc3orb05JNVhpLzR4MTVKWjVYU2JUaXFlQloxVFFjNmo0emVq?=
 =?utf-8?B?WW83amRXUG4yMUZDNTVjeEIzUXRFWUozZWdON2FKM2oyOTBKRzNuRDE4MTQx?=
 =?utf-8?B?QTI2VlZmVmFqbkcxYmhrZ2UyWExvNG5RY3VSaW52c1J4ZWxSWmdCdUhqd3E2?=
 =?utf-8?B?YlpTc1l5WndiY3Jnd09qWDg5ZEZ3Q0pVRExlNnFhVzQ4YU0yeXVsL2YzVkwv?=
 =?utf-8?B?T2NBb1JmcGd3bldsOFgwRUZXNHE0ckx4dS9tdFQzREdZNHVwV0V5ekJrUm5l?=
 =?utf-8?B?K1R4ZFMzTkI0OWhjMnVRMkJZUUZpdWtYM1ZYWXVaZXZWdW9wR2JReWlzM0ZL?=
 =?utf-8?B?QW03cW9tYVk1L1B6azFNL3dBS0RVeWNmVk5XK1hUeEEwUTBtb0lPTWlnd1Q2?=
 =?utf-8?B?ZFl1a2xTUFdaSncrRFFUdDNoNHZJdXZuWHh1MC9ldDNUMi91SGhaQWtwWUhC?=
 =?utf-8?B?SnAyaForU1grQTdVOHZjVkFtTFV6MGNYUVNkNGVxSU9DWHZ2WTFKRDNTUUY3?=
 =?utf-8?B?czNBaytwMkdnUFBvSEN5ejNUNCtXVEh2MGZSUnZlSzNVRVNSSStjOFZXUC9x?=
 =?utf-8?B?WkNtcWJxdzhKbkVtTmV5RDM4M0Y2dmZ3RDNTYklDZlppMjJ5bHV4WFJLRUIz?=
 =?utf-8?B?blVBM2xqMVBUNVZ1aW5QNFBOTG10bVZZVUYxdStpQ3VRVUFJOTBRVnNtTis2?=
 =?utf-8?B?UXBTNmNTeWJjZG1NVVg5U3ZEaXV2b0w2bUhIRlhLakw3b0tYWjJhRFZKOVdw?=
 =?utf-8?B?SlR4MUFLM2N4OGJ6QzNvT29LNTJKSGVaNnNEbUU1cVZlUExhcGtxSkEvUW9z?=
 =?utf-8?B?dWsrZDgyL0l5YllpeC9STm94ODd6L3kyRDczWXR3cENJKzlHMkJuNzd0MjVr?=
 =?utf-8?B?SzhwL1A4czFGc2xNRVhjdGw0NnFQOVVKc0pHMUJBNnIvWE1YQ215Z05YL2Ux?=
 =?utf-8?B?L0I0bFpQUVJhUGNGZ1F1dmpsWVhzSjRVcmExZC9yZDF1WWhjeGtHYTV0em1O?=
 =?utf-8?B?M1g0VUNJM3JER0VJNHJMWitLd2tGRGw2VkFNTWhFbzFPQ1dVRHh1UVhnL1Y5?=
 =?utf-8?B?Y1BRbFpOY0J0a3hNNkhoNDRzbFZkaEgwUzZHbEJrU3o4QVhvbmpnOVFqWkdH?=
 =?utf-8?B?VUYwY2xNTVlacTBEaUd5VmF2cVBRSFQ4eFFQS3RobnBVM0VQK3h1T0ZpL21N?=
 =?utf-8?B?U3VOVlNsaEM1YTRvcWFZOWVvaW50b0dFNlBFaTdsK2pBU3VhWmtrUUl4OGFs?=
 =?utf-8?Q?IjcyyU1jPngnnEOZXn3Mcy+Tt/dLdT9E21J+PgyndzUs=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c64a7b3f-a75f-48d4-f0e4-08db66b5f9ed
X-MS-Exchange-CrossTenant-AuthSource: SG2PR06MB3397.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 17:46:38.1693
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR06MB5473

The 06/02/2023 23:14, Dan Williams wrote:
> Now that free_dev_dax_id() internally manages the references it needs
> the extra references taken by the dax_region drivers are not needed.
> 
> Reported-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Fan Ni <fan.ni@samsung.com>
One minor comment as below.

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

Not related to the patch, but why we do not need to check the returned
value of devm_create_dev_dax as above? Or do we really need the check as
the function already returns ERR_PTR if failed?

Fan

>  }
>  
>  static int dax_pmem_probe(struct device *dev)
> 

-- 
Fan Ni <nifan@outlook.com>
