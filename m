Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC1E10E8
	for <nvdimm@lists.linux.dev>; Fri,  1 Jul 2022 04:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656650279; x=1688186279;
  h=message-id:date:from:subject:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0CIJJw7SuJr1wUrkiHKP4rFDz/3iPTQcqtycZsDc+Ks=;
  b=bI+WA0NhWuGRJ0FLdJPmJF4ZtnaOkdo6tiPQE4IKajzBZPYV3ZRDx7pj
   l94UcXe0j20nYdcEHb0TWgp2+GgAMc0XnC5gkLqUIG6zIfHtkvGlpl3hq
   X765j/j+ZHVz4Rmd6PZmbdr6uTztFeolZcv6xL+0v/8zYTJdaSbN1Swy1
   LHTMZOlK+k9FBQ3UA7jkncxQN8iAl5IQKTrNOrDSoTWGH6d/J2mrDANX5
   FYZs2wEcGDTH9/Mv6pS0EFSqGd5M9Eg3psaHyg4IJEa9ue6Hsf+YD2zwQ
   SZaeVlxHNU/UsrriTD3POzOGiin3i7EB2OuVFUYRgUUCVYDXRVZAiawi1
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10394"; a="262349092"
X-IronPort-AV: E=Sophos;i="5.92,236,1650956400"; 
   d="scan'208";a="262349092"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 21:37:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,236,1650956400"; 
   d="scan'208";a="918327268"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 30 Jun 2022 21:37:58 -0700
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 30 Jun 2022 21:37:58 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 30 Jun 2022 21:37:58 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 30 Jun 2022 21:37:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eC2292YedDNlJ+XDE3pehee+5Iuvb5g3MzOgjlEXotNE3ScslJmZeykUCxb/IbOJzoBioPMWvRYSm7q62H8kXqaIN66oWTxGpRrkRUf27R0Kx6K0c7QSy8nzNmZSx7aKnOHYfAV1k4oJVrA1ncK6GMdXkiZJqmyvZHpo2lQ3o6gM8LwNxdfGYRqhua1ZH2BXjjJEyoIC9L11FjLvatxsTbD+Id7u4yrlZ4kGd1w+w2efIXazeCNYtLIYaq+WaSP57ynXeloRN4v3iSjEqPxIQNfnyGfmWty6t0bmB23d4wgXxN78z+POHvhHvXvL3z218TNHMC0H3PHEN1lsRCxKpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HdQ0Cp3vULcpuieXWW5chL8RDt4gDI0wtXViv/4s618=;
 b=LOZJtrETU1Gu2BShVgdDybuavwAaPBiwhxa70e9IYpKEf7qqhZQ+LV+fLctjkX6AD4L6V4UyDdsBUY+NxBXREFijhm4aDnvdc95gP4ci80+yShq1jUfdy1NY8BlxROZU8I02QWz7s0JIztDO4M/f/ysmD06s7ScGeu6fuAzomwLsMksrX7+xKSSHPD1aD0LqU6fjrFlBUnYKi76gcW5HE1JduSVaxYQSS88aEHdQLCR/bQ5WWyfTOIxlorl6OcSbZaTIKhMMrkqBb6TByWhr+WHs0N6M86bDoegL3Yo6zV4urcJApKokB5PJ49p4+Fdtn4YKLCQTvz5eijblEx/Bkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB2640.namprd11.prod.outlook.com (2603:10b6:805:56::11)
 by DM6PR11MB4739.namprd11.prod.outlook.com (2603:10b6:5:2a0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Fri, 1 Jul
 2022 04:37:56 +0000
Received: from SN6PR11MB2640.namprd11.prod.outlook.com
 ([fe80::60b5:77fc:96a3:8445]) by SN6PR11MB2640.namprd11.prod.outlook.com
 ([fe80::60b5:77fc:96a3:8445%5]) with mapi id 15.20.5395.014; Fri, 1 Jul 2022
 04:37:56 +0000
Message-ID: <ffb9a464-1055-2c74-89b7-c00505a1d957@intel.com>
Date: Fri, 1 Jul 2022 12:38:16 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
From: dennis.wu <dennis.wu@intel.com>
Subject: Re: [PATCH] nvdimm: Add NVDIMM_NO_DEEPFLUSH flag to control btt data
 deepflush
To: "Weiny, Ira" <ira.weiny@intel.com>
CC: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "Williams, Dan J"
	<dan.j.williams@intel.com>, "Verma, Vishal L" <vishal.l.verma@intel.com>,
	"Jiang, Dave" <dave.jiang@intel.com>
References: <20220629135801.192821-1-dennis.wu@intel.com>
 <Yr4kcIC/GaAdfm8V@iweiny-desk3>
Content-Language: en-US
In-Reply-To: <Yr4kcIC/GaAdfm8V@iweiny-desk3>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR06CA0231.apcprd06.prod.outlook.com
 (2603:1096:4:ac::15) To SN6PR11MB2640.namprd11.prod.outlook.com
 (2603:10b6:805:56::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1a93b730-cf31-444f-e74f-08da5b1b780f
X-MS-TrafficTypeDiagnostic: DM6PR11MB4739:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Nbe8Ji94BWDxrI98gEG0iQu1uZlAgVwI4YxA49IaIh3FB7i3yinnazzO3em1NXnvRBCgbGUpOro5HDpXq+R9uI9zojKtmYqnbTgDF+E92Yqi65XY8EINSexqo2HeMkWvZAkORvNTlfamruwa5jFohKFXuLKue4C5sU/lkNvDSP72eXTtNtLvJY2eUz0KYkxQzgN0lrW0cjTSXcSRdIT4LA6TcNKuX722UeMZrSdmAC1NtkEjqqyY9kJ1DalnqhkmEDBcS8IiTWGrEL8Q8+1iJYyoDIOPE19K05DDPM9U0gvT8650E5XrO4lBZi1kkhNT3p2frFr71wi53AXFnIBlQmfwdU8wlPEGYt2fsoAYJIu2uuYhJA0RVUhdt0lUUK9KHBhfgqZXUYp89/gpmNhO6QFxgDDo0TzU+yxXC4sYRZ0s0Yy8w7tS1t0eA8oPWEuyKj4/LqPfWvJq3EAz202F/y7gXeQRra0BLcmgyt8c0h5EqlhWvBASoXGyGk85g3SLUxR2+8IJb+mS4GhlC3aVPeU1nwIhRjPMZ4PnFMukO0DTDlQF95Q0O/SqQL6lMfqtAPSMyB8xQVK/nTRX+GVtKD/qlOywK4ByxCBJfVyQwS3D++Y+/AnZSKxYoWLH9c8JQrSsHOBR9caFf34fX4SFUQD0l1GZZ675r60VeJiiDo9zjV1Do6JVKgp49555dJ+4Uvv/X6mOQWjTRd2cKR/M7orPV0ukvdVba5cKZc5LCEfD7lPmKb5dGPnzAIemlxiJhJrbpUYAlWgAzkPdwcvuDDQ5lVX+yw6IcX+iC80B4YgP43OJj/BMGNJB3+BttgeAPWohY7qJpSYaa57uavc0pY0FRwiPsnfEAx1oSfB0i/c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2640.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(346002)(376002)(396003)(39860400002)(366004)(66476007)(53546011)(6506007)(82960400001)(107886003)(31696002)(41300700001)(186003)(6666004)(2616005)(6512007)(26005)(66556008)(83380400001)(38100700002)(6486002)(5660300002)(31686004)(316002)(36756003)(37006003)(6636002)(478600001)(54906003)(2906002)(8936002)(86362001)(6862004)(8676002)(66946007)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MzlsMktwUlBDTlQ4RVcwRWVHMVZZQ0JLbHlHY2VkSkZ0dmlYWkRUY1ViQml3?=
 =?utf-8?B?dzBvQm9tZTR2SW9nbE9mc1ZUcURTYlkxVmRlbFpNV2FPQUU4WVorZjRnVGl2?=
 =?utf-8?B?cTgrU3FCUGJHcHl3anMxcnRwRFdIcXNvVW85OTIvNThteTRtb2N5SnpjWE84?=
 =?utf-8?B?TE5mRUwvWXo5UnVvM3FIZS9obUZzdWYxRm5HTjV4cUtPWHVGR1k4eGNSMUt6?=
 =?utf-8?B?M3lERS9nSEJxMUZJVGlzU3lhZnUzT3V6Vm5oVXhpcWhISktxcUFkWWJuK2Mz?=
 =?utf-8?B?YVdiUkM0WUlkNHNKUXJhMExzc1JrSzNMMy9RZzRrb3VxTThDdW1OY1RMOHpp?=
 =?utf-8?B?MUFzZFVsY2JRUU80SUJTVEdhdmUzeVBSeHdmZHAvSGFTV0dBVXV5ZXR6aE1n?=
 =?utf-8?B?aEpOeSt5dG5VeDBvQ0pqeTZHWFlxdURyM1pMYUFmMlVldkx4UDM0OS9SblVC?=
 =?utf-8?B?MWNSVThRayt2Qnp3ckxNeGhxa3V6VVJySGhydTR1MndUTDFzUUVQSlc2ZGlk?=
 =?utf-8?B?dk5tbHR2M0FBTXZ6cVdaenV4QWVnZGV3RGIvdGk0dEdmL3JOeSthUXZKOVdJ?=
 =?utf-8?B?M0xhUklnQk0xaDR6WWtiSjZtSHVNOWVROXlHYXJOeVFMNnFCYnZIRVRPTnJD?=
 =?utf-8?B?MGw5eG55TkZKS1JiR2tYbnN4UEdTTDhrOVNseGh6MkVYSzZxQTNaeUhoNTNP?=
 =?utf-8?B?SUxUYjVwRm0xN2F3UWsycEFTUnAwMFJjWklJQ3ZVR2JudFBzeHVobWxIQy9z?=
 =?utf-8?B?UjcyZVZWQndMUkFMZWhzdm84WDFnZjhxdGhPQVExNUx4OUpTaENtRStoeUFi?=
 =?utf-8?B?UmpGUzJBR1pTbnVrSHppU3FObFlwa2JUUG92QU1XQ3dCcDhJQU0xSTBvRmlM?=
 =?utf-8?B?dG05c0xKNUQvdXBMWlNlS3BpaHBMekYvRzVaRjVXWW8xMVdWaGVHR0w5Wjhm?=
 =?utf-8?B?VC8wbHZReGcrN2lRSFNpNjlSNWExVGk5a2ZpLzlESVAzNFBYV1hFcFB0Y0Vm?=
 =?utf-8?B?cTdYUkZBem94cUZMV2R1OExqSTVyUVo0S3dHK20wOTlZb3MrY3RIUDVqcFkv?=
 =?utf-8?B?QzVsWFh4WmlKTjYyN3FVQmN5ZjZ2QmY2bmlVMjl5Y2FrdzZ4dWZmQk1tSXUr?=
 =?utf-8?B?NUdXSFlSVGkvSDVCd1RtTUxhS2xqUDB3NjhLWVdQRFQ4YU1DTTFWS1crT3la?=
 =?utf-8?B?SGxwTVdmaHBrK016NWRUQUtlL0RpeFhyREk3ZGlFbEFsWXBIeGwzVklObjlF?=
 =?utf-8?B?Ykh4eDNsSFNGaDV6R0VFMTVZMm5jZkU5L1J2SnViN3dLeis4VGw3cmlzb1Zy?=
 =?utf-8?B?QzlJdndZSUZvaC9GYktWdjhwY0E1MmFleC9xYm5rZ21Uc0tiOVExTHdWWDNG?=
 =?utf-8?B?dUtWOE41VzZOZFZEOWhkdllMTFdLK3FEZG40WXhlVG5KaGRuNEVJem1sdDA0?=
 =?utf-8?B?WjZRWHg1ZzBNU09EMWYyc09tZ2tLMTVtaHgyVXc0NVBQc1hLZ283eGh2dmxw?=
 =?utf-8?B?VTBEcWMxd05rUEV5SDV2QWN2dXZMUXdYOUVpdmFiOFUzdG9NZ1lhRGh3OU9i?=
 =?utf-8?B?YXF6cUZLVVU1Wnh2d2RUcFd5c0RqYmE4eHpNbU84bEZaWlN3M0ZQeUkvbzda?=
 =?utf-8?B?Mjl1MVlGNWMwaWFLcS82YzRqMnJpeTFNMlFNdFNJVnlNVG9DS0tqYVIrNFRG?=
 =?utf-8?B?YzZUcVBrZWMrMXhjN3ZHcHM1cCtEeUw1aWdNQzlDUmUyTlhIYzlJL3pDczcr?=
 =?utf-8?B?eWhra0Nnb29URkF0ZS9PcHlldUlVaTVYcHcweVBYZmNOZkgzbGNiQnVDcmVo?=
 =?utf-8?B?WldoQTdFcDJZV3ZqVU1MOXNuei8zMHovOGJNSWNtMUdMcFRuSHBkQ3lGTXNI?=
 =?utf-8?B?My95amtpN2s1Z0tMM1BnMmpHakl3enhXczFTcGVwUzVPcHQ3K1VWd2JBYk9w?=
 =?utf-8?B?RjlKWHZNM1FvYVcyQkxSVGF6NmZPSUtiREpqZi96SUdmQU1SLzhZLzFjeUpU?=
 =?utf-8?B?SVFzSXgwN3BjeGtOYXJSN1pOb2NmYkxTTWw5TnBsUU9DbWVodFlGVWZxbW1w?=
 =?utf-8?B?VWgrWUY2ZGIwcWVoRGhiVmNPMXFGcEVpOXZveG9SSU43YWY5N29JeXM0dStT?=
 =?utf-8?Q?ohWs7mUaR0Nk+ytmkiXTldjwl?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a93b730-cf31-444f-e74f-08da5b1b780f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2640.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2022 04:37:56.5867
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MNix9tLHKdeLCzjJncxtew8G0VDWsnu5mr2JqxWiB7m3KKyHIf+Udk6P6bEIKTsV0P7nxTDzkamNlb69YCTezA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4739
X-OriginatorOrg: intel.com

Thank you Ira! Sorry for duplicating the patch.

The first patch is made on the kernel v5.17 and can't patch with the 
latest Linux master and the second one is made with the Linux master.

On 7/1/22 06:32, Weiny, Ira wrote:
> On Wed, Jun 29, 2022 at 09:58:01PM +0800, Dennis.Wu wrote:
>> Reason: we can have a global control of deepflush in the nfit module
>> by "no_deepflush" param. In the case of "no_deepflush=0", we still
>> need control data deepflush or not by the NVDIMM_NO_DEEPFLUSH flag.
>> In the BTT, the btt information block(btt_sb) will use deepflush.
>> Other like the data blocks(512B or 4KB),4 bytes btt_map and 16 bytes
>> bflog will not use the deepflush. so that, during the runtime, no
>> deepflush will be called in the BTT.
>>
>> How: Add flag NVDIMM_NO_DEEPFLUSH which can use with NVDIMM_IO_ATOMIC
>> like NVDIMM_NO_DEEPFLUSH | NVDIMM_IO_ATOMIC.
>> "if (!(flags & NVDIMM_NO_DEEPFLUSH))", nvdimm_flush() will be called,
>> otherwise, the pmem_wmb() called to fense all previous write.
>>
> This looks like the same patch you sent earlier?  Did it change?  Is this a V2?
>
> Ira
>
>> Signed-off-by: Dennis.Wu <dennis.wu@intel.com>
>> ---
>>   drivers/nvdimm/btt.c   | 26 +++++++++++++++++---------
>>   drivers/nvdimm/claim.c |  9 +++++++--
>>   drivers/nvdimm/nd.h    |  4 ++++
>>   3 files changed, 28 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
>> index 9613e54c7a67..c71ba7a1edd0 100644
>> --- a/drivers/nvdimm/btt.c
>> +++ b/drivers/nvdimm/btt.c
>> @@ -70,6 +70,10 @@ static int btt_info_write(struct arena_info *arena, struct btt_sb *super)
>>   	dev_WARN_ONCE(to_dev(arena), !IS_ALIGNED(arena->info2off, 512),
>>   		"arena->info2off: %#llx is unaligned\n", arena->info2off);
>>   
>> +	/*
>> +	 * btt_sb is critial information and need proper write
>> +	 * nvdimm_flush will be called (deepflush)
>> +	 */
>>   	ret = arena_write_bytes(arena, arena->info2off, super,
>>   			sizeof(struct btt_sb), 0);
>>   	if (ret)
>> @@ -384,7 +388,8 @@ static int btt_flog_write(struct arena_info *arena, u32 lane, u32 sub,
>>   {
>>   	int ret;
>>   
>> -	ret = __btt_log_write(arena, lane, sub, ent, NVDIMM_IO_ATOMIC);
>> +	ret = __btt_log_write(arena, lane, sub, ent,
>> +		NVDIMM_IO_ATOMIC|NVDIMM_NO_DEEPFLUSH);
>>   	if (ret)
>>   		return ret;
>>   
>> @@ -429,7 +434,7 @@ static int btt_map_init(struct arena_info *arena)
>>   		dev_WARN_ONCE(to_dev(arena), size < 512,
>>   			"chunk size: %#zx is unaligned\n", size);
>>   		ret = arena_write_bytes(arena, arena->mapoff + offset, zerobuf,
>> -				size, 0);
>> +				size, NVDIMM_NO_DEEPFLUSH);
>>   		if (ret)
>>   			goto free;
>>   
>> @@ -473,7 +478,7 @@ static int btt_log_init(struct arena_info *arena)
>>   		dev_WARN_ONCE(to_dev(arena), size < 512,
>>   			"chunk size: %#zx is unaligned\n", size);
>>   		ret = arena_write_bytes(arena, arena->logoff + offset, zerobuf,
>> -				size, 0);
>> +				size, NVDIMM_NO_DEEPFLUSH);
>>   		if (ret)
>>   			goto free;
>>   
>> @@ -487,7 +492,7 @@ static int btt_log_init(struct arena_info *arena)
>>   		ent.old_map = cpu_to_le32(arena->external_nlba + i);
>>   		ent.new_map = cpu_to_le32(arena->external_nlba + i);
>>   		ent.seq = cpu_to_le32(LOG_SEQ_INIT);
>> -		ret = __btt_log_write(arena, i, 0, &ent, 0);
>> +		ret = __btt_log_write(arena, i, 0, &ent, NVDIMM_NO_DEEPFLUSH);
>>   		if (ret)
>>   			goto free;
>>   	}
>> @@ -518,7 +523,7 @@ static int arena_clear_freelist_error(struct arena_info *arena, u32 lane)
>>   			unsigned long chunk = min(len, PAGE_SIZE);
>>   
>>   			ret = arena_write_bytes(arena, nsoff, zero_page,
>> -				chunk, 0);
>> +				chunk, NVDIMM_NO_DEEPFLUSH);
>>   			if (ret)
>>   				break;
>>   			len -= chunk;
>> @@ -592,7 +597,8 @@ static int btt_freelist_init(struct arena_info *arena)
>>   			 * to complete the map write. So fix up the map.
>>   			 */
>>   			ret = btt_map_write(arena, le32_to_cpu(log_new.lba),
>> -					le32_to_cpu(log_new.new_map), 0, 0, 0);
>> +					le32_to_cpu(log_new.new_map), 0, 0,
>> +					NVDIMM_NO_DEEPFLUSH);
>>   			if (ret)
>>   				return ret;
>>   		}
>> @@ -1123,7 +1129,8 @@ static int btt_data_write(struct arena_info *arena, u32 lba,
>>   	u64 nsoff = to_namespace_offset(arena, lba);
>>   	void *mem = kmap_atomic(page);
>>   
>> -	ret = arena_write_bytes(arena, nsoff, mem + off, len, NVDIMM_IO_ATOMIC);
>> +	ret = arena_write_bytes(arena, nsoff, mem + off, len,
>> +		NVDIMM_IO_ATOMIC|NVDIMM_NO_DEEPFLUSH);
>>   	kunmap_atomic(mem);
>>   
>>   	return ret;
>> @@ -1260,7 +1267,8 @@ static int btt_read_pg(struct btt *btt, struct bio_integrity_payload *bip,
>>   		ret = btt_data_read(arena, page, off, postmap, cur_len);
>>   		if (ret) {
>>   			/* Media error - set the e_flag */
>> -			if (btt_map_write(arena, premap, postmap, 0, 1, NVDIMM_IO_ATOMIC))
>> +			if (btt_map_write(arena, premap, postmap, 0, 1,
>> +				NVDIMM_IO_ATOMIC|NVDIMM_NO_DEEPFLUSH))
>>   				dev_warn_ratelimited(to_dev(arena),
>>   					"Error persistently tracking bad blocks at %#x\n",
>>   					premap);
>> @@ -1393,7 +1401,7 @@ static int btt_write_pg(struct btt *btt, struct bio_integrity_payload *bip,
>>   			goto out_map;
>>   
>>   		ret = btt_map_write(arena, premap, new_postmap, 0, 0,
>> -			NVDIMM_IO_ATOMIC);
>> +			NVDIMM_IO_ATOMIC|NVDIMM_NO_DEEPFLUSH);
>>   		if (ret)
>>   			goto out_map;
>>   
>> diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
>> index 030dbde6b088..c1fa3291c063 100644
>> --- a/drivers/nvdimm/claim.c
>> +++ b/drivers/nvdimm/claim.c
>> @@ -294,9 +294,14 @@ static int nsio_rw_bytes(struct nd_namespace_common *ndns,
>>   	}
>>   
>>   	memcpy_flushcache(nsio->addr + offset, buf, size);
>> -	ret = nvdimm_flush(to_nd_region(ndns->dev.parent), NULL);
>> -	if (ret)
>> +	if (!(flags & NVDIMM_NO_DEEPFLUSH)) {
>> +		ret = nvdimm_flush(to_nd_region(ndns->dev.parent), NULL);
>> +		if (ret)
>> +			rc = ret;
>> +	} else {
>>   		rc = ret;
>> +		pmem_wmb();
>> +	}
>>   
>>   	return rc;
>>   }
>> diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
>> index ec5219680092..a16e259a8cff 100644
>> --- a/drivers/nvdimm/nd.h
>> +++ b/drivers/nvdimm/nd.h
>> @@ -22,7 +22,11 @@ enum {
>>   	 */
>>   	ND_MAX_LANES = 256,
>>   	INT_LBASIZE_ALIGNMENT = 64,
>> +	/*
>> +	 * NVDIMM_IO_ATOMIC | NVDIMM_NO_DEEPFLUSH is support.
>> +	 */
>>   	NVDIMM_IO_ATOMIC = 1,
>> +	NVDIMM_NO_DEEPFLUSH = 2,
>>   };
>>   
>>   struct nvdimm_drvdata {
>> -- 
>> 2.27.0
>>
