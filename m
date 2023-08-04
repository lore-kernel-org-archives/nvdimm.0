Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A2B1DA48
	for <nvdimm@lists.linux.dev>; Fri,  4 Aug 2023 21:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691183005; x=1722719005;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=cfAFRR6ZvJMR1sY2APj5TVYal4hKAJH0/e6oahzVeDE=;
  b=fnAzN9/0k13HPr5hEB4wHm6Jiu5eOj4D8OvNCHMmZih1jpmsQfCABFlm
   JXR2LI3A0npecVgq8sZb7ZyozktV7d2+EHe+VQRsBvjzXmyMsozPqV2Km
   Gqw8zv4B3uBevSqN0el1psjkOYnA9YDoNWIRuyuOItLbvaycIl/h+DzYA
   tWC4901i3GWFuEdKpBh3Q6A6OV9OirDvBYd0JGC/SexrX75SSS9CM6yGc
   EYk4fHBu8CJ+dtC5tk7Kj1BQTFnWaHPLlh2M9aVU33Xnj0Qucy5UvJcCp
   YTas5KPoGmM2r1XN1l50e1hGKgVu3/kN8cUQ4duMxLH4IO95/B6mvlRsp
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10792"; a="350555667"
X-IronPort-AV: E=Sophos;i="6.01,256,1684825200"; 
   d="scan'208";a="350555667"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2023 14:03:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10792"; a="795570593"
X-IronPort-AV: E=Sophos;i="6.01,256,1684825200"; 
   d="scan'208";a="795570593"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga008.fm.intel.com with ESMTP; 04 Aug 2023 14:03:23 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 4 Aug 2023 14:03:22 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 4 Aug 2023 14:03:22 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.173)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 4 Aug 2023 14:03:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XAliH92iPO73xMhSzZg3wtIC0KiHhWMKB8dKifOZaYnDquJb0Sb7VMWcwW7cn+BpHbfpbU6r/m3AeohlHxAr+2Sdtj0hAuOk3TMFvUDltjpHwwdTE9XpzoVdJTmNwg64m0vKX1hj2K9kcmzpO4mMzJbT+NxLOPyOvIXtfEnX+u8g7MF891P/3jqRIhVOE9GERfujjAn+Ckdu8RRuP4SI7ySE78lLm4MrapFODNsyqXiFkIFfW0ZjqIWyaPGikQUbcUC9HXuVHabPYqYsm+GL2EuKdRo6xIbu5mZzUlteCNF6ZKaHwoN+aCkSvc6xKu0y7TmWP/139/DD2iXOBK/Lyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cfAFRR6ZvJMR1sY2APj5TVYal4hKAJH0/e6oahzVeDE=;
 b=RpTCi4bVHWUqv01WoUbzT3W3i4RtTjcN8fPutQ2jfSa0wwceLbxEWnbvGrSVNcf/BtMCYNJNi2oBbYaqiuyC6Dwe+7CSEim+BVas1KiJszVe1LiUB8P33wFBw8zx5E80jY1uc3JqypgE5ozuwC0C6xoIO9ZCgwrC9Kugjsm0ha+euZBTMjfukp6i2mdkmTFYbfhfG81LdM/t+QnUoHBDTXTIq/hZ0RriaOoluD4MoVUld9TkY3KukuNhh1NfYp4vHcoekz4Hzmao/xp0eb/dHUkyLHwjjadE/qJJVKGVZEJtEQIo+CbQQDaNC6oGkkJOVOLnYkIIrIaeEm+6lHNd9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by SJ0PR11MB4862.namprd11.prod.outlook.com (2603:10b6:a03:2de::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.21; Fri, 4 Aug
 2023 21:03:21 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::cb1f:f744:409c:69b3]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::cb1f:f744:409c:69b3%4]) with mapi id 15.20.6631.046; Fri, 4 Aug 2023
 21:03:20 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Jiang, Dave" <dave.jiang@intel.com>, "pankaj.gupta.linux@gmail.com"
	<pankaj.gupta.linux@gmail.com>, "houtao@huaweicloud.com"
	<houtao@huaweicloud.com>
CC: "houtao1@huawei.com" <houtao1@huawei.com>,
	"virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>, "hch@infradead.org"
	<hch@infradead.org>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"axboe@kernel.dk" <axboe@kernel.dk>, "mst@redhat.com" <mst@redhat.com>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"pankaj.gupta@amd.com" <pankaj.gupta@amd.com>, "kch@nvidia.com"
	<kch@nvidia.com>
Subject: Re: [PATCH v4] virtio_pmem: add the missing REQ_OP_WRITE for flush
 bio
Thread-Topic: [PATCH v4] virtio_pmem: add the missing REQ_OP_WRITE for flush
 bio
Thread-Index: AQHZtY0bO84/4sxsrEaPrHVAH4u2+a/amveAgAAoHgA=
Date: Fri, 4 Aug 2023 21:03:20 +0000
Message-ID: <47f9753353d07e3beb60b6254632d740682376f9.camel@intel.com>
References: <CAM9Jb+g5rrvmw8xCcwe3REK4x=RymrcqQ8cZavwWoWu7BH+8wA@mail.gmail.com>
	 <20230713135413.2946622-1-houtao@huaweicloud.com>
	 <CAM9Jb+jjg_By+A2F+HVBsHCMsVz1AEVWbBPtLTRTfOmtFao5hA@mail.gmail.com>
In-Reply-To: <CAM9Jb+jjg_By+A2F+HVBsHCMsVz1AEVWbBPtLTRTfOmtFao5hA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|SJ0PR11MB4862:EE_
x-ms-office365-filtering-correlation-id: c7c7568e-67b3-43cb-2249-08db952e3bdf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Up3kBWsxDUlpw5rs8vtVDmW96fcP9t/mIL94jgKGtk425FdZQ+s/dYfx91N9z27x/RItsze1KLv15203L1QhVrs56+V2/KPg2jF3IZ+Jf9y1e8/K2ld84CHmWk0e4HkmFe6dEwAGtV3cGBjY6L+lHryNfDNzCjXovl7TxcfSNop9eHRhZCvwMG6ImsnnbmI7nJHE5ClhZdjA2LIy1qJX5ICrH1EkreS2ym1bYE9WzFTTXD5qdCV5mRi0fu7ibZPcE7skEhpqo5vBT4NU8XK5SXNZYHTcrjCxf5z6GgUEsBwICz4Ym+StGjO1hdQo0k+kzXv8sK1wWCBVgJLfR5H/M4xKT7JI6fDIj4Uq0F55WYAE7YKPIBFtC1Pw5ukkyfHqMfriLm53FbXuvUnqMugiqv0yXgUL5xkGvYsBqkHZR1fteARgg1xEZQiJp3xX3E4ihXjZdaE+/EZ4+0yUhQtmu208CR5r6Jq2fUtovBrdAAX2CaCQmaAtVzcbmoqfJFORr0753iZWAL/6j9bsV6l0CGuIJE25o2iLOJf43uSwMs6/WuO/M07yBGvXFnCj5Gw+A0nlHONiBoqaTMRTJXbGlQP/UBNKovI5Gw13tzmqxf8BjgvAokI9piO/bMMvo76CtnSO1ElE0DxcoBV/tNSBxw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(346002)(376002)(396003)(366004)(1800799003)(186006)(451199021)(2906002)(7416002)(38070700005)(2616005)(36756003)(83380400001)(26005)(6506007)(86362001)(66556008)(64756008)(66476007)(66446008)(66946007)(76116006)(4326008)(38100700002)(41300700001)(316002)(6486002)(6512007)(966005)(45080400002)(82960400001)(54906003)(110136005)(122000001)(478600001)(8676002)(8936002)(5660300002)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eGhXU0JhdFNmVUdpTXlXU2JoWFVHTWRmMklSL2pLVjBrbCtpVVFGUjM4VnMr?=
 =?utf-8?B?VlkyUU0zdzZUUlBxYVRpUzNTc2NHQVVTZHlTVS90akxwU1ZpKzQvVEdmQzE0?=
 =?utf-8?B?RDdiM0l1Wml5YjdlQ1N0Q29XWXErbFdGeFJUZW9xSHRTcE9NVEJMLzh5ZGZv?=
 =?utf-8?B?eUI1WFNPNGY2NW11Q3RwRXB6eU90ZGRxUXBFOXdOa0FPMXkyTXd4Qk83aWQv?=
 =?utf-8?B?V2VXeXRTNXR0MGpoeVg1ekRSK2k2cFBrQkd6WTB6NXY1YTkvUDhacGtSeE9l?=
 =?utf-8?B?U0lFYVg2Vm9JaUFTNVREL0lkR1dnS0IrL2h5eWxzS0VPaElmek00UEppdnhV?=
 =?utf-8?B?R2owdml4OWpxd3YyMXFUc1dXaXVQT1UyWlhPc3dFcVpvNUFUMlZlcFg5OHRK?=
 =?utf-8?B?RlNaOVNlanMvVEllRWQ1dGgwWGdvNXZId2xVTEFrYW9VSXBOT1ZXb3RndUJB?=
 =?utf-8?B?dzRHb3VLSmpPUUMwdTU0NUZsVTBDSHprY08zNk9mdS9FZ0dwMXZxN0czUXNh?=
 =?utf-8?B?SWdxRFlxQ3d5L3FYOFhOVVpLQXZRZDhXM3c3akdnaHNlcE5GaFp1enVaVEFj?=
 =?utf-8?B?emRlYmpRRDlVOVE2d3E2Lyt6cG9iajVMWkJsZVZxZEFMS1Frd2VwSVBnUnFO?=
 =?utf-8?B?OWJaVk1CTmtZb0k4SE5iMUR3Q01qS1g5eEk5NnhkckhEMUdFSUYzSzlBVlVZ?=
 =?utf-8?B?N2RrbTdOUk9UZjNqZHkwejkvZ3ppK1d1ZDZTV1ZkVlVYb1BrdUd1WGV0RkJY?=
 =?utf-8?B?V0lVLzdvUk4xSzNvYU81eTZRN2NoN3ZRQ0FLRWhtYkIvVDdIZnJodHZkR0s2?=
 =?utf-8?B?WFBXOEdQYWdnakpMeUVNd1lWdGxZTjhRQ3MwZ2NleGlrT1JweUlva3pOZEFt?=
 =?utf-8?B?K2ttbnYwQlF2Y3RWWUNzZXNSMUpWS2xvLzMvUC94SWNEaTZNMWttbWthODlF?=
 =?utf-8?B?WUR3S2p5SnptUS9tS1R2SVVXV29CZTVDa053WGJtRmpaNUNhbFNBSzAzVk1J?=
 =?utf-8?B?eG5rWlhlOWY3Q2pVMFFwY1VEclJTUWZvVityN0tCbEpRSm1LeGl3eG90NUth?=
 =?utf-8?B?OC9QY0JHNk1IVEpXeDdCS0hDclVqRWgwY09HUXpyazA2VmJDWUkvY3IxTjZx?=
 =?utf-8?B?bWN6S0o1K1NwdjI3TGdjczA2YWV2WWdVZzhoRHFBd1JZWDZqMTB2Uk9UVVlx?=
 =?utf-8?B?TTQ3V0tTZ2FoY3JtYmRCeWhzT0lRd3ZJWEZEcnkyMllKUUxZalFFcmtDb1pw?=
 =?utf-8?B?cS9jZHliL1liOUc3QmNuTEdZM3pqTGtLV0YrMldqOGtrSExOOFVXUTdHby9F?=
 =?utf-8?B?VE5EcTZsZ3I5dmwwMHk0dm56ZkFGYXFBRmh2Szh1c2JKOUJ0M0hTdWZWRHpw?=
 =?utf-8?B?UW1TYVNBU1VYTXlES1BPY214aTdDRFlQRWJtVFRnaGVPTWNDQ3ZFWWNVbjFp?=
 =?utf-8?B?TEI3cU1lT3JkTVNrcFJYdVp6QlFPOFRUZzNCM01SUEI0cmtxdCtXNzhXeERz?=
 =?utf-8?B?cGQ3bzhQN01KNmo3MDJMRDRIS3ZNMjV3L216OXNXU01uOWN0V1dUaEo0Zmtv?=
 =?utf-8?B?OWZFNE9Wa3pMeHVSMXJQM1BEd21lT25zdnhhQ3JhaFEvYmtMdGdBOGI3Ym0w?=
 =?utf-8?B?aURhL1hJdGYySDdjb3VGelErV0VLVFRhMEw3NWczTG1jeG5lM1RkZnJnL09G?=
 =?utf-8?B?aFhkSWlOU2pCaCtkS0VPRTJnZkVxZXJLMjFWaWlUVTBtYWRIa2xmU0tHL3Rw?=
 =?utf-8?B?S3QwTXE1c1VRSlIrd0dqZC9qOTVCbmI0ZmhoY0pVdHo5dTdIZTlqNzFYQTVk?=
 =?utf-8?B?ekVPNVBkY3g3Z09qaWg2QTg5WFRnN3EzWTZCMU1JN0ZpUFp1ZUVwa0Y3SmtQ?=
 =?utf-8?B?UmRMNWI5UC82cnNiWU9Tb1pKMmtoRDM2U1htR2d2Vm1hVVBWdXdoOFIvdDNI?=
 =?utf-8?B?MWVwRUJyMkdMTU10NTZVakQyWHJoc3pWZER3VGFSZUY0Q2xDMUpwSDVYQ3N5?=
 =?utf-8?B?L09FRkQxQkd1MFM5b1FNRTkvTitCSzhZUzhTdkp2M3lpZ2dscjVRNkp5RGFj?=
 =?utf-8?B?SWdqdmRmbnhqU3hCRUZOK3NycElhc1U3SW9BTVJLZm5TdmEwdCtyYTZRV1Zy?=
 =?utf-8?B?QmliTDVEWWpwMU5QV25RTzY3YkVlYlkxRjQyZWNzeHpRcnBqMm8zSngxbUg1?=
 =?utf-8?B?RUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B4ED3DE15D1368459096A25DF29DA630@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7c7568e-67b3-43cb-2249-08db952e3bdf
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2023 21:03:20.8443
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S5dibtRQfyaoP2qaxviAihDq/MeGHpfjeD/AAQyw0NGSjKWuusE0YDCl2YT9Bk3npRgTaqy8W8upOhnrZ8CJQFseiDL0GcTGgi8QE+yjdlA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4862
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDIzLTA4LTA0IGF0IDIwOjM5ICswMjAwLCBQYW5rYWogR3VwdGEgd3JvdGU6DQo+
IEdlbnRsZSBwaW5nIQ0KPiANCj4gRGFuLCBWaXNoYWwgZm9yIHN1Z2dlc3Rpb24vcmV2aWV3IG9u
IHRoaXMgcGF0Y2ggYW5kIHJlcXVlc3QgZm9yIG1lcmdpbmcuDQo+ICtDYyBNaWNoYWVsIGZvciBh
d2FyZW5lc3MsIGFzIHZpcnRpby1wbWVtIGRldmljZSBpcyBjdXJyZW50bHkgYnJva2VuLg0KDQpM
b29rcyBnb29kIHRvIG1lLA0KDQpSZXZpZXdlZC1ieTogVmlzaGFsIFZlcm1hIDx2aXNoYWwubC52
ZXJtYUBpbnRlbC5jb20+DQoNCkRhdmUsIHdpbGwgeW91IHF1ZXVlIHRoaXMgZm9yIDYuNi4NCg0K
PiANCj4gVGhhbmtzLA0KPiBQYW5rYWoNCj4gDQo+ID4gRnJvbTogSG91IFRhbyA8aG91dGFvMUBo
dWF3ZWkuY29tPg0KPiA+IA0KPiA+IFdoZW4gZG9pbmcgbWtmcy54ZnMgb24gYSBwbWVtIGRldmlj
ZSwgdGhlIGZvbGxvd2luZyB3YXJuaW5nIHdhcw0KPiA+IHJlcG9ydGVkOg0KPiA+IA0KPiA+IMKg
LS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tDQo+ID4gwqBXQVJOSU5HOiBDUFU6
IDIgUElEOiAzODQgYXQgYmxvY2svYmxrLWNvcmUuYzo3NTEgc3VibWl0X2Jpb19ub2FjY3QNCj4g
PiDCoE1vZHVsZXMgbGlua2VkIGluOg0KPiA+IMKgQ1BVOiAyIFBJRDogMzg0IENvbW06IG1rZnMu
eGZzIE5vdCB0YWludGVkIDYuNC4wLXJjNysgIzE1NA0KPiA+IMKgSGFyZHdhcmUgbmFtZTogUUVN
VSBTdGFuZGFyZCBQQyAoaTQ0MEZYICsgUElJWCwgMTk5NikNCj4gPiDCoFJJUDogMDAxMDpzdWJt
aXRfYmlvX25vYWNjdCsweDM0MC8weDUyMA0KPiA+IMKgLi4uLi4uDQo+ID4gwqBDYWxsIFRyYWNl
Og0KPiA+IMKgIDxUQVNLPg0KPiA+IMKgID8gc3VibWl0X2Jpb19ub2FjY3QrMHhkNS8weDUyMA0K
PiA+IMKgIHN1Ym1pdF9iaW8rMHgzNy8weDYwDQo+ID4gwqAgYXN5bmNfcG1lbV9mbHVzaCsweDc5
LzB4YTANCj4gPiDCoCBudmRpbW1fZmx1c2grMHgxNy8weDQwDQo+ID4gwqAgcG1lbV9zdWJtaXRf
YmlvKzB4MzcwLzB4MzkwDQo+ID4gwqAgX19zdWJtaXRfYmlvKzB4YmMvMHgxOTANCj4gPiDCoCBz
dWJtaXRfYmlvX25vYWNjdF9ub2NoZWNrKzB4MTRkLzB4MzcwDQo+ID4gwqAgc3VibWl0X2Jpb19u
b2FjY3QrMHgxZWYvMHg1MjANCj4gPiDCoCBzdWJtaXRfYmlvKzB4NTUvMHg2MA0KPiA+IMKgIHN1
Ym1pdF9iaW9fd2FpdCsweDVhLzB4YzANCj4gPiDCoCBibGtkZXZfaXNzdWVfZmx1c2grMHg0NC8w
eDYwDQo+ID4gDQo+ID4gVGhlIHJvb3QgY2F1c2UgaXMgdGhhdCBzdWJtaXRfYmlvX25vYWNjdCgp
IG5lZWRzIGJpb19vcCgpIGlzIGVpdGhlcg0KPiA+IFdSSVRFIG9yIFpPTkVfQVBQRU5EIGZvciBm
bHVzaCBiaW8gYW5kIGFzeW5jX3BtZW1fZmx1c2goKSBkb2Vzbid0IGFzc2lnbg0KPiA+IFJFUV9P
UF9XUklURSB3aGVuIGFsbG9jYXRpbmcgZmx1c2ggYmlvLCBzbyBzdWJtaXRfYmlvX25vYWNjdCBq
dXN0IGZhaWwNCj4gPiB0aGUgZmx1c2ggYmlvLg0KPiA+IA0KPiA+IFNpbXBseSBmaXggaXQgYnkg
YWRkaW5nIHRoZSBtaXNzaW5nIFJFUV9PUF9XUklURSBmb3IgZmx1c2ggYmlvLiBBbmQgd2UNCj4g
PiBjb3VsZCBmaXggdGhlIGZsdXNoIG9yZGVyIGlzc3VlIGFuZCBkbyBmbHVzaCBvcHRpbWl6YXRp
b24gbGF0ZXIuDQo+ID4gDQo+ID4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmfCoCMgNi4zKw0K
PiA+IEZpeGVzOiBiNGE2YmIzYTY3YWEgKCJibG9jazogYWRkIGEgc2FuaXR5IGNoZWNrIGZvciBu
b24td3JpdGUgZmx1c2gvZnVhIGJpb3MiKQ0KPiA+IFJldmlld2VkLWJ5OiBDaHJpc3RvcGggSGVs
bHdpZyA8aGNoQGxzdC5kZT4NCj4gPiBSZXZpZXdlZC1ieTogQ2hhaXRhbnlhIEt1bGthcm5pIDxr
Y2hAbnZpZGlhLmNvbT4NCj4gPiBSZXZpZXdlZC1ieTogUGFua2FqIEd1cHRhIDxwYW5rYWouZ3Vw
dGFAYW1kLmNvbT4NCj4gPiBUZXN0ZWQtYnk6IFBhbmthaiBHdXB0YSA8cGFua2FqLmd1cHRhQGFt
ZC5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogSG91IFRhbyA8aG91dGFvMUBodWF3ZWkuY29tPg0K
PiA+IC0tLQ0KPiA+IHY0Og0KPiA+IMKgKiBhZGQgc3RhYmxlIENjDQo+ID4gwqAqIGNvbGxlY3Qg
UnZiIGFuZCBUZXN0ZWQtYnkgdGFncw0KPiA+IA0KPiA+IHYzOiBodHRwczovL2xvcmUua2VybmVs
Lm9yZy9saW51eC1ibG9jay8yMDIzMDYyNTAyMjYzMy4yNzUzODc3LTEtaG91dGFvQGh1YXdlaWNs
b3VkLmNvbQ0KPiA+IMKgKiBhZGp1c3QgdGhlIG92ZXJseSBsb25nIGxpbmVzIGluIGJvdGggY29t
bWl0IG1lc3NhZ2UgYW5kIGNvZGUNCj4gPiANCj4gPiB2MjogaHR0cHM6Ly9sb3JlLmtlcm5lbC5v
cmcvbGludXgtYmxvY2svMjAyMzA2MjExMzQzNDAuODc4NDYxLTEtaG91dGFvQGh1YXdlaWNsb3Vk
LmNvbQ0KPiA+IMKgKiBkbyBhIG1pbmltYWwgZml4IGZpcnN0IChTdWdnZXN0ZWQgYnkgQ2hyaXN0
b3BoKQ0KPiA+IA0KPiA+IHYxOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1ibG9jay9a
SkxwWU1DOEZndFowazJrQGluZnJhZGVhZC5vcmcvVC8jdA0KPiA+IA0KPiA+IMKgZHJpdmVycy9u
dmRpbW0vbmRfdmlydGlvLmMgfCAzICsrLQ0KPiA+IMKgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0
aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL252
ZGltbS9uZF92aXJ0aW8uYyBiL2RyaXZlcnMvbnZkaW1tL25kX3ZpcnRpby5jDQo+ID4gaW5kZXgg
YzZhNjQ4ZmQ4NzQ0Li4xZjhjNjY3YzZmMWUgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9udmRp
bW0vbmRfdmlydGlvLmMNCj4gPiArKysgYi9kcml2ZXJzL252ZGltbS9uZF92aXJ0aW8uYw0KPiA+
IEBAIC0xMDUsNyArMTA1LDggQEAgaW50IGFzeW5jX3BtZW1fZmx1c2goc3RydWN0IG5kX3JlZ2lv
biAqbmRfcmVnaW9uLCBzdHJ1Y3QgYmlvICpiaW8pDQo+ID4gwqDCoMKgwqDCoMKgwqDCoCAqIHBh
cmVudCBiaW8uIE90aGVyd2lzZSBkaXJlY3RseSBjYWxsIG5kX3JlZ2lvbiBmbHVzaC4NCj4gPiDC
oMKgwqDCoMKgwqDCoMKgICovDQo+ID4gwqDCoMKgwqDCoMKgwqAgaWYgKGJpbyAmJiBiaW8tPmJp
X2l0ZXIuYmlfc2VjdG9yICE9IC0xKSB7DQo+ID4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgc3RydWN0IGJpbyAqY2hpbGQgPSBiaW9fYWxsb2MoYmlvLT5iaV9iZGV2LCAwLCBSRVFfUFJF
RkxVU0gsDQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc3RydWN0IGJpbyAqY2hp
bGQgPSBiaW9fYWxsb2MoYmlvLT5iaV9iZGV2LCAwLA0KPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIFJFUV9PUF9XUklURSB8IFJFUV9QUkVGTFVTSCwNCj4gPiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgR0ZQX0FUT01JQyk7DQo+ID4gDQo+ID4gwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlmICghY2hpbGQpDQo+ID4gLS0NCj4gPiAyLjI5LjINCj4g
PiANCg0K
