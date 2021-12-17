Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE1529CA
	for <nvdimm@lists.linux.dev>; Fri, 17 Dec 2021 21:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639776699; x=1671312699;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=lSdFLxdMPELmsGCPVmJfQaMWJmIAiFt6dCkQ3POiYuc=;
  b=KA1zc/talmRfSMIC75L6yJ9R0PpCUF4YdiTCW5SQWUaFdrxabhYNv7ti
   z6zCGUgC8tzUpP2aHN336vAofpCnALZqN8l27MoUAl5sYVKZ1uK7do3TV
   sXqtJ1l62DLvh9PVNUbwy1TwMgUKLBuLkUMCfGsyIXGLN6NoCbrF4yapO
   1aSrQlbw3Bze2X+fFGETDfhjNJcknkTEHFDVQqwJtocfcP9oc28cXlXDf
   dPGMKrK4y90jrYG4s+qX7xhDgKJ93nZCzMzPJNHphY8c23Wu2uMOyQSv3
   7UwyVt5KYjFv4nA+twbojitsfpAsx1hpQer7qhShCUgye4bO/dekKvVIY
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10201"; a="237377629"
X-IronPort-AV: E=Sophos;i="5.88,214,1635231600"; 
   d="scan'208";a="237377629"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 13:31:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,214,1635231600"; 
   d="scan'208";a="612259528"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga002.fm.intel.com with ESMTP; 17 Dec 2021 13:31:27 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 17 Dec 2021 13:31:27 -0800
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 17 Dec 2021 13:31:26 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Fri, 17 Dec 2021 13:31:26 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Fri, 17 Dec 2021 13:31:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i89UqLMV0682PhRAcU87bS5J1FoHylwot9F8xjr0DwzEuIZtWzMyVXetEU4h1Ff7uJi7S994l6kj+6D5DlPIqf48rcyWw2GjHv46yCsL+GR3jeNsizRwClwWCG2gq7Y/dBp3QWBraNcRgekFAxHMTBBygC6c93o/hum9jQq47P/Adz4iG3icwBQ/kgT8pggFNc3oNmdz4t5k5wfJX5u1duZLefp2fQ7Z5zQ5ea1ty1XYSpEVY3XJn0tTQ08uJPOCdYkv00ce/asm1SXuZ7IYVue9j00GHm+HAiS+tyH7laUSfZVb6v4oU9NnDDgASg+On0xZ+E8L5Sge/MmjorUTRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lSdFLxdMPELmsGCPVmJfQaMWJmIAiFt6dCkQ3POiYuc=;
 b=ltUQd8t2O0ZFpXHvWnYf2BXOlKrLFJt+AwnPDtAQDh+RuNxYSYCsPWRBcc1t9mjD0yZChnpY6gVwqONzd+0HmeuZMTNxHpCqp93QSj9MLTuOLWbAxW2Xarpbprdkip9X7xlolE0OJa1SXPRMcFQf4ISdljROsbJoNpNaXhGmA7qd6tw7DkXbyQXBOypiflgCHy7zsK4kxOw4QDIpLzl2B8ppioVpgr5t+BYqZE+x4mVyy7PoRee2FZiekmZJDKvNfFWhfxslVwBFMyzcnkv9PhzN2Ulgi2NWrUqD8V4JabhgpIWKkA4Ds70ZaFoNzU33eyiqTcl4Ul9luYm42DiHZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by BL1PR11MB5509.namprd11.prod.outlook.com (2603:10b6:208:31f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Fri, 17 Dec
 2021 21:31:25 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::114d:f87:eeb5:b6be]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::114d:f87:eeb5:b6be%4]) with mapi id 15.20.4801.017; Fri, 17 Dec 2021
 21:31:25 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "qi.fuli@fujitsu.com"
	<qi.fuli@fujitsu.com>, "Hu, Fenghua" <fenghua.hu@intel.com>,
	"qi.fuli@jp.fujitsu.com" <qi.fuli@jp.fujitsu.com>
Subject: Re: [ndctl PATCH v3 01/11] ndctl, util: add parse-configs helper
Thread-Topic: [ndctl PATCH v3 01/11] ndctl, util: add parse-configs helper
Thread-Index: AQHX7hYn2abrS92RXEG7EJO9t9sQe6w1r4sAgAGPKYA=
Date: Fri, 17 Dec 2021 21:31:24 +0000
Message-ID: <afa286d5735e3faf52c8cb65875d4ec21b241097.camel@intel.com>
References: <20211210223440.3946603-1-vishal.l.verma@intel.com>
	 <20211210223440.3946603-2-vishal.l.verma@intel.com>
	 <CAPcyv4g=jfpUQ1h09MXdDy+t7Ur3ynPP0XurSfOM7gzUPbYYpg@mail.gmail.com>
In-Reply-To: <CAPcyv4g=jfpUQ1h09MXdDy+t7Ur3ynPP0XurSfOM7gzUPbYYpg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.42.2 (3.42.2-1.fc35) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5c0a7a4f-f356-4596-981d-08d9c1a493fd
x-ms-traffictypediagnostic: BL1PR11MB5509:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <BL1PR11MB5509CDD3E93B948C50829785C7789@BL1PR11MB5509.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bHEcSWfN9SrsKMs1/bwIJCXU0MSiAGmHWmEY/keWKgR9tx5zZmv8zkLnCyM2w4gxdFRSlXxPNwT+qKsyL7HEXIofoWXocvSNV/xOFHpG7pnkzYUxWTuWmOX1QJv1WSt5bJbaAr3Up41gyCqq2Awq+TlcyAA9S1q7YIIgtNRalmByYqG7mSZiVBWeYj95H+Fg5hsb6GTQMPHOgiXdQ/eWItBhu6lzulY2G6kfJLCoBjHzDTFmRU9G0ENPFtpyxIyL9wkhtQuWYgRN/XbO2uEOcjG/Dn66PymV94/IKrp6oGmUR9m8Pf6cyqA5SfwIwzPEELtYkAidGIziruxOGmV1PLI3aXL7Vb5O2hN63jFHztONtJf/rwA7SRy0plBc5bBiA5I+djzrv2QJL22UScmK/VsfHudo3PhMFhN/kgE9q+0hkIKWxvBP2Ys0Hbm7rwXZZyLO12Olt1xqE1xmH8mozGB81lEmakSAdixd6NM9uQq736WycBOTzIwVDFHy48i4rslHZXB7CbbgMHCc/zjvBWV5C8+ZRx6R2Q9N6QhjU//YfT3qkN9tZBIAapXffAf/EKPg2/fkc23Iiw7JnnIS6UZPpQfk7vl/G2zsO/uSybUrIBOq5q23zux8Uu+XVU/BXmK0991EueaMGvtRiCC8+DVi184Vq4xPyYVeyJEqEbEmM8JawMJPN7cUUfg91Kpaaj7uHOH8YgkLIV2xj2D+7Zln5d1kOKO06pAZiRhgLCL69aWve7JW98Gca7STFjNx69dbBHHoXy+G1fEWxUpT/0T4c3jwoZ64y+N3dmPNZNU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(76116006)(6506007)(8936002)(508600001)(6862004)(5660300002)(8676002)(6486002)(966005)(37006003)(2906002)(4001150100001)(4326008)(66556008)(71200400001)(66476007)(86362001)(2616005)(316002)(82960400001)(54906003)(53546011)(26005)(122000001)(64756008)(186003)(91956017)(38100700002)(36756003)(38070700005)(6512007)(66946007)(66446008)(6636002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RWlnNXlINzllOXdQVWtKbm9DWmJKTkZndmZQQ0Y2dVAzRndBYlRkWlFJQkJ1?=
 =?utf-8?B?eTdSRTBBSWFIV1NQbjNlSzd5d0paM2ZJQ09LTHhUWkc3dnhMYlZVZ29jTTdy?=
 =?utf-8?B?aUFPMXR3bzRORWt5OENPY2tTc3A2QzRhMmVxTUp5UFIxOVFyT1VXS2JUTXlu?=
 =?utf-8?B?b01OVWpUWjZQa2pCblh0a2lpc2Q2bkpKcitFOUY0OHJJcjdjQkJGRUNTeWF2?=
 =?utf-8?B?MFlwT3ROQkIrWTZrcVRwTnBYY1dSWXFNeHdnMWtzSDN5NVcyUzhYNzVSdlN1?=
 =?utf-8?B?VjZmNHdhaU1oN3Jwcml1dktmZWMzVHhWVVQwN2djTjluUFVtL0JRRlROdTZC?=
 =?utf-8?B?QlFYdmJqSUh3c0tGYVZBNi9hakhJY0lkQzg1cU9BYVZHcS9NbGZyemF0c2hs?=
 =?utf-8?B?OFhNMW1ZdlNxclZaSUxuQmg1OFlyYisyTWExVGFuM3g1Mms0aTI0WlY0WFRD?=
 =?utf-8?B?SmlyS1kwRktOSHRYdm9OTG1GSTZXT0M2RmNmTlJVYTZkZyt1dkJhcFkwRDNm?=
 =?utf-8?B?ZTZrcEc3VlZhWnZYck9Hd3pWVTJaZjRZQ0EvbnZMZnBHeWo0T3BGUG85bVhY?=
 =?utf-8?B?Rkl6ejFXS05QSnlDbE9sNWlRQnBxYWdLckJmT1lBTW0yNkZoU1ZNd3AwMmZi?=
 =?utf-8?B?emtFZCsvc1BsRWdQQXJrdU92MFV5a2FNSjlJTXJKdEJabjdxZENHTGZkZVMr?=
 =?utf-8?B?ZkNUUStkdTdsaDkwSlJqc3Uya1g1N3JiNmtGeVJlRlgydlJNU0VTM3ZPQ2c1?=
 =?utf-8?B?ZVRzVnF2QU5mdE5HODVMTDgzSkFTTmFzc1llNzY5dWFPMmlCa1VKWFA2UVIz?=
 =?utf-8?B?ZXhkMS9EdXZYODkzbENEbnJ6RGZkdUMzSGhOdzM4UUcvZk1CTkZGNHZhNjRu?=
 =?utf-8?B?RWw4ZVQvZThFYWNBSU1RNlFrWWtZVUdvbWtTTHVsR1owUFM2STQ3bDBaOTZF?=
 =?utf-8?B?bWhHMzdPV0o1bUFYY2Z5YnFLeFZQdzA2Q25yUzE1UVordWFmTzQxeFJDM3JJ?=
 =?utf-8?B?Zjl5TkFRNWpVdU4rMlcrckRCRUViUHBlRWxOdGVkVjFMbVorV0FrcGN4Y2FJ?=
 =?utf-8?B?L0tYUUw1UElVVXpmZHRHMkdUWDRadFMxTWxOMmxtYjBtUXNKU29kZllYcFRF?=
 =?utf-8?B?alE2V2hZTStlY2h1TENXMEM3MjQwSnpweHhRbGZQMkljOFJ6N0J1WDV1Tnpl?=
 =?utf-8?B?QXlibVNUelFFbkRoem5zamp4MnVacm1YMk5aSUFsSU5Wd2U2Mk9KdHhpaVJp?=
 =?utf-8?B?RURhRjAxTFA3YldhQ0JZaDJ3ZGJNOGo0ZFV2aG9LQVRMYWhjNXo5dUswTFZI?=
 =?utf-8?B?dHNIU2V2dUk5Yk9kYnFXd3Jxd0V5SndzYVVuNXpaNHUweXFaOGxYWHV4K0Mx?=
 =?utf-8?B?SkVTaCsvTXEycWRxL1piY0VGVndsNEl4cXhmU0svczR0aUZWbXdZcTJVd1VL?=
 =?utf-8?B?UjBqamVXbTY5T1ljMWZVdTdkRFhRLzJjbU4zbDk3aVZSVFhzditsNjFKbUw0?=
 =?utf-8?B?Q1AvT0dFNGFmL1k3akNXbG1SSUJPaStyK2tqNWhoZ0MrbUxyNDZYUzFWV01s?=
 =?utf-8?B?V3ZYT0tscXlQemdBRmRqT2RZS2lVL05YRitZbDJRTXRRWDlDRlV5bHE4WG1M?=
 =?utf-8?B?bnB6NTg4QVhoNTl5SFo3S0VJUCt2THhNWWEySXRjTFpDVHpsck9qM1REMjdr?=
 =?utf-8?B?eTRRMnJZazhEdmlqM1AvVWh1SHo1VUJHMVFzUElGRUFMcHpIQTdPU3o1TXVO?=
 =?utf-8?B?cEVPeWlwQklFNHFyY2UzUkloSnE5YnIvaGYzYjViNUF3NDdicnhud3NWSFNy?=
 =?utf-8?B?eSs4UHd5cWRSRHJCNVlMOWVXeG5BaXZSS2VvcVV1dzFXNnc2MkdKcnQ0eko2?=
 =?utf-8?B?Qll3UFNCbnc4MjlJUFFDTU9EdE45TUxDOGRPbnBmWjVyWGQrS2U1R09LMzhq?=
 =?utf-8?B?VFpFa2VucTBqMGRZOEZUQmNyaDE5YnR5MmcwL1B4ZmxTTE54VGRPOEN6SzdM?=
 =?utf-8?B?VWxPOTFoQ01SNHFVZTFvb2VoM1YrUEw4cmxwcGJlZjdXMHJkZFg3dEV4Yllu?=
 =?utf-8?B?MXljWDdYUG1oS3MwbnBhelhTTXZHdnczNWYvT3ZiSHVPLzVXeENiZUxRWFBn?=
 =?utf-8?B?M0RNRUszdEJiSDBuUzVIQ0xackNPclpzQVNsUXgrcTVYZU9yNG02elAwZnc0?=
 =?utf-8?B?eThjcktOL2ExdVAxUHRNbnptR3M5MG1ySG5FeVJNWklyUDNCQ0RucDB0TEVF?=
 =?utf-8?Q?jI3Qwld8mBTfXBcfSeSSLV/H3KAgJ8mM52lrxBhSIY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D8EF4444F4CC7F4DA46619993C6E5334@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c0a7a4f-f356-4596-981d-08d9c1a493fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2021 21:31:24.9534
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wb8ExPak6EVNVidIp3SOPzl7ST/Ba9I2LWzVW+fEqwxOw4bNQUsy4pqIcs0EDimM3GFizLadGfL/nBSroHvVT/Z4L+OTnszlzdR45HMIy3o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5509
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDIxLTEyLTE2IGF0IDEzOjQyIC0wODAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIEZyaSwgRGVjIDEwLCAyMDIxIGF0IDI6MzQgUE0gVmlzaGFsIFZlcm1hIDx2aXNoYWwubC52
ZXJtYUBpbnRlbC5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IEZyb206IFFJIEZ1bGkgPHFpLmZ1bGlA
ZnVqaXRzdS5jb20+DQo+ID4gDQo+ID4gQWRkIHBhcnNlLWNvbmZpZyB1dGlsIHRvIGhlbHAgbmRj
dGwgY29tbWFuZHMgcGFyc2UgbmRjdGwgZ2xvYmFsDQo+ID4gY29uZmlndXJhdGlvbiBmaWxlcy4g
VGhpcyBwcm92aWRlcyBhIHBhcnNlX2NvbmZpZ3NfcHJlZml4KCkgaGVscGVyIHdoaWNoDQo+ID4g
dXNlcyB0aGUgaW5pcGFyc2VyIEFQSXMgdG8gcmVhZCBhbGwgYXBwbGljYWJsZSBjb25maWcgZmls
ZXMsIGFuZCBlaXRoZXINCj4gPiByZXR1cm4gYSAndmFsdWUnIGZvciBhIHJlcXVlc3RlZCAna2V5
Jywgb3IgcGVyZm9ybSBhIGNhbGxiYWNrIGlmDQo+ID4gcmVxdWVzdGVkLiBUaGUgb3BlcmF0aW9u
IGlzIGRlZmluZWQgYnkgYSAnc3RydWN0IGNvbmZpZycgd2hpY2gNCj4gPiBlbmNhcHN1bGF0ZXMg
dGhlIGtleSB0byBzZWFyY2ggZm9yLCB0aGUgbG9jYXRpb24gdG8gc3RvcmUgdGhlIHZhbHVlLCBh
bmQNCj4gPiBhbnkgY2FsbGJhY2tzIHRvIGJlIGV4ZWN1dGVkLg0KPiA+IA0KPiA+IFNpZ25lZC1v
ZmYtYnk6IFFJIEZ1bGkgPHFpLmZ1bGlAZnVqaXRzdS5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTog
VmlzaGFsIFZlcm1hIDx2aXNoYWwubC52ZXJtYUBpbnRlbC5jb20+DQo+IFsuLl0NCj4gPiBkaWZm
IC0tZ2l0IGEvbmRjdGwvTWFrZWZpbGUuYW0gYi9uZGN0bC9NYWtlZmlsZS5hbQ0KPiA+IGluZGV4
IGE2M2IxZTAuLmFmZGQwM2MgMTAwNjQ0DQo+ID4gLS0tIGEvbmRjdGwvTWFrZWZpbGUuYW0NCj4g
PiArKysgYi9uZGN0bC9NYWtlZmlsZS5hbQ0KPiA+IEBAIC01Niw3ICs1Niw4IEBAIG5kY3RsX0xE
QUREID1cDQo+ID4gICAgICAgICAuLi9saWJ1dGlsLmEgXA0KPiA+ICAgICAgICAgJChVVUlEX0xJ
QlMpIFwNCj4gPiAgICAgICAgICQoS01PRF9MSUJTKSBcDQo+ID4gLSAgICAgICAkKEpTT05fTElC
UykNCj4gPiArICAgICAgICQoSlNPTl9MSUJTKSBcDQo+ID4gKyAgICAgICAtbGluaXBhcnNlcg0K
PiANCj4gRGFybiwgbm8gcGtnY29uZmlnIGZvciBpbmlwYXJzZXIuIE9oIHdlbGwuDQoNCkFjdHVh
bGx5IHVwc3RyZWFtIGhhcyBhIHBrZ2NvbmZpZyBmaWxlLCBidXQgRmVkb3JhIGRpZG4ndCBwYWNr
YWdlIGl0DQpmb3Igc29tZSByZWFzb24uIEkndmUgcGluZ2VkIHRoZSBtYWludGFpbmVyIHRvIHNl
ZSBpZiBpdCBjYW4gYmUgYWRkZWQuDQoNCmh0dHBzOi8vZ2l0aHViLmNvbS9uZGV2aWxsYS9pbmlw
YXJzZXIvYmxvYi9tYXN0ZXIvaW5pcGFyc2VyLnBjDQo=
