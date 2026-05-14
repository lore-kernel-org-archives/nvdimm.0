Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8213B6344
	for <nvdimm@lists.linux.dev>; Thu, 14 May 2026 20:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778789583; cv=fail; b=Vk4yBChuVggFXXuD6SuL/LByAvUqvr8vrajwPd0Kfp1P/l6UtnfzWlnMA2m6Z6+R+2tIVc87T28lLwdycom1ZJA1544L9NLuv1slzJHzt1dkl955R/Q7p0SMJq4/kx3xqE9OCnysfZMnVgh4X9FurD2/jZdvrPRBGEOGL0nW4Io=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778789583; c=relaxed/simple;
	bh=YNUV4bgxB08SWde9rAUz4OyltbSUcViPdpFAuUw7xW0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=DqpMdp0AoOCfYzUhuV5RKWPBG5hwHMa+lqKGIz8nVgB5M9X7xq+zUmQ+wRo/XdR7hHZ+HagmfsPRIQfJi0AJbjG729rw4/rVkvbEhLzDyYrgfgJ9zuoq4gLrWeR9RwUfJv7Ei1Hnq6vvdCUB8j8pRwIBljn+MAL/wfjRxzjIWOQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jVcRO2ge; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jVcRO2ge"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778789582; x=1810325582;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=YNUV4bgxB08SWde9rAUz4OyltbSUcViPdpFAuUw7xW0=;
  b=jVcRO2geo5rPP5rTDZcpX9D5jYpIvatXBMDhr+jTHnfjgYsyCtVuLvYq
   vDkyTnxMAeM0WOnTJZlHc/uNZ7WFfN8HE4osFLJwlV50+3scfAF29RnrS
   mPkkZ1vxpMo7rvYqRvB3q6BF/HbOtvnyR5s9AjmY3U+A5zSWo1t4D89up
   89NtT3Ez6FIL33E6bGaOzdOxixY5tpc6BajrKFq9Buna42FhiJzqeP7IN
   KfVp/gJaIW1sKku50Js2PScEObWhKr4muIWOrv1nFiVmIIWkUR04e/y8z
   sjdg2AAEhOdmhlcEqP0ZlLvH/LTokKfGWI7m5Xk3vqDDuA0GBl4jEQxuE
   w==;
X-CSE-ConnectionGUID: F6ypunY7S3ya5Z8uZTpx7Q==
X-CSE-MsgGUID: 82x3Np8hSqSl0k2v7pZCcg==
X-IronPort-AV: E=McAfee;i="6800,10657,11786"; a="90435815"
X-IronPort-AV: E=Sophos;i="6.23,235,1770624000"; 
   d="scan'208";a="90435815"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2026 13:13:01 -0700
X-CSE-ConnectionGUID: FvMv6H99SN+trbtD4Y6CQw==
X-CSE-MsgGUID: fNLD23VBQVeV4jnRzj8LRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,235,1770624000"; 
   d="scan'208";a="235445620"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2026 13:13:01 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 14 May 2026 13:13:01 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 14 May 2026 13:13:01 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.14) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 14 May 2026 13:12:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mv/+5vzesgHM3jhatJGI1kHAqtWa4xbiP1wYgwhxuWxPdmjbUBAMjnC03IX5NDmYxlMYXFMYu1UaL9B+LtdgULQZQBsBB0hE9qZMQlHkDvExR9le/Q0Mq85QMfB2Ykj3eyBDOYOegGsINLaM7qKnhFX1O2JNCIARSO1me0zTYYtnqIMUEzqfOHbF2d8RjumzSNBa6T9QxT2GPpgDgCEy1BT8/xcDUwjmMnE7Rt61Gxrs6IqeqkC8eZ2GdsOq8bhlRnVFR+IqSvzv0lBrA1xlgXCA0xS1fFUoBJStfc1Rhp2m2mH+KndCttj/EBo75aED1QXd7a6+qPJwmmzNkKwFwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MbVyCOlx16QQl/bIBg6b0e86+Q5XYy+FTN7EUvrHBF4=;
 b=Sw64QCtI82foryK+150kIV3pz4PxqZFbR/hKYLv4PrD4fty7bZ4bOxrBhdYb9i+kD+Ap+6r26MP5hRrMpAGkFE2bdtR4GOQc+SSn5uwiS43YT9dILNE6pFS98N+rsCEWu5V3bW8a/4o5xD5r8J7h/Yy0j5o7LZH11g3AA8/uHYlGmpKN8frCCMN0FXopZJTU643yXArykW+AsK1hmbK3yR0RSDZfE/0ReGLVXVuZVJiPFYlQjXQ2q59dZJr4hMtpaJpZL1AShAfexhzwYYk2h+vxGTukEQiIKw9cdWjW9f1l8MMmSEtwN4NCGVPx+L6OKTE9lBJNt58P274vBdbapA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by LV3PR11MB8577.namprd11.prod.outlook.com (2603:10b6:408:1b8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.12; Thu, 14 May
 2026 20:12:55 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%8]) with mapi id 15.20.9891.021; Thu, 14 May 2026
 20:12:55 +0000
Date: Thu, 14 May 2026 13:12:52 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <iweiny@kernel.org>, "Aboorva
 Devarajan" <aboorvad@linux.ibm.com>
CC: <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v3] nvdimm/btt: Handle preemption in BTT lane acquisition
Message-ID: <agYsxBsl_pDjph88@aschofie-mobl2.lan>
References: <20260514002314.65024-1-alison.schofield@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260514002314.65024-1-alison.schofield@intel.com>
X-ClientProxiedBy: SJ0PR13CA0047.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::22) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|LV3PR11MB8577:EE_
X-MS-Office365-Filtering-Correlation-Id: 62c0ae0a-e387-48c9-f4ca-08deb1f52f69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|11063799003|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: YAkoMXNH2khQBBrHzRJO5NAYPtjufYEl5Cq9hwzKqH9ZJ0OWzltcr6s3qG4nC184MxLDmzot6rd9JKlx8gi6TZQNNGohwOIzpJ0a6NcNQ0VMHUoPhAjr3Z8AE0D5i0oH0rdbX5tV4KKuwYpyfClE1oA9obz3X4GWqv3I9wReKuJkYhDaqFnmnWhnXEC56Ad+c50k1REVdu890OGVqI4xciKUesoRlzszWi5qtEK8/sK2Z6+G4r1cxOUKQGZS4mP5+qB9Jm040zpKeRH8Z5nLWhXptMFTp8xGNCy7I2UYh+p9HjN5kF8197jwiiEOCR7oYorVwjfVBmoxgB/WT1a5zkVrExB4/oqQTYAMOIXiQt/VKD+GmnJtBHNinSKpYMrbF2ZUEsA3nGVTE9KfxbDzMnYmPFM6d32Mf/i3y8JCJOdKkyL0l/y23n3eb1C6dDetdo8qtw/LIE+MvtGWgro9HxaxeyJYqeR/tkIq1to/PRzWmeMpYfDjT3SHo38WkIu7XBtkaLQRzhB3H5XBrLeYHa5GzgxKJxtWRqlGZu78zuDZS1psJj3tMVpAktM0uGGRF+wFA0jMFBm6BxQs8OCnOUznh6tEmShKFwMXIpaHUNzcWcDx2O0gnobkyg1kwMtV5YTMlIdm0mqbcrv5/23fvA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(11063799003)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OziH31DM+JqfAlVFWokEfWkCipVXQrsUZc8zjaqi3prEb70htlWrAr/qcVYc?=
 =?us-ascii?Q?qSmZjAkEAaDp4/dcVLXeW5H/3fiT7W6/jg9le6O1OpJJk2VOOxm6T7Cw5H8C?=
 =?us-ascii?Q?aJxXR0d8e+jmFLqJM+iSPVQfh9Jzq+/rFA/cs4p08qY/QCTumdv8yQ959q2U?=
 =?us-ascii?Q?F3P+AW28Pc/aQT4qLzyLK2LajOUSv4HYxArOon+7q+5jaJa2eCxP8uypNjli?=
 =?us-ascii?Q?LdGdlhiRRI2SvabDm2HhQqoqvy7F3BFeiJmYvNpuUmbPW7D8OOABwjYybnN5?=
 =?us-ascii?Q?AvQc6Q8b2jRD8FAVKG9I4n5OQkTqhI71DRym1CDEVQQ0z+Zko4G6BggMZTZk?=
 =?us-ascii?Q?pCb0aSdltQBuwbTMrimCvHSRjAQ4GcMkcrcfipHWL18aXp10qqVVbrFm0pzt?=
 =?us-ascii?Q?kPQ0yhaXE1TBC6MfcIvuN38Gjxp9I4AROeM05iLP5NRazvkBsw1Oh38vBTel?=
 =?us-ascii?Q?YOI0CzGyM2v6aMpZmrblFDNkpoLAqP72WDCU3eSh01anrlSgmwmJvaJqRIQS?=
 =?us-ascii?Q?mAzS6fN/0cP9eC3Z4pqyY9S1M1hO+YRrSc4hGn6WY+Z3igQE9mW34YcCK6Xz?=
 =?us-ascii?Q?+nWRHKrfU3dyv6+xlWPYF9KH6X4Ur23MIA4lBlB6+RBmmcB+/URz+5y5+0kZ?=
 =?us-ascii?Q?ZIXIPT7Z6Md0l6esZhw/VI0+ocliGNCBTg5qADDsSijsFJSGWKw00CzJ++1Z?=
 =?us-ascii?Q?bc8CpH9dtFEgFLGwAba6upQRjiCNYbQYyuTjddII1q9etSBnfjp7y8ir9gYd?=
 =?us-ascii?Q?0hdpkSAdjezXepqD1J/PzrVskiG8zjDNQvFFxOEvDn+dGZZLlIPcz6eXIxK5?=
 =?us-ascii?Q?TDijCfr6miA/oPcdYpi+T1+Q5RbrH+/WXXIeHT8M8rVVU8kdnymXQ96SI5nn?=
 =?us-ascii?Q?TFHn96x769S7qUN6JyfFXJrmow5BVI/rejfC/RgmQ5YZW/K+hFTGE0g6LSNj?=
 =?us-ascii?Q?mGBx4OrcOutFFJg+2vjCVYDy0vCp+XyNPzoO+T8k7S+8oYp4Ln+Q/ViBZc9R?=
 =?us-ascii?Q?3vkvDzyIWwm4SGbr5Qr6xxE1o2KdFphTcMRKcfPHxN37kJ8mmgN7YKKN5y0S?=
 =?us-ascii?Q?D8ZA1lj2JGm+mHPFWQ6pKbZKCWmQO/bmsCdvri6wtxpJRjFLhGtUs8CNkUQU?=
 =?us-ascii?Q?j9ZFuxgKiko2PkljEBqzZYkY/pp6vHJEx1Vg7DiDTETEYbKzOE7a1v6PNBmc?=
 =?us-ascii?Q?AwfZ51dsuVPhfHr8rDrCUav7Xe6nbiJM08VNJdzX4kyTIVgKUUnhxzsMh1vx?=
 =?us-ascii?Q?c/4UFfgvpINl48LnvoVoed4jijVpLCSQ8o7FPVeopBQLeA45/BnFLaA7KVqA?=
 =?us-ascii?Q?A4k/0eup0tuYRcO/2QYR9plDTgXpx3u4TY8A+jvhsdZhkw2n5iBOzkoWPDYW?=
 =?us-ascii?Q?nx1o5PccNdZd3u9pTn9yvcUVivA/TcGkxzd24eYZuXDtbRqQo/dv16LzSLml?=
 =?us-ascii?Q?WuYaSJyAgOIgevMATBy256/fTllA80CQXxf6mwZCXqCtc8oUCzda+l0ltO6K?=
 =?us-ascii?Q?M+mrvc8u95f/oRLeIk1FOP8+RLGPjihl074EXmJZIINI1UxQ86VC76iuFfPQ?=
 =?us-ascii?Q?VN1Nc74mqkva33wKyL83bUY04Xlfxfdqw0V4K2AcL1xzdeYlPEZMXBMVpIIo?=
 =?us-ascii?Q?oWgoL+mN4T/IoLmHm8uNFIqgqh9K/q1+z8HJMb8PcN5IFfuz8cB444la++Mu?=
 =?us-ascii?Q?Y5PO9JltiE54+9SndCJURkfushuo+fpoDNHjXp+iRwnJFMvFmZmUUTS7rkad?=
 =?us-ascii?Q?3MnjJp/yfj/X1+C9ysjZFzehn2L1cpI=3D?=
X-Exchange-RoutingPolicyChecked: Yu/ryAnGiOMnUsB7FyVE56zucYXpbe0cYCA6I7xIcRkOb/rnSt8jsBe5tAuJvqC4VEszq8/lECO8iuD/LkXyr8YPUF8q4IVuTtiNm5RadlKeEaofad3PFn5QrNths1DoKyr/fI9eUdqvOIJGk9l3bBXW0KkK6u8/CbLZMQExBt3BCOM7HZwTXnSxOqiLCKwONB5xZHiOS9Am/Ork/8ATldD6nKqqKmXS5ClSF6+JLJr3UWlmT+BM8ZMRLr/7f29mhUgJGzW5iyToWNVmP7em7ABNSA8xjtj546/Tp8CcaMPDHDyC9RFTfhzdLHlv4VUCX5j9Gh6R89i/jwWLrfgb1w==
X-MS-Exchange-CrossTenant-Network-Message-Id: 62c0ae0a-e387-48c9-f4ca-08deb1f52f69
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2026 20:12:55.6091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /0CTh/eGPBdRCMEFT5SVpJHjGc+rb7AVk9Mtjl+/fECg4EEKCiV/aWJ0LBcRuRfiFghB5RcScaaGSxDA0E01CmX9e/+dIISHjw2BLbHuwOA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8577
X-OriginatorOrg: intel.com

On Wed, May 13, 2026 at 05:23:12PM -0700, Alison Schofield wrote:
> BTT lanes serialize access to per-lane metadata and workspace state
> during BTT I/O. The btt-check unit test reports data mismatches during
> BTT writes due to a race in lane acquisition that can lead to silent
> data corruption.
> 
> The existing lane model uses a spinlock together with a per-CPU
> recursion count. That recursion model stopped being valid after BTT
> lanes became preemptible: another task can run on the same CPU,
> observe a non-zero recursion count, bypass locking, and use the same
> lane concurrently.
> 
> BTT lanes are also held across metadata and data updates that can
> reach nvdimm_flush(). Some provider flush callbacks can sleep, making
> a spinlock the wrong primitive for the lane lifetime. That issue
> predates this fix, but becomes more visible now that BTT lanes are
> preemptible.
> 
> Replace the spinlock with a per-lane mutex, remove the per-CPU
> recursion fast path, and take the lane lock unconditionally.
> 
> Add might_sleep() to catch any future atomic-context caller.
> 
> Found with the ndctl unit test btt-check.sh.
> 
> Fixes: 36c75ce3bd29 ("nd_btt: Make BTT lanes preemptible")
> Assisted-by: Claude Sonnet 4.5
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---

Sashiko review offered applicable feedback. With the recursion count
removed, the lanes are really just a lock pool indexed by lane number,
so the per-cpu allocation no longer makes sense.

Working a v4 where pre-CPU lane storage gets replaced with a dynamically
allocated per-lane mutex array.

https://sashiko.dev/#/patchset/20260514002314.65024-1-alison.schofield%40intel.com

snip

