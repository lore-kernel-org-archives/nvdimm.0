Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E54B327CCE7
	for <nvdimm@lists.linux.dev>; Tue, 23 Sep 2025 18:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758653541; cv=fail; b=eYtrVeUOpKc/mjSJ/No9s5vro1fothwH2faghTwRK3ako2MvOZa+y+Pf/6Ze3UJlF9CfVgFHKlLyIsOXRhVi0JhgmKpweuGU+jPbRqF1YuZon9F5hObsQLN8cv4Z7UUrURt4LHHBRwPXuZ8ed/634dfKBgmGwDYE4IOfljXZHLs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758653541; c=relaxed/simple;
	bh=eSBDXzwV2y+UVzwVvmX3sP2xU/F/852A9Z6p8S04lz4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=oQldfhHNxomtvHrC8CteNBv6Nm+AQF6C9kSrVY8+aR+sWyfMTYZJsascMnuOuLpj1Y/VFoYyWOSYynhicvZis8wx9eilEf0F30AtyvZk3Jlc6Cskig7kwYsN5w1cjGxBbM9CYCN86TutIuunYk2DTrl8EY761gqvmxsdpV7W66k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lhntMgqe; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lhntMgqe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758653541; x=1790189541;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=eSBDXzwV2y+UVzwVvmX3sP2xU/F/852A9Z6p8S04lz4=;
  b=lhntMgqekPxH6uL449O3JQSoQpFeximATnJnDuEGpHd9mykkownZUppc
   OyrrEVk/WJlynZosHzcFtf7cjTSVOOsa0VmceZ6+0iYLzYmdxDZOgiZUn
   orxxPROJrKDv3Ph6/f/HJ72yOJX2L1ACo84U0Xe2/b+OcbGMAnwEy1PWU
   CozjEPTw1/baB6KsKj53MuqJhWaBSa2xy5VNq4C9tnPVuEbMDKTqXzhSS
   DiWQH1ydrwpURDXq68FLZBwvLqzPRn7fohwBxg5cj02Tuz8rw4z9/F0wD
   hBY4n0FTU+ua+hTURwA2CS3pqqmxu/AAghkSfpsHLEmNWcOhnx6mKkg+b
   Q==;
X-CSE-ConnectionGUID: ++xW9yxxTWSWaHgFBHbxjw==
X-CSE-MsgGUID: 0570b7TDQPqAi+Mk9721wQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="83548597"
X-IronPort-AV: E=Sophos;i="6.18,288,1751266800"; 
   d="scan'208";a="83548597"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 11:52:20 -0700
X-CSE-ConnectionGUID: RgaZb9cjTj6DtoO5XoUurg==
X-CSE-MsgGUID: F+uVSQejRLmrm6THiIQ93Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,288,1751266800"; 
   d="scan'208";a="182103547"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 11:52:19 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 23 Sep 2025 11:52:18 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 23 Sep 2025 11:52:18 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.41) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 23 Sep 2025 11:52:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kGnFYQHqq0XONCZ/O2A46+olzqhvLP8ebUfBlmd7gnEwTzYatcU9bpqJRzdeA1tfvxgA+CHr7amLCWngPX6AmSeNaP3pKcj30mDfwFCBiFkE9cWU5vCc7YpTnda+B8y3/iT8kB9oBVSFjMGDFpIxI2TGH3VeyFhB/vxVRpE7bkwnF+NxT+4W2FmgueRjCck/we6VEpvqP1nv5s18tfarQWLXK0fUX4gX/cj/hjmUyhL+TzplwSwLDCuBYDCXWcvRf1fU57mqinnNvWKZibuwbcxqMUAFQBjdCXQZ4p1+oUsiycAOd1Xc1eJHwBXGB9oF8Z1g+b7AmGdZ1L+iUeCe6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OEi11Y1Yig8xeaNDdSL6w7oirhiTMHwS+tlAGZRUNpY=;
 b=l9Sm5frDoV/TN+i1QCwPrLn5IVUwbbj5IIrFCH9aOjN8zrOpgwy3cB1VDSzsRtUhiDnX6vsXCoRg7gEpH9jfLLJXjg8mTrwnAjagFhP2vtXgG1uIEa2yXx+D7ORX2tlGiJW8CKTUyjhpexcC5fbYu+i/cm1DZbFDBlhabSsMa+GDfTa2TG1fCn872OgWsD4d0Um63BeWVpyYEEmVLM5DK8aPnftuaQyYVHAn1E02nGaF7T2t7EPqSw6RKeSMuPZKA+1SibG8ZpUH1geVeDID/i9Pvchh1RAHbsQwR2jXHo6qSu18K1aCZrAZTIRitrLEqdFT8q/kKF/jPGw1cWtMPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::80b) by SJ5PPFC362E0A4E.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::854) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.18; Tue, 23 Sep
 2025 18:52:16 +0000
Received: from SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 ([fe80::4df9:6ae0:ba12:2dde]) by SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 ([fe80::4df9:6ae0:ba12:2dde%8]) with mapi id 15.20.9137.012; Tue, 23 Sep 2025
 18:52:16 +0000
Date: Tue, 23 Sep 2025 11:52:13 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: Guangshuo Li <lgs201920130244@gmail.com>, Dan Williams
	<dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, "Ira
 Weiny" <ira.weiny@intel.com>, Santosh Sivaraj <santosh@fossix.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH v2] nvdimm: ndtest: Return -ENOMEM if devm_kcalloc()
 fails in ndtest_probe()
Message-ID: <aNLsXewwa0LXcRUk@aschofie-mobl2.lan>
References: <20250923125953.1859373-1-lgs201920130244@gmail.com>
 <767ef629-519c-431d-9a89-224ceabf22be@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <767ef629-519c-431d-9a89-224ceabf22be@intel.com>
X-ClientProxiedBy: BY5PR13CA0009.namprd13.prod.outlook.com
 (2603:10b6:a03:180::22) To SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::80b)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PPF0D43D62C4:EE_|SJ5PPFC362E0A4E:EE_
X-MS-Office365-Filtering-Correlation-Id: 70de4c7d-497f-4e96-f3e7-08ddfad25090
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?6kphsDA2Ku0zOLXjnxR+XNuJ+QCUCHgctnVRwJeFZNvVjK2M4KscF2Z1nrCO?=
 =?us-ascii?Q?y6xtRApvU+Th5IFRo23k/IcbQVyw1E21ZUWsWdYMmBa7cmO5FgzsivdxxHYX?=
 =?us-ascii?Q?Dm7W7+CAGKMBygMTGY0QTNxBtvfEYqoWaDt0WUW7gB94ikdVmxlC/4+tUZh8?=
 =?us-ascii?Q?Hhoppte8j6XDq3kOOWhrsVs0AyK+nQKiEtP+iDGzLFtuudT5QCYZRrt8HExx?=
 =?us-ascii?Q?KvfNto8ZCOtRarsiMRtLp7wm5YXR015b9NGv5VJeCxKz4k4aOTYE5KxMC4xa?=
 =?us-ascii?Q?sJdWYGBczWS4wXRKd+ZoXBrc0V1edjwywwbgEf2UEzLMEyEfZYRFA61kDRQf?=
 =?us-ascii?Q?lRYjTqNVyg53RYPqe2ckb6l6gt9TL7TC9RUErsS2yEPn7c3+wyaEjVi/+C2b?=
 =?us-ascii?Q?lDTmvW6cEuLz4eqgltof0aSQdvfYLw5l49zzMfWzzT5l0DYySDkM3wTlBXC4?=
 =?us-ascii?Q?O+QcyroFAXWjAexSh3UttcAeAXPerddQuD9+y+JS3oeAcsHevd2BPes4XGAa?=
 =?us-ascii?Q?C6nvpv90ieVnBe2PYKRYN+6+wrdYgo8Wvr05/V9salSh1cTbN9yjsizZHr/Z?=
 =?us-ascii?Q?z1OYP9BMHSM6sEnC005BbqCtohignKjjB0IA3cMfKHoXBmm7zw2yZIgzAqyf?=
 =?us-ascii?Q?v6L912OGjRV2hC7WnFYY8s5ic2DvIkl3petJSEz1/ypaKalvgZZZRpFC9+5r?=
 =?us-ascii?Q?BtIzep7v4p+mBDlMyHkzQC5IULs+K2EXSh8tyQNku9LamE3wrnYnxoEAfJ5d?=
 =?us-ascii?Q?Ia2GWxErHy/nA4j+1Ms7aHF9+C03vmqiRO8a/HNqDOqETwl3YjZiCpuBGa7r?=
 =?us-ascii?Q?X9lPwfxriqMZmjIcLbZxtBBHreJaV1NxD+qTt42ujT32l/w9NcZuKtOCcN9C?=
 =?us-ascii?Q?CsiQ+FUb3KPHt2PrC3CmYRS8pMAG07jh1sLt9ewqX19vtXLMb6v/w1i0dGjp?=
 =?us-ascii?Q?bPbBm4hhbfCoHFDO24TLVToQ2zSveoNkR4/9KUg5H53Bi2ymNnxbuo70BWft?=
 =?us-ascii?Q?Vs0rSTnRnUqKJMR9BP4snmw1QmBBi9HFdGNMmCS4zdTb/JkHNsPxZAxMDb5t?=
 =?us-ascii?Q?rpb5UOxWF0NsN+0b3D6U48600GjXeuGr8phyrYTmohoGRUsQZd/9HSURg+1e?=
 =?us-ascii?Q?gvwU8M/bcxLBmwe9L5G36xW2Yazxoh3SbyVJ3RrTXttGKcT/7je6c3r/2g9u?=
 =?us-ascii?Q?GeTonrG/bCDjPGp2Mg0A8/watt8UOBWePx1nOzPKwyJotI9ZDpzDJA6MyjQB?=
 =?us-ascii?Q?vS7ZLc8Mb87c5f2LoaUFn3fcWW9YTkImUY1HIZQ0ovdKkc9b3Nqh3zpSgvX+?=
 =?us-ascii?Q?2EcMtq+8ZXQo925QrejoD/AYZSahk010FJ5+oDZRb7g+nu0RmwjjpekAAR/k?=
 =?us-ascii?Q?2+jU5OFyj+4KYC+Fi4nyfqVQoInGNOwR2K2wD1DcxVSmkgPaSQEeDwEa0o4G?=
 =?us-ascii?Q?gmvKUFLkc9s=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ5PPF0D43D62C4.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?b8242lji/ERKVhJNTc3ROwYceQ2TaGfTOILy9S3YpL0rs3+3cDooorRyH14o?=
 =?us-ascii?Q?mmuaWfqPACpSytN+dyQfWhrXisNUW9c+P9RsO9JK1KBqAc8xM+T/ugGRUbvE?=
 =?us-ascii?Q?QuS4MvutblS2PG8h8rcTcrdYO+xHc6V4VjGdB7Smz5YXQ+1vSQHQPhBSIpbH?=
 =?us-ascii?Q?3d6dhElrufsJf7Yeq4hpMqz0eY+YhB2u4RgZW36upCuBAFVnJlqrMwDPjBAa?=
 =?us-ascii?Q?RR9OIouE4oS2XHyF+ypCn8DVk51dT2hilxhWutw6MEI8wGNr7XDi7S/yMri/?=
 =?us-ascii?Q?/NlqFPmq9yYweSy07WM3LA8c5brXpPRMrWSWl0Wujrf0/k31HwYoj43tB9JF?=
 =?us-ascii?Q?AmdKqxJX+gMvLkA3fvF6Pu8TwB2W/Z81CfsFRYeZaJRGekUOu5Q+4kHTYnFt?=
 =?us-ascii?Q?ChHDmdPLR1IIuyjXzceZ2c5THT1Qks7DhPB/ZcKYloBhTmXupFKmFqVlUfPm?=
 =?us-ascii?Q?lId8Ci35yTb2g7XiZYemgIDAoQZHy5LGh425E3PaHB9BkIrby1My8qENThby?=
 =?us-ascii?Q?N6PE1PfB7BsVp+dWhA7eFWtXP854zbA+KMpxMC8ROs12XrttJjjUNsKYjlO6?=
 =?us-ascii?Q?5WzZ7g9OLjcStp+zkcCkBSbjJCMDp9+zuoabi90Yg9MW62T/Du0dLcz6sWTh?=
 =?us-ascii?Q?6FAmpm2PlUASxqfA5qkjpIOUlLhVX8O/DIVgYngiY2wHmJQek/T/LUDRMShS?=
 =?us-ascii?Q?WR50Wna6klfUm6lWAcz17BbX0NPpM/pGzGt2vzK47/h2+u0kelE/Nj7JUltN?=
 =?us-ascii?Q?Uas03hZMvZLivL1JV18lJ8hnbEqib3A6zzofY4mZHLDaKBL1TvYrDgPZ5Wdh?=
 =?us-ascii?Q?F9a93kHJpsFCrkUwjSwKbmDyyF7d8Dm/Og1wzVT5YHQOoe8SBkqOsfoFDuUz?=
 =?us-ascii?Q?6iroSesiU5lO62ClGZwkScEfjs22ap+g44arG4ndaZMJIHJzMRHWAP8+4B/7?=
 =?us-ascii?Q?278Kli615A4sL06HSw7WLX+zShetrswgrIpGTbn3PU/+xfsUvI+FaT3sERT3?=
 =?us-ascii?Q?ptg0PcKFgfq11K+xqsc9t45K8WF+tw1tPZiKHYZzILC3dpWkDgb4uV5N3r2n?=
 =?us-ascii?Q?PmbrSlhxnlNaI0rAfGak4+zpLX8/vZebBmFnjjTbToeUXnFPaGe0khTzpCzu?=
 =?us-ascii?Q?BF5IkOvBZZ3tDSPCZ5PTnW4nwUJDSczDSLHaBEPGtfrqKAq2QxM7GyirNKb/?=
 =?us-ascii?Q?ASh0+ba7SbWRllMWiPKA1ye6Mn1wepbtZzHHWp/sAxP8hV71Z5YqLO2mHZRA?=
 =?us-ascii?Q?Ej7EH2Ui62uYy95SGjaA2CH5WSwwt+DKqvTy8WHw1EouLFDYSp1VYUKPzHQ6?=
 =?us-ascii?Q?o8eZpw4WotksMa6AC1GiB+0QdJlJXyZe4dnFRO/f8lMkslZiTV1PAQQQLK65?=
 =?us-ascii?Q?wSaIvzynE+vkj+erH1ghfaROvpuYKczhbO928T/h1K7agpg+EJEXwH5AJKtT?=
 =?us-ascii?Q?qUDpiEx0HG8p373TGVLAiARb4S3VDu2I2Zmto9XVT06WCc5mTf8wa1UeAbgD?=
 =?us-ascii?Q?jOXQ7z64Hqz2v1E0GPTccFrn6VolKur75WXb33lyIoWIzZH0acUxm+tSeH5p?=
 =?us-ascii?Q?SAKh8j9tohdoeGztNvI8VHBIwba/tJm4J9q5PRDDGGMo4YqgYcs0liwxcm4o?=
 =?us-ascii?Q?eg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 70de4c7d-497f-4e96-f3e7-08ddfad25090
X-MS-Exchange-CrossTenant-AuthSource: SJ5PPF0D43D62C4.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 18:52:16.0195
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +qUCTmuPAeigvLcgJI2b1Z1Ij3DY4mALFW/z9E0wBOJjwSbh7IFnt+BZX4SfoAOaCLtKtnY02X/2McjgDqwsVj0iNAO5cD7r+QrMpVU4VDQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFC362E0A4E
X-OriginatorOrg: intel.com

On Tue, Sep 23, 2025 at 09:38:33AM -0700, Dave Jiang wrote:
> 
> 
> On 9/23/25 5:59 AM, Guangshuo Li wrote:
> > devm_kcalloc() may fail. ndtest_probe() allocates three DMA address
> > arrays (dcr_dma, label_dma, dimm_dma) and later unconditionally uses
> > them in ndtest_nvdimm_init(), which can lead to a NULL pointer
> > dereference under low-memory conditions.
> > 
> > Check all three allocations and return -ENOMEM if any allocation fails.
> > Do not emit an extra error message since the allocator already warns on
> > allocation failure.
> > 
> > Fixes: 9399ab61ad82 ("ndtest: Add dimms to the two buses")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
> > ---
> > Changes in v2:
> > - Drop pr_err() on allocation failure; only NULL-check and return -ENOMEM.
> > - No other changes.
> > ---
> >  tools/testing/nvdimm/test/ndtest.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/tools/testing/nvdimm/test/ndtest.c b/tools/testing/nvdimm/test/ndtest.c
> > index 68a064ce598c..abdbe0c1cb63 100644
> > --- a/tools/testing/nvdimm/test/ndtest.c
> > +++ b/tools/testing/nvdimm/test/ndtest.c
> > @@ -855,6 +855,9 @@ static int ndtest_probe(struct platform_device *pdev)
> >  	p->dimm_dma = devm_kcalloc(&p->pdev.dev, NUM_DCR,
> >  				  sizeof(dma_addr_t), GFP_KERNEL);
> >  
> > +	if (!p->dcr_dma || !p->label_dma || !p->dimm_dma)
> > +		return -ENOMEM;
> 
> Why not just check as it allocates instead of doing it all at the end? If an allocation failed, no need to attempt to allocate more (which probably leads to more failures).

Following on Dave's feedback and looking at the function as a whole,
it does have a pattern that this patch can replicate:

It does this now:
	rc = do_something();
	if (rc)
		goto err;

So, continue that pattern with the added NULL checks:

	p->dcr_dma = devm_kcalloc(&p->pdev.dev, NUM_DCR,
				  sizeof(dma_addr_t), GFP_KERNEL);
	if (!p->dcr_dma) {
		rc = -ENOMEM;
		goto err;
	}
and repeat above for all 3 allocs.

And, maybe even change that first ndtest_bus_register() failure
to follow the same pattern.

--Alison

> 
> DJ
> 
> > +
> >  	rc = ndtest_nvdimm_init(p);
> >  	if (rc)
> >  		goto err;
> 
> 
