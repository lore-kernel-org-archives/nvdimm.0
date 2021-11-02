Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB7D2C80
	for <nvdimm@lists.linux.dev>; Tue,  2 Nov 2021 20:25:24 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10156"; a="317562781"
X-IronPort-AV: E=Sophos;i="5.87,203,1631602800"; 
   d="scan'208";a="317562781"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2021 13:25:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,203,1631602800"; 
   d="scan'208";a="449793640"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga003.jf.intel.com with ESMTP; 02 Nov 2021 13:25:23 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 2 Nov 2021 13:25:23 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 2 Nov 2021 13:25:22 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 2 Nov 2021 13:25:22 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 2 Nov 2021 13:25:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=chqo3JvqF70Ly5TLYQh6IczuQQk2f+28NS1MqMAcMKofFXfCjwyK0BF+8btEKjScLYzELedjjjpzrWp7hufW/CzVQwpiTYIFAULo41axOSOPcoSX5e1fqrQFudTtANCtv4ZRYtDDkJHtj4qswUjrn2FrRWc2swvM2IL/d9gFio6kVUqodQ7xuKq9JlMGwatNMz2ZD5ydQeSdBCqD1FIKAzb7JVOtAHz2OYDytbMy97ndKOYeW+oQsZywZgO5yN6Oyg0Cu0tJvqlZHjoYqbnvYdz2kz1VcXmgIVievf2YcI9OPTn2MXTgN5W5ZUlBfPEqyrMNneVdFw5dvvBlOXXpow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y9GhIJbq0iXN2cI1aZJtryHbpToipASW4yYvFq5fDtk=;
 b=oN8/T2PRl/m/5wKUvJT/iEvquZJCWbH5KitMw6UNzH1O4vjTctIJuVcqvPyzkBAU4C7QMrzDBe3M0SNI4eHwja7qV1vlJ0OzmNbmpytw4yK1S1ZsdFrOwPzGNilGdU58VS/1TCOyyefNe4ioZdcG5JZIzbv6RicGemTo5X6MxGU3Se6vW7MY+C768WRu/s1wXVYK9snBEXbM2evYEZcmcnHIDhbRMcPfA2fGqO7x2rqEnTaRQcGQRXB07hDYMZGhQF7kAR3TE3xeTJgIpHDoCfEwiJ/LuyBYye3+B33JSxHas9Ml8aVLg7wHg4IradBXWHKiYk7khCK1Hm9SnZKSng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y9GhIJbq0iXN2cI1aZJtryHbpToipASW4yYvFq5fDtk=;
 b=gg9sitWXMjQVwZ58OQfTmvdaUXZ0Ah1cUUg90NN3Clei4m0gEWKNOHhp+fkuE5OodFUX4P9Un7jAJ52ChJ2rGamz6rarHqS8k6MccIH9JecNmz11Ho9l4rd4lqxbNic6lWDdKm8Gg9u16XYP/PQ5g0Adh44UrZaTnH6XtF8HJJ8=
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Tue, 2 Nov
 2021 20:25:15 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::d8a5:47b2:8750:11df]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::d8a5:47b2:8750:11df%7]) with mapi id 15.20.4649.019; Tue, 2 Nov 2021
 20:25:15 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "Widawsky, Ben" <ben.widawsky@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH v4 09/17] util/hexdump: Add a util helper to print a
 buffer in hex
Thread-Topic: [ndctl PATCH v4 09/17] util/hexdump: Add a util helper to print
 a buffer in hex
Thread-Index: AQHXu1RoDaRcRksIkUWr7jA69EtRK6vSv+yAgAA+yQCAACNxgIAdtq0A
Date: Tue, 2 Nov 2021 20:25:15 +0000
Message-ID: <944ba9b3c5d972d50b13f54cacdca4d624d6a80f.camel@intel.com>
References: <20211007082139.3088615-1-vishal.l.verma@intel.com>
	 <20211007082139.3088615-10-vishal.l.verma@intel.com>
	 <CAPcyv4gRM_3UxQkKxLg_up-zNecyTjrvG1CAuJyF1Wd+9bwfUA@mail.gmail.com>
	 <39a3f49daff50d8065e95cf4cd5ef4268d3a1c18.camel@intel.com>
	 <CAPcyv4gH02T29-WQeRORgk6nfn250fY8q00x3aNh0c46V4YXEQ@mail.gmail.com>
In-Reply-To: <CAPcyv4gH02T29-WQeRORgk6nfn250fY8q00x3aNh0c46V4YXEQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.40.4 (3.40.4-1.fc34) 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: abc3fec8-718d-4746-6cd4-08d99e3ee18c
x-ms-traffictypediagnostic: MN2PR11MB4063:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <MN2PR11MB4063C83811ABA606B5541D87C78B9@MN2PR11MB4063.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4f6X9vQvicTwLEaTSjkVVOXMyOYdcn9A6e5RqDonH4oXhUYdqfwG/v9JPK0E1EkS1MZTQreUy/DLx874aR9yyjnOj7g4USGVZ4Sz9pypKYOcPtH5OAdZ2nt4ktiXjWXPX+yHjvBsuDgiHii+7uh8vibANpfK5j6XPV71ZMwS7Cq6rxPilaoFpT1iNszSXrlMlkzchJYNgOXLJTnlQUsVw79jk0WE6f9d7f8kW2esJw+8+5v3qs4u6DQ5SmHCLvVTUOozxjZTZGEDosxBx8hOJalmTERrmvcZeCBGRZGhWh53ZfB0zkTY3igrDx95s19qUszBA8YHaya58rOqw6kXVwVdsJSBpqXLCE/nLgr6+X2t7VrXq5ukzrvNRD+ehFhfdxcNtZ32woh4PY59IoSdbMS7DdeloN7c/BD7NWwCygbDGDiOzEMdWQdAB28GwoOH9sE5qb+VFwdPbEONR+r3OLSacHKWdNiBdcIL05d/2IA28gZ3EQ+73MuULOeDggd3Cwh3zdVvmIFG9JgnKiTxnJEqWMFhfZHMLpbWmNC4QY3Tiq0TJ9ShJi0PeIKAVmEFyvg+ksVPNda54aMJlNjABUFZ88QiEM49lYuWp3ydm9Ukalx+aen4+iJwWHwBIfTDhQ3tNde5UAUX7nGDAHzfMlzlkAuqwkFZoTCZRPukztICvqZuxkYxLh8vMqCYftLaV7sn6iATfchM5w+/0YhD/A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66556008)(508600001)(66446008)(6506007)(64756008)(53546011)(8676002)(316002)(6636002)(66476007)(86362001)(6486002)(186003)(4001150100001)(6862004)(54906003)(36756003)(66946007)(83380400001)(38070700005)(38100700002)(82960400001)(2616005)(6512007)(91956017)(71200400001)(5660300002)(4326008)(2906002)(8936002)(122000001)(37006003)(26005)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MUM1OUZaNGtZNXc0T01ZVTJPUEZ3SDRlcytnMjVucFpkSkRMc2Y1Z1FxenVI?=
 =?utf-8?B?a28vLzBrRVF5TFVlN0dPQld3SGNZOWhpQ0VYNWF1UTlrZEQ1bkw1NUNiVjR1?=
 =?utf-8?B?b3RMeUZQZTduaU5IY3dFUFdOeEp4ZjNVb3VhVHlsM0ZTYW1ES09RUFdnNW1J?=
 =?utf-8?B?VHFVaUpXcWZ2ZHZ1aXZGeDNpY1BKZUUyZGVhUWtrQWJqK3JreTVzdFpoTEw1?=
 =?utf-8?B?eTFFMHc4UzZ6MHlJdXhEWW5sbVBITmNka0d0VzR5NVBQOVJqQWd0TStLM0l6?=
 =?utf-8?B?WVQ2MUlJekJ4YklwNjRvdGJISnVjdmVEbkVYVENpNUJlVWppTG85UEFXcVRa?=
 =?utf-8?B?RmhSaXY4c05PdGdxcjUvM3h4Z3FIdzRZYm9IQXJpdG1RK3pnNDcyRE84ZjJL?=
 =?utf-8?B?NnJWVktUUUtpcHV4eTBjM1JVZC9oZEhieWkyMUdIUlpWaEdFRjVzdXJkSDR6?=
 =?utf-8?B?cjhZZnBTbmo5T3hEMnZLVjhqWWVPNlZoZFRhTE9weFJvUks5T3dsbXVpTGNj?=
 =?utf-8?B?ZnVGakR2UktNb2M1LzArUy9lcmhvR3lqVjFndlF2bFlUYzUzRUpML0pxN2Vo?=
 =?utf-8?B?aHkzZEMwNnUra3pxazJtSUtidnB5SmVQbTBCaS96aG51cmZEVWMzc0svOSs5?=
 =?utf-8?B?UTB0QytWWmZZbTJud0xHbml1d3FVVFQ5R3M4S2w1WmtubzFYd3QzdjJFWGpG?=
 =?utf-8?B?U2hPU1B3MFFvMURNeFVYczY4QlJBS2VtaTZFeVdFMDgrcStZajA1TEhabUJh?=
 =?utf-8?B?eVZFRExzVlFvcUEyTkFkK2ZwNGhwY052MjBTSmdXOEJrZURsc3F5TDh4ZHU3?=
 =?utf-8?B?c2g3cDF6OGI4MmloYTZadC9zVEZJUGdIL09Za3N4S0xrejNGSkM1UTRTdXFv?=
 =?utf-8?B?TFI3VGREZUJKMXBweXhkREtRRzh2UFQ1N3FwVHQwdWYyVjVYbzZ1cENTTS9K?=
 =?utf-8?B?VWt6d1NMTjJIbzRMZVROcnVlT0k3M1h4ZFNhNGZrRTF4Z0pkb1k0Q1ZSQkVn?=
 =?utf-8?B?dEVoSjE3STBDL1VoTnpGcGJVcHlKd1FCQlp6QTF3dEh6VlhxclYzZFNUd3VQ?=
 =?utf-8?B?WDdiTkVSRVJzQzRWSjFKVGFTNmE1M2hreVpQY2dOZzgvYlNkVTlUZjR4Qlkx?=
 =?utf-8?B?NjdHVk1EUkZsQXVheDExYUhXVTlWdU9DaHI5THNBQzhtS1hLMEZzVlpqYnJN?=
 =?utf-8?B?U29GVXVEVDB4bXp6RFJ0ZjkzVUZGTlNaMkI1emRmSUFPbUdqM1F4aEs5cFpF?=
 =?utf-8?B?YTYxSVdDYVlWS0hqYXFRNS9BYWVDVktXWi9adjJwUFl1SkprMVdkQXhRbDV6?=
 =?utf-8?B?dFZLZUZ3Z0xNN3VIUGFVdlNMQktSVXAzYTdub1k5OXRTc2VkczdvUDdjUWkr?=
 =?utf-8?B?cnZaV2JFa2dtbEVSRFZFKzhaTHlwZjFjQ0FRV2RlQXliSjlpd1kwZWZTUWxL?=
 =?utf-8?B?a1BzWmVXTDFrSHg4ODBtMitRNi9ubE9FMk52a2NYZlorYnNVNDZoSGlZK0JI?=
 =?utf-8?B?cTBSRU85Szg3MUdsc2pNcytmaThZRjhvVjJkdmJTTWI1eHJhcGRGaU4zbVcr?=
 =?utf-8?B?UkdVN0VteUhaWnY2VXpkYk5OOHFQbFZFRmJ0azlzZEhmeWZFZ3JVK28yVEx1?=
 =?utf-8?B?c0I2d3cxQW91Q0ZLbWNFSU5MckRraFllL0pwaUVQSnJqd2Q5ZXhQTTY4SGpO?=
 =?utf-8?B?LytrZk5JOXFBWG9Wdm1JTW05N0lDQ0xZaERpeFRDeFVWRUVFeVRIMHBjOHNR?=
 =?utf-8?B?UGlaUXBzYXo1YW1pbjNIMEN0NTQ3TWRLMUJTaVMxNUZnM2s4S0VyN3lWTjBS?=
 =?utf-8?B?L3JtNVFEK1F6bGxDTkhEdEpJM2t0c1drN0IxNnVsSWU3UjA3L01COHEvbDdw?=
 =?utf-8?B?NWo3bWlEd0pqN1hUQ1lSc3lqdVpQOVdMaEdBUXZvMkRJMXdSTk1OTlUyUWs5?=
 =?utf-8?B?MWxiOGpybDVhWHpLbmFTNUdIanp5RWp3UE5TN3ByMjZrMk9XS3huYlVvR1FL?=
 =?utf-8?B?cjlEc2VENC9MNzNEcjlBdjg0K0hjWjVSVDlQMFR2Y2VURWZnNE9BUVNSSVZK?=
 =?utf-8?B?cWVvYWZpVUxQQkVRa0tTUkM4bFlkTEh1aWVrUjhWaSt4cnM5dHFIVWk5WG96?=
 =?utf-8?B?ZDBFMDRwZk1VQ043RXMvUFJrN1RGeUFsMWJIcnlNR0lnWXJrZTRFVTlGR0Nm?=
 =?utf-8?B?Q2Z4QUU4cGhuSm10bFBtdDB3U05GRU1odUx3Z0V5c2MwZVNlTmlWM3pjMVB4?=
 =?utf-8?Q?2xTFkEcFHlOj1hiAJVbB1j/kxZIJtn4NX6Ho/cHBzE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <65D8BECD2A0643408A46111B1C48C863@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abc3fec8-718d-4746-6cd4-08d99e3ee18c
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2021 20:25:15.7584
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8nEC/njH2GANB66ajI6sl3TfAdol9jaSGFgtyTgJdCPLlPrj4pdHHptfMGFj+Xl2TYPLo75sdxuNAMhi3LNXhdXuigjaQUFhrCvke3VLeSs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4063
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDIxLTEwLTE0IGF0IDE1OjM5IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIFRodSwgT2N0IDE0LCAyMDIxIGF0IDE6MzMgUE0gVmVybWEsIFZpc2hhbCBMDQo+IDx2aXNo
YWwubC52ZXJtYUBpbnRlbC5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IE9uIFRodSwgMjAyMS0xMC0x
NCBhdCAwOTo0OCAtMDcwMCwgRGFuIFdpbGxpYW1zIHdyb3RlOg0KPiA+ID4gT24gVGh1LCBPY3Qg
NywgMjAyMSBhdCAxOjIyIEFNIFZpc2hhbCBWZXJtYSA8dmlzaGFsLmwudmVybWFAaW50ZWwuY29t
PiB3cm90ZToNCj4gPiA+ID4gDQo+ID4gPiA+IEluIHByZXBhcmF0aW9uIGZvciB0ZXN0cyB0aGF0
IG1heSBuZWVkIHRvIHNldCwgcmV0cmlldmUsIGFuZCBkaXNwbGF5DQo+ID4gPiA+IG9wYXF1ZSBk
YXRhLCBhZGQgYSBoZXhkdW1wIGZ1bmN0aW9uIGluIHV0aWwvDQo+ID4gPiA+IA0KPiA+ID4gPiBD
YzogQmVuIFdpZGF3c2t5IDxiZW4ud2lkYXdza3lAaW50ZWwuY29tPg0KPiA+ID4gPiBDYzogRGFu
IFdpbGxpYW1zIDxkYW4uai53aWxsaWFtc0BpbnRlbC5jb20+DQo+ID4gPiA+IFNpZ25lZC1vZmYt
Ynk6IFZpc2hhbCBWZXJtYSA8dmlzaGFsLmwudmVybWFAaW50ZWwuY29tPg0KPiA+ID4gPiAtLS0N
Cj4gPiA+ID4gIHV0aWwvaGV4ZHVtcC5oIHwgIDggKysrKysrKysNCj4gPiA+ID4gIHV0aWwvaGV4
ZHVtcC5jIHwgNTMgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysNCj4gPiA+IA0KPiA+ID4gSWYgdGhpcyBpcyBqdXN0IGZvciB0ZXN0cyBzaG91bGRuJ3Qg
aXQgZ28gaW4gdGVzdHMvIHdpdGggdGhlIG90aGVyDQo+ID4gPiBjb21tb24gdGVzdCBoZWxwZXJz
PyBJZiBpdCBzdGF5cyBpbiB1dGlsLyBJIHdvdWxkIGtpbmQgb2YgZXhwZWN0IGl0IHRvDQo+ID4g
PiB1c2UgdGhlIGxvZyBpbmZyYXN0cnVjdHVyZSwgbm8/DQo+ID4gDQo+ID4gQWdyZWVkIG9uIHVz
aW5nIHRoZSBsb2cgaW5mcmEuIEkgd2FzIG9yaWdpbmFsbHkgdXNpbmcgaXQgaW4gdGhlIG9sZA0K
PiA+IHRlc3Qgc3R1ZmYsIGJ1dCByaWdodCBub3cgdGhlcmUncyBubyB1c2VyIGZvciBpdC4uIEhv
d2V2ZXIgaGF2aW5nDQo+ID4gc29tZXRoaW5nIGxpa2UgdGhpcyB3YXMgbmljZSB3aGVuIGRldmVs
b3BpbmcgdGhlIGVhcmx5IGNtZCBzdWJtaXNzaW9uDQo+ID4gc3R1ZmYuIERvIHlvdSB0aGluayBp
dCB3b3VsZCBiZSBnb29kIHRvIGFsd2F5cyBkbyBhIGhleGR1bXAgd2l0aCBkYmcoKQ0KPiA+IHdo
ZW4gdW5kZXIgLS12ZXJib3NlIGZvciBldmVydCBjeGxfY21kX3N1Ym1pdD8gKGFuZCBtYXliZSBl
dmVuIGFkZCBpdA0KPiA+IGZvciBuZGN0bF9jbWRfc3VibWl0IGxhdGVyIHRvbykgT3IgaXMgdGhh
dCB0b28gbm9pc3k/DQo+IA0KPiBJdCBzb3VuZHMgZ29vZCBhcyBhbiBleHRyYS12ZXJib3NlIGRl
YnVnIG9wdGlvbi4gQXQgbGVhc3QgaXQgd291bGQgYmUNCj4gbW9yZSBwZXJzb25hbCBwcmVmZXJl
bmNlIHRoYXQgLXYgZG9lcyBub3QgZ2V0IGFueSBtb3JlIG5vaXN5IGJ5DQo+IGRlZmF1bHQgYW5k
IHJlcXVpcmUgLXZ2IHRvIGdldCBoZXhkdW1wcy4NCj4gDQo+ID4gSWYgd2Ugd2FudCB0byBkbyB0
aGF0IHRoZW4gaXQgbWFrZXMgc2Vuc2UgdG8gcmVkbyB3aXRoIHRoZSBsb2dnaW5nIGFwaSwNCj4g
PiBlbHNlIG1heWJlIGpzdXQgZHJvcCB0aGlzIHVudGlsIHdlIGhhdmUgYSByZWFsIGluLXRyZWUg
dXNlcj8NCj4gDQo+IFRoYXQncyBhbHdheXMgb2sgaW4gbXkgYm9vay4NCj4gDQpJJ2xsIGRyb3Ag
aXQgZm9yIG5vdy4gSWYgd2UgZXZlciBuZWVkIGl0LCBsb3JlIGhhcyBpdCBhcmNoaXZlZCBmb3Jl
dmVyDQo6KQ0K
