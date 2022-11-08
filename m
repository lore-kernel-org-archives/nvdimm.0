Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C901CA460
	for <nvdimm@lists.linux.dev>; Tue,  8 Nov 2022 20:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667939022; x=1699475022;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=RIun1hEPkFVF/pZHyYmQxLP/WLqdprtG5zIwOzxeImQ=;
  b=ep7ypxzDXvyEYGnnaem9vupN1cUFBp4+hSbkoCDqfolzy3aMYReNRny+
   dqK2UTLH/oT3HT8kQuDxn0qv6fy2vRIWDjftaay+mKaUHcTb9Lney32xM
   julBWHE7Hp0FH5+MnqCSFYMxzRivQlTeUHY8ZsKP5emO95iJkIKZH1NfU
   IIh4S1VRBq6e2MP2A54b8oyft8utojrT7V4rj8txa/QW97M0lJ6CGZUgn
   JoNmHJ6i0N+C32eDIATV5MjFcKVQ5j9HGLVzpSJthQUoUQlnoVO79bQ+X
   /E40EPtx+jKwdz6E6EKuiAz52/5CK1GL/bHAuY81AF9yTBtYIV5XirwEb
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="309512084"
X-IronPort-AV: E=Sophos;i="5.96,148,1665471600"; 
   d="scan'208";a="309512084"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 12:23:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="630996306"
X-IronPort-AV: E=Sophos;i="5.96,148,1665471600"; 
   d="scan'208";a="630996306"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP; 08 Nov 2022 12:23:41 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 8 Nov 2022 12:23:41 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 8 Nov 2022 12:23:40 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 8 Nov 2022 12:23:40 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 8 Nov 2022 12:23:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TWO58VrTNPdwPBzecAtCBYlEX0gIxwJ/bddLdTn1Z57MkWwS761mEVvsSGuC6VAhH4XVlhNLG8dDfomxaQcIKS1UGtD2uPAglEgO9s5GoLnScZ6wkHdP3cZG/TaDn0qHalDK53k/dTxnX4JeBWb8THhqieMHrvKlUcFkM/6+SAqtZ63QGP2AGQf7fg4uVw1ZM8nbQ2J2eN7is7IhBV4x/4NlOHxS3tmXLADN4W1xz/BVp1aPIOS/q+IGNFOXYZZXkKiiftBmgZF7GvCpz+fttnQ6zG3vws3It5Df3DagEHpAxUboROaF3ZNb5y2nbBdWUeHvBQ3KU/T44OUK3eWAeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RIun1hEPkFVF/pZHyYmQxLP/WLqdprtG5zIwOzxeImQ=;
 b=cKCjhD63qBgPrOtLfnmVx1FCU7IRMUH+Kg7yVip2EpILyLaSCRWiEKAK8ghj0w0VJcU20kgbQHzpW5fG1+UtfLXNwz3xa6ky/oY4usDcvbPnmQ7WD9tN1Jf1L2Ki73Z0VDciNIfqfg8uKT7yON/VcXByTB4k22VefSHx4jP9FXe00DzER1l+U1OYfwhuJx49+0/kwtjO1OXDVNkM5Kte5bLSGl19cyHml+P1sQkhCQtCKY/r2vcTm+7hKPJ2BstnU9q5DnO7PCGR+NQ7fJgaKVM9RTh3MQkVrwVNJkxnBwi58/O1e54pkgP6xrJRco6z2w7dzl5DKx9v0bnyLJDIEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by IA0PR11MB7377.namprd11.prod.outlook.com (2603:10b6:208:433::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Tue, 8 Nov
 2022 20:23:38 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::c275:940e:a871:646e]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::c275:940e:a871:646e%7]) with mapi id 15.20.5791.026; Tue, 8 Nov 2022
 20:23:38 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH 14/15] cxl/test: Extend cxl-topology.sh for a single
 root-port host-bridge
Thread-Topic: [ndctl PATCH 14/15] cxl/test: Extend cxl-topology.sh for a
 single root-port host-bridge
Thread-Index: AQHY8jo+tUtv4KPVWUSf1LeZX1GF5a41e4KA
Date: Tue, 8 Nov 2022 20:23:38 +0000
Message-ID: <9b6565a8b59f3180f5d1d5edabebe8f32a35c172.camel@intel.com>
References: <166777840496.1238089.5601286140872803173.stgit@dwillia2-xfh.jf.intel.com>
	 <166777848711.1238089.14027431355477472365.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <166777848711.1238089.14027431355477472365.stgit@dwillia2-xfh.jf.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR11MB3999:EE_|IA0PR11MB7377:EE_
x-ms-office365-filtering-correlation-id: 370639fe-2bdd-4fcd-cdfe-08dac1c71ed4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 59mWpNBjvHz5QJ40qpNbtptcxslljE+XS+/Ddzl9zE87VKHo1dLC9mrr5FbhmKo0e2rRhlum61EFiC2hMteLxA/wmDDgBSt38M3cGCBxO4Jz53hQgPwPvkuifKY5YbQaGIQ9/jVOBwknLPFlfgT6XZxJcGOFoYZPFhUr7kL5rWtkM69R0tYLjd2pQUaWskC5AOeYK43x2TuTK0SF8DlQIJC02osjgWETSfN4zqHJF12Qy69q3Hw0eqjbKeMgLX30fFdGJBnb1oM3jeSbzzrOAbivmRGjV5A/WnwVOHRqpbPMj2qOx9NaXsR6zA6FldfjaOD9LQtytdcdYhXSga4vnRwODe+U5WdnEHIJYVK6OASuR3ych3pYbT8pHBsqzFMF42fo6qaEATTTbOLqeZ8srwm7fCvp2kUMBl+MBCYPQ48sQX7gVpFhLyvSnNlNmgQzlmuhj5s9laInn0Q04vFMEa3l86xgDa+X8gg6QplgCYrI78om4rEfKPE+zfCt734xcXVtwqoodTsXdbZCXMVGsWCaH1F8fbmpKmugjLHTjnNBc45ouUT1QDvUjGYMLgxupmcxsNnuol/qbC+FY6wYFkDypFk4wS0rxUaC5moir0Vo1zcDSOO16RuIiaLco5sKKJ2WlWLyWiR/3WT7HU2h3Z828gxXAZqOFB4B98L+ohWnnzXyVrTmL6dlz8gwvT76MPjmwiQtTQK52tWGvnxfFPBoNPpxNLhXyNsjEWx00b/JbCGRwQuPHtzVl/cjnbi+GEp1z+c1qbzCZZW2yRFJCvCTTNj/Qz7nkFjd65Wqpm0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(376002)(396003)(136003)(366004)(451199015)(186003)(6512007)(54906003)(82960400001)(38100700002)(83380400001)(122000001)(2616005)(6862004)(38070700005)(26005)(5660300002)(2906002)(8936002)(6636002)(71200400001)(478600001)(966005)(6486002)(76116006)(66556008)(66446008)(66476007)(41300700001)(4326008)(91956017)(37006003)(64756008)(6506007)(66946007)(8676002)(86362001)(316002)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QUNFN1RNTDNKWlp5Z3gvVG5vWU1rbGNaUUFIL2tCTGx3ZTVFMjFmM2dFNjNs?=
 =?utf-8?B?UVo4allWL2dRanRyaTRQbDAyem01RVVMemhLVXE5LzdPMVVCeDBsQlJsYjA4?=
 =?utf-8?B?MXg4NHYyYmNodG9HRWlGVGF3dytocFdNYUdyM1JmOE15VE5yOVRhNHUycXJR?=
 =?utf-8?B?WU5kbUdXd3F5ajFxUnVOUmhadDh3cEdaMXl3czhUZ29samZRWjRuTVJsWVJ6?=
 =?utf-8?B?d0JXS3VuTzhTWnJQeklUUkhaZFdldUg0UFdLa1doRlZNcjhJZE9KWDlTcGc0?=
 =?utf-8?B?RVRSQU5vdWdUNU1XOG93RTBkcFdYUHkxTm9mbWxPK1dieGltZVBSU05rNjZu?=
 =?utf-8?B?K1FDWHhxTXVSUXp6Y25Bc3ZudlBEemdUWFNGZGZRb0QxT0tOcG1iRk9Xa2w1?=
 =?utf-8?B?UFdDT2kxT2JFRk83alA4a1d5SDcySEhxbVc4SmFIZmZxZ2phN0NKMmtMT2ZZ?=
 =?utf-8?B?cFBQcnBhSzdRWStEa1RUVGZVSElOVk9wSmgzY2F1TlNKaTUyWlVSeFdzYXZu?=
 =?utf-8?B?WnJQVERoa2p5Z0U1U3UxY1JUWndNQjZuMGhnNFMzMitQN2h6dHBsRzJBWmV1?=
 =?utf-8?B?V3IzZFZOZTlmSzRYRTM4Q3F1NDltTkFnRTZMNkZFUnNsUTJZRTlpVGg2MXVB?=
 =?utf-8?B?VXFnejhHUkwxbW5zNTJscjlPUnJEQXJNVHJQLzAyNHgvUzNjUHNCZmhrMHZX?=
 =?utf-8?B?Nmwzb3dZaWVOTFhpb1FYbVU5R1NKRFVsMS8zZ3ZWTVJPS0JRRFVoT2xLNmhG?=
 =?utf-8?B?cm8zSWpCaFlpY2hYUlFJcy9DN0k0M3g1VXVsUG52dS9zQWNEMmQ1ZWFSL2U2?=
 =?utf-8?B?VzZYS1pXd2JONWRXOXduTGplMnI1VlJnYlkxbjhBUy9GV3RFcGVCOEduM3dE?=
 =?utf-8?B?Y2orNWtVZ2pHZzloNEJ6Y1FRajF6RTk2ME9mTTdPQzEwNzdoOTlpanZaMzV0?=
 =?utf-8?B?TTZrYWFja1J0SWJ1TVovNlQ2U3F0YXpyUlRWSmsvVjdHTjNGR1VoRW9qNEM3?=
 =?utf-8?B?bVJFZWhwL2hacTM1L0xDWVMzalZrVEJoU05Hd2p6L0J0L2ViVHVTN0tGNjR4?=
 =?utf-8?B?Q1VDVWRvNE5FelhFcExHTWswNHk0cG5ZZEQ4dTFBL3ErVm80NmphUUtmRDlx?=
 =?utf-8?B?dCtURURKZGNKN2NIdjY0aGZwTktDL25TRFVPMUhIMFJYcUNJVTJTK3lKNGNj?=
 =?utf-8?B?ZzAvTkdTVWZoMHdhM29sT2h6SFN4ZGhZdEc5bDNKdXJySVZNNHRPRi9meTJj?=
 =?utf-8?B?L2F5LzYrOTZzY0xyYTk4OEU1M3R6aFpNM2ZRcndqN0hBS2cweURzeGQ2ZElj?=
 =?utf-8?B?UmgrQzhmSmJFOUR0VmpkZkNaZzZFZkkwZjJzM2pCdXl5S1ljR3Q4VVB0WnhW?=
 =?utf-8?B?cFVzc0pFcStjYjJRZmNvWkpNR0N1Sk01M1R3andObzZlSlhzelovR1lMZUZK?=
 =?utf-8?B?VGg2bEtkYzBwMnp6VWUxWW5CemtWTzNFZTVYUlJtYllYb3dmS3RPOTluQloz?=
 =?utf-8?B?cGYvOXphbHBxQjNJb0hUckh3M2pWZ2lRYmFsb25nMVQ0ckNOckFiNmJGb3I4?=
 =?utf-8?B?TnNlMTF5dUx4ZWcyakQ4YVhQQkxIR3E3UElWSTVYOVJBWGRHMGtiTFBiclgy?=
 =?utf-8?B?enNnMnFuS2c0N0pWOHkvUVkzdVBHNVo5dVJxRGZsQXN6cHl4YlplQ2daZ29L?=
 =?utf-8?B?WUxGbGZXR1hBSkVnY2dyb2FENGhoYW9hL2EveXNvSEZxMHcwNzNHTTZ2M2Nm?=
 =?utf-8?B?UzBmek1TK1RvR2pYWW5BN2VpWVBnQmpBdmF0Q2pnVUg2TTlVaGtqVytPZWRB?=
 =?utf-8?B?RXlUQmh5MkFHL0Q3ZzBSSEozRmRISERQd0Z2a1AyaUhoZ3I3YlVWMmEwcEtr?=
 =?utf-8?B?Umk5Z0xVY1pMV2xoM3FjdmVHSkJlUVN3aXRTa0Z0cFpQTDIzT3Y3U2RQTVZj?=
 =?utf-8?B?NHNQVldtQ2JISTZ3bWZ1ODI0UlhIR25FTnZVaUpITWlPbW9NWUM1RkRvcDhS?=
 =?utf-8?B?OEgwdFZpS2tncEVxK3FXZkU2Y3RsOFpXazVrUngrMVdaWnJaQXFXMlJ0aktO?=
 =?utf-8?B?SWhieFFtcUZET2ZBU2xKSTZkRFFoYXk4RTNmZXpCREdiS0VBalJKUnZNeENH?=
 =?utf-8?B?dmdHZWpOOEdsdldvTkNCNC9sZjE3UkdyNWI3U3V3eGxza281MFdnQmZBNTdX?=
 =?utf-8?B?YVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <725C4F161A8F664F9006FD2A1E80D12C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 370639fe-2bdd-4fcd-cdfe-08dac1c71ed4
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2022 20:23:38.5949
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XZYx50CbjWZzMiiLVrdsP578hZEMS+d7S7IHgOd7PV2fIQFopCbg6k72ynV+y1F4kr1JjdrXZofDAnkzabchjaDwGpT0CaOQjJkSriQ0uiU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7377
X-OriginatorOrg: intel.com

T24gU3VuLCAyMDIyLTExLTA2IGF0IDE1OjQ4IC0wODAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IEEgcmVjZW50IGV4dGVuc2lvbiBvZiBjeGxfdGVzdCBhZGRzIDIgbWVtb3J5IGRldmljZXMgYXR0
YWNoZWQgdGhyb3VnaCBhDQo+IHN3aXRjaCB0byBhIHNpbmdsZSBwb3J0ZWQgaG9zdC1icmlkZ2Ug
dG8gcmVwcm9kdWNlIGEgYnVnIHJlcG9ydC4NCj4gDQo+IFJlcG9ydGVkLWJ5OiBKb25hdGhhbiBD
YW1lcm9uIDxKb25hdGhhbi5DYW1lcm9uQGh1YXdlaS5jb20+DQo+IExpbms6IGh0dHA6Ly9sb3Jl
Lmtlcm5lbC5vcmcvci8yMDIyMTAxMDE3MjA1Ny4wMDAwMTU1OUBodWF3ZWkuY29tDQo+IFNpZ25l
ZC1vZmYtYnk6IERhbiBXaWxsaWFtcyA8ZGFuLmoud2lsbGlhbXNAaW50ZWwuY29tPg0KPiAtLS0N
Cj4gwqB0ZXN0L2N4bC10b3BvbG9neS5zaCB8wqDCoCA0OCArKysrKysrKysrKysrKysrKysrKysr
KysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gwqAxIGZpbGUgY2hhbmdlZCwgMjkgaW5zZXJ0
aW9ucygrKSwgMTkgZGVsZXRpb25zKC0pDQoNClRoaXMgbG9va3MgZ29vZCwganVzdCBhIG1pbm9y
IG5pdCBiZWxvdy4NCg0KPiANCj4gZGlmZiAtLWdpdCBhL3Rlc3QvY3hsLXRvcG9sb2d5LnNoIGIv
dGVzdC9jeGwtdG9wb2xvZ3kuc2gNCj4gaW5kZXggMWYxNWQyOWYwNjAwLi5mMWUwYTJiMDFlOTgg
MTAwNjQ0DQo+IC0tLSBhL3Rlc3QvY3hsLXRvcG9sb2d5LnNoDQo+ICsrKyBiL3Rlc3QvY3hsLXRv
cG9sb2d5LnNoDQo+IEBAIC0yOSwyNyArMjksMzAgQEAgY291bnQ9JChqcSAibGVuZ3RoIiA8PDwg
JGpzb24pDQo+IMKgcm9vdD0kKGpxIC1yICIuW10gfCAuYnVzIiA8PDwgJGpzb24pDQo+IMKgDQo+
IMKgDQo+IC0jIHZhbGlkYXRlIDIgaG9zdCBicmlkZ2VzIHVuZGVyIGEgcm9vdCBwb3J0DQo+ICsj
IHZhbGlkYXRlIDIgb3IgMyBob3N0IGJyaWRnZXMgdW5kZXIgYSByb290IHBvcnQNCj4gwqBwb3J0
X3NvcnQ9InNvcnRfYnkoLnBvcnQgfCAuWzQ6XSB8IHRvbnVtYmVyKSINCj4gwqBqc29uPSQoJENY
TCBsaXN0IC1iIGN4bF90ZXN0IC1CUCkNCj4gwqBjb3VudD0kKGpxICIuW10gfCAuW1wicG9ydHM6
JHJvb3RcIl0gfCBsZW5ndGgiIDw8PCAkanNvbikNCj4gLSgoY291bnQgPT0gMikpIHx8IGVyciAi
JExJTkVOTyINCj4gKygoY291bnQgPT0gMikpIHx8ICgoY291bnQgPT0gMykpIHx8IGVyciAiJExJ
TkVOTyINCj4gK2JyaWRnZXM9JGNvdW50DQo+IMKgDQo+IMKgYnJpZGdlWzBdPSQoanEgLXIgIi5b
XSB8IC5bXCJwb3J0czokcm9vdFwiXSB8ICRwb3J0X3NvcnQgfCAuWzBdLnBvcnQiIDw8PCAkanNv
bikNCj4gwqBicmlkZ2VbMV09JChqcSAtciAiLltdIHwgLltcInBvcnRzOiRyb290XCJdIHwgJHBv
cnRfc29ydCB8IC5bMV0ucG9ydCIgPDw8ICRqc29uKQ0KPiArKChicmlkZ2VzID4gMikpICYmIGJy
aWRnZVsyXT0kKGpxIC1yICIuW10gfCAuW1wicG9ydHM6JHJvb3RcIl0gfCAkcG9ydF9zb3J0IHwg
LlsyXS5wb3J0IiA8PDwgJGpzb24pDQo+IMKgDQo+ICsjIHZhbGlkYXRlIHJvb3QgcG9ydHMgcGVy
IGhvc3QgYnJpZGdlDQo+ICtjaGVja19ob3N0X2JyaWRnZSgpDQo+ICt7DQo+ICvCoMKgwqDCoMKg
wqDCoGpzb249JCgkQ1hMIGxpc3QgLWIgY3hsX3Rlc3QgLVQgLXAgJDEpDQo+ICvCoMKgwqDCoMKg
wqDCoGNvdW50PSQoanEgIi5bXSB8IC5kcG9ydHMgfCBsZW5ndGgiIDw8PCAkanNvbikNCj4gK8Kg
wqDCoMKgwqDCoMKgKChjb3VudCA9PSAkMikpIHx8IGVyciAiJDMiDQo+ICt9DQo+IMKgDQo+IC0j
IHZhbGlkYXRlIDIgcm9vdCBwb3J0cyBwZXIgaG9zdCBicmlkZ2UNCj4gLWpzb249JCgkQ1hMIGxp
c3QgLWIgY3hsX3Rlc3QgLVQgLXAgJHticmlkZ2VbMF19KQ0KPiAtY291bnQ9JChqcSAiLltdIHwg
LmRwb3J0cyB8IGxlbmd0aCIgPDw8ICRqc29uKQ0KPiAtKChjb3VudCA9PSAyKSkgfHwgZXJyICIk
TElORU5PIg0KPiAtDQo+IC1qc29uPSQoJENYTCBsaXN0IC1iIGN4bF90ZXN0IC1UIC1wICR7YnJp
ZGdlWzFdfSkNCj4gLWNvdW50PSQoanEgIi5bXSB8IC5kcG9ydHMgfCBsZW5ndGgiIDw8PCAkanNv
bikNCj4gLSgoY291bnQgPT0gMikpIHx8IGVyciAiJExJTkVOTyINCj4gK2NoZWNrX2hvc3RfYnJp
ZGdlICR7YnJpZGdlWzBdfSAyICRMSU5FTk8NCj4gK2NoZWNrX2hvc3RfYnJpZGdlICR7YnJpZGdl
WzFdfSAyICRMSU5FTk8NCj4gKygoYnJpZGdlcyA+IDIpKSAmJiBjaGVja19ob3N0X2JyaWRnZSAk
e2JyaWRnZVsyXX0gMSAkTElORU5PDQo+IMKgDQo+IC0NCj4gLSMgdmFsaWRhdGUgMiBzd2l0Y2hl
cyBwZXItcm9vdCBwb3J0DQo+ICsjIHZhbGlkYXRlIDIgc3dpdGNoZXMgcGVyIHJvb3QtcG9ydA0K
PiDCoGpzb249JCgkQ1hMIGxpc3QgLWIgY3hsX3Rlc3QgLVAgLXAgJHticmlkZ2VbMF19KQ0KPiDC
oGNvdW50PSQoanEgIi5bXSB8IC5bXCJwb3J0czoke2JyaWRnZVswXX1cIl0gfCBsZW5ndGgiIDw8
PCAkanNvbikNCj4gwqAoKGNvdW50ID09IDIpKSB8fCBlcnIgIiRMSU5FTk8iDQo+IEBAIC02NSw5
ICs2OCw5IEBAIHN3aXRjaFsyXT0kKGpxIC1yICIuW10gfCAuW1wicG9ydHM6JHticmlkZ2VbMV19
XCJdIHwgJHBvcnRfc29ydCB8IC5bMF0uaG9zdCIgPDw8DQo+IMKgc3dpdGNoWzNdPSQoanEgLXIg
Ii5bXSB8IC5bXCJwb3J0czoke2JyaWRnZVsxXX1cIl0gfCAkcG9ydF9zb3J0IHwgLlsxXS5ob3N0
IiA8PDwgJGpzb24pDQo+IMKgDQo+IMKgDQo+IC0jIHZhbGlkYXRlIHRoZSBleHBlY3RlZCBwcm9w
ZXJ0aWVzIG9mIHRoZSA0IHJvb3QgZGVjb2RlcnMNCj4gLSMgdXNlIHRoZSBzaXplIG9mIHRoZSBm
aXJzdCBkZWNvZGVyIHRvIGRldGVybWluZSB0aGUgY3hsX3Rlc3QgdmVyc2lvbiAvDQo+IC0jIHBy
b3BlcnRpZXMNCj4gKyMgdmFsaWRhdGUgdGhlIGV4cGVjdGVkIHByb3BlcnRpZXMgb2YgdGhlIDQg
b3IgNSByb290IGRlY29kZXJzDQo+ICsjIHVzZSB0aGUgc2l6ZSBvZiB0aGUgZmlyc3QgZGVjb2Rl
ciB0byBkZXRlcm1pbmUgdGhlDQo+ICsjIGN4bF90ZXN0IHZlcnNpb24gLyBwcm9wZXJ0aWVzDQo+
IMKganNvbj0kKCRDWEwgbGlzdCAtYiBjeGxfdGVzdCAtRCAtZCByb290KQ0KPiDCoHBvcnRfaWQ9
JHtyb290OjR9DQo+IMKgcG9ydF9pZF9sZW49JHsjcG9ydF9pZH0NCj4gQEAgLTEwMywxMiArMTA2
LDE5IEBAIGNvdW50PSQoanEgIlsgJGRlY29kZXJfc29ydCB8IC5bM10gfA0KPiDCoMKgwqDCoMKg
wqDCoMKgc2VsZWN0KC5ucl90YXJnZXRzID09IDIpIF0gfCBsZW5ndGgiIDw8PCAkanNvbikNCj4g
wqAoKGNvdW50ID09IDEpKSB8fCBlcnIgIiRMSU5FTk8iDQo+IMKgDQo+ICtpZiBbICRicmlkZ2Vz
IC1lcSAzIF07IHRoZW4NCg0KVGhlICRicmlkZ2VzIHNob3VsZCBiZSBxdW90ZWQgaWYgdXNpbmcg
dGhlIHBvc2l4IHNoIHN0eWxlIFsgXSwNCm9yIHVzZSB0aGUgYmFzaCBzdHlsZSB3aXRob3V0IHF1
b3Rpbmc6IGlmIFtbICRicmlkZ2VzID09ICIzIiBdXQ0Kb3IgdXNlIGEgJ21hdGgnIGNvbnRleHQ6
IGlmICgoIGJyaWRnZXMgPT0gMyApKQ0KDQo+ICvCoMKgwqDCoMKgwqDCoGNvdW50PSQoanEgIlsg
JGRlY29kZXJfc29ydCB8IC5bNF0gfA0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
c2VsZWN0KC5wbWVtX2NhcGFibGUgPT0gdHJ1ZSkgfA0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgc2VsZWN0KC5zaXplID09ICRkZWNvZGVyX2Jhc2Vfc2l6ZSkgfA0KPiArwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgc2VsZWN0KC5ucl90YXJnZXRzID09IDEpIF0gfCBsZW5n
dGgiIDw8PCAkanNvbikNCj4gK8KgwqDCoMKgwqDCoMKgKChjb3VudCA9PSAxKSkgfHwgZXJyICIk
TElORU5PIg0KPiArZmkNCj4gwqANCj4gLSMgY2hlY2sgdGhhdCBhbGwgOCBjeGxfdGVzdCBtZW1k
ZXZzIGFyZSBlbmFibGVkIGJ5IGRlZmF1bHQgYW5kIGhhdmUgYQ0KPiArIyBjaGVjayB0aGF0IGFs
bCA4IG9yIDEwIGN4bF90ZXN0IG1lbWRldnMgYXJlIGVuYWJsZWQgYnkgZGVmYXVsdCBhbmQgaGF2
ZSBhDQo+IMKgIyBwbWVtIHNpemUgb2YgMjU2TSwgb3IgMUcNCj4gwqBqc29uPSQoJENYTCBsaXN0
IC1iIGN4bF90ZXN0IC1NKQ0KPiDCoGNvdW50PSQoanEgIm1hcChzZWxlY3QoLnBtZW1fc2l6ZSA9
PSAkcG1lbV9zaXplKSkgfCBsZW5ndGgiIDw8PCAkanNvbikNCj4gLSgoY291bnQgPT0gOCkpIHx8
IGVyciAiJExJTkVOTyINCj4gKygoYnJpZGdlcyA9PSAyICYmIGNvdW50ID09IDggfHwgYnJpZGdl
cyA9PSAzICYmIGNvdW50ID09IDEwKSkgfHwgZXJyICIkTElORU5PIg0KPiDCoA0KPiDCoA0KPiDC
oCMgY2hlY2sgdGhhdCBzd2l0Y2ggcG9ydHMgZGlzYXBwZWFyIGFmdGVyIGFsbCBvZiB0aGVpciBt
ZW1kZXZzIGhhdmUgYmVlbg0KPiBAQCAtMTUxLDggKzE2MSw4IEBAIGRvDQo+IMKgZG9uZQ0KPiDC
oA0KPiDCoA0KPiAtIyB2YWxpZGF0ZSBob3N0IGJyaWRnZSB0ZWFyIGRvd24NCj4gLWZvciBiIGlu
ICR7YnJpZGdlW0BdfQ0KPiArIyB2YWxpZGF0ZSBob3N0IGJyaWRnZSB0ZWFyIGRvd24gZm9yIHRo
ZSBmaXJzdCAyIGJyaWRnZXMNCj4gK2ZvciBiIGluICR7YnJpZGdlWzBdfSAke2JyaWRnZVsxXX0N
Cj4gwqBkbw0KPiDCoMKgwqDCoMKgwqDCoMKgJENYTCBkaXNhYmxlLXBvcnQgJGIgLWYNCj4gwqDC
oMKgwqDCoMKgwqDCoGpzb249JCgkQ1hMIGxpc3QgLU0gLWkgLXAgJGIpDQo+IA0KDQo=
