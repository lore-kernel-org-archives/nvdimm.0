Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=198.175.65.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1792793510;
	b=HOXG1PEk2gOEebsJw0MPEBl4X7qaQ7Axug95g7T6giA1BQ7u5YbUiNv1F57xIVggtWGF
	 sPJ8raAmp9tinlF6R7OAere3yodFdzKcgZKzTyINSaHXAq/FMq2Ps+Il1y1bmuHmUf/4g
	 RX/tjI+Pbx4yhJjlAR3GQG7DBoryqUHUVL5rrC3ESNAuDXB3X4/H6qx+LNHYtoBrNL0/B
	 opBwHAUmWNg9ht90RROyJoN/9+SJEvipT68iuniXwl42hkesOsupzhb67lovY80cthGt2
	 T75WjtPDnyltAO/tRbv/G0dIspPFx6grcLdjd7g9miT31LfKXnUGIIZUNJc3k1JWA+w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792793510;
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
	bh=0zcYbJw4LzXiysfgw+HOwGOYBOQpABAxZghKcLenXis=;
	b=R74uojw4l00RwurgcKjYoNbqaQ41Vmyd/09E68ZeFBXClcPUApyzHt7ZqmzN4/DGcsib
	 R4C7e6o/bjzuRwZzFmCHdbIiRklkGyUpt0WuqIh5xC9Z0iR0bymmUXU/+ahCbpxTl2y38
	 SpnRlPNyLw98NYWPGkly17EnpyFwOix2vcsbuiMCX284K8beqASYxSuVUWZ7GGGG/z3vb
	 SgtKUWijWY+MeZ+Tg94cBLPOAMI7EeA/HD3O5L8WqB9BN8BQWUjIkRaY/1U8xRZiKVWCp
	 aUWds1Z8S+ZOzT+bSmeGMORvSXz/devyohFmZt+CjhDcjZyjGnEz2jhycZ9jb4MR6gA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=EANlRw7b;
	arc=fail smtp.remote-ip=198.175.65.18
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36BC606A31A
	for <nvdimm@lists.linux.dev>; Fri, 23 Oct 2026 22:11:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F36BC606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=EANlRw7b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792793504; x=1824329504;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=U5T7mx7Uk9soyWmZwYUyfsTn5VWBbXaat2oSz7mhMV0=;
  b=EANlRw7bSq75XBhwF6swhKzCDaIRHvj5Bw37vGGChOK++ESnTWcNUOy/
   kWCZ8GOLFFqTnq+iaZXbJ3f3PnKH9s9fXltvZILk9LSrB61QhlnB7gMUO
   kmW5LCN71/CNYWYOyn0sq+J5982MwvThz+NoGwo2o/PbhfqCMSzl1gooq
   UwF22u4hfdShQBDHg6CGTVZJUNiBati8TMpuN+UEz1bx+L4OXuhpJ98Zl
   vxf3Li8Lhe6PO1apqYdOjq5g8OrcWR9dQNo+l5w+hcpLUpgA+EkWx2tuh
   gq8966EXmqBd2Il4+TKoD+efaSUQ7lKjXeU1+TUW4tAG0lYJjd86l9Ctq
   w==;
X-CSE-ConnectionGUID: aV4dyXhvSMKLKtzEpTC0hw==
X-CSE-MsgGUID: Zgg630b1Qo63ZnaAsWmb9w==
X-IronPort-AV: E=McAfee;i="6800,10657,11944"; a="1563754"
X-IronPort-AV: E=Sophos;i="6.27,175,1787036400"; 
   d="scan'208";a="1563754"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2026 15:11:44 -0700
X-CSE-ConnectionGUID: 3WUY7ConS5epmZS2v7ZMYA==
X-CSE-MsgGUID: KJ0HjnwGRsONUckBVJ0ZJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,175,1787036400"; 
   d="scan'208";a="3630058"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2026 15:11:43 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 23 Oct 2026 15:11:43 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Fri, 23 Oct 2026 15:11:43 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.37)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 23 Oct 2026 15:11:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DqnImcjs6DDspL7Elnpa3cduMlk+4nLcdkSV7vQEzcbScnetKNVvk7gLb+RhdD9VfwgBR5MA+2WJf7veWMh+NiZF2Hr4L9MK0o7S6G5Cgt7B9cS9IAtKLv0cz+7fjvJhbog2wuCyda/VSJLCsGuwqBbP7a6Xv3WETn+S9dstX91/deCqV+qqNkl5Fb7OFGsrqgPmp14Mc3BZ/7+JNJ824LaEuwi48HTGtV9NCaZeTf5rRh8Y0LJOJ3v8UcZq4t3ksROw1YNyRW+5vsex28tY0nqVYnCmN63Z+zvftpdPUy7LaTWcoAuUPg4ykmTj3EFNPkorbf7CO0c/DJ/p1zR6OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0zcYbJw4LzXiysfgw+HOwGOYBOQpABAxZghKcLenXis=;
 b=qCPT6ImtSof8N/SwxWDligJOcFvhRGks+AZKM1OMs/tGNOehi/k18Csg8T+p35wh9yc7GWuRuoDVoF1yOeIA55jafdM33rlG4O9tIIMtkebHhD1fGMXvwPppeupizfBYHjRpDjlBfUlOOxjI21rdOcZslqc4GR/w5VjNKah8iwi0eCYCtQiVJTsUYy7DcL/6SW11Vq6mKv82ONYztkfqHxaU7/+eZWonjQINEYUrYdLDmcedT5JWFaB+H2IHOWoHmrNc62cpXNsSzA7OFi608bgWhpKIcTyBhLU1XwOjHEUKP95tsr8SJGzGZpD+MqsxXdmuPfy++7LCqxB3i/VXWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by CO1PR11MB4866.namprd11.prod.outlook.com (2603:10b6:303:91::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.16; Fri, 23 Oct
 2026 22:11:39 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0546.017; Fri, 23 Oct 2026
 22:11:39 +0000
Date: Fri, 23 Oct 2026 15:11:36 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: <nvdimm@lists.linux.dev>
CC: Tao Xu <xutao323@gmail.com>, <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH] util/sysfs: do not fail on missing bind attributes
Message-ID: <atvbmD6iwFgwwqxV@aschofie-mobl2.lan>
References: <20260806223116.2354715-1-alison.schofield@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260806223116.2354715-1-alison.schofield@intel.com>
X-ClientProxiedBy: MW4PR03CA0346.namprd03.prod.outlook.com
 (2603:10b6:303:dc::21) To DS4PPF0BAC23327.namprd11.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 2459dc5e-f882-416b-2bc4-08df31529c84
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|11063799006|22082099003|261022105027099003|261022075727099003|18002099003|10067099003|56012099006|261009223027099003;
X-Microsoft-Antispam-Message-Info: k5dBMRP1Mc9LUc0rwsmf1kvUzBhWyvqhMyPpJvcew8y69vZAhapibmbVsjWrK3/iYZYYjM4FldwGMs9Y36qaiZ+7kx3OkkGCTekd1W06p7gebCVhYWmrc0nvMSpxI7nCSFq07qIxmjXp+kJ7dbs2ALENt4rzwKv4DQlRl60L/Oj4C2TJ6sPLV0v62vavGwl+bioamqotEsaYZ+dLY+IvxwRji3UR1HhOPYi6ddDmMy7ZZniglX/8+/31QD9/+zY2/42dH7dDXe70/SyRscbFO/nOqWxBoit1BjSZVQ02AD9J7VksSQswun7HvxxUSU3AJT28wSfqaJEGYbJ+fPE4MHybaYrNNncUSAW2dTs6wgrj2x+J7n+1BQvZW876W8KB5xE4/WmVdIr97s3NlQkJnS3vmmJ5YjOtU1zSM7pdaPh0dPfyk42zw5GODu6LOe1iUZ2S5jO57J/ef2d7sXiHispu9EVTkfvBAOkAfQKVTwkEvfjbvltCaoq87vFHtPA9ogcPCzRg+JmUNlxaeiqWOvr660ItAI1SRR4/TyYuY586hruwGIFhtmoCbQepE2ScDY/sJE3KytWp1IR4QpgF0gUQIdrxAuJ3bb2/4bQ4s3av1edWngBCUVnvTc3zPya0zLMZ3RLQHDSaYJcc7zHATZSCCqVH9qvQoIwUuzVnET4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(11063799006)(22082099003)(261022105027099003)(261022075727099003)(18002099003)(10067099003)(56012099006)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NK/azyaRIeW+f3jkYqmcqJSSZmkwzaUkCC0HApByM5rS2D2D/oTlgOkFd+r9?=
 =?us-ascii?Q?ZOx8/TF+Sea/yRe7kAlzE4qpEHvQPyJqYDd56nwP93RcHvRajlb/JBDj2Ggv?=
 =?us-ascii?Q?FiR4tj8YlyGeRNu5L6QfL/yqGs4RhmYvCIPKecW4LWIRymA3U+smQeYo/pbm?=
 =?us-ascii?Q?CKOQ6cD45olhUCdJyvDNQtzwtsB189oUuIilS9YQQ84LGacp/klY5IiMgPMu?=
 =?us-ascii?Q?ciFF6qEluO4VkoDzqbMaMM05bjXnABXdrzqDPz9UbY+/QQrJMj5O73jwGX8q?=
 =?us-ascii?Q?Md5TxXfWMfUgvcBMgqgmW4Z7u38TCoPruwELDCAlm8W11323Zb2VFW6RTbYG?=
 =?us-ascii?Q?dBeaPACnsxbAoI5ycDszHvBVRQx7qE7HPdegWd4ZAzv72EzI8xb7lUooZsa3?=
 =?us-ascii?Q?NIG9wT3Wy9wWxJVZx86TJmeoZbZJJoPNXnHi+grUf9ZEmVvcSdsks5KZQAE7?=
 =?us-ascii?Q?Cmibi9ObhsTmf/y7a5lid+Ms22oyRA0Rt8GkrvbnBafd+ifFe+pulD6ok51g?=
 =?us-ascii?Q?bnJwtnnghI460BpWTbtwVFYC+CNPLtj6yrVH76ZE3AEEU+BmqIyVepFRUt2U?=
 =?us-ascii?Q?36jPsNENqV/WHZaUFUgFc5aup1MFtaNxlTv+GiKMKYWAoZgeGxr8hxLU8WXp?=
 =?us-ascii?Q?6I5wGKyhV4Xa3/9iJmkFdxKm8q79sVZopJfJE4SEb73JEZzcYVqFf6XaudEy?=
 =?us-ascii?Q?IdhbKwwjCsJXV82E2+uNu3jaTzwkXplAohj0Frc2EBPblvVf/B1UNgQEmNDI?=
 =?us-ascii?Q?RIHqX+YEVkzg31NG8XzMv65jcHXGrNs7Lqn6nUp1o4hxy7R1gpcMHvC5W7oE?=
 =?us-ascii?Q?u8hcTSIROmkTFUiG1sXKnq5bIyaksboM3zuS7eK9Li4RUOvKzVGigJjoMtix?=
 =?us-ascii?Q?fYkxwkKQISOr8+DLzs+EnKOv8JQ7aOc34cnFPJD+AWkQGFt36BBB+hVmqsZQ?=
 =?us-ascii?Q?Qmtmt5W89XjAViZc6q5CEZE5kAf2D4jYkl1r5cU+9h2tcp6JCNAD1BUVTwB9?=
 =?us-ascii?Q?P6ecfQbHoQXwd9c+H5s5E0+4OIvuADzf1oxDP///uYvT0NHrHKQ3iacqfzQG?=
 =?us-ascii?Q?88Y35ngA5UMBBc0f7jELfN2I5lKv90e3+PjNCl2ceExex9rOjYjatSK5f+Aw?=
 =?us-ascii?Q?PsEFrvD2fJMsPEQPi5KqFl9vKg7JJ6w7IoPtJ3mp6B/Tl23ZQFeHnMwnvDbr?=
 =?us-ascii?Q?EPeF9/2L+QbP+uzH+9/rn6Cxs0a5w48nbFdI+XsZ0342SbP5tIqSa5bNZdR6?=
 =?us-ascii?Q?R0jtwH3aFnnQYQLO8bB4jvJEPlJ2HhGVMRoDcBTqVKHoZwkIRN+mMx974KbN?=
 =?us-ascii?Q?pCEVwYNv/DUyU6jM1uONbQjd+9KASy65RK9E3IkJcC6tx0OSYT2j9niykqoL?=
 =?us-ascii?Q?CPjc24cQi4RfNYlM7r2PAdvLmBDIRlvARn9My2DB4o0pRIZ/yRszEHuUofaM?=
 =?us-ascii?Q?UR1lfiiy2j+bX8XUoN+JMV905ONul5unVYPMVRM29PkY8D8zouG/+Rd4PKox?=
 =?us-ascii?Q?MAuxQvV/m7mlDRYIsS5G/zjMue/NH2pSHxVaglAXUs/OcZWXUw7bK5lyXb/s?=
 =?us-ascii?Q?3D8akWMngfgLnDjs5dUfBxtAZSgOp/RmKxopZ5NjaMIorf1AzzbSKkY6norN?=
 =?us-ascii?Q?zBQxPhWxgqK3k0plFW6x/g2O9h98A1+RAKZUtoXP7TWonilt9UEgBcgaEfu4?=
 =?us-ascii?Q?EG+uxdVIn2bOfJYdW9o3BQnQgXZgbkuF26Vf5sfGyObhTW4y1H4xO5W2amve?=
 =?us-ascii?Q?DPf5Sf9I6CPTSkZBzx+LQ8dE5jQX6+Q=3D?=
X-Exchange-RoutingPolicyChecked: wMQZxfIvM9Z5BWrl7AZgD0waw2q4nxKbN48HkwNXeALsv0ZSHB5O9idABV8b1tiYYmaJeJ4ZbVbojGTCvBEeA70ynkKFDhFNze5g/dGG38WFjtlFpIciVCrc3w/PpKayJEXMyGSFPwaUrqFamwQAgDefMVhkJ8W96SGafZ01WscA8jt76FSgSz3X18ynu1e78Mx894LK2CJCn0HhSBQmiiBMET3sTcJYBTGyYPa47dMx0C6r4FyKbHwHPc3xl0MQtNH30pek899ZXiWGY+A/G+UOia+xfJzRdTU2LIK7F8YN0p2A8BkiR9ifaIGu9DUbjVOdlwGZyPJVtpp4VMi7Cg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 2459dc5e-f882-416b-2bc4-08df31529c84
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2026 22:11:39.4950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IOcM0mzYTgGQJDmgK7fCQu2jc5RO5/wgoGW1N0X6hUYreg2HnOVyvPx1dWdumKz2Tsu8arNpjaELwtxq9sdaiajpLIUN1NL3HCGMBT9ml4M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4866
X-OriginatorOrg: intel.com

On Thu, Aug 06, 2026 at 03:31:11PM -0700, Alison Schofield wrote:
> From: Tao Xu <xutao323@gmail.com>
> 
> Kernel commit cb9cfff82f6a ("cxl/acpi: Simplify cxl_nvdimm_bridge
> probing") removed bind attrributes for cxl_pmem_region and
> cxl_nvdimm* objects.
> 
> __util_bind() currently attempts to write to the bind attribute of
> every entry under /sys/bus/cxl/drivers/. On kernels where some driver
> directories no longer provide that attribute, these attempts fail with
> ENOENT and produce misleading bind errors.
> 
> Check that the bind attribute exists before attempting the write.
> 
> [ as: commit log edited ]
> 
> Reported-by: Tao Xu <xutao323@gmail.com>
> Closes: https://github.com/pmem/ndctl/issues/298
> Signed-off-by: Tao Xu <xutao323@gmail.com>
> Reviewed-by: Alison Schofield <alison.schofield@intel.com>
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>


Applied to pending for NDCTL v86
https://github.com/pmem/ndctl/commit/3c8c3538a450

