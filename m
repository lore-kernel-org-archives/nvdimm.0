Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B9B372
	for <nvdimm@lists.linux.dev>; Tue, 13 Jul 2021 21:17:36 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10044"; a="210221105"
X-IronPort-AV: E=Sophos;i="5.84,237,1620716400"; 
   d="scan'208";a="210221105"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2021 14:17:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,237,1620716400"; 
   d="scan'208";a="503485005"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga002.fm.intel.com with ESMTP; 13 Jul 2021 14:17:35 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Tue, 13 Jul 2021 14:17:34 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Tue, 13 Jul 2021 14:17:34 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Tue, 13 Jul 2021 14:17:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dvt1KNI0XNiygzteU6SRjk4qkUAnMiR7v1RibVN6hWG4ck0FEkRJosaMRGb8X4qMwdpwzz+3VL5ZeDwdxqxCmxwW9acmxDhLpxBLZl80NE4BuiWdy5QuNVhx8R2Emoca1mcRtqHmeE0WqRZlvywh08iiynePoVRmnEqDng9qd6uogTfHIqHZlOxX8SLm+zC4PBn35yBon5VJoplj0TWlWFmWgYO/VdLFQ3E0BZUgZjRA92mzfIMyz2dPxoH5uygRSAu5eXDWhqd2FFxDMyotdo7/OIPz9Bna2SROoy4A2RbKULJL2lLMj6dFrRXt8f3bCC381B19ltY+aE/ofQIo/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oK6+VXIKV573jDiVVldpXChTFkHa1crZ3pFwISwk2vk=;
 b=NJi+5b8/a9BTFwxhvUme/zhbDfvOWSiAHEcF3PwCwUIu3ogVuybBYJeaWXloELaSZDOmSOGKlCbBtLv6Wmp4fYslK8TfdadTAUjc3uys/W+XEp8bywnehY6SmMtoV0LwEiO0d9jLMjYsNgS2HlMx0sIziiKhFv7eEhn7OryOkWXtYcudx9UBMoXGv27gCSKEnd3OlhZCxC94bjDeC/pU37NsM1b82YKGcw0r0e2nQ3kCl8izQdM2XnJy2lXbpV2nXuZN3WtqLRR6GXQNnGeSSJXkun676aLiI4sLL5EeR0eoVxu4TK3HGgUpP7k9ojZq+y5XqxzmIuoUJX7/OCQIdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oK6+VXIKV573jDiVVldpXChTFkHa1crZ3pFwISwk2vk=;
 b=M2It8oAizeepbF6gkxHuH3gQs4f5KrXGKKEFYVrXWzk7buKBvTfw9fNTAD7ZNr3WNzx3gdUJek274CMqTv5zr9SiXUgX+nn6b74+I3769GjpN0kpQ7GMu1h+Mp32cqy0A6dvsmMyp1+bVb6bH6s7LxtQKY1HWY95Im6nAy6LmS4=
Received: from BYAPR11MB3448.namprd11.prod.outlook.com (2603:10b6:a03:76::21)
 by SJ0PR11MB4928.namprd11.prod.outlook.com (2603:10b6:a03:2d2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.21; Tue, 13 Jul
 2021 21:17:33 +0000
Received: from BYAPR11MB3448.namprd11.prod.outlook.com
 ([fe80::de7:9279:792c:4d75]) by BYAPR11MB3448.namprd11.prod.outlook.com
 ([fe80::de7:9279:792c:4d75%3]) with mapi id 15.20.4308.027; Tue, 13 Jul 2021
 21:17:33 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "Widawsky, Ben" <ben.widawsky@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>, "Schofield, Alison" <alison.schofield@intel.com>,
	"Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [ndctl PATCH v3 04/21] libcxl: add support for command query and
 submission
Thread-Topic: [ndctl PATCH v3 04/21] libcxl: add support for command query and
 submission
Thread-Index: AQHXbrUipKLQn4g4tUSnS7BGG4uLjqtAbgYAgAENiwA=
Date: Tue, 13 Jul 2021 21:17:32 +0000
Message-ID: <14151c2efffe947103b881da5bbf38212786aa59.camel@intel.com>
References: <20210701201005.3065299-1-vishal.l.verma@intel.com>
	 <20210701201005.3065299-5-vishal.l.verma@intel.com>
	 <CAPcyv4iyhpSYkDKYDjWP61PaahtZrn3pGh7NnfC6jDaNbVEu+w@mail.gmail.com>
In-Reply-To: <CAPcyv4iyhpSYkDKYDjWP61PaahtZrn3pGh7NnfC6jDaNbVEu+w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.40.2 (3.40.2-1.fc34) 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 23a81616-0064-4883-2eb1-08d94643a132
x-ms-traffictypediagnostic: SJ0PR11MB4928:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR11MB49287DF602B02E97461328B0C7149@SJ0PR11MB4928.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SpkZrxWL1UApv459agFHBc/sgwP9RJ+EQrcsqcAeJLrMV2/FPJaL5It0O9wKocxyEo5wm8n1i655bHN58+t6HMOa14xk2mjMosoJ5Oaqaf7YQ4pGVNu5aqeVbVn4yqvuCc1dDrZ3/WhAKL9ELxEr33wqOkZGWGn61zw3WvQxRLQ5I2obcMU/jPNlaXaQrX5PvpW7ZIHGRvk50I10huwNahz9lZtB+AV3vpANR4/DkHygEqOSbCouXkKl2HSvlexwHw1m6eRIEtE5lzU0fRsixGKOW/9SBERayj7cdApJpRIrPcOJffggesoHQOcSxlQJI4m0Dw14OCDM7hycNY7SeJw4YoylVnwLxL1XtMmabk2qkEhdxHvjeHYRR0xz5Fm7iyt6NCSYSioDzXr9sZlHtJOTPDrgD2ewmdXsrjR41XcNMjceWpGho+ezepupJt/yw1eSzArIXU+E5Zbw65yTi2y35Gs+Ju1bL9RFGc2iHT/48ttNtqIaDO6DKQh7Vj4znFx3EaH8zTC7gcbObCTdS6ORYfFezsxvmNDJ2YWN4R5147dvTSM2h+dzJ18TuWsqpBMP6qNSop3lrld/U7nM4XWf3zfBhiZBDeDllfMUmDLQJcMlcwunlbBxK+a27gIgFntiXWcqfqEBskrSAue/VA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3448.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(376002)(39860400002)(346002)(6862004)(122000001)(2906002)(36756003)(54906003)(186003)(66946007)(38100700002)(66476007)(91956017)(83380400001)(478600001)(66556008)(66446008)(76116006)(5660300002)(64756008)(71200400001)(8936002)(6512007)(53546011)(316002)(26005)(37006003)(4326008)(6636002)(6506007)(6486002)(86362001)(8676002)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MVY1RDNSR3hNVU1lV2pLUjkzZ2dtZHVOYVI4MGFpSERYZi84MXE2MkRZSXlN?=
 =?utf-8?B?SWdPQjh0V0xYdFlBVGhwYmovQld3TFlObG82ZjR2Q2M2UG0xdGlRU0lPeG1N?=
 =?utf-8?B?WWNkeUFTam9aOEJEL0Y4ZWFqYU5PeFlva3J4bFlrenluNmFOdkIrdE9EN0VM?=
 =?utf-8?B?Sk9NZ3U4TDBFK29Da2JWVXBrUWtGT3Foc291ZXAvZHMrZ1pxVWI5cUVDdHox?=
 =?utf-8?B?c3dDOUMyLzcxVEVhcUZKdnJpcjBzY1QyR2FvaEJqcHNSeXVzNkVsNS95QTFJ?=
 =?utf-8?B?OGc5bjRjRGRNeVVVV2FpdVhYOWRXZFRmTG5CcTJqb0toeDc4MEZsUkJqdnpZ?=
 =?utf-8?B?TlI1ZGFDbjdSa3FhVm1UR2tnYUF1QTU3V1dtTDBhdnhQNUMrdHFDdkU4eVBt?=
 =?utf-8?B?QlBBbkY4eDMzUVgrSzR3NXRUSzJobDVYaXk3OHlUZVNXOWpCWUlvQjhNTUll?=
 =?utf-8?B?eG13aTl1ZjNobmlLNjRHMkYzNHRQWHpSWnV3SnlRK2Q1NzZkODVEMHZPYnA3?=
 =?utf-8?B?Mm8vMDNmbExPOFFDL1k4ZFZHbG53UG9MY2hTR1V3RldSNzgwS1ltZ1RneGRk?=
 =?utf-8?B?bld6bG9EZ0RaS0hiTXlKTDJ2V3hCc2RLMlZpbGNKZ0xxU2o5d1I4WDE3SFY1?=
 =?utf-8?B?UEdDdVd0SzZ3aE12YS90YTBHSzZhL3U5MktxM1lKY3ZQRFN5UEVNRWh4cnZa?=
 =?utf-8?B?K3MydUNYdWZwWkEvU1Z4Ly9GaTNWanBIN284dEExYzl6UlZaSjlsQXlCMTdt?=
 =?utf-8?B?NkNONmgrbktaaGRKK2tRbzF4MDZDV1grMjNTUTE0Znc5U1ZEZFZLWURCdE5Y?=
 =?utf-8?B?V3pKZHNMK3Z4NmJZTVl3U3I4TmlYU1RML3NnK0N0UWlWY3RQU1FpOGZsZFNO?=
 =?utf-8?B?aHBxcVJhZWI1Q3pyN1FCOXBDZmo3KzdMREJFRWMwekxuTGJUaEpQWFg3UDBr?=
 =?utf-8?B?UVEvOFE1dWdyRmZJU1IwY056VnZ1QkRPNEdTdHZlQVQ4NjQvcEdmSFN1OVNS?=
 =?utf-8?B?M2JCZlRoczEwTXlJVEMyV1dYUWY3bU9PZS80NE9pcVFXL0lJblhLc3lTWFRi?=
 =?utf-8?B?WThkQXFLdm03dVZxSUdSUmhyWm9oQ2twM2drWWFTOHN6MU9TT00zREpkaEVj?=
 =?utf-8?B?b0JNMDVkNXpYRDlkbXQ5cGcrK3Q0NVZFUGl0a2ZrVEtsRHhGZ1NMMit1Wi94?=
 =?utf-8?B?QUxZdW9ZWE5PSW5heGJmWkpVWnFWNFRPdkxFZFNkdHMzT0JMZWM0NEVrSmJk?=
 =?utf-8?B?a08rUXg1VTJMcjZVSUU3L0ZkSzZwRk5ycGp5Qk1JZE9ITzVWaENReUM3cFNY?=
 =?utf-8?B?Q2lCNE45N2FPbW1sWDdFZmpHdlVrM1hlVkR0ODl6ejBvdkJmbkhyOHFwakZD?=
 =?utf-8?B?R3o2bXFXTWxVWmNFNnpkYUlEZzVZZzNNdG5zanVMeE1ybnBhQWViYkZPcmZs?=
 =?utf-8?B?bmpJcG43MmZIU1VBSWU5K3kxMkxvV1JaYkNTVmt3RTBaNkJPRHB4UG5UV0xT?=
 =?utf-8?B?ZDBLQlJ0U0FLYVpnUUZuZkhYL0Z0VGZ5K09Hc2JUY0JkRnBlRldJQVZjSUFB?=
 =?utf-8?B?c3lHNkhsQ2JWVlVUelBoc2lDSVBiOC8zNy9JSEtzR09YMTdqTjh4Uk9qYktC?=
 =?utf-8?B?N1h2RmJKdXNEd3FxZHBnT3hlWHhRSmY3U1lJanlIeWtiN015cjJMMUxEMVpK?=
 =?utf-8?B?QkQvMllQRGc3L3MxT2RFMTI0VEh1Y2taWElHT21kVVpaaTlDUG5Sckw5V2lv?=
 =?utf-8?Q?HG/GHwHX9Loo7WBCv+7wzQwFItvF61tIunktTJv?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <08B4372D2B75D041BE445C91AFBA987D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3448.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23a81616-0064-4883-2eb1-08d94643a132
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2021 21:17:32.9770
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H7kMwXNE2TFHJqRaQFyu79HG04yny+vPTa9/5m/MJwxJ024pLAyZWB5P+tyQTQjlaFQvz9WjISdoT3amxRpRFs9WofSrVCU/m3Tm6T9fNwY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4928
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDIxLTA3LTEyIGF0IDIyOjEyIC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIFRodSwgSnVsIDEsIDIwMjEgYXQgMToxMCBQTSBWaXNoYWwgVmVybWEgPHZpc2hhbC5sLnZl
cm1hQGludGVsLmNvbT4gd3JvdGU6DQo+ID4gDQo+ID4gQWRkIGEgc2V0IG9mIEFQSXMgYXJvdW5k
ICdjeGxfY21kJyBmb3IgcXVlcnlpbmcgdGhlIGtlcm5lbCBmb3Igc3VwcG9ydGVkDQo+ID4gY29t
bWFuZHMsIGFsbG9jYXRpbmcgYW5kIHZhbGlkYXRpbmcgY29tbWFuZCBzdHJ1Y3R1cmVzIGFnYWlu
c3QgdGhlDQo+ID4gc3VwcG9ydGVkIHNldCwgYW5kIHN1Ym1pdHRpbmcgdGhlIGNvbW1hbmRzLg0K
PiA+IA0KPiA+ICdRdWVyeSBDb21tYW5kcycgYW5kICdTZW5kIENvbW1hbmQnIGFyZSBpbXBsZW1l
bnRlZCBhcyBJT0NUTHMgaW4gdGhlDQo+ID4ga2VybmVsLiAnUXVlcnkgQ29tbWFuZHMnIHJldHVy
bnMgaW5mb3JtYXRpb24gYWJvdXQgZWFjaCBzdXBwb3J0ZWQNCj4gPiBjb21tYW5kLCBzdWNoIGFz
IGZsYWdzIGdvdmVybmluZyBpdHMgdXNlLCBvciBpbnB1dCBhbmQgb3V0cHV0IHBheWxvYWQNCj4g
PiBzaXplcy4gVGhpcyBpbmZvcm1hdGlvbiBpcyB1c2VkIHRvIHZhbGlkYXRlIGNvbW1hbmQgc3Vw
cG9ydCwgYXMgd2VsbCBhcw0KPiA+IHNldCB1cCBpbnB1dCBhbmQgb3V0cHV0IGJ1ZmZlcnMgZm9y
IGNvbW1hbmQgc3VibWlzc2lvbi4NCj4gDQo+IEl0IHN0cmlrZXMgbWUgYWZ0ZXIgcmVhZGluZyB0
aGUgYWJvdmUgdGhhdCBpdCB3b3VsZCBiZSB1c2VmdWwgdG8gaGF2ZQ0KPiBhIGN4bCBsaXN0IG9w
dGlvbiB0aGF0IGVudW1lcmF0ZXMgdGhlIGNvbW1hbmQgc3VwcG9ydCBvbiBhIGdpdmVuDQo+IG1l
bWRldi4gQmFzaWNhbGx5IGEgInF1ZXJ5LXRvLWpzb24iIGhlbHBlci4NCg0KSG0sIHllcyB0aGF0
IG1ha2VzIHNlbnNlLi4gIFRoZXJlIG1heSBub3QgYWx3YXlzIGJlIGEgMToxIGNvcnJlbGF0aW9u
DQpiZXR3ZWVuIHRoZSBjb21tYW5kcyByZXR1cm5lZCBieSBxdWVyeSBhbmQgdGhlIGFjdHVhbCBj
eGwtY2xpIGNvbW1hbmQNCmNvcnJlc3BvbmRpbmcgd2l0aCB0aGF0IC0gYW5kIGZvciBzb21lIGNv
bW1hbmRzLCB0aGVyZSBtYXkgbm90IGV2ZW4gYmUNCmEgY3hsLWNsaSBlcXVpdmFsZW50LiBEbyB3
ZSB3YW50IHRvIGNyZWF0ZSBhIGpzb24gcmVwcmVzZW50YXRpb24gb2YgdGhlDQpyYXcgcXVlcnkg
ZGF0YSwgb3IgY3hsLWNsaSBlcXVpdmFsZW50cz8NCg0KPiA+IA0KPiA+IENjOiBCZW4gV2lkYXdz
a3kgPGJlbi53aWRhd3NreUBpbnRlbC5jb20+DQo+ID4gQ2M6IERhbiBXaWxsaWFtcyA8ZGFuLmou
d2lsbGlhbXNAaW50ZWwuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFZpc2hhbCBWZXJtYSA8dmlz
aGFsLmwudmVybWFAaW50ZWwuY29tPg0KPiA+IC0tLQ0KPiA+ICBjeGwvbGliL3ByaXZhdGUuaCAg
fCAgMzMgKysrKw0KPiA+ICBjeGwvbGliL2xpYmN4bC5jICAgfCAzODggKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+ID4gIGN4bC9saWJjeGwuaCAgICAgICB8
ICAxMSArKw0KPiA+ICBjeGwvbGliL2xpYmN4bC5zeW0gfCAgMTMgKysNCj4gPiAgNCBmaWxlcyBj
aGFuZ2VkLCA0NDUgaW5zZXJ0aW9ucygrKQ0KPiA+IA0KPiBbLi5dDQo+ID4gK3N0YXRpYyBpbnQg
Y3hsX2NtZF9hbGxvY19xdWVyeShzdHJ1Y3QgY3hsX2NtZCAqY21kLCBpbnQgbnVtX2NtZHMpDQo+
ID4gK3sNCj4gPiArICAgICAgIHNpemVfdCBzaXplOw0KPiA+ICsNCj4gPiArICAgICAgIGlmICgh
Y21kKQ0KPiA+ICsgICAgICAgICAgICAgICByZXR1cm4gLUVJTlZBTDsNCj4gPiArDQo+ID4gKyAg
ICAgICBpZiAoY21kLT5xdWVyeV9jbWQgIT0gTlVMTCkNCj4gPiArICAgICAgICAgICAgICAgZnJl
ZShjbWQtPnF1ZXJ5X2NtZCk7DQo+ID4gKw0KPiA+ICsgICAgICAgc2l6ZSA9IHNpemVvZihzdHJ1
Y3QgY3hsX21lbV9xdWVyeV9jb21tYW5kcykgKw0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAg
IChudW1fY21kcyAqIHNpemVvZihzdHJ1Y3QgY3hsX2NvbW1hbmRfaW5mbykpOw0KPiANCj4gVGhp
cyBpcyBhc2tpbmcgZm9yIHRoZSBrZXJuZWwncyBpbmNsdWRlL2xpbnV4L292ZXJmbG93LmggdG8g
YmUNCj4gaW1wb3J0ZWQgaW50byBuZGN0bCBzbyB0aGF0IHN0cnVjdF9zaXplKCkgY291bGQgYmUg
dXNlZCBoZXJlLiBUaGUgZmlsZQ0KPiBpcyBNSVQgbGljZW5zZWQsIGp1c3QgdGhlIHNtYWxsIG1h
dHRlciBvZiBmYWN0b3Jpbmcgb3V0IG9ubHkgdGhlIE1JVA0KPiBsaWNlbnNlZCBiaXRzLg0KDQpB
aCBvayBsZXQgbWUgdGFrZSBhIGxvb2suDQoNCj4gT3RoZXIgdGhhbiB0aGF0LCBsb29rcyBnb29k
IHRvIG1lLg0KDQo=
