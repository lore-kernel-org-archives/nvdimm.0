Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8DDD3B2BA
	for <nvdimm@lists.linux.dev>; Wed, 17 Dec 2025 04:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765946547; cv=fail; b=SF1mLdMAY//7FK6iB7b8L8fM1XRGq5IDz3Yxt8eZFwDMAtoftH+6c0wiiM6npdVYFmxnAtbDINGL2wzAmWQsJKrxhtrq+PjdzxvW1fUryOXae5rVJY7tbufArLAs9iewjmYftTF8Z5N2Lm581t5h+Bd7ucvgHpJfQdKR8dx7p8U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765946547; c=relaxed/simple;
	bh=9+pjXcebyE/0cV+4ZYAROG6chasF2PmOEZ8OdwQwZbU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QmnbvhcZZTStyYTeW21Pu6wCtZiZdhmkHlxzx5tr7OCi0F78p6iPLnvI1/aqyzo1EvPQn98jDNnyAFCxxvPm/rfmzZaYzTWnm585G47jOwwzG0lxV84yiaxpt/eWtN8uvMO8U7H+eTZS+c3zy9jk1TkzELAVfoMnfH8aInxUeos=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Eo8owl1J; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Eo8owl1J"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765946546; x=1797482546;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=9+pjXcebyE/0cV+4ZYAROG6chasF2PmOEZ8OdwQwZbU=;
  b=Eo8owl1JWcrWKblwIeLQj9NzFkbLPhRRk7xE1KNB4q0MsrkenbWqZRx8
   uGx/Lgw5EZCQAiJBNWQcCms8cHOahMrVMnKj+E+DBqXgSgMJIkBmtFaFz
   ArcdIwTSN7NkAoOj7jJInfGmtnPcjE04S6ZOTKKXAfShviEHVrVKE5jJ0
   0MXUMbWrP3hEUhBKIswqFSsg13gTsSxgnOVpm8pczqrNkik/XQQK2cn5p
   Pm+uEjC68HR6IvfpWby73BzXEbx2Hnwh+GVy9FkEqvYIZlFHhT8rQDACn
   7pZ2zlvyd7WBXtcZ/3GYmIetGHovzgl2FdfQ96K6HXzVY86e10iK62DbB
   A==;
X-CSE-ConnectionGUID: dKmJEUP+Q1uqpKE9F/rkQg==
X-CSE-MsgGUID: VbWSE5QPQyq0RAo6GfdQGA==
X-IronPort-AV: E=McAfee;i="6800,10657,11644"; a="79243967"
X-IronPort-AV: E=Sophos;i="6.21,154,1763452800"; 
   d="scan'208";a="79243967"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2025 20:42:25 -0800
X-CSE-ConnectionGUID: mIcRTkhxREmXlaOxPRu0CA==
X-CSE-MsgGUID: k7T0OtnCTzmQkCJPw9riEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,154,1763452800"; 
   d="scan'208";a="197485018"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2025 20:42:25 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 16 Dec 2025 20:42:24 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 16 Dec 2025 20:42:24 -0800
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.50) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 16 Dec 2025 20:42:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yVqKYGN460N09zBOFv0ivv8E2aPK079vvXKaSPRDRtd+YBHYlL4Godl8wfoi018dEsWeoSklE5FPhVsL1uFKtdYa6537Dpkeijj0uCUfhxzyIn1BwE9mcz9sqRKiyDERc2QUyhTDP4FK17FZDT1xiUme5BI6ekVotskLJnRxioXywW+Tag3y/gx4+VYLKsXWGqtbwqcPxRBB8Av/2tAZ0VboJe5UuRAYCbyxFmOHQy5u2ttXvO5EoYktzL4oj10cQk9N+En4kq9KOdQrApnKYWsURv10BXN03Ul/QIyjp45Y9EncJjJvzcdSO22dp4j2pT24n5kAM+5ZInK6Cc7lJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FHYs6kMlVjp9wUIj8MJbRaIntxgPUpV3MVBpZa+IftM=;
 b=vuY+WfteDLQvDpVg/mQHwkyzj+Px195x3KOVuoqw7Xfq1GYgHPknwuvbtA84DCdr/C6NixH4reQow7C42kFFOYgaucF7MHK5Axut2cdM78WHdVrna2VPge4j69DBJfGhDtPrkqQngOjQshE/yNnJ19Yhr+WuFRDiED1KNu+gleKbw3wOCCnBITLaWGbxKxYwkylNd9dEattvctWKbcOY3jD4fit3Nf09v0jPAuE9uvSh1ps/RRGISu6PmPvxVB/gWVkJl32O7iiLEe4Zr+/N93W1416A3fPIM6mdSbA3juU5hVKSU4m1oLAUiuhxHr0TSCM0ZVI3QKWXzgSfXKwWxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by DM3PR11MB8714.namprd11.prod.outlook.com (2603:10b6:0:b::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6; Wed, 17 Dec 2025 04:42:22 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee%8]) with mapi id 15.20.9434.001; Wed, 17 Dec 2025
 04:42:22 +0000
Date: Tue, 16 Dec 2025 20:42:18 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Ben Cheatham <Benjamin.Cheatham@amd.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>,
	<dave.jiang@intel.com>
Subject: Re: [PATCH v5 7/7] Documentation: Add docs for inject/clear-error
 commands
Message-ID: <aUI0qhTRx5s63ixW@aschofie-mobl2.lan>
References: <20251215213630.8983-1-Benjamin.Cheatham@amd.com>
 <20251215213630.8983-8-Benjamin.Cheatham@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251215213630.8983-8-Benjamin.Cheatham@amd.com>
X-ClientProxiedBy: BYAPR03CA0019.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::32) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|DM3PR11MB8714:EE_
X-MS-Office365-Filtering-Correlation-Id: 44f9a43a-2896-4b4f-190f-08de3d26aaf6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?bnzNzFIchPfor3033a2hnUsr8tC8GHEPgyjEsc+bL/YVNw1WNDZG+CdaKNv+?=
 =?us-ascii?Q?opkgO6cJPk9K0aCMTFWw3lYwgDe3C3lRt3s3TFrCEZA1GgobN7nPOJWeQAoD?=
 =?us-ascii?Q?7Cf47HauxCXyHVabbIWYSuf+Vb7bUJfmHifLM3LsPquGODMrgAiDAlzB1U+T?=
 =?us-ascii?Q?P9rfZzEmVEIP0yjQBV3xTg/YnWhHxdOTpqX7kPf59OYiYDT/j7belqE88KIH?=
 =?us-ascii?Q?vdsjDQY73ePpP6G1tj9xwH1K+4u6chyvolHrL5W757tVsW4z9sRgsTGUJS/E?=
 =?us-ascii?Q?YebKGIGmRNBqE2+MqUk//wb1rJab29QeYR1Ps0L9FnpPiczK55qsYNAnwhH0?=
 =?us-ascii?Q?ipNfj6p4qKh0zTnkDTG+nzTbeJm+nCeME+I13syUioI+pFtz7O2bYvW9rb+r?=
 =?us-ascii?Q?5mkbe7WJ4LjPiNTIpcBJX/wuZs59HuUDNcRbPXi2d4dUwMGPN/eqGq5LNOAA?=
 =?us-ascii?Q?54Z336jWulzoLr1K9f9sHQZrGa6RG/y94llFn92xhF/sM+yzPHD/nk7nQ6Iv?=
 =?us-ascii?Q?eoCtAYwiNLXUDzeFQtzys9e9SPdtLHVakIP6nWmraWgGJLWUD1/rMWXI1htI?=
 =?us-ascii?Q?VWdqsMyQwa8qTTn//k2QE46ma8Z/IBimlWEFQSmSqDagoc+2BE3iocBnr6aG?=
 =?us-ascii?Q?oZ3Was3ptcRBBuWXQF4rD9Wyk7TeVFh4RJpITupeyQbZ2/bQUBa/8eYoNoJy?=
 =?us-ascii?Q?iXABjhhnc3GjaXwLLKVSE3A/1rIcHEqhwpQSAQkvCvkiBQlF9RdAjqFqve11?=
 =?us-ascii?Q?M0VOVYmdFOd9lA6xTJH0aVKO0PZ00xPHDHXw05VTEL0rTQNXbILEdGmp1iID?=
 =?us-ascii?Q?PyYvJz3z//NcF8GxoutaoHB/Krh0QJmkcGvoLfNUR22nfiF5iJ4/2xqV4kEx?=
 =?us-ascii?Q?z/W/ju0jH4GqbqCrQWmnmaTJJUX73tq4WTAtvvjjq3TTlSyX34kyslcQQKwp?=
 =?us-ascii?Q?dTqCuF/mwiYQsDNtTaYj58m5zWztnlGs+Ne7kJIoLHc1F1Ntmbhjfx3nGydr?=
 =?us-ascii?Q?4iE9rU+Nui36VpNN5bYAo/QE/fB7AvsXt7b2k7GzqkLQQbxZdobUx5HofuGv?=
 =?us-ascii?Q?HJKfszrx922X1ZDgKGHSt5NdDtXpecGLatfli7g2re8aKHPRNVGdehIKnZO4?=
 =?us-ascii?Q?dpyTWB4+l+hJqsZ00dMJgERtgVaRk2Lgu6yRZz1/JW193Xh7L8POY2JZmxF7?=
 =?us-ascii?Q?xfUnlUT3/4YuhxeYnGnXlBZoPgJXVRe+KBWn/FPIgsQMGFg04PmddElJK/cK?=
 =?us-ascii?Q?4ofMvsBVDZwnRiO23Px3ZNR9tNpNDecnDjUz+h4aW2Oomfmq4eRUwlHYaIpE?=
 =?us-ascii?Q?gDQEtpaLl8Z5l6xyvGBMeWGwMEqsBRPNOfLwvSNOmU1Nz+u+iWwL7yR/EA2b?=
 =?us-ascii?Q?JcD4GCfHIen8x2UYMgXREUSpMr729+k/lb+qNb8kKSVhGsmcGlxgHJqGVqvB?=
 =?us-ascii?Q?o4GlEbMfGniTOfCvM4sJPKrYXfNxs5EJ?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XpTCdcF/Dcf7km0gcLd6mmZhbWHhTjfIcUHB5ehMHLonGwnGKu78REZgxsdo?=
 =?us-ascii?Q?SS86HXb00mqJp/MdKUGeCaTeogQ7BC19oZ7c11FrMSjI2DMyi2FVAXqMMdu9?=
 =?us-ascii?Q?UJdO5yMRN2xFpxnKow21BtMwGv0UztdBcbZepByR7Cjxmaw7alDEFp3GPybx?=
 =?us-ascii?Q?pdObnIHel+v7JC3RDytu1UHipTpCoQckUd6oUNLyMyZhGfXmLjf+JpExxz8z?=
 =?us-ascii?Q?rSv79OtWiBvIrD85hQulS70Ehv/IL7CiE7gqCVUsoP58MTuj/5L2wQXHQzy/?=
 =?us-ascii?Q?1edvPuDHxI8H/CCbLZxf4xua3FW1FwQSpNLTMTPrLzHFUzNGUoTKESrnaLJ1?=
 =?us-ascii?Q?pCX8ihbFTwODsZeAbGrVUmClswmSbuUtSSoIFIDhAcfIREhgYCCCM4IUD5va?=
 =?us-ascii?Q?xJJj1cQPJrDqgSqG+CKNglmDQ3q7ncHIdyhvv01AFay+eq+RQRpfPHqtt9WX?=
 =?us-ascii?Q?Fr3u+B3iailmTkzmZLWSh5bfbN93AmGlun2wgXma3+fnTKlJzqatMZsCgJpx?=
 =?us-ascii?Q?MhEE5/GA+x/3tFvrnKYvv0cz3lq0q5tZVbFYw6tejCdZQ8mwogft8VJo9YPy?=
 =?us-ascii?Q?nI5sj6jhH0bwbvDNjBkiQZDqa/RBQET2LeNxWfQDOwQLXeVp3gF7ga7i1+bS?=
 =?us-ascii?Q?U/mOJILnrqMKhzZVs25fKQUXNT9jmde5HR6Qc1hOYPZ69SnGXoV6SuuM6Ub1?=
 =?us-ascii?Q?5bl479P8otZzFbQf1LNgDWBQKutY3eNjIo8yyZR+L9wSqkDOtzyEk/9k24E5?=
 =?us-ascii?Q?R18h7/6rmVqtxIBTj1NZSb7+FV5IpMr+h9VjaVtTgya55lvcqWzKb0SpuSlu?=
 =?us-ascii?Q?tCbDV/Sp2wsCSLpk4GJtNxp1FtvWnz98Cw/5JlsMyxdhSpbZ8akhJ+hkze1n?=
 =?us-ascii?Q?Xbn5yWa+n94zuMVLKpiXRt0x4UPuNiAGAxixsjiN9Ff8RVOtHX1TCZQAv1Aj?=
 =?us-ascii?Q?wlsz70Bs6hriZB672QKSFhRDJd0Iz8rgjX9gSH4vyNv936Gn4dZvbD4v0kSs?=
 =?us-ascii?Q?HNo68Kh2KwVj+NKPcVvx6DIunLp26EB7kcTtwoYdpi/33q/IEksRbpBnIs8s?=
 =?us-ascii?Q?giV5Zi+wUbJJUJsa62S6WLy/0pnpHLhFjSkRnVzCh1w/Ua5DKIESAhHIz/oc?=
 =?us-ascii?Q?wA8ohzKfofti4T71WiLfkHa57X3EQGOhvqSsa/f5eHVVOUJnt9RcMGvlHrql?=
 =?us-ascii?Q?6zXisG9aW3CHZHlaeXl+Sx9XylxgwdN9p1IQb/QL7nvRKLJjeI2P9UdrVFA3?=
 =?us-ascii?Q?QMpgDlVZWWsS19O6PQMsdHIQmKC+oGBG5eAfGyv8HRVRcYRWBzj0RNeJtzbo?=
 =?us-ascii?Q?/fLzfHG89kI/1qBhgUgGOIXQfjMWzHC3Pkr5JUPH1w7PITqylqHODWmqF+MQ?=
 =?us-ascii?Q?Q73octBM9KcdjVUfMbGRHGVuSAXblj2pM9ULaHfRK1NRHAWzLvzjMypn4GZn?=
 =?us-ascii?Q?J/xkeWudaIgGjaWKpUtxuCpG6IIEGCXktTt1ln+D7uqkUuJ+aOpFd3LPX4ub?=
 =?us-ascii?Q?obs0c1xeVHHjdUS/oNrEhtzkD/VANA64ZzQggq3oJ25uZ/DfDvxnRtQWgKQX?=
 =?us-ascii?Q?u0/coqiJVkUA0iXRHhvcw2t40F+b09FTNAgYQCr6NPjWEY4fj3nFn6dP3vpc?=
 =?us-ascii?Q?Sg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 44f9a43a-2896-4b4f-190f-08de3d26aaf6
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 04:42:22.0568
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G9J/VrrWpOxEchbdmmiEfnV0nxNcsvdkhqzo/wghvBacZgnpUUQuUiPHyYp6IAxCz52qo1w/b+w7BRAyqVfxMqMcXlh5Rzp99X9AjcqtMUw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR11MB8714
X-OriginatorOrg: intel.com

On Mon, Dec 15, 2025 at 03:36:30PM -0600, Ben Cheatham wrote:

snip

> +# cxl list -m mem0 -L -u
> +{
> +  "memdev":"mem0",
> +  "ram_size":"1024.00 MiB (1073.74 MB)",
> +  "ram_qos_class":42,
> +  "serial":"0x0",
> +  "numa_node:1,

missing closing quote, should be:
"numa_node":1,

snip

> +cxl-inject-error(1)
> +===================

snip

> +Device poison can only by used with CXL memory devices. A device physical address

s/by/be

snip
