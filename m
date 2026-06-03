Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5DEC188CC9
	for <nvdimm@lists.linux.dev>; Wed,  3 Jun 2026 00:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780445624; cv=fail; b=QnZEgDIbXUsA6bWvZqGvao4zGVTWSA6wsooREFYIOoDVATqriaLzFki4V7jvjh0igze0olN+dJDscNiiK1JlwFVaLXxf0+Vuau4G7eQI2t3SZKVu6llXCeHVWXX0jlkIioPcmKtsD9pRioL+KOC5GaizDDNXPrxs7U5dE5Dl6rs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780445624; c=relaxed/simple;
	bh=R6go0oli1HXCfefIohTm2axjWwROVw4W1vkovxDUFwk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=trhVLiBL2ece2jgpqWpL51ajTlOouazJBtwImCdH17icd1iuRhkKwyWNPZT1WageW8QrPAgGdGXcHejPp5qbMf/olpHiepc/KkoIr0wlWygR20Oef+stH93O8gVZn90Deidq9h7/6SmjIlFtI7m2Ann1SU4CaGIbv2kCQLH3M5o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lA98wtVO; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lA98wtVO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780445622; x=1811981622;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=R6go0oli1HXCfefIohTm2axjWwROVw4W1vkovxDUFwk=;
  b=lA98wtVOIRipHZktegbo7P2U3DJiHiU06AMEkWJdD6DgS/B50eMFTwoG
   4Edynk1gv/LyEHPzfHRqYryDwUEoU0v8M7/Nvg85Pt+M6ZdRLji6iD3tc
   iHs9Bqf6zw9cLgU/UFHF1pbEILQi+IB5lvRN56qBNGbGiT0+KzLDEBDPs
   CP2NnA2NxYSvUOcxBHciF2mPQVyDTfADGcHGTb5wnyd2MvWy2ydNWjHyh
   uYPK7Ok3bLVC7blX8gd2JqjoLf8/rIQLb9xkD5ZtwILzMwhiYYlt0VAW/
   FU0bLiL30ugWXMtx81XczMYWLMDo5q5m+BU00Sv3thRaCaaP6PB6JBJNR
   A==;
X-CSE-ConnectionGUID: iJ03g2k1Qo2g/p8cbXipoQ==
X-CSE-MsgGUID: Ff2dt7pQSvCnW1qYoUpYQQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11805"; a="80274602"
X-IronPort-AV: E=Sophos;i="6.24,184,1774335600"; 
   d="scan'208";a="80274602"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 17:13:41 -0700
X-CSE-ConnectionGUID: lWv5mUsETE6UfZj6FHxYVw==
X-CSE-MsgGUID: op6JEW8EQzWVgiymzBmgDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,184,1774335600"; 
   d="scan'208";a="282168918"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 17:13:41 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 2 Jun 2026 17:13:40 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 2 Jun 2026 17:13:40 -0700
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.65) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 2 Jun 2026 17:13:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gRf9jYKo7LOF/dY3bxL+OL14AxJ51K+fRPElWuh0LoMoDyBO4I9OrRTxllIV1IlNBfR57fSGf2zWgOl+tkEDGTTYd7o9i9R9JtjUt5OSo5EEqn5gPyKBPj9kWoiOBiHVN0ZmIF4o59uPMsMT9GnRdgzHPpoZxMJ0/UYfzStohG7MJwBQ1XZ2JicTQFfyHgdQNF7JdmHFOGWRNlde47X8dBwJsscjCPuOZG4kx5ph2hr3m2bU+yEw73xz/JWe042IPKT24e48ZHph814aQe0Iy0sJgA/2IlvnPTZI0Dygz66wdY5HjxcCSLvikXjxSn6rdXwrR3i7i4OYdHo+OEB9tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pzQlbDWPcJFED161Mj5i/vp2dOvYz4xXsCQYVqu7mNE=;
 b=mc4jl0JLwCgUsfyQ6wL/uULvDXj3Zo0+MCjpCCgm1cbLKJpEooT6Jywst1UbINENW8sSdyp+jlxUYDIL2xLzQiexON2HW5uVFi2XrT8qbwmYW3JjcEObYt6wDf4Pt8TP10nsPx2kv5L3OC48yT3YvdP1bKxvE6rXSQ6dPyjEeyckvBsrEhXd8OrEDr475l5BerZAKBy09t/VKJ/4E9ciyvG9KzQS9fG3wnjA7TYst8yQaYT1vP4AhX3dhvQynxV3DoNqoQ3MfnPhWrANG8uE5OJ00D5lTs9eKGW7HCi2U7lYNRjVTnhf69/b3Ne2EeStlxeS4HCCieM/6NiTEWfaTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SA3PR11MB9511.namprd11.prod.outlook.com (2603:10b6:806:47e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.13; Wed, 3 Jun 2026
 00:13:34 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%4]) with mapi id 15.21.0092.006; Wed, 3 Jun 2026
 00:13:34 +0000
Date: Tue, 2 Jun 2026 17:13:30 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: John Groves <john@jagalactic.com>
CC: John Groves <John@groves.net>, Dan Williams <djbw@kernel.org>, John Groves
	<jgroves@micron.com>, Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang
	<dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara
	<jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner
	<brauner@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Ira Weiny
	<iweiny@kernel.org>, Jonathan Cameron <jic23@kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V3 3/9] dax/fsdev: clear vmemmap_shift when binding
 static pgmap
Message-ID: <ah9xqkq39VZzyNtF@aschofie-mobl2.lan>
References: <0100019e79caead2-5795328c-af48-4a93-b147-c11df7446e1a-000000@email.amazonses.com>
 <20260530165045.6636-1-john@jagalactic.com>
 <0100019e79cba76d-76fe26ff-33d2-4842-8eee-bd108eae6990-000000@email.amazonses.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0100019e79cba76d-76fe26ff-33d2-4842-8eee-bd108eae6990-000000@email.amazonses.com>
X-ClientProxiedBy: SJ0PR13CA0137.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::22) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SA3PR11MB9511:EE_
X-MS-Office365-Filtering-Correlation-Id: b10410bf-10f6-4913-8982-08dec104f38b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|11063799006|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: gSy4RW7RxeZwKYNd8dN4FBY7uIpCbsZCEyzT692R8bmE0IfNIke4tby1uSUh5S8T6OC9Dij2UyFMOq1utDZ4pYE152pFRqFqrDPD2iNbmIp+HnphbjuepBfaX8sjtfFkiaCPq6aKtQx5asqwcHAzvlMP5RkX+lYVJaiyRSAg3OvjjNfsXOmobfL9+dUpX8aR/71crPzZcGIKPMThVMTGfGhehj97HlHBOq/TKmpFdQ5UhRDpgQ1OQhD6lVMCnYoCK5RtVx0LboHLIEWXBiDRGutbFLL2kzhJqVXPO1cHofCNIA0PsZh+t9QXvNxNaNvNI3tvDyzNlNgwc4qKhD3Fi2AqMi0cEBeVFKyvviWyGfk9AkubclwOlNBK9TbINPnQFbOxTj69wARc6cacK2VD4IEKnrU29vTY1klfPLm6FdHfp1xqoNnaNZmpfPvye0mYCubOkeuIP49dXXBbYaRzhwHMNhB/oxuaiIpRrKkYGzMFlL5atUdaYybWtZm7RsmhypVG0zfo51yMuKI1qIO5d7ZKeRaNLkr1qAPWntimmY/4DMDdEVdSThXN3YKCs3W5uLb2jt4jS6ABCz9Smlg9wjTEJbsx3+QyGp/2c6+jOpHZwunNsuX8t2Zn5HhDShY3GyJhAAWNh4yhTF/dRnp3yr6m1Mk9RCyLcrtDkNT0gK2zYpTnBKrbws04mY0/ejeK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Il+iJEWMQ8PIoaRPRWRFcNihEQg/pTKeESc8tj+30B0/PaWPsjeubvTEzxSZ?=
 =?us-ascii?Q?3JOJvsT3A68z4wFbp1i3YtFpSKCwhpNVUd+hnIFCZ5S/tMT/CFBlTuqFLWNN?=
 =?us-ascii?Q?YFbWLVZsYS7pEzN7HnsByLOhjBiERy1vTtUjULdU/sqLv6lcZSJDVJZ834nh?=
 =?us-ascii?Q?UbN9tjaARaDyJRGfQpMn3xKDBhz8MlfNmpzsJtyTyVyOiJmgBzNjPa2VaH+L?=
 =?us-ascii?Q?4/XSdlhq84eixxRdIf1rKgf2gQ0OkukmFq00HQhMgLFIaTVt1r5eHI/p2qnE?=
 =?us-ascii?Q?6wfCZOAmj4qJ97mpnc1RH2F6qR63SIJtodkh2oz1UMml2KiySUEG/y97OKU7?=
 =?us-ascii?Q?HusXR9DEs8p3acWCR+bGz4hIuORgXM5tcH9RJs3Bz3W80oRR9lxZBPj1x1v2?=
 =?us-ascii?Q?slrSrgUh5wf6H8jSJPWLUD1Cew6M7Qlo7ixz/+EbzZPuvBuJF9tWlZ0K9bTG?=
 =?us-ascii?Q?ITIlU/sWQJn6ndpl/zQ9HX2XB7OC7lnSNRubq/JShcYjLZxVsPbpc5ijS4cl?=
 =?us-ascii?Q?qdhv1N8JiGhVx5dpKMwKeH3qdQApyUZsa3UvHnxcw9ubtmUZZGl3YCNDt6hF?=
 =?us-ascii?Q?i1RFQMq/2FTTDbZMiKL6ZYWLp8Fctm1rW+TPLCsJaZs4UXJCvSgXPkWGP+Uy?=
 =?us-ascii?Q?+lPE5Wk1iWjQu1e9HUrdH1/A5pnuioetDcjkf1AUK9T+OYahQJDJMxnkp0EE?=
 =?us-ascii?Q?7shMhnhziOicqE0Qeq3tDg1K1VH2bsVn0FUx7L5bEqX9WXbwnz+gChZCOqyX?=
 =?us-ascii?Q?SmC19CRJeLfkI/bDBZ0S99PAYmqVAFX87VB3tT+SUfm9Mwq27PGr2oaK76Nt?=
 =?us-ascii?Q?I5lhzx7Zh56272QU8OYtqdn4bKemTElB8Gy7ZIwHzT1E/Z74QuSzI3MMA8uo?=
 =?us-ascii?Q?xN4oIo6wYxOHDtbev0s96ZEtQcOHg4Qymb1krO4uhW5owSS9jNaHKweyiLbZ?=
 =?us-ascii?Q?WqhTQ6NR6w4mQ5JnnZ9dL4qyLpxALgMvHYRBuC2kfblybXO1wjJ2bdPuZ1ML?=
 =?us-ascii?Q?tZbv8R4FZVdSbKIblVZ4Wgi//wx9KNO9aQ/nybsalqRbxCzmdcR2L6HgbMvx?=
 =?us-ascii?Q?jJcag+VYD0C6oXtU37DL+UJTikhvu/y3EAYNYiaSl1ydX4KbYRE4/tgBX86b?=
 =?us-ascii?Q?OAuWsGG5MGAxHRcQE0l5hl4lzYU4P4Vx0/hC+2+QE8oKsAIoLmsMXbtc0YLm?=
 =?us-ascii?Q?Ou3Cjh+DvZMBUWV9KaqEtQHyxZH0JuqlzNupTixQfAUEop3ZbunbonMS2rcK?=
 =?us-ascii?Q?YSP2/72MOoo8XypV1GnRLQ/wDrjqfTBumQkTEc2TFs/9+lSehCRLAvos8Jnd?=
 =?us-ascii?Q?B1lm1tleGuI2UfYjhCGq8mcbiKhijoln6RQ0x3j7nBrcEeT0rptWRJwKHZKC?=
 =?us-ascii?Q?l3axKnQRX1F4s2sJiz+9OCfM3wgPOn1Xj0UapL39QujwIVpoUfAjA4NFzemq?=
 =?us-ascii?Q?rlF5/MNKC/FNMY1FX5ntCX0rNDzrRGh9pPnJo1cbQWoxWP0zpH7boQKmDt+5?=
 =?us-ascii?Q?99K3R3QSGdzdWd3Wa6rZoVsHJhUQqJXZvgVLXEj1dXbqFwzcEzEW5IvSwisI?=
 =?us-ascii?Q?5Z3tRxxfWVmQeCak0mymk9NIO6Je6ODVpNhBnzvQYphp+CIVyUnRcq2CVFvI?=
 =?us-ascii?Q?vp/7t6i3cbYbL5Gkjkc1ahyytU+T0IRnyE05muOYzIHctJ/NdMAG7GQyTNAK?=
 =?us-ascii?Q?2MsDWteDsvgLuKqhfcCw+lTJmg6xOulOQzyR13s+2YaO7XmJSK4Zh6wkIqYy?=
 =?us-ascii?Q?RDdStc2It3dqN0nkw1uUCZn3D5buPSg=3D?=
X-Exchange-RoutingPolicyChecked: At4QBQIzdNQSuFzr3i0hulIhHWXFX8W3zQIw9cZuxhj9vjkyngjxOvhQpw4pzEuRPCmbLhbNSANW+RzXJPVZCtKw7fIEr8e418sATnFdpvg2Bkha9V3IXN9AlQHLwknwdJOaQ4TivTWmr8H5nJcCcRCLN/7JqsWel8gO9mWEeB/uWf6xuKz7/K1YaX58yO2RfpqekWzAxCDDR9mPgy9x83/MWrURLJDiEmdOCwfxyn5jNVwi2b2TRNDddJ6UocST9bVPrf/vGwYJ+Pk7HSWbCmOhDarScpHABSjSGWHzHhBsRQi+lpIkvpHsP/raVU7TGQD0agw+g5+JVxkwXahumA==
X-MS-Exchange-CrossTenant-Network-Message-Id: b10410bf-10f6-4913-8982-08dec104f38b
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2026 00:13:34.4363
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8g5bp0m7xAHPVAWrovy+wc3ie2sLz3zU91wzqLPm/boFZD+2HXhRhhS7PDr/yXsFfGp98sI98ZkK5hWntbPr5mvO5fw6YmVnuNnjpQf+3B8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB9511
X-OriginatorOrg: intel.com

On Sat, May 30, 2026 at 04:50:50PM +0000, John Groves wrote:
> From: John Groves <John@Groves.net>
> 
> Clear pgmap->vmemmap_shift for static DAX devices. When rebinding a static
> device from device_dax (which may set vmemmap_shift based on alignment) to
> fsdev_dax, the stale vmemmap_shift persists on the shared pgmap. Explicitly
> zero it before devm_memremap_pages() so the vmemmap is built for order-0
> folios as fsdev requires.
> 
> Fixes: d5406bd458b0a ("dax: add fsdev.c driver for fs-dax on character dax")
> Signed-off-by: John Groves <john@groves.net>
> ---

Reviewed-by: Alison Schofield <alison.schofield@intel.com>

