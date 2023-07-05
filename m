Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7692BD313
	for <nvdimm@lists.linux.dev>; Wed,  5 Jul 2023 17:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688579156; x=1720115156;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OKxqNfA7xCknJGFrwaDZhJ7L1G7RukwO87A8JjnSHg0=;
  b=BO95f3c20IVvXuB3Zct5RKLd8do+Wm+i6YVsGQjzBpD99H/8aAm9hqhj
   O6VYUk7vd50IaXxLUSeO4v+GB3MH60JHKn55uXqeQmLPoEG/gPTcEzsyy
   JjQd1oFPskf1m52k6NdoRX35jYqANlAR7mLcHQgX+FlHPTKyXJOXF6NZC
   okJkGFA/QLbI19+QinsrabBQkWG9qogPnyAQNlpL3qdP05VQEoJg5KHZP
   vXzdmnRyQ/am2GktfnDz20BVAWyxuGYSeBYMNpGYird9W/hhfGyUt4STL
   30MovLBGUiPsEwPbIhqu8YjyCC9pa740FmbH/6gPDjWqOolLaQvIGjqa/
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10762"; a="360877214"
X-IronPort-AV: E=Sophos;i="6.01,183,1684825200"; 
   d="scan'208";a="360877214"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2023 10:45:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10762"; a="789240991"
X-IronPort-AV: E=Sophos;i="6.01,183,1684825200"; 
   d="scan'208";a="789240991"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 05 Jul 2023 10:45:55 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 5 Jul 2023 10:45:54 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 5 Jul 2023 10:45:54 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 5 Jul 2023 10:45:54 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 5 Jul 2023 10:45:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UuCt5OMODVwhLNoVSfq5Y/3xY9Ij+/GnI+eX7vlNmzLl27uu3g4QYJPhfmc2HBaGA35ycqH2TgwwityfweAdndu6vAH2NQ5h3g+x8ILbLgk73RoJlg8itfGfir/ZFFDzKHg2pPI5qR2WSQuQHYoeRtWL5YKQ+jGDrVYnklAK0PukcWhI5vfvNYT9lIQOMOgBNcHTI4NdhSzq0djnfWJb9xj38HZi9/gbbv2Fv+fcvc0WxOnu9xPBluw1uG7pZ5fSqzbfqTVMfQtYcH82YryReC5bjJgQLM4NtRReQCyeUV6h3mNrt741MtRbF4gtmfD/ZqLMhHuWBWQm499MtEdeTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MxFY9IeuibQlSbBzrWhBU6EH4mQV8BEMQRGn9DmTB6M=;
 b=Piy3eYghyx8wzT6lEcUoN2hoCw7oXT7onvtOIOwdt1XzWsfsa9SrQYzqgIFieEizHlzpirTT8tGmoBv93eA0Hhy1IxsUOykbdyYgjmq0jVEmuMvoBBNwAFsK1isLEA8ay+9Gn/BX2r2HubOuQMuZk9Yg7DSe+ELF+qSi2u7CYpbyONIniV9J7nAd/FG1DUP5q7aK2v7Vtz1qEn/8Hbe0tJ2PGtc0SvDafz1w7vSuUGs/JFHuF5q8WOniS371uPxuS1TZG3JlVF/YHid+jTneKXzBiJ79Zq5eHJvJYML2/h6PEYSKj6McwNcF7NiaiNhPUnDolPWhzb3tYpO595h6TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5984.namprd11.prod.outlook.com (2603:10b6:510:1e3::15)
 by CY8PR11MB7732.namprd11.prod.outlook.com (2603:10b6:930:71::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.17; Wed, 5 Jul
 2023 17:45:51 +0000
Received: from PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::ef38:9181:fb78:b528]) by PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::ef38:9181:fb78:b528%7]) with mapi id 15.20.6544.024; Wed, 5 Jul 2023
 17:45:51 +0000
Message-ID: <1b46df0a-7649-bd75-014e-02d1bfb931fa@intel.com>
Date: Wed, 5 Jul 2023 10:45:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Betterbird/102.12.0
Subject: Re: [ndctl PATCH v3 1/6] cxl/monitor: Enable default_log and refactor
 sanity check
To: Li Zhijian <lizhijian@fujitsu.com>, <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, <alison.schofield@intel.com>
References: <20230531021936.7366-1-lizhijian@fujitsu.com>
 <20230531021936.7366-2-lizhijian@fujitsu.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20230531021936.7366-2-lizhijian@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ2PR07CA0013.namprd07.prod.outlook.com
 (2603:10b6:a03:505::15) To PH7PR11MB5984.namprd11.prod.outlook.com
 (2603:10b6:510:1e3::15)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5984:EE_|CY8PR11MB7732:EE_
X-MS-Office365-Filtering-Correlation-Id: 3dccade9-9220-4c41-78fb-08db7d7facb2
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XdU43KMUc79URIGz6VCW0MRnpb7NBe1x6EXkTk5yUHowiGf+NSSOB0AGNPksknCbVFmHlZcfeDAOeTTzP51EDcsQJS14avYhOrO06RVmbavbwFmFV+5ij4z+349akwZVHYEyWNYRRbIjZRZo0me7ytB3Cu6yYU+Mk1lAUblbpb+XLVs9+gc12IRQ0VuoISofZlCn6EzuC3dCxseO5u1U0xP3lMeuUQl8qUVzVebopSxQQjTjviyZ71CUwpcR+RGv4BGyHhV9JNUsBRr8jqxK0pHfTvTqYIDEE7aADJcUsHlbuB+mI4nsx2O29XcoPie0dijbhyCLzhoi7TqjqR0N+qFl+PCs2W/rkqQPUKnfqNuwn4t+ewFDAy92dpwqHRaAWDTWDsmOrgQxgUbQ3mB/kNaA4fFM7hoOyXNROZD6qIRMWThH6Lkdq34rtMtFhf4Q7el66hTCOFZ+d65zZSmCAsQhAqw/6k5nSoFbaXZqWBymmp5Gl6A+gczXCWwyUfcupJ5B1EWL6pBB3CepuxNq4EEsB/KnJ+JlIWymspTF3Q+1GBnvPaTz1Kud3WyIM6wic1PHTwu3cwBh4MsHzsefhNKlG2UEr7ZGYY1b3xvmneqHD50kjHwJ7KRbzQ969/WkG23InrtZNcXt2cVxfP2WwA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5984.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(346002)(39860400002)(396003)(366004)(451199021)(8676002)(8936002)(2906002)(2616005)(5660300002)(6506007)(53546011)(26005)(44832011)(186003)(31686004)(107886003)(41300700001)(6666004)(6486002)(82960400001)(66946007)(4326008)(66556008)(66476007)(36756003)(316002)(83380400001)(478600001)(6512007)(38100700002)(31696002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cy9oNXkzUVBwS2hUME10SnpIbzd5MWF5ZjNtK2x5SzZlenRmTDlVMmc1alJH?=
 =?utf-8?B?VjVCRW12dWErQ2dTZHpGKzJYOFpEMlg3UVVPMnNjYUJRU2JJQzhTSTZxNjBq?=
 =?utf-8?B?QlowaTFFK0dNS3FUYitxVVJvQ1FXZDdMdjNjek5nQnIvKzVGZXhNVTRsc2ZR?=
 =?utf-8?B?b1ZsK0Z2RFF0WEFVMldSZ0VhbDhuazN1T0E5cWl5Ulg5VGZQbzk4SlYvUWU1?=
 =?utf-8?B?cTQ3TWlyV2liTkF1SVRZdGt4Q3JwbEVLakUzeis1VklTZ0dLTGJrMS9RYjNw?=
 =?utf-8?B?b2lHVGN1Q0xtYjRlMzdyd1lGQnF3VDdNSlBLZnpkbjZGTTh4ekxQb2VFVmM0?=
 =?utf-8?B?bitOS1dqZ3lKNHFUaGwrcGIvelAwbHJpaFJEVGwxMEd1Y3FrWWVvM3c4Yk1r?=
 =?utf-8?B?ZVVpNm5hKzNNNjd6Q3hmdmU0ejlFcFM3YkxTcGJCUE9zcnRKVDU0WUkxU1d0?=
 =?utf-8?B?YnFXRncvT2dFRktDckV2TzJzT2hodTZDMHpaNnR3WEs2WXNPaUFiY3JkYUFP?=
 =?utf-8?B?MXdqK21MakhsTFVsYlZncnU0R09nSlNld25BdTE0MFdBeHRvSEpDUnNpeERT?=
 =?utf-8?B?NWVRektnaUtQVUE2dC9rZXpZS20reDhyQjcrZzFsREdWc1ViN0ZVQ2kwZUc3?=
 =?utf-8?B?Q2RmdG5TYnFYWHZDQ0FvcStBUGp1cVRtVW0ycWh3UFBoNll2a09aaUwvbkti?=
 =?utf-8?B?ckI3cGV1TGFRS0hmeXpNaXJJMURmYXdNNi9DSldKZ2RyMjNaYjI3VEhjbTE1?=
 =?utf-8?B?ODIyR3RndFRzdHJxMjlrVmlwK2h6aC80NGtseFpJUHdjdDNvZkNaZmtpR3Nt?=
 =?utf-8?B?T0xZaUhyM1A3MUgvTFE1MVdLRVcwbk9OSGdDT3BCdVRtN0pBVy9idkdON1p6?=
 =?utf-8?B?d1poK1dRNmZXemxxdFl3L1ZIaGxhTUQrb05yRUJmdnZ4bmZ4a0VmRXdHNkl4?=
 =?utf-8?B?QlFXVmx4YTQ0b2dreEY3eElFaENjK1FxZVh2TFR0RUZ0VVVyT3JZc3F3SCtE?=
 =?utf-8?B?NUhGd2NNYXdzUGd4NktYQzJKclhETU5tdkcrU0N6ZlNkSHZRL05RY2JzOUpK?=
 =?utf-8?B?cENiR0JhNzJYc3ZSa3hCTG85bjVCZUZkd3M1K0puQnJHaHlnVm52Z1pzZXZ2?=
 =?utf-8?B?bmtGTXNqdVVYcVlzZWFUcGZMTHV0d3U3NUNiTmtVeU9OdjhoUmovMHFzbFdT?=
 =?utf-8?B?UVpzR1NObG16VGlBeE9GdFhjNzFiSlQ3TWFiOHM0aGFOWUV6VWdKbEVWc0ox?=
 =?utf-8?B?ZGhpcWtyV1kvM01hSGpEcmVKNXEzUk1Ea2xEcXVVTFpQdUh3dGlRd2VDRmVF?=
 =?utf-8?B?WTBrK0EweVFkN2VzbThGQUpmU0kwZDFzY1hNRnRBU0tRTm1pSHNvb0szdkRJ?=
 =?utf-8?B?SkU1ZGlnVFpkUGVpdWtaNE1YbWdoMC8xSEJ6RllsbWdkMDg2MzRMVHRTMFU3?=
 =?utf-8?B?YzZOeVZZRWZVajdpY29JMkNyQmZ1MDNUYWhTVWJSWXN6NnpaWVhmKzU5dHFW?=
 =?utf-8?B?L3FVVGFpT0NzSjAxcU1rRXRIVzArNFlpam1Hc0xhVmMzZnlWZHVwTzlwRnhX?=
 =?utf-8?B?cmcwUis2QUxCUzlDaDFNbWYvZGNsaS92aEtiZmJIK2J5clBxU1BpRHFwVG5h?=
 =?utf-8?B?MTkxTnE5VzFoYkNmcWdLWGk4SENFTUNiSlZuZ1ZWUzh4TThGZXNvQmMxaWNq?=
 =?utf-8?B?c091STR1ZCt0RG5pd2dRc1BxWVJIV284MkYvTE0rLzlVQ1hMNy9tbnJ0UExN?=
 =?utf-8?B?K1RsdVdYL1FFVkRORVlCN1NjUWI3V2orVVk5OG5oUzh5bVBvV2NXa1dyYmgx?=
 =?utf-8?B?YnZydjBkZXVoaEFYV0ZRQi9WVU1kdGlhYlNhTXp4ZWhSNTExR2tweTV2OUNl?=
 =?utf-8?B?blA4Z2FtUHJaWXphUk9rZEVmdUpmUm5LMnpRT0dSSHNoTG8zM3I1RUlhTFlC?=
 =?utf-8?B?MmVJanZxVEFUWkl6WmxJNmZPdmcwaTFvSzNCQ3VSbzdXZllQbk5JSXY1b3Jv?=
 =?utf-8?B?MmM1ZmthK21RR2xOOU1hTTI4OEVwQ1ZzQlVySk5RK0szRjhMQTFVaDlvZkla?=
 =?utf-8?B?VGZBOGRFQzJPS2dxNHN4dkVTdldoWWVLaDNNNUp0MW5LLzRrdmJCTEJXc2lR?=
 =?utf-8?Q?GxnJ2nRsA5m0EJ30Y8p7Q0UZC?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dccade9-9220-4c41-78fb-08db7d7facb2
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5984.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2023 17:45:51.6756
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m35KHktV6jtsUDD2eLwwE6BmxeCkgLpsYiajrgQpKSm2JDVD+vIztcPoh91o2GC09yVuyjJhby8hEcaF6sC0Aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7732
X-OriginatorOrg: intel.com



On 5/30/23 19:19, Li Zhijian wrote:
> The default_log(/var/log/cxl-monitor.log) should be used when no '-l'
> argument is specified in daemon mode, but it was not working at all.
> 
> Here we assigned it a default log per its arguments, and simplify the
> sanity check so that it can be consistent with the document.
> 
> Please note that i also removed following addition stuff, since we have
> added this prefix if needed during parsing the FILENAME in
> parse_options_prefix().
> if (strncmp(monitor.log, "./", 2) != 0)
>      fix_filename(prefix, (const char **)&monitor.log);
> 
> Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
> ---
> V2: exchange order of previous patch1 and patch2 # Alison
>      a few commit log updated
> Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
>   cxl/monitor.c | 38 ++++++++++++++++++++------------------
>   1 file changed, 20 insertions(+), 18 deletions(-)
> 
> diff --git a/cxl/monitor.c b/cxl/monitor.c
> index e3469b9a4792..c6df2bad3c53 100644
> --- a/cxl/monitor.c
> +++ b/cxl/monitor.c
> @@ -164,6 +164,7 @@ int cmd_monitor(int argc, const char **argv, struct cxl_ctx *ctx)
>   	};
>   	const char *prefix ="./";
>   	int rc = 0, i;
> +	const char *log;
>   
>   	argc = parse_options_prefix(argc, argv, prefix, options, u, 0);
>   	for (i = 0; i < argc; i++)
> @@ -171,32 +172,33 @@ int cmd_monitor(int argc, const char **argv, struct cxl_ctx *ctx)
>   	if (argc)
>   		usage_with_options(u, options);
>   
> +	// sanity check
> +	if (monitor.daemon && monitor.log && !strncmp(monitor.log, "./", 2)) {
> +		error("standard or relative path for <file> will not work for daemon mode\n");
> +		return -EINVAL;
> +	}
> +
>   	log_init(&monitor.ctx, "cxl/monitor", "CXL_MONITOR_LOG");
> -	monitor.ctx.log_fn = log_standard;
> +	if (monitor.log)
> +		log = monitor.log;
> +	else
> +		log = monitor.daemon ? default_log : "./standard";
>   
>   	if (monitor.verbose)
>   		monitor.ctx.log_priority = LOG_DEBUG;
>   	else
>   		monitor.ctx.log_priority = LOG_INFO;
>   
> -	if (monitor.log) {
> -		if (strncmp(monitor.log, "./", 2) != 0)
> -			fix_filename(prefix, (const char **)&monitor.log);
> -		if (strncmp(monitor.log, "./standard", 10) == 0 && !monitor.daemon) {
> -			monitor.ctx.log_fn = log_standard;
> -		} else {
> -			const char *log = monitor.log;
> -
> -			if (!monitor.log)
> -				log = default_log;
> -			monitor.log_file = fopen(log, "a+");
> -			if (!monitor.log_file) {
> -				rc = -errno;
> -				error("open %s failed: %d\n", monitor.log, rc);
> -				goto out;
> -			}
> -			monitor.ctx.log_fn = log_file;
> +	if (strncmp(log, "./standard", 10) == 0)
> +		monitor.ctx.log_fn = log_standard;
> +	else {
> +		monitor.log_file = fopen(log, "a+");
> +		if (!monitor.log_file) {
> +			rc = -errno;
> +			error("open %s failed: %d\n", log, rc);
> +			goto out;
>   		}
> +		monitor.ctx.log_fn = log_file;
>   	}
>   
>   	if (monitor.daemon) {
