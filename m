Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C50C6256D
	for <nvdimm@lists.linux.dev>; Sat, 17 May 2025 01:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747444852; cv=fail; b=Q4xD+Shr8uK1VnRluIlmID7IVwJglL1jybP0GJ1Vn0GnSd6jjVdkv1ch0uV0hyp6zgQx7Nozlbsi5AJBhI92F/CVmvbBqOOF9R6Q+wU2/pTyvXNUzACIu0Qr+Dz4jauUZFxIKfXWq/LpKXs/0XcyDnFtF6zVfhL46fWI7vK6oIc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747444852; c=relaxed/simple;
	bh=YwQ6Zh2HHzlHRnADOphX/2sXBZXu4POLXRXitotPVAE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=eeS/oHTkwPRDVQSQijYN2AE/sZ6VBHVB1V01ZCXFoIOZK1Z4ckolHIcD0y1z0mMPvRJwcUiwNyvY/QCK8kRz1cdDW+dDWkSduiohrEG+diHCardW/S3xuuEUv+3okPq757xMpivRZh5gGBqBhOhquFyd/prsFoUCnt10a8nEKzA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VbCLcSvc; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VbCLcSvc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747444851; x=1778980851;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=YwQ6Zh2HHzlHRnADOphX/2sXBZXu4POLXRXitotPVAE=;
  b=VbCLcSvcwt8aQbVBeeBGJTYB/saZvllatFkw5HEOIGatwfk2BdXB8cUr
   LW1x/tP1FwUuweRVEsk63ZcYT81FfChI5B13D0V51/eyx+yoxu3/3LQ6N
   UGO3a7hcUFNcWsPEoAkee7e0mzSq46ih1MTRb419tFyxwADn6MghYhElW
   mV/YLqiLKnyyriQqu6apPLRO2JzwxWmUVkzRCHRPbq0b5TRWqDd0TfEV5
   XoLpByNo7l5NWwSjDn/15gLAIThAMxKjJxXfJVDiMDxak0GN+msHRtw6b
   /zrYc31KOQMly29pzJ0RT/HmBWLQJj7Qm6Yt4+Vfj2jVTNtlPgtJxbeWa
   A==;
X-CSE-ConnectionGUID: +ERZ5/uTRHaUmrfBTrpqXw==
X-CSE-MsgGUID: Qoe269y5T7OJ1hn7ykhpeQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11435"; a="49411884"
X-IronPort-AV: E=Sophos;i="6.15,295,1739865600"; 
   d="scan'208";a="49411884"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 18:20:50 -0700
X-CSE-ConnectionGUID: SgHQ0tNpSEiucdKv7Czh1A==
X-CSE-MsgGUID: SyVH0EktTUOrZdo2bzrm4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,295,1739865600"; 
   d="scan'208";a="175977770"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 18:20:50 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 16 May 2025 18:20:49 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 16 May 2025 18:20:49 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.45) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 16 May 2025 18:20:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TFR//9E5oaNG3rma4JGPnGEHiCuhzBPABiBSSPJpaucoIfcpT8Q4fNZxbp85j7QQnZBJCXbIsm9KjgFqCoRiebqDThom0FX1V6YszcDkAHrFINstCkTS4B+z1yRJB2wcPaOYM5o7PLeRgClsVbFZ26IQ/LqL0CNYXqfW2WlDSFPu6fh2srKw77SbaTv98HxnRqr9WJMgFBH9zXfPr58BUnivsJbQXDby98W4a5z5wNpZIvf/peo0ojz+z2e6plR9fVAbGSfLS/wbfdizelEGBOGR/jpOV3AFKin6gQXa+u/Uoz0KE/1bDWPVR4/lEgp6Aijxj5O/vn+Tw2FTpJZYjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4PdBVOMtRnLzxySfzrEzJJYI01dwD4Pkb6ohmw4lJvs=;
 b=rIHkJhf5mrH1krEku7LWtCWOMus4dtkuUvscr8pvLUOqpbF0BdEKU/nKf1v0NuY/YvH7eEhhYS6DbosiHsD27S0C1Zpq1csoBnF/vDmWbe/QeeCz3GYSAdJgqzZLXPbHxy/sXzSy8+2XQlnPQMtOlIYp3PUvYrmdD6tkxVpmUQnRzTRnqDTFGAvBDyjk8VUnfFdei/CeTDxm8GeiYdkwPaHg/U7H65NGA2QZ/QMnyO0oS+qRHhq3qOTWOwPAQaXu8c8YgAnklO1dkx+4BuZdqIUdCfKnbJcnHdR9jpi1AG8/0PEJ2gBt46S1EffhH3DJDEFT9ZKnZ+XOsyoBkiwV7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB8794.namprd11.prod.outlook.com (2603:10b6:806:46a::5)
 by MW3PR11MB4667.namprd11.prod.outlook.com (2603:10b6:303:53::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.31; Sat, 17 May
 2025 01:20:47 +0000
Received: from SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720]) by SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720%5]) with mapi id 15.20.8722.027; Sat, 17 May 2025
 01:20:46 +0000
Date: Fri, 16 May 2025 18:20:39 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <nvdimm@lists.linux.dev>, Marc Herbert <marc.herbert@linux.intel.com>, "Li
 Zhijian" <lizhijian@fujitsu.com>
Subject: Re: [ndctl PATCH v2] test/monitor.sh: replace sleep with polling
 after sync
Message-ID: <aCfkZxJUEAdfenBe@aschofie-mobl2.lan>
References: <20250516044628.1532939-1-alison.schofield@intel.com>
 <6826d67768427_290329430@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6826d67768427_290329430@dwillia2-xfh.jf.intel.com.notmuch>
X-ClientProxiedBy: SJ0PR03CA0006.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::11) To SA1PR11MB8794.namprd11.prod.outlook.com
 (2603:10b6:806:46a::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB8794:EE_|MW3PR11MB4667:EE_
X-MS-Office365-Filtering-Correlation-Id: 132d1005-a7ec-4043-a0e7-08dd94e10cf6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?+A9t30KpWF64tP24+jiEflJ1jeEwtuT4IduhI8bEm3owJRuLT/+QJDCu7ZCO?=
 =?us-ascii?Q?0g2wt5vJV6wyFivdLSX2X0UGOKmFmUF7FlawN+615lpQHctBcdwJ4MCVwvAP?=
 =?us-ascii?Q?2SZ3Ag5glWNCZjFEtpuNiXQ9uWcIJ63Sbk/UjRib+HnXmCUhAF20UdH1DDuW?=
 =?us-ascii?Q?GP/2DiOk51W1Gk4+N/XQ1McAEMIDNcsrei+9b5hzwLBQDmVHmbpLgV6wYRiR?=
 =?us-ascii?Q?6+RpCceqDErtCv7xqUHzv9Yn3L80Fr82vVR1lW5d77JmEobAxyItZguSz/AW?=
 =?us-ascii?Q?Ywag3kM+aS3EG2h+K0euru/S5crN/2VjZKxRG/MztBIbPpGy8YhoA5TeMPoC?=
 =?us-ascii?Q?ssrJDqQKQf56jn9UyXINA481LSrCYCI8uNVbQc89FeKLmszd5EF64ZF7vSkA?=
 =?us-ascii?Q?6bhIBQqY7q/NkHn1mOuxgVUJMwFCiZ0ObfDzCK3QaJVolBD89FssP26009Pp?=
 =?us-ascii?Q?7J2x4LcQPZOH2+rT3Xfhgl6vA81VrIvWRDb52qAr8ow4E1yAGmmkS9tbcdZM?=
 =?us-ascii?Q?IrgoE4DCkyKXXsZp+V4YsRSkZGv/q5omDe+2xqNlG9/q4cfEMImNVz5+OSPD?=
 =?us-ascii?Q?DTFLRA4Po0VNvgbTLAPMxPFn/UXIdRmmTqhspvpWs2Xn/Ysb1hPyJBTgWVsa?=
 =?us-ascii?Q?UbbhnfFpK+v6u0WZdxPjXkllWNGMxAmIh12XGuNREm+9n0WL5FK55s5MKm6y?=
 =?us-ascii?Q?ADbRzzWDi4f6SNSm2wXcmylRmikVMTz/jYxDQGK7plykyzd8P1DDVd/P7Fv4?=
 =?us-ascii?Q?ZlWTRhtYA3E+gXUFuKco3D3+zXPxbrc8Ye8u3pqXs1B93mMuayHCjQF14jac?=
 =?us-ascii?Q?cpO2FizYZ69dM1bUUDLefbrFoYpcnlvp/2lQTL9o0fvVGr4FisBmFmYaVH9j?=
 =?us-ascii?Q?+WXQTVFVHaUHmktpWFuIuPbt0MtvQ5dGxwm8qjcHLvVPvQgXESXDZr4CqjPK?=
 =?us-ascii?Q?QsedX1rce7WUWXOEdMAdR3go+SmTB2YEWMDGDhkdqkhMK7t/TKQVD39xWJzN?=
 =?us-ascii?Q?Vi/4heme6J9/ejhxjW2uvprKq0jQ3dLXERzKIkVUnlan0SLVPt/ejEcBCW65?=
 =?us-ascii?Q?UxkdXgA+vja7MspTAr8oHVA9pLX3BbI5+5pDv9hvyjBeHxkCmxYaXPeHGXmj?=
 =?us-ascii?Q?ICaC/v93SmVm/87JGMQUU4H2mwBbbiVwCwnb4fV24Q4ImQ2JyY5J8aqzL7Qk?=
 =?us-ascii?Q?F7wqfSnX1/GU/oRC10EKzIaycIIENoNYzLPjD3wzby5mDSeBCgE0nD4AhgTC?=
 =?us-ascii?Q?3S/lujNPzVJimXKfvBoN6Mc4MsQjuCZ9twkuEI6L049sOAzTffWaUAi3JwAT?=
 =?us-ascii?Q?oLRabAoYFMIkCQ10AdgyVhU1mDlYxm0rgM2IBd7MboMw6/FCWneN2t3oCpNE?=
 =?us-ascii?Q?dl7sYR4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB8794.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0Cs1pf2rftr54WP/IY42orXgf3eWyxPA8m1RFXhdLUUZy9sqhGi/n79Kk3wy?=
 =?us-ascii?Q?AU5xBcx6DhGNqHC5iGYXPIzxIRSaIoRZKHeRCoVYQkz8E8eV1ALA0Y/e72yO?=
 =?us-ascii?Q?iJNlAEi8BXHYHQSLHSCHhFD2DR6BB7DIIfWFUBMl+x0GwCZK998VEe6DAHd5?=
 =?us-ascii?Q?9ujYHPd/hTviAZPxlI+3p0CyjiK3HoaxvUNEU4mB76OqKMfmAU5Hj/jcIClD?=
 =?us-ascii?Q?F3cbdK54lCVobFZRX8vIs+CHpi80mx18FrZPU6fGAbMBcm0nw8RI0Man/x1e?=
 =?us-ascii?Q?SW4xfPrvxH33vvsuBjwPOMMt0N3WTPid/AMjGJMLNgd+MNjO0XCHBYkc1ExD?=
 =?us-ascii?Q?RH1lod7gTo47uT5LZPmiONHq2jwh/cJeRdpZzX76Ov92CbTiLeh6OO6I3bdy?=
 =?us-ascii?Q?DIdqUT3fkRbgEJVkCbd9yLuVG4TOPnvXOTSakVC6+7Bdhi9O7t1DHMvXbhSL?=
 =?us-ascii?Q?Caqyf8Y/zcM2A3USmHpp1lPrOC5Eq6TIjAb9UeKW9yma4A42nPYV5FFPq4UD?=
 =?us-ascii?Q?1hgRmQUYdS2dfwF65eYM3XOnxW8XUC3L8vrz+noqIib9z4jDdilwPZUFiPVj?=
 =?us-ascii?Q?zstcS4p4K1KM3QM9yJ5kG0D+2bPcttCQnVn6M/jVpeHfHZ4es/DL+W2wD0TX?=
 =?us-ascii?Q?/fKAqRWAOJ1XqP3i85a3N8iNclIy4v0X9Hjaooz/NZH3RTNLmrozZma8R+7v?=
 =?us-ascii?Q?ZLeDNq35JMBmFG+LD2D2xywAfjJQ1rM0o1Ro75WhZ0pl0eJpUhoKIEdQ1djd?=
 =?us-ascii?Q?1CE8tDMUqFYWeSajdXO7+zHR9twzfcCOrtxTBRHQK8K8QVid6kvC2+wYmUZj?=
 =?us-ascii?Q?uyhVBEYa01ClaQiGdO4cnU0blw9LyP2l5kxSGRSvT/Inc2Pd8DMgoeOHU0VJ?=
 =?us-ascii?Q?EjyGcJdQngjS7IJQIVe+owqQG0s5Y9PGiyrjAxmf/1fMXEuSgqKB+1QOgBgr?=
 =?us-ascii?Q?HFJjrzXE+sReG/KXJ9rvvifVOeUx+48AyKIg6piUCCX6dVXE0t8Pp7L2aSr2?=
 =?us-ascii?Q?ZzmsILn7MXr/Yxh0M3CUFSVSp2n5rFmByxt4UCoV59UvlLwOxq0jWarEyx71?=
 =?us-ascii?Q?mE5NuXBOpfxFBfL/RhubtYfbh1pbQWpjP5oTcg3+ONO3vsb913HtQxoDYjvp?=
 =?us-ascii?Q?x9VTr0pWpuy7xglnN7LVZ9CPjbOYsd5dJUukeenjq9dyK2CEXfjNfYCZMOaC?=
 =?us-ascii?Q?Mw3L/n3sueafeXwKd9FDs5aeK3BGsXpH5BUqDndAs++P9fuAXAgqiiEAuDku?=
 =?us-ascii?Q?xuDxXPw8o2jHb6nXPJ/TGijbDjLzAP4KDpPH//CzYvzD/gX2FMxkzv30Vjvu?=
 =?us-ascii?Q?YYX4XQfORFUFUp/EFU79EmJbOWoGptxLrhRsbGXR/Xq/o1wXjnhhu/HyLxze?=
 =?us-ascii?Q?kS30asTbYF3Po+wjNtQQ1OJcwRhoi9aNzLA9rXKOkssdUFhpvWEvXB/v6IeO?=
 =?us-ascii?Q?ZNgWWU5HziGn97G0jtcLxooU2C2cj9EOZU18JqQ2YoiBSYfHWtoVtusVdlbc?=
 =?us-ascii?Q?PeER+obMXxovHvmTQ85CIpuJkDCol+KDztPHAP0QEl14FYqzgMArmpU76Zkj?=
 =?us-ascii?Q?itXwrHXsMnED2VARL//Ufdl3IchbiUHYRBSqnqK6yUMuOPGSbjk7ei6abM/5?=
 =?us-ascii?Q?PA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 132d1005-a7ec-4043-a0e7-08dd94e10cf6
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB8794.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2025 01:20:46.6332
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r/LSaSUZFaBEm1lS/LopzkrmO2yM1I3pe7iEFcjGw0zbX91jQWEjSUfYV5JXph7vkGkzJejVDq026iSpnvWI7LpozUZ8TpcCvZ9/CM5fJqo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4667
X-OriginatorOrg: intel.com

On Thu, May 15, 2025 at 11:08:55PM -0700, Dan Williams wrote:
> alison.schofield@ wrote:
> > From: Alison Schofield <alison.schofield@intel.com>
> > 
> > monitor.sh runs for 50 seconds and spends 48 of those seconds sleeping
> > after sync. It sleeps for 3 seconds each time it restarts the monitor,
> > and 3 seconds before checking for expected log entries, a total of
> > 16 naps.
> > 
> > Replace the sleeps with polling that waits for a max of 3 seconds but
> > does so in 30 0.1 second intervals. This leaves the current behavior
> > in place but offers a shorter run time for system configs capable of
> > a faster sync.
> > 
> > Again - I'd like to see some Tested-by's on this one because it wouldn't
> > be the first time my golden environment wasn't representative of all
> > environments where these tests are run. Thanks!
> > 
> > Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> > ---
> > 
> > Changes in v2:
> > - Poll for 3 seconds instead of removing sleep entirely (MarcH)
> > - Update commit msg & log
> > Link to v1: https://lore.kernel.org/nvdimm/20250514014133.1431846-1-alison.schofield@intel.com/
> > 
> >  test/monitor.sh | 43 ++++++++++++++++++++++++++++++++++++++++---
> >  1 file changed, 40 insertions(+), 3 deletions(-)
> > 
> > diff --git a/test/monitor.sh b/test/monitor.sh
> > index be8e24d6f3aa..61cad098d87c 100755
> > --- a/test/monitor.sh
> > +++ b/test/monitor.sh
> > @@ -21,12 +21,45 @@ trap 'err $LINENO' ERR
> >  
> >  check_min_kver "4.15" || do_skip "kernel $KVER may not support monitor service"
> >  
> > +wait_for_logfile_update()
> > +{
> > +	local file="$1"
> > +	local prev_size="$2"
> > +	local timeout=30
> > +	local i=0
> > +
> > +	# prev_size is always zero because start_monitor truncates it.
> > +	# Set and check against it anyway to future proof.
> > +	while [ $i -lt $timeout ]; do
> > +		local new_size=$(stat -c%s "$file" 2>/dev/null || echo 0)
> > +		if [ "$new_size" -gt "$prev_size" ]; then
> > +			return 0
> > +		fi
> > +		sleep 0.1
> > +		i=$((i+1))
> > +	done
> > +
> > +	echo "logfile not updated within 3 seconds"
> > +	err "$LINENO"
> 
> Hmm... not a fan of this open coded "wait for file to change" bash
> function. This feels like something that a tool can do... (searches)
> 
> Does inotifywait fit the bill here?

It's not capable of knowing what happened before it started and
there is no synchronizing. So a lot of extra checking when using it.

v3 will use 'tail -F' and check for the expected number of timestamps.

> 
> https://linux.die.net/man/1/inotifywait
> 
> > +}
> > +
> >  start_monitor()
> >  {
> >  	logfile=$(mktemp)
> >  	$NDCTL monitor -c "$monitor_conf" -l "$logfile" $1 &
> >  	monitor_pid=$!
> > -	sync; sleep 3
> > +	sync
> > +	for i in {1..30}; do
> > +		if ps -p "$monitor_pid" > /dev/null; then
> > +			sleep 0.1
> > +			break
> > +		fi
> > +		sleep 0.1
> > +	done
> > +	if ! ps -p "$monitor_pid" > /dev/null; then
> > +		echo "monitor not ready within 3 seconds"
> > +		err "$LINENO"
> > +	fi
> 
> This does not make sense to. The shell got the pid from the launching
> the executable. This is effectively testing that bash command execution
> works. About the only use I can imagine for this is checking that the
> monitor did not die early, but that should be determined by other parts
> of the test.

Understood. I couldn't find any clear 'signal' that monitor is ready.
So, I've added one in a v3.


