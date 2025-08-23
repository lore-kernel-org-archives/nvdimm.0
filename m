Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB9A0366
	for <nvdimm@lists.linux.dev>; Sat, 23 Aug 2025 02:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755917202; cv=fail; b=gBEQvOjy92nEb2nvH3NoA5HUwsizzZlcGZ38b4LeAavc2B/TVwTXqRyckis/CM8nrcf94+DjRdsQa1he60zLRQ4qpiM3G4ahh31I9eXD4PBcIqyABJfoOaZ7voMsR/+fA5RcH3GzUAc0qD0EV41Y/zuA0Fx+SDcqIrt8WV9FXJY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755917202; c=relaxed/simple;
	bh=3piseJIEl6NgCgCwxyies+71NNPX+FSFt3D4mxUh2wY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=aPLCRg8Ykan3ZrzDuweh776m9GWU+SLdAulKPi09mM55Og5GeOIZjRIjrM/OB3cmXhMMfS20ShQyrVNwD3BfnPj7yLNYcSbA/MmVag3rDl/krBBH1ebiFpRQMnPTGg0IVp+ix86Q4kMKGd6nxbjB0MOrlvIiTLjPUY5rQ+6NWdU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e/wBFfoK; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e/wBFfoK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755917201; x=1787453201;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=3piseJIEl6NgCgCwxyies+71NNPX+FSFt3D4mxUh2wY=;
  b=e/wBFfoKPrbquWiU2e8c3BQym9BRp8duWBNNuqi6KbT4Ijdv9sZWx6Z9
   au9PrsRyo3mtjyZ2KMfgnsr9WxJFphASaDEERY5Uj4SV05kJSkwALpITg
   LwtkBnMTUk5/0x/1q5QVvrAMkCy0sbvAd3oNlTBDDxrPFLIJL+VdXIxI9
   KeUBLoDUm1VAoiXTBM+BDeYKn9PD8YMoYRtc7tly130tVAvNr6TZax8W6
   Qf+Ls7zA3sG9gRwT+16tMjmw20M9nqn6qh0t+DIq8/RmTWRIs5vWopywg
   /OM4ycB+vLzLXRhN6/owgKxZSL3cgOsDDIzO1S7k5bEuXCixh1yELkUKk
   Q==;
X-CSE-ConnectionGUID: EUILk2ZHR5KoanYYy7JPBA==
X-CSE-MsgGUID: Ya9HcOcHSv6qRZ2cR/w2+Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="58290191"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="58290191"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2025 19:46:40 -0700
X-CSE-ConnectionGUID: u55FKqZVSAi5A8HiNxzTKg==
X-CSE-MsgGUID: eHj0rAFNQnejLhsVpCtITQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="168747718"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2025 19:46:40 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 22 Aug 2025 19:46:39 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 22 Aug 2025 19:46:39 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.49)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 22 Aug 2025 19:46:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HI8z4saAUPQkKE0zp3r/TkTM8hVt3t3Ktc6FMwHqTnePBg61rFHX3eZc4HkdX0M298FZU57kibfGADP8a95Ubb42RtN75pSmGlsLxyRFxIPUqPM7Pdzlj+S7toUq4vWfmlFJ2Tytmi582U/XPgbQmpK/3Up3ZAP53dgGTQgD/sdsi4kQGVjM2yIrvPVkfX08TfZbsT7sZ5nb3n59gvQPLsDsKzTSegRzclJ6m/NjMNaqiSzNrH9i9bYsk7JA175iolR5HfFd6KDfB5pUlBRqMUeJgkaMEo0xhex6qU6Sw6EnLdzJ1urskTBxVlnbj33n5nsKj4gp5ZMScdflDDnyHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xlJNtdDVc89Xa7GjpeSvmlRX5fAvC/0x6Q3mAnempUI=;
 b=a669olkIFKc2ok0YhaZYSumm1Cin9/TqXS50cP8BT1uHPAGcLdNqEANQMDeL9wXZpGWf4490VCEPhbRh/w3mesRCAYlFezKHzShRPtzIyWgZ8yqh2+I8q2MEsvH2rJDrgJu4mZahF7w9oPw6GXzxeSCfVHp1pCxu7EFfuT1LZyxGB4GdgSaU2xl3OdZlywP+UIw7LDKG5hGQ9eYuauH6s2g+mp33ZxjM0QFgR5gMA0gGWuNFj3UMy/+nrODsVgRd/h/xU9hs01VMOERS447eUIUAE3k+OvtXubf3bdH23gIEUAmpHTHsiyeQmZcPbBTK0tqws1blDlJBD/rolq3ZwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::80b) by IA1PR11MB7869.namprd11.prod.outlook.com
 (2603:10b6:208:3f6::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.15; Sat, 23 Aug
 2025 02:46:37 +0000
Received: from SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 ([fe80::4df9:6ae0:ba12:2dde]) by SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 ([fe80::4df9:6ae0:ba12:2dde%7]) with mapi id 15.20.9052.013; Sat, 23 Aug 2025
 02:46:36 +0000
Date: Fri, 22 Aug 2025 19:46:17 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Marc Herbert <marc.herbert@linux.intel.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH v2] test/cxl-poison.sh: test inject and clear
 poison by region offset
Message-ID: <aKkreb9BiccUusuS@aschofie-mobl2.lan>
References: <20250804081403.2590033-1-alison.schofield@intel.com>
 <5dc34767-7104-4184-b18f-44f9d3b9f483@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5dc34767-7104-4184-b18f-44f9d3b9f483@linux.intel.com>
X-ClientProxiedBy: BYAPR02CA0026.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::39) To SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::80b)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PPF0D43D62C4:EE_|IA1PR11MB7869:EE_
X-MS-Office365-Filtering-Correlation-Id: a97e1201-417f-4361-0487-08dde1ef471f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?3hjDKP43m/iqdFznx370QwFQXRXT3znwo4TSnzEcwm0pnO+2Hz3r2dhD3swW?=
 =?us-ascii?Q?u8DeUO2vvRZmcTYPBa5yR9W+7OevxE6Dnh4aZLNkaY8aisTVPOTErOSsgEg/?=
 =?us-ascii?Q?WnFgRu833umwGyM1HAorTvo+Gh3cowYElcChz46j89hR/Xq9jJdpdaPQCQAj?=
 =?us-ascii?Q?mJgLlWNeXkwTVeYUk+X5bX1vLfU4mJdYF+YEVp7S8YfIneSf5JNTJ2798Zbz?=
 =?us-ascii?Q?ORPpJmNDeaHZwl2oslv8YoGGUtq9johJzaJmKqgUznmtdoPGvOzxN4HiDBhJ?=
 =?us-ascii?Q?AZpaJKB2tRcqn+hLsMXmC3eak/xwo7fH5bMWq9sWVFtvLZ7NiGoIT/T2gXEf?=
 =?us-ascii?Q?AUGPugxZvieRwbjc5oU0iJWriWdnLquWsW8FctqbYi1Ta31fD8xM5RLu+3XV?=
 =?us-ascii?Q?kyZPwgRfgwTVo60SrfOPUQ1q4tQH2fKbdfQtouSerZjVnOCKQOK6uovOY3iN?=
 =?us-ascii?Q?7BMpDRQwIb0e72gGgO+4zttlVvXb/FmxmY5r3ZITV61LqyIwJQe3AXe9ji/q?=
 =?us-ascii?Q?2M3eYBi7d4h9bGAu96+7Isk8VDjVTG1zbHGODVfXDMo23BDRja5HD661qGFt?=
 =?us-ascii?Q?hCjaTY9sTNPof/2yfhiX6KiXJWBYuXreeL9F9hNmk9WSRH1Ni0whFXL1Wtvr?=
 =?us-ascii?Q?i188SwUKkwQRXqFSjsapgnYXAxy7eEAXrgg6tOuUfSMotF65RqkI1pnibabz?=
 =?us-ascii?Q?UWP044Eo8MBKydC4q40BMdJ3dtRPoKOzEyRwHzIyRBspV0C2EpL/ZHZ1+7vg?=
 =?us-ascii?Q?ihEJI2+viJ43unLEH18LAgsTrn17dduKMQeg4gefY9hdBc0+kTjmcF0R4THX?=
 =?us-ascii?Q?8SK58Rgw9pecnesQQiH1RBUzIAVQ50h6UX0409UsAfmQFid69dKVwZnS/4PY?=
 =?us-ascii?Q?oTBA/h61SyL7LICUinLcnVkGESvajF1ZqbkLZtVsHJK7eZe9B4idU1XMJMgb?=
 =?us-ascii?Q?sDbsIIdfOKS9o4woKfiE9tU4jyOUxFYxB4YffuwHgLiHYXbkoxukXP22t5iK?=
 =?us-ascii?Q?xvOzrq9LaQq/LW/oQ/hA81PM/5UMYN19NLaAC+k2LqP+SO4iEYgB861Fvs4M?=
 =?us-ascii?Q?Ur177BFOk+1iPOKYiqcPUVXQfhlDK0KhkjrjRjJxIPceUn/1rd1117oD+96K?=
 =?us-ascii?Q?UAY2SK3K5X6IGh0UjoOXq5hQGdy9qtpR77HnXHXh2r2pZG+fFmBvXhmwH2L1?=
 =?us-ascii?Q?6GimHxg1z/REDZjPsH55FZvUfzOI7JNsLNcPhod8v0qV07NBXDhTBx1NvMDw?=
 =?us-ascii?Q?zFJQV5mRijhEtWivZTa6lIcWzCXLHh+YJegsR3PuG8XZbQ178JCbdH2JFM9v?=
 =?us-ascii?Q?X5yJGjIDyu/pGnF+x4Z3LeujtEkSwbxQZFZHO+ph51vkraZkDh7vaZ1HpX8T?=
 =?us-ascii?Q?C5niBLlA0jwVAO/tR+8BeQNo7u2UR+BXZeDBSr75JDr2YsVt3Ax1mWOiQ3z5?=
 =?us-ascii?Q?168Qa2eDoCc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ5PPF0D43D62C4.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hsqhN755Zu/gWVS91ddgA7HBKqb9OvQqPqTB2Nc2fIz0pVNscfBzioh7DX0n?=
 =?us-ascii?Q?F6tg47PwukPrBb/Q0/Ab/aooXFn7yQyCdIqb0vyy1C81r/QJAl1KCOfVR2RY?=
 =?us-ascii?Q?rWf0cMtKmPJj57vZ+9Zu2MmRLQg0VtUl+xpzPEhwLpzfG2AHo0k+5xBCeX/b?=
 =?us-ascii?Q?Vif2OnHhQmVOwFDDBg5goKM5QqO5phqnKh0lIrG7iTJKIuI1BxHHpCtItRmw?=
 =?us-ascii?Q?47OQQLtzE/uWlyI9nS+IfVuhoSDmkarr+ebYdZZoDgyq2D3oCmSdQKt9XBD6?=
 =?us-ascii?Q?lt9otCx9l35DjFloX/K1RlzPnN4Qlh144rbmScpsoAXND25wErnjgsdMZIHJ?=
 =?us-ascii?Q?YNt61WdVvLn1bdjKtSvEKR0CAmJOdTuGvB8wjwQzXdPR/jaitmVpUgZlAnRs?=
 =?us-ascii?Q?sO6m7C7iklY7mRVBaVeoDSkTmPeF566uQGOfBNx1PPgJhAMBshcglV0KCe3r?=
 =?us-ascii?Q?J9CFF/df7CXm+yS1tQpXmLeso0LBNE8I0UfXRrUdchu/KNHuXSol6bqSz3uI?=
 =?us-ascii?Q?5a7XWBUlwPy1GNGdUzKujV+6zgnIEzAkp9ilGxGDcHD0ekReMlFZrTr64kv4?=
 =?us-ascii?Q?3QMqoCtQDSYTczVqGDQ1QyNw+TQvEO/tjftJFz6Qtqm+WLq7Y4ZxWXzrpL9p?=
 =?us-ascii?Q?ngOUfRIVfSgW/YKsz3XOjQTWVLhPcU3xFYl15PgfBw2zyS+eFPmAG4Wx1iTE?=
 =?us-ascii?Q?61jlQP3txSsnqU01+Fy7nSZ/PMLn6cXS6MviKnKjfjHf7V08D//HTy/TxsTL?=
 =?us-ascii?Q?mHcccT4mzjIu5M+sYSG5VF+pyk2et8daRbP2QswGJIPYWO+FJwkKGsR3bctq?=
 =?us-ascii?Q?yfaBc0+Y6rJPcU5e143B3y0IIoCOYMLZtU1axLiZByA1X4PSy364FWDO7xrp?=
 =?us-ascii?Q?2R30d1a7Y7cVgD4JMtfWom2XWg0/I/neKrG2ahjBTqSkX/vaBPXnAbpH8IX7?=
 =?us-ascii?Q?qQgKo3cjSnQTH0YITbCPJzqPvn3GjAe/x7nY8KLs5grSLRP6sWFSJJlkokXq?=
 =?us-ascii?Q?oi/osdgR0tGlt6iHAhj4neGs6vHS4CIuvw2yu3QKnT2zT9aUxdqiSZp1gqS2?=
 =?us-ascii?Q?7j7CCMMDAtKtlOYgU8Lv1QwQRtueGpq97PbnjW6IJc0ytvUzPU/bi44+8Iof?=
 =?us-ascii?Q?jWmkCRbBQdSe4zuGnHmAVu3Vjry49NO72+toyP3Jgxx9Rl8Xn3cOvznSAsiJ?=
 =?us-ascii?Q?ZcbDCUz7qT3UD0RU97n9qv2hXPIQeBWFdavm/qozxEoIqVPP8ISbp9lmFBXN?=
 =?us-ascii?Q?AyIEAUycw5rmi5XRAzpxjL+5dF8QbuMo6HV+PFA9NU6wJ/gB1k2NPRL5WICG?=
 =?us-ascii?Q?uqKKOdxI3PtdcBOzbI6iHakoX268bafnLG2BKiRwKVauZNCVfKRLGADNKv/7?=
 =?us-ascii?Q?6sVCtSpu0TuMZbuoXFbQr7e9KD05WTCNoD1FZeGmWeYsHyywnGqoQtpRkDln?=
 =?us-ascii?Q?EcpM85ZzFRRDNqVPrNMKDqVikJEnqDaqY4QodfeGAcm6MGp2UINI+rhHAV1P?=
 =?us-ascii?Q?DCmp7TUpiSe1egtNrSGXLhSRLXO6EUUH1FDZRjuyulQm70fhD55mqJYiByiR?=
 =?us-ascii?Q?X7SCYjPZHddbkMzr5UzMjjktnZaJ9mBBadOmVWF7ivazSfGLyGFI8ykQkW/4?=
 =?us-ascii?Q?FA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a97e1201-417f-4361-0487-08dde1ef471f
X-MS-Exchange-CrossTenant-AuthSource: SJ5PPF0D43D62C4.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2025 02:46:36.7765
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EIbE7Dn7bi3tqGYayzJ6gEZ1/mY/I/SUVkMqRK4pzYJRXrDIrxGakxFdrBVuIyKqwxZYiM64A6SBcumblmUxzWWUC9qzjLbIg0YwL5JdJJ0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7869
X-OriginatorOrg: intel.com

On Wed, Aug 13, 2025 at 06:02:39PM -0700, Marc Herbert wrote:
> Reviewing only the shell language part of this, not the CXL logic.

Thanks for the review. I applied most all of your suggestions in v3.
See below...

> 
> On 2025-08-04 01:14, alison.schofield@intel.com wrote:
> >  
> >  inject_poison_sysfs()
> >  {
> > -	memdev="$1"
> > +	dev="$1"
> >  	addr="$2"
> > +	expect_fail="$3"
> 
> You can make expect_fail and maybe others "local" instead of global
> (the default).

Done.

> 
>   
> > -	echo "$addr" > /sys/kernel/debug/cxl/"$memdev"/inject_poison
> > +	if [[ "$expect_fail" == "true" ]]; then
> 
> It looks like this script has full control over $expect_fail, never
> affected by any outside input. So you can trust it and simplify this to:
> 
>         local expect_fail=${3-:false}
> 
>         ...
> 
>         if "$expect_fail"; then
> 

I've switched to a bool comparison in v3. 


> 
> > +		if echo "$addr" > /sys/kernel/debug/cxl/"$dev"/inject_poison 2>/dev/null; then
> 
> Is it expected that this particular /sys may not exist in some test
> conditions? If not, then there's no reason to discard stderr.

No reason. I removed the direct.

> 
> stderr is generally just for "totally unexpected" issues and should
> almost never discarded. Especially not in test code where you really
> want to get all the information possible when something totally
> unexpected happens. Even more so when this happens in some distant CI
> system few people have direct access to for reproduction.
> 
> In the extremely rare cases where stderr should be discarded, there
> needs to be comment with a convincing rationale for it.
> 
> 
> > +			echo "Expected inject_poison to fail for $addr"
> > +			err "$LINENO"
> > +		fi
> > +	else
> > +		echo "$addr" > /sys/kernel/debug/cxl/"$dev"/inject_poison
> > +	fi
> >  }
> >  
> >  clear_poison_sysfs()
> >  {
> 
> Same as above. In fact there seems to be only word difference between
> these two functions, which begs for something like this:
> 
> inject_poison_sysfs()
> {
>    _do_poison_sysfs 'inject' "$@"
> }
> 
> clear_poison_sysfs()
> {
>    _do_poison_sysfs 'clear' "$@"
> }

Dedup'd that in v3.

> 
> 
> 
> > -	memdev="$1"
> > +	dev="$1"
> >  	addr="$2"
> > +	expect_fail="$3"
> >  
> > -	echo "$addr" > /sys/kernel/debug/cxl/"$memdev"/clear_poison
> > +	if [[ "$expect_fail" == "true" ]]; then
> > +		if echo "$addr" > /sys/kernel/debug/cxl/"$dev"/clear_poison 2>/dev/null; then
> > +			echo "Expected clear_poison to fail for $addr"
> > +			err "$LINENO"
> > +		fi
> > +	else
> > +		echo "$addr" > /sys/kernel/debug/cxl/"$dev"/clear_poison
> > +	fi
> > +}
> > +
> > +check_trace_entry()
> > +{
> > +	expected_region="$1"
> > +	expected_hpa="$2"
> > +	trace_line=$(grep "cxl_poison" /sys/kernel/tracing/trace | tail -n 1)
> 
> Probably "local" (but don't forget SC2155)
> 
Added local's to above params. Shellcheck has been happy. No new
complaints.


> Nit: you can save one process and one pipe with awk:
> 
>     local trace_line; trace_line=$( awk '/cxl_poison' { L=$0 } END { print L }' /sys/kernel/tracing/trace )

I'm going to stick with the readability (and maintainability) of this:
trace_line=$(grep "cxl_poison" /sys/kernel/tracing/trace | tail -n 1)

over this:
trace_line=$( awk '/cxl_poison' { L=$0 } END { print L }' /sys/kernel/tracing/trace )


> 
> > +	if [[ -z "$trace_line" ]]; then
> > +		echo "No cxl_poison trace event found"
> > +		err "$LINENO"
> > +	fi
> > +
> > +	trace_region=$(echo "$trace_line" | grep -o 'region=[^ ]*' | cut -d= -f2)
> 
> I think sed is more typical for this sort of stuff but whatever works.
> 

Point taken. The grep|cut version is working well and is quite readable,
so I'll leave it as-is.

> 
> > -# Turn tracing on. Note that 'cxl list --media-errors' toggles the tracing.
> > -# Turning it on here allows the test user to also view inject and clear
> > -# trace events.
> > +test_poison_by_region_offset()
> > +{
> > +	base=$(cat /sys/bus/cxl/devices/"$region"/resource)
> > +	gran=$(cat /sys/bus/cxl/devices/"$region"/interleave_granularity)
> 
> local if that makes sense.

Done.


> 
