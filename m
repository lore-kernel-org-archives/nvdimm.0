Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E74142BC50
	for <nvdimm@lists.linux.dev>; Wed, 15 Jul 2026 00:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784073791; cv=fail; b=boJOmmc+lRrL1kKknaq93tplDkSo6zpg3Zc3cRXp3nRrraT8nEgC07IxW3va2t4bSXqm+S5jHV5RVBUCswpiEB1CLyWRkwtm6RgwQtu6nQE/7tpba8fQBQCV81PDJA37nVd0aMD8AOjh9KTo/yYb+zS9q45Zdg4Wk2d/ciXS0lc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784073791; c=relaxed/simple;
	bh=978o+u/bkz7sa+jx+cMrQnuefm+nY7NvjjimhgmJcVs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=RUCMAMUnw/J8cpsQnBB5/UP7EzoViaIQEg1prZJzUBCq2UR5BJpNCy63BFgD+XbBGryMdDm95/jR8LdYULzqroQiTQuQTd2TjrNX70sN1xlUqlL7mmsQbtSJfchGdoUCrWZ5i1P3fFzwFaaAiI09N+bzcnsGWKZ/zGipG5T/nWI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e9TGwFgl; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e9TGwFgl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784073789; x=1815609789;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=978o+u/bkz7sa+jx+cMrQnuefm+nY7NvjjimhgmJcVs=;
  b=e9TGwFgl0kt/Apx8IKf+Ee9z4iVVqRSwFxt0otrk9+p/xLvjaH1OeWZx
   in2PciOvbvtxzw7WLbF6EQuktsou4NNjpaWKle4hH1AabErF1bPCfnTiG
   YDgVi8J3JhcRakatUqIwfUgF2gNGAZCN4jBSQpWBaIdFRG7fImQBzAOBo
   02ESOrV3zIrgNgrKRGD5J1dc8mYcZTtmtkAdwufDJVzOgvGRP262X2yc2
   jysIXkZrBkBSXGiu3syXxYAGoly8j6NOGWDcn+bY6yOuxeYVnZjHal4ys
   L2JHadge9JQp6csX9w8Kejd2XGkHaSiqjcw1A+T5nXpiryE67324nPnZW
   Q==;
X-CSE-ConnectionGUID: uVSDBv/SSlaN97QtEXe7OQ==
X-CSE-MsgGUID: vwiDd6GrQLyc72KLQW+zzw==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="84749564"
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="84749564"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 17:03:09 -0700
X-CSE-ConnectionGUID: fwMuPxA5SRuIXLAxBbhsWA==
X-CSE-MsgGUID: 6rEc2wpYSFSd4IwUZilByA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="251585751"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 17:03:09 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 14 Jul 2026 17:03:08 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Tue, 14 Jul 2026 17:03:08 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.58) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 14 Jul 2026 17:03:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bM6p3nY7Pdm3MWEppmOzodJa5kv7oKyVFDP/WFCgUTKNdy6JQncGovxZCa0p/V0msYMrwsaaIMxUtvfxZRbgV2Cm7RX4tuAmHXpw18ItbI58aqR/Bu9UHkH95hjQOpLwLv9Nv7IDe2CfQ2fV8bEJAxyis4ZrTmyl0NIL65l7W/e2AcmLtR+ue4rPjPQ5hJcNCKJ8JSQ6vkyiJEifINBN3X9jzit1MYtpWZwrZ4qE1euustpcSKEBx0y5Qhc5DzFa/CNufesd+/tAhEKByachzOrDAyFjPHTggrQsxLk9/AxZ9YFhJuZmub8MhwRa1IuoYudb2fXRkW82ewN1foZaVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qrPI/BoBVO+AckZ4fIw/qm++rXvo9HfkYwNVwNAL2dE=;
 b=OdT22RWpEFuM03a0r3Q+59kqCCBJPpqSErnT2f3vQaZMpXcmh8hXsohASwufxuPYDbApC7s7ShSe0GqlUrl5ROBno6br7pGU1aFCkQUkhxA2lySDQu2udXF0HCGnONxNBN7uHfAruzPw7XtqY9f7OO4KzO1NnkKzAWYvjrWaV2mx5HCDLzvos554XheP8THKzNPKi2zm2utQ/S52TrTl4o/hkoXfWA1kY6SDKkSAwCKmVa6DiRS7099qxw0k1PUsFytQ0d2imW81bqU7UhTC6VmKhchgpQs2t+4yk4YbDwqf6Oxsneb2iCkU74Z3dqkmMbfn6lPCv1oUnHfp6+asRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SA2PR11MB4796.namprd11.prod.outlook.com (2603:10b6:806:117::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.10; Wed, 15 Jul
 2026 00:03:06 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%4]) with mapi id 15.21.0223.008; Wed, 15 Jul 2026
 00:03:05 +0000
Date: Tue, 14 Jul 2026 17:03:02 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: <hexlabsecurity@proton.me>
CC: Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	"Vishal Verma" <vishal.l.verma@intel.com>, Dan Williams <djbw@kernel.org>,
	<linux-kernel@vger.kernel.org>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH] nvdimm/btt: reject an arena whose nfree is below the
 lane count
Message-ID: <albONq3ZZqqqa8v0@aschofie-mobl2.lan>
References: <20260620-b4-disp-88b2514b-v1-1-3834e707d232@proton.me>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260620-b4-disp-88b2514b-v1-1-3834e707d232@proton.me>
X-ClientProxiedBy: BY5PR04CA0022.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::32) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SA2PR11MB4796:EE_
X-MS-Office365-Filtering-Correlation-Id: c104b880-8124-4ad4-126d-08dee2047231
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|6133799003|18002099003|11063799006|56012099006|22082099003;
X-Microsoft-Antispam-Message-Info: SKyG/078PMC1gGHo0JTYS0Lm/Cr4O+woAJuULFj0hkBRV/FkyUj3ZiDGBilTOHxwPZSr5vf8nkL7TKlFmcOXHrfK0K6W+K6/9tRb9tPVMcOLQ+KzXheJc2bWcBZf5Mw4bp7v4puQHLjm9xE1v+nilD4yoKmyDuyGJEj28CwhbxCQvlbaFB40Gx/SjcutG0FkptoEMoXkeErMYuizRi8uEHs18mLqV/5t9g2SXxpxTMENDU2mKSCt07enJuPBufCNWdskO/k2zXRFefRmrQSyRL10rHCQvc7eqSojB8kI0XoVgUrM+YKoC+GL9EW0viMlpAhypJt6hPFBHCPCFV6qvrZsPkktr0KuEODy3TCSx0tpfNcJCV42pa8cpyywqvoVGG23nvolHqxm5fpsXy7C+6hNqV381zDodCiz5374JI4TEzdfRV20NHcNcH4Xp82p0TLAqbs15YT48PYaO9n9XmqencVmuGWeA8ec/EAX1Zq87E41fBpHmuOUKkxZJsaAJMDEQ4bOttMzxAKx27+aIoK4nJnNpSlFBrsXgDeOy89/BWYK9wKu0X8LDGTA4ehE0Ag53wLZWgwEUAg4haW41ZVJkx6dcrd1rJtTOsyMp6WN03wA4G833zpmq8rGcZkW/i2QdwSezrkbYXuVGnrfgTWP/lZAcEPgg63mPbvE0zc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(6133799003)(18002099003)(11063799006)(56012099006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JKLG7Hml1jF5UQ3+sf5a73eqObOEi56zGIL1/K7M75pJMgC+dzySRNwlbgfe?=
 =?us-ascii?Q?o7rNKYxhhnexnqQEuEyp1LsGI9SGGg4uIQZZ5uFcs5k/I1SIpxGI1S83p7xj?=
 =?us-ascii?Q?aygpKEHY5zvH/E5F+HBJ4S4abvaeYyLHvTHavZL5pjAqW9U3/7z8OskkFYta?=
 =?us-ascii?Q?hGU3Sc6zrGsUKnu2a+xcSf4zXXMPwnX3G4w1IM9EVUjvvJC6WdlxKL4UFfhR?=
 =?us-ascii?Q?Y9Vux8FiIcPdDp++qUVrbkmRBDfN8jav+NMqyC+zVV1ZSQ2LdPvfizBq41/+?=
 =?us-ascii?Q?vc1s6n7YoAF+aeHjaTWqFXXuiUTGC+Dy3wXB467n5z9Q5oMIFMCU4SKw3CTH?=
 =?us-ascii?Q?IuUASyDHvK4mlZNKOvPC+zwPk2aC+H4iHPsNWMEBlN6GVMxhaLSoP8KpVJI/?=
 =?us-ascii?Q?CkFqn9xj7ot4KJh1Zua88vHd4ko9swxrar7NzUZ85SADG8z2sy3xoRA86T6/?=
 =?us-ascii?Q?YvrqS7CRP5Zbfj02hzyrYCjGjBfdcsRu/Tq/htAeqemzJSfkPPy34ZavtXoB?=
 =?us-ascii?Q?RXCGevUJKBn3PQSS0CovUbJPBJg4jLcDezwdWkYkjBQzkHT6e1OF1229iIsl?=
 =?us-ascii?Q?hH+a84FxAKTsMRB1LisFXgIu4hVbSaZ6BSp+hxvSYOzJcHo0HIi/V57rneD2?=
 =?us-ascii?Q?dauYHZLRu2wl0MljX7CkGBOMqbvhLk2lwA7GQkv+wG0lzxOZzbvQ2bWRIgev?=
 =?us-ascii?Q?LnijgqxlVtnAq+JXOcWgZ2W3vLydAj91oGL0p3gOE0HFpvvyzEizucA/t97k?=
 =?us-ascii?Q?Ra05tnWeTw4kPZqfX4ffB+xu0ynm5x0u/fRtEThP6k7N7mbCOzK6WKPdiqFk?=
 =?us-ascii?Q?PZYkPkwKQqG8xJi1NOH3D8iCgeolu+12bKui47Qx6n/OZcER1PGOzcyqDtD2?=
 =?us-ascii?Q?NEJSJHV7XK7M7drUwW831idPvImY0bWUglfyOaqvVQr24zRfHo7xOvbVsqb3?=
 =?us-ascii?Q?rkWl1KV02SyOTSKuK8yZZCJrfdY7SkP/z2L5jzotVxRZcBHzWlzWS4G4NLU5?=
 =?us-ascii?Q?aIgmAGa/jF3jn/uEZnzNGc2dKGjNc0vlOzk8YhTZElQ9zRIOxGNITxo57Jm7?=
 =?us-ascii?Q?VAoLCrR78hfUjwgNq6YfWKrouO+KhAYslEnVmMC7x5PU3ujFvv9wWy24odQZ?=
 =?us-ascii?Q?q9lONkLGaXhRwzzhWpF/bQWTTXZSZ1+6Mgbu+YIuTSosF8yAy6lgqzK2mvAk?=
 =?us-ascii?Q?wZwGUq7PeOoZzTmk8KpPpVO5zt7/1YqYT8cI6k8waaNgSmXNMrcTQngyrNu/?=
 =?us-ascii?Q?CpFNr9syKS8r/jT8zCRulCh7EAOt5Pg3SiuQ6u+5a+OMN7fKZjTiwtVdFNVj?=
 =?us-ascii?Q?vLQIaWXSkhc+qlwv0PR7qKN4iB/3cw3weLS04OV5ZaV3lO1R5iTChjVaRyHR?=
 =?us-ascii?Q?ji/BDObeFlRB0ikmAkq8W/89+8D0BA0BvZlnESzqNDZopH0FBYCfrSq04i1i?=
 =?us-ascii?Q?GM3i7a3dPUztFoo9uUqT1y0ltV1ao1oZyMXY09tVlR/4lIbfi1nmIcdf05q+?=
 =?us-ascii?Q?Ds1rk3ZJ9cxXOraELfKZZbKJip7LjsV87E+k4yVlBky1DwWWzlSIgLIzoUWg?=
 =?us-ascii?Q?EY5Ndq2nOSbs0/YzzhXJWiQjOVITNct5dgBT9N3Q5gkdBY4GgFHNTPd9Rc4J?=
 =?us-ascii?Q?qwvVgFTwIDIKYZsJD0HxwkczVHQhR20BqsB6sBTlF9GTlvYqF/OJ+xBAISLR?=
 =?us-ascii?Q?s7J10SdBpKdBMAa9ahlb5g61mCLxn3SH4yvigCKQ5Vj1F1zWoA5PufrPvJlk?=
 =?us-ascii?Q?JcuMXikWYokfCuUBPA8P6+YJIBrcfhA=3D?=
X-Exchange-RoutingPolicyChecked: G6UzqtT2Bs/Dy8jANM4EG4G3CGDr273ZVU+3Pm2zGyc/yrE33qnXrh7dQlCbI5swlfpaxXbGelwytbr7NwWdp6aXU0VTaU6KRl4NfaUtYsnfuNA/bevoXMRhorwv6sh7+g7coXsuidATIn0rAsatp9AlfuW6gvazB6vdwxuxBXPa40jQgH8TYaFna8m3VAKN0PXLCuuqXRA+qyYBRGCI5VdVHHghvkfoJuUkEY7d1H1ug8VEXEi19KvWYfxVq6YfxBTmf6MuDLf+KzDoS/7jTq3y2NefOAn90EcDcm3zmodJOlBxFWREoDJLyv7ZgecW8jGIJSA7rIx+qF/donsH3g==
X-MS-Exchange-CrossTenant-Network-Message-Id: c104b880-8124-4ad4-126d-08dee2047231
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2026 00:03:05.8938
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G2kSFWy8nsoetgenUkCm9PDw4sFZ3vGN5AWXwoYTB22FEVXhjAsQZC+VRgacLfJShCVMRUlAOUO8GQSYR4H0vVMUpG5IkUc6bRA8UvPowS4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4796
X-OriginatorOrg: intel.com

On Sat, Jun 20, 2026 at 04:41:31PM -0500, Bryam Vargas via B4 Relay wrote:
> From: Bryam Vargas <hexlabsecurity@proton.me>
> 
> The BTT info block's nfree field, the number of reserve free blocks, is
> read from the medium without validation.  btt_freelist_init() and
> btt_rtt_init() size the per-lane freelist[] and rtt[] arrays by nfree,
> but the I/O path indexes them by the lane from nd_region_acquire_lane(),
> which is bounded by nd_region->num_lanes (ND_MAX_LANES), not by nfree.
> A crafted or foreign arena whose nfree is below the lane count makes
> freelist[lane]/rtt[lane] run past the allocation: an out-of-bounds write.
> 
> btt.rst documents the nlanes = min(nfree, num_cpus) invariant, which the
> code does not currently honor: num_lanes is ND_MAX_LANES regardless of
> nfree.  Reject an arena whose nfree is below num_lanes at discovery,
> before the per-lane arrays are allocated, enforcing that invariant.
> 
> Fixes: 5212e11fde4d ("nd_btt: atomic sector updates")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>

Applied to libnvdimm-for-next:
https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git/

