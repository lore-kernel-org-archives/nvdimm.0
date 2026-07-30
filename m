Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4731E3E49DF;
	Thu, 30 Jul 2026 22:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785451515; cv=fail; b=rifOl/djGeJdAK3vbgsAvoT+PPdoJwNlC26NYGfAkOqHlfHjuSpoOs5laQLpq1KNuiLYnIGIg6VWgo+oEg18Mj6Vnd91LOOfEYaZGXGgbd8voYzDC+BvcBoiZHynhMUk3imDB+ltAQ7hgfsnL14NdRL8IpT8czSaZmWPQtu0Ikk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785451515; c=relaxed/simple;
	bh=C9XD6MkTixjZOCStRlolTBu7grfwPgtu8quOb8Ts0XA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XDep9/eju8pjzamXuoMxjBl8rR1+vwYDy31q26LLMyyo08JRqY3NRByM2u8RYOHcPcxAK8yvSp8B9EUeDffxaGDit18+D8Fb7UkONAgCFGYkZwYKeXcj+uX4um5yeP0vVynjIiqpLhdvBAZl0wBx9xl00sB4ysG+/WkjFliTmZA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aGHG2pC5; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aGHG2pC5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785451511; x=1816987511;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=C9XD6MkTixjZOCStRlolTBu7grfwPgtu8quOb8Ts0XA=;
  b=aGHG2pC56GzaKaDsuJcsoHUuZMwTYk3Yj1kapafub1brFlgVqnQRF/ZI
   0roBVnY1y7H+iMDi4kLZKv1yK7S6u4BDtumwq3HtTVMjz0Gg8oG4KoS51
   H4ArzJZwHeBpNJlkejSHhLqJ3W1KEROPydzi4+nJocKtLaP33bYYDZBBx
   RGphsn3ouKTPFSN2IFdDjaJ2kzEEQwFa2kPAvd2uIsDKObFshytrtDu3A
   tsofoIgbFr1TzEzORiRZseujlS+ltYq5ICYuARi3T9n9N5C2VHVkIsk6n
   Peh5rKHPN8FkUmRaSO1vekHA2FpttSUX11dSkD+BolRZI+pdazD5QASwb
   g==;
X-CSE-ConnectionGUID: ZLV9ZKKDRZyBU4ScR3QO1g==
X-CSE-MsgGUID: +roLI3ZPT6Csth/7CGavpw==
X-IronPort-AV: E=McAfee;i="6800,10657,11860"; a="73615584"
X-IronPort-AV: E=Sophos;i="6.25,195,1779174000"; 
   d="scan'208";a="73615584"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2026 15:45:08 -0700
X-CSE-ConnectionGUID: Yzb3mHuBSBCpGGPL97ZuPg==
X-CSE-MsgGUID: 2dOkmxP5SwiguUyyNrxwFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,195,1779174000"; 
   d="scan'208";a="264228769"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2026 15:45:08 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 30 Jul 2026 15:45:07 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Thu, 30 Jul 2026 15:45:07 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.51) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 30 Jul 2026 15:45:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m7zeseP/eM4t5AHk8I5Gfz/mgQjNk/Co2Dw/2JqzAiQ1PFAmXwVLlEevnnfrqWNUWrxHgBim13IR8n+Z6IO4jgylc+Fii2UynIU3NKS3Or2YW34F891y9RqIXcdCVsXI35yUBoNJ2ywp0lRwxX60+BKtsn9K160Cekowq18IZfkfWcpDJlKcr3in2AtmhKDtWCLQCuejy5dnsG9anVu+AXQHCrOp8qTUH8vstUKQ8nak1GDUk6fjF6aEQG/D/e8dsRkHcgzsuPovsO6O77Z0iRxkxxRqHTAi3k/HqZGPzWsmI5DLVhya5/z17AUZ/zfNn1o36swzFZBF9Wwcarjy3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p3q3Gs20j+6wMeldHii5YFCfE3R+zsDDrXNT8aXXXfQ=;
 b=WxaKB8/StxaRz5XZtZgYcKPWZ6mvNHBL+ESYJjseb1zR9qSXF/Fiv81X+7vPYjLDoeThsy2+Qv6KBXQPnE9DcATFJb5IMvCcl5J9omhM/9LJOCwa6oztZyC9wvZ5ek02lr7JiOE4+EBkvzGTVXLnI/+IBfXgVxK7LWs/bL2AC4G7j7m29DnVIPCa37PatarvktWql8XxdcpubOnYanm1fL3th0kykbLp8wKDtbbUs6UC0s/SbMVuVFoF3EwsVSjLB3EaKU4W1SHuVJbU642tKDvmroVeWW+4ZoLCeJt7+ONCK9s7KwYNId/+Xmzx6Vg820c1t7u8PXVO8mfIpFTrEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by DS7PR11MB6040.namprd11.prod.outlook.com (2603:10b6:8:77::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.15; Thu, 30 Jul 2026 22:45:02 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::e721:90d7:9214:2d53]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::e721:90d7:9214:2d53%6]) with mapi id 15.21.0270.012; Thu, 30 Jul 2026
 22:45:02 +0000
Date: Thu, 30 Jul 2026 15:44:59 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: <sashiko-reviews@lists.linux.dev>
CC: Randy Dunlap <rdunlap@infradead.org>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH 1/2] libnvdimm: nd.h: clean up kernel-doc warnings
Message-ID: <amvT6x84r_HhMXaB@aschofie-mobl2.lan>
References: <20260721172132.3718892-1-rdunlap@infradead.org>
 <20260721174105.B837D1F00A3A@smtp.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260721174105.B837D1F00A3A@smtp.kernel.org>
X-ClientProxiedBy: SJ0PR05CA0188.namprd05.prod.outlook.com
 (2603:10b6:a03:330::13) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|DS7PR11MB6040:EE_
X-MS-Office365-Filtering-Correlation-Id: dd16ae97-8f41-4273-be19-08deee8c3141
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|6133799003|10067099003|4143699003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: 2Pq0hkc+eRqPHu2uAExI/9p1MKKipQOzLNodXV/dRUKyaveeQi6hg2pSqT80y1hnABVW+vDAsxQNy+yassS730c4+rcSDp0jSLqVGO6UiqwTp5EBKOuCGQAm4te6SSf1ESDG2c2k0gEteM0Y0//FIuhSOi1Yn8YmfVHjVO/xmNqMgeCYwx2heXjc101nP1vsMfKOJJsFAqVUcPY9JBtl8GlPB19J9UgkkfvG4BERxCS1qUK/BzF98hiBQWcYhVADZ8lQ/dhHNMAcKsg6WuTf1/NNdN6PVOM8HIENRUhVfW+BhgShzLrcmeZ5MBicfXqNGofq0L0OB+ilN55L63X/sUASWL+EohJ+1/L78R9r3dtvHEpmiXD4DcdaFvGFatGmc9kJP6uKPZs/fdfY/ptLtYLSIY5E7KexZf80Te7jmTAo0i7h0uvBKjlAhjIz5MrVCj+5V+pQfhZU87aCWcgsHRRktoy7NZfp0UfIzmf2v389WKIGZkmg3jXpwEcYYln+YyLjBBN7MlRP2iK96SnH46Odjk89PVqudmiFSEWM5larhn1cZcXhDyz37gPSubLJVC45A5+Zb2VvQQzmTItTEONSoTQCOJiK+hpf20Kv7CY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(6133799003)(10067099003)(4143699003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?EB7VA16NQMf5V+nydx/yqkATrbgvJdy/xGth0DWZ7uupvxWhvhK6odQulQ?=
 =?iso-8859-1?Q?JSazXYBqWzriGtnbuWy02qEjfwVzLFQ/IyBiVfg3NIQX/kwQe6JEBhqQTT?=
 =?iso-8859-1?Q?8IHnD9wsBSF/CGNLKGhCVuZ0NiC+td2IAsWP0t2c+JXYRsHVn97TkdxhXd?=
 =?iso-8859-1?Q?k9Lnx8zBg+gWFUY1JvzIzpG6unZU+PsSa+0gPJwcPT0SZTyUfJmUgVK2rX?=
 =?iso-8859-1?Q?5BFDJEBHgfq5a0Jwtb8FkV/5i+Du/1xVf21ONC7g69DOT6Kby7DfmEAJRO?=
 =?iso-8859-1?Q?q96OHgUyqeVsDzKniExJ08QvLSuZlTLSPRbHWXEHtxIjU4fdkdHo/hQoIS?=
 =?iso-8859-1?Q?8M0vr6a6qBrmfsbGN9/zURzbSvzPbCC7uVTWsrM4kGfExlObrtu8UKRJvl?=
 =?iso-8859-1?Q?yuB31PfxDVu2O+zS/Ojt0rc46gt0537IEpD733ugNnT0qgB5muWeDu8b0v?=
 =?iso-8859-1?Q?/mPtqoEutP75lYKDRToEChuMgFWFKC89U+lAd9RwusnxOq+Q1N7cRnCA7n?=
 =?iso-8859-1?Q?TI2XpcgqUQM45rPX0QFhuKNb/eSQRtuQ5Ge7COVyeEj9h+sj9yC1a5319m?=
 =?iso-8859-1?Q?RKYU2sENd0JdUc8Wz6cetLKfi7hoEZnFzpoYxGhOWCNUcMeK2lL5Npfkz9?=
 =?iso-8859-1?Q?wDIiTsCZSMhOX94e/vsFUBaxFXnZ1ANig6EUL4R6NZTZ0d1Uq6M+5xrQbj?=
 =?iso-8859-1?Q?5LMnrrJJjpgsdstAtGqcI+Uzy3totc/5ULpNWYSj/BcPbcJnfEonCt8WMs?=
 =?iso-8859-1?Q?mLzcS7CymCYfaSdYSLPUXfyFLDOjMXatohUWvxtAZinEZH+zK47Zc4TFli?=
 =?iso-8859-1?Q?ibd+Qb6MuQ/dbNWUU33zJi+Cw1WyUUTOaZD3CMcRTyLRvDiMX+OvTDLwpj?=
 =?iso-8859-1?Q?cctza3Y4Ze/iqpZkkjXcG9DxoC17mZrkDfJDNXM9aZX8d+thH6IjQ+H94L?=
 =?iso-8859-1?Q?V2pU8w3x4RcDysyoXYq/VRnh7cVXDtOQrfZSNq6HbtCcQJnJrVYuE1fjxX?=
 =?iso-8859-1?Q?h+O01DtcJpmisFBez5tNO7opZDILrD//OsFbveJKC9BB5fIqODNKDzn10A?=
 =?iso-8859-1?Q?H29/fMwJYUh7iPPDj1uG/k4sC+b5uUX7E5CdZcs7o0WWD/iOQB9OhX6bXt?=
 =?iso-8859-1?Q?J00pTDm3vmxV3cV92g4OwGQhP3yLMsC3WaVLTRrDS7qiIfuuAi/MGCztzW?=
 =?iso-8859-1?Q?PIUjg/t6wFxnm18XWgv025ciGOk6qCH7RZd2GNEVXnvVIqk72cSJNYjNtN?=
 =?iso-8859-1?Q?4y/yAHQhplUSFjpFzMDEOD6k+QZ7m1LtdVbwTFgOQB+Uq7v+Lk84mFFHv5?=
 =?iso-8859-1?Q?+WnoKBmtNFyTq7cyfRj/p+7cOn72xaCn27ZE7Qdk5LAMQmYLH0OxZu8dmm?=
 =?iso-8859-1?Q?X9k6dGUKnzX4jW7xIXWTwvEXP8M4op2yzQZzevWcV0FTR0nq2WFSKYC5Fz?=
 =?iso-8859-1?Q?pR3ZrfAhoPxxL5hhCoh37+hk7CMOUinjTAsFGHOdUVEd7ES5gU+Zi9Eg2M?=
 =?iso-8859-1?Q?Rhpu5fJo+zUAVmBph0YLINTZSeRKA3+lmM5FmyJZcAKRzSNiPhtPSBFBeG?=
 =?iso-8859-1?Q?RRDx9hlbILu9tbx+A3hwcc1gNnxMHyjX1P2iF3XNxN6bRnN2ee6ipetj1H?=
 =?iso-8859-1?Q?Dpx5negAMiNa+7Sm2KTEoXCYkMkBz7LT9ffLoBYiuU8Akl6r4EsQw9tYAH?=
 =?iso-8859-1?Q?4qe1hM5Mqhp8UXD6M8OI4jZvJM91RXiOmKy0SM81x+a0rWggYsFhm/RxPl?=
 =?iso-8859-1?Q?kBlfAcN0itzfvYZ/mTnSf1FZ31CGoqjQd4aTwHLobuwkMw6k+qZ1/LawZI?=
 =?iso-8859-1?Q?ZnJHo75fN7IJx3mKoDRrTT+YYcxgpeI=3D?=
X-Exchange-RoutingPolicyChecked: dkMm8Daz5wxtIZ38diBuof4RZGHiFjMQyGlOdD+L5ji0JYFEy9PizETFwk9GKA02R8SDtnTDX+SY2U+DyynY5V2Y3v2PJL2fw6tpMShwkKt/GOVaDisoidiFjHP2p40kLxgcEKYUheKfeTLfT7/yLFLL4YHlkoIBAvhjji/RNPWf2HzapJQEzrRBWWkv13+uLwycMcCA4GrE2VD3HJZbt9vfrdV++AgL81axeedP0LAYPVZ3siHe6y9ibojuzLe+zwyOmYjhmqHKjUI2lcRDehG6xyhWBVetjSRbYaRp9VOJfgyQCbIKqd+nDRYbsDpYYW1WMX4RsVj/U/GqYNAulQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: dd16ae97-8f41-4273-be19-08deee8c3141
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2026 22:45:02.4652
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: igvYeXhqyLXqJA3uH52LwSVujXazU2aH2L2tbudV8dQlGp5JqgTTrzS6Wn+QOwUcYkyjEyqD/I6AyNZgcdgKDANCvASpSJq347Y4ANtKFXo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6040
X-OriginatorOrg: intel.com

On Tue, Jul 21, 2026 at 05:41:05PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> 
> Pre-existing issues:
> - [Critical] Writing to poisoned memory without clearing it first can trigger a Machine Check Exception (MCE) leading to a kernel panic.
> --

I feel pretty good about refuting this one after investigating, but welcome
confirmation from others familiar w this code.

The point is that's not how poison works on the write path here. A store
never consumes poison, so there's no synchronous MCE.

memcpy_flushcache() reads from @buf (a clean kernel buffer) and writes to
the poisoned destination. It never loads the poisoned line. An MCE requires
consuming poison via a load, here a store just overwrites it.

Note that writing over poison isn't accidental on this stack, it's the
intended clear mechanism. See: 
- pmem_do_write()/pmem_recovery_write() in drivers/nvdimm/pmem.c
- commit 0a370d261c80 ("libnvdimm, pmem: clarify the write+clear_poison+write flow")

The -EIO isn't swallowed either. It's returned to the caller and the
badblocks stay set for the uncleared media, so a later read still fails
cleanly. nsio_rw_bytes() does fall through to the store where pmem_do_write()
returns early, but that's cosmetic. The store can't panic and can't clear
poison in hardware. 

--Alison


> 
> --- Patch [1]: [PATCH 1/2] libnvdimm: nd.h: clean up kernel-doc warnings ---
> commit e89a1ebc4ad5020678df8e74422e59aff926ae52
> Author: Randy Dunlap <rdunlap@infradead.org>
> 
> libnvdimm: nd.h: clean up kernel-doc warnings
> 
> This commit resolves kernel-doc warnings in include/linux/nd.h by adding
> missing struct member, function parameter, and function return descriptions.
> 
> > diff --git a/include/linux/nd.h b/include/linux/nd.h
> > index fa099e295f780..62988000e7a7e 100644
> > --- a/include/linux/nd.h
> > +++ b/include/linux/nd.h
> 
> [ ... ]
> 
> > @@ -174,11 +177,14 @@ static inline int nvdimm_read_bytes(struct nd_namespace_common *ndns,
> >   * @offset: namespace-relative starting offset
> >   * @buf: buffer to drain
> >   * @size: transfer length
> > + * @flags: process (0) or atomic (1) context
> >   *
> >   * NVDIMM Namepaces disks do not implement sectors internally.  Depending on
> >   * the @ndns, the contents of @buf may be in cpu cache, platform buffers,
> >   * or on backing memory media upon return from this routine.  Flushing
> >   * to media is handled internal to the @ndns driver, if at all.
> > + *
> > + * Returns: %0 on success or a negative error code on failure
> >   */
> >  static inline int nvdimm_write_bytes(struct nd_namespace_common *ndns,
> >  		resource_size_t offset, void *buf, size_t size,
> 
> [Severity: Critical]
> This is a pre-existing issue, but while reviewing this documentation update
> for nvdimm_write_bytes(), I noticed a potential problem in its underlying 
> implementation in drivers/nvdimm/claim.c:nsio_rw_bytes().
> 
> When a write is performed on a poisoned PMEM block and clearing the poison
> fails (for instance, when unaligned or in atomic context), the code sets 
> the error code but appears to fall through to execute the write anyway:
> 
> drivers/nvdimm/claim.c:nsio_rw_bytes() {
>     ...
>                 if (cleared < size)
>                     rc = -EIO;
>                 // ...
>             } else
>                 rc = -EIO;
>     }
> 
>     memcpy_flushcache(nsio->addr + offset, buf, size);
>     ...
> }
> 
> Can a read-for-ownership of a poisoned cacheline during this fallback write
> trigger a synchronous Machine Check Exception and panic the kernel?
> 
> Would it be safer to return early or skip the memcpy_flushcache call when 
> rc is set to -EIO?
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260721172132.3718892-1-rdunlap@infradead.org?part=1
> 
