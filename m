Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B5E21ABC9
	for <nvdimm@lists.linux.dev>; Fri, 19 Dec 2025 04:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766119984; cv=fail; b=jvXSZxYcjEoAXfRP3pUdkQFaJY30ctM9Vgu+p7THoklh0n38Yzm8UmZrOLDa+R1kSvfWUaoeY02ki+LT0bQ+DM14bQCfLM6WegPuS3CAXioJO4UtKa05mPJ/j6gCKA7yg46Dj+dl2lyk66xdQexmoyxbDk3L9BjUqL9lfipXFyc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766119984; c=relaxed/simple;
	bh=PGvtv2sddHndY6hrHUm+drFbTfvYvz+m9Z/ikUgMH1U=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=uagG6dVzP9t82dEvEe5vwqjh7TliKyNpiovdhBQot9pMUCCAtdMtKk1ilmc+Z3eY4XRl1l6Zrzl5spY8zxPNac+IeKAOyyjPU0nA3tJ611PI+nwVcyEnpq0HOwsLbebgrTKWuC31gMvUXkykMpIBzQpZWEITAObZeLR3KNNFNfo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EStSajbI; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EStSajbI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766119980; x=1797655980;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=PGvtv2sddHndY6hrHUm+drFbTfvYvz+m9Z/ikUgMH1U=;
  b=EStSajbIIXI+OU3slDLSBjhcpXW7cQCAjTGCBluCG/xPCiUdkqvZ7fCV
   Rp3sH8Z/TtWO36LoM7Igo1fCNvasrUURmh394V+VwAIFt7mRFjR8HOzDd
   Y8b5PlPgujs7U3konC8mZmh/a0jmKygSbU80h2ZIl3YtOLCWap2LDmINM
   Sjo3ggh8vqk7WT6a8/3VNTFo1qLNt8dSbZbBCS9ib2SsewK44sXpra/U5
   yBGHfZAyut7OqaCeULwcTqz9kniXXkSsEzw/FBlC5eDE7m8x/l92QM4xP
   9ztmjwn6objMOQo+pqjRVpMwL4MZE7ibGfEFDYZ1TnBOmKSEUh4TRZV0O
   A==;
X-CSE-ConnectionGUID: gjDkqfFMSFCzlLTY5UjcYQ==
X-CSE-MsgGUID: q+cbadcwR/mRA/ZBflNCXA==
X-IronPort-AV: E=McAfee;i="6800,10657,11646"; a="79202815"
X-IronPort-AV: E=Sophos;i="6.21,159,1763452800"; 
   d="scan'208";a="79202815"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2025 20:52:59 -0800
X-CSE-ConnectionGUID: OvgzgplnTDWjlk36UAkttA==
X-CSE-MsgGUID: gxcP0w4YT/6WC9vwszDycA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,159,1763452800"; 
   d="scan'208";a="199035393"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2025 20:52:58 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 18 Dec 2025 20:52:57 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 18 Dec 2025 20:52:57 -0800
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.31) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 18 Dec 2025 20:52:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T/lQDy1hvirnEXsF1Lmjv6GRmZr5ijFLZIoh19pQWpVl1Ee08iFisO+FWJvyxhCMRJztRzSAOyHM0T99A0/oSK9MYTVEFe9Fn1p+aNlvu7W32kTZ7G/fgDozUYcLYazNBgUIcBeQxW/0CbqgcMTffI8Udkqu10lAuRmhOZSVRGDABhEo2jxeUJv147VvXgWq82y78f4zrjWWCWBwZ37GuVxqMwS1+7kYIHc8gIpFjScnC7RAy3VTLdiTgjez3O66SWiv91FhXVyhkquORCU763XOvquaBNdooWRfmHIedJB5Qinfg7sSyi0cixZMCy40PIVVmPGid/vImz7nkdD42g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ge78i1XeLJxqrz2dlivrly4sZP0aAFZQHHv/YvnOtVg=;
 b=VxIop6kN8ViPdKS7xhMvO0yvZaHGjJu1EnrP+pJJ5a8YTdQMewDJVNXSzBb8jFZ9r5gaWSXUdDs66Hdeo7LDVPu7PWKnFeNUDWevFb0HiznW/WMGzIAF2bU3YZvXZEcY13nBuWIQy3mnav18XYtVVkBZ2vteLJeju8LJM2cAEt/RUQnsh5gBRlBXRfAfieybMJZ1P1gXAUGdVt9Q2XeDXZD18UsIY//gFg1eglc4wU6nKxj6ivTdjP4ejuJewBDsAF1t6zqsqiUBmLjn3QqVFMxn2kr2mmpxGQHg+QHOtNE5IEMufJ7i082RgZWXWgR1xwx70OLXnxfjS9F80nz4qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by CY5PR11MB6139.namprd11.prod.outlook.com (2603:10b6:930:29::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 04:52:55 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee%8]) with mapi id 15.20.9434.009; Fri, 19 Dec 2025
 04:52:55 +0000
Date: Thu, 18 Dec 2025 20:52:48 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Ben Cheatham <Benjamin.Cheatham@amd.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>,
	<dave.jiang@intel.com>
Subject: Re: [PATCH v5 7/7] Documentation: Add docs for inject/clear-error
 commands
Message-ID: <aUTaIPvIeILjEnnI@aschofie-mobl2.lan>
References: <20251215213630.8983-1-Benjamin.Cheatham@amd.com>
 <20251215213630.8983-8-Benjamin.Cheatham@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251215213630.8983-8-Benjamin.Cheatham@amd.com>
X-ClientProxiedBy: SJ0P220CA0007.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::15) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|CY5PR11MB6139:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c57c481-662c-43ec-9eaa-08de3eba7926
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?bUE9YWnAG9t3yVy4Ur/FD2EBp3KbqBPfxQ8Wfbn7ReCGkAz0oJ4cg3dQsN2G?=
 =?us-ascii?Q?pAFfrnB/N44Tct7IG3AuDKfz/P8KzFQKxyBCG245crWgZgH6NKHtqeEKxxi7?=
 =?us-ascii?Q?wTbM+wYyI+cco0Pq0nqMvhcU8+aFLtR3FvAPBDIkeaqo66OJqqRjZH2LCSif?=
 =?us-ascii?Q?oXg2fL/OSfyzy9MvtQQh+Wd2Pl4+z2h3jR3vPOq/i/+d1fo7FJKyRbRFGCtq?=
 =?us-ascii?Q?KU4G23aMtyfrNjnPEsr4cG5x8NowpTHFuNbwCFabNzgkNPuYyflm8PX8RlO0?=
 =?us-ascii?Q?0ZAv2WE3sjpDkT5kvkok2swhtpeHIRVKs7lCrPIAyBNvd5jIbN1Rott08CUf?=
 =?us-ascii?Q?Wl/gDz1O5LaB+BMVmnXU8jWvqV+iZSk9/hm2az/24VDMJI+KuzzsGj8Fo5KR?=
 =?us-ascii?Q?tQsRuFr5bsTioVn+bZ0wcWiUL4fRgTgyPtlibka8jN02yfK4T68/YQ7Zbm+c?=
 =?us-ascii?Q?5xCrXJ1AZp2X+WAGHN8IW6mFUSVTZ4Jvc2cexWBkeFQayQz1yxE6RMEKzJXi?=
 =?us-ascii?Q?NQDLvTFUuwzBbN34OnbLiTCAlK64eajhn64WD9wO+d/CV1VBcDeClGOoPUA5?=
 =?us-ascii?Q?6AWD7oO/ot/au2qQyRZOFlKYlAEGj+tVyHQDU9OCAyiNipGRXa9kO1H5EDqx?=
 =?us-ascii?Q?7ta1aaDTOW8BAcqoM4tTxjpuNHy9YlmNPHXN2xXtcbVyqP/D83CrHp55u+Nb?=
 =?us-ascii?Q?AE9M0FJZww5rsVeMxIOYjpcOarFNKChXF0E3b5dp4mCUYUfYAo7xyjZJbMbr?=
 =?us-ascii?Q?hRB15XL6ngFwT0tmZ3TuThOEhxSVvR4+gbA3/gypW+mJEiu/dp1h4Y5U8XoA?=
 =?us-ascii?Q?BqEJjwQHxM6Htjz3S68M59vUqA/IjnDsdYQ6+GhLBzbBiidkci97TJ4iUI14?=
 =?us-ascii?Q?DUzclP1LIiQAxtdbXxM+EI5692u++TIGF1VwBxpRHI9PfpPAO9rjAcHWpvaD?=
 =?us-ascii?Q?JwY6BmTrI24pEnsDKywiVtjBwfMhDTE/NZlR6ku635Z4uSJ4GVAQiJDTTbBz?=
 =?us-ascii?Q?12SDTc0xiVTTe62BI4oVlChG9+rCBEDFov93MJHkblCOTCSclKGN0jwR5Za3?=
 =?us-ascii?Q?40RlbDBnyH6XYCs+ETFyTppwUxVz3Gnfi8jxIY9q06QciovhZiQcYCelUvJb?=
 =?us-ascii?Q?4obRYHsWqUmi3Ix345zC9mtRSfYu9XlJMJnXnkuFjCMf0pLCEIZLuj0oaTVh?=
 =?us-ascii?Q?oQdl3KWQhgXlVjT/RgfWZ+p79DiudUZqmPyO4eRIHfBmXk5XMTNQwXXhx5zm?=
 =?us-ascii?Q?v8975BOlKAA8/vy36Tts+YP5tJk8Pj1TJ1Elwlm0hwu1tYwexPsOx8g9cl4y?=
 =?us-ascii?Q?GICJbG2gdLLWXjHmQmci6FwijGPenpD9sPoWPaBxgUIMXUTKHf0ud3KaqNsa?=
 =?us-ascii?Q?9nxjd7Zf5Fakx+mq7UBwowHliN/fpe57a4+8te30FHl2IaggVw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/bEXBkTR0L4YXh7KlbqQUvK1ryfPXkFodaTOz32c/Gk8bAC4qgOfNizU0fWb?=
 =?us-ascii?Q?n9eI/I1mSWItjeMFrK0KCtdsnkKifzJgVrYC23tZ2vI4IGpHDIcw3hg0nVaX?=
 =?us-ascii?Q?meqiDfed2pTlAHXi9cu2vbJhhiAg8OtJgVVI8DoSxHHt3YHDtiHAbNzKeD6H?=
 =?us-ascii?Q?zt0FmnyfrCquviGphpsEKnbpT5Gqq2UgaTRDi3WFpdyBFUPHEmE8+BWgraE1?=
 =?us-ascii?Q?G6OvrveLqxEmf/C2yhDuHoMXWeoGA5Fvc1Ld0oK4mTaD8Dnb5QRQPA8C8CO8?=
 =?us-ascii?Q?Rhi+b0IC8nNEl+3/7+b4qBmmJS8I3qkGbeLciNc3gnS0txuyR+6yErwv+2oE?=
 =?us-ascii?Q?fdu5eFqQFxisN/f0U0pD3LsH3/4N/nDQVtBCEwchS02YRtY4s0MHNdCzSjiI?=
 =?us-ascii?Q?CmeLzkm9dR8XIjvl3LLwQfWx5sKl1wt2z3EQg/DrZch0leSXbzz8ZlnJoARg?=
 =?us-ascii?Q?J5aRb4KQyKX9k8o+jvaZ6ylRTXLtaLWBAZ6lNK84ElW/Xwxd5BjNJU+geaRu?=
 =?us-ascii?Q?ed2NMfI18i8OT8l/uNJpNVPJDcwtqXCtZl/KZqStx10VByXu7Cm0FpMg/T0F?=
 =?us-ascii?Q?eNBxDRR9gOhCUMGywsIf6DbyjS3dhzbHi2v0waa32Y3GzVDjDnTOLf90n5SE?=
 =?us-ascii?Q?QSME7Y1t+tO3/DMYU9P4bkjZxoA9iQ9VDev7wTGlhXm90VkWZda9scp3SRD2?=
 =?us-ascii?Q?2gFADMiRTKsMIoqLOvTEaXXlPnh74hbjX57tYzeH6Q/eEqytCDrLtjbw1twy?=
 =?us-ascii?Q?+cWbpMAFIUfRj3TFc+FAnnadgmiC5wspOUxJrwH1PRp53dxuMFow9AYaiQBv?=
 =?us-ascii?Q?8vL3Kt0Xrahr3w8qmaz38F7ZSCCu45O8Zjczy+D9gVP4dfi+DXpZzOaUc4wj?=
 =?us-ascii?Q?JbkJh4ncUGYHHj/KC9/6zqPVzTiaQ6xtKxUgGX2d0rMGMTjpUasn7k0tqgkS?=
 =?us-ascii?Q?MUumnq06QwtBgQcN9n0L8esQYUGMP3lS64oMeEMniucNoYDazqx+Fj4oSpsf?=
 =?us-ascii?Q?mP1jNy5B8tPhjxU7vh4cRaWXKiSY7xlTyJdMHSNB7ShGCFgPUT1WraTCA2+h?=
 =?us-ascii?Q?HFvi4Dno108TOGupPRiQLABanK5ddDYnVvESCUbXYCxiS7sVcs50Ywxdol9d?=
 =?us-ascii?Q?k6S1HIzzBocEBktAhl0aEFfPom9kvn6bJfMgzvHqmc1O92yTQJE112I0reuA?=
 =?us-ascii?Q?BOrpzcMkVwsbCo46x1U3yNq/F2eB+usiGOJMOFDZY2j5E3lUC+gxCnpDRs8k?=
 =?us-ascii?Q?YPHmFpHsSuJUU4Mshhp6ptfkvYQ9Tw6KPDsdWRhdgZkR+RPKeIgzsLPe+1Fg?=
 =?us-ascii?Q?HMkbcoJrgeGLRGdu7auhMpaJQqAoM1sCGksYVhcpuilnrl9hkYgBr8JhYZ3P?=
 =?us-ascii?Q?HswZ14Xn1r2Po4xAFGgXOjJlGIZj/pfxJF5OMl7iFcIy1b29zQylntHvEIOi?=
 =?us-ascii?Q?UZi2hW5+Q83GCIV9aek32khFlZDY9pxfk4hmxP1L0dYkfESmn+G3LLHSW9mg?=
 =?us-ascii?Q?bvOKhaJUt/LFxpYZVfXO7abM2DwoJEOGGchTt2hqjaBuES8mO/0pxWJ5FQ5/?=
 =?us-ascii?Q?QOB/tI8AeAtsbEPnGVGr8Ocpb5r0ewFgesojSaYq6U6+z5FqPZjy/Oxk2XLB?=
 =?us-ascii?Q?xQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c57c481-662c-43ec-9eaa-08de3eba7926
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 04:52:55.2367
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tYOffGiLRwtBiM+Pi8jM8s2S/s9RZvWCfu+0x8QyuMLC8qmHcNb0ti8DoXGp24WB90oVPOtbybIoDinFUNVIatfsQcqdm4G+as6iPKwr//Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6139
X-OriginatorOrg: intel.com

On Mon, Dec 15, 2025 at 03:36:30PM -0600, Ben Cheatham wrote:
> Add man pages for the 'cxl-inject-error' and 'cxl-clear-error' commands.
> These man pages show usage and examples for each of their use cases.
> 
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>
> ---
>  Documentation/cxl/cxl-clear-error.txt  |  67 +++++++++++++
>  Documentation/cxl/cxl-inject-error.txt | 129 +++++++++++++++++++++++++
>  Documentation/cxl/meson.build          |   2 +
>  3 files changed, 198 insertions(+)
>  create mode 100644 Documentation/cxl/cxl-clear-error.txt
>  create mode 100644 Documentation/cxl/cxl-inject-error.txt

snip

> diff --git a/Documentation/cxl/cxl-inject-error.txt b/Documentation/cxl/cxl-inject-error.txt
> new file mode 100644
> index 0000000..e1bebd7
> --- /dev/null
> +++ b/Documentation/cxl/cxl-inject-error.txt
> @@ -0,0 +1,129 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +cxl-inject-error(1)
> +===================
> +
> +NAME
> +----
> +cxl-inject-error - Inject CXL errors into CXL devices
> +
> +SYNOPSIS
> +--------
> +[verse]
> +'cxl inject-error' <device name> [<options>]
> +
> +Inject an error into a CXL device. The type of errors supported depend on the
> +device specified. The types of devices supported are:
> +
> +"Downstream Ports":: A CXL RCH downstream port (dport) or a CXL VH root port.
> +Eligible CXL 2.0+ ports are dports of ports at depth 1 in the output of cxl-list.
> +Dports are specified by host name ("0000:0e:01.1").

How are users to find that dport host?

Is there a cxl list "show me the dports where i can inject protocol errors"
incantation that we can recommend here.

I ended up looking at /sys/kernel/debug/cxl/ to find the hosts.

Would another attribute added to those dports make sense, be possible?
like is done for the poison injectable memdevs?  ie 'protocol_injectable: true'


> +"memdevs":: A CXL memory device. Memory devices are specified by device name
> +("mem0"), device id ("0"), and/or host device name ("0000:35:00.0").
> +
> +There are two types of errors which can be injected: CXL protocol errors
> +and device poison.
> +
> +CXL protocol errors can only be used with downstream ports (as defined above).
> +Protocol errors follow the format of "<protocol>-<severity>". For example,
> +a "mem-fatal" error is a CXL.mem fatal protocol error. Protocol errors can be
> +found with the '-N' option of 'cxl-list' under a CXL bus object. For example:
> +
> +----
> +
> +# cxl list -NB
> +[
> +  {
> +	"bus":"root0",
> +	"provider":"ACPI.CXL",
> +	"injectable_protocol_errors":[
> +	  "mem-correctable",
> +	  "mem-fatal",
> +	]
> +  }
> +]
> +
> +----
> +
> +CXL protocol (CXL.cache/mem) error injection requires the platform to support
> +ACPI v6.5+ error injection (EINJ). In addition to platform support, the
> +CONFIG_ACPI_APEI_EINJ and CONFIG_ACPI_APEI_EINJ_CXL kernel configuration options
> +will need to be enabled. For more information, view the Linux kernel documentation
> +on EINJ.
> +
> +Device poison can only by used with CXL memory devices. A device physical address
> +(DPA) is required to do poison injection. DPAs range from 0 to the size of
> +device's memory, which can be found using 'cxl-list'. An example injection:
> +
> +----
> +
> +# cxl inject-error mem0 -t poison -a 0x1000
> +poison injected at mem0:0x1000
> +# cxl list -m mem0 -u --media-errors
> +{
> +  "memdev":"mem0",
> +  "ram_size":"256.00 MiB (268.44 MB)",
> +  "serial":"0",
> +  "host":"0000:0d:00.0",
> +  "firmware_version":"BWFW VERSION 00",
> +  "media_errors":[
> +    {
> +      "offset":"0x1000",
> +      "length":64,
> +      "source":"Injected"
> +    }
> +  ]
> +}
> +
> +----
> +
> +Not all devices support poison injection. To see if a device supports poison injection
> +through debugfs, use 'cxl-list' with the '-N' option and look for the "poison-injectable"
> +attribute under the device. Example:
> +
> +----
> +
> +# cxl list -Nu -m mem0
> +{
> +  "memdev":"mem0",
> +  "ram_size":"256.00 MiB (268.44 MB)",
> +  "serial":"0",
> +  "host":"0000:0d:00.0",
> +  "firmware_version":"BWFW VERSION 00",
> +  "poison_injectable":true
> +}
> +
> +----
> +
> +This command depends on the kernel debug filesystem (debugfs) to do CXL protocol
> +error and device poison injection.
> +
> +OPTIONS
> +-------
> +-a::
> +--address::
> +	Device physical address (DPA) to use for poison injection. Address can
> +	be specified in hex or decimal. Required for poison injection.
> +
> +-t::
> +--type::
> +	Type of error to inject into <device name>. The type of error is restricted
> +	by device type. The following shows the possible types under their associated
> +	device type(s):
> +----
> +
> +Downstream Ports: ::
> +	cache-correctable, cache-uncorrectable, cache-fatal, mem-correctable,
> +	mem-fatal
> +
> +Memdevs: ::
> +	poison
> +
> +----
> +
> +--debug::
> +	Enable debug output
> +
> +SEE ALSO
> +--------
> +linkcxl:cxl-list[1]
> diff --git a/Documentation/cxl/meson.build b/Documentation/cxl/meson.build
> index 8085c1c..0b75eed 100644
> --- a/Documentation/cxl/meson.build
> +++ b/Documentation/cxl/meson.build
> @@ -50,6 +50,8 @@ cxl_manpages = [
>    'cxl-update-firmware.txt',
>    'cxl-set-alert-config.txt',
>    'cxl-wait-sanitize.txt',
> +  'cxl-inject-error.txt',
> +  'cxl-clear-error.txt',
>  ]
>  
>  foreach man : cxl_manpages
> -- 
> 2.52.0
> 
