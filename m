Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A0111DFE8
	for <nvdimm@lists.linux.dev>; Tue, 22 Apr 2025 19:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745350855; cv=fail; b=tjSstYALMwZLQ68CByiQDAI3oJTmYSpcrGJ69rQEuu1mZK2Mi5QRAM2qNgkvXAjMmR2evOB9cg2kdqM2UFE7o4rjHGBgHb4RsUsm+daxLiMBEKI/nqiZVtpBGMAibUk9uNBnW1WqTXvkS8/xaB/jSQRvYToHYM7c9paCl35TYb0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745350855; c=relaxed/simple;
	bh=ncjYw1n3sgxQRjkPxsX3wvxbMGlZFY7ITok5qc/lf/U=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=UbgtlT4S/E5txxRJPQe+LhIVOEeqae7CUwEhwWeq8rwjAHKu+QKZFjFxBOtjYilQXSoTa4L/1MKpKi3XaXt763ywRePt+1aKxi0u9CLimWV4+uMwoOGWNepCNDHzAWCHF7Hj+WyjA98CnQwOoJH2S/iuN8H1kEkTEWRUHnf0Fy0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UrmU0pBH; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UrmU0pBH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745350853; x=1776886853;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ncjYw1n3sgxQRjkPxsX3wvxbMGlZFY7ITok5qc/lf/U=;
  b=UrmU0pBHra89HW/xhxbe4DpgfZyy85fRcZXNOb/A2QinMZNrxtAQnx7W
   lWbQxGrwkY4DTCh+VQTxAwEEYOl4o5U6m+izedxm0/YEEsKIX6b/WczjX
   FepBNr120P3VWV1ePvD6/mVyvW7u8XGoz6xdRhbMHgClvN6r5XurPPMEe
   AUoqGkmMbkZeddRqgo/aPaScgjG7rjrRMHiUv7b1ZgCEzLVJzof7aCCyF
   2DRcd3mUjrngVuKKyftfgwvmqFFnboPVEITJSTCGXge5IgRm8uuez4Buj
   rmtHyPeP2DB9hhpy3J1ld8NMYdthheZhGLLz2xB2S7ugBiTIqBPOpdZBR
   A==;
X-CSE-ConnectionGUID: CZEHsz1KQrWmY3qZYyK6tw==
X-CSE-MsgGUID: zrGYtAYmRDKekvki8RGDKQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11411"; a="64455567"
X-IronPort-AV: E=Sophos;i="6.15,231,1739865600"; 
   d="scan'208";a="64455567"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2025 12:40:53 -0700
X-CSE-ConnectionGUID: hke5cZrTTTCU9FWkn1Mifw==
X-CSE-MsgGUID: WADS3nzCRhG2bVme2z8Q8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,231,1739865600"; 
   d="scan'208";a="132982659"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2025 12:40:52 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 22 Apr 2025 12:40:52 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 22 Apr 2025 12:40:52 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 22 Apr 2025 12:40:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c4T0BJyYboCdYze1MUkFI+VmZ0fXzAw38oMxQ3qfphMoamQng7fKFe9zH9MiP4EMI//lN4DkqryBMWsI+erpLZG4YvVRghJpeBmrYc4UnR+/xH7R9uHGq+wdikXIMtrwx5GGzH4jZm/ir7tkxxGf02slg+EY+eu7sxkHi5P+jayKXSC1+3btsIplNDoFR/ay3gwYmUs0vzXXMLb3/dhVrDX9c/HUMeUb6Zu3E9G9yb3uR3P6C8NGsZA8guinZvpZdDGqCn8QK02xHYHJ7Ea1jjnqORG2fYTx3/R1fCgIkHugm+mpGzIGulOLg7/ZJ6RWiSRvp23YIaCcDxp5X4akIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ncjYw1n3sgxQRjkPxsX3wvxbMGlZFY7ITok5qc/lf/U=;
 b=FsMKVLe3SJU7raMJn3YXIsV2aqBvV3H04vTpIMJ74xysz2pZRNbntf+0lwaqw3QB35xwoJHJimFkOk2OCem3AlYdSVGm4eC98pKZZaedZyl6Jfg0B9qu9rRYqxkJaprf/ophxTAuT79V1iLjgDQtK3rDJ6wpST2lazP3U5kc9I2z11kZxlBOIUFKb1OT/IzHzaPAFHPqPWb4BbqM21r1qDJ+KMi6cW9h/80XPGLRTVqxcSJq5gijX//O3HeMxegl6dFONI7pI5LCUTR5rZXRQbEpazI4OKFYxJj7IpGdlkzaLa3FuUghV9VH03VQqO71WY1IpOpbq9i3Bu51CvgI8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by CO1PR11MB5108.namprd11.prod.outlook.com (2603:10b6:303:92::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.22; Tue, 22 Apr
 2025 19:40:50 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%4]) with mapi id 15.20.8655.031; Tue, 22 Apr 2025
 19:40:50 +0000
Date: Tue, 22 Apr 2025 12:40:47 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Dan Williams <dan.j.williams@intel.com>, Pasha Tatashin
	<pasha.tatashin@soleen.com>
CC: Michal Clapinski <mclapinski@google.com>, Vishal Verma
	<vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Ira Weiny
	<ira.weiny@intel.com>, Jonathan Corbet <corbet@lwn.net>,
	<nvdimm@lists.linux.dev>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] libnvdimm/e820: Add a new parameter to configure
 many regions per e820 entry
Message-ID: <6807f0bfbe589_71fe2944d@dwillia2-xfh.jf.intel.com.notmuch>
References: <20250417142525.78088-1-mclapinski@google.com>
 <6806d2d6f2aed_71fe294ed@dwillia2-xfh.jf.intel.com.notmuch>
 <CA+CK2bD9QF-8dxd92UBoyvO0rBJ3uTN27pXzO2bALw4v_2D_8g@mail.gmail.com>
 <6807e7647d39e_71fe294be@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6807e7647d39e_71fe294be@dwillia2-xfh.jf.intel.com.notmuch>
X-ClientProxiedBy: MW4PR04CA0327.namprd04.prod.outlook.com
 (2603:10b6:303:82::32) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|CO1PR11MB5108:EE_
X-MS-Office365-Filtering-Correlation-Id: fc25831c-8641-4aef-eb86-08dd81d595e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?CCkCCCisOqAyl4jB5Zo0Oru1cQZvTKvzHco1gTxCeyd4oKOERihcot9BMqB8?=
 =?us-ascii?Q?kGo48AK5o8WWMAvSIKcH9pdFqk/IW5kcij/OSFpNDkhgMW+tnDUBZQAF4KqY?=
 =?us-ascii?Q?zzLe+CmMBs1wpzpOel3yXYXpve/H3Ze3CesIX7xEEKZ7Dl+MZaIL1gv653gv?=
 =?us-ascii?Q?E+zOKsyRYtdtRgfIuuhceXsO5IyA2UA+9P3Bu8b0ozj2+zPxgNmq9BQ1XPeK?=
 =?us-ascii?Q?NoVuAJx51+8HWbgD35b5dzPwCDwyqf8rtVwnWuZVLx530PTuJaoahDKfLPQu?=
 =?us-ascii?Q?+8t881Bw9IW1u336hMWXLv2D1TGOceAl7CRuJzo4PzROp4ZOeRGUH+wJZYvC?=
 =?us-ascii?Q?RBWXCULmlE0Xz2BJ6N66cUJMNGdo4b+wv+WhuNZlNr9Tv4eWMeO1/2npBFw3?=
 =?us-ascii?Q?CIKeVCyoe0lwA9Yq7aA+5ktGOWP52HJ9i0WP3vSQ+fFn3wPLfxFCGLUMhLLD?=
 =?us-ascii?Q?ZYZlOGJ88Ot/bkCZ/iUqiJqe7j1aosPb7FHUs9mAuzIdJ1c82FbuePMAYeBd?=
 =?us-ascii?Q?1diU3NKT45nIvjI6+E1rQOOO4CJGWKWRInAIIIIltnF/NzRmpkMAbFD0N70W?=
 =?us-ascii?Q?jHqwPKHo2kws8aKfRp6TY62Ufnt2qt6r3v9oM1Ihsj2ArYR0/xqx+yS1bYzr?=
 =?us-ascii?Q?ioTm99THJecCO7FkZ1mnwTxDgF8EwnfB1cPRXCkQN83ow/naQqpZ9zLkp+d9?=
 =?us-ascii?Q?wnRPhBt9Xqt9I7pD9mJ9UiwZAJMCX1DHTALx7CHGy+xeqLKBN3YkculHXGVI?=
 =?us-ascii?Q?9ctF2TxTy3jkf8NmQYY3N9Lnkzg8UXYQa865GRezLJeO0UukwSvR11Vex2yf?=
 =?us-ascii?Q?loZJ0zvvIdQ8kt5t4iV4oHvOAwerKmpzzAtqTNIOUSo55XiYlp8idVPuZLLa?=
 =?us-ascii?Q?IXsqcwiw3Y1eCguW4MwICjh8GSdSRl49TaID9mgzSBFa6CcrNBnAoYbeeehB?=
 =?us-ascii?Q?UneXFYzH1ThOPGxSZBSBaUT/QkXCI/MDwJ/C1H/VRc4XPLT/eax/cgtxSK4t?=
 =?us-ascii?Q?A9r+I+8WqTFl6lfuk4e1B/9xc6YBP/vourZDtaI2p5uUUlfSYSJJk7r2ybYp?=
 =?us-ascii?Q?psioj5ivRiF8tGXKj/mDaAXXiDIy/9ziL0t5sYSVPH5vyhpx1PEvIOxqcALO?=
 =?us-ascii?Q?Zp8n+aWqN8t3ltUJW49zOXLHfTD8XL2aAQXwehoKK1RcOHq2h97tALMIb85u?=
 =?us-ascii?Q?zGpIm5NcsS+Eduv69aY0Fi0ZMN+50DNT4z+WM8cMDqm2jgicZE+6vkhJtqUo?=
 =?us-ascii?Q?TUDT82XRH3ZJXbA5qM489rhcmcQX+kEeQsoIA0miqni4lGiQXrKnMsAipO8A?=
 =?us-ascii?Q?JAk1bCLMG/ii9TPI/PA9CpJ2gnnCF6ASqTGLBwQ0poNoU5NibM74uqD2k4XQ?=
 =?us-ascii?Q?aM7fLqTjRHEfpdEL4dmBUnNLtVpMmvvJuL7T7ujBef9e/22E29V5/Z+KKXLm?=
 =?us-ascii?Q?NcjNPPBZVKM=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pafTJR4cWaSEkjM85X+e+ceDgRO6DCWzFWHr8guWs0KEZru/5DzRWBwGpfhL?=
 =?us-ascii?Q?VJGFzKEwtybBHcRbPIOi88FlbUm42doBuOIcUZqGZn1rawJVWZmokgqWNExG?=
 =?us-ascii?Q?fc3Fsfm27mtES1gajcDa+UtNtTUUqF7+M5CvuBhr7mJ0n40MY95a4sNCpUaY?=
 =?us-ascii?Q?rj+lCmPNsOAmUnaEAfIo0MLErl0y9JrQAz+UNCvpW3f/4bjwKnCpOlCfyZkX?=
 =?us-ascii?Q?5EY4z70l5ccBh3Cji0aBIoLX4jSYgbQst92rUEk7/2LwsXmg9kE+p1u8JjrY?=
 =?us-ascii?Q?QPGezOOMwIWjSZ2RMVlOITYF56FS2c2FgNhBI5UIyY1UuKjAO+cpA/Lpktby?=
 =?us-ascii?Q?/NKT7ZJUmTvhqiZqfbW5eKfkiP7WA54uDZuLW582lA6bX/DfBNeO1YWxOTXX?=
 =?us-ascii?Q?/mpzwmtjqMxKPhOwU3M3YziJDTrXiuZnEzzCz45kAYMzULy4YWl2uZsLPNOi?=
 =?us-ascii?Q?JgTmeqFsK9W3RYQuadIwCLpQ3xU9OFmDbwVL86ptsxMiEwLBXob2WOjugqZa?=
 =?us-ascii?Q?qeN+auqo5Lbp/IYNiQKUL14O2/DEZ62NU/GSkrOTeHrAS+Wk2+4vkHrzBmY3?=
 =?us-ascii?Q?1hZ2uPyjxV7vBzPN28dW8Mav0hR+zJ4hkLgfjhPOIXZkEsB8V2wkoV5D8fJK?=
 =?us-ascii?Q?Ce/1UEJzuSxP66qdyWE3cSMZBNeikLYmM9wUVkayVImpWhDU1w9jBG3GW5uw?=
 =?us-ascii?Q?C8NKAV4wW96AuyLY5ezEx6f92cPFHqyNZ4EYpApknuSXUxWrEEDJsymdkqbE?=
 =?us-ascii?Q?k0kaAAx+5woGnFhcUOsu1/RSNI7vk2UUUeToWPiVVllUwmm1y8YWfi+3+/K3?=
 =?us-ascii?Q?qxe2RAoP58ooJzohLwM7vNAit1m4AaL5LWT0YRp7NzIi9h2L3yBvWtPuIl7Y?=
 =?us-ascii?Q?DuU3CQqei0AsgXlnkbMp9UxHjU/VZlUz2gtNbddWgOBns6HC9mOFNJqOg0Te?=
 =?us-ascii?Q?Y6ZNeFTqaIfGYEab7HzW5dOQ5P9YORptBTJmo2K4e1RMzzatuPRJwwFdSWXV?=
 =?us-ascii?Q?yI4X0t9tfdtxrZ7m5zyMsUTXLQ9yytm0MExrm7c/U9yW4JivaCkF3nQep+2h?=
 =?us-ascii?Q?nQTHu1IBFp4p08y/QsJfkXmxGd1AIAckKZclQlD9yUarK9dsPD2xED6Mjp7w?=
 =?us-ascii?Q?wku2dfq3rgiMedHqH7ToEa3Se7a7eooh5vhdPn/K75YWQ7jY2m8nghdts2Gx?=
 =?us-ascii?Q?JoCvKX+iRpALvg2Z+w8HEymGbS4bb8QwhlK5vmEsNxrEnvWazwsSXYLIKGvx?=
 =?us-ascii?Q?LK+tTtsCz/NZTOS9gOhrjdap/D+HZIVIelFBF/vYKyIHdXbvZQGGcm49Qb6b?=
 =?us-ascii?Q?dwPQKsb/1YsQguki3Ek4EqP2IrmfWKUuToQPOkoJjezPrndGEEjjN1/uz1oX?=
 =?us-ascii?Q?huJIX0yqllshDqBPlj2U9EIIvy8KHwR8HKFEaTOnECvny8czsNmGrj/DykLM?=
 =?us-ascii?Q?StpR9X9Kb6VZWVP7+LSooG3CbnY7VoFfUVGe9VVzkBi7zCfg6lTaulShkwgL?=
 =?us-ascii?Q?ckcdgjCpnoNQWcZVAextJWxsRqQLdr3gDoiIRJT8cVqPW9Ex9SdkMOeJuHSy?=
 =?us-ascii?Q?Z0GwrVnm04DkU5wlMLUGQtGVeUuIQpIC3j27q6zC1U2ypdLC47uXoyiq6JYP?=
 =?us-ascii?Q?fQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fc25831c-8641-4aef-eb86-08dd81d595e9
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2025 19:40:50.1073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qTUB6XFhLa8gLp5GBKLQB8ULtFxWaZWVmiufHlslaIE29hltGLg9g1Lg3GosYyL9Vsathprj+G94gRBuA0IdmvDpX5ShmpVXznGroOeqrV4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5108
X-OriginatorOrg: intel.com

Dan Williams wrote:
[..]
> I think it is solvable and avoids continuing to stress the kernel
> command line interface where ACPI can takeover. At a minimum confirm
> whether amending initrds is a non-starter in your environment.

When I say "it is solvable" I am specifically referring to tweaks to the
NFIT driver to get it to operate without an ACPI0012 device or otherwise
tweak the table injection code to automate adding an ACPI0012 device
when an ACPI NFIT is injected.
