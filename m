Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64EEB70
	for <nvdimm@lists.linux.dev>; Wed,  2 Jun 2021 17:15:55 +0000 (UTC)
IronPort-SDR: 3Uei7kCdtIzXC/QztUzGu4tHtJGGjcHQzC/esxKS8p8MA9htDxyhRSfDsfQbehDtocsUDC1YZs
 gl9IO8E0i1kA==
X-IronPort-AV: E=McAfee;i="6200,9189,10003"; a="203873956"
X-IronPort-AV: E=Sophos;i="5.83,242,1616482800"; 
   d="scan'208";a="203873956"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2021 10:15:51 -0700
IronPort-SDR: zaKl29Hg5SEmRth3cBLjw14rw1CzKosvIqyp0yrpmn9EpWnjbxxCZeArUAa+oJ6FfSLWqPKBXo
 xKX7aL4FE2XA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,242,1616482800"; 
   d="scan'208";a="483122527"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 02 Jun 2021 10:15:48 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 2 Jun 2021 10:15:46 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 2 Jun 2021 10:15:46 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Wed, 2 Jun 2021 10:15:46 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Wed, 2 Jun 2021 10:15:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P2o4ZGzRlbJ4Xe4sr2fdIdFyHBN1clzl1XH7y4U6sKnPoJVxuUAlBf7j7BkDUDNUP0S0NrFYs8xHsmvL118J1e6USCfwbB61B/AVwGOMsOLO+q8e0+RENynV3uHPibW1p3Mplxrb2y9hRpsNQ20pIM4Fx3aRAYkcIAZwfofArpE66+cT0TzUdexVhzNjI6sONk9ueX79iN0TPs6z0fZ8/JFpvNkrty0SRTD3gsqy3zHnxbzQWKGylWqoD2A2h256KTWqb3o3I7bDaB+QeZT/fKcnnxeiFZLboG778UpW9RXnooV+mr7yMCdS1AzVloyNIqkTjCBkkgJTPx+IKo0D8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j2pG20da9iGewJWT+OWbFyWm9z1mpgvB/6wL6XFQJUQ=;
 b=mplhgxSfz6izxjg0aTBwauTCERLkSjr4rIw2ga/F3O/0WHupJtNC+XS+8bWKUTRaVuEcq37E2g9tHT3aIFY9JblOy3Ou/ldJMdwZYpS6tgje1A7RSLoDET/I85VHe31m8FdrDjUda1Dz6eHe4wJoGDyM6VKEXmAJ1BngU8DRdOMZ5PWNY/LbRq2/Cpehmg245MeIp2kFBsLpVRhtroj2Po6Bk5loHk/SS5JNEAMur9VHV5amvl+cxAhbgqfbKhPMN0IX4M4dXQ1aYfN5O+6khjM63nXJDse6r4Y6YRAiDH1/bLsVb+6Y+7939fHln8Izk7CobGBnCaZydGD82Lblwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j2pG20da9iGewJWT+OWbFyWm9z1mpgvB/6wL6XFQJUQ=;
 b=stEJlSp9Tpct4sDvOs2N/zlkvWF5bPxx8c69VVmVOkymv/0z2Q6TH1beupJFIkiyWf9MVq1csVJ1yOLypI1dxuKueWtgptybVlINXECk0/Z6FqfBm2P2gMkfJTiQ49Hv2P4h5rLM8Tuc3kjyWIe/X1vy1cndMAn+nxE3eNUlN8E=
Received: from BYAPR11MB3448.namprd11.prod.outlook.com (2603:10b6:a03:76::21)
 by BY5PR11MB4401.namprd11.prod.outlook.com (2603:10b6:a03:1be::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21; Wed, 2 Jun
 2021 17:15:44 +0000
Received: from BYAPR11MB3448.namprd11.prod.outlook.com
 ([fe80::713c:a1f6:aae4:19fc]) by BYAPR11MB3448.namprd11.prod.outlook.com
 ([fe80::713c:a1f6:aae4:19fc%5]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 17:15:44 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "fukuri.sai@gmail.com" <fukuri.sai@gmail.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>, "qi.fuli@fujitsu.com" <qi.fuli@fujitsu.com>
Subject: Re: [RFC ndctl PATCH 0/3] Rename monitor.conf to ndctl.conf as a
 ndctl global config file
Thread-Topic: [RFC ndctl PATCH 0/3] Rename monitor.conf to ndctl.conf as a
 ndctl global config file
Thread-Index: AQHXSqlKyo+afcskpkCQhHQX0SuPA6sAS6UAgAC82ACAAAgGgA==
Date: Wed, 2 Jun 2021 17:15:44 +0000
Message-ID: <98516fb56623180b78bce2a6a15103023a59b884.camel@intel.com>
References: <20210516231427.64162-1-qi.fuli@fujitsu.com>
	 <0e2b6f25a3ba8d20604f8c3aa4d8854ade0835c4.camel@intel.com>
	 <CAPcyv4inknvApE1xZOiK8u2xPLejuqixf_XKbS05fPKvno+Yyg@mail.gmail.com>
In-Reply-To: <CAPcyv4inknvApE1xZOiK8u2xPLejuqixf_XKbS05fPKvno+Yyg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.40.1 (3.40.1-1.fc34) 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.139.74]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3c72a123-171d-4a7e-4bd7-08d925ea0e55
x-ms-traffictypediagnostic: BY5PR11MB4401:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR11MB440139559ECF0FB118C3E2F3C73D9@BY5PR11MB4401.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ATrT5QU1UsTtNrJ08AP7IvcTO17FNSw0oDX+wYTDz1Mxr0bRfgSiZ2mTd1o6FeEMLJgmXzbrkgeiuEeAapF+HIQZZjxdoEy3UVrcqe/kM6y8NycY3L4bRDNWMIZ3pEwkTzfj6976/Epw58eoLsNfxHU49u/qUWALlbecmj1/D9vTrhPOa1gwTFa3j6NOYpBRzD7nxjg+2lnxoq2aN6Yw97CN8sNP1Yt0jwefA6KXGWFPQoVTAE0zDGckedRM+7reus8vaMfHWiLQxek6FjTcsYB6GTnEgySde4f2Id86SdNoXDM5lRYPAKXNmb7OIQDXCnt8cSG3mOmqUPkW+tqrc9Vu0Dn+ZaercLgX6qTBzlBixwF06UjmBVjfjDccowOyRIMmmwyJK5n6PqkU/aA7vRtn7gcQpnjDWHCuX/NTJ+eR3sm8DfbgTjneOlgOhLtoqIOcvwYq3C0lH7xz4kqdwp9tSZlJbOkNO7PtmV1f+5SWlVF9LNA+OKw4w5CjEHG60TvulamqOp3bb+mfuQEJB/pre2zKLaVUAAyoXT1wWwi44Mdby8TxeJ30o0dZSGJrVTOwrxbo0nXTGN2p8URJ9OttOm4qfH7p/asUnDIfg4k=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3448.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(366004)(136003)(396003)(346002)(186003)(6506007)(53546011)(2906002)(2616005)(26005)(478600001)(76116006)(66476007)(66556008)(66446008)(316002)(83380400001)(66946007)(64756008)(37006003)(54906003)(6486002)(122000001)(4326008)(71200400001)(5660300002)(36756003)(6636002)(8676002)(8936002)(86362001)(6512007)(38100700002)(6862004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?RCtNSWM5T2FVUVR2NlN3OCtiaGk3TUlPeGlMb3BXRlp5MVh2a1VZM0prVEY5?=
 =?utf-8?B?YWRwRSt3VjF6c0hnU2pkbXVMV013UzNyNW44WERyQTZDdlRMVm53MHdSOFg0?=
 =?utf-8?B?VWhOVGZ5WWo4eWZJK1djelVSR0J1M3pmMFI4Q3VSK0N4bCtmTHAySkxEQlZM?=
 =?utf-8?B?Y0ZQNjdVSFVmVXVtMTNHa1ZTN1liR3ZpNm85bVY4TTVkZEFWRHozbjRybnFX?=
 =?utf-8?B?SytIMjJXZ3ErTlpjaHp3NG1VcmpBTjRWcXVpaGNVYXBORENGYjRvbUtFWVN0?=
 =?utf-8?B?bWp5QXJmUjFKQkxsZ1hWZ2JkNFRidDYrSm1NUjJRR0R3UDk2bm5YUlY5aFhF?=
 =?utf-8?B?T1c5RHJxR0hhNlNDL2dSS1JRSVlMR3hWUlpncXdNT0lGQVhHcUtpQkI2OFZB?=
 =?utf-8?B?bWdVMTUvU29iZytDV3hmNDVOZmNFdFAzOG5mS0FHY1JlRUNrUTgveHA1STQ4?=
 =?utf-8?B?dGh0eDJQTG5GUVV5SUdBRjVhR2llazBxRENET3J3TlNCbFNRWElJa0xLaTFM?=
 =?utf-8?B?ZEdyRXN2MWE4SXJQb1Npd1kvcnY5NDdtd1RtUTVGbWluNUxzeWRjcW53SjJJ?=
 =?utf-8?B?dmo1OWl5d2pWazh4RTFIZ1N6RWtMaVh2UHl6NVF6YUUxbGZka2FQMmlETGwr?=
 =?utf-8?B?UE9pZmFkOVk4SHN5bG9lWkhzVzRRM1BFcExoQmV4SGpUVW9xeFA1ZnovcUJH?=
 =?utf-8?B?VVpsMzZqa0V6Y1JUbFgzZ0xrUFZxc3J4TXVLcTlndlI4elIvMUVhUFVpZVlw?=
 =?utf-8?B?VlNSWXg5UExObURHcXc1VktWZElLRXRwNSs4RDFZaGR3UjFLaThrcVVCWlhI?=
 =?utf-8?B?dTdPSEI3bGoxYitzWHVSZmNSN09oNGphWndlS1JFMnZzdStTcnJDR0pUcnJl?=
 =?utf-8?B?d1FyK0FZU0o2NUo1RmtGTHBYTHVldEYzbEZoaWsxdE5MQ1FlZ2tEbEpOeHJm?=
 =?utf-8?B?UHBpWXFnd2wrdUhHcXdoMGhMcUdHdW9FeGFSTG5LMFIyd2w3aVA1RVU4aDRl?=
 =?utf-8?B?OHpMZmdhWi84RmlOMjBOWmF2YkNKT3pvNVczNWdPUExzendZeTBzZ2hNWUlM?=
 =?utf-8?B?bGVCYTNib0pyT096cjhnQ1N4ZTBmdXRySE9xcGFFd1pPamZjVlJVanQxY3hY?=
 =?utf-8?B?eUhOODhrME9YRGZWSS8vQ3BZcXZQV1RhdlhKYlgwRHBYMWhlWlduTDVFMktW?=
 =?utf-8?B?OVNRellJYXRCZlJ6V1ZIN3lwYUJIMHVNYXlzcVdiVnFoZ2h0Y1Z5bVdGRmly?=
 =?utf-8?B?VGFZL3pwL0F0VWNaQ0k0aUhKY241c0lRbkdiRjFQSzk4TitJSFNUTDRLc0Q4?=
 =?utf-8?B?SG1xNFhsWjFENnZXNUYvaS9qL0xqMTk1VnZXTkFJWURwRUx0eEFHOWp3WGFS?=
 =?utf-8?B?anNRVnh6VmFmaEZhRk5vMWx5Vmp2bGMrMmFDQ0hoZUF6bXFjSHV2S2hMcGxL?=
 =?utf-8?B?NXliMWRoY1U3QTFYMi9GV01Sa2Z6amRCeEVqbDVaa28rSUdVMS93TjF1Sy9P?=
 =?utf-8?B?UWFOMVZ3TGNLdkxaWmR3SzB1SkdWTEJpdzY4RGxsTzZKV2hKNnhOWHE0SVBQ?=
 =?utf-8?B?Rk9hcGRMb0p2OFFUYlg4M00vQy9zWmhybkVvMzZodlhhRjdFNE9FUHA5ZmVF?=
 =?utf-8?B?VENqNVFqMjZyeERUc0pCSTNMYng1dlorRE1tN3llOGE3dlRGUWhqdXRhaDhO?=
 =?utf-8?B?WFQ0TmJ5TndISzhKUW5EQTFTOWZtZGt1NmpuRDEvK29oV3dkOTFVdWxkb0FT?=
 =?utf-8?B?ejdtWTd2bW1XZFVPVy9XSVVNbWp0ekd1RVZ4RzR3MmsyWFF6L2p4OUR3M0JM?=
 =?utf-8?B?RXloczVoM1AzMWR0VklOdz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <269DA21B18CA5541B90F098C541DAA66@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3448.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c72a123-171d-4a7e-4bd7-08d925ea0e55
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jun 2021 17:15:44.1149
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5kIV8JMUpmxCRBKEV/acCq7W9Q2tv3u9lQ9AmZsM8Zuy1jZi6RX9P2Y4A3V5upBY3awEQBZ1+SPfOEdaLGwJxEVGpNTRocD5l9AOlgGJq4Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4401
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDIxLTA2LTAyIGF0IDA5OjQ3IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIFR1ZSwgSnVuIDEsIDIwMjEgYXQgMTA6MzEgUE0gVmVybWEsIFZpc2hhbCBMDQo+IDx2aXNo
YWwubC52ZXJtYUBpbnRlbC5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IFtzd2l0Y2hpbmcgdG8gdGhl
IG5ldyBtYWlsaW5nIGxpc3RdDQo+ID4gDQo+ID4gT24gTW9uLCAyMDIxLTA1LTE3IGF0IDA4OjE0
ICswOTAwLCBRSSBGdWxpIHdyb3RlOg0KPiA+ID4gRnJvbTogUUkgRnVsaSA8cWkuZnVsaUBmdWpp
dHN1LmNvbT4NCj4gPiA+IA0KPiA+ID4gVGhpcyBwYXRjaCBzZXQgaXMgdG8gcmVuYW1lIG1vbml0
b3IuY29uZiB0byBuZGN0bC5jb25mLCBhbmQgbWFrZSBpdCBhDQo+ID4gPiBnbG9iYWwgbmRjdGwg
Y29uZmlndXJhdGlvbiBmaWxlIHRoYXQgYWxsIG5kY3RsIGNvbW1hbmRzIGNhbiByZWZlciB0by4N
Cj4gPiA+IA0KPiA+ID4gQXMgdGhpcyBwYXRjaCBzZXQgaGFzIGJlZW4gcGVuZGluZyB1bnRpbCBu
b3csIEkgd291bGQgbGlrZSB0byBrbm93IGlmDQo+ID4gPiBjdXJyZW50IGlkZWEgd29ya3Mgb3Ig
bm90LiBJZiB5ZXMsIEkgd2lsbCBmaW5pc2ggdGhlIGRvY3VtZW50cyBhbmQgdGVzdC4NCj4gPiA+
IA0KPiA+ID4gU2lnbmVkLW9mZi1ieTogUUkgRnVsaSA8cWkuZnVsaUBmdWppdHN1LmNvbT4NCj4g
PiANCj4gPiBIaSBRaSwNCj4gPiANCj4gPiBUaGFua3MgZm9yIHBpY2tpbmcgdXAgb24gdGhpcyEg
VGhlIGFwcHJvYWNoIGdlbmVyYWxseSBsb29rcyBnb29kIHRvIG1lLA0KPiA+IEkgdGhpbmsgd2Ug
Y2FuIGRlZmluaXRlbHkgbW92ZSBmb3J3YXJkIHdpdGggdGhpcyBkaXJlY3Rpb24uDQo+ID4gDQo+
ID4gT25lIHRoaW5nIHRoYXQgc3RhbmRzIG91dCBpcyAtIEkgZG9uJ3QgdGhpbmsgd2UgY2FuIHNp
bXBseSByZW5hbWUgdGhlDQo+ID4gZXhpc3RpbmcgbW9uaXRvci5jb25mLiBXZSBoYXZlIHRvIGtl
ZXAgc3VwcG9ydGluZyB0aGUgJ2xlZ2FjeScNCj4gPiBtb25pdG9yLmNvbmYgc28gdGhhdCB3ZSBk
b24ndCBicmVhayBhbnkgZGVwbG95bWVudHMuIEknZCBzdWdnZXN0DQo+ID4ga2VlcGluZyB0aGUg
b2xkIG1vbml0b3IuY29uZiBhcyBpcywgYW5kIGNvbnRpbnVpbmcgdG8gcGFyc2UgaXQgYXMgaXMs
DQo+ID4gYnV0IGFsc28gYWRkaW5nIGEgbmV3IG5kY3RsLmNvbmYgYXMgeW91IGhhdmUgZG9uZS4N
Cj4gPiANCj4gPiBXZSBjYW4gaW5kaWNhdGUgdGhhdCAnbW9uaXRvci5jb25mJyBpcyBsZWdhY3ks
IGFuZCBhbnkgbmV3IGZlYXR1cmVzDQo+ID4gd2lsbCBvbmx5IGdldCBhZGRlZCB0byB0aGUgbmV3
IGdsb2JhbCBjb25maWcgdG8gZW5jb3VyYWdlIG1pZ3JhdGlvbiB0bw0KPiA+IHRoZSBuZXcgY29u
ZmlnLiBQZXJoYXBzIHdlIGNhbiBldmVuIHByb3ZpZGUgYSBoZWxwZXIgc2NyaXB0IHRvIG1pZ3Jh
dGUNCj4gPiB0aGUgb2xkIGNvbmZpZyB0byBuZXcgLSBidXQgSSB0aGluayBpdCBuZWVkcyB0byBi
ZSBhIHVzZXIgdHJpZ2dlcmVkDQo+ID4gYWN0aW9uLg0KPiA+IA0KPiA+IFRoaXMgaXMgdGltZWx5
IGFzIEkgYWxzbyBuZWVkIHRvIGdvIGFkZCBzb21lIGNvbmZpZyByZWxhdGVkDQo+ID4gZnVuY3Rp
b25hbGl0eSB0byBkYXhjdGwsIGFuZCBiYXNpbmcgaXQgb24gdGhpcyB3b3VsZCBiZSBwZXJmZWN0
LCBzbyBJJ2QNCj4gPiBsb3ZlIHRvIGdldCB0aGlzIHNlcmllcyBtZXJnZWQgaW4gc29vbi4NCj4g
DQo+IEkgd29uZGVyIGlmIG5kY3RsIHNob3VsZCB0cmVhdCAvZXRjL25kY3RsIGxpa2UgYSBjb25m
LmQgZGlyZWN0b3J5IG9mDQo+IHdoaWNoIGFsbCBmaWxlcyB3aXRoIHRoZSAuY29uZiBzdWZmaXgg
YXJlIGNvbmNhdGVuYXRlZCBpbnRvIG9uZQ0KPiBjb21iaW5lZCBjb25maWd1cmF0aW9uIGZpbGUu
IEkuZS4gc29tZXRoaW5nIHRoYXQgbWFpbnRhaW5zIGxlZ2FjeSwgYnV0DQo+IGFsc28gYWxsb3dz
IGZvciBjb25maWcgZnJhZ21lbnRzIHRvIGJlIGRlcGxveWVkIGluZGl2aWR1YWxseS4NCg0KQWdy
ZWVkLCB0aGlzIHdvdWxkIGJlIHRoZSBtb3N0IGZsZXhpYmxlLiBjaW5pcGFyc2VyIGRvZXNuJ3Qg
c2VlbSB0bw0Kc3VwcG9ydCBtdWx0aXBsZSBmaWxlcyBkaXJlY3RseSwgYnV0IHBlcmhhcHMgbmRj
dGwgY2FuLCBlYXJseSBvbiwgbG9hZA0KdXAgbXVsdGlwbGUgZmlsZXMvZGljdGlvbmFyaWVzLCBh
bmQgc3Rhc2ggdGhlbSBpbiBuZGN0bF9jdHguIFRoZW4gdGhlcmUNCmNhbiBiZSBhY2Nlc3NvciBm
dW5jdGlvbnMgdG8gcmV0cmlldmUgc3BlY2lmaWMgY29uZiBzdHJpbmdzIGZyb20gdGhhdA0KYXMg
bmVlZGVkIGJ5IGRpZmZlcmVudCBjb21tYW5kcy4NCg0K
