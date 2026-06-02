Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816223233E8;
	Tue,  2 Jun 2026 01:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780363278; cv=fail; b=BDtsRl0cQKJB28e6oPV0KDfxSbGXhRSDwQc1IUqkRplBib7i65SGjeruE+cFJhc+jalrZUlcD5UCUTGhUkTPfBlFTp5BKBWuckdMvJuKZ1VMdhBtbqNht2Fb7MPn/SEQeKT4l+iPZBeUwI+7+Ma1CNhwhgp6tkwVvAxP8Dg1xsA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780363278; c=relaxed/simple;
	bh=5ojc2Xb3WSQ1OvJ9rXn0TxD/lm/5hqKIupB/9OOs4T8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=HkuJfA4X0AGJDvCQ7xmqLbVNKGnfkgmCvHVnnTBSfJ1aA53ur9sfv2/xnRPO6L5wayzCWY80smPkVema+DvmQpafzX2/Hh2QsbkJEPXvJsrxYDpPg3hL47HEHeiG1HCOLTN8IJiUIsl5i2QKAZAZewtL64RUD0JsPQWr8uHlVDQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aE64OD3H; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aE64OD3H"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780363276; x=1811899276;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=5ojc2Xb3WSQ1OvJ9rXn0TxD/lm/5hqKIupB/9OOs4T8=;
  b=aE64OD3HHRONqn6a/fEGXMo8IFxfp1t94qoeYgD0ebYUBX7niJnUd2ey
   0ESWxUA2jIF75CYX4/XzXymQ8dueCWboWuNCjncVIC+DDPAE8CNUUVKCR
   dsOqbPYWTzf/CJ8ZeGhqv04W6LxqMODcIKAZivkokPzA2xr7rYlsRVaRY
   UYNMn0Z0SuMHkkEetFQzezPWN6X3hqnCaVvZQ6xP3woFAXCer0SIFB5Mn
   DBqLBKMDFNZxhjUfgjgN+Axwqeja5+7gy0CVmkIBKWOZuXMog2g4zAE36
   lkpvPPh+8qIcQJoVLbKRlZcT7fsezr7K7jisM/VXzmS4PL0zk/s5FyW3D
   w==;
X-CSE-ConnectionGUID: 4NGSJwHgRl2NTlNABoJmwQ==
X-CSE-MsgGUID: fbTx8fMTSl6WKwS641OhgA==
X-IronPort-AV: E=McAfee;i="6800,10657,11804"; a="84758199"
X-IronPort-AV: E=Sophos;i="6.24,182,1774335600"; 
   d="scan'208";a="84758199"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 18:21:16 -0700
X-CSE-ConnectionGUID: hC1BdgfVRUqNewjMUqoU/g==
X-CSE-MsgGUID: 7EqKZFl0T3yQ3pEu9z/9uw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,182,1774335600"; 
   d="scan'208";a="243568744"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 18:21:17 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 1 Jun 2026 18:21:15 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 1 Jun 2026 18:21:15 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.40) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 1 Jun 2026 18:21:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tiK/o6K8vmVeT7W+3Hg9KC+Lq7Hw1aS/3isT4Oe8iiE3dowsEpdPp1si2ib8jUPJHBjYefHWoAfVPMBjj+gtYSZuW5nPkpDmW2Un3G9hcdFBqDlN/kaJdTLCt9vsDQZQnW/uySpJd6AlHuuaxoJjhZjfRjg7lAp0DHG7d0FbCOmgGfRrEmZYyX9xuSITRQrxJ35wVlAWlBxT6s0WDD4Jh3oiI/lFpotRFI10JzfDLNC3SX5V1U6xXzr/rwn8zDpbZfPqAAZyp09DCczSqMpPURTGZTfCnw8DyP+PBCHwtDa4ItzsicZcLsxJeQ9N3fvfYkhRzXHvwd93G1q9cS9p7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GhxDbGTKjoxwLwDRPBHcrYRIkgCEfzPDdIJ1g/ocJkU=;
 b=o4TJCsoAKTyb+dsPoH+xxMFZ+yACGrA3vHG6qEFYp5ofclJBkIdGSdL51YBxlfZnhAO4WFp8o6GLB2BAzgC29TdKZkUKdHDczFy0CRYBbIUF0Za90Ltw8H0kcul/QFpvcnxbxXRCoTmEvh6wVw0qJv0N/BOLVQtn9Q+gWy/xVMZGR91iklW3A9YzJeCiJRf9i2LqZiGIctiSg+VTKqr1EiIt8MjX4PwEDyBX9Myb+nQ9DnGc8X6CUCaFDGiBzCqWP0EIWg++V6/mRUWpHn6cJW9Gmna2RUhpAF42ZjIsRlSdoJqBEj5y95E6qkcn9goFCriQaPk07ndGDc1DV/3MwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by IA1PR11MB7754.namprd11.prod.outlook.com (2603:10b6:208:421::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.16; Tue, 2 Jun 2026
 01:21:12 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%4]) with mapi id 15.21.0071.010; Tue, 2 Jun 2026
 01:21:11 +0000
Date: Mon, 1 Jun 2026 18:21:08 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Ira Weiny <ira.weiny@intel.com>
CC: Dave Jiang <dave.jiang@intel.com>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <driver-core@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Ira Weiny <iweiny@kernel.org>
Subject: Re: [PATCH] MAINTAINERS: Update address for Ira Weiny
Message-ID: <ah4wBOp9dNUblgXB@aschofie-mobl2.lan>
References: <20260504-change-maintain-file-v1-1-6679b030d3e0@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260504-change-maintain-file-v1-1-6679b030d3e0@intel.com>
X-ClientProxiedBy: MW4PR03CA0144.namprd03.prod.outlook.com
 (2603:10b6:303:8c::29) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|IA1PR11MB7754:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e0db65d-6d9b-4356-6851-08dec0453b6c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|22082099003|18002099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info: vKZFWnTb0Uu5I0DtDYdbEU4xy16rto76K9s6yR0/6QphLWXoRXGMCoRw3qNWh9nHetnttUJXFlcTin4w0+C8FP7WGsq/wpchI3d5a/k7ZSzKcsMVZ6A2gZZoLsYIcuvGt0C8c41C03RUcD+mNVm/PhCpj/vgX21kx4cBUu4Daopa7rs1YmC818cZmSScrptEmOJZy5G9h8qkHG9gzJ8nguhC8prm9l2jUCitqrTjKMfm1AFAJ0ZdeSkU59Zx9xPWlIKMSX9WddAcnlj3iejx36fGAE5clAk+1P9A/weazUe/X8rZRQX/dEn276QZMHqfF+6fbyK6cov5molJi0rTe6trP0fttWB3OlUliBWgi3HUPnGsI7odhn6aUSh4wlN91Hi6i/b2FisPH4LheiZkoVAFE2KwWbHbqrBfegNNq51T/40n0J2vXIenU/qwJu9TcV+FoOiFMpdxiRuuE1wYITuqU8XPyfYLery2bh5HoIpTwm9REEt/kcs/yxHemDOCay7jCezUyDlbgaA0HlpUfHZTkkMspBmrFxZCWG8bYmlkP7CXsQzIckaUgV1PDipTo/O7KP+2ySSO2umj9LmvM0i1FHaxs0lt47ezrCQWSz7GgfIfaWtNUBvSn0afTkrmD+09JJAETCRz9puzDS9YxLJbAM+0fnAGhII5w3Ca3TG08UVgrNs9fc2yRoSqNRbrdcVa3P5T2JuWVu/GdAu8eg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(22082099003)(18002099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yDxpggetTf+o3GfR6M7dMoPc26NRs8hbUaPST3wAV+7qzvUlYW0BzKnjzIiK?=
 =?us-ascii?Q?PQ95nbtfeThBdyy4AUSYeJicuaI/kPspobqr9Yu2w1WGWiy/rEMR6P3KdRIt?=
 =?us-ascii?Q?/DU+ffnK2LWafnu2Zd+7x1ZryIHieDEgKDhc8sls8yLq/8EAe7/I9A/wXYAt?=
 =?us-ascii?Q?sWUq1Fb05MGt65FCCYEH21xUK2lje0YZyWDqpt7fn7qfb8Ifn9DvyvSpQdm7?=
 =?us-ascii?Q?jbnS2aklF1s/nEVgiQ82fUTh+o049EUsRMTQkX5TJqKT9yBmTErHNvlgpvDp?=
 =?us-ascii?Q?QG0+eoCHe9IeU/J2FLNOhaje80U9gz56LuYpaAFDmdteci1BijbhWAPc4Jjw?=
 =?us-ascii?Q?p0obDyRpDOAN0SX72OvIX2Qo7KTLNfNCyQpnj7i99IH2ozNdCepnwl/BTFKg?=
 =?us-ascii?Q?Hcxj/vJgQyuR5APLdxEXQQPgJcHuTSw7xfwhVQ9JrZTRyeq+ATyRRcY0iBT4?=
 =?us-ascii?Q?QTYzaraEdsMXeFaYKu/RSsdIq46iAY4h3kVjRyybtpYfdwOMN7hxc//sKSNw?=
 =?us-ascii?Q?X/Q8r3J/M39TeegJ5Ge5sdzdMXIvDuQT1LRo5uvCJW+Rt3LFlDXWSH06bbC7?=
 =?us-ascii?Q?QpchGzhY9ZJXLA9pFLMdb4Gfe7wQHXJ/nj0xUTficdhv1eqtYNM8i4UjF+tc?=
 =?us-ascii?Q?Z21QySdx13gY5Q5Pmhjs0khsbrjcpIaYRnCymhBZHj20IHVZRXvWvb7cuLIZ?=
 =?us-ascii?Q?Tpg+4+uV+K7FhfRHidu2kDwZ9lK33ThnAiBmZsbLPaob4PLQNv9h5XfxL/lX?=
 =?us-ascii?Q?X9mgD1FXHJOtjZsuCGFKliT3ibqJTGiZ4wMLLTKlFjTK64vZzB9brWmuRp0g?=
 =?us-ascii?Q?OedHwWtJFnLWuvRWhFaZ9m8ixJQOAg4tn/cdhHStCuTfAbfaxxWG2CJN5uq6?=
 =?us-ascii?Q?6WfDg9jvopC0f1uU4OyX0eUtEqf0v6huPSkcCoPkCmLo3NPK84Qk6zvoMain?=
 =?us-ascii?Q?wo0RittPouzgtGYOPi4Yh/6EfKPZsWviMNRT25y3FOGvXCwggTicrOwviHvN?=
 =?us-ascii?Q?AsF0n/DKR/mTni2QfodZP6MpJ4I12w4KO15oO5VyosE1tAA/qcgL/4ABBSHo?=
 =?us-ascii?Q?hsLSAqwm4vJ+sFw8rfw9plJh7f7bPy0i0E2mNaktNceMlxqdVkPCrswnAsL8?=
 =?us-ascii?Q?ztyKFWQiyjODb9hrsvmes58gSfe48tjOget5fjjgfJDpq+qJ91++jDGNJSti?=
 =?us-ascii?Q?oiUVIWEtqeMyhmbpRPBZ+ZyUtOjC766RNZXlPRWq/lZWWHYS9Vh1uLwlYMz5?=
 =?us-ascii?Q?rLlUrdufQs2+zchRF/RA8xUMcMH7NTyNQDOaKY1PSwZFXAbaZE9aUHW1WP6S?=
 =?us-ascii?Q?3fYkGkJKjlx2AQa/CHLva0li+upIr1pEF+r4AfFF09+uwM9HexDDmt2WV62u?=
 =?us-ascii?Q?kxDIikbbZ8Ho0nTh7+IVMWONHz9YLvy46uqHiFSISHeY4zssHteqJfPjsfhs?=
 =?us-ascii?Q?mZ8RnM+SL3QeHnNJ9Tf7F50ACywZ5yZ1nGsi8K2UD4S+cv+Zty3P7DstJbTX?=
 =?us-ascii?Q?9VqDTSMmQZ1lx3N3iCzOqv9ETPpJrw58NEgneDpRwgiV8AR4OGkILR05UFAS?=
 =?us-ascii?Q?jqjRFB2ef2wpJxtYjP5AUoTT4s2QS0+W8SM8Ly05iVl/BCNnxpzBCPNigz7N?=
 =?us-ascii?Q?93FZdbObn4JNft9idsaRHjG/5gkRrqDZPpYGPB6z8+6E8jBqZadkfgT3PHd+?=
 =?us-ascii?Q?WfRIEpbuArelYi745aDXY8fwiW4MKUrvpmdFjKXcxI6+ojJ5NpRRR1Q0CHEX?=
 =?us-ascii?Q?F36pQgOhOw=3D=3D?=
X-Exchange-RoutingPolicyChecked: XNH/vHyrQ1gWOehngwgKyrjxVSbKOckj46T/nOmB1sbB7cWY2/sQ13eNcTiC7E5/pdQ4uwIuFqpu7W2khnWJTP5yobTg8bChXCSGFdsQNNNLgm7c6bC0VtAurJMUVDYc82Z9Ynt2UFqk9C9Tj1ZPCFg2fQem7PHYC9vLTn+7+8+gtEuKsVwJWfCh7x+XKeyAzAxXgkg7dUMudq7fy6t8JX8F8FzIOfeG9zI9fdCG0joLAVT2VdjUgQq+KyocLJsBca+v+vlRS7Lnpus68EuZscVPL0C6982g6JFgJ+sX+DnlU0sRCjuZMXCqLvC76FMEGhpVNFOD4A9WJDDgwKXi7Q==
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e0db65d-6d9b-4356-6851-08dec0453b6c
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2026 01:21:11.8147
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UM3bLC8k2VHkkDohSYA+RDy45/K7rwQ5HC6RpiTZvvTMOOaH9j+mMbd+rQJ+4rWywGSAhe2MPhoEeVN+hQ5zOUBJQ/k8hSHIH8xHgRoy9B4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7754
X-OriginatorOrg: intel.com

On Mon, May 04, 2026 at 05:38:10PM -0500, Ira Weiny wrote:
> Update MAINTAINERS and .mailmap to point to my kernel.org address:
> iweiny@kernel.org
> 
> Downgrade from maintainer to reviewer whilst doing so.
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>

Applied to nvdimm/nvdimm.git (libnvdimm-for-next)
https://git.kernel.org/nvdimm/nvdimm/c/a6e0072cfa82
 
