Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C3F946F
	for <nvdimm@lists.linux.dev>; Wed, 15 Nov 2023 10:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SCDCH1sT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700042887; x=1731578887;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Y0b/nbpwTwFBmbWgYQcOOdWlaMKnOYNM1a38tAJRYj8=;
  b=SCDCH1sTlI0ACX56kZrrTO/KxwMg0nSxAGnMoH2PtavXm7eqjcbA/j5x
   Uk6C5QTmkArdgQalWAje64Jh/GPJiTrcvMflb/iQDV5Rz+H+DJ40LwwvP
   erm0BLmtzJVtP40Fxg7CG11pdl7eGStPMdzAzCIaeYt8WGqdq2bbDOEjp
   4nvx0d9JiKbM35XuowttFCXfr+qckw/EhhvH3szb/axogbI/B3KIxpODv
   7QRN/HWVvkwwzouaPJcJd//IfVtNiMN+xlWeajjL4IG8M5Ie8kK+Mc3pC
   tL5TarrN6wUSbeqG5Z0zNk9qttpYoMwRYRQ2zKABGlxpvzaDaSHxPIU1P
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="421947176"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="421947176"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2023 02:08:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="764936656"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="764936656"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Nov 2023 02:08:06 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Wed, 15 Nov 2023 02:08:05 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Wed, 15 Nov 2023 02:08:05 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Wed, 15 Nov 2023 02:08:05 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Wed, 15 Nov 2023 02:08:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LTWhCsGUceZQQUgqGvpbCsBz9pA1wK9uAaz1TKsekycilySa44zdapYeMnwlwJ6NG0jKO3oQ4cLXp3qFdDFreSW/UOJf4UEs+XExwowlzVe1La2tMCrwsrtWRmxu5eEoEmBfWCUrRBcY9OEkGd3z4LZMfVTAt1GKjgaI97ZE4UAB5495iPqcKgA+AMqdMNl/j6D/cNXveTAKSAPRH2lye5nDO4JM76dOVeJVIv6AEIQxfrSJcQwVQkPQYqAygEqyJOJT2Jb7TGX2xpS9uzQ/qbPihSVEnAvpvRPmknlE/+zMB/lUy0K8XtRnWe0mJsFMKRHz/I2J1pG8/xkTSCSblg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y0b/nbpwTwFBmbWgYQcOOdWlaMKnOYNM1a38tAJRYj8=;
 b=j5TryDHJkoB050UZxtgcAnwD+2mb+OJLaGbpy6aDaW5zA0nIO1FROP9jyrKi0dDxiuEP4TKZKqKPTQCy4HfI4X42E+4QKTUgVu6B5z9mVjc2nY9QzchYIMnhaXcIjf3ILaf8yvivNtRTGh/H074lmDaMlTdQWxv8L4Muu2URfbeakeT4T5IgDZ9V6/zpANLmyxVsmL9OYgiZ3wMnP+aeaRPRsp+lEAZNykmIBp1jWDwwm+MaQbSJfG4JbiFb/q4r64wmJZbU5K31g7pPJRF7aAXy6UDWkogH5zgI8tjxjLIyDQ6wJ1z+V2ShTFYCWouYtq/Ppi9ZXjZF7WidVKSTPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by CY8PR11MB7900.namprd11.prod.outlook.com (2603:10b6:930:7a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.34; Wed, 15 Nov
 2023 10:08:03 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::703a:a01d:8718:5694]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::703a:a01d:8718:5694%7]) with mapi id 15.20.6954.025; Wed, 15 Nov 2023
 10:08:03 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Schofield, Alison" <alison.schofield@intel.com>
CC: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH v2 1/5] libcxl: add interfaces for GET_POISON_LIST
 mailbox commands
Thread-Topic: [ndctl PATCH v2 1/5] libcxl: add interfaces for GET_POISON_LIST
 mailbox commands
Thread-Index: AQHZ9LcOkKjHJkI6C0ObHw6bxmFzybB7bcyA
Date: Wed, 15 Nov 2023 10:08:03 +0000
Message-ID: <9341c2e5f120cebe139125fccfda48d2b9f9c008.camel@intel.com>
References: <cover.1696196382.git.alison.schofield@intel.com>
	 <f59b7ae3277342f54bbcf409ac075a9c122ecd79.1696196382.git.alison.schofield@intel.com>
In-Reply-To: <f59b7ae3277342f54bbcf409ac075a9c122ecd79.1696196382.git.alison.schofield@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|CY8PR11MB7900:EE_
x-ms-office365-filtering-correlation-id: 45eed7c7-09c6-44e4-a8f2-08dbe5c2c143
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Fu7JZRAMwaCFFebWGLq7/T3p26+jmgkottNQjp2CYqWKq9Dgz28aBCLHSHPHrsY1E8QCNdHOIF59jtcTJyku/oc9U7bpJP2Xe4ne5SpZAT46jzknTBky/ICLxHJBRBzxg25Iwji6CA999Ch+9EZDqCYKK7j3eTCexizJUILIit+qt/+r4E3s4kCfxXTR3jtDtfSlZluuw4WinDox78qMFG+sMWKUonPjUT6i60oHo21ul3z4lTdH/tOwE4g+HlMf48ZKDiy9spCtVJ+c/qNYIHiOAhLA6ANayc5cqSW62s2M+Yhj5r6MrzOtGnrXemyw+8S7CI3Qge8jvsVy53c4pr96kzJhxaqXYC7p2h84aZRh86cMVNoaLZ/5/FYVBnfZtLDx6Awg+tiTw4ACto+zR3nlbt7j2F5jKH1N3cqO0bOczhAK9pGHzZuF9LMshmcbAh81C2x7biCj9ogaYRvTkS9Lsc9toJ6nzia0vqgEKOReSEE1OgvL0VEpyfdgjKUM4/yqKu6ZGZ04KixB4p6E33+FECHLayxhTvta7jiBOG5HQ4mtE+Q4YYh40ZrEuN0NfE4/ybg+87ztrWP/mHdZNHRUqS1FgY7kffuTZwc3QulTmc9iOBwbyNseDJD3FqTu
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(396003)(366004)(39860400002)(346002)(376002)(230922051799003)(186009)(64100799003)(451199024)(1800799009)(66899024)(5660300002)(2906002)(64756008)(54906003)(37006003)(6636002)(316002)(8936002)(6862004)(4326008)(8676002)(38070700009)(66446008)(36756003)(122000001)(82960400001)(41300700001)(66476007)(26005)(2616005)(6486002)(83380400001)(66556008)(76116006)(66946007)(6506007)(6512007)(478600001)(86362001)(71200400001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RmdxUm0zNHdsQ0JJeTI0MktDS2pjd3l4WGduWDBlcElOa09xVkNuV0sweEVQ?=
 =?utf-8?B?THJQSjl3eEJTemEzTHYzK0poa2o0TFBIT0JQd3hvdWlpeEpWT3ZsalNUWWR6?=
 =?utf-8?B?QkRzUVdSeTc3bFVBNG1XTWJQVzE1bFFrMlB2MUlNa0Y5Sy82dmJiQ3lLTWQ4?=
 =?utf-8?B?Y2JVdmVUOU5VeCtCZ3AwZVBFd1lNcDFNcUlJOWRPYVZBQkYvam4rRlVZaGhJ?=
 =?utf-8?B?cEI2eXUvYk1mNjVUcmUxa2RFMEExb3FHMlE2djRpSFRGdGFFSUFUUU1lMzlM?=
 =?utf-8?B?bFBEZFI0MGUwZ3ZFcEI4dkRTYllybmFreE4wcTdUeVNsOXZuWXREaUx6QVBS?=
 =?utf-8?B?ZWxEWTZpYVFkeldRWk5XekpmYWRrOHdtNldVU2huUEtINHdveUtkdnJPK3Uw?=
 =?utf-8?B?OVVyb2xRU1pudENVaU1HMFpCS0FGUFp3UW1Db25lRDI1SGdDNWVka0F0M3A0?=
 =?utf-8?B?ODh2eU5EcUZ0QVFQOEZ6eWcxa0swRnhwbWN5VkhENHR2UmZlTy81cFRCOUpz?=
 =?utf-8?B?dTFNWFVlaEZYZXdrZ1RNbEZBWkJJS3hDWmJoNDdUTi83VXF3cCthRDFZUGNY?=
 =?utf-8?B?UmNqZnBzUGg3TDhBSXZIVmFxWG9kb1drN011NHdOVy9wRC9Sd1Rzd1Azc1cz?=
 =?utf-8?B?UW1DNzZHRG5kU2FyVkJVUnlPMjJPTzRFVXF1QjBTSW5PTU56RzNubStPbUw4?=
 =?utf-8?B?WFhsVUR5RzJZamUwZzhGYkRvTS8ra1JOR3pxcXhOMmQrVWozdE5OZmttNW9Y?=
 =?utf-8?B?cU9FNlhaMEQrMGgrUHYrU0VGaEMxS1YrTGg2THA0MWV0dTA3djFOZjVZbWov?=
 =?utf-8?B?M3YrcGlBREJRUVRRRXdoTE43UW1CUGpOdGRsby9zUmNUQmt2WTFGZG5EbWxm?=
 =?utf-8?B?b0dTZ1FUeUcrS2JCTiswTk9jc0pGcmNoMUVBMEJNSEY1R3A0WFpXa3FQNFFT?=
 =?utf-8?B?RkFlZjJDU0hpNGdxaE5OMGU2V1lXODRPWm9lNWMrdEg5eDNiUXNLYU9aeGNF?=
 =?utf-8?B?Q012b1BseWpCSloyQzlUaktWN0RBbytmdGszZWJ0VWRJQkI1SkY0RSsvbnA0?=
 =?utf-8?B?QUNRcktWYWRzMGVSeFlxTVR3eHFhdTBsblBOZ1ZVK1pMUWRkTnBsM0htSHNL?=
 =?utf-8?B?c25NQXpEdCtSekdlVG55ckxWcHZCeFdtWldPVmlkZFRlRlVyckdidmJzelZX?=
 =?utf-8?B?WHowUFd5L2l4ci9LUDg1RERSN1ZJdzd6NG11TkhRUlE1aDc5WTlpNzVqZ2Nt?=
 =?utf-8?B?ODJDNEcvVXF6N3BNQ1FXS044Y2EzVVdublp6bTdxR25NdGZudXl6YVpqNGpS?=
 =?utf-8?B?WGZHU3Qvb1NoZ1YzbUo0TFdrVjVETlp5N2FOZlZhandlaHZXa1N6UHIrcW4v?=
 =?utf-8?B?eHhTMnFSbG9ucEpvdDV6MUg2QS9la2FUK3BzajJrbGpxOHFrVHFhYXkzWlYx?=
 =?utf-8?B?M3VZV3o4Q3VhdWd5YXlPN0hWVmppZXlQM29WSVZ4d1o4SHZvN3V5R3JmR3hG?=
 =?utf-8?B?WitpdUtYUzZndFpJbXFrQnJIaHQ4VklCbitiZ1V1UGM3bE8xQnB1K0JqcVlZ?=
 =?utf-8?B?Vzl6VnpCMVZEYWRGdm83dlo1eGhUL0VFc3k0eHMyTC9WTkp3MTI3OVdxWklO?=
 =?utf-8?B?SXFJQU85bzQrUW5QVUhwRktybWtsUC9BQTBjYjMrWU5DZDRPamc3WHdEUVVq?=
 =?utf-8?B?YllpWmEzMHdnUXFhak5IQVptdVN1SFo4cjFFSS9OZFlodWhKOWxQYmdLT3h1?=
 =?utf-8?B?M2JPRXIvTWpQTlVUcHh3SFlCUjdwK3NJaEVlalZRMUdVREs5ejVTaVV0V0RG?=
 =?utf-8?B?Uk5TQ050U1FXTUR4RHRmTng5eWJRTHdUTGNuaWgwS01ZNzBKTk8vZDF1Zm81?=
 =?utf-8?B?cnJ3eFRyYm5EaDdvUERHaXRzUzNyZmY5ZWRMZ1k5YUxBMUJXR1ZtZVdXcmdO?=
 =?utf-8?B?azdjSndFczNwalRIbEtOdkJ3RTBRUzY3N09NSU8waGdpa2pwWm55OHpjM2pX?=
 =?utf-8?B?bEtDNmJnN1VTY2htLzFzOElNVk56M3VPdEJoeVJ0VTFGVTQrMjQ2dThpMnY4?=
 =?utf-8?B?TlRqcWNKdXpiRXZiWlZmMjRybzRtdDdoZTVSU0w0blNhUjN6dkcvdEpVYlBV?=
 =?utf-8?B?OXlWOTJJQmVtRHhVeURoemsrUmZnSXVwYUVISENsTzdZNDM4T1hwQ0RCemJw?=
 =?utf-8?B?clE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9F98364CCB3F7B4CAA6F63F8E05C427C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45eed7c7-09c6-44e4-a8f2-08dbe5c2c143
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2023 10:08:03.1721
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zVacF+yTjLh5i1qrW68xG4DSKSoEScaBgko2DNyzW0g7rvAybdTA8GGwNAJKI+bS9uQUVfGt5F1uuEBVXBtx5F+ZYLADz00PZJM4zUmxHlg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7900
X-OriginatorOrg: intel.com

T24gU3VuLCAyMDIzLTEwLTAxIGF0IDE1OjMxIC0wNzAwLCBhbGlzb24uc2Nob2ZpZWxkQGludGVs
LmNvbSB3cm90ZToNCj4gRnJvbTogQWxpc29uIFNjaG9maWVsZCA8YWxpc29uLnNjaG9maWVsZEBp
bnRlbC5jb20+DQo+IA0KPiBDWEwgZGV2aWNlcyBtYWludGFpbiBhIGxpc3Qgb2YgbG9jYXRpb25z
IHRoYXQgYXJlIHBvaXNvbmVkIG9yIHJlc3VsdA0KPiBpbiBwb2lzb24gaWYgdGhlIGFkZHJlc3Nl
cyBhcmUgYWNjZXNzZWQgYnkgdGhlIGhvc3QuDQo+IA0KPiBQZXIgdGhlIHNwZWMgKENYTCAzLjAg
OC4yLjkuOC40LjEpLCB0aGUgZGV2aWNlIHJldHVybnMgdGhlIFBvaXNvbg0KPiBMaXN0IGFzIGEg
c2V0IG9mwqAgTWVkaWEgRXJyb3IgUmVjb3JkcyB0aGF0IGluY2x1ZGUgdGhlIHNvdXJjZSBvZiB0
aGUNCj4gZXJyb3IsIHRoZSBzdGFydGluZyBkZXZpY2UgcGh5c2ljYWwgYWRkcmVzcyBhbmQgbGVu
Z3RoLg0KPiANCj4gVHJpZ2dlciB0aGUgcmV0cmlldmFsIG9mIHRoZSBwb2lzb24gbGlzdCBieSB3
cml0aW5nIHRvIHRoZSBtZW1vcnkNCj4gZGV2aWNlIHN5c2ZzIGF0dHJpYnV0ZTogdHJpZ2dlcl9w
b2lzb25fbGlzdC4gVGhlIENYTCBkcml2ZXIgb25seQ0KPiBvZmZlcnMgdHJpZ2dlcmluZyBwZXIg
bWVtZGV2LCBzbyB0aGUgdHJpZ2dlciBieSByZWdpb24gaW50ZXJmYWNlDQo+IG9mZmVyZWQgaGVy
ZSBpcyBhIGNvbnZlbmllbmNlIEFQSSB0aGF0IHRyaWdnZXJzIGEgcG9pc29uIGxpc3QNCj4gcmV0
cmlldmFsIGZvciBlYWNoIG1lbWRldiBjb250cmlidXRpbmcgdG8gYSByZWdpb24uDQo+IA0KPiBp
bnQgY3hsX21lbWRldl90cmlnZ2VyX3BvaXNvbl9saXN0KHN0cnVjdCBjeGxfbWVtZGV2ICptZW1k
ZXYpOw0KPiBpbnQgY3hsX3JlZ2lvbl90cmlnZ2VyX3BvaXNvbl9saXN0KHN0cnVjdCBjeGxfcmVn
aW9uICpyZWdpb24pOw0KPiANCj4gVGhlIHJlc3VsdGluZyBwb2lzb24gcmVjb3JkcyBhcmUgbG9n
Z2VkIGFzIGtlcm5lbCB0cmFjZSBldmVudHMNCj4gbmFtZWQgJ2N4bF9wb2lzb24nLg0KPiANCj4g
U2lnbmVkLW9mZi1ieTogQWxpc29uIFNjaG9maWVsZCA8YWxpc29uLnNjaG9maWVsZEBpbnRlbC5j
b20+DQo+IC0tLQ0KPiDCoGN4bC9saWIvbGliY3hsLmPCoMKgIHwgNDcgKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiDCoGN4bC9saWIvbGliY3hsLnN5bSB8
wqAgNiArKysrKysNCj4gwqBjeGwvbGliY3hsLmjCoMKgwqDCoMKgwqAgfMKgIDIgKysNCj4gwqAz
IGZpbGVzIGNoYW5nZWQsIDU1IGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS9jeGwv
bGliL2xpYmN4bC5jIGIvY3hsL2xpYi9saWJjeGwuYw0KPiBpbmRleCBhZjRjYTQ0ZWFlMTkuLjJm
NmU2NGVhMmFlNyAxMDA2NDQNCj4gLS0tIGEvY3hsL2xpYi9saWJjeGwuYw0KPiArKysgYi9jeGwv
bGliL2xpYmN4bC5jDQo+IEBAIC0xNjQ3LDYgKzE2NDcsNTMgQEAgQ1hMX0VYUE9SVCBpbnQgY3hs
X21lbWRldl9kaXNhYmxlX2ludmFsaWRhdGUoc3RydWN0IGN4bF9tZW1kZXYgKm1lbWRldikNCj4g
wqDCoMKgwqDCoMKgwqDCoHJldHVybiAwOw0KPiDCoH0NCj4gwqANCj4gK0NYTF9FWFBPUlQgaW50
IGN4bF9tZW1kZXZfdHJpZ2dlcl9wb2lzb25fbGlzdChzdHJ1Y3QgY3hsX21lbWRldiAqbWVtZGV2
KQ0KPiArew0KPiArwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgY3hsX2N0eCAqY3R4ID0gY3hsX21lbWRl
dl9nZXRfY3R4KG1lbWRldik7DQo+ICvCoMKgwqDCoMKgwqDCoGNoYXIgKnBhdGggPSBtZW1kZXYt
PmRldl9idWY7DQo+ICvCoMKgwqDCoMKgwqDCoGludCBsZW4gPSBtZW1kZXYtPmJ1Zl9sZW4sIHJj
Ow0KPiArDQo+ICvCoMKgwqDCoMKgwqDCoGlmIChzbnByaW50ZihwYXRoLCBsZW4sICIlcy90cmln
Z2VyX3BvaXNvbl9saXN0IiwgbWVtZGV2LT5kZXZfcGF0aCkgPj0NCj4gK8KgwqDCoMKgwqDCoMKg
wqDCoMKgIGxlbikgew0KDQpJIHNlZSB0aGlzIHVuZm9ydHVuYXRlIGxpbmUgYnJlYWsgSm9uYXRo
YW4gY29tbWVudGVkIG9uIHN0aWxsIGNyZXB0IGluLA0KYWdyZWVkIHRoYXQgYnJlYWtpbmcgdXAg
c25wcmludGYncyBhcmdzIHdvdWxkIGxvb2sgYmV0dGVyLg0KDQoNCg==
