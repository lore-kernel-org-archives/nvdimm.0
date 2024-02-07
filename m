Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0A81272A8
	for <nvdimm@lists.linux.dev>; Wed,  7 Feb 2024 21:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=134.134.136.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707339941; cv=fail; b=gW8X6EeZoSjxpks0+D6pkNMWfHfXzLsZw7oP1fjM0OuHfm0p29ilUgGzI77EgIeE7Ev+22zcUVqvPG8V+JV8NpLpv/mQu8LTeP4rAt+E3a/LmD97ajp4p8WIPHDXRK8QA0k4EiT/5ILFzA6sn2e9ClDNxcU2hgXe5HLIfNgZ89Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707339941; c=relaxed/simple;
	bh=K+vLoBmQ/b1Ru37MEsts304WxjQX6D0RySIsWF594jk=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ob687qWSEK3dNhqhEkF3ao7lvDxcigNvbXy7/rPzHGSICSreejQlmIiKJqpgikpOA/0n4WwXtVIxzbp23cLj/GeNqITaEh6GN12rlvyGFPnyAgUsX92ZvJA/iDkHt0KHYYr6VdGUeaZYWnItySoIBilrzJrng6nDvsKuvJKZjnU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cQxTlvzm; arc=fail smtp.client-ip=134.134.136.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cQxTlvzm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707339939; x=1738875939;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=K+vLoBmQ/b1Ru37MEsts304WxjQX6D0RySIsWF594jk=;
  b=cQxTlvzmIYkxX6NBVNn/YUD8FEL/pJseT+1YTJ9FZDAFxi+qfEIDRiWw
   THIcYHacc5eZtWhsRNpZDE3Gn9SoQAU4EdluS247XkK9VEEd20CeIM/eh
   G2MAfd5fuDuzZDzJDm27PlX7OSSBjdmKHldNX3nddEqQYHBOPpV+bOn6y
   v89L/+Dgv+zQzuTlzDEhL4SnHGCOLmvwvbxlYb2DFo2f1kDz3iG0TGeeh
   j8vMFm+5NPVmRHrb1OF2xIJeREVWlspK1WsgjOTzi19HfM7cffQVLiLjl
   bbBz8DNIcPjeZYwG78g9th8MOtDbC7gLGStBfiesfCD73I8yOqXhuYcZx
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10977"; a="395498897"
X-IronPort-AV: E=Sophos;i="6.05,251,1701158400"; 
   d="scan'208";a="395498897"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2024 13:05:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,251,1701158400"; 
   d="scan'208";a="1755619"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Feb 2024 13:05:37 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 7 Feb 2024 13:05:37 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 7 Feb 2024 13:05:36 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 7 Feb 2024 13:05:36 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 7 Feb 2024 13:05:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cDPIth0VAoZdwwOKl0J8doMdqSBS/ISCHIgtVX4fvCPQlMZf4qASTM2f8gIYyuxNUcmdsdM4GGyjPika3X2+4NSrtPD9rhzMVBN8iyMhrE0ocVZ3MvIcuOK1pxIv3PQzSst/XlDhFFY+n4yBNd54ushFuDpUzeTURnacgH2sOjDSNKvsbS2sbjb1INpGhzXEqfSrwHgq+JUt0EG9AqxYEy13LmgK0/JBFV32qmXGjMaiDsLjStYVnEYmBP9zEsqq/FxsZpGhxABR92hrDWQW+ER70/JbOBF8YfX63EUVUo9GDkDsYDU3HR0tww/H/6tQn4OG6C3/aoIhx8a7i9ig4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K+vLoBmQ/b1Ru37MEsts304WxjQX6D0RySIsWF594jk=;
 b=JC6tKlUZlTAD44vgu8cY1KE0gcnggV2D8s1Q5pPyPGHLea7sD2iVjDo33GCqQaBxbZn1f4Bow39Sm1IpGWKo64XL0daxUp54TGZvdC/lpYUjJmxMOmwFEIiPbDTE2y6aG4MXT5mZv2pPWRGjQOTyc/5uJAHJ5lwmILw7onMmZB2M313br1zGwnIwiOR2+jJO81wO7TphtJ0j0f6TbqqBkYkX74uiW9z/ZZVJejRj7nHVrxHjVeDrH1AJgjBkDWM6GTQApQR5VGfOzM4fJA8R19mFz1dV0VD5hivwDuL8xSYIVqsWyXX55xh120Vmk0tUknNinb/crebTr2AjhktWyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by DM3PR11MB8671.namprd11.prod.outlook.com (2603:10b6:0:42::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.36; Wed, 7 Feb
 2024 21:05:28 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::e28a:f124:d986:c1d0]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::e28a:f124:d986:c1d0%5]) with mapi id 15.20.7249.038; Wed, 7 Feb 2024
 21:05:28 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Jiang, Dave" <dave.jiang@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
Subject: Re: [NDCTL PATCH v6 4/4] ndctl: add test for qos_class in CXL test
 suite
Thread-Topic: [NDCTL PATCH v6 4/4] ndctl: add test for qos_class in CXL test
 suite
Thread-Index: AQHaWeoWo2K28k3RsUCNLymwhbkM97D/XuoA
Date: Wed, 7 Feb 2024 21:05:28 +0000
Message-ID: <675eec433076c33af05742425b310256913be341.camel@intel.com>
References: <20240207172055.1882900-1-dave.jiang@intel.com>
	 <20240207172055.1882900-5-dave.jiang@intel.com>
In-Reply-To: <20240207172055.1882900-5-dave.jiang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|DM3PR11MB8671:EE_
x-ms-office365-filtering-correlation-id: d3717cc8-13c1-43e3-5d54-08dc28208324
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: w77IFX+e4sNb4RavPJeY7AcukEEZbAdB2cHw/wvmFzQeWjBLo/M3ZOfwmqdtzkhB4Dehs2iwRMZd8nsUhQicScXW3Z1tsmp5R+Xu0jL3XKurgjJ5BPKx6DncSMKnVrZ8DffEvZYxYgiRVaE1HdSJvtXM4vP7KirtiP+XB6Qp1FrCtIwbH44A8QdX2I/Ke5SNYTYO2CG2AvgK+iqfqVIkS4Xc2qW09Y2V2t1Je5UDyKmB5+OGKpzY1ZPB41+lpU3FmVrCvlDw0y5eyd4crOV/e28jzBqeM/o5o7cIKPGTmd0ItsxMC5KyJ33FDOOHukSxGD/EwF40+erRJ1hD2zsBa/ESU8d2GzS77m9BakN7I7ueSzhFlUsnpjn7wuDOGA0tYe76mrP8gZhVYAM1g3KYjL6IXi7aSissw2+tTrfLOK+OW1f0y5WB6bZlkb1LzjuWnwO4K/yUJX1dfT7qozF4pKSc/V3PoLSzJzlvbfmjWKmtsA+5eFaS+jtuQPFdBs1ZBDTgRBk6Vf1ck2QE2WlAVvV6G8QwQZ46wNYfCyq7KNnJT4iZo4Ll8JdquQccErvo7gfIB+m3py2+54F3ZbAJZA73qqqow0CdWJ7lC2gWDJXYs8IXhR709ZHzkwQYku4/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(39860400002)(136003)(366004)(396003)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(38100700002)(82960400001)(122000001)(83380400001)(8936002)(86362001)(26005)(2616005)(41300700001)(6506007)(6512007)(8676002)(71200400001)(36756003)(316002)(478600001)(38070700009)(5660300002)(2906002)(4744005)(66446008)(76116006)(66476007)(66556008)(6486002)(66946007)(64756008)(110136005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aXVSbllmQlgrWURlK05UYW5Dd0VkVGFrZlNpUWprSHVOQVR3TGd2Qi9iN1VC?=
 =?utf-8?B?T1E1bjB2Ujk4MmNBOXFocVRabnJJOEVmNWFQeFliN3FTUjJOTUhtMXRTMGFG?=
 =?utf-8?B?YlRqSlZZYmMxa3hZU0RZYmIrZ1JyTEpodVRXRVFrZXdMTmxLYXd1NjlxVkEx?=
 =?utf-8?B?eVBQcGw4OG5hNExKUkZOQTlSYUN6M3dObktkbHBoS21BZDA2U09zbzMySVoz?=
 =?utf-8?B?UTQzeUw1WFhRYmp2N3g5emEzSTlhcndMMTJFbWNUZ0NhME9FSHlqQTMwWmQx?=
 =?utf-8?B?OEp6eHhaQldVR1FQandRTy9IRk0yVlp6WWR0SnhBUHFEOVJMTE44dm91UTJF?=
 =?utf-8?B?aVA3T0pnMU1YdmNMSnc3aG14S245SGZsZ2RhUi9BTlhQRUtnVXlZSjRyUWNC?=
 =?utf-8?B?cVN3S3R5U1FKL2hkUkJod1QrUXEwQlYxZmZsdFZ2UzVPSjlLVkdSaERJTFQ1?=
 =?utf-8?B?ck5IZ05WV05lOStaU0d2MkRpRG9TUHNUTnk1VFNBTjdKMmV5VWp5ZUtPME9w?=
 =?utf-8?B?QkhBTnhkUUwrNlMvWXdPWjB2bis1QTVSRERkamZTTGs3ZjdneVRtVHU2R04w?=
 =?utf-8?B?MzZ2RVZ1bEE1SW9td2pQRzJzRXVGQkt2U0ZqK3Vpa1BhRFByV1VYZS9QckVt?=
 =?utf-8?B?MzZwUzEzZUlFNTRmYUhWRWFXVGh5R1lKeURRdjE0V3IrTXlSMVhKemZKT1NW?=
 =?utf-8?B?cGZzQTUwbUZCQTdnVmVoQnBpY0w4V3YycCtFS0dSR1QxenZsUFprNnMyYzZ6?=
 =?utf-8?B?OVB3bzFuQStUWG4zMXp3aEswU0hxcDNnLzlVSkxTbmlIdUxzdlJMT0VIMk53?=
 =?utf-8?B?bDR0VzZUZk9wbXVtS2dYc0xWcXVubW9ISm1nWXVoYmk4MUZPcDQrZjkvNFRD?=
 =?utf-8?B?RC9va3pwR0taTFRHVHVWQ2FBMTQyN2lCVmZjeklDOXQ5RnFzdWdhZW5OUHAx?=
 =?utf-8?B?MGlpMW4zbk13VlB0U3JPSk5UbjhCRERZVHRCZWQ3d0V0aVdLUnp3ZzcrWURM?=
 =?utf-8?B?dGF6RzBkL1hmdm9zeXV0SzhjUEdEcTc2T21Mb2lXS3IwSE1tYm0yUUZraWJz?=
 =?utf-8?B?Y2ZnU1RRaVQ3SkpzQjlCcUhnR3Z0dllWaUl0Y0dldkhSM0dpUm05UklxVS83?=
 =?utf-8?B?ekVydkJYSWFUWmdvNWQvVElXZDlrWmtiZ2pBUmhINGtmQ3pPVEVVb1FLcFdI?=
 =?utf-8?B?enpvSFBDL1hJK20xZ1hxS0Vnd3EvamU1cFA0eDZuQVQxYVBuWGNnMzZmRHht?=
 =?utf-8?B?dThVTlhCSFp4YVlBVXVrckM2eG8vQ1dQMXVmWlNMeUdEN25TaTZwdFN0M1lr?=
 =?utf-8?B?QzFSSHd2VVkveVJSaEtPOFdTR0tNWk4xSEJYUEptVmhnM2ZGVWVXajhlNkY1?=
 =?utf-8?B?Q3B0c2lTRzB6dHFrRXBydmk4cXZwNFFoVTV6M2NiQ052aTAyQVl6WmI4K0Rh?=
 =?utf-8?B?TFN2N3hZdEV6QnA0NTRQR0hiUHBzZk5oamR5WW1YVzM5VDJNZ25ZN0dyUzBE?=
 =?utf-8?B?QXJ0Q29mK2MvQ1JTTHZhVVZYYWd0V3grYTBoYUZMdlIwMkVSMEx6dUI2djAx?=
 =?utf-8?B?MnJ4YU45Zy9KTWQ0L3hDTzU0cytTYmZyOFc0S3UvOTlQOWxmZFgzMGg0eHZa?=
 =?utf-8?B?MFJYWFNyeEF2Vll3RzlKOVZOOXh1SjVaYzlXamVaZlRsVStCcS82WmVhTnZt?=
 =?utf-8?B?dFlXdG5nWkhPY1ZUcStXdzcyUWNkUXVEZTlwb2Z2YUNFdVM0cE8wd3BxUG12?=
 =?utf-8?B?NWhuNnI2ZkE4ZUZsOHRjZ1MrL0pkR29BandqN080TXJHbElsL2FiT0trWTNR?=
 =?utf-8?B?TmRxZU9hWlMxMWhLZzJSWmtYMURyMjVvNFR6NGx6TlFtL3hoUnFlaUxraWpy?=
 =?utf-8?B?MFVHYm5NMWVhdk45djdSZ1daYzl2bU40VjlUT2lrVmliYTJiaUlRZEZHU0Fr?=
 =?utf-8?B?cHNGUHg0SEpQVE5Zc1JXYitCSVpEaUlGVGZXM1dWSGR2djkrZ3BhSWFuM1N1?=
 =?utf-8?B?dmdBNDU5M0tTOFlYUVNIYkc5UWlIaDgvTDNidXZTNCtzZlBsbGxNUzJxTjIy?=
 =?utf-8?B?a1g4QXkzbXRUSmd4cytUQlFiNGhNNFR0aUs2VGptV1o0eDYzTS9yN1Q5aEFM?=
 =?utf-8?B?QXRkQVpsRWJLZHk4OUl5bzQ2UVloeDhuY2UzaUl6MjhLZjRIS1ZhcHoyL3d4?=
 =?utf-8?B?TkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C2F2837987A2D741AE955645B8176F1E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3717cc8-13c1-43e3-5d54-08dc28208324
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2024 21:05:28.3719
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9EtHAW1IAfH/8MMyvBtdD9xTBi6Mb9QkZrEqvoG8yOeMMH7KMJRt933iMNNu5aj2ko6jKEkklUFcs5MszCNgEPrpSchKm8Lw0V/agi3Sz1c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR11MB8671
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTAyLTA3IGF0IDEwOjE5IC0wNzAwLCBEYXZlIEppYW5nIHdyb3RlOg0KPiBB
ZGQgdGVzdHMgaW4gY3hsLXFvcy1jbGFzcy5zaCB0byB2ZXJpZnkgcW9zX2NsYXNzIGFyZSBzZXQg
d2l0aCB0aGUgZmFrZQ0KPiBxb3NfY2xhc3MgY3JlYXRlIGJ5IHRoZSBrZXJuZWwuwqAgUm9vdCBk
ZWNvZGVycyBzaG91bGQgaGF2ZSBxb3NfY2xhc3MNCj4gYXR0cmlidXRlIHNldC4gTWVtb3J5IGRl
dmljZXMgc2hvdWxkIGhhdmUgcmFtX3Fvc19jbGFzcyBvciBwbWVtX3Fvc19jbGFzcw0KPiBzZXQg
ZGVwZW5kaW5nIG9uIHdoaWNoIHBhcnRpdGlvbnMgYXJlIHZhbGlkLg0KDQpJdCBtaWdodCBiZSBu
aWNlIHRvIGFsc28gYWRkIGEgY3JlYXRlLXJlZ2lvbiB0ZXN0IGhlcmUgdG8gZXhlcmNpc2UgdGhl
DQplbmZvcmNlbWVudCBvcHRpb24uDQoNCj4gDQo+IFNpZ25lZC1vZmYtYnk6IERhdmUgSmlhbmcg
PGRhdmUuamlhbmdAaW50ZWwuY29tPg0KPiAtLS0NCj4gdjU6DQo+IC0gU3BsaXQgb3V0IGZyb20g
Y3hsLXRvcG9sb2d5LnNoIChWaXNoYWwpDQo+IC0tLQ0KPiDCoHRlc3QvY29tbW9uwqDCoMKgwqDC
oMKgwqDCoMKgwqAgfMKgIDQgKysrDQo+IMKgdGVzdC9jeGwtcW9zLWNsYXNzLnNoIHwgNjUgKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiDCoHRlc3QvbWVzb24u
YnVpbGTCoMKgwqDCoMKgIHzCoCAyICsrDQo+IMKgMyBmaWxlcyBjaGFuZ2VkLCA3MSBpbnNlcnRp
b25zKCspDQo+IMKgY3JlYXRlIG1vZGUgMTAwNzU1IHRlc3QvY3hsLXFvcy1jbGFzcy5zaA0KPiAN
Cg0K
