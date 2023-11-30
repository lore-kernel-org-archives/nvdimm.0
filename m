Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8156431A6D
	for <nvdimm@lists.linux.dev>; Thu, 30 Nov 2023 16:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JRDn7G2M"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701360485; x=1732896485;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=X5JSzezpN4DNxuy0fHDy5lseqZLI5Z9TXAv54ouACPM=;
  b=JRDn7G2M5vfcklqXXYVbtZGl1lbjBfbOhH42TmsnqFuT02TgfToED5mJ
   Ow1UJrmZy9dS5m3kZz5RDS/U3kMOUBl398sdTGnOiFbd1JSOex89nOHME
   SYL2eigBv4i3xeaojtPHlWdw0SczPbcoCXfJjIvh03nWgc27SP9KuECl5
   5OMvD9FDTG/malkA+3Jp0H+cTHQUj7z9mRwUEaT/0WujHRa2io1hZy8bC
   vdCiu4ZfzC07o0/yZacp+SBNp5Af42kHNbIlCjQ8IrBW2VbZ/wypFmPzo
   /VgA4HN22wIN2ZSFZtJGEjm+hV8JZhdsiyAzf5ld8pLUJE88I+c6/inYw
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="424492681"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="424492681"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2023 08:07:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="10807281"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Nov 2023 08:07:43 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Thu, 30 Nov 2023 08:07:42 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Thu, 30 Nov 2023 08:07:42 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Thu, 30 Nov 2023 08:07:42 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Thu, 30 Nov 2023 08:07:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aqXfzklJto7yDoLY8jU+VVQcyJCU0gFGEeSCS1oye+vHcrLAzaVsoageemj1QpM0USkLrpRecztBlAwI3+X524NX+BlyfBkdrwjF2ilA/s9HQu3/u3uNK8jtsUlHDuFA4JP6aZXfnyGefF/39sF3mNwzDZhIslfB+hsfgt/Dv4m+8z8wIWQSCokiXK6LyMbKnRXONcj0Hpn1RE8O2UDfIpbvxcYr7CzRJMNNxlFQy5v1tkw6RroJHzbbl9WIFijqFqW/Cjzt7LbKpk0hZhRHmmFkEx0X350Yd1nNOTb9UIxLbpltXcLtq8SZfGmHrgbu7f+bpP5/Xsr6hbRvghGKUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8qHwQGASH37wtf5umpr838Yuzg8oBJfM4Rv8BuYrEgo=;
 b=lyLhZdxwuw/NVjmaoiw36OpAau/aAC56pSjWdiWhCDdAOYnjeokA4MnawcVek1+J6OgjPNqceqLY4mBuq42o8g3qUYyg87pVYz5iPDPplPYIXdEHVHbpx080pD8BzxvqdL+CCp0VPGnyZh+lNY0iTAYh1h7PIXHGtXPh0ZMlFiPTd9HJkpFAcLMVcAPI0J50SYEG+AYdBCA83DiQqe+jEx3LwNzdq1i6wLLnuBytb5XHkVFelihcGDpKdxiERMr1XwGf+H9dqiZbFYKdF0WGFPA5Hp6qCSiSJSmwv3nRgOin0Ouu7Vhuv26Dxkup4mcv4bVRqmil5XNOtzcqm1b7hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5984.namprd11.prod.outlook.com (2603:10b6:510:1e3::15)
 by CY8PR11MB7945.namprd11.prod.outlook.com (2603:10b6:930:7b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.26; Thu, 30 Nov
 2023 16:07:34 +0000
Received: from PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::6f7b:337d:383c:7ad1]) by PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::6f7b:337d:383c:7ad1%4]) with mapi id 15.20.7046.024; Thu, 30 Nov 2023
 16:07:34 +0000
Message-ID: <b6867e77-d751-4d09-93e4-59c026e09c6b@intel.com>
Date: Thu, 30 Nov 2023 09:07:30 -0700
User-Agent: Betterbird (Linux)
Subject: Re: [NDCTL PATCH v2 2/2] cxl: Add check for regions before disabling
 memdev
To: =?UTF-8?B?Q2FvLCBRdWFucXVhbi/mm7kg5YWo5YWo?= <caoqq@fujitsu.com>,
	<linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>
CC: <vishal.l.verma@intel.com>, <alison.schofield@intel.com>
References: <170120423159.2725915.14670830315829916850.stgit@djiang5-mobl3>
 <170120423751.2725915.8152057882418377474.stgit@djiang5-mobl3>
 <766e7de9-8f08-73f2-fc7f-253930f95625@fujitsu.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <766e7de9-8f08-73f2-fc7f-253930f95625@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0234.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::29) To PH7PR11MB5984.namprd11.prod.outlook.com
 (2603:10b6:510:1e3::15)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5984:EE_|CY8PR11MB7945:EE_
X-MS-Office365-Filtering-Correlation-Id: 1138af6b-bbda-4d15-181d-08dbf1be768d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: My8e4dyucqQwKPFhgi9gu6EuzbjVC6M95sL00yDwq2h1X3R/PrFfCQ5Wr601GXoazm0xmjfDbwd3u6drZc+0zJtjFv2mVxoOpfil1fb9Sdu1CEctuY5EcZH9QLSaorODlxRawLPyAVsS8v2ae4tlvNMmhZuiRl+xNxTd2iS3rfB1z6KkcYddptIrMp870l5uS8SDNniespr6w6ALXca4LcIWqPanNPqZ7EUseLK8FfZCTXjLMWOrIbA/DyLc+2VghyUR2DKKTfwbRiry/SwyaA5QMz4WxZ2uGSloaiT4lg4EGv302J0XANmNfEAOnAsM0xJSPLyjgw8x0ruhp0JXnNEOxWo3oFUrDvoPABB7qdNlT9Gn6dvfwGpHBSzZreagr81vyz10nQFzozHsxKZ+W0BvLk4zaRiVZvgeD6bjOmicHWqABwsAoisPHbU5UQz/biuew1yqTm7NF5g8/6UWz0WKsBybnSuEw2owU0nyoH5PXej9EDhMtOzXdmCZ8NsKzxQLjaNkGTAFTNi4BRy+VOTBFOvI9O3IdFYmpx9fn0V28I3nc22imDtfww3VXNgkYCLIxWIJ0ZZ5fwy2/Eik+a1l1Iqrw+/nd/jD4qcqWptAcAWH1yLZ28abehM2B93W
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5984.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(366004)(136003)(376002)(396003)(230922051799003)(1800799012)(64100799003)(451199024)(186009)(38100700002)(5660300002)(2906002)(82960400001)(6506007)(6666004)(44832011)(83380400001)(41300700001)(31696002)(31686004)(86362001)(8676002)(8936002)(4326008)(66946007)(66476007)(66556008)(26005)(316002)(36756003)(6512007)(107886003)(478600001)(53546011)(6486002)(2616005)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M0RWSk1mNjJZL0tGbm5JMThNWmd3Y0RVQ29BdENWa0ljZjFOTkdXQjFoQ1hK?=
 =?utf-8?B?a3oxRHQrZ25iMlNXVllBTUNzbzAvd2dmVnZBNUcrdklaekRmVWRoZ1BiRXBR?=
 =?utf-8?B?RkNySURqN0VtMlZDY3NnVlE2MkhHaG15emlRMWpQM2dsT2c0UGNkWmk1RGJo?=
 =?utf-8?B?QVRDWXpPK3hwSDJkWUd4OG9PNkc3UEsyNDY3bWg5dmRqWnRJNFNlZFZ2enZk?=
 =?utf-8?B?T1VpeDNqWEdlQTdDcUpaWHdNTjZ6WlJiMnZPTmN2OGpBNjNTa1R4ZEZSRmgy?=
 =?utf-8?B?UFViT3ZRamJqdlZvVnBqemRrMkhrNHdBa29DSXlwQUlXSUhTNFIrT0pES01L?=
 =?utf-8?B?RkJPZTM4OWl5MnQ4RkNnZld5NUlBS3V5LzlCb2s3NTZIUHBsbkcyaS9rZ3px?=
 =?utf-8?B?ZndPQ1FtY2JXL1ViR2F6c21kdjd1NlM2Z094NmJUTG1ETGp4WXlDY0VkTXFH?=
 =?utf-8?B?TERaYUd3c3lBYWUyanZxa3V6R2RJM2pIbC9LY0I4c0YreWROdEhRb1lENW1p?=
 =?utf-8?B?UG5mYU1kd01LV05rSEpwMTZ4Rzkxckl5azZGOXk3K2dicjJFRHNnNFZCTGRU?=
 =?utf-8?B?WURKYkNPSFZqK0t0TXcrVzkxTkx3bGg3ZEdMTW41emx0VkZwNDh2cU5Jd2o3?=
 =?utf-8?B?SUV5RHdrbmZ1dlhWSWswVDVkUVhiR2xrQ2c4eE04aG9KT08yencxOWlnQzNL?=
 =?utf-8?B?aDBJb2xZOXF2VDBUVGFUVVFEYTdPRDR1eC94eHBMc2FpOHVIb0plK3ZJTmZL?=
 =?utf-8?B?dlhzaHVVc1ZRRWNEdjY0bDluTWI1cXNsb2JtTjNvem9ZSnpnVGhJMzhxbUR5?=
 =?utf-8?B?cEM4T1BZZDlmdnI5SkkybGh5enBXRCtBRmtkR1B3cmRTcVVvTlRoNlBUWmVi?=
 =?utf-8?B?QS9ldUtQZ0RRaTVYZWh4L0pWRms3Q2ZMcUtMeTFLaHc5WFdrNFlWeHFtTnRP?=
 =?utf-8?B?eG1QcUczeDdSVHpDQWExUmkwTUhPWnVLVXUvcEZmcjZnak9TM2dJVXhlaWE1?=
 =?utf-8?B?SWhVSkMreVI3eFBjVktWMW9FQUZXakZIYjI5WVhQTlV1QTFkdFk5YUh5U0c0?=
 =?utf-8?B?R2MwSndITDVIc2NHdnVTS012MGJDZGFqeEpQR3VmY0hGczNKUFdXQ1diM29K?=
 =?utf-8?B?UkJtcStSK21pbEw5TS9CTUNHL294YXdrOGVzaWlVN0FQM2pjQkFxNitqNjd1?=
 =?utf-8?B?NFN2UzVsdndnMHlhdjVKOUFuSm1vTGFvc2VFZ3drWHczL2dkemc2cHlqVURR?=
 =?utf-8?B?ckdqZjVZdHY4aFNFRHJMZ1RaNlEyWWE0bzMwK3ZyeTg5eityRTlZdjg0NVZz?=
 =?utf-8?B?SmpGZ1NUSmEzVnMxSjNQb3RLa0dCWkoxMEs4aTJVd1RwSVdEQVhFRlpvOVc2?=
 =?utf-8?B?OS9zK2xEVzFtUmlucHJyTktPTXlRLzJNWHFJVEc2SnYyaHVYUGU3QWlrQTEz?=
 =?utf-8?B?ZEVsMGcxWEI2NFY3OTY1Ym96Mms1eDZBalAwMWJTQlVGSWlqYStRZ2Q1TUR2?=
 =?utf-8?B?M2t1Uy9XZUpVZkpuWnNOWVFlMTE5YVZnU0IrNlJVUU5TZ0JkQzJNL2RBLzZX?=
 =?utf-8?B?Y1pvK00yM2VMZXpwUlc0SUl1YTIveVNjMVNic3FyNXlLc2pGVVFnWnQ3Ykxl?=
 =?utf-8?B?RFpJS2lCUU1TajdJd21FeWRkUTRjL3RwSVY2c2NCYy9lNDVPYytEeHM1TEhG?=
 =?utf-8?B?aFEzUWJua3QwN0liUnVuNmg3ZXpMSWtUUS94OXN2ZUpFRVBqVlgwaVpUQWk2?=
 =?utf-8?B?dFF0OUVoZm45VWY4NmtrWHVZSlhSUnBLQ1hzL0FSR0xSbFo5YUxzRWgyZFI2?=
 =?utf-8?B?NzhMYkpDc0wwQ1BDbjRlQUhHYTB3R1JqVVRzUlpBOWx2SU5xblVkMXJ3djNS?=
 =?utf-8?B?TEY5dENEalRCSHZNanVzcXl3V2VyV3hxdjhzc1FUQnpmL3dxU2VSa3FIR2Rm?=
 =?utf-8?B?cnY4YU94RHFxV0FFZUcreE15THVYazFuOVdPMVlpVFVQQzFFSUJVMGxiY1Rk?=
 =?utf-8?B?dFJ5Z0l6UlJhenQ1Qm0wOGpxUGxja2dpZ1hKdTN1NnIxdzNCclNDS1p1NW45?=
 =?utf-8?B?cUltUnlldExqdWFCOW4zVDJQS0NOTFR0UlQ5c3pUT3ZJTTdsYkNSektpYjdG?=
 =?utf-8?Q?/G0ZFHiiAtHg4rn+1/UzHVOgl?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1138af6b-bbda-4d15-181d-08dbf1be768d
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5984.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2023 16:07:34.1882
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ef1Mr4DX64YKWx3eCC7/VyuPCylMHFBLgcu8h6UJTX1RR0x8Fr/AIerO6VLCj+UL8IXefjMKtMCRpniYVOYOaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7945
X-OriginatorOrg: intel.com



On 11/30/23 01:29, Cao, Quanquan/曹 全全 wrote:
> 
>>   static int action_disable(struct cxl_memdev *memdev, struct action_context *actx)
>>   {
>> +    struct cxl_endpoint *ep;
>> +    struct cxl_port *port;
>> +
>>       if (!cxl_memdev_is_enabled(memdev))
>>           return 0;
>>   -    if (!param.force) {
>> -        /* TODO: actually detect rather than assume active */
>> +    ep = cxl_memdev_get_endpoint(memdev);
>> +    if (!ep)
>> +        return -ENODEV;
>> +
>> +    port = cxl_endpoint_get_port(ep);
>> +    if (!port)
>> +        return -ENODEV;
>> +
>> +    if (cxl_port_decoders_committed(port)) {
>>           log_err(&ml, "%s is part of an active region\n",
>>               cxl_memdev_get_devname(memdev));
>> -        return -EBUSY;
>> +        if (!param.force)
>> +            return -EBUSY;
>>       }
>>         return cxl_memdev_disable_invalidate(memdev);
>>
>>
> Hi Dave,
> Do you think adding one more prompt message would be more user-friendly?

Yes good idea. I'll add.

> 
> code:
>         if (cxl_port_decoders_committed(port)) {
>                 log_err(&ml, "%s is part of an active region\n",
>                         cxl_memdev_get_devname(memdev));
>                 if (!param.force)
>                         return -EBUSY;
>                 else
>                         log_err(&ml,"Forcing memdev disable with an active region\n");
>         }
> 
> output:
> [root@fedora-37-client ndctl]# cxl disable-memdev mem0 -f
> cxl memdev: action_disable: mem0 is part of an active region
> cxl memdev: action_disable: Forcing memdev disable with an active region
> cxl memdev: cmd_disable_memdev: disabled 1 mem
> 
