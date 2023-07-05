Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F272D313
	for <nvdimm@lists.linux.dev>; Wed,  5 Jul 2023 17:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688579217; x=1720115217;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ymrmtZkmYBqVgX8YzHYM0Sdm/9wwfJoACnmg7Vp8p4c=;
  b=BLeayZXT2Xy+iQYliOHbehBtVCiB+/1uTsHcVMANhx+t2iwiU2ZEwx+5
   u2nDYoOBGIGDpdfOZVN8zQFuNh0KHUrXM0tv0S/Gp83Hca/1HQaieNl7W
   PM6N0rxkEmNBSatdBxeLofjTmeLQu1stpb791Wp+EVxOCeh+eW+0/HC3N
   xCWJ1jf0zPebjW23eJSPy6LEDWUb60VWKw9ce5wCvEt7KLPGN8cPDNbNx
   CInFCcoDRotoAzB9nTC+XbMWcTv2eGuA14pJh9xBgfEgsf5IGxOGgbRJS
   5g/QLPb2gNhiIfIXU2oVSST1fLQi0yBG5p8ZEhSQcUDrycXCthIIIOIxj
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10762"; a="348192849"
X-IronPort-AV: E=Sophos;i="6.01,183,1684825200"; 
   d="scan'208";a="348192849"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2023 10:46:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10762"; a="1049796030"
X-IronPort-AV: E=Sophos;i="6.01,183,1684825200"; 
   d="scan'208";a="1049796030"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 05 Jul 2023 10:46:56 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 5 Jul 2023 10:46:55 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 5 Jul 2023 10:46:55 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 5 Jul 2023 10:46:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NBeI9l+OoVYxQAuBaPaZAnxW1ksy4WSp3QaaG9fG0e7/Cff3NrE1ncZvT8kjG3UrmoBWFo+vx3Ia9t7frkKp1AXd/jhj662W0EssuO/zEDxJScUh2KtIfXos7Z5t7SOBwV39OyeNWlbMNj9RC46+/9aXESF/d/mATYNJuGFSNtH3MaNSbQiLkmtBEqjLdbXPAJvwONfrqZYEUoHSOFBIY91uJenCvs5MlufOMFq9lFrDAJ1PDtJOSZDOcoYEvrdwBWi22Il0+weF8Hqf0vfb/ywtTmJibmXVlVVi7K6IQl+Ana9K0LIP+qy6odCHOsHOrwvAEr+pMQ78M8w/nPm8/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=99BYcb7msCxTtsFxSwxpvZd5MaaltQOLCLE3nXjZyvE=;
 b=AyjTpUK9weOL8yXFyd0J9NLVLme0BablUazzCgix0RrjsGlBZKENACQML6kAFVGSu71LVJ92TgUDUqjAYXKkEkCZMRhhpcdCXsgQjqHaM2OyuzdjFeqGIKKGDSZ78SlA9dl3bnS5rU5lVUwoQCb+kxqbtVoEd5yWXWGONMQfd3TfGOophG2uvYaSOxO41rS1zs/y6u9KRBv/qeb0P1oDuIfYS+C/S0Ytrl8XlU+p3n5iFKkrt9rJIQ1W5xKFp/MTDaVcohCXsYnS3klAkPxZ9qavxZUV34+opivHseR+X05DnIfYFwNAE1N0QGeVsdIqtdtS1+KWZJn3ifcMu1+etA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5984.namprd11.prod.outlook.com (2603:10b6:510:1e3::15)
 by IA1PR11MB7320.namprd11.prod.outlook.com (2603:10b6:208:424::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6544.24; Wed, 5 Jul
 2023 17:46:53 +0000
Received: from PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::ef38:9181:fb78:b528]) by PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::ef38:9181:fb78:b528%7]) with mapi id 15.20.6544.024; Wed, 5 Jul 2023
 17:46:53 +0000
Message-ID: <d38206ff-e889-f69a-0d50-1df671818f77@intel.com>
Date: Wed, 5 Jul 2023 10:46:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Betterbird/102.12.0
Subject: Re: [ndctl PATCH v3 2/6] cxl/monitor: replace monitor.log_file with
 monitor.ctx.log_file
To: Li Zhijian <lizhijian@fujitsu.com>, <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, <alison.schofield@intel.com>
References: <20230531021936.7366-1-lizhijian@fujitsu.com>
 <20230531021936.7366-3-lizhijian@fujitsu.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20230531021936.7366-3-lizhijian@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ2PR07CA0015.namprd07.prod.outlook.com
 (2603:10b6:a03:505::28) To PH7PR11MB5984.namprd11.prod.outlook.com
 (2603:10b6:510:1e3::15)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5984:EE_|IA1PR11MB7320:EE_
X-MS-Office365-Filtering-Correlation-Id: b5dbf6e0-60eb-4e66-c460-08db7d7fd183
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h1oMyp4De7fQXu3CWVNALy8MJG6efCskpUoZ0ja2KVIe4a+xO6QtOKoI27PlGQ5mlIbYn+BW9dLphUU0wG4apOwSYplfeX4nbn/uwDHxu3Ym8/kmA6Snkrcp9x3QwczpTUcHgEDScTvZ3OxW5uAmEaRE7glzrEsB4SmG82PVQouh/5BGbzK3xpC3zc1OLPJMhxcRSYVYST+k2uLM7vbwasetF/MCuU5SToQ74HJvyG6oNyAddRvbwsO1mayBKoDjMixhvkvd9DKUl8igit1ant2B3K8yl1REWshBU6Bh65wsJWe9cspFAnpcY4Nmt5TjJmGXuklQYyC6/vcxQmT/EiHd8HWhug6kCApZ439CYWrW9VJ0WDTbZN901oNgVC0mOntQ7W3tmHjwb1R8BJaxfeOwIXQCsNLEH2GRGxLYLolr66g10fEUpRhNWhsMXAiE1NLkhGJa/I1FtDkaarZmo81MWGHX2xIjuOa+oS4rl/c/F8rlwbR5tES3rlrfGgLmrshZo+k2+v4/eb1c3UjAlUL0hHFd7JMEiX1U520IQkAD5V6R2MBfQWnsX4Z2TxpqIGjydhsEYD2L3obziMLbas2DnR7OUXVQIg0Ervle5isZKC/7MjE6b6nXRWFDv1Ex+Mlbx1lcmhsrclkL5/xk2Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5984.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(346002)(366004)(396003)(136003)(451199021)(41300700001)(26005)(38100700002)(6486002)(107886003)(2616005)(83380400001)(6506007)(82960400001)(53546011)(6512007)(31696002)(316002)(36756003)(66476007)(66556008)(2906002)(4326008)(8936002)(8676002)(86362001)(186003)(31686004)(44832011)(66946007)(5660300002)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MHMwTzlxVVYrZys5UFNadXgxSHJUN25kMEJuQndpZDViUE0xYUJVbENMV2Mw?=
 =?utf-8?B?RzJGdkJSbHNJSWlaQUJ3c3RvYTEyc2ZBSjlpRnlxT0J2NWJhN1JweGtyNEIw?=
 =?utf-8?B?Nko4c08rZDVkcEc4Mm8vRkJkN1o2UE1KMEtPdFRKVWZkZkg2S1BESC9YVWZN?=
 =?utf-8?B?VlBqeDB6SVRmYzBPN3djNnZTN1NSazBhSmtxem94SXdkaHcwTEQ0YmEvRU0r?=
 =?utf-8?B?M0FBMFh3VlpKZkJKbnZQNC9kbUxRQjVGcC8yVnNjNlQwV05Db0lHN3pvaDJ6?=
 =?utf-8?B?UEIrVFVsc3pTMU1rNXhuQkphZVovRTNlY2EyTzhKQWIxNW1BV0hXQWRWaWp6?=
 =?utf-8?B?WUYrSFoveTJxMkF0TmZQa0pkN2s1cTJjcHRLN2tYbjBlWWZSYlg4c3g5WkRF?=
 =?utf-8?B?MGJwYTBVTC81YTZmb05takdzS3p2bU1yRk5FaWw5Ulppd3BmbHoyMDhwc3ZT?=
 =?utf-8?B?a21OMmQxK3JvMHgyQzBDNWY3cFB1eHpCWmxNV1RkVFZFd2dMY0RKajdreXdS?=
 =?utf-8?B?Y05OSDU3RElDWkRTVkNLUUt3RXNTNFVTWFU4M2Y1K0hrK0tuTkRUWU5mQlVC?=
 =?utf-8?B?WUlIRS9EcGppaTBZOXZ2SXAxRjZBb3RMNGxhV2MrOG5NT3RCWDdvQWd4Q2Ra?=
 =?utf-8?B?eXVxSUNteWNIclBZZ2ozUW9HNWQrR0pBb0U4am9rMHF0OEdNWXh0NWpQNmhE?=
 =?utf-8?B?Qmc2Rk90WWR6VUVwQzZrTjRmQTRienpzRUJCQnkxaE83aTQyOEhCZVdNTTk0?=
 =?utf-8?B?dkpTUExBRXhXQWEySDRMbUJIWDg2ZndXbTMrWUJManlCTVRBSEFCM1VIMlBS?=
 =?utf-8?B?aG8yR1I4SnlsUXBLM1RZcUxKRXMyanU2d3JLbisxQXowbkhlUXpPdWtROEU1?=
 =?utf-8?B?ck5qVXUyUXliQm5vVm5pK2ZQOHNqaEY0RUtLTjJtT1FGSE9hbis3ODZUMWJB?=
 =?utf-8?B?RThTTWlaYnhEQ3NZNzNQOUtiTEdRdkhiYStpQkVOWFU2NDd3SHhxWGVaNWZk?=
 =?utf-8?B?YUljQU16U1RidXFKR1U5QUJ4WFdzZW1oTFRudTd1Y0FBeC9vQ2NMeXA1cmpy?=
 =?utf-8?B?SFFoR2NRN2RuSFg1ZXFQT3hSMm5PcGNxWHRLQmZzcjZLRUZPZi9rdTlQVTA0?=
 =?utf-8?B?dXBzbjRpL0VBQ0lRY0hpZnprUm1jbUF3S1Nzd1pjK1htQjBBcmg5eEduczM4?=
 =?utf-8?B?UlB5RHVLRFFwTzNWVDVramlBYlVmS09IcTQyRDVVa01FOTdndlZOL0tNcldP?=
 =?utf-8?B?UGs1TldkbTIyb05wSlZlYU5nQzhZbkk3OHdkN2FsTTg4R0gyMDArelF5dGFD?=
 =?utf-8?B?dlNldzZkMmFMU1lSM0grRWlpZ0QzSjhCaDE5aisrajBBc1l6NFZvbkRlcXBl?=
 =?utf-8?B?Y3dadVRiREN3N0RPMmxFWW85eGNibHU3U1pMSzBEZ1NtSmdHT1ZBSXd4eEpm?=
 =?utf-8?B?alVFK1ZEM3c5a051QnN6Vmd3OG1JUEVkTXo2R2RzancydjZMbXUzNCtwVERJ?=
 =?utf-8?B?d3piVEE3dWJwd0dZcFVsdWpHdFRTUTNuaUhpY2JDNVJoRGJJelM1cVJvb1Nm?=
 =?utf-8?B?dXhxdUR3RnRERU1ad01VNWdJWFdrT1NPdUpFU3grOVErbFFwV255cUUvalh3?=
 =?utf-8?B?Mm01QWk5NnphQXhURERsNHE2UnhuM0xTbkJjTmFhQXQ4SlQzQ2dFZ0RtWkFl?=
 =?utf-8?B?SWoyK3p2NjZnc3h0cFREUkxQTlQzcElQaUpjRVBlWFRBTlJzcktmK3FkZ0M5?=
 =?utf-8?B?aFNwVmNkYTNWbHdIanYzWkYwK1haN3lVeGsxT2JHTWdiWnllK1FPb3E4Y0Ji?=
 =?utf-8?B?YnhTYjlkWlF4ZUpyUzk2d2cxUFlCMXExZG5hNVpwa1ozYmY3VE1tU09oanpQ?=
 =?utf-8?B?UlZJQ29kcmRQemRsSUU1T1BsSW5URzRGSkFtM0dHdkQzMVlRWEJLeG1MLzUv?=
 =?utf-8?B?dHZybmd4dE9mdFNYeW1SUzF5SlF4dnB5ZHhOY3YyREkzVWVjL3JVRXJpTTFW?=
 =?utf-8?B?VURabUpkWFFaaVhuUFJDV3pNVU9rcm9XdnZ4S1FuWkN2T1dCREEzNGVpRlFR?=
 =?utf-8?B?S1cxOTh1cEx5OWlWTGdrVk5MR1hVSUU0QXZGc1k0YW40WHAzYSsxcktMbXov?=
 =?utf-8?Q?OhB9fbR8OlfONUUuIUfM2tHC9?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b5dbf6e0-60eb-4e66-c460-08db7d7fd183
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5984.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2023 17:46:53.4957
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: upMxOeLp9akiqRJuc1QDYdpVaviRrZOGx2mTodRVqhMF133bORMXLuJ5pKLHY23iHc4HhUL/sCv/31NXC56fdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7320
X-OriginatorOrg: intel.com



On 5/30/23 19:19, Li Zhijian wrote:
> Commit ba5825b0b7e0 ("ndctl/monitor: move common logging functions to util/log.c")
> have replaced monitor.log_file with monitor.ctx.log_file for
> ndctl-monitor, but for cxl-monitor, it forgot to do such work.
> 
> So where user specifies its own logfile, a segmentation fault will be
> trggered like below:
> 
>   # build/cxl/cxl monitor -l ./monitor.log
> Segmentation fault (core dumped)
> 
> Fixes: 299f69f974a6 ("cxl/monitor: add a new monitor command for CXL trace events")
> Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
> V2: exchange order of previous patch1 and patch2 # Alison
>      a few commit log updated
> ---
>   cxl/monitor.c | 9 ++++-----
>   1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/cxl/monitor.c b/cxl/monitor.c
> index c6df2bad3c53..f0e3c4c3f45c 100644
> --- a/cxl/monitor.c
> +++ b/cxl/monitor.c
> @@ -37,7 +37,6 @@ const char *default_log = "/var/log/cxl-monitor.log";
>   static struct monitor {
>   	const char *log;
>   	struct log_ctx ctx;
> -	FILE *log_file;
>   	bool human;
>   	bool verbose;
>   	bool daemon;
> @@ -192,8 +191,8 @@ int cmd_monitor(int argc, const char **argv, struct cxl_ctx *ctx)
>   	if (strncmp(log, "./standard", 10) == 0)
>   		monitor.ctx.log_fn = log_standard;
>   	else {
> -		monitor.log_file = fopen(log, "a+");
> -		if (!monitor.log_file) {
> +		monitor.ctx.log_file = fopen(log, "a+");
> +		if (!monitor.ctx.log_file) {
>   			rc = -errno;
>   			error("open %s failed: %d\n", log, rc);
>   			goto out;
> @@ -212,7 +211,7 @@ int cmd_monitor(int argc, const char **argv, struct cxl_ctx *ctx)
>   	rc = monitor_event(ctx);
>   
>   out:
> -	if (monitor.log_file)
> -		fclose(monitor.log_file);
> +	if (monitor.ctx.log_file)
> +		fclose(monitor.ctx.log_file);
>   	return rc;
>   }
