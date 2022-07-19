Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234AA10FA
	for <nvdimm@lists.linux.dev>; Tue, 19 Jul 2022 06:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658210453; x=1689746453;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OZcbEm8LbiVPPBj9j3qjlO4/qOLuFn/yTgo1G4UYpi8=;
  b=HHNwa6uK+ocbrbXLibPJGuPLhpfdYX50XWGJWw2lxHAv8KEDiOdAYm0x
   5wOV8nNdJy0YQ5zk6vCaliYOPXecLVDJuvsye2L5szyqiC6Uqs6iOvMwz
   Vz0TDeXMCidho7aESnFLWxrKjrjaEkZHRlmAEpNCVpPUZKr/5XP55/L5z
   2bG1i37Y4FP9ldc1ecHDgJ+dJKgEzOn4V4yXc5GLbrNz+eXAC4ClEEGkq
   8xxGt13U/ukbCZBdkm74gn6N/pL3InPjQ8hc6EtOYyd9x35DpMT89QPmZ
   7QhXPcNv1oAEeCs8YLgR3ZrUiJpe2V/1MfyO+TLwBetgepiLrvHIOA3po
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10412"; a="283966013"
X-IronPort-AV: E=Sophos;i="5.92,283,1650956400"; 
   d="scan'208";a="283966013"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2022 23:00:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,283,1650956400"; 
   d="scan'208";a="655604827"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 18 Jul 2022 23:00:52 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 18 Jul 2022 23:00:52 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 18 Jul 2022 23:00:52 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 18 Jul 2022 23:00:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VurrIowij8MhWQVQ8Dza36KX7qUT8nY8Fvx+GDhIflh/I+4er+IfynOMLF4MrrbLP8SgsmSefZ2Q1H7T0Wrxf++8lw/b5qIQTvkWwqKg+ANdqZQOb8csI18y8BQBJ56dg6+jkAtSo1sGPKNLPBVukqzNp+RKwdjHqHLf+UBCOKoo3dC2djckTGE1LOwns4Ty61Vi4kpFHApA9PlGcqLxpjYNoWkjp99sE2GWbhSOT1zSn5pVOaHfpgbo+zwDFQMlSr/OOAYgKBodaV6j7nNF5/tQXQ3cmm2aECjgaMs0V4ASN+g/kV8vCC14Ma5jvgquzgNJ1cLWhCALGxYF0I0WGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hzopIIMvi1KXoPVJ8CF2c7xnjq5DY8oJ4mpst5o7o6g=;
 b=Ss4tp6/SGouSqR4MXW8iwSFBp6i/hUcIER9hTfqYSQd7TpEp64fNxsCCM973HQonKckbu1IgHHMIvmA7Msyv/kznBRKiGZawlOuVxiPfvukg8wpG90FZT9fMNEug/OLuAqIL2gXTovi/Z3X6FsYmJW4sNYT4TpbZgOceXpPkTTUjXYcBUYtjs4uioP0ckW1UaRXQot6qCVZTsY5SeGQOA6eCRhEESKWnKBWaGhjXpenwefWlKPp8yj4j3ZlWO8CDj7+2PS3YHtcndS1xurJY5u23UGEsH4iBZPQ27sH0arhkRX0n/xJ7iGaMkVI7oiO9bPMyQ3Gppj9AhML3OBXH2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB2640.namprd11.prod.outlook.com (2603:10b6:805:56::11)
 by DM6PR11MB3497.namprd11.prod.outlook.com (2603:10b6:5:6e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.17; Tue, 19 Jul
 2022 06:00:49 +0000
Received: from SN6PR11MB2640.namprd11.prod.outlook.com
 ([fe80::e0cf:f32b:a48c:51cb]) by SN6PR11MB2640.namprd11.prod.outlook.com
 ([fe80::e0cf:f32b:a48c:51cb%5]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 06:00:48 +0000
Message-ID: <810ab3e8-6755-da02-b6ed-ac480708067f@intel.com>
Date: Tue, 19 Jul 2022 14:01:08 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] BTT: Use dram freelist and remove bflog to otpimize perf
Content-Language: en-US
To: Dan Williams <dan.j.williams@intel.com>, <nvdimm@lists.linux.dev>
CC: <vishal.l.verma@intel.com>, <dave.jiang@intel.com>
References: <20220630134244.685331-1-dennis.wu@intel.com>
 <62cd01462c460_5c814294e@dwillia2-xfh.notmuch>
From: dennis.wu <dennis.wu@intel.com>
In-Reply-To: <62cd01462c460_5c814294e@dwillia2-xfh.notmuch>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0160.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::16) To SN6PR11MB2640.namprd11.prod.outlook.com
 (2603:10b6:805:56::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b1a59064-e3c4-4ee9-351e-08da694c072e
X-MS-TrafficTypeDiagnostic: DM6PR11MB3497:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vPQCaRL8rc5RLJ2bjq4WJ0LvNudSXRPZOrmaPxnbFZWw9PX8cnMVdYuC2bRYOmRcxPYw8XsoJ+npil3GkG9RFAYlBaADFcUJ9XN0l4WPdkeuljRKBTYVacYxVteqhKmkZTxHJuKYM1+UA4iIgUdp644FYw2elRG6ZvMXwk2pzDZPWZSeFsifFx24AfFlUw+xDNTk1YV+r/PQLFTVU01aBo9I/5zr40UyD0PS8zMGHJufXM4Yg+U3qddxW0O1IscIE9rW5m7XFC9rbxUDdVir+yXEsfC2uh5tGqgowHOVXxw5fRtEKjEOBdHC3h+jwwXDZ1Iq1/mnIBarO0efctT6me65/jUqi9l9KBBTVy9PvhLIXXOLPDOpRG9I8RPKfayCMf3oDN9kz7MuQCtoEZWqp0EGIJXlChXQvOesxu+NIHb0ABVeOInIUS84TH6Rjt0T1IM/nmW+wh9rpOTAW+fymmwuwDMtBChBJC9kTCnOff9E1bor141Cl7C2PE7dwRbYvjihdarBmE5kdY9gtAhsc7p96dmAgWsquuOnQ4Ddr9E0ilvCWo09pt86qKLAnG695mFzhOUrbR3RfIq0fmdLYJETa6tME77cA6YQzlXHSB6O88vLAjqz9mL67cgiF/s7DuZy+XMwlNLl20aJ9xRzOVhOfFcieSXijRS87lsB/4e0k82wmEg912I1tQlu2vhfWUwd1zVkorqzm485lob74L/bGG0UJQO4lh9oPBQXRpbtijMJAd/JoK2rlAgUfw5ov6MXejdGY607IP1mu9VkUziXRH2gxJ0j+r6V1oL/oZ+myohm0VtjYGF6pWsDevfrJgxNXzFCpjUIgQTZ8HMgLoKeQJvZng0wEUG64teDlN9su9LobHamTqp+xe4CSGSl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2640.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(346002)(376002)(396003)(136003)(39860400002)(36756003)(53546011)(31686004)(2906002)(5660300002)(8936002)(8676002)(316002)(4326008)(66476007)(66946007)(66556008)(6486002)(966005)(26005)(6506007)(6666004)(186003)(31696002)(83380400001)(41300700001)(2616005)(478600001)(6512007)(86362001)(107886003)(82960400001)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ejIzSTNtVmoydmVrWjUzRzczWkVNamhlN1pheVBtMVE1dDNoYmdTSktDMGkv?=
 =?utf-8?B?MTRYMWZKOGliR2NVU3JoR0dQcjRiM2tudGUxeHA3YVhOb0RtVHI5WVJ4S3k0?=
 =?utf-8?B?SmRTSGRzQW9VTEtCZFdVRTBaMHlxS0I3TWQ4VktYSFBOcXJybThaN0VIazlP?=
 =?utf-8?B?UVpna3RYQjZYYWtBbGY1L1RNdks3MkhoTHVGdFN2MXlpNGJZdE5mdVVoSCtD?=
 =?utf-8?B?QU01Sndudkg3UjFLdjR2cmlVQU5kak9HZUF6WUsxWlJVVkNOUUNOU0JDU2da?=
 =?utf-8?B?c01TdFF0RGJGREJhU3k5RnplbkxUelhTbnBVcnkrZytndWF0Y2trTHR6Q25Z?=
 =?utf-8?B?clpQcW9QQmwrajMxSHNNYWpySkJqZ0FZTlpsaERWTXFycWVGSmw3cjhKYkRo?=
 =?utf-8?B?enZVS0hQb2x1L3E1MERMTkVLYzZ1cjZ3V1pGWTh5dUt5Sm5lNGlCdllEMFM1?=
 =?utf-8?B?dmdSWFdhSzVrOE1odnRjZ1lwWW5NNjRlQVZGcWl4UVo2cG0rN3IraUM0VzYy?=
 =?utf-8?B?Q01IM0R5RVVXRDhJVE9Hd1dubWRlSU9OWTFUaHJFRVE0YXpyT2c4RVJVVmh6?=
 =?utf-8?B?UzllbkpZM2ZsRHNocWJrQ3RDdHZVVUMzaVZnWXZkMXRrdFdBU0VnejMxaVgx?=
 =?utf-8?B?Vm0xREo5NFdxckRsb3VEL1NJUHdHNkY5a2JCZWZKNEZxNEJZSVExcDNxSXhx?=
 =?utf-8?B?WVBKeEpjM1hpMmN5ZFRIeTRZdnV2VlYvVDFqQlFXQU1Qek5QY09IaWZhRW9Y?=
 =?utf-8?B?dlpmUUJOcXYvUGQzekducmJJWGhXQnBOa2FqNm92d25wQ0ZWcjliVHhISVVw?=
 =?utf-8?B?TGRNR3paeVY4amV2Uk5rNFhRTlcwVHBZbVZQMStYSm9pZ0NaeFFzOHNXVkFv?=
 =?utf-8?B?WTlObVRWQTVUOHkzcG9rZC9rNXcwSWlFSjJpMDNON1RVT0JSc0dwSGtpcjBZ?=
 =?utf-8?B?QkJoYnNMT3BuTXdKdkdpclNnRERad1hBbmxZM05URkNCeXByUmZJWFcyYWcw?=
 =?utf-8?B?RW1uV05wYVZwOXJjbk9GdVp6Y0pPUC9pNEM0K3ZRMUEwMytHVkJ5Ri9iZWdZ?=
 =?utf-8?B?NjQ3Nm9FVzlqWDJWTEl5RXdhczlnWGtYNC91amRRYWRoSmRlTGZPL2Zqdm8r?=
 =?utf-8?B?K09ERklISWUvMm5IOUh2N29NbUdndUEvVEc5U3lqc1ZxWFc5aUFVbklkK29y?=
 =?utf-8?B?WFNEczJ4OE16MmxGYUE2R2FtTmd2TzBIeStxZmorNW9TMVVPMGRrMkg2NTMx?=
 =?utf-8?B?Mkoyb0l2TUoyOHpqQUVITDBVQjBCS05uZmk5dXlVeGNXWDZxMGhmSGpSS3hi?=
 =?utf-8?B?ck1jNERtNmdvWThBWmhva1llSjlvcmlmYUlaMUgvM1RvOEo4Z05yUzVjZUxw?=
 =?utf-8?B?MzJjTSs1WGtqalNhWW44UC9mL1FqVWh2a0Y1SVM5Mkl1WkUrTTZsMFRnNmVx?=
 =?utf-8?B?emo1dklVS0tPbW9KY1ViZHlDUGpFSmR4L21YNnZYMnBSdDdWRXFOUUsvT3U2?=
 =?utf-8?B?eXgyUElvdUdFTHc0QkNGVHhqTWlONENZVFU5QURkRUxJOHdNZlFWRW1wUnNw?=
 =?utf-8?B?dHB4RjlkVXlKb3RyL0lLbHlIaG5PZ3NGNEZmRkEwUDBaNTNlUWxSdVF3b3V0?=
 =?utf-8?B?NjJGZHg2YmFMa01lby9FQkZibEVjWmp5WDFCQm1zMkdZbUJYdlNrWlp5MzZV?=
 =?utf-8?B?bTJINU9aR0NpeG5jOTRWZGEvMHJtbW5GVUM5WXpnYUpJa1JoU09ob3NIMHVv?=
 =?utf-8?B?aEl6TjZWMTB6dzlGWXp1Z3RaN1Z4TVQ4a05kSHVHUy9xbklSanFpSCtubEd0?=
 =?utf-8?B?WU1hMEcyYUxLRW5ISjFlN29wZVpDUTBkSEpMVXBnemlKU0lIalJzdktESGhw?=
 =?utf-8?B?SGwwTVFab3lzOVpvMjBBMlZRYWJDdmRGU3NHdHB2dXZOUTJTYkpZMlpFcG9C?=
 =?utf-8?B?eFlhWFZCMDFJczVCOUdiYWR5UkNET3lPSjFIVEVUeGVxd3AxRWJwMFgwT09t?=
 =?utf-8?B?MFZvWGw1OTFzVVVaY1hCdFlucEc1S3RldGcrMWR3STlacEJVMTdIKzBDZVl5?=
 =?utf-8?B?Nlp5cENJMEFSZGlMbXhtbkdtcTIxZFBXdzNZejV3YXk1NDd0WGRYaFZEUHpa?=
 =?utf-8?Q?wtlGKucYq/SDS0UlmBouQ6Htf?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b1a59064-e3c4-4ee9-351e-08da694c072e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2640.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 06:00:48.8527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2MDk1zZ2zqewhjMpSQhz4QPyVDQMCZLoiPK8IXvyjejYjACGcayXh6+GRZviyY1Qc9RAEw5GmqMKxrlz6PcEYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3497
X-OriginatorOrg: intel.com

Hi Dan,

Thank you!

Currently, we are working with one customer to evaluate the clickhouse 
and rocketmq with the optimization. From the preliminary performance 
data, we can see performance improvement. We will have some pathfinding 
work in Q3.

About the compatibility, we have the limitation to change from the new 
algorithm to the old one. I think it is good to have a new BTT layout 
version. I will check how to make it happen.

Thank you very much!

Dennis Wu

On 7/12/22 13:06, Dan Williams wrote:
> dennis.wu wrote:
>> Dependency:
>> [PATCH] nvdimm: Add NVDIMM_NO_DEEPFLUSH flag to control btt
>> data deepflush
>> https://lore.kernel.org/nvdimm/20220629135801.192821-1-dennis.wu@intel.com/T/#u
>>
>> Reason:
>> In BTT, each write will write sector data, update 4 bytes btt_map
>> entry and update 16 bytes bflog (two 8 bytes atomic write),the
>> meta data write overhead is big and we can optimize the algorithm
>> and not use the bflog. Then each write, we will update the sector
>> data and then 4 bytes btt_map entry.
>>
>> How:
>> 1. scan the btt_map to generate the aba mapping bitmap, if one
>> internal aba used, the bit will be set.
>> 2. generate the in-memory freelist according the aba bitmap, the
>> freelist is a array that records all the free ABAs like:
>> | 340 | 422 | 578 |...
>> that means ABA 340, 422, 578 are free. The last nfree(nlane)
>> records in the array will be used for each lane at the beginning.
>> 3. Get a free ABA of a lane, write data to the ABA. If the premap
>> btt_map entry is initialization state (e_flag=0, z_flag=0), get
>> an free ABA from the free ABA array for the lane. If the premap
>> btt_map entry is not in initialization state, the ABA in the
>> btt_map entry will be looked as the free ABA of the lane.Once
>> the free ABAs = nfree that means the arena is fully written and
>> we can free the whole freelist (not implimented yet).
>> 4. In the code, "version_major ==2" is the new algorithm and
>> the logic in else is the old algorithm.
>>
>> Result:
>> 1. The write performance can improve ~50% and the latency also
>> reduce to 60% of origial algorithm.
> How does this improvement affect a real-world workload vs a
> microbenchmark?
>
>> 2. During initialization, scan btt_map and generate the freelist
>> will take time and lead namespace enable longer. With 4K sector,
>> 1TB namespace, the enable time less than 4s. This will only happen
>> once during initalization.
>> 3. Take 4 bytes per sector memory to store the freelist. But once
>> the arena fully written, the freelist can be freed. As we know,in
>> the storage case, the disk always be fully written for usage, then
>> we don't have memory space overhead.
>>
>> Compatablity:
>> 1. The new algorithm keep the layout of bflog, only ignore its
>> logic, that means no update during new algorithm.
>> 2. If a namespace create with old algorithm and layout, you can
>> switch to the new algorithm seamless w/o any specific operation.
>> 3. Since the bflog will not be updated if you move to the new
>> algorithm. After you write data with the new algorithmyou, you
>> can't switch back from the new algorithm to old algorithm.
> Before digging deeper into the implementation, this needs a better
> compatibility story. It is not acceptable to break the on-media format
> like this.  Consider someone bisecting a kernel problem over this
> change, or someone reverting to an older kernel after encountering a
> regression. As far as I can see this would need to be a BTT3 layout and
> require explicit opt-in to move to the new format.
