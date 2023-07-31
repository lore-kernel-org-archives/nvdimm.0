Received: from mgamail.intel.com (unknown [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E6618C3F
	for <nvdimm@lists.linux.dev>; Mon, 31 Jul 2023 20:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690835293; x=1722371293;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=enM72KUK0tHttKomBxqnBEarQXuIdlI8ODgPSVFCKZo=;
  b=hROTVIJkRtRrG0xNBg1UrUe62j/UhsG63NxU9daWauq4GseeYt3WnjWp
   ee7uAd7cYkKCceRX7BWX8ofB6FUG8mfbqLcrmIL8Q786u5EHQPnlMAkcV
   EVxwr5ygI/sAw+BO7PRLltqY8B9zD4JGY1frhcvG4lnSdgj8FgWF18yCP
   R/H/s852hLOn8T2i2+SuJmRMLYyJzCVCNNKlke85abuJk5x97KykgBY1t
   doLDi6dD3uFzMAfDBjys400BtqKSFFkaxJYCK3ydQZ0ZwKYRwBj94iImN
   AJE9Y8PA0iKyg4qne5jXbUGjh+fCsHaIBegoTF6mhdWDN5zA2HcmKun/7
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="369124397"
X-IronPort-AV: E=Sophos;i="6.01,245,1684825200"; 
   d="scan'208";a="369124397"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2023 13:28:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="678449746"
X-IronPort-AV: E=Sophos;i="6.01,245,1684825200"; 
   d="scan'208";a="678449746"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP; 31 Jul 2023 13:28:11 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 31 Jul 2023 13:28:11 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 31 Jul 2023 13:28:10 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 31 Jul 2023 13:28:10 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 31 Jul 2023 13:28:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bEAcyozSHEy8/44ZPmjdM+ngKtLIpM654+HbB7ZzVKNPXUptYSOX2wgtzsv2hbUSnk3NA3xNWzyHNEjk35yrmgWy603+DAqsfIwOzz3e0IGVTLaXiO/WnMIF0GUYoPdrtSJp8/cDBl2gWebayakv0rm9P6iXze4x1ObVkc/SK0b2j9Pcpkcyz2c9JKt6xEyC7jmwgyRqh6P+YuaBX2XazQAImMTQgwAZO0PDknHHDLzApLf0x5bbgRqbnbi3oGuaDyQI11JDC9UNTZTZRxBD6Q0pPWD/YS6Zru2vWD0FMNfZCI6/+MzU/HP2tGrF83nnZYpE1d2p3MWFxb+2JknpMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fa/87kjHW+Kb9ZycWMBC38QM4ayd9Rmye0KD0BY5iNo=;
 b=GfMTIgpZGZQ5QBPd1AbYjNfnQ/LjbgtA9ZV6X4MeOX8AjjS/ch5K0ILvDfvaKQs1AzcLi3XTBk9CmzyTHn5zNIjVMiTOoLkfj1q+cVn7XtiQ/AClNyZ9JgEkHjSBLx6j3O/c/PooB8G1nPrY7qi937TZF9OQIfZJ/Lj5KdS7kV/isJRdpy01+fO0QP9KExAcI+SUvG/r5uC7pCR6UTvgtOR36gHXI9k5o7p8T2XYNEc6oK91ivItcmMXVIBj4yHroYUycW0Z8GaaQugDpLYf7iEJ6XlEnxt4VWWsWkHltOIkN5qd7JNAOgE01lIDisdE0rXNKh6RJ/f5/KfjPxMbbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5984.namprd11.prod.outlook.com (2603:10b6:510:1e3::15)
 by PH0PR11MB7588.namprd11.prod.outlook.com (2603:10b6:510:28b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.42; Mon, 31 Jul
 2023 20:28:09 +0000
Received: from PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::be6a:199e:4fc1:aa80]) by PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::be6a:199e:4fc1:aa80%6]) with mapi id 15.20.6631.042; Mon, 31 Jul 2023
 20:28:09 +0000
Message-ID: <cbc1f98f-0f1d-0025-906d-a57b79c1003c@intel.com>
Date: Mon, 31 Jul 2023 13:28:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Betterbird/102.13.0
Subject: Re: [PATCH ndctl] cxl/memdev: initialize 'rc' in action_update_fw()
To: Vishal Verma <vishal.l.verma@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>
References: <20230731-coverity-fix-v1-1-9b70ff6aa388@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20230731-coverity-fix-v1-1-9b70ff6aa388@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0071.namprd11.prod.outlook.com
 (2603:10b6:a03:80::48) To PH7PR11MB5984.namprd11.prod.outlook.com
 (2603:10b6:510:1e3::15)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5984:EE_|PH0PR11MB7588:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ce115db-756b-44cb-47ae-08db9204a779
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BqaVLe+nutfIH2tioqRQ3+IEjZWdSQ1e3lyPbwnRd/W8Pv3DOVaBqd545A35uwDr1vYb700FtFknKiOPyP2ByWcV65niPSKxD7RJfjtzn5CqKQ3dZ/LuKWlp0ohT8KRidHTJVx19rVDTS/3kRgAMEpCaKGLnjID/9hep/A+bu8UQgIUeabBmGVy0Q8NX5buXqrrGyk/6A/NTL/gut7vjqs2grWhOc1DTV3W6Q3R6Ci4wCtn8eWOVGS2qobJLx3CwQeiTfSHJYb7gjeSDBnvDXv9Sd3xlLxd73uRDVuuVkIToHyE4I5SbSszBimDQfN89LeYU6oQLyYqcgf1EKQQsLIlosigmF/47rD2PMqZuop7Nrr3BRLITv2kFfomMkxRI1UX2s2bYE7YWtmwcwt9a/iRyS3sCWAVXXZ0EFM83CdH6gjHoN1JEJGk+PCZVvGW0E+RxYcTLjA4ZABPbltMy1tRIIU5EuKsj27Ko20xD4aVgm/vRqZfaB8l9v5uhtCOS9wzkqGEBqT3alv227z8IddOODI29VWChHfnPBBdvSrH5YIoIZAWAjyMFiW17BCWvo7kKvwDPy/pAqNIlqxg1+VqwGEmmVbvn/9kYvmJYcNJLiG+QpDSqkcfizH+uCG8T8zYMM7L4PGZfYorDczDuLA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5984.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(376002)(346002)(39860400002)(396003)(451199021)(2906002)(66946007)(66556008)(66476007)(5660300002)(44832011)(31686004)(4744005)(41300700001)(316002)(2616005)(6666004)(6486002)(8936002)(6506007)(26005)(8676002)(53546011)(186003)(83380400001)(82960400001)(478600001)(36756003)(38100700002)(6512007)(31696002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N0Vuc1N2NXlScjE3V0xIVzRrQmNVbnVmbzdocFJoV242S1BLYUh2bk1QdjdN?=
 =?utf-8?B?Tm02VGhTY25DUFNNQ1BUT25nQUZNcnpxc21DclJxVkI0MVdrWnQvd2lINjJR?=
 =?utf-8?B?RXYzSG9Qclo5NXVTUXF4TFZNek00UU9waGlIeWY4aVplcnFhQ3BBb0dRMVBu?=
 =?utf-8?B?dU9DaFlXcmZJRXVNWXVjYmpVcjBySmhqVFYzVUlXRkhWOXFEODdUMDZSN3Ex?=
 =?utf-8?B?N014L0tRS05XNnJTcVRBT2VZaE1KZC9tZWt6SlpDQUpDQWI2UVN4WnRwUDhH?=
 =?utf-8?B?VTYxR3BQQ1lnYTI0Nk8yME5TM0ZsVC92cm9IVzd2SU4yTitoZFhwTXN4WGhr?=
 =?utf-8?B?VlVaUG9OckY5R3JOcVJQTUlGT0hQcnU3ZFBEVjRUK2JqbVNaMzluWU1ZQjd3?=
 =?utf-8?B?UGE2Z0F2cERGUUF1MkZzaTQ0S0dFb3NYNUxyVC83dEdyQTVuaEQrUXQyUkdt?=
 =?utf-8?B?M2xuUFFXZWF0aTJ3Q1NOUjNCdExRako1Tll0d2ZCckptWkZnT1RtSVpMWUJF?=
 =?utf-8?B?RHBBaitwM2ozb003WkxPMVpxSXl3RVdyeG1RUk11bEE0RlJlUVlqbkJ6akVl?=
 =?utf-8?B?Qm13ZHQ5emE5TmtZbHY5VGlta2VWS3QrTFN3R3l2VVNFUGRvQ2JYeWh4bGhp?=
 =?utf-8?B?WSsrc3dRQTRzajJ6b1NNdFNXcTBvZVcyTzhBL3dxWmZybGorRmhVcjNvdVBV?=
 =?utf-8?B?SGphVmc0VThqL3puUWtTQndaclFWaHE5TWd0K0MyRDFFc1NXQlJCeG5wVm9i?=
 =?utf-8?B?RUU2T25hYTFBVndhMHlCK2xKUFhEYjhmY1U5R0xoMWhLVUg2NmlrWWxNdU5s?=
 =?utf-8?B?QnlicXIrdWtwczR1ankxOEtPbFgvaEVjK0ZKa3pGTGtZSFVldVI2d29kWWlq?=
 =?utf-8?B?RFp1c1Uxb1M4LzFlcnYxM0k0bTFWQnZGbmMxaHpJN3JjTDdiczJvWXBHVjAx?=
 =?utf-8?B?WVJHb01uMkZiaUdiUzJoL2xXTkFoOHljcHBseGFqMG9zVmZyR0VGd1pMcDZO?=
 =?utf-8?B?Vlo3NEMzVGtvRFRMNmZFWkhIbEc4c2xVZGhUU0hzSmZHTzRHSzVqSjVKZm13?=
 =?utf-8?B?b0NIOFVpNmwvSk9MdndyLzZsZy8xSEdjRkZUNTJ2bDJVT2YxQW5VLzNRNmhj?=
 =?utf-8?B?Y2xBbnVnRWdxVnFIck4yRXNpUDMrV0d2cjJ4akg3U3FURFpRSk5NK2dlMHZy?=
 =?utf-8?B?Y2ZpT2RNQXB4cWY5VHZzMHZoMUpuaVVTSFI0ME1ja3BUSHhRcFluSi92bFNG?=
 =?utf-8?B?VkhxeEVIOUg3MWVaWm01bjVFdUpvaVUvR01PNmpMS3FVRjVnUnRvZG9RUGRw?=
 =?utf-8?B?R0NhOTZ4RERVeVB3R3VQcjE0TEhiQVpIcE9qZmZwRm9jU3RQbEt5enMrZXg4?=
 =?utf-8?B?MEM4NytDdTNudzVvdDViM3o1VjN1cXJubVl4VWtQMkJTTUxmMUZwYm5tV3lW?=
 =?utf-8?B?NjRYd0NPOFJmSDNWL1MwMmhPc2JiMGFTWGh5LzhvYWI1RXlSQXVmdElGSjJF?=
 =?utf-8?B?eFRaclM3cnR0ZUF3a3ZzbUxFWmlJbG5YZWdFc1RaeG1GREJUQ2ZWWHlSZnd2?=
 =?utf-8?B?SkgvdEEyK0dvSGhJSWtydk43OTRXZHNMRG1kOVZUV0VUWTdsYmFxYk1qV0ZV?=
 =?utf-8?B?Q3lzUkFkalhCa3RmZXVjckJUbzdTZ3BXaFIrR00zbll2OGlSVGJlQWcxeG5P?=
 =?utf-8?B?ZysxMnpVcXZwa1IyNXBEKzA2YmZpNDNwdWY4MkcwUnhyTVBzV2ROVnB5VzJD?=
 =?utf-8?B?ZFpOMXZQUzlWSkZhRG9LbmdLZTNzZWIzbWtGVHBVdWFaMEc5QnliendPMFdL?=
 =?utf-8?B?bW5JSVhRWFd3VlRjZlIwdTk5UHZid2MwaW5XZWNqNHFseGJia1lMZDR0eUQ2?=
 =?utf-8?B?aitIbjh2Mkl0NzdwV2hlRFR3L01iWnp3VHRiY0xXV25vMit3aGtJVU9MZFhS?=
 =?utf-8?B?K0JmcGNidVVyZE5Nc28yVSt1VlpkbmM4bGE3K1JjMnFpYlRBZm9xUEJIUVY2?=
 =?utf-8?B?ajZqdDlEamhmeTdYbVJVa2VYWDBxdlhaUW03c3lMRmVVZ1d6NFF6UzZHS1o5?=
 =?utf-8?B?YnNXL2p6S2VDSWZraG9XbGxLVkp1MUZkL3BReEpPUXFnNHJvT0FzR2ZwelBE?=
 =?utf-8?Q?UDGzD7suybcGGn1U6SMcDYYOv?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ce115db-756b-44cb-47ae-08db9204a779
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5984.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2023 20:28:09.3397
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jJ8F5mV+7VtVgR7LrXiWzfflVibKVLnA3bubQ9kwQqvH8vnj8lRlZU9UHLBqAaZoshUhgSOOL2f81+VVqsVHBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7588
X-OriginatorOrg: intel.com



On 7/31/23 13:18, Vishal Verma wrote:
> Static analysis complains that in some cases, an uninitialized 'rc' can
> get returned from action_update_fw(). Since this can only happen in a
> 'no-op' case, initialize rc to 0.
> 
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
>   cxl/memdev.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/cxl/memdev.c b/cxl/memdev.c
> index 1ad871a..f6a2d3f 100644
> --- a/cxl/memdev.c
> +++ b/cxl/memdev.c
> @@ -679,7 +679,7 @@ static int action_update_fw(struct cxl_memdev *memdev,
>   	const char *devname = cxl_memdev_get_devname(memdev);
>   	struct json_object *jmemdev;
>   	unsigned long flags;
> -	int rc;
> +	int rc = 0;
>   
>   	if (param.cancel)
>   		return cxl_memdev_cancel_fw_update(memdev);
> 
> ---
> base-commit: 32cec0c5cfe669940107ce030beeb1e02e5a767b
> change-id: 20230731-coverity-fix-edc28fd6e0fe
> 
> Best regards,
