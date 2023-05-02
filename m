Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C6F33C0
	for <nvdimm@lists.linux.dev>; Tue,  2 May 2023 20:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683059544; x=1714595544;
  h=from:to:cc:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=R97nkUhBZQjHifQlIq2rlbLlXbGm2XGJT0SMTV6og1k=;
  b=Y731m9cudumo8dElGgL7egFQiesirOdnDub+vCwX0oWPkY+UBe2N8ba6
   jElDD9mp8ElCu8ad6FpFdjUNXRB3kiYNGgJvkTfhKOYGnI4xkouqefWlt
   O6P5Ly55itt0hXii3BhaNc5cz+B5zAIsarUAdtJsvsA6FCIn/kxnCbLz9
   aeMy+EHm8iIsE0FGbjOh2SAzaWu/KTZr7kq6dzQRloj9nwqnZKzONyn8r
   OYa/9+1oGeRo9X2UNsDwUkZExEVVqGOgFxxjlHbNs2+vU8njAtYLFC3Ty
   HF5vEOVkHAft2PIiMdMm6VegfoE2Pw4p+II4XNTPpa5Yuoo88UGnzFqn8
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10698"; a="411644302"
X-IronPort-AV: E=Sophos;i="5.99,245,1677571200"; 
   d="scan'208";a="411644302"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2023 13:32:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10698"; a="765908323"
X-IronPort-AV: E=Sophos;i="5.99,245,1677571200"; 
   d="scan'208";a="765908323"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga004.fm.intel.com with ESMTP; 02 May 2023 13:32:23 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 2 May 2023 13:32:23 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 2 May 2023 13:32:23 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 2 May 2023 13:32:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=biEySr6tLnmoQjUi2EkMJ8GZ8oQKboCJhsVR+8qT63zVcaAR3ofZVUnwtyoVP4sjBcPkB+uCWS7qPkc5gzb7g4uQphP00l1aNrY7/DgNDCPfXZS1aoFw7eIvBAPoRraYb27TfM6kM5LgwzflG3h1okKwStuvV4xBmrO7I0Dhut0IpeDR290QXevpeNrlFB5neAcjn9S8jymGxcOE9s3PjWal1GNOxL80hGd13/INaQlSeSIfMiLl+xcbAPtcbm8MnhkTIex+Bi4YKTaWcv5SM1f3npOhtpNo+9rAFTtoC9WWkG6mj/2iY49fyNQdY4GfcLklEyDf/T6EUvOSjygbaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R97nkUhBZQjHifQlIq2rlbLlXbGm2XGJT0SMTV6og1k=;
 b=JK2R0C7Umt9/Qxwccrc0ASwPyzsLjjDzkDVQFdlUr3C6zmYgKrtgdepWdWCP7L+RhYZNEGHQVfKzevZBGXp+3LQwjPUaHot5i51hXeo/kLIsZL4R0Z4G6Teo75ciJ00fSUf0D2pt5CB+Xb7Y6EmgGnfj1TxO7fAmRl6vVlidXC8Su469G0MBTZYXb6fhCVA0kGJukLD3/JjcCj4a73yOe+xYAUF47jH7yWYFd2YDJs4ynowhQT9tOtDM9wZ8BH2KUprt8HIbzmNlXZXFDSnugVx3PIt14cm5MjVmmxfG2YvRrrOBzy9K0dM2n7i/sk4MfrEVbtF/R1KT2KFHwCf8hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by PH7PR11MB6955.namprd11.prod.outlook.com (2603:10b6:510:206::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.30; Tue, 2 May
 2023 20:32:19 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::3403:36be:98a3:b532]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::3403:36be:98a3:b532%4]) with mapi id 15.20.6340.030; Tue, 2 May 2023
 20:32:18 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
CC: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: [ANNOUNCE] ndctl v77
Thread-Topic: [ANNOUNCE] ndctl v77
Thread-Index: AQHZfTUwh5/mqCjyE0uEA1tXCR5zbg==
Date: Tue, 2 May 2023 20:32:18 +0000
Message-ID: <5de1dbdeb8484c91ca6a159d48b9f01e7afb2407.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.48.1 (3.48.1-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR11MB3999:EE_|PH7PR11MB6955:EE_
x-ms-office365-filtering-correlation-id: f3fad290-8d39-4930-4473-08db4b4c5328
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Rdsy2EN1cFwfeaTSLJEQ4vFmiSX7dxFaJvxb08YUO0fxVggfkxjwCN+/xgDp3H4Q7xLAvJCCYDSlC4l6I33XVWtnew5AfY6Fv/igMknqCAoTeZCg5FvPOYj7VUdpLQRI52m2HoFQ4K9FLKQXgN2oDY/tfZH7xtH1EU/C2P5JcEpY1wYvkTXSempMg7VfhQbuvWl12RVleodRHGrtQc+BfW2w906Vvles5pKijtoRskD51Qc54SeRVV2TTbhWOdVkx8dvo/4peKLihABaYelHFbtf43i74oOOy8rYiWz9MXxyZg+8Os5PjAT+GgIB3tsK0RmjLh9yWKeG+aIhNJ03Mp1r+9GIWZPGSMoHh9wTHp5aDTBZ2y7dId+30Mb9E/Fj44C/1KG7f+8taEOTAkp7LOuB9HC3CsqMSOuYA9wM0eAZhobC3ffx/ggDHVpAZ0yBGBRjQhThm+lTm8pZhY0/Phootyz5mhTqbTDsMlH84DN90MUTpCp+2VdkwxSTzh/uhjiUYEz6Ka1XtrtGkWqdZ+W6+NfB4pteJvKkFBcI3kUU6Xk89a5J9Gy6JuYMWIdJEe4gB73Up6wZKN2Ixk5NAmvB2/Cm+8uHMdKqfekgOMs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(376002)(136003)(346002)(39860400002)(451199021)(122000001)(36756003)(38100700002)(82960400001)(38070700005)(83380400001)(186003)(26005)(6512007)(6506007)(966005)(2616005)(6486002)(107886003)(110136005)(478600001)(71200400001)(66946007)(8936002)(91956017)(4326008)(76116006)(66476007)(66556008)(41300700001)(8676002)(86362001)(64756008)(2906002)(316002)(5660300002)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TkREQlpsQjE4UGVibkQ0ZVNPd1JXSXVZWWUvQWcwazRSbEhEVUtvTitPdU1Z?=
 =?utf-8?B?RzQ5bzF4Mm9ZTE9nRFBRcW5ReDE2allpdWNYSGo4ZkVyZDdEdXdzbWpmVFlB?=
 =?utf-8?B?bnpaYS9GOVFEOHZNeHRrblNTYTByOUVEeE9KTVdhdjJkNFBPVzltd0FLZjlK?=
 =?utf-8?B?ZjdSbDB1MVVZOUlxcjFySkswYk5rVzUrL25ER0UvdWlmOFdtbVpaT2QvZ2VP?=
 =?utf-8?B?aHhqSFhJTGtiRVAyRzhtVG1tZ2VJbVRQZXdwMVZQV3NZK2pHYUt3azFXTlZq?=
 =?utf-8?B?aFlGNmFzY0RSaE1aeHlJWklXYlRONG80Z1REZ056NkRCaGEzbnBESjBTL2Rp?=
 =?utf-8?B?YUxxdXRCcUcrRHlXb2pya3ZQcFpXNHZYSEp5cXpYQWREeGF1YlVxMTFyU2VM?=
 =?utf-8?B?OExRZnlDNy9kUDBHMFkvcDZkVWJTYUpLd2NZTXlNM0lLczcvbmNCM2R0N2xm?=
 =?utf-8?B?RnNxZlpLQW9Tb0hEK2RPOEswSFVkbjd6REtUTGx0S1JrSmM1aWMzd2EvQUJ3?=
 =?utf-8?B?N3pWT2dtaXkrTnJHelNpbTljdkthWVh0bTR2THNITEFOZURuL2o1bnExaXIw?=
 =?utf-8?B?ckRicjZnS2VSVmFxMHFxdFpmRW5ITHU0N2ZsVWVIS0xzZjdxcVFrM256a1F4?=
 =?utf-8?B?bzZtbVpnKythVWhZRDFFejBlNFhYeldFaFFtWUVQNXFCTlVCa2RMUjd2RHVS?=
 =?utf-8?B?Vy9YRW0xMTFOWmxTR2w1cGlNOVd3MWc3aDcvNjJmS1NWZlR3OFc0aWE0TjNm?=
 =?utf-8?B?SzBMV1p6M0tsdjlxRlNuVldQdFg1NGdqZ3cxNzlITDE2T3cvUk9LbmNiLzhM?=
 =?utf-8?B?WThZdjRTdEFCMXRtU0Z6WWRIbTdHOWFoejk5czlaaXUwSDQ2UTZ4cis1Tnhp?=
 =?utf-8?B?THBDUXphbXdOWm5LZEt4VEFZQk1BbUJJOGNxZkJ6S3ZDQ09Pdnd3eWhSeURa?=
 =?utf-8?B?c0JiRFpHKzU1UXZyRUZsRElqMGd0MG5KOFU2MXcwd3RHRWtDeVZJSzlyRzFN?=
 =?utf-8?B?L2UyTEcwNmtZSDRla2FCbEdiZy9XZ1pwVFE1ZmtqMkhuMjUvbzVNU0JwbXpy?=
 =?utf-8?B?TTQzYjYwd0VhNW9Xa05kL3ZwOEUyRjBFY0dlSytWa3BHbXBuTWdRMm52V1Vq?=
 =?utf-8?B?N2JuYmpLSElNU0daWmRKU3Bwcm9vS2g2QjllVEhMKzk1Y3ZEZlRqVU1oQzRC?=
 =?utf-8?B?Mi9uSWZRKzJ3WEFuZHlTa2REaEsxazZqWEo3bjFFNlE0R3BnRWppUjdwbTAx?=
 =?utf-8?B?STJqbmZ3bzFTMytYdTBuWEdZUG0yNGkyMzBxQ29IQVQvSU9DVVQ2eElPSjRn?=
 =?utf-8?B?TWV5N3BtSGwrMDV1em1VcjFZTkIwL0VROU1uOG5YbytFald3ZTQwOWlaZDRp?=
 =?utf-8?B?b081ZFp6Vk9mOUFTN1paeEhVK2c2QURKTVJhNyt1WGpUVXB2WTkxRDFxQUlR?=
 =?utf-8?B?YVZFWU1vSDNQczI4Mm11UGtQN3ZLejAzY1NXdTMwOUppaEdNVFJVc01QTjN6?=
 =?utf-8?B?blhFeWJhM2JMRGNhN045MXBQY254ZDBDYU1sSGRGTXVwTW14N25SUDRlVGU1?=
 =?utf-8?B?Qy9DVG11WC82TTg0NjljV2xhdjJKcFl5YzVDZDdWYWVRNC9zbnJXVXNlT3Jh?=
 =?utf-8?B?VFUvWVJrSk1vc0NoV2FKQU9oeHlUQ0Z6WW5lOHByeUMwMS85cHVYYlJYaGp0?=
 =?utf-8?B?Y1piNUpjYW40K2FUVkxMcTY4V0Z3cXpFVXp1YU5peTkrTjNwcFIxN2xUbmYz?=
 =?utf-8?B?MTd2OHBTMS9rSkVIZE5KNGVhejkxS3FVV2ZOWTh4WHZqQzZHZTE1UFBmcyto?=
 =?utf-8?B?UUc3RGpHc1JNcC94SWU2UTM5enM0dkkrNDdyZHUyR3diT1Nna2ZoaysxVnE3?=
 =?utf-8?B?YzBvckV3UG1XRnVFNEMvbStMR09udGFQWTVhcnJOMmNIM25ETUxIUmtPQUpN?=
 =?utf-8?B?QjkzUDJXM0VPcnMramw4ai9oU3piajFhbWkxZlZXNzg0TDVVSlBQMEE4eVh6?=
 =?utf-8?B?bmpWeWk2R3BGV015WWt1VW5yWlVXZkdSalI4ZWxLVU5wNFZ2SExSVHBEem5X?=
 =?utf-8?B?b2ZTMXQ0TXlhdEFiaHFjNG5LUmFjMzNpSm83RWRYcFBjUjg0Wm9QbERNVXh6?=
 =?utf-8?B?SmMxRHBBaldoRDZYUHZsbHFSK2FsRHdnMVJsZHZJZlJoZmtlZzljSnN6b3Jw?=
 =?utf-8?B?d2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7E36FE9EEC707F45BF44705E38BD3DCD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3fad290-8d39-4930-4473-08db4b4c5328
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 May 2023 20:32:18.7254
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xmexJdTD/o+xShnesDZQOZIcOHDH9L+MlxZ5y0iwaYd25K+I1Y791vo2dbyWL/dZ0E/vZDLxH6aDJDzZUNV3ykxC9aufJ4nfRz6thYBq5R0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6955
X-OriginatorOrg: intel.com

QSBuZXcgbmRjdGwgcmVsZWFzZSBpcyBhdmFpbGFibGVbMV0uDQoNClRoaXMgcmVsZWFzZSBpbmNv
cnBvcmF0ZXMgZnVuY3Rpb25hbGl0eSB1cCB0byB0aGUgNi4zIGtlcm5lbC4NCg0KSGlnaGxpZ2h0
cyBpbmNsdWRlIHNvbWUgYnVpbGQgZml4ZXMgYXJvdW5kIGN4LW1vbml0b3IgYW5kIGV2ZW50IHRy
YWNpbmcsDQp0aGUgYWJpbGl0eSB0byBjcmVhdGUgcmFtIHR5cGUgcmVnaW9ucywgc29tZSBmaXhl
cyB0byBjcmVhdGUtcmVnaW9uIHRvDQphbGxvdyBhIHVzZXItc3VwcGxpZWQgVVVJRCwgY3hsLWxp
c3QgZml4ZXMgZm9yIFJDRCBkZXZpY2VzLCBhbmQgcmVnaW9uDQpsaXN0aW5ncywgY3hsLWxpc3Qg
ZmlsdGVyaW5nIGltcHJvdmVtZW50cywgYW5kIHNvbWUgdW5pdCB0ZXN0IGZpeGVzLg0KDQpBIHNo
b3J0bG9nIGlzIGFwcGVuZGVkIGJlbG93Lg0KDQpbMV06IGh0dHBzOi8vZ2l0aHViLmNvbS9wbWVt
L25kY3RsL3JlbGVhc2VzL3RhZy92NzcNCg0KDQpEYW4gV2lsbGlhbXMgKDgpOg0KICAgICAgY3hs
L21vbml0b3I6IE1ha2UgbGlidHJhY2VmcyBkZXBlbmRlbmN5IG9wdGlvbmFsDQogICAgICBjeGwv
bGlzdDogSW5jbHVkZSByZWdpb25zIGluIHRoZSB2ZXJib3NlIGxpc3RpbmcNCiAgICAgIGN4bC9s
aXN0OiBFbnVtZXJhdGUgZGV2aWNlLWRheCBwcm9wZXJ0aWVzIGZvciByZWdpb25zDQogICAgICBj
eGwvbGlzdDogRml4IGZpbHRlcmluZyBSQ0RzDQogICAgICBjeGwvbGlzdDogRmlsdGVyIHJvb3Qg
ZGVjb2RlcnMgYnkgcmVnaW9uDQogICAgICB0ZXN0OiBTdXBwb3J0IHRlc3QgbW9kdWxlcyBsb2Nh
dGVkIGluICd1cGRhdGVzJyBpbnN0ZWFkIG9mICdleHRyYScNCiAgICAgIHRlc3Q6IEZpeCBkYW5n
bGluZyBwb2ludGVyIHdhcm5pbmcNCiAgICAgIGN4bC9saXN0OiBBZGQgcGFyZW50X2Rwb3J0IGF0
dHJpYnV0ZSB0byBwb3J0IGxpc3RpbmdzDQoNClZpc2hhbCBWZXJtYSAoOCk6DQogICAgICBjeGwv
bW9uaXRvcjogZml4IGluY2x1ZGUgcGF0aHMgZm9yIHRyYWNlZnMgYW5kIHRyYWNlZXZlbnQNCiAg
ICAgIGN4bC9ldmVudC10cmFjZTogdXNlIHRoZSB3cmFwcGVkIHV0aWxfanNvbl9uZXdfdTY0KCkN
CiAgICAgIGN4bC9yZWdpb246IHNraXAgcmVnaW9uX2FjdGlvbnMgZm9yIHJlZ2lvbiBjcmVhdGlv
bg0KICAgICAgY3hsOiBhZGQgYSB0eXBlIGF0dHJpYnV0ZSB0byByZWdpb24gbGlzdGluZ3MNCiAg
ICAgIGN4bDogYWRkIGNvcmUgcGx1bWJpbmcgZm9yIGNyZWF0aW9uIG9mIHJhbSByZWdpb25zDQog
ICAgICBjeGwvcmVnaW9uOiBhY2NlcHQgdXNlci1zdXBwbGllZCBVVUlEcyBmb3IgcG1lbSByZWdp
b25zDQogICAgICBjeGwvcmVnaW9uOiBkZXRlcm1pbmUgcmVnaW9uIHR5cGUgYmFzZWQgb24gcm9v
dCBkZWNvZGVyIGNhcGFiaWxpdHkNCiAgICAgIG5kY3RsL25hbWVzcGFjZS5jOiBmaXggdW5jaGVj
a2VkIHJldHVybiB2YWx1ZSBmcm9tIHV1aWRfcGFyc2UoKQ0KDQpYaWFvIFlhbmcgKDEpOg0KICAg
ICAgdGVzdC9zZWN1cml0eS5zaDogUmVwbGFjZSBjeGwgd2l0aCAkQ1hMDQoNCg==
