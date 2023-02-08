Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6469A62F
	for <nvdimm@lists.linux.dev>; Wed,  8 Feb 2023 06:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675836621; x=1707372621;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=mu52vgCbuxmAXZgKZA5AS6sGi7haj8LGcUWPmwSPlvA=;
  b=WvlR/RP0w68TX9mflRJf1AqR7kysSZPb/krR9BvjecDCRh1ZrEwJFXQR
   Ez1l2HRVonivHoqnGbmDZgCgQpkPt01u8/4rAMb4NpYVSoKRYUHSuJf6u
   UtwJohClXSoU1cwAEYyzZZy7e337bNdnl/K+yL66wRRl2tBgALARnnVYT
   sIsWYZV0sh/5bup60zpsuvtKwaSijwloSw4Gi3G7Fu3wnfRrF0nnF6jcM
   s45QeH5Z76UUTTuhhmhCvvEGJF4S4/Ia3H+H7vLPszdGM8+d6JEKC8yFc
   7QGVkBiFnS6ZUjIXntCuG/apgxNlWq1NMZiv4xBadJ/6Z/RLF5NVrIVdz
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="392118910"
X-IronPort-AV: E=Sophos;i="5.97,280,1669104000"; 
   d="scan'208";a="392118910"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 22:10:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="730737068"
X-IronPort-AV: E=Sophos;i="5.97,280,1669104000"; 
   d="scan'208";a="730737068"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 07 Feb 2023 22:10:20 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Feb 2023 22:10:20 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Feb 2023 22:10:19 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 7 Feb 2023 22:10:19 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.46) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 7 Feb 2023 22:10:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jyeUCXUpbQg7ikC2Nixd0JEM+qmVQwJVzKinHqJWln4GGXbjVlWuNEYRXJecteAOrXf0HXO4/lWqhqt8T9YwvI8Ai+802tBh1CN+jx3xwY7LZ6nS8B+WgerT0V0dkAEbG6pFKfsV5QHMtQJPCKUO2RAVzO8Y5LVfeMAPN9qdCyuEkdHmiO3zPR0CV1Za8SbIdmtGmAb/kYD2LNpAefQXLRd4wszhprYdhVKzVm640+mXmawZvuJDbYdTFR/ueiWNEzVUKNrLqghTmZABUz9AA5xiTBlOAqxAd5WSxMz6vvWbTxRovByo9trlhhJM1Gei+Z9tS0M+0G4rOCaSN2g5kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mu52vgCbuxmAXZgKZA5AS6sGi7haj8LGcUWPmwSPlvA=;
 b=CJ9Eiw8FmyDR8VpY9D4IbF9ymCZXJlwFY+2/uVkxh9Nso1GTyLFayT7DbeuBmSu9K8NpwgwleCEFRwzvYmhVzOV9PdrSq3X/3KmWKXTTLu3wsVJA88Kgu0cms+tPXqJPrEX/wMdanzazUZHA90YrO3qdHtOK7v1IWnAQRlKXToYBUyGHvBxvNtKGv9+DsD6+jKQs9bQmR2+HfLpTCrY0EqisWBgTGZBEUuZMU9u22pJumPQIqfk8EtvNicQWs9ZxDWWE2xZSjXFQzBEEjLk0ItbCW9Y1vL+e26CDgEKn/6w/2aNVmiJtsaqNwL4X8NDl7MlIGippTNtfclltDtW/Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN6PR11MB3988.namprd11.prod.outlook.com (2603:10b6:405:7c::23)
 by PH0PR11MB4920.namprd11.prod.outlook.com (2603:10b6:510:41::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Wed, 8 Feb
 2023 06:10:17 +0000
Received: from BN6PR11MB3988.namprd11.prod.outlook.com
 ([fe80::16cf:5ab1:7f74:d1e5]) by BN6PR11MB3988.namprd11.prod.outlook.com
 ([fe80::16cf:5ab1:7f74:d1e5%7]) with mapi id 15.20.6064.034; Wed, 8 Feb 2023
 06:10:17 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>
CC: "gregory.price@memverge.com" <gregory.price@memverge.com>,
	"Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>,
	"dave@stgolabs.net" <dave@stgolabs.net>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
Subject: Re: [PATCH ndctl 2/7] cxl: add a type attribute to region listings
Thread-Topic: [PATCH ndctl 2/7] cxl: add a type attribute to region listings
Thread-Index: AQHZOyjB+/fOsJsXqESd9P6Fum4Ol67Ei3cAgAAGPIA=
Date: Wed, 8 Feb 2023 06:10:17 +0000
Message-ID: <1c439ff6bac64030a8472b9daf5721515ac6639a.camel@intel.com>
References: <20230120-vv-volatile-regions-v1-0-b42b21ee8d0b@intel.com>
	 <20230120-vv-volatile-regions-v1-2-b42b21ee8d0b@intel.com>
	 <63e3378cb5248_e3dae2943f@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <63e3378cb5248_e3dae2943f@dwillia2-xfh.jf.intel.com.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN6PR11MB3988:EE_|PH0PR11MB4920:EE_
x-ms-office365-filtering-correlation-id: c3dba2a3-f6c0-42d4-47d2-08db099b2660
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qO46JA9LSpz5OucSHxVUaRzPhXjsTYi4w0AYkzN51AFuUPN6V1rHXvvM/ikvm4dMOrqLJjBkTMhiLgZ2EYdF4LX43qKFnh/humqUfoE2RCs4yfy6eJtzZhYv3vY/jZIeW79Kx7QK9p9v1ZbTvLTL1zprCSMmT/SDekAEVBwS8KZZ8eh1gbvkTI8Bn/rFpQKKW1aQW9Rj9Y8OJCAqgEOy7N9/gauAz9/xCrL++uwD5nOZQVrcdO0k4C6brFygqifXdhNzWkXQtVDY8wBULSybRyw5S+dVQ6pdbqLq65CNiVDEc/Zc0T1hFm5OB7Rax7IUNUpcBCpA/auMqt2EUXSlnwkOgLtfZUO44n+7ie5t+OqMn82ahYhC59jRQWEU+xsEsE+9kVAjChxAhgAQBj7wnvPZA8xl4jLbD8+PYxUHz+aaweXTSkV6oIx9Lwwhz1jOOhl9j/OOsunX4gCRUN592qMpPqVtNh5CPx8dJtYwIIIPFJebFN3xqBcg5pBJRhdz1D0Q0wwbfeY+R/A8DJF5bWtAoR/6+8A5utp1jjA92svlHmE03wEIiuWO64bxn2jwhM/ET6jbXqLF1YyPCc9Q0HkpxHQHRWUFOcdQUW5/6cLgnqK0xjgYuSG51HTtt9gfpVgMHw7wzbs1Za1rZKgaZo1C6YmHCwt+2ulANViMOoG2qOIib013TRNL63eXrf+KYdolVMNB92Z/dkkQdPpjdw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB3988.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(39860400002)(136003)(346002)(376002)(451199018)(66556008)(66476007)(66946007)(76116006)(82960400001)(6486002)(41300700001)(316002)(478600001)(54906003)(110136005)(38070700005)(38100700002)(4744005)(186003)(8676002)(2906002)(2616005)(6512007)(86362001)(26005)(71200400001)(8936002)(122000001)(66446008)(5660300002)(64756008)(6506007)(36756003)(91956017)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ejVNc1hxSU5FM2tsdmZtY3lycURlc3l6WVozZmEwMW1Vb211bEtFd1FtTjdt?=
 =?utf-8?B?ZkwzdnhGZFJOeUluamdFOHR4dURWNVluMGdhb2p2VW90MktGMjBzUFZWbXcv?=
 =?utf-8?B?OUxqNmU3NS9nS1VBR1JMTUJ4V3ltOUFNQVFubVlCMXAxeU1JdE44ZkYxcW1H?=
 =?utf-8?B?ZTh6RTlsa042VHlXdUwwYUlTMndtN1dFUUNIbXF3ejl4ZTFLR3V6SnpQL1pz?=
 =?utf-8?B?dlo2cmJ2cmJORFZ5Q2sxam5wN2tZQVdHdndXVG5nNUVOcTJsa0hzZm1FbTEz?=
 =?utf-8?B?bXpkK21zZ21jUFJFYzNlVzdxVnAySGRvWlRLTk5mUC9BenlRazZnYnRHejBU?=
 =?utf-8?B?azdxczJRM2RTQlFBUjlqVkxDQXQxVVp6Rk5oUVRPZUtMcFErOHpyMGVCa2Zy?=
 =?utf-8?B?bUFuKzdwVGh5VnZJekVjdDNxbVVEU2FWbWwxMHV1SklqZWlZVzBjR1Bibmls?=
 =?utf-8?B?NDlERWVWdlMwOHUrR1FFNHN4dk9NRmoyUFhJMmxNWkprYk5sNmV4YWNSbjJj?=
 =?utf-8?B?T3VFOHhJMHZmMWdqdVRRS1Y3TG1oaEdSNzNTUVBLaFhIMG5aemdvVWxSMEFG?=
 =?utf-8?B?ZG1uMzcxaVNUcmdQT0RMKy9kZkpTVFRPelhoQk9HNzM0Q3hJcFhaYVhZdFp3?=
 =?utf-8?B?bG5sUmFxYzFJSmV4U1BlTXA0NlJxUmpiTzdTZDk3VUE1ZWIwUVhLVWEyQ2gx?=
 =?utf-8?B?K0U4eEV2U3Yzc3pCU0tpWUxjbzVRcnZZcU1QY1ZTV3QvTTh5VERESVF3TVEz?=
 =?utf-8?B?cWQwMHFIR2tPN1ZnWWQvUUh3TUdISndzY1hQWXlsR3o0aGhxNXlLdmk2V0gv?=
 =?utf-8?B?OEN3U0ZvUkdEV3B3cXFQQ3g5a29BVUJxYTJydWd6aElIUjUyeTdxNHBodFVl?=
 =?utf-8?B?SXVWY1JpWUpjSzlaaVlhWW5qTkp5QkMzK0hZVmpKM1hlR2ZaaFJnSDVjaTVt?=
 =?utf-8?B?WFZvc2xDNmx3a0pXaXBONmJjaEJobFhvQXhmT2lFMW5mS2d1Z0ZaUDdjbWIz?=
 =?utf-8?B?TWkyZGZuV3FWeGlTOXRYQ1lKZzAraTIyS0pQVnJKdys0WWVxMEJKMjZXZldP?=
 =?utf-8?B?UGtPRHMrNEtLWDNUY2s5N0tIUjhaTnd1VU4zQk9pZjNlK3h2dFJ0ZW9kZkdC?=
 =?utf-8?B?TTBxMkh2QU9zemQyTk95UHVncHdwSldCbE5WVllrUFBhQkV3SmRrQUNZSklF?=
 =?utf-8?B?U0hDb2w1bzRRcHhZMC93aXA0OVVlajNOWmNJNytYK05HY1MveTRtZFNLWHlk?=
 =?utf-8?B?ZXNOMnBZZWROeUNJbmhHM0twL2JSZEFZNUNsK0pLazNVdTBVWFJmQTIvdENL?=
 =?utf-8?B?aHU5eDk5VHdpM21mSEVlTmF5Q1Zyd0dlRlE5b3UwWW55ODJ1N2t3TlNsSXg2?=
 =?utf-8?B?TVZJMExxVzFBN3I2SFlFYlk3ekNZaitGUWR2Y2tmUTIyOGtmdlBreHVWcUp3?=
 =?utf-8?B?clhTSmdaL2xIdTRQZ2xKSmdjeGFmQnU1UHZJcGd6cVdEdEgyL2RTanUrOFN4?=
 =?utf-8?B?dnd6SnUwUjd4SGs1Q2RsR1lWdUVJR1lvRkhMcVFiL0pNWndXallDTlVsNFFN?=
 =?utf-8?B?Ty9DNVNzRjNjYzQxU0F3b2pKQ1lndXRkQXdJbXhQQStLYVhNaXh4ODdqNHpG?=
 =?utf-8?B?ZHI4ZEd0MU5HaUl1ZkJDVS8yeU01TnA5bXJRenpEbWxsb0NZVXJMR09TZEZL?=
 =?utf-8?B?T0VWWlkrRWQ2YmxYTmZKaVJpYlp2bUU1UVd4YXNxRU5vSzJ4eU9wcmdJTHNR?=
 =?utf-8?B?bU4wKys5MmVLcXFEMDlRNWFNTEViMFJUb2tvK0VJZHB5a3U5RTV0RCsxa0Jh?=
 =?utf-8?B?Zk4zeFpIL0s3MXdwYk9ZcVRic01iWitnTGpPckdFdlZKRmhKWWlCenRldlpi?=
 =?utf-8?B?MVIwcVhtSGFuUVNDSDdTSnQ2OEdaY3FTdG1xVjQ0ZHRudXZxU2pYcTZvUXd2?=
 =?utf-8?B?aUxrUjBWcWV5YkxadUl4dnJFcEFhaXpoYUg4ckh3NzBwdVE0a0dKOFVCL2lo?=
 =?utf-8?B?Vmo1WXU0STJsb0NicXMwUms4ZmtLR05jSmVKWnJRN2R3eWVhWUY1ZTNhTmJv?=
 =?utf-8?B?K2lTeEpFdkFMR1FNbDNERGFubnpvQ0ZHcVNrSmlXTzVpRkYydFdFSWFHbEJB?=
 =?utf-8?B?WnlRU1NydS9NQktHUldrWXNLZHJaTm14TlZIdVFSa3U5RVVwWHFwamY5dGh5?=
 =?utf-8?B?OUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8AB5F892D9AB734A8CC3B1BDEE41ECAC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB3988.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3dba2a3-f6c0-42d4-47d2-08db099b2660
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2023 06:10:17.0857
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eKrStE441WtMc15b09onVuLdPqfOurKCGHuu8voJknjB/IIKLjuSpw4pbSWkeswQh9w/jYEbnbJqA6sZQhjgnYUq3+ZyCowlXAvEknOJFOs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4920
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDIzLTAyLTA3IGF0IDIxOjQ3IC0wODAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IFZpc2hhbCBWZXJtYSB3cm90ZToNCjwuLj4NCj4gPiANCj4gPiBAQCAtODUzLDYgKzg1NCwxMCBA
QCBzdHJ1Y3QganNvbl9vYmplY3QgKnV0aWxfY3hsX3JlZ2lvbl90b19qc29uKHN0cnVjdCBjeGxf
cmVnaW9uICpyZWdpb24sDQo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKganNvbl9vYmplY3Rfb2JqZWN0X2FkZChqcmVnaW9uLCAic2l6ZSIsIGpvYmop
Ow0KPiA+IMKgwqDCoMKgwqDCoMKgwqB9DQo+ID4gwqANCj4gPiArwqDCoMKgwqDCoMKgwqBqb2Jq
ID0ganNvbl9vYmplY3RfbmV3X3N0cmluZyhjeGxfZGVjb2Rlcl9tb2RlX25hbWUobW9kZSkpOw0K
PiA+ICvCoMKgwqDCoMKgwqDCoGlmIChqb2JqKQ0KPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqBqc29uX29iamVjdF9vYmplY3RfYWRkKGpyZWdpb24sICJ0eXBlIiwgam9iaik7DQo+
ID4gKw0KPiANCj4gSSBhbSB0aGlua2luZyB0aGlzIHNob3VsZCBiZSBnYXRlZCBieSBhbjoNCj4g
DQo+IMKgwqDCoCBpZiAobW9kZSAhPSBDWExfREVDT0RFUl9NT0RFX05PTkUpDQo+IA0KPiAuLi5q
dXN0IHRvIGF2b2lkIHNheWluZyAidHlwZSA6IG5vbmUiIG9uIG9sZGVyIGtlcm5lbHMgd2hlcmUg
dGhlcmUgaXMgYW4NCj4gaW1wbGllZCBub24tTk9ORSB0eXBlLg0KDQpZZXAgbWFrZXMgc2Vuc2Us
IEknbGwgYWRkIHRoaXMuDQoNCj4gDQo+IE90aGVyd2lzZSBsb29rcyBnb29kIHRvIG1lOg0KPiAN
Cj4gUmV2aWV3ZWQtYnk6IERhbiBXaWxsaWFtcyA8ZGFuLmoud2lsbGlhbXNAaW50ZWwuY29tPg0K
DQo=
