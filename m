Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CDC55786B
	for <nvdimm@lists.linux.dev>; Fri, 19 Jan 2024 21:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.55.52.120
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705698506; cv=fail; b=YjTKtEDKkIyrzbCKQ0o+rQuzUrMs+AQu+zM1SRKPilv9AyA8nQuEPsauhmH5980smbYive6K6xrB25j6RzcsX7q1hYA8z4CHdluqR3XBf0UTWEyD08BRCWfDHoKMACqL51ct5JY0xe5YHSuRFfxSiKEUp4W1irM/5a2FwfH1acI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705698506; c=relaxed/simple;
	bh=UEyAsD+YW7fu0wcFPsGzSf8H3oxj4WL15GtJLt+njGA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ir08Rvt72Tc3f6aYwr0DkgWAiCHqlXAAvjnujD/hzYB70pTHAha3tpLXuPPoMHF3kPyvydwlnqDLLpBWqpYtb2Q9UtNOfYihWKgoKCNNmpI13Jhnz/X273MpYjno7qb6lWiIm1BmjeLjv3mv9dWtxsKYKnfue0D/fFQLOTYSYwk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Xhkc/gzY; arc=fail smtp.client-ip=192.55.52.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Xhkc/gzY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705698504; x=1737234504;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UEyAsD+YW7fu0wcFPsGzSf8H3oxj4WL15GtJLt+njGA=;
  b=Xhkc/gzYMua0csmcAXJV9ZKq4AfTULG1SKy/DtWFFVkvunH5ZEujJskJ
   0tAIOlezzfdb0fD0+7UxwAfhlI8hPjwOmmk7VETU0EtfqstnmJ4EFKCHv
   h604oH3GWmLP2kRIlb5zCdsaRWCc5dy5fCkesyK8cHfhAorR0D5FRBcbT
   qtSQDlnbp6L304WNEb+beITOLxXleA5nIRplCs4vj20CpDobFV+2U0Jpx
   Rk+xIQ2kAe8dwZp5DlOkChofle0AuJnmTwd3KLTr3ciV1WVtp7pkqUhT9
   p50Ar1STZU0oBrnxx8n1Yx4ZtO1cYbZ8w6iUsicFYbrYR/Zc2zgZiXSyL
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10957"; a="399714869"
X-IronPort-AV: E=Sophos;i="6.05,206,1701158400"; 
   d="scan'208";a="399714869"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2024 13:08:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10957"; a="855423578"
X-IronPort-AV: E=Sophos;i="6.05,206,1701158400"; 
   d="scan'208";a="855423578"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Jan 2024 13:08:22 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 19 Jan 2024 13:08:22 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 19 Jan 2024 13:08:21 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 19 Jan 2024 13:08:21 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 19 Jan 2024 13:08:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y1WxVwwrwKT51jTh2sUdtsLuG5VjwRnM7K7RcFMHw7kxkcXvTxFsxbXJM1R7FR55VCYegkrhOagiM/IRFlnD05oTUFDdDin6+SBDAbrNtLs4pGCo7+1COIOb89Ql5AOoJyFNM5ROrC6m8TTHTHmxTFTaUvrE4x7Z10WiMAP5VnHDfv7KpRtNOu/tGqtJ0EGc9TloQcJJR+2VvGMrss0U1iPWaOnGN3Keyh7qNkqKjSNJQCcQAMF+9MF/9vhjs1lG01W3q2/nsxgNfoW51KTuU3dbj/Uy5RuTBL1HD2mW20+d9jlBZtjPHlwaTNXGG05jkouBp4anuA8dMwyiDvhqRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QJ4kJXGAme3H6pPF0hEnX4SZRXjhziLCj1hvMr9xOpQ=;
 b=hBWIGbFSEaLs+jVfVKi/x2nbIKGaYH/QFZsFdKMKHyQmICwXVeZGrAHYuBBqAwDO/mlnqfjYELK0o9zAT2Tv3e6774DFzsT4qlCVW0EiCMujhUn4trbHQNW+lF3yfsPxE4T4oN83+9XkLHnYWyUcq8+BPZMnHjTYC0fPPgtA77uV/GnIMJxA3jtphu/b7bRvD2UPDxOnrsoSJQV9gd8JDjMacv9BpNej+8ZzqGcCwZCZA61j5DVAweJKGP7cknu3bOXixyB9raHVECUe9e8PeYznUxXWNTDZHH8Ni2LJ5H/47SA3lNoLqkytaEFxtkFuMdGDXCJeQBhWaS0OjCmgSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5984.namprd11.prod.outlook.com (2603:10b6:510:1e3::15)
 by BN9PR11MB5260.namprd11.prod.outlook.com (2603:10b6:408:135::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.26; Fri, 19 Jan
 2024 21:08:19 +0000
Received: from PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::780:d536:ff24:3e4c]) by PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::780:d536:ff24:3e4c%3]) with mapi id 15.20.7202.024; Fri, 19 Jan 2024
 21:08:19 +0000
Message-ID: <937beafe-a5dc-4537-98d4-ffd4af332d2f@intel.com>
Date: Fri, 19 Jan 2024 14:08:16 -0700
User-Agent: Betterbird (Linux)
Subject: Re: [PATCH v6 3/7] cxl/event_trace: add a private context for private
 parsers
To: <alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
References: <cover.1705534719.git.alison.schofield@intel.com>
 <e1bc45fa032226407dbc2f75c552f12f07c8c829.1705534719.git.alison.schofield@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <e1bc45fa032226407dbc2f75c552f12f07c8c829.1705534719.git.alison.schofield@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0003.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::16) To PH7PR11MB5984.namprd11.prod.outlook.com
 (2603:10b6:510:1e3::15)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5984:EE_|BN9PR11MB5260:EE_
X-MS-Office365-Filtering-Correlation-Id: 41a0b1cd-4597-462f-79cb-08dc1932c2f6
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Nq3WvbfgAU0w++UL2v+4vfxB9PGCZWIiVdY4DHUms+quLrp6LQYgeNG0zLFm0p/4pieqJV6wrB8ObFCJLI3rIbtSs2uI4zJ1YhiX8hZOEwIrqisE3ZIwvkekgejmnL8DhHfxluClP+UqeTKUzPL8NgpnbQqHZm/444kRHG01fHP3AjGBnYBbUajLelUGDLNop3aP2uDh5v3QBVUi5dYgg5z3WKw3FZEPv0Z3b4G2K6yCFshHcL3OuWSINK5dyywHgQyxOEN/dTRfSD9Fn1bd7UKjzmVlX6ZRb6z+3zgyt3syEPEUIqlFocRnU+/zFnvvP/6/lrq5VobjMRx93CMRTVi8lcy9EPq7bIHxQsM1APkgKL4UF0595YRrlfCVKKNLFXNPSGJWEPhjC/Oje2QY6SG6FKsK5YE7GZfVZDic/IOX0U8zFUpQdOPjQOOoH9FBoWkqVyWeDyk33XRJSVAoDKagkYP2ohDSoPhom/2t7NSRza+xOekQd9PFlTg2IPTp7NbsDL6qemj+QvLR20eAY9JUbmMHwCxQrBRyGOQJa25gzaFAXRhcM6XyGkgX6z+Cuwp5GDQUnto5YR6UpfqeO4uyd6N2tYmEKULUn3uUVJzxoCSl3GNdemsix46zWROt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5984.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(39860400002)(396003)(366004)(346002)(136003)(230922051799003)(1800799012)(186009)(451199024)(64100799003)(31686004)(66899024)(316002)(26005)(5660300002)(6636002)(2906002)(66556008)(66946007)(6512007)(6666004)(6862004)(6486002)(66476007)(478600001)(37006003)(6506007)(8936002)(8676002)(4326008)(53546011)(44832011)(2616005)(82960400001)(83380400001)(38100700002)(31696002)(86362001)(41300700001)(36756003)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VFhtMzJSWTl6ZGovVloxOXJVN0NZNkZVRXpveGt4R0hJTVBMT0Z5VUZ5eTRk?=
 =?utf-8?B?WllZeFBFbjBNeTJTTnlEUnBHd2tXZTRuRlF3NGpPQWNFczVTV2JiaUNTa09j?=
 =?utf-8?B?NFpWM2JrYWdYVHA2dzdXcGNZZ05hOUFoQmd6TFFYaE9Jc1EzamRHSWlpYUlp?=
 =?utf-8?B?cG5sU1ZaVW05dzJjZWFDN3cvSlY5OHkrVkNIMUxkemNMWlRsL3l3NXhUUmlm?=
 =?utf-8?B?L0o4Nk1VU0JWQ1BPUjJvNzBod0g2WS9tdmJXQWZxZGdjS1F6MGl1T2dlU3c5?=
 =?utf-8?B?NjZuNEZ3Z0tTQkF3ZUdoYm9NR1g3eXdEdkhnMHJ3Qkd2QUtPVEF6RngyMnIx?=
 =?utf-8?B?bGZPemN6a2VGMVpxcXhIVmUxNGdkdHcxUGZxeTFLVmNJUkdnM1VRbWhkRGp1?=
 =?utf-8?B?UWtzT1ZINXRDa0NGU29BWmhKdWNJQWJNSGxqaTUxRjMrUXR2THAxeEtxZjM3?=
 =?utf-8?B?U0w1aXE4K0NzWTVCNTlDRmoxdFpDdjFRTU5XbzZPcnlBL214VytiSE8vQW9p?=
 =?utf-8?B?ZitPczZKcVYvdGsyemlOZGMwcGx6ajNYMjJFT1U3V3YwVUdjWlZydTFIMWti?=
 =?utf-8?B?ZkJaWk5weGVQVWVvRXEyT0haZVdXYWRmeDV6TWkvN2l1bFpad3Z6UWdkUUx2?=
 =?utf-8?B?SWJ5c09ScmQxZi9sNk9PWnE1N2ZvMVBPRkN0czU2ZG0wcGZoYjdjUTNlZFMy?=
 =?utf-8?B?MENmMDlrQlg0M3NVSDR1b0JPdFpFKzMyUVhsRThkMHkvM3VqNDJnWUs2ek5H?=
 =?utf-8?B?ZWhpclF4cmJ3bzV2ejgySk5JWmFjNXNEYWJpMHFZZWsyRkMwcnRhZ1A3V1lv?=
 =?utf-8?B?YUNCY3NkQWpNV0x2anZMdWhXWUFjc3BGejhmejVtb0hDUzlDV3pkYWVGZ2RF?=
 =?utf-8?B?N3Y0Vmp4U1FMR092eHlUNTZVTUdmM05maXhuSlV2aTZyVDlPWXp6dVBEbVpF?=
 =?utf-8?B?aXZnQXJxKzZrS3ROY3dhR3ZtQXdSaEFBSjlUaTljZnJEdjV6VnNXdEVieGxu?=
 =?utf-8?B?MXpTT2NTSW1iMldFbXcyaHVMWU81TDhDMVp4ZHA4NUN6b09KSzBKTzd5Rlo4?=
 =?utf-8?B?TmQ1M0FCSklzWFdSQVdKSzdkMGgzUlBsd3VrbHNhbWlZMVdLYVpHWjcxN0Vt?=
 =?utf-8?B?MEllbE9DMmJxdUtkZUlxNHAvNXBxQ05RblpUQkdpL1pyZkxkcVJ2ZDljWHlC?=
 =?utf-8?B?cWRRQlVzOEVFRTMza1FtREN1N1hrSjJPYzhBZ21ENVE0aXg1NzhidkFnQWtl?=
 =?utf-8?B?RnJHaHZ4bjhJNEsxZHpEWFM1UmE1TGtDQ25WR2p3STUyWmNuVXd4MG13b1pQ?=
 =?utf-8?B?T2FPOGh2VU5NMWtWb09MQW1wUVh1di9KVEFOR0FwWHhlYVpWUXY2OEo1b2Fa?=
 =?utf-8?B?Q0J1Mmx3UDUrUlNOYUdpNDhCMGs1dUpPaXU0OXhLeFliYmJTUGNrS1hwOVZ2?=
 =?utf-8?B?dmpkMm82R0EzY2dRSUNTbVgyclgyNGlhRUVMcml0YVhIcGdXWVJrMm91MUtU?=
 =?utf-8?B?M3gydHVjcWFKVHN5c3E0N3pXQTVkcGFDZCtSNXRBcjJ2Rkl4RTBXcDdjWVlI?=
 =?utf-8?B?V0p2bnAxODVJT0sxZ1FqMnJLT3NLWTBqT3N6WEJwVmF5NlhXbldTdFl2aUtF?=
 =?utf-8?B?QTJlcEw0QUEyZm9YM0FCbUxQMks5U1o4NlVYSkh1ak1lenptdmVuQ0ZBT1E1?=
 =?utf-8?B?WGJiMEFUNVlTRTgrUTY1a1NrRVlxWThkcXMzUjNIbTEySWF3TWcvSEkyM09l?=
 =?utf-8?B?MnlEY0JEbTJUZVpkKzFYTFFva2FJZ3RhN1pvMm4ybUpCUjYxZm1uMEk3VS9u?=
 =?utf-8?B?WTFZaUVLVEM5YmIyRVFrcStlb1RhYzJhZlUzc3ZMeUg3WjJwNEkxWHlqZUMw?=
 =?utf-8?B?MnJLMzlHUGNHb1c0d09lOVJWSWF5LzlHWlJXd3pzTCtkTDJKYzRwL2pwd1M3?=
 =?utf-8?B?Q25SZGtTTktrdEp0UXUrTEZ0cXJ3K2IweS9SUzY1T2xYWVFqczM2bmtBNy9x?=
 =?utf-8?B?T0xKb3VkbldBU1VoUFNWZytpSFk1ZDN6d3ZiZ2pVNDhWUHZnM0MzSTdwU3Zx?=
 =?utf-8?B?RDZycUxETzV4bG1oR3IzQUpucStMcGsvNVdPSzRTdlNCVmhLSVRMRUc3aGR1?=
 =?utf-8?Q?t45nembGRM3M5pnuxTlqnYFaL?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 41a0b1cd-4597-462f-79cb-08dc1932c2f6
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5984.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2024 21:08:19.1830
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: urDNA1utClfq7uqHay/VOToyC37ip+dMjSzVg7T++Ib/JyLBGHNKxa6re1aR7bJoddaLT4YHg5LgluT7h6ECvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5260
X-OriginatorOrg: intel.com



On 1/17/24 17:28, alison.schofield@intel.com wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> CXL event tracing provides helpers to iterate through a trace
> buffer and extract events of interest. It offers two parsing
> options: a default parser that adds every field of an event to
> a json object, and a private parsing option where the caller can
> parse each event as it wishes.
> 
> Although the private parser can do some conditional parsing based
> on field values, it has no method to receive additional information
> needed to make parsing decisions in the callback.
> 
> Add a private_ctx field to the existing 'struct event_context'.
> Replace the jlist_head parameter, used in the default parser,
> with the private_ctx.
> 
> This is in preparation for adding a private parser requiring
> additional context for cxl_poison events.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  cxl/event_trace.c | 2 +-
>  cxl/event_trace.h | 3 ++-
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/cxl/event_trace.c b/cxl/event_trace.c
> index 269060898118..fbf7a77235ff 100644
> --- a/cxl/event_trace.c
> +++ b/cxl/event_trace.c
> @@ -215,7 +215,7 @@ static int cxl_event_parse(struct tep_event *event, struct tep_record *record,
>  
>  	if (event_ctx->parse_event)
>  		return event_ctx->parse_event(event, record,
> -					      &event_ctx->jlist_head);
> +					      event_ctx->private_ctx);
>  
>  	return cxl_event_to_json(event, record, &event_ctx->jlist_head);
>  }
> diff --git a/cxl/event_trace.h b/cxl/event_trace.h
> index 7f7773b2201f..ec61962abbc6 100644
> --- a/cxl/event_trace.h
> +++ b/cxl/event_trace.h
> @@ -16,8 +16,9 @@ struct event_ctx {
>  	struct list_head jlist_head;
>  	const char *event_name; /* optional */
>  	int event_pid; /* optional */
> +	void *private_ctx; /* required with parse_event() */
>  	int (*parse_event)(struct tep_event *event, struct tep_record *record,
> -			   struct list_head *jlist_head); /* optional */
> +			   void *private_ctx);/* optional */
>  };
>  
>  int cxl_parse_events(struct tracefs_instance *inst, struct event_ctx *ectx);
