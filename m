Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8D32563
	for <nvdimm@lists.linux.dev>; Thu, 25 Jan 2024 00:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706140953; cv=fail; b=uxfCd3objmiiRKzghTJHQanSKNMAFBWHfpgsfReMQm2Lbd8jkidx+AvjDcEtNkbneXNrW/CN1s2ZwlIzQaNU+7oP36HJbfXDOEhOAQgM82PnSjR5Zz74d8en7mZ2e2NJ3wgP0MXYkhzcApKDxHRAG/4jL+rSe8al6ofL9ChQRxU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706140953; c=relaxed/simple;
	bh=TPR+AcrgfLOELf0oZz1Mo0vtbIITAewia88aezjikD4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=N2F8pM6MPRReHvQtwxfH79+CIIDKTqFRGrnqHm4+8yXPERIKNTvsHHopbPAmyt1PrgWOyBBFgkaJKDRi+MnySr/LzuB45VV37PlUTGjCvMuDow2/gOsdRGtkuawben4MzMvGBtN1g1LQrpXC3FIGsq/JdwmHa3leRmvEiVrt8Ko=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z2N+Zcte; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z2N+Zcte"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706140951; x=1737676951;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TPR+AcrgfLOELf0oZz1Mo0vtbIITAewia88aezjikD4=;
  b=Z2N+Zcte8NhMXfcvak5gFM3qKw793OVAR0nFarxSNRQCF3C1uZAmARIR
   L71uhn26xDGh0G2bUyQD//OBJOIulK8TGR6W8lX76tZ1fzvxG/oznUoiX
   xJY6CWAlNADuEyZBj51qTnxVyapdoZWJg7rmorfe0qIofxvhQdpHtPY4M
   bieSSqcyD96sXH5wMlOTzcyzH9Lp82O3rNkdH58gwMbvEWYHh9kUtFkIG
   HJZ6AB3NXt7j5S9gayY5eRDIQ6KYEo0ZwPJ/3N5fdF6dbHYasjDgoHB6W
   f/ekZJOFcspfvEzAUnuOkKjKHm0VM2/22ccVNKzP4N0tRaVOaXl/cBP6D
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="9387542"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9387542"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 16:02:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="2220066"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Jan 2024 16:02:30 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 24 Jan 2024 16:02:29 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 24 Jan 2024 16:02:28 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 24 Jan 2024 16:02:28 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 24 Jan 2024 16:02:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dBo2NB+/uDFZJm5oGtJ0v+AMXtDP/XYbCot5k9u4iKuBpl8Q5V1G8ZYyVxhelP3okAiCdq4k0pkDdjOE02Q6OU2T9NSR2wgCtNjju6lGcWRZDcb2i3t6OoK8r739bl926FlCp1tYMGyiUX7ytJiDCEKV36Kz3cddWnsYiup42PUoFnUZcNTqwKCSrYGmpyBdnppKs2o8H+Ph8bUlBZh8OG6AzcTq6RhewmbY1Yia+E0kw/O23YYbltwsazT+bnZKdewWnlTUNdbkhzlUgbJZ84vvfPQ09q7n8GqHyr2vOU3mCHDJKX4kynGDnreIwt6yYwClzyLoxfQ2zo/Bnsv//Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zhc7i/bowiZCxU8sdmpVRlxJ0ksxbFlFh7F2GqMiAyw=;
 b=MFr87ltxLAwVk6lS3TcnSnkgIrRAunoIP52+5kIITH5BR88dK1c7t7RUvInyH9Wc9hfozi4GWnn+ALlA/FWIZClTozoNBB4wvZwzLN1MxSQEeM7NPMc5kLXrSeWvllmUT0NxkMf/2jvgXgsmXnXipWfKMpFtxS9D0SdTT38RImYNmdlVbnA3tzhrpexpFTHZSZcETpgbi3DsdPTnQ6VAgZWtP0ejuneU6KEk51Dk4vyKrDSwOZyAv9sIEodsOq8B/QE89BwjyxOVgqXtsxHCQZVgKg5msOH1cGkrLMUTCTqiWC8jfBgcR4CwqyZZfZP0GR+TkNg4A926G7s11XNHCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5984.namprd11.prod.outlook.com (2603:10b6:510:1e3::15)
 by CH3PR11MB7202.namprd11.prod.outlook.com (2603:10b6:610:142::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.37; Thu, 25 Jan
 2024 00:02:26 +0000
Received: from PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::780:d536:ff24:3e4c]) by PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::780:d536:ff24:3e4c%3]) with mapi id 15.20.7202.034; Thu, 25 Jan 2024
 00:02:26 +0000
Message-ID: <d1f89b46-b61f-4667-87b9-8249a86bb2bb@intel.com>
Date: Wed, 24 Jan 2024 17:02:22 -0700
User-Agent: Betterbird (Linux)
Subject: =?UTF-8?Q?Re=3A_=5BPATCH=5D_cxl/region=EF=BC=9AFix_overflow_issue_i?=
 =?UTF-8?Q?n_alloc=5Fhpa=28=29?=
To: Quanquan Cao <caoqq@fujitsu.com>, <vishal.l.verma@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>
References: <20240124091527.8469-1-caoqq@fujitsu.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20240124091527.8469-1-caoqq@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0021.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::34) To PH7PR11MB5984.namprd11.prod.outlook.com
 (2603:10b6:510:1e3::15)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5984:EE_|CH3PR11MB7202:EE_
X-MS-Office365-Filtering-Correlation-Id: 1191dee1-ff3c-45f9-a598-08dc1d38ea30
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c/+4VOok8IVbDjaz36uMV0OpHu1SfixMHRfpbEale460JxL/07n98zKbxC4yxdQPtDPgu88Y9cGKFp+s5va7Wj6gPv2ZNfVsWZrQ8KY3HqnZIsmAmuvsOiZrld8S61choffXA5QyFS7P+ElcvyIeUcQ5QVHh00HE3Sk+Qk1Y/38XCP5XWCQiVnO+XIRT800IqEP4Zv8S5rFRsICO+YhbsVteW2lv/CrAmYFUPlMrPL6d5SR8UZeNbIQ/iyRrI/4dLg1dhSCgP6nATD31BKL99s0C79GKtG2JA8SfDyX1kq+n1vcSzKthmn2QHjkn36hH2chWcWKgyenDgS9C/jX97bbsrEGlZVuwPK+iBlBPPA2mFc/iRBqIZhzLNrD10wmzBWFAHXDEWoLXVLE72r43fkVzVN7yQWdUvpR4twtEfcnLLNA0xo5eFKeA7mdDSas+lxzH0IHUdMX+ps4BiNOM0osJUY0PKhw4jASgWb6rhi5Jo2pDRE68+kirUvtK/FYthsfyoDBfPhPbWx+cfnBMNdQRWNScDR9fJRfYvHrC9RIDeLmZ62OkASsE30ldrb3qRCLxyv80C+219KYss8l+Bi7VZr63ZGJWLAdnXvr4p0wlYsi41Mh79thP+5qmIzcU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5984.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(346002)(136003)(396003)(39860400002)(230922051799003)(186009)(451199024)(1800799012)(64100799003)(83380400001)(31686004)(26005)(4326008)(44832011)(66556008)(8936002)(66946007)(6636002)(316002)(66476007)(5660300002)(86362001)(31696002)(478600001)(38100700002)(6486002)(2906002)(6512007)(82960400001)(36756003)(6506007)(2616005)(53546011)(41300700001)(6666004)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K2U4a3BubDhzMzM4WUxCQUZhUnkwaENBcVdjZ3lRSEZZT1FHRlFtUnRSOTVy?=
 =?utf-8?B?Um1jQ1VYMndGTllDY2x6ci9uazZOVDA2OVZnWW5BOVBpeHVMY0R6aDNGZ3c5?=
 =?utf-8?B?cEd6dmtwM1hGRHV0cytsYjlvWWpiQlloNjdzd1ZYOHM0VW5Mc09nT2ovV01D?=
 =?utf-8?B?dlBaTlMraml6eHhEcVNhV0JIQkRRT2JSMnVWREJQVnRLVTRMOVJ1QTBrRWxz?=
 =?utf-8?B?U2crWHE4WS95R0ZoVElWdmFxdkVydG45Z2ZUREUzckU2Ky9aeXpDRTdXZTh0?=
 =?utf-8?B?NUtBRDdkN0VySFFrM2N1bCsydFdTdTBsTTR6V0U4VWJMMVVSVWdhT0ZQUmlH?=
 =?utf-8?B?Y0l4Unoydk5BVGUwV0FlOTE0d2RSajYyTCtTZjA4LzdlQnhFSDBKcG9rQmF2?=
 =?utf-8?B?N3d0WTQ2SXljTzB2eDYwSVpYYnFzRW1DZzRwZnhja1gxcStlKzJtRmR0c0FD?=
 =?utf-8?B?Mk50ZUJuWmFXOUNPM1l0NmlJRDMxQXhEblFBVTNHVjYyL0pQU2IweStzVGtZ?=
 =?utf-8?B?Nk5RN3hXWEhaWlhzWUVQeDRUWGxCSGM4Unl2MlBwL2lDMWZhakw2YnlzcEph?=
 =?utf-8?B?VmJHSVE1Zkdkc2ZrdmFRaS9wS0kvTTljNjBVWUlrK3RZQ0Z6UnRhVTRvdUQv?=
 =?utf-8?B?Umlabm1PamZnRDhhaHRDQUxqTWtmTFVjK05PaGk3bjRNTTMyUnVuZzRFa290?=
 =?utf-8?B?S1FRNUZUS3ltcW9FZkFkc2pSK2REYUM2cHpRZmlhNE1oemJDK0lyQmhrMWZR?=
 =?utf-8?B?L2Y0N0lLWGZxY0tydVFLaTJjVU1IOWRXdXFtN3FsaHRZY0VVY20ybWh6OUlC?=
 =?utf-8?B?NGNjMnB6T1BDaE5VZE9DL0x1Z3BtVWpTM1JyTTVNbitqZno5Ump5Y1NSZG4w?=
 =?utf-8?B?T20ydlB0YmZtUlNiWmRvZXdpeUxuVnBjQmZJOUNRTEtGaFlPb29BZjRBSnhP?=
 =?utf-8?B?Um4yWS96WHRWbjhldVNFdFFvNjRRY1h0WE1sa2xyam02WWZLUzIxa3FwMkdt?=
 =?utf-8?B?T2JRVy9QaUFqeUV6YTllYkhBSjRhR0VuNkRDRjhZSTF5TkQ2amRlS0Fqd3Bh?=
 =?utf-8?B?SlZXZnhDams4TVpvS3A4S25XWHQ1QzNNZlkzK2h2OG5ucURlMGVLVlJQWHFQ?=
 =?utf-8?B?Y2Rkd0VBOUl4cit4Qi9GM3FCTGZKL3pmZXI5dGFTVXA2aUNrS05FYzJ1ZFhY?=
 =?utf-8?B?NER2OGJwcmFGZTVnd29YKzQ2RENrNm83WC83OVR5bXRzNTFUWFFVZTlyTkV1?=
 =?utf-8?B?Ykc2QktvcGNQMUdnMFc1K01LbGc1UjhKREhobTJoUEhwdDJlQUZYY1RFenE1?=
 =?utf-8?B?UUhDOGxGYnFOMCtyVXNzYUpWVzNob3d6VFpVT25IYm94OWV6VjdRQ1FEeXE5?=
 =?utf-8?B?cksrY0g5YTZsTCtsWkJOT1F4d3orbDN3eWRBNk8rLyt0STJIT1dLcks4SlZi?=
 =?utf-8?B?Szhjc2g2SFoxNW4wdlo1cEthRWw3eG5LSDRzUVQyMFdXUkEvb0NZdm94TVNq?=
 =?utf-8?B?aDBvOVo3TTBRa0NQcU1JUU0rMmtSN2oyNVdZb2VDQlFSZUtETW5IMDllMEth?=
 =?utf-8?B?YXZOdml4ZFFIcmFTRnl2TmFPZHhJS1B5VlJlMVVJYlRlaENYWjhlUXRtVXR0?=
 =?utf-8?B?UHY1TlcybWZrdm1YSlhUVFRWNVN4V2VGaHB5ZzJHUDlPQ2NJaFlKeW9ncXU5?=
 =?utf-8?B?dTNCdFdkc21LSTFsM1FEZGdtSEhmd0lMcklGalJBY1hWMXlOeTJacEhwcmZD?=
 =?utf-8?B?TDlrU3VKV3RyZ3pCWTRZWnlQMGdDQ09xS3NxL0MxZzBicHo3VmtzbHhqSkg5?=
 =?utf-8?B?RVhaRmVhWktYOVIzM2g2OGliQTQ0WE10eHhETit0RHhGVzJpMEQzdm5VWW9I?=
 =?utf-8?B?d1FseXMyTmlybUtaWSs4TGtqNjlZQ0dtUW51K1lHWUloamJCbHB1VTVVbFM0?=
 =?utf-8?B?OXU4QjgyQzB3Z21sbFhhV0tRellpSjV2cExLQk9nMUZSN1Zqb1RnUVpSdm92?=
 =?utf-8?B?WFFVZnBmUTFmUUlNQlVBY2wvVGFicEwrTythLzJQQ1dHekcyWTQ3V01tSzVy?=
 =?utf-8?B?T0w4bGIrcUgzVEFqS0s4WEw0VVlueitlR20xMTY1dEgrZ3hXVHhLK0IvTVJa?=
 =?utf-8?Q?pJbWtUEgakP4WNLlQ2HtcqZbP?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1191dee1-ff3c-45f9-a598-08dc1d38ea30
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5984.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2024 00:02:26.6308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wxZJhrbuQ1nW/zU3XZasAjmSwbYRXeUpRS56CviuPva4CUVBYTzdJDoETsOt7wQrmOO1y11zZSgY34qHtcChKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7202
X-OriginatorOrg: intel.com



On 1/24/24 02:15, Quanquan Cao wrote:
> Creating a region with 16 memory devices caused a problem. The div_u64_rem
> function, used for dividing an unsigned 64-bit number by a 32-bit one,
> faced an issue when SZ_256M * p->interleave_ways. The result surpassed
> the maximum limit of the 32-bit divisor (4G), leading to an overflow
> and a remainder of 0.
> note: At this point, p->interleave_ways is 16, meaning 16 * 256M = 4G
> 
> To fix this issue, I replaced the div_u64_rem function with div64_u64_rem
> and adjusted the type of the remainder.
> 
> Signed-off-by: Quanquan Cao <caoqq@fujitsu.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  drivers/cxl/core/region.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> index 0f05692bfec3..ce0e2d82bb2b 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c
> @@ -525,7 +525,7 @@ static int alloc_hpa(struct cxl_region *cxlr, resource_size_t size)
>  	struct cxl_root_decoder *cxlrd = to_cxl_root_decoder(cxlr->dev.parent);
>  	struct cxl_region_params *p = &cxlr->params;
>  	struct resource *res;
> -	u32 remainder = 0;
> +	u64 remainder = 0;
>  
>  	lockdep_assert_held_write(&cxl_region_rwsem);
>  
> @@ -545,7 +545,7 @@ static int alloc_hpa(struct cxl_region *cxlr, resource_size_t size)
>  	    (cxlr->mode == CXL_DECODER_PMEM && uuid_is_null(&p->uuid)))
>  		return -ENXIO;
>  
> -	div_u64_rem(size, SZ_256M * p->interleave_ways, &remainder);
> +	div64_u64_rem(size, (u64)SZ_256M * p->interleave_ways, &remainder);
>  	if (remainder)
>  		return -EINVAL;
>  
