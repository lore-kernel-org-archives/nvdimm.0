Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A491CA84
	for <nvdimm@lists.linux.dev>; Thu, 25 Sep 2025 16:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758816422; cv=fail; b=EWnN/NUC/hHZfwGT0sH9QtEPjR+bqSSWs+jmzvqUPNaUvN8lwZFO6gF2KUHrERjf52EWANXqRGeFO0rshe1MPCyUzyyA/hwGyH5Zjbaf/sF8ODayTfWFUO1bl0MY6JfE4J9kLk6Dk8d5DRvf80sgW8e2YvL4CN9bJL/Kw7vR8e8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758816422; c=relaxed/simple;
	bh=vfByY9qNoyf9EukMijKvhXpSbtRJgERgdI2lKFzDHZ4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Ci5EHkDK6COjuztKisnbGWgdujB67rHiJrFYE/yDDwq06YjtqM3ibmisaEQmprYlRjxJdJilRGMRsECuhwY0fAVlyzAcW5U+xAa5mt2uIgXMzyJRtg3vX40KJMMVQLPAt5cP7bjMJs+Dcgi/CXD5cyp4OlSN3HoyHj27D0mBYMI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mDH6bbvY; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mDH6bbvY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758816421; x=1790352421;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=vfByY9qNoyf9EukMijKvhXpSbtRJgERgdI2lKFzDHZ4=;
  b=mDH6bbvYeUfGuqSSn7L1X7v7PfymuTYcwftXGNhpL6cBccG4tczQd1fG
   VDy37FYyY0C1fHuQbb3W7fmpXIw8jckvW3Vzm437y646n2fjE2kimK3UT
   mjq6iHMbT5OQ/tArG6/YvXQQq6qAG/6RaNoXmI2ZSXFNJ0w2dbcM7q1rx
   KfUi1ng7jCuAGxBSF3pw+LvZTG0MqYx/qxDFwXnEbrp0JRMKgJgCyJDQ2
   uM0G8eTBqURu4kJtVJwC+HnNeWs9qrlxIzOlFREA3mzXqMqu67iRz2tFL
   Dn4o7htniAmiD9tHgdcguIsP4LrCxIvpJNgi2c7XJM1vDtWvm0BN/Q//K
   Q==;
X-CSE-ConnectionGUID: rcaRntd8REe1dFSJmJsYfQ==
X-CSE-MsgGUID: HzeqOi3iQ9mgknXAR2Klhw==
X-IronPort-AV: E=McAfee;i="6800,10657,11564"; a="64986868"
X-IronPort-AV: E=Sophos;i="6.18,292,1751266800"; 
   d="scan'208";a="64986868"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 09:07:01 -0700
X-CSE-ConnectionGUID: lHNhds2xQg+ZJdw4Pu0WXw==
X-CSE-MsgGUID: X3YytFRJQPS68uH596YMJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,292,1751266800"; 
   d="scan'208";a="177302310"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 09:07:00 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 25 Sep 2025 09:06:59 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 25 Sep 2025 09:06:59 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.27)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 25 Sep 2025 09:06:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kjJREpDYV8/UolU283KpAGnWoskdKku0EL9chEZd8FRURG6knaS5eNFcsWhHKI3L9o2VAQfvcMULICqS3zXH74qnjvBYm5RUE+wIFTxS8WIwouDp1z1/u3HnYXRaS4G8AaGGDVE6xkWUfRY+O6TPvkqladD1PcAsTiplOEcmuLt6Cz7zcoFZGGT2uiJnmu4VpUhzn6AGt6Zz98h1qsyHkw/l2ZnuQxDkVILM2ulmlr3toizk0j9SICTD8Exfks/JeZeAnP2ATbgeEYYqym8uCRWzvSB1eo2gyHtbNGsWxQ2sP5HbWVR6mu/cNv18S8qoLSvPjUs58XfAayIMYMVZ+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B3mDCXNCCu4sckDbBEwnqZQTgeeuWNJ1IkPAkl2TwNU=;
 b=GK5ewvddVIiT35/IHu1BIuH4I9nyduSo82zazW9f8ViZYs+x/ZdSDEPu8Mdu929O0WHKjb3PNQcLeD4SHz7HL6LbfTF18vOJxSOKte/EKyFYKgOSQaZUsZ230UlEMFAbOhh7RGIuNQ9j75Tqn8JO+T8wDdi6hZHXuuwiGLoLaDuh8ALf12DGF27GKeB0UDU+6fVaI8rVc+qJWUgxFjRpYu1NDwTv/jGiU+kq0+zvdFRqzBteaMNu/KjSIg0BGWIdULQjIdboNnedOZiuUORSfjSAGe0U2e9sjiUTP8kAZMCP3CXXeaypviBX+i2RTZYfeTwJY7LhkXy0lRgRO8HneQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA4PR11MB9131.namprd11.prod.outlook.com (2603:10b6:208:55c::11)
 by CO1PR11MB4819.namprd11.prod.outlook.com (2603:10b6:303:91::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.10; Thu, 25 Sep
 2025 16:06:54 +0000
Received: from IA4PR11MB9131.namprd11.prod.outlook.com
 ([fe80::7187:92a3:991:56e2]) by IA4PR11MB9131.namprd11.prod.outlook.com
 ([fe80::7187:92a3:991:56e2%5]) with mapi id 15.20.9115.020; Thu, 25 Sep 2025
 16:06:54 +0000
Date: Thu, 25 Sep 2025 11:08:56 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Guangshuo Li <lgs201920130244@gmail.com>, Dan Williams
	<dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, "Santosh
 Sivaraj" <santosh@fossix.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>
CC: <stable@vger.kernel.org>
Subject: Re: [PATCH v3] nvdimm: ndtest: Return -ENOMEM if devm_kcalloc()
 fails in ndtest_probe()
Message-ID: <68d5691882202_245a5429471@iweiny-mobl.notmuch>
References: <20250925064448.1908583-1-lgs201920130244@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250925064448.1908583-1-lgs201920130244@gmail.com>
X-ClientProxiedBy: MW4P221CA0016.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::21) To IA4PR11MB9131.namprd11.prod.outlook.com
 (2603:10b6:208:55c::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA4PR11MB9131:EE_|CO1PR11MB4819:EE_
X-MS-Office365-Filtering-Correlation-Id: 7187397f-c882-4d68-8b1d-08ddfc4d8be4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?CoitVptrx73lL/x9wgO0UmHW9gg5tthgU0WcGsmpWEixV3UB5DGP4hCUPF0Q?=
 =?us-ascii?Q?r7wnRej2R3Slmq8+SzlxPScDwum2CLfrlEz+UWKRLa3TQa48xnkFOWJ8bHCY?=
 =?us-ascii?Q?55Ksc8sgjOVdgOePP/RWQpIkUGK4xXqFj8ykqkgYodpV6cOQLcRJM3TYEx2b?=
 =?us-ascii?Q?g9664Ku6ldKbbXlD+O7Uag3YPJdWcAdzBY95YtH6AnrVDLSaaM4P1S0mIaxQ?=
 =?us-ascii?Q?5bE9VnHuP0lohqf6xkLDULcpK+G64XSH4Inz53uED+arvDjAaHkQ89L6u7U1?=
 =?us-ascii?Q?BUs0suxJxoEZRvCCDIvVuFVJZ8RTLRy34mi0z/0YKiS/565KEKxo/DDQwHuk?=
 =?us-ascii?Q?yB35aywI3xOxg1ZXn6VuYvdbzqu9wYFA6P25yX98CeCXLNAWwrSJKt021KOU?=
 =?us-ascii?Q?yQT1s9a5j70eQN9KsLyarjrCAnCKBHvbjcRNERxVHZOuruscCsi1w4cvmu6s?=
 =?us-ascii?Q?XzE+67zB38ga+ngKRrTHw59WpBMEqmoGiiCoAb4wcdrt/SX+uiS38snZJCJG?=
 =?us-ascii?Q?KewewdGyEKt3FzRUmAb1JqkNoq99vh6QMxj0Zd/2CW1fSmMJ5Lrfl2DWEYQd?=
 =?us-ascii?Q?HSy8iT8WDE0YoiwVSbnvvPVg9ffL+NgEJ91WNWZCO9NGO56oRXcA/KdwYhEn?=
 =?us-ascii?Q?bGxZheNhG36SNV0E7oLKESGFdxzpdXU8W1HwgXzyXiB9I9z9+xgvnNJ/9Afa?=
 =?us-ascii?Q?TYYMDmNGdBNhWp2c9kCcjZ1WGIToqMzXjMjho337qnVYs2+GCneQcXBi9Apn?=
 =?us-ascii?Q?XVOggtx/pTVMezTVERGj37qYWDSNS8azT/0mLZgz1s5cMABSlgQ5a4SPZL9M?=
 =?us-ascii?Q?PqKOzy4rZKVi87SKRwudSiHAr1cJrM9NLEckRbyXefrtdDBB1PX/Bv6uDmNf?=
 =?us-ascii?Q?5RYKwWLHfW7FXUq8E5YaWtAH+rZaK/4tf+2jh5mdS9kY5dcMrjUCurcuSrF7?=
 =?us-ascii?Q?vjySLLc0dRQOr/zyRUifSr3yxBjbrVSZQzMbNGBxytTHRphv7l8SUHZb1JQU?=
 =?us-ascii?Q?O6s01vnKUKGyuLBamNWSCGKDNDAD29ZZihYweesIsmTwL/O83jF3/OlkLdXB?=
 =?us-ascii?Q?LQ9vwsJPNbzxIBFrYy48MPK9SEDea+srkU06bxVAb17LZltbObZjLVYKRD4T?=
 =?us-ascii?Q?NC+GuwC/fPoS5kmPm46HnQpdkuK73dXMxlYCqlA0myMXjj22rr/U9UnVU/80?=
 =?us-ascii?Q?GWmpyETyC+5pgIRf/7MBMpPe3dQrWQMwUahS07B2QVTginkRCI1DXmQX2crm?=
 =?us-ascii?Q?Bv8ZYDEyXFre0EtWjodth/lFL/BPGrguKKmdMDl+MYlQxyVeCfXyusAcnVXj?=
 =?us-ascii?Q?iW0XFHVJ0SMMCJi8zkw/MruRXbqlXQIiFy4/aPlV9eNSbBo2u8bZMZB6K2pQ?=
 =?us-ascii?Q?EsIw+AhyWanaTJseQfvgqP3TM1RwEkXbhjAgqRCPlzOLxXtVSif2mAjPEcZ4?=
 =?us-ascii?Q?ujIj1zd9pHk=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR11MB9131.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eqI/bqZ9ZT/bVBmVUUbzZ7dSua6C9NtD3ht/tzaEW0y+lM/vtq1okOrfigSv?=
 =?us-ascii?Q?RvS9SMTTkVjmpbiTtS5UrFysN3V5NWzAhKDgQaURC2eF7UCBOddnaXtc2qrg?=
 =?us-ascii?Q?SbpXV87UHvECmpxF9HXSznxKuBWuiSItn/XMAfJ7K8Xv3ZoQ9HD9BgEAN4U6?=
 =?us-ascii?Q?DCvWwMgXfiJmuqkaXQqpmOXAZpDSw6eoE4mxl1lzuEkTvqpziIVDkjAU4Mjs?=
 =?us-ascii?Q?6MmwYXypGmlYidCt+oYvNqcLh/sVkntnKklVSD4gRkGm/uR9c6a+MBczO6AS?=
 =?us-ascii?Q?ZJfqUKxNdUknneumcdgT4TB/kVhRnGlu1qgeExBd8oSBnnZ9r7pFsMofBr6h?=
 =?us-ascii?Q?z/n9R0jGBYTgS7kyiER65NPb9a2joSgWoXQR4b5kttpKMApjzWmk0cOLX/1j?=
 =?us-ascii?Q?NkPcvRTHvKZgrVypj+U3mJuAc7eo+VR1xhL9poRFCjQGgC9V6MRZ7a/fCXKK?=
 =?us-ascii?Q?6GloCiwDyhsQFXc5ePT2fZXPz4+0OZHS/xDH4zrGplsCUpmLYdhEO4V7ccar?=
 =?us-ascii?Q?qNFQESEl71agBprSB6aJEdZMTMEz3jkv9ZHGQ9pESobv7gOBDAWJfikiSnnB?=
 =?us-ascii?Q?/noV5XZWgE5PkM4mGYgSF3D7uEzWtnMfoB3721MwiSSZ+ElzcecZCPB/i5Hx?=
 =?us-ascii?Q?4zwBc4jTPjpDfj2teBAueoOvLd1VVrYMET+a/fKX6YcY58FPkOZ1G9+rjJPE?=
 =?us-ascii?Q?U0m6LERWjidp+f9qPPEqIwSuq0UBSgw1eEDsGY72QSfubq+6g+Bd96rakl2f?=
 =?us-ascii?Q?YQK1YAt5vlvK6KCFQixnl+DXAlW9/mD20pSVs1kYrQ/siSYX0z0uHYaka3in?=
 =?us-ascii?Q?M+K/r8fzqbNjz4pb8gNvFg/dOncepkh/DZJ5a4wMTx1pYmbTDmS+iWvulYfn?=
 =?us-ascii?Q?LF3bOjZL2zNz1U2eQfFq6E3bux2fMP3yS521v0qg2UevQqFg+/6lY6xAhmPM?=
 =?us-ascii?Q?8Ap2MAdGoirv08p/ilRDgdTN+ivMJ2axpe7Rz2w7Y7A55+uRHx/xJkmc+HKd?=
 =?us-ascii?Q?LCVK46llX56woFXmAhhK4Aiichq4Jul48Mx7Q/qFco+eK6yD1cuBE19Q/KPk?=
 =?us-ascii?Q?KxriMfW6oJ9/GvKXVmqC3lEZfg4ddY5dw7Ab75SEiVJl8c0qtr/si7U/6Bde?=
 =?us-ascii?Q?t9kz04wzTFpyEgrpTdIzTmoqAirGttbZooMho8eozpMuZ47ILdDR3bpnY60k?=
 =?us-ascii?Q?KCVSWru6Wk3z7AAV2qnHlGtU/FQegW8oA2ehnVGgGhJhFylZbY4MvacZE1eU?=
 =?us-ascii?Q?61Am5/5jzHe5jj8HuAiZHSCZo3uzkuiiZrlveuPTHiAsGrUlFdXKJtt7g9Ge?=
 =?us-ascii?Q?yVSyhUzJ8oY/b8WrJYNAN/QAYPHdbkmXIXtmbNQTNbBBG2FKn1omNve+G2uf?=
 =?us-ascii?Q?czRgiD9lRaGJh/jZIAuHDTVJ0NZPJX0PeI3wjgWS9cBRyGfih4J4VGFFBQ3E?=
 =?us-ascii?Q?s7hf3k+yGYEI4uy/dIviAk1wEbVQN+GR4cV6bB63iBArJPQVsH/Gli6dwcWb?=
 =?us-ascii?Q?LrqY4oe4b90lX3Sw9IGCMyI8IKbjVJXxZ8yijFcnn6OzLPumi6wWfjYfxwaQ?=
 =?us-ascii?Q?eizNlPaTuCnhvQ1kN1OUqdS3W19spAtmQ+xE+z9H?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7187397f-c882-4d68-8b1d-08ddfc4d8be4
X-MS-Exchange-CrossTenant-AuthSource: IA4PR11MB9131.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2025 16:06:54.7717
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +9BuJ2VQvGYM4H1aeLWGW4sMDTmmGcdTLWa8bPmKgSDj2i8V15TigKSjkck78GLdoOI1WdbgyNvgADDbgoe4Dg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4819
X-OriginatorOrg: intel.com

Guangshuo Li wrote:
> devm_kcalloc() may fail. ndtest_probe() allocates three DMA address
> arrays (dcr_dma, label_dma, dimm_dma) and later unconditionally uses
> them in ndtest_nvdimm_init(), which can lead to a NULL pointer
> dereference under low-memory conditions.
> 
> Check all three allocations and return -ENOMEM if any allocation fails,
> jumping to the common error path. Do not emit an extra error message
> since the allocator already warns on allocation failure.
> 
> Fixes: 9399ab61ad82 ("ndtest: Add dimms to the two buses")
> Cc: stable@vger.kernel.org
> Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

[snip]
