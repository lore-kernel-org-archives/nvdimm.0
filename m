Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73DA7263BD
	for <nvdimm@lists.linux.dev>; Thu,  3 Aug 2023 22:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691101755; x=1722637755;
  h=from:to:cc:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=w8KHfVrT9uaAv93Lx5zYufS6C3bjc2Ulivf89ZVJEio=;
  b=nhe8zamI+zG/Gem7AtEpuDETmSIQ36tnaedyxS2ey9IJH2QJk5xDZ80Y
   MlvZZdRKjvHzP01dJAt3+eLKTFMqEpCe0diHpiLZGSKIA4YkZQg2XtgVJ
   UdLU0OhmO1H/QgcT94t+W3XTw9cz3uEmLcWQusieCKVUETIg/6hjw0Cnr
   rbFyEU3S9oGBFuz1e0fsNU2PxUhNYNSB/YIi9atazE99572K2KY77fR+q
   mwAryUtDBQcLVj452sPFxEvE6gNqwfpMO/0FqcmKfEk1GUCkzZzkCIpFX
   0JiPWVGEt45AuSjV4rBN1u+ADVBXNZMzrow1jJfJ9qyHG3ZQg7NUppjsF
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10791"; a="373648342"
X-IronPort-AV: E=Sophos;i="6.01,253,1684825200"; 
   d="scan'208";a="373648342"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 15:29:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="873115161"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 03 Aug 2023 15:29:16 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 3 Aug 2023 15:29:14 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 3 Aug 2023 15:29:14 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 3 Aug 2023 15:28:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PuBlvD5C9gC7cC+SCcr26NI+7wvQK9bc4o2/Pb/szkskNn2MFqtDTJoNjKyFxjyQBGfDOR0TOWMXRvKId3zd3uvqlrI0v8hC28oPDTBq+OJykoF5OlCFyiUvIbBLi1fITzQagP5mkSDGCG/hR+z0rQUAkm/lOMsABftStANbKr98lcxdvCq8xGHNPjLq7Ix8iaW4vvCKdhGJ4dEer3XJU6VngOz0AoA9ljqDZyAaI0yujEymFhfYNJOC6oniqQedpe1LBrz94DBbyBPwVZaDOzQ0NaAHCikilsawJFK69QI4Az7b63En1VsKvLdg6E/pxRSg33gGCMajll//PThkkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w8KHfVrT9uaAv93Lx5zYufS6C3bjc2Ulivf89ZVJEio=;
 b=g1pe/g7L2nylYcsLIaRmHCg9IekY9IERJa1IpgCtNG8sfDGBTg8WsLWPxurfXI2cIqJA5ixGOK1d9R5DIM7kDskYPI0ojCtSX8MLQM5zgVDfHfOg4Ow/qli5F1QdyuXPP2J6zE5bRMlulgoj4udyi5MNAiZ0HyFaD8Xuj70FafAzKlp2dwDSpmsWGz+OQ/U9RI1zunetF8obVaVZQ4Vd5K3Tu3HnCozUS0fqL5VMvZV85NQJMrdwIY9UWoZos7ZKdLcFQRR+QyCqnZ7CF2XxQpw351vM7gqAk6I5KDvZX2cYGWv/ac+1RbHAW5R+daTAMrfWM+IpPp4YvwAy4CT7oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by MN2PR11MB4726.namprd11.prod.outlook.com (2603:10b6:208:269::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.20; Thu, 3 Aug
 2023 22:28:56 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::cb1f:f744:409c:69b3]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::cb1f:f744:409c:69b3%4]) with mapi id 15.20.6631.046; Thu, 3 Aug 2023
 22:28:56 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
CC: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: [ANNOUNCE] ndctl v78
Thread-Topic: [ANNOUNCE] ndctl v78
Thread-Index: AQHZxlnjSgX1unggu0mdVvBgr9GyiQ==
Date: Thu, 3 Aug 2023 22:28:56 +0000
Message-ID: <8a83f1832c95e327a4695b607729102216a3e2f0.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|MN2PR11MB4726:EE_
x-ms-office365-filtering-correlation-id: e0f6df5a-da75-4a61-e07e-08db9471064b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bvv2Tqom8mI5t1xdpi5uYOE9x7LjxCYp32mkgoVat6AFyBCMQo4Gmg1LoTTm095uD0+LGAzpx4gBAe6XXcDd72qpSm6ywD2KjFn0xj5nLi+LRUD7n38QeBxPS9CbfiIQollzzQnua1p8m9WOP0y60RGBnn7yNRQDvfEUddXgQUAjDUoGW8JIYzPzeB2zt8WztXmaoTmv/57vhgYPkp+utR741WRkqLW1WwuUi4J1Hl8oHiEtXmZhy2v7WHue2c5wW180qmQgKP34yfp630mjbBoCTPDKos20vU0m975lloA/WdQnQ+1W2ky4djraLDa7HYGeUkIuVPOWxL/JyXicrbSsEZ71woqB87r1pCiIuYhFHTMO4kjj7w181UCb/X4cb10wrmehKazPDbJ/cfZrjhy/yfVX5E4SD5ykDSksYt33XUVVgF5IogkOoOGSCxcKnCVIoApb3GUKmsKOFHn7cTwczXgIR4lypTiyb9LIt2H4hrKm4bbQalIx9knix4otse9Sns/ypcXjeWS/aWBBgOT2dOK3Z7in00rO4QnmpF7+j9wOrN6pYnsZpvfTtLbz+q9OUpR5yRVCCdAmo/IAYAzLbK99U+E7iAw38SxtKaE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(366004)(136003)(39860400002)(346002)(186006)(451199021)(38070700005)(86362001)(36756003)(478600001)(110136005)(38100700002)(122000001)(82960400001)(8676002)(107886003)(2616005)(83380400001)(26005)(6506007)(6512007)(41300700001)(8936002)(6486002)(966005)(71200400001)(2906002)(66556008)(316002)(76116006)(66476007)(66446008)(4326008)(5660300002)(66946007)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MWRuZUY3NldFUVNSMGxBcC8xaEUweTV1THRSa1NHYmtoa3lvZ2NuTVhiclRu?=
 =?utf-8?B?Z1RjVVRwMlRycXZ1d1hTQ3h6Y0I3YmdtUzNDOVF2Vldtd3NCd1Z2dDErdXYw?=
 =?utf-8?B?cGEwdWJXL1docWVmY1dnZHN2dS9GOXNZc3hiMG10anNUemM2Y084UlpCb2R1?=
 =?utf-8?B?aWoxSXl1OUhZbW5zYnhxVGdyNU1oVFVVRkRiQmVNYjFid0o4c0NURmVzYWJ2?=
 =?utf-8?B?cmNESnphMG0zbDU3M1pmMWlxcGl0ak50OERCeU1NNFA0ckNZSWlHQzZaZDJi?=
 =?utf-8?B?NitTWnNCdUwyUnduaVN2THBsSk8yWGg5bi9KZzNpZWpqRXpuN3prWERoSHd0?=
 =?utf-8?B?U09OakRhQ3gvVFBIV3NIa2htU2xvUnBQajZwMERld1F3SVVMb0RtN0F6S0ZU?=
 =?utf-8?B?Ny82MWJ5TG9hUHVlZE9aYURVZ25sa0kwSUl3TnRJWUlzK05sV3A2U0dJeDVZ?=
 =?utf-8?B?Z0ZQeHc3UFhnODVPT1RYemJ2eFdvRjM5Wi9xQVdKdWpxdFhuTThOSjFYWVpR?=
 =?utf-8?B?aTI4ZDdRZm5EekRlZk1zeGF6d2RhNXd4d0pJVEd0dll0NzlQMDhmU1J2QTRv?=
 =?utf-8?B?dGc3Rk9qOXY5Vm1QL2hwYWlJZnBtV1VjdXFiaWVKZkhDNHZ1emxZWnBqSi9q?=
 =?utf-8?B?NFFhSXArVXNic3NRVFZxYTQ3OERxVk4yZVpTdGw2MFhTQUl3bTJmWUtUZ0hi?=
 =?utf-8?B?TUcvSndUVXRyR2tvY0dZOTlJVldXbGtqbXd2NlNWU3BwMkZmdEoyUnFycEY5?=
 =?utf-8?B?cjRZTHg1dTdiWmU0WUtVaFVWS2k1N0NzdFdZWUdZM1lQR21IZUVRNjhCTDVm?=
 =?utf-8?B?RDBxOG5yQkczMGNNUHNFb2NyVDFvNG5ON1hKcWNDREVNRE9FSGppNXlRcXZG?=
 =?utf-8?B?K1YvbkYwNG53VzhiVk5QdnJQNko1czBpdlJtbi9KZnpZMDg0RThLWWorRXM5?=
 =?utf-8?B?Y0JNczU4dk1aNFd4enl6V2RxenliaDY5OUJ2MDlndldFZzNpMXVaKzhoWEx4?=
 =?utf-8?B?Sm1leUhaR2Y0SEJyTHlDVjJvRFU4dzNXQVk4M01QL1A5enFSd2Z6eGZxb2tM?=
 =?utf-8?B?QVhuVHVITndPWWJQTjB5cGdob3hObDV4bFg1V3k5cmtkMWlQdnR2Z3Nrbmpp?=
 =?utf-8?B?VUNoOVBDZG5xKysvbTA2dUJWTCtWQ2RySk56bWNxMm1xVkZBemdhQTNmS0hu?=
 =?utf-8?B?YWptZ2QwY2JqQzVGVHhteit3RGw4SjdqNGJyWmFkQnluR2RDQ2lBZGIrRVR0?=
 =?utf-8?B?TDNkamprUUVETkhqRW1xYzlWcmtCRUJhaWc3UnlmcjJsa1ViNWZMdFYvcHZP?=
 =?utf-8?B?VEk1NU9PY0djTXg1Qmw4TGVhZ05wNXpQUCt6WEVrenYwTGNNQ2RXOVBFSEFI?=
 =?utf-8?B?cTlhNWVRN3l2WGpBMUFwdFpnaEYwNFJmUWs2RTlObGxWSmE2cGYxOXgxRkJK?=
 =?utf-8?B?NDlmakRrYWUwRXgrL3Bkb1hWczVoWG9kTlBpOG5wVEdReGZvRG9YRWZHZ0dp?=
 =?utf-8?B?NDIzQ2RZcW1Iay9WZEkrZUxyYmdXOFUxWXFiR05FZTNkRjB3bHJhbGdSRHR6?=
 =?utf-8?B?MW1DbTV0NmpmYTA0dWExNFdIaGxBS0hzTTRGM1lPOGUzUkpSdlF3Vjdmc01K?=
 =?utf-8?B?S3orRXpmbUVqYm9uR205KzI1S1VkbG05amE0SFl3MnhnRWFSWkJ6azBNK2F3?=
 =?utf-8?B?TkFCWWdQYUZZazFzcGRIbEdOYXJPdEVWZzNZemFyWTBZWGhkay9zMXhvNEJU?=
 =?utf-8?B?MzQwdjJKSlJyUFdhQnFqVTJSNFBTTXZaRHplQjlQb2lDM0tJNndhbFVrSnpP?=
 =?utf-8?B?R3pQVnJodi9BbzZ3U0NLb0lEV2EycWdSRGp0V1BVc2RRbHRhNmdGVTU0RHYr?=
 =?utf-8?B?V3FQNnVDZ0F1ZmMyNHZFcThPeDFGeWJDTER0c0lSMk1COTJJZXpHSlhjVWVX?=
 =?utf-8?B?UVBoK09kYkM0TVVPT3FVMGl1VkY5S1VzOHhJMWwvZXo5UXEvZFMxMzY4SHd1?=
 =?utf-8?B?YjErYnQ3R0c4ckZPKzFrMU83eU1iRDRyZmRtOGljYlVaUTFjQ25sYmRwYnY1?=
 =?utf-8?B?cXk5MTVRaW0vVFpxZU1UOEJmdk9aZTRMVjRxMEpJSUJvM212WEVDR2dxaDdu?=
 =?utf-8?B?WE40U1FSbHVZSVFicXlyemJQb3IwUG1tVHI0YmlQQmM5K0wrK0tBcUdjNUdu?=
 =?utf-8?B?NVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4AFF47D8327D9441BAC7D35AD9C8F02A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0f6df5a-da75-4a61-e07e-08db9471064b
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2023 22:28:56.0387
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2VG9cCyJsmBlU1psDK8ttahQ1S9P75fIl6aMAObkguFCcSbm6U7pwpdgvNohbFEri+HVysx1fhJxUuDFSjTxufYxqW9RvkZNrDXx+A2nLyk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4726
X-OriginatorOrg: intel.com

QSBuZXcgbmRjdGwgcmVsZWFzZSBpcyBhdmFpbGFibGVbMV0uDQoNClRoaXMgcmVsZWFzZSBpbmNv
cnBvcmF0ZXMgZnVuY3Rpb25hbGl0eSB1cCB0byB0aGUgNi41IGtlcm5lbC4NCg0KSGlnaGxpZ2h0
cyBpbmNsdWRlIGZpeGVzIHRvIGN4bC1tb25pdG9yIGFuZCBuZGN0bC1tb25pdG9yLCBhIG5ldw0K
Y3hsLXVwZGF0ZS1maXJtd2FyZSBjb21tYW5kLCB2YXJpb3VzIGRvY3VtZW50YXRpb24gZml4ZXMs
IGFuZCBhIG5ldyB1bml0DQp0ZXN0IGZvciBjeGwgZXZlbnRzLg0KDQpBIHNob3J0bG9nIGlzIGFw
cGVuZGVkIGJlbG93Lg0KDQpbMV06IGh0dHBzOi8vZ2l0aHViLmNvbS9wbWVtL25kY3RsL3JlbGVh
c2VzL3RhZy92NzgNCg0KLS0tDQoNCkRhdmlkbG9ociBCdWVzbyAoMSk6DQogICAgICBuZGN0bC9z
ZWN1cml0eTogZml4IFRoZW9yeSBvZiBPcGVyYXRpb24gdHlwb3MNCg0KRG1pdHJ5IFYuIExldmlu
ICgxKToNCiAgICAgIGRheGN0bDogZml4IHdhcm5pbmcgcmVwb3J0ZWQgYnkgdWRldmFkbSB2ZXJp
ZnkNCg0KSXJhIFdlaW55ICgxKToNCiAgICAgIG5kY3RsL2N4bC90ZXN0OiBBZGQgQ1hMIGV2ZW50
IHRlc3QNCg0KTGkgWmhpamlhbiAoOSk6DQogICAgICBycG1idWlsZC5zaDogQWJvcnQgc2NyaXB0
IHdoZW4gYW4gZXJyb3Igb2NjdXJzDQogICAgICBtZXNvbi5idWlsZDogYWRkIGxpYnRyYWNlZnMg
dmVyc2lvbiA+PTEuMi4wIGRlcGVuZGVuY3kNCiAgICAgIGN4bC9tb25pdG9yOiBFbmFibGUgZGVm
YXVsdF9sb2cgYW5kIHJlZmFjdG9yIHNhbml0eSBjaGVja3MNCiAgICAgIGN4bC9tb25pdG9yOiBy
ZXBsYWNlIG1vbml0b3IubG9nX2ZpbGUgd2l0aCBtb25pdG9yLmN0eC5sb2dfZmlsZQ0KICAgICAg
bmRjdGw6IHVzZSBzdHJjbXAgZm9yIHJlc2VydmVkIHdvcmQgaW4gbW9uaXRvciBjb21tYW5kcw0K
ICAgICAgRG9jdW1lbnRhdGlvbi9jeGwvY3hsLW1vbml0b3IudHh0OiBSZW1vdmUgbWVudGlvbiBv
ZiBzeXNsb2cgb3V0cHV0DQogICAgICBDT05UUklCVVRJTkcubWQ6IEFkZCBub3RlIGFib3V0IHRo
ZSBDWEwgbWFpbGluZyBsaXN0DQogICAgICBSRUFETUUubWQ6IGRvY3VtZW50IHNldHVwIHN0ZXBz
IGZvciBDWEwgdW5pdCB0ZXN0cw0KICAgICAgY3hsL3JlZ2lvbjogRml4IG1lbWRldnMgbGVhayBp
biBwYXJzZV9jcmVhdGVfb3B0aW9ucygpDQoNCk1pbndvbyBJbSAoMyk6DQogICAgICBjeGwvbGlz
dDogRml4IHR5cG8gaW4gY3hsLWxpc3QgZG9jdW1lbnRhdGlvbg0KICAgICAgY3hsOiByZWdpb246
IHJlbW92ZSByZWR1bmRhbnQgZnVuYyBuYW1lIGZyb20gZXJyb3INCiAgICAgIGN4bDogZml4IGNo
YW5nZWQgZnVuY3Rpb24gbmFtZSBpbiBhIGNvbW1lbnQNCg0KVmlzaGFsIFZlcm1hICg2KToNCiAg
ICAgIGN4bC9tZW1kZXYuYzogYWxsb3cgZmlsdGVyaW5nIG1lbWRldnMgYnkgYnVzDQogICAgICBj
eGwvbGlzdDogcHJpbnQgZmlybXdhcmUgaW5mbyBpbiBtZW1kZXYgbGlzdGluZ3MNCiAgICAgIGN4
bC9md19sb2FkZXI6IGFkZCBBUElzIHRvIGdldCBjdXJyZW50IHN0YXRlIG9mIHRoZSBGVyBsb2Fk
ZXIgbWVjaGFuaXNtDQogICAgICBjeGw6IGFkZCBhbiB1cGRhdGUtZmlybXdhcmUgY29tbWFuZA0K
ICAgICAgdGVzdC9jeGwtdXBkYXRlLWZpcm13YXJlOiBhZGQgYSB1bml0IHRlc3QgZm9yIGZpcm13
YXJlIHVwZGF0ZQ0KICAgICAgY3hsL21lbWRldjogaW5pdGlhbGl6ZSAncmMnIGluIGFjdGlvbl91
cGRhdGVfZncoKQ0KDQpZaSBaaGFuZyAoMik6DQogICAgICB0eXBvIGZpeDogb3Zld3JpdGUgLT4g
b3ZlcndyaXRlDQogICAgICBSRUFETUUubWQ6IGFkZCB0aHJlZSBhZGRpdGlvbmFsIGNvbmZpZyB0
byBjb25maWcgaXRlbSBsaXN0DQoNCg==
