Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A9AD29CA
	for <nvdimm@lists.linux.dev>; Sat, 15 Jan 2022 01:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642209399; x=1673745399;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Md7WOYqHeSLx7hxtkHsBTubhYWviAX6mP4ZRgS+H2xE=;
  b=ZuvyUTHqtd1z9nWrTiJUh1nkokcVzmucsIPAQr/E7FYcH5NGfZ/XTLNj
   YwNwsWShYIwi8oqAdSd1Qr8t0vI64eK4yvomjhS0qiyHl8I7gjIaaMx74
   RSx/l2ubhVXqcY0lILAlI6eug57MNaWQ17UjfFBb0wbinmolHEtsSug5Q
   YohnXxZRzCz4a6qf/3LZ0qpE13y1n0vzHMVVic+iqrLwdCBHYgI97End6
   3h4iszti/Vtd6IeLpLuxSAc59w5ZIwpCwSqCSHuFjJg10ZqiiyR8h3AsE
   SwPFiltIyBnHXSOC1umM2qzCTcWMC6aUmQFzQjgNVEEnCRiLhBk37MY0k
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10227"; a="231713524"
X-IronPort-AV: E=Sophos;i="5.88,290,1635231600"; 
   d="scan'208";a="231713524"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2022 17:16:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,290,1635231600"; 
   d="scan'208";a="577478482"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 14 Jan 2022 17:16:38 -0800
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 14 Jan 2022 17:16:38 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 14 Jan 2022 17:16:37 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Fri, 14 Jan 2022 17:16:37 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Fri, 14 Jan 2022 17:16:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LSCZl5j3eiPlJcxKHdHpCc66r/s2m8ICeiKJaQ8gEOL5jS/3MbcfkEk0ybqNhm2LynfBDfmf3ZWbdUU7tk1ohSwHCSsCAaTmT7RH/rvjK4P1j6aa1g0VZoahmNSvSSKoLZIsLMKW21Spj5glKIkURV98tuFGQbmrnFXiJIosBwWv5JAulsIVE5q51I91N0HfZSNwbIKUvKQtRDaOmGnP+IOrH/flG1LHg71LPw4L8mm+MRaXulgBQPxxNIjWMUq4m377J/eqJmKwPgGsFY+7Jbxfe9YQtyjxR340MT7kbwi5nDmxBF81c2WyWaFZXtu/qe9rk/n88gfMPEeGaX5DWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Md7WOYqHeSLx7hxtkHsBTubhYWviAX6mP4ZRgS+H2xE=;
 b=kVi9j8f/xDmxkuOfLinDPMqFZMXK3TMF7nh4skLIJYJeNYkG1+wiejz2cG4g/IeHh1hVsRxsepBZ9s9IWKQipz6TW5nzBrRMgoXC3wepu9wvNuezL75j9oMOyl9OX2B3y29+VEStpYcOgRYaJjztbkPNyWRQtKxGRR29Fxpov+UzVJyS46IYOIhTFt9VE4Xj85OpwuU7YgG7+gbsQ43X9yHogLo1piaSyE12cANirO5A+GruKjoS/WBTqg3PfX8RC34S7CJG0Jf2fkaFsX8G3Ek59TSz7HkZ6XG5D5irtvtQEPsTDv1NL/3H5CiJYvbOgbX0HRtqwYNhb18ILqGLQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN6PR11MB3988.namprd11.prod.outlook.com (2603:10b6:405:7c::23)
 by DM5PR11MB0074.namprd11.prod.outlook.com (2603:10b6:4:69::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.9; Sat, 15 Jan
 2022 01:16:35 +0000
Received: from BN6PR11MB3988.namprd11.prod.outlook.com
 ([fe80::e1a7:283b:4025:328]) by BN6PR11MB3988.namprd11.prod.outlook.com
 ([fe80::e1a7:283b:4025:328%6]) with mapi id 15.20.4888.011; Sat, 15 Jan 2022
 01:16:35 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>, "chu, jane"
	<jane.chu@oracle.com>
CC: "kilobyte@angband.pl" <kilobyte@angband.pl>, "jmoyer@redhat.com"
	<jmoyer@redhat.com>, "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "breno.leitao@gmail.com"
	<breno.leitao@gmail.com>, "msuchanek@suse.de" <msuchanek@suse.de>,
	"vaibhav@linux.ibm.com" <vaibhav@linux.ibm.com>
Subject: Re: [ndctl PATCH v3 00/16] ndctl: Meson support
Thread-Topic: [ndctl PATCH v3 00/16] ndctl: Meson support
Thread-Index: AQHYAnulcNZJ9TW7fkuxyaLtBaP9V6xiu8EAgABr/QCAAATUgIAAKYgA
Date: Sat, 15 Jan 2022 01:16:35 +0000
Message-ID: <9dcd4029fc655690d87bb7dd12f97c5ddddf697c.camel@intel.com>
References: <164141829899.3990253.17547886681174580434.stgit@dwillia2-desk3.amr.corp.intel.com>
	 <d4a57facb2b778867e3bbe8564f03868b58e2f72.camel@intel.com>
	 <c6be7804-419e-d547-062d-6b852494bceb@oracle.com>
	 <CAPcyv4jYg3DRv6Eeq3s2c0kk4dSvr3_i_jk+Uc2Pew9FON+zmA@mail.gmail.com>
In-Reply-To: <CAPcyv4jYg3DRv6Eeq3s2c0kk4dSvr3_i_jk+Uc2Pew9FON+zmA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.42.2 (3.42.2-1.fc35) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1bbd18bb-0851-4c0c-bdbd-08d9d7c4ac45
x-ms-traffictypediagnostic: DM5PR11MB0074:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <DM5PR11MB0074DFAFDB59E3758105BCCAC7559@DM5PR11MB0074.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 84l5BK16iKrfG9oJwZIWe91ronWL9ONPOBkZ8J7DDKAc6O+yF2D+VlMBBWhDR4kNgcf4vCPQlIh4rEfxZ1i9qHSbfFLeEz4RbUGWeRtZNTJRSUApb477ziUQwYInAZYgbCetGRu1Zzt4QXn9nLhKui5lRbi61L49bqVioQ/WAb9YPtV7RU/U3wCOZXY4GKuEXaoACv5XXYR8o3V1v5GlS10+GNiK5cVRabOButed13Gh+v7sNMtr4+WmgwTeaXLHKeDZKofUC/WnzALLNtJF+0MDwnW+hdq+JUl+JcpnlKHmvDW+7lTXp/N2i252U5qPRLHGuvZ209RQVGyKAwks46LZn2Q72H75907jIo1YDEn4cErMTyqmWVTAAnMRhhxgdG2u+Stn8dZH5L2vFqLiA4FprlTKMzxZqLY+kWgc7ue5oQTuo8dvFSAyUg/vrbVPJQd4koxKUd7ZGmykSpoq+BHeC0Zf0/dI7dzvlIYZMRZNo/ygi1T9/6A240MzTLCDolqBeTgqHjgAn1uI2GsAfYL/+m0OavrXC2E+oPX2lxJd4fXiCmtyqxdc1F15KC1mB9Su6zhnigUBJPtOEjxlm3wF0verkoxHBDy4qIVDJayf6v4VjXvRmAmbcFkMcNO+F9JfOEviaEJmxHPrexoysimpzh7LRMEGOsqJ1OPhHfScJhxkDatPu1c996KKYCvZGFMMKC9lT0Nw7GDSlBlerA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB3988.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(64756008)(66476007)(66556008)(36756003)(38070700005)(91956017)(8936002)(54906003)(316002)(76116006)(86362001)(110136005)(38100700002)(66446008)(82960400001)(122000001)(66946007)(6512007)(6486002)(8676002)(2906002)(53546011)(4326008)(26005)(71200400001)(83380400001)(6506007)(2616005)(508600001)(186003)(4744005)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cVRNY1BvbjF3MG0vb3NrVnRxR01wc0trQ1lyVGEyS1d3d2VhTHRKVEthY09l?=
 =?utf-8?B?MUl2NU5DL09mSUJyNDNxeGQyUXdKVXppVnRSekUxWlV5dVpwSVFJRlArNWhZ?=
 =?utf-8?B?cHd0OHprdU84ZEhqYVpnL1BERlVQZDhoV0R5Qit6blBvam1DQmF3emRFTlI4?=
 =?utf-8?B?T1J6MGxDd2ZDYjFwRG45amluSUtuZ0VYVXVkY1AveGpTNmVNM0RCdXNhbmFK?=
 =?utf-8?B?bmlXdmFFcGk4bUhFRXFOREtsdkUrUnRpV0lKTW0rTno2T21DUFNLRndrR2ps?=
 =?utf-8?B?b0NORndmaWI4cFhubm9CdXdPM2pITVhsZkdPR1lJQ1VkZFRwTU9rZVA2UGZq?=
 =?utf-8?B?TnNBRXUvR3VjYXkxZmkvTmsyd2F0NUhjdmVybXdCdWdaMnpJWGRYdDVndDhz?=
 =?utf-8?B?b01mYkt5VjFZbVozYW9RdkRiY3dZZ2ZBcTJXcHU0WDNvRlRDY1dNZmxlOXN4?=
 =?utf-8?B?ZERtdlFuRnJtUkQ5L24vbFdPVktTMXdpTWFUWUdiTHlTOWt2QXcyMUpwcys5?=
 =?utf-8?B?c3VCVk1CWDQzQmJ4NUlFSmxuaUlhWXNRM2ZSSTc0eDkvUEhjTmozRUcrSjFa?=
 =?utf-8?B?WU92VnplNHRmTjR6eVBtN0RmQ2VjakJFU0VVanRDSnB1VC9MVXJLZ2Zwd083?=
 =?utf-8?B?MXVjaFZnN2N1TU4yTVU5SW15RFZMQ3ZUSm5EMlVBZDZ6Z1hVSFp1b21VSER5?=
 =?utf-8?B?OFF2L0pWUEk4R0hVcll6UHMxUkFienY1QVM5clB4Mm03TTZ3OEViL01TcWN6?=
 =?utf-8?B?TUovZXJmYkFTRFNlMnhiUzRUK0FKcUZjOXVPYUJjdi9MS25xby9QOGJmeHlt?=
 =?utf-8?B?UlVvZzYwYTlWai9kcUlxUzVrSHdBck5WOTJuQnRkRWJLcTIzYzVHYWQwTEUx?=
 =?utf-8?B?S0RzNndmR3QvMklWVUNzK2REOE5Ld1VaeVJWVEJKT2F4MlJTaGlrZ2lZZlFo?=
 =?utf-8?B?cUhGdjdBUzdRcUIrNFN2ZFFIOWdNL2RleUViR3o3d3RtR016Q0x1OFZLbXNo?=
 =?utf-8?B?SldnTGVXZnNXQkltSE9GTTNxOHRMMWNOUXpnL21DTWMzSGhManZtYnREbXpU?=
 =?utf-8?B?aENwWUVWNWovNDZrdVhmTng4T1BtR21CVDkyYSt6b29zRlhBc0RPUHlwWWRF?=
 =?utf-8?B?dnFxQW9FbU9DUHlOUTYyWGZGMVBwK0YvZERndTJ1WHF4KytVTVBwN2lJMDJN?=
 =?utf-8?B?ejFzTGU2bXl1Q3dkMUQ0TnNBKzBySFRCRENBTE4wNmluTW96aWszWlBnVmVv?=
 =?utf-8?B?NE4vUUNVUjZrSWg3UHE3ZWcrallpbmEyL0ZxdXI2Q01LZTRaTnIvTTg5N0V1?=
 =?utf-8?B?UDA2Q1B4bnN5UmNXdTkzZGRnb2NuMUZlSThWUnJlVFBpUXpFckFDbTdHTFU5?=
 =?utf-8?B?SlJsL1kvb0xjMXpZWmlzdGVyRVZpMmdvQWV0c0pVS1g5TzNJYVlERFpYaW5L?=
 =?utf-8?B?dmg1R3lueUY0TUpNM0ZLNjdMMGJ4eWRCd3hCY2t6cUZ3ZTRVcFIyNEJKWXAr?=
 =?utf-8?B?cWZXQWw4QTFMWjRaeXBEVXI2TmI5M2Nvc1ViWXMxdlRob0FlaHEyQUdOSDNa?=
 =?utf-8?B?d1pqVEI0Q0RBMjdtbnBZOGFCcVl4YS9NbWJUakZnQW5MOU1kYzYvMi9oZW5O?=
 =?utf-8?B?Qlp2S0E1ZEV2N1o2cGJrU0xKdTR6OXpqMFdtVFlZNERJSlpkN1JUOGxqeTJ5?=
 =?utf-8?B?Zml0TnJFMzlEZVdtVDdQUEZnQXdvcUcrdnJ0TVpDQm5pT2NZekhMeVA5Z0lU?=
 =?utf-8?B?a1FvczRZcWVKWmZPMDZ0UExhOG51L3NQRmk0c2pSVXB1d1BIRnQzL3o5VEdr?=
 =?utf-8?B?WGpZdkMxY0JRaVgvWktaY1BIaVU2T1l1SHJkWjVXTUZtanVxYWhvT041VWY2?=
 =?utf-8?B?ZXFYOUI0MTdPWVZycVI1LzFDOEVOZ2EvU01WQmgzeW5YZFNPRWx6NCtIaDVq?=
 =?utf-8?B?OEtNNXQ1RVpZZXZMMDVFT2FmaGdBUlFHUmRoTDdYMVo5eXg1STBvTWdYZjQ3?=
 =?utf-8?B?ZXIxL01BREwxL2pCRXFUZ0ZTR3gzM09pd3RQOEFUZmJyVXJZNWdtWmtWTWha?=
 =?utf-8?B?dDZ0ditJSnVXdS9Hd21SWlc1cVI3cXJLVDNpKzcvMGM2OWtOdkxvQ0RpV2RY?=
 =?utf-8?B?dHM2SEhGS0RYNTJBVVB1ZWw5YVluMk9XZ0F3WXVHWDB2YXRJdmNqWmhSZnBa?=
 =?utf-8?B?eWFhdXhNdStQMTlLdzQyLzd3bklJVFJDWGpDK3lpL21CMStpYW1xYlloaDJj?=
 =?utf-8?Q?pIFt+P7wzb5aAHROtMRu+gHKGyu6jhKYL0HpqgAEkw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F60C82ED064C194699B50CC4AA511A47@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB3988.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bbd18bb-0851-4c0c-bdbd-08d9d7c4ac45
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2022 01:16:35.2668
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oswJ3tKPkg8SRsaAXAR/ihEgybne1YxDlnpuUF4LY+c3+TW79qL4IrQfbbdWWxiH92y+R6kuA7IBkN0OzEZdA5KRZJX9a/2o7rd1M/zUU/o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB0074
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDIyLTAxLTE0IGF0IDE0OjQ3IC0wODAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIEZyaSwgSmFuIDE0LCAyMDIyIGF0IDI6MzEgUE0gSmFuZSBDaHUgPGphbmUuY2h1QG9yYWNs
ZS5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IEhpLA0KPiA+IA0KPiA+IFNob3VsZCB0aGUgUkVBRE1F
Lm1kIGZpbGUgZ2V0IHVwZGF0ZWQgYWNjb3JkaW5nbHk/DQo+IA0KPiBJbmRlZWQhIFdpbGwgZml4
Lg0KDQpZZXAgSSBoYXZlIGEgcGF0Y2ggZm9yIHRoaXMgYWN0dWFsbHkgaW4gYSBsb2NhbCBicmFu
Y2gsIEknbGwgc2VuZCBpdA0Kb3V0IC0gd2FzIGp1c3Qgd2FpdGluZyB0byBzZWUgaWYgYW55IHJl
bGF0ZWQgZml4ZXMgcG9wIHVwLg0KDQo=
