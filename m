Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AAC01DFFD
	for <nvdimm@lists.linux.dev>; Wed,  3 Jun 2026 00:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780445651; cv=fail; b=CisHLen5PB1V7vcje0jujtpadlQQyv0rY1PjYHzD6oUjzTE8/XgJunhI8JL9aiBeexCNz8bIEItRev9boczbxQTPSkgvCY0LJBQWXD4yws+QNOTxlWyld0pTuMjYrbKgcYgAt9PXl51pN29JWBJZLmkd6LYyPNYSqiEo5ly0tgg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780445651; c=relaxed/simple;
	bh=mBV6P8veeJDe6v38h5hW9mw0QIVtiKoRQb8nc0Iuxis=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jjewXl1ci0h9wXi24yaAoOv8lqSdi2u1Oqe61XZGvVB42Lx/T8rDopMKa9R04rp3HQ/GSgusEHShHYUwA30d1YmF3T7AQHPgtD8tmArOTvxtHwT026ewTnZBGrlhspGFQruXB3Psbd670Mt1fw9XEitYxtc5WHJSZIAs6D0k6QE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JGnc0Dpv; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JGnc0Dpv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780445650; x=1811981650;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=mBV6P8veeJDe6v38h5hW9mw0QIVtiKoRQb8nc0Iuxis=;
  b=JGnc0Dpv641g6IoZXbxlIMtjAS6ecufpLkxzPKs/PuqUjEm6O8s67lhE
   ValQADEf12inY5ywknz7QVyoRJPVwU6w3RHdtNhjFfqSsOMBotFLBTgG0
   nR7QBOb9raJVLPRHsDkvZWL7v9GmytfK4siPet7j4a6gTtxF/seWIiKrM
   1iqp7Tj5AdP0hGZ2ALfSxUdsScUYl5nbais4HBfs8DGSGpNfyv5JRWNu8
   OYIC6r5MBuaP+ii/eGtQvUOhiiBvULvsOuY7EVXa/kmtGtfKM3p2U2V/k
   MkCancourkwVtdEBz2RfPA+/P+c0fNTKxCK9scdoe5uJS5J3iiSgOw1z/
   Q==;
X-CSE-ConnectionGUID: hcGfrI0KS52lUuIdDQFBag==
X-CSE-MsgGUID: Nz3LB7bASg+Psn/HO6MATg==
X-IronPort-AV: E=McAfee;i="6800,10657,11805"; a="81304792"
X-IronPort-AV: E=Sophos;i="6.24,184,1774335600"; 
   d="scan'208";a="81304792"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 17:14:09 -0700
X-CSE-ConnectionGUID: yTEFgFHfRHyEy9G08FWCig==
X-CSE-MsgGUID: vV79eyPSQRaKld94YznaXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,184,1774335600"; 
   d="scan'208";a="267689424"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 17:14:10 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 2 Jun 2026 17:14:09 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 2 Jun 2026 17:14:09 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.1) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 2 Jun 2026 17:14:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dsG6A+JvfKPkmvVUdQSXLN27Ihoeqlg6Rw1cS/JENyISp3eF5Dys6uTPYABILDblHn1dNTRf0xi3MWi7g7wS4EwNsBZc0XJtxSyDqh8Gc3GwK/3oEVGeGea+8U8/n2pDFZbsCgZj7LvvUUQFc4RYPcv8WW0BIDGq9ZzNaXFhnG+JHKCJg6/9mdx1nTkGkkDlBATv77eYYr+6SSDNtQF0SKjriRJVRDFro2K57OCTU4/6RQ3fhPoUNjc3/OtDYkU95maVuN1qoJSqIqE41i+EuXLxvcLmApV8/Hgig6+DSnJ8VVlljZ/ahZvBQy98ZpBNM+0UlK65alsZpZUVhB6OEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LB2k9yRD3FE2Z+pZec8NxavbHg9S68LLWbX6mhCZ3RA=;
 b=UKoCrsZu6O8zxrXDZZxumnSDZkNEFztRLxOrzeOSDYemkkyjfcS9QdHIiP4SDvkw2uqXoXwwGqBGtTa02vgVhz46Y/cmWB4tFAbpZMNM1eo27pn5w9Qu02LK+eK1tgErYrcJBSS1mT4/KBVrfRKTQKy5ioFPMAyFnON5ISTeXYP/aJUndfMtDPtModKDjOip2Wy/3bhs92zlKM0RxllydFHr3+r+crWYFqLaKSiAPNKpWdkjdpiPJcz9+TRQamYQWQxv0RhyDwYV046wb+fl3nbZ/3dLJfdBqm6GEdyos0U2x4ruHeIYyUI19VKcHIvP8cZ7mFlCE1j7SY6qHdOJcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SA3PR11MB9511.namprd11.prod.outlook.com (2603:10b6:806:47e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.13; Wed, 3 Jun 2026
 00:14:06 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%4]) with mapi id 15.21.0092.006; Wed, 3 Jun 2026
 00:14:06 +0000
Date: Tue, 2 Jun 2026 17:14:02 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: John Groves <john@jagalactic.com>
CC: John Groves <John@groves.net>, Dan Williams <djbw@kernel.org>, John Groves
	<jgroves@micron.com>, Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang
	<dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara
	<jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner
	<brauner@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Ira Weiny
	<iweiny@kernel.org>, Jonathan Cameron <jic23@kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V3 4/9] dax/fsdev: clear dev_dax->pgmap on probe failure
Message-ID: <ah9xygZDPJmvCAvb@aschofie-mobl2.lan>
References: <0100019e79caead2-5795328c-af48-4a93-b147-c11df7446e1a-000000@email.amazonses.com>
 <20260530165053.6653-1-john@jagalactic.com>
 <0100019e79cbc3fa-cdb45b69-de84-4cc0-8aeb-71d0673c1a9c-000000@email.amazonses.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0100019e79cbc3fa-cdb45b69-de84-4cc0-8aeb-71d0673c1a9c-000000@email.amazonses.com>
X-ClientProxiedBy: SJ0PR05CA0170.namprd05.prod.outlook.com
 (2603:10b6:a03:339::25) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SA3PR11MB9511:EE_
X-MS-Office365-Filtering-Correlation-Id: eb3aff8e-d3dc-4f43-b749-08dec10506b0
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|11063799006|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: o1mL2RLryF4QB4JUciNyLtWmZ2Wu++Q+O813S4r4DuhGHFOW+A+Vn93lprrrmFKfDQeE0caopINzRfu2wbkf3yB4MIpGFnlQ4NRWn/r2djFtqryemUqJlDPpGC6tzzxmdddVPfCO5IqhzfKBFmz10nenRYq2siz/cWtq+1ZxJDys/gVlRuYBdgjMRqTGIu8cCbgghPgWgKSjhh9M6Xu8lfCzYn+7+RHGy/jCVKcJt0nFJUlTNeAZj4wgN6EMtESn6W6KNWx/vqykpUpA5v5Opcg1yzYD8Kz3LXOrF8arbVPVafsRmwrZnmNcoGl/7YlQ6xnpQmdptxeafvrHVo0uJW9rv4xKpAnvOTxJCw0xJcO0aymOBDFshFRhNbjSJFzFbLq1hHbBJOdGNCN6QQV/E20UazOxmKyXoYa9s4U7Q+h+DfxTVBwX8FzADEk8HtGMsUOflXEpn/6iUzcAPC3jA2ZxNfLUM8LHpbnJJEP4XAszUjpjopGLiBUs7G/lO4maN9wMiUCCGSwcyiqaJRh9l+pniEhGta765RcUbHaSu53xXyHBOaxPjZYwLbjVu+Ci5kTsNMUhNO/Xc6iMWmg1FPjEIAYz1orf0RAlM4r3Z5aXge54bcu94NglYGZwrHXsoDSEcYKAXFnTBetaw+hPJKcwraQ1ZK51EcnDk4Crh3SbpN3pao9YWKb+8scJcKfn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xVMmupT5iITAwz97RLt5x9ag2ubExBa+Wzm6YoYRltPUzmJbqF9QTOLVaU4D?=
 =?us-ascii?Q?ATkZkS5t621dD+IKd1+x7sclea/sz+uxirPYPxEOy8Igmq8Py3IFN8U9hjpK?=
 =?us-ascii?Q?/hgy0nk98aCjGZVeoznJ4cjCqspkMVufb6YHJXlZGvBBu2B6omk8eLNG5MRv?=
 =?us-ascii?Q?7MBNubxYTLi8B2CFxeoPWHifAzwonSrLCw/9u8L1W/0Z5xLf6DHkFDfidpN9?=
 =?us-ascii?Q?mpZnPJyU/T8glxvS97LIauIhdjgkGBbNWBStlnOnFKTBq7LbLcIpBX+oPBZO?=
 =?us-ascii?Q?quyygUOMIj+ucALEpj/IcvOh4HjUCSlP6Kz5GVdUCoWDYsXsM23PLv2hkViq?=
 =?us-ascii?Q?GO+8YvW6FWovo/2cXvCdT8f+O3jN63htuElpMP0NKwPSPP7yb/Ykg51qvq1w?=
 =?us-ascii?Q?8D4OTjFwLZMdpE2I9lVKz3mFdzYM+vocA5lcNje4Ogp3HPDoPb6JIGEGWxR3?=
 =?us-ascii?Q?gVrKtkTDuFO+l0/lQ6v8JTPjJui+sdtcYpNv9sH6QBMmn68Q0Uoxkb9Ejta/?=
 =?us-ascii?Q?l0ixbJopCr2kn0EtbosUoG7IQmqpNALo3cJ+G6hmLM24fQgduL0/+tdv+Yp4?=
 =?us-ascii?Q?hkZLfL3+0sFO9/hzbDsfPGq+ms14NOzKDXx9lBQ1kX4suxp1ikdI0jHdQMy/?=
 =?us-ascii?Q?lmxiyZ1kDsYIfjBTTsS083enWZN5GHHPNZVijnIDiHqRR6dTxWUgOcWqNJIY?=
 =?us-ascii?Q?2tpZW0Lsr+7afJzfVlLIPX+6grPciNUga6xPOsfWQ/KZFlmFbobUi5hnA8lK?=
 =?us-ascii?Q?tx+fXh/s9pyGurX2VNLHa9mHslllSnrSggb9eIGnXtYo/9hvsZiFJfx42QvM?=
 =?us-ascii?Q?2Z7OlAXVx1FkoDZM+R2lTAkNm+li7hwUJU5XfwRP0rVcSIaO/jnsMcX2haOx?=
 =?us-ascii?Q?YZB3yhPXC250trj6BCkK9QO525/FW62NvZBo88eRA6bW8Zcbqs/1feObfvjc?=
 =?us-ascii?Q?TDmx2KFd9vm7FX+W2Sqnaj9gdtWjtumstVesuiy9HLQZEHvNgSQwHrLU/FsR?=
 =?us-ascii?Q?BMeGfpm3q3701BfeUuRbJyPJsY26ATuvGejsY0Yc/K0ZjOnN+7pshvtwGlTY?=
 =?us-ascii?Q?Chbli+Boz621slPdL6SsPi2YenSBl67P5/3VH1gDwwaquyucfegy/JOOW6mD?=
 =?us-ascii?Q?LuAiI9td/z9bu0x1dbfI50XJA9sUqrB+UHf8k/nHvg9EFBjKzhQ8t0iKp+CB?=
 =?us-ascii?Q?Jis/v7Ng+x1k+cL0Rz7dNbsIt179ypHBJgX5uQZNC5hcRb4nS9737FBbv5r+?=
 =?us-ascii?Q?dcznWNwQHT9dc47tifvagfIC/217Tg0MX94Uf1wHT8vHPO4suRzhNsxix2Xi?=
 =?us-ascii?Q?tauNRFihI50xmxan2JkR2xN7kD7lavJhfW8/BCtHVX/jPas9xAyqLDR+sFil?=
 =?us-ascii?Q?M/Q9Y6RUq9mlEP5BS/P0bUgCuJS73cv/eVMtcQRw8Qm8NczL8xJ7hzhCOcMP?=
 =?us-ascii?Q?GKrkpb8ryTDsZ5YjOpYmulqiLa7Eu2PjC0cZKKf7aZ3oGW8IGIELofd9Wy1Z?=
 =?us-ascii?Q?SUuh39+vjXjwEKJIz5GdB9cWYSyMAo4lQmzjI9uJU+7YuO+vm20KgSZaGBSl?=
 =?us-ascii?Q?vJTvLdhYm7xmULCsaWM3ws6GwJpLnsPmidpfzdsZLOJbKaKkmAwzUFVA948K?=
 =?us-ascii?Q?5P7QfwZFZc/YGvR/W0vSM4Hal8X4YX2xIH9Qn+5XbNtmqG44ZudCruU6gxaM?=
 =?us-ascii?Q?BW+b2mW0Witjm1ZqWhs/WpHOY4T9Mr2ZxCzm3/9t8TmpaPhVHfyEkkGPDcjf?=
 =?us-ascii?Q?W/RU2VHJe9clzb6FnkwoY3XFTyEf8MU=3D?=
X-Exchange-RoutingPolicyChecked: CwI9bUR7e4vrUUpAaEmHiBVuGfxw8h5mgn3kP/FE3Bv5v0QHXKB5kQhniBSy1Vob/DSRZDLSoo1UFJBQwzGzwlkjYynuevxjGIbI9dI84ssNvk3n8mE38FgmzpqSGPSoXg2SBpG1ZZauO1aDuHvBtYAVfX0bUpxyHCKurVRrJtY2viVdyUtShPOOSh/20zAyIAT1vXlQN/7jn+R05+nv0bgX2/foPEHj0h2OtXzzrBbgzr2yuyHJlecgcxLGo6q5sgbF1436XdPo5MFPZ2HwTuo4A6Kb+P55JIVrjh18cSNAOp6G3M+D7t2vwMhSWfjAl22TeQc/SMb2xs+oh4y6lw==
X-MS-Exchange-CrossTenant-Network-Message-Id: eb3aff8e-d3dc-4f43-b749-08dec10506b0
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2026 00:14:06.5607
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W67mmaEPJJAMXErh3TyFW8w540ZDfaAsK8tdTqXWTWa3DJe8M9r/GNdqiSLV2zglKmsTz9pdIPI9cf5Kc3X3fKexBq3nep57FKWqChQCryI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB9511
X-OriginatorOrg: intel.com

On Sat, May 30, 2026 at 04:50:57PM +0000, John Groves wrote:
> From: John Groves <John@Groves.net>
> 
> Clear dev_dax->pgmap on probe failure for dynamic devices. After the dynamic
> path sets dev_dax->pgmap, if a later probe step fails, devres frees the
> devm_kzalloc'd pgmap but leaves dev_dax->pgmap dangling.  Subsequent probe
> attempts would hit the "dynamic-dax with pre-populated page map" check and fail
> permanently. Use a goto cleanup to NULL dev_dax->pgmap on error.
> 
> Fixes: d5406bd458b0a ("dax: add fsdev.c driver for fs-dax on character dax")
> Signed-off-by: John Groves <john@groves.net>
> ---

Reviewed-by: Alison Schofield <alison.schofield@intel.com>

