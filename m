Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86D03D7C
	for <nvdimm@lists.linux.dev>; Thu, 25 May 2023 15:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685028512; x=1716564512;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+XdZDVZGCmeX6RqcR4aynKiA97krXjfdJsV14z/wnEw=;
  b=N0bb6rIhOWlW1kgWmfFq+7LupkveSxKNXlVrqUatTfPzdF4QmqspvNhZ
   wW28SfpXHO68IbmWGptJFFU87Jit+0BWKkICuOsnRxRX54uwLIX7/4daW
   rfSWRurFciUjg0n8LHVGUUUTw27d7C8VmeflqGOCiWHirdthB3BeIXKdD
   IhT/qy/JAZS7G15a5eZEgQTWMnwrnbNLxs2sgtFQD+tPJMcM0hXA+qGsl
   IM2qEBH4fbuS8Tkd8ArwQfaVVhvKvQkU7ln9kXsm3HkeCPghFRayIK3TV
   SaTtqk32j5z0RhI56xkahl07exVGPnX+CZL8iiAHek9THDMwLpD88I7t8
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="351430471"
X-IronPort-AV: E=Sophos;i="6.00,191,1681196400"; 
   d="scan'208";a="351430471"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2023 08:28:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="951479456"
X-IronPort-AV: E=Sophos;i="6.00,191,1681196400"; 
   d="scan'208";a="951479456"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 25 May 2023 08:28:30 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 25 May 2023 08:28:30 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 25 May 2023 08:28:29 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 25 May 2023 08:28:29 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 25 May 2023 08:28:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iliTgJplXFv3B1lkUaqAQu1XtyTgdjyaF/zNungQJcH58dpW5TZS4TU4ov7IP5uHav5o+pqdISkIq5kMzrBBcWh0IJOZtBw22ejNAEWKdKucDDPDfTO9yOrUMuFMFhHxay7W+Gfbjlgv56RMIH5a/gMinZK81DRkZJFumKmYQHj5mNykYaBrfm/zxy++fQu4JHQpx6C6bg79xVen4dA7zGyQlvMrkZvLg8ziaPsx1BwBFe/P2GzbVVoZMMiFff10Mf3qNMQBf1GFkUHrdAbYWYX9zZgmqM/NfbcQekXQhgdMUmfofWBFebfRoa2iuPhelF8MCRZXKVVDa61U7at1Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q7pndQvEnejs3Bd/xOb5gbjNuCV/q8n0lksNao0lO48=;
 b=gD8u/6a3CjYImu+Nz25fQOrZQG8FVDj0HzF/NhHezyrmXBLzcDbliGYVAquWpm1rQZ7p79hqSm57MOrmxlrM1hwsqWeg2yEh2hCajpoOfNXYFaw3CAueRkjjqXO8gziqhQMr15l6nHdHgvqzL0lSiBruJa+FEXsT8viQ62tIxtNEIDXMcA5zGXOVhyxD8Rv8S3Ps+XC0ERkRqFJmcOag8rSkbcTpBMoVK0cvcVxsuwemsuPFoeJMNo/LkqINAXJStt+fILs7d7+jetsLi6hlPNMZ3nHj0nZkFQvOzKn1GA1flMV9eQmv0KjvSzjeCZHwJyNzogvJyRe/rVQuwhR3Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5984.namprd11.prod.outlook.com (2603:10b6:510:1e3::15)
 by SJ0PR11MB5118.namprd11.prod.outlook.com (2603:10b6:a03:2dd::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.17; Thu, 25 May
 2023 15:28:28 +0000
Received: from PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::b315:faf6:e706:ca61]) by PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::b315:faf6:e706:ca61%5]) with mapi id 15.20.6411.028; Thu, 25 May 2023
 15:28:27 +0000
Message-ID: <43b38130-19fa-26b5-f7b3-8429c5230c66@intel.com>
Date: Thu, 25 May 2023 08:28:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Betterbird/102.11.0
Subject: Re: [ndctl PATCH 2/2] README.md: document CXL unit tests
To: Li Zhijian <lizhijian@fujitsu.com>, <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>
References: <20230523035704.826188-1-lizhijian@fujitsu.com>
 <20230523035704.826188-2-lizhijian@fujitsu.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20230523035704.826188-2-lizhijian@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0368.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::13) To PH7PR11MB5984.namprd11.prod.outlook.com
 (2603:10b6:510:1e3::15)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5984:EE_|SJ0PR11MB5118:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f951fd4-e445-4d04-187a-08db5d34aff5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J3bLd83en48ol80yIH9sxLH8shufFvXh0Ewvi/MylSftXP41QikRahDDQDI8OyIUo7VDPgA7vbHobX8q4PHKO5jeqYgFnYXGz9NfmeCAKrHf8LCLEwMIVobSJQd+zZsJm4jgIWrb2Wdo8CQ8ai+IkOWCJCmBcwDuP54wfxGXj84AyipHPifIzTjCfHlDCQX8SbkExhlB/ka9J4o01YkeK6hKRCLK8eT1Uy1TCibPC4O31SFYdf/78sdAQWnxygbyWGn2fDVQIsFDtD5e32108qcPUX5W1/AWXxHt7ISwS5QhYJHABXXNmPaZjnVS4cNp3Jj/lL1yxxuPKU7s6u/YJ0V5/tfksPiikE1hUEJnJdkjYGWE3vz7AeYnOHe2ChIw1vHNoY9vfwyd7U7xuTq4hvjh3CwXyuC66W0xzCDqus6jm+w8HGenOAavEEl99m32dKwKji+MdILlHlPsZAMW5OCyi82PylWLgnSQUSUoEJwouIiORj2v9gd/gOES/6hjbycW7yGF1wEHNQu+Od1SgkkBYObofiIvhd5F4jjBU2m2oZo7tiavkhRo3tCtiIW+QC4RTQE4rbfRBXPbGD9pYwP56tCWkWyspWch/J7+wHcRLkp+AO6Rc/MNICieCvUKvybIe/hNQyUaMWe/ZCweJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5984.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(136003)(376002)(396003)(39860400002)(451199021)(2906002)(186003)(6666004)(31686004)(4326008)(86362001)(41300700001)(6486002)(66476007)(83380400001)(66946007)(66556008)(36756003)(26005)(31696002)(316002)(966005)(44832011)(82960400001)(478600001)(2616005)(53546011)(6512007)(6506007)(38100700002)(5660300002)(8676002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q1FmQzJ6RXF5VXNESmZrNlNqVjdVaHoxcHJZVTJLVzZ0V2NHd1JNQmN1WVdS?=
 =?utf-8?B?YlNMeHB0SEJSY05VUGlhZTRvZXpHYndyVEdDSDJuUTZNTkd6N0NFb0ZoSWNw?=
 =?utf-8?B?MTRDZDd5UFNxVk9RYUltd1o5Tnl2cVNaVldYOXFsNlNwOERlam45SmdEajl2?=
 =?utf-8?B?QWQyZDFLbVViL1p3VTUwc2xDR1dtb1h2WEpiMWd5b1JNWlJ1bnB2dkx0QUd1?=
 =?utf-8?B?TXNvM3B6R2UxMmhtS2hGR0IrYVh5ZTg1cTh2ejhzNzdjQXhuUmh2cUxzUnF0?=
 =?utf-8?B?MEdSWDZKaUlXNEdmRG9HdlZVVTg3ZlVGNlFQRm9wZ3lndFV4dW1YNEhMQjNP?=
 =?utf-8?B?cThWRDVOaVVram9oTGhTb1FuZGpBKzYrZlNOQWRyM01sMUJpaXhlN3ZpNXpF?=
 =?utf-8?B?TXBkdHVKamRac3NvVHh3ZGRqd1NxSzVyTlVDclg2bnY5ckhJWVk5MmwxdGk4?=
 =?utf-8?B?TWtCVHFaZHIyMGlsdmV1WHdENDh4bmYyY0pMREtjUzFUUWtMbzhqMkNrMHVZ?=
 =?utf-8?B?MThOTjFkMnkxTWluTUVLNmNJZXd6dVJMRVFHcnVjalFrUC83RnVaT0tsV09R?=
 =?utf-8?B?allTQjI2T2lLbEJMcEFvb2M3bnBDT3ZOWVpVMHovd09DRHIwZmZjZU1mUk5X?=
 =?utf-8?B?Z1hwSEwxbm03bXJta3hPdGJmdW1WeGVZZ0crVkhpaU1Ga2xnWjJYT1VUMS9p?=
 =?utf-8?B?M0VnSHNRcE1yWU8yMEhocEJBU2xLQW1LbUovSXBqYmxkOHdaellCc2tVRm1z?=
 =?utf-8?B?YkdzS3EvNmRheDBiWWpXeEpDY0FHeGxOcnRBeDYxeSthSktJTmNMQ0lESFpW?=
 =?utf-8?B?eStWaHo3QTF4VGR6bEZGTGFzZTFOWjZEL204emJhdklSZVB6Mi9iZW83Y0lV?=
 =?utf-8?B?SjVJU3RNS3N1MGtGYUIvV09NaTErSUNvQWQ0a0lSWStrNDRYeU5nQitKb2lx?=
 =?utf-8?B?bDlTeGZEbnF4c1p2N0o4bzlBcVRvV000MlB3cWtWSjdTak1mYWsyQjc2SFhS?=
 =?utf-8?B?eTdxak9sSEF0VGhjci9VQ1VhZlBoNGp2MGtxZjB0eXdCNjJYSDRoV3Jzdjhp?=
 =?utf-8?B?T3pjNzNrRmlqWjhmT09tNUdFaFdQQ3ZkZS9IZ3dIU3BndjRvKzVRc3VydTJk?=
 =?utf-8?B?TkFBcC9GTm1id1I2UFJ3bVArWWZYYlNBNnJHN0RrQXMvd1F6aHdFczc1ZXZt?=
 =?utf-8?B?U1ZNOVR5UTA4enF6QldLR05sa1BXT0tsaGdjMW1GRUFBZ3UydG51VW5CbXpR?=
 =?utf-8?B?SGRnQjlvc1lzZnB5bFRYMlRheHdpRzNOQmxqWWptSXVIT0dORHd3eWJ3Vm5L?=
 =?utf-8?B?SXJqSDFsL3RhQkI4TlpDdno4ZlZQVUJFaTdybGhCOW15MTBmQksrOVV6TUxo?=
 =?utf-8?B?OXI2Z1FPOFBILytZQ1V4Wko5blo1QlJJQ0hCWjhyV0o2QjBqWHNyTm5lUFJ1?=
 =?utf-8?B?TVNFblZOTEFWcXNzd2liRkFVQTNsZDdQbWgzcEliRTdQTzU5cllXNnROV1Vr?=
 =?utf-8?B?OE9JUFNEcmMwbFpFeWJtTEh1eGphWHhMZlRWd0ZIZDEvQnZaK2ZhUWljbDVJ?=
 =?utf-8?B?SlI0VkJxdTdwRFROZ1FvUDRjZHhKYUMybGxGbTZwMTEwT3lWb09LT284VzNp?=
 =?utf-8?B?dyt6UVlXQTIxVHA0R1ZmNlZDRCtPc2hKWWl6N0xJOGlibFBXZnpvUWFCaW5E?=
 =?utf-8?B?Q1NQelM3N253KzBEZGRDcCtTdXl5ZS9tSDRPcmxVcWVkVWxrNlh2NG9TRFJC?=
 =?utf-8?B?SXl3Qi9VVEVoNGRKYktjVDRIMkdhYnhwWjNPWVQ2ZGxnNjgvS082eGhNdFY3?=
 =?utf-8?B?L0RqYmVDKzdnUjNhKzFlWXBPalR3eENEYWJUNGJVYksxcktpSzNadWhCbm9Y?=
 =?utf-8?B?WTZwMEVucmZYKytzcERUTGRmbUQ3bUY2OWd5VnZhcVJiN0x5Y2FJQ2N6S2pD?=
 =?utf-8?B?L05LMjJ1K29UT1E0VTFpZTNmNTE3OHJTc2pnM2RjaklyNkxST0p1dVBvOTVL?=
 =?utf-8?B?NEprcElmRUpXS0FlT1RiV1JBYU1IcjR1ZXlJTk5RRFBra3h3THMvcHkyL3dR?=
 =?utf-8?B?S2dSTGNqSTAyTGFkZytvWnZFR0JJOEN0aUtDa1RnZ1p5cm95OGZxTzIvdGRn?=
 =?utf-8?Q?9mJDRSRImMHx6N8xvoaGlp6FL?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f951fd4-e445-4d04-187a-08db5d34aff5
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5984.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2023 15:28:27.7253
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KIFDv7GdyfjyRrcKV0RHlMjFzKlhmxngzC/u1LeS0GSpim04Ir/AJ7puxZc+qFoG2rUOVCHJA83MOkfve+X2/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5118
X-OriginatorOrg: intel.com


On 5/22/23 20:57, Li Zhijian wrote:
> It requires some CLX specific kconfigs and testing purpose module
>
> Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
> ---
>   README.md | 17 +++++++++++++++--
>   1 file changed, 15 insertions(+), 2 deletions(-)
>
> diff --git a/README.md b/README.md
> index 7c7cf0dd065d..521e2582fb05 100644
> --- a/README.md
> +++ b/README.md
> @@ -39,8 +39,8 @@ https://nvdimm.wiki.kernel.org/start
>   
>   Unit Tests
>   ==========
> -The unit tests run by `meson test` require the nfit_test.ko module to be
> -loaded.  To build and install nfit_test.ko:
> +The unit tests run by `meson test` require the nfit_test.ko and cxl_test.ko modules to be
> +loaded.  To build and install nfit_test.ko and cxl_test.ko:
>   
>   1. Obtain the kernel source.  For example,
>      `git clone -b libnvdimm-for-next git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git`
> @@ -70,6 +70,13 @@ loaded.  To build and install nfit_test.ko:
>      CONFIG_NVDIMM_DAX=y
>      CONFIG_DEV_DAX_PMEM=m
>      CONFIG_ENCRYPTED_KEYS=y
> +   CONFIG_CXL_BUS=m
> +   CONFIG_CXL_PCI=m
> +   CONFIG_CXL_ACPI=m
> +   CONFIG_CXL_PMEM=m
> +   CONFIG_CXL_MEM=m
> +   CONFIG_CXL_PORT=m
> +   CONFIG_DEV_DAX_CXL=m

Probably should have a separate entry for CXL configs for testing. 
There's a cxl.git at kernel.org as well.

Also will need:

CONFIG_NVDIMM_SECURITY_TEST=y

CONFIG_CXL_REGION_INVALIDATION_TEST=y



>      ```
>   
>   1. Build and install the unit test enabled libnvdimm modules in the
> @@ -77,8 +84,14 @@ loaded.  To build and install nfit_test.ko:
>      the `depmod` that runs during the final `modules_install`
>   
>      ```
> +   # For nfit_test.ko
>      make M=tools/testing/nvdimm
>      sudo make M=tools/testing/nvdimm modules_install
> +
> +   # For cxl_test.ko
> +   make M=tools/testing/cxl
> +   sudo make M=tools/testing/cxl modules_install
> +
>      sudo make modules_install
>      ```
>   
