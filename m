Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 959992C80
	for <nvdimm@lists.linux.dev>; Wed, 17 Nov 2021 23:17:53 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10171"; a="257850530"
X-IronPort-AV: E=Sophos;i="5.87,243,1631602800"; 
   d="scan'208";a="257850530"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2021 15:17:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,243,1631602800"; 
   d="scan'208";a="672570024"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga005.jf.intel.com with ESMTP; 17 Nov 2021 15:17:52 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 17 Nov 2021 15:17:52 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 17 Nov 2021 15:17:52 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 17 Nov 2021 15:17:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JNUslRi9n9dhHNZNf3Qau3gSxS8K//8GbGpRbNBxSQxoqER5sPqIQ+ZQtiZag5qwOavbXQrrlopnZ5ctpLv8UiGh57NfITFaoBC4Zn1UaB2vDoSQt7Ulj8nr/SyjT98KE6V0fE4a842YBsfDreyMuPrGfzNoQFDdWd9F1kDyaDF+ezYQtuWt16fGzxDtgzmMVjO+GL1GWVs1488SP2wc5GHwcR8T5UwkMpTQ4CzPKoLogT+28ruik0zvLdFWKHrIOZDp6LnL0Ftwi/Fs7QoptpHU4r9aXEXSRHR3zDLk2jd00aV4khnxVA15xGX2auLkMhZUJ1nUgwH0INKOj1LRjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AJ63+BwvwVoYUMutdBMLSDRz0g8/dFGG4Nq8Bojp1qA=;
 b=mK9U+hxiCSb8kPZjyi0xQM+Ntw58gWEa/i2bPk5J1haR1SdKaQT7re5oUO2gtj4pz6gemXbZSwO5QTWqpBYXmYKOCIVOyzBbVfTByXwfuJnTDdxn7vVMXaiH9qaLGRiFlqb8KflledUlwIYDqnD+GenxvcrNi74MO3mgVGPjYJG1G/AqtL8TIE9vLN5KPoQW/SFHVDNPjEWLfmzbWCMbEG2JREDD/b2tyWt7wIR4/gUxHcNlCoudzYidNa2ML8A4Gw1j02Dp8b40En/4IIoED13S0LaedwvB0Tqxjg4b+XF277lG67M/ROuoW8J0504ax724oK/lZ7Iz16tFPB4siA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AJ63+BwvwVoYUMutdBMLSDRz0g8/dFGG4Nq8Bojp1qA=;
 b=EhkkfJ7ufs8cSyuMA5wN9UBufa9NeXNiTURI3fbAopKv46viAjzeThs4YE2PrV+//eQSbyoz66iWzdXvpW7HCnVsuZ5jvnzjRPJUTuLSo+9lAoXRBQ9aKafpoywu40hdNcX7D7eYCBLFQc3AL0WYtErz5IZpU7TJWMXinrh4/3M=
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by MN2PR11MB4045.namprd11.prod.outlook.com (2603:10b6:208:135::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Wed, 17 Nov
 2021 23:17:50 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::d8a5:47b2:8750:11df]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::d8a5:47b2:8750:11df%7]) with mapi id 15.20.4690.027; Wed, 17 Nov 2021
 23:17:50 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "qi.fuli@fujitsu.com"
	<qi.fuli@fujitsu.com>, "Hu, Fenghua" <fenghua.hu@intel.com>,
	"qi.fuli@jp.fujitsu.com" <qi.fuli@jp.fujitsu.com>
Subject: Re: [ndctl PATCH 4/7] daxctl: add basic config parsing support
Thread-Topic: [ndctl PATCH 4/7] daxctl: add basic config parsing support
Thread-Index: AQHXnkdSurFOFQYzVUOEBwQZzW90MaunYEsAgGF10oA=
Date: Wed, 17 Nov 2021 23:17:50 +0000
Message-ID: <f4a643b9bf5c09844e2c2c541d6fca0ff3c19e55.camel@intel.com>
References: <20210831090459.2306727-1-vishal.l.verma@intel.com>
	 <20210831090459.2306727-5-vishal.l.verma@intel.com>
	 <CAPcyv4iFJrCCVzV66dNjzP_tF1Soq9UGyT36QdWxm-pWwVjZGg@mail.gmail.com>
In-Reply-To: <CAPcyv4iFJrCCVzV66dNjzP_tF1Soq9UGyT36QdWxm-pWwVjZGg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.40.4 (3.40.4-1.fc34) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fcf872fe-9395-4672-d3b4-08d9aa20796e
x-ms-traffictypediagnostic: MN2PR11MB4045:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <MN2PR11MB4045A179BCF4AD21A1FA77DCC79A9@MN2PR11MB4045.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zpAkaKzVJd88VgJCJjqge54NWMW7yBTFdrBICXi22z66TLp15NPmVtk1AH4xz3VcyflXrne1czsM+crfP8nixYVQ6rZDfWPwSCeTk1o2UmtJ1pNe9BxiutNqiYDowNdf9CUn0J+tHvSjNdXCW7+Tox7PXPgcmre/WToSwm++KSHIvHGK+YiVJOprb3N7RiIR1dPwSoAwNriZu0mkY9C9U3t2FGJQuW9e6PgF/Iga3O2wo+CzR8kZ3dhNpNngYkl5W74r/dqhHXG+75JNwHlxfacVvYmziTpjMTHMEqZzCwAR6HcZC1Mc2pkPxH9wqZUy/feeLXnG/LFci1DI1/KQchw/HYOa8cmbFODzaZXjsPyU8TgNxrEqSLvvmxWoLxUAIDccTNvbKjQD6JbnWiYyuOAKjYjQrJYy3wJgoaq0t0c91WyMK3tbCfGk/OuhtRFnZPJBQWBK1QS5av/Wv9tTeU1Vz9I28Zm9dkHnPq4W5g1jVtQauKvplr5hnz+TkWi/lmEcqVV+IwUUQK19go8i7BBjFx6BoNNVbVIAqTBRnDHA6N6SlwD7trcNM20Y/RbNL4wytQYmcTaamlj8ZB+ZPrzXH4VXv0uSDCa5xyofO0lHbn9AAoBrc5n3dxt/HdlT0384pbsqHGsHJVjH10rXTFCIRvPDpGhhw5vQQXQriyd59pA3jyIrFeh5OE6zExQiUbZIeJ5+HiXc9JPUQK5zaw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(71200400001)(2616005)(86362001)(53546011)(37006003)(8676002)(26005)(6512007)(54906003)(36756003)(2906002)(5660300002)(6506007)(6636002)(66946007)(64756008)(6486002)(66556008)(122000001)(82960400001)(316002)(66446008)(8936002)(186003)(76116006)(508600001)(91956017)(38070700005)(6862004)(38100700002)(4326008)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SVJtL0NRWnNTL3VqUk1rZkFNWjg0bDhubWRDRThUeXNzMlppN0ZsajBNR1FZ?=
 =?utf-8?B?NWZEaVpYL0ZYMTlIZlJ6RnRORFhHZ3g5VXZNZ2lCVCt6TWpuRmJRVzZUKzhJ?=
 =?utf-8?B?eW5XSmlUUi9vUWgyN2srTVdqaUR1UkhIZGh0YzN3d2NJbUtxdFlUS0JnVHN6?=
 =?utf-8?B?NGJFNDhXcXdNMmx4Q3hFczVYZzQrMTB5R3pqRXdEdFJqQVFJR0gzRWRSTEdk?=
 =?utf-8?B?N2UyU2xPeFBtNnhwM1VpcjN0MEt4eTFybDhuWEpMdW1RTndORlY2WFVFVmV6?=
 =?utf-8?B?ZkNEeGUza29kT2dTaVNibWIxNEpuckZpZ1gzVEwrcnNMM0ZGYUFQM09UdGts?=
 =?utf-8?B?dklvS0I5eXAxWnBCVUR3ais4bE1UVGVxdlFEYmkwRXBoRHYzbW5YZ2JwK1NI?=
 =?utf-8?B?V1IvR3FKcElEME9MaE9sWDl6aGN2U2Rjc1dOcU4vV2FZcnZodUpsVXFzS282?=
 =?utf-8?B?ZkhOaEJSK0xQWU5veEROR1pNbS9zY0N4MWhGc2U2VGN3QndkQUNGRVNJYmx1?=
 =?utf-8?B?dmNjbm9kSW5TSE1oamQ1bFhkWE5lY3hWbFB4enUvWUxOdEtucEFkQVNBRjRk?=
 =?utf-8?B?SElUUURQQ0g1TnR1ZTRHNUNXenYxZ3NvZzFPTlZGUGdlQVhYREU5U3dtNm1m?=
 =?utf-8?B?eFZHM1B5SmJnbHB1QStlQ1c5UWFHU2dyVDJYTS9oaVlZUWgydHJIT3VwYi90?=
 =?utf-8?B?OWZCYWdEVWtiS3pxTFk5V3VUOWpRY3dDVVQvVU55dlhuK1hVS0JZZXNTNXQ2?=
 =?utf-8?B?UTREU1l3bXRjL0hucVQ0eVlmWS80ekRsSUZCMDl4TlBlNFZVRGxzbzQwWGtO?=
 =?utf-8?B?MDl6dmE3THpNVVB4aHZ1QytMZTZTeFdtTUVmOVpOTk8vRDN2Q24xRWZJNElk?=
 =?utf-8?B?ekd5Z0JRaVNScHY2Z0NXYzgzcGxsMjNySTRmbDRBWXUwSVRzRnJHL1hnRFJH?=
 =?utf-8?B?bHArRWkzc09Qb09zdVZhaVBTTk81RkVWVjhJVjBMRFlTRjZOY3ZjSG9oakVa?=
 =?utf-8?B?U0dLeXBvVmVHSHUyUmNuSlBjOWhpdUh4OSswNHplZHpkcVUvTUR4ZjliQjRw?=
 =?utf-8?B?cU5CV1hrS1p4b0hvZklVVGtlL0tLT0xlcm1SYWwvcEJuQS83TFBXRVFNTWor?=
 =?utf-8?B?M0NEZVJQUjhreDRMTFV3Z1dVbW0yVW90dlhiZ1ZKVkpPaXlXRVFLa3F0Nk5L?=
 =?utf-8?B?NVNyYzR4L2RZSWtyL3k5QjNwaDA5Sjl1cVNQd280V1JSc3VsYjBHMmpvMGlX?=
 =?utf-8?B?L3VyUGZJWlIyditwdTAyMEFSMDVjZWZpQS9SNHlnQ0VmMjFXdkFlVEJpY3Zw?=
 =?utf-8?B?NGd0QTZvK0hiK21MY0tjWjRrMjkwM1RxWk9SSkZremIzZkpMelNlRXN6MEht?=
 =?utf-8?B?NHdkMmM2a3k3bGZRTHRSTFVCQndxZEpIZkxEajhVZVFiZWFxSTJUaVRnVUk3?=
 =?utf-8?B?c3V1dmJNUDFVTEtwOHVaS2VNUEk0eEtUZWlkV2RmUk9wVi9PZDNSbXJNeVYz?=
 =?utf-8?B?YSt4Q2tGOFpFaFk1cHpmQ20wZTZKTWh4YXl6ODBwa0RYcy93bzVVMXorVjVX?=
 =?utf-8?B?MzVhUm1CWEhFS09BbVN6YWhDOFZlZlVmcnM2SUhDenNNaHVRMitQTEQvVzJq?=
 =?utf-8?B?SGNmR3lRRDZaVGdmaXk5bG5pR0JiSnRNSXZNOWdjSkx5WWhQSERBSmk5MlpG?=
 =?utf-8?B?K2pYZkZ5c2R2Zm1DVGVTbFU2M2VWaTJibUlLcWhuU0ZDRytVWlY0VjBkUk4y?=
 =?utf-8?B?S0xCU3hFRzhHbHNLNnc5VC9oalZVQUhBUjcxVDd6OUJwVStTM0xYenUrdHRa?=
 =?utf-8?B?Sm9mU0lrVjJ6OHJUTklkSEJCQnI1YVdhSk4xcXA2Ukk2ZFBjU2FDdytCQW9R?=
 =?utf-8?B?c2szMys0QjBpQm5UdEFabVgvUTRuS29TUVVrbTZGQkhrTys3bWFDY3VucHg4?=
 =?utf-8?B?L3NxYzBubythOUdZWmVPSUY4NkljMFlRaUVieVBnb2wydVRVbVRWZms5cUpq?=
 =?utf-8?B?OTU0NmdRUTJDQWIrNUg3U0l4U1VUUmtQSU16YmxBRzFOZzhheTFucm9mb0E1?=
 =?utf-8?B?WWFIeVJCYVpvZloxdW5CT2J6d21wbkdPbE96WkZScW1Nay9xcVFlbFFQbWFK?=
 =?utf-8?B?QXVQOWJrQko2WmZNeVRyQnpWZlRIMU5tWG9HN0FNMjI1eGxSSlVRWnhWYWJk?=
 =?utf-8?B?THJDRzdBRXQ2RnBOYlFTZGpNTHcyRjRWN0JYQW5CZm9oQlZhYm9iSXlSajZq?=
 =?utf-8?Q?bzFkWZyUXQnABweDUFs90RIHNvbCnZO6CLgKom3T2M=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F548E18BC3EF0C4BA4555D848C635C64@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcf872fe-9395-4672-d3b4-08d9aa20796e
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2021 23:17:50.0738
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dOjZNE92JdHRBXAEN6uN7nZcezPgx/W8eqbBTOxa+h7WDj9Hor1VXYz3P1iTEN1Ud381ON2cHlMfUqW4nMXPlD3rM23lbqWUUYUVIWAPKjs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4045
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDIxLTA5LTE2IGF0IDE1OjU4IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIFR1ZSwgQXVnIDMxLCAyMDIxIGF0IDI6MDUgQU0gVmlzaGFsIFZlcm1hIDx2aXNoYWwubC52
ZXJtYUBpbnRlbC5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IEFkZCBzdXBwb3J0IHNpbWlsYXIgdG8g
bmRjdGwgYW5kIGxpYm5kY3RsIGZvciBwYXJzaW5nIGNvbmZpZyBmaWxlcy4gVGhpcw0KPiA+IGFs
bG93cyBzdG9yaW5nIGEgY29uZmlnIGZpbGUgcGF0aC9saXN0IGluIHRoZSBkYXhjdGxfY3R4LCBh
bmQgYWRkcyBBUElzDQo+ID4gZm9yIHNldHRpbmcgYW5kIHJldHJpZXZpbmcgaXQuDQo+ID4gDQo+
ID4gQ2M6IFFJIEZ1bGkgPHFpLmZ1bGlAZnVqaXRzdS5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTog
VmlzaGFsIFZlcm1hIDx2aXNoYWwubC52ZXJtYUBpbnRlbC5jb20+DQo+ID4gLS0tDQo+ID4gIGRh
eGN0bC9saWIvbGliZGF4Y3RsLmMgICB8IDM3ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysNCj4gPiAgZGF4Y3RsL2xpYmRheGN0bC5oICAgICAgIHwgIDIgKysNCj4gPiAgZGF4
Y3RsL01ha2VmaWxlLmFtICAgICAgIHwgIDEgKw0KPiA+ICBkYXhjdGwvbGliL01ha2VmaWxlLmFt
ICAgfCAgNCArKysrDQo+ID4gIGRheGN0bC9saWIvbGliZGF4Y3RsLnN5bSB8ICAyICsrDQo+ID4g
IDUgZmlsZXMgY2hhbmdlZCwgNDYgaW5zZXJ0aW9ucygrKQ0KPiA+IA0KW3NuaXBdDQo+ID4gDQo+
ID4gZGlmZiAtLWdpdCBhL2RheGN0bC9NYWtlZmlsZS5hbSBiL2RheGN0bC9NYWtlZmlsZS5hbQ0K
PiA+IGluZGV4IDliMTMxM2EuLmE5ODQ1YTAgMTAwNjQ0DQo+ID4gLS0tIGEvZGF4Y3RsL01ha2Vm
aWxlLmFtDQo+ID4gKysrIGIvZGF4Y3RsL01ha2VmaWxlLmFtDQo+ID4gQEAgLTEwLDYgKzEwLDcg
QEAgY29uZmlnLmg6ICQoc3JjZGlyKS9NYWtlZmlsZS5hbQ0KPiA+ICAgICAgICAgICAgICAgICAi
JChkYXhjdGxfbW9kcHJvYmVfZGF0YWRpcikvJChkYXhjdGxfbW9kcHJvYmVfZGF0YSkiJyA+PiRA
ICYmIFwNCj4gPiAgICAgICAgIGVjaG8gJyNkZWZpbmUgREFYQ1RMX01PRFBST0JFX0lOU1RBTEwg
XA0KPiA+ICAgICAgICAgICAgICAgICAiJChzeXNjb25mZGlyKS9tb2Rwcm9iZS5kLyQoZGF4Y3Rs
X21vZHByb2JlX2RhdGEpIicgPj4kQA0KPiA+ICsgICAgICAgJChBTV9WX0dFTikgZWNobyAnI2Rl
ZmluZSBEQVhDVExfQ09ORl9ESVIgICIkKG5kY3RsX2NvbmZkaXIpIicgPj4kQA0KPiANCj4gVGhp
cyBnZXRzIGJhY2sgdG8gbXkgbmFtZXNwYWNlIHF1ZXN0aW9uIGFib3V0IGNvbGxpc2lvbnMgYmV0
d2Vlbg0KPiBkYXhjdGwsIG5kY3RsLCBhbmQgY3hsLWNsaSBjb25mIHNuaXBwZXRzLiBJIHRoaW5r
IHRoZXkgc2hvdWxkIGVhY2ggZ2V0DQo+IHRoZWlyIG93biBkaXJlY3RvcnkgaW4gL2V0YywgdGhl
biB3ZSBkb24ndCBuZWVkIHRvIGVuY29kZSBhbnkgcHJlZml4ZXMNCj4gaW50byBzZWN0aW9uIG5h
bWVzLiBXaGF0IGRvIHlvdSB0aGluaz8NCg0KWWVwIHNwbGl0dGluZyBjb25maWcgZGlyZWN0b3Jp
ZXMgc291bmRzIGNsZWFuZXIgLSBJJ2xsIGNoYW5nZSB0aGlzLg0KDQo=
