Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F38B134CD
	for <nvdimm@lists.linux.dev>; Wed,  5 Jul 2023 18:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688581303; x=1720117303;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=B8UytpfakTjtiWYjPzCZSt8KjsE4G8K6nOwfLyK/2tA=;
  b=lDqPFg7vJt1QZSoVDCVfyR4RaifNfLeqorkt0/rnGLa7GSXmdZJ9VxyZ
   km6eEQD3vfvoCn1qyYKoeAjwtpaglPtfGycWnZRK7xrSTqd06MG6NmQ1y
   MyByH7hdYUoWXAB7gGW4H0KyC10cfSD7GW6SZ9oA9osWmg/oXBpUIpwwQ
   NaJe6CcDVZqT47W9F1g7RZAaM+in601sApGW+yUwz+BboTw9GVIyrc51B
   Z+LnpOSsVN42Wsy4RtDt4Va2nujVuBnOyGBz2EuBoou+ZhAFfU17g5Yhh
   jDMHaDPxwxL97gAaW7IS09sRgaOx1qCSH2i0ccyoQRuN2wX8fCGX13lOs
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10762"; a="362281677"
X-IronPort-AV: E=Sophos;i="6.01,183,1684825200"; 
   d="scan'208";a="362281677"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2023 11:21:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10762"; a="748821944"
X-IronPort-AV: E=Sophos;i="6.01,183,1684825200"; 
   d="scan'208";a="748821944"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 05 Jul 2023 11:21:13 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 5 Jul 2023 11:21:12 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 5 Jul 2023 11:21:11 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 5 Jul 2023 11:21:11 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.49) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 5 Jul 2023 11:21:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bk2NFPRqx+CWve5+3CNwEBuLrsL4rNe6NJVOgLntrFGrOHvhHq1wqpM4cSjfzjFDw4I8nieqXU8+wK9RD+cX/PKoBEmS/iCzroWXjP6Np+MXOX2hUQekYDPkXs+EHF9/BcQB9gyj+KisAzObKfHvxf9V5DCfF7Creh2o/z5r2i9unoetQjo6R2Sh6Z00oxubzhAbNTDn3sBDGKy5ntNvpgsqz2WHjfc6Ex0aOgahqGsbeuKEZ9Lw6xgiRAJC0DZaPp81P0Kktbdhz+Pda+Q8Hl8tzRPp6xrl1JXouEJPxMqWwXaBZJxkeoHLj0O26BThycBppkTfiORge3v5DBTwVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zq36dShLCg8R5buIy9ROzZob49Ye9fdmAZZgZlmtQiA=;
 b=ME32vqa1PKrcI6NO7vu55Lhm476nGeQeEvA2HCton3r7VXrvaq310793OLSlhjss3YGWAwEBrVE24ljv4pOd5qbkdNOLAhoQfzEIOwzYuv4ZTF0wzXZ1cfmufj8CQQjP9WnVqOYtd51nxwGeEU94lwLt6FRk/od2TFf8m7MFXv52RikapCfXJMwL9A/O2szSJg4lofW+vQ/n/kg45VeldFvYcq23oDjF3WH3VYYb+08F0UwTLZFZ+vgMxa5/SYQkoIAZATcjHDty/eHaa29ChAgEQXgjImiscv5sq8V2or4M1oLgFptvK7KUODb4mERovcbMtEOMSl452e8kHhT2qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5984.namprd11.prod.outlook.com (2603:10b6:510:1e3::15)
 by BY1PR11MB8053.namprd11.prod.outlook.com (2603:10b6:a03:525::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6544.24; Wed, 5 Jul
 2023 18:21:09 +0000
Received: from PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::ef38:9181:fb78:b528]) by PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::ef38:9181:fb78:b528%7]) with mapi id 15.20.6544.024; Wed, 5 Jul 2023
 18:21:09 +0000
Message-ID: <292a06e8-c7ba-3a40-71bd-406dc7d37e41@intel.com>
Date: Wed, 5 Jul 2023 11:21:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Betterbird/102.12.0
Subject: Re: [ndctl PATCH v3 4/6] cxl/monitor: always log started message
To: Li Zhijian <lizhijian@fujitsu.com>, <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, <alison.schofield@intel.com>
References: <20230531021936.7366-1-lizhijian@fujitsu.com>
 <20230531021936.7366-5-lizhijian@fujitsu.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20230531021936.7366-5-lizhijian@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0147.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::32) To PH7PR11MB5984.namprd11.prod.outlook.com
 (2603:10b6:510:1e3::15)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5984:EE_|BY1PR11MB8053:EE_
X-MS-Office365-Filtering-Correlation-Id: c3a08d87-fa27-48f7-6078-08db7d849aff
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o7c2MEBKUx9DVqA5KX7B3ARbcVZx35pwXIPOiZwUZI4IxPX0oRxY7KMsbUYROgV02WkSBLc+wQx53l/OgaAUdxV5oyxiukIBMRdRh23U9dnalpBVlvbtW8/p3MHO18cKB++8X3C/ZrmHh7vQrwNg9u8Hn/oLyp5UM4zyMmqGujgqdsq/Xvo9N0emcZCXHex9upAi/4SsIPKxyaAnw9tIgJpidVMl6xP4MZpy4ZME8uZUUwgVwJdZQvkcnmQMuUxSE4rww45UCpwbpSCZghlO2zbmGrqcpK5fXE4oy1JF35cyax76CbUQEY7l//CdUYw3N1acCmzqDdBbpHx3MD5Vbuj8qAScvj48xXJdCugMDMdcLl4DB0PPcDFz2I/lnbGdpYcn15mgewNq3kYl7JxqX9v6NccN77RkQwSOtx8Tyf5UR1709ZpMYE9Z9b6uuzgbCgrbSK891hrv66aUIuFwjvS4Ks8r8c80K4aj7Feg3/1IhptIIBrmTH5z9IToL90oG411rgPp0rAFJGgOie15m72v9zrVDNwS9jXafNpNeMeKSkr6fd/WjnQ+G2oZQpWSNs0nRKWWDt/C392zPUGLec/4ErySfKJ8OcjbhBBLGgALkUTsM1sQuRIMOnaFKgima275dwB1YAgOJDG039SqOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5984.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(366004)(346002)(39860400002)(136003)(451199021)(66476007)(316002)(66946007)(66556008)(107886003)(38100700002)(82960400001)(4326008)(186003)(26005)(6506007)(6512007)(53546011)(6486002)(478600001)(6666004)(31696002)(31686004)(2616005)(83380400001)(8936002)(2906002)(5660300002)(44832011)(15650500001)(86362001)(36756003)(8676002)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M00rQkkrdW1vejNleWR4VExBVEFFRG9pcTFFcUpzNkwrRTZpK1U4SVhDSk9K?=
 =?utf-8?B?ZjdGUHplZUFwdHhwUEZlQVpUYUVPK0xCUlp0RE13V0N6VVFFRm9rdloyTXJV?=
 =?utf-8?B?MHBVay84eVVka3oyODZ1b0ZSTVNNN1NUV0pVeWwxemhRNFJLSnR3SHBud2kv?=
 =?utf-8?B?eEdVZVUyM0JaaU01ZENoS0VuNHpkUmM3MEppUDdlTmFlNndzQWJZRm5QTW5p?=
 =?utf-8?B?Z0c3RjdyelN5U3B4aU9rRG1DaXN1Z1VvMldoSkxTVURrQjZUZzA1ZnpuQ2tK?=
 =?utf-8?B?VFIrSU15VzkxODhEaXgrb0w2SUFQWHE4SmhDa2oxekNoR2c2cWEzb1FEajhx?=
 =?utf-8?B?UFhraGlQNDNWQU5wM242d3J5ZC9lbytsclEwMmRkUDJwUUJrK1AvT3RYUXhz?=
 =?utf-8?B?VVFoQ3RSNE1hLzBXMXNpTTAvbzJwUzgzUnRvdUdSMGFMY1ZVVEdvaXdGdVdM?=
 =?utf-8?B?RmxnVjFnZS9PTkFaOXpsOUZCMlM5U0VxSHNVNDBVR2YrM0h5aDZENnI2dUxx?=
 =?utf-8?B?elhLU21SWG9rUXlObkt1R0pCalZ1OW40Y25wY2lPQzk5VVVha2VOYjR3Y1dS?=
 =?utf-8?B?Z21oaVVHZnBpVGVGZzd5ZWtpNTNya3NRTjBodGRmcjhxWDcxQnlhRnVxSkFR?=
 =?utf-8?B?bTBpWFJpMnBqMksyTmVJTkxHcWJwOUkyamVrK3ExRTVvRWs2OWVuSFNMU3Ux?=
 =?utf-8?B?RjBZVkM1Q2JMSzJYVEFVelcvdU1INGFQNE9pUWI0RzhscWRrWSthcllnTkcr?=
 =?utf-8?B?UWtrbTFxSVBNbFNPTmlITHpxb0xOdHZrRGZEMk1MS3JGQnRWZVMvdzZwWVY0?=
 =?utf-8?B?dVFFc1VqdzYxdHY0MDI2Ryt6YjVvUmdGL0NBbmFFNm5VZjJneENTTEJMdHhy?=
 =?utf-8?B?WXVsMk95Zy84c0hGUmNQZEQ0OWl2Ynp6WWRodytGVHpQWGZUbWFPcW9lRXFp?=
 =?utf-8?B?R1RmVkt2dGh4cUFEWnlmMmZxak9BRDV6VFVlVHVuaXpTOEFWWXlLT3BDYkM4?=
 =?utf-8?B?RzZLMS9tak9nMWJzcDQ5SlgzYVF1VUhBS0pWZDFUZ21ncmR6aStOUWRqcXdJ?=
 =?utf-8?B?TVh5TlVUOXM5TFBLNDZGaFluN2tuTmhnZmhVbWRDVTF2ZlNmNUc5Y2NvN1l2?=
 =?utf-8?B?bUxQUXVRUzIyZlZPS0pmUkpIcEpNZ3pWNW9RUGVyMnJPWjArV1VEMnJGSVlU?=
 =?utf-8?B?TjRqcU11S05kMHEyZnhyTXlpYWZ6ZnIzTkFFUVdDRGV6czM0dnR3RXZRekxY?=
 =?utf-8?B?MCtGVGR0R2RubGlhSG14SUFQTy9mTUFTeHNvbFROc041REZIT2JVa1ZZSXpk?=
 =?utf-8?B?TitjYzJUSHZPcW5tWnBlRGxpakVMaVBHSUtKbWpmM0cvekRTZE9sa01WR1ds?=
 =?utf-8?B?SGpYSTI3UnA1OXo4YTFMdkJYVlZlTlJYU2NpNXFocTVsTlJQdHpSY1F3RFJX?=
 =?utf-8?B?VHFHOXN2QWg0cHlDRWdTd1U1QmdJVDJOVzJoV1NncHk3MElQT3dmNytBQm1P?=
 =?utf-8?B?eGo0V0FBanduL3kwUUdpS0pyS0I4SnIwd1pLcUNweDBmVEc4NzBpcDlhRW9h?=
 =?utf-8?B?alZOYVRpU0o2dGkvZGNWSjgxSzZpRW9kS2hnbFlKc1lkLzYzTjM2YUR2cVVa?=
 =?utf-8?B?ZzZMcnAyUU5yZWZTWWFhT2trUExvRUVVRFdqY0NTK3JranR4WGMwVmxaKzRa?=
 =?utf-8?B?YnZoWDBhM1F5L0ZHancrZXRQZlE3blc1MkNEUGJ2ZTFYb3UwY3ZCbGM5V0h5?=
 =?utf-8?B?cTRyNjI5VGtKS2RDREVuUjdya3p2ZGh5MWhYYS9nN1JacERPNXV4NkhxcUd6?=
 =?utf-8?B?ODNtWDA2OWxVRS9QcDJCZWNrTkxnV1I3UVRCNXlPZWQzU3IxNzg4dXJ4T3la?=
 =?utf-8?B?NWhSK3lseFZFMHZwWFcrVTV2cy9GYmZteWV3dU5Pb29UZC9hUllucFJyQmt5?=
 =?utf-8?B?Nzg1eWcwb1VvT2drckhSMFdlR3Y1Y1RlM1ZIK1ppVmF1MUVaNi85K0dQNmdJ?=
 =?utf-8?B?V3l0aHBZQ2szcVR6U1d4SW9SZVhCUCs4VmUrL3gyR3VwZ1FGLzEwQXp3MU52?=
 =?utf-8?B?WXRKQ3Z3Zk1nVkt0Zk02b2VUVk1UanRKWU13ZkdRNWhad1JVMU05c0h4Nmdn?=
 =?utf-8?B?UHdSQjRkbFAyYWVGRU1GQzBCSkRhOVZLWnZDVHlMbDBwL1VWTzNXZzNpM3kw?=
 =?utf-8?B?VGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c3a08d87-fa27-48f7-6078-08db7d849aff
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5984.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2023 18:21:09.4989
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f+ZxCVJc8RB901ezD4DVmglJcOav/kh88xKjH8JeJt5Uxxo2macRcsJnylcO2gzOr4UIjSa9DOecMPHsTkrhTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8053
X-OriginatorOrg: intel.com



On 5/30/23 19:19, Li Zhijian wrote:
> Tell people monitor is starting rather only daemon mode will log this
> message before. It's a minor fix so that whatever stdout or logfile
> is specified, people can see a *normal* message.
> 
> After this patch
>   # cxl monitor
>   cxl monitor started.
>   ^C
>   # cxl monitor -l standard.log
>   ^C
>   # cat standard.log
>   [1684735993.704815571] [818499] cxl monitor started.
>   # cxl monitor --daemon -l /var/log/daemon.log
>   # cat /var/log/daemon.log
>   [1684736075.817150494] [818509] cxl monitor started.
> 
> Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
> V2: commit log updated # Dave
> ---
>   cxl/monitor.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/cxl/monitor.c b/cxl/monitor.c
> index 179646562187..0736483cc50a 100644
> --- a/cxl/monitor.c
> +++ b/cxl/monitor.c
> @@ -205,8 +205,8 @@ int cmd_monitor(int argc, const char **argv, struct cxl_ctx *ctx)
>   			err(&monitor, "daemon start failed\n");
>   			goto out;
>   		}
> -		info(&monitor, "cxl monitor daemon started.\n");
>   	}
> +	info(&monitor, "cxl monitor started.\n");
>   
>   	rc = monitor_event(ctx);
>   
