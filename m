Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3C913AEF
	for <nvdimm@lists.linux.dev>; Wed,  5 Jul 2023 21:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688592142; x=1720128142;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Zq/Yy6PJ6RqFw/Fu28R8zxfQDaaho/7j3VF6fONWjPM=;
  b=eqHJiKZipEjvlLDfO4dYrDYT/Na5sTq1VRH4wnwh1GMP69wAs+aGAftF
   LsVn9qaxqiHlLv9TB4rcP8t0ncJZxr4hscMMjn5Yj0vqNvXCgp0LfPigE
   Cx5VE5LC7jUklsjYaiJP9zGVqoGsFD8Wz6wA4XoIXJ8BiYcjbAc8FGk9x
   7lBZUEoFQGMBGslEgHVe7UguLSDzts52MYJrUUVHFpXCA1P4wYeyaIcUs
   sp2NKBfu8q0Mce3LGxgSXAtW1pZMLTBqT1rz4fOvE1lTXsOzMgbQfDtD+
   PH4rZ/DYVWkMHuoaCWWiCH3wwC/eDi78a6YgdZ+AJBySib+MOllWWXBIT
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10762"; a="362314018"
X-IronPort-AV: E=Sophos;i="6.01,184,1684825200"; 
   d="scan'208";a="362314018"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2023 14:21:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10762"; a="713325200"
X-IronPort-AV: E=Sophos;i="6.01,184,1684825200"; 
   d="scan'208";a="713325200"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP; 05 Jul 2023 14:21:58 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 5 Jul 2023 14:21:57 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 5 Jul 2023 14:21:56 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 5 Jul 2023 14:21:56 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.44) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 5 Jul 2023 14:21:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gNe4eKsTv8xgja3jiKOLpXgd7tbioUmOA3i9kLAy8CO7/i+hp7UtQht9+kbcx8TDP4yLVdXlKg0wSj+yGjN78iiNSd3BRnfw9ldoVNDJscv3+ptfU+Rfsc2lVHt9VPja9cW7PQMyvS0+0e6zVngppnbv+DBNhsgdENLaemrRv8HQtcB7eI16z3UgpYGhxht5YOfB6Hyxu6owff8WSMTWGpdLUKkGdEVTGRYAgqmLbS4E6HOymExOY3zzM7pf5yGR5buYJT4JwOCsEnkKwjVKo98ddU/zerRFBXWlxAIuKtXYX2733LOmUkhg/DsjzZtdFdYLXteIhVHP/dU//id8SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zq/Yy6PJ6RqFw/Fu28R8zxfQDaaho/7j3VF6fONWjPM=;
 b=K1d15ZQi/B5UfLLFw7DOWwDfF8jscu6GsaTOjK/jaXlJvbUMYQc3XDipQufJARPKe6+1Iwn4kz18CKiIlj/qO6MapRKoYTdxZE6kQEacb2GWRaAP2LTcJvyu9/h4gKeHSxg76eyafyn/7ZK54SV25TEIYqeyOGQ6m/2o24YjBhctdFC+21FoOK2DU+/he2iMDl7+gwLjbpN3CHErmXPj+AdlARM0Jr3Uq9Kim6mg0pjN7aGC++u0KF5AHi9me9TJX+ij2TSfect2V2CknTcut9e9pIjHjLTk7055iGvJ8f1JdJjYCSy9ko+TMfkI9ScQFign///z3mLs1YxErVbKnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by DM4PR11MB7183.namprd11.prod.outlook.com (2603:10b6:8:111::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.17; Wed, 5 Jul
 2023 21:21:49 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::8e37:caf2:1d81:631d]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::8e37:caf2:1d81:631d%3]) with mapi id 15.20.6544.024; Wed, 5 Jul 2023
 21:21:49 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "lizhijian@fujitsu.com" <lizhijian@fujitsu.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
CC: "Jiang, Dave" <dave.jiang@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "Schofield, Alison" <alison.schofield@intel.com>
Subject: Re: [ndctl PATCH v3 0/6] cxl/monitor and ndctl/monitor fixes
Thread-Topic: [ndctl PATCH v3 0/6] cxl/monitor and ndctl/monitor fixes
Thread-Index: AQHZk2ZnuSJ28sf4gECMqTluV5fv9q+emlAAgA1MTQA=
Date: Wed, 5 Jul 2023 21:21:49 +0000
Message-ID: <9a0b014dc891dcf0496dde1f41d32fb0893f586e.camel@intel.com>
References: <20230531021936.7366-1-lizhijian@fujitsu.com>
	 <f83e918e-ae85-cbfd-dd3a-0ef3f1519cd7@fujitsu.com>
In-Reply-To: <f83e918e-ae85-cbfd-dd3a-0ef3f1519cd7@fujitsu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|DM4PR11MB7183:EE_
x-ms-office365-filtering-correlation-id: f7ec6474-516b-4cc1-14e7-08db7d9dd864
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aVL+wyAPiY9OtLyKHeuY5I/WNPyNy7dlWtQ0ELZRXqyDLxuKdsQmEJ9kPi+ON5RAZrziFHYz8Rz2btsyGVPze+KhBQ7Fb0DHo6egqyfSDCzcVjGxSlLFrWBqAUkqdVDgjm0mtAIMzZeV+kyMLGcUU7hJStnYI0UwRy+hERUKXaIy3mBt2cfWnGP5gOpP1JggPTqocC/FcyL+QhtLPZEO2418+tyZygvYH2a/HVIFbiclv5+VJZdyX/nL9pdruy+YTurI1xTlzGxrLCAmiAMviVPRrvHO2QlZ84BU5B8+EF+qLiy1E7VAYTpwhOOTfUXk9r8BFdt9KZD3zGqLk/XmGgFOliRAY/sWlrsFQe69W7dDOSIT3L/tthHOpcZFfDZIRVMdn0/3MhEnnzmrt8H+NWkXBxp+BIuqAmHOTFH4cbgbi6zeF5vDKGw+uQuSRy27arTq2/9O1I8QgobD4EmIqil439VGB7saHYWxOghVoVwTk2hIWimXb4TtCMC45McdT91+cARBZJF85HcUNoqz20Ue/IUELkp76NqJYTIgTF8ULDVYBuDZhXE6iXnT4inNpwRujNRdKFMju/tNGNwsgswqaIAjmm87HrU24LimS4kNHt/sUiuzTA6re9r3XSIe
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(366004)(376002)(346002)(136003)(451199021)(76116006)(71200400001)(6486002)(478600001)(110136005)(54906003)(2616005)(36756003)(86362001)(38070700005)(2906002)(4744005)(186003)(26005)(107886003)(6506007)(6512007)(82960400001)(38100700002)(122000001)(41300700001)(66476007)(316002)(64756008)(4326008)(66556008)(66946007)(8936002)(8676002)(5660300002)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MHBzL3pFbVVPZllwbkJvZmM4TXlUOVlXbEdMa0paUXlrVGJpY3B3eUFkY3NG?=
 =?utf-8?B?TUZwcUhocTVkeEpFVmVDN0R5VVVkUGRwRlVpbXA4SUZITm5xY1l2MG5jR1Zj?=
 =?utf-8?B?eFVsZ3ZsSUN4R1pwU1Nwb3Zwek9ON28zQjhucGlQSkJaMk02bU1oa0dvb1da?=
 =?utf-8?B?MzBTK1lsejRiOTlQUndBUjdkU0E0ZVZkSXdCVi8zN3hLM0JGS3RxMlFHNXJZ?=
 =?utf-8?B?VDR4dXpFUUJ4RUVhQXFJT1hrNm5iZmNxU0pDM1F5SVhEdkRBUU90QUhkcld5?=
 =?utf-8?B?ZjM1ZlYveEE5enEvMkZnbUxBdG4wWDZYRjlwbkNScjZrSlJaVnFubUxMaUxC?=
 =?utf-8?B?dHFmRUN3Sk8vU3lpTkt2MXMvSCtqRlFPWEZReWJQN05pYjRBRGQvclBXU3pS?=
 =?utf-8?B?UE5uaktSMzZ6eEx0c0I3MW9wblFpNHBXWHJYbWhpVGdVaEZyYzgrQ2NJMjRa?=
 =?utf-8?B?Q0dtNnhYMllxT0s4eGhkSno3eVAydTBjSTlCdC9QWUJIVzJCV3ltVnlXNmZN?=
 =?utf-8?B?TDU4amNaRStZaFhmMDhhU1BJVm5aZjRXZWJtWnlUWXNkbTJubnBOdncweDVL?=
 =?utf-8?B?bXVNVFExbWxKSGxvZDFnRWg4OGdrOXVIdkQ2dUI5RXN6V0VzVXdLTVNWK3Bx?=
 =?utf-8?B?TmdzQm5NRnhJNTBSS20vOWxhZTlKZllmT25UU1hmV1VZSEkyaWJxc2xDdVdH?=
 =?utf-8?B?Y1Y2WUtUTHh2Y2haYjhVSS9zSG5taUpNYnRFaUFNNHBOV0RpOXpDTzVoSDFa?=
 =?utf-8?B?RmtGeTh3cFBvZVl5VzRLamRRTzYzaHpKL0p2bVBaeDd5cVJmOVpKaXFwcDVN?=
 =?utf-8?B?Lyt3Ynl1NjFQcE1sMlAyUEpMOGxyR0ZOSWZRTU5nc00xZ0JvWnJpOUVtV1ZV?=
 =?utf-8?B?MVNHemZMT09WRlR5bkRVRzRIc1BrK2JVd1RWK29ybVk3ZHpLVDNHdWFJS3lw?=
 =?utf-8?B?TmVSZllEQ0U3NWFTaFBXZ2N5ZHdlRFVyTlA0dEU0SlJFc1pIVTFqYi9wQkJV?=
 =?utf-8?B?UjNWVCtUTDVPQUhZOFpaSzU3SUJWM0pURGNyYlhDbkdFNnRxQVdSdFVPQ1ZZ?=
 =?utf-8?B?TWIyT3FlS0hOU0s5dll5aHIyK3lydUJIRXRxNzV3ZWo5QTlZWVorN21WTzJk?=
 =?utf-8?B?SXFGTlNDYUJFUFd1TGJPYk1GSXhDU3pGMXJSbUd0SlQwL0s5ODd5YURWQXBn?=
 =?utf-8?B?LzRTcmlBOXJsRVhpR3k5eXhlWUUybkd3Y0VZejRqciszRHRqbTR6aVB6QURB?=
 =?utf-8?B?SVREbXE2NWtuMExuZHE2bHBrTVJhbUxMVTJJSWxDeEJuR0tESzlkZ1JKMCtm?=
 =?utf-8?B?M3VPSDlEUWVNaitUNEZGenRsYy9EVGNYeEZGOFNvTHZtOHVsVk1pcUYyMHlG?=
 =?utf-8?B?eHF1RGphUHBNRzREemx6SldOWStNaXlxWkNYZnZUK1hTT0ZhemNaMXRiR2ZR?=
 =?utf-8?B?OTF3QTFKZGtZUHdCT0xRMFk3SHgzendiRlc2d0pUTDhwcjRuZHRVQkhNOW15?=
 =?utf-8?B?bEhGeE1iWkVwc09KM29SYVYzdGErZ0V2djNvaTFMcGo2QXYrK1RielVNQUww?=
 =?utf-8?B?R2FNSHAzNTlUY1JzRElVaW02amlVZkI1RzBydmFycDBwVVd1bGRlaGM1YW41?=
 =?utf-8?B?S2tYeWswV0kydGR6ZzBSSmVNSnBEbHRxK29ZaW9PY1orcFlkeXl0V0kwaHpN?=
 =?utf-8?B?K25hWEJORmkxaVVjRTZMRk9HOWNNZHZMZnJiRHIyZ1ZuKzVoK3d4aXBLSm5q?=
 =?utf-8?B?b1RCNzRIUkdhYU1KUm93OE02N0tTN0hzSFhGcERRS09GMlcrSFNhNlhIN3Bn?=
 =?utf-8?B?Ui84Vnl1L0s3SmQ1bWZpRlA0cFZQRllXMDdoYytVN0U2S1ViTnJvUXUrZkdK?=
 =?utf-8?B?N2pKRE5sa0U3L3BYbDE5K2c5V0VOVy90ZWtkZVpQR3EvcWxmcmVaL3dwWFJJ?=
 =?utf-8?B?SVZia0dqV2sxTENvRUNBQWpXNlE1SXNZMXlmajY3cDZxZndsbzJIR1BmVU5B?=
 =?utf-8?B?U1lmUHBqWmdxeERXY1R3SGt3eSt1cjFramlMMWhWWlVTenRRbHhVa2tDaS9r?=
 =?utf-8?B?aTRLMHMvQ3FKSHJxUzRCWTFzRlNPTTkybG90U00yOGJUbnRqTVZBMWZ0ODRL?=
 =?utf-8?B?cmF5V0R2eG5ZaXEraVhsNTduNkp6RTJQZnRzVjFLREpYanpncGdiL0kyclFR?=
 =?utf-8?B?bGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <00585CCBF6517F4B84AC6AF80B148534@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7ec6474-516b-4cc1-14e7-08db7d9dd864
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2023 21:21:49.6800
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h+2lt1rfdb+D2k3ni+IAfgE3AFAQpNR22aUgApo/ip2xhRhX64r002fDPkfdhGgTuvH5ctj6E2rswkoRgY0s5mpdHzAdYq9aqktnZdwghaA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7183
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDIzLTA2LTI3IGF0IDEwOjE3ICswMDAwLCBaaGlqaWFuIExpIChGdWppdHN1KSB3
cm90ZToNCj4ga2luZGx5IHBpbmcNCj4gDQo+IEl0IGhhcyBiZWVuIGFsbW9zdCBhIG1vbnRoLCBh
bmQgaXQncyBkb2luZyBzb21lIGJ1Z2ZpeC4gVGhlIHByb2dyZXNzDQo+IGlzIGEgbGl0dGxlIGJp
dCBzbG93IGFueXdheSA6KQ0KPiANCkhpIExpLA0KDQpTb3JyeSBmb3IgdGhlIGRlbGF5IC0gdGhl
IHBhdGNoZXMgYXJlIG1vc3RseSBmaW5lIHdpdGggdGhlIGV4Y2VwdGlvbiBvZg0KYSBmZXcgdGhp
bmdzIEkgcG9pbnRlZCBvdXQuIE9uY2UgdGhvc2UgYXJlIGZpeGVkIEknbGwgcGljayB0aGVzZSB1
cCBmb3INCnRoZSBuZXh0IHJlbGVhc2UuDQo=
