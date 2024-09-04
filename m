Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94AC117E
	for <nvdimm@lists.linux.dev>; Wed,  4 Sep 2024 00:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725409519; cv=fail; b=eF3OfZ2TxUC1lxQVYg/Sqx9WioEHl2xud/9E2gy94BcwSAo5W5Qqv5zxKD/N/b9BOHV7UQevO3PAXxkF2I7Abu2QiSb4DT2Tb8CANkcOI1LG5d/WYsChzYZZDuRZz8/lVhhnaIlkUqQ6pj0pw8AO3AWg7Jbd4/FETWwklDZases=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725409519; c=relaxed/simple;
	bh=lCDyHViHimrBgHdqfLrcu6Pr5utLb52o+N8cxrzOrAI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eKEKQp1EFUaK3VXhVKnwLl8Mdd7HFQf5eQ6PwAdSB/lvG0/GCiz1uYuxUaQCAry/OPXQxHqYybNvrWfTae/NBxzAJytmTJNqfisXPI4pvKdmeSdKNtXvoornzL1AHgDe63nJ9YZYjrnGubmei98Do2mspSUGcOy5gb5LrRBucBI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c95apowW; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c95apowW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725409516; x=1756945516;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=lCDyHViHimrBgHdqfLrcu6Pr5utLb52o+N8cxrzOrAI=;
  b=c95apowWGDjGiOVOnBSwMkNh3M3Dp0bPDYL7+RXUI1669HprFP6313Yt
   bXDDMQUScFVHU2nXJUpcN4z5xC61XUWuWQXpZ3VGfyugd6otyXXZ0OFl3
   ObWVxoZ+S7XlZfEmKa/npw1QXJp+o8Dfm4DNKO3z/r2yGpnSfejwglnEi
   +X4BvAOLD/9rRPMqycGtKu/PncFYmWrt0oBZv6dg7I6v6fTzwqWtCl6j1
   7MxBBDrb1I9yFdmbbDVfrU943Njw3E8dKuOY7q0y7+XjJPe/UTp5gW8dS
   hUllSXp1HJGPtR1rDEYBigAiXAJEIuMvcUO8HVucT2axgh1YpbwdCw9uC
   g==;
X-CSE-ConnectionGUID: Vf/y+89gQdKz3uIGggw+hQ==
X-CSE-MsgGUID: vX6pCSHMQ5y7w9r4qdv8Uw==
X-IronPort-AV: E=McAfee;i="6700,10204,11184"; a="35404684"
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="35404684"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 17:25:16 -0700
X-CSE-ConnectionGUID: EOFkWfGiSGSZM0+eHXUX3Q==
X-CSE-MsgGUID: OT+si7nmSl6IP0EOCJz+QQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="69903219"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Sep 2024 17:25:16 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 3 Sep 2024 17:25:15 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 3 Sep 2024 17:25:15 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 3 Sep 2024 17:25:15 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 3 Sep 2024 17:25:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OEw5bDIvj0Y14PXrSLx9wNfwFXwm5FhvAOS3Kul6Y+l5JW3Mu3O61uY3ZJtkqlS0E0lv7iL3xlIbz87WPBtazmigjlgqz9UzNSsOWMpaD8VViy/LG+dW05x6o/98LuNeSfFUkNBDPUUOuDxee04V1UcUnjxozPUnKcg7P5IN3BMZWAKN4NJRnY5FE8urgGzb6pUmUg2Lk4dkBdQJyXgQHdtyvJXm9I0CHB1+Gybe0yx/bME6GM7IUnpgJKqg0UpFFGlQpO9lE7tgKjOWK0Wv6Q4FvVosC9o4ImtQo4Shb4wtnebq7XWcpKJPIpY4o8DdiRUWX+9DYDQq52yZ6Dpg4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lCDyHViHimrBgHdqfLrcu6Pr5utLb52o+N8cxrzOrAI=;
 b=Xxt60g7/SH1K8/Zr8W/YC3ZVVNM+nliQ60LI4aEswTgH5SrXJnOCf3JCjxeBNBYHp0Auh/77iXz4ZCMH5PJhvrBn/5hPZFjQTrhphLbg7w1aX7Ng1KyQzkgnP/YGtWOtzfTKuvy6r6CaFKp6N7lK3AVtCaIaApbYuReIvdllJaz4sglhDPYyUhkzcZVsyme9lMDli324tXry+9NrzPi0cYn+4vFE0+GOGJge9Didv1J8nBL4s4uQMFczIXbaqblj2WbelyFdvLGPUxhleneR+xep89qIz3Gljeo+ytU7v+xFDVwbXMJ03z/vqySBIxvYbP5ZOm83rRwXv3uzsZVytg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by CH3PR11MB7770.namprd11.prod.outlook.com (2603:10b6:610:129::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.27; Wed, 4 Sep
 2024 00:25:12 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::eff6:f7ef:65cd:8684]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::eff6:f7ef:65cd:8684%6]) with mapi id 15.20.7918.024; Wed, 4 Sep 2024
 00:25:12 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Schofield, Alison" <alison.schofield@intel.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
CC: "Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [ndctl PATCH] test/rescan-partitions.sh: refine search for
 created partition
Thread-Topic: [ndctl PATCH] test/rescan-partitions.sh: refine search for
 created partition
Thread-Index: AQHa+YDeoi39K7YtsE+Fj7D0HC/hmLJGzsyA
Date: Wed, 4 Sep 2024 00:25:12 +0000
Message-ID: <f3ffd3d136bb7bea61368f1ee16a5ce37ba7ba27.camel@intel.com>
References: <20240828192620.302092-1-alison.schofield@intel.com>
In-Reply-To: <20240828192620.302092-1-alison.schofield@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|CH3PR11MB7770:EE_
x-ms-office365-filtering-correlation-id: 14d026a7-b212-4689-c619-08dccc780ac2
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?YTVCVmY0Ynp1RWxQWnQvWllSSllHRnZZSENDN2lRbVk0am9MaTZLZUtqUUl3?=
 =?utf-8?B?Z0tSOE1EUWtiaEEwNWUzbThIWm45c2xWbkM4UmhjVWlBTzhldVU1Y3lxWnRm?=
 =?utf-8?B?Yyt3RWRMVUo1eWhXY09JZk9ORzhZbHd3b3hQNmhQYWdwcDVQVnk4WWJSVk9Y?=
 =?utf-8?B?cHIrMlc5NWZhZk9UK3kvbkx3cDQzQkN5T2Y0ZHZlbHcrMjM0SWpFZFJ1Rzly?=
 =?utf-8?B?TlJMZjhpRFlSMGo4THlmZ1BiMGptYUJsb0UrT3Mrdm16YlRIUHhBNW9BMVdt?=
 =?utf-8?B?MlBVYjZmcjlyRmtrdE5xdFJML3JjZHhOUFNUWklRY09QTWR3L0JIQ25EM08v?=
 =?utf-8?B?SmFVRTExNld0NnlENDh5K2Z0aVJXRE5GeGVrZmtodWJpd0ZINmJKeXV0U0Y4?=
 =?utf-8?B?SVJGZU9SRGF3bWVyTlZOYkZxMmdldHIwNXNiTWk2MUVFTTJlcUdmNFRqQjJr?=
 =?utf-8?B?bDVJZlBhZjk1MHBqOVg5bzRwZUFNUnczaGxad0FpcHVlZjU3R3hWUzBBQXlZ?=
 =?utf-8?B?VGMvcU1hS1pqWmZZYStBN3dnRU5Wa0VkQnFpR2NDd0xmUGdza3YyUXRHZXNj?=
 =?utf-8?B?ekR4blVHTDhHQ1hLZzBDWWtFd0s2dUlkZnlSMHdQS25jcUk1a2hseUg3TDhx?=
 =?utf-8?B?c0dSckhHSlZ4bE1ScnVMK3BwWEVmeXJQeGUxTk1GZXh6cVpkTUdKaXJaTys5?=
 =?utf-8?B?Qm1LdzNaZXhMcHRvdkVKNENjVlg3VUp3RkMreU9HN0Q2VnNxelF2cTJzNkVy?=
 =?utf-8?B?eFM5TFc4NzdTWFBJNGtKbVdvV3F4aEZycHIzM1hBZThiajFNQjBwUUZVYVNi?=
 =?utf-8?B?MnR6WDJLdU1YaXR1NGZoaUVSUzNqUXBGN2l0RER2ODdjN2xOUFVTWE9DRU11?=
 =?utf-8?B?QTU4ZVNwOU5vR3pmSUxTSldjVkg5ZlF2T2k4NnRlMi90c2JmdjNiZFlya0po?=
 =?utf-8?B?amVVMlp3c2xWdmxzT2pRTnJ3Tm93R28xT3VtamUrbVRaTnd6TWg5SC9rMW9t?=
 =?utf-8?B?NWRxSVloVTBqaXhNbjFObFFPRldtZjd6cThacWFUa01oV1dTaUdwY0JEeFQz?=
 =?utf-8?B?SWFSWm11WlkzbE5jbXpEc255ck5IcUt2VUpTMEI4blZIUUxTVDlCNkVhNmM1?=
 =?utf-8?B?VXh3Ky8vTjhselY4eWdaR0o3WmJhK2VFa2xaUTZacFIrSEFLVFNhZXBzQVgz?=
 =?utf-8?B?RzVlY1ZlbDRyWVhmeTRrVG9nblZKYmU1ZXFibnBIVzduUEYySUJMVXMwdXN1?=
 =?utf-8?B?N0tlNHZwOXlYM3p2TzE0VllhTkxteHVhNWJmcUY1eDlPRkdqRFRyZDhrNndv?=
 =?utf-8?B?MC9PaTJMWjhnaEJNM0hiWFhFdEdaOWU5WnZyOWkrb2NDWWdvU2c3MW80bFN2?=
 =?utf-8?B?eTZDM1AxendWK3lZUGdzbmNvRnBrbGJ3SDNEZ3lid01YOVlsMTQ2UkxOdDJw?=
 =?utf-8?B?UlJ4VG5RQk9vUG1ycThDVW50dzhXTWNibFRTY0YxdmlTT0dTUlB1OGRDOEh2?=
 =?utf-8?B?NmJOMUt2V1BiK0psWHpFQ0pqU3JESHVqSHhzaFdVeXhvK2JZTWxrbDNFbXpn?=
 =?utf-8?B?eEszS0NZOVU5dllFL1F1cWlLcCs4Z2JxMlpSQzR4L281U2JoZDdNbUFzdUli?=
 =?utf-8?B?ZnlaWWZlbEN3dmJWbTFOcnhvdS9CSUg2dVZ1RS8zeDRFSGE0YWxicnNJSnN6?=
 =?utf-8?B?TjVvMDFtc3d3c1lFWXdUT0NMSjU3V2t2cWdMdlRVUjJLbGtTZ0UyMVNmRC9N?=
 =?utf-8?B?eHcxcHBNb285QXA0Mm05a2p5RVdNTWorbUJ1N3lkZ1lmY0g3RTA5QjdIeUd3?=
 =?utf-8?B?WFRSOWU4MS95Zjd4eDM4dktlb1J1V3hqbjlUWlE1d0xaU25ZTEdIQ01uYkpG?=
 =?utf-8?B?ekVKbDAyN2RsM0hNaU5STUhtdEJkZC9XY29YZEpMM3BVVEE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L3dlaGRTMmFJODRKYm5HeWJTRW05ODNENDNpcmhSaHJJTk9LYUxWcmd6ejlk?=
 =?utf-8?B?d2p3eDZkTFVPMU1SUDBEN2lxNDVlQWJ4dW00bEc2R3E0Y2lWUUhvY01CRE16?=
 =?utf-8?B?eGpmUWRMOTJBNDB2OURwL01vT1o5S29laGhNa1ZZM2lSUlhxcTU4eFZvVk16?=
 =?utf-8?B?R3B0RC9zazFucm1KUHhkWkYxQmZ0U0drVzN4Vyt3OGRjRDljeXJwbFhEMGh6?=
 =?utf-8?B?bkVXeTZpdC9waHVmKythOUlrVjBsbS8zS3U2VTdseGJ6NHd6QVMyeXlRSXFR?=
 =?utf-8?B?N1p3bVJKT0hKbXcwVnV6MXdZU0xIcGtEdVhGeUJyTFdRKzlHTVNOVUlSTjNy?=
 =?utf-8?B?citxNFBTNDRGZGVSbG04cllXVWlBSWdYQ3hGdnNjY2hiUUl6MkNQbzR1R3dL?=
 =?utf-8?B?bXMzbXNRcjQzdVIwZFZjNHFjZld1Y1VMbUhtakpkalJ1TElSVnEzbmNaRFNK?=
 =?utf-8?B?QisvWm45aWduL2xkQXpORjgyRHN5WDlGekxJMVV4RHBiTWxQa1FmanA3TW9J?=
 =?utf-8?B?SjlDMHlSZXltMkx2QlpmcDVSNjJLTDNMS1ZRK1dJZVA4dWJUMGNsTm90eUR5?=
 =?utf-8?B?Um1vRWRXc1o5c1dScmx4LzFicms0c1NlSXM4ODYxQno2aHhCN1VKMmdVSDlY?=
 =?utf-8?B?MHI2Z1VMUG10S2VjRTNZZ0R2Q0h4anNBYzRMSGxwbWlnNUVNV2xoVC8rMVJr?=
 =?utf-8?B?d2hkSk02a1pPNDZyT3QvTDhkNG5IdndlbjhUUlVSYm1jbDFDS0oxMFh6NGVO?=
 =?utf-8?B?bTZMWk5WSnd6MkNBQ1ZRTUpKU2FNQm8ydDNMSHlJTE9sK1JTYVAyYTlienhI?=
 =?utf-8?B?R1M3QmZKQTFyaWo4WnNwZ2RuTEdvZ0dFbW5jQ3NRcC8yQnIvMkVLSzVNZEpr?=
 =?utf-8?B?dE9mSDJUOFUyWnZkRU9lelE3RnpGMmNSc0tTeUJpamltUUdJaWo4VmZJZ3d3?=
 =?utf-8?B?V2I2S1AzaTJFL0ZBVmtvRWw4Y3MvejhvMkVZRXVnb3ptbnhiRlU1MEVYVC90?=
 =?utf-8?B?TjhxaG9td0p1a3hqbmtzT3VrOUtXQkwycTY3QjR0M01JbDRtakhXcW1TbndQ?=
 =?utf-8?B?WlBVWjRMa2cxUXRLOTA5K0JEcUowZkhLRzBYSHJaSnBpdXBFTEZ5SWc2SUVk?=
 =?utf-8?B?TEI3akVaNjdVdjRiNnhnZTltUUZxU2lWZGFMVnJvVTY0VnZCL0FVQ0JXQTRI?=
 =?utf-8?B?OW5xdnRpQzRZUVJrK01WeWt3Y1dYRjFENjBTWUsraGJ0YTNyWXltYW54Y0I4?=
 =?utf-8?B?L0xlREhHTEhiNkEyWjBTQkRaVi9NSGdDZHFDdVlrR1RSOUhDRHhmcVYrUEY1?=
 =?utf-8?B?elJHV2xPdUR1Q01uNGpSTW5UU3l5RzFjd3B0NnBIbXhwenNEWWxTMExOWmhJ?=
 =?utf-8?B?ZDJub25ydWpQVm00U3ZZR29USUMyQW5BQ2hFZllvNlcyRnMzY3U1Qm5jdC9K?=
 =?utf-8?B?VmpJSjlhRmhWQ2VHQ2VvTWpzZUlxOTJpTEV2enFOdk43ejhqNERNWkhkSDVC?=
 =?utf-8?B?SWNHdFFBRFdJNzQrMWZqZ2JhTGNqMEVzenVyU013TmY3WHlqVk5Za1kyMzhT?=
 =?utf-8?B?dzFoTW4zVXZwL3Ayc2xJbnVoSklTV0NnUmwyTWNESmg1Q1dqT1Y5VGp2NGdT?=
 =?utf-8?B?SjZCanRGYlJ4Zys0NHNuL2JDSWN1Z2U4d2dzc0lDcWx2b0hhbTJtbVNWWTJJ?=
 =?utf-8?B?WFpjWFdlRVV5Nk9xc2I0N1hrQnU3RFNMRlM0RkZSSCtlcVUvdTdwaFdJZTJF?=
 =?utf-8?B?YzVEaUltVEV0ZWJmc1pvbyt0RkhmSWZaWW1MMytXdVloSFBlSjVYektZcVgv?=
 =?utf-8?B?OEk1a3hYN01lZGQybE9IZ0g0MlpOeWgxaG43MnU1elZXZmhwQ3l5YU50eWdU?=
 =?utf-8?B?ODVOSXZUcForRTRoVm5WMFU4c0JOZktrTW4xQ1NGV3FySWRpYnNHU01sdlkz?=
 =?utf-8?B?N2RadkRxdUhkMFBLK2xldzkwQkdEc1l4Q1VSaTZRTVVzVFNoNnF4aENSaWNr?=
 =?utf-8?B?bmprUjZtR2NkMlF1OGR1Z0ROZmo5S3NVM2tHMnc1dnlUTzdmMSs5bEYxQkhY?=
 =?utf-8?B?Y1JaM0doYjc0NzN3UlBCeVpwL0NxNWg5enJyRVRDVmhsNlBEelU0TFZ3YlNh?=
 =?utf-8?B?VGJxMXBMUmVCU0RERmN6a3V0eFJkVjRnbHkxOVhtS3pKTmg0SS9SQ3ZCa2g0?=
 =?utf-8?B?ZlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <678DB347F5750B4B966B14F785CAEBE2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14d026a7-b212-4689-c619-08dccc780ac2
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2024 00:25:12.8048
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Kre9RDHqnMhg6S2v6nZqs2GHMPsrM5qstwQVg8VB6+hLFR5H0aIQxYS30B7t2NJuGsyBrlw5AM/bslbWyOsSm4hEvFtwrXBzEVVGkrdIMzk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7770
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA4LTI4IGF0IDEyOjI2IC0wNzAwLCBhbGlzb24uc2Nob2ZpZWxkQGludGVs
LmNvbSB3cm90ZToNCj4gRnJvbTogQWxpc29uIFNjaG9maWVsZCA8YWxpc29uLnNjaG9maWVsZEBp
bnRlbC5jb20+DQo+IA0KPiBVbml0IHRlc3QgcmVzY2FuLXBhcnRpdGlvbnMuc2ggY2FuIGZhaWwg
YmVjYXVzZSB0aGUgZ3JlcCB0ZXN0IGxvb2tpbmcNCj4gZm9yIHRoZSBleHBlY3RlZCBwYXJ0aXRp
b24gaXMgb3Zlcmx5IGJyb2FkIGFuZCBjYW4gbWF0Y2ggbXVsdGlwbGUNCj4gcG1lbSBkZXZpY2Vz
Lg0KPiANCj4gL3Jvb3QvbmRjdGwvYnVpbGQvbWVzb24tbG9ncy90ZXN0bG9nLnR4dCByZXBvcnRz
IHRoaXMgZmFpbHVyZToNCj4gdGVzdC9yZXNjYW4tcGFydGl0aW9ucy5zaDogZmFpbGVkIGF0IGxp
bmUgNTANCj4gDQo+IEFuIGV4YW1wbGUgb2YgYW4gaW1wcm9wZXIgZ3JlcCBpczoNCj4gJ3BtZW0x
MCBwbWVtMTIgcG1lbTFwMScgd2hlbiBvbmx5ICdwbWVtMXAxJyB3YXMgZXhwZWN0ZWQNCj4gDQo+
IFJlcGxhY2UgdGhlIGZhdWx0eSBncmVwIHdpdGggYSBxdWVyeSBvZiB0aGUgbHNibGsgSlNPTiBv
dXRwdXQgdGhhdA0KPiBleGFtaW5lcyB0aGUgY2hpbGRyZW4gb2YgdGhpcyBibG9ja2RldiBvbmx5
IGFuZCBtYXRjaGVzIG9uIHNpemUuDQo+IA0KPiBUaGlzIHR5cGUgb2YgcGVza3kgaXNzdWUgaXMg
cHJvYmFibHkgYXJpc2luZyBhcyB0aGUgdW5pdCB0ZXN0cyBhcmUNCj4gYmVpbmcgcnVuIGluIG1v
cmUgY29tcGxleCBlbnZpcm9ubWVudHMgYW5kIG1heSBhbHNvIGJlIGR1ZSB0byBvdGhlcg0KPiB1
bml0IHRlc3RzIG5vdCBwcm9wZXJseSBjbGVhbmluZyB1cCBhZnRlciB0aGVtc2VsdmVzLiBObyBt
YXR0ZXIgdGhlDQo+IGNhdXNlIHRoaXMgY2hhbmdlIG1ha2VzIHRoaXMgdGVzdCBtb3JlIHJvYnVz
dCBhbmQgdGhhdCdzIGEgZ29vZA0KPiB0aGluZyENCj4gDQo+IFJlcG9ydGVkLWJ5OiBJcmEgV2Vp
bnkgPGlyYS53ZWlueUBpbnRlbC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IEFsaXNvbiBTY2hvZmll
bGQgPGFsaXNvbi5zY2hvZmllbGRAaW50ZWwuY29tPg0KPiAtLS0NCj4gwqB0ZXN0L3Jlc2Nhbi1w
YXJ0aXRpb25zLnNoIHwgNiArKysrKy0NCj4gwqAxIGZpbGUgY2hhbmdlZCwgNSBpbnNlcnRpb25z
KCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvdGVzdC9yZXNjYW4tcGFydGl0
aW9ucy5zaCBiL3Rlc3QvcmVzY2FuLXBhcnRpdGlvbnMuc2gNCj4gaW5kZXggNTFiYmQ3MzFmYjU1
Li5jY2I1NDJjYjJmNjggMTAwNzU1DQo+IC0tLSBhL3Rlc3QvcmVzY2FuLXBhcnRpdGlvbnMuc2gN
Cj4gKysrIGIvdGVzdC9yZXNjYW4tcGFydGl0aW9ucy5zaA0KPiBAQCAtMjQsNiArMjQsNyBAQCBj
aGVja19taW5fa3ZlciAiNC4xNiIgfHwgZG9fc2tpcCAibWF5IG5vdCBjb250YWluDQo+IGZpeGVz
IGZvciBwYXJ0aXRpb24gcmVzY2FubmluZw0KPiDCoA0KPiDCoGNoZWNrX3ByZXJlcSAicGFydGVk
Ig0KPiDCoGNoZWNrX3ByZXJlcSAiYmxvY2tkZXYiDQo+ICtjaGVja19wcmVyZXEgImpxIg0KPiDC
oA0KPiDCoHRlc3RfbW9kZSgpDQo+IMKgew0KPiBAQCAtNDYsNyArNDcsMTAgQEAgdGVzdF9tb2Rl
KCkNCj4gwqAJc2xlZXAgMQ0KPiDCoAlibG9ja2RldiAtLXJlcmVhZHB0IC9kZXYvJGJsb2NrZGV2
DQo+IMKgCXNsZWVwIDENCj4gLQlwYXJ0ZGV2PSIkKGdyZXAgLUVvICIke2Jsb2NrZGV2fS4rIiAv
cHJvYy9wYXJ0aXRpb25zKSINCj4gKwlwYXJ0ZGV2PSQobHNibGsgLUogLW8gTkFNRSxTSVpFIC9k
ZXYvJGJsb2NrZGV2IHwNCj4gKwkJanEgLXIgJy5ibG9ja2RldmljZXNbXSB8IC5jaGlsZHJlbltd
IHwNCj4gKwkJc2VsZWN0KC5zaXplID09ICI5TSIpIHwgLm5hbWUnKQ0KDQpIbSBzbGlnaHQgcmVh
Y3Rpb24gdG8gdGhlIHNpemUgPT0gOU0gY2hlY2sgdGhhdCB3YXNuJ3QgdGhlcmUgYmVmb3JlLg0K
DQpXb3VsZCBpdCBiZSBiZXR0ZXIgdG8ganVzdCB1c2UgLmNoaWxkcmVuWzBdLm5hbWUgaW5zdGVh
ZCBvZiBsb29raW5nIGZvcg0KYSBzcGVjaWZpYyA5TSBzaXplZCBwYXJ0aXRpb24/IE1heSBiZSBt
b3JlIHJvYnVzdCBpZiB0aGUgc2l6ZSBldmVyDQpjaGFuZ2VzIGZvciBzb21lIHJlYXNvbi4NCg0K
T3RoZXJ3aXNlIGxvb2tzIGdvb2QsDQoNClJldmlld2VkLWJ5OiBWaXNoYWwgVmVybWEgPHZpc2hh
bC5sLnZlcm1hQGludGVsLmNvbT4NCg0K
