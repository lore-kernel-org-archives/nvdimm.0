Received: from mgamail.intel.com (unknown [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAA5418B01
	for <nvdimm@lists.linux.dev>; Mon, 31 Jul 2023 18:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690829141; x=1722365141;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=9REiVCn5JApfuIAJvrMZ6xvip6TfO5j9pf0F+JBmO8M=;
  b=m3xu06IDCK/d6uvr7GUZP+ZbWv72IvJu6ILHyfrYA7fE48ZxXVlL2xmQ
   Sd2rgPM8pcXM8BvwI5AbQQJYAWs7mGya2L6QDiZS5Rq1mEjKaFojincFr
   SGVYsELppoB7rq2q9qef55l4VogcmU4x8s4ZZOqBcTFVehoifpXLsuSGP
   YXI96P2hnvrAI4ZTyd7ZJ5O81BofBPYl0o6owPQFB7n78Rt7wEUVJUsvn
   TudBH70eyV0SNo+gytH0LCpkbGmYZjtJAqdMQmqNAy9O+d9VTPOzoC1yR
   wf/tUyedatAFs6hCbUgSsKWZf4TEHGbUY4FG7nYtXeOQf13zF+BHlqPbH
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="349397446"
X-IronPort-AV: E=Sophos;i="6.01,245,1684825200"; 
   d="scan'208";a="349397446"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2023 11:45:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="705529568"
X-IronPort-AV: E=Sophos;i="6.01,245,1684825200"; 
   d="scan'208";a="705529568"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 31 Jul 2023 11:45:37 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 31 Jul 2023 11:45:37 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 31 Jul 2023 11:45:37 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 31 Jul 2023 11:45:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KY6JI0VLo2WcJG7yzY6/DowuZjFdU1lgf3ORVHRwxapfwQTDlafe2gZ5R+Ri0dX5hdBWeEf90bZy7QFd29aA10NkCuLIRow8DU/V8QWoWr8GDupV56uvW7b0nSUy62wRw5Z0enuReuki13SNYo4PMYQdJOeAIURbLmkiwkJIT5ThNU5s5Yehye0/EFTdUfm1/Dl53PFmgWYAavdvRgyJOB33heOHXOEFAQkv9PMi3cxHwVy1WFLviFQaDIvsfTkyJMslbVGpXHIOz7pcklPfhwxZ3QWzWzmtYJjFjQRSVQwUCxi0rCXQmYBlcU5Bt9FDueTjU3swGy0PSBtWmtJmhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9REiVCn5JApfuIAJvrMZ6xvip6TfO5j9pf0F+JBmO8M=;
 b=C2UBJgBjGMkEpNvsJw/5KX2XhxsQshILN+VMvjsknyy3c7gb9OT1fe5YrNrhjeVOWmrt1h/JQQi+5fjQTWYZ9v2QKqS/AJQUAAH1p4zxtJctef5okWrk3ekEC4iNV5Okps6m2Fu5tSE/OOu5c19Y5hHM12z72S9s1+f1ubReQ2rfk4JHNL0YHpqK2AK4Eqcg91vsskmaq3fA8v44X4baCIzYS6OHQjgj1K55TbdpiYf4yqoKuisJXZXn5O/FsqVKujULMTIdwwKfYzsbQxXs/KmKGajQnUr18YT+KCpKTMdMEhYfB+/wIveYTl/mPgMlVd1MRtWLOFV1ZF8Ubp7AZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by CY8PR11MB6889.namprd11.prod.outlook.com (2603:10b6:930:5e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.39; Mon, 31 Jul
 2023 18:45:35 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::e527:d79c:2bb3:e370]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::e527:d79c:2bb3:e370%2]) with mapi id 15.20.6631.026; Mon, 31 Jul 2023
 18:45:34 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "jehoon.park@samsung.com" <jehoon.park@samsung.com>
CC: "Jiang, Dave" <dave.jiang@intel.com>, "Schofield, Alison"
	<alison.schofield@intel.com>, "jonathan.cameron@huawei.com"
	<jonathan.cameron@huawei.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "im, junhyeok" <junhyeok.im@samsung.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"dave@stgolabs.net" <dave@stgolabs.net>, "ks0204.kim@samsung.com"
	<ks0204.kim@samsung.com>
Subject: Re: [ndctl PATCH RESEND 2/2] libcxl: Fix accessors for temperature
 field to support negative value
Thread-Topic: [ndctl PATCH RESEND 2/2] libcxl: Fix accessors for temperature
 field to support negative value
Thread-Index: AQHZuHev1g7mtyUPG0mGyG87j5xBe6/JdQGAgAnVEACAAQNfgA==
Date: Mon, 31 Jul 2023 18:45:34 +0000
Message-ID: <f1a9710dec8697edb50f0ad9941edefa4e2a4498.camel@intel.com>
References: <20230717062908.8292-1-jehoon.park@samsung.com>
	 <CGME20230717062633epcas2p44517748291e35d023f19cf00b4f85788@epcas2p4.samsung.com>
	 <20230717062908.8292-3-jehoon.park@samsung.com>
	 <ad6439d56a07c6fac2dc58a4b37fd852f79cfec8.camel@intel.com>
	 <20230731031714.GA17128@jehoon-Precision-7920-Tower>
In-Reply-To: <20230731031714.GA17128@jehoon-Precision-7920-Tower>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|CY8PR11MB6889:EE_
x-ms-office365-filtering-correlation-id: 0f3180bd-2cbc-433c-db39-08db91f6530e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lsKZXrp0wXG9im21HsTlJFpr8p8hAi8fNFDEFxdwVOMJrUoT4oTQE1yVadIrxNXKPC2X59Sj+9vuxh+RbwgnmhleX5ZswvPG+XG+F9SCYILsG79VSz64072UsWEo2vrAFy7azELClwyvZrbdF7SsilurdcMItd1ii74gf4LdGgo1FpzaHz/FcBQnnyODjUAMBGo1XewRDhk+GtDmMxPL7MgL+7PnmoyzOO10BbeCWHKrCfNMgSDbputMUjGk0e7iXdqPVvt3dQ1SAIo4Jv/0yFzKEO3NNZUe2qNRGZhH+vGAGmjDccVgIIs3moySFNmbnPaSbxUEoUyE5dP+nfhtQZcBkjRvumxRScLoX66v9vIYU+70WI+g5ZX1M0aOCoq4mjkg5Af6ARywMuruPfkyKMCgXFMUVPbfrerBAiyjpOBOGcRrf8848+Ac1WfIQVGGdYeb/ntks3PLjZQIWMq/NGKTI72q4nIi6JbPe0Hvawl1QkX9ywsiEbTMtE+mO3KwvzlUEbLiVr1OZmDQHWsuIkpuz8DQKUha3WlXjVo2VpPQwt7jAfw4/UzWNg/hVdAQLrQQMJvqq3cacd1tzA7RbY0TT1JReeHh0+y6Vd6euwRLLax8j+5XF1MKNwxOBt8n
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(396003)(376002)(346002)(39860400002)(451199021)(5660300002)(66476007)(66556008)(2906002)(64756008)(66446008)(66946007)(76116006)(4326008)(6916009)(41300700001)(54906003)(316002)(2616005)(71200400001)(6486002)(6506007)(8936002)(26005)(8676002)(186003)(83380400001)(82960400001)(122000001)(38070700005)(478600001)(38100700002)(6512007)(36756003)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d2hBNDl0SHJYK1JJMWVYbmNTQXhhM2JicTRtenVZbCttSVlDemFKdGVrdEtm?=
 =?utf-8?B?T3VIVDNydEdXL01TUXIvZ1NYMnR6b3dJcnhwZ0lJOHlYNnRwaml0VzRDWTFq?=
 =?utf-8?B?ekJmYUsvcmtZVGdRNlkzWmM3QitNS084SXM3MkZ2aVA2NVBpbThHRk1YbFpV?=
 =?utf-8?B?VHNxYk9CcTMyanZTSWVBSHBZYWJXWU13WDhWN01OU0c2ZFNhSng5WHpUTGV2?=
 =?utf-8?B?bUVxcEpTcUxnR0U0OW9wek85cGVrU01Kd01XYU9uNHZFTHJXOExZZ1loRmZ1?=
 =?utf-8?B?UzFlTkl2azJaTjFLcVp5azNsczZtejdmVVlpWXJMdVNqUVZBVWpuZlUwV3Fv?=
 =?utf-8?B?ZlU1YkxUV1Z6U1pBa2tVUmRiS1krdDBCcEl0OG5wNXozYW5QTXRBRGplSWpJ?=
 =?utf-8?B?SlFwdkNTU0k2YUpldzEyMStBK0VRemxVb0ZrQ3JXUDJXSUJDeTgzclZYRWRZ?=
 =?utf-8?B?dW9RSmJyemt4OUtVTzRoMTZIY2EvT3RoK3dhNEFlQ3d1RXVraEcrUUVCTTMr?=
 =?utf-8?B?TFF2TVVmL2EzRXlBNFNLOVZFbmRzSmlnNi9ZU3FxakE5aWRIeTFENnFiKzli?=
 =?utf-8?B?ZUsyNERPRDl6ZTJVUXVSK3E4RWtnYVR2dCtkOGpqWVVxRXc1eGliWkVZYkov?=
 =?utf-8?B?NklWcVMzc1lvK1hiRVNtRW5CZVBGSlhEOEo3RXY4WFFNUW1KbzRRVk1XeUwx?=
 =?utf-8?B?MVM4Kzc4TmJLT1dGWnd5S2lQRm5aQ1Y0dEt0S1RxWExTcklFOStFN1lTWjBS?=
 =?utf-8?B?MUgvblRlaEdCRTQ4TkJqRktYUTlGTW1XaXZ4YWc2cldpTDdvT3JmOWhXbGN1?=
 =?utf-8?B?dDM3aWJDU0hSZmdrMS9qNmYrVk5Vd1lnVHhJV1pWdG1BT3hhRjU3UWFUY0pZ?=
 =?utf-8?B?SWtuRGtWNjRYT1dyRzU3dlJsME5SL1hkUXBkMU5DOWV6ZXNzd1lmY0llSE1B?=
 =?utf-8?B?eTgxTWhBVUxlb1d4d2doWHl5eVhHb2E4cUhEYThJcE4wbWxuL25CQWJGaEMx?=
 =?utf-8?B?dkQwRzdYVGlmaTEyeCtFRzNzcmpPNnlMbk0vSGhVNTNEaUo0RnRhMmZYR3Y1?=
 =?utf-8?B?Vm5oajJvU0xObittUnhEOE1acWpsYjZ6M3R3UksyZzlEcXJKcmI3ZnpIWnor?=
 =?utf-8?B?SnRRbWxJZjJWY3B6cEt3ODF0UVZtNElxelA1N2Y2b2swR3dZV2Jud05xT2VD?=
 =?utf-8?B?Z01udFN0Q3Q5cWVCYi9jL2F4MlE1WGx6RFJhQWRBQzRVdUkrMTlMWWxHQUN6?=
 =?utf-8?B?QVIwckxIOWpLSDVacHVLVVMzOFpBYUY3bkViVGVkdjFwSitWVGxkcWN5VWJW?=
 =?utf-8?B?RldEUEhNbytQMkJuc1ZMZ0pCWHlMdWJCdlZWdmZFTG16ZDkwUGZxNmpvRUlD?=
 =?utf-8?B?V3FNc2szemhTL0V4bllDSnhYYzNKV0w3anZTTDRjZHN1RWpOQnAwQmRyUngr?=
 =?utf-8?B?Q0JZWkdLWks1c0ZqcnVFUklhVWx5NmNuOTZuRldsYjBIZkJWMkNBUnUrOENX?=
 =?utf-8?B?VDVqQzlnT1dUUEg1NURhTVAzaTNGVDJDMFYycjN3akNGZzF2TXZVZnF3RklG?=
 =?utf-8?B?RWJJZ2QvOUZMTWJyTzJLQnJ6QjF3M3d5UmxuclZTZm8zckZZV0lqYm9pRTQ3?=
 =?utf-8?B?dXhrbzRnNENoOEtudkdiUTJDT1dlWGRGTHh5elBScTI2ZzVYTUt6OEZkWG11?=
 =?utf-8?B?UkJ1WU1MQzNzVThmaWVSbjZnQ2dqWnptQTBQMTJ3T0xtblNJa0l4dXlGcTBs?=
 =?utf-8?B?WVM1M1ZXb2wvakk4dTduNDVMWFl1YS9ONkt4OXV3VklLSnVXWm9vQXdiVVVY?=
 =?utf-8?B?VE9vVERxcDJVcUx1Y1BnSTB2aWY3bHVmSEl0MkRDbDVXZnk1RWdlTWRyeDdm?=
 =?utf-8?B?dExFVm9EVmZvbkhmeEYvdFFtaHQrN3hxZ0tjLzVKcXJIb0s0RW5SMkhwWEJE?=
 =?utf-8?B?OG8xeGdsZVAwUGRBZWVmTjBEQ3g4NDZ2OXhvb05FY2ZnSlpHRjN2YWVwcGox?=
 =?utf-8?B?MmE3RkpjeFZ6WXlSZS9kRzJXbVV2WjBVRXlTSGttNG5kdGszRU9LZm1jaEFM?=
 =?utf-8?B?TWlFVmUvbUtvVUhhMmRLdEJOeHg4QUJxSXBOVDZja3ZpajBvZVgyY2pxL1pi?=
 =?utf-8?B?SEdxZEFuWGxPRVUvaWFTemVGV1JPdlJhUFBqT2NaQlMycUM3bzc0OUdhTFBJ?=
 =?utf-8?B?OEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <771603BA21481F4E96856A964D0311EE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f3180bd-2cbc-433c-db39-08db91f6530e
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2023 18:45:34.3967
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H5m4fcY1rTtLrBCf3/JDfZVOtSqOZJ/c/VOp+EjU3/0985j9DngU81ZsEovwWY5pbs5aVy09I7HYyH+VZ3FS6KM8sqo55Az3t26C5as9w8Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6889
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDIzLTA3LTMxIGF0IDEyOjE3ICswOTAwLCBKZWhvb24gUGFyayB3cm90ZToNCj4g
T24gTW9uLCBKdWwgMjQsIDIwMjMgYXQgMDk6MDg6MjFQTSArMDAwMCwgVmVybWEsIFZpc2hhbCBM
IHdyb3RlOg0KPiA+IE9uIE1vbiwgMjAyMy0wNy0xNyBhdCAxNToyOSArMDkwMCwgSmVob29uIFBh
cmsgd3JvdGU6DQo+ID4gPiBBZGQgYSBuZXcgbWFjcm8gZnVuY3Rpb24gdG8gcmV0cmlldmUgYSBz
aWduZWQgdmFsdWUgc3VjaCBhcyBhIHRlbXBlcmF0dXJlLg0KPiA+ID4gUmVwbGFjZSBpbmRpc3Rp
bmd1aXNoYWJsZSBlcnJvciBudW1iZXJzIHdpdGggZGVidWcgbWVzc2FnZS4NCj4gPiA+IA0KPiA+
ID4gU2lnbmVkLW9mZi1ieTogSmVob29uIFBhcmsgPGplaG9vbi5wYXJrQHNhbXN1bmcuY29tPg0K
PiA+ID4gLS0tDQo+ID4gPiDCoGN4bC9saWIvbGliY3hsLmMgfCAzNiArKysrKysrKysrKysrKysr
KysrKysrKysrKy0tLS0tLS0tLS0NCj4gPiA+IMKgMSBmaWxlIGNoYW5nZWQsIDI2IGluc2VydGlv
bnMoKyksIDEwIGRlbGV0aW9ucygtKQ0KPiA+ID4gDQoNCjwuLj4NCg0KPiA+ID4gDQo+ID4gPiDC
oENYTF9FWFBPUlQgaW50IGN4bF9jbWRfaGVhbHRoX2luZm9fZ2V0X3RlbXBlcmF0dXJlKHN0cnVj
dCBjeGxfY21kICpjbWQpDQo+ID4gPiDCoHsNCj4gPiA+IMKgwqDCoMKgwqDCoMKgwqBpbnQgcmMg
PSBoZWFsdGhfaW5mb19nZXRfdGVtcGVyYXR1cmVfcmF3KGNtZCk7DQo+ID4gPiArwqDCoMKgwqDC
oMKgwqBzdHJ1Y3QgY3hsX2N0eCAqY3R4ID0gY3hsX21lbWRldl9nZXRfY3R4KGNtZC0+bWVtZGV2
KTsNCj4gPiA+IMKgDQo+ID4gPiAtwqDCoMKgwqDCoMKgwqBpZiAocmMgPCAwKQ0KPiA+ID4gLcKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiByYzsNCj4gPiA+ICvCoMKgwqDCoMKg
wqDCoGlmIChyYyA9PSAweGZmZmYpDQo+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgZGJnKGN0eCwgIiVzOiBJbnZhbGlkIGNvbW1hbmQgc3RhdHVzXG4iLA0KPiA+ID4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBjeGxfbWVtZGV2X2dldF9kZXZuYW1lKGNt
ZC0+bWVtZGV2KSk7DQo+ID4gPiDCoMKgwqDCoMKgwqDCoMKgaWYgKHJjID09IENYTF9DTURfSEVB
TFRIX0lORk9fVEVNUEVSQVRVUkVfTk9UX0lNUEwpDQo+ID4gPiAtwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgcmV0dXJuIC1FT1BOT1RTVVBQOw0KPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoGRiZyhjdHgsICIlczogRGV2aWNlIFRlbXBlcmF0dXJlIG5vdCBpbXBsZW1l
bnRlZFxuIiwNCj4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgY3hs
X21lbWRldl9nZXRfZGV2bmFtZShjbWQtPm1lbWRldikpOw0KPiA+IA0KPiA+IEhpIEplaG9vbiwN
Cj4gPiANCj4gPiBsaWJjeGwgdGVuZHMgdG8ganVzdCByZXR1cm4gZXJybm8gY29kZXMgZm9yIHNp
bXBsZSBhY2Nlc3NvcnMgbGllayB0aGlzLA0KPiA+IGFuZCBsZWF2ZSBpdCB1cCB0byB0aGUgY2Fs
bGVyIHRvIHByaW50IGFkZGl0aW9uYWwgaW5mb3JtYXRpb24gYWJvdXQgd2h5DQo+ID4gdGhlIGNh
bGwgbWlnaHQgaGF2ZSBmYWlsZWQuIEV2ZW4gdGhvdWdoIHRoZXNlIGFyZSBkYmcoKSBtZXNzYWdl
cywgSSdkDQo+ID4gcHJlZmVyIGxlYXZpbmcgdGhlbSBvdXQgb2YgdGhpcyBwYXRjaCwgYW5kIGlm
IHRoZXJlIGlzIGEgY2FsbCBzaXRlDQo+ID4gd2hlcmUgdGhpcyBmYWlscyBhbmQgdGhlcmUgaXNu
J3QgYW4gYWRlcXVhdGUgZXJyb3IgbWVzc2FnZSBwcmludGVkIGFzDQo+ID4gdG8gd2h5LCB0aGVu
IGFkZCB0aGVzZSBwcmludHMgdGhlcmUuDQo+ID4gDQo+ID4gUmVzdCBvZiB0aGUgY29udmVyc2lv
biB0byBzMTYgbG9va3MgZ29vZC4NCj4gPiANCj4gDQo+IEhpLCBWaXNoYWwuDQo+IA0KPiBUaGFu
ayB5b3UgZm9yIGNvbW1lbnQuIEkgYWdyZWUgd2l0aCB0aGUgYmVoYXZpb3Igb2YgbGliY3hsIGFj
Y2Vzc29ycyBhcyB5b3UNCj4gZXhwbGFpbmVkLiBGWUksIHRoZSByZWFzb24gSSByZXBsYWNlZCBl
cnJubyBjb2RlcyB3aXRoIGRiZyBtZXNzYWdlcyBpcyB0aGF0DQo+IHRob3NlIGFjY2Vzc29ycyBh
cmUgcmV0cmVpdmluZyBzaWduZWQgdmFsdWVzLiBJIHRob3VnaHQgcmV0dXJuaW5nIGVycm5vIGNv
ZGVzDQo+IGlzIG5vdCBkaXN0aW5ndWlzaGFibGUgZnJvbSByZXRyaWV2ZWQgdmFsdWVzIHdoZW4g
dGhleSBhcmUgbmVnYXRpdmUuDQo+IEhvd2V2ZXIsIGl0IGxvb2tzIGxpa2UgYW4gb3ZlcmtpbGwg
YmVjYXVzZSBhIG1lbW9yeSBkZXZpY2Ugd29ya3MgYmVsb3ctemVybw0KPiB0ZW1wZXJhdHVyZSB3
b3VsZCBub3QgbWFrZSBzZW5zZSBpbiByZWFsIHdvcmxkLg0KPiANCj4gSSdsbCBzZW5kIHJldmlz
ZWQgcGF0Y2ggc29vbiBhZnRlciByZXZlcnRpbmcgdG8gZXJybm8gY29kZXMgYW5kIGZpeGluZw0K
PiByZWxhdGVkIGNvZGVzIGluIGN4bC9qc29uLmMuDQo+IA0KR29vZCBwb2ludCBvbiB0aGUgbmVn
YXRpdmUgdGVtcGVyYXR1cmVzIC0gdGhpcyBtZWFucyB3ZSBjYW4ndCB1c2UgdGhlDQpuZWdhdGl2
ZSA9IGVycm9yIGNvbnZlbnRpb24sIGJ1dCBpbiB0aGlzIGNhc2Ugd2hhdCB5b3UgY2FuIGRvIGlz
IHJldHVybg0Kc29tZXRoaW5nIGxpa2UgSU5UX01BWCB0byBpbmRpY2F0ZSBhbiBlcnJvciwgYW5k
IHNldCBlcnJubyBpbiB0aGUNCmxpYnJhcnkgdG8gd2hhdGV2ZXIgZXJyb3Igd2Ugd2FudCB0byBp
bmRpY2F0ZS4gQW5kIGFkanVzdCBhbGwgdGhlDQpjYWxsZXJzIHRvIGNoZWNrIGZvciBlcnJvcnMg
aW4gdGhpcyB3YXkuDQo=
