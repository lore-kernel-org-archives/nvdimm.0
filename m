Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55BA72B5EE
	for <nvdimm@lists.linux.dev>; Fri, 13 Oct 2023 22:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YVnwih3R"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697236034; x=1728772034;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2wMtvS0kTunnpyiJrKTxmRjsOYJ9bk6nBjowbncuJo0=;
  b=YVnwih3RU1btYH0KrCydztPLP3tlTLqFCm1+jkLJofO2AlSOcf8zOgio
   o2Yz2sQUNY7d7zq057WDf30VmQ0ExWfI8TwLZnR/seCU7Y7BK7rfF/5j/
   1zP2F54bv8udPHXWztJ0LBHwfStE7+YJm8oqLe5zUV4+jTx56rXYnBpGV
   jj/NRIWbs03wPGPbYGMC2WIVkCoUE1h4xpb1oQmhMp9EN34WUyF8JfIE2
   PevyuGeHvkGG8rENwaR23Za6TLBXyrHJzlL4YhYKKv5aUAutAiKiuuORX
   Lc3pqfIjAp2Co50S5A26IVxaf5Yk0z+34vc4DAyoAKXL/0sZVjQVl1qlJ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10862"; a="382506929"
X-IronPort-AV: E=Sophos;i="6.03,223,1694761200"; 
   d="scan'208";a="382506929"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2023 15:27:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10862"; a="825217883"
X-IronPort-AV: E=Sophos;i="6.03,223,1694761200"; 
   d="scan'208";a="825217883"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Oct 2023 15:27:13 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 13 Oct 2023 15:27:12 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 13 Oct 2023 15:27:12 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Fri, 13 Oct 2023 15:27:12 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Fri, 13 Oct 2023 15:27:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kBAZK4lEQoof+Z/JD0BKgSrRH7rde7tV74PfVkKoduzl2m/pixerNOAirBM5rXJ6kxgK49B6TpvQ29b8pvGD7mhbETysPrh5e9bXLdA24+fQQv7VPQ5H6Tq1/qRt9oob6oOHLN6iO7WGur5P+g6/FW0TUsnbFNuPKwVB6xf2gDRdA/84GPdZC0xmcoFVGWclJhFBRi+oVA57mRASpo5p4Ej+sVh0OBJy1H3KaHPCVmMPadNA52UzoszQlEYl6sNuoQjKhStT0XajTQJhvpWHf5wF9CEtXzFbVE+jhY1OmpCRqWIZvGYyrW8fRtEPf+CpC0socEjTQ7DocrdaGAmXbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K7WP5ishp7C8H6/4sdVcROIv1av4KIvJZKCPc0I8G60=;
 b=AcIH6567op36fsFbOALinYxs8mLzVv16+DCYoNDB7qW5PNjvXlm20YvkLa6p2qxNcp0a50u14YeCirZcjITuo8+G8MVpp8rsoVmzfxHBmtqNxx1Np84fhnrgGERmZudZsddNsn7g0onk/DUWT0L7F3JGfAdBcIA1bLTucDcOpnJzpH0CAHZ9vmnrddndpRsQxEgJ6B9p1Ewz10l7xfk+x2Yw/z8foOTwEPaeLSkFJle2JznEZcvDlP8OorbhRB5IlXQeTrhiX6086zxHSaezkwBB8DdM5emdFEDKSszAqGw5F4zVVkvSN5bR2Moyop2sMsbRZKD2pM3p+Wnj32sL9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5984.namprd11.prod.outlook.com (2603:10b6:510:1e3::15)
 by IA1PR11MB6147.namprd11.prod.outlook.com (2603:10b6:208:3ed::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.45; Fri, 13 Oct
 2023 22:27:10 +0000
Received: from PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::e9ca:a5a7:ada1:6ee8]) by PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::e9ca:a5a7:ada1:6ee8%5]) with mapi id 15.20.6838.040; Fri, 13 Oct 2023
 22:27:10 +0000
Message-ID: <dcf0a90e-5b13-48e4-af89-e6a08e9139e7@intel.com>
Date: Fri, 13 Oct 2023 15:27:08 -0700
User-Agent: Betterbird (Linux)
Subject: Re: [PATCH] libdaxctl: Add accurate check for
 daxctl_memory_op(MEM_GET_ZONE)
To: Xiao Yang <yangx.jy@fujitsu.com>, <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>
References: <20231009103521.1463-1-yangx.jy@fujitsu.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20231009103521.1463-1-yangx.jy@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0248.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::13) To PH7PR11MB5984.namprd11.prod.outlook.com
 (2603:10b6:510:1e3::15)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5984:EE_|IA1PR11MB6147:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f2be395-7694-4e8e-ee94-08dbcc3b8a95
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hLalvDeTpXrHwBoXcaH/ignCpxMAOf/8YLme+ZxJUFKi0YmCyoi0RVQY0dE/k/beVTCEIgk21WmyfbYzddD+VTrtSS7RL0v+67HCHZXZ1VaG+TnHjKc8zCVYKb9vhBqFIiaMNr4aJ6kcGVptDWIOu8wa3YDK+tzTSrBUdGdIAnH4cFBAUem8ihrNCgBQgHq0fzO2P1jD1Lq1A/G3K56O13H+Sz0yZRMzhu1EXZUtn4438N2SCDw5/Ojt8hkX/vd/gaWoEiB/mCtIMd4bgTRQGELBOnbqPlQc4iwxH+sNEOqfByOJfSdnu1CsVw/OSU4SBHFtPIDIlzkscOGyKNmrhwhmSc64gYcmt7fqrXKih8pk7ubQ3ZdO7Q347bu/809T3I9YjRUa/c8dLnYqFPJxYp1mlI1du839sAvZG3e1dNkr0JRPQfjZzmapAl5PdvbfvamfzQviM3gyq9eR+mi0qGr5540o1Dh9RPOAdXutkfBkQ2zXRpGqVGTd1FJgtBvTGnivne5DgSTC2N8OnjSMqE+GIWAIwFGnanvxmos7XOounWqisrKAHBSLTn8qjBZJYnKHRkJhpiLnMWUlBNhM149oxUuKbG0UrSY/Q5tbTr1nCs7ZzuPtFLqvJCSuauZp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5984.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(346002)(136003)(376002)(39860400002)(230922051799003)(64100799003)(451199024)(186009)(1800799009)(5660300002)(4744005)(2906002)(86362001)(36756003)(31696002)(82960400001)(316002)(38100700002)(2616005)(66476007)(66946007)(41300700001)(66556008)(26005)(6486002)(31686004)(83380400001)(6512007)(6506007)(53546011)(478600001)(44832011)(4326008)(8936002)(8676002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bHQ2MmpxMmYxMXlmZ3loRzNhZnBlckkwTDNwT2gvUFZXOXpTZDdjY0xJallO?=
 =?utf-8?B?UDFpb1pHRXE3OTZSNENCai85YUVxZzE0a2tkS1p4eExFYjhPcWs2NE9UQVQ2?=
 =?utf-8?B?VU1RQ2NLeDZicVFFZ0NjYzlma3p1c3BVb1dUcE1ITXZjeVZ6STFMYnhNRSsw?=
 =?utf-8?B?WFViQ01nVHJTV3JEaVFkSTlWcTdLR1pZREJDdWdabUk5WXBVbDZrL1pKUmkv?=
 =?utf-8?B?ZlNjblV0M3g5MVFhMjArU05aeGJaMnNrUndIVTk2NVRZajRkdXFhSkdrQmxi?=
 =?utf-8?B?a01xVGFQRTR0azR1RnlNRWZnQ215ZW9iSG5oVTlFcUZvQVYxWFpkSVBYTFIr?=
 =?utf-8?B?VEtZK3c3TkxnQXRTcDBRSWFTR0RVSGFJVEFaa3AwTGtiak9jbkdvTE9xZkYz?=
 =?utf-8?B?TmFhMEFkNmZmcVBhZzFOUjhrZnhxN1Z1cWlpV0I2OGpja2lxSjUzWko2dWpx?=
 =?utf-8?B?UG1ZelpIZFZrbHVSOEFMdTlNK2ZjMW92YXRWdnhoZktxdkxEbUpZQWRyb3FS?=
 =?utf-8?B?SGF2LzhLVEw4aDFaaXJ0aWp6OGdDbWMrU3ZhMDFCZzBqTVdZdlFkcTVncnhh?=
 =?utf-8?B?VWMydU44U2FwZlFIcXlSNkZvSEVQMGg0SXFFajRtdUNmZWhNdTRXVE1rSXpH?=
 =?utf-8?B?ZVRrSXVkZG0yNEpNWWtKNjc2MU85cktWN0MyTk1MSUtoclNKUjkzTnFnOXR0?=
 =?utf-8?B?bitFS2xiZ0gyY216eE5hU1Z1SiszRFpabGsxZWZ1NzdIbUowdmlabDBpNDJm?=
 =?utf-8?B?OUhYUGF3VjdzZ2hVS01sbyswV0xURzUvaWxyUlNUaVhqRmRzNnhKZDVpOUxv?=
 =?utf-8?B?aGpmRWtIL3pocXZWNnhIWmtleVQxbDBkbE1XV1JXcXduVWpYaDBYM3RtZDc3?=
 =?utf-8?B?WWMwZDdXVVV4L3JLZGo1OFpJa0VQQjNMR0F1TWxDWGdvalZDRk11VWEyeFZi?=
 =?utf-8?B?ZlV6RS9tRVNYM3hqZ05panRONzZKT083RnZJUzl2a0U0WXEvaFI0eEI3bHdn?=
 =?utf-8?B?Q2ZjTG5hUEVsdHEzendEcFFGcFpHRkh2M0dlMzltZmRXV2VOczhXRkRMbm1D?=
 =?utf-8?B?V2VjSm9TZVZoVnR6VnlrS1l4T2tob3R3UUVGRzFDUDlnRVI0a090TUhDWmZW?=
 =?utf-8?B?TExiSU53ZFU0aU5pMnlybFlxeVhGcjZJMXVyakMyUjB3MnNtencwRWsvTDhp?=
 =?utf-8?B?RTNxRHhzV0V6VENrWU1NM1VMNGtXVnBOR0NLaHpzWENpRGFkWnUvbTh5bkRG?=
 =?utf-8?B?aS9JUkg2d3JlbGdQd2o1SEtwY0UyVEVDb2dQdTFKSzBEVjdsZS9BNkNHVmNu?=
 =?utf-8?B?V0FPeDdDRlZEYVhOaVVPTFpweHRDV09HblNZYjdWSXIrdTRCL3NRZFF5aUNO?=
 =?utf-8?B?NWVvWXRKN3BKSCtTUTN4OC9zc2QyY3YzNklIV2dYRm5zT1YwQ01ZeURJOFlF?=
 =?utf-8?B?NzRsQVBHbjBDT2NCdUpZd2RJQWx5TjV5UmQ1bEU0Rm0xWnZ4OXBMbWM5YUIx?=
 =?utf-8?B?Qk1PVmlseDZvNVZtd3F5UW5ZMFBqb2lIbmltK1c3NFVYdlVGMWpjUkxJMDNV?=
 =?utf-8?B?UXE2a1RZTW5rZUl2TGZObkY4a1luV3VVbWZDVnd2SVgzMENOT0RVc0hBcWpU?=
 =?utf-8?B?RENWMVBZRVBhQi8vbGNIN2M1SWJHa2ZCVWptRmp5UjRtdFF2cG0vcjNGSjNT?=
 =?utf-8?B?TmJQYlNvTktBdEtyNXVBSDVtQ24xcEtMMVgrSGREOG9lcEZhblpRTUNCSUZa?=
 =?utf-8?B?eDMwd2ZqMEduZnd3alZZUXViZFBUOURpQnVyRFlDc0dWaXpQNXh5bGVJK1dS?=
 =?utf-8?B?Qlh6NTEvWEhtTXpnNktWeWs3SnR2THF3U2d3MGlnQ2F4RGlhalFvOHBHYjhW?=
 =?utf-8?B?NFJLM0xWaXRpTmJERzdOZDF4MTNyQW9RNW5NTlNKUjU1QXRoN0ZPNmVKOElp?=
 =?utf-8?B?SWlUdzRuQ25KZTlrTlJuSGI1U1IvaS9XNWNZV3BGTDhNRXYxTndRc3VERHlJ?=
 =?utf-8?B?K0t4UHVBWFdIOGZKUnphdk54NDNPejJwUlpZRHVnQ2Z0UDJYKzk5OWtXTWI4?=
 =?utf-8?B?YTBZRksvenRGNHhYZzUxcXBpbmI2NWhMUDFTZ3JMWFI1emxTWHdSMVpJaitN?=
 =?utf-8?Q?d7oVi88BczyCKZgEGJ/BTZhax?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f2be395-7694-4e8e-ee94-08dbcc3b8a95
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5984.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2023 22:27:10.5140
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LNC+OfksNVfwmUALCODebSfWKY2810mPEs4biflOKyRWUSWzm+z6BX9EIdkoB6hAqslhXRHRtzKC9tA3NTtATA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6147
X-OriginatorOrg: intel.com



On 10/9/23 03:35, Xiao Yang wrote:
> The return number of daxctl_memory_op(MEM_GET_ZONE) indicates
> how many memory blocks have the same memory zone. So It's wrong
> to compare mem->zone and zone only when zero is returned.
> 
> Signed-off-by: Xiao Yang <yangx.jy@fujitsu.com>

You are correct. Thanks.

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  daxctl/lib/libdaxctl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
> index b27a8af..4f9aba0 100644
> --- a/daxctl/lib/libdaxctl.c
> +++ b/daxctl/lib/libdaxctl.c
> @@ -1616,7 +1616,7 @@ static int daxctl_memory_online_with_zone(struct daxctl_memory *mem,
>  	 */
>  	mem->zone = 0;
>  	rc = daxctl_memory_op(mem, MEM_GET_ZONE);
> -	if (rc)
> +	if (rc < 0)
>  		return rc;
>  	if (mem->zone != zone) {
>  		err(ctx,
