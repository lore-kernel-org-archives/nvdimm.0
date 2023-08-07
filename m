Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411C6FC01
	for <nvdimm@lists.linux.dev>; Mon,  7 Aug 2023 16:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691426567; x=1722962567;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fQcvg3qqj9XfVCnaCd4FfCInYOzJ/GS/azehjm2PAgg=;
  b=PqAgnzDAZI30tMJ29BmeYVEN3OG/Cac6JD2clYYn+7MyZX6XqyJm+yQV
   VhBEea4C1u2BLTUX2V/aBbkYeN/g9K3seDF+vf4vsG4CNkYQD0NL2o+A5
   lnuhu0KXttdP45T9sXh+rccRrp9koNbCbXQiDf8iA1RmtDaj8waund+Et
   KfMjVDuw0G650SbcL04hWnCja4EJkXOd3Y6ttjb9zj+reS1e5S5pXgSly
   70bJyXL5ZDs+Z7L0wDQhk82/OZ7AyMt4NBHWjkTPpaLi5dFIgbk2REAhU
   RXlfZ9UqpObZI21zABH56Ea+m/FewFZX2sXg1VccmPJJTBEYB4oSnt5Gv
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="436924521"
X-IronPort-AV: E=Sophos;i="6.01,262,1684825200"; 
   d="scan'208";a="436924521"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2023 09:42:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="800998937"
X-IronPort-AV: E=Sophos;i="6.01,262,1684825200"; 
   d="scan'208";a="800998937"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 07 Aug 2023 09:42:45 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 7 Aug 2023 09:42:45 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 7 Aug 2023 09:42:45 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 7 Aug 2023 09:42:45 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 7 Aug 2023 09:42:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=keMIDlZnzVGBQjCMhAK/rNlCz4F8MobysaXbY+2go6P9rxOVCBqpReO0dsOU/DZGnDBu8Sz1n3GKvgl52h8BerFbTP8OYWV343T6ptdFVXFQF4dG/f214K2mN6Ya+Z05vjLT9JiT61ixxWDa0zMDi6WkYnTTiKcMTifm/I0gTOj3odEOqi1+36ch4U+laGu2Db0CURRyd3CKdqeeLtSgyDZorekk213+Dx3228XgUDDksdckOE2Rg7mgHYOtiuPv0JIIwTEYlUdOyVTy8HaBDtmNpLBszB5Bk9H7LEeKWe6et/69jQLvAUcQIg/7zKJAehVxN77o9FNcLysHJiCvzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f3hiLYykvjSosURixHRKK2hEbrgFum6RDTUUZfVhBc0=;
 b=X6uBkiI1P4IzBcmwHRxop52vk7uLoQWW2vsF916bpQpzNYY2//xGNLr2KcYnYSh+Vo9zjsiDJZjmFi+8iSrAvOKP9Erfnu1yx/sV89YGr29lfavcHBdOVhKuit+yZiREq1bOU+Td4+3g5/HM/9Vc2hPZtCRYg60cIAMfibbepK6EzWQmTiSz+I4KJvfKJfnKS+LV5W5ykV4Awvax7Q0r3jemuwSSo2BK0uUybjMEwKHTjfU3a7YQo3NGYEArTjWsQhSkSQ3bog/qQvvshknGhKaGZ4dYqq4LWhNeTqnBw5e1SFWeTTfEns8psp4ifrrrvvOgfrHmlUJ07sL0zE4h6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5984.namprd11.prod.outlook.com (2603:10b6:510:1e3::15)
 by MW4PR11MB6572.namprd11.prod.outlook.com (2603:10b6:303:1ee::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.26; Mon, 7 Aug
 2023 16:42:43 +0000
Received: from PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::406a:8bd7:8d67:7efb]) by PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::406a:8bd7:8d67:7efb%6]) with mapi id 15.20.6652.026; Mon, 7 Aug 2023
 16:42:42 +0000
Message-ID: <bcd1a935-b6ce-3941-5315-197f6876379e@intel.com>
Date: Mon, 7 Aug 2023 09:42:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Betterbird/102.13.0
Subject: Re: [PATCH v4] virtio_pmem: add the missing REQ_OP_WRITE for flush
 bio
To: "Verma, Vishal L" <vishal.l.verma@intel.com>,
	"pankaj.gupta.linux@gmail.com" <pankaj.gupta.linux@gmail.com>,
	"houtao@huaweicloud.com" <houtao@huaweicloud.com>
CC: "houtao1@huawei.com" <houtao1@huawei.com>,
	"virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>, "hch@infradead.org"
	<hch@infradead.org>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"axboe@kernel.dk" <axboe@kernel.dk>, "mst@redhat.com" <mst@redhat.com>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"pankaj.gupta@amd.com" <pankaj.gupta@amd.com>, "kch@nvidia.com"
	<kch@nvidia.com>, <mst@redhat.com>
References: <CAM9Jb+g5rrvmw8xCcwe3REK4x=RymrcqQ8cZavwWoWu7BH+8wA@mail.gmail.com>
 <20230713135413.2946622-1-houtao@huaweicloud.com>
 <CAM9Jb+jjg_By+A2F+HVBsHCMsVz1AEVWbBPtLTRTfOmtFao5hA@mail.gmail.com>
 <47f9753353d07e3beb60b6254632d740682376f9.camel@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <47f9753353d07e3beb60b6254632d740682376f9.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR04CA0021.namprd04.prod.outlook.com
 (2603:10b6:a03:40::34) To PH7PR11MB5984.namprd11.prod.outlook.com
 (2603:10b6:510:1e3::15)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5984:EE_|MW4PR11MB6572:EE_
X-MS-Office365-Filtering-Correlation-Id: d28a9e5e-96e0-4e2c-1a4c-08db976551ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1vErSzv1xBBdfMQ1Jn3HA/qiGdg1koKGhJ3ZCxsJdnjIDYnm/acQOE2NqfnGPhmXO/nVNE71/GL6/QXg+YkVHZunQj+JglUO8svAZYWJPil8P8BMwJEDy6g7pWQIEsNi8zHBi+qsdZ8o4oeycHCFMF5lSsuA5vOQzexG0TnLDpu3aaQUhxIYGILtUnaWJHnclDYIJu/AHRkI2HbEU0uYahOHD9gIWoOaTdlajZkk0nGIABOMg+8mJBl5xN1nim+QaqdEQk7WxgQ53nIEvU86bcmw7JDs4AGNhexP8BV7nlS/P8XErmuK90/yLx70jb0I8H/1S3DfCdnOLcvq6XIMpTz9HdKR6H0WNyQ6z8JsPClXkcDd14/RTBzmn5TWM+lY6gVtr6aWdF7uY4kduL8TU4hwQgS4j0RXxHFnTT5NbpMMUZJhj2zwms/az4+b/5TewlsDmTno4xvh6A3Kb/4rZvamGulhnsPbcrGgCEoWsdMroRgWGPiWnNiTU+HkcWjCGFcVwKFAGNp/+7S87zLw/CPTwSNHSa33GtKKzZ1wXxNyKSa+ZyqMz29Pc9lCKu8DGa6Gk1zgB6GpBa7LUamp3ALGu67sBmYkDlyDu8HzRKttmnvAILT9AZFYYB1Ngt0X/lk0uSgLWq9n7W+T1o8Of2zcbD0UtR8T6dR8k/SFsX6F72xVwJgehV2shNMMuYEH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5984.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(346002)(366004)(376002)(136003)(451199021)(1800799003)(186006)(2616005)(6486002)(6666004)(478600001)(31696002)(86362001)(966005)(6512007)(82960400001)(45080400002)(26005)(36756003)(6506007)(53546011)(41300700001)(8936002)(5660300002)(316002)(8676002)(7416002)(44832011)(54906003)(110136005)(2906002)(4326008)(66946007)(66556008)(66476007)(38100700002)(83380400001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MkVPR0d2TVZYU2xKTWc4OGM2a0lvbXd6Ujd2bUJtYmVrZWt3NzQrSm1kZ3d1?=
 =?utf-8?B?bFlrSmNZbVNKcjRCTmZKeFg1TTZGLzZZQ0ZYbTkxVG5DamNtZ0RkNWsxVmNt?=
 =?utf-8?B?SGZ4a3VwOXNTeVptemlTcTIzdU0xbmFGb0V4U3kwcWp4c1NFZHk5d1d2d01M?=
 =?utf-8?B?S2lQVVAxVzJDaWxSQWh2eTFXZHZiN0FuVUxTeHh5SndvUzh3UjBRU0RKWTM5?=
 =?utf-8?B?VjhaTmtWMjAvY2pRa3p3V29reVhmVUpNNkNQVkJZL3FmSmlCYmYzVnBzSm52?=
 =?utf-8?B?WGJZYjFvbU5kR05wSWJNem96c0E3ZHRlOE9aby9oVm5lcjhiRUx0YmtQNUpi?=
 =?utf-8?B?Rk5ZUXFTR2FvNytjYTFYV3BTZmtwVkJHRkRReGo2Sm5qQjZHcTlTbUJxNTNz?=
 =?utf-8?B?SWFRdWlDdnMzdVhjTklKSzRSRERhV2dpSWc2eHBUcllGN096YXJWZ2tENk15?=
 =?utf-8?B?T2p4WGh2NFMwTGpONUJXeG9OSVZwUllmMWVteVlicFl1S05KMC9lcyt6Nk9M?=
 =?utf-8?B?dzd5bTFENGxldUgzcU5MQXhHTloyUnBpemJJMHF6cUxOajBhdUxZcnMwYkNR?=
 =?utf-8?B?aDV0dTdGUW45ZEdvM1ZEMTFVQ01CVm5GWkxvMFBhTzFvK01DbGZrSVNaNFlh?=
 =?utf-8?B?Vi9td1ZBcUllZm5FMkJZdXRqMUZUQmdiakg1T3RKMnFSc0grMkJhS2xqeStR?=
 =?utf-8?B?SnZqY3VSYTBXTGZnOGFQSFdPNUhQNDJ0VVpTd05NZHpGK0M5bTlpZzFSRUNJ?=
 =?utf-8?B?UUlJS3ZpTkE1dzN4UCs4NE9UWlBtZ3J4d2FLNGZCV21UL0lPa2VKTjdTam1j?=
 =?utf-8?B?OHRpMWtyNWNSZ2MrVWVkVWY4UktaWldsbERaeTVnTVcrR0N4MUFsMGgwT1Ni?=
 =?utf-8?B?YzVaZDlXQ3FmVWxLRU8rQ2VTdVdsSWw4VjdvNi9KTFNrK0xCK09nMkU4NS9O?=
 =?utf-8?B?ZVpnNit6T002cEYwa0pZbFBVRmRvM2VyTVBmb2FpYSs5UEM3UzNoZnJBWWc1?=
 =?utf-8?B?Z0EyRE1iM2dpMGE5Q0xBdFdKNkUyOE5BcllvNGM5dW01bks3MVZpbHdhdi9v?=
 =?utf-8?B?WlVIb0Njcy91UUNLeGpjYVlLWWdqdmFTZzVGbUZ0VmVKWE9ldDlKSTh0c2I5?=
 =?utf-8?B?a2E3RVZYeWkyZlV2QmgrTlcrZ29jRHYzRkpOZU5mbHYyZEFRQ1d4YlkvUW41?=
 =?utf-8?B?N2VrTDBjTzdDTndyL3lRdDRmY2dEY3JNUjluOC9EUXpEeWorQUtscGJCT01r?=
 =?utf-8?B?Q2I3cjlXeHNDQ250aUxkd1l1LzlpQkhJQVZGUHVTa3luQm5YT1F3cFd2MVda?=
 =?utf-8?B?OGR6L0NBeENKK2JINThuaVJqczdTNUN1UGJEVXhFMmZIMHBnRFZBVCtvSlVn?=
 =?utf-8?B?WFlHMHpWSkNwSHozalh2WWRhTEZtRWZSYlgySUYzZnEzenhIZUp1YlMvTlRF?=
 =?utf-8?B?UU8vT0lNT0duOTVqM095eGxkc3NjYitUOTUxelBUQTdROXpPQkNzSHVFSWdN?=
 =?utf-8?B?bHB5aDRxQkNrQmpsSTFsZGZYMi9mQVkxN2krKzI3b1lJNm1Tc3JDbHZVVE1m?=
 =?utf-8?B?TitiNU5iTXVWZ1BDdC9Ud3BGVW9qdzRDU0pBcmVzZysyUkNKRVZJSlRucS9h?=
 =?utf-8?B?ZVA5Q0tHdnFTTHhHMG1VRUcvRnptV2NhNVZrMTlJTEQvMWs2cS85ekxKYmdO?=
 =?utf-8?B?cXlET1FYVHBvN1BNNk1PUG9iMkVoSGQ5cjN6TnE0UHB2V3NQM1cvM2NWUDRh?=
 =?utf-8?B?ZEZLRmJDc2VKWmhSZW5NQ1d4aXhKZW04bVRCR0QwcDlqdmw0V2o2VHkrVjdk?=
 =?utf-8?B?b0VOUjZmUGx1YlRLSStZM3lEZjNhcGZvMHZxTzNhRkxXMTI5UkdLYklXcldO?=
 =?utf-8?B?SExXbVdzQ0xkaGVPSVFJbkZibjRrZGUvb3RMSDhyL2xlUkMyYXdUK0pma1Uz?=
 =?utf-8?B?WUtZY2E1VUdlcnNiMmo4SzFYMHBRazdOaFpLRHFCU1VuNkQ1bXNxd0M4ZFlr?=
 =?utf-8?B?a1ZRZ3VjNlQwY1NGeFhFRmVodDltR0hGVW5OVWFWR3NMTDZUZHhLK0RSZUY3?=
 =?utf-8?B?bE1ncGdUMHc5OTh3cFRMcTdiMy93N3F5dXhUUksxYXZWTkJmYXdkQVdiN1Bx?=
 =?utf-8?Q?b8kotq4JbNEo8un/WuMf1aCbn?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d28a9e5e-96e0-4e2c-1a4c-08db976551ee
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5984.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2023 16:42:42.6212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U+/OdMobqKADZsq7zOfeGS/t+7CTULk/1DCL/ZfjnDMCu7SE8QDt2wQ7SbS4LvM/XHFK+1sRBbJVNO2m2o1pBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6572
X-OriginatorOrg: intel.com



On 8/4/23 14:03, Verma, Vishal L wrote:
> On Fri, 2023-08-04 at 20:39 +0200, Pankaj Gupta wrote:
>> Gentle ping!
>>
>> Dan, Vishal for suggestion/review on this patch and request for merging.
>> +Cc Michael for awareness, as virtio-pmem device is currently broken.
> 
> Looks good to me,
> 
> Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
> 
> Dave, will you queue this for 6.6.

Looks like it's already queued:
https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git/commit/?h=libnvdimm-for-next&id=c1dbd8a849183b9c12d257ad3043ecec50db50b3


> 
>>
>> Thanks,
>> Pankaj
>>
>>> From: Hou Tao <houtao1@huawei.com>
>>>
>>> When doing mkfs.xfs on a pmem device, the following warning was
>>> reported:
>>>
>>>   ------------[ cut here ]------------
>>>   WARNING: CPU: 2 PID: 384 at block/blk-core.c:751 submit_bio_noacct
>>>   Modules linked in:
>>>   CPU: 2 PID: 384 Comm: mkfs.xfs Not tainted 6.4.0-rc7+ #154
>>>   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)
>>>   RIP: 0010:submit_bio_noacct+0x340/0x520
>>>   ......
>>>   Call Trace:
>>>    <TASK>
>>>    ? submit_bio_noacct+0xd5/0x520
>>>    submit_bio+0x37/0x60
>>>    async_pmem_flush+0x79/0xa0
>>>    nvdimm_flush+0x17/0x40
>>>    pmem_submit_bio+0x370/0x390
>>>    __submit_bio+0xbc/0x190
>>>    submit_bio_noacct_nocheck+0x14d/0x370
>>>    submit_bio_noacct+0x1ef/0x520
>>>    submit_bio+0x55/0x60
>>>    submit_bio_wait+0x5a/0xc0
>>>    blkdev_issue_flush+0x44/0x60
>>>
>>> The root cause is that submit_bio_noacct() needs bio_op() is either
>>> WRITE or ZONE_APPEND for flush bio and async_pmem_flush() doesn't assign
>>> REQ_OP_WRITE when allocating flush bio, so submit_bio_noacct just fail
>>> the flush bio.
>>>
>>> Simply fix it by adding the missing REQ_OP_WRITE for flush bio. And we
>>> could fix the flush order issue and do flush optimization later.
>>>
>>> Cc: stable@vger.kernel.org # 6.3+
>>> Fixes: b4a6bb3a67aa ("block: add a sanity check for non-write flush/fua bios")
>>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>>> Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
>>> Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
>>> Tested-by: Pankaj Gupta <pankaj.gupta@amd.com>
>>> Signed-off-by: Hou Tao <houtao1@huawei.com>
>>> ---
>>> v4:
>>>   * add stable Cc
>>>   * collect Rvb and Tested-by tags
>>>
>>> v3: https://lore.kernel.org/linux-block/20230625022633.2753877-1-houtao@huaweicloud.com
>>>   * adjust the overly long lines in both commit message and code
>>>
>>> v2: https://lore.kernel.org/linux-block/20230621134340.878461-1-houtao@huaweicloud.com
>>>   * do a minimal fix first (Suggested by Christoph)
>>>
>>> v1: https://lore.kernel.org/linux-block/ZJLpYMC8FgtZ0k2k@infradead.org/T/#t
>>>
>>>   drivers/nvdimm/nd_virtio.c | 3 ++-
>>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
>>> index c6a648fd8744..1f8c667c6f1e 100644
>>> --- a/drivers/nvdimm/nd_virtio.c
>>> +++ b/drivers/nvdimm/nd_virtio.c
>>> @@ -105,7 +105,8 @@ int async_pmem_flush(struct nd_region *nd_region, struct bio *bio)
>>>           * parent bio. Otherwise directly call nd_region flush.
>>>           */
>>>          if (bio && bio->bi_iter.bi_sector != -1) {
>>> -               struct bio *child = bio_alloc(bio->bi_bdev, 0, REQ_PREFLUSH,
>>> +               struct bio *child = bio_alloc(bio->bi_bdev, 0,
>>> +                                             REQ_OP_WRITE | REQ_PREFLUSH,
>>>                                                GFP_ATOMIC);
>>>
>>>                  if (!child)
>>> --
>>> 2.29.2
>>>
> 
