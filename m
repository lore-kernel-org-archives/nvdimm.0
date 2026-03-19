Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1C8E1E9919
	for <nvdimm@lists.linux.dev>; Thu, 19 Mar 2026 05:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773899326; cv=fail; b=BVIpcrghixnod0Lfe7em/ch3bmKXXJHOogW14/s95o9hm7+gW5Jf+8TuBmPs8JwWf1Ia3L/tKU/FWu8vvQZ7XVCVmjrfS8PQnyTzhrmbWBbUbTJvr6/frqNWyheYQ1BZlU3MMorBFOqrF2iwpVIoJJEnWSrNXfJHktok7C//NMg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773899326; c=relaxed/simple;
	bh=ZR3PMmcgu/a4jsSxnIHtSgQ49Dy8DLTTQvJvqIIjoGA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=JjWcw+VqhoyV0K+Mkvrjpoo9y+nBoOzYEVyAMD592iK+bJVSkLzu/3vE5ReJ7FNgxxos2W+MyOLVjmMaPUSNqnSNTdmRTIwkwfIvhAtK90CUHIOYH0sbv4yNaohHkaw8jp0cPn5kPetYb1ToM2qPFclsK0zT+wW4LFLq+nXYRoQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O78/2Sp6; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O78/2Sp6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773899324; x=1805435324;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ZR3PMmcgu/a4jsSxnIHtSgQ49Dy8DLTTQvJvqIIjoGA=;
  b=O78/2Sp64cnS9BHgTrXIEbRxvk6MG1iqBvxg4W1X7baRMufptXRbySbL
   IuJSuTPw2LmDIwy5JOZ1Pe7vAnXO7cedbRmG87UYfbkMyYrUQq7N4AeXc
   cxdl7lUiYP2Oe1EURU/j78aZMnLcmQLJY5syrs//kcw3e1+xaEUL7Sr8A
   TrDnJuNIyci8Z2p/SpmasgqbXmVrFmsopFFzEOQXU6lG2/s+CB0Oald94
   yea/qpng7ZtINtMJr7y8t8gtX8oWPfuwuGiL59SaCuzAZblgD/dgiNj1n
   O4EpoacAYiHtOqqmSipVY9MYRMGlIjAgGC8iNhrMNIwmUyPy3RQNkcHT1
   w==;
X-CSE-ConnectionGUID: FpsWInKHTDKw7419H0trDg==
X-CSE-MsgGUID: 7ivZpfyhSruLxePKOrtGcQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11733"; a="78570121"
X-IronPort-AV: E=Sophos;i="6.23,128,1770624000"; 
   d="scan'208";a="78570121"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2026 22:48:43 -0700
X-CSE-ConnectionGUID: f4J5xyhgQ5azywAAoM96Yw==
X-CSE-MsgGUID: VLIH35/6SBuV7/YRZ9Jlog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,128,1770624000"; 
   d="scan'208";a="220268144"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2026 22:48:42 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 18 Mar 2026 22:48:40 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 18 Mar 2026 22:48:40 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.50) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 18 Mar 2026 22:48:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A/7m/ehmhJXgv5/CIA5yu8iWpKBk9mq6Dqzx8HvBNpmM3kIrZw30HHoQMCS5JAYsxjJh/sF/H45XFbiazXTNn29hBSsUTOqmF607vEIvriyI65EK0O85Tk+mwTPIsgu1+3kH2D6F8OpG6sa+bGM6Ea/XByZVu6ymnr5QYxENFZ7KcLJm14TY/b65rkAzaHpKTIYFrXC+vzHYa0es49LBF6pt2msbOYZH/1HK8omWTLFcP7jc9x1Jn34A9EJxUcm4teOvO45+8LwkYVdsz855EuiFjEKC8MHAUSfktHtHcTPNFlv5v/5eXau/4IVF4uBZv/9ALfOHO4xlqcSc0EdUCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FK2asDD388lRO/apC5ywtdO8y2I0cGZ9g3BTD0oa3+Q=;
 b=cXEf1jvM96LkE1TV+6ihphZ8wXwmU82ULVujDe8P6mpl0QLf/o0OvM3yRaAJ/qkuJH+Md7WCGxFZVifh5LVDdwp1jtWHJyM5ugD5jFg2xVX2K29Hwpn+nIrLEOztb3NIHwqGmiW/bcXVwFZvJ3wHQBoYgYBTciRJ57Yx4oyyobf3Emc8M3RNh2++DRBKUjXZDfhcZ0ya5kXWQQDbn4ZUWcqfgvwfsHzJI/obyZ4k+nDRVcIHO+T5rg1vklzdJkwJX8GsmEmh6LG082phQ/7e9y7qtENunzoT/EBY/1Bgfhqob7GN/TgnvSFpHThHBmexq12HcsAWeTelDzr7tNVQuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by LV3PR11MB8556.namprd11.prod.outlook.com (2603:10b6:408:1b4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.16; Thu, 19 Mar
 2026 05:48:36 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::3979:c00f:fdca:b895]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::3979:c00f:fdca:b895%4]) with mapi id 15.20.9723.018; Thu, 19 Mar 2026
 05:48:35 +0000
Date: Wed, 18 Mar 2026 22:48:30 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
CC: <linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-fsdevel@vger.kernel.org>,
	<linux-pm@vger.kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Vishal Verma
	<vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>, Dan Williams
	<dan.j.williams@intel.com>, Jonathan Cameron <jonathan.cameron@huawei.com>,
	Yazen Ghannam <yazen.ghannam@amd.com>, Dave Jiang <dave.jiang@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>, Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, "Rafael J . Wysocki" <rafael@kernel.org>, Len Brown
	<len.brown@intel.com>, Pavel Machek <pavel@kernel.org>, Li Ming
	<ming.li@zohomail.com>, Jeff Johnson <jeff.johnson@oss.qualcomm.com>, "Ying
 Huang" <huang.ying.caritas@gmail.com>, Yao Xingtao <yaoxt.fnst@fujitsu.com>,
	Peter Zijlstra <peterz@infradead.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Nathan Fontenot <nathan.fontenot@amd.com>,
	Terry Bowman <terry.bowman@amd.com>, Robert Richter <rrichter@amd.com>,
	Benjamin Cheatham <benjamin.cheatham@amd.com>, Zhijian Li
	<lizhijian@fujitsu.com>, Borislav Petkov <bp@alien8.de>, Tomasz Wolski
	<tomasz.wolski@fujitsu.com>
Subject: Re: [PATCH v7 3/7] dax/cxl, hmem: Initialize hmem early and defer
 dax_cxl binding
Message-ID: <abuOLq6bMPa0nNAL@aschofie-mobl2.lan>
References: <20260319011500.241426-1-Smita.KoralahalliChannabasappa@amd.com>
 <20260319011500.241426-4-Smita.KoralahalliChannabasappa@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260319011500.241426-4-Smita.KoralahalliChannabasappa@amd.com>
X-ClientProxiedBy: SJ0PR05CA0009.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::14) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|LV3PR11MB8556:EE_
X-MS-Office365-Filtering-Correlation-Id: 52e1a248-3237-4fe2-6b15-08de857b2950
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info: 2YBkYw/HrTBkEaLIvf33mEu9dU9Tufz0k+/dXGN73AApmgI3dv19U4Zimyxoz/uOhV8Kx2sxPQNjfy1R0zdqu5lubQWKHTPEBwDaeJ6pw4DMB4Ksv5/tolvuBi/VGQI0hP5khbNFUoDPzTDxgwSKn40IjqUCIJW5mtQzl0qYqUzRFI8PLjaVcR6tuqQw9TgJZrdL93ztHv4c8XrWnWrwPk/Adi+/mVu5egWGXvuP1eH+jCef7ldh+zbDEUwKy4SdJlpgeAVgbgGUqUKja4yFBxMCWoAU9YL4r6Uoxii8w2twNNCq5ralt1U6OpFmyrjFgwbw3F25qYeg4NioHqK5ZdIQARBzQ46+l36tg/jyiXXSs2kNvDhLZJ5ATQhPFEu3I1oeVyU+5Qg28+W0PY5CG5yafKFisEkjEAK5l6bAIBNtvvGf/QqTCHEbsruCA7vbv4dPWcNnzNWjpe3IdM8QOPpQK/yReqLfztMzKnEW54nhXfP/dGuXVdcu8AOhNRr5IDh7Q6bDcrroENVj54w/69GTvwxC0XiaBxwoYNzCtUZvWIytniTOXwmCNeDCGxomQcwNLRPUL+fWBUm3xG8xAGSMyy9BlTHMC0nDsTJHVOT/gvVtEwG7QxHL8dzZfKSfkPpShaUhOEcDpcUY9BiDyRad5RNgoDpbYstH9wUO0zxmOXXX1LQURwLh6WECwUGiRO38qt5wMYO39Q7fwT+pS55yCum7djtL79HmeYr7DTQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mPfIG2UEHWUMeXbzoM02xfcBbA6mbps1CDqtNO8gr1KLKkFxrFpatEYI/QOz?=
 =?us-ascii?Q?9vilERONz9AKibz+Gvf6uMN9yJu9h+Ly8/cQiPegF4qObxzVSQiNkeMTT84L?=
 =?us-ascii?Q?gAsFxYd39x8wlaR/mUR0ib6ADO+ogRZ/zar1qkYyiVZHtz2KbAah20VufsRg?=
 =?us-ascii?Q?P5NR0wKCFwUCwvXETOfx55RKQY4Sgx3K80RHsW+zdlthIGjSgr7vgtszZuqH?=
 =?us-ascii?Q?IrKvXQbn8REZQ8puPXWQmLA75H14rUQV29ePfq2AWyrMZNQcrVx/U35s1q3c?=
 =?us-ascii?Q?i2Q+GFPXo8ovysaVhl/zWB2kOZ/PuV1jOZ9bIcc01wXaEosB4/KmC4HnSxw4?=
 =?us-ascii?Q?xGssnhIUF3x7zRxoZ4++WCtEhNjtDcccJ2JKrlyCtF0X8dDp+fcJR2NfOJpy?=
 =?us-ascii?Q?OgBnVBa52g2Z0XPajbX0AvucSmEmJV/ipNXIKzVDV961uOT7n76hFLOG2LJU?=
 =?us-ascii?Q?QFlzrYJwcNdrT/WkxR7tL0S590K/SS7mMOELwnWGbSX7VpkL+QEoFwSyM3V+?=
 =?us-ascii?Q?Au5w7M20zwLYXROtDnPhDzC63PuPZztzLGHTUOZeEm4rWRMNDaW2cvyLbJto?=
 =?us-ascii?Q?dw55j/fwmE3itzC4Y1kcni7He69OHdDlR46QSDXfExxJjfL6mJ6SQaJWn2Ew?=
 =?us-ascii?Q?7CtxM4Bp26fm8FvBAaCpCwqpA4Rmz5GlOpj0BfG5y5IKwg084FaS5MyvBfvj?=
 =?us-ascii?Q?FQhzlZciBQ6i15Au15Gh7JgifFKpK2ZreZw+yLH2iwCBaEgKQ0YQk5Hhc1p2?=
 =?us-ascii?Q?Zvfz4342b1c/QIRoMM5M2v8DiGDoIhlsgH8yiHe3MqiVglirH2RAcOm1SUcd?=
 =?us-ascii?Q?f7NiFSUuXtiBWLaGm0xm9MuWEbv7jniRj2TaPICkuVPz99myVW4Gk/sQCkoA?=
 =?us-ascii?Q?GnJVKpdJlWM22FjsLKIPEgMfVhht/34+sikcxwG0BDU/EFubPzBK42zSmY/U?=
 =?us-ascii?Q?lMBc/M/977tfpMJRECduLDh8raspLVURQCM4rjjSl76/i1sNe+gqMX5xfa7v?=
 =?us-ascii?Q?lFTH1Q4Ys4ZMOgGhD+suRkntmto/EFlfUaOq9yVYGL+BwkMwNfI/TPWdwa5T?=
 =?us-ascii?Q?id891d2L9Ty3UtWht9nIHlPajZrlMsSzdfLJe1T6ljBdk8iXGMUcnpxWfmbq?=
 =?us-ascii?Q?ziieQSb9sF9GAccdSfTL/U3jRWJdqI98CC5fmJm4xLMRtijytx2ad7OXJw9t?=
 =?us-ascii?Q?VyPbvBStNIaTD2jAazIEO1Uv+ifCGQEGK43+QfZ72Wv8Md6F6PND5GKESO/j?=
 =?us-ascii?Q?aQGxZqCl49GnDp7SULmfE167XJm0aSXIeC3dR7DF9x0UqI9H/bpq1uYes1c4?=
 =?us-ascii?Q?jY8DIkE+Nxww2HExLUJ3GP637T37QPibyLKaFAywqKEALs9WoP5EcHDN+Jse?=
 =?us-ascii?Q?NmszfhqfxnmDl/Dq0ctK6fdvyxnk/hudLKNQOlMPDss+outUCNMMGQjO6POd?=
 =?us-ascii?Q?ubp9IMq2vQLLhU/GKt5j/pOAx3K2I0OvTeh86W176ZZEQutHsv5yOWijYLKv?=
 =?us-ascii?Q?D9xY8AvGlNMW4wWV+XmhrRs7k9W7RK0LDb0wYn3OpwetzK4qE27zCEVXMYxV?=
 =?us-ascii?Q?8qRbNM1/ImQQudewJDidmD10zp/RNT+z70xgO0FDDF0Us9844Td08Neris5x?=
 =?us-ascii?Q?r3yDGRGYCdQyv9jsDM9yAYQSunxgkq4KIyOMFqHC4VkMNV923aB6z9dbuoQq?=
 =?us-ascii?Q?3I0NH4JdqoJ5qWsYe6O0RaweQEiYJGBq2gXCDTIfhEVFA/yiiMMa633uYhi0?=
 =?us-ascii?Q?uKlXx7PpMOatE6n2dZfRDFwm1qLZcoY=3D?=
X-Exchange-RoutingPolicyChecked: frSWVFF+66vmXH2pgL1dBybjHK4Sf3v6AIK/mbhJMmZXIpsJ1qKDGPgsGrP9bIYtLqLN/+ew78csaJL8Vd3/F+aPJDbDOkULKnc8zaA8QqCZlpZsFsECZiNANBs4rcpka/Lvi0EuZ+0b/38z7jmXJGJ2ih0N+c4cNOKeOpnSpv56eN5jTyFB1wwBJuIggSKs2vcnPzbm7PWILnR4QQrZDM6luTTYZRBHHJRf2eKsO/4naDP7fxRPSHcDT4IhJtKkVHHmhGOgKKtdCOsCMbpnwNuZPZ6BUe5QCoHB5EFh0WjRlM+jGu0u/atBPZ844IfDMpA5DvWoA5RmrTxOPZkkCg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 52e1a248-3237-4fe2-6b15-08de857b2950
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 05:48:35.7789
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zuS5cyy+Y/UbtmszjKvkXROh8Si9tlu1LuEGxZmnXSyOc67Nb/9jCPdDyFaZ4yPrXMxF6Ic609/H/P6FVV61Y5loF8WHz6bZLjAwbSW78H8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8556
X-OriginatorOrg: intel.com

On Thu, Mar 19, 2026 at 01:14:56AM +0000, Smita Koralahalli wrote:
> From: Dan Williams <dan.j.williams@intel.com>
> 
> Move hmem/ earlier in the dax Makefile so that hmem_init() runs before
> dax_cxl.
> 
> In addition, defer registration of the dax_cxl driver to a workqueue
> instead of using module_cxl_driver(). This ensures that dax_hmem has
> an opportunity to initialize and register its deferred callback and make
> ownership decisions before dax_cxl begins probing and claiming Soft
> Reserved ranges.
> 
> Mark the dax_cxl driver as PROBE_PREFER_ASYNCHRONOUS so its probe runs
> out of line from other synchronous probing avoiding ordering
> dependencies while coordinating ownership decisions with dax_hmem.

Hi Smita,

Replying to this patch, as it's my best guess as to why I may be
seeing this WARN when I modprobe cxl-test.

We are able to pass all the CXL unit tests because it is only that
first load that causes the WARN. All subsequent reloads of cxl-test
do not unload dax_cxl and dax_hmem so they chug happily along.

I can reproduce by unloading each piece before reloading cxl-test
# modprobe -r cxl-test
# modprobe -r dax_cxl
# modprobe -r dax_hmem
# modprobe cxl-test
and the WARN repeats.

Guessing you may recognize what is going on. Let me know if I can
try anything else out.


# dmesg (trimmed to just the init calls)
[   34.229033] calling  fwctl_init+0x0/0xff0 [fwctl] @ 1057
[   34.230616] initcall fwctl_init+0x0/0xff0 [fwctl] returned 0 after 186 usecs
[   34.257096] calling  cxl_core_init+0x0/0x100 [cxl_core] @ 1057
[   34.258395] initcall cxl_core_init+0x0/0x100 [cxl_core] returned 0 after 538 usecs
[   34.264170] calling  cxl_port_init+0x0/0xff0 [cxl_port] @ 1057
[   34.264982] initcall cxl_port_init+0x0/0xff0 [cxl_port] returned 0 after 110 usecs
[   34.268058] calling  cxl_mem_driver_init+0x0/0xff0 [cxl_mem] @ 1057
[   34.268743] initcall cxl_mem_driver_init+0x0/0xff0 [cxl_mem] returned 0 after 110 usecs
[   34.274670] calling  cxl_pmem_init+0x0/0xff0 [cxl_pmem] @ 1057
[   34.277835] initcall cxl_pmem_init+0x0/0xff0 [cxl_pmem] returned 0 after 1671 usecs
[   34.285807] calling  cxl_acpi_init+0x0/0xff0 [cxl_acpi] @ 1057
[   34.287105] initcall cxl_acpi_init+0x0/0xff0 [cxl_acpi] returned 0 after 262 usecs
[   34.292967] calling  cxl_test_init+0x0/0xff0 [cxl_test] @ 1057
[   34.339841] initcall cxl_test_init+0x0/0xff0 [cxl_test] returned 0 after 45832 usecs
[   34.342259] calling  cxl_mock_mem_driver_init+0x0/0xff0 [cxl_mock_mem] @ 1063
[   34.343459] initcall cxl_mock_mem_driver_init+0x0/0xff0 [cxl_mock_mem] returned 0 after 356 usecs
[   34.658602] calling  dax_hmem_init+0x0/0xff0 [dax_hmem] @ 1059
[   34.670106] calling  cxl_pci_driver_init+0x0/0xff0 [cxl_pci] @ 1100
[   34.671023] initcall cxl_pci_driver_init+0x0/0xff0 [cxl_pci] returned 0 after 197 usecs
[   34.673051] initcall dax_hmem_init+0x0/0xff0 [dax_hmem] returned 0 after 2225 usecs
[   34.676011] calling  cxl_dax_region_init+0x0/0xff0 [dax_cxl] @ 1059
[   34.676856] ------------[ cut here ]------------
[   34.677533] WARNING: kernel/workqueue.c:4289 at __flush_work+0x4f9/0x550, CPU#3: kworker/3:2/136
[   34.678596] Modules linked in: dax_cxl(+) cxl_pci dax_hmem cxl_mock_mem(O) cxl_test(O) cxl_acpi(O) cxl_pmem(O) cxl_mem(O) cxl_port(O) cxl_mock(O) cxl_core(O) fwctl nd_pmem nd_btt dax_pmem nfit nd_e820 libnvdimm
[   34.680632] initcall cxl_dax_region_init+0x0/0xff0 [dax_cxl] returned 0 after 3842 usecs
[   34.680918] CPU: 3 UID: 0 PID: 136 Comm: kworker/3:2 Tainted: G           O        7.0.0-rc4+ #156 PREEMPT(full) 
[   34.684368] Tainted: [O]=OOT_MODULE
[   34.684993] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
[   34.686098] Workqueue: events_long cxl_dax_region_driver_register [dax_cxl]
[   34.687108] RIP: 0010:__flush_work+0x4f9/0x550

That addr is this line in flush_work()
        if (WARN_ON(!work->func))
                return false;


[   34.687811] Code: ff 49 8b 45 00 49 8b 55 08 89 c7 48 c1 e8 04 83 e7 08 83 e0 0f 83 cf 02 49 0f ba 6d 00 03 e9 a1 fc ff ff 0f 0b e9 e6 fe ff ff <0f> 0b e9 df fe ff ff e8 9b 48 15 01 85 c0 0f 84 26 ff ff ff 80 3d
[   34.690107] RSP: 0018:ffffc900020b7cf8 EFLAGS: 00010246
[   34.690673] RAX: 0000000000000000 RBX: ffffffffa0ea2088 RCX: ffff8880088b2b78
[   34.691388] RDX: 00000000834fb194 RSI: 0000000000000000 RDI: ffffffffa0ea2088
[   34.692135] RBP: ffffc900020b7de0 R08: 0000000031ab93b0 R09: 00000000effb42e8
[   34.692876] R10: 000000008effb42e R11: 0000000000000000 R12: ffff88807d9bb340
[   34.693588] R13: ffffffffa0ea2088 R14: ffffffffa0ed2020 R15: 0000000000000001
[   34.694358] FS:  0000000000000000(0000) GS:ffff8880fa45f000(0000) knlGS:0000000000000000
[   34.695179] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   34.695775] CR2: 00007fe888b4e34c CR3: 00000000090ed004 CR4: 0000000000370ef0
[   34.696494] Call Trace:
[   34.696889]  <TASK>
[   34.697238]  ? __lock_acquire+0xb08/0x2930
[   34.697730]  ? __this_cpu_preempt_check+0x13/0x20
[   34.698277]  flush_work+0x17/0x30
[   34.698705]  dax_hmem_flush_work+0x10/0x20 [dax_hmem]
[   34.699270]  cxl_dax_region_driver_register+0x9/0x30 [dax_cxl]
[   34.699943]  process_one_work+0x203/0x6c0
[   34.700452]  worker_thread+0x197/0x350
[   34.700942]  ? __pfx_worker_thread+0x10/0x10
[   34.701455]  kthread+0x108/0x140
[   34.701915]  ? __pfx_kthread+0x10/0x10
[   34.702396]  ret_from_fork+0x28a/0x310
[   34.702880]  ? __pfx_kthread+0x10/0x10
[   34.703363]  ret_from_fork_asm+0x1a/0x30
[   34.703872]  </TASK>
[   34.704227] irq event stamp: 11015
[   34.704656] hardirqs last  enabled at (11025): [<ffffffff813486de>] __up_console_sem+0x5e/0x80
[   34.705493] hardirqs last disabled at (11036): [<ffffffff813486c3>] __up_console_sem+0x43/0x80
[   34.706354] softirqs last  enabled at (10500): [<ffffffff812ab9f3>] __irq_exit_rcu+0xc3/0x120
[   34.707197] softirqs last disabled at (10495): [<ffffffff812ab9f3>] __irq_exit_rcu+0xc3/0x120
[   34.708015] ---[ end trace 0000000000000000 ]---
[   34.752127] calling  dax_init+0x0/0xff0 [device_dax] @ 1089
[   34.754006] initcall dax_init+0x0/0xff0 [device_dax] returned 0 after 422 usecs
[   34.759609] calling  dax_kmem_init+0x0/0xff0 [kmem] @ 1089
[   37.338377] initcall dax_kmem_init+0x0/0xff0 [kmem] returned 0 after 2577658 usecs


> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> ---
>  drivers/dax/Makefile |  3 +--
>  drivers/dax/cxl.c    | 27 ++++++++++++++++++++++++++-
>  2 files changed, 27 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/dax/Makefile b/drivers/dax/Makefile
> index 5ed5c39857c8..70e996bf1526 100644
> --- a/drivers/dax/Makefile
> +++ b/drivers/dax/Makefile
> @@ -1,4 +1,5 @@
>  # SPDX-License-Identifier: GPL-2.0
> +obj-y += hmem/
>  obj-$(CONFIG_DAX) += dax.o
>  obj-$(CONFIG_DEV_DAX) += device_dax.o
>  obj-$(CONFIG_DEV_DAX_KMEM) += kmem.o
> @@ -10,5 +11,3 @@ dax-y += bus.o
>  device_dax-y := device.o
>  dax_pmem-y := pmem.o
>  dax_cxl-y := cxl.o
> -
> -obj-y += hmem/
> diff --git a/drivers/dax/cxl.c b/drivers/dax/cxl.c
> index 13cd94d32ff7..a2136adfa186 100644
> --- a/drivers/dax/cxl.c
> +++ b/drivers/dax/cxl.c
> @@ -38,10 +38,35 @@ static struct cxl_driver cxl_dax_region_driver = {
>  	.id = CXL_DEVICE_DAX_REGION,
>  	.drv = {
>  		.suppress_bind_attrs = true,
> +		.probe_type = PROBE_PREFER_ASYNCHRONOUS,
>  	},
>  };
>  
> -module_cxl_driver(cxl_dax_region_driver);
> +static void cxl_dax_region_driver_register(struct work_struct *work)
> +{
> +	cxl_driver_register(&cxl_dax_region_driver);
> +}
> +
> +static DECLARE_WORK(cxl_dax_region_driver_work, cxl_dax_region_driver_register);
> +
> +static int __init cxl_dax_region_init(void)
> +{
> +	/*
> +	 * Need to resolve a race with dax_hmem wanting to drive regions
> +	 * instead of CXL
> +	 */
> +	queue_work(system_long_wq, &cxl_dax_region_driver_work);
> +	return 0;
> +}
> +module_init(cxl_dax_region_init);
> +
> +static void __exit cxl_dax_region_exit(void)
> +{
> +	flush_work(&cxl_dax_region_driver_work);
> +	cxl_driver_unregister(&cxl_dax_region_driver);
> +}
> +module_exit(cxl_dax_region_exit);
> +
>  MODULE_ALIAS_CXL(CXL_DEVICE_DAX_REGION);
>  MODULE_DESCRIPTION("CXL DAX: direct access to CXL regions");
>  MODULE_LICENSE("GPL");
> -- 
> 2.17.1
> 
> 
