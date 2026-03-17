Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E533A2D8798
	for <nvdimm@lists.linux.dev>; Tue, 17 Mar 2026 02:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773713696; cv=fail; b=J5+HM1OpfJFWQiStc0tigop5M0AOU0CSilb2FcoBgArZCBX9WPdJ7tTRlZHO8ie++tfq/+72ncmKnkZxeVn5FOp1G/bJ5Po5poOwU6DO8f4GRVt5dir/8SzcAKNgxLgkLr/Wpq4XCmZ/IUuESrandIuI5rrPyVqF7SnRCHwK+bI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773713696; c=relaxed/simple;
	bh=sVRxH7UVZOmeesDR049K9lS+h/cUI2gBTpal2728WzY=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=XKAGqQ0vs79vV+MP06gxO98IecRm+x5wzLI0iqu6pdhmo3qLXvTqy4XAPmrzTy17BeWdTvzAXIvhQQo6ULU5ecxXeW7d/Wle/hPvmB9NNbdmdGSk8ljf/OscXRXH3CAvqrcFmpbrXXruo7ED0mwhGLAi2ynRQYxJs95sBAtsz6Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R8yjBRkT; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R8yjBRkT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773713695; x=1805249695;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=sVRxH7UVZOmeesDR049K9lS+h/cUI2gBTpal2728WzY=;
  b=R8yjBRkTNzukkPUEf/65QQJhkrtWJaOMYsrOqZnEJrzWV/GZgVrSMOr2
   13+sFjxanLClzW/JAmcYgTbow/j7mldLZpj++0fPj9XSGr7t7tqVPdoaj
   IFC1XqDWjYLHH5iqUVMVKE/UlttpYF/ZYBCY+ItwgGJxiIlyf+RN0HhtS
   79IURz8OAwgRaMa60JeCzc74SJ+Y+tIsMCkk+K7r0QPju7mlu5pGjiWjX
   zp48qLqkxm/UbRLKwU/KFo7h+6wNW9TBUhiYSEjmGscwe/rCimJbebNNA
   NME2mJsXAzRyU6q/xa++3iQeo2QOtnOku2uTq9KVKEcT2Kr/la8NXpSeV
   A==;
X-CSE-ConnectionGUID: oiGARui3QwGAOFq69P7hAw==
X-CSE-MsgGUID: NiX5YNZ3QLaSxRPoUrPsUA==
X-IronPort-AV: E=McAfee;i="6800,10657,11731"; a="86094958"
X-IronPort-AV: E=Sophos;i="6.23,124,1770624000"; 
   d="scan'208";a="86094958"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2026 19:14:54 -0700
X-CSE-ConnectionGUID: cNz5eil1QuOvGdJ2CgOb1g==
X-CSE-MsgGUID: 7J3uts9rTZuA5X22STTJlQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,124,1770624000"; 
   d="scan'208";a="221138540"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2026 19:14:54 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 16 Mar 2026 19:14:53 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 16 Mar 2026 19:14:53 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.29) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 16 Mar 2026 19:14:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hj47bO/pWZz3Q1/+WSEmt0ijx2QWtM9hfU9VZx7uNlSf73niI+Dcd63lhXvA1l7YnJYW+Dvok699jtnjuwdU9KxQZUMxhQhJttHMz/JVFtCYrWT7nmv9Gh1JrByT6hCgJYV9U/LJZejBV6gXAceL6xp4lfuvLKmCYw/Itx61W6e5+pvsuEP884L4+KMORF5Oofb0tSrM/oo54udjXTuMc2SA8aEat/L045MM88GVKg0icbjpwpMEVB8OgHhEb9Yy84UA1Jw9lKakObS4B/dvUa+FJ0r06d9dY5c7jQHj9nbR28B2lYm9sB6aXfUhlmCQ4sqrHoJrzFcYbFR9kO4PaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JNWR/ek7v9Wg7MerjJezgXBxBl9jBXPQmZJSvqqDdP4=;
 b=gCJHJZfARZEnYuB/UiF0tZJxQhfaSDx6QtjUsE3lRxvxd9d9bwqHzm1WwfQ82xrfOHEVQYeMtl+kVV2WFckEhHgTmHg12r9Z7qIaMOZAouEbrxPE2u0kYnyesuN4Dhpa3j1FY0x97EgtKX6eqKejxS3pvaFJjSoiLtFMkropWyGbfYBBfeKINP8F/Ry18z2Qb/XIItXfES8badwN6TBKZEH5/+Irjt00y7HQ7kAPT61TnF3AcXzzoXYG8O/TOkccdn85IIBzwaTxlRxVpRSESGT5HdXNTl5tD1Bs5Qz4Lht2LkTdmACdT7tzDOrJQtiqBKEvl4CtC65bC5NepgSZRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SA3PR11MB7463.namprd11.prod.outlook.com (2603:10b6:806:304::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.8; Tue, 17 Mar
 2026 02:14:49 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%3]) with mapi id 15.20.9723.014; Tue, 17 Mar 2026
 02:14:49 +0000
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 16 Mar 2026 19:14:48 -0700
To: Alejandro Lucero Palau <alucerop@amd.com>, Dan Williams
	<dan.j.williams@intel.com>, Smita Koralahalli
	<Smita.KoralahalliChannabasappa@amd.com>, <linux-cxl@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-fsdevel@vger.kernel.org>, <linux-pm@vger.kernel.org>
CC: Ard Biesheuvel <ardb@kernel.org>, Alison Schofield
	<alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, "Ira
 Weiny" <ira.weiny@intel.com>, Jonathan Cameron <jonathan.cameron@huawei.com>,
	Yazen Ghannam <yazen.ghannam@amd.com>, Dave Jiang <dave.jiang@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>, Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, "Rafael J . Wysocki" <rafael@kernel.org>, Len Brown
	<len.brown@intel.com>, Pavel Machek <pavel@kernel.org>, Li Ming
	<ming.li@zohomail.com>, Jeff Johnson <jeff.johnson@oss.qualcomm.com>, "Ying
 Huang" <huang.ying.caritas@gmail.com>, Yao Xingtao <yaoxt.fnst@fujitsu.com>,
	Peter Zijlstra <peterz@infradead.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Nathan Fontenot <nathan.fontenot@amd.com>,
	Terry Bowman <terry.bowman@amd.com>, Robert Richter <rrichter@amd.com>,
	Benjamin Cheatham <benjamin.cheatham@amd.com>, Zhijian Li
	<lizhijian@fujitsu.com>, Borislav Petkov <bp@alien8.de>, Tomasz Wolski
	<tomasz.wolski@fujitsu.com>
Message-ID: <69b8b9181bafd_452b100cb@dwillia2-mobl4.notmuch>
In-Reply-To: <df9cfac5-7e01-422f-bd29-d1b8b3c55623@amd.com>
References: <20260210064501.157591-1-Smita.KoralahalliChannabasappa@amd.com>
 <20260210064501.157591-4-Smita.KoralahalliChannabasappa@amd.com>
 <69b1e0aacb9d0_2132100c5@dwillia2-mobl4.notmuch>
 <69b319d7e6adf_213210086@dwillia2-mobl4.notmuch>
 <df9cfac5-7e01-422f-bd29-d1b8b3c55623@amd.com>
Subject: Re: [PATCH v6 3/9] cxl/region: Skip decoder reset on detach for
 autodiscovered regions
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0016.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::21) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SA3PR11MB7463:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f4b509b-3eec-46c0-239f-08de83caf7bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: WwFyWTmi0/niM+pDwxpCQoLL5n6s1rseuPRqyvElCpmxrLgZl0LhZ7TP7Ygv76Q07inYI+au3HyOS2xoA0y2RG2dDi3wKTgbDjsM8DJhbC4Xu7596JbHnk2J+tBc/gfWRrubboIW5/Z/arDMms4ht9lihnZ0FhA59SCvBQoI5JOLpkerOh8gFKK5nPwXbnd7J3P/Fb/CXzvvUg9E8fNHZBu0njJfm5draGv70t3tjG+/vHn/Rdo+L2gJOQS6LeZ6+4NNWl1SJgk4CXQDNgmQ2JjrXIct9HvJz/ijoMKf2mqf4tpWXhVXaDnH8wVORByAbLwZsNS32JjyKhcixhp9T8+CTIi33ep8hr3E9oopMMYzDvXWOQtKG5Qbd+kCwg6OXoHZMqJ5Kl51lU8EUp+s9sjodlKJzL26U70rNCylnPu8t1EIcVNy3HyfR6asJCjbaf3ne9hgwzSEDu8X3v1WuWSOeHoq4ZCG/Yr2w7n7Mg6f06Xd8gxOhEHFRRDzGUKH7s5bgOKCvsbPC6x4Kdb7fDs/PFus/ySclH58QzoTw0xBmn78yi94GHBwW/LTZ8QMMdgIoQKLmKhOjImNBhuXWLt3DvBeCjGY+pgxmvBjpr9FE3iLHoDHOq5GK3DutIm+adeA/bIz+W2ccEPE7QKdaIdV11GW3yN8Ri27druAG7lPqHZe1YGOT3HdOeRcLz+vfBg3SHNjBTlc2NwcVg7OcuTpwGHwj1PHi10IZwEX+vQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bnBodlRXcGZzY0JqZXZsS0duR2NxeTM5YkFBcUdEc25CUWJ0RmFEKzdXZTdU?=
 =?utf-8?B?UUlsRVVsYWQ1TnBMa0hNaEliMmRZNWVwTEIwOUJZdFlmeXZBRlM2ODArUDFC?=
 =?utf-8?B?NzNYRHBkQjhDMTc0elA0VHU2a1M4bXBBQjBDTkxrN0s5WE9LcDRDUFNXZW91?=
 =?utf-8?B?NU5QTlhGOXVzR2FCNTFNdGh4c09iV0Q4NVFJM2dpLzVDQW44NElPUmo2Nklr?=
 =?utf-8?B?WG9tZS83RjJWR284TkNUREJKZWtjb3VGalNyc1dnUWptT3k1ME9xcU9uV1Rh?=
 =?utf-8?B?cUQ5d2xwbXh4MlNLUzZsV3RTRUlkeXZYcWJqVS9ha0Fhc0Z4c002SWZBYWFJ?=
 =?utf-8?B?Y3QvbGpnQWJsMXVQYnpwT1V1a3YyN1krdmN5emlqWmhNbXIxTUZXWlBIbFhY?=
 =?utf-8?B?eWRjbGk4bGpkdVNBK3E1WXlEV1ZSK1ZtSXFRRmx1QUIvQzE5R0I4eU8rdlBT?=
 =?utf-8?B?V2lJdVFuWllNOWpRc3RkdVJVUlppckRJQy9GTnlKUGVxL04xeW5yNjNKL2pv?=
 =?utf-8?B?NWZBK1o3c28vQkpSaTlONzVvbHdlMm9Bd3dxTldIbUc4cUt1Ui8vb2tXZlQ5?=
 =?utf-8?B?bTJnN2pFTGZTZHhZaTEzSmVOV1I3alQwaHNUdHRVQWVyRktMeE9tR1RHWStU?=
 =?utf-8?B?c0pOTSttbC9NM1A4Z0QwSlBVa2M5TlJHN3lhSUU1NXVjVnM3ajYyVkdZcXdy?=
 =?utf-8?B?Rk9NSVlaVTlwdFpzQkMrbUQxT3ZINzhmOXV2Y25sS080QXdBcURoUGFrTWMr?=
 =?utf-8?B?eWlwNDN4SUZEOTJjaXJodWxRZVppZ2tvcjB4N1FKVUxBRFM5Wm9ST1pqN2pl?=
 =?utf-8?B?cFhSampKaHRNWXNwVFdGbWV4RHdsNjFweUlRZWNFaUpObGRKdWdIdm83MERn?=
 =?utf-8?B?anFUMDVkUjhCV2IwSHRqSldjSVZXYXRLYzh0NlY3SGpxS2RLbFJDTnV3dmsv?=
 =?utf-8?B?UmVwK0xJdVJUK08renpMWU9BTHRmWU55eFgxa0JRR08vUk1vdWRrYkIzdEZW?=
 =?utf-8?B?eTVISmJBQ3JlRlJZbzA5OE1idHEzUS9uek43S3V1alU1N21Ubm5oZ3loK2NS?=
 =?utf-8?B?OHNOeDRXaUMvVW1aZURoajBCUXpnQ05uZVVQanhYZWQ4anp3eERHQW1Ydldp?=
 =?utf-8?B?VmZubENYdUZyVDV3V1UrSkxFeG1tK1RzdGl1UndhRHBUemRWN0NXTFl2a3Zx?=
 =?utf-8?B?bmdIQWxyT0xtUjlQYllLc0l3a3hVK1hDaUxnc05PY21NeUhUVHlDVmVrNDF6?=
 =?utf-8?B?c1F3SVVLYTQ0YTdQejJjUDRNS1VtblRnaUhEYnJiN3RXeGJRc01oY2J4TU1o?=
 =?utf-8?B?OE1UUG1JSFVibUZwNnVMUFhtU2tzOXpRVGpuZGsxb0puK2xNenlTcGhWK3ht?=
 =?utf-8?B?Vm4ycjJiZjYrcHQ0cUk4TS9QUWtDT3VDZTB1aTdUaXQ5TEs0UGNUZmtmY1NW?=
 =?utf-8?B?Rzd3MnRkRkZOUDJXY0hYRnZPZzI5NkY5WFlGWEU4cCtCT3ZOZXAwTDFaVzFJ?=
 =?utf-8?B?N1ZUMDZJQnhCaU5EUHUvOG96Tks2bWdQT29qNmpMSjNHaXFLdElJM2VzWTBS?=
 =?utf-8?B?NzZwdTRBMk14M0N5YjFZRHltdmplcnhIV0ZrSnlXenlqRXM2WGdTcFA3dFdT?=
 =?utf-8?B?OURrcEt0TUkwWDRUcXA3VUdXcVJIYS9hWE8zSURJNytQNUhaMVZ5MmtUWkNi?=
 =?utf-8?B?bnhmK0V2SUJsbnA4VFZIV3B6TXNxSERiYnNmdDUwOHFvbUY5SUh0QlZIU2I1?=
 =?utf-8?B?RS83NUFNdzQvT3RXOTgycWJvdVpUZGxwbXk5L0t1aDFMUkpwQWZKLzAwVjF4?=
 =?utf-8?B?bGRXKzFST1J0L2JtZ2NzVjVFWWJrMkRyTm1rUVYwWWQxazRJK1kzMDFMQ3hj?=
 =?utf-8?B?R3ZGdHV6RXlacTMybUp4eTN4dWlxU3kzbmNKYkhod09jOFRSa2ZObjFGaDBr?=
 =?utf-8?B?bzJ5blpIZVNoZUl6azJhL01RSFJRbDVmeTNVVkVyR1kzQ3Jodk1IMkZUMisz?=
 =?utf-8?B?M2NuOTAweldZaDhra2RIOWRVYWtBOWhRY1N0U29KTDlTT3Y3bDVCalMzQ2lR?=
 =?utf-8?B?VktuQW5ucmtzcUppSW96YTQ3VmtVdkcwM3pBY2ZMaEVJeDFHTkVocnoyUmNt?=
 =?utf-8?B?d0VQc1BSYnNEeFRaMkxYWmZYR3NQdlI4ZHZmdzB0Q0E3cld2K1NLL0h1dWVm?=
 =?utf-8?B?WTR2alo3UE10OWRuQVdFdWdreWd4eTBzQVNlT2hVVWZIRVF3TXhFa2QyZHJI?=
 =?utf-8?B?bUZiV2ExS3pJellLOVF0UDNtTjBmbVJhdTVsNWRqQ0E2YlErUDdNaTlZREZj?=
 =?utf-8?B?clNGLzVOd29LUERVQ053L2ZHZGlSVGVOa3VJR0dUS05LQ1JwMzQ4eHdyakkr?=
 =?utf-8?Q?L1P4J9LtNdVp2J58=3D?=
X-Exchange-RoutingPolicyChecked: RX4p+0fkl4gG4a6Sqv+Rz90YLBPNLRrWA5P8ZIgs+WdfSkJYsMggxT1SYhrv/KgRx+xAVUjapVvf4JCIk6zV6LVftFuQIkSmWpYhbQoWJeNWEUuYlEcAllyZvTfRxbaax+n1ajNl4yTSWSlbJuUvwQNYaVUWvUuSmNsOc8NyUBeuTtRkzqL75u0ZfHVDtjNC2URm9c+1GxCtAbxNQOqujF9057uwLYbZ3n9kOMe2Ez0MEs+/UpLbHljsbSDzsD2mPaXqLfcrj/A/MacC5EXS6IV+fe7cNMZcsLyYADQbVdlaYfwkG1Wn6pBFvb0UtJQfH8rpI2HhQlOk/eUTUflIOg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f4b509b-3eec-46c0-239f-08de83caf7bd
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 02:14:49.7425
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hSIFtnD/E5+yx7gMR0csMKPmNJ+ryRztns/bSfCvOC4aBtf/kM53hUueJSwIXVJfu/vh2kudRdCQDYWjHdnvVwgzU7avtpUsvEUq2upLMwo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7463
X-OriginatorOrg: intel.com

Alejandro Lucero Palau wrote:
[..] 
> This is not the first time I share my frustration, and as when I did so 
> in the past, I want to finish with a positive last sentence: I will keep 
> trying to get type2 support and hopefully further CXL stuff, and happy 
> to discuss the best way to do so with the CXL kernel community.

I did not mean to imply that the type-2 set was stuck behind a new
dependency. Apologies.

It is next in the queue, it needs to go in next cycle with a high
priority.

In my view this confirmation that Smita's proposed patch addresses PJ's
test failure cleared one of the last hurdles for this set for me.
