Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CC137E5DF
	for <nvdimm@lists.linux.dev>; Wed,  7 Oct 2026 23:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791416635; cv=fail; b=HY/FrFCMK3QrkKw94qB8LpKrjwi1speqktjVhDxl3ObEI+RO1N9ipdDVKezkggCihpFFW4Z3Yrpz+BCu7AeSnNJ6bXunyB+pfPP7oOLnlIM2fyjswxhfSP5ITeVnJWSeuCzq3jFg+QJdM/FIQ+FeE6oa94QOV1HYyq8h12TvP+g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791416635; c=relaxed/simple;
	bh=zFeM5kKMODdRJA4reNHjvfrxRS5Uwf14cbG58BRjvQc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QtV1XMr0miPlGz20xUcq59/erz1CzZqsqvzko8t61wo779ak8OQE8P8Y7PYfA0ydo2sPZ99JAPREUzNeTlXFvjA4XygABOST9u9f1fjw1WB2HzWM126qz6s3ibk+sWfWDWk9rdzosefiEHGfL3TiZwuWA6uXLLuUAE/2HMuF+GQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T+jW7/fc; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T+jW7/fc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791416631; x=1822952631;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=zFeM5kKMODdRJA4reNHjvfrxRS5Uwf14cbG58BRjvQc=;
  b=T+jW7/fcqPvqn+RMiJhOz1GwglO+cQJ0tGOPVuCAWTlNjPe6+8iesX3i
   OxdyTUmg5bKT31PEPDgMvd/B2yTxETPKBSo+h4ulVvm7WnA1MOS70SS2h
   AAM1RrCv32EeY9Bd6HvPGacgpOOnuXRGXnnifekctZ0/ENmC7IeYfy0TU
   KwSex732C1yM5TbhEqk7gW6KCgmrtyjto0Hg131hYo92lLFFvEpkXFnq5
   DiWv0wvHtAtotbIs99bvac1NAryTyoiubVvisZ4GwedWTP+kYUhJZIpA1
   RKmbevHBIRBQZEDXM7ppCfKTuFcPAuvQiaZ033n4AsctdiTYTrfEkQa0H
   A==;
X-CSE-ConnectionGUID: uNjJk6yjTtqMqVqLDVXlcg==
X-CSE-MsgGUID: V46doJK1S363YbcFW8/aHw==
X-IronPort-AV: E=McAfee;i="6800,10657,11928"; a="185483"
X-IronPort-AV: E=Sophos;i="6.27,145,1787036400"; 
   d="scan'208";a="185483"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2026 16:43:50 -0700
X-CSE-ConnectionGUID: qIk++Vy0TmqKjeR3qUxKQA==
X-CSE-MsgGUID: BDhlzjn/TwilkHlIHYfH3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,145,1787036400"; 
   d="scan'208";a="285672308"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2026 16:43:50 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 7 Oct 2026 16:43:49 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Wed, 7 Oct 2026 16:43:49 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.3) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 7 Oct 2026 16:43:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tNPGceXRNjo1HF/qin+snCT+YaPfL4eyDGitbuN9VU3lyX31H2cYzfOLALOM/0j35ekpYVgqhhukRwnTjolg4gpL1dtxsOMaHw1Z8Fk5HwqW3oo9wsHFhexdSnReyrONDiN95Z83TCHwexkD5BLv1XTjSLLjIZJPFCVOZWMDHkQzAamICaDdII7QkWUilp4jvMT/I380rop67PTBL0YYOHzr40zLfTIxdw693WjtvjrBHNsrVOILOiVkw6cCudS8BZvaKR3R+QNsGk3lrgrR+ezBo9qbHpJbVfCFYDuRCjvX3DRL5c4U+ubUoUSfXmVul9pzapQYaw1hqK1aIQE/ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z0x2YfEHqyXrez4Kg7CVya4EIG/zB+IV+6z7JbPLTiY=;
 b=X5LVF942buXBOYixhV4KT6pDjzFXkwUBqKceUn4vfQ5Wy9D76vF1l14fw7tJzKs4E8/XS0aqGFaHSQpnQhnoSjfOweUjBB+3J1JzFlahjF46Vo8UunB7+z2ucGYO8X04K6rHMl/wCfzYWZHYkUdXmViPPzyjhHkNUijUpLZ0is5IoRQG5VUKHSV8mRl57w3JiubscQSzj/xcApwTPc41DnMr8toYnaau+EwbwdRFw8r1SERg0u8mkJIYlpArQ2LFcKuvhOHywXmV5lUcvVw4y2RBgtMFPUeemL5+LJ9uodvmqJ/zUH2prKvPIsSYQK7rOa7N7/YiXE6RTuA2gYxybA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by PH0PR11MB7615.namprd11.prod.outlook.com (2603:10b6:510:26e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.15; Wed, 7 Oct
 2026 23:43:38 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0496.010; Wed, 7 Oct 2026
 23:43:38 +0000
Date: Wed, 7 Oct 2026 16:43:34 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Anisa Su <anisa.su887@gmail.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Dan Williams <djbw@kernel.org>, Dave Jiang
	<dave.jiang@intel.com>, Jonathan Cameron <jic23@kernel.org>, Davidlohr Bueso
	<dave@stgolabs.net>, Ira Weiny <iweiny@kernel.org>, Vishal Verma
	<vishal.l.verma@intel.com>, Fan Ni <nifan.cxl@gmail.com>, Li Ming
	<ming.li@zohomail.com>, Benjamin Cheatham <benjamin.cheatham@amd.com>,
	Gregory Price <gourry@gourry.net>, Richard Cheng <icheng@nvidia.com>, "Anisa
 Su" <anisa.su@samsung.com>
Subject: Re: [PATCH v15 2/8] cxl/mem: Read dynamic capacity configuration
 from the device
Message-ID: <asbZJuiKsR0pB8XF@aschofie-mobl2.lan>
References: <20261007201828.952-1-anisa.su@samsung.com>
 <20261007201828.952-3-anisa.su@samsung.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20261007201828.952-3-anisa.su@samsung.com>
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
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|PH0PR11MB7615:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e7c45b3-f13f-4c49-8c10-08df24cccf8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|11063799006|5023799004|3023799007|56012099006|4143699003|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info: sJ5mFvbzaMwGypqBJnF8HOw/6Wpd/fUh7FmDyChwymz63iMbAuXcFx6y9csw8wmBRBVC/x1LPzlDKA+OgmPz1jXeUvGUNfozqqcVVuTjdP31dBRH9AZso7DEMuS5YiV0L/YlhuX6Wvfe+MoVCUDIRZDnI7h5axKG8uW03wVZ3EHGdjs0CQKWJ+xWIP92cKptEA8gWE9/yUxJW7gM7Cv+K9P1XcyAz/RLg8giQCt0JlSNOA+9cR8z88VoiAFW2HGp1Dm3h8Otw9l4eClTei5MKKlwh7n7Lsp/1FH0+02JSLLtP7AAi5GEbbg3HwaOFsOX7uV3W7emzbdbNL+IyclZHGhQdsUOnNAtkqtikpsc4pJFVMyaL+VVNo4IocMkc6wh5kDwyndmQEBgpAN5Y+odw8/+jKmhkCrfjaiMFeKcutXPt3Tu0xK+lzzJv4NPj32QsfoFFQmdr7zk4AxAdDE2JL8qt5VdIV7dlCJ9/4eMmzI3Ra11NQQPKKQ3oa8v0E8yA/+z+h27WKYvYFEyiSXs2ciYg+cYx7c3z179adMGOSJvzLLjTrv1yf2bpUPgtPk55uVbIurn0YUJlyae+jp8O4kIeML03RzIN3TU/Wa5HXKtTW5m8AQm2e+UXcZ3FBmduCqqoZNvGeqoWHlFr8AkxkJ3ln0uQCjRJW1RLvgbDak=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(11063799006)(5023799004)(3023799007)(56012099006)(4143699003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?006MPLrHcFF9m/lD1yke6VhV66Olstg/4v+7w/cf2Q14PxL8EUIJehKAfjsW?=
 =?us-ascii?Q?1XpymOVyBYOc7PiZ3YaM0xeaofUPzKkdEyNoGOlCy7q9WIpEzT+JVZJuqZ/W?=
 =?us-ascii?Q?3RLeZxmlDpBdbaoGpUq6Ufy098ay6eivm0EIZfB1pm9JvgBtpRtXqEPnP5Q0?=
 =?us-ascii?Q?em9d4aU2hC2YVmI8Ujhj2H7D15r6G4X42B8Yvmsp3c5s4lLdpR7lU4vQ/nwB?=
 =?us-ascii?Q?54mZZYf/emUpo9su9j3cSJ3OfuGvU69h/Wc/JyuR/NeD7ynb513G2YacDFK/?=
 =?us-ascii?Q?NudN0rnpFlBGFC6YXWpfPH5JLUuJLEV/0No2EdkTt/umyPcon2sClkkKg44A?=
 =?us-ascii?Q?04vnLinkmGl4/W3JFMYzGgIHh7bCgUOpJcdntp/5FJKonuA3h3a0inMWIe7E?=
 =?us-ascii?Q?z37VSHt/zphtEYdIwxWIDW/oFs0PnK3aGxlWuiMzDnk4MiLyIaYORI3Ouy1f?=
 =?us-ascii?Q?TcrbHYBSV0XTi88qZlWSwHUPZ21eJHcHM9S99SKyXy8K+yk0LmM8oWPcMlU6?=
 =?us-ascii?Q?kALYxGzAX2MqaBRxVgSTALGhYTWU79dcumOiFR4lCeFrsMiRA8e4C4eNAbk9?=
 =?us-ascii?Q?g3ZXxmDkbpQuJRxiQHzdYNDNaqhhK4ovw26CHIbYkJW2Ccn7nA5OlGtXT6lP?=
 =?us-ascii?Q?Jxq9mVAOdZ08HSXmwWsjeHj7ZI465psgeAgSdv0/Ty1B39juWwBPuU1gJOLH?=
 =?us-ascii?Q?3yuvT8kiCcQkRhso7xkFhAtkzE4jGmkmymveZ1CGQJhvdldFsFp2GKAoDqWX?=
 =?us-ascii?Q?f0Nf/TuVsx5ib2nW6cIPK3oj1DwJ1pPF05/fZblK6WNFj2pClAdTGm+6FAhT?=
 =?us-ascii?Q?/nCB8d1FPrs4dADXNzoNgtlLcNEVwScUko188Y1fR4o3VDacFaNG5Kr/CHhr?=
 =?us-ascii?Q?v6PX4DCo+4TrbwIcrF/sCbjEhccTL7bcRloPVX4+oueCWXm/hIeXqSeK5wA/?=
 =?us-ascii?Q?cICZ+J1rnQj9rvru1gQwi96ygTvFwRFIMJCro/8Gbdi8ka867MHHun40c5kR?=
 =?us-ascii?Q?Tb1UvP5Vab9zLJsB4tBoIoolb8YE+LEQIHyLwt5aVBUEWnT4wlsuK9BBA7Ti?=
 =?us-ascii?Q?cZQxtwb4+2khyvx7gvOIIQa5zvxTyorGIYQAsSiGq7G1vYlrgw4vjkfHH8rn?=
 =?us-ascii?Q?fe53hWXok+ATcZYVIWB3GNwlkzc3Ha5aESa15ecpIQzcBfB2Z9ZL9rYi915z?=
 =?us-ascii?Q?2bxomHBh9qpsc7etzlRR4JmE+qhUbCq1c4LO+8vDLIMt/kg60apuemHsagIP?=
 =?us-ascii?Q?ilUfR57sImhYUwia9DYIY30NWYas+Gpg8aagCC/t5XRaWnuv6Gdpw0OTXihq?=
 =?us-ascii?Q?FmJ93AT2Isd2afUeDWTql3qPuSvdSbBm3Le8Hb0nQxiygdJQnuetmNwos6en?=
 =?us-ascii?Q?0sS4he74mjJAIkRee08Cud06UlFCldO7IZ0UmQ2zUliR9mggBpMh+gsSKqZG?=
 =?us-ascii?Q?zO34rDXQO8X/YJcf1P+Cu513GytdTf5TplwmGUqRxPta+ygLCQKFMmkQcG8P?=
 =?us-ascii?Q?afdJjKu1fw8gvemivqZVfZqHNcmnQv4Mjm7rtxkrAxejJjWV4XI7tF/Zxazp?=
 =?us-ascii?Q?xr32alYYLOT7li/2vikMehUh3qn9RzGAEDBLz1cunzbVSnnErx1qlqAqcbfV?=
 =?us-ascii?Q?zaa3dQUGHRxwTXDpqRSVzeDfBoQ2gVc/Ubgt75LxHvo5C7j1b01ieP7Pgnpp?=
 =?us-ascii?Q?nMCq91QgpBVIE9RJjPSBX21LMtfHocweiEhya1nyO0ogJib3xB0JOnAnfD9t?=
 =?us-ascii?Q?t5go5FKEExAq/tSlpFIe+sr+ea3IrrA=3D?=
X-Exchange-RoutingPolicyChecked: Kd8sLs6k4p+WE7/wjDHQBcz/RLlRGUpP4340mca7eqyS3bq4v7SKbFBXl5gXCgtGR+NrF4zjmuxqBN5jgJR7p/yyM+Q+aWElrnBNkizv1TJKByZeArL4trEo81Z19bqkJDLlUlywmV9A13KiV0ixa0JLMiW+qV7WgAU2l5Q86QI4Rk3Q3VrPAOl8V5b2Vn5XyxvAVp/Q/74IUMVi/I7YuNqfRNtvsZfp28om+UYWZlvTo/nw9ZLyDTXszK3tDKTPFw9KdywoxHEwRcTX80lzgm4jWFa9D8DSpnW6c/inSMDkjy3wNis4ioepO6tyM7ujjXdvbI/1lVLBO/5SVDFtkA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e7c45b3-f13f-4c49-8c10-08df24cccf8b
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2026 23:43:38.5975
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: grEk7gAludWWPmq9gkVIV3VB1jFV6sHX0tGH/qNBLWvNQQCw+Siz3wEi7OG0tt7PLXAhL6RXuzlX7kOB6o0LyaqjC668kXOfEY5qaM2q3Dg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7615
X-OriginatorOrg: intel.com

On Wed, Oct 07, 2026 at 01:16:35PM -0700, Anisa Su wrote:
> From: Ira Weiny <iweiny@kernel.org>
> 
> Devices which support Dynamic Capacity (DC) are configured via mailbox
> commands. CXL r4.0 section 9.13.3 describes the use of the Get DC
> Configuration command in order to obtain DCD partition characteristics.
> 
> Implement the DC mailbox commands as specified in CXL 4.0 section
> 8.2.10.9.9 (opcodes 48XXh) to read and store the DCD configuration
> information. Disable DCD if an invalid configuration is found.
> 
> Initial enablement for Linux only supports one dynamic capacity
> partition. Read all the partitions the device reports but validate
> only the first, and configure it as 'dynamic ram'.
> 
> The specification requires that volatile capacity starts at DPA 0 and
> pmem starts at the DPA immediately following it, but DC partitions only
> need to be 256MB aligned according to CXL r4.0 section 8.2.10.9.9.1
> Table 8-347. So a device could leave a gap between ram/pmem (static)
> capacity and its first DC partition, or between one DC partition and
> the next.
> 
> However, Linux chooses not to support gaps between static and dynamic
> capacity, and requires the first DC partition to begin at the DPA
> immediately following static capacity.
> 
> Based on an original patch by Navneet Singh.
> 
> Signed-off-by: Ira Weiny <iweiny@kernel.org>
> Co-developed-by: Anisa Su <anisa.su@samsung.com>
> Signed-off-by: Anisa Su <anisa.su@samsung.com>


Did you needlessly drop tags. Here's my Review again, and I think you also
dropped other folks Tested-by tags. Take a look at history.  

Reviewed-by: Alison Schofield <alison.schofield@intel.com>


> 
> ---
> Changes:
> 1. Partition mode renamed CXL_PARTMODE_DYNAMIC_RAM: the mode says what
>    kind of capacity this is, not which partition. The DC partition's
>    resource name carries its position instead, dynamic_ram_1 for the
>    first, formatted in cxl_dpa_setup().
> ---
>  drivers/cxl/core/hdm.c    |  13 ++-
>  drivers/cxl/core/mbox.c   | 237 ++++++++++++++++++++++++++++++++++++++
>  drivers/cxl/core/memdev.c |  47 ++++++++
>  drivers/cxl/cxlmem.h      |  55 +++++++++
>  drivers/cxl/pci.c         |   6 +
>  include/cxl/cxl.h         |   3 +-
>  6 files changed, 359 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
> index 0c80b76a5f9b..5fa2177cefcc 100644
> --- a/drivers/cxl/core/hdm.c
> +++ b/drivers/cxl/core/hdm.c
> @@ -446,6 +446,8 @@ static const char *cxl_mode_name(enum cxl_partition_mode mode)
>  		return "ram";
>  	case CXL_PARTMODE_PMEM:
>  		return "pmem";
> +	case CXL_PARTMODE_DYNAMIC_RAM:
> +		return "dynamic_ram";
>  	default:
>  		return "";
>  	};
> @@ -455,6 +457,7 @@ static const char *cxl_mode_name(enum cxl_partition_mode mode)
>  int cxl_dpa_setup(struct cxl_dev_state *cxlds, const struct cxl_dpa_info *info)
>  {
>  	struct device *dev = cxlds->dev;
> +	int dc_nth = 0;
>  
>  	guard(rwsem_write)(&cxl_rwsem.dpa);
>  
> @@ -471,8 +474,16 @@ int cxl_dpa_setup(struct cxl_dev_state *cxlds, const struct cxl_dpa_info *info)
>  
>  	for (int i = 0; i < info->nr_partitions; i++) {
>  		const struct cxl_dpa_part_info *part = &info->part[i];
> +		const char *name = cxl_mode_name(part->mode);
>  		int rc;
>  
> +		if (part->mode == CXL_PARTMODE_DYNAMIC_RAM) {
> +			name = devm_kasprintf(dev, GFP_KERNEL, "%s_%d", name,
> +					      ++dc_nth);
> +			if (!name)
> +				return -ENOMEM;
> +		}
> +
>  		cxlds->part[i].perf.qos_class = CXL_QOS_CLASS_INVALID;
>  		cxlds->part[i].mode = part->mode;
>  
> @@ -485,7 +496,7 @@ int cxl_dpa_setup(struct cxl_dev_state *cxlds, const struct cxl_dpa_info *info)
>  		}
>  		rc = add_dpa_res(dev, &cxlds->dpa_res, &cxlds->part[i].res,
>  				 part->range.start, range_len(&part->range),
> -				 cxl_mode_name(part->mode));
> +				 name);
>  		if (rc)
>  			return rc;
>  		cxlds->nr_partitions++;
> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index 199bb986d674..72af23ba288e 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c
> @@ -1349,6 +1349,243 @@ int cxl_mem_sanitize(struct cxl_memdev *cxlmd, u16 cmd)
>  	return -EBUSY;
>  }
>  
> +/*
> + * A partition unavailable for Dynamic Capacity reports zeros for decode_length,
> + * length, and block_size.
> + */
> +static bool cxl_dc_partition_unavailable(struct cxl_dc_partition *dev_part)
> +{
> +	return !le64_to_cpu(dev_part->decode_length) &&
> +	       !le64_to_cpu(dev_part->length) &&
> +	       !le64_to_cpu(dev_part->block_size);
> +}
> +
> +static int cxl_dc_check(struct device *dev, struct cxl_dc_partition_info *part,
> +			struct cxl_dc_partition *dev_part)
> +{
> +	u64 decode_len = le64_to_cpu(dev_part->decode_length);
> +	u64 blk_size = le64_to_cpu(dev_part->block_size);
> +	u64 len = le64_to_cpu(dev_part->length);
> +	u64 size;
> +
> +	/*
> +	 * Not an error; leave the entry empty. A partially zeroed partition
> +	 * is rejected by the checks below. CXL r4.0 Table 8-347.
> +	 */
> +	if (cxl_dc_partition_unavailable(dev_part)) {
> +		*part = (struct cxl_dc_partition_info) { };
> +		dev_dbg(dev, "Partition 0 unavailable for DC\n");
> +		return 0;
> +	}
> +
> +	/*
> +	 * Decode length is a count of 256M units, so a device reporting 2^36
> +	 * or more wraps.
> +	 */
> +	if (check_mul_overflow(decode_len, (u64)CXL_CAPACITY_MULTIPLIER, &size)) {
> +		dev_err(dev, "DC partition 0 decode length %#llx overflows\n",
> +			decode_len);
> +		return -EINVAL;
> +	}
> +
> +	*part = (struct cxl_dc_partition_info) {
> +		.start = le64_to_cpu(dev_part->base),
> +		.size = size,
> +	};
> +
> +	/*
> +	 * Block size is a power of 2 and a multiple of 40h. is_power_of_2()
> +	 * takes an unsigned long, which truncates blk_size on 32 bit.
> +	 */
> +	if (blk_size == 0 || (blk_size & (blk_size - 1)) ||
> +	    blk_size % CXL_DCD_BLOCK_LINE_SIZE) {
> +		dev_err(dev, "DC partition 0 invalid block size %#llx\n", blk_size);
> +		return -EINVAL;
> +	}
> +
> +	if (part->size == 0) {
> +		dev_err(dev, "DC partition 0 zero decode length\n");
> +		return -EINVAL;
> +	}
> +
> +	if (len == 0) {
> +		dev_err(dev, "DC partition 0 zero length\n");
> +		return -EINVAL;
> +	}
> +
> +	if (len > part->size) {
> +		dev_err(dev, "DC partition 0 length %#llx exceeds decode length %#llx\n",
> +			len, part->size);
> +		return -EINVAL;
> +	}
> +
> +	if (!IS_ALIGNED(len, blk_size)) {
> +		dev_err(dev, "DC partition 0 length %#llx not a multiple of block size %#llx\n",
> +			len, blk_size);
> +		return -EINVAL;
> +	}
> +
> +	if (!IS_ALIGNED(part->start, SZ_256M)) {
> +		dev_err(dev, "DC partition 0 base %#llx not aligned to 256M\n",
> +			part->start);
> +		return -EINVAL;
> +	}
> +
> +	dev_dbg(dev, "DC partition 0 start %#llx size %#llx blk_size: %#llx\n",
> +		part->start, part->size, blk_size);
> +
> +	return 0;
> +}
> +
> +/* Returns the number of partitions in dc_resp or -ERRNO */
> +static int cxl_get_dc_config(struct cxl_mailbox *mbox, u8 start_partition,
> +			     u8 partition_count,
> +			     struct cxl_mbox_get_dc_config_out *dc_resp,
> +			     size_t dc_resp_size)
> +{
> +	struct cxl_mbox_get_dc_config_in get_dc = (struct cxl_mbox_get_dc_config_in) {
> +		.partition_count = partition_count,
> +		.start_partition_index = start_partition,
> +	};
> +	struct cxl_mbox_cmd mbox_cmd = (struct cxl_mbox_cmd) {
> +		.opcode = CXL_MBOX_OP_GET_DC_CONFIG,
> +		.payload_in = &get_dc,
> +		.size_in = sizeof(get_dc),
> +		.size_out = dc_resp_size,
> +		.payload_out = dc_resp,
> +		/* The device must return at least the fixed header */
> +		.min_out = sizeof(*dc_resp),
> +	};
> +	size_t expected_sz;
> +	int rc;
> +
> +	rc = cxl_internal_send_cmd(mbox, &mbox_cmd);
> +	if (rc < 0)
> +		return rc;
> +
> +	if (dc_resp->partitions_returned > partition_count) {
> +		dev_err(mbox->host, "Device returned %u partitions, requested %u\n",
> +			dc_resp->partitions_returned, partition_count);
> +		return -EIO;
> +	}
> +
> +	/* The trailing extent/tag counts (CXL r4.0 Table 8-346) are not read */
> +	expected_sz = struct_size(dc_resp, partition,
> +				  dc_resp->partitions_returned);
> +
> +	if (mbox_cmd.size_out < expected_sz) {
> +		dev_err(mbox->host,
> +			"Payload size %zu less than expected %zu for %u partitions\n",
> +			mbox_cmd.size_out,
> +			expected_sz,
> +			dc_resp->partitions_returned);
> +		return -EIO;
> +	}
> +
> +	dev_dbg(mbox->host, "Read %d/%d DC partitions\n",
> +		dc_resp->partitions_returned, dc_resp->avail_partition_count);
> +	return dc_resp->partitions_returned;
> +}
> +
> +/**
> + * cxl_dev_dc_identify() - Reads the dynamic capacity information from the
> + *                         device.
> + * @mbox: Mailbox to query
> + * @dc_info: The dynamic partition information to return
> + *
> + * Read every partition the device reports, but validate only the first:
> + * Linux maps partition 0 and nothing else, so a defect in capacity the
> + * driver never touches is not a reason to refuse the device dynamic
> + * capacity.  The remaining partitions are read but not recorded.
> + *
> + * Return: 0 if identify was executed successfully, -ERRNO on error.
> + *         On error, @dc_info is left unchanged.
> + */
> +int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
> +			struct cxl_dc_partition_info *dc_info)
> +{
> +	struct cxl_dc_partition_info partitions[CXL_MAX_DC_PARTITIONS] = { };
> +	struct cxl_mbox_get_dc_config_out *dc_resp __free(kfree) = NULL;
> +	struct device *dev = mbox->host;
> +	u8 avail_partitions = 0;
> +	u8 start_partition;
> +	u8 num_partitions;
> +	u8 partition_count;
> +	size_t dc_resp_size;
> +
> +	/*
> +	 * Bound requested number of partitions by mailbox payload size. The
> +	 * 256 byte spec minimum, verified in cxl_pci_setup_mailbox(), keeps
> +	 * the subtraction below from underflowing.
> +	 */
> +	partition_count = min(CXL_MAX_DC_PARTITIONS,
> +			      (mbox->payload_size - sizeof(*dc_resp) -
> +			       sizeof(struct cxl_mbox_get_dc_config_tail)) /
> +			      sizeof(struct cxl_dc_partition));
> +	dc_resp_size = struct_size(dc_resp, partition, partition_count) +
> +		       sizeof(struct cxl_mbox_get_dc_config_tail);
> +
> +	dc_resp = kmalloc(dc_resp_size, GFP_KERNEL);
> +	if (!dc_resp)
> +		return -ENOMEM;
> +
> +	start_partition = 0;
> +	num_partitions = 0;
> +	do {
> +		int returned, rc;
> +
> +		returned = cxl_get_dc_config(mbox, start_partition,
> +					     partition_count, dc_resp,
> +					     dc_resp_size);
> +		if (returned < 0) {
> +			dev_err(dev, "Failed to get DC config: %d\n", returned);
> +			return returned;
> +		}
> +
> +		if (returned == 0) {
> +			dev_err(dev,
> +				"Device reported %u partitions available but returned none at index %u\n",
> +				dc_resp->avail_partition_count, start_partition);
> +			return -EIO;
> +		}
> +
> +		/* A DCD reports at least one partition (CXL r4.0 Table 8-346) */
> +		if (dc_resp->avail_partition_count == 0) {
> +			dev_err(dev, "Device reported no DC partitions\n");
> +			return -EIO;
> +		}
> +
> +		avail_partitions = min(dc_resp->avail_partition_count,
> +				       CXL_MAX_DC_PARTITIONS);
> +
> +		/*
> +		 * Only partition 0 is mapped, so it is the only one checked.
> +		 * The rest are read to complete the enumeration and dropped.
> +		 */
> +		if (start_partition == 0) {
> +			rc = cxl_dc_check(dev, &partitions[0],
> +					  &dc_resp->partition[0]);
> +			if (rc)
> +				return rc;
> +		}
> +
> +		num_partitions += returned;
> +		start_partition = num_partitions;
> +
> +	} while (num_partitions < avail_partitions);
> +
> +	/* Linux only supports the 1st partition; nothing to do if it is unavailable */
> +	if (partitions[0].size == 0)
> +		return -ENODEV;
> +
> +	*dc_info = partitions[0];
> +	dev_dbg(dev, "Returning partition 0 %#llx size %#llx\n",
> +		dc_info->start, dc_info->size);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_NS_GPL(cxl_dev_dc_identify, "CXL");
> +
>  int cxl_get_dirty_count(struct cxl_memdev_state *mds, u32 *count)
>  {
>  	struct cxl_mailbox *cxl_mbox = &mds->cxlds.cxl_mbox;
> diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
> index b3419df586b9..def26c490dfe 100644
> --- a/drivers/cxl/core/memdev.c
> +++ b/drivers/cxl/core/memdev.c
> @@ -643,6 +643,53 @@ int cxl_mem_dpa_fetch(struct cxl_memdev_state *mds, struct cxl_dpa_info *info)
>  }
>  EXPORT_SYMBOL_NS_GPL(cxl_mem_dpa_fetch, "CXL");
>  
> +int cxl_configure_dcd(struct cxl_memdev_state *mds, struct cxl_dpa_info *info)
> +{
> +	struct cxl_dc_partition_info dc_info = { };
> +	struct device *dev = mds->cxlds.dev;
> +	u64 total;
> +	int rc;
> +
> +	if (!mds->cxlds.media_ready)
> +		return 0;
> +
> +	rc = cxl_dev_dc_identify(&mds->cxlds.cxl_mbox, &dc_info);
> +	if (rc) {
> +		dev_warn(dev,
> +			 "Failed to read Dynamic Capacity config: %d\n", rc);
> +		return rc;
> +	}
> +
> +	if (dc_info.start < info->size) {
> +		dev_err(dev,
> +			"DC partition 0 base %#llx overlaps static capacity ending at %#llx\n",
> +			dc_info.start, info->size);
> +		return -EINVAL;
> +	}
> +
> +	/* A gap between static capacity and the DC partition is not supported */
> +	if (dc_info.start > info->size) {
> +		dev_warn(dev,
> +			 "DC partition 0 base %#llx leaves a gap from static capacity ending at %#llx\n",
> +			 dc_info.start, info->size);
> +		return -EOPNOTSUPP;
> +	}
> +
> +	if (check_add_overflow(info->size, dc_info.size, &total)) {
> +		dev_err(dev,
> +			"DC partition 0 size %#llx overflows DPA space ending at %#llx\n",
> +			dc_info.size, info->size);
> +		return -EINVAL;
> +	}
> +
> +	info->size = total;
> +	dev_dbg(dev, "Adding dynamic ram partition; %#llx size %#llx\n",
> +		dc_info.start, dc_info.size);
> +	add_part(info, dc_info.start, dc_info.size, CXL_PARTMODE_DYNAMIC_RAM);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_NS_GPL(cxl_configure_dcd, "CXL");
>  
>  /**
>   * cxl_set_capacity: initialize dpa by a driver without a mailbox.
> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> index 0c8e23276dc6..4fac65dbb808 100644
> --- a/drivers/cxl/cxlmem.h
> +++ b/drivers/cxl/cxlmem.h
> @@ -407,6 +407,8 @@ struct cxl_security_state {
>  	struct kernfs_node *sanitize_node;
>  };
>  
> +#define CXL_MAX_DC_PARTITIONS 8
> +
>  static inline resource_size_t cxl_pmem_size(struct cxl_dev_state *cxlds)
>  {
>  	/*
> @@ -689,6 +691,39 @@ struct cxl_mbox_set_shutdown_state_in {
>  	u8 state;
>  } __packed;
>  
> +/* See CXL r4.0 Table 8-345 get dynamic capacity config Input Payload */
> +struct cxl_mbox_get_dc_config_in {
> +	u8 partition_count;
> +	u8 start_partition_index;
> +} __packed;
> +
> +/* See CXL r4.0 Table 8-346 get dynamic capacity config Output Payload */
> +struct cxl_mbox_get_dc_config_out {
> +	u8 avail_partition_count;
> +	u8 partitions_returned;
> +	u8 rsvd[6];
> +	/* See CXL r4.0 Table 8-347 */
> +	struct cxl_dc_partition {
> +		__le64 base;
> +		__le64 decode_length;
> +		__le64 length;
> +		__le64 block_size;
> +		__le32 dsmad_handle;
> +		u8 flags;
> +		u8 rsvd[3];
> +	} __packed partition[] __counted_by(partitions_returned);
> +	/* Trailing extent/tag count fields unused */
> +} __packed;
> +
> +/* Trailing counts; cannot be a member after the flex array above */
> +struct cxl_mbox_get_dc_config_tail {
> +	__le32 num_extents_supported;
> +	__le32 num_extents_available;
> +	__le32 num_tags_supported;
> +	__le32 num_tags_available;
> +} __packed;
> +#define CXL_DCD_BLOCK_LINE_SIZE 0x40
> +
>  /* Set Timestamp CXL 3.0 Spec 8.2.9.4.2 */
>  struct cxl_mbox_set_timestamp_in {
>  	__le64 timestamp;
> @@ -812,9 +847,18 @@ enum {
>  int cxl_internal_send_cmd(struct cxl_mailbox *cxl_mbox,
>  			  struct cxl_mbox_cmd *cmd);
>  int cxl_dev_state_identify(struct cxl_memdev_state *mds);
> +
> +struct cxl_dc_partition_info {
> +	u64 start;
> +	u64 size;
> +};
> +
> +int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
> +			struct cxl_dc_partition_info *dc_info);
>  int cxl_await_media_ready(struct cxl_dev_state *cxlds);
>  int cxl_enumerate_cmds(struct cxl_memdev_state *mds);
>  int cxl_mem_dpa_fetch(struct cxl_memdev_state *mds, struct cxl_dpa_info *info);
> +int cxl_configure_dcd(struct cxl_memdev_state *mds, struct cxl_dpa_info *info);
>  struct cxl_memdev_state *cxl_memdev_state_create(struct device *dev, u64 serial,
>  						 u16 dvsec);
>  void set_exclusive_cxl_commands(struct cxl_memdev_state *mds,
> @@ -828,6 +872,17 @@ void cxl_event_trace_record(struct cxl_memdev *cxlmd,
>  			    const uuid_t *uuid, union cxl_event *evt);
>  int cxl_get_dirty_count(struct cxl_memdev_state *mds, u32 *count);
>  int cxl_arm_dirty_shutdown(struct cxl_memdev_state *mds);
> +
> +static inline bool cxl_dcd_supported(struct cxl_memdev_state *mds)
> +{
> +	return mds->dcd_supported;
> +}
> +
> +static inline void cxl_disable_dcd(struct cxl_memdev_state *mds)
> +{
> +	mds->dcd_supported = false;
> +}
> +
>  int cxl_set_timestamp(struct cxl_memdev_state *mds);
>  int cxl_poison_state_init(struct cxl_memdev_state *mds);
>  int cxl_mem_get_poison(struct cxl_memdev *cxlmd, u64 offset, u64 len,
> diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
> index c7c91e8dc51d..2fe9db4b3d86 100644
> --- a/drivers/cxl/pci.c
> +++ b/drivers/cxl/pci.c
> @@ -868,6 +868,12 @@ static int cxl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	if (rc)
>  		return rc;
>  
> +	if (cxl_dcd_supported(mds)) {
> +		rc = cxl_configure_dcd(mds, &range_info);
> +		if (rc)
> +			cxl_disable_dcd(mds);
> +	}
> +
>  	rc = cxl_dpa_setup(cxlds, &range_info);
>  	if (rc)
>  		return rc;
> diff --git a/include/cxl/cxl.h b/include/cxl/cxl.h
> index 802b143de83d..e07360849344 100644
> --- a/include/cxl/cxl.h
> +++ b/include/cxl/cxl.h
> @@ -133,6 +133,7 @@ struct cxl_dpa_perf {
>  enum cxl_partition_mode {
>  	CXL_PARTMODE_RAM,
>  	CXL_PARTMODE_PMEM,
> +	CXL_PARTMODE_DYNAMIC_RAM,
>  };
>  
>  /**
> @@ -147,7 +148,7 @@ struct cxl_dpa_partition {
>  	enum cxl_partition_mode mode;
>  };
>  
> -#define CXL_NR_PARTITIONS_MAX 2
> +#define CXL_NR_PARTITIONS_MAX 3
>  
>  /**
>   * struct cxl_dev_state - The driver device state
> -- 
> 2.43.0
> 
