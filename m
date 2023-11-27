Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB511341AD
	for <nvdimm@lists.linux.dev>; Mon, 27 Nov 2023 17:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XzQ3dsq6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701107891; x=1732643891;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=8eZ4MHOGhQlvddmjgVeuJRKeGIq7Y9zmH6m0+wIDkOI=;
  b=XzQ3dsq6qZ1xaF193YLJKyFxObiHE07IWu5XbwoC22UrqTjFTaj4/Dv3
   +Hv27cscXW44k9PC8BBXUT3pmU6bhw7KxnCp0w61ESbqu/6FY/GxEwrJv
   uypb+FrDxt6KgNuUlMKOdk+7KK/GiDRG8+FOb/qcq8GEt0D2MUb1pjiC2
   O25njwLoKntaynjh644hAmuO+jjoP2QhENmqdF+3iYmSuEhbA1ZovM8io
   aoRNocqwCn8fpyQtmypu4IwWLdcaDh0tS25+WEwDfUkiRAwLWzsOHSzMq
   q4H33YQwDoOB3qy/AVIDO7kQatlcOg5GuXlCd7kwhlH6s7Ay8PSeA3k0I
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10907"; a="383142600"
X-IronPort-AV: E=Sophos;i="6.04,231,1695711600"; 
   d="scan'208";a="383142600"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2023 09:58:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10907"; a="941658017"
X-IronPort-AV: E=Sophos;i="6.04,231,1695711600"; 
   d="scan'208";a="941658017"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Nov 2023 09:58:11 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 27 Nov 2023 09:58:10 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Mon, 27 Nov 2023 09:58:10 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 27 Nov 2023 09:58:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RhXfyzFyWlKavpdN0vMCYxWqV3Xjz6DWxaNUYTzEEET5UjD0B67UUNB5mM6tJ2E8UYKrQaWiP3IYkutOf8nOidRq+xpiaxz670sFJZp5FNXhbA+MjAnvzxPgfeMAgQJ80zAgowf3JZscnoidMKW6GThDlrF0F2VYOn7DMyjKcN+ddMypmA1yGeExPHPpcTgpn/3UH1dH03Arw0h8WDBgvNfnvc9FiG7h1oJ0b/8mnzCKrknv0ZPtqhDbQKcJF53FRRYsmyrs0/j6bfWg5lP++nkBn+iA8OnUv/+BpYa7LmLCniSxYHxlQrgh7gdLR9oLcUf9CL0O5KsNpNxgjd7kZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8eZ4MHOGhQlvddmjgVeuJRKeGIq7Y9zmH6m0+wIDkOI=;
 b=WDF/+SFrVPPSCTcX6T+lvFdX7nfthlrFik0MZHIf3BCVodh1vivqFIeR4Pep8k9mBv+UkntYTJxVBPlVkJ44NhxFsKsWtC+e+IBSgrV6HfLBbf1M+pz980VyPmFWfHMOFWGL6apoAioAOEEjolhWwym38pW1qGnj3H5Hfseh4KP5KMlk4k8rshCYiQUODKJ3QXtSMcOrX8u2CKeRGPc9zZoL0iCo+oTdzOqtUp05a5PYDOCvtaPWxMbzm10zrBzeM3I92/QxdsTxYYGW4QMwO+A/ccVdJou66VuSYepz6zVQX8EZVPf5nKnUcuQoaqpGeJvnJusLgerV9RsCIlpAjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by DS0PR11MB8666.namprd11.prod.outlook.com (2603:10b6:8:1bd::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.28; Mon, 27 Nov
 2023 17:58:08 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::703a:a01d:8718:5694]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::703a:a01d:8718:5694%7]) with mapi id 15.20.7025.022; Mon, 27 Nov 2023
 17:58:08 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Jiang, Dave" <dave.jiang@intel.com>, "caoqq@fujitsu.com"
	<caoqq@fujitsu.com>
CC: "Williams, Dan J" <dan.j.williams@intel.com>, "yangx.jy@fujitsu.com"
	<yangx.jy@fujitsu.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
Subject: Re: [NDCTL PATCH v3] cxl/region: Add -f option for disable-region
Thread-Topic: [NDCTL PATCH v3] cxl/region: Add -f option for disable-region
Thread-Index: AQHaDEAjWlmK5izRNkunNvygoxCZobCOEXKAgACANgCAAAxkgA==
Date: Mon, 27 Nov 2023 17:58:08 +0000
Message-ID: <47fede41b87c0686c3dfbc95bf7c2e21b84c5100.camel@intel.com>
References: <169878724592.82931.11180459815481606425.stgit@djiang5-mobl3>
	 <4910174f-4cda-a664-62ee-a6b37f96efac@fujitsu.com>
	 <1c5f9602-7226-42f9-937c-671947ccdb73@intel.com>
In-Reply-To: <1c5f9602-7226-42f9-937c-671947ccdb73@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|DS0PR11MB8666:EE_
x-ms-office365-filtering-correlation-id: 57f8de45-2d89-412f-7476-08dbef7269c7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YXt8QiuGGcMQTDu3mvVN0Ay4PDKRlCTSIy9IsMIvXCt+eXvQ/7ZZIhH/jxEl2vPm4BC/NHQ7zs6i1gcUKiCRf/1xkPWPLIRbtyo3L0tS7SPWu+HnnfukblLVw4rp3+RFhgjnhIIggBRAGe6Yk50KdoPpLhEOxRFg+IBdIHx2NGfApOeaLApNdBRed4Q2gSjecJGHNjfvLZVCvOV26sPiyAThrtmaYc9n+8Ks+HrU9y/MKHQhYu9gjTwyRaQ6jFLANGs6QxdKj0EcJspyO+awQ+6HkOSWllXdCirA8Klf5FJc8aID2OD2j3WdS6FyFHQl4YJOhU7jAA4WRsODghRYTTMSerQecCxks+OPlnpmSuuvkjbtRqIUmtR7dL5iCpTEI9RrFp3SQNPIyR5I2CULT79jUFRdkWEmpwu8k+6o53fV6Q+6vAJkrqan7M5kLCuukCTHzssZYXkUDjighamN0kPYn+4Pqwh4xfOlRsaAzSrDWWneQO/goMRo+vPij1nOjqsFfJJ31GrJxBwXoDSLa8G2akP07Y2AyRDyYBLfY1TtEpXfYw+TBjAGsMqpc9vp+kPtPYcfHIb1gnw6bKpvVVy7n/1qH6nC5N9KzY7JGLysrY0yL4n3oxi11rycfAl9
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(396003)(376002)(346002)(39860400002)(230922051799003)(451199024)(64100799003)(186009)(1800799012)(71200400001)(8936002)(8676002)(4326008)(6512007)(6506007)(53546011)(66446008)(66556008)(66476007)(66946007)(64756008)(110136005)(54906003)(76116006)(316002)(6486002)(478600001)(122000001)(36756003)(38100700002)(41300700001)(38070700009)(4001150100001)(86362001)(26005)(2906002)(2616005)(82960400001)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q3puNHNOb25XQXFRQ2JLU3FsYWFYbnlBbUpBTklQbHAvcG01dFVMWFRSNGVs?=
 =?utf-8?B?dGtjR0hHODBGamdZblBpYXpSbFc0TytSd0d0ZnZaY2NWcE1xV2hvUkJydnND?=
 =?utf-8?B?ZWxlOEFvbFNmMzRENnZBTmtBVjRFYmVVejg0ejJSQmlsdEYrQ2laUzNIRTRW?=
 =?utf-8?B?NnhxS01VMmJ6QmdkR05JN1V6cXJsb3I3TG84andNWHpzY0xsQm5ta2w3RWxp?=
 =?utf-8?B?ZkRvQ1lKYVNSbDJCUkZkemU3b3Vaa2U1M3BVU2lTY3dRRjdsYnpnbXRUWlhD?=
 =?utf-8?B?UU9VMVFwTmZYcW45SVYxRGZWbTdNVVA0UVdyajM5R1JaR1ZJV1JkQXBVKy9S?=
 =?utf-8?B?cE9LVk5taFY0VnNjcFcrM2pOU0JKNkY1b09IaldQM09LbzE1NTVwYy9XYk5G?=
 =?utf-8?B?VnNDcHlycGdDOXhubi94cENmbEJENjFyVFM5eXFWOG04SzM5T0ptM3BCaDJK?=
 =?utf-8?B?S096Y0h2eG83T24xbHByN2hydjhlS2dyYmtxbkVTeGk2bTBESUVxZEhCZXRa?=
 =?utf-8?B?V1JDLzE5RXF3SG9CWGNzWTRyMlZNcG5qbkhuMzJqSlFkeE5VVVkrZkNCcVM2?=
 =?utf-8?B?MzMzaVBaRWl0Zk9hYTF2SHZCbnFFSFArNDNLNDFjcW5DSS9jVHQyazZLYWtX?=
 =?utf-8?B?Y1ZmOHI3RE94NnQza0wwc3A1clp1Qm0wcVMzbzRlb1RSOVhoa3NpNlI2MlRQ?=
 =?utf-8?B?Um01WXE5SlpNbmNXYTByUGt5YlJFVytGQ1dyNUIveFNRbmFMZTI0QkN6T1Rn?=
 =?utf-8?B?OTltLzhHejBMRkQrT1BQQm5uY2o4Zy9JQitUa3pWZm96UjBuaTNiSFgxdFNZ?=
 =?utf-8?B?OGVxejlpTVo5bFY1WDRocTkybXZTS2tmMFlmYXNBZytwTXNtMW52cXFIbEda?=
 =?utf-8?B?bUpRQlpFVm9qNWtCWHFBNHBOSlZuRkhid2lheEFzQk0wZ3VucmRrb2FZVUh3?=
 =?utf-8?B?c1BpaWQ4eXl4YUhqTTBrUWNQa1luR3lMbXF5WnRtU0xqNVFPQXZNNVpUWHo2?=
 =?utf-8?B?cHRZZUtqSVcweW5PUWFJL05ydEJpRWh2VkN6QlFoY0k3b0Z5Zmhvbnpmcng5?=
 =?utf-8?B?QkFQMW5WYXp5Q1JSSmhYMlpVbVlrQVFMSlR6ZThIRHFNMnlsdEQySTJ3WXNF?=
 =?utf-8?B?dUFwU3FlVCt2ZnNVV29tcktVMW9XMjZRdHZNTVFwRFFMdEpjalZhNFNqa0ZN?=
 =?utf-8?B?YnlwV2xiRGVGaU5HT2dIdmdMWUZ3cktvZldKdm1CNnRQcmQ2Nitjd09YWHpT?=
 =?utf-8?B?cTc4M2hRT3hidHNJb1BuUVYybDlOTFdJcUZyRVAva1BTQVBrNmlDcStaSWZv?=
 =?utf-8?B?aVVLMnV5WGZkTEp3KzdKcmgvc2dGQXd0d1VDc1BpQk1NcHBIa1BWbXp0Qktq?=
 =?utf-8?B?ell3M2RrTFdxZUkwazBFRnR0TGlIbFNpQ28xTlBwaWRwa0FSSGRqRU9PWFpp?=
 =?utf-8?B?azFlQVJkektXcEZoVEliSXhkSVovaWlIQ3NHUWFqaTZXU3gxdVFkVnk1RUtV?=
 =?utf-8?B?SjVEZWQybXNjMGdzaStvMGY2OWZveXEvUllFNWhnbTZ3QkJsNmNrcERWeDZP?=
 =?utf-8?B?eXhyZ1RyQlQ0d1ZmeXJHTFloUnpwUkpFQjBrTmVWQk5LQU0ydGZONEFNQ2tm?=
 =?utf-8?B?bmJyRzVuWHdNaFZhYUdFVlhUekJ1aGMyZVpLdTA5bU5wVlhwQWFHSTZGZ05W?=
 =?utf-8?B?Vjh2QWdWanltWWJIRjAvVHpHVnF6aXpDdnRablh6SjkxQnBMT29ZL1pzZTI4?=
 =?utf-8?B?aS8rRUNZblhpWXYyWmZyWWMvS0ZmVnNaN0pUVVFTNDRiYnJCUEhEUXFuOVls?=
 =?utf-8?B?UVZpQzF1bGdOM2ZuZkJDR3NBMzVuNUkwTWQvaHlOMStWS2lFbktFN3VxWDYv?=
 =?utf-8?B?UE1aUU02eHlPRm9TWVVVYjRQSER6WjdabVpHRUZseWErcjJWbzFlSFRRTjVx?=
 =?utf-8?B?MDdLeVQ2b2JaaU51RU5GZEtmeGQydHYrSjNCWlJ5ajlMMXQwenZGYjU5ZWd6?=
 =?utf-8?B?UDhpbnVIcmwxMlVXWGZISHJvZUM3TENINjFFSk9xYmRJbk1JWS96WTVFMXBk?=
 =?utf-8?B?dzg5UHlhOURxclQ3VXlLeVN4a05NaThadUQ1M1lNVDg4SGFHN2VVNmhvRXVj?=
 =?utf-8?B?bGRzVVcvNDFhUmFPZG4wRjlWTWwxRW9JVkFiVE9odURhd2NORTNBeEE4TWc3?=
 =?utf-8?B?cGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2BF464DE2F35674299D381B9CBBEC147@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57f8de45-2d89-412f-7476-08dbef7269c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2023 17:58:08.2860
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YU5RIQSljdTrtGqlTdJpCCs12Gu1228iO0glSDNpvPaH+u4/AtLiyrKEIMC9ny9DYx324vjrGaZ/fp4Br2GgAAs8nYs0cx4szpLTFFmfjNY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8666
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDIzLTExLTI3IGF0IDEwOjEzIC0wNzAwLCBEYXZlIEppYW5nIHdyb3RlOg0KPiBP
biAxMS8yNy8yMyAwMjozNCwgQ2FvLCBRdWFucXVhbi/mm7kg5YWo5YWoIHdyb3RlOg0KPiA+IA0K
PiA+IA0KPiA+IDEuQXNzdW1pbmcgdGhlIHVzZXIgaGFzbid0IGV4ZWN1dGVkIHRoZSAnY3hsIGRp
c2FibGUtcmVnaW9uDQo+ID4gcmVnaW9uMCcgY29tbWFuZCBhbmQgZGlyZWN0bHkgcnVucyAnY3hs
IGRlc3Ryb3ktcmVnaW9uIHJlZ2lvbjAgLWYnLA0KPiA+IHVzaW5nIHRoZSAnZGlzYWJsZV9yZWdp
b24ocmVnaW9uKScgZnVuY3Rpb24gdG8gZmlyc3QgdGFrZSB0aGUNCj4gPiByZWdpb24gb2ZmbGlu
ZSBhbmQgdGhlbiBkaXNhYmxlIGl0IG1pZ2h0IGJlIG1vcmUgdXNlci1mcmllbmRseS4NCj4gPiAy
LklmIHRoZSB1c2VyIGV4ZWN1dGVzIHRoZSAnY3hsIGRpc2FibGUtcmVnaW9uIHJlZ2lvbjAnIGNv
bW1hbmQgYnV0DQo+ID4gZmFpbHMgdG8gdGFrZSBpdCBvZmZsaW5lIHN1Y2Nlc3NmdWxseSwgdGhl
biBydW5zICdjeGwgZGVzdHJveS0NCj4gPiByZWdpb24gcmVnaW9uMCAtZicsIHVzaW5nIHRoZSAn
Y3hsX3JlZ2lvbl9kaXNhYmxlKHJlZ2lvbiknIGZ1bmN0aW9uDQo+ID4gdG8gZGlyZWN0bHkgJ2Rp
c2FibGUgcmVnaW9uJyBhbmQgdGhlbiAnZGVzdHJveSByZWdpb24nIHdvdWxkIGFsc28NCj4gPiBi
ZSByZWFzb25hYmxlLg0KPiANCj4gVG8gbWFrZSB0aGUgYmVoYXZpb3IgY29uc2lzdGVudCwgSSB0
aGluayB3ZSBzaG91bGQgdXNlDQo+IGRpc2FibGVfcmVnaW9uKCkgd2l0aCB0aGUgY2hlY2sgZm9y
IHRoZSBkZXN0cm95X3JlZ2lvbigpIHBhdGguDQo+IA0KPiBXaGF0IGRvIHlvdSB0aGluayBWaXNo
YWw/DQo+ID4gDQpZZXAgYWdyZWVkLCB1c2luZyB0aGUgbmV3IGhlbHBlciBpbiBkZXN0cm95LXJl
Z2lvbiBhbHNvIG1ha2VzIHNlbnNlLiBEbw0KeW91IHdhbnQgdG8gc2VuZCBhIG5ldyBwYXRjaCBm
b3IgdGhpcyAtIEkndmUgYWxyZWFkeSBhcHBsaWVkIHRoaXMNCnNlcmllcyB0byB0aGUgcGVuZGlu
ZyBicmFuY2guDQo=
