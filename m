Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BFF3139CFE
	for <nvdimm@lists.linux.dev>; Wed, 21 Aug 2024 22:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724278948; cv=fail; b=M7OX0I9CPpVSU1xv+dxkbmD42TzbvkUfVfC6vNKZ2iuYU1B14SrhJU5M2Nfiq8Eg6bWqq3ypz6EgskQwAPfmuT0IIUEPGbyIN9RhNLb9GOeHfq3gv/whyoxohkvpJI5AYqpoAaNgV2y7UOAJJJ9bufqTspNozyDDCsOv/6S43sc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724278948; c=relaxed/simple;
	bh=eh+qSZZLI4qH9g5H5O4PKeWKTBNXx02MFV7jv3O5Nt4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PrqUrOlDaOPQZNH7i+rNU/rn2K4iyUbKW0YYS7bBx5fNaY63w49lY/g4/2Xpuf9mTtFtkdOi3Vq5dkVzKjSH86EE2ctUvhau+YCadhtWkRrlqgkcFY8/zR6OJcJc6ZTcL+yzFAVu5oKKDBXOT/zlBgWw5EiSJYD4Z/myEFEwTMU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O7Bu6Gdk; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O7Bu6Gdk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724278946; x=1755814946;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=eh+qSZZLI4qH9g5H5O4PKeWKTBNXx02MFV7jv3O5Nt4=;
  b=O7Bu6GdkVjICscmal3H83J8svZA9h8yXdxvAzAZpGTWdOnzT5w3MmKxP
   MJikGHjONkqT/T2DAitQddHOzJ4sNPDJJ++ELRPyNdm2SeCZrJaK+m8yq
   x7ANHRcpFc42pBOhmkpYqM3jjDRJk9PusHQ2pr2JtfoU6/EooGaregfnb
   F3Rfpt/9sgt2d2CYPUrsGj97xm5EY5bCY/4IxEEvPPtTYvx5WNaMwCIj9
   q/Y+ezgQTrWepBm+R2wleXN/DTz3fhCKO2Pztcl1FhqwNd6+OqqZtaT19
   m8pK3O61x5SioF8yh7J5ejd/VD5XKuSmazSRZqoF0jPH99jbnn5ldVSCh
   A==;
X-CSE-ConnectionGUID: 6E6jsMM7SJeCDhhVn7Fekg==
X-CSE-MsgGUID: 8Q/ilz+DToq0wYbX5cwnHg==
X-IronPort-AV: E=McAfee;i="6700,10204,11171"; a="22834379"
X-IronPort-AV: E=Sophos;i="6.10,165,1719903600"; 
   d="scan'208";a="22834379"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2024 15:22:26 -0700
X-CSE-ConnectionGUID: 4x8kbRx3Ru2dsem5u1IEtw==
X-CSE-MsgGUID: zl9F/dsYSNSFLo90/MZ+Rw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,165,1719903600"; 
   d="scan'208";a="60950770"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Aug 2024 15:22:25 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 21 Aug 2024 15:22:25 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 21 Aug 2024 15:22:25 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 21 Aug 2024 15:22:25 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 21 Aug 2024 15:22:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mW6S6MYB6ASEIN/B9E/LDG3wj4h9ofSKrxy209de7FysvvzFNNDr1bSdKIXCy/3XML5t+f8Hbd4w4l567IbVwb/TkBHyN62V3jMlb9P9LBdYcRTgLctSUgZywwAjta4CC+0nZOCr/2adEo1aifrflQUqhH5ZQMm0y1W0MN9ioKHZNO34pkii7oG+QAw+Y1am1gf5w+ZRZc+pGQf48x6iQwZA4o5nKtx325C7Qa4AfN7D8twOZ7CvdTjBXYYVufb70l+CMjFrDQJxcoUnqYOhHBhRW7HWYeCWf491Erlecjal1Sgvowv3qJ6GEF0qyrWeleWMtL/5FfnpdR/Vmw5O7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eh+qSZZLI4qH9g5H5O4PKeWKTBNXx02MFV7jv3O5Nt4=;
 b=SNmRr6mqEjEUM0qIhzPrfftigVz/Sew7exXUt65vD7Ci/tI1hHkabco1Xdd2Jv+PoeyISZztiTlmn8oS8Rnl6XphMSgqkLBSuo7rDrKk/+ZVv9njK/nnw+1eT+87msSJ+ko7b4n/XhYSKZQ6PcidbHWdwObnaANjFbynawjQTsRZ0T0bQR4fFzS8LS+mZdVj0Vdl+wCrN+Fb/YjxiFee+3tZNH26eaF+ZmcktVVyJqE60Dmm2Tw4u1MvxewbCpQZ0Y7kt3rV2ycjhxj4K07vZAKB3zbEe8aZJPrbFh4eb/egIZqUOQHloAnrfMX09VGriOy4pvt6qH/xxfQ9EDMWkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by MN0PR11MB6232.namprd11.prod.outlook.com (2603:10b6:208:3c3::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21; Wed, 21 Aug
 2024 22:22:21 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::eff6:f7ef:65cd:8684]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::eff6:f7ef:65cd:8684%6]) with mapi id 15.20.7897.014; Wed, 21 Aug 2024
 22:22:20 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Schofield, Alison" <alison.schofield@intel.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
CC: "mirek+github@lomenotecka.cz" <mirek+github@lomenotecka.cz>
Subject: Re: [ndctl PATCH] ndctl.spec.in: use SPDX formula for license
Thread-Topic: [ndctl PATCH] ndctl.spec.in: use SPDX formula for license
Thread-Index: AQHa9BXcnyiYFhT0Hk+iUR5/ZhoVpbIySP4A
Date: Wed, 21 Aug 2024 22:22:20 +0000
Message-ID: <25667e4eec686af1d7a29019495f3287c834c47c.camel@intel.com>
References: <20240821220232.105990-1-alison.schofield@intel.com>
In-Reply-To: <20240821220232.105990-1-alison.schofield@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|MN0PR11MB6232:EE_
x-ms-office365-filtering-correlation-id: e4b54dba-ebbe-4cd4-f05e-08dcc22fb944
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?UmQranNmamhaWEZYb3VrUUY5NDA0WkhpWnRQTGIzU3hlQ29vTGdhcFVpbHMv?=
 =?utf-8?B?WFh6M0xWbXZHYjdhL0hwYXFzQ0MrdHBEL3dKY0tSZHpmdzRCWkVhaktCQzZn?=
 =?utf-8?B?NXBJTVdqdU5NMVFwc24yMkhQRnY0RE54MmtLeG5jaDlYTDdUSDc4Sy9ta1Fa?=
 =?utf-8?B?Y3N6VUhKN2dUWEdQQ2NabU5GMnZoYU05Yy9PMmZLMXE1ME9HUGdUVDR3UVJn?=
 =?utf-8?B?dkZMSEs3c3FRcEovL3RvWXVMMk12dU5aSDFjaThKZ2V3S0NZUkFBMDNlZmxK?=
 =?utf-8?B?ZVVrbVhaUW1mWm9rTUR5dGhONkoxNWEwQVJ6WWRqeWlUVWM4eEdnQkF0LzFj?=
 =?utf-8?B?UEdqZW5mRVhPL0dsbmdVSHYyN2RRMEZLZ2hJSU4veHFyaWlQM1I1eEF4Vm5I?=
 =?utf-8?B?RGZMMHBqekpuRzA2WVlCU2RzVnFNUmhHeG9kRDY3WEcycjBhbEhMdzhpSmcv?=
 =?utf-8?B?dURINERZSDJ2UzNkS3JsSk5VR2JZMnJVN1paOENBREZrNHJpMnZYSnFZZ1lM?=
 =?utf-8?B?VktVUExVT3F0RlU3VVRqeGR0L1BKZENyM09tdkh2QmVLSDlyREJ2cUVqcVB3?=
 =?utf-8?B?aFFwNncyWUxVVkRoeU1JaGxDdGN0b0MvdVVNY2owRHU2UHR0TUQ1ejduOERR?=
 =?utf-8?B?aVNGSm5BdEl6blY0aFB0QWVDelBiQVlwcFI4Kzh6WTY2bUJGT0JkbGF6YjRO?=
 =?utf-8?B?NnlSUWxxRUFFbzFkR3JrZlJQSERsTnVlbnFzVi96ZnYrRjVXeng5MkVHb3p1?=
 =?utf-8?B?RE1lMVVaeHFUOGJhdFlLR0pJZDVsTUJUR1ppbUlnY3hwR2NIdCtvSkJFNlBP?=
 =?utf-8?B?a0JtcmxaS3haQmIyV3ROYVNmWVprK0h4RzdBa2s5R0x6amVBZ2k4eUlHL0lu?=
 =?utf-8?B?bmU5dWk0ckxKL0MvdFdGbHJVbXpFcTJyU010d1N4MXExSEdMOW1jTDNsMTRT?=
 =?utf-8?B?SUkzQzlHSlNTQkZ1aUpqaGEyY3Q2c25TWEhJUGlVM05nd2RoV29hSGs3cG8w?=
 =?utf-8?B?c3hDZk1lTG53WmoxZm0wUUQzSEgweDQya0JVMjE0OWd6ejdDWGhKNzEyZnVu?=
 =?utf-8?B?UmdjR2xYYXJLbmYybE9nVlpMNlllK1dMVnIrMHFsWk16OVpON1FzRWgwdGtp?=
 =?utf-8?B?eHVadUJTNVVxZDU2OU8rbWY3NlJVbXBhQWMwZFRhMUZERkJ4elVwbHBqWVVo?=
 =?utf-8?B?NTR5ZkV0V1JUeHg1MlBSNWZxYXEzOGluNXp6TWdHSjU1UmJHb0h3K0F4WG1p?=
 =?utf-8?B?ZGlRKy9DWDI1NEkyUENJT25NMUlibHdZRzFjMWJUTk1BNWJaeURKUjl3L0Zz?=
 =?utf-8?B?Tk5OQjBrSXZyQkRmTEhobFBiQ0Q5MTNTV09DWHhTRm91Vmw5L2Rid0xMQ1Mr?=
 =?utf-8?B?c3NUcTdSQndWalZzM2VURlh6T1VQTUVTdjZDMThxODlkeWl4UEcvdVJnS3RN?=
 =?utf-8?B?d25BWXNKYlJTblBQK1JER3V1eEl3ME4xUUdSOUpsbE95RTZpL090UGVUWEZG?=
 =?utf-8?B?Vm9Gd01XYjJuT1ByT0RVazRmNHJyRU9LTjZnWWVjbU15NFRpQ3hpTHIwRmtl?=
 =?utf-8?B?OVhpTlAyOHpaYVFvR2pVZkF6UUlFRjg5aGtER1V3eFRoOWowQ1lqdDdhNG05?=
 =?utf-8?B?YzJ1MGRaTEpla1B5eDlibU9VVm0yVU9saDBVaFpNdGJSNmJTQXlIdVltTGJk?=
 =?utf-8?B?dUI0SEFFRGJqc25MUlNTT2ZxazM2aHk3a29RR0M1UUVnd245dXdJM1pwUk9j?=
 =?utf-8?B?NkRSakdRWmNCNEk5amxreWp2VVV4Ukh5M1d2WVVXTm8zUDhaQ016c0FSRG5x?=
 =?utf-8?Q?pPWCA7/1gaG1NKF/0BoSCzaMl9PdcTE6pxC34=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TnVpNWxmOWNwK3oxNVh4UU04VVpRSk1TNkNXTzFyWHR5dUlkcjMwOFJoR0Za?=
 =?utf-8?B?ZGlOeVZobVZITWRKWElSWGUyb045OUhHQ05EbEltUGxMWVVyWTMvcm5oYkR6?=
 =?utf-8?B?T0ptWE9xeG1TK1g0WnB1K0hyVk9iM3NBZjhzV1BwYk01S2tnOE8vLzZ0MG53?=
 =?utf-8?B?dThoMmhEeE4rVWxSaFVDOTlOcmpGNlNsdzlRdW9lRTFkOGltUFJBb3B2ZzFu?=
 =?utf-8?B?L0dvckZFcWVDbXgwZkp6cFBEck1laXZrYnp5eEhrRldLWGZDRkdON1FPeEZU?=
 =?utf-8?B?ZGZDem51SGIwcmxWNlQvNHdDM2ZmdDhjOWJOVlRuSTFJZlQwaVJBMzgxYWk2?=
 =?utf-8?B?N0ZUUkxQYjFzUzlpRTYwSkNIRktjdzQ0VzlDMUo2MUloMkoyYi9WTEZORVpm?=
 =?utf-8?B?Z0swbzIxSmhwcFhPblIvS3hYVUJ1WFZadTlWOUMwWmkrbVdNL3RKVnpuYmxJ?=
 =?utf-8?B?aXhHMlIvRUphRHhEYnZSOWJ6MGt3V1QyNFhNazI2c2ZCTDdNQjJZcWNVdUVJ?=
 =?utf-8?B?Y25PMTJuNUdDK09QQlJpYVFwVE1SOTNMMjNhMUFXaVQ2bHJaVjFPRlJwNnRE?=
 =?utf-8?B?V01DRStMMVNDZ0ZjTm5UK3hja2tIZmxhY0hTek0yc2lPS29sSm1BbXdKeEdo?=
 =?utf-8?B?end0SFY3OUt3bXlGRWFLRW93WEJrb1VpcGtyYlc2dXZ6M1VlS0IrUXVEazc2?=
 =?utf-8?B?SThvVFpZZmVRZGsyazZGSUNsaHYrVzZHWmVvVDgyVW1kcS85c2dZWUR4K2ZZ?=
 =?utf-8?B?b2hQc0pzT2pzRTB1bmhoQjNPUE5QNjBubEVKSks2ZS81ZHpZMTBPKzhPT1Y0?=
 =?utf-8?B?SFdIcGFnOUtFQ3k1WEdwSXlqWjdBcEQvam5LSi9jY0Q5cXlmNmVxUnM5YVdj?=
 =?utf-8?B?czdhcWFqVTFRa05QbFVTRWxzeGhHZkV2Y3JBVkYrRTdweFpsWml6TlY4WGRj?=
 =?utf-8?B?cnZJTVdIT1RoTHRFYmp6YmFuQ1JVSTgzQUpNRjMrSGF2TFdIbTRQOXlnQTRn?=
 =?utf-8?B?NmoxbnNva3pqTndCWGtHRHNnZ0tsaWkzQSt1QzUvOVR4K1RBb01sWitWUGJp?=
 =?utf-8?B?U2dkOTYybHRObTZmTEdoTU13c2ttWWxnV0lJYjBhRHlmbXdCSjgwcnQ5dE9S?=
 =?utf-8?B?MTAyb0NUNS9RaGFoWVBZR3hOcE15ODBCeHJxMDVzSUE1eGJDVTU1UWRWMFhT?=
 =?utf-8?B?cUNSZkpGU3dNWDBVbU1KcmZsZUx0VExmRGF2bFgwTkNheHA4UTFFWTloYTVZ?=
 =?utf-8?B?TFRPVzVwVkJvMUFLeDlMVmx6M1l2OGJvbURPQUs5U2xuR2FXQ0VhdUx3cDkv?=
 =?utf-8?B?ejFrcnVuQUhjeDVBNXNPV3d3cWl6R1FLYzgyYTNRRkdrdUdsVm9EbnUzS2Qx?=
 =?utf-8?B?OFBxdHBYaktHdkZYR0FrMzgxVVFGSlNMWUk0eFc4dWtuUUc5UERXVlVWWE0r?=
 =?utf-8?B?a2xCRGlUdkd3RlpwOEEzR1IrT0l3VEpsYy9KMFF6aDB3NEhpTVozNk5qRXlk?=
 =?utf-8?B?aWZZTlZGb05uS0hVblpibWU5Tkh6SkhmWWI1WkN0aVd4MFM0YUwrOXhFQVM5?=
 =?utf-8?B?YWdWY1lreFNXeTYyMlI4WTkrUk1sWFlJK24yeStweG1lUkZZek5ua0FKbFM5?=
 =?utf-8?B?aTU3RnRHbk1vYU8rajY1bEtiWGdObFJuZUZLRXBjd3E3ZzZaM1lKTGtXNkpk?=
 =?utf-8?B?M2RiaFgxRHBqQjJwNEFnZDYyZjAvejNCQ2ZOY0RwSVJwajdwZUJ2N2JTRVZN?=
 =?utf-8?B?YTdmdmJqVW1TbkFOa1hLZEM4c0JtTWVrcGorcHZuQ3l5NFN3WUI4NGhPTFNq?=
 =?utf-8?B?SzNqMzlvL0Z2elBqVEVKZDJUMlJ2ZDd1SCtaZ25MRVhKbVozcUNUSnRkVHR5?=
 =?utf-8?B?WjgwYnoyak1yNnlwQ1dYWjduSDZpUnJvalN3VDR4a3BXT0p6K2JseHZoYjkr?=
 =?utf-8?B?YlRPOXVqeGh1YmZEcDlxQk0wa0ZEOHJuVmR1dUdMdEVEdGxMNGR1cU8wemNZ?=
 =?utf-8?B?S2JaRmN3VTlaVDZxR1JMbFVib3B3MWxpNWx2bERNSEdtZnlqdmRlVC9MSkhw?=
 =?utf-8?B?TFFvMDk1cGZpNzNnMHhDbS9HaytqTWNaeks0WmJTcUJVek82S2dMWklicSs4?=
 =?utf-8?B?VFhxa0cvWVNUbW0wVkdCRGZqanZPWHRHN2ZmMzQ5L0RiVVBvaGN5TU4wQUhD?=
 =?utf-8?B?VUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6F353875BD359E4C92ADC75EA43FB750@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4b54dba-ebbe-4cd4-f05e-08dcc22fb944
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2024 22:22:20.7009
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OVFJha7Us1+TtZpjwBV6cJazevJR8s+9TKdPARYRHLfk3TTvcIZaKYDrQ9YUkAlMMBMVkpb+ZOG0k1hzeo8DVwtbHTzRY91XTEWE+AUt+zY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6232
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA4LTIxIGF0IDE1OjAyIC0wNzAwLCBhbGlzb24uc2Nob2ZpZWxkQGludGVs
LmNvbSB3cm90ZToNCj4gRnJvbTogTWlyb3NsYXYgU3VjaHkgPG1pcmVrK2dpdGh1YkBsb21lbm90
ZWNrYS5jej4NCj4gDQo+IEFjY29yZGluZyB0byBTUEVDIHYyLCB0aGUgb3BlcmF0b3IgaGFzIHRv
IGJlIGluIHRoZSB1cHBlciBjYXNlLg0KPiANCj4gUmVwb3N0ZWQgaGVyZSBmcm9tIGdpdGh1YiBw
dWxsIHJlcXVlc3Q6DQo+IGh0dHBzOi8vZ2l0aHViLmNvbS9wbWVtL25kY3RsL3B1bGwvMjY1Lw0K
PiANCj4gU2lnbmVkLW9mZi1ieTogTWlyb3NsYXYgU3VjaHkgPG1pcmVrK2dpdGh1YkBsb21lbm90
ZWNrYS5jej4NCg0KTG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBWaXNoYWwgVmVybWEgPHZpc2hh
bC5sLnZlcm1hQGludGVsLmNvbT4NCg0KPiAtLS0NCj4gwqBuZGN0bC5zcGVjLmluIHwgOCArKysr
LS0tLQ0KPiDCoDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0p
DQo+IA0KPiBkaWZmIC0tZ2l0IGEvbmRjdGwuc3BlYy5pbiBiL25kY3RsLnNwZWMuaW4NCj4gaW5k
ZXggZWE5ZmFkYzI2NmQ4Li5hZTk0NjZjNDUxOTIgMTAwNjQ0DQo+IC0tLSBhL25kY3RsLnNwZWMu
aW4NCj4gKysrIGIvbmRjdGwuc3BlYy5pbg0KPiBAQCAtMiw3ICsyLDcgQEAgTmFtZToJCW5kY3Rs
DQo+IMKgVmVyc2lvbjoJVkVSU0lPTg0KPiDCoFJlbGVhc2U6CTElez9kaXN0fQ0KPiDCoFN1bW1h
cnk6CU1hbmFnZSAibGlibnZkaW1tIiBzdWJzeXN0ZW0gZGV2aWNlcyAoTm9uLXZvbGF0aWxlDQo+
IE1lbW9yeSkNCj4gLUxpY2Vuc2U6CUdQTC0yLjAtb25seSBhbmQgTEdQTC0yLjEtb25seSBhbmQg
Q0MwLTEuMCBhbmQgTUlUDQo+ICtMaWNlbnNlOglHUEwtMi4wLW9ubHkgQU5EIExHUEwtMi4xLW9u
bHkgQU5EIENDMC0xLjAgQU5EIE1JVA0KPiDCoFVybDoJCWh0dHBzOi8vZ2l0aHViLmNvbS9wbWVt
L25kY3RsDQo+IMKgU291cmNlMDoJDQo+IGh0dHBzOi8vZ2l0aHViLmNvbS9wbWVtLyV7bmFtZX0v
YXJjaGl2ZS92JXt2ZXJzaW9ufS50YXIuZ3ojLyV7bmFtZX0tDQo+ICV7dmVyc2lvbn0udGFyLmd6
DQo+IMKgDQo+IEBAIC05OCw3ICs5OCw3IEBAIG1hcHBpbmdzIG9mIHBlcmZvcm1hbmNlIC8gZmVh
dHVyZS1kaWZmZXJlbnRpYXRlZA0KPiBtZW1vcnkuDQo+IMKgDQo+IMKgJXBhY2thZ2UgLW4gTE5B
TUUNCj4gwqBTdW1tYXJ5OglNYW5hZ2VtZW50IGxpYnJhcnkgZm9yICJsaWJudmRpbW0iIHN1YnN5
c3RlbSBkZXZpY2VzDQo+IChOb24tdm9sYXRpbGUgTWVtb3J5KQ0KPiAtTGljZW5zZToJTEdQTC0y
LjEtb25seSBhbmQgQ0MwLTEuMCBhbmQgTUlUDQo+ICtMaWNlbnNlOglMR1BMLTIuMS1vbmx5IEFO
RCBDQzAtMS4wIEFORCBNSVQNCj4gwqBSZXF1aXJlczoJREFYX0xOQU1FJXs/X2lzYX0gPSAle3Zl
cnNpb259LSV7cmVsZWFzZX0NCj4gwqANCj4gwqANCj4gQEAgLTEwNyw3ICsxMDcsNyBAQCBMaWJy
YXJpZXMgZm9yICV7bmFtZX0uDQo+IMKgDQo+IMKgJXBhY2thZ2UgLW4gREFYX0xOQU1FDQo+IMKg
U3VtbWFyeToJTWFuYWdlbWVudCBsaWJyYXJ5IGZvciAiRGV2aWNlIERBWCIgZGV2aWNlcw0KPiAt
TGljZW5zZToJTEdQTC0yLjEtb25seSBhbmQgQ0MwLTEuMCBhbmQgTUlUDQo+ICtMaWNlbnNlOglM
R1BMLTIuMS1vbmx5IEFORCBDQzAtMS4wIEFORCBNSVQNCj4gwqANCj4gwqAlZGVzY3JpcHRpb24g
LW4gREFYX0xOQU1FDQo+IMKgRGV2aWNlIERBWCBpcyBhIGZhY2lsaXR5IGZvciBlc3RhYmxpc2hp
bmcgREFYIG1hcHBpbmdzIG9mDQo+IHBlcmZvcm1hbmNlIC8NCj4gQEAgLTExNiw3ICsxMTYsNyBA
QCBjb250cm9sIEFQSSBmb3IgdGhlc2UgZGV2aWNlcy4NCj4gwqANCj4gwqAlcGFja2FnZSAtbiBD
WExfTE5BTUUNCj4gwqBTdW1tYXJ5OglNYW5hZ2VtZW50IGxpYnJhcnkgZm9yIENYTCBkZXZpY2Vz
DQo+IC1MaWNlbnNlOglMR1BMLTIuMS1vbmx5IGFuZCBDQzAtMS4wIGFuZCBNSVQNCj4gK0xpY2Vu
c2U6CUxHUEwtMi4xLW9ubHkgQU5EIENDMC0xLjAgQU5EIE1JVA0KPiDCoA0KPiDCoCVkZXNjcmlw
dGlvbiAtbiBDWExfTE5BTUUNCj4gwqBsaWJjeGwgaXMgYSBsaWJyYXJ5IGZvciBlbnVtZXJhdGlu
ZyBhbmQgY29tbXVuaWNhdGluZyB3aXRoIENYTA0KPiBkZXZpY2VzLg0KDQo=
