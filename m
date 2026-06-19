Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B314273D8F
	for <nvdimm@lists.linux.dev>; Fri, 19 Jun 2026 00:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781829528; cv=fail; b=NfUJei18X7Kw7wcpLhj7frjXgNf2Ad8ow1IESiXdgbipYBOUJR9e7aM1VFmrSatEyXhb4f8T3ZPxrcFv+ZkeewOTwejrU/GF294Obtjc8EMIWr/59mMMIyth9SC29OFr8DG7g/YHumodB9NuBJUlIFIaPUTM/MhafJClFOIul1A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781829528; c=relaxed/simple;
	bh=ht7CP4WK1l7UNyAfh6VUIpbrwJx7TtheAT6393rvqGk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=LWMAuY6c9u4pf5p1Cc0cPR74JQNFwgVTiDqK9aVVXXRXQdbuhoTuwecVOEXyIH0z+F8yvkYr64Th8Z7P2TNWrqe70hQtkklQ30IefRw5QxlNDSJeG5x897NU5KgUp9AW9a9WkYSSQp/RKnmHWfdDxrXms2/3kMQhmiEp5x62eJE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VeEh6cUV; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VeEh6cUV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781829527; x=1813365527;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ht7CP4WK1l7UNyAfh6VUIpbrwJx7TtheAT6393rvqGk=;
  b=VeEh6cUV90I/+SYToZCzbTd+7tia8fhmq3Dgn3H62IgJ/5pzSSYB/k6y
   25zzMHb35M5DnCfMvhqbLTWs2BgVNeSfZqdE0tdLQbQtoifuUMk3js7pz
   RzTDy/9rxMZrCuJ7QTryj88mfrDWUwUtJ6cqKU0qvOIVI+NJp02JyPPh6
   KYSyImP+d2syNruEhy6BKFB0aXe4GnQ/NoaJ5is+n2aCrzDweaYLFs44b
   glw2/0E8M4t4upqkipicjODT7X46RuRLWVXRpaO4LYyn4PzAPkdDTI/FR
   6JxIsqpYeguRhMffFgj76k6AohWVkc5MC3ba8jLg8jtgyLPv6jrj2iabq
   A==;
X-CSE-ConnectionGUID: 2b2HD+YtQQ2KMbVIXvXywA==
X-CSE-MsgGUID: jLo6QJ2VRL6NYcKVcjgqfw==
X-IronPort-AV: E=McAfee;i="6800,10657,11821"; a="93337618"
X-IronPort-AV: E=Sophos;i="6.24,212,1774335600"; 
   d="scan'208";a="93337618"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2026 17:38:46 -0700
X-CSE-ConnectionGUID: E6cPEgNhTWqrKsE+/WLmcw==
X-CSE-MsgGUID: cnKIxHu3QNuIpU4RaAW42g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,212,1774335600"; 
   d="scan'208";a="242128299"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2026 17:38:46 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 18 Jun 2026 17:38:45 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 18 Jun 2026 17:38:45 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.46) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 18 Jun 2026 17:38:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tBjCsA3VGVLeoNofUaWbbNzCUN62M7vEwpHZzpmcMXvxK7Bp14YJcIfvGTB7/wGCaswRdd/wxHIgSxzhAjzEz3vPyVdFvYqADtHnm5WsG4M66Jh7qKNHeOFlqKxwo84aQPaAKYNIohHloBB9mHFdMkg3KvsTiSJ5HZFKQ6MHv3tLbnwTN78LzH/N5O0hjzw9FyHxTCzUZmRtosHIyPKGMYestdJ/VlNYOlIKhJSRA03yUGaccJY+ahlk7sIfx5ISAxIzHgqX+puL4TWKlQOvCRdIKdDWykaChqFMDJkcu9Wico5tpvIc0Lq/btdYPAE01lJ04aDVqDkbqB4Icc5dLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i1Nn4DwHc8B3qQ5M2RJxwbnCeogIRGssLzpUeyrQYY8=;
 b=r3LZDGXHUXVTRuz2Fdcfz4yQ8ly9sswlCXtfbjNDF2TkVyVNpM5Yhps9VFkOowQBBZFak8+p98oqf8Vd6h5xAosP6b6rGGSdMrUtpYCUFNXfqsyZ2ghvweLDNV8Q/AxKE8B9OGe+xF5KvqnCwuCeHrrXX7cPWpYOif0hJDkXH17s2WfUEW4o2gFcTdw8DafSx3+jeG1Uepgannn30OA2la9f6ISbWixkNFO3bXKmj6JN5SLlwaTmjdIub8blbIGhZaFofw4XgP1MJubVTZcdN2jYIl8HKxB2vfrnCo2aTDeQs3P4buTIJHYqhZwz8XGsRYlxXIKgmd07oRxszwqycg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by BL1PR11MB6026.namprd11.prod.outlook.com (2603:10b6:208:391::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Fri, 19 Jun
 2026 00:38:37 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%4]) with mapi id 15.21.0139.009; Fri, 19 Jun 2026
 00:38:36 +0000
Date: Thu, 18 Jun 2026 17:38:33 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Anisa Su <anisa.su887@gmail.com>
CC: <linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, Dan Williams <djbw@kernel.org>, Jonathan Cameron
	<jic23@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>, Dave Jiang
	<dave.jiang@intel.com>, Ira Weiny <iweiny@kernel.org>, John Groves
	<John@groves.net>, Gregory Price <gourry@gourry.net>
Subject: Re: [PATCH v6 0/7] ndctl: Dynamic Capacity additions for cxl-cli
Message-ID: <ajSPiWGP_AiwYi23@aschofie-mobl2.lan>
References: <20260523095043.471098-1-anisa.su@samsung.com>
 <aiJh7vcs2u1fMDX4@aschofie-mobl2.lan>
 <ajJITxBewsUuQGzp@aschofie-mobl2.lan>
 <ajOHhP7hX8r2ptKC@AnisaLaptop.localdomain>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ajOHhP7hX8r2ptKC@AnisaLaptop.localdomain>
X-ClientProxiedBy: SJ0PR13CA0064.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::9) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|BL1PR11MB6026:EE_
X-MS-Office365-Filtering-Correlation-Id: a11ec6c5-6916-4fbc-0f0e-08decd9b199a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|23010399003|5023799004|11063799006|56012099006|4143699003|18002099003|22082099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info: JoAoxaNF9RAaYqghSY0yZs1wH1RnwdrDW2SrqdBjmJcKeqs3L4sH7S2p8TwpaxoCSR7wV3a9bgTTF4M94E8fZo8O3tenXuUKKMOagIVP786rU41SnDbQthnIoyhxD5mHoR55moUI8mg0NPvbEtvyFcNRjFAk0pCXIys60qMq56FvxNj7LH9wLisriEfrWlQ9l+aE0m5ANMquv2LqtxLpVpvvQ6CvnzLTO3Pdrh+mBJ6GXxd5ceL5CxgtH7P4PvIDDQe7g/OL+CRy2QqViK6GuI50LCV5QjKemzfaQr/gs6a7lweaSHpDDaCbzOV/VAqH1zodW81zam5m3UY1sXN25GttpvWPvD0bKcFqUxSdXRUBVLs8ydV9T6nfLCoWAvKutgOx7zlJzGQcRB46PnW4q6L1GWhYAEiB93i7c6/0zfbCBgnhFSxq3hp6dou63fFPKpYFm1ah4A69IU1NGsnHuwXGB1Hf1YUiJGJ/POgh29MxdK+C/IyVmETkwbhiInRQt25WTDGCvF5YQgZE/FQWsB2UwCWi2mKq+XeFjQtwe7fJgu82OStghFB0pF0j35UYx6+cVAeisFMUrA68dHNfehjFdrkXJh6lOS41NgUAewJsTVlPLqsIDzg1DDdQ1QbJTcFaukgrG0vrcu55SC8CuOjt0c+LZa6IBBJtO3AqpTU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(23010399003)(5023799004)(11063799006)(56012099006)(4143699003)(18002099003)(22082099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?T2NCILlyDK9TKvSmh/lwdugF5ndYMeLA2gnckBjC4pWRdc6gQQqbmKeKJ2Uf?=
 =?us-ascii?Q?7ulHtpHQtUtSrtxTIoidrAYQGuySeqVZu2b8xde0CV6wNydbahyLLNGPVNqP?=
 =?us-ascii?Q?um3geU4zFl/ZpP10l2Rkjwiksjkfqp4xA7FOeXBzQpqA37N8Kz1EVL7XOlE0?=
 =?us-ascii?Q?bCYtZnVwpNG6nzvI3WAkEAFWNF9MeM6184lf1CHPMcLf+4bbs0pJQ5LaFlJo?=
 =?us-ascii?Q?ZE5CUqkZykUUWiw/d4tcYitkkpfcoFtziK3af88+7dkkpEJ0T3RCsd/y6fVJ?=
 =?us-ascii?Q?+EszddtI/a+U6GdkaVobWBnDwkfL6s3ysL58+FVBI68Zlw4Owe+HIOoHJk78?=
 =?us-ascii?Q?t+n5jbfgxRAk2Mj8D8ykXcpoHGD45CtWNIy7vHcMs9AW7bas+Y7Dr7K72IxI?=
 =?us-ascii?Q?P9Sr0Ak7MFlODQ+I8Tg6s3hA7kzpUBT/W5yCrIzEnNTFWzOmm4TMaBd+d5eA?=
 =?us-ascii?Q?DnANi2dZ72S+svciYPLWJoRXFYFmnw+ImJRN/O6L0m1mzWXPjOoddG1uooLK?=
 =?us-ascii?Q?g5fiASa+GcgRqdPDA9NiBDh6SvqyXVeIWS93bQqj3MHaaJvQmPiVZLmHUcAA?=
 =?us-ascii?Q?8ra9jDQl5VsmxQkdK/8OAdrnGpDUWeWwrHAA74U4fbZwkAJ3/Y77Al3WQ6wC?=
 =?us-ascii?Q?kr3oT7WYDr3+y8vqcH3f6maYqEm0BMYzOEcayDUK7pm66wScYm3RxYKXrJ0F?=
 =?us-ascii?Q?0c6FycKSJF+HogepHy2Dpfk31tftN2gfdLEgBYIkHszqIamu/QWHBjRB/7dY?=
 =?us-ascii?Q?v5/00xeZDByVdom9WrI8Ev3+TgfrwNkbWyhDRri96VhiXb485i5VaNB9efJU?=
 =?us-ascii?Q?FCdlhg2Q3CxmAJJsqLd9W+Gf3nKG3dHgYIp+vfpMHWOAxuOWc3RHpYv+rqHx?=
 =?us-ascii?Q?Xq3xhDF/ykeCyfSxf0AdXKMRk22dm0MbWT5XKT0D1rLDA3oQTDC+iS4u7mt3?=
 =?us-ascii?Q?i+r/Fc4Ys65sm2pY4t/ylTLd5a4kOYeIzC5pimOeh0rm0JwZxUWFXIXeDlmg?=
 =?us-ascii?Q?UllofMxJxsIr/6IT9ZGfmjYB5Bg/8h09sjryP52kcIBqI7zGpZ8sIgKzcHW9?=
 =?us-ascii?Q?v8oV2WiPMKyBc+bYaTYQdHFL2qBKo0yR2c118tlGhMbWwx2JloCy5u9RE9U1?=
 =?us-ascii?Q?Ax5SGOqhf0p1S+jpAVCDgOUwEAKJlYgpPvyMTgROUV0/Tv3kRnvkVv1acYqV?=
 =?us-ascii?Q?46jJCBrUfxzoYbyGRiq8KlxeeDOaUxfFN30rOU0UEiFosxDnrrnn4q1fJBv/?=
 =?us-ascii?Q?+2TYwTobWrSGYuMbOtPVDRvpYiA3Q8FtFyneBk9wFSkXChv/ucrf3lC08MNb?=
 =?us-ascii?Q?ZUkQ1Ueev+GfCkTBFeOqxvDItE4wUPlzB4njdu8j99Wi6EdzC8/RomLGLlHr?=
 =?us-ascii?Q?lFAPf6SNKrE1nKVvJz5VfLOpoozPnrsHuRpFfsPshIHPzYJvnUAHA2eh1zXD?=
 =?us-ascii?Q?BdHVxQoCR5EwlGA+buCwbAhKv+hJWJPD7JyrAZ8972UduYpo/alL18fNj9GH?=
 =?us-ascii?Q?t0VCxzg/eRK/YCh1F+JXONBItR6eHUQEAIwT5zlBuEOp6X/GBYSEfDyFXwp9?=
 =?us-ascii?Q?zrt8owSh3IHzRtrBtwbzg8vQgiNf7RSaBfa5wpjvh55UAcBXJkc7Is5Jepp5?=
 =?us-ascii?Q?WBaFRBwF36wzv/tD9oNIcaOfwNA/04ocbBP1aXXcdZB9cA0+eFAUfBrZvcFu?=
 =?us-ascii?Q?nlKyChAvdd9HlHFsyen14Spmayzns5P54YSdaVsbXYb50Xj8aBVFvb3dk6/+?=
 =?us-ascii?Q?vyLqo48qdMVpdMsZe00lA1bSrbzlleo=3D?=
X-Exchange-RoutingPolicyChecked: ahwE9KErKYWtkSc/3fecFwk32pMQs1EeHJw/UzSMNpsoLsQpLb7wGsS17X/5wo9VHsgGI7ab4DVcUtKA0CtUkcRyUeg5Z71USRE0KKcjz0M4l87n80nuRJjd9wpT0mGaRyDWy9VuSqQ+GbY8C7Ri+LOBFN9hcGdD1dEqVBt0QDHrBMtXCEZpltv/3HSvCz70TXUK0aZEIA/rDqzBhd6UAm+ybJd7031iLXPqEaTOZb92iMqF0ehxNtjL4l41TV1BT1dWMF3lJW8YMRPO8znxDTu4OxDOt8gtzzkaT8opoTkfumzjAd7Htew0Xo6a5kXNv+sLGEpXirzcFqjN7PKU4A==
X-MS-Exchange-CrossTenant-Network-Message-Id: a11ec6c5-6916-4fbc-0f0e-08decd9b199a
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2026 00:38:36.8330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fodTY/Rn9EzVuuH0CBjWXysjH5KVNSFO1PbqdhYBI5dsPN6oVUiWhj1r/g8nfNVpWMUS6O4kJgXSnsRqkY/cWNYm70cjv6wr5fMgiGoQWOM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB6026
X-OriginatorOrg: intel.com

On Wed, Jun 17, 2026 at 10:52:04PM -0700, Anisa Su wrote:
> On Wed, Jun 17, 2026 at 12:10:07AM -0700, Alison Schofield wrote:
> > On Thu, Jun 04, 2026 at 10:43:10PM -0700, Alison Schofield wrote:
> > > On Sat, May 23, 2026 at 02:50:35AM -0700, Anisa Su wrote:
> > > > CXL Dynamic Capacity Device (DCD) support has continued to evolve in the
> > > > upstream kernel since Ira's v5 posting [1].  The kernel side has settled
> > > > on a uuid-driven claim model for sparse DAX devices: dax_resources carry
> > > > the tag delivered with each extent, and userspace selects which ones to
> > > > claim by writing a UUID to the dax device's sysfs 'uuid' attribute (or
> > > > "0" to claim a single untagged resource).  Size on a sparse region is
> > > > determined by the claim, not requested up-front.
> > > > 
> > > > This series brings cxl-cli and daxctl in line with that model and
> > > > extends cxl_test to exercise the new paths end-to-end.
> > > 
> > > Hi Anisa,
> > > 
> > > I just now picked this up with the kernel side and took it for a quick
> > > test drive. Based on what's been touched, first meaningful finding is
> > > all the DAX unit tests pass, and then for CXL unit tests, all but these
> > > 2 pass: cxl-security.sh and cxl-dcd.sh
> > > 
> > > Please let me know if there are known problems with either of those
> > > before I explore further.
> > 
> > Hi Anisa,
> > 
> > Good news, DCD exposed a long hidden bug that made cxl-security.sh
> > fail. It is not an issue w DCD patches.
> > 
> > Found that DCD set changes which mock memdev the test happens to
> > land on, and that's enough to uncover a latent hex/decimal bug in
> > CXL nvdimm code. We use to always land on id '1', but now this patch:
> > 
> > tools/testing/cxl: Add DC Regions to mock mem data
> > 
> > reorders the sorted dimm list, so the test selects a dimm with
> > serial 10 (0xa), and there's the hex/decimal mismatch.
> > 
> > The renumbering is harmless in itself but it just changed the
> > serial the test exercises and tripped over the old bug.
> > 
> > I'll send a separate fixup patch for the hex/dec cleanup.
> > 
> > (No answer on cxl-dcd.sh yet)
> > 
> > -- Alison
> > 
> Thanks for looking into this! I can also look into what might be going
> on with cxl-dcd.sh if you let me know the base commit you applied the
> dcd patches onto? :)

The base commit was indeed the key to the cxl-dcd.sh failure.

I'm seeing a probe-ordering race that you may not see unless you're
using v7.1-rc1 or later. The branch linked in the kernel patchset does
not include this commit -

39aa1d4be12b ("dax/cxl, hmem: Initialize hmem early and defer dax_cxl binding")

Dan changed cxl_dax_region to PROBE_PREFER_ASYNCHRONOUS in support the
DAX and HMEM synchronization, so I'm guessing that undoing that, is
not an option. Before that change, cxl_dax_region probed synchronously
and created the zero-sized seed dax device before cxlr_add_existing_extents()
ran, so no race existed.

Move to 7.1 and you *should* see cxl-dcd.sh start failing. Since it's a
timing issue, so you may need to dial down any dynamic debug and do
repeated runs.

The race is on the dax_region device's devres_head between-
(a) the asynchronous cxl_dax_region probe reaching really_probe()
and
(b) cxlr_add_existing_extents() attaching devres to the same device

really_probe() rejects probing devices that already have resources
attached. If (b) wins, probe fails with -EBUSY, cxl_dax_region never
binds, and the seed dax device is never created.

One possible fixup would be to move existing-extent processing into
cxl_dax_region_probe() so that the resource attachment happens
within the probe itself. That looked like more restructuring than I
could quickly test out, so I'm sending it back to you.

Below is a reproducer using cxl_test and cxl-cli. It creates a DC region
and checks immediately if its dax_region driver bound and a seed dax
device exists. An 'unbound' dax_region is the bug.

    #!/bin/bash
    set -u
    CXL=${CXL:-cxl}; NDCTL=${NDCTL:-ndctl}; TRIALS=${1:-10}
    bound=0 unbound=0
    for t in $(seq 1 "$TRIALS"); do
        $NDCTL disable-region -b cxl_test all >/dev/null 2>&1
        modprobe -r cxl_test 2>/dev/null; modprobe cxl_test
        udevadm settle 2>/dev/null; dmesg -C 2>/dev/null
        # first non-sharable memdev with a dynamic_ram_a partition
        # (serial 56540 == 0xDCDC is the mock's sharable fixture)
        mem=$($CXL list -b cxl_test -Mi \
            | jq -r '.[] | select(.dynamic_ram_a_size != null)
                          | select(.serial != 56540) | .memdev' | head -1)
        reg=$($CXL create-region -t dynamic_ram_a -d decoder0.0 -m "$mem" \
            2>/dev/null | jq -r .region)
        rnum=${reg#region}
        # sample immediately, no sleep (what the test does via daxctl)
        daxreg=$(readlink -f /sys/bus/cxl/devices/"$reg"/dax_region"$rnum" 2>/dev/null)
        drv=$([ -e "$daxreg/driver" ] && echo bound || echo UNBOUND)
        seed=$([ -e /sys/bus/dax/devices/dax"$rnum".0/uuid ] && echo yes || echo NO)
        ebusy=$(dmesg 2>/dev/null | grep -c "Resources present before probing")
        printf 'trial %2d: %s drv=%-7s seed=%-3s ebusy_msgs=%s\n' \
            "$t" "$reg" "$drv" "$seed" "$ebusy"
        [ "$drv" = bound ] && bound=$((bound+1)) || unbound=$((unbound+1))
    done
    echo "SUMMARY: bound=$bound unbound(FAIL)=$unbound of $TRIALS"
    [ "$unbound" -eq 0 ] || exit 1

Sample output on a failing kernel-
    trial  1: region9 drv=bound   seed=yes ebusy_msgs=0
    trial  2: region9 drv=UNBOUND seed=NO  ebusy_msgs=1
    trial  3: region9 drv=bound   seed=yes ebusy_msgs=0
    trial  4: region9 drv=UNBOUND seed=NO  ebusy_msgs=1
    ...
    SUMMARY: bound=4 unbound(FAIL)=4 of 8

> 
> Thanks,
> Anisa
> 

snip

