Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27AEC17ADF8
	for <nvdimm@lists.linux.dev>; Wed, 21 Aug 2024 21:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724277070; cv=fail; b=fTaEv31bvrwS2RRJ9y7isuGC5QfotcPMzmBZCuWEEKHKpx5B+BZX8IsTx4M8N/zKGJoF74Zc0MkNQjPHSp9s0jTJM+ON4dSWmSVErqOCPqPfezwoeJqu0LXH5wHwltEiEyE98ZGjF9KQ5Ke/xkP+jWA7cpcpmWipdwmh+0JozPI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724277070; c=relaxed/simple;
	bh=Uuqci9kWva25KX5y0m7zXE5pJSFti1Wa1c4bIzlBeTw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZMUPHP7m3dfog/Mepn8DFwbo3AJ8YLT+oa3gs40n5R5XZFXWA5i6UtHTNhVrsgBUhvDFOGRKIOqJUvc5qCla3P7olS2tNMJUAPI0+hJqqJo3bSn0EJQ825VJJLtOUZpTA1KseSaBMBiY37L7ESn1jcC7BvxVGii8415hpkiiy8A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XsciTSdm; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XsciTSdm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724277069; x=1755813069;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Uuqci9kWva25KX5y0m7zXE5pJSFti1Wa1c4bIzlBeTw=;
  b=XsciTSdmzOiD0yQSUGun+1hVUUE9BvGtk4yf9tEaju1HXc12IyfUzBcw
   XMtLP5c8TqwpQQ3hthvxcnnVnZjATDkkBdWZpFucMdtPqIwUbXPf4uoY4
   +Y00+ElQ+Rhokk7dTKbHeU7hV3Hu3fKaAOxFJ1rc7LxEXeHdXRhKwpkja
   7RoayQIdOHo6yhMvAWf7MszMb1n1lPOi1Jo+l0xsiQmmKifchNmghEvg/
   pkGwDsfhPIO1qNIyxEZbB4BHJJQbbNYGu7NCRgXBAySB0vRqsrYu0m4NN
   OMdWMC5rUzqoVhjEeUma8Yw74hxbc2O/Jc3ywiPs0cI0QvNl/98639NUA
   Q==;
X-CSE-ConnectionGUID: SBQjWdDlSg6Tmh/+kT84lA==
X-CSE-MsgGUID: 3c7yX0q2Q7idf6FstoQaIQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11171"; a="22633867"
X-IronPort-AV: E=Sophos;i="6.10,165,1719903600"; 
   d="scan'208";a="22633867"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2024 14:51:08 -0700
X-CSE-ConnectionGUID: ReEg08+3Syi0d6k18zrfiQ==
X-CSE-MsgGUID: 6RTjGdkvSna16d0u/0HoQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,165,1719903600"; 
   d="scan'208";a="98729060"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Aug 2024 14:51:08 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 21 Aug 2024 14:51:08 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 21 Aug 2024 14:51:07 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 21 Aug 2024 14:51:07 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 21 Aug 2024 14:51:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dwcmAYrqPoE3T/fDVDZMIvmrFUsMjNpbzfxShs+fVDHY3l64gL2nrkK2G3vrCs1uY6nOUr/LH28K1f1PCOIpWyKYckdd6Q76mQRqz/xoQDl5D2FWLn1UMr4ZGv6sJKPFx7PX07ym0/gc6dS5Nw9XJT/wc8C+bGUDDLudUSpiDiugkb7FHGn77HxShdQbg5hg3Tz9Jq+Qa9RshYBXAnVklIp7WQi6LhxYE6ECyFdja+2T+RFAKK2zzrJa6/HnKm7pZQnkpwhuGgQuqL4axvuvBGFbYXIE/OTcvcG9VULtR2HNpbnLCQySn9Oxiy3lr8V8Ivd2sNWTSKW5seuiCeex8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uuqci9kWva25KX5y0m7zXE5pJSFti1Wa1c4bIzlBeTw=;
 b=yK5R4W/aq8L29AiM2j+vjbkRg8OzCEa3gGHPq+gcXhWBUrN5ZHM0+qDfZAHZyEWLsuA6bkTqfWlD35ouv1mnrkLdco43sGtXPahT38YqdF34XriHI0k22D0fGwhXKEoRr9cE2Kbcdu+483QenoYdZ+30PMWQUvHzRVKdy0bzatQNDkNWZZSZ9NT12/20/D6Fj9YRnJG7nRF4u4Hp8eF05EXPbHRbMwnrW+FEG3hxQxiJFdYUlhEaCjfI5JrfaDNHih21Vu4RVEJ/FH0bWkXVmlqSbBowhzyB87bQ8awEb4Zjn1a7O75Z2je0sidFxH/bzgRtl7NNERMNpaYd8AwhWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by DS7PR11MB6150.namprd11.prod.outlook.com (2603:10b6:8:9d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.33; Wed, 21 Aug
 2024 21:50:59 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::eff6:f7ef:65cd:8684]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::eff6:f7ef:65cd:8684%6]) with mapi id 15.20.7897.014; Wed, 21 Aug 2024
 21:50:59 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Schofield, Alison" <alison.schofield@intel.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
CC: "loganjerry@gmail.com" <loganjerry@gmail.com>
Subject: Re: [ndctl PATCH] ndctl.spec.in: enable libtrace{event|fs} support
 for Fedora
Thread-Topic: [ndctl PATCH] ndctl.spec.in: enable libtrace{event|fs} support
 for Fedora
Thread-Index: AQHa9BOCknPspOYqq0+KKW4GNQlS9rIyQEIA
Date: Wed, 21 Aug 2024 21:50:59 +0000
Message-ID: <27ae6a86de3d6a25df1fafcff6632c18ff3b2f14.camel@intel.com>
References: <20240821214529.96966-1-alison.schofield@intel.com>
In-Reply-To: <20240821214529.96966-1-alison.schofield@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|DS7PR11MB6150:EE_
x-ms-office365-filtering-correlation-id: d7f82916-436b-4445-6d70-08dcc22b581c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?V1BJMEZaQ25iZ0xCaXcvVC8xQzhmWEM4eTRLZ0VBeUo4em5nelh0MDA4K3Nr?=
 =?utf-8?B?RjRyT2dzejhTYkZuT3dnNkQ0dDA0amVIRjcwbmlYWGJhaU9KOTJEZ3J0Z29o?=
 =?utf-8?B?Wi9ncS81U2s0YWlJWXdNTXNNYXJYeGVrOEdnZHR0NkdIKytFVjFxbGw1TUlV?=
 =?utf-8?B?SC8yQ1JCVnpiRDZ3UVB6M1plTDRwM3RZeXpiZGtqcE1KL3hTQXVyczFibThD?=
 =?utf-8?B?RjkxNW5vZk5XR1ZBTVdoU3djRXFiS09aS29zQmd3QUlndEMwWWVzQWVBRE9Q?=
 =?utf-8?B?cmpLU1Npcyswekt0Y1J1a0g0YzdGczNvd3g1dGcvOER1aTdnT2JpL3ZaQkZC?=
 =?utf-8?B?VTladFJURUxweDg0MkRtam1GUUpvVEl5aXV0ZS9lSFlFODFsdzJEQUx3R0VO?=
 =?utf-8?B?Nm9GOHVycWREYXE5RVRPY2dSSjJ6V1JSbmJmUmV5K3ZGZU1LWkZLcTdjbm1w?=
 =?utf-8?B?bE1ObWE3ODJjQTEzYzdBQU1oYWN5QWNZMGREOTJXYjdHcGplNXo1UGVTTEw1?=
 =?utf-8?B?RENEaFZDMjNqTUV3UTFGNnlnWWIwemJwSkV2dE1PR2ZzeFdTSktuaHV2VEpt?=
 =?utf-8?B?NFozc1BUcmZjYVVEVEVBQk1qMHV1NTFRVzBFYzI1b014dEdqQUpjVFlVbTR3?=
 =?utf-8?B?dTlSSThWcWt2Z0VVSEJDN0tHK0RLZElwNDZBdXQ5TVJraXhmVGpYK1k2UHZI?=
 =?utf-8?B?SVdPQUZ4R0puYkhyajFLUnFQdlJjWjJwNzREVkp4U0Q3Nk9uYlJtWVBMVTZ3?=
 =?utf-8?B?R2ptUVlVOHhFUEordTJIYTJqVVBxdlE0QkpaTVJjZkVYVlFpMDZpUkY3Yis3?=
 =?utf-8?B?K0VzSjBlVmJLMXQ1MjR6S0h6VTE4Vjl2b3VNQzZnRzlTZE5EYUxLcENlQlJQ?=
 =?utf-8?B?b2ZOR3UwWDJ0dGZRdDRGQ1AxeTYrQ2d1R3BIUUNTOXU1MG5ETjlWUnFobTE2?=
 =?utf-8?B?SG1PL3JPUzN4dzQ0WGVSbVI2QTliTzA2WnB4elZhREEvdmREMnIrdnlxMnNs?=
 =?utf-8?B?VDc1Y2FhL3pSRU16SWJCUUlvUUd3RnV3d0YyREoxUTJmendQaVNFVHJJTGNi?=
 =?utf-8?B?SzlaZVNNcjJtaVhPRDdJaHExRkRUNVRxMUFiaURaU1puSFJIZnFDbFdYVXBt?=
 =?utf-8?B?dWRoWk1xNkx5UmhDK2REQzJIWWlsTVV3UFlTeTcrNjNuOGRCc01sTENMVFhq?=
 =?utf-8?B?ZzhIY2RZRUMrc2NkK1VhdmdPQk5rSUtqL0tET1BGcVE1dW93WDkwbWplY0dn?=
 =?utf-8?B?d2JwdGwrdk5uc3AzWDV2dlk1MzY3SEtCNHFwVjlOVVI4S1hBcldlTFAzUFcw?=
 =?utf-8?B?Y2padWRLUFZWU0N3RGhDQ2NXZXpUd05NQTZoVkMyV2hqcDNublp5aUo2WHow?=
 =?utf-8?B?L3duTDFtSHJBTXVzaUdDSDU2eXBBYmc4dXZFallSNG9ySGx3ZDV3N1FINk11?=
 =?utf-8?B?OFJQWVJSM2lOOEZBZk1lK3p5STlpYnZvS0pua0R4WEJVa1QwbzlWRlBERmlw?=
 =?utf-8?B?U1NBSTd1VzNJYWRtQUVaUXNpNmxrazBhRDRFQS9xZnFER1RYdC9MM1ZkVHcz?=
 =?utf-8?B?WURzN0dub0Q2cVI2aWpBalFtaGtLQWV6WGd2RHNsV1Bhci80N2pQamk1RS9O?=
 =?utf-8?B?ZWlWRVdGUGVXcmZRVmptenVkL3ZnYzlmWVRwMWg5SWpDcjJjd242ZXp4eS8r?=
 =?utf-8?B?bElPQ3RHTGgyRDZwU1NqdjM5K1hjVnhBQmxmbkRMbnl3S2dtSDZJOWw5OWZT?=
 =?utf-8?B?ckxWc2RVSStod1crN0RoSjhOSkN0TjlaTnZMRGsyZWhJN2lmOEMxVFBaeS9C?=
 =?utf-8?Q?29h0XGEy1AdAIXJVn/2S404Tey2etftIhDav4=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RzVHODRJa29hQkRFanlVVHpJTTNlcmlWZDlCZzJaWlkzYjY0MXZ2NDVIak5o?=
 =?utf-8?B?ak5iN0s0anNuNnBVZExlVis0cUc4LzBKMU9TUWdOVERZeUdTNTc3WDllcjc1?=
 =?utf-8?B?L2FycHM3b2VCQjJUOHlPZzNEYTROTWNZNnJLQTF2OFZQTGtWSjlISFJkZWVP?=
 =?utf-8?B?MGMweTd1a0R2Z3ZYYUFWS3prTVoyVkxUYnFCajdIQTRtRmFnVnR6dEs3Y1hU?=
 =?utf-8?B?Q2s1SHBlbWFKZEVzdC8wTzBYYnhEaWFXcUQ5bHNFYTBmWERId1pGa3ZFVUFh?=
 =?utf-8?B?UDdqYVhKbW1yQ1J4SmhSdGlQOHMwenVxZXg0akFYdkplQUZXWXdGSTh4Rnd5?=
 =?utf-8?B?NlZlS3piTXlPcWl5NjlPY0pPNUhhV2dkWnhib25QSUVGaE1xL0hmSTU4M2U5?=
 =?utf-8?B?QU9rbHE1YzcveGorYkZKWmRLdGpvYmFKekd3WkhuTzFDeXpDMG80YXdWZmxS?=
 =?utf-8?B?MTN3eTFmMHRNODFrOVZ2OGhLMHdBMVBZM1IwQnczNC9MT2Y5UGxwUGZSdDVE?=
 =?utf-8?B?M3RMakZsZm5tM2h5QkJxckxsdGw3NVlXd2kzLzVzOUFGV0IwSmtJTGJmTWE4?=
 =?utf-8?B?ajRUN1JVRjhHc3dGRWI2QzhNeWlXa3I0U3lzZXhrNmhaaDEvTkpxbnFYZ3pR?=
 =?utf-8?B?VnZlK1d1cVlLOXpsQmNKOWY5WFFyMlY0UUdNNnJwODlheWxzVUxWcGFpMXFw?=
 =?utf-8?B?T3pjSjFYMjcwYVFtY2diVmpueXZGV3EzL3htN2NGUlZmcTZzZG9DZEdRQnNR?=
 =?utf-8?B?bWNSTzV4ZWVoM09iNlFWYnI5WTRpM3hWcTY2SjRxbTAzRE9pbGRRMXVrdzVs?=
 =?utf-8?B?WE1EY1dOT09jckd4V2FuWWM0QmxKUXBmOVQxL0lGeXlWMW5LOGNVUXlSZEh1?=
 =?utf-8?B?bzYzYklvQk5JMkRwOHYyNit3QVVrL3hudnVjdUR6dktmWHdXQXlkR1U5WlVo?=
 =?utf-8?B?cjdPT1pWdXJocWY2L3VzeWRpSkxpa1V4b052WHRJSCtzY281WXVyZzNDY1ha?=
 =?utf-8?B?Yi9GWGVlQWRVRS9TWUZxbmlqSEVjQm9PaG1oMnZKdDJ0bENZTXpRZ1RSdkVM?=
 =?utf-8?B?eXNNSi96ZU5lZ2ZIcWtIdnBsN2VMTzd5YWo4TXNqOWpEYm1XZGhRTUo5R2dY?=
 =?utf-8?B?ZGpMZlQ2Y2J0ckFReG8xQTViUGZHcTNyWlNjMDdHODQ0UlZMNGtXU0tmV3Qz?=
 =?utf-8?B?NmtmeTdWOTcwQURaUVQrNWt2WmJNN3VLcEdKYWdkRzZiTVhvbVZ3T1NmNUVE?=
 =?utf-8?B?OXBGNjNWUkpzNTdnbmtVWG1YS3c4T01HWUt3WEthamJrV0x1emNRc0IybzlG?=
 =?utf-8?B?V3gyVDNGR0VLWkJCSUJCTUdqVWhkSUJaeHR2ekV4Wk9pSVlqVGJRNnhOc1lr?=
 =?utf-8?B?WWVvZzd0TEpFclY5TUhGZmFiQmIrbzAzejRpVS8xN0dVajFvQmpNMmk5aFBt?=
 =?utf-8?B?RGxvZDNadXlGcHloUG8xYWFvaXVpQmxMTlZDSXN1OE1BM0ZPNUdydUhHLzVu?=
 =?utf-8?B?MUtwMjJmdkVWYUQwckExRWlCWGM0SFRQRVVHb0l3YUc3QmE0emMyQWxqeWdV?=
 =?utf-8?B?cTUrdU9wZHVaUVgzWmhaV3dsenplMGpNR3NLSzhQTjlZZTRvZ1UzTkQ4V25L?=
 =?utf-8?B?VUNaQ1BXU2RZQTl5UjRMOXEwTUVJamQ4emJ3MDNFNmxxUFdlTlNNQjhTZWtx?=
 =?utf-8?B?MzQ4WTVMN0Q1RzJEK05NWUFuclRzZFRsL1FsenRQbWRpR3VrVGVVdjRDMndj?=
 =?utf-8?B?RGM1SGVOSlBwak9NejFJeUFZdXR2SjNqV1UxOTgrZWhxcFlBNDc2QnNOdHBM?=
 =?utf-8?B?dVE2MmJYUXdvL0c1dC95Ykowc1dLZ0c1amEzdE91Tm8va0lVU0ZPNXRncDlj?=
 =?utf-8?B?QURZYnVvc2o0WjBxY3N1elFhOTFVWDhMMXFCVEZnSzIrZ2N5QnpYWHhBV3c4?=
 =?utf-8?B?TWM3MWlVMzVXZnRndk95WjlXejBuMVJrWmt5OXByaXByWGNwMU1mNm80Mm0y?=
 =?utf-8?B?eU9PSnppQ2ZUZ092S0tEcTZpaHJtQ1NEMmc5S1VuYStkWDBVVnozLzVYdGU2?=
 =?utf-8?B?RWdUd1FaSG5UaGlJbXlNdnpMdGJQNTUwbHFYSmVjSWM5WXk5bTdrajRlS2NI?=
 =?utf-8?B?REdxSkJmamdGTWxLK28wMjBxcDVoUUlibnVEaVVjSml4bWhIbkZMMkp3ci8v?=
 =?utf-8?B?cVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6FEC7417A7E5064894DA9CFDBC0A0603@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7f82916-436b-4445-6d70-08dcc22b581c
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2024 21:50:59.6882
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ipb8Jy04Z/14SPo40R18+dk6SjyIk4C+kV0K/2CTDPyDVYSnj7dL2kTJ8THMiPrK/c/uxFSNgp2Thnqmlo+LiL14tQ+ZNEGLBQvOc/7rxeQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6150
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA4LTIxIGF0IDE0OjQ1IC0wNzAwLCBhbGlzb24uc2Nob2ZpZWxkQGludGVs
LmNvbSB3cm90ZToNCj4gRnJvbTogSmVycnkgSmFtZXMgPGxvZ2FuamVycnlAZ21haWwuY29tPg0K
PiANCj4gQXMgbm90ZWQgaW4gaHR0cHM6Ly9zcmMuZmVkb3JhcHJvamVjdC5vcmcvcnBtcy9uZGN0
bC9wdWxsLXJlcXVlc3QvMiwNCj4gdGhlIGV4cHJlc3Npb24gIjAlez9yaGVsfSIgZXZhbHVhdGVz
IHRvIHplcm8gb24gRmVkb3JhLCBzbyB0aGUNCj4gY29uZGl0aW9uYWwgIiVpZiAwJXs/cmhlbH0g
PCA5IiBldmFsdWF0ZXMgdG8gdHJ1ZSwgc2luY2UgMCBpcyBsZXNzDQo+IHRoYW4gOS4gVGhlIHJl
c3VsdCBpcyB0aGF0IG5kY3RsIGJ1aWxkcyBmb3IgRmVkb3JhIGxhY2sgc3VwcG9ydCBmb3INCj4g
bGlidHJhY2VldmVudCBhbmQgbGlidHJhY2Vmcy4gQ29ycmVjdCB0aGUgZXhwcmVzc2lvbi4NCj4g
DQo+IFJlcG9zdGVkIGhlcmUgZnJvbSBnaXRodWIgcHVsbCByZXF1ZXN0Og0KPiBodHRwczovL2dp
dGh1Yi5jb20vcG1lbS9uZGN0bC9wdWxsLzI2Ni8NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEplcnJ5
IEphbWVzIDxsb2dhbmplcnJ5QGdtYWlsLmNvbT4NCg0KTG9va3MgZ29vZCwNClJldmlld2VkLWJ5
OiBWaXNoYWwgVmVybWEgPHZpc2hhbC5sLnZlcm1hQGludGVsLmNvbT4NCg0KPiAtLS0NCj4gwqBu
ZGN0bC5zcGVjLmluIHwgMiArLQ0KPiDCoDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwg
MSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL25kY3RsLnNwZWMuaW4gYi9uZGN0bC5z
cGVjLmluDQo+IGluZGV4IGNiOWNiNmZlMGI4Ni4uZWE5ZmFkYzI2NmQ4IDEwMDY0NA0KPiAtLS0g
YS9uZGN0bC5zcGVjLmluDQo+ICsrKyBiL25kY3RsLnNwZWMuaW4NCj4gQEAgLTEwLDcgKzEwLDcg
QEAgUmVxdWlyZXM6CUxOQU1FJXs/X2lzYX0gPSAle3ZlcnNpb259LQ0KPiAle3JlbGVhc2V9DQo+
IMKgUmVxdWlyZXM6CURBWF9MTkFNRSV7P19pc2F9ID0gJXt2ZXJzaW9ufS0le3JlbGVhc2V9DQo+
IMKgUmVxdWlyZXM6CUNYTF9MTkFNRSV7P19pc2F9ID0gJXt2ZXJzaW9ufS0le3JlbGVhc2V9DQo+
IMKgQnVpbGRSZXF1aXJlczoJYXV0b2NvbmYNCj4gLSVpZiAwJXs/cmhlbH0gPCA5DQo+ICslaWYg
MCV7P3JoZWx9ICYmIDAlez9yaGVsfSA8IDkNCj4gwqBCdWlsZFJlcXVpcmVzOglhc2NpaWRvYw0K
PiDCoCVkZWZpbmUgYXNjaWlkb2N0b3IgLURhc2NpaWRvY3Rvcj1kaXNhYmxlZA0KPiDCoCVkZWZp
bmUgbGlidHJhY2VmcyAtRGxpYnRyYWNlZnM9ZGlzYWJsZWQNCg0K
