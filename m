Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB6A385524
	for <nvdimm@lists.linux.dev>; Thu, 19 Mar 2026 20:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773950633; cv=fail; b=GidH5E+BNfwzmNLxVOulPxqjJogaE4bHZCMZxuhF/ZDAPMLCCODsf362GP0E79Kpn5Q+0eAMlbi+ezpPMZndiCyMfObF10jM1y8eKoT71QRqMxIcIeLa7ONNC0nbKN60BhbnOkFiMSlE2TtAtmv1N8lbmkaE2XlZHJD7xXEWOSA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773950633; c=relaxed/simple;
	bh=ID+xlafgbNg0rthNm63T2T0D8XwnJ1Xy7CRFt3cm2Go=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=brMOzgMQvxTh+eoPWZDzKGrD2uzmAse66dQ6Ci+G88+LqnQQxhJHZ17IVOXIZ/ylKOY6IiUPkK9wLBlm8AN1KyYVNvcbspxhMRi93QEop/9QCdLurXMerVOmZHd8olNbsBD0j0VczC2Cjpu0kZZ3e/BE4BpmzrL8lwABFBB9Lro=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GAclMrIm; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GAclMrIm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773950630; x=1805486630;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ID+xlafgbNg0rthNm63T2T0D8XwnJ1Xy7CRFt3cm2Go=;
  b=GAclMrIm8icgMVkxaFag4KCnKWI5Lwo7bcuyLxxBTKRQCuDEMphNXqTF
   cRC9EkEXzKZ7AH7czNVnQavzPvr6WiVNSc6o9/Sco8/T9ADYdkfzglDlP
   THCLLUHoKgZhXyTD/+234PtmV/RWOEvOqSo7wWTmpRxRyg91oz0mCgdeY
   tPJzZc8mfIp2kgqXl/TophAvc0vo/Pyei9NBbQWYY41hvBz73kae98CUS
   I1J8oaLdD/ISbgIhahJbjb+ZITDlZDBMzBFvy1RTZGlFqkQeFhrUgDSQ5
   jIrEFIgHecr6agYx9BQhaqIi6QZ7+3bqrBXVIhi2E7k2XbsxZKNRWxSKr
   Q==;
X-CSE-ConnectionGUID: P/B7h8bySLCeqjaWvylquw==
X-CSE-MsgGUID: p2lKt7SxRcqA4hR4+wteUQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11734"; a="86512220"
X-IronPort-AV: E=Sophos;i="6.23,129,1770624000"; 
   d="scan'208";a="86512220"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2026 13:03:49 -0700
X-CSE-ConnectionGUID: MVlrbA53SRClyiRpB2a8ww==
X-CSE-MsgGUID: RLOzgXwlTaezLU68+onOtA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,129,1770624000"; 
   d="scan'208";a="228018361"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2026 13:03:49 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 19 Mar 2026 13:03:48 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 19 Mar 2026 13:03:48 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.57) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 19 Mar 2026 13:03:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KchyTRMUCdHLnPoe/ZOzmTA1fMk7syXVuCuGbFIg1wQLNk8uY5Cn96Sf/6iTXqHSviRj8OrQ7/uOTTr1VMywrOnAGnNS68sR6A7QY8SkNcMN2HGy8avLa1hs04DLinhsStyPyl6vP7zTbtKENRadAQ3XjKjD0EE5n9nOlhwsejPmf2eAHpIses/rucTvoR4p1XqxKxsrK8zJQ1l64CqAfS6FLvPFog8s1V6vG+OjksvEm9Kzjs5bVnwCxR1JYIq4zvQ3KMQxdWLJnyNrFCycYoqwSG6jDCyX4I8WTpGcqKRk6Dv1wmcfNafNHfQTxS0Qy9kwiXkmMoYmagTFtkwQ2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qWXyfu+hxLi5XcIF2E8NBUuppYbz3B5BEJ53MKUAWBE=;
 b=NaFVnRfR6k/7RDvEl3iMHiH9a78laoCVhcAG5swg8BcX6gmA4UDNPH3XCAfxZVs8/SpSRzH3w9DFQCXDS1xyzc3/Bau2RKBZ2RN7PEZQmQQejOgrM74zKXeOTvibnSAgnk2aUS79CRAZUa9wfMieJOf3tvYJYunVCcG2TtUSuSqvETaSiP/ybXWMelJ1vQFGrWwRhEi6puCB7KI2E7uZpgawAxDhaLh0YGGMnmqW3QUGUTXREDCdm/EasFC+Y6uX1o1k4mCzn3JSGmWjvydiCkUHYkgWjRifDN4xiLSOFOVT7JcEOdi1qBrlKeMm1yVG0djQNJonnDPu0yCWWfo/JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SA2PR11MB4860.namprd11.prod.outlook.com (2603:10b6:806:11b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.9; Thu, 19 Mar
 2026 20:03:44 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::3979:c00f:fdca:b895]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::3979:c00f:fdca:b895%4]) with mapi id 15.20.9723.018; Thu, 19 Mar 2026
 20:03:44 +0000
Date: Thu, 19 Mar 2026 13:03:38 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
CC: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>,
	<linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-fsdevel@vger.kernel.org>,
	<linux-pm@vger.kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Vishal Verma
	<vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>, Dan Williams
	<dan.j.williams@intel.com>, Yazen Ghannam <yazen.ghannam@amd.com>, Dave Jiang
	<dave.jiang@intel.com>, Davidlohr Bueso <dave@stgolabs.net>, Matthew Wilcox
	<willy@infradead.org>, Jan Kara <jack@suse.cz>, "Rafael J . Wysocki"
	<rafael@kernel.org>, Len Brown <len.brown@intel.com>, Pavel Machek
	<pavel@kernel.org>, Li Ming <ming.li@zohomail.com>, Jeff Johnson
	<jeff.johnson@oss.qualcomm.com>, Ying Huang <huang.ying.caritas@gmail.com>,
	Yao Xingtao <yaoxt.fnst@fujitsu.com>, Peter Zijlstra <peterz@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Nathan Fontenot
	<nathan.fontenot@amd.com>, Terry Bowman <terry.bowman@amd.com>, "Robert
 Richter" <rrichter@amd.com>, Benjamin Cheatham <benjamin.cheatham@amd.com>,
	Zhijian Li <lizhijian@fujitsu.com>, Borislav Petkov <bp@alien8.de>, "Tomasz
 Wolski" <tomasz.wolski@fujitsu.com>
Subject: Re: [PATCH v7 6/7] dax/hmem, cxl: Defer and resolve Soft Reserved
 ownership
Message-ID: <abxWmg_iCN7yxQ11@aschofie-mobl2.lan>
References: <20260319011500.241426-1-Smita.KoralahalliChannabasappa@amd.com>
 <20260319011500.241426-7-Smita.KoralahalliChannabasappa@amd.com>
 <20260319142910.0000113d@huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260319142910.0000113d@huawei.com>
X-ClientProxiedBy: BY3PR04CA0030.namprd04.prod.outlook.com
 (2603:10b6:a03:217::35) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SA2PR11MB4860:EE_
X-MS-Office365-Filtering-Correlation-Id: e8a93308-4049-4cef-9a45-08de85f29fbe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info: GoniySVHiOkc3e6nXCsK49LqOWCbB2Ua06pnO4JFJuJuEmYTa0e+RVDhxJ/Qbc+vMufXJSxVGYoGhFnGEr5PM2eKGQ41GTMO5SX/lICXfCrb2a+LzcgIM32a9hkS7qVgeZiFokUHEAc6cP4OPtqnHM9PJxut5SZikCQD5SI2FCqmXLn8jXs2VmulS2aPAW77Lv7V+tdlKWCKSRA45ST4nscdlX0zPcoSMRdfx25r1/vArw9cMqxb30L1TKKwmDZ/eZX/W53NbegzSmXyv7DIprKDLSJLkcO8sUyzDNSvfbpM1EBWJfUDzjzN9Oatq4yXxD098AZ5bl1ew2+9rGudfGcSduwG0JCMLU8bnt5hbU8mW+xWjcpgEpEAs+2bJH/Iyc87GYVIQBZ75AWMKKfRpYYaesE9As63eqIbOHTRlXDhRtiYCnJLvQrX9k6k9t/53emEHWFaZnhDJ5zBsy92i3xJomIIpJ3v6BqXCRoB+LhDX63Yz2GrqG507dJJPDnfzNZc70DgLCbM5reAjDU2qEzdDIpebVq/+gCjbxhJTEpuDbITFl96bS28ILVDnWq8U5KZzyKlbujYyLqYvy2hA8eeBnIsP9ef5bcicaaBGyqawirApn3r0HCsEFuCLNPjzs4mmTOFaQqNWsheVHFMZYvSYnYL4EeXZJBjjTWmTZdU6EXqdQIaYPOecpvjdkI/Pfa7o25WjSgoSNlGD2gSo/7EV+kzamS82RLWWPrFldU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?t+mAvBDEzPdDcb/iHSlhzldbteFoztsecP1WIKrMaUiIjArv2rWbw14RXN+v?=
 =?us-ascii?Q?MwpQY2ll4F+dId25UWJ4pp3K/K4F9zRRNbssc0xQdVS5mguj2jh2WWIXTaO3?=
 =?us-ascii?Q?jruUxw93H5x9HRxXabh06Zhi5km1vd4HgBr7Ao7AtaRHt/MsdOfTRP2BSSZM?=
 =?us-ascii?Q?NwWBBTtdlHLlGfGPXz8ThzVKKUcAcDH9qxkuHxUYl6rug2dvyrvCmAbqNZUq?=
 =?us-ascii?Q?E6pSWR3GN4JQ76wKyR4oTtBq6zY7JYjKQ6KgYVsG8Uhx6t+IseltoKLGZEQj?=
 =?us-ascii?Q?ED6S8JCVW5rJyc7fVAGptesT1ybtpJt1fBl0TiFPjSIchh1YqklONnGwzcp/?=
 =?us-ascii?Q?cEurcU1r6S4G0kEiU1kjO6RXEv5dwOaRqpTTbZ1XokNzkk6xQZNxQOvQueNC?=
 =?us-ascii?Q?RKpfszzUA9VJgxLfiax6fcOBHA3KLiVOAbxt4wOauWAoMxqt+wEvUAUw/Gk3?=
 =?us-ascii?Q?94wez5Ye6w90k6UK0eQ8yL2ATO2V/qT3wBdJCxpChpp0Bv/C05rdtqiobgO1?=
 =?us-ascii?Q?ZBkYSYHGos4L8B0o5hcTjpe7SAYQV2nIxhwhTZscLMufhm2TE58idetKnZe9?=
 =?us-ascii?Q?Q8z4X5lWLrR1ih68k11ooe1Z/WB40s4XdntXtlSKK3vNXRHmYSVXQRD/ateq?=
 =?us-ascii?Q?TtFe3jCFwxnTXO+1f3k12ararBbRg8mVcRnMTbAPj+iJgUNnl7HaIy4fXZ94?=
 =?us-ascii?Q?i5sthpDIix1elHg52AalLe34N+2kZpukL/tbZMC/Lmw/qPo39IJ9dzsinl9X?=
 =?us-ascii?Q?wML8JeXmjj2Hr3ibCTHM7XykRwcyRF/m9Dgkqvre7nM80ZKNSjzoPVhnb/ot?=
 =?us-ascii?Q?kbvMbIri6Dd25DeQ1O8mt9QvqDNJIhu/133hYIr1/7Fzgteg8lJe0btnnQvM?=
 =?us-ascii?Q?EZb/1OFdWIa5AWt11ZplzouWjOOQbMVWzXMsn1V+WrqCBvVV62UcW5kwGY65?=
 =?us-ascii?Q?6HHOrzCXdINpFMFSaEBJg3imyNcMumFsYd0un64Iu/c74v3tGd7YGk0GSU6+?=
 =?us-ascii?Q?NbYX+syDvHdi88yGCqEbqCHeBF6xurgL1kB42l2ythjAnzGRRIh3iSc2u77F?=
 =?us-ascii?Q?6qwyb5VohVg2BvBhdyzwaHzlDazDZHPpxoSNRS41/2lIp9aI3uIbdaqnoQ4k?=
 =?us-ascii?Q?38Bg4e0BinFtShuQd/qCNjejEdR0Xv/CGT6/pvYGiYsnxbDSiZ3gbqt+rMKM?=
 =?us-ascii?Q?a1l6AFvO7Sp6cEn1It8f3kAHau5U1p7kWwmrJAsIfATX4riS0nkiMrJ27z7c?=
 =?us-ascii?Q?irevAdUVAiDHp5QLy6UUqJvtU1mDwnwVpuS8x1vrlZXsJTVhRgYldgLSq51+?=
 =?us-ascii?Q?kKQiOO7QPCgXvP+9k7YTy+I/cY6sEyaxBK8w+5CJk5Q3KZ1CEcTljzVMVVlu?=
 =?us-ascii?Q?H6STb/sAkvKex1+XhpDGX0RB0zoxSClh27ZsSNdZ4HSX5DE+FyokBkai4pV2?=
 =?us-ascii?Q?HU0qqTnsGZHcf3HqAwaY6AC4OTjlq92Lk701ooej59O6FcKKiXIslH3Kgkf1?=
 =?us-ascii?Q?Q0nKC6TN5gBOYUM7t77cyYxLBvSlyt4DGGkWqwvgv8zoRphq2nj+4ZGuXG3B?=
 =?us-ascii?Q?wVnBrsFtr3C+B5r4NsHLfqXNS9aMtMoAj3KTFc7WMLjrmSvKXg4WLbAkx+lz?=
 =?us-ascii?Q?apMo0wOJg1Dlr+dGyJkmazOFJuRofR0OdHA06JJj8VV8S5fCyNoI/gYTzb9V?=
 =?us-ascii?Q?usZFbDvL/3Sx8+wmJh87T+1YRa8t7hDKOedyTCCuQXAgITXpYOhWyHeBFeF2?=
 =?us-ascii?Q?fvCbYjqytKbnmHOPL4gYq6fn9CmlyLU=3D?=
X-Exchange-RoutingPolicyChecked: ZEJSt6VuMl/6cLVdsx2LNqdy+Yt5FK/FFafwyvLC0h0CnzWYxdfXi6U8kIHr6LMKtJuHDIzbVsC5ERHlwOrfOoTeVFMF0EGxwA81smy2jZpA+yYzH0j1R1M6dRWLaMsbirDGuPf6JRN8yDhQxxwQRQ0u6X4zt0l/nCVlSwpaAI3boLcpNR/i2XtIDSN6+bg7hdIcg2S2Jpz8DQDiRhQjiunUJtJxZhvHOxNJcTPreCmJsx9vLalv8Usg4i4UO8l2BMHnaJfae/iP43Q56jC0MDzzcjcWYWgRV0UxmauLmzsq8plRLqcdk2OgmRYpvVhcEmzHd/8wk1GkHa30mbFjxw==
X-MS-Exchange-CrossTenant-Network-Message-Id: e8a93308-4049-4cef-9a45-08de85f29fbe
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 20:03:44.3880
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B6k7YfMzMIF1WsnyLNMJTvkdsIY2g7+yFFWdbvneCDUSxVpEKit+e+X9kEDHCjo5xoQkNxfqjg6txjzqxRSbCz/hcsTrkyW4sb+3qjPWpPM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4860
X-OriginatorOrg: intel.com

On Thu, Mar 19, 2026 at 02:29:10PM +0000, Jonathan Cameron wrote:
> On Thu, 19 Mar 2026 01:14:59 +0000
> Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com> wrote:
> 
> > The current probe time ownership check for Soft Reserved memory based
> > solely on CXL window intersection is insufficient. dax_hmem probing is not
> > always guaranteed to run after CXL enumeration and region assembly, which
> > can lead to incorrect ownership decisions before the CXL stack has
> > finished publishing windows and assembling committed regions.
> > 
> > Introduce deferred ownership handling for Soft Reserved ranges that
> > intersect CXL windows. When such a range is encountered during the
> > initial dax_hmem probe, schedule deferred work to wait for the CXL stack
> > to complete enumeration and region assembly before deciding ownership.
> > 
> > Once the deferred work runs, evaluate each Soft Reserved range
> > individually: if a CXL region fully contains the range, skip it and let
> > dax_cxl bind. Otherwise, register it with dax_hmem. This per-range
> > ownership model avoids the need for CXL region teardown and
> > alloc_dax_region() resource exclusion prevents double claiming.
> > 
> > Introduce a boolean flag dax_hmem_initial_probe to live inside device.c
> > so it survives module reload. Ensure dax_cxl defers driver registration
> > until dax_hmem has completed ownership resolution. dax_cxl calls
> > dax_hmem_flush_work() before cxl_driver_register(), which both waits for
> > the deferred work to complete and creates a module symbol dependency that
> > forces dax_hmem.ko to load before dax_cxl.
> > 
> > Co-developed-by: Dan Williams <dan.j.williams@intel.com>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
> Hi Smita,
> 
> I think this is very likely to be what is causing the bug Alison
> saw in cxl_test.
> 
> It looks to be possible to flush work before the work structure has
> been configured.  Even though it's not on a work queue and there is
> nothing to do, there are early sanity checks that fail giving the warning
> Alison reported.
> 
> A couple of ways to fix that inline.  I'd be tempted to both initialize
> the function statically and gate against flushing if the whole thing isn't
> set up yet.
> 
> Jonathan

snip

> 
> > diff --git a/drivers/dax/hmem/hmem.c b/drivers/dax/hmem/hmem.c
> > index 1e3424358490..8c574123bd3b 100644
> > --- a/drivers/dax/hmem/hmem.c
> > +++ b/drivers/dax/hmem/hmem.c
> > @@ -3,6 +3,7 @@
> >  #include <linux/memregion.h>
> >  #include <linux/module.h>
> >  #include <linux/dax.h>
> > +#include <cxl/cxl.h>
> >  #include "../bus.h"
> >  
> >  static bool region_idle;
> > @@ -58,6 +59,19 @@ static void release_hmem(void *pdev)
> >  	platform_device_unregister(pdev);
> >  }
> >  
> > +struct dax_defer_work {
> > +	struct platform_device *pdev;
> > +	struct work_struct work;
> > +};
> > +
> > +static struct dax_defer_work dax_hmem_work;
> 
> static struct dax_defer_work dax_hmem_work = {
> 	.work = __WORK_INITIALIZER(&dax_hmem_work.work,
> 				   process_defer_work),
> };
> or something similar.
> 

Just confirming this stopped the WARN:

-static struct dax_defer_work dax_hmem_work;
+static void process_defer_work(struct work_struct *work);
+
+static struct dax_defer_work dax_hmem_work = {
+        .work = __WORK_INITIALIZER(dax_hmem_work.work, process_defer_work),
+};


> 
> > +
> > +void dax_hmem_flush_work(void)
> > +{
> > +	flush_work(&dax_hmem_work.work);
> > +}
> > +EXPORT_SYMBOL_GPL(dax_hmem_flush_work);
> > +
> >  static int hmem_register_device(struct device *host, int target_nid,
> >  				const struct resource *res)
> >  {
> > @@ -69,8 +83,11 @@ static int hmem_register_device(struct device *host, int target_nid,
> >  	if (IS_ENABLED(CONFIG_DEV_DAX_CXL) &&
> >  	    region_intersects(res->start, resource_size(res), IORESOURCE_MEM,
> >  			      IORES_DESC_CXL) != REGION_DISJOINT) {
> > -		dev_dbg(host, "deferring range to CXL: %pr\n", res);
> > -		return 0;
> > +		if (!dax_hmem_initial_probe) {
> > +			dev_dbg(host, "deferring range to CXL: %pr\n", res);
> > +			queue_work(system_long_wq, &dax_hmem_work.work);
> > +			return 0;
> > +		}
> >  	}
> >  
> >  	rc = region_intersects_soft_reserve(res->start, resource_size(res));
> > @@ -123,8 +140,48 @@ static int hmem_register_device(struct device *host, int target_nid,
> >  	return rc;
> >  }
> >  
> > +static int hmem_register_cxl_device(struct device *host, int target_nid,
> > +				    const struct resource *res)
> > +{
> > +	if (region_intersects(res->start, resource_size(res), IORESOURCE_MEM,
> > +			      IORES_DESC_CXL) == REGION_DISJOINT)
> > +		return 0;
> > +
> > +	if (cxl_region_contains_resource((struct resource *)res)) {
> > +		dev_dbg(host, "CXL claims resource, dropping: %pr\n", res);
> > +		return 0;
> > +	}
> > +
> > +	dev_dbg(host, "CXL did not claim resource, registering: %pr\n", res);
> > +	return hmem_register_device(host, target_nid, res);
> > +}
> > +
> > +static void process_defer_work(struct work_struct *w)
> > +{
> > +	struct dax_defer_work *work = container_of(w, typeof(*work), work);
> > +	struct platform_device *pdev = work->pdev;
> If you do the suggested __INITIALIZE_WORK() then I'd add
> a paranoid
> 
> 	if (!work->pdev)
> 		return;
> We don't actually queue the work before pdev is set, but that might
> be obvious once we spilt up assigning the function and the data
> it uses.
> 
> > +
> > +	wait_for_device_probe();
> > +
> > +	guard(device)(&pdev->dev);
> > +	if (!pdev->dev.driver)
> > +		return;
> > +
> > +	dax_hmem_initial_probe = true;
> > +	walk_hmem_resources(&pdev->dev, hmem_register_cxl_device);
> > +}
> > +
> >  static int dax_hmem_platform_probe(struct platform_device *pdev)
> >  {
> > +	if (work_pending(&dax_hmem_work.work))
> > +		return -EBUSY;
> > +
> > +	if (!dax_hmem_work.pdev) {
> > +		get_device(&pdev->dev);
> > +		dax_hmem_work.pdev = pdev;
> 
> Using the pdev rather than dev breaks the pattern of doing a get_device()
> and assigning in one line. This is a bit ugly.
> 
> 		dax_hmem_work.pdev = to_pci_dev(get_device(&pdev->dev));
> 
> but perhaps makes the association tighter than current code.
> 
> > +		INIT_WORK(&dax_hmem_work.work, process_defer_work);
> 
> See above. I think assigning the work function should be static
> which should resolve the issue Alison was seeing as then it should
> be fine to call flush_work() on the item that isn't on a work queue
> yet but is initialized.
> 
> > +	}
> > +
> >  	return walk_hmem_resources(&pdev->dev, hmem_register_device);
> >  }
> >  
> > @@ -162,6 +219,11 @@ static __init int dax_hmem_init(void)
> >  
> >  static __exit void dax_hmem_exit(void)
> >  {
> > +	flush_work(&dax_hmem_work.work);
> 
> I think this needs to be under the if (dax_hmem_work.pdev) 
> Not sure there is any guarantee dax_hmem_platform_probe() has run
> before we get here otherwise.  Alternative is to assign
> the work function statically.
> 
> 
> 
> > +
> > +	if (dax_hmem_work.pdev)
> > +		put_device(&dax_hmem_work.pdev->dev);
> > +
> >  	platform_driver_unregister(&dax_hmem_driver);
> >  	platform_driver_unregister(&dax_hmem_platform_driver);
> >  }
> 
