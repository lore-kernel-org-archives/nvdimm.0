Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB73357A56
	for <nvdimm@lists.linux.dev>; Tue,  6 Jan 2026 18:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767723614; cv=fail; b=JCHADm74T0w5781Nv04+jBZZwT3s5xUmXSEDSyUeI5Ywo1/9GbNxw5wxyznigr48zTMeXE8p2KwzDnUCG148yTjJQxvtJKkXO6oe7jPPZ8d2s7GaiW4ZJVu896z7cuTdy7fnrNiYy7rMRhPQ2qvwDBpAYwdcLOQwk5Kv7YLYrbc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767723614; c=relaxed/simple;
	bh=QeKh5WDrXeIHC89+HeEIDATbgGgK3+6PhUbeEiePdYI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=X9LrWHuKzLtxJNAqhHy7+ddR7Zrhqfulz6xlIJoOzh7Q0/MfM53ifnGSPJ8EHi42qev126df8p78jwVY/jd5MvYXBIME8V/PvFYRyNkyu/OZwHu89+NyIy/LaNbjtDW3elnhifaldp+GRNep2NAUggfyMOtiZNfzLiSJqPK8QoM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mj7mJrwv; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mj7mJrwv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767723612; x=1799259612;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=QeKh5WDrXeIHC89+HeEIDATbgGgK3+6PhUbeEiePdYI=;
  b=mj7mJrwvlB39HN1dKTslDd3txjIlpn37b4ePF9CArWk5mUzSky3SBn4o
   OlGRENfW1xKL4AbBpUaM6Hr2l68bPfZPj5AHnHWzhD6Hue0ejVGiOd/uk
   yL7uoEvkphsuLAkypI/1+atpCBcSjZixs5d3xwFRiu/cIdUJz1gkVbM0/
   st128t5IJvKAYx/bDUYTgV33cvs7kTji87+CjSSsYC0XRb1jsZAosSTvj
   y4tdRMZtBMUkg17l0+RdoCv4u4ORX65Aj5gBofMUjFQr4I0yW0Zy3WPGQ
   EvQ+BuAKY4+Nc7zfczKagfNLuQZwaqL3FcPHRcsjuzTRhKchuAtN1kZNa
   A==;
X-CSE-ConnectionGUID: 7nbq5Po3ScK5C9SD2nzraQ==
X-CSE-MsgGUID: GTfE3KJYSiazRR8LnJhR5A==
X-IronPort-AV: E=McAfee;i="6800,10657,11663"; a="72940554"
X-IronPort-AV: E=Sophos;i="6.21,206,1763452800"; 
   d="scan'208";a="72940554"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 10:20:12 -0800
X-CSE-ConnectionGUID: n1sLmbdCQGKseraVCcwe+g==
X-CSE-MsgGUID: 3sxYnid6Qqe6PyigUGeDLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,206,1763452800"; 
   d="scan'208";a="233856025"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 10:20:12 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 6 Jan 2026 10:20:11 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 6 Jan 2026 10:20:11 -0800
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.54) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 6 Jan 2026 10:20:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KLcZBUSMGOJU35bEYVXzHcqV+WixhtDMtR2duExiv69ZT1x3PU3EjtI0ejPoniC2QQCbMZ8Z5wYOdMd2aoDjqLVr6oayweqiY73fz0x6zogeu0X6Q+lMUXyA4rHxMYtr7Ch2EJaPdpT3+1DUXDZNSdLlNJ+7ijtJwMA06AHDLl4NP6xssM8t7S2+1DvT8E/rLwNyuMvldM67wmF7fml8MXL89t6nieVaUPCSX5arK92UBC4+o9Lh7V2hkN6ap930FBO3I6E5VFHd7/5tKUMyennQBmjm3qEz4ni7NyawbIr/yGVY2Gm+xr3d3+p8CZdzR+qVIYQdXJY0QL2oAqeCnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1aOzCr4eiHh4z0d8yvJ9X8E1vM8UlVgM/vF4a3IxDTs=;
 b=VEALJXQcc0RAp1Phspe7p92vlyxRg2rh44A3AMhi3erXjCEWCTJfbbYkDwjLJfsrpLKI+X2TYB0y9DpR2EBmyeAHIyaLR6s9y9A3owRNg5ovtQd72q9zRkFzvNPoP2JhDHgOtu65krE0RO+wSk6uOmf/lcarjQo/MzXXmCAzmWa4IUxyagh4BDIrmpOazSynNB0q4ixFUQSDAZ2ogIMDU/4z44YZHtC+aF0W1+TZnsqCW3XGxiDQ2cVSAAZwTr4sT2K+ihW8z3BEqG1NUI0dWf0W58TpeZ1/02ECJx8DVY8Lre1DeCCfYSGjTWlI9IM4IRo8M2Xacu4p2pCEvrhyjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by CY8PR11MB7081.namprd11.prod.outlook.com (2603:10b6:930:53::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Tue, 6 Jan
 2026 18:20:08 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee%8]) with mapi id 15.20.9478.004; Tue, 6 Jan 2026
 18:20:08 +0000
Date: Tue, 6 Jan 2026 10:20:04 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <nvdimm@lists.linux.dev>, Cristian Rodriguez <yo@cristianrodriguez.net>
Subject: Re: [ndctl PATCH] ndctl/lib: move nd_cmd_pkg with a flex array to
 end of structures
Message-ID: <aV1SVIH0IsxFbxjt@aschofie-mobl2.lan>
References: <20260106035209.322010-1-alison.schofield@intel.com>
 <b328f1cc-dcf8-4e44-80d6-b95a1e4c2ba5@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <b328f1cc-dcf8-4e44-80d6-b95a1e4c2ba5@intel.com>
X-ClientProxiedBy: SJ0PR03CA0169.namprd03.prod.outlook.com
 (2603:10b6:a03:338::24) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|CY8PR11MB7081:EE_
X-MS-Office365-Filtering-Correlation-Id: 9aad1b33-bcbd-4391-26ac-08de4d5038cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?/ajSBcq7T9Ze7v0qq+S3zWYzmmBlvD3rmMt4EtJ6Y78T0ZG+enVMIzT9htCU?=
 =?us-ascii?Q?g9iK7ERg0Hr+WDO+9Ltmx9WoQ3kSarL2iZAmSidGmjmIcrvLwp+0gKKABAVA?=
 =?us-ascii?Q?B6GDvfDjShy+I/wYQCq+trumnotmnVX3wH9BrONd+mzxfM8BXVvrwOvKj7a1?=
 =?us-ascii?Q?6kUl1SK2L0rZxhxOwa6D74MmJsorEFdDFxriMsViEqg5Ebt97PfsX2qooJvj?=
 =?us-ascii?Q?Hxf+JcuBh3JsMZF7T/DdGMgMFC8fFXyibRVRl8SKubp44Jakcbxa7PToXLbA?=
 =?us-ascii?Q?SjslhSeADhdSoVuIjSs7rJT45qkXbN/5vFFukI6I0pJXBF3Nz9GR8BE7b5O4?=
 =?us-ascii?Q?CeENFz7/zpi15tFBKVyMEAsQRhPtnuP8cTKnsqWTjuj3H2mFC115SdJXxLK5?=
 =?us-ascii?Q?zXIIXJ9tEer6gdk0vgZFWrZCQx4izfLcSZ6MxcNArwZf1zsqJK6C+2xrPQGW?=
 =?us-ascii?Q?SLVSkUORS+f4EMKXb1JN8rzOk6pto7LGj9Y96V8oeHWzswrZauQ5GvkysSpU?=
 =?us-ascii?Q?Jx7ZkQvQUsXbtQ0/GSN5PmtQzYooYHms8bt38HiUI81Gu1CaATFT++cX1SO7?=
 =?us-ascii?Q?unLc+iQmMK9POqtz0tYOblUYR+EJ7JkdLnn5dWTVnHl2FGnsEHXzyITphkCp?=
 =?us-ascii?Q?zWLZ8TpJ6tu7vy3nWaMBlJP2omTCfbbe7NLH1r9ZIp5w66SVTNhRHSxWSQ6y?=
 =?us-ascii?Q?We42woFG2EgL0hyvjP2ERsN148NZAohBpwUwWr76WQLvQj6g0/TQ8rprqah/?=
 =?us-ascii?Q?hRatGW0z7iYjkQw7qa86wLFsksZiJhxA2yXLM9w0gQDwtmxopedVYG1+OoMk?=
 =?us-ascii?Q?KowUH7WZkjbEl3yAIC1lEYiERwI+TcNyKDKUMgnZ0MKfNv/zc4ZZI/D+VzGM?=
 =?us-ascii?Q?uEH25dfCL4f6AAzIt29OWyhvTJfRSXAjoVIT3eHs9eEREzNGCbU6ORNe0CHX?=
 =?us-ascii?Q?rSJQzW8DenNitx6bbAKu0FCDV/EpzVyosPoUPWGV6JhAiny7S8+z5p/ZMbaT?=
 =?us-ascii?Q?Xb9+jvEGmUuxqlRfZEup6TbTnctY2KSQ6MWxfi3Ca81m5X7ZmHcMQTsyuuHx?=
 =?us-ascii?Q?3g4v3FlkqX5/A0pBwzma1EBz4WCW/7wGmX1BTqrAUOB72UUEYOg19SixCm7G?=
 =?us-ascii?Q?wHDCXExxnd4lh1us4IPSl2eNo5JHhh0fH5Yx/7nRjwY0+LI/3XZNrfKDcmbC?=
 =?us-ascii?Q?rIuw1SCu63Idt9oRqllsoYMjBRfKG72jPtzuBt3z4NOrEw4vUyiobUZVOwIP?=
 =?us-ascii?Q?B+DnNpFgXHpU/WmEleLRxYdqMnpg4PF8sYVos0HudaKUsSPPBvjGtBBZqK2Y?=
 =?us-ascii?Q?Bl6SPWoW/mumsMZKxh+dMZIbn04bEOtUqchOzr3yGLdTDNy9bvECP338tTBT?=
 =?us-ascii?Q?stPl145BFMrYmGjr68YXP+0LqTs38zXQKn0UqK/EcJVlvS5o+lc+7jNXXMqz?=
 =?us-ascii?Q?V6PqM8TEY4gVT/ZMtLBNxZvSvLbumiJYRDgAljj7ugV7jzr3BDGuBA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BKxdaNBdBKdV4rUqL45D1+laiRa8kqaUP6ryhmJ3zbuf0zmis7yPZhRNrI10?=
 =?us-ascii?Q?rgwOCIJ12r6PFRxAtKg7yEbjfDQR+vIYsAfr+dPA2jhGvHCaU/LLdaxt5Pki?=
 =?us-ascii?Q?u+fMvTdSayO/rnVRUcVqSeB5fU3Uosv3qVQk35gk09ZuvR0ue41GWtGBJUgy?=
 =?us-ascii?Q?NDHOmKmeAGxgg/DiCcpVpPISvWVd2QETbnphLfRTrlZ7TfxJXI9lAXoRFczb?=
 =?us-ascii?Q?j4VQeG/R2+Pe+H2+9Np2of1N7IiAS6BNZB/+48lYKjLKWk4vjVYZqPizLXiI?=
 =?us-ascii?Q?WMpKXig3h/rxFo/pChJ2csdI1iz07iMLA2KzQnXBW/M1yScD2KqKbOM8SUK7?=
 =?us-ascii?Q?9WcYPsIWYYMAwgF/vNrBFXh5fdPACojVlyQgIhrYAVWvpEUz4UIIvwSB+XSI?=
 =?us-ascii?Q?vm+fxNcoxPCck2rDrga6WYlFMWS18MmgZ92ckm8ZshmCMPdgqr/WAzRxbEfy?=
 =?us-ascii?Q?U/uP/9s7Z8w30bIKKdku8HkMcQpIqkMkR+goRbdpMAZv17tn0t77mhWyamem?=
 =?us-ascii?Q?TGxqEVDX+aXFxmfHyKtrSsuXOrIIdOubgq5I1TiVdjTh/548x5WkJE15FtDY?=
 =?us-ascii?Q?liWfkZy9IJGzLA1B6WNTX0Hx8wH7LlVO9pH2BEd2B15FhMwFWr6Gjs/igxcq?=
 =?us-ascii?Q?OwB+TDclyHLobQGT2dhrJBkg76WLGwEACFeM8wf743wJziFvnz5EWZJC1xiZ?=
 =?us-ascii?Q?XcY8/CfVAAjrU4GzQoeMA0bAJWFse4ePwkA1IVh/ucuONP0+jY0GKlBI2nFj?=
 =?us-ascii?Q?vU8bqc07yZNOh+JSO9xsOw3La84XcPBL88bW1ONuhc1hoDAL+I9u46LuFPiK?=
 =?us-ascii?Q?sYvzoTzNWTkJIaV7fO6ZKq48+SRzt9gfI/74w5iWrwuNgFha8w5+M7hsgxOe?=
 =?us-ascii?Q?sUQy87+6O6XHFdOvNy6OzQYRy447mVIsAauo9Apqpb2IYVglculpdWUDnLD5?=
 =?us-ascii?Q?RP+UVIvXQwh4IEnmWb9EgwADlIXgC9Fp/FzeQhJT3SeSw0+wZSHiM6CwH7MR?=
 =?us-ascii?Q?Co2iMdxQqz2+a8aWw2gYfWitc6UV+zj7fcyH8XbgeCHoZdesgSBjLZaHPrj6?=
 =?us-ascii?Q?avYioKOBEbUSEzJxh1N80gPAjd7Kt+sVhoq0a9Y1+XuwzV+8NCgOYgMR0+yK?=
 =?us-ascii?Q?6N6wdND8mvPIfN4VdQ2UwqbQ9dNd86/DQtUof3mhzHxOChKTlzrwGTctuyG1?=
 =?us-ascii?Q?WnoUPrril6Blr9ZFVB4wVlBTv7G/cI2Sw85lqupGfDGxfaLnpsu0TlKbmsE5?=
 =?us-ascii?Q?9iFAx3+60+r9CLjCmVvR7jflMF95T9zuicoLyUSklIFDWAjvgxN980tzKy8b?=
 =?us-ascii?Q?Lg3aXUbp6hsx4BnW7XD+OaET7nrDFsVQT8Wv96YPsjv2cYhnwjNeF5DkyZB2?=
 =?us-ascii?Q?XVzXFckhuxJyKKbVfieMGa4wu94jnxZf++pC11nJgBI1cnFZmOAzICrXW2S6?=
 =?us-ascii?Q?feZTeNmAw3Pp35wdevQXdMob7qSI4rWHzsIxgzxxY0DH1TdenmW7x8CptoFL?=
 =?us-ascii?Q?dz83gVFfx2PZUuvbSuT51h0ifyMiyPQPK5CZKPlo7Af+gPghfUhxcOVZ9ZNV?=
 =?us-ascii?Q?ALhtgaJiEKE4K2zN7VfGUzOTK3Wsa5kXio3JFD9Mfrgimgfrfpj5FjNpdAJZ?=
 =?us-ascii?Q?vycjSFggE71RqSr2ETzRVazdOT/2hS13Z8jBTrd+ldDSfVkCxMc33kgwKcfh?=
 =?us-ascii?Q?3Zq2fvsd/ftClGd0OcxifwEzFQCf7PPGpgdsj/mpP8jwDXtT0+KapXivdHhH?=
 =?us-ascii?Q?PLN+IROLGTruq9ZRfCG/YkCdm+q/tVI=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9aad1b33-bcbd-4391-26ac-08de4d5038cc
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 18:20:08.0517
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QxpRQJJsGH4qHYq+pl3TtFfaPiixYAjAfR5CTGRwCVnqOvhROIu66HLLurPbHaV/KbrQJFT4Jvrm4VnGM5IMhhjQc4iXjbYKGX4XpschhnQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7081
X-OriginatorOrg: intel.com

On Tue, Jan 06, 2026 at 08:41:35AM -0700, Dave Jiang wrote:
> 
> 
> On 1/5/26 8:52 PM, Alison Schofield wrote:
> > Placing nd_cmd_pkg anywhere but at the end of a structure can lead to
> > undefined behavior for the flex array member. Move nd_cmd_pkg to the
> > end of all affected structures.
> > 
> > Reproduce using Clang:
> > ~/git/ndctl$ rm -rf build
> > ~/git/ndctl$ CC=clang meson setup build
> > ~/git/ndctl$ meson compile -C build
> > 
> > ../ndctl/lib/hpe1.h:324:20: warning: field 'gen' with variable sized type 'struct nd_cmd_pkg' not at the end of a struct or class is a GNU extension [-Wgnu-variable-sized-type-not-at-end]
> > 
> > Reported-by: Cristian Rodriguez <yo@cristianrodriguez.net>
> > Closes: https://github.com/pmem/ndctl/issues/296
> > Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> 
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> 
> I wonder if a comment needs to be inserted to the definition of 'nd_cmd_pkg' to warn users that the struct should never be placed anywhere besides the end when used as a member of another struct.

Yes, a comment will be useful.
I'll add it upon applying if I don't rev for anything else.
Thanks for the review!

