Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.21
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793744129;
	b=ZdslnEaykHMA+zvQfU0iFHxsLXow4zLbX5x2EgVlEsjrVo3xAYOhiqHU+xhh4Q45B9lX
	 S4ZS2rw78JXBsCuw6cnM46BMjK/awKwqoNx1Cpo8PNyed0qoL59l2dCKJd54TMTCPn1vG
	 hdkvchyjLkag6nDSiD3w3xslRWcMgHsXIjURQeGSXuP5WCJ1oJb52hSg2WJN97K7FjdV6
	 v3Bo0phLcpsCcGBH3gVKmE65v6zTDYkTfVtXBmbTt5B/ufVr70uYJ3ZOmETmgIzJez+Lg
	 tzhRqAheJKjrteJGuydMO8pkze7XNCimTmGxkAqeiEG1Bo9/0VTBl6vOQ00B2b6FVWQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793744129;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:Received:Received:From:To:CC:Subject:Thread-Topic:
	 Thread-Index:Date:Message-ID:References:In-Reply-To:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:user-agent:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:x-ms-exchange-senderadcheck:
	 x-ms-exchange-antispam-relay:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:Content-ID:
	 Content-Transfer-Encoding:MIME-Version:
	 X-Exchange-RoutingPolicyChecked:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=0mVfeuqYm7pUxwAwxB4+ghljKsxbZfrlqJs3kib3WTs=;
	b=IUFLS+S/3sYhPLGt72hTWmpABq9ld0E7BEX9JO9kTPEA1D82nYoJnwfeeJCUqVD/pHRF
	 ydx5Q/fOltMgbnTp2K7+ep8YzT20ORvIuedM2E3BOD20q1A6O+R4RSUNkdAcsUVZLeZK6
	 Rw/amw+dKPcpgQyUds+ES9LiZ16goY3cUGXYdpgaL7E43LT3ccar1CKQwVTtgm/nvU3Vh
	 4Tp1FsXsGROOHE24S7uemFfCZR2erN7qfLjL4pwOyc5sjlCGMErcrfSc2WWwtemNWVazn
	 cWb5Ic0jhdpCe2kSkc5/vDu2KxDT7vpu1SYOy0hQIXEp7Mfv4xCiUd2w37QXglIUVlg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=gCTjjjWZ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.21
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523CE606EE80
	for <nvdimm@lists.linux.dev>; Tue,  3 Nov 2026 22:15:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 523CE606EE80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=gCTjjjWZ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793744127; x=1825280127;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=0mVfeuqYm7pUxwAwxB4+ghljKsxbZfrlqJs3kib3WTs=;
  b=gCTjjjWZ7wn/4mzxXGR83Cib4KAvYSaW0xX8T4lDAbY+V/DvXNZfBVTR
   c6hxLsXgwDZxb0bYTEwaGeR+3dh6gU2fLptmsllsRbd4asoxN9fklQYym
   G7XgEFzsvL20b3Sjb888y5ITD3NTRNThg7tAmxcHxrC09rD5c0soWp+b6
   zpOlZfSG6nn9Hgr/0tqNeG/aFrqIlyaKi5/ZKYQ+vK4tQZR9xk14dN8ji
   NsBVQmjtv3JmEb3R+ko9EwYa+TgyVt0jyN8Rt1dMAxFg4QW4vNxGUskgZ
   jMoUnDhG6zkhv+Fmfi26lDwWKVXJT+SJGVaBFXXjbDt39pVyJN5TMmMfq
   g==;
X-CSE-ConnectionGUID: 9qzdXlZsTguB9s0pMSUnbg==
X-CSE-MsgGUID: VlE5Vb5PT4qTInbylfZMFA==
X-IronPort-AV: E=McAfee;i="6800,10657,11955"; a="2578502"
X-IronPort-AV: E=Sophos;i="6.27,194,1787036400"; 
   d="scan'208";a="2578502"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2026 14:15:27 -0800
X-CSE-ConnectionGUID: L+aREAhaR9yveEpccyLzyA==
X-CSE-MsgGUID: lhTicpb8TYCyWyFDtPSvsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,194,1787036400"; 
   d="scan'208";a="6679013"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2026 14:15:26 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 14:15:26 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Tue, 3 Nov 2026 14:15:26 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.38) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 14:15:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=olV2E1spZAW1lx73enZkDFPaCn2nopL3mYn3vjdbi62jHeBZolvK0LOB2up+L3e/S01nhFf8ovYjA09nhoaT+Y44OLmuVqRgnjWze2J4Lb5EYZVLY3DyHQ0fPdl/5IfZs1LYoFQPvIDM8VHWxOKeFUSaNPpOWRb7Sanwi9WSIXrI5/Z3eVL2R6UO5+XYcyRGm/OjacB6ajN3HDEYmmgpFXFGBQJICpVlpSB3x2bIVRODPw19RtooEDMGQuXHnDMth38cFKiPpdolrtP30LhAeduu4P6c2z9Gi3HR/o6UU0hC/Ae8HEoqru2EqEdBSBM0TJ7JPhOR28rBwvvrdn0ZMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0mVfeuqYm7pUxwAwxB4+ghljKsxbZfrlqJs3kib3WTs=;
 b=Lgiss+gChryp8Q4zY3QgZ8HPgsZwcMhChcLiPjpSv+avcBiag+ezWuXEer0yDPVDPjbeF6/CVo02/z5PAh5aKibW/FokDB1DKdVA0LhmNhniyqPLDIitCOYfcNq2eQind9n3x0qAgVA3twYSnIAOcnNXoH57jB4BfwUwXIWyY7xi9oEEvS0laWMmU9fHLYAnE3buvzVndZXvJMxUmfxYqTYpWJqMbOKBdCr9BCpNCcvlZRFbr9FacPpmFnaioBdJKRlEU2GqIDmxz1lqLMY9eAbvzp7VZUvDVK6oavjQ6xnihDPwTDV5c67oQHgMVUaun0lkElZ7Ms/wwcOSaLG/Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA2PR11MB5162.namprd11.prod.outlook.com (2603:10b6:806:114::22)
 by CO1PR11MB4865.namprd11.prod.outlook.com (2603:10b6:303:9c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 22:15:24 +0000
Received: from SA2PR11MB5162.namprd11.prod.outlook.com
 ([fe80::70e1:28f7:f440:ff0c]) by SA2PR11MB5162.namprd11.prod.outlook.com
 ([fe80::70e1:28f7:f440:ff0c%4]) with mapi id 15.21.0569.011; Tue, 3 Nov 2026
 22:15:23 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>, "Jiang, Dave"
	<dave.jiang@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>
CC: "Frank.Li@kernel.org" <Frank.Li@kernel.org>, "Schofield, Alison"
	<alison.schofield@intel.com>, "jack@suse.cz" <jack@suse.cz>,
	"willy@infradead.org" <willy@infradead.org>, "dave@stgolabs.net"
	<dave@stgolabs.net>, "jic23@kernel.org" <jic23@kernel.org>,
	"vkoul@kernel.org" <vkoul@kernel.org>
Subject: Re: [PATCH] MAINTAINERS: Update CXL, NVDIMM, DAX, and others for djbw
Thread-Topic: [PATCH] MAINTAINERS: Update CXL, NVDIMM, DAX, and others for
 djbw
Thread-Index: AQHda9AvEKbBQwyp/Uua0MYYRIiC17cc6gIA
Date: Tue, 3 Nov 2026 22:15:23 +0000
Message-ID: <792d73511088b913581405420bd3f774dbd04b47.camel@intel.com>
References: <20261103201547.4079847-1-dave.jiang@intel.com>
In-Reply-To: <20261103201547.4079847-1-dave.jiang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.60.2 (3.60.2-2.fc44) 
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR11MB5162:EE_|CO1PR11MB4865:EE_
x-ms-office365-filtering-correlation-id: 0278d9b4-ee87-462a-6bc6-08df39f7f4e3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|7416014|18002099003|22082099003|21046099003|10067099003|38070700021|56012099006|11063799006|261022105027099003|261028144727099003|261026140227099003;
x-microsoft-antispam-message-info: MIVT5LP96fczJ7fxgKzHOWun5MfbZ0zPKmuHNBn8aXXXASdPTxFoVnvaa7BlS+CSDoNTpH/cHiYgY0F0WeunJHSjXdYb0mf3ma00XY6keEU9xY8HZwrTSvEHxa+njV5N1cTuyYsh2buhs5jYYE5H5Kzv3Q6ynWRUmgRM/YoYm7C6QM9ZJnin2RsOUh6G6SeT3VlQleOcEG39xc6IuSPKooBLSEGBLwt8qbAtX8NS0yh8pvXx7fVbJRM0UpSmX6HUFNwf5uu/AAFn65V5qBRuC/Hb/urtixvSc9Tcc6yKMzGxEnB/1BJTwV971RrUQCoIZ1aWP0SWwc4k7cXKBgcr9cOYyxHOVnY9jdyGisrmk8FFAFDDDzNWB9oiNCb1Phy9J8vv1a0QeLi7giTYoHWB1Hgrp8DRDm0uY4208sB1EF1IENWoiD+0bBc3HZEyOaw7LLMd7aaego+sZIwHyuNZaRYr8qr2zZbC9R3D9NHZ5sHwI9rx43lEZsaufPgKIAUdb0rke8JpCfu1PTtx2ZltgZstGCtxVopuiqyTYnBPvy3Qm1OBt0y8NQxLbGigWFpxEO9Nxj3DW9SBhgG5nGRit9XEVUtGy+0Ez9qfeS+5bIrc6shhFJqMdkDWFDqm/1sjfKx40A3ybCAc0EsEpNVOL8+zhP1kZIqQDYa4Aj+pS6L4PSdmJluraxFC8PLb8SG6tTSA6xnyv4D8B+KPk4ImaPjRWdFwhta92jMEcp1bF2Q=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB5162.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(7416014)(18002099003)(22082099003)(21046099003)(10067099003)(38070700021)(56012099006)(11063799006)(261022105027099003)(261028144727099003)(261026140227099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M2xKWmIrdFQ2cWdSdzZVb1JFOGRubjZyc2cxc3JwdFIvelQ2SFVDNEJJbURn?=
 =?utf-8?B?QVBQWm4zTENZWUVHaUFqaEIzNGxTVjczUCt6aUdURW9meDNSQmhwSTRibGdY?=
 =?utf-8?B?L0x4VVdVVHVXRFZwNm9SL09mUndmRW83clNPeHNlTGswMTJMZGtCRE5HQXRh?=
 =?utf-8?B?c3ZHTG91Y2F1K2ZqQUFpRVoxdXUxcm0xR0JDbDV2UXAyZFNaOHh4SkJJQ2g1?=
 =?utf-8?B?Yml2OUk2SGpSclpEbHpwcFh0eWdwUjdpbDAwSVZwTjdQUjY3cHh4STVPVldw?=
 =?utf-8?B?cndLWXNqSHUyKzcvOUdZNTJER2l3UUc1UVhqMmxNMFEvSmlRMVVGc0xEYmRo?=
 =?utf-8?B?WVBZQ3dqdXQxb004VFZsMGE3RnpEb05MSGsrMTl4UUp5MWhucU1FQk44cmVI?=
 =?utf-8?B?TmxoTlV3ZHlHODJkdy8xRWNJSklrSjFmNGM3elZnUHBrc2ZZUWZwbzAvNXox?=
 =?utf-8?B?UjBhRzV3aGhER2hyRk5DY0Z1VHhIQ1h5cy90VkxWWGpIL1pOMUZ5UEdlZWEx?=
 =?utf-8?B?aHhxT2dtbTd1OVd6QmdoaVJ0cDl4T2x2VjlqczUvVlZvdTRxRWh6T1U5NWRD?=
 =?utf-8?B?TFZ0YTVIcW1ibmd0SjNiQjAyalJBNHdUUzhvK2pWQVFXZ0ZBN1ZyUzlOTFJz?=
 =?utf-8?B?OXdqenM1Z0RkWGpEVHYzVFNKMk1ESTRTUGkzNTZ4OHo2WHFWMkhhbUloN2tJ?=
 =?utf-8?B?QkZzKzlmZXI3dGJkSk93bnNKNWdTT3hZQi9idW1yT2RITnhkb0pVRjA1UFlK?=
 =?utf-8?B?aTRYUEFkYlJaMkpGZU9hUHo3THpJdzNtaU9RdEdIWlhpQkk5b1B6M3BTbE13?=
 =?utf-8?B?cTAreEdvUlFWUXN5a0ZGTlNxR29UWmtMM25UbElOWVgwS21wSkovTXgrNWVR?=
 =?utf-8?B?MzFpV0JvZStVT2xLLzNNQjNxbm5PT1I3VUJ5SWdQSml1OGZ3aXBZeDJBb2dW?=
 =?utf-8?B?VGthL1NLSnVJRlVZS0Q2Y3RBbnlqZ3N2WWlZTXRCVGFna1pRNEdZb2MrcUlJ?=
 =?utf-8?B?aDlGb3hRRmtzZWJjME5BdnVCRHB5Ri9HOXJJTEsxQzl3djFac3ZBV291OXJy?=
 =?utf-8?B?a2NiOUVDMWFHT08wbXBsNXRkYmpma3gydFlITnNmUVJUNWZCd0k4VDRJaDhy?=
 =?utf-8?B?SyswT0Y0Q2xkTHJiQlJ2bUQ2SmxvK0FueUEwa0VtZXNLNVRBbkNGTWdhNk9J?=
 =?utf-8?B?YkRkUXFEYXI4VENZbk5NeDFCaUNrOTV0R0pwMUlPam9GRXRUbEI0VVdpK3Jm?=
 =?utf-8?B?NlpEUkc5QmhJcWlTY2o5aklSOHkvV1BwSURsRG5USHhURnk1K3kvaGVsK0tU?=
 =?utf-8?B?c0orUHlSYm84alN2dDR1MUttcDBVSG9kT1hmZjFBN2dvejV2TFV3U3lwd0RC?=
 =?utf-8?B?RW9KNXB0ajR1Z1NtMklPWCtpNGJ2aWFyZTNRd2txNzV6c1UxcVp6Ry85VG9Q?=
 =?utf-8?B?NytIZFNDa3lCblNON2dDNXJRR1ZMWU9kNW5SMlh0N0k3RnplVS9zSHluTlov?=
 =?utf-8?B?OEpIZzlFL2lqeXUxUSt6RkZsNUJ3bkJWMzRGbDVoWnMwakNub1lUcmRHRURC?=
 =?utf-8?B?Qm9pVzl1d3FyUDdwd2prZ25JZlFTdnYvMm5VMWtvRnEwbUx5YVpxRTlJSjJC?=
 =?utf-8?B?bUNLRWlKenR6Q0ZJa3NGV3JnQko4SU43S3pZVjAvNzByd2JhSmJLWGUrNXZF?=
 =?utf-8?B?Yy9jSU9Zbit6c2NCNHJsb09PcXUxMG4vM0N2NGJQNXFLQUlnL0U4cjREUFN6?=
 =?utf-8?B?ZWQ5ZkpMbWpINXMrZG5PZ09jSkFEV3JqTFpDRHBXMi9sUFkxa09mYVRkVyti?=
 =?utf-8?B?alZnSTA0cDEyNFJGSzRBY3ZKVDZ5NHhkb0gzS0k0Z1ppVzhIMFVLeTliaHBL?=
 =?utf-8?B?MHVFdHNuMkwxV2VYSG1qdDVYdjVPRHRTY25sSmNJMytxb01mcjlpY2hKeUYz?=
 =?utf-8?B?L2U4czQwVEx0MzNRSW96cHo0RkM0ekdqRldvMUtZcE9lWnRnOTFvWUp0WjFl?=
 =?utf-8?B?N3FyaXBRbkdaUUR4VlBlNG01b3dzbm9yOTBrTUEyLzdBWUQxVGVQbjdVNWdk?=
 =?utf-8?B?alA2T2Z0a1BOSUNnTnFiVnZlZlNOamM2aDhvVFVyZDI0dXhiaVk5OU43VHBn?=
 =?utf-8?B?WHI3U1NRUVduOVJBbVBic2NDWm9QdXRJVTN2V0lac0p5L3NvdTVFbVVienFu?=
 =?utf-8?B?RmxMWVVlUGxQcTlIRDBESWVzbjUxZmZGSnNJeHUzWmx1VnFJUitMQzJJR3Rn?=
 =?utf-8?B?eHNUM1docnFidEh2MURaR3RyV3RIcXdjZG13Z3VZMW5QU1dGMkRjM09VTlFw?=
 =?utf-8?B?SUlxbmFwQnBKTUFadWNmY2UwQ2tKajJNNUVlNTRGTjdwNzVtMEhEUS9DWGNG?=
 =?utf-8?Q?QnPyOjCpUMKFv3zY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F2F72935B0E36A4DA27E4BA0A65D69C6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: JJWUhAi6aA/RErz/04+nJ8rHcIutISOYDj+VmDjq+POjfCMDchsQc6oLae9O4y1E8ZCx1ZPqwuUy8FSuxYl1fIvfKa2kqyfJ/8/d2geF+yawYSZCjz1lAQtVPLvOgwJir0e0hLX9eMicERSbIm6Swvt986Oq64e1UkBv6GeH4Oy+iW/J71pSTZAqodt5ckYTrxnyx/kWkvDDpwGPBt5jGWhY/OVfnlNK0JlF5bP00spvY1rD2Kc6yVp2/9Uh1PyJnMRJdPKDCp4wHEtI2/2G35ROycjExtGgo0lnZBJ1NasELHE+y9SrH7Seuzi18K9jL6UiX5IbVljZZzB/PVB7Yw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB5162.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0278d9b4-ee87-462a-6bc6-08df39f7f4e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2026 22:15:23.8113
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rgw6tIDJe10JrdbTE6+Iew8vKoQDPnfQ8xeKdd03McMrkfNFH75tv7ABfWGFA55p5PBVmJ0d+Z6Doo86BOoXS6bPuISjvlnUvfLBJWjYSDY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4865
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI2LTExLTAzIGF0IDEzOjE1IC0wNzAwLCBEYXZlIEppYW5nIHdyb3RlOg0KPiBE
YW4gaXMgbm8gbG9uZ2VyIHdpdGggdXMuIFJlbW92aW5nIGVudHJpZXMgaW4gTUFJTlRBSU5FUlMg
dG8gcHJldmVudA0KPiBwZW9wbGUgZnJvbSBrZWVwIGVtYWlsaW5nIGhpcyBhZGRyZXNzLg0KPiAN
Cj4gYXN5bmNfdHggd2lsbCBiZSBlc3NlbnRpYWxseSBvcnBoYW5lZC4gVGhlcmUgaGFzIGJlZW4g
ZGlzY3Vzc2lvbiBvZg0KPiBkZXByZWNhdGlvbiBmb3IgdGhlIGZlYXR1cmUgb24gdGhlIGRtYWVu
Z2luZSBtYWlsaW5nIGxpc3QuDQo+IA0KPiBmc2RheCB3aWxsIG5vIGxvbmdlciBoYXZlIGEgbWFp
bnRhaW5lci4gQnV0IHRoZXJlIGFyZSByZXZpZXdlcnMgc3RpbGwNCj4gYW5kIEFsaXNvbiBTY2hv
ZmllbGQgd2lsbCBjb250aW51ZSB0byB3cmFuZ2xlIHBhdGNoZXMgZm9yIERBWA0KPiBvdmVyYWxs
Lg0KPiANCj4gQ2M6IEFsaXNvbiBTY2hvZmllbGQgPGFsaXNvbi5zY2hvZmllbGRAaW50ZWwuY29t
Pg0KPiBDYzogVmlzaGFsIFZlcm1hIDx2aXNoYWwubC52ZXJtYUBpbnRlbC5jb20+DQo+IENjOiBN
YXR0aGV3IFdpbGNveCA8d2lsbHlAaW5mcmFkZWFkLm9yZz4NCj4gQ2M6IEphbiBLYXJhIDxqYWNr
QHN1c2UuY3o+DQo+IENjOiBEYXZpZGxvaHIgQnVlc28gPGRhdmVAc3Rnb2xhYnMubmV0Pg0KPiBD
YzogSm9uYXRoYW4gQ2FtZXJvbiA8amljMjNAa2VybmVsLm9yZz4NCj4gQ2M6IFZpbm9kIEtvdWwg
PHZrb3VsQGtlcm5lbC5vcmc+DQo+IENjOiBGcmFuayBMaSA8RnJhbmsuTGlAa2VybmVsLm9yZz4N
Cj4gU2lnbmVkLW9mZi1ieTogRGF2ZSBKaWFuZyA8ZGF2ZS5qaWFuZ0BpbnRlbC5jb20+DQo+IA0K
DQpBY2tlZC1ieTogVmlzaGFsIFZlcm1hIDx2aXNoYWwubC52ZXJtYUBpbnRlbC5jb20+DQo=
