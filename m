Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 153B784D35
	for <nvdimm@lists.linux.dev>; Wed, 12 Jun 2024 21:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718227107; cv=fail; b=CuqlfCNh8eunH701LiJG9CbbfBrAQks1FORs8jIBvr8ZhUiE9iLBwFMrbYk8EQn2VmJ7IBPni9/ZIB/jH9KM0uKcahnkwSbGz6PjWN2ONDFvTyC59lHPQVdj3Egk1ud5cSFKSrX1+IxZbw/BRWqWis6ZB+9vbONOQEAF5K39k18=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718227107; c=relaxed/simple;
	bh=YjwRoXOIuqmJXdNC+GgXfC7bst3vI9bEPLqgefxM/rg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XFBgkKUzDkdVDADd5ZoXihMjfi/yLVDPkZ6VHv6+BDQHwYC1ikNt4Oxodp0r21HKvRk/KuodhhuvVivYyWpn4jUP0pH/MPRCln3EL50ezBpQ+5otxqjZHbSlX8UsgC3G2hHCyOnZvG604PQehzZqGs7iQp0089Jq6buOOvGDeRM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J/mIsH67; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J/mIsH67"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718227105; x=1749763105;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=YjwRoXOIuqmJXdNC+GgXfC7bst3vI9bEPLqgefxM/rg=;
  b=J/mIsH67iYnV2xMJvODp94sCqMCoEMm3s27VVFIQlUq9ssreTcp0glDf
   FTyRtjbAveIxs22a9M/mL+ypp0AE2m6HzP0Ni4bT5e/LcUxetWv5CHlQC
   qyCUd2n5kBpyAB9aaS/CdoWQgJ0HbWT5+9GUdp090M9NAq9AZIUvn6t7P
   2kbVtyvwGGLZGxoS2Cq5v2+3CQ/er12DIwXADci96+Yu8+lzkhv0CmsJU
   n5Jz96UuWwk8ayfkEZeSvm2wQYiPTTfeIEN0KJrRzqCTxrFSHLyc7nnNn
   HwXDdNdbrcszHwBgyd6b7wW0pSxD9HZ5MuTncq/nqOG602JHd7BPWJ/cZ
   Q==;
X-CSE-ConnectionGUID: T5Zsr1CcRq2g3KgSjzBWBg==
X-CSE-MsgGUID: 1Vsm0GZJRfmrXeev9fpDcg==
X-IronPort-AV: E=McAfee;i="6700,10204,11101"; a="17940069"
X-IronPort-AV: E=Sophos;i="6.08,234,1712646000"; 
   d="scan'208";a="17940069"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2024 14:18:24 -0700
X-CSE-ConnectionGUID: gmgRpb2KQYaySWDdAGGM1g==
X-CSE-MsgGUID: hzhhae70S7mfrCBs6cJwFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,234,1712646000"; 
   d="scan'208";a="44303250"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Jun 2024 14:18:24 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 12 Jun 2024 14:18:23 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 12 Jun 2024 14:18:23 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 12 Jun 2024 14:18:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VSHHMjfwcERN1WfT8Nit0O6TfJ8NDefZBz/COyshA3v+umzxKExOZ6FwtUcJRl8BlX57f02aUz1VInNyfkYdURieVsEigYbNlvmHlWnOLyft6i7uRcO1+dCtKRLrOOgK1Y1LBh00diMXUNOvT+xabEa7HyzZE6UlTy+vFo78riDoBSAaG2CTNlT3bbZ+nT516Rfwjvjt2Jx59sXLySZxUFr3JN8oor4f6dBTcBY9dMZt2U9vbH5VZizsTkgMhlS4iL7TK04UBChxVWpRNa47gFbt+1trDBdPyc15vljytZXvLDagROvO0O1b5q5mF3Ss+PklBpc3AUmqSrtoce3rKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kzTDCyRKJZmmEn+m0SnJKPQ9ILejVOOGj8vJ9ldPCU0=;
 b=fxzDTd51wu9fvSRBcDCqK3M/Eq8pShQ7W1NIfkgkVnbsFC+vIVqfdX52dxQosqBzbD30Y47iLT0ivII2TUSxNTuH/4FdCrWw4KA1D2ZyGLkayyd2uL3cp3qfirPX/EPJdGZ3iadnHdw1ONfRUYjn2VvFKeB4f7gSFEu7oaVUz1Pqb8z4OaO/mwPAzpJPOEh08f31iNYnYPD+QOEmKU2k8Bue6nTghRCFI4eij+L19sA8l/6HHmHBWZeud83C1xj51RjPp5Tm0NdXX0TAjXc5PnUxK6HFVQg+CsMEtRPPD1krhA4gHN2Ij1/LN27uJ/uN54DIKXcJGHPsgh1taJhRUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by PH8PR11MB6683.namprd11.prod.outlook.com (2603:10b6:510:1c6::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.37; Wed, 12 Jun
 2024 21:18:20 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%5]) with mapi id 15.20.7633.036; Wed, 12 Jun 2024
 21:18:20 +0000
Date: Wed, 12 Jun 2024 16:18:16 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams
	<dan.j.williams@intel.com>
CC: <nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>, Vishal Verma
	<vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Ira Weiny
	<ira.weiny@intel.com>
Subject: Re: [PATCH] nvdimm: make nd_class constant
Message-ID: <666a10986e8e4_20324e2946b@iweiny-mobl.notmuch>
References: <2024061041-grandkid-coherence-19b0@gregkh>
 <66673b8a1ec86_12552029457@dwillia2-xfh.jf.intel.com.notmuch>
 <2024061206-unleveled-seduce-9861@gregkh>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2024061206-unleveled-seduce-9861@gregkh>
X-ClientProxiedBy: BYAPR08CA0013.namprd08.prod.outlook.com
 (2603:10b6:a03:100::26) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|PH8PR11MB6683:EE_
X-MS-Office365-Filtering-Correlation-Id: 6204d289-e7a7-4fea-8e07-08dc8b252f59
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230034|376008|1800799018|366010;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?SVjLWk3euAMz4Mo59z5cogxY8pLpJM1OD9oLtJmR1aEcnuJ3NrNO5xvOTHpw?=
 =?us-ascii?Q?Db6cSTRU9GUiDhGwWBDjGnukS+jTA95JFicm4DktT/UHRvUlDVpsI3/CuaGD?=
 =?us-ascii?Q?dUdxFRJKtyT9KvDG1x/u8Sw8aBDo13/B2TFC4dCER68TgK7qTzo67SyzqOuw?=
 =?us-ascii?Q?qifgjkGVsXsAMQR+l1OW0eIABBh0ROeHVSK5KQ6N6XL3SzqwRqlqCdzJIx06?=
 =?us-ascii?Q?nXb0r5OYBxPYtKuaYU97r1SaE/v7AbCHstBozuOxP7d9O4H2Lx2biHLy31xi?=
 =?us-ascii?Q?lwhnSlRUG6fY6hfgCBgXBVWjyFY1yMUY7bE4iMirS8sJNmzPQyyaKhNah5Zy?=
 =?us-ascii?Q?ZijLi2a9sF6iNW4hbfI9RDpuHe2dCdyfbq6MBnL7Kz19RVJWejyxIKOsbPnN?=
 =?us-ascii?Q?rzC2YUkiqHsYnrmg+oYw8hrEfH5wmjINH7RI4TUpYUhPDJ4ge/T1b9dc1R1U?=
 =?us-ascii?Q?A3zex6FQHFqEXSOWkg55ytr8UaW58uKD0xBLeCH4PtmIMZHTHGdd/1DenngW?=
 =?us-ascii?Q?5uwK1b00zNjQxJU52pf8opF2HtB+6ewnoNMSCyBlgjrAF7Lkk6QOSX1FwYgg?=
 =?us-ascii?Q?yhi/uSQAmlsv92nRigdmM7X5/g7rc0yCQc3l8mcQKlwRLQ+dp/H56kRryspE?=
 =?us-ascii?Q?xrf5KZrqaSCrOkijZns8TdDKGAgM2eHsrhm1FAkFozLhj8nhjbMcFFsvP3Qw?=
 =?us-ascii?Q?mHpruveQfHVyvwoHJ1w031whubhMVl5wSsiO8mKtG0Yx7dcuniGc1gp6vAh7?=
 =?us-ascii?Q?amACEjiljKOpVB0DuH1vHsz3w0HyUOrDBjrJlwqPRzOAuF8eEcOaacwjr/Ub?=
 =?us-ascii?Q?Ozjil6QeychidqYMn4publYsfyScp6s40zqbV6rdDiDwJwJsStKTKS3qYlu1?=
 =?us-ascii?Q?qDOCjIcpypAMcgPRu8jtj+zsgyP8hSiXoRooBvKYEF5IQbWhcZPH2RFW5yFu?=
 =?us-ascii?Q?uPwv4m5N2vKI6SyBs7vyN2onXKmzVEPuRExjDrGJ4ybU/lsApQOPqAu52hMq?=
 =?us-ascii?Q?QRX7t85kmJX3Fp1dDaziCXjp79Ai9RdvDDXTUMYQHevW5cqthxDdG6ih/8xv?=
 =?us-ascii?Q?xvHlQci/VTzQ2OB7Y1FMXHjFby9FFCXYIAmK147Hii2iOzAr2CeuUxDfxIF8?=
 =?us-ascii?Q?hag1nAQxmHWGHuQkQ4ZTtnz76GsI9GRlqgt3qFDtY+rN18gBypQRBcEZZ1qa?=
 =?us-ascii?Q?I5mwh/FFwFnJUgjgdDi6CSymifsG0jLnUfiIdm+mwz86OWD8y2Y7Pvy0rTvb?=
 =?us-ascii?Q?555kk1kqH2bwuPrvkIr0SkjnwHO4BAtsgypKBYbMtKR3j+hDfy2y4sY3KPue?=
 =?us-ascii?Q?lhY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230034)(376008)(1800799018)(366010);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3chimejPLZAHv2M17COTTLpdQaCuu1U9ssxjUDpDH+vRAHyxpMsLmZ7GtmUj?=
 =?us-ascii?Q?JSrvHzjHaMNhDp/SA7CIc+DV5fwzyjYJ0B8JdloPXZkqOMzrbJvGm+cictyH?=
 =?us-ascii?Q?VCfm1DzsO3D95PPyDYIuyKMpR3Yol9xFQ39ib0p4boKkRzwx6yRoV4UTZgs5?=
 =?us-ascii?Q?oVYWd+Ojit099vddwUdFWZMFlJoiEDrIeWO2eUhmg1ufDkQNeuZvefQVeuaR?=
 =?us-ascii?Q?KR9j0seG+mViQyCl3AIrN8YU5KcnucDQF7pcw7jOhzxfAsaZYa0s7bqlGwAr?=
 =?us-ascii?Q?BMV35f64XyRmxSg8weKwQEm/kkST/zDqk0aS/gwWQV7RbKmUpu2PA0SDGFT2?=
 =?us-ascii?Q?RIZqqYCZnWjCGzKgWsY9Z0HEehcxc+CnY9AMayVPr1oXJdDJDQtdpkKRktpr?=
 =?us-ascii?Q?CC+bHKixyJGri7CAV9ft0U5hqA03t2lubnaRJmqTFcwtXboPBixRH+zzT9Lj?=
 =?us-ascii?Q?jwZ/HLjX5onDwYQY+s2Nx+1fckqzjhMWS3SIHA/mCZXKC79XcX9LMzAZetfe?=
 =?us-ascii?Q?ieT1QHNTOCWPoGm08ldPRiUtTG9SX7It3hwBUIjur4epdcS1aTRg6ezz/bwu?=
 =?us-ascii?Q?h7VmVSLqC5kSIqbIjK/8KktGHiTU8bMO7mhJc63ImKYTTqMCRuwq+jiwg0Fe?=
 =?us-ascii?Q?Ku7bV9pu43GIpVwpv41TRer0K67VYe1KuxjwpbYqpGsANVBPfh2/Nwhc5fao?=
 =?us-ascii?Q?wSeyYXrCC8vSa+xr3I3I2kA1eYXHUtQw8skuNHdbCDFxzUJtA+wy6SLtoRAG?=
 =?us-ascii?Q?rB3IWzqJVzbgChtfEeAxyM0oPbTbCcE5JEY3mV7bEImKaMfZKH1/Ff3UGyaJ?=
 =?us-ascii?Q?wB/CtA+n4oLq0ZKZordml79YklbbKqBYszguagVs1VuQYdkYgjCpsi9GRXT7?=
 =?us-ascii?Q?GyTKMT11P62ufDHjvXLgri4QPYNZC1rsz/BlzR+8mYWT7S7B6H/rlx2isyqu?=
 =?us-ascii?Q?6KayobpcUV8TY5QOcEKNbjrtYe0cvFk81m+feBvQ/tRNp+Qbn9H1Tt5/LnKj?=
 =?us-ascii?Q?YojHS6Kkt/2PtE9DdvRmD39Y+DMuDatb9s+Dttvb3dPLoQDRkeGeVx+zB8ag?=
 =?us-ascii?Q?PFh3Myt9enDP6GJO9M5fT8pRlNQj00zRF3k6eeLvXkkHLUSeXEEKvBAN8Yln?=
 =?us-ascii?Q?a2tXrDmq338iVHupw4dg4sJOnL5pK+41VlXgh2rtkuD5yfM3+Y0k2IY9Fqo4?=
 =?us-ascii?Q?m2SaWBryAw7aGw381Ep2pzUf8ASpOnmWUaUVxDDLzanNlF/Ksef9H31Jh1Af?=
 =?us-ascii?Q?66j620BtHr4oUlWR7GUnZ6BZysKm1BTKdmilTtzgBmwmXNVkeivnd4vSL8vv?=
 =?us-ascii?Q?kUA3Sluy8p+5aEjcYz6Msk5L53budWH76RABsq/uEgMplnMYb1YCgWf1USkW?=
 =?us-ascii?Q?6c3IScQIylSl3xHh9MQui2aCeQWCSPT6o8FR1z174QFKaExK7UDUfKSYrtkc?=
 =?us-ascii?Q?2yU9UggGN1O433ewQ6GkD1Ojv6seRZqARwa1NAuARdVMMD3EuTiG1UH/kNqe?=
 =?us-ascii?Q?RzQS8LREqMDLUkeV1oYzEWbGaED0zS6WTkpQHVffW20EEx72XvOE7Ri6K53z?=
 =?us-ascii?Q?kr70z9Rsrpbr/4vLGdJ2esKtF72Ei/g6bMIgGRVr?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6204d289-e7a7-4fea-8e07-08dc8b252f59
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2024 21:18:20.6423
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pyLyiuXR6oT2irlv4nH1NGy4DW60ROFf1hMt8xtWpA78M/7pW7uX4tQfMQQSIWYJHkiAA1hXfGpZ7/iPrz6Mtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6683
X-OriginatorOrg: intel.com

Greg Kroah-Hartman wrote:
> On Mon, Jun 10, 2024 at 10:44:42AM -0700, Dan Williams wrote:
> > Greg Kroah-Hartman wrote:
> > > Now that the driver core allows for struct class to be in read-only
> > > memory, we should make all 'class' structures declared at build time
> > > placing them into read-only memory, instead of having to be dynamically
> > > allocated at runtime.
> > 
> > Change looks good to me,
> > 
> > Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> > 
> > ...changelog grammar tripped me up though, how about:
> > 
> > "Now that the driver core allows for struct class to be in read-only
> > memory, it is possible to make all 'class' structures be declared at
> > build time. Move the class to a 'static const' declaration and register
> > it rather than dynamically create it."
> 
> That works too, want me to resubmit with this, or can I update it when I
> commit it to my tree?

In that case.

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> 
> thanks,
> 
> greg "the changelog is the hardest part" k-h


