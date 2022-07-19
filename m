Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A584D10FA
	for <nvdimm@lists.linux.dev>; Tue, 19 Jul 2022 06:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658211796; x=1689747796;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=e2VZNPNRwT7U4R8DX3sRA6GUwb84Htzfih2dA81lDi0=;
  b=GsQt4mizSLiNssZYoVxDWeOEIXL6cTgpb0NMtkLTh4MjNfUIVsC/3Dv8
   PVhxIjzft6v/ahETIgvZsYLp8Bn0ubimFXEdoOzuZP04r6UIbQNMSe5e3
   NkMMoQZn/0+YWuKhWWZF2dyPJclppwvuNRC5AyCxDI9StpQI0z79eXe4Y
   u1O6jpOm23NtAOX73cWfGT+5RURNau82fvkS3Vd9JOeukipWrbQsDn+6J
   7PJmvMXIQ0vPyMrW0xexe9Yoqt1G7ZKF+OgkRzHE7VoR48ebMtXr+Zvsc
   Qo0pIFXVNxdjbCfc4rWsBqevDlZzWONSeZtvCga3FyLSWqqR35M5NQp6R
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10412"; a="283969665"
X-IronPort-AV: E=Sophos;i="5.92,283,1650956400"; 
   d="scan'208";a="283969665"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2022 23:23:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,283,1650956400"; 
   d="scan'208";a="665301952"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by fmsmga004.fm.intel.com with ESMTP; 18 Jul 2022 23:23:05 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 18 Jul 2022 23:23:05 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 18 Jul 2022 23:23:04 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 18 Jul 2022 23:23:04 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 18 Jul 2022 23:23:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RK4LxlZrrExKtE9aHCSCoqYV3ISSWuDWl3L57Y5RPfFxqiRXd8+FmihAbQLtYylmCvHONqPCuJ60Hlss1kMUTKaoZL5H/kmS/sn9fStLxyncvF44sukNPzuxqeBwTnyJgjTZz8QL0xgI6I1PPrLJZTdAsTzfCtAvGLKDCGrhiXEez2c0BjVs0cm7cQ77hBFVB+HJ5r/JzHlcyOOCCWRNgBBv3x1XqYVdhYJk67OZkO7YT853NJUzfjO3kp+Epp5ixSlxCFfKFmW+I8UoIiWSCDz785vZEXILrHchWnNorzs4122+J3APxKYj/K9wseErM9Tul4bjhx2AWRUREhb/qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ao3VSJrk/barcPxgk77OHRQm1Nxah1q1dPcbsV9nJuA=;
 b=Ob36VfM2o49wEV0emXqU9TRdjTB1HaZSJ0F+KDufvfuI23iuGYZQOMbb2tL4bkjwX3yG/aMtKdLap2a2MDx5zgZ2sRyI2GYg0HvO7GvXQBLvTzPoSqilxZfbgJzuNfG3i9V6n3uQ9xMw9E14NSmqpf4CIrpKadj1GVjQzKlA0Bv/xCf2TEIgvfj03gDLS7PACrtpy4cIzULl1sZhyeeFIu7mLMfBN+R0Tgw2IAWoWji5nNvYpxla3RfYL1LpYVgyGAa5FbafmU8cydNyRTF7GEVbEI+aEziwQB0248VDnMYj9ng+jhCh3ho0OazjBUCOOFC+Z1jE0Jel4h/CCV36RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB2640.namprd11.prod.outlook.com (2603:10b6:805:56::11)
 by SN6PR11MB2608.namprd11.prod.outlook.com (2603:10b6:805:57::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Tue, 19 Jul
 2022 06:22:59 +0000
Received: from SN6PR11MB2640.namprd11.prod.outlook.com
 ([fe80::e0cf:f32b:a48c:51cb]) by SN6PR11MB2640.namprd11.prod.outlook.com
 ([fe80::e0cf:f32b:a48c:51cb%5]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 06:22:59 +0000
Message-ID: <73a87567-2960-c0a8-7b0e-42247e7ba8b3@intel.com>
Date: Tue, 19 Jul 2022 14:23:17 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] nvdimm: Add NVDIMM_NO_DEEPFLUSH flag to control btt data
 deepflush
Content-Language: en-US
To: Dan Williams <dan.j.williams@intel.com>, <nvdimm@lists.linux.dev>
CC: <vishal.l.verma@intel.com>, <dave.jiang@intel.com>, <ira.weiny@intel.com>
References: <20220629135801.192821-1-dennis.wu@intel.com>
 <62ce1b81a1607_6070c2944a@dwillia2-xfh.jf.intel.com.notmuch>
From: dennis.wu <dennis.wu@intel.com>
In-Reply-To: <62ce1b81a1607_6070c2944a@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0138.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::18) To SN6PR11MB2640.namprd11.prod.outlook.com
 (2603:10b6:805:56::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dc84424b-32d8-45f6-7f3d-08da694f1fee
X-MS-TrafficTypeDiagnostic: SN6PR11MB2608:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +hDfaneA9D4BfW93QutQVmvckiH/FN+ls4DhrusiIQ/kAimjdwWNL695Bl2jkBIH4JhItwlxpYbwMxgbScoGj42U178mqFHUO4eg08Al4Wkqz/NwlVOZJA1Xe98b45WOreE4sNacPgsqreGtzniBV1usv/xixjPrDlmoq2B+gv+4R4x2hp9Qlrm9DHLtFJiCX+AbBKOkWaKLr0+a7gLeG7P9mnIU62EcWvKW/lYSw6e4U7pBdFqXcswnAVQscSQAWBSdc0Hq33ie0YLaOLEwoEeuBhBI4bsekVsVu6CHXDeGiRLxCc4r12mu1fvy3BnH5fAJCLISRlwtNLc2wg4RrNPCLTJbAiSRr3K9e4iAHfqTM4z1DFAj1RSD8QBTl5b/cO0TqL4Rmn0YrJrrIUdroRbTvE/TyifwFUOE/J/YUA14jSY9h8rP59nChD4GH03838a+Vr7G6RJcW2LNUK2tY6JkTDabswzBMi9SmkkN43MePCLTYwGqhSaM8bfeF0eXiQevaJIWFvzUryby2R6YhsYohTH7uuSJAxmGWGtiIaOvddjmiCSxy1It46cIbrU02FTKbBoodqRXYJ2H7/YAThFLllAT+qoDd4+9Kstmp4HsYWleNXc9UN84A/7OeaLTSW6mCb6rGc4Q4zdUe6B+LM7nIKX+VLg4o4aWmccP9HG6fmfPniyiDzug27Jsu4Lh1bIvWUGJN2juxLwwnXQPs07OdjB7Ms4Q7F/iSx04kzaGRLS1R8r7xEkZYmvLUxXLIlCjJBpW8JLj7BsIQ+DY2Shu/H3JCY9iuBYHcxV5HqlHCxHI0D0huw92U906QIA5Nhaom+ifp032rH0/reFj/A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2640.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(39860400002)(366004)(376002)(396003)(346002)(6486002)(41300700001)(86362001)(6666004)(186003)(6512007)(478600001)(53546011)(107886003)(26005)(2616005)(82960400001)(38100700002)(6506007)(66556008)(83380400001)(66476007)(66946007)(4744005)(2906002)(8936002)(5660300002)(4326008)(31686004)(316002)(31696002)(8676002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NGVkczM3VDhkVFRJYjZ1ekFtR0RmVkxYZEVDZ3JaWU9nM0czbFhKV3JneCtx?=
 =?utf-8?B?KzZ1MXRwcWc4cGs1Q2JuM2VKRk14VHVPMVMwZGhkWnZIRzJiZXJYaFgyUU1P?=
 =?utf-8?B?THEzanNubENkdG92b0tFK0tBUWx5QUJUUGdtTVZueHRSaW5CNk01VlZ2M3Br?=
 =?utf-8?B?WWY4ZjJIc1JlY3JvMkNPYUhESllIRmR2NGMwSTh5dDJEbFBtMmt5Tm9IUW04?=
 =?utf-8?B?Vmw2dUx5MzY3UzFqQUVxTldMNlc2YjlPUklMWlcwTTVobE4wT1NPc1YvckZa?=
 =?utf-8?B?TGt6QzQ3OGl2MzNTRFpXNjFzV2EvTlpQN095ZUpKUGRFZWF0d0o4THRZM2py?=
 =?utf-8?B?NzZqYVVab1Y0d0c4MHZNYUpuSGpEYkFDeEZ5QndaRis4a2F6RHlEbkhJMkQz?=
 =?utf-8?B?b1pkUEFnUjFkUWVXaHFiZVp3U3ZOTjh0UVAxNFc5NnRRd1JIdWJLY2ZSOUhr?=
 =?utf-8?B?U0VUV2ZjekU2RkpFUHBEZUd2cWd5c1pZV2NJcDc0RVVWc2picWxid1ptbHkr?=
 =?utf-8?B?VnlrSzZLMERYbFJXTHN4RStiTXJ4RUhjNzNNM3ExUFNseFJyVFVSaElwYzZJ?=
 =?utf-8?B?MkNHWmN6anErYlZaTkUzK2JHWkhJR0RHazdqUldPQjlMSlB0YmZoZVhlemRs?=
 =?utf-8?B?V1N6cy9IQUhNdUE1bDZ0RDBTTVRyelVaamFpYm9LWU4xQ3pZNVVLM3lpb0dG?=
 =?utf-8?B?L0V1REZoQmV3SW9sL0RDWVl0VE02R0ZKM0hlVnJwNGJOblZMVktBaWV1N1lw?=
 =?utf-8?B?MjhqNXdYTWF5blU2aTRrR1R0MnJKam1YSkZHRG5jcjlyNHJQeEVncTJnRnM1?=
 =?utf-8?B?anJ1ZjEreG4rVW4vbGtOTTNianA0TUhwK2ZzTHRjMzJkRFlqbkVOVERyT09k?=
 =?utf-8?B?ZmFvNTkvdUtHSjBOUzJnbDRlYmF5TFBFMVRJdHBmSmw0bkxtYThGMndCeE5W?=
 =?utf-8?B?ekxYcE5rc2FjN3NCcXF2dFMwUFVmWDVQYUJobUdBekVYM3VzY3haZ3F0NjJP?=
 =?utf-8?B?YkN0VkEzN3hmWGZOeXdqMzd4UXpldkdBQzFCMGQ3RzRNS1B1Uk8yOFZ6b3U1?=
 =?utf-8?B?U0xwTzBlNjdRbVN3NmExVDRUUFVFT21uVE8yVG1HMStwT01yWkZneHJMeG9M?=
 =?utf-8?B?aUpFZUJGbUViUkFXaEFCaUc2TVkvU1dJeGw3VlVydnl2NGU5dlRLYmQ2b042?=
 =?utf-8?B?dkFEL1JUZEZpayt3VklsakVHbGgwMUlkZFN2UWpPVDlwdW0wSTBqRm5SY2ty?=
 =?utf-8?B?eDdIbmFxWkZNUHFQdHl5WUlqdEpqRVgvZC9kUEFDZ1N2WldGMUFvdkVaWDlR?=
 =?utf-8?B?VXRPWU8xL1FsSFR5QWRyd1E4SVRIaUJBREVCNmVxRHdFU1FpY0pPaExyczBv?=
 =?utf-8?B?d1NkUlVqd0tpWHVXWmw3WjAyTjl4WmNqUE8vNm5zRkFsOUpidkxUQmZhcG5p?=
 =?utf-8?B?TEd3aHV2eTFjOEZMUFcrUlp6T2t1blQrbENvZVYwMGt3d0plK0hKemRFZWZo?=
 =?utf-8?B?aGRsb1R4SHA5d3RHdUp4Qm5HNkhQMHhtaEVIKzdGalorN1FXL2dWa0d2enV3?=
 =?utf-8?B?VFpuN1dQa2w2Z0NwdXpqSy8vcWtOV3BjTjU3Y3VIRVp2cGJHcWNxaG50d2ph?=
 =?utf-8?B?MC85RGFIRXZKN1cyekVKQWxkWkdZMTVrTEg5KzN0c3M1eEh5MmRqSS9BTjVw?=
 =?utf-8?B?NTk1LzJRWTJ0WHJkQkZZQS9YeEpYNXpaTDh2Sm1Wd09laG51OWNLeFhXdWlE?=
 =?utf-8?B?cm9WaEV6My9EbU4zQ001S2IxRUY0UHVCSEl6Q2hLanNVUzFmVEMrSWVMUlY2?=
 =?utf-8?B?aWpXclBlV2FhUExiSy9qZUxEcEZ2SEhheUd6cmhwcURCRXVPeENINHpqblZr?=
 =?utf-8?B?UHJGMUpSS1daZWdaSG9zUjZUdXMzQjJtUGNRL2xzdnVWYTJDT01PNU9oWGRz?=
 =?utf-8?B?Y05OVTFCUWY1MEVmbGxmVGRsdGdnN29SMjhoRDBHSjJoZUFzVHpNNGVMTWpJ?=
 =?utf-8?B?Y0tHanEwUVdWYllLWDRyRVpKZUhWK3l3TWJPTDVnTFF6SE1TSXhuRTZqVnU0?=
 =?utf-8?B?cERnNFpaMkQyU2NDaEw4bFR4R0JOVS9SZ1NiR1NpVHlUYVJWQzdMV1NvWUdX?=
 =?utf-8?Q?Ny8aurdsdIQFM/oG3J/4lNMDF?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dc84424b-32d8-45f6-7f3d-08da694f1fee
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2640.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 06:22:58.8684
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: maHEmy4loa7I9acLJOlGoHNML7fLQWdo8OcAIwWMyfHPmALlfhK8gSnoQ70THm6s9dmpycFf9tLRzbsRu157Cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2608
X-OriginatorOrg: intel.com

Hi Dan,

Thank you!

This patch is not necessary, but we have a concern that might some 
customer would like to keep "no_deepflush=0" option. From BTT 
perspective, we still would like to control independently.

BR,

Dennis Wu

On 7/13/22 09:10, Dan Williams wrote:
> Dennis.Wu wrote:
>> Reason: we can have a global control of deepflush in the nfit module
>> by "no_deepflush" param. In the case of "no_deepflush=0", we still
>> need control data deepflush or not by the NVDIMM_NO_DEEPFLUSH flag.
>> In the BTT, the btt information block(btt_sb) will use deepflush.
>> Other like the data blocks(512B or 4KB),4 bytes btt_map and 16 bytes
>> bflog will not use the deepflush. so that, during the runtime, no
>> deepflush will be called in the BTT.
> Why do you need this in the BTT driver when deepflush is disabled
> globally for all regions?
>
> ADR only applies at global visibility of stores, so the pmem_wmb() is
> still necessary.
