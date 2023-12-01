Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 801ED22080
	for <nvdimm@lists.linux.dev>; Fri,  1 Dec 2023 17:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NDWG6df+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701452358; x=1732988358;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5zq8S/HH3EexsGk9cNpd8WPuGZglX9MAqa15AaX4Y6g=;
  b=NDWG6df+YfgXokBSmhcYoaSSnpduwm0yaF1MC/EKEBLqQs0Abu9plzWA
   8L2zzPyKo6RxrtotemLR+fhqXjsYYQ9VUvSPPUwRbQurmX2iM7bSIkL+n
   CZxXQgUIdZP0MqB05ezuxIGOiaV6K/74QoqIGzREdAWoN8UqSlxxnFYyn
   MPOFlIGjtYxY4LoZwP1BbzUp/xUcnmw4AOxOnyQtpgcH9LwBkDJzv962B
   /wuuC6rQJ4uZ5njEy3qvRxixChNyNSiG4Bnz/7YdXkcuzIqcwtfKYHjC5
   5ISFa5Lz4m2AXLf8TwGNi/plLwehAhBMRq5A4Q/mcO0L2pkXnmJMzI9Qu
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10911"; a="12240988"
X-IronPort-AV: E=Sophos;i="6.04,242,1695711600"; 
   d="scan'208";a="12240988"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2023 09:39:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10911"; a="1017101355"
X-IronPort-AV: E=Sophos;i="6.04,242,1695711600"; 
   d="scan'208";a="1017101355"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Dec 2023 09:39:17 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Fri, 1 Dec 2023 09:39:16 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Fri, 1 Dec 2023 09:39:16 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Fri, 1 Dec 2023 09:39:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N5roOIIEDj2Kg7zDyQbFjHI/jAt6KJswXLhyi+Ikg30wb7fV+qzcUWqr7NtMZ8AIMcRD6B6JjZR7JCKQyCzA/aIccJh4x7YlhtBkuhqWraU9ZLwhWUJEti3AQOQyu8MDWLnThQvQaGaUpaSnp4MhMeBY2FjgsLOMNEehZPeQY/BqWi5sFBsHtkLm/GsLZvwng4VZWj947jvTaM9O0drVkPSop7DP728GYYeSbRm+4wesDqxzdeP2190IZBAWjLHTk5ke8/3BTWRQ2SdyyjnGHlQ5pwpnAt8n6Wq8EFh1qQZaVQfAsZtx3VMR7xPCZV7BjatUKqHBo9T7wN2/A+ihcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1UgFexC1kEjNvXVhicuA+/8ubXgvxhX2Iu7PnqHj4ss=;
 b=g+LHdhQo2AW7OXeTJ5Id3aFKzX1uvVKt0HXwTnG80vZdWy5INFlh7orIEuzcTUfWKiLGiAbi/TsNCsH/RtF2Dqtb5BDI4GuDOx4wswzQSwMO6eZgQUPjE1rdG+fyoq83uJXDm2hvqsbB3ZaPxnSKPMdfyeCQqZsx8dkqve51cgwfjv+T8v1L6gpZXdyNrchgLKQZ01uJvTJhOM5AfkYf2aLdImzqALbHNZSqGNKziosVZQeP/js1yft2DgU9pDujuq0wYwIf+hyvjIjvLf7Nv/LRe7gdIq0ypAgQ0PmKqHcigDMMikF5W8U7hLXEYWHRAbIH2q6E6ko/mppPY65FCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5984.namprd11.prod.outlook.com (2603:10b6:510:1e3::15)
 by SJ0PR11MB5937.namprd11.prod.outlook.com (2603:10b6:a03:42c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.27; Fri, 1 Dec
 2023 17:39:14 +0000
Received: from PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::6f7b:337d:383c:7ad1]) by PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::6f7b:337d:383c:7ad1%4]) with mapi id 15.20.7046.024; Fri, 1 Dec 2023
 17:39:14 +0000
Message-ID: <4977047b-efd3-4237-8107-4beed0041f03@intel.com>
Date: Fri, 1 Dec 2023 10:39:11 -0700
User-Agent: Betterbird (Linux)
Subject: Re: [PATCH ndctl RESEND 2/2] cxl/region: Fix memory device teardown
 in disable-region
To: Ira Weiny <ira.weiny@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
CC: Dan Williams <dan.j.williams@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>
References: <20231130-fix-region-destroy-v1-0-7f916d2bd379@intel.com>
 <20231130-fix-region-destroy-v1-2-7f916d2bd379@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20231130-fix-region-destroy-v1-2-7f916d2bd379@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR03CA0001.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::14) To PH7PR11MB5984.namprd11.prod.outlook.com
 (2603:10b6:510:1e3::15)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5984:EE_|SJ0PR11MB5937:EE_
X-MS-Office365-Filtering-Correlation-Id: 7bf5fb7f-ff7f-43ee-5d42-08dbf2946f72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: scU0YKau6Zm1fzr98adD551ppxIwTtrc24f0K4js1FVQhbPS/zh09/Ii1cacWKOwImgZMwIZjN+UQYF+OHDB3dfmPzQJncV5c7G737ipqlW3uEGl/l2l70Kzx6HmA5iLknYKQnQryHndkWQF0P4K2qto3wDL9O3fHOSGaCZLmckwOGFqIaGU3KpxTeV84ph6QhbNjyNipdbRON2w/M/HHjNLglTl1IKlwIiQu5VtrxYaRXyQNuLupkXoTVvn2vMDRJ/ohhfWNjSuNXtz15c835haLmtKjC+54dfhZDxVLm/i+vU1YxFMaBHnA4FHyAojPZNLD8cEdlYpXXFc0/Dl+bWT9Ai7K+6xmir/oZAMCbS1mXxb9Q6iasHMpcIbTa75GbC5kcdliEnhAiwkVw7KyTES7DKzU2TOqrB6Pc/5A59qt9XjYe34MIMGKOk10xXmbny2RCnRurafLMvuLIESr8zjcbmFRK/KDbpP5A8IC0Ykjpy2k3tYSt1rVn8rUo6VZeTvoWyu6BJPt2cyEO2/7WXNlRNoDwjLKa/r/w2xzuF04f77q3qbgr1JM/AOmzBYTTKKFECAwOr9Q4vcmiD5uEBj3z4yAUNr1v3TJVri6uJMrY1Ifuk2TOyC1uyjZSZO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5984.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(39860400002)(376002)(366004)(136003)(346002)(230922051799003)(186009)(64100799003)(1800799012)(451199024)(83380400001)(38100700002)(82960400001)(86362001)(31696002)(36756003)(66946007)(66476007)(6636002)(316002)(110136005)(8676002)(4326008)(8936002)(5660300002)(2906002)(66556008)(31686004)(44832011)(2616005)(6512007)(26005)(41300700001)(6666004)(6486002)(478600001)(53546011)(6506007)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QjZ5Vy9nZmFDMHh0aTByK0lranp0M2s2NWxSRHdRK01jU2c0cXNDaXpRRGpK?=
 =?utf-8?B?VVp4d3NIM0ljNEd5UzZ2OFVCYTBHV2VnODdIL1gyUGxKY0NFbTBGcktYbmFI?=
 =?utf-8?B?ak9yUHZBRVcyUXdtRnlZWkI4WWNSelRqTnErTThXZW9uaFlySm1tV0N5emx6?=
 =?utf-8?B?ay93MG82OVpabzNncDcxZ2ExMDR2TEJPRk80N0JITXZma05lblYzQmI0bmlV?=
 =?utf-8?B?NjI2Q3phN3B0akhzZWp0WnU3Zjkxb2xIWnBNR0dGbEtrbDA0OGttbW56L0Z1?=
 =?utf-8?B?OTlidC9VdWt6ZUkycWFIRHUvOUpzdUt1M2RXOHIvWU1EUDBpY05ac3FSYURs?=
 =?utf-8?B?WTdjSXByWEhINndmQmtQbGYzSkhFS0czUERjZ0M5SHhoM01pNzczRXNUaVV0?=
 =?utf-8?B?NnkzelduZDdVdjhoaS81enNlUCtsNks5MUQ4alpTaTBnVEZDZnlFV3pCSEEz?=
 =?utf-8?B?cjhyWWxRa1pUSlcyNVRZWkoydXpzd011cXFwcTYrN2hlcTVSbW9HT29KcWJH?=
 =?utf-8?B?ajdGVUlOR2N2T1ZjQW1aVytWVEVTK0VlSFBmWktEVlAzN29WeERFZTRMbWR0?=
 =?utf-8?B?Mk03Zmp0dlYyQXI5TzBueWdzWU1SMSthRzhZS3p2NTQ2UmVqcFBIMVVOY3Za?=
 =?utf-8?B?QTh6R2N3OXVmUzhaYU02MkRETU5kY2ZXaGFhV3F2dUEzSnBQSmxzNTBOQy92?=
 =?utf-8?B?WGhaVUFUQ1pCR2ZQbi9LNExzVlRZcFlEbmFSdllqK3NPRThrN2ovd3hQUENM?=
 =?utf-8?B?WGh1N3FTYUpqM2E0WGRjREpkb21JbjZQcVRmSFpyVDBLZzB6K3kxSjNtaUVT?=
 =?utf-8?B?cXl4MUJneWxQQjVEVGtWQzdTWmppbzllSW9KbjJuM2Q1c2x2ZUxlTkpqcHpW?=
 =?utf-8?B?SVF3ZDdjeVljcS9meWtGZkx1djg2cFArdStMKzIzUFlkTmJXSmFqeElPY1NK?=
 =?utf-8?B?eDNmWUhSZHVMa0lxS0FlMGN4aW5nRndSTDJqcFpFait2anlpSk4xTGVtNWJm?=
 =?utf-8?B?MXA2dkYyMUxZcXpjd2MzTGN6cGl2VklUWEszeitOQlVmTUYzTC8yN2x1UGVR?=
 =?utf-8?B?YkdmUDZLQ0l6ZHBHZEsrRytRK1F4eWppN01KbDQyRVp6am1HcEVlUjUzT0ZO?=
 =?utf-8?B?Q3hkaU9yemNzM1lFV0I4aG56TnprSHlNQ2VQMEJjbGllbElkclMwSnJJV3ZO?=
 =?utf-8?B?S1hlNGhCclZpNGNVa3dKQnM1TitNQWJsdlQ2dGo3NzZuV0g3VkFnOGw5dFl1?=
 =?utf-8?B?L01uSE41bXozNnBWSmpWSkRXM2NlaGhZbDdqdFN1dXFscG9LbnQ1RGx5eFU0?=
 =?utf-8?B?U0pYMzd6VFN0ZFVyS2QxazZmRDQvMjRLT0FqU0dDRjZEdjJraGE4dUE0WUhD?=
 =?utf-8?B?SFUrRkNNZitNS3hGbkIyQUp2VTRiejRRYzdOUzV6SVBiWlZ2Z1hYSGZsVkI1?=
 =?utf-8?B?QURvc2x4cnA5ODNNSlg0THJzbkdqQ0I5YXdWRGMrT1Y3eUdUUjZhSEFiSzJC?=
 =?utf-8?B?c3hlU0RGMjcwVWEzVU1zSUlySzF5V0VwR1VQQTZQazRMWGE1NHA5SkE3ZHZ2?=
 =?utf-8?B?YXhnalRIOUZoVTEwaWZHTzlsbWo4bU9BOTF2U2VyYUhWb1BocXY5ZERNd2pa?=
 =?utf-8?B?a2UrNVpUcEpGU3I5LzA3VWl0UVgxY1lGTzlWelUybE1ZOHFYV1Rvd21PWHhT?=
 =?utf-8?B?OEl5S3QvUGI5MWx1ejNsblo1blJKSFNXL1JxeUVDYWFzK1FrK08zWVM0V3JW?=
 =?utf-8?B?NnhkNWcvdjBDdWdWejNPSVdkNGEvbHIrb3dudDJjdXExbGRGOHdwdlRoQmtL?=
 =?utf-8?B?a09jajN1LzZkUURuaDBjY3h1dEpFS20zNUxXUE8yY3pIeG43djFvQlU1UG1Z?=
 =?utf-8?B?TDU2cmIzcVdxTlZjY3NIcXJkNnNjbHNQb3h4dmFLMU5ML0hxak0wU0txY3dB?=
 =?utf-8?B?OWY3T3VEdHFyQnZIVVd3dWRWQ1BVZFVEUkhQaXd0dmlqSWR6dmNPY2FxVmE5?=
 =?utf-8?B?bllhc0owNXo3RnhhNFd0Qi8vTTF1MmpFeFdKcjRpNDAzOWVkSGNPNW5hY01m?=
 =?utf-8?B?cCtWYndHdDdxZVJpbjM2SUZvTVBSSVMyTkFodkhvdm10RnRBWmtZbDVORmQ5?=
 =?utf-8?Q?rk3WnKbqmVqcjQ+WddI+C/Zkf?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bf5fb7f-ff7f-43ee-5d42-08dbf2946f72
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5984.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2023 17:39:14.3930
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cM9nzoW49IUsoOPevijYB8eYqQLeMobnJO32+gtQddlk8NZSb6j6+XeEmyR2zrmaPuYNSQsGHGScD4eUSxlD3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5937
X-OriginatorOrg: intel.com



On 11/30/23 21:06, Ira Weiny wrote:
> When a region is requested to be disabled, memory devices are normally
> automatically torn down.  Commit 9399aa667ab0 prevents tear down if
> memory is online without a force flag.  However, daxctl_dev_get_memory()
> may return NULL if the memory device in question is not system-ram
> capable as is the case for a region with only devdax devices.  Such
> devices do not need to be off-lined explicitly.
> 
> Skip non-system-ram devices rather than error the operation.
> 
> Fixes: 9399aa667ab0 ("cxl/region: Add -f option for disable-region")
> Cc: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  cxl/region.c             | 3 +++
>  daxctl/lib/libdaxctl.c   | 4 ++--
>  daxctl/lib/libdaxctl.sym | 5 +++++
>  daxctl/libdaxctl.h       | 1 +
>  4 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/cxl/region.c b/cxl/region.c
> index 5cbbf2749e2d..44ac76b001e9 100644
> --- a/cxl/region.c
> +++ b/cxl/region.c
> @@ -805,6 +805,9 @@ static int disable_region(struct cxl_region *region)
>  		goto out;
>  
>  	daxctl_dev_foreach(dax_region, dev) {
> +		if (!daxctl_dev_is_system_ram_capable(dev))
> +			continue;
> +
>  		mem = daxctl_dev_get_memory(dev);
>  		if (!mem)
>  			return -ENXIO;
> diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
> index 4f9aba0b09f2..9fbefe2e8329 100644
> --- a/daxctl/lib/libdaxctl.c
> +++ b/daxctl/lib/libdaxctl.c
> @@ -385,7 +385,7 @@ static bool device_model_is_dax_bus(struct daxctl_dev *dev)
>  	return false;
>  }
>  
> -static int dev_is_system_ram_capable(struct daxctl_dev *dev)
> +DAXCTL_EXPORT int daxctl_dev_is_system_ram_capable(struct daxctl_dev *dev)
>  {
>  	const char *devname = daxctl_dev_get_devname(dev);
>  	struct daxctl_ctx *ctx = daxctl_dev_get_ctx(dev);
> @@ -432,7 +432,7 @@ static struct daxctl_memory *daxctl_dev_alloc_mem(struct daxctl_dev *dev)
>  	char buf[SYSFS_ATTR_SIZE];
>  	int node_num;
>  
> -	if (!dev_is_system_ram_capable(dev))
> +	if (!daxctl_dev_is_system_ram_capable(dev))
>  		return NULL;
>  
>  	mem = calloc(1, sizeof(*mem));
> diff --git a/daxctl/lib/libdaxctl.sym b/daxctl/lib/libdaxctl.sym
> index fe68fd0a9cde..309881196c86 100644
> --- a/daxctl/lib/libdaxctl.sym
> +++ b/daxctl/lib/libdaxctl.sym
> @@ -99,3 +99,8 @@ global:
>  	daxctl_set_config_path;
>  	daxctl_get_config_path;
>  } LIBDAXCTL_8;
> +
> +LIBDAXCTL_10 {
> +global:
> +	daxctl_dev_is_system_ram_capable;
> +} LIBDAXCTL_9;
> diff --git a/daxctl/libdaxctl.h b/daxctl/libdaxctl.h
> index 6876037a9427..53c6bbdae5c3 100644
> --- a/daxctl/libdaxctl.h
> +++ b/daxctl/libdaxctl.h
> @@ -77,6 +77,7 @@ int daxctl_dev_will_auto_online_memory(struct daxctl_dev *dev);
>  int daxctl_dev_has_online_memory(struct daxctl_dev *dev);
>  
>  struct daxctl_memory;
> +int daxctl_dev_is_system_ram_capable(struct daxctl_dev *dev);
>  struct daxctl_memory *daxctl_dev_get_memory(struct daxctl_dev *dev);
>  struct daxctl_dev *daxctl_memory_get_dev(struct daxctl_memory *mem);
>  const char *daxctl_memory_get_node_path(struct daxctl_memory *mem);
> 
