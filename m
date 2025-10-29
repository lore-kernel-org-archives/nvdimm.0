Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3343358A7
	for <nvdimm@lists.linux.dev>; Wed, 29 Oct 2025 15:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761752296; cv=fail; b=Slntt+G2sKZFnLNr7jswoF4dj0beQR5S/QyA1Dr15s6HfK2IKMr8DAZPlXFNDFE8LG7A4nZP/NteLhvpHfqbKCeGoCLoY/wXvtQ2g0sfryVJxk59qOZ9N1OvsR219okEcO8y8n45+ZV1f2LCt+DIb2z7f9rURWBdxPikS41tekM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761752296; c=relaxed/simple;
	bh=PGBhJc3Zr0QmCXvFD9+FQAmvU37RvQsFiCZlYvZWnpg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=a1xKM7OlSquWrgMfYwicOgDm9+PW1yN99Rrykatp62V5kCb0sefpycdlnvRbcoQMRDqZuD4pXCd/svJqApIa+cDxCkNtKVFzb9iMmqL9wiWlOwgPMvscLppvnhGH4iUOTWiPVegt/AVi/A8VpSLt8fCtQEmyb8meshYp1lcPiLQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PFPR6jJR; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PFPR6jJR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761752295; x=1793288295;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=PGBhJc3Zr0QmCXvFD9+FQAmvU37RvQsFiCZlYvZWnpg=;
  b=PFPR6jJRSyiQd0FrSb7xsG1L1KO5h/EkScs8X24c6v5P5VJ+k9cP585l
   PhNnkz0WnZqSLvDYJ8RuAih8dQp0szlp4ILTxRFIUpwtwHmxrPi8BUmvJ
   7kSDdVRpI7ea5HFHoy7Wot9PI+X+4Fi/YdqlMS/PLh6PLTSnlrgrjNScZ
   IM9CYUhCbLBysFvUzo2MQIjoL8SLtrKGtBhvBGFeJO9szASDNg4T83Vcd
   ozz9XX1K0l4RgyVReYvSNDWM69zoRlKt0nIsgRD6Axe3I0VeIUcC4NDkj
   8iuFd7IHvK/g0mGLVUw9EmQFI+tQiJay8TRwXhkgbtNYbEbiBbWybkVrZ
   A==;
X-CSE-ConnectionGUID: fgk0gXs1QS+tDhcE752SPA==
X-CSE-MsgGUID: xHQwUxPcQau1A/U7Mu81sA==
X-IronPort-AV: E=McAfee;i="6800,10657,11597"; a="67530385"
X-IronPort-AV: E=Sophos;i="6.19,264,1754982000"; 
   d="scan'208";a="67530385"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 08:38:15 -0700
X-CSE-ConnectionGUID: 7bSdpbf0SZq2ZAR00NSFGg==
X-CSE-MsgGUID: pmLvQkB0QFeMxVv2xxGKyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,264,1754982000"; 
   d="scan'208";a="216358022"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 08:38:15 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 29 Oct 2025 08:38:14 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 29 Oct 2025 08:38:14 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.12) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 29 Oct 2025 08:38:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eh/zH5zD4MIPE+mQ0fQt3zBUaugTycGjUl6O4S0dAc9OgoL3V5O2NzJ0lmMhoCs+UPoRDSLV5b+EnqufbDJqioqNvKsBVl73cOppvAicT3tFZSgq9PqlGZc9TwQQkfvTgAdHTnAxJd3l8HSNgJEaG9CXIrk4ymRUSTj7VsqY9xnyvLjLeimnTuiSh7gXENKRv9MmYdkV3djQyyQHk+KiJZ2fHOpNd7W3DctbyBzie0pFnE8dcNxRyBNWSY+pyUe1XGvCL3bCAzbu/U/BYDds9FCGFTnT8VrJcwKigfmvZWolnDs6p7lsGSfUOv4giIRNDUL8wXbn8HDbJk6HtYObzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zJb6HY13AnkmthGpWfWIAZu4qyqvD2I5ENQMH93iDEw=;
 b=Tl+ZFygDjWB+Otvzs3u3K6Ed5xseYg3Ue0P7+7ANL9wB9OhYDCvSfy+j/eYnCeUoNsjkjiueTMxP6MZt3ajvIzkEBbClb5To20IUbknfYcaBvF7tHFagei+pGzm0Eip8x+GCZgMCyd4MCJQoWKNMDFXR2SDRVIbxiDj0Tet03NLtU0GP4XaoVgR88h4fbojBFieZdiPDdCFG2dLzdEPHkzJPmi2XOEWX7HPzT1AhP0W3T/nospKIL/PlVTdTPEqiRpBWXXOAzJ8TKfzY0hQHJzaX5pw83Pcv7JvdBziSv1YrssHj4d+f4JGkH7Sg9nfirF1jp0IHA4Of7EqoQv1AlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by DM6PR11MB4578.namprd11.prod.outlook.com
 (2603:10b6:5:2a7::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.12; Wed, 29 Oct
 2025 15:38:11 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::8289:cecc:ea5b:f0c]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::8289:cecc:ea5b:f0c%8]) with mapi id 15.20.9275.011; Wed, 29 Oct 2025
 15:38:11 +0000
Date: Wed, 29 Oct 2025 10:40:34 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Alison Schofield <alison.schofield@intel.com>, <nvdimm@lists.linux.dev>
CC: Alison Schofield <alison.schofield@intel.com>, Marc Herbert
	<marc.herbert@intel.com>, Dave Jiang <dave.jiang@intel.com>
Subject: Re: [ndctl PATCH v2] ndctl/test: fully reset nfit_test in pmem-ns
 unit test
Message-ID: <69023572a0b5a_20e8ab1006a@iweiny-mobl.notmuch>
References: <20251029032937.1211857-1-alison.schofield@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251029032937.1211857-1-alison.schofield@intel.com>
X-ClientProxiedBy: SJ0PR03CA0144.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::29) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|DM6PR11MB4578:EE_
X-MS-Office365-Filtering-Correlation-Id: 082674b0-6ef0-454c-0d63-08de17012af1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?mYwBdU4JtI6sNmhRMAIP/hqMfMUg/GMm+2qAfvMriVNWr7AmAyEjHYy31X+M?=
 =?us-ascii?Q?SANKmgl0EZwhc/gzwmjvpUIcsElh842sUNPr6C2JZVzQQ23ibwJuPJyPYY8S?=
 =?us-ascii?Q?2cm1eVkkUrDuDl1LglwfgcGlVb5gtjg6yweQNFkg4oM+t7AHI/DNQfHX/830?=
 =?us-ascii?Q?JIhbWb8mCK6V8b/soyJ+0WJtJ/ZLFolyiY6zpPib60kbCz3iub3JvVgvqf4U?=
 =?us-ascii?Q?COnD/CrGNlPjpMItHJxyuCOVJ50eaLkNlPdYnWYmYtQY5eNhs22HGMzqCePs?=
 =?us-ascii?Q?tGsA44sckDmkpe78jAoBuuCYEXYQ2gpQGS+qeIVHiHne0r8Iq8+kEH9gOVsl?=
 =?us-ascii?Q?31UDaU5KixbwBDM05ZeUrnBjcDwZMg1ttKVTUZLsHhpzFgTD4kbl9Do3CZRR?=
 =?us-ascii?Q?XeXuRb4cT4iNruNX2f0P35UdGDBy7DT08pG5SzKDQ5dgMtW5HveQWrJUdMgI?=
 =?us-ascii?Q?1oACl7rUEUWQuJFv6Cg/0t8fS9fhdHtF98AZ4ybuFWOmL49zWZ35FSiWuNYc?=
 =?us-ascii?Q?3GQzZ+PBcZQQyoUQKNIXUBKOw6KkhoFLsMlCzFZoSfbdIZR6ZRgX1kz2Ihff?=
 =?us-ascii?Q?5L2EO6mMdoFoNOOePjH1cUGC4p1j+9WR30DJ5bYh9ErqrVqG9Ra5xEuv4kfJ?=
 =?us-ascii?Q?i8p5nDPZ6+f1HlOGw9KeJPUXqngXmAdsYeNSaL8MuDfpDsaKu7SbcXxYHUqm?=
 =?us-ascii?Q?hRy2batFBxHSYKYb8vx/IvHB4+5ozUDsiLR0iOT3jJBOvyGbDkD5NjUEj35S?=
 =?us-ascii?Q?sBdSGAiGx2ZDQ1NiwXfc3GT6ctvEYJ/Z9eX5+YyimyAguM06jp538HnyS0eQ?=
 =?us-ascii?Q?tTNfIE6Wh2eIPyYcOmyjYc/6yCAcQRLWT1KL89UTQ2FQxtKXyfKiQ0l6Aj32?=
 =?us-ascii?Q?D1dF9rq4XGxDKgrroKqP6g6brq/G2AyxwmRI6xMT6GpY9DTHUNSr7yTGJA6I?=
 =?us-ascii?Q?O9M6F70j56tgmvGdTK+ADCTphvExYqjujQy+Ya63lw3z0ohE7GldVDP7TOQq?=
 =?us-ascii?Q?7pnBMclE+jTjRRjnxmvDAivPckSe/Jxz4VRMFed6Sv4L96FyPmLlnbiSXCrP?=
 =?us-ascii?Q?UhUID4wKtoP1YXP4Nf+tBoNyrPM8Ve3Vnlxs8pXFbLpJT3S2n/7Jg0PvW56m?=
 =?us-ascii?Q?It60/+6WBVDzbTSBsfg34a6qbZXIlJu+hVIgNQVnDfpyy1BytiGB2VmI9OwB?=
 =?us-ascii?Q?6y+okf8XogdAmP7BReV4hVr3Fw5Uj0gN4fudS2kNoIJRtnLU4IcHNvNXnOBl?=
 =?us-ascii?Q?i4SOGLRMQ7smwi5g4NsuRflzLqd9dL6z4iCpKY1jdp4aU6aDGFJBUWLoIMfY?=
 =?us-ascii?Q?1IrF/KGfSUpjm2WvOOA7J9aI/8vXFOMQXGR8d5XMyjodcK5u+OY9XSw7bn5b?=
 =?us-ascii?Q?Ptf8ysnRJ89JU8GtRxoLzKO5LQvTTOzCCqJ1K7twAqIx9By6D7fkHTbO7kI4?=
 =?us-ascii?Q?4hXUiFBo670JfVfZ2fcrvAlpp1T75DlJ?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9nJzC1lVUNLf7AQiiD8P5UCXF9WslZQi+lpxFW+aiUWwuZ8snGI97O6S/svu?=
 =?us-ascii?Q?oNSL74C4Qu01LOpm95mwwWkF30iCa/98nBDQm3vLDW9FWndCiqB4tfw0lIlX?=
 =?us-ascii?Q?Eu1dFevY9npCc9A/UgY7wFaHmbD4J1MLBC3b4n2W8zvODwUKu+M8+U9r5BWv?=
 =?us-ascii?Q?C3s6SVnhgU4OTV+ptSPKIEgR56tJ56HEL6bI5lHGjeq3Uh69j4Gux3v3+teB?=
 =?us-ascii?Q?tkQ63jQRKXWy1VPZtMXVOOkd+xVO+EU6W9Il3cxLQtqUI/Ep6macFfwVO/qb?=
 =?us-ascii?Q?OO9TzfGWxo662XtfpxDc1/IMNvZmWikGhcfTOEMYWDIvMkpWRA2FXqn1yNZE?=
 =?us-ascii?Q?pKPuX6GuNEkyOGgHZNXDl6RVGNLN23eUaRGWKY8QESbt8hKE8Q1OUK4SQ7SR?=
 =?us-ascii?Q?057mekyUoQ/1TopkHWRzdNFT+BUaYrRCKs+b/m16+MFBiPIXfr/9J1zfGr30?=
 =?us-ascii?Q?+Xe7G6U8WTE0OuttSzH8KwsdsqGX/UFdAVoMUl1gDMXL5MKx7sJ7rWgYC4/j?=
 =?us-ascii?Q?4NH1FIFcqngnh1PUSKMrGhrlpXx0KMgr0UmMAfawu4N/1P+F6VjD/Frj/VWV?=
 =?us-ascii?Q?RJx/FAkQhLtqZKHYuaCI9HGIpSkWs5vwhMovTYgjknDt1zL3iGSahAip8iSD?=
 =?us-ascii?Q?8D8PQyDxzXyHmuxzWpFxp+FGWczjWdBvfgQa6QABEXYsXkr/HqCFjOJKEIpG?=
 =?us-ascii?Q?Xv9CjqKvXXCQvd7w7z3hJp4W3IuS1Psp8kSZGdOH9d79tuG3hCFlIMdrqJht?=
 =?us-ascii?Q?pk+CKX4rpksnEPSJphPEudRiuqORnw5BI/5DtAPDZ9TUwIhlMSTg5nVOBPg8?=
 =?us-ascii?Q?3LZJ21fx67gEXU3SNMdrNEMDFnWes3ROtD1nUsGoAfF4SPZI9m+eN69ZHOg+?=
 =?us-ascii?Q?4gqLkFH2OhmN05RgxHes2x7qVAv2tmjScE5CYjQjlD0ajMBS5Y8FLTUAdA4K?=
 =?us-ascii?Q?f4NyLKnjMmhmGUYJ+TT2RzPMa08F5GGxiXohUfA6atV7m0/Fc2rXHIxBteMt?=
 =?us-ascii?Q?f4MeOZpY8wgCYbFXJKND7dTJyJzaf+dYcdEcytZXCOzN13DL/+WtWRd66N9A?=
 =?us-ascii?Q?CbgH+Hvh+ZTyXABwJR2z3GjZ/O+vb+1LQIndFLppVmZm/JTfeM9jcj9NIvMs?=
 =?us-ascii?Q?+Yvxhvk8qSPLAHRHozZZHhTAyTj6/DZKR1FWezuzTVovAnj/72rYvNd1QaWg?=
 =?us-ascii?Q?jP8UkyluT9SNPkY+7rESlOZLaZcq3hq9yY/sQElIeapYDYIAPV5mwEsRWBfQ?=
 =?us-ascii?Q?cPGNdDFVhxllrD2PiZORCrAycDbIyuNV/XRzGNQPNXiLsYqdlIQSmoGMmtGx?=
 =?us-ascii?Q?vKtHgHlGtKd2eP92sCjEiynXM3CcZcqukJ/NAxAS0T2nF8dPMYgh27lUDIJH?=
 =?us-ascii?Q?NvRprLJNMZbXNguB4CncuiFGNrA0GuMd8mPtFAnb27Iit4/5RvECQ4DN/Lcl?=
 =?us-ascii?Q?2VEtj9htT6eOVBCIOZh8GjzMX6A7NdR7RtfzzN7ZqQy2bJ4n05+nQABCijbW?=
 =?us-ascii?Q?138Du3BzaG3o7V90Ot8D6WwHs/R7Uwi8oairf9Q0RbxORcvc8hLzjCvisHR8?=
 =?us-ascii?Q?P51sppXO/T20hq6hlcwE4wZsnzWfn+8nrqvN/xUK?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 082674b0-6ef0-454c-0d63-08de17012af1
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2025 15:38:11.7569
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YRdwu5KekdW45wXuOZ3ZMI04U384oaQIObwrfiIJmCUPAoRwLS9icziDieH9UMYY1XndEBfux86lrDr3SPL2xA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4578
X-OriginatorOrg: intel.com

Alison Schofield wrote:
> The pmem_ns unit test is designed to fallback to using the nfit_test
> bus resource when an ACPI resource is not available. That fallback is
> not as solid as it could be, causing intermittent failures of the unit
> test.
> 
> That nfit_test fallback fails with errors such as:
> path: /sys/devices/platform/nfit_test.0/ndbus2/region7/namespace7.0/uuid
> libndctl: write_attr: failed to open /sys/devices/platform/nfit_test.0/ndbus2/region7/namespace7.0/uuid: No such file or directory
> /root/ndctl/build/test/pmem-ns: failed to create PMEM namespace
> 
> This occurs because calling ndctl_test_init() with a NULL context
> only unloads and reloads the nfit_test module, but does not invalidate
> and reinitialize the libndctl context or its sysfs view from previous
> runs. The resulting stale state prevents the test from creating a new
> namespace cleanly.
> 
> Replace the NULL context parameter when calling ndctl_test_init()
> with the available ndctl_ctx to ensure pmem_ns can find usable PMEM
> regions.
> 
> Add more debug messaging to describe why the nfit_test fallback path
> is taken, ie NULL bus or NULL region.
> 
> 
> Reported-by: Marc Herbert <marc.herbert@intel.com>
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

[snip]
