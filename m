Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F3D1DA631
	for <nvdimm@lists.linux.dev>; Mon, 28 Oct 2024 14:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730125056; cv=fail; b=d1sNrn11FPX5FFX4jz+J1AA1Is1SNWmdhyskuq+8BsrHiMj/9P4umfjp7lmSE9HkXILc+Fs5Q22116sN7qSjxR+Ww41ldCIEwSVrYtPXlaAIR58xG0+UIYDdKUZh2i2h7LynvazYjp6HaBa+GS9xq4TGETOb4fjcc+iP/OHrjmg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730125056; c=relaxed/simple;
	bh=mQwj9WAb2ciXbX+sgnWcRW4ncH26bIWjUPcifxksYxc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=IBe+9KQS4Fc7xERdsYbQF0gGwiSbYk0exygCy2Q4+x0j9xmorlkqsoNlluw4K3RSghcP+bJWwZjSfEPuyerGOljhj/qbnrrRRBjHzoqifyJAO3IcokHsiVe+s5cr3BDT4I+y+5nXzX8SCrFAtWP8O21EV89POrEgeyXWf/yljz4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Tt2cOH3D; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Tt2cOH3D"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730125052; x=1761661052;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=mQwj9WAb2ciXbX+sgnWcRW4ncH26bIWjUPcifxksYxc=;
  b=Tt2cOH3DYdUC0Z9hKzc3yFlInNX5zjQQq5+Ynis/rvNP1SQcKGU1deFS
   DDl/xA1M8G/kVmVRtKcb8ks/yGQ6+uY9ovqJ9fi8Y9zJbDhRllKk9xKAj
   sVQ8RXRk4aDZ3HTozo3JmHQKoRnhWKRagIfdeYYM5BH0dDPlLWmI335Mz
   2SMBqDe7zTPRjR5qTlEsehRTsyKCEznGl1tgu9OolzkGk1IQ0Oe46nu7t
   4VhjWAR2LtlCqc1DgzC+w7kVq6kf8eZiAGFoZB6PKS6Lefu32Ca/R0p5I
   dCkExSUjB1LPf4puRfHee0myi54+a4weFrKMmYuHoQ5V9qRpzFNqKTCiR
   w==;
X-CSE-ConnectionGUID: 46CYB0HQSuaSEGi5/aNt+w==
X-CSE-MsgGUID: yiLEB2JkT++Q7rZ7x+Hhuw==
X-IronPort-AV: E=McAfee;i="6700,10204,11238"; a="40298630"
X-IronPort-AV: E=Sophos;i="6.11,239,1725346800"; 
   d="scan'208";a="40298630"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2024 07:17:32 -0700
X-CSE-ConnectionGUID: NSS1DZcBTW2dXPaZXOCzOA==
X-CSE-MsgGUID: f+FBB/OgQuymKDD6XdX9tg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,239,1725346800"; 
   d="scan'208";a="81250618"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Oct 2024 07:17:32 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 28 Oct 2024 07:17:31 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 28 Oct 2024 07:17:31 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.177)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 28 Oct 2024 07:17:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bWv86lkjjt1uYd/9GWjJXbf1dbA6rlPPQ6g7R/N7wbWSQ1ryf2nk2RQElzq2hOgH5hvtbO+2FpgouIq12dRxnnfzeXoccJu7j5ZKqUrn62OiBdV+/pUchRm7CFLmv0XlUTpZAb0ls+StbFeQxjCL/Lm3rvc9mJ5/G45ffpsjDAqfU2Bw9FAs3qwVDYWOhpwiOWbKQJ0714O3gYz0fl4z4SbkWRLnkFVY9U7b4jAuJFdCh+G+q1BJ3o5AO7mrIxpDelIrjlUHlmz+vyl7S1f2bjJ8MVmSdAhsoAtDnL33Kk8x9wk+xmtO+7DixF16ORZADBEvy2LRqwjMIm+r+Tjd3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jgNduiPWrG15UmlvqIjNOSJSxkBEdWeatPd7FjBqPmY=;
 b=GhQfZqkfd4f9MjzuvtBnL3/QUY9L/20kUc2YCp3Ulwmoodwk1ucQkfSsbNLk0MjbPB3U8tIrqROAJCrFiodkoReeeRT0fMyvl/a2w6CJbhgvk0A581r/vmnLE7t2VmAkzm5Rm5cYI/BWXa7hGzT1ZyH6rWoyDfDFVQrPAV9LBHJky24lQeb7IGtduyBq+dsgEKCr8iIq3w9xCiGEUOhDpIAhqulsTboxYhlrpf2rQvT+uZrQaMA4c0D8fPXuRTn2E8cs9e1ngvAJViLUTo0uJ3z4Z+KHd8Zjo1wFJGmM/108wAJmu1Z25PET2xaBszR+xamncUEYvbXkbMdLZY764w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by CH3PR11MB7724.namprd11.prod.outlook.com (2603:10b6:610:123::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.25; Mon, 28 Oct
 2024 14:17:22 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%3]) with mapi id 15.20.8093.018; Mon, 28 Oct 2024
 14:17:22 +0000
Date: Mon, 28 Oct 2024 09:17:18 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Yi Yang <yiyang13@huawei.com>, <dan.j.williams@intel.com>,
	<vishal.l.verma@intel.com>, <dave.jiang@intel.com>, <ira.weiny@intel.com>
CC: <nvdimm@lists.linux.dev>, <wangweiyang2@huawei.com>
Subject: Re: [PATCH] nvdimm: fix possible null-ptr-deref in nd_dax_probe()
Message-ID: <671f9cee9a07f_23f01e2949f@iweiny-mobl.notmuch>
References: <20241026010622.2641355-1-yiyang13@huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241026010622.2641355-1-yiyang13@huawei.com>
X-ClientProxiedBy: MW4PR04CA0346.namprd04.prod.outlook.com
 (2603:10b6:303:8a::21) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|CH3PR11MB7724:EE_
X-MS-Office365-Filtering-Correlation-Id: cea85896-bfbf-4cf6-f012-08dcf75b3d72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?tpFcgD37kIF6oSkhS/CUe03qDACizVJ+McAO9wkab2MN6oDJL16uXRPFcU6P?=
 =?us-ascii?Q?juD+RkUDRe+gvmfuOX9r4Bfrm0xYEQOpe8ZNC8bDsAobvrm9Jp+pFUDrRX+E?=
 =?us-ascii?Q?QSgYlNGTZ6xJ58X3cGzid+Ncr1pFFi+ExjQuxS2GIEVbAteX1jvIvqLy0D8M?=
 =?us-ascii?Q?mAeQAKfCE098goub2NXPL64lnTACZsHCAJu8p4aFfv7gC5Dz1WdVzguMdi3m?=
 =?us-ascii?Q?nMb9WgoO7UHLUaUWyN+IIp/xKxzqOwEqO24n/wvHVia4Qhza/vfMXQKvqfYv?=
 =?us-ascii?Q?ZofXxdX14HKdctR1mW/wFRaD8shiG1p2S22a1F3wj7ANwGhODKekzYb0zBeN?=
 =?us-ascii?Q?MrNo+16QMYugQo/FCE9e3bB8yfGhWBij/QImKwUy268JMTlMX0NqGOczkHv7?=
 =?us-ascii?Q?vewB6Sh/fCWcla+k1wz3eqbZDVsPqiYSMNqYHNFpj0pNbUqA2UaQYmhhI+7Z?=
 =?us-ascii?Q?fKYFXLkHsJ3fTlnre+OTMEKW4M5c9aghmyd1y6slSJ0PYDfZChkHoGpAn9OQ?=
 =?us-ascii?Q?MFHswrBIDjA6uMfcRVMgYK8Rocktg/BJKedv3qjwf1IVFSx/XwXVMx9QdZO5?=
 =?us-ascii?Q?mRag7pssz1ow9Zkgtq7BQlN8vkrKcxfQPcg8vOIfkKSip2HczrJdPYkMujqF?=
 =?us-ascii?Q?N3HloxfYeftOjHpl4lb1FzYRt/w8INBFKCfXffp9qsp3VvnjCc0BQUH5bNZ1?=
 =?us-ascii?Q?+PCLaKqH7mUCmSDujMK0rDGG8bIktsRW245H+ndmy3khm8EtCIh1/EK9adVm?=
 =?us-ascii?Q?miUb7tCnW7/sz/CG8ftYOBxmOiH9IrhA+afsLlFaPa2zSAccXJ9II/7rKmON?=
 =?us-ascii?Q?xHjEW9818dxHjOQ3cLZE0umctL7csk5GNoWNjySiQnMITWl8kfr11wsqrNFY?=
 =?us-ascii?Q?Vq4+rfxEapBK74OHNOaBGNAp58VG0LCu4krG9CoS5ha18PzqauzSxGg/mukz?=
 =?us-ascii?Q?9paedi/bBNEb9Db80XISjfonQtnCfevu/LDv8P4/psmBWh6kZLhgG1D/XT6P?=
 =?us-ascii?Q?L/nZp8aVjqcGOUPXHNF56r5e/rRXwhrEoPyUwQX/6R0zowB0joSSf3x8q27M?=
 =?us-ascii?Q?3K6JQOJpGFnYUPqrtHdk0FwWPfTiVqlGbZ+pa5xF8sDWwJSoKEiHv2DTVYVz?=
 =?us-ascii?Q?HS9pGSyXnBHlTwS3vErvsqQC7w2k02ZiSscRc9eCnpkMJMgbrM1RMhZQYdz5?=
 =?us-ascii?Q?+LeS+ylrE0ZTgyYXxgV+XCPOiljfy5vpsi6BCOy0+cuBfqI3YPvV/UM29Bvn?=
 =?us-ascii?Q?GROKc3BnnJkO+nOxEOI3ecPhdobdMQFDQGoATnSmd77Ec0kseoodXyJnBgCr?=
 =?us-ascii?Q?ISdDc9LH0y4dYS4Fyvt5n2eI?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UKogAHXBGa5vMrrVoT2w5d2umHSQSjaxdk2pi0ThupxW1sQxS3y7s/eFAx8y?=
 =?us-ascii?Q?QFYh3fIZ+u2oDbPmpxCBOh6Js9WsCN8HEVEoHCnGY8N45qQ4vdwdxyUPsXYJ?=
 =?us-ascii?Q?kUaD9AQdFVluJBRttRh8Dmjoc44yAf5iagYeBDv4KmmnTv0o8uFVsFVMApm0?=
 =?us-ascii?Q?rIEYUAfUqNXktmoad+GpwI0LW5NuzSXlW1XF9O8o32T1BSX11icesweuWfjS?=
 =?us-ascii?Q?1x5EyJgkNVHR3SPDDNEz734k31l5NvWfN2epd9xJHRHuY96OZZ1wgXHajI3m?=
 =?us-ascii?Q?IZUx3XpJXvx8wxqsWB3k/f486bGYgga5BMkYnmPPZN96fG9qCWi3jHhK3FTB?=
 =?us-ascii?Q?ohRd2OUN1v3nFCg/t3vJEq9P8bugix/ch6uDnHmHJmRUAhEcEMSxQwlwlBRt?=
 =?us-ascii?Q?LxcN7RlKf70hrxTo+4K6gEpyJlsWhhI7mNNtNaEwrnNQ9/O3UxjDOmqLHcn3?=
 =?us-ascii?Q?AIWsoZcKnq51Jkbe5JUHGz0yEnrmRy2DjlJbLGkB2Y07rV1zJtM0gSuR4mZd?=
 =?us-ascii?Q?EFW0omi6HU8Oe7XmgxCbsox4pe3srZCSl8zoEWSESGqzc3zD2/U+FvW8jkh4?=
 =?us-ascii?Q?KRE0vYalzTxtfc/7knfBIqQHPtXHrgcSS71CAv9+I7ySzWIrZ+2cp9UJcie7?=
 =?us-ascii?Q?I+ftfg9k4Kk4AfbB7/0LctSWu+bmqwz3ofy3nBf69iFDnQx7WiUx6S5fvoEB?=
 =?us-ascii?Q?UJk9tE01zwdq6pCN/FzSg9+W22V9gxy4NtsMdtlNRJA1kAQYl7bUM3ByRr2Z?=
 =?us-ascii?Q?qcZnOf7qKTqT6bVeiVgxQyiE6Pk4kPFgf4+BVLv7H3gc1QfWUy5/JCEK+HBh?=
 =?us-ascii?Q?Kk54ED80Vy9iA9F14D1RbILAaEdm4omMmCoI+gpGsSfgsom63qJfKgfbsYvU?=
 =?us-ascii?Q?qx9W+OK+9wh5W+Xy4XNmBtQS7/X2DOITAjBKGy/cbkozmmmm86H9Yo+qnBdS?=
 =?us-ascii?Q?3ygWMfhltvLSkt5UHpqXoT+Ml4SYfkmEFSVwKaYT1tHODgWGdOgmqv45EUbl?=
 =?us-ascii?Q?wcYLLBS7o4KiQbSr8vS78synZfV3vukOHhtprlR3b0GTvPStHiOMq0BiGnvi?=
 =?us-ascii?Q?k/eSkrlLXiH0AGSEvdRqitpJ+9CggS9vJG3R8JOTOKrcCXObbXOOr6Gv+9pK?=
 =?us-ascii?Q?gzjFnfnmLY+wvyJet5nNTKsaJxfw7+zGdpUBE7z8lKhvsbuSb0iN16F5U2tr?=
 =?us-ascii?Q?M3f0o99eV7hX6Land6gLE9XLl4TebOX4lxfjyI7eQeOwrItqITsBaj6Uwd3M?=
 =?us-ascii?Q?B5YldFVmHMHjPWpvSAbb1Ab+S3Zv5/KEGt7OJjQBrFCFUlvpD2fp3H/UUjFh?=
 =?us-ascii?Q?XEGupQ+0vgtJf1K8eWguO/6Jpndk7CSGZ6cvvbubblYwrE5xt3RjCvuRbYHc?=
 =?us-ascii?Q?aPZr7fcXBQ+k63j2wQ/dIPgBjZ7wpq7T5kQn3XMbtDHlIz6dvquEn9s7mPPi?=
 =?us-ascii?Q?Wzkj1PNWI1LU8nheYHf1+BbNXTTAEnTJxk73/08AlkpO/Y5WOe9XfNNwqi69?=
 =?us-ascii?Q?xTeqCUZpvFflCT6KdmRFzd7FMoCe3YHMLN4HyRdNUYI4M6SSnmXpiV8+Nm/M?=
 =?us-ascii?Q?vuEm+SFO0B2HWu3ig3JRDgot0zDQcqrQX4lzjArN?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cea85896-bfbf-4cf6-f012-08dcf75b3d72
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2024 14:17:22.6257
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w56Ya4wv6UJsrMUHAu6Y+vbVzLnAgdZggCOxrqOGRMYlFsuL0pKKHuaIfeU7zKwBPsJ8qdbidkSQkflbJC9+qQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7724
X-OriginatorOrg: intel.com

Yi Yang wrote:
> It will cause null-ptr-deref when nd_dax_alloc() returns NULL, fix it by
> add check for nd_dax_alloc().

Was this found with a real workload or just by inspection?

Ira

> 
> Fixes: c5ed9268643c ("libnvdimm, dax: autodetect support")
> Signed-off-by: Yi Yang <yiyang13@huawei.com>
> ---
>  drivers/nvdimm/dax_devs.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/nvdimm/dax_devs.c b/drivers/nvdimm/dax_devs.c
> index 6b4922de3047..70a7e401f90d 100644
> --- a/drivers/nvdimm/dax_devs.c
> +++ b/drivers/nvdimm/dax_devs.c
> @@ -106,6 +106,10 @@ int nd_dax_probe(struct device *dev, struct nd_namespace_common *ndns)
>  
>  	nvdimm_bus_lock(&ndns->dev);
>  	nd_dax = nd_dax_alloc(nd_region);
> +	if (!nd_dax) {
> +		nvdimm_bus_unlock(&ndns->dev);
> +		return -ENOMEM;
> +	}
>  	nd_pfn = &nd_dax->nd_pfn;
>  	dax_dev = nd_pfn_devinit(nd_pfn, ndns);
>  	nvdimm_bus_unlock(&ndns->dev);
> -- 
> 2.25.1
> 
> 


