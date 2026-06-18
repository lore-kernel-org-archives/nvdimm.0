Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74BED221F20
	for <nvdimm@lists.linux.dev>; Thu, 18 Jun 2026 20:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781814100; cv=fail; b=UidpMWVo5UgojIwTnKwthcodYogNYPW3ELqjhS2SpC2h/NhSi5vAxpTIkvNIvWz+3LRiIzZlsKXmwCRYt64RTQouSPPuZUHyEvLOWSANtp3HY2czO7+3glVYhIdeRdaQ6oyC2yWwcj7OFBsGj6DqgmFJjy6CAMaYfjaPe6/kz4Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781814100; c=relaxed/simple;
	bh=v8zQ55+K7GLNGcPzxSuRLijbOhedIHZfYw2Wue9s3UM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=snwp4O20qjzBEUbu0kEUhuhqWWDUjX0jXASKr8WlRbN9f81GVQWwz/LUP6g+CIKAvQdy3+yXi4FK6d3bIjSP8ESc8vAwMqZ8NBynRuatP634INVU4eBD4aINcW6+qbnKxVEjR4SuuPm0DFlnXSwhBvV+bMdJ5vXEuH2en/nj0Z8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lOP4957T; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lOP4957T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781814098; x=1813350098;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=v8zQ55+K7GLNGcPzxSuRLijbOhedIHZfYw2Wue9s3UM=;
  b=lOP4957ToeM+8Ax2LDu75VRbEC07rjO/MZzRYOh2zqKt3PgO1PZkRJOd
   FGvOEb5W7mWpb4KwSi6q9V3kMzIbg//GltmFaw1PJKJ4RT9OGnkTBQNE4
   ADmlJKTbffoN7Vye0cCJ4eF8IJ91dWB3CJaE9P9eTsaETftHFePuWWJdn
   lW1Xa3kSDKaq8+WyWg+MDGm5ck76yVsiNirWc5TfbhW1DrvCKM9CZgOYU
   tj4+u4CIxyuXeDCXDSo/jINXGTjSv7xS0iUz8ZpfjlMlSb8E+NOaMYkzg
   giTxMtrIykRxjo0SVRX2MYW2xlCZxqC8ARLS4nyTeaeNQYVqV5NRjsPxl
   A==;
X-CSE-ConnectionGUID: xFO7yYcKSnOEd9SDJk62Qg==
X-CSE-MsgGUID: w+8EPtwtSOmh+Yb/0ZQXgA==
X-IronPort-AV: E=McAfee;i="6800,10657,11821"; a="82667959"
X-IronPort-AV: E=Sophos;i="6.24,212,1774335600"; 
   d="scan'208";a="82667959"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2026 13:21:38 -0700
X-CSE-ConnectionGUID: yQmzFDrMTrSE5mym5yWHgQ==
X-CSE-MsgGUID: NBtxzsoiRAenUmmXmq78uw==
X-ExtLoop1: 1
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2026 13:21:37 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 18 Jun 2026 13:21:37 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 18 Jun 2026 13:21:37 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.0) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 18 Jun 2026 13:21:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VeXfGOgVjaF1gKIWe2BvmbhNvaG3+E8GOi8MPZfYnQVpb2Rb6rlNpFhkNXH7wuxZePSyCy+8uLuUitYB/UIQ4kHbRYDLhVdgBShADLv/eRGPtBnZqEgeDsNY2PAfpq0G38xiQRLaNPPegXnVQZglBzpKUsh0SXyN8DeyGPBEWjyMKImMqWGjkiizwUjv8RBlJv2A7QUzld6fOSsMj/AeyXPhOb9JEZmjJkOOIlW5kCJVFqDixi1P5ziEn0jbN6aHd50UvkHloUmsglg4aoR9uK6kDhuCuzeNkXsYS40CDdv/qIp4Zx0LI5XYMbxoSjEtu9SMBq5WWv7DN6rq8g1ugg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bHinaXYT9z3SdP1OSxam+XFxmAZd1P6E+NKau5eve44=;
 b=qRS8inK9zLxHPK8Fw1UAcL2fHumceC+Gg7Vg06fd+i+CClnOnz7+sXqgOwC9Um5Bi1tNmr8bpd6/dcd5nz+RkBdqwWCk9uBNHhX8cSQsD315uqAhd3R9sW8GZy+Ns0hYx6Mg2VItMU2/IEvXx6n4kD9vD6fbi6oChyFVQa1y9GXPosXWgbOYJ7LlsliQH2Wk8PC/JBjaeAa2rBJG4btSIuM/N//4m57laCa6iZQP6H+IoQp5AE+25pLgsVLGYfv+H35fx2+KCI07TycyW/i0VxprQu95t85f2KfPH2ivkzKvSdpK7Rbjzfn9FyEWJYcwU2/7axlC8e8K7GN2m9DtDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SJ5PPF5B09F0799.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::82c) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Thu, 18 Jun
 2026 20:21:30 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%4]) with mapi id 15.21.0139.009; Thu, 18 Jun 2026
 20:21:30 +0000
Date: Thu, 18 Jun 2026 13:21:25 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Anisa Su <anisa.su887@gmail.com>
CC: <linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, Dan Williams <djbw@kernel.org>, Jonathan Cameron
	<jic23@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>, Dave Jiang
	<dave.jiang@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny
	<iweiny@kernel.org>, John Groves <John@groves.net>, Gregory Price
	<gourry@gourry.net>, Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH v10 07/31] cxl/region: Add DC DAX region support
Message-ID: <ajRTRZS3a6Cc0vm1@aschofie-mobl2.lan>
References: <cover.1779528761.git.anisa.su@samsung.com>
 <9f0e0b3deeb1825ad113d7aebe7056dcf2bbc5f9.1779528761.git.anisa.su@samsung.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <9f0e0b3deeb1825ad113d7aebe7056dcf2bbc5f9.1779528761.git.anisa.su@samsung.com>
X-ClientProxiedBy: BY1P220CA0004.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:59d::15) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SJ5PPF5B09F0799:EE_
X-MS-Office365-Filtering-Correlation-Id: 31dbdf1d-7fa3-48d5-bba3-08decd772e6d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|56012099006|11063799006|5023799004|18002099003|22082099003|4143699003;
X-Microsoft-Antispam-Message-Info: 5hk5GPbJf05eTBuehf6fPQK2ZACjEYkmqP2DETJweslsbW122bXwspAK7y6jiJZmXruDnGvDOlQoNM6kCPVrENM2jwiSwc3+Ddm9LNvNKEcBrZRCumZm2nnQ+rCpFB1xoPTCjeNKyAmEDdIslHz6Zbpg7HaUzGW1kZu+wRU/l3Z5n94I5H3OC+XgZqp8WICStneGCVx0RU3sKCpRogD2KQwVkXZqLMTc8zakwDNUIaDVhDWkrDH2R3fSN2fAHmdnwBfJSDo302lKD+SDo2gRdL5DuPZP2a5FbGV2wQ/D6KOvFGajSWqU8aqXsi2TSYPeHvttDfuP9Rj4aFCOLHhPfPNor7p89mnkv3ySK8z45SztDW509c3hdJehuXWTl/8zK5GerJCEZM7BvI99Fd2qLrR4+AIYuv3fJNAxf9k6yz2DBDAeLFD/W5xCFojSAr66ndS2VEgaK6U+tcn8knO+YwUARTvJhIO/krkW5tpCwgfPsEm0B3zh4YoOoohGWnkOldx5qqPtDDlFihDULvFqJ9sOUl8J5+ZGkOwxHu2WhYlxQQjYXZh2g6YmYGZAyxLoTPH1L2EW1KS5gqEknHJ4s2UTqIL3sKqTa5+rAuLDwiL5RcYVMNViAhyZeS18fvHKjTeCOYn/P1rJsd+YtG7ENWK9v7VJUmPRoB3GpBvaKiE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(56012099006)(11063799006)(5023799004)(18002099003)(22082099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Jn+ISjDzfZF5nHT5jAFqL2pFOqyiOFp4bW8vh9RjQUsJQxa2eFMlW1jsXjWw?=
 =?us-ascii?Q?ISccJZGl3WNCVrLBgcv08LteLbVd1k2nUpZ8U705HJrTWIWz62ctsO8yUezb?=
 =?us-ascii?Q?u1D4IUm/7HGYQ6HkgoRncTVbDSmppXq50KuN7l/VBT9lmFgT/Dg+rvfWjxmn?=
 =?us-ascii?Q?f50JWmljVRhjzIrEqM4Mz3imYrEZDxZo1WQGfkok/qnrqizOyTGX/R2N/KSA?=
 =?us-ascii?Q?xqC2+FhzxGUcSvCK/WCb+Ncg5LUkcsh5fe2tCuaicQ8mFCluUev2eIRV2qcz?=
 =?us-ascii?Q?LliE6loQIUq1pPYhgg07yat7I/I4zzdxhLkqo/ghCIiTPN+YLorrssXegQPV?=
 =?us-ascii?Q?EDk8fku06LOZ74JFp3DcSNY0Rfk3FzBFnmMgfzH7jCMrVY8IywXbJ0QCQFoV?=
 =?us-ascii?Q?xeuYUQp402IZWzCUen9V/gLm5+djfMskbE4JIO2CYLqVaguBhk/7OtvbWJFf?=
 =?us-ascii?Q?+tmFYQIABHAvN5WLGJv1S4RQi5owheNn9v7suigE7riGGQrThG8mOsQwcrsT?=
 =?us-ascii?Q?hdID1OWr+gH/mGdNNiruZKffKvPaFZmB3F7gWQ3h8oB/0SKuCCcH15OAKVOP?=
 =?us-ascii?Q?wj1PwHP1rNgydsJh3cc04yuMUNkVw4k8Ms8ZoC2nkOo2oeh1JUW7d2mLZKW1?=
 =?us-ascii?Q?bKwUJEjdNCRUdVpQ4l44yVf8+OEm45Z0F9d2aAVrT533qQ7zxi2kQ7PAhPA8?=
 =?us-ascii?Q?66iX7U/ftV0Am8GOBiEPKypP64qSMYwzZH57kCdDQesQldAQlGhbgJ5ARg02?=
 =?us-ascii?Q?l2KMB/uXt2sK+iQyx71NVGMvO5Pygv5oAmr6YoNNnh3pab0b9KbLreRLpdnk?=
 =?us-ascii?Q?QbOQUZX1mjUV9nt2RXDL3XXVILCK5F/esmy/uLwRr2f9IShKetKtOu+Gogr6?=
 =?us-ascii?Q?GkmJq9JqqHsEu3/l56e9e58G7mNonewsecGb323vcSl/L00jL0vhqtpvZ+Vq?=
 =?us-ascii?Q?Dx3CW51JhCXuJjfLD/L9YQfGsIdM0Qplnn6GanGde6AmunS/+WlmniYK1zs3?=
 =?us-ascii?Q?x+jmzDZOdk1Y6VvhId9QCRvU2wqjCeBZH/pYU1KaaeAtr/d8KNd8OJdCjOQh?=
 =?us-ascii?Q?7+4IkxCl04AMmmuj6mThhw2DcvoOpgIGN3Ml85izcNP9y8Jlnh8yQVamgFqR?=
 =?us-ascii?Q?LIHmKRBld6gzCmgXK90o9rtHWDOMyMg/xLEHjBPkul+/l6HQlsP+eXsab1qq?=
 =?us-ascii?Q?9g4nWVnQ103dpBExNsdrZ+mXB3rNjJSo2Ly6j8/lGmV4qra2I7qh/DTMJypm?=
 =?us-ascii?Q?o2jrVLEPlBlGTP3EK6W+3Uq4yIkT1/BNL36VP7HQSz+B7tuw+LDs8sVTk6vr?=
 =?us-ascii?Q?r3unEXrCCNW/iFvikO0RK6eu2T5aqxm1VD52hdzjMzpybdmahbsvvPLRG75e?=
 =?us-ascii?Q?Ckj4ylGxS2MGs0MsKC2LO+2iwy2emVdDHa1P71kv8T+0rKE+6y5RQmoU3MiG?=
 =?us-ascii?Q?rj/RcZ5ALUZ7vFTPSw/s8bYvlZnSARy7c/G1QjJlqbIPc5gLb2z0Jx7ZgvZR?=
 =?us-ascii?Q?dKfp14nE2BpT7LD4FZAJmbgaNcAklQcyIrtXMKa+/5jVhr6aedgUz14rruQg?=
 =?us-ascii?Q?74XcTVa7mhXTjpyhPYMXuniEIjI2jfFbe/mu1xXrf8OHOO9r+HQt+BSZcUSk?=
 =?us-ascii?Q?Lvqwo9/9g/RXu7pQNqPIR6Wl6bx1HacBpeyZqj4iT03wDcGPtRJLi6JpHLWb?=
 =?us-ascii?Q?Vg9j60PFXqi6Xwx8pGC5nTzye9txjy3rKEgA4nxSyJhpmqPUoj9I93YtbViM?=
 =?us-ascii?Q?l3hGR0sg3rYz5VKJn3loVLjR7fQfEpA=3D?=
X-Exchange-RoutingPolicyChecked: iZ+F4YnGQZdOYxNhSGxRqhgYsdI73eAyHVTkUTfaOYtZEWYt1d+ePDFrTHPYe5MGn87ap9AkwZN1DiAR0QKtrbQH/fA6nFt06PAXrHrjgY6s+dzpbCVb/hrzcBRnPt0fWfPBMBFGX6HcRsvFKPuFAkwn2v2AT/mxJBZIjokOeH+87piQLB8YpLqt8/2j227rdX/0kpog/B/3kWoi108p272hwCXGt+B6LjcsrCldgWGMELrlGSCNSzfAROqEUvH47IYZ3wnWoNAhC0523DSoIMLljuprxM7XH8gioZeRvjXqP3Z9nwXGLyDvjZLqztIvrGOI56hoOukZUqFCFKowtQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 31dbdf1d-7fa3-48d5-bba3-08decd772e6d
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2026 20:21:29.8739
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SK+CqBeMN+VSrHJDbQNnJc1puZhsJNlXiYCB1LVl7BTNDDviZ57x3LYENRzPnADQLsmfi5aKrHdRYSG7UwSVxEehyxydLXxUct7ofCJvuU4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF5B09F0799
X-OriginatorOrg: intel.com

On Sat, May 23, 2026 at 02:43:01AM -0700, Anisa Su wrote:
> From: Ira Weiny <ira.weiny@intel.com>
> 
> DC DAX regions must allow memory to be added or removed dynamically.
> In addition to the quantity of memory available the,
> location of the memory within a DC partition is dynamic, based on the
> extents offered by a device.  CXL DAX regions must accommodate the
> dynamic movement of this memory in the management of DAX regions and devices.
> 
> Introduce the concept of a dynamic DAX region. Introduce
> create_dynamic_ram_a_region() sysfs entry to create such regions.
> Special case DC-capable regions to create a 0 sized seed DAX device
> to maintain compatibility which requires a default DAX device to hold a
> region reference.
> 
> Indicate 0 byte available capacity until such time that capacity is
> added.
> 
> Dynamic regions complicate the range mapping of dax devices.  There is no
> known use case for range mapping on dynamic regions.  Avoid the
> complication by preventing range mapping of dax devices on dynamic
> regions.
> 
> Interleaving is deferred for now.  Add checks.
> 
> Based on an original patch by Navneet Singh.
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> 

Hi Anisa,

This change is needed and I think it belongs in this patch:

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 9fbcb2035600..e6d9a6238677 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -647,6 +647,8 @@ static ssize_t mode_show(struct device *dev, struct device_attribute *attr,
                desc = "ram";
        else if (cxlr->mode == CXL_PARTMODE_PMEM)
                desc = "pmem";
+       else if (cxlr->mode == CXL_PARTMODE_DYNAMIC_RAM_A)
+               desc = "dynamic_ram_a";
        else
                desc = "";

IIUC That empty string default should be for an unset mode only.
And, this makes the new type appear in cxl list -R

-- Alison

