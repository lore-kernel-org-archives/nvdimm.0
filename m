Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C0621D90CB
	for <nvdimm@lists.linux.dev>; Wed, 15 Jan 2025 22:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736980527; cv=fail; b=ZnKjXdSpFqgbF9rAx7FOFDmgOmzShsbmtWgNdqqYVGXb+7g0oHsDU9JqzbrMqyJyb2BsKvmrpvzeidwHyOkqCqeotBv1wXyUaljMyL9j1Zq2oH7bw3iTp7/aFBgM1CvVojs1rBmLGCv8V4rqmnxMu+8yrxqz+/pfgQ8HjACeNmA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736980527; c=relaxed/simple;
	bh=NthWdZy9CpTXmF94W/K+mPyVFGdAxJnfyipvyCkGhfE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=pODJLgMlJJXy7vnIvewkNQGHO8vXpApRtlo1qWDnI4Qs3cA6mR2THH5XqKAsOX53/Y+J9cvuYBR2s8bJRYIyLbPamyGl9/fA7MlYEhXmIo/8GXP51rraprQ0u6Jzn++szXbH7JIUKlETfyn/4CvhtJxiVES8/lyc0/HwsIM1Yrs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jRV7SshG; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jRV7SshG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736980524; x=1768516524;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=NthWdZy9CpTXmF94W/K+mPyVFGdAxJnfyipvyCkGhfE=;
  b=jRV7SshGdUdengoao8cN4WFhFmBcXQP9hu2MF5kvNYVm+Tohfqzxg2YP
   1bTRPfXnPgg8nEMCJzDeRnGJPAiUSodWexBbqSET5J81Wj9JsiztRHpj1
   LBEYol4WNAhCjzJvBCzSfrzVYxFe3W08OSWrTiwyXmi3LN822XeHvwT8T
   78+d22BJ41SEdNg2IcWr8o0UpnLXpMlq3JKv+PhfaHphuP4zEItBC6rNx
   n96B+7D0GXFhwPGZQUuPOw+bV0/ZK+ec4SNRCAuWwh9G6v88V/ufeRCve
   3xuczpisEeCmYpWUr2On0N0n0UV2aln6escecmKupHIN4puJ4ZZEsVbeL
   A==;
X-CSE-ConnectionGUID: xTiJl+40ToyoD//JLpTuow==
X-CSE-MsgGUID: uBXsp4BzSXGIkW9VP2KNdg==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="37453510"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="37453510"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2025 14:35:24 -0800
X-CSE-ConnectionGUID: rMfI8ETNSHKC7lSQHgL91g==
X-CSE-MsgGUID: CZwaHeBSQsqcwwpiLwneyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="142545327"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Jan 2025 14:35:24 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 15 Jan 2025 14:35:23 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Wed, 15 Jan 2025 14:35:23 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 15 Jan 2025 14:35:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yrItmyyMEH7pjVzU2R44kos5iCz0Ttj/fyuy6Iceeem7CROwygdSOgH7fDtFwLWKWbY10UabPSHa3A82AjRZlWzOc3mA4Hv93lP8BKdhKArO7S7O4oq2XED1nFB+S4z33aUPJVqcaEPlHj/3MwW5d1v/opWou9rRBN4Gc+rAA9XhQGBvXavaC2IA1Ak04VBEcDbeUpwMX8Bqi3EmAMl4reHhav3WrgpK6lx580HDpMr6NJ6JKSJfu8JUjWYZxwmws2rck8a4FHYhSYStCCZM0/hxSwt63j54POYGQxeTqX87W8X4jbZjFeqJrvDewgTCxYtmidpfMEQUCS/EuoOuVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=So2Jp9Y3xa2IZw0u02k8sUYbeka4WMu/F62ZL+GM/gY=;
 b=p18pHsnryIL9sVkRWk/Lrr3ozsmOfJDR8RL1EMltUnBneBGV7nvPVUiv745LodaTh1zaaGmZ1unRhZMoz7bm4aGWC241n3BR7JJGY7foKiMbCO7gQTVZuaMFEgngvUihoSge4V7U2w9v8hlxYy6imX9OGzkdC72MXxlMkeA7NNtJZMpH+XMGqw4RaVpZjyWeKCVrmbfRsN4PALRS8DvcXCwUthRfPhK4tCk41jPCB8e121710kPtaVVbL4wDDQFg/cXYFzBRtWr0QSc+hAcdQypOpnYu/lf80uoQxMQsd6vrTY3brwKlcYlJlZQoZFcLPtqcHIVei76LVWDdy8A1Cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SN7PR11MB7042.namprd11.prod.outlook.com (2603:10b6:806:299::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.13; Wed, 15 Jan
 2025 22:34:40 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%5]) with mapi id 15.20.8356.010; Wed, 15 Jan 2025
 22:34:40 +0000
Date: Wed, 15 Jan 2025 14:34:36 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Ira Weiny <ira.weiny@intel.com>, Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, "Jonathan
 Cameron" <Jonathan.Cameron@huawei.com>, Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>, Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>
CC: Dan Williams <dan.j.williams@intel.com>, Davidlohr Bueso
	<dave@stgolabs.net>, Alison Schofield <alison.schofield@intel.com>, "Vishal
 Verma" <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	<linux-cxl@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<linux-hardening@vger.kernel.org>, Li Ming <ming.li@zohomail.com>
Subject: Re: [PATCH v8 02/21] cxl/mem: Read dynamic capacity configuration
 from the device
Message-ID: <678837fcc0ed_20f3294fb@dwillia2-xfh.jf.intel.com.notmuch>
References: <20241210-dcd-type2-upstream-v8-0-812852504400@intel.com>
 <20241210-dcd-type2-upstream-v8-2-812852504400@intel.com>
 <67871f05cd767_20f32947f@dwillia2-xfh.jf.intel.com.notmuch>
 <67881b606ca4e_1aa45f2948b@iweiny-mobl.notmuch>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <67881b606ca4e_1aa45f2948b@iweiny-mobl.notmuch>
X-ClientProxiedBy: MW4PR03CA0032.namprd03.prod.outlook.com
 (2603:10b6:303:8e::7) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SN7PR11MB7042:EE_
X-MS-Office365-Filtering-Correlation-Id: bd871029-48a6-435b-5a30-08dd35b4cce6
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?lSZ6a9YfbF9VkCKRZdvnSl312aNxX5XzJt5y5BFyj7CbzV7T8JmwsjQnjuji?=
 =?us-ascii?Q?DrTLP9zsoy+KmJIKGQLOpMfWN0NLX/i9taCBUU6aunf2P83hczvdK6ELawoZ?=
 =?us-ascii?Q?yWAy5Eo+kpGcdLpMQ5xU/jZX6byHDyJiyb3j9+paPEYC9Zhd6XMY5qUPYUo3?=
 =?us-ascii?Q?eLqplqVR0elaUFBHyQXzW7SDGdholiqXHLZDD7UqJzPOF0LiLBGSKUS+gium?=
 =?us-ascii?Q?Ia0ySlT2EYDYvuyrHMNILO8tzzx8XqACux2fzZTajVuXepuzbvAAREfBl4PC?=
 =?us-ascii?Q?Tk49YkJw9s/cwYVeT3MHbknZ7kXsh797tELmG9ggOGiP/bu9Bjw7CDcLYyGr?=
 =?us-ascii?Q?b3H0ALBNPSIWRRtj7RrO/6/pDoGEDw8487Jby1MVQAK2XYu+g7Ndbg4xcb1g?=
 =?us-ascii?Q?35cRAiaT0FgFajSVJ70Mw0gwptr99WcyGKSlmHiBE+G/jDZ0wyvQdv0WYfqf?=
 =?us-ascii?Q?htkYa2kB+asaQ1B8zQtp6eHIejRc+VXQeCo/jSJGRoQpUvac2peuwnhIGbmw?=
 =?us-ascii?Q?LpI4V+Hnr4qrI+KCgTedGnIkxptf9PVXKJbaL2oCt0wuxvVHMewTqU5vogoU?=
 =?us-ascii?Q?R5M7PSBOzJLPOTPW+apoII0vPCrkomoQmCWE2QuTC2DrflwJdn6BbeFP0PQY?=
 =?us-ascii?Q?2ZRak5RATJQkrK3L+9f8V/LteRqrhk8E9DXcDv1iwMTTfCJ8OuBu9zTxjWTI?=
 =?us-ascii?Q?aHYHNj/uwo7KV4sVdMuOYb5z1VD+wJEEmlmnvXjTKjZQyQrrsc5ou8Irj1Gd?=
 =?us-ascii?Q?RyvAf1ZCy3jdeYiN+8j50AwmsSdk5OFLRex92M0roRbqn74+05O2smZElaYJ?=
 =?us-ascii?Q?hiMMDp7qCWGVNWEyQdxKjFB6LRjDJkg0G5fdWDtj8+I4uhezjg2cZXk94rH1?=
 =?us-ascii?Q?KElHcS4xmwilQz43dak2Dn4wgFMGnsfQbkk6QOaxkBmnBLUNtrxNDyh/7n8W?=
 =?us-ascii?Q?FLUC1c8WG6c+fARc/QlZiXasKrbleJpk+gTfk5Xh7ZAtkovUcY8fWtG2m23R?=
 =?us-ascii?Q?HVsHwNh7ARIT4xQA341+8t9o2srjfmqF7Vv3mPP9kDX2n/hUYjsumpXVjzf0?=
 =?us-ascii?Q?d8TmI3WK49yk476zzahUNyqvQpGlQNK1jzDIzXFIzb2zP8uo0QTI77nScG5o?=
 =?us-ascii?Q?kSt/nmDwNY2XK8ui7VAbt7tN5CTH4EsUoyZblRRqioTi96c6AGBN5bscXtZ0?=
 =?us-ascii?Q?41seZDVhZGDqxaPlETnmOJbXISthIPynCVbzCb7Y0t8d6mQX7ATsP5AzvU/C?=
 =?us-ascii?Q?z3sJ/5detZa+2betGbGJKuikDObvrOii56E1bgzz//V7/6PwvoRUu2QV/u1c?=
 =?us-ascii?Q?wLTTj/rzdso6NctcTM3vkXKzKOgNre4x7Pz3pivtOm2CDeSVjYxRgya28d/Y?=
 =?us-ascii?Q?U/12M4iER9HxMg0jXXEJ8zM3kx17?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AOKs5nm82Iixf6SAFcSkuVfZhmTquAgszgEI59mmKpDyS3Homb4zrX9zNlwR?=
 =?us-ascii?Q?JzJHxX5ptyLKunaovQN1jTv6SSpuWTjTvWhimvJNtU9MqB+2fWQ2cTec3h4g?=
 =?us-ascii?Q?V4pw1l02N2GI/cwtpgFF6AuRwn6In9gtwNtWr/bFP6g+d645t3yqe/REr2Cr?=
 =?us-ascii?Q?yVESYNWhgNyknx/r9ZUEaTHDkqUGH6quq0b++YO/5dGXOM9uZJ9BmdAytJqV?=
 =?us-ascii?Q?/KJ517pI24IDvU69I8R+bZlQbH+LSDU2XClK1vn/5zdGbVR5SjQuTNfgOt5m?=
 =?us-ascii?Q?4d1h7iEG/qtMFO9LKPwUtM5P4QNFQ54PwKyJnTxJhCStRT+qi/f4ECFqntoB?=
 =?us-ascii?Q?yS5YHLVTWnjJnOace28CGc163XuRvZQAYsy9v2FZkrXNtAbRjZr3ZoxZF/h5?=
 =?us-ascii?Q?pybaohJBEC0qVH+AfeuIAPFJuJGZA+G7/rNYtxy17OlOJ6l8ZpMGuGkG2Dcf?=
 =?us-ascii?Q?vEUXD1an7wyLu2jajvaPVZOMTdsPztuP+jE9zmpNhANl6cxfDNZ0n0KiBxiN?=
 =?us-ascii?Q?HNJgessuFBPe2k/CWDaDGJBEcSwi1XTF73DVif/iYrWBzE4bxaGrpdNAYLmT?=
 =?us-ascii?Q?ep2UAuI8o8eGmSfmV/w1drzNhNiol/9FEzWTs1OmwbXm0g+nr2Xz0PCHaHv/?=
 =?us-ascii?Q?TwgWtx+9IhmISpY2QfcO8tZWRu55yi1yPrsJGpfQ+kk3ZzFZ1yL9xUOFeMEQ?=
 =?us-ascii?Q?m9BTrLWO+Teizbj5rqFMGh12mzAH3lmpGq1efhawGO3dPwYUc63QYBPSaVTD?=
 =?us-ascii?Q?IeRMi0Q58cNH7d+RxplI42IGq+JlkT84ycbTtkCpKXDVKuXC/RY4cRyUv3Dd?=
 =?us-ascii?Q?A+FpaLXL/PZ95ZS9rS2eJcBBEC1sVKBAF8KvMi10a/fSG0AwFuHuFUZ5Rc1i?=
 =?us-ascii?Q?A9urfAKgE46i8Md5NxaYHcC97X/0X5ZNgqASlPXcXFhGrSHYyBd7GqYVCwvN?=
 =?us-ascii?Q?+8v7qeTpDicYBvYp/UV9BioinIutXpC7Zi5IdSv+jXRfo93ZTdxj4kNixbxH?=
 =?us-ascii?Q?BidnmvGfXgpbj8lxeenUInTa50Ll1yAyVZRB67yuVoxf+hIif5qFlLQDdXEJ?=
 =?us-ascii?Q?1+Krfh85g+7yTTbnxrpNEPi0uiR7rCNR4nfNJlXVLD5Vi/VinJaSMkkeVZuG?=
 =?us-ascii?Q?gPi+hwKi88OhKJQe0VWkR7CsUXDfB1f4PsEH4xHiXieraqUerNHucqXmH222?=
 =?us-ascii?Q?c6Kus9aDj9rQ0hR7nfaZpgqpp2QBsV2uYC22ZMi6fqU4jjTce/fZaHR47kYi?=
 =?us-ascii?Q?W7Phuuos9o9e9P5IzDBa76HtuQ+Ww4BVHi5CzyR2/UZE75nYe4ligsZ4KoRZ?=
 =?us-ascii?Q?Y+X/Pz1tJODTNFIwmzoKd3reR7h4pKSql09Un9fRzsmYOWqmUVUR2/kwWnuw?=
 =?us-ascii?Q?SHfbPBf4X6D88b6gviXQA0D+lcbHlI3J9fCx5UapR/eaSYT3nmnCoqXGn2Sc?=
 =?us-ascii?Q?Z40YYx0SgRBydq76B5IvGcFI37Hks7J0ffhSe1rc6gmEonsHGZbcZf99Yvn/?=
 =?us-ascii?Q?T5vq1QGaov5R9kFVQoTgWC6Tz+6xOch1yGi/2yJbb/b5195Qan13HoThEsWx?=
 =?us-ascii?Q?wFnJd9iJzHZXg9AW2biLri3E5nNhR82egWVHRUp4PgaCQTR82Kd2VxU/Bnwf?=
 =?us-ascii?Q?ng=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bd871029-48a6-435b-5a30-08dd35b4cce6
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2025 22:34:40.6304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wR2nOpr5p5Wo3zcnlC2bI5zb9oMD4VzooqjpgVBzYK4t0Pf110DwN9Sfr5f9owLQhdKSosYjRAEglbon0RiUKnsoWQwX4g4X8HrKgccgwqU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7042
X-OriginatorOrg: intel.com

Ira Weiny wrote:
> Dan Williams wrote:
> > Ira Weiny wrote:
> 
> [snip]
> 
> > > diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> > > index e8907c403edbd83c8a36b8d013c6bc3391207ee6..05a0718aea73b3b2a02c608bae198eac7c462523 100644
> > > --- a/drivers/cxl/cxlmem.h
> > > +++ b/drivers/cxl/cxlmem.h
> > > @@ -403,6 +403,7 @@ enum cxl_devtype {
> > >  	CXL_DEVTYPE_CLASSMEM,
> > >  };
> > >  
> > > +#define CXL_MAX_DC_REGION 8
> > 
> > Please no, lets not sign up to have the "which cxl 'region' concept are
> > you referring to?" debate in perpetuity. "DPA partition", "DPA
> > resource", "DPA capacity" anything but "region".
> > 
> 
> I'm inclined to agree with Alejandro on this one.  I've walked this
> tightrope quite a bit with this series.  But there are other places where
> we have chosen to change the verbiage from the spec and it has made it
> difficult for new comers to correlate the spec with the code.
> 
> So I like Alejandro's idea of adding "HW" to the name to indicate that we
> are talking about a spec or hardware defined thing.

See below, the only people that could potentially be bothered by the
lack of spec terminology matching are the very same people that are
sophisticated enough to have read the spec to know its a problem.

> 
> That said I am open to changing some names where it is clear it is a
> software structure.  I'll audit the series for that.
> 
> > >  	u64 serial;
> > >  	enum cxl_devtype type;
> > >  	struct cxl_mailbox cxl_mbox;
> > >  };
> > >  
> > > +#define CXL_DC_REGION_STRLEN 8
> > > +struct cxl_dc_region_info {
> > > +	u64 base;
> > > +	u64 decode_len;
> > > +	u64 len;
> > 
> > Duplicating partition information in multiple places, like
> > mds->dc_region[X].base and cxlds->dc_res[X].start, feels like an
> > RFC-quality decision for expediency that needs to reconciled on the way
> > to upstream.
> 
> I think this was done to follow a pattern of the mds being passed around
> rather than creating resources right when partitions are read.
> 
> Furthermore this stands to hold this information in CPU endianess rather
> than holding an array of region info coming from the hardware.

Yes, the ask is translate all of this into common information that lives
at the cxl_dev_state level.

> 
> Let see how other changes fall out before I go hacking this though.
> 
> > 
> > > +	u64 blk_size;
> > > +	u32 dsmad_handle;
> > > +	u8 flags;
> > > +	u8 name[CXL_DC_REGION_STRLEN];
> > 
> > No, lets not entertain:
> > 
> >     printk("%s\n", mds->dc_region[index].name);
> > 
> > ...when:
> > 
> >     printk("dc%d\n", index);
> > 
> > ...will do.
> 
> Actually these buffers provide a buffer for the (struct
> resource)dc_res[x].name pointers to point to.

I missed that specific detail, but I still challenge whether this
precision is needed especially since it makes the data structure
messier. Given these names are for debug only and multi-partition DCD
devices seem unlikely to ever exist, just use a static shared name for
adding to ->dpa_res.

> 
> > 
> > DCD introduces the concept of "decode size vs usable capacity" into the
> > partition information, but I see no reason to conceptually tie that to
> > only DCD.  Fabio's memory hole patches show that there is already a
> > memory-hole concept in the CXL arena. DCD is just saying "be prepared for
> > the concept of DPA partitions with memory holes at the end".
> 
> I'm not clear how this relates.  ram and pmem partitions can already have
> holes at the end if not mapped.

The distinction is "can this DPA capacity be allocated to a region" the
new holes introduced by DCD are cases where the partition size is
greater than the allocatable size. Contrast to ram and pmem the
allocatable size is always identical to the partition size.

> > > +
> > >  	struct cxl_event_state event;
> > >  	struct cxl_poison_state poison;
> > >  	struct cxl_security_state security;
> > > @@ -708,6 +732,32 @@ struct cxl_mbox_set_partition_info {
> > >  
> > >  #define  CXL_SET_PARTITION_IMMEDIATE_FLAG	BIT(0)
> > >  
> > > +/* See CXL 3.1 Table 8-163 get dynamic capacity config Input Payload */
> > > +struct cxl_mbox_get_dc_config_in {
> > > +	u8 region_count;
> > > +	u8 start_region_index;
> > > +} __packed;
> > > +
> > > +/* See CXL 3.1 Table 8-164 get dynamic capacity config Output Payload */
> > > +struct cxl_mbox_get_dc_config_out {
> > > +	u8 avail_region_count;
> > > +	u8 regions_returned;
> > > +	u8 rsvd[6];
> > > +	/* See CXL 3.1 Table 8-165 */
> > > +	struct cxl_dc_region_config {
> > > +		__le64 region_base;
> > > +		__le64 region_decode_length;
> > > +		__le64 region_length;
> > > +		__le64 region_block_size;
> > > +		__le32 region_dsmad_handle;
> > > +		u8 flags;
> > > +		u8 rsvd[3];
> > > +	} __packed region[] __counted_by(regions_returned);
> > 
> > Yes, the spec unfortunately uses "region" for this partition info
> > payload. This would be a good place to say "CXL spec calls this 'region'
> > but Linux calls it 'partition' not to be confused with the Linux 'struct
> > cxl_region' or all the other usages of 'region' in the specification".
> 
> In this case I totally disagree.  This is a structure being filled in by
> the hardware and is directly related to the spec.  I think I would rather
> change 
> 
> s/cxl_dc_region_info/cxl_dc_partition_info/
> 
> And leave this.  Which draws a more distinct line between what is
> specified in hardware vs a software construct.
> 
> > 
> > Linux is not obligated to follow the questionable naming decisions of
> > specifications.
> 
> We are not.  But as Alejandro says it can be confusing if we don't make
> some association to the spec.
> 
> What do you think about the HW/SW line I propose above?

Rename to cxl_dc_partition_info and drop the region_ prefixes, sure.

Otherwise, for this init-time only concern I would much rather deal with
the confusion of:

"why does Linux call this partition when the spec calls it region?":
which only trips up people that already know the difference because they read the
spec. In that case the comment will answer their confusion.

...versus:

"why are there multiple region concepts in the CXL subsystem": which
trips up everyone that greps through the CXL subsystem especially those
that have no intention of ever reading the spec.
