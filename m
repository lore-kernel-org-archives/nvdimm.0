Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF181AA7BF
	for <nvdimm@lists.linux.dev>; Tue, 20 May 2025 20:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747774031; cv=fail; b=X9rlxOxCFdc0somdug9ifr2RoG/8g08byVODSGtb/2AjG36tW240o+QGqngw5eSjbkNAcPEUwqO+7h19pqn6oHd3sSct9MfDMEedr9O78BrmZUy9RwJgsxZivuMT8J9f31xrDFK3x6o+Vi7RJTmPUyOD/k1J/JBOLI30mPrXDDE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747774031; c=relaxed/simple;
	bh=vUQObNee5bb/KP3EjEONZraJ0d1n4O42NlR3LVIzkDk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XYAcMwT0ga0Y1SlbNGZsjxA7gj5pfPh0Sil97EWyFLhaNXWbzB23aenlMKsg4wSgDA8QShljOvRGQ9Vp+qDDxgmJtTP2UFUTM5fdmwXIoyXhNwhYOOfJm821RlmFqhSmSJG6RLjDZ0Ut4MiCK6ZRy+rxqjGO+8lSNvLAtIgcUJw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T/gwTgex; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T/gwTgex"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747774029; x=1779310029;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=vUQObNee5bb/KP3EjEONZraJ0d1n4O42NlR3LVIzkDk=;
  b=T/gwTgexNubWm6CRfewcGx69mkY645FqY13G+9ozLB12kFCbsZueRppP
   FnNQyvL4aQrRHGXQABQIph40UnfeXKmW+H1Jh7RjnKIpQjXAzwvd7Bgtp
   O2YgtK5mR6XMaWTbtf3W1PqkZ/+iAqQwkmLr7eN9Mfrp0dyqgyccWvyxh
   /+Zj1mi1y7J2+lFuSmQJ+Iq2BkrN5Vcc3PxTDPZdT7tQZMlm8K1GxyBCV
   K+An7RyTME5+cMo4/CVZIYoduFRoVe49yqjoc2wS2rQJtGNr+0s8Ju5+F
   BbLmtzHG59SQkFY+o25PvDRTWdPBf5OH3YMARpjZuBhkcp6UMlPjUhNx9
   g==;
X-CSE-ConnectionGUID: zPDtwwv8QgOaRszTq4vZxA==
X-CSE-MsgGUID: kQ7t4RI3Q52j7BqibEeFmw==
X-IronPort-AV: E=McAfee;i="6700,10204,11439"; a="60768335"
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="60768335"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 13:47:08 -0700
X-CSE-ConnectionGUID: 1cKIPMX5TQek/KnGoE1G6g==
X-CSE-MsgGUID: ZxZPU2I6TxGqq/+o7mPcHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="140736083"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 13:47:08 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 20 May 2025 13:47:07 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 20 May 2025 13:47:07 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 20 May 2025 13:47:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OkcxpUHgI3qu/8MHNPOkYVOP4Nl73PxBLuNecG8X+kux3l7N7wh4X2d1NT89pWp0KVA9IEy5D9YFrC2rQHqaWEX0OV16AYVZiGUiM0o4+nwFtAXJenLacigNDf1R8YrAEwgh2aKWWuHMKj7N7MZab+3djdexWZfgD3XMXn1Nr6UwfmPSpPCefnkCzdRmOgEJlg2MIf5R1TngNxc6IwGWtdw+gFF4t4haerhTcCO+WVFDYyZzVZ37dIeQpPRJCzM5bu++kjx7laKXeW4HMFwj3Wx8x+aqbIv4hhjOAJerX2YH2t9Rezabg5RY7D4s18/e7LEI66TNeAUPBvsyAmnT3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vUQObNee5bb/KP3EjEONZraJ0d1n4O42NlR3LVIzkDk=;
 b=x9m1eNltfkYLG8msAZs/v3crti+fODfBb7QOn+Ild/uwJsK/oPhG/N9LHRbTkIgk/OGHi49/lUPxPbZgJ6T4D3PSVziwR8wQJtK8aqBDsEXwohBcZuczi76DCmEV+bbQ+DqlRqzpv53P4Al0Xaj6mi4JSr61rRxt1YwH+vU6kZzDoaMLPvZRgi+P9QAPukJJ8dsUYXFfHuYxP9d9kZ6BbZNqs+6CrIKt9Ywjlzptt0IS0/xcXnQnhteB2wLnkuvpQloedVqHELfEFgw7ntullP6tyYWJw95htD+e2h09VsPEKsmNIMLMo5uWuC4J4Buj/41macwi2bSuhkSi6I+PRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by PH0PR11MB5095.namprd11.prod.outlook.com (2603:10b6:510:3b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.31; Tue, 20 May
 2025 20:47:00 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::eff6:f7ef:65cd:8684]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::eff6:f7ef:65cd:8684%4]) with mapi id 15.20.8746.030; Tue, 20 May 2025
 20:47:00 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "lizhijian@fujitsu.com" <lizhijian@fujitsu.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
CC: "Williams, Dan J" <dan.j.williams@intel.com>, "Jiang, Dave"
	<dave.jiang@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [PATCH 2/2] nvdimm/btt: Fix memleaks in btt_init()
Thread-Topic: [PATCH 2/2] nvdimm/btt: Fix memleaks in btt_init()
Thread-Index: AQHbxiFx2nazuY+vyEy5AgPdQwSlrrPcBGUA
Date: Tue, 20 May 2025 20:46:59 +0000
Message-ID: <278895599f74d38816b7960f70ffe6ba5357f299.camel@intel.com>
References: <20250516051318.509064-1-lizhijian@fujitsu.com>
	 <20250516051318.509064-2-lizhijian@fujitsu.com>
In-Reply-To: <20250516051318.509064-2-lizhijian@fujitsu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.3 (3.54.3-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|PH0PR11MB5095:EE_
x-ms-office365-filtering-correlation-id: c0c38372-1228-4bc0-6f83-08dd97df77cb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Q0Njb3A3OTAzVy9MUGY5emxCWFpiVnFOVkYrb3pmUVh4bVo5dlNrVWpSWlpR?=
 =?utf-8?B?ZG1UaTJoTm5WVnVZMjdUT3k4VHlyQ2s1WktONTlQcGl1L2ZuamlsWndTZlNL?=
 =?utf-8?B?MW1yMFNJemdVb0RxVUZqek9LcmxrSFNHQ0RGRzRmY0R0V0NYbmhOVmN0WjJJ?=
 =?utf-8?B?YlNyNVByY3hSdXlJRUVLUGI5OS9vWkE0YVR1T3kvekRoVEZTK1RlclVGRlNa?=
 =?utf-8?B?VjFzVG52RkJQY3lDdzJ4WXVkM3MzTGYwbW9RSm9DeisxK0l6RFo4TWRqcEto?=
 =?utf-8?B?OUpYUXBBd2JBL1l1eDBKL2F0aXBKRm5tdE15d05UNlZZU2kvdmJZMk4yMWUv?=
 =?utf-8?B?T0JRQUNZUUdYN3dSeElxZVdHcVF0QjlEeUdBME1Dc3BlLzVnU2V6RFRQc0tu?=
 =?utf-8?B?dkZiTGFhckxKQlpoQUQ1SHMvUGcrTHpVZGcrb3NnN1NCOFRrUW9hZzA4YlNQ?=
 =?utf-8?B?VStNdk5BOXZ1dXhpQzcyQXBERGY1RkxGOGwzQm1oRHN3MndYVUdNanlHUTA2?=
 =?utf-8?B?TkUzaVFSUHRWVU1BUElWcy9DbXRCcDVvNU0zR05DNkJEeFVDbUJURUwwNnJQ?=
 =?utf-8?B?TnRYZlJpVG05SVFhd2t3elIrbG1zbEt3YndrejBydFZSVjNlQ05ZVVRBRGE5?=
 =?utf-8?B?bVU0SnVQWnR1emRna0psL2FyenIvUjhqZjBJQnhNSUlaaVVUbzVNZ2V4NlNm?=
 =?utf-8?B?aUtjWFlJQzIrSXVWWkkrQ081WnFGaDNFUzVWWlo5QTBJR042ZFg5Z2lJcS9F?=
 =?utf-8?B?MXRKS2JRS2ZsMlJmVkRpaGVjbG41RHREQW9LelZ6NUZHNG1TWDB3MjZ4RTJr?=
 =?utf-8?B?NUhYMDk3cDdZdGM0emxIS1pWUk8wdnJ0cnFaeE5pWlNoUG5VVGRITFdrZUQx?=
 =?utf-8?B?K1NtUC9aYWFQZnpFTkZmZklhOWV3bEtVRWR4UEIyTTlVYU1aUTZDOTk3RHMw?=
 =?utf-8?B?WjlHL1dNOXVmbC9udUd5bzN4RDNhSWZoTytPY2ZMQWMrdlF6U1o3UUs0T0Rk?=
 =?utf-8?B?ZWVYUmNHZEsxTmVqaHhDaGE5YjRlZlZpYlFIWDRCYWJnQUxiWUQ2MENZSTU0?=
 =?utf-8?B?UWc5SUhwb0hhMlUzMG40OS9WS0RyWTR4c2RsdUFkbW5QUThRcERvQmF4dEpK?=
 =?utf-8?B?NDdwRHB2VzBzajNhdGQ4aDNIZFArMWhhVlBwUkZaODRoY2NOVUlQdndRVmpu?=
 =?utf-8?B?TTVESGROTXE4MUZDZC9FRWU4Mlh0VTJDV2kzckxtR01iTTc1dEt4NllPejNB?=
 =?utf-8?B?akk1NnBFcm95c0ZDajhZeGt4YkYvc0VaV0YvZ0huNkFkOFI1Z0YxUnd2WkdN?=
 =?utf-8?B?M3lBSzJsbmRaTGFkanBuRHVPVGxjTmhiNkNDM0lQSGFvWnF0OUYzbEpDaXg3?=
 =?utf-8?B?S1hIK2lhUGJhWDZTdVFCZ29vWGxrTGpqWjRpOG9oZWFOZHRKL0Ftc1h4M251?=
 =?utf-8?B?UEh6MTZlQmVWR09wdHgwdzE4Q3ZhdU1NMnJtdGFpeFRENGZLWWV2eGZpNC93?=
 =?utf-8?B?MW5CUlRvYy9hWUlaMWFKbE90VnBzU0tHV0pKSzZMeWF5VXd0d2IwWS9Ud1Vx?=
 =?utf-8?B?MFZESC9rMGZiY042OHo2WWFJeC9mcTFMT1IvK3QrR05CdDFJSGUyVm44QUQz?=
 =?utf-8?B?aFAwTDFkZjVPZGNqMVpyQlBHRHJrU2FkeWtabzZ3TzhBcldkRVpqdDArWW1X?=
 =?utf-8?B?RlFQWUExM1g5VkJjTTdhcmNndGZZUWx1MUFnOEdIZHBhRzhtWmQwWnpreklR?=
 =?utf-8?B?a0dZalA4c01ZUk5Ia3hlUmpGeU5qd1RlWFREOXdVSHlYWU1jcmhMaHZiZHZi?=
 =?utf-8?B?elhmb0FkQVV1cllKQ2VhRkY4di9hMGdnMVN5QjZyb0xBQW5vUFRlUTVIV2di?=
 =?utf-8?B?NjNlUnNhWVlLUCtocDZhcWlTMDlPbWFRWFRqN0hYWHNCdlVsVmo5MFA3alUz?=
 =?utf-8?B?L0lZZGVIUUp4Uk1qTThPQ2luU0JSTXY4ak15Yk1SekptNUxTczg3c3ZOTDZr?=
 =?utf-8?B?RW92bmJ5VmN3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OEJXL1VKa1ptNDVsMkJpa0dNbFJhN3BEY1hnNjh4WGV5aWw1S1VWM0NZRGhZ?=
 =?utf-8?B?TzZvYmF2U0UzMklScThpa1dtNy9oNThNZDFIajU5bndodC91YUprT2NBMzcx?=
 =?utf-8?B?YlBmVXNsazhmSWEwczNxSmoydnVnMTQ2Ty9od1ZSM0QzL3BpS2tDeGtHdWl4?=
 =?utf-8?B?dlR4dUpDelNNRm1iQXA5Z0ZuOVZlaStxaVBSeVpIRHU0WXVJeEUxWVIySWZ3?=
 =?utf-8?B?STRFSFZpeTR0YTRPWUs2MzMrZVdlaXpSOE15MkgwM09pbW8ydVVhVG9QaUhl?=
 =?utf-8?B?RjFkU3h5UHNsSjJEVUdpY0lpWE9DNGZnVVFXVHdZVlRUSGdpMVA4eDcyUXYw?=
 =?utf-8?B?RVBvZWNESlhVSWtMK0VjNzJBbFllTCtqM1NxNGFRaVZOeGlzMTlud3B2bkkr?=
 =?utf-8?B?N2MyYkFYa2lhUlVJNGYvTFFIQjhJMzRnY0NoNEVNMnZyZStqR1RSaWpCWWZD?=
 =?utf-8?B?VWZMalpIeFBJb3N4Mysra1VFRnVtZ0JmbFZYMDdXTVpRa2Q0ZzlHeVh4Q05o?=
 =?utf-8?B?a2FZbGVMcHorVk1BVDRBZzcybHh6cjZkRGVFTFo5dWsrWmpIRCtHVlJKR2U2?=
 =?utf-8?B?WUhvMjNIQjVCRWlEdFpzTWJKQ0NSMWFiTGlNR3FER1NYYVhmNFN1ZTByd0dE?=
 =?utf-8?B?aEU5NDQ4Y3E4bnluSXF3S3JGZ0xGNU5CM3BwWjFkVVpVZ2V3Tm9XcTJENlpk?=
 =?utf-8?B?Rkxuanhmb3Y3OVBTMmNSdkZ3KzFSemZBc3B1ZEhha1FYTitOMWZOZktOK3Jq?=
 =?utf-8?B?V3o3Mmh3VnlTb1VYcnoyalhRNmxoTE82YTlqMWhtQ21KV1BlK3pzYmR4QkFk?=
 =?utf-8?B?QlRpUHhLY2x5bE42YjZESWU0ZUJvWUxJY1VhakV0LzZjWGV2Y2RGcUgvUVN5?=
 =?utf-8?B?ZEVqaGhEcVlabUFHWnhxbUhEV1VWRlBKQzZ5UGNVMkZCYjM4RnZzcm5vMWZI?=
 =?utf-8?B?VVFWaXFkWDl4bVJVMVh6U0VrZGJDd3FDYUI1OXlEeG42K3lxRkt6VVN0Ykpt?=
 =?utf-8?B?VFJWQ2FlVmN0bDY1TFZ3V0dUYks3MWNHSm9naU12MGpYRTdjU1dpd0MvVFpj?=
 =?utf-8?B?RGlmcTlLZHFZRGxSaS9zeGtKWmtmSmt2VFAreVJKR1NtcDZKMFRST2FVS0Uv?=
 =?utf-8?B?SFRGUnJPcUFFTkNLdXcvWkNhNUhkbit2TjBuZFpONncyS0N3MTdvVXRsZ3Bt?=
 =?utf-8?B?RHBKUkQwNSszYkJQYllzWmtNU1dyaG1iSjdiSEVmM0RtNy9kZVQyK1dmRnlq?=
 =?utf-8?B?ejVib2htcFE1LzcvR3RScHlSN0tHd0t6emJxK0JSa1B3anFFTmdnWm0xQzBo?=
 =?utf-8?B?NW5wWVAwcW9IRUN2cExJT2JrZFdpSW9YOC9IRUR2Y3FCbWFRTEJRVTNuczZp?=
 =?utf-8?B?Wk1lcUNsSFo3NEhHWkQ2aUlHZ3VqNktnblE3MUNEbE9MeGI1Y21TZEdEU0V0?=
 =?utf-8?B?Q3lnSnYzajBxYVd3MzVJU1RRbHJrdVRCU093RSt3Zmc3K1o0ZWlXMURhUXNk?=
 =?utf-8?B?T1p6dXZiTGJFR1FtZEUvVmRNcFpvNHpsOXB1UlhVd1h6UXY1em4rd0VCN1hL?=
 =?utf-8?B?d2gvQWpJS2l5NmF6NGQ5TXp0TElNbXlJWUN5UjlBTituN1pQSVFlSjJuVjJa?=
 =?utf-8?B?SUxxWTRJeC9DL1R5dmNGUkhwSE9PWFkwak1RdzVsbm9WRXU4eVhhRDlQTW5U?=
 =?utf-8?B?aDNxMW14SHhSb1VHR3JxbE9VVHRQak40WUFvMEdIbnh4ZDB2ZG12Q29Odnp3?=
 =?utf-8?B?bFdaN3hmVWs1ajJoYjVvYVMwL1BGdUtQczhFdzlMRjJ0TUdOdVRNcHF4dDE3?=
 =?utf-8?B?eVYweGpsaS8xdkNvUHlWSFVNNlo0NWVCbGVJejBYTFlNaG05dkdNdUNEMnlt?=
 =?utf-8?B?ckhPTVJhTmFNaGpDNlVvQzQ1Q0hFU1pINHYweGNWLzh0NGluRjNKdHZodTli?=
 =?utf-8?B?SGlVd25teWh3clVYdEdVTEZhUHp1Y1RGc09Jb05TMG9LMHR6MEhOZXZaQUJn?=
 =?utf-8?B?a2pVeml5ZVNkOFdJclp5MjVhcVc0ck94NC9uanZESTM4QjVwR1Y5U3NFNUZD?=
 =?utf-8?B?b0RVT3BIWGRNeUZCUzFzWkR6eWxpZHZtcHY3TGMvSmRJc1BBalJoSk8yT2cw?=
 =?utf-8?B?YXcyVHFxNVJwV3JLRm4wQi9YM1lKcXE4NGtrNUlHMjFqQzZ6ZlV6WmJsWHpF?=
 =?utf-8?B?RlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <60F4F2C2F5013743A590193A224B3A84@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0c38372-1228-4bc0-6f83-08dd97df77cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2025 20:46:59.9642
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I6LQmUMW0ao2oNOnSpuWWgzdUOwy9YGM20Lp8Dz4j1fasgafZnz4N1rpgvr8EY+0hJ3t8hm0LlcX+NKgS5fil8ZGWI4nK8PAeD7d2QFWpck=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5095
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA1LTE2IGF0IDEzOjEzICswODAwLCBMaSBaaGlqaWFuIHdyb3RlOg0KPiBD
YWxsIGZyZWVfYXJlbmFzKCkgdG8gcmVsZWFzZSB0aGUgYXJlbmEgaW5zdGFuY2VzIGluIGJ0dC0+
YXJlbmFfbGlzdA0KPiBpbiB0aGUgZXJyb3IgcGF0aHMuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBM
aSBaaGlqaWFuIDxsaXpoaWppYW5AZnVqaXRzdS5jb20+DQo+IC0tLQ0KPiDCoGRyaXZlcnMvbnZk
aW1tL2J0dC5jIHwgMTIgKysrKysrKystLS0tDQo+IMKgMSBmaWxlIGNoYW5nZWQsIDggaW5zZXJ0
aW9ucygrKSwgNCBkZWxldGlvbnMoLSkNCj4gDQpSZXZpZXdlZC1ieTogVmlzaGFsIFZlcm1hIDx2
aXNoYWwubC52ZXJtYUBpbnRlbC5jb20+DQo=
