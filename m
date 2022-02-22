Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62EE566A1
	for <nvdimm@lists.linux.dev>; Tue, 22 Feb 2022 15:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645545363; x=1677081363;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=biCzH0f6ld/ly/fylgu4R+ikeUHpDrgZLMe/Rls817g=;
  b=VNGAkHzVh0ssywHoH/jMuE9OCQzegZ3+o7MDGhekb9+VSutEmbv9k8cH
   TPuMZMelsrxrS3gqyZjYn/HG7oNmTuY25EE29W9kqYIP8rE90PB87s44w
   gkxA1LuqIHWKUfGCdUjkxznKTsCPI4s8+4wXt3ONrKJZz9V5kG0S0Mlh/
   LaK71Cmhqum5gS1QRdeqbHCt66WDI72M18Q5ahQu38NDsPzbH6AyhsIxA
   oP7kz+9v2P5ntslr2hhNdnU3ORnv3UM4anYp+kIsteK+EcVmdQWJaxdR6
   QW5E6F440/GncyFCrSk5Luv+5l+SNV61vI2K3qUg4eQiUa24PGEhEwedu
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10266"; a="312456073"
X-IronPort-AV: E=Sophos;i="5.88,387,1635231600"; 
   d="scan'208";a="312456073"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 07:56:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,387,1635231600"; 
   d="scan'208";a="779310856"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga005.fm.intel.com with ESMTP; 22 Feb 2022 07:56:02 -0800
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 22 Feb 2022 07:56:02 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 22 Feb 2022 07:56:02 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.106)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 22 Feb 2022 07:56:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ehVk7xPOxxKVKWf5GaOkc6UaBm9PrdZ0v6+yquRgx2z3MBFbsmBhnMitLgEXNmzGuGfaTnLntPujlrWbFd49G8TLM+zfwwYVFdpiMczCm4PaFLkjTx7lSBWzeDiR7xykRy1gCmqyRPwZppB0XTHfs/URuaRGQALngnTOzViJ6pTDhOH083ZL2DZbuxbLXos3ljLFPo3gu6hfuw5Ay7ZevaTNjX5wITUKoCUC3KTQWYP1LV+oqGzn8Kvswb5WfsUP/jU7sWECm042XTGj0l22wd41lOM7U/eP6p38uDAI7hgT78MlIpBHVvchh1kSQbz6iolsmM99ESsN7A+okmOYRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=biCzH0f6ld/ly/fylgu4R+ikeUHpDrgZLMe/Rls817g=;
 b=SfI81N4XRO1YZ/AkpX+2jApz57mHRpYqN5frJQKHWxI74BLocqYpn0EO86LRbebxO4aHkaC84Z3RCateCx0Fyi/FuBtSPI7smVlowYqcY0FbeD0dCFmDnTUOTJex9EnZ69u+54nZBHSmLrJysiuW8P0kggmA4TSqj2zrsqfbsKFznjmPuBqH8iHYlraHCf20ZNpiDxqg9+iYNXs5BMvpvWxb32ewbspAijFcJn5hMJmRQ3/5MBtSAoKeZFf2RaZS2GfbjvzfUl2WQ6YZ0j3OeSGJTE0MgQktRXbFWppxGfyC9Aihf3k2xzDyJCb0L0mCNY/kTkAW3yr9Jufif+4Yjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by SJ0PR11MB5120.namprd11.prod.outlook.com (2603:10b6:a03:2d1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.25; Tue, 22 Feb
 2022 15:56:00 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::d02d:976f:9b4b:4058]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::d02d:976f:9b4b:4058%7]) with mapi id 15.20.4995.027; Tue, 22 Feb 2022
 15:56:00 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "vaibhav@linux.ibm.com"
	<vaibhav@linux.ibm.com>
CC: "Williams, Dan J" <dan.j.williams@intel.com>, "aneesh.kumar@linux.ibm.com"
	<aneesh.kumar@linux.ibm.com>, "sbhat@linux.ibm.com" <sbhat@linux.ibm.com>,
	"Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [ndctl PATCH v4] libndctl: Update nvdimm flags in
 ndctl_cmd_submit()
Thread-Topic: [ndctl PATCH v4] libndctl: Update nvdimm flags in
 ndctl_cmd_submit()
Thread-Index: AQHYEWUquHiSWKDHeEyEG94NPf2YAKyaK4gAgADNOACABO3TgA==
Date: Tue, 22 Feb 2022 15:56:00 +0000
Message-ID: <5e159e75b9ff3dfdaa46a7cbcb1c251786294f0b.camel@intel.com>
References: <20220124205822.1492702-1-vaibhav@linux.ibm.com>
	 <555f5d150e4d55dce788bf0ebfbc029409b21260.camel@intel.com>
	 <87h78v9gj3.fsf@vajain21.in.ibm.com>
In-Reply-To: <87h78v9gj3.fsf@vajain21.in.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.42.3 (3.42.3-1.fc35) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b3ded45f-c1ad-496f-9c9e-08d9f61bd257
x-ms-traffictypediagnostic: SJ0PR11MB5120:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <SJ0PR11MB5120915DACED29EAC83762A6C73B9@SJ0PR11MB5120.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: befT2F+5EchbNDM+goiCgwooaDJRYw5tb6Av43BfK4sJKD8gq6wlMoCUNnOztu408omp6TaqSzkRsuDLhbykwfyqs9n4d4y9uX4MYTatXaRGSd48tYzRON0221fyp3UPc6BujEd1t+hdcrSrnDw/yXOOkQiYAkBhy2qvdxvBS0msELCGFJZCxq+W6pHfdRHqmQR3KafQOmC9hPsVnh8q9b69G7ZJzJ0ekXFTbeHVRjSyiXpLiD8aY8KL1abzmNLYDM6U6qYowC9rhiFUXTfXcyeNMWDLeXvxkv8Ikh3VaWr2FPZOfDBOYVmQtoRLQk7lUeoJQaoNfW1bGbzgxbKuq+aUaNPHpWsnTJBab5JfOGmOYhLmfmZB3Qn9RhWg1BrUvqyhtRRmJt1oiA2oXUwS2e6uHKJtUC4BLnXM6B/2iEUNTSYXicmJ3o7669oMdC5SQVS85w/AZ/aebo30UCzZK8iUGx5LkErdZyB7/ktcIjjvehfPS/90wkbluyua+i6onmdmuUIheFcfOKODRSFmN8weFVDKnZf48lTaaDD9vRqOT4R3Yty1VmcFHLRzbXmvZQ0VF/vANOdaW1Uy9iC8YHLqGufYcThCGpC5e5d9dPQ7TyUjwLVkxC4GyksJ/b3amkmeSk0qutQvujs/e/5N2SqfpGsJ2lFYT7j6E8ZBYvGefzC3g5QBfzu2XgK67FxhTlzbMXqWpT04IF692WLUAw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(2906002)(54906003)(110136005)(83380400001)(6506007)(15650500001)(8936002)(5660300002)(66946007)(91956017)(186003)(76116006)(8676002)(6486002)(2616005)(38070700005)(4326008)(64756008)(66446008)(66476007)(66556008)(38100700002)(71200400001)(6512007)(82960400001)(508600001)(86362001)(26005)(316002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bWxRUGE0ZG0zbmJ5Z09pcWRLUGZJV2syQkRUVElxZkE1NTFzcTlCK2VqeUxk?=
 =?utf-8?B?K2hTNzBCclZESGZmdHNZVUZRTXQ0d1o4TmtvUjJ4MmJvQWdBS1NUTjg1MWVt?=
 =?utf-8?B?TnYxWGl3MGVlUHZhaXNDYVUvYTZSeE1OMjJ1SnE0bWdTWGNXVVBhM1RheDht?=
 =?utf-8?B?Vk1aTE9lbi9iemdKWGJhMEZHdkJnTW1lMWdtVDcxMWpxUHJ2aDBIVE9XWEtZ?=
 =?utf-8?B?dmpTMDBNTzVEbVlXRDJBN0RWZHc4VGY5SEZiM0FNMkk4QVBQSjU3V3dhMmpC?=
 =?utf-8?B?TTRBeDE4OXI0MkY2NTdUWkt6Z1hyRGliMFpUck1mR0RRNUpaY0t1aDB6TGdW?=
 =?utf-8?B?UHZ0Zy9HMTk3SFJCU1N1TTlsZjhacnBGczFQNlFCU05ONDJFcXg5K0RTdy82?=
 =?utf-8?B?OGFrZ2g2dklXb2EvcTc0eXpZZmNVWERxVi96WmlicmZCRnNJakQ3UE9jZ3U4?=
 =?utf-8?B?YXZzb0gyZGdqSzJKb25uUnhiT21MQWtmQTZRMWFVSmN4bnNmaGVKTzB4MWNV?=
 =?utf-8?B?VDlzcGVueVlpTTJGVDg3YjlkNTBKeXdWMUhEOHdIQWhjRmU3cFJnWnhaaG9E?=
 =?utf-8?B?WHhnUmhNdFpkVnQzM3NBMEg5RG9ZSDRFMzRNUjAxQ3NiaHE1Y29XSDJEeTI2?=
 =?utf-8?B?WVZpYnFuYUduaDZYNDNGWHVBRC9HeFUzRTFyYlVaUmtVK3pkcmJIc1Z3eGdD?=
 =?utf-8?B?N2ZiN1FveENhSTVkS2l2RzN3K1RBNE9YeUp4UXBQNnZwdkt3bWwweW13OGhD?=
 =?utf-8?B?QlVwYm9FNy9aS2lXejFDV2VpWncxYVF3MXRGTS8xcWtLaGQ1MU12aUVUbW1U?=
 =?utf-8?B?aE1mRVZwd3dVWHhKQ3JNOE9CeEhlcHJTdHpFOC90ejhmZGl1VUs5K3htdGV3?=
 =?utf-8?B?Y2lWUmhpZmdmK1dVV0tjNWZ0bFp6NkNwTTV5WjUwSHJoeHJWNUo0NndzT1NK?=
 =?utf-8?B?cXVPK3o2SGZHTnpaLzQrOGRhWTI2cEdvOExRSGlRZ1ZEa1E0L21NTDgraG1P?=
 =?utf-8?B?WHZkcW9pR0ljUVJIa3VCZzMzR1Q0c21GUVdUV2wxUkJvUUJZY3MyY2FHeGU3?=
 =?utf-8?B?Mld0dEs1cXZZSnJLa25CS1J6bExoQlMvN3l0d0lHTWNBVEVUUVVHRTRmWmJB?=
 =?utf-8?B?Ym9ka1BnTHhrSGllK3RPRnk2NHRPMGFxRFZtbUhCSEdTSVovY3dRM1daNXlU?=
 =?utf-8?B?RC9zRkF4SllYTS95Vmt2VDFEMjE5SjlRS3pLSTdZd0pRb1A1dTJobDZNZzBJ?=
 =?utf-8?B?TUhmQ0NXTlVYWk9nU1BkQmw4UWFqTzQ3RW9saHhBOGlxWWtaMTkrb2JSYU9L?=
 =?utf-8?B?LzNsVlVFNFQ5MXhmOUEwRjhXdW5kOHU0NjRVZWdWbEkxOXVJWnFSZEhRdzlj?=
 =?utf-8?B?TkNOSkluYzZkODg0dk1HazFLQ3lpaWRsVGtMNDNTZHJVOEp3REN4Q1pmSXk1?=
 =?utf-8?B?Z1NiVWdWK3ZFZzFPaFl6cjgxY1BFQ20yTkJXV1I5d0VZYkhmM0RPa2hqbnk1?=
 =?utf-8?B?NUExbkthNWY3bmR0djhYVEhGR0FhZ2k1aEZ4dldPTEMzWmY5N0ZYcThwVDRH?=
 =?utf-8?B?NnVwVmlnNVlvamR1eTVYQVA3MDFNVmRoQ2VLZVdwaHA3VW9NN2p2amljRmMz?=
 =?utf-8?B?TlJqMWYxLzlTcU9JS1g5d3E1aTYvVGtHd3dleXU2L25mRG05aHlvR295NktB?=
 =?utf-8?B?Nm5lSlJOOU5JTFZwWmFhblA2ZjlnY2l1SnlEckxvUkFKYzRFUUl0MFpTc3Ar?=
 =?utf-8?B?YU44NVQ2T3RlNXVDYzJNUmllSWF4ZlVuUzFPOHlUalB6WElUZHFUa3Zta3RC?=
 =?utf-8?B?eGpmWUJEL1FhM3IycW9BNmtoeTc3cnZDRUcyOXZiUGhlQUx3bFdzM0tJQnV3?=
 =?utf-8?B?RFk4QUMrbGZvK3lrNHJQWDRyNDlsUmdBcEExVHNEazZpZ1Y4Vndxd05XK2lt?=
 =?utf-8?B?MEFZZTRLNlJ5SzlFMUR0emRnMlVVTjdVK2d6U0E1dG9UT2w4NXV5SFgyU0ZZ?=
 =?utf-8?B?SlpkTzQ5WHcrZXZpK09yVFRtMXNxTzlldFVEaU1pR3VYY3FEQ0tMOWZjVCts?=
 =?utf-8?B?eUFkT3N2c1Zqa2RIbC9Lc2RsUWI0REZaTkJkQS9IZUVoNTdsS21xcHFEMVhV?=
 =?utf-8?B?QjM5dEdpYk8zTVFTVUZJSmRsaEIrR2RrZG5aeTQ2S3dEU0o2cThnTzFySi9S?=
 =?utf-8?B?cEt1Ylp4WkFwRGlKQzU3dE0vdWsydU9jVUl5RXl6UlQwYTR0WVozbFpWYk1w?=
 =?utf-8?Q?gxFJrgS/ZzechyY0Nu9JSMpBxkuPF5GjBQrUztg58A=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <86A51B130642274EBF99779CA4D15262@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3ded45f-c1ad-496f-9c9e-08d9f61bd257
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2022 15:56:00.2361
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EXzffn5odJWay0z4kppFO1uj19ZlCQ41IYL5nRAfsV2qXLPCTabfUh+dXRHmFWHceQRnEbQK5AF2KJBRWo0ERvyoj5i/qbpVt/Eqr62RHQ0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5120
X-OriginatorOrg: intel.com

T24gU2F0LCAyMDIyLTAyLTE5IGF0IDE4OjA5ICswNTMwLCBWYWliaGF2IEphaW4gd3JvdGU6DQo+
IA0KPiA+ID4gQEAgLTE5MjQsOSArMTk0MCwxMyBAQCBzdGF0aWMgdm9pZCAqYWRkX2RpbW0odm9p
ZCAqcGFyZW50LCBpbnQgaWQsIGNvbnN0IGNoYXIgKmRpbW1fYmFzZSkNCj4gPiA+ICAJZGltbS0+
Zm9ybWF0cyA9IGZvcm1hdHM7DQo+ID4gPiAgCS8qIENoZWNrIGlmIHRoZSBnaXZlbiBkaW1tIHN1
cHBvcnRzIG5maXQgKi8NCj4gPiA+ICAJaWYgKG5kY3RsX2J1c19oYXNfbmZpdChidXMpKSB7DQo+
ID4gPiAtCQlyYyA9IHBvcHVsYXRlX2RpbW1fYXR0cmlidXRlcyhkaW1tLCBkaW1tX2Jhc2UsICJu
Zml0Iik7DQo+ID4gPiArCQlkaW1tLT5idXNfcHJlZml4ID0gc3RyZHVwKCJuZml0Iik7DQo+ID4g
PiArCQlyYyA9IGRpbW0tPmJ1c19wcmVmaXggPw0KPiA+ID4gKwkJCXBvcHVsYXRlX2RpbW1fYXR0
cmlidXRlcyhkaW1tLCBkaW1tX2Jhc2UpIDogLUVOT01FTQ0KPiA+ID4gIAl9IGVsc2UgaWYgKG5k
Y3RsX2J1c19oYXNfb2Zfbm9kZShidXMpKSB7DQo+ID4gPiAtCQlyYyA9IGFkZF9wYXByX2RpbW0o
ZGltbSwgZGltbV9iYXNlKTsNCj4gPiA+ICsJCWRpbW0tPmJ1c19wcmVmaXggPSBzdHJkdXAoInBh
cHIiKTsNCj4gPiA+ICsJCXJjID0gZGltbS0+YnVzX3ByZWZpeCA/DQo+ID4gPiArCQkJYWRkX3Bh
cHJfZGltbShkaW1tLCBkaW1tX2Jhc2UpIDogLUVOT01FTTsNCj4gPiANCj4gPiBGb3IgYm90aCBv
ZiB0aGUgYWJvdmUsIGl0IHdvdWxkIGJlIGEgYml0IG1vcmUgcmVhZGFibGUgdG8ganVzdCByZXR1
cm4NCj4gPiBFTk9NRU0gZGlyZWN0bHkgYWZ0ZXIgc3RyZHVwKCkgaWYgaXQgZmFpbHMsIGFuZCB0
aGVuIGNhcnJ5IG9uIHdpdGgNCj4gPiBhZGRfPGZvbz5fZGltbSgpLg0KPiA+IA0KPiA+IAlkaW1t
LT5idXNfcHJlZml4ID0gc3RyZHVwKCJwYXByIik7DQo+ID4gCWlmICghZGltbS0+YnVzX3ByZWZp
eCkNCj4gPiAJCXJldHVybiAtRU5PTUVNOw0KPiA+IAlyYyA9IGFkZF9wYXByX2RpbW0oZGltbSwg
ZGltbV9iYXNlKTsNCj4gPiAJLi4uDQo+ID4gDQo+IEFncmVlIG9uIHRoZSByZWFkYWJpbGl0eSBw
YXJ0IGJ1dCByZXR1cm5pbmcgZnJvbSB0aGVyZSByaWdodCBhd2F5IHdvdWxkDQo+IHByZXZlbnQg
dGhlIGFsbG9jYXRlZCAnc3RydWN0IG5kY3RsX2RpbW0gKmRpbW0nIGZyb20gYmVpbmcgZnJlZWQg
aW4gdGhlDQo+IGVycm9yIHBhdGguIEFsc28gdGhlIGZ1bmN0aW9uIGFkZF9kaW1tKCkgcmV0dXJu
cyBhICd2b2lkIConIHRvICdzdHJ1Y3QNCj4gbmRjdGxfZGltbSonIHJpZ2h0IG5vdyByYXRoZXIg
dGhhbiBhbiAnaW50Jy4NCj4gDQo+IEkgcHJvcG9zZSB1cGRhdGluZyB0aGUgY29kZSBhczoNCj4g
DQo+IAlpZiAobmRjdGxfYnVzX2hhc19uZml0KGJ1cykpIHsNCj4gCQlkaW1tLT5idXNfcHJlZml4
ID0gc3RyZHVwKCJuZml0Iik7DQo+IAkJaWYgKCFkaW1tLT5idXNfcHJlZml4KSB7DQo+IAkJCXJj
ID0gLUVOT01FTTsNCj4gCQkJZ290byBvdXQ7DQo+IAkJfQ0KPiAJCXJjID0gIHBvcHVsYXRlX2Rp
bW1fYXR0cmlidXRlcyhkaW1tLCBkaW1tX2Jhc2UpOw0KPiAgICAgICAgICB9DQoNClllcywgdGhh
dCBsb29rcyBnb29kLCB0aGFua3MhDQoNCj4gDQo+ID4gPiAgCX0NCj4gPiA+ICANCj4gPiA+ICAJ
aWYgKHJjID09IC1FTk9ERVYpIHsNCj4gPiA+IEBAIC0zNTA2LDYgKzM1MjYsMTAgQEAgTkRDVExf
RVhQT1JUIGludCBuZGN0bF9jbWRfc3VibWl0KHN0cnVjdCBuZGN0bF9jbWQgKmNtZCkNCj4gPiA+
ICAJCXJjID0gLUVOWElPOw0KPiA+ID4gIAl9DQo+ID4gPiAgCWNsb3NlKGZkKTsNCj4gPiA+ICsN
Cj4gPiA+ICsJLyogdXBkYXRlIGRpbW0tZmxhZ3MgaWYgY29tbWFuZCBzdWJtaXR0ZWQgc3VjY2Vz
c2Z1bGx5ICovDQo+ID4gPiArCWlmICghcmMgJiYgY21kLT5kaW1tKQ0KPiA+ID4gKwkJbmRjdGxf
cmVmcmVzaF9kaW1tX2ZsYWdzKGNtZC0+ZGltbSk7DQo+ID4gPiAgIG91dDoNCj4gPiA+ICAJY21k
LT5zdGF0dXMgPSByYzsNCj4gPiA+ICAJcmV0dXJuIHJjOw0KPiA+ID4gZGlmZiAtLWdpdCBhL25k
Y3RsL2xpYi9wcml2YXRlLmggYi9uZGN0bC9saWIvcHJpdmF0ZS5oDQo+ID4gPiBpbmRleCA0ZDg2
MjI5Nzg3OTAuLmU1YzU2Mjk1NTU2ZCAxMDA2NDQNCj4gPiA+IC0tLSBhL25kY3RsL2xpYi9wcml2
YXRlLmgNCj4gPiA+ICsrKyBiL25kY3RsL2xpYi9wcml2YXRlLmgNCj4gPiA+IEBAIC03NSw2ICs3
NSw3IEBAIHN0cnVjdCBuZGN0bF9kaW1tIHsNCj4gPiA+ICAJY2hhciAqdW5pcXVlX2lkOw0KPiA+
ID4gIAljaGFyICpkaW1tX3BhdGg7DQo+ID4gPiAgCWNoYXIgKmRpbW1fYnVmOw0KPiA+ID4gKwlj
aGFyICpidXNfcHJlZml4Ow0KPiA+ID4gIAlpbnQgaGVhbHRoX2V2ZW50ZmQ7DQo+ID4gPiAgCWlu
dCBidWZfbGVuOw0KPiA+ID4gIAlpbnQgaWQ7DQo+ID4gPiBkaWZmIC0tZ2l0IGEvbmRjdGwvbGli
bmRjdGwuaCBiL25kY3RsL2xpYm5kY3RsLmgNCj4gPiA+IGluZGV4IDRkNWNkYmY2ZjYxOS4uYjFi
YWZkNmQ5Nzg4IDEwMDY0NA0KPiA+ID4gLS0tIGEvbmRjdGwvbGlibmRjdGwuaA0KPiA+ID4gKysr
IGIvbmRjdGwvbGlibmRjdGwuaA0KPiA+ID4gQEAgLTIyMyw2ICsyMjMsNyBAQCBpbnQgbmRjdGxf
ZGltbV9pc19hY3RpdmUoc3RydWN0IG5kY3RsX2RpbW0gKmRpbW0pOw0KPiA+ID4gIGludCBuZGN0
bF9kaW1tX2lzX2VuYWJsZWQoc3RydWN0IG5kY3RsX2RpbW0gKmRpbW0pOw0KPiA+ID4gIGludCBu
ZGN0bF9kaW1tX2Rpc2FibGUoc3RydWN0IG5kY3RsX2RpbW0gKmRpbW0pOw0KPiA+ID4gIGludCBu
ZGN0bF9kaW1tX2VuYWJsZShzdHJ1Y3QgbmRjdGxfZGltbSAqZGltbSk7DQo+ID4gPiArdm9pZCBu
ZGN0bF9yZWZyZXNoX2RpbW1fZmxhZ3Moc3RydWN0IG5kY3RsX2RpbW0gKmRpbW0pOw0KPiA+ID4g
IA0KPiA+ID4gIHN0cnVjdCBuZGN0bF9jbWQ7DQo+ID4gPiAgc3RydWN0IG5kY3RsX2NtZCAqbmRj
dGxfYnVzX2NtZF9uZXdfYXJzX2NhcChzdHJ1Y3QgbmRjdGxfYnVzICpidXMsDQo+ID4gDQo+IA0K
DQo=
