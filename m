Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03EB44350
	for <nvdimm@lists.linux.dev>; Mon,  7 Mar 2022 21:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646689441; x=1678225441;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=KBt8NKLdh1kGLFDGyGpm588sJYJHRQdNziNfSl2iplI=;
  b=fQNnc1mE+vkhDfmLNlOslnLy+9bajk6PEUqtQhxmo1ge9teOdGvdyEuJ
   dnhzeIlbfwSZ1tSNH21H2bUFLNKKzMe3TWttAYLO1wRNUMQ8xmc+buKlo
   /7qTCXsPtJdcLH+dYIqKF/MFhh+VqD5yp5lvn7D3+2shO+1NLd9Gj/eiy
   0wry5/FWNfeUqlclwkqmhlfOAQrqnjw0Md88DOKmT26QC2H+LAcVXCOQo
   1ZM8crTOECwqfzXFZ9i6bdIEiZgtipq8erMzJ0sDWU9wri36f/+jq2l+q
   YFH2VHFxs7zRk48dLAG3Z183wt1FvgRP4DPavL2Q1aLUMhkrywg4VxDcb
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10279"; a="254453824"
X-IronPort-AV: E=Sophos;i="5.90,163,1643702400"; 
   d="scan'208";a="254453824"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 13:44:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,163,1643702400"; 
   d="scan'208";a="643408232"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga004.jf.intel.com with ESMTP; 07 Mar 2022 13:44:00 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 7 Mar 2022 13:43:59 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Mon, 7 Mar 2022 13:43:59 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Mon, 7 Mar 2022 13:43:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kSoi98pB1/2IEm3qj0Ufhe0r73MjxiHx6WVSKHLdMVGWK76vAe6etqpY0tEtwRL00Q77BbbQkyw2tDDcfthroU8Fgn9SWFhtI67snxa3ZpRAkfLbMDSzc/WRD70g0ogo+gQ/NL9+Nj8qg+m8yhAqsRIoHMZMzeO91hWBDJgTW7JrsrAuGWQevAgJ7IwjMko0mrEENP0FKyDqj7uwScT3C+qJJ5yBL6tt5nE2x+IzsH6bVoZ4i0OGFmI0k9u4a4lC++TemLFHtUxQ/52CijtEdLFaTOExHAK03O5NBOON1IJVH55n4CYCeX280dGuEvhBNia4flXnr/oKn6J1pCS5fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KBt8NKLdh1kGLFDGyGpm588sJYJHRQdNziNfSl2iplI=;
 b=nlkr+bcT2awzDI3vmbCzoEFKfCDhlf+YpfFiwNso/SOIDa5h96LTfzhA1EkxoZ2g1BM9hpUYFb8gWm7zmKFSmxaBQ2C58S1niNy5RUQEcsxUEnla7lEg4s7xiT8uFWbA35D0jXVvTc6MrLK+iXf9nplNIbb+9e9cup8/CaWmWct7vOrEu/E3svrSFeWYA4fJPPsvPWZg7ySMbaJT6iaqzlRZqOMWHeM3bo5UalmNwqZ9oZ1Ym4dg28REikJLnXtmQ+KoxPABv+YQJTRMgGME4w43ebVNf7rSbNR1ZnJsBYlDUnkDG8NpnKy/AczSYdfJPaJ6mhMKrSubuZoSMtad/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by CO1PR11MB4865.namprd11.prod.outlook.com (2603:10b6:303:9c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Mon, 7 Mar
 2022 21:43:56 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::d898:84ee:d6a:4eb1]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::d898:84ee:d6a:4eb1%6]) with mapi id 15.20.5038.027; Mon, 7 Mar 2022
 21:43:56 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH] scripts/docsurgeon: Fix document header for section
 1 man pages
Thread-Topic: [ndctl PATCH] scripts/docsurgeon: Fix document header for
 section 1 man pages
Thread-Index: AQHYMANqX4JGlPIcKE+IcM2cTYa6gay0V6cAgAAhLwA=
Date: Mon, 7 Mar 2022 21:43:56 +0000
Message-ID: <7f1652c3f82b76c71907985fc359be4b9ae67195.camel@intel.com>
References: <20220304200643.1626110-1-vishal.l.verma@intel.com>
	 <CAPcyv4hLnbEfg=1kQ5WZ6-4OpG5s+Amrc7nJCa+amgYWJKX0yA@mail.gmail.com>
In-Reply-To: <CAPcyv4hLnbEfg=1kQ5WZ6-4OpG5s+Amrc7nJCa+amgYWJKX0yA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.42.4 (3.42.4-1.fc35) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 20cdc141-2bc2-4f4d-9c71-08da008394f9
x-ms-traffictypediagnostic: CO1PR11MB4865:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <CO1PR11MB48650B6E8D0534B4F230BED2C7089@CO1PR11MB4865.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UiPHAkbpLCNHSGgtgAyeOlK5BBhPU76graH5cJJBfKeDiqRSQ9WFM6uIWdlVxfzBrhI87IkqviJu3YrC5AAjodCL+RUNEeoJwKMGmDTuHDTSClT5WvdhRyt8uijHXg0PYxMhTWN0XO03uV86JDAx3C/JTkuhOkrEpAH2AMEHEimg+oam/0660iSqZbANdWd3o8FEb4g2V4FMVJbBFZemI9RMkKN61peUY0uxauoBiJ+PUFIEAkh9Q0JhBJ/v2kV9ciEKF95K3xL2W6KNRpuVd0M9tFD1RaglcLmKrFcBR1Q1robSCSzncHm9GlgMyWburnPg/b6mwUN5Vy+vNyWlvGe6upG4oHBGnuAs0oGrGcRv4h5xR0vBK620gBap48HhyVZPLgnqb5Ufq26Y7u+YzUnRU9AZZHvfkhI/ubKG1ZTgWD4zm2NsCvf5miakrnxvzWeH1JF6XorI3d31b/+dneZSRDEmScu+o25ac+vAn0h77CG2O41aSdrOGiB+os/I52pQivolZPxKsgTkXHz50JcR1T0jd2ulTNarGRxqp0zxORXKv2/HpKgpxF3wQR+NsNSIbQyD3UEpd4JlsgArcP99IqdheACutr9/F34MHi0wAtiFNf5j1Lkt6bzKOrqqSzuGuDSCynF6cata7/o/+o9lErNm+mvgF3Ym/Zg1pOW28BdzGxkqTmgJsblhshrXB5ZS1/TJjh3ntfKi8paUIQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6636002)(37006003)(186003)(26005)(2616005)(508600001)(6486002)(6512007)(6506007)(53546011)(71200400001)(86362001)(38070700005)(122000001)(38100700002)(316002)(83380400001)(82960400001)(36756003)(2906002)(4326008)(6862004)(66946007)(76116006)(91956017)(64756008)(66446008)(66556008)(8936002)(8676002)(66476007)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MUlxWGtuMHF2cFlsdGRPdGhxNWFwdkVGVTNZODlKdDdrSmlxQXdBZnJxOUR4?=
 =?utf-8?B?b05UOWZyY2NEWkVCK2l3bFYvT2JkeWlrNjFCYkpveXVtOGJWczlJMXpXZ0U5?=
 =?utf-8?B?V0J3dFB2YjdaeEtwcUwxcG96bW5qcnh6TmNjaTQxUE9JQXlSMFlOVEd3NlFu?=
 =?utf-8?B?QTV4b3J0a3czWVU5RTRmMDJkdU5aRkxnTlp6UFlCUGQ5Z0R4NDcrSzBiQXE4?=
 =?utf-8?B?eG8wUmVURzg5bGJINGFGSW9OZXVERTFTSHhaNG5WaHgvSHl0T210QlNybHl3?=
 =?utf-8?B?N0lrVGl5U2pScUdUM1BNZFgwK0RndVNwWjk1NVpvN25ETTJvSExwS21aN1gr?=
 =?utf-8?B?d0lZcXNwQ1BkVUNMMFMwZktGSHhnU3dlcWhUMUpRMUdSSUVEcmRkN3Y0Z2pV?=
 =?utf-8?B?VS92M09tc2FXaGpXODEwZHdNNHp4MklGU21rdkpucmhzaEhoNmF5UFRuVGg5?=
 =?utf-8?B?QUsrZUlSWEhVdGtEdDhSTFdoZk91d1FXTUxubTVZbDdoT0RVWkZHZzFmRlVp?=
 =?utf-8?B?YzVGR1NzRjJUa1A5dE12ZEE2Z0pwdE9xV1paZXZqSWdhLzMwdDVNWkdjY2Rn?=
 =?utf-8?B?WWRmRjBIdzJSb0draGFlRk0vMlJxelB2YUJaMnhqSW9jVkVOSHhVR0F2K0Ry?=
 =?utf-8?B?RmZ2eEFZaDJnd0FoYkJyWHpXVTNCanc2cld4S1JUMitxMi9yQWRJRmdpRmVq?=
 =?utf-8?B?c0R0dDdRUGorb1Z1UFF3MTBad3JSZjhyZFc1cHZKczFlVFBxdFBUSkVuMVk5?=
 =?utf-8?B?bk1NRU1Jcy9XSFZkc1hUaDVKYXN1QXlTTnpCeW5zMWhDMXFZNWYxUXRzRUtC?=
 =?utf-8?B?Zit2Nk8rSDBwN3dETERMNW90SXBhWGxMak5uUC8vZTFpbENXVkFLaS9xVWxw?=
 =?utf-8?B?bGlpK01taHhLbDFYVFF5QlFLaHFhZ0RxQmtPSlNSUkdRM1ptK2ZBcjlNZjlT?=
 =?utf-8?B?SjZXRUdWK010TnNDcFVlYlR1S0puTTVJbE1LVzh6cU1qY1BFR0g3T0Rvc3JW?=
 =?utf-8?B?NUNubzcyZ1hoOVloWHJYcm5LcjRsUTFMM2UvUWllYnJxWjVDem1KOWRFWm81?=
 =?utf-8?B?SGJzYUd1TjFtMXdOQnBSdElnZ083TUg3aEZqN0hvM09vVnM5Y2tCSEh2ZTZr?=
 =?utf-8?B?NngzVjkzdXlFWWR0NUJDVk1Ba0pnRi80NkFGYTFyZmhUWlZOUFJ3Vm0wZlFG?=
 =?utf-8?B?TkdhenlLcmxwVEQ1SmRQdUNSbDFYN1VuZkEwSElibVYwY0Z4WlRubkhFbjhz?=
 =?utf-8?B?di9TbVFJREVPTE5TaSs1anNNM1BBemk5Uy9pSnFXWXNPVEpzdjZFSFlGYkt2?=
 =?utf-8?B?bGNmaWFXb2d0bVBZUmM2SXdIQmoyNnVyQ28vMkJpWWVyOFJHQUM2eTRVcGcx?=
 =?utf-8?B?clcvdHZZdms5UzBSQmhtcHg3RnI0a3hJeW8xaWUrUkx2Zy91bXRIZGJtVHJV?=
 =?utf-8?B?S05vcHQ5d053c3hMVmltSEtSMUMwWW85ZC8vakZpRkdDRW92SXk2K051QUJs?=
 =?utf-8?B?c0QxK2tnM09wWDRGNEpweHN2VkMweGZrSDVuLzZjVFRaSHJ0VDFvajdFTFRh?=
 =?utf-8?B?WURjU0x2OFJVci9YbHBwRlVSZWFpWmdsMk5kMmoxLzNGR2luenRQejlFUXo2?=
 =?utf-8?B?a2k2bTF0SXk0Z0RDZjZWRFdoWnpQaFlQRU1iWDR5dDl6OFFEUGI2T2dodE1B?=
 =?utf-8?B?c2RIWWpIdkErRDBPWkFGOGdka2RKSlN2KzFSa3ZzbElHUUZSQlVKYm9VQ05L?=
 =?utf-8?B?QTkxVnM4MnpkV2VPYmhZU0Z2OU5xQ2VIdzN3Q1dIaEk5anc3TGJTNDE1cnFY?=
 =?utf-8?B?R2F6d1ZhTTZsWXhTelp2YS9uOVJqNm93TUc5VVlKWERoRUFBTEJ3c213UjAr?=
 =?utf-8?B?aThzSU5Ib3h3THlUK21ocEtUQlJCMFkyeHVNTXhuRGlBZjkvdldkMlhpdXph?=
 =?utf-8?B?aXNOVCt4MXB5azJMQXBaNmVyMTdnOVYvNnBHZk9zZXpyc3krUlBmcmdLUDRq?=
 =?utf-8?B?OTJvRlVtU0VVbVU2RTZQTGZienVMREhZYUZOSlE4NUwzMUdjcnFlQ09iZTB1?=
 =?utf-8?B?OWtuWlJ1NThzVVEwK0gxMiszV3o0SmEwR0xOcWZ3K1BZbVhaS3lOTWNSTVhH?=
 =?utf-8?B?MFF0ZXBtQ21lVkFSVVl5YmpyY3JEbngwK1VuM0ZEa2FOdHE0MDdlZGh2YTAw?=
 =?utf-8?B?emdKQnVPanZYUW9iL1pVS1NweWdPWW1ZdXBqT0FndHRmZDBGZkQ0bkY1Uy96?=
 =?utf-8?Q?Z44x8JlTAgjRq8Pr1yA5SuQewzBf93zk68PvdtuFRE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DABAF65406B8924FB94749202A8AFD36@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20cdc141-2bc2-4f4d-9c71-08da008394f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2022 21:43:56.5511
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fdl8imMW0VIfG4yyL8tFkkPLT5o9taX/Pz87teFzoW0tVksKDOq8hHXdjPkY/4A4owbtxe4Ouk7YqYDuUerPi3CCgN1MDnxqO2n5djcUDFQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4865
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDIyLTAzLTA3IGF0IDExOjQ1IC0wODAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIEZyaSwgTWFyIDQsIDIwMjIgYXQgMTI6MDcgUE0gVmlzaGFsIFZlcm1hDQo+IDx2aXNoYWwu
bC52ZXJtYUBpbnRlbC5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IERvY3VtZW50IGhlYWRlciBnZW5l
cmF0aW9uIGZvciBzZWN0aW9uIDEgbWFuIHBhZ2VzIChjeGwtZm9vDQo+ID4gY29tbWFuZHMpIHdh
cw0KPiA+IG1pc3NpbmcgdGhlIHNlY3Rpb24gbnVtYmVyIGluIHBhcmVudGhlc2lzLCBpLmUuIGl0
IHdvdWxkIGdlbmVyYXRlOg0KPiA+IA0KPiA+IMKgIGN4bC1mb28NCj4gPiDCoCA9PT09PT09DQo+
ID4gDQo+ID4gaW5zdGVhZCBvZjoNCj4gPiANCj4gPiDCoCBjeGwtZm9vKDEpDQo+ID4gwqAgPT09
PT09PT09PQ0KPiA+IA0KPiA+IHJlc3VsdGluZyBpbiBhc2NpaWRvYyh0b3IpIHdhcm5pbmdzLg0K
PiA+IA0KPiANCj4gV2hhdCB3YXMgdGhlIHdhcm5pbmc/IElzIGEgIkZpeGVzOiIgdGFnIGFwcHJv
cHJpYXRlPw0KDQpJIGRvbid0IHRoaW5rIHNvLCB0aGlzIHdhcyBvbmx5IGZvciBtYW4gcGFnZXMg
Z2VuZXJhdGVkIGJ5DQonZG9jc3VyZ2VvbicsIG9mIHdoaWNoIGN4bC1jcmVhdGUtcmVnaW9uIChX
SVApIHdpbGwgYmUgdGhlIGZpcnN0Lg0KTm8gZXhpc3RpbmcgbWFuIHBhZ2VzIG5lZWRlZCB0byBi
ZSBtb2RpZmllZC4NCg0KPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBWaXNoYWwgVmVybWEgPHZpc2hh
bC5sLnZlcm1hQGludGVsLmNvbT4NCj4gPiAtLS0NCj4gPiDCoHNjcmlwdHMvZG9jc3VyZ2VvbiB8
IDIgKy0NCj4gPiDCoDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigt
KQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9zY3JpcHRzL2RvY3N1cmdlb24gYi9zY3JpcHRzL2Rv
Y3N1cmdlb24NCj4gPiBpbmRleCBjYTBhZDc4Li4xNDIxZWY3IDEwMDc1NQ0KPiA+IC0tLSBhL3Nj
cmlwdHMvZG9jc3VyZ2Vvbg0KPiA+ICsrKyBiL3NjcmlwdHMvZG9jc3VyZ2Vvbg0KPiA+IEBAIC0y
NDQsNyArMjQ0LDcgQEAgZ2VuX2NsaSgpDQo+ID4gDQo+ID4gwqDCoMKgwqDCoMKgwqAgIyBTdGFy
dCB0ZW1wbGF0ZSBnZW5lcmF0aW9uDQo+ID4gwqDCoMKgwqDCoMKgwqAgcHJpbnRmICIlc1xuIiAi
JGNvcHlyaWdodF9jbGkiID4gIiR0bXAiDQo+ID4gLcKgwqDCoMKgwqDCoCBnZW5faGVhZGVyICIk
bmFtZSIgPj4gIiR0bXAiDQo+ID4gK8KgwqDCoMKgwqDCoCBnZW5faGVhZGVyICIkbmFtZSgkX2Fy
Z19zZWN0aW9uKSIgPj4gIiR0bXAiDQo+ID4gwqDCoMKgwqDCoMKgwqAgZ2VuX3NlY3Rpb25fbmFt
ZSAiJG5hbWUiID4+ICIkdG1wIg0KPiA+IMKgwqDCoMKgwqDCoMKgIGdlbl9zZWN0aW9uX3N5bm9w
c2lzXzEgIiRuYW1lIiA+PiAiJHRtcCINCj4gPiDCoMKgwqDCoMKgwqDCoCBnZW5fc2VjdGlvbiAi
REVTQ1JJUFRJT04iID4+ICIkdG1wIg0KPiA+IA0KPiA+IGJhc2UtY29tbWl0OiA1NWYzNjM4N2Vl
OGE4OGM0ODk4NjMxMDMzNDdhZTI3NWIxYmM5MTkxDQo+ID4gcHJlcmVxdWlzaXRlLXBhdGNoLWlk
OiAyNGM3ZGMwYzY0NmMyMTIzOGU0NzQxYTk0MzI3Mzk3ODhjOTA4ZGU3DQo+ID4gcHJlcmVxdWlz
aXRlLXBhdGNoLWlkOiAyZjVhYjdjOWM1YjMwYWE1ODU5NTZlOGE0M2RkMmVjNGQ5MmQ2YWZiDQo+
ID4gcHJlcmVxdWlzaXRlLXBhdGNoLWlkOiA2ZmZhNmNlMGVhMjU4ZmVjMTdmYTYwNjZlNGVlNDM3
ZmZkMjYzMDdjDQo+ID4gcHJlcmVxdWlzaXRlLXBhdGNoLWlkOiA5OGY1ODYzNTNmODk4MjBkMGIw
ZTI5NGMxNjVkYmJkNzMwNmNkZDQwDQo+ID4gcHJlcmVxdWlzaXRlLXBhdGNoLWlkOiA4M2YwNzhm
MGFmZTkzNmRjNmYwZTE3MmY1OWRhMTQ0MTI5ODFhMDMwDQo+ID4gLS0NCj4gPiAyLjM0LjENCj4g
PiANCj4gPiANCj4gDQoNCg==
