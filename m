Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E271116
	for <nvdimm@lists.linux.dev>; Mon, 25 Sep 2023 22:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695681456; x=1727217456;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=x73eUXT1xpPhOrJ8+vQ9eirV91BC2ig19LMO9xFbFyg=;
  b=UlDxQGsm6zeSv0hcN52D8HmLV2/ESzdOWdmjRQp5pLzVdGrgFlGrSkQU
   WBJ6k35CSyVVBBRs+OkzUvVVt9kTRzga3GvmFQ+Fd+rv1vcZVqghFQQq6
   E8wSlFQZwJk02EU3bVcRdulVhWs4JomW/B2VGLKe9/IjQHauWVgyxiy+f
   zxtREBv+iL3UxLFzdrbCzC9mjtPwU0IoQCNzVXQW8bDu3jFqYP3zpiiBd
   zRu3m8/1otccLLzYF5+X42QIriezmXDqb+oaKhtecK9XtkRN1fvUncjAL
   TH6qh0XzDfAy9hprjJUBytxV3ERYHedLbVX/Eg5DzuxHQqGotGkRYktmt
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="467711071"
X-IronPort-AV: E=Sophos;i="6.03,176,1694761200"; 
   d="scan'208";a="467711071"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2023 15:37:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="891945322"
X-IronPort-AV: E=Sophos;i="6.03,176,1694761200"; 
   d="scan'208";a="891945322"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Sep 2023 15:36:31 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Mon, 25 Sep 2023 15:37:33 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Mon, 25 Sep 2023 15:37:33 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Mon, 25 Sep 2023 15:37:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H5y/Un0Dc+MVTh/8J2BU8qEqsLIz4yup2T+0UYVmgchvsKfxPe29Q0NVgdcq5VpJ0GOIflgMv80C/cp9FIw7RVu2KDSY3nb06R529UW8p/gk1/zkoy4PMvdjrTpyFBt+LZgkCI2Qk8Hkq1NaveiK+s60e85LX/hrsw0AEmWOoR6HatjMrmQQmaVqHYoj1wd8BDEj4cuMuqpwb7N7cgG/6IouXgar1eIkMVEBYq651edjie3d48OEv1HtYyBFB7ef4GXu9lJyMwiA9YA58opyeJtNyYm2VG/CSwf3P8CYK4P3ZXZH3xCc9SKqGwjcVc02856WhhTa4hd3WYLbZOSuuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WP75zjC62stsvMBcSqHYvLgYMgYjLn+fpa91KSPuyXU=;
 b=mR+KORxEUuvsaGKxRHIRTXx23QXqYXXzTxaULO7og8igtGx49sYYM0+DqMD14aagOCZdlzacLgZT5iIgzq/pMwNvkmezuwJjTShdY1IVjkxEPykyBEsNmG+39W3d2lIlOHlDNZ8tbkU8MLhiUTOVM19oAZpERqnqX6RJSswQdCX2pJ2jdPV6IdU7mSC1yYM7PpOTlMUDSbKpzHPRVxu6wuJup9UGo0yqDYYHLAUSWIb1mb4PQm+U1zweQ+nvSrjBcU44YMW9o8byDpqM4uSbznHLTUFnSD+4vHE1chKW2MgE+MeoAdT6Ck49KxnQpPNA8mZ8pY5HUylDGXc1qk9K5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5984.namprd11.prod.outlook.com (2603:10b6:510:1e3::15)
 by PH8PR11MB6706.namprd11.prod.outlook.com (2603:10b6:510:1c5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.27; Mon, 25 Sep
 2023 22:37:31 +0000
Received: from PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::e9ca:a5a7:ada1:6ee8]) by PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::e9ca:a5a7:ada1:6ee8%5]) with mapi id 15.20.6813.017; Mon, 25 Sep 2023
 22:37:30 +0000
Message-ID: <a2f7c266-6bfe-d7c3-f0b0-f926ded6925a@intel.com>
Date: Mon, 25 Sep 2023 15:37:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Betterbird/102.13.0
Subject: Re: [PATCH ndctl RESEND] test/cxl-event: Skip cxl event testing if
 cxl-test is not available
To: Ira Weiny <ira.weiny@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>
References: <20230925-skip-cxl-events-v1-1-bdad7cceb80b@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20230925-skip-cxl-events-v1-1-bdad7cceb80b@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0203.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::28) To PH7PR11MB5984.namprd11.prod.outlook.com
 (2603:10b6:510:1e3::15)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5984:EE_|PH8PR11MB6706:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ea13bb9-6f29-4ce2-be65-08dbbe1800c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qfzDw5JmzMpHteAd3RaWbeYP0tCrp6WN6XCqHd7tYvhDhM0gT8CpqpF6F14mIl12o26+PiuXZu9CQRQw9A4yRwyyK5k4+mFLyKbx9QcC3bxpMRczyfe6fc0ukEglyB7EPlOgCSrlOXtUNWoqjhLOYSbYS/0tx7/hXKIniEbwUxelHOXbJZnnAjdirUddwUXvSS9L5gpeg92sgmn2v5ethAF/K4JY8nDeGh3maVKjSQUbJOd6+2BC/5UWxKOA2w4wbvGiiiGUQUZhtRiez6b1cPFYasy0VjxsIM2uuOA8GgPRdojzolkUvLezmckq1eUcyDTTagXS0MuW7uqr+rbP6/sZbDxbL4M1RAiJakZ3w3bQInnpnHS6zkWvIVwJR2XqmWZ+uKyJqo+d6QBJYeg7uKoCpuBGrOit27OJCcphWyYauxkIFebX0+y09guKkgJVkyEyf3J1NwdcXc+yoNVwojAv+iHsFrupR6WM3tjMd5kINyK7/C76QtPWne6p8hCk3Q/TFjg/5rEZbmrEuA6y+qg8ojLOtoCaBVhUeLtVyRBrV3mMGkpImB1SRsM025PlTs2I8px3iXzRc1S1AZ15b/5vcbDUr1UInngbe9tVb+E8UhkHOY5x+kOAmksV6etCPFSUdZ35mcq8wdrA6WWmHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5984.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(366004)(136003)(39860400002)(376002)(230922051799003)(451199024)(186009)(1800799009)(5660300002)(66556008)(110136005)(66946007)(31696002)(44832011)(316002)(66476007)(6666004)(86362001)(6636002)(31686004)(38100700002)(82960400001)(2906002)(36756003)(41300700001)(6486002)(53546011)(478600001)(6512007)(4326008)(6506007)(83380400001)(8936002)(8676002)(2616005)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YW82dTRyRDFCYkQyMFhMQXpLZE9MdFE3VVpZTEJMVTh6ZC9rV291QWV3T0Fn?=
 =?utf-8?B?NkQvNVJsWjZMMWlsKzlQTUMyWHBsbng2VWlxODIyZTNVdnRhSUF5Mis3bmNQ?=
 =?utf-8?B?YmZQVUg1MXRKdFMvZDFIVTQvUEc0TnY3Z2liRlVzMVlpblRUM1FNREF4UXor?=
 =?utf-8?B?cG4xQjFIaitJUUE0UzJhaUdOcTBZMDcxSDVkSnZtWmZLRTFFdVZXVmZ6a3pT?=
 =?utf-8?B?dEZnRmkwRXpKY2VHNUxpWFVBdFhPU3hKVDFHMGZaZG9GRTQ3RlY1aHRTU3Z0?=
 =?utf-8?B?b0NtcFBCaUxvT3FFb0RBTmVFRnk1SHgrWnE2d1ZIQ3R4NVZGMEkvRkc3djlJ?=
 =?utf-8?B?VXlJMzVXcXNGZ2ViZWtZelZXbVhERXREamRYellRdG5FWDg4R0czT3lqWmlu?=
 =?utf-8?B?R0NKTkVXQUJZYnFDM3paVDVzeHZsZ3hWVDhYQ3RLZU52UHc4aUJETGhHT2dG?=
 =?utf-8?B?YXVIWnNpMnh2OEJ1NWY2WWVqdFZUVUM5Wm5tL3pJazU0VVJ3ckM0T2VzTGEz?=
 =?utf-8?B?TlBLUGRiNmNCMmpvRE1tL2xnaVUzZHY5b21DWFIwZG4yVHZuNUoxZFB1NVpP?=
 =?utf-8?B?T3lRWHp6UTdwWFc4QktYbmFESjdvMytJN05XSjh2M0lSc3dzeFc2R3IxNDdG?=
 =?utf-8?B?Q0dkUGI4MFlqbEd0cmJSaktqQ3JZTjZGdCtGNCtZbCtJTjFyQklXNFVCL2dx?=
 =?utf-8?B?SEM0ZlNqMTdiN2hSTUpGN0tQUnVWL3pRMGxsaERRL0hwN3ArQ3RKVHh0eEJp?=
 =?utf-8?B?cWtPbkZRVEFNQkhyUDhCSXliNzllM3huVnJTd3JCWVpVY0VZb2RxMzNUQUhw?=
 =?utf-8?B?YmRpVnpqUGZaaHo0Rmh0NGF1c0xIZ3ZRSFlYMy9GVG43b1dwakJVZnNlUlI1?=
 =?utf-8?B?TXFVaktjQWp4MWJCZC9QR0dBazltcVdPNUR1RU91bDRPMlZsM1M4VlQ2ZGZL?=
 =?utf-8?B?dXVGc08vSDJ1MGExZkpIZXdYWTZnTkFsTlA1M2NUWjZQenFETVcxY0Zia1dK?=
 =?utf-8?B?ZUJlV0dTNGZqR3czazJWY2Y4VWtTQTNqR25PWTd5OGVFaEpzRDg2UFc1VmlS?=
 =?utf-8?B?MkFxZGU0V1pYRmdXYWIvb0ZpOGdVWndoYlk3NlNPRWNpZWVrR2xrYmJjaVQx?=
 =?utf-8?B?eTNYaEpMaG9iN01jR1RqeEV2Q2NwRTdKUkQ4U0RHaXRjOHVUOTBsR2JNK2Jn?=
 =?utf-8?B?MlZWVDNHUlgrdmVTNVZRYnd1UFlUVllhT0xuVS9rTC9RUnFFdW1OeFc1Qlg1?=
 =?utf-8?B?d2xWVVF4ZHRPak51d0pEWTRCZE15ZU1IaUpnRHVhQlFxU3B1ZDRoNFlxVmtY?=
 =?utf-8?B?QkJPdEpYYmorRGkva281SnlPOFkrTDZzbEI2Uk9UVVJKcUdEeWFsU3RoRXk0?=
 =?utf-8?B?NVlkSGlTSDM3d29CK1VOclVtbkJkclRiVlNrY2Fodllad1BGRUpCQk9XWEdU?=
 =?utf-8?B?ZkZ5M1BHdlJ5YjJWUS9ORUpVOHdRc1RDT3dTSnJha05tR0pMQ0ZVSWd5SnY0?=
 =?utf-8?B?ZFVNU0hqeVBQekFwdHlkMzFjRnhOalVOcjVkR2hXQ2dmRVJPVGJXMHdPUEsz?=
 =?utf-8?B?b1ozS1ZpYmdCZERLQ1hBTnV6anVDYlJSc2xDZ1lPY0xTRCtJUUJ1cDZvcHZQ?=
 =?utf-8?B?N2pYa3VxbVdRb3J5eHdJME5NSDRTNEdFUVhNcHE5bHNtNG5HNGJwK1NJOFFU?=
 =?utf-8?B?cU1GV2dmbDJ2SzdsMml0ZDlSRktOUnNWMzh6aUY2bm9sd0Qyb2Q5c21nRVRL?=
 =?utf-8?B?OVpTZUF6V2hHb1lSN1MvaEJwbXJjdCs3Vnc0TU1JSGlKUzdMdDBtc0FhSFhL?=
 =?utf-8?B?UnoyMHhuUWI3VmFCZ3BNYzdwdlRuNWxJRnc3UHNSOC9CSDI2S1RDbTBYSmhW?=
 =?utf-8?B?dGZ3YVFuN2ZUOWpmWVZwd2tHa0lmTllkZUg5U3JnMzI4NUIvb0l2eDNPV21q?=
 =?utf-8?B?ZUgrT2tBVFJrVUNZWVJtVktPTVl6MDRHTmJnRlNSbVdhV2d6Qk1uSmdRdis5?=
 =?utf-8?B?K2hWRitIY2p4UUN2WWRlMmRsRHdBME9ENStZMzFoTDg5K3lBamZEdDVhVnRv?=
 =?utf-8?B?YUlGYTlGK1dMUFhQQ2YzSGRHOXZUNFppY21RMUZMUExqTEdpTmk2MWVPenYr?=
 =?utf-8?Q?6tnq9h5/CefyeylprhUgq/vaO?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ea13bb9-6f29-4ce2-be65-08dbbe1800c3
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5984.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2023 22:37:30.7016
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2WuiE0cSdKFw51zBU7KHxZQsM4RAaWLF1pIrTsL8y5yARoM3pjWVEos6s4simKQbcq/dsI5IrZCQRnNX/yCJVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6706
X-OriginatorOrg: intel.com



On 9/25/23 15:16, Ira Weiny wrote:
> CXL event testing is only appropriate when the cxl-test modules are
> available.
> 
> Return error 77 (skip) if cxl-test modules are not available.
> 
> Reported-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
> Changes for resend:
> - iweiny: properly cc the mailing lists
> ---
>  test/cxl-events.sh | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/test/cxl-events.sh b/test/cxl-events.sh
> index 33b68daa6ade..fe702bf98ad4 100644
> --- a/test/cxl-events.sh
> +++ b/test/cxl-events.sh
> @@ -10,6 +10,8 @@ num_fatal_expected=2
>  num_failure_expected=16
>  num_info_expected=3
>  
> +rc=77
> +
>  set -ex
>  
>  trap 'err $LINENO' ERR
> @@ -18,6 +20,7 @@ check_prereq "jq"
>  
>  modprobe -r cxl_test
>  modprobe cxl_test
> +rc=1
>  
>  dev_path="/sys/bus/platform/devices"
>  
> 
> ---
> base-commit: a871e6153b11fe63780b37cdcb1eb347b296095c
> change-id: 20230925-skip-cxl-events-7f16052b9c4e
> 
> Best regards,
