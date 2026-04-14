Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C2420B810
	for <nvdimm@lists.linux.dev>; Tue, 14 Apr 2026 03:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776136411; cv=fail; b=erISI730T309kHwVieXTL5oqmRdBAnVL+pgQutjHUsjU/SptHot7b7+jEPic+DyxTrrbK/ENvbtrEpjf3TPKtlPF5rhl1eN0F2ibp9TjM01p4BnFtuHAvChpN7R/7dmzG/TNa4n7NF2+NCTp3G+ZPPybGYBT/2gVjpptvrK0ooY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776136411; c=relaxed/simple;
	bh=avKPqJSR/CXiNcRejx170X26FrPw6EX4Lz4Yxe5FHAU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=IQcvrlDmQmtNpJgnHStIBNRs260FUs1j9MGu0gU5BiO9pqisjoim2MB9r4tPOqEFnqwrsH/zpQIV58yh+rIJIo/yW+gVJoqPASB8A6EwCoUSn9xwHz7kBR/UhRjKYA9FQjw2ym0TdK84O+BwxcdGf/2dwafDLiRSWLybPW1mp88=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J+59DhDf; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J+59DhDf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776136410; x=1807672410;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=avKPqJSR/CXiNcRejx170X26FrPw6EX4Lz4Yxe5FHAU=;
  b=J+59DhDfPCZDCHsnqRgr2IzPVj/UEuHXyjsNWAFJMMy6zuq0MQqbNn2T
   UYBPfPZnhIILn/f881uJhNnNaB0K/hEIsFupXS4HOxKoJdSCvDKjYHnfw
   fFKzyVZhAAkagTvlme5LGb7XseOmLSFYVZ7Cx3TN1cTXXxBylZ9wgbCqG
   avjI0d2kVoYvsLWNMbqbdtdPjTzBGFIUWlmP+b3HUWBFxXiZP/xmPsUwX
   EL9/sQjfunhq0ku3EsWbf0LH/kcH8p/mE+u0tJnpaCOQ/UwHaVxZ/zACY
   ahrosIOrRu5ax/O1S2DSn8S4MvnvJIvdUpZRudPUCkU0L2alCQUkuJ2B5
   w==;
X-CSE-ConnectionGUID: 1RgJK+82T4O/QldWrPganA==
X-CSE-MsgGUID: pnKZ+PpuQXSYJrZH3ACpEw==
X-IronPort-AV: E=McAfee;i="6800,10657,11758"; a="87782337"
X-IronPort-AV: E=Sophos;i="6.23,178,1770624000"; 
   d="scan'208";a="87782337"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2026 20:13:30 -0700
X-CSE-ConnectionGUID: f9iozjNhTEWI3oRPJigm8A==
X-CSE-MsgGUID: S88bIGnrRLGNmP8ppgnwIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,178,1770624000"; 
   d="scan'208";a="227299862"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2026 20:13:30 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 13 Apr 2026 20:13:29 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 13 Apr 2026 20:13:29 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.43) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 13 Apr 2026 20:13:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fBOkz53pYxGonbRbYt1OwytUU5z3cA6yWUiOI06eshhtkTZQVvXZHko79QNGXSzJYGdKw7yTPGHq2Piv1DU13fQReuAd5dh4HNsDES68d+n8M5P2t158fjMdfrq/KeBpC2ZFGvN+szEQ8WrgBHCFqSSjYg1QfkEqEQsJvXABLv1AYOZP76AYAS/AAW7eg5ZN4wHSu/KHblN0/xPxT13r1h64L2dEhi3E8CrncfXC/qUiBsIA8i7l2o5674aCXObaRHOqi/yqN/+Rw1T5GGDCYrf4nBtHNtXqGvDR9dhdF3m0NeSxzz6vQoRk7xTchaldq4zFpxiTQfrnUaszW7a7Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/EHARJr2UrkMZWlUVqV1PMccQ/3cIRdjs2064x4EniA=;
 b=HLVHZ8o6Tg+AoWxAEfBtCBFrTBkvKjjG3jWj0xvdiigzqhByPaLk0T8wvUEICoMAOOKn0MaEf/G+QhFZ4J2F4XxDLsDl4JGNmm1gcvYUFjnPyMpHQhBrds+UU2PycRy+I9+jdjdtMxpmw6dnuyMZeOEJwcKVyVSu+Utt7aj0rD8XVFFLDc11MxGXKeKhesLSgC96ZDdXvECNSxh68v30zI9Cr1HXxL/r92DQ0qZSzXJWZoEKoFYXkjy1sTsus4uphlJvSypJfZ3IojDfK37Ufsr7B2ggIgcBrcKO/xEyOi2NHAew6viahSHq9tANoaVIn58QMb7M3x6/3s+ju/3ItQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by DM4PR11MB5262.namprd11.prod.outlook.com (2603:10b6:5:389::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Tue, 14 Apr
 2026 03:13:24 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%8]) with mapi id 15.20.9818.017; Tue, 14 Apr 2026
 03:13:24 +0000
Date: Mon, 13 Apr 2026 20:13:21 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>, Dan Williams
	<dan.j.williams@intel.com>
Subject: Re: [ndctl PATCH v2] test/cxl-dax-hmem.sh: validate dax_hmem vs CXL
 collisions
Message-ID: <ad2w0SrHaeIXz-l3@aschofie-mobl2.lan>
References: <20260404025123.2967169-1-alison.schofield@intel.com>
 <afd0f7b1-77d9-424e-99d7-d2e4bd75ee79@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <afd0f7b1-77d9-424e-99d7-d2e4bd75ee79@intel.com>
X-ClientProxiedBy: BYAPR21CA0011.namprd21.prod.outlook.com
 (2603:10b6:a03:114::21) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|DM4PR11MB5262:EE_
X-MS-Office365-Filtering-Correlation-Id: 50512bfa-4973-4a4d-a182-08de99d3ca00
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info: VFyFoUR0RL/357PwqI7i99OjPch2jvuYAEe0aHkPacYz1o2XvqO1iUSG/YfbbzSCLmat1oWslvKaP2Dq8sdJ1FHcPuD9NPTbcq+z0rNavwV/3Hwkvg4Oon9loePxZlIM/W+sUUgnwhRpiLhvMefNhOWcIVffMLoGvqZG+0HL42f4Pd/6RO7rI8nD6FcqWdO+JuhudN8CBskRWVGEHSMGhs9SmTodVUsTcuvWsgyEALgfRu/niWew6SoSuWwl0VubVvbu2iTegqzySZiKZT1kV47iZkeiFzlhf6T4nva2CrquJf8tE5f418TzJl7kzK8qitPUQC0HINeQ+mnkmPgwNIXGP/6TMDfQ7r8XxwFtNPTNY7TXLWc9Mt5e/kGDAXPCdBXDkdxPaezNK5BU1Hto2jgUbm18X877lCKmibu975SRfMGr2KCiOwNWZexp5G2CHEyXuIKiUZq4R/Kr4+yhjnumdaNv1eUKbpWsvsKJzSF2+Ig7jPSfxwSA/ruYCE9sIQLbF4nbAAwpSLNFuMzSmoMmpwcfPhB7uQ8MgsuBGnT25CjvIHCbS7HqcqxF2vhRyfIGqTMs/FBesLDy2rLbp+nUB0h2aUGyrBAm9fJUg275aj7XX/vvdP6rhCe70axc2qeT+kh79xSw7Ul5VQx31Xri3YHUN+HcTkjiFmWh8xG5gxO8A6AzzfNtAEGFLJXkX4x+qdRzEHTExurAOFC0ByyMQ8cR8qXEeo22r5FpWwE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LwM1orTelQI7i1j5pYwDNhBN4CH7fjx2HjPeiAZq1RP75NgNc338iiUAwqZB?=
 =?us-ascii?Q?pfnVUalE9cV7a1f3Oj1vDRHJV6wjFJNnlOSFHHaFyEE/m5lGADxkLIwePOyu?=
 =?us-ascii?Q?DWR2BKvmbSPv2Z0l31IWq5t7f8JNVQn6T+3NfObEc6I15oCQtPoRNRDwRjWA?=
 =?us-ascii?Q?rfYtCacEc/aRwUlYl1ZEeqOs1trJ31uM+TAzJE0LOWkxI6rRjSbu3TfhoxPY?=
 =?us-ascii?Q?qQBXZFkkwdnp7OmaWcqM9CvKFJpUam1NykqjyMozKdCAgyfb413stOfE70v+?=
 =?us-ascii?Q?M741Ks9+IM87B5QHIihmB8WMaFt69cU65C0s49GyVIU/vAdiupC/CyF81EUo?=
 =?us-ascii?Q?X3281uzgTlRM4P2KNrn+f7UI77G+bfjEVQAYWSE2khlRAJu+2wGg6G/x8/Ws?=
 =?us-ascii?Q?kI3x08bhxXsucOX+iuQtHqxUxCPy9cM0Qd9EZT99b8NVNHMMxrAgSHfI0kpD?=
 =?us-ascii?Q?dm4Z84DCJGqjemm2DugyWqSs+YRvfcOWgI+eewdIeZNvunREeRq1LZM8IzLo?=
 =?us-ascii?Q?ppR9vQ2G1JZ0Gl0iJfIU2OyWXOXZtRuCS43Y71ljXcUk9EA4gjCK9w4DL/aO?=
 =?us-ascii?Q?ftdwr8qBuQ/0U+G0eYncyS8k1EGgB6zh4FfH1dXdNDPePTr+QJbSYUHbasNZ?=
 =?us-ascii?Q?eAx2jHVadRe87yHhKq93WbCwD19tg4qGht103M8obMg+O8yrxEnUVVtYjdKF?=
 =?us-ascii?Q?lCB2UUvFr/tNcUd52dge4PBw0IQoX9hue1Ex190Pz4jLeSVsAtoLgIZZsGjP?=
 =?us-ascii?Q?074B3tv60BYXu520l7qIbN3Jx4yJKYd5Uhw2wHhNzyH//SJseUmeXGBzuwe/?=
 =?us-ascii?Q?Cp/B2sNPEsitX+MPG4eBAbWkFDdL+eMgIkspGf5rg/I1XKheDPf0vYHOEDwB?=
 =?us-ascii?Q?QHn2bdB/aORb8HnP094u3UkAuqlBBIF8381E7bHOxzKSzFm5Ia1C01wzuB9U?=
 =?us-ascii?Q?IxtzTH5he1IrAkKekzO62wxnFkdvhw7NoR/EbTGc13IeNe4kexBVzxKE1NA5?=
 =?us-ascii?Q?XDW6/+9qAAeTQokF3WAtpnT1yMOPW9X1It1mp3zT0cIYUNwe/IOC6FWLhph0?=
 =?us-ascii?Q?YHbgwPOLIV/Wa/FiOOGEDWZy+wZgu3xQtefJTbUTwT3dB1NMlAKnT0cFx0kP?=
 =?us-ascii?Q?t9Oef6ykcFWwacRy9KN4yUnOkf/1KDXzLeN2hOTMH37wPFKu6apK3h3lrDSV?=
 =?us-ascii?Q?Dj3dxWhnBNr9m0p7nkSu6EeA6n9GEwRWW5oSHHDJP4FZ4vzRWf+2QVGthrS5?=
 =?us-ascii?Q?Gumwm48alHn1ziQ1dvAE1m3w/foXpFPSLJ+o60VXuMJUsC3j/yB9SV+zVaU3?=
 =?us-ascii?Q?OxYSD9zwNbBuzdLeTjB1qiaUuU4SBukFe5p0q35oDgSZmeiCFBAf1D3Y+KC9?=
 =?us-ascii?Q?Xz0zIMkFEGRiILiZ639JwgZ51rDqm4TeQ2LE0Gefdcjvbbd1TABdUqudPBc7?=
 =?us-ascii?Q?l8YFuDnkhlu+GlFlcGzDvGpF7JbbpCvrRW+ZY7cAMCkoQQdkucD12RFM8ECT?=
 =?us-ascii?Q?50E9IA80EWUZSnYpW5xhn3bzfCLPeCevrfduSTnS4GPcnyK7sXdNw1A7hnoG?=
 =?us-ascii?Q?uNV12CKYV7GwGtxmmPargdRmolY/tizrOVPQCiiLxOxpmHxMtHFKX1mNOF/m?=
 =?us-ascii?Q?exBdR2ZUNEnheLAiAqSJ31xtXL1HuDC20CwMsj5/9vgQdhwRUafb0H47ZMPU?=
 =?us-ascii?Q?c39r5340lT79d10/lK8xXPu7D7xlq8B3X94H5oJY1Pgx0Qo+oqGcAhb7aRpQ?=
 =?us-ascii?Q?3NEEjdz70Nv1eLsarQOiexikf8rEmZM=3D?=
X-Exchange-RoutingPolicyChecked: LWk5UyWZk4n6lIOr8rjz9ng/3byGtqznkgrwgZOGZIfM40gSrc2G1t8LNjkgokX13lb2zB6a1E/AbbGbnAw4t4m4+0U2syzwemef61zOY7q8p57eOcDiT4X2qTvZmxIaeBZGl1SVNFRhjnZytFusqV9fjP3MRtcFOxtlCB/TtnBqYSIOaknr2b7f3rUg+27AgBtl4b7o+AjdaZn9nNT7Jppp0icXMij9/nvaX7ZDSMf0sUIMXLQmcXYNNgAX8KZVjZGg1rTdlyrp4j9ESy9A+WLBvypIy5xXpTk1+sXPNvYW0T3OpHVzXtHry0RRIhyNIdgR/2j4b87KgsbJEAwqHw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 50512bfa-4973-4a4d-a182-08de99d3ca00
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2026 03:13:24.1083
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ApaJo67c+dgU+u7U5a+6DyoEDuD1aVBguzH4C3wcwbrTv2O4wdE1XERaGyxxtN8u3q/kBDhoyJw/8ZjgCynI+kBPGUdTfGwkLNS8pDVJsig=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5262
X-OriginatorOrg: intel.com

On Mon, Apr 06, 2026 at 08:22:13AM -0700, Dave Jiang wrote:
> 
> 
> On 4/3/26 7:51 PM, Alison Schofield wrote:
> > From: Dan Williams <dan.j.williams@intel.com>
> > 
> > Use the new "cxl_test.hmem_test" and "cxl_test.fail_autoassemble"
> > module options to implement a new cxl-dax-hmem.sh test. The test
> > checks dax_hmem takeover of Soft Reserve ranges that collide with
> > autoassembled CXL regions. It depends on the cxl_mock_mem driver
> > to launch multiple async probes before the dax_hmem driver attaches.
> > 
> > [as: do_skip on missing params, explicit param usage, robust unload,
> > check_dmesg, misc style]
> > 
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > Tested-by: Alison Schofield <alison.schofield@intel.com>
> 
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>

Thanks! Applied https://github.com/pmem/ndctl/tree/pending

