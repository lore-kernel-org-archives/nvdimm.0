Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA58A72
	for <nvdimm@lists.linux.dev>; Wed, 11 Aug 2021 19:02:07 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10073"; a="214931806"
X-IronPort-AV: E=Sophos;i="5.84,313,1620716400"; 
   d="scan'208";a="214931806"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2021 12:01:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,313,1620716400"; 
   d="scan'208";a="507187041"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 11 Aug 2021 12:01:32 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 11 Aug 2021 12:01:32 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Wed, 11 Aug 2021 12:01:32 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Wed, 11 Aug 2021 12:01:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f5WA7ZDUijR5RnmcKVMkYHpKOTQ2HYpTfRXTzNVsyxACa26+D8e1Xsy3IHiEVSChGyGpEBK9d1Q0i+a0xCICpmJldVsP6fPRMHM82d90CZc4h2iKR1QgZb3YCKgt+hW5G9bDzX0RXYznjvx3TMEKrQ7G4yIlGQtP5kH0gEbhrR17lK/z3VSBnFmLu/NJwczqv4gNCqozEkn/iPcuTATlEhDvai1kNRjo835KIatvjoib26I/pflLBFCt0KR/NcB6x0xFfxBPruZ3MM5BC4fU68WMfBcetRGsAU12tWaLlnaRjFbZzSW9MuRtnVjeA5sESNdcAP/Oy8+3+QHkiLyHGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QSv/esY67rLQ12ziw0F4W+hBCeDiqwu0pmoumICUsxU=;
 b=MsEjqOdUjsOyX+XdXhcKN9Sm7jQjRzOuteVHQBso1bNOiyCiYQxeaZfl9cDw0Psevrgar+Qyv9pbVhOUATeGVF7Cs/xG4UXZbmO+z4o11V59yoZAq8F8TO3f980WG3uxmChrrHvr6Wp2VR23g2EhQRZpgplEhdW1WF74daG9KlUlohbVRLNbLgzsxNVIAs0V246nDwS1ROBMNylhCvCLGtpqQ9o8Of4qlYC9Lb5WtP8xtdG3+3VYqLFC4ZPvuPR6z9d55bxGnjPb4dbZRLiCoaYAPdENZiqXlYHzZda4mG1MPUPh4nDiAdSiqL4w7GH+ec7l9LiwNa037IaeXBxo3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QSv/esY67rLQ12ziw0F4W+hBCeDiqwu0pmoumICUsxU=;
 b=a+pDLGLw46VvKkHrjFt2XixSYt1hq7pw2n4dLnkS+E575GtKzcvFjuYoOWYuv6k1Zl08Qs6LmyAf8KCDFFnmlgHQ+bM1x21pDUyNY2NjRGuDbORrdcnD/lzAIlIHxZzf9mF6aumjQUXmAxKxjL7qtMzxn0WUZ49Ax7A/x+E6LVM=
Received: from SN6PR11MB3184.namprd11.prod.outlook.com (2603:10b6:805:bd::17)
 by SN6PR11MB3373.namprd11.prod.outlook.com (2603:10b6:805:c6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.19; Wed, 11 Aug
 2021 19:01:28 +0000
Received: from SN6PR11MB3184.namprd11.prod.outlook.com
 ([fe80::4046:c957:f6a9:27db]) by SN6PR11MB3184.namprd11.prod.outlook.com
 ([fe80::4046:c957:f6a9:27db%5]) with mapi id 15.20.4394.023; Wed, 11 Aug 2021
 19:01:28 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"peterz@infradead.org" <peterz@infradead.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "Yu, Fenghua"
	<fenghua.yu@intel.com>, "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com"
	<hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>, "Lutomirski, Andy"
	<luto@kernel.org>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH V7 14/18] memremap_pages: Add memremap.pks_fault_mode
Thread-Topic: [PATCH V7 14/18] memremap_pages: Add memremap.pks_fault_mode
Thread-Index: AQHXiOnGUYGkWqNytUWRPivZN1JaaKtutL+A
Date: Wed, 11 Aug 2021 19:01:28 +0000
Message-ID: <506157336072463bf08562176eff0bb068cd0e9d.camel@intel.com>
References: <20210804043231.2655537-1-ira.weiny@intel.com>
	 <20210804043231.2655537-15-ira.weiny@intel.com>
In-Reply-To: <20210804043231.2655537-15-ira.weiny@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8658dfb8-4821-4534-77ee-08d95cfa6c93
x-ms-traffictypediagnostic: SN6PR11MB3373:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB337352EE427C7D789B5FE669C9F89@SN6PR11MB3373.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: i3jwd68ioDFheVb9pXyG1BdfQUbgqrXw2ahYIFLNExrHoklGML8NNkZFFKFZhpWsNFnOwdDcQR7IWfyfeyqq2L0hHR8UEgYfGoNhzvxO48fKYSTF3cSlsVNFuBtj0oWW9A/HuCMlOo5bpNHKcocxavdNIIGFgMC/KENLjHrgcxEsKlOyNI0xdvAHGBs5Gz+kRpFdvCfvLoIRcPH5/UHznIbCib53OQuuBuIvBJD154WVxLFlOg+tf/00H7ggCdmQw4Fm8Uf+vWp97rpIJQh7J9plOEkv0WtBO4hl68+IFikysoILdbvzsnKVYSjptAFAC/kpQV9UDyF+R0lrW/TDrs9dmuSnpMYlhUWbFYMFiWRoylLgcSDJSa5miXl5TyiHoVRKJbSd5/bbI1KOJTmXCQQA5xJ69vNnpVHinRUpTrT6wusWBASDjht8pALIAc2UlVP2Natc+i3XBOZt1ZX1VD4G4aatAL+ASnyWa7iTI9xasTsO334P1+8ta2bGDGArwBMxHmM1YTvi99ysBxOCXeeF9AmF5k2S1LesctIftr62ZFQyDHngtVzeEdK14EgCVnJEjP17PEDzJG/WywMJssd1PLfx9CDLS1bohpxKCyMF++II+xH+vExVhL6gMoei7xWDLb6f1rTGErJOk4HCYpembKzxFuZS10ZSQzx9WTsqg9sSU53fwIN3OLaP5Lw9h7maDCvN8joIlmW+LqgmhbW4QHbHAiGnNGfA+28EKCs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3184.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(396003)(39860400002)(376002)(346002)(38100700002)(38070700005)(122000001)(54906003)(110136005)(316002)(6512007)(2616005)(6486002)(6506007)(36756003)(26005)(8936002)(8676002)(7416002)(186003)(86362001)(66556008)(64756008)(66446008)(5660300002)(76116006)(91956017)(66946007)(71200400001)(4744005)(4326008)(66476007)(2906002)(478600001)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VjR0UGJEdVNGbEpDclQ1eExRbGcxekR0TFlzTi9ZSkhUc1RqQkpUQmlNZ1NR?=
 =?utf-8?B?VVJFWENDS2hERlJ6TFpSeElaTDdDazNTK1Vhc3EvSmZ1QWpycmVzdm1OOGJD?=
 =?utf-8?B?WGlRb2xCL05aWnYzL0hxZkNMdWJlK2hFWFpQcmFDanpzUEdzOHZMNW13ZXc3?=
 =?utf-8?B?WnFFMXZvRXp0RHVuT2NmUFRiQkJCQzd5bWJleCtRTTlSZW92a3dFbUhHa2lF?=
 =?utf-8?B?blZOOVZKa0FUL2RDOTNSQWhjTmQxR2pMWHBZdFl5dGVneXhhM0NsaUo0QzFw?=
 =?utf-8?B?bUJET0J6OEpYOVhnVVhLeVlRL25oV0lJbUVWT2Z3Z0l4c0Jtb3dKUGtwakVm?=
 =?utf-8?B?RkNHTGJvVm16aVU1Q200bHBValN2VnowUjYrclJkaDJlMkxQMVFJcXpiUXZY?=
 =?utf-8?B?MmErb3llYmdua3JEUmJxUzBIU1psQjlwT1RhNEFzanJIbURaZmN6d3VoTkFG?=
 =?utf-8?B?aTdoK2J5TjNYUHZ4Q1Y4TnlaankybG81b2pKUzV3NnZMQWV2M0dsRkRWanZu?=
 =?utf-8?B?VjNzVmhPWGJQR292ZnIrUjRsb0hDM2JYUi9ITjV2VzViV09XUWUydkV1ZUJo?=
 =?utf-8?B?WjBTUnh3ZExOQ3pMdzFDMG5yeUUrNlZQQytkeVJRdEtCVFp2OGVSUGw2bm9V?=
 =?utf-8?B?UjdMajczRkxBWTVYdThaMUErZWt6S0t3NFI2UmNJVjdZUEVkUWlQOEFDazlh?=
 =?utf-8?B?WWZIaWxZTXFGd2JFSnZlVzhndFRJZzV0UkJVUHZEaXRYY1ZEMzR4Nkk1RVlq?=
 =?utf-8?B?L3FrRlNrbE56QUxNZ0IvOFVMQTRnN0hEbHZSRW8xT2pFNU1qRjBJdGlzN0RS?=
 =?utf-8?B?Qllzc1JuZk15aDlKV2FSWlZYOWJiT2xJS25PTkczUFRmRjdIV25sYXc2RnBy?=
 =?utf-8?B?NUZnNENMMm9pS0pjOENjc09PNXZ4dWU2b2gxTTJYd3BxUjV6aHk5MGxyV04y?=
 =?utf-8?B?cmZkRXhQNkdERWNJSUl2S0psRGlFRGJBNnZnUE50YmF4anNlN3N0UnJvc2hR?=
 =?utf-8?B?RTVXOUZYSGptcm1YYTQrSHRwRzE2V2Jid3l5emdnRmorWERaY2lxVUpWVFFm?=
 =?utf-8?B?Q2RhU3BxQ212dVkvUGFLajBGY0R5bGhMdS9Va2JKVnlaK01ZRzA1VmhPUHY0?=
 =?utf-8?B?RjdmVlp2VVJBV2ZRNms2WHd2ZWI5SDdIckVzbWxuRXZGQTVYeVFGd3hXaDV0?=
 =?utf-8?B?ck1uTjZGd3hVK2tIYTVxN3RNeHNHbERvSDArMGxQaGIwZnFvdWtZR3hjSXYx?=
 =?utf-8?B?U09KY2dLT2tWWmxDT0wreHh2TkV1NDhxb2VZUVBraW5PWU5OS0czR25ZRGlq?=
 =?utf-8?B?M0NqcUZOWUZvdjBUUko4eDlZQzE5YjYwTWMxWE1lQ0IxQk44aTV6SVJ1WU14?=
 =?utf-8?B?TnFXN1FHQytyWXRvaDVlRm5SY0JQWGcrdFJIS0E4VlNPV1pNZUpZK2d0aWdv?=
 =?utf-8?B?eHlHaHM0RzJiNjV3Z2REdUN0ME92TFgxZ0VWN2wzaWd4Q2d5ZnQzcFZtZGt4?=
 =?utf-8?B?OUoxU2c2Rm1zS2hJeFJocU8wOW1jTzBCbGFpdXRnSThXajVWNk94ZnB1NDhk?=
 =?utf-8?B?K2JFbG8xNlh1alRmTlVxNjMrcHR4L244NEVvRGpaQXFGeTNLZk5zU09UcEdp?=
 =?utf-8?B?Q1puS3dRK1A3T2ZKM0RJenV3U2tzTkxWUEhhVktveFRhN1g3ZmFxUlZZdits?=
 =?utf-8?B?R0ttbHVkazFpOTdYKzBnVnJtVi9xK1JlNzFjVWNtVS9oS3UvbDlndzl1aU9F?=
 =?utf-8?B?b1NBOFpQUEN3c2NYK2xIU3JFUzc0Q05Yb3BVeU00ZFhpeHlub0hoQzVnaXAy?=
 =?utf-8?B?c280R2xwb1pmTEZWMUtVQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B51228A67964D941856EEA3812FF512F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3184.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8658dfb8-4821-4534-77ee-08d95cfa6c93
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2021 19:01:28.1539
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7XJ1UbfoaH3scvQhTndvVwtn1nIx9WgwJ+p12Vtpk2gnrGr9veTkDDxY0IYjgfIyISWp2Insl2SiXDleZsPVQZKD0XikC/pgX7JzpqNMRMQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3373
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDIxLTA4LTAzIGF0IDIxOjMyIC0wNzAwLCBpcmEud2VpbnlAaW50ZWwuY29tIHdy
b3RlOg0KPiArc3RhdGljIGludCBwYXJhbV9zZXRfcGtzX2ZhdWx0X21vZGUoY29uc3QgY2hhciAq
dmFsLCBjb25zdCBzdHJ1Y3QNCj4ga2VybmVsX3BhcmFtICprcCkNCj4gK3sNCj4gKyAgICAgICBp
bnQgcmV0ID0gLUVJTlZBTDsNCj4gKw0KPiArICAgICAgIGlmICghc3lzZnNfc3RyZXEodmFsLCAi
cmVsYXhlZCIpKSB7DQo+ICsgICAgICAgICAgICAgICBwa3NfZmF1bHRfbW9kZSA9IFBLU19NT0RF
X1JFTEFYRUQ7DQo+ICsgICAgICAgICAgICAgICByZXQgPSAwOw0KPiArICAgICAgIH0gZWxzZSBp
ZiAoIXN5c2ZzX3N0cmVxKHZhbCwgInN0cmljdCIpKSB7DQo+ICsgICAgICAgICAgICAgICBwa3Nf
ZmF1bHRfbW9kZSA9IFBLU19NT0RFX1NUUklDVDsNCj4gKyAgICAgICAgICAgICAgIHJldCA9IDA7
DQo+ICsgICAgICAgfQ0KPiArDQo+ICsgICAgICAgcmV0dXJuIHJldDsNCj4gK30NCj4gKw0KDQpM
b29rcyBsaWtlICFzeXNmc19zdHJlcSgpIHNob3VsZCBiZSBqdXN0IHN5c2ZzX3N0cmVxKCkuDQo=
