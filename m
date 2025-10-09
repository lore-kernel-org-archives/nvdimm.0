Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EBA5285CAC
	for <nvdimm@lists.linux.dev>; Thu,  9 Oct 2025 22:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760048624; cv=fail; b=eBcakL0MpENNORTXmvXISP5CoZkS9Nl6OoUoOwFv1iyz3Esjn9wY7d/aCRYR5xYaOWw5c35Ubsrx3vWKSm1XGLxsgb167ofEiY3gXDdtjKAUcRLGeTQvo3wKYcHTN8kEp0vRQH2RhlHiL/eo3LJsjGwWkJ6uv80vIfD7QlBADc8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760048624; c=relaxed/simple;
	bh=gbi8Jt3je6m+ussw0CyjMpKsEk3XtSlMfpXFZ+cNDY4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=NYL8UK9VBJBjyYlf5AcsvsR/ix8UlGEDglDEZTfTEeGhABLnZW+AIu1EuGV+JLC2e+2AYrZkz+3ZbHpqiL+pMhWu7Guz2WaIDNhCw4D/lbxUUKigpdZxKEbk5cJ7PYF3bdm9N681TDBIpa8GBQzF7zf7j5MzjJGZwWjQ9es6dyo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IeefUdcH; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IeefUdcH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760048622; x=1791584622;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=gbi8Jt3je6m+ussw0CyjMpKsEk3XtSlMfpXFZ+cNDY4=;
  b=IeefUdcHKmsjR79Ds1bpq1UxmWPEQSyCXIIRdNwWBwzR5X3YAFmyK3lz
   N2+JNw4t0gVuOg2RnLbANy/F14VkbxeRkyH6B1xhz6tYu9OzTpqOjaJ0p
   nVIJpg0HSJW84MLquQ2/I4SJK05qruO9Y95BkUzmPFRe5XVP2d60k5q03
   owS86CtOH116aw1qsU3wtmAV9/+RyREGM2IloM/LjE4Y8cFlC5C78fVOB
   DN3dAN1xKKPWj6Mimm7WhxzdZ0b2zu9m+AD3NEJqrn8CAsE6g7xsyXwrr
   /Q63TsJs5n5z9QBFEpDamBKhyyYToQ4vkh2mWL9+jOUANn1EAcvGiloOM
   w==;
X-CSE-ConnectionGUID: lcEY1YAfSE+wQ0trjYs4Iw==
X-CSE-MsgGUID: 2eGWw2p1RCSDVORM/l+1Xg==
X-IronPort-AV: E=McAfee;i="6800,10657,11577"; a="62426619"
X-IronPort-AV: E=Sophos;i="6.19,217,1754982000"; 
   d="scan'208";a="62426619"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2025 15:23:42 -0700
X-CSE-ConnectionGUID: jy0c5IkSQqmLQ3nNJ1sw8Q==
X-CSE-MsgGUID: AJXOv8mySBSviYmf43qSgA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,217,1754982000"; 
   d="scan'208";a="186090954"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2025 15:23:41 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 9 Oct 2025 15:23:40 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 9 Oct 2025 15:23:40 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.66) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 9 Oct 2025 15:23:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BMeM9IQPFkJdWPH4Vje6Jl/vOY39c8qkHi0mspFPbQQBDXIRHAO2KFNLIuyGHb2MjZzkR4t9X/vDIw7UMjfFU49ORjhQPGP68Kpmc4GIQbEo1h3+3awyejZsT8pjHZoTM5lxr7TirIB/9H6tW+6qm2KkEpz75kVDe3h93QpSoCNI20+zBmbMQQULG0py2Wr/kdHcyyDodajVTN3+yS7mxYn8RUErVBvWSw33Obs5tKCfwbtcMLXNWlbx7qbX8ZQOdOO76r5RXnW2WqqMKleUwUsbZMCK9mightlBnB6IoyKMQQOuP7tqgTywlALU8WMst0NJvXrQIBPgsWQag2dHVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FSpCgl/aumqP7FGj9eLLoKzNzxRGXce+9UuwR8SS1bI=;
 b=cqjL4CGvjRgdAqgTtYsVgX28ZAPnmcA4we3ehbeMMcCNMGgbf30qfRhaD9paWLZv1HfQqNyHOT6CrIOk7bxNpIWmQTTCDoV1ib7f7fFTtvUaCWHvW9Dtjfb9aY++zLLIiYXzIc8VWrgIZLdQASJM9Fe5eXRxnZu8aYp6dFxD0bVoivp2xwE563r/5/sPRynFPd7y3l4dUU08+ReDp/fn2sbRCi3Y6HWNAMz68oUXOVQXZAinhIIi6rs8JjRNoo33sBuTWIXAn/jGuaoTSQa2w3qrj5MadjE5VhIYS2UB7pz61yu9rNrvdru3y4U46EUFNdActFLGS6ty99SQyJn7GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by CY8PR11MB6987.namprd11.prod.outlook.com (2603:10b6:930:55::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.10; Thu, 9 Oct
 2025 22:23:38 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee%7]) with mapi id 15.20.9182.015; Thu, 9 Oct 2025
 22:23:38 +0000
Date: Thu, 9 Oct 2025 15:23:35 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
CC: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH] README.md: exclude unsupported distros from
 Repology badge
Message-ID: <aOg159pZmMkUsYiD@aschofie-mobl2.lan>
References: <20251001192940.406889-1-alison.schofield@intel.com>
 <ab8bd3c22f4cd0de61b676a466bae209ad9ab5a8.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ab8bd3c22f4cd0de61b676a466bae209ad9ab5a8.camel@intel.com>
X-ClientProxiedBy: BYAPR02CA0016.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::29) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|CY8PR11MB6987:EE_
X-MS-Office365-Filtering-Correlation-Id: b1a34a1d-62b1-426f-b644-08de07827e95
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Ba0fyHevXLGlPGC3srVwGVgCdfKCqGBvMlmmlisTkBcpfe+MqdvPObfO0V8n?=
 =?us-ascii?Q?dgb5VqvUMM/KA/Sv6y0a/aG0GyBhqKYdXq4inYFKO4UkSHqLavYabZSEM5AR?=
 =?us-ascii?Q?WzlKxPINsoarpJgAi3CClsoDLCJsLL2UwLwWbZZhjus0tYM1ktdnSN1P3HIr?=
 =?us-ascii?Q?v67nyAAW4+Zt5lziRhdpROgC5ujTzsGKS5lSkrfa7mLqNTLaYV7XfqnaZSw4?=
 =?us-ascii?Q?fFgnPEUOjBPbE1xec9KjAWw5PAnGTM3jHGDPUMh6Eokbhm3OvN66ka7q26c9?=
 =?us-ascii?Q?CtR/YA1dlO2frZrvncarHy4ukdybAIKyY67gSTE9u+m+snxJ4ixj2Wvcm4ao?=
 =?us-ascii?Q?dD9ViZ8e24RGt7iysQ9+8Afn9qR7DNNJpeOWaS94tI4KvLSx3KxE8jYr47ei?=
 =?us-ascii?Q?0Dz2UhvIRLZKT3HUyBRXT8uLaJZWiDsD4o6BfWx4nCMu/0762vv9HHz2azvZ?=
 =?us-ascii?Q?3zTLVo/4Z+UaKW0H67BqY3zzCmbhfE7x5JZYC3SDGDWZcqcThnaECH3Cq7GR?=
 =?us-ascii?Q?/t5Vv4PRg2lyCSfzkwIuqtBtxoMTsSGfMo1UFGXlkHXRoV/CuJTdKizF+2Sh?=
 =?us-ascii?Q?YofV53aaFPtrzRJ4ZTchw/6839RaY8t4+v7nqJoa/gFoh7wln6w17SsOnp9I?=
 =?us-ascii?Q?S+JzulhiOn75ChnyFcptNritG8JIGJ71ZHzOFthFA8NgXLWsb0iR1Yd/EYUQ?=
 =?us-ascii?Q?gdDEXzWOVjlZsiLrZl6SoYHHWHU5WHt065XGZT6Jtb8cJA0jFQfZsgeXDg+w?=
 =?us-ascii?Q?4PPZthL3//cXBvWhzkV4cS5ciUEKEUvZsYHiokj60AIl/P9zaqWcbfOJCJxs?=
 =?us-ascii?Q?KJaKCXTlueW5rNfl3FaXGV4HJYKoNcUVpZFvg9Ok82gsQhf8m0+oM3Bwz+pD?=
 =?us-ascii?Q?2D9OObLavrfRICpZ9H9CBPkrq+tAwWGzRg8hov45FiyhHjll0bypOlvvm36Y?=
 =?us-ascii?Q?Swfh2f+xeoDY/nl5NxKNo6Obd4JCrMfhQ1Gp1bLaGzObyv2s+qOz7i8nWA4C?=
 =?us-ascii?Q?QyZw1rKUzzqqV3DcNEfKLim1XZpHlTtDQx0185kyh26Ik+N3fqJEmxRkA48H?=
 =?us-ascii?Q?xK7S5Mruja5PvzNaTP8uERU1GUTKWoFvk6ex7xpS7Z7b+hdxYTZkqHogfsKw?=
 =?us-ascii?Q?zRc8cc8qOYD8XQ0YgnJX4Mz9FHq8/tvAn0HcHofoB8U7Ra/zR3Z5Sbh/ltOF?=
 =?us-ascii?Q?Wj8SnDGBRR75hqR3nI6muikix8EMxslsUdOk/9CT/4HfvYuKBFIBe+/AVQ2a?=
 =?us-ascii?Q?y/s/s96ycl9BEp3F46HzABn5hbMg4dGjf+wAsujjh+lUJ1+nygQ69VYSF4sf?=
 =?us-ascii?Q?V1RspUQd/eJJ5vVvSH7ZB2Qs7vJxAr9HplJk6ne0WTXBwUK/prQ8m2ub3ACk?=
 =?us-ascii?Q?avRQamqdXngHGagQu7QruCWH60E9ayL1804vgqbODPhX7fYewA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?m560z3l4d5NoCXF7AJLllBn6n88+MWCBY8tMCY/1yWWi32DyXWOO+6BBks8D?=
 =?us-ascii?Q?AzZWci2LJw/1s4j5Mu1kpLfpBlUrQdRo++SHSSCFRClOrxm0dwo9nNYOZrA0?=
 =?us-ascii?Q?dCzSkJ/aX0oWjg6/wxdboxVJi3qlL61iEOlOp7uPJvN7RjMwf5rhRMXr01L4?=
 =?us-ascii?Q?8xxaXHMQjAa95QqDr6nOUHvZHXffRcwkPSnBoBhBLEIOvab8Z158dfZ1uopL?=
 =?us-ascii?Q?CKCsGDdhvW5czaHPbfw2d0qmYu28I/KNIvRSs8QnZmeg/KD3kDO7isfIBOST?=
 =?us-ascii?Q?3gLSEUVYofF37wCZzQjvviuOKw/OFs/apcYuMboKdlgmrOHkmLEEyNGxIr70?=
 =?us-ascii?Q?4TS4UejERtzQcvZThbhMReWh32Dl6yDGcDriI6u9RVRotYA7JU3CJS2Y/ImG?=
 =?us-ascii?Q?qn/pdUm0g5jz7q53UBkLZAJPxQXqoE9VHwtVMvfPRcpJRIJYcVt/o5I945mk?=
 =?us-ascii?Q?sOuTWty4P7IW1Jj0l8Cki8N/QZno2NTqrNFxF9us1NFtxx5s971Rdk6sD8TR?=
 =?us-ascii?Q?E1fbHNzAyK8hn40/7LNW0ku3J5Ablum/IJWPcwXC04bbmJc2LBjUMpgqD9e2?=
 =?us-ascii?Q?hdUx0FPExE7qmkjT4CCvai7u+4SF02BL1KAQ62R9Fkqx/if0C/jtSnofenmW?=
 =?us-ascii?Q?vYUdGottIdzkgQsNN93YOxiaRoTjOtn9tx8VwOTomFcFyf07FxJk4gEIgQNW?=
 =?us-ascii?Q?BrcSApqr1HPfGMuMOzu0gDx6MU6xQnbUvCc8V8NG91J7Y0b+jbKMeVGKqgja?=
 =?us-ascii?Q?BGO7dBZTQbmjMJktClQ3rzK9li5F1Z+jARHqOO0LTNnr6l3hnALqnRrKTrAM?=
 =?us-ascii?Q?NCZ4Tes7w3o/iu/2AwbzfykvELYH/ozHTmyJ+Zr1ovDOF/NAOz2cAxPeBgVb?=
 =?us-ascii?Q?iVZvvLDzKnKNt6urcj3SaS7dggIZTaUsmsU2zvRQ0xOUPB+CxwseozcNFx7P?=
 =?us-ascii?Q?T0a7kbu/tr7ETFFTcE67X1LCEL798PrUqjml6zPgpn8elyic1mwKBJRYsO9m?=
 =?us-ascii?Q?gB3pd8VlVyqSmxo7R3sWB7C1idP/Zhs6cNo4thSqOrq5cAu/a9Pmn8+ocNBb?=
 =?us-ascii?Q?GhHh/b8hQ/EFwdVmpPf3T1e4Bu+i12eX5qVbuw+skTms6Rv/dAvoupVJiM8P?=
 =?us-ascii?Q?Hu9ltaaHcILJJrur4vPhkIbf8mDxO5v33UiF+7G81/vLEwoaE4D3jjILhosy?=
 =?us-ascii?Q?29LJ9RwyXAauiZRgt8KqgCnWve5rKS87Ovs4f/UdrWwK9Gz34oPU7xBAXnBa?=
 =?us-ascii?Q?11NdWxNNGm8xb5ZMvCDxgiYqExPXQloHCDhx2PkjZX5oZv3J+n72OTZOpB1V?=
 =?us-ascii?Q?1EUxmOXcEyZEoat7DPyUqoUQmMybQ7JvDhXXn8ur3KnhHkHk+pMGOhwkin6k?=
 =?us-ascii?Q?hsmK5IH6a1pKDlIOVtPwC16gvlGx2H7AykVu5F25U1Ru/ZZO4fQMJHpldSj2?=
 =?us-ascii?Q?3QCRoa4vfneIhfVvpexld3Bh8+YR/h+B/YAZB0z0w+y68LXngh+6rM6SkMCf?=
 =?us-ascii?Q?huPpq+Wx03F+wCZWsuHNo8F589tPt0rrolqVHpL8QCCM3VhdGiS02L6ZbfjX?=
 =?us-ascii?Q?Y1ZzhfFyQjPeQxK/T1tYnZgYEjhpqlmTruv3SjZJPrd39IMUs+twgRy+r0Oi?=
 =?us-ascii?Q?tQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b1a34a1d-62b1-426f-b644-08de07827e95
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2025 22:23:38.5490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y/6DXjkyTgV5ArDLd74HXF9uQq0dvujR9pNBMmsjaZofrqR1+ojlCDFbZiiGCnBWPybptnVQFBXaFg8EcoYaExF30NuZ36CpsrkTTuL501s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6987
X-OriginatorOrg: intel.com

On Thu, Oct 09, 2025 at 02:56:20PM -0700, Vishal Verma wrote:
> On Wed, 2025-10-01 at 12:29 -0700, Alison Schofield wrote:
> > The repology.org badge includes thirty-seven repos that are obsolete
> > or no longer maintained. Switch to the exclude_unsupported variant to
> > make the packaging status more relevant and easier to read.
> > 
> > The full list remains available on the Repology project page[1] for
> > those interested in historical packaging data.
> > 
> > [1] https://repology.org/project/ndctl/versions
> > 
> > Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> 
> Looks good,
> Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>

Thanks!
Applied to pending https://github.com/pmem/ndctl/commit/38f04b0

