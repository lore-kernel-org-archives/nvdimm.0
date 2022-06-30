Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D606EBE
	for <nvdimm@lists.linux.dev>; Thu, 30 Jun 2022 22:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656628344; x=1688164344;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=S/iXc2xnHnIH4qQXOhFzA+d6wGIXPn+W2b7e6wIYTbk=;
  b=kMJLuOUvirjuarE90DgarPR1NVUnt7I/vcavLmiCJ0nRQ7zIeTdUdWgF
   vqXBWLOysAGWovxQaaludzxa82GqabK79I+8p+whzUpagOQV30V3wQ7RU
   dQEXVudLAqdgGAD7ti1Pm5kZ+owelm6TtfGM9TOJgKIhDGG2GqXF1rGGL
   T7MZxkpuIwtEN3ixZK/VF8kKtJ5p1CDlaXiZxDw8YXs7HDiJa94yuDDhw
   PuQx10SvzVcxZ81Lzc0sowKeosIqjKnZM2IqRIEA7cJ/pQBRAwT3pDg8e
   NhmxARSy1zUZC2F3VLZpzD3+wuM0rErhDxth++VRu51TpUr2akywk6V9N
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10394"; a="280032917"
X-IronPort-AV: E=Sophos;i="5.92,235,1650956400"; 
   d="scan'208";a="280032917"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 15:32:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,235,1650956400"; 
   d="scan'208";a="595998431"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga007.fm.intel.com with ESMTP; 30 Jun 2022 15:32:23 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 30 Jun 2022 15:32:23 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 30 Jun 2022 15:32:23 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 30 Jun 2022 15:32:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A3rFEgsThlz+7VWaUyE6LAAYMadea2dESeh5mm4qiSPKnXev0dRTVF9H56n1TgLF5u5BaLMgdW1bv/6nme0VhkDxidmgHbLhnyzdfoiwqttU+4hwK5CruHyVTKewc9dUiCTFgO1I4tznVqVqat8w7OxAdrQQiCgbxkLcY/+eB6TwJuRd6ne/6YebAhD9SzgBadyXjHMawbiWj2SUhB7VcF+YLD8rByPWa1xp1q6C4wsZu0aABMUKw5ZSbZPlU60Y0KpNZPTcuWFQb2vCb8wWmS2yAPfmK5HLCqv73zZam8G48G90eCZFu0vlENhIXIJ/Ifqz/DJJS/8MICn2dyfT6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YKrxqOU5Eg413W2wDDqtgTZcqdtwcwQoFl4jkR0R+kk=;
 b=A342XCm98KK8hNjhk7NcGpbr+ag5uIey2xsLn8+brj06KAs7N4bQr+UGtyGrTTx20pemY9l325cW+n31xJjafxrXICVrFiUmz4DVqw9GFqEUs6QqY1kyLB4sOZDCSuEtBDksmjGgIIJ5XFM6EsGC+1L5Tq01Y2kYn+PKCmhAdB0LCWOPht0+3WVY5zg8V4TJExQArEIjGY6JXFECBUewPJXOcXrJ3y7LxWMO615cnwpcZARgF81k1TXiKZ7vyN8KirbvBN4mNrMS7egan4qmKCgLtgagqwUZFv6j1xDJRK82eCwkoW9/BzaF2LQphZ8cd/oQa/VHs6Efb93g2TmvGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6311.namprd11.prod.outlook.com (2603:10b6:8:a6::21) by
 CY4PR11MB1527.namprd11.prod.outlook.com (2603:10b6:910:c::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5373.18; Thu, 30 Jun 2022 22:32:22 +0000
Received: from DM4PR11MB6311.namprd11.prod.outlook.com
 ([fe80::e912:6a38:4502:f207]) by DM4PR11MB6311.namprd11.prod.outlook.com
 ([fe80::e912:6a38:4502:f207%5]) with mapi id 15.20.5395.014; Thu, 30 Jun 2022
 22:32:22 +0000
Date: Thu, 30 Jun 2022 15:32:16 -0700
From: Ira Weiny <ira.weiny@intel.com>
To: Dennis.Wu <dennis.wu@intel.com>
CC: <nvdimm@lists.linux.dev>, <dan.j.williams@intel.com>,
	<vishal.l.verma@intel.com>, <dave.jiang@intel.com>
Subject: Re: [PATCH] nvdimm: Add NVDIMM_NO_DEEPFLUSH flag to control btt data
 deepflush
Message-ID: <Yr4kcIC/GaAdfm8V@iweiny-desk3>
References: <20220629135801.192821-1-dennis.wu@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220629135801.192821-1-dennis.wu@intel.com>
X-ClientProxiedBy: SJ0PR13CA0116.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::31) To DM4PR11MB6311.namprd11.prod.outlook.com
 (2603:10b6:8:a6::21)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5bdf5325-9cb8-4789-bbb0-08da5ae86615
X-MS-TrafficTypeDiagnostic: CY4PR11MB1527:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vx4IkZOtwS0XWJDU6p2+5fmr01W0I5yVaKV0TUHZxDhAFozgXG6i7vVdbn63IitajbAi7L5lUBd4Mkwb7uYnR7gY9SwLj2GzezuQyyvRuw0osg7+/8oa96vc5xMWRMXEnPnxYapTMX8WXIsnVpyMJlavQ+oKQSdfMNCOR6quToe0UpSEUajm1NUNTbUu7lXL/NYkq1BtDcgf8VwFPAUg+N8YAisaZziqufmo/ro9kI9LWG/c3l+nqSJfy0o7T02kU/6g3LWWD40BUmiBhTxfGLBhs8Qq+ZM+rsIVTNucHdAFeNk/N0XwSomi1y8FYwQOduxCfU/dodyH2bpEl/VVg7hRTts9y7MioYtROKQ/+BClTlHJ+nSe7okVUXWLsZhnstOEGS+zmHA8tRrlAU4JzQNEVOouwL2gUCpo9VpTAXkdHkMnRYl9u8scgRenfZjwcXdY5LBSEXrzQm9xgMdpqjwOMr/iEAnTUDek7AQ3rGxarwt2csbZ9zMxuw3fsO4IQj4qNbvBaeuzaNNZqMptuBkipdUhW7YxZggfp9L2v5mLcZupkxfQpVuOvdTNKOLlUjXvFAO8u47iWegEHpbOR/NW7XShjFZKBSCK+dXPLZ/8ulViYEWbs31fVQjDSbAzQaW5bSMv2mw7HHHWIVIYrAuxc1D7CV5AWXTMM1Vg0DAcoMynEKllUaQx8NivSrjpZuNnSN0h0SU4QBVyeK63wklM4HnyPtakwDVM0ZxuxM6xGI6v+HeUKTTk3ZPBig0PwWN94xVwxvnRGRTtTkRgvg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6311.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(376002)(346002)(136003)(366004)(39860400002)(396003)(38100700002)(86362001)(4326008)(66946007)(6512007)(316002)(66556008)(107886003)(6636002)(186003)(66476007)(33716001)(6486002)(8676002)(6506007)(82960400001)(6666004)(44832011)(41300700001)(6862004)(2906002)(9686003)(478600001)(8936002)(5660300002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kmb0hm91Kt0H10APoOXXmU0uWYmJqYuXYsioT7iCU5KyP78ulW9jVImjJjdJ?=
 =?us-ascii?Q?Op+iIoRIfTGg767ZLI0XyXPBrTCWJrg4KVk4DYJ1OGV+qIebgx4qh7JAjRsL?=
 =?us-ascii?Q?a+3Q0R8I9cScH+ucvKak0lKCruh4VAfV+TMm0/6OuosybRhrUSo91j8njH5B?=
 =?us-ascii?Q?SRBHUTMdXe2XMqt9gChCnGEohZwPHGp/xxuAWjVr5HzFJPTZPo4MZYqGWHYk?=
 =?us-ascii?Q?iTXLuMnbvj4mucwx00BoGPKGDOUW6hg8yIxPM2QwGHZCvheLWJwPDeO1BH9x?=
 =?us-ascii?Q?bSdHflGhW+QvQOQHTIJI1KIEnVVtuPNDBy5vYkxA1vGdfDbb0vIoVtPdUXHg?=
 =?us-ascii?Q?U/exUzwnmHq2Mtob2868LgcHgTr6jeeROSs4Imik2ahbEq9ZGiysPC1s02YY?=
 =?us-ascii?Q?cV7JLK/43ToeCBRcHv5aoocagYcZFx1yD77OdO2jJO/3mRa/aiAzUa7Ig+XU?=
 =?us-ascii?Q?nRGGRgGgUE1dplD2irt0Vu/2Lpn2BDj9eg4cyTGFrG5ACAgnR4mXFtKUZ7Fy?=
 =?us-ascii?Q?oysT+AbIySIvJqw4VillzkKyTJQNFlwcXOV8lezjjxtv3mfuTj8zzUfvZk3u?=
 =?us-ascii?Q?zKjORL/uHbtisN9XY+f3+U0MmGVtZsfvlpnIZnG5vJAENScXeGb2mXA3aIaQ?=
 =?us-ascii?Q?nG80fb/nl5v5OnmsaYMQo4vzzEQsag1bhlMsaIP1U5NFMJOapqRNClUvF1di?=
 =?us-ascii?Q?RTtuZ1XRemirqr/fDzn/Tt8fJD7vjw4n9Hk2nk0rUxgNUmTX39p/xXE9VQHL?=
 =?us-ascii?Q?KcJI7I95zl7XnfJb3drZKEk0Yfrg8ygTsJexwMXaJiM76QxtKPAorI4Kw1Kl?=
 =?us-ascii?Q?LQowKgu8hH3DxPNwR9GBaFiRSnCWb/4Qb21R+2geaGJWFN4GQRGNqsWPh5N6?=
 =?us-ascii?Q?puO0KvZXWkBNx7cr2j3WmeJQmMhF8dv3JHppI2wMRyRUweWAYs43nG73Ynhr?=
 =?us-ascii?Q?XpGlYLBBjCx5M9Sk+MJqAH7jvNv43N99wl/ewDwcg2+MJKKiKwnvanbY+P/V?=
 =?us-ascii?Q?P3mHIEiBMCYtVDpLgTGQiMTZffMbaNFBGUaX5Lhlyf7RrBxx59KEaF/kro/B?=
 =?us-ascii?Q?8/epEliVn/Pj4P8+O/+/rKaBOXLhzokV+FtHE4MfEuaulzy1fQIgBBaXZp8j?=
 =?us-ascii?Q?RarXR3tKjw+woN8XqLqlT8vkYfXaz36dLRrFax9FP0ygCe3wdNibLaLUFdXO?=
 =?us-ascii?Q?FdI3K5r1Lk2B7beVrTe45yUizn/nnxUVcRCf80ycjC5WM//7LHIkXwIFtvKO?=
 =?us-ascii?Q?i4avVj0J67FHUl6LU2O8yafAA7GytZiq5ro7+hp3lU0kK78Oa2MDm9dIwwaK?=
 =?us-ascii?Q?4rw/MhfgW/pSWPVGANy3RpZcwYMNMFjgQhziFyCdJLFnVruzLRQM/YCxC1fo?=
 =?us-ascii?Q?mF5pU7J4I9SL+VsgBG2K5J5fKs+qfA2PVSxBaeATDLqi0ZbeSxnCAp2Vrfl8?=
 =?us-ascii?Q?f1APHWLLLyIYYVi+slMX5GVtyMDkN45UPp+KOYbvDfKo4iibYG5IQHIuI7Mw?=
 =?us-ascii?Q?zeHUTLq5uzbdXv0mwNF3g8bP9/W7NR0n5GgOaHCv/VG87iux/OF00bm2ky0s?=
 =?us-ascii?Q?YV1EBgefVEHFg/oPGMPJF02U6CZpqt4ilWcFDHaqKi+Q+37lPnc6L80blESA?=
 =?us-ascii?Q?97+/bAUnAXeHhr+skfaX5n5j0K0L5PGojEUYgVOz7DxPYpMYLrEvtsiyu7av?=
 =?us-ascii?Q?k2SPsQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bdf5325-9cb8-4789-bbb0-08da5ae86615
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6311.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 22:32:21.9521
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hrE3OuKtPHk1rvwDElP82Yo7LUo2n2+zZPtxjqTFw7zRnjEH/UnqB9O3DcTiX+gIBg4gLxe1z60sS9OBj3n1ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1527
X-OriginatorOrg: intel.com

On Wed, Jun 29, 2022 at 09:58:01PM +0800, Dennis.Wu wrote:
> Reason: we can have a global control of deepflush in the nfit module
> by "no_deepflush" param. In the case of "no_deepflush=0", we still
> need control data deepflush or not by the NVDIMM_NO_DEEPFLUSH flag.
> In the BTT, the btt information block(btt_sb) will use deepflush.
> Other like the data blocks(512B or 4KB),4 bytes btt_map and 16 bytes
> bflog will not use the deepflush. so that, during the runtime, no
> deepflush will be called in the BTT.
> 
> How: Add flag NVDIMM_NO_DEEPFLUSH which can use with NVDIMM_IO_ATOMIC
> like NVDIMM_NO_DEEPFLUSH | NVDIMM_IO_ATOMIC.
> "if (!(flags & NVDIMM_NO_DEEPFLUSH))", nvdimm_flush() will be called,
> otherwise, the pmem_wmb() called to fense all previous write.
> 

This looks like the same patch you sent earlier?  Did it change?  Is this a V2?

Ira

> Signed-off-by: Dennis.Wu <dennis.wu@intel.com>
> ---
>  drivers/nvdimm/btt.c   | 26 +++++++++++++++++---------
>  drivers/nvdimm/claim.c |  9 +++++++--
>  drivers/nvdimm/nd.h    |  4 ++++
>  3 files changed, 28 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
> index 9613e54c7a67..c71ba7a1edd0 100644
> --- a/drivers/nvdimm/btt.c
> +++ b/drivers/nvdimm/btt.c
> @@ -70,6 +70,10 @@ static int btt_info_write(struct arena_info *arena, struct btt_sb *super)
>  	dev_WARN_ONCE(to_dev(arena), !IS_ALIGNED(arena->info2off, 512),
>  		"arena->info2off: %#llx is unaligned\n", arena->info2off);
>  
> +	/*
> +	 * btt_sb is critial information and need proper write
> +	 * nvdimm_flush will be called (deepflush)
> +	 */
>  	ret = arena_write_bytes(arena, arena->info2off, super,
>  			sizeof(struct btt_sb), 0);
>  	if (ret)
> @@ -384,7 +388,8 @@ static int btt_flog_write(struct arena_info *arena, u32 lane, u32 sub,
>  {
>  	int ret;
>  
> -	ret = __btt_log_write(arena, lane, sub, ent, NVDIMM_IO_ATOMIC);
> +	ret = __btt_log_write(arena, lane, sub, ent,
> +		NVDIMM_IO_ATOMIC|NVDIMM_NO_DEEPFLUSH);
>  	if (ret)
>  		return ret;
>  
> @@ -429,7 +434,7 @@ static int btt_map_init(struct arena_info *arena)
>  		dev_WARN_ONCE(to_dev(arena), size < 512,
>  			"chunk size: %#zx is unaligned\n", size);
>  		ret = arena_write_bytes(arena, arena->mapoff + offset, zerobuf,
> -				size, 0);
> +				size, NVDIMM_NO_DEEPFLUSH);
>  		if (ret)
>  			goto free;
>  
> @@ -473,7 +478,7 @@ static int btt_log_init(struct arena_info *arena)
>  		dev_WARN_ONCE(to_dev(arena), size < 512,
>  			"chunk size: %#zx is unaligned\n", size);
>  		ret = arena_write_bytes(arena, arena->logoff + offset, zerobuf,
> -				size, 0);
> +				size, NVDIMM_NO_DEEPFLUSH);
>  		if (ret)
>  			goto free;
>  
> @@ -487,7 +492,7 @@ static int btt_log_init(struct arena_info *arena)
>  		ent.old_map = cpu_to_le32(arena->external_nlba + i);
>  		ent.new_map = cpu_to_le32(arena->external_nlba + i);
>  		ent.seq = cpu_to_le32(LOG_SEQ_INIT);
> -		ret = __btt_log_write(arena, i, 0, &ent, 0);
> +		ret = __btt_log_write(arena, i, 0, &ent, NVDIMM_NO_DEEPFLUSH);
>  		if (ret)
>  			goto free;
>  	}
> @@ -518,7 +523,7 @@ static int arena_clear_freelist_error(struct arena_info *arena, u32 lane)
>  			unsigned long chunk = min(len, PAGE_SIZE);
>  
>  			ret = arena_write_bytes(arena, nsoff, zero_page,
> -				chunk, 0);
> +				chunk, NVDIMM_NO_DEEPFLUSH);
>  			if (ret)
>  				break;
>  			len -= chunk;
> @@ -592,7 +597,8 @@ static int btt_freelist_init(struct arena_info *arena)
>  			 * to complete the map write. So fix up the map.
>  			 */
>  			ret = btt_map_write(arena, le32_to_cpu(log_new.lba),
> -					le32_to_cpu(log_new.new_map), 0, 0, 0);
> +					le32_to_cpu(log_new.new_map), 0, 0,
> +					NVDIMM_NO_DEEPFLUSH);
>  			if (ret)
>  				return ret;
>  		}
> @@ -1123,7 +1129,8 @@ static int btt_data_write(struct arena_info *arena, u32 lba,
>  	u64 nsoff = to_namespace_offset(arena, lba);
>  	void *mem = kmap_atomic(page);
>  
> -	ret = arena_write_bytes(arena, nsoff, mem + off, len, NVDIMM_IO_ATOMIC);
> +	ret = arena_write_bytes(arena, nsoff, mem + off, len,
> +		NVDIMM_IO_ATOMIC|NVDIMM_NO_DEEPFLUSH);
>  	kunmap_atomic(mem);
>  
>  	return ret;
> @@ -1260,7 +1267,8 @@ static int btt_read_pg(struct btt *btt, struct bio_integrity_payload *bip,
>  		ret = btt_data_read(arena, page, off, postmap, cur_len);
>  		if (ret) {
>  			/* Media error - set the e_flag */
> -			if (btt_map_write(arena, premap, postmap, 0, 1, NVDIMM_IO_ATOMIC))
> +			if (btt_map_write(arena, premap, postmap, 0, 1,
> +				NVDIMM_IO_ATOMIC|NVDIMM_NO_DEEPFLUSH))
>  				dev_warn_ratelimited(to_dev(arena),
>  					"Error persistently tracking bad blocks at %#x\n",
>  					premap);
> @@ -1393,7 +1401,7 @@ static int btt_write_pg(struct btt *btt, struct bio_integrity_payload *bip,
>  			goto out_map;
>  
>  		ret = btt_map_write(arena, premap, new_postmap, 0, 0,
> -			NVDIMM_IO_ATOMIC);
> +			NVDIMM_IO_ATOMIC|NVDIMM_NO_DEEPFLUSH);
>  		if (ret)
>  			goto out_map;
>  
> diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
> index 030dbde6b088..c1fa3291c063 100644
> --- a/drivers/nvdimm/claim.c
> +++ b/drivers/nvdimm/claim.c
> @@ -294,9 +294,14 @@ static int nsio_rw_bytes(struct nd_namespace_common *ndns,
>  	}
>  
>  	memcpy_flushcache(nsio->addr + offset, buf, size);
> -	ret = nvdimm_flush(to_nd_region(ndns->dev.parent), NULL);
> -	if (ret)
> +	if (!(flags & NVDIMM_NO_DEEPFLUSH)) {
> +		ret = nvdimm_flush(to_nd_region(ndns->dev.parent), NULL);
> +		if (ret)
> +			rc = ret;
> +	} else {
>  		rc = ret;
> +		pmem_wmb();
> +	}
>  
>  	return rc;
>  }
> diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
> index ec5219680092..a16e259a8cff 100644
> --- a/drivers/nvdimm/nd.h
> +++ b/drivers/nvdimm/nd.h
> @@ -22,7 +22,11 @@ enum {
>  	 */
>  	ND_MAX_LANES = 256,
>  	INT_LBASIZE_ALIGNMENT = 64,
> +	/*
> +	 * NVDIMM_IO_ATOMIC | NVDIMM_NO_DEEPFLUSH is support.
> +	 */
>  	NVDIMM_IO_ATOMIC = 1,
> +	NVDIMM_NO_DEEPFLUSH = 2,
>  };
>  
>  struct nvdimm_drvdata {
> -- 
> 2.27.0
> 
