Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7BE7258EE9
	for <nvdimm@lists.linux.dev>; Fri, 16 Jan 2026 03:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768533604; cv=fail; b=F3Gkd2u+DUCROxmQ68VAORD8EtbbZeBGTmfjLxB1jzBmK2a2cix0uAP36YnZlPJ2xEQIgJbT+10KqQBo9+Ew1zVavmRDtSaK2/D/FVfo3ABBt2JXi7nCbmIRxlOnJvwjt29ZMkaieu3aDxH5Xblnk4D0HEx3elFBeyFjEim+Tb8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768533604; c=relaxed/simple;
	bh=I0SrNGQvCmlFxqGmaJFQOAFQhFeDmvaOOJXRWFT65VM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=FnrXPuu0OXUFs9pA5fqohUaou+x5eS/N8Y26yDb3CgfE768uow+8vNIr7wWNT26euqu4JN5xOUW266B6HqKd4B69Qt15/X2TV2SwOsvyTMT+O2kKEQSnHoEqhht0M4mLKlgBjtQgd3sfF80HujOVRyUqPeB3BhGysuRR0SihELQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FHMgTSDb; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FHMgTSDb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768533602; x=1800069602;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=I0SrNGQvCmlFxqGmaJFQOAFQhFeDmvaOOJXRWFT65VM=;
  b=FHMgTSDbDmHKwbE65Kh3Nkjc2vazoiGjnDSpdSTKkMALNEPOw0Mo01kq
   58sNQ7FypOqW+5nhokIvc7gmRn4dYYZ3YHavacnypDmUOGgm/bbCi+Ylf
   hvGDC6YY4J7fAT/Z0/dsfjpZqXMkum1mTxrO6xXljPpVwRyzf8TLMyg6T
   cXRGGZ89nEjoXD0XCqiEOWzBI/U+TJwnEh8KaV2tNK02MCT6lpuOctkOd
   MjDQQ5mXsJ2eYUVh6uI++YrjvGtqIuRuaSmwPutdQuhKhwu9vwertzN48
   hBbp0I552QSwdwC5G+C9pUtpfHtkIzm7pMfyQ8xCoLtLzJd17ko4yieBl
   w==;
X-CSE-ConnectionGUID: QhBfjdHWSOetaffO1wAqUQ==
X-CSE-MsgGUID: 0au6oYdbTAqqEUda2VRGLA==
X-IronPort-AV: E=McAfee;i="6800,10657,11672"; a="80963588"
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="80963588"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 19:20:02 -0800
X-CSE-ConnectionGUID: 8uJ17BiXRw64pqKPQunNoA==
X-CSE-MsgGUID: nK+fcvsqSdyiLpfEzjlUCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="204334493"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 19:20:02 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 15 Jan 2026 19:20:01 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 15 Jan 2026 19:20:01 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.45) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 15 Jan 2026 19:20:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vSi9AobBoprGcJYQvk+OJUft2UYUnDppvbn8m8ybTXWMxnrU2OFy7LpUkqKCRVm2da7A495jBfyBL7Y67nfz9/Be6K9R1zzziwjBireXEK9hHao/wFnxBatdbDRGsbk9W85PzhflHrDAwe8J9STUdR9U3YjI8f4CoodNSSPyS4q7V8nz6EWqwLdy4MuT02ZYoBFtD54c/qSLk9PVHx/5vScGuxdDNP0snEIHDqcG7kuHhJfKDzZCVUM8nmYJFAif3i4xJ1xPGZfSuCK6RUny96CqNaw48T5ZJAJzbkn/fQRqr3RlIhqlLj3iGZxr74nW1Ypy/vTyGhnWG7LGyaCi1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y/2zQHJX2c/c5fIwu/GVGzIblLdaJc/t1tx9952AKqA=;
 b=kMw2Tmh7kOI6+9H6GBxlE+ZEw8pB7Yw55sn6mE4h6w3rlu+NOGNhQ7cAVa9XjlqEoEGusjOWHsYk2GRVv7cttII/Cf2pvmge6yzfkLtEHja0s1kLKZDQpnZwHw6t9oLqj6u42KyGrXBoO1G2qbIfUNHA1Z5O71QPj71jKGvxRKk87CMFdJqjjCvxxM/ofT0VRLMFjmXme/CB3ahCZ4BzvAYFHw/b08mn2UzO4IJ78aybxiyGc5SjIscaLe2GGmg7W+hfLET8hVH0dsJACnhi9ftPKf1BgMveuzr7OJF891kZiW25a266w4ta5QflYvswIFfC1H5656r/TYURVDJ93A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by PH7PR11MB7052.namprd11.prod.outlook.com (2603:10b6:510:20f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Fri, 16 Jan
 2026 03:19:53 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee%8]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 03:19:53 +0000
Date: Thu, 15 Jan 2026 19:19:49 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: <dan.j.williams@intel.com>
CC: <nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH] daxctl: Replace basename() usage with strrchr()
Message-ID: <aWmuVZDKdcyAjP1R@aschofie-mobl2.lan>
References: <20260115221630.528423-1-alison.schofield@intel.com>
 <6969a3941ec49_34d2a10080@dwillia2-mobl4.notmuch>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6969a3941ec49_34d2a10080@dwillia2-mobl4.notmuch>
X-ClientProxiedBy: SJ2PR07CA0023.namprd07.prod.outlook.com
 (2603:10b6:a03:505::9) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|PH7PR11MB7052:EE_
X-MS-Office365-Filtering-Correlation-Id: 2363517f-7477-49c8-02de-08de54ae1da7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?dCpC6d0fQhlHHUXHcGCT6k0CdbpQOcFUpX2G1fuM9aPwUnlywGZC7HMhed9E?=
 =?us-ascii?Q?A96K/ti9M+GKHbiJYPWghP7qNRFrsH+gm6jjlM5K0qXKTIYtWuvbWu3yqpcU?=
 =?us-ascii?Q?V9n2aK287zkOg2yyIiXTeamlKi7GalDew6wbC4R1J5+W7HOb2Nga8cndUuGN?=
 =?us-ascii?Q?z4mtoww6Jz6aDery0YmqjnMmqLP/UR3GsHIwvVx3JSs4Jv2pXb+3YDifFzJk?=
 =?us-ascii?Q?ZfTEdPybVcAdBctmoSmXvRdj6HKqNdx54x3yPCb6WVrEs/q2TieNKDf/nsnG?=
 =?us-ascii?Q?7L5m93pO97/1IKDOZfzxHiW4SyWWPYBmDM175ZbhL+Zd9JW2Tp9aEpMeTv2J?=
 =?us-ascii?Q?8crZgZT4SL702+2tNFBOFff6d4i6mJ94f8thlBsyavgJXA52/6YqBr27wbpU?=
 =?us-ascii?Q?paO07+Z8DGVeIMfNPiu2Q4CzJyu++sXtL7unVkVJF/QPGr1QqXChE6wJMKQ1?=
 =?us-ascii?Q?4vUNud+pRTswiTGS4mCY0gOkQ0y02tDLetnUKdzzWfH444cjOARIB7zI0rFB?=
 =?us-ascii?Q?4OVIKYaamuYuFgRr/LuH/lWdwN4aVxKn5A7OlNySqFlswrNP3W0yKivfkUxZ?=
 =?us-ascii?Q?xiU7REytc6G6aMie2gj3kv5IJZjmrnd49Ei+QRmSax5l3JMS4onCCUBUn7mu?=
 =?us-ascii?Q?DCIXx4ZJSEIlmNl0ZKnpdOImNTUAaq53HoGJvFHK2kLNAb+2dEw+zrPgHz0r?=
 =?us-ascii?Q?Z77jm+B5fWjfEWYrwQghFgk0+JhlNgGOxoOX4hkQRIQYSYDarTDt5+w1K7g2?=
 =?us-ascii?Q?BtPQZ4acdIBAvBgZiSvtr/nnysQsjMBz2jzi10elbu7SLrr/nT1JvDlM4sYt?=
 =?us-ascii?Q?0OssL+7rqwMA1EHJPvbLPtcnE9bfjtpDFDIqNipLMlzt0Bx+patGCAnuVmKg?=
 =?us-ascii?Q?LaAnQe8ZAebWJqSNL85E9SXZHP1AVe4bNBCy3vpCBa0qMvSTdwjkiRM4VRKU?=
 =?us-ascii?Q?H4fvkQbJBFFXT0jEDGT+s2PxIJDIMXJLo7aYFnVdGlf1el6KCxnqbBlPcl/l?=
 =?us-ascii?Q?Mh2/XHJav+AWNLUQXcimCrAgxksvCJHNhBfdldyiizzgd9Dhe8MuG4ez0wJ9?=
 =?us-ascii?Q?3MCyMCTvzSwoHqmOOglzk89MgL37qM9j9xIwMMKU48TvesfJc8eudn3/0ysO?=
 =?us-ascii?Q?Lho0ZpzsQT/5hxeWGws3eCR1cnd/IWB6HMBA9hhSUYWkjOsMviq4xQwbxxu+?=
 =?us-ascii?Q?AToDCzFvcxOgTmhcbz+rlyhJN8ANb9FrZ1D9whDYbPcN1kcSwzoflPPABgvG?=
 =?us-ascii?Q?4422Wvlv4Ku6unhMIAW0r5MtPTVtlrKTjn6siAjtMYYoRjS043EbcbbwtAbF?=
 =?us-ascii?Q?82EYyTbIGjw50e1AM72h3BkAogju5HE1G5ymDtHRbZoPfhTqtNzDbbRdsA8W?=
 =?us-ascii?Q?7FOaGRIMG+VLJdorA7yb8RBcbM4lKcqdpWN8jf7AfdGY7Wi6/xdZcwF1bDPr?=
 =?us-ascii?Q?MJJ0iYSTouXQMT9wU1uKeilBl4jL2obxk8j9lDQJM/U3leoGFId1TBr1xRuZ?=
 =?us-ascii?Q?S5HlVYdCGIvWaS5cMczsRcZEO4AQ26+7ygZdSsBNuUUr+YVUkmSxBQwGXBEv?=
 =?us-ascii?Q?0ftYvGv16teGSOrQRoM=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XiXTJsi3FKvl98Vc+CURKr2mnbWLM89v533r+X5uw77tDkHM9YFTJczKFiac?=
 =?us-ascii?Q?sszbm8IlB5JoaRIkHLD8tAk5trxgKnnNly5sX6rgeZJ7WxLpwl0zuevVErB3?=
 =?us-ascii?Q?O4ALjyULYTGdKu2w/zi0pVlMRGJ/LXhq05d+D/gVWOvDiTRNPQowcgO3X9BY?=
 =?us-ascii?Q?esan5xdskMkCqIu2GWjwQKfFOBtAP6+Cgnfu6Tje35fiB7R8oW7Vt4fz/XkK?=
 =?us-ascii?Q?Gq1+E5xlHmkEV/qRvGBOittfuWUG/vlCSuKvs3WShPgLOJXLMtpNkBkp9LC1?=
 =?us-ascii?Q?WfhmCzKgQV1fGmixFaCV6vPF61g1dg6gxEL4oOpaR9SifzsKxlkCcyUVt1Ip?=
 =?us-ascii?Q?2yhZ8Qshwo/8DL0y0u6mSRH8cublSHnUF2eAUVVK7qbNI6R+ZeKP02hjcxa3?=
 =?us-ascii?Q?XPjbf4XX8kqFLupHHP6GtNIha3u9Bk3u+2X8zJwFcjqe5EJYtMauzxpb7LlS?=
 =?us-ascii?Q?2vRm5sbfm8diAtGPb9auh+59LSBOq0RVBtT1ybxPoY4zf2RLujWpSYXYg8q9?=
 =?us-ascii?Q?ZTnyLffmLg6qmaYfK8D/TGfD68EqigqpJgutiHpHoigpQyBtj1fD0qfVaLze?=
 =?us-ascii?Q?l1ix9OR5CYIudNae1qJiEIaIUysFMhNzaRzjgx8cogM/cQkTyn2JMTmqxptF?=
 =?us-ascii?Q?DMZ2ahjIkoK0apciIWGhpr2V2ytMtWQnJDe9l6cdrWF2tLaFwE2RuY9n/5QR?=
 =?us-ascii?Q?NKa72MyA0D/vmzqDkL7IwtfrM8J6eJAovqY5xwpqnGQEXMVwiDaLUgoAV0WK?=
 =?us-ascii?Q?Dm/Vi71IUxXIkD69V5tCoV80ubWIin22nLd3MMTaLwRHBXFi1XChS3oiZNEQ?=
 =?us-ascii?Q?PYaZ2Mq3QkXixOAJae8fwDrKxUOsCw9SDHvvorUfdy8N1bbRCoK0JRkZeqk6?=
 =?us-ascii?Q?Ok6ehu9q8x7WHbocuQqHKvcW81YH4RxANYfSkvKW2xiHDhFrsLSam+gNlWKn?=
 =?us-ascii?Q?wCOt4Vyk+1aSV78N7wVLVQrSEgKvIRVY+9mVkXVCI6he+Q9JCQfivefjMyyj?=
 =?us-ascii?Q?44AfGppcigBah82NTUepY1T4eDrRpNef0KLp9Mw3IsJyHYkdNjHkcd0Cs579?=
 =?us-ascii?Q?v9UeGSARbvn2GIPUbc6HEb1Bq4E4vyhmEnsIpKdVuhRVakYWbJ68qGo7p+jY?=
 =?us-ascii?Q?0LuVoUB50GnterQ4mDm//2BaQndHKOJaCChhCOXVo+KP24E+tkj2fHHkyzbC?=
 =?us-ascii?Q?mv+Iw8iywkKMfy2AYwLTA1FeTzfKAJ6TyrVQe5QXne2ilJcfyRVQRq/YARZl?=
 =?us-ascii?Q?udMyxsLBmsrMzzImIWKDpOs2KIDEfpNlzEcLI2M5e26nIcJyNSIEqaAHvL/9?=
 =?us-ascii?Q?xtW5N3tjK83uvHo8qh7TF1p/G0Ta37c5aMWeU3Np5+AnKY1a7/OZXSeFg+lT?=
 =?us-ascii?Q?g6gZNV07Slpsih1hJg0ODIxYSYAfs2uFCM4aXvPJ+WwbvnIF1dHXrxZg7it5?=
 =?us-ascii?Q?6itGIC29n8Ob7t5uvDPFMZL9oI+0Z8AYRxC71hSvYOMDZ4f/0LKumEFdp0Yw?=
 =?us-ascii?Q?FXKbQmJA41nrJnYD0d4ej54thR1tHptY1lPXJxAcnYxD+qxUoPt9bVEC7oVV?=
 =?us-ascii?Q?Go1if5hn7+BLd+qUciujt4JNij40A+vJUWsMqJptWuPrvgv0j+BBpP0vB9hc?=
 =?us-ascii?Q?q3fzhO0pg7nzYT9Ulg0P4ZUf4TUCpuSTqfJ5gpUWXAEjngmSMQKoTmrViItm?=
 =?us-ascii?Q?Pb40zauOBFGW6i+8lkuCt52PjUJtHwAIOvR7ZMvXrxWLka/cdqLY+ssICht1?=
 =?us-ascii?Q?AY2Mo3TfHTT5N6L/ITEYspHIs89QCt4=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2363517f-7477-49c8-02de-08de54ae1da7
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 03:19:53.2522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R2Bpdvvp4Y7gX3YlLmbbTNFmIW0jqiGqa4dFUx9wGovxn82UBC260aCMVk+cqjofeFcHa7rrg2IGMsSSkmtzu6IjCz9OPDyJnHRKAmcTsAw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7052
X-OriginatorOrg: intel.com

On Thu, Jan 15, 2026 at 06:33:56PM -0800, Dan Williams wrote:
> Alison Schofield wrote:
> [..]
> > Rather than conditionally including headers or dealing with platform
> > differences, replace both basename() usages with a new implementation
> > using strrchar to find the last '/' in the path and return everything
> > after it, or the whole string if no '/' is found.
> 
> This feels like it wants a helper rather than a new open-coded thing.
> For example, devpath_to_devname() is an existing similar helper.
happy face

> 
> Alternatively, just create a local helper called basename when the
> C-library is missing the GNU version.
grimace

Prepping the happy face version next.
