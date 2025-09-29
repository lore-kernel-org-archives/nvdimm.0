Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 546B230B539
	for <nvdimm@lists.linux.dev>; Mon, 29 Sep 2025 15:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759158223; cv=fail; b=c8L4mFdvjO4/j5JQDkQfagtn44s3Hozi9wQRgv+BTNZBXUIRdupUU2SRnkYDuKlr36kHIlKeE1SxapfekINbS+/9gr+lAm0lHqOAFzxNC2ksjfUknjJ7SB4lhecogIz7+Qvwc5as5eo8Y8yYIB01g9muB291hJLJ+Z5cqLeZnS0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759158223; c=relaxed/simple;
	bh=l3XZEWn4DsJDBQlzCyWFy3mOc1T9k+7w9mzc5RAYl8s=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=oMl7GGNUKOPdISfZrL6Ah/lA3JhBv0HN+F2coOmEAH65zdZEOne/SJP+jwHAm/Afoqu/xrim5Jlrti6rxPd9j8MHWAljxmeLJi+FAtsflAoBcVGdMf4fEBn7PNhv1N2H4zg9BnFld16XdDswSmOAyrJxgfrCHdcxo+ebH7BWH8s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dZP5Br6B; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dZP5Br6B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759158221; x=1790694221;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=l3XZEWn4DsJDBQlzCyWFy3mOc1T9k+7w9mzc5RAYl8s=;
  b=dZP5Br6ByOYNtGKbOoOIquJZ83v+Y+I7ZngLMkbReL1CLLGYO0yR8bVs
   ygIlmauqjeJ1kVOy4fH4/AAdc9jsSzMv2LHuAen1MHQ7BpqZieVnY/gXo
   ALLt6ZHKm5m45tnHnxzxYZp/qOy8W/lNxzMYAkCkS0LhMS08smAjDinas
   nP3+Eq25gsM8XaYSdT47qsXAKGROqyP3fmYHunf3NDhU/F2+xE2ho/0JH
   lRDK/x9VrDfqawzvx+8ZEO/1Nf4+vq5T0hZ4CmHARcs35ffBUfCRy+h70
   9CynhGWkuzrf5K5ZHbfUnJbr94re5iHniP+wO9dPaKMMWpZntfipN9xFH
   g==;
X-CSE-ConnectionGUID: JryfGZkvRf6a0micS2Rh1g==
X-CSE-MsgGUID: ypCoK0RKTRSHtmVNPiAh9w==
X-IronPort-AV: E=McAfee;i="6800,10657,11568"; a="72501476"
X-IronPort-AV: E=Sophos;i="6.18,301,1751266800"; 
   d="scan'208";a="72501476"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2025 08:03:41 -0700
X-CSE-ConnectionGUID: Ek+gkKwOShmVfKq5czENnA==
X-CSE-MsgGUID: +TIClV28R0SlFmnWxw+XXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,301,1751266800"; 
   d="scan'208";a="178067822"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2025 08:03:40 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 29 Sep 2025 08:03:39 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 29 Sep 2025 08:03:39 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.29) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 29 Sep 2025 08:03:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oHJWXjkFUnmJ3qkptapRp2O1BhpBucIT8p1EbDLPb0KpNDaD8z32iAJ1y510uDxNOF/12DzRvF1jxMVUI/azkr1ha4wFDZKwzHPwOgHl/TCeJQXxkwnWQZMZrORIivlBBBjP6ZUq4yP7etuVrvV0sZTcm1G3waCF6SWUoXQh7bOygo6JcKm4BWG2IPcyzMI6P/pZT828XwhFjnuCd/o8zwpAS7lRMWx3gnuXb+WDKRU6ahbOZsv0vY/ZnwEXu55xSJs0bivIVrLJs7Tc1zCvazmiGFJ0+Yf7TK9yEHpNdiBHveMi63d51U+lv1eVjZxn1uSdbhPo9iiu5LCqa6t6RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8WeowIR44Idp46rGB4xPKBLMq0OdPAx9JsQoBy0q9RE=;
 b=QlXa7Qu2huclVk+oaFGa3D4C6DEPS/NZXpHChr0uyzFI0Gwc+EQbfKmpueLg4cM/E1Cs8V2ycaTP2BDK6kAHys/+omD9aaWKKhsJQj7LeOAij6SkQFczN0Eb6YyX0isER+SGg5j4NI/VeRhDab96Kw9P9Ssy6xrTGLONDfGqwf+LhhPk3KI5AxlpdO3AWnbVNouILZbPjrvxlnDTN0l/1FTNlUiu+zFoZWVPsbkSPKLa4GCvjrEOO0Dfws4krG4g1wOwbzy2h3MkzJ9S5NWCwdz02DnjGVjQkDxOOUpP1l6DDHw0SYndpYQMI5ES98uDT+U5M2afFFEiTSEjt2gvXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA4PR11MB9131.namprd11.prod.outlook.com (2603:10b6:208:55c::11)
 by SJ0PR11MB6742.namprd11.prod.outlook.com (2603:10b6:a03:47b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.16; Mon, 29 Sep
 2025 15:03:28 +0000
Received: from IA4PR11MB9131.namprd11.prod.outlook.com
 ([fe80::7187:92a3:991:56e2]) by IA4PR11MB9131.namprd11.prod.outlook.com
 ([fe80::7187:92a3:991:56e2%5]) with mapi id 15.20.9115.020; Mon, 29 Sep 2025
 15:03:28 +0000
Date: Mon, 29 Sep 2025 10:05:31 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Alison Schofield <alison.schofield@intel.com>, Jiapeng Chong
	<jiapeng.chong@linux.alibaba.com>
CC: <dan.j.williams@intel.com>, <vishal.l.verma@intel.com>,
	<dave.jiang@intel.com>, <ira.weiny@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH -next] nvdimm: Remove duplicate linux/slab.h header
Message-ID: <68daa03bbd9a5_270161294bd@iweiny-mobl.notmuch>
References: <20250928013110.1452090-1-jiapeng.chong@linux.alibaba.com>
 <aNngNaDpVJAyYKYx@aschofie-mobl2.lan>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aNngNaDpVJAyYKYx@aschofie-mobl2.lan>
X-ClientProxiedBy: MW2PR16CA0008.namprd16.prod.outlook.com (2603:10b6:907::21)
 To IA4PR11MB9131.namprd11.prod.outlook.com (2603:10b6:208:55c::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA4PR11MB9131:EE_|SJ0PR11MB6742:EE_
X-MS-Office365-Filtering-Correlation-Id: d9235cc3-c42f-467b-504f-08ddff6958a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?z88VtO9Uts+9MhlYgDd4w4wvQEPe1cDl9gHG0iYJcdPsB5ziYWFkmhuzmX8+?=
 =?us-ascii?Q?va8CkFtC9eu0E+LXv97wijJjSBzhoOKWYJ+ZFVULlbfpBs+hlps9DU0L4TlY?=
 =?us-ascii?Q?2JUn+gOyMueZdva1M5BYF7FtKD4nhJXBqI2m0IvnWwQ6f+JdvhvQxyK/iIxR?=
 =?us-ascii?Q?QhgqAAR3aGuS+okrgA1S0dyHCyfRgcB8NAFZhAvuAYNN1MGfpHnAlC9M+NAj?=
 =?us-ascii?Q?TanYM8RmoWEw3UJaQhXRWa6HuKCzsbJTZdny0nosmr0jy5rfbis4PK4wnBQk?=
 =?us-ascii?Q?LDO0DNBtuMd5zfo7QaAR4KAEj9xAkW5beZoz7vcfYyY6d9tSSpv4uyed9GC1?=
 =?us-ascii?Q?0VjazXzyTtYvZjSrTDPzHLdM1oZzcMKl/dGS8yAkmH3JzRuCggtEtUGEk9Bn?=
 =?us-ascii?Q?48F25kPYqr8WXU+GX6H83qnU8SOXVrifEZVqYLJ8js9d2QvKoZnneo/HsLtZ?=
 =?us-ascii?Q?Q3dYI+9G1ziwgKfP3NhlR/YaP/4FXixe/cFfMaagQrwMQqcr23lqDzMmcHMM?=
 =?us-ascii?Q?834GWBvC8w3ZyU3CA/IGQavbASmcggVO715V87RuSBk32l3kOWR+CQ46BcAt?=
 =?us-ascii?Q?6lnjVJaGvrfclk7gcz75Z50iOADcoO3CqSNvPnE4V3ajQh7CtfBNJSyWZ/A6?=
 =?us-ascii?Q?9J/Q7lGIz5bLSFjQsn5gwDW9L0aV8SuHIAGPQxRJox0iSGteuNmdCTuNeAb/?=
 =?us-ascii?Q?kJho5gHsmFimf2lfbaIiztVK1/xeqj3rBImHHvsFDvFDT7SzBCeDvbHbvV7J?=
 =?us-ascii?Q?zPE+J9jRdtAeDZ6qihUQ2h0iC+JDn1/OlAu1WdgwOnmEUX1uGHTpUrCKot1N?=
 =?us-ascii?Q?IXl7Zs1L4TOJ6PkWEQksme08RHGc1umdoEgDaQKOcEbINRT2C8PlW3yHlDDU?=
 =?us-ascii?Q?SBKBZSEMBSMJ8c/sBQoidWPUMRh130RnGQLMYpx77o8/0ZtvhMdvgENj4Ycq?=
 =?us-ascii?Q?DNHqyGvHmV2pybEY06AN2gefAXG3CqZtdpuFHu3rrGsPt4W8dUCNvhCxOD9S?=
 =?us-ascii?Q?Lm9Bw2ka9+E3v2wBjxAR/owFSRQbEA5YxazWUOV5dIrTay0zW5gITnzT5q5R?=
 =?us-ascii?Q?r1cJX5sRqtvtHyfBjfKVFq59Snf/9Bz0IZDiDwZTBQDGcGmcoaZ8qCxT13Bv?=
 =?us-ascii?Q?FoEaNs4mePqHeQbvhQpYchv5cESAp1XsWDTeHZ5DGwvTrH1OQ6ry+5wDlctK?=
 =?us-ascii?Q?sz5p15C5Vx0eqr/AXpLOl+kQjvBcPKhD1EOIQHEEg7vcKEhNdZo88bTfw45y?=
 =?us-ascii?Q?x+Ax2CavrUNT7IbxNGOtkb6L2Zs72LVLasdpL/IDuwHMSNw9jraKj9NEisxP?=
 =?us-ascii?Q?lsDZsM+7tFcs5CJZSCHlTxPM5Fty0wKAwPIPKouIwPVsyNZrI/5g49hCVYBn?=
 =?us-ascii?Q?O8l7drqEjDdhaK1W7nYMa900iO2/iO/wKS0zPv1boqSOVdDvNg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR11MB9131.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1ag/e3kA+t+hsMnKmtIj2hSl5Gc2fIQDMUrVS8nzmQ4baYmq8ehk6HkmusEV?=
 =?us-ascii?Q?cy6WALqYBW8ACgEib+fZg7hcBIg19RZW77B6KlNyvXOx1stKaeKqFt1mHP3e?=
 =?us-ascii?Q?Wem712lLnty1qr49IU6Q+yGqDjxFLZHUfpgx673EPXizTLDAIek2NxE5+hRK?=
 =?us-ascii?Q?FvKnybjB4A9pUAegjLTvrbkRxx+1NiBjOTAmnFh5LWOoVU46NHTT+hTp72Be?=
 =?us-ascii?Q?Md5mDcKTMqrWzfGb8Ga2UCCPBZNlY0ZdlrlfT7ZOXI6MblmQW+Jv7VsXa4Al?=
 =?us-ascii?Q?jj4Dx8ZwvD3cgvNuWvfmR4Bw+OxkvazLDP6UZG5QFq1hoVxFdtuANo6maLQq?=
 =?us-ascii?Q?jfk7efrHf497HPiAN+AXZv1e5NvzQ4X/ym2JZc7hcMA8lqTqWNRHIlWmEfJW?=
 =?us-ascii?Q?vYwlqolUyBRSt2nc+ULDzLSzhzI12VVGxp5uvVU/+qq2ufQer2eUOw9gXK/b?=
 =?us-ascii?Q?JHWluFPhbYBGR52dbcJKADsMmvNmdo/OLXZYzMa0M1x8T4YpIjsoilQiof+k?=
 =?us-ascii?Q?Z2vKwFsudW+bPe0trGafXC/yqRBxGnTwmpYK6meFErU/sJcbrrMZZJmDkfbf?=
 =?us-ascii?Q?wM4PtRpPC2E3VvCwU4GC7bQ/4Fv0Lmm6efelsJ+6YiiDBPqvJdIwJy6/DJU/?=
 =?us-ascii?Q?ZKqKLUZCgmaYcpYWAxBhdWGwjnot5NwLeYmb5R5q6K8lgeu7qZTVEh/47W/R?=
 =?us-ascii?Q?eYD4bIG6rTvHf4mX0vs+j2HP/0hEAeI0hILIUmeO5v3rnVuAfvSrRKVT7Bo/?=
 =?us-ascii?Q?1/Io+LkkBjGFj6Yc7Rre7HDBNGn8k+i6liaAb+isI2MQdaACqW4cZ+dVtIUH?=
 =?us-ascii?Q?em2egqJejYQ+iQlx6yIVVxRWZe3+6T4MDtAtHLhFOwa9FVBOjPFegLpL4pIb?=
 =?us-ascii?Q?fYcRwzuOJ22J/c/lEICn1LiFeFOk5UcAfynkXeQ3Nux6AKjwycmbNyEPgjgS?=
 =?us-ascii?Q?N8MyPx2vE/M56qwGhnk18hgaDR6E/7Hbb4emImhKtm2SrOyXbGS//ywqL4Ir?=
 =?us-ascii?Q?tjEUESJ16kEYkDO9ac4Ezi0E1tGtJZy9axBuqISGuELTaWfJCxCX3IBDIu1e?=
 =?us-ascii?Q?JUrJDguLoecwGT4szKxYZEn92C6JYTk0fUXXJzgIEQqOrkICLI/+8rz4WWlR?=
 =?us-ascii?Q?FZik/8rIQSCRy7a3Hw92inRL+l504X8UvUhQNTATRGx2WNQHKyy04x2g60mB?=
 =?us-ascii?Q?gbNGVGfRrymxNW/I1LlfI+iLrk7np3JURBcQ3ARYVnhsMdI9fALiE/lAa9nv?=
 =?us-ascii?Q?gQzHdgrjEfHLV1dVRy4LNbe4OachtXByWJ1mjE4osu0cGBRrMxPpOTPzyVyg?=
 =?us-ascii?Q?+brx+xbHnl5+ztdKvG3/fhLQFv5NOtkk9D3mzVNqdizftmOT5B9q1iBc+cFN?=
 =?us-ascii?Q?sWUYRv2FMU6nEAW4tIlprgHX9UTQNFubS5r7DwGWazagSVpyJZY6UAsjwXrM?=
 =?us-ascii?Q?hfXJxfOcAj7avL9bQ2FUEuNkiXH+qT7keCUT+ATMsP2OCOEBHem7MbSqh40f?=
 =?us-ascii?Q?ZXcGi1tbQyW7zFMIG5b9UzlQ2v1yuTZoRT/QfU2SOYO7rkBXXbXMb3A6M8M5?=
 =?us-ascii?Q?lnWc1w/iOD1odATGrMED4daftRQGUt2hbx7EJy2s?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d9235cc3-c42f-467b-504f-08ddff6958a3
X-MS-Exchange-CrossTenant-AuthSource: IA4PR11MB9131.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2025 15:03:28.2214
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ldGngT2ygT1GBSm9z97U/Y864vkV6FNOopd8HoFTdRvrdhWEmqY4wXCRtxPmZ/fFtOjbhDOabhjdnQqt09vq6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6742
X-OriginatorOrg: intel.com

Alison Schofield wrote:
> On Sun, Sep 28, 2025 at 09:31:10AM +0800, Jiapeng Chong wrote:
> > ./drivers/nvdimm/bus.c: linux/slab.h is included more than once.
> 
> Hi Jiapeng,
> 
> It would have been useful here to note where else slab.h was included,
> since it wasn't simply a duplicate #include in bus.c.

Actually Alison this is a bug against linux-next where it was an issue
with Dave's patch here:

https://lore.kernel.org/all/20250923174013.3319780-3-dave.jiang@intel.com/

I'll queue this up.

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

Thanks,
Ira

> 
> I found slab.h is also in #include <linux/fs.h>. Then I found that this
> compiles if I remove both of those includes. It would be worthwhile to
> check all the includes and send a new tested version of this patch that
> does this "Remove needless #include's in bus.c"
> 
> BTW - I didn't check all #includes.There may be more beyond slab.h & fs.h.
> 
> --Alison
> 
> > 
> > Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> > Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=25516
> > Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> > ---
> >  drivers/nvdimm/bus.c | 1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
> > index ad3a0493f474..87178a53ff9c 100644
> > --- a/drivers/nvdimm/bus.c
> > +++ b/drivers/nvdimm/bus.c
> > @@ -13,7 +13,6 @@
> >  #include <linux/async.h>
> >  #include <linux/ndctl.h>
> >  #include <linux/sched.h>
> > -#include <linux/slab.h>
> >  #include <linux/cpu.h>
> >  #include <linux/fs.h>
> >  #include <linux/io.h>
> > -- 
> > 2.43.5
> > 
> > 


