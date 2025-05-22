Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84DB82AD18
	for <nvdimm@lists.linux.dev>; Thu, 22 May 2025 04:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747889255; cv=fail; b=L1nTBNcw6pnYHwpgw+TXUxaD937Ckaky/bOau+B3CJDtcEvyrPSAK4buvj3P/++1qScn9nuLe+ptyowc9P6DBR2PQ7nNoKBOOYqfbgwuXwKdLGASYPr4LSQXctGaWNwsqoT6UxD0m8lIRKr4JyshT0rIlc8RVuh1kiHW9BLznnA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747889255; c=relaxed/simple;
	bh=IEhWIyRm8cul/ZtzBvxoG21iiatM3KEvCu8EhCd1+4Q=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=TDnmUHHN9AcZq/LfGRAw21FL/V6o/R9yNnT3CcMYA5gfmZ7SFyT3p7bp+hOW7sHD+u1o0c0pTf12XZwrLBh3p+/I2TPsFlxVKr1BDs+0aipN3Xw5t/1vW9oF2P1rjVWuNj58LLF0HPf0bPagzkBJsC+ieuXpqnujs/0URNAVCgA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Jo7Ou8pl; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Jo7Ou8pl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747889253; x=1779425253;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=IEhWIyRm8cul/ZtzBvxoG21iiatM3KEvCu8EhCd1+4Q=;
  b=Jo7Ou8plUJfOrYHpUD1wtMShDFBx1vDXYQe7VLK9DowR3PDTbaIbfHXb
   C26GjUyeq/MlAcNcvkD7iSsbe0WnortqCnpzrr7ENduGu+yeENMsgLI2h
   r6Qm4158z4ySzTnhUtCdvvBVsIGw3kNmx2j6t5w75T6tgqhlQSXByTqEl
   8McVB7ASLLN2uU41ZCgZUzG6Rtm5IDpmJeQxGUgmUNtwQN3w6b/uU346N
   rXIBaG7v5nVkORx7I9ulrkGD2sA3ZbnLgLoTd+Mnp21UFzhrtEu49/Wnc
   KoBHdvsV140o1cZ0vOYgNrqUkk8bMV+uQYNBE0nY7cLc7xL57lx42dhkF
   A==;
X-CSE-ConnectionGUID: upbCidiLQA2OjrhQyZPBEQ==
X-CSE-MsgGUID: LS9WfA5eREy5p3PQnuiyPg==
X-IronPort-AV: E=McAfee;i="6700,10204,11440"; a="52520958"
X-IronPort-AV: E=Sophos;i="6.15,305,1739865600"; 
   d="scan'208";a="52520958"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 21:47:33 -0700
X-CSE-ConnectionGUID: PDpBzU4DQGq3uC2xwUfqAg==
X-CSE-MsgGUID: n/eaUrNDQpm5f+S7cWJGwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,305,1739865600"; 
   d="scan'208";a="141330446"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 21:47:33 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 21 May 2025 21:47:32 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 21 May 2025 21:47:32 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Wed, 21 May 2025 21:47:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CR9AEEGxLNnNsP2CfwdoWZGKdnAzRPEnxZW6O9EJnDFWaTyG9gX1vM61vCnj9TmAsrL3he8MR1YbHWJ0lNQSlwDJeQixwrpnxshl+tik+T0UfSjyJmoIKavx8c09G3QNDTtIZ0sVmk7tDfkvn90XPhsFwvW1mnvtWqx5886U6OVeXxD8SnfzfHbV/10z+JaQ7C0x5haOmkBdyWcqKn83L6iVxKpMjZoMvKGLBFCNRaOdFtH0anrOaLyYgAofyl7v4IhMV/N7fCtlFBCgAXOb5tTrRxAep0bvAJx7rRjk4tnnpaNNzJvkxks5YpuDL9yiM89hWRMd9JvjOeYb2Q+kgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=euspgiGNdI36ENjnvH0S0G9ZPxexgC1LAemNyoIR5ik=;
 b=mQaqUYet51hBqgYodc3ZaCb8BBrZ8dA/Ywqb6J+1g4Hl9Eht32hz8ZRCo1eX3dnRFf+6m4vVYRkwznEOshRYrOSKTroG3cGRbnhbOXKDY2pJwTBHq70MsKyqNoEqVan0+BPtLdI7WgDZBlJUKUNaGhMRVAVmcqCNGFX7WKvFCxIUZIIk+3CjHCGq+WkWqc7jUy9oPr4uKE33Z+5NRhblzaj9mnUtTVmzgGH/va+ND7rtIY+E/qpMHNhVJW41px5a68ps1tCbgXSZx2KeJDY0inpBCNDddbw4sICp24GtIihWrKnzbLwSgnUG8VZ9+24zBKXl+W5S+OoUA2d6KhNtxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB8794.namprd11.prod.outlook.com (2603:10b6:806:46a::5)
 by BL4PR11MB8797.namprd11.prod.outlook.com (2603:10b6:208:5a7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Thu, 22 May
 2025 04:47:29 +0000
Received: from SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720]) by SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720%5]) with mapi id 15.20.8746.030; Thu, 22 May 2025
 04:47:29 +0000
Date: Wed, 21 May 2025 21:47:18 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: <marc.herbert@linux.intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dan.j.williams@intel.com>
Subject: Re: [ndctl PATCH 1/2] README.md: add CONFIG_s missing to pass NFIT
 tests
Message-ID: <aC6sVpma71y4jH7S@aschofie-mobl2.lan>
References: <20250521002640.1700283-1-marc.herbert@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250521002640.1700283-1-marc.herbert@linux.intel.com>
X-ClientProxiedBy: SJ0PR05CA0017.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::22) To SA1PR11MB8794.namprd11.prod.outlook.com
 (2603:10b6:806:46a::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB8794:EE_|BL4PR11MB8797:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a435781-a836-40a2-2ece-08dd98ebc1ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?QvBrYMFOGWtQ2Rdw2Td7aKW6+CuyH5GelYVEStmKAtIbDL0+HSAxfKmwLTqH?=
 =?us-ascii?Q?rhR0lsgzPyz4YoRhxeI9rZ2RxjYjQTE7YucS3lLRV5hJxMjQkO5r8jcRJBQi?=
 =?us-ascii?Q?ibfmQF3UehwQLZWS1SoF6SRpltw/yUnxiZSnvg1as7s/QW20wtbihxQxTkV+?=
 =?us-ascii?Q?I5kADN6GxZ47QuH7vQ4eA1poeIaR9/LApB+2CEXs8oKEaleTDDWkMDAhjvq3?=
 =?us-ascii?Q?Z4vltWE3nu+IbeRxDlDbAMWXtWMsYMT80g++kasJOeHHmftcf2cN6O1ckJf7?=
 =?us-ascii?Q?P7mF9wBNRWVzoppPaAFHGr7h8yjNtDaV3o7t5sghl9BUu/L/y7zJlrIj7LhM?=
 =?us-ascii?Q?DkyTM4StgtT+pzLOII1rqZwYU2lHn6EtpNz609hHM3PAskjfkuw3Vzcdgd1b?=
 =?us-ascii?Q?lehW6F/UF+6zM2jkdrNX52cHAItsDONhwCHfo1cOyx47gNfrtePyjQ7/wHtq?=
 =?us-ascii?Q?AcoBSwb4A+/rDMhP2VCg2meiKZ0udVSv4BOD8tdbiKVWNW+uZedN/NzSSqmx?=
 =?us-ascii?Q?IRja3RTTE/4WIa+7oUPmNdnQAt700qgh9MdY2Ac/9fTfurWG8ddoS/B78lcM?=
 =?us-ascii?Q?Abw0wplkNMhNpCgpTmqskV5cBLIzNc9YM0nnvSNK42q7nW/NEMcZNWFd1fBY?=
 =?us-ascii?Q?8CjKNgxClSRDU+kObEROB6oYV47bVwv6yxI9GphUvjSuNklxaP4EYMoH4U/x?=
 =?us-ascii?Q?QW7qMhTzhO4V+xK5298djm4E/VKAHr9osSdwyitSyvTTPbjtke6ZvcfBYmL2?=
 =?us-ascii?Q?B3jM9hRjlQzpB4yBavFdJzC7tlz4xxAlFuElrB+/McwB9rlRHxjwaqX8H4I8?=
 =?us-ascii?Q?GJKzqjoV+kG/R0/wNDsn6MKUXnhsaX/6aXI/5Rf1IKphDBArYHbBG1dzgn2z?=
 =?us-ascii?Q?9hIr17w9BvCmruZ8OiLCK2Hd2/kcGp3a7GMQQ2TuZzK9c4NdpO6XslO8LoSV?=
 =?us-ascii?Q?GMxQD4G3uanQFydGEuAOQQS48KttnSV15/tIROZhIMaot3mTUdbLHLuvlRAK?=
 =?us-ascii?Q?AePf9bH/u+q4QEO+aNPwwWZwawwhirapHgZDlIjg6cxog9lcWFF0p8GNDGm8?=
 =?us-ascii?Q?V1S/jtHS8hhSeUXSmo1sfpSDBSPcwFIx0ccaT7lLCoPYqFwrfSfBchLiWvY+?=
 =?us-ascii?Q?W/l8ehtJRPImb7FG440QShbyDa8h+AXAXncfXRu28Jwr4aelEyYwyfssAFK3?=
 =?us-ascii?Q?YJXEOlrjWb9B7X28s1PprLrn0y9dqtayeERbeHOG8u248fUnsZVEqRKn6Puy?=
 =?us-ascii?Q?vBXmT+VC3A99YNqUKdbI+d3ADy4OQukiO4N2QeucMzQIL4nbNsj1Osv76dwM?=
 =?us-ascii?Q?o9qtIVK9Ky1ijaHp0YNZhCgt5FIED2A32unCCyoupFVxCMwqK+/MgGXy4gaW?=
 =?us-ascii?Q?VB0P5qZz2MCiF2esuuChAKRMuVQBnw1cYKg+sKR+9exkBwouKuYFiOI/+FOb?=
 =?us-ascii?Q?MdRePTmvwQc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB8794.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mCT5fRzG+Oo27XLRqcoQYDejBVpxUS8tUNPQdGA2w6cth/VJY+sTcOMla4jj?=
 =?us-ascii?Q?HqQnjV13BdMUuLlkSl4/zC2qWN5gmxLtclrAev2zj9bRYNEIpdCj2Br2QVz8?=
 =?us-ascii?Q?z7hRJzZO8a2Nzya8xm99Shmb4nK+vHIpSYneUDQh5OKiCAGkrRpeF5aIwwOK?=
 =?us-ascii?Q?dKRr7duQ49qCkSpX7u1p0XEZqPCJNEvNOxir8Dc+HdL4COyRLBKfhmxZ3tu6?=
 =?us-ascii?Q?C5yYkesa5nJyK4ESzGM0Hf0ug4YMln/7ekqBcpZb7ZGAOTtH2B8/KxYk7iV1?=
 =?us-ascii?Q?Fb9EVfnrCGFfnHwLkClYCNW0tBzHDY3uYb5GlZagV1cGituGUIAi3BMFlAl3?=
 =?us-ascii?Q?o/7C3tCd9qgJzebE90aYAP7WVoZbdQCkJ4sFhrti/2UFEzQoh6G1v7lnIdQS?=
 =?us-ascii?Q?u5B0S6XCck9MxyNPwDGgbD/T9GRbGV3GdOT3rTlqYoX3V7mlyXZNb/DBtNgi?=
 =?us-ascii?Q?HptTa+NZc9OvCBSQ3/ND2fCuhJ3mgLZqSZw3P2duV57Mnmn4RNPstopyx1zo?=
 =?us-ascii?Q?ndCisLyE3aQiRbeHcZ61cGJux8cx36qpIUUABV8dY5/SZ2m8KGpv/UPec7Hr?=
 =?us-ascii?Q?rJAPSmgEoSU/EJuD0d+fLNs7fm5vLHyQu3VAeeXI4zFl7fzxYLNCdpVqFxfo?=
 =?us-ascii?Q?WcDJq49cHCejGLwx1lf1n2/OCxLA+U+ilgtxRRAEDoMjX3pEZhoxDsWXCKbg?=
 =?us-ascii?Q?e7jsr+EebcZA8/tZfvxxzzbBvMHxmXelI3yNSqQ0ip1hmE1WjhYAL5fpqikD?=
 =?us-ascii?Q?Q18taFzqh9ppM8Bpp1UbZf9MI97yERMNjkG2ZC/MyGsIx84qIcZhIDoz/uo0?=
 =?us-ascii?Q?lfWSAyF0ZKhW5gKyFPXYPnbdhToUiVKOLFtYndOWo5tTNYPaFFKGaS5aE7Cq?=
 =?us-ascii?Q?Mg0X44rxOGoRl4U4tjVCkexRPKjgfWfWgageJqR9Uwhwrymkkvlberj5MyQn?=
 =?us-ascii?Q?lh73qArC50tMM9KptpKNKjBYyoy9ocyu5uTaGHGuq+YqONf5MZnkjEIgkYhQ?=
 =?us-ascii?Q?Rx9GbL6AOnPR3wuVWCXKSeZwDoft9l48it+fZHT0hKiyJM/Jj+smGa9gHpc+?=
 =?us-ascii?Q?PzXjnXwfwy3OPm5TQAnltGgSbjPeit625M33IxlX0sLHG8g2Q/yYp/K9niqm?=
 =?us-ascii?Q?rvHBEQG5vPkqeKzciEkueE00p2TFlW1MbHeJh1MN5/ZQ5VpKgPeHz/LL6Cya?=
 =?us-ascii?Q?nm/zGZL1Vo0aNMZJyIng5LjbbJpA6Lrm3qQp/+L92UFEh2y1mLEnDyEhJ59H?=
 =?us-ascii?Q?tE3UgDWIAXjRlNTNkAdrMFkx0gQVaAON1lHOMbrGQ5bMdg44jl5Q+xkmS5c+?=
 =?us-ascii?Q?qkRlIebsYsfnbTG0pylle/cBUjhqvqs5UT4PKBq4hcMv4zUdD0DB0inOprSO?=
 =?us-ascii?Q?XZsM2y1I48jPKMO9AnDq0uF78syHsvv94LkakBWA/X6rn2Rc+pV9LhywNDCO?=
 =?us-ascii?Q?n/v9ZaycDarrtFgXgqWM2yeZFl85TgK8v6bddvxOYzeLSjQbbfz+pEXkBN9p?=
 =?us-ascii?Q?CkbuxiLwhifoCgyT6tmvi/1ZSP3bnI+HwBxS5LtZwItNiY2RntAot15ZkrZQ?=
 =?us-ascii?Q?/8LdzuPRRzfyXWuaUCHunnW+3soKLAVq/bxQaoU9ZKmNIHJJl6YuukP6pk8F?=
 =?us-ascii?Q?mQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a435781-a836-40a2-2ece-08dd98ebc1ef
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB8794.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2025 04:47:29.6721
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iU/F2BQ+si9u+V8HTF9Aa60jc9urJy2+G/4piPphfuSu0eDN2obMj2CBYbeJxxWigD9KTj7Gr6yx+L1Bd8mCTkS6PlA/Ph3hKQ7d3NJGTyo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR11MB8797
X-OriginatorOrg: intel.com

On Wed, May 21, 2025 at 12:26:39AM +0000, marc.herbert@linux.intel.com wrote:
> From: Marc Herbert <marc.herbert@linux.intel.com>
> 
> Found by trial and error. As of kernel v6.15, the CONFIG_s in this
> version are enough to give to ./scripts/kconfig/merge_config.sh and pass
> `meson test --suite=ndctl:ndctl` and `meson test --suite=ndctl:dax`
> 
> This has been manually tested with only `make defconfig ARCH=x86_64` as
> a starting point. This is admittedly incomplete test coverage but still
> a massively better starting point for other ARCHs and a big time
> saver. There's a good chance it's enough for other ARCHs too.

Thanks for doing this Marc! 

I'm wondering about the need to delineate between what is needed to load
and use the cxl-test or nfit-test modules as opposed to what is required to
run all the unit tests.

I believe my environment, and yours, and most other folks using these
environments are doing so in a VM so it's no big deal to load up all the
things.

Maybe just a gentle separator in the list showing required and optional.
I would NOT go so far as to pick apart which ones are needed for which
test because that is a slippery slope. If a user is in test running mode
they need all the things.

> 
> Link: https://lore.kernel.org/nvdimm/aed71134-1029-4b88-ab20-8dfa527a7438@linux.intel.com/
> Signed-off-by: Marc Herbert <marc.herbert@linux.intel.com>
> ---
>  README.md | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/README.md b/README.md
> index db25a9114402..a37991ccefa2 100644
> --- a/README.md
> +++ b/README.md
> @@ -69,10 +69,20 @@ loaded.  To build and install nfit_test.ko:
>     CONFIG_NVDIMM_PFN=y
>     CONFIG_NVDIMM_DAX=y
>     CONFIG_DEV_DAX_PMEM=m
> +   CONFIG_FS_DAX=y
> +   CONFIG_XFS_FS=y
> +   CONFIG_DAX=m
> +   CONFIG_DEV_DAX=m
>     CONFIG_ENCRYPTED_KEYS=y
>     CONFIG_NVDIMM_SECURITY_TEST=y
>     CONFIG_STRICT_DEVMEM=y
>     CONFIG_IO_STRICT_DEVMEM=y
> +   CONFIG_ACPI_NFIT=m
> +   CONFIG_NFIT_SECURITY_DEBUG=y
> +   CONFIG_MEMORY_FAILURE=y
> +   CONFIG_MEMORY_HOTPLUG=y
> +   CONFIG_MEMORY_HOTREMOVE=y
> +   CONFIG_TRANSPARENT_HUGEPAGE=y
>     ```
>  
>  1. Build and install the unit test enabled libnvdimm modules in the
> -- 
> 2.49.0
> 
