Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB4F5200BC
	for <nvdimm@lists.linux.dev>; Tue, 30 May 2023 21:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685482699; x=1717018699;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ad2YUtGOLsWxfUQoAwlFyuT/Fg14cX4QN2jE3r/Aw2U=;
  b=h5AXdtWfl5BFGVID3f26e4/odTjz//PW3kcUpqYl5LVpTbx4TReGgaHB
   aLXgrlBIz1tOqZO7oonY+c7DwHf69f21wR1E8HL6p5S5bjZWOuK+E861l
   SAHKojWwVn6mCczINGPS1YcF8IBqHzZcvTGc2utQ8ZF4MlNF86fKt44Le
   wYm0lWqwslhf4R1wE5A2jt77QY+f/xM0qwj+3tPyL/n/ta0KoDnkwlbTQ
   YO6vUEGL12OEaqugbmNaKJCqFs6z5Y8NOlUfwu3qmoeQRioZ1IfY809Ag
   9vv2XfPNbQMJNnqvWmqPfRTcGXQWaIuhNaYErH7jaPD5urv3plz1paHBY
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="353897058"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="353897058"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 14:38:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="850954045"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="850954045"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 30 May 2023 14:38:18 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 30 May 2023 14:38:18 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 30 May 2023 14:38:18 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 30 May 2023 14:38:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jhGUR4+40PlTDNGp+iFVh56S1ZWqi1Zify2EAkobGnOS07yeYbwyRV/+2usJWAQL3NAJxWAJRn+ki5DozZE+X+hnnv6idfp6VsABBLEmvQLhZ2YciRFldrbjfxd3B+NIh3FbasckhI/a4rUJBtIKo+YBvczcWCNsi/GPwfXaQ0gGr4KGWMpsPNyxd3ki+7szrHW3Mn/PGtArm35aeDplzOtAlm4pjYrvxHaILmjDLFHRYqqkPEFl28/bxfMenANCenET4yeddgGP/ElDbJiW1cXhsWD/JttW+ye0QMirFhn0NEvv0WEE6OOq2rR+nBVj5Zu5pBw6Rek1S12EYf/Haw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JDLhtYqglbe6Iq81UJfoUHRY7heENfMOzJ8IqrcZ63w=;
 b=WOhk/r/o/qdYhIGQIAcAjrKX5yUEwO1GlUh5o+95Toql6lebImF7TybRTOuuASyksKV7Zw+eddpKSkn/9g4hZo1jsGw8ScvahyAMNMEHr3ViT9kZJG5k80hL8dPCNRrlm2+ouimv+w+SREeK20B0kVBMkk3g884D2df7THX85MD6t+tWpVWc9umTFLrYBdq3wB+9pForrBhAYdTtKsyh+XXIMx2szYbiyrsPZXPdeX7GgYwRXmb2P5Tn0F9eGdRXtli2+XuTllp5R8XqaMWMa7dca4kbNWrCbjAJ0YWrtb0chKd0V0fC4gH3Vpq8s0ufG0BBWUC1lnbtbUxf0q7+Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5984.namprd11.prod.outlook.com (2603:10b6:510:1e3::15)
 by SA1PR11MB5779.namprd11.prod.outlook.com (2603:10b6:806:232::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 21:38:16 +0000
Received: from PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::6b5e:ef4b:bd3:36d2]) by PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::6b5e:ef4b:bd3:36d2%4]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 21:38:16 +0000
Message-ID: <7cdf6d5f-72f4-2794-c305-fda6042d320f@intel.com>
Date: Tue, 30 May 2023 14:38:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Betterbird/102.11.0
Subject: Re: [ndctl PATCH 2/2] README.md: document CXL unit tests
To: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
CC: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
References: <20230523035704.826188-1-lizhijian@fujitsu.com>
 <20230523035704.826188-2-lizhijian@fujitsu.com>
 <43b38130-19fa-26b5-f7b3-8429c5230c66@intel.com>
 <d77dbd2e-452e-ab91-d045-e89fd7a7a9f9@fujitsu.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <d77dbd2e-452e-ab91-d045-e89fd7a7a9f9@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR07CA0013.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::26) To PH7PR11MB5984.namprd11.prod.outlook.com
 (2603:10b6:510:1e3::15)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5984:EE_|SA1PR11MB5779:EE_
X-MS-Office365-Filtering-Correlation-Id: e79d66ce-04bc-4dec-e1c9-08db61562d65
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mOj8bgRwraP84SEm1DLUbkYxWDhwp9BZFLM9sGgzmb2EkRSCyv7p7qCH/XfEnADFv56C+WJ+k72z4JnvTI/p6qxULqw3+VN92R22a2w8xW4gONCPZXlphNQW6UitypZXrlaFqa9yFo3cgGP3H/AHYUrZhg2NSosls5JOfkwIi3urOppmQei7SpF+hVZM1NhH4K5BQFkOgUK4vK7XnQI4xu7fek94bGUCvqqel7f+6j7KeVe4bw5d4NniO2MJk6XWF2Wtq14LfFfP+y+QmxFB+lpmJHuPJEH7j6/MlW9JhF2dWH/qrA3f1rRnUREkYqiN1RuSBDpASV2EbCftAJx5PRxUsUnoyG++8LyfIIfWiXCQihv1TW8acpdbiT86M7sGSZF1WAuVOfLBox6VKjIm05xo2tOckz2THPgU0jOROz0de6DLJa5G0oK44L+89UAQbVXnhoIg93bkztalheW7UhmDDGa4ryDLwCvMFrkLWZpQ8k8jgcNmvEk0fihD05Wk8+jyNZOC8iL7VAl4BkxYIW2WFLtSMoUexq0pfc2LX2m6tkG5g1Ut5PpiWF2KTiLI3dm4P7sq2DcyRpP/e0CpG1Ym43riRyLARkoavhyR3+V/5FEdYBPoD0zg90MWC+8ccYev1H6iMxKvLN5DHvk5Uw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5984.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(136003)(376002)(396003)(39860400002)(451199021)(478600001)(110136005)(5660300002)(44832011)(8676002)(8936002)(86362001)(36756003)(2906002)(31696002)(66556008)(66946007)(4326008)(66476007)(316002)(82960400001)(38100700002)(41300700001)(2616005)(83380400001)(53546011)(186003)(31686004)(6506007)(26005)(6512007)(966005)(6486002)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d3BmMHNCVnR1M1VrcmtKLzBYT2FqbkQ1Q1o1OVFFZDF6YUUwRm9sQldpNWN2?=
 =?utf-8?B?eGJYR1o1aTlqcEsyQ0xtQnRybnBnVEJzSzhYQWNOalNFVmtqUWNBOTVMNFMr?=
 =?utf-8?B?VDZDU21JTngrK0h0WWlCT3lRMWw3S0xmU2ZiYWJDR1FWUXdSRHA2WFl0elZs?=
 =?utf-8?B?Z1FNMmdib0phQjRoVW5EbjY5QWRwSXd0bmtvQVcwYm5rdFdJbmFaRUFIMHlq?=
 =?utf-8?B?MlM4bkgxT0EyUU5YblpsY01BeHZNSXhSTHJUcTBtOWhBZ2VRMVlEM2hvbU5E?=
 =?utf-8?B?SW4vMHRwK0hxTmc1ZVB3bVJlTmZwYWkxRXFZS0g5anY4OG1sNERONjhqNGJI?=
 =?utf-8?B?UjIyMEtMVWkvdVdNN3F4ZTVzcElCUFVLV1d1ZjI4TWtPd2xPYnI2Q2FRaTIv?=
 =?utf-8?B?ekFhUUJpQjRMVXArUldtdWxHTmtUbzhORDA1b1J0RjdQbXpiNTJzOHB5MWNw?=
 =?utf-8?B?NFNvSlV2MFF1SGVPTWlvbm41WmN5N292MFVENFVieUY5RjZJc3J2ekg4Zk5x?=
 =?utf-8?B?N3I5OVN5cDh5NVJZRzM2ZC9sbXVMc0pzQjFFeXprMzhUN1FBYUIwMGhQWHFl?=
 =?utf-8?B?ZldpdFFPNWRnbXh5Slp1MnlERncydkVpUEl4Y2ZiZ2hwRzcxeWw1cHZKYjd2?=
 =?utf-8?B?RjJKZzFDcEJEblFaazg1Y0o0UzhVblpUbm5IMGlNZXlhcTV4OEFvV295amdI?=
 =?utf-8?B?ZEduMUdTck1MZXlkVjU1WFZwQVZwODViSGNFVnc3bmN3M2k0REdoOGRTM0o1?=
 =?utf-8?B?M0QwQ1VDeTdTTVBwT3NRdXg0MmpacWx0UnZZdlVoYkJPcTFtejlYUFpYKzEy?=
 =?utf-8?B?Q0UwaSt6MGt3OWNyaVFJV3FsbXJ0TnFBQ0dMazhERGhvZGNrVWl2cW5tZnFT?=
 =?utf-8?B?cmxMM1FJYnBlOXdXUmVURmNaa0FKTmMwY25ZRllqeElQSVJXYmk5TTZKakNX?=
 =?utf-8?B?ZjJkbmwrT3F4T2Q4bm90MDRkdEhJZ2tvc1pEZUVNNEJHNWdFMkticUU0R2J4?=
 =?utf-8?B?dS9nME1tV0IzK0U1ZUwrQU1oWEdUeDlKOVhwaWg5ZGM2cjV1Z0ZzaEpPQVJx?=
 =?utf-8?B?YjNjN1VVU0sxUXZqNmRlUEVEY2NpbGtRUzdLU200azlmK25EMFovQStUOGNs?=
 =?utf-8?B?SjF0M3VkekN2MnhzdUJDUHJzL1VvL2N2bjZvY05BMGllU1RkRm8wSHBhNklM?=
 =?utf-8?B?aUxPWXRJbkdyZGVRckQwL0kwbkdkZFpGYUhQVkhoWDUwVzF1Y29YYzZnb3Fz?=
 =?utf-8?B?THNneUlpU2poSzZiQnkrSTlaMkdJZVVMdTdXTzdLbDhWSHo2SFJPQUlPeW1o?=
 =?utf-8?B?OVVUenY2bUgxWmc2d2NmbHRhelJicDYxK2lzY2ZXTitMdGI2YnIydVEwTDNJ?=
 =?utf-8?B?V1RmSHV6RXFhbW1QU0oxakhpbWg3Tjg3YUtrTU4wR2g4T0VSYkUvb1RTNHZP?=
 =?utf-8?B?Z2N5T3V1VDhSQVo2cWU4Z3VaUFAxY2kzL25WVzkwZWpGVTVpVUtPZnVDeGpl?=
 =?utf-8?B?SDVxcmRMRGh0bVUwMEtTWk82V3hPTDFWUzNFYnJyNlFQNUxPOEFQUGNGcmdq?=
 =?utf-8?B?ZEY2bEFXV2M4b2RTYjUvMzlTaTRrSXdpaUlYRVU4V1ArRGZjdkpoVVErM3lT?=
 =?utf-8?B?ciszOE05Vk5XVlBMcHEyYVdVMFhORUJGV1ZrcWZCcW4ydTA4YlcwSXE0RG9j?=
 =?utf-8?B?MmN3WldhK3BEVnVqTHBQMzJ6NDV6ODVvZ2NXNjVZb1BsN1RVU2w1OTZ5M1Vk?=
 =?utf-8?B?TGJ2SnBoaHBkdHVKbmpIVXdDRW92bzYyKzZ0dGdELzY0L005SURyZCtUQnBk?=
 =?utf-8?B?bUlFL1ZOa291eEFFSXVXaGJEdkZ5bm8vWkloWm0wQm4wMGZ4MlVSaWp2NUhl?=
 =?utf-8?B?eXVBdURGbWV0T2FCcUt6dTZiQzY4eVFGVTVsQndMRDJmeWpoazRCR2E4N25O?=
 =?utf-8?B?NDEvTVQ4dUswbVFHZzJ1UkljbzlldmE5Rmswbno5bUJNOWJ4SGRweklmM0dJ?=
 =?utf-8?B?ZFQ1M004TDN3WGhwVlFJd3pKMTk0YmxSM3BEZHhpQ05UbFRzN2VvYU91MDYx?=
 =?utf-8?B?ZTlKaDc2Q085bGxrTlVsaU91KzRQdXR4NXBCTVFoYnIzTDU5WmtZd2ROV1Jk?=
 =?utf-8?Q?U0bOQpXu8F66uY2kGnPiVyBHf?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e79d66ce-04bc-4dec-e1c9-08db61562d65
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5984.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 21:38:16.1639
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ttioLepojbz0aVeReg4n7P0MuBoKmWfh4pLzR/iDuPF9gNyM2+ZcCEvdLWmIxz4EPe1BeV9TzzjT8riV5+jA4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5779
X-OriginatorOrg: intel.com


On 5/25/23 21:01, Zhijian Li (Fujitsu) wrote:
>
> On 25/05/2023 23:28, Dave Jiang wrote:
>> On 5/22/23 20:57, Li Zhijian wrote:
>>> It requires some CLX specific kconfigs and testing purpose module
>>>
>>> Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
>>> ---
>>>    README.md | 17 +++++++++++++++--
>>>    1 file changed, 15 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/README.md b/README.md
>>> index 7c7cf0dd065d..521e2582fb05 100644
>>> --- a/README.md
>>> +++ b/README.md
>>> @@ -39,8 +39,8 @@ https://nvdimm.wiki.kernel.org/start
>>>    Unit Tests
>>>    ==========
>>> -The unit tests run by `meson test` require the nfit_test.ko module to be
>>> -loaded.  To build and install nfit_test.ko:
>>> +The unit tests run by `meson test` require the nfit_test.ko and cxl_test.ko modules to be
>>> +loaded.  To build and install nfit_test.ko and cxl_test.ko:
>>>    1. Obtain the kernel source.  For example,
>>>       `git clone -b libnvdimm-for-next git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git`
>>> @@ -70,6 +70,13 @@ loaded.  To build and install nfit_test.ko:
>>>       CONFIG_NVDIMM_DAX=y
>>>       CONFIG_DEV_DAX_PMEM=m
>>>       CONFIG_ENCRYPTED_KEYS=y
>>> +   CONFIG_CXL_BUS=m
>>> +   CONFIG_CXL_PCI=m
>>> +   CONFIG_CXL_ACPI=m
>>> +   CONFIG_CXL_PMEM=m
>>> +   CONFIG_CXL_MEM=m
>>> +   CONFIG_CXL_PORT=m
>>> +   CONFIG_DEV_DAX_CXL=m
>> Probably should have a separate entry for CXL configs for testing. There's a cxl.git at kernel.org as well.
>>
>> Also will need:
>>
>> CONFIG_NVDIMM_SECURITY_TEST=y
>>
> I also noticed that Yi have sent a patch to add this and some other kconfigs
> https://lore.kernel.org/nvdimm/20230516121730.2561605-1-yi.zhang@redhat.com/T/#u
>
>> CONFIG_CXL_REGION_INVALIDATION_TEST=y
> Yes, i indeed missed it.
>
> I insert a section before *run the test* as below. A markdown preview of README.md
> Please take another look.
>
> diff --git a/README.md b/README.md
> index 7c7cf0dd065d..324d179ac4ea 100644
> --- a/README.md
> +++ b/README.md
> @@ -82,6 +82,32 @@ loaded.  To build and install nfit_test.ko:
>       sudo make modules_install
>       ```
>    
> +1. CXL test
> +
> +   The unit tests will also run CXL test by default. In order to make the
> +   CXL test work properly, we need to install the cxl_test.ko as well.
> +
> +   Obtain the CXL kernel source(optional).  For example,
> +   `git clone -b pending git://git.kernel.org/pub/scm/linux/kernel/git/cxl/cxl.git`
> +
> +   Enable CXL specific kernel configurations
> +   ```
> +   CONFIG_CXL_BUS=m
> +   CONFIG_CXL_PCI=m
> +   CONFIG_CXL_ACPI=m
> +   CONFIG_CXL_PMEM=m
> +   CONFIG_CXL_MEM=m
> +   CONFIG_CXL_PORT=m
> +   CONFIG_CXL_REGION=y
> +   CONFIG_CXL_REGION_INVALIDATION_TEST=y
> +   CONFIG_DEV_DAX_CXL=m
> +   ```
> +   Install cxl_test.ko
> +   ```For cxl_test.ko
> +   make M=tools/testing/cxl
> +   sudo make M=tools/testing/cxl modules_install
> +   sudo make modules_install
> +   ```
>    1. Now run `meson test -C build` in the ndctl source directory, or `ndctl test`,
>       if ndctl was built with `-Dtest=enabled` as a configuration option to meson.


LGTM


>
>
>>
>>
>>>       ```
>>>    1. Build and install the unit test enabled libnvdimm modules in the
>>> @@ -77,8 +84,14 @@ loaded.  To build and install nfit_test.ko:
>>>       the `depmod` that runs during the final `modules_install`
>>>       ```
>>> +   # For nfit_test.ko
>>>       make M=tools/testing/nvdimm
>>>       sudo make M=tools/testing/nvdimm modules_install
>>> +
>>> +   # For cxl_test.ko
>>> +   make M=tools/testing/cxl
>>> +   sudo make M=tools/testing/cxl modules_install
>>> +
>>>       sudo make modules_install
>>>       ```
