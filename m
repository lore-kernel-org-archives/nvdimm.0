Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C51287510
	for <nvdimm@lists.linux.dev>; Wed, 24 Sep 2025 21:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758750169; cv=fail; b=pBlPbJSvlfeEZlKU0EbQNmR1HczHbcdxu9afbVych+U/NFoOmtJTBg7Nwz5PX+YZLGWNB+b4aA9nLSHFa2we61qX7O81lDc+w/acQroV1BJAb3ALKTnLeX9E2f4XMBuuDI+nX48p9nNTOZ93pvf3pSp1eh/v2yCSGhJOgmED3w8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758750169; c=relaxed/simple;
	bh=aycBkcp62oz3Ph2/Ta09QjAXEWCkAcPCCbT8gHs3lYg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Y3yBvr/Zm9Dt6QKQ/tQQJM0gpdTpGm4TCLQGboP53ehCkAhh3q0w5iwyR/7TDD0I8pMbTQ1RKXFuE5NSByhTz2EAnieFKKWhoRmvEP4//0EJ1uditQ1wITGW5HxH8gKA7p9IJkm7uuUGl6LWwmF06rVFiQRxmcsogfYrzBjS9MU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Nqfq++Q6; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Nqfq++Q6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758750168; x=1790286168;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=aycBkcp62oz3Ph2/Ta09QjAXEWCkAcPCCbT8gHs3lYg=;
  b=Nqfq++Q6g5KD18EBTyyo97cm0JUg/12IcGBZSax14PJU7bK66vap8CWk
   YnRg8Ld0HLgl099d3L840BQH1WraA2C0PjganSO/cB/EJmhJz+yfWlwxD
   PJrMEs9VG9mKCeljP0hnLnd01e5B5FSnWOZPL42DaMW5Q6ntD0xhpxDoN
   jXCqU86trFQ98gfCQ1M+U7X4+XrDPcQ8LnYGfFc+BkVmubPN6U2hQc9Ql
   OR/rrGEstvh1wUz2UD6hMd6WFD5I8tzL88Pn+EldUItyGMK/Qy8tcDPfB
   i7YuyT546bjGzbxlgUAw+BXxjVs2xhaEVXFDvybx6RLD8KhRdI4k5nr4l
   Q==;
X-CSE-ConnectionGUID: 8z5GttIwR6uJWeWvSGadIQ==
X-CSE-MsgGUID: PxjCdW1FS3yY4tfx23q4mg==
X-IronPort-AV: E=McAfee;i="6800,10657,11563"; a="48623455"
X-IronPort-AV: E=Sophos;i="6.18,291,1751266800"; 
   d="scan'208";a="48623455"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 14:42:47 -0700
X-CSE-ConnectionGUID: M6mKG2j3RTaHB6koX+Ukdg==
X-CSE-MsgGUID: P2LQQwo1QXixFVzWB8gbXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,291,1751266800"; 
   d="scan'208";a="200833038"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 14:42:47 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 24 Sep 2025 14:42:46 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 24 Sep 2025 14:42:46 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.16) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 24 Sep 2025 14:42:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ahl2FjxbXFhM1MCbDSGg4vtl8/K/R5HJ3ezf/3fir4Q1u7clvia8TvSCb6piHlM8qp0nOgGsVx2HFsRIyZiPpli9PpOILeIqTx3B1ODEJqiczHuTTa/kLlwVc1tmsK36Xv0x9ald9chZIU4+6G89hzSk4XgnUd0tOQuJQvXQzVVR7dV9z7rCvU5OqgTq5YD6sXpPYapY/9p0rgtNnRmqhWp0Ihnl+mYqRofORg8T14pEqHbCfTOOTCGdE5uPhcVBbSeMj9hypUe3T/jhBj5qs6ONywDH1YVv1dvUX8A/6yFcpzsrRoC+yp/F3+WmRrr8kg0jiG+j0Zea7g/wcp9bdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2we6PDQ1/FLcjPcvBfLBEWTbKYpAclw4bxcOBIiuXbg=;
 b=azdogxd6CwDa0vze+k4xY4H+gHUdhRerGWjT5K3MQZTLO3ck5dmGHSshvQRIqMIWTKcypF4eGv8SS1nHgOwZKMJMMiYfD+73Dg2dLskcvwHFfcyAESd/i7F0LNdb+ggUXLbXeGI2vNqR4xQ0YS5Jy84Zkl/ZZjAXQB4y5oklCL5YeNVx3e8XwhGsnWpFebUQJ5ancKNAvu7Rh7YhiD7xgGc4SsxdaPRFgYKmzJOQ/3ldqJ3kWIFAEfLUDAtJ8IQCbPi/BmHCsL1BYg2gLvJWleIT4Laxa+AVfGClj7vaCZjhD1ev4xF9K2OSexfW2a8xxmEBKyMt68iBSZIQtj7MHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::80b) by SJ0PR11MB5814.namprd11.prod.outlook.com
 (2603:10b6:a03:423::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.14; Wed, 24 Sep
 2025 21:42:39 +0000
Received: from SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 ([fe80::4df9:6ae0:ba12:2dde]) by SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 ([fe80::4df9:6ae0:ba12:2dde%8]) with mapi id 15.20.9137.012; Wed, 24 Sep 2025
 21:42:39 +0000
Date: Wed, 24 Sep 2025 14:42:36 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Neeraj Kumar <s.neeraj@samsung.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <gost.dev@samsung.com>,
	<a.manzanares@samsung.com>, <vishak.g@samsung.com>,
	<neeraj.kernel@gmail.com>, <cpgs@samsung.com>
Subject: Re: [PATCH V3 04/20] nvdimm/label: Update mutex_lock() with
 guard(mutex)()
Message-ID: <aNRlzI9b2oFk_VeC@aschofie-mobl2.lan>
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
 <CGME20250917134136epcas5p118f18ce5139d489d90ac608e3887c1fc@epcas5p1.samsung.com>
 <20250917134116.1623730-5-s.neeraj@samsung.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250917134116.1623730-5-s.neeraj@samsung.com>
X-ClientProxiedBy: SJ0PR03CA0124.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::9) To SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::80b)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PPF0D43D62C4:EE_|SJ0PR11MB5814:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e2799dc-d20b-42e8-ebcb-08ddfbb3485f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?qERzEgO7OEN0PGUsdMV7VYrek+AmknW7/MV6n+Tu99EU4hrXFcPpsHYVCLS3?=
 =?us-ascii?Q?WD3PUN+5WfMpgO9g3y0rDmF+3yEa2bCsTY18gD4PmGgeB2p/wYi45Z0r6Vh5?=
 =?us-ascii?Q?vP9Ify8pAdDiRmMRGXeH437yB1St7wkjf74e5L+2amb+OJLPL+AQxZXGALTw?=
 =?us-ascii?Q?EzeZZEKcw+9dEsFAbPyJd531SmrqV6d/LWUgFX6VpJLUuDyD6jZ+XtZ6fO8k?=
 =?us-ascii?Q?k1gkCuZYNrpyiKrFLWWJ/L2eLhv7Y1txevkkgZ5O/90toM5mIRvQIvIfvg1t?=
 =?us-ascii?Q?lICYA7D/NJLE1ckkr0hvIWkm1aN1W4PPjGvU5XID1xF2Ut4ZT8g21tZ2s2qr?=
 =?us-ascii?Q?Lozvclc02q3IsvqHpEz5+khSVFetoIpeDplIOX9T/bN85Cfpy7sj7h+HvAc2?=
 =?us-ascii?Q?EsJXQHG+Zdbqcf2Z2Yiv15uu9+NrEE4h70NTCshUCCoIvWPhDbSqUFdLytN4?=
 =?us-ascii?Q?WoGWVefmk0iUf1GLjEO+Cm1eE1VcuVDLhe+ghsE8Sycffs8SqfaCuN2gnxLz?=
 =?us-ascii?Q?hQgf4kso/XtEKX2ODF9nn94C9IUPcpjnXYHUfZmBvj9ABmQ2oJ0PqJjgdi0D?=
 =?us-ascii?Q?cUJesL8aQ/pcG8kflxheRpkSUE8qHXhtfC8Yzl51mbBxTuZMlC2wCECvc+X2?=
 =?us-ascii?Q?eUhCIk5EXqrbptV6/m6tsP7scVYDVudZMpRTvqsnvbdVfSVdo4GdfQEVOsPd?=
 =?us-ascii?Q?Pn2fT8NqN9nuH+kQQsvC1ZWdgpNZrTcy7534Q0C+sT+EyjvoDgq4ZfVRZDhD?=
 =?us-ascii?Q?stdeM8/NnErq7ebnvEnC/vA8YoDvvw1Po0HJcTV6tY2zuew/avK5wk/oB+wv?=
 =?us-ascii?Q?BL08HIfV0Ql6WZ9i9JuW/WkRP3/zyAOMDO/T/nT6pQu+QIc7pixXYy5/wpUM?=
 =?us-ascii?Q?2x48v+0wYtXA2XnFKh9bgrGgucK10WCuWU+iY5vUL3qJ6WbZUQZim0ShvRs/?=
 =?us-ascii?Q?0fvlsF+FQOqAlz8Zz4TsA7DM1mmIK+zdSU0rop7YQJfKOIvHoHQ0Bj66iXds?=
 =?us-ascii?Q?Yolo3jm3pl7eOxZKx96kiun4kbr4KFqD2fZvBhCwaDS/Temlc2nEzy+b+rN7?=
 =?us-ascii?Q?kwOQE2YO83LIYt7zyyupHNv6gc0gykEYohVnqm5zjnCujD8jlq5JZg/DUs8K?=
 =?us-ascii?Q?5ytLuM6pnkCCZShMacstXZ/b1I+Uia/JZFj0DY0jcu/mZKy3iIQJK9o3Pls5?=
 =?us-ascii?Q?6iFLnd/RdM0zyxoomxsWkQO58N9qguADYAv+fN94R831sxue5M3qPbX3uFiU?=
 =?us-ascii?Q?JK43QW6oY+5LSCguLubv8uRwDT0E6bLfqamVikU8lc9T28FOAh1xrk3J9FCN?=
 =?us-ascii?Q?H2hHtRWtCasndJTc+1m5rQkfAZh8iq254fMBj3weCWnRCFvG0AlY2DVzVB9F?=
 =?us-ascii?Q?eRNTHZjIQtL+A/eA8qe/KpVJr0bDHWZnuNdTdF/IqlImg3uyGAvVeEkNedVi?=
 =?us-ascii?Q?ws5+Gj9oM5Y=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ5PPF0D43D62C4.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YuB7OGHmfTNnidG8kaiPSn3ljp7SfMcI33+c78vAU92A1xSlVQJTRrhxEvzG?=
 =?us-ascii?Q?yZV+9FkFElHoXxM49oh8//x9gC4gMszFWVf2wSzvFZuzu8HVZk+7E8DsGTkp?=
 =?us-ascii?Q?J+L9hSzawnU5+hhlB+EbP5vGim08jNcUVbDIxW4tCzsWUPyd3nvT/r9d6ik0?=
 =?us-ascii?Q?tR3MzZQfLC11Ycw9XMpph6irzBSfKofmMCU6w/wgB/3TzgmLtMCZaReefi4n?=
 =?us-ascii?Q?MMAjtEhXLMlKZ6+0aFDH5gVjLEGX4scydPgx6epfH+kMM0vVNMsaaU3QkCVc?=
 =?us-ascii?Q?BjWExSmKK2254EugDsxHFt4/UZ6nWmR0OPa0GCu/g6IxOL88zxP8SezuUTBZ?=
 =?us-ascii?Q?i4yroubpBy9WGd9EcUPsu/YpTWjFDuydlJKba5UsuuohKQT1GhRLfot5Sh2t?=
 =?us-ascii?Q?mOxa0i2qY6aZLk1O+zsIfWprqFFWY/Hr2D2Y5XEmE/g+wEsV+rFAAvmyX5bM?=
 =?us-ascii?Q?Rx7ZCSwWFKSBbQJMHzYeEKAYP25RZ+WkrKt/nRbbH2OeoUFnsQN9KgSrL5Cd?=
 =?us-ascii?Q?VMlRpoBQdCQht0cP8NE7xVXu64KcyTGZlfGh4pV7DQbP6w3jmjmOzNrRXPQO?=
 =?us-ascii?Q?2LVoqTTdTuhPa8/pyjNYB/izbyhgM+dlxWQIYCMFypvG2D5dvOKzkBdrPicY?=
 =?us-ascii?Q?sNxQFuC5WGGu8JT/CvT+XcpWsZzLylLHp3n5oq2F6nOKz6l8qbcop+TK1+uF?=
 =?us-ascii?Q?IUtjkjioVHfEt+Bh/Bul05qj8OxCzcGXsrWLJKzl2l4clvMUlNQUhUHb+duw?=
 =?us-ascii?Q?vf+3SBm8YDMAbNut6zC9lkZkiapABKZmSJA82+hKdsWZOcN9g+iyd/4MIvOR?=
 =?us-ascii?Q?Y4XTzSil+PTJk9dHsNJxSrS8JPqrBt625NOb5O2Ix+Y6EUadEBg9jydcXM+2?=
 =?us-ascii?Q?5RltbohJTKtMjASHNktB3S0L3PZvlxg+ZKSX4Xj4XNkQCLbttczt0i5tIYV+?=
 =?us-ascii?Q?kK0GlwnuYj4T4jNykChUlolLM3ymXDSwsbjZcjU7dBNdYSZ4YmZ9ZiTvbz3I?=
 =?us-ascii?Q?cUiiQxmWuuIoEmftM8k+JJK3p5BE6YlqLY6cJ7HiulzE3JpeMaADtqhSkSmA?=
 =?us-ascii?Q?CpOzoeesgVL9Bl4tQTpNrnlxc+SAnelrWwkscpOzdxBmuXq+NKjBWJ/GaO3F?=
 =?us-ascii?Q?SNiE8RstFlrP/nERBaXcmp1JSyIS1/aFJZOpU+3dWoxS0df7UE7Z/mCz1bO6?=
 =?us-ascii?Q?FaPF61Q6kjmU59YwSToqicyUsVRs/BVHd6Mgga31rrZaVh1TPpmeGJzQ88oe?=
 =?us-ascii?Q?bq3PlIevyJ5xu0pkfSF+7yMLpukGGwPZncgZnsO5jIWMYLrwn+yD9kMbYpPX?=
 =?us-ascii?Q?J2mnBGL8nf4J6xUIA8OsQ9Cfh4+lbwAmKCyFiGI98KP6xunPXvvtyouvzoHh?=
 =?us-ascii?Q?zFskGVo9j1qAMM/pH/54sj5CwhtCYwOzaF7x1RKf9QIEeCLVJ+Vyv0lc0kTX?=
 =?us-ascii?Q?oinKbfpDKjxE9wfFRo9n1JK1Pv3HqXewfIr3Y5Rk+FpUHI1yMKXd+JZVxRXH?=
 =?us-ascii?Q?DJpOoS9nPwb49bZAYmm7/rERb8H3c2lVTYRV1DM1eE9CXBcXi1e7SYGEvn58?=
 =?us-ascii?Q?MZhqwnHv/S3EKDag+mKeMhDjXi6RvZcaHHeeGbjUuNReqBvY8FyJzZnjUGF6?=
 =?us-ascii?Q?0w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e2799dc-d20b-42e8-ebcb-08ddfbb3485f
X-MS-Exchange-CrossTenant-AuthSource: SJ5PPF0D43D62C4.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2025 21:42:38.9989
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CcPkbUPjTv4x0qOhW5nHvwZJb7BWaYCQKRpdPA0ub+RmrBMr2wVKjGFnQZsiTj3+yJi3BmQ4YKlQfpRM1rRYCnbwjgOwax9olIWal0quNec=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5814
X-OriginatorOrg: intel.com

On Wed, Sep 17, 2025 at 07:11:00PM +0530, Neeraj Kumar wrote:
> Updated mutex_lock() with guard(mutex)()

Along with the other reviewer comments to limit the application
of guard() to where it is most useful, can this be spun off
as a single patch that would be done irregardless on the
new label support?

I'm asking the question. I don't know the answer ;)


> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
> ---
>  drivers/nvdimm/label.c | 36 +++++++++++++++++-------------------
>  1 file changed, 17 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
> index 668e1e146229..3235562d0e1c 100644
> --- a/drivers/nvdimm/label.c
> +++ b/drivers/nvdimm/label.c
> @@ -948,7 +948,7 @@ static int __pmem_label_update(struct nd_region *nd_region,
>  		return rc;
>  
>  	/* Garbage collect the previous label */
> -	mutex_lock(&nd_mapping->lock);
> +	guard(mutex)(&nd_mapping->lock);
>  	list_for_each_entry(label_ent, &nd_mapping->labels, list) {
>  		if (!label_ent->label)
>  			continue;
> @@ -960,20 +960,20 @@ static int __pmem_label_update(struct nd_region *nd_region,
>  	/* update index */
>  	rc = nd_label_write_index(ndd, ndd->ns_next,
>  			nd_inc_seq(__le32_to_cpu(nsindex->seq)), 0);
> -	if (rc == 0) {
> -		list_for_each_entry(label_ent, &nd_mapping->labels, list)
> -			if (!label_ent->label) {
> -				label_ent->label = nd_label;
> -				nd_label = NULL;
> -				break;
> -			}
> -		dev_WARN_ONCE(&nspm->nsio.common.dev, nd_label,
> -				"failed to track label: %d\n",
> -				to_slot(ndd, nd_label));
> -		if (nd_label)
> -			rc = -ENXIO;
> -	}
> -	mutex_unlock(&nd_mapping->lock);
> +	if (rc)
> +		return rc;
> +
> +	list_for_each_entry(label_ent, &nd_mapping->labels, list)
> +		if (!label_ent->label) {
> +			label_ent->label = nd_label;
> +			nd_label = NULL;
> +			break;
> +		}
> +	dev_WARN_ONCE(&nspm->nsio.common.dev, nd_label,
> +			"failed to track label: %d\n",
> +			to_slot(ndd, nd_label));
> +	if (nd_label)
> +		rc = -ENXIO;
>  
>  	return rc;
>  }
> @@ -998,9 +998,8 @@ static int init_labels(struct nd_mapping *nd_mapping, int num_labels)
>  		label_ent = kzalloc(sizeof(*label_ent), GFP_KERNEL);
>  		if (!label_ent)
>  			return -ENOMEM;
> -		mutex_lock(&nd_mapping->lock);
> +		guard(mutex)(&nd_mapping->lock);
>  		list_add_tail(&label_ent->list, &nd_mapping->labels);
> -		mutex_unlock(&nd_mapping->lock);
>  	}
>  
>  	if (ndd->ns_current == -1 || ndd->ns_next == -1)
> @@ -1039,7 +1038,7 @@ static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
>  	if (!preamble_next(ndd, &nsindex, &free, &nslot))
>  		return 0;
>  
> -	mutex_lock(&nd_mapping->lock);
> +	guard(mutex)(&nd_mapping->lock);
>  	list_for_each_entry_safe(label_ent, e, &nd_mapping->labels, list) {
>  		struct nd_namespace_label *nd_label = label_ent->label;
>  
> @@ -1061,7 +1060,6 @@ static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
>  		nd_mapping_free_labels(nd_mapping);
>  		dev_dbg(ndd->dev, "no more active labels\n");
>  	}
> -	mutex_unlock(&nd_mapping->lock);
>  
>  	return nd_label_write_index(ndd, ndd->ns_next,
>  			nd_inc_seq(__le32_to_cpu(nsindex->seq)), 0);
> -- 
> 2.34.1
> 
> 
