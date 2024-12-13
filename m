Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D15A1E25F6
	for <nvdimm@lists.linux.dev>; Fri, 13 Dec 2024 18:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734114874; cv=fail; b=AY2M9m/rBN3apggjYe4iVekgp2VnNhCdXPwDyOr+nl96ah04kK2uJtJBG11yWqnkmXEATS70laeqPq/i1tJ6F/f/Qhv3+s6oMIantKWmdNliiA6Z4n347E2esJUKgYLfhqPxa/ONPX6UPixqL9CtRM4Eqn4ucxGPyn0kFeM2qG0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734114874; c=relaxed/simple;
	bh=7RPlEgV3rHwOhMpCqcD3o0nimKkvHR1L40pobKVRaOk=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=UDfxMjUnhMVIg4clkbu9y9vCu8i784uUFSbteMu1/UnWUicSJtEIf3ujpxRJWKxzLLfpV+jsRr3aOnUvB4MIEmiv8fBaJThvfEJ29qdlZiSdYz9nBuLKU8vjWJjowG9VVXTTrQRftpzznm2i9JfljeZkzUfrB37QbRwUlemuPQc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EtyQk4bF; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EtyQk4bF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734114873; x=1765650873;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=7RPlEgV3rHwOhMpCqcD3o0nimKkvHR1L40pobKVRaOk=;
  b=EtyQk4bFX3bxfbeirqmRIx8hRZjH/SU5iQ43Zyqs0rOvJrjtI1SGwxwC
   g+MVUd3ohUGnoHM/aIo05gHj54YzoBHdar+UuTWfdG6DCfx4WErNLcJck
   X/fjQH3f1kAtmxdtvBu4zlHUBh9yqjHf0NcsircVxYvpFNQHfrtMWDwQ8
   0WKlO5HFCk3NKPiYQCHif/z3UNMF9l+nZl8u4vWGr8+mQtMUezgNByEEz
   kNI1Vqqxw3hCn9ebEKDGw+kR2fbBy27bF7GrnyAchFqg42ikT6Vpnt3Ve
   EkKYB4HXa5IdwoLHTCB9eiy2h+9l4Fl9h+dsA/i69o5i1aLEb4YhMK8/p
   A==;
X-CSE-ConnectionGUID: 8Lf2mdg6S/KzVIiG4uZdig==
X-CSE-MsgGUID: 1ZPpvY5sR4q+LfV+jClUZg==
X-IronPort-AV: E=McAfee;i="6700,10204,11285"; a="38257376"
X-IronPort-AV: E=Sophos;i="6.12,232,1728975600"; 
   d="scan'208";a="38257376"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2024 10:34:32 -0800
X-CSE-ConnectionGUID: Bm40OzpsSLCupXxyincnYA==
X-CSE-MsgGUID: rpE1VfU9Tw6ttJaVDy1D9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,232,1728975600"; 
   d="scan'208";a="101449859"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Dec 2024 10:34:31 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Fri, 13 Dec 2024 10:34:30 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Fri, 13 Dec 2024 10:34:30 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 13 Dec 2024 10:34:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TrI+UP1nmRvFrs7kDS26kcxkqQmdQr6NYjA1RWl/vpRMlaaTkzWcWL5o6+Gbe+OuQqjx1NV/F4StHpeVAf1slsddSRY7CLcU0BLSoNTrqFHh4PU4VHCCx6y3u4+3gmaSZL1MH1Jux0q6jHCJ7wqmFI77JLM+estUiuhIWXqdKeF/LTnxWxD9pq33GeWKHgXAsGsaXfmH5Hxvdmd09s4mMghbyTRniJBGHqDnkWKTaWH2Gc8zy2FYe2/Vl7TwIemnLHn/84R0jnNr8GjhAnMLAIYh/SVZIg/+DL+GfJoiLMs/wLzOzDF66TDUgeQVcJG4pjS3Ml+Gc4bCmQfI5huo+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W/p/A6KJ8Erh9XGXhu773fD2vw2h1wyjCg5fMxdpiLM=;
 b=ACPzGieEIPJ/u4TF7rvF8SuY6YcOpq73PbZ6hI4jlsNpCrwYfyYHwmC82xF0IJBm8sRnHf/jWCpRx2QKTssu90ubmnvtvMjb8eX6TpeQSaSk9xK/zTZFd9/fXXuTCVbWVPyyx5B/wcZD3f1L2DpUpkPrxwz2owBicOOP7PCffmTKf3ZRaWOe32mQQGSn7tGQJHZPJeZ6u4m2bAaxDfuv1v3NYK8dGWJySXxqmrcgbW1rvWkOvsw3Fo+WLU0a6dwVsQyNfinFagkHfxKozBRZ+P3TnJ0TFFROKSkXR4NIo6m3n//bGBspq084NiIaGop6/LtZmMXjswDctnQ6+c6vWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW4PR11MB6739.namprd11.prod.outlook.com (2603:10b6:303:20b::19)
 by PH7PR11MB6650.namprd11.prod.outlook.com (2603:10b6:510:1a8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.16; Fri, 13 Dec
 2024 18:34:10 +0000
Received: from MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24]) by MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24%7]) with mapi id 15.20.8230.016; Fri, 13 Dec 2024
 18:34:10 +0000
Date: Fri, 13 Dec 2024 12:34:07 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Dan Williams <dan.j.williams@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Ira Weiny
	<ira.weiny@intel.com>, Suraj Sonawane <surajsonawane0215@gmail.com>,
	<nvdimm@lists.linux.dev>
Subject: [GIT PULL] NVDIMM fixes for 6.13
Message-ID: <675c7e1f4ddff_24c59c2947c@iweiny-mobl.notmuch>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: MW4PR03CA0028.namprd03.prod.outlook.com
 (2603:10b6:303:8f::33) To MW4PR11MB6739.namprd11.prod.outlook.com
 (2603:10b6:303:20b::19)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB6739:EE_|PH7PR11MB6650:EE_
X-MS-Office365-Filtering-Correlation-Id: fbf05ab0-6cb8-473f-f0fc-08dd1ba4bc4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?2jV+3YCHPmra8CpXnf90/uovG4LJa432dNbZajViIOhNL15GWmPwouNT4WLb?=
 =?us-ascii?Q?lgJabz+3vOjkxMw/8yOQ7PhDGQaaJJLZ29PInOSon4l4f/qC0+YzDvTv3oIO?=
 =?us-ascii?Q?LnFV9cBMoBS2Ild0zHCZdJwtirYu7h1Ijq0WXEHUDjV6tuc0lEfktnlrkjRs?=
 =?us-ascii?Q?C9RKE3MUhtymEG5achv/0f5xErhQI/g019fbm6rdUkzAEpTrq9GPJe0cdb53?=
 =?us-ascii?Q?7+IlIMBwsHUd0NpbiHFFYtKsMO740D7acp5yJAWKNBpjc+Tka16LUhNOvVbB?=
 =?us-ascii?Q?9WL6p9sSM6yzPl/1UmoYHQpP74gB90cBMebasFHT4Q3KVAfhBItBvqRfw7qi?=
 =?us-ascii?Q?iYOI2LPMApDbNGTXueaM9fBpKEpJVYZJUctS+/gfwHcwuxgJGx4DXE6VcPzE?=
 =?us-ascii?Q?9BAYvm6L7GmOVbK38irPkRue4S9HRKcAW9xc57ndnEf29OaeNbn4OyvFSjgg?=
 =?us-ascii?Q?Dl4Ecbiu67ZWYmZ/kh1kDG8bf/KnboAssvKEfDJuZYcQ8nYrgqTeTlVj+8Ug?=
 =?us-ascii?Q?Ec5IEkdDG4VLlHaeS2qNf4WhIpj//JjWqPh29+XlgcmNMJ1WhvPikbKdgb0N?=
 =?us-ascii?Q?SAzUeky6UobLVBFQGLFHapA8R8hzX/JAmOrxzjxkZ4eU8f4Uljr7SZJGWJ+3?=
 =?us-ascii?Q?CD5HFZl4kBMrUyVXBkvaBz//OLwUtY8VmjvBJ1aYX2dV/JDy6+TK9Ya5GkmP?=
 =?us-ascii?Q?0Gwz3JXzvvNEq1TmP5EZFYAa6gbFwE+iFXbSG2UO4OXQUU0/ehgqlWF81R0L?=
 =?us-ascii?Q?+/93rsuMKk3QP1QuCAW8d7E+a7jur1snuU0Xx4O9jD/Eoy0n2JOL+uaaUvGO?=
 =?us-ascii?Q?P45/qKcC1DS/92SklbXMSqICHYL/CyCHgSuRseeXruiNJb0nByIVKq4EqG6j?=
 =?us-ascii?Q?DihQn/e1j8XjcXnzHVpQDiEqr+fMAbwjC3Q3hoI9S8XzkFdPFrgJ9eEu4wF7?=
 =?us-ascii?Q?fBiqacAv2DD/A60/Y8uSeg0qKjHlgX1Z2kMspBEwgF/+2x28Z6QMmcc/RduU?=
 =?us-ascii?Q?p0Eumxiq1BtlGqTCrZXUL9Jg8OHFgRy7KsHYvO3s4EhW9G6luMawIC63/j8X?=
 =?us-ascii?Q?LxIj7vGnaPdUNp15Q0xyFJgRIQPu2YEAkFlT5GBXoONRH5ZPVGOvlrTn5q2m?=
 =?us-ascii?Q?qpCK7t2xMRBgLTOrLCBHjUa6JunN5g1blS1jJwsp9Wp1yHpTaH3xXOXK3IDs?=
 =?us-ascii?Q?wRgqcdNeHSrNJX+J9tPONwq8uvb4/v4VboYd47P/9ihOO4gJ8tGFWzay39+r?=
 =?us-ascii?Q?3R0YxcrgJT6/ekrGVzkhDBSsS7ccdrCRFt/k0tjhR62np2eyGCxI6NN+xHe8?=
 =?us-ascii?Q?b7jBfZxTPGc0Idrv22xBztQqV6QBMduoJEgSEFtODxtZa4JPmspLb7SxEwDV?=
 =?us-ascii?Q?62UeQng=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6739.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7s9Jb3H2aH2kk5jgONLiQgEAazZJgDlEJFOWxa3mCzNbz8uZ2yOKQfHlxz7h?=
 =?us-ascii?Q?WPQ61pEbiPyCaYezUhBqbLd20ayIjO1dxQd9VtbySRztA9YLflysxBPelWXe?=
 =?us-ascii?Q?YaDE6bsACtgqGMAMsQ9hk3RPRj/tLc4rr3ILLGp4duakGZY7xMO6hiap85cn?=
 =?us-ascii?Q?PTCkawFwE7IFMazHavf/ERRaxhUA2g2rU0wowE5wjExI4hmSUrlH5KcbO68s?=
 =?us-ascii?Q?/GkY4sDqLzF5vRvWBAWfI9Zeou7iSAdjWj9vpCrbV25/SkozV3Kg7fNvQlKu?=
 =?us-ascii?Q?JXKYEd7CUpzhH0uHoczDOTQ8a5PKf0flx92CfEYGu8dFyiw15K4O8h+ZXiuV?=
 =?us-ascii?Q?VYPlDfQtXDW9Zgbv2q51G3L0JsE9v1L4pOvMI+5yWujc8bYyNugFCFQ+JxXn?=
 =?us-ascii?Q?21edkDrKXtx7xcEBIDP3OcrQKZC/xLPH24nhtD2JLB07OG+NVNgrKGIV/W7L?=
 =?us-ascii?Q?SE1+ZCFAmBdHdkFOy4R6M2JbLhgd8GL/iDqmvIpEEwPR1Dk//yjk7NFy9TvU?=
 =?us-ascii?Q?/J03mFUJXSZmij2YqCbF6xzWmIcO/23p2eEcJ39EkTl3SK9gaQIUbFrxTdXO?=
 =?us-ascii?Q?oIWe5TNhkDl16dvC7B/hiPfBNRD2WAskCKVOcNbB5MCGQ8rbT6w2tSczTH6G?=
 =?us-ascii?Q?o5dp7uXMr4MERo/NawmthtMuS24G24982/0Je4v0LPHIHbQe2BlMQdX5MCFP?=
 =?us-ascii?Q?GiRfgCT/u5wIC/fOqozme+WFE8NW+abpODxap/XUaPfnwCSaa5pTxNjBcP0Q?=
 =?us-ascii?Q?IBye3pTzBK41O+DxEW5iPBg4FYBK9U29L9KmlE7PHcQmDH3YBjvbSNC/PDBa?=
 =?us-ascii?Q?+Ua/+lm6VRqZJslr7EuzYu39GJwnPUzNDLGtV9re+BSyVLEUR7QmcF5nncKT?=
 =?us-ascii?Q?g6VfuQCS5YWlCPqbgJVNb3qy2wmp0/zZ7ly09AtAP/WwcSfX2HdvL1QoG+L3?=
 =?us-ascii?Q?ROjS7GlFv9TMTKojKGy58sqEOPEplgRvAxR7pSQkwQJ2ykwE2Z/0+FNUOpbW?=
 =?us-ascii?Q?DWmXSB/zzu+L8CvBoz94kRr5JB6ixl03rX3mVDNmEgh2WMrRgT7y8W3V/RcI?=
 =?us-ascii?Q?AiTcOgVUME/8YSSPVEWldyRXmPzxS/6D7GKA1aEKD2KtLM2X2CcWIf/J25PK?=
 =?us-ascii?Q?iH7b9Inpea5R+YdsCwmpZH8yYRMSi8ufikqoalekXlgybq+y9YJKsNIIFzwS?=
 =?us-ascii?Q?Ndnz99TGpwxnZlpaVtqZQBilcz/iFqp1ZZyXbvYlI+CWwTmmmfE5mmH4lVzg?=
 =?us-ascii?Q?RJGByJlTcUgdQzPK+zLd5844Zg/CfZFUCiSKzWREmrtF/tU8ksUwhDJatghd?=
 =?us-ascii?Q?SXSv0JhVp8hro4cwyv4vJoEk1Ckb4+TmUydsIe0VzWHMxAyFN+iqdAE4yH/A?=
 =?us-ascii?Q?opWGFbFs9XJXpqGFZmCbh5PyqKD49VKXj1dBgxEr4DPWQYDhERyAUFS5q1gQ?=
 =?us-ascii?Q?PvPVPwqkvkR6+YGoW+J8EXu4ZTmgdOgOLnIBDiB1WV3JNO6SGlmnIfM/torq?=
 =?us-ascii?Q?H8DgVRdPmPgiTnHYr6lCQyL9+oH2i4OrU4Fd302TVvWws9cBCA1G79zKSuYI?=
 =?us-ascii?Q?3NbRQynAWqZvdfbm3bWFemq6bnVXLftD79JGsTBD?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fbf05ab0-6cb8-473f-f0fc-08dd1ba4bc4f
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6739.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2024 18:34:10.6761
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8hqIsnqI+Y27gQa6kAJTpRI4L8aF1Ct8Js7A2kW//IisUM5PboWmoojZPU2kUgrsVT+gG2+B07DF6DgvtXoz3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6650
X-OriginatorOrg: intel.com

Hi Linus, please pull from:

  https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-fixes-6.13-rc3

This fix just missed the merge window due to some changes required but it is
serious enough I wanted to get it in.

It has been in linux-next for a few days now without issues.

Thanks,
Ira

---


The following changes since commit 40384c840ea1944d7c5a392e8975ed088ecf0b37:

  Linux 6.13-rc1 (2024-12-01 14:28:56 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-fixes-6.13-rc3

for you to fetch changes up to 265e98f72bac6c41a4492d3e30a8e5fd22fe0779:

  acpi: nfit: vmalloc-out-of-bounds Read in acpi_nfit_ctl (2024-12-04 14:58:44 -0600)

----------------------------------------------------------------
libnvdimm fixes for 6.13-rc3

	- sysbot fix for out of bounds access

----------------------------------------------------------------
Suraj Sonawane (1):
      acpi: nfit: vmalloc-out-of-bounds Read in acpi_nfit_ctl

 drivers/acpi/nfit/core.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)
