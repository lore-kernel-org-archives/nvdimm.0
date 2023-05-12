Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF29200AC
	for <nvdimm@lists.linux.dev>; Fri, 12 May 2023 17:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683911687; x=1715447687;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=1EdFDrZpNuA5mUYIMC0sMyv/ZvVuGoD+KGy4yjt/qfo=;
  b=clafxOxWOqN9jrFesYERDVJI0zhDz5EjR5WK9D46tV9TewIKBTIN7CjX
   yNzGCQVHSRWxVQdoRwaRqsiWOczVDaSCfxuT5usSsfcquHMgzKoxDPKgV
   cD9rg3MGCj0NyRakAz8EHvrmAZKtYY63+bRsd5H+2MmTCxfiLTD5RzT98
   C/SWTk1cLG5Ocym5gU0ismibiUwphKmeJX3qXY6sDJ8ehVJtLggf6VZyN
   jRU3ct1LqKnoVqDej3R/EvFA7dlzvP9JoTL5FbTEV7ZMJTNBTfOpfNayV
   8/If3seYjr27yb3FaAuTKn5YfJhq34YXwdej+xI4+aS/+1sspo5cpUlP2
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="353091105"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="353091105"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2023 10:14:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="730877406"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="730877406"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 12 May 2023 10:14:46 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 12 May 2023 10:14:46 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 12 May 2023 10:14:46 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 12 May 2023 10:14:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HG4Ayf6ZjcAgCT8eF1AJnGM2t3Tz7kKVvpJqDalswZFVNVGCvoYtTQX0FHSarSQYICiZXFKGgOwhf+lZm3KS2vcbI9cRMPKWAMJ2lsmpkA8yI2BDccXNEHfHogm8d/AGEdfcbkPqC/cJDbfQo0Kl0Pu4Mx6CsyhBbXpEB2+QffyX8VTzmg0lt2aDygioxpG1BsCl0EAq/5KbJV4/GYkQEjlCNE8aZsxnImWb5CYZTRdxxq/Z6QVmoCsIllXhXdPIBEAk6pb6ZkLXKnZh5tRDCd3XGyPnEH1PJ9uD8pyLx9rYO/GU68ZYyBh1bRCqgDWMr/uhp3jxU0hOSrMkIS7fZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mle/f6tB/+u8rm/AUhKCexig11EHK1s39o50o+sUUDE=;
 b=NwUiiX310KhzgEw1a/Bv/eO6crYEL63xByiD87oV0Ds1/AutOB3YMQw5CNKlOAGl2mY/bz6geuh5J9MZhnlQYjNWF7qeYKPllx3F5ChvjKpQ5HN4ZbMSFCl0AlnhxyKLNS6XRu5gmmvYF0ESfjO3q8fciGy6VNLE/S4XQnvQln+aO6xw3Sm0v3vRAqW7eSnLQMI9avlBw2iSJjqbaCewD2PevEekQMd2om6FRofN6+jWVkwaq4VpgZAW7wh2mt6WxBnpOgLqDEh3mPn8/2qW7X6oEevT3qTsxhEsviBk2th4W4CU0wZB/3VPeJRVLKdjgERNjwGLn0f25GHyDvscoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by LV8PR11MB8557.namprd11.prod.outlook.com (2603:10b6:408:1e8::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.22; Fri, 12 May
 2023 17:14:43 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::4fe2:e207:596b:d145]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::4fe2:e207:596b:d145%5]) with mapi id 15.20.6387.020; Fri, 12 May 2023
 17:14:43 +0000
Date: Fri, 12 May 2023 10:14:38 -0700
From: Ira Weiny <ira.weiny@intel.com>
To: Chaitanya Kulkarni <kch@nvidia.com>, <dan.j.williams@intel.com>,
	<vishal.l.verma@intel.com>, <dave.jiang@intel.com>, <ira.weiny@intel.com>
CC: <nvdimm@lists.linux.dev>, Chaitanya Kulkarni <kch@nvidia.com>
Subject: Re: [PATCH 1/1] pmem: allow user to set QUEUE_FLAG_NOWAIT
Message-ID: <645e73feb7ff6_aee562944d@iweiny-mobl.notmuch>
References: <20230512104302.8527-1-kch@nvidia.com>
 <20230512104302.8527-2-kch@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230512104302.8527-2-kch@nvidia.com>
X-ClientProxiedBy: SJ0PR03CA0260.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::25) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|LV8PR11MB8557:EE_
X-MS-Office365-Filtering-Correlation-Id: 4de79fbd-a054-47f5-b6cb-08db530c60a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DJ2KNAykteIC2jF3JpkDqDpGPI6lzucgLQEePEknhPrwqeQGnXDgs74Nz8q6+VNtcjdlKCyQBhHy3K1fZzfi71GtodLMKoRBgtvyc3blP0baKuzbrEpewkmv5YeB6Se54u0PsBGO92fN4zupywXXAYMb6hFhsstH815sfcR8+rB8t1QqZKNjmKaYI2M0mQSO5muqgOmJBpX7a0NkKSAZDNDj+f6VaPwFwDYWSZ+4/x7Hx2CPwIn0ojHwSlEihFNTa3yEPzIg8xQrK0Z8mosiOmzCxh4A1cselpSiUMhB6+wwSfS3gWk3ElgeeecGkFYUZx1vUZKAg0Af7vmTcyG7zl2fCdcdzUg0b+oVeR4UVlHR6bwk7Q8XOA0R00wKUuMqNQc+xEaegw4ab0yVBcS004iYeeAS7CVbs3ZCVAMd0pqXucAid3akc6nwRjAUabB9958OlOy3CS03b8wS/vSZDHmKYatAK0N7Ta3RHuIdSOzBeImvO4Rh15kCsbTXolCjYilJmFFeu8V+1URCxlOtZG8nffiHyJiuFWh0U+YRgyop/mDlFkp/07SK+/UmBiIr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(136003)(346002)(366004)(396003)(451199021)(9686003)(186003)(8936002)(478600001)(6512007)(6506007)(26005)(83380400001)(2906002)(82960400001)(44832011)(38100700002)(5660300002)(86362001)(8676002)(6486002)(6666004)(316002)(41300700001)(66476007)(66946007)(4326008)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?g9JQL06ZCTQ5DOJkjUc5mkpYvMGYbIycS+knTP8knEqlxm94D3oJYnkAG3Z9?=
 =?us-ascii?Q?6CrSh84DWDqQuw5myiDANwztpalPO4zozl9QJwmHQ/2EYk1HpAIO84/1kioz?=
 =?us-ascii?Q?hJTnh3Riq2h1/lNpqSdeB+rN8K7FVp8a8wqmZk98nu8Hs8XS6uf7iK9rWDNN?=
 =?us-ascii?Q?USmlk7F0sg4qJhScjVE3tH5CAtstXlB++mafWQNJDMjYSWkvDLTq6MSpLxru?=
 =?us-ascii?Q?OiOhrzqbGINYND0oOndcb3vEJ9+QUjsfKrLkjS2F4MGUapvZhVzUikVjxQbI?=
 =?us-ascii?Q?YYhz3rNbxVmpTsf3qZKyLegEy+2h0Banp2U8dgJTgsHOylLCI0PdpHCrq9w8?=
 =?us-ascii?Q?9Ofpwpq+0ukfbU5G4F4m/YW5U4z6xaSBdk5wtCZ7ZH8Wg5lenSPnwgvflh1w?=
 =?us-ascii?Q?skPJZb0rP7UEhxF6VZncHc8fYjlB32gZlOBhrD7Ka1WZ7KZk5aU5SU770Tke?=
 =?us-ascii?Q?8Zk0NjIr8msDt+sBpCVtb/kMmiLRAeczNO+TLlY62nZeAb6WEB2hF2uH5jU2?=
 =?us-ascii?Q?2aN1JkeOg9JFsV9dxWNPL36i+uMVD4gI06/F1eK6UyhFb9KvFKabHj47GVHy?=
 =?us-ascii?Q?Rw3pYSrpfNKcyaMM2HAhqqstPICVzyqxGDsJ7eT6lJX08tzopObynAA4Qo8k?=
 =?us-ascii?Q?BV2hNugM/CPb5noUWMxrruxFSpILj5t1wmntHETpeKhuMsiL77MAR2q3EdLI?=
 =?us-ascii?Q?elu+jtKuU8i6ybJtkLyEszgIxc3sS1+IE4YxLijHGVpmnx84Zr/dXh6K9UYg?=
 =?us-ascii?Q?F/Pyou6ZhXmlItZmtVPmZKTpCdUv2EKfbPSsMF8WnCoBGdGIeoAkYdwhaRHE?=
 =?us-ascii?Q?J6sTH7grgqb9gupTHXxahtr38F5XXb18FXBppsC+Y6sA1qv1Pz6MleG1hWyT?=
 =?us-ascii?Q?LELSkjJateJENxib8wxRX3KXzn0wSrcpPAHKCxS+ObNnvRpH3r2k+BAeKlhR?=
 =?us-ascii?Q?ppvAv/2ptg/A3s9Eu9+OpCvCEwA5qcI+85L9XMvgpAUQMTHz54p/+6XUj2He?=
 =?us-ascii?Q?WPVZIyOIj2azLUgLBDV1RV81qs537koWtbns+cH/FQFNkAC4xmcHJ4hX/MUl?=
 =?us-ascii?Q?Dx+KU6oRT8xCcozFqJWH8OOQ54nBhxZKLY5/4iZBnnQGT5yisih7gH0aniZu?=
 =?us-ascii?Q?ouhUT9DEe0glrWI6HIfBJuzt7Vez3Pj6gm6cXVXG2CBg2Xc3ylNEsK+9Lrye?=
 =?us-ascii?Q?v7RRPTVNBGNrsr5DYeePiHTjqeyAefn240Jjpj686tCKLoszF4a6EXbtGIte?=
 =?us-ascii?Q?edopLOm4l5PBx4GMCb2/kJPF44yzUzMU63RQzfW8EsOsYLmI+4rSF8pAhadf?=
 =?us-ascii?Q?0DktrYkTkluXcTGRXU17zh1/afXsvKokOLaKzGx1ykMLt2pM9mlxIQ7sGP8z?=
 =?us-ascii?Q?ljc26/8aLmIYUWUWiIKcQxL+g6rMM0m0AAILJxZrnGq5cpimpV43rLLoWkOQ?=
 =?us-ascii?Q?FosV/BYpshUY8LeraijIK5e+RTtNzVr89tcbgGs0Cnsc6TqOJ2b3a7nMYVE5?=
 =?us-ascii?Q?4XL7fTMduQFxzUyzCTi7zcRtyEGDxplrAce9H2fU3hQ42SpLkIhmNjnGR+Pq?=
 =?us-ascii?Q?5KtY7nDJqzQxshEH2Mk+oqILkJm99vDzrkdDxeY9?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4de79fbd-a054-47f5-b6cb-08db530c60a7
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2023 17:14:43.4578
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m66R1iZsY3U3GnOYzzf4asK4tM9w4nZPDdoW0wDgfqa+d6HAsNp/A6F4BgYtxiQmziapm/p8R6HOLgeCL03GTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8557
X-OriginatorOrg: intel.com

Chaitanya Kulkarni wrote:
> Allow user to set the QUEUE_FLAG_NOWAIT optionally using module
> parameter to retain the default behaviour. Also, update respective
> allocation flags in the write path. Following are the performance
> numbers with io_uring fio engine for random read, note that device has
> been populated fully with randwrite workload before taking these
> numbers :-

I'm not seeing any comparison with/without the option you propose?  I
assume there is some performance improvement you are trying to show?

> 
> * linux-block (for-next) # grep IOPS  pmem*fio | column -t
> 
> nowait-off-1.fio:  read:  IOPS=3968k,  BW=15.1GiB/s
> nowait-off-2.fio:  read:  IOPS=4084k,  BW=15.6GiB/s
> nowait-off-3.fio:  read:  IOPS=3995k,  BW=15.2GiB/s
> 
> nowait-on-1.fio:   read:  IOPS=5909k,  BW=22.5GiB/s
> nowait-on-2.fio:   read:  IOPS=5997k,  BW=22.9GiB/s
> nowait-on-3.fio:   read:  IOPS=6006k,  BW=22.9GiB/s
> 
> * linux-block (for-next) # grep cpu  pmem*fio | column -t
> 
> nowait-off-1.fio:  cpu  :  usr=6.38%,   sys=31.37%,  ctx=220427659
> nowait-off-2.fio:  cpu  :  usr=6.19%,   sys=31.45%,  ctx=229825635
> nowait-off-3.fio:  cpu  :  usr=6.17%,   sys=31.22%,  ctx=221896158
> 
> nowait-on-1.fio:  cpu  :  usr=10.56%,  sys=87.82%,  ctx=24730   
> nowait-on-2.fio:  cpu  :  usr=9.92%,   sys=88.36%,  ctx=23427   
> nowait-on-3.fio:  cpu  :  usr=9.85%,   sys=89.04%,  ctx=23237   
> 
> * linux-block (for-next) # grep slat  pmem*fio | column -t
> nowait-off-1.fio:  slat  (nsec):  min=431,   max=50423k,  avg=9424.06
> nowait-off-2.fio:  slat  (nsec):  min=420,   max=35992k,  avg=9193.94
> nowait-off-3.fio:  slat  (nsec):  min=430,   max=40737k,  avg=9244.24
> 
> nowait-on-1.fio:   slat  (nsec):  min=1232,  max=40098k,  avg=7518.60
> nowait-on-2.fio:   slat  (nsec):  min=1303,  max=52107k,  avg=7423.37
> nowait-on-3.fio:   slat  (nsec):  min=1123,  max=40193k,  avg=7409.08
> 
> Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
> ---
>  drivers/nvdimm/pmem.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index ceea55f621cc..38defe84de4c 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -31,6 +31,10 @@
>  #include "pfn.h"
>  #include "nd.h"
>  
> +static bool g_nowait;
> +module_param_named(nowait, g_nowait, bool, 0444);
> +MODULE_PARM_DESC(nowait, "set QUEUE_FLAG_NOWAIT. Default: False");

Module parameters should be avoided.  Since I'm not clear on the
performance benefit I can't comment on alternatives.  But I strongly
suspect that this choice is not going to be desired for all devices
always.

Ira

> +
>  static struct device *to_dev(struct pmem_device *pmem)
>  {
>  	/*
> @@ -543,6 +547,8 @@ static int pmem_attach_disk(struct device *dev,
>  	blk_queue_max_hw_sectors(q, UINT_MAX);
>  	blk_queue_flag_set(QUEUE_FLAG_NONROT, q);
>  	blk_queue_flag_set(QUEUE_FLAG_SYNCHRONOUS, q);
> +	if (g_nowait)
> +		blk_queue_flag_set(QUEUE_FLAG_NOWAIT, q);
>  	if (pmem->pfn_flags & PFN_MAP)
>  		blk_queue_flag_set(QUEUE_FLAG_DAX, q);
>  
> -- 
> 2.40.0
> 


