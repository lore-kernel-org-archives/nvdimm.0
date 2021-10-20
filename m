Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D5129CA
	for <nvdimm@lists.linux.dev>; Wed, 20 Oct 2021 15:01:31 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10143"; a="315003676"
X-IronPort-AV: E=Sophos;i="5.87,167,1631602800"; 
   d="scan'208";a="315003676"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2021 08:01:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,167,1631602800"; 
   d="scan'208";a="720445813"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga005.fm.intel.com with ESMTP; 20 Oct 2021 08:01:18 -0700
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 20 Oct 2021 08:01:17 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 20 Oct 2021 08:01:17 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 20 Oct 2021 08:01:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LSJh6/ActCAF9DImmfV7WQ/bXe9WemHpZxxQgKFtK9AU26321MjmG5VE0ma8Xq3auQGq36u/WsTi1rTA/52KV6eg4iSo30EkchCDwLP1r8dzeRk3AOwFKkkYmktqhD3B+Zz1kjvhICVbVmc7coQInMMLSJrEgR+LS7s932elXD4oNml8gjTSWWFhqEuxGxeItK3X7VKCeaDCJL8ESB+Epb7plHJjFVOC9kQQgeOXVMvSV7SCIDPuyo5YKlux6mlO4EX+ZEliL767Z97fmKvsQdIOEZ2cdHUmoAJGJTtjuGjkMA4tg6P1jiYj0xKdWMIDocflyMBJu/3vDsp4W/8fTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cfjcBRVm/t1oiuZ9d9PY+XJ0Koo12xOyDye5Nt4swrc=;
 b=Rs6Rv9WBjRVoIw5eYyl/CqEdbeAhxyOF1AKZULG7Q1Ui0isP+KB4SbiYnHAWZ5mROWO/bKFWwFVedNJ2umlQV2ptJ3UYYG8EQCHbP9HeO7yd/6JWJntsfNzLkBJr9sGCKbTAmbZ2yHLTMNXLyKue6x7ZnGnSkwQEPX8ha/yh19Q53FwDAOx6z9JVnOSPEeDQGHsD1D1K633CkL4F6/s4J6p1MSXhhahRchrpnbbQnFGTvJOgldOmbBVzQIg5G6VDODbpe3mSSb12BOdnvBKOpYLT/QhrYq9h3qPp9PqsSA2K3tXkfwRh9PyOp+7M7K3nLH92sty3Y6lni/5h/KS4Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cfjcBRVm/t1oiuZ9d9PY+XJ0Koo12xOyDye5Nt4swrc=;
 b=EeaFKj1kGR5KXQtv8mWfU8Aaa1pfATJ6D9bidcDyDS+Q//YP8hvewZAEVOf3vesBkAfC3CHJN787r9JVrey3WmrcOWvHTVhwwYePzkWFWb5G8CPXwhCjU4tA53shppKwsqXj7cLKc/Sv2BJDLeQE4ZBjB+b9DJVGS/xFIprOzeY=
Received: from BY5PR11MB3989.namprd11.prod.outlook.com (2603:10b6:a03:191::17)
 by BYAPR11MB2982.namprd11.prod.outlook.com (2603:10b6:a03:84::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Wed, 20 Oct
 2021 15:01:15 +0000
Received: from BY5PR11MB3989.namprd11.prod.outlook.com
 ([fe80::d836:5d55:87d6:15d6]) by BY5PR11MB3989.namprd11.prod.outlook.com
 ([fe80::d836:5d55:87d6:15d6%4]) with mapi id 15.20.4628.016; Wed, 20 Oct 2021
 15:01:15 +0000
From: "Scargall, Steve" <steve.scargall@intel.com>
To: Adam Borowski <kilobyte@angband.pl>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: RE: ndctl hangs with big memmap=! fakepmem
Thread-Topic: ndctl hangs with big memmap=! fakepmem
Thread-Index: AQHXxbo4tL8MWRXM5Eq2Vs0S7JIoKqvb6zAAgAAPXcA=
Date: Wed, 20 Oct 2021 15:01:15 +0000
Message-ID: <BY5PR11MB3989976BB2AE9F2B31E55B1695BE9@BY5PR11MB3989.namprd11.prod.outlook.com>
References: <YXAYPK/oZNAXBs0R@angband.pl> <YXAhzF9qQsTPDfWU@angband.pl>
In-Reply-To: <YXAhzF9qQsTPDfWU@angband.pl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
dlp-product: dlpe-windows
dlp-version: 11.6.200.16
dlp-reaction: no-action
authentication-results: angband.pl; dkim=none (message not signed)
 header.d=none;angband.pl; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: daefbda8-fab7-4ea7-ef47-08d993da770b
x-ms-traffictypediagnostic: BYAPR11MB2982:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB2982FADFA0EFE9D85DE3CC5D95BE9@BYAPR11MB2982.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1201;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DMisNZ//8MjWybpkdVxE8TwoAwGn1w4tArw+T9xK3uFCJsx/1x5o6agDq1/RpCJUxEmmFwDss2tr7Zrg1blw1s+yhrqxDxTYlxlZ3IXQahBqvXqDmT0iuaCok8Coe8uK/cmJ/9Bc28NbcdZnrbOtfR0mruxeAP5sLudCW0UxXU2k6a5ZY+uuHmQa9L/327hwDIX7v94Rw9avvLb9wfohgQJRt1ROex5FmmcdSLvlDcjEVp0fP6o77rj6bI73IswVrDNZJ6Erxo8n2H2IofDPCijsBba1UBUlCIS7Eo6dW3sgmRQfu+c1ypM9Totl068w6Q4gUnqs5N4040bUW2XHecTgs2BOXQzSS543QSDqR/3TA0LfJyM4xpzRiyNTQ5WN3/O/+PXTsSIPdf3V9JfKpAEmVacqMfQLM2bF6htOVapCj5cZle78VFoO+WC3qF7+ULH2yLZyUZY4E0jR6ixHG9xNuyFMTleli9XlFVYWly/LC8NNznveQbbsjAgMeaQ3kjKFNAy36/CT6ceJzIW6TagwDDnIbulDSx/bPC2FHFYrCZ8n89n3uRClH+UcyUldG0plmW82I1vLH9BouTgGtEj91/IMnEOy/WhJHhftKVFNBh7tZSmjDJj6GLJ+GyhsuwFW0P08KlF1K9qYTUf4WuDmoak2khZDzdSUYjL6R64Nf7JvIBF6xc2V9Wvax/EDfpM7jJyQfPLxD/d80T8sXIrdPABfBrItX0eXwtNmjG5++mdGbg1l3BlSDT2tEXVV1gwuUxQe2ReFBRYzYF/L5UCRgB2Bymk6nKPPhkEgC9E=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB3989.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66946007)(6636002)(508600001)(82960400001)(66556008)(66476007)(6506007)(76116006)(66446008)(5660300002)(52536014)(55016002)(83380400001)(7696005)(38100700002)(122000001)(64756008)(9686003)(186003)(53546011)(2906002)(26005)(86362001)(110136005)(38070700005)(316002)(8676002)(71200400001)(33656002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S0Z5Mis4VmhNNDVMeGFIZzAzOTJnSVQxdXRoUkcvR1BjanJCVDNUZjdHblBN?=
 =?utf-8?B?emR6ckpTK0xQblhyOHhLMEJXUTQ1cVpmaS9yekFiNlZRdHRyOXFqYStDRVVD?=
 =?utf-8?B?ZUIxb3Z6RlpXODNXMXhScXIzSDBjZzJFWTBvWHd0MlZxZkcrdStJeFUrdUsx?=
 =?utf-8?B?TzJVeXd4ZXZaRDAzOW04Vno5dU1uNWJmQk94RXJObXorZ2JiZVFwUVllaU1w?=
 =?utf-8?B?emQrTmZlSTVKQkhTYXN6cW12MlgyTUhOWVJ0cGFUWnV0UlNvSzdycStuL05J?=
 =?utf-8?B?QnkxTUsvempOSXVpUW1VZGdQcTl2a1EzSFhsYm0yQkw4UmRxMFhUengxc0JS?=
 =?utf-8?B?QmtYckNIY3ZxbEU1K3NiRytDQjc1OGpPWDluVVJMSE1qNWRGZlJIVkgwZzdR?=
 =?utf-8?B?QVNDQ2xMVWZ3OXY5RjFNb3ZUL3NNZFk2YUoyd2pCUFNKSi9meENSWjRrd1Uz?=
 =?utf-8?B?Si9PRkRYVjdLbDJWOElLTUg5SCs2RW5kNW9sYnZBbE1hRm4zNW9xM1FrK3Qv?=
 =?utf-8?B?RjFZbUNXUUVET0QxOG1SQTU2OXhXalJpM2c0ZVZVK04wTTZkanJJMElQNXM0?=
 =?utf-8?B?c01OU3pjbWNVaHU2QVd4T2s4TDl0TllFdEphbGR6TEF3ZXQ1MVgzYmpXaUMw?=
 =?utf-8?B?WlkyZnlaS25QZ0k4VFhMdGdTS0JXUEFlNnMwQTF5dFZWWHBpbnpSUld0eldE?=
 =?utf-8?B?MnFLa3IvZFVObHJZZTN4ZEN5WDJ2UFBiZGR5Q0RjdTJERm05NVpwS1dyRzBo?=
 =?utf-8?B?MjFQRG1GQjdtdW5wUmhpTWczNmcraUk1YXJGQlN5V0o5MG0xYjNxRS96T0Mv?=
 =?utf-8?B?bVVkTXJLWFc5ak1QV1NJN2pUNnBzMnJ6VU9wVXgrK1J6TkFQd3gzVjVnM3E1?=
 =?utf-8?B?QWtDNlg3R2ExOEVPcm90a09xbEJ3MEd2VzBRK0syZHd2WC9zOVdaVCs2NTh2?=
 =?utf-8?B?UFBiYm9CQVlxd0NKYWNuS3RqeW5KQXNPOHZzRm1teXgvdWx4alhJUmV0V0FP?=
 =?utf-8?B?R1BaTFU3U2FCWDl6b2RFWVRuaEJIQzJpQmlqOEdaL3MxODlBVVRLQUVlazF1?=
 =?utf-8?B?MDY3Slh0YUJBZlVKeWVnVDI1QzFqSW5kQUgwYVBXMjZxa3lqeUloWlM5b0hC?=
 =?utf-8?B?VVhmell3U1k0RUhyUFA0NHRGOFczQ3BkeXpEbm92Tk9PK3MzYytYZ2MrSXFC?=
 =?utf-8?B?eEd6UjJ6R2RmQWZVazdOdG5DYXB5eWQ5RmtKZ1YwM3N6bUxnTFB6b0RudWpj?=
 =?utf-8?B?RzZOMjV3VDVMSGpxQXh3RFVEVkp2MjdXWWJuNGJqZVdhOHV4dFNpMm9LWWNM?=
 =?utf-8?B?eGxISmk4c0JXeFl3YjNjSHMyeE9zQTZrTWxuOWUwODVsZ2NWY29OcTZnL3k3?=
 =?utf-8?B?TXI4RGR3bjZsVlJmVno5dExsTWsvTUpNWk1WMEM4WDBiMlJyeXVqeDRSWGJJ?=
 =?utf-8?B?N0FpclNVSllZTlBxNVFiOTdYVWZTNVlUVHgyVGhDTTkzUFlaL0Z3eGh6cDFD?=
 =?utf-8?B?UEFQaERIVGhROTZJZUFQUXpBUXYwM0c3M0IwK252eTJDWW8xejN4V1VBZXdC?=
 =?utf-8?B?dFBMMW1mZlczU2cwYkVOeS9ZVXRiOURHL0dRNzRja01uMVhVYkU2aS9OYXRD?=
 =?utf-8?B?aGMxaHNIbnR1UGdBV3RLYU5CU3cwNVRWVzZNeDZxU0RYSGFLRE5uRHlTNHpV?=
 =?utf-8?B?NWRPcnFIT2c4RUtTWkxHRHI3YnNMNWZ5NkFHVmtseFlpUDVKelJDcGV4dFVO?=
 =?utf-8?Q?dxJ9wcd5dvncOnGAFftf5cNuRkiUpBKQGk7w17l?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB3989.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: daefbda8-fab7-4ea7-ef47-08d993da770b
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2021 15:01:15.7351
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /DWfgUFeaRRrvrqaJMhONl03K3SH6cKleWqwymLXQZn75TU7F9ureWdO2NMSQEBQ3BDhhi5E5xZlx5ObK43NFJJyQGUxpBBtQsudPgW3Rlk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2982
X-OriginatorOrg: intel.com

SGkgQWRhbSwNCg0KVGhpcyBpcyBsaWtlbHkgcmVsYXRlZCB0byBhbiBpc3N1ZSB0aGF0IHdhcyBy
ZXBvcnRlZCB0byB0aGUgTGludXggTlZESU1NIGVtYWlsIGxpc3QgKGh0dHBzOi8vbG9yZS5rZXJu
ZWwub3JnL2xpbnV4LWJsb2NrL0NBSGo0Y3M4N0JhcFFKY1YwYT1NNj1kYzlQcnNHSDZxenFKRXQ5
ZmJqTEsxYVNobk1QZ0BtYWlsLmdtYWlsLmNvbS8pDQoNClNvIHRoZSBiaXNlY3Rpbmcgc2hvd3Mg
aXQgd2FzIGludHJvZHVjZWQgd2l0aCBiZWxvdyBjb21taXQ6DQoNCmNvbW1pdCA4ZTE0MWY5ZWI4
MDNlMjA5NzE0YTgwYWE2ZWMwNzM4OTNmOTRjNTI2DQpBdXRob3I6IENocmlzdG9waCBIZWxsd2ln
IDxoY2hAbHN0LmRlPg0KRGF0ZTogICBXZWQgU2VwIDI5IDA5OjEyOjQwIDIwMjEgKzAyMDANCg0K
ICAgIGJsb2NrOiBkcmFpbiBmaWxlIHN5c3RlbSBJL08gb24gZGVsX2dlbmRpc2sNCg0KL1N0ZXZl
DQoNCi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQpGcm9tOiBBZGFtIEJvcm93c2tpIDxraWxv
Ynl0ZUBhbmdiYW5kLnBsPiANClNlbnQ6IFdlZG5lc2RheSwgT2N0b2JlciAyMCwgMjAyMSA4OjA0
IEFNDQpUbzogbnZkaW1tQGxpc3RzLmxpbnV4LmRldjsgV2lsbGlhbXMsIERhbiBKIDxkYW4uai53
aWxsaWFtc0BpbnRlbC5jb20+OyBWZXJtYSwgVmlzaGFsIEwgPHZpc2hhbC5sLnZlcm1hQGludGVs
LmNvbT4NClN1YmplY3Q6IFJlOiBuZGN0bCBoYW5ncyB3aXRoIGJpZyBtZW1tYXA9ISBmYWtlcG1l
bQ0KDQpPbiBXZWQsIE9jdCAyMCwgMjAyMSBhdCAwMzoyMzowOFBNICswMjAwLCBBZGFtIEJvcm93
c2tpIHdyb3RlOg0KPiBIaSENCj4gQWZ0ZXIgYnVtcGluZyBmYWtlcG1lbSBzaXplcyBmcm9tIDRH
ITIwRyA0RyEzNkcgdG8gMzJHITIwRyAzMkchMTkyRywgDQo+IG5kY3RsIGhhbmdzLiAgRWcsIGF0
IGJvb3Q6DQo+IA0KPiBbICA3MjUuNjQyNTQ2XSBJTkZPOiB0YXNrIG5kY3RsOjI0ODYgYmxvY2tl
ZCBmb3IgbW9yZSB0aGFuIDYwNCBzZWNvbmRzLg0KPiBbICA3MjUuNjQ5NTg2XSAgICAgICBOb3Qg
dGFpbnRlZCA1LjE1LjAtcmM2LXZhbmlsbGEtMDAwMjAtZ2Q5YWJkZWU1ZmQ1YSAjMQ0KDQo+IFsg
IDcyNS42Nzc1MzldICA/IF9fc2NoZWR1bGUrMHgzMGIvMHgxNGUwIFsgIDcyNS42ODE5NzVdICA/
IA0KPiBrZXJuZnNfcHV0LnBhcnQuMCsweGQ0LzB4MWEwIFsgIDcyNS42ODY4NDFdICA/IA0KPiBr
bWVtX2NhY2hlX2ZyZWUrMHgyOGIvMHgyYjAgWyAgNzI1LjY5MTYyMl0gID8gc2NoZWR1bGUrMHg0
NC8weGIwIFsgIA0KPiA3MjUuNjk1NjIyXSAgPyBibGtfbXFfZnJlZXplX3F1ZXVlX3dhaXQrMHg2
Mi8weDkwDQo+IFsgIDcyNS43MDEwMDldICA/IGRvX3dhaXRfaW50cl9pcnErMHhjMC8weGMwIFsg
IDcyNS43MDU3MDNdICA/IA0KPiBkZWxfZ2VuZGlzaysweGNmLzB4MjIwIFsgIDcyNS43MTAwNTBd
ICA/IHJlbGVhc2Vfbm9kZXMrMHgzOC8weGEwDQoNCk9uIDUuMTQuMTQgYWxsIGlzIGZpbmUuICBT
aG91bGQgSSBiaXNlY3Q/DQoNCg0KTWVvdyENCi0tDQriooDio7TioL7ioLviorbio6bioIANCuKj
vuKggeKioOKgkuKggOKjv+KhgSBSZW1lbWJlciwgdGhlIFMgaW4gIklvVCIgc3RhbmRzIGZvciBT
ZWN1cml0eSwgd2hpbGUgUCBzdGFuZHMg4qK/4qGE4qCY4qC34qCa4qCL4qCAIGZvciBQcml2YWN5
Lg0K4qCI4qCz4qOE4qCA4qCA4qCA4qCADQoNCg==
