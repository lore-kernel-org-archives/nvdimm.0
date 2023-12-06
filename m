Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F18B70969
	for <nvdimm@lists.linux.dev>; Wed,  6 Dec 2023 21:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mrFLKJV0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701898581; x=1733434581;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Jkt7lBbF0dFHqb5uXpyf7p17zgE7xQFskc1APpsi1P8=;
  b=mrFLKJV0LdxUOV5Rd5Okjw67EsAaLk8x19hlnIZR4pCb96ieahZW/TAF
   lfHnrXLqda7OxefBsOBohIa5UnTUdel5ghyZc9M7hP/hhp+9YOeeRenJS
   RSOQjg9hZ3/p+O1H14LtRshnNKldJtg95qsIeuYAunuUhNv6mt1MKdt1H
   iIVVDUTouB6Uq+sWwPI6gqR/XHFzPtIMPaVcusbFW3VTKDjDAe/kqYnIH
   v1xP3B+GHUMLUj8DIc5IwXdj5YKDWHDBFjnz0OMx/o0DkT2DHeN5McdeB
   7AcNlnudDna0610S8tN1h5SzrDcsp5wIiQ5OpJ8Z2KXRN6e2fKl2I6VZG
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10916"; a="396920470"
X-IronPort-AV: E=Sophos;i="6.04,256,1695711600"; 
   d="scan'208";a="396920470"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2023 13:36:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10916"; a="721223894"
X-IronPort-AV: E=Sophos;i="6.04,256,1695711600"; 
   d="scan'208";a="721223894"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Dec 2023 13:36:18 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Dec 2023 13:36:17 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 6 Dec 2023 13:36:17 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 6 Dec 2023 13:36:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b79WKjMM1vWh60bK96YH3p9uH+fM3R4gHVmnjm4xqwQIUjLii6TmEf92HrQOduv4qqzJS+1yGjE3dpSsK1uMcgN8UorMcV3kp1HhMxewdCxn/gWVjZjDMjKaVZRaffOYZEij0QwRTIm9mvyeHLzktXyHws7ffAhYbuils6FMfBNln8TwM0EEAbuIy3x8gxppl740iHmpysfRbYWTtty0lhOUrqK+5BS82gs5kAHC5KY06jPTuXj6a2gGQ89ir45swOYLSfyWCDB5rux3GtACdxlwhPSxkVrvAEpekKAlZGRj3FUo8kvifP/I9QLn/BFGntco+FfYWw1MtM6VmEdlRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UgxAVDcQqFt0/xnXwUe3mRdBWOgRF0vzl0sm2zNDnS8=;
 b=hE/P00LkQ3GSzJZOvIjByEQ6uQiMJrLCfHV/a+87gWyAk6rcUhgaGN/0mLl2UE0wSlfpOvFMTLLhIDCeN/wkQlslRp0s5wGsjIb7ACKbluwRKj5K31b+/Cq1iv1RZ6UhFU67NrgIaS8bNXJQzzD1VMpTfTUx40hAC6VbUZ3ZzmlyUzKEvcsPoJKlqQ+XytusMS+Fi63NjMa+5tkoM7FeipWTkZvNNxlWQwa+jo0jLRr6xKP50OZyjfXMQYEQl8MIUTz8B7bj90xgO41hRWCYTPt/3f5M+KCxI6YD44Mdlc1Rl+gjWFzJPEusloNRNSTO2as7IiMO5Munfuk0rKQbKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by PH7PR11MB7516.namprd11.prod.outlook.com (2603:10b6:510:275::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.25; Wed, 6 Dec
 2023 21:35:57 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6362:763e:f84b:4169]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6362:763e:f84b:4169%5]) with mapi id 15.20.7068.025; Wed, 6 Dec 2023
 21:35:57 +0000
Date: Wed, 6 Dec 2023 13:35:55 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Li Zhijian <lizhijian@fujitsu.com>, <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, Li Zhijian <lizhijian@fujitsu.com>
Subject: RE: [ndctl PATCH 2/3] test/cxl-region-sysfs.sh: use operator '!=' to
 compare hexadecimal value
Message-ID: <6570e93b1dd74_45e0129427@dwillia2-xfh.jf.intel.com.notmuch>
References: <20231123023058.2963551-1-lizhijian@fujitsu.com>
 <20231123023058.2963551-2-lizhijian@fujitsu.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20231123023058.2963551-2-lizhijian@fujitsu.com>
X-ClientProxiedBy: MW4P221CA0023.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::28) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|PH7PR11MB7516:EE_
X-MS-Office365-Filtering-Correlation-Id: d70871c9-233c-4ded-35e2-08dbf6a35543
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o0zeBLi+bltKxFiB9FEBJhetxy1Ob1cNWI3AfMv6YapUKY9n017Vc5pVRT2JOEiDeqT74Uoi6vVvRCAd8jiPlb4StWaZvOKowT+cN4yaOdC/Qa/WdxbLWuO7B/UWsydKocEwLOR2VXPY1zKVOQNilzQR2NWj2zaqmHGpT7s6tS9bfReI/z557zQf4ie6gPDCiHhE1HoPKHlQMxO8NpMoYHbBYrc24p5YZJqmVitnA8euHaVP26fNpRv/JxhENAQKmdu+xkMdilWiZXU/dNfIecn+A2tb17DAIxKP5ZXe8PaoT1iqXax8ATplJy1MsU7hdWQkQth6He9Lx9zRPj6QbS7oPmhc/zGyxh4gSHN4HzCo70iLgcIiITBXloQCBMoRzoRncXN5os0LcGUT1Jc6wyeUiwfTVPvhB/zwyXBFq1qiW/3RFN1cRb6R9s+CebqoeiisfZsM+9ru2Rz4Aqtpnmq10wgvbY5Ldhwf0hiXu8SS8l9663C61fSTb0HRN792Q1qrbTXM4KKgk8Iv6fR/WTktyTNLIN9mCmiB3x6OvF4ZdwowxDfMfiUctn7x4nn1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(136003)(376002)(346002)(396003)(230922051799003)(1800799012)(64100799003)(186009)(451199024)(5660300002)(82960400001)(41300700001)(4326008)(8676002)(86362001)(8936002)(38100700002)(2906002)(316002)(26005)(83380400001)(9686003)(6512007)(6506007)(66556008)(66476007)(66946007)(478600001)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FpDS3R/9czJDQ2MKC0+PVrHQX7a8hbEuJ2B63gf9MX+CTU1Ph00m1I+hlN2f?=
 =?us-ascii?Q?qX5aOfen6TJdRPls1CoDpblfqAQ2Ykg0KJXL7M2PJo0ibnhLR2Iqf1Y808yR?=
 =?us-ascii?Q?qvq2eHzKlhxZEKGvZJGQukjNRugiQry4eSGnrLLukO9WF/SbQbc2LhJgV5Zv?=
 =?us-ascii?Q?Tb38GzW9zgUxgLe9iI2gO+2j98E0PU96fra7/RWuUSzzXc+O4J6i4EM+5n52?=
 =?us-ascii?Q?r49j7m8v0OOBHBqqzZ4YzdAY4sM9bnoAzPvE0x79RnFOl9rX9Ltv1mCqcqGd?=
 =?us-ascii?Q?SSENhx0/wg20N/JOHIKnVNp0ofw1qzyClQ+OxFSVdnV1LX+jw1zKmlIAgzt2?=
 =?us-ascii?Q?Hx5gzs4U80Ay13t+lbPftH/2rR6dX+V12nN0MA1P/UJsWb/s6sMSREHOjlcC?=
 =?us-ascii?Q?W+hbB06cwImBMexZR1uEPtNiVQkQKrZBxH34oc6AuBu/h2g9H+m+RrCBhxJx?=
 =?us-ascii?Q?xCQ52BX/9ODk4GmJLNm66OkOYWSdXjveHPHnSxrLvfmoy7D3Wen72+eKTM2e?=
 =?us-ascii?Q?bMPlHA4VWLsrDxnb+eF9fetRwsRsclyySTvwmMx+8xNL+eTco0+HAfF0QJq3?=
 =?us-ascii?Q?AXc6Zk+Kc38SCbtTdr0BqKQhMZS9PM158YHQH/9GxzmhmcnNQuNMWMwcZRn5?=
 =?us-ascii?Q?TcsHV9nabNplk3XhvQsnc4Jq25oRLub4aIZk8eGOZrDIVC5v7fHhtDz1TJkN?=
 =?us-ascii?Q?XtaZfBHVViSwrtPKKw1xSVR/F5TyDzogZxcl0YDMaJxzOSrcfdNS5hOu0a9P?=
 =?us-ascii?Q?uS+fOJSNbrYbBhXAi/EgdehK8zSqagwjeTY9oh1C58vnhniAUE3rXPmuDp9z?=
 =?us-ascii?Q?pTGlpherJZtyqxi9lOWKOcJI+ndknAMelKfe+CF1GYPk2bUJUSXkCn6JIbeH?=
 =?us-ascii?Q?hdHdJ5K6Bw5bxe/hwZ5dwY7YK2ExstN6BKe1qdB/uXgnaXdHeITTfDCY3sno?=
 =?us-ascii?Q?/IaQ+gHmyZ17PSBKx5LsXUyTTmmLmh2laTt2T/xoEhdXEVb1zps6ztQhkxSX?=
 =?us-ascii?Q?7K6ifPuN+qaOWIGbg1BCYHCHo752q6Ea6hdxZ/wy6jrqlfkbJVoRrnaorRlX?=
 =?us-ascii?Q?LyH99l141mowECcIfFcgTPyb9I/Z4WVRhr/P9dIVO5E9m1Skpne3I1zQgTGD?=
 =?us-ascii?Q?6p597jX+5xopH205cNaeWQBgwi+/4Fk2QUH0+mZOEWYQhHZo5R7IkrRnAz5h?=
 =?us-ascii?Q?ilx7idLElJ4SRXdr96bsMjK5+AawjaQhX+GIsPDhakSgZkl0XdNZbC5wIZ2M?=
 =?us-ascii?Q?qIHDwIIihgc7lqLl5oqE12Plajxk1cZVH/eFRhwGYw62AqrnmVvkSZYeeSch?=
 =?us-ascii?Q?yCjPuFByLpcNZPuSWM9FOfBO4i5CrvgsnMafSegkXc6CpK/7RYa/kUz4Jo2z?=
 =?us-ascii?Q?jYOWEjs33P7NoVroBh2q2JrzLW08W3lRrNdcFu7B5IZpaBmaWO4zN0l9mAMa?=
 =?us-ascii?Q?UsSDyN2sx8SU4oevtZJAZWkL4dqFALRptIoubCGskyjm3KnFvrOV13eFDjmz?=
 =?us-ascii?Q?GTDkAMCfna6sG1SgnsctiMakaj6omPdE2Es7gNl/KKUVnCwIwV+kRompnAJh?=
 =?us-ascii?Q?ZznkS9AsWVGnFTUIrNpTOs1lXa7ykTcdMx9ISvgF/sVZUPEvE7qeV2qAa84X?=
 =?us-ascii?Q?TA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d70871c9-233c-4ded-35e2-08dbf6a35543
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 21:35:57.4918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /IUVOEM6UWNoQeImzdRbrYi/R9fooOAVNi1rrcy+Wz3mf98XNezeHMTYeMD9sWe6z+yx3tyWB+8pUSf3q8kPAPTqZlK6LyzgLeO9/RaE1zc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7516
X-OriginatorOrg: intel.com

Li Zhijian wrote:
> Fix errors:
> line 111: [: 0x80000000: integer expression expected
> line 112: [: 0x3ff110000000: integer expression expected
> line 141: [: 0x80000000: integer expression expected
> line 143: [: 0x3ff110000000: integer expression expected

Similar commentary on how found and how someone knows that they need
this patch, and maybe a note about which version of bash is upset about
this given this problem has been present for a long time without issue.

> 
> Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
> ---
>  test/cxl-region-sysfs.sh | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/test/cxl-region-sysfs.sh b/test/cxl-region-sysfs.sh
> index ded7aa1..89f21a3 100644
> --- a/test/cxl-region-sysfs.sh
> +++ b/test/cxl-region-sysfs.sh
> @@ -108,8 +108,8 @@ do
>  
>  	sz=$(cat /sys/bus/cxl/devices/$i/size)
>  	res=$(cat /sys/bus/cxl/devices/$i/start)
> -	[ $sz -ne $region_size ] && err "$LINENO: decoder: $i sz: $sz region_size: $region_size"
> -	[ $res -ne $region_base ] && err "$LINENO: decoder: $i base: $res region_base: $region_base"
> +	[ "$sz" != "$region_size" ] && err "$LINENO: decoder: $i sz: $sz region_size: $region_size"
> +	[ "$res" != "$region_base" ] && err "$LINENO: decoder: $i base: $res region_base: $region_base"

maybe use ((sz != region_size)) to make it explicit that this is an
arithmetic comparison? I would defer to Vishal's preference here.
