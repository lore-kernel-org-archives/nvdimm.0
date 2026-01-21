Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047C025392D
	for <nvdimm@lists.linux.dev>; Wed, 21 Jan 2026 00:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768955535; cv=fail; b=egi0XYIZlC7wM4ufv7aeCEI+JM+cqwSbZpdYgRg83sAzcow0HDjxS37pxN3fUMV/Gxq8YZjgnJbJevKXhnz+z3Z1ue99n4htG+/v3fdN5UOfoMnl8D2tNMQ9UZ8tpcouz+yB1cbZoOD3Pw12EAuvmTcqSFsqAYA4vUOGNArVrig=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768955535; c=relaxed/simple;
	bh=uK6jk3K6ZZbxpE6s1uPz7dUf4Q0uVID0klZMUydl2iQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=T5t+v34LiMxARSFDyJF7zPmOC3qleSJRNlFUZi8+xoMdl9AN35+3IyRJIn+zc3Mti1QtE7fcW6A6fKvkzt0EIfUmZFGEqK8EZhE2GiQY6CXjrw5dJxhf00cIePALwEIihyioAGpo7yKn/eHctey1L3HLJKfsCLo2PBhLiwUN6t8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PQvqPYdN; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PQvqPYdN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768955534; x=1800491534;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=uK6jk3K6ZZbxpE6s1uPz7dUf4Q0uVID0klZMUydl2iQ=;
  b=PQvqPYdNF+dLWh5fD4joHDb2OOJlq7Vi/CKrd7qtOl35mwn7YunppO7Q
   BGzPWp/lvzhC6PTMk7tjaGdoCno3Qpphpm0r5brgLZlIDD2d6UfwsYaxk
   Oqy8PExgLFnapWBlftHlPRp93NmknP6rQPUQWLPyiCIaFkn5+K25i8cJY
   zByvbk4Lk/Kxtx3Xs5IHtSJxi5O/t5SPbbY7PoFkRnc0VMR1kvQYlytgr
   GDk99Nog+VTGSRLI5GeaEPn0QnzH2vKXdUKULmtvxGZYVn7ffJO2bZOCN
   Zno7O5pNSbL20bhGv0Va2cso9Sepfu9ePqbbsoUhpvb8Qol2bLGZ7brS+
   g==;
X-CSE-ConnectionGUID: QPjgsu/yT/u+TpvnB5XXxg==
X-CSE-MsgGUID: 7nc5k61PQTGAVfyHDo/Gnw==
X-IronPort-AV: E=McAfee;i="6800,10657,11677"; a="87755205"
X-IronPort-AV: E=Sophos;i="6.21,242,1763452800"; 
   d="scan'208";a="87755205"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 16:32:13 -0800
X-CSE-ConnectionGUID: /4Glj4IUQVez24flJF+dZg==
X-CSE-MsgGUID: z9Sxg/PBRsmlRtw1h+ed3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,242,1763452800"; 
   d="scan'208";a="206187834"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 16:32:13 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 20 Jan 2026 16:32:12 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 20 Jan 2026 16:32:12 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.44) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 20 Jan 2026 16:32:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t795IlVcRma1h5zKKteUCIlwTu9MS/lN3roRlv/o3D5b6HVBuChWeaOJ9t2PdKR+vKj1pXsX4dOWZzqLu95LWZ5Yr8hcMH+gUDZKq3dbBl8AgeOrGZ2dbQWgaoMZbLwkBUsvTz0Zvznc992F98IDEKF/3h2K1Wz/bgefkhpdqGmQ/ul54WmIqKsgU//Y5BuIhlMRO/JTHPuWwp3aBad22wdQnnrNtczG3p5I9j7fZHeWls/lZXUfQK6JPMpZh/6UHw1SHyHzXbrQ9F0wXH0LvuNnLsv4281UH2xYAyEuoELx0nAJVmzzWaaZ3Cm9BeFMKjF0HV2LzSWpk6XrE37kbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NQe1P7GDTUKkMvCnFb3ioZbjcmLNxzbB6xfEWgGQEO8=;
 b=ptulIcjoM3XyZ0/0PwVkdwjhreVoFOuxQ5pu1ED78yZ+GL2YmNlVBIBZOVCmo3TxWu8kr94Dj5gnJNy6G5WD2qImVJmuhMu4LZ43KTGL7/JZoAc7mq36N2LnR/hT6ovPg9fS0B8ASNPwfBklIuNpfelbquINtZXTYjN9904dHJgKQN/YrILZ9/KJQT8LThUI3Yblh8exooHh+EiclJQwUQGaKmpy4cN6fy3OjVMbJi00bIJztEMXLt7gdBBOdBtT3uW4hq2Un3aoHlD2rBmHp6m50Ss0BnUmAWY+z6p4i2wFWuFyN0saEBqKRDq/ZPwj8L8dvNZ9NswtpiswXOEaUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA4PR11MB9131.namprd11.prod.outlook.com (2603:10b6:208:55c::11)
 by IA1PR11MB6348.namprd11.prod.outlook.com (2603:10b6:208:3af::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Wed, 21 Jan
 2026 00:32:07 +0000
Received: from IA4PR11MB9131.namprd11.prod.outlook.com
 ([fe80::7187:92a3:991:56e2]) by IA4PR11MB9131.namprd11.prod.outlook.com
 ([fe80::7187:92a3:991:56e2%5]) with mapi id 15.20.9520.011; Wed, 21 Jan 2026
 00:32:05 +0000
Date: Tue, 20 Jan 2026 18:35:13 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Neeraj Kumar <s.neeraj@samsung.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<gost.dev@samsung.com>
CC: <a.manzanares@samsung.com>, <vishak.g@samsung.com>,
	<neeraj.kernel@gmail.com>, Neeraj Kumar <s.neeraj@samsung.com>
Subject: Re: [PATCH V5 03/17] nvdimm/label: Add namespace/region label
 support as per LSA 2.1
Message-ID: <69701f41c1606_1a50d4100b5@iweiny-mobl.notmuch>
References: <20260109124437.4025893-1-s.neeraj@samsung.com>
 <CGME20260109124503epcas5p27010aaf98c7c3735852cbb18bd68458e@epcas5p2.samsung.com>
 <20260109124437.4025893-4-s.neeraj@samsung.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260109124437.4025893-4-s.neeraj@samsung.com>
X-ClientProxiedBy: BYAPR21CA0013.namprd21.prod.outlook.com
 (2603:10b6:a03:114::23) To IA4PR11MB9131.namprd11.prod.outlook.com
 (2603:10b6:208:55c::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA4PR11MB9131:EE_|IA1PR11MB6348:EE_
X-MS-Office365-Filtering-Correlation-Id: 7cdad6b9-4f45-44f1-c115-08de58848072
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?huRDE2Bc4bfMvwufbru+B4WxotYN1o66o3xjqESlH2rxm1pAf4vnyJWIa9CX?=
 =?us-ascii?Q?TShm0hrYQS0JIhjnAqTMkGMPBZWFdnyawbWPa91cLpPQauT2xhuIfggLmM20?=
 =?us-ascii?Q?GpcTykrXTkXbtkviFC9HFAvurjDKseefYW6oWOF4qGUvDfingUar42qZJYe3?=
 =?us-ascii?Q?7ZG1hK543CFmZvURgHnxc4wkaXrn3M1YzllZJYmbOUnh1HfUSlm2TqKbtkdu?=
 =?us-ascii?Q?O1+YmRA+iwX6CDtH+U2omSah2PnzF3OXI4KZUwThRfjShUgh6OLAJ7qGEn6n?=
 =?us-ascii?Q?+Tw2pbNumztA+/dtN7ynfzMTna0VwL02ASTfINd9czuww4499Rg0eu3Sugs4?=
 =?us-ascii?Q?uLn5FelbuKfD42HJYLji9RJJhD3nhataMBPU7ecf8bAUn5SV7JcR6is4yiMZ?=
 =?us-ascii?Q?PKLkILwTsfeApiELSMCKLiIfKOX4Qo6oxeH33hXa7l7ZpTnEfvRufY4aAi/N?=
 =?us-ascii?Q?D/MTM9+pFiQRY48MUvURlsstWHwIBOAROAKj9JxPdWHhqaPEUc4bGRQfBy/5?=
 =?us-ascii?Q?B5yBy2CmGEA+FEI5D0WiQnkr7BKQXKAthC/BAIsq4lEIlGIk/f4CmBKzOmua?=
 =?us-ascii?Q?mFFD5ldNJXVAZCLCwuMMRH7zIEZqbb0jGeu5BlZqOZ756V6RJGyrsYcIQb+H?=
 =?us-ascii?Q?TSjHxTJZIzN5MJdaf63mAc8wYnXf+JMmbGXXpplW6Ja5+di5GQml5pYMnpnE?=
 =?us-ascii?Q?EvcvN7+jdlrYtFC5PB4p8c4O0HYH4JkM5vJnO66E1OLwJkvaL12jKMcOj25i?=
 =?us-ascii?Q?UNAQd2DzDg86zcIM8wm/q0W+TVf89zrtSAsqutUm4NbX+iqcIlphtjHrg44O?=
 =?us-ascii?Q?dbYAlkWRIjK+tFnYStSaou1i4130NQ83WfMI4syumm9IDWknlvDjqd8r/mYD?=
 =?us-ascii?Q?6qQQF6PxjPpRQdXEhGYV8DreIOWe3PZEjHZcnOIuNQjaMu8TTwJpWnxS/96i?=
 =?us-ascii?Q?xeP7V4BGSszCm8lkiP3i32XQd1R+PByB9dGwG2Mu1AmCG5l5oH4dGNnNKAx2?=
 =?us-ascii?Q?nTRpspjbs7lg5Dh+Q7WEnO8lMznCaAV1PxsHUje4sZjPqedEZMa7NzB2msFp?=
 =?us-ascii?Q?hCNM+jF5O1xj/kOBINz6b8EwqVgk5IKXnC82/pYkhi1WlHJBDuml3/eya+Yz?=
 =?us-ascii?Q?iplGfl/9dyb0yEw0q/JroNn5m4zWx4DFU5n3w0mCxy33z6gU70zbhMrJlxVp?=
 =?us-ascii?Q?1ntWRAKwAweJEOJb1yk+D8uaRHcEjuNWt7jY87gR7X3SAIgxqEuqc7it27wC?=
 =?us-ascii?Q?LqYXOdB46469UHoXVQ2SPWBe2rzGzSoWGE7/CR2GhrliBvGM86UQAEyMpG71?=
 =?us-ascii?Q?ksyxsdTg/BMxtjvvDV48VudzKkyIILA9XSF2LUDgwq234TvJBnjgUv+97PT3?=
 =?us-ascii?Q?d5IozNPAMZuTeeHlSl1dT5zUl8hSZWOtyVKVzTWCv+Rbui5pRcblaMaw38wM?=
 =?us-ascii?Q?tY6Imee9BiluZpsLzeYMlCyBMZAgEc2YVab0T2U7t51uFnGQl2cDILSuOjLV?=
 =?us-ascii?Q?pILKfTryUS2OGCF38SgyDc64mviR48Sd4rSXdJHetB42pivH05Fd0BOg0+SD?=
 =?us-ascii?Q?okDJ9yXwt0PgZ+Xy7mE=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR11MB9131.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IBvKuPNk/qqoN1t6zPgUjDmaUgCTXYvbjXY74vsnb1vxRNhCnu0avYpsaPBZ?=
 =?us-ascii?Q?77dnyudLC3xsWWrkWpPxwIrsdPP7Dn8RodNby1Hn6TmRvTrcK2xjB6HKsZkw?=
 =?us-ascii?Q?8IayRJqHUCvvzvxKT7IE0rnCjAPvxK7ebqOmIwBBVQ1MPRQPJz4Nosr7Y1z1?=
 =?us-ascii?Q?ukX3MNj/3jnRq9jfwT0dQ2XfhhOLjjjnm/lN5OO0CU+yKkTdySz8AAS7mX2X?=
 =?us-ascii?Q?MteTOHv0oJ0v7bGcloY6jVyOEeh/9LrDs3qIqx+IMT9jRyOsm54L3a9u0UMG?=
 =?us-ascii?Q?KdjU3YdMOwzPUABWw8kY17aJfYBzamwXpNSAGb0lyZmOU/2FNJdpsTzFyUrq?=
 =?us-ascii?Q?uSpJHEjaH87EfVpsM5vaEM9Q8JEEIvGiSoXP1VvaNU9+kmCs9ggC+onRf5HI?=
 =?us-ascii?Q?dSoIg9PF/OXrO6bPN9kmbd5AMwbgPtk2p9tQ5HFT7b56cAV9/n+hAJPBRRPM?=
 =?us-ascii?Q?R6IW0qx0fM9Z4izR5O9IpW1YhE9Ael9EdlDhFP06YYpLZs1zFndiebRi3Xgk?=
 =?us-ascii?Q?tRlf/fbHcba0VxXJew7GfBYitbhhUvdCZ31Ca97ZVoDJNAkbh7Yug0vmNozW?=
 =?us-ascii?Q?w56P417AqNKD+u10uMTlg3Fj8ycTe+b04rPGYnOwHc1RcXiWWKwyGhORYDXG?=
 =?us-ascii?Q?vGMAwGyrNNZeDfwWxQxnATim73UeYu0n96+uHlRVFudYCdfrRtQRacwBRr2j?=
 =?us-ascii?Q?9uoFeCBzSDenNglOYAJfcJ8l/7DSPC/havhVg4PYukE5aXz6+8vAfiPnGt9g?=
 =?us-ascii?Q?FXfquLiuaUIquN28BfREzAgTmsG04bngNvh/8Tl/MrF56ESYOgRojnbIpqQn?=
 =?us-ascii?Q?1Gp/VtcfzvQX12zk9gKCPtN8QA7WJ5KfaOcsaY3ah8+rgxbtdbqprFnihI94?=
 =?us-ascii?Q?At7FxCBgcaCLEREuN5DqjeCxNUKGRCxPNlxBDfYJlZzhnEUBzDHuDNJrsfc+?=
 =?us-ascii?Q?PvjdZfU98/XzQxJVQXXlrCkcI3LRkW5ggh/QhhLAxian6Sdt8wIFLRFw6J4W?=
 =?us-ascii?Q?TPAkypUx8lkDwpibgDygSjT7/PNvHLJrwml4kUHoJsc4kiSIU3k+TWLMliw3?=
 =?us-ascii?Q?uXs3A/Hplb5ZCCSiL1OrHR9q7IAqGWVHDo9dLquopkd6K+79PE0Aoouwbxpi?=
 =?us-ascii?Q?HHA5mt+qfXpVavPV5fHz/EoZn1P3DSLnZEo9XJgGg1+jIZHTBUU3GKUtTm/m?=
 =?us-ascii?Q?/YXKKNkPYZYDdJPKGcyKeSYGpmRyFvLctftfSIyyvzIV25646UAWxR13feOf?=
 =?us-ascii?Q?jBdoY3BsLbdpo1+tEYBl1bjyhebDnLemJIRwPN73S7HdCk9c56qVRopNRbQB?=
 =?us-ascii?Q?g0mIkJubjB5R75lhKZ1emuAqlYXXImiY3kjHnOM6PWMxZ2e4eeO14QkSBQPI?=
 =?us-ascii?Q?SUT4MKw0cVaBGA0bAvgPUpOoBsmJRzJXdhsEr4imL4RwvMHP8VZPAnZ9VgBf?=
 =?us-ascii?Q?wWe82hlzUy+A9BEBjJur2p166ZIlWmvoGvaScyvTrTjyD5IWHp4/v4wBto5/?=
 =?us-ascii?Q?3Jg3VZuFgxM6ii6XKFsN/7343TPIsoFHjMuyOiC+Ci0s8a0BJGE7psQFLGd/?=
 =?us-ascii?Q?d/wpfphy9gnDfpHrMOCChgIfDeIE53wzjP4DLDkF1A+ydAjMYuTwqxBFKjPg?=
 =?us-ascii?Q?HXKS7fSPKVA98CYSj5ZzvGvSSZM8sZuOZE7SS0Gz6lCMYUb0giMSIm0PBiVd?=
 =?us-ascii?Q?e0bDJUhMpwHzUxi4wY+ToRH/M2Yk1JSsWZoLeRHHSSDbcqhWP35vwhdADutw?=
 =?us-ascii?Q?6PcsVIeFYw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cdad6b9-4f45-44f1-c115-08de58848072
X-MS-Exchange-CrossTenant-AuthSource: IA4PR11MB9131.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 00:32:04.9235
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jkz/lJmRVuPV/WlCcAitxdArZImkn4HtGNMmBH3gcVTBb+4SrIZFmU9ZeJRIRu9rBMZDPGkd6wMy0ttAl7N7tQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6348
X-OriginatorOrg: intel.com

Neeraj Kumar wrote:
> Modify __pmem_label_update() to update region labels into LSA
> 
> CXL 3.2 Spec mentions CXL LSA 2.1 Namespace Labels at section 9.13.2.5
> Modified __pmem_label_update() using setter functions to update
> namespace label as per CXL LSA 2.1
> 
> Create export routine nd_region_label_update() used for creating
> region label into LSA. It will be used later from CXL subsystem
> 

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

[snip]
