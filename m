Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3224D32B102
	for <nvdimm@lists.linux.dev>; Wed, 22 Jul 2026 00:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784679383; cv=fail; b=R/mh14d0lX7X3uvbG+XeobSJw6YP05f55iVAE58rFdJ/38zVPMW5N/TQ+nSjPB7pkngUJAGw9VEhJLE8buDR6n9+RuPYVhwkRxu7FwrZVRDsvAyyZO4/oHinvsfGavqcq/YR9Hc/yrdYzLN7n4Ayj5u4z0eI17qenHX+VE3e5Zw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784679383; c=relaxed/simple;
	bh=1Okwk1qOLEMlH8bW9ztUhzheokeWyi4C8eJF5Rv8efU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=f/4S9BPIj3TQuXlU6piOwPhkGFktuCXUUYxZSE3CvKMZOpDI28ygc+y0N+nIbB1PeA1DWqD0g1wY1qbyVTOJPOynQpCLIFt0wNu7oFNlztSvLXcOFm2lv2BIPNk2OpM0AJ8V0RWAb+r/F1tmgpzJg2qHpPL5iOS7uTOoW+K0M7E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BmvHZ45X; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BmvHZ45X"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784679381; x=1816215381;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=1Okwk1qOLEMlH8bW9ztUhzheokeWyi4C8eJF5Rv8efU=;
  b=BmvHZ45X/wqsNSV7r5Ad0+pj3qkWn4gKW8H0jFT4n+l7qFjpscTxXIL0
   T4TDXdqZQLY8D2IPvO+TJ1Z9WjmBA1Vn1QIGjNQDHHkFKhokJ/6NIQu3H
   WGKDCZ4rymKg9UaH534rCGwJIuRSWLS8lIyJvHGlidUwMcWkPYNpSwLu+
   fz2gxkNJ+Tq81yPVtSAYGJyTo0EhcmI4lBlwCWEgYkW2qWNLp9TlqjwXa
   RDOXUCGTmuhPQt7aJBXis3HZvfbTWlS0y6hm4HAUFRBn8eT93yuVJCP9I
   LTgYJnajhc+Dr6NzQgmuV+tRTKp4MalMTxLMQj5hyM58bTl+XbsI2A+Ja
   g==;
X-CSE-ConnectionGUID: itqbVClpSyOIgg1eOE/qmw==
X-CSE-MsgGUID: S4s4XOulQtC4FMFvtAmxgQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11853"; a="96435757"
X-IronPort-AV: E=Sophos;i="6.25,177,1779174000"; 
   d="scan'208";a="96435757"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2026 17:16:20 -0700
X-CSE-ConnectionGUID: EhSqHxAmQXmW7E8CJRam0w==
X-CSE-MsgGUID: RWQStdjOTAelE9L3FLvYJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,177,1779174000"; 
   d="scan'208";a="259887495"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2026 17:16:20 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 21 Jul 2026 17:16:19 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Tue, 21 Jul 2026 17:16:19 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.59) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 21 Jul 2026 17:16:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LzRuPx3xCRIrNIE9qzkIXhZke+9EmIJ479klgMCqE/f2aJaEfjgY/LjlH+7NE5YtgSb7Qc672mJ8Y7qkQzIF3k5P0N/nt87dqCZIjSflq31ogWm3vZ1mQLU3h2dbsf7ac3heWpzyRETELZJH9QZE/pzTXKoMNjiCvGb/TIJ0mt1U8QQe7omuZrolaq6N6jfMeP8vK+/UBHSHEgGOzJEo41DEunY0X8Ly2rNnepVhWA/ZBXLWqOUYqYvyCmubKq9RDpTTfLCD7YvW2b3z8jU1neGPuzeNDALo9kQRu+5IbT/JeC3J6jNt+x6oygm7Ne4ykuUJgeoYysNQVX9C8plgaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J3OGf+Ijn6UAz1PHooJWOHQ+jeOPobHhUuknSpaHbzs=;
 b=hMQpxWC55LWoelWbbw6vsTsxkiylZ9Kdnz+nrEJOJwNTJO6igjuNcghZacD8mE8lyKApvLFdbBqA1FWJrEAfO288vOpW45UR9Q+4h/DoUYIuPQLSQDGFz66mYFhtG/4vM8JwTnaKRSH4pAAWqq9fHF1vONQzuuiv5t0aCnnZ6CnShUuALrbxOhsfmythoWHqSepXcNLuzy9ufa+bUByDyUGgbERT8TYi8aEk+GzdCQNVGUOvsGnrixC60+qCQOxhgZTFMzILy4NCbGreGJgRPvLXCbwJljLdwN/6ap3/K1MP1jR9Fjn4AsapJd7hB3RSjie42qkoF+v2Oqi+A/DUXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by DS0PR11MB7998.namprd11.prod.outlook.com (2603:10b6:8:126::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Wed, 22 Jul
 2026 00:16:16 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%4]) with mapi id 15.21.0223.017; Wed, 22 Jul 2026
 00:16:16 +0000
Date: Tue, 21 Jul 2026 17:16:13 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: <nvdimm@lists.linux.dev>
CC: Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH] contrib: add Fedora release scripts
Message-ID: <amALzWtZBxsoXL6O@aschofie-mobl2.lan>
References: <20260707035709.1668810-1-alison.schofield@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260707035709.1668810-1-alison.schofield@intel.com>
X-ClientProxiedBy: BYAPR21CA0023.namprd21.prod.outlook.com
 (2603:10b6:a03:114::33) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|DS0PR11MB7998:EE_
X-MS-Office365-Filtering-Correlation-Id: 544f292c-ed8a-4af8-506d-08dee7867218
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|6133799003|56012099006|11063799006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: 3/louRa7imGD/DLGRkBgrVmy2LcN+jajX/eMeffi71s+YMGVwF/0lteziUucsZBCtL56Vs1S/GWfB7Yikzj2RxgFTeJfsX41WKmu46aqj0selCctUxttxZfEC89gov1vdVXvMbodbVqnNOC0lkFLObjbDpQdIbiSFi9J/WXAUkQeF8n2nLweM9XX1slCTQarZmBWGbmCBRasRz7f68jkXqYlE7M3vlgzcXT71WOKEuDuDmbEMZS5GFYUodnOddaF59M5Bpc25q8ygxUhgrv5N1TGMPpelgiCL1rVi7jmOrxFk+yEjgvhRPppzwVys8i18Sr6dHoWHrN3yqV/bDmuPKuGm6JqC5K+CZNkNXUAcbbvSDNZMWeGK0P96q7t36m32fyrvG2yNYPeklOXhL9v5o1YiqAYuM2o8LkObRrf1zSDnYWrkKecTtvJ4mzNS6e6VorH6DXgSr5W+OyinRk1mSNCcdBi3MfesIAT7fzOd/ijcGFc2IhTBmFwxeXsM7r7IzWoW5pr355VUoWjBj9eN5e8ckq2AfT9qR3o4Z4cTbK0p3HsXSPqpTSPWecrC3ojHg9lZeqHpjhH+NgAw5ChIcD5OxzLKoO0hlqzN3KhtJvNE5YciBEx6mQmSePPLXG3XWBOvMx2cCnDUmjTvFsPHP9KrTlq0QkS3Kzt8A2ru0A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(6133799003)(56012099006)(11063799006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mLA516w504+BFtdWt6rQuOk7iBU7IUD8x/qpzt7tGooNTumpEfw+W/kEgLVD?=
 =?us-ascii?Q?V72OaXIWOxksH2UOeu9aK3R+86D1T0nF87c2QY+WfeDsI6JDFQcV5hJOt/eQ?=
 =?us-ascii?Q?WFHmZfebw5lxKDGtwFrZQ+1zT3DM9Bcd6YEax3bxAW+ZkjI7mViXnSoo8JYU?=
 =?us-ascii?Q?kS1tPV5DkqSQRYnu2CqUiW4HJ8sJkM4BbjC0sAtS8nW1nGGMDGOGC6shlaIV?=
 =?us-ascii?Q?HsqpCw3zLi+vy8JG5mFD8NuXWzn9DNCzP35F4fBvEmgeeOtirSqnDbY8U+7w?=
 =?us-ascii?Q?aDLCNYxQVAZhTxiiB2Bzmq9vMgxYrjzbPA9z5qzLmRHL3CPV/G9zwZThBdDJ?=
 =?us-ascii?Q?LF60ZEr0gd7nhUVtxkFnFCA6yf8rQqtkd0t1KnS86gR8UdSALbhC7F/0co/Z?=
 =?us-ascii?Q?oDA18LOyH4NLYnif9toyj9nfwNaTMAl3LCNYggQFHp97AWbNdFj0BZMzUbu8?=
 =?us-ascii?Q?IKGcNuOPW93RH7snx2nKF4XkxY20QPTGeucBvMPvaHRZhEgGJy40gyfzDoQR?=
 =?us-ascii?Q?SNbpmdHsv2aYQr5q3QRAgns/dTbE3XdJ9uCr61mPOGmJ5ubq9QHQBvNSlYGw?=
 =?us-ascii?Q?XJ6/V8RL9bpWBgLzyvZ0QULTwPmYeA/8yVhcV4O4zeZ0aVTns7FVycG02aIh?=
 =?us-ascii?Q?/Ylprs934oFsNfAFZyPbbHaOYUzMo+1WbhaBFra8CVTyc/n6h6MTM3ErDm+A?=
 =?us-ascii?Q?59bhJZmv01wXcs46HXHYzm4fYvbLRGeP9ykgwnDjbJDf7Qq+c7OZqANHVc9a?=
 =?us-ascii?Q?47w3N0rbOxitpo3OUd31fodRlIe9Wx+GI1BEW6L3eW4nUMTPQRaevJcAEIPq?=
 =?us-ascii?Q?ShRro6cJraTPAPs9uBAYb2e/SgtxejeZSF+GnHr7in94d0cVoAnUVGJ/eRcs?=
 =?us-ascii?Q?dLjtkv8rjHuOqxlizfJ3JcDjDKTb3gWbAmj/vRHudc0RaRln69FkPZdyU5To?=
 =?us-ascii?Q?x8g82d4amc6ce3yBceIzbyGgTQLQxdZ93yXeLyAkCNG1U+/25JLVRLyGGLpd?=
 =?us-ascii?Q?1vst/DYFtJVatKzy0u8OC5yp78qXqAlMT74Abe3RRtYanXoxrUD0BYonb11b?=
 =?us-ascii?Q?crOI1HtpNxXx8+04StWCwi4NWxmk7Cc3unZFKukJdrcpZUDDdi8KGqzGGZYy?=
 =?us-ascii?Q?gHoRSbaMrSi4V8blAvJ/NJGdGi4CisNJDiaY1CVmYInt5lM4yF8u0IzS2Nt+?=
 =?us-ascii?Q?2wTIF8aAbV+Aob34Uwvd25q7haR+34IG1H9fTLThLgZ5Hh6vLm3C9ShCtDVd?=
 =?us-ascii?Q?VBlt/HIlOr3ji0WI7Gv1O0YuuFGufHhxmJstTcwM8KkxYlNX7p+34X7sGz4x?=
 =?us-ascii?Q?hrDckaleOLXsB8RheEJ+XQ2UDvW43EzIuaPS0WgxE/aoV/Y1NMSKokz2eQTH?=
 =?us-ascii?Q?BByBEa/xH/tqKoDNXqBcq1oTukBN8boJYCAWLSf5+Ar0uWXh/zdfZ5DHt4hr?=
 =?us-ascii?Q?GOiquQl7UF4GvT5huso+WFFQ4Ad8bWwsl8rM8aFtJaYJ0yj5ibUzu8pW/0UF?=
 =?us-ascii?Q?kKH74lc6Gm/DdLnuGueHrJtScycdpdl4vfObmdXJfU9pqO+Z2val2dl2xhbk?=
 =?us-ascii?Q?ZB3+mCLMzGKov58sVkQ09FMMMho6z2CF3GOszcPkKQZFYmyiSZJHhdyPDFTs?=
 =?us-ascii?Q?nOhjh3urmw2iXcuWXmxia2/mtuy4wHazFe6BEy21bdEyeWlgj+4KcMzu2I11?=
 =?us-ascii?Q?6rRoN4vKAKr561xNEHyXClTraGoiZcUjv/GdIZ0UZX2v07U1anz5+8FKd9Pr?=
 =?us-ascii?Q?eTNYYZt29o/s8QRJQUmU7XqfI8XBSHI=3D?=
X-Exchange-RoutingPolicyChecked: JfrBGCv/MFVI1qivro07jGqBvrLj2wvnG3xKJ8IWBIJEyamTGRRkgEDotb8EhO+02o5J3prZO3tx6pFVv43djVfbHe2vbGtw3hH1YvRPU0PauuudhD2wnJTP98QYnDR4rli4tYR8K0yFRy7HIPZUeckrMMlf1aWqLx9a+eFIqbSkNYuZCI+j8o4avBRvLF65ooUdXBfk9zCnm9EeRGpbIskTAo2vjzsrXSkuwMkoyS1N5o85M0EF7u5a33rRZQTpsb93atQ1jWyovKc1ioJ1K31O8FssclN7MFDSV4a8nH5njnTq/l3TDrFuIH+iwmM1x3+gGtVS+HI+8xHWpTBZDw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 544f292c-ed8a-4af8-506d-08dee7867218
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2026 00:16:16.1184
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B/+kFZVw6UaxZIye9Vw51cZUp2Re5MKCDVqSNgoBGTSbQUlVpPlZBlZAoOK/3TXKkKYD3Gg/4hGDh+IODKBBEfO+FZoVsPDonre/Abv/Z20=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7998
X-OriginatorOrg: intel.com

On Mon, Jul 06, 2026 at 08:57:02PM -0700, Alison Schofield wrote:
> Documentation and scripts used by ndctl maintainers to build and
> release Fedora packages have traditionally been maintained outside
> the ndctl git repository. Bring them into the tree under
> contrib/fedora/ so the release process is documented and
> discoverable, and the scripts are reviewed and versioned alongside
> the project they serve.
> 
> The scripts automate the Fedora package build and release process.
> They run from the upstream repository and operate on a local clone
> of the Fedora package repository (dist-git), configured via
> contrib/fedora/config.local.
> 
> The workflow is split into discrete, individually verifiable steps:
> 
>   01-prep_build            download release, compose the spec, upload
>                            sources to the lookaside cache
>   02-do_build_local_checks sanity-check the dist-git workspace
>   03-do_build_push         commit and push the spec to dist-git main
>   04-do_build_branches     scratch-build gate, then fire Koji builds
>                            for rawhide and the stable branches
>   05-do_submit_updates     verify builds completed, submit bodhi
>                            updates for the stable branches
>   06-cleanup               remove temporary files
> 
> Notable design choices:
> 
>  - Stable branches receive the release by copying the spec/sources
>    files from dist-git main rather than merging, since stable
>    branches can permanently diverge from main (e.g. after a Fedora
>    mass rebuild lands on them independently).
> 
>  - Builds are submitted with --nowait and run in parallel in Koji;
>    bodhi submission is a separate step (05) run after the builds are
>    verified green, providing a natural checkpoint.
> 
>  - Every script supports a --check mode that verifies configuration
>    and paths without performing any real work.
> 
>  - Local mock builds are dropped in favor of the Koji scratch build,
>    which uses the real Fedora build environment with no local setup.
> 
> The contrib/ directory is excluded from release tarballs via
> .gitattributes export-ignore, and config.local is git-ignored as it
> is machine-specific.
> 
> Originally-by: Vishal Verma <vishal.l.verma@intel.com>
> Assisted-by: Claude:Opus-4-8
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>


Applied to pending for NDCTL v86
https://github.com/pmem/ndctl/commits/pending/
