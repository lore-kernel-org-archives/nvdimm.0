Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.9
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795548570;
	b=pO11wYHHcou7UcIUAaEWgDLbH373fzRZmme7swPD+4BcBZ8jpxoL8Ip3UhHbwbUvB8fL
	 fJlrzLiCigaceqC6bZ6Y5YjY/Vh1tjTjilkMQcFCnHmRypOFoIX/Te/9N03KSzWfraAKr
	 +jhxkGp1ZB3XCgm6IdguwT5LMYUjsofLf5a3ldde8TOfCD2L5XJEsaj+qw1KTjbkjX8hX
	 aOX3Aw+IGu2ToCU12FmYTAQv+VpotYthQVG2yYjfY+Yx+h2hxnZaupMU4CJtceq4Kee4U
	 qJGSyoRRYvTzAh4nDj/45aS2ZsQYLLRhJhMKQO03x0srwvg3Gq6vx7cQ7oylgJ8nIJQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795548570;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:DKIM-Signature:Received:Received:Date:From:To:CC:Subject:
	 Message-ID:References:Content-Type:Content-Disposition:In-Reply-To:
	 X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=71u3oMQe8Uedj2DD46WOkbuq1mIC0W8xSnkW2yVakgM=;
	b=vRZ3xIZ2acb+RlO3Zp8mnFh7xqXs0PeDAXSH5tp3JBWUuWbOODUZGldMduU5/aPJAP9K
	 9Pjq4BKYviyU13ZHpcGbTbEZigb/XryzXzjABzHh/EeCp4neBv4Sz0ZXx6hu7Ik2vuqXc
	 ZwxJlIlVped1aVMC4sHwbvlzWSovxUIvmXEvJXRfog/GJR738SIlcMQ9vmlY5Y3LcG02d
	 L3WEiZNyvTuckoFDyJ1ncZ4tHa6NC29EpGCuVRPfD/Epq/n0NFG/Ama6384Tm5e6ahIwq
	 ISvzTdlHIVR4p2s6evMF32LGnkRhK1HApuM2LVh5XGIu+T9J9TXSWE4onL29azVjFHA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=WiCpbc13;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=NAwZgdA6;
	arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.9
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8398E606A690
	for <nvdimm@lists.linux.dev>; Tue, 24 Nov 2026 19:29:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8398E606A690
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=WiCpbc13;
	dkim=pass (1024-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=NAwZgdA6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795548570; x=1827084570;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=3w7T2uoZ9ejwIT/oVB9s9Ivg65STE7JaSTPDoQNnrXw=;
  b=WiCpbc13LGTOOZi0fFbm2HLXMQBBOQFNiFBeJRUA3Essss8N0SCnxk/0
   0Ql85RaqLL1t9SwwIHoavCDOwv+7Cnj4lJo5SSWWUY5IyWa/bQQ3Yo+TI
   NEpGIGmB2PGtkU9bO9Zz/HvZUelZwRRJuOz0C1jfni6QFXrIevF1AMSB2
   Rj9u4BwobZm5WIEdmWSnjck87FkqC9zIJutDcrckCYgkM6w68VXyKmDtE
   tWadF4KEI9Vox8zsG2R4ApvglatX/JQCE7bKIJMufKW0R5BUuqy/dq9ZL
   3Bftqk8LnjThFow17PKQT0cDV6h/MkrHbXiSh6ip6MGCs8DmRVmJDvvEG
   w==;
X-CSE-ConnectionGUID: jNyV6QLhSNSwGZoV14v3XQ==
X-CSE-MsgGUID: dmDd8KHuQyygdYweCMRoBw==
X-IronPort-AV: E=McAfee;i="6800,10657,11976"; a="4277137"
X-IronPort-AV: E=Sophos;i="6.27,231,1787036400"; 
   d="scan'208";a="4277137"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2026 11:29:29 -0800
X-CSE-ConnectionGUID: FtfsZakFQP+TsZUJdaLc1w==
X-CSE-MsgGUID: 7o+BCIs9QCii3YR0LoB+9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,231,1787036400"; 
   d="scan'208";a="11442847"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2026 11:29:29 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Tue, 24 Nov 2026 11:29:28 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57 via Frontend Transport; Tue, 24 Nov 2026 11:29:28 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.66) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Tue, 24 Nov 2026 11:29:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pLxv/U4OlqMfcG1Mn6fQrrI+FGN/77YB0vPDY5Ec8qP/BzWJ+1pTNSwGUoswGfybXTvEsjnslUqKGikKJcqTU6hzpzcKgWWI+BWUmU9MSI2uehWscQAg/mcEpp2ejiI/KZ8Ey/yibhS+ihJcikRzhRdMikczx9RT+Vs1WsXhpLk3gYrE88mrOO2J0P1ZxSskXSZrAzUZQMPFqdNk+P+UURJqhMR4Lf3gVgvsaokScp3FqKTTPkJN+CbG9xqJg+4saBlRAUiwtcz763WBJkM4N9IVm4OEVrWajD/mHsHt+TberllpCEj75cfLyWtkLHCtZGFGZtJP6djTvxay4sAR6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=71u3oMQe8Uedj2DD46WOkbuq1mIC0W8xSnkW2yVakgM=;
 b=HaYNf3h2F7esz0b6uvX8fy3waBMgQ4Z/DneeSXf+sJWQBjeOym4Ei5Vea9uLrAjTh4MQhJ/A7BesJ5ed9wFZ2qn2aT48UckYTLldHdNlod9zmvcYJODI+vg7sjolpugAeOnODe3WF432y+2jEKfcyQCxNDqY4KyGsY84SG6jFifBGW27lpQme3fae2hk3KBtca/kD1LYoO0RcQT9AUqQ1Ue9MtKI9LshyJIgoUo6+sKIMcMTycDYDkEDURarORfMFODRUvLZJt9IIdHH/N/SVFce70tetazRSlpZ1s3Lj0Uyw3vF6Iv6VnnnqXSmd1JDMDuVrJfPGAdAagT0X4pSuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=71u3oMQe8Uedj2DD46WOkbuq1mIC0W8xSnkW2yVakgM=;
 b=NAwZgdA6oPunUBEz488cXwzer2JUx4gRoO1tjMjfBXu1nhVx4ljeW+45jN4/8CrXKFxRaEv5JA72x6OA85IAzllI6XodyhyTU/KlMBE6t664EL0KrR67ajfdZrXEv2eBMO41CsNwVm9zc0LFBIi+QowFCzEECPq0wy47O4y1nEA=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SA1PR11MB7014.namprd11.prod.outlook.com (2603:10b6:806:2b9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.14; Tue, 24 Nov
 2026 19:29:25 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a1fc:97e0:329a:4aa7]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a1fc:97e0:329a:4aa7%6]) with mapi id 15.21.0662.001; Tue, 24 Nov 2026
 19:29:25 +0000
Date: Tue, 24 Nov 2026 11:29:15 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Anisa Su <anisa.su887@gmail.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Dave Jiang <dave.jiang@intel.com>, "Jonathan
 Cameron" <jic23@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>, Ira Weiny
	<iweiny@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, Fan Ni
	<nifan.cxl@gmail.com>, Li Ming <ming.li@zohomail.com>, Benjamin Cheatham
	<benjamin.cheatham@amd.com>, Gregory Price <gourry@gourry.net>, Richard Cheng
	<icheng@nvidia.com>, Anisa Su <anisa.su@samsung.com>
Subject: Re: [PATCH v1 04/14] cxl/mem: Introduce DC event handlers
Message-ID: <awXli-IrNpWrDC0t@aschofie-mobl2.lan>
References: <20261104230445.66625-1-anisa.su@samsung.com>
 <20261104230445.66625-5-anisa.su@samsung.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104230445.66625-5-anisa.su@samsung.com>
X-ClientProxiedBy: MW4PR04CA0215.namprd04.prod.outlook.com
 (2603:10b6:303:87::10) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SA1PR11MB7014:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f2c78a5-ae3d-459e-8c7a-08df4a613f82
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|23010399003|6133799003|22082099003|18002099003|56012099006|5023799004|4143699003|11063799006|261102123227099003|261026121527099003|261026140227099003|261022105027099003|261021121427099003|261009223027099003|261021123027099003|261022075727099003|261022113327099003|261028144727099003|10067099003;
X-Microsoft-Antispam-Message-Info: uQIzcqUPejHm39P6HLkWBkkhMR2VhDbMoH3dVT9uSbe3ZkpeK4TZIw7TVCxxiOnq7kcjreyvvwXRTXtQhdxNSsAgtSaFlZm+7w8JQR/7on5K3jXu2qLYCj2De+rR7pGsOerwR6PmRMjomK6Cx8KUGsqVfQiJKftVdJgqW1ab2MhUp3JSMzC23SqLGMZ1d4r/DTfKZ56zyyYA3glyTHL/b+kWvsdBORI6NcWTkdij2rx5f0YmTVbUWqtMIlzvanU8PQ2p2KvmYuhSRPbK3q9UyiBHoNeGY96qKO2p+Xy7CgyxNHNHoUNyv042xLNoKiT9YEQsNf+Pj+1+v1B3FY9eMP3lRMbeNHMZp55BcEx28wNW31w+Cx5YZ+vBnIO3Az0YpcbDcO62LCIvpDwqBQWgpdgYpltDzTF0mKEUyUVonJqzh3aq6vI50Fx6gp/ES8Sy4IS+1uaIK3dNrUOWhGDG3Dnprjuh+oHT8EfvyS62heUkqUtKum79248hao94oAEzjLTsTgY9enICnbCm0QukzI0Q0d5d+mg9NzsWiQWRfuPDhn/4NI6W6tMZC4oXjcdJ9gOPCeCZAJQaVUbCalg1ErvsrLxl5xZxjaZi/7gRnKmA3ScmhGt0eqdDJXcf1FML7Wy4dl99bvlfsyQsfBaGHIHe7+tz3NM4IdlfvcL5Z2M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(23010399003)(6133799003)(22082099003)(18002099003)(56012099006)(5023799004)(4143699003)(11063799006)(261102123227099003)(261026121527099003)(261026140227099003)(261022105027099003)(261021121427099003)(261009223027099003)(261021123027099003)(261022075727099003)(261022113327099003)(261028144727099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xBTyCL/OrxELD1LPCaOsPvdIvQSbJ1K1tPmWSfOpWM43DbCo4oe9Qfu0gFrm?=
 =?us-ascii?Q?D9qwN2MtZY4cO0WueoP8jJJpYrBCklud6JZ64eh5ESKdgfhyoGLfdRpJ9kuY?=
 =?us-ascii?Q?fNX0c9RBDsxEEQsUcln5W71Mr7yhgdMbe+XnrgWUyR+KwWcg1cF0fRTIXO0M?=
 =?us-ascii?Q?J1Nnnw2MBi0z0qcA3AIlahMrE6GrLu3Q4TC/XZ+JTkM8OAMGdO9AiX8F3KMI?=
 =?us-ascii?Q?JNqxKQ1/ZGypBcsNeuBH9hKrlKmf9Mhh9kaUELEwmoGwSF6O0TJtmynBwxc2?=
 =?us-ascii?Q?YrWzKtxHniEMR0BzbXPJ4PDTYc5/CgpTQjGkvIae6uhj9ti3H/OOh/J0FYzG?=
 =?us-ascii?Q?9MSZAksAYyd5OOrv3nx7lYBuE10LKHX9mZP7yDpuNYWb2vMyGsa0A2OeSDqY?=
 =?us-ascii?Q?xo/eX2iTsA3UsJRoIF56Ry6/cyRJamZRJQCxm8KOe+eFGhp3faXgKuFdGb0y?=
 =?us-ascii?Q?WuRq+OjC/2PL15Oqencc/q8eS+D++z9xHGDy+W5BFbqqeax0624ijo9Jo81f?=
 =?us-ascii?Q?l/GK7G4vQVTFvZLZzSeXjAGyVZPUmYXVu6d5JwXD2vjhl3zbKDLgPqBJbXJ6?=
 =?us-ascii?Q?rznpVLWzB4k4axwrOD6GmWRP5F/W3GDuExQ3iVfMjIGBfEFH2y2Sm9GdrdhV?=
 =?us-ascii?Q?EXTtZbnOXgD2p6BYPpIL78FPAKWbOZMGF21vAU6aUiHa1S1Uk8++o2fsqVdH?=
 =?us-ascii?Q?69LlXUN4J4lHru112kVZEvcNWTd10CUCq0tbchsgzDhWyBURUwR2ls4uMocn?=
 =?us-ascii?Q?HqRSt/4VkBTzGuCLcXplYZdafDvvpSh+jn9dEW33gREk5rM0hvwnPcfK2Lp1?=
 =?us-ascii?Q?ZoC3DxoMHxIaDd4skE0egouKw+txN39T6FLZBSgPFANh9Gz3yFmiM7c0V/i1?=
 =?us-ascii?Q?wn3hMJosmUXNP6K0ZAK/VY7MgrQ93ljCtjmmA7rmJPlVzKvQx639i2A4DoKE?=
 =?us-ascii?Q?0jg6hIp9xIP/fQYFH9OzXqIc91TZG+GtZ3s3kDJu1vRIUp7BxRceFaUWZFdM?=
 =?us-ascii?Q?QFHGoCSbojQF5Ng1fMzb3ih1MP1ab6oAsjhF9NQtG1ysiP7LbNP5zdMG+PyR?=
 =?us-ascii?Q?2AYsMBBjYaI6hF0ugbxij9WOBAWddE/8bh5prbCPCpFtNkvpivDzfySFsT3K?=
 =?us-ascii?Q?51WEBgccV+BmvRp/koTiJh8KIxXAWSBT5whUWOg58MPek25Y71QJOOxGL339?=
 =?us-ascii?Q?O9193sOkPIwSuaIFOkAwDE7hMVGl5mbRtL9iGuoNiAqDL/0NrR4nvZ8CcyFx?=
 =?us-ascii?Q?X6C8GdoNON3oaSjeEz+hSJrsXmOx02aT3x8I/Wwfz9NPKJkpvvqINGgEyUwG?=
 =?us-ascii?Q?5OxJ6vH4SP2BdjW6jlrHUe2ULTrYH1I9G9OrRA1+usQVSkUj8t5mrGfj3tSd?=
 =?us-ascii?Q?HfuYNSLkGFQc4YRF2hJeDePjv6NV0RPj5dzQMEsao4N++84dQFSAyNLYsM8C?=
 =?us-ascii?Q?j2sekL8tjOC9LQH7TgOTOw3ONd4upFyGyTTToxRHfayWwfbKGh62To8opH3I?=
 =?us-ascii?Q?+y/E1h19dbqlucJwyqlwxoIXYkUUNkiP/4s81hVmf2feZ6EhkPEYMa8uL57H?=
 =?us-ascii?Q?7NTd0IYNV2JwnguXMso5EmO+8bcSqj+S8YugZQtBbFKiWi2PF7PFNV0c/aHI?=
 =?us-ascii?Q?Z+zn3iiSxmMMtS4bmpYj0jIEiQC065l0G16JwXXsAhm+nT+v8Hu8CpkHie7z?=
 =?us-ascii?Q?qUfjyPwZ/Ki3PAuJNlwOQIhs5VcQ4r7AM6+brRWUggJYwU31ga0IYWVNP5Bc?=
 =?us-ascii?Q?TlD95Kyj+RmTeagXOS6uZoy+2XZBgDs=3D?=
X-Exchange-RoutingPolicyChecked: dq4331Cg5/I9yNMhgjtzBiY4eFr+LTBPXuvk8FtuJHT0GU88w8DPTp6c4aoSej2BMDrZv7jOn0OmU7QpaE3rf871lo6aakARB26dgeqArkeEa5kcoJ9Lgs4juS2V67LSkJe0ntnVf7uwb6pOWAW+2oOwe7xxMtal5krkJ1tnsvBmxKdrlL8Nf8rHSUkey7v0yr+3AivjfwA1Or0k1Mb3ZRi3IMQZbF7RSkVHoGeRgIkjPLOKgIK1o39armTpFjClVNoLr/luPBQWoy7rh9mr0/4wCZzNyS3wlyF4d491n+Heh9UsLMrfSbGiIcuBiDf2JXKYwoKea2xPmrU9936VHA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f2c78a5-ae3d-459e-8c7a-08df4a613f82
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 19:29:25.0311
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6IT9la/VBcJZuM/tXB8+n4jU0crv6pcUjvJl0UK8J0eH4wvZBJ7wV4pu+Y5SNdqTJMlEYn3Ovl52nOrpfN5AisHgGlrht3bR0o++Am6KEnA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7014
X-OriginatorOrg: intel.com

On Thu, Nov 05, 2026 at 08:02:28AM +0900, Anisa Su wrote:
> From: Ira Weiny <iweiny@kernel.org>
> 
> Add the handling skeleton for DC Add and DC Release events. Per CXL
> r4.0 Section 8.2.10.9.9.3, the host is expected to respond to one or
> more Add Capacity Event Record(s) with an Add Dynamic Capacity Response
> (Opcode 4802h) to acknowledge which extents the host accepts for use.
> Similarly, per CXL r4.0 Section 8.2.10.9.9.4, the host is expected to
> respond to Release Capacity Event Record(s) with a Release Dynamic
> Capacity command (Opcode 4803h), or to issue one that is not
> associated with any event to release capacity on its own.
> 
> The records of one operation can be chained by the More flag. Chained
> records are contiguous in the event log and share one event type (CXL
> r4.0 Table 8-229), so a single staging context, mds->dc_chain, holds
> the records of the open chain until the closing record (More=0)
> arrives and the chain is processed and responded to as a whole. A
> record that fails to stage, or one of the other type arriving inside an
> open chain, drops the chain: an add is refused with an empty response,
> a release is left for the device to retry.
> 
> This commit refuses all extents from Add Capacity chains and acks all
> Release Capacity chains. Subsequent commits implement accepting and
> releasing extents.

'This commit' and 'Subsequent commits' is awkward and not imperative
mood per submitting-patches.rst. Perhaps:
"Until the host tracks accepted extents, refuse all extents from Add
Capacity chains and acknowledge all Release Capacity chains."

> 
> Forced Capacity Release and Region Configuration Updated events are
> logged and ignored.
> 
> Based on an original patch by Navneet Singh.
> 
> Signed-off-by: Ira Weiny <iweiny@kernel.org>
> Co-developed-by: Anisa Su <anisa.su@samsung.com>
> Signed-off-by: Anisa Su <anisa.su@samsung.com>
> Tested-by: Wonjae Lee <wj28.lee@samsung.com>
> Tested-by: Junhee Park <jh9934.park@samsung.com>
> Tested-by: Heesoo Kim <habil.kim@samsung.com>
> ---
>  drivers/cxl/core/mbox.c  | 246 ++++++++++++++++++++++++++++++++++++++-
>  drivers/cxl/core/trace.h |   3 +-
>  drivers/cxl/cxl.h        |   9 ++
>  drivers/cxl/cxlmem.h     |  46 ++++++++
>  drivers/cxl/pci.c        |  20 +++-
>  include/cxl/event.h      |  37 ++++++
>  6 files changed, 353 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index 13a68f5cef69..3acf5ace48db 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c
> @@ -5,6 +5,7 @@
>  #include <linux/ktime.h>
>  #include <linux/mutex.h>
>  #include <linux/unaligned.h>
> +#include <linux/list.h>
>  #include <cxlpci.h>
>  #include <cxlmem.h>
>  #include <cxl.h>
> @@ -1100,6 +1101,237 @@ static int cxl_clear_event_record(struct cxl_memdev_state *mds,
>  	return rc;
>  }
>  
> +static int send_one_response(struct cxl_mailbox *cxl_mbox,
> +			     struct cxl_mbox_dc_response *response,
> +			     int opcode, u32 extent_list_size, u8 flags)
> +{
> +	struct cxl_mbox_cmd mbox_cmd = (struct cxl_mbox_cmd) {

Is that cast needed in the initializer?

snip

> +static int cxl_send_dc_response(struct cxl_memdev_state *mds, int opcode,
> +				struct list_head *extent_list, int cnt)
> +{
> +	struct cxl_mailbox *cxl_mbox = &mds->cxlds.cxl_mbox;
> +	struct cxl_mbox_dc_response *p;
> +	struct cxl_extent_list_node *pos, *tmp;
> +	struct cxl_extent *extent;
> +	u32 pl_index;
> +
> +	size_t pl_size = struct_size(p, extent_list, cnt);
> +	u32 max_extents = cnt;
> +
> +	/* May have to use more bit on response. */

Huh?
Is this trying to say: "A list larger than the mailbox payload is split
across responses chained with the More flag"


> +	if (pl_size > cxl_mbox->payload_size) {
> +		max_extents = (cxl_mbox->payload_size - sizeof(*p)) /
> +			      sizeof(struct updated_extent_list);
> +		pl_size = struct_size(p, extent_list, max_extents);
> +	}
> +
> +	struct cxl_mbox_dc_response *response __free(kfree) =
> +						kzalloc(pl_size, GFP_KERNEL);
> +	if (!response) {
> +		struct cxl_mbox_dc_response empty = { };
> +
> +		/* An empty Release DC is invalid (CXL r4.0 Table 8-352) */
> +		if (opcode == CXL_MBOX_OP_RELEASE_DC)
> +			return -ENOMEM;
> +		/* Refuse all extents rather than stall the device. */
> +		return send_one_response(cxl_mbox, &empty, opcode, 0, 0);
> +	}

Should this fallback report the failure to the caller?  When the empty
Add response goes out, the function returns 0, so caller can't tell
that the extents it asked to accept were refused.

Sashiko raised seemingly valid questions here also.

> +
> +	/* Set __counted_by to capacity before populating; reset per response. */
> +	response->extent_list_size = cpu_to_le32(max_extents);
> +
> +	if (cnt == 0)
> +		return send_one_response(cxl_mbox, response, opcode, 0, 0);


Should this refuse an empty Release DC, like the -ENOMEM branch above does?

Could the helper count extent_list itself, rather than trust cnt to match
it?  A short cnt would let the loop below write past max_extents


> +
> +	pl_index = 0;
> +	list_for_each_entry_safe(pos, tmp, extent_list, list) {


Nothing is removed from the list inside the loop, so a plain
list_for_each_entry() is OK.  


> +		extent = pos->extent;
> +		response->extent_list[pl_index].dpa_start = extent->start_dpa;
> +		response->extent_list[pl_index].length = extent->length;
> +		pl_index++;
> +
> +		if (pl_index == max_extents) {
> +			u8 flags = 0;
> +			int rc;
> +
> +			if (pl_index < cnt)
> +				flags |= CXL_DCD_EVENT_MORE;
> +			rc = send_one_response(cxl_mbox, response, opcode,
> +					       pl_index, flags);

I think another mailbox command can land between the More-chained payloads?
Each send_one_response() goes through cxl_internal_send_cmd(), which takes
the mailbox mutex for that one command only.

Asking because of this in the spec -
For Release Dynamic Capacity, Table 8-352 says "Payloads grouped this way
shall be submitted with no unrelated records between them and shall
contain the same mailbox opcode", and 8.2.10.9.9.3 calls the Add response
payloads "back-to-back".  This only matters once the list is longer than
one payload, which is about ten extents with a 256 byte mailbox.

And, that makes me wonder if that was required in other command where
we are chaining multiple payloads. Making a note to take a look!


> +			if (rc)
> +				return rc;
> +			cnt -= pl_index;
> +			if (cnt < max_extents)
> +				max_extents = cnt;
> +			pl_index = 0;
> +		}
> +	}
> +
> +	if (!pl_index) /* nothing more to do */
> +		return 0;

"nothing more to do is" leftover narration. Drop that comment.

snip

> +static int handle_dcd_chain_event(struct cxl_memdev_state *mds,
> +				  struct cxl_event_dcd *event)
> +{
> +	struct cxl_dc_event_chain *chain = &mds->dc_chain;
> +	struct device *dev = mds->cxlds.dev;
> +	int rc;
> +
> +	/* Chained records share one event type (CXL r4.0 Table 8-229) */
> +	if (list_empty(&chain->pending_extents)) {
> +		chain->event_type = event->event_type;
> +	} else if (chain->event_type != event->event_type) {
> +		dev_warn_ratelimited(dev, "DC %s record inside an open %s chain; dropping the chain\n",
> +				     cxl_dcd_evt_type_str(event->event_type),
> +				     cxl_dcd_evt_type_str(chain->event_type));
> +		cxl_dc_chain_abort(mds);
> +		chain->event_type = event->event_type;
> +	}
> +
> +	rc = stage_pending_extent(&chain->pending_extents, &event->extent);
> +	if (rc) {
> +		cxl_dc_chain_abort(mds);
> +		return rc;
> +	}

Same as Sashiko and Jonathan here.  The abort on a record of the other
type above can leave a tail the same way.

snip

> +static void cxl_handle_dcd_event_records(struct cxl_memdev_state *mds,
> +					 struct cxl_event_record_raw *raw_rec)
> +{
> +	struct cxl_event_dcd *event = &raw_rec->event.dcd;
> +	struct cxl_extent *extent = &event->extent;
> +	struct device *dev = mds->cxlds.dev;
> +	uuid_t *id = &raw_rec->id;
> +	int rc;
> +
> +	if (!uuid_equal(id, &CXL_EVENT_DC_EVENT_UUID))
> +		return;
> +
> +	dev_dbg(dev, "DCD event %s : DPA:%#llx LEN:%#llx\n",
> +		cxl_dcd_evt_type_str(event->event_type),
> +		le64_to_cpu(extent->start_dpa), le64_to_cpu(extent->length));
> +
> +	switch (event->event_type) {
> +	case DCD_ADD_CAPACITY:
> +	case DCD_RELEASE_CAPACITY:
> +		rc = handle_dcd_chain_event(mds, event);
> +		break;
> +	case DCD_FORCED_CAPACITY_RELEASE:
> +		dev_err_ratelimited(dev, "Forced release event ignored.\n");
> +		rc = 0;
> +		break;

Same as Jonathan here. Once "cxl/extent: Handle DC Add Capacity events"
tracks extents, the host also keeps tracking a forcibly released one.

Should forced release at least drop the host's tracking of the named
extents?

snip


> @@ -1136,9 +1368,13 @@ static void cxl_mem_get_records_log(struct cxl_memdev_state *mds,
>  		if (!nr_rec)
>  			break;
>  
> -		for (i = 0; i < nr_rec; i++)
> +		for (i = 0; i < nr_rec; i++) {
>  			__cxl_event_trace_record(cxlmd, type,
>  						 &payload->records[i]);
> +			if (type == CXL_EVENT_TYPE_DCD)
> +				cxl_handle_dcd_event_records(mds,
> +							     &payload->records[i]);
> +		}
>  
>  		if (payload->flags & CXL_GET_EVENT_FLAG_OVERFLOW)
>  			trace_cxl_overflow(cxlmd, type, payload);


Spec 9.13.3 says "If the Dynamic Capacity Event Log overflows at any point,
the host shall utilize Get Dynamic Capacity Extent List to retrieve the
current list of host accessible DC blocks." 
Here the overflow is only traced. Is that OK?

snip


> @@ -1781,6 +2020,11 @@ struct cxl_memdev_state *cxl_memdev_state_create(struct device *dev, u64 serial,
>  	}
>  
>  	mutex_init(&mds->event.log_lock);
> +	INIT_LIST_HEAD(&mds->dc_chain.pending_extents);
> +
> +	rc = devm_add_action_or_reset(dev, clear_pending_extents, mds);
> +	if (rc)
> +		return ERR_PTR(rc);


Does unbind leave an open add chain without its response? ie device 
doens't get expected response (Table 8-229). Maybe an open add chain
can be refused before teardown instead of just freed.

snip

> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> index 35268d1c387c..c88de7cb65d1 100644
> --- a/drivers/cxl/cxlmem.h
> +++ b/drivers/cxl/cxlmem.h

snip

>  		  0x40, 0x3d, 0x86)
>  
> +/*
> + * Add Dynamic Capacity Response
> + * CXL r4.0 Section 8.2.10.9.9.3; Table 8-350 & Table 8-351
> + */

also used for Release Dynamic Capacity, maybe add to above comment

snip

>  
> +/*
> + * Dynamic Capacity Event Record
> + * CXL r4.0 section 8.2.10.2.1; Table 8-221
> + */

check that spec reference above

snip


> diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
> index 3ed7c3e70042..29541b8f79f2 100644
> --- a/drivers/cxl/pci.c
> +++ b/drivers/cxl/pci.c
> @@ -510,12 +510,20 @@ static bool cxl_alloc_irq_vectors(struct pci_dev *pdev)
>  	return true;
>  }
>  
> -/* Event logs the driver drains: standard logs when native_cxl */
> -static u32 cxl_event_drain_mask(struct pci_host_bridge *host_bridge)
> +/*
> + * Event logs the driver drains: standard logs when native_cxl, DCD when
> + * supported.
> + */
> +static u32 cxl_event_drain_mask(struct pci_host_bridge *host_bridge,
> +				struct cxl_memdev_state *mds)
>  {
> +	u32 mask = 0;
> +
>  	if (host_bridge->native_cxl_error)
> -		return CXLDEV_EVENT_STATUS_STANDARD_LOGS;
> -	return 0;
> +		mask |= CXLDEV_EVENT_STATUS_STANDARD_LOGS;
> +	if (cxl_dcd_supported(mds))
> +		mask |= CXLDEV_EVENT_STATUS_DCD;
> +	return mask;
>  }

Who drains the Dynamic Capacity log once cxl_dcd_dsmas_missing() disables
DCD at endpoint probe? Should the log keep being drained, refusing adds,
or should the DCD interrupt be disarmed when DCD is disabled?

snip to end

-- Alison

