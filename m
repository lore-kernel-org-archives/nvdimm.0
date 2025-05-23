Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 260571419A9
	for <nvdimm@lists.linux.dev>; Fri, 23 May 2025 03:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747972715; cv=fail; b=eMr5k6vxWjm+141ZZhJn3yL1A4B0cyKvxy7XySrPJiLoKql11lJIVByKeAHPCWOMaVQo5tLeu4MLVuB4A7Ca5xpQLYe0gxyyfaXdU8ZgNugomFrwucqRRD9bvS0xfi+1Gi4lVu0jnYcozDjPDJi54mGWEv874PIT4Iq2NjPLm7U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747972715; c=relaxed/simple;
	bh=JPrzGQPffXLJby2tzSSCs29zkx4ZfVtoUnQ26j6Rk4k=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=HV1Z/aKSR+T3xm7SDER9Vc95HkG9yr6Cczmm5QDkib6swXIEd4ys+mrpbTK8sWc0hxGNhzkHQnrk9lkct0eDbozYMVsEvkio3UKcD7QwxoPYNS93fcGipvhhZAHtdsN0U+096nEESx7RT5nPFcWPrvGGfCJQaM4AUISUnw+0OcI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RVlph8gj; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RVlph8gj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747972714; x=1779508714;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=JPrzGQPffXLJby2tzSSCs29zkx4ZfVtoUnQ26j6Rk4k=;
  b=RVlph8gjdiIrm1mBFGg6DpqrNme1Hv7gdRVwq06pntp0iRi4yi1rubSe
   4urAC/rd3GiN0qpUx/SUAJrpp+Q1pdmpWOCwY23HMC3n3vl4Aae2zorzM
   SipKqThP9vJHImEZO7nPBlRblFOgqDf2EvnTo6G+LOFV9aJ+5DpDmNSFq
   YQKFHZLwz5/fgjiCEDmniuKm8uPy3aff9vJ+IV1R8fuVx2EwH4wzM4ag9
   kINV9q6Askg7cHp0W6GOG+6Di3aMsjfPOC2H7x1aC2UpUuldQMwf8EWGF
   tecqr5lLSh4OS78lBVpkBbZpA9XTSKsLwbDfps0fnjlm0zOBkawuHbFQW
   A==;
X-CSE-ConnectionGUID: 3ftpIWouQpCIFKejNPlsjg==
X-CSE-MsgGUID: zhraCKScSQqT2Lz9wTtmPg==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="50184212"
X-IronPort-AV: E=Sophos;i="6.15,307,1739865600"; 
   d="scan'208";a="50184212"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 20:58:34 -0700
X-CSE-ConnectionGUID: pn/ol+fESEaGC3Yjc7pJsg==
X-CSE-MsgGUID: nPIY+/uqSwicl+uWZXGcIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,307,1739865600"; 
   d="scan'208";a="178073078"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 20:58:34 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 22 May 2025 20:58:33 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 22 May 2025 20:58:33 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.76)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Thu, 22 May 2025 20:58:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k6YcP33nRqJ6sqzV2gCbnZaR9oeJujgDUIpuzW0B2YItloNP+9prq6Ga5HznK/kw+BWxiDTCsfCJsyncSIJLe8+Th/h2IFrns0UgxDKad9AS3oNdjnMD829wVNZcEzpUxcWOuzlWP79Inrukvx02sgaiE1dwhY9yaeg7EnxhlqiINE7cTrZjDGA6Q0ovJorkd+KKIUPkmWZJV7/SGB4MrXbR4Z4zZoxQi7rSgUrjLR2C8dQsonFGbXlKcCIKIPP8i3L6UmRZTdupS2aG6nPXmb50HSZ9FiMl4mMbH9hBxHz+u4DbJ+s+CbiOKfu+2vZDTfpQhfmaQy+ApNF7k5j9lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VFcpPbsi5Q8F9sHKXGEuf6ZhlG5Ehy6k6RJofuTAUD8=;
 b=lqVoOUS+IxICPZr94qGHhL9XQoFs4HBgSSkQg0Wl7KKzHjNrdi6xyETxHy6sTuVN+SekbJsUADSEEcglPFkq4Ptx/okjJh7P1pVMG4sfC1V/KThpbTmKozXTLKl+sgMtfO3WnetFatZ1FaZ3U0WwQRxvrVIegEK9NrsQZdhA4VeSnUKFLxBMFrSKKM2WfUL2nLz1Ed7fKfrXBfFxK8oNL/3ttrbDb2cejJjBVQWT/MQg2VsxZiIao7wOMZ1OrdxJuzZue2hYFDuIChum5jMWgh1ggyFyA9IqEXusCOyyTPO97bXGtFzbylKVdSmRTlSMeM5k0EtuGiveY0S1s0PFqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by CY8PR11MB7034.namprd11.prod.outlook.com (2603:10b6:930:52::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.25; Fri, 23 May
 2025 03:57:50 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%4]) with mapi id 15.20.8769.019; Fri, 23 May 2025
 03:57:50 +0000
Date: Thu, 22 May 2025 20:57:49 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: <alison.schofield@intel.com>, <nvdimm@lists.linux.dev>
CC: Alison Schofield <alison.schofield@intel.com>, <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH] cxl/test: skip, don't fail, when kernel tracing is
 not enabled
Message-ID: <682ff23d8ff_1626e100e6@dwillia2-xfh.jf.intel.com.notmuch>
References: <20250523031518.1781309-1-alison.schofield@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250523031518.1781309-1-alison.schofield@intel.com>
X-ClientProxiedBy: BYAPR11CA0056.namprd11.prod.outlook.com
 (2603:10b6:a03:80::33) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|CY8PR11MB7034:EE_
X-MS-Office365-Filtering-Correlation-Id: 17470a22-e7c6-4599-6b85-08dd99adfcd7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?x6ZYmJS7aSoX/d0/6bQj600WHdxP7tjhnv2ZL9YrNO4B9a+tRJ6ub6WW892D?=
 =?us-ascii?Q?zoFmyAf6QlxS3bOdimXprG1YEelTyh9FJdHzEifICfeNTAcjOC5PGfhW3v+n?=
 =?us-ascii?Q?p/5Z7uCggB4xuxDcHoOsWAY7ZXKaa6gtDmiTc6Kq2DqclNstAJx3a+4MyCPE?=
 =?us-ascii?Q?lmr9+Zp9JFhUsAcVYWUI9DHREmfLfLwYdg7KBgIXdThfJ1RL9Fwy0FsyNqZP?=
 =?us-ascii?Q?JAtL9f9NOEfq/nKDkTxHkZ/YQA3phfjOL7pEWlLMxnRQAyLFJz0gzZHQruqu?=
 =?us-ascii?Q?0S4bG9zOdszKnUpJiyOohi6iFynDoiNzEkyY+Pv9aRq8Jsz3SCucVvq0ZbhZ?=
 =?us-ascii?Q?AELJwZOiqu4K5pK//Nhhd/WfiyTphMs6ghG1S7gLZGCUet5D9z9JIjdgLr3K?=
 =?us-ascii?Q?41cZacz0UPj6j+D4RLW7qegq50Pryzv5Jww7MH2c2jyeB88Z7gx6RYVpEvPc?=
 =?us-ascii?Q?qfGkVL2mq397QYUtrhgSbHfT7hBroxpr93RSuWHrVuzzEUBFbDG2D3a4GyUP?=
 =?us-ascii?Q?5D6Mb8gqnu6h+nRV4i/B1z0V/Msvq2RoEQqKfA954l8ONlIwm5/vpydh1GNk?=
 =?us-ascii?Q?JFkaAk9wJ6YI3Y0/DyBT/m7n8HvB6S86njXYcbjmYiC7IKsIB/4EsFyvtyEg?=
 =?us-ascii?Q?BVVPVAtQqDWUseu1htnhSnTfpLQ6THh3lgLx1sBJVY+ofOhVqxAh7T983i+s?=
 =?us-ascii?Q?QXHJaXMGSacCl9AG/wgeISwZFM5tX9jPSDWCCmhOY2b7pG1xy8Tfvf7gdZaP?=
 =?us-ascii?Q?jsDrtGr9U4qTqIYryyoKEV7TRLI1vsIFuS2lvVlVZZnmmVn9yv/nZE7TVMb/?=
 =?us-ascii?Q?lb8D3jKzL908ob3w7UQKbbTt9SSUNESFxY8PPNyJpDUNeD0m8xs9YYNRPSqi?=
 =?us-ascii?Q?VblC4wR7/0RZ3R96bN/0rVXbodJCSr3tI/pHvyvSgF18mEpWwqddxLm0dYr6?=
 =?us-ascii?Q?y0LHs1RvxJeysnph9Weq8sM9dTD3hadSrafJHxGKkVODI8Gt3oPz21pYhwCO?=
 =?us-ascii?Q?1yH6JFIwDmwKRqoUJz6qJ/RHmhWZ8f/C1LCVY+9pSYg+R9Uo3FOWt61Siz4v?=
 =?us-ascii?Q?kaXfgrP9DqH+HNkpIPGcF3NK2PxjE9ooOaCpZbTbmzt5MXfz6/4Ot5ZzLqPR?=
 =?us-ascii?Q?DbE9Ja9jmp9Ff9DOLCE3KjGj6BoPeSkeoGegdiBGbUsx6rTrpcRlDggmlH92?=
 =?us-ascii?Q?jgS4dMgaZQGAIY7fZ8Am5xn8OMxXni/b6PQ88NwFGrZVWVSln//Biu1yuj0A?=
 =?us-ascii?Q?VpKIvwHNv3WmWYXmJLP6YqYAU0GmmosnLr5I1BlwYk7MB/2+kSbHl29vNhIK?=
 =?us-ascii?Q?lPuAPtl5OtNKCdr5KnH5K1Jerh0zpxHDP9dWgdvjsYtAngn819zH+L5BVJE9?=
 =?us-ascii?Q?qbPOwWeCA6KEhPZKcqdB0ukYFE3G?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KxBV522FsSVA7hrH3WfL6oHb7vb71glQZYC+ORqxC17S0oDpWfvFeJdvOtdp?=
 =?us-ascii?Q?ZQaYaKJPFrMstkute4xsNm1ainKOPUrL4ekMUvq3+01tW1RwFPfkJ7wXSotW?=
 =?us-ascii?Q?+L1Mia+lgGvSdurUQA/vMtfumqRgDfwlJHVmC2uMM6HRwkLnbLZSXGc0hkNU?=
 =?us-ascii?Q?ptaMhX2vuXOXynzxBNpT4mGrXMTT4s+7UL6iXN8rBB+etUnz8hVpqqflqDHl?=
 =?us-ascii?Q?zqa1Vu6EBBmYrRaWZ0xLs13jmUfBdA336iLgbmgqRvGRIrrdzarUwyVS8eBL?=
 =?us-ascii?Q?iygnR1ifV30UjNBysMF9gKhC3zLbVyPxN20xQS03K2yByZMu+haNi/1R1bh+?=
 =?us-ascii?Q?xYog2UenIHihJEb60aaDUVxcgf7/0e1LEhtsaf8dYioBwHWJAA61Df2v64RS?=
 =?us-ascii?Q?KYZprtQ6GZFgpdfjuHRBXizUOKeeUDR0Edq+ESDTv4ohQ36tTQcFfDkkkdAj?=
 =?us-ascii?Q?kw0lrDSnmBPa2Ksk9Yv7qHd9kSTgXeL6naraolYLKHO+yjW8q4C/cTmxA7o5?=
 =?us-ascii?Q?tK4GZl0twUWL01IN7Z3/4HNGIPlXuukvVOhbaLI0q0r5bpFtx+JAClHXPRKE?=
 =?us-ascii?Q?cg7SgEc9WnkXxho2+MpD4bbHgFbtu2THjivXVtMnIMjcnSUqElQE+3dsPwCm?=
 =?us-ascii?Q?B+9tgbclgMrXmQjYLOf/etar/OmIL5fhR9WksIyJyvsliWQvFLR3QBZX6ERQ?=
 =?us-ascii?Q?3GXhQnQaR8mS1bs16oUIEaN0dvDbsZK+Dmgem406UNnqXP/qXN8FsXS5SdvA?=
 =?us-ascii?Q?lVpRVqmHDods8ohVwNvtEObrE+S1VdazuKy54rI3sjKrwXp3+xJKdPIeAMQB?=
 =?us-ascii?Q?zcswhDo63wIoDwMYmBwedEqUk3FM919lA9aK2q3BxOE1CFYrNMPwKS2LceSJ?=
 =?us-ascii?Q?35gbU3GuNzo93u41PVsrliuSfUcGdCw/KKthsLaIikVu/hzHI2ffBuJtUWl3?=
 =?us-ascii?Q?/YevTedR9PDhvpd+sXvfgpKHPV3ly236qw/ZLNTT9uOxczctsPnhnBAhmCVV?=
 =?us-ascii?Q?AcuZQ6P+wTtat8HwwYFinPTR+3a7T79Fh8B/GiEAf9EuDzGqe60WuFET+i2G?=
 =?us-ascii?Q?K9xifO5ud9YifOZcv4QoizwQxr8gvXvaRXjt72647gemrqTG5P5mXWoGR4/v?=
 =?us-ascii?Q?tMXjvwygM0Qvh497gYnO1l2QbtHQJ8Fyf/fMDPRn3dF5B7c4eY1SjsFmziRb?=
 =?us-ascii?Q?F3kzj0Exca2m8149bduGm06cugL1V6LN9bFScFGArBYJ9/9Ex6///kwXSuto?=
 =?us-ascii?Q?mQHMxMkxnAQCBjLNu6Bi+VkNigDarV2A0DvHfwfoJDn7l5SbiWKfWEjWaXMW?=
 =?us-ascii?Q?bFay+lwKScK6i8AbVNkn/VVGCriHwkOXZxvQer6wcKG5Om41l3N/NGGTuG1C?=
 =?us-ascii?Q?BV1TbxQ8Xhg89+b9eRyre9+RCfQlLNYGZOpP8Sg26gRH0ZZijgjdJVvLdTA5?=
 =?us-ascii?Q?FjINFDsRY7Zpm+b5Pysypx3Ae9FEkd4/8LohydoIRYbIkMR2dksQ4xdNTzbe?=
 =?us-ascii?Q?VgcDrSBfSAU30BgOBZgMMs/g12MFCskaBd3AWAvpjB5KF3QeNAabEJmVxnk5?=
 =?us-ascii?Q?/acEASTF4+IuQrhubdgQKwEdSY43rOplTyIcXiiSiFlHceLI93SgsGx6qT2Z?=
 =?us-ascii?Q?cw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 17470a22-e7c6-4599-6b85-08dd99adfcd7
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2025 03:57:50.8057
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mHIkDGhIXQAAAFUzwd5EApX2XweZqrq6geBp0Y5EuhHXkhqweNpEZuzqaGIlL+DfS2D5u1EceH3nWtrsWkKTzifBTHuR6vJva3s4NgJsvLw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7034
X-OriginatorOrg: intel.com

alison.schofield@ wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> cxl-events.sh and cxl-poison.sh require a kernel with CONFIG_TRACING
> enabled and currently report a FAIL when /sys/kernel/tracing is
> missing. Update these tests to report a SKIP along with a message
> stating the requirement. This allows the tests to run cleanly on
> systems without TRACING enabled and gives users the info needed to
> enable TRACING for testing.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---
> 
> Noticed this behavior in Itaru's test results:
> https://lore.kernel.org/linux-cxl/FD4183E1-162E-4790-B865-E50F20249A74@linux.dev/

You could borrow the kernel process for information like this and move
it above the --- line with the following trailers:

Reported-by: Itaru Kitayama <itaru.kitayama@linux.dev>
Closes: http://lore.kernel.org/FD4183E1-162E-4790-B865-E50F20249A74@linux.dev

...you can also add:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
