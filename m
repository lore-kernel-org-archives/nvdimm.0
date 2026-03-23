Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A0A23DB64E
	for <nvdimm@lists.linux.dev>; Mon, 23 Mar 2026 19:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774294649; cv=fail; b=LUZr5fIC+mpZ4lmiyuQr45J3RnKz1zr91tyUp8001uiPQ1dzwGqDFs3U46BT1l9YCluo4UVw5Y4IdJWzwCbAXZZETjQZ2L5b6K0mQbFkdw+GgTX19p2uSsyOqQvkzTsOADZxU0am2Qhafvp5aklktyRjWLFWI6g7enZNeEd/UWA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774294649; c=relaxed/simple;
	bh=Q0gtYEABJWpQDv/ZIQP/r+Cg4xRB3HQGUvHNs13nY4c=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=iOpg03Ky/4qm1TjtF7JAYA8erYXoRXBDB2W49HSfMch3jV7oUicPszXDxXKKNgHbrFt2/KAB8WmLvGuYZNkrvcw1ocIt8lTxkHLJdhlo/RtuYpL8j6NdTMwcRkJhY2DDOunUvUg66jBBpg93wkjcbTjOHYE+0XdG3nTGd4L38+I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ayO9PiaV; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ayO9PiaV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774294646; x=1805830646;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=Q0gtYEABJWpQDv/ZIQP/r+Cg4xRB3HQGUvHNs13nY4c=;
  b=ayO9PiaVsparLPm6ZWxLoWNfagCdzgEizMWX3wodrQMf9RNzEsmNxT08
   YeqqqixN7EggVOmGU5tkshMx+YzFVy5uCzBha4QfFVvYjrIFno3Kv4Jmu
   CEOZRRlZRgQzuZpTRJktKAvH+qmiUpSG++WpEDSyRB02CRqalZKzTOPR/
   JpL1Jqea9ug0MZpYfUE1PelZxz8D2SI/gB99m9fSaIlSltFOwLx9hTTCW
   cJYNe7+DpzkOPRuQp69O+AhWJlcpevlRddukm6MLPUmkDLSnhhZfhEze6
   rCPU9+hp/g/1kk0Hps1hS+L4L2wk5l0TKP95UadyEpEVHNDMvDoFvQsyP
   A==;
X-CSE-ConnectionGUID: joaoo4PIQFCkEcTzMc6LkQ==
X-CSE-MsgGUID: 8jnpNtL1RAWzrRNOIL9xGg==
X-IronPort-AV: E=McAfee;i="6800,10657,11738"; a="75183836"
X-IronPort-AV: E=Sophos;i="6.23,137,1770624000"; 
   d="scan'208";a="75183836"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2026 12:37:25 -0700
X-CSE-ConnectionGUID: 3ieJaH69Sq+OTqx6RrJavg==
X-CSE-MsgGUID: 5fpB9ke6Qdu2jU0Ao+vDag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,137,1770624000"; 
   d="scan'208";a="219718751"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2026 12:37:23 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 23 Mar 2026 12:37:22 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 23 Mar 2026 12:37:22 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.11) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 23 Mar 2026 12:37:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NqVvE4q1SwG9wpHUOqKaRyB7ac4NE5uaJHytIGLswswO2YSyn0Kj8GToKtg46ei+gyxZzSehTiutug0MRB6p6L7Pcg0nO7lxqhGKSSwv673jBOe8a/52dogRopV+CGGZsVtCWRsSSiRH2OAiYyiPv52hXLpq0ZPE24CcuHcnIsk4mhfKFbof0SNAIw+XC2i4QXnAZggsRu0ZQFlhRgaLPsaOsFS8buJa/7IaMEE0v6zkMlLAaaHx3g6IGd0t+Ab21NzHjX3kwrmgmsDoYiKh5mNdzpdMlU7AvtDhUOYhs0Na0fL+GyRn5qnXvjHuLLp9pPn1ft+dQOHejFKndoIcaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=efP1mmhdevhHP7UJIhfwdAhsMQo71n546IYpboBT21g=;
 b=G5mHyAGO3XgL4183wDJ2JhooIUvrqSn/Z7dwroreuEjfaLyYa4IhtqAvEPRIMiz3BwZC586ufi6JFcmtakffp1QZWgpz42hvHafQ8Y0a0XIVJbyswv0hZqdHWek+W/SbZBhl02+Bj7OQ10mhBl2cvTMcV89ywylgF4MOVd0PCfts0uO6yiuapzJwDPMOWoNSFlOLARN55qH/1r6qUMHcfjgoMJtAB+fqH1YT65y/FkCfKZkiNr2fTKvoJnXaKAissE5pTx5q67U44OaZujsZaz/iLHkXPfquj4SdZOr2nO5zrjyeL2HHqfEOfMuOLPDY/jyKF4XHWHUUiJDMwCClfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by BY1PR11MB7984.namprd11.prod.outlook.com (2603:10b6:a03:531::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Mon, 23 Mar
 2026 19:37:18 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%3]) with mapi id 15.20.9745.019; Mon, 23 Mar 2026
 19:37:18 +0000
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 23 Mar 2026 12:37:15 -0700
To: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>,
	<linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-fsdevel@vger.kernel.org>,
	<linux-pm@vger.kernel.org>
CC: Ard Biesheuvel <ardb@kernel.org>, Alison Schofield
	<alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, "Ira
 Weiny" <ira.weiny@intel.com>, Dan Williams <dan.j.williams@intel.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>, Yazen Ghannam
	<yazen.ghannam@amd.com>, Dave Jiang <dave.jiang@intel.com>, Davidlohr Bueso
	<dave@stgolabs.net>, Matthew Wilcox <willy@infradead.org>, Jan Kara
	<jack@suse.cz>, "Rafael J . Wysocki" <rafael@kernel.org>, Len Brown
	<len.brown@intel.com>, Pavel Machek <pavel@kernel.org>, Li Ming
	<ming.li@zohomail.com>, Jeff Johnson <jeff.johnson@oss.qualcomm.com>, "Ying
 Huang" <huang.ying.caritas@gmail.com>, Yao Xingtao <yaoxt.fnst@fujitsu.com>,
	Peter Zijlstra <peterz@infradead.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Nathan Fontenot <nathan.fontenot@amd.com>,
	Terry Bowman <terry.bowman@amd.com>, Robert Richter <rrichter@amd.com>,
	Benjamin Cheatham <benjamin.cheatham@amd.com>, Zhijian Li
	<lizhijian@fujitsu.com>, Borislav Petkov <bp@alien8.de>, Smita Koralahalli
	<Smita.KoralahalliChannabasappa@amd.com>, Tomasz Wolski
	<tomasz.wolski@fujitsu.com>
Message-ID: <69c1966bba13_7ee31000@dwillia2-mobl4.notmuch>
In-Reply-To: <20260322195343.206900-2-Smita.KoralahalliChannabasappa@amd.com>
References: <20260322195343.206900-1-Smita.KoralahalliChannabasappa@amd.com>
 <20260322195343.206900-2-Smita.KoralahalliChannabasappa@amd.com>
Subject: Re: [PATCH v8 1/9] dax/bus: Use dax_region_put() in
 alloc_dax_region() error path
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0064.namprd04.prod.outlook.com
 (2603:10b6:303:6b::9) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|BY1PR11MB7984:EE_
X-MS-Office365-Filtering-Correlation-Id: b6151669-45ca-48ce-ed71-08de89139800
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: a6yanbmgHBcIrD6IfwYouaKclqLssSJxDANuOPJ5Iikw2TPEOA1ZakFk/dx6lgytMeWvWdLn6KNt2ZztGHUfYYqm0NROJwadW2oOd4hA2YeeGrxo0TcsI/n55PUaJ5xfGT+b2oOL3PWaifCthVeTMPh39zbxEVHBXxw0GNqejTHnUk8XgK/6IOwY3FshOpsyb3ALiZwqucq/duX7mH7aPuG5PaTYHDG3Y7Bc1yDqfF9fseb2ovlkrgh5nkqYE+Mp26FlQcEAgznVJqLONbWL4hqyYUoC6A5qxmOXDTSTmFUSyx50zktSK7Hk5UtT7T1L4WYd014DUzdS/RXVf0k38iQ9LpBYRMPZTdPgiczeR8/Ag8ZsFetKgqtQ5cNtMQhxPVMVlB6a2TqiwHcnLe5cTxolsO5Mcd/wATD/32pi/wFpI78TWAGgPDu1+5YhFD3x4KCDtaHo+/lgl+0TH7jQktd3UG90H1zCtieYY2W8OWLh6IXW+EuxvWilR8rnG1y2W2LRk9dRjTqdNOSZhsS31rQRgbiVORqtPYTx0H7ioyMuSogZENzM+feiu1rmtCswz5inWFd+p6frwEH9QCwzxth1W0OU97IgimnJzDwkQMHMOuAj69zP0c678U3Ia5pvbkIZ5Jax6MMnpEFypWH7L9/OpPdyX1p2yD6SniJ9qgjl9PyLMQMBtYY9Z/yqaG5Gw/EqS+2YM/GS0bEDhcJLAB7EjYhR9CULDWXTfzKS//A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cHJvbE9BQm15eFVoYnpyRnB2ZUU3Ym9rcXF2VE81a1VTTFVLd2xHN1FtbXdX?=
 =?utf-8?B?UDQwdmp0T201KzlIZ2lwUmdhNVo1NDc5Y001UE1CVTRWZldlbXA2ZCtIQzBp?=
 =?utf-8?B?NXBDN2hSVjF5THVSSUZZUjNqZTJxcW5jUDZaOFVtMUhHTWh4VTRpVkNtdHF2?=
 =?utf-8?B?SGt2MjZlc0wrY29RNnF2T1QrNTZIRjc2UzFxQWVDdHp3WlhNN1NIaFhQMlpD?=
 =?utf-8?B?Ujh5bkJYSFFpekx0ZVVRYVNYeFEvNk9yNUE2bkxmVGZGS2ZYejh3NEs0L0N3?=
 =?utf-8?B?UnZDT1BIM0daaGt4M1VjU2VlVHJJNU9YR0pPN3ZPK2NONEVISWxhUlVLckZK?=
 =?utf-8?B?T0Y2R2QwUHY0dDl0RTJ3cTVxMlRXMnJneGhQMFk1RnUvbDBqVllJTHRtajdv?=
 =?utf-8?B?L05ydVpJS1R0RkRXbXB1WEMwZUh5S2dhRk1TU2VoN1VteHVzZEx2emM2bE1h?=
 =?utf-8?B?VWFUTjFsRFlDZ01LazhZTzNVVmlGTStLZkNaR09WSGovcVYxWE1FeDFINk9U?=
 =?utf-8?B?TWFZMFpETThVdGJEUTA3c1JCSmlSUGh0V3pJd0Z1dEFJdWExNnVPdGs1dGFw?=
 =?utf-8?B?SXFZOVNaQ3VUNzdxYndCV0pDYTN1b1R6Sll3NEJLamkyanAwVjBSdEQ3TEs2?=
 =?utf-8?B?NE9CNmloelNnU1VtS3BXY1hJSVZYdVI3cWNvS0ZQajAvckhqWjhKN2lTYmVl?=
 =?utf-8?B?UjNQWFAzdXErSnlHRlNiZTlEUCt1RVFGWFZxaHRZRVJPdThsZlVZNWkwLzFX?=
 =?utf-8?B?MkU4TThnQmZuYlFId0NzNGlFZHNWQ0tJMm8weG5YMCtEdy9EZ1FQMDlrR3o5?=
 =?utf-8?B?UzZabllXcE52Mk1ZU2JjSUk4QVJlaUI3bGRXY0psQVNDcVlKYUR5aDlma1hN?=
 =?utf-8?B?MzhraThWZC8zTUJZdWJIRXFlcUlEVWJ6cWRWUVpaRzFJYlROTXZkVFJIdE5m?=
 =?utf-8?B?UTNCZ1JuRUV6c1Y2b2UxdUUvZGlxVjFpSThvenQxT0NjTVYwSkF1RC80L0Uv?=
 =?utf-8?B?STJ1REdEdE1aZWhKdjVaRjQ4RzQ4RTVyTzIzcGMwSk96MFk3dDlqbTVtaE5J?=
 =?utf-8?B?bXp2WGsvQkpZc1c0ZWNLYjQ0S3FqVGh5Ty9zRG5WRlJFV01ydFZCSXRSVm5l?=
 =?utf-8?B?empXczlMU2EwOHhIditmSXp5djVMdUhCMEF6MEgwNE9LWWlaSXNFNDIrQjA5?=
 =?utf-8?B?NHRRVEZJdld3M0ZhajdlUFh2RW9BWFFqdzR2LzQybE5aaE94Ui9LWDU3WllO?=
 =?utf-8?B?QWNCYkdnNGtNQ1lkU2NNNnVmQ2JPSFI3Ni9SMUdVOThaM1dtTVBKVFNhNXJ2?=
 =?utf-8?B?cVNISHNwL1RkaUFrcUhhc1BSUGd4aHRGVkFJUzVnQU1NRHhyaTF3YnA0ZE1q?=
 =?utf-8?B?cWhUZU9icjRiNlIzZlE4bmxQaHJUc21GU0RjMkxPaE1qWnN5Ri8yOU5CcHpT?=
 =?utf-8?B?bzFuMGJQR0pjbkJ0NEJvdVRqck1UTUdReVJQUDJMTVdPQnNQQ3lBZ2puanBy?=
 =?utf-8?B?bFlsUXFHd2xBQkk3bStiWFArdkRTSFVkOFhZMWhDL0NRWllsT2p3VkppN0VE?=
 =?utf-8?B?RFJUUForMTVScmhsbHhsbXpkeWxhRmh4UjhNZ3lQNWxPdmVPUVoxdGxFN2Zr?=
 =?utf-8?B?NGJvN1lVaVJ4RS9XUlQ0ZFpHYTJPNnBSYXV3WGVEYU1RVU9jUkIwK2VXaHpF?=
 =?utf-8?B?UWlBUG4zUTZDVTFVYVFQVU9XZWUvOUlQZnNENmtESjdLYlhqOSsxc2REMVFv?=
 =?utf-8?B?bzYwNWU4OW9xTEpSN1lXOGFGNUNlY1hnT3VKSEVHeDdQSDJGWVk0Q3g1TG5E?=
 =?utf-8?B?VEcrU044SU52aC9YWlliQkdpUi90MEFOMWorUi91YUN6cVZiRVlIZW5kcHJz?=
 =?utf-8?B?V0dabGg2bGM3aWFkK0hkZDlvUVhPbzM1Q21DRzFOeWtsRXcyOVRVZVVzSGxy?=
 =?utf-8?B?N0FNaWFMQ0hxc1hZUFlrbHRzVmZhNFllcGEycFJsdmlXR2xldUU3VmFYdmhB?=
 =?utf-8?B?Ynd4cE9NMElMelhEdXZGQjRyeldEQ0R0V2U2QXBMRURSdWFXc2daaGx6ZFd6?=
 =?utf-8?B?SFM4ZFZwZzlmWExLRGdCSWhxNFJpMitCVHozNndlak5ESThMRDBXdklna3hH?=
 =?utf-8?B?TzdrOXg5aFNtVW52ZDVLZXZoVTRyOWVmSHpZai9UVXVueFlveUd1ZllnTThh?=
 =?utf-8?B?ZzN3WDZ1RFRhVmxtVUYra0M5ajk4UlZpNVMwUlNCLy9FYm11ZzRsdEJwYkVv?=
 =?utf-8?B?RHNvYnNibSt3dlp6VG5nT1FJdlBqZnBMZmJhcDd6WlJMbzNkVWFGbWNZdjlR?=
 =?utf-8?B?MjZVbyt3cWh1S0c4U3BSOHM0UnYrNmVIS3BHajVQaW9iNmVqakRjVndmY3F4?=
 =?utf-8?Q?/KaWWc5pGQI4XXXA=3D?=
X-Exchange-RoutingPolicyChecked: P3Wwz8sjlBhGyRtjpJoVDtVi/DfVIVMrEz3NIBhmBLMD4d1Ey6HsCycTRLZwtfWOeaffU8w5XC175VjjDye9sCSjACksK1GSgx+ReLBQadOgQQBWBRf4/5SWekcHsmLjA8XvKlTX7/lMJBiBsLsv4hweN7OTZGmu4v4ENdywFqjoZSxmDi5mRb/V/kFV0OpmxM8DUtUEnTEsr/C2QyOhbFPeMAaGdqqasFA9VfjO/3ckaY9gQ8glXOmkMy4Q2caAO007Dya/obZc8HoagRP9NpqrjqIu1XDYLdOQ93mZ66S25S/eJVBCGY9e57WMJJ6c55WDehP6B27u3x1SqUoJ+g==
X-MS-Exchange-CrossTenant-Network-Message-Id: b6151669-45ca-48ce-ed71-08de89139800
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 19:37:18.5411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TNxvNK3XEK6NEQkT7ig31tIPEFTx+U6tlzvFhFrfiGM5djJyc3FOV1Uqs9KjJpK4l20sCiLFKief3/gTz9dbSG7bTACeADi09NyFxLbp6Oo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB7984
X-OriginatorOrg: intel.com

Smita Koralahalli wrote:
> alloc_dax_region() calls kref_init() on the dax_region early in the
> function, but the error path for sysfs_create_groups() failure uses
> kfree() directly to free the dax_region. This bypasses the kref lifecycle.
> 
> Use dax_region_put() instead to handle kref lifecycle correctly.

There is no correctness issue here, the object was never published.

I am ok with the change, but be clear that this is for pure symmetry
reasons, not correctness.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
