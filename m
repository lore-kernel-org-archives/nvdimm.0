Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D274436D51E
	for <nvdimm@lists.linux.dev>; Tue,  3 Feb 2026 22:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770156071; cv=fail; b=uDESAvCk4RiQtJhOfzs3GKh4nqOF2vvyeE1g9e9ph5q0aVzcezxbZBbu0KD1aiulM2MpgieRuu4EHRsdCddR7CzbPLwG7ka0zEanSUX7D0dKbO+ERAsFB4U8xYC760xoS1widbvviKiOY53vp3xzg0EkB+/CYLBD4Y2IGeZXEfQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770156071; c=relaxed/simple;
	bh=dedPX+/Ad0M7ZVO8klVSAunD1eJmPpWS80VKoZeYIwU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=btsociZ+lBqoQPfZeRMOq8QAAK9YVKQGID+3hVSlW5s+VgXOum7zDEYveJCuOZ5dj5nOmGhQmxOrTzzIx3b0Ms5p3MhpYMld9JqVCbzFwW0RiAc/nqFJrp4nOcr/iu9s11Da5hIKcZIpjYFuA+LrOVXa0vTcURTg3gqyw5XshDk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jDbCaKx7; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jDbCaKx7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770156068; x=1801692068;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=dedPX+/Ad0M7ZVO8klVSAunD1eJmPpWS80VKoZeYIwU=;
  b=jDbCaKx7CgFGXi6HC7m0/g8EHnb7dghIQ9OBLRDwd5SK1mFEQtkdsW7Y
   2tTt9hEEjdPvSh/iHrdWzWfzyfBqaetzR6XlS6aKQbUOiYlLhFAeUd00c
   EABu4letKsgpnrYN5xx9R+vgKOKP9ZW0DkDhkNVrnldEVDiX4PU5wsx/x
   OdIQApH4HQKkqPjOBvRORAuNGY8G92BfI/Xoq8BiEJefWfMSp7OMNOcS2
   8s8dPMd1IqKgkOLpfMuywJcCif6WjzfKvz1DKYRbUOs5ZCh7rVEeZMPGo
   RHfNGhZmEGZBnX12RLraY9KYpLm5gpI9nfHJOqvzzcWKDAYLxCjz8wR0o
   w==;
X-CSE-ConnectionGUID: Lyqx31j1RwyInfPho9NUDA==
X-CSE-MsgGUID: ioufKvlpQ4OFWyAiNQ1eTQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="75191739"
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="75191739"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 14:01:08 -0800
X-CSE-ConnectionGUID: rvjRAiYQQFGeGDr6QPXcGg==
X-CSE-MsgGUID: p5Ct979JS4y9QLi1vkZiTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="210086880"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 14:01:08 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 3 Feb 2026 14:01:07 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 3 Feb 2026 14:01:07 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.22) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 3 Feb 2026 14:01:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QajkhEExkI7xv2PCSfxwOXW6ReoDZhD1zuIG/4RZSluBw4oZraioRAef6m4HdpszdG1GmaT7x2ycGrs3gg9cb8IvRQsOl6N1lADVGb+/C0hnCNnqa51u2fY8qxVVtCACGLA+obMlPx4zQyCvRSsxQgEfEcrPur2ks2N+iGWkZhVjZjhyRfqsAiveZkKFy28jHNnL97h0t4UefPrJCEyaBe4yYaYpK2p2XPV8g4S2gcVI5u6e1I4CH9aQCWRExODsDpSh+xPx7ZjsSlFzV2WLp5QBm1b/CZu8ksjyPMFN2hpSkv4Ei9pvhndg8czhxQJ8Jp2Mf2zgOAurponR+pWiGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M30rtKEL0qyLP4WL8tGLP4bev1IZ0cdAKibxdar8o+8=;
 b=ZoeWCTqVdyg+8rw13BbT5QNszH4O3Cmp92T9MiSpXPorHikkwrhSXtmb28Zvj5p3w2TLzhAPYd8l1kC6TzWLplyVNutdt4Ufa1LN2R2oZBiB0jW3MeCQBBM77T/OFv+phxmLPbDaHJgcenPtv0U7TIjGblR0NvCXD+ol3yt+uw7dMhP6mzmTqAFcJbud4/GbA9HdkNa9xaabrr7YO4wof0LanSyPLzchZrK8U1MuJG6xXyEVsjHG+uHwzsjML4XqkCCOr1Ps1fJWbckZVvsATybDwqM6GAaxVFZbK1wM3iSN85+wg+16QAGwhFpGnGTjHXyp3QESppJ/ZMuFxTzLvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by SJ0PR11MB6791.namprd11.prod.outlook.com
 (2603:10b6:a03:484::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Tue, 3 Feb
 2026 22:01:03 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::1340:c8fe:cf51:9aa2]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::1340:c8fe:cf51:9aa2%2]) with mapi id 15.20.9587.010; Tue, 3 Feb 2026
 22:01:03 +0000
Date: Tue, 3 Feb 2026 16:04:23 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Gregory Price <gourry@gourry.net>, Ira Weiny <ira.weiny@intel.com>
CC: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, "Jonathan
 Cameron" <Jonathan.Cameron@huawei.com>, Dan Williams
	<dan.j.williams@intel.com>, Davidlohr Bueso <dave@stgolabs.net>, "Alison
 Schofield" <alison.schofield@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>, Li Ming
	<ming.li@zohomail.com>
Subject: Re: [PATCH v9 00/19] DCD: Add support for Dynamic Capacity Devices
 (DCD)
Message-ID: <698270e76775_44a22100c4@iweiny-mobl.notmuch>
References: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>
 <aYEHmjmv-Z_WyrqV@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aYEHmjmv-Z_WyrqV@gourry-fedora-PF4VCD3F>
X-ClientProxiedBy: SJ0PR05CA0006.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::11) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|SJ0PR11MB6791:EE_
X-MS-Office365-Filtering-Correlation-Id: feb8ec05-44a1-480d-1c76-08de636fb916
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?uMxd1M3yZPHailPDswIVEJenDuq9k2YSDT0zMtCdniMZsFdz6f+x0IqXrQnQ?=
 =?us-ascii?Q?+iAKqjWMHXqdge5xtHYLUn4tkFhzwYximPh/RTP6m57HGDHv3mwwtuCfaPfu?=
 =?us-ascii?Q?GhQLG9Snebx4CVOMr6IdJExoMn1/23qjuPvIY9x6ED29auwu7tLR7un0PESu?=
 =?us-ascii?Q?vuqpl/KmdT7Qo5ziCcwkBWYoz1CqHYKh0k+WSws/A1weMyOSqUXJHX18lzfk?=
 =?us-ascii?Q?rUY4iE4tZTVoGw0WgCREq2f/9Xu35bgTb7CyckfyPzhKaEpru7nGpuwr837j?=
 =?us-ascii?Q?ca2Lx63Pu2FRBMHWPom34Ub+qLglIi/RkDJvuy2ZIoTwd22gbvbtXQIIA3K8?=
 =?us-ascii?Q?CpIFQJ8scaJWxDmssyrq1kEGYJ137kxH5e3M4/oB+8C+xNqFOK1li1qc3q3L?=
 =?us-ascii?Q?4Q0fdyjOkdwpt95wE9IF8ZjMan28GvK40ZvqyXBfl35YOlSb+LZ7xZEcHqN1?=
 =?us-ascii?Q?hEltQCovugSf7ftEfNsmFgryVAXSMJMERExcHGSZ32d+Bw2Q5n7JUx4Njk6E?=
 =?us-ascii?Q?NcNFaZdiSvEVBqFTjUnWvmU6ujw3uwupjTfn9MgitHejc/+i2hhW18fb3qIy?=
 =?us-ascii?Q?FhVgewuFy1peb96oHjs6KiMAolNApy6Uii3YyImHJTf6BhuyLaU4qJQDLIr9?=
 =?us-ascii?Q?iqRE3DNZ8jUNHTg1QmTSDXIIrotkg43b9EBAR+zBsOmaJmOUJ2Q+CR8F6QmS?=
 =?us-ascii?Q?W/wbrEL22HBdmMYe2urFQd83IiUSmxgoZIVWVG0Ku9iOJFQa9elncuPhV+ot?=
 =?us-ascii?Q?PrDFrjtB7fvDjz/BrdcekbR5b3espgh5e5VUwAtOzDYDorei6HMMGfqGtiL7?=
 =?us-ascii?Q?6ZF39r1GfECdTZzL5CQ/C3wLNQYKj/2J2rXgL07X+YC/5xmfXbU107x6hogU?=
 =?us-ascii?Q?0JRWzkgirwbtTtePyBCxsadl6G1Db0zYBgCk/Ngytj5fznBMmMnzrc02WnLt?=
 =?us-ascii?Q?OQ8vMNEjGSonQfm54trCK7rwpZZON4bAmfjpkfN1DlxR0C+CcpGgM79P/61E?=
 =?us-ascii?Q?f5DohXfpTSh9+1xiipLpIxHptk2E+ylrVobuKWVoMJD/y75cvGhRvk7EL2RT?=
 =?us-ascii?Q?O2Vcse2lyujreNEJqmWj33cE+THVix0foyMSS4cdSIbds9mgSAJELRaL/eGw?=
 =?us-ascii?Q?JL58CYHay6mMIdZfLQLE/0/Eh0q3kyoNKMy/avykc58uFTeo8rWZXMqlpNBD?=
 =?us-ascii?Q?N5yLcWgryl/sNSuLMCXO3kEGNMnfu0LRuGIMmj0hExRgSplUhHo0PHt/VzF5?=
 =?us-ascii?Q?Tkmv50v6eWDPbKS51t3HyLKmggv66QYNHD9vS9ytCEREDZYtnfD4Rgibs5kF?=
 =?us-ascii?Q?XJFyYoMcQflJjSGZf3L3hdQPOJIuvIcwDZppHiOv2y2NT4RfttaZemBAM7wz?=
 =?us-ascii?Q?EU3Buf6kkkOFwl4ncdd6JtLMHQ0y589RsjrUqqjvcY5lIc1Yo6qkJAGg8Yeg?=
 =?us-ascii?Q?5fF5nW3gmYZ4+mK3EU0QKFv+l81ZMD1L/haZHGX1rz+Z9O1eXDqJrlV+acZT?=
 =?us-ascii?Q?i2ovpTW0o6MM1c9quafHM7X+3/GLWsDNKfKLOdfls8mAqFnFtJcRcnyxyQ?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9Kz16gHxvfx5kr1v2q9T+t7D2hdH53ExhtfgkPg/rwWwIZ+a94hc81/s5jVz?=
 =?us-ascii?Q?0g6g1KyYrrkIAZaFYojlsxJws0SOwX9wNhBVZYU3fAyBPoSWdE/SJPpIFzSJ?=
 =?us-ascii?Q?/8IbIHgJKuHZGAxSK7CKHpkhHqcb/9u0I4d+XF9ECJlkwIuq64YFxvGZ3ZCk?=
 =?us-ascii?Q?A/mz6rWtrho21NpxoPYaJI+5XsuMJCLrNq6OwMpfdQMwzferIrmluYXWeJK8?=
 =?us-ascii?Q?wESE/ZOpxBW0aMNQxLW5OIK3QOBPJ+E/xeLeNRxvxcjlXrjVECT0QBxZItBP?=
 =?us-ascii?Q?R0yyKaINMgLU/6DqazQJEDWPEx1N4FF4de46dvfWON013QmXMkhIoXvgyB6J?=
 =?us-ascii?Q?BTzKfnsv4Gaz7JIET7igd0xduhB06ps5zK+leyL7yV55a0MHCF/iLZ04t6EN?=
 =?us-ascii?Q?WcwIEEnYX+TruuUWedVfIP4csyIOE3pwNvC5PWrkxK/xEHACtqzT+nbJi0Aw?=
 =?us-ascii?Q?DE7Jpzr5SBg7AzoLfyean9GtxAjyzk0ROIxyc7aYR6C4icE3LczADJnMEMs9?=
 =?us-ascii?Q?qUMbPcy4WlPDQxmMNi/ldJJhfzUL4YlmjPLOejKrabc1XY/Am4ulkf1CZWXf?=
 =?us-ascii?Q?MowddXxXAY4Smz4n4bAzdRQstrchbPILm1gugpfmp2l7fg+eVBDZQ7xorFpo?=
 =?us-ascii?Q?RtLlmfeAi+Nvza5yh0TcddH1UTN4S1dcUUBUbPcN7KFmKnNCyKqrrIalDNPk?=
 =?us-ascii?Q?uqk6YPV8edGkSf2dsXmDuQvoRa6i2CgcIsNh8wE8cVDY6716jOQIXGSH/LC2?=
 =?us-ascii?Q?0iJm1KDQKMDtGPhQawE9fcrubBpQoS0Yf1HeKQtCtD7KUJ6ekQG4ZSqgkKcI?=
 =?us-ascii?Q?fS5oLbXmLNFXB/lNjgTdjiF5Btc9Bw8Qt7xW32vl8ngSoiSBqBpAaKnSHBnf?=
 =?us-ascii?Q?6nwWGi2BsPjZLu7YNQdo0dUQBtMdmEG9GrUV6aiFAN7rJbjk+1tR+gPAYTDb?=
 =?us-ascii?Q?VvIGHOzhbvyBCeVqwj1TaEdSuZ2JYPDQeVVUf0DWdo5XRCVwr8nTANFV2/qE?=
 =?us-ascii?Q?bkCbdDvtq+1NpHzz4OTdG0YT4L12qfr9gc0mzDMZmiomPrrYd19fkLBEQumn?=
 =?us-ascii?Q?iKhQI/CdL6rzfpy75R7nAIprs6si8zTj93PbbnTPuBQw2ur0yodqRhoVuhJu?=
 =?us-ascii?Q?5ttC4+ONw9iv4tt366kyYJtGzjQ6gvngPMl/KaEk8DlRujn2lDNDo/knteSo?=
 =?us-ascii?Q?eqO9XTDBBJ8c1fPwEP5uDftVTLNFk5epfPGbi7bYvOR8xuSEDPLpQKZMK/Iu?=
 =?us-ascii?Q?iTjdxXErkTZS0qlDY8a+tyO6ULyjA1UdVaer6Xl7S5w3FQjKR0kMoEJENCgC?=
 =?us-ascii?Q?b2hMcjkAtzLKmGJwyy4FxMcPfsGyomREopnG7pnKkhQX6IxOTnovtbTMCkMZ?=
 =?us-ascii?Q?uD0tU1bPyEm53ZkShIx72Fotr5XOa9edIIqiVrCH/g36hjRPtmjjg+I2Vp5k?=
 =?us-ascii?Q?JUqVSvts77Fb2kaQlY1Jqi3iSnxbNLoEdcYwF3kibAlRoksLdJ///t6fNqhD?=
 =?us-ascii?Q?214zD7hQLXjwiNlDJb9SE9iwY1y1hNd3cM87isOn1kVMch3i52GWJQxZDKvO?=
 =?us-ascii?Q?z4FYhh7Ycq3kbwSpG+53MuFO1mjV7Za4i5fDtn72qopatPqO3vgviM0NZW5l?=
 =?us-ascii?Q?y19oToGmliXQ57LCa6BuLXV8qz3ZGMYxFXtjJPNT/pyB+gzmFxdNU60HpJhL?=
 =?us-ascii?Q?5JQUy05QZNXAkJAcadv4QtT1wOrfVPxGoCAREwhqrlW9ClwWvkqsDxdXvRDq?=
 =?us-ascii?Q?bz5R7VMf/w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: feb8ec05-44a1-480d-1c76-08de636fb916
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2026 22:01:03.2817
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2R8HTw0DKADA63momG180EIYmw7MVMRvX4NJaZ3OHlPCsCOVPivGBZxAIqbJgc4i32yrSSY0WaCe2Ca2FHxckA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6791
X-OriginatorOrg: intel.com

Gregory Price wrote:
> On Sun, Apr 13, 2025 at 05:52:08PM -0500, Ira Weiny wrote:
> > A git tree of this series can be found here:
> > 
> > 	https://github.com/weiny2/linux-kernel/tree/dcd-v6-2025-04-13
> > 
> > This is now based on 6.15-rc2.
> > 
> 
> Extreme necro-bump for this set, but i wonder what folks opinion is on
> DCD support if we expose a new region control pattern ala:
> 
> https://lore.kernel.org/linux-cxl/20260129210442.3951412-1-gourry@gourry.net/
> 
> The major difference would be elimination of sparse-DAX, which i know

Sparse-dax is somewhat of a misnomer.  sparse regions may have been a
better name for it.  That is really what we are speaking of.  It is the
idea that we have regions which don't necessarily have memory backing the
size of the region.

For the DCD series I wrote dax devices could only be created after extents
appeared.

> has been a concern, in favor of a per-region-driver policy on how to
> manage hot-add/remove events.

I think a concern would be that each region driver is implementing a
'policy' which requires new drivers for new policies.

My memory is very weak on all this stuff...

My general architecture was trying to exposed the extent ranges to user
space and allow userspace to build them into ranges with whatever policy
they wanted.

The tests[1] were all written to create dax devices on top of the extents
in certain ways to link together those extents.

[1] https://github.com/weiny2/ndctl/blob/dcd-region3-2025-04-13/test/cxl-dcd.sh

I did not like the 'implicit' nature of the association of dax device with
extent.  But it maintained backwards compatibility with non-sparse
regions...

My vision for tags was that eventually dax device creation could have a
tag specified prior and would only allocate from extents with that tag.

> 
> Things I've discussed with folks in different private contexts
> 
> sysram usecase:
> ----
>   echo regionN > decoder0.0/create_dc_region
>   /* configure decoders */
>   echo regionN > cxl/drivers/sysram/bind
> 
> tagged extents arrive and leave as a group, no sparseness
>     extents cannot share a tag unless they arrive together
>     e.g. set(A) & set(B) must have different tags
>     add and expose daxN.M/uuid as the tag for collective management

I'm not following this.  If set(A) arrives can another set(A) arrive
later?

How long does the kernel wait for all the 'A's to arrive?  Or must they be
in a ...  'more bit set' set of extents.

Regardless IMO if user space was monitoring the extents with tag A they
can decide if and when all those extents have arrived and can build on top
of that.

> 
> Can decide whether linux wants to support untagged extents
>     cxl_sysram could choose to track and hotplug untagged extents

'cxl_sysram' is the sysram region driver right?

Are we expecting to have tags and non-taged extents on the same DCD
region?

I'm ok not supporting that.  But just to be clear about what you are
suggesting.

Would the cxl_sysram region driver be attached to the DCD partition?  Then
it would have some DCD functionality built in...  I guess make a common
extent processing lib for the 2 drivers?

I feel like that is a lot of policy being built into the kernel.  Where
having the DCD region driver simply tell user space 'Hey there is a new
extent here' and then having user space online that as sysram makes the
policy decision in user space.

Segwaying into the N_PRIVATE work.  Couldn't we assign that memory to a
NUMA node with N_PRIVATE only memory via userspace...  Then it is onlined
in a way that any app which is allocating from that node would get that
memory.  And keep it out of kernel space?

But keep all that policy in user space when an extent appears.  Not baked
into a particular driver.

>     directly without going through DAX. Partial release would be
>     possible on a per-extent granularity in this case.
> ----
> 
> 
> virtio usecase:  (making some stuff up here)
> ----
>   echo regionN > decoder0.0/create_dc_region
>   /* configure decoders */
>   echo regionN > cxl/drivers/virtio/bind
> 
> tags are required and may imply specific VM routing
>     may or may not use DAX under the hood
> 
> extents may be tracked individually and add/removed individually
>     if using DAX, this implies 1 device per extent.
>     This probably requires a minimum extent size to be reasonable.
> 
> Does not expose the memory as SysRAM, instead builds new interface
>     to handle memory management message routing to/from the VMM
>     (N_MEMORY_PRIVATE?)
> ----
> 
> 
> devdax usecase (FAMFS?)
> ---- 
>   echo regionN > decoder0.0/create_dc_region
>   /* configure decoders */
>   echo regionN > cxl/drivers/devdax/bind
> 
> All sets of extents appear as new DAX devices
> Tags are exposed via daxN.M/uuid
> Tags are required
>    otherwise you can't make sense of what that devdax represents
> ---
> 
> Begs the question:
>    Do we require tags as a baseline feature for all modes?

Previously no.  But I've often thought of no tag as just a special case of
tag == 0.  But we agreed at one time that they would have special no tag
meaning such that it was just memory to be used however...

>    No tag - no service.
>    Heavily implied:  Tags are globally unique (uuid)
> 
> But I think this resolves a lot of the disparate disagreements on "what
> to do with tags" and how to manage sparseness - just split the policy
> into each individual use-case's respective driver.

I think what I'm worried about is where that policy resides.

I think it is best to have a DCD region driver which simply exposes
extents and allows user space to control how those extents are used.  I
think some of what you have above works like that but I want to be careful
baking in policy.

> 
> If a sufficiently unique use-case comes along that doesn't fit the
> existing categories - a new region-driver may be warranted.

Again I don't like the idea of needing new drivers for new policies.  That
goes against how things should work in the kernel.

Ira
