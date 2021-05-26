Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 009FE2FAE
	for <nvdimm@lists.linux.dev>; Wed, 26 May 2021 19:33:16 +0000 (UTC)
IronPort-SDR: nggzuMHxWqVVPoQ+wtK+hCo42sNVd5fhK/Dw/pIs+4nHmgekr/Su/1DOdyP4kTeVASLqFuqxRx
 h6+Mv6QSd+4A==
X-IronPort-AV: E=McAfee;i="6200,9189,9996"; a="199507484"
X-IronPort-AV: E=Sophos;i="5.82,331,1613462400"; 
   d="scan'208";a="199507484"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2021 12:33:16 -0700
IronPort-SDR: cEUgGUDN96LRrje/oJh0454pSR7vImCKs7TAG8zpvJj18Cgd26rhWwNyZ12UD4e9YqikGg3C4M
 tYFVeJmbvWhA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,331,1613462400"; 
   d="scan'208";a="436245729"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga007.jf.intel.com with ESMTP; 26 May 2021 12:33:15 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 26 May 2021 12:33:15 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Wed, 26 May 2021 12:33:15 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Wed, 26 May 2021 12:32:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RRq4ELxMx7vx5y7LmI3AEaRHP2ZuuNjX0A3VAZmdu0wvCmAgbU6aMKYCNlZdqCaNuhX7hZVIcq60guQYQQNwU8F8vzDARNeaWQBDWK5EcLbvMPe9hTaHUlNatF1HhnF2rIY2yid1K48WrrEofIZVzYmXFG8UgQbuaUmuZFXblWg9qtYsocU2zzuJVVWmEVIjMumTfE789745rXcfwCginmblAmuCTT2ixfw3McsCqacraCz/B3Bzg1z/0CCJonMhPIa9F4tpHuHb4OkTnEH85Ekn0ySWNzJVqhEFQIuiW9b+OzkkIg8ublOX8kjEPFVDRvtXkf0PB/eu/EXS9UHCZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9bL0wF6jfG3Vdo5BLMTytE2zPXtTCZ3dlmoRGx0nZCA=;
 b=LoBFRtgt1PpBhCUC3EqAtYTXdGi5+wWmlbPmA6bec1H8DDOoaA/igZWwxttmCOeaSTVI11zswDs06aNwIFyFAfZQTcEB8vMP6oorXCw+rS5G6du1CLGRee4kZmUQiBSmAfB0PiydQzWG1dvJfEq9FQXHzgfOJP75yzxGHWU4XEAhI4Vvmy3+++oACYdVxu5IT+N/T8qyw/BpQ1wSwOZFYxfL7L6w85Ls7IOyZjz5mcqea9T+Oime9PWIpUQiriXrKA1amniLaN7v8EVa0/dc0AtNJj4JRqgYX0f1kKP9w43Ez8WiiCw8v3THStjiNmW1CUF0PM/1VMq8gSHND+PlqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9bL0wF6jfG3Vdo5BLMTytE2zPXtTCZ3dlmoRGx0nZCA=;
 b=miG/4hB3UgpgTYB+Eg4IRfFet70B2JehDiW0Wqnynla6hNKITVWTOVePjwy2cGzTQikZ0R2YEUQIz7nQgox3kBuNqgyAHfO+y3EiPggrRb5mMy95Og/rGVzRF9roLoIEvYG96sJn3lLKp4qgz1wMX+A/W3iCHvocmLN4if5I3y0=
Received: from BYAPR11MB3448.namprd11.prod.outlook.com (2603:10b6:a03:76::21)
 by BY5PR11MB3895.namprd11.prod.outlook.com (2603:10b6:a03:18e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Wed, 26 May
 2021 19:32:30 +0000
Received: from BYAPR11MB3448.namprd11.prod.outlook.com
 ([fe80::713c:a1f6:aae4:19fc]) by BYAPR11MB3448.namprd11.prod.outlook.com
 ([fe80::713c:a1f6:aae4:19fc%5]) with mapi id 15.20.4150.027; Wed, 26 May 2021
 19:32:29 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "santosh@fossix.org"
	<santosh@fossix.org>
CC: "sbhat@linux.ibm.com" <sbhat@linux.ibm.com>, "harish@linux.ibm.com"
	<harish@linux.ibm.com>, "aneesh.kumar@linux.ibm.com"
	<aneesh.kumar@linux.ibm.com>
Subject: Re: [ndctl V5 4/4] Use page size as alignment value
Thread-Topic: [ndctl V5 4/4] Use page size as alignment value
Thread-Index: AQHXR78dliwb0fNPv0qbbfUYRWQK7qrhuPoAgBSC84CAAABOAA==
Date: Wed, 26 May 2021 19:32:29 +0000
Message-ID: <5cc6a4e35883fe8d77ad375de4aef64044b076f5.camel@intel.com>
References: <20210513061218.760322-1-santosh@fossix.org>
	 <20210513061218.760322-4-santosh@fossix.org>
	 <27307f1aceeda53154b9985f065fdada71cf1fd4.camel@intel.com>
	 <6708790151b3f627bafb2eedd21dca000372a4e9.camel@intel.com>
In-Reply-To: <6708790151b3f627bafb2eedd21dca000372a4e9.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.40.1 (3.40.1-1.fc34) 
authentication-results: lists.linux.dev; dkim=none (message not signed)
 header.d=none;lists.linux.dev; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.137.75]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f137498d-f5bb-4b57-41e9-08d9207d0067
x-ms-traffictypediagnostic: BY5PR11MB3895:
x-microsoft-antispam-prvs: <BY5PR11MB389570108484FB4333FD5658C7249@BY5PR11MB3895.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EODKHXBqP6r7lpL4G9KvqNuCu2N+K+tKWhAEheHX/d2sTcEQLCc635Kk2qwd770mqKUuvnbUNxPjmgqVeHFkI87bH36cCbz4iTThxDaXnHU88iqWTLh862hagwhtIgWKvVB+YoGkfVv7QzFl1ojQHrwPCKUChJj7H9Q/J8fp7ze1b1MwJp4Gk0hyomWacPNzHmUFnSvWgeDX1TKn2LTY9UoVQqfwgaUniejDBjCBKS63IKS7XzAFYmjV3P6/x4rKVyDl60Ik7RwednIg4bOpRezmLIJ4DUhIEuqYEnfKtkg28HQrrh88c7B09BJ8/H/jiYvD4Du7+IKIsOxvRX+jK61yfNaEC74l92s2oIuw4jIxvDlRh+KEwqtk2qAhBLv9sdG1znwAwLJp/upyg3YIdGUxvXLzCnolTSUkqisFe1uhVAhgwSCddAQ6aq70/CIkMQhmAtBkQXrZxBP0GWQZn1GpM0zX65lYpRlYPmD3KEObpJyl1RjKfRCGgxm0kc6bSU7sjL+aUc0tJLL0sG9vSh6rDu2ChKBbqZVQMbpg+TiJNSm3sq43pWihesGUtXywH6S0COHBYCDqLq2lcRd3APaWY8VTBH5Ze31EL2CsEKkQHxwDQckqecgmwVyTGx8QhSB7YePSR09G8pCsHJise9Lu4Og6zSD3Wc2Hvyyo+SGV0iMXpeLLhZD/4KStYfZEQOjfFbFWkXfluSLwlrS90A943koRTaHW77k+AnxE1G8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3448.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(39860400002)(396003)(366004)(376002)(76116006)(478600001)(91956017)(6506007)(6512007)(66446008)(316002)(2616005)(64756008)(4326008)(66476007)(8936002)(186003)(66946007)(5660300002)(122000001)(38100700002)(26005)(66556008)(54906003)(966005)(86362001)(4744005)(83380400001)(8676002)(71200400001)(36756003)(2906002)(6486002)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?NjB3SjFKMWh1UDl2ZE53OGFsZkRaZHJkcWRSOEJuYnptWisvUElWaFpCcVR1?=
 =?utf-8?B?dnVVd3pBV001a3E3UkhhSU1SNzdEdXZqeFRwVyswQnRKU0NVZDI1cUZQekd0?=
 =?utf-8?B?cUd4dTBqa0k0RWdrTlFIckFDTVUzWUk1UmRzZ0Y0OVpNRGJGeGplSzd2NzA5?=
 =?utf-8?B?dkNYUjBxbHhVSGlIc2hNRm82Umt6Z0llS1pWdlJpSml3MUw0VkpIc055ak8w?=
 =?utf-8?B?TWUvdkl6T3BkblZRT0hjTVVZS2ZwdVVDWGpodnMzZldMcnJuekI5U0J1UmVR?=
 =?utf-8?B?MzFsaCsramJqUkxSOHhtOXlGbmp2aFF2Z0JHYmc0SFA2OWpDVG9XMXhmK0Q5?=
 =?utf-8?B?eUtJQVZYaDZHYkFNWmRlT3JaZ1hLV1YxTW9LcDNlNk1CWWNVU2gyTlRWN3VP?=
 =?utf-8?B?MG1ZN2ZGb2s2a3NmVTFDWmJXVy9Xc3hlMEhidzVLMmF5T2dJTlNldjlxZTZi?=
 =?utf-8?B?Q2s4RVJTUW5ncXVESDNTdHh0N0RKalkvOGNZRHAvKzNUUUtOUHMwSlZiZ1Y5?=
 =?utf-8?B?WkJTQ1hleWNkbDJNMlh1SmVEQnc4T0hsdlhTbjRKZ2xSV3JsaVBhSzFKZk12?=
 =?utf-8?B?MEhoWGp1SEZyck1LMkpvVXJNTTlySkFHTVRFRjRCTmNTeUozQlVDdnBacHp3?=
 =?utf-8?B?SlN5UmcvaURuV1ZzYVBTS0Iya0NmNXFpb3YrRkVmWSt2NTdZRUpEb3BnWmdP?=
 =?utf-8?B?YjhYVkxOeXJ2ZE1lSmNNR3NMK2JpRFZKSlhKc2pnVCtxRmw0Y1cvKzdVYXYz?=
 =?utf-8?B?SXQyVFBQdm8wTlpZV0hmZDcwcklaR29zVi9qUGRFdGUvd001TmlYZE1RNWxF?=
 =?utf-8?B?ZTMwbW91TEh4V2ttamk0ZXVDZDQwR0ZnVkhhdUNYMWVDSnl2SFVKSnFkdEFR?=
 =?utf-8?B?ck9xRTR1RzJGU1BEdDNnWnU2bmQ3NTFRNkNGNFgzbHV6MExMK3IwNEFQbDk0?=
 =?utf-8?B?UlBwSkF1WGEram1vaHJYVjI0NmMrek9wbkQ4Z3poZ3BYelVBZXBVV0Q4cXN0?=
 =?utf-8?B?bVVYMkdNS2w4TFljSkZNK3M3V3EvRENPa0ZYSTd2ekFVbURlMzZRYndmV1ZM?=
 =?utf-8?B?YTdBYys4R0FEZFRiekdwS2pMWmlFZldlZUxONklXMFZhS3NCZmNHbEg3MUJO?=
 =?utf-8?B?VDZNNkVrRG0rbHlZS3BzOVZZOCtoZnh6cDJEL1crVTJIYXZDMjc0RFM4Q2ta?=
 =?utf-8?B?akdISTJDY0Yzb3NCSm5YTC8wOGxEbzVGS1B0WEpsYjhZelNBSVhUSmhFenJK?=
 =?utf-8?B?cFFURTRNUlh0VE0vejJvbGk1TmNKZGlsc3NCWUpwbktrMTVOVndlZnBFOE1k?=
 =?utf-8?B?WXR0OFAvR3NaQzRzdXd3cjZrV2ZiVW1BNWhYMGQybDVmVFZialpzbkNxYWQv?=
 =?utf-8?B?T1VHa09GdWtQRldJT0lqM2xyMzROWHVsSDNDNk0yZzNGK1I2NmRPOUhKeFRY?=
 =?utf-8?B?YUQ4MEhsTmJzNE45N29RWEdTblBxd2U4SDN4aHB0WEVSTnJUeC9oa0FuTjdr?=
 =?utf-8?B?b0lWMG1YZVlYTEdjNTE4TVR5OWFtRWlhZTdqS0MvakV6YmpTTlVGNHoyR0hq?=
 =?utf-8?B?TFlNZS8vNXJ5b0lRS2J3WlBIVm5UNk9wTDh0dG10ZnRUWEhVWjRxSHNOcUVN?=
 =?utf-8?B?YkpObkJYV1NCTWtCRTZadEU3VnhNMU53WXMyeEdueWlrRGo4Qmxza1V5TGIw?=
 =?utf-8?B?WkZ2ZnE3K1VGRVBEOHJVZzF2NDN4U2lkNndISFJIWnZJeHVabkh6dFdwUzAr?=
 =?utf-8?B?Mmp4Q3RRaFo2RWtRck5tZEt3bnBqaVpyTUNKajl5cnQ0aGtXeGdpVjR2MXBs?=
 =?utf-8?B?M2N5d2ZzSG93OXF0REIzZz09?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <E8A25A61A68E16419B3002683BE5F8D8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3448.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f137498d-f5bb-4b57-41e9-08d9207d0067
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 May 2021 19:32:29.8264
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ACw056huKf9r6TWlGy2fZyx0fOIDqcKwnrbCsLuV4cf6TAqGFRaviIM3MuZOsBm5EQ918hl5A33n7lOc9LVZVUqOizHWeNS3cga0wbrNyac=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB3895
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDIxLTA1LTI2IGF0IDE5OjMxICswMDAwLCBWZXJtYSwgVmlzaGFsIEwgd3JvdGU6
DQo+IE9uIFRodSwgMjAyMS0wNS0xMyBhdCAxODoxNyArMDAwMCwgVmVybWEsIFZpc2hhbCBMIHdy
b3RlOg0KPiA+IE9uIFRodSwgMjAyMS0wNS0xMyBhdCAxMTo0MiArMDUzMCwgU2FudG9zaCBTaXZh
cmFqIHdyb3RlOg0KPiA+ID4gVGhlIGFsaWdubWVudCBzaXplcyBwYXNzZWQgdG8gbmRjdGwgaW4g
dGhlIHRlc3RzIGFyZSBhbGwgaGFyZGNvZGVkIHRvIDRrLA0KPiA+ID4gdGhlIGRlZmF1bHQgcGFn
ZSBzaXplIG9uIHg4Ni4gQ2hhbmdlIHRob3NlIHRvIHRoZSBkZWZhdWx0IHBhZ2Ugc2l6ZSBvbiB0
aGF0DQo+ID4gPiBhcmNoaXRlY3R1cmUgKHN5c2NvbmYvZ2V0Y29uZikuIE5vIGZ1bmN0aW9uYWwg
Y2hhbmdlcyBvdGhlcndpc2UuDQo+ID4gPiANCj4gPiA+IFNpZ25lZC1vZmYtYnk6IFNhbnRvc2gg
U2l2YXJhaiA8c2FudG9zaEBmb3NzaXgub3JnPg0KPiA+ID4gLS0tDQo+ID4gPiAgdGVzdC9kcGEt
YWxsb2MuYyAgICB8IDE1ICsrKysrKysrLS0tLS0tLQ0KPiA+ID4gIHRlc3QvbXVsdGktZGF4LnNo
ICAgfCAgNiArKysrLS0NCj4gPiA+ICB0ZXN0L3NlY3Rvci1tb2RlLnNoIHwgIDQgKysrLQ0KPiA+
ID4gIDMgZmlsZXMgY2hhbmdlZCwgMTUgaW5zZXJ0aW9ucygrKSwgMTAgZGVsZXRpb25zKC0pDQo+
ID4gDQo+ID4gVGhhbmtzIGZvciB0aGUgdXBkYXRlcywgdGhlc2UgbG9vayBnb29kIC0gSSd2ZSBh
cHBsaWVkIHRoZW0gYW5kIHB1c2hlZA0KPiA+IG91dCBvbiAncGVuZGluZycuDQo+ID4gDQo+ID4g
DQo+IEhpIFNhbnRvc2gsDQo+IA0KPiBEYW4gbm90aWNlZCB0aGF0IHRoaXMgcGF0Y2hbMV0gZ290
IGRyb3BwZWQgZnJvbSB0aGUgc2VyaWVzIC0ganVzdA0KPiBtYWtpbmcgc3VyZSB0aGF0IHdhcyBp
bnRlbnRpb25hbD8NCg0KT29wcywgaGl0IHNlbmQgdG9vIGVhcmx5Lg0KDQpbMV06IGh0dHBzOi8v
bG9yZS5rZXJuZWwub3JnL2xpbnV4LW52ZGltbS8yMDIwMTIyMjA0MjUxNi4yOTg0MzQ4LTQtc2Fu
dG9zaEBmb3NzaXgub3JnLw0KDQo+IA0KPiBUaGFua3MsDQo+IC1WaXNoYWwNCg0K
