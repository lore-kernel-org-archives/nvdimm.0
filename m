Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A36B55E73
	for <nvdimm@lists.linux.dev>; Mon, 28 Oct 2024 16:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730132805; cv=fail; b=CzO4L8IHVMZtDH0Haq4FGpFZctMLx3CSCWPP0YeUW/z2VxLgiXIHOfUU8D23fPu4j64hEVdooe2yCbDWpH93ofRf/HLNMXI2Rez5UIrsINZagU8Y4x1jic2H+XGCPU9WyHXBq/xLpTyzMKYed/j8g1mm6wUNyxaJM7tVxAX07BE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730132805; c=relaxed/simple;
	bh=9lczkQVs9anLYNCiYWbi+yhx4iyXZNYhzwlNYsAOnZ8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kZPZNVXNbobWgLHgxijYI1jL0DyyEyTs5op8R8kReT5M45TxJxt9Teg5P8Z4DLZMegP7QMtOM4WKVvfC664Zna0Rp9DJZ2C+eGXoUf61TDT0hhiZyFZ+sUKujz0XasFDIe5a63SdzXk03n47Jgfb7Q5kz6euj8UP0CydCN7LgKA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BulUQTXp; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BulUQTXp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730132804; x=1761668804;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=9lczkQVs9anLYNCiYWbi+yhx4iyXZNYhzwlNYsAOnZ8=;
  b=BulUQTXpA9XEDeGeKn3znargnRtr5uU53monL+TRp/8+28m4uVXr8Q2Z
   iCOiLuHuak6TpSpZwLFU/v9FvI6EQ3M3qCRMN9cYxQW+hpi76iyeAd06P
   azYDeJVN+PbQWOtQM6LDsgee2710lGTwzL+wtmoQYOrOLcJlpVUMB3f2k
   OWpYBSF1ABfFW8XPI6qq7JTBPVkaPHhKITFBbkCOvkmH/HWVxBq87tVYb
   ULA2INn6cUspYi9wiydOgWQLHGRx5m+97ChhNyHbV5sD5DBN8OJ7AIPYz
   ETR8I/siU8bRQWj4NUbhCB1/WFf7ZAFWMfM2W90an61jMf9UfE8VRMWHn
   g==;
X-CSE-ConnectionGUID: dXWUs+RSQMyMlCrfeXHhUg==
X-CSE-MsgGUID: WqhyMWvQRQ64zFJ3vPJTtg==
X-IronPort-AV: E=McAfee;i="6700,10204,11239"; a="41100869"
X-IronPort-AV: E=Sophos;i="6.11,239,1725346800"; 
   d="scan'208";a="41100869"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2024 09:26:36 -0700
X-CSE-ConnectionGUID: yCQun7rWRtKRojDVzcdDkg==
X-CSE-MsgGUID: +PD7vol9R2ilAxskhOzuPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,239,1725346800"; 
   d="scan'208";a="85620018"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Oct 2024 09:26:36 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 28 Oct 2024 09:26:36 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 28 Oct 2024 09:26:35 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 28 Oct 2024 09:26:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HRZ3R/bVHlyptxF7KxNOayJqxL5QWLO1vDaTYF5g/+E/l1Or+7b4tQlwtEeawKtR3BDM7PcVEPRvt9jQ0+bMRBvvY+JC2WeeaXl/enkFfBZqq7TyYygyUw0H0QAjMQ33Gw0ooqfRr0euVM7YbtfbU//Dza0NED7lmVhZQMtlPGf2uDgD52lGpneJedWU5icYAmXPJJOvTSfyVFuKurb7+Gnq/z/nsvACxZNAahweq9tKpP3ghH+nFwElfD8oGlCYuUakhbh6OUzHozci8fcwbxg5anlEYLmY63jCDrNNg32LePT808T5BfejUdwcNA6Og+S+M+qzhUu00h+d9oEE4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AHH+mPQXTA/CMu1hFVAkOsj8so2KAjl6L1jrOu9jX34=;
 b=K7U/d47hITvRtpEMmGrsx5+kOw24+WqB6MqD94db136n2n2MsRwzIHyMqz6DxLBR4x8EL1TxCbDNGb0gPk87H4bb1YO3RBkSu4AG0hi2HSNDu20k6fsAefTGu+bsFxohVThA5R5of6je39kUeayyjORt1y7qeDLuJBwWEBg0alxMYqNitgNouK+yTYxwaxrASxYwg69M4v/bvJrDfpudQPIz22N4dpUOa2oYYjUkCiS1VR5rF4dUb6BkHOYA0zT7/NU/VrwzC5qxkal5NAQ3uAiyY/rlC5w3XHzf5UOf9RbJKEteUOrkPe8uSzkJpMhq+rqF6MatNFxJ3R/aQFTqnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SA1PR11MB5900.namprd11.prod.outlook.com (2603:10b6:806:238::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.25; Mon, 28 Oct
 2024 16:26:31 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%5]) with mapi id 15.20.8093.018; Mon, 28 Oct 2024
 16:26:30 +0000
Date: Mon, 28 Oct 2024 09:26:28 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Yi Yang <yiyang13@huawei.com>, <dan.j.williams@intel.com>,
	<vishal.l.verma@intel.com>, <dave.jiang@intel.com>, <ira.weiny@intel.com>
CC: <nvdimm@lists.linux.dev>, <wangweiyang2@huawei.com>
Subject: Re: [PATCH] nvdimm: fix possible null-ptr-deref in nd_dax_probe()
Message-ID: <671fbb33ee9ef_bc69d29447@dwillia2-xfh.jf.intel.com.notmuch>
References: <20241026010622.2641355-1-yiyang13@huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241026010622.2641355-1-yiyang13@huawei.com>
X-ClientProxiedBy: MW4PR03CA0245.namprd03.prod.outlook.com
 (2603:10b6:303:b4::10) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SA1PR11MB5900:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d9709e3-c1d6-4edd-45da-08dcf76d47b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?8PoGfyvQ9QOYZFEDG23oO4Qc3i546nLziuoC5hMZliuPxxmRo8KiEGKqZtc4?=
 =?us-ascii?Q?YSRAmILmpbhBEJPozza5hVEJkLQ5GoeSEbVsrDFIXkyxsN6RZN2gpcq0dW+K?=
 =?us-ascii?Q?jvvmfQNLg6nEMS5T4pMWgNjAK7A1ArA09c7N2q0TPul46LqTWA/fmGfXjKi3?=
 =?us-ascii?Q?l5ZCc9e/bEePDjSdU1qAyjmsHMTsAF97PBHw2me23SBaLcMfH2wajjBhh/lW?=
 =?us-ascii?Q?gchN0Ec63ByzFoasjKoxZ5tiUpMugcAZkhEPsOqjSR54NvlQj0dWGWQA/19B?=
 =?us-ascii?Q?vbkd7DQGObv5/ssX4HLqnG0/hYL/mW2qMFvWjus98hzzMEAAJzFMBiMOHXzw?=
 =?us-ascii?Q?7je/LxESKJ0LwrrnsQtdJ6LYcp+w1cSRAMIiXCx24y5Xvln6PnoMh17dUNd+?=
 =?us-ascii?Q?i1kWFnE+m2aAgHmYJEI6w9BMsrJ1/JvbAJOuUV5xW+qE+J8A1ueHIVTNi2Hm?=
 =?us-ascii?Q?IXbCCb2je4XVeP5Nyx7u06OFKi4XYdUDmSbGggcgfp78QmV0UgobrB5mHO2s?=
 =?us-ascii?Q?tsfjawwB2YFPx5ui/znCM8nMk8pw5w72/eDlZHH5qAx3OXs5Inw9M4FLF91V?=
 =?us-ascii?Q?/b5STkNa5gjGPAcBYzw/aks/0GtUJlEy2tlQ+g1PdeEZnjmuj/40BoMs6Z0D?=
 =?us-ascii?Q?mkjqYT1TvUMir+AzMc0sJnMJL2RffdAJZzCtSqLyBS3gQx7TsckxlGrAweJA?=
 =?us-ascii?Q?LuDlXQtAsd2LspPhcwPl1ZoePErQSics9EZwq6c6e/ax4H6KvNReb9aBRoDI?=
 =?us-ascii?Q?mk5E2AjtxGWfqrr40iVkmxAuTFPEXgPrmUKpM1+qpTI9t/xf6w9WLuKK6TXm?=
 =?us-ascii?Q?uYudG7UH3TG6v/CumlXZWZgCvHnKDG/35ibcElqMTdpT+AzeA2sXRU4MKUaS?=
 =?us-ascii?Q?5mMhIQKvDHhIPbFB88LMCw8ii3qcAjigoOWN4JzKzqEcNtvp69xHEpv/lb9p?=
 =?us-ascii?Q?8WcIVmrbOkDXffM1xL85Vh1D8I0JrT0dtt/QiTmgMySZKnv37FWmBHinTvoT?=
 =?us-ascii?Q?tvY4vA0euROwnRUbao+6JZOfvu4Xe7IlXM2Kzq2nAoffP12T9+YuYxu0eFb+?=
 =?us-ascii?Q?4zSWdywFlTT1hisaE+uyumpT29mll66sqv2QSiNbjol590FvOBpHSN9abdUJ?=
 =?us-ascii?Q?kGReSPTkZEqGM8r8L4iSff8dgE/iHvoEcW6DeKVuHxz18hxUQsGJ/Q9WmXxM?=
 =?us-ascii?Q?axC4uVl7oCpcdoIjvvdfUUc4/nljYMFZziLgJDiwaQ9Nt83q4mirzG3nV5Gn?=
 =?us-ascii?Q?rxunztqVkhqPvMXSR3G1kDWUYUPmvcQcEQIVzRySJY4Ho84W0kpvImI2/uos?=
 =?us-ascii?Q?XMXqlztmiaXwdwmoCnID2Ztb?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yFfIpqV8caQLIoFKhvl6oho10/Puen+JDwGVKoyXdIOqOZiPR4n/AQgAJNxO?=
 =?us-ascii?Q?T673PFQkjh4JtVZ3ZC/sT9663ASv9RjwXWVUwQX/nan0CwSSPhmG3hZhOvJW?=
 =?us-ascii?Q?skmx8QA0oMIg6S1KlelcPzF/NRduK7iEzu3DYSO+lfOjp5BhwH8Q7zvzF1JJ?=
 =?us-ascii?Q?ZqsL5Kf8Fiwr2RxDnK8gKsEcuVG7X8O8MTXhrQinpPPNO7TLErZIj28vVss9?=
 =?us-ascii?Q?pcVoVqLdfQwbZeLzCuwYqrd6qWpagwjOs1s99GAIPmUbjJXEE1fturT5pgUg?=
 =?us-ascii?Q?1JRVs2VCc5h1msqJ4wEy9d14otxBffHxCJUnHj8K6UoIRpmZiifz+99JQNF5?=
 =?us-ascii?Q?J8Bey9ALHTE2f3gAgFs5du23Roy7Dwj7s2qJtnJGPQHlTzbll+EX+21ykZIL?=
 =?us-ascii?Q?+TYQWaqEtBYdByitFYzwxRcgIc8tU3yE1Oi9FesAUzrhCmmkr64Qm8dQYsVN?=
 =?us-ascii?Q?Yfm4TT0ffeW9e5hb/vxu1DSB8VZOVIc+P9VjOzLcgCC3hHayrNolwRX4mKs0?=
 =?us-ascii?Q?2+iw4c4dTQd+VoQpi9g2UzF3pH4dsKkPsYYEDmuXCgBwH7lWzygzOqRdxdcT?=
 =?us-ascii?Q?GeTbCUCPvx541pvid5W64h5JJVvM2SCDIvw5BAfvtRecwga69NObMmUr8jud?=
 =?us-ascii?Q?OsDoNfBGe0rCeqIZA+CzDgxLfWe0FJzq8VjGfBtmNmAVXq9ewi9lcdQDM+bz?=
 =?us-ascii?Q?F9+PEPC1h/f+y7HFZY6tgc1wQjpx2ZYERPiNVdOcC86CZ9NsUnudtFcNWOy2?=
 =?us-ascii?Q?x2zNI6myPADN6ozH/x+hMQmJmejHW78AG8wM94WmvQpgTA6+Of0TEMW2Phz1?=
 =?us-ascii?Q?voKiVMSNy7h4abO1nSENLGpvWsFsepwdGvuTRsq8iqK0dEN8uve7lZ5Ancwz?=
 =?us-ascii?Q?b/mxcxE8kaCsevgjjGziYA0oSsyfBKE1PWS12QZr4l/lO/65myMR1dKVoGeN?=
 =?us-ascii?Q?8MSPm1X320HsCs17DUNNMsPkcdWTzWTuytosuLWHd9UVW1pH+f5xtrbVnMbA?=
 =?us-ascii?Q?4gl/RNxnBjlq05eyPLI09b1hKTic49GotDKHvC+41FH91eHiyUJTxCuO/998?=
 =?us-ascii?Q?Sn5UBsofPW6+tOTeXEB1oYRKacK1dEJwaItMF5Hj0PVxwdQFtw4+VewRDb8Q?=
 =?us-ascii?Q?ZJ/zjSUytW3ywNMhILS+UmOgtgLAX2npo9lgltZXImYCtN27701E65DWmgu+?=
 =?us-ascii?Q?qoFA5wW032cIeZtkm8fj7qMCc/yfK2x/hLTyqPbz5b+4ws6B3a+9qBIgwU1M?=
 =?us-ascii?Q?F/BRgssLLvY9FIuEkginzIW1MFtQMZyU4iAiXjaH6NBZNgktCRuyLWENJHho?=
 =?us-ascii?Q?MdCgLsV4uDSJvTAqvmN8msvrGI1XAgbXlhJ2y5PllGCcGMNAkbbabdirx6aW?=
 =?us-ascii?Q?2NQDNFxdhCzy8HERr04OlimNGSLxzgYJ+ILbDFKS+SMdRJd9L0Mzkmre6TMJ?=
 =?us-ascii?Q?FPbmxI/mypqT0VcbNV+3iMDY94o2ss6pnUfsCQuYJf4MX7KM80sWn06g8nLK?=
 =?us-ascii?Q?05+eNSTOHQ1LqDTOLKgFFJPExYkvJgnIjeYU1JwkJHfNB2qsZrUTJ0KU23kg?=
 =?us-ascii?Q?j+GO+ODdtCr63iThv0Qgn0I3OKLdQsy7y6xGxv8vcZROQCoMRF0CbWyvx9o6?=
 =?us-ascii?Q?dw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d9709e3-c1d6-4edd-45da-08dcf76d47b2
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2024 16:26:30.8247
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zzhGOpPqwVev0FhOslrCMvUdb9/+U0kVwU5kaCprog/lcmZ2LMnFshNyRPBiMkcP1GEjfobHnpJVXZAhC0GWz1vf7SebOeAo778J7+Cbx6o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5900
X-OriginatorOrg: intel.com

Yi Yang wrote:
> It will cause null-ptr-deref when nd_dax_alloc() returns NULL, fix it by
> add check for nd_dax_alloc().
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

No, this isn't a NULL pointer de-reference, but it is indeed
unreasonably subtle.

If nd_dax is NULL, then nd_pfn is NULL because nd_dax is just a
type-wrapper around nd_pfn.

When nd_pfn is NULL then nd_pfn_devinit will fail.

What I think this needs to make this clear is something like this:

---

diff --git a/drivers/nvdimm/dax_devs.c b/drivers/nvdimm/dax_devs.c
index 6b4922de3047..37b743acbb7b 100644
--- a/drivers/nvdimm/dax_devs.c
+++ b/drivers/nvdimm/dax_devs.c
@@ -106,12 +106,12 @@ int nd_dax_probe(struct device *dev, struct nd_namespace_common *ndns)
 
 	nvdimm_bus_lock(&ndns->dev);
 	nd_dax = nd_dax_alloc(nd_region);
-	nd_pfn = &nd_dax->nd_pfn;
-	dax_dev = nd_pfn_devinit(nd_pfn, ndns);
+	dax_dev = nd_dax_devinit(nd_dax, ndns);
 	nvdimm_bus_unlock(&ndns->dev);
 	if (!dax_dev)
 		return -ENOMEM;
 	pfn_sb = devm_kmalloc(dev, sizeof(*pfn_sb), GFP_KERNEL);
+	nd_pfn = &nd_dax->nd_pfn;
 	nd_pfn->pfn_sb = pfn_sb;
 	rc = nd_pfn_validate(nd_pfn, DAX_SIG);
 	dev_dbg(dev, "dax: %s\n", rc == 0 ? dev_name(dax_dev) : "<none>");
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 2dbb1dca17b5..5ca06e9a2d29 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -600,6 +600,13 @@ struct nd_dax *to_nd_dax(struct device *dev);
 int nd_dax_probe(struct device *dev, struct nd_namespace_common *ndns);
 bool is_nd_dax(const struct device *dev);
 struct device *nd_dax_create(struct nd_region *nd_region);
+static inline struct device *nd_dax_devinit(struct nd_dax *nd_dax,
+					    struct nd_namespace_common *ndns)
+{
+	if (!nd_dax)
+		return NULL;
+	return nd_pfn_devinit(&nd_dax->nd_pfn, ndns);
+}
 #else
 static inline int nd_dax_probe(struct device *dev,
 		struct nd_namespace_common *ndns)
