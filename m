Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B06D72F5C
	for <nvdimm@lists.linux.dev>; Tue, 22 Feb 2022 18:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645555734; x=1677091734;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=0XzsOVdwfeLjYG4j7pH07FxajZss4Za3OxxFfKMu8XQ=;
  b=Ivuu26dTKR1tag23SZqNL/RU/elCspAPqF6hYRE/YYnt/ZNLqeV68vBG
   WzJlzlAInQNPWTDm7AJ6DTBHkfWGKQ8VUvyin5eM5v5flTy3i7B3DuUed
   6M7GqSSonc/TuffnzVwfwi4qHXWMMhDBmQ5Z7nF3HTZspDnGjeoqB+yJp
   RaxAtj4Wam2rqRvNaq+peCZ6A+utyQ3a3DNkskveo84fX0LT1NqTw+S4k
   gE1xSTZfKByCR7Tz2N5NbyjSKwCo2I6teJLSdyO1n0rLoavyAlpBcgKF7
   Z1Hh8xRVabgvTXbfeI2+eugKt97Ltmiu36Pis3EzaGDhrrRz2lrUwX8jt
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10266"; a="312496863"
X-IronPort-AV: E=Sophos;i="5.88,387,1635231600"; 
   d="scan'208";a="312496863"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 10:48:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,387,1635231600"; 
   d="scan'208";a="508103528"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga006.jf.intel.com with ESMTP; 22 Feb 2022 10:48:54 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 22 Feb 2022 10:48:54 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 22 Feb 2022 10:48:53 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 22 Feb 2022 10:48:53 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 22 Feb 2022 10:48:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aBaHBOB94qaitGY4s3+G/h6mUzr+qYKufcUR5EtztaG6QyxKmtJ0oTYhT7/en9A8dtY0x//aH5rW+TTPRCHUlpLCGiFoerUfJY9ciEFTKYGBzT3BybrcaElYKf/7JnDg/330S4iYTWOSOexPH56u3mOeoiY9v1xOr4MkF+r7xXAmru/Hk03W44MG/uHvJgZyV4CX+u33vr9w7ZiakYO6qh179sH94uc4uIC/eNRD7ThL2WV7v/Xj3YQ2Z9LZ9ViqvOyf1ODjzBTQ1MlgtWwdnkpVCVsvTF+3RuVzOrq1dqgbEj0/GU6OaKRftQg5iFendbfzoL7oNdMFbW8B/k121w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0XzsOVdwfeLjYG4j7pH07FxajZss4Za3OxxFfKMu8XQ=;
 b=V5/+bnGT1/a1GL2MHSyQZr7PgSbV+M2jtVJepUYiLAcTiWKJfyLe/xVzJRqJ9/ee4n5saODI96BoYy5y2d+MxsIGOd8z9fX6xkpr+4iSV1UVuzAJYykWBIPyu11SQNMKt2HZXaxMEeCA2MrfNOaD4y4evDpVlLZmIzdV9hzLzszzJiMKqB608xj3h6rqN28YQNMnSjseuaVNT7yS4i5DeTCqIA0vaaSXtcrR18G36Cdws1hM47M9059UdBjsRFtDMzwRv6CyTn1uNLQFDHQRfELb8iyEvFfleYSUYuCCEYZYeugPp5caBlPPJd9VTZsna987+AxbcMRE/18R9bLnrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by CY4PR11MB1813.namprd11.prod.outlook.com (2603:10b6:903:127::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.17; Tue, 22 Feb
 2022 18:48:50 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::d02d:976f:9b4b:4058]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::d02d:976f:9b4b:4058%7]) with mapi id 15.20.4995.027; Tue, 22 Feb 2022
 18:48:50 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>, "Schofield, Alison"
	<alison.schofield@intel.com>, "Widawsky, Ben" <ben.widawsky@intel.com>,
	"Weiny, Ira" <ira.weiny@intel.com>
CC: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH] cxl/list: Handle GET_PARTITION_INFO command as
 optional
Thread-Topic: [ndctl PATCH] cxl/list: Handle GET_PARTITION_INFO command as
 optional
Thread-Index: AQHYKBjakVBcDXCdOUWkYg0ZpxWSLqyf6XaA
Date: Tue, 22 Feb 2022 18:48:50 +0000
Message-ID: <1e4be0ba70b9840348aa0eecea1c2307343ea33b.camel@intel.com>
References: <20220222182328.1009333-1-alison.schofield@intel.com>
In-Reply-To: <20220222182328.1009333-1-alison.schofield@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.42.3 (3.42.3-1.fc35) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: beedafe8-c7c6-468a-1afb-08d9f633f777
x-ms-traffictypediagnostic: CY4PR11MB1813:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <CY4PR11MB1813E893ADDF7C14E2B0A987C73B9@CY4PR11MB1813.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V6eWz3EC/zzL2oljoVfXKMKqalJlh242iKKp+ICHiQuK7euIzBqr9Ou6RidY3BnF5bfEy3QdDG1eYVYJonFsIQeIyBMFXG6I3tQrzQmI5xsrxHUTtmu50w8TnZuXB1kH+GoW1EV6nfW3a6J/lNxJZI6I3Y2r3UoOkg1DCgCjEYmg9GoZlIGKLmyjHXQoQuQzjwkWXrUjeFW9XIVUR0a8GeOFcr+kyTjFL/+TgyOnPn8ZXRCdesBOByZ7b5cus77it6xBBZw5ujLB3o16YfOQAkYE6ODqGR+owV1K+w18U9TKzfS8qgCmaVRLZRC4Cn/Y6K6gQ7zwzNmBwisdabh7W9IAap1xp8NGAtgk1dDVenTJtMHn9vmzHFSN26zPxIKSWNS+//G51zS6zuu9dU7OhEJSG+lHYMvxAw9liK4JewlGGM1aReyp/jPZziIR5oZjlm2wJbNS7SCW7N5k9xCqDjTsFfBZF91CwkRQ0zf2CmmBY7FoJ/3Itm2IAvyEXvuChjWPU6cjlo3ZwdtAIbHMyau0hYeyF+8ZtpETwYGUixVx+pOH7cOYyPE5pV7ojLG22MtcJ2qKG+GUTsxY/3vR+0rBb5G+ZuoNR8Em4JwD+dDvcnSKtFh39jFD7/PbIIgVX4VYiPOGU2zZh7bke5WqY2kB7mzrT6nHXJXwDMdaE7Jm4GKi40O/YO1JU0JknB4DsS5fuluhoLDMnGOkV/6eXQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(110136005)(2906002)(54906003)(6636002)(2616005)(36756003)(6486002)(6512007)(316002)(186003)(5660300002)(76116006)(4326008)(66556008)(66446008)(8936002)(6506007)(64756008)(71200400001)(38100700002)(8676002)(26005)(122000001)(66946007)(508600001)(82960400001)(86362001)(91956017)(38070700005)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cFA4UGFYNnhTNW95QVBqb1llclZZZ0c4RVFsWlZMZnlRY3dyazJkbGYvZURs?=
 =?utf-8?B?TFk5U3d2THIvdTV1aGo0S1hDdGV0US9MTzJJelpUdDFjQkFFM3BsaW9WRCtn?=
 =?utf-8?B?TlpoWkg4TGE5NHN5aFVUdjBDMEJTWEtzVlpKc1FVaHRiRFYrUlJPS2Y0TFF2?=
 =?utf-8?B?Mjk0bGR2b01TM0dERm1Vcktwc3dmOXdQRjNydllEZ3RGSk1tM3VJYllKOXN5?=
 =?utf-8?B?TG1ZOS96SEw4R3FMWDJJYy9TSFY2RFdxaldla1p5OFlmTmZTS3FlYkJrdS9Q?=
 =?utf-8?B?VkFPakZKanBsMWFJVUp0ZUlMN3dWbzNVeXRCUEZkSHlReDUxQW1Od0ZZMkJs?=
 =?utf-8?B?b2xiVStqYWhMNG1DcVFaeS9TRGZDSnJFbWRKajJkOWdFRnZqODdoVzBoUk5q?=
 =?utf-8?B?YnNQUTExQ1dzZmlJYklXMzZpVkxFOFl6MEFQSjlDSGpKd3VXQ0E4b256Rzk5?=
 =?utf-8?B?RHZjYWdsRDkwcEJOWlpLdGU3c3d5V2ZPZGM2Z1Z4V1B2eFFsYTZ5cWtlTm9j?=
 =?utf-8?B?dTI1Mi9jSnlJQjljd2JmRGdpWEI5Zy9pUmtpZFk0VW1ZMFFBMXQrUVIrMmdz?=
 =?utf-8?B?djVkMGI3Nnp4QktIQTZ0WEpyUnBRUFY5V09ydnE4R3VETnJGMjZnZHIrV2dz?=
 =?utf-8?B?MzFvcnpmQnZsMWlqUU5Uc1pveC93cnJ3bVBMVU9VT1dDVkRXODBSZHVERlVW?=
 =?utf-8?B?VHlORVpiWHREMXQ4Z0gvd1ZhNEVWRW82Rk5tVGFGTXoycDJ3MzZpUE5QL2Ns?=
 =?utf-8?B?VDhnR3pmTWVBZGloYVYvMzRvaDBxaUZOaS9QWkcveFIzdmlxYnVlYUlLTlAv?=
 =?utf-8?B?dzI0bmdlSHlrUkxiL3BCaFlzRE5HdDNRbmErNXZlUE1yWWk4aHhneVpGcERy?=
 =?utf-8?B?aUpYSHRFWU15Q2g3dENNYlc1ODFqVEJod1VmOTVOYUpXbEpWSkJnbWlsZkw5?=
 =?utf-8?B?YnZ6dXBPWGRVSVlGdjhRbFdzaTk3WmtQaFphRUpPNXpORCsxYmM4RnFjYVlv?=
 =?utf-8?B?OFZlUlczRWplMmRWVjFDdFM0YzNTZWEvYzc5RG9CYThJUXVBTTA0c2FoMUhr?=
 =?utf-8?B?ZlFqZEIydW1JVlcyZUkyVElEbWNvUlpkS2Q1UURDSytvRXpLK3ZXNGFWTG1y?=
 =?utf-8?B?TTFabFd6V043cFJ6dnVXMW44QU9vaXkxSFd1eGxrRG44NUplMXNoSEJMZzkz?=
 =?utf-8?B?Z0F1OEpINVF4UitJSm00RVN6TTJFK1pJejZ6Q282VExWRFNhVTdVS3UzU2tm?=
 =?utf-8?B?OHFwbmYrbXhlMitQSnhSMU53N3B5L3hTTEpuQWxvNS9lY0pFdEhlNmMwdVgz?=
 =?utf-8?B?Z1NUZVVoQUFLbklmclY5eG1BKzhRVldjQUZ3ZFpQNW51d1B5SjlFZE9TS0Zr?=
 =?utf-8?B?VnFRSVU2VEJPLy9NN294eUNUeFc1citqK2dLblp4NGhjMmxPME9aOXozQmM4?=
 =?utf-8?B?LzhYclUrd3VyZWJoQmNsaCtxTG96MVE3YnZ4VXo5N2RVK0VwRzVlQ2Z4RUhp?=
 =?utf-8?B?dXJselhYbW1RaTZDMVJDeWprSXUwU2VzK1lZRUcyTUl0WlVOYTQxSG5tbmwr?=
 =?utf-8?B?SUZSaEFZQjc1TkpCM2c3NFpQWTJaVzZnM0dxbjdENGhZZFoweVh6MXlYYWVl?=
 =?utf-8?B?VVowTmNON0RYak83OVlRWXY3d2Y1NEJ1eHVDUVU2SHNCOTZzcGtVRmtEY294?=
 =?utf-8?B?SUZ4ZlVYVmpiVlI2M1ZFNDB2ckhueHFKYXVJVlgwVzQ3eXNCZmdqbm5vWnpW?=
 =?utf-8?B?M3JFYlVlakFjbFNlcTBISTJYQjkzREtOVTA1MDh3L0ZZQ3RSN0tBbWR6N2F2?=
 =?utf-8?B?SFBqQmdocWlDZEIrSlJDRmNkdWhTQXVlL2ZveVpiSE1RSStrYTRvV1UvdVJp?=
 =?utf-8?B?byswelV3RE1pSFdhcnVORU5uYlF5MU84aFJWODZaaUpwSVJzQ1gyZVYwekg0?=
 =?utf-8?B?TFNhUlFtcEgrQmc0aE01MGg1WkJsSFIvMVFmcWVVR3ZqY0dhMVp5VjRQTHpv?=
 =?utf-8?B?Z3hVMld6ajhVZk5TcklkZVQwbFRMY1Y2Q21JL2ZjSU1nUXVEUDNyL0ttdXRi?=
 =?utf-8?B?ckQvV2xCRUczck5DR1VaOFkzSGhqUEg1cWdXbEJOOE90ajJNbGRYanhLSmhD?=
 =?utf-8?B?aUI1M0VUQjdtbm04c3IrbG11dERUQ254b1ZCcDhWREZpTlMvb1dONm9UZzhR?=
 =?utf-8?B?OTRwMGpsRXBMbHJaWWRIclBKbWROTlRFQXdOMTRZV1diWEVYZlpVOVhBSno3?=
 =?utf-8?Q?QzdEAPZ/1YUGcfHLqSWT771f6y0d+9W0XhjkCyzN7E=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CCB7DF56C0E94C4FB72BFBB36B02D3B9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: beedafe8-c7c6-468a-1afb-08d9f633f777
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2022 18:48:50.3616
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yZufrAJjKplrf3l7jefZrYYPExybPiDbjIw/NUfrDy7hXm4AzL6zqs8cfOiLBKBdR4OjYn2XyUF7I56gJnKfU5Eqgdmbof1McI4nNCLu5T4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1813
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDIyLTAyLTIyIGF0IDEwOjIzIC0wODAwLCBhbGlzb24uc2Nob2ZpZWxkQGludGVs
LmNvbSB3cm90ZToNCj4gRnJvbTogQWxpc29uIFNjaG9maWVsZCA8YWxpc29uLnNjaG9maWVsZEBp
bnRlbC5jb20+DQo+IA0KPiBDWEwgc3BlY2lmaWVzIEdFVF9QQVJUSVRJT05fSU5GTyBtYWlsYm94
IGNvbW1hbmQgYXMgb3B0aW9uYWwuIEEgZGV2aWNlDQo+IG1heSBub3Qgc3VwcG9ydCB0aGUgY29t
bWFuZCB3aGVuIGl0IGhhcyBubyBwYXJ0aXRpb25hYmxlIHNwYWNlLg0KPiANCj4gRmxpcCB0aGUg
b3JkZXIgaW4gd2hpY2ggdGhlIGNvbW1hbmQgY3hsLWxpc3QgcmV0cmlldmVzIHRoZSBwYXJ0aXRp
b24NCj4gaW5mbyBzbyB0aGF0IHRoZSBmaWVsZHMgcmVwb3J0ZWQgYnkgdGhlIElERU5USUZZIG1h
aWxib3ggY29tbWFuZCBhcmUNCj4gYWx3YXlzIHJlcG9ydGVkLCBhbmQgdGhlbiB0aGUgZmllbGRz
IHJlcG9ydGVkIGJ5IHRoZSBHRVRfUEFSVElUSU9OX0lORk8NCj4gbWFpbGJveCBjb21tYW5kIGFy
ZSBvcHRpb25hbGx5IHJlcG9ydGVkLg0KPiANCj4gRml4ZXM6IDc1ODFhYmE1MmRhMCAoImN4bDog
YWRkIG1lbWRldiBwYXJ0aXRpb24gaW5mb3JtYXRpb24gdG8gY3hsLWxpc3QiKQ0KPiBTaWduZWQt
b2ZmLWJ5OiBBbGlzb24gU2Nob2ZpZWxkIDxhbGlzb24uc2Nob2ZpZWxkQGludGVsLmNvbT4NCj4g
LS0tDQo+IA0KPiBWaXNoYWwsIEkgd2Fzbid0IHN1cmUgd2hldGhlciB0byByZXYgdGhlIG9yaWdp
bmFsIHBhdGNoc2V0IG9yIHBvc3QgYXMgYQ0KPiBmaXguIExldCBtZSBrbm93Lg0KDQpIZXkgQWxp
c29uLA0KDQpJIGhhZG4ndCBwdWxsZWQgaW4gdGhlIG9yaWdpbmFsIHBhdGNoc2V0IHRvIHBlbmRp
bmcgeWV0LCBzbyByZXYnaW5nIGl0DQp3b3VsZCBiZSBiZXR0ZXIuIFRoZSBGaXhlcyBsaW5lIGFi
b3ZlIGRvZXNuJ3QgcG9pbnQgdG8gYW55dGhpbmcgc3RhYmxlDQplaXRoZXIgLSBnZW5lcmFsbHks
IHRoYXQgc2hvdWxkIG9ubHkgZXZlciBwb2ludCB0byBjb21taXRzIHRoYXQgaGF2ZQ0KYXBwZWFy
ZWQgaW4gJ21hc3Rlcicgb3IgJ3BlbmRpbmcnLiBBbnkgb3RoZXIgYnJhbmNoIGlzIGZyZWUgdG8g
cmViYXNlDQphdCB3aWxsLg0KDQo+IA0KPiANCj4gIGN4bC9qc29uLmMgfCA5NyArKysrKysrKysr
KysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gIDEgZmlsZSBj
aGFuZ2VkLCA1MiBpbnNlcnRpb25zKCspLCA0NSBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1n
aXQgYS9jeGwvanNvbi5jIGIvY3hsL2pzb24uYw0KPiBpbmRleCA2OTY3MWIzZTdmZTkuLmZkYzZm
NzNhODZjMSAxMDA2NDQNCj4gLS0tIGEvY3hsL2pzb24uYw0KPiArKysgYi9jeGwvanNvbi5jDQo+
IEBAIC0yMDQsNDggKzIwNCw2IEBAIHN0YXRpYyBzdHJ1Y3QganNvbl9vYmplY3QgKnV0aWxfY3hs
X21lbWRldl9wYXJ0aXRpb25fdG9fanNvbihzdHJ1Y3QgY3hsX21lbWRldiAqDQo+ICAJaWYgKCFt
ZW1kZXYpDQo+ICAJCWdvdG8gZXJyX2pvYmo7DQo+ICANCj4gLQkvKiBSZXRyaWV2ZSBwYXJ0aXRp
b24gaW5mbyBpbiBHRVRfUEFSVElUSU9OX0lORk8gbWJveCBjbWQgKi8NCj4gLQljbWQgPSBjeGxf
Y21kX25ld19nZXRfcGFydGl0aW9uKG1lbWRldik7DQo+IC0JaWYgKCFjbWQpDQo+IC0JCWdvdG8g
ZXJyX2pvYmo7DQo+IC0NCj4gLQlyYyA9IGN4bF9jbWRfc3VibWl0KGNtZCk7DQo+IC0JaWYgKHJj
IDwgMCkNCj4gLQkJZ290byBlcnJfY21kOw0KPiAtCXJjID0gY3hsX2NtZF9nZXRfbWJveF9zdGF0
dXMoY21kKTsNCj4gLQlpZiAocmMgIT0gMCkNCj4gLQkJZ290byBlcnJfY21kOw0KPiAtDQo+IC0J
Y2FwID0gY3hsX2NtZF9wYXJ0aXRpb25fZ2V0X2FjdGl2ZV92b2xhdGlsZV9zaXplKGNtZCk7DQo+
IC0JaWYgKGNhcCAhPSBVTExPTkdfTUFYKSB7DQo+IC0JCWpvYmogPSB1dGlsX2pzb25fb2JqZWN0
X3NpemUoY2FwLCBmbGFncyk7DQo+IC0JCWlmIChqb2JqKQ0KPiAtCQkJanNvbl9vYmplY3Rfb2Jq
ZWN0X2FkZChqcGFydCwNCj4gLQkJCQkJImFjdGl2ZV92b2xhdGlsZV9zaXplIiwgam9iaik7DQo+
IC0JfQ0KPiAtCWNhcCA9IGN4bF9jbWRfcGFydGl0aW9uX2dldF9hY3RpdmVfcGVyc2lzdGVudF9z
aXplKGNtZCk7DQo+IC0JaWYgKGNhcCAhPSBVTExPTkdfTUFYKSB7DQo+IC0JCWpvYmogPSB1dGls
X2pzb25fb2JqZWN0X3NpemUoY2FwLCBmbGFncyk7DQo+IC0JCWlmIChqb2JqKQ0KPiAtCQkJanNv
bl9vYmplY3Rfb2JqZWN0X2FkZChqcGFydCwNCj4gLQkJCQkJImFjdGl2ZV9wZXJzaXN0ZW50X3Np
emUiLCBqb2JqKTsNCj4gLQl9DQo+IC0JY2FwID0gY3hsX2NtZF9wYXJ0aXRpb25fZ2V0X25leHRf
dm9sYXRpbGVfc2l6ZShjbWQpOw0KPiAtCWlmIChjYXAgIT0gVUxMT05HX01BWCkgew0KPiAtCQlq
b2JqID0gdXRpbF9qc29uX29iamVjdF9zaXplKGNhcCwgZmxhZ3MpOw0KPiAtCQlpZiAoam9iaikN
Cj4gLQkJCWpzb25fb2JqZWN0X29iamVjdF9hZGQoanBhcnQsDQo+IC0JCQkJCSJuZXh0X3ZvbGF0
aWxlX3NpemUiLCBqb2JqKTsNCj4gLQl9DQo+IC0JY2FwID0gY3hsX2NtZF9wYXJ0aXRpb25fZ2V0
X25leHRfcGVyc2lzdGVudF9zaXplKGNtZCk7DQo+IC0JaWYgKGNhcCAhPSBVTExPTkdfTUFYKSB7
DQo+IC0JCWpvYmogPSB1dGlsX2pzb25fb2JqZWN0X3NpemUoY2FwLCBmbGFncyk7DQo+IC0JCWlm
IChqb2JqKQ0KPiAtCQkJanNvbl9vYmplY3Rfb2JqZWN0X2FkZChqcGFydCwNCj4gLQkJCQkJIm5l
eHRfcGVyc2lzdGVudF9zaXplIiwgam9iaik7DQo+IC0JfQ0KPiAtCWN4bF9jbWRfdW5yZWYoY21k
KTsNCj4gLQ0KPiAgCS8qIFJldHJpZXZlIHBhcnRpdGlvbiBpbmZvIGluIHRoZSBJREVOVElGWSBt
Ym94IGNtZCAqLw0KPiAgCWNtZCA9IGN4bF9jbWRfbmV3X2lkZW50aWZ5KG1lbWRldik7DQo+ICAJ
aWYgKCFjbWQpDQo+IEBAIC0yNTMsMTAgKzIxMSwxMCBAQCBzdGF0aWMgc3RydWN0IGpzb25fb2Jq
ZWN0ICp1dGlsX2N4bF9tZW1kZXZfcGFydGl0aW9uX3RvX2pzb24oc3RydWN0IGN4bF9tZW1kZXYg
Kg0KPiAgDQo+ICAJcmMgPSBjeGxfY21kX3N1Ym1pdChjbWQpOw0KPiAgCWlmIChyYyA8IDApDQo+
IC0JCWdvdG8gZXJyX2NtZDsNCj4gKwkJZ290byBlcnJfaWRlbnRpZnk7DQo+ICAJcmMgPSBjeGxf
Y21kX2dldF9tYm94X3N0YXR1cyhjbWQpOw0KPiAgCWlmIChyYyAhPSAwKQ0KPiAtCQlnb3RvIGVy
cl9jbWQ7DQo+ICsJCWdvdG8gZXJyX2lkZW50aWZ5Ow0KPiAgDQo+ICAJY2FwID0gY3hsX2NtZF9p
ZGVudGlmeV9nZXRfdG90YWxfc2l6ZShjbWQpOw0KPiAgCWlmIChjYXAgIT0gVUxMT05HX01BWCkg
ew0KPiBAQCAtMjg0LDEwICsyNDIsNTkgQEAgc3RhdGljIHN0cnVjdCBqc29uX29iamVjdCAqdXRp
bF9jeGxfbWVtZGV2X3BhcnRpdGlvbl90b19qc29uKHN0cnVjdCBjeGxfbWVtZGV2ICoNCj4gIAkJ
anNvbl9vYmplY3Rfb2JqZWN0X2FkZChqcGFydCwgInBhcnRpdGlvbl9hbGlnbm1lbnRfc2l6ZSIs
IGpvYmopOw0KPiAgDQo+ICAJY3hsX2NtZF91bnJlZihjbWQpOw0KPiArDQo+ICsJLyogUmV0dXJu
IG5vdyBpZiB0aGVyZSBpcyBubyBwYXJ0aXRpb24gaW5mbyB0byBnZXQuICovDQo+ICsJaWYgKCFj
YXApDQo+ICsJCXJldHVybiBqcGFydDsNCj4gKw0KPiArCS8qIFJldHJpZXZlIHBhcnRpdGlvbiBp
bmZvIGluIEdFVF9QQVJUSVRJT05fSU5GTyBtYm94IGNtZCAqLw0KPiArCWNtZCA9IGN4bF9jbWRf
bmV3X2dldF9wYXJ0aXRpb24obWVtZGV2KTsNCj4gKwlpZiAoIWNtZCkNCj4gKwkJcmV0dXJuIGpw
YXJ0Ow0KPiArDQo+ICsJcmMgPSBjeGxfY21kX3N1Ym1pdChjbWQpOw0KPiArCWlmIChyYyA8IDAp
DQo+ICsJCWdvdG8gZXJyX2dldDsNCj4gKwlyYyA9IGN4bF9jbWRfZ2V0X21ib3hfc3RhdHVzKGNt
ZCk7DQo+ICsJaWYgKHJjICE9IDApDQo+ICsJCWdvdG8gZXJyX2dldDsNCj4gKw0KPiArCWNhcCA9
IGN4bF9jbWRfcGFydGl0aW9uX2dldF9hY3RpdmVfdm9sYXRpbGVfc2l6ZShjbWQpOw0KPiArCWlm
IChjYXAgIT0gVUxMT05HX01BWCkgew0KPiArCQlqb2JqID0gdXRpbF9qc29uX29iamVjdF9zaXpl
KGNhcCwgZmxhZ3MpOw0KPiArCQlpZiAoam9iaikNCj4gKwkJCWpzb25fb2JqZWN0X29iamVjdF9h
ZGQoanBhcnQsDQo+ICsJCQkJCSJhY3RpdmVfdm9sYXRpbGVfc2l6ZSIsIGpvYmopOw0KPiArCX0N
Cj4gKwljYXAgPSBjeGxfY21kX3BhcnRpdGlvbl9nZXRfYWN0aXZlX3BlcnNpc3RlbnRfc2l6ZShj
bWQpOw0KPiArCWlmIChjYXAgIT0gVUxMT05HX01BWCkgew0KPiArCQlqb2JqID0gdXRpbF9qc29u
X29iamVjdF9zaXplKGNhcCwgZmxhZ3MpOw0KPiArCQlpZiAoam9iaikNCj4gKwkJCWpzb25fb2Jq
ZWN0X29iamVjdF9hZGQoanBhcnQsDQo+ICsJCQkJCSJhY3RpdmVfcGVyc2lzdGVudF9zaXplIiwg
am9iaik7DQo+ICsJfQ0KPiArCWNhcCA9IGN4bF9jbWRfcGFydGl0aW9uX2dldF9uZXh0X3ZvbGF0
aWxlX3NpemUoY21kKTsNCj4gKwlpZiAoY2FwICE9IFVMTE9OR19NQVgpIHsNCj4gKwkJam9iaiA9
IHV0aWxfanNvbl9vYmplY3Rfc2l6ZShjYXAsIGZsYWdzKTsNCj4gKwkJaWYgKGpvYmopDQo+ICsJ
CQlqc29uX29iamVjdF9vYmplY3RfYWRkKGpwYXJ0LA0KPiArCQkJCQkibmV4dF92b2xhdGlsZV9z
aXplIiwgam9iaik7DQo+ICsJfQ0KPiArCWNhcCA9IGN4bF9jbWRfcGFydGl0aW9uX2dldF9uZXh0
X3BlcnNpc3RlbnRfc2l6ZShjbWQpOw0KPiArCWlmIChjYXAgIT0gVUxMT05HX01BWCkgew0KPiAr
CQlqb2JqID0gdXRpbF9qc29uX29iamVjdF9zaXplKGNhcCwgZmxhZ3MpOw0KPiArCQlpZiAoam9i
aikNCj4gKwkJCWpzb25fb2JqZWN0X29iamVjdF9hZGQoanBhcnQsDQo+ICsJCQkJCSJuZXh0X3Bl
cnNpc3RlbnRfc2l6ZSIsIGpvYmopOw0KPiArCX0NCj4gKw0KPiArZXJyX2dldDoNCj4gKwljeGxf
Y21kX3VucmVmKGNtZCk7DQo+ICAJcmV0dXJuIGpwYXJ0Ow0KPiAgDQo+IC1lcnJfY21kOg0KPiAr
ZXJyX2lkZW50aWZ5Og0KPiAgCWN4bF9jbWRfdW5yZWYoY21kKTsNCj4gKw0KPiAgZXJyX2pvYmo6
DQo+ICAJanNvbl9vYmplY3RfcHV0KGpwYXJ0KTsNCj4gIAlyZXR1cm4gTlVMTDsNCg0K
