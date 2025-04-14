Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B7DA1CD213
	for <nvdimm@lists.linux.dev>; Mon, 14 Apr 2025 22:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744668624; cv=fail; b=KAGkg7kw5SoWP0lGS1BCQ07lPI1bdPrHRBwmWHKspzIX56gWPG/56Fie14rkhHsws2eBqjgmXAa2ZlPX1h2P3mN+VmOvI3wKuA39ReaNBRZf7tVcOutlRZSCw+96LsGZBMyGql9cQmcIjujPy/CCq4+qUz1w+NXG8np6nvLc3Mw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744668624; c=relaxed/simple;
	bh=Of6+So6p04phpiIFaiKGLO26sCbke4DTM3FQ+8HPXDQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=iVWOkp1/OuehFdgFtrSwXF8NE07N1ZZeL7URevsFUb4eYnlhjOjjLqAw6PJkaEiaRZ2u2a6PL8jtJAhplCr3+6K4ae+271a6z0A/9pW1dxP7YuNc/vZGJA3AzdJpMCsKuAOAAmv+0NK4S2UUOF9YB9Br7Dtvu9FPInrJK8bAT2k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ghk95594; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ghk95594"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744668622; x=1776204622;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Of6+So6p04phpiIFaiKGLO26sCbke4DTM3FQ+8HPXDQ=;
  b=ghk955945HDkMwMc0FqyCVnHJ6ntG0aBLxEAJ1xIQJJS2io7uOqTMwFp
   XwbBaVZzUBL9A47edRuInwA+dEJS27VmF7jdHjVlnI36wU3fibvsWfRWO
   ANHdS3K7+8YqjOAKy0tFrsA4m1WzIzjfsLY5WrTNDMjpZz4DzcXnLw4na
   7ir84PXspDkgbeSQHw45BcpT2sqFTGImHyUk/l4kfZySobvRsmPlUKCBp
   9B6NlzaEkWVcgwmSk/KouEkfKaPSljlaSN/PcS4LXibBnkjtuq6sVKsDs
   /Bwj95rO2J5lfdvbrSHRChNV3f21+UVss9nzSibi1wpXTis1fvD5NAr1K
   A==;
X-CSE-ConnectionGUID: ov7kVoMoS4qvg8MrWLjEqw==
X-CSE-MsgGUID: L/Ufqfd5Q2CdTiuvgJQ8UA==
X-IronPort-AV: E=McAfee;i="6700,10204,11403"; a="46167463"
X-IronPort-AV: E=Sophos;i="6.15,213,1739865600"; 
   d="scan'208";a="46167463"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2025 15:10:22 -0700
X-CSE-ConnectionGUID: O6xiQqBhRzCOy157y/u2Kg==
X-CSE-MsgGUID: rj6Y2ZrxSF2Rft+wNGcAkg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,213,1739865600"; 
   d="scan'208";a="129707358"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2025 15:10:22 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 14 Apr 2025 15:10:21 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 14 Apr 2025 15:10:21 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 14 Apr 2025 15:10:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DKIxfnd6pZsQbYaNjFhgiCXGCzyE3snPDQlRT6J0qluKxBeXpLgeMArzfA3wk8Nl3I1okHW05jD8VcKpEmtN/xHJ0hKJ7bDk3+on2OGdm4qgFHl6+tPsjOwXEdTjfmzyMaib0YY2BnaHdmJBXwNYr2pxj0Od6dKb/CEkAFYKr/JuyIpMGeKlNGAWVQCccuFSr19ipztdV5qpXoPWvIWF0A5e1BhUbwz/JvNj/Lkkwa7nFp55nxVwENgUSmpqBNvDBlg7eZ5krL0l7+gNW6ETADH21i/iJTknaYRl3ElWvP4tCjyH8nppNaNC24SXT9JFzZ/EtDvPU3Kp+QmFCJgpTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sfB/hsEqSH2Xk2SrkwySr0HmrTV4itPU6L0A2QM2n4U=;
 b=OlpN6LPVyJ3jvhJ7gP0KQQ9j0Lo2K0Hb3uaYRaIPsJvNPMYbngqEtV5RSfGHLBxU2Cac/P+i9J7ZFNcyxIfa8DmkegutdWuoQqU8qNoVed7NxZG3V9mF4oH0zSFXn6eJb7F3QhrIcXOT5X5Sbj2CbhUtkBXTk7xPUjypb1r4URmJJ+Tyeu2UtrLOEDtIVSbUOtZjm36AbBeyJcdBCn8Cmrg8pWJAJ9Fpw37AKFQETOmfkyay9aABSHkQZIKe6CMhCJ8twr0uf+YKYTPfIYVdTqZhfVWiIss4T19ar9mglj5Ont/t7sF1rPSqDzYbHhepZIA9BF7caGlo5k9RXAvqlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB8794.namprd11.prod.outlook.com (2603:10b6:806:46a::5)
 by DS7PR11MB7932.namprd11.prod.outlook.com (2603:10b6:8:e5::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8632.32; Mon, 14 Apr 2025 22:10:19 +0000
Received: from SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720]) by SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720%5]) with mapi id 15.20.8632.030; Mon, 14 Apr 2025
 22:10:18 +0000
Date: Mon, 14 Apr 2025 15:10:14 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Ira Weiny <ira.weiny@intel.com>
CC: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, "Jonathan
 Cameron" <Jonathan.Cameron@huawei.com>, Dan Williams
	<dan.j.williams@intel.com>, Davidlohr Bueso <dave@stgolabs.net>, Vishal Verma
	<vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>, Li Ming
	<ming.li@zohomail.com>
Subject: Re: [PATCH v9 12/19] cxl/extent: Process dynamic partition events
 and realize region extents
Message-ID: <Z_2Hxo1DvMnp4bhS@aschofie-mobl2.lan>
References: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>
 <20250413-dcd-type2-upstream-v9-12-1d4911a0b365@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250413-dcd-type2-upstream-v9-12-1d4911a0b365@intel.com>
X-ClientProxiedBy: MW3PR06CA0018.namprd06.prod.outlook.com
 (2603:10b6:303:2a::23) To SA1PR11MB8794.namprd11.prod.outlook.com
 (2603:10b6:806:46a::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB8794:EE_|DS7PR11MB7932:EE_
X-MS-Office365-Filtering-Correlation-Id: 52559831-ad0a-4e12-7b10-08dd7ba12463
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?fzmvLF2lBU4zxSM8an1rKZAVsMlNoT4D22gaXHOyVWSPlgNroOF/OQqip1/u?=
 =?us-ascii?Q?c+YuqvOLIAaZqsRmlGv2VTq0ruhg/uIAiQsnICR8b9HNNUwCpbTuOn8ng98K?=
 =?us-ascii?Q?2aycr/pACkCEv46VbNiPPN4MCjx0+4htJ6vcbEmDNzXL9CDAQs/W8/4NG7kr?=
 =?us-ascii?Q?16SyOa2AoMIICAYIHMknbKdrDYKO9rxUmdmB0JZrmFZdpH/phvLPe7ryMU9G?=
 =?us-ascii?Q?qo39Kw4DtcqtetSKc/sNq+xcMLkDnDxUqSHB8UEszErIcA/p0/PyjjVLAU64?=
 =?us-ascii?Q?W8U5NFivqHyIOCfF97v4Cj77GuB6a68p3x+cUBlInhVDUJnHwJYvCxPLL2bt?=
 =?us-ascii?Q?WjvKAH7WnuPU+Xn9KaIEwjIYpjxc7BSwTBW+tb/lZhfcIwYNtu46YocvBrA0?=
 =?us-ascii?Q?RXQU18tT/CqL05sKM6Hw1ilSA5wml1AcyKYHyBv3Z+BqqvSHMF6aAhek41yV?=
 =?us-ascii?Q?JPZHJ5/xFyvRe9femoPvnC7vNVyVBlPH9ZoVBWzdrpI8pKWy/w85Al5pPO2H?=
 =?us-ascii?Q?brHJ46B78zlYkSinbM5+Ycr2fKgJ9obhTikJBGxWQYwIjYfz7Bk6wgIlNT9Y?=
 =?us-ascii?Q?8bwo3nrjeFilgcjIilcM6y8dP+GnqfNp9tKdAzbiN7JN7Kju1hLaDlT176yS?=
 =?us-ascii?Q?a44s5heOikAYWC/LsHt8kroZHPGKhhbewuGFC6+coyZ5vMbiqosT0u/mwsMI?=
 =?us-ascii?Q?SnEfCJ1WqZf/6H+GxN7vRJo9z7Q7dl8lsFjJ+sfIr946zIjRn8G8gCiUgjTp?=
 =?us-ascii?Q?xjiw0W8Af77KlBciZxTeYIBWu0WgmMWG1ipqo5Ymg4A5lTF0jzmcePxPSnAa?=
 =?us-ascii?Q?7vKIig7VDXVgPWAbWE0Euc57QeCTsw1n0KEeHM5ev4DFyk3tjuwZYZdlDqQW?=
 =?us-ascii?Q?w/qtGVDk15hy3916Mwm96l4iuFGbwjQfnWsoEZSg7/APU4iX6+Z5752pGbOc?=
 =?us-ascii?Q?9mgtZnTM3PG4hz/DgZLaalOzhoxkN0J44wALdNJ7yTr1vIcAxAyAcWngNad3?=
 =?us-ascii?Q?dz4Tz2rc/DibrqLbQ8TL7a63VdjPBFPrT6cgBKeCDmEFT98EiNUTEjVFwBCX?=
 =?us-ascii?Q?tf1/Z1wkg6rXEkisY/aUOpA6E79jOwV4TwRG6FqSPIkr+9ZfzZ/DVPbOTIbj?=
 =?us-ascii?Q?J6wZOws1Zc964c5WmgZvxAUtTUvHRSXqlYJ1tascgudyKU+qm8fQDyGb4Hmo?=
 =?us-ascii?Q?S5LlN6MY7zT2zoKeUYRRUpY2PbQpSLTv7QPzueW90mjs7aFf43rcb1Ur0OxP?=
 =?us-ascii?Q?vIUQmzqD5lzBO8pnrKfMWfWswDpSnZYx0LRLV/YSjOG3rMySG0JXacfEdff3?=
 =?us-ascii?Q?vEVLnlp0/MJOS5oM45N+h3dZHyJxVtk1P1BRFdf5u7g2P5xHHY8kdfMSeu1O?=
 =?us-ascii?Q?d2/7vk25F1TbVNLngA6G7X+mSmPbBWtYcEpfe8AEgjyK/uObOxh39ZCIdmAa?=
 =?us-ascii?Q?RbIrrwEfAR0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB8794.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oQmmDKT2V7vASqRTvUHrvuwDMydKeQ151Uf784knMAzAKEgLSSskxwEDzYgt?=
 =?us-ascii?Q?rbx3+aU3wxb/wjPqHNOgaliyODDosloA5+rtooqoXyKzb2JCR9WpQRc7n1oG?=
 =?us-ascii?Q?AkT7fbiLv7zJUThC0TYCkCA+n7D9c0BcGr0URTyWjs1+T5T/MxCq5hq48kAx?=
 =?us-ascii?Q?2mSRHsShVaS6gG6KG2q/US1ed2rNEZCcOCVy8zA6E7Sj2aVRh1FW5xaleSZT?=
 =?us-ascii?Q?Gd2V20TGTOXrsVaQYQwYZgNmcsmh0LY4b1i3V/NeQlE25jeuoPjF9zdCimNS?=
 =?us-ascii?Q?qPKuf81u+8LHVlBZnk3FRTL0QNFWXwyVIAl6awTzGlKtdUUeRVK88Jhw7Vr7?=
 =?us-ascii?Q?wUJxTBaBh9ULiiOs3teGbUpQTJlPXfszBtUTwKtDGzNuBI62/Y5oGwT4q2o9?=
 =?us-ascii?Q?WFjpHQKvkbq5mzDxf/rN+RBoPdEZWl78eXVmiy2St4g9ucdw0CZC7RNTQaNL?=
 =?us-ascii?Q?Y0TAEsaZKFWW7WQsky36Mjhw4FaBFbCTeGxqOM4Bkf28V7ngVhhS11k2suMR?=
 =?us-ascii?Q?IbiXJmPZ2arRcOVwuGjtDPa+tWH8d8SfSWd8mBx19gN44eEbGFdbKimEfg4l?=
 =?us-ascii?Q?vK2HsSn+D//0C1JHIsmyXWXdqN/LIGp01mjCkP2Cmcu7WoEJdk6W8qD/hBEq?=
 =?us-ascii?Q?cl/X2/wDZtlxqdk6iySGHiUgO0Zuw4P2fMw6dkknliBWJt8yMJb0figjWzY8?=
 =?us-ascii?Q?LyvLEGd5ET3v1B5p2z4nBX75+iwVNk+1qceI8k9KRG8VvbutGrfrFxF6s+o+?=
 =?us-ascii?Q?/0DN23xUrap8BsRKc8EA/L8I6y8pTQD1a3lvd6Xxhy1cI07M6ZRkCRJ4K2Oa?=
 =?us-ascii?Q?NI2YmL8wosAysKn3LSqRkVGLhCN5VXZ75waZG550WjmeycTXnvSqj/zdbUwU?=
 =?us-ascii?Q?BArwLvvHwqY+uFZRMVpjlCV1KlDB+MVJ5Fj2GzQlCtYbB7zLOt5MmSyc0c8Y?=
 =?us-ascii?Q?8oOWVlqZM389Vu26v2gvr1oCA4qAUx2ABqq1+etU/z/GOeT01mxpvEubDO6Z?=
 =?us-ascii?Q?tJtXkute12cM3k6kih1WcQ9lH3Jx91gSBdPn4uEsn0XPZVtMs9Uw5WS+wEvX?=
 =?us-ascii?Q?HJGgcloWG3FReCJbr0zNgWyCfRm3Pmct8XLeq7BMb9HdzeqKX+w624hIOhvz?=
 =?us-ascii?Q?kD7cfuV0kdOWQFR3KvDr1pvuKnRUwKWLDQHS6TOXSu2maus3cPKVD8uXGzMf?=
 =?us-ascii?Q?HWz7D/rXevM5zmXhGOBQXbkqUivJ7iD87/2kH0U93DKTY1UyFYAKINgOBzKz?=
 =?us-ascii?Q?NdSGVxOEE1jjnsNiMXNPHugCmRZu/ZCV0P+ZXq+HlS514R0bxKksgBuXjEp4?=
 =?us-ascii?Q?4O4A36vo92unvMPfaosAF6nUsh1N2zKtz/VHGP7MbN1RTKY57HIj0iFlI1mW?=
 =?us-ascii?Q?YSheByvjEdO8/OGxwXRKGa1W+FHlHfTw4FQIbekvaKyOhZQXN1ZRJHxU7V/r?=
 =?us-ascii?Q?NhVVJ1iBSrjtK+j3pyUE1MrUvPRispssk6i63HVzOVLYPhJgR0KDMjc6IpjR?=
 =?us-ascii?Q?0kY/iGHT1ZdJvmKBXEA7CQXd3t9TzqyUY9kf+CiurgY83SDrG/+6inySRGYo?=
 =?us-ascii?Q?ZYo6m0Sx6zC5hKWPiFWKK+V8nrw0lHDExz4gTvsnAeT4BUYbrtL8wLdwGxoQ?=
 =?us-ascii?Q?zA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 52559831-ad0a-4e12-7b10-08dd7ba12463
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB8794.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2025 22:10:18.9045
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zEtLWxFyvAzHi3v78jH3TXi9JPVVVwC/xJyhNUwG5fGJyU44gRpaDu/QVL9jRqsAybzisllP9V1CcSHyjX2ByuzWUSJLyWhRMmQJnFqDlpA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7932
X-OriginatorOrg: intel.com

On Sun, Apr 13, 2025 at 05:52:20PM -0500, Ira Weiny wrote:

snip

> +
> +void memdev_release_extent(struct cxl_memdev_state *mds, struct range *range)
> +{
> +	struct device *dev = mds->cxlds.dev;
> +	struct xarray extent_list;
> +
> +	struct cxl_extent extent = {
> +		.start_dpa = cpu_to_le64(range->start),
> +		.length = cpu_to_le64(range_len(range)),
> +	};
> +
> +	dev_dbg(dev, "Release response dpa %pra\n", &range);
> +
> +	xa_init(&extent_list);
> +	if (xa_insert(&extent_list, 0, &extent, GFP_KERNEL)) {
> +		dev_dbg(dev, "Failed to release %pra\n", &range);
> +		goto destroy;
> +	}
> +
> +	if (cxl_send_dc_response(mds, CXL_MBOX_OP_RELEASE_DC, &extent_list, 1))
> +		dev_dbg(dev, "Failed to release %pra\n", &range);
> +

smatch complains about the above 3 dev_dbg() messages:

memdev_release_extent() error: '%pr' expects argument of type struct range *, but argument 4 has type 'struct range**'

snip

