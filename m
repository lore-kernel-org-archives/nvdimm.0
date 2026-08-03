Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 915FC280035
	for <nvdimm@lists.linux.dev>; Mon,  3 Aug 2026 21:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785793957; cv=fail; b=HYz+8mGCRz7NK9wb9Cc3gNbgAGly9QRfqX9KFi3UuPs5nX5A9Z2ooDLRRgl20+btLbuZ92jsyuFTSZ0FF3CXolxUbKJv0FfmshBNb4fAHVb0a1geCG1h6b1GQXigdHuI422hOZJHhsb7NLtnXxq59wbzRk58QChYpeXW9EyRNzc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785793957; c=relaxed/simple;
	bh=grsUBCEEBu7U7hQ5gFVGaP2hF6bzG5695YtMp+FFkZw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=LPR/c/UPcmladQwV8R7L6sNNv+FyhWPk8XPTmS7aGAv016trfoHexVEbO0XMYRk1IK6Atw7WMN+Z/OWwpQZAuJYLQkZw0RJpfR9Hkv7ZLVq2994ioRoQr/5ipCeU2/X4bj1Tb7WVe6jo+7zrEIc/nJHyGriaQP/jbe+flGiLbr0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ia5c4F8N; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ia5c4F8N"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785793955; x=1817329955;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=grsUBCEEBu7U7hQ5gFVGaP2hF6bzG5695YtMp+FFkZw=;
  b=Ia5c4F8NqpSzfinsssF3lJNp3jAkXuz//MpAz9FKmRz0B0ImJ2bhL7rp
   NTQbRvfUf+WNZolxpXC5EkYEYJyB0Bds1jrcTco7mLXrFDFybQLISl5Jd
   qK+mxp4Jro5RnapFEmZFPCb7IK1LsmfPmeGM3VypRSZUTaPtVn8r9vW7d
   rYUKO+L3d2xne8rI4UO3sGEXvdc1Ra0wKzMExkqG59zRAzKDLtLbQtlee
   9AnUphGdupwcyqLklriI26ADSFPdvM1aCQyNKM6JDMBDid64nG21TPGqu
   +xsFexpgJsSJfwruy0xRxPmHGhNkl6+L48nW/7MeyXGBWRuejzn0+/2WI
   Q==;
X-CSE-ConnectionGUID: mVR0EynVR9SXfrxMhnJG0g==
X-CSE-MsgGUID: W2YZ38xwTKSS87kbBDF82A==
X-IronPort-AV: E=McAfee;i="6800,10657,11864"; a="111895908"
X-IronPort-AV: E=Sophos;i="6.25,203,1779174000"; 
   d="scan'208";a="111895908"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2026 14:52:33 -0700
X-CSE-ConnectionGUID: EtYMNbijSi6C0mokxpitWA==
X-CSE-MsgGUID: vtDNkryZQHiwoVUTDQOZZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,203,1779174000"; 
   d="scan'208";a="260731301"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2026 14:52:31 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 3 Aug 2026 14:52:30 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Mon, 3 Aug 2026 14:52:30 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.42) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 3 Aug 2026 14:52:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y3VZ1uxUFm5NWbH7dmG8CjfGIEQMbu4JKFvAKYLtD7Wj1ugpjGI8UvvYH98NKTGFdvILCmJbnu66e+HHrybR2oXTPOSlVmlRZ+BYkhogjYfx3gpnvFHQCtOMvePE6dP8upYzKCpERU/Kx0sNunG4+vcDDODg5oPYph0sh/sl1nP9y1vBknJYYvSooxO5FJld+So77+dH2Megm6lJhn1A60MMwDlqLLWAY73bP4IWoWYWNvGkSPXn8AHUAIAuiDnG+kO1Yd/DHmPpKAgy94Grel1QLBs1cI42RSfuEF+cTP53CulPr7tK9phUyftUcUph8QtrrznygqHg8k4z/7ANxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xZoGFZeRUjbeqa0zrUb9RCO+sZRV+LFgAid3B7FqHZ0=;
 b=aBN/1eQxQi3AgIfyxaK1AvOWUS9cYxsySX3P0SSxzGIwMHfMguBEkxiWjBR2QpQysvAjGkeN6b5hiSXcxSltvIT7TgZ49squ7XcGtUJA5Ukkh5bAR+9TO860wkGQrC2jB/v8MZAzMsVyJ102rI30m/8R5rfFRcEqABbrfFL53Z3SeOaArsb17cQTBSUKREdYt+YWO09fhCDTqWjlN82lQosVxJarSBUhKW3oVseHcDkGi3pGQCNI2yrX5tjoHrFDjckwiInZEAknPfWYwxjCIJouJN2ui4Si5U4+G+rpQOJhqcv3tEyYyMRqgIe0gNC4awjAbd30qUifAsf7pKxXuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SA2PR11MB4891.namprd11.prod.outlook.com (2603:10b6:806:11e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.18; Mon, 3 Aug
 2026 21:52:26 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::e721:90d7:9214:2d53]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::e721:90d7:9214:2d53%6]) with mapi id 15.21.0270.017; Mon, 3 Aug 2026
 21:52:26 +0000
Date: Mon, 3 Aug 2026 14:52:17 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Anisa Su <anisa.su887@gmail.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Dave Jiang <dave.jiang@intel.com>, "Jonathan
 Cameron" <jic23@kernel.org>, Fan Ni <nifan.cxl@gmail.com>, Li Ming
	<ming.li@zohomail.com>, Vishal Verma <vishal.l.verma@intel.com>, "Davidlohr
 Bueso" <dave@stgolabs.net>, Ira Weiny <iweiny@kernel.org>, Benjamin Cheatham
	<benjamin.cheatham@amd.com>, Wonjae Lee <wj28.lee@samsung.com>, Junhee Park
	<jh9934.park@samsung.com>, Heesoo Kim <habil.kim@samsung.com>, Anisa Su
	<anisa.su@samsung.com>
Subject: Re: [PATCH v12 2/8] cxl/mem: Read dynamic capacity configuration
 from the device
Message-ID: <anENkWO2G5tdPtNb@aschofie-mobl2.lan>
References: <20260731084901.1512819-1-anisa.su@samsung.com>
 <20260731084901.1512819-3-anisa.su@samsung.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260731084901.1512819-3-anisa.su@samsung.com>
X-ClientProxiedBy: SJ0PR13CA0124.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::9) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SA2PR11MB4891:EE_
X-MS-Office365-Filtering-Correlation-Id: 50daecfd-2e79-4829-92ff-08def1a981ba
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|23010399003|7416014|1800799024|366016|6133799003|10067099003|11063799006|56012099006|4143699003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info: JtR8RUod3uvWN/rf6zj0bNicyksb2/mHfFWLZSnxu1T38zpdIIIozEBD5MhxsbxzwTvw2buc7SzGjoLWe0q0q6kMtaXs7B02SQRYVNGDz3rg3Dei244rnlZ6E6ZPpiS8O8lXUCeKzAJ85PZ9KC9POgj3gi1L/ODQnlhql1ZwrBXAt+1lFoc1jqf1hvTgXww/pDwwun6+T0RSpPEPTY+pFIwTFUne7ujD6heiRgZCIpLNqhmphf7r4in63jjBfIPgIbm+hIKmFPsou/lz0OFx5y2b228rHd9docIURD2iA0RBS61iNKXyJw+6jZlrH2nzwCf/o7nI4R7ThPEs9GfvfhzUZeYPULWshejzeBB1/w/PtU+uw7k1y10qTXvXqylazBgvgMmTXxcqgibr4bkMOL1gykwnYwcCoMkSZXGx+zMY+4a6A7ivrXEnguz65awK/TGGM02VSNje5Oolk134GL1YBHwOXW7B9/x0zAzfyikl9J750VCxfCEt9lQI3Sckg6ehH7tww3alSWpM9ohAgReVF5+8LUtw8gEFUrnSQT6dDAtBNqMxepYHccJrUEELRJcrL6DKNsCnOwQbDYzqMZwYD6WyDApFsN9kzfHOgdA90rk2GTxAUC3+LACJjr3CxCk8bDWpn+DJVkA2zv7SSDJcEp7aGIDJ/qoOwP34Ylg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(1800799024)(366016)(6133799003)(10067099003)(11063799006)(56012099006)(4143699003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rLZvtQ+FNtlFO3VacS0mtA/0+wy3JxuBCseyQII8Prr+sftfFXNgCqH8x4Si?=
 =?us-ascii?Q?QZzhLg2nahEt1K763J7oGW9bmOf/1FmR7yVtuxluKwvDHPX3+Cb6ew5pcYuM?=
 =?us-ascii?Q?sKBFCNuy29gODHGxA4SGFFEQux5sc/d/1eIqYw2kV4gyPP/blW/gVc/HRrcH?=
 =?us-ascii?Q?0Uuz0zr158esISgYnPPhDReAUVmtc773MguDWA+IMXf57WNixAbnEvBIzLB7?=
 =?us-ascii?Q?2aPm0jZwm0TwhNgi2UaujWlRJXlZ9RFTjahrPein5ykP1AyTLHmI3aEUxXo/?=
 =?us-ascii?Q?QzsXwfgq+hSoKLJHdj8NdVHvdH8U6mPxVfGAsyQw8qkaAi0DhBunGqBDXF6/?=
 =?us-ascii?Q?PocHmTikHrp2zluY0GwxmtiwrkSd4QVsBwsRfV4gxU4GGCIeZ3y3nmLQcyZe?=
 =?us-ascii?Q?fjJ8oDnAjEOwB9bKBcS2ISPlb1bWaXn0Ws4N9OqjSevChgj+kwR2+Zxul45k?=
 =?us-ascii?Q?i5UKUQiHzCv7VVjt9b04/l3kgvr4tRt4oL+Uf5HOYEACeua3JyJJzp4mYcX3?=
 =?us-ascii?Q?cPYveIC0LaMG/bVaXqrmhc07/gPcl/bbr6zMo7IVVwUPPJxLiWBRNNwyE5YQ?=
 =?us-ascii?Q?6dJiLa2Ar8ZOa4diC5Yv2mphhUmpEIPMiZe7TJA3md5nwLpUUnCG/jjXC8E1?=
 =?us-ascii?Q?1esQgTXNcDw1q37+L3wd2sx7m7OfamyKqRXxzMsa7of2WobJnYBYoxwkfPDy?=
 =?us-ascii?Q?c4MUaL80v5mWCM4rBTrXlZlKSObwtW3Z6dYGAf5r97fY2nwk2bHhyucqJy+x?=
 =?us-ascii?Q?3CPjge2zKwHKx9ziL8j381qVtfedsILxJOkAJqpZ4e+oMKu9EeZAoNY3scp1?=
 =?us-ascii?Q?bGoBY+N3WM20Wv7edp5a2gIMdzxlEwVGpcgIPl8N/g9t2km4xaium9f6GkP/?=
 =?us-ascii?Q?ueRNkxdv0EAZ8DqzWwdLr9/uubbq+dRI18GLyvRCoeOCAkWhCpsozlYKmsu1?=
 =?us-ascii?Q?/v6QP2pQEq9Lf+CI4pVRGe123fsCNxejQ4QoNSflDobQ4DCI0Z8dxI2hHDGJ?=
 =?us-ascii?Q?ugXaCVmUiKpS+kh3d6xli5vRAuQRtYxXHzg0DR0mgyrDBEaw1wcDKMeIEWAd?=
 =?us-ascii?Q?MawV+4QGWretnY+R0VUw94USXvujeIwMTD8D3ShNwczP4Oq/UlkFFsEjPwIA?=
 =?us-ascii?Q?N/DYpV6ZiAh0OT519rv9KiYFS77FZzj7DVhhbIoWWkCLK+1YAyRefZQJnUBz?=
 =?us-ascii?Q?qFkwNqUfhYZ1wiqeyhywFsN4AIEfHMck+rgmEvlqmu4tzg7pqy8js+xTyT9o?=
 =?us-ascii?Q?QJ8mKzKXmrLLu+P8W0b7jdn4V5rTkGQGpJ4FHyiP2SBHbGHJZAUJcmp/XthY?=
 =?us-ascii?Q?tCA5uCo5vDg6MkurfQ948qJlnkjV0EP2jU0XZaDNro27Sg6qTUtlJiCvilNg?=
 =?us-ascii?Q?gsNnXrvoAxrT4iskLtyMMkGi0/LDZ17j0AEiacEBuNv1C5bCmMvsfx+k5yAA?=
 =?us-ascii?Q?8rRenl/7hCklITySSKHFJYL0JpB5AXKgPAAA1STk0MLnMS9QYKVEH7zIbd10?=
 =?us-ascii?Q?MqV7WdjSeTi1FzfdV7OFgezBaGFJkgdGO9sMX8Ws9MhbDoxlz5qVO/hDMfwi?=
 =?us-ascii?Q?fG5uJ6OTPfpXLdCZguwYrxuJyy8RwCj/47Nt4ZvOIPEFsH56gbFN2Vw1KRaO?=
 =?us-ascii?Q?+uhP4nPlQBFmQzNz9rdpcmFfAW8Hw1VyO6vtrnth4O2ucmQd4KBGGyz+RJWW?=
 =?us-ascii?Q?1I7rQjIOITt5xmkHJjZpu4xENfE7tCLn7qRhF2/qlfKPq7rV2V6s/kReCnrH?=
 =?us-ascii?Q?TiEc7W4Yj6LB/p9a5JigaYvAwuzyEpY=3D?=
X-Exchange-RoutingPolicyChecked: LmBL3ZfviN93jAs/PW3HDu95WuKgqUJjTi1WzhTvIjs02o/ACLK5F1SQ+av+S2QzxhnzPZOxLhH1rleZSai9BNad5tdMZOTIim4Xaz4oA7FhuVAMT94CXZTTGLJFyMdWfOax4kbF1AaPgqSN7V++4KSrMGnWM1M2ElkYA4Qh90w4n0C7Bk2sa21TIdHhrWMM1uBdPegPr3pmuvED8hIFxzkm6DtJ6ldQv/YFnZtzFXJLeuoVN7FyqdY94xLJCydxCOgZSXtW9YzfjTtL/xmllbvoWYsnaxp93uumkpPP8iMcmOiOOc5zkF5dRPLTYcvO4yjHOn1Ge+6K8fDVdgU2cg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 50daecfd-2e79-4829-92ff-08def1a981ba
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2026 21:52:26.3043
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7H/918vHfg5nW92ot0Xm1VJelOa8L0SlY6/VBtJ8nMWbgS2GP9naAKCviWCRcnYSoiVbB52uju1ROgjjEbhohV08b1Wk11ncKz+wUEHw1qs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4891
X-OriginatorOrg: intel.com

On Fri, Jul 31, 2026 at 01:48:07AM -0700, Anisa Su wrote:
> From: Ira Weiny <iweiny@kernel.org>
> 
> Devices which optionally support Dynamic Capacity (DC) are configured
> via mailbox commands.  CXL r4.0 section 9.13.3 requires the host to issue
> the Get DC Configuration command in order to properly configure DCDs.
> Without the Get DC Configuration command DCD can't be supported.
> 
> Implement the DC mailbox commands as specified in CXL 4.0 section
> 8.2.10.9.9 (opcodes 48XXh) to read and store the DCD configuration
> information.  Disable DCD if an invalid configuration is found.
> 
> Linux has no support for more than one dynamic capacity partition.  Read
> and validate all the partitions but configure only the first partition
> as 'dynamic ram 1'.  Additional partitions can be added in the future if
> such a device ever materializes.  Additionally it is anticipated that no
> skips will be present from the end of the pmem partition.  Check for and
> disallow this configuration as well.

Hi Anisa,

"Additionally, it is anticipated that no skips will be present.." sounds
woogedy. The paragraph starts with a Linux limitation of only one partition.
and next mentions skips. Is that a Linux implementation rule, a spec
rule, or something else?

See below wrt validation checks.


> 
> Based on an original patch by Navneet Singh.
> 
> Signed-off-by: Ira Weiny <iweiny@kernel.org>
> Signed-off-by: Anisa Su <anisa.su@samsung.com>
> Tested-by: Wonjae Lee <wj28.lee@samsung.com>
> Tested-by: Junhee Park <jh9934.park@samsung.com>
> Tested-by: Heesoo Kim <habil.kim@samsung.com>
> 
> ---
> Changes:
> 1. mbox.c: bound the Get DC Config request by the negotiated mailbox
>    payload. Requesting all CXL_MAX_DC_PARTITIONS (8) needs a 328-byte
>    response, which exceeds a spec-minimum 256-byte mailbox and fails
>    -E2BIG, disabling DCD. Cap partition_count per call to what the
>    payload holds and read the rest via the existing start_partition
>    loop.
> ---
>  drivers/cxl/core/hdm.c  |   2 +
>  drivers/cxl/core/mbox.c | 220 ++++++++++++++++++++++++++++++++++++++++
>  drivers/cxl/cxlmem.h    |  55 ++++++++++
>  drivers/cxl/pci.c       |   3 +
>  include/cxl/cxl.h       |   3 +-
>  5 files changed, 282 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
> index 0c80b76a5f9b..0ef076c08ed2 100644
> --- a/drivers/cxl/core/hdm.c
> +++ b/drivers/cxl/core/hdm.c
> @@ -446,6 +446,8 @@ static const char *cxl_mode_name(enum cxl_partition_mode mode)
>  		return "ram";
>  	case CXL_PARTMODE_PMEM:
>  		return "pmem";
> +	case CXL_PARTMODE_DYNAMIC_RAM_1:
> +		return "dynamic_ram_1";
>  	default:
>  		return "";
>  	};
> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index 4790524c32a7..d79019fbd790 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c
> @@ -1352,6 +1352,197 @@ int cxl_mem_sanitize(struct cxl_memdev *cxlmd, u16 cmd)
>  	return -EBUSY;
>  }
>  
> +static int cxl_dc_check(struct device *dev, struct cxl_dc_partition_info *part_array,
> +			u8 index, struct cxl_dc_partition *dev_part)
> +{
> +	u64 blk_size = le64_to_cpu(dev_part->block_size);
> +	u64 len = le64_to_cpu(dev_part->length);
> +
> +	part_array[index].start = le64_to_cpu(dev_part->base);
> +	part_array[index].size = le64_to_cpu(dev_part->decode_length);
> +	part_array[index].size *= CXL_CAPACITY_MULTIPLIER;
> +
> +	/* Check partitions are in increasing DPA order */
> +	if (index > 0) {
> +		struct cxl_dc_partition_info *prev_part = &part_array[index - 1];
> +
> +		if ((prev_part->start + prev_part->size) >
> +		     part_array[index].start) {
> +			dev_err(dev,
> +				"DPA ordering violation for DC partition %d and %d\n",
> +				index - 1, index);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	if (part_array[index].size == 0 || len == 0 ||
> +	    part_array[index].size < len || !IS_ALIGNED(len, blk_size)) {
> +		dev_err(dev, "DC partition %d invalid length; size %llu len %llu blk size %llu\n",
> +			index, part_array[index].size, len, blk_size);
> +		return -EINVAL;
> +	}
> +
> +	if (blk_size == 0 || blk_size % CXL_DCD_BLOCK_LINE_SIZE ||
> +	    !is_power_of_2(blk_size)) {
> +		dev_err(dev, "DC partition %d invalid block size %llu\n",
> +			index, blk_size);
> +		return -EINVAL;
> +	}
> +
> +	if (!IS_ALIGNED(part_array[index].start, SZ_256M) ||
> +	    !IS_ALIGNED(part_array[index].start, blk_size)) {
> +		dev_err(dev, "DC partition %d invalid start %llu blk size %llu\n",
> +			index, part_array[index].start, blk_size);
> +		return -EINVAL;
> +	}
> +
> +	dev_dbg(dev, "DC partition %d start %llu size %llu blk_size: %llu\n",
> +		index, part_array[index].start, part_array[index].size,
> +		blk_size);
> +
> +	return 0;
> +}


cxl_dc_check() above needs rework.
Please go back through it against CXL r4.0 Tables 8-346 and 8-347 and confirm
that each constraint the code enforces is the constraint the spec actually
states. The check need to run in dependency order, and then each failure
needs to report the specific field or relationship that is invalid.

A terse list of what looks wrong from here. (I have not chased each one)

- blk_size is used as the alignment in IS_ALIGNED(len, blk_size) and
  IS_ALIGNED(start, blk_size) before it is validated.
- Four unrelated conditions share one "invalid length" message.
- The start check combines the 256 MiB and block-size requirements, so the
  message cannot say which alignment failed.
- "DPA ordering violation" is really an overlap check, and gaps appear to be
  allowed.
- avail_partition_count is never checked against the 1 to 8 range Table 8-346
  requires.
- cxl_configure_dcd()'s "skip from pmem not supported" also fires on overlap,
  and prints neither address.
- min_out = 8 is a bare constant for the header ahead of the flex array
- DPA addresses and sizes print in decimal, rest of CXL uses hex 
- The Table 8-178, 8-179 and 8-180 citations are not r4.0 numbering

And RichardC called out this one in his prior review -
- Zero geometry fields are legal per Table 8-347, as already raised on the
  list. Agreed, and the fallout of skipping rather than rejecting needs
  working through.

-- Alison


> +
> +/* Returns the number of partitions in dc_resp or -ERRNO */
> +static int cxl_get_dc_config(struct cxl_mailbox *mbox, u8 start_partition,
> +			     u8 partition_count,
> +			     struct cxl_mbox_get_dc_config_out *dc_resp,
> +			     size_t dc_resp_size)
> +{
> +	struct cxl_mbox_get_dc_config_in get_dc = (struct cxl_mbox_get_dc_config_in) {
> +		.partition_count = partition_count,
> +		.start_partition_index = start_partition,
> +	};
> +	struct cxl_mbox_cmd mbox_cmd = (struct cxl_mbox_cmd) {
> +		.opcode = CXL_MBOX_OP_GET_DC_CONFIG,
> +		.payload_in = &get_dc,
> +		.size_in = sizeof(get_dc),
> +		.size_out = dc_resp_size,
> +		.payload_out = dc_resp,
> +		.min_out = 8,
> +	};
> +	size_t expected_sz;
> +	int rc;
> +
> +	rc = cxl_internal_send_cmd(mbox, &mbox_cmd);
> +	if (rc < 0)
> +		return rc;
> +
> +	if (dc_resp->partitions_returned > partition_count) {
> +		dev_err(mbox->host, "Device returned %u partitions, requested %u\n",
> +			dc_resp->partitions_returned, partition_count);
> +		return -EIO;
> +	}
> +
> +	/*
> +	 * The payload carries trailing extent/tag count fields after the
> +	 * partition array (CXL r4.0 Table 8-179) which the driver ignores, so
> +	 * the response is at least, not exactly, expected_sz.
> +	 */
> +	expected_sz = struct_size(dc_resp, partition,
> +				  dc_resp->partitions_returned);
> +
> +	if (mbox_cmd.size_out < expected_sz) {
> +		dev_err(mbox->host,
> +			"Payload size %zu less than expected %zu for %u partitions\n",
> +			mbox_cmd.size_out,
> +			expected_sz,
> +			dc_resp->partitions_returned);
> +		return -EIO;
> +	}
> +
> +	dev_dbg(mbox->host, "Read %d/%d DC partitions\n",
> +		dc_resp->partitions_returned, dc_resp->avail_partition_count);
> +	return dc_resp->partitions_returned;
> +}
> +
> +/**
> + * cxl_dev_dc_identify() - Reads the dynamic capacity information from the
> + *                         device.
> + * @mbox: Mailbox to query
> + * @dc_info: The dynamic partition information to return
> + *
> + * Read Dynamic Capacity information from the device and return the partition
> + * information.
> + *
> + * Return: 0 if identify was executed successfully, -ERRNO on error.
> + *         on error only dc_info is left unchanged.
> + */
> +int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
> +			struct cxl_dc_partition_info *dc_info)
> +{
> +	struct cxl_dc_partition_info partitions[CXL_MAX_DC_PARTITIONS];
> +	struct cxl_mbox_get_dc_config_out *dc_resp __free(kfree) = NULL;
> +	struct device *dev = mbox->host;
> +	u8 start_partition;
> +	u8 num_partitions;
> +	u8 partition_count;
> +	size_t dc_resp_size;
> +
> +	/* Bound requested number of partitions by mailbox payload size */
> +	partition_count = min_t(size_t, CXL_MAX_DC_PARTITIONS,
> +				(mbox->payload_size - sizeof(*dc_resp) -
> +				 sizeof(struct cxl_mbox_get_dc_config_tail)) /
> +				sizeof(struct cxl_dc_partition));
> +	dc_resp_size = struct_size(dc_resp, partition, partition_count) +
> +		       sizeof(struct cxl_mbox_get_dc_config_tail);
> +
> +	dc_resp = kmalloc(dc_resp_size, GFP_KERNEL);
> +	if (!dc_resp)
> +		return -ENOMEM;
> +
> +	/*
> +	 * Read and check all partition information for validity and potential
> +	 * debugging; see debug output in cxl_dc_check()
> +	 */
needless comment


> +	start_partition = 0;
> +	num_partitions = 0;
> +	do {
> +		int rc, i, j;
> +
> +		rc = cxl_get_dc_config(mbox, start_partition, partition_count,
> +				       dc_resp, dc_resp_size);
> +		if (rc < 0) {
> +			dev_err(dev, "Failed to get DC config: %d\n", rc);
> +			return rc;
> +		}
> +
> +		if (rc == 0) {
> +			dev_err(dev,
> +				"Device reported %u partitions available but returned none at index %u\n",
> +				dc_resp->avail_partition_count, start_partition);
> +			return -EIO;
> +		}
> +
> +		num_partitions += rc;
> +
> +		if (num_partitions < 1 || num_partitions > CXL_MAX_DC_PARTITIONS) {
> +			dev_err(dev, "Invalid num of dynamic capacity partitions %d\n",
> +				num_partitions);
> +			return -EINVAL;
> +		}
> +
> +		for (i = start_partition, j = 0; i < num_partitions; i++, j++) {
> +			rc = cxl_dc_check(dev, partitions, i,
> +					  &dc_resp->partition[j]);
> +			if (rc)
> +				return rc;
> +		}
> +
> +		start_partition = num_partitions;
> +
> +	} while (num_partitions < dc_resp->avail_partition_count);
> +
> +	/* Return 1st partition */
> +	dc_info->start = partitions[0].start;
> +	dc_info->size = partitions[0].size;
> +	dev_dbg(dev, "Returning partition 0 %llu size %llu\n",
> +		dc_info->start, dc_info->size);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_NS_GPL(cxl_dev_dc_identify, "CXL");
> +
>  static void add_part(struct cxl_dpa_info *info, u64 start, u64 size, enum cxl_partition_mode mode)
>  {
>  	int i = info->nr_partitions;
> @@ -1422,6 +1613,35 @@ int cxl_get_dirty_count(struct cxl_memdev_state *mds, u32 *count)
>  }
>  EXPORT_SYMBOL_NS_GPL(cxl_get_dirty_count, "CXL");
>  
> +void cxl_configure_dcd(struct cxl_memdev_state *mds, struct cxl_dpa_info *info)
> +{
> +	struct cxl_dc_partition_info dc_info = { 0 };
> +	struct device *dev = mds->cxlds.dev;
> +	int rc;
> +
> +	rc = cxl_dev_dc_identify(&mds->cxlds.cxl_mbox, &dc_info);
> +	if (rc) {
> +		dev_warn(dev,
> +			 "Failed to read Dynamic Capacity config: %d\n", rc);
> +		cxl_disable_dcd(mds);
> +		return;
> +	}
> +
> +	/* Skips between pmem and the dynamic partition are not supported */
> +	if (dc_info.start != info->size) {
> +		dev_warn(dev,
> +			 "Dynamic Capacity skip from pmem not supported\n");
> +		cxl_disable_dcd(mds);
> +		return;
> +	}
> +
> +	info->size += dc_info.size;
> +	dev_dbg(dev, "Adding dynamic ram partition 1; %llu size %llu\n",
> +		dc_info.start, dc_info.size);
> +	add_part(info, dc_info.start, dc_info.size, CXL_PARTMODE_DYNAMIC_RAM_1);
> +}
> +EXPORT_SYMBOL_NS_GPL(cxl_configure_dcd, "CXL");
> +
>  int cxl_arm_dirty_shutdown(struct cxl_memdev_state *mds)
>  {
>  	struct cxl_mailbox *cxl_mbox = &mds->cxlds.cxl_mbox;
> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> index 616eeaeee5b9..a9782939d82b 100644
> --- a/drivers/cxl/cxlmem.h
> +++ b/drivers/cxl/cxlmem.h
> @@ -407,6 +407,8 @@ struct cxl_security_state {
>  	struct kernfs_node *sanitize_node;
>  };
>  
> +#define CXL_MAX_DC_PARTITIONS 8
> +
>  static inline resource_size_t cxl_pmem_size(struct cxl_dev_state *cxlds)
>  {
>  	/*
> @@ -691,6 +693,39 @@ struct cxl_mbox_set_shutdown_state_in {
>  	u8 state;
>  } __packed;
>  
> +/* See CXL r4.0 Table 8-178 get dynamic capacity config Input Payload */
> +struct cxl_mbox_get_dc_config_in {
> +	u8 partition_count;
> +	u8 start_partition_index;
> +} __packed;
> +
> +/* See CXL r4.0 Table 8-179 get dynamic capacity config Output Payload */
> +struct cxl_mbox_get_dc_config_out {
> +	u8 avail_partition_count;
> +	u8 partitions_returned;
> +	u8 rsvd[6];
> +	/* See CXL r4.0 Table 8-180 */
> +	struct cxl_dc_partition {
> +		__le64 base;
> +		__le64 decode_length;
> +		__le64 length;
> +		__le64 block_size;
> +		__le32 dsmad_handle;
> +		u8 flags;
> +		u8 rsvd[3];
> +	} __packed partition[] __counted_by(partitions_returned);
> +	/* Trailing extent/tag count fields unused */
> +} __packed;
> +
> +/* Trailing counts; cannot be a member after the flex array above */
> +struct cxl_mbox_get_dc_config_tail {
> +	__le32 num_extents_supported;
> +	__le32 num_extents_available;
> +	__le32 num_tags_supported;
> +	__le32 num_tags_available;
> +} __packed;
> +#define CXL_DCD_BLOCK_LINE_SIZE 0x40
> +
>  /* Set Timestamp CXL 3.0 Spec 8.2.9.4.2 */
>  struct cxl_mbox_set_timestamp_in {
>  	__le64 timestamp;
> @@ -814,9 +849,18 @@ enum {
>  int cxl_internal_send_cmd(struct cxl_mailbox *cxl_mbox,
>  			  struct cxl_mbox_cmd *cmd);
>  int cxl_dev_state_identify(struct cxl_memdev_state *mds);
> +
> +struct cxl_dc_partition_info {
> +	u64 start;
> +	u64 size;
> +};
> +
> +int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
> +			struct cxl_dc_partition_info *dc_info);
>  int cxl_await_media_ready(struct cxl_dev_state *cxlds);
>  int cxl_enumerate_cmds(struct cxl_memdev_state *mds);
>  int cxl_mem_dpa_fetch(struct cxl_memdev_state *mds, struct cxl_dpa_info *info);
> +void cxl_configure_dcd(struct cxl_memdev_state *mds, struct cxl_dpa_info *info);
>  struct cxl_memdev_state *cxl_memdev_state_create(struct device *dev, u64 serial,
>  						 u16 dvsec);
>  void set_exclusive_cxl_commands(struct cxl_memdev_state *mds,
> @@ -830,6 +874,17 @@ void cxl_event_trace_record(struct cxl_memdev *cxlmd,
>  			    const uuid_t *uuid, union cxl_event *evt);
>  int cxl_get_dirty_count(struct cxl_memdev_state *mds, u32 *count);
>  int cxl_arm_dirty_shutdown(struct cxl_memdev_state *mds);
> +
> +static inline bool cxl_dcd_supported(struct cxl_memdev_state *mds)
> +{
> +	return mds->dcd_supported;
> +}
> +
> +static inline void cxl_disable_dcd(struct cxl_memdev_state *mds)
> +{
> +	mds->dcd_supported = false;
> +}
> +
>  int cxl_set_timestamp(struct cxl_memdev_state *mds);
>  int cxl_poison_state_init(struct cxl_memdev_state *mds);
>  int cxl_mem_get_poison(struct cxl_memdev *cxlmd, u64 offset, u64 len,
> diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
> index 267c679b0b3c..9b320a2b6fe0 100644
> --- a/drivers/cxl/pci.c
> +++ b/drivers/cxl/pci.c
> @@ -870,6 +870,9 @@ static int cxl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	if (rc)
>  		return rc;
>  
> +	if (cxl_dcd_supported(mds))
> +		cxl_configure_dcd(mds, &range_info);
> +
>  	rc = cxl_dpa_setup(cxlds, &range_info);
>  	if (rc)
>  		return rc;
> diff --git a/include/cxl/cxl.h b/include/cxl/cxl.h
> index 016c74fb747c..87c2bd73df21 100644
> --- a/include/cxl/cxl.h
> +++ b/include/cxl/cxl.h
> @@ -133,6 +133,7 @@ struct cxl_dpa_perf {
>  enum cxl_partition_mode {
>  	CXL_PARTMODE_RAM,
>  	CXL_PARTMODE_PMEM,
> +	CXL_PARTMODE_DYNAMIC_RAM_1,
>  };
>  
>  /**
> @@ -147,7 +148,7 @@ struct cxl_dpa_partition {
>  	enum cxl_partition_mode mode;
>  };
>  
> -#define CXL_NR_PARTITIONS_MAX 2
> +#define CXL_NR_PARTITIONS_MAX 3
>  
>  /**
>   * struct cxl_dev_state - The driver device state
> -- 
> 2.43.0
> 
