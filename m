Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 368C6134C5
	for <nvdimm@lists.linux.dev>; Wed,  5 Jul 2023 21:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688590990; x=1720126990;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=KeVhGe5GS1rtNG5mA1sJMihoMDDbO7EcSrXLwmSH9rU=;
  b=i1C/22lJsbyqdcrWnAxF+0gOb6KINduSIs4mTlgbqrbyw6yJR7UcM+cW
   3od70u5reFBbMsIO4seGf+ucnsbhqde27x4WjtXH/J8TG6LaosPa+YMEt
   yZSOfSNRshkj5Po/7V1ElniZdonMcDP+v2L0GxIrvjSKumjk2AaMOczTb
   HuVXF68a0jRHSqMnrpd/+E6K5saxAF99kqMOA/JmSp6SeQGbywhBXclYY
   Xkg4B0lkfZ80NtH0M3FzFsMUx4K9DyFF8b3jpSVY6o3/FKdtpcSnXkNiP
   849QreBPHAZKTFYZAzHE3fLyazlILHLwz/mknIF0bk0W3iMVA7Z8n7Rdk
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10762"; a="343035359"
X-IronPort-AV: E=Sophos;i="6.01,184,1684825200"; 
   d="scan'208";a="343035359"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2023 14:03:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10762"; a="722541966"
X-IronPort-AV: E=Sophos;i="6.01,184,1684825200"; 
   d="scan'208";a="722541966"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga007.fm.intel.com with ESMTP; 05 Jul 2023 14:03:08 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 5 Jul 2023 14:03:08 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 5 Jul 2023 14:03:07 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 5 Jul 2023 14:03:07 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 5 Jul 2023 14:03:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SCXM0oNOqAvLZiRlBLvDqqRQUjDZ4D63gNX1zudxyL9XUTr2rchv+VGy7U12KOilmTPrCu8eLfZVOg71fqjCh7D9vcomjecajimXyJb08QHYY2pW7BA24VYXga5yM/wi65a1pz4m8npwmdt58Hs+9J7IYOyRYX7M4EN9hzDedebNZJ48hbuPAmgz1K3HMMR4e4omGkR3t/zyiSMaeNbpR8a1nVXqiApbm62xEdU+NG524FEUq1CLoar+odtfAtGWOhH651oGbVnDGMt44mwjnY+BNToGEf//ZoxP/qS52UBgBoWs2CclmM1GU9RzcBIzC97nOoyIK8TRgaoCnSIBfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KeVhGe5GS1rtNG5mA1sJMihoMDDbO7EcSrXLwmSH9rU=;
 b=ir5HhAK74xyNbjDSAZyYWykCNqi3S7wkDuqnA3kNmzg4oxv9WktqmYDwqIvvIwfgN9mwoz1euUsZRxf4oMnJZxj78RwLxi0L8dGYxFuOo539Eej+dFjfc1RkRcxS3wwRQudTSddkz8Oaqab5hv9QQ3e9r31QVG0EUJkIytiuayMZGk5o7jg32/CDTLZZaXw7HpY7t4KbWCKrM0ZcyMlPgBRKhjE+0V7TEf3vsFD1m8GoPmXND6wlDomn+qovBtRBuYchfhmo1I/2OgY4kf/Rt8cJfANbsdtDlyHEXCAqK8Oa2l8iPCmA6M3jq/mb6I/HyAfFv78lqRfrLfFdPmDvjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by DS0PR11MB7358.namprd11.prod.outlook.com (2603:10b6:8:135::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.17; Wed, 5 Jul
 2023 21:03:05 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::8e37:caf2:1d81:631d]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::8e37:caf2:1d81:631d%3]) with mapi id 15.20.6544.024; Wed, 5 Jul 2023
 21:03:05 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "lizhijian@fujitsu.com" <lizhijian@fujitsu.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
CC: "Jiang, Dave" <dave.jiang@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "Schofield, Alison" <alison.schofield@intel.com>
Subject: Re: [ndctl PATCH v3 3/6] cxl/monitor: use strcmp to compare the
 reserved word
Thread-Topic: [ndctl PATCH v3 3/6] cxl/monitor: use strcmp to compare the
 reserved word
Thread-Index: AQHZk2ZojzI/Mcp5lUer4QIEXsEll6+r4WEA
Date: Wed, 5 Jul 2023 21:03:05 +0000
Message-ID: <d0378a7f915b2f9ef793214a366b5466c68d3204.camel@intel.com>
References: <20230531021936.7366-1-lizhijian@fujitsu.com>
	 <20230531021936.7366-4-lizhijian@fujitsu.com>
In-Reply-To: <20230531021936.7366-4-lizhijian@fujitsu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|DS0PR11MB7358:EE_
x-ms-office365-filtering-correlation-id: 275214e7-b7d3-466f-9d8f-08db7d9b3a5d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JKkNZjAJ84MyKL0opSY/cog3kmv/Bo5jwmA6TCnR1qg0hWmDTbcPjVrxPYdNwFYOhUje4iwdJkBx+39EIXbLh4xdYzw+HKjfrzgFU63mpliuqEHskd7j6VJGlDL8EF8nMTuj5wfjFsl1tL1zz+BpEN0nUIJah+X5yBWHDy5FJrGnGC2mCP+f5r9wdXTjkS3W20JGyR/N1ylZJXcEY1w/Ve1B0xB4YkyH1782yKd15BKsa8mlcu2T6FDkHWcFoM4XEzGhdtNqUmf2junVqsqIhApgeoVsUBP+iUwB679Egs9Xf/xRrHpCrc8UrQrPVBVIwBqpXPFPbOYmErGY+V0WqXd+gob05aDA+bLOvR27IhxMcR0rcng3HvzpeZ3X0AjCiTxpQ4S3s2ZmjOHbj9xGM5h7Wy2LezBwX7MJQBGHojQQD/mZa7W9UjiaX7bCAnLVw/wYxnShLhXit0+NZrb4j/NaX2Ts+sDzgPVfDMID+xX9JsZ90uSPBWXjJQ+NJM6R6BeLFOZnuySwY8fXhheEmrs9rfDxkESE6vqDWMA+A9K2MCeycVkc/cld21z/kNOnx0N88nLQbNUIiwt/i/gaGBWbZme8rFP975wE7i8y6vRUVjn/PlOA+XCIpiDQFp3174duHv2ivw03LltgGztwzA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(366004)(376002)(39860400002)(346002)(451199021)(478600001)(186003)(82960400001)(6512007)(107886003)(26005)(6506007)(86362001)(71200400001)(2616005)(110136005)(316002)(83380400001)(54906003)(38100700002)(6486002)(76116006)(66556008)(66446008)(122000001)(64756008)(66946007)(66476007)(4326008)(5660300002)(8676002)(8936002)(38070700005)(2906002)(41300700001)(36756003)(40753002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RnI3bkgwV1VZWUJWUmcvQUd1cXdHeitDUmRPcE1JK0Yxdk13TllSVGxYRzNu?=
 =?utf-8?B?YlNUUjFwVmp1YlhiVmViM1BqV0dPcCsrNlVOdnRvSE42UU5vVzdQcnNtL1ND?=
 =?utf-8?B?Y3FORzZCcEZ6eEgzR2RneXJxZmltcWNIRjdHTGtsSXNuSm5kTGpzNkF2N2NL?=
 =?utf-8?B?YWc3bkl2aWlBN00vbDJVU01YRTEyVUxkSWpkRHBzU2FLZzRZczI5T0xOQjBH?=
 =?utf-8?B?QnB1M3pYU01VTnNqMGY4c3dQTW5jZ1cxMGt5eit0OFFGbzZqME9tMzByM2xx?=
 =?utf-8?B?QUVKQUVid3RxanNoNEltZG4wZGhFczdOTVNXUlBldmhPbTUwZFNIeG0yUDVp?=
 =?utf-8?B?MWpkbDhqU3dQYWhvT2dMeEpnNTVmR2xhaXJHQXpuNVB3dm9wK2Jrbnl0bnlP?=
 =?utf-8?B?Q0wzT29JUVFKMGhER3pJaU9LaUZWN1NZUlhxVFdHQ3lZSFlYVUxlRzBhUnBG?=
 =?utf-8?B?VnEwRHZxbFNYK0RMQ0hUQkR6amhNaFNwNThFbjl0SlQ0WTRMbWcwUVl6dWpS?=
 =?utf-8?B?MVhoSmZySldhMmY5VS92eGlncVljOUpMSnNUNVdEZHVFT05WUUZ3bUx4bTR5?=
 =?utf-8?B?SWJ4cE9VNkZKSmkyeUdVb2JHYy9hWXZWb0FtcHVkVWtoWjVXRVU5am1qM1Q4?=
 =?utf-8?B?VFBZZjlRN1lFYjBEY1VTR3haQytzcVNiYm1FdFBqNXYxQjltb3lSTHByT3Zt?=
 =?utf-8?B?bXhnM2xkZi9WRzYzM2l1NjJwSXpXUFE0T09QM2dSQXZtZjBPczNaOTZsbTY2?=
 =?utf-8?B?S3pSaTU3VTFDTGtHYng5bzVCOTF3bFZTelppVmkxcHM3b3BTSVhBNjVvcnlR?=
 =?utf-8?B?YXBRdzZXSm1hQkVKOFJ3ZWordEJsdDRuRTBPSVhEV3hDb0ZMRXE3bDlUTzY5?=
 =?utf-8?B?SDl2WWY0Nm5RdEVHdlFTS3hYR1dYbko1R3ZGeWg1NG9scW9mdTlrVkNVMG11?=
 =?utf-8?B?Njg5R2lUc1V0MHNEL1Z6TkdQRWpxN1B3Z1VlczI1aSs0NXc0a3BicmZrZEZB?=
 =?utf-8?B?U1FZSmFYcjdySnd0aW1QVzFhNFJtMVhpVmNUZUhub2F6am8vZWptVXRmNEpQ?=
 =?utf-8?B?aGtUcHRXWDlrWEMwa1FzVEFFWVpidnNSWlVhakhqUlBJc3QvTWFsTU1WeFdO?=
 =?utf-8?B?dTFJTXBIYlB4YjUxY1ZRRGd5RXNhOFBtMlhNaHc2U2hDYlhJTCtyanp5Q3VK?=
 =?utf-8?B?U1lzV2F4SDh3eDcvQ3oza2NFYUtsMUdSVWdDRklpY0tKM0N1bk1QVGNJWjMw?=
 =?utf-8?B?YVdyQlFVdkJERWpySkxuUGtBQzgyREZpcjV2TVBXTTFLSUFQK0RPaDZ4Yjh1?=
 =?utf-8?B?YmhySHFjdUZEa0ZPTkUyWEpjbm1QdGk5T1dEU2ZSb3hObmhIUmRXeUd6dHI5?=
 =?utf-8?B?TExmbzFIcXdiM0xIQUdybVl3S1NlVzRUM2gxNlRyM0tJaFdRd3FQUHo5VEpM?=
 =?utf-8?B?djdwZEpEdG9Wa1FzeUdJakt6dXQxM3QyVlc0VytMUEd3Y21tSU1keWkzMktm?=
 =?utf-8?B?cjd6ZWtkejkxS1lZeUovVEJsQjdFT3c4UEo5U25TTmtrclEyVnlKdElscFZ1?=
 =?utf-8?B?VnArQkgxaTRhWHBub2hKLzBxRnRQaG9sWEcrSW5Ocys0VGxLcnRwbmIwelFi?=
 =?utf-8?B?Z09RekVsdVNkdCtZMFRSMWVtVTdDeElyTnNKSWNvNUlXK1pQMDZ2eE5ScDFs?=
 =?utf-8?B?UzVZaC9aWno3UXAxUTZVR2NDM1dqekVSQW1qK2pOd3VYeWhES1JLN0dLLzd5?=
 =?utf-8?B?Wi9tanFwc1JyVzZQbzlYNkJ0MyszaHBTQm43V2trN2ZhbmI4THFFTXFrVTVZ?=
 =?utf-8?B?RitZOTFYbGViS2h3OW1ncnpLUnNJZmdFZGNaeVg3WXdhcFhma1lwQTNRNElX?=
 =?utf-8?B?NDJzQ05rSndwSEVzRGZmbXZlTzNWdUZuQmE3UVJ2M09Dc1VVaXUrc2ZIWkxS?=
 =?utf-8?B?bnAvS2M3UzRuZllnaU92bjVUQWszNTFZbThKQlJwVTg4UlNZekJURFdJMjBw?=
 =?utf-8?B?ejdvOFFMSzZxcjZQS1V3VEJUVlVmeUt5NVpKcUlxS3QvWm1wL0RMVlE4blJS?=
 =?utf-8?B?eVNPVHBhSzc2SzR4SzhnbFRpd3YxeERYM2lsTEE4RmJqOTJxa095YUxpRzNH?=
 =?utf-8?B?dThZZXFvVUtoM3pLb1hTK2lLcEQ1Q1d0Z3ZUTEUrZ0VYZjVibHhzRGhkQnZm?=
 =?utf-8?B?clE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1422A37B0C147945B41FA3A5E68FCC21@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 275214e7-b7d3-466f-9d8f-08db7d9b3a5d
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2023 21:03:05.5324
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YgOAWOJfqtaji2kDCVZJ+PInhEUnohPNI2mLv61TzmYTsctNq/0tKhc9LHMdqL4ZJvoxBhJdv7bG8EQBBk8hiIlQxImg+OL3vW6cIFY04rg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7358
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDIzLTA1LTMxIGF0IDEwOjE5ICswODAwLCBMaSBaaGlqaWFuIHdyb3RlOg0KPiBB
Y2NvcmRpbmcgdG8gdGhlIHRvb2wncyBkb2N1bWVudGF0aW9uLCB3aGVuICctbCBzdGFuZGFyZCcg
aXMNCj4gc3BlY2lmaWVkLA0KPiBsb2cgd291bGQgYmUgb3V0cHV0IHRvIHRoZSBzdGRvdXQuIEJ1
dCBzaW5jZSBpdCdzIHVzaW5nIHN0cm5jbXAoYSwgYiwNCj4gMTApDQo+IHRvIGNvbXBhcmUgdGhl
IGZvcm1lciAxMCBjaGFyYWN0ZXJzLCBpdCB3aWxsIGFsc28gd3JvbmdseSBkZXRlY3QgYQ0KPiBm
aWxlbmFtZQ0KPiBzdGFydGluZyB3aXRoIGEgc3Vic3RyaW5nICdzdGFuZGFyZCcgYXMgc3Rkb3V0
Lg0KPiANCj4gRm9yIGV4YW1wbGU6DQo+ICQgY3hsIG1vbml0b3IgLWwgc3RhbmRhcmQubG9nDQo+
IA0KPiBVc2VyIGlzIG1vc3QgbGlrZWx5IHdhbnQgdG8gc2F2ZSBsb2cgdG8gLi9zdGFuZGFyZC5s
b2cgaW5zdGVhZCBvZg0KPiBzdGRvdXQuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBMaSBaaGlqaWFu
IDxsaXpoaWppYW5AZnVqaXRzdS5jb20+DQo+IC0tLQ0KPiBWMzogSW1wcm92ZSBjb21taXQgbG9n
ICMgRGF2ZQ0KPiBWMjogY29tbWl0IGxvZyB1cGRhdGVkICMgRGF2ZQ0KPiAtLS0NCj4gwqBjeGwv
bW9uaXRvci5jIHwgMiArLQ0KPiDCoDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBk
ZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2N4bC9tb25pdG9yLmMgYi9jeGwvbW9uaXRv
ci5jDQo+IGluZGV4IGYwZTNjNGMzZjQ1Yy4uMTc5NjQ2NTYyMTg3IDEwMDY0NA0KPiAtLS0gYS9j
eGwvbW9uaXRvci5jDQo+ICsrKyBiL2N4bC9tb25pdG9yLmMNCj4gQEAgLTE4OCw3ICsxODgsNyBA
QCBpbnQgY21kX21vbml0b3IoaW50IGFyZ2MsIGNvbnN0IGNoYXIgKiphcmd2LA0KPiBzdHJ1Y3Qg
Y3hsX2N0eCAqY3R4KQ0KPiDCoMKgwqDCoMKgwqDCoMKgZWxzZQ0KPiDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoG1vbml0b3IuY3R4LmxvZ19wcmlvcml0eSA9IExPR19JTkZPOw0KPiDC
oA0KPiAtwqDCoMKgwqDCoMKgwqBpZiAoc3RybmNtcChsb2csICIuL3N0YW5kYXJkIiwgMTApID09
IDApDQo+ICvCoMKgwqDCoMKgwqDCoGlmIChzdHJjbXAobG9nLCAiLi9zdGFuZGFyZCIpID09IDAp
DQoNCkFzIG5vdGVkIGluIHBhdGNoIDEsIHRoaXMgc2hvdWxkIGp1c3QgYmUgdXNpbmcgJ3N0YW5k
YXJkJywgbm90DQonLi9zdGFuZGFyZCcuDQoNCldpdGggdGhlc2UgcGF0Y2hlcyB0aGUgYmVoYXZp
b3IgYmVjb21lczoNCg0KKiBpZiAtbCBzdGFuZGFyZCBpcyB1c2VkLCBpdCBjcmVhdGVzIGEgZmls
ZSBjYWxsZWQgc3RhbmRhcmQgaW4gdGhlIGN3ZA0KKiBpZiAtbCAuL3N0YW5kYXJkIGlzIHVzZWQs
IGl0IHVzZXMgc3Rkb3V0DQoNCkl0IHNob3VsZCBiZWhhdmUgdGhlIG9wcG9zaXRlIHdheSBmb3Ig
Ym90aCBvZiB0aG9zZSBjYXNlcy4NCg0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oG1vbml0b3IuY3R4LmxvZ19mbiA9IGxvZ19zdGFuZGFyZDsNCj4gwqDCoMKgwqDCoMKgwqDCoGVs
c2Ugew0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoG1vbml0b3IuY3R4LmxvZ19m
aWxlID0gZm9wZW4obG9nLCAiYSsiKTsNCg0K
