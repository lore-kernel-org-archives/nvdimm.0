Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B772CAE
	for <nvdimm@lists.linux.dev>; Tue,  7 Dec 2021 21:50:34 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10191"; a="237501507"
X-IronPort-AV: E=Sophos;i="5.87,295,1631602800"; 
   d="scan'208";a="237501507"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2021 13:50:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,295,1631602800"; 
   d="scan'208";a="461457390"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP; 07 Dec 2021 13:50:33 -0800
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 7 Dec 2021 13:50:32 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 7 Dec 2021 13:50:32 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 7 Dec 2021 13:50:32 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 7 Dec 2021 13:50:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RCodXP/akXWLqY9NEQZyOuW/mJj4YBQqItSD4idL3GgFStbbOh3QuiKLGhJ8XvwujnN/xPEQUJ4HbhRpkd+y9N773C1ND2DxYvaTlCZRtwZjKhnDV+D6bmCvEVamTrymqAd5CDALIJ0/q+6HHFZ/mypbT0bctL9g817DXID9Co1/pzQl4Yqv33yeJmN9J9DttGi8FMs8BsIckuLoWPNtyFDUIGy50ONYhYOcyBmouq36JsiuvzEXq8fezXkf2v7+j6HnWLZ7nRud4AFKz6Z4lSFAX5ftD8oIDdLt4ghlTVVDe4koAJnQaypFHci0gYfKlSaagXU4RXK1ZTwlBr0cIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Eo9hCdXKQch32ahFhcuM2/9a1xvpetpvFpJqTcd934=;
 b=gT7p6AKXmNnb0Ova5WCe61ZMuuU9rgvS2f0wl9A9S91uKrxYAG3A4uJ4hHGoafLNvkJiFp6vO9hlltaNjZ8edGgv0gdzbtzulk+SMarN1QKUB6bdjyUfxJVYTaPFVqB1t0fhnCLA8k/QOMP402zcIBuiWSTIG6+dVD6H0xYt9lrfX0J4Ttq0m3OX8P2qVjA6o2b0RzdzNr/84oaHcdRkgoOZIfW8lL6F6pbrVh+gRp1qPuuj7hhvCK46yYs2xW64dp9nhZsrGOS8J2920zDenA43Dc267P8AGRQbdQww/Am9HDPq7Eylf458FPwe5skhTTVCqk4EDzcOePDoStGBrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Eo9hCdXKQch32ahFhcuM2/9a1xvpetpvFpJqTcd934=;
 b=SDeoqtCxrrblrSR/L/H0QnhvjuZkalOeFKH6jBv9np449GS8q1hwnDoSRQU+Sws211nUGky9KQoiUpPKR6FQf5yRnEA7T/ywq1rzrhBDc9dJex0HlB84qtPdkMJ8y53+Di4OCoijtPCoC6DKYFnGGXc5ZJWKmZ9gDIc0bhqcQTY=
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by MN2PR11MB3823.namprd11.prod.outlook.com (2603:10b6:208:f9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Tue, 7 Dec
 2021 21:50:30 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::114d:f87:eeb5:b6be]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::114d:f87:eeb5:b6be%4]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 21:50:30 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "qi.fuli@fujitsu.com"
	<qi.fuli@fujitsu.com>, "Hu, Fenghua" <fenghua.hu@intel.com>,
	"qi.fuli@jp.fujitsu.com" <qi.fuli@jp.fujitsu.com>
Subject: Re: [ndctl PATCH v2 01/12] ndctl, util: add iniparser helper
Thread-Topic: [ndctl PATCH v2 01/12] ndctl, util: add iniparser helper
Thread-Index: AQHX6vCk6gPLEj2XqEGoHWd/o0ZiQqwnWYgAgAA5fYA=
Date: Tue, 7 Dec 2021 21:50:30 +0000
Message-ID: <fa5249423185fdcbdbf37d9e3bb85647cc89678e.camel@intel.com>
References: <20211206222830.2266018-1-vishal.l.verma@intel.com>
	 <20211206222830.2266018-2-vishal.l.verma@intel.com>
	 <CAPcyv4g4cJ_sdRT_cO9T+g_xjMoaboW+ZfHB98KL0NJaJoS1zA@mail.gmail.com>
In-Reply-To: <CAPcyv4g4cJ_sdRT_cO9T+g_xjMoaboW+ZfHB98KL0NJaJoS1zA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.42.1 (3.42.1-1.fc35) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2d4cec4f-a3aa-4b9a-831c-08d9b9cb9682
x-ms-traffictypediagnostic: MN2PR11MB3823:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <MN2PR11MB38236498AD347409D140EAADC76E9@MN2PR11MB3823.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LrFk/bJ+8Yk0IcI/yPMANnhIxbgTpckeA3FGkvh4PX2bvV42bJTQ31EjFWX76si8dYGHl6LxwcZFb5tRsr0y3YzJCdie/Uxkny/87/opIaHyP4ENBdEcBHsJ/c8Kgc/t7W+e3c+kzN0Wutuv9eVb75FWDX/p2lVmG9Ll3nhIUpfBp32qfVfqPrq/Z/E/kFv31/NxSnvr9T4uLiZfrMvoHxJj1WL15GxR8Y4pquZFjq8tLGc0d8FUABI2Zadu8YTi9oGqFub9WmFd21LeXJazvbt/GDDSPFYH1YfMZGr0s4QVEgzo8Q2krY0ofmso6WG3wjTan4cAQFK+p4/e7P5C63v+JLlUYCXeSbDJ3BKeA9rGvi8lX7Z0ijOZ6+rvu8OhgHhlP01pUIofxOZcO7JLWUMPfGuywlu5D+Cx9pJ4TLRfbNLnU9SVDb/wpd36QX/vINPjIE7xwOPad+CJ0nbTu7s0eVV/ytSC8GsdZnvp9OuTK0132Az5haqUSGiD4h8GkwmeWQJn3HfX+gxYqr0UaGVBOtMcdxgrLYQsn/cDQY5H6jIH1ZgOBrwF4vlKf8IFyhNVRXqQo4kqLj5Ln2LsxomWq7je2cAKjnhXRGIDDd1zEtqLG39JRBQbwTvB3K3u/dqBsW/awoCRATx4M9+bl5PqN8ae1pXVp9MWDOXT6Q2KdmggMV8Qema/YqllBKRJ0h1B8s8B3fZ0VJdXJKp5GtvHOhpXuiSYMkz07/0B7qu1UyBP+05jgQGSACaRdXUW6vllsIDWSu4ysNOM3r2B/BANRDOikANgx/wAKqCsPsQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(91956017)(6636002)(4744005)(86362001)(66476007)(6506007)(6512007)(76116006)(8936002)(26005)(186003)(316002)(66446008)(38100700002)(122000001)(64756008)(66556008)(53546011)(508600001)(6486002)(37006003)(5660300002)(966005)(4326008)(66946007)(2906002)(36756003)(54906003)(2616005)(38070700005)(8676002)(6862004)(71200400001)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WWF2MjFCbGxJYmxYbDROL1lBWDB5QzRrTVB0dnByVktFZXdIZXZvMGFkSEdD?=
 =?utf-8?B?SktaeHdmYUduVXpybEx6UkxvaUE4SktFM2NBSTRVbW1CN1hOeitwb2h1YTV5?=
 =?utf-8?B?TFR2QXBLSkJaWXEvVTB1T0diMmg2R210UEU5K0pyYmh4eER6K3p4bFpFdmk5?=
 =?utf-8?B?eThBV0Z4S0tybFN6djJoSGd1RUV2c0dWajBpMi9OSllUZzY3TE93TS84enJn?=
 =?utf-8?B?RENhTjdhWjRDUkdoZHBaeitQS0VjRlFhL3FPZUcwU2cwZ2ZsTU1VWmFjcXZW?=
 =?utf-8?B?UmNJZFR1ZWVGZXlONnRsWXRQN0dBc0p0Z0dNalUxQnIxbmVNbER2THdxWUhX?=
 =?utf-8?B?Q0lUMUxmNWR1NVJYcS9FM0pNTUNkaVkrTFRzd1FwWDhveEthY05PQllWSHg0?=
 =?utf-8?B?aWxyTHpxb1VnYWZkNkhuRHJQa3BnZi96OUFWZG9HSkpZZ3JFL0ttSW5Ic01O?=
 =?utf-8?B?cFBCVlBIaUZ2ekREY2MrV2ZMa0MyKzBsRGtXd1JTekpZNC9VbDRldE5tSTRv?=
 =?utf-8?B?TExXRVJXbU1oUTAvV3VLZXdMYUJPVHRLNklKSUhpSE0xVi9ROGJVZDg3a3pr?=
 =?utf-8?B?bnVvYkdHOWk4YUdEK1lCa1UxU3AvTU5EYVJoelJEN1NrekZNc0hDUmFQQzRi?=
 =?utf-8?B?WW5RVUZRUnRNSWU2MUFJMG1RQ2pncEx4UXlRTU1udVM2eitiN2NaOXdUMmgx?=
 =?utf-8?B?Z0I3UUFKdUhXYW4wTjQ4THhlb0xGNlZEWDUweEVwSlI2Q2lSSFdlN21oOHVj?=
 =?utf-8?B?SDZFYWlnWW9ZUUhacVc1NDBKY3IwNUx6SHY4Z2JibWs1TFEvemZPWTI3cVZ4?=
 =?utf-8?B?VDlMREFPZ3RyTm55Y2JjMlUxYVhWa29MUlMxTHNUaXcvVFgxQktzUStWL3Ir?=
 =?utf-8?B?WnVKeDB6dUs4VHo1WEpNZktCZ3ZBd04zN1NhMnI1S2xMYXFHYWtvdC9rOGxI?=
 =?utf-8?B?TUVIUTc2T2JzSTUrRmkwdFBoWXo2ZzV3UElSLzVBRjJra0tPNDZBeFRjc1RN?=
 =?utf-8?B?Rmk1NHFBb1BMazgzUGI5bnZTTFZPNVV2RTVscm1mcGxZbzBjWWxRZkZhMTY4?=
 =?utf-8?B?U1NvOUw0ejdKbXhLZEszcGlvQUM3ZWhSZmxPbEttOU92K3N5dmF3T3B0T3pu?=
 =?utf-8?B?QXpRUVdGN2tnZmJDUHQ2cStXZWFwMlkyNFNleUttNTJWbmYyS3ZxK1ZCenNK?=
 =?utf-8?B?TlFUaURmQisrdHhyN2tONjhWSDY4K2krU2VnQTZJMkEzRkQvclArby9KOUZj?=
 =?utf-8?B?ZmVJQ3FyUTlIY2FNdzFJV3o3cCtZQXFlc3J2TFBrcnBvTldtazZJenV0WG5k?=
 =?utf-8?B?RlRuMTNXVktNYlh3alZId015bXg5MWdmdG9vTlFENjMrVk8wTTY4ZGI2SXRO?=
 =?utf-8?B?UllIa0RiUmUwcjNVa0ZXWG5Ic2pUaHZEMCtHSlRoeVBhNnpnbFZ6Rmlzdis3?=
 =?utf-8?B?VU9SODk2Vk1PMkQrSXBieDUxY0Y1ZEhhL3NCUUU2NzNEM1pYNXpNREhabjFQ?=
 =?utf-8?B?cGdyRWprTytYMzZhdlVlLzllVlQvNmV3R3A0RWtueXg4OUZ3cWd6V0JTNTJQ?=
 =?utf-8?B?Nk9FSldnZmxGYmNEQ3IzbGlqRi8zcHdUdGN1UEN6Y2RlNkRselJIYnM3bFpz?=
 =?utf-8?B?dFFwWUdEVlpzVVg5WEt3RFV2bXhQVlc1TE5pRWg5bWxWVWJpU3pnUTRYc2J3?=
 =?utf-8?B?eUFaVGJITUxEYmUvanlVcEF0MkRjR1Npd015cmtXejhydUFlcWlMYzhrVzJQ?=
 =?utf-8?B?RHZlSzNqbHlRZzZuNlFPemczUE1zNnBMT05meG8xSThLejNDOVdvbTJVVzRn?=
 =?utf-8?B?ZjFiNldJemVwNHVTQjBqRjF4WWJnaHNjZ0w1WFZZejBWbDUzT2xXTFhTeEU0?=
 =?utf-8?B?Z3pRdTdrS1AwVlZjT1A3WlJRNmEzakNPaGtZR2FvMmVCU1QzaWMyeFYxNjNi?=
 =?utf-8?B?K0ZtS2wzRFdrWjRxbUE5L3dHYkhTSGFqZ2VDMUd5cjFVRlhGeEF6S2dCMkxU?=
 =?utf-8?B?cjVTR3doV1N3ajRFVnF6TnB2SkRkRHF1MFdMNG5QQjVzVDJpTW5ocVIwWFpY?=
 =?utf-8?B?cG5sTStpK3M4ZXVmcjdZUmNxNXRXVndKNFU2UXc1dU5sMGJaU291T0t1R1RV?=
 =?utf-8?B?UjFZZ2NHWWk1VHJRb09seDNCWDhSK0cwU2dyUW81aW1GdXdNMDhFQzNhb3hO?=
 =?utf-8?B?T3oyOUFDQUtaNC85dlZaYUtqbEYzV1VyWk5UOFltS1ZOUnoxR1g4RHhBbzh5?=
 =?utf-8?Q?nOj7Va5iBhEqI1vpqBY87RwGCmvPKKMwasAQPLNHx8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7AFA88A36A43AB468C091EC706EBEAA3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d4cec4f-a3aa-4b9a-831c-08d9b9cb9682
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2021 21:50:30.3371
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u5eiheTQcfMDlC/jpHD6n1WZvhsNoSQcwjmyuS8WTCQxO/LLqo7l9CKUQ82P95Ub/KaW7b5iAuJpCoQ7gRYorBlJSN7QcfgMChc1KQcAy7k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3823
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDIxLTEyLTA3IGF0IDEwOjI0IC0wODAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIE1vbiwgRGVjIDYsIDIwMjEgYXQgMjoyOCBQTSBWaXNoYWwgVmVybWEgPHZpc2hhbC5sLnZl
cm1hQGludGVsLmNvbT4gd3JvdGU6DQo+ID4gDQo+ID4gRnJvbTogUUkgRnVsaSA8cWkuZnVsaUBm
dWppdHN1LmNvbT4NCj4gPiANCj4gPiBBZGQgaW5pcGFyc2VyWzFdIGhlbHBlciBmb3IgcGFyc2lu
ZyBuZGN0bCBnbG9iYWwgY29uZmlndXJhdGlvbiBmaWxlcy4NCj4gPiBbMV0gaHR0cHM6Ly9naXRo
dWIuY29tL25kZXZpbGxhL2luaXBhcnNlcg0KPiANCj4gSXMgdGhlcmUgYSByZWFzb24gdGhpcyBp
cyBiZWluZyBjb3BpZWQgcmF0aGVyIHRoYW4gbGlua2VkPyBUaGUgY2Nhbg0KPiBjb2RlIHdhcyBj
b3BpZWQgYmVjYXVzZSBubyBkaXN0cmlidXRpb24gcGFja2FnZWQgaXQgdXAgaW50byBsaWJyYXJ5
DQo+IGZvcm0sIGJ1dCBpbmlwYXJzZXIgc2hpcHMgaW4gRmVkb3JhIGFuZCBVYnVudHUuIFVubGVz
cyBuZGN0bCBuZWVkcyB0bw0KPiBtYWludGFpbiBhIGZvcmsgSSB3b3VsZCBwcmVmZXIgdG8gbGlu
ayBqdXN0IGxpa2UganNvbi1jIGlzIGxpbmtlZC4NCj4gRXZlbiBpZiBuZGN0bCBuZWVkcyBhIGZv
cmsgSSB3b3VsZCBleHBlY3QgdGhhdCB0byBiZSBjYWxsZWQgb3V0IGhlcmUNCj4gd2l0aCBhIHBs
YW4gdG8gZXZlbnR1YWxseSBnZXQgdGhhdCBmb3JrZWQgZmVhdHVyZSBpbnRvIHRoZSB1cHN0cmVh
bQ0KPiBpbmlwYXJzZXIgcHJvamVjdC4NCg0KQWggSSBkaWRuJ3QgcmVhbGl6ZSBpdCB3YXMgcGFj
a2FnZWQuIEkgZG9uJ3QgdGhpbmsgd2UgbmVlZGVkIGFueQ0KY2hhbmdlcyB0byB0aGUgY29yZSBw
YWNrYWdlIC0gSSdsbCBjaGFuZ2UgaXQgdG8gYSBsaW5rZWQgZGVwZW5kZW5jeSBhbmQNCnJlbW92
ZSB0aGUgZm9yay4NCg==
