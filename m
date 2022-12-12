Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4CDF33D5
	for <nvdimm@lists.linux.dev>; Mon, 12 Dec 2022 18:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670869076; x=1702405076;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=aVkiq/MPdobd+zTRCs8GEBSgAq8cmd3lrPE5ZCpo2Hk=;
  b=QcTrwYMn4jmhtH6P28tLG8GY4kJoHSLO0QWjZo4K/SfqyYnvxwTCdjC7
   v+LG/ef3T4ZO6n02vWObNy73Vrp4iQXejPQrHRE3kfUQpSD+DdijOW4wV
   8dwc61/0UfkjdkyldYiS3yAQFYSF+6WQHicuNOxgk0R6STfIiAq99R+iA
   aAnwPd51EgYaO5DVD11v0WHOiR5qGDP/h7jTWvBySq/hCWjZ1alLWxiXk
   ccdOU0sCFk+RlPXmgVwe2CHxMvxhfxVHcijJYiDjDmiyVBBeI7xHA7U2s
   knj3Y5LmNYuGCUbwrStnEj5PlzWgE54YuqRaXK/iwSHY5OW/35ubAkvD7
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="315561994"
X-IronPort-AV: E=Sophos;i="5.96,239,1665471600"; 
   d="scan'208";a="315561994"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2022 10:16:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="737064918"
X-IronPort-AV: E=Sophos;i="5.96,239,1665471600"; 
   d="scan'208";a="737064918"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 12 Dec 2022 10:16:07 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 12 Dec 2022 10:16:06 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 12 Dec 2022 10:16:05 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 12 Dec 2022 10:16:05 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 12 Dec 2022 10:16:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bt2dx4YOTlrTViSEH2bDHyezXs/bP1DSjAgm9/b6c0mNPyN/0H+RKyVqGVYDwYsS9NxLX1LD3y7+FV0kcCfIF+5pASfn/KX2VWU3EbHEHo4tFcL+S/qOdsoJpnUMH8r4/o97hxzHPt+CJd5Dlnjdh0/Aw9MKJ1v80XpuNyX8ZILStlk7QoA0qcLwrpl8hXEX46BAmHzZpASlyAc1QnOrfjgt0uLDDI1wfa6GPUiQ+PB4/HIejhphdvSVrFKJJyl1jG516C67H4Kmfh4LkFW+t3uOT3fj9XDm/v8JJII3uUNlZ+VN5toSJg3fmq4xWD9uo+HaD1NEF5nXTFA0i7KrpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aVkiq/MPdobd+zTRCs8GEBSgAq8cmd3lrPE5ZCpo2Hk=;
 b=O6NJvnHJwpX2nmHdFQNTXv1A4bONm+HO0dqIPeRSBB9aa5+I9zYdcWr8cmhVi+jGmYsuYzGGKQYcTt3sBUWXbl/HG8tRRQT060x2lJD1S69HrwY8fqzO4nfSgQW/R83j7BCybet/rJtbNErpDT+UeExqG9kJ5ipzTmHCYGbxF/RcQmqcvYeDwi4aP2WKLOAsQKx+L9Mxf09e0FczzH2h7fYEkDDHB4aXChaYiWrutFWi6M61JHvx45B2RxogfJs1bUPPJX1YxtZWauluprlKwjFex4EVfAzvV2+Ti3/wHppxcCJCIktE5/lf20OR+TzTTz/6+h/X76jRLCKGH1P4VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by BL3PR11MB6460.namprd11.prod.outlook.com (2603:10b6:208:3bf::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Mon, 12 Dec
 2022 18:16:02 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::82bb:46b:3969:c919]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::82bb:46b:3969:c919%4]) with mapi id 15.20.5880.019; Mon, 12 Dec 2022
 18:16:02 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>, "Schofield, Alison"
	<alison.schofield@intel.com>
CC: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH v2 04/18] ndctl/clang-format: Fix space after
 for_each macros
Thread-Topic: [ndctl PATCH v2 04/18] ndctl/clang-format: Fix space after
 for_each macros
Thread-Index: AQHZC0wDfBGftGWXtkWub4KfVX4xc65lzwaAgATFxQA=
Date: Mon, 12 Dec 2022 18:16:02 +0000
Message-ID: <5f1d9bc6ce1b4a7a41bf4b487e4b15eb4088cc9c.camel@intel.com>
References: <167053487710.582963.17616889985000817682.stgit@dwillia2-xfh.jf.intel.com>
	 <167053490140.582963.14276565576884840344.stgit@dwillia2-xfh.jf.intel.com>
	 <Y5Nu0wD/6I29aUqN@aschofie-mobl2>
In-Reply-To: <Y5Nu0wD/6I29aUqN@aschofie-mobl2>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.46.2 (3.46.2-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR11MB3999:EE_|BL3PR11MB6460:EE_
x-ms-office365-filtering-correlation-id: bb2d1bcc-290c-430f-fb30-08dadc6ced5d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SM4UP7B9tDw1QOXWqYwYPgvzKOmYxIFRn3AfCmK2hYJT3NiQCkvnEtBNAd2HuUFFXn/yBZh9chUPwC1kEpqIRZcjVZQ20dbTzTR2UiBjOb19hRx4jlEoinVZuGOGMtkRBAkv4iMGqQalsMY1728ikX+lMlcCy+V6O840o0rw/PSV0aAb/VxPNcij6glmQPTnUvCty1M3Ip73pkrHBkfbNhsI8UizcsJ/MIBOw7rkt7fdhOsNIk4FhQHQjVKrgBZw1Dvu/AgNhLRaxD7Yj5iZWp12H76bEB+tRl86vuSXo7AuzcxectS/DXS++Wg4NiJ8XrcGegkWXSQH08+ziBasWGvdXEsAm2FW73l7+BwwmZqgt6YYz38X50IvlaayXMSwbMDcRDJb48Bfx5xrqNs6F6CwW15MvHEd2H8Fl9jJ2s/kwjQH+tFOKuEA0sFDlyVmhEAWz+tz3dsGYjTrSN2+lxlTHx+6kciBgRgpzOQkuG5jER65z5srzdRTXd6gnHV63MNpUQeof+l/YlcDnbVXD2MUfqR+Kr7zgOvHgVia8y0R3CV2wjIHYIXBZ11dleBQ2nIY7IZKio76MnRbORJ3nHi0LJQ8J9rRbo+tDkFgaMK4ZZ7DPgIjO3G12B97hsHVHeq2UbgvolUe34d1ZZhZQLZ6uo2QF+OIJXoOWGEhjzcYvzQmL2zgbkPTBeSIiPYMWij4I/RQemm2tnY/jgOpZg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(346002)(39860400002)(376002)(396003)(451199015)(36756003)(6512007)(41300700001)(83380400001)(26005)(6636002)(186003)(6486002)(478600001)(8936002)(71200400001)(5660300002)(38070700005)(316002)(54906003)(110136005)(76116006)(66556008)(66946007)(64756008)(66476007)(66446008)(8676002)(4326008)(86362001)(91956017)(6506007)(38100700002)(122000001)(2616005)(2906002)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QlQrTkhuZTN3RDlveDFwQjIyM3B6RGhnL0YzQWMzOVNTM21qYUp1RkE5UEhP?=
 =?utf-8?B?ZzRLMUdnV2ZuNHZhbDcrQzZMR05CWmFvaVNuODNQMHFnQlF0OXEvRUcyVkUx?=
 =?utf-8?B?eEU2ODhQOC9ydVZVVGRHbnhsQlhSUmIvalZxMHRvREdsdjNtTlorTmdQMHNL?=
 =?utf-8?B?dWNSdW45ai94MUdpWHJSM2g3REsvRHl6a212Sy9MM2RqcHRSSWRweWdFdFEy?=
 =?utf-8?B?Z0JsSXo3MHdJRCt3RGlrN1lpU3p0WmtYcG5sTEdvMW1SMHFWK1FZU2p0LzY3?=
 =?utf-8?B?dFR0Y2wxcFB1TkdPQmpmT0ZrYWFjWEdUTWN5ZUhOY04yNGozNTVMMEg3enlO?=
 =?utf-8?B?Uk9wQ1psSVpJVkp2OU9FNk9yT3VrM04wQVU0OXJRUEp5bVdmeGtLZVlXdEd6?=
 =?utf-8?B?UnpHOTA4dnNxaTEyMDBuajE0WFIyTTV4QVptU3lGeWVZUkVScWFZQ2l0MnVE?=
 =?utf-8?B?R1lFNTN5eGFNWkFNZlJFUHhnZm9DOG9BLzlqWDFMT2ExcnpSTzQ0Z3JnaDVz?=
 =?utf-8?B?bTgwWUY4RUVxdVJWR3JaUkZkQ0thNVJFNFpodlRmSnJsbGphQnovTElibEhx?=
 =?utf-8?B?R3hrS3ZhdVRZMGt6bGJRaG9VZktVYy9ZOWMyYVo2SE44V0dxeWZmb2QzUEFJ?=
 =?utf-8?B?YVRpUmdxcVd3ZXpFUzF2cjl2d2ppcDJ0elducCtLeFV5T1lrMGRReVhIYVUx?=
 =?utf-8?B?SEx0TFNERExXNVdnQlNPcGhiR0txOTJ6UCsyU212MlFJM3I0WXdNeDdPYkI5?=
 =?utf-8?B?UUpscjFQMFU5cUNYdjZCazJ2dDhGa0t0S3JjMFFQUjIvTWRrVUNaazVwYzkw?=
 =?utf-8?B?QjRSQzRpN0pKbHJ4TVVGRGRTai82YWxJTVdqSlJEWCsybUNQdkV3NC85dHlv?=
 =?utf-8?B?bkdtTU9GTVNJZUo4a1E4eWhiZ05ITEhoYm41VWZ1dWRIRU9qRXNtMG5YdGdz?=
 =?utf-8?B?U0RGeE44UG1LeWwrTEVoVmx0YjNyb0JnT1k4aEIrb1c0RlltMEVTcmNXNUxr?=
 =?utf-8?B?Z1UvYkF1OEhRNmY3VDFlZ09IbGlFK3dUR0VPdlo0N1pJMk5SWXY3VHR2UVVy?=
 =?utf-8?B?NnVxRnhVWGx2cU1OUUJ2cldSelRCb0tMeDM4NE8zU0VSNFNnbUUyWml2ZmJh?=
 =?utf-8?B?TG9IY0M1dmMxbmpnUGpKSHJiRi9jbVMzUGhRZnhQNmQvTTI2Y3FxSzk2azR2?=
 =?utf-8?B?d2hEZGg5cWR4TXdmNHdZRm1PTEdXd1l6RkpRNGNDWURaVUtKT2Y5ODgvS3E4?=
 =?utf-8?B?ZkxWYXJ1ZDZoT0p6WHRpLzNxaDRQTU82MkRwaVBXWWFlOWQwMXBBU2ZjSmE3?=
 =?utf-8?B?M0RJREFkOGc2T0lFMzNHNzFxY0Jhd0VCRk5YWjgxci9ablJDQ3M4TFowMFZi?=
 =?utf-8?B?aWJnYVhlcTJ5aDFxOUFPY3dINkFkbjl5VVgzTHhjcHVtbnNrRmlBMEtPTHpO?=
 =?utf-8?B?N2hUaXRRSVBYNkY1bkdwalJPak5QVlhubDVUdVZFdWRmWmxrMDFXOFZ2cVkx?=
 =?utf-8?B?Nk5WN25wWHZxaXZEcHJpZlVRTEh0R2psQVdRUW9KelRsU2o1bEpJWWlGWUpY?=
 =?utf-8?B?RDN2akFDK0F3RERtVTB3dm1YOVFwRzk2UmtLWjZlQ2NjYm0wcHIzZHRRa2Er?=
 =?utf-8?B?T3V4bkZGUDlSWExWVlJkYlUrcDA1MUVGWHpaUGZ0WXdGMklHNjUzK00vdzV0?=
 =?utf-8?B?MWFOZDJWOEFPQm5UdGVsTjZEaTMvcHN1dEFoZjdkRkdSbERKdFUxWmVwNmVJ?=
 =?utf-8?B?bTVvd3NKVWVWYWhMcjlVWEhDTndQMG5ObVhQMytObVFHRnpWU3QrLzR4RFBr?=
 =?utf-8?B?MStjZGMxaTZrQVVJckdLNUYyNVhNSEdxdmZFdkxFMzMzUXJYaGJJRzhsYmJC?=
 =?utf-8?B?a0xzMHRqWFpMRzMzSWYxYnE2aEtrTDlPaXJGUkRJRHZkZjFwbVU3TDk2YTVP?=
 =?utf-8?B?R1U1TGpRcmp4K0lVSksxenJJZEpzRjJYaG16QWk1enQ1akFMV2R1ZW9EUFha?=
 =?utf-8?B?RWFscXFQTTlMZXYxUW5wR3ZHS0tXYjhGV1A1OCtnK1ZlZDV4eHJNcUNOMjE3?=
 =?utf-8?B?YXBMV3A5UUZaSElVQnBaYXNoQ2pvdFQ4YnhqTG85WGlzcjNPVnFVTEN5Y2xw?=
 =?utf-8?B?dkR1ZlVJdFNTNnJHVmRZeVdubThjd29pZXh2RjJwbVBkUUJPQVNwQnRrdjFu?=
 =?utf-8?B?TlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B269ED3269897B41B7811FFE6C65BF38@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb2d1bcc-290c-430f-fb30-08dadc6ced5d
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2022 18:16:02.2659
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2buaaRQIo/P8HdMsmU/1yLGD2D1EBEFAe4vehKkHCEbCdEuk7tsY5XpfdPzO65vpLULUqKO4j99dA9eSx7AGtUUkLmYnnqt1jstyVxAN0ig=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6460
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDIyLTEyLTA5IGF0IDA5OjIyIC0wODAwLCBBbGlzb24gU2Nob2ZpZWxkIHdyb3Rl
Og0KPiBPbiBUaHUsIERlYyAwOCwgMjAyMiBhdCAwMToyODoyMVBNIC0wODAwLCBEYW4gV2lsbGlh
bXMgd3JvdGU6DQo+ID4gQ29weSB0aGUgYXBwcm9hY2ggdGFrZW4gaW4gdGhlIGtlcm5lbCB2aWE6
DQo+ID4gDQo+ID4gY29tbWl0IDc4MTEyMWE3ZjZkMSAoImNsYW5nLWZvcm1hdDogRml4IHNwYWNl
IGFmdGVyIGZvcl9lYWNoDQo+ID4gbWFjcm9zIikNCj4gDQo+IE9uIGEgcmVsYXRlZCBub3RlIC0g
J2N4bF9tYXBwaW5nX2ZvcmVhY2gnIHNlZW1zIHRvIGJlIG1pc3NpbmcgZnJvbQ0KPiAuY2xhbmct
Zm9ybWF0LiBQZXJoYXBzIGl0IGlzIGluIGFub3RoZXIgcGF0Y2ggSSBoYXZlbid0IHNlZW4geWV0
Lg0KDQpBaCBnb29kIGNhdGNoIC0gSSB0aGluayB0aGF0J3MgbXkgbWlzcyAtIEknbGwgc2VuZCBv
dXQgYSBwYXRjaCBmb3IgdGhhdA0Kc2VwYXJhdGVseS4NCg0KPiANCj4gVGhpcyBwYXRjaCAtDQo+
IFJldmlld2VkLWJ5OiBBbGlzb24gU2Nob2ZpZWxkIDxhbGlzb24uc2Nob2ZpZWxkQGludGVsLmNv
bT4NCj4gDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTogRGFuIFdpbGxpYW1zIDxkYW4uai53aWxs
aWFtc0BpbnRlbC5jb20+DQo+ID4gLS0tDQo+ID4gwqAuY2xhbmctZm9ybWF0IHzCoMKgwqAgNCAr
Ky0tDQo+ID4gwqAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygt
KQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS8uY2xhbmctZm9ybWF0IGIvLmNsYW5nLWZvcm1hdA0K
PiA+IGluZGV4IGYzNzI4MjNjMzI0OC4uNDQ4YjdlNzIxMWFlIDEwMDY0NA0KPiA+IC0tLSBhLy5j
bGFuZy1mb3JtYXQNCj4gPiArKysgYi8uY2xhbmctZm9ybWF0DQo+ID4gQEAgLTEsNiArMSw2IEBA
DQo+ID4gwqAjIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wDQo+ID4gwqAjDQo+ID4g
LSMgY2xhbmctZm9ybWF0IGNvbmZpZ3VyYXRpb24gZmlsZS4gSW50ZW5kZWQgZm9yIGNsYW5nLWZv
cm1hdCA+PSA2Lg0KPiA+ICsjIGNsYW5nLWZvcm1hdCBjb25maWd1cmF0aW9uIGZpbGUuIEludGVu
ZGVkIGZvciBjbGFuZy1mb3JtYXQgPj0gMTEuDQo+ID4gwqAjIENvcGllZCBmcm9tIExpbnV4J3Mg
LmNsYW5nLWZvcm1hdA0KPiA+IMKgIw0KPiA+IMKgIyBGb3IgbW9yZSBpbmZvcm1hdGlvbiwgc2Vl
Og0KPiA+IEBAIC0xNTcsNyArMTU3LDcgQEAgU3BhY2VBZnRlclRlbXBsYXRlS2V5d29yZDogdHJ1
ZQ0KPiA+IMKgU3BhY2VCZWZvcmVBc3NpZ25tZW50T3BlcmF0b3JzOiB0cnVlDQo+ID4gwqBTcGFj
ZUJlZm9yZUN0b3JJbml0aWFsaXplckNvbG9uOiB0cnVlDQo+ID4gwqBTcGFjZUJlZm9yZUluaGVy
aXRhbmNlQ29sb246IHRydWUNCj4gPiAtU3BhY2VCZWZvcmVQYXJlbnM6IENvbnRyb2xTdGF0ZW1l
bnRzDQo+ID4gK1NwYWNlQmVmb3JlUGFyZW5zOiBDb250cm9sU3RhdGVtZW50c0V4Y2VwdEZvckVh
Y2hNYWNyb3MNCj4gPiDCoFNwYWNlQmVmb3JlUmFuZ2VCYXNlZEZvckxvb3BDb2xvbjogdHJ1ZQ0K
PiA+IMKgU3BhY2VJbkVtcHR5UGFyZW50aGVzZXM6IGZhbHNlDQo+ID4gwqBTcGFjZXNCZWZvcmVU
cmFpbGluZ0NvbW1lbnRzOiAxDQo+ID4gDQoNCg==
