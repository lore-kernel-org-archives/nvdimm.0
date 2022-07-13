Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3CF4A0A
	for <nvdimm@lists.linux.dev>; Wed, 13 Jul 2022 19:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657738820; x=1689274820;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=i4GLDEj3gdHvbJOXbp+nxXJF9vBjaEuLqC3HdvM6678=;
  b=FXNvfRWhLF8EGyShiv6RDj9v9cTaVzjl8Kn49UAyMWMAeP61/Qtu4lAU
   YeD6c0MOWh4MEWV55nYcNr2xqhdxkpcYMpmnErzwHJIMmwVUwTji9nP6U
   4eN5bUHKiEsdpAl0iBpMO0BmiFHzcGO3heshSC/f1YiXz+faG4s3/3chE
   nyrwXmIBcrd+lK1+w1g/nH9/PaxAqLJ7Y3yRcva0cjhsJXEo3viSdtIoK
   YaigfWE5qDpSgAxI/FfwYOpUe/GEPKoTKOdNDhM/iBzCA8VH6J1UJGFDZ
   AEtLRZLSJxvfS0dkUZIjNBGNZoHFD5DfBpVHvXHWpiE3TlU4kgljcbkki
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10407"; a="310963102"
X-IronPort-AV: E=Sophos;i="5.92,267,1650956400"; 
   d="scan'208";a="310963102"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2022 12:00:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,267,1650956400"; 
   d="scan'208";a="545971904"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 13 Jul 2022 12:00:15 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 13 Jul 2022 12:00:15 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 13 Jul 2022 12:00:13 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 13 Jul 2022 12:00:13 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 13 Jul 2022 12:00:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KYg4c1f2Rd5fdw/5zl02mOXJMSTX18CekH8Stt1LovIz+iHiTGDDlgs9g5t0oOJUVQSu9A8Htfnos6AcGpTIJ+xtTy79m6xTr4N0P1kx6jXL/8+zn9wV2v/BTWqiM3P6TKWqNxKFPGGNDAEZhNnsBlIV0HPQmtFqctlBdnCHL51v676txHVKuLhAfXVGWFaqDRlNA15T4WxImogEU6sySJvUlKhtOk5cV7TeF95m0NqFjzRXqZwZENcUKovyhgQR07bhdYE6Q4ZWhtHt53J6nAGUBWqi7CvPEvMH0fmiIWy7RjtQZG1jH1bbW+86zldulLj3D0P1RZoxeIyU7nJWeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i4GLDEj3gdHvbJOXbp+nxXJF9vBjaEuLqC3HdvM6678=;
 b=L9QU/jFKv66mpRwOr0YoFJT07emkoDMYLmLr+yFa2lTZVubMItR7vI5jo42rw1U5gS2dQAFJ446evM6+fIaIWQD+2JByBP6XSdS9vVz7tikTil/qnezw7kfwITk+UFPkkHXo3BMVl/jqfB9ub5R04x13LSCaPVILtR4zCZaKwrkk6kGyPkzAM3x0D1NrpBRx6TF4fcoLubb4aAeSBxgltDngXiap3LB/X6ywpHTIh25QmVVn0cJohwUT6p8bBb7ltq0TZuApk5bJWWDyyPxCjDBuj/qgm2kyvia//JHYPvdRtTIrfucy80Vej/SDMM1D3oxSGH4gNbwFoADUW8C2KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by DM5PR11MB1818.namprd11.prod.outlook.com (2603:10b6:3:114::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20; Wed, 13 Jul
 2022 19:00:11 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::61f9:fcc7:c6cb:7e17]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::61f9:fcc7:c6cb:7e17%5]) with mapi id 15.20.5417.026; Wed, 13 Jul 2022
 19:00:11 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "dave@stgolabs.net" <dave@stgolabs.net>
CC: "Williams, Dan J" <dan.j.williams@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>, "a.manzanares@samsung.com"
	<a.manzanares@samsung.com>
Subject: Re: [ndctl PATCH] cxl/test: add a test to {read,write,zero}-labels
Thread-Topic: [ndctl PATCH] cxl/test: add a test to {read,write,zero}-labels
Thread-Index: AQHYlo1zzd06jDszzUK5emGxgQJJ+q18pa8AgAACwYA=
Date: Wed, 13 Jul 2022 19:00:11 +0000
Message-ID: <bc5a8df2dc71ce95c852c64f0323f2f79cba1d29.camel@intel.com>
References: <20220713075157.411479-1-vishal.l.verma@intel.com>
	 <20220713185018.lfrq6uunaigpc6u2@offworld>
In-Reply-To: <20220713185018.lfrq6uunaigpc6u2@offworld>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.3 (3.44.3-1.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 07e87974-ed60-4e83-4732-08da6501e9bf
x-ms-traffictypediagnostic: DM5PR11MB1818:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ikAGJ7FCf6/xQ7w6RvGQupF6t58tnnZB0wMCGXiKoSOTaMtsWuF8JXNb6A5pzeacHhaRTCFTTbapmTG2VN60G89ALnFZHQfQ4p/vjd93ju+GOhm/7TP+rRsnEW2tivjs3mvMFamOMLoIkY+wKuAh1f4yi7KoX0733I2XdErxZRCV7+Owz6tNUuySuwn6kjQs7VhLPSOvKZXOHmlFF8Vt5U9Pa7N+6kcgySdhRUW4y0gJFqVzz1lUNzd8/xjU3+Y4cQ9eRpF3UcHT9OjHSe5O534xSe0Zsw1iVgGPNU9yX5oXMXa7X4hpoScpLXVmJdNcJEKolQoZuQTYzbK/yUnF3RTodLE8UEZ/cmo9Bcbj7UTluIxWgQFK9jMfWcYQ78ZTp2+u7GmRK6sI46LafAqXiEFQ2tOB2HROMm8L6AIuwU+jz9+Oa6sZlnuEZGNOFmXbGY+KaukVHrF+ZT//vj5HTQzvi2m8+ETNgKVaK9ru8Gu8gxXzk2dTcnVLNzgLMJceSDuSpTBBORI5PVlN0MIhs7RBLHBNqB+4YOtyvL9admzlwmmpCOeKPg8lJarytKjNJ/e3Zfeiyd5qHI7rFvPizj3L6X8AOwD6LRbgJy92QVXIrldYlt7ayNsV7wtGEIlAYahaNuoFJckF4SusCuQ7V95vA9zKOZDW+0NE2mze9kP/3A9BL9Einx4i2HUYe5/QY3KgKqdcl/mXoIGamKobKVstuOH8DlsPBIOA9B3a4vnWwRMUPrt4ThxC2sZX+aXXOmdxbwIqlWLFFw9NOKiknwIhv3uq59gST8DYUL0fUYkJ5E7VtvsiY8Ay9kbvCVHP
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(136003)(366004)(39860400002)(376002)(6916009)(6506007)(54906003)(76116006)(64756008)(83380400001)(91956017)(66556008)(316002)(26005)(41300700001)(8676002)(4326008)(66446008)(66476007)(66946007)(38070700005)(186003)(6512007)(71200400001)(86362001)(2906002)(2616005)(5660300002)(478600001)(36756003)(82960400001)(38100700002)(6486002)(122000001)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bXdCd1BEcUppdEx1QWhHUWN4UVZ6blVpanFzbTFtQWJkck1rSk84d3BaOU94?=
 =?utf-8?B?MDVyd2trMnpSTkNLU0IrelNod1Y4bUNRZTBubSs1QnVKSFhCS2xoTE1kaUZm?=
 =?utf-8?B?QWd3Zk81VUE3QnExaFB1S0NwbUJDUWhRTWpuVTI3cmp3SFJOODRpb2UxUnJj?=
 =?utf-8?B?L3p5RmRVd3FwNVk1NnRrclhNWUNKNkdmZEtObHRYQS9rWnQvZUhRYlhlYy9S?=
 =?utf-8?B?cjlLU0w4ZzV3dU1ycmI4dDY5azhnVmNPOFJDdGNvamtZRUdKMlBlTVZnTWVn?=
 =?utf-8?B?QllkRVFRSm44NmRMSHJEVVJsZEZwUDFYdWFoZFlyTndLWWFzR1B5ZWJ5eXlx?=
 =?utf-8?B?UHc3enpna3Y2azdMOFh4TUNhZ3Z4NVZWTGlScXNBc29xcklodDJ0anNyVGQy?=
 =?utf-8?B?K3RSMllOT1BodGU2VWJwU3NBQXh0NVZmbnUvNjBISmlrWkhjTDhCL0UrZU9h?=
 =?utf-8?B?K2xJditPQzFlSXoyYnJJSi9MeFk2L3ZRZC9BcHBwNThSU0U2YzR4ZGJlaUhp?=
 =?utf-8?B?Mmw0bHI1Q21SYitwbmFtTndmQ3FISUV1emNXQlowQzZlLzlTanNsbDYwdXMx?=
 =?utf-8?B?SmttcXZTczBYeXU3Tk53ZThpT0Znc3kyK0FNZXpDWjE5TGlPSWwxQi9jL3Bl?=
 =?utf-8?B?aW5MWHRaQkhBTmdoWEo4cXl6S0xVam1LNDlXcUtpdWxkMU9xQTVnaXdmbmRD?=
 =?utf-8?B?QmJnT20zaTU5ZVBSU1VkdWdxbDhuK3ZDZVJuQVJBSklzV0NGNTNmczEzY1NS?=
 =?utf-8?B?aFhkelJVK0Z4Skk5UGVzdXFPaW01eWVUeHAyUDdaQkxrUnl1RGhybERmQUt1?=
 =?utf-8?B?RnhJd0hDMWx2UU5FelplZWt2YlZyQWhHSDQya0JXNnhVd1lkeWJsL200bW9z?=
 =?utf-8?B?TExFRm1ySEs4VG44NFRhYnNQdjE4bDlXSDlFTVdvRm5LZm9QOUFETHk5RHVy?=
 =?utf-8?B?dzlMcUpTNTk1ekYzaGlVa1h3UHlRdnVUWGl0UnFzd013bzBCMU82eWd4S3hP?=
 =?utf-8?B?OFE2azZBbU13dXd6R0kxSHRrYm5RSjlRa2xnMUpEYnZFekMxMjNFVlVUVnpT?=
 =?utf-8?B?Rm5oalZQeDBmZHJBdi9kblV4ZE50WUloV1dUZlBBMXVBalZZbC9jMDhWT2VF?=
 =?utf-8?B?bzZCbVR0ZnJyUS9LTWRTNzRHOGFOOG13NmRpWE5OQmNPdjgyZmFPdXU3ckJj?=
 =?utf-8?B?bmJ6RWQ5QWFYazlSaXNkSTc2d254V244Rjd6ZFo5TVB0RGpiS2hCRXNqUjMz?=
 =?utf-8?B?dVFSaDkzOUhkdGczTG5nd3hnTFRpUk96aUIvdDJBUmZCdXpYNWVacGtSb1Ju?=
 =?utf-8?B?aXlMTWQ4dmVod2RCY1VZWXhYMzZiWTBFZ0dmaks0WklXWVlFTUo5VHRDZDV6?=
 =?utf-8?B?amJpMkJJZVprbmE2Qk5pYXYxSnREaDlwY1gxK1NTdTB3V0U5ZmRwZVl3KzJp?=
 =?utf-8?B?SCtYMGNVc2xuWEozTDdQVkVKWHQ1WVg5OWxGK01tdkdIMk84N2IvYUtUMWlq?=
 =?utf-8?B?dEwzcnNDZUZtZURlMUt1WFkzekY3T2I0L2FOY2hnZUx4QW52WU9QRnY5eUVL?=
 =?utf-8?B?d3JjR2NLcnlVYkdkZ0lPbkNLQm9yUW9sc2NhNU5TOVZieS9nTW1YN211NFBO?=
 =?utf-8?B?NG16Sy80UnVoUE1nUzJ0em5KUi85SHlFd2RVb1Y4MThEOVNZaDNQVzB2NVFr?=
 =?utf-8?B?NkZnemZLazZrSW15aDRxZm53RUd0WHlOMnVDTVp4cTdqL2UxNTdRcHllYk4v?=
 =?utf-8?B?ZDdDL0tIcDJOTGJuYjRKQ1lZMjdIUFV0aU5ZSTZuK1Y2OVhYaC84b2JMZUps?=
 =?utf-8?B?dzhmbDRXV0RJQUY1VjZ3MmRNRlVtRHZBLzMrdEZZcGliZnh3Y24vNVpzUkR6?=
 =?utf-8?B?dDhjcEMrSXdPTExRSHpFek1zbFpLMzVIeEU1eWNyRk5KWXZtVnA1U3lUZ2RT?=
 =?utf-8?B?S3VXdUZDcnZmNWhSbTZ2YS95RnhTbWlPVGhJdUxFeUV4aW1rU0xhZ2t6elhk?=
 =?utf-8?B?VEhWZHVkZXc3bVNOYlpMMERES1lnUHlDQnpsYVYvN3c5a2hiYWpMblB5WFdw?=
 =?utf-8?B?ekd4UjZ3MHQzZnhCSWRoQzBNTFNpQVNlcDJGV1FZRzJrQUN4L0ZMYjlheG56?=
 =?utf-8?B?T3dkdVI3YS9tSFh3SXNvd1NMSkRYeGh4WEdmSk5UTGxrb2szTVpUWWJjYVp1?=
 =?utf-8?B?UEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7E975635683B094E9051E412CF526454@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07e87974-ed60-4e83-4732-08da6501e9bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2022 19:00:11.6877
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2wOjucZQ5MknuX5nphHcPPKfqpIEeyviKPiENziLJYn8w98NiiCbp+m8SPtGxbhmWW1XurS94rm+tHav9fFIq8DumovBG3ggOMbd35sYxnE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1818
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDIyLTA3LTEzIGF0IDExOjUwIC0wNzAwLCBEYXZpZGxvaHIgQnVlc28gd3JvdGU6
DQo+IE9uIFdlZCwgMTMgSnVsIDIwMjIsIFZpc2hhbCBWZXJtYSB3cm90ZToNCj4gDQo+ID4gQWRk
IGEgdW5pdCB0ZXN0IHRvIHRlc3Qgd3JpdGluZywgcmVhZGluZywgYW5kIHplcm9pbmcgTFNBIGFy
ZWFkIGZvcg0KPiA+IGN4bF90ZXN0IGJhc2VkIG1lbWRldnMgdXNpbmcgbmRjdGwgY29tbWFuZHMu
DQo+ID4gDQo+ID4gQ2M6IERhbiBXaWxsaWFtcyA8ZGFuLmoud2lsbGlhbXNAaW50ZWwuY29tPg0K
PiA+IFNpZ25lZC1vZmYtYnk6IFZpc2hhbCBWZXJtYSA8dmlzaGFsLmwudmVybWFAaW50ZWwuY29t
Pg0KPiA+IC0tLQ0KPiA+IHRlc3QvY3hsLWxhYmVscy5zaCB8IDUzICsrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4gPiB0ZXN0L21lc29uLmJ1aWxkwqDCoCB8
wqAgMiArKw0KPiA+IDIgZmlsZXMgY2hhbmdlZCwgNTUgaW5zZXJ0aW9ucygrKQ0KPiA+IGNyZWF0
ZSBtb2RlIDEwMDY0NCB0ZXN0L2N4bC1sYWJlbHMuc2gNCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEv
dGVzdC9jeGwtbGFiZWxzLnNoIGIvdGVzdC9jeGwtbGFiZWxzLnNoDQo+ID4gbmV3IGZpbGUgbW9k
ZSAxMDA2NDQNCj4gPiBpbmRleCAwMDAwMDAwLi5jZTczOTYzDQo+ID4gLS0tIC9kZXYvbnVsbA0K
PiA+ICsrKyBiL3Rlc3QvY3hsLWxhYmVscy5zaA0KPiA+IEBAIC0wLDAgKzEsNTMgQEANCj4gPiAr
IyEvYmluL2Jhc2gNCj4gPiArIyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMA0KPiA+
ICsjIENvcHlyaWdodCAoQykgMjAyMiBJbnRlbCBDb3Jwb3JhdGlvbi4gQWxsIHJpZ2h0cyByZXNl
cnZlZC4NCj4gPiArDQo+ID4gKy4gJChkaXJuYW1lICQwKS9jb21tb24NCj4gPiArDQo+ID4gK3Jj
PTENCj4gPiArDQo+ID4gK3NldCAtZXgNCj4gPiArDQo+ID4gK3RyYXAgJ2VyciAkTElORU5PJyBF
UlINCj4gPiArDQo+ID4gK2NoZWNrX3ByZXJlcSAianEiDQo+ID4gKw0KPiA+ICttb2Rwcm9iZSAt
ciBjeGxfdGVzdA0KPiA+ICttb2Rwcm9iZSBjeGxfdGVzdA0KPiA+ICt1ZGV2YWRtIHNldHRsZQ0K
PiA+ICsNCj4gPiArdGVzdF9sYWJlbF9vcHMoKQ0KPiA+ICt7DQo+ID4gK8KgwqDCoMKgwqDCoMKg
bm1lbT0iJDEiDQo+ID4gK8KgwqDCoMKgwqDCoMKgbHNhPSQobWt0ZW1wIC90bXAvbHNhLSRubWVt
LlhYWFgpDQo+ID4gK8KgwqDCoMKgwqDCoMKgbHNhX3JlYWQ9JChta3RlbXAgL3RtcC9sc2EtcmVh
ZC0kbm1lbS5YWFhYKQ0KPiA+ICsNCj4gPiArwqDCoMKgwqDCoMKgwqAjIGRldGVybWluZSBMU0Eg
c2l6ZQ0KPiA+ICvCoMKgwqDCoMKgwqDCoCIkTkRDVEwiIHJlYWQtbGFiZWxzIC1vICIkbHNhX3Jl
YWQiICIkbm1lbSINCj4gPiArwqDCoMKgwqDCoMKgwqBsc2Ffc2l6ZT0kKHN0YXQgLWMgJXMgIiRs
c2FfcmVhZCIpDQo+ID4gKw0KPiA+ICvCoMKgwqDCoMKgwqDCoGRkICJpZj0vZGV2L3VyYW5kb20i
ICJvZj0kbHNhIiAiYnM9JGxzYV9zaXplIiAiY291bnQ9MSINCj4gPiArwqDCoMKgwqDCoMKgwqAi
JE5EQ1RMIiB3cml0ZS1sYWJlbHMgLWkgIiRsc2EiICIkbm1lbSINCj4gPiArwqDCoMKgwqDCoMKg
wqAiJE5EQ1RMIiByZWFkLWxhYmVscyAtbyAiJGxzYV9yZWFkIiAiJG5tZW0iDQo+ID4gKw0KPiA+
ICvCoMKgwqDCoMKgwqDCoCMgY29tcGFyZSB3aGF0IHdhcyB3cml0dGVuIHZzIHJlYWQNCj4gPiAr
wqDCoMKgwqDCoMKgwqBkaWZmICIkbHNhIiAiJGxzYV9yZWFkIg0KPiA+ICsNCj4gPiArwqDCoMKg
wqDCoMKgwqAjIHplcm8gdGhlIExTQSBhbmQgdGVzdA0KPiA+ICvCoMKgwqDCoMKgwqDCoCIkTkRD
VEwiIHplcm8tbGFiZWxzICIkbm1lbSINCj4gPiArwqDCoMKgwqDCoMKgwqBkZCAiaWY9L2Rldi96
ZXJvIiAib2Y9JGxzYSIgImJzPSRsc2Ffc2l6ZSIgImNvdW50PTEiDQo+ID4gK8KgwqDCoMKgwqDC
oMKgIiRORENUTCIgcmVhZC1sYWJlbHMgLW8gIiRsc2FfcmVhZCIgIiRubWVtIg0KPiA+ICvCoMKg
wqDCoMKgwqDCoGRpZmYgIiRsc2EiICIkbHNhX3JlYWQiDQo+ID4gKw0KPiA+ICvCoMKgwqDCoMKg
wqDCoCMgY2xlYW51cA0KPiA+ICvCoMKgwqDCoMKgwqDCoHJtICIkbHNhIiAiJGxzYV9yZWFkIg0K
PiA+ICt9DQo+ID4gKw0KPiA+ICsjIGZpbmQgbm1lbSBkZXZpY2VzIGNvcnJlc3BvbmRpbmcgdG8g
Y3hsIG1lbWRldnMNCj4gPiArcmVhZGFycmF5IC10IG5tZW1zIDwgPCgiJE5EQ1RMIiBsaXN0IC1i
IGN4bF90ZXN0IC1EaSB8IGpxIC1yICcuW10uZGV2JykNCj4gDQo+IHMvJE5EQ1RMLyRDWEwNCj4g
DQo+IEJleW9uZCBzaGFyaW5nIGEgcmVwbywgSSB3b3VsZCByZWFsbHkgYXZvaWQgbWl4aW5nIGFu
ZCBtYXRjaGluZyBuZGN0bCBhbmQgY3hsDQo+IHRvb2xpbmcgYW5kIHRoZXJlYnkga2VlcCB0aGVt
IHNlbGYgc3VmZmljaWVudC4gSSB1bmRlcnN0YW5kIHRoYXQgdGhlcmUgYXJlIGNhc2VzDQo+IHdo
ZXJlIHBtZW0gc3BlY2lmaWMgb3BlcmF0aW9ucyBjYW4gY2FuIGJlIGRvbmUgcmV1c2luZyByZWxl
dmFudCBwbWVtL252ZGltbS9uZGN0bA0KPiBtYWNoaW5lcnkgYW5kIGludGVyZmFjZXMsIGJ1dCBJ
IGRvbid0IHNlZSB0aGlzIGFzIHRoZSBjYXNlIGZvciBzb21ldGhpbmcgbGlrZSBsc2ENCj4gdW5p
dCB0ZXN0aW5nLg0KPiANCj4gVGhhbmtzLA0KPiBEYXZpZGxvaHINCj4gDQpIaSBEYXZpZCwNCg0K
VGhhbmtzIGZvciB0aGUgcmV2aWV3IC0gaG93ZXZlciB0aGlzIHdhcyBpbnRlbnRpb25hbC4gY3hs
LWNsaSBtYXkgYmxvY2sNCkxTQSB3cml0ZSBhY2Nlc3MgYmVjYXVzZSBsaWJudmRpbW0gY291bGQg
J293bicgdGhlIGxhYmVsIHNwYWNlLg0KDQogIGN4bCBtZW1kZXY6IGFjdGlvbl93cml0ZTogbWVt
MDogaGFzIGFjdGl2ZSBudmRpbW0gYnJpZGdlLCBhYm9ydCBsYWJlbCB3cml0ZQ0KDQpTbyB0aGUg
dGVzdCBoYXMgdG8gdXNlIG5kY3RsIGZvciBsYWJlbCB3cml0ZXMuIFJlYWRzIGNvdWxkIGJlIGRv
bmUgd2l0aA0KJ2N4bCcsIGJ1dCBmb3Igbm93IHRoZXJlIGlzbid0IGEgZ29vZC9wcmVkaWN0YWJs
ZSBtYXBwaW5nIGJldHdlZW4gbmRjdGwNCidubWVtWCcgYW5kIGN4bCAnbWVtWCcuIE9uY2UgdGhh
dCBpcyBzb2x2ZWQsIGVpdGhlciBieSBhIHNoYXJlZCBpZA0KYWxsb2NhdG9yLCBvciBieSBsaXN0
aW5ncyBzaG93aW5nIHRoZSBubWVtLT5tZW0gbWFwcGluZywgSSB3aWxsIGF0DQpsZWFzdCBhZGQg
YW5vdGhlciBjeGwgcmVhZC1sYWJlbHMgaGVyZSB3aGljaCB3b3VsZCB2YWxpZGF0ZSB0aGUgc2Ft
ZQ0KTFNBIGRhdGEgdGhyb3VnaCBjeGwtY2xpLg0KDQo+IA0K
