Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD8A2905
	for <nvdimm@lists.linux.dev>; Wed,  9 Apr 2025 00:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744158026; cv=fail; b=eKO33SSjg6Zrk4knyTyaxgkeI7H7sck2vrL4psdCLHt1knjFU9cRhTCc77Q0QFOUxz42iyrO2CVxa3LyL60abUyHdWlcx353TArgFsxFKBuapja4Jylrh9raVnEA0E09BhRxATuGigXS4R112OLZGIVYNwEryXnftHRZXAzefoY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744158026; c=relaxed/simple;
	bh=Pbsee2C0FqiNpaM32CSIhGpWqT5+zKfaK+z0Zr0hDVw=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=tDClbKP3g4m+vM0u3bJxRl7+ZoPzSxSIbYornoKJhUR5gJi8UQhCT7GSKbaPYtuweKeVEiUHg0mQZcXFJqOKDtHJuozu26l/IjsgafzAxOTLojZ3tOCyWYk4zDDr2RkkTiNls3ITXe2Yuxgu6FtcEJNMpGsUYr52knBgCMDnIAs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UsCxDf9h; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UsCxDf9h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744158025; x=1775694025;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=Pbsee2C0FqiNpaM32CSIhGpWqT5+zKfaK+z0Zr0hDVw=;
  b=UsCxDf9heXXPVWh0r1zDGFnPeoDf84SCq9eTvRSOUSBFA/FPyVR8uA1G
   DwBZYxJzrYsDSjn62S/WYEnaxetycRcA56WDLoax+ZbKks7ZJ/FyNgKAl
   yRJrrgqly4G9FqFFHL62lEFVU5625ch/Ej5zPlGJ596mOsbI6EBmfSWsZ
   L6UkqngFEJaJnwqCx7Rh+FrYNaBRv4GLpUnxd52NqnJG+725qwzbffvX8
   +6zDlxCzXFn8ND6poPQy1uqF/06LK/7z5LVfzPCWNpOF0irikDSaACMCs
   R9p1glSRGe/NYi+loedzdfKDzt5IzDTN1YeOuV7lVgn3pH9imEuCY8bCj
   g==;
X-CSE-ConnectionGUID: Q4GPKZMYRA+8CLcag8DTyA==
X-CSE-MsgGUID: YPK3bWNmT6eezNAmLZe1QQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11397"; a="56984764"
X-IronPort-AV: E=Sophos;i="6.15,199,1739865600"; 
   d="scan'208";a="56984764"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2025 17:20:24 -0700
X-CSE-ConnectionGUID: A6fWj884SBSJnAAVZyFiIA==
X-CSE-MsgGUID: AY/HuYuXRva4v+2zl6bvig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,199,1739865600"; 
   d="scan'208";a="129376289"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2025 17:20:24 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 8 Apr 2025 17:20:23 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 8 Apr 2025 17:20:23 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 8 Apr 2025 17:20:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rZaXSsuFh8iA84830bEtajraPTMjWecshH7L1trTFz4ByPIJ/lrzajYM89iOCp9pcJP1iAwMGNYvcf4L2mWA4ZZLZIuPQv8OaFGlC5E0PMiRVDK3qA28AwAOTTrnWqRZnb64Q+pQb8RMpd9sXpyVVfCxdJX41syww9lC4sUadtGSlWn1NuYBUbrZpWUTe8dv1kk1djXzhXemhkwtTIBxLeoXwoW8ts7M78qp8ZLBqQz3SLrfhLuarzix+8KFT0w70Z0FftXKuNIw8dVU4sZG9BMi0yxB1LF78wwHRDlA+11dMTIeKsfMszkqS4l22t19tCgmVPjTGhWQbbDrqPOSqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kfam8CNUPLkC2Tx86eBxTbE8T3XTinLqFVdL3WRtC2g=;
 b=WHt2S2RSHQHBtwQ4yJibbc0LjykhwaxET2WLxe6LxT+LK9dla0PueyBsIShFPob4Ob19Lol7j3OWZj94YqxY1fXJKPYzEJDxnJF+33hWxO7UkX+9I6n1n+d8wxhycK54IbLMu0ZmLdXS1MHnCGP4XPe3McVb5zrgN/BsIH6fZZLQTfce1rjTHdA8z3RlzDZDkedzHdtJmNNMnh41WOdyDgcbq+kzKnze1Fploglvm+wAF2ZlbcRLiIwRQu0f1t8/r6ggAgwyREVN1GGCO0ZjlPhEykw2PTMb57icV3KQA+M1TTQlN1gae3PzfZJ7Cr/ZCtQtngf0/c1ZLy4mxFPudw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB8794.namprd11.prod.outlook.com (2603:10b6:806:46a::5)
 by SA0PR11MB4653.namprd11.prod.outlook.com (2603:10b6:806:94::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.34; Wed, 9 Apr
 2025 00:20:21 +0000
Received: from SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720]) by SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720%4]) with mapi id 15.20.8606.029; Wed, 9 Apr 2025
 00:20:21 +0000
Date: Tue, 8 Apr 2025 17:20:09 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: David Hildenbrand <david@redhat.com>, Alistair Popple <apopple@nvidia.com>
CC: <linux-mm@kvack.org>, <nvdimm@lists.linux.dev>
Subject: [BUG Report] 6.15-rc1 RIP: 0010:__lruvec_stat_mod_folio+0x7e/0x250
Message-ID: <Z_W9Oeg-D9FhImf3@aschofie-mobl2.lan>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: MW4PR04CA0112.namprd04.prod.outlook.com
 (2603:10b6:303:83::27) To SA1PR11MB8794.namprd11.prod.outlook.com
 (2603:10b6:806:46a::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB8794:EE_|SA0PR11MB4653:EE_
X-MS-Office365-Filtering-Correlation-Id: 756da059-20bb-4f7d-44a6-08dd76fc5073
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?dIu4h/dmd72fNmafyXnqWc92tp66mAO4qU1hFXKIP1f/CBdbqTOPencE2pjF?=
 =?us-ascii?Q?GzWZgdMapPvKrToySHbbdh272GSEUmDhxEvGzPFq6EeIjgFq26eewNUhLdVZ?=
 =?us-ascii?Q?Av/xSiU+SrIdK8jNbTsBkyjmoNiS/4NaFa5YoBfHWY6BFJhNMcCPhAz1Aj44?=
 =?us-ascii?Q?EIZ7oaJhB1DDKl7qW0PZ6rAwldr9RusxSR2DdHHrfmGE5ds9A1T4bN/4ogHb?=
 =?us-ascii?Q?Ftzn6dpjzbZn0RzOccYDClNK/xXBb4gQMdf7HyGBif0E5oeizk0hjyMR1Qa/?=
 =?us-ascii?Q?G34HWxSIY4lDITRM6Ah3eojWoo9yoSKZ/MG71CLRwDXhk39EtwoZtN+V+tkr?=
 =?us-ascii?Q?yU/VDn1QHJS5azaerr4p4iUhy2oF+12ai3iWJ6+DCx4gUPvpEdhVqwMSGmru?=
 =?us-ascii?Q?NGe24Wv9CqESFpwIVoSHFBJblD+7BdK4p6Kx/JzQu52vz8hAp01shaaoV4b8?=
 =?us-ascii?Q?cPHDENYwpcduDrwcM2KDFKIFJW0UXxpi6nrbz5bJJRF4FhTGrRwXJ1e6eo3H?=
 =?us-ascii?Q?dcvDzwGlejtKw4rkA++eaXCipdwseLrjIcdqDAV8NmOPGn+7QynkPeO9ETwI?=
 =?us-ascii?Q?xoodK6BgNwApa+TWbMEVD+M+/zdWp4dRWrzri0qdPiSiunx5SjnPLx1cD2h1?=
 =?us-ascii?Q?hEPIqVMCFU8UECgp3kguH/PweFp6HO2pUVIw4Xqa2jGMC4mYwCK2Q/BpxKVv?=
 =?us-ascii?Q?8mcmgTmmp4oiNNAbx7+UFW0Krakvh5RuSTqqpLloHytk72Hgpr9yTOa3DDDc?=
 =?us-ascii?Q?N/geoPkfi3j5seMAoj312be+92JKNRdd/jkXfqFLgMo9JytGBxyWlNGFl9wJ?=
 =?us-ascii?Q?k4DrkPF148c5aJzHIT1LDRbv4qZk1qHzmbPjBOlC40s1otwmEXrjxJzuZguk?=
 =?us-ascii?Q?2BRgzUPgpchy1dALcGxtvSpoeQ3Qj5Tazjb6GPY2N6/mcFVqkjlMvAxc/XW1?=
 =?us-ascii?Q?8WtzXvEe78yAO0OD+p+0hAowZR9r3Iq2EhffJn0l5b/mY/O1UOft4oKuExmA?=
 =?us-ascii?Q?o+E9P+rs3+BZ2iB8CCyUm6dHubuwFxS0ZtiuzaUfmvhIaYn7+b6njw6bpgel?=
 =?us-ascii?Q?HUrmqPCH9IH8sTzjbsRaqb/RCIww6TyG/NOVTihW6PzBztm/CSv2IguigkWn?=
 =?us-ascii?Q?8Fa+xFU2GE0OpKFN8rjNjrwb2d7v8SyDMTsFSouqgpoLV3Qpo9IIImd6c5FD?=
 =?us-ascii?Q?WX3mTyMVr0mau5te4Z05rc4g+xk5LwhWdIKd7WhkRjmbtljcpnOSW4PMVrLy?=
 =?us-ascii?Q?tdfer/YBxG3P/pIxpGteceNrB/JDdwHK2fFccuN1vvEQznjnpfDbCJy3TB8j?=
 =?us-ascii?Q?oTh/BUTwLAhARBtQPFO2J4pwrioOVmYaoIwxFxtJRZ+MeIj4qZjd89WtLX3l?=
 =?us-ascii?Q?xBVQQYpPte054rDvPy+57pfyxmP6?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB8794.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?j+aFbIUHRj5O4zB0QMryYT6aYLm4fVWTETMvDzh43q/x8IY1wnM5XFhV/l+/?=
 =?us-ascii?Q?aJto1yJ236EILnk2Hh2KIrI1W0KzqwpZWdugihkmZSXEos+NFHXWXb9Ai/fo?=
 =?us-ascii?Q?pHDmxAEhkiDGHdnMAaUZSaV4p2majeAFi8SNIf2cgZbKgv4JB4+jlHm+xc//?=
 =?us-ascii?Q?GkJjBLvcyK4MdiZ6j58478X/U5KKm8cByHPVm9ImIgxqv8EiwTccbRYn3ah5?=
 =?us-ascii?Q?SJZQPhrLcG9jGI99WwxNcQsI4/GoNOiMZRmhRVxN5V+cQZ8x4mrmANEFnzRN?=
 =?us-ascii?Q?K7OL2RZ1A/5vz2LY9nq2b3g4uTbNWamZUku6YZkzcFuNaVf63MYiH9szGCP5?=
 =?us-ascii?Q?1d85B3ouy5bwJ/DpTuCbWTQGQOegKxUKbIibdOnXGwM1m+LtOn796SIBzJOn?=
 =?us-ascii?Q?tm2xdJi3P1kKGshjeDIQA6g2Y/n+TVqHYZrE95TZX+fxHLhJE19AGxHSqtTV?=
 =?us-ascii?Q?ACognaoN98gIcsWHAFJ5RVSV7BmPD1HSu30oLgIBAl9PqZapt4mpstdweQ2y?=
 =?us-ascii?Q?B495xzOWc5Yv48shAJmHYzYNEEt7BN6HYzJCgtAEBj/W3SDOxakskJ4IGv9c?=
 =?us-ascii?Q?sA3mqTtktFNcwVzacINo3rAYGUR/OObIWcs1O5ChXnMgos/gD0SbbXgHMzUj?=
 =?us-ascii?Q?8J157tK2kIQ9gMH+fKkzNXP++46gCGBYZm0QhGi8CRfkb98Dho7G1WdjlO8r?=
 =?us-ascii?Q?L9KFDgRUv8t4l3aJEEW7579L7gP0C2OX8JRHqU1GKVq965djDBUv/3k0/KzB?=
 =?us-ascii?Q?6lznelUUYRPqt0zMUpJ3NmfFmt6INjtjib1oiyQm0dKu4CLFiQOaB7oBwAgp?=
 =?us-ascii?Q?zAMmxmLPhGKyG1quyk/fLFtboHlJu7v9EPrnHP6ZfvmvwLKRBDkU1N00rjNs?=
 =?us-ascii?Q?qs+cDdt7+NwRWccDo5bpNxLHjkKz/tqNt3gF2GbfXVDE1moXr5FnF3nfB/Ig?=
 =?us-ascii?Q?sFj5mw/qXmhjkR4KMcbiMS/LGgHJYGKMNGrb+xJCkNta0LxtPuKq151cGLcH?=
 =?us-ascii?Q?wyvUtCVjlOthCgjh3Iyop9Fw2Br1wnBHQoKPjp5M3eylcl1n4/+U6ca8NXZS?=
 =?us-ascii?Q?Zqt3NC7GBb+11gJUoqKU499FVejO4BuIy7BA7gsswGK0lkBDYXqtCkNLHWOw?=
 =?us-ascii?Q?6TjvvW2S93oLANPVNxQ3q+0wo5XrcmfCJnOT0qC7qxYw8z9TTirkqvarxLYT?=
 =?us-ascii?Q?o4oQvYT8RRfdziPIBd4dnbiYVEmTJRvwFqS/4Vc8f7s/180cV5q1Q+0Dk5l1?=
 =?us-ascii?Q?4oxhKihd0SqGVWph3hVmvG8x1OKSljMIzZMjAjECzLZ46nYvoKjt39s/bjHL?=
 =?us-ascii?Q?J4oZ2PvlVLtVCNJP1JJDWP/ohYCbrY4Mamuwkfo4qPGSyYyzOV9uxQjPZaik?=
 =?us-ascii?Q?Wt4ByM8azWMmfv+eIeJIAotFATpqkctfQ+0ee2PxEAlSLxgxvmBOF3vT5lVV?=
 =?us-ascii?Q?b0vGlaK4dv/SH5OQsW5DYxJQ7ag88Vwklcxdhbomuxfcpv1z/ncxhCVhXiZl?=
 =?us-ascii?Q?J2TY2N199QKwHEzZqmm4/LOpY93viH5LZ4p4ER7/UgglABE8o2PTcmljhQ66?=
 =?us-ascii?Q?3NOymCrU5tce42bh19Oyo55nZjEdoUO531DmQ/XJq6qp9MM2u5LyF+L4R7tq?=
 =?us-ascii?Q?vQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 756da059-20bb-4f7d-44a6-08dd76fc5073
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB8794.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2025 00:20:21.2303
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S8go+fwWy5yuNM6C70WjgTy10tJbEXUEAhl95E1vetvtcqxKq16hkbQKc2YdfLr+de3ENP8oQtUuQJVN9rxYfeqhccjZ7tu1N6ZItb2YZr8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4653
X-OriginatorOrg: intel.com

Hi David, because this bisected to a patch you posted
Hi Alistair,  because vmf_insert_page_mkwrite() is in the path

A DAX unit test began failing on 6.15-rc1. I chased it as described below, but
need XFS and/or your Folio/tail page accounting knowledge to take it further.

A DAX XFS mappings that is SHARED and R/W fails when the folio is 
unexpectedly NULL. Note that XFS PRIVATE always succeeds and XFS SHARED,
READ_ONLY works fine. Also note that it works all the ways with EXT4.

[  417.796271] BUG: kernel NULL pointer dereference, address: 0000000000000b00
[  417.796982] #PF: supervisor read access in kernel mode
[  417.797540] #PF: error_code(0x0000) - not-present page
[  417.798123] PGD 2a5c5067 P4D 2a5c5067 PUD 2a5c6067 PMD 0 
[  417.798690] Oops: Oops: 0000 [#1] SMP NOPTI
[  417.799178] CPU: 5 UID: 0 PID: 1515 Comm: mmap Tainted: G           O        6.15.0-rc1-dirty #158 PREEMPT(voluntary) 
[  417.800150] Tainted: [O]=OOT_MODULE
[  417.800583] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
[  417.801358] RIP: 0010:__lruvec_stat_mod_folio+0x7e/0x250
[  417.801948] Code: 85 97 00 00 00 48 8b 43 38 48 89 c3 48 83 e3 f8 a8 02 0f 85 1a 01 00 00 48 85 db 0f 84 28 01 00 00 66 90 49 63 86 80 3e 00 00 <48> 8b 9c c3 00 09 00 00 48 83 c3 40 4c 3b b3 c0 00 00 00 0f 85 68
[  417.803662] RSP: 0000:ffffc90002be3a08 EFLAGS: 00010206
[  417.804234] RAX: 0000000000000000 RBX: 0000000000000200 RCX: 0000000000000002
[  417.804984] RDX: ffffffff815652d7 RSI: 0000000000000000 RDI: ffffffff82a2beae
[  417.805689] RBP: ffffc90002be3a28 R08: 0000000000000000 R09: 0000000000000000
[  417.806384] R10: ffffea0007000040 R11: ffff888376ffe000 R12: 0000000000000001
[  417.807099] R13: 0000000000000012 R14: ffff88807fe4ab40 R15: ffff888029210580
[  417.807801] FS:  00007f339fa7a740(0000) GS:ffff8881fa9b9000(0000) knlGS:0000000000000000
[  417.808570] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  417.809193] CR2: 0000000000000b00 CR3: 000000002a4f0004 CR4: 0000000000370ef0
[  417.809925] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  417.810622] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  417.811353] Call Trace:
[  417.811709]  <TASK>
[  417.812038]  folio_add_file_rmap_ptes+0x143/0x230
[  417.812566]  insert_page_into_pte_locked+0x1ee/0x3c0
[  417.813132]  insert_page+0x78/0xf0
[  417.813558]  vmf_insert_page_mkwrite+0x55/0xa0
[  417.814088]  dax_fault_iter+0x484/0x7b0
[  417.814542]  dax_iomap_pte_fault+0x1ca/0x620
[  417.815055]  dax_iomap_fault+0x39/0x40
[  417.815499]  __xfs_write_fault+0x139/0x380
[  417.815995]  ? __handle_mm_fault+0x5e5/0x1a60
[  417.816483]  xfs_write_fault+0x41/0x50
[  417.816966]  xfs_filemap_fault+0x3b/0xe0
[  417.817424]  __do_fault+0x31/0x180
[  417.817859]  __handle_mm_fault+0xee1/0x1a60
[  417.818325]  ? debug_smp_processor_id+0x17/0x20
[  417.818844]  handle_mm_fault+0xe1/0x2b0
[  417.819286]  do_user_addr_fault+0x217/0x630
[  417.819747]  ? rcu_is_watching+0x11/0x50
[  417.820185]  exc_page_fault+0x6c/0x210
[  417.820599]  asm_exc_page_fault+0x27/0x30
[  417.821080] RIP: 0033:0x40130c
[  417.821461] Code: 89 7d d8 48 89 75 d0 e8 94 ff ff ff 48 c7 45 f8 00 00 00 00 48 8b 45 d8 48 89 45 f0 eb 18 48 8b 45 f0 48 8d 50 08 48 89 55 f0 <48> c7 00 01 00 00 00 48 83 45 f8 01 48 8b 45 d0 48 c1 e8 03 48 39
[  417.823156] RSP: 002b:00007ffcc82a8cb0 EFLAGS: 00010287
[  417.823703] RAX: 00007f336f5f5000 RBX: 00007ffcc82a8f08 RCX: 0000000067f5a1da
[  417.824382] RDX: 00007f336f5f5008 RSI: 0000000000000000 RDI: 0000000000036a98
[  417.825096] RBP: 00007ffcc82a8ce0 R08: 00007f339fa84000 R09: 00000000004040b0
[  417.825769] R10: 00007f339fa8a200 R11: 00007f339fa8a7b0 R12: 0000000000000000
[  417.826438] R13: 00007ffcc82a8f28 R14: 0000000000403e18 R15: 00007f339fac3000
[  417.827148]  </TASK>
[  417.827461] Modules linked in: nd_pmem(O) dax_pmem(O) nd_btt(O) nfit(O) nd_e820(O) libnvdimm(O) nfit_test_iomap(O)
[  417.828404] CR2: 0000000000000b00
[  417.828807] ---[ end trace 0000000000000000 ]---
[  417.829293] RIP: 0010:__lruvec_stat_mod_folio+0x7e/0x250


And then, looking at the page passed to vmf_insert_page_mkwrite():

[   55.468109] flags: 0x300000000002009(locked|uptodate|reserved|node=0|zone=3)
[   55.468674] raw: 0300000000002009 ffff888028c27b20 00000000ffffffff ffff888033b69b88
[   55.469270] raw: 000000000000fff5 0000000000000000 00000001ffffffff 0000000000000200
[   55.469835] page dumped because: ALISON dump locked & uptodate pages

^ That's different:  locked|uptodate. Other page flags arriving here are
not locked | uptodate.

Git bisect says this is first bad patch (6.14 --> 6.15-rc1)
4996fc547f5b ("mm: let _folio_nr_pages overlay memcg_data in first tail page")

Experimenting a bit with the patch, UN-defining NR_PAGES_IN_LARGE_FOLIO,
avoids the problem.

The way that patch is reusing memory in tail pages and the fact that it
only fails in XFS (not ext4) suggests the XFS is depending on tail pages
in a way that ext4 does not. 

And that's as far as I've gotten.

-- Alison
