Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB79134DD
	for <nvdimm@lists.linux.dev>; Mon, 10 Jul 2023 16:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689008364; x=1720544364;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=7F/SKytEXMP9gRPtKaTz8fZD4JEs1fRV/S06NP3T6Kk=;
  b=T88yHI5jWBaYrg0y2BNam0Igqf9f+pbQKJbS6DjryUAut4YoGLoLmPSJ
   gn3KxmukMDM3Tn2S+a1+FjbOQtCSqA05pP4LtusS2Tgm1ldgCA77Opafa
   EgeKKixq/H5gd8DKXF2S+rNbZ2j2Ec+tVD+kcL3jWaf8/a+B/VsveadJj
   Z1rTiaOJKTiojGHhsNKCp7i+te9eDnGytqrvHTBupvROFmGsbzc41mWCE
   ZDahNEaAa5Bb8PERxc+sFTAfsexOyCbhK0wkh4YfCqkwfVfcWQeMULAWE
   uYLhG3cxTuyIZfNdCm2GdVspSDo7XeqZiLvLEuLdbnOhpdfdN/8RP4KZF
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10767"; a="430477839"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="430477839"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2023 09:59:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10767"; a="894858791"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="894858791"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 10 Jul 2023 09:59:21 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 10 Jul 2023 09:59:19 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 10 Jul 2023 09:59:18 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 10 Jul 2023 09:59:18 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 10 Jul 2023 09:59:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P2ihkXWRqU8dvPhPBHRmuiFMRPQ64k77CnDiWjaPuNolgiayIZYdTZbhDn/c+cj2UPnYAH2Kyxah9a3yUBjiulj/JKgfzfDs41kZsabrr4xyNZsrru/zgdtCwcOQ59qWLcS3yEOvddy/yR9JbpoM2pCB4ZLjVo+lhiAjwfyHhNnX+4lIJagWTv2NkblNTHKb3nNMs8yLmM6xj4X3NNERzhDkL2GWSfkKePE/Q6fiKQmLBSorJf5z4qBCUHOgN4pFyrmtImybc/R6zvfMBoO8lKrkucC6FumICjG+uK+brYIFtF42O+uk2/AhusLFI+CxsQZoj4ZdoQ/X2Rcpsao7Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7F/SKytEXMP9gRPtKaTz8fZD4JEs1fRV/S06NP3T6Kk=;
 b=UXnxcCsIZNrkMC07PBbLRA249RIMZPy3dBIePhTf0TSvIkjVMGTlTw1fKIJ2BNkCfTXtQjjzs4MSbZSYguVecuDsW8w+flq4NmwWe5WiMG5NxmNLEoNsZY2+HtSHUdDDaQ88nLHyJp0qT/B650f7koh5dOBRo2X9le17C87G6WsFx/IpHkTPZroM+uax1McROx+goIrYfwYKjbQOAfyjzPKhUlia7MZy3tY4Gl9FSg+2zcJGmG7jRPJPpXWZ8awtMNyMV/XLtu+g4Mf0o78XE4d8v2O8HRQgoAKqGRmzAhZEE0tFtaf6+jkK47yyKqkrXas7Pk6PaApC7pPW8ZFVKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by MW4PR11MB6809.namprd11.prod.outlook.com (2603:10b6:303:1e9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.29; Mon, 10 Jul
 2023 16:59:17 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::8e37:caf2:1d81:631d]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::8e37:caf2:1d81:631d%3]) with mapi id 15.20.6565.026; Mon, 10 Jul 2023
 16:59:17 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "lizhijian@fujitsu.com" <lizhijian@fujitsu.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
CC: "Jiang, Dave" <dave.jiang@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "Schofield, Alison" <alison.schofield@intel.com>
Subject: Re: [ndctl PATCH v3 1/6] cxl/monitor: Enable default_log and refactor
 sanity check
Thread-Topic: [ndctl PATCH v3 1/6] cxl/monitor: Enable default_log and
 refactor sanity check
Thread-Index: AQHZk2ZoIreSFbNtSUiNvW6bENx3vK+r3qEAgAcz9wCAAGZTAA==
Date: Mon, 10 Jul 2023 16:59:17 +0000
Message-ID: <49b68658b6abb3f36823507a18692ea3af1afb02.camel@intel.com>
References: <20230531021936.7366-1-lizhijian@fujitsu.com>
	 <20230531021936.7366-2-lizhijian@fujitsu.com>
	 <3aed308abaa24becebacb559501c9b1ade9c0597.camel@intel.com>
	 <895193f2-6d4e-e481-69ca-74ac2c0fee5f@fujitsu.com>
In-Reply-To: <895193f2-6d4e-e481-69ca-74ac2c0fee5f@fujitsu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|MW4PR11MB6809:EE_
x-ms-office365-filtering-correlation-id: 98a7f108-e395-4a69-16ea-08db8166ff51
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rkN8dRIB6U/7qaqoOoMIgXl2wfsDn5/OUJX6v2bTi+iBtpTz8/deaT7Jgqyn+VarXHf/4SZeueTQNLcJT442f2c5bhvEkun7z7ZcNP8mLIa7VU35ja7xjjVIN16wIilzyvUq1BpnORJRI4F0dqxdlhDL2weMpgjfm3BUCJit9586T8sOELpICSW4j/k0+vrYLbmNNIK5ZpiYB6QHB244i/QgSDfPEBUIhfgfzKyPeBq/VR4G3H4efMLT5XLBESuBrpdU+LQEOfoBLGWvrPPiHJXCQQHRz2j1nUk8YYFjJKR9bQKLOYkvlLM003Upj9Q1wzFrAcOnkZZM3BOeVYX7WH5oerKA+aIsFrFcObL4BbUhzi4LcdAfsu4DaLHT0I6PWVAxYXimIWdv60DhvGTyhZMdoaAKMfnSQXMe66X8Ors6o+RLiDsW/XEiWMDP6sFpMxUxTiuDHNiSLeKbS+7IL75SF9NqU/aVw9PHLE4wRk5G06iylxM3CwrtMNJyCORqBcT3RfcU+JUUok/YXY9YVDxMki3JpAeRdWKdAx8xu5ysTk7oQdRUhrAcnwPdK/guxqxPZd7BuVpUnSbt33dzMtJGdxeAlzbIFugddm2IjSDeEcw9nuEH3CGnPj+grDel
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(136003)(366004)(39860400002)(346002)(451199021)(71200400001)(478600001)(4326008)(76116006)(54906003)(110136005)(6506007)(26005)(6512007)(107886003)(6486002)(2906002)(186003)(41300700001)(8936002)(66476007)(66946007)(8676002)(66556008)(5660300002)(66446008)(316002)(64756008)(122000001)(38100700002)(82960400001)(4744005)(38070700005)(86362001)(2616005)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?blUwT3ZYS0EvekNSWVdQdmo1eURYMTlnWHhMZG12OHFzMXhzVHFOVzlLL1BO?=
 =?utf-8?B?RjQzRmhINS8vYUkva2tML3hMMVl2L2ZYa29YQXVLb0FzS0VNb3R5emlzM0g4?=
 =?utf-8?B?dVpZVWJYNVgzd1NoTnloT3FzL2ZWQXhCNTk0N0k2U3JnTlRkZmxzbkVFMmdM?=
 =?utf-8?B?M3lNSjNFMDUvZk9uekdUazExM0RpVHpCTjl3bWRwR3pPTFJ0SkZRQ2R1VG4z?=
 =?utf-8?B?UkRQTnlYNnU4MW4vMGRoMDk3THJkNEx6UEowbmhwK24wRnd2cDdWejV6WXRE?=
 =?utf-8?B?bGlQVWdkNTQ0cC8zQlRXdTdFcmFqdTdZNzl2ZndMUDhVY0NlSHo4b2NlRER4?=
 =?utf-8?B?Ynp0OXZHOFpXV216OExWTi9FcnJMeGNodUNNdm1UQjZoNW1FdC9NUWtIL3ht?=
 =?utf-8?B?dmdFVXBIVWhVWjZuRHlTZVZFbHYzN09lVVY5NU84VUtiNU1kbVh1dlcxUElT?=
 =?utf-8?B?RktkajNQWXNxejF1eUREbTZaY1FncGxENWwzNzFTMkFNUjN3ZTVZUndNYnky?=
 =?utf-8?B?VElENi9KZlhGNXhCVnJraUJ6eS9ob2tuWERRV1pmWDJJV2l1c213dXFjaHhT?=
 =?utf-8?B?c01kM0hGYWxPelRNcE14VXR5eWpKeG83RlU0ZkR4cmJhenFpZWg4ZHIyMExU?=
 =?utf-8?B?cGdPK1BQTzdUblZnZ2Nhdm5nQVhoZmdNTG00L01FZFNtR2RPeGhXRUV2Q000?=
 =?utf-8?B?MUdvTUlqYXZoOUlSL1lUS09jTGk2Q0ZLK3BUc0kxdWVkZ3Y0cnBJSnVPN3k4?=
 =?utf-8?B?c3E2eXVIaGFKYnQ0azJlTjBsYnZ6d0tMZWI2SHhtUERKRE90dzY4RUQ1ZjMz?=
 =?utf-8?B?aDN3Ylg3SnJ3dlNmNlFyelNLeG1SOW1ya1lVdkVVNXZvTDRFMkNLQWZ4WVRa?=
 =?utf-8?B?QTdLclJQNTh2MUVsNDk1dnpUeUFoVkd1YW5wQ1pQNE9jcFhxaEtqVERnUTFj?=
 =?utf-8?B?dGNPZGV0NXdrZXBxelJIMlBvOGkvZ0Rhd3FrRjJ6SHA2T29YU3JXSkIrVmlh?=
 =?utf-8?B?T0t6SzJQbVo5bWhud0hvdU1Yb2hWNldoay9HYjZYRExxZktFUTlWdVhmWC9M?=
 =?utf-8?B?VjBuS0Uvd3gxM3E1bzJvSWpmTG9GR1V1eUdYOFRCcUxBOTlObGZUZi96aER4?=
 =?utf-8?B?SFlsQWVzZDcvRG9TRmxLTDhsZlZEZzhZYVBJZkRVU2kyR3d6amFoYyswUUl2?=
 =?utf-8?B?N29vNTd6Umw0SFhMalRQMk5CTDNiWHNudzdHOWsxZmtJLzR6R0hKN2VYckdk?=
 =?utf-8?B?QllWNEF1ekd5bUE4bUkwNzF6OHNvd3djeDJ1dTJSNVE1TGUzMkN5Y0NJN3F5?=
 =?utf-8?B?UDg0bWNTK3p5STR0VTNYQWhQRHVoREk2OTFrdjJsOUpNSC9DZXZZRUYyWmll?=
 =?utf-8?B?c0ZER1RXV080bmUxQTV5Mk50Ty9ZVU9FOEgvejNkM3hxRDlwcjltU2dRUmUx?=
 =?utf-8?B?NjgvcHN0eWswRUhoL3M5VUloRnJrUHQ5ek4vVUEwaDFCS1lGQkNCcmJPSkx1?=
 =?utf-8?B?MDBkcDlCaG5WQjBtajV3b21WT2xFVU5aQ2xTSnRMVGZBNVpWbS96MURDRVgr?=
 =?utf-8?B?Q1JkM29TMk80L1hTYThoSGFXeXZsMWxqaVdBT0ZuWFRFT3VsWW0vL3F1ZkI0?=
 =?utf-8?B?UnQ0di9oQ3crSGRtUkUxeGNkMEt0QXphUG56UHVtbVZzbzdxTVNGV1BzRjRS?=
 =?utf-8?B?SEhBT1FzZ0JXT3hBdkhUWngvbi95TU5hc1VBOTZROXYvMmsxeTdRWFQyTTdx?=
 =?utf-8?B?amkrdHJEMFVsQnFtNEtVRzJIbGE3aE1jVTNYYTRnSE5ac3U3OTJZYkJLZVdm?=
 =?utf-8?B?eXc2Q3FRR1BGN3lLTFFlUGhHYWliMHFySUQ0QUZzL0FWZisrQmxPcVNxRndT?=
 =?utf-8?B?NlRNNEw2Rk1sYnVHTFNQQ2MxeTZJNEdjSHo2V21DZy9mdmh5TS85cUZVL09z?=
 =?utf-8?B?dVRORlZBekFZS1JRYVhzZCtVd0JNS3M1cjlqTjY2RFRncHhaRGFkcWtlaVFv?=
 =?utf-8?B?QmtudXdjbklsc1lqQ0Z2TElyK2w0eit3dzBzK241Y3UrVHZOdUg4TnlWKzRG?=
 =?utf-8?B?bktWdXNmSVlNNHE1UmpUVzI4WE1QTmY5WmtqVFBXY1NiaVphTEM5Z0R3MitC?=
 =?utf-8?B?UXJHcVJET21uWlNNckxEOVU5UVQ5dWE2d3NSVnR3NWdMVlU5bnFGZEZ3elIv?=
 =?utf-8?B?T3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8D8C089584849840A497E65F38EC9847@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98a7f108-e395-4a69-16ea-08db8166ff51
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2023 16:59:17.3165
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EV4VPwJXXKlTQMaMpD7OrjSnLhmUrUKD0umxaqgZZCsJLL+LrQrStGxLs4U4TwY3apv3Fzix0UuGuuiuu7WlM37/i/gKMvKxtouHXEn9xk8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6809
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDIzLTA3LTEwIGF0IDEwOjUzICswMDAwLCBaaGlqaWFuIExpIChGdWppdHN1KSB3
cm90ZToNCj4gPiA+IA0KPiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgbG9nX2luaXQoJm1vbml0b3Iu
Y3R4LCAiY3hsL21vbml0b3IiLA0KPiA+ID4gIkNYTF9NT05JVE9SX0xPRyIpOw0KPiA+ID4gLcKg
wqDCoMKgwqDCoMKgbW9uaXRvci5jdHgubG9nX2ZuID0gbG9nX3N0YW5kYXJkOw0KPiA+ID4gK8Kg
wqDCoMKgwqDCoMKgaWYgKG1vbml0b3IubG9nKQ0KPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoGxvZyA9IG1vbml0b3IubG9nOw0KPiA+ID4gK8KgwqDCoMKgwqDCoMKgZWxzZQ0K
PiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGxvZyA9IG1vbml0b3IuZGFlbW9u
ID8gZGVmYXVsdF9sb2cgOg0KPiA+ID4gIi4vc3RhbmRhcmQiOw0KPiA+IA0KPiA+IEkgdGhpbmsg
dGhlIG9yaWdpbmFsICcuL3N0YW5kYXJkJyB3YXMgdXNlZCB0aGF0IHdheSBiZWNhdXNlDQo+ID4g
Zml4X2ZpbGVuYW1lKCkgYWRkZWQgdGhlICcuLycgcHJlZml4LiANCj4gDQo+IEF0IHByZXNlbnQs
ICcuLycgd2lsbCBzdGlsbCBiZSBhZGRlZCBieSBwYXJzZV9vcHRpb25zX3ByZWZpeCgpIGF0IHRo
ZQ0KPiBiZWdpbm5pbmcuDQo+IA0KQWggeWVzIEkgbWlzc2VkIHRoaXMgLSBJIG11c3QndmUgY29u
ZnVzZWQgbXkgdGVzdCBhdHRlbXB0cyAtIHlvdSdyZQ0KcmlnaHQsICdzdGFuZGFyZCcgYmVoYXZl
cyBhcyBleHBlY3RlZCAoc3Rkb3V0KSBhbmQgJy4vc3RhbmRhcmQgYWxzbw0Kd29ya3MgYXMgZXhw
ZWN0ZWQgKGNyZWF0ZXMgYSBmaWxlIGNhbGxlZCBzdGFuZGFyZCBpbiB0aGUgY3dkKS4NCg0K
