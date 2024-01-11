Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 897EB59150
	for <nvdimm@lists.linux.dev>; Thu, 11 Jan 2024 22:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KWndEFAF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705013670; x=1736549670;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=uUB5Fyc3WQ+kjc4u/0enEC74l9IREmkKnOLRSm95pcQ=;
  b=KWndEFAFfKaJATqJKHt1ng0p+JkikrqtdRm60WqawTtDDxB9TzlA/Ple
   xSxoX7Eja8Dr6x/EF1HdE6YiBxuw7QSjt3b1RamvqTSCcoE40t8ED1g1/
   CrgsUbj+Zwu9ojXYpNWBV4PkpODSSo7LonECvZ5SNVKZ69owMBAKNU6Q4
   s6Ypt6d2MCR0FyZ1tOFzJzFSBYkk3HBLBIOmvBUBSovX04PtbJop1Q7Xo
   zCGo5yk7P4tizivKFwyQnJPgQmTRDtAcmkXyACRkwdZG3ZCPaMXceM208
   bs/pQZBBp29XGG7a5tKdRF3vPRg7QtkqdzXn2jLFjU64JMXevW+gctf/L
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10950"; a="402788585"
X-IronPort-AV: E=Sophos;i="6.04,187,1695711600"; 
   d="scan'208";a="402788585"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2024 14:54:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,187,1695711600"; 
   d="scan'208";a="17193232"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Jan 2024 14:54:29 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 11 Jan 2024 14:54:29 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 11 Jan 2024 14:54:29 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 11 Jan 2024 14:54:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NxZpp2FVt3YQvhv+JRqb7Ju5AJyE4WCgEl4Q1InFhs2nf0IvM9hlRNW5OJMGSpl5W6cogHqkbfimLDUjgvKi4Et8+6M6RCTILkNS6dNyIM2OJLOS/GsLy3qlGqlNWdC+K370hSfDhLbBfnSn1FHheskeMUBO40ubRUQfOWtKmGf/hbWQdhSb/Or0eljo+JROE1waNHsK8oUtWN36Nev7Ud2RnsF+A1LRmhYTlGyteXPLfguyXBDTv63rnVLoy+NVhiyBjQ6HHXzHRGvkBkjrUADN+gKc0w+iGJ8LDDhyEpNouzawRy2U7FzeSTwBGN7b1ns1j3nzS9coAfe/0DtIlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uUB5Fyc3WQ+kjc4u/0enEC74l9IREmkKnOLRSm95pcQ=;
 b=n4JVtQyKw9vKpmBvkcUeVg9wsMbIohjXCuNKxnUClZlKYlhifUHFnIUZq5HEuPNA5dBTS/in5QpYBF1K0f5IFf+5ruJYL3R+n1/mhSaVNiex4LZQP1icqUYrlGDgwspYUfjjb2UAYG90dRh42DT9KiJrtMy6KzzGXYvucDSnUoqVUhiKKDm2dVxbgXWIvrD8uLFByxfRby8ucaLaOjb6KLI48pOTPUYpXhQ+Es+19wLvqlFIrmC4fgBcKyXQ5cKGE+NoQsZKDPhIHJUjVz2FP10NGP6R4N/asXbr5oNI6HiZgGsfY2vWh1zuqLshKS9cP/pVLOFQRoUirzRDeQ0JVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by BL3PR11MB6436.namprd11.prod.outlook.com (2603:10b6:208:3bc::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.29; Thu, 11 Jan
 2024 22:54:22 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::3b75:f6ef:f383:eb3b]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::3b75:f6ef:f383:eb3b%4]) with mapi id 15.20.7181.019; Thu, 11 Jan 2024
 22:54:22 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
CC: "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>
Subject: Re: [PATCH ndctl] test/daxctl-create.sh: remove region and dax device
 assumptions
Thread-Topic: [PATCH ndctl] test/daxctl-create.sh: remove region and dax
 device assumptions
Thread-Index: AQHaRBevlIIAmpDrEUy2nZIz7x/Ti7DU/y+AgAA62gA=
Date: Thu, 11 Jan 2024 22:54:21 +0000
Message-ID: <24009232372b8f554f2b0f272da55b582c74703f.camel@intel.com>
References: <20240110-vv-daxctl-create-v1-1-01f5d58afcd8@intel.com>
	 <65a0403d151f9_5cee2944d@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <65a0403d151f9_5cee2944d@dwillia2-xfh.jf.intel.com.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|BL3PR11MB6436:EE_
x-ms-office365-filtering-correlation-id: c2add4c7-7f04-4f77-300f-08dc12f8404d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Bhbyf0CWrzV2K2eDXkqfE8nFxxDZdGHTV26FydhVzv6Hxz9Zb1P+P2VaIU6+9aquNOjKVBVsI5i+3n5YBGOR73fC8R6VBWk6XV4fZMiQ1kFiYLj+TSd8WJs1E7d5BaGLz7gDThcy2FEvPXeiL/UqgULr+zHp9CYe2pIkPkVbDZS0WbPNYw/UmOUkbCzTC33UJxVTe/t2nrN6k+UCP3zQjmbvdbreZr+kKvcuurf8GSz33NWZl0h6au9w4iLF4hl/tEwjgCIQhcs/sI6zEGXjjmqlSE/ye5zBg7muSMXwQY9bEa5j0bRbcOgsLR7CWOXsx1fwFhmJaNfKkIVYNWmtyASMoEaor2hzb1ljNugTjHoCT6DKFmX0ADp0P0HSQf4mq2Tp6qpkWbdgDqwKsrno9gC+VkEvp06fDr5dt46E7H9ZGRNyEJ3O6MMVHlvBuFVzswXde8A6zAO6SI1VWSjEzHo2U3x5kVuQBgLyfIvr/Yez0xJIOaYsUwM7QOe5PpI6FfpwE99/5mVUOf30I+qfKHyj2vm59PCc5luFo9NbC4v3LMSOxjBJ/Us0wpbPuToTJXOoQEzv8CFZjmNm9e696tdQXFXR/u7EmzbmYhnZagPNXLLIexzvAtZE3pAeuH+a
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(376002)(136003)(366004)(39860400002)(230922051799003)(451199024)(1800799012)(186009)(64100799003)(82960400001)(38100700002)(38070700009)(36756003)(86362001)(83380400001)(2616005)(26005)(76116006)(71200400001)(6486002)(6512007)(316002)(66446008)(64756008)(6506007)(66476007)(66556008)(110136005)(66946007)(5660300002)(478600001)(122000001)(2906002)(41300700001)(8936002)(4326008)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dkpBMjFnOE5NejJlWTJka0dnMVFEY1BNd0k2Qy9oOTJQY0F2UmNhY2w5ckQy?=
 =?utf-8?B?RENrbUFQdzI1dFBuMzNLY200anV1V1daeTdreFJsZ3Q4MDcxcEhNYjRpUEpk?=
 =?utf-8?B?VkRTcExvSzdGK0l2eFQzV3JhdnhhSmdwc3pxcVo0cU1VMGpxN3ZaV3pBN0Vn?=
 =?utf-8?B?VzNkbnIyZ1h1K0d1aWloZlE1WUo2WnZ2RjcweDFRcldESUVnb1NRM2k3Y1B2?=
 =?utf-8?B?SDdtYjdHanFHcGFBanlocTdLVERsZjc1WUdRclMrdGQ4TERiL1RVVUgvOTBI?=
 =?utf-8?B?U3pVVnpFV1JYN2MvVHBObGV2UnVrd1B6ZDRaYk5pWVRRYXRoRlFOTEZsdGk1?=
 =?utf-8?B?K1lpQVVrbFl3aFpDdEZCQUg5TzZFOW5LN1hFVEt3Vzg4TVRma2IrS3hpdlVv?=
 =?utf-8?B?S2dKTk5UVjVCK2VJclNyZHQzRTlKV1N2SjJyVHdqQkpBZ0dQWUlPSGRldnFJ?=
 =?utf-8?B?RzVuT1JDRERvZnRGRW5hY2xlak5KVGF4OUttakJWVXJ0WFVXMktyMVN1WnZt?=
 =?utf-8?B?ZmlNWDcrdm5iemhXQzlzdmJKNzBpdFdJYWdzelFheFNsK0U2dnNEU1ZJMjY0?=
 =?utf-8?B?NSszNU5sVGhkN2F1UUExV0tUcFl6N25NY2l5ZHVOYWh3V0l6bUVPUVV1cTRP?=
 =?utf-8?B?OHY2Wlo2d0ZvTjVKRkQ5SXJrbWRRZFY3S1lBT0o2eTNCcjVPNzNFTjZJTkRv?=
 =?utf-8?B?elhCb3FQb1lZNjNhc1dNUDB1T1FLK1VFZktmR1V5akJJVXBIMklPSDBaVW9i?=
 =?utf-8?B?bFFZMDNjV3RYMjhSWDUzQVk0Sm1sL1NNajF6MXJUdXNtYlhrU2M4RmZieFdk?=
 =?utf-8?B?REZ0OHlneFZaTCt4azhCN3RSaDlGbkZEa0NiM2NZLy9YUWNEY1R4UEx3K0Qz?=
 =?utf-8?B?VE10QTRLL1NtaTFITW1hV3FGbjQzVU9CVDAzNURRZlJ1N1dWMFBxQkhMUTBN?=
 =?utf-8?B?UFBhMlR1R1ArN0tKTkt2OUJ2Q2xsbnlMcU8wYi90SHRHdHhxZWpUN0gwbHdt?=
 =?utf-8?B?VGR6SEFPQlVXcnpQTVo2Y1pZWktUZ3FsYzY5QlJyVS93dnFmTWNtUDUwZzVT?=
 =?utf-8?B?d2p3OHVpdXlNczJac3g3MjdiNDNsK2hBTzMxbm5ORU9MQmtmQmlKZXNZMUVz?=
 =?utf-8?B?RlhJUk11MmdycFZXRDhiMlNweTg5Z3RHOHlVRU9aT1BJUXIyTDF6Nkoyc3VS?=
 =?utf-8?B?VGY4Y0tPN085QWs2ZzZZb3o2UDVSeU5CL2JnRkw1dXBVdml1ZStldVVQVEd5?=
 =?utf-8?B?RkhLdWtFUkJNWkV6NU9yUFo5aEhLUVRQSDcxREV1bFNydVcvY29YaHpTeEFj?=
 =?utf-8?B?ZjVCYnJFWnpVN0E1YlNtaUJGWitJd0Q4NFBCaGQvd081aW8zNkxCSVV6Tmwr?=
 =?utf-8?B?SnFtQnNGSnIvMWJDTFVJb0E1Y2NWSUE0bnBmbndXMkdzS2s0eXBSTFJSQ2sy?=
 =?utf-8?B?SnlpVlVyTUZWMWMyRTRFdnI1MmRnL3lsdi8yUGlzcEdEYWt1Z3RMQUNmbFpw?=
 =?utf-8?B?ZzBLOWtHTm1TM1BUL1dvNEtkZlZ4Wkx0RVpiNGpjU0FhdjRvd3Q2TVBPbEI0?=
 =?utf-8?B?aDJUOWtCem5IeXN3dFhWRHpIOGIxTU5CcVdCMFFRTjdCbFNkUXUvTldKZTJN?=
 =?utf-8?B?L29PQWwrUW9MUFRtZExKVVZxV2lUbEUrNEpQYi9Wcjh2cFhIVlNDYitnRi93?=
 =?utf-8?B?N1dMZnUyOURnUlByenFsd1B4R3ZIak53YSttVWJLUTl3SnpKOGd5c1lITVBp?=
 =?utf-8?B?Z1k3M2tpWEt0YTV1clRZM2EwdUdydU9EYi9XUlhWTkVPSkh4UVNFdzNzSU5E?=
 =?utf-8?B?TXVzKzBJQjZ2MGF0SVF4VHg0TnZuMS9LRndWUXRWUU45SDFaeGtRMUcrdnlE?=
 =?utf-8?B?V3NoZ3piM2dPNDBiL3hXREl3dmlYVmhCUytlMERORU55ZzJ3NVRJK0xwUXNX?=
 =?utf-8?B?RTg5eXZMc0IzODhVckhuS3lQZ0FDOTlzejVSSzlhcCtGak1aRjgydkFXSWtK?=
 =?utf-8?B?cnp3NDF1VzJNS09DTW5PcE9wWitkT0hQYnliNHRwNisyTS9GZDBKRVhPTWtP?=
 =?utf-8?B?QVVZbGdnektMM3JLSUNtcGs2dGVPWW1iaDJtY05BT0JGcEJ2dklWSm82aU96?=
 =?utf-8?B?ZXhzL0VUYW81bDN1NStiNS9NOU43bWFFazQ5UlhRUVhtMzJXaDFieE9kQVk5?=
 =?utf-8?B?Snc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7C14E8510650D84B92E0CD493300F89A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2add4c7-7f04-4f77-300f-08dc12f8404d
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2024 22:54:21.9545
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s9VfggJTxnYYE/MtIp2vy2No4YbvL8wXvkTr6wYDX2mUUrtE+96N+uidfhCZwWm9n0M+NhDq3t7OUBSHuIJrVQIr7/mL0o5QCZK1rPTtlVY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6436
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTAxLTExIGF0IDExOjIzIC0wODAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IFZpc2hhbCBWZXJtYSB3cm90ZToNCj4gPiBUaGUgZGF4Y3RsLWNyZWF0ZS5zaCB0ZXN0IGhhZCBz
b21lIGhhcmQtY29kZWQgYXNzdW1wdGlvbnMgYWJvdXQgd2hhdCBkYXgNCj4gPiBkZXZpY2UgaXQg
ZXhwZWN0cyB0byBmaW5kLCBhbmQgd2hhdCByZWdpb24gbnVtYmVyIGl0IHdpbGwgYmUgdW5kZXIu
IFRoaXMNCj4gPiB1c3VhbGx5IHdvcmtlZCB3aGVuIHRoZSB1bml0IHRlc3QgZW52aXJvbm1lbnQg
b25seSBoYWQgZWZpX2Zha2VfbWVtDQo+ID4gZGV2aWNlcyBhcyB0aGUgc291cmNlcyBvZiBobWVt
IG1lbW9yeS4gV2l0aCBDWEwgaG93ZXZlciwgdGhlIHJlZ2lvbg0KPiA+IG51bWJlcmluZyBuYW1l
c3BhY2UgaXMgc2hhcmVkIHdpdGggQ1hMIHJlZ2lvbnMsIG9mdGVuIHB1c2hpbmcgdGhlDQo+ID4g
ZWZpX2Zha2VfbWVtIHJlZ2lvbiB0byBzb21ldGhpbmcgb3RoZXIgdGhhbiAncmVnaW9uMCcuDQo+
ID4gDQo+ID4gUmVtb3ZlIGFueSByZWdpb24gYW5kIGRldmljZSBudW1iZXIgYXNzdW1wdGlvbnMg
ZnJvbSB0aGlzIHRlc3Qgc28gaXQNCj4gPiB3b3JrcyByZWdhcmRsZXNzIG9mIGhvdyByZWdpb25z
IGdldCBlbnVtZXJhdGVkLg0KPiA+IA0KPiA+IENjOiBKb2FvIE1hcnRpbnMgPGpvYW8ubS5tYXJ0
aW5zQG9yYWNsZS5jb20+DQo+ID4gQ2M6IERhbiBXaWxsaWFtcyA8ZGFuLmoud2lsbGlhbXNAaW50
ZWwuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFZpc2hhbCBWZXJtYSA8dmlzaGFsLmwudmVybWFA
aW50ZWwuY29tPg0KPiA+IC0tLQ0KPiA+IMKgdGVzdC9kYXhjdGwtY3JlYXRlLnNoIHwgNjIgKysr
KysrKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+ID4gwqAx
IGZpbGUgY2hhbmdlZCwgMzUgaW5zZXJ0aW9ucygrKSwgMjcgZGVsZXRpb25zKC0pDQo+ID4gDQo+
ID4gZGlmZiAtLWdpdCBhL3Rlc3QvZGF4Y3RsLWNyZWF0ZS5zaCBiL3Rlc3QvZGF4Y3RsLWNyZWF0
ZS5zaA0KPiA+IGluZGV4IGQzMTlhMzkuLmE1ZGY2ZjIgMTAwNzU1DQo+ID4gLS0tIGEvdGVzdC9k
YXhjdGwtY3JlYXRlLnNoDQo+ID4gKysrIGIvdGVzdC9kYXhjdGwtY3JlYXRlLnNoDQo+ID4gQEAg
LTI5LDE0ICsyOSwyMCBAQCBmaW5kX3Rlc3RkZXYoKQ0KPiA+IMKgwqDCoMKgwqDCoMKgwqBmaQ0K
PiA+IMKgDQo+ID4gwqDCoMKgwqDCoMKgwqDCoCMgZmluZCBhIHZpY3RpbSByZWdpb24gcHJvdmlk
ZWQgYnkgZGF4X2htZW0NCj4gPiAtwqDCoMKgwqDCoMKgwqB0ZXN0cGF0aD0kKCIkREFYQ1RMIiBs
aXN0IC1yIDAgfCBqcSAtZXIgJy5bMF0ucGF0aCB8IC4vLyIiJykNCj4gPiArwqDCoMKgwqDCoMKg
wqByZWdpb25fanNvbj0iJCgiJERBWENUTCIgbGlzdCAtUikiDQo+ID4gK8KgwqDCoMKgwqDCoMKg
dGVzdHBhdGg9JChqcSAtZXIgJy5bMF0ucGF0aCB8IC4vLyIiJyA8PDwgIiRyZWdpb25fanNvbiIp
DQo+IA0KPiBUaGlzIGZpeGVzIHRoZSBjYXNlIHdoZXJlIHRoZSBmaXJzdCBkYXgtcmVnaW9uIG1h
eSBub3QgYmUgcmVnaW9uLWlkIDAsDQo+IGJ1dCB3b3VsZCBpdCBhbHNvIGZhaWwgaWYgdGhlIGZp
cnN0IHJlZ2lvbiBpcyBub3QgdGhlICJobWVtIiByZWdpb24/DQo+IA0KPiBJIHdvbmRlciBpZiB0
aGUgYWJvdmUgYW5kIHRoZSBuZXh0IGxpbmUgY2FuIGJlIGZpeGVkIHdpdGggYSBqcSBzZWxlY3Qo
KQ0KPiBsaWtlPw0KPiANCj4gwqDCoMKgIHNlbGVjdCgucGF0aCB8IGNvbnRhaW5zKCJobWVtIikp
DQoNCk9oIHllcCB0aGlzIHdob2xlIHNpbXBsaWZpZWQgYnkganVzdCBkb2luZyB0aGlzIGRpcmVj
dGx5Og0KDQogIHJlZ2lvbl9pZD0iJCgiJERBWENUTCIgbGlzdCAtUiB8IGpxIC1yICcuW10gfCBz
ZWxlY3QoLnBhdGggfCBjb250YWlucygiaG1lbSIpKSB8IC5pZCcpIg0KDQpUaGFua3MgLSB3aWxs
IHNlbmQgdjIuDQoNCj4gDQo+ID4gwqDCoMKgwqDCoMKgwqDCoGlmIFtbICEgIiR0ZXN0cGF0aCIg
PT0gKiJobWVtIiogXV07IHRoZW4NCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oHByaW50ZiAiVW5hYmxlIHRvIGZpbmQgYSB2aWN0aW0gcmVnaW9uXG4iDQo+ID4gwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBleGl0ICIkcmMiDQo+ID4gwqDCoMKgwqDCoMKgwqDCoGZp
DQo+ID4gK8KgwqDCoMKgwqDCoMKgcmVnaW9uX2lkPSQoanEgLWVyICcuWzBdLmlkIHwgLi8vIiIn
IDw8PCAiJHJlZ2lvbl9qc29uIikNCj4gPiArwqDCoMKgwqDCoMKgwqBpZiBbWyAhICIkcmVnaW9u
X2lkIiBdXTsgdGhlbg0KPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBwcmludGYg
IlVuYWJsZSB0byBkZXRlcm1pbmUgdmljdGltIHJlZ2lvbiBpZFxuIg0KPiA+ICvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqBleGl0ICIkcmMiDQo+ID4gK8KgwqDCoMKgwqDCoMKgZmkNCj4g
PiDCoA0KDQo=
