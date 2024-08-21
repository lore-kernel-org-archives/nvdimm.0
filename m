Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 783D3170854
	for <nvdimm@lists.linux.dev>; Wed, 21 Aug 2024 21:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724277023; cv=fail; b=rpggcibGpUtJRVKdd/2NaUEo+IbcY1zT3tK9ii0WLMJ7p/BLJOxG/Qe8QlgBn/+xfo7r0Ad4Xq1EE+U6VOpz6RTaU4hMwHgdeLI6mAZ5K+WD5fGkdhFrEnfnaFAsTlucEJ6wWNXvUIjDb/YfFHa6nTP14wcmELP19uRq+kbcZS0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724277023; c=relaxed/simple;
	bh=Q8y15RKgSBe8QHKvatcoWuamuhjPGsF9Q5kd/wwPboM=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nth/Jw+sv7Oes04naCbyHtcYgQx4qwtuXEWFndvLXOe36DnXzO8xcYT0obcfXBglN4IntDUkgbBiz9hUULCqmlrsrVqXsdSFc96OjhCqsYLmorZkKI8YVPnL/5EdX1x/iYoxB2WPIgneuNrsNmk9bjGrrEUTZ9hyzMtTIi2GO6w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a1cXW3XQ; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a1cXW3XQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724277022; x=1755813022;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=Q8y15RKgSBe8QHKvatcoWuamuhjPGsF9Q5kd/wwPboM=;
  b=a1cXW3XQwApqZJcD9whZScizFR3UceIrlmfRSvxBI5tEn+3xYM5WzA3y
   rp6uBJsxZpTpew1llENb5BgrCy2NcF5fe96splUtTutkhx0Npw4ntNtqW
   fUcCSEQbyd9DV7qRftTEb1vy9VBLEWedYH+YdyCnKxcQCFJcoswEThOlf
   VkeGRUY60qC4ZV1lkhM9DtHHX1qs8Gd7j/We1pZQai9n3Ok/tTeGTyw0l
   r0kTc0WTpDpdmRHdqmlGNLGzv5zaoaIUiSRv3gLZUFRq8hJDcc4QfjZ32
   sLpIJ4wU7PWreyRhhx9NiHy/SOs4Ii8yQy7bnBEF7Ce7JwNxdsZ8Q5qYj
   Q==;
X-CSE-ConnectionGUID: 02U92synTMCbt+5uhKDIRg==
X-CSE-MsgGUID: gwKdSQdPQIC65cEDah3/ZA==
X-IronPort-AV: E=McAfee;i="6700,10204,11171"; a="22633758"
X-IronPort-AV: E=Sophos;i="6.10,165,1719903600"; 
   d="scan'208";a="22633758"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2024 14:50:21 -0700
X-CSE-ConnectionGUID: R2clzFHJSp2vZc3CMouTYA==
X-CSE-MsgGUID: HmwUWTEgRQ6YxgnuCxrOhw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,165,1719903600"; 
   d="scan'208";a="98728832"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Aug 2024 14:50:21 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 21 Aug 2024 14:50:20 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 21 Aug 2024 14:50:20 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 21 Aug 2024 14:50:20 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 21 Aug 2024 14:50:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RB6PxPAUm08vPAWaU5fPmIKVv3GG1g3TkJ5gb3v/SgroCkWREetx387LzhvHg+yRg3FSJdblShdOMxPO27qRXr4G7lJ7LVnctnjN64Ucs+l1QT8uaU4m/v6Y0ZZn+l/sgAHUEW7nTFZIKLialtk/SlTsnssRfu7E5xwYI7oPUft7KyhjJw3Cb7TGLKvMDaKqVtDiiMggeartwFKjRfxRL09O9Rafovz7cHlN6hms7hYBytNHDgVlW7xeZa3GCNCsj5v9ZjL0LOwUPP9YAU/yVw3fXEAHdVYdtYIMTd7+RapxLqmPQmLkiARLMd36fZ9Zh1vO1ZwisOR1yl0ihPX7OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q8y15RKgSBe8QHKvatcoWuamuhjPGsF9Q5kd/wwPboM=;
 b=iOSHBKkQ4XazWlHveBr6jqir8EydunvJUM1ZNG2fUpQ3k3N0g++bWFWsJ4ycw3PcK6DqOx21w1W4LRC1Nyuw5yu7W74CoU13vvXEh8da9QwzUjGqSDfJhgFKQBGkoic8t8vHCTjQPQvY4bq64hCQ/JaBwjXYvyEvY1PS7USQRWr6mFJF46/RBxLU21717GkD3yAnfdV+vKk14lSBXgRVA2ybkWnthYTMWwGa0LWiXCo3asKGmo10r2FzshlyX1ixVJVVPJ4ABgccsHgm8fOv3o7UJ/xH6i6wie9OFFrelNqBgt5CcmIfSc0eJGAkXMsxPs/unKgYKAMM6wkxwd5vGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by SN7PR11MB7020.namprd11.prod.outlook.com (2603:10b6:806:2af::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.19; Wed, 21 Aug
 2024 21:50:17 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::eff6:f7ef:65cd:8684]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::eff6:f7ef:65cd:8684%6]) with mapi id 15.20.7897.014; Wed, 21 Aug 2024
 21:50:17 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "jmoyer@redhat.com" <jmoyer@redhat.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
Subject: Re: [PATCH ndctl 1/2] ndctl/keys.c: don't leak fd in error cases
Thread-Topic: [PATCH ndctl 1/2] ndctl/keys.c: don't leak fd in error cases
Thread-Index: AQHa8y6fzgpZ7jTcoEOn3pxjXq+1v7IyQdkA
Date: Wed, 21 Aug 2024 21:50:17 +0000
Message-ID: <e7cc2048498c0759af33c004d0bf74e2a9449d14.camel@intel.com>
References: <20240820182705.139842-1-jmoyer@redhat.com>
	 <20240820182705.139842-2-jmoyer@redhat.com>
In-Reply-To: <20240820182705.139842-2-jmoyer@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|SN7PR11MB7020:EE_
x-ms-office365-filtering-correlation-id: 9f6db763-f94b-4c9e-8c25-08dcc22b3ef9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?TW1RcnlEaDF4dDhRU2tNZ29TVmlFZkgwc2lHMm9KN29mRkhERGVnTmhOSkEz?=
 =?utf-8?B?QWNhM3NZM1pla0V6eWZGREtUUmJqWmVvN0FIY1hNY0c4bm90ODN1K21zSUND?=
 =?utf-8?B?clljMlNEd0tqcFlaQUo1Vzd2ditjUnpHUUptYS9WWmFaNEJNR2xqUE5lMUpL?=
 =?utf-8?B?SmFIWEt6V1hCWUFIZm15akJlZ3Fpd0RjazR6MUdmeE9ZWmdHbDJ5NlhuTzE3?=
 =?utf-8?B?Z0hLblF0S3RseEszTjVDbWRGMzJnc0lVWEQrb3hVRGVFREZCNmVGNVFUdmp3?=
 =?utf-8?B?cXV1SXRhU0NEcDMrS2N6Y3UvUUxmNmFSVjA4dlNrNjlEYnM3MUxQd0xjeit2?=
 =?utf-8?B?Y2NHOERKU0xzYkkvclM0Uk8zbkJMeFpBWEFoM0YveURVWkQ5NnBCMW9scDg1?=
 =?utf-8?B?NDJ2WDl5blNSN3VSMjhLdDA5QzdYS21Mc2xGL3AxOTVjbVlOM3JBLzZSbUZ2?=
 =?utf-8?B?QUlhelUvWll5bUp4WUpvV0xhSUJlY2huNUMvSEhoekRwZVA5Q3lQZE9BZitF?=
 =?utf-8?B?SktPZlVDM0I5b3FENnBMZy9BTi9jcTRIaW9EUmxOTzNzTGZYNXRLS0xXUy9r?=
 =?utf-8?B?SnBLNVloSGExRUFBUk5sOVBKR09ZZkJOZUZHT0VYY3g4NDQzZHlNc0N2bVJP?=
 =?utf-8?B?d1dhcitTM1dPUjNXbE51akMvRlVtZ2lYaHdnaXk5L2ZlV1E3S1VROGZmS0tY?=
 =?utf-8?B?Q3dOYmo0RkNOcWpnZ2lEeUJ1dzZIUnVyd0ZYdVBndmdlWFMrbWVkR3FZVzdJ?=
 =?utf-8?B?ZTVSQTNpam1BV3RBdUo3ZHRiWWM4OFlocm5qVTJaQ0dvSFlHdXoraUFFeVNh?=
 =?utf-8?B?c2xIVEtkaDZibmt4RmVSUnYyZlpmTFFmRWV3QTRjWVhWNDJYUWxvbHcvZGtt?=
 =?utf-8?B?Zk1EYVVkMks0RDdnYTV4eXc1QmtRUmJ6ZXhxdzZBWVRBbGd1bEMwMHpOZ1N1?=
 =?utf-8?B?dG9Mb1JLZUlwU0hvOGJZSXNuaTdvRXRiRGRGa2JSeDZnMEhNYnN6UHFiV0FS?=
 =?utf-8?B?NGgvb0tRT21jVWZSakRicEtWUzlnNTlXelptUzM0TDhOeEgwNlo5bVdXQlNy?=
 =?utf-8?B?RVRKQ3FlMWRSb0x0clU2OWJpUFF4aFJxUklBYUVwdHBKMDdzcXJDdmU2a3ZH?=
 =?utf-8?B?T0tFc1h2elRxMVJkbVhDUTNHR056SjAwYVAwM3RTOU1tWVRSZDZwNVAycGFN?=
 =?utf-8?B?SGlnRXNlbmdSMEtyOW0reHlPSC9qdUFGTDUyY2NvbExaQmtVWHZLWFFFUG9n?=
 =?utf-8?B?NitCS0U0Ni80SW5iTXN1eFNLRmFTekhEcjZYZXNQdFo2RjhzTG9IVmlFSzlQ?=
 =?utf-8?B?TmJRRlVUbzVhV0hJYUZWODd5OEZRWFB5L0N1a3hKV1dBeUVsMzdNOWRHNEhU?=
 =?utf-8?B?V1JBVlpJLzRIOWd1WUJLOUE3aGhkalAwcEd1RnVSUlBzdGc1YVgweTI1OEFQ?=
 =?utf-8?B?M2ZJS0J4K2tweTRsd1VCQ3NkTVlvcWNobjJGRmU0cnpyV2FXRTBMQ0hGTzcr?=
 =?utf-8?B?eC9UMVBnVFMrRGUxdVZTd25jN09xbDFoYmpRSGdDeG02QmhYNk12T0x3R2tY?=
 =?utf-8?B?WVREYnhPcVA2VEFEOU9MZW9xc2hEZWFMbHN5dEVxTzhBQlVXOUtHL1BmR0lt?=
 =?utf-8?B?U0MyWmhrVmJ2V1J1Zlp6b3l6YUh2cnpUVU9YSDREY09jVXIvWi9jQ3hmVkxJ?=
 =?utf-8?B?YXljMURmWjhUdTRENTZsMXc5dC9ja2c1Mlc2YThnUjQzM2FIQU52TXVTYStV?=
 =?utf-8?B?VWJpR3MxbTFzaWt6YXg1cnp1cTg5TDhjMnlSYitqWmNIcm5wZDE3NGpwMTlV?=
 =?utf-8?B?U2hiVlErOEJRRngrUGttbkRIbTFiU0RCWEM1RkFJTjFUaE5hUTJQNGpRSjU0?=
 =?utf-8?B?amE0Q2xpVVVsNUNnRHJhZlU2cytsazF0aDBMZUN6L2Y2V1E9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?elVkblA3bWZHTUVuOWJPbUJ1T0pEbEN3ZkozMUl0UTdCQ08wdHVpcnQ4Z2Rn?=
 =?utf-8?B?blJNbWpRYmJodk91andSWlFGQU9KQnlnYnByakZkaU1NeG5CVnppZjBlWHp4?=
 =?utf-8?B?Z1BackppVnhCcDJwNHJlOEJ6VXl5bzRVaVIwcE1vNGw3dXFISlVaK1pTc3k4?=
 =?utf-8?B?Yk45V0JDY1pRakl4dy84QjNURzBwcEt0NG40eXg2OExIRW9RWENjK3I1NDEy?=
 =?utf-8?B?WTRVK0hUUE13dFFoMHo0RXRuclJZd3BvL3o2eTRMaDV1OHpiNW0zbjh5YjZC?=
 =?utf-8?B?YjRLNEhZbFJXWExjOVBxRElseHFaMkE2Z0R2QTVicWZOamxIclBqKy9CTElK?=
 =?utf-8?B?eEtRMVdrWWp6MDVtQUMySFBWWDNGN2s2NEZqSkd3R0tDczBNV2tsNkc5U1Q3?=
 =?utf-8?B?dE8rKzJKV3NueTR2NjloYjN1R0EzaHhwMTFyRDhxRXZJai82anR0ZEtPMlJK?=
 =?utf-8?B?VDg3SkpHWDQvVk1mUDVXNldkc2g1QkdxeHBUMllZc0dZWGVXSUdleDI2ZDZH?=
 =?utf-8?B?OHh3cVdNTnlVRXRpYUx3MG1wUmlFN21UNjJlM1dEa20xcFpEK0tJVDlVbm5w?=
 =?utf-8?B?dGhOalRjWkRnYTRENnBld0ozTExTQlFpa3F1RWtKTmluQURuWXhHRVFxU2w3?=
 =?utf-8?B?VmNxOUFVMGh4ZDdUSytWMFBHa1c2dE9jYUNvYmFPbUJxdmlJRHFPRmpzZlpy?=
 =?utf-8?B?c2Y5NDdtQUJFclhmVVpMK3lScDRwdDJwU1BqclVYQWxyZEFRRE1LTmFRTkp6?=
 =?utf-8?B?Z0JMbFhJRmNZZUZneStERGo0REhIMDVVYUN2RVB4ODZWWGRrd2hMSFhNK1pT?=
 =?utf-8?B?Vm1wVkJuWnM5R1I2SjYzbHQ3Mmt1Wm5VRkIrbXlTYzZ2NFVtWGxtc3dpN0FH?=
 =?utf-8?B?K0gvL3hzWW9kMHM3OVNRT0ZxSzdFRkhmTHc4TWRTaDY4NUllQ0luMWtiMDM3?=
 =?utf-8?B?eFhTd0wzRTA1L0NDRGxoaWlLeWN4NkE4bC8wc3Z5eGRvVmJ1aTJERUtRbm9x?=
 =?utf-8?B?aDZWNVUrd21XRG85RWdoeERPVUZuVlYwVDYwQnlzbGs5cjlsQmN0VVJibWpj?=
 =?utf-8?B?b3FlSElYY1lBT29DNmZuMXZ4TTdJcmNIcWNUTGU0MjdJSU9lUjluQUJiQllk?=
 =?utf-8?B?WEV2OXMzc0xFZ3p5aDZKRGg0WFI2eFRqamp6cFFhaUptRlhKT1FvekcxbnhH?=
 =?utf-8?B?MjFUMmJBVVNmY1NQQ2IrRnZOZnhBelMyeTZhTlFLSERBY2U0RTA1ZjBhbDZH?=
 =?utf-8?B?L0E0SHpTL0Z0NmlWNGI5WXNSSHNOajVzZGx1REt2cXoxUFVoSmxUSStCWlov?=
 =?utf-8?B?WjR1QTIyVFVCL0pqWkEvZFV0cUR6dTRQTXVPRmVuZmdNWXJXVnpPcXNPNWNU?=
 =?utf-8?B?djBjSDczOFBhTDVHT3k5cnVMY3JJd2tPWDlDL0UrUDlWczJRc0xJTklpMm9Z?=
 =?utf-8?B?MWxqMUk2dVpGZGFxekVzYzRzWWVLT0tnbDFvTHBORnhhKzJQZHR4Z1dBZW1B?=
 =?utf-8?B?aWFMMmNhZFB2T08yNVdXWHArZUZ4elRoa0owOG14aWJoSWpGZ3dONEs1cDJR?=
 =?utf-8?B?RE5MNXdLVGJMcUJzbndhMG04YUhNSnFFcCtraTdDNG5tcTZPNXVmZ0NjdzdY?=
 =?utf-8?B?SWpvdnlkNHExT04wZWt6aDFwd2R1MDFtVVN1SWpmOUNnZ1d5Q3BEcDRmem1w?=
 =?utf-8?B?NUIzSms2S1Z5Yjl6bmZqVGdsb09aRWcvdTRlYkVRdjVUV0JmbDlsUGpVK0Mx?=
 =?utf-8?B?WUNhUjh6YlpIbXJTVzl2MFgza1FOUVJJcEtEbWlwMitTZnIrd3VsMWlWcTR4?=
 =?utf-8?B?VXZzR0pMNWNZUnpSUWFENDBWMmIvUWwxbXovQjdvNFJPalYrdGZNdUhrQmE5?=
 =?utf-8?B?SUVhWnAvTVEyUVE1Yk5qU3FvZmNvYkJFRy80Q25jVjJiaXRuNWgzRSsxRTdx?=
 =?utf-8?B?cWhzSWR3N1hpd0tXakcxSTc2cFFWeC85RnhaVGhzdVJhdFhBUS9vbEx6c0s0?=
 =?utf-8?B?eDBISnNzck1jcVVqWDRQUlgrWlRzUXBkdk1jOTkwS21wK2ttcU5lbzJGTFAz?=
 =?utf-8?B?dGtib2lBWEJYaVB4YTY0c0EzUDc5TjdPZEMxVmFRbzEvNGM3SmdMbzM1ajJW?=
 =?utf-8?B?S1YrSUp5TlZEM0trZm8xd2lHbHkrTWY5QTczUisxL2FMaTJSRjQ3RlNvdEZk?=
 =?utf-8?B?bGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <23B24710E98681478CC7D2AFCAD9EF84@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f6db763-f94b-4c9e-8c25-08dcc22b3ef9
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2024 21:50:17.5062
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ajx/+0+IherkpiheGe6dbR57MJbo66slfzSI98rJ3zpiIHm5kRsCsRoNulGD8CO1wNCI76aX9fLSStvIxGtAImhrrf4mXJ3KOOd1bRs/frA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7020
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA4LTIwIGF0IDE0OjI2IC0wNDAwLCBqbW95ZXJAcmVkaGF0LmNvbSB3cm90
ZToNCj4gRnJvbTogSmVmZiBNb3llciA8am1veWVyQHJlZGhhdC5jb20+DQo+IA0KPiBTdGF0aWMg
YW5hbHlzaXMgcG9pbnRzIG91dCB0aGF0IGZkIGlzIGxlYWtlZCBpbiBzb21lIGNhc2VzLsKgIFRo
ZQ0KPiBjaGFuZ2UgdG8gdGhlIHdoaWxlIGxvb3AgaXMgb3B0aW9uYWwuwqAgSSBvbmx5IGRpZCB0
aGF0IHRvIG1ha2UgdGhlDQo+IGNvZGUgY29uc2lzdGVudC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6
IEplZmYgTW95ZXIgPGptb3llckByZWRoYXQuY29tPg0KDQpMb29rcyBnb29kLA0KUmV2aWV3ZWQt
Ynk6IFZpc2hhbCBWZXJtYSA8dmlzaGFsLmwudmVybWFAaW50ZWwuY29tPg0KDQo+IC0tLQ0KPiDC
oG5kY3RsL2tleXMuYyB8IDE2ICsrKysrKysrLS0tLS0tLS0NCj4gwqAxIGZpbGUgY2hhbmdlZCwg
OCBpbnNlcnRpb25zKCspLCA4IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL25kY3Rs
L2tleXMuYyBiL25kY3RsL2tleXMuYw0KPiBpbmRleCAyYzFmNDc0Li5jYzU1MjA0IDEwMDY0NA0K
PiAtLS0gYS9uZGN0bC9rZXlzLmMNCj4gKysrIGIvbmRjdGwva2V5cy5jDQo+IEBAIC0xMDgsNyAr
MTA4LDcgQEAgY2hhciAqbmRjdGxfbG9hZF9rZXlfYmxvYihjb25zdCBjaGFyICpwYXRoLCBpbnQN
Cj4gKnNpemUsIGNvbnN0IGNoYXIgKnBvc3RmaXgsDQo+IMKgCXN0cnVjdCBzdGF0IHN0Ow0KPiDC
oAlzc2l6ZV90IHJlYWRfYnl0ZXMgPSAwOw0KPiDCoAlpbnQgcmMsIGZkOw0KPiAtCWNoYXIgKmJs
b2IsICpwbCwgKnJkcHRyOw0KPiArCWNoYXIgKmJsb2IgPSBOVUxMLCAqcGwsICpyZHB0cjsNCj4g
wqAJY2hhciBwcmVmaXhbXSA9ICJsb2FkICI7DQo+IMKgCWJvb2wgbmVlZF9wcmVmaXggPSBmYWxz
ZTsNCj4gwqANCj4gQEAgLTEyNSwxNiArMTI1LDE2IEBAIGNoYXIgKm5kY3RsX2xvYWRfa2V5X2Js
b2IoY29uc3QgY2hhciAqcGF0aCwgaW50DQo+ICpzaXplLCBjb25zdCBjaGFyICpwb3N0Zml4LA0K
PiDCoAlyYyA9IGZzdGF0KGZkLCAmc3QpOw0KPiDCoAlpZiAocmMgPCAwKSB7DQo+IMKgCQlmcHJp
bnRmKHN0ZGVyciwgInN0YXQ6ICVzXG4iLCBzdHJlcnJvcihlcnJubykpOw0KPiAtCQlyZXR1cm4g
TlVMTDsNCj4gKwkJZ290byBvdXRfY2xvc2U7DQo+IMKgCX0NCj4gwqAJaWYgKChzdC5zdF9tb2Rl
ICYgU19JRk1UKSAhPSBTX0lGUkVHKSB7DQo+IMKgCQlmcHJpbnRmKHN0ZGVyciwgIiVzIG5vdCBh
IHJlZ3VsYXIgZmlsZVxuIiwgcGF0aCk7DQo+IC0JCXJldHVybiBOVUxMOw0KPiArCQlnb3RvIG91
dF9jbG9zZTsNCj4gwqAJfQ0KPiDCoA0KPiDCoAlpZiAoc3Quc3Rfc2l6ZSA9PSAwIHx8IHN0LnN0
X3NpemUgPiA0MDk2KSB7DQo+IMKgCQlmcHJpbnRmKHN0ZGVyciwgIkludmFsaWQgYmxvYiBmaWxl
IHNpemVcbiIpOw0KPiAtCQlyZXR1cm4gTlVMTDsNCj4gKwkJZ290byBvdXRfY2xvc2U7DQo+IMKg
CX0NCj4gwqANCj4gwqAJKnNpemUgPSBzdC5zdF9zaXplOw0KPiBAQCAtMTY2LDE1ICsxNjYsMTMg
QEAgY2hhciAqbmRjdGxfbG9hZF9rZXlfYmxvYihjb25zdCBjaGFyICpwYXRoLCBpbnQNCj4gKnNp
emUsIGNvbnN0IGNoYXIgKnBvc3RmaXgsDQo+IMKgCQkJZnByaW50ZihzdGRlcnIsICJGYWlsZWQg
dG8gcmVhZCBmcm9tIGJsb2INCj4gZmlsZTogJXNcbiIsDQo+IMKgCQkJCQlzdHJlcnJvcihlcnJu
bykpOw0KPiDCoAkJCWZyZWUoYmxvYik7DQo+IC0JCQljbG9zZShmZCk7DQo+IC0JCQlyZXR1cm4g
TlVMTDsNCj4gKwkJCWJsb2IgPSBOVUxMOw0KPiArCQkJZ290byBvdXRfY2xvc2U7DQo+IMKgCQl9
DQo+IMKgCQlyZWFkX2J5dGVzICs9IHJjOw0KPiDCoAkJcmRwdHIgKz0gcmM7DQo+IMKgCX0gd2hp
bGUgKHJlYWRfYnl0ZXMgIT0gc3Quc3Rfc2l6ZSk7DQo+IMKgDQo+IC0JY2xvc2UoZmQpOw0KPiAt
DQo+IMKgCWlmIChwb3N0Zml4KSB7DQo+IMKgCQlwbCArPSByZWFkX2J5dGVzOw0KPiDCoAkJKnBs
ID0gJyAnOw0KPiBAQCAtMTgyLDYgKzE4MCw4IEBAIGNoYXIgKm5kY3RsX2xvYWRfa2V5X2Jsb2Io
Y29uc3QgY2hhciAqcGF0aCwgaW50DQo+ICpzaXplLCBjb25zdCBjaGFyICpwb3N0Zml4LA0KPiDC
oAkJcmMgPSBzcHJpbnRmKHBsLCAia2V5aGFuZGxlPSVzIiwgcG9zdGZpeCk7DQo+IMKgCX0NCj4g
wqANCj4gK291dF9jbG9zZToNCj4gKwljbG9zZShmZCk7DQo+IMKgCXJldHVybiBibG9iOw0KPiDC
oH0NCj4gwqANCg0K
