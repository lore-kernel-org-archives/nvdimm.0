Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19E12317170
	for <nvdimm@lists.linux.dev>; Tue, 24 Mar 2026 19:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774381611; cv=fail; b=jTRb7sGUepKAlZjQ7hF0UAs1fjxh+B3KcdIGGgTH/rAJJGySqa3qu1UF9+d+QqgxS/h5V5CdG/P9xJ5fc9c6+USH8Dvr2TSZ1JrQxGy4Vm1BJaEWaEUGB8gGHyZrxoFUIW53k6WsLbDXmmc9oplqAEFh+9plyJ3Nn+kxkIwuSo0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774381611; c=relaxed/simple;
	bh=SII/7xeCvPsgw0P3zddZaNvNW5XhzEkaazQ88aZc5rw=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=QA7ag4u922VC7lKlJgJy1U3U1IXwTgRC2E8sr69f7DFtMpF7SQlZ1V6lsBbAkVFMvMnif4AgyHTZyLTgj2uSAF/yDt24ui3NBYee6x52RsSaDFB83XU5qKKn+nITGKud5p9/uKSXvokU2Kuiwlr2X5jdoZrLhDCyQQpYl+GQwiY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bGm/3If1; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bGm/3If1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774381608; x=1805917608;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=SII/7xeCvPsgw0P3zddZaNvNW5XhzEkaazQ88aZc5rw=;
  b=bGm/3If1WTbN3WoHrJ9vITLwO+aps0zWFEshGSqBXayLKT6uKyhWSRGO
   NNH0qaUbQiIqAkXFp0Wc8MtUpuvDULKUK21SRI1Ox69DKKeh8FqxpSPNs
   PQ5ZhpG9bwgwYZJhb/2NCrp2/nmaT/XYCx3a6iUiKxGHDb+sJ6ayDI2yv
   HkBfRPX4ISS+XeX7Zb+nP25M3cLxdmbF+8j0L9w1OTN5HfR+IaGNGWffS
   IJ+wm3mCB8kiBdkTdAKcc02tdTyY8B15tb9X0CmY26RqWCYF3ox1LX2QA
   N0lxbqDCZneycAzumKbJjxJpwAGOpnUoTNlXEBlYbW/R7AQWhuuH4bSvm
   Q==;
X-CSE-ConnectionGUID: oFCUH2lNQLqugMbdgMG8YA==
X-CSE-MsgGUID: tjA6J2TJT8mhYx1KT+aDCw==
X-IronPort-AV: E=McAfee;i="6800,10657,11739"; a="86487047"
X-IronPort-AV: E=Sophos;i="6.23,138,1770624000"; 
   d="scan'208";a="86487047"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2026 12:46:47 -0700
X-CSE-ConnectionGUID: til5AyqQS06puNXN4le8YQ==
X-CSE-MsgGUID: hYKhXhZoRHq5td2/0BFANg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,138,1770624000"; 
   d="scan'208";a="254964375"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2026 12:46:46 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 24 Mar 2026 12:46:46 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 24 Mar 2026 12:46:46 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.28) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 24 Mar 2026 12:46:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Vy1nIXUOlY0ApMKc19QBVBkaOD8ogpLqUnDsr560vHPPutPLG3SBjgD5rqEAf8YTtuB6NtoJEW8mg1wx9IyGx3EEdIE8xWpsVGj3fEoZTSRO5bIM59vuXNYGo46vg5Zvwfn+GNHXwqyGIMJtKItk006Heu7rSSom4ngSByHUJY6+/rfJhqs1jdunq9yNZNHlA5SfAic5ritKktbrRUd3W7NDo/16hlZJ3H6GGpVB6fFnK+97ufYQoj0FuU5dODXD1abfxyRovPWDUrJrFeWY2w7Huychzi34+bnKUAg0XWBhm0yyqEvcx7qlq7s6lhh3muGTb4M05f4tkhVbWMT4ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PDfxH0FFYAkxjj/4ASFi493PM/ItnitpnK4rTPNiFzw=;
 b=gxtq5h9sZ2Wuwr/qYR8KNt4ZCDsJQuCxm8CJLC/mSfW2iW6iKsoAIQ5H+ImXMsPRCyr1ewJWe6obofNRO+sLt3Y5HNk+zmQn8+yJHiN3JUyIhX71FcpgOucdcYAb2UP4tsUNqqjdWmexJVipJa2np2c+RRRtnHoepSQ0A8x7sjsNprJpGf086Gka28EKTEE3hQ6CDKmCL+CjJQpll+9V33Us1tFUoXLrCY3tjwsvnMKN9axBNiseOz9TrxnO0EP2iiWCOw6O3HvZ5UnquEnk/vwiLlwgYLfyAobl7gSCwBFLaELqAqD36BeIY6nBWIXONNpVHs8sAkyUSQqFqGrjow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DS0PR11MB7767.namprd11.prod.outlook.com (2603:10b6:8:138::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.9; Tue, 24 Mar
 2026 19:46:41 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%3]) with mapi id 15.20.9745.019; Tue, 24 Mar 2026
 19:46:41 +0000
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 24 Mar 2026 12:46:38 -0700
To: Alison Schofield <alison.schofield@intel.com>, Dan Williams
	<dan.j.williams@intel.com>
CC: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>,
	<linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-fsdevel@vger.kernel.org>,
	<linux-pm@vger.kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Vishal Verma
	<vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>, Jonathan Cameron
	<jonathan.cameron@huawei.com>, Yazen Ghannam <yazen.ghannam@amd.com>, "Dave
 Jiang" <dave.jiang@intel.com>, Davidlohr Bueso <dave@stgolabs.net>, "Matthew
 Wilcox" <willy@infradead.org>, Jan Kara <jack@suse.cz>, "Rafael J . Wysocki"
	<rafael@kernel.org>, Len Brown <len.brown@intel.com>, Pavel Machek
	<pavel@kernel.org>, Li Ming <ming.li@zohomail.com>, Jeff Johnson
	<jeff.johnson@oss.qualcomm.com>, Ying Huang <huang.ying.caritas@gmail.com>,
	Yao Xingtao <yaoxt.fnst@fujitsu.com>, Peter Zijlstra <peterz@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Nathan Fontenot
	<nathan.fontenot@amd.com>, Terry Bowman <terry.bowman@amd.com>, "Robert
 Richter" <rrichter@amd.com>, Benjamin Cheatham <benjamin.cheatham@amd.com>,
	Zhijian Li <lizhijian@fujitsu.com>, Borislav Petkov <bp@alien8.de>, "Tomasz
 Wolski" <tomasz.wolski@fujitsu.com>
Message-ID: <69c2ea1ea24e1_51621100a1@dwillia2-mobl4.notmuch>
In-Reply-To: <absY10LzUqb3vK7A@aschofie-mobl2.lan>
References: <20260210064501.157591-1-Smita.KoralahalliChannabasappa@amd.com>
 <20260210064501.157591-4-Smita.KoralahalliChannabasappa@amd.com>
 <69b1e0aacb9d0_2132100c5@dwillia2-mobl4.notmuch>
 <absY10LzUqb3vK7A@aschofie-mobl2.lan>
Subject: Re: [PATCH v6 3/9] cxl/region: Skip decoder reset on detach for
 autodiscovered regions
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P222CA0009.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::14) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DS0PR11MB7767:EE_
X-MS-Office365-Filtering-Correlation-Id: 09d09c28-f3a8-4274-c446-08de89de11f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|22082099003|56012099003|18002099003|7053199007;
X-Microsoft-Antispam-Message-Info: 4zglxPPl7G+/RPbqt7FWJSDsLhmtCENUHB+yUjLEZeb+nlXIwMRIEPHRGVepAj4I7W1dYRbzI5AId/geX48kYm81Df5bGKFT4l937DlpFtIXX8SsUw9P0XWldfKffmJ2cccUcLZT29G5elGY2yhN3kONx+nJq56c+r1jxYdbPYBADhmZ2eEKuhWzCxxxeYyAaqnhSJc8TjUMg0c5F9cB3eFERZfFB+IQH3l5/sQu7G3FIi16KdLSh/emlOfrDJOOc1at1Bm2PzjRZqiBZ0sWTJvBrGjU0KK6Ep7dXFz/TmTL030U4tH0QZc9oHfNtrbu+hOs3fajbUp5BZFRyH1P7El5sIDUPOLVZmSOm5VEIIG2HT1yP6uzoAXafElZd0u0YQCg1ayJqX2mL/maNvuF5MLAquZLjIbD2AmeTWrzWs8FvGKwsqIse6LH12rBDecNJOEcqAPQFtPKxoXU3EIOWY/7EL+g1jYC8yks0/N7s/ZaW1U2svV09qHz7vB9Um+GgA35trNAx+c7UwalPkTt+skWjGPFAH6WWgJBKImT7yEYh0sQS8etzV99yAbd6XpNIYELn4hS6vbFjeE8LNYCPNQLVgYSTzodCC5u+fTdKogdYSYw0xWlSSwI7r8pRl/eoDEtUvfU+N52SQcQbY2fAvwurmSOPV8/y3oUVyJYmMPMrrOc03Q3RAnHYSXug3h/TFPlM1RgnFStIGCvEMklRzZwVyb81izB3yKs5Fm6tfc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(22082099003)(56012099003)(18002099003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?czU2RUFWc09uQzM1V2tiV1VscTk4UnpwNkhvQmpjNE85aWJvdGN2SmVxYm8v?=
 =?utf-8?B?WkNMZG1PNzlzTFc1MldKTGhYRG93TVJmNm40ODF4Q29uMi9rQlp6MzFlVW9P?=
 =?utf-8?B?dU93VzF3ZC9tM1VEc0VZc2VqNmJsT0pETTRwdkdRbytCTHpNd2Uvb1VXT0xp?=
 =?utf-8?B?ZGkrZUNQS1BNMitKdVdtbXI4R0pqT1hVSk1sS014dldtNXZSRFZOS2JjQVNR?=
 =?utf-8?B?L3hVSXVNTnVvQm54bFRDRzdEQ1gwK3hqQjFiOGVjSERMZHVjcDQ2VzNzcUdK?=
 =?utf-8?B?WHBhZzJrU051bHcyUmRoSUtQSnpsMGx4OTFPMW5iT3p0ZVh0Q2Q0ZFB5ZHNG?=
 =?utf-8?B?NVhlZFlCdVVJbGRxVmFEeExyUWdiaHpERExVaVUrRS9lREo4NjdmRWFDVUhw?=
 =?utf-8?B?c1BhU1ZOQ2o5SllFcXJydHNxSHJWY29LcFNEaFBTUjNGU3JRSWRxK24xWlNV?=
 =?utf-8?B?MnVWa2hFbmUrMU9XczRCTFp6cDcybXVHVDJBb2RnYUtLYmhNTUM4VXZVK1FI?=
 =?utf-8?B?emVDQWlhYzFSLy9QZkkxa2hJcGdsSGEvcTFvODhuSXkrUWVERk9YdmxiTHZP?=
 =?utf-8?B?NDU3ODFQREZoQm81ZmxxNkZuYlJFQUtLWnBtbXZ6ZjRQbHozUXJqakx5cldy?=
 =?utf-8?B?NVcwS0Vnb2FtY1JNT0RhTHZ3VEREaXRLMFFwRjh0WVJHbU5WdDdSQzJUVzdX?=
 =?utf-8?B?SlZGQjFycEFOWWszNVprTmQ3RXYySEJTelhQNWRUVGVsRzZ6UEJGNnpPREFk?=
 =?utf-8?B?RmswSnBhVHZmdlk1dDdYZWpHeC96djNSb1NIN3pBa0FwVko3Z3VpQldCOHBm?=
 =?utf-8?B?Q09pcDBVUmpWM2lFQjFHMEVsOS8yUkdBY25qZmpYdnNMTHZENVR1ZkVraGpD?=
 =?utf-8?B?RUJlZEd3ZDh0czIwTFhTcE5TRGxwQWsyYlZMcEdWU1kwbjJJbnBLV1RTQWEx?=
 =?utf-8?B?RmQ0akFxWnZlZU1majhBWGZNSEtwcVJaMWZmTVRXOVcvZ21WbVFhZmdzNHJv?=
 =?utf-8?B?alREZ2s4SUZtNks4d21NZ0s0V3RVcjBsTkU5Sm94eVI4MW1zQnFDSklJZWgr?=
 =?utf-8?B?Zm5pZzEzM2R6b2l0blVDYk43amw5ODYzTTBSSHU1L01SQXZlVDM4RExCRVhp?=
 =?utf-8?B?ZVd3d2hCN3NkWGx6Z1IvZkJ6ZmRvUFBzWWR4aHNWREtmemdrakpkdWJPR2pE?=
 =?utf-8?B?TVRIZXFkL09WekFYYk9Rd0RYbmRDVkllNHpIODN5NkxiS21nK2FNMGtLaG1C?=
 =?utf-8?B?cUI0QVFnL0FnRzFTQ294cVR4U3RuYWhtdlNLeHUrWFhud2V6bzF2bDNKQVJ3?=
 =?utf-8?B?ZDVQRjBBR3c1M0hGWGxXVWpGQXV0Q1ZaWi8yZUdxVzZJaGt2bWFkUUdEd2dY?=
 =?utf-8?B?UE9BSkk1bHJEdjBZS1ZWSWc2eEZKLzJxQ3k3K2tjTTZOUlV5K1NIMmpjeEND?=
 =?utf-8?B?Z3Ewc0c1U1BSMEoxY3BhY0VZajdjQ1RYZnM3WWVuTzdjL0RZRGY2dkc0S1NS?=
 =?utf-8?B?UE5GRGllZ2R6YlJYWVdsNkN1WFFVMXFZTk8rMW1KN2haaFlRc0lOTk4zZWFL?=
 =?utf-8?B?RkhZaU9kYTAyVm95MytFdCtWQVFGaS9UQlVxZlNudlZUUnZIeHM5Wmg5aVZL?=
 =?utf-8?B?SXZjZUVSdUxjZVlIaGlyVGxWUmdyeWdQdW52MGwzbHVnRTM5bnRTM254M2pi?=
 =?utf-8?B?S3RYbW1tMHNJN3AzdVVSa1pxdFhneXQvL2Jma1JKbzZhcWdWVTRVbnc4ck9r?=
 =?utf-8?B?WHg3RWx1L2xkTWVCWXRzbzEybHZZQnU5bU9QUU9zWkVKZEJNWXpBdlNnemJM?=
 =?utf-8?B?ZEJLdkRLYlFIa204Y0hFL1JPS0hBOWE4RllkM3hVWEEwNy9JSkZ3cVFsOFJ0?=
 =?utf-8?B?bzhiWWJIaWR3VUFPbGpRTWkyNzAzdlQrNnRVNUxFZ3ltTTE3bFVrRWEwN0h6?=
 =?utf-8?B?dTBFcWRmMzBPbHh2bnRkWmljR3Y0YklEd3VYNm9HK2g5YTgrV2FTZkFnSUU1?=
 =?utf-8?B?WW9VOXA3eC9IRVZ0RHUrY3M1T2lZbDJqcFVMTkxzWW44NE40TUhmZFcrMGZT?=
 =?utf-8?B?Z29kcU5hYWhFUkJocUM5bW1NN0EvSllXVWt6SnZ0OHk3azBuSVMvR2Q4dFFQ?=
 =?utf-8?B?Szk5MWpaTzAvUys3WDdFUnYxNlpvT2paUmJ2M2h1dzBnS2x3VUxRREhLQWRZ?=
 =?utf-8?B?UnMxeVZHSU9sWmZnMXNYVkovdG1XQlErejVXcUNvREI5eHVFblJZUk1kQThm?=
 =?utf-8?B?QUVQN3JDSTdDSE4yM2V3d3JkSDBvYUNkMzNFejVRVVA0K2UvNVZ2QVg2QzVG?=
 =?utf-8?B?NDhSN011d3hqa2hNM1p1dmQvQzVWaFh2bEhROVVkR21YeHhBeEJjUHlkMit2?=
 =?utf-8?Q?ngDmCvBIVWIrQrqk=3D?=
X-Exchange-RoutingPolicyChecked: aCMRm7XZGoSIHhC7OgBzJ0ztj1OrN8ie+DGGEUm/YJigZcpfWOA/1tFNbcwIDbba0NPHg2Xek227yLHlyYGmni1MITKmmmq3Z4UNE+Z5c3oao5RID5TySbfyLOimlc99AKk+LT2RYw3aDZhM6iU8ei6qT6/coAX5CUod4P85KjVgPkx77GsZZe98UspgizNxkLSQPacHc61liq272SqqtNUpt8Ohtsdo4O04LXWHqCXEW4/mpMqHp8vdas59z5RR4Cf3ghILEpi7ue5SsIeEM7/J8J6CqFxiQz0VcgyIxGMsO/pKjcQPgALdhcnw2jiIqaG+x66MVrIQBleBHL3lRw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 09d09c28-f3a8-4274-c446-08de89de11f9
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2026 19:46:41.5092
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vgmBirwy32w0XgL9p8PZzDdRrhS466PLRz8eVGaku+luav/J8HK19hH5MekG5Vv5DOmBj7D6+3ZXjI1l46uxkEcbj9i0IVZfMUVyjS8HKXo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7767
X-OriginatorOrg: intel.com

Alison Schofield wrote:
> On Wed, Mar 11, 2026 at 02:37:46PM -0700, Dan Williams wrote:
> > Smita Koralahalli wrote:
> > > __cxl_decoder_detach() currently resets decoder programming whenever a
> > > region is detached if cxl_config_state is beyond CXL_CONFIG_ACTIVE. For
> > > autodiscovered regions, this can incorrectly tear down decoder state
> > > that may be relied upon by other consumers or by subsequent ownership
> > > decisions.
> > > 
> > > Skip cxl_region_decode_reset() during detach when CXL_REGION_F_AUTO is
> > > set.
> > > 
> > > Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
> > > Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> > > Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> > > Reviewed-by: Alejandro Lucero <alucerop@amd.com>
> > > ---
> > >  drivers/cxl/core/region.c | 4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> > > index ae899f68551f..45ee598daf95 100644
> > > --- a/drivers/cxl/core/region.c
> > > +++ b/drivers/cxl/core/region.c
> > > @@ -2178,7 +2178,9 @@ __cxl_decoder_detach(struct cxl_region *cxlr,
> > >  		cxled->part = -1;
> > >  
> > >  	if (p->state > CXL_CONFIG_ACTIVE) {
> > > -		cxl_region_decode_reset(cxlr, p->interleave_ways);
> > > +		if (!test_bit(CXL_REGION_F_AUTO, &cxlr->flags))
> > > +			cxl_region_decode_reset(cxlr, p->interleave_ways);
> > > +
> > >  		p->state = CXL_CONFIG_ACTIVE;
> > 
> 
> Hi Dan,
> 
> > tl;dr: I do not think we need this, I do think we need to clarify to
> > users what enable/disable and/or hot remove violence is handled and not
> > handled by the CXL core.
> 
> I'm chiming in here because although this patch is no longer needed for
> this series, it has become a dependency for the Type 2 series.

Like I replied to Alejandro it is not a dependency for the type-2 series
[1]. It *is* a fix for the issue reported by PJ, but it can go in
independent of the base type-2 work as a standalone capability.

[1]: http://lore.kernel.org/69b8b9181bafd_452b100cb@dwillia2-mobl4.notmuch

> So this
> follow-up focuses on the hot-remove, endpoint-detach case where
> preserving decoders across detach is still needed for later recovery.
> 
> Some inline responses to you, and then a diff is appended for a
> direction check.
> 
> > So this looks deceptively simple, but I think it is incomplete or at
> > least adds to the current confusion. A couple points to consider:
> > 
> > 1/ There is no corresponding clear_bit(CXL_REGION_F_AUTO, ...) anywhere in
> > the driver. Yes, admin can still force cxl_region_decode_reset() via
> > commit_store() path, but admin can not force
> > cxl_region_teardown_targets() in the __cxl_decoder_detach() path. I do
> > not like that this causes us to end up with 2 separate considerations
> > for when __cxl_decoder_detach() skips cleanup actions
> > (cxl_region_teardown_targets() and cxl_region_decode_reset()). See
> > below, I think the cxl_region_teardown_targets() check is probably
> > bogus.
> 
> Rather than repurposing CXL_REGION_F_AUTO, this splits decode-reset policy
> from AUTO. A new region-scoped CXL_REGION_F_PRESERVE_DECODE flag is introduced
> and cleared on explicit decommit in commit_store(). AUTO remains origin/assembly
> state.

Just like the decoder LOCK bit the preservation setting is a decoder
property, not a region property. Region auto-assembly is then just an
automatic way to set that decoder policy.

So, no, I would not expect a new region flag for this policy.

> This does still leave two cleanup decisions:
> 1) decode reset (now keyed off PRESERVE_DECODE)
> 2) target teardown (still using existing AUTO behavior)
> 
> No change to cxl_region_teardown_targets() in this step.

Turns out that cxl_region_teardown_targets() never needed to consider
the CXL_F_REGION_AUTO flag.

> > At a minimum I think commit_store() should clear CXL_REGION_F_AUTO on
> > decommit such that cleaning up decoders and targets later proceeds as
> > expected.
> 
> This point is addressed by clearing CXL_REGION_F_PRESERVE_DECODE instead.
> Explicit decommit is treated as destructive and disables decode preservation
> before unbind/reset.
> 
> > 
> > 2/ The hard part about CXL region cleanup is that it needs to be prepared
> > for:
> > 
> >  a/ user manually removes the region via sysfs
> > 
> >  b/ user manually disables cxl_port, cxl_mem, or cxl_acpi causing the
> >     endpoint port to be removed
> > 
> >  c/ user physically removes the memdev causing the endpoint port to be
> >     removed (CXL core can not tell the difference with 2b/ it just sees
> >     cxl_mem_driver::remove() operation invocation)
> > 
> >  d/ setup action fails and region setup is unwound
> 
> Agreed. This change targets 2b, 2c.
> 
> >  
> > The cxl_region_decode_reset() is in __cxl_decoder_detach() because of
> > 2b/ and 2c/. No other chance to cleanup the decode topology once the
> > endpoint decoders are on their way out of the system.
> 
> Agreed. The reset remains. Proposed change only makes it conditional on
> explicit region policy rather than AUTO.
> 
> > 
> > In this case though the patch was generated back when we were committed
> > to cleaning up failed to assemble regions, a new 2d/ case, right?
> > However, in that case the decoder is not leaving the system. The
> > questions that arrive from that analysis are:
> > 
> > * Is this patch still needed now that there is no auto-cleanup?
> 
> Not for this Soft Reserved series, but yes for Type2 hotplug.

Type-2 hotplug is not the issue, it is boot-time configuration
preservation over device reset which is a different challenge.

> > * If this patch is still needed is it better to skip
> >   cxl_region_decode_reset() based on the 'enum cxl_detach_mode' rather
> >   than the CXL_REGION_F_AUTO flag? I.e. skip reset in the 2d/ case, or
> >   some other new general flag that says "please preserve hardware
> >   configuration".
> 
> I looked at using and expanding the cxl_detach_mode enum and rejected as
> not the right scope. The current detach mode is attached to an individual
> detach operation, whereas preserve vs reset decision applies to the region
> decode topology as a whole. If we expand detach mode for this region
> wide policy, then may risk inconsistent handling across endpoint of the
> same region. Just seemed wrong place. I could be missing another reason
> why you looked at it.

Regions are an emergent property from decoder settings. Decoder settings
come from firmware, user actions, and with the type-2 series driver
actions. Firmware, user and driver actions are per-decoder especially
because the behavior needed here is similar to the decoder LOCK bit.

Region assembly can set a default decoder policy, but the management of
that decoder policy need not go through the region.

Either way, settling this question can be post type-2 base series event,
not a lead-in dependency.

[..]
> > It is helpful that violence has been the default so far. So it allows to
> > introduce a decoder shutdown policy toggle where CXL_REGION_F_AUTO flags
> > decoders as "preserve" by default. Region decommit clears that flag,
> > and/or userspace can toggle that per endpoint decoder flag to determine
> > what happens when decoders leave the system. That probably also wants
> > some lockdown interaction such that root can not force unplug memory by
> > unbinding a driver.
> 
> As a step in the direction you suggest, AND  aiming to address Type2
> need, here is what I'd like a direction check on:
> 
> Start separating decode-reset policy rom CXL_REGION_F_AUTO:
> - keep CXL_REGION_F_AUTO as origin / assembly semantics
> - introduce CXL_REGION_F_PRESERVE_DECODE as a region-scoped policy

Not yet convinced about this.

> - initialize that policy from auto-assembly
> - clear it on explicit decommit in commit_store()

My expectation is still clear it on decoder configuration change, add an
attribute to toggle it independent of changing the decoder
configuration.

> - use it to gate cxl_region_decode_reset() in __cxl_decoder_detach()

cxl_region_decode_reset() just automates asking each decoder to carry
out reset if the decoder policy allows.

> The decode-reset decision is factored through a small helper,
> cxl_region_preserve_decode(), so the policy can be extended independent
> of the detach mechanics. Maybe overkill in this simple case, but I
> wanted to acknowledge the 'policy' direction.

Appreciate you pulling this together. I want to land type-2 with the
existing expectation that unload is always destructive then circle back
to address this additional detail because it is more than just decoder
policy that needs to be managed. The type-2 driver may need help finding
its platform firmware configured address range if a device reset
destroyed the decoder settings.
