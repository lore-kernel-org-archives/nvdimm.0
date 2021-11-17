Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881292C80
	for <nvdimm@lists.linux.dev>; Wed, 17 Nov 2021 23:21:14 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10171"; a="320292743"
X-IronPort-AV: E=Sophos;i="5.87,243,1631602800"; 
   d="scan'208";a="320292743"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2021 15:21:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,243,1631602800"; 
   d="scan'208";a="736002942"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 17 Nov 2021 15:21:13 -0800
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 17 Nov 2021 15:21:13 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 17 Nov 2021 15:21:13 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 17 Nov 2021 15:21:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kFhPBNHhnZABqs5fasj0LeNB+rOR4Xy7OQRhbA49eVMmn4zH4jTqBk7tV7Gdyadwj9XlB/fhvC354peVCYfAgfyDSqFWfYHA1FNFVDz9UTzAs+8A4SIUSWic9U2C17feJg43WRJ43vHsbkC5HTAQKRd4VzjNMtb1aSsW0fdfeaE6mB5SpY51EtvYkNJOVc1/tYCU0W487v8LX2ak/iPehWci7kbcV5potXkZdkKYnk5MLj7nLqcVVM0+yPY868yQHSQamlZyAcx8OmsDgKpzDKaHq7VXAiTrLkMtmNKZ2sjvYKxIymxfgYbDmfPUfr6L6AIDsQCDPK4Q27bqa41e9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jm9f6+HqDnIAyfTPj98lb74EJPRcQ87BF+gPEafSJwc=;
 b=B2pb91/yLOoV62t7wWi3CBPetSzjNRe962saWElEpCZoRSBsmOHMMpaviKKeKKKG4E+mV+uAAjI0yiUfLZbz4/sF8DEHd6iFikeKfCK8M8cYDMa3GLNixxcGcg1oFrvP1Uryg3HDkhxVgoDj/QxgZf1FfbtZkIu+zNT3CWXIeWzWkPgkjlg3n9Q3pI/d9bxoGZAYwA/G5SWWIJn2IXzA2yasHbH8g9s9pbRSeFtF5h7CeypqpgLSB1HVKART61hxloopHO4GfiEcym5JpQqcwhYqCXPcSSRWryuLq5TvHImbtcWtV1OKR5tIKj2ETWP3g+9jgwuAYZTyGMJpROJ6/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jm9f6+HqDnIAyfTPj98lb74EJPRcQ87BF+gPEafSJwc=;
 b=up4nRmJ/o36Gae/wGaORNHC7VvYysSYeoYeEifLWjOS/aPaxT6o+DrHc1BAvK89VWp7lb9RT2ESdoz+zD2KdxrqiNBJCRBWA50aKF3d9vqSnyWgCR5mnlHhkWy5fJ4gYab6i9MMCxItdAWP/ASHDWGMEWMMA1GYoCJvXq6SYzik=
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by MN2PR11MB3568.namprd11.prod.outlook.com (2603:10b6:208:ee::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.16; Wed, 17 Nov
 2021 23:21:12 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::d8a5:47b2:8750:11df]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::d8a5:47b2:8750:11df%7]) with mapi id 15.20.4690.027; Wed, 17 Nov 2021
 23:21:12 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "qi.fuli@fujitsu.com"
	<qi.fuli@fujitsu.com>, "Hu, Fenghua" <fenghua.hu@intel.com>,
	"qi.fuli@jp.fujitsu.com" <qi.fuli@jp.fujitsu.com>
Subject: Re: [ndctl PATCH 5/7] util/parse-configs: add a key/value search
 helper
Thread-Topic: [ndctl PATCH 5/7] util/parse-configs: add a key/value search
 helper
Thread-Index: AQHXnkdS0F8p9Tc8FUWy/ad20qUv96unb8QAgGFnSQA=
Date: Wed, 17 Nov 2021 23:21:11 +0000
Message-ID: <cc6dcc69c1fd54c294e1d1b51ff31de3364e38f9.camel@intel.com>
References: <20210831090459.2306727-1-vishal.l.verma@intel.com>
		 <20210831090459.2306727-6-vishal.l.verma@intel.com>
	 <CAPcyv4jLQY0XMy=+3wLHv2PJ=ogFU12yuD2xj9RRjs+=H1jAUw@mail.gmail.com>
In-Reply-To: <CAPcyv4jLQY0XMy=+3wLHv2PJ=ogFU12yuD2xj9RRjs+=H1jAUw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.40.4 (3.40.4-1.fc34) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8d1e28f0-8991-4be9-fdc4-08d9aa20f1b7
x-ms-traffictypediagnostic: MN2PR11MB3568:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <MN2PR11MB356854522FDF0148D7B6BD0DC79A9@MN2PR11MB3568.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8sSovdxTieCdJDwl/o2o1h3AE736HZgQ4KxtBE1uG57DAf3gMylgKx16CHipWZKSXcN13eLsYnvJ7JNEAjkKqbwWX+mHzu3wYW66eW/8Vo0eB3BmgZX0Qt9lndu/xX5ypIxgb+ua0hUytRxv9hjcouAjEoKu+jE2zXOf6nJis6GAotPZAW3zQ7uTKi6LhuirQaTAaxx9U9HbJgFXlZGJocptCgUQcLDTumwzKkg74pKO/EmkfVqMczStwdgoepSQLnE6rD9cfq/Xx5vqfu7Et2gdUpcMoqB+NfJn8B9ECqLdh7T1qPs1qfbbIF4bgF5Qm5aqYt+ty8LnXbIN9h/LCuNSoY8UDqk2w2WZcB8DuqX4NDelylmC5S436y33QjmQ5L+/NWs6slscJ6wQtkA3jqJO2ZR3+vJ+q4E6bKoqsOmxghxcwIvhrs2CXl6m+X7JCVAs3JyPUC6aclWcPnjTkS6EV3pWG06b2Mavzgn4XQFaZNHtD+dkSE4gscyBudWrCYVxeKfXbxXmba+5fzbY6CyvLAVrOjuiHdRqCyKTjLmeODr9yPojyz09YVb2edGPCl/sW/Zs66ghavpQw1kOrSKPRHBQFgDP7H+rGC/KhbfZO8U6WlI2rrVTX4sEVGdU6Ud0QrhFZe9DKr2i48noYf19hmDNQhHuITbpnie3R4AJ+VhpE69owCaaEaHHA/Ex
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(186003)(86362001)(66446008)(6636002)(2906002)(91956017)(76116006)(53546011)(6512007)(6862004)(38070700005)(66556008)(64756008)(66476007)(4326008)(66946007)(6506007)(37006003)(71200400001)(82960400001)(8936002)(508600001)(26005)(38100700002)(6486002)(5660300002)(122000001)(2616005)(36756003)(316002)(8676002)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MzFOVk5lYmxiWkhJZFRya1lnWHlIRFBhSXFmeUxxWlg5QjZlYkJRdnV5MUZ3?=
 =?utf-8?B?eUt5NEUyeUNOVVRlU3E4SmF2NWU0WkdoWDBJamtkWmZDSDFpVXB1SEJHS0hr?=
 =?utf-8?B?NjlMVkszNUE2SVVDWk9CME4wbmJXbVRzSGo1OE5JdGJRREdrVFhUdnJaU214?=
 =?utf-8?B?RXQ3QUkrSG1BN1pYUmF2VFVwRGw4WXFBckVtU0pzMGxwalplVHE1TUN2eEZS?=
 =?utf-8?B?TTZ3NFVNY3NXYWc3djBjdVVMRHc5bWRjQW1rRkkzNEtsazhpcno5TVhIWUNr?=
 =?utf-8?B?b0ZxS1Ntd2xIbXN1QVdOdGZMMGtRQVdFeXpCSEM4SVdqVXBYZ0JuUTUyK1Jn?=
 =?utf-8?B?QXFBbitHTCtxSkhWbTJ0MnNIdSsvcHZPOTFLK2FvVzFBTmdpQnZpZGw0cTBt?=
 =?utf-8?B?cXRHaS8vUkpIWTRtZThPdEptN3VLeXpCc3h6K2NiQWdyYlBRaDFSQlUrSXJn?=
 =?utf-8?B?Q2wwVndGUkVQbzNNdm8vVzh2YWYwaWluNUR6a1g5bVQ3T1B2VE5CMEZCTG1V?=
 =?utf-8?B?NGJqZ3BDUTdCZE02QTVJYXkrbzZ4YkIyZytKYXczVGZ5cGFrSFpxZFBwbTE5?=
 =?utf-8?B?QmdYWTVxQ2FOZmlzbUFyclpjdFZMYTJ5OGpMTzUzd2JhS01zMVlLL3VicDY3?=
 =?utf-8?B?TXQreWpKRnJHT2g0cUR0YVM5UHpmQzFuQUZvbis5M0FkTTMwY01oM1RZRVhI?=
 =?utf-8?B?UkkzV2toeHpnYmJ1TEhoNVBWSld5STZIcENXWmZYYXAzZHIxMk93WXl0VEtj?=
 =?utf-8?B?NWkveFgraGFKcjNzaHBsdXNvZTkvYWpWd0RVVC92RHdhN1BsWjNwZzd1c3BF?=
 =?utf-8?B?WEs5cytpcmtBWkliQUYwekNMTER6QVBZMXBGZnUyOTVQTjcxSEg5SWxhTzFK?=
 =?utf-8?B?eEd3Zld2R2M5MjdtaDBPTnM2cm9qMmJ0RkEyKzFEakYzQTYzMkUvaFBQZkxz?=
 =?utf-8?B?OEhKa0t5ekVnVkFmejlubkp0ZUVJT2lHZHZUSWFkL2JYTk5NOGtobnFkTVl0?=
 =?utf-8?B?SXJtMHFvRGkvdDRjS0p5cnJGN3FaRUJPZWttcnFhY1ppR0lwNk8xckY5QUZL?=
 =?utf-8?B?MTJ6L083TnFFU0ZuU3FIRDh6V1NsaTFzQ2Rla0dJV0RXSWJFa0x5elpUdytW?=
 =?utf-8?B?TXVuM1pVMGNMQ0FtdWdOYkk2WkpkZ0NrWERlSTUvVW9aZXpPV3JFWnBnZ1Bm?=
 =?utf-8?B?d1M0U1FDUzViZ1l4Y1VCOGVPT05kaWZjNzg2TDlkMEV0UDBsUWhPeFhhUmg2?=
 =?utf-8?B?NktyTTlhbWR2WFBxSzNZQkFyckNnSVRkTFhLeXk1eUZXZmlFQXFtdnpwZlBU?=
 =?utf-8?B?NzN1SDNROVdHTGdxN1krRzY4Q3cxZVRzYkV0bjgwYmNRUWpNV1JVazNFd1Z4?=
 =?utf-8?B?ZjdoS2Z2Q0lyYkduV1VKVDV2TThySTlqQlJ0MGVDN1dFZENtY1hjTUhHczMz?=
 =?utf-8?B?MWhOcStHVlBCMkZoT2tkWlBrV2dqTEpwcGZKOEtEWUFzK1B1UzE3a1hvenNZ?=
 =?utf-8?B?RU1WNmlpTHRWVDIzc2RnRnRqS2ZWWGpyczJ0RWJMU3d1ejRUejZUOUZTRWpy?=
 =?utf-8?B?OUNiZE1PV0xPUkxMdzZ6Q1pnMWpFSTBRSFpNUWMwY2d2WU82NjNKN0VscCto?=
 =?utf-8?B?T1c2M2V2aDVaUU1qVk5NcXRnRVJYTWxHWDRaR21FcHJBOVVMaklUT2Q3em5i?=
 =?utf-8?B?MG0xYUg0cEd1dUNNV2R4MWE4Skl0U0xpbXZTSTJUaHhxZkVIOS9lU3hGMzNk?=
 =?utf-8?B?TENaTzRkd2RUNXlJbUU0K1loODhIMDVYRmxIQUtvNVBEL3VMRTg5RWV5dE11?=
 =?utf-8?B?Rng5cDl5aWZCcTBpYjBWWktLQWVKbml4ZTBhVitiOCttNHVsTnVuemIrQzI2?=
 =?utf-8?B?Y1JGdmtzamowbVU5RTZwYUZXbldBM1dQMmJCY1U5SDBiMGFpZTkramo4T3Bp?=
 =?utf-8?B?OGFkZWdyOFN4T1Q4UjE5Z1grWTQ2emdrVUhSYnBPT0xBWkFDcXdtVUk4anpN?=
 =?utf-8?B?NjlqdGpUTGMrNFhoRkRobHQ1TXdNZVBsMFJvMDhSRXRhQlNSWlIvYXVqTUNs?=
 =?utf-8?B?ZVRCeXRHMEg4d2dkYUU4dmhsRGU5c1dobEtsZTdZZW5kSytwSVk2L21kb0lr?=
 =?utf-8?B?bWtKMFNJa2xBcjZmamZ1cXpYZVZDZWtkbUE0c3EraEpwQkVaYW1RT25QM2pl?=
 =?utf-8?B?QktwMUE5SERJaHRwUE9kM3lTbTFuRmJ0RkZVbFk4eTJ3bG9ZRnVIM2gzcXEv?=
 =?utf-8?Q?AdfYvtirEsEu91Mtn/RwndcbOZDg/Hfi17SXn/Fyo0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D6AB8EF9019E294D891732FE740F6066@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d1e28f0-8991-4be9-fdc4-08d9aa20f1b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2021 23:21:11.9079
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gtbScimGBGMMrHX3HLE5+w4ihnJjPZ/5TRnfren4XvGoxotds8p5csAqnYhTee28T5ffMbSGA0CG9eLe0gxbwMHFZGQ38y74e7zkmp6OX4M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3568
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDIxLTA5LTE2IGF0IDE2OjU0IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIFR1ZSwgQXVnIDMxLCAyMDIxIGF0IDI6MDUgQU0gVmlzaGFsIFZlcm1hIDx2aXNoYWwubC52
ZXJtYUBpbnRlbC5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IEFkZCBhIG5ldyBjb25maWcgcXVlcnkg
dHlwZSBjYWxsZWQgQ09ORklHX1NFQVJDSF9TRUNUSU9OLCB3aGljaCBzZWFyY2hlcw0KPiA+IGFs
bCBsb2FkZWQgY29uZmlnIGZpbGVzIGJhc2VkIG9uIGEgcXVlcnkgY3JpdGVyaWEgb2Y6IHNwZWNp
ZmllZCBzZWN0aW9uDQo+ID4gbmFtZSwgc3BlY2lmaWVkIGtleS92YWx1ZSBwYWlyIHdpdGhpbiB0
aGF0IHNlY3Rpb24sIGFuZCBjYW4gcmV0dXJuIG90aGVyDQo+ID4ga2V5L3ZhbHVlcyBmcm9tIHRo
ZSBzZWN0aW9uIHRoYXQgbWF0Y2hlZCB0aGUgc2VhcmNoIGNyaXRlcmlhLg0KPiA+IA0KPiA+IFRo
aXMgYWxsb3dzIGZvciBtdWx0aXBsZSBuYW1lZCBzdWJzZWN0aW9ucywgd2hlcmUgYSBzdWJzZWN0
aW9uIG5hbWUgaXMNCj4gPiBvZiB0aGUgdHlwZTogJ1tzZWN0aW9uIHN1YnNlY3Rpb25dJy4NCj4g
DQo+IFByZXN1bWFibHkgaW4gdGhlIGZ1dHVyZSB0aGlzIGNvdWxkIGJlIHVzZWQgdG8gc2VhcmNo
IGJ5IHN1YnNlY3Rpb24gYXMNCj4gd2VsbCwgYnV0IGZvciBub3cgZGF4Y3RsIGRvZXMgbm90IG5l
ZWQgdGhhdCBhbmQgdGhlIHN1YnNlY3Rpb24gaXMNCj4gZXNzZW50aWFsbHkgYSBjb21tZW50Pw0K
DQpDb3JyZWN0Lg0KDQo+IA0KPiBQZXJoYXBzIHRoYXQgc2hvdWxkIGJlIGNhbGxlZCBvdXQgaW4g
YSBzYW1wbGUgLyBjb21tZW50IG9ubHkNCj4gZGF4Y3RsLmNvbmYgZmlsZSB0aGF0IGdldHMgaW5z
dGFsbGVkIGJ5IGRlZmF1bHQuIFdoZXJlIGl0IGNsYXJpZmllcw0KPiB0aGF0IGV2ZXJ5dGhpbmcg
YWZ0ZXIgdGhlIGZpcnN0IHdoaXRlc3BhY2UgaW4gYSBzZWN0aW9uIG5hbWUgaXMNCj4gdHJlYXRl
ZCBhcyBhIHN1YnNlY3Rpb24uDQoNCkhtIHRoZSBtYW4gcGFnZSBkb2VzIHNheToNCg0KICAgTm90
ZSB0aGF0IHRoZSAnc3Vic2VjdGlvbiBuYW1lJyBjYW4gYmUgYXJiaXRyYXJ5LCBhbmQgaXMgb25s
eSB1c2VkDQogICB0byBpZGVudGlmeSBhIHNwZWNpZmljIGNvbmZpZyBzZWN0aW9uLiBJdCBkb2Vz
IG5vdCBoYXZlIHRvIG1hdGNoIHRoZQ0KICAgJ2RldmljZSBuYW1lJyAoZS5nLiAnZGF4MC4wJyBl
dGMpLg0KICAgDQpJIGRpZG4ndCBpbmNsdWRlIGEgc2FtcGxlL2NvbW1lbnQtb25seSBjb25maWcg
ZmlsZSAtIEkgZmlndXJlZCB0aGUgbWFuDQpwYWdlIHNuaXBwZXRzIHNob3VsZCBiZSBzdWZmaWNp
ZW50IGZvciBhbnlvbmUgd2hvIHdhbnRzIHRvIHdyaXRlIG9uZSAtIGJ1dA0KSSBjYW4gYWRkIHNv
bWV0aGluZyBpZiBpdCdzIHVzZWZ1bC4NCg0KPiANCj4gVGhpcyBsb29rcyBnb29kIHRvIG1lLg0K
DQo=
