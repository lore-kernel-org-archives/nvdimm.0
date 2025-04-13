Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9F41A5B85
	for <nvdimm@lists.linux.dev>; Sun, 13 Apr 2025 22:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744584746; cv=fail; b=Y0m9jXLLXKZJ1yb30AtZf+3+Ln+Roz2bNhs0+hQN3PddUaO+VjgsgXMOVlQgJZW3+rYZ9V1CUBXV406rNvLl/wFWDXhYcl8ObhM5ndG4tPdPFGmae78c/khWd8G/+ecxuS9AKU3DzJ4AQYzQxbyRDZ3oxm4maTraIQxAk2KuG3c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744584746; c=relaxed/simple;
	bh=YpHLE0FN1k1Z9JdxdTPtJN/f7uJ44Q/rHM2lVf7j/Bk=;
	h=From:Date:Subject:Content-Type:Message-ID:References:In-Reply-To:
	 To:CC:MIME-Version; b=BtJcbrWR6IC5YMCh3kyK+yLCDmiqTHPLprqiC/0TLcGJw301N8oA4CNwuCKf3jgKkiJTlqdiw8jAyB9HKYVK1e68IPBVyyrXNn0u5PoHq/Y8UMsC262BHvLccUIydEdf4mYsBuCkyC7mzDEQZSH7EafTU7k+cErcQ3NV7GW93d0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BNqZYJmd; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BNqZYJmd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744584742; x=1776120742;
  h=from:date:subject:content-transfer-encoding:message-id:
   references:in-reply-to:to:cc:mime-version;
  bh=YpHLE0FN1k1Z9JdxdTPtJN/f7uJ44Q/rHM2lVf7j/Bk=;
  b=BNqZYJmdjlvw5ecBlC1WTEwYdcajNJ+QcAmODnmyWzUbY3BY0lKg95iu
   G4cm4ECtyOq1EHgJoUXsR0F9gRiLraUzkNA2Yy2CLlq7BYZqOJyqBe/ne
   os0rok+nWwvD/w0+m7Bj8Qat/a2YykBsozfad9zQh2ZV8nKJPI0D0Wc+F
   WjepRp7HYrW05MNf6dDPtSWDRz7CYLrSrJfosgOECtRted9uPhufUp3iS
   8ibFFJhmCTCqDLXyqZJZQ9cp7VkpvY4Vto79NX182nT5By/AhnX/bL8WE
   L+qjclej/+ElkhUxmGZpNCvgqBdTIla1u6+DEOODSCy5zeFg62RWh1P53
   Q==;
X-CSE-ConnectionGUID: 9md0sIugRw2S/KUQc6V/Vw==
X-CSE-MsgGUID: MiBhGGpjSuurbUuS1sYPcQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11402"; a="71431133"
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="71431133"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2025 15:52:20 -0700
X-CSE-ConnectionGUID: 0odosYkAQUWvdJfiPQxaXw==
X-CSE-MsgGUID: 8gWCtrdFSfeXaAD5DVL8qg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="134405569"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2025 15:52:20 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Sun, 13 Apr 2025 15:52:19 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sun, 13 Apr 2025 15:52:19 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.43) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 13 Apr 2025 15:52:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RzEm3Y/tjECJNYGRzuB/WlY6ju5pz21KTxFYaULBhqPqwiTMprdNLsAyN5pwkYcHR1fkHA8MZLOpwb6bGaqr6EGWUlvlQHeoFs7icvCaPBEbCLtMrGySv5h1nWErLAR5Luky67LKunDIVp10P0wuo75hNXvNX77COuh/5mG7MAM9VC2CAHB6UVwBuDmC7bzvYqfluf4pH4n/CRkYFOQjstgpJ/JQmLQaNvjC6cVdu/AcfAH2GVs+0P/sqP2HfJVHumccwRFsGoIoyYiOlN9vqCm2IdB3QcHol+6IT1GVV84R6aGFrLr/y1dQeKduOyxWHmF4e/Vgf1Le/GxoU9YHjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XRcH1hlq1+QlfAeeyAqjDhwx1fs/vkBOfIBaucUZuys=;
 b=ERFaKyw3KZbxg9zCW2JA5haoUWJGfhBTpeJhNewvY3D6glrQAc2Y2G6IpwbVufPIgVZQ0tXrBUjkE9in3Ygg7Y4uZ6RYKc5CRIak4hc/SqpsnutMXKgJybeOEbJsdjIF4Ec6OKkmk41dwv0ac0GdQypsOX1XT0/mLjiD/MLKEfrnWfHLfv/+xtz4wwP3pB0AHZ/E2Brd/lYO13VarcbJaAj0rglEhVt0wa7DQve+9rLDsdnyN7f9xgSMF3SFF9e4g2SMHeyu+LEtKp0KGvkAWRZrMYIsWgfuK+XaMoUNuEyPjlMP2TUWxAg/Uc2HUSVFIZXqbK//L3SWJBxUd+sZfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW4PR11MB6739.namprd11.prod.outlook.com (2603:10b6:303:20b::19)
 by PH7PR11MB7003.namprd11.prod.outlook.com (2603:10b6:510:20a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.33; Sun, 13 Apr
 2025 22:52:07 +0000
Received: from MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24]) by MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24%4]) with mapi id 15.20.8606.033; Sun, 13 Apr 2025
 22:52:07 +0000
From: Ira Weiny <ira.weiny@intel.com>
Date: Sun, 13 Apr 2025 17:52:23 -0500
Subject: [PATCH v9 15/19] dax/region: Create resources on sparse DAX
 regions
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20250413-dcd-type2-upstream-v9-15-1d4911a0b365@intel.com>
References: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>
In-Reply-To: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, "Jonathan
 Cameron" <Jonathan.Cameron@huawei.com>
CC: Dan Williams <dan.j.williams@intel.com>, Davidlohr Bueso
	<dave@stgolabs.net>, Alison Schofield <alison.schofield@intel.com>, "Vishal
 Verma" <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	<linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>
X-Mailer: b4 0.15-dev-c25d1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1744584735; l=29379;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=YpHLE0FN1k1Z9JdxdTPtJN/f7uJ44Q/rHM2lVf7j/Bk=;
 b=k/yUghpVT/FSxdfIS8LZxy+Q5S8lQQ082S2i3PUvR6yby79FqvoYhhODCbL31YpqeR6F69P/p
 NJN/Ic5/jt0ALFQ4H47FCt2mVOx/NmEAkUEbv9CYTD4eTn5Fhv90oMa
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=
X-ClientProxiedBy: MW4PR03CA0227.namprd03.prod.outlook.com
 (2603:10b6:303:b9::22) To MW4PR11MB6739.namprd11.prod.outlook.com
 (2603:10b6:303:20b::19)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB6739:EE_|PH7PR11MB7003:EE_
X-MS-Office365-Filtering-Correlation-Id: 03dc5a8a-60d2-456a-fd17-08dd7addd11d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SlI4RWNvVDdrWU1WZGxGeHR3bXdEV1pqaVpxS2ZpQmx5U3cxVytxcHR2S2VP?=
 =?utf-8?B?d0E5YU85NVVNMmRrS0JZeHlCakxHSkdKcG1lYWlUU1A1Wlg3YWlSazNRVGRM?=
 =?utf-8?B?dlpPTEZBRzBSZVZlYzVUdDc1SGM4eWh6YnZKY0gvYjhNVktteGFDUTR2cnJU?=
 =?utf-8?B?dnExV3FiMU9oaW1LVDJJWU9Ia3lxM3VmWXQ3Wkx4c0xyWG1iN29lSkdmaUly?=
 =?utf-8?B?U2dWNGF2UXNhKzJSdEw5Q25pNnlJRGZ6TnNuNG9kNWU5QjZLVU9qOXRGdjRu?=
 =?utf-8?B?OXVwaVptcWphSnU4d0owTTcxczE0WlJoTys3WlhhZmFvRkxYVEVNZDlVdzNs?=
 =?utf-8?B?R3RxMkF2UWFyYWdmcGJuZnlDUURJSXRIa3RvdVlHK1I4KzgwSDJhelRxWUEr?=
 =?utf-8?B?czRFSExJV21YUzdmVUNCZDBBaTk0OGJGeS84S1czaVhPcWcyWTh6aXY3NHd1?=
 =?utf-8?B?Y1ZrL1B3MzRmbXBDdEd4bElYYnJqNVNEN0xhUUI1Z1pkTU4vd29EdHZXRStL?=
 =?utf-8?B?U3l6MTZVMVJFcExoRkhPQi9iZ1JzamlkbnZPNVBvRWRvRVZ2V2xzempQbkRO?=
 =?utf-8?B?ZjNNTkZGdXZ5WlhaREk2Z3BVb0o4Qy9pUGx3VE9mK3NiSWIwNTErYU1JbW1o?=
 =?utf-8?B?VVBuMmlIQWtaenhPTHlsSTNHTWRiYXdXZDFZS0NiR2lKUVNEOG9QMDZtYW9C?=
 =?utf-8?B?QkxPSlh2Sk5JVlltWXAvRUhReGJWV0RUMkJhbEhxL2xWY0JDcnNRZEhKNHlw?=
 =?utf-8?B?ckNPdU5neXM5cFFZQ3NNbytPM1pORDNhWEJjVU1vZWtaVnEycGhZdkM3a1FC?=
 =?utf-8?B?alFVbjhGWnRYZW0rYmRoNVdkQzEzZ0QvblRBWjJXelFNd2Y5WjJiRFMweGov?=
 =?utf-8?B?R0xqY21PUHE5ZFp3V0J4QXRqTFhvMGtXR2FrNkJGWVpIOHA5MHBmaXErYW1m?=
 =?utf-8?B?YzBkQ1hNYkJEWndNWmpTb1BFQ25na2xUZXRoNVJkRW1Td202QVZtRTQ3cFE4?=
 =?utf-8?B?RnB5TnNtRW8yUy95NlFhM05DTmR6ZEx2KzJlU0FwVjNGeFlwZFlPbmc3Vm1X?=
 =?utf-8?B?ejVUNkZEWnhGcGc3S3lMdG9tM1RLUjdWRWVjNjMwRThtR1dReWRkMm8vMHdT?=
 =?utf-8?B?YVZaUXpNQm9TYWU4S0NDNk00RkxPeVR5djIxZ2tqSE1ZQmJvSVcwVllDWEVs?=
 =?utf-8?B?b2kxQ0VtWU5LVTlWeGdRdmI3ejlwVEVNOGlFb2huelV5blJjSEhsZmIzdTRq?=
 =?utf-8?B?UW5uVWpvVzhlWUJJRHZkZUdpZzVkUXlJRW1POExySHNIVStFS2pQOUdCanU5?=
 =?utf-8?B?MzNYQ1NRa3p5SEZYQjlkUWVrZTRoK0tkQjJDSVBnZ0NrcDFjZU55UmJVeWkz?=
 =?utf-8?B?VmtBenFoWWpsRmsxRkMydU9DdHJCU1lEUGdZVGpOaFZsMnVMbmZxZ0haVXR4?=
 =?utf-8?B?MU9YUTJuSUNyY0g4akl0dnh1SWdnY3huQzM3dGdKN0orN2hDRUlmVXo5L0w0?=
 =?utf-8?B?ZlRDRmpzMXRpd3lzQThhQnlQR3Nmc25GbHNCeFpqbFU1cnR2WmFOZTVaQUpl?=
 =?utf-8?B?dDRCSW9sT08yZi8vNFRGb3QxTzFaeVhEenEzMjB0SFpSbVZXRXdiNGNXZUxZ?=
 =?utf-8?B?bDlJMmpxaXdia1lGc1VoZDV0Y0JOK0hENTBnMy9qL0xCZmJxSm9hbDhteCty?=
 =?utf-8?B?anF5Q2YzcTlHRk11LythdEVRczdVYmwvbjEvUmc1MTkzdW5oaTJTRkorMHVx?=
 =?utf-8?B?dEVmVWlQZzcxakgrQXRCcFNBZk93OTZMVEtCTnA4akRpR0JycWp3WlEwZ0Z4?=
 =?utf-8?B?S2t2SElMY1FIdytydExHK29hMGg2dDdoWW1xUG0xOWpnUUFEMGprS3BzMGJI?=
 =?utf-8?B?dU1rcFpWTnVudU1sWEZ3QTJWVkpqWDdDMzBiSVpDSlJtREZnMGs1eXBDR2ds?=
 =?utf-8?Q?SNBqtwnfZWA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6739.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dWZkV0N6WEZMREJsejZKUWtPUHpzWmhQNWlUajNBMFRRNkJ0VmJzY2tHcHEv?=
 =?utf-8?B?QlhZVDh6eTZkSFkvdWNLUFpHWGhqOHJ2bHpQZWtyVEZlZTF5NDNrTHdaWG9E?=
 =?utf-8?B?dGlqVjhnSFl1eWk2aFFrY2hpSDhzOHp2aGlvMzI5b0xtVVRlSkNDL0ZjWXNU?=
 =?utf-8?B?Q2xmNm5XNGN4NGZUZWlib1dHOEFrMWZUaTErcW5QRTVLaEloOXMvb2NIdGR3?=
 =?utf-8?B?SkVYanNUNlR1VEJBUnBJWTBJekdxYm5nVmNIWEppQklqZDVhSEFtNnBJL3Z3?=
 =?utf-8?B?VGhZRFVvT3dFMDRJams2dFYxS2hVcWRDMXBrTG1Lbzd1UE9jaXNtZW1sL1lz?=
 =?utf-8?B?cVFDOUt5THc3VVcxYXlzSW0wZStQa2JVcGl6R21FNCtWNHViNXNuU3dIclFm?=
 =?utf-8?B?cmFUbHZSZUpSSWU5RHdQVmVTZTEzMnBoWEpEQlIvTk5yUE1FVWRQTGFITks5?=
 =?utf-8?B?V3hLZ2FaaDZrWmJQWGVveGZpZjNzU2Jaa2JBNXFCM0JPL2VWWE9Qb3NmNUlU?=
 =?utf-8?B?ckZDR0hjbDBiNVIyT28xUCs5b1FqS0tJM212dlFZbFdxZmxEMlFWMmEwZm12?=
 =?utf-8?B?eFRNMFByYTU3YnpjT1BuUVExOGRxUWx1NkZ1Y2d6c1ozWExmcy9KYWlEL04w?=
 =?utf-8?B?YXhDUERiYzRpUXYycnJGeFpyMmY1SzJRTTdvWldOeFNtaEswVU53YWNDRnhM?=
 =?utf-8?B?Q1V3Y0FURXM4TU9aL0tzTUhsZENJQnc3VXVybk03VTBMd2N4RGwzOFN3dXdS?=
 =?utf-8?B?UE1sUDQzejMyVE81enBIS3N2SnZQaTQwZW5PUHJiWCsvSmtKSUZ2Nk1XK1Ir?=
 =?utf-8?B?RUNJSFYwRWtJWGNTd0tscjgydW1jZWVmWGxwdnYxa1hIOVNuWk1rWnNMdisr?=
 =?utf-8?B?MU5Rd1BqbTFOQWs1UGFCL1M4V01mdThTYTJRdkN1bUtIVThvQUQwUEF5bFgz?=
 =?utf-8?B?Ri9pN3FqZWNhMnU3TVd0amJ3VzhoODRnejFYejZlaVNhZVZmSHdlTUpLRHBj?=
 =?utf-8?B?bGdPQnlLd3BheTQ5M0I5OVQ4ejlyUVM2TWZkRThQK3hqM0lKS244S3I5ZE1a?=
 =?utf-8?B?M3dGSFQ3a0hlem84aFZodmU4NjMrRlpReHZzU0Zmdjc5TlNvWXVpaU55UTJU?=
 =?utf-8?B?SWpnam9yeXlSUFZycjFLYlJVdEpoWDZ0S283VmZwODhDdW9TaklBRDlSVHZk?=
 =?utf-8?B?a2NyWUs1NjI0ZWNvSnc5aWpSRDBDTjcvYkJJQk1XT3VqYm5LWHR3c1hXM1lK?=
 =?utf-8?B?aDVSR0tuTkVqRUlUY1M0bEJTQm0rSGNLMkdTS1UxWFhqRjRyN29ycHNLNG8r?=
 =?utf-8?B?dXJucEc0Rzh4bFlMNXlzcEFwV2hjOHhsSTkvdG1oWDdHZXJ4WEpIdEdjVE5K?=
 =?utf-8?B?ME9jT1A1TVljcW4vY2tETEZaMWhzbmpZRkttaVd1ckRpb1phZEc2S0Q0aElO?=
 =?utf-8?B?RFNTQ0U5ZlNKa2xlUGtzTk9PaGRnUkFFNkZZVGQ1eEpSMDN3amRURmZhQm4r?=
 =?utf-8?B?NEc3c0xYeEdOL1hxZHlISDBYak5nQlFNOXBpaU9BaWs3TDYydFh6NDBVbGJt?=
 =?utf-8?B?SGFwNHp6OUYxSXJZR080VEFZQ3ZtK0FqWHp5WC94OFJRbHVhNm4vd2RMWDRl?=
 =?utf-8?B?Tmc0VjVWemQxQmtmYlpROU9CWDFPaGlHQndRbmdOTmJwWG93UHkxSlVXdGlQ?=
 =?utf-8?B?WCtGdUpabUcxTWlPdm5PQVRaMjA4NEFzS2NwVGFkK2N4TlVreE9sNTBhUGwr?=
 =?utf-8?B?T1dOaVBCNWFNNVpwV0VlNXFWSzB3TmViam5GTk9xdHRjYzI3RXRsUERBcWVm?=
 =?utf-8?B?dzdBMkVxZTlwWnVLWk1lYVc5VjNsTHNNRkhLYXV5R1pvV0E4NTNjbmZRWCti?=
 =?utf-8?B?ak5WeGNFU1VjL3p3QVlMYTVyeERhbHhRNzNxQ2wxZGlhTERUWWRlZlBjMFdw?=
 =?utf-8?B?aXp0ZHdCUkxGT2FBQzhJUlc1T1ZrdXRhR1VyaGV3VUI3KzFIUFk0VTZDU2wr?=
 =?utf-8?B?VFMyczg4SGp5N1VzckNnOVd6UUVLYmRJS0pjWGpubE1xbENQQmxWOW16WGtQ?=
 =?utf-8?B?OGVjZzh5OS9FekNUNDV4R2hManM3bS9lSUFiTjM3YzFYcUR6MDM4UEVQVW1F?=
 =?utf-8?Q?FZVkZ5jUZjrG/VGRaA7eD1sbU?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 03dc5a8a-60d2-456a-fd17-08dd7addd11d
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6739.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2025 22:52:07.5027
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xJzjVKews76ExOKtU9a0AfPekF38jO09MaY+ooT8PYsbYmqWvjWPYRvIqdMvoEeam3wLPonrY22my9e3MHeXxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7003
X-OriginatorOrg: intel.com

DAX regions which map dynamic capacity partitions require that memory be
allowed to come and go.  Recall sparse regions were created for this
purpose.  Now that extents can be realized within DAX regions the DAX
region driver can start tracking sub-resource information.

The tight relationship between DAX region operations and extent
operations require memory changes to be controlled synchronously with
the user of the region.  Synchronize through the dax_region_rwsem and by
having the region driver drive both the region device as well as the
extent sub-devices.

Recall requests to remove extents can happen at any time and that a host
is not obligated to release the memory until it is not being used.  If
an extent is not used allow a release response.

When extents are eligible for release.  No mappings exist but data may
reside in caches not yet written to the device.  Call
cxl_region_invalidate_memregion() to write back data to the device prior
to signaling the release complete.

Speculative writes after a release may dirty the cache such that a read
from a newly surfaced extent may not come from the device.  Call
cxl_region_invalidate_memregion() prior to bringing a new extent online
to ensure the cache is marked invalid.

While these invalidate calls are inefficient they are the best we can do
to ensure cache consistency without back invalidate.  Furthermore this
should occur infrequently with sufficiently large extents that real work
loads should not be impacted much.

The DAX layer has no need for the details of the CXL memory extent
devices.  Expose extents to the DAX layer as device children of the DAX
region device.  A single callback from the driver aids the DAX layer to
determine if the child device is an extent.  The DAX layer also
registers a devres function to automatically clean up when the device is
removed from the region.

There is a race between extents being surfaced and the dax_cxl driver
being loaded.  Synchronizes the driver during probe by scanning for
existing extents while under the device lock.

Respond to extent notifications.  Manage the DAX region resource tree
based on the extents lifetime.  Return the status of remove
notifications to lower layers such that it can manage the hardware
appropriately.

Based on an original patch by Navneet Singh.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes:
[iweiny: convert range prints to %pra]
---
 drivers/cxl/core/core.h   |   2 +
 drivers/cxl/core/extent.c |  83 ++++++++++++++--
 drivers/cxl/core/region.c |   2 +-
 drivers/cxl/cxl.h         |   6 ++
 drivers/dax/bus.c         | 246 +++++++++++++++++++++++++++++++++++++++++-----
 drivers/dax/bus.h         |   3 +-
 drivers/dax/cxl.c         |  61 +++++++++++-
 drivers/dax/dax-private.h |  40 ++++++++
 drivers/dax/hmem/hmem.c   |   2 +-
 drivers/dax/pmem.c        |   2 +-
 include/linux/ioport.h    |   3 +
 11 files changed, 411 insertions(+), 39 deletions(-)

diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index 1272be497926..027dd1504d77 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -22,6 +22,8 @@ cxled_to_mds(struct cxl_endpoint_decoder *cxled)
 	return container_of(cxlds, struct cxl_memdev_state, cxlds);
 }
 
+int cxl_region_invalidate_memregion(struct cxl_region *cxlr);
+
 #ifdef CONFIG_CXL_REGION
 extern struct device_attribute dev_attr_create_pmem_region;
 extern struct device_attribute dev_attr_create_ram_region;
diff --git a/drivers/cxl/core/extent.c b/drivers/cxl/core/extent.c
index 3fb20cd7afc8..4dc0dec486f6 100644
--- a/drivers/cxl/core/extent.c
+++ b/drivers/cxl/core/extent.c
@@ -116,6 +116,12 @@ static void region_extent_unregister(void *ext)
 
 	dev_dbg(&region_extent->dev, "DAX region rm extent HPA %pra\n",
 		&region_extent->hpa_range);
+	/*
+	 * Extent is not in use or an error has occur.  No mappings
+	 * exist at this point.  Write and invalidate caches to ensure
+	 * the device has all data prior to final release.
+	 */
+	cxl_region_invalidate_memregion(region_extent->cxlr_dax->cxlr);
 	device_unregister(&region_extent->dev);
 }
 
@@ -269,20 +275,65 @@ static void calc_hpa_range(struct cxl_endpoint_decoder *cxled,
 	hpa_range->end = hpa_range->start + range_len(dpa_range) - 1;
 }
 
+static int cxlr_notify_extent(struct cxl_region *cxlr, enum dc_event event,
+			      struct region_extent *region_extent)
+{
+	struct device *dev = &cxlr->cxlr_dax->dev;
+	struct cxl_notify_data notify_data;
+	struct cxl_driver *driver;
+
+	dev_dbg(dev, "Trying notify: type %d HPA %pra\n", event,
+		&region_extent->hpa_range);
+
+	guard(device)(dev);
+
+	/*
+	 * The lack of a driver indicates a notification has failed.  No user
+	 * space coordination was possible.
+	 */
+	if (!dev->driver)
+		return 0;
+	driver = to_cxl_drv(dev->driver);
+	if (!driver->notify)
+		return 0;
+
+	notify_data = (struct cxl_notify_data) {
+		.event = event,
+		.region_extent = region_extent,
+	};
+
+	dev_dbg(dev, "Notify: type %d HPA %pra\n", event,
+		&region_extent->hpa_range);
+	return driver->notify(dev, &notify_data);
+}
+
+struct rm_data {
+	struct cxl_region *cxlr;
+	struct range *range;
+};
+
 static int cxlr_rm_extent(struct device *dev, void *data)
 {
 	struct region_extent *region_extent = to_region_extent(dev);
-	struct range *region_hpa_range = data;
+	struct rm_data *rm_data = data;
+	int rc;
 
 	if (!region_extent)
 		return 0;
 
 	/*
-	 * Any extent which 'touches' the released range is removed.
+	 * Any extent which 'touches' the released range is attempted to be
+	 * removed.
 	 */
-	if (range_overlaps(region_hpa_range, &region_extent->hpa_range)) {
+	if (range_overlaps(rm_data->range, &region_extent->hpa_range)) {
+		struct cxl_region *cxlr = rm_data->cxlr;
+
 		dev_dbg(dev, "Remove region extent HPA %pra\n",
 			&region_extent->hpa_range);
+		rc = cxlr_notify_extent(cxlr, DCD_RELEASE_CAPACITY, region_extent);
+		if (rc == -EBUSY)
+			return 0;
+
 		region_rm_extent(region_extent);
 	}
 	return 0;
@@ -327,8 +378,13 @@ int cxl_rm_extent(struct cxl_memdev_state *mds, struct cxl_extent *extent)
 
 	calc_hpa_range(cxled, cxlr->cxlr_dax, &dpa_range, &hpa_range);
 
+	struct rm_data rm_data = {
+		.cxlr = cxlr,
+		.range = &hpa_range,
+	};
+
 	/* Remove region extents which overlap */
-	return device_for_each_child(&cxlr->cxlr_dax->dev, &hpa_range,
+	return device_for_each_child(&cxlr->cxlr_dax->dev, &rm_data,
 				     cxlr_rm_extent);
 }
 
@@ -353,8 +409,23 @@ static int cxlr_add_extent(struct cxl_dax_region *cxlr_dax,
 		return rc;
 	}
 
-	/* device model handles freeing region_extent */
-	return online_region_extent(region_extent);
+	/* Ensure caches are clean prior onlining */
+	cxl_region_invalidate_memregion(cxlr_dax->cxlr);
+
+	rc = online_region_extent(region_extent);
+	/* device model handled freeing region_extent */
+	if (rc)
+		return rc;
+
+	rc = cxlr_notify_extent(cxlr_dax->cxlr, DCD_ADD_CAPACITY, region_extent);
+	/*
+	 * The region device was briefly live but DAX layer ensures it was not
+	 * used
+	 */
+	if (rc)
+		region_rm_extent(region_extent);
+
+	return rc;
 }
 
 /* Callers are expected to ensure cxled has been attached to a region */
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 3106df6f3636..eeabc5a6b18a 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -223,7 +223,7 @@ static struct cxl_region_ref *cxl_rr_load(struct cxl_port *port,
 	return xa_load(&port->regions, (unsigned long)cxlr);
 }
 
-static int cxl_region_invalidate_memregion(struct cxl_region *cxlr)
+int cxl_region_invalidate_memregion(struct cxl_region *cxlr)
 {
 	if (!cpu_cache_has_invalidate_memregion()) {
 		if (IS_ENABLED(CONFIG_CXL_REGION_INVALIDATION_TEST)) {
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index d027432b1572..a14b33eca1d0 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -867,10 +867,16 @@ bool is_cxl_region(struct device *dev);
 
 extern struct bus_type cxl_bus_type;
 
+struct cxl_notify_data {
+	enum dc_event event;
+	struct region_extent *region_extent;
+};
+
 struct cxl_driver {
 	const char *name;
 	int (*probe)(struct device *dev);
 	void (*remove)(struct device *dev);
+	int (*notify)(struct device *dev, struct cxl_notify_data *notify_data);
 	struct device_driver drv;
 	int id;
 };
diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index c25942a3d125..45573d077b5a 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -183,6 +183,93 @@ static bool is_sparse(struct dax_region *dax_region)
 	return (dax_region->res.flags & IORESOURCE_DAX_SPARSE_CAP) != 0;
 }
 
+static void __dax_release_resource(struct dax_resource *dax_resource)
+{
+	struct dax_region *dax_region = dax_resource->region;
+
+	lockdep_assert_held_write(&dax_region_rwsem);
+	dev_dbg(dax_region->dev, "Extent release resource %pr\n",
+		dax_resource->res);
+	if (dax_resource->res)
+		__release_region(&dax_region->res, dax_resource->res->start,
+				 resource_size(dax_resource->res));
+	dax_resource->res = NULL;
+}
+
+static void dax_release_resource(void *res)
+{
+	struct dax_resource *dax_resource = res;
+
+	guard(rwsem_write)(&dax_region_rwsem);
+	__dax_release_resource(dax_resource);
+	kfree(dax_resource);
+}
+
+int dax_region_add_resource(struct dax_region *dax_region,
+			    struct device *device,
+			    resource_size_t start, resource_size_t length)
+{
+	struct resource *new_resource;
+	int rc;
+
+	struct dax_resource *dax_resource __free(kfree) =
+				kzalloc(sizeof(*dax_resource), GFP_KERNEL);
+	if (!dax_resource)
+		return -ENOMEM;
+
+	guard(rwsem_write)(&dax_region_rwsem);
+
+	dev_dbg(dax_region->dev, "DAX region resource %pr\n", &dax_region->res);
+	new_resource = __request_region(&dax_region->res, start, length, "extent", 0);
+	if (!new_resource) {
+		dev_err(dax_region->dev, "Failed to add region s:%pa l:%pa\n",
+			&start, &length);
+		return -ENOSPC;
+	}
+
+	dev_dbg(dax_region->dev, "add resource %pr\n", new_resource);
+	dax_resource->region = dax_region;
+	dax_resource->res = new_resource;
+
+	/*
+	 * open code devm_add_action_or_reset() to avoid recursive write lock
+	 * of dax_region_rwsem in the error case.
+	 */
+	rc = devm_add_action(device, dax_release_resource, dax_resource);
+	if (rc) {
+		__dax_release_resource(dax_resource);
+		return rc;
+	}
+
+	dev_set_drvdata(device, no_free_ptr(dax_resource));
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dax_region_add_resource);
+
+int dax_region_rm_resource(struct dax_region *dax_region,
+			   struct device *dev)
+{
+	struct dax_resource *dax_resource;
+
+	guard(rwsem_write)(&dax_region_rwsem);
+
+	dax_resource = dev_get_drvdata(dev);
+	if (!dax_resource)
+		return 0;
+
+	if (dax_resource->use_cnt)
+		return -EBUSY;
+
+	/*
+	 * release the resource under dax_region_rwsem to avoid races with
+	 * users trying to use the extent
+	 */
+	__dax_release_resource(dax_resource);
+	dev_set_drvdata(dev, NULL);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dax_region_rm_resource);
+
 bool static_dev_dax(struct dev_dax *dev_dax)
 {
 	return is_static(dev_dax->region);
@@ -296,19 +383,41 @@ static ssize_t region_align_show(struct device *dev,
 static struct device_attribute dev_attr_region_align =
 		__ATTR(align, 0400, region_align_show, NULL);
 
+resource_size_t
+dax_avail_size(struct resource *dax_resource)
+{
+	resource_size_t rc;
+	struct resource *used_res;
+
+	rc = resource_size(dax_resource);
+	for_each_child_resource(dax_resource, used_res)
+		rc -= resource_size(used_res);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(dax_avail_size);
+
 #define for_each_dax_region_resource(dax_region, res) \
 	for (res = (dax_region)->res.child; res; res = res->sibling)
 
 static unsigned long long dax_region_avail_size(struct dax_region *dax_region)
 {
-	resource_size_t size = resource_size(&dax_region->res);
+	resource_size_t size;
 	struct resource *res;
 
 	lockdep_assert_held(&dax_region_rwsem);
 
-	if (is_sparse(dax_region))
-		return 0;
+	if (is_sparse(dax_region)) {
+		/*
+		 * Children of a sparse region represent available space not
+		 * used space.
+		 */
+		size = 0;
+		for_each_dax_region_resource(dax_region, res)
+			size += dax_avail_size(res);
+		return size;
+	}
 
+	size = resource_size(&dax_region->res);
 	for_each_dax_region_resource(dax_region, res)
 		size -= resource_size(res);
 	return size;
@@ -449,15 +558,26 @@ EXPORT_SYMBOL_GPL(kill_dev_dax);
 static void trim_dev_dax_range(struct dev_dax *dev_dax)
 {
 	int i = dev_dax->nr_range - 1;
-	struct range *range = &dev_dax->ranges[i].range;
+	struct dev_dax_range *dev_range = &dev_dax->ranges[i];
+	struct range *range = &dev_range->range;
 	struct dax_region *dax_region = dev_dax->region;
+	struct resource *res = &dax_region->res;
 
 	lockdep_assert_held_write(&dax_region_rwsem);
 	dev_dbg(&dev_dax->dev, "delete range[%d]: %#llx:%#llx\n", i,
 		(unsigned long long)range->start,
 		(unsigned long long)range->end);
 
-	__release_region(&dax_region->res, range->start, range_len(range));
+	if (dev_range->dax_resource) {
+		res = dev_range->dax_resource->res;
+		dev_dbg(&dev_dax->dev, "Trim sparse extent %pr\n", res);
+	}
+
+	__release_region(res, range->start, range_len(range));
+
+	if (dev_range->dax_resource)
+		dev_range->dax_resource->use_cnt--;
+
 	if (--dev_dax->nr_range == 0) {
 		kfree(dev_dax->ranges);
 		dev_dax->ranges = NULL;
@@ -640,7 +760,7 @@ static void dax_region_unregister(void *region)
 
 struct dax_region *alloc_dax_region(struct device *parent, int region_id,
 		struct range *range, int target_node, unsigned int align,
-		unsigned long flags)
+		unsigned long flags, struct dax_sparse_ops *sparse_ops)
 {
 	struct dax_region *dax_region;
 
@@ -658,12 +778,16 @@ struct dax_region *alloc_dax_region(struct device *parent, int region_id,
 			|| !IS_ALIGNED(range_len(range), align))
 		return NULL;
 
+	if (!sparse_ops && (flags & IORESOURCE_DAX_SPARSE_CAP))
+		return NULL;
+
 	dax_region = kzalloc(sizeof(*dax_region), GFP_KERNEL);
 	if (!dax_region)
 		return NULL;
 
 	dev_set_drvdata(parent, dax_region);
 	kref_init(&dax_region->kref);
+	dax_region->sparse_ops = sparse_ops;
 	dax_region->id = region_id;
 	dax_region->align = align;
 	dax_region->dev = parent;
@@ -845,7 +969,8 @@ static int devm_register_dax_mapping(struct dev_dax *dev_dax, int range_id)
 }
 
 static int alloc_dev_dax_range(struct resource *parent, struct dev_dax *dev_dax,
-			       u64 start, resource_size_t size)
+			       u64 start, resource_size_t size,
+			       struct dax_resource *dax_resource)
 {
 	struct device *dev = &dev_dax->dev;
 	struct dev_dax_range *ranges;
@@ -884,6 +1009,7 @@ static int alloc_dev_dax_range(struct resource *parent, struct dev_dax *dev_dax,
 			.start = alloc->start,
 			.end = alloc->end,
 		},
+		.dax_resource = dax_resource,
 	};
 
 	dev_dbg(dev, "alloc range[%d]: %pa:%pa\n", dev_dax->nr_range - 1,
@@ -966,7 +1092,8 @@ static int dev_dax_shrink(struct dev_dax *dev_dax, resource_size_t size)
 	int i;
 
 	for (i = dev_dax->nr_range - 1; i >= 0; i--) {
-		struct range *range = &dev_dax->ranges[i].range;
+		struct dev_dax_range *dev_range = &dev_dax->ranges[i];
+		struct range *range = &dev_range->range;
 		struct dax_mapping *mapping = dev_dax->ranges[i].mapping;
 		struct resource *adjust = NULL, *res;
 		resource_size_t shrink;
@@ -982,12 +1109,21 @@ static int dev_dax_shrink(struct dev_dax *dev_dax, resource_size_t size)
 			continue;
 		}
 
-		for_each_dax_region_resource(dax_region, res)
-			if (strcmp(res->name, dev_name(dev)) == 0
-					&& res->start == range->start) {
-				adjust = res;
-				break;
-			}
+		if (dev_range->dax_resource) {
+			for_each_child_resource(dev_range->dax_resource->res, res)
+				if (strcmp(res->name, dev_name(dev)) == 0
+						&& res->start == range->start) {
+					adjust = res;
+					break;
+				}
+		} else {
+			for_each_dax_region_resource(dax_region, res)
+				if (strcmp(res->name, dev_name(dev)) == 0
+						&& res->start == range->start) {
+					adjust = res;
+					break;
+				}
+		}
 
 		if (dev_WARN_ONCE(dev, !adjust || i != dev_dax->nr_range - 1,
 					"failed to find matching resource\n"))
@@ -1025,19 +1161,21 @@ static bool adjust_ok(struct dev_dax *dev_dax, struct resource *res)
 }
 
 /**
- * dev_dax_resize_static - Expand the device into the unused portion of the
- * region. This may involve adjusting the end of an existing resource, or
- * allocating a new resource.
+ * __dev_dax_resize - Expand the device into the unused portion of the region.
+ * This may involve adjusting the end of an existing resource, or allocating a
+ * new resource.
  *
  * @parent: parent resource to allocate this range in
  * @dev_dax: DAX device to be expanded
  * @to_alloc: amount of space to alloc; must be <= space available in @parent
+ * @dax_resource: if sparse; the parent resource
  *
  * Return the amount of space allocated or -ERRNO on failure
  */
-static ssize_t dev_dax_resize_static(struct resource *parent,
-				     struct dev_dax *dev_dax,
-				     resource_size_t to_alloc)
+static ssize_t __dev_dax_resize(struct resource *parent,
+				struct dev_dax *dev_dax,
+				resource_size_t to_alloc,
+				struct dax_resource *dax_resource)
 {
 	struct resource *res, *first;
 	int rc;
@@ -1045,7 +1183,8 @@ static ssize_t dev_dax_resize_static(struct resource *parent,
 	first = parent->child;
 	if (!first) {
 		rc = alloc_dev_dax_range(parent, dev_dax,
-					   parent->start, to_alloc);
+					   parent->start, to_alloc,
+					   dax_resource);
 		if (rc)
 			return rc;
 		return to_alloc;
@@ -1059,7 +1198,8 @@ static ssize_t dev_dax_resize_static(struct resource *parent,
 		if (res == first && res->start > parent->start) {
 			alloc = min(res->start - parent->start, to_alloc);
 			rc = alloc_dev_dax_range(parent, dev_dax,
-						 parent->start, alloc);
+						 parent->start, alloc,
+						 dax_resource);
 			if (rc)
 				return rc;
 			return alloc;
@@ -1083,7 +1223,8 @@ static ssize_t dev_dax_resize_static(struct resource *parent,
 				return rc;
 			return alloc;
 		}
-		rc = alloc_dev_dax_range(parent, dev_dax, res->end + 1, alloc);
+		rc = alloc_dev_dax_range(parent, dev_dax, res->end + 1, alloc,
+					 dax_resource);
 		if (rc)
 			return rc;
 		return alloc;
@@ -1094,6 +1235,51 @@ static ssize_t dev_dax_resize_static(struct resource *parent,
 	return 0;
 }
 
+static ssize_t dev_dax_resize_static(struct dax_region *dax_region,
+				     struct dev_dax *dev_dax,
+				     resource_size_t to_alloc)
+{
+	return __dev_dax_resize(&dax_region->res, dev_dax, to_alloc, NULL);
+}
+
+static int find_free_extent(struct device *dev, const void *data)
+{
+	const struct dax_region *dax_region = data;
+	struct dax_resource *dax_resource;
+
+	if (!dax_region->sparse_ops->is_extent(dev))
+		return 0;
+
+	dax_resource = dev_get_drvdata(dev);
+	if (!dax_resource || !dax_avail_size(dax_resource->res))
+		return 0;
+	return 1;
+}
+
+static ssize_t dev_dax_resize_sparse(struct dax_region *dax_region,
+				     struct dev_dax *dev_dax,
+				     resource_size_t to_alloc)
+{
+	struct dax_resource *dax_resource;
+	ssize_t alloc;
+
+	struct device *extent_dev __free(put_device) =
+			device_find_child(dax_region->dev, dax_region,
+					  find_free_extent);
+	if (!extent_dev)
+		return 0;
+
+	dax_resource = dev_get_drvdata(extent_dev);
+	if (!dax_resource)
+		return 0;
+
+	to_alloc = min(dax_avail_size(dax_resource->res), to_alloc);
+	alloc = __dev_dax_resize(dax_resource->res, dev_dax, to_alloc, dax_resource);
+	if (alloc > 0)
+		dax_resource->use_cnt++;
+	return alloc;
+}
+
 static ssize_t dev_dax_resize(struct dax_region *dax_region,
 		struct dev_dax *dev_dax, resource_size_t size)
 {
@@ -1118,7 +1304,10 @@ static ssize_t dev_dax_resize(struct dax_region *dax_region,
 		return -ENXIO;
 
 retry:
-	alloc = dev_dax_resize_static(&dax_region->res, dev_dax, to_alloc);
+	if (is_sparse(dax_region))
+		alloc = dev_dax_resize_sparse(dax_region, dev_dax, to_alloc);
+	else
+		alloc = dev_dax_resize_static(dax_region, dev_dax, to_alloc);
 	if (alloc <= 0)
 		return alloc;
 	to_alloc -= alloc;
@@ -1227,7 +1416,7 @@ static ssize_t mapping_store(struct device *dev, struct device_attribute *attr,
 	to_alloc = range_len(&r);
 	if (alloc_is_aligned(dev_dax, to_alloc))
 		rc = alloc_dev_dax_range(&dax_region->res, dev_dax, r.start,
-					 to_alloc);
+					 to_alloc, NULL);
 	up_write(&dax_dev_rwsem);
 	up_write(&dax_region_rwsem);
 
@@ -1466,6 +1655,11 @@ static struct dev_dax *__devm_create_dev_dax(struct dev_dax_data *data)
 	struct device *dev;
 	int rc;
 
+	if (is_sparse(dax_region) && data->size) {
+		dev_err(parent, "Sparse DAX region devices must be created initially with 0 size");
+		return ERR_PTR(-EINVAL);
+	}
+
 	dev_dax = kzalloc(sizeof(*dev_dax), GFP_KERNEL);
 	if (!dev_dax)
 		return ERR_PTR(-ENOMEM);
@@ -1496,7 +1690,7 @@ static struct dev_dax *__devm_create_dev_dax(struct dev_dax_data *data)
 	dev_set_name(dev, "dax%d.%d", dax_region->id, dev_dax->id);
 
 	rc = alloc_dev_dax_range(&dax_region->res, dev_dax, dax_region->res.start,
-				 data->size);
+				 data->size, NULL);
 	if (rc)
 		goto err_range;
 
diff --git a/drivers/dax/bus.h b/drivers/dax/bus.h
index 783bfeef42cc..ae5029ea6047 100644
--- a/drivers/dax/bus.h
+++ b/drivers/dax/bus.h
@@ -9,6 +9,7 @@ struct dev_dax;
 struct resource;
 struct dax_device;
 struct dax_region;
+struct dax_sparse_ops;
 
 /* dax bus specific ioresource flags */
 #define IORESOURCE_DAX_STATIC BIT(0)
@@ -17,7 +18,7 @@ struct dax_region;
 
 struct dax_region *alloc_dax_region(struct device *parent, int region_id,
 		struct range *range, int target_node, unsigned int align,
-		unsigned long flags);
+		unsigned long flags, struct dax_sparse_ops *sparse_ops);
 
 struct dev_dax_data {
 	struct dax_region *dax_region;
diff --git a/drivers/dax/cxl.c b/drivers/dax/cxl.c
index 88b051cea755..011bd1dc7691 100644
--- a/drivers/dax/cxl.c
+++ b/drivers/dax/cxl.c
@@ -5,6 +5,57 @@
 
 #include "../cxl/cxl.h"
 #include "bus.h"
+#include "dax-private.h"
+
+static int __cxl_dax_add_resource(struct dax_region *dax_region,
+				  struct region_extent *region_extent)
+{
+	struct device *dev = &region_extent->dev;
+	resource_size_t start, length;
+
+	start = dax_region->res.start + region_extent->hpa_range.start;
+	length = range_len(&region_extent->hpa_range);
+	return dax_region_add_resource(dax_region, dev, start, length);
+}
+
+static int cxl_dax_add_resource(struct device *dev, void *data)
+{
+	struct dax_region *dax_region = data;
+	struct region_extent *region_extent;
+
+	region_extent = to_region_extent(dev);
+	if (!region_extent)
+		return 0;
+
+	dev_dbg(dax_region->dev, "Adding resource HPA %pra\n",
+		&region_extent->hpa_range);
+
+	return __cxl_dax_add_resource(dax_region, region_extent);
+}
+
+static int cxl_dax_region_notify(struct device *dev,
+				 struct cxl_notify_data *notify_data)
+{
+	struct cxl_dax_region *cxlr_dax = to_cxl_dax_region(dev);
+	struct dax_region *dax_region = dev_get_drvdata(dev);
+	struct region_extent *region_extent = notify_data->region_extent;
+
+	switch (notify_data->event) {
+	case DCD_ADD_CAPACITY:
+		return __cxl_dax_add_resource(dax_region, region_extent);
+	case DCD_RELEASE_CAPACITY:
+		return dax_region_rm_resource(dax_region, &region_extent->dev);
+	case DCD_FORCED_CAPACITY_RELEASE:
+	default:
+		dev_err(&cxlr_dax->dev, "Unknown DC event %d\n",
+			notify_data->event);
+		return -ENXIO;
+	}
+}
+
+struct dax_sparse_ops sparse_ops = {
+	.is_extent = is_region_extent,
+};
 
 static int cxl_dax_region_probe(struct device *dev)
 {
@@ -24,15 +75,18 @@ static int cxl_dax_region_probe(struct device *dev)
 		flags |= IORESOURCE_DAX_SPARSE_CAP;
 
 	dax_region = alloc_dax_region(dev, cxlr->id, &cxlr_dax->hpa_range, nid,
-				      PMD_SIZE, flags);
+				      PMD_SIZE, flags, &sparse_ops);
 	if (!dax_region)
 		return -ENOMEM;
 
-	if (cxlr->mode == CXL_PARTMODE_DYNAMIC_RAM_A)
+	if (cxlr->mode == CXL_PARTMODE_DYNAMIC_RAM_A) {
+		device_for_each_child(&cxlr_dax->dev, dax_region,
+				      cxl_dax_add_resource);
 		/* Add empty seed dax device */
 		dev_size = 0;
-	else
+	} else {
 		dev_size = range_len(&cxlr_dax->hpa_range);
+	}
 
 	data = (struct dev_dax_data) {
 		.dax_region = dax_region,
@@ -47,6 +101,7 @@ static int cxl_dax_region_probe(struct device *dev)
 static struct cxl_driver cxl_dax_region_driver = {
 	.name = "cxl_dax_region",
 	.probe = cxl_dax_region_probe,
+	.notify = cxl_dax_region_notify,
 	.id = CXL_DEVICE_DAX_REGION,
 	.drv = {
 		.suppress_bind_attrs = true,
diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
index 0867115aeef2..39fb587561f8 100644
--- a/drivers/dax/dax-private.h
+++ b/drivers/dax/dax-private.h
@@ -16,6 +16,14 @@ struct inode *dax_inode(struct dax_device *dax_dev);
 int dax_bus_init(void);
 void dax_bus_exit(void);
 
+/**
+ * struct dax_sparse_ops - Operations for sparse regions
+ * @is_extent: return if the device is an extent
+ */
+struct dax_sparse_ops {
+	bool (*is_extent)(struct device *dev);
+};
+
 /**
  * struct dax_region - mapping infrastructure for dax devices
  * @id: kernel-wide unique region for a memory range
@@ -27,6 +35,7 @@ void dax_bus_exit(void);
  * @res: resource tree to track instance allocations
  * @seed: allow userspace to find the first unbound seed device
  * @youngest: allow userspace to find the most recently created device
+ * @sparse_ops: operations required for sparse regions
  */
 struct dax_region {
 	int id;
@@ -38,6 +47,7 @@ struct dax_region {
 	struct resource res;
 	struct device *seed;
 	struct device *youngest;
+	struct dax_sparse_ops *sparse_ops;
 };
 
 /**
@@ -57,11 +67,13 @@ struct dax_mapping {
  * @pgoff: page offset
  * @range: resource-span
  * @mapping: reference to the dax_mapping for this range
+ * @dax_resource: if not NULL; dax sparse resource containing this range
  */
 struct dev_dax_range {
 	unsigned long pgoff;
 	struct range range;
 	struct dax_mapping *mapping;
+	struct dax_resource *dax_resource;
 };
 
 /**
@@ -100,6 +112,34 @@ struct dev_dax {
  */
 void run_dax(struct dax_device *dax_dev);
 
+/**
+ * struct dax_resource - For sparse regions; an active resource
+ * @region: dax_region this resources is in
+ * @res: resource
+ * @use_cnt: count the number of uses of this resource
+ *
+ * Changes to the dax_region and the dax_resources within it are protected by
+ * dax_region_rwsem
+ *
+ * dax_resource's are not intended to be used outside the dax layer.
+ */
+struct dax_resource {
+	struct dax_region *region;
+	struct resource *res;
+	unsigned int use_cnt;
+};
+
+/*
+ * Similar to run_dax() dax_region_{add,rm}_resource() and dax_avail_size() are
+ * exported but are not intended to be generic operations outside the dax
+ * subsystem.  They are only generic between the dax layer and the dax drivers.
+ */
+int dax_region_add_resource(struct dax_region *dax_region, struct device *dev,
+			    resource_size_t start, resource_size_t length);
+int dax_region_rm_resource(struct dax_region *dax_region,
+			   struct device *dev);
+resource_size_t dax_avail_size(struct resource *dax_resource);
+
 static inline struct dev_dax *to_dev_dax(struct device *dev)
 {
 	return container_of(dev, struct dev_dax, dev);
diff --git a/drivers/dax/hmem/hmem.c b/drivers/dax/hmem/hmem.c
index 5e7c53f18491..0eea65052874 100644
--- a/drivers/dax/hmem/hmem.c
+++ b/drivers/dax/hmem/hmem.c
@@ -28,7 +28,7 @@ static int dax_hmem_probe(struct platform_device *pdev)
 
 	mri = dev->platform_data;
 	dax_region = alloc_dax_region(dev, pdev->id, &mri->range,
-				      mri->target_node, PMD_SIZE, flags);
+				      mri->target_node, PMD_SIZE, flags, NULL);
 	if (!dax_region)
 		return -ENOMEM;
 
diff --git a/drivers/dax/pmem.c b/drivers/dax/pmem.c
index c8ebf4e281f2..f927e855f240 100644
--- a/drivers/dax/pmem.c
+++ b/drivers/dax/pmem.c
@@ -54,7 +54,7 @@ static struct dev_dax *__dax_pmem_probe(struct device *dev)
 	range.start += offset;
 	dax_region = alloc_dax_region(dev, region_id, &range,
 			nd_region->target_node, le32_to_cpu(pfn_sb->align),
-			IORESOURCE_DAX_STATIC);
+			IORESOURCE_DAX_STATIC, NULL);
 	if (!dax_region)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index e8b2d6aa4013..a97bb3d936a7 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -27,6 +27,9 @@ struct resource {
 	struct resource *parent, *sibling, *child;
 };
 
+#define for_each_child_resource(parent, res) \
+	for (res = (parent)->child; res; res = res->sibling)
+
 /*
  * IO resources have these defined flags.
  *

-- 
2.49.0

