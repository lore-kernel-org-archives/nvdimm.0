Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0179255F39
	for <nvdimm@lists.linux.dev>; Wed, 24 Sep 2025 19:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758743619; cv=fail; b=gxdTcklF07HYj+pUxkuGMiWNVj9jKP6FNu7NTlsYqXsjb4Dw84q16d9KO+G7duE6p5rF8Kf1/cBOoTaXdR7PiyEofLmfZBKv2FISwhSh0zC497wS6eXDU3y3cgJJePIgCX2jdA2KUhFx380neY4T7NPvPPt4lsMhXR38yr9ASaM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758743619; c=relaxed/simple;
	bh=DXdViDrdYAJgzGeBnnR1T+E8+JnXXqZNT9nuCo3py00=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tx7c3tK8Hwf85E3kCJBy+c5JbKq9SwyNxMOtnXn8Qy2kGR+k+OnpCbGrtNCQZavM01qS1VXsKj/LtwqHE3YRAvXDvwDP030Uc3IKX6me1n6DpkahdDK6BM6s061ucEy0nl3R4ehmpiN1ktl8nvlaLLfNHiEr1tsZQP3UQugcwes=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b9pdznDz; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b9pdznDz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758743618; x=1790279618;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=DXdViDrdYAJgzGeBnnR1T+E8+JnXXqZNT9nuCo3py00=;
  b=b9pdznDzt4WVPfCIeKIzGH0GExXz9vGZUqEgQSH7dc/Qv1OCAMfgW/z4
   a3iDZWyAHm+dRL9Ucuy40F7oxgwbwDNHQFns3rgqc8XzUHsEleTYmV577
   OV6Le2XWp6deDze5NZooKUmrvVey9vLAiV4m6K7s/QdARau0FxjjZMcuF
   UiakkircvOd4wFtgW/blVnEn63X1Pkz7t3e7TbYEZRY0kkgwt3GZvm2Ti
   BWKH+DYDA4T4nHF2OoN04pd6O5I8yzl3t3ITRG8HbNf5yJlrwEkVgxI/W
   1Dz8EoVCjjZnBXA458mQJ06dnFuMOW64OWSLCTfPOsAWQzyzZ3momQIAY
   w==;
X-CSE-ConnectionGUID: JhChQHksStmTNdOYTjnilw==
X-CSE-MsgGUID: 5Joj+/CkRIa5Xw5OIfWq1Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11563"; a="71730317"
X-IronPort-AV: E=Sophos;i="6.18,291,1751266800"; 
   d="scan'208";a="71730317"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 12:53:37 -0700
X-CSE-ConnectionGUID: VkukIYiDT2KVbWV9UFoOqA==
X-CSE-MsgGUID: JjykIEfcSHm++DeJv5zbTQ==
X-ExtLoop1: 1
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 12:53:36 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 24 Sep 2025 12:53:36 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 24 Sep 2025 12:53:36 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.11) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 24 Sep 2025 12:53:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Cf4x++wX2n4OWGFpHBrW0QO7+cHtXNXhMnVhwvWSweuHdwj78wCD/+HXNc/MJx0cnhQzMq7dU2Kusd7FiCCsd2bUhe8txTFFwf1vbD/uiPPAQgrApc2ZOIaamfwYO5sG16Yvg9VcqToBdFoQH+a9my3Q2UaL7QuAeo18NdNzCoGd1Ulb0jRU4akjsQ0TIS1sAQ2YH1hAlCPRIJo7cnDfNvKV4LPV88aj89Izj1Pw1wnVSZHPBgNZSdIvfIo3lcZJF8QVP0BjVk5egem9iTcvtQKEMnSY54oS7t59BURT41+X3aaBs+15zkAHjWIzI1uRu5CMnurpqfDDsqfjxNyeYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DXdViDrdYAJgzGeBnnR1T+E8+JnXXqZNT9nuCo3py00=;
 b=Y3l8JKGJKmWAnimHYylQ9+oWMIJIY4qltsOl2ZXfnbUU4AUWzU1cEHD5zrINdtZ9otn0x1/dM2tKHv2YicbYgXVCp9bz7XVaCYfdmE6HGvGGP9b0L1icN2Tb3NzCpMmQKoS9b7s7QpR4lH+MIN3Ef9vTpcQhX38BQ9dIvrisP1SzQSx/U5fIcEcyYQE2JNW+JkRo7CutOEYSYhJ8Lm94qnbfTbI1JM6LCtr080akeDwvkLWyvXRuOS4LqbN/UPRwlEAcssP2CTBAbiv8ReKZ7U+GFpBOcMeViZbQ0VWU7i9PO3DpIFvCNQR7kr3ZKHxDERs/7F7DHCTnPsJG5RH1fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by IA1PR11MB7944.namprd11.prod.outlook.com (2603:10b6:208:3d8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.9; Wed, 24 Sep
 2025 19:53:25 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::eff6:f7ef:65cd:8684]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::eff6:f7ef:65cd:8684%4]) with mapi id 15.20.9160.008; Wed, 24 Sep 2025
 19:53:25 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Schofield, Alison" <alison.schofield@intel.com>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
CC: "andreas.hasenack@canonical.com" <andreas.hasenack@canonical.com>
Subject: Re: [ndctl PATCH v2] cxl/list: remove libtracefs build dependency for
 --media-errors
Thread-Topic: [ndctl PATCH v2] cxl/list: remove libtracefs build dependency
 for --media-errors
Thread-Index: AQHcLQ8pa08JmItWgUaBB//mbbSWo7Siv6cA
Date: Wed, 24 Sep 2025 19:53:24 +0000
Message-ID: <26986497924af1a917142d982c76b855775bc7a4.camel@intel.com>
References: <20250924045302.90074-1-alison.schofield@intel.com>
In-Reply-To: <20250924045302.90074-1-alison.schofield@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|IA1PR11MB7944:EE_
x-ms-office365-filtering-correlation-id: b3beb7c8-c448-415f-7731-08ddfba40609
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?TWxxVlZ5enY3M1NJVFNIWWxXVFY1M0dRbXNFN1FtUjA4TS92L1g0M0RyeWsx?=
 =?utf-8?B?Wnl1TzlCTWgzWkdpT3FGSUlOSkFPWjRQU0NwenVha2U5V0h6QitjVXNlTUkw?=
 =?utf-8?B?WDRweWg0TWpBVloyendqMjFFSEFaQ0ZjdGx3MTB0aDBnaVpFKzhIbkE2RGNH?=
 =?utf-8?B?Umt1OUZ5Qm1ZTnF6SGlsc2JCazRReFY1a215cXptdGxHZmF5WVVKL2JxcVhT?=
 =?utf-8?B?dUs0WGI1akFpMXVVbzFrVHZGQ2JWZHFYZklyUHdvTTZ3OGI3NTd6cElCUkJk?=
 =?utf-8?B?VjdKMGd5RVNpQTBHMWVsUXJOWmF5TTBDaktmcE4zVUZjUS9OSklDY2RobDlr?=
 =?utf-8?B?RFROWmdpeTN4dyt1d2djdWJiWWgzWHZWOGVaNVhzNlM3ZWI5L2p5bEpIcnhE?=
 =?utf-8?B?QlQ3amJ2YlA1bkpKUHl6Vm5iSExJVGFwbDVybGdtUW9XODk0c1NrK29FWE1N?=
 =?utf-8?B?NjhNMVI5blhxTDYwQUp1M0tDL2lMWkkySWY4c1lkOG9JejFiTkZlbm54TkY0?=
 =?utf-8?B?Z1lIRzZhbmhYOWNINklvNjdEckUwYm1nNDZTcm00cTVsWGhla01JZzJQY0dp?=
 =?utf-8?B?ZWs1U1NjbVdnYnBCb0Yya1F5WXlqRkxJQXpmS0p1Qjk3OGVhZ0xiTTc0YnRL?=
 =?utf-8?B?Q0Q4QWdwbVUwOTNyMnVsdkdFbmtSREFvT0RaOHpabi9VMFMyRExuWTFJaDl4?=
 =?utf-8?B?UjJrUHhjZEJFdWRVVXhoVGUxdjY1UE1YN3gxUm1CajdZZmowR0tFRCthRUds?=
 =?utf-8?B?cHJ4dFV6cnFqME5qREVrZWh3TEtSbGphSVd6RWEyNU1FMWh6WEtMQmh0UTRk?=
 =?utf-8?B?Ym5wR09IajBQNlBWeURaR2dtNFpOSkVnT2Ztc0tXL3hBZ3pGajFKMjRQcEtT?=
 =?utf-8?B?cnB1WFd0dFMvbm5yV0JpYyt0c2FpMC9PZmd0TXlLOUxscCtFakNrTkhnd0ds?=
 =?utf-8?B?UE1ERFJ3OGk4d0orL3JXWUFJNjAyMkplUEVrQXBNbUMzd3R1bGFaWHMwVGtN?=
 =?utf-8?B?andESGlId01SZmVwcW9YWWdGd1ZDUTAzUVYwMlcvSmo2LytMTDdYM0dTRE11?=
 =?utf-8?B?enhIOERYZDg3SGRIUjZJS1ZEbUliUHRkR1F3TEJVTC95eXpOU3VkcUpvWENq?=
 =?utf-8?B?T0tlcVFIdzQrdFcwdlZpNGR2Z3FPek1LTVFsbWwvTFhOVjRvdE0vdGxjdDl6?=
 =?utf-8?B?SW1yN25ISVQ3TFYrSDRKcTZyTjlNVFpHdWVuU3FmdzhCd29vcDk0UjlMRitp?=
 =?utf-8?B?bVhnKzZiYmhvWXEwaXB1ZXpJVmYreVViWk9EQTN0NnNnYkFGZXhOWllySXc0?=
 =?utf-8?B?Uzl4ams5UWxQZTM2bGVVMGdqS245T1JhWVNuRi81TVBxTWY5RGVOVkR6R2Fz?=
 =?utf-8?B?K0hMRzA2NDBPZUd3OUhyaW5BWjFwdTVLazVJNGFvY1VmcGpXQlBiZmZRWk5M?=
 =?utf-8?B?SFR5U0lWNHoxcThGem4xWVBIejJvcmI1bGc4NW1WTnBsYk5xc05PZkMzeG41?=
 =?utf-8?B?VXRucDFvQmNYazdObXZtK2ZaejdMYStkUEt6aGx1KzlpUll5TUZQemZRT2hl?=
 =?utf-8?B?WDRGcjY3Vy83UmREWi9WaEsrTUc2K25uRVVQeVlyRC9OaDJtRlFOd29FNnVS?=
 =?utf-8?B?NTdzaStBRW4xZEV4bHZQWnNPUVFDSVRrMUFGUzBNNDdBcTVRNUdDZDZQTk1n?=
 =?utf-8?B?VzdDR004RXI1OXN6TXdRdnJ2MjZlbGtHSFdoOEZERjJJcmxJUnRKL1hqRHhV?=
 =?utf-8?B?Vlhrc2RHaWdVc2k2YVpLOC9Lbmo2WXplM1RodWtxK0RFbkVhVnZBT1c0Ynlz?=
 =?utf-8?B?RlVuYTdYSEZMNUs5Z0JoaWMvNk5NMUE4U3g4M0FmVTkyN3JqK2ZQU2VOQmV6?=
 =?utf-8?B?aUpja2lZRG00Nm9uUU5rYmt4K2dqaHB4U3pnUTNESnVQeWxaM3N1SndnV0Fo?=
 =?utf-8?B?Q3ZMRU5kbTkxTlZaaGg5ZlNFeXo5dEV1RkRUblZ2eWNrWUVlc09rd0NhWmVt?=
 =?utf-8?Q?Lkxoh+W5t+bIlqieaSwKJrJ4+UgUe0=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S00vT0xESEZ4QUZONjNWWklmSUVaYVhLeFpTbjhqUjN6RklNUmFqTHZXbWN0?=
 =?utf-8?B?bWRwKzlCbURkZzEwK1BqTklDTTVZaXZ0VVlwdmYrTlFnMnMwa0JpSmR1WU1w?=
 =?utf-8?B?R1o5T3J2Z3Q2OWtSU3RpYkExaVZIcDhld3VYNUlKSjB3d2J1d1V6YmlmZ3dX?=
 =?utf-8?B?YTRyYm50WFE3Wjk2WHRIaXBjbVlncUNXV3pkbUlyWFBIS3d5MU5HWEFac293?=
 =?utf-8?B?RHRMMXY2WkRZQjJOVzUzam4wUmpvTjJ6cTY2dFJHUmxLK3g4a1ZpMTJsT3Za?=
 =?utf-8?B?OVVFL1I0d3JlZVdlT3ZpekhzVlI0djA3RkZiK0Q2UU11a2NQUUtkd2JFdUgr?=
 =?utf-8?B?WDFLejZEa0FLTC8zcWVwSTdrZGlDenBBRjk0OWdYUlhoRkMwWC9pSjJHMnhQ?=
 =?utf-8?B?Q3JxWUsvYXpLTVp3QkNWckhzYS92cDFxdVZIdzVvaFkxd1JjV1ZXeHAwSStE?=
 =?utf-8?B?b2J2a0JyU2lIRkdPZkU1TVdWQjFsQWdNaGNuWVpWZmZGTU1KMVdSMmpraSto?=
 =?utf-8?B?T2FDYkpSdmdJSXV6YksyZHhZTzNmK0YvTDYwdTNzaTMvL0haU21jaUV6SEtp?=
 =?utf-8?B?VFpEYzVmOE9uanB4N3hMRmp1VzZ3Q0QyOE8yNTZrOElCSExJQUVjbE5zSDdU?=
 =?utf-8?B?Mnc5Z3BkU3l5cmg2bjEyd2U3VjNUMy82OVNwRHVIek9JUm1oNWFGWkZvc3BC?=
 =?utf-8?B?czZ5L1AvOWVud01rNWd2Z2Z4SWxHMjVURWhaUEVzRnF3ZkVqLzNsR3VKaDVF?=
 =?utf-8?B?d09EalhEK2xkVmFIb0Iyd1RiZ0FQZkNyTXNEMHFRTkhvcGZwaFprVEtHa3R0?=
 =?utf-8?B?aiszWWRjME5xSmlsNUpTc2ZEbmV3elYvSFNWNHFjbE14Q3FNQSsrWU11cm9N?=
 =?utf-8?B?azBRdndOL3k5ajVySUgxckJXV1d1WTRSS21YM3J1L0R2ZHpKQmRIc0dnL291?=
 =?utf-8?B?OHBJS1BzSVZHZEUySE1TeXVqT3hML2NyS2lhOUpWazhBY0NlZ0dLcUVLbFhG?=
 =?utf-8?B?U3ZNV1p2Z2NJeFd2c2F0VW83d1BVbGY2RVkrQXhhWG9VQzliUDR6SldCTUE2?=
 =?utf-8?B?NjM0Q0d5a3RndkN4WktxQlF1K1drZUtFVmtmT2VUbkpxM2oydzZNVlhqVGRl?=
 =?utf-8?B?QVczSGQ2RzJmM3V4OXdPOUhVbkprTlNDVHB0aTdaVm16ekkyanpsQnlzL29h?=
 =?utf-8?B?L09nWVM2YWF1UllkdE1nWVJ3THVFMkVvelJFbDFHNTR0Q01KaHNEQkNJY3Np?=
 =?utf-8?B?Z3MxenpiUDdyV2EvUEVqNHFkZThROXFWSnIxQXVFanU5c0Ftd2p4L3U4VFc5?=
 =?utf-8?B?b2J6QVp2emd2di8yQ2Y3VjRheW1nWmdKU2NIWCsySiszU1RnN3lyVkoxUTlT?=
 =?utf-8?B?MWUwS1RMSFhyZlFGODd1anljSzIyaWhKUjBoQjhVTFczWHhjWXZNbzRjMHdx?=
 =?utf-8?B?ZlppWE45RDJFbTkrSHFRRzdkOE4vRFpUYk9GbEREcDlzcHFyUFo2MkQxSGc0?=
 =?utf-8?B?c3V3emNUMEVzSm1LZzc4cTZ2ejNKMnUxczVFSGROWFNrK0xaSTFVODV5UERB?=
 =?utf-8?B?c1luRGVnU0duTUJpMmZmd2MvMVM5OFFmQ0NoVjlYcjU0dHNsWkJLMzVjMmVO?=
 =?utf-8?B?VXA2dVhIRWVNVWYzTWZsMDhTT1hMT2RINW1tU0tNd25hYmRHZ2xlSjltWTI5?=
 =?utf-8?B?QzA2TVBTYitJZ2xQMDBJK043Mms4YTVUU2NzWEt3TUc5dy9NZVY0YU85dnRm?=
 =?utf-8?B?NmUycGRJR1NNRHAyMmFXVDJUdVMxdzNlelBsYnhBR1F6MFRqY2RGamMvQ2Zs?=
 =?utf-8?B?czlrbjlzdjRTM0lzWjZmaEY3MHhuQXdHZ1J4R3pKVFFab2pCc1hRUDRoc3Uz?=
 =?utf-8?B?OGNSa0lpT3JUbG44QU1YanpkKzQveVdGcmhQUXpnRWZoWkp1S1hxaFB3SkZE?=
 =?utf-8?B?QnFpd3ZrNXl4QWtDSDFGMlY4eUxvUzRDbGZmcGVhTVhrUFIrYWZkRTlTUlNa?=
 =?utf-8?B?SXhKMFJPNFAvMUdzWERGbWNWaFRNVUkySkJ2ei9DNlZnZm1FTTYxVHRkeUlL?=
 =?utf-8?B?cFpwOHNVRnNYNDBTTnUxMG4zbk02cGZqdGVJcExjaWpvejlybzJtSlVESG9k?=
 =?utf-8?B?Y2VLd0ErZHBwN0czSU1SQjFpUnRLQkNYdlRwR295U2NaZVhzbDBSckpEQThD?=
 =?utf-8?B?b3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EF1A89CE255D4E4AB6FFCD174E43F7D4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3beb7c8-c448-415f-7731-08ddfba40609
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2025 19:53:25.0526
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FCK/NSIEGFIG9mAJtWuDjw3CZjyAU/No7+jN/42snJTK13XCw9AWWgMYU60+F8sFqedVavwAhbnRx/qT979RSFnZuZBMnQX3A6xo0rchT7k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7944
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA5LTIzIGF0IDIxOjUyIC0wNzAwLCBBbGlzb24gU2Nob2ZpZWxkIHdyb3Rl
Og0KPiBXaGVuIHRoZSAtLW1lZGlhLWVycm9ycyBvcHRpb24gd2FzIGFkZGVkIHRvIGN4bCBsaXN0
IGl0IGluYWR2ZXJ0ZW50bHkNCj4gY2hhbmdlZCB0aGUgb3B0aW9uYWwgbGlidHJhY2VmcyByZXF1
aXJlbWVudCBpbnRvIGEgbWFuZGF0b3J5IG9uZS4NCj4gTmRjdGwgdmVyc2lvbnMgODAsODEsODIg
bm8gbG9uZ2VyIGJ1aWxkIHdpdGhvdXQgbGlidHJhY2Vmcy4NCj4gDQo+IFJlbW92ZSB0aGF0IGRl
cGVuZGVuY3kuDQo+IA0KPiBXaGVuIGxpYnRyYWNlZnMgaXMgZGlzYWJsZWQgdGhlIHVzZXIgd2ls
bCBzZWUgYSAnTm90aWNlJyBsZXZlbA0KPiBtZXNzYWdlLCBsaWtlIHRoaXM6DQo+IAkkIGN4bCBs
aXN0IC1yIHJlZ2lvbjAgLS1tZWRpYS1lcnJvcnMgLS10YXJnZXRzDQo+IAljeGwgbGlzdDogY21k
X2xpc3Q6IC0tbWVkaWEtZXJyb3JzIHN1cHBvcnQgZGlzYWJsZWQgYXQgYnVpbGQNCj4gdGltZQ0K
PiANCj4gLi4uZm9sbG93ZWQgYnkgdGhlIHJlZ2lvbiBsaXN0aW5nIGluY2x1ZGluZyB0aGUgb3V0
cHV0IGZvciBhbnkgb3RoZXINCj4gdmFsaWQgY29tbWFuZCBsaW5lIG9wdGlvbnMsIGxpa2UgLS10
YXJnZXRzIGluIHRoZSBleGFtcGxlIGFib3ZlLg0KPiANCj4gV2hlbiBsaWJ0cmFjZWZzIGlzIGRp
c2FibGVkIHRoZSBjeGwtcG9pc29uLnNoIHVuaXQgdGVzdCBpcyBvbWl0dGVkLg0KPiANCj4gVGhl
IG1hbiBwYWdlIGdldHMgYSBub3RlOg0KPiAJVGhlIG1lZGlhLWVycm9yIG9wdGlvbiBpcyBvbmx5
IGF2YWlsYWJsZSB3aXRoIC0NCj4gRGxpYnRyYWNlZnM9ZW5hYmxlZC4NCj4gDQo+IFJlcG9ydGVk
LWJ5OiBBbmRyZWFzIEhhc2VuYWNrIDxhbmRyZWFzLmhhc2VuYWNrQGNhbm9uaWNhbC5jb20+DQo+
IEZpeGVzOiBkNzUzMmJiMDQ5ZTAgKCJjeGwvbGlzdDogYWRkIC0tbWVkaWEtZXJyb3JzIG9wdGlv
biB0byBjeGwNCj4gbGlzdCIpDQo+IENsb3NlczogaHR0cHM6Ly9naXRodWIuY29tL3BtZW0vbmRj
dGwvaXNzdWVzLzI4OQ0KPiBTaWduZWQtb2ZmLWJ5OiBBbGlzb24gU2Nob2ZpZWxkIDxhbGlzb24u
c2Nob2ZpZWxkQGludGVsLmNvbT4NCg0KUmV2aWV3ZWQtYnk6IFZpc2hhbCBWZXJtYSA8dmlzaGFs
LmwudmVybWFAaW50ZWwuY29tPg0K
