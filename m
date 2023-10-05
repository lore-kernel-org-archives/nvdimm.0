Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09BD30F93
	for <nvdimm@lists.linux.dev>; Thu,  5 Oct 2023 16:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KhrTRn5e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696522611; x=1728058611;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1rQ1rvVTBtfgyUy564AhiI8AGUzerHnWrhQZj0sPZvM=;
  b=KhrTRn5e1UR6EXIH2hPpM4XqTdZYcL+SKoo3Is/dxLccLUCoZUV1ec3I
   OgzHY1SQqljIiZvBNkEMY0IkTmVQ7tKymMfBiGUMQzIy5zKRxk00O3CXl
   FFrSil8PGSDDqoTpFJnBx61nNzfQ4g2C0dqeLlXY6X2k7UAD2vthW+NeC
   O6vxcwr2tItpmFz/TYZn/N/eIKn7uQO8fiFKEK8x1tppP81USywK9wWrP
   FR0KIyZOm/5a6rlqg9QFlWYin3n7qcTx0spYlzfk+DmyG7JLywD1wP2Aa
   0dj6d4yOT5rtcXkWmaTD8RpcOP2gmZ7dkHTWv/XX0Ipxlv13oQctD4mUP
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10854"; a="362905511"
X-IronPort-AV: E=Sophos;i="6.03,203,1694761200"; 
   d="scan'208";a="362905511"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2023 09:16:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10854"; a="781299179"
X-IronPort-AV: E=Sophos;i="6.03,203,1694761200"; 
   d="scan'208";a="781299179"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Oct 2023 09:16:50 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Thu, 5 Oct 2023 09:16:49 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Thu, 5 Oct 2023 09:16:49 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.42) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Thu, 5 Oct 2023 09:16:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X/DgfrgxCGqMNDpA5I/ucz3EvTf/95WMunzbawx1ynr3xHVRO3WkCQU2oOtbZooRSAd+dxZnn9xBevoc8jPQQTkoU9zc1b9eWQX6A56sQmytlaa8I4n5C7Bgx+kJ0VzVsjPMAe9zZICMPXgjuxAM3YsQBEFpU39hZWenhQxGMDJ1uEB88Hpr+vom2B/rJ528FghIDHtZ5yBTcVBZVZ7hsunXqHpsAHANfrUsNrVfMei+/tgULM75oBUph8LXSfpjlwZOEhkF1nLHfAZP4J0TNPyXePiSo3XdaadDksUu6Tuxcm7Yv3bK/i8CfOVdyZTp+iDTM6R8uEjpSw3nUAJXCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kd0Ki2NncLYXSXh7w4kM5iMpL4CBWVHN2MWbN1eYoic=;
 b=H05jZ7lrzZoRKXdAkjBdDkWis5fgaQWVd1H9OZTKyjeTPh35HvmvL5fHWPkdz7imfLCPcWAhQD8NcyLyEWXuqGngyqZrLZdHIW9fXH1lMXqrV2RnklLjeGit6br2PxU7srBXtf08fUuEzmOffJlbYLFlL6JlVhmsq3aS9wq9Fffq/GVxKPi+5Z0tguh9jCChrgYAQQ45R2RDu0s+hTe80iDxChWVxfpaZB8yDo2ckDsah9XBOBm/Yiait4xaz/Ts5kTAjXBtJ4wpRS5bf+y+fM3gxGzSbJdPrK09RQGlpQMwMjFEyTh/OLQGwMqxfwHpJBHeqvwoc9Z1K8elv3sQiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5984.namprd11.prod.outlook.com (2603:10b6:510:1e3::15)
 by DS0PR11MB7359.namprd11.prod.outlook.com (2603:10b6:8:134::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.34; Thu, 5 Oct
 2023 16:16:42 +0000
Received: from PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::e9ca:a5a7:ada1:6ee8]) by PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::e9ca:a5a7:ada1:6ee8%5]) with mapi id 15.20.6838.029; Thu, 5 Oct 2023
 16:16:42 +0000
Message-ID: <02d249b2-fde4-464c-a5ee-bfbd2a4e5c7a@intel.com>
Date: Thu, 5 Oct 2023 09:16:38 -0700
User-Agent: Betterbird (Linux)
Subject: Re: [PATCH] dax: remove unnecessary check
To: Dan Carpenter <dan.carpenter@linaro.org>, Dan Williams
	<dan.j.williams@intel.com>
CC: Vishal Verma <vishal.l.verma@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
References: <554b10f3-dbd5-46a2-8d98-9b3ecaf9465a@moroto.mountain>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <554b10f3-dbd5-46a2-8d98-9b3ecaf9465a@moroto.mountain>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0334.namprd03.prod.outlook.com
 (2603:10b6:303:dc::9) To PH7PR11MB5984.namprd11.prod.outlook.com
 (2603:10b6:510:1e3::15)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5984:EE_|DS0PR11MB7359:EE_
X-MS-Office365-Filtering-Correlation-Id: b7e8f772-b8ae-49d7-4bd5-08dbc5be764a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h2fG+wE38IDUPJr4QlAxu0/zbt7/rlGFTEbXVQr0shVg2WzOYpUkcU2p/uE0PPqajUvUrzgovKYFeoA7jpOd1qOJYC/5FxaEvRnBxr86SUab4yTPMF20fuydmQZeezZvEbajuaWRMx7XgFSRXkcMNUR6dHmGeOFhLAW8pnmAFycrAhC7oismSRm3Tk2DPPZ9TqK4b0K9LmPB6DNbwotrgsTEFiPHjBE4nnKRj+C4kSiNN2StTzwZ2NeMtCAr7U+rAjfSHNMuze3BLDTN2iQvaP7pb+GQTQvKaNM1gbqXeMd328G1jh7WLaHDBftNk1nwI1KMU7tyxlrG4sHU/ZQ6Y/nBKyrjOqN34NHmQ4GAUgIf0gG27q4GKMbYHI4+wKRF+POitm64V44gUVltyZJwLm6FfDK9msmOdiHNYXbGrJS+iMlfGVtOBFCrgbEsS+s5v+/MOs3qtnKzDPHwNaoSg/TTRhhMUa8+0kZB4OAL6vPp9bJMCHFPDOzT1iC5vT4M8aY9xjuTVSeG/qpVl3TV+41SI6xgbB/0zEdkVTlfWmP5bHJMDtI26DUaqKBGovSP++ceT62mcfZbjk05fsb1LgThdl6C9G7YAa0ByYOwC0JOivJzeoR9eRIXCq5IP1Uq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5984.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(39860400002)(366004)(396003)(376002)(230922051799003)(1800799009)(451199024)(186009)(64100799003)(31686004)(36756003)(82960400001)(6512007)(6666004)(31696002)(53546011)(86362001)(478600001)(6506007)(66556008)(2616005)(66476007)(6636002)(6486002)(66946007)(41300700001)(38100700002)(26005)(316002)(8936002)(4326008)(8676002)(5660300002)(83380400001)(110136005)(44832011)(4744005)(2906002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SlhkajRGMUpmRTZ6RkMrZlpNbld5b3RQSWNTcTcycGJxak0wREg1SmxuOE5i?=
 =?utf-8?B?bnE5bEVQcG5wZzlpSVk1VTliUGNkeHlMTXVkb2d6SEx0em41NUJKVGFUYnFz?=
 =?utf-8?B?S281Q0lPUnB2RjdLOEpYdnhYajFoUWl1aFZuMmZKQzBuUGhFbU9MMHo0NytQ?=
 =?utf-8?B?UWlNcmZNVzZOUjlJRTVDUGpCR3JaWGlIbEloeXBtaTZYOWkra1U0TWZrVEE2?=
 =?utf-8?B?NjIrcEo4WDErM05lcnhCb3Q1SkwwZEk0UThiNVc4VVZPZElVVldRTFpESDlo?=
 =?utf-8?B?RVgrSzJLQjIzcXZHSzRhVWRJZktvMmxwUnlDS1BtKzBad0JCNThvb3J2cGZE?=
 =?utf-8?B?MENFMnUzdk0zNG5lcUpkMStnUGltalA2N0Vvdk9ycDNTRWZKMlcrNlBUUnN6?=
 =?utf-8?B?TjZ3RWpmTi9PL3lFY1FSb0pPbEFmR1JlQUE1RlNNZ0VCM2RmSnBwWXVGWFRQ?=
 =?utf-8?B?b0wrUFoxK1hyZXY3bkZBRFl1eWY3L096ZFNRbEtsc01MYmV3THp4YlJiYjBE?=
 =?utf-8?B?bnI0aFI4dXRid2VLc2ZPMWliZzBvMzVYSjdoSDM3OG1DL2RUYVkycnlPcllI?=
 =?utf-8?B?RlJlYlJOU1FmYjNWenVNK2ErUFBIc1pqcUN5RzRDbmpOQkExZyt6Z2Y1Kzd4?=
 =?utf-8?B?VHFnNDdGMnN5dlJKSnRDVCtpeXRjRGVBMWd4Q01Mcnp1UGFLcTM0RkhLMXFN?=
 =?utf-8?B?clJkT2VRTEJXbGd0WGdEZE1yb3pkMXJWd2hBS1c1UlVQQ2JlczNwL3ZoQ21k?=
 =?utf-8?B?ei9zbDY2UUxrREFySWN2L0dNcjFMQTVvbGF1WjhNbU54RjF1SkdsclJCTlBm?=
 =?utf-8?B?eVhIUXhxcDN3VnU2V3c4Vnh3Rk9HcVordUtxSEt1VmZHSFFCV21TTHJlOE8y?=
 =?utf-8?B?VnlQQWtwRy9TL3hDRE93ZVVFbStUNUIvYVg3WkdWb1hDajRadGw0NFVjTGh5?=
 =?utf-8?B?blRrS2Q5N2dFbEVwendMc2R1VXpHYkxJZUJCaDNnTTNGanZ5a0VzRkxvYnl6?=
 =?utf-8?B?V2JrcUJ5VjhrQkFUOW1tVXRuRUttV29sVStvdVAwNkMzUnY5VWNqMjBUUnlo?=
 =?utf-8?B?T2dDUFFqZjM3NGZtYlhkQ2trbTNBbGJFUnk4SnVyeGNEcGZOa3k4bzlVMEo5?=
 =?utf-8?B?QzJBTHVnV2dDVXpIRTJhRUR5bDlpM0ZCMmd6aStKREREcndialBjYWZhQ3N4?=
 =?utf-8?B?TDRZMG1YQWZIVkhVL0lnVnpLbHBET2Z6cmw2TnhCaStHUHROdlZjODVScUxm?=
 =?utf-8?B?OXRPSEdBM1BreXVCNXJ4dDBLL1FtTmdhVjd5YnZCSmVnZzBJT2hzb1JPZWho?=
 =?utf-8?B?TFNjcnNuY0FCM21aK1NXTkMxN3NQZmtzeTkybXRJNlF3SjZFeVBJalN1Y3Zi?=
 =?utf-8?B?bldLaHBNK2p2clZZdXZGU3BWZUx5ZUdmOU5EbFdydG9SWnBwM3Bla0NWUGFF?=
 =?utf-8?B?OVQzL3VzaWliZHZhM1RVQ25iRzBya2lyQms2L040NE5maVFzU2NkMDdVL0tl?=
 =?utf-8?B?S0V1RDZXcFJ6QnBqcXcxaXNtVTZWRG1jK3dGS3JqUXZCbmw3dW13djFYQTEy?=
 =?utf-8?B?c3MzQkYxQW5uUEcwWEMxbGxNenUxaDlpYVFFYk5Pc1l3UEF5NnI5V3Z2ZG02?=
 =?utf-8?B?YzFDQkloVmlnQ3dwVjl1R2Q2alRYUzRCZ0VsVWsrZzM0cFFOUUdDZXRWUWUr?=
 =?utf-8?B?ZHp1bzZPcXFOMmpkV2pRcWVDY2NqY2pQNVN3UnpwRnE5YXM2V3ZOaHVHQVdP?=
 =?utf-8?B?VWk2VWV6ckd4TXZoUk9qTTh5Z1hiOEJpaUVoOElCUGJiNVBJb25QWmEybWtH?=
 =?utf-8?B?YVFweE1yTnZMUG1uWmVzbU9XbkwyazIydVZxbDJsUHRqNlBNZWtWYUJSU0tj?=
 =?utf-8?B?cTlMWUthSEtmQ0N2T281VjE0SHpRd0hHdzVNTGhsWFgwOG9CNVcrV2NJQWZL?=
 =?utf-8?B?U2ZKTS8yV0o0VmhXb0RKYnNBM3RRZVhKYUpNMWExTGZrSlF3UDBZUnNNRHBK?=
 =?utf-8?B?N09UWlBkSytJd0NqNmQvOXdwQXdDU1JvZDdpMkt3Ly9lSnFMckxNTXNJVTZU?=
 =?utf-8?B?Qm8wdGhJZFhadklXcDg2alkvdjk0cUsrclZ4SVhGZGRmbE1kWUVybkUxRnU2?=
 =?utf-8?Q?S0vyq8+u0pC5q+IazSyeklKr+?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b7e8f772-b8ae-49d7-4bd5-08dbc5be764a
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5984.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2023 16:16:42.4086
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 36lp6AqGJiC+JTgqVQv09nTOw6SfmnkG8q9OVn8BKnqfUr6/Kcr9R8KphuFwbvxg2OYiwDyNAO3TBrkEQ1iknw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7359
X-OriginatorOrg: intel.com



On 10/5/23 06:58, Dan Carpenter wrote:
> We know that "rc" is zero so there is no need to check.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  drivers/dax/bus.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index 1d818401103b..ea7298d8da99 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -1300,7 +1300,7 @@ static ssize_t memmap_on_memory_store(struct device *dev,
>  	dev_dax->memmap_on_memory = val;
>  
>  	device_unlock(dax_region->dev);
> -	return rc == 0 ? len : rc;
> +	return len;
>  }
>  static DEVICE_ATTR_RW(memmap_on_memory);
>  
