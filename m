Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=192.198.163.12
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1792793102;
	b=zPteZ6D7dX+fT8KpqlDMoMUIV6cAHB4Cm20gaECjRjiB3IYxhkGup7muuhh1X4cxtmu1
	 HikL+7oZZ5MdFtza1NT1bCkti51LkEL0kDboGkIfXA55Voo5lQ88yMivC58qjEwi5O88d
	 7hqHZqDvc1vCndaArAeC7Ot/im4IWYOlipH6AHNF/ugw0CKFIgDnY9uZsRvx/NDuph+jC
	 JVDYSFvGdXlRPDSjueE6pa8N9y8eAE8nZ+39ptzwX3vh/4rXNahmN3wz/HE+0jpc+zW/m
	 nQ8HQxDm9/zWtLpicKrssb9moKP2PCsK3HSL6+tp5JJkh5tOSDHdfrcEfq1zoYtkaGA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792793102;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:Received:Received:Date:From:To:CC:Subject:Message-ID:
	 References:Content-Type:Content-Disposition:In-Reply-To:
	 X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=GCbWmzio+2sWVqXkPbnYObHOoYaVFp0kSlldnI6VdLE=;
	b=4qDnGUPGw65ujsFDFisWWYlKyfb98jr8tz2qxUEmS4/r3pNLoyMEoAFPHJJGWE4nLCr4
	 r3YJdxAoV1Xhf/vx0XwtlXDH2vlb4u5N4K2oMgOerXZNMEa00UcVI2+vhrrjPtwfsCP8S
	 ggm0+xpGltPTFy2dGXnHTGJirMlgn22wzj1NKIsFwLDfeR0RwuZlk4wkQsPSLMKJ+Vmj6
	 Ncae8VvqLg/8y/Bou4zlMOdoGDx2iidAmdqAcJc2MbuGAWZqtdj5MWHzvEgqJAnMCKXzc
	 aOwpu/Q+/gBsfinBZQnrvKhprgNBwNvsZVGGOufC8CyWxdnToe0vXDHhJNn/h9xgkbg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=g1wvc828;
	arc=fail smtp.remote-ip=192.198.163.12
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3B0606A32A
	for <nvdimm@lists.linux.dev>; Fri, 23 Oct 2026 22:05:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2E3B0606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=g1wvc828
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792793102; x=1824329102;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=2b1CLGKHjPGXTBuuxTvAv2kqmLuleYc9wZKt+EtzFPM=;
  b=g1wvc828OATL246uRJvRfT158e67ngD5prA66SlqHBsLndSoO/wUDpgr
   lXe03JX4NX/hja6h6oeSbEclydRm7Ul+VlV/x/Oa83ydV20uU3mkbDlJU
   hkMnz84bpF/btvffDTyNCXwr0JENgLe+Nw2AGf6du6cU5acbgTCvYDNtF
   boUZ2L192LJY7LoOyRiIf3ao/MA/jQJ0pchpCoe/1RkySm1ROUpiLHL9O
   hGtoawFCV1JuCGnUsepf+DIfFqN7q2XzCinaN4PThZGbzw6+DtiS0T4BS
   zyGFIkvwxWyFyPFZ54Pi9UgN9hOLDfs8q8s6pqmBP0BRL9073WRnOEKje
   A==;
X-CSE-ConnectionGUID: Z+vJAODJSzWeVa3XQHMZLA==
X-CSE-MsgGUID: wYTrIw3RQWWwGuUPQ44L+g==
X-IronPort-AV: E=McAfee;i="6800,10657,11944"; a="1460870"
X-IronPort-AV: E=Sophos;i="6.27,175,1787036400"; 
   d="scan'208";a="1460870"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2026 15:05:00 -0700
X-CSE-ConnectionGUID: A5m7hhevRIy46mu8ZPaOEQ==
X-CSE-MsgGUID: wqzAlP9tRKmK6HAMBvemyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,175,1787036400"; 
   d="scan'208";a="4136994"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2026 15:04:56 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 23 Oct 2026 15:04:56 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Fri, 23 Oct 2026 15:04:56 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.68) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 23 Oct 2026 15:04:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f5hwpsmqbpmxoG656vlmi5OUjMMNu2WLi+Y646U2Kckc77EJsh3yxkHwFZ3U49asBkqq1Gy7v8v3RwBMhD1MPSPT4fo7DDvIOfwNkc9U/rDP6uWqSPG9Jc6Wu/ktaaG+CZfT2m+CIyr+118E4ODmKXeHNMf8noGnFKk5KhHIOUVKX2gdTlOJrkF31Gwyu6PLlwn7vyCG2NVGE+BvR0j/BT+F/VMIYnmUS2GY9voal1BZulfpqyXYqsSLizGBOjRfnqBQwtvEygMzYpBTAtlepVtPMCKDmNSh2s/B5zyQiSt8Wyl2PgtjgJFhxYnSf07nKNrOEWrgcxGQLPb6ZVfgyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GCbWmzio+2sWVqXkPbnYObHOoYaVFp0kSlldnI6VdLE=;
 b=ZAMNPHAo2WlqGbSdCuF6IyZ+9GLXey4TjQu6RPLLnwoOkPZJ1jiCRqL29oCHhPlNY2IMfIphp6MZuatXeLp8ZTyMBkk/kJGAeRKJMJu7U9tR+copJzaSvxtExfC7sjGLl0A9BrsajmXcn6zxUSPDoZn7IwBXKkukZi/9RYoSog89Kn6rPbC/nRoFyus16nlTwVvCPa7T6GqEQ/qgBVv4Ui6BLT1NbJ3xX38AmO7KC+aTCdP6/JBQeTPcNF7+sxQee6+4k5ml1+xV0Vp8RZdreEuhvSihciocqL01I9sTJxCoO7iYtn4Plngp0FhKHdQd3pSEXcqbPTZgsJLLCdDoSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by CO1PR11MB4866.namprd11.prod.outlook.com (2603:10b6:303:91::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.16; Fri, 23 Oct
 2026 22:04:52 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0546.017; Fri, 23 Oct 2026
 22:04:51 +0000
Date: Fri, 23 Oct 2026 15:04:47 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Richard Cheng <icheng@nvidia.com>
CC: <dave@stgolabs.net>, <jic23@kernel.org>, <dave.jiang@intel.com>,
	<vishal.l.verma@intel.com>, <djbw@kernel.org>, <danwilliams@nvidia.com>,
	<nvdimm@lists.linux.dev>, <iweiny@kernel.org>, <ming.li@zohomail.com>,
	<kobak@nvidia.com>, <kaihengf@nvidia.com>, <kees@kernel.org>,
	<newtonl@nvidia.com>, <kristinc@nvidia.com>, <mochs@nvidia.com>,
	<linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [ndctl PATCH RESEND] test/cxl-mbox: Regression test for huge
 CXL_MEM_SEND_COMMAND out.size
Message-ID: <atvZ_4S4OnYijGyw@aschofie-mobl2.lan>
References: <20260624150158.55264-1-icheng@nvidia.com>
 <aqiXdEIiMb3I9w-3@aschofie-mobl2.lan>
 <arJDl7DmQJzQQu9-@MWDK4CY14F>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <arJDl7DmQJzQQu9-@MWDK4CY14F>
X-ClientProxiedBy: MW4PR04CA0345.namprd04.prod.outlook.com
 (2603:10b6:303:8a::20) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|CO1PR11MB4866:EE_
X-MS-Office365-Filtering-Correlation-Id: f2fa76e8-287d-4209-0533-08df3151a964
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|23010399003|11063799006|4143699003|22082099003|261022105027099003|261022075727099003|18002099003|10067099003|261021121427099003|56012099006|261009223027099003|3023799007|261022113327099003;
X-Microsoft-Antispam-Message-Info: bgGcQ8HFj4UI1fOoLYJuYA4z7hVD8Tvesvf3NSIfj6DVQX1yViktzy5RYi1uxM+ojbjEYIk95n90o0ZQY9s4DP2qmB9pRiAzFGse9VPOL4Qlx1CnuI9ZyEGmkrWWMvsXT/YCJJ0hIOcKpP63NexTV/8HHW+MdlsP5R35aY6Q+HTnZ3WbZ2nm4i3gJ2LuFRU8jDolksxRzUJOfzAlE9NU0KUfVvI7mGXeuBG7l1cBIDmPOHg/nVjryh2aSe74b8Y8/NZw8IiUaZPS0wjUc1SJkIyPXKcMRP8LBxDSRv/QqzpNsmGYR/uyb1GNvHEKRmFahSbeoROBaDzy1E/JXtvXWea2KkpBbOH8nBCFPuwSAG/jjlPMMYGNOXGFRfIj5R/wnys8UWmXjCTBlNDqT/RKErR7yzvD9zkkxY5/VPwW4t9QDyWYOFZc+vSJRDqC8k0Nd6djzx5kdZ5jqGRuiwtnEELKoq1NOHzeN7aJO6E7lOpfg+2hmUyJTgXSfGjsnk97nUhNuXG66WgkiiQyo3h7RdOU8iI/P52NoDNExnbzL2sATuyauggxmV6YU7nSeGw5DKe4qctQnlB9fwTTRC+eU01kA9DdauvQiv08KpyV1WC1drbqqFpa0zkrsQs2HaMb1SvqQEeP6FFTSmOxwFJ/1+1h2u7zSAiYYb656VyWiOo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(23010399003)(11063799006)(4143699003)(22082099003)(261022105027099003)(261022075727099003)(18002099003)(10067099003)(261021121427099003)(56012099006)(261009223027099003)(3023799007)(261022113327099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AzD8f9kcr9PmI3I+GwlK+HF3C3WXj54PaaoAp//Wf7IbBjHR8sQCuY01ckkH?=
 =?us-ascii?Q?eJNNraqPw+c4kdOdUtjq7cvAa6nOy5+/s+H3DkSFvmYYD5aUJc4+bWeZGscv?=
 =?us-ascii?Q?lMq++dGI0Gggf9yPft5fc/PEaAaoxR/mziJdqxuhPkalE+KP9zYaDRRUkbMm?=
 =?us-ascii?Q?GliSH5pP78s2XNy91AhhFsTFxFUi/u1sODPh88V8cvJ6b+W5jVpMM3o9tN7A?=
 =?us-ascii?Q?H2zjdRYS9O9z/9PoAa7xsOhZFI/gpFySLKUY4P/47w2klU/+R/lM+Fvre3Pn?=
 =?us-ascii?Q?UwsnlyBY6mCaVetKLdjbOBRHGicHm6eG7PmW2o2ME+WGrOBulkVDpsj48KwG?=
 =?us-ascii?Q?ZhsDHnTKTJ0vsojmTeq5X37KPpEngJyaxH36Pnn+/mnN6ptqgwzl0g2VuLU9?=
 =?us-ascii?Q?a3g6YDap0O/VqDYXXKm36yZ16XdX07jugisAX+osbqnaDIB9pJ6y18exd/5S?=
 =?us-ascii?Q?XHzAn9pU0LFy8fDH9ulH9KoVyKf71udBthsFYwLuoUTYJ8qGl9LhQcvuuUCw?=
 =?us-ascii?Q?/NdZN7FhXs/zhB8bBe3P9+56gSUO9HuPnh/5hwUov3eQQn+fOgvbIw6fuPgb?=
 =?us-ascii?Q?JCQHQW2zLNCKMk56m+dgCu8T2khWZy0mbli7+b/aQZtUb6iVMrSKGlMExOz0?=
 =?us-ascii?Q?3wK/xv07668fI9AtK6Uotd/iPhHa5glyjHl43CiQKvRtnFIY1k/c7YMeKqHj?=
 =?us-ascii?Q?ImfX5P4t2s5Aiov1G83/uHY75prDf9tGpXdToyxrRPs+vyTuyMWIyed806wb?=
 =?us-ascii?Q?vdzM60JukvPj5Yi1Uzf5zSrF3PTWzj2sGyCEkY/hh0rL5tbULJ7NtQ4p4QQ+?=
 =?us-ascii?Q?wMu2TUx75r/l5hOYP+q+BFKBp4mZrCX/LFPVHBZguZ+WitT0I4iFJmlc5tB2?=
 =?us-ascii?Q?RvI5vCDGcvik4Bp2f1te9YRVG9IwzV0isiYWlVAJrwDX5DC8Mn82XBVXKxYB?=
 =?us-ascii?Q?RZz3jfdG4wADlbNWk4E9COtH6LXqh9r12RaY3kAnbzLt1ibFXcpXxeT1HIy3?=
 =?us-ascii?Q?s6SnsqGB8AGVI80LyHNEGu4fLOINKuv7uutIcV1UXknAu8+/+ZpWVqOXx49f?=
 =?us-ascii?Q?XTDoC04AdP3YsTirDSwDltHzoXwY/JYQvot6aUnogaX+HqUrqUFzNLky0KS8?=
 =?us-ascii?Q?1QSeAr0aaRJaq/b0EaAABRegvTJvpoYZtyKlmzQc+riZ5IuKmuQuHQvERgzN?=
 =?us-ascii?Q?MRgacVDNSTeRCl0Y61dbf//eoFFc+uydImKYiQtgtjcLUnQdjag4bY+uE7mL?=
 =?us-ascii?Q?qS+gtF8Nu74U+3YAN1oR5hW+8VsyGs/OTX7nZA3zoXXvxD0Q7ve/hC8XmAFU?=
 =?us-ascii?Q?fiFYNinWdWiJOZxny3oX/hHjZOPyzVbeMUlZffqeE0dLE9qfq6g2RWEjiXd6?=
 =?us-ascii?Q?9lI/4CPW1p5OZbawn2r/G1T66vcYiEiXk6MLGfxeAKzS/bd7WFajDMl9FOA1?=
 =?us-ascii?Q?ShDOS2+QapbdGwF3p8hgZa0dPFSBWZDTxyv3wFVCe92EHje4gbbcXlzGpFyW?=
 =?us-ascii?Q?w6FiDoAUMyLsHMpHBZ1Nb5Nm6xsYu5nxhX085vGSeyWhj66Vm3aIMNix3trm?=
 =?us-ascii?Q?VxoU6DdhE3wbsK7HhNTHhgqy5Oy2dRD+D8TUCk+BHWlj6rS55+LMp/5bf9WZ?=
 =?us-ascii?Q?iNM1LPnJNgQaIjVrZIuL1+PIMfye7FCRXVJcnZXXU7YIIwG4dibmlXAADBXs?=
 =?us-ascii?Q?IWNu0daVokCOUOpuL0SKmX9zd3qqQ7hOKxpyMiDikaue8NmcghCg/qK6efru?=
 =?us-ascii?Q?jFq3GLTQsD6iU/T3eEx9cUID+6laECg=3D?=
X-Exchange-RoutingPolicyChecked: t0mKWR8loP0IacGRAg2ANOC0HhsFsbAKvBYuZCu7RZ0yMqptQ8rwlZdmlGA/qcciBdaDObpDSSAPVk/oPirCKDzwXohLuv+7aGIRl/lArei6jjkuVJ2aAN+cGneHFBDEy8yqadRF3Cw+4f5uPSIo2NZhhX44gBQiJqqFMci32wu2iYSpLZD5d5ue7ef/0mfGxljSEJYgMd6zHoZhEgeyguHkcewcbg/S531kIKROT6Oa1XkLURZBzJ40Y9K5haBl5GL4NMv1Qdcm1oHDyBs6I4MiEX7tkdsYDi8UkjRfA/fq7SyNNVCu9M1nORpxO/8GSiBoVLFcu/sYGvPPl6S54g==
X-MS-Exchange-CrossTenant-Network-Message-Id: f2fa76e8-287d-4209-0533-08df3151a964
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2026 22:04:51.7107
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wjAJcT8kFVQSCuAJcVNqADHj7m+N2moILEN2kR9CKmIfXZSFAOSul+bXwQh2in18Q3YmZSBvjvt2yosz8VLtiM28g/tPJjB8X0YImdSMnf4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4866
X-OriginatorOrg: intel.com

On Tue, Sep 22, 2026 at 05:01:58PM +0800, Richard Cheng wrote:
> On Mon, Sep 14, 2026 at 05:55:16PM +0800, Alison Schofield wrote:
> > On Wed, Jun 24, 2026 at 11:01:58PM +0800, Richard Cheng wrote:
> > > Implement a regression test for unbounded kvzalloc() in the kernel's
> > > cxl_mbox_cmd_ctor(), which a CXL_MEM_SEND_COMMAND with an out.size
> > > greater than INT_MAX could drive into a size > INT_MAX kvmalloc() WARN.
> > > 
> > > libcxl's cxl_cmd_set_output_payload() rejects an out.size larger than
> > > the mailbox payload_max, so the test crafts a raw struct
> > > cxl_send_command and issues the CXL_MEM_SEND_COMMAND ioctl directly
> > > against the cxl_test mock memdev.
> > > 
> > > The test is for a kernel bug fix [1].
> > 
> > Hi Richard,
> > 
> > I appreciate the new test and sorry it got buried in the backlog. I'm
> > appending a diff that I have tested with in my pending branch. If you
> > ACK this diff, then I'll just apply with that. If you want to change
> > anything else, then send a v2.
> > 
> > My changes are:
> > - wire the test into the meson environment
> > - update the shell script to be like others, including using check_dmesg
> >   intead of reading tainted.
> > - NO changes to your cxl-mbox.c
> > 
> > 
> > -- Alison
> > 
> > 
> > diff --git a/test/cxl-mbox.sh b/test/cxl-mbox.sh
> > index 67fecf5a3f46..1b9f95fc7836 100755
> > --- a/test/cxl-mbox.sh
> > +++ b/test/cxl-mbox.sh
> > @@ -2,33 +2,25 @@
> >  # SPDX-License-Identifier: GPL-2.0
> >  # Copyright (C) 2026 Nvidia Corporation. All rights reserved.
> > 
> > -. $(dirname "$0")/common
> > +. "$(dirname "$0")"/common
> > 
> >  BIN="$TEST_PATH"/cxl-mbox
> >  rc=77
> >  # 237 is -ENODEV
> >  ERR_NODEV=237
> > -# TAINT_WARN is bit 9
> > -TAINT_WARN=512
> > 
> >  trap 'err $LINENO' ERR
> > 
> > -modprobe -r cxl_test 2>/dev/null
> > +modprobe -r cxl_test
> >  modprobe cxl_test
> > -# cxl_test alone does not autoload the mock memdev module on this box
> > -modprobe cxl_mock_mem
> > 
> >  main()
> >  {
> >         test -x "$BIN" || do_skip "no CXL mailbox test"
> > 
> > -       t0=$(cat /proc/sys/kernel/tainted)
> > -
> >         rc=0
> >         "$BIN" || rc=$?
> > 
> > -       t1=$(cat /proc/sys/kernel/tainted)
> > -
> >         echo "status: $rc"
> >         if [ "$rc" -eq "$ERR_NODEV" ]; then
> >                 do_skip "no cxl_test memdev"
> > @@ -36,9 +28,8 @@ main()
> >                 echo "fail: $LINENO" && exit 1
> >         fi
> > 
> > -       if (( (t1 & TAINT_WARN) && !(t0 & TAINT_WARN) )); then
> > -               echo "fail: $LINENO kernel WARN taint (bit 9) set" && exit 1
> > -       fi
> > +       rc=1
> > +       check_dmesg "$LINENO"
> > 
> >         _cxl_cleanup
> >  }
> > diff --git a/test/meson.build b/test/meson.build
> > index 07c8618cbc6e..69c22c579b02 100644
> > --- a/test/meson.build
> > +++ b/test/meson.build
> > @@ -139,6 +139,11 @@ revoke_devmem = executable('revoke_devmem', testcore + [
> > 
> >  mmap = executable('mmap', 'mmap.c',)
> > 
> > +cxl_mbox = executable('cxl-mbox', 'cxl-mbox.c',
> > +  dependencies : libcxl_deps,
> > +  include_directories : root_inc,
> > +)
> > +
> >  create = find_program('create.sh')
> >  clear = find_program('clear.sh')
> >  pmem_errors = find_program('pmem-errors.sh')
> > @@ -173,6 +178,7 @@ cxl_elc = find_program('cxl-elc.sh')
> >  cxl_dax_hmem = find_program('cxl-dax-hmem.sh')
> >  cxl_region_replay = find_program('cxl-region-replay.sh')
> >  cxl_type2 = find_program('cxl-type2.sh')
> > +cxl_mbox_sh = find_program('cxl-mbox.sh')
> > 
> >  tests = [
> >    [ 'libndctl',               libndctl,                  'ndctl' ],
> > @@ -211,6 +217,7 @@ tests = [
> >    [ 'cxl-dax-hmem.sh',        cxl_dax_hmem,       'cxl'   ],
> >    [ 'cxl-region-replay.sh',   cxl_region_replay,  'cxl'   ],
> >    [ 'cxl-type2.sh',           cxl_type2,          'cxl'   ],
> > +  [ 'cxl-mbox.sh',            cxl_mbox_sh,        'cxl'   ],
> >  ]
> > 
> >  if get_option('destructive').enabled()
> > @@ -292,6 +299,7 @@ tests_deps = [
> >    daxdev_errors,
> >    dax_dev,
> >    mmap,
> > +  cxl_mbox,
> >  ]
> > 
> >  if get_option('fwctl').enabled()
> > 
> >
> 
> Hi Alison,
> 
> Thanks for your kindly review and the modification.
> 
> Acked-by: Richard Cheng <icheng@nvidia.com>
> 
> Best regards,
> Richard Cheng.

Applied to pending for NDCTL v86
https://github.com/pmem/ndctl/commit/ef4a5ae264e0

snip

