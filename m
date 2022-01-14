Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A962C82
	for <nvdimm@lists.linux.dev>; Fri, 14 Jan 2022 07:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642145334; x=1673681334;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Y1eDsIDjrZO0LeOpu26lzosAR7OlYcvYE1agJ4wsLQI=;
  b=Pt6WF8ox6lW/tZVbl6hvZQdwUbh9/Dah9nWzbe7QZHL64M7ulUUfOxjg
   etJ45UzmKfeB/+y/YkWy7apIvgi0cdev50iG8UVx2N1agN0A1M6QeEWAm
   9gQtChD3GQaJpn+2k9RfY9itPsoJr1I9m8/9ZAVjMZAJ9PRuuUqYZF/yW
   1juQBxCARgtFKq4aL8VTs6/ALyOdfrGm+a5Q1hW3TeCB9zUH6crGx81kg
   bQMj4JDWkE+FNRLxoyt5XmQG92Hbx6buBfFkLqjycCyudw3Tq9bYqOIv6
   2xBlYFRQaAW5QeMmnlmemmamxAknsFvpMxUxy56oxk7ug7UefTuAzCYW/
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10226"; a="268561796"
X-IronPort-AV: E=Sophos;i="5.88,287,1635231600"; 
   d="scan'208";a="268561796"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 23:28:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,287,1635231600"; 
   d="scan'208";a="692109375"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP; 13 Jan 2022 23:28:53 -0800
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 13 Jan 2022 23:28:52 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 13 Jan 2022 23:28:52 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Thu, 13 Jan 2022 23:28:52 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.47) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Thu, 13 Jan 2022 23:28:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NWZcqnqKZMPR50lj62+K7et+EZXT5VRaOmOMKLb/VWk3gL89YhUxTmPLE1I5dPUEBACB/cvvDZXRtY7Orl7y/4wWjTojIY16kBHkcXlgcTS1EK7/qYqTclRG8a/IkpU/ADyZ6olUssMnaa62GCKZk0aHTFBRqJB1qRhJP8YoxjE+G6kpGU9RRdmwUPJwHRYFhMtv47cRdbFOD51oKqpygqc/A7DGOfThNHT1HqwswMdab968dF2af3VR7aBZA90Bg5NhkbzbwawoSyy96QySg3PGJJATLFdrVLMOGtjytp3Hi9bcVhcJW+BQpghtyGqpIptI6CuEjJCA/gPz/yiQog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y1eDsIDjrZO0LeOpu26lzosAR7OlYcvYE1agJ4wsLQI=;
 b=hk9TE8L3k2HvENESbPrThycFGuJ7haZ628WeTz/VWgVHHEU0UCQjN9BXwQaFeiwzPwaR5WfqoXvyNsTYGedAf6ZZyH7BrMTCpjBpmIbRIO/JX+vphqMYZScPdGa4srHB7fskYMT7WA9mdOsfDOkCVYTfXqSCEZL8xFzFqOqgzkkBy6DU2qp3b1uoKanhUq78d5yd+ZRS8Vj9nB+O3p+P8xAa7lCq15W9NMaXYiNbAOvPz1GpJ/EXohkW4QCrH7ffUrbx+MD/cvg+agjUIS7/5+GOp9UiO+b5xDemJ60XBBZ9tZRhMbmniGRC4niVvAUwW/ORGuVSA58+mwhOqOLL9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN6PR11MB3988.namprd11.prod.outlook.com (2603:10b6:405:7c::23)
 by MW3PR11MB4748.namprd11.prod.outlook.com (2603:10b6:303:2e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Fri, 14 Jan
 2022 07:28:49 +0000
Received: from BN6PR11MB3988.namprd11.prod.outlook.com
 ([fe80::e1a7:283b:4025:328]) by BN6PR11MB3988.namprd11.prod.outlook.com
 ([fe80::e1a7:283b:4025:328%6]) with mapi id 15.20.4888.011; Fri, 14 Jan 2022
 07:28:49 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>, "Schofield, Alison"
	<alison.schofield@intel.com>, "Widawsky, Ben" <ben.widawsky@intel.com>,
	"Weiny, Ira" <ira.weiny@intel.com>
CC: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH v2 3/6] libcxl: return the partition alignment field
 in bytes
Thread-Topic: [ndctl PATCH v2 3/6] libcxl: return the partition alignment
 field in bytes
Thread-Index: AQHYB32iAejeunWAW0KYqM6//LzMPqxhJySAgAAAroCAAPnwAA==
Date: Fri, 14 Jan 2022 07:28:49 +0000
Message-ID: <bc2d0fe9bbc5b049d4abfb725e5bda5b99630be6.camel@intel.com>
References: <cover.1641965853.git.alison.schofield@intel.com>
	 <ca1821eee9f8e2372e378165d5c24bbf9161e6fe.1641965853.git.alison.schofield@intel.com>
	 <20220113163149.GA831535@alison-desk> <20220113163415.GA831585@alison-desk>
In-Reply-To: <20220113163415.GA831585@alison-desk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.42.2 (3.42.2-1.fc35) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bab69c44-7379-418b-4601-08d9d72f8217
x-ms-traffictypediagnostic: MW3PR11MB4748:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <MW3PR11MB474825CE2B93057520E2C26AC7549@MW3PR11MB4748.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: alMEBc2ogkxWs099NHXpzuezpg7u9Wfs19c1yLdypUupZQNOGWm1b/D8K8sQPmiJYaV5lm2fS27Tf9916H4ipvOTxwy4ZguSiqyxMYOycakf4IIESvbo5u1bWWo6Z7I69pes/emvfyvqx6vOgW4oFbBz4CqJkafnt0VQxMmJuinFKqjN5cS4Ozor0IK9XzGVMsAMm8wAj5GHxmjKkfpOPvgn9LwAIbXfF2PMetJscFab3CRUWUdMQqvWgEMYcFi9tyDYcCzkkavfHnj/xSO+BYgOtCAEipa6WlY3def9kjYv03oRR1Be2kpKpURGcxqNfTepylD3eL4SXaAAUW492ZCJG4WHTs+ZkrG2Ct/2t/Z+Lj+hNQ5wSrmZb1jwtWIYrcLdz/RYaevbgqT5uHEWxuWI13gs4XFyVlIVcRWAkzlNTUXnXlULdbGpR+OlGfICEqZ1W+zIduoWhHT0ymAHyDdFpuMV9egVFa4w6BUNwvjX44ymTx1BGyPbk98P1j7yKrDeFHfwWyDkPp4SM8Qtlf2F1qE33vqNDlNQX8yox8IWYR1s92qzt9ba9iPxsyKCfESFmlU4M+V71pahIvfDAk1t/bJ0rJATh28mxDY75m3I3Jd2Qaq3NC3Kh14eUmSe5hCyogtbSQikAOsCppPsokpqrGqMt7E/yI4dLF36a4dPV3rmKSlhfE60I1b+doeOZfzHlhrw+iQzgeOPxCDBfQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB3988.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(110136005)(76116006)(82960400001)(66556008)(54906003)(66946007)(2906002)(64756008)(5660300002)(91956017)(6636002)(66446008)(83380400001)(6506007)(66476007)(4326008)(316002)(2616005)(38070700005)(8676002)(8936002)(26005)(86362001)(122000001)(508600001)(71200400001)(38100700002)(6512007)(36756003)(186003)(6486002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Yy9GcU5XOE0zZWEwenEyU0tzYVVsVEdia3FBbTk1NVQzM2I1ZHUrMkRUeEgw?=
 =?utf-8?B?Rjdza2QzQXpWdmlqU0RNSyszMk1KYy9vdi9FbDhSbHdFSGw5eXU5OFFZc2lu?=
 =?utf-8?B?S0Y2akE2V2puSDdyaXMweHNQNm5wTU5FRVlnaW81QlV0NzYzMFZPMHR2RUFN?=
 =?utf-8?B?cUtwdzBiQnhacmxOZVFmL1BjOVFReVkwYUJ3OE9PbnNjSXhRcGE3WTczbVFS?=
 =?utf-8?B?Y3REVGZVNGhBYlo2R2RtZWg2b2xUamhoZ3pPODJOVElENnF6NzdUaFppbTlt?=
 =?utf-8?B?ajNUT25WTlpQa295NjA1N25YeXl6ckp5Z3oyRWZKeGFHbXdYVFZBaVVkTlRa?=
 =?utf-8?B?b3ducXJ4dVBucUl3T0xVejJGY0ZSUjlhbU9jQlRjdFh0aVhieFZ3VjBqb25Z?=
 =?utf-8?B?TEphSW5CRjVIWEJEYjhieUF5MWhUV0FTRkxQYVo0WkkvaWxJcXZlbkxZWHdv?=
 =?utf-8?B?eFAxMEMyckxSeGtXS2tNaDV5enludVByS2ZLNlZaT2puNWszeGFVeW83bkQ4?=
 =?utf-8?B?TmU0WmVvK0VoVzZ1MCt5SUVaS3FQU2xuM01UWTFoVHNoaGxPM29TaVVoTzNN?=
 =?utf-8?B?UnZCMU5tdnJwcHNBR3pmRDdMVlpjdE9NWkV2cHBBS2VYMDZzdStEeGpUdVo2?=
 =?utf-8?B?UjA0ai90cmZsZVEvTnlWTXZvSVFXUEM0bTgvRWlIMFZTYm5jT3FsbElpMTE5?=
 =?utf-8?B?bWJlZ1JIZ20wbUNGRG1jdW1NMjR3VUN6bUlwa2dLM3daYzBwdlBuT1I5YnV1?=
 =?utf-8?B?YW4vaUpKb0Nkb3VEOHJkcVVrSEZZOUh4MWVYTnIvSk9QWXBPUDlDcGRFMU9I?=
 =?utf-8?B?ZW9YbG1SQUtkNWFsbTZOUFJhdmw0Q3M0TThLVjBGM2d0dTljdEZDcDVOLzhk?=
 =?utf-8?B?bDVIZEVGalJwRVRXYU1IcXB3bVdFWTA3MFRBWDF2TWxtckdFTDRkd2oxcHky?=
 =?utf-8?B?bnZLcUJadGtUSXR3ODhObm55SEF4eWlYMnBNYUdrbjFhbERzOFkrKzR5bGtN?=
 =?utf-8?B?UG05WFo1RHZqbWE0c3JLQWllNkFhUHhzMTI5bXkvSXgwdVArWjRUOFNuV3dR?=
 =?utf-8?B?bjIyWHpCMktHbE9PNzRlb25FOEx4QjZsY3ltUC9OZmlQdCtxNHJLQnVOaXEy?=
 =?utf-8?B?YWNVclBLUjE2TmVheDFHZmw3NzB3eTNVRldsM1g2VGg4eStxeTBRYW5tbG1M?=
 =?utf-8?B?eHlCdytJSFFSaWcwL1FYUzI4ZE1GN3VUQlRDcjVpQ1dBc2xNMkNKWEpBUWo0?=
 =?utf-8?B?UHZvMjVQUFh4b2lsQkYzRGZLTmZWbmQ5RTlsdDI5WU14SCtaeldHUVVXd1dN?=
 =?utf-8?B?Vmt3N3pRYkpPMlJJSWZONGI5Vys2VFJtUnhBT2gwUnpDcU1JZy9RWlcreVhL?=
 =?utf-8?B?MUVKSzdMcmpHSEY5SU9KY25xZytmYmJ3V2NIbHd1TGFGL0Q2cnlxNThBNUNt?=
 =?utf-8?B?eTM4b2xCZFlsck9yTlBEcWFMRS8zakpQSU1YMFBMWGljRitEMkI3OVdaYTJL?=
 =?utf-8?B?a1lwbWp1cmt1c1VKRDRONmUrRGNIYnJqYndRTVJnVmZSOVhJdkJpbW03MEhn?=
 =?utf-8?B?TiswT1NIN1NCa2ZtdTJBZTJVdlY0QVdFOUhETzYzbTYrT0xnNTN3R21XcmpY?=
 =?utf-8?B?ZzFsVG11YitzQ0dPU2dPMDhDNjNpMkU2U0F0eTEzYVJpZGJmQVM5dTU3eVZV?=
 =?utf-8?B?SWxYenBndThKSk54eUppNHZQazYva2tEV0s0ME83YzFrTHRRVFNOWm82cFY0?=
 =?utf-8?B?cXZyc1JUT01MTThUbWsvYllBWld0N1A1NmxSWEQxVzlwVFUyUTQ4bmdIRXZs?=
 =?utf-8?B?eHlDdnJ0Z05CamVpQ2NrQ3pMdnBGbjFBQjhLOUd6V1RqWnpqVlM0VzkxNFdP?=
 =?utf-8?B?VUxQL2hPSURrT0JhcFdmK1RjSkJqay8vRDZ3cm9YOHJCbmRWTjNyOEZRaVNI?=
 =?utf-8?B?ZDF0ZkdTNjQzTDlzMXNYVzBydkRvY2dLS0oxVStmY3NqOVcvMGJ5K1I0ZWRO?=
 =?utf-8?B?WUkzWlZZZWdqbVVFTmpVSlNoTTY4RnQ0T1BVNzRSK2Z0OG53NmRMRFo0L3NY?=
 =?utf-8?B?TEJNS3VwRXRUUFp2SWFKbVdVZU9MaXAxUkkzSkNPRW5IKzgzNDRvN29nOElG?=
 =?utf-8?B?Q1FqeDMzVlJzQ1B3SHhGR1JhTlJHMDYraWhONURDbUJ6R3NnbDZnU1J0ZDEw?=
 =?utf-8?B?ZTgxakUvZEc5ZzdMUDZBdjhzQkN5eG5TcGR1alVySnhnNEExQlUzZnRUcFc5?=
 =?utf-8?Q?7H1WgS+RqIq2IJsKREmKUGQeV6+grou3yhVxzhT/q8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1696399DF43C1B4C81431EB73ACB4E20@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB3988.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bab69c44-7379-418b-4601-08d9d72f8217
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2022 07:28:49.4696
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EU8lXB6y443BL0oJ/dbCuyBDg62nt3pc1+cQ3FiNwMRg2CWXYaXtozeFivkmVhg55aFYDf15kCqmX3Uviyx7pDRt5kKL1Prt9Er6JRFnKjY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4748
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDIyLTAxLTEzIGF0IDA4OjM0IC0wODAwLCBBbGlzb24gU2Nob2ZpZWxkIHdyb3Rl
Og0KPiBPbiBUaHUsIEphbiAxMywgMjAyMiBhdCAwODozMTo0OUFNIC0wODAwLCBBbGlzb24gU2No
b2ZpZWxkIHdyb3RlOg0KPiA+IA0KPiA+IE9uIFR1ZSwgSmFuIDExLCAyMDIyIGF0IDEwOjMzOjMx
UE0gLTA4MDAsIGFsaXNvbi5zY2hvZmllbGRAaW50ZWwuY29tIHdyb3RlOg0KPiA+ID4gRnJvbTog
QWxpc29uIFNjaG9maWVsZCA8YWxpc29uLnNjaG9maWVsZEBpbnRlbC5jb20+DQo+ID4gPiANCj4g
PiA+IFBlciB0aGUgQ1hMIHNwZWNpZmljYXRpb24sIHRoZSBwYXJ0aXRpb24gYWxpZ25tZW50IGZp
ZWxkIHJlcG9ydHMNCj4gPiA+IHRoZSBhbGlnbm1lbnQgdmFsdWUgaW4gbXVsdGlwbGVzIG9mIDI1
Nk1CLiBJbiB0aGUgbGliY3hsIEFQSSwgdmFsdWVzDQo+ID4gPiBmb3IgYWxsIGNhcGFjaXR5IGZp
ZWxkcyBhcmUgZGVmaW5lZCB0byByZXR1cm4gYnl0ZXMuDQo+ID4gPiANCj4gPiA+IFVwZGF0ZSB0
aGUgcGFydGl0aW9uIGFsaWdubWVudCBhY2Nlc3NvciB0byByZXR1cm4gYnl0ZXMgc28gdGhhdCBp
dA0KPiA+ID4gaXMgaW4gc3luYyB3aXRoIG90aGVyIGNhcGFjaXR5IHJlbGF0ZWQgZmllbGRzLg0K
PiA+ID4gDQo+ID4gPiBSZW5hbWUgdGhlIGZ1bmN0aW9uIHRvIHJlZmxlY3QgdGhlIG5ldyByZXR1
cm4gdmFsdWU6DQo+ID4gPiBjeGxfY21kX2lkZW50aWZ5X2dldF9wYXJ0aXRpb25fYWxpZ25fYnl0
ZXMoKQ0KPiA+IA0KPiA+IFZpc2hhbCwNCj4gPiBKdXN0IHJlYWxpemVkIHRoYXQgdGhlIGN4bF9p
ZGVudGlmeV9nZXRfcGFydGl0aW9uX2FsaWduKCkgQVBJIHdhcyByZWxlYXNlZA0KPiA+IGluIG5k
Y3RsLXY3Mi4gRG9lcyB0aGF0IG1lYW4gTkFLIG9uIGNoYW5naW5nIHRoZSBuYW1lIGhlcmU/DQo+
ID4gQWxpc29uDQo+IA0KPiBUaGF0IHF1ZXN0aW9uIHdhcyBpbmNvbXBsZXRlISBEb2VzIHRoYXQg
bWVhbiBOQUsgb24gY2hhbmdpbmcgd2hhdCBpdA0KPiByZXR1cm5zIHRvbz8gIE9yIGFyZSAnd2Un
IGVhcmx5IGVub3VnaCBpbiBjeGwtY2xpIHRvIG1ha2Ugc3VjaCBhIGNoYW5nZT8NCg0KQWggeWVw
IC0gY2hhbmdpbmcgdGhlIG5hbWUgaXMgZGVmaW5pdGVseSBhIG5vIGdvLiBJIHRoaW5rIGNoYW5n
aW5nIHdoYXQNCml0IHJldHVybnMgaXMgb2theSAtIEkgc2VlIGl0IGFzIGEgYnVnIGZpeC4gVGhl
IGxlYXN0LXN1cnByaXNlIHJldHVybg0KaXMgYnl0ZXMsIGFuZCByZXR1cm5pbmcgYW55dGhpbmcg
ZWxzZSB3YXMgYSBidWcuIEx1Y2tpbHkgd2UgZG9uJ3QgbmVlZA0KdG8gY2hhbmdlIHRoZSByZXR1
cm4gdHlwZSA6KQ0KDQo+IA0KPiA+IA0KPiA+ID4gDQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBBbGlz
b24gU2Nob2ZpZWxkIDxhbGlzb24uc2Nob2ZpZWxkQGludGVsLmNvbT4NCj4gPiA+IC0tLQ0KPiA+
ID4gIGN4bC9saWIvbGliY3hsLmMgICB8IDQgKystLQ0KPiA+ID4gIGN4bC9saWIvbGliY3hsLnN5
bSB8IDIgKy0NCj4gPiA+ICBjeGwvbGliY3hsLmggICAgICAgfCAyICstDQo+ID4gPiAgMyBmaWxl
cyBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pDQo+ID4gPiANCj4gPiA+
IGRpZmYgLS1naXQgYS9jeGwvbGliL2xpYmN4bC5jIGIvY3hsL2xpYi9saWJjeGwuYw0KPiA+ID4g
aW5kZXggMWZkNTg0YS4uODIzYmNiMCAxMDA2NDQNCj4gPiA+IC0tLSBhL2N4bC9saWIvbGliY3hs
LmMNCj4gPiA+ICsrKyBiL2N4bC9saWIvbGliY3hsLmMNCj4gPiA+IEBAIC0xMDc4LDcgKzEwNzgs
NyBAQCBDWExfRVhQT1JUIGludCBjeGxfY21kX2lkZW50aWZ5X2dldF9md19yZXYoc3RydWN0IGN4
bF9jbWQgKmNtZCwgY2hhciAqZndfcmV2LA0KPiA+ID4gIAlyZXR1cm4gMDsNCj4gPiA+ICB9DQo+
ID4gPiAgDQo+ID4gPiAtQ1hMX0VYUE9SVCB1bnNpZ25lZCBsb25nIGxvbmcgY3hsX2NtZF9pZGVu
dGlmeV9nZXRfcGFydGl0aW9uX2FsaWduKA0KPiA+ID4gK0NYTF9FWFBPUlQgdW5zaWduZWQgbG9u
ZyBsb25nIGN4bF9jbWRfaWRlbnRpZnlfZ2V0X3BhcnRpdGlvbl9hbGlnbl9ieXRlcygNCj4gPiA+
ICAJCXN0cnVjdCBjeGxfY21kICpjbWQpDQo+ID4gPiAgew0KPiA+ID4gIAlzdHJ1Y3QgY3hsX2Nt
ZF9pZGVudGlmeSAqaWQgPQ0KPiA+ID4gQEAgLTEwODksNyArMTA4OSw3IEBAIENYTF9FWFBPUlQg
dW5zaWduZWQgbG9uZyBsb25nIGN4bF9jbWRfaWRlbnRpZnlfZ2V0X3BhcnRpdGlvbl9hbGlnbigN
Cj4gPiA+ICAJaWYgKGNtZC0+c3RhdHVzIDwgMCkNCj4gPiA+ICAJCXJldHVybiBjbWQtPnN0YXR1
czsNCj4gPiA+ICANCj4gPiA+IC0JcmV0dXJuIGxlNjRfdG9fY3B1KGlkLT5wYXJ0aXRpb25fYWxp
Z24pOw0KPiA+ID4gKwlyZXR1cm4gbGU2NF90b19jcHUoaWQtPnBhcnRpdGlvbl9hbGlnbikgKiBD
WExfQ0FQQUNJVFlfTVVMVElQTElFUjsNCj4gPiA+ICB9DQo+ID4gPiAgDQo+ID4gPiAgQ1hMX0VY
UE9SVCB1bnNpZ25lZCBpbnQgY3hsX2NtZF9pZGVudGlmeV9nZXRfbGFiZWxfc2l6ZShzdHJ1Y3Qg
Y3hsX2NtZCAqY21kKQ0KPiA+ID4gZGlmZiAtLWdpdCBhL2N4bC9saWIvbGliY3hsLnN5bSBiL2N4
bC9saWIvbGliY3hsLnN5bQ0KPiA+ID4gaW5kZXggYjdlOTY5Zi4uMWUyY2YwNSAxMDA2NDQNCj4g
PiA+IC0tLSBhL2N4bC9saWIvbGliY3hsLnN5bQ0KPiA+ID4gKysrIGIvY3hsL2xpYi9saWJjeGwu
c3ltDQo+ID4gPiBAQCAtMzQsNyArMzQsNyBAQCBnbG9iYWw6DQo+ID4gPiAgCWN4bF9jbWRfaWRl
bnRpZnlfZ2V0X3RvdGFsX2J5dGVzOw0KPiA+ID4gIAljeGxfY21kX2lkZW50aWZ5X2dldF92b2xh
dGlsZV9vbmx5X2J5dGVzOw0KPiA+ID4gIAljeGxfY21kX2lkZW50aWZ5X2dldF9wZXJzaXN0ZW50
X29ubHlfYnl0ZXM7DQo+ID4gPiAtCWN4bF9jbWRfaWRlbnRpZnlfZ2V0X3BhcnRpdGlvbl9hbGln
bjsNCj4gPiA+ICsJY3hsX2NtZF9pZGVudGlmeV9nZXRfcGFydGl0aW9uX2FsaWduX2J5dGVzOw0K
PiA+ID4gIAljeGxfY21kX2lkZW50aWZ5X2dldF9sYWJlbF9zaXplOw0KPiA+ID4gIAljeGxfY21k
X25ld19nZXRfaGVhbHRoX2luZm87DQo+ID4gPiAgCWN4bF9jbWRfaGVhbHRoX2luZm9fZ2V0X21h
aW50ZW5hbmNlX25lZWRlZDsNCj4gPiA+IGRpZmYgLS1naXQgYS9jeGwvbGliY3hsLmggYi9jeGwv
bGliY3hsLmgNCj4gPiA+IGluZGV4IDQ2Zjk5ZmIuLmYxOWVkNGYgMTAwNjQ0DQo+ID4gPiAtLS0g
YS9jeGwvbGliY3hsLmgNCj4gPiA+ICsrKyBiL2N4bC9saWJjeGwuaA0KPiA+ID4gQEAgLTcxLDcg
KzcxLDcgQEAgaW50IGN4bF9jbWRfaWRlbnRpZnlfZ2V0X2Z3X3JldihzdHJ1Y3QgY3hsX2NtZCAq
Y21kLCBjaGFyICpmd19yZXYsIGludCBmd19sZW4pOw0KPiA+ID4gIHVuc2lnbmVkIGxvbmcgbG9u
ZyBjeGxfY21kX2lkZW50aWZ5X2dldF90b3RhbF9ieXRlcyhzdHJ1Y3QgY3hsX2NtZCAqY21kKTsN
Cj4gPiA+ICB1bnNpZ25lZCBsb25nIGxvbmcgY3hsX2NtZF9pZGVudGlmeV9nZXRfdm9sYXRpbGVf
b25seV9ieXRlcyhzdHJ1Y3QgY3hsX2NtZCAqY21kKTsNCj4gPiA+ICB1bnNpZ25lZCBsb25nIGxv
bmcgY3hsX2NtZF9pZGVudGlmeV9nZXRfcGVyc2lzdGVudF9vbmx5X2J5dGVzKHN0cnVjdCBjeGxf
Y21kICpjbWQpOw0KPiA+ID4gLXVuc2lnbmVkIGxvbmcgbG9uZyBjeGxfY21kX2lkZW50aWZ5X2dl
dF9wYXJ0aXRpb25fYWxpZ24oc3RydWN0IGN4bF9jbWQgKmNtZCk7DQo+ID4gPiArdW5zaWduZWQg
bG9uZyBsb25nIGN4bF9jbWRfaWRlbnRpZnlfZ2V0X3BhcnRpdGlvbl9hbGlnbl9ieXRlcyhzdHJ1
Y3QgY3hsX2NtZCAqY21kKTsNCj4gPiA+ICB1bnNpZ25lZCBpbnQgY3hsX2NtZF9pZGVudGlmeV9n
ZXRfbGFiZWxfc2l6ZShzdHJ1Y3QgY3hsX2NtZCAqY21kKTsNCj4gPiA+ICBzdHJ1Y3QgY3hsX2Nt
ZCAqY3hsX2NtZF9uZXdfZ2V0X2hlYWx0aF9pbmZvKHN0cnVjdCBjeGxfbWVtZGV2ICptZW1kZXYp
Ow0KPiA+ID4gIGludCBjeGxfY21kX2hlYWx0aF9pbmZvX2dldF9tYWludGVuYW5jZV9uZWVkZWQo
c3RydWN0IGN4bF9jbWQgKmNtZCk7DQo+ID4gPiAtLSANCj4gPiA+IDIuMzEuMQ0KPiA+ID4gDQo+
ID4gDQo+IA0KDQo=
