Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B649D70
	for <nvdimm@lists.linux.dev>; Wed,  2 Jun 2021 05:31:10 +0000 (UTC)
IronPort-SDR: Q0eEZGB6dwj6qjK2EyZUhHmVPdNHMKL9Ijj4Mr+ia/OefZLpszlbjhaiW8Q+kjwuwgoHzkkEyP
 wUX2ItL/1n9w==
X-IronPort-AV: E=McAfee;i="6200,9189,10002"; a="201845201"
X-IronPort-AV: E=Sophos;i="5.83,241,1616482800"; 
   d="scan'208";a="201845201"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 22:31:09 -0700
IronPort-SDR: kFfwr8jkA8mDJLe/m5d3+3rAJZ5J11vaOSzjLHmSOW/qDpQK9wpberUr6Sak1QtjPjFtcdPAhU
 851p/VkguDug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,241,1616482800"; 
   d="scan'208";a="416740376"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 01 Jun 2021 22:31:09 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Tue, 1 Jun 2021 22:31:08 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Tue, 1 Jun 2021 22:31:08 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Tue, 1 Jun 2021 22:31:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hd3M7HmcViPXPVWvSeyScPOMCf3xejB7MsKEbnD7BxPNdZ6B9WvyRqwYI3G9W4Cg31obQYcG1mvY5sujRoQMpS9F224h13jpDGIXV36ZpUhwLnvi0GN0h66RU9LVeYzig/fXxdWFpu4gnoznYodyzaEcjyPjW5PVzRYZILuAncsDRjx3twBL/l5MGdJXNlorH624ZaBmrnMw/XIubUjchEWnY/v1Yz1mHQG3AeAoupsVFfCSmU3iFYPazpbEXqDRRLRQ3+/sQzAa4mYo8pJCiowy2xc/fAT69rr/G0VkuhxlEdezVw3OmcI8zx2CZghyn1R/ak7dQMZCfw0C7hgsww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=67UtdcCWM2XENJfRHfmyH7V9vsEXL/+jNmHQP4FvkYc=;
 b=Jl0/YCW1Kh4TxIFEK5YHjKSzfyiAkyVSDbcqmSrx8yYbe6/8/PpxEdzFDK7qHibn4+awD3fD6c8F13wBrajGJSeIWzQFL0au3L83/xuds9fzsuUtRgnsy//OoDUrrtf4pM1ZytwV3+rACSQQdsEBDvpLt4rtDFhAJlP4SQK4yCjDBuHmNAtwVzOLc1eESdYX1ebdyoOYbly+g32hg0gw5eg15/04JAdmpJABRdCNe4fvTxAIF5K8m/SzNsCFDjQ0TChbvZjKSqbmZISRt+ifLzr5cfJBHBI1Vr6kv9BTCjepYp46soQRTSeDyFkHWfCtcvtCUQFa8OQYPFW/EkLwTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=67UtdcCWM2XENJfRHfmyH7V9vsEXL/+jNmHQP4FvkYc=;
 b=zLbdHWL/fJWIPG9aWq/S1WWX1ReXjMl5XiDm3pjY7xYZT60ZWvWPd23I7KgOchjkqyuEIIPnAMXq7JS785uE9nY0kAFUxkYVoZ8SE6Zcta6/Zt7XA6sQLJLHJXdCDJsFTf1I3Z49MBjL1Ky43wbamm/L1v0FkzrbWAHoJcnJtqI=
Received: from BYAPR11MB3448.namprd11.prod.outlook.com (2603:10b6:a03:76::21)
 by BYAPR11MB2920.namprd11.prod.outlook.com (2603:10b6:a03:82::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.24; Wed, 2 Jun
 2021 05:31:07 +0000
Received: from BYAPR11MB3448.namprd11.prod.outlook.com
 ([fe80::713c:a1f6:aae4:19fc]) by BYAPR11MB3448.namprd11.prod.outlook.com
 ([fe80::713c:a1f6:aae4:19fc%5]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 05:31:07 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "fukuri.sai@gmail.com" <fukuri.sai@gmail.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
CC: "qi.fuli@fujitsu.com" <qi.fuli@fujitsu.com>
Subject: Re: [RFC ndctl PATCH 0/3] Rename monitor.conf to ndctl.conf as a
 ndctl global config file
Thread-Topic: [RFC ndctl PATCH 0/3] Rename monitor.conf to ndctl.conf as a
 ndctl global config file
Thread-Index: AQHXSqlKyo+afcskpkCQhHQX0SuPA6sAS6UA
Date: Wed, 2 Jun 2021 05:31:07 +0000
Message-ID: <0e2b6f25a3ba8d20604f8c3aa4d8854ade0835c4.camel@intel.com>
References: <20210516231427.64162-1-qi.fuli@fujitsu.com>
In-Reply-To: <20210516231427.64162-1-qi.fuli@fujitsu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.40.1 (3.40.1-1.fc34) 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.137.75]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7c9fbac7-d399-42a1-fdb6-08d925879f58
x-ms-traffictypediagnostic: BYAPR11MB2920:
x-microsoft-antispam-prvs: <BYAPR11MB2920C8F509BE46B4B65E4404C73D9@BYAPR11MB2920.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: o28DufCdD/wSPEAGzY3C1J9Fxv3K1m+4UwSTUNXEtpzQ/JY8fHcFOAnaaW2fsjKrrASwgykdLDM+VovkHAumq2gE0+Cndbuomks9kA41KHfSIifmZiDA2TnpzLLAndc5EXwpegNRI1MXL/JPOw2jf7i9uPyeJVx1qTYZ/ur4CYNHFgoNzInKj2JXdV6zYS7ay90z/tB2VYqHZe1lKVRuZMNWIxOlnMXdD0vgKDdIsTvFfgYN0ZznFEiSrId4XSgl1V8Yrj9xiFyQ9scQePAkw5n9ARCVGGdOynTsopgL+IomB86DaiH+thTmFcZtI79u3RbuFo7bIjoKjWcp/jPLiKx0m2v30iliXGnM/q0EHaeeaXMqKoCIHbOQHnk6KzoYxWL6H/n0CqNxDly3Onp9WHuDRmvvL77Xa1TF2WeiqFKc8wZBE7TVjHmkwbwQ1COIJV4u9C91X8oDDEGVuTaS1SVCEfRE06h3feW5PO4yyEjW1gkVtzhtW8aQ1HAakRLumSpq1MMgLTo4M4o31wQB3j2VBLx3ePN4r98tOhBXgJ6p2SxN0sDLaQ9+Iq9KBxYw7DjLRQSTalSwTJg7bvviSXlUHlo/bA0aSz8nNKeVnUI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3448.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(376002)(136003)(39860400002)(366004)(110136005)(5660300002)(38100700002)(2616005)(8936002)(6506007)(4326008)(26005)(71200400001)(64756008)(478600001)(66476007)(76116006)(86362001)(2906002)(6486002)(316002)(83380400001)(6512007)(36756003)(8676002)(66946007)(186003)(66556008)(66446008)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?VWpRWmJtVTEzdTZqNGk2REdkVW11QmZkemFVeWpNSitHMWpQeDJJV0RIckdn?=
 =?utf-8?B?L0M2MXU3aURCTW9CcXJ0c1R1clhabjlmZjRLQkRMeS9pY1Z5bVZOSHJzR2p5?=
 =?utf-8?B?bjQrSkw1K1k2ZllBMzE5cVFYdEpoWHU4ekFHbmtKeGM2SjRiNXd2OU12d0Fs?=
 =?utf-8?B?TUgrMGc4WFhzN0Jad3NIRGNuMFh5U2FyWHRBbXR1N3dTM0liNWNVTFl1dmtV?=
 =?utf-8?B?TkJacURaQjBKcXFycCtpa2lsY0wwR0Q3TVhNZ2NUZUNWODZZbjBHNm5DM2tr?=
 =?utf-8?B?Z3VLUER3MUNJS2Y0ZThpdlFWY2E0YnZ4QkhZODlrSGNnVisrdUNQMmlPMHVV?=
 =?utf-8?B?UzVULzFvakdPTG4xNGFodXNiK2F2VDZ2WDI5eG9uMk90ZWpZU1pYWnVzWC9h?=
 =?utf-8?B?VjQ2Rlk4Y1BFdC9lM1FyaW0xa0xZUU1GVGxzb0JZc1hRUmJTcSt0ZzA1VmdK?=
 =?utf-8?B?YTdDNEVlL0huWXZjQk1FVFhCT2h4cW9NQTMyaS8rTE9yQnB1d2VVU1hTZW9S?=
 =?utf-8?B?dkN6eWIrdmdUR1V0eXdwam1ZbjhjbDhPL2FXbmI1Q2NHa0VCaHBmWklaQ21E?=
 =?utf-8?B?dEdSTzJDNnA3d01YOEtTU051Q2dZVUtZZG05d2ZNa2ZSZ0RsNk1rNCttNWRw?=
 =?utf-8?B?RmV3ejFYU2VwZ1NsTElubFRFOHplVzJaa1o3RGtvNEVrRXJvdG5MSXo5MTJW?=
 =?utf-8?B?UHNkNTc0T2lzdzJYSFdnQk1rQ0M0VnVxeTVTUUtFVExUZ0lnSWN2YVJWN3FQ?=
 =?utf-8?B?a21oYWpRcStKVGxwMTIxTGd6STcvNmVIMURiSDhNci93OStvT3htUWFwbG5B?=
 =?utf-8?B?b1VxRE80bmhsVVZiU0xpcXZmYU9ySDRtUkV3VDNQYnd0R0I4NmE3MEFHb1do?=
 =?utf-8?B?UlhDUXdkMUcwWHYrSGtPaEZrY0Q1dktzTU1Yd0oxeEtJd1kvQ3JvUDY2eGxp?=
 =?utf-8?B?NmhJOXBXZUNiNUxxOHpZRDcvRWtTTTNxSDFqZmF3UTI0TlZobTk2elRuMDJO?=
 =?utf-8?B?WTdOcUY0L0liL005blZaQXd3WjJob0wwUjZqaXpDVEZ2RGZ3U01RZGUweTZY?=
 =?utf-8?B?WWQ5WitBTmovelZ1L3o0a2ZsS3ljSDg3WDRwSzJ1ZjhnNnByb1QrT1BKWWRM?=
 =?utf-8?B?WURvdlR0NXNMYmdpN2hqMzk2MnBiSU15QzdjOGhwS3I1bjhnRXpTdmpqVkFt?=
 =?utf-8?B?OG40V01oYTE4L3RhVGpxVU5FWlZNcXNSbFJxRjk0TVJGWTJVV1QrSGlYSXV1?=
 =?utf-8?B?cmkwSFJzd1Y5STJCTkFoeVhhRVFjZmRpUmVHR2RxZ2xaTTN4c091S3lCeWl4?=
 =?utf-8?B?dEVVMmZwYnRvQ21Zb3A0RGxrVHpiMkxyU2RzWkp4TnBPZUZPQlByOEZpeXhT?=
 =?utf-8?B?TzFDbTA5dU1YKzFhK3ZqcHVTQnM4S2tuN2xxTDhvWmkrUFpzUTlWNlNxRG84?=
 =?utf-8?B?OFFVR1RtakVPNEF3YStvSjZkWHd2VE5oTHhYTm5Zd2puWXpnTUFHL3RDZ0dK?=
 =?utf-8?B?Wm5ZYlFBd3JmT0IyN3BLOG95YW1TVHNYZ1lXODcyODZLVURiYmx3U1dZUFc1?=
 =?utf-8?B?WlNNS29pRTM0ZHlWOHhxNXM5b2Z3MkduS2h4VVFjZ09aclYrb3FIbUZHVjdO?=
 =?utf-8?B?dldJUmpjbENYS3BGSnpaRFBCbnVCZzIrMHExenl3UTNYRlJoS1lURHhDb0g0?=
 =?utf-8?B?d3l3TnVobnNUU0lnUTFjMG1QTjQrMTJYQjhFZE5tSXloam4raThFZ2JHTE9D?=
 =?utf-8?B?UDk3dUxhRHE0clVQOFRXTjFsWWNCWFJlV2dJZ0dYY3VGSHVHLzIxRG1RM3hu?=
 =?utf-8?B?S0FnREZ2MUoxMTdUbUd0UT09?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <85AD5CC6EA6DBE478FA48BECA0D8B810@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3448.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c9fbac7-d399-42a1-fdb6-08d925879f58
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jun 2021 05:31:07.3209
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WLqusSM5k+tnAeoVWLbsg1IFOuHX83no8PlKTP4LnnoCQXQVoYSN0zBj7DIjWxpByIzFq322Ih2IQGLrzjnx4Xp/WUF9+GWZmQw7sVUEUUE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2920
X-OriginatorOrg: intel.com

W3N3aXRjaGluZyB0byB0aGUgbmV3IG1haWxpbmcgbGlzdF0NCg0KT24gTW9uLCAyMDIxLTA1LTE3
IGF0IDA4OjE0ICswOTAwLCBRSSBGdWxpIHdyb3RlOg0KPiBGcm9tOiBRSSBGdWxpIDxxaS5mdWxp
QGZ1aml0c3UuY29tPg0KPiANCj4gVGhpcyBwYXRjaCBzZXQgaXMgdG8gcmVuYW1lIG1vbml0b3Iu
Y29uZiB0byBuZGN0bC5jb25mLCBhbmQgbWFrZSBpdCBhDQo+IGdsb2JhbCBuZGN0bCBjb25maWd1
cmF0aW9uIGZpbGUgdGhhdCBhbGwgbmRjdGwgY29tbWFuZHMgY2FuIHJlZmVyIHRvLg0KPiANCj4g
QXMgdGhpcyBwYXRjaCBzZXQgaGFzIGJlZW4gcGVuZGluZyB1bnRpbCBub3csIEkgd291bGQgbGlr
ZSB0byBrbm93IGlmDQo+IGN1cnJlbnQgaWRlYSB3b3JrcyBvciBub3QuIElmIHllcywgSSB3aWxs
IGZpbmlzaCB0aGUgZG9jdW1lbnRzIGFuZCB0ZXN0Lg0KPiANCj4gU2lnbmVkLW9mZi1ieTogUUkg
RnVsaSA8cWkuZnVsaUBmdWppdHN1LmNvbT4NCg0KSGkgUWksDQoNClRoYW5rcyBmb3IgcGlja2lu
ZyB1cCBvbiB0aGlzISBUaGUgYXBwcm9hY2ggZ2VuZXJhbGx5IGxvb2tzIGdvb2QgdG8gbWUsDQpJ
IHRoaW5rIHdlIGNhbiBkZWZpbml0ZWx5IG1vdmUgZm9yd2FyZCB3aXRoIHRoaXMgZGlyZWN0aW9u
Lg0KDQpPbmUgdGhpbmcgdGhhdCBzdGFuZHMgb3V0IGlzIC0gSSBkb24ndCB0aGluayB3ZSBjYW4g
c2ltcGx5IHJlbmFtZSB0aGUNCmV4aXN0aW5nIG1vbml0b3IuY29uZi4gV2UgaGF2ZSB0byBrZWVw
IHN1cHBvcnRpbmcgdGhlICdsZWdhY3knDQptb25pdG9yLmNvbmYgc28gdGhhdCB3ZSBkb24ndCBi
cmVhayBhbnkgZGVwbG95bWVudHMuIEknZCBzdWdnZXN0DQprZWVwaW5nIHRoZSBvbGQgbW9uaXRv
ci5jb25mIGFzIGlzLCBhbmQgY29udGludWluZyB0byBwYXJzZSBpdCBhcyBpcywNCmJ1dCBhbHNv
IGFkZGluZyBhIG5ldyBuZGN0bC5jb25mIGFzIHlvdSBoYXZlIGRvbmUuDQoNCldlIGNhbiBpbmRp
Y2F0ZSB0aGF0ICdtb25pdG9yLmNvbmYnIGlzIGxlZ2FjeSwgYW5kIGFueSBuZXcgZmVhdHVyZXMN
CndpbGwgb25seSBnZXQgYWRkZWQgdG8gdGhlIG5ldyBnbG9iYWwgY29uZmlnIHRvIGVuY291cmFn
ZSBtaWdyYXRpb24gdG8NCnRoZSBuZXcgY29uZmlnLiBQZXJoYXBzIHdlIGNhbiBldmVuIHByb3Zp
ZGUgYSBoZWxwZXIgc2NyaXB0IHRvIG1pZ3JhdGUNCnRoZSBvbGQgY29uZmlnIHRvIG5ldyAtIGJ1
dCBJIHRoaW5rIGl0IG5lZWRzIHRvIGJlIGEgdXNlciB0cmlnZ2VyZWQNCmFjdGlvbi4NCg0KVGhp
cyBpcyB0aW1lbHkgYXMgSSBhbHNvIG5lZWQgdG8gZ28gYWRkIHNvbWUgY29uZmlnIHJlbGF0ZWQN
CmZ1bmN0aW9uYWxpdHkgdG8gZGF4Y3RsLCBhbmQgYmFzaW5nIGl0IG9uIHRoaXMgd291bGQgYmUg
cGVyZmVjdCwgc28gSSdkDQpsb3ZlIHRvIGdldCB0aGlzIHNlcmllcyBtZXJnZWQgaW4gc29vbi4N
Cg0KVGhhbmtzIGFnYWluIQ0KLVZpc2hhbA0KDQo+IA0KPiBRSSBGdWxpICgzKToNCj4gICBuZGN0
bCwgY2NhbjogaW1wb3J0IGNpbmlwYXJzZXINCj4gICBuZGN0bCwgdXRpbDogYWRkIHBhcnNlLWNv
bmZpZ3MgaGVscGVyDQo+ICAgbmRjdGwsIHJlbmFtZSBtb25pdG9yLmNvbmYgdG8gbmRjdGwuY29u
Zg0KPiANCj4gIE1ha2VmaWxlLmFtICAgICAgICAgICAgICAgICAgICAgICAgfCAgIDggKy0NCj4g
IGNjYW4vY2luaXBhcnNlci9jaW5pcGFyc2VyLmMgICAgICAgfCA0ODAgKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysNCj4gIGNjYW4vY2luaXBhcnNlci9jaW5pcGFyc2VyLmggICAgICAgfCAy
NjIgKysrKysrKysrKysrKysrKw0KPiAgY2Nhbi9jaW5pcGFyc2VyL2RpY3Rpb25hcnkuYyAgICAg
ICB8IDI2NiArKysrKysrKysrKysrKysrDQo+ICBjY2FuL2NpbmlwYXJzZXIvZGljdGlvbmFyeS5o
ICAgICAgIHwgMTY2ICsrKysrKysrKysNCj4gIGNvbmZpZ3VyZS5hYyAgICAgICAgICAgICAgICAg
ICAgICAgfCAgIDggKy0NCj4gIG5kY3RsL01ha2VmaWxlLmFtICAgICAgICAgICAgICAgICAgfCAg
IDkgKy0NCj4gIG5kY3RsL21vbml0b3IuYyAgICAgICAgICAgICAgICAgICAgfCAxMjcgKystLS0t
LS0NCj4gIG5kY3RsL3ttb25pdG9yLmNvbmYgPT4gbmRjdGwuY29uZn0gfCAgMTYgKy0NCj4gIHV0
aWwvcGFyc2UtY29uZmlncy5jICAgICAgICAgICAgICAgfCAgNDcgKysrDQo+ICB1dGlsL3BhcnNl
LWNvbmZpZ3MuaCAgICAgICAgICAgICAgIHwgIDI2ICsrDQo+ICAxMSBmaWxlcyBjaGFuZ2VkLCAx
Mjk0IGluc2VydGlvbnMoKyksIDEyMSBkZWxldGlvbnMoLSkNCj4gIGNyZWF0ZSBtb2RlIDEwMDY0
NCBjY2FuL2NpbmlwYXJzZXIvY2luaXBhcnNlci5jDQo+ICBjcmVhdGUgbW9kZSAxMDA2NDQgY2Nh
bi9jaW5pcGFyc2VyL2NpbmlwYXJzZXIuaA0KPiAgY3JlYXRlIG1vZGUgMTAwNjQ0IGNjYW4vY2lu
aXBhcnNlci9kaWN0aW9uYXJ5LmMNCj4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBjY2FuL2NpbmlwYXJz
ZXIvZGljdGlvbmFyeS5oDQo+ICByZW5hbWUgbmRjdGwve21vbml0b3IuY29uZiA9PiBuZGN0bC5j
b25mfSAoODIlKQ0KPiAgY3JlYXRlIG1vZGUgMTAwNjQ0IHV0aWwvcGFyc2UtY29uZmlncy5jDQo+
ICBjcmVhdGUgbW9kZSAxMDA2NDQgdXRpbC9wYXJzZS1jb25maWdzLmgNCj4gDQoNCg==
