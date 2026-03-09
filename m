Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F20396D2B
	for <nvdimm@lists.linux.dev>; Mon,  9 Mar 2026 16:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773075314; cv=fail; b=SQ2AkgEJG2WDn6B2J1kxRFS6VC/8hRtHik0qlE7vd9P2Y5eekLfGGoH5LsB7r9P86EIYTmbkOuRqXQJ9F860kpxPMhrTWhoPM7Si8mphDQ7Ug9n42g5Nk606We10rOhsSB64Bip46s+4PuGJTUuhOA8YZqNnPY3TI/8vhofah7g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773075314; c=relaxed/simple;
	bh=A5e5+fewatQaWUowQVw5vxAOm0u3UVp+UvhTv9tFvVE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=T5FuXjrL45YxhA2iAScTWAeWWySg5LqbqEgEVb8Y2BCeT0LVpBdNtsrsnAKpKTI5inukoIR/Mibp08+p5kc7WhZ+2YIVEUqIQ7/+7iBYxXgbWIxFpQd4upEf/Bf+rdHu3BeUwDMegTHk2D1qQPbptBTseRSK/DcLDKLJMQyiPsI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ahQy2irG; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ahQy2irG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773075312; x=1804611312;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=A5e5+fewatQaWUowQVw5vxAOm0u3UVp+UvhTv9tFvVE=;
  b=ahQy2irGQAUqh5OqLpowcDjmCJD5mtvH1PQwkKiwCqa6qnzzH1jeNaf8
   HaygzHodcnP89vOSWAySjWM5weOrqw8gAfDQBj1wyqdOUragrF4o7Tsmm
   yHB5+VuUVrvjhnj8nHPyR6b3LOcK5kp410XYpUiRcOlKL3c0Z0KA+rZAw
   nXHFXcPxSYQYcTZiQz0/rT0I8KvNOsrm/MWkwfl+zr0GFYPzeoDKdzVv0
   ArSDoUXffhLuPJ9e66NwLnvqkylO6NsOsku4Z6x7SjDgnYb2bGZ3fWBM8
   RJhSv57z9mC61YNNcP03gC8bR3at/fguHVcGYmN59FIZjUX15TK6sJ69T
   A==;
X-CSE-ConnectionGUID: 7gOrBqzOSTiWOzWOUwo1sQ==
X-CSE-MsgGUID: yKS3gwABRUONrgJEtWakiw==
X-IronPort-AV: E=McAfee;i="6800,10657,11724"; a="96724366"
X-IronPort-AV: E=Sophos;i="6.23,109,1770624000"; 
   d="scan'208";a="96724366"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2026 09:55:12 -0700
X-CSE-ConnectionGUID: LrwqOYF7SImdhcF2W5umLQ==
X-CSE-MsgGUID: Coiff/zLQPa2wHsaXri6tQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,109,1770624000"; 
   d="scan'208";a="222469609"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2026 09:55:11 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 9 Mar 2026 09:55:10 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 9 Mar 2026 09:55:10 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.9) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 9 Mar 2026 09:55:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IKdRh87OMYp37kGwxA2Vek/FON7ByhAF9yaX25+bLFP9MOyqubSJWQQZ2LXNkqtsvoTvMXKMHTGuLByrY12cYMNXuWFGk6DX1fo2JmBFPjSGJCS4Nx0hbRMiwKIKk0eiwODUVmFRsWhWh3pPlAob/j6ugvLF3SvijCebQG/OKYCWekVNh1MsMTjSMmRqukJeoz7GUYWtk5ugigAppYeG6JxCegpFjQUTuDdV8RjJ44N/YLc4untokzfh4SdFrYxPGBeTWDblrLEfxk7wJaYvyfudTI+tkvmqnx1G0UL5lk3X+0rz4OIjJMiXOaOSMeFicdwnkZmiqfvRIKFoX65u0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=by/d+g+89TyZCP6oXpLcMJ2UN+2H4+B/l78uJvAJdmI=;
 b=oPvd2/qieb2uIQQyzpYns37jMk2QEVbOHdQcTTKsZH/ILtfocBWCWU1KV2EpqMHghCuF6FRSe/oMHXVRlKxGj7zWeRjAHDpTCoPL683hbCkJuXgYcv76wwgSGaUkU3CkI7Gd7gYZMZB39OpGilTxF/F7xvNi+TgrxJOoPrlNUJ9PztaFj0GPE+hAfDIl1fSLeXKwaGBYfpVcVela0hLjtNl8qKWO6V+61EvKfjmMGXc1edgUrE5Hpoxb3ZVI1p5GNneurj+NtcVfb9bnWibWb7UsrFIULgfuyseJ333lbuNdIfzhYBlAYpIPyK6f6ZMh9/e3FhINMINdMROcwYAj/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by PH7PR11MB7003.namprd11.prod.outlook.com
 (2603:10b6:510:20a::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.11; Mon, 9 Mar
 2026 16:55:02 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::cedb:24cb:2175:4dcb]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::cedb:24cb:2175:4dcb%6]) with mapi id 15.20.9700.009; Mon, 9 Mar 2026
 16:55:02 +0000
Date: Mon, 9 Mar 2026 11:58:45 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>
CC: <dan.j.williams@intel.com>, <vishal.l.verma@intel.com>,
	<ira.weiny@intel.com>
Subject: Re: [PATCH] dax: Add direct_access() callback check for
 dax_direct_access()
Message-ID: <69aefc453438e_1954ee10015@iweiny-mobl.notmuch>
References: <20260306230507.2149965-1-dave.jiang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260306230507.2149965-1-dave.jiang@intel.com>
X-ClientProxiedBy: BYAPR06CA0010.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::23) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|PH7PR11MB7003:EE_
X-MS-Office365-Filtering-Correlation-Id: ac01759d-8703-430e-4541-08de7dfc9b35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: TRuSADpnHBdPOuHq1orfD3Ia63cn46ntxYCZIcWE3tF9gkxRKLwBkwoeT266/09Q6ni1cnG3UI/z6SVj/8Ws/aXP+EuU8pQqiCJbpRPN9dzUhDtiy6FEw8aj9XrjwgMPvKM4ADgsBylpP2jw63RBLIHe/ubT4FBVfSuW+32iGpM4zhoEfMojdR1cBtvw3MTH2zxNfLw9QlPi+ZbkdsKIMjMDsowfdA2wANS+4iNLL6syTZqHz8j6zZC3O9V3gIEwFnhZeQzjN01cPdSXk7wkW5S26oQo6vglu0NYXjzFuTpJhZv+7Aso5m4irqjUrmk26J35JxkAlGpiBaXzs5yDRaikxDYKYz6inJVMimLpNbA44JhoxzztqSABKmtUEbNuE2EMv4bHHTpfZ78ZGDre43s/1gyFr+jekM5/ySSe/TwsziwCFP6QpnX8cLblDPkDAMrNTAEnG2f4yFCG3hUjUFAhVyV3qqDHfb7qH98/wUEo7cczCeOJ/ZhNq8vTueQgM2v1S7YkK5EnJ/WPwsQfE4BUSwAMD5GNA4TDp839db2grAcGvJDizaj78GWKwPA/GIg0EdE91hJWzrzezqKbx6QR2tUdLlzpsC5SdcAJ4AbL9jDoCuDWPHLJFqZ92FYum/YXwY+kRBReOmDDHQa2p6prYYdzjYyPwULHeohYYyf27a1OtSlfZDYIoExS4FNFNJaqPDTmwkRPxD4GHbJZ0Rd06loB3719oosCl54DoUU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pBs4LbP7dorxJm5jstrYIUAwljlmJdt7BvZAcGYUPKCXAnyLB6upb1mFm5xB?=
 =?us-ascii?Q?AyeTOydeZzWdGX1JB6/k4+UQKYTy8ZkCoc4KRgvbjUXQiDNzPUyzrV9HgnRD?=
 =?us-ascii?Q?Xp/+STvDIRKyDY0ttGePJ1gSJxtsKST8ERw1N3p5QpFgTKnnFqVwfvET6fOG?=
 =?us-ascii?Q?+d7e4uXahe1Pgj6aBZdCsZeeo+N2tgr4BPqHC9j9JPXiWLlcGekFWhH3M7Zn?=
 =?us-ascii?Q?P/z0zCtf16Dvnh3IyP5g3DXCXiLMo/TdhnZOGTUyNxHh8F/3fmoYPReFGTlx?=
 =?us-ascii?Q?DwE5sFaElGw3LCVxCTF/jyvctt/9Cezb2lrOTSRm6ulMAhs3rJddlM448geq?=
 =?us-ascii?Q?VtU7e13bd2KFFBEXiMDM37FltQ0f6ac5mN7hFet3z0kl3uNcOHxHJnOSf6ta?=
 =?us-ascii?Q?BKzgdCmZ5u6W7llbz8GC6p65FLWBFWbhUmvn4GGX8/i3rnwy6P81KobgDdvj?=
 =?us-ascii?Q?E75XgvJKvSlUyAGUWEHS4hDE5U4IrR2jX10rlb7xuTVZy4X1N1ESXjkugby2?=
 =?us-ascii?Q?XkkL7ZQ3nzG8TMJhwKp0ydw2Ex6ikIBfZvrehLsrVpMsvst2hzG2NouhmKha?=
 =?us-ascii?Q?svu1MMp0lDMoy/BsNObJI1TESpnWDGP8Nqnx26iZX1TIICESRQkDfacNEJaV?=
 =?us-ascii?Q?vbG+mCfL0IDrZqYstGp6rE2xE2tkSEcVr+XdQlk2Fs0HuWw58AN/LoHwVWjj?=
 =?us-ascii?Q?+CnepaWEI6RdC+w69Y/8fF77UH/FZtLNbbufuetC0NBhcczGnMsW4yAf8swd?=
 =?us-ascii?Q?Duv0C69dZSCfBfXQGZYImPGRMSnaZhyNSS85cQquOfl46VmxPWpzXvcEEmZH?=
 =?us-ascii?Q?N9BIrWJJ456OzXS/CMbOh2jqh2r5q4j3hv79jhnnyeTgjP8vf3G1Tm7+nOi4?=
 =?us-ascii?Q?axatmUiGvRjSV4cvFjgzVLmDyPhXX4QBIzfmyOZnEjgHLxuXmihK8xvTI2YT?=
 =?us-ascii?Q?LQuu8sTog89NfeNyqe1BW7ykE5e7ELcYJjBvI6KD1Na7hv93u7BUKQE778p+?=
 =?us-ascii?Q?0bPeeoru2PYMj+DywOCrjx1qnGopoTjGgrpyl50q+bHQRtGWJEOdOs3mqzHM?=
 =?us-ascii?Q?r2BCiADQj9glLRV+u+e0Izpd36kHTn6XRrDi8YiS1J+gq47oYHMj7pqWnH9N?=
 =?us-ascii?Q?GjP0Q+NgCMue6waYZCweshzq2TZXHASYmqY3h8pf9ZQUN5t2RZBhBs77BcVk?=
 =?us-ascii?Q?dtsldKdeWzgoeyj/dC0Axps1PajvTnQqGXcECFSooER8V8YLeWBGH/FLUQoP?=
 =?us-ascii?Q?7lZj/EzoB6nd+bSKmYvXusfXFuEbyc4qSzO12Z9gwCufkrE3WscDdXldJbtH?=
 =?us-ascii?Q?63aKHX7Myqun5JBpcm8ZUezDKU9gelCgRi6DdL4TQ4OnC6OUmnSfEYqZHsqK?=
 =?us-ascii?Q?KERJwOHa4Ln1WCI1+3d0+aYhEi+niPn3PgEjmRe6MArYCvwIHL5l9sHZh0Dt?=
 =?us-ascii?Q?lc56lZmU5tmQgGR0sp+rzOy3mSPxmikVgnyA8sTli4Q3E3Qwd7vA5DStFAS0?=
 =?us-ascii?Q?lmtCPUCX2CM9bk/jyYRGwrhV0ZdeTygUmXK7RJaublz2XEAN46Wxb7kWxyLc?=
 =?us-ascii?Q?/nPn8wLygLt2mvl76w+77SFVyq7Bk0dpP54f5sN9tM3gj4cthX2lHEui1TQi?=
 =?us-ascii?Q?ecY8HcXoC6II+U0ELS8yz3BBQRFaJSizUSp7pjnDH/0QTXN2YBYNh223Rl/5?=
 =?us-ascii?Q?d+VA0KWFkW622IE375dI9NI6mEb+8ahIjkK7pVlZw3aZLIvq2Ua2bpEsfBwH?=
 =?us-ascii?Q?cI05dZxCIQ=3D=3D?=
X-Exchange-RoutingPolicyChecked: Aj83tQ3ZKxiDgOc6ystsJMOoDcS4zMMuNfKd8LqK15wW/7Cb+No9+5a/t39kSex8WLsOV5Wq1z2NQHwp6hKcQyyR1rEDrBnkQjnphUmfXApozMYrxaQrAtacDEOkFCvH6Hsfyr/JgUzOjdRBcYilbdM2i3Hp6aRH7ns6Z+UtURAKDIK5IMdEJmT9URR1kfF5jFh80YynfVlQ07lhbHkOOpQVs6fAFjRvCStnej+p3TZoRHe+/xfk3flt5sLaSP9dcwWe4fRyjS7pmSKLDpZfoYEVE/jDnP8lTwNsS4kWw4CO35tFk7KJHENsu8bYWY18biaH6D6QaPdf1U650eA4WA==
X-MS-Exchange-CrossTenant-Network-Message-Id: ac01759d-8703-430e-4541-08de7dfc9b35
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2026 16:55:02.5150
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aqEP0jNZS1v+KyyPk0Eb7F5ErSUbFilMN3ymFUysZWPio4VnApxnGAj7gdD638ruFoVhK3O9HArtkXeXv1ok+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7003
X-OriginatorOrg: intel.com

Dave Jiang wrote:
> __devm_create_dev_dax() calls alloc_dax() with the ops parameter passed
> in as NULL. Therefore the ops pointer in dev_dax can be NULL. Add a
> check in dax_direct_access() for ops and ops->direct_access() before
> calling ops->direct_access().

Doesn't this need checking in dax_zero_page_range() and
dax_recovery_write() as well?

Ira

> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  drivers/dax/super.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index c00b9dff4a06..5cebaf11a58e 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -160,6 +160,9 @@ long dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff, long nr_pages,
>  	if (nr_pages < 0)
>  		return -EINVAL;
>  
> +	if (!dax_dev->ops || !dax_dev->ops->direct_access)
> +		return -EOPNOTSUPP;
> +
>  	avail = dax_dev->ops->direct_access(dax_dev, pgoff, nr_pages,
>  			mode, kaddr, pfn);
>  	if (!avail)
> 
> base-commit: 11439c4635edd669ae435eec308f4ab8a0804808
> -- 
> 2.53.0
> 
> 


