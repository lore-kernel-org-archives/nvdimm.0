Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10BA212FF69;
	Tue,  3 Feb 2026 20:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770151107; cv=fail; b=KFYFhHsb9WCyb5TtepGS4SXDNN0cSaeVMmb49iDiSRs24nBv9+JGLyOsvktD2ZZvAKYurq0kwGQFZ3RhPNdVwqjFeaRLpQsXZbzp2/UuaGaJwssIp/dqmKUUY6jOmbZYkkZpVc0V7cs9FDaNS6og5PKtqauqNVz5jwOySL1lsPA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770151107; c=relaxed/simple;
	bh=S0eFk4G9JuiNAy7WV5BdRsSeJZQ5x8lCJAzsA92hjAo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=IsFsrq/bdtlDc6dkKvS1QNzMYB/+ccpKVMjdvxHL+CXAhdrXVpO/4av93pShxlEcnR/KG2/bzBM57AQeD5HplI2fgVgjeLg1PTE8+Yu7HuxoFc48eoXoMRb6LnEhKb/qmd+ACfn4CA668oPv6sQODHC/Y/H4tzCas8tsjzfhR6k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dqUh+avh; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dqUh+avh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770151107; x=1801687107;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=S0eFk4G9JuiNAy7WV5BdRsSeJZQ5x8lCJAzsA92hjAo=;
  b=dqUh+avhbMOOUJXuxIyyoAJvKC3iO2WWx+8rG9LRk+RcapEHr0q0k7JR
   V5v65+cuUtc1eqss3+tUlVO2UkcBv5iX2QTKhm6lbHWZVN2WEIT7+Gog1
   6jTAG8IAzjHQkqviqmL70f49Lf6dYEZmiPg6ggfwNvpYRhOuRP3/7TZjb
   dI6zunEwH9KGByzUcq45F7XSSq5Y4eM1EugxdSJyt3MgIj7baQswU+vvw
   naLAxYMRTCI4VZhqyP1jzF4/1m0kUt6vwUc0a7/6ZdHToGJ5xIuJBReYJ
   EqhuBvqOW4o8O14BaXw2/rVRWbggKXxaWapfnL8zmq0mjYS4J8oUhC8Gb
   g==;
X-CSE-ConnectionGUID: fU/6278GQ5GR2r5ayAhLrw==
X-CSE-MsgGUID: KobhqOzpRwWE0Nqxb1NUWg==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="93984922"
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="93984922"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 12:38:26 -0800
X-CSE-ConnectionGUID: 3L9c4DSlTsej6Cys78GD4g==
X-CSE-MsgGUID: ezyYkcuvRiyqscJGEd7wEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="240638336"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 12:38:25 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 3 Feb 2026 12:38:25 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 3 Feb 2026 12:38:25 -0800
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.65) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 3 Feb 2026 12:38:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cCXmdXEDi3MhdvMDiUlVK1n8mxtDkBh+trcktdEJsaB+Y8PXolbeLaWQe9EgswdUaSDmiREDcapkt8aayCxmPi3yHsv0QpauyeTQmG/lyt2SrBSJB81mK5+Eb9TqmBN6r5BzM2CjNw/K0XPZhrx9UX6CjaMbr/CWsYZ9jAWJ8AVVNGPji7VXCttEDy57krrOxEq3m8nErIF9H091TxynPyj4UiK/41Edio1b6PeM1LT+CxyPHaChwvfUJHijLCttqgYkXskPhUT6A3hO58sK5090KYgyPuEF/IdQfreBwNvLjsnDKVu6xLMkqTtOZwa6073tWTXsNsOtwcf1zJcHMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nmZAh8OD0v3HckgVj8O9YlAfatzaOxDzk46ibJiTVWA=;
 b=hl6KltALb9Qp2qPInQSVzpOQSeOMMy89KfdpZTxJ51u/5DZoO/JCgNjTqGcZuATLdloMvIVtzKU55NXtnNZ6Za/zc45ZN66WUxabrXev6ZszCBZsGIvio/zd84YaYmJP0yOiyAUAFXtNm2VF665LDptezpXmQOjwebWW14d+Y/f1O5/KejPa2tSVVr2UXp/fFOHkfglHEYnS0zJ3FzYaqs1OLNJjNufpzcRyVEXYu3/m5Ma5y95R+CIJQ3rDG+cPFJ36O4Figj5zzwRbwyrCbd4pWew7+2wQPzIyuLkvr/V3v+BI/db/HDq8Gbsp0rtZiUj3vajzbjCqfco6LmF5TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by SJ2PR11MB7456.namprd11.prod.outlook.com
 (2603:10b6:a03:4cd::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Tue, 3 Feb
 2026 20:38:22 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::1340:c8fe:cf51:9aa2]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::1340:c8fe:cf51:9aa2%2]) with mapi id 15.20.9587.010; Tue, 3 Feb 2026
 20:38:21 +0000
Date: Tue, 3 Feb 2026 14:41:42 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, Li Chen <me@linux.beauty>
CC: Pankaj Gupta <pankaj.gupta.linux@gmail.com>, Dan Williams
	<dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, Cornelia Huck
	<cohuck@redhat.com>, Yuval Shaia <yuval.shaia@oracle.com>,
	<virtualization@lists.linux.dev>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] nvdimm: virtio_pmem: serialize flush requests
Message-ID: <69825d866edd7_44a2210014@iweiny-mobl.notmuch>
References: <20260203021353.121091-1-me@linux.beauty>
 <20260203052616-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260203052616-mutt-send-email-mst@kernel.org>
X-ClientProxiedBy: BYAPR02CA0007.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::20) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|SJ2PR11MB7456:EE_
X-MS-Office365-Filtering-Correlation-Id: 04c43345-d79a-481e-ea27-08de63642be1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?y4L4NqOesMP0yiillOBm9GCOCHaK6n4L3q3xbBk/I5g19A1Y+tRtXS0S6bqZ?=
 =?us-ascii?Q?I/EkCfDUleMGO5IcQYk6h0szwl/lDjzQBYzPCS0R+eoKDYhk7/qYH76VRMrh?=
 =?us-ascii?Q?hSpUGUQjE0szpBMNK1Mc0bAGtC+5j0mBVpfo1lJVMfSGs0m2qt/D4B0sRO+J?=
 =?us-ascii?Q?Wj/Qp9oTm39rdcD76mtI/rf7CR1//H8KdbFRoYKznXgQCIaD/o6Wj4FaJDlj?=
 =?us-ascii?Q?B7dgc8vV1bwal4orKBVJAK8CtQZbJUMKcG3cHw7VUi5gGUvzY/+/IAcxJ781?=
 =?us-ascii?Q?gYF/x9oB0qXu1xuVW0uePbvZS3voMRyC5X2Vp+7OQzKEBD7mY63vMQY/J+K/?=
 =?us-ascii?Q?ONSsXi0nTc1QlGNgLsfb+ykYggi0pBBZUsFeszRy/jr8M4ClEa8kLg31kvzN?=
 =?us-ascii?Q?RIRCKgYVLeuuzd/sp4Zkg8q2UIif4IejcWDkk8FFAYyW2SU8jzgL8BgNQX3C?=
 =?us-ascii?Q?CAmfEkXfOU897FQhmAi3bD4/lsIIWQUQdMiJfvpJ/+4oZEcVf5h5SEb2xCwI?=
 =?us-ascii?Q?+WGNGW215zGwjZJqGRrpaaHgQ7NeUzT1Z8/1S3wTGmGazuYV+bl3VYq1ATDC?=
 =?us-ascii?Q?C4tjIr8t2x0YxJEcsdcOMycOouE7Qtt5hC4u3HiShhvIjIP4Ngamk+d6FFNZ?=
 =?us-ascii?Q?TL2PRroel2/xLBuit3gHhx33Fit4SjydMoyxyPD7lZ/fVaXm8KXG7sPnEhjZ?=
 =?us-ascii?Q?3jI0rsoYqFcaqElxynuB/yLzfteqRuhbKpeGWHx05+cJMFwRqcoYBTDKtTYc?=
 =?us-ascii?Q?X7PAN2fLQjUM+INRvfzW/S067vC9hYHc2gLAVtAzlmw+tHnOGWSNrhQwUMsn?=
 =?us-ascii?Q?ar6gvMJ+4pU7pQT+Tx49VIMHgAYqu79OzF4zdzX4VCt0kI/vdgivSTjcC5jR?=
 =?us-ascii?Q?4RoDGrei/K5xitO57CwdQ7On0gX4PD6YOodIBS7CvoWwyN2e3dGlJP8h2A1O?=
 =?us-ascii?Q?xH+jHS6MmwBZ3EMyLMBxl8CUyL9gJzqw+LPbifheQ0rXRKAoKmBrviltHeSE?=
 =?us-ascii?Q?iYoQ5lLmoqqzKiKiIIJ4gKF/xNK+TGUMoXqcxS1tiSVEEVZmLr5TOVHfMVkv?=
 =?us-ascii?Q?4oLzPZ0oG5QptIM4TZI2XO02jARcxbKUDEUM+b+jMGZhKr1oNPw39Qa3cUD4?=
 =?us-ascii?Q?l95VxVSCxLt8Xh5Qhx+QmQarZMMUytWBsRubMucUz8ICY/05oZqnh+UY7B2W?=
 =?us-ascii?Q?z45Vkd+imp+pfBHN4m5T974765CpsZimS3cQDAju7xL5G4OCzzjUdnQIAsZ7?=
 =?us-ascii?Q?ZCyyDe6yQqXwM5WT0tUt6vsIVssIGijFogcXll07Bqjen3BOrS/+9/pYjbo2?=
 =?us-ascii?Q?Hn++2KA++K6DuDuzBdq3iGclqTCvrr5w83AYBcbK97fIPxH5zMuOQamXqG89?=
 =?us-ascii?Q?sr2ubefCxErZ26fEFApQsQESNhLnlj9iqCNSmtkEv99KQwWZKDxWa9ZWbQNV?=
 =?us-ascii?Q?p++iNIG+QncneifSLp9Dvi50jfk10D+Gf2CjIbmQ70OxIlhZREscorugqopR?=
 =?us-ascii?Q?Jn2X0YTWfeh2OdJRDsm0B+jXsxVOqBryOMFvZyBVg5aXLpUyB6vTcpk0cbbQ?=
 =?us-ascii?Q?VoJeg1VE9BNJ+lnKYUU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?h5lgejW7L0FqcikdRp07f8PSNZQeEqf9KfGVjrJf4d6qCr05M3v2S4u1yOjr?=
 =?us-ascii?Q?MNKNUVyGuSLsb5RWwZLwAZehM2xWhZMgu3+1wrh2CDMKB+/tuniIOXPQD2kv?=
 =?us-ascii?Q?zCHhLinWBXZMjK1TTPfS3jFFb5MTRrE3jIJSfwE4xlFyhQNEPE5aak8n5uWZ?=
 =?us-ascii?Q?PbUI2hjSsJuONwwKHw6oHMC4Td1gtG3o8lECqqQwqhr+HZhgv7+4Yh8+/9tq?=
 =?us-ascii?Q?0zd0swHD1L4qzW29DdY/uezw324OTz4qMDW0apmprp8YJcxgICp1NYXiWAkF?=
 =?us-ascii?Q?oWViYtT3OPA93fiZHFnerQxl64x0OhxFyJESKOc8wYIHbWcGsZkZBBe0wsxs?=
 =?us-ascii?Q?jy0SvgQJt8YfGNQHiabKpVWX6LCEhGpUGG3Oe9YsB0cKhNoeVnwl2MZVuhFU?=
 =?us-ascii?Q?qWisF1MzKeQcqH9OvFswnE6U1CUypf8vz1YanZP5g2JiWOaLxmpb9D4bsuci?=
 =?us-ascii?Q?nzFQ8veMSPc0bROy5bTP7JA7l8ew6h5CGDHZQzqDPRsEgQLTL7Z80ipvScCn?=
 =?us-ascii?Q?5GDk80DvlEJL54vWTBxBly2v4kmwKsX8y55alBaHLK9BLAYFoY9FAqKdR1CG?=
 =?us-ascii?Q?PzBALzLvdqJZxOTYk6r2xP4i7xJvWjpkPCY7EFR4PofitZMT/xYxqgoogjAP?=
 =?us-ascii?Q?eFbQTKfOVX7FH1S0MhM56YTrgCBsQncZYnBIjMcKSRhXoUZyXfnznxKHKSYv?=
 =?us-ascii?Q?4aI8URa0JVxQ1jrqP8xIVCCci5uCVFXGm2mkIS3s1Zy8y1u1di+I26VSiK6s?=
 =?us-ascii?Q?n7lZvRFwDIWIAqsUEEKz7/Lttzkmo6nIImRTG/Cg6fKz4aARWpKuLI4cklDH?=
 =?us-ascii?Q?2GWSvNgpIlcnJJFrq4QREecZiIq7jNjGM8Dk4TU1k7o1X7UzvkvqdtBWreFa?=
 =?us-ascii?Q?KCHdgdyNj411EtppYiT7LyYhIq4OPXkXAQRW913suQ+mTuFC8+MpfOzDndlB?=
 =?us-ascii?Q?dbn9thiBoWz5cgJiUjaCdyGk2vIZCAJVK9OU07+ZI+/gJWsDAZvOQ/tPy6yM?=
 =?us-ascii?Q?DogoQAliWqj39TtGs+Yfr1UgtD4M2dHRZf6ta3DtyoM8QP45ybIqtEU7LCXz?=
 =?us-ascii?Q?d+tD3k1hfxgo3fCiAt8U+a0cPpkWRtVtHlTc4tyao6lWFk4gAA/vnLJ9ElUT?=
 =?us-ascii?Q?zog+KWlRpiNAnvwpPisM02POylPTi0Ou2MDO1MzGOl79SX2/HgeC7GmxJNfJ?=
 =?us-ascii?Q?othAuPlnUfRkJMSSCL29azaoYhhMSCkly+xFUYz9Q7rZJqw+GRPWhAzfpA7P?=
 =?us-ascii?Q?E9CCWAJubf/y8xwqpr1kOS4ifS80QoDFlMTweGQasAL+Qfr4NEV+HtNE3qon?=
 =?us-ascii?Q?xxTkfclCsQW6OfRpzkWOxDPEOOhWXNe1r1OztUWVliJ1bz2nd+kDsl4Tv+eq?=
 =?us-ascii?Q?o0zibWaH9xwURu3dJSyDBYmBPFmakelkoIeovhbSX45AxIA9AHSHL93ME3cX?=
 =?us-ascii?Q?YZ7bshV2vWkPZ7E+niTkCNa8iZh9fGJsBS1wg93xQE7VTgXNy9TlNjtcghot?=
 =?us-ascii?Q?4/XC8QPjh+LR9KzFYipsWrP3wujySDt3GnaSAaFRxSsuT4Wvnd8fgAj9IWug?=
 =?us-ascii?Q?o2e7gYyGCAltaKUvOEaR/+jE1SHswZ2muDTVwQMjVHkoZ45r+nrmV3hl02TK?=
 =?us-ascii?Q?HEfBm6ucCpNSgRsUYRyCvbYMjMAjS4omXk3kjccvDN9YWqzrHOa2d//MCH2F?=
 =?us-ascii?Q?9Ly2tXGXdftIUSPpS913EMYqW15YDX4WJMZqdklGKdkEtmI9w+w+wpyMB9Pn?=
 =?us-ascii?Q?I2L9icmQYg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 04c43345-d79a-481e-ea27-08de63642be1
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2026 20:38:21.8505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D5m6mjglFOWX6q+l51YxZ7vItB9XqX8oK8TS/Wi+5kNcGUNsAjbzDqpi4t9hWjgGHcGW3fWrJX6+kuEG3jAMag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7456
X-OriginatorOrg: intel.com

Michael S. Tsirkin wrote:
> On Tue, Feb 03, 2026 at 10:13:51AM +0800, Li Chen wrote:
> > Under heavy concurrent flush traffic, virtio-pmem can overflow its request
> > virtqueue (req_vq): virtqueue_add_sgs() starts returning -ENOSPC and the
> > driver logs "no free slots in the virtqueue". Shortly after that the
> > device enters VIRTIO_CONFIG_S_NEEDS_RESET and flush requests fail with
> > "virtio pmem device needs a reset".
> > 
> > Serialize virtio_pmem_flush() with a per-device mutex so only one flush
> > request is in-flight at a time. This prevents req_vq descriptor overflow
> > under high concurrency.
> > 
> > Reproducer (guest with virtio-pmem):
> >   - mkfs.ext4 -F /dev/pmem0
> >   - mount -t ext4 -o dax,noatime /dev/pmem0 /mnt/bench
> >   - fio: ioengine=io_uring rw=randwrite bs=4k iodepth=64 numjobs=64
> >         direct=1 fsync=1 runtime=30s time_based=1
> >   - dmesg: "no free slots in the virtqueue"
> >            "virtio pmem device needs a reset"
> > 
> > Fixes: 6e84200c0a29 ("virtio-pmem: Add virtio pmem driver")
> > Signed-off-by: Li Chen <me@linux.beauty>
> 
> 
> Thanks!
> And the commit message looks good now and includes the
> reproducer.
> 
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> 
> Ira are you picking this up?
> 

Yes queued for 7.0

Ira

[snip]
