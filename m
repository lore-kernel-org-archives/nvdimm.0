Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2BD643
	for <nvdimm@lists.linux.dev>; Wed,  8 Feb 2023 06:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675838184; x=1707374184;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=fxnqmWt/zKa1j9u4aFMrMU5jbtwGrn9Cj5/rcbe7XMY=;
  b=Y5UaOSqNrqlZDeRLs+G3wBiwk/Lw0eLdt8rqMTDUXweMh2v9tuk+Rnjb
   uSgv8Qy9dE2GRy/H8EgR9cqU4/HJE5HqoCjXd3++SVqdN2AhBDLT2RwBt
   YwNPudhuHThOy2Dnz+ADVs9dPyagG8vZBIeeNRv7fs4A1euwuVf1WdJld
   NhSINJYqdmx2fTxzmMEHNVEW+1Jkf9PI2IRgrAlQwQdOqCJsyxrjUGxaw
   9pceivPoDnrxCV2BB0J+fjMOaPPllPwZNa2/a+k9JdB0WLmvd60IcYB6f
   Sxe/+AbMeo9ZiuXh5vVt/e6ex03mC89iqAQfui6BCVzZeX7nEqFLBZyEQ
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="328379746"
X-IronPort-AV: E=Sophos;i="5.97,280,1669104000"; 
   d="scan'208";a="328379746"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 22:36:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="755929017"
X-IronPort-AV: E=Sophos;i="5.97,280,1669104000"; 
   d="scan'208";a="755929017"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by FMSMGA003.fm.intel.com with ESMTP; 07 Feb 2023 22:36:20 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Feb 2023 22:36:20 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Feb 2023 22:36:20 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 7 Feb 2023 22:36:20 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 7 Feb 2023 22:36:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K/OqQFcBC3sUpi71+gzsfIlIpiJxzgW9g7yVNZRGM6Dgias+vIR1PpD6C7GyQLMtKeLeLr98vBI/Zj0gEBINcmEyljWQ36YOOmhUSJDUYqDcQPzReSTl7Ih1QQk/7DoszssUhekcQFOCNvawhfp4j4CUOl8bjS5Kb/JuANREMrUf3T7/Q50TWuBWgfHMScpcpAWju7QDugPYgZWfCTdKlp4wSbdZJMBIp+ojWejl37kBlVZw91TEN0Qk1OQMDcLuW79FNgtmb+S0Ghjo/PMmrH4ywTHOWW83fwCV88Kd3YRV7a67HrDj+S2jfIQp9BKbMExt6koDimQzPRR8LAAGWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fxnqmWt/zKa1j9u4aFMrMU5jbtwGrn9Cj5/rcbe7XMY=;
 b=b6HQT8g7i8pBsqg1q9Ien8zfFsHgNqwTF7hbgvCS/U07E9EQrFpCGqykUei9AFoYqexZUSFl/Vpk0J44zcB9sk3vSKzx86C1+oesnqTngO7WXpHju+X0b9VoRzSIPpYhsoDu73d5tBM0nnFd1BPCYdCpi3oj5MtQPOhoJ7endCTQ5xHBVyQ0yqQCVCbNQDO0nP2pKdiLFMeINMcfhpMwtPXfq/7OIQAsi1vBpxTHyc4Vk1YCAOx5r/ogP7WJ9Gv7BYW/YbMH4z4INzgTtqYKvGiwdF3VKZkIJ4KYjNN5vvBxaYDs7AVvCURaVfITbc8UP6w1GrmpsMsUkwTCO1VqpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN6PR11MB3988.namprd11.prod.outlook.com (2603:10b6:405:7c::23)
 by CY5PR11MB6390.namprd11.prod.outlook.com (2603:10b6:930:39::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Wed, 8 Feb
 2023 06:36:16 +0000
Received: from BN6PR11MB3988.namprd11.prod.outlook.com
 ([fe80::16cf:5ab1:7f74:d1e5]) by BN6PR11MB3988.namprd11.prod.outlook.com
 ([fe80::16cf:5ab1:7f74:d1e5%7]) with mapi id 15.20.6064.034; Wed, 8 Feb 2023
 06:36:16 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>
CC: "gregory.price@memverge.com" <gregory.price@memverge.com>,
	"Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>,
	"dave@stgolabs.net" <dave@stgolabs.net>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
Subject: Re: [PATCH ndctl 5/7] cxl/region: determine region type based on root
 decoder capability
Thread-Topic: [PATCH ndctl 5/7] cxl/region: determine region type based on
 root decoder capability
Thread-Index: AQHZOyjCbpj9o+tVl0C8FxqU/nkUZa7EjbEAgAALPgA=
Date: Wed, 8 Feb 2023 06:36:16 +0000
Message-ID: <25e86e813cf63b618d0756dfb1d3ecc2fb4325f8.camel@intel.com>
References: <20230120-vv-volatile-regions-v1-0-b42b21ee8d0b@intel.com>
	 <20230120-vv-volatile-regions-v1-5-b42b21ee8d0b@intel.com>
	 <63e3396a17860_e3dae294d8@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <63e3396a17860_e3dae294d8@dwillia2-xfh.jf.intel.com.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN6PR11MB3988:EE_|CY5PR11MB6390:EE_
x-ms-office365-filtering-correlation-id: 0b39ee63-76d7-426a-51db-08db099ec7cd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OcPDlo/6+UPmT/B97Wu977m1Q2gPBiS11wvDUbOmDGNfEOFQoGS9knv8qYxw4B32GE9/ka3AScZqjQEOi433nLwYfqWVt2BfAqj56hLJMp7/fCamKrNdwm6aAQdOVVQ8Yf5wGGYXd3zGnW7D+BqX4K0kH7pl2jArIJWDjo0t55O9Eyyj6LayEh/nUo+ch8BpPliASdZbipAr+Qi9wSdSwL/9jT/RoIR+s/vKf7PUuYa8KhKKw4DJYxBxhHSeAavVnSwqmsZ37jUMpQlW90lSUPzfxBgRc0N9rPwZajcOJPg+d+dMKZWhNneJfvQIoMjZCDBruFSSkMb/VHhnkke4XD+ovcNJkW9Eg70bIPvbivFojdb/ZU7WjLLYc8VGfugfyQOaOeueNvDhsjO/lDWOg24oVbANweXLJnPEF9lJ3YcupA6uGEgMI4QQnNST6t+mFkl6W+vnb2X46UK8ev9MPolU+kDfdj7KzJ5RrBrl/umfKNq9+DC6eZKta3mOnINhnLNqJgBX9+8warE0Gfd3Q85UI5JgjnjBaxMITfv2CIdF82CN8cnQei08swEv+yDMXiT8zKQCC5v/6F4nJR6mXxVP4QgTg+58TWiE3K3iN8Oxd8tN8h7tZw97Xbh/59yr8oZSLFWsY/59QlUAVQiEYu7r26meK7EOPzuu7pux78yJRXLkM06WjomdFwFS5ocUUbQDhNdulTjS1V9U0n5H5A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB3988.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(376002)(136003)(366004)(39860400002)(396003)(451199018)(2906002)(38070700005)(5660300002)(38100700002)(122000001)(82960400001)(36756003)(71200400001)(478600001)(6486002)(86362001)(2616005)(6506007)(186003)(26005)(6512007)(8676002)(66476007)(66556008)(64756008)(66446008)(91956017)(76116006)(66946007)(8936002)(41300700001)(4326008)(54906003)(316002)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?emVxVTRLdlVsRjFSU1NudnJSV2djc2FsOXRYbHQrdnZTaVFEMXNya21kRkxx?=
 =?utf-8?B?MisycDU1ZFpISitWMlByc2p2MWpxVzVLVFMxNU5kM3hjOXF3amsrYTdDQXlm?=
 =?utf-8?B?bWRPZktQS2VvbXM3ajJhbUpJNGo2SGNiU3JoNmZ0QkJzUlZQTVRRVGtpZWR3?=
 =?utf-8?B?bGRxTndnaGFVRmlNemdUTjFJQWVodFIySGt6MnA2T1hlcXBSWWhNdlNWZWRl?=
 =?utf-8?B?WUgvTFg3R1ZPTDJwQ2Y3R2FnTTBpM0dGaStmRnNQaGJwLzk2Vk5sVEs2empG?=
 =?utf-8?B?SFFKdWttUEh6TEVGc2w2eVlRc1NGVUk2TGNMcGtEemhGdjJ0TUVjVFdTTHpB?=
 =?utf-8?B?Um44U3RyZTY1VEhSVFllUVdSZUNrajlQNXpQZHdqbzlGbEFDaDE4Ui8xeVhH?=
 =?utf-8?B?dUhPT2E1M0QwNHlxR2pUN0l2elVRZnp6MzFja3B5RXhzZVNRZWhlNDZQZ1dX?=
 =?utf-8?B?bVlpNE9US2hIbkVJT0ZZdGxyNFM1NHdrTHVNbzNJSjk2eUJDTnMrN3NpWTVS?=
 =?utf-8?B?NFcrWDA4NWNMeDlpUzFOL2NGbys4cklwclVLOE8vaitxbWFIQTBlREpFMC92?=
 =?utf-8?B?YzhMWktGNWk3UHB6VFlybjFjVUpxVFpTQXJONzJNMDNiYlMxTU80TXJFR2FT?=
 =?utf-8?B?cXYxUHlnT041OXM0VHhnZHFKdmswaWRZOGllRE9Fc3VjUEpYUWVGV0w4czhQ?=
 =?utf-8?B?cE81ckZmNlJhSkdUZ0Rla2ZpUkZjQ0QvMmYvUTdwTDJBUFhLS1VwREx4SU1p?=
 =?utf-8?B?SktYMXVVbE82LzhOd0JCazZ4OUR1Mk0wMFlZU1d6M3lzZ1lmNnppbklSMHY0?=
 =?utf-8?B?Nm1UVDhIM2hqWG9CTmJJLy9PQVYzY1h6MElQZXlIWko5MUdWREhQN3Mra3dE?=
 =?utf-8?B?dXBPWm1QRHFSS1pSMFByUUl1VXBpZkYzVXdpOXpPV3dMV2Y0V3U4S0xkcnds?=
 =?utf-8?B?TGU3K3hZeGE5cUZNbm5id1U2Z0RkNEoxV0RwN3pyS0VSZDEvdmQ2YlgrREpN?=
 =?utf-8?B?SXZwYkxrK1pkWnFqVGRWUW1PNW8zMzBJMFllT0VTNEFQbXhaVjlpK0R4ZnJI?=
 =?utf-8?B?UXVHMTdOUVBBT3dENHVpRGNsZmh5cWNLUnhpMUE3OUs1Vkw1WlNKekIyNVkx?=
 =?utf-8?B?RFFsdGl3dE9rL2U5TTZSRFBkTU53REw2RDMvNFpvNVZwN1ZYbE5uYVlWTlBq?=
 =?utf-8?B?N3JUN3FvY29COGcrbis4SkVoZVRzMEVweGZ3SzdRbmlnQnJPd3J1NDY5L0Nh?=
 =?utf-8?B?Z0dabmZySDhtWVFMU0FhN281VThtMnVFS3lDTGZyYlQyeURYNlRJNkxnZzZL?=
 =?utf-8?B?SXVScHhqVHZYT1kxVEM3RVorQUt5TDhYK3RRTjhaZ21PRjJYOVpKSllPNGxv?=
 =?utf-8?B?ZlRyWW9XSWhRaHdoVmp6WUc3TkE2TEZzTFh0dHc4WUxwcUo4QTlPVitQUnov?=
 =?utf-8?B?QkpGTlZBWkF6ZEpHUjlCSDdjNTFnalhRTDlCbmNkbnh2Zlh2ckkzS0MxRXFy?=
 =?utf-8?B?MGQyWTZySEdod1NCMTR0MVFDYm1GRjl1bTkzYVp6ZVlqTjlNYUkzaUpaYzZD?=
 =?utf-8?B?eG5BMmFwL3l5UExwR0xIdVBvRWxFTDdlcTNqa09aVUlDZEZpUnQ4bWNLR2U4?=
 =?utf-8?B?cC9vSGVPOHBLMG54USs2RTBpNFBiN21NZEkrRWdUK3lJWEYzNm83WElUY2Ny?=
 =?utf-8?B?Zi9HdGxoV0s1VStHcFF6Ny92SHdlSzZXQk1ScEhVUnhiMG9hT0I0ZUU4b005?=
 =?utf-8?B?Vm1BVUZib2I3MlF5L2x6OS9VOTRCU2pqSkZmbVp5RlVpb2t6WnZ3RDV4dHNk?=
 =?utf-8?B?dlFpN05ONk8vQ1Q0MG9YMEVhYWx0azkwNURaVXM4VW5oQ2FGelFISUJnRUUv?=
 =?utf-8?B?UUVEeCtkbUQrUEJTM3lWUkhwWnk2YUFoQzNUSnNIOVBMSW9VeWpGbkljZHB2?=
 =?utf-8?B?WDB0WTEwR1M1QjVpL1A2Yy9KWTc4YXNFQThqTkZvZWN0d1NZZnhLb2V1RmQ3?=
 =?utf-8?B?dmRRcDNySWh6eE81SGFyR1NiZ2J1aDg4KysxSm1KS1BuVWMvY3V2MDZleGFq?=
 =?utf-8?B?MUp0TzlHM2ViWVdlOHYycjZ2dmVSaXFzbWdkb2Y4R2RHcWdJL29xTW0yTVBO?=
 =?utf-8?B?VXJ2S0Q5a3hVYzZTWTQ4UUFTOTVmWm80MUJyS0tUYm5jbWJtSkdrSTM1NjZK?=
 =?utf-8?B?eXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CB44748F60BF664BB085B82FE872F7D5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB3988.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b39ee63-76d7-426a-51db-08db099ec7cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2023 06:36:16.4349
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pyFqq4ejgCOl+Yxpi3Son7uL4Uft3WZTeecUPT4wWKobtys3B5aShr3YBRDqoXASDlLvpwa1Y8Cm7uXRycYGpiyYZYjJTiT95oee8484ubI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6390
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDIzLTAyLTA3IGF0IDIxOjU1IC0wODAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6Cj4g
VmlzaGFsIFZlcm1hIHdyb3RlOgo+ID4gCjwuLj7CoAo+ID4gK3N0YXRpYyB2b2lkIHNldF90eXBl
X2Zyb21fZGVjb2RlcihzdHJ1Y3QgY3hsX2N0eCAqY3R4LCBzdHJ1Y3QgcGFyc2VkX3BhcmFtcyAq
cCkKPiA+ICt7Cj4gPiArwqDCoMKgwqDCoMKgwqBpbnQgbnVtX2NhcCA9IDA7Cj4gPiArCj4gPiAr
wqDCoMKgwqDCoMKgwqAvKiBpZiBwYXJhbS50eXBlIHdhcyBleHBsaWNpdGx5IHNwZWNpZmllZCwg
bm90aGluZyB0byBkbyBoZXJlICovCj4gPiArwqDCoMKgwqDCoMKgwqBpZiAocGFyYW0udHlwZSkK
PiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm47Cj4gPiArCj4gPiArwqDC
oMKgwqDCoMKgwqAvKgo+ID4gK8KgwqDCoMKgwqDCoMKgICogaWYgdGhlIHJvb3QgZGVjb2RlciBv
bmx5IGhhcyBvbmUgdHlwZSBvZiBjYXBhYmlsaXR5LCBkZWZhdWx0Cj4gPiArwqDCoMKgwqDCoMKg
wqAgKiB0byB0aGF0IG1vZGUgZm9yIHRoZSByZWdpb24uCj4gPiArwqDCoMKgwqDCoMKgwqAgKi8K
PiA+ICvCoMKgwqDCoMKgwqDCoGlmIChjeGxfZGVjb2Rlcl9pc19wbWVtX2NhcGFibGUocC0+cm9v
dF9kZWNvZGVyKSkKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBudW1fY2FwKys7
Cj4gPiArwqDCoMKgwqDCoMKgwqBpZiAoY3hsX2RlY29kZXJfaXNfdm9sYXRpbGVfY2FwYWJsZShw
LT5yb290X2RlY29kZXIpKQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoG51bV9j
YXArKzsKPiA+ICsKPiA+ICvCoMKgwqDCoMKgwqDCoGlmIChudW1fY2FwID09IDEpIHsKPiA+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAoY3hsX2RlY29kZXJfaXNfdm9sYXRpbGVf
Y2FwYWJsZShwLT5yb290X2RlY29kZXIpKQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqBwLT5tb2RlID0gQ1hMX0RFQ09ERVJfTU9ERV9SQU07Cj4gPiAr
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZWxzZSBpZiAoY3hsX2RlY29kZXJfaXNfcG1l
bV9jYXBhYmxlKHAtPnJvb3RfZGVjb2RlcikpCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoHAtPm1vZGUgPSBDWExfREVDT0RFUl9NT0RFX1BNRU07Cj4g
PiArwqDCoMKgwqDCoMKgwqB9Cj4gCj4gSXMgQG51bV9jYXAgbmVlZGVkPyBJLmUuIGlmIHRoaXMg
anVzdCBkb2VzOgo+IAo+IMKgwqDCoCBpZiAoY3hsX2RlY29kZXJfaXNfdm9sYXRpbGVfY2FwYWJs
ZShwLT5yb290X2RlY29kZXIpKQo+IMKgwqDCoMKgwqDCoMKgwqBwLT5tb2RlID0gQ1hMX0RFQ09E
RVJfTU9ERV9SQU07Cj4gwqDCoMKgIGlmIChjeGxfZGVjb2Rlcl9pc19wbWVtX2NhcGFibGUocC0+
cm9vdF9kZWNvZGVyKSkKPiDCoMKgwqDCoMKgwqDCoMKgcC0+bW9kZSA9IENYTF9ERUNPREVSX01P
REVfUE1FTTsKPiAKPiAuLi50aGVuIGl0IG1hdGNoZXMgdGhlIGNoYW5nZWxvZyBvZiBkZWZhdWx0
aW5nIHRvIHBtZW0gaWYgYm90aCB0eXBlcyBhcmUKPiBzZXQsIGFuZCBvdGhlcndpc2UgdGhlIHNp
bmdsZSBjYXBhYmlsaXR5IGRvbWluYXRlcy4KCk9oIHRydWUsIHRoYXQncyBjbGV2ZXIhIEkgaG9w
ZSBpdCBpc24ndCB0b28gY2xldmVyIGZvciBmdXR1cmUtbWUgd2hlbgpjb21pbmcgYWNyb3NzIHRo
aXMgYW5kIHdvbmRlcmluZyB3aGF0IGlzIGhhcHBlbmluZywgYnV0IGZvciBub3cgSSBsaWtlCml0
LCBzbyBJJ2xsIHJ1biB3aXRoIGl0IDopCg==
