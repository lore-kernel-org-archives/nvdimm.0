Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=198.175.65.17
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793919550;
	b=wNVLGuiaBGY1ANZewWGAhueBTracaUPWyr8NiOiDt6u8hV5BT/mEQb/nG718GoxEMJPw
	 /KbRwVomL7v2P4/KqKEB3ePeAwpNuilgiM5g9W0771wKNhvkiw9TNTzNXPpr5HSphq8RU
	 g3eFTono+GPsO6Z/bXul/KsuN7pxNA6PJp4tkT1AiuhlPF3U+wjbfgxKhillOwNjuquzN
	 o8xn8MdIlvLCdQAAhmuP7djqPrC5Nk/ep+r2InPeZ33Ue4hCB72SRHg91Pv9oItd2oKMa
	 MRo28daKw/mi+PJBbIfzrmpBdMMitqkKPN8yishudldmyeFxsyDvoH4cVvF7vx3SvCQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793919550;
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
	bh=CzIbM5cd5zfHPfsEq8RGVqvuB+L/B19V70kw/qtaukU=;
	b=wgI+tR+eBIBnbM8qQBW6hvhRzHig4ni1G7K98k5GW/YmL05fGK4/ldQELh6l+0hU7HEE
	 f0anJoHBNg+rbb5QHQHfiOuESM3Zzmkl9XJY7eP5jyPVm9JWiLeRiKrtihLzZDm14koKn
	 j2bIuCmcBeQBewXejCRW7gb1p1ojSX28VxWCkArSqUlcZu6UhmMMjXTmUA+pJ3f5JGj/9
	 kFc0EcOU57g93l6gwBkmTVmsuwwCnZlZKmIRABqH7GcDeY4kqyL13qp9/bEe7s46H0aYZ
	 5znMRqLJ+uRgGxi3IQQPbvlyesz1egAIBTSNN4ABvDY7y1EIWdXxWGuFlkZooTD4vxA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Yt1Gq3ab;
	arc=fail smtp.remote-ip=198.175.65.17
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E3B4606A31B
	for <nvdimm@lists.linux.dev>; Thu,  5 Nov 2026 22:59:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3E3B4606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Yt1Gq3ab
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793919542; x=1825455542;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=qvXp3yRbY4LDgfYz/M9g1PCFrbe0O1SyYzQ5E1Alc7U=;
  b=Yt1Gq3abaqJe6oMOUUHFNGUjQWXk5o94/a8wFTYHZ59aD4LaI4eGVorg
   jb7tDxL+9FRoO0+W36kVVpXFF21kg39SPLfL29UewNOcCRM4h/+19lXkX
   E95BOjuNsnErkHHMw3pHzyyJvai95a8G39zat/57ru327Ol87pN8vKaXX
   loWj0uBiwLcr/rwmnKJ8CkWzQDc8efD3cGif2s5kfdaOvKzx4BmFvjH9U
   ZvG07UM5IcWYb863LuwkXmKMZ0Ifw0TrXQ58UeqQnpYSN2Bf8RdNIXfzg
   aN7lny0P133ypTj9Q1+E8XV9q7Z2cqTSJKzd143WxcMwADY1jGLQdal3K
   Q==;
X-CSE-ConnectionGUID: Mqnhs6H3SAyMZ8+2hXJG2w==
X-CSE-MsgGUID: jr96iF06RZW8y+DANhOTJA==
X-IronPort-AV: E=McAfee;i="6800,10657,11957"; a="2757481"
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="2757481"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2026 14:59:02 -0800
X-CSE-ConnectionGUID: PcOL07acTiCiTNrGH1Nyjw==
X-CSE-MsgGUID: ciHfv6UrRNanZ1m1z9R5lg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="7248118"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2026 14:59:02 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 5 Nov 2026 14:59:01 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Thu, 5 Nov 2026 14:59:01 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.38) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 5 Nov 2026 14:59:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G8i+oAXciW6ZsN27Nfvqc7dJyO2rt4Tq/DhSuMs2hUH0jnrzZfi0hcTCf8SC6J1jh8heULae6fPCAA1nd0QFICr3ipHb5hpbSRgVvNAQpPHWZPNiPlxJ117cX++TsPMdjqc7sAD2aG/f/LXJKFeF5H3EbZ6mzz7Bgn9jW5ZfGpOn6k5i3TI+3PNyBkSPc9Yz4Cxo7OCrQIW1vVnrlB0Cf2bZDrJ/Su+zpeImBbhcqDD+eY43Ol4o60sRNaMtZj1QjYQK5DAra3J0FVILqPhfa7ok78pjez4r6qQUQYaXk2RRSOUH1CA9qf2qbS0rPxxBGS8KyWoHpzhOCQfAtEYuVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CzIbM5cd5zfHPfsEq8RGVqvuB+L/B19V70kw/qtaukU=;
 b=vKxmOFvFQDVjCT23CvPtbY3LZ9AeoHJ7op/rTQFdzStCOwbpbLe3cHKZ/6ln5Vqii3qyxh29OQVAazOexfIuPN4eTmMwcuY+yvsxn9owx4M1FcPqCYzaTS8SAqOP6RhqPJN1T4Elv7LZVnYd/78UF2ZYr66TW1Ovf1qgWHFIojdLeK7tqy77emClD1jXfhb36R+64ccH7fsCHszhKNrGd0jD/M71z5V6eSMMQs6W7VgeK1TZGLci4yBlj/Jh6VUN+fKu7tnIQISIEDR7B4B2suqicWBrgq+k1BAV1hZe+GGvIMH2NxwugFUPOg+i6hWGOpPQMcZpTxcXjEVDajBeCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by CH3PR11MB849673.namprd11.prod.outlook.com (2603:10b6:610:364::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Thu, 5 Nov
 2026 22:58:59 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0592.009; Thu, 5 Nov 2026
 22:58:58 +0000
Date: Thu, 5 Nov 2026 14:58:54 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Muchun Song <songmuchun@bytedance.com>
CC: Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang
	<dave.jiang@intel.com>, Andrew Morton <akpm@linux-foundation.org>, "Joao
 Martins" <joao.m.martins@oracle.com>, Ritesh Harjani <ritesh.list@gmail.com>,
	Muchun Song <muchun.song@linux.dev>, <stable@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dax/pmem: fix unaligned compound devmap initialization
Message-ID: <au0KLseDt4S6b1ME@aschofie-mobl2.lan>
References: <20261016054914.2601510-1-songmuchun@bytedance.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20261016054914.2601510-1-songmuchun@bytedance.com>
X-ClientProxiedBy: MW4PR04CA0048.namprd04.prod.outlook.com
 (2603:10b6:303:6a::23) To DS4PPF0BAC23327.namprd11.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|CH3PR11MB849673:EE_
X-MS-Office365-Filtering-Correlation-Id: 16ac90d6-ec8f-4251-832a-08df3b906021
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|6133799003|10067099003|18002099003|22082099003|261021135927099003|11063799006|56012099006|261026121527099003|261026140227099003|261028144727099003|261022105027099003|261009223027099003|261021121427099003|261102123227099003;
X-Microsoft-Antispam-Message-Info: YBTvYfqdwAam4ctS4SM73h5kXLGTNepHSJNZQaysjZZ5QDwcgEkc6452a14lx2Nz3petNLPEPUTps50zcGpi4zgQgnbw0FPjLxDouPwQ3dSam5DDjTezM3JXSKnH63VCX8Z3cdGzCWW7ZoVgupuwmLhVgoIGmEqi0SjdEU5rfEP4vmOIXyCxTYgMu6IEsXeOGYCgpfXLtCU+hQC/v7a7npwnaAAUp50A5htoIiryDReJgmNNnCuWo/H6R6njt0g8fShVDW4cmcYuaenTTmHmRPKVfqaIGkKGBhaaKA25GUTO9jTgV4xjOjARw1q9PFa2p/BKQGTVlOP8Vw9Y7guz8TL+4EfzrSnFZR5jchrMpw6q06XUP4luFmTE1zuAeCKyBoN+gcEnzWgJeh87V2BxlLLvbtLuAX1PZWiUEQl1Y3E6PlgkaQ8/YCsBmVdl0/4sKSsv0DlAW+MeAQq/6SGntCCv8YQuxk/8Qr9wyddSXYSShxEkNAxjsve8i+5Su7PmweBI6i72OPTGa0wb99cwLm+I8ZlPbXOG1Kw/5WECYrCNfto+zl35Nx+1nJZQeGb/o416iMhE2WRSneYrwjstQjQUxcFVbYavEbjgSty+puXMFnvF6aJy0HORYaPk5fKE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(6133799003)(10067099003)(18002099003)(22082099003)(261021135927099003)(11063799006)(56012099006)(261026121527099003)(261026140227099003)(261028144727099003)(261022105027099003)(261009223027099003)(261021121427099003)(261102123227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YPvenLjJJA1TPAEzrbjWNE8ibDKbD9hSynciEEiRL9FpKEgVIB1d+NkHvsOr?=
 =?us-ascii?Q?jUP9vLkVSNh/9UAGwnsiEfbJmTGYhwfbde/oKe2NMqYuZSMvfdAMtnvsA8Ij?=
 =?us-ascii?Q?HtO+LRw2gjRNCsxfjci6RjutvzK1yPJXzIidtpFvWBRcMohQ+0SCKJFL2JLF?=
 =?us-ascii?Q?nnndzIhnPoDkRW6lE1EnfyMtYdZKJzecXzDqj1tqfOVW1+H8Krwlfug+qMWz?=
 =?us-ascii?Q?xZdU4dXWydZfITtHb3r0MDrGTf0WghMu3SY/1w73DunnIuSf9bYOOAYaiQkQ?=
 =?us-ascii?Q?3divlo/p1qwWZj4B0LeKPhtCCJ+NWWy9jS12h1KQNwYom/zOsyqOS/GD7rJA?=
 =?us-ascii?Q?us/ROu+blIxdgu7RFwdf4pTHf+HSOjgt4SxJWcHJMA4wWVl8ABv2Ocwp6paO?=
 =?us-ascii?Q?xEoY+7nr/gLRzvF7fATCoMOPr/6ml8GJvyjIeIcwpX57Zp8O0M5Aio4lPgD1?=
 =?us-ascii?Q?YxcFVQQjymj5vym3FafxjoEQ+0uuiptihD8gkPjqd5RderOUw/52Rk4mUxSo?=
 =?us-ascii?Q?kOd2/YHqNSVEsNJy9etT1gBHzeRNP951+o6OCqEcPx6GjNP3bhWPkRNF9W34?=
 =?us-ascii?Q?AwZeYQyEAnZ9o8AwoULFeI94DXpxpXq5UkYy1prWuvYbUzC0zBwIjB5WMIe0?=
 =?us-ascii?Q?RT0+I+pnOrs0zBN1msi5cxN6KlNo2y6xdk7Mj0Ljqcfp32n0s9dip8hdTLmz?=
 =?us-ascii?Q?IP9A8981AvPH5oOReLtbaYO8DvGc8APXiWRnvdFVsA/6nr/OgIW22lV6L6T6?=
 =?us-ascii?Q?v+/iQGphoYd9P1G7Zc8ATDLoEzcNOC5BmrtAa0CTv7LhMNkiSA6aA/zj0PT/?=
 =?us-ascii?Q?+bME0Q4JomdqzVcsU5F60WNeCKR8lbOGYhcspYQFwnSFwogUbYFM1h4tdo8D?=
 =?us-ascii?Q?sddJZl1oc408S/qYOpjkIElUWqhUMf2TtypuI5NwGKcg7STIFw/JByGyN2ud?=
 =?us-ascii?Q?8fqyBAhoDMhZ27pZosAUekitwDgCqofuaLfsApRbETwzCornYHUzUq+hRHv9?=
 =?us-ascii?Q?LoJ2c4hwN/SxiLbbn8Oc7UZyzeUX4Uxv7O+1+q42/bi7wbvDds15n4J7/jkH?=
 =?us-ascii?Q?zQGjjkSjcuAcD50IlALCbcA11LYo3vh3CKvQyPDPSoqftvxoAO4iylp2r0hm?=
 =?us-ascii?Q?kFNY7ou+3T+6zQeKJEHmeZnrw5/8Sl3TQ1mpwC/8lkcoyxVvwvdQ+4ckV03N?=
 =?us-ascii?Q?UPSaMjsvEFxSHJFQxNuyO71RRvB1COPJIICuo9D2nszvsTsYeYpZJ3A95qyU?=
 =?us-ascii?Q?FSi5pTrJ5bFRMc4nS3GbkZRINrYEAp4zdaMTZJCOpwhoFq6Vt+bwUMxEuOLi?=
 =?us-ascii?Q?rQHuDWviNirm0H4caCilSNKnLcYOTlfb2DgAJbthv81GSxuN1+UdKz4OZZjE?=
 =?us-ascii?Q?w36c5jqsNgqodiT0G+poX0bd6Rbu08Vkbdmiu9DkLWdH3VOlZ+rHeXaViPGm?=
 =?us-ascii?Q?vvp/l9WoKb89ktHAOegf6RP8PoctLtENzODXPfUBlgIKE65HntYU/k6IL0yP?=
 =?us-ascii?Q?yt3ZglYOUGUIO01v7eayIT/oqKbtJwssodVUODP5LeTN5xG9q/49/cOIhqZ/?=
 =?us-ascii?Q?z8KfUkfIAQB+Zx4GYrVdINQWpwF8OiVrwmMSnaq+vXh6+an9odkIRE/ULT98?=
 =?us-ascii?Q?y/NpewSxO3ccdKQDrrb+VEoVckVpLTZCl3CLye0heSNiLRp5JYi/+9CJrc1B?=
 =?us-ascii?Q?x5oyy+g3fKoyQBB570Xr6XOLnfXok07owq8fgf8qbKhXMoU/3AnNIf6a9TTi?=
 =?us-ascii?Q?YjhOHQ0ZJa3hCAujZ3nAj3xf164n/jY=3D?=
X-Exchange-RoutingPolicyChecked: vTvs1PndAu/GdhkREBE8nD5MK/HEwWloexcAVTqeixr6kyHAulix49rfC9PZiLw493E0+y/iCS1dtzN9nsxZFS/hCSgbcg8BCVifa0Fc61NyvqHFYQ4Ml2CYGpOamDtgPs4NlTdF14iPEZ2qTANQNgQAWiSRx8+xyDJQpYZ+yoRqrPBVgr5vdtpr7Rt95YkNpVMJHojh3GIOS3dlLr+U1TOzhbO5EhpMYXXpOnH0lDTPu6rbZ3vWJQkQurNtNMV/QsIx09SiWR8j0ekXlhPuENMrxsThwG2Z06O+iYrcs7hu0m8Oc+nXqI2F1cl6VN7eryb2ddxzjKzeaODgtWxZ/Q==
X-MS-Exchange-CrossTenant-Network-Message-Id: 16ac90d6-ec8f-4251-832a-08df3b906021
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 22:58:58.7290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jiYorgsLhtkllAgbtx+mE16uO94E6ahxzLb2t1AChOEhfrmg1CbjCS5Gm4AZy6MEzNnh6Ho0zopK3j70+/eAUZpFBbjn2OivWFExdVxAHn0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB849673
X-OriginatorOrg: intel.com

On Fri, Oct 16, 2026 at 01:49:14PM +0800, Muchun Song wrote:
> Static pmem Device DAX namespaces reserve space for namespace metadata
> before the user-visible data range, and may also include padding needed
> to satisfy the Device DAX alignment. __dax_pmem_probe() adjusts the
> dax_region range to start at the data range, but the dev_pagemap range
> still starts at the beginning of the namespace.
> 
> That is not valid for compound devmap mappings whose memmap is stored in
> system RAM. Compound page initialization requires the start PFN to be
> naturally aligned to the compound page size, because the head and tail
> struct pages are initialized according to that geometry. If the pgmap
> starts before the aligned data range, memmap_init_zone_device() can build
> compound page metadata from an unaligned PFN.
> 
> The resulting struct page layout is inconsistent with the Device DAX
> mapping. A later mmap fault can then resolve the user-visible PFN through
> invalid compound page metadata and hit a kernel panic while inserting the
> DAX folio.
> 
> Fix this by advancing the pgmap start to the aligned Device DAX data
> range for non-altmap compound mappings. Leave base-page namespaces
> unchanged, and leave the altmap path unchanged because
> memmap_init_zone_device() already skips the altmap reservation itself.
> 
> Fixes: 14606001efb4 ("device-dax: compound devmap support")
> Cc: <stable@vger.kernel.org>
> Reported-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> Closes: https://lore.kernel.org/r/wlrkqqvg.ritesh.list@gmail.com
> Assisted-by: LLM
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>  drivers/dax/pmem.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/dax/pmem.c b/drivers/dax/pmem.c
> index bee93066a849..d3a9b85107b0 100644
> --- a/drivers/dax/pmem.c
> +++ b/drivers/dax/pmem.c
> @@ -51,6 +51,13 @@ static struct dev_dax *__dax_pmem_probe(struct device *dev)
>  	/* adjust the dax_region range to the start of data */
>  	range = pgmap.range;
>  	range.start += offset;
> +	/*
> +	 * When the memmap is stored in RAM, exclude metadata and alignment
> +	 * padding from compound page initialization.  Otherwise, the pgmap
> +	 * may start before the naturally aligned Device DAX data range.
> +	 */
> +	if (!pgmap_altmap(&pgmap) && le32_to_cpu(pfn_sb->align) > PAGE_SIZE)
> +		pgmap.range.start = range.start;


Hi Muchun,

Does moving the start here lose vmemmap savings when the old start
was already aligned? ie. on x86_64 with -M mem and 2M alignment, a
namespace starting on a 128M section boundary has its data at +2M. The
first section then becomes a partial add, which 2ef77f4a7d5a
("mm/sparse-vmemmap: set compound page order for device DAX") doesn't
optimize. Would that cost about 1.7 MiB of extra vmemmap?

Can you round the original pgmap start up to the alignment to avoid
that loss, and still fix the crash?

-- Alison



>  	dax_region = alloc_dax_region(dev, region_id, &range,
>  			nd_region->target_node, le32_to_cpu(pfn_sb->align),
>  			IORESOURCE_DAX_STATIC);
> 
> base-commit: 0fcb05b72344f40806cbe810de8872f1698bf053
> -- 
> 2.54.0
> 
