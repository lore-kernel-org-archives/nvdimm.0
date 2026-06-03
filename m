Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD05383C67
	for <nvdimm@lists.linux.dev>; Wed,  3 Jun 2026 19:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780513472; cv=fail; b=GwviInn5d8m7hmsPb5esjOtvOMO8760k3/0HnZiXs1U64yRx1RvzxnH5CXfrLTxgJL7m5gXg/aeG+5ec5ohq4SUVz6T48Gx5IUYolEHPL0I1M7I4uq2RTpYcJ2tRO8+kN+Q4Blf88vI8/+xA1uGuT1ZQXKVB1AwKjH5v7iIcDW8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780513472; c=relaxed/simple;
	bh=ZhHITuL1UeMds/Vkhe9Z1dgVhlKaYNV1HrLu0LugKVY=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=E2dcH4VPUyQ86PJcMrfhAKimCPcaL2RtLFGsuBASfQ7aENgIPS66u+Wyn76mPkpjJteKkmAUXXpGatw/2elo2K/BYdpgiwigyhiLxrWJH0ujp2bmLCKx37fZed8aJIRdQIRY/U4sEqD4BU6j85GUWAR91hQbGoHOQ6DSJUPwcUQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FDNOuYEZ; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FDNOuYEZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780513469; x=1812049469;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=ZhHITuL1UeMds/Vkhe9Z1dgVhlKaYNV1HrLu0LugKVY=;
  b=FDNOuYEZm9nQvtAU3ehW3735Xf2EViKi6mh2ZDetkB1hV12wlIglop1I
   xncnSwV/fQyJ7LRryFaP/DhXyIHOHxj2V0vlvUUb3fpESBOJxR273o7x9
   b0fboxk7fUuD2Z5NFWQR9crKNL1QF8ZJ1l35hcX8rZLyU16U3da2ggL/K
   qTZHKf+bjvZEaJNAfsuNPvevdTzXu1k57Reyd1H0FLBj7ot5j+vQpLCvi
   cN2zMvJzfFJiCvRgG3cQBbrESG+GPMnXnkWe2IAqL9JxSJjjMvv5QdUXY
   RWH5Do9uowyct3NRf0AE7VbjJ3ZWEuBndLbLiwXdVM4GJU6R2cfJzodgj
   A==;
X-CSE-ConnectionGUID: HNOK445iRFWM4ByLkt8izQ==
X-CSE-MsgGUID: qeCPL081RbSKrpm6VbTELw==
X-IronPort-AV: E=McAfee;i="6800,10657,11806"; a="68872700"
X-IronPort-AV: E=Sophos;i="6.24,185,1774335600"; 
   d="scan'208";a="68872700"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2026 12:04:28 -0700
X-CSE-ConnectionGUID: cFnNYXguSpuHfw8mTQbcGg==
X-CSE-MsgGUID: 5BQ56vo2Sbi7XpWUxZE6nw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,185,1774335600"; 
   d="scan'208";a="241337528"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2026 12:04:28 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 3 Jun 2026 12:04:27 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 3 Jun 2026 12:04:27 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.53) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 3 Jun 2026 12:04:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mauf3XIUL4QhMF3WBSSRD2UXsMy6iwgq1oM40O6iULHDPYb9jrWr7GdnynPWrFXos0JLhsomI0PPK1lkiO9ggl5tqu9OPWoPD9DEZQKw6m9cEBu1WEvKWsEtHPK306Ji+6Dv0+kF8DsEC+2CVeDXeGD2PBvAfCe/9k+zOB5jLEpz+7K0DO907CbgkNTGGi2Ose0+LqIy6XOho23zq7cmU2s747Xr+uy8/3wnzE3Zho5sG1kwi6idZ47aZX4p5EMoYgjC4emaXIEY7bpRTQhaNhGPIh+NmuyfM7jRp58yQ4u8L1WkozSpil1Q9R6vXPnBafWzha4Hz6BCst04F8hyKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZhHITuL1UeMds/Vkhe9Z1dgVhlKaYNV1HrLu0LugKVY=;
 b=QEEHtFAPYi6FEcByixwH+EcgJu4AGcg32TfH8SSiFw+SC0WgyT9p7pYR3f7clsJophNQAzVMIIIK92vwaxn8cx7Cy+xD8Z6UlS2a3R4u2x7LgjkITZnYrhW2tlwmfstGMXs4wAqHzSWo3XKKBbvuk33zHuYgeayt2NZHONZiljd45MZ087iZMsPaJdLOU4R6dDLiTYc/5CsPUOQ/h1MRW4dQC2IVWXFpPanHRjFt/NkvijTWrR8DWc31IOQ/gjfJ+Nvhwrb4ZFB9Md4z5pE7Z3P8ZniZ1SvtvYYuNOtdX1CfdW/B/dXrrVU+XfQz8xKKDjW5VtlSTYYieyylLE68uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by SAWPR11MB9547.namprd11.prod.outlook.com (2603:10b6:806:4e3::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.12; Wed, 3 Jun 2026
 19:04:01 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::690e:5fd2:b08b:52af]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::690e:5fd2:b08b:52af%5]) with mapi id 15.21.0092.006; Wed, 3 Jun 2026
 19:04:00 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Schofield, Alison" <alison.schofield@intel.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH] test/btt-stress.sh: add stress test for BTT lane
 race
Thread-Topic: [ndctl PATCH] test/btt-stress.sh: add stress test for BTT lane
 race
Thread-Index: AQHc1EM9cCtOCHWc7Eep/euO/+3y2bYtbu8A
Date: Wed, 3 Jun 2026 19:04:00 +0000
Message-ID: <29e5bdd3a3f0e4c342f7ed93808fa06cd2a96872.camel@intel.com>
References: <20260424233633.3762217-1-alison.schofield@intel.com>
In-Reply-To: <20260424233633.3762217-1-alison.schofield@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.58.3 (3.58.3-1.fc43) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|SAWPR11MB9547:EE_
x-ms-office365-filtering-correlation-id: 9b3dcb24-fced-4809-e1ab-08dec1a2deff
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|6133799003|22082099003|18002099003|56012099006|11063799006|38070700021;
x-microsoft-antispam-message-info: oVxAYvsoMaqhVuRWV+4N+hznoGGYX/d8WZoD5ccT8Sh0TR+YAVPykkKoxLo8M+ZJFukQcPI0z8cNLJgxIUx3TumAH0dpU+F95ve7dUhnMMSy/xBp0O8MjfZ/0kmsb7xz5U6AQXWHCt8WlueCmbZFvfnWi8gGJfa/TUxk90/sou6W/b6KdM5MsHBNmVg9v9zb69gszsMCq8PefSNQSa7aXo4ewz9/rSXAR8jBCLPszcxmIqs6CnqTAZ/atSsp//YTsjujnghq65KWn+OnfIuPqHumi01RO5y5G1J1xrA5OCsIBavATYJFwBhkESsXnGyItz+CgwTtGwMj6Qv5HkAp89aZ5cU8LqFKLS3AuM8HOQ3wEareUbmGhfjMo8M4KpGBKM4UvSZFJngfdrlLti73oQePCW4R2emZW7ie+HcManEve2ULvdVv3tP4db8vM7SyZmo42vrBTIkDRdweJm7IrUABXilOFrk6rEtyb6gKXOBhSRubUcHsVWRB7/o3caydz0V2oSHMV//bUGs8rE3mruWaVHIJqZ8J2KRQ7DlTUNo4wTUmlB/y+JTPkGjgYDbxLLfLwnL2mw6DltK+wVqoGa1qoYBa/T/e493UJ3bkeMWbtGxMOV2CAJcDFZNrVIWMygF89+wzjVLjLp2GkKDVsXM6cXO3uFLqG18UyhoHuFprXF9mKmdz0NgarYutyyxSaS1FO1mgPhquMGllt6QppQ8vqYHwBl/FZAAiT4M4iugY5U8kKxBDcHXoP2WUksNp
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(6133799003)(22082099003)(18002099003)(56012099006)(11063799006)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MGdyQlJZUVROTXhPSGh2NVFZazJXcG5qQUJTaW93T2NGV1FPODFaOTZYTWxZ?=
 =?utf-8?B?d2Y2TndiTzRsUFA1cHV1OVM2cTZoSU9MdjMvYjlPUkgrTFVsb3VBY1IvOEJ6?=
 =?utf-8?B?NUdCUnRIUGo5RkYrVEZJOVQ2a0tRK1FXbElTTFlpOSt1Um16M2RQOGFXcnJC?=
 =?utf-8?B?NTlZMVlrTlF0UWZweU4rS1lPK0VQVWxOZmcxZUgxeEtiWDdBdGtUVXp5NWp6?=
 =?utf-8?B?TlpLMEtlRzEwcVlYMThwSjBscHh2dkNJZ28rSTZGSkc1WlZwaFRTb1MrMkgz?=
 =?utf-8?B?djFJTU03dkpvVnowdDBGZWlLd01FSmlvYWhuOHdaOGtGVDM3cDBMczQzVDk4?=
 =?utf-8?B?dlN3UXB3TjB2akVZVDZnTGVqVmpSRDFyb3lodVcyNWJybjdOZzFVT202WDBs?=
 =?utf-8?B?K21VTyszVmZvelZyeWk5THgrUkp0a3hTWmQza2hmTm9VeTlsbGhOUVpzb1JI?=
 =?utf-8?B?VkcvUTF6bU92RTlyeGJ1bmVLZGZMVWl1TWNFNWVTTGZDaFV6Nm5aMGlwTk9y?=
 =?utf-8?B?S3I4TFlYSlRHVGVqK0c2MTEwb3REWi96eUtpQzlSY3NVM1hrRTBRUXkrelp3?=
 =?utf-8?B?RERyclA4ZDcvWGdmc09NbFFobUdFbzYxTlJSSzY3UEZZR2sxRXdkT3RQVDVO?=
 =?utf-8?B?d1FMbFZhRGMweUo0TmdDK2JmRW5nK2RWVFNEenp1UisvK1FYNGVIVENDNWZz?=
 =?utf-8?B?c1l5bW1Ha25hYnN1OG9MdGQxeGZ3QkV6VUNyazBIaktQUjNXNjRzVDNQeS9O?=
 =?utf-8?B?dHpySkJneTViYWExTlFXU3htRFNFKzkvZ1l0TjlENjF2R0RpYXNtQUUwS2dR?=
 =?utf-8?B?NWh2eU45WlRweThFaU96UGh3THdrZWFBT1JMV2xvRGVFZVk1M2RRK1dMWGoz?=
 =?utf-8?B?Nkl4U3lETi9hVEI2dHdVVUVxdHVzajZnZ3U3V0QwbTBRNkdwSE1XUVd5a2xM?=
 =?utf-8?B?RGxCbS9iSzZMcm5ZWVBkY0twT2NUMzNQcm8xWElFVHhsUi9hT0d1RlhnbE54?=
 =?utf-8?B?Mysvc2huYnZNRitheG4xSzBEbmx2NFg2Zi9FeVpvK1RxVHNEUmtMK0dkL2xO?=
 =?utf-8?B?ZENpa3ZSKzdkd3REeG83VWNFcmNyUHlTVUFiRVNROWRlMzdwMjhwYzBZYnFP?=
 =?utf-8?B?MkJ1RHdrTUhrYXVMZGN1UllKRUsvR1JMcEErREQvaXZ2MXhRdlI4cndKNk9E?=
 =?utf-8?B?VXg4cWNMWThzZWk4UXIxWlpSRGl6ODVGMHNsVXZLRXU3dWlLWXdDNzlRQXA3?=
 =?utf-8?B?bjNDTjN3QzdPSjU1OC8wRytqYjhxN1k1RlJXZXA2USs1RW1pTzRXUEVPZFQ2?=
 =?utf-8?B?dTdwYlJzMXdTNDFjejFyODNRSUxibEVnRmNBUWZwL2M3TFZhOFBWeWc3UHRX?=
 =?utf-8?B?TnFMeTdydHZ4bzBDc01aV3ZQTjE3aXFZL3lVMjhNRTQ1cE5XTzhGMmxURjNL?=
 =?utf-8?B?N0VFNncrcmZRUXdXWGI5SkF3Q29UWEttbXJoeWhXM3BleG12bTRKMGViWVpR?=
 =?utf-8?B?aDhVRm8xaUtWaGhvT2FSUm9QUFhqZU1GSGhyakxQeTlWTXBEb1grYkRrK1pu?=
 =?utf-8?B?RmRyUFV6cnZnaDlGYnRwY1NvazVuQ3IwbVpDY1ljcUxSeUtWbDU2WkkwSTNS?=
 =?utf-8?B?SUZ0QitOWExyUUxqdzBsY0x0Ymc0clIyc3BwYmcwWTFKK3lhcDFMN3RnNUhR?=
 =?utf-8?B?ajlqOUdDaWlndXVVK3RBWHQzR2IvMXJpSEdFNXpqLzYxUEx6cDVlbzY4Z0xL?=
 =?utf-8?B?UVVCbmVBeGxESUI5R09oUmZNdlIwdlV5eWQxWTd2QnRjdnlGMXB1bU9EWENl?=
 =?utf-8?B?STN1Vk5YT0JhWGlkbEVwVHljcjM4N3hXemRmVUZUeS9DK0duRmFEYW5pTGMy?=
 =?utf-8?B?ay94cHZqSGh5M3FmbC8vK0k2RElGNjluV1FnU2dGeThDemFrbUNsMTJJeEdp?=
 =?utf-8?B?NE1tRlpCd1A2WmZscjB4QnNnbXlZUWxrZ1hTbGxsL1RFZHRzZFdQQVJoaGdx?=
 =?utf-8?B?Sjl1VFAxUG4zaWNiUFdYcHpKVVNIREdMeG80YlVBbVVIaFk3a1N1S0krUWNT?=
 =?utf-8?B?ZzdVcUFzeTRNOFN3R0RHbTlJUEE2K2lES1VRZ3oyYStIalRWSi9iSldMSStC?=
 =?utf-8?B?dHRvMGxVY0pNTE1GY1lWQkd1bndvT1BXdHJlL0MzZmx3b1RrQW41K0E2QXUx?=
 =?utf-8?B?eCtKR2FoTUtvRE00SWF6NE5IaG9vYzZBeUJKRnRYZWtlcVVreVN2bVRGTkNk?=
 =?utf-8?B?L1BiQSt6Wi9aMnBlNm5HQ24yd2I5QUh2SElzVEhDamF6SVB0VHV3QkpMN216?=
 =?utf-8?B?T3lYa2hpZUN1V0hyOHBYb1k2SlMveDFDdllLTWNORFNFdm1OUXlKOTZTdGJk?=
 =?utf-8?Q?XelF3S0c/WJ3FByM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2B91C658D8DF4D4B829B25B5F015AB1C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: GRGE8+XXE8C25Fb5JcE+T5CeSJDFlH3s09Df1RiTRPHugz1ol2LRKyxJjXgKC+YLiWaYb9YryQ/2L9gXqqkVWy3QvHLQgOmGt5v+QYtyI4ivbSHnT/RqEGzQHp0vFfmtSqX4/ebkH5rnlP6TlOMM4w8xKpjpjhudu39tBqqQwtAZHO3+fFSAKm/iniJ1hPMJrdDv2REsyPNZTdClLvgafFxtC8x78yY5VI4abAf7i03wkl+4pVAzZhYP/2U16igPGyZD/5saBJmahi4ECpuxKScHNOoKnbWPBIOXYcoR7Dgss/6+ekpm+rEVPagingr11ZTmUh+jSuUPEVYfWLcuLQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b3dcb24-fced-4809-e1ab-08dec1a2deff
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2026 19:04:00.3257
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Fj0qA+vb6hktB2nBB39dfoj+TkrqXSvNutXv1MdaceppvCzlTaxNriFfULzvolpKJGBKQUHUk6pmNRpgDa6DImkLDvMAHQTymCZ8p/uFNdw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SAWPR11MB9547
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI2LTA0LTI0IGF0IDE2OjM2IC0wNzAwLCBBbGlzb24gU2Nob2ZpZWxkIHdyb3Rl
Og0KPiBUaGUgYnR0LWNoZWNrIHVuaXQgdGVzdCBleHBvc2VkIGRhdGEgbWlzbWF0Y2hlcyBkdXJp
bmcgQlRUIEkvTyBpbiBhDQo+IENJIGVudmlyb25tZW50LCBpbmRpY2F0aW5nIGEgcmFjZSBpbiBs
YW5lIGFjcXVpc2l0aW9uIHRoYXQgY2FuIGxlYWQNCj4gdG8gc2lsZW50IGRhdGEgY29ycnVwdGlv
bi4gVGhlIGZhaWx1cmUgd2FzIG5vdCByZWxpYWJseSByZXByb2R1Y2VkDQo+IHVuZGVyIHR5cGlj
YWwgdGVzdCBjb25kaXRpb25zLg0KPiANCj4gQWRkIGEgdGFyZ2V0ZWQgc3RyZXNzIHRlc3QgdGhh
dCByZXBlYXRlZGx5IHdyaXRlcywgcmVhZHMsIGFuZCB2ZXJpZmllcw0KPiBkYXRhIG9uIGEgQlRU
IG5hbWVzcGFjZSB3aGlsZSBiYWNrZ3JvdW5kIHJlYWRlcnMgY29udGVuZCBmb3IgQlRUIGxhbmVz
DQo+IGFuZCBDUFUgbG9vcHMgaW5jcmVhc2UgcHJlZW1wdGlvbiBwcmVzc3VyZS4NCj4gDQo+IFRo
ZSB0ZXN0IHJlcHJvZHVjZXMgdGhlIHJhY2Ugb24gYW4gdW5maXhlZCBrZXJuZWwgYW5kIHBhc3Nl
cyB3aXRoIHRoZQ0KPiBsYW5lIG93bmVyc2hpcCBmaXggYXBwbGllZC4NCj4gDQo+IEFzc2lzdGVk
LUJ5OiBDbGF1ZGUgU29ubmV0IDQuNQ0KPiBTaWduZWQtb2ZmLWJ5OiBBbGlzb24gU2Nob2ZpZWxk
IDxhbGlzb24uc2Nob2ZpZWxkQGludGVsLmNvbT4NCg0KSnVzdCBvbmUgbml0IGJlbG93LCBvdGhl
cndpc2UgbG9va3MgZ29vZC4NCg0KUmV2aWV3ZWQtYnk6IFZpc2hhbCBWZXJtYSA8dmlzaGFsLmwu
dmVybWFAaW50ZWwuY29tPg0KDQpBbHNvLCBzaWRlIG5vdGUsIGxvb2tzIGxpa2UgdGhpcyByYW4g
Zm9yIH40NSBzZWNvbmRzIG9uIG15IGxhcHRvcCBtYWtpbmcNCml0IHRoZSBzZWNvbmQgbG9uZ2Vz
dCBydW5uaW5nIHRlc3QgaW4gbmRjdGwgLSBtYXliZSB0aGF0J3MgZmluZS4gQWxzbw0KYWxsIHRo
ZSAnd2hpbGUgOjsgZG8gOjsnIHByb2Nlc3NlcyBwZWdnZWQgaGFsZiBteSBDUFVzIHRvIDEwMCUg
Zm9yIHRoZQ0KZW50aXJlIHRpbWUsIGJ1dCBtYXliZSB0aGF0J3MgYWxzbyBmaW5lIDopIC0gSSBz
ZWUgdGhhdCdzIGludGVudGlvbmFsIG9mDQpjb3Vyc2UuDQoNCj4gLS0tDQo+IMKgdGVzdC9idHQt
c3RyZXNzLnNoIHwgMTExICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKw0KPiDCoHRlc3QvbWVzb24uYnVpbGTCoMKgIHzCoMKgIDIgKw0KPiDCoDIgZmlsZXMgY2hh
bmdlZCwgMTEzIGluc2VydGlvbnMoKykNCj4gwqBjcmVhdGUgbW9kZSAxMDA3NTUgdGVzdC9idHQt
c3RyZXNzLnNoDQo+IA0KPiBkaWZmIC0tZ2l0IGEvdGVzdC9idHQtc3RyZXNzLnNoIGIvdGVzdC9i
dHQtc3RyZXNzLnNoDQo+IG5ldyBmaWxlIG1vZGUgMTAwNzU1DQo+IGluZGV4IDAwMDAwMDAwMDAw
MC4uYzE4OTJmNTM2ZDc1DQo+IC0tLSAvZGV2L251bGwNCj4gKysrIGIvdGVzdC9idHQtc3RyZXNz
LnNoDQo+IEBAIC0wLDAgKzEsMTExIEBADQo+ICsjIS9iaW4vYmFzaCAtRQ0KPiArIyBTUERYLUxp
Y2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMA0KPiArDQo+ICtkZXY9IiINCj4gK21vZGU9IiINCj4g
K3NpemU9IiINCj4gK3NlY3Rvcl9zaXplPSIiDQo+ICtibG9ja2Rldj0iIg0KPiArcmM9NzcNCj4g
Kw0KPiArLiAkKGRpcm5hbWUgJDApL2NvbW1vbg0KPiArDQo+ICt0cmFwICdlcnIgJExJTkVOTycg
RVJSDQo+ICsNCj4gK2NoZWNrX21pbl9rdmVyICI3LjEiIHx8IGRvX3NraXAgImtub3duIEJUVCBs
YW5lIHJhY2UgYmVmb3JlIGZpeCINCj4gKw0KPiArIyBTdHJlc3MgQlRUIEkvTyB1bmRlciBjb250
ZW50aW9uIHRvIGV4ZXJjaXNlIGxhbmUgYWNxdWlzaXRpb24gcmFjZXMuDQo+ICsjIEJhY2tncm91
bmQgcmVhZGVycyBjb250ZW5kIGZvciBsYW5lcyB3aGlsZSBDUFUgbG9vcHMgaW5jcmVhc2UNCj4g
KyMgcHJlZW1wdGlvbiBwcmVzc3VyZS4NCj4gKw0KPiArY3JlYXRlKCkgew0KDQpVc3VhbGx5IGZv
ciBvdGhlciBzY3JpcHRzIGluIG5kY3RsLCB0aGUgY29udmVudGlvbiBoYXMgYmVlbiB0byBiZSBt
b3JlDQpDLWxpa2UgYW5kIHB1dCB0aGUgb3BlbmluZyB7IG9uIHRoZSBuZXh0IGxpbmUuDQoNCj4g
Kwlqc29uPSQoJE5EQ1RMIGNyZWF0ZS1uYW1lc3BhY2UgLWIgIiRORklUX1RFU1RfQlVTMCIgLXQg
cG1lbSAtbSBzZWN0b3IpDQo+ICsJcmM9Mg0KPiArCWV2YWwgIiQoZWNobyAiJGpzb24iIHwganNv
bjJ2YXIpIg0KDQpJIHdhcyBnb2luZyB0byBjb21wbGFpbiBhYm91dCB0aGUgZXZhbCBhbmQgdGhl
IGpzb24ydmFyICdzZWQnIHBhcnNpbmcgdG8NCmdldCBzdHVmZiBvdXQgb2YganNvbiwgYnV0IEkg
c2VlIHRoaXMgaGFzIGJlZW4gYXJvdW5kIHNpbmNlIGZvcmV2ZXIgYW5kDQp1c2VkIGluIGEgYnVu
Y2ggb2Ygb3RoZXIgcGxhY2VzLg0KDQpJZGVhbGx5IHRoaXMgc2hvdWxkIGp1c3QgYmUgbXVsdGlw
bGUganEgLXIgPGZpbHRlcj4gaW52b2NhdGlvbnMsIHRvDQpleHRyYWN0IGVhY2ggdmFyaWFibGUg
LSBtb3JlIHdvcmR5LCBidXQgYXZvaWRzIHRoZSBldmFsLi4gQnV0IHRoaXMgY2FuDQpiZSBhIGZ1
dHVyZSB0cmVld2lkZSBjbGVhbnVwLg0KDQo+ICsJWyAtbiAiJGRldiIgXSB8fCBlcnIgIiRMSU5F
Tk8iDQo+ICsJWyAiJG1vZGUiID0gInNlY3RvciIgXSB8fCBlcnIgIiRMSU5FTk8iDQo+ICsJWyAt
biAiJHNpemUiIF0gfHwgZXJyICIkTElORU5PIg0KPiArCVsgLW4gIiRzZWN0b3Jfc2l6ZSIgXSB8
fCBlcnIgIiRMSU5FTk8iDQo+ICsJWyAtbiAiJGJsb2NrZGV2IiBdIHx8IGVyciAiJExJTkVOTyIN
Cj4gKwlbICIkc2l6ZSIgLWd0IDAgXSB8fCBlcnIgIiRMSU5FTk8iDQo+ICt9DQo+ICsNCj4gKyMg
U3RhcnQgYmFja2dyb3VuZCB3b3JrZXJzOg0KPiArI8KgwqAgLSByZWFkZXJzIGNvbnRlbmQgZm9y
IGxhbmVzDQo+ICsjwqDCoCAtIENQVSBsb29wcyBpbmNyZWFzZSBwcmVlbXB0aW9uDQo+ICtzdGFy
dF9iZ193b3JrZXJzKCkgew0KPiArCWxvY2FsIG5jcHVzDQo+ICsJbmNwdXM9JChucHJvYykNCj4g
Kwlsb2NhbCBud29ya2Vycz0kKChuY3B1cyAvIDIpKQ0KPiArDQo+ICsJIyBFbnN1cmUgYXQgbGVh
c3Qgb25lIHdvcmtlciwgY2FwIHRvIGxpbWl0IHJ1bnRpbWUgbm9pc2UNCj4gKwlbICRud29ya2Vy
cyAtbHQgMSBdICYmIG53b3JrZXJzPTENCj4gKwlbICRud29ya2VycyAtZ3QgOCBdICYmIG53b3Jr
ZXJzPTgNCj4gKw0KPiArCUJHX1BJRFM9KCkNCj4gKwlsb2NhbCBpDQo+ICsJZm9yIGkgaW4gJChz
ZXEgMSAkbndvcmtlcnMpOyBkbw0KPiArCQkjIFJlYWRlcjogY29udGVuZHMgZm9yIGxhbmVzICh1
c2UgT19ESVJFQ1QgdG8gYXZvaWQgcGFnZSBjYWNoZSkNCj4gKwkJKHdoaWxlIDo7IGRvDQo+ICsJ
CQlkZCBpZj0vZGV2LyIkYmxvY2tkZXYiIG9mPS9kZXYvbnVsbCBcDQo+ICsJCQkJYnM9IiRzZWN0
b3Jfc2l6ZSIgY291bnQ9MjU2IFwNCj4gKwkJCQlpZmxhZz1kaXJlY3QgPi9kZXYvbnVsbCAyPiYx
IHx8IHRydWUNCj4gKwkJZG9uZSkgJg0KPiArCQlCR19QSURTKz0oJCEpDQo+ICsNCj4gKwkJIyBD
UFUgaG9nOiBpbmNyZWFzZSBwcmVlbXB0aW9uDQo+ICsJCSh3aGlsZSA6OyBkbyA6OyBkb25lKSAm
DQo+ICsJCUJHX1BJRFMrPSgkISkNCj4gKwlkb25lDQo+ICsJZWNobyAic3RhcnRlZCAkbndvcmtl
cnMgcmVhZGVycyArICRud29ya2VycyBDUFUgaG9ncyINCj4gK30NCj4gKw0KPiArc3RvcF9iZ193
b3JrZXJzKCkgew0KPiArCWxvY2FsIHBpZA0KPiArCWZvciBwaWQgaW4gIiR7QkdfUElEU1tAXX0i
OyBkbw0KPiArCQlraWxsICIkcGlkIiAyPi9kZXYvbnVsbCB8fCB0cnVlDQo+ICsJZG9uZQ0KPiAr
CXdhaXQgIiR7QkdfUElEU1tAXX0iIDI+L2Rldi9udWxsIHx8IHRydWUNCj4gKwlCR19QSURTPSgp
DQo+ICt9DQo+ICsNCj4gKyMgV3JpdGUsIHJlYWQsIGFuZCB2ZXJpZnkgZGF0YQ0KPiArZG9faW9f
dmVyaWZ5KCkgew0KPiArCWRkIGlmPS9kZXYvdXJhbmRvbSBvZj10ZXN0LWJpbiBcDQo+ICsJCWJz
PSIkc2VjdG9yX3NpemUiIGNvdW50PSQoKHNpemUgLyBzZWN0b3Jfc2l6ZSkpID4vZGV2L251bGwg
Mj4mMQ0KPiArCWRkIGlmPXRlc3QtYmluIG9mPS9kZXYvIiRibG9ja2RldiIgXA0KPiArCQlicz0i
JHNlY3Rvcl9zaXplIiBjb3VudD0kKChzaXplIC8gc2VjdG9yX3NpemUpKSA+L2Rldi9udWxsIDI+
JjENCj4gKwlkZCBpZj0vZGV2LyIkYmxvY2tkZXYiIG9mPXRlc3QtYmluLXJlYWQgXA0KPiArCQli
cz0iJHNlY3Rvcl9zaXplIiBjb3VudD0kKChzaXplIC8gc2VjdG9yX3NpemUpKSA+L2Rldi9udWxs
IDI+JjENCj4gKwlkaWZmIHRlc3QtYmluIHRlc3QtYmluLXJlYWQNCj4gKwlybSAtZiB0ZXN0LWJp
bioNCj4gK30NCj4gKw0KPiArIyBSdW4gdmVyaWZpY2F0aW9uIHVuZGVyIGNvbnRlbnRpb24NCj4g
K3Rlc3RfaW9fc3RyZXNzKCkgew0KPiArCWxvY2FsIGl0ZXJhdGlvbnM9JHsxOi0yMH0NCj4gKwll
Y2hvICI9PT0gJHtGVU5DTkFNRVswXX0gKCRpdGVyYXRpb25zIGl0ZXJhdGlvbnMpID09PSINCj4g
Kw0KPiArCXN0YXJ0X2JnX3dvcmtlcnMNCj4gKwl0cmFwICdzdG9wX2JnX3dvcmtlcnM7IGVyciAk
TElORU5PJyBFUlINCj4gKw0KPiArCWxvY2FsIGkNCj4gKwlmb3IgaSBpbiAkKHNlcSAxICIkaXRl
cmF0aW9ucyIpOyBkbw0KPiArCQllY2hvICItLS0gaXRlcmF0aW9uICRpLyRpdGVyYXRpb25zIC0t
LSINCj4gKwkJZG9faW9fdmVyaWZ5DQo+ICsJZG9uZQ0KPiArDQo+ICsJc3RvcF9iZ193b3JrZXJz
DQo+ICsJdHJhcCAnZXJyICRMSU5FTk8nIEVSUg0KPiArfQ0KPiArDQo+ICttb2Rwcm9iZSBuZml0
X3Rlc3QNCj4gK3JjPTENCj4gK3Jlc2V0ICYmIGNyZWF0ZQ0KPiArDQo+ICsjIDMwIGl0ZXJhdGlv
bnMgYmFsYW5jZXMgcnVudGltZSBhbmQgcmVwcm9kdWN0aW9uIHByb2JhYmlsaXR5DQo+ICt0ZXN0
X2lvX3N0cmVzcyAzMA0KPiArDQo+ICtyZXNldA0KPiArX2NsZWFudXANCj4gK2V4aXQgMA0KPiBk
aWZmIC0tZ2l0IGEvdGVzdC9tZXNvbi5idWlsZCBiL3Rlc3QvbWVzb24uYnVpbGQNCj4gaW5kZXgg
ZTBlMjE5M2JmZDUxLi5lZTZhMTg3NjJhMTcgMTAwNjQ0DQo+IC0tLSBhL3Rlc3QvbWVzb24uYnVp
bGQNCj4gKysrIGIvdGVzdC9tZXNvbi5idWlsZA0KPiBAQCAtMTUwLDYgKzE1MCw3IEBAIHNlY3Rv
cl9tb2RlID0gZmluZF9wcm9ncmFtKCdzZWN0b3ItbW9kZS5zaCcpDQo+IMKgaW5qZWN0X2Vycm9y
ID0gZmluZF9wcm9ncmFtKCdpbmplY3QtZXJyb3Iuc2gnKQ0KPiDCoGJ0dF9lcnJvcnMgPSBmaW5k
X3Byb2dyYW0oJ2J0dC1lcnJvcnMuc2gnKQ0KPiDCoGJ0dF9wYWRfY29tcGF0ID0gZmluZF9wcm9n
cmFtKCdidHQtcGFkLWNvbXBhdC5zaCcpDQo+ICtidHRfc3RyZXNzID0gZmluZF9wcm9ncmFtKCdi
dHQtc3RyZXNzLnNoJykNCj4gwqBmaXJtd2FyZV91cGRhdGUgPSBmaW5kX3Byb2dyYW0oJ2Zpcm13
YXJlLXVwZGF0ZS5zaCcpDQo+IMKgcmVzY2FuX3BhcnRpdGlvbnMgPSBmaW5kX3Byb2dyYW0oJ3Jl
c2Nhbi1wYXJ0aXRpb25zLnNoJykNCj4gwqBpbmplY3Rfc21hcnQgPSBmaW5kX3Byb2dyYW0oJ2lu
amVjdC1zbWFydC5zaCcpDQo+IEBAIC0xODUsNiArMTg2LDcgQEAgdGVzdHMgPSBbDQo+IMKgwqAg
WyAnc2VjdG9yLW1vZGUuc2gnLMKgwqDCoMKgwqDCoMKgwqAgc2VjdG9yX21vZGUswqDCoMKgwqDC
oMKgwqAgJ25kY3RsJyBdLA0KPiDCoMKgIFsgJ2luamVjdC1lcnJvci5zaCcswqDCoMKgwqDCoMKg
wqAgaW5qZWN0X2Vycm9yLAnCoCAnbmRjdGwnIF0sDQo+IMKgwqAgWyAnYnR0LWVycm9ycy5zaCcs
wqDCoMKgwqDCoMKgwqDCoMKgIGJ0dF9lcnJvcnMsCcKgICduZGN0bCcgXSwNCj4gK8KgIFsgJ2J0
dC1zdHJlc3Muc2gnLMKgwqDCoMKgwqDCoMKgwqDCoCBidHRfc3RyZXNzLAnCoCAnbmRjdGwnIF0s
DQo+IMKgwqAgWyAnaHVnZXRsYicswqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGh1Z2V0
bGIsCQnCoCAnbmRjdGwnIF0sDQo+IMKgwqAgWyAnYnR0LXBhZC1jb21wYXQuc2gnLMKgwqDCoMKg
wqAgYnR0X3BhZF9jb21wYXQsCcKgICduZGN0bCcgXSwNCj4gwqDCoCBbICdhY2stc2h1dGRvd24t
Y291bnQtc2V0JywgYWNrX3NodXRkb3duX2NvdW50LCAnbmRjdGwnIF0sDQo=
