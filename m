Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0EB929D06
	for <nvdimm@lists.linux.dev>; Fri, 19 Jul 2024 16:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721406003; cv=fail; b=a8JAMGhmS4V6FnnDBjN0fICae3y/GnKzAodnpnUEYJSViPQN9m47YGbyLpWpLL8GRNfuphm7VWP4aiFoPXiqYBZzXD3nVvcKbX7fP8mzwPQEYSruuDzwXVOTrj9yokhaukzhnC6Zt7WGo5KhQKnVvxQbZrJ0636hshTiQi+f2zY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721406003; c=relaxed/simple;
	bh=OINMrvTikNtHSPvsVUnINW/1wnS/jzZv9wSj/0gqxMc=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=IAg9UzOTPOzTEG+KjMzp5PQNFtB0gR/mXtQJsnjfm0ueRUEo94ZOBL+WEXwUjbbEhbtLowCE4uvA9SkPWgE4b8C01x2A4IgfV48rsbSHDufoagi2Z4nzdcFh/ThSJqwh4215q3G+P+0L1/UlYtiKi2MkHGENLbhUKOMCgtRgVGw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W4XKKWaw; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W4XKKWaw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721406001; x=1752942001;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=OINMrvTikNtHSPvsVUnINW/1wnS/jzZv9wSj/0gqxMc=;
  b=W4XKKWawHT0BoeJ6uZJF6g+H6sEpC7tdGQ5M5j+mvDNwkwBz8hZpaLY3
   iQNbOZNBpfy7IzpdANANZmZSb1Q963mKCIged+0BLaLOHsyhcfJN4H0X/
   ED/Kql9nN2EQtSxrBJ7ebUOd4D0SKOnRLGsriePQREUXUClmmfGmaWGD4
   ZrLFw+Dj7RLbOIueNEJRX1AOF159274jF3NIJXgoTNgdUHh1P4ain7xfQ
   +B618Ovxei20RRT4xcnebspB8de9SXQZJ9JtSEoCp6XWye5YlLogyzyeR
   5RWIzoxPsSIQH2j3N36DGxAW83z47AfHiD/ZhIn6HIz9/cSHWK9aLPLoc
   Q==;
X-CSE-ConnectionGUID: CVfV4wgnQWKsBto970SKFQ==
X-CSE-MsgGUID: EwZUvd0RRRG6d8s9sECw6w==
X-IronPort-AV: E=McAfee;i="6700,10204,11138"; a="21930402"
X-IronPort-AV: E=Sophos;i="6.09,221,1716274800"; 
   d="scan'208";a="21930402"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2024 09:20:00 -0700
X-CSE-ConnectionGUID: QmJACc5jTJyWB7gO4XWCXQ==
X-CSE-MsgGUID: W5DjSPNBSYavVKknFrCXIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,221,1716274800"; 
   d="scan'208";a="51183817"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Jul 2024 09:20:00 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 19 Jul 2024 09:19:58 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 19 Jul 2024 09:19:58 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 19 Jul 2024 09:19:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ESpUi5AorDVNnf2WPln7Ci62mRcKNFogElt6Q61Bbq2HVqsS+WZMpbViSrHZ5W/Ik1sgZSxlWikucdJi6vgFV2EEDUKE0IyxgNhkIT5l9v4lbyI/oHi5iGW8rfQR9R8VweI8MLEW+zt7kGOaRyXr4PCAgjyJ4UTxmUeH5pcGkyrTM9CZJyEYi6grVMqVKfT/kaPgfbZi3tnBWo49KKhz05FmomX4XccIGJlMIyZCMyEUEWK3TebKOmHuh36Gf3e+8oTYLUmdzXKn0t3f9ApPMpHMmsdTprQS00yxwxdGgolRhtPBxmBTIwJJknxnnFYAEIpjWZwROxDsiRrO1MdLsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IqURcXYw61lA8sxxcHbK3uqETe8//0WYfVBlbFb4qFY=;
 b=YF48koXCS1tDSmllXGdudAoBJvj9rFCpT/5E2+mrNRfvdq5zz668dVrvniffZBk5fezJCbAMTflm62x9qDl7lk+GAPQKILs/qqqYnZVSVEO+nhHiSeaxEV3AvG6Dem5CQdOy6GaVXZs1bKofbityR3T/LOTxWCqD5SJYZ9cIdCoW50PcqQLGRT6MZailsMahANUfgd+IUAVGLzUyXJIZEuWheNnuwOCyr8TmN/9MiX5c4Tm34rM9JtEiVnuAtyHP9hyWnSao91Q59tZdGwVIwYmu0liuIn3JmCbUtLkyTtHPxsZ6+Ic12wWbGb7J7tZoHeT2J+aligbocqK5DB+/2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by SJ0PR11MB5199.namprd11.prod.outlook.com (2603:10b6:a03:2dd::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.28; Fri, 19 Jul
 2024 16:19:51 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%6]) with mapi id 15.20.7784.017; Fri, 19 Jul 2024
 16:19:51 +0000
Date: Fri, 19 Jul 2024 11:19:47 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Erick Archer <erick.archer@outlook.com>, Jeff Johnson
	<quic_jjohnson@quicinc.com>, <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>
Subject: [GIT PULL] NVDIMM and DAX for 6.11
Message-ID: <669a922323f4d_173615294c1@iweiny-mobl.notmuch>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: MW4P222CA0029.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::34) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|SJ0PR11MB5199:EE_
X-MS-Office365-Filtering-Correlation-Id: 02b46208-a838-4e56-eb7f-08dca80e9dbc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?58vI6IXxXsHyDIh1Dnajpo2p6rcC9YDxj0VjeS7Wk5xfY3Gafo2SfN+tjkNA?=
 =?us-ascii?Q?C03Ofw/j+zJwfvTBHOfF9YHvW5z8lGZ+XH0kQeVGMn768NjCMgp/JHj2fUwG?=
 =?us-ascii?Q?eoeJZPrU7j8CIgwgFQrVGEQBxFdGJ5pM2Kjb11F/QKiEkDJNHZSDFr65oxEV?=
 =?us-ascii?Q?Zsdj767sg5nPnH5LiO6fCVoboCREhlde21PMsdUJ4SFG5VxnC5pv00D9uKOY?=
 =?us-ascii?Q?prKiV7Pd5O82dxVifL9p5EKtUQRkbdjYIOiZ+AX4I+YYz2VHobwJeTm2ZWQq?=
 =?us-ascii?Q?jL43Eo2tw1O9VBDPmigqMl13TCnIXo7pSEPBfvxjaN/rlGWIeMsRww9PWHch?=
 =?us-ascii?Q?II6jaHzsJeiXO1OJs8UHEnm+z/oqjXkODql50AGNhJyGnQmzwN4ExuyIrJqD?=
 =?us-ascii?Q?icShp59fJPmHAExzYTmEDz7tMNFRZvkc7fHeuxWvx4UW7prAuk2cD0tjeTwe?=
 =?us-ascii?Q?j4/t+GAJpaUlTu/68fyAs+793cAwPCMnUSXXjMBmICmRAOmVXdqeMshT7WTE?=
 =?us-ascii?Q?OkDzuF1zxOvUC9+I/EODEcWK5yXuMvMB0rUHeQ0XdJ+onYGvQHSX/rbOF9zF?=
 =?us-ascii?Q?mGQhp5IgtBrD+0heLRNsGd67OrqITV0Ksc2FKigmncLUkZdz42xaD1QwHx9Y?=
 =?us-ascii?Q?N2i8hSEy76xPQuqyblKLdMfimsl0ojBpBfQZkgCtEZ/0m6nTo//JnJ286O43?=
 =?us-ascii?Q?nRvA8CcziNRX71cYjSHUkKiSCyFzsp6DR6aMsmE05EDW9BDBU+pOuFsvuJ18?=
 =?us-ascii?Q?NxGLDN9orp3cUtAo7mgqidQ/C2AsfZ6qQCWI1YNJXz9Uq9kFr2T18ouJJHaI?=
 =?us-ascii?Q?fbgw1o0SNMSC7c9KNNXsXKbo9USpr966Wtlt4S7mjoqF52xY1hBQalk2b6ga?=
 =?us-ascii?Q?UqnAOVa864CrW+zeROg8ZpHs5KZj6xSiM6TBZhWxcXJs4il/jD9B3EqEaORQ?=
 =?us-ascii?Q?OEhN5+hu/haDemIbEcuKqC5QIsJBMfKgAwN9nmYqkwiaykChdO3haD2/LURJ?=
 =?us-ascii?Q?1TR6tnCuMY17+3GtWq1lAr2d+rrn/WrGFplXcZbDZ+mIgw4szNvUOfRiJ8hm?=
 =?us-ascii?Q?8i5mxlVK/YEHBPdi2H09Paq/FmUVia7Ssp2sd8BEpVBaGn9FLSoThEXaiuQ8?=
 =?us-ascii?Q?KAmsogZe3htrIwV6NL0OxFdX/oTn3z0GQ/sbWPbkowSR3fAyxFZJhtqpzH+Q?=
 =?us-ascii?Q?AnLStpez0gvax/OaddhnsPbk6gz+Rmghz4DnUhJZXPZdNJUAuNXUjd2bJ98n?=
 =?us-ascii?Q?zB4yFCI3e66I/Y2QZgpyf7MmNpGat0FhWimmEhAbGp2W7pc4qIRdzGWC/zPm?=
 =?us-ascii?Q?4qT7YyeeS4Wr3E+5VLpFFGyeJof2vva5VCyvpZbmS873NA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?11gZtG1GTTWT277Gl3a7msYXFRr4G6y22jm310QMg49dD1Oc24fO8ZlFmM5m?=
 =?us-ascii?Q?/9pcyUTNW25wz0B0xu2mNlcy8EI3hJV+3z5WPy2U33yUYqxxLdNmtWQsoJSn?=
 =?us-ascii?Q?MG7dJc1lZjZ2qtGSBONLd8PhIFn6sWLqxZht3uvtzfoWD2vTjYbSx1OBYh48?=
 =?us-ascii?Q?I3BCv3U5+f0zmwHyYAkT376FzfJWz1USg6ZPzimnFh89Z2Cu3r/HSz//MWkS?=
 =?us-ascii?Q?4LDoK0MeUu3Awl6m6XCH14rAWfl7y9JYetguLz7aqj/YEp4Se0NMqNG/5569?=
 =?us-ascii?Q?5ehuSVpfglYOKKtW9EmD+PSozE67yZ61+JJnb6i3QwEaBOwM0AivMVdq+lTv?=
 =?us-ascii?Q?NzY7nZXJTYXQwuOkOJhXBSOQOVSisCTNxMzMzb23InoEwkVSvugBdQakMe5f?=
 =?us-ascii?Q?6vs4Hx165usgNpVEIMdsRzYK9KteRGAoxcYYQ0VhbL/16rf2jbmLRTyVYvBi?=
 =?us-ascii?Q?TKdG3o+t48gijaejKsmZ/1KYTC0e9jtGY9z8fbefW903VvopGt5iKPNQ2onc?=
 =?us-ascii?Q?mz9dLqTI+IWZn/4z87vYyfu+mQAqNE5oh6TYwlqX6UM4D260EClFA2FY4phS?=
 =?us-ascii?Q?WBF7APo1vFXAquIRmXXhcOfFBwoz6pffRPZ+Pw2ILIn0gRdnToRZnLIMm4f6?=
 =?us-ascii?Q?KLCGYi24zlzxmYD3LgMFcnqKCnozMEhd/29hriM8804C08RmNLLeAqm7RCRD?=
 =?us-ascii?Q?cR0ZRgONSel0lGQ8bu8Sk4C3GHyb7kogoMgf3o3Spron41T3KOjGCWV5aqwI?=
 =?us-ascii?Q?nMsWbc5c7nxrCWJr2xMs4Dg9dPUkEBTamTadB1I6AufQ5Zme0L/wvwrGwvna?=
 =?us-ascii?Q?PjKFPrqLCcRf1zla7so9OsZGm36Q4wEcJu2JkGmwH4aejSeqsgOH7pL45MAV?=
 =?us-ascii?Q?rzJt59BCiZTFzf7LWCTCslGhnqhtUayAGTVNGTS0iWCGyr4IWvlfgG2B4xTS?=
 =?us-ascii?Q?61DNsnR/H+wq1rpjpCL8AS3vBLQZ0boo+qQMVSCsyF7X7oQRd2VMcHNiH10e?=
 =?us-ascii?Q?srhNH3M07dMvjQpTxVUIdCSTDq6dqhm9dYVeG+IsRndUCgJEzlAft9Jo9ctm?=
 =?us-ascii?Q?AsTCHu/9DxIqD7xOPivawH1dYS6YhaxMXTL4xj70PtajexkJG76vDOxoIkoN?=
 =?us-ascii?Q?22a80lSh8f7hCYCrhnLfyUpIJDlZIPWwmopgl6y+4XL2mFV9UPoTsPgllh6I?=
 =?us-ascii?Q?kJ8MndvNdcWF2K3og/o/hfb2x53ElV+eL0oZ0qqB4Jv2Cyo0bFMGK06Y4b3q?=
 =?us-ascii?Q?AojFUHzmlyoRZ6DkQ1QTw/f/XDkF6xh3qPfPVDPr7OcYfMCQjXuGvCP1xlCL?=
 =?us-ascii?Q?ro3lcrukwDtdAT1PA+MRWo8nUphgpXgX/RVHppSiXD7bQ4R9GEKIuWUT4jmj?=
 =?us-ascii?Q?iIWZJ46N3EsG8RtiL80WXoe3BKXMJOfdPrlObsToUPi8kLJAqO94DOOMKtPQ?=
 =?us-ascii?Q?upFwNycEDMalE+Ci4kRSmkqFdCzjVqIUuYvOpgKcpkJWK3253WyLQdLB3Yax?=
 =?us-ascii?Q?MjV5g+MThlYNNfnOyPiozJapQXHSO5dbn3wIV6Ac8vyDLvq94d0Qejw0wU1S?=
 =?us-ascii?Q?Xz8FhNOQtHEgHer4TwwthQl9XfrFRTyy70O/AXyY?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 02b46208-a838-4e56-eb7f-08dca80e9dbc
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2024 16:19:51.1758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AOpS8JCxkrEuKIhd1FTHHPtnbzNeuebqkzVWQiQgs+IyWTQ7pEdi6DECTOwReeEi0qy+WtYN43Ald5de9tRGjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5199
X-OriginatorOrg: intel.com

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-for-6.11

... to get the 6.11 updates for the libnvdimm tree.  The bulk of the changes
are to clean up W=1 warnings with one small update with the use of sizeof().

These have been linux-next without issue since 6/18.

Thank you,
Ira

---

The following changes since commit c3f38fa61af77b49866b006939479069cd451173:

  Linux 6.10-rc2 (2024-06-02 15:44:56 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-for-6.11

for you to fetch changes up to b0d478e34dbfccb7ce430e20cbe77d4d10593fa3:

  testing: nvdimm: Add MODULE_DESCRIPTION() macros (2024-06-17 18:43:08 -0500)

----------------------------------------------------------------
6.11 updates for libnvdimm

One small cleanup to use sizeof(*pointer)

A series of patches to add MODULE_DESCRIPTIONS() to eliminate make W=1
warnings.

----------------------------------------------------------------
Erick Archer (1):
      nvdimm/btt: use sizeof(*pointer) instead of sizeof(type)

Ira Weiny (1):
      testing: nvdimm: Add MODULE_DESCRIPTION() macros

Jeff Johnson (4):
      ACPI: NFIT: add missing MODULE_DESCRIPTION() macro
      nvdimm: add missing MODULE_DESCRIPTION() macros
      dax: add missing MODULE_DESCRIPTION() macros
      testing: nvdimm: iomap: add MODULE_DESCRIPTION()

 drivers/acpi/nfit/core.c           | 1 +
 drivers/dax/cxl.c                  | 1 +
 drivers/dax/device.c               | 1 +
 drivers/dax/hmem/hmem.c            | 1 +
 drivers/dax/kmem.c                 | 1 +
 drivers/dax/pmem.c                 | 1 +
 drivers/dax/super.c                | 1 +
 drivers/nvdimm/btt.c               | 5 +++--
 drivers/nvdimm/core.c              | 1 +
 drivers/nvdimm/e820.c              | 1 +
 drivers/nvdimm/nd_virtio.c         | 1 +
 drivers/nvdimm/of_pmem.c           | 1 +
 drivers/nvdimm/pmem.c              | 1 +
 tools/testing/nvdimm/test/iomap.c  | 1 +
 tools/testing/nvdimm/test/ndtest.c | 1 +
 tools/testing/nvdimm/test/nfit.c   | 1 +
 16 files changed, 18 insertions(+), 2 deletions(-)
