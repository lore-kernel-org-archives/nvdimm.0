Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83769EEDE
	for <nvdimm@lists.linux.dev>; Tue, 19 Aug 2025 18:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755627273; cv=fail; b=pECjn0jXeRDdnKyph1zuT6g88Vz4DrNfI2ApzuHDQ69Iw1hlVnHQ6prdq5GDY4P0PyIcYjkU62NzzGv19Sh9oy40m6YRYqJfTXyy/Zyj+GrAAZe+dh8GAFGXKiEmPEN1hNk3TVeEb7yU87sPevIOCO16ObPZfXEJRuaf9HdX9FY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755627273; c=relaxed/simple;
	bh=O3kTDCQ9T+faAyQjF4Clo9PrqoPtnwVEyMmxRYOw0hI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=TR9Oh7sUs519cb34XTAy+BLsbPmzu1o5SLxjJlQzm3nVkr4RAReYHQ82P0QwK0mAeEeGWRcYJAp6Lp8YccWyQXayNb7m59wuUvBAVeaFXTXaQGh+XKtJyHukbppviu3PSGk8wNtXcWYoDTgIp12oCJvh6ESBduq8TQS/qe3DIyw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h5JpsDYB; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h5JpsDYB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755627272; x=1787163272;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=O3kTDCQ9T+faAyQjF4Clo9PrqoPtnwVEyMmxRYOw0hI=;
  b=h5JpsDYB3Zb4wy3WU9E33FAOkVUad0Eo/jnTVMoWYhDmhqsD1jUvsI16
   /RegP+Rl4zLSi9Fz4gWwq3EHYcxy6G9UIq0BT59LNGIYMeR5YjNXG/ce1
   MnyggmkVZGrj2TbIiKKynW8yJoCKnAEX+U2nWCgMS5e9nOnfucttJ8h9o
   SDGOe3fU00zpDrvAsvkKR6jX+EqHHmMRqS5tiPTwz4tMkuRZDepUSlY69
   znArV767vCXDAmcjmeBbpS8HCDJhQB/e/ab4QJlchw8h2rwl1hQ19b+mc
   c/mtcwV6YSJbc6A4O6zGFtdUvXMccCIHwH3EY8XCCJ07VwyqajYA+KMxf
   w==;
X-CSE-ConnectionGUID: EDXES0n6SR2sFhoWwJ/h6A==
X-CSE-MsgGUID: 3lE8kBS3TnOXuZBpx8S3Zw==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="61517473"
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="61517473"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 11:14:31 -0700
X-CSE-ConnectionGUID: hwQdQQFcQr6o5mb5IizbEg==
X-CSE-MsgGUID: 1O7Mw64xT7e6G9eJnqWcNA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="167829941"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 11:14:31 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 19 Aug 2025 11:14:30 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 19 Aug 2025 11:14:30 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (40.107.95.76) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 19 Aug 2025 11:14:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jVcs5ckWXB8fx/ACJz+ZZyqE6KtOv6tITXk84dKzTfIDiaAf6m4EIzDheBXWQ3O9Q8O7Am1lARM4g9degf0Qpejdh7CdvQ+3uTqF1YXocnDFP0CNBmAPOrn9/wgFtI1M52Xzh7Bcfx3tKGWO6ct38CCh8OPHSZ4RvXcyYAh222TqM+Y2kdQ/Yb/dXkSw65xkzJkEaklZfaPMHuAXGIhT42fq9z+9WvJCZckFPsi2NGKrbgSsqbY3Po6u9SFky54KLNBeF1oNpSHEeLGZO6vQ6oQLaFqqsV8uW6YOwWFb2ia905FwMzafOFXR0zGqn2/WGucLAXr77ZYQLVUhgDF3pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xKTAqbh/ZFp3glJ8t+2fMuNFrXfmYty6OxEjaj+dZKg=;
 b=iylmK1fQUdjuKbYG6m6gM4qwMgDFiPXxxjyKcG7VoR2z0FtffwAXhFGK1PgYaV04PmGRQM8xTJoACN+YsrUGEQHqyKNdmYQgi4Fe2M+KM5Gw50NmdYd50FEBFjty5trXvsW2zGOV1aRUCCCYtumzV975mMSdwreMLGq6hhAa3bHfDpf3sxF7tuKE8n5OtNlPr9KgG4mZckPfT53EoUcgXVAZE7SdGb3qkG4JIYQFl7WOmRE0ni9h2QoS5veA32ElRnv2Y4zz/LiJEllxFD/5xOHBBSyGw0XZXX13jWMR61KYyrRXXYcTrd/xRVmcF2f72p1/Y76qfVXUEyzd/0J5sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by CY8PR11MB6913.namprd11.prod.outlook.com
 (2603:10b6:930:5b::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Tue, 19 Aug
 2025 18:14:28 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::bbd5:541c:86ba:3efa]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::bbd5:541c:86ba:3efa%7]) with mapi id 15.20.9031.023; Tue, 19 Aug 2025
 18:14:28 +0000
Date: Tue, 19 Aug 2025 13:16:11 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Neeraj Kumar <s.neeraj@samsung.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<gost.dev@samsung.com>
CC: <a.manzanares@samsung.com>, <vishak.g@samsung.com>,
	<neeraj.kernel@gmail.com>, Neeraj Kumar <s.neeraj@samsung.com>
Subject: Re: [PATCH V2 05/20] nvdimm/region_label: Add region label updation
 routine
Message-ID: <68a4bf6b747e2_27db9529461@iweiny-mobl.notmuch>
References: <20250730121209.303202-1-s.neeraj@samsung.com>
 <CGME20250730121228epcas5p411e5cc6d29fb9417178dbd07a1d8f02d@epcas5p4.samsung.com>
 <20250730121209.303202-6-s.neeraj@samsung.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250730121209.303202-6-s.neeraj@samsung.com>
X-ClientProxiedBy: MW4PR03CA0174.namprd03.prod.outlook.com
 (2603:10b6:303:8d::29) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|CY8PR11MB6913:EE_
X-MS-Office365-Filtering-Correlation-Id: 31a290b8-9e24-420c-2fa6-08dddf4c3c94
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?xKw0WhDKzSq8AtMYf7aXYTmo2OycGEb2W0AzcL8gAsKEdPa80Zcd16xG8ypt?=
 =?us-ascii?Q?T7heS+tkrfujn9qNXxldgx2G/sTw17lPZJfhe5oUmpIVZL9WubNsI75qzvhG?=
 =?us-ascii?Q?p+fARvqnZ6+/VIb5gXPGS1M5MvHXia4uQ8mVU+tOu5r4VuqNrSvcQsu4MP3z?=
 =?us-ascii?Q?oI14wmWIGQOeGjXfDCXZy+9z+QFA3D+EoNBAmGrUh2ir6UrdCXATxNxY+obD?=
 =?us-ascii?Q?Ztn4xkVgOQpYPxLX9izYIn0RDAGWq+V5Sn4Lgfa0kCRYt37DobWd3Y5/FYu1?=
 =?us-ascii?Q?IOe+3jkNN4sEmgbpwNpVmuWhVHK0QJ4HQHuQ+HZLUHMMC3+qitqGSLav22BT?=
 =?us-ascii?Q?0XFyjSRlOjwJlzx4slILbkNJo8atF5PAhtR2ZHxxaQNm11xs0jIdY3NC7gtU?=
 =?us-ascii?Q?7fsEWFoiJbF8eWb2Oci14kcaEiPWMkdERT9g2mHXLJguDBMgOf250z9RhVW/?=
 =?us-ascii?Q?4GabQf13OA/3MtgQMENcR3UseuAvhq8flr/fzK8CKT59Ypwj2fJcTJ08WfYc?=
 =?us-ascii?Q?TtyV9uQrMznkhAY1NS8GS5ivijtNm8CNm6/QXrjFXeTZNG5hhkm6758n46LE?=
 =?us-ascii?Q?YhqZZ2TdfEJ7jWGmeE3q4xBQr++TbB3X75VU5Br0Au9eCJfkv4MR4iLZNecp?=
 =?us-ascii?Q?pNXtyQZ8KEW2IQ+T2Yjubs53CZh2CluWus7KpWjvHdMCb5OV+pbGxMGcZFbq?=
 =?us-ascii?Q?ZQ/Ch3qZj7o/1QiaaomrSZeBfqOrwz75St3x+LuA6EV8n4mFpUHXSwNVxQlM?=
 =?us-ascii?Q?7WIVcgJyu9fcutDqc/zyq92yKE13K+6GNHOQ0ZJR/DL5KVQHZRLlANe6uXSS?=
 =?us-ascii?Q?AGol9zlBHKiC+Sp15NH2U7troOQtEHv8yKQGThqDz0BhbFAvWz0frgQ6Wemm?=
 =?us-ascii?Q?UWIW4/q2D5CZ8BIXcqhp/aB4S2EedLIg32KrWakkyO15Sl/1jRBpOlftTVHt?=
 =?us-ascii?Q?QplXXPc6GA9xfK/nSKBYjdZuxHr3piizz8eqQzOquLvb0kXVfI52iyoWlyvv?=
 =?us-ascii?Q?Ce5mBUT5/Guy3AplOkEpHtfi36DK7Jw3AKGil3rVt1hBB5ERNuDhY+fzOux3?=
 =?us-ascii?Q?6dOi9EwfYg8kXsFQdDNJll/7Zq1rmf8ejUz3eKr1xd/CBQRwppg+ib0WIA/m?=
 =?us-ascii?Q?OIdf5psAr7WiF1gU2Y+tJ0eJLIlZQfbWc68944VK8lBAVwqzwwilMJVUgLmk?=
 =?us-ascii?Q?HMtOZvn6AaOgShDeZoxJMjRO3l4NtcZU9p+DAwX1LskgtpJqiqhWiAmmg2PF?=
 =?us-ascii?Q?WnfMWOYeGc0Y1+QOaEB3lZkGiYFqI52WJeqTR/He7cdzmtLeDLabwSoCrDb0?=
 =?us-ascii?Q?BZG8XFSyB3oVtZ3rIg84UxUKUSMo2Sd3A9wXXst2JY+u4KOFnXNl1qfYEd+c?=
 =?us-ascii?Q?UiKATqJRpEMMxYMPy+5QRBeJkLqXU4brOXUlJcx5oN1l6mlOZh5I1LzIG0mv?=
 =?us-ascii?Q?RtzXEcizAQM=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rnCyMcD6OGTJ9jEzwU+72/gl+Pt4Jzf7C6SOARaZu9iZDIpeI6nGDx8RNx1D?=
 =?us-ascii?Q?lu0xSU5aJVXCAtQjOphdEE+SOE9s/F4fuR6hSrS1Z7l8TvRW0qL2n75fV/Ch?=
 =?us-ascii?Q?UgC0C7pTGG5iy5oNqWf6tsmhk2UCuhlKa9wUQWLQbhEdaj9uz8NCJUvA5ytc?=
 =?us-ascii?Q?LimAHo+Sl1b6xkdntk1uyK2nl6AGmVRWEoBf3uOIy63hpRvpIsejuBKkCsAQ?=
 =?us-ascii?Q?9UyYdfQjX2dJQYPNMIBbK/mjBaThjCE2vYZx2YEkNp4HfSRkZxuP0JN69K51?=
 =?us-ascii?Q?g69Q4irFzXkGxLs73F0vAnxsuuD2uYL7MoH3Qf1AxNdyG1sXlBqOJx2vYPjP?=
 =?us-ascii?Q?uECV6gxsn78ipgDsV39xgPfPE2RWvUIYAU8BqoWxWiA1OYcKX2c8xHwdW0h7?=
 =?us-ascii?Q?1IRrvhtkA2BT83Bi8yFP554hdgKT74hgScGxLsr2H3pYZkZFChTcqxGHC+lp?=
 =?us-ascii?Q?Mp/ZmmDC/ntNKgFm7g8qZpYAAWtKT0LoUl3x3iy34LcCHAQXPICFXNXuJfnA?=
 =?us-ascii?Q?3XzsrOlTiSTm1tUV6anaBr5cdckTJhAayklcIQVMLftNtX5zTo1v8mIiyIsH?=
 =?us-ascii?Q?elyY0HLAIWtUuiP8i5d18/KO+F/Bqzfv2mcmaM3ShzbOLZ0Xm1Eq8sjfqBm1?=
 =?us-ascii?Q?S9SR79zfUH9eYMapXBMNglCChjC0169wEnyp+QFwRIn2KsxSxGhEF7LCDBc/?=
 =?us-ascii?Q?TH+eXdmb/irF8i+XjRD8eqoadodOYvl5C37kVFIsDWRjJmyMJ3Y/9M8B8O9s?=
 =?us-ascii?Q?Qvl5xKRRrQl4/VfZdW34P6KFMotDqBsefvaxIFRGZkXBYqP8eJ/29G4YRukP?=
 =?us-ascii?Q?9j6iIbfoE4LakNIyr0gK/0/oaWAyueLaYbcNm7wuyafjT4PnH+wAUBWw5SKq?=
 =?us-ascii?Q?anqbwT/LBQ6GSDGl8fStOBItlmME5ZOdSaQpkJ/uAr2FXJ2Ewnf1c+LislcR?=
 =?us-ascii?Q?Zz4rZDnXPobmZdEh85Xkostd3XwP93xNZbh7I3G5aZLUwyng10qkVGD9bnvI?=
 =?us-ascii?Q?Nx6JB/aFX6P7w4g/ql4eZkNbqn9NUr/zIJrxjFsuGI1FtCcka4NYNcE+dn1c?=
 =?us-ascii?Q?U7IQ+WGv9W9md85rOif1HgApELfuAHwC31RBoK3GkmZeWdCD4VbCx8BAOAJx?=
 =?us-ascii?Q?Im56Nn4A5bYN9njGbIVRNAyKgt7JxwYItZmSRJJIhFr4pS9Pgxa9OD1UE9zc?=
 =?us-ascii?Q?HD98DT+Cq9RGONzSKw2255m9KQrUI4ryiMxRWpQezLzQF9y5+m1a/OdHG5TV?=
 =?us-ascii?Q?d/wiEpGwvpcn6F+SkkRVl968SOJ+OQCVwZDllVhBJcv1z4IeLVhaIc6Z5LQi?=
 =?us-ascii?Q?6PybjyLdBoxga7iovR/lMXG+UNuvWCLLr6X10jgUoIQP5TfDE4Uvh3eP/mOW?=
 =?us-ascii?Q?Va6vNgia+mftSxfDlsDREXp3tT2VpyolH1N/xszJ/NzoVhq5F/oa2xDwgrd4?=
 =?us-ascii?Q?ugEmBbuj5hms9c6zOj9Yz89auOCd/cCSBRruQyAA0Ue79EnubTGv5mhSBWug?=
 =?us-ascii?Q?OBNCMa4rRWbZEc7mciZ+2f4uJJ/EFKN+++Qf3ESbXvvBoOd+eXFsnmlube2y?=
 =?us-ascii?Q?IadsunnjYMSEcT3afB4ySbsjuYrFH+CRe8oq6UEY?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 31a290b8-9e24-420c-2fa6-08dddf4c3c94
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2025 18:14:28.5063
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IIF9XQS/4dweWadU8ocCv+AJBn1NGOqp5Nw7ssfQZXZ6t1AjP93goe9kC6HUP6HE/ur0lnC27JDMz4V4UcUprA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6913
X-OriginatorOrg: intel.com

RE Subject: [PATCH V2 05/20] nvdimm/region_label: Add region label updation routine
                                                                   ^^^^^^^
								   update

Neeraj Kumar wrote:
> Added __pmem_region_label_update region label update routine to update
  ^^^
  Add

> region label.

How about:

Add __pmem_region_label_update to update region labels.  ???

But is that really what this patch is doing?  And why do we need such a
function?

Why is __pmem_label_update changing?

> 
> Also used guard(mutex)(&nd_mapping->lock) in place of mutex_lock() and
> mutex_unlock()

Why?

I'm not full out naking the patch but I think its purpose needs to be
clear.

More below...

[snip]

>  static bool slot_valid(struct nvdimm_drvdata *ndd,
>  		struct nd_lsa_label *lsa_label, u32 slot)
>  {
> @@ -960,7 +970,7 @@ static int __pmem_label_update(struct nd_region *nd_region,
>  		return rc;
>  
>  	/* Garbage collect the previous label */
> -	mutex_lock(&nd_mapping->lock);
> +	guard(mutex)(&nd_mapping->lock);

This, and the following hunks, looks like a completely separate change and
should be in it's own pre-patch with a justification of the change.

>  	list_for_each_entry(label_ent, &nd_mapping->labels, list) {
>  		if (!label_ent->label)
>  			continue;
> @@ -972,20 +982,20 @@ static int __pmem_label_update(struct nd_region *nd_region,
>  	/* update index */
>  	rc = nd_label_write_index(ndd, ndd->ns_next,
>  			nd_inc_seq(__le32_to_cpu(nsindex->seq)), 0);
> -	if (rc == 0) {
> -		list_for_each_entry(label_ent, &nd_mapping->labels, list)
> -			if (!label_ent->label) {
> -				label_ent->label = lsa_label;
> -				lsa_label = NULL;
> -				break;
> -			}
> -		dev_WARN_ONCE(&nspm->nsio.common.dev, lsa_label,
> -				"failed to track label: %d\n",
> -				to_slot(ndd, lsa_label));
> -		if (lsa_label)
> -			rc = -ENXIO;
> -	}
> -	mutex_unlock(&nd_mapping->lock);
> +	if (rc)
> +		return rc;
> +
> +	list_for_each_entry(label_ent, &nd_mapping->labels, list)
> +		if (!label_ent->label) {
> +			label_ent->label = lsa_label;
> +			lsa_label = NULL;
> +			break;
> +		}
> +	dev_WARN_ONCE(&nspm->nsio.common.dev, lsa_label,
> +			"failed to track label: %d\n",
> +			to_slot(ndd, lsa_label));
> +	if (lsa_label)
> +		rc = -ENXIO;
>  
>  	return rc;
>  }
> @@ -1127,6 +1137,137 @@ int nd_pmem_namespace_label_update(struct nd_region *nd_region,
>  	return 0;
>  }
>  

[snip]

> diff --git a/drivers/nvdimm/label.h b/drivers/nvdimm/label.h
> index 4883b3a1320f..0f428695017d 100644
> --- a/drivers/nvdimm/label.h
> +++ b/drivers/nvdimm/label.h
> @@ -190,6 +190,7 @@ struct nd_namespace_label {
>  struct nd_lsa_label {
>  	union {
>  		struct nd_namespace_label ns_label;
> +		struct cxl_region_label rg_label;

Why can't struct cxl_region_label be it's own structure?  Or just be part
of the nd_namespace_label union?

>  	};
>  };
>  
> @@ -233,4 +234,5 @@ struct nd_region;
>  struct nd_namespace_pmem;
>  int nd_pmem_namespace_label_update(struct nd_region *nd_region,
>  		struct nd_namespace_pmem *nspm, resource_size_t size);
> +int nd_pmem_region_label_update(struct nd_region *nd_region);
>  #endif /* __LABEL_H__ */
> diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
> index 5b73119dc8fd..02ae8162566c 100644
> --- a/drivers/nvdimm/namespace_devs.c
> +++ b/drivers/nvdimm/namespace_devs.c
> @@ -232,6 +232,18 @@ static ssize_t __alt_name_store(struct device *dev, const char *buf,
>  	return rc;
>  }
>  
> +int nd_region_label_update(struct nd_region *nd_region)

Is this called in a later patch?

Ira

[snip]
