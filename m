Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5A53396E0
	for <nvdimm@lists.linux.dev>; Fri, 16 Jan 2026 04:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768537789; cv=fail; b=tcSogv4AweXV7KOvCeZJ6mjHWVDlyMqJQLnr3KpMTjmfVI9MSr2JZYcDRd0OBeFbodrfx11X/nkpOGSpXqUyEFS46YDFV2WexgXjEt7TvqnyvrUjvjorEWmKHgVjDueC5/DbsguMcxiMV4JtcVjAZDehHb8aOQngyScsJtI9JWA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768537789; c=relaxed/simple;
	bh=VNOCSrj25mSfhzrYfXJAGUUXYUzLRcoFnfVMDcpcu2c=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=h3MgRl7jggOwqtH8eee2JFFrR0fwMHwtkpVwUZHgOfDl2FsUSrW+Apk8hrPHeFtUaTMbdbiQCU2UeOX75Y366IAKvWI9dht3sEj3jAdmD6TbCDFJNY4cSRXl5egpDcuiiA3rWhAAqRx2xOrTV0qMQnkljzB28DjYL7VAAHC7jtI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d/NcvbeH; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d/NcvbeH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768537788; x=1800073788;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=VNOCSrj25mSfhzrYfXJAGUUXYUzLRcoFnfVMDcpcu2c=;
  b=d/NcvbeH0IUTLJi/bSgC+9jKVJKGjCL64rlkdV4jd94PaK05bKVn6ehT
   vHLsdIHwqM+0/fTS8BzD3RVplTRg2UQdEsaMr3fsgokrwMFO9zAeCQ5sg
   74orNToOKBtTNOcxHKynTCYgTjeaNvXl3/8spdycdN9nW6HAhNGE0CSOO
   dpL4WzbAiQAbj24g961ro/xqxdCFE4ebCqdlJDgjG3S+WnXqzCNuTco70
   rVr+igev8KRznOs5HBhX8gGZOdwXLfFNDqsPZKTrxqm9VrnBgUNBH6bGG
   /MnoaftC5EUyRfO03voPzr7Jm0ahXZ0xRBiymG9dHkrx+NYldsUsvUfLx
   g==;
X-CSE-ConnectionGUID: P5lg7TcpRW+0yAEgfARHFA==
X-CSE-MsgGUID: a/l/oqTcRDaiKFk1zitYuw==
X-IronPort-AV: E=McAfee;i="6800,10657,11672"; a="69056234"
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="69056234"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 20:29:47 -0800
X-CSE-ConnectionGUID: sa+rsQ2tRQaCNemLdXf/oQ==
X-CSE-MsgGUID: qsevKhFNROGoXDFDqYtzrQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="204932015"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 20:29:46 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 15 Jan 2026 20:29:45 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 15 Jan 2026 20:29:45 -0800
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.36) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 15 Jan 2026 20:29:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R03wtCsad9BfaF+P0unmx2B+t9w/Jp3R5g1B/PlQuFm8z4c4IUuCf8p6D2fcu6ADE6WqWwydq/RDD0a1cCTnxira/FtNeA3ebPoYyFHsV5YWV9CFvkYx1V/X9skptguaNjZAwJPcbzhJv99QLg4rmkEvRujHvULxP2M203FwDkqD1sshtglBN8tld94Xk2NO76LHFny64H9Rm4IyL2/v/sjfoYlo5MeOQW3sxm8gX0MoDN42igE0q6lSsbJDQmdRXHnmrCB3IU8wecfoxLYmxxg8SUn8h9GheXaKGAei4F3EOkm1DZt7fJz4mMCLm72OyGI/+7CC3+Oy2Vxawq3k1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aHAQ7SvAeklbT+yufOw3zDRlHePIs/X9o4iQjoT1RpU=;
 b=PHz7Gt9PiY7BMKlItkDgU7FcMFrT3f3tAig64tHaEZ9t2FP61wrhLhI38urQpoEbxFJsCIgv3rWa6+EAdQt5xpAQwpTqlO6UkbX8Kzvsr6bJllnWFye2tJvzMcLU+euSbQunilwtLROvLkfI+y/zNX4Tx3MS7gCShcSz7fvMWbywcXgf1R/JbDJvizq34MAgMDZjR8ymcLIqo3EFyCS9oNwX+CnrIVU0HGGYH+1KJixKcZHSosveMO8kZ2JB7CnIQcrjR8Ie9X6rggTX4N5Gzn5ZJArTzgo1S8RssnmTFPhcWJNFENz4rwoJfrat4mWq/BAIUz6TszKlGjLodXsTuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by IA4PR11MB8992.namprd11.prod.outlook.com (2603:10b6:208:56e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.4; Fri, 16 Jan
 2026 04:29:37 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee%8]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 04:29:37 +0000
Date: Thu, 15 Jan 2026 20:29:33 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Marc Herbert <marc.herbert@linux.intel.com>
CC: <nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH] daxctl: Replace basename() usage with strrchr()
Message-ID: <aWm-rSB1I_jyhyMB@aschofie-mobl2.lan>
References: <20260115221630.528423-1-alison.schofield@intel.com>
 <m2a4yee8j5.fsf@C02X38VBJHD2mac.jf.intel.com>
 <aWmtw8DSPCnPSS4n@aschofie-mobl2.lan>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aWmtw8DSPCnPSS4n@aschofie-mobl2.lan>
X-ClientProxiedBy: SJ0PR03CA0072.namprd03.prod.outlook.com
 (2603:10b6:a03:331::17) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|IA4PR11MB8992:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bf9d2f6-be83-4659-1aad-08de54b7db17
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?v2BnG/9Xgmo/ZFKz5XClLrf6xlue/n2L1Ec9l9y6Z1sKqtm0vN9zCFK+Lmns?=
 =?us-ascii?Q?8mnzxN6MYBoW5/S67LnkqV5t6rkgqU/RhIamwXZqzaFzEpzAhKE7qzRga1pR?=
 =?us-ascii?Q?/B2iX040YcqBt0TXY2YdMtni868I95+mOMPf28CosOPKuwqBT8m4aaRU4aeS?=
 =?us-ascii?Q?KKuVR4rqQkvJ5kDdciBnZoyH0fb+I/tDbnUl1rTAfV2yp4t8DA6cg3IFJKk8?=
 =?us-ascii?Q?RUg0xNjbgEQDH34t8bOZ0GdIsksbl3c578PORMgDZbnEYOADiLnnP9lZMyWq?=
 =?us-ascii?Q?C91tRr89RmEKSapm0IER8ymZA/JhSkMBwb4Y4bUm9RRWJ76itU408Wi9+SZW?=
 =?us-ascii?Q?PASCv5vBn5bHXZ5PTCiXuClUdeH+wIU/PIBtJc94F9YMbZDYHdCyTGJhOaFt?=
 =?us-ascii?Q?2Uw/uWZHXc1+3RbQx22EjLzB3dTQmxW5Cp3gf/RSuwM0qSP054OCb6IorCHG?=
 =?us-ascii?Q?UjA/cyw8qk8zlpDYPoulGT5z2rgWmj3unHsZfQhXWbuF+ZYSR0kdBJo3+RJw?=
 =?us-ascii?Q?WUdu+z33IXM6iaViS1seNNclC9NFCIxzlYajxJYJa7mR3E35rgzYgnqN+qEm?=
 =?us-ascii?Q?78se7FVWiIkKvnzk8ETw7tiArZzzKo8f/CfKSQffvoSkKpmgG/ADjQZmvDtn?=
 =?us-ascii?Q?LYaFHOKX5tstQOCvzCUhPzzsk4x+CuXNeszvra1ALhpGfCXyPJIFVEFDwFec?=
 =?us-ascii?Q?n3jzS5t1kLKmhsYVcFqzIiaGuloZY3jlk4Bi7fGZcmwM4eqH6JCKNLFP1iWN?=
 =?us-ascii?Q?id9eRza+ZQwFMJPjpCih70PFy01e3EYmvAa+fnUfzY4rpzMz4f+tPbCA3g1L?=
 =?us-ascii?Q?vR146fKFAfoOu0gA3f/QatXZXcOAKfPLnxfvf+FIPUwRUY7MOd0Gu+FTDKFC?=
 =?us-ascii?Q?HcoaMrvXgCHZZRDg/CNuM0X1uyMRHr+/lDWJtSEVJZLT01sNptIeWpD3Nzcu?=
 =?us-ascii?Q?nZ5+JD9fT4D4c2/R0JtSQY10aTnJeIbOZwBzWqd9cFyirdJczS/dmKjGuwbp?=
 =?us-ascii?Q?+x3P8hhWZu8cC+ogKvdYPoOD4Hi9gfWQ9eFA/3CQ32VjwNYk2Es5BQ/dSgpT?=
 =?us-ascii?Q?G2gizFC2l80nAm7PS3thwbRSIRhil3YmKXMmFr7Y+taZvUbinn8oU3qjFSNU?=
 =?us-ascii?Q?ptw01joWtY6VJ/Ia8GlJ6zqOk5MnuM+8ro0Gg6mbTb1uaOfUAtf+rCLkVcrv?=
 =?us-ascii?Q?bodrBJzBKHMJO5ej1e9nkWiyuQHJBu708qv3gKkDaWCHs256zr6GVyM9/Q0w?=
 =?us-ascii?Q?NQFy/H1vVo+U1c8zvm/iTIxV3KONSXbiC21+TNTq+oj+9WpH8dGFrDIoMJzY?=
 =?us-ascii?Q?D1qVgkEKYwluRKJ6PVdDdfrn/j38/ivcKv5cBCyDOoJfZIleLzuwTHc2O054?=
 =?us-ascii?Q?VVjsyLjBjbrGWAUz4UQQpHYR8DQKEfsOFtfehhswiWmTcnBiVyG9QU+vQiK5?=
 =?us-ascii?Q?q98f3EExlLTbWQK6FpLDLX+2kKI9WunVs+Q1vcXSJpQGkP+Lhjut9mMlUiNR?=
 =?us-ascii?Q?qHdfxL/KJc/+DXS5jOSMZKCoMY7QRbQLTEW2heLK/rJekB9lndPOjMIMJoSs?=
 =?us-ascii?Q?0tonea/RW4ONvsxQR+E=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eK4nnB1Jhg4CBITqQcqfAM4aB2djUr/bpupj3UJUK/d+URKSRLGMUa6jIG4I?=
 =?us-ascii?Q?IbY4xBX057j6RV/psWqr49N8+9+Y6tzA3vHnVErwKi04k087mVXzACNJ0l4i?=
 =?us-ascii?Q?fdn3zHkgsC4k8lb41g7Gu+qJo2zJuB39islu3j4oRKXnCLr1GMSQPCNLVEjS?=
 =?us-ascii?Q?bTtVMpaYAlm06eynNEVmK86fYqEYmMcrf7yAFoGmaesuWCTi82sJaGuflInL?=
 =?us-ascii?Q?0oi8G2cZ188VkJ3+h8X3/fKRNE6Tj8DgBBTjUwvPTXgfMbzWrk2dRaYyyJ+y?=
 =?us-ascii?Q?PkGKvNztt6SX4ROkYrITP1MsyLRkJkhBUFSe40AK0eUYddDm0msD3Ln0STgk?=
 =?us-ascii?Q?OcsAtvihdlU99SX6sHFM0AYxDIXXP6HoFC7c/RvbuDP597EBNadXwYVv0KYB?=
 =?us-ascii?Q?6hNw8nrT/rJODdTUmvUsGc3T9Iy0HMWPlDRsHLc1UR8MaJ2HoV7Q1GaIV7JS?=
 =?us-ascii?Q?dKh3phTSKRS6MMpy6hgc+0WZYTNPsjTbenqV5E+tLc0x5CerWxXn8BN83Koj?=
 =?us-ascii?Q?uVLKubJ8gORr9wPUbyYSLMTB7hhrBKDYPlolfozyRhpcwOE5b1R7kBVAxLZD?=
 =?us-ascii?Q?/k6vjLmL3KgVrthpVveBtkOXGgmRqTVsx4M6558jYFLItBe6xHNbhCLrrukp?=
 =?us-ascii?Q?7y8Ti2MiMgd6ZTOBSqJetYk0z8ucqd0ZQepYT/m85xv57J3EoK/yHHabojpe?=
 =?us-ascii?Q?dKnKH14KCaP9npynnk+Q4RAAO3SWBdndSxni8PZq81hz+s2sa2jHg/XJ7H+p?=
 =?us-ascii?Q?yLtIK4W5VzTt5HLVB/a/u0uWKCaAC21F7WQX2UJnVINSvy9Ua93C+DLhzpOn?=
 =?us-ascii?Q?iGfZt1bSxha5UCpqFqG61GFErvhNZ7bp8B37wTp/uwJAaNNYG5HLK0pZB0FT?=
 =?us-ascii?Q?IvKHzu4c1+cSLEFiowSgGj+9oNn+3PRXNZGrfsqskyeFKfJE05H+2YOQxe8y?=
 =?us-ascii?Q?KTbAxzs3Af9JCvWw1XVhdT51Q0Kd8ykzobkVF5+brIWqof/jyvQRBNLDB7nr?=
 =?us-ascii?Q?KJ31+0Sxu0Zmj+lc+Qs7xMOx2yXU7Azf4W4d5C06+AGEeJEw5+qAv/Yn/Jzz?=
 =?us-ascii?Q?W6FQt0pNCTdGPqzjMQRdBErBlUHQqBoq/POu1Eu70YZtSKiKLYufyV6GorxE?=
 =?us-ascii?Q?j94JnhMFFVBTf+Kk3bWB3DwsDxH+5ZI6i3UGhKTuM42c1IeZDoGkScpGp9GF?=
 =?us-ascii?Q?slARQIQua+0nG6g6hnGqu0kxjrm5iWdDvRXoKcTh/MoakOzVRKTb+CuPppq4?=
 =?us-ascii?Q?Y8XI5/DpxLj4IiQhNCqbiYMbyBSlqhyGcC5aH7okDpl9RPmWDht2FH7Pp4Dx?=
 =?us-ascii?Q?rvWkEfAqPwNwgKJNgVT26hXKoeDeyYsH0Yy3+yHrOYPWLXEUB+uqnS7NJ8kz?=
 =?us-ascii?Q?1vA8efIrmsDUYpPZ1FQEayA+qhcACHaS2IZn4ktAYuc1DL6pmGYdUwFg0a+3?=
 =?us-ascii?Q?bopEpjen1VOiQm9upBiAQjIigoiEA7r/iMB0UwxP8mp7m7ZHVrotpgos5xLO?=
 =?us-ascii?Q?33SoDqbvfQxx+aQcwRKAyKBzVehTWb1XMHsr1QTOPxahzPSQilyyyPNx+Fhs?=
 =?us-ascii?Q?SfMyCMdBwu+V5z4PHNLiWDNlIseSJNw06sMwRvVdf12yb7jd0WwJcUj9qOJV?=
 =?us-ascii?Q?cMCXUWRtUYqlvcWSGCinClLKEfrdcO1zbjmxw54cB8blR8ihop4CmIdCdky/?=
 =?us-ascii?Q?EB4EL/wA2o2TTp3bInfyoMHR5y4Xek147CWnMhomJH12Cz+mgQlKVgghq8Qv?=
 =?us-ascii?Q?llGS9kdjqtGWU+knBUOYVVSHU1yYI00=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bf9d2f6-be83-4659-1aad-08de54b7db17
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 04:29:37.4958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rlYwOfrWR61WX7v2sDxL8uhet+LvmmOIn9OXJwh5YnMMLyXWLs70+UmjW9WByVKZdkYXnUkfIg+94UD8Pc2FotoPCKaUzwZnoNlMNP0PHUs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB8992
X-OriginatorOrg: intel.com

On Thu, Jan 15, 2026 at 07:17:23PM -0800, Alison Schofield wrote:
> On Thu, Jan 15, 2026 at 03:54:54PM -0800, Marc Herbert wrote:
> > Hi Alison,
> > 
> > Alison Schofield <alison.schofield@intel.com> writes:
> > >  	argc = parse_options(argc, argv, options, u, 0);
> > > -	if (argc > 0)
> > > -		device = basename(argv[0]);
> > > +	if (argc > 0) {
> > > +		device = strrchr(argv[0], '/');
> > > +		device = device ? device + 1 : argv[0];
> > > +	}
> > >  
> > 
> > 
> > 1. I would add a one-line comment in both places, something like "This
> > is like basename but without the bugs and portability issues" because:
> > 
> >   1.a) It's much faster to read such a comment than understanding the code.
> >   1.b) Not everyone knows how much of GNU/POSIX disaster is "basename".
> >        You summarized it well in the commit message but it's unlikely
> >        anyone will fetch the commit message from git without such a comment.
> > 
> >   To avoid duplicating the comment, a small "my_basename()" inline
> >   function would not hurt while at it.
> 
> Thanks for the review.
> 
> I'm headed down the Dan suggested path of adding a helper.
  meant to say - Marc and Dan suggested path :)

