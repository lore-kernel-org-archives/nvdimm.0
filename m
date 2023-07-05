Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C5114A8F
	for <nvdimm@lists.linux.dev>; Wed,  5 Jul 2023 18:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688581352; x=1720117352;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AFr8UIph8wYFWlk10TUXz38T2DS32czmrVWp5qg/Odo=;
  b=aonzqRLoD8te/hyKsKBafuzqYm67QKbyOSbj1QnHPw1vdtHfFZ0L5rz1
   cZ1S39bLkBQ/jhyrC6HYFPgN2XkXxOnJveZSvh2hzV47FyozC0ltR8tx9
   Mr0uQXQMHB8ZVYHPry5AahMlxKHnNeCxN+FUS4/62BYb/P+tty0XjhzaY
   Kp0q9DdEg3rPTH15UX4ikq7SD9Q6ZlUarhEOSoPsFZ/GPGV+2m2xU11OH
   zNf7YdpH94TzZBjF8gzcYxmrNFaRCg4ADf7gzv2VmsROMGT0Y3SYxx3kB
   xRbJdJJTwcRtDJ/l7oqrCzI10S28DUBjmr9c5kP+L094/92k9wzXcsyB4
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10762"; a="366898666"
X-IronPort-AV: E=Sophos;i="6.01,183,1684825200"; 
   d="scan'208";a="366898666"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2023 11:22:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10762"; a="722503457"
X-IronPort-AV: E=Sophos;i="6.01,183,1684825200"; 
   d="scan'208";a="722503457"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga007.fm.intel.com with ESMTP; 05 Jul 2023 11:22:31 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 5 Jul 2023 11:22:31 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 5 Jul 2023 11:22:31 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 5 Jul 2023 11:22:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EZrw0e67JwGPr7YSolUhhVBSvm7vK4MlSD26lMvF9TnecXDVY3wAWzVRp1QsL/gd8vc99ofrTu76syo0WEyBRvfoH9N6uZZyONiAWoJf9tpzbjJ4melRK2pWjJ0sydKu9KIgNHPiUdILb6lko4uT6fx/NiKJyC1/P2HfoVZ1uyLhHkp2g1BYIA45b84Ty7OaE63o5sZIbZ7c/rRkxC6r1WjOwtfSauqyDB1/c8/ruUzPyQCo6hS3gGdkqVdYvz6VQbnbN26s0z4IjqbFe5/PNdYSPOAcS1sNsspIFvwocHBYGTtEfgZuvva5Kmzxo1a1h2HJwn16VbMWelMil6ZzWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nz1RM1CMgbx1+7imcRduYNGf8nXRpXfyWDocLC6ZKU0=;
 b=W6tX3HjdWCu8xv3ZE7Lxpx+/qE6YxeivwqoRIjAFmKGklyYzePsEZSSP+6zPVluRKPjkTiR4GELttmkHjd9kQ0qwdRSysDDNZt50+I80mxkGaLQRvo5CWasIj9OLlMo8K266VjJPManPWVm24TzpGFVDN8VkZIBclSxzOsJptl3yFJz0zsYmUwzILmMJchgKGDgZ1zi+J3fadDEKaqbw+UgOl6DSXqzwL3EgcHmNTLrQBg2t0katAZN2ruS5Sh0YOAeS+nfAWQxjeHx2zuQj2A+wbgoWZm3Lgg2MKNL5fPd+bjML8zY+vW+0Z6H4IAEx9vS324lpW3XtUrJfQHokxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5984.namprd11.prod.outlook.com (2603:10b6:510:1e3::15)
 by SJ2PR11MB7476.namprd11.prod.outlook.com (2603:10b6:a03:4c4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6544.24; Wed, 5 Jul
 2023 18:22:24 +0000
Received: from PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::ef38:9181:fb78:b528]) by PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::ef38:9181:fb78:b528%7]) with mapi id 15.20.6544.024; Wed, 5 Jul 2023
 18:22:24 +0000
Message-ID: <6bdd57c6-bc35-b827-3c3c-ca36645b233f@intel.com>
Date: Wed, 5 Jul 2023 11:22:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Betterbird/102.12.0
Subject: Re: [ndctl PATCH v3 6/6] ndctl/monitor: use strcmp to compare the
 reserved word
To: Li Zhijian <lizhijian@fujitsu.com>, <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, <alison.schofield@intel.com>
References: <20230531021936.7366-1-lizhijian@fujitsu.com>
 <20230531021936.7366-7-lizhijian@fujitsu.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20230531021936.7366-7-lizhijian@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0132.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::17) To PH7PR11MB5984.namprd11.prod.outlook.com
 (2603:10b6:510:1e3::15)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5984:EE_|SJ2PR11MB7476:EE_
X-MS-Office365-Filtering-Correlation-Id: f2c660e8-cd10-4f59-c432-08db7d84c7c6
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dcSZPXhe4eYCQmUH6tiTfsdS9UsjbzEGvZeNcd2aOm1/2Il7ZoprYCJVSIT+QqFNPWuGUTne77snaOJ5JtFDOOXMTPi42819Ne1ciZ1vpeufCecPPO5TLYK1pQ0uoWKsdCZqkoL4pGTekGbsZMJezlmZ8LfudE28GDwhwDqTbNVZbUMIPcD/Doj48vGb+XtNcjHbD/nAUsOilF9vOVIrdfEpR1iRYrRIWHBZiMant9KjSMxaITHObOU6r1OfttVMIriyOh0HejsyKs7uKmTUsihAH8AdOz6It3DGpbbvEcb4pyjl31Yc7b8tzJbFar9Cbbs3zbYA0ngJsHiFKyMXFQ+5mlBNzw/G1UONkfaFnOOhW4KfsuyhpTBNO4ID2ScKEmQ0TcYm4UCAwdDgweC/14BgTbyhEQrUzVy0ayj8bCWx7oBFztDHmB10bsMnZt9TLTa3NDcwdbJjlJwYxSgDTACry496abVacTcwnj2BnLh4CrY/csyAe7s5r89balf0BtVAlqSPgkWDZuk1BVZJx5fviOPlKYw7aufDdH6Sc2INt8q26d5cqlFkp2mS6g5XT8m1XnRhCrZK55/yi7Emqi1q5szwXmj0hTW/u2soa9sz22lJlbsLwzqj1hJf/6QZ+mMYBS2qDLY8PsHeqLy7m3M+vSylpdDx3iyQ53uJNFI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5984.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(346002)(366004)(396003)(376002)(451199021)(2616005)(83380400001)(44832011)(31696002)(36756003)(86362001)(31686004)(41300700001)(8676002)(8936002)(2906002)(5660300002)(316002)(66556008)(66476007)(66946007)(6486002)(107886003)(478600001)(6666004)(38100700002)(82960400001)(4326008)(53546011)(6506007)(26005)(6512007)(186003)(40753002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K3UzQlROMTRWbFhWTW4xS3Mxd0ZGWmExKysrMHo3c1Y4TVorSEJrRTJzbEVm?=
 =?utf-8?B?NDJBdWIrajVaamE1MzM4bnJnZGRZOHZ2TDRFOVd5TmQxUnAva2JXY1g1YjBz?=
 =?utf-8?B?U0JXVXJVTUN3RmtYTnhaK3Vzb3FPcjVRU3IveXlOWTY1VC9DeTZsdHUvVDZa?=
 =?utf-8?B?MHl2a2FQeHdCWUVFWE5UdEowSkNaN2dXS0VIRFZHN3dydUUyR1JSMThJSkx3?=
 =?utf-8?B?dGhNRlFtdDVxb0pEMW9KK2p3cnZIM2J1SWpjaXprYS8vRXF5b2xnMWlYeW9i?=
 =?utf-8?B?YmF4M201b0dFT2ZvazBqc2ZWNUZqdDlNMmZPRWR5Mk1YczZzNUpWRk1jUERu?=
 =?utf-8?B?OU0vT1ZwMGhzOEVmanBDcmQrajFTeU03R3lMV0FOQjNiRWN5NXBLUzQrOWRm?=
 =?utf-8?B?R282cVA0OUdSSWp2VldNVFR6dDNjQnFPWVJLcnhSWmlpdHphVE0zUHZqMXhK?=
 =?utf-8?B?di9VMXVRaU5KcjZYaXdSaVhpby9tS3VUdlBETDM5SGt2NWZiSTJpak0zbUJy?=
 =?utf-8?B?TUpmMmwyMTV6U2VjMnhQNUNZdDJHWFUyS1kyODBhRDB3bHhUeWNteEkvRm9M?=
 =?utf-8?B?UjFMR3FvMDlUYjZPNXZNRll1OGxmbVlOMEFzZktlV0dEdThsV1QxSkRRZlMv?=
 =?utf-8?B?OHlPTHlIbWNEcThPK2Q3K091d3l6ZjZHTFBrMjUraFBxSnM0Z1dGWWtvOGxl?=
 =?utf-8?B?VnhCK0FGR2xtYkp5cEdvQkw5MFR3bEFSYTV1Mm1xbnp6RFpzWEl4UDBtV3U3?=
 =?utf-8?B?L2ROZUp5Q2E5V245b3RUOFJoMk9Jai9FdFZzMzY5blM1UExJWWpweGV5TUNk?=
 =?utf-8?B?bHJXaG1IV1I4bUFzS3hxVGdNV0xXdGxpZzhzM1dieXlHVWlNYmJLWnN6bmVY?=
 =?utf-8?B?VWZFUXFiZVJVVXNXRU5qaVZRR202UHRYUWtKT3lCbFpVVUkrd2FNbmpyZmV4?=
 =?utf-8?B?WjV2WUdyTklJdmdadkxvc2ZTVUxWZ0hUaVBsRy90L3FqamJVUW11UCs0MXdQ?=
 =?utf-8?B?OWdyL3Q0aSthb2RTSlhEclhvTW43a2dvcUlmZ2Fwa3paRVl3YmpUaTBtb3h4?=
 =?utf-8?B?eGh6dDZIZkVvSnYrNXFVeGRGcGVGNWpmSE01ZUxqbzhpenNBQlZkajVBK1Ir?=
 =?utf-8?B?MTZNc2EvMnVHdVdQRGszci9JS2FCZEc0ZEEvckUwc3pwWlRzelZid3ovTWRq?=
 =?utf-8?B?N2V5QWZOdWZLYXUwT2JpUFk1TnI0MlZ1VW1iSWVBZGN5WldOeTBlNEdlYUJ0?=
 =?utf-8?B?MG5QQ0RsRWhSWUtYZjNOcjlwYkxadmZTZHRDeEhrVWRGQVZVWFFCMkZrMVVo?=
 =?utf-8?B?OVlqWDVpYUpLcDRFRGxLc1hhSVVpelk2aWpvV2lVakRjRE9YaXRaOGxqdTY2?=
 =?utf-8?B?V0hMeHpHUkJKQ3ZqYmsxaklXL0xKbVpMdk9QaEg2eUVPSE1IUGZpMVFEMURm?=
 =?utf-8?B?VnVubk5XWmlQZWRDUEJIZUE0b095a2U5cDY5QTJhR0VKSzlROTE2OXcvdEVS?=
 =?utf-8?B?OS9EemMxSFZvS0lXMUpIWjVheGtnUWJGeldDVW9vTEM1aW03dzRGS2ZzQjht?=
 =?utf-8?B?WFhXQ1F1RWZ2dGIwcUJQOHpqSkt6M2xrUXVRSm5PL0UwbFFxd25UdFFyc1VF?=
 =?utf-8?B?eWNVcTJBakRJZXJQZmdmdTJzQ1hnQ1pSOFkwNlA5UG5CaTNmNytROGUrNHov?=
 =?utf-8?B?cEUxK2pXMjYzUEwvc2NPYURFMWZscE1NR1k4U1VHYlFnbEo0TlZyb3BLQ2RI?=
 =?utf-8?B?dERySm1BRnNyZkE0bUtqS3lXUE1UOHFRNGpUN3MzSy9VSWRpNmIvOUJVYytY?=
 =?utf-8?B?cnZ1dXZoRWVIMWZ6RWxTMTB1b2s2RkJ3MEpWZktTd21yaC9VUnRHNGhpQjRQ?=
 =?utf-8?B?LzBzcmpQRXczbXF2T2hqZVNTcHNBZjRTdTVwcjBhUU5XVHhDQVN2NU5hbzhJ?=
 =?utf-8?B?TkVGMFRuTWJ2c054L1RJTmEreFlLTDVsMHlUTTAycWVnY3hkL0h5OThaeHRL?=
 =?utf-8?B?ZjFyQ2ErRG9wSnZON2pPTzd3TEtFeTBsVTRycThmTDdZRGpiUDhVR0k3YTlk?=
 =?utf-8?B?eEtmdG9hKytIc1FsbEdRcTdFK05FUGJ3OWRTa3EyVU80amRSK2ZTTnQzTUFD?=
 =?utf-8?B?aGlHa1hub3prY3c4YkI2d3pEblFSUzEyRmZpb2xKRTB6bTZ5eW4vL1pHWWFl?=
 =?utf-8?B?QVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f2c660e8-cd10-4f59-c432-08db7d84c7c6
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5984.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2023 18:22:24.5764
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ck97rOxhtc7YGLfPMq5pgwJoY+03C/AYMbN5Zta6Zs0UCWAG68jSlpdEVnh64cSAil54duRM8rpuNUF5Tj8wKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7476
X-OriginatorOrg: intel.com



On 5/30/23 19:19, Li Zhijian wrote:
> According to the tool's documentation, when '-l standard' is specified,
> log would be output to the stdout. But since it's using strncmp(a, b, 10)
> to compare the former 10 characters, it will also wrongly detect a
> filename starting with a substring 'standard' as stdout.
> 
> For example:
> $ ndctl monitor -l standard.log
> 
> User is most likely want to save log to ./standard.log instead of stdout.
> 
> Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
> V3: Improve commit log # Dave
> V2: commit log updated # Dave
> ---
>   ndctl/monitor.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/ndctl/monitor.c b/ndctl/monitor.c
> index 89903def63d4..bd8a74863476 100644
> --- a/ndctl/monitor.c
> +++ b/ndctl/monitor.c
> @@ -610,9 +610,9 @@ int cmd_monitor(int argc, const char **argv, struct ndctl_ctx *ctx)
>   	if (monitor.log) {
>   		if (strncmp(monitor.log, "./", 2) != 0)
>   			fix_filename(prefix, (const char **)&monitor.log);
> -		if (strncmp(monitor.log, "./syslog", 8) == 0)
> +		if (strcmp(monitor.log, "./syslog") == 0)
>   			monitor.ctx.log_fn = log_syslog;
> -		else if (strncmp(monitor.log, "./standard", 10) == 0)
> +		else if (strcmp(monitor.log, "./standard") == 0)
>   			monitor.ctx.log_fn = log_standard;
>   		else {
>   			monitor.ctx.log_file = fopen(monitor.log, "a+");
