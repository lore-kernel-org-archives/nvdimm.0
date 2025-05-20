Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB9F2820D3
	for <nvdimm@lists.linux.dev>; Tue, 20 May 2025 19:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747769131; cv=fail; b=umkovoV1ixdaC6wDaJAVhbSJRaGXKQWNwmx8SHQ3aMxc5rQ8dBHRYrRJkMrytp93PhPjCzbQXc14RO2rsaogZyDLglApH+F7PfNx0ydjjmlW02M63oG3YwoVYHn6VeLlJRZP5n7Xr//lmrVfjYiIK/GR25bpiYOfzYD+pBU86Xo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747769131; c=relaxed/simple;
	bh=0Ymr089UuuFA4g9dny884V+MFieb22sFDRpC7KhvthU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=SIyIn2Npxgtpvxcbhm4CcU08oRAfzEd9qCo+F5MWwpzH4z0agTw+zuPecFJM8HpYzBLuoT8YIPOuxJ5k0W97FqDckkFo1Ap9mz6ejqPid7oAcQR5tYZeyu8J99FkZ5ddtGG13HBfTkp7//sl1mUPr865E/rqrcPXjxTXW4FvaNs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k3zRo/JE; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k3zRo/JE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747769130; x=1779305130;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=0Ymr089UuuFA4g9dny884V+MFieb22sFDRpC7KhvthU=;
  b=k3zRo/JE6WG/yVTdJm1fvVM8Z0rjvjxg1snfpzAY3ibeXOfjfUr6BN0t
   dKo+1tVgAKFChZjxLllJccd1NbEXnbTvGuQfiXZspB77AZiirklkLC2VH
   pHZkihK5vg9Ri6b8buy5W6ZOA+/ilSCY1KRrusu3zt6P/y4P6yb1cn+ZK
   T1sJpifHr6cy+zzHyfUXhVJJzZiuMRPrQA4PAF0P8OpwyJaapBSagdNkI
   yXznR9FAkM33wVLBLOsED2Idwc7RNGVISvxDtb8ZHw+MZWV63hhlFoVic
   sCs9aprfVkucEJkj/PHo+uzZvyyg8bUhFZ7HHwA6sl+BKwJrdBBpvkwrI
   g==;
X-CSE-ConnectionGUID: GYVkIYYoQg6X3DWjmbdRQA==
X-CSE-MsgGUID: GM4QVgBrRqeiPzsiP2YCFw==
X-IronPort-AV: E=McAfee;i="6700,10204,11439"; a="49593331"
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="49593331"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 12:25:29 -0700
X-CSE-ConnectionGUID: goKhzZh+T7qvjI+MPvPnJg==
X-CSE-MsgGUID: vv6U+7y9TPaPsAjj5gtq6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="139666363"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 12:25:29 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 20 May 2025 12:25:28 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 20 May 2025 12:25:28 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 20 May 2025 12:25:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=akpCGn5KJTk4OI4KfRGcQGxba7plXTHkv61wLgpO1gCKr7ZC3GFBpSuhQsxGjk+rYrk6HQZh41dMZOcmGmmz6BZvPXc5JPIh+7L8OEA8QtUblydViKRKDURV2QCzg/eWbrAMb+EdwpJlkqgFdEo8heck/xVSRme/Hej0xdGm0Dgw6ll3I9rYTOXkK/kDW2UnQSIR5O5zcw5K1/yEPF5Zw6OFTHN1emR5XE4K7SgxO5753T78Saw5fupltpi7H+jO6qLG7gRKaDhapA8QTA72WH0yvB4ol6NahRcRZ4+TfSmmNRjCOGI00xeRcFYGMTit2bkqr7qWnrOnEpgOgzNdwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FJGovIzb7YLGg3beWW5D6w8BIBfsUvqJ27bh46jlvRE=;
 b=BA1lbPYpNu+tT0LgE3wZov1Y01u50Id0d0qokx5D7oIUny7+z5sk3RV0HGJM0Rvgtwpg7vTzgIWQoYkUFkoFJRPWyC8VtNOYJfYuAVqdrUmoMp+7cJ4hPB+8cD/aqgx0pgqXEQBDeSW06CSUPhnXHzj5J07bOnHUAYSV6cuLtroVVlSZ7m5TAWLe21r0plh3eTUB/lSL0we6ZLOoR8vps0BSP6mGdJW4/d3Atqvu8i2ojOeEPX1EW8OIrf4fpHFjSuqeo9cF8cUGh2R2o0VSoPujuTcLk0VtxHs2qNAdABH47GuBFC35bqk/lBeVk3DA9ke5l8vjGs9AHjfv6DKtGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB8794.namprd11.prod.outlook.com (2603:10b6:806:46a::5)
 by DS7PR11MB6063.namprd11.prod.outlook.com (2603:10b6:8:76::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.31; Tue, 20 May
 2025 19:25:23 +0000
Received: from SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720]) by SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720%5]) with mapi id 15.20.8746.030; Tue, 20 May 2025
 19:25:22 +0000
Date: Tue, 20 May 2025 12:25:15 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>, Dan Williams
	<dan.j.williams@intel.com>
Subject: Re: [NDCTL PATCH v7 4/4] cxl/test: Add test for cxl features device
Message-ID: <aCzXG9IwG6Xr-ssY@aschofie-mobl2.lan>
References: <20250519200056.3901498-1-dave.jiang@intel.com>
 <20250519200056.3901498-5-dave.jiang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250519200056.3901498-5-dave.jiang@intel.com>
X-ClientProxiedBy: BYAPR06CA0016.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::29) To SA1PR11MB8794.namprd11.prod.outlook.com
 (2603:10b6:806:46a::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB8794:EE_|DS7PR11MB6063:EE_
X-MS-Office365-Filtering-Correlation-Id: ebe6e9c3-95e5-49b6-f95b-08dd97d410b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?UAR2dBr/C9eenCPqkhblzt57LngjHjJsb/7W0XF0bp9+WFOTqqoDJ9DR49rJ?=
 =?us-ascii?Q?/BsoOzel3gCaF2riNz+Zmi7+C5GPQHROejTi1ldgIwFNjzAH8WHtF0LkQIkR?=
 =?us-ascii?Q?Z78bngPneqlYDJMiJy51D2Qgsap503B09uTsRtkafP6J0cnWvLtSQ0NNCZ3A?=
 =?us-ascii?Q?ZvW9uA0Pq0df47uQ/ffTjSWlSOebzWuk8H6caf3Ki1KPRCDX9NQdvN+qEsOA?=
 =?us-ascii?Q?UmeF4D0pA2TzqweUz3k8p4Ee87c2bQ/uJ28DFmuaJWiTXAri83eWSU9yguVv?=
 =?us-ascii?Q?DERM2WuFe9KGWVWsWpBuwjMCMG0zv37IDxIFqvPSa9rz2mKZz//pO9biuqZ6?=
 =?us-ascii?Q?mSAY+iDjwmIDzweKd248XaBGcCn1eH9xSqcZKPQU0awiZdF/AsxlDJB8zdvi?=
 =?us-ascii?Q?3waw/cX47XD2z5dMNIKJUgMTYwfx+05psjq5CqE6C8B4zu51zRRrD8eezIxW?=
 =?us-ascii?Q?dt08bSLT4N+Vq6crVraLeNv03NLjN946fS8v3LaFaXCxcaNZXEjxAXOa8xcN?=
 =?us-ascii?Q?6IMTUrwctFDFkUjddl77XLsNiHzF89dRIVptdVPRFdp5YdenqzqtG3hhOCEu?=
 =?us-ascii?Q?F52CtiWZr/VWJZd6f/ghfY0n/hBmmywlr0YNFueWYPYRvoPu5GGRdKII8Ft5?=
 =?us-ascii?Q?g1sY/0CY9C7mTP7KxzuIr9uyHnx1rY7aMmtk3PkpZUuNhFYD5F5vM6GdBJSV?=
 =?us-ascii?Q?fjbe0TlZBwrqwTwdbIch//zn39mGE9+yWscJZuqH2RwMtRrb7bG/4HpzoS+E?=
 =?us-ascii?Q?q5G4FaHc+FSWcScOwIUJwZt/CGyugt15+LfKm/1+MoNoXVqtHAMSKRcuOI3W?=
 =?us-ascii?Q?KG7GEnjtFlL0O7zDLFiCMyF3uaB7zp//F9DAME7qSSXcit0slYHYHF2zpDCE?=
 =?us-ascii?Q?T0uwI4OFIwkNbbu1hImZQfihjBpRi5mhEysW6wJ4zWGK8TIFvrR9mnLgcFbt?=
 =?us-ascii?Q?KmiPSBogz2B/rhTyikbSv02hYJ2UTylXj/P6fXxQLOvUZ1VItvbeEC4CcmxD?=
 =?us-ascii?Q?T2Awrq8+7sy+l9rAx9rIp+ViUuH90McsRyA6nK3im9b9aQhbO7hWgHV7Z7Ri?=
 =?us-ascii?Q?JI73HT7sqdIdCwnfeet7OJmi4DEDbVOqyAJUSWIPAnFo4fCXCqC8+lka+our?=
 =?us-ascii?Q?gt3TOfwH+xuSCTolJFayestm7I6H9rwXeJ2HAGQt3dHf/sXub9K85m0l1brr?=
 =?us-ascii?Q?yjN2a4flBxpRhSt7fkPUqPs9wi8AI8ZE+BdPIuJSHVxjI+X0myp5cpk0ze0r?=
 =?us-ascii?Q?U2C42hy+jPtqPsJezR929zr9FNE5+RnCVb49dvIcZKrwdin1kqPNFSn5uOrX?=
 =?us-ascii?Q?ssNl7HZQnoQMBPQQYEIRabUt+YsvxTvT5C9nbcOpTQFU6Ttmxkr410/Q+Tp2?=
 =?us-ascii?Q?46WzENDCr2XS+r8lnN7hhMhWU8Tia/1Nf5X+lmDcZJWKyoPFurULh0oSgrg7?=
 =?us-ascii?Q?5150zozTM6k=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB8794.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ELfq5noDZ0ydusiKJtWhi0nT1fjMKuSJjB3G6HyuMimpWAPq4qDdUEix1P3e?=
 =?us-ascii?Q?iD4fmuwfNJrKFrGM7E0d8InCfBQv/E05OOPW+dIV4rYsrAQ31o2xvruoDo5s?=
 =?us-ascii?Q?68kS7CHCFWfUl1CTQrggP58pq2yL6+ZVT9fM+etkx8CUjVnE/hvnfGOL+DAg?=
 =?us-ascii?Q?vuHQOkZY8YgdqcxBS3PAWq11P4F+CsZmQKsuBwyhUZOEYACh7fdMVS8eajET?=
 =?us-ascii?Q?w20Bu4BFHgz8PQLP2rxebplIVguC3STcouh+nebnUwbQ5+iKslyKF4Yn5qVa?=
 =?us-ascii?Q?BJpU/yIHgvv8yr1DOzBgymizvF0BGxMFDLa/iLjTRxgkpegLg3t0DKBmh/lW?=
 =?us-ascii?Q?oOtIzQL06OaTAGf7BYq3Ek7ye4pIqH1a1QZAh7EDl1rDINSPgj0SkOMdbbb7?=
 =?us-ascii?Q?FhIFuCb+lZokMsn1rsbPpfnJl+HwWTkK6Tnn/kj5+lVirgdfTRfAGNrJbZy+?=
 =?us-ascii?Q?SF4kelM3sJo0zZVhGoXr+0BXjT6mJTp2Sn6StbLy4qMpcjpGC5sdtPnqj103?=
 =?us-ascii?Q?Xc+uWxwgDyJ+dBbDxJUfj/bjI0Mmw0zLWNZAqyRkP/Pwd4kEDnbxwNYogKaP?=
 =?us-ascii?Q?3lI7jnI5Sz9POGGdvQOPDXKP3WFusUPKsRnwIPrqLF/dSItsJHw38h9U9GKM?=
 =?us-ascii?Q?1LhGhYToBKSrK76RAbxEO4YqO75XgfVmhJF6u5+A/hsbCCe3oYyENl3jFqGx?=
 =?us-ascii?Q?bzHXH7aUmnV3c0zIV6pLf7hgFAavSe5Rqpd0KMRxFVWkta6HDyF1QvTz/vZE?=
 =?us-ascii?Q?IMYy1kCIri610q+Gp/EwlBfErKjcoX4Klw+3qx+/O1VZ0wiqwotmW2lzpZF3?=
 =?us-ascii?Q?5djsH+R3jXnhcgYNEHt3dCuWGak3O00z7fhyWD+aOsSj+gTVPkK104vqKpw3?=
 =?us-ascii?Q?KVnREY/E3QDCE/IA+5CIhtEhXLFV7XFAU31i/UzSwhvFxgJlMAlybkbvxcLA?=
 =?us-ascii?Q?yVU8tXMn96qwFgK/EzfUvNb14mPpFbWTEuFpm4EkO+AJAoW9yOcf0UYl0r6o?=
 =?us-ascii?Q?axWHckNortvapX0Z4UYUXuwhNW61HUs3XVbgJaFpR/jZ7q66F7H2GYrJgX+v?=
 =?us-ascii?Q?eKXS25mgouqoszqNzWHWA6P908qvMmz6grETak/xNrSwCmSQZBgAMjDF/8nv?=
 =?us-ascii?Q?McS1Ek+cs5u2XPlH1WKWXLqw8h1ldwjdJhoryZrIGgYlNmPPYkBqSi2phGPG?=
 =?us-ascii?Q?7iCQTmWFuXikzRZIH2fPzkE+fPGutsi770lANGaFLBLS/HTo9g2Zto0BJyqd?=
 =?us-ascii?Q?egek3CLEx4G/gV4m7z0JewhgLWzziLOAFBCjjlru2+Jecac9jIAOF/mBNTDB?=
 =?us-ascii?Q?1MCAdu1OmBiQCup0/8w/6/ZbBPQsdmtWUuzeHVimCJynpf7IS5fWYfHDKa7X?=
 =?us-ascii?Q?2sb9gZUa+gtCWAxQnRCEJclHeKe0p0wETWRo5dithxYcNNJv4D+IkPEx6lCT?=
 =?us-ascii?Q?Y+p4J3rY0J+Ibn348FwNPuFphWAxY1dgDDU+hBmTyhWezpSpuyYaoABaNgB/?=
 =?us-ascii?Q?M8NMEJf+uQUBp1eH+PASCMDuI3SSPnRrAUmDfX6cxTSwipr+QTZonnbJyrn5?=
 =?us-ascii?Q?SMbBTgAhnQdq1Mj1QYaVv6H7H0WFBPq2XryohnD9k7u+zqhicA09KxDkN6hu?=
 =?us-ascii?Q?yg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ebe6e9c3-95e5-49b6-f95b-08dd97d410b3
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB8794.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2025 19:25:22.8296
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Uuq6Bvxe5FCfErTYJEtd/b3pswlnl6f0obnOIIBh5dfQhxqhFupMwCYWCZGkNDTCMi60SBjYY5yTg0ewtx9wC8+iU1O8w8L1mV2SLGNoFQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6063
X-OriginatorOrg: intel.com

On Mon, May 19, 2025 at 01:00:54PM -0700, Dave Jiang wrote:
> Add a unit test to verify the features ioctl commands. Test support added
> for locating a features device, retrieve and verify the supported features
> commands, retrieve specific feature command data, retrieve test feature
> data, and write and verify test feature data.
> 
> Acked-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  cxl/fwctl/cxl.h      |   2 +-
>  test/cxl-features.sh |  31 +++
>  test/fwctl.c         | 439 +++++++++++++++++++++++++++++++++++++++++++
>  test/meson.build     |  19 ++
>  4 files changed, 490 insertions(+), 1 deletion(-)
>  create mode 100755 test/cxl-features.sh
>  create mode 100644 test/fwctl.c
> 
> diff --git a/cxl/fwctl/cxl.h b/cxl/fwctl/cxl.h
> index 43f522f0cdcd..c560b2a1181d 100644
> --- a/cxl/fwctl/cxl.h
> +++ b/cxl/fwctl/cxl.h
> @@ -9,7 +9,7 @@
>  
>  #include <linux/types.h>
>  #include <linux/stddef.h>
> -#include <cxl/features.h>
> +#include "features.h"
>  
>  /**
>   * struct fwctl_rpc_cxl - ioctl(FWCTL_RPC) input for CXL
> diff --git a/test/cxl-features.sh b/test/cxl-features.sh
> new file mode 100755
> index 000000000000..3498fa08be53
> --- /dev/null
> +++ b/test/cxl-features.sh
> @@ -0,0 +1,31 @@
> +#!/bin/bash -Ex
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2025 Intel Corporation. All rights reserved.
> +
> +rc=77
> +# 237 is -ENODEV
> +ERR_NODEV=237
> +
> +. $(dirname $0)/common
> +FEATURES="$TEST_PATH"/fwctl
> +
> +trap 'err $LINENO' ERR
> +
> +modprobe cxl_test
> +
> +test -x "$FEATURES" || do_skip "no CXL Features Contrl"

Seems like a comment to help understand skip - 

# fwctl test is omitted when ndctl is built with -Dfwctl=disabled
# or the kernel is built without CONFIG_CXL_FEATURES enabled.

Now the above is assuming the .sh got in the test list and is 
not left out completely with -Dfwctl=disabled. Going to look.


> +# disable trap
> +trap - $(compgen -A signal)
> +"$FEATURES"
> +rc=$?
> +
> +echo "error: $rc"
> +if [ "$rc" -eq "$ERR_NODEV" ]; then
> +	do_skip "no CXL FWCTL char dev"
> +elif [ "$rc" -ne 0 ]; then
> +	echo "fail: $LINENO" && exit 1
> +fi
> +
> +trap 'err $LINENO' ERR
> +
> +_cxl_cleanup
> diff --git a/test/fwctl.c b/test/fwctl.c
> new file mode 100644
> index 000000000000..7a780e718872
> --- /dev/null
> +++ b/test/fwctl.c
> @@ -0,0 +1,439 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (C) 2024-2025 Intel Corporation. All rights reserved.
> +#include <errno.h>
> +#include <fcntl.h>
> +#include <stdio.h>
> +#include <endian.h>
> +#include <stdint.h>
> +#include <stdlib.h>
> +#include <syslog.h>
> +#include <string.h>
> +#include <unistd.h>
> +#include <sys/ioctl.h>
> +#include <cxl/libcxl.h>
> +#include <linux/uuid.h>
> +#include <uuid/uuid.h>
> +#include <util/bitmap.h>
> +#include <cxl/fwctl/features.h>
> +#include <cxl/fwctl/fwctl.h>
> +#include <cxl/fwctl/cxl.h>
> +
> +static const char provider[] = "cxl_test";
> +
> +UUID_DEFINE(test_uuid,
> +	    0xff, 0xff, 0xff, 0xff,
> +	    0xff, 0xff,
> +	    0xff, 0xff,
> +	    0xff, 0xff,
> +	    0xff, 0xff, 0xff, 0xff, 0xff, 0xff
> +);
> +
> +#define CXL_MBOX_OPCODE_GET_SUPPORTED_FEATURES	0x0500
> +#define CXL_MBOX_OPCODE_GET_FEATURE		0x0501
> +#define CXL_MBOX_OPCODE_SET_FEATURE		0x0502
> +
> +#define GET_FEAT_SIZE	4
> +#define SET_FEAT_SIZE	4
> +#define EFFECTS_MASK	(BIT(0) | BIT(9))
> +
> +#define MAX_TEST_FEATURES	1
> +#define DEFAULT_TEST_DATA	0xdeadbeef
> +#define DEFAULT_TEST_DATA2	0xabcdabcd
> +
> +struct test_feature {
> +	uuid_t uuid;
> +	size_t get_size;
> +	size_t set_size;
> +};
> +
> +static int send_command(int fd, struct fwctl_rpc *rpc, struct fwctl_rpc_cxl_out *out)
> +{
> +	if (ioctl(fd, FWCTL_RPC, rpc) == -1) {
> +		fprintf(stderr, "RPC ioctl error: %s\n", strerror(errno));
> +		return -errno;
> +	}
> +
> +	if (out->retval) {
> +		fprintf(stderr, "operation returned failure: %d\n", out->retval);
> +		return -ENXIO;
> +	}
> +
> +	return 0;
> +}
> +
> +static int get_scope(u16 opcode)
> +{
> +	switch (opcode) {
> +	case CXL_MBOX_OPCODE_GET_SUPPORTED_FEATURES:
> +	case CXL_MBOX_OPCODE_GET_FEATURE:
> +		return FWCTL_RPC_CONFIGURATION;
> +	case CXL_MBOX_OPCODE_SET_FEATURE:
> +		return FWCTL_RPC_DEBUG_WRITE_FULL;
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
> +static size_t hw_op_size(u16 opcode)
> +{
> +	switch (opcode) {
> +	case CXL_MBOX_OPCODE_GET_SUPPORTED_FEATURES:
> +		return sizeof(struct cxl_mbox_get_sup_feats_in);
> +	case CXL_MBOX_OPCODE_GET_FEATURE:
> +		return sizeof(struct cxl_mbox_get_feat_in);
> +	case CXL_MBOX_OPCODE_SET_FEATURE:
> +		return sizeof(struct cxl_mbox_set_feat_in) + sizeof(u32);
> +	default:
> +		return SIZE_MAX;
> +	}
> +}
> +
> +static void free_rpc(struct fwctl_rpc *rpc)
> +{
> +	void *in, *out;
> +
> +	in = (void *)rpc->in;
> +	out = (void *)rpc->out;
> +	free(in);
> +	free(out);
> +	free(rpc);
> +}
> +
> +static void *zmalloc_aligned(size_t align, size_t size)
> +{
> +	void *ptr;
> +	int rc;
> +
> +	rc = posix_memalign((void **)&ptr, align, size);
> +	if (rc)
> +		return NULL;
> +	memset(ptr, 0, size);
> +
> +	return ptr;
> +}
> +
> +static struct fwctl_rpc *get_prepped_command(size_t in_size, size_t out_size,
> +					     u16 opcode)
> +{
> +	struct fwctl_rpc_cxl_out *out;
> +	struct fwctl_rpc_cxl *in;
> +	struct fwctl_rpc *rpc;
> +	size_t op_size;
> +	int scope;
> +
> +	rpc = zmalloc_aligned(16, sizeof(*rpc));
> +	if (!rpc)
> +		return NULL;
> +
> +	in = zmalloc_aligned(16, in_size);
> +	if (!in)
> +		goto free_rpc;
> +
> +	out = zmalloc_aligned(16, out_size);
> +	if (!out)
> +		goto free_in;
> +
> +	in->opcode = opcode;
> +
> +	op_size = hw_op_size(opcode);
> +	if (op_size == SIZE_MAX)
> +		goto free_in;
> +
> +	in->op_size = op_size;
> +
> +	rpc->size = sizeof(*rpc);
> +	scope = get_scope(opcode);
> +	if (scope < 0)
> +		goto free_all;
> +
> +	rpc->scope = scope;
> +
> +	rpc->in_len = in_size;
> +	rpc->out_len = out_size;
> +	rpc->in = (uint64_t)(uint64_t *)in;
> +	rpc->out = (uint64_t)(uint64_t *)out;
> +
> +	return rpc;
> +
> +free_all:
> +	free(out);
> +free_in:
> +	free(in);
> +free_rpc:
> +	free(rpc);
> +	return NULL;
> +}
> +
> +static int cxl_fwctl_rpc_get_test_feature(int fd, struct test_feature *feat_ctx,
> +					  const uint32_t expected_data)
> +{
> +	struct cxl_mbox_get_feat_in *feat_in;
> +	struct fwctl_rpc_cxl_out *out;
> +	size_t out_size, in_size;
> +	struct fwctl_rpc_cxl *in;
> +	struct fwctl_rpc *rpc;
> +	uint32_t val;
> +	void *data;
> +	int rc;
> +
> +	in_size = sizeof(*in) + sizeof(*feat_in);
> +	out_size = sizeof(*out) + feat_ctx->get_size;
> +
> +	rpc = get_prepped_command(in_size, out_size,
> +				  CXL_MBOX_OPCODE_GET_FEATURE);
> +	if (!rpc)
> +		return -ENXIO;
> +
> +	in = (struct fwctl_rpc_cxl *)rpc->in;
> +	out = (struct fwctl_rpc_cxl_out *)rpc->out;
> +
> +	feat_in = &in->get_feat_in;
> +	uuid_copy(feat_in->uuid, feat_ctx->uuid);
> +	feat_in->count = feat_ctx->get_size;
> +
> +	rc = send_command(fd, rpc, out);
> +	if (rc)
> +		goto out;
> +
> +	data = out->payload;
> +	val = le32toh(*(__le32 *)data);
> +	if (memcmp(&val, &expected_data, sizeof(val)) != 0) {
> +		rc = -ENXIO;
> +		goto out;
> +	}
> +
> +out:
> +	free_rpc(rpc);
> +	return rc;
> +}
> +
> +static int cxl_fwctl_rpc_set_test_feature(int fd, struct test_feature *feat_ctx)
> +{
> +	struct cxl_mbox_set_feat_in *feat_in;
> +	struct fwctl_rpc_cxl_out *out;
> +	size_t in_size, out_size;
> +	struct fwctl_rpc_cxl *in;
> +	struct fwctl_rpc *rpc;
> +	uint32_t val;
> +	void *data;
> +	int rc;
> +
> +	in_size = sizeof(*in) + sizeof(*feat_in) + sizeof(val);
> +	out_size = sizeof(*out) + sizeof(val);
> +	rpc = get_prepped_command(in_size, out_size,
> +				  CXL_MBOX_OPCODE_SET_FEATURE);
> +	if (!rpc)
> +		return -ENXIO;
> +
> +	in = (struct fwctl_rpc_cxl *)rpc->in;
> +	out = (struct fwctl_rpc_cxl_out *)rpc->out;
> +	feat_in = &in->set_feat_in;
> +	uuid_copy(feat_in->uuid, feat_ctx->uuid);
> +	data = feat_in->feat_data;
> +	val = DEFAULT_TEST_DATA2;
> +	*(uint32_t *)data = htole32(val);
> +	feat_in->flags = CXL_SET_FEAT_FLAG_FULL_DATA_TRANSFER;
> +
> +	rc = send_command(fd, rpc, out);
> +	if (rc)
> +		goto out;
> +
> +	rc = cxl_fwctl_rpc_get_test_feature(fd, feat_ctx, DEFAULT_TEST_DATA2);
> +	if (rc) {
> +		fprintf(stderr, "Failed ioctl to get feature verify: %d\n", rc);
> +		goto out;
> +	}
> +
> +out:
> +	free_rpc(rpc);
> +	return rc;
> +}
> +
> +static int cxl_fwctl_rpc_get_supported_features(int fd, struct test_feature *feat_ctx)
> +{
> +	struct cxl_mbox_get_sup_feats_out *feat_out;
> +	struct cxl_mbox_get_sup_feats_in *feat_in;
> +	struct fwctl_rpc_cxl_out *out;
> +	struct cxl_feat_entry *entry;
> +	size_t out_size, in_size;
> +	struct fwctl_rpc_cxl *in;
> +	struct fwctl_rpc *rpc;
> +	int feats, rc;
> +
> +	in_size = sizeof(*in) + sizeof(*feat_in);
> +	out_size = sizeof(*out) + sizeof(*feat_out);
> +	/* First query, to get number of features w/o per feature data */
> +	rpc = get_prepped_command(in_size, out_size,
> +				  CXL_MBOX_OPCODE_GET_SUPPORTED_FEATURES);
> +	if (!rpc)
> +		return -ENXIO;
> +
> +	/* No need to fill in feat_in first go as we are passing in all 0's */
> +
> +	out = (struct fwctl_rpc_cxl_out *)rpc->out;
> +	rc = send_command(fd, rpc, out);
> +	if (rc)
> +		goto out;
> +
> +	feat_out = &out->get_sup_feats_out;
> +	feats = le16toh(feat_out->supported_feats);
> +	if (feats != MAX_TEST_FEATURES) {
> +		fprintf(stderr, "Test device has greater than %d test features.\n",
> +			MAX_TEST_FEATURES);
> +		rc = -ENXIO;
> +		goto out;
> +	}
> +
> +	free_rpc(rpc);
> +
> +	/* Going second round to retrieve each feature details */
> +	in_size = sizeof(*in) + sizeof(*feat_in);
> +	out_size = sizeof(*out) + sizeof(*feat_out);
> +	out_size += feats * sizeof(*entry);
> +	rpc = get_prepped_command(in_size, out_size,
> +				  CXL_MBOX_OPCODE_GET_SUPPORTED_FEATURES);
> +	if (!rpc)
> +		return -ENXIO;
> +
> +	in = (struct fwctl_rpc_cxl *)rpc->in;
> +	out = (struct fwctl_rpc_cxl_out *)rpc->out;
> +	feat_in = &in->get_sup_feats_in;
> +	feat_in->count = htole32(feats * sizeof(*entry));
> +
> +	rc = send_command(fd, rpc, out);
> +	if (rc)
> +		goto out;
> +
> +	feat_out = &out->get_sup_feats_out;
> +	feats = le16toh(feat_out->supported_feats);
> +	if (feats != MAX_TEST_FEATURES) {
> +		fprintf(stderr, "Test device has greater than %u test features.\n",
> +			MAX_TEST_FEATURES);
> +		rc = -ENXIO;
> +		goto out;
> +	}
> +
> +	if (le16toh(feat_out->num_entries) != MAX_TEST_FEATURES) {
> +		fprintf(stderr, "Test device did not return expected entries. %u\n",
> +			le16toh(feat_out->num_entries));
> +		rc = -ENXIO;
> +		goto out;
> +	}
> +
> +	entry = &feat_out->ents[0];
> +	if (uuid_compare(test_uuid, entry->uuid) != 0) {
> +		fprintf(stderr, "Test device did not export expected test feature.\n");
> +		rc = -ENXIO;
> +		goto out;
> +	}
> +
> +	if (le16toh(entry->get_feat_size) != GET_FEAT_SIZE ||
> +	    le16toh(entry->set_feat_size) != SET_FEAT_SIZE) {
> +		fprintf(stderr, "Test device feature in/out size incorrect.\n");
> +		rc = -ENXIO;
> +		goto out;
> +	}
> +
> +	if (le16toh(entry->effects) != EFFECTS_MASK) {
> +		fprintf(stderr, "Test device set effects incorrect\n");
> +		rc = -ENXIO;
> +		goto out;
> +	}
> +
> +	uuid_copy(feat_ctx->uuid, entry->uuid);
> +	feat_ctx->get_size = le16toh(entry->get_feat_size);
> +	feat_ctx->set_size = le16toh(entry->set_feat_size);
> +
> +out:
> +	free_rpc(rpc);
> +	return rc;
> +}
> +
> +static int test_fwctl_features(struct cxl_memdev *memdev)
> +{
> +	struct test_feature feat_ctx;
> +	unsigned int major, minor;
> +	struct cxl_fwctl *fwctl;
> +	int fd, rc;
> +	char path[256];
> +
> +	fwctl = cxl_memdev_get_fwctl(memdev);
> +	if (!fwctl)
> +		return -ENODEV;
> +
> +	major = cxl_fwctl_get_major(fwctl);
> +	minor = cxl_fwctl_get_minor(fwctl);
> +
> +	if (!major && !minor)
> +		return -ENODEV;
> +
> +	sprintf(path, "/dev/char/%d:%d", major, minor);
> +
> +	fd = open(path, O_RDONLY, 0644);
> +	if (fd < 0) {
> +		fprintf(stderr, "Failed to open: %d\n", -errno);
> +		return -errno;
> +	}
> +
> +	rc = cxl_fwctl_rpc_get_supported_features(fd, &feat_ctx);
> +	if (rc) {
> +		fprintf(stderr, "Failed ioctl to get supported features: %d\n", rc);
> +		goto out;
> +	}
> +
> +	rc = cxl_fwctl_rpc_get_test_feature(fd, &feat_ctx, DEFAULT_TEST_DATA);
> +	if (rc) {
> +		fprintf(stderr, "Failed ioctl to get feature: %d\n", rc);
> +		goto out;
> +	}
> +
> +	rc = cxl_fwctl_rpc_set_test_feature(fd, &feat_ctx);
> +	if (rc) {
> +		fprintf(stderr, "Failed ioctl to set feature: %d\n", rc);
> +		goto out;
> +	}
> +
> +out:
> +	close(fd);
> +	return rc;
> +}
> +
> +static int test_fwctl(struct cxl_ctx *ctx, struct cxl_bus *bus)
> +{
> +	struct cxl_memdev *memdev;
> +
> +	cxl_memdev_foreach(ctx, memdev) {
> +		if (cxl_memdev_get_bus(memdev) != bus)
> +			continue;
> +		return test_fwctl_features(memdev);
> +	}
> +
> +	return 0;
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	struct cxl_ctx *ctx;
> +	struct cxl_bus *bus;
> +	int rc;
> +
> +	rc = cxl_new(&ctx);
> +	if (rc < 0)
> +		return rc;
> +
> +	cxl_set_log_priority(ctx, LOG_DEBUG);
> +
> +	bus = cxl_bus_get_by_provider(ctx, provider);
> +	if (!bus) {
> +		fprintf(stderr, "%s: unable to find bus (%s)\n",
> +			argv[0], provider);
> +		rc = -EINVAL;
> +		goto out;
> +	}
> +
> +	rc = test_fwctl(ctx, bus);
> +
> +out:
> +	cxl_unref(ctx);
> +	return rc;
> +}
> diff --git a/test/meson.build b/test/meson.build
> index 2fd7df5211dd..93b1d78671ef 100644
> --- a/test/meson.build
> +++ b/test/meson.build
> @@ -17,6 +17,13 @@ ndctl_deps = libndctl_deps + [
>    versiondep,
>  ]
>  
> +libcxl_deps = [
> +  cxl_dep,
> +  ndctl_dep,
> +  uuid,
> +  kmod,
> +]
> +
>  libndctl = executable('libndctl', testcore + [ 'libndctl.c'],
>    dependencies : libndctl_deps,
>    include_directories : root_inc,
> @@ -235,6 +242,18 @@ if get_option('keyutils').enabled()
>    ]
>  endif
>  
> +uuid_dep = dependency('uuid', required: false)
> +if get_option('fwctl').enabled() and uuid_dep.found()
> +  fwctl = executable('fwctl', 'fwctl.c',
> +    dependencies : libcxl_deps,
> +    include_directories : root_inc,
> +  )
> +  cxl_features = find_program('cxl-features.sh')
> +  tests += [
> +    [ 'cxl-features.sh',        cxl_features,       'cxl'   ],
> +  ]
> +endif
> +
>  foreach t : tests
>    test(t[0], t[1],
>      is_parallel : false,
> -- 
> 2.49.0
> 
> 
