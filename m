Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A61F350A07
	for <nvdimm@lists.linux.dev>; Fri, 30 Jan 2026 20:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769806722; cv=fail; b=qUPWMU4EA/5l+oyrHEnMMnZLlZGOse+4sgwjDlxZeLne7zRPZUivWD9x1/au/QJ67luVnr7S77PUIAzQgYJepi1EqDu5Kirxrs9oYDy2rvsD9B59+iXYJmb9hdywLbMbChMSQLAlFEEyq6pRtA6G4Dnl/F9+QV5M1A4l5WpbBJ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769806722; c=relaxed/simple;
	bh=KmJRBFnpjd15hLqClYAz+f2/8L+8YAJE1tFUWAarm3A=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NHkUI7HMuScRMPB6FkS6+4aK0SwY3kbWT0QeM9MYHT1cXcAgpztlwyvo76CTtx/Ph9yt6X0pG/t/A9igHtt+9jgPPTUqJoYNXhgCCVBkYKbEguGgHFE+3s1DifQWN1uhvKavDEURB+hB9slGxEV7GhSs6JC5FHUuuQT2jCpYmJ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HAp4vUMc; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HAp4vUMc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769806721; x=1801342721;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=KmJRBFnpjd15hLqClYAz+f2/8L+8YAJE1tFUWAarm3A=;
  b=HAp4vUMcUnyO5yNBU5yStUAivlPAHxA3JlUtuEgXJrW/eTwSMLAmwZqj
   VuWmHMG2xMwOzGGF59Qg26hUiMwxhOotlbbQVBB8dvd6HWthyzAqmZeF3
   51LwfvkI9Cw3HwCdRbcEDu00GFLBrlZkeYRGc0pHMat916xu3fSzM1T4u
   jkVVaJcWdPZNDV/e+dLt2BWR0DJamHAcRG5hswAQj2ExHU+8qhwLJUp6i
   qwQ78BbwhxIGlHX/z/DyW+Ny5tdeDZGNFNJGIn1cbSYk74EwYFlajF8qT
   ftL6gL9eUUdvvCBFkhdTz8khmk0aKQsGlA8isVIMxmgftkEcAt9R2wfEf
   A==;
X-CSE-ConnectionGUID: wG9Dq+3hRIWC/1to6Yk4cQ==
X-CSE-MsgGUID: 0pyZYgR4TaGrkV05cWqlEQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11687"; a="70972391"
X-IronPort-AV: E=Sophos;i="6.21,263,1763452800"; 
   d="scan'208";a="70972391"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2026 12:58:41 -0800
X-CSE-ConnectionGUID: pgbE+QTlS1eXkWkg3BSsjg==
X-CSE-MsgGUID: yd0gJX3fR/eMkWdFob2sFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,263,1763452800"; 
   d="scan'208";a="213471539"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2026 12:58:40 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 30 Jan 2026 12:58:39 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Fri, 30 Jan 2026 12:58:39 -0800
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.46) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 30 Jan 2026 12:58:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vY1M622X2zVRjhn2QHKS/8KdMliszVafsGqr8YuJq01KNxz22jj+kEZjXBBZaRP7IFTIE9W3KRP/KfdYlpD7Kix8Aexxt4mDF0ybaJqyPMIRQcGxVWZ51gkXjUS/ACXynRRL8nYlOJyNBIXglpCrAU21zN6ZkapILKn7cEzzhUZKBhhLgqyy4w8OTyHpqTpkJQb5uh1LmDYX8wS2dbwsWyl4tTHVwjK+OFjiOHbfYtZSLVvNFbdsNS6fzMd3Shj4dMJ+wG5uU3rlMkQA+PKp+RCa9CPOk+qQ40Ne+X6X/fp2VtbuAAkGfOLIL1iejNrUGYwiwdoAtj0dq8L39FdynA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KmJRBFnpjd15hLqClYAz+f2/8L+8YAJE1tFUWAarm3A=;
 b=fikFyE+ZHA1SDaoBEi9Vc6qmRUXGkb8OVyQ2yQBmXmBpRL+HKKq2/d/DEKSxCddr4NAHmRCwfoFMx6z2Zha+KLoTh4T6ohjBpkhuRXow/RA+qwp9+MjSw11HS/YXpT0tcTFfqD0VugD+i3fKMUN40WbF6pbzt3JDfPADa1R1Ofw2AdwDKpcNJnMS9guXywNJ/HOY0RVwpIa6BZ0OcHUnY7TzBWHcwUpiexkv6yh/5IggyB27L5OT1eiXeGu2OwFmxqigJEe0xgR3CYJbnEPfVPgRHvOJ8znp9DC5lnXhK/j+M2L/CT8fm5dvVq1AskL96xpDdjfdSZJLFTXeLqZBIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by PH7PR11MB8549.namprd11.prod.outlook.com (2603:10b6:510:308::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.10; Fri, 30 Jan
 2026 20:58:36 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::eff6:f7ef:65cd:8684]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::eff6:f7ef:65cd:8684%3]) with mapi id 15.20.9564.006; Fri, 30 Jan 2026
 20:58:36 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "benjamin.cheatham@amd.com" <benjamin.cheatham@amd.com>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
CC: "Schofield, Alison" <alison.schofield@intel.com>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, "Jiang, Dave"
	<dave.jiang@intel.com>
Subject: Re: [PATCH 7/7] Documentation: Add docs for inject/clear-error
 commands
Thread-Topic: [PATCH 7/7] Documentation: Add docs for inject/clear-error
 commands
Thread-Index: AQHci+eXEkQeU7kYMkKDkegRAYg3Q7Vpl88AgAGWTACAABB7gA==
Date: Fri, 30 Jan 2026 20:58:36 +0000
Message-ID: <34210a8339035800430a9d4084154e17c285ee86.camel@intel.com>
References: <20260122203728.622-1-Benjamin.Cheatham@amd.com>
	 <20260122203728.622-8-Benjamin.Cheatham@amd.com>
	 <4e3cf71a568f98a8349416874a7f08a5e5099799.camel@intel.com>
	 <dead69ac-86ee-46ff-ab38-c964935cda13@amd.com>
In-Reply-To: <dead69ac-86ee-46ff-ab38-c964935cda13@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|PH7PR11MB8549:EE_
x-ms-office365-filtering-correlation-id: 3c83007e-3248-427f-68f1-08de60425655
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?MUh6VHNJN3BsdU5jUDBmUHpBcUFPTmtZZVJYUWFBQkNXK3BodU8xY1V2QjRD?=
 =?utf-8?B?M04wSG5INDA1Q2FIVjNtMkRqajJ6bDh4c3lRT3VnY3kybGJ4SzhCeU5HZ2Fn?=
 =?utf-8?B?TzFZUUx3OW0yVFVvazVwVjRleTY3clRlcmZoM3F2NTBiVGFTMXgvNmxxUWUy?=
 =?utf-8?B?dlFONDJ2Qk9hRytQYUwvNE1QOGdEVFZSWXI0SGZBZWZkQjVJeFlOQlE5VnNy?=
 =?utf-8?B?VGtocWJCTldrV2Q4MGRaZ0lmTlRFZ3RZWVpxclIyZ25rZzFvVmFzeWtFZFJo?=
 =?utf-8?B?clJNcUNZM2JyV2ZremZFN1gvL3p2ZjF3dzhRZXZHS1FjMTREd3d1MEI2dkpj?=
 =?utf-8?B?REw0ZHBraW81R0xtRDdpNDVEYlc0cmo1MzA2aGljaTZ3NkVjdGVFTnhwUUEx?=
 =?utf-8?B?ZGcranpLYkF0dDVEWGpuYzBGcWNTRVFlTEJNU0w1YjBrTlM3QmJtbUJybTdL?=
 =?utf-8?B?WHZTSm9wRUVLNTRZc3ZseG9zZEtKVFl4bDhCREpFWG9vQVdSNldZVSsvMEM1?=
 =?utf-8?B?TmVmV0lIOU4veThGWUtnQU5MOG43TnRBS1U1S3RWRjdCczE2Zzg3OFhacHUr?=
 =?utf-8?B?bElBN3p0SjNSbDhwbFdjU1JQMWlyb0NqSnVabFNRc1JibGVSZ2lLSTVVY3Iw?=
 =?utf-8?B?TXVXNTI5OThGb3JteE8yZ0xWZXZVTDh3TUlxUEFlNC81eE5YcFhHVEZwV2wx?=
 =?utf-8?B?bWl5bUN6OWVxNWpZU1k1OFZsdkczeFlIVmpoOVVHa1VPa05SMmlSeTNLNGhZ?=
 =?utf-8?B?bkxtZVRqamRjMWRoOU5UNmkxOFY2SDRUYUZuLzhKcTRieUFBemd3dzQ2TkYx?=
 =?utf-8?B?M2wrN0tBUUhMRHh0bzJMQkppRnJ3eDh5RVdSblBrRUEwb2x5V25CS3VnaDdZ?=
 =?utf-8?B?SVBNMzBTZlVsdFBjQVpxQ3lhTjJTMGwxdk5reEVpcWJTdmlub0NFcU9oRzNM?=
 =?utf-8?B?SGtUeDdLVEZzUHVJSlNuN2laUEZibUZTREh2cWtTb1d5NHhnWXNzbkJkM0ZH?=
 =?utf-8?B?RUVGTFJpaUtWdUxPam1xR0VRT1F0V1JWWkFTVFM1NW5nOGl0RkJ2Y2pzNkF5?=
 =?utf-8?B?anp3eVdPcmNWSzVxRW94c1IrYWlSNCtiL0J2UCtQUnRsMVNsRU5yZVRjb2F5?=
 =?utf-8?B?bkNTYi83dU52ZzJ6QmtQcDBzSDNMem02V1VmRFhEM29oOVg0Z29WSC9PcGls?=
 =?utf-8?B?bkQ4UHpac0tSSDFCbGY0bEgrUnZMTDNick1IcHZ5bExFWVZLcEdlMWI2amV4?=
 =?utf-8?B?WW5SRlZYUUw3eHA5UU1TdDZkOGtaclI1Yis2L0FlaHE1UlVtZFRlZ0M0QUZh?=
 =?utf-8?B?Qm9lQkVWZDQwbys3QUtUQkkvRkZRc3RWTkZUY3BTT3NXRnJQTm9DY2kyc1pl?=
 =?utf-8?B?a1owT1JqQ0ZLKzlCV2lqMFpnMll5NzdmOEFPNnFEb0VPL1FsSGtCaTZMcTlQ?=
 =?utf-8?B?MkwrUkZPS2ZrUHBrTFFmRHpnRWNUamFHRllYc2R1bDJUOWR5NVBLdm5TdjRQ?=
 =?utf-8?B?WmUzZ0hFNWFxREFOU0cxelBaYll4T3RXa3hQanAvQklqdTNtazJMdjRGQzUx?=
 =?utf-8?B?aGNEVmhtd1pieldRZE04eVJLanlNWTdOUU1sRHkxNVJqUVREeVNkZGt6RDZN?=
 =?utf-8?B?VFFvaHZGbTVEWXJ0UXRMRFZ0RzdKYnY4Tkl5K2JwT1R3QVR3S3pwR25TcWEw?=
 =?utf-8?B?azQ4VG9TMVE4Q3BxQlhocEwySTdGR1FCdnlwNm9GRnpzcnovQ0dxV1FPRE50?=
 =?utf-8?B?UXZJV294WGxGNzBDbi96aUlucWo1ZXhyQzVSa3ByMElMcjJUVW15bFNnNjVr?=
 =?utf-8?B?RGgvNkQ2cTNtYzVZK2FySEtCSEFScW1xZ1VhV2pYTFIwUktaSHBwaWZoVzVs?=
 =?utf-8?B?elJsK3V0Y0lHcWhwWElwVjRvWG5VZEs4dmMzaVNhMWxIdlFheXpDVjFUYm4w?=
 =?utf-8?B?c3ZuUGhpdFdhZ0EwalcybldMV3daVkNOeUJkT3ZHcjRXVzZjdi95QUszb2xq?=
 =?utf-8?B?MmlsNmhwNEp0RDlVUWZpN0svRTVKSEI2VVYvSXVrc1E4cU14UlZyeHNqQndC?=
 =?utf-8?B?bXkzN0NqdHY1OVB4TzloNkhONVc5eDN0YVFOMTI3R000UXBySjkxMDJFR05X?=
 =?utf-8?B?dHVuWnhBZDRsWitKTXN4M0ZvNjF3QWRWeWQ4cjRueHh6endIYzFyTWxpd1h0?=
 =?utf-8?Q?4Aqdz0aQNfDp8pDN1FpmF48=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c0V4anpHQkdiN1BFdWNUd2k5S2lMcHZWaG8rNTBrRVhKdDVnS0YxcHgwOGVa?=
 =?utf-8?B?WlVTancyWEpmOThDeW5FWG16ZVk1N3VQNDUxMzkxOFRBZHRzTmpSV2FQekU2?=
 =?utf-8?B?ZHp4eDlpY1k2WHhycGhQWlNnM1NwNitmN0QwVVFZTDY5SDlKc0Y5eHpXbDVj?=
 =?utf-8?B?VC93ZkdiQWQvN3NQSGdmVmo1MStMdXN5Mm5UZERnTFYxR0dzRnBYMU5YNFFp?=
 =?utf-8?B?SG9jVmsxY09JSlg4dGxjWWhTMzd5TWc2c0F4aEJFRjNMN0lCa2V6Vi95Tmlr?=
 =?utf-8?B?R2lxSCtTeW1FKzk5d2xIb3JYUDFZbTJaTURWdE4rVGNXOCs1dG4xZCtydllN?=
 =?utf-8?B?NXNuRjhwcGJza1A3cE9vT1RaUVR1RWJaanN2Nm9FeUd6L3BuVmF1N2Jvb0ti?=
 =?utf-8?B?Uzd0UlFDbkpmZkFYeFZaNmFKNDJNZGsvOENoZnZHNSt5Yng5VEJGMEhYKytu?=
 =?utf-8?B?VHFXcXJlN3VocFVjWmYwZlQ1bzRvMTk5cFd4eHFDa2VGWWl2SVJXNzQ0bnk2?=
 =?utf-8?B?aUh0WEFzTVU1NFI0dXFPdnRobCsrOU9WRE1SQW9mS2VWbXg0Q0VBSkJFc1lj?=
 =?utf-8?B?Z1Z6UlhsWGFqN1A0YVRTZ3ZDMmtiQyt4bDJUYzZNY3cvcUdpaUFBVnpYSHpZ?=
 =?utf-8?B?RHV3ZUNBYzA3eUJIeGZJQ1c1a05ydXZzVXo0WXdsa3VNQ2N3TFdZQzQyRjdT?=
 =?utf-8?B?TUZ5Vy9xdExtZ1VMOTV4VEEyUjhYZG1qU3VIdHlVSnlYNkpDSjdadmtHR3NZ?=
 =?utf-8?B?Y0E1NGU5ZExrd1BDZEM4eGtqaERPVW53WjdXaUllN1J6Tzk0L2tucUZ0a0tw?=
 =?utf-8?B?cUFFdkJ2YmVHRlp1VTVtaGFoUW5nYnF1cnM0VFBWVmJIZzBhTm9VRzZ0UUY2?=
 =?utf-8?B?VXFqaDY5RGppbFN0S1BvVXZkOENDaXdhSC9FMnRvUGVWVU5uZDhWck1WM1F6?=
 =?utf-8?B?ZjU3VEdiVEkycEN0ZzA3YnRjcHdSTlo5a1Z3Yk56TEJzbDRIWi8vcXFOYkMy?=
 =?utf-8?B?V0g2YjV2Z3crRklCd29OazN6cE5wYmMwcWNrdld4K0k0alVkbU1SYkp1M1FS?=
 =?utf-8?B?QXVNRUFJRExiNHQxbUR3KzhYd21kbmZUMmUxc1lnc2llMzdyMWdUaDJITTFi?=
 =?utf-8?B?L0pRWEZuWE9Oa0RvM0ZGYjVPcjdON0swQXpsSEhYU1RuRksvdmhHYnZTbUtL?=
 =?utf-8?B?cXppMlJ4a0oyVEpOdXdYTkdjakcyYUlYeW4xaXpWaHNHT3pYUFdZQjJGNndv?=
 =?utf-8?B?VXFHcVBHbXpXUUwvRUlpSnhoc1ZkbUhzbTJhM01tOXB1SmZobjkxS3kxeWlS?=
 =?utf-8?B?K2pxNFN4T21Ec1h4T1FSb2c0bHZXc0FSbFRXYXZEVDVPbHJBTlZERnRoNFFE?=
 =?utf-8?B?bWVUK0l2VFNmQ0hPekxTV2FBWm9CYjNmZTNEK2VXNENVWmk0WnFRMGdEbzRi?=
 =?utf-8?B?NG0wZ1lUTy95RG56WlowY3NaamZuakNLNG5YdmlpbXBmei9NdERUUGd6ZnFT?=
 =?utf-8?B?KzFRNjlUN1RpY0Y2Sm5zSUMrd2t4ZFZjZ3ZGQnI0MkpQZExHVTcrc2kvZzVk?=
 =?utf-8?B?Q0xWNDNsWFZ6TGhVV09oQ2UwYmRyeDNsVFhBOENrNDEwR3FWSnlwNHc5cXp2?=
 =?utf-8?B?aStDN0I4OFRTL0RVajlSTFR6d1RjZ0JhNFg5VDlDV2s5VXBqWVVoTWFzZGJG?=
 =?utf-8?B?MVpvK0lFT0Jpa25aWEE2UFdjRVFiNmtmL2FQT0VLcytHbzdQWVhwVVNDcHJu?=
 =?utf-8?B?TzhqbkRDR0ZQeHMzbmxGTHoyZmdnbGhzV25jdytKMTBRZ3gxL3FTclh3U0x0?=
 =?utf-8?B?ZUl0UG1hUzNpNVljcFRwbDRsT0pvTDJ3MGtWVVF6RjF1ZWplZWdhUGhBcURM?=
 =?utf-8?B?aDE2NDFIY29veGdVRzcwWmtYMEdXWW1WKzNSakpDVjZmTENPS3NRRHNlMzZk?=
 =?utf-8?B?NDk5ai85d2pKUjlYTXljSmVNVitEdVBmaFhhdlFoSjFNYU4wU1dVdUl6eTk2?=
 =?utf-8?B?bmREaTZXN3ljNlhBNHVuazYrN28yZUtUcyttRWhGVThsclVjU010Y3lRZkJT?=
 =?utf-8?B?TjJtZDFnMWM1OTRGT1ZVOGZHTHJhWTF4Nnp2KzNWSEZhYXNqN2pqY1lwUDRZ?=
 =?utf-8?B?cEdXMDlzZ28wbXRPZ0Z0MEVlZUR6TStmRU9OTlQyNUZ6VGt2VU13aG8vZENJ?=
 =?utf-8?B?dWo1dWxtSUI2ZGZrNHRqWkQ0RTVUbEg2NklaSkZWdmZoQ1lzaGZNbHo1SzFE?=
 =?utf-8?B?SWlJWEhlMnNpdUdaY25SdmRhaEJKK0YvMmdBUHpBY00ycGxSbWtQNjQwQ0RS?=
 =?utf-8?B?RGd3Y3J5WE9DTDZocEdTWGF0UTM3eTNvQlBIeFdzNUR1STFGUUxVSXNxc0Vm?=
 =?utf-8?Q?dir/P4DyTdtFh5g0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DCC7D3635971D1438A4F35DF2BBD568A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c83007e-3248-427f-68f1-08de60425655
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2026 20:58:36.5185
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GCc10fLKBajvTmR+6wBNxRx7o2z5ZLh5ogEF4W0BbvRDm6VhZ4XsELIybJA6VhSkTkHl+zR+ZNMLy7fQvCvsCtVD5vNz537+zFtCt8g+KJc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8549
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI2LTAxLTMwIGF0IDEzOjU5IC0wNjAwLCBDaGVhdGhhbSwgQmVuamFtaW4gd3Jv
dGU6DQo+ID4gDQo+ID4gSXQgZmVlbHMgdG8gbWUgbGlrZSB0aGUgdHdvIGluamVjdGlvbiAnbW9k
ZXMnIHNob3VsZCByZWFsbHkgYmUgdHdvDQo+ID4gc2VwYXJhdGUgY29tbWFuZHMsIGVzcGVjaWFs
bHkgc2luY2UgdGhleSBhY3Qgb24gZGlmZmVyZW50IGNsYXNzZXMgb2YNCj4gPiB0YXJnZXRzLg0K
PiA+IA0KPiA+IFNvIGVzc2VudGlhbGx5LCBzcGxpdCBib3RoIHRoZSBpbmplY3Rpb24gYW5kIGNs
ZWFyIGNvbW1hbmRzIGludG86DQo+ID4gDQo+ID4gaW5qZWN0LXByb3RvY29sLWVycm9yDQo+ID4g
aW5qZWN0LW1lZGlhLWVycm9yDQo+ID4gY2xlYXItcHJvdG9jb2wtZXJyb3INCj4gPiBjbGVhci1t
ZWRpYS1lcnJvci4NCj4gDQo+IFRoaXMgc2VlbXMgcmVhc29uYWJsZSBidXQgSSBzaG91bGQgY2xh
cmlmeSBpdCB3b3VsZCBvbmx5IGJlIDMgY29tbWFuZHMsDQo+IGNsZWFyLXByb3RvY29sLWVycm9y
IHdvdWxkbid0IGJlIGEgdGhpbmcgc2luY2UgdGhlcmUncyBvbmx5IGFuIGluamVjdGlvbg0KPiBh
Y3Rpb24gZm9yIHByb3RvY29sIGVycm9ycy4NCg0KQWggSSBzZWUsIG1ha2VzIHNlbnNlIG9uIDMg
Y29tbWFuZHMuIEkgYXNzdW1lIHRoZSBjbGVhciBjb21tYW5kIHdvdWxkDQpzdGlsbCBiZSBjbGVh
ci1tZWRpYS1lcnJvciBmb3Igc3ltbWV0cnkuDQoNCj4gDQo+IFNob3VsZCBJIGtlZXAgdGhpcyBh
bGwgaW4gb25lIGZpbGUgb3Igc3BsaXQgaW50byB0d28gc2VwYXJhdGUgZmlsZXMNCj4gb24gcHJv
dG9jb2wvbWVkaWEgZXJyb3IgbGluZXM/IENvdWxkIGFsc28gZG8gaW5qZWN0L2NsZWFyIGZpbGVz
IGlmIHRoYXQNCj4gc2VlbXMgbW9yZSBsb2dpY2FsLg0KDQpGb3IgdGhlIGNvZGUgLSBhIHNpbmds
ZSBpbmplY3QuYyBmaWxlIHByb2JhYmx5IHNlZW1zIGZpbmUuIFRoZXJlJ3MNCnByZWNlZGVudCBv
ZiBpbXBsZW1lbnRpbmcgbXVsdGlwbGUgcmVsYXRlZCBjb21tYW5kcyBpbiBvbmUgZmlsZSwgYW5k
IGl0DQptYWtlcyBzZW5zZSB0byBtZSBoZXJlLg0KDQo+ID4gDQo+ID4gVGhhdCB3YXkgdGhlIHRh
cmdldCBvcGVyYW5kcyBmb3IgdGhlbSBhcmUgd2VsbCBkZWZpbmVkIC0gaS5lLiBwb3J0DQo+ID4g
b2JqZWN0cyBmb3IgcHJvdG9jb2wgZXJyb3JzIGFuZCBtZW1kZXZzIGZvciBtZWRpYSBlcnJvcnMu
DQo+ID4gDQo+ID4gDQo+ID4gQW5vdGhlciB0aGluZyAtIGFuZCBJJ20gbm90IHRvbyBhdHRhY2hl
ZCB0byBlaXRoZXIgd2F5IGZvciB0aGlzIC0NCj4gPiANCj4gPiBUaGUgLXQgJ2xvbmctc3RyaW5n
JyBmZWVscyBhIGJpdCBhd2t3YXJkLiBDb3VsZCBpdCBiZSBzcGxpdCBpbnRvDQo+ID4gc29tZXRo
aW5nIGxpa2U6DQo+ID4gDQo+ID4gwqAgLS10YXJnZXQ9e21lbSxjYWNoZX0gLS10eXBlPXtjb3Jy
ZWN0YWJsZSx1bmNvcnJlY3RhYmxlLGZhdGFsfQ0KPiA+IA0KPiA+IEFuZCB0aGVuICdjb21wb3Nl
JyB0aGUgYWN0dWFsIHRoaW5nIGJlaW5nIGluamVjdGVkIGZyb20gdGhvc2Ugb3B0aW9ucz8NCj4g
PiBPciBpcyB0aGF0IHVubmVjZXNzYXJ5IGd5bW5hc3RpY3M/DQo+ID4gDQo+IA0KPiBObywgSSBs
aWtlIHRoYXQgaWRlYS4gSSBkbyB0aGluayB0aGUgYXJndW1lbnQgbmFtZXMgY291bGQgYmUgYmV0
dGVyIHRob3VnaC4NCj4gV2hhdCBhYm91dDoNCj4gDQo+IAkjIGluamVjdC1wcm90b2NvbC1lcnJv
ciA8cG9ydD4gLS1wcm90b2NvbD17bWVtLGNhY2hlfSAtLXNldmVyaXR5PXtjb3JyZWN0YWJsZSx1
bmNvcnJlY3RhYmxlLGZhdGFsfQ0KPiANCj4gd2l0aCB0aGUgc2hvcnQgZmxhZ3MgZm9yIC0tcHJv
dG9jb2wgYW5kIC0tc2V2ZXJpdHkgYmVpbmcgLXAgYW5kIC1zLCByZXNwZWN0aXZlbHk/DQoNClll
cywgSSBsaWtlIHRob3NlIGJldHRlciENCg0KPiANCj4gRm9yIGluamVjdC9jbGVhci1tZWRpYS1l
cnJvciBpdCBjb3VsZCBzdGF5IGFzLWlzLCBpLmUuOg0KPiANCj4gCSMgaW5qZWN0LW1lZGlhLWVy
cm9yIDxtZW1kZXY+IC10PXtwb2lzb259IC1hPTxkZXZpY2UgcGh5c2ljYWwgYWRkcmVzcz4NCj4g
DQo+IG9yIEkgY291bGQgdXBkYXRlIGl0IHRvIGJlIHNvbWV0aGluZyBsaWtlOg0KPiANCj4gCSMg
aW5qZWN0LW1lZGlhLWVycm9yIDxtZW1kZXY+IC0tcG9pc29uIC1hPTxkZXZpY2UgcGh5c2ljYWwg
YWRkcmVzcz4NCg0KRWl0aGVyIG9mIHRob3NlIHNlZW1zIHJlYXNvbmFibGUgdG8gbWUuIFdoYXQn
cyB0aGUgcG9zc2liaWxpdHkgb2YgYQ0KL2xvdC8gb2YgdHlwZXMgZ2V0dGluZyBhZGRlZD8gUHJv
YmFibHkgc21hbGw/IElmIHNvLCBtYXliZSAtLXBvaXNvbiBpcw0KY2xlYW5lc3QsIG5vIHN0cmlu
ZyBwYXJzaW5nIG5lZWRlZC4NCg0K
