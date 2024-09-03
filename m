Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538D2126BE4
	for <nvdimm@lists.linux.dev>; Tue,  3 Sep 2024 21:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725398906; cv=fail; b=MFewo+FIGJtx7SCnYRf295ldYL5UocZOWEvAaJHA1O+CD/euRatj7KWJW8w5vXued84KOHm/bBPK26QNj2AlHazC5cihXZQ8RVx53L7LE8yRlmIopLofp/BMQatk+yMj5EyQpdKaeHYOEXVhT3JE/8ANDuarhuc+71YKm/8zAqc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725398906; c=relaxed/simple;
	bh=R+lFRx2mm6myGMsTTrgmGBWj/RHnfJFGyKA8aAtlpdw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hwsvq+P2bsAmWpBQI2boXEJVdaYY7a0JDHkJgLsiOnAewOzCy5xPkMoHo1LNzGl/P476kHTEApd+12WZUhZfPhU6re+GYNIIW9jjHKyxKiVr/tg9Oyy4CwdrZlFAFg3wyubGnT+kv4nnfBTLIE993O99cU+8V8RDXHyoswHLX+A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=drOqsu5q; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="drOqsu5q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725398905; x=1756934905;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=R+lFRx2mm6myGMsTTrgmGBWj/RHnfJFGyKA8aAtlpdw=;
  b=drOqsu5qOevUzGnrhLzprNL8KkfLFPn5lqCB2xqprAktBdZHw4+ZCnYW
   UXYKHeSyBcocOA7QNEN/acxcN9mu8+oZIG8z7AFrptvEYyWGHsMfYobGp
   FihQmZIDeGvp3Jf23INjF/61uLQwcsCgsMikiDSKKPVf3gu0Ugq5VzJHC
   +wQy0I1hTbKutMwfzrgCRh2ja5791sFy95V/5h/H2w2FXbmOfCFwtmU75
   NFWMrdAsZpzn06LVrO0fewRXVDb0OjfdAWEYgtlwS93adfZIG+94tzODk
   LuG72qYdNd0FKCJsnyz7ndNXRffzpljY/K34j7FqrLYPT+MUjLmdhCmqW
   g==;
X-CSE-ConnectionGUID: xnBVp4dlSn2w3qa9rFAUmw==
X-CSE-MsgGUID: n6vtr5t5R4SKqpGb8mJ9dQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11184"; a="24191532"
X-IronPort-AV: E=Sophos;i="6.10,199,1719903600"; 
   d="scan'208";a="24191532"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 14:28:24 -0700
X-CSE-ConnectionGUID: G6e68NAsRvidWi/jZNt2UA==
X-CSE-MsgGUID: Otyuf31PQd+2bW/ZzlOyYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,199,1719903600"; 
   d="scan'208";a="95846856"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Sep 2024 14:28:25 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 3 Sep 2024 14:28:23 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 3 Sep 2024 14:28:23 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 3 Sep 2024 14:28:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PWKS+k80QQoELuaSWrgqvYg/l2IROJgUtJEIYnqjM7hNmEfvSrPclb01zteTOvhBwG9be6yQJ32FnNl9lpZVZoHWHqH7uV2JT7KEZfDcfxjkdGHApkYUSs9NmqQaqzHvQxL63ClaK36fIjZ9ihZ5/aczdUl557RTtrayEmzIPahZKye5m6kxVKdz8pMojjQkBFBpISih7eegKhu+QJvdV80OUNM3N0hLb/AkdVV5JHQBBub01k1kLvnB8nC6iu9X1jxxeQZS6EDQyy61zaWNYVkbGQV+BYV7FkvU8RxSB850Cfv25bkmCUiesTndGz5o1y1ywojp+CjdHmpY1grDdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R+lFRx2mm6myGMsTTrgmGBWj/RHnfJFGyKA8aAtlpdw=;
 b=CY4hBBnKbjikggrTaiCKZOzWM1kZYfTI9FvzaNymZYvaHE/VnB0zT8gb5lOt6MmFo7Ts4FvZlKG2LrRevDl+SOG2Mk44DiTRcAHodpB65efqDZ4ny8Vd6DdFB2dk/5VXP/zwIhrI0kPugvFVrS26kggWIKHNvJJyRWTOa8KNQD7j3ZV6Og7eyhKVoN7uKrielY7f50a4KsIFImvEyWhI1DO01jxSv9EciNM8+srlcHwWNJFne/FI/gyDXmMZpLWDmsaKPupdF4ceja/VHPHlxFBwU4AtV70dTrEhvddlhwv+UjaVgic4iYViArxbVHyGxnp/WLUgF/To40UGKbsLAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by PH7PR11MB7432.namprd11.prod.outlook.com (2603:10b6:510:272::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.25; Tue, 3 Sep
 2024 21:28:16 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::eff6:f7ef:65cd:8684]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::eff6:f7ef:65cd:8684%6]) with mapi id 15.20.7918.024; Tue, 3 Sep 2024
 21:28:16 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Schofield, Alison" <alison.schofield@intel.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
CC: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH 1/2] test/daxctl-create.sh: use bash math syntax to
 find available size
Thread-Topic: [ndctl PATCH 1/2] test/daxctl-create.sh: use bash math syntax to
 find available size
Thread-Index: AQHa+PhtTAG+kYbsOEy+KKKbv/QLgLJGnm0A
Date: Tue, 3 Sep 2024 21:28:15 +0000
Message-ID: <b18a49223ed6c59e7e8787c56bd9e63878c919ad.camel@intel.com>
References: <cover.1724813664.git.alison.schofield@intel.com>
	 <865e28870eb8c072c2e368362a6d86fc4fb9cb61.1724813664.git.alison.schofield@intel.com>
In-Reply-To: <865e28870eb8c072c2e368362a6d86fc4fb9cb61.1724813664.git.alison.schofield@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|PH7PR11MB7432:EE_
x-ms-office365-filtering-correlation-id: 5525faea-adba-41c8-a110-08dccc5f52a4
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RWZaVldjU0ZQYnVPVG5jeHJiakNPSnIwN0JRY2NjUmE1S3p4Qytsc0paU1NJ?=
 =?utf-8?B?T2oyczVNdVJaN1h5SFFMYUdVeEtWeGZQQVRBRnBweTMxOGhRTG4rUnhrV1pw?=
 =?utf-8?B?SDBuRW0yRFVxQjB1MllPS2wyc0FHbXhqRW9TWmdMNEdLRkFVWklQNTZLeGsz?=
 =?utf-8?B?RFUxRWFsMU1TZHJjNkd1OVpSM1RFWWV3b1VxQlRwRithRGRwSHJwd29ZeDNW?=
 =?utf-8?B?TmVDbDZBT0J2L3JXKzQ5SnVxc0c4ZTFFdXFmaC9LRXdvdExPUXF1TEJmVERH?=
 =?utf-8?B?RTc4N0JMcmtzc0ZPVTZqajliczFpT1VCZmxZRUhtSHZoZnJYRFBnbHQ1WFB2?=
 =?utf-8?B?RnBSeWtMVFgzTldOU3lwL2UwcmI1MGJSRUZoWks2WUQ0aURmQTBpYXJjODEz?=
 =?utf-8?B?WEU1dnQyZmlndjY5UVovK0g2ZGVFYm0xdEh0bmdZakE2NEVHdzdBbzFKWE1J?=
 =?utf-8?B?Q0pEbjJZZE5GdncvbXZ0N3o0bmFWZ3hsNjg0U2diRkRFZTU0bE5TWWF4b1kx?=
 =?utf-8?B?MmJUdnpWaGxiUzFGQUx0eHFVVG9JdWJRYWwyRHRLSFN4bmRhWUZ2NUhVR29D?=
 =?utf-8?B?bWsrODE4TGNBSG1vNVJLcW1oajBuaE1FYUZGRlh5VkgyaTNDblVHSGY1TVMx?=
 =?utf-8?B?WjJtS2lhdmhEempZME1VRFVBdlRpZWVIY1g1b29XYVhtd3NSRDRqbFhlOTR2?=
 =?utf-8?B?Ums1OU9HYTJRU2xWTG4ycndiLzgrYUJ3U2NkSnI0bEI3UkhaRGV3NUJmcVhq?=
 =?utf-8?B?cUhCQkxKdUYyNXg5cDJ6Rm1XKzlSdWlwTDNyMUFDNnpLdDl3ZFU5U210SldE?=
 =?utf-8?B?MS9HUU4rSEJkWFVBK2QremEyTTExQUNCdEtTRGNqWG43SjB1VHpnVElrTXF2?=
 =?utf-8?B?VS81VWM3NW01V08zY2xVZXNwL2pCcTZ5T3haUjlMQ25tY0JLcC9oNmZsc21w?=
 =?utf-8?B?WitMTGtuWTNlai9kdDBJVHV4cW5aeXo4Qm1NUW1FY3IzMjczYTc0WWV5Lzkw?=
 =?utf-8?B?eWpPTG9JV2l1YkFyVU5nbDRabERLN1J1RTN0WGwyZ2s3dWlCTDQ1a2hhRUF1?=
 =?utf-8?B?d00ydTJ4Ukh3MTlLamd3QXJBaEVIc3pOZmlBYXplUnVEci95YXpicHBGc1Nq?=
 =?utf-8?B?ODcxY1Y1VHVVSXdUbUc1UE5hdm5yYzBuK3lyY1paWVNvNWdINVl4MTlCVnpx?=
 =?utf-8?B?R1BHbEJXT3loLzlDdlZZaW8rNGpHMFd2OUQ1UzR0SG9UMkROemxKU2VGempF?=
 =?utf-8?B?UFpuKzRBaUpSQndXc1d6eGh2NkpiNkhXajU4VnlobjdOQzJ4ZStrSTJuZ3Yv?=
 =?utf-8?B?aGVBVWtIK1ZvOHlTQ1JjWHBac0FPYlRKVElRV3A0VDB0TVNNK21JVVlvZUFG?=
 =?utf-8?B?NnNUZFNteGpmVExyaDNvZzM4QW1mbkhDWU0xbmlKQ0tPVDVyWnhDcmZmTHJq?=
 =?utf-8?B?bWdRV3RNR21qQklkMkdwWUE4QVNHWG9TR3lnTHI3MVNUV2RsbENsU0NWMUdj?=
 =?utf-8?B?YmVqRUFvU2VuS2h4dUxxNWVSdjJEWlZNbVRabWhRTXdRZlRJS09HSUw3Z1Nr?=
 =?utf-8?B?eFluTnd1UDdQbjluWWZoT2dRMU0vTkplVk44VXFLUDJUWmQxek1Xd1hZMmZv?=
 =?utf-8?B?ZGlQdXh6VGRZZHJlZWZRWHQvaGI2QjBocUdDSWJEQk0rSzFrMDUwM05KYWh1?=
 =?utf-8?B?VnF2ZURMS0l1dEwyZUNUaGVOMEFadjNPdkdCK2dUMjJvVnNkRCtyYyt6VGN2?=
 =?utf-8?B?alJXSnFGQXN3VDVKTG5QWTRIY3IrNXIvdjBXMlBGYVdmU1hIWFJqY1hVVEhs?=
 =?utf-8?B?L29UU1lOV0Fkb0F0a2k0RWVseExKUlVIL29rSWJRdEFRY3g5MzA3VE9ySFpT?=
 =?utf-8?B?c0ZKOTF2Z0ZpZXlFelpYcWhiUjNWbi9BbVcxekhDSWtsSFE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VkdoM2cwM3k3Nk1PODNBTXNWcWZnbUhaQU1FV1gwYno2aVNGbVJGMG5XaHpW?=
 =?utf-8?B?MFJxT3dmcy9DcXA1TWNDbmxFVzdzNjBvZUVWM0c0aGxoMXY5bi90bEVBbVht?=
 =?utf-8?B?MDhTeGFPVG5kUDZneG8xWVpkajlCM0N0b0M4UFFzamNvRUd1bkFGL0djdDh2?=
 =?utf-8?B?aG1xTmVhQ3FuU2J3bVZkYUFkdktmY1kva05oOTE3QTlVeDJuT3V6VURSRE56?=
 =?utf-8?B?cG1lbWxZakF2M2NxUTNHWEJLTU5jUmsvWXdBS3RhV0dlOVo3c3FKWUFrY0ZY?=
 =?utf-8?B?NVp2b2lrMXRCcGVtQ0xDbmwzZHdEQ0Z5aW1Ka2JCdTZ6NkNKbCtocG16emlv?=
 =?utf-8?B?RmJtQ25oTHhBNEpJOGhZVzRqTS9GUmJPaG81K3pWY3NqbzlPOHFPdDhHUEVr?=
 =?utf-8?B?OGxDdER0aW9NT2pmd0ZGL0RKUElkWHh3OWZzazhoVXlLU2xZK0lYQ3M0dEdF?=
 =?utf-8?B?WnJzRWkrSWVzd0RNMVVFWjNzV0liTXNlUjZTK05MNHRsR2t0UTcrSFhtODlQ?=
 =?utf-8?B?MXpNME1QMDJDSm1SRXNHdEZBWC91b2c5cllxKysrcDVKZHpkYTg4RHlzM2xm?=
 =?utf-8?B?SWtSL0JsQlBtVW5xVjdzaUhHUFN6ZVhpZnYvblBRVmxsUHJITmRVWTRCYTVi?=
 =?utf-8?B?d2d6TDlGVmhWNHhCd3BUQzVxaU1nTGUxd0xoNDhrTjB1VVhwOHNDcFRjeVh6?=
 =?utf-8?B?RGZqeDhpMS9nejJYVFZJdFZpdWU3Qlh0b2N3ZnNQelFQeDE4am40amNDM0xR?=
 =?utf-8?B?TG9HUEh3QWk1VTdFRlkxUHFvU2ZBRnNjNmo1bkVra3E5QnQyUWd1L1RrZzR3?=
 =?utf-8?B?bFZtbGZjcUJJc04wa3dnYWxxRUtBQjBvZ3dkM1J1aXhZUVJyM1lrdHJOeW5H?=
 =?utf-8?B?ZXZEZUxMUDNsQnZMTkcrNFIzY1ZydFV5WGVhK2NUZkQyaFd1Sm92aUUvZVdp?=
 =?utf-8?B?NjdVbTVwNDJRaHBSWmMyMjU3a0g5TVhiQ3B6LzA0emdJWWF5Ky94dW9QTll3?=
 =?utf-8?B?Q2tGNG90emptS3ZvUjRPNXVrZ1ZnN1hELzBLM2Flc0E5UlhrRW5TSTBwam1r?=
 =?utf-8?B?Uklhei8xZmZFcVI4eDFqZU9CMDBoWmJxT2V3dE1xZDZ3eGFsV0JCNUZVMURD?=
 =?utf-8?B?citWMzE2cFFZZnl3dXh5ZjFiU3lOdFNOUXprWjUreFRTUUVnZGhMQy9RZlIz?=
 =?utf-8?B?a3NNRndsdlcwMWFhRG82bUwrVHc1bTBXMVAwa2JVcEp1aFc0ZXlYcWE2TkY4?=
 =?utf-8?B?UG1RV01TblBHT2pvYWYzK0tyWUx0UGZZZ3VpT05JdFNENWdnOUdobmRwRDBD?=
 =?utf-8?B?ZGNUVXdFL1pDVjVRQ1JHYTY3SnlyTExWMjdRN3JhbDJCWHVBTit5QU1NVUVl?=
 =?utf-8?B?eWJoalBKQW1BKzVtazB4NGNjVityOEFXdFdzd0dJVisrU2VNRlpVcUdqUTY1?=
 =?utf-8?B?VEJlT3FBNDlYQW05QThBZHNoeGJ6QS9iWHk2dmV6a3BiWEVsOHdSNU1jMU1z?=
 =?utf-8?B?OHJVajRHYVVyTGVCNWhTU1dnT3NjZGplemhoRFFKVlQvNW1zUUhMNVorb0VD?=
 =?utf-8?B?VllOeUlObURvci9CaDkyeThoUW4xbHk0c0kwTGJ6cEFHeEdTTkFoWHRRSlRr?=
 =?utf-8?B?RXpCWGNFTm10M25xeGIzTnpkRXVRSkw4K2l6OStrTUdyck1OUnNTYUw5ZVVW?=
 =?utf-8?B?T2hTVHJLY2R6MkNVVjBGT2hab2pzMDdpQjJVSGxWU2wwQkZVUkZ6eHFoSTBG?=
 =?utf-8?B?eldCZlBqOGFBR2haM1BRNTBFWld6T1Z3RE0vQWU0Wk85TEFIWHRFN0hZRk1t?=
 =?utf-8?B?YXNLZ0hRNjhCSm9XMFAyMnpvYldRR1hkcUg4dnJsa090dENLK1M1N2MxTFZa?=
 =?utf-8?B?bXI4NHIzVVgyNFJZMHhIOER6dG1CRy9kVmlVQngvNWk3YThST3FDNXpaUjN2?=
 =?utf-8?B?RFpkZTYvN3pkU3NtL081YWdFa1ZxRlZTQmpYQ2FvQUZrSDlkRHhRZzhaeDhy?=
 =?utf-8?B?T1prZ1k5d2hGOHk5Q0VSak5wYk9DTVhoc2FDRG1jeVkrZmpSNmwzUjNSUWZZ?=
 =?utf-8?B?WVpMQlBLM3MvTmJQcW5JL0tTQ3NOUFNHc1NmaUpwS2Z4Vlk0TWw5bGI3Y2VJ?=
 =?utf-8?B?Q25vT25lNWFOMzVZNVlScy94dzJvMkZHQkM4Vjc5djRwZVZCQng5b2ZDaWNV?=
 =?utf-8?B?NXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <03CFD6BF1C4B6E47902B59F020DA23DA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5525faea-adba-41c8-a110-08dccc5f52a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Sep 2024 21:28:15.9926
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WyCR5BVDrO2WNXXlEqBp3QDnzCLD+R0qY4Nn+/JDpSjg46dNXANYw4NrXCK1rAA2324vdeUPcIt2Vy/3ZaI97bhwn/kz20OAkeYjAxvmcl4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7432
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA4LTI3IGF0IDIwOjE0IC0wNzAwLCBhbGlzb24uc2Nob2ZpZWxkQGludGVs
LmNvbSB3cm90ZToNCj4gRnJvbTogQWxpc29uIFNjaG9maWVsZCA8YWxpc29uLnNjaG9maWVsZEBp
bnRlbC5jb20+DQo+IA0KPiBUaGUgY2hlY2sgZm9yIDFHQiBvZiBhdmFpbGFibGUgc3BhY2UgaW4g
YSBEQVggcmVnaW9uIGFsd2F5cyByZXR1cm5lZA0KPiB0cnVlIGR1ZSB0byBiZWluZyB3cmFwcGVk
IGluc2lkZSBhIFtbIC4uLiBdXSB0ZXN0LCBldmVuIHdoZW4gc3BhY2UNCj4gd2Fzbid0IGF2YWls
YWJsZS4gVGhhdCBjYXVzZWQgc2V0IHNpemUgdG8gZmFpbC4NCj4gDQo+IFVwZGF0ZSB0byB1c2Ug
YmFzaCBhcml0aG1ldGljIGV2YWx1YXRpb24gaW5zdGVhZC4NCj4gDQo+IFRoaXMgaXNzdWUgbGlr
ZWx5IHdlbnQgdW5ub3RpY2VkIGJlY2F1c2UgdXNlcnMgYWxsb2NhdGVkID49IDFHQiBvZg0KPiBl
ZmlfZmFrZV9tZW0uIFRoaXMgZml4IGlzIHBhcnQgb2YgdGhlIHRyYW5zaXRpb24gdG8gdXNlIENY
TCByZWdpb25zDQo+IGluIHRoaXMgdGVzdCBhcyBlZmlfZmFrZV9tZW0gc3VwcG9ydCBpcyBiZWlu
ZyByZW1vdmVkIGZyb20gdGhlDQo+IGtlcm5lbC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEFsaXNv
biBTY2hvZmllbGQgPGFsaXNvbi5zY2hvZmllbGRAaW50ZWwuY29tPg0KPiAtLS0NCj4gwqB0ZXN0
L2RheGN0bC1jcmVhdGUuc2ggfCAyICstDQo+IMKgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9u
KCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvdGVzdC9kYXhjdGwtY3JlYXRl
LnNoIGIvdGVzdC9kYXhjdGwtY3JlYXRlLnNoDQo+IGluZGV4IGMwOTNjYjllMzA2YS4uZDk2OGU3
YmVkZDgyIDEwMDc1NQ0KPiAtLS0gYS90ZXN0L2RheGN0bC1jcmVhdGUuc2gNCj4gKysrIGIvdGVz
dC9kYXhjdGwtY3JlYXRlLnNoDQo+IEBAIC0zNjMsNyArMzYzLDcgQEAgZGF4Y3RsX3Rlc3Q2KCkN
Cj4gwqANCj4gwqAJIyBVc2UgMk0gYnkgZGVmYXVsdCBvciAxRyBpZiBzdXBwb3J0ZWQNCj4gwqAJ
YWxpZ249MjA5NzE1Mg0KPiAtCWlmIFtbICQoKGF2YWlsYWJsZSA+PSAxMDczNzQxODI0ICkpIF1d
OyB0aGVuDQo+ICsJaWYgKCggYXZhaWxhYmxlID49IDEwNzM3NDE4MjQgKSk7IHRoZW4NCg0KWWlr
ZXMsIGdvb2QgZmluZCENCg0KUmV2aWV3ZWQtYnk6IFZpc2hhbCBWZXJtYSA8dmlzaGFsLmwudmVy
bWFAaW50ZWwuY29tPg0KDQo+IMKgCQlhbGlnbj0xMDczNzQxODI0DQo+IMKgCQlzaXplPSRhbGln
bg0KPiDCoAlmaQ0KDQo=
