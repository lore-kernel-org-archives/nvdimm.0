Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2853F2FE589
	for <nvdimm@lists.linux.dev>; Fri, 31 Oct 2025 23:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761953123; cv=fail; b=Jl5hn+gTC3KQafRWW94aG4ESAPxbZS1//Jc8y/9PgactgGyVNgP0iaD4NEVvXKIzl+46omUPLDBTh45NgUl/4slvi6belgeUV6kzVx8qhJDIu7CFeGK3aeHaFlm0kxkCXbo2tDLH2C/PiaaMm8+ga4k1CLdy87k/WxU5mW84KgU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761953123; c=relaxed/simple;
	bh=RhfZ0iYT7cs1r4jLR11NNPFwey5unZTwvXSUO1h+y04=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ix8I16ZI7dOXR+mT5kt42lrrOrtPvAjOdDVBCwxMet37VxPwBuZ5vgbwV3A1oNGgJ3RteAhjYSJDefEk3DYcrWsZLbaIWzOFwS4OdWeB0mte7/KxV9ScJ1xDay9/PUNBT1Zt0WSVhqiErj32uxewSpxVWoVOMjm7LH09sjHjHAU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bkEtAvuF; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bkEtAvuF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761953122; x=1793489122;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=RhfZ0iYT7cs1r4jLR11NNPFwey5unZTwvXSUO1h+y04=;
  b=bkEtAvuFF/RdeH3GnEZJRoDmPYZ0w86LC/+v3/iXOJFBvFT0bx7zFCRN
   NCjXafaXWJL4kBskTY8Z8kDi/MGEa+VTfT2qen4r9pup/SUDkByrVeoVV
   6/flbS+GRkW+Wjpaqxx9pr0ger2/nrvKDKs+Knhg3YcIAJeaJl3vChCIf
   nIUPdRAkm26qYoMYioGhLedODubJ5vczxbIhfoxqZfvaTJbd1J1vK4+eP
   tpaYS+X0F4M5bXMN+HCyvgQsXFLV8HREdkFeg3fQMHfndyOmRlzaXtetf
   AbN6cv9pbHHAcO0iP+7KF91d+wPbLQnSGkhOSKSquTw4Wt5B8kETCOgOw
   g==;
X-CSE-ConnectionGUID: a77rzyiaT46PXkC5Jj2GDA==
X-CSE-MsgGUID: /cgZMNSRQce/OPZarNJ/MA==
X-IronPort-AV: E=McAfee;i="6800,10657,11599"; a="67979709"
X-IronPort-AV: E=Sophos;i="6.19,270,1754982000"; 
   d="scan'208";a="67979709"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 16:25:21 -0700
X-CSE-ConnectionGUID: DeQKusMpQDK83gCH00nkcA==
X-CSE-MsgGUID: ICwWeSphQbSlpugNsli3Tg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,270,1754982000"; 
   d="scan'208";a="186229524"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 16:25:21 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 31 Oct 2025 16:25:21 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 31 Oct 2025 16:25:21 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.61) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 31 Oct 2025 16:25:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t8ctw6hzQ+PMMXpS5C/lRMySVGdo6NxHMsTHUxikiXo19S210cScSvkB8SrHJfNs78fbJTfDBSIvYe6/0NuJ04nLCYRuBRJwJq+fZvwPKlfW4kxF8oovHEEcvznD+25u4jqCGpe7aQbYOPhL5hlMreoJd/KNRBuxUKVVQ7Yq0rCcrVmlnq8+3GEWqUkpUJ9EhU89d7gUnxZ/ZKnPPndXZ0ntifx5o7FdzHJND6mRORnO6kFjyOsQ3lMerqAMe1ZNR1kLX+atB9TvVlYgF6U+w0x+v7Jy3Z+7kw6FE1uCejQ/fYvP2nc/M58A0JV0SgPWkBtVnKgo28wTwY+V2f7YDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S6Pis4EZtwIoGRjbAL3FaZy6XqBYincE5xh5m61Xq+8=;
 b=HV34eO6Wt9PCTzwfLvhm6flJMh/8lKu7dJlzZ/Qh5WtgM0YvbfcZEMYxcIZF8vihZgdFhpUF/4jtzgXqYTgD4qvNz6mofs4WiOKrIs03QjKlgdllBMmyO0CMEypnbqbdEEUVavxBrV8LpQeDCso7IXAePMN7AsWU4TYAWbYE9U5H1x2zRcTosvhSBg9wPB5BjXhfLd2C+v3/feopRzh7pJNMHqJqhAM3KlUD1fDqlwcqndBSu3zVYCuVJ4zVZiyJKm1vusdpp1dkYq1UUD1auGUNBewvFz4FFotaMSgBGmudX6XAciZhmCRF9S717KlNtafNL/uv4VDSJEWRNRRzFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by IA1PR11MB8151.namprd11.prod.outlook.com (2603:10b6:208:44d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.15; Fri, 31 Oct
 2025 23:25:19 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee%8]) with mapi id 15.20.9275.013; Fri, 31 Oct 2025
 23:25:19 +0000
Date: Fri, 31 Oct 2025 16:25:16 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: <dan.j.williams@intel.com>
CC: Ira Weiny <ira.weiny@intel.com>, Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, <nvdimm@lists.linux.dev>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH] tools/testing/nvdimm: Stop read past end of global
 handle array
Message-ID: <aQVFXFGAyfWEQvI9@aschofie-mobl2.lan>
References: <20251030004222.1245986-1-alison.schofield@intel.com>
 <69051f256714_10e910054@dwillia2-mobl4.notmuch>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <69051f256714_10e910054@dwillia2-mobl4.notmuch>
X-ClientProxiedBy: BY5PR17CA0002.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::15) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|IA1PR11MB8151:EE_
X-MS-Office365-Filtering-Correlation-Id: 93cdf0fd-66ec-4f0f-773f-08de18d4c16e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?rlXKjf3UtAplODedkcYz9kAHHSrZCvFP2+HDm9lxYoa/CCCcBfBRcvrcAlZj?=
 =?us-ascii?Q?5hjkwN9ldS+tyn5Rcjbic2v2zt7CGdmcRS1xqOyikveXSv6GDlwuWYhBEAb3?=
 =?us-ascii?Q?615fDzLPrhNUaJqloABaUr3EKSP6+KkqX+/DrzBK0Ex65aSua9uZM6JCTrqM?=
 =?us-ascii?Q?XYuNxgEuJ7CwRpN9HdJiwZF5B2MtzMc/CrQSJushMcoBcMG+N2vALSRbHaF9?=
 =?us-ascii?Q?6RQPguDdLDgV2nGzSmg3iZDm+5Cr5fcrQIkXZdTMlGVBxODDfSzittCL43Zi?=
 =?us-ascii?Q?W7IkShvc5/X3+4XmEGgg1QBlPAeHDW3FVM4MPQEq5ciSYU+8i4fhIQyxogY8?=
 =?us-ascii?Q?yoA1gkSC13zcyeWMrBM7p8QPXO5BLeyeJXXviJ6WRxUksK4qOomNVoo1hIhb?=
 =?us-ascii?Q?FgUwMPeGFRu6wA183tAigEn08wjwV6k4UvA7eBqcl31fO2zKtG45tnw9b85t?=
 =?us-ascii?Q?tm3A2TzJNCp3Ut5sOyQ9V+/ZWS6cPF9edWmZy52SvcdmRrAzE8WEvDypldDO?=
 =?us-ascii?Q?U+LNmmn11/513De2aAPLKy4PPMgT92Bfdp8yFFkRRlqe6N2d7LxgvlPUQ9zk?=
 =?us-ascii?Q?YJRrc/OxRdXBFJw/dZI287HDzACu2fUZmwO4cIT7VJYCfiYBLI865uMRgLl0?=
 =?us-ascii?Q?Dwz7zMQ0HiJk/6T3bglOLxDuHm4+xKJ7YykJ+HpV+gWhbW6N+RJJAKWF/EUe?=
 =?us-ascii?Q?RIvq/Sonkgk9SAnKAHCAlzfE8lqNWYzjRavGF8PzRuqPbR9vrKd6k5nTxbrE?=
 =?us-ascii?Q?/5P1tw56TuZCtehtRL//Yx+b0hqkBeSZuh9k+4fhgHeoRmfCstpVpSYxcDsj?=
 =?us-ascii?Q?7oZTDiOLXWznJ7N9wiJf7S0lv3NPDIyqTUJhcU3j5kom4kqaYWGqwegCT/DA?=
 =?us-ascii?Q?YilC18cMo8mYozHmiw3LpCgHiohhuu62bAbz2EXNv6FoLWPgfOxzjCES6/Kb?=
 =?us-ascii?Q?fcUDOLgYxLo/92ih+UKtyP2wXtmKBPsws3ZUJPX9qPk3PgVLaBpc1h6iEWcp?=
 =?us-ascii?Q?OoLotdECfDHFTHlSMHPZXOCjsF2YqAK8PW+46TWparYcStMB14h/coWtdFXa?=
 =?us-ascii?Q?GG04lVf1P3gCOoyllvPjFCPOYP1EBJG8HNFbIiabf59pHe8kgTw3TCl4NbHJ?=
 =?us-ascii?Q?vLp6f7itH8f7OpftHTgWA6Z4bKkDVbr2xbqPCZW9Lj4uv+Cr2rM6VtJNHxwi?=
 =?us-ascii?Q?3EpRIZKdCkYErAwwTjpyEGY8CmPf+cgWTJtVr6B75XpfPY0Ahhapi8cQSbLY?=
 =?us-ascii?Q?BoK7mtWYRF885KdUOjNAOu0HqzgFlwa3o6qlD2UO4Q10gU/R4KLwnuUTrj5o?=
 =?us-ascii?Q?qY4z189qB3RXupyPBHNeiGfLLjnw2VUaUL4jkv61ejhdXHcXohslq0xdQ6pZ?=
 =?us-ascii?Q?K8sIPANovb/CZaeCEomaALvYvwHl+Z7/L1WRyswhFO8Y5WuIHC9m16ZrmyNm?=
 =?us-ascii?Q?0+MbtHDK9cMD8L+L/T7sO8gbYG5Qt1qJ?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Th6OEtXPN8RphQGgRc812/GlL8c6LCHGc01BISCVUu3QbRUEjCihCSrUuiyT?=
 =?us-ascii?Q?VrgT1COAWuaN66h50Kd9KJIz0wLlAro4ACXQNuNc2pPa0cuz5wTWdgcQEExi?=
 =?us-ascii?Q?J+RMwcuvQCds8mKdZ3m8MfWIFxlrzJfuVqWm/gxB40KSZWldw9fGZZGK2i/8?=
 =?us-ascii?Q?sOWtzXjL0p3Y5t8lOjncfRArNBIO4C6qTe3ZS8guU/LIlbCU0ImYMMqODBgQ?=
 =?us-ascii?Q?l9TNwJ7G1Fu3QI0veuLdkt/ERefRUtlWN/1dyWpCSZ+XKwXNip2p6ZL0qBfG?=
 =?us-ascii?Q?QQbGWITKG67AoplZB7661j7y/llRdZ6o93cdWPnw77Es97OsfVHYvJ6VWtD6?=
 =?us-ascii?Q?xXXVRxxRmFVlHRgsTIHppRMmsA9TJ+lyrhGFN8aIePJGjeJJKzWZTwQkW1hS?=
 =?us-ascii?Q?zwd/Uyd2kthd82vIAOSP3GHJwABUc4rPGEgzMduhdD9o1PKEtjt722zMLFCd?=
 =?us-ascii?Q?WWoNtDE4hRgOAQsRVXxCboeTVjz/kA0rdQKPeUZGA5k/D8oaOEyOM93vpPlV?=
 =?us-ascii?Q?h3Lom6srwn/3yoQTek+qjW446/9nKRrN6Zp3+4Gw29Vr/aesptx/17+souNo?=
 =?us-ascii?Q?V5kEJbCP4CsLIlpDkuPF7RJuO+vTvPtRwel5Fh7QFcM6AiQY6ZDqJeMaWURj?=
 =?us-ascii?Q?GXZ7aMf8rlsSHh+42aPsd2DJru9ZNCAAxZb73G9Yrn1JmyEy/XLeOEJblZPU?=
 =?us-ascii?Q?l7vhYo3T9O8gvbaubf8/7CuPuY9LEtGmtXgVQzZqz7GiBdWxgiIRnhQHqT8d?=
 =?us-ascii?Q?elzgOWCn2BXyQBS+AiBKUDwycyKlmilfmPiel5grVVFoapgoFjyvIEptweSm?=
 =?us-ascii?Q?oocW7sAtxZgKkvKJIzwIVMU6PuuE/6saP8a88x3Ouawty2AzEr3GdHDvWCEA?=
 =?us-ascii?Q?S6Pi+rk/Y+JhRC0MKlTF30BblRxGC8ID3uqffi1yPv21DCTnZU2STznSLjih?=
 =?us-ascii?Q?jgGHzpOU+EpuFR1m4gLym2kwTO9HN3BQrEnaq1nwviidvSwZ4u0flCe3jRUf?=
 =?us-ascii?Q?ZORbmyyW6fjhD8XMEGFhgM7B0sdyuFSu3mPKZUPqnINErH15Scr8fxKi92MF?=
 =?us-ascii?Q?OlHf5Ij59/NaXF/Rb87vO8CalApuYbai6f/lDlWLqf6HOP/GhJesigHt21d1?=
 =?us-ascii?Q?3VR3jYJhG0rxCcqzwXUhLjVQUMF/1E4IodGDtUgo4ZIXv+SnESsKZttq4+UL?=
 =?us-ascii?Q?7v18VfY48EVuaReDiCmoIAee+TX24O030so/Xx2sGfcBYbtTAkutqzK+znzq?=
 =?us-ascii?Q?Zakp634gx4WOlr8CzAbiPTGIlg++tsaSWCGRSHQP4DJ7b8AQSm01SBlb4cPk?=
 =?us-ascii?Q?zMdu8se75kJWhDZa8Bx3vrq/DQL0LLYAegdWiWHn0p2x7GtREnyKN9iTLULt?=
 =?us-ascii?Q?z5oIwDQ7WNBxbes6UIAn5VLgIAsxgpUbbzr0TYHzs0safUQ22wdBbt2EsWet?=
 =?us-ascii?Q?Kg2tWsL170WP08Hi+udCYzxI3kj6muXHGq8VXtf2rlplUZGREJXSa7yuV66e?=
 =?us-ascii?Q?WT3118xYnAP4A60cz+pPn2oZIynryugyLK0RZbrKF0ZEtKzuod9iCyL3xRFn?=
 =?us-ascii?Q?HxHzma0VyAGrvkGv5qhjhWGxTaitctb5eUYnRzpHhkrdjjzsjHqHHxA9xAot?=
 =?us-ascii?Q?5Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 93cdf0fd-66ec-4f0f-773f-08de18d4c16e
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2025 23:25:19.2629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NUAn+zjENn/ximRqCJGDFotDPuM4VywpKeXARtgAbO3018rVJeFjIt4FVNYmkQDzvxWr1uQc0Sldy6GtldwU0Z+u5ZtBzAnUmZwS47ddMRs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8151
X-OriginatorOrg: intel.com

On Fri, Oct 31, 2025 at 01:42:13PM -0700, Dan Williams wrote:
> Alison Schofield wrote:
> > KASAN reports a global-out-of-bounds access when running these nfit
> > tests: clear.sh, pmem-errors, pfn-meta-errors.sh, btt-errors.sh,
> > daxdev-errors.sh, and inject-error.sh.
> > 
> > [] BUG: KASAN: global-out-of-bounds in nfit_test_ctl+0x769f/0x7840 [nfit_test]
> > [] Read of size 4 at addr ffffffffc03ea01c by task ndctl/1215
> > [] The buggy address belongs to the variable:
> > [] handle+0x1c/0x1df4 [nfit_test]
> > 
> > The nfit_test mock platform defines a static table of 7 NFIT DIMM
> > handles, but nfit_test.0 builds 8 mock DIMMs total (5 DCR + 3 PM).
> 
> That does not sound right. NUM_PM is not adding DIMM devices.
> 
> > diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
> > index cfd4378e2129..cdbf9e8ee80a 100644
> > --- a/tools/testing/nvdimm/test/nfit.c
> > +++ b/tools/testing/nvdimm/test/nfit.c
> > @@ -129,6 +129,7 @@ static u32 handle[] = {
> >  	[4] = NFIT_DIMM_HANDLE(0, 1, 0, 0, 0),
> >  	[5] = NFIT_DIMM_HANDLE(1, 0, 0, 0, 0),
> >  	[6] = NFIT_DIMM_HANDLE(1, 0, 0, 0, 1),
> > +	[7] = NFIT_DIMM_HANDLE(1, 0, 1, 0, 1),
> >  };
> >  
> >  static unsigned long dimm_fail_cmd_flags[ARRAY_SIZE(handle)];
> > @@ -688,6 +689,13 @@ static int nfit_test_search_spa(struct nvdimm_bus *bus,
> >  	nd_mapping = &nd_region->mapping[nd_region->ndr_mappings - 1];
> >  	nvdimm = nd_mapping->nvdimm;
> >  
> > +	if (WARN_ON_ONCE(nvdimm->id >= ARRAY_SIZE(handle))) {
> > +		dev_err(&bus->dev,
> > +			"invalid nvdimm->id %u >= handle array size %zu\n",
> > +			nvdimm->id, ARRAY_SIZE(handle));
> > +		return -EINVAL;
> > +	}
> 
> No, I think the bug is assuming that the nvdimm device id is the handle
> lookup.
> 
> I.e. this looks wrong to me:
> 
> 	spa->devices[0].nfit_device_handle = handle[nvdimm->id];
> 
> ...does something like this also fix the warning? (UNTESTED, not even
> compiled!):


Dan - This does fix it...and I basically get it. v2'ing. Thanks!


> 
> diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
> index cfd4378e2129..5456f67b7e43 100644
> --- a/tools/testing/nvdimm/test/nfit.c
> +++ b/tools/testing/nvdimm/test/nfit.c
> @@ -688,7 +688,8 @@ static int nfit_test_search_spa(struct nvdimm_bus *bus,
>         nd_mapping = &nd_region->mapping[nd_region->ndr_mappings - 1];
>         nvdimm = nd_mapping->nvdimm;
>  
> -       spa->devices[0].nfit_device_handle = handle[nvdimm->id];
> +       nfit_mem = nvdimm_provider_data(nvdimm);
> +       spa->devices[0].nfit_device_handle = __to_nfit_memdev(nfit_mem)->device_handle;
>         spa->num_nvdimms = 1;
>         spa->devices[0].dpa = dpa;
>  
