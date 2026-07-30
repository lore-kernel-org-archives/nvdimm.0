Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 831AA403AEA
	for <nvdimm@lists.linux.dev>; Thu, 30 Jul 2026 22:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785452397; cv=fail; b=ZNqXtZ6D9XhH6PaL/tOZaWwaXHgcHa06vvei02PC1NWONmYJWIahj5m6/UNJHYUh6/1XK2BZM34+WgJrLkDJJ7DJLWcFtfylnIY2Uy/fAY07HrZJIQXIEysimxAWZXKFr/T9vg9vPyRmIrhiY1BoX+O0PLDxxXrx7ZH1uYvMD48=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785452397; c=relaxed/simple;
	bh=L7yB9EsoP+b5rJoX2diUrdZJ08I6NJpURuspS0aEejM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=gUpCkAB/Qlmis72C12WA1zXB4FzA9kcMUg1AcfDTZ5euw9fdpBvdWMXRirs5Ze/rj1IMSfLeVCdwq0IuCmdVEE/GI4uAGduvw/5nhwsbPgadE5l1yJOCadlgCTNyLIeBMYVEUj3iGF3L7q/pbeRo/Sf+1DbylKuz1QLGEUZDzMU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WheH/8KE; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WheH/8KE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785452395; x=1816988395;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=L7yB9EsoP+b5rJoX2diUrdZJ08I6NJpURuspS0aEejM=;
  b=WheH/8KEH3Ab3QGbU3jyMnZmRm9ZWp3U62hjwCJQvWyPwMIuISEvCKEu
   4b4e3gLEJYczPoaC8lqUPeITl5rXWpI/CJpxwiSthRMNl1F2a+QBcMIMZ
   WoNb3Dq2G6TUhkpBwTuhm8G7uUuSrJDgUIxeOnIKmHjmQTcjOGrHcNAA8
   l9FTZUmkddVTpTH4noCobgfntLzPeBblGn6NwfXbEHz+I9EkpAn79iqjx
   RnacmeFxq6gTSMLw0OrXIz1U9FP27ldLGMVxC8/csf6gwFWF54cr3stKT
   FS7spGvmx5RWBo5f6ya1WBfvD43nUCIxryR1GBLJsgiiS27tZ6p4RngHk
   g==;
X-CSE-ConnectionGUID: UyeXGCjATjyMweMk6z5Ueg==
X-CSE-MsgGUID: 9e4Pz4WHQTqxjsr3BGvYQg==
X-IronPort-AV: E=McAfee;i="6800,10657,11860"; a="96440793"
X-IronPort-AV: E=Sophos;i="6.25,195,1779174000"; 
   d="scan'208";a="96440793"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2026 15:59:54 -0700
X-CSE-ConnectionGUID: QZAmnNk1RSSmQHLzkT/tsw==
X-CSE-MsgGUID: SZeGKxl6SzaJLN+7m2IDQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,195,1779174000"; 
   d="scan'208";a="262368327"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2026 15:59:53 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 30 Jul 2026 15:59:52 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Thu, 30 Jul 2026 15:59:52 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.33) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 30 Jul 2026 15:59:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hD9dXTxSwvd3eq75kjBw8CMHZ4b7zBBUXsz8iHJWr/oeGaXLSWMYbpByg3jdleVDEcJT16SfSCo6iDB/5lvDCcX6AcbUPl0ekyjKN5QLbya/+Tdw11o0LvOUa6tsh3ShW+28xS2XegrU65HrTgQv5dx3b/Zjx71WYUYhu4iKq7a7tKe18oq/IKircNc5SwlFH0iHQIyicMrjPMY6T366Thc3NaSwMCnPO2WofDD/GYlFaHNrmAzcgWHEt0OZ46yXnmDKD9DwGf9AAZYDCRZ4RpQhruui8yXNa8B3zNQeNa+CFYBHwB2S8MlvAzVZexpecY2RU7JCR05gEKXqCta8IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fg4x+bVDsRbhv6DpsZ+BDxrKkJQP2jJrzdfs8EaEesc=;
 b=wL8CSh8MO7er+jHgbvs33FV3sje42ctVX99xnRLHGGJE9n05C5wCJV2He3WdzJT/pl7vDNDkLJt0FiCi9ZbD/SeuBiz+ZQ1ftNjqvEtlxf/RIa8CpKtr5b++OHFykMTKtbl2X7DjVIRLw710IlJTXTz0r50ChQeqQ69QOSf82cVL/fbd54xbMbiuCQhtLK6FX+Sfu6iISMSvKK/hUQXpGtrznRzakWANOucjmNYxsoB0yjmr5DfuQmV1G701MTEhhXSHnvnvjPxaVsf6hKjiJgJ+r9hG5rgNMh6tK76MUkPt1E2Ljkmy8EtjQFCDWysXAVz1LORLUGq1KfUgjGGZdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by IA3PR11MB8896.namprd11.prod.outlook.com (2603:10b6:208:57d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Thu, 30 Jul
 2026 22:59:49 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::e721:90d7:9214:2d53]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::e721:90d7:9214:2d53%6]) with mapi id 15.21.0270.012; Thu, 30 Jul 2026
 22:59:49 +0000
Date: Thu, 30 Jul 2026 15:59:45 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Randy Dunlap <rdunlap@infradead.org>
CC: <linux-kernel@vger.kernel.org>, Dan Williams <djbw@kernel.org>, "Vishal
 Verma" <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, "Ira
 Weiny" <iweiny@kernel.org>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH 2/2] nvdimm-btt: clean up kernel-doc warnings
Message-ID: <amvXYfI2m2F2SrXG@aschofie-mobl2.lan>
References: <20260721172132.3718892-1-rdunlap@infradead.org>
 <20260721172132.3718892-2-rdunlap@infradead.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260721172132.3718892-2-rdunlap@infradead.org>
X-ClientProxiedBy: SJ0PR13CA0227.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::22) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|IA3PR11MB8896:EE_
X-MS-Office365-Filtering-Correlation-Id: e4779c47-085c-4739-39fe-08deee8e41ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|56012099006|10067099003|11063799006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: /++pZoSwaeB2Wzbx44JdBjkGtWAPZ2y2pTDqxptK09rH7bmbrRxxclTTkRVlJ24GMXOAYURKSWap43P8DrC/0tXJT3lpegquqX3WDmnpX81E3uEWtJKztnEKzuTiVmXllyvvM3hMCSx+EsmuzpCXgqYUnNXR+i8J/y0ontFdf4skhJOJ4V0NkdTqONW61dYLeXcwCJomN9IO/c7A36j9VF4BnHmSw4hHcvoTH5dgOBHXwVmgJghMzDnHN0ce/AZctgUT5Ghc+5Z4arSg644FNu2Z1n7+bP5toEd9nGuquAb/DDkKcQ8gNMbf8CK+WO9Tv66MKAw2RKAeQ57q1OuB1lu3LjkICrzzgSmaUVfrKLtxEtLU1ylSbWQKQirHPW2Dx19KOEqYjp2jFrQvTAnKGLD9AafhNDo0x4z5kFDSK+Urk5t1HMb8aKW5uCDOcSdbgEIzi5hEzq/J2kdy9V4Csn4DYzFXq6YM0vY8udkkzpHpQUPAocy6QlXG7SiyUkn6Hvht5d2/r9hVQHQE+8mO7EQaFKH5UG4r4iRHY9+EwHG/Dj1Pq+WOqG1BII7s0nS83sDmtlWLNddf32Wt7JkDgskM7dSogNSnKIpwvLE+oF771SecTY37kEoveKkqsY5aARFIC0zoTRZOj/hgihxqPYcmPj7sW3bM9L/ARf71GWU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(56012099006)(10067099003)(11063799006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VWVLYkV9k/4xZjigrWWRnWB7R/Nni95cMaI09QOGbgUdUw+nqxO3B4hhSTfw?=
 =?us-ascii?Q?/QZ0H2xSOYDweJWaL8/9Kaioszh0Vxjrqxa/2OB1XvQSNMQeHB2emkVXPNZX?=
 =?us-ascii?Q?BDauEimW6equrOwUT3dfOi24lkzqI/g7bMWdKmx80h69YUGTGYcxaLayHQ0Z?=
 =?us-ascii?Q?/CiEgaqjGxNXiqkfQ5YLga5tHvx2RxJim5Ki15Cyvjp+LgdTp/FCCul9ZADE?=
 =?us-ascii?Q?nE+Tiq5agvkfKauxFR0WhNapbYcLlWEDE57erOZB/qdEYxBnUoqXLvhgn7PL?=
 =?us-ascii?Q?/BOYe56aEWyYH6d0Aqcgbmifxm3UIf4Y79elbcUAAwaHiqGX/iYCVJA55tVB?=
 =?us-ascii?Q?g4XhkD4e1kalL/yxkgrDqjZSGl/5ZgQdLjGn30YSMTcirfrMSuAk5L3d7Sb/?=
 =?us-ascii?Q?2NOftY23snVvQkNhSALrAhLgo2bFteL8bmMY5zhQTjKoT+qUzTkOHq78V9oS?=
 =?us-ascii?Q?SaMDfIkyg7Tr1x9Y0I40zQ5lvP6pvxofuqb6OdtUYJFegbE01ZV/2gE4azPD?=
 =?us-ascii?Q?gcTnh5DXnf+S83qqgvFHOi+fgXTiUezM175ysBbTk+xgI4ExImuhSD/Aj38A?=
 =?us-ascii?Q?x+fxWMHw7lkctFhxLatYeK4nbtE/k7K+I8feNACKlpGpmM6ocaG//o+pUUK+?=
 =?us-ascii?Q?V6l9C50S1QzqJhIfYwr5UCRn+JuZ5vIblgc1rB8EAj37l2DNesC3PWiqTA2n?=
 =?us-ascii?Q?vxA99SSoDRXfA2ccIhglfs5tekjDwEJrHf1egg0dQc2SaZg2x3E5HobFBLYt?=
 =?us-ascii?Q?Lu2nNOqq5Lq3sG8kyuCeA4AdAUTN3IsKb6hjZMtlmLsBajB36J9dtWfnAmGb?=
 =?us-ascii?Q?ctZzwcgEK1D0V4cE7t4rcquOaUuSNRpy26LISo1KTaZ2tOupKbtc8glztgCI?=
 =?us-ascii?Q?r+E0C1KGwN+5V1ZvJ4c4sPqAG9Ps0PXApwPj1bufgw575Hh0xrCXLRzWb3Pw?=
 =?us-ascii?Q?pySuCQWJb/q0iTx0rnESdtrJtqOCmHuP7/5OoyNx1EPQNNFT6lqBo7vN1IFr?=
 =?us-ascii?Q?jkW16Mj3E76MixbxczDQ2LvRC2/rt5QAULdXQJsfovWfbf3QmE34L7V6QyzW?=
 =?us-ascii?Q?B27dqH71BPLGzJy1ZJ5J3ZCdJh+zHzR35WYN7+Pf8SKSDfV73e6bHHTTlWgf?=
 =?us-ascii?Q?pL2Wdb9E94PBfDiVJ+9yt+Vrr2k1v+Q3lhvSLZ9oEVCdiyiWEIaCf/iFeElT?=
 =?us-ascii?Q?+FCLiTkGMNLlQX/cu7xzbi+cMfhyHZlg5FuuA1ItD4UCjsY+ZUI19yui6gKw?=
 =?us-ascii?Q?mCluwFYnOXKV1Zb9k6a6X1NCC5HOtzlcQPqhhoWS5VuPbS9Evvmn0IShVLqA?=
 =?us-ascii?Q?I3gxIvX7GIfKR5VoWUIExwMiwJdjNVFZ3EStwL7wFc2kL+n1dey0CMsrjgN9?=
 =?us-ascii?Q?cZkLVyVIePa+jNpme39TvpHE2uNMPsuvHfSJDYklvv3nVKHsPac/6k12pkBc?=
 =?us-ascii?Q?DbQaU3Ykhdv8R4XeiWGW19Iww0tgmvKTmtXpGUB4S8sdardxv9alqoyNKfma?=
 =?us-ascii?Q?WLvIfdGsVujkj6R6EbEbCLZWtShGH9+O6+RGtEgqKlOIt+nE9Qxzhp6/A6++?=
 =?us-ascii?Q?rg9deoYG/auIec51+b76Q5OGgoClX/NNKWaHHn5bisrpyEo/RELnhyjUcrbI?=
 =?us-ascii?Q?zWhDCOLPCcn/ETNK6KzXiCvacmWasU3gkgtld4DaRhoCM7jeb29hYz4mibAf?=
 =?us-ascii?Q?m04ATnEP9F4jeaIx4skWtc1XyXeoIBtSUTp8Zn7ENLpAAWlxAAS0GGvI966O?=
 =?us-ascii?Q?CNFQw+aDi2lQTBmkqPa3UUx7wD7xaJQ=3D?=
X-Exchange-RoutingPolicyChecked: KyOnHeshE8jywdnBl4GUg1xm8Fb9LyqF+hSWk3OeTUyKQtEWHoLSWo+zz4UvqSh59eZcHU4E7OmzRao3+UKp4mtlILmLY3K4JfjObrGMbD5s7NZn6Q/S6ZOAvqEARePyNfDltw9lDWs5QFu5ru3aFWurYkfl1hz8qIe+jNK9Cbh20q8yunHfF3h4zbeIHwv/7SmWhhFs7krjlHzU0byoOhkly1+hPJws0vwYuYOZ0muHtiYtZUo0GW5CfO7ithnOxzT96OeW/a2IXC6jjjXSab/phEi+vMN06s1w2OR1PTQGTS09+mNejBvNHRmnfBKBenhR94WGu5Jf6aR47EgYeg==
X-MS-Exchange-CrossTenant-Network-Message-Id: e4779c47-085c-4739-39fe-08deee8e41ae
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2026 22:59:49.0056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VkzLZFZNWXyGiQGLiemq9PBDsQdhRpZwHOGZBRas24aLUriadoeeGVIcL50mDjLwjB8U72CuB9ytbP7gndpP1jL7WGra83khPEKONha3FBY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB8896
X-OriginatorOrg: intel.com

On Tue, Jul 21, 2026 at 10:21:32AM -0700, Randy Dunlap wrote:
> Add one missing kernel-doc description and drop one that shouldn't be
> here in order to avoid kernel-doc warnings:
> 
> Warning: ./drivers/nvdimm/btt.h:232 struct member 'nd_region' not described in 'btt'
> Warning: ./drivers/nvdimm/btt.h:232 Excess struct member 'lanes' description in 'btt'
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Thanks, applied:
https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git/patch/?id=1c454cec28d6ef9f04c32b10d268e699e09573a4
