Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 438C61DFFE
	for <nvdimm@lists.linux.dev>; Tue, 31 Oct 2023 17:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SZG0fZsK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698772958; x=1730308958;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=JV5oJLtiO6n+7O+2MZjuLwoRfCvJK/Kheqe/ntwhVKk=;
  b=SZG0fZsKkeoJV+BhsJtQHxCngr7bMC3Rtb19PoD5dxNZeZI13kTZ1UJk
   hbekHIaxtZPdzl8kzP3lAPJ3tphmgPsrFR+JFIqLYo1xfRS7mOB19CKOg
   8yK2OCkm8U9FeSuhJaSZvbHBWV/w0aknLLGljBkGvDLdvL+abELeFhgnL
   FfuwCCbsHHCW8ac1+duYSlgt7kuqgPE9MlqCN1MlqyESbCpye2+r2oZe7
   Q7k95t7G/jIK+BnM5U4muni0q5tfv2Uik2uQ9L+8cJHkt+ePVYdJBti9U
   GpRjiMt+3j7tCo1ziG8LXoA75Rivi44EedFUQd4TS7bKMdwCMOUO3eaqr
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10880"; a="385521921"
X-IronPort-AV: E=Sophos;i="6.03,265,1694761200"; 
   d="scan'208";a="385521921"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2023 10:22:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10880"; a="1092074687"
X-IronPort-AV: E=Sophos;i="6.03,265,1694761200"; 
   d="scan'208";a="1092074687"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 31 Oct 2023 10:22:35 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Tue, 31 Oct 2023 10:22:35 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Tue, 31 Oct 2023 10:22:35 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Tue, 31 Oct 2023 10:22:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=klnDayZo4I8d56udhaY22OipY1ccdVe+r5s8OexOAlMlcGHnYP9To4FZKdDFjA2kBBRFhWp+dXVCyO6Sb/KagJVUC8uARdpLLSlPXVSNmKDta4QNBmb72A/6w92UGXRKAHTMSIAVmSWB9U25Kz93gNROmOY3fft5k/VzA7/RpPRwxBvpqWfY+B5HKym2JBdrI35ejiwQUnmGHBmsUmiaKPkzn4kXOp4CxcIvvxHDb72M78LKsRyTdsR7qYyIdrN3xt9LFa+hGPU1fstWfjZNMNwz7jS1f0jSN7IRycVvTrQCAMB2RPbar7+aqd/8cwh0N+ClV3ddfDQwqhyyNnAGVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JV5oJLtiO6n+7O+2MZjuLwoRfCvJK/Kheqe/ntwhVKk=;
 b=DXmx3JjePpXhFkbmRNVP+/Hkn4nOLgcFvFant+nVe2Qgf9B/W/dj9IHFGKFMmX52UFN2b0OxixGc1XSMmqHx6CTwY6EAdZ1feb6Ba9pNIxnpGk0jcNKbk7lk/Xko1z0YhIJARLF83on04DTXRVFdzv17fdRH6/Sngk68xB2nhpJHmLlSaytDe7iaIANAnQZXUGslsoADpjJtMJPM0+YnpRoTt+6jZlQlxG/cbkx0a/8bhDrBEEi4Fr/2R5InW8nSiXxw2Kjmf5UnJVe7EoUcBEnV12ZZLH2zX69aOF7LehTWGRVzD+N+fTBs0L3P9QTJdYmj3tgt3iSQREwGniES4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by SJ2PR11MB7713.namprd11.prod.outlook.com (2603:10b6:a03:4f6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.29; Tue, 31 Oct
 2023 17:22:33 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::703a:a01d:8718:5694]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::703a:a01d:8718:5694%7]) with mapi id 15.20.6933.026; Tue, 31 Oct 2023
 17:22:32 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Jiang, Dave" <dave.jiang@intel.com>, "caoqq@fujitsu.com"
	<caoqq@fujitsu.com>
CC: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [ISSUE] `cxl disable-region region0` twice but got same output
Thread-Topic: [ISSUE] `cxl disable-region region0` twice but got same output
Thread-Index: AQHaCvxEZU2KjP5CzkSFNGNKTCX7QLBkJ6+A
Date: Tue, 31 Oct 2023 17:22:32 +0000
Message-ID: <9b0f2cc0330197456bd5c810561b390a7606a26b.camel@intel.com>
References: <dc013f7b-2039-e2ed-01ad-705435d16862@fujitsu.com>
In-Reply-To: <dc013f7b-2039-e2ed-01ad-705435d16862@fujitsu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|SJ2PR11MB7713:EE_
x-ms-office365-filtering-correlation-id: de409aa1-b45b-4a4c-c970-08dbda35f7d4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NU2+KWVY+gjWVkxPC9iIu1NM1biMEAxmXDYZDTOMd6qSUzZkn/l2Ij9kluhvjGxJlGxFwHxnSqsTuTIftdGpxjX7kFStRsI2ioPwUNo94G5kXvq1cslZBdPXKM2ANNKf1tRcZT1pNw77tg2+VyYdMrLklhn5SY/mRPKDvtiiMtb+iUb+AzELSPFj/EpWw6b5mP/tDy3F9NZVFBYxmkUGHf5i5M/nGMK28rEVRnEelxRDdVXzZ9KL25j0G1zau6N8Vr+YNBsDQaDFN54z+4lgzfxtee2kpes+lJmVRNd492Z1tjMzevJtOHEfL5OmWbk3sBpf7oPiRo3oBPUqUYVFmJDFu6zLezjTKIGaAx0eifKvVHa+dTKaxBmXA9f4C283oxvsp9tkTi3RHsDzaeO4dP+RjwRg0CtDG0n5WHY1euVFHJAGh8maimhYSsFCvXHFvla5czBZOesYQ8TKXhQw/JMINHX1Y+1czL++/CR5fi8hqwGzb8N/THa+fifqK5rxSotIGoY+VvfI/izt2VGSPmUsYxqqUixtRetnKVJT1y2Wn2IPdBKeh17q63TY0W2raVo8zPOxBlb8zcGUTa4RjN4p03llA6iBlItrOCA+RJKTKu5FmU2HCvoqsb9DQH+OVC7vyjuXvF7bL5BQwvkhOA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(376002)(346002)(396003)(136003)(230922051799003)(1800799009)(186009)(64100799003)(451199024)(38100700002)(122000001)(82960400001)(36756003)(71200400001)(2616005)(26005)(83380400001)(38070700009)(86362001)(6512007)(6506007)(6486002)(478600001)(2906002)(66476007)(64756008)(54906003)(110136005)(66446008)(66946007)(76116006)(66556008)(8676002)(4326008)(41300700001)(5660300002)(8936002)(4001150100001)(316002)(81973001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RTlrTG1RSk8zMndXYXRocjh6VHpYdGE3S1VCOTZlOGhoYm9mQk1uejZ3YjZQ?=
 =?utf-8?B?V1dsSjRXWWtrWlMreUh0RTJoZ3hCNk9rcWVSakZCdjllazZ6TUczYWV4cUYz?=
 =?utf-8?B?azZ6ZzVTN3ZuNk9EbEJ1aVpTUm82Ungwc1hzdGpKRW0wTFdrZkhTYTByT05Z?=
 =?utf-8?B?L2ppK2lsUmhmYTM0d1lKbEI1bVdGaS84ZDdWL0hCNldOWVhIV2d3aE9CYlVa?=
 =?utf-8?B?N085bEtZWko1cmxETys5azFEeWZpMXFCQVFyczRCb1pnYjFXWWxkTGlOdjh6?=
 =?utf-8?B?ajBKUlVEN0kwdHJ2dFpUblVaeFpEMnQwRzFLcithRlQ2WXpIY0NmcDdQT0N3?=
 =?utf-8?B?ZmYvV0FieW9CclV5N0M5L2ZvSmNEZ2JReXZ5b01YeXhkRkFhVzlEbE5mbnVP?=
 =?utf-8?B?U1A5eDhnSFZZWk0yWnJEb2YxUG5QT2duR09vVWU2YjIvUUxlNmlIeDBydnE5?=
 =?utf-8?B?NXNhT2JKWnp4SFF0cUtwYUF3REJObGdEdkZRMVNtWDVqOUx6cmgzRnFFOWRM?=
 =?utf-8?B?UTFQY2VnVzZZUHdwekZvSVdudXI2byswdU9tNXdpVld4MWwwcUJrb2xhQjVI?=
 =?utf-8?B?M3ZGdUhmT0dUa2pyc1d4aDY4Nmhja1NsSjV4d2FibzRzbm5kV2xQVTNMaVd6?=
 =?utf-8?B?RFdYc0ZJWUk4Wm1JMnlXZHp0eFZ1UXA1RlBzdEh2Smx2NE9UenBjTVh0RU5V?=
 =?utf-8?B?L2QzcUcwUFNpcUNnSFQ5djJVdHRCcjNJbzFHdjBQZE44TGdoZk9OVk13YVh5?=
 =?utf-8?B?TGpKak9WZEJnKzRFSWRmVk0rSzN2NEFCOG5KTitKamNOV2o1TGhzWHRqdkxi?=
 =?utf-8?B?TGtESDJSclNFcU90RGt5SXR2ejZhL3hNT3E3b1lUUnpUNG4yRG1WV2puTHBi?=
 =?utf-8?B?M1I1RnM4V0owUTAzRFNLbXdRdEd3YktaQmVHZWcrSUdxcHljOWcwVXRpVHZO?=
 =?utf-8?B?NVUrU1dXLzJxYzZtRHBQYVIvOWx3cGhnMmhhLzVhdmtIcDliZUcvaFhzaDlv?=
 =?utf-8?B?ZzNKM2VZeEUyQzhjY08zdVRQdDJvaVgrOFBoMTgrVjIvY2s4SkY4N3BEYUJ6?=
 =?utf-8?B?Z1E4TENGYUwxSUdrYnR1a3owWDJkQXd4R3lOZ0VnWlg1VFRsNytJVSttSWQr?=
 =?utf-8?B?STltbXlFOEE0RWREUUhxcEJZcEYxUkp1K2xzSlBoMTJyRVI5U09CMExxS1dN?=
 =?utf-8?B?anpkeEo5NkQ3R3BJaTNWa2I1QkpKYXNXTFRLK1FiSG1Od3Y5cVZ0Ym9pc3lv?=
 =?utf-8?B?aU91cm8wL2o0cFU5T3ZFSHF0aDBVRm1uaHFMRDdsVm5tVFZ1bkJwVGFiMUdo?=
 =?utf-8?B?N1VjVklPRCtkQ2dMWEVzbFpQd2VIUGFPTW5LcmhQa0VMbzVNYm1sQmdVdzg2?=
 =?utf-8?B?eXJIT1krb1lvU1B3NkxlMlBTVlI2UVk5ZDhodUoycjhsZUFTY0tuVktrQmJJ?=
 =?utf-8?B?TTlITCtKaHdHSU5maTBncTVsUFQ2QWpsNUJIdlRSUXd4TXBscHpXTys2czNC?=
 =?utf-8?B?SHhWWnFDak9ybFhXaEJnVTdFM3ZoTDhVNXhEL1d6MlMvWTNrVW5mbTlCT3pm?=
 =?utf-8?B?MVU3cGpHOVVuenJaL3JUY1hPU2VFak1EcUVpRVRnalNwbzN3VFY3L1EvTW1H?=
 =?utf-8?B?c2EwK0kxQ1NnOXFGY2ZxT3dScUt6NE8zQW5ZR0o5RkhIV2FmaDc0U0l6S1N2?=
 =?utf-8?B?VjByYVFpZWMzdTRTb2ZRcUJIZ2F2LzNmYzlIV1ovWkkyMitsSkxDc1lmb2Fz?=
 =?utf-8?B?NE1vQmZ3QjVNWUd0TUVESWhqcGp5QzVNTFo1Ykk2Vkk3SWxTaXlkY1pVKzZx?=
 =?utf-8?B?V3NTN2Q2ckdFZEZVNTVaK1hmZzZUb0F5YUJHWkVrbTNpcGNxZTdNMDB6S05m?=
 =?utf-8?B?U0U1YjFGV1k1VW9iZW9jTDlpUXBERnpROEhwUG50czN1Y0czY0w2QXFFVWk4?=
 =?utf-8?B?bm16MnlveCsyOVZ1V21CaWlzQ2ZUNlpvMmxVY2dkalRmS1RnR3lvanhkRlhQ?=
 =?utf-8?B?eXhib2xncnZoRCs0R3lYWnVoQ0NHLzFrdDVHS3ZFMWRxOUxOSDVPcTlmeEtR?=
 =?utf-8?B?bkN2cW1VanlmcnNuUGRicHFGSSs4Y3ViWVVBZWE1c2RCaXIyekdEVjRseEcx?=
 =?utf-8?B?aVJ4cDZrZk1jNzNiZEFRbU1haWU0eGU4aUZOMGJFU1IrencwQ1FzcWVMSXZy?=
 =?utf-8?B?Tmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FC41717092AAEC44A118CB8F50A15CE9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de409aa1-b45b-4a4c-c970-08dbda35f7d4
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2023 17:22:32.8740
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HUBOWVKDJRnyyn/L9NGTyspaxyqLAAvgGgi2UDDomfDorXdC5sul/89yb2Rhc+Dlt+SEFL4MX/FB8pNvi/JorB0uQwbGGnqMxr0vNgAjINc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7713
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDIzLTEwLTMwIGF0IDE0OjQxICswODAwLCBDYW8sIFF1YW5xdWFuL+abuSDlhajl
haggd3JvdGU6DQo+IA0KWy4uXQ0KPiBBZnRlciBpbnZlc3RpZ2F0aW9uLCBpdCB3YXMgZm91bmQg
dGhhdCB3aGVuIGRpc2FibGluZyB0aGUgcmVnaW9uIGFuZCANCj4gYXR0ZW1wdGluZyB0byBkaXNh
YmxlIHRoZSBzYW1lIHJlZ2lvbiBhZ2FpbiwgdGhlIG1lc3NhZ2UgImN4bCByZWdpb246DQo+IGNt
ZF9kaXNhYmxlX3JlZ2lvbjogZGlzYWJsZWQgMSByZWdpb24iIGlzIHN0aWxsIHJldHVybmVkLg0K
PiBJIGNvbnNpZGVyIHRoaXMgdG8gYmUgdW5yZWFzb25hYmxlLg0KPiANCj4gDQo+IFRlc3QgRXhh
bXBsZToNCj4gDQo+IFtyb290QGZlZG9yYS0zNy1jbGllbnQgbWVtb3J5XSMgY3hsIGxpc3QNCj4g
Ww0KPiDCoMKgIHsNCj4gwqDCoMKgwqAgIm1lbWRldnMiOlsNCj4gwqDCoMKgwqDCoMKgIHsNCj4g
wqDCoMKgwqDCoMKgwqDCoCAibWVtZGV2IjoibWVtMCIsDQo+IMKgwqDCoMKgwqDCoMKgwqAgInJh
bV9zaXplIjoxMDczNzQxODI0LA0KPiDCoMKgwqDCoMKgwqDCoMKgICJzZXJpYWwiOjAsDQo+IMKg
wqDCoMKgwqDCoMKgwqAgImhvc3QiOiIwMDAwOjBkOjAwLjAiDQo+IMKgwqDCoMKgwqDCoCB9DQo+
IMKgwqDCoMKgIF0NCj4gwqDCoCB9LA0KPiDCoMKgIHsNCj4gwqDCoMKgwqAgInJlZ2lvbnMiOlsN
Cj4gwqDCoMKgwqDCoMKgIHsNCj4gwqDCoMKgwqDCoMKgwqDCoCAicmVnaW9uIjoicmVnaW9uMCIs
DQo+IMKgwqDCoMKgwqDCoMKgwqAgInJlc291cmNlIjoyNzExMTk4MTA1NiwNCj4gwqDCoMKgwqDC
oMKgwqDCoCAic2l6ZSI6MTA3Mzc0MTgyNCwNCj4gwqDCoMKgwqDCoMKgwqDCoCAidHlwZSI6InJh
bSIsDQo+IMKgwqDCoMKgwqDCoMKgwqAgImludGVybGVhdmVfd2F5cyI6MSwNCj4gwqDCoMKgwqDC
oMKgwqDCoCAiaW50ZXJsZWF2ZV9ncmFudWxhcml0eSI6MjU2LA0KPiDCoMKgwqDCoMKgwqDCoMKg
ICJkZWNvZGVfc3RhdGUiOiJjb21taXQiDQo+IMKgwqDCoMKgwqDCoCB9DQo+IMKgwqDCoMKgIF0N
Cj4gwqDCoCB9DQo+IF0NCj4gDQo+IFtyb290QGZlZG9yYS0zNy1jbGllbnQgfl0jIGN4bCBkaXNh
YmxlLXJlZ2lvbiByZWdpb24wDQo+IGN4bCByZWdpb246IGNtZF9kaXNhYmxlX3JlZ2lvbjogZGlz
YWJsZWQgMSByZWdpb24NCj4gW3Jvb3RAZmVkb3JhLTM3LWNsaWVudCB+XSMgY3hsIGRpc2FibGUt
cmVnaW9uIHJlZ2lvbjANCj4gY3hsIHJlZ2lvbjogY21kX2Rpc2FibGVfcmVnaW9uOiBkaXNhYmxl
ZCAxIHJlZ2lvbg0KPiANCj4gZXhwZWN0YXRpb246Y21kX2Rpc2FibGVfcmVnaW9uOiBkaXNhYmxl
ZCAwIHJlZ2lvbg0KDQpUaGlzIGlzIGJ5IGRlc2lnbiwgSSB0aGluayBpdCB3b3VsZCBiZSBtb3Jl
IGNvbmZ1c2luZyBpZiB0aGUgdXNlciBhc2tzDQp0byBkaXNhYmxlLXJlZ2lvbiwgdGhlIHJlc3Bv
bnNlIGlzICJkaXNhYmxlZCAwIHJlZ2lvbnMiLCBhbmQgdGhlbiBmaW5kcw0KdGhhdCB0aGUgcmVn
aW9uIGlzIGFjdHVhbGx5IGluIHRoZSBkaXNhYmxlZCBzdGF0ZS4NCg0KVGhlcmUgaXMgYWxzbyBw
cmVjZWRlbnQgZm9yIHRoaXMsIGFzIGFsbCBkaXNhYmxlLTxmb28+IGNvbW1hbmRzIGluDQpuZGN0
bCBhbmQgY3hsLWNsaSBiZWhhdmUgdGhlIHNhbWUgd2F5Lg0KDQpQZXJoYXBzIGEgY2xhcmlmaWNh
dGlvbiBpbiB0aGUgbWFuIHBhZ2UgbWFrZXMgc2Vuc2Ugbm90aW5nIHRoaXMNCmJlaGF2aW9yPw0K
DQo=
