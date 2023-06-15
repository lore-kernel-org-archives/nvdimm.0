Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9022E0D8
	for <nvdimm@lists.linux.dev>; Thu, 15 Jun 2023 17:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686851122; x=1718387122;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=81aqwFGiiowVza0VLRythQeIzKcFxbNfPF/mNm6EfVM=;
  b=kpjK5QhHMpRwOP3HtlFdlxlUcrxNVKvP2zqZ5PIa26n74DSRFcXLAjJF
   TldiSapqsl2OOv4cEOk/H/UEU7A7kZwso0RBqxVeCRUOW+X1Qsp88FE6A
   FHVcGNdabqe/97KB7qEDaPI1y6srMdDOTU1Bkf3fRNAKNfaU0bma9k6KB
   Gp6VbtO/CHzSaEn8WMFSFyItnWwcbHqMeGfDALo6zb/NxKV8wL4gXOOCi
   a2R0ALlJyWyj3e1RmRrmrwx4Pl5uPBdZD9ZwgGm4F4CcOYBnvKsVti5So
   SRPiFKzylPCUJnKqEw3LqBH4qaqd6FxR++Vv6NUKBWV5kI9BQhEtDn8pV
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="361511450"
X-IronPort-AV: E=Sophos;i="6.00,245,1681196400"; 
   d="scan'208";a="361511450"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 10:45:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="836714266"
X-IronPort-AV: E=Sophos;i="6.00,245,1681196400"; 
   d="scan'208";a="836714266"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga004.jf.intel.com with ESMTP; 15 Jun 2023 10:45:20 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 15 Jun 2023 10:45:19 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 15 Jun 2023 10:45:19 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 15 Jun 2023 10:45:19 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 15 Jun 2023 10:45:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ABUEiwsOID/4yppCCO5suGOcW1/Yc89CYulKo+5Mj3PKPtMLWN1B0yz2dJtAocZa0Pa9+xrfdfYNZMouiR6JyCqieihP4arDcFxEainQt4YTDpzFnVfaOCaHMRZP+HOT+zHFJA3F0lgdmlWMh1pCxpJG03YwyARhoGtJ08zQYRh0kr1J6KTzXwrcDwzImOIrNkBV0LEPNVT3hfbCQ3M0WgJqPhz3g8jU14Z9yy4lQZvR4aG8HhRAXgslXLzx/6X+QGnjK36ZJsK7J8axRXQWsVQLEZTdFeCD5mdeFC1z89sJ20Po5Ut01yQrTAjfMAC5NhxAseiYuKTU2zW3ZlbYtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DIINxcMe/ALEa2XYjXaNFaL11A9pZnaakQxasOslkjs=;
 b=YLUtrwYtkqEioUaIFLw7ZougoZ7IMz4w3y/Xndc6rVuZ6wp/50mWez604ctPRsT2e00TJ8zSQFBvSjkGswD7xXVNeg59cOZED8NQNxFYl6gkFCRu4vlXUe31wG86KjK4c/hOoW4/nXysFLAZ9ORh0pmxwcEqjtuEPisThLNpATw5cvs0Q3TRAIdPo+8UxfP7d3a7+7R2ZDMJPQl6slog3ZP56Ni5325wT6HFUDrYrSpTkbqjY/JhopLs48mNc6x0qhzHvkCr7bfNOYXkxiq/l1Z8PhoJZsfpioBC68Znv8fWaeWjzcHlOulYhOsg335Wh26u+bEvTKJkCKSUHb59Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5984.namprd11.prod.outlook.com (2603:10b6:510:1e3::15)
 by DM8PR11MB5704.namprd11.prod.outlook.com (2603:10b6:8:23::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6477.37; Thu, 15 Jun 2023 17:45:17 +0000
Received: from PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::ef38:9181:fb78:b528]) by PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::ef38:9181:fb78:b528%7]) with mapi id 15.20.6500.025; Thu, 15 Jun 2023
 17:45:17 +0000
Message-ID: <6a4d13f1-1607-659d-350a-a8694fdf485d@intel.com>
Date: Thu, 15 Jun 2023 10:45:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Betterbird/102.11.1
Subject: Re: [PATCH 4/4] dax: Cleanup extra dax_region references
To: Dan Williams <dan.j.williams@intel.com>, <nvdimm@lists.linux.dev>
CC: Ira Weiny <ira.weiny@intel.com>, <linux-cxl@vger.kernel.org>
References: <168577282846.1672036.13848242151310480001.stgit@dwillia2-xfh.jf.intel.com>
 <168577285161.1672036.8111253437794419696.stgit@dwillia2-xfh.jf.intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <168577285161.1672036.8111253437794419696.stgit@dwillia2-xfh.jf.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR10CA0005.namprd10.prod.outlook.com
 (2603:10b6:a03:255::10) To PH7PR11MB5984.namprd11.prod.outlook.com
 (2603:10b6:510:1e3::15)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5984:EE_|DM8PR11MB5704:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f95ab8f-d9ba-462f-abd7-08db6dc847e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ARXCj2fNcyVI4NCp2u9wcN0frzxXFDlX8Bqk2nY9gs9xZVt1rY/TbsTokHxTpDxFyEVWB8bKi/xYkEI43IRN//5OhXYOvl21ZHsXRA+0ru+YzEnSueBOsquQqW1BG+kTy8hiF+F7el99FSQJKR5+oAD5fHr9OShaIna92guT9W2DjUhDMBiAGUbx7sVMQiWjyb8NMEpUfVEcgZfONNuElnP1gf24CnODxM8xjwjpK9F41ZsVMqJ7Wzh2AsMrLvcV7xyV2MXO20Y2KVPcUAn/G2GM+tJmUl8uH3FylFqYL4gpEXXiX093FcB1UIc0U7444OzvI3Hzxt3GIfaZnMb2Vr9VE+ExWC7R0KDejMLkdWY0LMt7cZ0O0MXNJnQGMTwQACdNgHAaP1Egz8njTkqZ1sxC0+8LjF7543FJmjFJK7/v9C6ajYqQbUUNfk6O2LZ0ctKuTrf+921WX0lrmulTIJdCV1t5TvAY7f1OF3iE4eSbibXv02lp4kFbx8uxI6nHoIdL3Aof46kS6jgNppwX63/bAFQtTLq4SwxL7/VOH59teyB4Reb9LMEis0In/HTLdLv5x8joFVcHAiuQaHDz1ZRJ+NyEKEXV4tnL2iMYiFXfk1muIYtaIgR7ERkTPwKC4t8LwGIhModAgTyEXORcSQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5984.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(376002)(366004)(346002)(136003)(451199021)(8936002)(26005)(6486002)(8676002)(6512007)(41300700001)(82960400001)(478600001)(36756003)(66556008)(4326008)(86362001)(66946007)(66476007)(38100700002)(316002)(31696002)(6666004)(53546011)(6506007)(44832011)(83380400001)(5660300002)(186003)(2616005)(2906002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MG8wRU1aWksvR1NJbXBEUkJrWFV0N1FadTJJSWFMY0QrNCtGLzJXTk5TakhB?=
 =?utf-8?B?VHhUVWZwelVYcGxUQ0poRmtvUXdoZm5jd3lxTWxZYW1HeUY4ZFV1K2xuOUlN?=
 =?utf-8?B?cCt5S2JlamZCTzgzR2l0b1p4T09tL3lualE0RFVxM3JDZW54VGpXSEs1M3pY?=
 =?utf-8?B?VnYydE9tWE5EcTk4dDJESStmZ25rZG1nN0cvTGdIT0p2U3FQU1Yxem04ekpr?=
 =?utf-8?B?S09LdWxKSGhBSk5iK1FRTHA1Z2trNk54TnZpS3VabGZFcEszVU5VSHBKMkxG?=
 =?utf-8?B?MVlXZzRzT2dCNXFaWmdKV1hRclAxY1hKT3p4Nk5vVUtHZWdMTEVsNHdDaS8v?=
 =?utf-8?B?TkhQR2hZVlV1Ylp3Kys1cXdyUm5EMURLbnk5NzNMUllRQ2EySi9VS2c0YWxp?=
 =?utf-8?B?cUdOb1FRNVZjZTU1WEswT0tjeHhQV2kyam1mdENGV3F5L0laRHlONXc5MjB3?=
 =?utf-8?B?K2RSY01nMlhZV2MxUTBXazl5MjFaQjAxSFhtWSt2UHRRaWJaVS96R296ZzFu?=
 =?utf-8?B?YnZQTXl3QnhTNFRpSXM3TDdwMXdkTnMrdXVTWFVtWDJUVEg3RHVaV1BmMDV2?=
 =?utf-8?B?RnhCdy9ORnpLZ2FuWTdZSUxEakt6R002MnEwSWVTQVVhN1lCYkZTdmYvaDBp?=
 =?utf-8?B?TjNpbjJzVFJQc2xkcUZkU1FmMGxSV2RxQjFMQWlWTDJGTW1vRDlWZzhUVjlt?=
 =?utf-8?B?NXBLcjh4em8yY2s3WHlMdXRnUUwxMVMydzhGREp4MDV2VXlxdmxSSXZyQmVG?=
 =?utf-8?B?YXR4d0dRc1ovaFNsUDJmZi82ZW8rdm42M3lITkY1czJBdVd4SktkU2NybnBN?=
 =?utf-8?B?UWlncCtTNzlRMUFxZzNaaUJPUitDdmhIaW4xQzhxYlhUQk5xV1N0QkFPZVJ6?=
 =?utf-8?B?NWtkWWxNRStNc0E0a21EeGE5cm5HNzBtd3pSTUwrQk9mSGdpNWtWaGoyQjhZ?=
 =?utf-8?B?QzRPdGlBL3ZJbUdEcU5vandsRzdnR1VpdmRLRzhlNnZCWkRNU1NuK2NtTTFX?=
 =?utf-8?B?VmM1aXlWcVRKNHhhNWxOcVdLaW53ZG5NL2E1SklHRTE1eU5lZGlIbU5vM3Fs?=
 =?utf-8?B?QUx6N1AzdUJGQTcyMVo3UnNlcy9jRlZObVRMTmRORzd3YzUyeFZsOW9mQVhq?=
 =?utf-8?B?YzJYVWh2M3BOMUFsejJJeS8vOTdGZW5GNGs2cVhUNVVDOENPdGJUdm40YmlV?=
 =?utf-8?B?eS9acVNqdlZUNW9uVzhCbk9kRElsTWFRSXBUV0hGKzdXVTRzdWU0eDM2QVRx?=
 =?utf-8?B?WWJlUmkxbmtXdE5ZblczZWc1UGxWdEpYN05pYnFrVzA2Y2RwYzhncnVSQm1X?=
 =?utf-8?B?YU0xTnhWMlQ0TTd5SGZzQ3UvdDBDY0U1MzdMeUJPWTg5THNQa0R0VUVuYkpR?=
 =?utf-8?B?MmpEQTJLOW5TL0hvRHZRdldWZjBUNGZ3aGlSNEJWdWdEc3owK3NiSnBBYVd1?=
 =?utf-8?B?TXFyM0FXYzJtT0k2OFUrZFJiUlBrWXB3UVRJYXZZbzVRQm9mczJzWTMyd2pR?=
 =?utf-8?B?T0xhcDNwMGIzRmJFSWhZUUJ6cnJ1RDVQQ0FZMnlsOFhtZWpYOC9IcHRrYm1k?=
 =?utf-8?B?VHhaMVhCSldEKy83cEx6WWZvbHc5NGRQcHBXT212TWQ0REFSeHpEcTZCRWRn?=
 =?utf-8?B?TkkxSmFjeWZnNnZmU1c2MHhURHByVkRRb1duTXpiRzVMYnpMempIREIrZSsx?=
 =?utf-8?B?VHJUdXBRMFBSd1dmWWhnL2xFbm5FVjZ0OUNsYWtOWXBiMmJhNnRIQVFWMncz?=
 =?utf-8?B?VUFwdTZzMStGUUZ6eFhHdkNqYW4zSm0rejlRTHI3ZHBXamV1RU16Qkp5L0NV?=
 =?utf-8?B?S3V3WFNiZ3JmUFVOa2ppK2xETVdVUXJsUTVjVWZUQ3dDcmZyK2k0WnlJZGZi?=
 =?utf-8?B?cHE2NFo4Snp3SmhNV3hlWmJlR0dVTExxZEFkZ0x3TjZ5aHhHczdzeTZYRS9L?=
 =?utf-8?B?Qm5PZUF6eGdac1dWZjgrcTRHYjk4ZUFHUDhaczJVMDVCOGdpYjZHWEw2Q3pn?=
 =?utf-8?B?RUxsYTFQZlFKTUdFT0p6bmxqRGZwaTRCWE9zdlRwM2E1cTRHZDNzcFJETDJP?=
 =?utf-8?B?ekZ5TjdSZlFzK2lEeStWM084VUFhdm11NzFtMWR3U2I3RXlKTEFTTDBRTHVj?=
 =?utf-8?Q?wB2bU7aMiANChKsyDo3ufgJP8?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f95ab8f-d9ba-462f-abd7-08db6dc847e6
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5984.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 17:45:17.1965
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0D0NYSDrrC/Og7yPOx5uTK4u6f8cc41ppcKVYex8welkKulw9UN02RqCNoiYSuWX8SaOivOSpd+2sBzbSw8Xmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR11MB5704
X-OriginatorOrg: intel.com



On 6/2/23 23:14, Dan Williams wrote:
> Now that free_dev_dax_id() internally manages the references it needs
> the extra references taken by the dax_region drivers are not needed.
> 
> Reported-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
>   drivers/dax/bus.c       |    4 +---
>   drivers/dax/bus.h       |    1 -
>   drivers/dax/cxl.c       |    8 +-------
>   drivers/dax/hmem/hmem.c |    8 +-------
>   drivers/dax/pmem.c      |    7 +------
>   5 files changed, 4 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index a4cc3eca774f..0ee96e6fc426 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -454,11 +454,10 @@ static void dax_region_free(struct kref *kref)
>   	kfree(dax_region);
>   }
>   
> -void dax_region_put(struct dax_region *dax_region)
> +static void dax_region_put(struct dax_region *dax_region)
>   {
>   	kref_put(&dax_region->kref, dax_region_free);
>   }
> -EXPORT_SYMBOL_GPL(dax_region_put);
>   
>   /* a return value >= 0 indicates this invocation invalidated the id */
>   static int __free_dev_dax_id(struct dev_dax *dev_dax)
> @@ -641,7 +640,6 @@ struct dax_region *alloc_dax_region(struct device *parent, int region_id,
>   		return NULL;
>   	}
>   
> -	kref_get(&dax_region->kref);
>   	if (devm_add_action_or_reset(parent, dax_region_unregister, dax_region))
>   		return NULL;
>   	return dax_region;
> diff --git a/drivers/dax/bus.h b/drivers/dax/bus.h
> index 8cd79ab34292..bdbf719df5c5 100644
> --- a/drivers/dax/bus.h
> +++ b/drivers/dax/bus.h
> @@ -9,7 +9,6 @@ struct dev_dax;
>   struct resource;
>   struct dax_device;
>   struct dax_region;
> -void dax_region_put(struct dax_region *dax_region);
>   
>   /* dax bus specific ioresource flags */
>   #define IORESOURCE_DAX_STATIC BIT(0)
> diff --git a/drivers/dax/cxl.c b/drivers/dax/cxl.c
> index ccdf8de85bd5..8bc9d04034d6 100644
> --- a/drivers/dax/cxl.c
> +++ b/drivers/dax/cxl.c
> @@ -13,7 +13,6 @@ static int cxl_dax_region_probe(struct device *dev)
>   	struct cxl_region *cxlr = cxlr_dax->cxlr;
>   	struct dax_region *dax_region;
>   	struct dev_dax_data data;
> -	struct dev_dax *dev_dax;
>   
>   	if (nid == NUMA_NO_NODE)
>   		nid = memory_add_physaddr_to_nid(cxlr_dax->hpa_range.start);
> @@ -28,13 +27,8 @@ static int cxl_dax_region_probe(struct device *dev)
>   		.id = -1,
>   		.size = range_len(&cxlr_dax->hpa_range),
>   	};
> -	dev_dax = devm_create_dev_dax(&data);
> -	if (IS_ERR(dev_dax))
> -		return PTR_ERR(dev_dax);
>   
> -	/* child dev_dax instances now own the lifetime of the dax_region */
> -	dax_region_put(dax_region);
> -	return 0;
> +	return PTR_ERR_OR_ZERO(devm_create_dev_dax(&data));
>   }
>   
>   static struct cxl_driver cxl_dax_region_driver = {
> diff --git a/drivers/dax/hmem/hmem.c b/drivers/dax/hmem/hmem.c
> index e5fe8b39fb94..5d2ddef0f8f5 100644
> --- a/drivers/dax/hmem/hmem.c
> +++ b/drivers/dax/hmem/hmem.c
> @@ -16,7 +16,6 @@ static int dax_hmem_probe(struct platform_device *pdev)
>   	struct dax_region *dax_region;
>   	struct memregion_info *mri;
>   	struct dev_dax_data data;
> -	struct dev_dax *dev_dax;
>   
>   	/*
>   	 * @region_idle == true indicates that an administrative agent
> @@ -38,13 +37,8 @@ static int dax_hmem_probe(struct platform_device *pdev)
>   		.id = -1,
>   		.size = region_idle ? 0 : range_len(&mri->range),
>   	};
> -	dev_dax = devm_create_dev_dax(&data);
> -	if (IS_ERR(dev_dax))
> -		return PTR_ERR(dev_dax);
>   
> -	/* child dev_dax instances now own the lifetime of the dax_region */
> -	dax_region_put(dax_region);
> -	return 0;
> +	return PTR_ERR_OR_ZERO(devm_create_dev_dax(&data));
>   }
>   
>   static struct platform_driver dax_hmem_driver = {
> diff --git a/drivers/dax/pmem.c b/drivers/dax/pmem.c
> index f050ea78bb83..ae0cb113a5d3 100644
> --- a/drivers/dax/pmem.c
> +++ b/drivers/dax/pmem.c
> @@ -13,7 +13,6 @@ static struct dev_dax *__dax_pmem_probe(struct device *dev)
>   	int rc, id, region_id;
>   	resource_size_t offset;
>   	struct nd_pfn_sb *pfn_sb;
> -	struct dev_dax *dev_dax;
>   	struct dev_dax_data data;
>   	struct nd_namespace_io *nsio;
>   	struct dax_region *dax_region;
> @@ -65,12 +64,8 @@ static struct dev_dax *__dax_pmem_probe(struct device *dev)
>   		.pgmap = &pgmap,
>   		.size = range_len(&range),
>   	};
> -	dev_dax = devm_create_dev_dax(&data);
>   
> -	/* child dev_dax instances now own the lifetime of the dax_region */
> -	dax_region_put(dax_region);
> -
> -	return dev_dax;
> +	return devm_create_dev_dax(&data);
>   }
>   
>   static int dax_pmem_probe(struct device *dev)
> 
> 
