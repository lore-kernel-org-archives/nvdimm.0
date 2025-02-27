Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B3A2356AD
	for <nvdimm@lists.linux.dev>; Thu, 27 Feb 2025 15:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740670052; cv=fail; b=E53FPiaMgEV6vDcCYpjAcdLpwqH/BRQpF013NqH6DkreNEbwmuHtB2RCdXSDsSrj33ANUqzKUZQS53+DLeXfXOtMCTf9uPGyIHSN8QL9cMNMsd8WKYQ1lJSFjH6H1xoVkU4Q0DPH0kWULAHOdwD8HN1mrCyeaQ7QIpKATodEzOk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740670052; c=relaxed/simple;
	bh=O8Lh8YfrzNdkDAqdoRA7jj/0D6idkbPBdA8azMeX0U8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=avkmj67lpoQkVH6K29fQDV3eWW5VE4j6WJICTF8pb9tmpwUmRUHDmqKi+Y8W86ygy3IYq4Arow9P64gtzYLTVjz6UNyi/6EXzYSSCQ39irLDG9tNBh8QIIB2U2wQbtX4nK3Wjd2fEebi73EKc+KicnpNGziuoEYH1l5Ikk3KcKE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CwDeilr0; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CwDeilr0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740670051; x=1772206051;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=O8Lh8YfrzNdkDAqdoRA7jj/0D6idkbPBdA8azMeX0U8=;
  b=CwDeilr04WQTYle0wHx1MWdlWeICXTpkY8hBxRlC3uPbLeDqdrC4//2y
   p1JllWUZm4vfRC35yLPWB20/df9MtoC70CCF19XRWD2eOpiSeQ3mQzp/u
   LEHuOyKsDxqoOjsDdEvI15GOfOYWcnF5w9ZMsBEs8+4lWIixh+AHPbZZp
   7mlx4ltAqA63+B2gGCFyborR1CXEc8bD+s2o9ndb4DNNwp4mNVt7Fu5Hu
   zgSHn3qXp3cqeYNdboN0m3VlTX2iNd2S2jBWh7+NsVTs26/TK6tSfsmn6
   Tugp3y0AmpJP63t6PoOkdqLS1rCMA0JyHYTofNnlh5ob2HjOpnYQ/fZbC
   Q==;
X-CSE-ConnectionGUID: 1h6e6P23Qam0vH6rKVLe3w==
X-CSE-MsgGUID: g7smjuyJRcGBVK1Y8tJ43A==
X-IronPort-AV: E=McAfee;i="6700,10204,11358"; a="44389424"
X-IronPort-AV: E=Sophos;i="6.13,320,1732608000"; 
   d="scan'208";a="44389424"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2025 07:27:30 -0800
X-CSE-ConnectionGUID: Hwmsy9AXTIK02chU/L4Qog==
X-CSE-MsgGUID: 3lC0WiwxRAGMxTGHG4TtYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="117975640"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2025 07:27:30 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 27 Feb 2025 07:27:29 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 27 Feb 2025 07:27:29 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 27 Feb 2025 07:27:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D2qNFL5OVJaRTvU9fYqjWT8Nw3GPS8UqtBH6H46NyZ0G7G+BBxsmThnwNKk/kSCrBc1oFVx8BoV/6MK6ChvAoGT3qvEwUwu53W1nTGFGACbitjspQECFQblCl3nKIIUXvi1mLNgqhere0N/f0rQZIKiDasJ3vRDLGZofgXLqHdYi0UDnO5a/PNjxDgipJ6+OyKclv1+kS0FApuJFdHYObTpEgBvCcwPMI4ld1yzK3JVAG4kDuo5KwK5zQ6rlZ3M413ssXIDXt422IeWMZ56Lk9Gj9msBNYgGewovAut2VlUUq+YxoWW8ei3ielcnS1bp2IhYYcx7vkmvJppLDDIJXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cs/cS8rmnKu8m2GCEIPkM/+RIxav5wW2kn8xnhWoVJI=;
 b=eFX1AK144dEcjif3LX1oMGvvorNKMf3vT3woxgIsvxRwzLgqmI+3465NKgM2d67TM4t3vZtWCnWko+lgKZAXfGieaBaYE8AvdKjyldr5YZzTCB36YlBjO0d3Luyy1pCEvwA++f964whaxRvnNYBuTXYsypsZ9VDNT8pWGfJSNPOkuSY9SKhSVPhOqczh05PiUPLcU3T+RFTZ++JzbOz26CaTOwD5sK0Mo/WTvtyJjve4I8oKZiTrU0/BU7VY+mdISdk3t2BxRmnhsqEE96DTi+FGXfi1MPUkgcY3yEHpvHnGEAdr/oHQvQneQzZsTl+eP0frMEYQ3s4c/qdgba1CCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by SJ0PR11MB8294.namprd11.prod.outlook.com (2603:10b6:a03:478::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Thu, 27 Feb
 2025 15:27:11 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%5]) with mapi id 15.20.8489.018; Thu, 27 Feb 2025
 15:27:11 +0000
Date: Thu, 27 Feb 2025 09:27:11 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Zheng Qixing <zhengqixing@huaweicloud.com>, <axboe@kernel.dk>,
	<song@kernel.org>, <yukuai3@huawei.com>, <dan.j.williams@intel.com>,
	<vishal.l.verma@intel.com>, <dave.jiang@intel.com>, <ira.weiny@intel.com>,
	<dlemoal@kernel.org>, <kch@nvidia.com>, <yanjun.zhu@linux.dev>,
	<hare@suse.de>, <zhengqixing@huawei.com>, <colyli@kernel.org>,
	<geliang@kernel.org>, <xni@redhat.com>
CC: <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-raid@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<yi.zhang@huawei.com>, <yangerkun@huawei.com>
Subject: Re: [PATCH V2 12/12] badblocks: use sector_t instead of int to avoid
 truncation of badblocks length
Message-ID: <67c0844fe82af_b2959294d1@iweiny-mobl.notmuch>
References: <20250227075507.151331-1-zhengqixing@huaweicloud.com>
 <20250227075507.151331-13-zhengqixing@huaweicloud.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250227075507.151331-13-zhengqixing@huaweicloud.com>
X-ClientProxiedBy: MW4PR03CA0167.namprd03.prod.outlook.com
 (2603:10b6:303:8d::22) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|SJ0PR11MB8294:EE_
X-MS-Office365-Filtering-Correlation-Id: 601f93dc-9142-4528-b7aa-08dd5743344b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?RywKiuVifAVNnjRjJAa5Lj2SYbliRvC7jicL/KpIuT5XVNgfZHhQ0Mvnme32?=
 =?us-ascii?Q?ZRBgRf1dwpWxI4nbOh8h16lvquB2V+l5hJ56WoXjY0lS88bxyC7FeX8Xgb16?=
 =?us-ascii?Q?mmFqEX3xNGh6DsJSof4XP3u3Uz3KX3QXUWN1Weg2r6j5uRMluwtpJySiF3o7?=
 =?us-ascii?Q?IAkhilZvJl7Az0En5qqQuOSTmNYNCKxobgOXWV5q2U23j52uZHNaWEOcRFcq?=
 =?us-ascii?Q?hJFFgHYtRSItTZ/uunRQcshu2Q8MDhG/hMqj/Hiss6pzrBwZrUFpMMJi0O22?=
 =?us-ascii?Q?gxo3Srti2q3kw7WYIgS8h4lwTa7lr3tobgUbqNHlSEmIyIrHH0WD20WFSoxN?=
 =?us-ascii?Q?8s2ld1paMCy2zyqepDvCIrFSCXWl29MvsQ3hqQnDNXn0JztGQBzxAyC9rsq8?=
 =?us-ascii?Q?JZKp5hCOH2E4tLkX/xi5GBZATLciHbVy30EHOHR3EwpG0gm+KvsrTKNLy4fL?=
 =?us-ascii?Q?vKi0I/W30YxmmdPXub4hjC4YY0UCTL4UiqgyopxLg4Bv7vBK/YEMSOO6SDqI?=
 =?us-ascii?Q?QVxhFpD9g/BcFkcipu5N+FZthhUG+l/PfelAg0avvNu7P0XnICfVQaTvIrXb?=
 =?us-ascii?Q?Q7C2oOA3bOSTnEYKqv6YsBLPzNMz1fpX4DA/bWDUGAu/BqeNXqIJN/Wm9t9R?=
 =?us-ascii?Q?wHlqSL+IkupdFKN7eG/LvnnpBr2Jm4oZLekfEl2I3/JKCRa6WLo79Qhw8qqj?=
 =?us-ascii?Q?2m0EDAuUoe9xHC2Fz7rspWukQ+STdniidtg7caUBonISKRrcnk/4sWQuAl76?=
 =?us-ascii?Q?WEBIhK1oRt8E1nBzBHIzRnVqq64mu1aAq6RP1EqT33LQt/gFMksKVsoLobiF?=
 =?us-ascii?Q?CGOdnargpNArqvetXz/8RmDWd38+JMFP27qpIbobGx7uRuCQ+fnYwfhBQeN2?=
 =?us-ascii?Q?LzOMDBdlQtuPHeilQdGVZBKB3y2pVMNV2kwZuU9/b1wovTMg/DL9FbJpAqIt?=
 =?us-ascii?Q?Hg45owz7zJEAv3xTIPBe1f3hcxpBLyGrTsotkaxe78nG4pXaZpYSR3Lgghyz?=
 =?us-ascii?Q?VBsfASmAUso7uDRdpu5OPMxzXoTHCgMXqk5pXQ/WXXzn0bxJtPPXJNhsv63m?=
 =?us-ascii?Q?lesdL+ILyb9MUNKhdrDD0c4CdZnYpIvyeXgAJrmpb9fWnBauXiw2SMESHaHx?=
 =?us-ascii?Q?ZVy9HcpE/8EB6qU+G5+mo16Y/JtXefAQXUPD93IrSaEWWk/XQ/YZ4ZhoBpc1?=
 =?us-ascii?Q?ut6y9Puzdj/Ite+hSiuXkLCfu4xs5IMGbdNXZBxmnsGq5jpEWcaO+YnxfAM9?=
 =?us-ascii?Q?CGCzgL4q0o7w1IZYlhGsMCy8/TFD35PN1L2XvUiFXjSinhBVCQx83NfLMA3l?=
 =?us-ascii?Q?naSn9fCYFO6VUhrArqXxcnA7QSciYvEQpxMg5/fcd7cvUKocEQQRhT8WjdlU?=
 =?us-ascii?Q?zRR8UdsRUt6vwwlBETioRH2sxCLWqKcd8kQ9TVu54vL7s+QCpBO6lEkaFaeC?=
 =?us-ascii?Q?3hbwpnMFl28=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RnyzGCHIHASJR788HnQuBusnpALdGwuu29r/uriNFoP76s363fzznGFXSHgb?=
 =?us-ascii?Q?dNt0Gwm5NRXfNpi/zew35FEqjccdiRaqoXQBF1ZjIt42kYqik92VRPPdu83X?=
 =?us-ascii?Q?gIusXKBLLRsQTvOJmKwhfaA2Hwj8DrgvtSuIcEUk2VuH8DZlMXDrntLlDQnG?=
 =?us-ascii?Q?MtNai/rGN4yhydaPo8ma8GSfOXXywnboL2ljR4YaxRktWQCkxMJSLMJxZkCj?=
 =?us-ascii?Q?PEZAJcYk/nhEeNSzm3LUNTJO1/TM9mSrb4hG6yu+1x8CleO3UB0Sy52GiCmw?=
 =?us-ascii?Q?oQWeF/KYg4pDLU0bUjxmg+xFtfv6fV6OcAfyOLo1PT/0BbBb68WJ7OGks5vM?=
 =?us-ascii?Q?/341dlpVbjXk7w3S+74wmSLGFCR8fZx9koPZL2FqmFPPKX1d9CsfJRDhgclr?=
 =?us-ascii?Q?H2w0j64V52l3NILJv6HJj6yUvq7XLIBwlORNwaFtpK9OHLDE3O0fw+1m0yIF?=
 =?us-ascii?Q?9RWuXFUKlyhm9UAqUgZ17Hw2sbgo6zV3mZsapB2ZSFBJ4P/OhY/hqvObGM0G?=
 =?us-ascii?Q?jp1L5mF5sFevEjBBedvKAqtE9DYbRM5huYbPTXHKaXfQRWmE32r3W/X8iFWy?=
 =?us-ascii?Q?7OLnB9c9odNYmxJGAJEUJXwnNn9QBxaJXGpkTaa3EeqTIcjbXYmEqoInda6O?=
 =?us-ascii?Q?HAeJY/iKupMx+Jm7Rknm0QM9SEKeHYtLJbFgc0A9rZTRROQDxuuUQVqien0B?=
 =?us-ascii?Q?6Sf3nEbgyfBm9h/9Fcjem/wrf3U5CN3aiK19GNnXtAn6kTfNgmJDn1ERpTN5?=
 =?us-ascii?Q?FIpdX6rAJ/qLF2VfzhmmNZyU5zBHF7f8Hyu8gSjxZKE8BU1aEqai4xzYxLF6?=
 =?us-ascii?Q?vhIt0xCVqXML9o5IpfnQi5zQmYAYoAcRCwU8Te6yvTtvfaqNfEvZ01drmGWc?=
 =?us-ascii?Q?CVCb9HQ+cl2g1z2aq/kKtkEpn+EITv0f/5E0Tm5F09Bmp2zcVzJDlAOy6MMa?=
 =?us-ascii?Q?QwigNgvwwgxeaZH5FDsP9osiWdmD7AeSh6iCMnAc/KclcFooVVVpbd4WNT+Z?=
 =?us-ascii?Q?Pl+a+ftVWRaLy5TFWRa23DsxQz6Fv58tHeAsVxUEIwoZ/eE2Kh/kC+5LWaqS?=
 =?us-ascii?Q?LIAvygJfVnUrscf5ixSlZ9tfHSBpqXQpxOEq8+xWrPqO2O21JjWHjGpjzAVo?=
 =?us-ascii?Q?QAfQOPR7r0tUcRU2XHGZBCbYR9q8NPZ7h9TUHBLq6WOlR7sbIcNJAOFTPBYu?=
 =?us-ascii?Q?XehuLyQ7t1crZO0SA8ObXZH7Z+ZnKA57LBO6PTeHlLtnAkbPTHUC0aGMAe1W?=
 =?us-ascii?Q?9f0dq2DX1R1clPSU/k5oTaq6U8xMN8N8RWTQfDNOnRUPfhOYU+xgmvKfi0ur?=
 =?us-ascii?Q?gLZUfjRvRPCIWWdWI+ZVY4JlmhVNjDwVEGO1NSRyRTTxKEealNYvVzeeNIwP?=
 =?us-ascii?Q?qicgQKMBtoyJEPgWh9PaKYxeK3vfb/xIZpBW5gT871/qIGkQOhJf5vek/KB9?=
 =?us-ascii?Q?nd5GvuMkDd0q84/hgmyiIeGw7f6AQfhpiYvEDDqx48JgoYgfb6Gj6lEKj7hC?=
 =?us-ascii?Q?m9oeaocCK5TMZFocd0App702IaK+eNiETMqbNrFjWPAUaqddF+nWzrApJnUV?=
 =?us-ascii?Q?g71IZLwFsUj0782xHB++KAJMW9DloWfYkHwtfCTI?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 601f93dc-9142-4528-b7aa-08dd5743344b
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2025 15:27:11.0044
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r7goKSYNRKN97O4mebCxSo7abjm0nYiXix7ufreGwrmh8yqbnEi8pLSiIpytnb2obnyI4cH7jBRHtPP3eao7Iw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB8294
X-OriginatorOrg: intel.com

Zheng Qixing wrote:
> From: Zheng Qixing <zhengqixing@huawei.com>
> 
> There is a truncation of badblocks length issue when set badblocks as
> follow:
> 
> echo "2055 4294967299" > bad_blocks
> cat bad_blocks
> 2055 3
> 
> Change 'sectors' argument type from 'int' to 'sector_t'.
> 
> This change avoids truncation of badblocks length for large sectors by
> replacing 'int' with 'sector_t' (u64), enabling proper handling of larger
> disk sizes and ensuring compatibility with 64-bit sector addressing.

__add_badblock_range() in drivers/nvdimm/badrange.c limits the number of
badblocks which can be set in each call to badblocks_set().

After this change can that algorithm be eliminated?  I'm not familiar with
the badblocks code to know for certain.

Regardless I think the types used in badrange.c could be updated with this
change.

Also pmem_clear_bb() should have it's type changed to match
badblocks_clear()

Ira

[snip]
