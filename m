Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72FBB2BDC29
	for <nvdimm@lists.linux.dev>; Fri,  5 Dec 2025 17:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764957505; cv=fail; b=jA2qUv0eOljcdhbAZC3s4sEdeD+UerZj/oKoyqOGrPVFotqX0p3RUMJRe9lQj13rV4ux1hCeAwKkKrSjRHjg2K494rZQQPsjnetublQS7+v3k902onmwxJItU5Qij36b2O7b824A6FF0MiLVMUuppniQA1sEZ4Il3Mw60pL0/ZM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764957505; c=relaxed/simple;
	bh=fPn755B6xxSYh0Wx1h3t9+NGtbU2p9aVMw2OZWBVxu0=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=O8W04ULTpCWxMbZoBn2s8ao5wJPOylV6cgXGWso8a9TO7r+JYn+8u/w21RkCjqBdyv8np+5HjtMuOsKKghnsXQQ+eYk5hhhS6KFWrFwtD8ksfTKg2AgQvuZeshxQyyhesL+Ko4doXpfe8m/3/OcZfp+C2V+jncdFWNBMRiJ1Epk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JLJaqjcR; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JLJaqjcR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764957504; x=1796493504;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=fPn755B6xxSYh0Wx1h3t9+NGtbU2p9aVMw2OZWBVxu0=;
  b=JLJaqjcRxiLzE4655OuK3v/49I1FffIgrgUd0D4MD8+kbo9AmtysGaq9
   kdwOyXWu3UTzaD25gtqk3HKJ+I+BIFGynXHxmBE4nvOFMD8j7drlPw9I0
   NqcUrV06LwtEOOr26GnVlTSB3KOv0Z9Iwrc5uAMSc+TDcz0lkkFtRmcMU
   PEqmJorySY1WOlV1D970UfKEj3l/OnsBn149iv/ZNS5Gr9XI+XkxiX54U
   iiRJPTmBA0K+UxJdPUTPDFVWSNMMRtmLvO3aMvjjhAo5Gwy3l+FjWrH7W
   jcN27xRbmDp63b8ar3LqNSbWBgrg72COtPLAK0Qta9IX3Trdnd++rxeYM
   Q==;
X-CSE-ConnectionGUID: yjPuyoDeQ3WoOVpOmp5B3g==
X-CSE-MsgGUID: kVBcINZpSRqEevwWxhZo9A==
X-IronPort-AV: E=McAfee;i="6800,10657,11633"; a="70843996"
X-IronPort-AV: E=Sophos;i="6.20,252,1758610800"; 
   d="scan'208";a="70843996"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2025 09:58:23 -0800
X-CSE-ConnectionGUID: lAu6BtEVTcmsfwK/olDy7w==
X-CSE-MsgGUID: WAll859xQrOiBZ9AAhuPAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,252,1758610800"; 
   d="scan'208";a="195372779"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2025 09:58:22 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 5 Dec 2025 09:58:21 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Fri, 5 Dec 2025 09:58:21 -0800
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.67)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 5 Dec 2025 09:58:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=empMF/TXF/um8Pcuh+zb6mpyODVEFX5R+mBecAarP7EQMGxJVoot4uVX084e7wls5oE2LerKlqlpu3/G2jTpivWCfPXmbyz74vMartzPmD/mN0+kj/U6G2pPoYnoCylzxog5lLOJ/wL8LYaDibA5ykxdQguDPsWsgO8pFyQMYx12qcqf7sp1rYfuW76l1q/E8eZWFMeO2KGUkkShQ+22nXu2Oj6gIMSMdRT8xYoQ0fRwHL4/eRbsJ6RiwZliqVYa/caCTfFOYSByf1s6bwBtOHDzqVGgdp8SdGa+R51WvTw6IaN5I36Bhlzwk0yavCsDunoLRkidHSHU6pQ8KEufAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RaMRW38DKz6/OkCHMoFaJQAu0EByx+1xdVQWwMWkuic=;
 b=r9YCZDsN89Z6tV6DbLM3W7avs9Z94VzYn1OpAtDXrfiwP7XS0rGUME2hzIiUM9lU8wkIcvXLV8GKQRTM8Xyhuqi3+UWgKqjZ2XUN43Bidek1EdvrCuPenNKdGh4adqbXG/IOtyx+NpwQ/x+Pk1fj7kzejXYS86/JL7Rlo7E+ZE92d/mxJc5iP6pehnSFjNSaNLHWLYVSMUjSDXshLiZIT2Vh6TaGYRGNpHaQWc2NxV1FTGPI4UcZMaoa/Bd8onbGGIrBgyY+nHY11hPw9WT9OJ1Y+f2DUuUGZcDG2dzIMZgZKSAxG+7y1m6DCOA1NCNk4vIor/rZg5zbw04FywT0fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by DM4PR11MB6551.namprd11.prod.outlook.com
 (2603:10b6:8:b9::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.9; Fri, 5 Dec
 2025 17:58:18 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::8289:cecc:ea5b:f0c]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::8289:cecc:ea5b:f0c%8]) with mapi id 15.20.9388.009; Fri, 5 Dec 2025
 17:58:18 +0000
Date: Fri, 5 Dec 2025 12:00:54 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Mike Rapoport <rppt@kernel.org>, Alison Schofield
	<alison.schofield@intel.com>, Tejun Heo <tj@kernel.org>, Marco Crivellari
	<marco.crivellari@suse.com>, Dave Jiang <dave.jiang@intel.com>, Bagas Sanjaya
	<bagasdotme@gmail.com>, Randy Dunlap <rdunlap@infradead.org>, Dan Carpenter
	<dan.carpenter@linaro.org>, Dan Williams <dan.j.williams@intel.com>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] NVDIMM for 6.19
Message-ID: <69331dd6ebdba_50fc7100e3@iweiny-mobl.notmuch>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SJ2PR07CA0017.namprd07.prod.outlook.com
 (2603:10b6:a03:505::17) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|DM4PR11MB6551:EE_
X-MS-Office365-Filtering-Correlation-Id: 7aa91524-a7c8-43a9-e043-08de3427df24
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?ymhXbB4ceefWZoUzzb16u6jnJkIemwvSbMM8k2eVgX8I+r7dlEeGfQn+KFEM?=
 =?us-ascii?Q?2OLkgXmUye3zEVZ0BT20WphsXWFqbYqnPAmJIXnb+iV58WzT3IWzn/2juejk?=
 =?us-ascii?Q?q/6OUHz18+Gy1DvqI15s2eSshHagpWExYRiKflBS7f1fk+uga7KtAkyUkD4x?=
 =?us-ascii?Q?YNdB9NOKj/99r9Wz2SAxU1zwV3Xy880+Iftl3D9N+E7F2+Mhmk0YAN1DH5x7?=
 =?us-ascii?Q?pKpBLl0qyfB4Fw/b7O1ZX7xe/Kvc21Y9a1YlqKbbFEip8vlpfnjEBlGoD5Xl?=
 =?us-ascii?Q?bmdspWPZngv5ozMdGQ3uu3fU2wl8m6YZDrWBlqkEL02YiVVFMAaAEWjKXki6?=
 =?us-ascii?Q?cZ66z4TuQPrbj6Y7mFTTibkXvQr2ynZt4Z2QopityvL97ts3tkVHZie+X8eQ?=
 =?us-ascii?Q?xJAmWBM0//Pa2Kb4Z8I05BUf2ityH9FCcbexC2ACiyuCSdSF6EV2RZUBWgm/?=
 =?us-ascii?Q?e+droKbnzyXX9qdd0NVC5vEc7Fb5lU+RPOfB2zipbLt5lBMD/QM9DvzyW7hP?=
 =?us-ascii?Q?4rAQJyt86Y2rFSx7Bvw+ilcs25cYATW2ZTUl8ss6/DygduIrH5aI2T37Hphe?=
 =?us-ascii?Q?cBWqZFdfPuL7jN7piLCgRGyqlBhv7Q14DljS8esx+oM6ZBaGaDMKLX2yJqaX?=
 =?us-ascii?Q?o8GnFl12+Z5G46dKC5HrSfxMkzUfX6RKK67Oe+xNhge3zqc/XfBLpXSoAtTA?=
 =?us-ascii?Q?0ns1Vbp6zNiTzhDRDhTniVeNsD2AyvQkhzNhTVayMgcQt/GN5GxDOFSL6vca?=
 =?us-ascii?Q?4rsZAdmOYm++NtCMwUswcc+HdBfo/2XVpmFf4geDvxS4fEuafU20/FXj1POA?=
 =?us-ascii?Q?9KlFawLqnEKFcGXT5YUSY7MaRiF/xnERO6Wqr0/RHL09T9hXwUE1Dk+3vVec?=
 =?us-ascii?Q?SSW1EvCFogsG4ezFwQApCfr2NT7635wEokdC3cs9o/lXwYqvpz2+FfJIt7xG?=
 =?us-ascii?Q?euvLXIOloBEGzL3YoZw+Xt6/V3nXRhOEUCi2o+bFSknfmp7cYm0DFsL7PA9b?=
 =?us-ascii?Q?Hw9+2YR0ysMOi/Jpy28GeebF40qufPKwI2Vjn6r5GP4NcJVcsqfXkr5XjNl4?=
 =?us-ascii?Q?zkW3+5x8acaYq38Ym9sLOh1A6D3m5+RBC1jpeqJnoWiHReiy6xeEGvAococc?=
 =?us-ascii?Q?/BnYdHJMmHdQqTOG4nS3ZmJU36WemuuIoV0LF0Bq6s9BqQdy/JCTOn1Kz0Yt?=
 =?us-ascii?Q?qkSS4rGRllEl1FfzM3dlMWbw8UJvvO6LSyOdOo3wM/HJsfiTerBU9WRkjp/m?=
 =?us-ascii?Q?R4YTKDb8puVVBNaS48/U1W9eVSBd7viuNkKmP92kFUI47r2IFtWxfBUa0H+i?=
 =?us-ascii?Q?NawLklB9YvLAB2FFAYDTm/5uB7vIbdpdg7M7980xN5HspyCPmaS94P07Yawi?=
 =?us-ascii?Q?vKc/XxHXLusd8mMzRTTI0uXKKMFTaaHA54q+H/ShlaUtP6jOljkpGKvASOoC?=
 =?us-ascii?Q?h7dphfsNYmvM8030oyDWb54lI26cK81Q?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ql0I9YJSt0dv0CcGn7KuAovDCc8J3NYzdw1QlYSzRBN1dsXdG8ag+xq26gkl?=
 =?us-ascii?Q?S1DmSbaCie/NbrhlNOL6u804tRKguVXA+Xbpdjl01s57rfcldd6IU7MBDR98?=
 =?us-ascii?Q?phGRjXImKnR55NJPX7ieWmHRwYGRxJkthaB8jEVEr/2K8/w/Q3HVpyzpNk5n?=
 =?us-ascii?Q?Y4gIhAipuYrcEjt64YhVGZzHUCEdqb4JyWIB/76amvdnwfvYqcCn0bPXyekg?=
 =?us-ascii?Q?Rv3j6zqma23Mtl4VA661PSu3kvd5o3D3Y1S2EZ57TKV6I0aLXdAk8EzXIERD?=
 =?us-ascii?Q?qbYgj67+1jk2Hqs5LDFR49gtfNrvKyirwXxQylfRWZf44gc6tO2YL6+cxwO9?=
 =?us-ascii?Q?zE/Ad0mjFfTCH6fS2ke8erY+tEh1Z8yRI3vXP9Jrz17qsHOeAbkV7sqV2rsW?=
 =?us-ascii?Q?6lzFtwVfb59mJ0wyVleY5cHOoy+YHLJnCjqjQcVlJia89P55O7ucrjeDd/5g?=
 =?us-ascii?Q?WYL2nOKYghHFhcn85jJ3dIdhvGXOFv8jtCAPZpqBtJmNJxBj+6OP1/sTGp8m?=
 =?us-ascii?Q?wp3btOfR7ZBt+NCpaxv4NA9Sc8KhBDWjqt9i7deYFNRps4CE5usE5d9HfMY3?=
 =?us-ascii?Q?XPHAdI9SFGC6QisMvBS3oHkX/0QFEbXw+PRKd2YNQXXSlDmhyj4WsrVb16Yh?=
 =?us-ascii?Q?rxc017Odbxv6H+dRuinNl0PI4OBwasQJdN9RZOJ8p0uuOl32FVeibtt8R3nI?=
 =?us-ascii?Q?t5UeVMDLIwkhu17HG6WSe5EVyGGtj4Eq/QCsdAd5i8Bqn6Ll+VToXsbSdJ6h?=
 =?us-ascii?Q?Qh0MX7ZnN99RNG4P3+B0QY1HuhcpZB4uYS6pJgWWnNrDq4DvnDdSQujENX2K?=
 =?us-ascii?Q?5yXu1kX4ypo38LKOM77qyI4RSdHXk+7+pteKRwqO0YaQVS5cNsqV6rbs23Wm?=
 =?us-ascii?Q?ddEYq8dcjocFSLqm7w9XKRcdhPtRMryMFKXwotcn3hCvwnAZtNqYIBdNLPTD?=
 =?us-ascii?Q?+Y+IfD5CQc5/qlhyyShEXDGwwF6iJdY5x+nIUtM3TLzVXXoWwBB0YwaBGgyR?=
 =?us-ascii?Q?EcxXbmLH/iEHVSAEFpU3m6z6caZFmdKHr1nkxD1pWXgAWXWK7RCCIu4qyFxJ?=
 =?us-ascii?Q?UT9TaGz7cg/ddJ08RaRMTPO60t//3IsR5rdC7OfAvjuLqnvt1j5L2mQtmS2n?=
 =?us-ascii?Q?DSmUdM0IB5dbhPHDnmq7vLSBKOGJwlcVNHdZnDrUC4EF33asJB3WNAW36ltS?=
 =?us-ascii?Q?dNGUtHufyP4hOf2tEoDglC/evfTRLvvqtoeAz+fQ8wkFffmtvlmQD9qKH4DE?=
 =?us-ascii?Q?E3vWHb01d3veyIEyUL+RQERrEK5Xk2G1doAP+XYkInZxgucVEB3EjbjusuYL?=
 =?us-ascii?Q?MEUKOoZy5v4wrHVLwZ1Qbi1EZXoGxNY90A5dU/QST9UCQdv9ansejC8CZcku?=
 =?us-ascii?Q?W4JmsWaj8MjJSoJ/zUKdB4g52Fes1fgSvYuyM5yl2LFBrTvYE8eDA8JRrACj?=
 =?us-ascii?Q?ITWCR/YwIR0gBLepoJjpTGptxLgtPty+z0qRjAKQQuwAppI+Wu5zF7xvVena?=
 =?us-ascii?Q?Id2NyKIwoT4qtrT+qG3nFXAkAN64TjqGWcPFlct75yqgO3JSev91JGm+mnZU?=
 =?us-ascii?Q?ZXoelJRcsqbKCXTnSiopuJaR79XynaoyqOJxtzOy?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7aa91524-a7c8-43a9-e043-08de3427df24
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2025 17:58:18.6335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OsDYPBqhGTmCE8qDF16bnytDK4cjfvqLJgfehRGKiJ9yShMYN9DYuII56VCRrVjjXsph1ydZ6ofSFNsF541KZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6551
X-OriginatorOrg: intel.com

Linus,

Please pull from...

  git@gitolite.kernel.org:pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-for-6.19

...to get changes for 6.19 for the nvdimm tree.

These are mainly bug fixes and code updates.

There is a new feature to divide up memmap= carve outs and a fix caught in
linux-next for that patch.  Managing memmap memory on the fly for multiple VM's
was proving difficult and Mike provided a driver which allows for the memory to
be better manged.

These have soaked in linux-next without any issues.

Thank you,
Ira Weiny

---
The following changes since commit 6146a0f1dfae5d37442a9ddcba012add260bceb0:

  Linux 6.18-rc4 (2025-11-02 11:28:02 -0800)

are available in the Git repository at:

  git@gitolite.kernel.org:pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-for-6.19

for you to fetch changes up to 30065e73d7c018cf2e1bec68e2d6ffafc17b3c25:

  nvdimm: Prevent integer overflow in ramdax_get_config_data() (2025-11-26 10:58:23 -0600)

----------------------------------------------------------------
NVDIMM changes for 6.19

	* nvdimm: Prevent integer overflow in ramdax_get_config_data()
	* Documentation: btt: Unwrap bit 31-30 nested table
	* nvdimm: replace use of system_wq with system_percpu_wq
	* tools/testing/nvdimm: Use per-DIMM device handle
	* nvdimm: allow exposing RAM carveouts as NVDIMM DIMM devices

----------------------------------------------------------------
Alison Schofield (1):
      tools/testing/nvdimm: Use per-DIMM device handle

Bagas Sanjaya (1):
      Documentation: btt: Unwrap bit 31-30 nested table

Dan Carpenter (1):
      nvdimm: Prevent integer overflow in ramdax_get_config_data()

Marco Crivellari (1):
      nvdimm: replace use of system_wq with system_percpu_wq

Mike Rapoport (Microsoft) (1):
      nvdimm: allow exposing RAM carveouts as NVDIMM DIMM devices

 Documentation/driver-api/nvdimm/btt.rst |   2 +-
 drivers/nvdimm/Kconfig                  |  19 +++
 drivers/nvdimm/Makefile                 |   1 +
 drivers/nvdimm/ramdax.c                 | 282 ++++++++++++++++++++++++++++++++
 drivers/nvdimm/security.c               |   4 +-
 tools/testing/nvdimm/test/nfit.c        |   7 +-
 6 files changed, 311 insertions(+), 4 deletions(-)
 create mode 100644 drivers/nvdimm/ramdax.c
