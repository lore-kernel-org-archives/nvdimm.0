Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0065C5D8E8
	for <nvdimm@lists.linux.dev>; Wed, 22 Nov 2023 20:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XMEYCzYy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700683991; x=1732219991;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=f6NrMk8HFJKFVx71sDv7HqD3wpb/Ya+X3Od5Rb0Alr0=;
  b=XMEYCzYy1XtrW866T8hl7CGQT4eWuH0gsYheMyVpxZjRPck1um5Mq12v
   dIeRg8lx7RNze66tHrNCYpvxcSDVGon8GxJBE3IohenoIFiOS0XIeFQcM
   hcJokppEuPiT9Iy/JiuDMVVocPHi4Ac4Eqhr/sieZTnFx6XNpQ0gYL4Ig
   mgnvTDmD45GHp6VGnB8b8eKme4m8k3Tk8hRnQjXXuygM/SKE7nZb2iwXf
   J//1sEYOuETtnuxCT4WcSuAYQIOfp4GZmpRLpPYvCCuicssZZ8ff9c8wc
   IAMhasmCcrwqxRV2I8c+fPV+12Da0EOhBMRXonX9O62AFoV/AAh+vAIhj
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10902"; a="5332332"
X-IronPort-AV: E=Sophos;i="6.04,219,1695711600"; 
   d="scan'208";a="5332332"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2023 12:13:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10902"; a="890559007"
X-IronPort-AV: E=Sophos;i="6.04,219,1695711600"; 
   d="scan'208";a="890559007"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 Nov 2023 12:13:08 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Wed, 22 Nov 2023 12:13:08 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Wed, 22 Nov 2023 12:13:08 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Wed, 22 Nov 2023 12:13:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RqqnMqWPzH6fa8pHNmtk12kSH3E9L5x4O/UTZ3EMlIUvFO75MiiveKrLLGiEQs01YwIpLMCEU68JQQrJWYKdgHKz+YSDg9xqmI/GbFsHDyjuH9zz37Lzkx3DwP7WsJSqv4o4syqdJ6UDsIUCZNn6Ybeexv6LKdLKlTqYfM0Mn+57AqonhB0AOiXnLAOlO8AB/B7h8LSIG9woLttIsZv6ab7Bp8gWqiFxfu9m6O+nWORykS3k4Snc3/Xw5WfoBehB6AxvgCKYnxrDMfy849CPOEiOMXvgZJReSDwo1TgE+DIraNK35aA7R5rDKGVCKEWS+hgoRpnSTsNbDukZ4EB4Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f6NrMk8HFJKFVx71sDv7HqD3wpb/Ya+X3Od5Rb0Alr0=;
 b=GgpY4RqQ6Za2SirOkaBoOGaCo+CWo/7C3FdpqcPKKEul2s2/vvMCdfU+ye3vMyJlSQ8N2saQJzrqrAbVS1nvWDRKDzAiPVMeBiSW3ABU+0NiEdNjuT7RpvH2Q3S6c3Uax0Ai700pSW5WXNvm1HVLfcF5e7kONZ0xmTuC+ba7mFyeUO71GfFs9pSr+s/ZaGXjZP9TQh0h6IEuvZjWHm8XQqupEnNUHneC1ATeZaM8HICGOUeDloMTPvm78KoKN4co/F7aoseEO7kk4hoqqiR9mMXoZa9HDHEUmw4BsiphhzEc0g/otnUuEaNLiFkPmxTwnK4tsaZ83J72S4WxKinj0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by PH7PR11MB5943.namprd11.prod.outlook.com (2603:10b6:510:13f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.18; Wed, 22 Nov
 2023 20:13:04 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::703a:a01d:8718:5694]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::703a:a01d:8718:5694%7]) with mapi id 15.20.7025.019; Wed, 22 Nov 2023
 20:13:04 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Schofield, Alison" <alison.schofield@intel.com>
CC: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH] cxl/test: replace a bad root decoder usage in
 cxl-xor-region.sh
Thread-Topic: [ndctl PATCH] cxl/test: replace a bad root decoder usage in
 cxl-xor-region.sh
Thread-Index: AQHaHO+0CKpKWoM4p0mWKMmbMe+doLCGxrcA
Date: Wed, 22 Nov 2023 20:13:04 +0000
Message-ID: <b070946887be8a9abcd41235780abec69d8db39e.camel@intel.com>
References: <20231122025753.1209527-1-alison.schofield@intel.com>
In-Reply-To: <20231122025753.1209527-1-alison.schofield@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|PH7PR11MB5943:EE_
x-ms-office365-filtering-correlation-id: 2452fb72-4add-401c-9365-08dbeb976f31
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ficZ8+uPVWhG3XPmHTiWNd2iIOYKHajbLjmFysPyHKwH48ALXOxeVADYBHEulbHX6FQ4+LHEvv5IsX6m9C3HldjZQwpxNRfwgB96ILuQJIyy+R14ol+Q3xlySEnEhigQnEt44MIwgcU2Ey5agA4XE+IVlfOERPbIDzc32H+CCVHnzkD5OnWhNY7/qxlWWCYQiH1REtWCnXsYua0GHVg34JU6x+cDlhucChCwN4NyeoqNIBRlIinR8rplUWu0enkb7b3lZMeR9C0/DRoAAknuctL/OiB5+rg2d5rrV1WBfySOlyy9+LcbzFx9kCqIHH2OLxDFIexl1TZzPgGpP20/jQGWUOQ8ud6mM0ZqLrP+9jH3f3oA/dQja/RmJ3m/s6VZayWbD/M/LGfKhg1ttJDwOsjVixX7I4S6525GEu4NcpYyprwSCLPzFQ93RyetrRl/1wkOas9VhbYeskwJSG6FYvo4QOG4+/w7zACmeoFN/mfs7CF82MwfBMcUEgd+jBF8oS6+pZ9sHIir2cTyiWnHcyw7t23kFSBW50ybpICDy2kJE5c59fjzalRlclgXPqQEwnRqw0I8WQ95PrNM4VmzOFfODeKB1slQKm7mpAOlMd6vOQhj5rwZVwN6vMi1CS2KEEYsr9XyZNDh7buJrLrgPw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(39860400002)(376002)(136003)(366004)(230173577357003)(230273577357003)(230922051799003)(64100799003)(451199024)(1800799012)(186009)(5660300002)(86362001)(2906002)(66946007)(66556008)(66476007)(316002)(64756008)(54906003)(6636002)(66446008)(4001150100001)(37006003)(76116006)(6862004)(8676002)(4326008)(8936002)(36756003)(38070700009)(41300700001)(6512007)(83380400001)(6486002)(966005)(478600001)(122000001)(6506007)(71200400001)(26005)(2616005)(82960400001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OUdEV0Y1ZjlEbSt0ZHN1R0FIc0Rqc1Fld1Y0Yk9oeUt3NVBTQS9rVWFDaVVm?=
 =?utf-8?B?aHMvTWplU3VJdXRpYUFVWitpVHhSU2tDbzRxcWRVK3V4ME15ZTNSRlFnMWRp?=
 =?utf-8?B?Z3Eya3FWaUtEYnVyNWtNaHJtc0daUlhXdlhadnpySEN2U256bVU1VEpQMDN2?=
 =?utf-8?B?SUwyS0VReTE1L25vWFRGNnZVWTk4M3Faa0NGbU03Zm9ob3FEK1lBaDRRVkFh?=
 =?utf-8?B?Vlh4UzlUU2Z3RWtVZEVRb0UxTHNpczd4VzIxUFBDNHFnam4vUUtvallJM1Vw?=
 =?utf-8?B?bkFhQURsc09hdGozLzVCclJpZ3daZXE5MzBJMEppbTNUQ2o1bXVmSkFrMHNj?=
 =?utf-8?B?WFk4OXBuOHB2UmQ1azFTenlCZk5HcUhSTjIza3kxTDQrMXFwbjQxc3U2b2RU?=
 =?utf-8?B?R3Y1c1hvc1hrZzdRNFFrZUIza1FwbFl1WVFQOGkrSWU4eVBSZ0hMeVU5ajFp?=
 =?utf-8?B?dURyVlhYaUZ3V0paVGQ5MjdYUUVYS2JiaUREU0F4SVVRTXJ0RDFmeUJmK2Zm?=
 =?utf-8?B?QTNkWTBaSDAzbEZnMVZXeFNvbEdVb3VNRmkvZUMyMjg1TWd4dndUay9lTldx?=
 =?utf-8?B?Vk85N0p1M0xhTUVwNC95czlYbWIyY09lZkkzekRtempEUGpuWDlMWEgra3JZ?=
 =?utf-8?B?NEJ5dlBJY3NFb2RnVExkMjJMTi8yYkZPbXpTZnY5YmdGa3dpYnV3Z2NieEdh?=
 =?utf-8?B?TDU0Qlp3aG41VzRQc29NaHBsK2NIWFp6T2l6WTFmWGtMajVTcGlxQXltdHA2?=
 =?utf-8?B?bFVINHFCZk1zYXVIR3J3THhiU3hSdkdvM1N3TWhROCt4S1RtdDNmbjhXQmV3?=
 =?utf-8?B?cFUzS3VPWUtQTk5TdlBpSStoOFFhYkVpeWpYWXhGRXRpeDROYjRoSUFvYm4x?=
 =?utf-8?B?VkJCN05qNGxUTk5Lb2dmRWhtMWJiVXdSV3FKTnd3WWNnNEVuelFlYXIzNGxt?=
 =?utf-8?B?VnZva01RbGptUGE0TVRtZ05aZkRBZTB3NWlFZ2c3Y0Rkb2o3OWsvMENObnRU?=
 =?utf-8?B?N3MrNVlMV3VrMHJrQkVzbXc1MjhIc25WdW13NVJpa0FSbXhQb3hNcmljR1NP?=
 =?utf-8?B?bDl2Ris2UGx3UUpNMlZiTHZES0RCV295bFFObmZVNllKVWdXQ1FNYXpvZm1w?=
 =?utf-8?B?TVdNZ0F4NWk2b215SWhUUzkrQlBnUzB4NWltTERUSXBSQ2E0YjdkcERYR0R2?=
 =?utf-8?B?YnNqaFhCN2tONllqRC9yYU1WSXh5ZERTUjJHeU9lWS9EZEhZUFZ0TzJ4VTlk?=
 =?utf-8?B?REE3aThSUStBRmVONDd1VHowQ1k5cUM5eWY3YndmalhpTTB0emZFRWh6Q09r?=
 =?utf-8?B?UjlmRWpmbXBtSVoreWFGWmcxcTBYNVFuclJJdHB1UkprZkwvZGQwZ2ttZmgr?=
 =?utf-8?B?YnpUcVJpTkcwZHdaWkhuRjhNbmlzenNYL0xOajJhVkJiYjVWK3ZCc2RjejU1?=
 =?utf-8?B?OExDdVUreVVjaHpZSWN3ZStxcWVXNUlqV1ZzRjZWMVFKRkhGYTFjbElQYVlR?=
 =?utf-8?B?OUNSVGV2SldHb1d6QjBzVnJBZm9kbHFmMk9va05yellieGdwbktKVGZnNGxy?=
 =?utf-8?B?M1FOeENMbGN2THJxMEljZUNNaExOd25kU3g0MWFaZTJnY00xTjltTXNzNjFY?=
 =?utf-8?B?ZEsrcmYxMSt6OTIrM1RkUFlLSDNoR1RrWEo0ZVVCNmhqZDJNUGdCcU1HanBs?=
 =?utf-8?B?LzRmQTZHclk3ME11RTJIZmQ2QzJlR3dwLzRzKzdmcWtWbzdOVUdRSDlJV2V2?=
 =?utf-8?B?ZTc2RmtrWGlJNXd6am9YaGNHaCtoM2xEQW9HSEJRenFTQ244UlFyZ2xNY3A1?=
 =?utf-8?B?elkzVWt1RTZ1bmlnSkNmYStRcmJJWjllSU43SmN1RXpycVZUNjJ1dGFQYTBs?=
 =?utf-8?B?L3dIalkrZnMySkJrWExUelpiaFpoT3Axem1oR1ZYWm5GKzNUYTY5Rlp1Y1BP?=
 =?utf-8?B?STZhME83SVBJUTdUMExlb05PWk5tbGc2Ty9YcU9VS2JMQm80cnRSSkxQTEVT?=
 =?utf-8?B?Q2krM1JnSVdvWkNSbjFyc1hheG9GQUE2QVFnUDR0eHZUTVFmb0VWK2p5UUpu?=
 =?utf-8?B?Q3dEaldUcUVnOUZzbzFJajZ2dzlKTEk5VkU3c2YyZSs3NWJyc0ptYlNxUHVM?=
 =?utf-8?B?MU5naUY4L3p4ZUp4RDM0c1NlMklVeTRsYmFNZGJ1NlQ1MGVNZW5iQkNUM0hF?=
 =?utf-8?B?M3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F8391D09B362AE4E90AF62084BB34CFE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2452fb72-4add-401c-9365-08dbeb976f31
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2023 20:13:04.1087
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5kDQjGvv8Kgf8klGIkO67E8mZBfCAUfE6HiQ5CceBDN1TE8jXlCESjUIP2V8wyQ73zIyX7z0e60ahyB7RyGUIQJ37Q6q+6ooN5sVDefLwBA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5943
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDIzLTExLTIxIGF0IDE4OjU3IC0wODAwLCBhbGlzb24uc2Nob2ZpZWxkQGludGVs
LmNvbSB3cm90ZToNCj4gRnJvbTogQWxpc29uIFNjaG9maWVsZCA8YWxpc29uLnNjaG9maWVsZEBp
bnRlbC5jb20+DQo+IA0KPiBUaGUgNC13YXkgWE9SIHJlZ2lvbiBhcyBkZWZpbmVkIGluIHRoaXMg
dGVzdCB1c2VzIGEgcm9vdCBkZWNvZGVyIHRoYXQNCj4gaXMgY3JlYXRlZCB1c2luZyBhbiBpbXBy
b3Blcmx5IGRlZmluZWQgQ0ZNV1MuIFRoZSBwcm9ibGVtIHdpdGggdGhlDQo+IENGTVdTIGlzIHRo
YXQgSG9zdCBCcmlkZ2VzIHJlcGVhdCBpbiB0aGUgdGFyZ2V0IGxpc3QgbGlrZSB0aGlzOg0KPiB7
IDAsIDEsIDAsIDEgfS4NCj4gDQo+IFN0b3AgdXNpbmcgdGhhdCByb290IGRlY29kZXIgYW5kIGNy
ZWF0ZSBhIDQtd2F5IFhPUiByZWdpb24gdXNpbmcgYW4NCj4geDIgcm9vdCBkZWNvZGVyIHRoYXQg
c3VwcG9ydHMgWE9SIGFyaXRobWV0aWMuDQo+IA0KPiBUaGUgdGVzdCBwYXNzZXMgcHJpb3IgdG8g
dGhpcyBwYXRjaCBidXQgdGhlcmUgaXMgYW4gaW50ZXJsZWF2ZSBjaGVjayBbMV0NCj4gaW50cm9k
dWNlZCBpbiB0aGUgQ1hMIHJlZ2lvbiBkcml2ZXIgdGhhdCB3aWxsIGV4cG9zZSB0aGUgYmFkIGlu
dGVybGVhdmUNCj4gdGhpcyB0ZXN0IGNyZWF0ZXMgdmlhIGRldl9kYmcoKSBtZXNzYWdlcyBsaWtl
IHRoaXM6DQo+IA0KPiBbIF0gY3hsX2NvcmU6Y3hsX3JlZ2lvbl9hdHRhY2g6MTgwODogY3hsIGRl
Y29kZXIxNy4wOiBUZXN0IGN4bF9jYWxjX2ludGVybGVhdmVfcG9zKCk6IGZhaWwgdGVzdF9wb3M6
NCBjeGxlZC0+cG9zOjINCj4gWyBdIGN4bF9jb3JlOmN4bF9yZWdpb25fYXR0YWNoOjE4MDg6IGN4
bCBkZWNvZGVyMTguMDogVGVzdCBjeGxfY2FsY19pbnRlcmxlYXZlX3BvcygpOiBmYWlsIHRlc3Rf
cG9zOjUgY3hsZWQtPnBvczozDQo+IA0KPiBOb3RlIHRoYXQgdGhlIENGTVdTJ3MgYXJlIGRlZmlu
ZWQgaW4gdGhlIGtlcm5lbCBjeGwtdGVzdCBtb2R1bGUsIHNvIGENCj4ga2VybmVsIHBhdGNoIHJl
bW92aW5nIHRoZSBiYWQgQ0ZNV1Mgd2lsbCBhbHNvIG5lZWQgdG8gYmUgbWVyZ2VkLCBidXQNCj4g
dGhhdCBjbGVhbnVwIGNhbiBmb2xsb3cgdGhpcyBwYXRjaC4gQWxzbyBub3RlIHRoYXQgdGhlIGJh
ZCBDRk1XUyBpcyBub3QNCj4gdXNlZCBpbiB0aGUgZGVmYXVsdCBjeGwtdGVzdCBlbnZpcm9ubWVu
dC4gSXQgaXMgb25seSB2aXNpYmxlIHdoZW4gdGhlDQo+IGN4bC10ZXN0IG1vZHVsZSBpcyBsb2Fk
ZWQgdXNpbmcgdGhlIHBhcmFtIGludGVybGVhdmVfYXJpdGhtZXRpYz0xLiBJdCBpcw0KPiBhIHNw
ZWNpYWwgY29uZmlnIHRoYXQgcHJvdmlkZXMgdGhlIFhPUiBtYXRoIENGTVdTJ3MgZm9yIHRoaXMg
dGVzdC4NCj4gDQo+IFsxXSBodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2Vy
bmVsL2dpdC90b3J2YWxkcy9saW51eC5naXQvY29tbWl0Lz9pZD1hM2UwMGM5NjRmYjk0MzkzNGFm
OTE2ZjQ4ZjBkZDQzYjUxMTBjODY2DQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBBbGlzb24gU2Nob2Zp
ZWxkIDxhbGlzb24uc2Nob2ZpZWxkQGludGVsLmNvbT4NCj4gLS0tDQo+IA0KPiBWaXNoYWwgLSBJ
J20gaG9waW5nIHlvdSB3aWxsIG1lcmdlIHRoaXMgaW4gbmRjdGwgdjc5IGV2ZW4gdGhvdWdoIHRo
ZQ0KPiBleHBvc3VyZSB3aXRoIHRoZSBrZXJuZWwgZG9lc24ndCBoYXBwZW4gdW50aWwga2VybmVs
IDYuNy4gVGhpcyB3YXkNCj4gdXNlcnMgb2YgY3hsLXRlc3QgYXJlIG5vdCBsZWFybmluZyB0byBp
Z25vcmUgdGhlIGludGVybGVhdmUgY2FsYw0KPiB3YXJuaW5ncy4NCg0KWWVwIG1ha2VzIHNlbnNl
IC0gSSdtIGFsc28gdGhpbmtpbmcgdGhhdCBzaW5jZSB3ZSdyZSBhdCAtcmMyLCB2NzkgY2FuDQpq
dXN0IGJlIHRoZSB2Ni43IGVxdWl2YWxlbnQgcmVsZWFzZSAoYW5kIEknbGwgaW5jbHVkZSB0aGUg
c2FuaXRpemUNCnBhdGNoZXMgdG9vIHNpbmNlIHRoYXQncyB0aGUgb25seSBvdGhlciBwZW5kaW5n
IHY2Ljcgc3BlY2lmaWMgdGhpbmcuDQoNCj4gDQo+IEFsc28sIGhvcGVmdWxseSBJIGhhdmUgbm90
IGludHJvZHVjZWQgYW55IG5ldyBzaGVsbCBpc3N1ZXMsIGJ1dA0KPiBJIGtub3cgdGhpcyB1bml0
IHRlc3QgaGFzIGV4aXN0aW5nIHdhcm5pbmdzLiBDYW4gd2UgZG8gYSBzaGVsbA0KPiBjbGVhbnVw
IGluIGEgZm9sbG93LW9uIHBhdGNoc2V0IGFjcm9zcyB0aGUgQ1hMIHRlc3RzPw0KPiAoYW5kIG5v
dCBsYXN0IG1pbnV0ZSBmb3IgeW91ciBuZGN0bCByZWxlYXNlKQ0KDQpBZ3JlZWQsIHRoZXJlIGFy
ZSBhIGZldyBzaGVsbGNoZWNrIGNvbXBsYWludHMgdGhhdCBoYXZlIHNudWNrIGluIG92ZXINCnRp
bWUsIGZpeGluZyB0aGVzZSBhcyBhIHNlcGFyYXRlIGNsZWFudXAgaXMgZGVmaW5pdGVseSB0aGUg
d2F5IHRvIGdvLg0KDQo+IA0KPiDCoHRlc3QvY3hsLXhvci1yZWdpb24uc2ggfCAxNCArKysrKy0t
LS0tLS0tLQ0KPiDCoDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDkgZGVsZXRpb25z
KC0pDQo+IA0K
