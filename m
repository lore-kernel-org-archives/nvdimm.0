Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826E1168
	for <nvdimm@lists.linux.dev>; Sat, 18 Dec 2021 02:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639794808; x=1671330808;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=OeXuscZ25D9cIOcb+dS4/F8wHTFCXrLk4R6BaeDPyMw=;
  b=W16Zy0raosIHqPxXKFHpZhJqPRqQOEGF4PyTM1ZzAgsNY970CARMk8Av
   1Exi01BJ8recVnZRN/f4mhW4I4cab343x5Rfx9Tn0X79a+g7Esrj8ni1E
   DwGCwj3sE52dVg9wDT1u222htJvA7wL5w+w25nmdCdp0ooIT8CB07wA7L
   KooMAi87apyKiITLPY5ox3AZPTR3fkCQdlybiJG2BKjThEEHBDSC7Il0j
   0Ci06r28fxDYA8Zz5lgiVte1jdK1HSrmGr3LTahssjTv2G8r64MWyZE0o
   TVoSugYvhk92IoqA6jaAZObbXpZpaFZBwaGjF1Yw/2/PjWRKNHfx5d04c
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10201"; a="239687033"
X-IronPort-AV: E=Sophos;i="5.88,215,1635231600"; 
   d="scan'208";a="239687033"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 18:33:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,215,1635231600"; 
   d="scan'208";a="520014590"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga008.jf.intel.com with ESMTP; 17 Dec 2021 18:33:28 -0800
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 17 Dec 2021 18:33:27 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 17 Dec 2021 18:33:27 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Fri, 17 Dec 2021 18:33:27 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Fri, 17 Dec 2021 18:33:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PDk0+GKXvi06Ghl0UNAjS0PYssC0FUJDmApGnfl/ZUCGVrHCdxXpCROLvwDkqwj4J7fHbYmsC18fvjIT8kruTXyO5LHvtiptZnMAw8DzBmMoVn62fKIt4UFc5EA4JEbFBpFUn8L3qjHV9kBavsC/ZSJymOGNDUP6W7pRgZGmecndgTxhCFlIJyqx4zyOgUFNmnr5F8kmDL2uhgT+EkqPt82LEbTrDK11WxJpEfX3cNa/RO+Z8uetAn2AzXS4KNw9xWwEXd6bF4XnXZx21TjhZtQryBYR+AY5Mua36Wa3P1/H601eIDFlUEKNE5yR/yf5ccQFA5r/29tSD2sgIMJxzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OeXuscZ25D9cIOcb+dS4/F8wHTFCXrLk4R6BaeDPyMw=;
 b=KQqfV7DLSynb5J5atJhIONJZbPmSYa/QcjK7xRh/FRwPo9gmfLJXGfaMp8gpCE4IW3yomU8u8KFjrfeAkhU28i9deB9UuqEu8civgBuBd3B/ETeOuiO/wFVGLBkuvwndeSdhza5CIWhHDg6JKk3amWZJ7bfsvyyFexhp4F3tYyNHXVVYEs5+AQj/7tP6RD7K5dCfj2JUE7+dZjS8tpdg8avgMvqTR1BRS0p27op4adFnX/OZhcyTaxh0+FyAXE7hhLXEWU6fEk9PkwKvi938wAf9yW+Y3JmjEEQtArPNPIfG3Dtjj4QVOOJMIDGWqU95MP3sJO7szBJ6ycEt+mkm/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by BL3PR11MB5745.namprd11.prod.outlook.com (2603:10b6:208:352::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.15; Sat, 18 Dec
 2021 02:33:20 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::114d:f87:eeb5:b6be]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::114d:f87:eeb5:b6be%4]) with mapi id 15.20.4801.017; Sat, 18 Dec 2021
 02:33:20 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH] libcxl: fix potential NULL dereference in
 cxl_memdev_nvdimm_bridge_active()
Thread-Topic: [ndctl PATCH] libcxl: fix potential NULL dereference in
 cxl_memdev_nvdimm_bridge_active()
Thread-Index: AQHX87aC72J0hP+4I0eXm7etuShb0qw3hlUAgAABeoA=
Date: Sat, 18 Dec 2021 02:33:20 +0000
Message-ID: <ab013b5c98f69cfd385b14f1fec7930f04fe4c71.camel@intel.com>
References: <20211218022511.314928-1-vishal.l.verma@intel.com>
	 <CAPcyv4hGOw0wp7iR24vVXG_jCRTFwaxMNmq+qJH_8tpG8K8zfg@mail.gmail.com>
In-Reply-To: <CAPcyv4hGOw0wp7iR24vVXG_jCRTFwaxMNmq+qJH_8tpG8K8zfg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.42.2 (3.42.2-1.fc35) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ea3b9aec-789a-4336-e60d-08d9c1cec1b9
x-ms-traffictypediagnostic: BL3PR11MB5745:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <BL3PR11MB57452461EF88A74B8103532DC7799@BL3PR11MB5745.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iRr97ibNNUdTxSTpq8ZcwGORUArnOgErd7S3A48uuyaCDsfl985RkAdnuq/SMtAdIX/aIoFXr0fa19jkA7EVK63hEFU2hFnB2as1N/AcdgBGJl4jIXu12aWl1VuzeXzxyhQRsPhFs4U6dkWf7ikn8vxTW6u/7rjFsSnCHC4Ag9THryJ9+H0nvz8vCnjqw1PkQA86WDLUmr/sW3K0ozICLK1rq45xZwnYd9H2UGjdecpFQRFtzVsHogMBSkaJ1BttRs6MjEYdh1MTMUTqLqOqNhnmf0zyVqQWMid9jc9CLVsQfEn/V6WNyX1E1xEU8p7iiJFPjv+fob5pWF6gjlJ1gxyFX8rBrgpX8Tx9e6G8cQDvu17ECoTaSH1fNifiBjzTZCWL0g+VBCAFP20xDP5JTd4hlgCxZBfZi+YXq3xTKLNRO7/i7iG0GDgWHKg3xNiPqRfyBjsZPvM3KJj8h+s6WHf1sRM2oPa7nB2rv6hOtvcMxyOdtZbnK9ioO3cBogEaQQjaXlKnipVAg79Oc/I9zSXG2msXfCMyZyPZ0LYdZzOg6C2lKU9OEa2UwbLj38upmrHjEBrYJl7z6BSLcxTAeipHB9ZYphR74PSNWphCHiUmB/ukETN8plcYvALye51WWyXUdHLkU2RtqCZ9DnXcj0t9LbBef6WGzpxBo5ZOlPk/B6V526IHU4dttRAh7nDuydetfw5QCEjDhcofZHKNSg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38100700002)(83380400001)(37006003)(122000001)(82960400001)(6486002)(66476007)(4001150100001)(6506007)(53546011)(8676002)(6636002)(316002)(508600001)(6512007)(86362001)(54906003)(66946007)(76116006)(5660300002)(2906002)(186003)(8936002)(64756008)(4326008)(6862004)(66446008)(91956017)(66556008)(26005)(38070700005)(2616005)(71200400001)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VmhnK2VhMmFxWFRXOEhSZ1o0b1greWxQTzdXYUExcFZLL2dIVjJDZmY1dzZj?=
 =?utf-8?B?NTE4VlN2clNuWUhadWxxOE1uQzdPR3ZHOWJ4RXNSYnZoSHI1dXpreVc0bURS?=
 =?utf-8?B?TXJ0R1B4aFpBSVpGbFN6Y3VIV0lHaEdHWVE1NjBSZlpoVU5SZlZuSHZwKzdC?=
 =?utf-8?B?bFphSVFTU01SWm5UV0R1d2kyY21zV0VNZHQ4Q1RSY2h1MlUwbEozVWl0cnlI?=
 =?utf-8?B?NHhPaTJtVVpNTmc4aHhBdEhqbkNMMGF1Mno3eEZjbytJWmxUSVdQcUxMMit5?=
 =?utf-8?B?YnhvZXc3Z1pwWFo5b21HQ09MZG9Ia0xqR2I0aUZVdTJZWlRCSy9uU3Nvc2Q5?=
 =?utf-8?B?N2gzemd1TW96MDVOZ0piNzI3QTFUUml2b0dzcG5hb2RRTGU4KzNGMHJZQXVx?=
 =?utf-8?B?blREZllWd1lzVTVNdVlkVUMyQnQzWFN6NXBCaFBZelZTYVhrQUFMeFJWbWNR?=
 =?utf-8?B?c0lGSGUyRGFuR1haeHVFRjhTeEpOZUVGUUo1cG9EdnJ5cktkRHV2dlpBOTFs?=
 =?utf-8?B?WGN6VVhzdnBJaFBvSzd4UUMxZk1qTXR4S1cwdDZVbWgwUk9wbmFWSG5xdnB1?=
 =?utf-8?B?TDJFbm1qejNWKzgycU1pbkR2d29wYTBPZFJzQ29Xc0dTSDMvRnNqak8vTzV6?=
 =?utf-8?B?R3V0NENpSVlVUUN2Q1YwcWxsS1RpeGplRjVZL1F2d1hINCtlOUJVNmQreThO?=
 =?utf-8?B?VXpoYVI4NE9QRndwcjF0aUFoaXhLdGFJQ0p3blpGa1FjQ3AvdXR2UlRqVkNz?=
 =?utf-8?B?c1ZEc0NYdG5yWkhzWHljZFdZS2xGaFYyb3hEY3locUVJQ2Nqb0F0aEZsMkFW?=
 =?utf-8?B?cVVUOGZoYVc0R0FSUkZHRWRuWmJibVFVVlNaSnpVRDN6QUJXdUJYZnZXYWlF?=
 =?utf-8?B?TEFSN280RUJUV3oxcUxSUnZmQW5lV3dsSUg2Tk1YVUE2cGxSR24va2tMbzNE?=
 =?utf-8?B?Y2l2V2ZRa3JTL21ER1hpNUhaMHZ4VkZnSDEwUTNueVdpd0FBbEx2eHArVHgv?=
 =?utf-8?B?ZEtWL2FtMC92SVlKazE3UlNWWlBlR3k4QlB1b1ErV0NxQmxNQkVQMllKMlpt?=
 =?utf-8?B?anVuK2tiVzBmME1vRE10NElNcXg3OThJUWJJTkhXd1hHRTdySURVcGVvSGpC?=
 =?utf-8?B?OVFMSndGV0toNWtHa3NIZHZ1MmxlU3FaSGxIcVkyMDc5dHd2SWFBWmQxVGc4?=
 =?utf-8?B?L25ySFEybGxERnRjZ0RuM2NyMkxtSThMVHA3ZFZWVFFjdVgzTHRBeG5aZGky?=
 =?utf-8?B?Vm5WZ2RjTk56OUx0U0JxU1M2eUVCU2VHdSttL3BZQ3dlQm5XK2hxVXlUaisw?=
 =?utf-8?B?RkVsbjBGSk1OSVpxM2NtQ1Q0UTA3N1p4ZENtTWhwSHRTR2p1UFdUazMrbzIz?=
 =?utf-8?B?OGZkdFVOUThhbjd1d1F1THJYbGo1ZFBnTmtRY1pvUnh4RUR1YWNFME53Qmcw?=
 =?utf-8?B?ZjFGQnRnOEp0VTcwVEswR1FSeHQyaWdjam9OSlNvOUFrNDd6T0hTMEVQVFF6?=
 =?utf-8?B?eXhoclZ6Z3RKWUNveFRoV3gwR3UvT0JaWVhnRXhyN2QzRUVsaXJsQnhKMGNt?=
 =?utf-8?B?dzFJSE1YbU9UN29qNGZwMXVLbmtDaCttMWNiNFB6a0VQcHBob0FYK2E2YURj?=
 =?utf-8?B?LzVGa05uNVpockQzWndxTmpiRzhlNWVDR09mWG1waUVZeS8vZHJQWDdJa2Jk?=
 =?utf-8?B?VDE3T0RPQkxCK1NaQVZtajB5TWkrcEZZVWQxMWhTVU9rV3o2ZXRFN1JJQlU4?=
 =?utf-8?B?akorUEpLeWNYcWpQSnliaitTd2F2eW5ybFRoc3Z3bEovRDBaNXpkdDAzVllh?=
 =?utf-8?B?QkdqTEsrQzhDSTJlai9qS3FoUUtzTFlzSG9KL3dVcWdzaytRNFZ4YlZMdytV?=
 =?utf-8?B?cGpzVVlCMndIRWpSTEowK08wUEVqTnF0dUpXamhvK2ViWnB1K3hmSnVPRkxv?=
 =?utf-8?B?dGxkM3kxRE12QnU3OGtMY1FsRUpJZDJIdktWK2VWeis0K1JGZE1pZjluU2RE?=
 =?utf-8?B?d3ZUM3RPNldMLzBHakxFR1Vqajk2N2pkVGFqZFUxZWhNbXM4WHlnSW1HVDYr?=
 =?utf-8?B?ekdPMlppMjhHSC9XWldDVWpLdkcwcEQ3RzRSYVRjY0g2QnlkSmpDZlhiTS9z?=
 =?utf-8?B?blJqU29mRGtQa0p1OEkwZHhGYTc3c3V3eEFqc1hJYkUyNCtWV1F1clVaRkZM?=
 =?utf-8?B?THNUMzlWaTZCQ05QS3RrbDViNXkrbi9RdDdhRlJFeGltRTlDZVU0ZGEyUitz?=
 =?utf-8?Q?T1vwIAIWIiEAHMHaqPZBXL7sHeABXNb9HGwtC8LrYQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5095E04969C2BA4BBB0730B1390CD527@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea3b9aec-789a-4336-e60d-08d9c1cec1b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2021 02:33:20.6235
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FRKHshesR74sgDtPUxsjDWCE34MaqoOc6Dc7b4ywSf1TYlwWDpAESOiQzDMhs3W58a8Q7IALcfYAy6ajSsB/DeP2tDAp5RsVvm1FPP/sy3I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB5745
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDIxLTEyLTE3IGF0IDE4OjI4IC0wODAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIEZyaSwgRGVjIDE3LCAyMDIxIGF0IDY6MjUgUE0gVmlzaGFsIFZlcm1hIDx2aXNoYWwubC52
ZXJtYUBpbnRlbC5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IFN0YXRpYyBhbmFseXNpcyBwb2ludHMg
b3V0IHRoYXQgdGhlIGZ1bmN0aW9uIGFib3ZlIGhhcyBhIGNoZWNrIGZvcg0KPiA+ICdpZiAoIWJy
aWRnZSknLCBpbXBseWluZyB0aGF0IGJyaWRnZSBtYXliZSBOVUxMLCBidXQgaXQgaXMgZGVyZWZl
cmVuY2VkDQo+ID4gYmVmb3JlIHRoZSBjaGVjaywgd2hpY2ggY291bGQgcmVzdWx0IGluIGEgTlVM
TCBkZXJlZmVyZW5jZS4NCj4gPiANCj4gPiBGaXggdGhpcyBieSBtb3ZpbmcgYW55IGFjY2Vzc2Vz
IHRvIHRoZSBicmlkZ2Ugc3RydWN0dXJlIGFmdGVyIHRoZSBOVUxMDQo+ID4gY2hlY2suDQo+ID4g
DQo+ID4gQ2M6IERhbiBXaWxsaWFtcyA8ZGFuLmoud2lsbGlhbXNAaW50ZWwuY29tPg0KPiA+IFNp
Z25lZC1vZmYtYnk6IFZpc2hhbCBWZXJtYSA8dmlzaGFsLmwudmVybWFAaW50ZWwuY29tPg0KPiAN
Cj4gTEdUTQ0KPiANCj4gUmV2aWV3ZWQtYnk6IERhbiBXaWxsaWFtcyA8ZGFuLmoud2lsbGlhbXNA
aW50ZWwuY29tPg0KDQpUaGFua3MgRGFuDQoNCj4gDQo+ID4gLS0tDQo+ID4gDQo+ID4gYmFzZS1j
b21taXQ6IDhmNGU0MmMwYzUyNmU4NWIwNDVmZDAzMjlkZjdjYjkwNGY1MTFjOTgNCj4gPiBwcmVy
ZXF1aXNpdGUtcGF0Y2gtaWQ6IGFjYzI4ZmVmYjY2ODBjNDc3ODY0NTYxOTAyZDE1NjBjMzAwZmE0
YTkNCj4gPiBwcmVyZXF1aXNpdGUtcGF0Y2gtaWQ6IGM3NDljMzMxZWI0YTUyMWM4ZjBiMDgyMGUz
ZGRhN2FjNTIxOTI2ZDANCj4gPiBwcmVyZXF1aXNpdGUtcGF0Y2gtaWQ6IDlmYzdhYzRmZTI5Njg5
YjljNGRlMDA5MjRhOWU0NTVjZDliNThkNTMNCj4gPiBwcmVyZXF1aXNpdGUtcGF0Y2gtaWQ6IGUw
MTlmMmM4NzNhYzFiOTNkODBiOWMyNjAzMzZlNWQzZjQ2YjA5MjUNCj4gPiBwcmVyZXF1aXNpdGUt
cGF0Y2gtaWQ6IGI2OWVjYzlkNjhjZTVlN2M3OWI2MmNlYTI1NzY2MzUxOWY2MzBkYTINCj4gPiBw
cmVyZXF1aXNpdGUtcGF0Y2gtaWQ6IDkyOGEzMmY0YzFmZjg0NGRmODA5Y2NmMWFiYTgzMTVjYWM3
MjNkOTMNCj4gPiBwcmVyZXF1aXNpdGUtcGF0Y2gtaWQ6IGFlMjlmMjNjZWRmNTI5ZGExZmU4ZTM5
ZjhjZGUxZGY4MjdkNzVmYTENCj4gPiBwcmVyZXF1aXNpdGUtcGF0Y2gtaWQ6IGYzZDhmYzU3NWY1
YWZlZDY1YmU4YTdiNDg2OTYyZTgzODRlYWJjMWENCj4gPiBwcmVyZXF1aXNpdGUtcGF0Y2gtaWQ6
IDc0ODU5ZjQzMzAyZGNjNDQyZGZiMWUyOWY2YmFiYWQ3NWQyMjliZjENCj4gPiBwcmVyZXF1aXNp
dGUtcGF0Y2gtaWQ6IDY5NmMyZDVjYWYwYmQ0ZWFjNjQ1MDM1ZjcyYTcwNzdlZmJmM2U2Y2QNCj4g
PiBwcmVyZXF1aXNpdGUtcGF0Y2gtaWQ6IGUzZWY3ODkzYTFkZjllY2M2Yjc2ZGVlNzhmMmIyN2Nj
OTMzYWQ4OTENCj4gDQo+IGdpdC1zZW5kLWVtYWlsIGFkZHMgdGhpcyBieSBkZWZhdWx0IG5vdz8N
Cg0KSSB0aGluayBJIGtub3cgd2h5IGdpdC1mb3JtYXQtcGF0Y2ggYWRkZWQgdGhlbS4uIEkgaGFk
IC0tYmFzZSB0dXJuZWQgb24NCnZpYSBnaXRjb25maWcuIEkgZGlkbid0IG1hbnVhbGx5IHNwZWNp
ZnkgdGhlIGJhc2UsIHNvIGl0IHRyaWVkIHRvDQpkZWR1Y2UgaXQgdXNpbmcgQHVwc3RyZWFtLCBi
dXQgdGhlIHVwc3RyZWFtJ3MgcmVtb3RlIHdhc24ndCBmZXRjaGVkLCBzbw0KaXQgdXNlZCB0aGUg
bGFzdCBrbm93biBwb2ludCBpbiB0aGUgbG9jYWwgaGlzdG9yeS4NCg0KSSBqdXN0IGRpZCBhIGdp
dCBmZXRjaCAtLWFsbCwgYW5kIGZvcm1hdC1wYXRjaCAtMSBhZ2FpbiwgYW5kIG5vdyBpdA0Kb25s
eSBnZW5lcmF0ZXMgdGhlIGJhc2UtY29tbWl0IGFzIHlvdSdkIGV4cGVjdC4gTGVzc29uIC0gZmV0
Y2ggeW91cg0KcmVtb3RlcyBmcmVxdWVudGx5IDopICBUaGUgd2hvbGUgdGhpbmcgd2FzIGEgc2lk
ZSBlZmZlY3Qgb2YgdXNpbmcgYQ0KaGFjayBmb3IgbXVsdGlwbGUgcHVzaC11cmxzIGluIGEgc2lu
Z2xlIHJlbW90ZS4NCg==
