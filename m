Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB051FDA
	for <nvdimm@lists.linux.dev>; Wed, 30 Apr 2025 00:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745974404; cv=fail; b=L4s0hvHotKBB69pB1HpwHjRGz/lGcWHOm1PHAZVgfkR/Vh0xPdiRFElv7yq9nzP9yTZ+SV2QmWvOFjb+u+jyBOyKoEkN9slhdAdr7YqNhSRTgnyYTy0Ckk72SJM66TWdLa9MWjSGtBDGwU+flfGbtOylgXHL9hxDUsQ5VIcRWTA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745974404; c=relaxed/simple;
	bh=rcCm4ZXXTiBwZyNxEpmQ2l7go9aKI5mMVFN56NVcQbw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=e8WZzvuyIHJqteZw07C+gXgNfq+23DzQFSN5lRaWuBFNJXo2yqR1/c2k5V6clQWzFVmTcZ/cgCSH7vbahb/sbhg4w9Ga1QEyVMza9AJvP/nyaq0yz3pWHqdt9lVeXarN21Hh9Hrr8eSciv/NZ9R0eMMloEwyc1ZbbsnF9+7hDyU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Po6V5JmM; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Po6V5JmM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745974403; x=1777510403;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=rcCm4ZXXTiBwZyNxEpmQ2l7go9aKI5mMVFN56NVcQbw=;
  b=Po6V5JmMi9DgQJFlmk7AHH7Xt9M3Wu3XqBwUGdSTq/94ilSLiGb2ZJ2D
   rukshQteMa24uGuCx3VvD1NjKrUdbMx8ah76KvWfKrWIc8+t4oeiSZMek
   Bpm3nVqppmygVyJThxzWUQheRtmevCG1pRBcRdMqSiC/y3gnxkkxFizE8
   D/umzsy2xj51fB9cRHS2BDCVjKyq3yBJle7RMcBNHkFgNK5wx6gaR8Qcr
   v9pWy8vb72VJQBz0h3Vez3L4OV+/eUEbFcvrYVwZ6Rn/Ej9pl82pBK1r3
   8jg30HOEF9WLaywoJbS2ET4NFLhO4ob9suXT0GCdG5wvpI6cFGXcXrE9i
   A==;
X-CSE-ConnectionGUID: dJQytJs7RoeP+gKSuKfW4A==
X-CSE-MsgGUID: uMae8XkwSDGgEa6bLkyC/Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11418"; a="47498483"
X-IronPort-AV: E=Sophos;i="6.15,250,1739865600"; 
   d="scan'208";a="47498483"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2025 17:53:22 -0700
X-CSE-ConnectionGUID: EcvlQyAdTYSM8QMQxBKBcQ==
X-CSE-MsgGUID: W78PoFGtTq+o8LkAvCRnrw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,250,1739865600"; 
   d="scan'208";a="134291251"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2025 17:53:21 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 29 Apr 2025 17:53:20 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 29 Apr 2025 17:53:20 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.173)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 29 Apr 2025 17:53:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zL0GPKl8JILXQ2gTb/IleJvyGZ+QZRQvPPw4THflyXNDmsB4cxThPvivcDyh4Wt/T+VX3IR4KuSmxaU11ai60oCiCUn6TuFb6BcCnS7ldqRuY9rTTFyeKxrZSbdUspUgK/q7/AtDpRpUdNkbNXhp08ubcmIo4OvypqJ+3Pl0a6yGQ3kLg/7fHMbOu32iTSP0I9uL55kY80u1IFVQ9FptqQj+xk8ze3HD/5dKwlssvOmmfGt8C++GUrEilDGgReRHWyqwEBSaLGypImdtpFpf7ojIXyfLFqPIEWU+CbIUjtnIcDN4uKjJf3P/8vf7b/Q0L5EqnszuOdhjRddnZmYZUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z5VIf9FAkNErx1ofuNxSLLaXo5IfkYvX9vW3sMF1+9Y=;
 b=nK2YckWpfUKnNL49nkSFSfyVIjczCGKoC0/ndXRdPXWSPL214hsaAyWaV1G4GfA40hMP0fnd2Y7yoNlmBlJNBi85uzI/0Wtk44O+vb0Co6QzSg4o9/sWau1lt/6gIlSKUemCg1j+KdlD4iM5iasGrSBBqU3xZjxz+EW+LZi5OQOqRSV8yMcjzH3ghcfDBxWxd/zq8F+lpE/DWa2t8dUAB9dbZC7DoXP/a22nNWMxtLywyvBMgvM+3QKzmRCUQnGrIA9lp7hgFDcWkpNcD+Y6sfE2Urx/tyrDBuNUcKbNkU2PYRnkxOhRjIvyBthUXRd8vXRR3nFIPNarw405jIw29g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB8794.namprd11.prod.outlook.com (2603:10b6:806:46a::5)
 by CH0PR11MB8190.namprd11.prod.outlook.com (2603:10b6:610:188::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.19; Wed, 30 Apr
 2025 00:53:12 +0000
Received: from SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720]) by SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720%5]) with mapi id 15.20.8678.028; Wed, 30 Apr 2025
 00:53:12 +0000
Date: Tue, 29 Apr 2025 17:53:08 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Ben Cheatham <benjamin.cheatham@amd.com>
CC: Junhyeok Im <junhyeok.im@samsung.com>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH 0/6] Add error injection support
Message-ID: <aBF0dA2NzjrfWVBJ@aschofie-mobl2.lan>
References: <20250424212401.14789-1-Benjamin.Cheatham@amd.com>
 <aBA63FNkc21vPZ1d@aschofie-mobl2.lan>
 <2bfda6ab-7eb7-4166-832f-06a6a3216d0e@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2bfda6ab-7eb7-4166-832f-06a6a3216d0e@amd.com>
X-ClientProxiedBy: MW4PR04CA0161.namprd04.prod.outlook.com
 (2603:10b6:303:85::16) To SA1PR11MB8794.namprd11.prod.outlook.com
 (2603:10b6:806:46a::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB8794:EE_|CH0PR11MB8190:EE_
X-MS-Office365-Filtering-Correlation-Id: 3395bb1d-1dd3-4a38-d0f1-08dd87816205
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?H+sVCmhLrjoalIY/Uq2D+7DsMH1DzmPVftw2HNZ07AN2+dH2XeaC1NgdQ9Mx?=
 =?us-ascii?Q?6H1FjQ6SBna67FFeWeKD5DcTx0Tshe7UQAtwRQlhiqMNAoF3L4FgjlDpLmzH?=
 =?us-ascii?Q?dqOsnBynqqqQXIkLGHCC3JGw1Kavevx2iYFw2csny708UnxTS6kguXYCgpyS?=
 =?us-ascii?Q?ujT5xEEFr/OSH+ZcJfbYjGJiyDSGpVuaYzRDaACO1TXkHTq85MMS4mLeFqlz?=
 =?us-ascii?Q?krXzGghmqGVjyQMCNKlMVkOniMrt3rPPsMAVmT3dUBT4kFzDt6QvmrU2Fy/r?=
 =?us-ascii?Q?K0cfF49JcZDDQyI6KB/07KwgafkRHn3FcqJBStMiFCLpxgVyjFQq5X1Adlp1?=
 =?us-ascii?Q?G65/8Yn3X61yo0oOkNmpSYhkTsyR6eC9e7JqnqLAjeqtya+csQszx/uM5/uw?=
 =?us-ascii?Q?UxKbubg8YIi4e3gF7pg7CB39Awt+yC1OytG6jQRqysCLhb7Mf7FzkYulRsGW?=
 =?us-ascii?Q?Rcd/45nWNiDSB+n7A5JSWb4YStToVtm1rtOCn2VVWNkU6FkuHNci36hd0t10?=
 =?us-ascii?Q?PIjlyVLQLe0DZN7GPlk+RMF8UTmd0yz1EP9Z79k/6jFWs0ceuoBWiZHQ16eC?=
 =?us-ascii?Q?kNGbywjv+KF6CtVmOFBd6S8FYcI/6Ssd/uIMomfdfy+xZ1UM2aGBHT/t7FLS?=
 =?us-ascii?Q?HmYHuYEHfpJ7Ht1MXniK70XXsZAv6YguwKRwccrVuyYpLLOBYp5xznASRudN?=
 =?us-ascii?Q?v1F0zExGDh9nugUHRs8skQQJvl7v2qopVYyOh7lLtWQg9dHy42vab5j9GakI?=
 =?us-ascii?Q?u0+ZrQWNZILWoyQi1G0V61YsDFrzxywyz1nTYJFqZtQj+0n5usZM5QAFouW1?=
 =?us-ascii?Q?E1r0GiCUk4J+9LktVBhHbTl/MqX+KiEMfVImzhGQF6T3Lr1C8q6QiZTc5XIr?=
 =?us-ascii?Q?H7P79/qQe5W00IJrJFgwv4xEBVwnNhosqX28ceE3fRFZHSYmFXaGMAdeBjx/?=
 =?us-ascii?Q?RcQrrY/BI7XNMOinezZXhDWVOP2+Ecw4TQG3Fm2+y5YTPZZM3Z9aN/n7xeRn?=
 =?us-ascii?Q?RFPltho1cxhYak6v9ib7SEPH5oWEhMyUZVRmDQDUmQ7OSoiRAZ6Kc6qrQ6Ev?=
 =?us-ascii?Q?V7DD+vHRB33HbtQV+YgXotRoXL7kM9Pp5onUvbtIMvC/3PvGuvhcHdw+1uHS?=
 =?us-ascii?Q?Lo5A9KKpPf2Eclnk2Hxer/FC9kTSIf34Ju7CY7RW6d8WqOioEzfj5nLgtlZb?=
 =?us-ascii?Q?u6VR3oZXW1GoCtvZXnVdFOZh5c9taNko1oyv7abZAOMBrzL8O5yYZ602alXV?=
 =?us-ascii?Q?piDsuRw3YNSauv8NlsRt4WstfsWhmCWJDlDt8E5kjYRtyt9zvAIMpe5H4l7Q?=
 =?us-ascii?Q?0NQY3ClLnX1rYlykQ0jbE4U+e/SFyooGXhaUgyK2CRi2tB5c8O3fP82w42sz?=
 =?us-ascii?Q?6QG2SOQ=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB8794.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5yYkJJtvY8/wixw4PDcbBGeLSHmfFd+rNWX6n1KtA+b3AtURH8HloZlQ1Jeg?=
 =?us-ascii?Q?4n22ws0bHvLywwzEiIXLcPfO1kfn5RvMBxs51AvIHQLGg1gRgHWqkFQtazbB?=
 =?us-ascii?Q?1XiTV+8mUvm4FTXg8QKU5fLZ3bML/wkgsaiVBKkBLLY4hIP98YtFODOd0Qgq?=
 =?us-ascii?Q?CoXs4rVw9/zwC2cu/BBtbu4BtZamzqnVm7K0Z8ylQG8PbLtkVoqSVatU8loR?=
 =?us-ascii?Q?v7/wDaCziQSPx35CZYZ/+jdYvQZN2Ip4w43QxcXgzkYjHR3bZ7Endx8O2yrc?=
 =?us-ascii?Q?bTMhRLjgbNedCcEjlKIUeHPvjc+fqbAmXQUdz+J3SJ9IewbCa62mQoM+FfNY?=
 =?us-ascii?Q?/WTVzp1n6dnPdJKaPCun3d4RQ4rgOlH6xV5XUD4hhws7grQDJgz4iDip8vzR?=
 =?us-ascii?Q?xmzN4nkk1FD81aTLonz9Qv8YosMGqB4iSatlYxVkFvWPvNRz8AeOUYtfcUs4?=
 =?us-ascii?Q?LlNUBhsCwnREPjJnfQVf+JorAx3PvpV0xqKiMl92Uddi/Ag43TI8vaphN0Cr?=
 =?us-ascii?Q?oqRkSnnXLqbZ5okzyC1I0jXL2YGCBusENokPgWxuPDYFCTvFNPyVXUb0aJcB?=
 =?us-ascii?Q?DI15qh02FxyvaFesJtmRuYdRCgZu7k+3YgGAe3eASOzkxUiq9lcoaGRiZgp/?=
 =?us-ascii?Q?MryiYDUp3F7uzqmuBRMaoq7bSvW4fwHyV8EpuZSeO2JLJjaQuA4MvrST27UI?=
 =?us-ascii?Q?MyM4OdnIJZ4cThAZjH3ja9HtQ0iMqxWQKtiOFH3emtYk5Z30zE+HT+mvxqjf?=
 =?us-ascii?Q?OCG5QinM9NB6XBp7j3cf5zeNRdrWYX92JPQtWSh4zTtobl1YZq7wupcAO3AK?=
 =?us-ascii?Q?Fri3sruhIR6jKq/OoKhDvJUuyUFGnTjuoPUMPNRhkv0t4sEGZUL3ROlprkGI?=
 =?us-ascii?Q?AJX5hHnxaBpTUkqTDSBGPt47DA/fA3Z5RyTzD5d5/MTSF2P9lzSql7iivxVP?=
 =?us-ascii?Q?rwG/ueZPjtZ5TqkXgxG5v/ba4mkPZGu2J78HdP0wkl0qjD2dqaV5xVO8Vqum?=
 =?us-ascii?Q?b4l2i9+QiKDtqyi16XHW8veHyugdXlCWmlnzVTJjSTDDK7S1NIexMoXVf0mh?=
 =?us-ascii?Q?k+7Vdw3tiEOvj21NGSPeIfKQ5iKmkHQrzABsZ0f038q3DjJRFhbjgK0d3hRq?=
 =?us-ascii?Q?WVV/gWerRuNvKR4vYT0pNLQLRit7Fqh72TSMPh/uhCN3RQTiWxnunytVnzfb?=
 =?us-ascii?Q?BDppdXZUR857WsBhG+E8hyPu/iwBiWawqaOI0p3VxDMhTN+nXszfFmu8abMn?=
 =?us-ascii?Q?B9URjdW8bsYMVGT9Uvm0z4MZuzOd0m7/aAVRy06w/zyJ/9+jM0XyRE/2aih4?=
 =?us-ascii?Q?C1zKo6lKuC4OYcu6E+EW2O07yqVqWw7rBuL6rVVjtUN8FY9BYXBP9fiZ9z3g?=
 =?us-ascii?Q?ZWnswQzioJmeILwwRXhzO0A+0WeQoarIa7tnDakIzZHOJonzqvJiyJMUUdyg?=
 =?us-ascii?Q?2Q0nBGX+D3/QzwMzrzipNEUyrbFsPC8o79NRH0xxd3oaSU6ZgZUFcYMDQ73B?=
 =?us-ascii?Q?k9pEPYqVwoC//pTop17bK8pCbyCJF1o7PZMXL4E18vtJETuU1HR9wec7ioaM?=
 =?us-ascii?Q?Izs+q9AZaVG/GpR5kMM2UCMK2y0I92HmM3xxE206j+eZ2PVKHmPmmyO3PyMF?=
 =?us-ascii?Q?nQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3395bb1d-1dd3-4a38-d0f1-08dd87816205
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB8794.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2025 00:53:12.4707
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eScI0nYbbs9BhITRj/wfTZFOv4nvJElATSyrqRMswEE6PDFzfQi7sSS1fnlvqz2CKgzuLgcF5s6ecCjSO5mPmWvvw5Y3RvnVyYLPevFi6vU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8190
X-OriginatorOrg: intel.com

On Tue, Apr 29, 2025 at 03:01:42PM -0500, Ben Cheatham wrote:
> 
> On 4/28/25 9:35 PM, Alison Schofield wrote:
> > On Thu, Apr 24, 2025 at 04:23:55PM -0500, Ben Cheatham wrote:
> >> This series adds support for injecting CXL protocol (CXL.cache/mem)
> >> errors[1] into CXL RCH Downstream ports and VH root ports[2] and
> >> poison into CXL memory devices through the CXL debugfs. Errors are
> >> injected using a new 'inject-error' command, while errors are reported
> >> using a new cxl-list "-N"/"--injectable-errors" option.
> >>
> >> The 'inject-error' command and "-N" option of cxl-list both require
> >> access to the CXL driver's debugfs. Because the debugfs doesn't have a
> >> required mount point, a "--debugfs" option is added to both cxl-list and
> >> cxl-inject-error to specify the path to the debugfs if it isn't mounted
> >> to the usual place (/sys/kernel/debug).
> >>
> >> The documentation for the new cxl-inject-error command shows both usage
> >> and the possible device/error types, as well as how to retrieve them
> >> using cxl-list. The documentation for cxl-list has also been updated to
> >> show the usage of the new injectable errors and debugfs options.
> >>
> >> [1]: ACPI v6.5 spec, section 18.6.4
> >> [2]: ACPI v6.5 spec, table 18.31
> > 
> > Hi Ben,
> > 
> > Junkyeok Im posted a set for inject & clear poison back in 2023.[1] It
> > went through one round of review but was a bit ahead of it's time as we
> > were still working out the presentation of media-errors in the trigger
> > poison patch set. I'll 'cc them here in case they have interest and can
> > help review thi set.
> 
> Thanks for pointing this out. I forgot to look for an existing set before
> implementing it myself, sorry about that :/.
> 
> I'd be willing to drop the poison support from this set and use Junhyeok's
> instead, integrate it into this one, or leave it as-is.

I should have recalled at the RFC time. Anyway, compare and contrast and
select the best path forward.

> 
> > 
> > How come you're not interested in implementing clear-poison?
> 
> It is implemented, it's a flag ("--clear") for the inject-error command. I forgot
> to mention it in the cover letter, I can add it in v2.

Ah, I haven't reviewed yet to see that. I'm going to ask for that to be
its own command. We may get into some naming brouhaha. You are using the
word 'error' for multiple types of errors and we used 'media-error' specifically
for device poison. I'll put more thought into it when I review in detail.

> 
> Thanks,
> Ben
