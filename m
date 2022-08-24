Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD12A7E
	for <nvdimm@lists.linux.dev>; Wed, 24 Aug 2022 07:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661326175; x=1692862175;
  h=from:to:cc:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=PGBVonY4Z/cFR7270VoWT/jeVurctDYOBoGPtqQyqw8=;
  b=f3Vyjz9JWfKSovkcWnHVkHpkma84aB3u7LrX/AVy90ov2BJlp5tLDXzy
   /Vlms/xX3VSJv3pPPGqOUps4DVwVz0q5hZcJPfapfuiEn7FUwowp99GLl
   Rj7ZW7mUJ2cfpeHi37FmhF8HKz2AfUDaeH8+DWfikbItpYxMliPUVwQDw
   6/GYJG932BSpfh3wb3AEebqsPR8JZaAcrHJMQXWLjKADOfBGJshc+yfC6
   S/vkT3VoheEg1jPR0vNaRTHgeq0wdy8lD4B9685Hl/bmPh+5NpN0keZ5H
   bBFNqqxYKuv+4n6FcVK20KW/0wpfsR/EGgwBHiX2dH+RK4EnQIFMEsvm6
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10448"; a="293892083"
X-IronPort-AV: E=Sophos;i="5.93,260,1654585200"; 
   d="scan'208";a="293892083"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2022 00:29:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,260,1654585200"; 
   d="scan'208";a="712927368"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga002.fm.intel.com with ESMTP; 24 Aug 2022 00:29:27 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 24 Aug 2022 00:29:26 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 24 Aug 2022 00:29:26 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 24 Aug 2022 00:29:26 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.175)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 24 Aug 2022 00:29:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JYrvai3D23y2xtETL2VTbn1do9DYK2O5XuaIde/WEpuYgwqqogJbC7DcIDIunSwE2md9W1SFif+7f8y1bDsq2xUjvyzIIYIwV+4cos9iUDEbyP7nBCxLc3lgbNxDlBuhkL8OleQckqgH/tNuCzywPEf9VTTFu66AVx1ow+oYCX7wwP4bwIUWaTktTpSVVvsoyZL1zCQl/zT0BV+HnrOrr/TJcPGO8lvOkA8o8Zgi5gRhfQVesXKlD6yJhda0C5ASMXAsKrh5V63FBc8+4Q1xEiGqn1FcOKY/U7etwG+xkYzteca0r4R8uuLVkEFAyK3nLdQ9b+FL5qGfMA1dmUo8iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PGBVonY4Z/cFR7270VoWT/jeVurctDYOBoGPtqQyqw8=;
 b=kmhUgu7GyTvhuSfHjVDbTM5aJbH3GJRBRUt3IMelEQtC8Mi03QUBhZKI/ioVIHruuJCSRQkf6aD3BgeQ+2yvrJr4suzM59vQkl/0gSmFMf0SryBgLCKRlj1Fy9Io4iBZHouGOdRm5LVFY3fTmAL9QtYH1sLvFFyCrHgFytxCYUjcVMV4kWuSn9bhsFx0dxcUIvL14U7YsT7SlzVfH7jiAEDz5MdOWem3ZCTErA0CsDyWnDCz/oPapq13nAD5cDs3gDdnmWHZ3vS9SImvSDWmdNsedr0UIfHyu9VTyE6T0PatmoIcGYz1Cl6yCqZDaHFrD1reF4mirNgmKGNcovuXXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN6PR11MB3988.namprd11.prod.outlook.com (2603:10b6:405:7c::23)
 by DM6PR11MB4028.namprd11.prod.outlook.com (2603:10b6:5:195::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.14; Wed, 24 Aug
 2022 07:29:24 +0000
Received: from BN6PR11MB3988.namprd11.prod.outlook.com
 ([fe80::d864:dffa:8a1e:62a7]) by BN6PR11MB3988.namprd11.prod.outlook.com
 ([fe80::d864:dffa:8a1e:62a7%7]) with mapi id 15.20.5546.024; Wed, 24 Aug 2022
 07:29:24 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
CC: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: [ANNOUNCE] ndctl v74
Thread-Topic: [ANNOUNCE] ndctl v74
Thread-Index: AQHYt4s8bQWDLfiihk61VS/+ZWHcfw==
Date: Wed, 24 Aug 2022 07:29:24 +0000
Message-ID: <2bee1d35659c2e74be504da39d0f4873def27a0c.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4 (3.44.4-1.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7e204310-abc1-47cb-99d8-08da85a25ea1
x-ms-traffictypediagnostic: DM6PR11MB4028:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wINu5gWfcoeRnz/iGpG+lhCRottYZDsbxgGTX/gun5QFVFCtfsalgs1j2pJPSo5E21tlDDHIz2yRlhNQw4MbJhwVwGtPfQqNi0RuYtUbObkxQqbIY4dZUKg4qqyzU3m4vYpmQD/3JMO7sC7Q7lTFD8VoHY7dXCJihSdD2AQvrITNAjbpf9cJ7GvsdgC1IGDhZqt4B4FJc1lzpb1Isguz/lR5nlMZErTB+92XZDjXjMIb9OMr7GQYOL2IQJcbkp8slooxI+E//E8zlJrUzAbH3zg4le1Ieg4U+x++dHET6O2mZwHLJxhorNPpbhN1211NBOXGFwQT0DI323TDPLqfo8CGPg16eyvoXfusmdz1FEc0knz3hvEuQznsnRmAlgnE4/A+jD0IeHgGxeVdWXGL7woyQshk0GrQu0Vpv1fbcMVV4SeI9+GQ5JMbFFEjZNPtxnZ2JMa+oPRjnkN8tK7vN9VJaNcxCpNmYgh4C1HLvj9Y7MLRHsRgvkX06i0vEvDPiYbsvVFDpb2K9/jk0kE9jnFuBAryw8shUWjkLvrURfy308i+ogyPqTf8TVvyXmpklVe8kOo2atByW5SmSpqjv+yw/M9DGmcInLNEv9InACjpMWCBFyQvU3MpG/xbZegBnNcwQSlGzDM2ZVM4xVbDHbDFHZOSam5ZBqEpgtb6DPuaGFY2Enq8fkSm0Nwlqk7IkyBJzW6d37ObV/zxH/Bp1HhYxC0vCTFK2JkqY25qRwTQW507es77QPICW+cmFSIUUfYzIZ7B2uzW0JICanruePmC75Cu2h/MLZHABetgn30=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB3988.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(366004)(346002)(396003)(136003)(39860400002)(83380400001)(26005)(6512007)(2906002)(6506007)(186003)(107886003)(2616005)(82960400001)(86362001)(38070700005)(38100700002)(122000001)(8936002)(6486002)(5660300002)(316002)(36756003)(91956017)(8676002)(966005)(4326008)(66446008)(64756008)(76116006)(66946007)(66476007)(71200400001)(66556008)(41300700001)(110136005)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cldvNi9NbVk0QXlISnQyZDNucms1d21kZTBUaG5BRjI0OElUUWU5cHd6eEdZ?=
 =?utf-8?B?b0VYdUJZMS9qRWRFNTZ3QUJuWHRXR1Q4TUMyMnNkM0J5TjQ2dEpCNVlzdmh4?=
 =?utf-8?B?U3B2VHU2cEZLMFdKOWozTHBBRnFsekNmTmtQSndYRFpBK3YxSVI4UmV1bDdP?=
 =?utf-8?B?K3pXS0ZBQ0JGaEVrM0l5ZmtlTEdCVkdsaElQaThZMTdWZHRUVmR6dTdwWmR2?=
 =?utf-8?B?QVFsM3B1Y2ZFL3pkajJiNHE1RlVVdTBpeFRCMmU0NXhBWGhURmZGZzlHdUdl?=
 =?utf-8?B?aGU0eHNOM0ZpZnoza1BYeStHdHFjS001N2NMaXJtNk1PS0U4SGF5MkFIZFVT?=
 =?utf-8?B?bDdEcHhyOFlyYU55NkdpekVVQnpHV2JNR00zNEgvWHVsU1g2UnAwTGh3R3Fr?=
 =?utf-8?B?U0Zvem9NTXoxWGpRc284LzhPNWQ1YVpGZWdyckVIa2tTREpyZ2R1VktteEUv?=
 =?utf-8?B?aDFqQVpvci95bGNjSG85a2doOGtreEJjeG96TFl5Ui9WWWNLRTRQSUpkRE5I?=
 =?utf-8?B?VDJ5ek9jWWVYUGFXWWJlZllKYVRFNGNXNnNhSEhiTFAxWVA0dlNqY2N4V3pL?=
 =?utf-8?B?cFFjNmI2U0FXNXpZcGNud1pXd1AzVWdqQ3drTzZXN2tXdmdIZlFlUUVtYU5o?=
 =?utf-8?B?NGRkTlpOdURCb3B5eWFuWGwraVIwdGxrUlFxdFRpZFBPRnBIMi9vK29pYk53?=
 =?utf-8?B?UEVRaUtxa0FTNHlObkdWeTBwUGZzeklqVDRkUENpdXp4bzUweXpEUzNhdXBk?=
 =?utf-8?B?SjBLalMwQ0M4YVZMRDM4OHVVM1EvcHc0VmJpK0dIZ0g1NmM3NzNnSXp4aW5U?=
 =?utf-8?B?V0paSGZsMVAzREdIdllTNFdPR1VwSHFVOEJyRmcxNWpRUGhJTTJzMWxySDRo?=
 =?utf-8?B?eE5ZQXpGaGRrL05HWnZPWHpvZFF6a25OdFhzZmVVWSthQlFFRWZqZE11UW1T?=
 =?utf-8?B?Wk1BMlhqbVZ1TzNjSmxWUTQ4Qk02T3B3WnpYbzFLQ0FZb21SOGlWb2pGb095?=
 =?utf-8?B?WFZuZXpseW85K3gzSXpXU3BsZ3ltaGNKVmRCOUtPRFNxVDJrSkIva1N5WUU2?=
 =?utf-8?B?OVhzZy9teElLM050WTlIQ2pvSzZVVDhscy9pWXBrUlBUbTRHbW9FWUgvM05N?=
 =?utf-8?B?ejQrUjFLRXp1RS9XVENVMjVUSzdUZmJnYUxlcU5nQ2g0RlkrVFA1WlNYaGFn?=
 =?utf-8?B?bjJIUGxSVWhTdlRwZ1gxV2tBVGwzYTFqS1VVYTR2SVhuUWNHQXZQYkNKUGJi?=
 =?utf-8?B?Y0s5QWVmclpSUWlkVkV1cnJXN3RXRXpNazJMNnh4NDd3Nk1IL25KTDZCV1VH?=
 =?utf-8?B?aW9yYmtGUnRVc2tZejM2TlRBWWNZWTNWdWRuWUtqSUlKTkxoNnhad3VLdEh1?=
 =?utf-8?B?SXVhcktZR3ZZMlo0TUNtbERPU3hBdTgrMlJaUzNiM1RXdlBNVmpsdFpzM1RM?=
 =?utf-8?B?ZHV0RHRXV0NhRXVxZjMrelVMWDVqeHA4S01TRk1kKzBwZjNucWp4TVdFYkIy?=
 =?utf-8?B?MlhLOGlqMWhVczdVT3RuZ2hmLzlFeTE4UGFMd1lTc1RMS2w0VVZKWjBBV0th?=
 =?utf-8?B?V0VMZGs3MExKcnArcTFVREFLTlFlWUJvZ0p2bm1VYzhPYm1UWm9lWHU1U2tp?=
 =?utf-8?B?WSsyZkttRWYxSjgrNEZIVXdTRTF1VXBVakxtbGZncEM4T3Fwb2l2UDExYzdX?=
 =?utf-8?B?MncvRGxFM3pvVzVNd2R1YXF3NU91L0lNQUdZS3FKMjIrUnUzNDVIMVZHMHBh?=
 =?utf-8?B?SnNBRzR3aW02d1dhRU1TNGVlempOVzl6bEx0WUFuQTV0d05rSEhNYXl0OVEz?=
 =?utf-8?B?NlBNeHQxOXBlTEtRdFpJU3QxWUxOYW10NnlmRGd3aVRyMmdWMm5KYVpiZ05S?=
 =?utf-8?B?RXV2Vmd2ZnM2d3Npa3A5d2NGMm5nbG5TZVFVRlVrOVk2OWtsNk5aSzI2L3o3?=
 =?utf-8?B?M0JsVy9MWng3TVJsUDNERndJdnlGN1hZcXVYbnVJd0ZWSEtzdVJTZEZWM3Zr?=
 =?utf-8?B?UFBWT2djM2dMM1RZcVhFa1RpQ1RnNW9VN3YzRVpVWFVBVmJsVkpJV1NZaVFB?=
 =?utf-8?B?WHJja2tVbEtDZ2M2S2xJTHlFTCtORGZwenJML245ZUp1KzVld3hHVU1WdHdD?=
 =?utf-8?B?QlhLaFRTVFBOME9USVpSRXEvWEw1R1FoMnZUYkVLdEthMjYweXl4UkZWMzZw?=
 =?utf-8?B?Y0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4EB8F9B46075AC4C90DE805CC2977868@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB3988.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e204310-abc1-47cb-99d8-08da85a25ea1
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2022 07:29:24.4566
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z9CauV8pBWHacGr/GER7RFgVouhcsmBEthFJPyywOsO/kJdpHyD9e75djXYqUcSA9wnPTc6e6jmL/ckybYstLAHjoMDJkcIgFqlB53lAikQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4028
X-OriginatorOrg: intel.com

QSBuZXcgbmRjdGwgcmVsZWFzZSBpcyBhdmFpbGFibGVbMV0uDQoNCkhpZ2hsaWdodHMgaW5jbHVk
ZSBDWEwgcmVnaW9uIG1hbmFnZW1lbnQsIGVuaGFuY2VtZW50cyB0byBjeGwtbGlzdCwNCmN4bF90
ZXN0IGJhc2VkIHVuaXQgdGVzdHMgZm9yIHRvcG9sb2d5IGVudW1lcmF0aW9uLCBhbmQgcmVnaW9u
IGFuZA0KbGFiZWwgb3BlcmF0aW9ucywgbWlzYyBidWlsZCBmaXhlcywgaW5pcGFyc2VyIGluY2x1
ZGUgcmVzb2x1dGlvbiwNCmZpeGVzIGluIGNvbmZpZyBwYXJzaW5nIGZvciBuZGN0bC1tb25pdG9y
LCBhbmQgbWlzYyBkb2N1bWVudGF0aW9uDQphbmQgdW5pdCB0ZXN0IHVwZGF0ZXMuDQoNCkEgc2hv
cnRsb2cgaXMgYXBwZW5kZWQgYmVsb3cuDQoNClsxXTogaHR0cHM6Ly9naXRodWIuY29tL3BtZW0v
bmRjdGwvcmVsZWFzZXMvdGFnL3Y3NA0KDQpEYW4gV2lsbGlhbXMgKDMzKToNCiAgICAgIGJ1aWxk
OiBGaXggc3lzdGVtZCB1bml0IGRpcmVjdG9yeSBkZXRlY3Rpb24NCiAgICAgIGJ1aWxkOiBGaXgg
Jy1XYWxsJyBhbmQgJy1PMicgd2FybmluZ3MNCiAgICAgIGJ1aWxkOiBGaXggdGVzdCB0aW1lb3V0
cw0KICAgICAgYnVpbGQ6IE1vdmUgdXRpbGl0eSBoZWxwZXJzIHRvIGxpYnV0aWwuYQ0KICAgICAg
dXRpbDogVXNlIFNaXyBzaXplIG1hY3JvcyBpbiBkaXNwbGF5IHNpemUNCiAgICAgIHV0aWw6IFBy
ZXR0eSBwcmludCB0ZXJhYnl0ZXMNCiAgICAgIGN4bC9wb3J0OiBGaXggZGlzYWJsZS1wb3J0IG1h
biBwYWdlDQogICAgICBjeGwvYnVzOiBBZGQgYnVzIGRpc2FibGUgc3VwcG9ydA0KICAgICAgY3hs
L2xpc3Q6IEF1dG8tZW5hYmxlICdzaW5nbGUnIG1vZGUgZm9yIHBvcnQgbGlzdGluZ3MNCiAgICAg
IGN4bC9tZW1kZXY6IEZpeCBidXNfaW52YWxpZGF0ZSgpIGNyYXNoDQogICAgICBjeGwvbGlzdDog
QWRkIHN1cHBvcnQgZm9yIGZpbHRlcmluZyBieSBob3N0IGlkZW50aWZpZXJzDQogICAgICBjeGwv
cG9ydDogUmVsYXggcG9ydCBpZGVudGlmaWVyIHZhbGlkYXRpb24NCiAgICAgIGN4bC90ZXN0OiBB
ZGQgdG9wb2xvZ3kgZW51bWVyYXRpb24gYW5kIGhvdHBsdWcgdGVzdA0KICAgICAgbmRjdGwvZGlt
bTogRmx1c2ggaW52YWxpZGF0ZWQgbGFiZWxzIGFmdGVyIG92ZXJ3cml0ZQ0KICAgICAgY3hsL2xp
c3Q6IFJlZm9ybWF0IG9wdGlvbiBsaXN0DQogICAgICBjeGwvbGlzdDogRW1pdCBlbmRwb2ludCBk
ZWNvZGVycyBmaWx0ZXJlZCBieSBtZW1kZXYNCiAgICAgIGN4bC9saXN0OiBIaWRlIDBzIGluIGRp
c2FibGVkIGRlY29kZXIgbGlzdGluZ3MNCiAgICAgIGN4bC9saXN0OiBBZGQgRFBBIHNwYW4gdG8g
ZW5kcG9pbnQgZGVjb2RlciBsaXN0aW5ncw0KICAgICAgY2Nhbi9saXN0OiBJbXBvcnQgbGF0ZXN0
IGxpc3QgaGVscGVycw0KICAgICAgY3hsL2xpYjogTWFpbnRhaW4gZGVjb2RlcnMgaW4gaWQgb3Jk
ZXINCiAgICAgIGN4bC9tZW1kZXY6IEZpeCBqc29uIGZvciBtdWx0aS1kZXZpY2UgcGFydGl0aW9u
aW5nDQogICAgICBjeGwvbGlzdDogRW1pdCAnbW9kZScgZm9yIGVuZHBvaW50IGRlY29kZXIgb2Jq
ZWN0cw0KICAgICAgY3hsL3NldC1wYXJ0aXRpb246IEFjY2VwdCAncmFtJyBhcyBhbiBhbGlhcyBm
b3IgJ3ZvbGF0aWxlJw0KICAgICAgY3hsL21lbWRldjogQWRkIHtyZXNlcnZlLGZyZWV9LWRwYSBj
b21tYW5kcw0KICAgICAgY3hsL3Rlc3Q6IFVwZGF0ZSBDWEwgbWVtb3J5IHBhcmFtZXRlcnMNCiAg
ICAgIGN4bC90ZXN0OiBDaGVja291dCByZWdpb24gc2V0dXAvdGVhcmRvd24NCiAgICAgIGN4bC9s
aXN0OiBDbGFyaWZ5ICItQiIgdnMgIi1QIC1wIHJvb3QiDQogICAgICBjeGwvdGVzdDogVmFsaWRh
dGUgZW5kcG9pbnQgaW50ZXJsZWF2ZSBnZW9tZXRyeQ0KICAgICAgY3hsL2xpc3Q6IEFkZCBpbnRl
cmxlYXZlIHBhcmFtZXRlcnMgdG8gZGVjb2RlciBsaXN0aW5ncw0KICAgICAgY3hsL2xpc3Q6IEFk
ZCByZWdpb24gdG8gZGVjb2RlciBsaXN0aW5ncw0KICAgICAgY3hsL2xpc3Q6IEZpbHRlciBkZWNv
ZGVycyBieSByZWdpb24NCiAgICAgIGN4bC9saXN0OiBBZGQgJ2RlcHRoJyB0byBwb3J0IGxpc3Rp
bmdzDQogICAgICBjeGwvdGVzdDogVmFsaWRhdGUgc3dpdGNoIHBvcnQgc2V0dGluZ3MgaW4gY3hs
LXJlZ2lvbi1zeXNmcy5zaA0KDQpMdWlzIENoYW1iZXJsYWluICgxKToNCiAgICAgIG1lc29uLmJ1
aWxkOiBiZSBzcGVjaWZpYyBmb3IgbGlicmFyeSBwYXRoDQoNCk1hdHRoZXcgSG8gKDEpOg0KICAg
ICAgY3hsOiBBZGQgbGlzdCB2ZXJib3NlIG9wdGlvbiB0byB0aGUgY3hsIGNvbW1hbmQNCg0KTWlj
aGFsIFN1Y2hhbmVrICg0KToNCiAgICAgIHRlc3Q6IG1vbml0b3I6IFVzZSBpbi10cmVlIGNvbmZp
Z3VyYXRpb24gZmlsZQ0KICAgICAgZGF4Y3RsOiBGaXgga2VybmVsIG9wdGlvbiB0eXBvIGluICJT
b2Z0IFJlc2VydmF0aW9uIiB0aGVvcnkgb2YNCm9wZXJhdGlvbg0KICAgICAgbWVzb246IG1ha2Ug
bW9kcHJvYmVkYXRhZGlyIGFuIG9wdGlvbg0KICAgICAgbmFtZXNwYWNlLWFjdGlvbjogRHJvcCBt
b3JlIHplcm8gbmFtZXNwYWNlIGNoZWNrcw0KDQpNaWd1ZWwgQmVybmFsIE1hcmluICgxKToNCiAg
ICAgIG1lc29uOiBmaXggbW9kcHJvYmVkYXRhZGlyIGRlZmF1bHQgdmFsdWUNCg0KU2hpdmFwcmFz
YWQgRyBCaGF0ICgyKToNCiAgICAgIG1vbml0b3I6IEZpeCB0aGUgbW9uaXRvciBjb25maWcgZmls
ZSBwYXJzaW5nDQogICAgICBsaWJjeGw6IEZpeCBtZW1vcnkgbGVha2FnZSBpbiBjeGxfcG9ydF9p
bml0KCkNCg0KVGFydW4gU2FodSAoMSk6DQogICAgICBuZGN0bC9idXM6IEhhbmRsZSBtaXNzaW5n
IHNjcnViIGNvbW1hbmRzIG1vcmUgZ3JhY2VmdWxseQ0KDQpWYWliaGF2IEphaW4gKDIpOg0KICAg
ICAgbmRjdGwsZGF4Y3RsLHV0aWwvYnVpbGQ6IFJlY29uY2lsZSAnaW5pcGFyc2VyJyBkZXBlbmRl
bmN5DQogICAgICBuZGN0bC9idWlsZDogRml4ICdpbmlwYXJzZXInIGluY2x1ZGVzIGR1ZSB0byB2
YXJpYW5jZXMgaW4gZGlzdHJvcw0KDQpWaXNoYWwgVmVybWEgKDIzKToNCiAgICAgIGRheGN0bDog
Zml4IHN5c3RlbWQgZXNjYXBpbmcgZm9yIDkwLWRheGN0bC1kZXZpY2UucnVsZXMNCiAgICAgIGxp
YmN4bDogZml4IGEgc2VnZmF1bHQgd2hlbiBtZW1kZXYtPnBtZW0gaXMgYWJzZW50DQogICAgICB1
dGlsL3dyYXBwZXIuYzogRml4IGdjYyB3YXJuaW5nIGluIHhyZWFsbG9jKCkNCiAgICAgIGN4bC90
ZXN0OiBhZGQgYSB0ZXN0IHRvIHtyZWFkLHdyaXRlLHplcm99LWxhYmVscw0KICAgICAgbGliY3hs
OiBhZGQgYSBkZXB0aCBhdHRyaWJ1dGUgdG8gY3hsX3BvcnQNCiAgICAgIGN4bC9wb3J0OiBDb25z
b2xpZGF0ZSB0aGUgZGVidWcgb3B0aW9uIGluIGN4bC1wb3J0IG1hbiBwYWdlcw0KICAgICAgY3hs
L21lbWRldjogcmVmYWN0b3IgZGVjb2RlciBtb2RlIHN0cmluZyBwYXJzaW5nDQogICAgICBsaWJj
eGw6IEludHJvZHVjZSBsaWJjeGwgcmVnaW9uIGFuZCBtYXBwaW5nIG9iamVjdHMNCiAgICAgIGN4
bC1jbGk6IGFkZCByZWdpb24gbGlzdGluZyBzdXBwb3J0DQogICAgICBsaWJjeGw6IGFkZCBsb3cg
bGV2ZWwgQVBJcyBmb3IgcmVnaW9uIGNyZWF0aW9uDQogICAgICBjeGw6IGFkZCBhICdjcmVhdGUt
cmVnaW9uJyBjb21tYW5kDQogICAgICBjeGw6IGFkZCBjb21tYW5kcyB0byB7ZW5hYmxlLGRpc2Fi
bGUsZGVzdHJveX0tcmVnaW9uDQogICAgICBjeGwvbGlzdDogbWFrZSBtZW1kZXZzIGFuZCByZWdp
b25zIHRoZSBkZWZhdWx0IGxpc3RpbmcNCiAgICAgIHRlc3Q6IGFkZCBhIGN4bC1jcmVhdGUtcmVn
aW9uIHRlc3QNCiAgICAgIGN4bC9kZWNvZGVyOiBhZGQgYSBtYXhfYXZhaWxhYmxlX2V4dGVudCBh
dHRyaWJ1dGUNCiAgICAgIG5kY3RsOiBtb3ZlIGRldmVsb3BlciBzY3JpcHRzIGZyb20gY29udHJp
Yi8gdG8gc2NyaXB0cy8NCiAgICAgIG5kY3RsOiByZW1vdmUgb2Jzb2xldGUgbTQgZGlyZWN0b3J5
DQogICAgICBuZGN0bDogdXBkYXRlIC5naXRpZ25vcmUNCiAgICAgIHNjcmlwdHM6IGZpeCBjb250
cmliL2RvX2FiaWRpZmYgZm9yIHVwZGF0ZWQgZmVkcGtnDQogICAgICBzY3JpcHRzOiB1cGRhdGUg
cmVsZWFzZSBoZWxwZXIgc2NyaXB0cyBmb3IgbWVzb24gYW5kIGN4bA0KICAgICAgY3hsL3JlZ2lv
bjogZml4IGEgZGVyZWZlcmVjbmNlIGFmdGVyIE5VTEwgY2hlY2sNCiAgICAgIGxpYmN4bDogZm94
IGEgcmVzb3VyY2UgbGVhayBhbmQgYSBmb3J3YXJkIE5VTEwgY2hlY2sNCiAgICAgIGN4bC9maWx0
ZXI6IEZpeCBhbiB1bmluaXRpYWxpemVkIHBvaW50ZXIgZGVyZWZlcmVuY2UNCg0K
