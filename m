Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6094B16A956
	for <nvdimm@lists.linux.dev>; Sun, 16 Nov 2025 01:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763257755; cv=fail; b=rbadrf3BqVcMKpwPzCj2ICoNa2s+IppBIqm7HY2v+voOcD74lWjfL74NseCrqShKPnRWKdhrJxC8zKRM2JlRZ7meAbA/9wOo8rpbfRmf9bmcUvqCqezYrj0KIj5AtRZT/lQcLlM9Acq1XoqYrr1rCkeDnmhHS+q2mWnX4nVe9Oo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763257755; c=relaxed/simple;
	bh=qBFwHm1kMv3VjYsKzsfRcWQYp83q7X7KzUl3wRdT5Mk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=IUOwMUpQEJi71ao57dXoZwMHXDOJu5zRCmC08rNj4hsW25aX3n9DBe0xoAks0S3byq5dqLCNJOULsR05HO/na/FPpGZEmLagvi5X/b0PJlb2ZHCcxDIQt0Vt1yk8Kplzih5IKzWwKBg1LIgzr+GpyPeQshvJjUJJdAknemL3yEk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YE9GBPPA; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YE9GBPPA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763257754; x=1794793754;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=qBFwHm1kMv3VjYsKzsfRcWQYp83q7X7KzUl3wRdT5Mk=;
  b=YE9GBPPALzj3/z47a5C3QOwvjW3BGUxoBhf8jFUO+i/nJUePfbNnYQl/
   RJfm5/vo18qJIpifujIWZRlTlz+pTFXvc8KmteuStTOFOTI+ujcrm3LD5
   255OqNpFcWaHTjx+MuSh4/bV98piV2fgTP7eCBH9hhM8tDh6I2lK3ve4a
   VH2cwk9RGdAR9RFL17gLhSushZxwUx4hazKFosPTgZDbdd0u4vFJ++i8t
   clWLvQ8FaUn2In0zyNadQntrc01jTybgToB1D2kyqXxLcnB/K8JWuH3NF
   51/FIFshJHm1Ng2NbVGyGSLpMV/M+q7LoPhtVXV8A34yfbLxfRfSTkt4E
   A==;
X-CSE-ConnectionGUID: Weo4lUGtRPCdJVe5DqJdlg==
X-CSE-MsgGUID: sFdxvGCzT/+2QkAwfUFWwg==
X-IronPort-AV: E=McAfee;i="6800,10657,11614"; a="75624848"
X-IronPort-AV: E=Sophos;i="6.19,308,1754982000"; 
   d="scan'208";a="75624848"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2025 17:49:14 -0800
X-CSE-ConnectionGUID: 2jzOQ5TIRsutgZpdEfp/yw==
X-CSE-MsgGUID: H6/7SBKmT8elUkMQ4sLPjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,308,1754982000"; 
   d="scan'208";a="189941942"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2025 17:49:13 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sat, 15 Nov 2025 17:49:13 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Sat, 15 Nov 2025 17:49:13 -0800
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.9) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sat, 15 Nov 2025 17:49:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HlgxX6lEG0ZGOy09I3y/nw2StFiRIRL22zn/AnqkjDSRe5dz/5WaSWlXvSZUA/iN8dMoJfrfxTRPqE7jEJnOpMve5dzjtf8P+Pnx8VUqbdob2YcKJtgbpEcMzaKla/rIE8PKL/DNXncAE48g10DIlp5pK6GXF9P+FFz8uOzPg03tMzZiA9oXmJbuqpM/JoHAZ2PqHZFsLg35jDOqeeNi/qH2N8cy/PZ1XWpj1TUo0uU0c+tYngqccPRveQjOuubDvYJbnjiU8a5WlUIZm5G7Hp1lyc+nK50pQ0EAeCVVjPHEb7c7wMIC+gpl61eqVOK8xFpN1yhveqKwIWH+NWDCPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qOlNSZpIVe0y5WXa/QYcmQw3d0JLvWYCq4YbesZoywo=;
 b=O+KvVPTxIrU+Cj1ZH2FfnpMG1bO4ObGw+LY7W+fX4/s9XuA4bRIDbLb39Tp6Z2zm1jo8LFaxLoqgX9FsfC8xxaV8bREvKgWDxciXfYKGZUCANwdYK2mab4i6FlH3jLAZr26M5UpCGFBcIvhoVcfY8QqPOSR7KflT0020b9/txWwyT+F76x3NrHI8S7bL5yfjOFI/LC3NN5hGAp8KKeAPTLbGwjCb0vvcOb0M0bwnetVGo5wXhA/GRGgF/Nq0umdVJI7vE/ENAzCemdvCaYTCuwlkSA58EhuulMv4t+FE4ihUpu4rmrWr/4VGTUEQTETecn+ZEtL79394f6KXG4NprA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by DS7PR11MB7740.namprd11.prod.outlook.com (2603:10b6:8:e0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Sun, 16 Nov
 2025 01:49:06 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee%6]) with mapi id 15.20.9320.018; Sun, 16 Nov 2025
 01:49:06 +0000
Date: Sat, 15 Nov 2025 17:49:02 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dave@stgolabs.net>, <jonathan.cameron@huawei.com>,
	<vishal.l.verma@intel.com>, <ira.weiny@intel.com>, <dan.j.williams@intel.com>
Subject: Re: [NDCTL PATCH 1/5] cxl/test: Add test for extended linear cache
 support
Message-ID: <aRktju4Zjbe92-w-@aschofie-mobl2.lan>
References: <20251031174003.3547740-1-dave.jiang@intel.com>
 <20251031174003.3547740-2-dave.jiang@intel.com>
 <aRfrTZtRF54vyFfa@aschofie-mobl2.lan>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aRfrTZtRF54vyFfa@aschofie-mobl2.lan>
X-ClientProxiedBy: SJ0PR03CA0138.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::23) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|DS7PR11MB7740:EE_
X-MS-Office365-Filtering-Correlation-Id: 741f9e5d-e89c-423e-d49b-08de24b253a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?5+QE9YObhyq1QwBSfpnlv4ac/XUOeLiix6CUcG+FWA31YvkGHb/tQ4wv06po?=
 =?us-ascii?Q?8XPRNgwDuzq0AHKHHEyogdFy/SgyMEUoIweANhebZmnh7x4KdzPlpvlExTN7?=
 =?us-ascii?Q?370eFn8VuD2uceVlXEzzbcU+3QKNMtQGoHguW7HWdyCi0wyu/vifuSCqWH9r?=
 =?us-ascii?Q?40MEykK9mLpr0/v4DqdHD2QLoXmCA0eSbveUOcYHQbdvCLsCHhuwdPYVZB/j?=
 =?us-ascii?Q?Wa7sb8yBenTYxTz6aBlQWJlfO+uyM9SLGdICkCQh6lXfyCfkOgnIHqayUPZE?=
 =?us-ascii?Q?n/K7XSSoqxqk2D871MrDJDQa+XR3Nd0bnlSnFvf9nxkKfohdhgddUPI3c5ow?=
 =?us-ascii?Q?ZQ/OiY0uaCCG0JiOFCY3BBbnYkPjPtiWgn+0lRm5Yh7NyLYtWd0p9PBbcyv7?=
 =?us-ascii?Q?grO/+j4pkljOuN60h3fAIlWQ/SIK5/VgYRrqhIKZC5KTziM+UNxaqavnCKD0?=
 =?us-ascii?Q?ikn8smTATlsiQ4u8LLLuyb9zIzDqrSp0iQ1uRSSVsYijd3IBvdVDpm1TRMes?=
 =?us-ascii?Q?h4myHUh1RwrCw0g6csL5OS7/T/dKt+LWCIZX8grVRQq3A6vVZqO4Hbyh8lJe?=
 =?us-ascii?Q?FEybIi8WkNGrPcyLpzOXA+JYb7ja73uTIdo/QknVyoB6LkbPBWZpg42IDDLZ?=
 =?us-ascii?Q?/Nd4PWd1liTn1JQGfNuyxfWJt5X9YAzeHU2e7eKidJzadp7Z0VQKSH8pCBvN?=
 =?us-ascii?Q?tJdRRA+Qn8u74fEE2GfQS6NyyN9/GUsUz9ARMKz4BlTixJHmM86wYfo+LKY/?=
 =?us-ascii?Q?ELC9qsL2yhslGt21PXEqDpwO2zydf10FKpSJ54tuyRqTJaTfPU/XRp+5AiC7?=
 =?us-ascii?Q?MRiMil4CiXC7N3ebVAkb0hMlQ2jcwqMizETHld3iyTroo3QkH0eXv+F3gxgo?=
 =?us-ascii?Q?W4YPz6YacF0igSB5hZ6GasTwNozx2P/9Uc6N2LH+VxesZwzxcl4UIOrDVZi3?=
 =?us-ascii?Q?U+WDTdxyqBLk3GmTI879lXCEMltx6rZn+tb+6MWh8Plbvfz4sKUBwwR20U39?=
 =?us-ascii?Q?mJ9uRh6nthaNuc9ujgsCbJYMPICRyY457jaN4BspHxoF+Q2LzWqKvdT9ZSEX?=
 =?us-ascii?Q?Z+fciQkh9kg7y2wbcSB+c13FHahb80QQMPpk4NWQlbin7DAqlVuGrj2bBFTR?=
 =?us-ascii?Q?ttfBP30K63X+4zLP/r5rcG6Y9YjDTzQWp+4qyqwqn1rOzsvnhc3fyujhExq2?=
 =?us-ascii?Q?y5fGoo6xzzQT3Ok3fcNq3M1ehz0ZGgGvXCxzW1yVaxPVkWa4Ixc76iqbPYQz?=
 =?us-ascii?Q?1q/dAJ41/ktSXSYFhS6oGVazyFCi+LSWScCgxfzbrKRHQa+rzhW2XAJBrntN?=
 =?us-ascii?Q?y1GQj1Np7oMrhcgNMyuD1hFGlKwKBCMdaJtwoxn9QhO2mtmQts1+Di1vnMkW?=
 =?us-ascii?Q?M32C/R6Q8Mx9CDcn/3vCkjbDp+tx+YCvoQqLI8Yd8AS1JGv/PegO4jFOz9lr?=
 =?us-ascii?Q?NFi0ul9b6zSVI4+QTptggxDMpDOVWhUu?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?M5cW5uMkoufe9nWupSWyZIaXPSInrwww7VbZoOK9B2PfNhJY6HdJL/ZmoOHf?=
 =?us-ascii?Q?FHxW+6tfHOmRWaluem5qojlUkINxMmuMLlEoVpyOJsmsVpXgcKjBIAvbMZ9X?=
 =?us-ascii?Q?YR9GyL85fT1BfZq/Quyp52jzc8B+pEUAc0KDDaLOaoNToHuJE2ZGNKU3J7Iu?=
 =?us-ascii?Q?+KUHfD05ZGOLBvNXeqR9gAtzLaX6yyVjJ77z6DUIdjTrGZStibybFWZhZ+/b?=
 =?us-ascii?Q?k+JAVwxOUnSVKkbgZldsykyYpwzQgSDAYNPyLHX0QVuspyVeImcecfF6/T6m?=
 =?us-ascii?Q?vVm2APYtKW/YSsLNFtjUTNzGuCm4QQS08swLrf5WUJzi31IG1d8bwsoGMT4x?=
 =?us-ascii?Q?7JZUcs/xyzW6KtTwxjG6tNIODicy/la69wg+XMubdrftWaNhNV4IvcpwMGAl?=
 =?us-ascii?Q?riYWZgbOBTqkrk3SkmoeHg5Mq/RxU/C2jhAWreaAY214L15OrM2z95yHcL6f?=
 =?us-ascii?Q?oZBiEXbROrSKAkAFEEn1rK5PO0Qw21l4YpPxByLNbV3keV9JrLgUavHjaw7U?=
 =?us-ascii?Q?qtnNBuwadg6mgJI/zzlcQQkWtVyoN0p43FN+J8a0mTSOq8xX9yBuAfpKTTwk?=
 =?us-ascii?Q?MEk0fRTFoMheqZYv+jzwKMSvjf3VUIEBCA8xzkf+HdCWU3aqvVOHOaGB8zs8?=
 =?us-ascii?Q?xjp8wBTrOo9PRYg0IXw7cAKe0GToF41vN61U5scJiSTg55k278J2h5zhGNzY?=
 =?us-ascii?Q?BHxmpkWo5YQ7nWw45SaHeYqxCChcARMBusjZcXDt2AFJX5LZg7Z9LFvhTAZP?=
 =?us-ascii?Q?n3BSzLsxnAhE0Y3Zw+bi3f7ReCUG9KVk6K38A57pZt1cTXaYQ2WralKvzdZ/?=
 =?us-ascii?Q?AFZ4A9un/LZnUiPaYC3m35QoDPsJ3WIsYxfLoZd+gGBaZuq2T+xqP9iPDuZK?=
 =?us-ascii?Q?a2cQt22yo4aKpnZN8AjwHssrHSBpmarneodKlwQt4vyL4LLJY/IANy7F6RH5?=
 =?us-ascii?Q?Nym22mOg5wCfzeHijhY1YQmHgB6t++cn3uQLxB9gJ9/3C2kAFiI5GpyYsVAx?=
 =?us-ascii?Q?uZ4HkVrz+q2LdSrMv9u8F3Z5nwDpKl7i7tafmOaJ146pGCuKGsP+gLkRPUDR?=
 =?us-ascii?Q?sxt+TFDcdCiGBbFe7QTjBbmReoFXdBCssoczBKG5tYxt/v3mzD5wWP3mVN44?=
 =?us-ascii?Q?5vl8mtUT+vlsp/Xe5Vc9FTd5rh2xou6Oj1tDe5OWNr8MiOJuBF+eaI//jxjE?=
 =?us-ascii?Q?digW7nCA61pyeYRSChhLRz0pgpw2kRomzYIM9giS+njSNtQc9iTc22RbC70D?=
 =?us-ascii?Q?KT148OOdSScD5kz6K77BZetQKlwbcJCycM4dZr9u/UetI2i5ErLytwkt6G+O?=
 =?us-ascii?Q?bn3Y9UZT5/IvC6QG3gjcYWtXb40tZEw+u+FXp6r9XbrajOufCWqxszvLjAXs?=
 =?us-ascii?Q?XlBavjGYPIpxltGglUYlQmD9ETWPs/xu8cF2xP6OT+na2AQjqz8AKCCtucO2?=
 =?us-ascii?Q?XJnVY0tT7SGy1ns5eIs/nkzlPQejdnGjgIqNxMEWZ/65kMxb3KOwmBLFS5sN?=
 =?us-ascii?Q?Ewm5bHUlXau8rQphmU8VPw1PsMidhn8fnJ0VQX9fmokuDeWeAO0OUPcV2O5+?=
 =?us-ascii?Q?RSAo/nM4qCTocSedEeq6kS1TwkrivAFPmRMoUFec7ogUiMVD7UucEwrw/rKa?=
 =?us-ascii?Q?xw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 741f9e5d-e89c-423e-d49b-08de24b253a3
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2025 01:49:06.1687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pcK5OR37r7xKZuE7sdxEivZN8FaSlEZDw/ishmr8WAatDuwkbqMoge5lAmR9F9xMMRWIEqwAli4GoXzGTR7roKhrOjUggTuoxZkqE0Dip/Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7740
X-OriginatorOrg: intel.com

On Fri, Nov 14, 2025 at 06:54:05PM -0800, Alison Schofield wrote:
> On Fri, Oct 31, 2025 at 10:39:59AM -0700, Dave Jiang wrote:
> > Add a unit test that verifies the extended linear cache setup paths
> > in the kernel driver. cxl_test provides a mock'd version. The test
> > verifies the sysfs attribute that indicates extended linear cache support
> > is correctly reported. It also verifies the sizing and offset of the
> > regions and decoders.
> > 
> > The expecation is that CFMWS covers the entire extended linear cache
> > region. The first part is DRAM and second part is CXL memory in a 1:1
> > setup. The start base for hardware decoders should be offsetted by the
> > DRAM size.
> > 
> > Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> > ---
> >  test/cxl-elc.sh  | 89 ++++++++++++++++++++++++++++++++++++++++++++++++
> >  test/meson.build |  2 ++
> >  2 files changed, 91 insertions(+)
> >  create mode 100755 test/cxl-elc.sh
> 
> snip
> >
> 
> The call to this:
> 
> > +find_region()
> > +{
> > +	json="$($CXL list -b cxl_test -R)"
> > +	region=$(echo "$json" | jq -r '.[] | select(has("extended_linear_cache_size") and .extended_linear_cache_size != null) | .region')
> > +	[[ -n "$region" && "$region" != "null" ]] || do_skip "no test extended linear cache region found"
> > +}
> > +
> 
> is missing from here. Just found while testing w patches supporting the
> parameter. So you can fix this and ignore my review comment about
> looking up the parameter.

I got that wrong, we do need both checks:
Skip if the param is missing
Fail if the ELC region is not found since that signals cxl-test breakage


> 
> > +retrieve_info
> > +compare_sizes
> > +compare_bases
> 
> 
> 
