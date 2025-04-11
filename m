Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B825D28F948
	for <nvdimm@lists.linux.dev>; Fri, 11 Apr 2025 20:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744404848; cv=fail; b=QOuKFHSoKooShOrRI7p+QvrDYoM6+iQYMUWiqbJyRpJQxeRats5CHtoguP0Ae7hDoCBEVU0XT2PB3FvlPpU3Ka+YKDm35ObCetLW0B71o2J4bvZ2ynDyjiWvITh5TkoPizP8ojhiGNvz1rpLFmCBR90h/wzWNUHUqNxqAVIVoh8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744404848; c=relaxed/simple;
	bh=ffN+WA363q706VxYSZuaSNXJTPHQ9rhr8cUAyX2HDoo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Onths7l008XnwZryUvHoKvynFVNbEWBDHXjpQ0CU/Bn3PugCdmyoGDtJ8HvP4s74+ATKNhabGg5dSogpAYZCyy10RnFTtAVCcaZf3YyHgkYu1X3GFJPyruuo0I1dwWvw4Rmr3q43BSUtHBWw/IqeqhQk3rKSykHRhBPjur0BM9g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A08RkMNo; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A08RkMNo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744404847; x=1775940847;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ffN+WA363q706VxYSZuaSNXJTPHQ9rhr8cUAyX2HDoo=;
  b=A08RkMNopyDPF9lU8hX/mU3QdLiXkfQ49OL0xIlfc6Q2KUpXCBUMJeP5
   GnB5HE0qlK0Gi0ThK+I4pUpS6luiqTebm22gH+Z57QDaGWwT5iM6QpcHk
   g5U3EJFWsoVcI29Zr80kNsfnDqTfCbbPQK1ZB/WfXQIrBQxPVMNxvJcN3
   XeJvA6SLFZVrtM2yGXn0s08EAicc3Xph0JzpsRiioRVBT4c8hQyoUwxOx
   1GdPcvnxkT8j7ws7PQulTYBjrYeFXz7i0KDi8HxQ4eJr5D3A/1VHHMDB1
   +67mzGqg6VxvXBYuygvhAZs3acJPd+aS0a0DaxmTObGAeNGJvDsgPrEnv
   w==;
X-CSE-ConnectionGUID: FDxW/+hERMa2kCW90a73zg==
X-CSE-MsgGUID: LaocA1VXRfuDknHX+mAnow==
X-IronPort-AV: E=McAfee;i="6700,10204,11401"; a="48672414"
X-IronPort-AV: E=Sophos;i="6.15,206,1739865600"; 
   d="scan'208";a="48672414"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2025 13:54:06 -0700
X-CSE-ConnectionGUID: ssbH5pnLSMa6lii17vToyA==
X-CSE-MsgGUID: 0ZYFReoxSnyhe9NYxYDsLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,206,1739865600"; 
   d="scan'208";a="130277693"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2025 13:54:06 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 11 Apr 2025 13:54:05 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 11 Apr 2025 13:54:05 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 11 Apr 2025 13:54:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=avggFJHPjMly2btu5X/Pefiv/nxYB34CXNDP6n9Mv3GG8FgSwx6s0VBNiMD52AMBM2IBocFN16wdQmh+Lxa2Buala5wUU/k9QwOQLhvKnJeFMA9OoUFTGgzGcCNsDQUzttZlPOakVgdzyiT55i5WPhusRiieUoKZY+t06FiBT2Een2GhHvOA/3JV0PycK8KHOMwJilvXoFqhUna8N+SFVGFLS3jthkDlpV5xhP4Rb6lO4qbodY6JF45dd+qqJsX0O8+u6bs7Ivem4SVWPx9dNvL7+fFMr5OErvmDmBZSK7re6az+sJ3o1yzpKbgPJHvnzOUq5Ozoa8Tsh3HNapdldg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gpw34Y7aZDT6DIl1OF73ADN972jHKb7CnY2PmJorye4=;
 b=Fjt5asB69cUBcCohCKSn7KpUWHdXjqhTelzodCX3Edbw8M/Fwh8/zpztPh+h1iLoircKqepRqQT93cDceiInpogfhysvFbQmCHWJImiUWhmahhVAe4aIVgzj32Gw+fqUAehXbxMeKaGAlXsdvwybgTinPSNqAgVh7LgXZA46Ggk+HsJ6yn+a1fz32rdfqV9cdUpdi4ES/LkBVDgElRxQPnycjuBGuWrxYIIZBpNglj5dtChnMlaH4LR71SNx68Wq3xa0tB0Ehy7kwsgxK61slnjH/j8wms1xoRaSC7GYcBCXYs1qZEg+6YZXmlMeLvxef0C77pK7EUgZ/m21wqHW+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB8794.namprd11.prod.outlook.com (2603:10b6:806:46a::5)
 by MW5PR11MB5858.namprd11.prod.outlook.com (2603:10b6:303:193::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.29; Fri, 11 Apr
 2025 20:53:22 +0000
Received: from SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720]) by SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720%5]) with mapi id 15.20.8632.025; Fri, 11 Apr 2025
 20:53:22 +0000
Date: Fri, 11 Apr 2025 13:53:12 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>
Subject: Re: [NDCTL PATCH v5 2/3] cxl: Enumerate major/minor of FWCTL char
 device
Message-ID: <Z_mBOJVF75TEKqRU@aschofie-mobl2.lan>
References: <20250411184831.2367464-1-dave.jiang@intel.com>
 <20250411184831.2367464-3-dave.jiang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250411184831.2367464-3-dave.jiang@intel.com>
X-ClientProxiedBy: MW4PR04CA0328.namprd04.prod.outlook.com
 (2603:10b6:303:82::33) To SA1PR11MB8794.namprd11.prod.outlook.com
 (2603:10b6:806:46a::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB8794:EE_|MW5PR11MB5858:EE_
X-MS-Office365-Filtering-Correlation-Id: 77a86ee6-66b9-492c-1353-08dd793ae54c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?JW1BCPrrSD8ZEK3Q1zLJkLOrfMMA5LUm8rXtpH3SHIil1q35EJGGRp+XMq8S?=
 =?us-ascii?Q?4+iXzM/791UAc5xxqD0cj8R6OillZfdNTGuUBxCQE+Dhe39bXZQQnzOfMh6I?=
 =?us-ascii?Q?Lq+HAq77VcsAnVfDn+6EkJWB6OSW+GQQypveO9wN1qf9pWK+rFyldEE21+hS?=
 =?us-ascii?Q?b7KhtDWZfR4FzNNbju2Uj2v5chgTmJkZPiNPAjMaja071u4t5TFhYr0FggdS?=
 =?us-ascii?Q?Fb657BpkB0CBnwnkWQ7+txWgLDsB2QSRJLg7iBGkmnf2kbQPDdUoRXwjqEs4?=
 =?us-ascii?Q?PkXctf+bQX83KAmgpCl7owoAEwcJyLZKt4RiToTktSfd+Pnz9uyv0Oh/jDA1?=
 =?us-ascii?Q?1WMP8ELxDTW3pq7DmgoWlOGAeC/l6ZEhp4SdjPX+Pw40a6pYO6bC7HUi2tro?=
 =?us-ascii?Q?4DHxaQd7WJVr4qzBA+Ar+qvvVfbXONGYDKVShrk1XHBb9dLT3r57MB8JVBYi?=
 =?us-ascii?Q?v/xLk2cqKTiBZtsa5+aors1a+dIggR4TGKTCDLjHbP9fYCQiAHiN93Cj023L?=
 =?us-ascii?Q?1cVIDRQbtuqwA8GfPdHrrMxUdB5EknMeIrPW6LDKp8BM0XZPoC0xxMiPloxT?=
 =?us-ascii?Q?pcLrpJhVydLbpjBMQUmVCjPPSIOGnKSt+QXgc+4lvOZqiuCxwGikPmbAF048?=
 =?us-ascii?Q?HBOALH4qhLjPOQc6FWny4J/JlX0AqjjwVaSNgzPxYa2r00iFPeeNCLjNQRQP?=
 =?us-ascii?Q?T7l7n8K6ussFZWvpkc5/V32MmIMPknBmI7+Qsa2qOJ7TZgKaq9Qdqv2pzy6I?=
 =?us-ascii?Q?GKJ8FH54Hc3CplZVp2Yx3SzQWlyTYUJ7NKV9k6oTf19l1AlpqVmaXtygRrIM?=
 =?us-ascii?Q?RJydCNfLovRKsMD50o2y388CyV51BpLVQs+7V9yO/JYArrof8zuoPGIYjRuK?=
 =?us-ascii?Q?cIuIklA2c90qvp7X4AASxXK+xSyhTk1MOxLKXuGbuj594N1xKF5ZRxEU6eId?=
 =?us-ascii?Q?3c8tQzF9iTwBc2ScsRe75BH60mrd3ladSBE6ou3DUkZXnZE873jyuOLs2YMe?=
 =?us-ascii?Q?jGC1f5oT5Mojv3eaZa6T2m6sFm6OwQrTBOuNN8rozFKMCUrQBVNyMpee7w18?=
 =?us-ascii?Q?ZkPjw+aim56gHnf4WfFtAFlkFqN5G5j2YWiMuAwFb+7UexjKqpW2YTDR65AB?=
 =?us-ascii?Q?bBOAmMA/ZnN27SUr5I808fqxC0bSyW/DMxdLG3P1ifGmnKhmp88Hy4sscMyY?=
 =?us-ascii?Q?YI3s4BodB6hHaoI7n8AcWJaYzWRMnxXJDaofSqeax+AzMXiuXYbS/fKAIjTD?=
 =?us-ascii?Q?rKeY3erokpyneCrZugFS0T13UrmCFA25WQlP9DUihrtTWscyJ1Z7T0kk/4pZ?=
 =?us-ascii?Q?qB56IO7XLkZiFvEQJO1+gdPlF9voF6lm2XqS+k5ZV5u+CyknZIQ5NMh5aC/9?=
 =?us-ascii?Q?iWdczFqgOPxXoWRMosy95GPs8QE0sa7XJFjzFpXcE3YwOjEe3s8+2uEvvwGz?=
 =?us-ascii?Q?uMsBx6IY76o=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB8794.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?erJ3KsHWKwg0gI0drigsRmHOlKavgTFzlOOEF5tBGD/A3ak6zK2EWg4U5sr8?=
 =?us-ascii?Q?eokcP0YuBGCIkjR3QCzRhydYE24PEk8lne7S+THPiRtVpfZoKPd6c8uhDjfn?=
 =?us-ascii?Q?nDOni30GexoI3UVHmQtWz7e5az6iWUeak7lZNMUsrt8IdiB3UDuDYaDXcKGh?=
 =?us-ascii?Q?9xKId8MgmIZC/U3awitLMVsVJ17iHIHy+CUsMXbZP8JyuZ1JtH2Vzxqua1l7?=
 =?us-ascii?Q?3ALPMIjtfWVjECqttdajV1EEqCABciXmNfKq7wLm2nFXRbE/YEXh5bmz0BK7?=
 =?us-ascii?Q?uxNGMhm7pGGJ19PAAymgN6sA1ukO8Jwe6Jx+W8606W29q5XQ5r/lOZ5E1r/G?=
 =?us-ascii?Q?xBFbUeVU4yrfDU5XBxC78/inb0rEnsxtkpOrmnuX1TKTz2mb0nNWeQcoe2Oe?=
 =?us-ascii?Q?krjHiNoKcvbmi2ZElcGkpOJcSLmYkUpXFOTP34N5RpI8QoqCLP4NDhQMxefx?=
 =?us-ascii?Q?RQD1Bvyj3MTu2keEA/2/+ebrj1m/rM0sUuIhfekn/wrgqiUp3kAHoSMN6Grr?=
 =?us-ascii?Q?g11RfifET5RiU+7IFPXX960ugf0ADe7I6jnNtQveQ7+QtQ1i8YpzR3+xmE+O?=
 =?us-ascii?Q?b6NdQ0xZmWKqWjD7fpq7tj6AuyfhVI1IuPuq8gebZT0A2ySV8aVrExRYM1E3?=
 =?us-ascii?Q?+19MQVSftN1N6ADKSr0i5eSBGMfW7Rt2ng7GzSnC4/Uqd5cMWzyRdfR8hEQc?=
 =?us-ascii?Q?l0U4phdHrj6NqORHApyh2jGvIX374uEyMNy2C2lp2N9Xleu3FvD2il98sCi4?=
 =?us-ascii?Q?3wvdblEbsGByeUwv8JP0EHjVPRd14snjGV91po1xQlkiK0ub+TAA8WH39pXQ?=
 =?us-ascii?Q?i5dYFfuYlquQKeadpy+I14+Lv7EdKz7/mvfW2efKoQe3289QTonHMGD9PbBx?=
 =?us-ascii?Q?xmuw5dDl8SIgyTRRDZyl31OyCvFwvIGq/kKDOuiV384P+SaVOa17O+ZUVibe?=
 =?us-ascii?Q?Htzdp1dnKIG8Bjt43co1+oOWPbCTP4DUjM0SXUxRBQY4rSA77tBGXEAZmbyk?=
 =?us-ascii?Q?bt7Lex9xk8YJdXl4d7lzKt/gadgLwFCIma4nsDJ94EKuOGpOJjFKcx9CjH7J?=
 =?us-ascii?Q?sSTB2rTkn81wAw+/6/VHfqfyiYxHTj2cagPO8erGoVbJPIlUBrVgASZDULhm?=
 =?us-ascii?Q?jNEx7VLU0BFOkYpjiiWnCJCU86tuGfLiDIaxtS0vdm0wfj3umMpvfBoCJi4A?=
 =?us-ascii?Q?8VO+hyhujkISHrBMRZA3in9ocjHATMiPh4giPXYrw3+97crx+U/eTCy43TEr?=
 =?us-ascii?Q?NcVF0iyuk8cOFP+o28VLeDUEASnVT5ERRFci+QOdrDGHILt1KvTUUZvkDq8l?=
 =?us-ascii?Q?aQK8ue0yDY5TNYDysTzhCft/SEGUQdgnldR0hWOEJdvHJco/J1wKKFExbAcK?=
 =?us-ascii?Q?abiBfSJFV3wleuCABexiyP7VOyOY47oNiXo91IUuGMjek+nPtOKzGh/wnJvy?=
 =?us-ascii?Q?pSBRn30LMsgPQwlikOZplCAsh6l4N8YatFeXDw7yNZQbEyJrygqYPg9YKLxj?=
 =?us-ascii?Q?V816dI63P1DFtFW4cfATfEhjBpjddzMDQROF4s4aH9evkA5sx2hOuVhfacKC?=
 =?us-ascii?Q?k/sFExl5JdhAxIH2F1myf2PY4NNF1b6u4Vn88V8b9C8KVY2y75vSG3vM/mBi?=
 =?us-ascii?Q?jQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 77a86ee6-66b9-492c-1353-08dd793ae54c
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB8794.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2025 20:53:22.0199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0oAE/15Wn+cdMNo2OU3TufbMGOJw9P2gOC82JVoOFNHALz5JEktwUI56nsW0KoZAVbgsJ1Z5VjbzWk5n0CnKt2Wqi8P2K6OMuy1nS1efO9k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5858
X-OriginatorOrg: intel.com

On Fri, Apr 11, 2025 at 11:47:36AM -0700, Dave Jiang wrote:

big snip...

> +	char path[CXL_PATH_MAX];

A bit of minutiae, not directly related to your patch-

I see:
ndctl keys code, (ndctl/key.s,load-keys) simply use the PATH_MAX which
I believe comes from limits.h

The rest of ndctl is doing the calloc'ing, like you originally had it.
(~/git/ndctl$ git grep char | grep alloc)

Is it not safe, or is it wasterful, to make all use PATH_MAX?
Would it be safe-er to make all use a NDCTL_PATH_MAX?

This may be worth tidying up but not clear which way to go.

snip

