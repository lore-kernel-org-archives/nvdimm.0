Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF31200DA
	for <nvdimm@lists.linux.dev>; Fri, 19 Jan 2024 18:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705689337; cv=fail; b=mouZZEpeI9hZQlqAT0+EurTq4MNO+rlPOv/Z54nLFHn0R7YT2xxeLvk+GGWvrQud0oHCIAJhEQpBKgtUE+ylrgY6+leDt51sHfiuNNaSgsLDtIoRcMFTkqy7a2ufW1rtL/MkzZDRCB068jU5qMwMacTJQOIRcAhbzeq4MfXrW9s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705689337; c=relaxed/simple;
	bh=cUDGZ5buYzFVxoLqcxydEfx6q2pfDdTZfLpkD5Z9FgM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GvgxTvftteAOy1phbxNcEFMvNL2AxBE9mVEX+hpRRkcQSnASV73NuAfwBYHqUYFUuf8YcA1orou+CxkZOVvO7XZdFyzGhi8qEqhR4gFBKBzcmRk1Ypfi5noNdD/lG9DzHKxdcRqzjGHY7ephw0LPMaqKzGPnU1VTPjcQevRfiCs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XMMnjtCY; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XMMnjtCY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705689335; x=1737225335;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cUDGZ5buYzFVxoLqcxydEfx6q2pfDdTZfLpkD5Z9FgM=;
  b=XMMnjtCYjiAv7/8vrAn1/yVLFfOOUEn20uD+J8wawLDpA/xYXBB0aPMk
   Xu1472FGS6YCH+ogD9pJr0dyw+x0ZyiVIxkt+yrWibZggJkSXKkjxOaWW
   Np3UPDgQoSrTsdRRUBwIV4jqIZj1Gtxg3fEvR+XO8T7l4Mno+k5NwRQQI
   YWmo6V3Dr/sH2zKzun2rAJ6n627zEHYAepHgSQk9pggD7GQq7L8iu/xYU
   52N/cPoKo4tGYgOzRo/YZP4pqM1Cutza/6iVvFkGLxj/Gjs59gmBNBnmU
   FBlduCRHgQuLB2/5zsW4iAZ/f360gHbfUCjcgoO4xMAZ5h/JkoJSSW3+F
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10957"; a="7567452"
X-IronPort-AV: E=Sophos;i="6.05,204,1701158400"; 
   d="scan'208";a="7567452"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2024 10:35:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10957"; a="908386024"
X-IronPort-AV: E=Sophos;i="6.05,204,1701158400"; 
   d="scan'208";a="908386024"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Jan 2024 10:35:33 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 19 Jan 2024 10:35:32 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 19 Jan 2024 10:35:31 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 19 Jan 2024 10:35:31 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 19 Jan 2024 10:35:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TdxOOSBjMvIHOGvMz1wSnXqXNE9w6TBeHXaEmsANRy0jfOovHlU9E4CZ+gQ+uaeRR07GCt/kgDD6qg8ZHCJJnwgdsz7wNvNsYJB+8GJhMKySBh6RwGR80FavK1MmtwLvSNEBEkOIsC70+07dslBl+uiiSBtgYr7ElY6Cb2rz/j5Il7CQgDGX7iObgDplhZjcz8zHfCOYuzfbp8g2UbXRI8cQmsbQoZCIpO57FUnxBnba3emDVtH/uX5Dzi/OVz8l9kZmpMtKC3lVtpvq9VKjpAc6FTbQ+nVx5NXxUGWFpTA9ait5rQ8QZ2j+nBAA2SipdqOHMjTVZ/3rBu2gDCozww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tOOwqrUTfP4g8qdHIBO4ruxlCXJHyxRYH6GrYP5+A8k=;
 b=VnInI8RMb6+yc1bsiAOkFtztOw7Xiy0BAtsKDTBxK5ctw98BFEwXSiTm3XBpxBzsp1EwBe55Kn7QpCq+FuVV4kPpf247p+AJemnCoiY9aq2cyoEO81ScxVlUQlgaLz2aZDafjC+p7GWVm+SLKY/X8b2Hr0+YIy1ZrYRP5/BXwe5+m6HCN+Is+8nil2LMWT0kNctQMMJ7D+xXKwoBcATNGK5om4gsZQdHXJronEPfzjpB4YVJ3k0arkAmb0Hg/aolzXWEFf9UlF5wtyaNYbgbVpo6nX8j/F0wFW0TOyedfNwPvTzI/mj8AtgyHAfypryX9hD9UJQhbBq3LtsDlvRujg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5984.namprd11.prod.outlook.com (2603:10b6:510:1e3::15)
 by CY8PR11MB7035.namprd11.prod.outlook.com (2603:10b6:930:51::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.24; Fri, 19 Jan
 2024 18:35:29 +0000
Received: from PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::780:d536:ff24:3e4c]) by PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::780:d536:ff24:3e4c%3]) with mapi id 15.20.7202.024; Fri, 19 Jan 2024
 18:35:29 +0000
Message-ID: <3fadeff6-3074-49f4-9a04-f1e5ef79c962@intel.com>
Date: Fri, 19 Jan 2024 11:35:26 -0700
User-Agent: Betterbird (Linux)
Subject: Re: [PATCH v6 2/7] cxl: add an optional pid check to event parsing
To: <alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>, Jonathan Cameron
	<Jonathan.Cameron@huawei.com>
References: <cover.1705534719.git.alison.schofield@intel.com>
 <77d576abb7e7f9badbb0c117935ad1bcc74899bd.1705534719.git.alison.schofield@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <77d576abb7e7f9badbb0c117935ad1bcc74899bd.1705534719.git.alison.schofield@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0076.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::21) To PH7PR11MB5984.namprd11.prod.outlook.com
 (2603:10b6:510:1e3::15)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5984:EE_|CY8PR11MB7035:EE_
X-MS-Office365-Filtering-Correlation-Id: e14dd7df-b7cc-4db7-4c6f-08dc191d6969
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /PrRmBeGQU5S+sDGdYWxm1vmdhqr4cEy9l66ePgZ5T+roEANvy1eJ69dKvMYo3IZhTMuQnHhjlJGXJXEYgB62g0hE2OeY2TK5GjGIfO9dOfOkgZLbx4l42jNrvfS/TlW6R6yYkqzwM5qjoZKrL34GWtIVgFCwJIp9USDnPSHxOi9Xhqu0E5vKj9QNMnfpq8tvSVCZQjZl0C5i10jaGrltaPiLrkAiaYtX4lPgIiR82Wp4YewqzdA1W/EwMbxgUhBD3YZGCaapdExBjX5tyYrlldeb+V0UXYLIToNUac/Vrne21NRvemdAPm+52it/M5SoGIxw073c3WbhqqCrzCdyWzwEHEvkY506BpKOc0UoZNNj3w2v+6q8XEbnRMSSvzFfhXXwkk11EvrNZ2L/1WNxvnz8eYB9LDiJbq79xmNys5QR1jXx6zO74O3j+qqlINL2Qbawlh2eqDGaidodRINehhPlfyQgG0G8thhIASes/huR2n/xNvRoWM77im+ia1Y3r2HqPDUJUl+0ROLLqGb0IkKNxYnEsnJ4FPo/8KnWeje/X0yLTO5Y70D2M5lDH6V6HtF1r6Xd/LfdCMvJCpAzbk7ziGm7btPaJ0kIX9sKE1UHHAWlezQAilv3ez4n4/t
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5984.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(136003)(39860400002)(346002)(376002)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(8936002)(2616005)(6506007)(6666004)(53546011)(83380400001)(6512007)(44832011)(6636002)(86362001)(316002)(37006003)(26005)(4326008)(66946007)(8676002)(478600001)(6486002)(31696002)(66476007)(66556008)(82960400001)(38100700002)(6862004)(31686004)(41300700001)(2906002)(36756003)(5660300002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RE1ndDltQzVhbktpZk91UE56eU9lYkFIM1hIc3d3Y05JTFJJQXhFcmoxeTJI?=
 =?utf-8?B?QzR3STVLZTYybnhzUmlhYitIYTFISU5FK3UvUkxJTjdNaHNrb25lbnRuNVkr?=
 =?utf-8?B?dzFhSjJleUxXZjdreFVwNmFqNkN6dEEzMGVEbVNLOXpPcUU4d0JlcXlzZFlO?=
 =?utf-8?B?M2ptbUhkN0kyUEJzOE1XOUtlMHExTXNnUm5Za0JRYjI4QTBkOWltNVlISHNx?=
 =?utf-8?B?R0RUbDFRbzZoQWlUTHEyVVlMc01lOThVemo5OFZuU3ZkTXF5VkZreTE2U08x?=
 =?utf-8?B?VDFGYzg0azVibmFBalFvYVNpcStPOVpybXJUZ05vbnlBY2wzLzVjQXk3MnVB?=
 =?utf-8?B?aWNDWVNGbTM1QlRnSnZHTXhNWDlPd3ZKMWc5U2dBWDg2N0p3bC9uZ0pLTlh1?=
 =?utf-8?B?ck9nY2h3cmxQK0N5RXNNdmFvTU9PdmFEalF2cnluc0FLbncvT3dabWZwSUFO?=
 =?utf-8?B?cFVsS0daeDBUTDA3cEtJRGE5ZmJURk9SOWhQWVJlcTh2YVRMeUlwd2lkRDcw?=
 =?utf-8?B?VnNCeis2NTJCci9zeXdmNlR6RHFpTmFlYXBaYnRsM05nMjhzcGVlV1phbkFz?=
 =?utf-8?B?MVJYSFJ1b2xmY1lIUmduVVpMeWdHeVZ5SDFLblVya2o4R2ovYU5zeFV2K2Rk?=
 =?utf-8?B?UEhQdWthTStJYVhPRFJIL1NWZzN3SXUreXh5RElscy9haklGZzRHZjYzczh4?=
 =?utf-8?B?d0JhYURoeEVqOWt5akpTMDlMMFRxV0pXckh1dFYvZ2J3c2cyQ1lhNVY1ejY5?=
 =?utf-8?B?cTYyVHp0NlFRTWVQTlBEdWhxRkRnZWVOOVV0YXhCbStxUGNzWm9RSUlydThr?=
 =?utf-8?B?ZUxVUnlzMnlnVXk3QzdsNUtpNyt1VzlCT3lJT3FHTlp1ajZLeE1xVE9JdHZO?=
 =?utf-8?B?VCtNbFZaOStDSzJUT1dLQlA1bUtmV2x0eDRjUkNoYUxCa3dLMVU1M2s2TXlo?=
 =?utf-8?B?MTRseU5sb1g1VzZ2cm5acVcySkZxRHd5cEswRXhkc1gwT1NpQVQvY01xcm9X?=
 =?utf-8?B?YXhVZERndm5nbkU1TXVqSFNHL0p5OWFyNXRNRnJGKzJVbmRwL2tVS0tISy8w?=
 =?utf-8?B?ZnBJR09NcXhreTBzNmVEakM3WlNINW1FUm5QLzR6aEZxbHJ4dmc3ZStPUU1O?=
 =?utf-8?B?TW96RmFtY3pVWjdjYkRLeDd0NWE2bWkrVlM3b0NSTTk2SDhNU1BuaVpyYnJo?=
 =?utf-8?B?TXZsZUpYUGxBcllzS3RJVllFWVJJQitUYnFDZHQ3OTBOdjlKL2Z0WnNEc3o2?=
 =?utf-8?B?S09DRkxFS3N4a2I4dmJkUVdHT3BXMXJsZzhpR0MwbFJaQld4V0N1V3h0NWRj?=
 =?utf-8?B?aUxxUWk1NzRFS1BySTZvaGs4aGh2REY4eWlFMSt2MEdOazg2MVZ1SG9VVjV6?=
 =?utf-8?B?Z25oTVVmUjFjcDFsczNHOGJqdzBsUVZGZ3B4dVNvTVdqazZERXhlV2JXSnRp?=
 =?utf-8?B?Skw5Zm1UV0NKUERzQzgzQmlnRUxUOVN4WmNXeU5KMHZ0amVGVFFDcWdHSkc1?=
 =?utf-8?B?VjlKaW9XWHk2SEFudG9tRWFjaE56LzhBTjYrQndtWXJ3Wjl1dkhKbDlBTFA5?=
 =?utf-8?B?Yi9meTBNM2drdnVXMlBTS0NQMWJNbHllYjVOc1dmcVgvNGowb1FIUUx3VHoy?=
 =?utf-8?B?cDRxWU1OckNYWEVoK0tZNXlweU83Rk5ScnBheDl0dXV2aG5SdUI5eHQwUFhS?=
 =?utf-8?B?L01lcEQ4cXJEWlY2OUh0WXBua1NTVmJsejRLejY0SmpvVWRQUlhRbitMaUNp?=
 =?utf-8?B?Zjd5WmFoM1ZjTTQwcnQ5N3hMUDMxZVZVQ3dvamRtNUpBZW1DcnFzY1M5S01o?=
 =?utf-8?B?N0I4QnYyN010MXdkWkVINXRvNUUvYXhETU1kRFl1VGtYci9qd3d1S01iY3Bx?=
 =?utf-8?B?UnpLekMrdlA4YVNnbnpaQ0V3SjBMZTZFeU11R2xqT3BKV2Z3dVp1UElHZnM4?=
 =?utf-8?B?RmE1WDRSSTE1dWpLbGlIZlJjRWREM3RkRGlqZGl1czBtR2kwT3pkb0JlV2xD?=
 =?utf-8?B?U05HT0dDWHdXV0NlQzlwT0kyRVpQY1N3czhTeEc4bnlPWWV4UzNwNEppdEtD?=
 =?utf-8?B?WCtRaVVaY1NFcTMwL3U2K3hzelBRNm80TkdrTUZjUnQvU3lOZHNDL0FzU1lB?=
 =?utf-8?Q?ePmzel6ENFaBtPt5WpsWgL4bZ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e14dd7df-b7cc-4db7-4c6f-08dc191d6969
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5984.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2024 18:35:29.5007
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pUUMx6UvdcunaIcKWVphyzpT1ygI29Sti1U4lzq8quR2Lj7kHMzVZ00geYehsK5lvOA5c690UJzSHAHWWPOLLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7035
X-OriginatorOrg: intel.com



On 1/17/24 17:28, alison.schofield@intel.com wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> When parsing CXL events, callers may only be interested in events
> that originate from the current process. Introduce an optional
> argument to the event trace context: event_pid. When event_pid is
> present, simply skip the parsing of events without a matching pid.
> It is not a failure to see other, non matching events.
> 
> The initial use case for this is device poison listings where
> only the media-error records requested by this process are wanted.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  cxl/event_trace.c | 5 +++++
>  cxl/event_trace.h | 1 +
>  2 files changed, 6 insertions(+)
> 
> diff --git a/cxl/event_trace.c b/cxl/event_trace.c
> index db8cc85f0b6f..269060898118 100644
> --- a/cxl/event_trace.c
> +++ b/cxl/event_trace.c
> @@ -208,6 +208,11 @@ static int cxl_event_parse(struct tep_event *event, struct tep_record *record,
>  			return 0;
>  	}
>  
> +	if (event_ctx->event_pid) {
> +		if (event_ctx->event_pid != tep_data_pid(event->tep, record))
> +			return 0;
> +	}
> +
>  	if (event_ctx->parse_event)
>  		return event_ctx->parse_event(event, record,
>  					      &event_ctx->jlist_head);
> diff --git a/cxl/event_trace.h b/cxl/event_trace.h
> index ec6267202c8b..7f7773b2201f 100644
> --- a/cxl/event_trace.h
> +++ b/cxl/event_trace.h
> @@ -15,6 +15,7 @@ struct event_ctx {
>  	const char *system;
>  	struct list_head jlist_head;
>  	const char *event_name; /* optional */
> +	int event_pid; /* optional */
>  	int (*parse_event)(struct tep_event *event, struct tep_record *record,
>  			   struct list_head *jlist_head); /* optional */
>  };
