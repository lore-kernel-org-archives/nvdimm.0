Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=192.198.163.19
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793316287;
	b=T6iTzRCrrk9wDSt5ja0zjbdp6hnAVGGIUzE3nO+TgnEQMCLAkxYERQdGRYDKjBNqH5Zy
	 4NQhErrujweQy5KQWlXFR1e4YvmdSUwkSNxH4gXaRffey/yES4yT1FzL4od3qKEk0I7bm
	 0Ryikud4j1/DTArQsIZAAYjgXp3RycOwq9r4UQpXiJ8Dv/CMKg3/Ymry8ptNp/OnrcYTd
	 oVRGq90Hnwf15i8xzZTq1jpFtKMOHRRV64JLbK5wttQkaVGa/fyw5GvGqppUxCK5L1nVF
	 xpfzn4GDH48G2RCvYLUgta9Kwy0zqkp028PWmJC+f+y+nfi/jpjm9W04t1C2HTYdysQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793316287;
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
	bh=NGAEc9xgbmF3rAFTptwN9m0+4O7fDAgOsiV/rth31fw=;
	b=NlYnZWKNz/Ce1DpCIROyecfCRVHnOUKj6ck8E1HFnIBUeS/+dQsEweqSE/G7VHjdL5Ji
	 jYo0XuGtUUPaoQCsIo2yulwyZbYIKv/HadSiCFQX/EZdWupGLOqvTaaIQiAoZxdJmv+SD
	 4I57kXy2z/XaqL8kDF/G/ndaCfuCKzAyU2bfGozkvzMGvshlxrwqmOU34eZEpFkFpeCIX
	 jyWnzVs695dt1DOmuG5KDm9F69/HNH+5WrU2nQaJwKGl3ejFv/wjWhIICRW8j8pmmtVYj
	 4cx+0XrojjCFxAZ7/Gfm+Grt19f5sFaPEMrVBts37zq1GqZojiRT4Io2FlfHhPVmPRA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b="Kc/4JBLq";
	arc=fail smtp.remote-ip=192.198.163.19
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F7D0606A31E
	for <nvdimm@lists.linux.dev>; Thu, 29 Oct 2026 23:24:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7F7D0606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Kc/4JBLq
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793316285; x=1824852285;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=LG1bYJD7FqC9AW4V8wxtcxU99TMXPngfyH6Kg2JkCFo=;
  b=Kc/4JBLqWwJdaMGTE3FrYhps5emAUAbDnRQ8n1h/6sWSr+rx6Ve2cXul
   9x0MVqlACmgfhZ2+gc2L/KYAY20rhCLT0zVX+UwLPXhrkAU+LNCJbCLcl
   q/RjhZi15rf9jPF7E1wzKVwFiDSnY1KoCxb4jSew7CYJnubxVAzp70rnx
   9gLaEjCZezLXIOqqUMS76BCf9QLq/yQjrtBHrwlXY4oFj0/d1isW0p7+4
   JJgKktrhp7QmnZnlpYH5bPVqsswRzbgrZ+3lRFW1tky6DCT3PC9z2HhyT
   G/l/LJq/mtg1Fw7ruKZM3Br2SFQpwmnW1nyF7D5J21kEFdq+yVLEHSrOF
   g==;
X-CSE-ConnectionGUID: r4lZSxL9S/uiA/5JI857YA==
X-CSE-MsgGUID: qbwITW/tSQmq7f+WaxDoYw==
X-IronPort-AV: E=McAfee;i="6800,10657,11950"; a="2178457"
X-IronPort-AV: E=Sophos;i="6.27,185,1787036400"; 
   d="scan'208";a="2178457"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2026 16:24:44 -0700
X-CSE-ConnectionGUID: JWbSYGJ9ROWsAsQBpjIRVg==
X-CSE-MsgGUID: qSdZalsTQwO4QKgoTz871Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,185,1787036400"; 
   d="scan'208";a="5300351"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2026 16:24:45 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 29 Oct 2026 16:24:44 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Thu, 29 Oct 2026 16:24:44 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.39) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 29 Oct 2026 16:24:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kKTJQLwb1vz4SBSMIirBZqzKIU9xj/T/cfMjdLJe2vbWdLzY9EX3Z8BIYq992RjQnpj7mnlQrh5XfWZd7Lh+EsMfHPjF0fHCstZhsSh//p8fa8chqMWBO4cESIuKA8zdHydfgefZNnLtLf5BHYqckv+Dc2qOq06S0m/VSIV0EBRI/VR5vx0zm1aPs4G6zI3TWdclljj6ey9YUk4aEaWca5CfhpqvzA9EofXh1HVdK68aiz/aS0oJ/M5XwwxBy24DsM91UqFW1P01glSQSImLN4QvwKHmujJgesC6FQIWqsRdf7ZTKucwV+vk0uFrmsLIupDwoSLD3bzVvjNtCXCyuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NGAEc9xgbmF3rAFTptwN9m0+4O7fDAgOsiV/rth31fw=;
 b=bmWYQd7JcJ6AbmIoW88AGXTaGcl9Ij0pqdnI11jm8Y29HJBYcJZyj9WgFfFkxWvI5Fcaqaf56LwVHFvn/RO5l2wsa0brJ7Cg4NuskyOYxYPx3+sYThbSCuFPCmbGmmkQnv0ps5mINblUtIHSfXvqCjDL8zyao9OukXCmoJDMhHxfL11XYc5cGcVGi3RhcsoCOZBplnMYDWurVLeJEv3R5mv73MahCA2Q2AD9DC47WA0XxGri3d3vg/baO5Pk3+4ErOW+ZlmUwUF8z4RaMrwQpn3C4NrS1+mHkM4w7eCduhHp1QsfcyP9plZT/A6AQ2l2eteH2okT2EmrlN4U0EA/Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by IA1PR11MB6172.namprd11.prod.outlook.com (2603:10b6:208:3e8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.8; Thu, 29 Oct
 2026 23:24:33 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0546.021; Thu, 29 Oct 2026
 23:24:33 +0000
Date: Thu, 29 Oct 2026 16:24:29 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Gregory Price <gourry@gourry.net>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH 3/4] libdaxctl: match memory blocks against each
 dax device mapping
Message-ID: <auPVrdewLsEbMEzw@aschofie-mobl2.lan>
References: <cover.1792695259.git.alison.schofield@intel.com>
 <45bcae14b4f665af8427ebe38afdb9eff282bacd.1792695259.git.alison.schofield@intel.com>
 <179319574485.768545.678014460424399236.b4-reply@b4>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <179319574485.768545.678014460424399236.b4-reply@b4>
X-ClientProxiedBy: MW4PR03CA0245.namprd03.prod.outlook.com
 (2603:10b6:303:b4::10) To DS4PPF0BAC23327.namprd11.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|IA1PR11MB6172:EE_
X-MS-Office365-Filtering-Correlation-Id: a3268ed6-91ea-4bd5-5ae7-08df3613c9de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|4143699003|11063799006|56012099006|261009223027099003|261026140227099003|10067099003|261021123027099003|261028144727099003|261022105027099003|261021121427099003|261022075727099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: BLsaFkD5d1Kwcl82j+rldt2ARaXIqnaefSPk+2a68sJg3FItP2yT5fr7uXm2gH0aHQecWuoIf3WeUjpha2oVEKXQKQ/jQ4Ci57M0hjlK6Yw4/jQStKKWVGuUHnF/IMQ9t1vphyIYtz7GLWM2BX0NSrTgaldxp7wHqCNjvI6kTHSBDc6uo3Q/UqkIsb202NBtD38SWviSqw54sab9TlejzQbVp2/NwHKHAjlm+XKSPeOndaPUvFJ1hG40HzC4tNGLYgQlHA4U1USZuTXAgxA7X8BOGUHslOKT57oPZskDK2Hv/sWsTgXpwJ4WWXQfZAqFlQjhxYnm7sBwxt6YtOfKDj4pr/M92LFW9HMTmEf2dzIYGMELEIJGookIIf7/JiNobJCYEzuZIeEgxBWL2TnrOYE/vAzJArLItvbSRbHLToDi8QaUS7LkC95hiZvZgBfmLEsL1XSmXaEXuouKNxU2SE0Z3SPzxBSzvLUKFuKyp0sZK9lHyXFFQfn7FiNPXvEKLK73JAs8vQiNEEpCC3k7rU4EWhoW/6/4FtSA5MsN/Y1kv2leb6Pg+Tj0gfOgWhW/QLB9OtEuctS9qWH+omLYVKfqR3i6rrBgRC7kY9ksX6IDc/KrIYVkYiVt7qW03iSMppV12zCdWD+aMtnr4HtNy8KpCxkSFHtXQhe2tnJIqO8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(4143699003)(11063799006)(56012099006)(261009223027099003)(261026140227099003)(10067099003)(261021123027099003)(261028144727099003)(261022105027099003)(261021121427099003)(261022075727099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D322lDlu1+WRnrxEra3P0iYNsT0TrlvoLVE8T52JWLT+JX5oy23Nuuw0I07+?=
 =?us-ascii?Q?+qvKpbEbBRPHpiPv0A1EGIyQ79/Mi/gSIC8h9SKwEHWTWlpzsdj1t9yTb2pj?=
 =?us-ascii?Q?AHkAnWdZDPFHWpE3JFJlIIHA6KiLPvKqrV9M1loY5Da+AJKFQ2W7Lidc/jJ3?=
 =?us-ascii?Q?g6YVBxUGbX2dGireedxGIOXy2w8BPYswW5bl1qOb46eVxiYgs67qdOz/PEBr?=
 =?us-ascii?Q?hFCZ//Ef5aJuGiKQiUg2mYs/KAfcME//HkkGramErpv8C158tFhbxO5vU4q1?=
 =?us-ascii?Q?HZSiY1AnrknQlptO1HK7bLa5l18m+gjhS31MWV4yOdCLzPQ2hFfVR23EituA?=
 =?us-ascii?Q?iKs+6I4ZRsePJhAbwoHKJOdGsFMJc8IwE1fNgCEiXmBb72BSSRNTaHXXQ2rA?=
 =?us-ascii?Q?9t6YX/tw7+lMbLFD/XyQ6MapHEVm6ZaGUWSswIc7QEK6JWLePUvQDRCCI6c1?=
 =?us-ascii?Q?Mt/9Mh4GIj9y9KYpTtn10BWpR0XPwPDEuO7IoyHAclxRLvO2OWsX5S9g8+4r?=
 =?us-ascii?Q?wSIatGR+s2YchG31EnzbgSZHQRc00BjpRxAA3S1pYKolsBH25R5XQhI7EN2T?=
 =?us-ascii?Q?l2+SZ3y2iv0wYzI+cBOfuj0gtIDw0MLPZLkPgNDNXyV4vQ9zjYZU2FpoUxr0?=
 =?us-ascii?Q?YEY/Eq6ezRkWcF+uiuCdNGjdmkreY0p8JneBpwRjHzr+WQLRVMRAdV5nQ8f0?=
 =?us-ascii?Q?nK7x4RYPD07S6YYb1TXZhR3Mj73U2/UfxTbmec93GtJy1w5viYToxRf1t8zV?=
 =?us-ascii?Q?KJd7xcjduWboH6gjbLMrPy9nRBFNkUS/jJulT5v208/p1b9ZD9IIjiNQzoxa?=
 =?us-ascii?Q?8G5xGpi4+vOiI3L/1Ig+7ffYwwbwxApIyvqM49785tX+1bekBcO7GtFzUx8f?=
 =?us-ascii?Q?/rkWqW6cOP+cmub/KyeZVXtyEG59MeG8wxsDPAl09wab8G7Mg4XCCsOn3fdr?=
 =?us-ascii?Q?qJ51lW8694E94CVmGMbj4dqFOgFIbqKyjPtmFz0yXVVDPbqnxCR8uDStMLw9?=
 =?us-ascii?Q?FnJ3taT8yC2hCC0SyOsb2oD2vR/vCWoTWx/sPY+MSOwn/1RUn/Y7dV74zANt?=
 =?us-ascii?Q?Tqi8zMUMOkAI7T7lSw/gn5oYYAMEYypozT4oXd68GaRxuLT9Sj8MwwzmSPFK?=
 =?us-ascii?Q?pnFJvysy88/bxIW8bx8AfV2TJKARwHzVF31EYotXzIUJFi8gheN2NoYHDjte?=
 =?us-ascii?Q?Zu0UXyXWyotFIQG2MnCKrBe5u8eZX+TXPVVBrctaF+39UR3mBfOIeZ8E+Yg7?=
 =?us-ascii?Q?gjyRWIiak25tXjt5tTH5rL0f3nSRHHL8MQ0UTrxcztwWcTqGW72vhe27IRiI?=
 =?us-ascii?Q?Z63M45ZgzgNMelZuFCSjnwPrSAR8ngRYN4Y0/ysqjjZ+nZOBSwGavk5CJriF?=
 =?us-ascii?Q?Sa1OeMjz7fWqrv9ehYhiH++AB770HFm5R9YvG4/JzPXuXM+25E6yv+ASxNHG?=
 =?us-ascii?Q?FoHvrJH8Jv0WQ0zPWYvLy/OJoxNkuj1B+Tx5E4zYG1tyO8yHJi5I3u5DGMTN?=
 =?us-ascii?Q?koAGCij08zSg2towyfFenwwQot7sV2jga0ztc3E0P1hAPoh6f+MF3Shqpawh?=
 =?us-ascii?Q?NZaKSj8UWO8PUzoHZYjyBRsCE9XqLq+Cpx8F/psw6Wo4zpsTH7Mg1DWO2AS+?=
 =?us-ascii?Q?iaMaM9FWN7meiFeC9gMBENk6ikncAEBTF+tSE/65YcXaTqlMNQZK6pWsoxlg?=
 =?us-ascii?Q?DsN2b4DojLi3ieLP2US5ueF2r5CrRsCmM+1nOSTmd4CZKuISEck+mEzotxsi?=
 =?us-ascii?Q?vv/kAkzhs+SbrC2ZDKegp3CrlMpfH3o=3D?=
X-Exchange-RoutingPolicyChecked: s1up46Ace8BHyxFz9YoZCVCyEvCFZUWch7iqGE7Is52nfIAmVO44LKYvMQk01LID3TAdOxbHoaShXdg4wIil0jVk/K8bQLYvJ6Lqu/cZFNojvY9XSu/wPeZj42ZZjItCYJyg2vX0FwGWHwhzTq1STlVD+ObzYT0/3aXC8J9NwCBefL53lMvGDtRxhl3GEiCqa6mS79N9AJsagPiMT5OHWLhyVVlgBJYZYUSttLFzY3HkTlKwkLN4eaUfeXjd2naJjolJWGDDx/baImfDlNmnRRaQkW+gtMb/LUkV5wZT5vHHthLwb/vdpvM6Rgc5xOfmB6sAu/ltpdMHg13JY2rjSQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: a3268ed6-91ea-4bd5-5ae7-08df3613c9de
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2026 23:24:33.3210
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v23mPXtB5UB7UdR1/aMQWnADXS33Ix95d4RWAYFYhewtz6InPVJ4XLBsSo4IIYM7IlYtfLzybQuh1yJErhKl3uiFCvXQYVB5HAJH5c68mBU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6172
X-OriginatorOrg: intel.com

On Wed, Oct 28, 2026 at 06:55:44AM -0700, Gregory Price wrote:
> On 2026-10-22 12:56 -0700, Alison Schofield wrote:
> > memblock_in_dev() treats a DAX device as one contiguous physical address
> > range, even when the device has multiple ranges separated by gaps. This
> > misses blocks in later ranges and may incorrectly include blocks belonging
> > to another device.
> > 
> > Memory block counts and per-block online/offline operations use this
> > lookup, so daxctl may operate on memory outside the requested device.
> > 
> > Match blocks against each individual mapping, retaining the single-range
> > fallback for older kernels.
> > 
> > Fixes: e8bf803e359b ("libdaxctl: add a 'daxctl_memory' object for memory based operations")
> > Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> > ---
> >  daxctl/lib/libdaxctl.c | 15 +++++++++++++--
> >  1 file changed, 13 insertions(+), 2 deletions(-)
> >
> 
> Ran through an analysis and testing round with my clanker, seems to want
> this fixup.  Looked reasonable, just passing it along.


Thanks! I've applied your fixup below in v2.


> 
> Will get proper tags for you this week.
> 
> -- >8 --
> 
> Counting an unplugged device's blocks can return -ENOENT when its node
> still has unrelated RAM. mappings_init() leaves ENOENT after probing
> past the final mapping, and unrelated blocks take continue before the
> scan resets errno. End-of-directory can preserve that stale error.
> 
> Clear errno immediately before each readdir() call so the final errno
> check describes that read alone. Errors from block operations still
> exit through out_dir with their saved return value.
> 
> This corrects "libdaxctl: match memory blocks against each dax device
> mapping". Returning real node-directory entries with memory entries
> last reproduces the error in the posted series and verifies the fix.
> 
> ---
>  daxctl/lib/libdaxctl.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
> index e106fff..c154db9 100644
> --- a/daxctl/lib/libdaxctl.c
> +++ b/daxctl/lib/libdaxctl.c
> @@ -1716,8 +1716,8 @@ static int daxctl_memory_op(struct daxctl_memory *mem, enum memory_op op)
>  		return rc;
>  	}
>  
> -	errno = 0;
> -	while ((de = readdir(node_dir)) != NULL) {
> +	/* Helpers may leave errno set even when a block is skipped. */
> +	for (errno = 0; (de = readdir(node_dir)) != NULL; errno = 0) {
>  		if (strncmp(de->d_name, "memory", 6) == 0) {
>  			if (strncmp(de->d_name, "memory_", 7) == 0)
>  				continue;
> @@ -1734,7 +1734,6 @@ static int daxctl_memory_op(struct daxctl_memory *mem, enum memory_op op)
>  			if (rc == 0)
>  				count++;
>  		}
> -		errno = 0;
>  	}
>  
>  	if (status_flags & MEM_ST_ZONE_INCONSISTENT)
> 
> -- 
> Gregory Price (Meta) <gourry@gourry.net>
