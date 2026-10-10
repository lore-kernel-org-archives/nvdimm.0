Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F6D381E89
	for <nvdimm@lists.linux.dev>; Sat, 10 Oct 2026 01:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791597389; cv=fail; b=aBVLZztresKs7/o+VWsr1FHePaW5Drz2wicYACPTcfVWf/egPkkDiXkZxn4lTz8WFf3XN5GwYmdUzZaGx74wA5DpW0hztrk3tzyQgxKQvXdojPNVuRN7kSAURJS1f9McBuPUc+6rxoR71iKDCPdvtOY2J0J7R0fVOcnE9HGK3mE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791597389; c=relaxed/simple;
	bh=7PSpLodZMdRZNLyk/9TDT1Do2oTdEt9AHU9AqJH8hWg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=nhXF1u/6Z4+TqjrrKrui89Og1yFdWTekPM4KukFVGUJxUjzBZhZ5sa5DB/KjLqjsiIN04JiiBR24YRXrfPaL6WQ4Wx/R+Fq3TleJG2KCXtEES2/c8SvVa+be3s37TO7/Q9kyHy7swWJwJOAT6B4NuQHz6AVUmWbgwkBmU0z5uyg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y6AM+1pp; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y6AM+1pp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791597388; x=1823133388;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=7PSpLodZMdRZNLyk/9TDT1Do2oTdEt9AHU9AqJH8hWg=;
  b=Y6AM+1pp6YpEw6oFKsWn9ciCgAz5hUuQbEIxYklDxcmnSRtj6/xZECTn
   LOpMQ7xmC0qj0BoJYz6DJRud92vmZzd+0D50lwjhaF3V42I5tAoBAwWXH
   r8oM1ONIMyLSqTM4xso9ow4n1EfSuBL49Mq1u5ysKGZAHYNqD6/4ERZjq
   UjrAvjqW8GWtEbIq2IvxQrZwiirLvBsHaS4+/nkO30mSaTk/tG2u+xzPk
   RVb9WcjwXZEZe5zve21i0UaOkAsN1IKsG2qyxJKHCaeX5fU5n4MS67Vyv
   b1MRJKyeqUgVAipNwuKzorz7yC35+i3JdOTa6CCVGXqwfxdIoXXxm3QeQ
   Q==;
X-CSE-ConnectionGUID: B0xavamqR3OXxgjB42Y/Sw==
X-CSE-MsgGUID: HV2LUnxLTJmjhq8TPV4cyg==
X-IronPort-AV: E=McAfee;i="6800,10657,11930"; a="509216"
X-IronPort-AV: E=Sophos;i="6.27,149,1787036400"; 
   d="scan'208";a="509216"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2026 18:56:27 -0700
X-CSE-ConnectionGUID: EiPqztpeTla44t/sUM8lDw==
X-CSE-MsgGUID: HIry3mbCQKymI5ogD6258g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,149,1787036400"; 
   d="scan'208";a="410719"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2026 18:56:27 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 9 Oct 2026 18:56:26 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Fri, 9 Oct 2026 18:56:26 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.65) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 9 Oct 2026 18:56:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cTU38u0KRme2KhdFvW8Bwl6T7/pwr4zpaHokodNWMAvM9RUIZR7F3Hgm54b/GMXjuUH5+1OLvi+jIvPtzDpuA5VdbPmhMgb67vtoo19ruWuTHqxCoeHPjvox83yZX0kryCleiq2uLNRV2v9U+GPXmIgi41jRvtdnxHb+2eKCkz8QkM1OrHR7VGnUSF3swq+98Zx0bXRj/CQU8QAER0USx3R7Ti7RsTigK52w2ubbK6MRHmDuhH/GZAMq/muDl7ib/Mcpd0fmn3/Y+F4WEx7i9jQQfnVDK1O9XxiXB4gY2fgRMx41TNYtVwHmFBFXASBUmzToO0qRIo3qOGoumbxtWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D/XLmv7h6L98BxqGmzXcZFwQl5JmmUY5hgRPGMPc9Dc=;
 b=KwUoii63Wt+iEwiEXPkn7tUpDdBprIfYUWM3JX0iOPJOALxGS5tGSGw7etkiXLprIatXljZTx4qhHnq2G1+l6wuK1GGF7o4TEOQKTcS2Bppdzp3AM/CaztmSh3rhDvhMjyO0TuTM7i8klcBahNJdNm1q8Xk8ORhGpVdtUVvSzLQ1gspKasAH4YtH1UWlPpdOOOq8x+zlAdR0Hm4VFeT9aB64Mc1TsqbwxJza/1nC2qPIm8wcV8Nm4QvwifLZlbRuTcZxPxVt0wvfdUmSzmw1KCCaS+pFjToQoq/c3nVUThXE75uSNAO1+gjEy5S4o4oHxJnTvNuFJWw1C2aiSh8cDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SJ2PR11MB7520.namprd11.prod.outlook.com (2603:10b6:a03:4c2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.35; Sat, 10 Oct
 2026 01:54:33 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0496.017; Sat, 10 Oct 2026
 01:54:33 +0000
Date: Fri, 9 Oct 2026 18:54:29 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Serhat Kumral <serhatkumral1@gmail.com>
CC: <djbw@kernel.org>, <vishal.l.verma@intel.com>, <dave.jiang@intel.com>,
	<iweiny@kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <error27@gmail.com>
Subject: Re: [PATCH] libnvdimm: Handle negative return from
 nvdimm_clear_poison() in nsio_rw_bytes()
Message-ID: <asma1W7snCJkrR3W@aschofie-mobl2.lan>
References: <20261002165641.14479-1-serhatkumral1@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20261002165641.14479-1-serhatkumral1@gmail.com>
X-ClientProxiedBy: SJ2P221CA0006.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:a03:5db::6) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SJ2PR11MB7520:EE_
X-MS-Office365-Filtering-Correlation-Id: 118ff266-0003-40b1-41f1-08df26716e40
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|11063799006|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: XrZcHSuYj+xBoQc/zOqQqSRlbJ4gBGBfZwc+KGkGXp8zYejP+AsOm0rCOKh95RAo93eTbxpiQf5pFi1KIST9BQaWuZa5qtEQIP63dobmEsAn/pywMqy0PU0VnXp1wcmEvMQEMAUrMMMADgViFsZQ/+1OaCbxgxh4lUXn2PYxJTRLGflZqkfZSN5gd6tGffn4nf+ZXwuTKWiHmQ2tqwNL7iVRrM8ezlCMy/vGTEZizNlM5tWqkXOi0caW9SXOR/wS/hw9Qfe1aq/la4hIc1SpexhysAhudn3jnvcAD4ykxGocir/AppSWAp+vWrDIiMFi05MZaUp89mdYSRfdqLMtXlEmRNoNeVUHhXm+6DYFgEhfAGsja+2J08ikV1qSTGG68tUhhlDvsv5OZfCDofaHPyqMo0R3zAe+5uw0Y/8D+5TqxmdW6HY3WkDmy86p3U0KZqw+6e1FHj5ExmthYoi9KiBYlFd5Hm8+LFE3WA4FQLrE7gQX7H3bgQz1wxbTz9+ZkhMUgiOw77ybgVQWfmfya4ssmSJ0BR+QRe4U7hiNSX9aZA9jDduEhwXTD+r3uDSxbsSsG1tVDNsyDIbZm363IkjI3Uo7Q7IKPzD4IubVtrG8ejF+t2udD7ZFlcF1GW4HxRmN16aA2+vw78oGfnmRXjgAKHxo222dJUrcjj1l8RA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(11063799006)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yDElu/n7lj6ndVQ8/dNNnyMTW0gX47nTlbm5WMZqlZJIu9ZYK1KG4cA2kURk?=
 =?us-ascii?Q?hIiCUl5OlXsYwsUtNi5D/MIBsC3j8vCecpFIfIhUX80PhOkVVF5PPkzw6+iL?=
 =?us-ascii?Q?FJYudb5bBn1fzJtH61n8mNGsWyV3Rjg74I15DiIlltsXnqAsuH8tpJvL6mO1?=
 =?us-ascii?Q?BBkR+zxgHC1HwYXNaF0dCim1Ju4OwNuZMGFm4PvqgSCRfZBffs5HjM9xdcPt?=
 =?us-ascii?Q?Zp+CS8Mi2dV0JpC036B6aVn3IPMFO45T5w2gKMPF6ZDb1gzG4SL45TiD44rA?=
 =?us-ascii?Q?b6R3SHZNnwQbVCAcIJpeazSxW1P3Zb44C3cq34VSejEY++R1KO48fd/DArHv?=
 =?us-ascii?Q?YgfkdEcpxemEdhYJQU9HM7D77uBQl/YC7QvGzGvUZQTrxy+9Eh7KcJBccxvk?=
 =?us-ascii?Q?iNBzlwALWDBZfXvr+62iVvVdskoL6a5RGHFWKeik0eG6SSUhu9po2m6VwJ9t?=
 =?us-ascii?Q?7Gg8Knwjzer0tw/HO5QsaVy7KiRiajnKX+lLviRyaOgarXIePsWxVkU6QueF?=
 =?us-ascii?Q?q6M5Jab4leqTCcUzCoVH5GODob36jiyM+BrvrJqWXXTqJUJuOCj2mxB/aP0q?=
 =?us-ascii?Q?QRoWmM711ahkigxOzYF2vxoHz33kNJIJZaQgOLybTBnmLqQNkeawjfXex56M?=
 =?us-ascii?Q?kh8OelKhcj3m+2j7GXTJRfjjVakLTyRsBCPhvbpATavn19E7IEAfveLr87Oe?=
 =?us-ascii?Q?wHY6wM96lP8lc3dO2eTpadV29/Nb4TMGmzpAwyyLngtaeBQBeyyhGVg1teaD?=
 =?us-ascii?Q?3t1nIjZ8n1q84KjqMIwUV9tz8Rn8tHBkm1zWqQwiIDI0cKpNkytRnNkcd/LB?=
 =?us-ascii?Q?uSzper+I8lr2/dtUtAPuPrJ/fIhgUjwJfCpdyF0CbKhgke679Q30VzfqXzvY?=
 =?us-ascii?Q?6YS5dgIx18Dn69Pyvpr3EeNp3xxtT2tynzKptw1sxqR3QzPCdRLm0N1l8WcV?=
 =?us-ascii?Q?f2ZFzZY4thXjtMrLnIHrB9Ako0PhI80W/9Havf0/vaHVQYe44evcC6Lmmb0o?=
 =?us-ascii?Q?VL44AyUKATuKoh3FaGQEwmKSX9w9sUdwFQ0MAmptjKazwG4hbMyUBkkDpl2+?=
 =?us-ascii?Q?+GiMdMD0KD/3PNkSzKqa8trmHW6yr9DkjKwDxJ6t1vblcGYY2O8FYux04LjZ?=
 =?us-ascii?Q?GukkQ0Dn9OigogycdS3X6daJLhe5KsFBAIuvqIVdrp9vh0T5itwginrdsoKz?=
 =?us-ascii?Q?K+5ggbrPi2H6IW6aykhSl69Db7zW7KIfzHneWR+pIjYAwki6WvNE78GjKIbQ?=
 =?us-ascii?Q?ZA4hKSjmZOe57H1te0dckwUh1v6fZeqw3mHfJbWQ5eAQcqWnnpR+uURxJ6BJ?=
 =?us-ascii?Q?N4exc03lvawe44Zt1wBMo0U6V9dV+9OVanRfbb7pWx/HkL7ZUMHXWQaq3pUG?=
 =?us-ascii?Q?CUya94A1mI7NLrD9o4RHKBFL6jCQg2EA2QOIEBVLVokhmNvxuBjBtMmUohhz?=
 =?us-ascii?Q?I6VNxo3hkl6PKq7kWS0b8EsnU6UIpG2M3loyfpoxeqVYkHWwXUBPY3Fwpmux?=
 =?us-ascii?Q?meL6GDA7Ot1NFeJRDUOGG6osl7R4YlwrZW8qTM3fOGvIzbMzDqlVCeSH2esm?=
 =?us-ascii?Q?G4UEY63irw72vS5CLGiPMuy2zRD6qjO2K/C/0a0pI92D7qu/53BAX45k8/qL?=
 =?us-ascii?Q?bHP9Z5H3KjNgcHiMVsbbmY/loc6b4fn5G7dGp2wkNV2FPw7yFyzTiX4YT072?=
 =?us-ascii?Q?+qeFVOk0LO6NFI+tzMfpKTkQdn54Zf3a2m+KPPaF6ZCfrMuA2qtZQxW/Jzkc?=
 =?us-ascii?Q?Xo/3dPmw43f+u1ItnIk1o953hBpdQfg=3D?=
X-Exchange-RoutingPolicyChecked: HkKEUrUBbqefoYBPtpbJ09DFtvRKlSDophcwF214/3Wgx8U7IqoxOco366aWozFO1jf0/ibRs7g5wZrb7FJOkVaZ7juE/YhLzuDMMd5JB9jbLg5WR+kbbMV+/L0KHJ6l+ys7xqfkmwSylCjmnq8R6fSTxMBmxo4C81oHDnT2zhyivpSwNG3iwrsi3MOSAAmANpkIkuqk86rMBl/S6a+0AX/KhQCylqpzBYPYu9flhsNgxKn+uh2nEoBkJGePdqIPVIaDATtkMDG1gU16BPetFWkD0oelLj9E/DRg6teMxjK8vz80u86iWh+76t0RilquYolPNdvRAZQI7JALZCmmcg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 118ff266-0003-40b1-41f1-08df26716e40
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2026 01:54:33.4554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mpc7QKALB0VfpALXdBmFTVezCvStO4cEVjq5j95+gdQg3NA0vvf3KuDvdgtLx31UG+R81+wBHsTiqypUoe/ZtE/IxgJDqxy8RBgtv1gjpxw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7520
X-OriginatorOrg: intel.com

On Fri, Oct 02, 2026 at 07:56:41PM +0300, Serhat Kumral wrote:
> When nvdimm_clear_poison() fails, it returns a negative error code.
> However, 'cleared' is a signed long while 'size' is size_t.
> The comparison 'cleared < size' promotes 'cleared' to an unsigned long.
> So the error condition can be bypassed and the function can
> incorrectly return success if the subsequent flush succeeds.
> 
> Explicitly check for negative error codes before comparing with 'size'.

The fix looks good to me. Thanks for addressing this.

Reviewed-by: Alison Schofield <alison.schofield@intel.com>

