Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAABF3783D5
	for <nvdimm@lists.linux.dev>; Thu,  8 Oct 2026 02:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791424803; cv=fail; b=EtJo4Xe/ZWg++pwY/hr/kgdBPAhT0079Q3ug32UcRmyKLJxzg7mDvf1B5KRxTUiQ7YEV7tZOLgzvgIWU1BcDfMxnobh+LrTLdbOs8UnFU4gDLjAoYQUqN4AbwyaFvRjk3nXHu8ZVLr8Cxxa4EPiqeXL+TchI7gZO6WE3wz5X0fE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791424803; c=relaxed/simple;
	bh=xg96nImKgQTbbksQFQLRKiABu58eLPZoZdjb7P9w9+Q=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=smioZOl2u4Y3XsMb2PgyUEBKdqZVORaLkIkcm3p01YoY7g9fYxf4agN4voyYgM30gOrGPidZ4OkubkZv5HVS86SGAoRcgToEyyONUPhWg3jCbbIRFTWydSO1jCpk24UwhvelEy5gEuimk9nnn6l5lgmMIBDVK3Q1ZJ+4E+QUGLY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gQGQtvBw; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gQGQtvBw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791424802; x=1822960802;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=xg96nImKgQTbbksQFQLRKiABu58eLPZoZdjb7P9w9+Q=;
  b=gQGQtvBwlhA4NYQHyIuYJS4e6VmKs5YMK9yFCF01jMJiLIl5yf/K6WBi
   gvJ6k86sAEtxDbmRzEzr803fJj4EEnEdr06aSSuu8CzN0tINkE0T5X9Ap
   rDInFGCNVUyeN1cLm0LDCHc7N+n3SiFhDcxPzTV6466Tj6oz1mf32t6rt
   37c9zGGrXhSNibWiQfOwu9nYy793Wr7vDO9anWNgRJAUpx3zT7RBjtXUW
   b0DzZv8Pb49sWSAe9dBjBcRDVdPO5G336+aW04snGux7vMJjeRyO2dw5p
   cIBv9AsMSaDb/DvffV7VFWJXQhkzB/X4AWCGolbw8q4gJKYwkmpwKkIb3
   Q==;
X-CSE-ConnectionGUID: tyjwK06MRCOm8I4iN05OOA==
X-CSE-MsgGUID: Ae3BQns6R7uuJjVNfP9msw==
X-IronPort-AV: E=McAfee;i="6800,10657,11928"; a="79838"
X-IronPort-AV: E=Sophos;i="6.27,145,1787036400"; 
   d="scan'208";a="79838"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2026 18:59:56 -0700
X-CSE-ConnectionGUID: 6Rhkw8UxS1mCVaJGTfbjAw==
X-CSE-MsgGUID: mQ6hHTAZRfy2jnDd9/0kZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,145,1787036400"; 
   d="scan'208";a="280891340"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2026 18:59:56 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 7 Oct 2026 18:59:55 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Wed, 7 Oct 2026 18:59:55 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.6) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 7 Oct 2026 18:59:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MMFg0dPln8EX7t3SHF5Cs7FCyvqqLmw9BwLlGEY0PqnC42cITqrMIlj/fX37l4rq1yMA/ku7wkFbFczWhdukvx+gR9KNij7WuP4JeM4MGng6NCrPIamETlGc7a7B2o6OAxhyCKO6LogiM7tFRYUgq5fDnf56tU1R9pQjhebsMxqgdGgAKkV18lL5MaqwvZiYrfqyiHq4M7z0CzF0FILUA0aRh6ae3ChRBUrSXeStvbA8LggEToLZXmqbkhAQKoiQQxSf3GGS2DODn9vj1LEd2YGmdu60RV/8i81UlrUuyIDGofNN+aw764sN/PLIwcVAlqXaug8g8JLDmxTr9Rbkrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c5F6nCiSNdTg7DpByNx/8xGY7oqAZvzKrI82c618jCI=;
 b=QszJ+1Qt3TEwn7rUwTjKWVJ572r7n8UwyG6Hgm2mEbiAphNmf3BSryptUuv+sP35iTX8PXYusMBMXbbkVR2zyfrYEmeNgWxQIoQ+CYIIwtWUhOpTMiQ/k7/A/uaQmHkXvD/7jGzfl/FGXIRMsLGXd8wNUdAWRUUhdUPmJintU7EEn01aUAnNTBawE/ExDK8eaUH4G2G//QRIWiDwk+5tufL2dcIV7OvrGO1V7QMZ4nvBKG9nCc/E8+VmpX4SzrCZuy2XxGm1+joIvq5kSt2W5vN60hGJBlBCbQHbCd2BfW7//D5iVuWYxoSc9PQqwp5DU0uBbazgHlnoBvegiJO5LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by PH3PPF5ACB2DC0D.namprd11.prod.outlook.com (2603:10b6:518:1::d23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.15; Thu, 8 Oct
 2026 01:59:53 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0496.015; Thu, 8 Oct 2026
 01:59:52 +0000
Date: Wed, 7 Oct 2026 18:59:48 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Jonathan Cameron <jic23@kernel.org>
CC: "Gupta, Pankaj" <pankaj.gupta@amd.com>, "Peng Fan (OSS)"
	<peng.fan@oss.nxp.com>, Dan Williams <djbw@kernel.org>, Vishal Verma
	<vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
	<linux-kernel@vger.kernel.org>, Peng Fan <peng.fan@nxp.com>,
	<nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
Subject: Re: [PATCH] dax: use assign_bit() where applicable
Message-ID: <asb5FDTzTHyayd6U@aschofie-mobl2.lan>
References: <20260919130750.3041470-1-peng.fan@oss.nxp.com>
 <34be3233-87a7-4dbd-bf4a-56116f4e8cdb@amd.com>
 <20260922000813.3299a72d@jic23-hlaptop>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260922000813.3299a72d@jic23-hlaptop>
X-ClientProxiedBy: BY5PR03CA0028.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::38) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|PH3PPF5ACB2DC0D:EE_
X-MS-Office365-Filtering-Correlation-Id: 3bd1ac3d-9651-4442-c054-08df24dfd7af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|18002099003|10067099003|22082099003|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info: Vpa+DPhPyboJFG1V9DlF+xaG+ctmZMaFQvYwG30GQ8hskgo1O9omx0wSucrcLAUTlPNkD9y6izUHFKxDGfvMd53/wDwi/FrtJIufXHu99C1m8qQCsZkmLP7Glo6OTGsDaQaXkFfFKSGSRz2qWkniANQ3mVpX+cDAjn6AOyKvTcbPoAFP9LiqXZwG1FjiJ0hYjD91+kurUgJsdD/wNWcTagz1AOhJtR1nDUSxPb5DXpY9TKsT0iwkK+qEg5eZA5mOKobjTKAHa14tszxd6//7WrT7+jbB9U1T3K+894v6qAlvQFS1ySrsbZEADltet2xYsyB9xeyIoyhk99epUdDsnoKcFM4e5JJsPKztsshBsPODefDIWfkrenQZpIcmnOotvxM+A9PWvTBn68/fw6mQfvYdm8zrkN0Qq/Mu4PTSrOFr8OE7yEHf8P43Bu3g5K50N71+iAss+U+leRhF/AKMcoYUmyxeN0Wzb3brD6gi//0VZeraNYCpP44Nys5Ecd9K9jE/YG4pi8T/3TW0/Ig40bz93FkONqzxR1jz8cJ/43xxu02bzh5n4AacpEb8RVYAtKehaoaBQi6YhFS5fJIOt6BTIFcBan9Ufk0Afy+pvz2uCxUGTunbWtg4SNEk48kZkhiG1tZCPEGbbot4W0YVXTeNBNM0cRX0LtIf0grZYaY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(18002099003)(10067099003)(22082099003)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yj0tJ5B/WbovrL/Cb4O2Mbjp1NNd3OEBuoLUQWdVpitIgLuFKqjiiK+I0xbG?=
 =?us-ascii?Q?Jpladiz2jphwgNtawvL9TMoSP8YSaEpl2TzKqCIYHr/0k888Yl8dIfF17dMt?=
 =?us-ascii?Q?9pCN8kaiwcOAkxCC+UfUJs1/pBPSMOpjx/f3G6gtj2Dtlhtr/9jNW0vRK7PE?=
 =?us-ascii?Q?S3grKrtfuQaBoemqRo0kgY+mo13eCCHBabsR/ZyLyPbIKMIO1XjboTpXfJFB?=
 =?us-ascii?Q?kfofXkhM/hCDK7yp+iU6BRMx/SWUo1SSazSh9jQXq3lKvyXWfn/87IV0XB0T?=
 =?us-ascii?Q?Dfwsdl4r4j8q7ro+jHAiHXAogFQCTErYhZ0fk/3LMLGBF/JKBp0Gh8V5y5Ca?=
 =?us-ascii?Q?0rt9unuyiJ1Z/+x+or3BP/VpGFh3uw0Urk4daPlDOORkU6XHbKv++hsXyOgs?=
 =?us-ascii?Q?9kGPqnr0P1qtJKbpiIe6X+EyF+hTDTGR9T8+DmZQTwff4nvpmfCG2F6miqDw?=
 =?us-ascii?Q?Zgd5WKCUqFX9Pe3LUPMPM7GP0rQ9t8rw12LZIglgXUi5jjfemfU940TZWhC0?=
 =?us-ascii?Q?2mXMMpvoONMa0NWSUfmqKESXNl1HkmuTqGEG7HEBMkB+gj/FJwLtok3s3ZYT?=
 =?us-ascii?Q?hL1YjMVyCI8IgjqLWF2JILToB19RfcE0VjAwN1vRLP7+FAjpA+XmpUM0fcYl?=
 =?us-ascii?Q?7yq48csiZCVEqbsGydXYjMGlxavf7CsxgXgE/XFTwwHLQO35VXak6QIADcU4?=
 =?us-ascii?Q?kJmSU4jBoGJPCZvtsftHuj5LGReTzBSn2IA2VSIHUS2tvTP3LjT1A4nxlPZN?=
 =?us-ascii?Q?cuSCZ5gOul5vx31Xt0KihGXIdAe3O7Vq4u9fofQ/24GXkthXYGE4gfukvuTv?=
 =?us-ascii?Q?sYAPNjkJiI6LcnQpqoIsHYg5m1fO9Yk3++pBSgqMWG7oYvywYDVBVbSOdOiI?=
 =?us-ascii?Q?sf0Y7pGBj0D6eE3inqcZBTxB8uW8QVKNJx5qGSnbvJpiZKpMVORrffWCbGbK?=
 =?us-ascii?Q?k37e9Mxy4Rmj3nb67B3Zvchrmri7C3gzCe5wjIGPwiUYfOuEGFTAqGhgbM8S?=
 =?us-ascii?Q?PlEWvDZlay5VYevjQNx/a6fo/fTjduamcCdlOhWJvl7bAnHKIIX7peTg4aOx?=
 =?us-ascii?Q?ZKw4La3UJJPjIaaoXgr4Nopx3atJNlpcAWWSyIIPIAOo1UZ9xU9fxV4ADtir?=
 =?us-ascii?Q?keUFwD0IGr5WJCwAVaJgstm9wUfuKYzv1yh5wXnrKskPzDagy1C7s89K0MbO?=
 =?us-ascii?Q?aM7aYEtMaFKmMgFzYSXxcSzDcNaT2RkqF0H6sqkjdFgWUxNj287RtWEbKv/r?=
 =?us-ascii?Q?mKjgXmUIJURhlYCc8LymLi4g9sOmZjiLCZxIA92ZXAj1z6p6/oIOkILkNOSu?=
 =?us-ascii?Q?TFU/Qgb8DHQEZHolSC8iRgPvHQmhayb6c6qT5ad0fQoQwixSWqSdzBN7yu1e?=
 =?us-ascii?Q?JtQTRizSzgWRqrMVJCB9zV35v3bHJVIpE8UH4NKVNRfeS2LHnpU/GSFBmbQw?=
 =?us-ascii?Q?hQBSK8EP8HV+wONOSMBNrPGNyPO/TyArbtugzMGmi7ahqTQ5S3D1zNljZpG0?=
 =?us-ascii?Q?X3wD3Kb1G3qXivT7fRMpYzccQBGbz89+hQO9rFz7hObZmUOSOAOfrPRxagGJ?=
 =?us-ascii?Q?XxbS7rFjie9w8a3M6vhDY3yPKDKru38gjANXncyMKOvCTa7URPT8Dt4Ku1/e?=
 =?us-ascii?Q?PQhBupvMpAYKfneoCQEJ+DcIQW0//y9sEUcXuQjxmrWdlqTrgt13QtiVjP3i?=
 =?us-ascii?Q?gbu/JNLsbe8qqOAgkei+vGaQQJqImj/JAoP7EMC5PJ9mi2jkDg4/0q8+uivr?=
 =?us-ascii?Q?iGJVhGfMiy9C+UV/dIMgfJZsmZIfD5Y=3D?=
X-Exchange-RoutingPolicyChecked: w/SWcxuW1A15BY9bviPhijioo0OqZguYgxvClcJeF09SJkFgYJH+Gx0RhUIlCsiyhjGJG/ioypn9fmTdPO+3ImcvAI0Dx4WR6lmx2T4u5ZFeACS72q4EasbmZyoHG1jHwwVJpe8EUycYjz/1I/BcvjhvniqeEw+luwHuIu8cM5QuGC1SjYRJW9+wH3T6sGC2NozgJ5soKyz+4+mLCZSeleAxsEWVotG4JyYalHmnjOftLPvnNWyM7PSO5gR/zDPni0XN0xz+ApkjJHkIbZGZT5yt0ec5gyOincmzvXQlD2V1Sc6aaGHkxvZvO3msVmBLV//78Ca9DnCgq5rNdM8Z2w==
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bd1ac3d-9651-4442-c054-08df24dfd7af
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2026 01:59:52.7653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X6WdeCmBHBVAk7rhcLR9SqK4jg/kuzGE6l2ej2w9fekLCPQ9QPLlBEhZd3OGRbEw87FsERGv3mvflosDuzNHYb2ee3vfim9QjpJMOsX7L7s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF5ACB2DC0D
X-OriginatorOrg: intel.com

On Tue, Sep 22, 2026 at 12:08:13AM +0100, Jonathan Cameron wrote:
> On Mon, 21 Sep 2026 10:24:51 +0200
> "Gupta, Pankaj" <pankaj.gupta@amd.com> wrote:
> 
> > > [You don't often get email from peng.fan@oss.nxp.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> > >
> > > From: Peng Fan <peng.fan@nxp.com>
> > >
> > > Convert open-coded if/else with set_bit/clear_bit to the assign_bit API.
> > >
> > > Signed-off-by: Peng Fan <peng.fan@nxp.com>  
> > 
> > Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
> 
> A bit marginal wrt to churn but a good change in general.
> Up to DAX maintainers on whether they want this type of small
> focused improvement.

I didn't see the improvement. When I peruse the file I see set_bit and
clear_bit, and now I see a couple of those obfuscated by a new
assign_bit, needlessly.

If Peng wants to come back around with a 'why' then I'd take another
look. I shared my NAK story here:

https://lore.kernel.org/lkml/asb3hGpSWVQk93cX@aschofie-mobl2.lan/


> 
> Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
> 
> > 
> > > ---
> > >   drivers/dax/super.c | 5 +----
> > >   1 file changed, 1 insertion(+), 4 deletions(-)
> > >
> > > diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> > > index 45f84b0eb909..60c4aec52ae1 100644
> > > --- a/drivers/dax/super.c
> > > +++ b/drivers/dax/super.c
> > > @@ -385,10 +385,7 @@ EXPORT_SYMBOL_GPL(dax_flush);
> > >
> > >   void dax_write_cache(struct dax_device *dax_dev, bool wc)
> > >   {
> > > -       if (wc)
> > > -               set_bit(DAXDEV_WRITE_CACHE, &dax_dev->flags);
> > > -       else
> > > -               clear_bit(DAXDEV_WRITE_CACHE, &dax_dev->flags);
> > > +       assign_bit(DAXDEV_WRITE_CACHE, &dax_dev->flags, wc);
> > >   }
> > >   EXPORT_SYMBOL_GPL(dax_write_cache);
> > >
> > > --
> > > 2.51.0
> > >
> > >  
> > 
> 
