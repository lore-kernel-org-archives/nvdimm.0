Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58CAA18A
	for <nvdimm@lists.linux.dev>; Fri, 19 Jan 2024 18:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705689134; cv=fail; b=s4O5B3oGqJdOiIza83oHtLxRXHUiYkxrnbl5uDFooZYDhkByQobt8MEoOs69xIkDPMx/x0fw9WRaLEl95iuvdH2gYa+mA3pJl9xTpSF3fWZMLGg1ZGmR83v3JDrgRlLrAp1BClDMdQsLRIFOkf/AOs/wZUzbplaFvCRXG1pcU8E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705689134; c=relaxed/simple;
	bh=XO78TFJuTHGm7RYhz80HSOU/je7h5vscy1F5FSS9H6I=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HKG67wiz1wreTNMPS6bmvwdkpz7/DLr/9XUTNg8t6UaQ2Ib05LWuNZ5UooNygFOfRQ4OWbA8sTa0uTUbptJR3OzjwlK1/Vnjc7eMGHiRa64XOaG+xtc/bws969nv45xx5zt/bIgV1v4Ow9VZcEXvk1fVd0+DmtC2IKsL/L9sX48=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HHxzSCz0; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HHxzSCz0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705689133; x=1737225133;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XO78TFJuTHGm7RYhz80HSOU/je7h5vscy1F5FSS9H6I=;
  b=HHxzSCz05quP1YG4FQkywlyx4VSg+ylNqvecFGnLlEBckGajT0Oxrplf
   WKhDQD7h5Z+dlclpoFuun2VwOWs9T0NiZM+FgfHxGRwX8KHxD1QgvJAiF
   1m8Wi7Ko34BUYZ/rRZmX32Qq+vuPtQ04n3UAK4ptEKkFotaDfbMXJ3Lpr
   pYwUtpLCc7z1tjljN2N+yg3hTRwmob6L8hWNZFauAvh+JLANsffYErO7v
   yBPO8qpaDauMExqwqYEVjYEH4EgvawqewrMgNl5XQ5GlUoSXBGeq6lhUc
   lKG29edBY8ca5UqBzHLIp+wbb0NEdyx+FRMoBn0EvI04TZK0D3cymXjNb
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10957"; a="7909480"
X-IronPort-AV: E=Sophos;i="6.05,204,1701158400"; 
   d="scan'208";a="7909480"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2024 10:32:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10957"; a="761188302"
X-IronPort-AV: E=Sophos;i="6.05,204,1701158400"; 
   d="scan'208";a="761188302"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Jan 2024 10:32:12 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 19 Jan 2024 10:32:12 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 19 Jan 2024 10:32:12 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 19 Jan 2024 10:32:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V2S5bagqLshzzxJognVONx3VPoRQ4IHRL4De1WKhdQ6Vo0d3je2WXoyTYrdRv0BU9v95DAdNeNBzbgwVR6rm7wT9edE1GjXnI91zBz8NUfh/lplop2fAyE9Sjmi/mRkj/GWv6zcaB5dzqf3izLl6JPQCrlhRHmrY0FaaxxLFbuVPPzCR+2fjEh/YAJdvUfdot7EJjDJisyajqGghLwz789uxThHg+B1CuXbxxTwxXCYVSiHa2gxbXr4/+SqobTNfs3Gnc0K+UVPCGxHGFcpy5vBkZc7A/rF7EgdvpClDNB+snk/QG1lFQWzLyxikIJwDOTJwnIJLLwmcffFLb1a8vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2rPihUcrEppPzsNZKwhBB6FtJuZHdvzBN6F9C/pI1IM=;
 b=dQk7Lm7//W+99uPXWCehiE4HBneG8KZRZXsqzY6uxokhvvZfDWrgwmAbSBFVa8Tw532zu2fOiEPP2PNAi++ZFba8y2Zf/XgWf1aWsvUgl3MPIkOFlb2LCi395E9RIOnMd580G/VdYvB9ZnTLB0fluxAhWLXHiprq4jFrtGRPUqiZaokG0IUWHUYDTeuIIIn0H0AY6m8O2rrcLzQiVbwTfNnkIOOfTdERfD+d9N1NYFlqYHl96M0uBvXRHmhT+ELmDVoTkzEUao23qrpRDHu4gv/9A0gTsq14hRvZl2Xwkn47SMxrOCZQGaeO1IpXaIRGyL58QO33AshXJGhGcql7lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5984.namprd11.prod.outlook.com (2603:10b6:510:1e3::15)
 by MN6PR11MB8220.namprd11.prod.outlook.com (2603:10b6:208:478::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.24; Fri, 19 Jan
 2024 18:32:10 +0000
Received: from PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::780:d536:ff24:3e4c]) by PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::780:d536:ff24:3e4c%3]) with mapi id 15.20.7202.024; Fri, 19 Jan 2024
 18:32:10 +0000
Message-ID: <694ad508-cc06-4e3a-974b-3d1403adeda9@intel.com>
Date: Fri, 19 Jan 2024 11:32:07 -0700
User-Agent: Betterbird (Linux)
Subject: Re: [PATCH v6 1/7] libcxl: add interfaces for GET_POISON_LIST mailbox
 commands
To: <alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
References: <cover.1705534719.git.alison.schofield@intel.com>
 <22d01bd1af9af5370d1e35094176dbd66ef20dac.1705534719.git.alison.schofield@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <22d01bd1af9af5370d1e35094176dbd66ef20dac.1705534719.git.alison.schofield@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0066.prod.exchangelabs.com (2603:10b6:a03:94::43)
 To PH7PR11MB5984.namprd11.prod.outlook.com (2603:10b6:510:1e3::15)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5984:EE_|MN6PR11MB8220:EE_
X-MS-Office365-Filtering-Correlation-Id: e05c1a10-0950-4196-0231-08dc191cf2a3
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oY+TQo7dMaP0vsJq/zE1KINaqfk8ZxDd0VCyHhEyy8jQNc59PHzJtGPUxGTIOQyx3bg0fTUuZDxGmD3Clw5SCVH+2pSM4GOyY6TIWR4jGFI1UD4z+qGn+nHwpFX3PJw2Um/Mw6uCPzXj0FpWPj8ljLkyY3ZjvWyEyeelXw/AsWjXMQPdRH5ievHx2qqcuYb2CuYJL4EUdZPHPC+WzH4hVKitjZBjSFaABgxB5OkE/vtMhUvwMQKBPKjXjhzvL+9FHj2DosqI9F82UG/Yg8vqhYO9anpbN7K+55ZWRlk05nCHgEt/Bq9ePHFU20viLDdDth+FcetuGYx0Jvg8leYx/X1yFiQOXH0sanxoTTyssMSJ93olldzK2g+osFyiHPeDilt2YZb2l2D1n5JrZTFpYkHrKOrHlHh0iy4np5b1zbS8aWw3k46nOU8uoNfM/g/tip2OVKEaRaFlBRlnaQIzBD5wwS+vNlthc8+t6NPYwZKa86Uk0EtuhIdBMAyMzI4kQNnfdWxfLbOMObuw4Ai5Xbzx830iXz5Hnr6WtxaDovyrGAQx4ykBgQINEIjeOl0y2Pfr532a859C+qLzHnRV/kLr7TPY9ElwLAgxQyWymJTEVxQpzUP7zNvqwE7IoiEI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5984.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(346002)(366004)(396003)(39860400002)(230922051799003)(1800799012)(64100799003)(451199024)(186009)(6666004)(66899024)(6512007)(6506007)(53546011)(26005)(6862004)(2616005)(8676002)(4326008)(36756003)(8936002)(6636002)(86362001)(316002)(44832011)(2906002)(37006003)(5660300002)(66476007)(31696002)(66946007)(66556008)(83380400001)(6486002)(41300700001)(478600001)(31686004)(38100700002)(82960400001)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WStHTXJnVnNJOXVYVU1sdjBsZnFmaUJ4Tmo4ZXJGV2xVc1hDWnZyYlRXbldy?=
 =?utf-8?B?SGR0QjdiS2UzN1NqZUJIVUVIbnA2Q2tCcFNXMkFTaGowdEhLdGsxeEJ2TzFG?=
 =?utf-8?B?YmRYaDB6eGhkWGEwQUpZK0t3OUF2V3JCcTRNdC8zeTh2QmlTSWJJT3pUSUY4?=
 =?utf-8?B?WU5od29KRXhVOUhvS1F6YzJSTTZVQXJJQXhVbkRHRHgrK3g2N0JtRldXeUhj?=
 =?utf-8?B?RlBkNEluQkZFdmVTRWV3ZFNKK3IwWlRvenFMMkpYZ05aeTd5ZXFVZ0w4WWlE?=
 =?utf-8?B?d2R1K1RRMFY1eDlqOFo2Nm5FOEptai9vbzlLNHR0QmZOV05oMG1sMjhURkJa?=
 =?utf-8?B?dVJzTjJKUWNkcCsxQWlyNHYyVEJ2VlptUTJVUHAvK1Y5SytFMEVkQTgyeDhN?=
 =?utf-8?B?OHUrV0ZXazJNMW5jdDVNQnBhMU54N01rQkxwdnI5cm1ReDN4M3hGc2sxSjFs?=
 =?utf-8?B?ZFozMVZiTElqMVM1QjNwZ0RQd2NsMXpjanVKOU1IS2xxWWJCQTVHSkEwc2J5?=
 =?utf-8?B?YzhtMmNSUzVEVC9FSW9TU1I2UGlnWWNLckhGLzk0VUc5NnNBTjhkTHhrUG9j?=
 =?utf-8?B?RkZEZkovaGZ4N21wNE1mWUxud25yZng0UE82V0RUYlBsdUZYUW5XWnc2bWhm?=
 =?utf-8?B?YUFkVHVGS3RPNzd1ejF2dEdidUlvT2Uxb0w2T2Q5alZMSjg2QkF5TEU5TVY4?=
 =?utf-8?B?OTRidzQwMmgyVmoxSGxQM3E1dnVySEl5Z3hGUkNyQnNoMnZFbU13T3JIM2JR?=
 =?utf-8?B?SjZnM0VPNzNKQ3ArKzZpYjhjQTNMYzlMM3h4Y21vL2NCMnlQU3RvUjNEd1hY?=
 =?utf-8?B?cU5qNndoeEJFeDd0bjVNVzNCUStNSU9YRUxOM1NZU1hoSEgra2dFNmtFK1Z4?=
 =?utf-8?B?WFNXc21YcGwxaFh1TkNmVUVnVkgrUGhkUXoxbUZVWWZlcGZEa0pmbnAzT3V6?=
 =?utf-8?B?cmNrNUtEL1VvemJKTGxSdW82dWlUQkFEaGJsSENwdFVJZzE4UTYwNDZxV24y?=
 =?utf-8?B?M3dBVEJBK3RKZm1DM2U3NWt3b1ROSlRyYTlQMXV2UlBKaU44RXpma3RWSmNr?=
 =?utf-8?B?WkhITXM1WTVHRGlzSjl5T2xnS1drYUs3WmZiU0ZnbUFmWXlvY3MxK3VrNk1W?=
 =?utf-8?B?VHduWHlUSGFvelBraEdUYzRpb0FPcHp2RDdBdUhaRkd4ZytpT29KNVFGTU4x?=
 =?utf-8?B?bFVMRHNnN1QvTlhOOWU4bjE1VExTRzZvdW5hazZ6czUyeFYvZ21qb3BlV2h1?=
 =?utf-8?B?NUNndWVFMkVLYTNTTmVzQUVxMHVEckMxeWpBbHN6UjNCYmpyU2hxUXlYYUxn?=
 =?utf-8?B?L0xTb3VjbnJ1TEZad1NYd1YrSTNHajJmZE5vMGcxb1p4TENOMHhLU3B6SWxh?=
 =?utf-8?B?ZnowL2ZwdVh3cW5yMWc0WkFndWRIeEVhdjdKekw4SG9sQWw1b3VleFVIYWw2?=
 =?utf-8?B?bXJId2NqZzRqa0RZWXV3L3FWc0R0Ujl6WDlSU2xZMTZ5RmJvenBRZm9KWHFr?=
 =?utf-8?B?MEtZZElNQmI0VTRMU1k1bmV4U1c5NjNQR21tSGU2UG5PYkExdnU1Rm44MXc0?=
 =?utf-8?B?ejVzYzJnOHBlRCtsbzJ5Ri9WK2VDV3Y1UmNCOExuTzdrdTZtTGhBeCtqUzBs?=
 =?utf-8?B?QWpFMk93U1U3bVlCVldzSE5UTVljTm04cUxiQnJ0dk9LaFI4dTNGU2twakxu?=
 =?utf-8?B?SW85clI4a1laWm16Vmx6eS96NUExUVp1cXhwSWlldXdjR1h1MWFjM25ZV2lU?=
 =?utf-8?B?c0RMRHRGL1RXR3pnemxEdU1haWpFYXhjbjFqUTJvRW95M3lQYzRMd1EvWXpn?=
 =?utf-8?B?V1g0WE1KT3JIckxOVEdHVUl4MTdFUmZHYnF2dmdoNkwyMXZ0aVlFNzNzMHBk?=
 =?utf-8?B?NWRyVi9lMndZMWp2bjZmb1hMWnpDRmpNTmgxOHFJY2s4cXdBWll1WnQwdUo1?=
 =?utf-8?B?eDRMbnJ3b2lydmI5Z2kvRXpCbS9sWTE0cDVSeUFYYk1vNEI3UEpmNXBhK0lM?=
 =?utf-8?B?NUtHWW9TV29sTzRra1hJbitIREV5cVNqWFpWUDk2dnNjOTFqWW1OT1dEZjRN?=
 =?utf-8?B?SzltdDdUOGdXSlF4RlVMV0N3dFZxbzhud0VNZTF1Wk8vcTkxc0VOUU15SHF5?=
 =?utf-8?Q?pFKaGpg3vCHsamSLGXiEerL3C?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e05c1a10-0950-4196-0231-08dc191cf2a3
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5984.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2024 18:32:10.1428
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KHL+LTuEvH6VQ85ykdCP8C98pl3jVHz8SSBlldFuSHXm2z/aUmqWXotB2E2hEcaBqBUrivmJpfBFmcjBJHEKsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8220
X-OriginatorOrg: intel.com



On 1/17/24 17:28, alison.schofield@intel.com wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> CXL devices maintain a list of locations that are poisoned or result
> in poison if the addresses are accessed by the host.
> 
> Per the spec (CXL 3.1 8.2.9.9.4.1), the device returns the Poison
> List as a set of  Media Error Records that include the source of the
> error, the starting device physical address and length.
> 
> Trigger the retrieval of the poison list by writing to the memory
> device sysfs attribute: trigger_poison_list. The CXL driver only
> offers triggering per memdev, so the trigger by region interface
> offered here is a convenience API that triggers a poison list
> retrieval for each memdev contributing to a region.
> 
> int cxl_memdev_trigger_poison_list(struct cxl_memdev *memdev);
> int cxl_region_trigger_poison_list(struct cxl_region *region);
> 
> The resulting poison records are logged as kernel trace events
> named 'cxl_poison'.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  cxl/lib/libcxl.c   | 47 ++++++++++++++++++++++++++++++++++++++++++++++
>  cxl/lib/libcxl.sym |  6 ++++++
>  cxl/libcxl.h       |  2 ++
>  3 files changed, 55 insertions(+)
> 
> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> index af4ca44eae19..cc95c2d7c94a 100644
> --- a/cxl/lib/libcxl.c
> +++ b/cxl/lib/libcxl.c
> @@ -1647,6 +1647,53 @@ CXL_EXPORT int cxl_memdev_disable_invalidate(struct cxl_memdev *memdev)
>  	return 0;
>  }
>  
> +CXL_EXPORT int cxl_memdev_trigger_poison_list(struct cxl_memdev *memdev)
> +{
> +	struct cxl_ctx *ctx = cxl_memdev_get_ctx(memdev);
> +	char *path = memdev->dev_buf;
> +	int len = memdev->buf_len, rc;
> +
> +	if (snprintf(path, len, "%s/trigger_poison_list",
> +		     memdev->dev_path) >= len) {
> +		err(ctx, "%s: buffer too small\n",
> +		    cxl_memdev_get_devname(memdev));
> +		return -ENXIO;
> +	}
> +	rc = sysfs_write_attr(ctx, path, "1\n");
> +	if (rc < 0) {
> +		fprintf(stderr,
> +			"%s: Failed write sysfs attr trigger_poison_list\n",
> +			cxl_memdev_get_devname(memdev));
> +		return rc;
> +	}
> +	return 0;
> +}
> +
> +CXL_EXPORT int cxl_region_trigger_poison_list(struct cxl_region *region)
> +{
> +	struct cxl_memdev_mapping *mapping;
> +	int rc;
> +
> +	cxl_mapping_foreach(region, mapping) {
> +		struct cxl_decoder *decoder;
> +		struct cxl_memdev *memdev;
> +
> +		decoder = cxl_mapping_get_decoder(mapping);
> +		if (!decoder)
> +			continue;
> +
> +		memdev = cxl_decoder_get_memdev(decoder);
> +		if (!memdev)
> +			continue;
> +
> +		rc = cxl_memdev_trigger_poison_list(memdev);
> +		if (rc)
> +			return rc;
> +	}
> +
> +	return 0;
> +}
> +
>  CXL_EXPORT int cxl_memdev_enable(struct cxl_memdev *memdev)
>  {
>  	struct cxl_ctx *ctx = cxl_memdev_get_ctx(memdev);
> diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
> index 8fa1cca3d0d7..277b7e21d6a6 100644
> --- a/cxl/lib/libcxl.sym
> +++ b/cxl/lib/libcxl.sym
> @@ -264,3 +264,9 @@ global:
>  	cxl_memdev_update_fw;
>  	cxl_memdev_cancel_fw_update;
>  } LIBCXL_5;
> +
> +LIBCXL_7 {
> +global:
> +	cxl_memdev_trigger_poison_list;
> +	cxl_region_trigger_poison_list;
> +} LIBCXL_6;
> diff --git a/cxl/libcxl.h b/cxl/libcxl.h
> index 0f4f4b2648fb..ecdffe36df2c 100644
> --- a/cxl/libcxl.h
> +++ b/cxl/libcxl.h
> @@ -460,6 +460,8 @@ enum cxl_setpartition_mode {
>  
>  int cxl_cmd_partition_set_mode(struct cxl_cmd *cmd,
>  		enum cxl_setpartition_mode mode);
> +int cxl_memdev_trigger_poison_list(struct cxl_memdev *memdev);
> +int cxl_region_trigger_poison_list(struct cxl_region *region);
>  
>  #ifdef __cplusplus
>  } /* extern "C" */
