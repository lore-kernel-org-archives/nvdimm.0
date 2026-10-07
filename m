Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A689C345EA3
	for <nvdimm@lists.linux.dev>; Wed,  7 Oct 2026 23:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791416808; cv=fail; b=pWQ8P5NuZG5sRFmrLbIKr7XTCSBjM3p+LxHE/OjJqu5beleIsbWUssZgs0y0aYtb98ME4WL5kkhhQd67RB5bWzDf90oBMwNGJsj6yLhrfJI7K4BUWOoJ2Ydodec6u4MmdOvtsfM/tE7w7bQKbZxmlBiOa26p/ZqeCrg+BX2XN7k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791416808; c=relaxed/simple;
	bh=VvQ6o8kKdyVImBR+txj2unmofybmihT6tRRsBqLDDHA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=r+kZZ08dOA33vQ5r07YQ1DPX6qLdCdWpsWuLL8d2RU6oKRGDy5ekGZvhWcJ1tfbEz+/dXUzWYwmzSW6oOFoFoTMLxbqf2l/7DZtcZvywhFyhqE4KZULLnjRAryd2rpm5SBRPYAxxV3gYB4N6bIQGFCYb08N6f9oouEiWD5c/rAM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Gk2ytKzc; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Gk2ytKzc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791416808; x=1822952808;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=VvQ6o8kKdyVImBR+txj2unmofybmihT6tRRsBqLDDHA=;
  b=Gk2ytKzcpzA6JVGrlI2CqnFyncbNC4kRWeh3mhP6FZDTTHc5pAyturtx
   9srPIKSGltq4hLSg4tS1qzOi7qdkLXqjPDsFXRrruKuw8D4GYwGinlgNv
   eHASbYiUyJa8dqySXOUK8GLwFGsBsMSyicQnsVsP/uBHbI7wKkJ35O/5E
   56rIBam4qL9J/nBjOzKGdyKDDMlycOpE9/+BN9F9oKBPX6Vvh9FIlMGb9
   4+o+hLjH+rFgi3WQj/EJWHUJ+0hup1i5s3y81P9FTxMquD0M32q5VCx7u
   dyLStC2164AVWG4UEbWJWj+p89ADSTR1KobMRINxGV8QfhctfvXoohr71
   Q==;
X-CSE-ConnectionGUID: 7T1rL4g9RS+Q74hG89LM9A==
X-CSE-MsgGUID: 6/TjcUGvSxKx+dWNzBlOSQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11928"; a="192297"
X-IronPort-AV: E=Sophos;i="6.27,145,1787036400"; 
   d="scan'208";a="192297"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2026 16:46:47 -0700
X-CSE-ConnectionGUID: 0NSgBwfZTxC/qpM1NUFbLw==
X-CSE-MsgGUID: dyDV3nC0S+WngUDvbjJuuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,145,1787036400"; 
   d="scan'208";a="277705842"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2026 16:46:46 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 7 Oct 2026 16:46:46 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Wed, 7 Oct 2026 16:46:46 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.18) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 7 Oct 2026 16:46:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EQktmMdP6r840wCbujHY5gArtyyCCh0y4C+Q+xdl6mSOZJ5P0BVwvjyZFKgZo/GG1XXKQRGSJmeiTBQJS7g+aLqeqT75NfFD/NwoJRJRD2z9MVR73JwRcxpzdzEqjnLUR0pQoNHUmfTRmtYes1qdvqVdfUut/8T0+6UQbrubT7dV9ztcduxVBLn36Yox2ZLXssqs+Vkn34eWfJwWBSs3ayvFW9ssVAl9wmPle5oFwvXcxSKCjt+doSMdeJkjpTh9MGWoHsfChw8rVOko4e/j/2G1cSHHw6aigHSnQ3VGmpR1P0hvPiFLn1iVsBs+Zdofq+uXibfZFJDZga4oDPHwyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OXrRx+27dlto9ZklhzcoglsjrAYzyEWy6/RfUeGN9Dk=;
 b=VHUeslUy0kH6Lqyhu0HD6yXi+ITKypS5tbZITBSZL0gH+zhoblydH1hy5eGF71w2EMK2K94OfvBeBj2Ux4H7YCrm2eMUKVLTlsA7X9QIRCHL6ki21DMoJ+iifVqmPVtGv7ZNn4uM1czJ5DTBW1Ix6/wxUGZC0JZf6z8Rr1Shnn+dAHkhK0Ry6XyCVzD0jL2MpArRrL5q/BkZGC1FLSVNC9mGI5cL/FicsEMa1nNQcwunBDfUxfjV13WqGuuzuictanEi1QhgHbXOKOQaJsyNQMzQ3hvyEoTJNB0tsA8/OPSFhn/ldiOx4qNmsPlsWb+3pQ8/zG0IVeAAtDHZEnEhsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by PH0PR11MB7615.namprd11.prod.outlook.com (2603:10b6:510:26e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.15; Wed, 7 Oct
 2026 23:46:42 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0496.010; Wed, 7 Oct 2026
 23:46:42 +0000
Date: Wed, 7 Oct 2026 16:46:38 -0700
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
Subject: Re: [PATCH v15 6/8] cxl/mem: Configure dynamic capacity interrupts
Message-ID: <asbZ3rHtXygXi3x_@aschofie-mobl2.lan>
References: <20261007201828.952-1-anisa.su@samsung.com>
 <20261007201828.952-7-anisa.su@samsung.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20261007201828.952-7-anisa.su@samsung.com>
X-ClientProxiedBy: SJ0PR03CA0110.namprd03.prod.outlook.com
 (2603:10b6:a03:333::25) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|PH0PR11MB7615:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f4303cb-174e-4e74-cc98-08df24cd3d2b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|11063799006|3023799007|56012099006|4143699003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: aQstVMpCpWh0LHipF2Q5yGulKoaPbfiQT9hT8m6IpxdQnLSzjgf2jQyz1dFNAQheycXrq/6ZzlgDBUecsCVl6ROEbqZnt/3rXmgllJLhBKnK0wPU6ZdrQ3INoVS25fKLwrEuZqFwdbvVmnIWrBc3Y9ykMyREr7QklyruAnCUVFA2MiIyWu1cJVaJCE4Da71hAHdrX4eTuZdripHdzp0DjDOjzSXcVPrS36VU7s5JxYHjiTEitIhkiIMC3bjJ4v7Dh7sx+NDK3gRmdki1VNSWsyIfC8G4x9SWUYj78Lim0fWpTLoYwqLvOAueD0eXT9plHi3NL+V5j22O+VOpvJ4yy9c8CaW8gcWDbykEjUbuA67WWWuLkIbd3wx/vWzcTnvHPY2GVH5h1Y5hxCwWIAQt/oNDpxp31HDmHX0tszPNRJSuoIS9LhEoNav9aduiNTHJCWSz7f8uC/m7xFDyVnEKcpZBLn79i8wxouUGzLhCgrajqytIxWMjorWsikbMfkuq98cQqXY+VSRuWbz5xRjFstMY1WfFmdEGiplcDGsJCiGU0ZrG6QQmzc1E3lJ+U5pURpahi6xEnjwLFVDf5aOPScTiy5Ghpr7FEpRtwGF9gSXi73sMHyW1Td4PeA8+/bcw4rMdY34yvGThkuGv7XWCLficHpI9B/P1hyXB8h8ghDM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(11063799006)(3023799007)(56012099006)(4143699003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?r9j0dPy4vneK38Kc9MtS7hyt+HCx/b1xO70gwLgcGur7leWvV9nStgS47NRL?=
 =?us-ascii?Q?ga/v0TluB7cIqy5+4HM4ClFuXtR9Zxqh+6LxmHJk2JLMyLiszE4vWq3igB+S?=
 =?us-ascii?Q?z4b7O0M8I3ZDsrHpObspF8aXucz6MyAP5a3WxCbzk6JGYIcvmrW0CttM7xy7?=
 =?us-ascii?Q?pNG26aCZqZZQuFBV7HiY7MLK+nJUmd5mBQQ8SFBGU//Ix1NogQwMQRGF1PZq?=
 =?us-ascii?Q?4ZYCIJdqGHTw70QWlgbbA5q2lBcMVfvh7eRF3vuzJUlbIOglDtv7xkHVd7R1?=
 =?us-ascii?Q?8fUirqoWoFdDmVRkHZyEmaFo4+mcmUQ5dCcv9Ofd95elW4f7i8UWXe5OtNIB?=
 =?us-ascii?Q?QsJwjIAKQUFd/+dSoT3N6LoAxgQ+dqWbLzdH07f927cuyKaeboQau1o5BNQk?=
 =?us-ascii?Q?NGa4LLOstKw2atudE2+/3pEqupoQtR3mkdwzuN7rMsCLAQpLNRzAM0mJaJiK?=
 =?us-ascii?Q?RyBq+R/XxZysJKdx3Va4ng8bI6u1JB3ec+k98k4pCsJKfiQg3COOJd571/DY?=
 =?us-ascii?Q?yzBvGXVKH7T3ml+vZ/mPG2xkxctsxFjHBtdyi4fiNI20Zm99ZXrURpIZDz2+?=
 =?us-ascii?Q?MRxW46HY7TBG7Qib6QwRPRju6nYGVXTVi9w7d6WgPoA7Z2WnqJHzIatSupfF?=
 =?us-ascii?Q?UligCMADA92BhD+NoJf0P6fSPD6zPiYmV2XS9KtcNCQ8uVC9IEZUYwyugqjP?=
 =?us-ascii?Q?TTlk3X4qUA+z6hnXU9iP79/tiuVlo/O831USjRaktsVQIp+HU32H11RLdOdh?=
 =?us-ascii?Q?i6zyKLzU90+ViP1iDEN9RcKc7BjxEJopUTQbAAZ+Dvn/qKLkSARc2ofe2Jn5?=
 =?us-ascii?Q?U4c3F8OWFTasIecStXT3UhJ2BAVRL6lD6+GoF2ob/+cb4s91NVRLdeZ5nxTt?=
 =?us-ascii?Q?4f9wnwFMy/deOdpjaZtHf/VU3DllZ9J518LSO9IcQJ73KTlMI63me+QavkK2?=
 =?us-ascii?Q?Ki/6rg4s1xyouSBmPLgVaob8FBRlLNwprrqv2t0nONs72SyLddRdvLqtZYFG?=
 =?us-ascii?Q?eo/GeGMklrRs50+5hldG2yjRFMbcsD1xXnHLQI0GH3sdoFmat2+QZH3MPuRW?=
 =?us-ascii?Q?Ap87oFdftxg7lHpE4gVhh+Ux7DIkUAgW4A2cCbo0v++Zql8xAr6J61R5AQI2?=
 =?us-ascii?Q?/x56z+Stbm0n/T29oWX8+TReGY5+PHVFWdEqu3aYlgDczas1Fep8mYHycw55?=
 =?us-ascii?Q?gfrP7dqUQy5iY28WkfBY2JUm60w+820TRzd/Srp6pfYGHCry9CdtDEEh9AmF?=
 =?us-ascii?Q?OQIYjHZNRZVBu0WC1xikRaLKa0XQJGQJV4sdUb6lo0AckTkVZ1I5wkA0H2dM?=
 =?us-ascii?Q?SDTEopuG4Dh5E+cO65/zRpSvifVfelhy4kdJ5V14rebaVilpfZ6VzAqKAUj/?=
 =?us-ascii?Q?YM4Qc4ITLdxAQAq55XO0L3hBfJ5TKkWInXjOlcW+D6Gvo++oZr691NA7qhdX?=
 =?us-ascii?Q?A3khs4izuTkURqsWwYui/c6PR+G8Upj9SfLK6P7vq5dTaEDgaiU28LrcULhk?=
 =?us-ascii?Q?57tKtYf+Fhv9cBsMXHq5BRDWKcv+usbozF5vFg1c0shB1Jt9S6gl/Iad849O?=
 =?us-ascii?Q?04dHTLwcgxvO96p8iEijeKZlOpu5sGW/OWHo4Kmx2ocQpMjwnBHxyzB+F6L9?=
 =?us-ascii?Q?lb9Qhoj5YWEIQ1dhHkYFuWELvM9eY9uWb+rfpDN+4Yg1cONBQblXINtsehhV?=
 =?us-ascii?Q?jnEjNWFiSlqo2P1sAFw0po5tnLyiZsg2pGwInVXQ0im1bDfUdeMY903xZayN?=
 =?us-ascii?Q?ssyy+o7XjrSqIQyu0pZX6I9JzACbHEc=3D?=
X-Exchange-RoutingPolicyChecked: OiuiznoqtsQkyQEpGR3w6GRsrB7RBrKg+Nqt9DRILrGBAwRAKNtCfBMYXOR5cB495snAemzaI5zko2D3xtF3A9Z2sOBh2QNiB+u64OIb4jX++M9A3OAUOBINXA3qjALrgDW1KbgNOFuDMmC2LVxwS09h7ieOCCKg7qU5+aPKX2RNegDplOqT5KHEPw55gPa2ZEUm6sMv4FrplRsGOsdfw+eDeXJLpb9gTc1vOlqCe4/72MTQbd0fy468Lt04r0mGLB4e3Gq2SMK1/3VmS6PN9+nXuwzhdVxa+P0smfijfkCfElJDSJ62XSKs6UibwqCZXDzaSaplgw9kviZogQNauQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f4303cb-174e-4e74-cc98-08df24cd3d2b
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2026 23:46:42.4626
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wk+DSBdwTmhU4WaJ7LjxxzDflI5QPJ6I50JFBEgGQmZiT7UO240e4w+irtfEdyViCWMGmqJcWmFTJ4ciz5VsNNl5wuBpvQro5QDQQm3dmPg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7615
X-OriginatorOrg: intel.com

On Wed, Oct 07, 2026 at 01:16:39PM -0700, Anisa Su wrote:
> From: Ira Weiny <iweiny@kernel.org>
> 
> Dynamic Capacity Devices (DCD) support extent change notifications
> through the event log mechanism. The interrupt mailbox commands were
> extended in CXL 3.1 to support these notifications. Firmware can't
> configure DCD events to be FW controlled but can retain control of
> memory events.
> 
> Configure DCD event log interrupts on devices supporting dynamic
> capacity. Disable DCD if interrupts are not supported.
> 
> The DCD event log is not drained here. cxl_event_drain_mask() reports
> only the logs the driver can service, and the DCD bit is added by
> the patch introducing DCD event handling. Until then a DCD interrupt
> wakes the event thread, which finds no log it owns and returns.
> 
> Care is taken to preserve the interrupt policy set by the FW if FW first
> has been selected by the BIOS.
> 
> Based on an original patch by Navneet Singh.
> 
> Signed-off-by: Ira Weiny <iweiny@kernel.org>
> Co-developed-by: Anisa Su <anisa.su@samsung.com>
> Signed-off-by: Anisa Su <anisa.su@samsung.com>

Reviewed-by: Alison Schofield <alison.schofield@intel.com>

