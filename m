Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C005B1549F
	for <nvdimm@lists.linux.dev>; Tue, 25 Jul 2023 15:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690298091; x=1721834091;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eS2rMcZkGGkU+IPQzM0SUHJjeraQKObrrywr6VXKuco=;
  b=lXMMoWNYX+i609QDjxaa51G8U2YzHBtAWjZM6C3DePB9Do9j5AajLoSx
   WEBylZd/fPa4Dm9v8rHbOcAhk8Ur0eFxX2j8wT2bLFQt4cd31n5zApyQY
   qQlfhTefjf7dBF/3QRar52yIwcjK1ue73QFcqQai+rzEBDIwBxWG6e4OA
   BuUzj4DJoV/b/Tw7w+Iwx45tW6+tgi/BtukJeo0shg81u3G4q1Fa2w4N1
   m/+Ao2hY3eqWLUo205PT55NkgrzZtMUwDnJ2mJSSbdCq3X3XgLxE3ethg
   JKhF8U7rJWo193Cm3Mrox254H6VutB1+/6AYHBS8YKmTxJUFD2C7RPeOC
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="357759529"
X-IronPort-AV: E=Sophos;i="6.01,230,1684825200"; 
   d="scan'208";a="357759529"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 08:14:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="726149401"
X-IronPort-AV: E=Sophos;i="6.01,230,1684825200"; 
   d="scan'208";a="726149401"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga002.jf.intel.com with ESMTP; 25 Jul 2023 08:14:38 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 25 Jul 2023 08:14:38 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 25 Jul 2023 08:14:38 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 25 Jul 2023 08:14:38 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 25 Jul 2023 08:14:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pl9AlDc6Z6H+YoDDWOoKd7nUW8pI1uz28vAczy0qbzgTwgWGFdVtMon6U96JJ0q0mRVTxBBha8T/ZZ0iNp3VQD0DnkUmMM2+OHIdBvlBxlkvCxMHuozT8qE5oJ9raXxAVqXwiDS7Kh/Ud68ePmfoR9uoIzJjpsVpNctOfysmE0fWRXgUGNXmHXdSa4D6APWIIYJvYAMYPwGQzJPInh0OdJ1nvOKcGr3wTEZiboNaY0S/yqeR+XnKzJDztxyG0csYmkqalucfGNWZqnaDOXW0GOnW/4WO7kI1BSUyZeutVJSwczl7zL3YGxnOnqIog0HisE3L/wqp1UfMVyV3ZPt+Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jYgP81yawcK7lvTdan7n+SGQMVbC4lenoEZCi6CPJUk=;
 b=JtG720plBwkG7CcnI9L058u3AXSbGEla4H2jGJ881sB1JrWrbUL/eDYdNsbSKsvDMY1qm6P1Lxdu8+UpMGREDCVzx2tZpf9agfz9DhSyJ/y++LBaCK++Kf0NOH5wntQnqsSlWq+egXOUm0NCSvLtnzHY6SlJOujfw/IBvXIl5q8sSdlP7qReI+VoaDRxQXUeiLOMq14aoX/uIIX9mS7rfIsd2+LTyWOJB5jM7sdDYw5FHL+ZQCwYoME3/UprU5XBFVSa5WSJhWDwHk21SzHINZVPE/lvLu+GZgX4nXw94Pada8HJD8LN4RGZYuGQDjLyP89TB9C8WooTV9L11XYDrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5984.namprd11.prod.outlook.com (2603:10b6:510:1e3::15)
 by LV8PR11MB8461.namprd11.prod.outlook.com (2603:10b6:408:1e6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.32; Tue, 25 Jul
 2023 15:14:29 +0000
Received: from PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::be6a:199e:4fc1:aa80]) by PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::be6a:199e:4fc1:aa80%6]) with mapi id 15.20.6609.031; Tue, 25 Jul 2023
 15:14:29 +0000
Message-ID: <73ac6fc5-50ce-bde8-d77b-c28499b04436@intel.com>
Date: Tue, 25 Jul 2023 08:14:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Betterbird/102.13.0
Subject: Re: [ndctl PATCH] ndctl/security: fix Theory of Operation typos
To: Davidlohr Bueso <dave@stgolabs.net>, <vishal.l.verma@intel.com>
CC: <nvdimm@lists.linux.dev>
References: <20230725015457.31084-1-dave@stgolabs.net>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20230725015457.31084-1-dave@stgolabs.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0039.namprd07.prod.outlook.com
 (2603:10b6:a03:60::16) To PH7PR11MB5984.namprd11.prod.outlook.com
 (2603:10b6:510:1e3::15)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5984:EE_|LV8PR11MB8461:EE_
X-MS-Office365-Filtering-Correlation-Id: a549dd61-289c-4173-4f6e-08db8d21d749
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C3xZWsLrz4mPihWT6ktDMe52+ifYN3wNHbl0eWuP0nUHFN2xWb9BWN6VRN+m0Sl4pwkvOoyoG7JhD2gdjdVhKDIjdGtDacstjQr3gz6phCB/XrIQS4hUPf+5H0sXKzQUpsv/b17UzjlaVJWMYSmx87xia5/LaU+S9DQ2ufcZ2hKztuButXbgRx1LS6peUwxUCvmQvbNobS8n08eCuIdbKbCyNYvJjONLdrTKbzO7at9ycbK5WOF3jbSFcpJPxr6xLSnsMcrUmWqGQFOBslXfArszrzjtd/TCV91sydI+sV0OD/QYaa9QUeHuvSsM9DNcfMgDjkP15n3Q/rpPhR6TiMaUcLvXkxA9L4OrNH0zYjWVUAB63OMaNZCMkJLIPOEWSQbruTLQaUF3gPlHUEgVvwLgssD4Maj0OwcywwEsaDeulFRAKdX45o4gmkZi021kX6zmy8J3UHQgs8Rs/Up+xcvdkl07J15XQiQhPMOvKedGqWUM8LFG8Nu5K6GUKemQ/dMmHq5ijnA4+2g1nXPneQBAuGekI+FFF6MMC9lg+2ixDlf6lY37r90Rnxhd0nVaBXhkEeUUy9X5Yal7pVcou50DVMhnmAMrvu3xbUd9kPOPDsWAFGPLC7PsqKg891jYUCBBmYoWjJv0BW4/bJPZ4w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5984.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(366004)(346002)(136003)(376002)(451199021)(6666004)(4326008)(2906002)(66946007)(66476007)(66556008)(478600001)(6512007)(83380400001)(86362001)(6486002)(31696002)(36756003)(186003)(82960400001)(2616005)(26005)(6506007)(53546011)(38100700002)(6636002)(41300700001)(8676002)(8936002)(31686004)(5660300002)(15650500001)(44832011)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eCtYYTNiY1dvMWlVT1VEWEpXZGdKbHlFM3FFcXZpcEJzRC9mUGRXS3M2Q2lC?=
 =?utf-8?B?SDFyUzI2QmtJL0kwL0t5aS9xYTVsVGxxZTNncmdUUm5DQTFTTlR1TkRmYkFn?=
 =?utf-8?B?NzBkcFVSWUQ2SXgxY3NRNG5ZeUZ4eW80WkM1ZThKS3VOaEgzQzl4YkkrWmpo?=
 =?utf-8?B?VzZEalIyeWpTeEx4aFp4cHBQdGtMTVcyUGVuM2hjY1NUUVIxTjFxYitlV3Ra?=
 =?utf-8?B?Z0xqOVBzYU9TYnZIQmwwbGVra3pqTWFEeTFLbUx6NEhuOFFRSEF0V3pTRThw?=
 =?utf-8?B?Ukw5VXEvajVzNDZRcmZnQ2tHSk9WZGRkZWRrZGFDTVhOMldORzlrQ2U3VkJB?=
 =?utf-8?B?bGt5THROTGR5SjlhNEtDZHRzOTF6MHUxU2RlTENETFdKZmZVTU9FUXRyclNt?=
 =?utf-8?B?MFhmVGxJdnRpb1dPbFhBbkZtTDVmQnB5bHlRUkRNYkdjcTIyL2wrZ09ML3pm?=
 =?utf-8?B?aWd4WFM3T1JDWnhTMFJ5SlVkejJ6Zno1S1N3UStrQmVqdi82OVFUK3dwWnlE?=
 =?utf-8?B?V1E4TUh0bUNxRnAxSzQreCthWkhLYU5YZDl2SEJ4WklSaHlEZ1B3ZVVPNzZH?=
 =?utf-8?B?R2w5cHdvcHY5UE5xZXplMno3clNtVWdGT21sN3F6RFkwRStRM3RhOXhCa01q?=
 =?utf-8?B?aHp1ckczUUtFV1Qxc0QvY2p6alN2bmtSVHJBb3dSVFIzb3o4ZWVVbmZMdzIw?=
 =?utf-8?B?dEx6MnQ1SjJtK0hsWGx4d2xTd3dkNERSYzVGUE9NcTdhL0lVamJaRElUVTV3?=
 =?utf-8?B?dmZNU3VyRkdJZEdUZ0tiWWZEaUVES3JvbXJwaHlCQjFaeWhBNDU3cXMrdmtl?=
 =?utf-8?B?WmppdnhyT0cxaU04RGJLMGFXQk02bTNxVi96azFrVmplRGk4aklNbGFJMHJs?=
 =?utf-8?B?SUZuUlprNkx6MFpiTnVOVnVML3dWQzJ2OWNvbjVFZkExcTQvTExKa0RrL3lm?=
 =?utf-8?B?alB6allsS3ZjTXZ5V1Z0TkRTeGNOTzZUdnc0UUFRY3RCWE5YQTJJRGVhSExJ?=
 =?utf-8?B?SFNTQXc3eFY5eldtYitxQ20xMWRETHUvTStSQTkxQW5aVWErQnd2NVJQWDRs?=
 =?utf-8?B?UEhpTmg1RVR0bVhDZ3Z6OGFLV2NoR3JnaGFnVU16ZkxiYUkzdVpWQS9XWVp2?=
 =?utf-8?B?VDFGZVF1SVFtTEtCUGU0WGtJdVNhc0VIa3kxQ2hCekxYeVBZbFkxVmFQT3k1?=
 =?utf-8?B?dUttTkxrK05XaHZHOTNYNXk0OW5IRjVpc3hoaldlam9lYXdPeWtlOFRzdllv?=
 =?utf-8?B?eVlBSTdOYTZsUWlPSVhIS2owTlpGUXVkSzRZbnhJNTJPWkhpRlA5S1BMaU1x?=
 =?utf-8?B?SEpVSUFaeWZXUC8zTDZMOWtsb1pVbXNOaWVBRHVJRCtyTzY2SGhud2hTSWFV?=
 =?utf-8?B?N0RaNys3RStMb2g5Qmt2M1NxNlgzQTUvckQ5STRHM2wvbkd6SzlsUlZzTWl6?=
 =?utf-8?B?TnVjRnpuZHRNNU1NMWVXS2ZxWmlBRWdkYmRFVHgyOXN3b0hGN2x3NnFjMWRq?=
 =?utf-8?B?ZWtLcWV4c2lzSmZ3OHlKejhNL1ZUSnFRZE9YcHRwY2xubk81YmhFQm00aTNI?=
 =?utf-8?B?T1BOMEFWN0M4bjRLck9JcTBkZW9sZk1JU1BUbmRMQmR0ZHVxN3hHcVBlYUJy?=
 =?utf-8?B?MnIybWtJNFhmRld2Yjl0UFVXdFczamJIemc1OUZ5azdkSzc5d3BiRytQL1g4?=
 =?utf-8?B?aDVaZGswQVZDNDE4UkZiRVoxaGMvanBhbndwQ3JsK3Z3S243U202WG8zYXR0?=
 =?utf-8?B?MVVheFppalAyZ0VIRDgra3VWTldmOE1jOVVVcnF1eGZkblZSa04vSENIOVM5?=
 =?utf-8?B?S01XTTRLbmhjK051dHRia2tDenZGak9TTklxT1JEMStCTVFBQXRIdjNkV0dm?=
 =?utf-8?B?N3cwWVR4b2J6T1lqVVVTVThQTm1iUUltcHIxVUw5V1VsZjF5WTcvc0h1KzJ1?=
 =?utf-8?B?c2NwV2RSbzZKN0U4UGRSbi9mR2R0YnVNbkh1dDQxaktWQ1pVNG5wcWVGa0hx?=
 =?utf-8?B?T1dxLzk1VXBFbGswa1ZzVlRGdjFERjNtT09yVHA4WkRXTUpaZXFxUXRYL2xZ?=
 =?utf-8?B?TGJJY1FmK2hBaVRQR1krZmxCajRidDhwR016VW5kWW5FTHNoS0g2U3NQa0tO?=
 =?utf-8?Q?s5sVe3VcnItxA6nS7yngXb+7b?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a549dd61-289c-4173-4f6e-08db8d21d749
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5984.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2023 15:14:29.1356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lLGHRjKgDtMiFv3VoX5BeGe3rV+fFm4jvVPJJXP4TCquiVSwwNIToSULw8Rg92FMiiEf/NFpWa+rzGqjoje5iA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8461
X-OriginatorOrg: intel.com



On 7/24/23 18:54, Davidlohr Bueso wrote:
> Noticed while reading the file.
> 
> Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>

Thanks! Great catches.

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>   Documentation/ndctl/intel-nvdimm-security.txt | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/ndctl/intel-nvdimm-security.txt b/Documentation/ndctl/intel-nvdimm-security.txt
> index 88b305b81978..4ae7ed517279 100644
> --- a/Documentation/ndctl/intel-nvdimm-security.txt
> +++ b/Documentation/ndctl/intel-nvdimm-security.txt
> @@ -4,7 +4,7 @@ THEORY OF OPERATION
>   -------------------
>   The Intel Device Specific Methods (DSM) specification v1.7 and v1.8 [1]
>   introduced the following security management operations:
> -enable passhprase, update passphrase, unlock DIMM, disable security,
> +enable passphrase, update passphrase, unlock DIMM, disable security,
>   freeze security, secure (crypto) erase, overwrite, master passphrase
>   enable, master passphrase update, and master passphrase secure erase.
>   
> @@ -115,7 +115,7 @@ This is invoked using `--overwrite` option for ndctl 'sanitize-dimm'.
>   The overwrite operation wipes the entire NVDIMM. The operation can take a
>   significant amount of time. NOTE: When the command returns successfully,
>   it just means overwrite has been successfully started, and not that the
> -overwrite is complete. Subsequently, 'ndctl wait-overwrite'can be used
> +overwrite is complete. Subsequently, 'ndctl wait-overwrite' can be used
>   to wait for the NVDIMMs that are performing overwrite. Upon successful
>   completion of an overwrite, the WBINVD instruction is issued by the kernel.
>   If both --crypto-erase and --overwrite options are supplied, then
