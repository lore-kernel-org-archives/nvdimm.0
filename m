Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B408023F291
	for <nvdimm@lists.linux.dev>; Tue, 19 Aug 2025 16:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755619384; cv=fail; b=mmC+J8yYjOpiNypdC32sMn+6oTaC0XOtLb7N+bUtzqYWTQLJSYJoPm/eEPROumdULAHeFY+hSULRACafdJ/DifbdAnp1GFNR7vOCvNrzZTSPZOs4kHm4hE7+uxLX+MAycdNIS4xSbi1et3K8DbySo4eL1sWlEnHClD/Ae3rye5I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755619384; c=relaxed/simple;
	bh=wgsn/w2xEI3MhuIz0exwEX/oaBXb/Xbm1Kc/U/MwRJY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=HaQiEUfU0EA+qEH9oEsTzHIgeEx4nGPDqg3WQuXUC3+vxG7oIO7Iq2yDl41k8Y+KYdePU+bzF69lGmNYbJ/v+yih+fjVvozE5A3tdQDfq3rzw0yexHoWWeK7CDtaDShSS7UMEpGmEjkhhT+XkIwDjrjPRZ2x7/Ch5gl7DM6Opqs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d1q5kyCF; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d1q5kyCF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755619382; x=1787155382;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=wgsn/w2xEI3MhuIz0exwEX/oaBXb/Xbm1Kc/U/MwRJY=;
  b=d1q5kyCFClFJd8ASV/ECwTzJgFy8Oj4kdUpATUJ1rqJP1uLl+jOb4IYu
   KUTAMu700hwXRkaEub+iHk8ST7LY0VQPLIYWX8aGN6dawNgvkgg2SmUdz
   kZxE2OPb7Efd7yVqsz6KjgFtO/2w0II6TyT9ZGSGt0l4Zrcl/jhSGfTNd
   9FXjjed9ndOqhti0/kIMFKNBWkfJUgzoZ7JC6upmbPKs9SHGLM7kqc2YW
   O9+qyp3gpjGlI1hYEH+ayndKu1ptrGkTwlqwvdUgsCCSmPkpVhNSMH3yv
   GcAOrxDaKranDK9s2NwJKJazUQWYtT0xVIhDNZx05YO09/u15iDMn0uRS
   A==;
X-CSE-ConnectionGUID: Var0DHAtSBKjcIkmYTk1PQ==
X-CSE-MsgGUID: COuH9pwnS3eMmUYtnmMO+w==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="75441912"
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="75441912"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 09:03:02 -0700
X-CSE-ConnectionGUID: AiHDNKMoT72aJMSHT8fVfg==
X-CSE-MsgGUID: 5cHsXQKNRQmhd8m2PlO6mA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="172122559"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 09:03:02 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 19 Aug 2025 09:03:01 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 19 Aug 2025 09:03:01 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.88) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 19 Aug 2025 09:03:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NYPeN/RV50FYatDeYF4k7oibd/WgttDCyvtlLtzhhJmddeCtSFU/JexJQLUG0rD81WWHAR4QbfNBE0xcMF7mWBlXFOYzniIneGySpamUbaoKYyXaREgJ7A88bzN0K8q0oHI3FLzg3W+XfLBpnK0Bn1IQr53O2EX7q92oyyhDzxn0YNafujo9TzX8f8I9EuNChpcBNNBU1Id+/8tTB6ZW+z/xpO1Oxh8urZlTP9FELEIWa2K8cSwII+FyBoWbspCuGhDPzSi917LOybiGD3XKQxiG0K+tYpbmHEsygNqfQZqMawPNXLLiyYZBQcTl7/dx4+YskxdPv89TXWMpH+RK7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Oc/munk6DcMGJNNNMZi5OgXOjFA77+vsXqya13t6jlw=;
 b=BEZiN0ZmF4AFPkO4uVbhQ50YYPVtaueJUkNbSFqCnNfN62TFz3kwc/TrTSrahp8SO0aFiqQWnhoKvI4mfMdRiKbSMDtBHPCLrxG1ojoQv7+MTqFNkj+GYHo1OQvonZsqwhE9iA7UsELkFYOSGu7qfX5vCDb+XUMs85JgNesj8v3Grd7rdZNFpvOyM7tf2mV46UMz85BiGu8HsP0jGSkvxR981wplcUiX4cBTjYV8uL6Yo78N+KPePvIbr7PXsJZWEwuHW6F0Et+8M8SpqLmYQ6iJ9jF2sQkPsIiARN2K7dSAL7ejjjZtAJ35LGx7GeU/JyZ2d2B0HTMyZmiMxB5dfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by PH7PR11MB5982.namprd11.prod.outlook.com
 (2603:10b6:510:1e1::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Tue, 19 Aug
 2025 16:02:58 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::bbd5:541c:86ba:3efa]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::bbd5:541c:86ba:3efa%7]) with mapi id 15.20.9031.023; Tue, 19 Aug 2025
 16:02:58 +0000
Date: Tue, 19 Aug 2025 11:04:43 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Neeraj Kumar <s.neeraj@samsung.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<gost.dev@samsung.com>
CC: <a.manzanares@samsung.com>, <vishak.g@samsung.com>,
	<neeraj.kernel@gmail.com>, Neeraj Kumar <s.neeraj@samsung.com>
Subject: Re: [PATCH V2 04/20] nvdimm/label: CXL labels skip the need for
 'interleave-set cookie'
Message-ID: <68a4a09b147ef_27db95294a8@iweiny-mobl.notmuch>
References: <20250730121209.303202-1-s.neeraj@samsung.com>
 <CGME20250730121227epcas5p4675fdb3130de49cd99351c5efd09e29e@epcas5p4.samsung.com>
 <20250730121209.303202-5-s.neeraj@samsung.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250730121209.303202-5-s.neeraj@samsung.com>
X-ClientProxiedBy: MW4PR03CA0038.namprd03.prod.outlook.com
 (2603:10b6:303:8e::13) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|PH7PR11MB5982:EE_
X-MS-Office365-Filtering-Correlation-Id: c70c54da-74df-4aa2-ab42-08dddf39ddc5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?GlWNTUL2PAAkWeLnM+/wEVjYZ03tT1jk2a9KWayl6Sj3n/RAfw/2aU3Fed+t?=
 =?us-ascii?Q?3gjmOz1N/gV2C2oIgxCc+hXL5UEIq3VskB2aRs0+coRrN638lsUnowSIpG7h?=
 =?us-ascii?Q?7IoYfE2qYdMZvHMNI3VxQep8P9SNcYBgHNyTpAubxhnMKzotONzZmX/bbXLr?=
 =?us-ascii?Q?cEgL8pEgzGbK2eqWiKQ4ALK9WUYBFE3n96U5l0QHcmp9rv/1Pim52UVDLMJz?=
 =?us-ascii?Q?+AMzfS/jW3HJKBT6YbzHOU7GFfLjGp6ZIQecMz7zpozG7stcrt7zN3YHPaij?=
 =?us-ascii?Q?45GEJjkCNXFo2LSW2vQZCRn6B9vxIczivsOF2iz9rmuK7EdfWKMb+jG/JUIC?=
 =?us-ascii?Q?D6cPPx+Pn2Z009ahcvzJA8Xbfaehhnykcyp2fUFR5XrdAUyJa42Ohmwkp3Ik?=
 =?us-ascii?Q?pKHM2qmX/zrUg+sii+6taL1mIyz+z44wvOpGMEpX9orUeXiq64AejnmroI3L?=
 =?us-ascii?Q?/Dl0LVNV20iqbowFaQbyqfxdgc+HX6KvztX9rSxSqpki6gAUVbBi0lb4YYDa?=
 =?us-ascii?Q?UGueaznWCpVvh/jVrLRGHLZTzYXzu0JPGhxE3bcAw/tAs/0+a1lqDCIkxvtY?=
 =?us-ascii?Q?ACkpQw1CfjP0OTKCLc8nnEEsZmULuAYyLmt9GvTOndaXMI7Yc50NcMrHnhrm?=
 =?us-ascii?Q?jtzpjFrqPWT2cZpD9oINNhHTJC1SKbQqnPvfiGIrNYh7td/2r0TAmPWZtDC5?=
 =?us-ascii?Q?h2eDebn+R1b1IUFOJFKtfPs5I8sORunwt2gRLnnSnspP/OYxT9TfpM0Jkn5F?=
 =?us-ascii?Q?vkvVmQdn3D388DWT1ODsn9Hdc66RhPzVznZLmstEXAHDnfwcCfpvA9AET1wr?=
 =?us-ascii?Q?8yPmaMOyD4C39d4f4kxd1WanMt72r42ynPG6qocp+4kDUp1JdYRhibo4DZN/?=
 =?us-ascii?Q?1ouqtWj6ZulqHvv1J4RVzTnRScfMnKYhZhgYg/v1KF2n6nOQa5eW/megsmeB?=
 =?us-ascii?Q?4IjXJjZDp8owW341hgTJJXHuNmhg0Embl+3s0CHocXs/MyBRR+rYWDCGFGMD?=
 =?us-ascii?Q?Esqx/MYHRHVdvmCjxx46NdBjcTvdxzo939xGwc2EEZA4TA6RvKRya0bdC+Ww?=
 =?us-ascii?Q?3iTRTJS5SeQfihRiTzPdL1SH+Px57sbxp74x6WUf9ZvMCPlqGUnJ2dDTJzXP?=
 =?us-ascii?Q?BO77lpUaZ0xogs7L7GSZ7J6Qh9POP99v+lte05tRqeBNXDmfdAvBFQMDpFu0?=
 =?us-ascii?Q?8t195PL8D8TJZmjJFd7g1dW36J3kMr6oZGQRGtvcf9ZhoPq14TVT0DoNb1kJ?=
 =?us-ascii?Q?h3eczn1XhjHRp4wmUc0UPeByuxXRBYKEBdSElWnFacBLBC2F8aii9kCM59f9?=
 =?us-ascii?Q?WUfteByhuo3Oi6NRSoHMTU8Q3yoGzP1w4US3kcJqppjeXizPx8PAl5JEn51U?=
 =?us-ascii?Q?R8nlyhYFnxuY4rwlJ9ZWjJZ15YcX1NhmrqLJE/7zyIQQ3btMPQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Tjnv7cWCGDQu/AW+luoWeKHcVU5S/toVwNa55N+L5GQA4Z3Xrsxnk5QeXDJG?=
 =?us-ascii?Q?j9VG7jqv9o0w3FiY5OQyNvh3NJ7biKyu5yjfTydFp0wVFYjM/qdMPI6GtnzZ?=
 =?us-ascii?Q?FSmPkwn1ldy/JeurZjupjRCDEfE/KH2avaFmtzagUZDWssOb/ViQPjQ+AIq6?=
 =?us-ascii?Q?nqqB+7MMtTvg9ErkQa9MfU248P2kVxcTAkN/Wif8fR9c0+jerWNp4RyEaCV0?=
 =?us-ascii?Q?K/l7kb0gCI3Cy4A0ac7MV9cWXwWsDU+YXcLGHZ9VKmiN4s1u6nnEbdXesn6c?=
 =?us-ascii?Q?fXtgy/tiCgn3g7bfLbmD57J1qkHISnSmifD2SbiMxV9ro5WXi9PV/8nWFqI4?=
 =?us-ascii?Q?MkKdKITiVCKP0UoRh1SI0WdnxAhSUdYnoxJxq2kBM19QwT2srIy+MSK0WB5l?=
 =?us-ascii?Q?tEWPYWrkeodGqj4R5m8aaak00eX5Z6BKv3XYlFVfxk6Hb3oM3gQ/4eY0NA/N?=
 =?us-ascii?Q?ths3YRKm4RwHXONyMC5c0IzP5k9eI+6OQqIVA3uj8m+3CcMZAvDr+Y5iqtYf?=
 =?us-ascii?Q?FIlDJ6crPLXKpDL+UaJOK90Fb7GE5y2bfEt36ScMJGV5w0TGr4OQzze+JgUF?=
 =?us-ascii?Q?iYkoARZFMmYeCJQS1G7+kA5CwcwyaVHXbDFjtllbQAkdoM143hwmSSVCfuKq?=
 =?us-ascii?Q?MmG12jceogSbchkF55cxmitEZVbo2fuCcC+/HwzoDKh3EJWMbZMxFx1kuDld?=
 =?us-ascii?Q?Mju9nxekG+Dhf/wqg7UoKTqBOZnpPaOMLIi2kjX1TiKeXHTEJdd6o8Q3CPl5?=
 =?us-ascii?Q?/5AWVVoIhvKq248lPHcz8VHHrijuAUczXKQiydPMbv3oVZ3resFm5RxUD0Gn?=
 =?us-ascii?Q?pLqsocCSIWrK9Tx5B5Cx+Ar2SwdiCGn1dzRhZoXFfmPG4zGMRknVaw1Wsch9?=
 =?us-ascii?Q?bFDWj4cUe4qqpP357Pzv8XjKTwJZJ50h6FcrlXlRun4WlIEZAPQrT6OFgv7+?=
 =?us-ascii?Q?QO7Y1vT+U5DGlY2WVTsr+MG16UbJYVqhNkYXigDUVTSsZf1yLrstsi6oO+Oj?=
 =?us-ascii?Q?airQNsYecR7b6tISkJjbbjLbKtCVEOkVp7RpQHP1I/owiAS326f3V5BIOUVU?=
 =?us-ascii?Q?jpY32Im0CcbAxLbF4aFQm+seAZeDa13BnuWPPMKXI/H6KnR4SLkIplgMqhVn?=
 =?us-ascii?Q?79TLQq8CUx6SAQCHlp1cGgGpgsuraeIC0b0mbuGujx1rhPLayDwXfxgOL5WL?=
 =?us-ascii?Q?tSesQbf/J5HXpjS+4TQdPWumw33hiqkNoSItaH4fs4l01ESZKI0AUVwMUDgo?=
 =?us-ascii?Q?Ny3uI2LfJXrXJcv3s1SA3oWKN1JNS84ZIrtWTy+lUueydMnbxfdFzJQPOjJF?=
 =?us-ascii?Q?Xt2GP8/jrc13/nVf4F1kGelzNBVOBT9VWkgNJX8I2P1Od0bUSJvsym120nVc?=
 =?us-ascii?Q?7ob2HNzkWRjAe2BPKUp18uyUwKHi3XN7pFh8IMuXWPlGCI7+s5Ze2VfYZuB9?=
 =?us-ascii?Q?qfj0Axb5jIYfVwWlID8ghgeEfWrUqv2dKFvdmTZlxyTaBIvqLOHBbO0ZPn/M?=
 =?us-ascii?Q?glFa692MEW2+5MglNSvXlqvXfxXYev0y7tvvcd18Jl5FIgS6PTeeWWyWcJwQ?=
 =?us-ascii?Q?w7AwRWcyYL7dWZFX1x2keV+SHff+Xt+07mcoN356?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c70c54da-74df-4aa2-ab42-08dddf39ddc5
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2025 16:02:58.4922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ILO6DQC7L2V10nc4oFVXs+i8MpFp88lAb0nF7BpEIauOzgssJ8me7XOJkTW+q4hQNfkKJCcud7ag1UMsJMLIZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5982
X-OriginatorOrg: intel.com

Neeraj Kumar wrote:
> CXL LSA v2.1 utilizes the region labels stored in the LSA for interleave
> set configuration instead of interleave-set cookie used in previous LSA
> versions. As interleave-set cookie is not required for CXL LSA v2.1 format
> so skip its usage for CXL LSA 2.1 format
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>

Seems ok:

Acked-by: Ira Weiny <ira.weiny@intel.com>

[snip]
