Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CCCE1B7910
	for <nvdimm@lists.linux.dev>; Sat, 10 Oct 2026 01:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791596939; cv=fail; b=PtBdy3x4jU05NmtBHEDOq/xw1QHeWXeoRKvF7CNJU/C1/ivPwyPf81aFy6oRdlL4DnIkWjfpngExqIM8W2bnKy1Sh3AFHMXXGnqtR3wAMxOrW4SEfGudvrwZuBE9dow+DVUuXG6idn4Jd+ul86nDyVr5Klw8ho6sKFJIKxg4ez4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791596939; c=relaxed/simple;
	bh=jSrpQwPDuh4p3gYoRMqRzwngYqbnTuhSUOkh5f1GqNs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=EQfmPKqoREsTF1Y3o3mJTyXBfsr/c3EumqjVjtmW8Nuxl1EGBJCcQ2tzJeDVfzO0ojnIne0A2DNMuvOeBXc6e+LYefJVuwaodD1ZmsYaMhzlJ4cuJLoxRotDzNx7B/YSGCM1CeF3GuUPu7qN/ZIAT4l2ZuNEAKWay3D8MylWgVo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=immExsmG; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="immExsmG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791596937; x=1823132937;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=jSrpQwPDuh4p3gYoRMqRzwngYqbnTuhSUOkh5f1GqNs=;
  b=immExsmGH+ehmgFadBnSIHF6gGRPE/nq6yq5sQTNVxBv7dkILac//PRk
   4N5NUUd3OaP/QPEYfN69XEjW1WsN0y1+sqXoiYd3ydsDpZMau+3Dz+BcK
   uWGyCm0Z018uIukg//PbobJtXdRf/17ex7KyfCQZA+ulfbYQ2Da2mRL94
   SXTUckWgvGcJ12RiB+r0xQofC0UfC5HIAxYVcfTkE8O2RyKPNTwrt5H8+
   1hX9LNRjkltE2LULRBi5vWRRDvTEKr/zzOioCOUI8cwq49LOJHy5d9MJW
   /R+9ZvfcoZ/duJeu2ytnAsH8Zqctc9CJSBaOZfDztIp2awniqPYK4ejag
   Q==;
X-CSE-ConnectionGUID: Bsj4hx9CS7KlKMELcIB1Mg==
X-CSE-MsgGUID: Iot51x9VSGqw02+Gvqm+OA==
X-IronPort-AV: E=McAfee;i="6800,10657,11930"; a="392385"
X-IronPort-AV: E=Sophos;i="6.27,149,1787036400"; 
   d="scan'208";a="392385"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2026 18:48:57 -0700
X-CSE-ConnectionGUID: MHHISchbTWaIjMT6m+zclg==
X-CSE-MsgGUID: 25ZcOwTaTx+6a0P/O+6kZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,149,1787036400"; 
   d="scan'208";a="802133"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2026 18:48:57 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 9 Oct 2026 18:48:56 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Fri, 9 Oct 2026 18:48:56 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.23) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 9 Oct 2026 18:48:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bjWnMz6gIFuE0kzBOp8oCZ6+fT2afYV/vQv+pAdcKvzFA1Mt0R+h3ycy4x6AEYhvYLcSG3kotY5qxzs7WYAWtgntNX0zNjuzAft1K8d8ay41744pEBpErK6pLAl/ho+lbhFD/Fw5btmGez0fmB++UqaNfCJY3s3sXDg+DDdGmhz/5KoIP3tgJ7GmW7YfAW6IrxeSXYd+QzoPu2josXPcH07zUxtI6O4pgt8kKpIE0G7UZOVOR/gYuuSnN6aDBYqIIAIdfxUWvpscqWof56EKmrsEor0EnEFR/4ST6R8tn9jvuLYhL8e3THSkXhE9M0axfZBXsKmXDLHM6Fc1Yrh0uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O5JcoL3ea+n7Kn97ueIBiX0U4/tCVDTllHRxkFFl6e8=;
 b=n5Wg06pZvSwRVOK51VY2XvGjYU1yYjSa8UCHS2GMJU50ua9hDOvabRdsOm/7TGBt4uUUQ1SKoR8J2RBnOkOLOY6ffdTPEq9G+/g6Wh/Gz9Uq1/rIS7/qyCeqd7jvErVyADrjaN5lcUUe7nUloUqhecKeaJzJUfQ/6kS9dcju+EYKyhRWqqVXAObvs6aG/Aar88aWz1ycoBRagu4q47iuyMZAPawlZz/qu1/7Dgg2dvan1dbupaOIG+OAw+SFoFwr6BxEmhtHoJen079L+Khg/I/GscvmAmPClkyqVqrKGhH6y2g8GsUI1bb5HAliaMSQ5g23Y2Z3bOdhIhdQPj2maA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SJ2PR11MB7520.namprd11.prod.outlook.com (2603:10b6:a03:4c2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.35; Sat, 10 Oct
 2026 01:48:46 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0496.017; Sat, 10 Oct 2026
 01:48:45 +0000
Date: Fri, 9 Oct 2026 18:48:40 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Jiale Yao <yaojiale02@163.com>
CC: Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang
	<dave.jiang@intel.com>, Andrew Morton <akpm@linux-foundation.org>, "Joao
 Martins" <joao.m.martins@oracle.com>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH] dax/device: defer publishing the dynamic pgmap
Message-ID: <asmZeDROBmmc-3kz@aschofie-mobl2.lan>
References: <20260927114736.1113965-1-yaojiale02@163.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260927114736.1113965-1-yaojiale02@163.com>
X-ClientProxiedBy: SJ0PR05CA0101.namprd05.prod.outlook.com
 (2603:10b6:a03:334::16) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SJ2PR11MB7520:EE_
X-MS-Office365-Filtering-Correlation-Id: 720aa857-25b1-4f28-7ed9-08df26709ef4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|261009223027099003|11063799006|56012099006|6133799003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: QAIyNGlkecwABVxlgYp+7y/y25ojr7CWZkT+psYTxGHla8nMbvSkCp6YGDK3oXva+Rmy3e/JCRDPPaRCGFcYNSVCDDc0imIY6SwqESsbfXOkT/FF0TycI8a4Fl6sgDeCoND8B6PaADFZuLP2yiYHcfHcWbZ3QjONWbQR3EwSU8AH48n4WlWKI5fPEWRLonWaKz8J3nDkezcz4XVQNL5rQHx2TAbJSJE5N2aqSEA4mnClovQ5/7rP0PXKJguVal5MeVgWcxo57M1UBHahiBHORn3FFBVBO3T6emE4ztbXNg+h0h3nKEnMGlnyiX/xytVy1qv8wFR8ft4BnjFFpTaCZsttYeiE7alsVjFUV8cGvlVFmQCxkY+ZvQ5K2OVboDjAtrHpOjCQ2n5QxjKcZEJmijjmj3cswpE2b7UIypg/cuMn5Y/WJ4E+tGNl3apC4yPD5tcQaHWfDfC06ZOvmsB1gAz+W+xp4AqUsIGc0UZBkAigNjMyRxckjoSEltTleGk+zGxYhgk2XgqEcZFMRiXbkuCPmVR4f6pMYGdDdkBf/91lr1VfUoVIAd0PYbhSyIdlFAwctPI+9hQVHicwpyhPorA7FvoHsIzRc9ekusWJRMGn+XJ6mK89jleB4u2WauQig6yQz5bvQ7Et6hhA1cRKzPiQJ1IZjIFszp68Z4XprJQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(261009223027099003)(11063799006)(56012099006)(6133799003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0xhJIgDLDZnsQiMdjrYU4J0XvThI7Ji+/YqKd+q3Sx8BovBEaZ2plUDX8MKe?=
 =?us-ascii?Q?cjZWbrxj7XMqsBJOTkW2Ipcd/ma4H6LxFXbnwtLeome/8Yrk/b9EQg+co1U2?=
 =?us-ascii?Q?aV7kr/91oObk3AWfEZU8heq6fJqDLGguiAKoT8rZoJ6GwDdMYuoFjnUQbe+8?=
 =?us-ascii?Q?pdskuH/YRtWXu4/zOYtsJjbRfIl5gxnoqRYLPRUytnX9sHC+r8QFaHLkNIn1?=
 =?us-ascii?Q?eeJCU6P5pYzOWq0eVQURSf9RbRfyDrdK6/zrY8ogEvf0e8eCa/WQ1zmCH4/+?=
 =?us-ascii?Q?l4Lwug7BqIR25G9XpYaLINZGN3UM26zsZCGKI1BE/+t0VFdrozlhwlBrXVSr?=
 =?us-ascii?Q?opEKerbGxGCZLLEtYD42DkqnU/u+JOIDi5f//Lstr1KlyFkU7GAjcQgkFkCq?=
 =?us-ascii?Q?bygrgg3SwSP/nI/i+wyxa5l1PJHvP4YDt+9FjV2rszRGoyOoXkIN0+Ku/rAe?=
 =?us-ascii?Q?I4aMgUecSh2XGVAaE9Cf0rL2ABIAQ8+iZoscYkKS2A2xXgF6sUOFci0Hf/t5?=
 =?us-ascii?Q?7YFhZJPVh6CunBuHZm54bogTtovDcViruW5skctk9DDcmqz+jopTUD4CxWQJ?=
 =?us-ascii?Q?6kHp8bHwYv6nYNMaZwnKpb5YwVrjMPasoneW27y6Ap5bQW8+oPr3/b4Gug3F?=
 =?us-ascii?Q?Jvo8uCc7YxPeLvFgivSAp3BE5aWD3GMrQc87AoZOLUEaF0rj+Hp8pV4H7WlI?=
 =?us-ascii?Q?uWZSlexRgXzGBg4w0PZNT4aGHz5He6//6HV5Rgp6YB3CjFyieg7d3kHhWPAI?=
 =?us-ascii?Q?OZad1/LO8TfaBnQlZJiy87VhrbIsU2GFkXH21Y4qfIfXK/iK+PwJ2iuZkKV8?=
 =?us-ascii?Q?gy7AB7uRh3YVv2j+6SJ081wyazLm8cMIRKXoL+QVUv1CEX7zqyv3w05Ze8qU?=
 =?us-ascii?Q?ePQhcHZY+obnXlablNRk2pwXsUmiZNrNERbX3VwMAeOBxK1QaD8X6JayUzYv?=
 =?us-ascii?Q?qIemyvUffmc9NBQw/bCh04gsuaZDTIBNgw7uoiTXjlnFMwkJzOY1NvYvnp7I?=
 =?us-ascii?Q?U8hCMdqLNf3ls1StLNqUYuklpuG2iklXwbrYfZ9j03G85mgPfx8PX5nsUeR2?=
 =?us-ascii?Q?BFwdtsn49IGxOdo4XvGF939mSlSSaBDe7aUAz3Je9PjXNnb9kfYnCeNRjBRA?=
 =?us-ascii?Q?pdkT1sPqN4UqW8pATHeh4AjRZO7YNh/DsAZw2kG4OONGqk0qS0nd2be7ob2r?=
 =?us-ascii?Q?KNtwUsjpIhBx0+P1KtWRKfTI8nBGjLWJql+dYdgDOO1cXzZfe8CqtAX8Trk5?=
 =?us-ascii?Q?vvkRR9VvxEvB57vrfgdWIfe1IfayZ4b2XlrWQS1b3o5377zetb/Lt1wO8+Cp?=
 =?us-ascii?Q?5FdVGaX4AV3oiobsEmQwX+ODm+fitQe/1rFT+fGgqOAOG4FZi0mTskGeyKJA?=
 =?us-ascii?Q?1NJ6t9ZjKeOMR9YA++HcgVeHdGq73E159ViLOujUujWSbg9RNGL9JI1ndmSo?=
 =?us-ascii?Q?UHvBwBy3yeUtM5f7T8huxRl0wSn9FdabIF2NK4IRKYpEgDX9A1Q8GVnfmxjp?=
 =?us-ascii?Q?ZYIQJPApgT2wSglwOkc4+A7PG80KpCgEo7QHVvhfsLb0crhd13kuW7rj2BIm?=
 =?us-ascii?Q?kFdHKyXrswerzKIPxswTJK4ffcTnAyE/Hhv1COrzVUHVcPvkeNLREuw/bdmc?=
 =?us-ascii?Q?GxpZ1TGdulbi+9CTfN+Cs71KVplnlPF63w3o2PZhwikEPNjZH6vMtt/SZgr7?=
 =?us-ascii?Q?wlltTVjDVA51RqUIneRh7TL3R+R1CyFYajSpjjLIKgCoTI6E0WKfZwVqfVT5?=
 =?us-ascii?Q?FkjW+/JGvbBi8BPYYEpbZPsPiDnBN/I=3D?=
X-Exchange-RoutingPolicyChecked: GzjNbVavYI99QUPY3/ZmTKzmOlUQOaoZXCm0xSgtZaO8i1b3gUXAEytyYFC9u6U0cIEYx6ibxPM2hwbW/H5JHy6j63xo+dQzqllO1BnFIuzVL/3tOhJd0VBV0iD/or/HJP5oldESvLTdt5WI3PCIObr/On3PGpFySslNcMa31CLL7t3aCNHOr9EJLPyN6EiigEkOftJ5wt5Wct5CGAaKHDgBuqe2IUtGRtQ83/yK62aGZKeJA85fE/k70def+Vl/XGCpFZL39x3fXM24Nwdo+1xGrepzPsxYx+Kn/DhhqOK+EJVdV+qOTeNjf3riZ+EWAsYES9ZzhZVgImX2vb8Yfg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 720aa857-25b1-4f28-7ed9-08df26709ef4
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2026 01:48:45.6761
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4HJy1hlUkS/cy/MDAzw6OUXdIs2ju0qUecezBixPD6T3Kp/ceOiUun6Z2NO7vE/2QJ9rZlZR1tv+XpkZlhckNZPTVa6SBd4TXYoxMoyKjNU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7520
X-OriginatorOrg: intel.com

On Sun, Sep 27, 2026 at 07:47:36PM +0800, Jiale Yao wrote:
> The dynamic device-dax probe path publishes its devm-allocated pgmap
> before several operations that can still fail.  If one of them fails,
> devres frees the pgmap while dev_dax->pgmap remains non-NULL.  A later
> bind then fails the dynamic-dax invariant check and leaves the device
> unusable until its region is recreated.
> 
> Defer assigning dev_dax->pgmap until the final devm action has been
> installed and probe can no longer fail.  A failed probe then never
> publishes the temporary pgmap.
> 
> Fixes: fc65c4eb0b2a ("device-dax: ensure dev_dax->pgmap is valid for dynamic devices")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jiale Yao <yaojiale02@163.com>
> ---
>  drivers/dax/device.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dax/device.c b/drivers/dax/device.c
> index d0c9b4e03b47..8cd8e05872c3 100644
> --- a/drivers/dax/device.c
> +++ b/drivers/dax/device.c
> @@ -409,7 +409,6 @@ static int dev_dax_probe(struct dev_dax *dev_dax)
>  			return -ENOMEM;
>  
>  		pgmap->nr_range = dev_dax->nr_range;
> -		dev_dax->pgmap = pgmap;
>  
>  		for (i = 0; i < dev_dax->nr_range; i++) {
>  			struct range *range = &dev_dax->ranges[i].range;
> @@ -450,7 +449,13 @@ static int dev_dax_probe(struct dev_dax *dev_dax)
>  		return rc;
>  
>  	run_dax(dax_dev);
> -	return devm_add_action_or_reset(dev, dev_dax_kill, dev_dax);
> +	rc = devm_add_action_or_reset(dev, dev_dax_kill, dev_dax);
> +	if (rc)
> +		return rc;
> +
> +	/* Probe can no longer fail; expose the pgmap via dev_dax. */
> +	dev_dax->pgmap = pgmap;
> +	return 0;
>  }

Hi Jiale,

Please address the NULL ptr dereference issue that Sashiko identified.

Could we instead register the dev_dax_kill cleanup action first, then assign
dev_dax->pgmap, and finally call run_dax()?

That would leave the pgmap unpublished on probe failure while ensuring it is
initialized before the device becomes usable. I believe the existing kill_dev_dax()
already clears the pgmap for dynamic devices during teardown.

It sounds like you may have reproduced this issue already. Can you confirm that
you've tested the fix with a failed probe followed by a successful rebind? It
would also be good to confirm that normal bind/unbind/rebind still works.

-- Alison

>  
>  static struct dax_device_driver device_dax_driver = {
> -- 
> 2.34.1
> 
