Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A8E378D9F
	for <nvdimm@lists.linux.dev>; Fri, 27 Mar 2026 17:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774634046; cv=fail; b=HzaJpFMREhHxZPgmBwXDddEq9/yTeANbeEtBgoP5kleTNrnrUPytSj2XEbewYuFkdT/Nfh53RCGWL9Mi4Tk8poCAlQ7yXXIfZb82YZMPtwpEo5oACXMNrFCt9aP4HbM9HIFcy3Vi7Z5r6iIbOzP3zk+oAyIgktFbwhHKy1VMIdY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774634046; c=relaxed/simple;
	bh=6yzVRSKN/d8cmdCrTI5EjRQp24YFzTl+2GJhJBthaSU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=WpHFccEs/Pig85Zpr+aYwM6AjUB5+xNHiXH23QfgLR/9uURyIDLVUvlhaAwy94l6/Po0Nq6sXgODSthPZ9BVLBq2xY6v7cNdZQ/jV6sThp3NzHsTwMdYE6kIL3E3a2OSMJ9KtYen71VsYul2Z6fw6ygQTWWxVhg9GcKJAjuS5d4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FmzSCGAI; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FmzSCGAI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774634046; x=1806170046;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=6yzVRSKN/d8cmdCrTI5EjRQp24YFzTl+2GJhJBthaSU=;
  b=FmzSCGAIyTALmqAOa6tKS+/gCHtH7GZjKw6Wd7wxFX4nZpjA+Lufvwnx
   FeCdB578O4ve8Fkp8Gtfe+icJIpsJP3jrnJYopOF2oKMo1PVn+FBQZg2P
   AUDAbNvlg0H7S3RWVshBmMqR7hjiIFSSkNNkwGMGLY9CBDd8Mz8tYkmT4
   4LB0tIVDmZim4S1sFcKgxDfB/ithE4u0mQK8+IPT0OfFTpWcThAdjuOjz
   O0x173znKxOvEj0ZbCXxxC/ygtE6FsXoDanyK2E83oOJ6Wm+8atDMLAKT
   io2QbQO7tBkiXPqTgVsQtn+YT6iDej5UBD5kSJf9+he8LqlMV5ZHt6K9v
   w==;
X-CSE-ConnectionGUID: GCiy7pb/RdSfdBC5u9BOdg==
X-CSE-MsgGUID: 0EypF33hQ+mLX8FsSnbATw==
X-IronPort-AV: E=McAfee;i="6800,10657,11742"; a="75779662"
X-IronPort-AV: E=Sophos;i="6.23,144,1770624000"; 
   d="scan'208";a="75779662"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 10:54:05 -0700
X-CSE-ConnectionGUID: lLfLWuzcQbSsfsBjXzLN1A==
X-CSE-MsgGUID: Mlz8/fNVTvyZkluSwCMneA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,144,1770624000"; 
   d="scan'208";a="218764094"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 10:54:05 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 27 Mar 2026 10:54:04 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 27 Mar 2026 10:54:04 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.55) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 27 Mar 2026 10:54:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mvl56j90aisZ1LiB7M65/shZXS8zm+8x+ZPFqk1PP09y8Ry6kbtKT6KPnuwuJ7WGIzvVPn1s515NQ6GUL2PDOXA7l14zBiPjTlXyNQbq++cttiyzm3nbhfjg9Op3OqYBiBNXUFpoHICRAhSISWGRp9bsA/BnLqVPvxrRanD/2NM8KOlB9OfG4EZk11ktYPJQrsR5Z4icI0bh+ft/wKpzMNjUrQ6XinyUjtKhZJjqlHkQboBb99vqo54/P3PruJTd/aZYo54sK90aeV56kVGv9h8oAJeqP9jnQN3CSq6coEsntNqhmdDZ31Sm6XBrVYLWr8dzKe7+hq/UyPEvhyezOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vzuEBO2Y414A/JQ0QJk72T+FnmwK4S2ntxqFkH6wp/c=;
 b=XDgvoaldghOdwSltvlgTkbjNVsQ+ZY+IiASCdK4zSCiGN6fKVN0O3Zoi6RLh6JzH9XbCxLKTa1HQcnC3bRL+qDXsk/KalLP13xAUbDGnO9NBHPNhxDznvAIQVPfoNsR2YlriNsGcot/bVlRr1wFQljz/RDJbhMWKIzz7CJWvRTEJ9iXGrRxiv95lf6OKihH7zKEyHafF41kWelUqaEZpvzu5dbI1u09VHUiVHjCEK9k8LL/HcH6NBRxLpK5Lotfh1mrT+eWSctKSZ5Q+Ok0ooIxhj5VL5oXFQxXt+0PpHetUkYr/+PT3tmHxC7mJWnkuFbsPqdArXVb2axcsiF+UBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by PH7PR11MB6835.namprd11.prod.outlook.com (2603:10b6:510:1ee::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.8; Fri, 27 Mar
 2026 17:54:01 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::fa8a:90e4:57d4:8026]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::fa8a:90e4:57d4:8026%7]) with mapi id 15.20.9745.019; Fri, 27 Mar 2026
 17:54:00 +0000
Date: Fri, 27 Mar 2026 10:53:50 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Rosen Penev <rosenp@gmail.com>
CC: <nvdimm@lists.linux.dev>, Dan Williams <dan.j.williams@intel.com>, "Vishal
 Verma" <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, "Ira
 Weiny" <ira.weiny@intel.com>, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] nvdimm: use struct_size for allocation
Message-ID: <acbELuIOm6GTRRGC@aschofie-mobl2.lan>
References: <20260327025251.7688-1-rosenp@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260327025251.7688-1-rosenp@gmail.com>
X-ClientProxiedBy: BY3PR04CA0018.namprd04.prod.outlook.com
 (2603:10b6:a03:217::23) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|PH7PR11MB6835:EE_
X-MS-Office365-Filtering-Correlation-Id: e3abd568-3f2d-4e39-aa25-08de8c29d39d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: vXjFY3OMbsrSBJ1QhSIxzBOil1B24OgFqeH7vrM9zOaC4tISx+m8o680a+yfOYUyUCYHWUzAXRsWI1DUUMb0po7HwUqto5+m6ZXJpEOmGC3ps9I43W1D8GmGOxL/pax5917clQsljKx98fGtyBIUNBvQFMVNPaFaCB2dZalzQYnSn7S5neGmentE5yf+sqtTxdjmQ5VReeGmf/6+JpTbm6Jlak/P174hbkfbHc/qolidUOeoTN6D1HZjAbdoK64JE6gRheX8iayF++VEEGIjwDzxpq7MfbHtngd5eD5Z37bZEvHN+WIV3jB2WaOw5FSBkKCqR0tYNNKXLNnlVjP4mrSBfGh7nzdSq1+odIAsH+d4rgRjE6FE54VimEks2N6O7AsWw167xVlCasR6pkTC7oQBq+PBkM/mhaGJLOHByyXR5gyuajJ9UVUERMGMl+SRoj1pJpE1eOoQ4Cos97iQXEj8CcxeftL1ZIGJguOn9WskPPp4UX5w9MtyoQNhknbK6oPDpi6F9UUWkw0copfy+KDEwym1uKa6RMv75bLjo0HNjt3zBB2S18fZcJMSxmjRDbhe6NHAm/aPjL9ME5Bx4Uzta4EYDEl7uSzWsF44Ye7KOVf0UQXzmVZlTRUW5bxg36X65jGMHmvYS1Mp/C7HRIMIEcXyKmo/shaxvdQDyeq+VRw4lHSvs+oIN5GfePxm7+aZU63Y7eMsjTTLPvpg0fszbiwWpH6SpUEBvFi17hQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ma0TxrW45oHwus2T51fRRzSrsVztZmCJTLHXtKfMHHZupPpR/SSDfi/qK/yp?=
 =?us-ascii?Q?7TEAktdLTGGCUu0uZhCfisoh/sy0UxwioM2hb+S323Cicf7Sr+AortoTiY6y?=
 =?us-ascii?Q?a8ZIYtQl2OXGkXNRLwhnS1N+LFUI7aee/Z1VQXTrhxrofuHmtMuT0ptTI5Ij?=
 =?us-ascii?Q?jaVAUnYQK6fFOws4bA2/Sc1iF0wn7Ym8L8D0/xVpdfNwlJPM2/M0gcNi1rgY?=
 =?us-ascii?Q?YiLW/YDyJ90hqw7iHHtOogQDL6HcP3WJxPADcS2PLt5jpD0ZUgs/Re3fuRFB?=
 =?us-ascii?Q?Nizo9w3lG6HFpH97FBp6RdMgKO+sN79zpBKCyrJmjvdJaAtFNF9OX4sOK4z6?=
 =?us-ascii?Q?NRy2AQtQ9QB9xMirew5VX32GPAmP0q4XyUhrsDfhMntNb4Cstl7Lu0cZQPRP?=
 =?us-ascii?Q?vjNR8vli7llUkP+p/Auhpj26DGJLNcPmDhLS9hN2olsqn96HQQlly/Km06GE?=
 =?us-ascii?Q?dmuQyGs7pa7j5IyXVze/wlO06X9knv2s2Vc/eoq8EPMsqfissMGNzsP7TL0b?=
 =?us-ascii?Q?kpzIIAO6rtFbe9bXGhLQMEql1mrhqXK0UpiTxS23CZGFaeYNJmACxIgI057J?=
 =?us-ascii?Q?6bHGbYCOP7EJ8ZgD9e1Tajzts3hCDAgqdCbA3qEH9k/3WkgVoYppViv4tBRU?=
 =?us-ascii?Q?ng7DvJAHdLWa62eYUko/3DO8m1t8mem900fzIzrb50kXnwa9IqjyrvRi1znJ?=
 =?us-ascii?Q?iQLq2tJkkYYDmGWj6tKAVxuQHu32FycIbkAeO3KYae8lsYRECOMjPuFN7RF3?=
 =?us-ascii?Q?jrPM1V+tZLWJitSWBUKR3arV3IQoNIie77Bu5o23ssJ2XbA9Onk8YAihmRDg?=
 =?us-ascii?Q?2KDChfknWPl/frqlYwMUVRK7KatlY085w2e2bvvNV2f4p5HkS8veGHWCbF/4?=
 =?us-ascii?Q?HGXP0Kff12z8ZLxRn63+0QeqVdOIMSy6usEZKVncXcFoKA/Z1d3GdrxijrHo?=
 =?us-ascii?Q?iZIg9qyTn3LNspMNEOWdfNrboWyruICJm7zjntt7rL68FnNBw1/axNBHFtx4?=
 =?us-ascii?Q?KwBaaEBm9gfxaObAYthrtKgN3iTw3AsBMJgIR4hLYlJdW98LePnWEptPJHFf?=
 =?us-ascii?Q?ZvSE2DduToZP3HU7TszhjMBiH7ZNNoBHCLA2OC68fh1iDJi73SPmxYXh0hWf?=
 =?us-ascii?Q?BytvuuZlBFM4/Ld0fKnnA7oGFm+MMR1LmopvBZSuDadc0wS+kSKMpvk7dnv/?=
 =?us-ascii?Q?LmcKvJV/35sDUJrlPvGfaF0baTfYsx1AtD4WfxskBOAI6zobnlZjzM/CHupd?=
 =?us-ascii?Q?O9xpRVKBMSbqDaNiH7v9VgpIPyXKY+786+cgpQ8TeeDLAOriMFhy48pETGUd?=
 =?us-ascii?Q?hEJvjncGykWfVUm3IYLBv4Msiwhf2uy9FKfVHLx15JUuXT/TYSlxIBtKPgc7?=
 =?us-ascii?Q?97eyvTxDV377TCPpte3rLY/XwzRGRHtflWTfHlzOJM0pquWAURSQPFMAUgV/?=
 =?us-ascii?Q?ZIsFDoNgDRQS5XWU3EB5erdrU18kVEHbvuz0m6P6ieiFo31ckzKXe6IblI96?=
 =?us-ascii?Q?PJGx9gZBL6kjUkN/Jv+FpHDgP55CeQUnkYXlg4BWp880/ORTkEivrECDNM51?=
 =?us-ascii?Q?5O1j78Xu4H3ncuQJkButEq1RJmzuJv0jhDyGBtajDzy419xN8UF/tt5pMfEt?=
 =?us-ascii?Q?z1dZ/Vx0fBJhpgzbNFNkIp40XJ6Y78UA+l+gHJ1udL0qYavoQT9XG+H4efXi?=
 =?us-ascii?Q?4zSHMx/LQI863M7aYQCYy7FRMHkxsgm/yqNNkldntU/DuHbPC+zG4lCrlfLo?=
 =?us-ascii?Q?zFNmV5PiEjVf00xiCbnPfSoLKyzOFYE=3D?=
X-Exchange-RoutingPolicyChecked: fWV0yQju+pyakXwDB/0d5HPy5FAdePLjVdUYBI+EnF5cocxV4dfJxf+l0LequiLpAdF6vYAfyM/e7hThnYlaAdHuqxq0t8GBaxhxrNpvLTtFjsKevZHtwreYA259imayY8Z9HPHJ3pAz9ML4nK5Tt+M3VhcMLXcJZ25ydfHOsiyLjgjIDSTNGy8As+rRkdFkWfZ8Hwreo1rS3OACSvo8tryRn1+lOCWrSmH4ajz68FDBC2GnV9et9L/szP9CIilAlftbGodFqYCWOMTghMe3uGaeb0mq59Fs6ggZxSjXdQNz5ez3Dk7FYurwXhZQau4RLBt/04rPmBoizoCUFDFgPQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: e3abd568-3f2d-4e39-aa25-08de8c29d39d
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 17:54:00.6862
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MNQikJpelIh7FhLo676KuQ9X6jB2Xv4lFuhGhYfrPcLGmuWb7M8jOoHPFQClN7hEmv5cKtltJFkjtbUYSll/wkaCdQ5PRkLpYECCQjSZIZI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6835
X-OriginatorOrg: intel.com

On Thu, Mar 26, 2026 at 07:52:51PM -0700, Rosen Penev wrote:

> Signed-off-by: Rosen Penev <rosenp@gmail.com>

This is not a mechanical struct_size() conversion. It changes the
allocation math for flush_wpq but there is no commit log explanation
of why that change is correct or safe. There's no commit log at all.

This code in not just counting bytes. It encodes assumptions about
the no-hint case and the per-DIMM indexing model. If you intend to
change that, please study those paths and explain why the new math
preserves correctness across all topologies.

> ---
>  drivers/nvdimm/region_devs.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
> index e35c2e18518f..1350a34a34ce 100644
> --- a/drivers/nvdimm/region_devs.c
> +++ b/drivers/nvdimm/region_devs.c
> @@ -104,7 +104,7 @@ static int nd_region_invalidate_memregion(struct nd_region *nd_region)
>  
>  static int get_flush_data(struct nd_region *nd_region, size_t *size, int *num_flush)
>  {
> -	size_t flush_data_size = sizeof(void *);
> +	size_t flush_data_size = 0;
>  	int _num_flush = 0;
>  	int i;
>  
> @@ -117,11 +117,10 @@ static int get_flush_data(struct nd_region *nd_region, size_t *size, int *num_fl
>  			return -EBUSY;
>  
>  		/* at least one null hint slot per-dimm for the "no-hint" case */
> -		flush_data_size += sizeof(void *);
>  		_num_flush = min_not_zero(_num_flush, nvdimm->num_flush);
>  		if (!nvdimm->num_flush)
>  			continue;
> -		flush_data_size += nvdimm->num_flush * sizeof(void *);
> +		flush_data_size += nvdimm->num_flush;
>  	}
>  
>  	*size = flush_data_size;
> @@ -145,7 +144,7 @@ int nd_region_activate(struct nd_region *nd_region)
>  	if (rc)
>  		return rc;
>  
> -	ndrd = devm_kzalloc(dev, sizeof(*ndrd) + flush_data_size, GFP_KERNEL);
> +	ndrd = devm_kzalloc(dev, struct_size(ndrd, flush_wpq, flush_data_size), GFP_KERNEL);
>  	if (!ndrd)
>  		return -ENOMEM;
>  	dev_set_drvdata(dev, ndrd);
> -- 
> 2.53.0
> 
> 
