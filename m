Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB6951850
	for <nvdimm@lists.linux.dev>; Fri,  1 Jul 2022 16:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656693786; x=1688229786;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=+jFY0beLWHh5BF8PKgG2wqxT5aCeyURXATBZ5v2GA0Q=;
  b=ZAk7t8S7EhlZU+yNz9RndmirTt0eN3ht0UJuAY3BW3OtH6RfcSzaGeS+
   E+SXS6GQhi2TPKoiPmwfHTUQZIX4u1/Fx4vt8SSQZAM17B7RXPsqGQXpk
   dXQLsUgUFvPvrMggW8zB78DXgJ25thaeHkeindcw8/25C5RRdVd6rrQKD
   8cHw55EoYT1OkhhtyT3JyuZVpqZQKr/UyHt1+7nVIkWusHhUi4DVCqkto
   HlkDR9z8D4APUg3f9iD9Edks0P/lV9/JN76X4w80e6kIvxX2ZeeEdfVh3
   Hfu1MK00HAxlfRCyPlOu+N68CVn1OPSsQzVlktkfO9OO9U8dyo0W64iQ7
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10395"; a="308212773"
X-IronPort-AV: E=Sophos;i="5.92,237,1650956400"; 
   d="scan'208";a="308212773"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2022 09:42:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,237,1650956400"; 
   d="scan'208";a="624328379"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 01 Jul 2022 09:42:50 -0700
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 1 Jul 2022 09:42:49 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 1 Jul 2022 09:42:49 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 1 Jul 2022 09:42:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JAEjjGlf32PsFSgoR5nfOOBscl/PuAAwHIV39keZX5JyrBd6i9qri2fM4gxxZNMJQLcpwCOURVXAX4X3HQXdSAodJvBoF4E7g4NbfOlHSXPr5nD7ZrA+HSpBFxcXCXW/M18KsGtxYppx8w4rgyYCK/41FB+f5x66jlZgl5pjp+x6WH/vNTgI6AKq+pZz2I0C/mkBa3YAdfZpFl/xdmN3PFZZNGPkPL0LEhyruF9XXvpc7fgPaD4cfsGMzwcM7exHIw+7rEuHaTF9FtHeG5+ec80c5SFCejqps2YzDDcvUAVHOYufurQqLAprUH7l6txkCqU/yB4Whl2q9G+pCnSZ+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iIg7KXqgNqBB32Rbv6szDlqdsth0R5zintkt4aLWFxM=;
 b=WFjx9O+uBWcAxvjvC0TfWiozNi5AFHfjMmPQegwF294ONfuAooVBXnkRp0tlkPKl/UZyC19ga3CWk8goMoD5U0ae+ELvIyIIdBwwIPqAEjAp1KxeX736bFrz0kNsmZVYFZXfs3bqbKeA7t7Agq2tnNQJc/epUkJhdAdwrxnSRWzTNjzHg891Jjd0ipxzHLZwScLiKCR9piT82IXNpZKDqLOOXcC/WXGLfYhdRDiIo3CYX/fdqLnzfNXeLtD10IVGIxq5QYsnd2VFNhmtjNgKIA/bl7c8tYyUod0elciA0Rzp47+XCw29yufeQtOB/9HCF3BeY9AZYWa8ekU/qOZZxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6311.namprd11.prod.outlook.com (2603:10b6:8:a6::21) by
 MN2PR11MB4632.namprd11.prod.outlook.com (2603:10b6:208:24f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Fri, 1 Jul
 2022 16:42:48 +0000
Received: from DM4PR11MB6311.namprd11.prod.outlook.com
 ([fe80::e912:6a38:4502:f207]) by DM4PR11MB6311.namprd11.prod.outlook.com
 ([fe80::e912:6a38:4502:f207%5]) with mapi id 15.20.5395.014; Fri, 1 Jul 2022
 16:42:48 +0000
Date: Fri, 1 Jul 2022 09:42:42 -0700
From: Ira Weiny <ira.weiny@intel.com>
To: Dennis.Wu <dennis.wu@intel.com>
CC: <nvdimm@lists.linux.dev>, <dan.j.williams@intel.com>,
	<vishal.l.verma@intel.com>, <dave.jiang@intel.com>
Subject: Re: [PATCH] nvdimm: Add NVDIMM_NO_DEEPFLUSH flag to control btt data
 deepflush
Message-ID: <Yr8kAqfVzQGrrXVF@iweiny-desk3>
References: <20220629135801.192821-1-dennis.wu@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220629135801.192821-1-dennis.wu@intel.com>
X-ClientProxiedBy: BY5PR17CA0041.namprd17.prod.outlook.com
 (2603:10b6:a03:167::18) To DM4PR11MB6311.namprd11.prod.outlook.com
 (2603:10b6:8:a6::21)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a03a122a-f8e6-4bae-4084-08da5b80bb24
X-MS-TrafficTypeDiagnostic: MN2PR11MB4632:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v9ygV90yoBrZnFirPgnrlJ/13fB02/YC4MtaiiTpykTChyeN9nptX4K3ZM8s9+bULT98VgCDcslfR8cDP6TFHQ2cRZzQXSSN2TYCRPacQVpFjt2JjFJG8J3wnXpowRmyI6R7Xuhjyh8VxYmR+qdiwIq+E1PytIQx1RMahppKKCNHVKqTgRtod3qGGBnc8rOe/qbwyBFM+6oVPA0u3jaRID46AAPoTjJWgTemv4EhThIgYp70vEUhcchdgzQeLU6o9+TF7YVCIHBDv5we6oWN3CbaFw3FjNbEgy+vTWUIJSoJNB8GD08SoLANuDZNbrywOjJ5D+hiUup4klUMhLc7k+VcFaiw6HY0iaVGMOqfkZnr8VGVSr1XV+PUqeYAayYBz87Sva8du65bTSNb2+RIrEjECr7trsWP7/OwGuablJvHMltEkvZ6FW2KtbuxrF9rxLn2R92ySZAUnWWKHts9Nbu7D0s5fs23w5WzuQYV8QSvGudfQceuOcqZJMF5niG2R4sEieu5nmUwgWAnJxzhTvO0B2i9bY8gHayTqmK9+tSo41z7N06svIgH3OLSnbkvdiFx4H5SnFjyR7VBxhIne1BAPI6fR/ewECkhFLluvNLPl3lMkSun3hzXdoDlL3nkuIElRXNsSGLzk7k/BXjgF7YyFHasUZnG+4N/12DF4bwf5tuLVylzUbfc+EEbDxl/xgulHhH+4rkTh1OGwK8oHrK6kvq45OAsSEP3XxBE3zGL71ub6hSB8oxGlbBs+yA00DqPiGdoov3EsZM2eOqKDw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6311.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(376002)(39860400002)(366004)(346002)(136003)(396003)(82960400001)(38100700002)(6486002)(478600001)(5660300002)(6506007)(8936002)(6862004)(6512007)(83380400001)(9686003)(186003)(44832011)(107886003)(6666004)(41300700001)(2906002)(86362001)(316002)(6636002)(33716001)(8676002)(66476007)(4326008)(66946007)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Dqy6Fz3XIbPZF3q4H9g01+PqeNld00lF7nfOqUYXglc9YMGqM41hL/vVa9Iz?=
 =?us-ascii?Q?jTrKFDrTpu/y8KPaAACtfqW5sMTLGq6G5/AlebV89zzTCrnPwlyztTrieFci?=
 =?us-ascii?Q?g+vtQiOJrJOZwczY/AbqKlK4jerHtJdvk4XN98Fc80iKwfCrAaZ59t/en93B?=
 =?us-ascii?Q?HASe2+Y5D96r0Mk85aDIo5DQueEKkfJXZ82239gl91MtUvpcSQ90BUJanwwX?=
 =?us-ascii?Q?C4Mxz7viDL8wLgs2k3nQWxTD/kB9mW6ae3aG0wBfsjwHlcPgcWNMTjO9C0xL?=
 =?us-ascii?Q?ous/LLQkZ9c4DRfrItoVVYeXzatzjTBLg87TSJ/a5FxuaP/SWXXDz+iQn2dg?=
 =?us-ascii?Q?uFVZOra4ChXVu1qLJhzer3cjHJ3weXQTEN0WGKZyI8F/5cbQHm/BkIYqZo4d?=
 =?us-ascii?Q?p66xN0QP4DErG7gyQFwknCXcYlcFyWM1dmZtXUopPwpfe3AcCgTJEcxpr9gQ?=
 =?us-ascii?Q?fJd9hkaLI87Q3qIaGH6CA9yInSUrh3PyFYL588/XqeUNopilmcUR5gDM19Qh?=
 =?us-ascii?Q?Q6HMZd+L5m2sH96UMnA3v6CqR8xtpOWxQ8HZKLM8lho446dRpXiBL4rnG0LS?=
 =?us-ascii?Q?52rA645E01iCdjIhx//5qtKVUOSg2JQbkU0hCO6hueH2wvwDuuQQAFbMDQKE?=
 =?us-ascii?Q?d352sGxXDyZVZVz0u/HrJixh/ehDUQoo3e/CSOmU0z/NfOZdaj1kcIwf0qAA?=
 =?us-ascii?Q?Vwwq1i/sulaKQML4yvTO4iy3wOpE4UEwLhVIUJxmAoEofoHDsKkHxum+xIQD?=
 =?us-ascii?Q?WMDoOhzyaOEyzj8Ty7k5g8NNvpOy6hAnreLwg1hlKwWI2oZWnHRv51E407V8?=
 =?us-ascii?Q?ZugCYJlGnokuz9wWoI8mLWlwgTP3bB665tccC/4KBz23fo6nf4UT3Qbvm2Er?=
 =?us-ascii?Q?Fq91LZt4M4MUg2aBVXzkFEZ+ShA/HGVReUZ86hM6p+CUpBNvlMozxYa1qwms?=
 =?us-ascii?Q?6zCgEBwzNm8i+FZFWMILgE0x1gYo7YwgCUB3o1Dq7OwDECvQlOxXrPHlsOeZ?=
 =?us-ascii?Q?AfKhCP9dBRoIFG9PahXkihIPQYWYOGX7+cc2emA8whVEnVtdFHw4MzVdR1ox?=
 =?us-ascii?Q?zUb16WI7Iqal2aVsOArSn4IWCdouOSYyINbbUHg8/UgjSb9tjdbHKRp9zNaW?=
 =?us-ascii?Q?ZcaMrm57pMnAZKSV+QHLtlQvGQ72GT2YH8G60PQjr7/H5XutEqITs/r9YcBt?=
 =?us-ascii?Q?lFlSZ6WGZB4j10QnqLEkLeb4ysQsTIrK5DZ+noHhV66d4e1Pqqi795VLgPfM?=
 =?us-ascii?Q?buujUEtwHDPt4DoeVCu09DRE60nuTNctKiTKkjs6Ji7Cwc0lNW4C5ePvLM8I?=
 =?us-ascii?Q?c4LSSf2vEgdQRhxHtNpvi6McCqo5cKlImSMFWqC4EHABdq0oyRzwPI9Ojs1x?=
 =?us-ascii?Q?9Y2Iushrk3MvSmhigJ+/6azqIgTdjFwwQXeQRDB4TzgE/JFnDI+vUug/h9JC?=
 =?us-ascii?Q?NROP3DkWVdZsay6WNxKOnHZk1TDRLbXW6es3B2nAGGw1vya+/a8SsOYDyjEk?=
 =?us-ascii?Q?AWadl/upasMLUKyxuEpJcPjMOrLVaD3hwBSAGxUtRidCkJHRWK7y0QsJcjvK?=
 =?us-ascii?Q?8PwM9xsJ+Uxp0nJFT6wdcDKifA/SoCbiVNvJYUrkjttKVkvwo8FdtC1qM3aw?=
 =?us-ascii?Q?AIEhbUSaqx59UbOd/nMqei/vycqUbP5F9QIAJOTMSI/L?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a03a122a-f8e6-4bae-4084-08da5b80bb24
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6311.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2022 16:42:48.2346
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KZPIHr3cvcr0rM0zEAiLXITvNpIcG8ejAKx0SGKNx21o6UMbatVQZ8ic9HohrbsTUfe/2GcRbZDc3OC/uYLTtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4632
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

Unless Christoph is right and there is no need for this deep flush I think this
logic is backwards and awkward.

Why not call the flag NVDIMM_DEEPFLUSH?  I think that would make this patch a
lot smaller and the code much more straight forward.

The commit log implies that this flag is to be used with NVDIMM_IO_ATOMIC but I
don't see any relation between the 2 flags.  With that in mind see below.

> 
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

Why not specify NVDIMM_DEEPFLUSH here?  ... skip the next 9 hunks ...

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

And reverse this logic?

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

I don't understand this comment?

Ira

>  	NVDIMM_IO_ATOMIC = 1,
> +	NVDIMM_NO_DEEPFLUSH = 2,
>  };
>  
>  struct nvdimm_drvdata {
> -- 
> 2.27.0
> 
