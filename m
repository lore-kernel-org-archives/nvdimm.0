Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45542E6CA0;
	Fri, 30 Jan 2026 20:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769806145; cv=fail; b=SK70bcbPxibu4IsZAuIcqVmgP/FnZXqsR3EQpCg7TuLvOR8l9wJXW4fSlMgbTGUnxt42Ae0j/xu7FxN3rPlAR+q4ID1gocbe4R5iPvEWi0bBXFv7gLAW1XywoIhxfbjXv4ywWXmSVGbsqz9WM47pGZd4UcG80KWfD3LtcmEN8Yc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769806145; c=relaxed/simple;
	bh=aUtQc8rzVbYVXl604plM9+x8YS2xWqKs/ZKZ9MnTAQg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jJaMpF1pictDgO8kUmocAOmzyT8aHKtlFbQ6Oss6Bn5LyHDcOCwGpoRgxgS2Nfb1OOWv3NG46MWm0VzRMjZ/A4Qka2MBfB4uRV3MYHxxE4BUGqeb4RgRy5FScXQqLq2YFX8TNBC1c6nBuqci62iyUpONGjspcL3BIsrA4uI9k9M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VvYAnhmW; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VvYAnhmW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769806144; x=1801342144;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=aUtQc8rzVbYVXl604plM9+x8YS2xWqKs/ZKZ9MnTAQg=;
  b=VvYAnhmWIskZa8VVHRssYJsJHDc+a8vxGxFEdzAwo3WqKs9EoOywlSZp
   Nca0CiZZy6y4xYh2xnZjpCyA2e1OP0jkkC4TB7b8Aw5iJH5dIEH11Gpg1
   0jyJ/KPVZUHdmSu0zV+l+g95XFhO+z64H5TUWbbm03mqtathx42GXlp6z
   BvEJlYzwVGhdf4pYv6hdnXGEDL6rGlYN8B+VXCoxguzFq87Ni/pgTxtGD
   KDAWUlYjdvADuWtgpo91R/Ln7stPWj6kZTDEIU9j3blb4ONvcCKwfHHai
   ap1pJ7+8LOnrOqtpSQ65Dco500MNE8jpV4ajRHcwWXjVr4fN5Uy+vPJ9Z
   g==;
X-CSE-ConnectionGUID: +LRpdiOMSu2ng6CoTVIfRg==
X-CSE-MsgGUID: 0vUvu/HFSXOdV9XxYLZieA==
X-IronPort-AV: E=McAfee;i="6800,10657,11687"; a="71098914"
X-IronPort-AV: E=Sophos;i="6.21,263,1763452800"; 
   d="scan'208";a="71098914"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2026 12:49:03 -0800
X-CSE-ConnectionGUID: KzQ9JuHZTKOdBCj2j+x3iw==
X-CSE-MsgGUID: DSxTCSMpQbGY0O0gUzZ1sQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,263,1763452800"; 
   d="scan'208";a="240214329"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2026 12:49:02 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 30 Jan 2026 12:49:02 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Fri, 30 Jan 2026 12:49:02 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.25) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 30 Jan 2026 12:49:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i0hr6Qi2Fa7MEBVNlrpR0AgTZJHR6IMekJMwLrHyOxB5yzw5rbO6H+lbby6Z1UaYMyOolxnPDDhkFyXHaVKaP3ZClhCXW6ca4lW1vAk2SslnPSfLpmCZU53/gT3GRBohWLgz/POYpRJEPH3YB+VW0HRTnE8h8lFfrG24RmoGRGH2TVZe7W3w5J4UBjCC+jAPtEPIdoqoQdYKGKBeJn+WGRV/xslP+VeDV92Ds2lqWeeFLclljWkESRq5s11IM1Lh838tna+ni1CUEtk3PBNolfjntWlPWg2HkGFCCNPx7p+igdScif0CEmXw+pSy1hCRwDn1Nh1Tp6yqIC13PN4BUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rnbGhtU+P7IMGGzAulH3vu1oybzGDQlQ5ZBKZGeimJo=;
 b=DROZuXLilkyj4WbtVh0W1pMft3czbcnskpmwK8P2qnkQ1tFKkvnn3GmFAX6NGXVgom2P7X8BwhQE+T7paW0rcLgJttAG4snYq9KV2Y8Sta2fgFezg1aLNHCWSEz1407GwfiSY/wWsjR/vupFQrvQDd8FLaamNgbUuQrAO7Fc5YqjJ0+/sCBcUBkO1WWRbKSCTdqNpnKq+nPOwWxvKHuBRnSo3/GZXPHY7mkQKIw7vJ0gESrO2FjdZjo/raWIwHWfkTguGWErBPXPhBIssPTYBXWfP+K5Wsp86e8+F4I3TwCa7lA5xGjUEWA7a4ksDJqEc3zT+AJuKW+n1LZaAeeMuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by PH8PR11MB6682.namprd11.prod.outlook.com
 (2603:10b6:510:1c5::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.11; Fri, 30 Jan
 2026 20:48:55 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::1340:c8fe:cf51:9aa2]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::1340:c8fe:cf51:9aa2%2]) with mapi id 15.20.9564.006; Fri, 30 Jan 2026
 20:48:55 +0000
Date: Fri, 30 Jan 2026 14:52:12 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Li Chen <me@linux.beauty>, Dan Williams <dan.j.williams@intel.com>,
	"Vishal Verma" <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
	"Ira Weiny" <ira.weiny@intel.com>, Pankaj Gupta
	<pankaj.gupta.linux@gmail.com>, "Michael S. Tsirkin" <mst@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>, Jakub Staron <jstaron@google.com>,
	<nvdimm@lists.linux.dev>, <virtualization@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>
CC: Li Chen <me@linux.beauty>
Subject: Re: [PATCH] nvdimm: virtio_pmem: serialize flush requests
Message-ID: <697d19fc772ad_f6311008@iweiny-mobl.notmuch>
References: <20260113034552.62805-1-me@linux.beauty>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260113034552.62805-1-me@linux.beauty>
X-ClientProxiedBy: BY3PR05CA0002.namprd05.prod.outlook.com
 (2603:10b6:a03:254::7) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|PH8PR11MB6682:EE_
X-MS-Office365-Filtering-Correlation-Id: f7856bcb-456e-437c-4789-08de6040fba3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|921020|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?SFMUPGLZQPM0s/dMjX1rCdChzHSjOXTnj4+sNv+a4jKW8WEhbdmyj3JacIpN?=
 =?us-ascii?Q?3833bp0vsHaOaICMkx/8iax3YkInTv+4j1Z5NC87P0lJBXC3QcLDu2eyOC4D?=
 =?us-ascii?Q?GH/SxuCLxVUPTym5FM8V1Kk53A2MvVavBRee75+nVyU8jECOvy8sY9Fghbpg?=
 =?us-ascii?Q?S7a0cSFTb4uW+kMPt8tsfURbvF5U9krv0+3BPkgIaVwcR2AHZExiyWw6HI6M?=
 =?us-ascii?Q?zR++JUFAVx3lbWLDRSfR8M98WTb5zM8NFQjwJ7XywYIx1+sqVUPZKGChNK/z?=
 =?us-ascii?Q?otfQf21B7mrhkvOJvaq/hh78LNsxef9H47CRI8v8jzqY9FPO/nYnJbE0RtWY?=
 =?us-ascii?Q?HNgDky5EOZuyRNIT2BRifdQMlEfkVnHSS7dcx9kkEjt4n3Mox9darGfVtZKX?=
 =?us-ascii?Q?eJAuVd7xh8K2wEYAfE+yXnD5z5O/+2qACTkyU4cXyxFiBh6etWmdJYIxRe31?=
 =?us-ascii?Q?kAtmzozCWvhwkKmGAfXWyejCcwmuqveISMpT5G2QMGXZ00lupOmFfRfHyYqv?=
 =?us-ascii?Q?BM/cHrUKf8LnwTW1bmtaaDhIShSaDtnvBK+LgW4FztavDk67PGR8IEKXHD+W?=
 =?us-ascii?Q?E9ovcDRJBJt4+yyDkzyaCrAeKT7KZdi7Of7PFgEDd9oaTEZDzDgx2SVMY3Xe?=
 =?us-ascii?Q?mTvKOfsdoX5GEPLV8IVbK9iw81ldWpKI4WpvH5OQauooUFKmpp4MnmipkI6R?=
 =?us-ascii?Q?3F+BcfxzDPVpHf18NA6yxJY7zozF9R1uIzganVXRLk/UkxxAzJpiKs55JDDG?=
 =?us-ascii?Q?LcETb0hyLU1Z3vOIkKqCicreUIgyN0O6ZxrD87UsoXvFUsw4fm8TJ6WrL4fk?=
 =?us-ascii?Q?5ViUMiyv3L0hgfqAj+xR+GFpoD4d74EBUj0iks0LnnPkd+S6LfWvMncEGBgL?=
 =?us-ascii?Q?1NmBjnVWKH/LkFTFbtJkOdYyqVB5OakYLyfgJcH2zp3FYmrWCYbqqp+98hq7?=
 =?us-ascii?Q?UAhHNIOQW1kZDAXF/N6cTlAm7dvPHfFYyUtYQhJQtN2Ijslr3Dz0Uh4mLvBX?=
 =?us-ascii?Q?Y/b4x+wF/LoYywEfVkOCdNtcYzSp+pBuiikRZj11d+joSs4b63GDb7e8tiRl?=
 =?us-ascii?Q?YE9GVhRDZaOeXOJ6UL1dH/Srr47PNQmd+V7IZUuuENjbQ8EE5XMQsXWniXgP?=
 =?us-ascii?Q?Ofz/r1ujAOh+HEUn8mCZmbkPAycqLNKijMO9zyqFF+qzpkcRDKNh287lqVTP?=
 =?us-ascii?Q?ppUBCfl2HszT+W+PklWHEy/6W2O7VZkDasqvh0P9Ps0CmszphDizEPHSYqVb?=
 =?us-ascii?Q?W7sVDpdsHRR3fP9RZRj2FIIUdXJ0ymFnyTvnHbeR2D2x+ZxXE0Nf6lcAU1Xz?=
 =?us-ascii?Q?ct1U7xAMo4I9JsC+lTASVPivLP8vn5Qq/0RKjhX2+G2JOyr77JKLAdSSnioe?=
 =?us-ascii?Q?iRZCR+AXrJ/oTav5jIfX6io+2ITs88+uuuoIwkGIbfh/s5gPdF/KAl1bz26e?=
 =?us-ascii?Q?uNXyuVhAv6kJbaAt1+sspxhkoGZuFi/crWDpJ1kV8s5OV19BR2jplRvpCrlY?=
 =?us-ascii?Q?i80WkOklwdO7veQgjIYN/lvoVZjQQY3fPY53cs0VdoIQQQ++c17T+VyIjy6a?=
 =?us-ascii?Q?A8KKQa+B51oOezKmZlyTpTu4j6KsUgkdEZwORMf5gcWJNF69MjXn0mbXOC7d?=
 =?us-ascii?Q?wAJQUUjiEQ5qVLifdCl32xM=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(921020)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BCGo35jXknLwVkf4QnIr/PWJbZWfCagl4B5IYG+B+4bSlm+m7P3IOe0RDF/W?=
 =?us-ascii?Q?pFlVdxljlJNizVjDw8hx+BOJNTVCFKJ7BJhQG+OHR5/r2e9L6tlU2mN1TISW?=
 =?us-ascii?Q?rvDfkOOIWEfaq34T1qMVY0IdGinwrBF3AERLboYtJ1CxEOIZlfa+yxKkQ4em?=
 =?us-ascii?Q?McbP97FEF9d/Z1x/YnA6wQmrnFDXOzdjUvuVXKkaMLiLdCY1s4MGR6lI0ifh?=
 =?us-ascii?Q?am2oGv0daboR/prdJIa9v32V5NeFLsRme61EQWvUxUe5S1GN4Cuq9V9Du+cZ?=
 =?us-ascii?Q?9uduWLjDIqy+tay+d0rk/BRbGMldSQC54gnRQ4VYSzkkd4/N5BNitp3ucWeR?=
 =?us-ascii?Q?HtfqmlYdZJ6LTbP4H24tVZQ5s8g5zJrgGujekxqr3SNJwkf3yAkwclP/SzfX?=
 =?us-ascii?Q?ehlw7AD6r9/Du0sFkAcgGlqZiZVPwe4jvhVIt/JMN/BOWZ5E6lknh/op5HOs?=
 =?us-ascii?Q?0GJrB+t7m4g0lyNMldTNK8NF8sk+TiWRQE/uh1jleCGoqpKytWFo4tEXqzb0?=
 =?us-ascii?Q?k18Kt0wE+5Q8p3HCN4WVDHT5GsuMNV/R4hJmVFd8/IvpNHhOtcWWGbaZvfGv?=
 =?us-ascii?Q?3OG+hoOqIEFk4jg0tQ4MDf15So6dH6tUlvK7+7mCSqHnJBaExgR7pX8IqMhi?=
 =?us-ascii?Q?dXdFtLLpAvMn6S6BpK0Rlp5zsJLvcheAd+RLBxRNnendmOD3MtYVdZDLHE/v?=
 =?us-ascii?Q?lj0whwTW4LgnBSVAyNsNP+2PFMZmKh3qjD2dUGDJbwZ8dIdGisIix9SlEBZ2?=
 =?us-ascii?Q?BsVYDFtnUAYX7hnPDr016vKsdHEiwRHlLPDnpSCl+KRU7Brr82YFsHFmNemv?=
 =?us-ascii?Q?P4GcdU66QV1P0lpdKiLr/i4vJowpWA1FpSnhgnfVPdv74rCnJJ3gZVsbLVKu?=
 =?us-ascii?Q?FydLIB7VYaa+RrhIR+S1n1xi7JxDuYW6BSD9SrVBrOusZWQhynFVGV8GNfFx?=
 =?us-ascii?Q?t1Dc6aOp4uY9ijnof3ZStcDkv29vmQLgDRq+HYqIBctCX7mr5zcjvwvO+9NF?=
 =?us-ascii?Q?2i82YZ6BXFxOp22gz/MZt0rxWam0+VREnfIr4TEpBu8rdWaNm3E3TrVlQbg7?=
 =?us-ascii?Q?kl8iOCEZpgzerEX7Iszv9heZqFiGqtETTABimdALBaUWVhjvYKUtXjjTwsNV?=
 =?us-ascii?Q?aOxl9LLgbo1Gv50hAEyEqr/6Ga7+tZBaTX9sSVXWn5obHx1wAZ8RqiMYJhDy?=
 =?us-ascii?Q?s8VjTlrzDsc5rVA3ERdUCoOmpwfrM6hfy2FYzl2kQQK6NwMBMZpkrTXTWC6d?=
 =?us-ascii?Q?l89hotJg+wz3Wke9w2EUqomC/dreHwHdPXxVWN0lPOMGtizqOsdNZrbKFJwG?=
 =?us-ascii?Q?0VLWbTfGcLoe0AWQEI4ZHjZiKTPeL5vmso/MrVAQ3Z9bJ5V/al0nd5vJ4kwj?=
 =?us-ascii?Q?vp+DZCXETfoBavYU/kofTxxgwZrbsfPslWL1UX+P4p+GuUx94a3H5eKif2sM?=
 =?us-ascii?Q?mcHDGrKCD0pAgtwmKVLnDnZqjasTekdI1HBguOnqGusjzuRPjewjSq7ruDwe?=
 =?us-ascii?Q?5wSaNh4/XgSoaaQ3YfRW9gQ8HcUNZysKS7DGBVi6bLdH3nWz/chS5LFWetZ6?=
 =?us-ascii?Q?pwqtuvo5HBxyM09xA92U093WCkTCGMe7WHic3lVgp9dOFxM6LiQv9lmK98/u?=
 =?us-ascii?Q?NzD0shwllLENRZSLtr5OE9QCBVWQamTnqyVKRU6LpIWHz4g0vIsE4UPRq4TT?=
 =?us-ascii?Q?5VLI0sSp3PyI+CbkNMU1FF86tXiw+NlkhUEs30XLG7lTVqTpFlIShE8aRjyJ?=
 =?us-ascii?Q?RWdyZ3BqzA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f7856bcb-456e-437c-4789-08de6040fba3
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 20:48:55.3187
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JXsJQh9dNSC+Opau4FSc2pqCrYMjoWhLn/zvNMGUZkl1bVFCXsKYhh3iDCi634iPUvqVw1rrOQEHr+l1sh5guA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6682
X-OriginatorOrg: intel.com

Li Chen wrote:
> Under heavy concurrent flush traffic, virtio-pmem can overflow its request
> virtqueue (req_vq): virtqueue_add_sgs() starts returning -ENOSPC and the
> driver logs "no free slots in the virtqueue". Shortly after that the
> device enters VIRTIO_CONFIG_S_NEEDS_RESET and flush requests fail with
> "virtio pmem device needs a reset".
> 
> Serialize virtio_pmem_flush() with a per-device mutex so only one flush
> request is in-flight at a time. This prevents req_vq descriptor overflow
> under high concurrency.
> 
> Reproducer (guest with virtio-pmem):
>   - mkfs.ext4 -F /dev/pmem0
>   - mount -t ext4 -o dax,noatime /dev/pmem0 /mnt/bench
>   - fio: ioengine=io_uring rw=randwrite bs=4k iodepth=64 numjobs=64
>         direct=1 fsync=1 runtime=30s time_based=1

I don't see this error.

<file>
13:28:50 > cat foo.fio 
# test http://lore.kernel.org/20260113034552.62805-1-me@linux.beauty

[global]
filename=/mnt/bench/foo
ioengine=io_uring
size=1G
bs=4K
iodepth=64
numjobs=64
direct=1
fsync=1
runtime=30s
time_based=1

[rand-write]
rw=randwrite
</file>

It's possible I'm doing something wrong.  Can you share your qemu cmdline
or more details on the bug yall see.

>   - dmesg: "no free slots in the virtqueue"
>            "virtio pmem device needs a reset"
> 
> Fixes: 6e84200c0a29 ("virtio-pmem: Add virtio pmem driver")
> Signed-off-by: Li Chen <me@linux.beauty>
> ---
>  drivers/nvdimm/nd_virtio.c   | 15 +++++++++++----
>  drivers/nvdimm/virtio_pmem.c |  1 +
>  drivers/nvdimm/virtio_pmem.h |  4 ++++
>  3 files changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
> index c3f07be4aa22..827a17fe7c71 100644
> --- a/drivers/nvdimm/nd_virtio.c
> +++ b/drivers/nvdimm/nd_virtio.c
> @@ -44,19 +44,24 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
>  	unsigned long flags;
>  	int err, err1;
>  
> +	might_sleep();
> +	mutex_lock(&vpmem->flush_lock);

Assuming this does fix a bug I'd rather use guard here.

	guard(mutex)(&vpmem->flush_lock);

Then skip all the gotos and out_unlock stuff.

Also, does this affect performance at all?

Ira

> +
>  	/*
>  	 * Don't bother to submit the request to the device if the device is
>  	 * not activated.
>  	 */
>  	if (vdev->config->get_status(vdev) & VIRTIO_CONFIG_S_NEEDS_RESET) {
>  		dev_info(&vdev->dev, "virtio pmem device needs a reset\n");
> -		return -EIO;
> +		err = -EIO;
> +		goto out_unlock;
>  	}
>  
> -	might_sleep();
>  	req_data = kmalloc(sizeof(*req_data), GFP_KERNEL);
> -	if (!req_data)
> -		return -ENOMEM;
> +	if (!req_data) {
> +		err = -ENOMEM;
> +		goto out_unlock;
> +	}
>  
>  	req_data->done = false;
>  	init_waitqueue_head(&req_data->host_acked);
> @@ -103,6 +108,8 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
>  	}
>  
>  	kfree(req_data);
> +out_unlock:
> +	mutex_unlock(&vpmem->flush_lock);
>  	return err;
>  };

[snip]
