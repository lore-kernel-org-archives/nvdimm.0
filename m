Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BEF31C3F
	for <nvdimm@lists.linux.dev>; Wed, 24 Aug 2022 23:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661383702; x=1692919702;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=YI2qsUlNG2KJt8/FSac+IA2UtJhwD2aFTjOcvfjmT9Y=;
  b=X+NZcTD1xRkhWpwUO6SiiOqngYVquy3PcS4G07xuWp1Kg1qo0jBk0d2M
   bgsaw+pzoYSP3zRf2yx7OSp+IMikdTo74lnAAHUcx4NdqyQZCo0l6CrKl
   TM2uYf3BQOApznqYehWUFZi1ovnfIzpoz5SIwbQMn8hQPlW1Te4sVuZii
   LtocXrlVhB3OabWu7/qZePmVRozUHOPt9WOi5u+SwOpAKLjdb6OdATaj6
   INsg1QlOrvzOtpQ9bnGESLh+0WJpHifgHwsRzxFZEhmNwFVamh+qkm7YG
   679thyK0ZZfv+tGajdBedHsL1xCym/xBFeOT6g1Zi/K1B5QFWEWClJWRT
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10449"; a="358071536"
X-IronPort-AV: E=Sophos;i="5.93,261,1654585200"; 
   d="scan'208";a="358071536"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2022 16:28:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,261,1654585200"; 
   d="scan'208";a="938098105"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga005.fm.intel.com with ESMTP; 24 Aug 2022 16:28:21 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 24 Aug 2022 16:28:20 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 24 Aug 2022 16:28:20 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 24 Aug 2022 16:28:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EjIScMlUkhpFjOlKYv3OVnG+oMtiMvsPAwEI7m5gzLphlnnOYU7ETmebAvwJw9Gnpr+3PRMfM2uI4in49XX8vDSTSC/Yjm2grntuYIdbB+8Gxo9htD6jTYWOfCNG3VPHictDW5IeJMKLoR3y8FEDZwVrLqLwYa9m2HDYLvgMv23sWVHr7Jw8Eq14s7fBr+EAbIXcjZeJ73LBa0QOkULyW6Erb4/m4Rkj73GIx8zcOm6jca0ZPTtIIfY2bK0Z2xMCPKdQAUnzhXVBz+SQ2dd+yhLJpHx6SNIZaJX8XHccc2x+CrD/T78dFDKVSafyBjgs0EmLp1tD70ZOVR0ZiaB17A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YI2qsUlNG2KJt8/FSac+IA2UtJhwD2aFTjOcvfjmT9Y=;
 b=Icaf6yPPsxCSqz7i8GxpD7LcFamnFqjBZcJefTo/SIHAgy52ScONBkTroAkDJO6jnAslgnEDtJ1v/HtiN+mmTivlmeLt9tqo4OOEkaBrK9mkEKcpFCU1amA24Pf+o1Lcl/EF2mQSUKbUVDyVzSYPdFpPTHdbWh6KMoZLtbhssGbqTcQ5J6wrIyt+MnCTEFAR9IycT4LJQZOOAM+7Ap/ZROH/xrT+1nO/gV6jRAbBgCLskie0Ig+zgymrSjjN3sGGtvYcx/CCB59lw+TKoiwR+/TGOii2INV33vIEUFTAcIpcYMfcsh/i0jkFyuGVrOYKkg32y+7rydBz5AG+gel3ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by BYAPR11MB3767.namprd11.prod.outlook.com (2603:10b6:a03:fd::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.20; Wed, 24 Aug
 2022 23:28:18 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::2dac:a302:f722:7850]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::2dac:a302:f722:7850%7]) with mapi id 15.20.5566.015; Wed, 24 Aug 2022
 23:28:18 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>, "Schofield, Alison"
	<alison.schofield@intel.com>
CC: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH] cxl/test: Use interleave arithmetic to sort memdevs
 for a region
Thread-Topic: [ndctl PATCH] cxl/test: Use interleave arithmetic to sort
 memdevs for a region
Thread-Index: AQHYuA60z+5gzd9yW0eBdVrOZObU1a2+skEA
Date: Wed, 24 Aug 2022 23:28:17 +0000
Message-ID: <19ba6b1298fdfb5d325a270750445b83a5b6ad82.camel@intel.com>
References: <20220824230958.125906-1-alison.schofield@intel.com>
In-Reply-To: <20220824230958.125906-1-alison.schofield@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4 (3.44.4-1.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4bf651f4-7096-4a5a-7d6b-08da86285345
x-ms-traffictypediagnostic: BYAPR11MB3767:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SvvO/iXEC+1vWkjrJMC0DGoq1M+XLx6P39xw9g+1BXe+0sTrub+f0m1MFrkoDIdbpk/TLrK+1C8uBUuLbfRScEJY9+xPACHLqaOvA6LMQYgnGYUQnoHjsbyDxmnHG+A8PUfjLi4H03l7A1DLYBvGMaS5ngdpmHA13RTtYtA24kijhfHPNm2V47UcDt4S1C+QBR06KqRqyU446Nz22jcGsLGBagf6/hVZGovfrWtT94RbTS/4KBMWX0IHSBkC4Dgqx7inngEan6AjwolXODj2GyMYU6TLHZhttfUDnD++T5LGLBCC9kNvMCpwsJFp2YWpnprR+I9MsIjr3KGmgXW3WRO5OvDxJ4wO0cB52h4/lwhkWP2qywz7vQ/5pEew1AgXOQ2VC7QaecwFGrr9M8dVLbO35vRrPJV00xMe8eeyoVA9Tas7e08+T1ejg4Q7Fy0/UmHljQdqQjrLhBOJxbiBMAXqsBYi2YafVY4E33tfZ3MtYLCp4ff1t8BAPQuHQY7SpOTlfoH2DwZcjRX3qOqkgb1XY08IB/U1qmVE4xzbz130+Ovo9UZfk41VgEBVt1niucss4BglYd3QPqDScnm2moCj+SeOpNL9qrFrheqP1m1VF26euib4csFErtumX2zkSY02IbblJ+gLDbXVwYk/JX4D9jzmGY+7jPKdQjYX4N+47/K02XzbHiB/ueCBCqWj/FWkRietlyauIiJ/waUXnFDucgy9GhcLxLSV4+rM+cjdTPlv/jDeNa9cJQBv6Z5EUhJIEpE7WXgIkQ0u/32OsQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(376002)(39860400002)(136003)(366004)(396003)(41300700001)(6512007)(8936002)(316002)(5660300002)(66446008)(91956017)(71200400001)(478600001)(66556008)(6486002)(64756008)(76116006)(2616005)(86362001)(8676002)(4326008)(66476007)(26005)(66946007)(186003)(83380400001)(82960400001)(6506007)(122000001)(38070700005)(2906002)(54906003)(38100700002)(6636002)(36756003)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WjF0L1VZSlFKbDk3OGVCVkpiRlZ4MHV3RC81N0pOQll2S1pnaEMyNWJqb09C?=
 =?utf-8?B?YlV3K0Fud0oweFJaNllZRjhSN3lmTURHY3RtUFlkQXpEN1lYU3ljcExVT1ZS?=
 =?utf-8?B?RXh4ZzRseUg4RUpwdG9MTFFHSUgxWHAweUxyVmFNemZHMzZRa2M0Z2ZGcmdl?=
 =?utf-8?B?WHFuMEdjdU1OamJVNDFkYnNOek5mVWNBa2RSdjdNaTNZMjBDS0VxN2pQd3NQ?=
 =?utf-8?B?QlhpaTVISUhkT1BnVDlWL0lUOC9NMmF0V3E0K1ZndEdUeWQ5NDVXT2FrVVVz?=
 =?utf-8?B?RGNuaTRsUktJM0I1WUN5eTVuWWhDUnY0QXhzUGRCQ3Rsb0llV1lKdC9JNHhZ?=
 =?utf-8?B?NEVKQ2EwTGdpc2dJMlp2STdmeklGeWFXaFora2JkQUovMDNOOEpydHdsK3Fa?=
 =?utf-8?B?QjVyeUM5TXNlaE5XaEV5SGhlUi80TVlVWWNqbG53REJmZ2M5WjFSa21SblJw?=
 =?utf-8?B?UVg3TWtzeUdickF2WGNlZW1wTkV4K2RtUFJ6TjlVNnVVd1Q1TW1HMTl6OVhX?=
 =?utf-8?B?ZUNPaHNON2hVMm54QkwvTWl2MDdJaTVNSkZ3elZPclVEZk9RTDMwaW9JK3J0?=
 =?utf-8?B?WC9QYXUwYkFkeFlkOXdaRVlUMGNCUDl6UjMzZ3lBTUhjN282YUwyc0NCRVFl?=
 =?utf-8?B?bFVMT0Ftc0Y2dkhuNVJ2K3Vzc1FxaUJ1dWlPTzFsT29QR0hBYUhXZGVyVVMz?=
 =?utf-8?B?QXB6OXF0VUNWRFM3VXhiSi9TL1pFaE9Yc2cyWXhQbVF1Wi9tZzRGbjdBcjRP?=
 =?utf-8?B?dVBRRjhvbEJRcXQyYnRJNW1ENEpNNEZDVlVna2lITmtoV2g0ZTFtTXlLVm53?=
 =?utf-8?B?cG4zcE43VGliM0ppak1aQkJiQXVVZzAwRUZ0MXhWWDNaak5wdEc0ejZNSkZi?=
 =?utf-8?B?K05MeFlJdG5xemZTSndZTGRHVjhRdkQzendQVktUc1dXSUU1aXhuYkpsTldO?=
 =?utf-8?B?bHVQWmVLaHg5Y2xxVGdBOXNJbjlweVdudytxemx5VVduaXhGT1IybERUOXFa?=
 =?utf-8?B?S2dpRUdLZjNUWE11Rm1LT3pEYlQzd3F4Y2xlcEMvem5zRVdEU3kxdVV0ZHV4?=
 =?utf-8?B?UEltcHo2cHJ1V3Q5d1VpNVUzZU5uU0RLQXcvSkhhYkkwWmlDUERPUmpyUUw1?=
 =?utf-8?B?ZWd4eVNUYTJmTExWQnZHQjhwU3E2Wnl4TmxZQVFKQ0dnQUZScVJSU0xHcTh1?=
 =?utf-8?B?WGtoNkp1MzZFbGlJSXhOckJDV0lEdHNVeUhKMWpuUTMwb3FPUFM2aU5nY01T?=
 =?utf-8?B?M1FHc0Z3eUJESWJkUDBsUkRmMVpiWVNxRFdVTTJJOExqVmpQUkpsOXpzeVNF?=
 =?utf-8?B?TVRtcFNGclAvR0tCYmN1cGZWaFNmU1pUREpHRVIzVzdSWTJUdjIxbW1aNWln?=
 =?utf-8?B?SU5uU052VklJdTlFYittN050U1ZpVGVsSWlFSWU2ZXRzRWowbkx5bGZBb3Z5?=
 =?utf-8?B?VXRWcEZ5T2JZTnZsUU9BM0EyQ2NONmRkMm1GdFBVYmNhMTNMYy96ZXNNSnhD?=
 =?utf-8?B?TUx4bW1HVmtENUtMZnFHclI3aUd3WHEwK1ZOb1Q1N2NaWlJYdkw0RTFkMzRz?=
 =?utf-8?B?K2s5RmU3NXkwYkE3VU8zU1NkOUxRZWZ2S01uRVhoYzJtMDZ4aG4wdzEvUHRN?=
 =?utf-8?B?Q1NCMFF4SlI5TU10Vnk4MWRzSDlqYUQ3Q3gzZjhQbytZTnVER3F0NEZ3YlR5?=
 =?utf-8?B?RXBHOGhIMUFpYmhnaTNOd0lXQTNMVkJKMHhQUjBDVWw4Z0NPRENVeWQwWGFL?=
 =?utf-8?B?VE5VQzRaajVKa2pPS0Y1OUQ2bWNjRkYyZ2tNcEpCbnc4VXJ1R1Zmek0vWkhk?=
 =?utf-8?B?d1gzaUNNQmhNWncxL1FDRlBuUDBhNUlKNFlkeHlzTFBHankydjFiVit3TWFB?=
 =?utf-8?B?enQra0pScVFFbHZSUWpRd1BCNVhTR2FTanVlaXNBY2hkc04ydGE4cU9ReGpX?=
 =?utf-8?B?M0VmYWdBb0RvV2hLdW9UNmFNVXBjd0EySEpTaG4rUGdwSVFtWER4VzVvRE1p?=
 =?utf-8?B?U1ZXN1FMS1FtVjRxTFg2Q0JxdmNSakRJSnJJUkdobUtrRUN5UGRJdFRjTHRm?=
 =?utf-8?B?OVUxdHNXeEU5eUpJZVFpS0t3N1ZsSW4wRzliRm1mRHRUZHVFQ1VXLzM5VmFX?=
 =?utf-8?B?M0laL1NEMFdtd2lhWHpWZEs5ZkJSbHJ1OGFxZFpxRGtPUGthdmFXUHJDeUdh?=
 =?utf-8?B?VGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <911C0A0123B743479B2E56CA51799A6E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bf651f4-7096-4a5a-7d6b-08da86285345
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2022 23:28:17.9910
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z0AwI+Dq0B9XaYkYkvuBTjc5Wa3Vk+WIpCHcFyHeyJUW35eJTLqMkZXd8WP0B9zycR3pYJCOZNSlLFiRGSyQvkNb1XlKCtJ0GxFHf4a9RCE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3767
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDIyLTA4LTI0IGF0IDE2OjA5IC0wNzAwLCBhbGlzb24uc2Nob2ZpZWxkQGludGVs
LmNvbSB3cm90ZToNCj4gRnJvbTogQWxpc29uIFNjaG9maWVsZCA8YWxpc29uLnNjaG9maWVsZEBp
bnRlbC5jb20+DQo+IA0KPiBUZXN0IGN4bC1yZWdpb24tc3lzZnMuc2ggYXNzdW1lcyBNb2R1bG8g
YXJpdGhtZXRpYy4gWE9SIGFyaXRobWV0aWMNCj4gaXMgYmVpbmcgaW50cm9kdWNlZCBhbmQgcmVx
dWlyZXMgYSBkaWZmZXJlbnQgb3JkZXJpbmcgb2YgdGhlIG1lbWRldnMNCj4gaW4gdGhlIHJlZ2lv
bi4NCg0KSW5zdGVhZCBvZiAnaXMgYmVpbmcgaW50cm9kdWNlZCcsIG1heWJlIHNvbWV0aGluZyBs
aWtlOg0KDQoiSW4gcHJlcGFyYXRpb24gZm9yIGludHJvZHVjdGlvbiBvZiBYT1IgYXJpdGhtZXRp
YywgYWxsb3cgZm9yIGENCmRpZmZlcmVudCBvcmRlcmluZyBvZiBtZW1kZXZzIGluIHRoZSByZWdp
b24uIg0KDQo+IA0KPiBVcGRhdGUgdGhlIHRlc3QgdG8gc29ydCB0aGUgbWVtZGV2cyBiYXNlZCBv
biBpbnRlcmxlYXZlIGFyaXRobWV0aWMuDQoNCi4uYW5kIHRoZW4gdGhpcyBzZW50ZW5jZSBjYW4g
YmUgZHJvcHBlZC4NCg0KPiBJZiB0aGUgaW50ZXJsZWF2ZSBhcml0aG1ldGljIGF0dHJpYnV0ZSBm
b3IgdGhlIHJvb3QgZGVjb2RlciBpcyBub3QNCj4gdmlzaWJsZSBpbiBzeXNmcywgZHJpdmVyIHN1
cHBvcnQgZm9yIFhPUiBtYXRoIGlzIG5vdCBwcmVzZW50LiBEZWZhdWx0DQo+IHRvIE1vZHVsbyBz
b3J0aW5nIG9yZGVyLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQWxpc29uIFNjaG9maWVsZCA8YWxp
c29uLnNjaG9maWVsZEBpbnRlbC5jb20+DQo+IC0tLQ0KPiDCoHRlc3QvY3hsLXJlZ2lvbi1zeXNm
cy5zaCB8IDQ0ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0NCj4gwqAx
IGZpbGUgY2hhbmdlZCwgMzYgaW5zZXJ0aW9ucygrKSwgOCBkZWxldGlvbnMoLSkNCj4gDQo+IGRp
ZmYgLS1naXQgYS90ZXN0L2N4bC1yZWdpb24tc3lzZnMuc2ggYi90ZXN0L2N4bC1yZWdpb24tc3lz
ZnMuc2gNCj4gaW5kZXggYWUwZjU1NjUzODE0Li4xYWYwYWU3ZTYzMmMgMTAwNjQ0DQo+IC0tLSBh
L3Rlc3QvY3hsLXJlZ2lvbi1zeXNmcy5zaA0KPiArKysgYi90ZXN0L2N4bC1yZWdpb24tc3lzZnMu
c2gNCj4gQEAgLTU4LDE1ICs1OCw0MyBAQCByZWFkYXJyYXkgLXQgbWVtX3NvcnQxIDwgPCgkQ1hM
IGxpc3QgLU0gLXAgJHBvcnRfZGV2MSB8IGpxIC1yICIuW10gfCAubWVtZGV2IikNCj4gwqANCj4g
wqAjIFRPRE86IGFkZCBhIGN4bCBsaXN0IG9wdGlvbiB0byBsaXN0IG1lbWRldnMgaW4gdmFsaWQg
cmVnaW9uIHByb3Zpc2lvbmluZw0KPiDCoCMgb3JkZXIsIGhhcmRjb2RlIGZvciBub3cuDQo+ICsN
Cj4gKyMgU29ydCBiYXNlZCBvbiByb290IGRlY29kZXIgaW50ZXJsZWF2ZSBhcml0aG1ldGljLg0K
PiArIyBEZWZhdWx0IHRvIE1vZHVsbyBpZiB0aGUgc3lzZnMgYXR0cmlidXRlIGlzIG5vdCBlbWl0
dGVkLg0KPiAraWYgWyAhIC1lIC9zeXMvYnVzL2N4bC9kZXZpY2VzLyRkZWNvZGVyL2ludGVybGVh
dmVfYXJpdGhtZXRpYyBdOyB0aGVuDQo+ICvCoMKgwqDCoMKgwqDCoGlhPSIwIg0KPiArZWxzZQ0K
PiArwqDCoMKgwqDCoMKgwqBpYT0kKGNhdCAvc3lzL2J1cy9jeGwvZGV2aWNlcy8kZGVjb2Rlci9p
bnRlcmxlYXZlX2FyaXRobWV0aWMpDQo+ICtmaQ0KPiArDQo+IMKgbWVtX3NvcnQ9KCkNCj4gLW1l
bV9zb3J0WzBdPSR7bWVtX3NvcnQwWzBdfQ0KPiAtbWVtX3NvcnRbMV09JHttZW1fc29ydDFbMF19
DQo+IC1tZW1fc29ydFsyXT0ke21lbV9zb3J0MFsyXX0NCj4gLW1lbV9zb3J0WzNdPSR7bWVtX3Nv
cnQxWzJdfQ0KPiAtbWVtX3NvcnRbNF09JHttZW1fc29ydDBbMV19DQo+IC1tZW1fc29ydFs1XT0k
e21lbV9zb3J0MVsxXX0NCj4gLW1lbV9zb3J0WzZdPSR7bWVtX3NvcnQwWzNdfQ0KPiAtbWVtX3Nv
cnRbN109JHttZW1fc29ydDFbM119DQo+ICtpZiBbICRpYSA9PSAiMCIgXTsgdGhlbg0KDQpJZiB1
c2luZyAnPT0nIHRoaXMgc2hvdWxkIHVzZSB0aGUgJ2lmIFtbJyBiYXNoLXN0eWxlIGNoZWNrLCBv
dGhlcndpc2UNCndpdGggYSBzaW5nbGUgJ1snLCB0aGUgdGVzdCBzaG91bGQgdXNlICctZXEnIChh
bmQgcXVvdGUgdGhlIHZhcmlhYmxlIGluDQp0aGlzIGNhc2UpLg0KDQppLmUuIGVpdGhlcg0KDQog
IGlmIFtbICRpYSA9PSAiMCIgXV07IHRoZW4gLi4uDQoNCm9yDQoNCiAgaWYgWyAiJGlhIiAtZXEg
IjAiIF07IHRoZW4gLi4uDQoNCldlIGhhdmUgYmFzaCBhc3N1bXB0aW9ucyAoaS5lLiBub3QgcmVz
dHJpY3RlZCB0byBwb3NpeCBzaCkgZXZlcnl3aGVyZQ0KYWxyZWFkeSwgc28gdGhlIGZpcnN0IG9u
ZSBpcyBwcmVmZXJhYmxlLg0KDQo+ICvCoMKgwqDCoMKgwqDCoCMgTW9kdWxvIEFyaXRobWV0aWMN
Cj4gK8KgwqDCoMKgwqDCoMKgbWVtX3NvcnRbMF09JHttZW1fc29ydDBbMF19DQo+ICvCoMKgwqDC
oMKgwqDCoG1lbV9zb3J0WzFdPSR7bWVtX3NvcnQxWzBdfQ0KPiArwqDCoMKgwqDCoMKgwqBtZW1f
c29ydFsyXT0ke21lbV9zb3J0MFsyXX0NCj4gK8KgwqDCoMKgwqDCoMKgbWVtX3NvcnRbM109JHtt
ZW1fc29ydDFbMl19DQo+ICvCoMKgwqDCoMKgwqDCoG1lbV9zb3J0WzRdPSR7bWVtX3NvcnQwWzFd
fQ0KPiArwqDCoMKgwqDCoMKgwqBtZW1fc29ydFs1XT0ke21lbV9zb3J0MVsxXX0NCj4gK8KgwqDC
oMKgwqDCoMKgbWVtX3NvcnRbNl09JHttZW1fc29ydDBbM119DQo+ICvCoMKgwqDCoMKgwqDCoG1l
bV9zb3J0WzddPSR7bWVtX3NvcnQxWzNdfQ0KPiArDQo+ICtlbGlmIFsgJGlhID09ICIxIiBdOyB0
aGVuDQoNCnNhbWUgaGVyZSBhcyBhYm92ZS4NCg0KPiArwqDCoMKgwqDCoMKgwqAjIFhPUiBBcml0
aG1ldGljDQo+ICvCoMKgwqDCoMKgwqDCoG1lbV9zb3J0WzBdPSR7bWVtX3NvcnQxWzBdfQ0KPiAr
wqDCoMKgwqDCoMKgwqBtZW1fc29ydFsxXT0ke21lbV9zb3J0MFswXX0NCj4gK8KgwqDCoMKgwqDC
oMKgbWVtX3NvcnRbMl09JHttZW1fc29ydDFbMl19DQo+ICvCoMKgwqDCoMKgwqDCoG1lbV9zb3J0
WzNdPSR7bWVtX3NvcnQwWzJdfQ0KPiArwqDCoMKgwqDCoMKgwqBtZW1fc29ydFs0XT0ke21lbV9z
b3J0MVsxXX0NCj4gK8KgwqDCoMKgwqDCoMKgbWVtX3NvcnRbNV09JHttZW1fc29ydDBbMV19DQo+
ICvCoMKgwqDCoMKgwqDCoG1lbV9zb3J0WzZdPSR7bWVtX3NvcnQxWzNdfQ0KPiArwqDCoMKgwqDC
oMKgwqBtZW1fc29ydFs3XT0ke21lbV9zb3J0MFszXX0NCj4gK2Vsc2UNCj4gK8KgwqDCoMKgwqDC
oMKgIyBVbmtub3duIEFyaXRobWV0aWMNCj4gK8KgwqDCoMKgwqDCoMKgZWNobyAiVW5rbm93biBp
bnRlcmxlYXZlIGFyaXRobWV0aWM6ICRpYSBmb3IgJGRlY29kZXIiDQo+ICvCoMKgwqDCoMKgwqDC
oG1vZHByb2JlIC1yIGN4bC10ZXN0DQo+ICvCoMKgwqDCoMKgwqDCoGV4aXQgMQ0KDQpUaGlzIHNo
b3VsZCB1c2UgdGhlICdlcnIgIiRMSU5FTk86IG90aGVyLXN0dWZmIicgcGF0dGVybiByYXRoZXIg
dGhhbg0KZWNobyArIGV4aXQuDQoNCj4gK2ZpDQo+IMKgDQo+IMKgIyBUT0RPOiB1c2UgdGhpcyBh
bHRlcm5hdGl2ZSBtZW1kZXYgb3JkZXJpbmcgdG8gdmFsaWRhdGUgYSBuZWdhdGl2ZSB0ZXN0IGZv
cg0KPiDCoCMgc3BlY2lmeWluZyBpbnZhbGlkIHBvc2l0aW9ucyBvZiBtZW1kZXZzDQo+IA0KPiBi
YXNlLWNvbW1pdDogYzljOWRiMzkzNTRlYTBjM2Y3MzczNzgxODYzMThlOWI3OTA4ZTNhNw0KDQo=
