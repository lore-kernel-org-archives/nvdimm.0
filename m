Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4464530EF68
	for <nvdimm@lists.linux.dev>; Tue, 24 Mar 2026 23:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774395648; cv=fail; b=qW0WEjBBIOT7KVrq9QAlx0O4T9vrqXxKisbmK9BCTxmK4S2Code9KY9UM2XVv+07g82aMbX4u+7v6ZLgwsvNFtFiUECSpMOIEpO6J1hEOMHUomn0dNahnX5kw0cw/31UCwBrWsZwshhI7zluQJKOSDt2BABLYyD30wYd6EYIpms=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774395648; c=relaxed/simple;
	bh=j3SlyzFLQTf7Zu+m0Kxwrmv9tox//o9b4l8h/hFOOSM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jVQDt98alKB2+b7V1ydBuQ+DR0QUxTHopFNFFMYYtkUawxcB3/Yvd4zYVG59fl99RvfkaGkkoUYReAbTsTm0KhwpMGAkPJjXDsrqXhSX0PRJH+RtZ7V1gTAGIbZhHLdbXLzajcUNyDhVJK9mAPj2686FhBIz+NtrSiX5O0NFXgw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jZXKdJqJ; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jZXKdJqJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774395647; x=1805931647;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=j3SlyzFLQTf7Zu+m0Kxwrmv9tox//o9b4l8h/hFOOSM=;
  b=jZXKdJqJzNGJq3DagKsQXDN8ytWulW2/hfR4SyKuyLN6LMo6GOLr/RTi
   G1HFg5wZKTLeDaT4BbRp5HV6MEp8ixCZ5OCCoTrHh5yKM8NprgCxp1RSC
   T1jKXuU1daUO9o5aQtCuOE2H6RHizSIUH/Lv/WvqPIPruzvRHWFqS/khO
   lWqfQRsuIdZt7qD7pTMCdXnlBwVwgg2Qc+YDQNik+JhRhpaI/lxkr+tf5
   qlX5HVp6Vc4NpM67IEC0bmbDjZaWmTwrsZMsU20dRaLGxBEDWPIANiNYW
   tKlVs9GQ6oO7VmUJXGz4+hb6jnvitAo5x5Upv0H9zfVFg+AdS5RU0UiV+
   g==;
X-CSE-ConnectionGUID: MlZMDCxHRVGwcDWFkkOr0A==
X-CSE-MsgGUID: Lk5sGkXvRc2Dm/40G8AWfg==
X-IronPort-AV: E=McAfee;i="6800,10657,11739"; a="86041223"
X-IronPort-AV: E=Sophos;i="6.23,139,1770624000"; 
   d="scan'208";a="86041223"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2026 16:40:46 -0700
X-CSE-ConnectionGUID: ugoU3+UxTBSpbkY+pZMMkw==
X-CSE-MsgGUID: VA8Us7LdQ3qFRZAIxQUNIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,139,1770624000"; 
   d="scan'208";a="221611451"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2026 16:40:46 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 24 Mar 2026 16:40:44 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 24 Mar 2026 16:40:44 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.7) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 24 Mar 2026 16:40:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CBjQQ/Js/p90x+tjKagg234YmOOJLwFmowmJvvWxCDn6laAb57WaCqBJDBcgKSWAZAZ42ogGObQikrkSlCwxo3FwJbY/hgJIjkgZroNZ+81smQaw/HSuXClBp71OeTNzdwPuaPdAGpisdYDdHl/NQSFaNC3BiiqgjB4cnil7MO+4sonN3DFC0vfHuRQTTEFenC4xpfvE2YRLsQdcjbpki7gr6mHQmVMa5qYmt7WFPlUrckyl695srSTjIE2zQDhLqYQEKnIwlGKIFIS/kLq/vWYasciWimpc7s0HDPTP5YCY8vXNdUqzILjkjX/mXSS5yddXBtjAsvaTDYl9Xb3XnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nHXsOfyhPyLhsaVYdlB9y9mY1sWvT/ZjPH5Xs3HXedo=;
 b=KFr8YOJkJgJfTEIpxxvtA8hO+Q0eGJUAtwogJwqIGWiSQSxtLofJOkoSI/rmpyPubUTHvwWaEuuchhjwxAO8cichPalvB4OxiBz2wQMdX6Czj5+INEA9y8Am96URia90BJGg5yAoFNURUUH9ocAQHWYoEK+VijMNJkjvL8AcVsg/PAMskkhpnZwBbTapf7KWn7jyxgJ949PsYn1IWup1iApDEN8x9rOPU6PjDzWva5vcoQdH8V/ikTCDJjFpL/ZsfnPmeAQ/kF/Nxv7PE6bpN7ZcJXYAmGsv/LsL28vGZI3FEB9rZe33+vcNXFWEHklglUqNVFnE0gv9g+uUhF6jDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by DM3PPF90FB92BE6.namprd11.prod.outlook.com
 (2603:10b6:f:fc00::f38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.12; Tue, 24 Mar
 2026 23:40:38 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::7d4b:a049:aed5:d2b0]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::7d4b:a049:aed5:d2b0%8]) with mapi id 15.20.9723.018; Tue, 24 Mar 2026
 23:40:37 +0000
Date: Tue, 24 Mar 2026 18:44:21 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Jonathan Cameron <jonathan.cameron@huawei.com>, John Groves
	<john@jagalactic.com>
CC: John Groves <John@groves.net>, Miklos Szeredi <miklos@szeredi.hu>, "Dan
 Williams" <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>,
	Alison Schofield <alison.schofield@intel.com>, John Groves
	<jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan
	<skhan@linuxfoundation.org>, Vishal Verma <vishal.l.verma@intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara
	<jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand
	<david@kernel.org>, Christian Brauner <brauner@kernel.org>, "Darrick J .
 Wong" <djwong@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, Jeff Layton
	<jlayton@kernel.org>, Amir Goldstein <amir73il@gmail.com>, Stefan Hajnoczi
	<shajnocz@redhat.com>, Joanne Koong <joannelkoong@gmail.com>, Josef Bacik
	<josef@toxicpanda.com>, Bagas Sanjaya <bagasdotme@gmail.com>, Chen Linxuan
	<chenlinxuan@uniontech.com>, James Morse <james.morse@arm.com>, Fuad Tabba
	<tabba@google.com>, Sean Christopherson <seanjc@google.com>, Shivank Garg
	<shivankg@amd.com>, Ackerley Tng <ackerleytng@google.com>, Gregory Price
	<gourry@gourry.net>, Aravind Ramesh <arramesh@micron.com>, Ajay Joshi
	<ajayjoshi@micron.com>, "venkataravis@micron.com" <venkataravis@micron.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Ira Weiny
	<ira.weiny@intel.com>
Subject: Re: [PATCH V9 1/8] dax: move dax_pgoff_to_phys from [drivers/dax/]
 device.c to bus.c
Message-ID: <69c321d5e7195_e9d8d10040@iweiny-mobl.notmuch>
References: <0100019d1d463523-617e8165-a084-4d91-aa5e-13778264d5d4-000000@email.amazonses.com>
 <20260324003743.4973-1-john@jagalactic.com>
 <0100019d1d46d094-cc0a4b79-3bd2-43e8-a08d-ab8cd21266a6-000000@email.amazonses.com>
 <20260324141806.000003f7@huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260324141806.000003f7@huawei.com>
X-ClientProxiedBy: MW4PR04CA0238.namprd04.prod.outlook.com
 (2603:10b6:303:87::33) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|DM3PPF90FB92BE6:EE_
X-MS-Office365-Filtering-Correlation-Id: 32dba86b-5224-4361-5dc2-08de89fec05b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|56012099003|7053199007|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: HVxCasnh0DLlv96Nt09uBDRNYTAg3S2eB6vPVEtA/dir3TitVAaX5UpngbSdOjEinova2xQAQurleuE2s1KIdJ/lJBZPR+SqNzwIwAbH4pcYNXSWEmTq9ZZhnEqBghSJyOZxFgy0AGYgXqAd/WHVkGVDpmaHRyvEp8ddmmrl/rcpgY2ADXVsao45iyU0lWACUA269t5HN0Uh4X5sRqB0P7URkr92bJrr9Ei0ICf+EROCA/CEkAS7tzHMi0zcaoj3seztS6ROK/9nEPk50MxbWBjQMjrYdLbP8hHIhnMUfLsuCD3vkzkeUzFXSi2IAHxwbaY2dCvr6DKsHzUMiRetGQrQJaZFAWUiB15VxpxhgB+wSOEo8uySADz6NTyc9LWU6TdEEHdf4dOkGYRnA1+5fYND9qwFxfnweNN/56VYaohy1wlgmLcUi0NEH1UTe4rLWBwnJ1hbIxv6GWeQUpDQbCpGaUxsQniFORHYgE41kC8xr27qCFTig8vikpIJxPxqbGddp53W3lASjkuoEou12f+3O0dsKoPdSHCQ2RxY+3dXnMlNVH/QwmoO6TGmdYJ7bmUjmC3GSSveDvuVZqU8PSEORBNX8HHBcxuxrSG/Gmo+q/acMqAn76Lpeuq6zxKKQzh2s5FdnPZuNnkficL/tneIl7PsAZblMpSLo5lHCuekq+QLDHK6o79dQGeoszgVx0j4XS7oJVc+Sb62rslbKw8X/O03w542sPti8Eac8DE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(56012099003)(7053199007)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qUQ4FiqjuuQPHagYxVb6gJMRP2i6ztFI9KDmwwxflKZ2p73RwqAXaFsZQ73l?=
 =?us-ascii?Q?OBi29Es3f2Sn+ZUMPScpZQ/ZoxsXgpXVe3nDF2F93qOlldR8UF4ooL99QNzo?=
 =?us-ascii?Q?H3vfMeooaLMy01x4vODCGFbRl5AFyv30xdn4pZMHcMhgmnTzIYSPFii0Wo2V?=
 =?us-ascii?Q?TAjFdNBd3kqMxBv9W7whojFEruQrXeY9hGVUHYmYa4xS6GLZD8mJ5MEwqCLm?=
 =?us-ascii?Q?R0FylvJJpRWRl5g7u48ATW7+7uyGHzNKSg5tNMU+Xu4kM/OqlfLqAy1dfCoN?=
 =?us-ascii?Q?TtnDTHQo05+ggKznfcyVVhfLFxMUrLQ55tbtzK0Twi1dsfAHOOHQ93xyJL4n?=
 =?us-ascii?Q?+rOKIO8LcIDUkU1+TYC2TcU2OFuKattz5XbK70j89eE5WjglwZIIz9+7Eou2?=
 =?us-ascii?Q?FhLlwBMkH9kYcX6L58ShNMtj3k01fd3PzqHn5eFDLlSRNB2qe6Savzpkgdk3?=
 =?us-ascii?Q?Hlp4UnOrA1p6hJ2Y+ghO/1v5NQq4nrUq0xsIW0VIHTX8GjlTm62T6dyfyyeH?=
 =?us-ascii?Q?OgRY42WtCUmeK43WVdlRFffhaIbkkhpxnA9ybAT6pmL3Q9dOxm6oYvBpld+K?=
 =?us-ascii?Q?ByEQMLcN20+gLMdQt5iIqRJFv32FS3GBZcqT9WxP0fEasbn5L4lk+OpR18Zi?=
 =?us-ascii?Q?wHUqCDydiTIO+hJ+yFzEkY/DP1OL5mOs3CuwDZZf2K8LDnXmUiL64wWdNCyC?=
 =?us-ascii?Q?j73HnmuQVsAEQbBAoyXGruHRpEB/zU0KrAtpkBnjihzOOtOtgXBXrzcP+rGC?=
 =?us-ascii?Q?IIA8/nIVe4G2235qwt7IznhbPp1B6RX4+2TSHXB0YNIYLZlWkyB6ZuuyDc5t?=
 =?us-ascii?Q?Ki4FctWwF48ab9m8ifXgBgCQrjMIJ/1hbKsVHvpviNRO7AGRvSovXUCirRku?=
 =?us-ascii?Q?kU+/HNdVJ7df1Gt++akLM9UusGJHVQxyreh8+J9jonqIwwfvBl1bKXr9HHjF?=
 =?us-ascii?Q?f1TJ6GPkEb85f6homoLmXY0tFkIXwV8jfu5Ah6eZiVvySyukSgXohz9BMJzD?=
 =?us-ascii?Q?NNsE6Ntup3ZPBmt6qYg6kKrLVJguBg1fGNevolrODBBvt4MKaxIMzyCy5G/g?=
 =?us-ascii?Q?2GhG3NQ01WWHWPZoeEMHYtTY+hpBphk/bgIIvIgPZBqlC/KmHYDkjYXuZ7U/?=
 =?us-ascii?Q?SB4QPFneBZp1Ud2gmQqCl8AX0ZCSnyWqP6AxOitTEoq/Xg7V3zVWeGcntLqf?=
 =?us-ascii?Q?XyTBo/j3KWKXhaui15qDtDnng9HbKo7egpQgHgkAFEAJlrMABw/JduMY0iUl?=
 =?us-ascii?Q?qCN9QpcS1rnSL9cGrxxJRSUeZ6qsPvVuB26MNMBAmT0f5i/EoTrCwIc99ki+?=
 =?us-ascii?Q?9U4hPDW4qZ5bnuRfPTbpOdi/sMQsMlkSHn59ZdKyPziEwF+igZuh2Sw4eMt3?=
 =?us-ascii?Q?5PbQzOejpyi5kIpOaffyIofVry5GpZ+YlEV7HnCBBgbm4UfYm5r3HkNd1J57?=
 =?us-ascii?Q?VrBO32R/9uY6F1+mFqLR4gUFfRoPx2rsBoOeqcl7svuISRLkeRnbQKHuTOaF?=
 =?us-ascii?Q?UQxBm/gSPJp8AsBG1Ki97xfFlagFN1KRUt+JItXNnHI80/ILLsLq0AQWzQQe?=
 =?us-ascii?Q?7cvaIdJeggFee3A3z4AXU5iEaCHnZ4jB6kk/0p93Q+1FgDWtdp+c57X9MiFY?=
 =?us-ascii?Q?LmxLRBSm0hfhq3MzaQQXJ+kAd0Rz38NO+fSAQnT4Oqc3Pg5oxgbLRgtHivtQ?=
 =?us-ascii?Q?hpnj9U8MEmYoV2obvIuQGGvVyfL92A2fii4G53JFm1575bDj+zrkfvYzKSlw?=
 =?us-ascii?Q?MJP+4Dw74A=3D=3D?=
X-Exchange-RoutingPolicyChecked: oNM/Nc1M0aDzeeglP7uNCNNtzF80m2Q2jtS+hPvG4XlYtRCwnW1uqH2Og2sP/AFqiudOM7PjvIXkF/GT9NcuWsqBWhp/GlVfLeJVYner/sVMPJTEzPTkhS4emrYGsz9FHwQlJVYEHK30/xjSWQyPoy1dXsYwSLFmVgfC0PMi62xABIje98nDZfa3T77271b5NyGs/+IusEiz0E0CHbaAsms+ymJT3YtTfoW8ME503dcWm4T7wHoeYwKZB/sOYOey0qvmGsFFteaqETdY8OCtBjESvKX3pwdN8AWTLR6Tb3KnCNEU/fabUPI9mLYzE7qBvxOiNlRI6fnbMqgrY7XsMg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 32dba86b-5224-4361-5dc2-08de89fec05b
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2026 23:40:37.7073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mnVAbaCLGOjb5BL7orBLT/dnLYnIanZ9Vn7My1MttEHi0cBjJVgqxh6RdNyOOPy5QTpqMpYmBe315ewDRvDscg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF90FB92BE6
X-OriginatorOrg: intel.com

Jonathan Cameron wrote:
> On Tue, 24 Mar 2026 00:37:53 +0000
> John Groves <john@jagalactic.com> wrote:
> 
> > From: John Groves <john@groves.net>
> > 
> > This function will be used by both device.c and fsdev.c, but both are
> > loadable modules. Moving to bus.c puts it in core and makes it available
> > to both.
> > 
> > No code changes - just relocated.
> > 
> > Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> > Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> > Signed-off-by: John Groves <john@groves.net>
> Obviously this is a straight forward code move... But I can't resist
> commenting on what is moving  (feel free to ignore! or maybe a follow
> up patch if you agree.
> 
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

Added this to the series.  LMK if I missed something.

Ira

---
commit ccc1878ab00178e82108bdd1ece497388a24290b (HEAD -> nvdimm-famfs-dax)
Author: Ira Weiny <ira.weiny@intel.com>
Date:   Tue Mar 24 12:36:19 2026 -0500

    dax: Modernize dax_pgoff_to_phys()

    The patch to move dax_pgoff_to_phys() to bus.c revealed that the
    function could be improved with more modern style and the newer
    in_range() utility function.

    Update it while we are moving it around.

    Link: https://lore.kernel.org/all/20260324141806.000003f7@huawei.com/
    Suggested-by: Jonathan Cameron <jonathan.cameron@huawei.com>
    Signed-off-by: Ira Weiny <ira.weiny@intel.com>

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index e4bd5c9f006c..1b412264bb36 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -1421,16 +1421,12 @@ static const struct device_type dev_dax_type = {
 __weak phys_addr_t dax_pgoff_to_phys(struct dev_dax *dev_dax, pgoff_t pgoff,
                              unsigned long size)
 {
-       int i;
-
-       for (i = 0; i < dev_dax->nr_range; i++) {
+       for (int i = 0; i < dev_dax->nr_range; i++) {
                struct dev_dax_range *dax_range = &dev_dax->ranges[i];
                struct range *range = &dax_range->range;
-               unsigned long long pgoff_end;
                phys_addr_t phys;

-               pgoff_end = dax_range->pgoff + PHYS_PFN(range_len(range)) - 1;
-               if (pgoff < dax_range->pgoff || pgoff > pgoff_end)
+               if (!in_range(pgoff, dax_range->pgoff, PHYS_PFN(range_len(range))))
                        continue;
                phys = PFN_PHYS(pgoff - dax_range->pgoff) + range->start;
                if (phys + size - 1 <= range->end)
