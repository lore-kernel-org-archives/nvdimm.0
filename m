Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B7022080
	for <nvdimm@lists.linux.dev>; Fri,  1 Dec 2023 17:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lo00UO8B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701452427; x=1732988427;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WhPPdj1L84nwb/a0WguvIdtxAWJl5PDb31XmMYJOZVs=;
  b=lo00UO8Bqx7P1X44hhJ2NWXqLpuA1gqw1QbVU2MmnfNLf6lw2jBQHQ3c
   pBq/MPuWiimd07Op8dAfp7MuVfo3ucpbZDRx9j55tE7jBydqxL8EmNWfS
   ad5smqGwPFwiUjl8JGG98teTELyft8Zl//NPJhRUbQfydana0kCRl+TnV
   1xoMuxqnPGbB4QVqiAgL2immka4PYwgQQ3uuoSCGmlD6tb3aEh6IMakCp
   J5y5uq+vize1wKMtID1zdeBZQ8eUOJygt3AmefqWrWeLvvFGFi0sWPm26
   ef0E3EM+202Vilz4IcJzwThb9i4+9BjaqfTJiOqqne8e1cZjTipaWtdb6
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10911"; a="428109"
X-IronPort-AV: E=Sophos;i="6.04,242,1695711600"; 
   d="scan'208";a="428109"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2023 09:40:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10911"; a="893267453"
X-IronPort-AV: E=Sophos;i="6.04,242,1695711600"; 
   d="scan'208";a="893267453"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Dec 2023 09:40:25 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Fri, 1 Dec 2023 09:40:25 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Fri, 1 Dec 2023 09:40:23 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Fri, 1 Dec 2023 09:40:23 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Fri, 1 Dec 2023 09:40:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O45CkchW15TlQ3jvW1s6B5Me6ytHq0Dto+Crgd4JlFG6EnZZlf6FacrHVlJy01st3fRS+Cpj1HuCqMo+kTL+YSKLdApP/61PsRWKFtQm/vEx5oCFg0gFedxqQJtjv91w0S70Ji3RM7Xx3G+y0eeSG3i5x6hzgf8HDjGbTbCx9qYkk2JRBqF+9gf/C2/VVeYTbiredQq7XTUOA2aKP3XfDpRtqx+cNEojzn1WzUiNPg4noMHcImB288I9uDwqWKkz7CecEcO5f+DkDWsD+P9HRy3BF7ezk3u+xsFhHAP1vfHLLDdqvF/8TL/psuSclkOzcW/qgrBulQIBEGUNQIGLIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7VKxKtnAE2RD6de+y7m8rfZjufxhHiIDJo/TaY0PjZk=;
 b=XoQIrpu1diPimCpYvJb8uFyEcek5awmcvJyoNnwmk6H/TUOgRJXgBx+ffUD36k+qLC8dsgEHnA0GHBssBIJG8tKisQs6BZUaMzBH8S78KbrnDmVDlQQUcFD0drSE0QeWHuKvhlznLWIyzhHIlDRpcVxH9mOe9XAdUjTBuQ5LQZFR2GdW1FI1A9S/vasyn3g519pIpsiQEvFlxsP0wV0t+lPOQu50ELghA5GjOkmjG7dRC1uL94KOKJ7B7ism/QMUWNKqm/kN0rCHzhrGs6WKNC/suOHLQKVcejQLFsdHgfjLsA0d6IbRJ8KISHME8mv+Ub0YQKSxk//oTk+SDM+/2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5984.namprd11.prod.outlook.com (2603:10b6:510:1e3::15)
 by SJ0PR11MB5937.namprd11.prod.outlook.com (2603:10b6:a03:42c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.27; Fri, 1 Dec
 2023 17:40:20 +0000
Received: from PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::6f7b:337d:383c:7ad1]) by PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::6f7b:337d:383c:7ad1%4]) with mapi id 15.20.7046.024; Fri, 1 Dec 2023
 17:40:20 +0000
Message-ID: <7ba80281-6566-46fe-8cfe-9f3264def271@intel.com>
Date: Fri, 1 Dec 2023 10:40:19 -0700
User-Agent: Betterbird (Linux)
Subject: Re: [PATCH ndctl RESEND 1/2] ndctl/test: Add destroy region test
To: Ira Weiny <ira.weiny@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
CC: Dan Williams <dan.j.williams@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>
References: <20231130-fix-region-destroy-v1-0-7f916d2bd379@intel.com>
 <20231130-fix-region-destroy-v1-1-7f916d2bd379@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20231130-fix-region-destroy-v1-1-7f916d2bd379@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR03CA0001.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::14) To PH7PR11MB5984.namprd11.prod.outlook.com
 (2603:10b6:510:1e3::15)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5984:EE_|SJ0PR11MB5937:EE_
X-MS-Office365-Filtering-Correlation-Id: 80241d2f-2105-4a88-b88f-08dbf29496a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qQyZVRHVLiLfQqz5GkQ7xBqmVsklShs1uh5qjK7N7raJ2QDVvWmjsI90g0GjW9gzZrx2m1FiX8jnizeh7qBNqLlmL4TnySyQB/LSjbhkr45Qlaoa2bCASE4Ak5ZMt5C1eNBvRHFsQUAeLruP23AVyOyN7CUY4yA8PoeJemEbSU4oEjqtgInmD8DQNY+yTwWOvKxlwMG6rqavYugNUwWFCIY3NeoSzhqI7TBE3hi/2YiUBrSRLQ2V5zHXg2MJvQU8g63wLean+QKgu9C+xSQ3gs2wFMPa1aQbd9ow8VVorwCGMeHIveACAihdjQStOZo2YmJoQ/26lcBkX15WARvkc0E97ilO0Yv1ppg/xXoAy6o/z9GmREJiblae+39xvp5QDLevbgeKHGCEciWQDn/Zcif/x25x/CBrTQhW7AvJk8M7yUrGx+rCUYeCichVRFCnDz7f13aC1TJq7JNcOa5nwQrLZSHITHa9HNekSIIC88uh+5FiW2etDSCkzI4K2JN7ByyXbqnOhFI1FVmW7zjbTQbUwqn9Nfsb1GvlK0O9mvNbuedB/9Fjn4ExcplyiPdun2tDv84nUyB8OgxxXXeCk9Z0qjEZo7vilcTX0+5p2GiUXyvaK7G12/BssYEVKm9F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5984.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(39860400002)(376002)(366004)(136003)(346002)(230922051799003)(186009)(64100799003)(1800799012)(451199024)(83380400001)(38100700002)(82960400001)(86362001)(31696002)(36756003)(66946007)(66476007)(6636002)(316002)(110136005)(8676002)(4326008)(8936002)(5660300002)(2906002)(66556008)(31686004)(44832011)(2616005)(6512007)(26005)(41300700001)(6486002)(478600001)(53546011)(6506007)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NWx1aDJnc1BRN2QyUURoRmw1eTREMFd1d1lSMVJaZmdrM2ZZWEgrMW80bUpR?=
 =?utf-8?B?SmN2WnZLRXBvdllnaCtsRWxHT0NOK1VzMlVaSTRhek1UTzV6Y09jelp3L1RH?=
 =?utf-8?B?NmVFcFF1T25lQ3dSZFRiNHR3eFhCOFZJNFlvaVNqa1pwZkZFb0lsd2haNFVi?=
 =?utf-8?B?Umk2TWltZWlQYVlCTjZjQ2N5ZVQvcG9COWVpelAwZ1FPSTZuQmxHd2cwdHhY?=
 =?utf-8?B?T1hwQWhoQ3ZyVVJUMjVCSkFXNnVXb3JxKzZyenJmT1lvRnp5eFVVanR4ZTZp?=
 =?utf-8?B?bFRFRUR0MmdOcFljdUJNY0VCY3FIWG5uSmJURHhmbTFqZ3ZySFBnMHVwRkxa?=
 =?utf-8?B?UUZuUVJDWkdQUFpySWEwZWE0Z1I4SmcySDk2QWZ2Tng4WFJmY0Z1T25CNmg4?=
 =?utf-8?B?VGlnckl2Zm5QdTVyR2lQSWZHaDdSOXYyYVVoMW9pWnhNcjNHd014dVZVVFl6?=
 =?utf-8?B?M1NJUkswTW03MW51ckVBMEZWVjVTa0xrN0VCd3FlYnRCL3d6UDR3bnFKNTlD?=
 =?utf-8?B?UCtvNUZ5cFFVaFdXbVZ2WkJKMmZFM21VMktBTlBsNzI2eTBNVEV5YjhVY2kr?=
 =?utf-8?B?R2hDTEJhVDcyVWVFS0F2alFNbCtxNVlXK0REeDJjZ2pXTWhnd2pybTUzeDNG?=
 =?utf-8?B?UWNNYUlBZjVTSjRzNnROV1Zhb2hJMnJGeEhsZUhiT0dQbzQ5cEhXNjcySkFW?=
 =?utf-8?B?QWJub1pvcmd5MXUyM2o2SDdJM0JTRHdQaWxVUm5yeWJwaUt4L3JRNmVoeHZo?=
 =?utf-8?B?WmVUTHlNSDRlalovbDFaRmYzblJMalpnK2NuK2hHRE1TWnZxaVpFd0x3d2kv?=
 =?utf-8?B?dHZLL2lSM3hpa015Q09Mc3dqZW5lNDg5NVc0c1VvV0RiOTF4Tk1yU1JZZldm?=
 =?utf-8?B?ZVpNVUZWSXhtNHNkbmVncW5OUnMyaTU5VFczTzR4bDZYVGNCaGdmcjh0dmRP?=
 =?utf-8?B?UFNpNG00TjdFSVQ3cFhsVDUwcTZHV0NqbUFpS2JGWkFhWFJZUXdCOTdJcmpk?=
 =?utf-8?B?aGJQSWNVajkzZUJzVnVMUVVJa2lWOVZqYnJ0UnY0NUlueVNyUWpqYXJ1SkV6?=
 =?utf-8?B?b20vZjFDM2xoZzErZ1hUMnN5V2JtUHNacGZ3WHJQYzBLKzBCWExlMVlobWdk?=
 =?utf-8?B?Z2tYa1NvLzlnS0F0a1gxRzJSN0lzeHp4ZDUwTmtLWWZ2Y2lXVDlYV1lDSjBE?=
 =?utf-8?B?dG9PRk1pY2pCSnltOVllRVhPQy9FUWF4Ym9SRmRxVE5kb1g1VURPWkdPeTY1?=
 =?utf-8?B?WENUdFRHc0FmSG1uRUtxNDBWVlhWd0s0R2dSRFU1UnZLbEZZeXdMTitXZlk1?=
 =?utf-8?B?UEU2OUs0d3lhTHZKU0xXVVNtVkMzaVRLWnlHWW1vbUdabDNna1B5OWlQelE1?=
 =?utf-8?B?TFQ5OWt2SlZyRjJOdTV0QUljUDFYazlsR29XMDE3bzVKVVExb1FjQVBXcDNj?=
 =?utf-8?B?T0tCd1lhWU9ENS9VZTlZb2ZJYk5RcVZoVjZwcVBNb1NCRUg1ckI3OHh0RlRa?=
 =?utf-8?B?cERnd0pzYmdWYlFPYU1VL0RPU044a3Z2WlEyeFBYNHZQR2JHVmsyM3A5NGVv?=
 =?utf-8?B?RjQwcVhnN2ZhK1BhQWhubVlYcU5SdjY1VUcydzY3Vzhadi9ncWYxc3lNMVFG?=
 =?utf-8?B?TWYzZkxLRlBONVJJb0hWYTBoUGVzWEdJczZRallTWnBDREs4WU5vOERydnUw?=
 =?utf-8?B?djFlN3gveTFBSy84KzJTSmhDM0NTbDNWaUZjcnUzQWVZY2tQZ0lSMnpuSG91?=
 =?utf-8?B?akdmeUJsQVhFWVo0ekkvSG5uVlJlUnlPWXd0QytzUVpCYUtTUWZwRGRsa1Nk?=
 =?utf-8?B?TEljL1FHenR6NEs5NmRQcjljc3dNOURxa2hpUEN1czNxc05YVmlEa01COVhE?=
 =?utf-8?B?MDdpY01TOFRzYTBJeGpSTU1wcitGTUx2MFB1VDhuT3BwR0g2TGZrNmYxUWZP?=
 =?utf-8?B?OVo4S0hQczNMWEVZZTI3dTF2Q3AxTUNOQVZNdHppVTBvRTh3Y1VhaHRhWTB6?=
 =?utf-8?B?U2dTVWtoVEhHNVBYTVVxdWpDUm1MeW9LWjZyeXp0OE90eHVlbCtaZHRJOSth?=
 =?utf-8?B?NzEvSlNVbXdZTy9SQlpvSHcySE5uYnlxaUxub3lRQ2VjYzlSWHk4NkpTV0dO?=
 =?utf-8?Q?dCehn9cpdebzkCqs1lUfNyIOp?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 80241d2f-2105-4a88-b88f-08dbf29496a0
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5984.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2023 17:40:20.0405
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: phYEBJwlNRCOh3nX/NQEglrLLmH2Db1ur/3Y4ApD16bp12smLBdlsUCn9QvcSTw0M+ATDNHY+58gjtTUXbITpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5937
X-OriginatorOrg: intel.com



On 11/30/23 21:06, Ira Weiny wrote:
> Commit 9399aa667ab0 ("cxl/region: Add -f option for disable-region")
> introduced a regression when destroying a region.
> 
> Add a tests for destroying a region.
> 
> Cc: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  test/cxl-destroy-region.sh | 76 ++++++++++++++++++++++++++++++++++++++++++++++
>  test/meson.build           |  2 ++
>  2 files changed, 78 insertions(+)
> 
> diff --git a/test/cxl-destroy-region.sh b/test/cxl-destroy-region.sh
> new file mode 100644
> index 000000000000..251720a98688
> --- /dev/null
> +++ b/test/cxl-destroy-region.sh
> @@ -0,0 +1,76 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2023 Intel Corporation. All rights reserved.
> +
> +. $(dirname $0)/common
> +
> +rc=77
> +
> +set -ex
> +
> +trap 'err $LINENO' ERR
> +
> +check_prereq "jq"
> +
> +modprobe -r cxl_test
> +modprobe cxl_test
> +rc=1
> +
> +check_destroy_ram()
> +{
> +	mem=$1
> +	decoder=$2
> +
> +	region=$($CXL create-region -d "$decoder" -m "$mem" | jq -r ".region")
> +	if [ "$region" == "null" ]; then
> +		err "$LINENO"
> +	fi
> +	$CXL enable-region "$region"
> +
> +	# default is memory is system-ram offline
> +	$CXL disable-region $region
> +	$CXL destroy-region $region
> +}
> +
> +check_destroy_devdax()
> +{
> +	mem=$1
> +	decoder=$2
> +
> +	region=$($CXL create-region -d "$decoder" -m "$mem" | jq -r ".region")
> +	if [ "$region" == "null" ]; then
> +		err "$LINENO"
> +	fi
> +	$CXL enable-region "$region"
> +
> +	dax=$($CXL list -X -r "$region" | jq -r ".[].daxregion.devices" | jq -r '.[].chardev')
> +
> +	$DAXCTL reconfigure-device -m devdax "$dax"
> +
> +	$CXL disable-region $region
> +	$CXL destroy-region $region
> +}
> +
> +# Find a memory device to create regions on to test the destroy
> +readarray -t mems < <("$CXL" list -b cxl_test -M | jq -r '.[].memdev')
> +for mem in ${mems[@]}; do
> +        ramsize=$($CXL list -m $mem | jq -r '.[].ram_size')
> +        if [ "$ramsize" == "null" ]; then
> +                continue
> +        fi
> +        decoder=$($CXL list -b cxl_test -D -d root -m "$mem" |
> +                  jq -r ".[] |
> +                  select(.volatile_capable == true) |
> +                  select(.nr_targets == 1) |
> +                  select(.size >= ${ramsize}) |
> +                  .decoder")
> +        if [[ $decoder ]]; then
> +		check_destroy_ram $mem $decoder
> +		check_destroy_devdax $mem $decoder
> +                break
> +        fi
> +done
> +
> +check_dmesg "$LINENO"
> +
> +modprobe -r cxl_test
> diff --git a/test/meson.build b/test/meson.build
> index 2706fa5d633c..126d663dfce2 100644
> --- a/test/meson.build
> +++ b/test/meson.build
> @@ -158,6 +158,7 @@ cxl_xor_region = find_program('cxl-xor-region.sh')
>  cxl_update_firmware = find_program('cxl-update-firmware.sh')
>  cxl_events = find_program('cxl-events.sh')
>  cxl_poison = find_program('cxl-poison.sh')
> +cxl_destroy_region = find_program('cxl-destroy-region.sh')
>  
>  tests = [
>    [ 'libndctl',               libndctl,		  'ndctl' ],
> @@ -188,6 +189,7 @@ tests = [
>    [ 'cxl-xor-region.sh',      cxl_xor_region,     'cxl'   ],
>    [ 'cxl-events.sh',          cxl_events,         'cxl'   ],
>    [ 'cxl-poison.sh',          cxl_poison,         'cxl'   ],
> +  [ 'cxl-destroy-region.sh',  cxl_destroy_region, 'cxl'   ],
>  ]
>  
>  if get_option('destructive').enabled()
> 
