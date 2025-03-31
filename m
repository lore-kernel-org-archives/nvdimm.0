Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7C321B9D1
	for <nvdimm@lists.linux.dev>; Mon, 31 Mar 2025 21:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743455805; cv=fail; b=l4iYh+uwcxboG0ttf2jMw0n0bpTv5ediDWKNX6RIFfIEiZm/LgyeXlfJplGq+YKAmYUCuNXe9+1Z/GL0w/Xfa9rKdy59nRwixaAs0MqO6Wm7IQoZFWnhH2tTV05jqgEuHgVVTLZhTzrMLM6w9cjXFR7b6oeDHRMrcyXSIAQn28c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743455805; c=relaxed/simple;
	bh=Pjs7KSPsmH02DPXEEe4mMU0WZxBPykY+DP2yUDMPawQ=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=Ryrwn/3mdtH4xRAF3uDuYwRmWsShIGN2JwwZC4L6gX7nCtTGl0r0TkOhtaVgtlJIhilW1EBWNRYFsh/KCQZ6oiLQ7ofPYY7zd0zP66XwQX0kJv+hBbJEeql2chGuZBlaODmfd9rbzhSF/8xuCGD7qDLsZvSRLhIieZCQ5yUmm+U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FErCwg+P; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FErCwg+P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743455804; x=1774991804;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=Pjs7KSPsmH02DPXEEe4mMU0WZxBPykY+DP2yUDMPawQ=;
  b=FErCwg+PDUvhNrOUkQe9GXpamj6Vqynwrpti5xdyR26CYs0Utkdkd6DZ
   GD64IlCPbMo6toQtVCpv767Bufg2Bgh80exzpR9XW+WJ4cfShinxq87Kw
   a0oM3ztTELCMQHiV/52sz38t4SkF1PEOQJ+5hkFeVsCYh5o4ZVVuORHLj
   +2gF+JwiNjrJGa9pfHLJWMIEPGxAMHz1+aR9exJmNtDAh5qVWzSSgHMx6
   hCF4HznICplME96x5vTG0jfyN6oyNwZwouNCzDK6sukvu5+ZVIIBVKLEF
   P2RtXynW/gWlIXioFIrQBA2PcSUWcrXZGs+rHyJkOSplIlB9bk59qFTuo
   w==;
X-CSE-ConnectionGUID: 42H/zR+OSjGQedq0FmCCBg==
X-CSE-MsgGUID: CfKpl4d9TSiXHJWIHR3jdQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11390"; a="44010070"
X-IronPort-AV: E=Sophos;i="6.14,291,1736841600"; 
   d="scan'208";a="44010070"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2025 14:16:43 -0700
X-CSE-ConnectionGUID: JXhxStO3RYSRZkFwiRbISQ==
X-CSE-MsgGUID: zPiNw7u6QACcgtkdG4RrHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,291,1736841600"; 
   d="scan'208";a="131410109"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2025 14:16:43 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 31 Mar 2025 14:16:42 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 31 Mar 2025 14:16:42 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 31 Mar 2025 14:16:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qUptYOSwvZvkWyx8q6wLV3kzQdPMQLFwiHLfGXkEKEyc5FTziarQHr0hAWyEda9DrQEgMqzFuPuHDNNi3APi0K8IwejBhmKpiWaX5HOxK1IazZ+OBERijZnj7iB0ZiMXnDcyt8Up82LB+SNyU8i5qhe3MN2K/C1FV/M2QEKMeqLH3HZ3zKNXIaBIqYKqFtDVeKrjSSRu30/AvBZA9r2Ozd5TLRAabtEQiSftCPtx9XRRTYojXzg2wCGD1Mc9JEfkRtQtgw/6hTy8mgNhdOs9xInEZKj7aluEjPkq8Ta8MTXg4MbBl83LpE1mb7QpvWDUc2oIvkmUyeVHQ/ury0kPYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UkEsZkmhRlC45uqmf/6C/aXDUzaXNzR+XNID/u7FoUI=;
 b=xk98548snNFtkWc2iYu0CjSbwj9Cv6ctArn6GiLjTOGbq2Ko/r5rM40Pj9hnV/ygjjTmHYuOXXrtsQ1kvR9bGeOxve9jlTH6+8h3Y/wovVF+a/cZvCPjYsEAoZmQvLyxTRF99gZeY85NNir/JX4JMboB8R0yXab8J8nHADrHXYcTADE+wd99jx84X61GxzTN38UaZVY270hdaQo7ibrG9HNZLjGQZzYon2hnqaz9mT6+U58vUidO3GIlV/LrVT7zOg/vXWnQVX0mQsoXuuN/Cxsh2vCE5eU1VKullovBYWxF9HCXKat70J+825IQC6ziRQnKvF/yshGfhfV+TYuuuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by DS0PR11MB7786.namprd11.prod.outlook.com (2603:10b6:8:f2::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.44; Mon, 31 Mar 2025 21:16:19 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%5]) with mapi id 15.20.8534.052; Mon, 31 Mar 2025
 21:16:19 +0000
Date: Mon, 31 Mar 2025 16:16:40 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Dan Williams <dan.j.williams@intel.com>, Dave Jiang
	<dave.jiang@intel.com>, Alison Schofield <alison.schofield@intel.com>,
	"Vishal Verma" <vishal.l.verma@intel.com>, Lukas Wunner <lukas@wunner.de>,
	<linux-kernel@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>
Subject: [GIT PULL] NVDIMM for 6.15
Message-ID: <67eb0638e6f4c_3b58229447@iweiny-mobl.notmuch>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: MW4PR04CA0345.namprd04.prod.outlook.com
 (2603:10b6:303:8a::20) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|DS0PR11MB7786:EE_
X-MS-Office365-Filtering-Correlation-Id: cdd1823b-d3e9-4a85-1e51-08dd709947b5
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?xpPJbat5+5/+y/yQZyVA1ZW9pckYfrEeNOSOTZMtWYQ7UT3v7EoW28RUTzoJ?=
 =?us-ascii?Q?Y/6GE/eYmF1fT6PZ5c0AyBky2whIm5NPRJKCNKQqaWzlDiQaIGeFFLMRahwC?=
 =?us-ascii?Q?sI29vxUQ5N3ZxQQUEGbXkpdcj/3PABV70uSgeActvZ+VWbYzgRP7x9mFjds+?=
 =?us-ascii?Q?4GBSloD60XYCQLPrJ60oBgu77wnA6mU59K5JoIOhUcCD+o1yMrug+S/wOuWu?=
 =?us-ascii?Q?KzeZ3XXy9pHgkDfVL/YZMhn2OxmQRdAgTWKP3J3mJFtWfrc1HFNs/sPi+yix?=
 =?us-ascii?Q?/d02nodAtvD6g85SmyaHJk3uMCiH540loqnCl87g73B5QpoTWVQ7Aydi38y8?=
 =?us-ascii?Q?/oWKPWIfwRlVUD9U1B7j0RB8dw1gl9vurD2FIMbfgk3HeT3jOgqZmZux5Qo0?=
 =?us-ascii?Q?DRlFN25RUOMVmLY3austzeFM24VREymbcO2qCtDas1suTOfJhPlePdbzHL56?=
 =?us-ascii?Q?JoVq3xvR3T2P4XMqoqLSXuqzvjkNBYVB+ur3iRLjm/nljmNYu2Gc3UxO03DE?=
 =?us-ascii?Q?0DIgnn0mhyx+aA4AhAlIPL+BTvp72Hm51RU7eQI8KRhtHXOdNdjC9+i1czwk?=
 =?us-ascii?Q?9JpVa1gmKkkelycTgqaDzBrE1P1QaL2zc3V8tNH1eodE1Y/POfOd7zJlsFpB?=
 =?us-ascii?Q?IqNAnN5Bkp0p8tbjhmpOq8UxEs9/iMnyJWg2ujRZM0JR1JryMPNyMLRpVHR5?=
 =?us-ascii?Q?2BsrS3ptKsWrSvyAL9QgoohN+Q+91hcWbhq52vqkJtprfgzMg6lPbl4Vt+D5?=
 =?us-ascii?Q?Pua06ay5pZ9DgHxjAUubGri+P/Y2MWD/U8E23g1nb4FSmZAfLMNn1mYv0EEp?=
 =?us-ascii?Q?KNSkEBMT1Q1CppBijQ8ToHAFu/ql5r/W0Mdlg81CTdfedNfKVd73Rgs10LqI?=
 =?us-ascii?Q?DuUVjy3Qj7sNJsJBMZ27A/mGgkWtPPfe64Gf4q8ViayGVH3X/l4ycKPa31Ra?=
 =?us-ascii?Q?GT8akInkgOWBkw7TH8bpuCgGyJXupkHgECGoSWMzR70M39yK1iWtCQxukZJn?=
 =?us-ascii?Q?xTJ+rjDlFcLsDT/DS+3umKl0YkdSBhAVlANXea1hJeuSV5kFZb38NMBe9f+X?=
 =?us-ascii?Q?r1ucx4CFKyoC9KUVM5D8oeESRcYHlakQTc4pNd07oK2eB09UJmASW1D3HSrD?=
 =?us-ascii?Q?MGTdN276oT1V2vuBszJcmHE18c2nhrcHjNCk9l1m23fFB27Uuklx2ByETxPf?=
 =?us-ascii?Q?ghc8Ix0WZcxT/ubaZq2AGhOqPcx1ehNGVFxWXmwNL3vM+FsfXb65oMMf/tXx?=
 =?us-ascii?Q?XkGA4vk7Mg6iERill/XlA+duyplh2J70TVhSISgiPCoXgtMOUiab+HREaCTP?=
 =?us-ascii?Q?SJNKqBbn90Y7UNVWGeylnpxXCTKJOg3LqNiJWUnQ9NgFr8Q8gvJd1tiNX0qt?=
 =?us-ascii?Q?pYp7apvwlKmB7XAGL5+ccu7TvoG+?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0fRbebFFL4nswMaN+zjQn78tmbxTlC7hnqDgE6TVRg5Et4PsXvZrz3dYKbxh?=
 =?us-ascii?Q?+GjZ6K9kYLMjpJIHXyZNHlRtIUxdrpfYej+nlWYDsXpWvaM1mBVNapIvDZqz?=
 =?us-ascii?Q?qkxbc/Rbh2MbRORJ+eCRf1VSlaC4shn8JN3vTai6bOWfvm6XxGCHXStRq6Xi?=
 =?us-ascii?Q?6JyUbB92Vk3r6J83QN8FY5bWIFR4gLx/Mq7i1kOJbwcSdWn6YXZImHFO0aB9?=
 =?us-ascii?Q?J1Xu5xhDDfNX/a5WdKk4a/hvzqPUSoPf64lELI4AMC571pH7/11CvJ6l8CBa?=
 =?us-ascii?Q?Z+4P6wPyPUdb/yhRi45+tMLic7tKpGRrAKv75Qk5ED04iDs2tFBSMu3XRLFB?=
 =?us-ascii?Q?uQYM0a27OOE2U+BGIMvDA1mPR1sq16pqde3wsuXP5bysxyI0T0quC05rYBxc?=
 =?us-ascii?Q?PwYzuXhOz6bso6ov4b4lzE8XBXTOaf1iDrk4LnwXCr0VjYSr9el7tA3QGAOn?=
 =?us-ascii?Q?CXNe99cMqXFKrCXL/nr/7h5iNev8Svw6K0JTzkqKltkLLDkwFoe1PtMw+nnt?=
 =?us-ascii?Q?gN0st1SreDDkkK8JAjqtV2yw4AMf8LcHKTVKTwhxdmSQU15uo4j8xJa+6eit?=
 =?us-ascii?Q?ORot8SXF8Oc1VW9hpnW91ceWZQkxwqQp6sYSU8S+7H3oxdoaYadLm31MnypN?=
 =?us-ascii?Q?pVeBl1rkitppSFHbLmgODGBdZygtKJE+n+QFI85RwK4qR15pml5fsKV9vRvy?=
 =?us-ascii?Q?fAPGUNsuLl3+4Vj19k4bt6yV4Ciw/uwTA7RJJszUBYW9B5Y1NESdur1v5Tyk?=
 =?us-ascii?Q?cIJeGWg5hABa1sH6wntQPlbSm/IWZsS8WWMYp+Y35+ksp5hauESlxxBNtbMD?=
 =?us-ascii?Q?voHRP6F6jB/rRckSlg0kiQw4evILqezVQp9ZTmZipfVGLL+LRCKylOquGI60?=
 =?us-ascii?Q?btij5Hr8pO/a31+Kvr0QzOGPQA+hRwTQhXq14iNu9xszUgvs2Yir3r+QnpUB?=
 =?us-ascii?Q?C32exXyJ/21SzXUj37W9s+Djl66/wBMVFsj1nxJ9ib7W7Pcda1x+rbtU8KiB?=
 =?us-ascii?Q?pwjVEPb5xC8OKzsAmOw4mN+GTuyIcExF9JeFPHl+9+pFQcZsZwAdQtYR0z2/?=
 =?us-ascii?Q?N41bQ7JMbZhPYHET/mfCMZV7RvEpp93u9oWXbAMtrztQ024kaTC8sZzcvsib?=
 =?us-ascii?Q?NeqVTUtELoABc33ApyWd6wvwCQFE1/Ad+4ZsoqrNz3EwCLUwpUOwfS8o36uT?=
 =?us-ascii?Q?RkWxwLyGtE67NPNY2NkX+0K1HRUQehY3OgJOk+z+GAcqyZxGwfy9uuKf9tLU?=
 =?us-ascii?Q?RVRR5DjwNfset2ZShO6SrKHU+aRc9IWi3BuhKUPZi5e5V2mOv4jzl5cOFpa1?=
 =?us-ascii?Q?1jCyQkBE5zw5AE2Z10aS1/QYM5JsL7y23M10PW1huknCQYCA/qYKtwcu+fe2?=
 =?us-ascii?Q?D9DVJIdfwQ2m78QzOOpy6pws6QNAjay+upryE0+zjGszVF8xaUk29u3jkSm9?=
 =?us-ascii?Q?kdNmbsfG8VO9hktFVEk7iI0YHcGP5SlCwM0NzJOPWoyjkpZ9+z3OAev1aOXq?=
 =?us-ascii?Q?icOA/NiUIxKdvndpprT2ZdkXCsLFnQy5hkG08RYaRnLRzZJFws8VmL9r21bC?=
 =?us-ascii?Q?A+ZjqcaOF8XV0s/Zv3Ekh+dF8P/GDCRN07glwN57?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cdd1823b-d3e9-4a85-1e51-08dd709947b5
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2025 21:16:19.3294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rubGEwinG3V+h+lNWqgmfGeTINl+cts+24VzcTTgPYAazPpzhxL4qH0C9yN0eJhuRBt8uKKdvp5hjFAw27HbNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7786
X-OriginatorOrg: intel.com

Linus,

Please pull the following updates for the nvdimm tree.  Most of the code
changes are to remove dead code.

The bug fixes are minor, Syzkaller and one for broken devices which are
unlikely to be in the field.  So no need to backport them.

All have been soaking in linux-next without issues.

Thanks,
Ira Weiny

---

The following changes since commit 7eb172143d5508b4da468ed59ee857c6e5e01da6:

  Linux 6.14-rc5 (2025-03-02 11:48:20 -0800)

are available in the Git repository at:

  git@gitolite.kernel.org:pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-for-6.15

for you to fetch changes up to ef1d3455bbc1922f94a91ed58d3d7db440652959:

  libnvdimm/labels: Fix divide error in nd_label_data_init() (2025-03-20 16:54:27 -0500)

----------------------------------------------------------------
libnvdimm additions for 6.15

	- 2 patches to remove dead code
		nd_attach_ndns() and nd_region_conflict() have not been
		used since 2017 and 2019 respectively
	- Fix divide by 0 if device returns a broken LSA value
	- Fix Syzkaller reported bug

----------------------------------------------------------------
Dr. David Alan Gilbert (2):
      libnvdimm: Remove unused nd_region_conflict
      libnvdimm: Remove unused nd_attach_ndns

Murad Masimov (1):
      acpi: nfit: fix narrowing conversion in acpi_nfit_ctl

Robert Richter (1):
      libnvdimm/labels: Fix divide error in nd_label_data_init()

 drivers/acpi/nfit/core.c     |  2 +-
 drivers/nvdimm/claim.c       | 11 -----------
 drivers/nvdimm/label.c       |  3 ++-
 drivers/nvdimm/nd-core.h     |  4 ----
 drivers/nvdimm/region_devs.c | 41 -----------------------------------------
 5 files changed, 3 insertions(+), 58 deletions(-)
