Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271901DFFD
	for <nvdimm@lists.linux.dev>; Wed,  3 Jun 2026 00:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780445581; cv=fail; b=Mfz3ZZ3amnnsA5FFq92Hu+Hq1Eo3wANS7jKAUK1xno+rZgaaAhMcqaOMwP01650Dz/Je/aM/gMqYd5RDXAgHe3NGEWXyeX6zDeCVW9tGjptxNL6mB5DC+2ML0D5YhW4vba8tGIZ05GR1nmM5A8ljP2lICDosbkZ9Z3JAvzaGijM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780445581; c=relaxed/simple;
	bh=+UgzTX1I9TThx3hYH/uiZY/w+zGTFsPy7BrU3S2QTqA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=BxVHKv24IHLp0jZKnGSVVFcfU8JTzfFm+isjC6lhmV+t8YfS6mU/Nnw8d3RxpjEZRqh1H5RZ4aNrSdKtx9GAFEC+FNoQ0yhfdIpW8N6NsYeV34J0AgZWLqts7Areypo3p0UOz1iPMlTDJSOo3JM7Ke3C9D8JlD0KY8DXvPdXTEw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hH+/Lcss; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hH+/Lcss"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780445579; x=1811981579;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=+UgzTX1I9TThx3hYH/uiZY/w+zGTFsPy7BrU3S2QTqA=;
  b=hH+/Lcsscw9uObTvAepHMq25PCB65CFAV0M0n7wfl4nyZJi+SwyCEHXl
   zmzcX+/MUwOQmr+At6SIaF95Hz4DXZxRNXZlrsYDkT87WgNQC9IIlQipt
   1hrBWtNeQ4RMCYuTJnsOAHb//B13t1F/iddYrV1SQVH41Sq2Mm9iAti1o
   SNnr62uASiR0BhjXe/Y+io8IiWWoRsggrGyoTyFbJHxFE3mE3ckmy+g3/
   ci1FsjzNW5CetPK7pC6kko0+Y2MWgIdulIYpHACDcStg4BwEAPvnTu2Fl
   OMZQa70d0dueyskDIAb2Zp87bcoG5lcBKtmQOnWLlkC7e9o2LVVv5HsSx
   w==;
X-CSE-ConnectionGUID: B1PI13lJQOmpHoNae58SrA==
X-CSE-MsgGUID: QAAMCbNZTzyv50L9pvzxUg==
X-IronPort-AV: E=McAfee;i="6800,10657,11805"; a="85130782"
X-IronPort-AV: E=Sophos;i="6.24,184,1774335600"; 
   d="scan'208";a="85130782"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 17:12:58 -0700
X-CSE-ConnectionGUID: pNi/r8byQq2d6Yb8S2W2BQ==
X-CSE-MsgGUID: DTM9sjS4Te61m7fy21LZsg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,184,1774335600"; 
   d="scan'208";a="244167252"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 17:12:59 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 2 Jun 2026 17:12:57 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 2 Jun 2026 17:12:57 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.56) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 2 Jun 2026 17:12:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Lpw55ZlbD4wAIGcyfXanR0Y9gU3q00O5I0RRRQm9aEFs6CvqJt9p6161knsKBqGx52k4MYfaeDal5/zfBhibzYy+D8gQXj8suvZhEE+pHU4g4moHrYqrNiRDLsHh4U75fQM2mHziRgh8IQHYQwRImW/ME7GV8Qp/wP8x6S6SUnpOk2QeFreQE1tpnofjGQ49zAkIqHZlbDoWUeEr/V9LJBlUxbFfnvrHvE5rROX2dp/+xUlStgL3sWi0P8vBVhkY+IUnmpb4WJ2rJAAmmxkFwFQJ52elIpHUftALUYYfphfGfsEuTqkqe9OP/p31db4qPUUTPlZd2Vx0U6KNIfWlWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QBKEFdTv/UQ/XRDxDOCoMJyi29mwuQs7MMmV+OEhUro=;
 b=d6ns9pcuq0khq+vXShOiBFLDzDAsgf5LZPpla7JevxN7CE03RpT4d/vx07TLFDBucvotLsvFkRkD1DrKIHRySmlWqPJNXpk2+2kIMjzpMUT/StKU3Z7Ldj8AEFvqr1pKNYQ+Sm6LkVtUlCg8DFLPZPftO2ZUDRP/KmdWADF6K4SUX0at5fhXtID1Nd8NJSySHap5ZxAAZu6cc8G6k4zBlKL1oXPsk1n9pj0ZVuXMlUta1eHb9wgkkuzPrPUkPn8Tec9Nq3APw+3f30C8H4FVoOZr9Dz90i6D7DEWvnkcgLiqc8BEMY1GCvqIeEzHSNGlB91agKveNyfRn2CZcZqNKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SA3PR11MB9511.namprd11.prod.outlook.com (2603:10b6:806:47e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.13; Wed, 3 Jun 2026
 00:12:49 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%4]) with mapi id 15.21.0092.006; Wed, 3 Jun 2026
 00:12:49 +0000
Date: Tue, 2 Jun 2026 17:12:45 -0700
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
Subject: Re: [PATCH V3 2/9] dax/fsdev: fix multi-range offset in
 memory_failure handler
Message-ID: <ah9xfRsFHqH5rETy@aschofie-mobl2.lan>
References: <0100019e79caead2-5795328c-af48-4a93-b147-c11df7446e1a-000000@email.amazonses.com>
 <20260530165037.6619-1-john@jagalactic.com>
 <0100019e79cb8953-e505a8dc-63a4-4bc3-a9bd-3b86ec081838-000000@email.amazonses.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0100019e79cb8953-e505a8dc-63a4-4bc3-a9bd-3b86ec081838-000000@email.amazonses.com>
X-ClientProxiedBy: SJ0PR05CA0119.namprd05.prod.outlook.com
 (2603:10b6:a03:334::34) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SA3PR11MB9511:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c38f03d-0c36-49d8-ba7f-08dec104d8cc
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|11063799006|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: o5WGLxgID/w+kioOq/t3UU3A/NJY7FshN9vLLyOfMZvDTRQNnyLAxYv5T8qjhipnwGKuB3lwNwoV49DEJRtQFAgpxwa1KRqn1ZFLK3TubNlTrJDLAWeHf0HCTqDw0wj8kPx5tU/4GQ55rKJCgWFVR7XbSTNrDSmuvNZ0M+W0+v89wiU4leP3BqE0DhcH5gDMYthCxUFDz/xjRwvtiMd68yox/tP+iEkfk4hIv3YGqa9U1/Ku3gl2Ga3DEYH3hzY4VjLNBAYmMFghn/CPit6e7l15Qd5aLYnUPUfGEyuaIt31e2Z9deVuBjl2k8kucCGDWEtUPiuNR3XTP6NvDTyfcuu4VbW8qmkMSXnkXm7htGxus59v9PwG0pQMIg27WpXl024GBs9QAoHA9Yi0/NraM/Lwo+te4IV+DeTvq95uOzOSXdfgt5YKwthF0sMTuaNpyXU8O33ylhxTif/oAIEn+fs5CoKGsMAI6vrGOVeDBKu6mFCKTeAyjzt19FWVzaX13sgDyUzXCHKhUT2MkUAkoCvFTqLlyCPlY9YplOyjxrbsEfbBR5CmcbdY7DqLtOQHJfu8CBCk0ssNb/TAh3mA2lwbfi2gbAKbSuk6wU0cNpxnIIScC13RkGnurfV+MXt/wHjR1ZvQauEfjbWsqQ85BAgVqFkUCLQSlWxHGuUxZZ0/a03IJKvTLNuEmzyp6JhU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DqED9K2naTs//6UOleGb/r3vpv7HCN+eXZe4fxTh0Mrd7qp3b4Chd+ZlpJqi?=
 =?us-ascii?Q?PPW+1h/6FDCXhGHVfapizlY15RSvbweOwAd7LmIgvnZBdkW94l0fTH4jbKrq?=
 =?us-ascii?Q?Uv0WzD/26il1xUNiwsAo2x8iLVjubr7D9fpaDm5Pf3VmVYjhzDKvOTGAg4mH?=
 =?us-ascii?Q?V2X/IcETiz4RnimeHNi7bz100k8S6prkK21yHDRzBlc84eSrhp+I1B0WNNTh?=
 =?us-ascii?Q?M9JLBEQZklmWUMC8MtmBghA5nD9gJeICvY8ErLfN1UmXSpQoRIRAHnTLwO43?=
 =?us-ascii?Q?fzYDxmwzh2fUiJXA3ZmJI9RYVqdL83c116sG56E/Bdc9YxMJ9edXz01D3/pl?=
 =?us-ascii?Q?/iHwvek6sR1r8K0al9F5Oz1LQXF30t6EYO3kFO6YLMjFvgnrjhpIVq0UPW0A?=
 =?us-ascii?Q?Ytr+r3TyJ1s/LEfhmc+A3shDRZ1tT1YJDAuMRdod1Zq0/6GjbqBlpwUrk3/E?=
 =?us-ascii?Q?hVWf+G0swBw7NdOo154H7Npl7QgJXyehQtI5/xig+SUuSBwR7o3lepCKo0LM?=
 =?us-ascii?Q?yS3frNi21Rl1MzIdZ8b15hVWCDr5T2YpREuMhR1aIBKJ2UZpwB6sNW+7qRnH?=
 =?us-ascii?Q?Q46M6GBmq2jtMXQC5w3zYyfDnVMa3ecr7Ssv6mHE2lc214iNZWWsmTOJr756?=
 =?us-ascii?Q?6xKDa1Hed7vLcBzOQ3Aw7firhfoDJ8QHHFWJgfeGvDgQ1bReaJExmCpzvfMZ?=
 =?us-ascii?Q?4oliELuFur/cs5vIcZyAZflSmB6cj5mXaPeVoQUzn5TkU0b9VVUCJfFI+kzs?=
 =?us-ascii?Q?J2lKirO5sH/T/bkozRSAgnn5QTGFfIw/lJsi6rGoppwb7EHK3Mp5botH4NIV?=
 =?us-ascii?Q?io+SFnWQc0CISITQEf7wAp6sn05hvZ80m0TrShLWkytWm1BMQ34a2E4cUnET?=
 =?us-ascii?Q?4WBNoPO0BnbP064zKSPmiCO519jfMnXbUchW+Gm4h2QhA0IwyyyqdIvVuTC4?=
 =?us-ascii?Q?vEpyvGrT6hRX3LLXrJkRRqSJbjRkS+siNr85GKL/17ae7wxJogVTz6CQhzGQ?=
 =?us-ascii?Q?huiIY7l1EKL3u1+76vAcyjGBQn+/mfqvvjJ+Db1Zhp60pHnOyCMaAy0PrONj?=
 =?us-ascii?Q?f34FzSk1MxAryAcPX7dZI9zSv/OezNJ2JUXOFAdzXFBVTg80Dqhg8q7Xnm5U?=
 =?us-ascii?Q?ehdUvoAJBN2JiSYERdyX2Ku1e8soN/QEYVC6U57sccVgQRPJSFa64J7uqIpS?=
 =?us-ascii?Q?ynzvCBLmMlGO0MM/66Ebb7s6DWvyAUR68FIyIhQ0+xCPrXStIKBrubySYe/C?=
 =?us-ascii?Q?4lWzjpXGeeEUm6IQmHMDezSYfxVuaTwcOgPw9tWt2toSzcTLjdKV0QrpwQ+r?=
 =?us-ascii?Q?q5OC3g1zik/xFMOL6n7KOOnnbb9dIW7Q7n9GEXbzm0e3/O02c6BWsXxvSgr5?=
 =?us-ascii?Q?9CfJk/5cRB4UbPLldKsAJAxMczGH3d20C860dX72GxfMEiTrDn2ET2bZb96c?=
 =?us-ascii?Q?rTlg8MeeNJ9qBQEFixY114LjqDO+OZSg8WZemKPFAGDLkBdFCbTrsx79Iczp?=
 =?us-ascii?Q?egVS7zcXj952qLqSGJtt1bER1vXqYZm1qjMAAwDhN7spyo2oa1UCYa+X8XKt?=
 =?us-ascii?Q?JZA5HCRvxFnW/WEzlZIvDshtBWsfqdjW9oHQEp0xZkmoGOt6+t4FJVeMquGw?=
 =?us-ascii?Q?pJmpLmaoc7zJ+kcs7eJhmV1bZBqupiEImG+RrgdgtY4Pci/IO3872lhXog3p?=
 =?us-ascii?Q?i82T/tvOBCGN5Wo+EqUl0Wi17HFevPwBMpzq20qIvGNb4uv5gCNnNf5jBkbU?=
 =?us-ascii?Q?bV0HZSCusy8VgitIns1Y+9LYBDYBA6c=3D?=
X-Exchange-RoutingPolicyChecked: MPr3YHVUeHEaPz8GZfDWmlXv4P+UzA03ugR3CcXs7cdo+eegWeksVQrRwHM9MuPy9F82njuLUeUn2btLYDfDC77uDy8wiWv1lK2MC1zlKIt9T3C66NC37uchsHC9937XAjnItld7n4ttjkS5gRKntkAO7iLmdOdxE0NCsF0+86oLUYxV3fdgK1LAJxN6RndGfX+cW8fN1ULf3Z/rUxJ0nJwvwHIXEfZMKhJU1krrDEDClseoKoxP1AuUeZjepmD5zo1hWi6c6tfqV2+nN5Zq9B4gNaN4gY7EX2f3z1xEh+O6R2Co11gcWWqE/77F49me5hxJdSTTFP5SfbO6gkScKw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c38f03d-0c36-49d8-ba7f-08dec104d8cc
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2026 00:12:49.6069
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yn2dd4Vd0O46/0QxRAC4uSOAcvmt+cmav/fFFOjIfsBXRUrDIjDMRxYEBm+6FZ1vaOGifdTNifiEkQ6a0kK4Dnr7Me6RkVauespBOk5GdfU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB9511
X-OriginatorOrg: intel.com

On Sat, May 30, 2026 at 04:50:42PM +0000, John Groves wrote:
> From: John Groves <John@Groves.net>
> 
> Fix memory_failure offset calculation for multi-range devices. The old code
> subtracted ranges[0].range.start from the faulting PFN's physical address,
> which produces an incorrect (inflated) logical offset when the PFN falls in
> ranges[1] or beyond due to physical gaps between ranges. Add
> fsdev_pfn_to_offset() to walk the range list and compute the correct
> device-linear byte offset.
> 
> Fixes: d5406bd458b0a ("dax: add fsdev.c driver for fs-dax on character dax")
> Signed-off-by: John Groves <john@groves.net>
> ---

Reviewed-by: Alison Schofield <alison.schofield@intel.com>

