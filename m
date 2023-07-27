Received: from mgamail.intel.com (unknown [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF4027132
	for <nvdimm@lists.linux.dev>; Thu, 27 Jul 2023 21:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690494580; x=1722030580;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hiNxkc/brySlvev8ql/otcvJ64p4EfrOnlR+PpTKUes=;
  b=gztYCLJrTGzDZziQnpgpqBzvabvbLXw1kZxkwcOH0mZGQNBzbBsmqzAe
   gn95WBFxHZ5QbyvA+AnPGCQqRWCp4596+asv7HDpr/9hK33UVswalAjkI
   OawVLiY+K2ZSaerBGcDznoOXbyiVz8WqaUbJ4eC6cHG4XGqz8jKTzNbgC
   Tj8zC7eiGNuKLOdSsV6E3e9nffu3c0Syx4aKpv4gB4j/nHKiITRdILN5R
   bTwItpy6NSYVM5TMd610gIlvX+MHSVhgRgVMyi5SBj1LY4YCXQc2XtuK7
   9RZdgMZsEtSq8L9y/cmdflgIllcwYXLWxiur7+cWJMoLuJLQqzCQ2qULV
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10784"; a="371139618"
X-IronPort-AV: E=Sophos;i="6.01,236,1684825200"; 
   d="scan'208";a="371139618"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2023 14:49:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10784"; a="797183365"
X-IronPort-AV: E=Sophos;i="6.01,236,1684825200"; 
   d="scan'208";a="797183365"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga004.fm.intel.com with ESMTP; 27 Jul 2023 14:49:37 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 27 Jul 2023 14:49:37 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 27 Jul 2023 14:49:37 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 27 Jul 2023 14:49:37 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 27 Jul 2023 14:49:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UgcAV+EiS7W1/fLh2bBwMMU3GGKxkUvOgkAVsplITttgP22/9K7meTCokE6RMBeqiJXD9WPpawFssoHSUItbTUFCL0IROPCCIhxdr10oR509hpah1hXA5H/Isap8wHgTpFftjiJW4c14eRcHkEx3A1VCzXA73NK9CLRU+8pXUspAa3qXnjrgKSf5kyMoiXTOvH3LUOekc2f6k+T0SzG5u/uFv161vS4PYGWkji0EgiGI95Mb1P5o8M7OW5Qu3eYUZX7AAuqqF2pR0sBDXGzvt3F6hPLvPLRRIuDHrgiDcyqNR0AR7zaJjm4kVUIp73UqzQ2qfL+GMrzAKu3wY8jpuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZoO9PiJv44Lmx36Womn+4EBhP46Qaa52Lq4M794EfS0=;
 b=ZWVL/iU1Q9fZuzy2vOYuJIBGvFnTNw8Aj7dVEcqvtycdOwdZmPZPMjlpLBEz4VtkO/KbB7J/N5U0YWtnELFX/t4vzf/mngJiZXd5oLSS/m1y7Rh79N2jlk5yXHSFIfwh58Bvwb96OYkJKsZOv3ckog2/lQvkLGsCTdR52zposWOPCg8aH6d5u9sO/wJm+9aM5J/oPu13oCsHofYdJ1oyap8JOojO0y811+LaEBtU0d7Nf0pSFnsqc2H/uVhbqNLGdiw4588SqlOUTKMCI/2UO1bEG7OVAZouhEvfcAQ0RG87s65wm7KDeM3JNtTWc9PNGACIKscRukvxqwz5dv/MLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5984.namprd11.prod.outlook.com (2603:10b6:510:1e3::15)
 by MW3PR11MB4634.namprd11.prod.outlook.com (2603:10b6:303:54::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.29; Thu, 27 Jul
 2023 21:49:35 +0000
Received: from PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::be6a:199e:4fc1:aa80]) by PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::be6a:199e:4fc1:aa80%6]) with mapi id 15.20.6631.026; Thu, 27 Jul 2023
 21:49:35 +0000
Message-ID: <867b567f-45cc-d6f1-d5f4-cc68a80406b3@intel.com>
Date: Thu, 27 Jul 2023 14:49:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Betterbird/102.13.0
Subject: Re: [PATCH ndctl] ndctl/cxl/test: Add CXL event test
To: Ira Weiny <ira.weiny@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
CC: "Schofield, Alison" <alison.schofield@intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>
References: <20230726-cxl-event-v1-1-1cf8cb02b211@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20230726-cxl-event-v1-1-1cf8cb02b211@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0020.namprd05.prod.outlook.com
 (2603:10b6:a03:254::25) To PH7PR11MB5984.namprd11.prod.outlook.com
 (2603:10b6:510:1e3::15)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5984:EE_|MW3PR11MB4634:EE_
X-MS-Office365-Filtering-Correlation-Id: 0795623f-d647-4a34-8e96-08db8eeb5e32
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bhz9KV/DU30irZu/BdS2lzgmoh/CV4rZH9y2POt9GA5Pb026nw0EhA5Ak7PZDFUqKU8VGK7/av67QrJPPUuFrYyWPvrJbmxUCmjR/l59Ijsjf2dekw6v7ZGoE+CqQF7ZoTCC1Azhtxma9Jm25ZnQWYpvUd7sOVrotYELDzotWjkFqZfn6tGCtLsamCSXQfx65ZhLf6QvpXHkh8Xkl/NdUaYqH5z5V+5cJKVZ7VPy/jEGGPIKM5tJ0/M7KwE1zGfXhUrvCFQQMSmkrMRuFgNDKo+MzL+lcKcZoyI0aFc/4KL+twkkQquO0M+OYwzkhpLZcaBcALHLMwlpfWZ6W3Lmlyih5jFp5oT3sbcumVDnt1G6ejWzulNXCw645XYba4sKdNUbTlrKNugkAnti5jEzJGWcXN1CwDxTn0ODBVJCG37KjGkp3K2NdtDRoTlaORCY5a6NRbfMDbuWVWI/7G5fsTULAXHUJJWFHv/B5B9NQits1QbgLBMPZ+ZfsNHnBYfVWYwb+a4w9NvG98H30mR3KRvhw6NqbaT5aPay2wg0SaVmLwTGCZsCqpNP2SuUQ9bXmimhsbV4JwLWgeosS35mFZLXeDIIjiWkHVNEEu49SVXqOHGO0d7Kv+ADbuTP90Lg5zQjqBSI08mRfWqp7MrYVg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5984.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(366004)(39860400002)(376002)(346002)(451199021)(5660300002)(6486002)(82960400001)(478600001)(6666004)(83380400001)(26005)(53546011)(6512007)(6506007)(38100700002)(4326008)(110136005)(54906003)(6636002)(186003)(66476007)(66556008)(31686004)(66946007)(2616005)(86362001)(8676002)(8936002)(2906002)(41300700001)(44832011)(316002)(31696002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cjI4OWZURWFNemdjU3V5aWZJRU8rSTNDbzhGU1hkRG91Q1RSWTcyOUNSbUNL?=
 =?utf-8?B?eUlJZkJndmJMMXNpZ05ra3BDQWpHUFNvTyt5TWplL3dZTmdBRHp5d0pkZmMz?=
 =?utf-8?B?a2M1MXFNUnR5Vm93RXBWelpnOGF2NktkZmc1MkpnVmhBYThOcytWZU9aOFJQ?=
 =?utf-8?B?dWZHaE5MZUdXK05KWHk5cVN2eDduVVFOdG40RzFOVUdkWVE5U2xQTHhxcjhW?=
 =?utf-8?B?RHdMVHFPMmFMdS93NUt5QXJ6N3MxYSsvZkxreFI3d2N1eGY3L1NPd3IvMEd1?=
 =?utf-8?B?SFIwTlJFVmdHOU9EN3FFTWpVTzdzMjcrbncrKzBDaDRvT3ZyYUhHWmhIZnNh?=
 =?utf-8?B?MGM2NHd5OU5UZmhRbmJSRFQza0ZBdlFidXE1T2U0czZ4OHA2Qm1YdzhaOFk1?=
 =?utf-8?B?Y1NBSUFFL3JIWUowZ0FiYVpzdjJzUnBzREhWZ2VoQmdObjFLZGt3WTBLYm94?=
 =?utf-8?B?UEZCMjNUL2hteXJONitGTnVRZ2Zoa1NuNzRxUUtERGJqYkdDV000VzBuNTNJ?=
 =?utf-8?B?L2NGdmdOUUo1Y2lqclRTd0N0S05vOGdOM1NuZG1XWURNa3FiUHNMc2JTYjZH?=
 =?utf-8?B?SE1yQnBFL3VwV1lPQlh6OXp1RDhHMStqdEczd1FEQkdScXJzQVdhTnpVSzI0?=
 =?utf-8?B?SlE2MWhKVkRmSktaZzhHRW4wREl3blMyMWIwRjRyd0EzenZCUEpZL2VVeEdp?=
 =?utf-8?B?NEE1dmMzUzN3bm5rUjVuUU80ZHA5cUpsNTdSYjdNNHduczhMK1hhZEVpcGdW?=
 =?utf-8?B?WGltNmRHZldpSmc4eHhmT2xULzFHMW9LNmluVitGVHlxMzgyTnByZE5uZWVo?=
 =?utf-8?B?blB2TWZ6a3QrSjJFRGpyOEIvY0VWNm1jciswb0xaNFlGU2xiNnh3N1NWWHQr?=
 =?utf-8?B?aER5MkV5RzdMUjFKNC9KVjZVZzBrZmpOd2VHNEpTOXpvUUxRV3djUU1tenlJ?=
 =?utf-8?B?czFMRGRYbjAzcVRkVGZ6b2p3Mnd5MXdlaWp6NXpWalJ6aE1CODdjWVZURlUr?=
 =?utf-8?B?STRseFRXYVBra1JCSy9mYndNV0xWcXZGQ0ZqcElLejRrUVJSaWZPcjlDNkMx?=
 =?utf-8?B?TWJGS2JEeDdTYnkyTGJ3R3o4YTRJTkZRN2RrRFp5VnRzNXB2YXpWNnJ1RWgz?=
 =?utf-8?B?Y1IzRyt3Q1RpbVd1cTJyT3l1RXp3NUc0MmtXVHBjZENZS2UxNmFOd2pEWDFE?=
 =?utf-8?B?OXliUzQrSU4zZllpNWoyQ1JQckFKV1VYUmszVGhYZ0FSQU03N1JWMzJaSnJQ?=
 =?utf-8?B?dW5PNzRyemtTVFJOMS9rUG5PNjF1c1N1SzJCRFkvRDdzcitRQi9kNHU5ZHV5?=
 =?utf-8?B?OUd6ckQ2MmM1bWphTU50WUdWR2dPbHd6NGRjR3NqY0ovcGl6QjI5RzJjZmZH?=
 =?utf-8?B?a3lnVmFNcGIxQkd4UHJENTNHcHViWEtiaDJ5N2syNVpGREQ4cnpqNVpMbHE5?=
 =?utf-8?B?N1pNcDVWZkdzVjkwbUI1YWtEVU0zd2tNbGdRbkg4T1RQaGMxdklhdDN6dEsw?=
 =?utf-8?B?YmNHZTh0d0hLR2dGbWp5WFZDWVEvaTZhZjJSOENKSjh6ZUlESVJBQ0xTT1hT?=
 =?utf-8?B?SlVrbmorNWpYLzZoZ2ptOUhvbU9ycGRZdGlyRWNqaUw4SDlzOWlZWUVPMzls?=
 =?utf-8?B?bUV4d1lxMzJMZzFrNVorQ3lHOW42eHJuelY0Yk1sdWsyM3JVajJCcWZlc3RE?=
 =?utf-8?B?Z1dBa0lEYjVHc3QrRDd0T3BTYjV5QWVTNWlESjBCZ3lzdG10SS9mT2NqMWZn?=
 =?utf-8?B?cnJoRUR4RTc5L3B4MEZkVmp5bHc1TitmWkZaUW1iQnI0dWdRQW90b0kyYTdi?=
 =?utf-8?B?cFlQTGxwNWNyRUdrL2tpZkNFNUFuc1IreElPa2pJZlluL3hocVRLV3dGYlp1?=
 =?utf-8?B?bjRlR3ZJdUR4NnpwVENJSmM4R1RGb1M4ZFlLT0ExNkJHVzR4amEzY0VUdElv?=
 =?utf-8?B?aStZV2FlK2NyUGpjUndRZU5JRVZaajVVREpKYUR6a0dMOVczOGlhT24zSzVj?=
 =?utf-8?B?MzAyemFESTlUWFI1WEw2dWJoY2xGekF2Z0pNcnVFMExPVWIvQjF4QmE0UTJW?=
 =?utf-8?B?eGVTV0ZkTFk5QVh2UmRiVXhQOWFGblhLYklhYWgvZG12STNCWmM0MTNPS0Nn?=
 =?utf-8?Q?DOEM79Sj6fNwbx8BiIFx7Mc8L?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0795623f-d647-4a34-8e96-08db8eeb5e32
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5984.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2023 21:49:35.3182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PQdb6TBqScVW60LT3/1W0hsh/O2SQT49k+yRxuRiP1zCYNU/4XEQE8vBoxRH4kruS0nBeMrCjJ5c7DVvqKX00Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4634
X-OriginatorOrg: intel.com



On 7/27/23 14:21, Ira Weiny wrote:
> Previously CXL event testing was run by hand.  This reduces testing
> coverage including a lack of regression testing.
> 
> Add a CXL test as part of the meson test infrastructure.  Passing is
> predicated on receiving the appropriate number of errors in each log.
> Individual event values are not checked.
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>

LGTM. Have you tried running shellcheck?

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
>   test/cxl-events.sh | 68 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>   test/meson.build   |  2 ++
>   2 files changed, 70 insertions(+)
> 
> diff --git a/test/cxl-events.sh b/test/cxl-events.sh
> new file mode 100644
> index 000000000000..f51046ec39ad
> --- /dev/null
> +++ b/test/cxl-events.sh
> @@ -0,0 +1,68 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2023 Intel Corporation. All rights reserved.
> +
> +. $(dirname $0)/common
> +
> +set -ex
> +
> +trap 'err $LINENO' ERR
> +
> +check_prereq "jq"
> +
> +modprobe -r cxl_test
> +modprobe cxl_test
> +
> +dev_path="/sys/bus/platform/devices"
> +
> +test_cxl_events()
> +{
> +	memdev="$1"
> +
> +	echo "TEST: triggering $memdev"
> +	echo 1 > $dev_path/$memdev/event_trigger
> +}
> +
> +readarray -t memdevs < <("$CXL" list -b cxl_test -Mi | jq -r '.[].host')
> +
> +echo "TEST: Prep event trace"
> +echo "" > /sys/kernel/tracing/trace
> +echo 1 > /sys/kernel/tracing/events/cxl/enable
> +echo 1 > /sys/kernel/tracing/tracing_on
> +
> +# Only need to test 1 device
> +#for memdev in ${memdevs[@]}; do
> +#done
> +
> +test_cxl_events "$memdevs"
> +
> +echo 0 > /sys/kernel/tracing/tracing_on
> +
> +echo "TEST: Events seen"
> +cat /sys/kernel/tracing/trace
> +num_overflow=$(grep "cxl_overflow" /sys/kernel/tracing/trace | wc -l)
> +num_fatal=$(grep "log=Fatal" /sys/kernel/tracing/trace | wc -l)
> +num_failure=$(grep "log=Failure" /sys/kernel/tracing/trace | wc -l)
> +num_info=$(grep "log=Informational" /sys/kernel/tracing/trace | wc -l)
> +echo "     LOG     (Expected) : (Found)"
> +echo "     overflow      ( 1) : $num_overflow"
> +echo "     Fatal         ( 2) : $num_fatal"
> +echo "     Failure       (16) : $num_failure"
> +echo "     Informational ( 3) : $num_info"
> +
> +if [ "$num_overflow" -ne 1 ]; then
> +	err "$LINENO"
> +fi
> +if [ "$num_fatal" -ne 2 ]; then
> +	err "$LINENO"
> +fi
> +if [ "$num_failure" -ne 16 ]; then
> +	err "$LINENO"
> +fi
> +if [ "$num_info" -ne 3 ]; then
> +	err "$LINENO"
> +fi
> +
> +check_dmesg "$LINENO"
> +
> +modprobe -r cxl_test
> diff --git a/test/meson.build b/test/meson.build
> index a956885f6df6..a33255bde1a8 100644
> --- a/test/meson.build
> +++ b/test/meson.build
> @@ -155,6 +155,7 @@ cxl_sysfs = find_program('cxl-region-sysfs.sh')
>   cxl_labels = find_program('cxl-labels.sh')
>   cxl_create_region = find_program('cxl-create-region.sh')
>   cxl_xor_region = find_program('cxl-xor-region.sh')
> +cxl_events = find_program('cxl-events.sh')
>   
>   tests = [
>     [ 'libndctl',               libndctl,		  'ndctl' ],
> @@ -183,6 +184,7 @@ tests = [
>     [ 'cxl-labels.sh',          cxl_labels,	  'cxl'   ],
>     [ 'cxl-create-region.sh',   cxl_create_region,  'cxl'   ],
>     [ 'cxl-xor-region.sh',      cxl_xor_region,     'cxl'   ],
> +  [ 'cxl-events.sh',          cxl_events,         'cxl'   ],
>   ]
>   
>   if get_option('destructive').enabled()
> 
> ---
> base-commit: 2fd570a0ed788b1bd0971dfdb1466a5dbcb79775
> change-id: 20230726-cxl-event-dc00a2f94b60
> 
> Best regards,
