Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48703595C
	for <nvdimm@lists.linux.dev>; Wed, 27 Aug 2025 01:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756256788; cv=fail; b=e8+0tASDtvHuzGqu8tqjfabORLaK/SB0akZ0OEryig16+J2in6nX2q3hylREkr/y2Jir2T44zXfY99mtOzv4W1eXeXfAB1hkyTiWO0ytAkCxozvynwYnLRbKAnxOGQjw8THitv3+zAYa5TegcWvdVUeslkeZ8HtFnikDhQWKH9k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756256788; c=relaxed/simple;
	bh=VwD+46NAqwdxaYm0Pthrz2phD+NMJMe/sdjEMs5Nkes=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=DHiZ/pyZEbbV00ljGMjbmkbHo4aeS0HACoMv816vWJHqgBJ37MJypBhLGilZD/zn4xJP+F0QJFnBAQY5C0DNXZg/pEsCCX4OhaMkEXCxSZ2USzUEf0NdrvAPQba5/0i4G6ALkyKdsO4avXiXUUi53Ai+3CFCJmS7LJ/wm+6tSw8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Am686L4J; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Am686L4J"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756256786; x=1787792786;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=VwD+46NAqwdxaYm0Pthrz2phD+NMJMe/sdjEMs5Nkes=;
  b=Am686L4JAoeVmMWKJSsff/WwM/bYueh8J8eLmq4TAqpSa6fkKpGWXx0r
   xTnpGJ06b+YVkkdyp1IixmcvDVi6UB7h1R+s4q3tHVxnNQr5RXmYzh8oF
   FMXp8eZcMDGDVvx8EerW/bsW/y3FqgI9kcmQg2Z6w3o2Qzpg8HyP+HZU4
   0TYC9FMw9dw2QyiQJzvHbObZWifm1PMaQ3I2KTqmX5dfhdzC1E1eWCHCN
   3Cg9albq+ed6u5nyIo8qVKXP2spOiICcpFA+7fzmwrUmqoAcx/oEm950V
   Vpcvt4J5bQud70xJior3D7vJyyHhEYOeWXBSbKUF7nzdG3Zl20uMR7cQh
   g==;
X-CSE-ConnectionGUID: fbZW934PQZuIeGxYw02iKw==
X-CSE-MsgGUID: Qg0FTlg8T8m7rC2n+S2wfw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="81099353"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="81099353"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2025 18:06:26 -0700
X-CSE-ConnectionGUID: Oa6Cf4V4TeCLvlSChgPJhg==
X-CSE-MsgGUID: S6Rw3DPXQje2SaEURfb6rA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="193367709"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2025 18:06:26 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 26 Aug 2025 18:06:25 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 26 Aug 2025 18:06:25 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.81)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 26 Aug 2025 18:06:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rmAA7nty3KY5t0TorvrvfPXIWovpYDxlnlR18lNKRalFtNUollsvQL+5l7w8xK+2ReVKgxkBvIaGP0fjVP1lYJZB5uadPAfrfefbU9QiKgArt6sXA1ajJVg4eHXEK47mHulT7nIaUPnPDrBpsA+H3XtmPiUdzG9SiiT8Atp0+5q7y70APy3B9TrgDpi8mQxbFWBcXDKy+NUJymW36x/yEIMNAIlm8lZ3wlDH5yQ5nSrhnINYPdaknQNOE1rsmXQhd+yHPD/Vr9vl8lR3qORtbbjZvXDjHRdkjdnua00Codw2JFHFOpUa6ge7f4e/MIajO79orvtB6j2Zy+9DYAJqZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m41Dw3siVLXxQe8Diwg/rjEpgTus9cAddzCLzggNs/I=;
 b=sHCAEW0u+hbmLr5pbTjAKpBh1BqJkDZDVePnJ3CT7NyZvRAJJ7K3eeEesje1DtBF3pdS1iZMSEYJlHC6IBzTEaAfTPvsHkogHyAy07AlrJ+/ENU1zzgSoPviI04Y6hF9RfOVX96d1K6dukFtpmxrYfJ+91+t+IxQawJAYo5qJgw5+/DnSWuy6dRO5EC23dLz4n97mzlBElDLQvgD4OpLox9CgU3itOP6cTMjtQgdA2pZtRHFoQdSCwlHViC40oViEE9Z5rUFb89w+PbFPYI7QeACo6SLjiPBTU4fCi402gfy60wG8BbhPFDfm8NpZ9YPTPzxgaRg3w52dYa7cMnJ0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::80b) by CH3PR11MB8496.namprd11.prod.outlook.com
 (2603:10b6:610:1ba::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.13; Wed, 27 Aug
 2025 01:06:23 +0000
Received: from SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 ([fe80::4df9:6ae0:ba12:2dde]) by SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 ([fe80::4df9:6ae0:ba12:2dde%7]) with mapi id 15.20.9052.013; Wed, 27 Aug 2025
 01:06:23 +0000
Date: Tue, 26 Aug 2025 18:06:20 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>
Subject: Re: [NDCTL PATCH v2] cxl: Add helper function to verify port is in
 memdev hierarchy
Message-ID: <aK5aDMsCRJP3tns8@aschofie-mobl2.lan>
References: <20250711223350.3196213-1-dave.jiang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250711223350.3196213-1-dave.jiang@intel.com>
X-ClientProxiedBy: BYAPR02CA0057.namprd02.prod.outlook.com
 (2603:10b6:a03:54::34) To SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::80b)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PPF0D43D62C4:EE_|CH3PR11MB8496:EE_
X-MS-Office365-Filtering-Correlation-Id: 0acc11be-3b93-4675-0bbb-08dde505f046
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?k0J1xYhngc4iZO9BuWfrUg17zDBGTOU4GzHYQkb+gjwrUqQ1VdIoSHZ2IHYM?=
 =?us-ascii?Q?1zw2at6j2E0K6WxfddmCegevjamNeC1HhrOdEm8tMwXKocItCFDG2+ufB3R9?=
 =?us-ascii?Q?fqhpIpkzIM55QB6UWoi9YJs2G3Y65tYf2WmTumwxEmExQOxRv2Zzdf7pCUpb?=
 =?us-ascii?Q?oVp/xd3JIAk5/kuoCS01gvgar5IXTnm71TkX6cmZ1VVGOPhf+VsW2fFEJii3?=
 =?us-ascii?Q?aRe/V68Gb6k1lfKBdHdxQu/4l0Rbbyk1nllrLo+HI+IIgVTSPom3L1Ob1GHU?=
 =?us-ascii?Q?Yelr6iWL+jF7WGMgYGGRe7rzjMIZDnhSI26ATqtdvO0lcgmH6Huk7QxnqUft?=
 =?us-ascii?Q?jKkfCDvi9Czqphf7+xU3lETuCYPlu/rqhxpbokl1pX3Gln0mSLSUiw6j4zWy?=
 =?us-ascii?Q?IZynUnzVR98lF+tA45KlhZklenR7e3iMkUlXkfrEuI/hX4DPz2y7HlDE15Xu?=
 =?us-ascii?Q?b+3pF4Yf4NK9qZPMb74+FJdLhJwCt8ZQyc3Ol16VQmkbOyimbQhqMgw9EgKE?=
 =?us-ascii?Q?gr6g7865wybBeL3jKUv/rtsbdzswvK4WXztOmuGh6+bAwr8biq50nWA1QLNl?=
 =?us-ascii?Q?H70uclZaktUNsLvfFy/4bez5NononwNu8AdNnHy2FETlYtwKquHnYdLx6LG0?=
 =?us-ascii?Q?VuSM4Jy03P5w1ZRqYVbEOxkSo9T8DMojZOuNvQt8yrrfoT5QesdZZeWexcm8?=
 =?us-ascii?Q?eQ/ZJSHVUbhe0IFV8LXUB4epX0yiuCx46jDS6vDLSh44X4vhQfr3EFt+/hPu?=
 =?us-ascii?Q?oOYHEp+o1jckSKqvbumo9ZWMQGv1IhjNjzLp5EqbNRm+u2lKcIUVzN6qfU22?=
 =?us-ascii?Q?ZQDZBaLu2ZFeMlfd1enU0LiHM4mhnNGjZWsxW1abf83SduEbhQUIHs5HQDI9?=
 =?us-ascii?Q?0/IdsQaT4T0tFTIjn8bhit61hxrRBUEyx1DMywtbtCTtGNmIQcH/iDVbsFDN?=
 =?us-ascii?Q?DTs/gTLjBZ8L0Tu+CuqX7Ciu2T27w4B1C4Lw2Hfgtr+Hem/zRWrhEVnX9ueG?=
 =?us-ascii?Q?h9abL4d1oorcq/nAVgN5Nh3vEwPk2JnekVchsz4mUdSJhlVu9FTTsAEgqNwh?=
 =?us-ascii?Q?3iZmbJb27zkXKvIJ2WpbriPZbq3XfzeeDFDIiAu3hTPuXZ/QxsVbCHhFi58T?=
 =?us-ascii?Q?gHB61YUD7UE6I/NHhMOIaTrLb5Z2ReBGj0OWWZ1w+af4DdsA444UHV44G+Vk?=
 =?us-ascii?Q?BgXvN5kZuvx1j71/YZm561QHsvfkxDbLAwaLpEBKfXpkhcpbwo6tuUMwFF8+?=
 =?us-ascii?Q?2S2o4W5fi5SZLycpCyaG7Uy9vVdSE+PR5jWP1vXKi4BdgedSaaFLaNMBydXm?=
 =?us-ascii?Q?uFrTxzmlCK+o7cU3L6QbbNBKLbKAJAQG1/pI+1WTWs8pGeN++m+p6F7Piolk?=
 =?us-ascii?Q?IyKBJ6FylJ90NoBT+KxZJDdIcf6gYCRjdBLusdbRsT/MBzqLpzvajnpEURfV?=
 =?us-ascii?Q?pUVoMocPk3I=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ5PPF0D43D62C4.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Q1xTyWstJQhrVg5jClueQeYMUHyk61Trs9CgRbXdc9NmbR/YA4rfnyDkcnt9?=
 =?us-ascii?Q?/OdN6bm3eO6UKqlZpwwH60kSAGBYwCC5RwMzgHWmyTp8bXi4+sfq+ljwwU46?=
 =?us-ascii?Q?yi9ZhsagMfdByDYE+dRkhrdmZNdYu/i9pMpu7piHozGS95amM0BHHa+0rrXf?=
 =?us-ascii?Q?ukubuqy8xV1LdTKVKBBh2p9aVVGoXVGiSTzjN1t4RIosn003kZliSvHRuzh+?=
 =?us-ascii?Q?nDqSnC7yar9QonGcqI7FX6p2niVNjNG0y4iSUKAQQO4rRH9kEsLyNizGH2fs?=
 =?us-ascii?Q?hBVtnwPaVp+BWHAMtSmXy1mddE+2k15hd4BTKudgssxrUGLRLPcjIPH2DVm1?=
 =?us-ascii?Q?dDeDER7SzoE8vIQW+mZLJfAVmkIhSB248l+QVNaM6N8eZsZZxNotnASIx17b?=
 =?us-ascii?Q?f7X22aB80XxdpwoF0vUUzn9ZjHyRVfShvbgKDNE1KSKqDrENdoYacL2wrNEY?=
 =?us-ascii?Q?FdH32DfVLvPOBBLNNaXld6KWLOQocNKcpifn89Vj3iAWl9P6ddtjEXSdWTQS?=
 =?us-ascii?Q?2j8WVmtlh5m6B/OCjiQ7gk7ddyUgD0bOVlR1YfOMFfDWWJ9RmhFkWHpabtnn?=
 =?us-ascii?Q?1wcy+pqw1VBezQTdDGzuvaSN2NFdsAmuEsLieONaTe5CdTng1NHGb6RipnsE?=
 =?us-ascii?Q?twQrevGwsqmOuEkVUarcH1yMdeDCTq1yGcTVhi6JxBP8/tsKUX1RJ40Sx6xP?=
 =?us-ascii?Q?cQb4VXZhQUJLp6IY5+56o2Wf+af62BAcrCDGKgGohX2ZuVT1tsYjSiU0eVN1?=
 =?us-ascii?Q?T1t15SkxTb099j/9ky8R4lXbYctB074CFaxDDAwjdI/OLsvYa7JnXni1am4A?=
 =?us-ascii?Q?t4R2spX5+VGSbkH6VcbO6xA8JyH+WRs2p/0FnZWPWqEgr5O3yQBH+35Zh2Ry?=
 =?us-ascii?Q?e57Sg7vFl1zv5yqHJtiStDSHbjJTof8j8lLwiX4vxw4lQEn8yH2rVyqTxYMj?=
 =?us-ascii?Q?oBMLV2ckzeLZaW0MQBrBxdHx6XpF+4e2KzwcCDHzuF4dPgdoEqaCIFGoFGy4?=
 =?us-ascii?Q?OuAnndmPpWKRzJrSKmGFwCR28lF3gdBIyPINs9A/rcEMomAjvi2m9KuAKBe8?=
 =?us-ascii?Q?lm0A2aS80fcsYO4pON4RIHNgQKna9/d85qtqM3Qe/NgZgfw8PfqjHr//SuMR?=
 =?us-ascii?Q?irRu1KA+iMaL7BIL+8xx0WHhdX2Qhpe4iRNwTaYfE2FBzv1EdfL7QRhdILQ6?=
 =?us-ascii?Q?pwB0R1vDxPB0nuDA63A3xhgJram6LsNbxwRkxCpKQwqN/RTqYYs6VDfjYE42?=
 =?us-ascii?Q?t2SiYTNBwLCH+vMSrRNAU7WUPc38DdPnQJdMeCINFotPXtBsFxoScF4HSH74?=
 =?us-ascii?Q?9iF89vt6ONnm6v04GmBIeyJmohSg3R7U8+FqN1pcZ2PIMqYyFAVcG7ShoaAM?=
 =?us-ascii?Q?TcluVMWwshdDUpyH6qUXYBIvfLkadLcqGnSpDpZGCWvxT2TYA/ERb6RwQ9Ix?=
 =?us-ascii?Q?jzbU6ekLvJjvEhF+KZz8P3aRAH/Lk/yo69tXOTiwcORqXX9NI/PIR49Iyi/b?=
 =?us-ascii?Q?Q2kt9fD7QpE4GcjZWcWsa5jk8xesqrOlbUmYxsDm4UffIk/WAPCQbzq36m1N?=
 =?us-ascii?Q?+60fOzz6O8v1CwAPwkrRXzPsD6NieB7qL/Uujrmnr1Ih6tYY0T9nqzx30w0D?=
 =?us-ascii?Q?Ug=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0acc11be-3b93-4675-0bbb-08dde505f046
X-MS-Exchange-CrossTenant-AuthSource: SJ5PPF0D43D62C4.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2025 01:06:23.0490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6egVfWwbKxWGOizWKhw9OtDPpXXJsB52AKFOkM4+ja08ux3Ij/EgfokeGFnmdd0GOoRRfjUiwfKcmYXUkHbEPfVvuTNFAfma5J1rOqoVQl8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8496
X-OriginatorOrg: intel.com

On Fri, Jul 11, 2025 at 03:33:50PM -0700, Dave Jiang wrote:
> 'cxl enable-port -m' uses cxl_port_get_dport_by_memdev() to find the
> memdevs that are associated with a port in order to enable those
> associated memdevs. When the kernel switch to delayed dport
> initialization by enumerating the dports during memdev probe, the
> dports are no longer valid until the memdev is probed. This means
> that cxl_port_get_dport_by_memdev() will not find any memdevs under
> the port.
> 
> Add a new helper function cxl_port_is_memdev_hierarchy() that checks if a
> port is in the memdev hierarchy via the memdev->host_path where the sysfs
> path contains all the devices in the hierarchy. This call is also backward
> compatible with the old behavior.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>

Fixed up the func name in commit log.

Applied https://github.com/pmem/ndctl/commits/pending/

