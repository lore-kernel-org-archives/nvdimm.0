Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD97286405
	for <nvdimm@lists.linux.dev>; Tue,  2 Dec 2025 22:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764713758; cv=fail; b=bvysrADuYg75mBkTbGeDoMd7QPCLl8wvNFyRnF3bIL97dwacNr/b9jfWiws1pf7FXNZ3mv9mQ9m1/wUNu+9v7KitaJyqu8YeykRVrrYsOyO/47qO4dWIFKmFk8Re0iG0TGwptQT7nr7MW9Dm0D/DrFZStabs0yxUFX9TDX9YBv8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764713758; c=relaxed/simple;
	bh=fShzAoRzf0vKUn9aiXP+trJms9G0CC2JQFjBabBuvU0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Hn9JKGUescd29cywiIpoqsYLD2DCXNjIQ4W4xxZ4xmpZDm1/Mbac/f/Sk1nJGroAQ7PUbgfowCswOT2p+ydqWFAvVGA9ITqRcOGw35H3BiXScwWOwV6BtY/hz9eEyy/2vj5pgN9GTwSvkH6cl6ON2miYebWcrRmqULT0TfGJb4A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N4hNuEwN; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N4hNuEwN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764713757; x=1796249757;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=fShzAoRzf0vKUn9aiXP+trJms9G0CC2JQFjBabBuvU0=;
  b=N4hNuEwN0ViL8rsVi4pZ+BoQ5XXJGyZv8Jw5Vo8WQUEO3UwO499bNUw3
   vLfmavou4g46DJO8m0OIRnE9kG1azZ45MvDMTZJPAR0vNt3SoN3fOR/WV
   CbC4mhipOrtaL8ZlNodOAIy2gDoAN+9NRUfnxRrAG8xB1VRTZkB+Uva3l
   7NfiIqS7W+FOR4q9cn/64omtgTrxJWwO8oEVstrboHacNB5i3SxV7lnqA
   iiG25pGQZKfpLmeCuY4zbH1uzeNVnLbgWyaEKvHhEOO+Wbh/NhmtPorBz
   nNRGwZzrM25TnlXswxcx0XF/+CjXFtGN5ebePwjv650qbnm8pOAzjDwQo
   A==;
X-CSE-ConnectionGUID: ARwaYGlTSYSwKfldHzpa1A==
X-CSE-MsgGUID: v527GtKYR3GAcWR9W53ETg==
X-IronPort-AV: E=McAfee;i="6800,10657,11631"; a="77321144"
X-IronPort-AV: E=Sophos;i="6.20,244,1758610800"; 
   d="scan'208";a="77321144"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 14:15:56 -0800
X-CSE-ConnectionGUID: iIICTpmJSLOYFs4F9L7LAA==
X-CSE-MsgGUID: aXEetEQtSqyVLt5BBHIAnw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,244,1758610800"; 
   d="scan'208";a="195291603"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 14:15:56 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 14:15:55 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 2 Dec 2025 14:15:55 -0800
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.4) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 14:15:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a1nh3kF0Qs8MZbYBc7QTb+4JQnW0bRTOnMQwRuWsED+LIR6djaf4dy5xWsTGWaa02Px4g26Gc+WyQ4g6ui9wEhwTSaU6bdoh8DJpExmCK+8b4Ksj/HjDtl2iUqFcgPB49guemIm8a6qlP0XvJKs8In5mu1YXsMQ/9sw88J6cw/zioKud+sfrKzlKJ/j8ks7xue8vv9mrPAL4zlYx5iwIT1qvzQAxQHxyFXNYkMbb2uTc7HGzCyEa4JhFM7HSOCD03maW76SlfGsz3+iJVRB2IQiBBWD5CU79QAYPvvQeKLhTfb8v4Oe0COICvye+T2283Wzj0Ypp0eZeoN9CEaAPNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vun3xgEcqB+sIeA0GFY9y0QKtZXYwOrbAatVMQwoWnw=;
 b=Q7R03j49sT85iv+hYNxIdLMOvp1fHEmuAAUGM2g5EcgJWIm/kX8pdwGLEyM2OrEHiXssOJh2tdUJkDht96yqDLElTpTNlbBXY7zNy0w0g3K3ypz15eOnWC8HFUZeTCayf4obENiIVZINzXMtw/XvIWwbmz4eewXXrxT3wAZyPwhxTxDvuafqlvAq8Uz6uFfNvxneoxgeM92vakKR2H/6DgmCMBr2VM5PaYqboDko4YFB+myls3hwtbmpZw3bq/kpkL/nqsGX8t7MIc9KAnYsQSMkZ2Z4S/LdoC7V9WDfctiOH6g3P6i3ukM0A2Mso4rRZcPdyXFK48bGoFxH+q0ABA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by IA1PR11MB6348.namprd11.prod.outlook.com (2603:10b6:208:3af::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.9; Tue, 2 Dec
 2025 22:15:50 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee%8]) with mapi id 15.20.9388.003; Tue, 2 Dec 2025
 22:15:50 +0000
Date: Tue, 2 Dec 2025 14:15:47 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dave@stgolabs.net>, <jonathan.cameron@huawei.com>,
	<vishal.l.verma@intel.com>, <ira.weiny@intel.com>, <dan.j.williams@intel.com>
Subject: Re: [NDCTL PATCH v2 1/2] cxl/test: Add test for extended linear
 cache support
Message-ID: <aS9lExT_uyhyA8nd@aschofie-mobl2.lan>
References: <20251121002018.4136006-1-dave.jiang@intel.com>
 <20251121002018.4136006-2-dave.jiang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251121002018.4136006-2-dave.jiang@intel.com>
X-ClientProxiedBy: BY5PR04CA0018.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::28) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|IA1PR11MB6348:EE_
X-MS-Office365-Filtering-Correlation-Id: 25cc2dd1-5095-4c25-9c8d-08de31f059e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?CSa+hLQ9SKw13WXIVYJBBgLFiHMv0AN627Vo3IRnWTieUlm27A05dAJEL+mb?=
 =?us-ascii?Q?BNQaKdg6AHLK7Qvnb/M99ibS/hiHXprQY74zAf1fND/RLzIPdtaiiRsx/gva?=
 =?us-ascii?Q?1dRhaPgTM9nIyEC0Hnz7yG3GLuUixtJ1wVXOGJEr+uihRUGBnLnSxZa2fsA3?=
 =?us-ascii?Q?dUvoeG3AWXDuWch20kdQW1Ob4wXpqX7ESL0W8FT4WCH6pjZv0ScRLd5aq5IV?=
 =?us-ascii?Q?jkifB65dwRtp7Wjw8dw7WTIINAhUWdsw4jk+XU0Ac5m3JoYFFlVoeddTI5iO?=
 =?us-ascii?Q?T41ptsPkig2iBKbxr1Mu5pEhiCwWOExznt8adtb3mdhzLgLM16WMhtSzjAzZ?=
 =?us-ascii?Q?qSBGNAqwXpxaIquAVEuaB1N3PQzDiCrBkGRLRGHTTwKzjZVKHPn1tjZxSDqp?=
 =?us-ascii?Q?xzwM/pJaX95uG2VxvK8uck6/oDRkGEzFswGdUpd1rh+qd02+91QYRMnXeD7a?=
 =?us-ascii?Q?Y8wKOo/WTKMLz6V/eBAMld30XlRjnXPnfNkYiCuAaw6m52enAc9ZEvzwwRCX?=
 =?us-ascii?Q?3yDRp+jTQxfGuwBjrCte0JE1+Zm/QdodpzZwIfKnKSIZ9+I5BpgXJrdL0yES?=
 =?us-ascii?Q?1MtquUH5mi+89U9rOtSLJWXSX4EeuYUH1+V9Mqo0iwKVdLctvXBEuP2sMFm+?=
 =?us-ascii?Q?o7cAw7eQdR4A32saQEQG4/rrQ2EEoskGDw7sburdaxvyfkoEXHnngsjJOD12?=
 =?us-ascii?Q?ErfgcjUQlCXzZaoQTfrvKZ7/lG/gTR2AQpES7xTs76Hb1kgaWxP+woz+9i8O?=
 =?us-ascii?Q?JINmWt/EGI4WFEmk39NjdwT1ZcMuRzbYpN6yRH8MCCmDjETp53cy+1V32iPb?=
 =?us-ascii?Q?YqA//7QE+gzdtHILc4qBx+iP7YjQnt+wWjkNmkJ4q7kC/Kjkb1Lzovq/B4cL?=
 =?us-ascii?Q?Gkj6VdqrPHHEFYr3LSmdEDskYoZnISrxoT1w44GKdF3Af1v7QocQu+BG2/L5?=
 =?us-ascii?Q?qVW4FCxEC9rLdaFU2rzJfRZzBNVjR5hjI4t53ALAA2SkKeaOIODoTknZvSS5?=
 =?us-ascii?Q?vp3E1+wPK8Kx3/GVQTr4FuSWk+2gvT0hZynOWWTAefWbnC1AN02AZ1ne1yoa?=
 =?us-ascii?Q?Mm/p4b9c51bvpADyHuqZUWUHT3UTG0TxlEHB7lV6mZlE4O2QkAhObAInKdE/?=
 =?us-ascii?Q?ejyPgRmFAqI7Hk7A8j8rETQ9WvXUC2XqAc1D00aCF2yK2ERpatokwMOzuR56?=
 =?us-ascii?Q?Fphhjo+sJzks1iE6YECIxKlmKz2ka8k0FTwjNi7nXHn29O1WQq9FOIK1VfsV?=
 =?us-ascii?Q?UKL9ppcFUYpOH+OSO3vaQiWegc77HslhpkVAfpy3jZptgAOZl+auKhKccxrs?=
 =?us-ascii?Q?tA9vBL8h86aGYJMWGyfthZmjM0Fq0tNfWt90+7ftdExO6py+e9fnitC7qb75?=
 =?us-ascii?Q?/seiswVvZtT9j3EKmAWE3agZiKAJphCY12hhGEY+NiY7U2Q3/r9iBatA/xLs?=
 =?us-ascii?Q?z28hRCzFav1N06ZQkZOfpCPY8o5ceTYeeOQPRrBWx+OTCL3X+mHG8w=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LTjgvxcjbbDr0b50DXaScINswu00Kp8NOt0tILlovhgU9RVLN9yduaDVcxaN?=
 =?us-ascii?Q?y3IU+XzyX0B5q6a0gLtgFVQx5p5vIYyS4nVBn5p2s3rCYbnbqk66IH1D9s5m?=
 =?us-ascii?Q?N3u+AuWNFI5jlyn4yI5ViHxz//epEUVKzeN344RTCqR8MxLDXtN1riJmD/QR?=
 =?us-ascii?Q?sW2GlKPx3bQKC4JiEDWmfjGWh+t4mWw0DVvSpzlXo+PRr3y/Y+O6HsIrNtxg?=
 =?us-ascii?Q?CI5ZD/1uiTWfDxme+KpQYaQ5eiLYILKt2jTHVJ4Lorh65GYc4+cvyt+g7DiR?=
 =?us-ascii?Q?ZJwiBaIA4PLEhZOO1JsIRy0/Nmq8OOSV8iWYyOhgTDVLZxtowC9rzEftUYFi?=
 =?us-ascii?Q?PfaMNp+H1Y1tSBC7QGfGTIbrcM9/B46YTRb9xeW0ZU1wiqdngjfzv9SO0Rr1?=
 =?us-ascii?Q?gUmJPtZ87YcnYEXVcEG48XZVQeMty0f+UzxufRqyksvo24XIrPaWoNPVe6v+?=
 =?us-ascii?Q?Khi9A1lrbEI1bK5+KT8Gvy0bCr6ZsfnKG856OhCPgwwbWlVi3vCrJfTYVKEh?=
 =?us-ascii?Q?DYAnRlGMARWk01wPaT956fmvf1QWSKHtHOOY+MIBT8n4A/iUmN88dqfLTRYN?=
 =?us-ascii?Q?fH6IB3X6klgSJf0tmhokPlPu7LhX+ddNzMxhjODc26w8L5LCxOeLsVVuVHE/?=
 =?us-ascii?Q?yFJFr43PLVdHsNZ2mkk1lbF1bV6KQlRQi9+OdPkwpDcoKDhn5tZJ5ITaav+f?=
 =?us-ascii?Q?HG8HHL7VrkuV3i7fOD/DCjZDbe6ooHcMpxsE9rR1B1Dke6pBwjELMrOJPooG?=
 =?us-ascii?Q?rLLoA9mDhIn2LjY59K3Ftk2YcKEHDwKWMnK5tAJWlKVj7cJuIbiuJIzN5XL8?=
 =?us-ascii?Q?RT/Af06i60qrLt5Kmu5CCP/EmUScdQ58pa3Zf/C3wM8XkUmpWbV7hpztFWjl?=
 =?us-ascii?Q?mO6VOW53Cgn99u0eAf7wER4DUG3ATckH6t8knNAqvbp+cJdilx8y5bKgF2Lm?=
 =?us-ascii?Q?8dWMHS2JamlMJpZo87t88hrzwEX3/PiW9UwdDQ6+GtbWJjGGM01I2v+gC/Lg?=
 =?us-ascii?Q?5w/NGTaFt09wlh4OmrTFe2r5BxYtCq6iErnAcDv3wy6EvwHaWAatAeH98eom?=
 =?us-ascii?Q?I94liUj3YhNDVztiJRG9OvcY0D3zpp4d20Oo2Wm22jAplWJhoEy8VK9zJdF+?=
 =?us-ascii?Q?qtEsU1HJSDv7RT66OUdtuQ3mzPlk3LSrSHlk2dnZkQmMje7KkEP6NtkR2N+u?=
 =?us-ascii?Q?gag66DkmoJ1HbuYQt+dHIKGhZiWbiEnN+hrtJ2wSTxNkAgjn5TRsN6R8Je6k?=
 =?us-ascii?Q?oOxJM58JDcjFQowUidehzgmZSqS4rtdhY8KdFnWkADnFWPMF0S5ePeg+X8YI?=
 =?us-ascii?Q?O9NwKlPjTBKqBoW+Q01mbjJQF7qd5hU9ah6Ps6WOaGng0wqoXohFP2QFXjqW?=
 =?us-ascii?Q?QJT3k93bMGmHPfpZuihZY0zVG08Pryvgm3G7Aakn+SsOfu0pkn1nENEyFteB?=
 =?us-ascii?Q?pwNaqkDQqL/NtXwTUpN+cAwMyQAVIsl2c45ypo4/LlqLfzg0nz1D/jqUsegT?=
 =?us-ascii?Q?kghLQlJrkVUihuQja4dx9ejxhWdXCut95AQ/L5s3auy3Y8jIX6VfWjpzdCVz?=
 =?us-ascii?Q?XPzjGXWV3fFC+a5/Ch39dIbLP61CKAYCF0BalD5OsRmw0JgeAMaeCDnj8doq?=
 =?us-ascii?Q?LQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 25cc2dd1-5095-4c25-9c8d-08de31f059e2
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2025 22:15:50.4922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dkpe0C1PvSK6xKQ6uw+eDn4gjw5dlxon3wVVSePQuGxOHrfil0Rj3Bl7tsRCSeM3Oml1JwtNAGSlu8b4V8dnbwyb3qOZjitJvh9y6AMIwMQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6348
X-OriginatorOrg: intel.com

On Thu, Nov 20, 2025 at 05:20:17PM -0700, Dave Jiang wrote:
> Add a unit test that verifies the extended linear cache setup paths
> in the kernel driver. cxl_test provides a mock'd version. The test
> verifies the sysfs attribute that indicates extended linear cache support
> is correctly reported. It also verifies the sizing and offset of the
> regions and decoders.
> 
> The expecation is that CFMWS covers the entire extended linear cache
> region. The first part is DRAM and second part is CXL memory in a 1:1
> setup. The start base for hardware decoders should be offsetted by the
> DRAM size.

Thanks!

With this [ as: remove CONFIG_TRACE check ]

Applied to pending: https://github.com/pmem/ndctl/commit/39085f7

> 
