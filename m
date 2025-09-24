Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C162820CE
	for <nvdimm@lists.linux.dev>; Wed, 24 Sep 2025 21:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758749935; cv=fail; b=Al569i09X9mwrkgORdbuxVCdq10IA0iQwHkpMnTKrrQf9rYjgQljfnMzN32iX3heXwUoZhEwV3OiZAPAFNlOwzcGvxOph1VScvarQlXfM8Fei1gqd+DHSfEAjviLALCA9v/Ag6kJF6xVpcoU4v3jMEyAUj6A8o/nYTiYmePqbWo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758749935; c=relaxed/simple;
	bh=vkIp2prvTxTxKF3H4Male61z2Z57C1nG/yJGRHmZnfA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=cmlIsaZWcwk3JFMdG2NSuoxtdItNBKO6/CTAVg0A5pXw5r3uOWQRkHvdIAx+rtP6lA7RUcrTFX7ijzTUAaYIKzdtuHqxM1qpjvxIWvZ+WS+57z+CFE2OemIXi9ZuZF6ggW8JQOhgeFET6/SU9Sfo2H44S6GdZPGIV//mKo3CNgk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TWCiVH9z; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TWCiVH9z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758749933; x=1790285933;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=vkIp2prvTxTxKF3H4Male61z2Z57C1nG/yJGRHmZnfA=;
  b=TWCiVH9zdF66vwPf7R4+Z9BZFx0AvbLvpk5j2kEq2zR4v5C757sZQznI
   YSGiHOp1SWef0uXxmn+pZ6xinl93GyUg6LgPDR48rDe1dSwoeNjaCajV9
   FM+JhRtkdlpkUkGHODsSP0yaVANNxxljSSNX4W9r4mQVD+6ZYK6uVbNK2
   WcPH+UF40dyxVfhYRVriLi7QQuc0WHanI+/UC8dH7pSpahCLI2JIWnzUK
   eVMbnt8HvfS+AKUM+Eilu9oH+rIa3vqnEVY+cFcoNThflflQzG7SdfcQR
   xUp/NRs+oKGO1E6skki9a6ETB8oPXOy9Y50HYLhoVTMKSooUQ+f8WMdKo
   A==;
X-CSE-ConnectionGUID: RM5k3NEERbKploQoIzM64Q==
X-CSE-MsgGUID: XoHxOcw+S22iXn+BwJSyPQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11563"; a="48623073"
X-IronPort-AV: E=Sophos;i="6.18,291,1751266800"; 
   d="scan'208";a="48623073"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 14:38:31 -0700
X-CSE-ConnectionGUID: HZbhhgjNTCa2h5x3lAuzSw==
X-CSE-MsgGUID: ONN2WYrVQK6lINas6eG2rg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,291,1751266800"; 
   d="scan'208";a="200832181"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 14:38:30 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 24 Sep 2025 14:38:29 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 24 Sep 2025 14:38:29 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.20) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 24 Sep 2025 14:38:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rfbdpHxSKr/jR5QbXrKs5rkpsQ698hBrh5d75ArOdlo2Lf7aipLJ/yNOnDa8xhYUk4fgp2DwTudFYVip9buxnFrWoFqQGVAQy6GwJzeyArAdrsADvPpkIzkFkwVSL8xY0P2qHUcGr6AAZpDH0V74ev0twOAirmCRarTaKQGyWnDpwtSqz3qIb/F7FklDF0YkVrpVL7cSZ6/CfIV+iYUbanQ5cjVHjK22c6GU8T7MfvzheKuUsRUl5lF/5MNkbQsK/UWz/VpszC39Zh72tDK28zEi2a8h96ow200OhOtfDyFRaXSl3oYvVYSUSq0gwxk77Wttu6oMFhK9TReYMfVjmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sVx3E6CBwunclX0JPInCYdeb4sVKY8Q78xCPFB7MtQ0=;
 b=Kp7jrHPXoWL26b3LoRXnkZPMCeZ7PK75hf67PrhkqsUiwUmzFaHowddijqfLyTGIzXW+A1JRK2WCeeppQD5SyUO9w4lIiBpPQW6PkVsHEdLhObXSaFgPOf4l5xAB7mDzyKy8qJcGw5Q2KrwSZcBksVQriI1uwD281vWR0AS7mX1L5ZAuMjae/6Hle7KX93l0JfivLFwajN5Cm7Mp/AIAvaNY8xqn7XpRw7cbYIgcqFglt2fUWgzJbvjINreNHroRlZ/okuUqFuPal0AdbPKnipSTLkOoAE3SJnloxcrDW/yzM/ycCTiCrBfGBijDts+gIBpr2AO7NJeHyamggczixg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::80b) by SJ0PR11MB5814.namprd11.prod.outlook.com
 (2603:10b6:a03:423::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.14; Wed, 24 Sep
 2025 21:38:27 +0000
Received: from SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 ([fe80::4df9:6ae0:ba12:2dde]) by SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 ([fe80::4df9:6ae0:ba12:2dde%8]) with mapi id 15.20.9137.012; Wed, 24 Sep 2025
 21:38:27 +0000
Date: Wed, 24 Sep 2025 14:38:23 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Neeraj Kumar <s.neeraj@samsung.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <gost.dev@samsung.com>,
	<a.manzanares@samsung.com>, <vishak.g@samsung.com>,
	<neeraj.kernel@gmail.com>, <cpgs@samsung.com>
Subject: Re: [PATCH V3 16/20] cxl/mem: Preserve cxl root decoder during mem
 probe
Message-ID: <aNRkzw5GrqyZjE6s@aschofie-mobl2.lan>
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
 <CGME20250917134203epcas5p3819aee1deecdeaed95bd92d19d3b1910@epcas5p3.samsung.com>
 <20250917134116.1623730-17-s.neeraj@samsung.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250917134116.1623730-17-s.neeraj@samsung.com>
X-ClientProxiedBy: BYAPR08CA0029.namprd08.prod.outlook.com
 (2603:10b6:a03:100::42) To SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::80b)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PPF0D43D62C4:EE_|SJ0PR11MB5814:EE_
X-MS-Office365-Filtering-Correlation-Id: d3316b45-7d05-4139-c529-08ddfbb2b214
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?WDfEP//6ojdXykuppHwQFbts0OcVn2GehGnhsbO1ktUaqXJkLFi6coTmzfjB?=
 =?us-ascii?Q?iVcXXRhBtp1vN2T41d3cUFF/q/E2gwNzJOQZdezuQWzLWh/943EYnMtjiBuV?=
 =?us-ascii?Q?w5hHmRnCZogUOP74vs4MXtoRB+fAp4T+vtDliU6v0VpnPb66Cb1nZD0iklma?=
 =?us-ascii?Q?fFEeCOgZb9nR5LDu5Ul+yWHuTJNlG+sSunezjLw/+ccsE69qPP3335F+oDyi?=
 =?us-ascii?Q?PdAkkh8yTs/ZL9gdYagPnri9qAED8RIZ0GbKR6753GaQ49LWG29hQZkJCfOH?=
 =?us-ascii?Q?ZrHSbEaRZYu/8xwdSddxCXz0mkZ8OTsQjQhq8/j9EU1h3PaPWCofVEYsMMCL?=
 =?us-ascii?Q?2mIMW1xA0MVqQhnL/+oQlmW+WTKgpR6NQEpDBS4w2LpZpCwmqrs/AxPqPT4x?=
 =?us-ascii?Q?i7xQ9KVHWRYwxK0bsK8ZYKt217XwjalzNXjJ9SgluwMmWAvFjT+IG3b2V0ZE?=
 =?us-ascii?Q?aMCEyptdaGX3nLaBs99pTlq1ncdxEPF42plrjk0boppfJPYPReyRlwvyBdM0?=
 =?us-ascii?Q?rkRVo+CUTJuh5SP4mbQ0aqowBGu2xBFOiGn6NgVqTQC1zvDnAITLweMubD5L?=
 =?us-ascii?Q?7S5AJhn0jQhSOQm0phNGX/rWbiAzPDv184EU/ctz5inSDgMnIScel3h/nD6O?=
 =?us-ascii?Q?/Ld1r1sRssrIjiTZRQsmp+D36yhxCoEFKjAYei2tYs4hT0Cxdpd3g7E8M9bn?=
 =?us-ascii?Q?cJH+72D0S0/tTKCW+PsoydwHY2Kuf9EtvjPBGD4po1xFtEebRJw9yVkqtlNn?=
 =?us-ascii?Q?WDNkO0coIVl29JMoFZEG5QU7GJI/w+qRPlVVsslRLX17U37jRj8l8YCqdoS4?=
 =?us-ascii?Q?dOgvMmmTSpUl60whoQUig8xFLhn6CsiKVvaT09+KuDarArwxREqffaCt/R+/?=
 =?us-ascii?Q?nPTZD0/kXL2hDfany0+++faxeEt1AjYolHfbvih3/LyCiD0TKs8i6sWwYhjh?=
 =?us-ascii?Q?OvVfudLzMNL+wtAhfDmFVV4SaSoKLYousYxsLCgFt5VI/UKNVMBomha+fQSz?=
 =?us-ascii?Q?g9BqbJKcSx/G228HdHURclI1Obl7CB0Lynl/NSTbtM+Ye6xXmdgNwjnKRAh1?=
 =?us-ascii?Q?w/+wjZtkOmzwRFIwUU4dynsioHmJZ1lKJKgT29jK4RwtC4My2oNIqQKlWMRJ?=
 =?us-ascii?Q?toipptoVqkivWmXHec9QAXgKur+IifuHkVw3EqKEJsHERkEqlyxYDdXb0YSu?=
 =?us-ascii?Q?IIkgeBqQa9h1RwipsreYYMNxS9mSXcBIJm2+m3ypEDk6Kg7bpUyI/apzMQTN?=
 =?us-ascii?Q?J5gH7TRRBh/6SK2j6hXFP5wohgFiReX4Z26IymKF+WDWlN4JzC/gxvomBd7d?=
 =?us-ascii?Q?DRZ9um2NEA+EIq+YJrM/IDanI44WEwG45egnBxA9ikfzkCGTeVEB+/e+hVBb?=
 =?us-ascii?Q?JHWqM+FlsqLuNUCWeh7ZAk9W67UnYkE6p2djC3ODFAPDBXPjaoFxYh/+aln9?=
 =?us-ascii?Q?ZLa9W8fKTq4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ5PPF0D43D62C4.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aW3HTMPRv8RP8dQgMhmkpLIvVFXxtPVMzqcDuJChf+jey+gQFOZ1Db59/kND?=
 =?us-ascii?Q?S+0p3ZLxG4v6GDx0eQvWmd2cZaAukiKHlYuFBCYRhBTl03HQH+p5Bm/s2gin?=
 =?us-ascii?Q?TgBrczzU+xxP8hCYX/a7kiOYAKTmVOLRPINplJ6dRmEYHeaUo1rYQzZVdgxQ?=
 =?us-ascii?Q?CmFI7QdYNVX+yEGryZgViZXD4TKh76l8eV00wV/M93dLkQY95tppWPnLNk0O?=
 =?us-ascii?Q?XjdY6TA+2nDXV03iMf9TMrohV1wSUzDuFfKtYgITBIkv6f6cwGHdjQ7PrD5z?=
 =?us-ascii?Q?lYfUARsVIC2gpDhbRJppT3u3zDTgiARq+Ojw5vrRjhzEm1F5wggoDomKgmI3?=
 =?us-ascii?Q?I6nifTa82mTZ34185ah1v2fcfMZGa13oHzbMqNX8T05CdJoc0fwnRoBdT9Fo?=
 =?us-ascii?Q?taQHhR+yO/lLJvcwbHp5T8QsibIejRZFGo5qTVH2bKGX239oUEmdL89KX+8T?=
 =?us-ascii?Q?1RWMXWyecHTaqECsHAS1RYNkXRGaNCuJ3YZnR7skwW65XsLYtEfOf7MfyZMX?=
 =?us-ascii?Q?QmL7QkjnN3DMqBteUbwi7bGeVdZxx1x7PV9zOd8sbyYsRyH16aMS7rY0U3Gh?=
 =?us-ascii?Q?HuHcgHVrQosOoon+tUd2Mij0snFqahclNEg8yZ3UydN8CYg76EmYK7nku+gL?=
 =?us-ascii?Q?cI8/8cWvoYvAZAOwO4OZW3f4bIk2qheuRR9gOnrkjJb86oI021/tMZ1E49Sp?=
 =?us-ascii?Q?vckFl2lTITvAFHK2WglMwgxOWdGNFUHWfsY8tx4cf8kqiqWZKBeY/lJbYPIm?=
 =?us-ascii?Q?i7qEqfmHJLtcLzeIr2C2MuWSWO5B58vtxRsDj7wLav984+T3GLFhIXHpk9rO?=
 =?us-ascii?Q?wEztPe0YYy9v4oXpZSwFF3JDLPFEjJtwYtAFM4Wo1p4Y2/e0Owj6yRhO4WIX?=
 =?us-ascii?Q?59MboiHH7uWvYt/UDSsf/gN3Wehgi70HtFWdo3vmaVd5wcszWaLaCVEcxJFH?=
 =?us-ascii?Q?IDgS5yDuEmwhTWQgP4WavNpMvH1GeRa9pN8w1Y74qhRAHaDHT9MyajiJRgYG?=
 =?us-ascii?Q?3T4fq9SgAOJaInzqMG1cX6YFnvt3HHHH1UyFY+ChdN5Crolk/VqM8w0w72ob?=
 =?us-ascii?Q?4vUNdzONsSCK6GFOCIsIzGmJycxzxONsZIH/DOYSQySDc6PeMWs4LyDUD+rq?=
 =?us-ascii?Q?sjLVDOYJ1nInS8Ynd449JiUEKmAEmcdV9iDRuigXmoFUIquUrrHV1iD6Tfk9?=
 =?us-ascii?Q?Mz3vXrOL3erU7lnONHiFgS4i7vW0PikX1WovKd2TJEawnd/27V5ALfoLClSI?=
 =?us-ascii?Q?5sKKsc12IOBwtQ0zTxzP+IquIQb4hzKzSNsVc7r/c/dn29k0w8aSUxLLkyYR?=
 =?us-ascii?Q?pn++Zsc7D6AzQPHzQkCDIACb80m6jXIhjMrhczEBMf7HYbSH1GJWPVVQGFV5?=
 =?us-ascii?Q?Bjqvomi+g/+k/bVRjkuRC6senJW+f9hteqDxW9LeLeKB5eA2Yu3U791KkqPv?=
 =?us-ascii?Q?ww3EyHzPJhwDTioLtR38reQ0yOGqHwTvCHGhqDXXtz3vZ7HXi+GmNEeOQea2?=
 =?us-ascii?Q?LXztNinYHdtAWAy+MMxSHzYV4DzVet7nzrPpKXkwM5FoAtWyk9gioeREW98x?=
 =?us-ascii?Q?yR8grCic016cH28klce7N8SSy6upz67vtgtkR6O2S3zHilpS/p2bbBeYbpAp?=
 =?us-ascii?Q?2A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d3316b45-7d05-4139-c529-08ddfbb2b214
X-MS-Exchange-CrossTenant-AuthSource: SJ5PPF0D43D62C4.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2025 21:38:26.9615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VE+yh3Zal8ClmVqlwX59Bdn7ms2ZgnnMW+hotcv7V8O0a2wEg5XdJuWtIAt5/8pGNAKtTTbdmFzkM7bNHpC73nRY4KrYI3l5PQc78EJFc2Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5814
X-OriginatorOrg: intel.com

On Wed, Sep 17, 2025 at 07:11:12PM +0530, Neeraj Kumar wrote:
> Saved root decoder info is required for cxl region persistency

It seem there must be a more detailed story here.
Saving the root decoder in struct cxl_memdev does not sound
persistent. Please add more detail on how this step fits
into the grander scheme.



> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
> ---
>  drivers/cxl/cxlmem.h | 1 +
>  drivers/cxl/mem.c    | 2 ++
>  2 files changed, 3 insertions(+)
> 
> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> index 434031a0c1f7..25cb115b72bd 100644
> --- a/drivers/cxl/cxlmem.h
> +++ b/drivers/cxl/cxlmem.h
> @@ -59,6 +59,7 @@ struct cxl_memdev {
>  	struct cxl_nvdimm_bridge *cxl_nvb;
>  	struct cxl_nvdimm *cxl_nvd;
>  	struct cxl_port *endpoint;
> +	struct cxl_root_decoder *cxlrd;
>  	int id;
>  	int depth;
>  	u8 scrub_cycle;
> diff --git a/drivers/cxl/mem.c b/drivers/cxl/mem.c
> index 54501616ff09..1a0da7253a24 100644
> --- a/drivers/cxl/mem.c
> +++ b/drivers/cxl/mem.c
> @@ -152,6 +152,8 @@ static int cxl_mem_probe(struct device *dev)
>  		return -ENXIO;
>  	}
>  
> +	cxlmd->cxlrd = cxl_find_root_decoder_by_port(parent_port);
> +
>  	if (dport->rch)
>  		endpoint_parent = parent_port->uport_dev;
>  	else
> -- 
> 2.34.1
> 
> 
