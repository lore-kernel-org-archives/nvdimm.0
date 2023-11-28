Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF2C821A1A
	for <nvdimm@lists.linux.dev>; Tue, 28 Nov 2023 18:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UAMQ0I8+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701195230; x=1732731230;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=XDS9zK1G4p8ylP71NFGd0VKzuZj0Rud/wXtxEq4eVtY=;
  b=UAMQ0I8+XPHvA2Jdzz2VEjIV9ei8mJ42FYwlU5Df+tiAUF5MGD/QJOcz
   1F3fA5gEWnj0PubsaUCZALeQuu6ppUDhleHoufoteMQaB6lFjGW6q25f0
   avib2Nn+ej3RV9FXsmd0xcRwG7i+QOkCOCoeHq311EOZKsO23x5TuV6me
   VypX7QEeQVB0FvZZqYw5CvZ3hqWcnQT8b8wvrbr3jzYnktBRvsZnl9jyS
   OthZeC418L9egnYBXefBNccsce05dClTMOxsen4Yg7wmBE6FfR4mIDSDN
   2+pHuSpD/Gqy8si8CqeF21iCHgyXch7Nyu13aLMxoN1Qj3xt5Zfxosc5c
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10908"; a="378010016"
X-IronPort-AV: E=Sophos;i="6.04,234,1695711600"; 
   d="scan'208";a="378010016"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2023 10:13:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10908"; a="912526723"
X-IronPort-AV: E=Sophos;i="6.04,234,1695711600"; 
   d="scan'208";a="912526723"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Nov 2023 10:13:49 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Tue, 28 Nov 2023 10:13:49 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Tue, 28 Nov 2023 10:13:49 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Tue, 28 Nov 2023 10:13:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IEF812NsQurScfZxMOG5TP3//j8SpHZBw/kYj/NxzprGUH+gbSmBM1jyPy/ioKwc9H5T9e/fuAkM+aPOrFHTaCvHSv82FpkoqbznJNjEqd0t8GQnzrCYf1ZH6ikCMVMMom/dOdKZb0zNYLoQmEgYxhbWLC2bnal5Ld5ckvo5hoy4ExtEihywU9OD84MO37sb0dy8/4SWDFD6f4vXz4mgl8d2HWFTpPWhgbe/e5/KGk8Xio1Ij6Bg7PJS3XHZoDgfnb+JgN+PPb3FCeB6m1qKE+WSCG3Qfj7iJa+zwlkJxOhRYV0Oec2GJZt3wdpf4V89wNp8JFv6Y58Kpl5B67adJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XDS9zK1G4p8ylP71NFGd0VKzuZj0Rud/wXtxEq4eVtY=;
 b=HtixbsLKec7QXHcoAdqP8nRArUHVLHUnnX+Z00zXUsUq7J5mKA7bK9/f0Zv8IZEoBJ+9PRrws7U7zKj1Xfq5iiG8zSqHl6DQt2Z/r/7x4NLQhdhNsq+N9CUhkeAz+b9cxDssAKNa6JRHmLFQbrnE9qjnC3aRIScCdoFDfOS19TuKJQieFbHel5VPbeUHRQ45Cr9ebREkrRWuobf/S3o7TXiQkqEPdYNpS2nTGr4dW6bJtTyWZuv+FsEhK6jZCzTcg+UmZL4JAduJwic+iuJ3qmV2lY7bMqJ39S5dv07MMn7spwtF98wVd8EqLB401zAvK1E6DOVOELXe+d4WHlLAFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by CO1PR11MB4867.namprd11.prod.outlook.com (2603:10b6:303:9a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.22; Tue, 28 Nov
 2023 18:13:47 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::703a:a01d:8718:5694]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::703a:a01d:8718:5694%7]) with mapi id 15.20.7025.022; Tue, 28 Nov 2023
 18:13:47 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Jiang, Dave" <dave.jiang@intel.com>, "caoqq@fujitsu.com"
	<caoqq@fujitsu.com>
CC: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [NDCTL PATCH 2/2] cxl: Add check for regions before disabling
 memdev
Thread-Topic: [NDCTL PATCH 2/2] cxl: Add check for regions before disabling
 memdev
Thread-Index: AQHZ9w9ZQAZQ6v44DESU9sGmY2gHE7CPm/kAgADDKIA=
Date: Tue, 28 Nov 2023 18:13:47 +0000
Message-ID: <182f953bc0bc72688cca300084f5d90ea8265983.camel@intel.com>
References: <169645730392.624805.16511039948183288287.stgit@djiang5-mobl3>
	 <169645731012.624805.15404457479294344934.stgit@djiang5-mobl3>
	 <7eaf1057-2caf-8ec9-8b79-22ad4976ef76@fujitsu.com>
In-Reply-To: <7eaf1057-2caf-8ec9-8b79-22ad4976ef76@fujitsu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|CO1PR11MB4867:EE_
x-ms-office365-filtering-correlation-id: 91158191-58cd-4639-689c-08dbf03dc407
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yypsar9aZc+jsHgNcIQaws0wCz4jSZ7DsB27BTt0VjNFsfEZq4qJMRfJ1XmDBq56qxzneUgkKINMZC6g9Em+MHcOeXgwyoqLdY7OvzeoAsFPX+SJ4IiDAJKET/zT7oYsAClpFfrd0vUvqmV/bDbIgAo7tTtKBMtcFnEQYZ9PV9fI8jCZ4TB2vveBwrGiJfz9Qcxgz+ePK7lsP97RVzABDEIIoUi0M2/rA5wpzJm+FZhUe0pWFtbRseV4F3pvgs6aNfrp+LmJQCVfZevL/pScyKK8G4g32sxjb1U/LlJqrHARw4C6iEdZf0+mDSn+xcBGiv6EFoZIY07ZnCFmxtH3k2Bz1N8zCzChz1wX7xNCAkww0Nczq6b5zgu3j1L/4GGqY8q+MC+pbLO89x306WCkzib1DFuOmISWy2V2DcU0R9gAtpnL3qyxz3c54TFSco6CanuFCNi2BuiYtaUivzy/d2MLJZ3Dv31bZE3I+08/n8dZ9zdUll2jPclmjiT5Fs6TP13cOjtV6Xbf2GBnFEtIU1rCAGKmRSHg7S/SPd2Le9ihrbL9aVQB2Z8wq7sHR5ghtBdC7ot1+++xsvPgsZ1xjyy3jCjWlK/3XOl7ooC4sS9566fDiRxpBwCoh/Mpm0ru8wgFy42xWNXKN/uX4TDuGW/rnZcCh3XGQjDg+M+VMJY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(376002)(396003)(366004)(136003)(230173577357003)(230922051799003)(230273577357003)(186009)(64100799003)(1800799012)(451199024)(6512007)(2616005)(71200400001)(26005)(478600001)(6506007)(83380400001)(5660300002)(2906002)(41300700001)(4001150100001)(110136005)(76116006)(6486002)(66946007)(8676002)(8936002)(4326008)(54906003)(64756008)(66446008)(66476007)(66556008)(316002)(122000001)(82960400001)(38100700002)(38070700009)(86362001)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RWx2K0RxVUtUam1TZjNKekNXWjJiQXFSaE1xcmxQWEQ2MFdiMFN0cDdZQ2xD?=
 =?utf-8?B?RUwwM3pSL2VLK0gwSitPUmg0R2pOaTBNSndydkFlSGFIMWZnWC9ETHpEUGhP?=
 =?utf-8?B?QnUwN0JqOXVaRWVtR3hTT211NmdmQmNaVGhnOEphLzhYaWRNczZ3Y1RJVlJM?=
 =?utf-8?B?M0FuM2pWRFVuUHB6NFladEEzbStUcm82SjRCcGxnVlpKL29XcUIzQ21zZm5u?=
 =?utf-8?B?M2x0clkxWnlRMjRJaWFGeUJCcFNrYUZmM1A4am1mcGc0QUdpZk5jMGtQUUJ0?=
 =?utf-8?B?R09NdlB2YnNJU3I1NWh4cFpiOWR4Um1oUFB6VTJCZWEybkxJS3hCbnJ2dmV6?=
 =?utf-8?B?anJPbHNLOXBaQXF4bmhmWnhDcVdEMDhzYkpSNVBpMGtyS0NIWlkxaksyTTFx?=
 =?utf-8?B?QnUyK1BSajhpTDF4R2ZBQ3pvNkd2TXFJbFUybVQwd08vM2xUcTZ2WUZPdmto?=
 =?utf-8?B?bmZyWkhRU2hWYzZlaG54WlkwK2ZSQ01YQmZNSklGMjNsbSsySzZzaEpNdkZX?=
 =?utf-8?B?c3lwQW1kUVNRdFJMT01tcG9GT1h1a2szamtMSUlVdXpFMlloZityZGY5d1JJ?=
 =?utf-8?B?NmNtTzRrWXJzcSttSk9RRzBlRWxUVkRxTGdoaVYvQitvSk9tUUJFY3dMSDFF?=
 =?utf-8?B?M3lKT1R5aG9nOHNaRU1KcUJtcExkS0VIWlFtMlJzcUJkYnBHQmt5bnA3a3Jj?=
 =?utf-8?B?NC90d3ZFRml4NFlLWjdLR3lSakRyRXROMUFwanVGd1pOVWEwWjBkS0dUb09K?=
 =?utf-8?B?Q2VEeGxQTzBFNjZwVkZ5L0pPL3Z2Q1ZHdStLc0llampkVzJDWXViZ3piSzRQ?=
 =?utf-8?B?SVZ0TmVhZW14N3l6MkcySTJJNFBLeXR2bnA3bExQQzBwSy81WS9QNnJGY2FT?=
 =?utf-8?B?QlFKSkJtQUNVb1VlNlpNSmxkeWVyOWVKRTcwLzhNM3JoMEV4ZXI3MEErZHVO?=
 =?utf-8?B?bWx3WVpoMUh3TWlQeU4wamhzazRqUnBjT1NzZ3dqVSt6U002amtFdFdqNXNH?=
 =?utf-8?B?YXI0RkphWVVSWjAwaFlZbWRjRUFYK2xPYkcwb2dGdHBNMDN6T0hDOWhLTEcy?=
 =?utf-8?B?dHZxUWVwcDZ1Z25ickVTeXZ3YmM2TkM4TDV6cmpNZ0h3VWFDMFZJWThzNXlo?=
 =?utf-8?B?MmtLRFFMTzJUaTJ2VVRlL3BaV3BQNzM3VTBiK2FmZnFwM1dLKzBZelBObDZi?=
 =?utf-8?B?elBIclpYSU5Edk9oamp0R25XUytOdWJ0cThnSWk3QlhScWhmUjJzVUZJS0pI?=
 =?utf-8?B?b05RSGJwU1o4SUREZ3g4d2prN3NZUEpPOU9sVllJQ0pLM3dMbW1keFpKLzBp?=
 =?utf-8?B?REViaGNPZ1MybW5BSGMwVEM3azl3S3NodDlEQVVMM1NHU2JGUUxTc1l5TDJX?=
 =?utf-8?B?Z1diRldqQlZSbUJnMHErblZacUNaeGpsbDlkR01MbUFoR1VTbm9EbnBWSlU0?=
 =?utf-8?B?UHNKOENUcDFUeWlvMEpYaXJ5N295U2UyNmRHU25RLytZRXJnRmhBYWNXOGh3?=
 =?utf-8?B?SXFwa0QvdmNaWEF0aXA3OG9WSzhkWDZJM25lQllsSnl1cDJpUDZNNlZJaGI1?=
 =?utf-8?B?ZUNsMnVoaENmajdoZEUvZHNiNnQ0U1NZK1RYRERIS25keW42U0R1ZDJ5amdP?=
 =?utf-8?B?eUVLVGRDbm5CRGhsemhOVnI4UllwZndtalltbnM0SW5jWmpFYXJLdEVOcmZS?=
 =?utf-8?B?cUVVeEQ4TlkvaEJIMlpnMXZQZXZSU3ZXeXFuVU8vNzREUWludnpzb3lkalJ4?=
 =?utf-8?B?TlBoY2FXbGZIUHRsQ2E4YmNWM3l1WkpwVXFRZzAyaGZjQ1BMQ24xVGFKWHR6?=
 =?utf-8?B?eWZNbjhCK3RoZUxvUVVkSHZraThiWHl1VEVqSFFhQ1ozVldNTXVDQitmNHpB?=
 =?utf-8?B?ZEJzaGFwZlNnNFFUV0FhbytkVDBJWXc3Q2xpd3dPaVA3T1o0dGExVVMrSUdY?=
 =?utf-8?B?QnRiUzZyc1gxOS9vTkYxM1dYTnpQRW1idDR6aS9MS2U3Y1dCeGcyNjhuMXpE?=
 =?utf-8?B?d1N3bWdTSjN1bkdGV3VyM1lLbjB6L0RGMmJOak1XaWpRalQzdTNFWGtER210?=
 =?utf-8?B?NXBKTWI5U1pzRHYvOHRGYVp4NjJqU3VtM2RzRXgxR0tXSkhvbnhGUEJZSEF4?=
 =?utf-8?B?Zk5qbFZyR1N4M3pxTTBYRUhWRTNJRE5CV3c0VG5vb2lvdy9GdDhzaFE1VnNK?=
 =?utf-8?B?Wnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <39307B720F5BBF42BF8738442BFD9800@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91158191-58cd-4639-689c-08dbf03dc407
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2023 18:13:47.5038
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oeBERMxW0SifV0mo6ai+mDjFVVmdFot5rhW8xVB1Q+FlrJTRQWgZ/sINiOdtZ689y1gCAIHfwl7FuHgfDyP6/sB6KPVXyUtI/GataokSFqA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4867
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDIzLTExLTI4IGF0IDE0OjM1ICswODAwLCBDYW8sIFF1YW5xdWFuL+abuSDlhajl
haggd3JvdGU6DQo+IA0KPiA+IEFkZCBhIGNoZWNrIGZvciBtZW1kZXYgZGlzYWJsZSB0byBzZWUg
aWYgdGhlcmUgYXJlIGFjdGl2ZSByZWdpb25zIHByZXNlbnQNCj4gPiBiZWZvcmUgZGlzYWJsaW5n
IHRoZSBkZXZpY2UuIFRoaXMgaXMgbmVjZXNzYXJ5IG5vdyByZWdpb25zIGFyZSBwcmVzZW50IHRv
DQo+ID4gZnVsZmlsbCB0aGUgVE9ETyB0aGF0IHdhcyBsZWZ0IHRoZXJlLiBUaGUgYmVzdCB3YXkg
dG8gZGV0ZXJtaW5lIGlmIGENCj4gPiByZWdpb24gaXMgYWN0aXZlIGlzIHRvIHNlZSBpZiB0aGVy
ZSBhcmUgZGVjb2RlcnMgZW5hYmxlZCBmb3IgdGhlIG1lbQ0KPiA+IGRldmljZS4gVGhpcyBpcyBh
bHNvIGJlc3QgZWZmb3J0IGFzIHRoZSBzdGF0ZSBpcyBvbmx5IGEgc25hcHNob3QgdGhlDQo+ID4g
a2VybmVsIHByb3ZpZGVzIGFuZCBpcyBub3QgYXRvbWljIFdSVCB0aGUgbWVtZGV2IGRpc2FibGUg
b3BlcmF0aW9uLiBUaGUNCj4gPiBleHBlY3RhdGlvbiBpcyB0aGUgYWRtaW4gaXNzdWluZyB0aGUg
Y29tbWFuZCBoYXMgZnVsbCBjb250cm9sIG9mIHRoZSBtZW0NCj4gPiBkZXZpY2UgYW5kIHRoZXJl
IGFyZSBubyBvdGhlciBhZ2VudHMgYWxzbyBhdHRlbXB0IHRvIGNvbnRyb2wgdGhlIGRldmljZS4N
Cj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBEYXZlIEppYW5nIDxkYXZlLmppYW5nQGludGVsLmNv
bT4NCj4gPiAtLS0NCj4gPiDCoCBjeGwvbWVtZGV2LmMgfMKgwqAgMTQgKysrKysrKysrKysrLS0N
Cj4gPiDCoCAxIGZpbGUgY2hhbmdlZCwgMTIgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkN
Cj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvY3hsL21lbWRldi5jIGIvY3hsL21lbWRldi5jDQo+ID4g
aW5kZXggZjZhMmQzZjFmZGNhLi4zMTRiYWMwODI3MTkgMTAwNjQ0DQo+ID4gLS0tIGEvY3hsL21l
bWRldi5jDQo+ID4gKysrIGIvY3hsL21lbWRldi5jDQo+ID4gQEAgLTM3MywxMSArMzczLDIxIEBA
IHN0YXRpYyBpbnQgYWN0aW9uX2ZyZWVfZHBhKHN0cnVjdCBjeGxfbWVtZGV2ICptZW1kZXYsDQo+
ID4gwqAgDQo+ID4gwqAgc3RhdGljIGludCBhY3Rpb25fZGlzYWJsZShzdHJ1Y3QgY3hsX21lbWRl
diAqbWVtZGV2LCBzdHJ1Y3QgYWN0aW9uX2NvbnRleHQgKmFjdHgpDQo+ID4gwqAgew0KPiA+ICvC
oMKgwqDCoMKgwqDCoHN0cnVjdCBjeGxfZW5kcG9pbnQgKmVwOw0KPiA+ICvCoMKgwqDCoMKgwqDC
oHN0cnVjdCBjeGxfcG9ydCAqcG9ydDsNCj4gPiArDQo+ID4gwqDCoMKgwqDCoMKgwqDCoGlmICgh
Y3hsX21lbWRldl9pc19lbmFibGVkKG1lbWRldikpDQo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqByZXR1cm4gMDsNCj4gPiDCoCANCj4gPiAtwqDCoMKgwqDCoMKgwqBpZiAoIXBh
cmFtLmZvcmNlKSB7DQo+ID4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoC8qIFRPRE86
IGFjdHVhbGx5IGRldGVjdCByYXRoZXIgdGhhbiBhc3N1bWUgYWN0aXZlICovDQo+ID4gK8KgwqDC
oMKgwqDCoMKgZXAgPSBjeGxfbWVtZGV2X2dldF9lbmRwb2ludChtZW1kZXYpOw0KPiA+ICvCoMKg
wqDCoMKgwqDCoGlmICghZXApDQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJl
dHVybiAtRU5PREVWOw0KPiA+ICsNCj4gPiArwqDCoMKgwqDCoMKgwqBwb3J0ID0gY3hsX2VuZHBv
aW50X2dldF9wb3J0KGVwKTsNCj4gPiArwqDCoMKgwqDCoMKgwqBpZiAoIXBvcnQpDQo+ID4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiAtRU5PREVWOw0KPiA+ICsNCj4gPiAr
wqDCoMKgwqDCoMKgwqBpZiAoY3hsX3BvcnRfZGVjb2RlcnNfY29tbWl0dGVkKHBvcnQpICYmICFw
YXJhbS5mb3JjZSkgew0KPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgbG9nX2Vy
cigmbWwsICIlcyBpcyBwYXJ0IG9mIGFuIGFjdGl2ZSByZWdpb25cbiIsDQo+ID4gwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgY3hsX21lbWRldl9nZXRfZGV2
bmFtZShtZW1kZXYpKTsNCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVy
biAtRUJVU1k7DQo+ID4gDQo+ID4gDQo+IEhpIERhdmUsDQo+IA0KPiBCYXNlZCBvbiBteSB1bmRl
cnN0YW5kaW5nIG9mIHRoZSBsb2dpYyBpbiB0aGUgImRpc2FibGVfcmVnaW9uIiBhbmQgDQo+ICJk
ZXN0cm95X3JlZ2lvbiIgY29kZSwgaW4gdGhlIGNvZGUgbG9naWMgb2YgJ2Rpc2FibGUtcmVnaW9u
IC1mLCcgYWZ0ZXIgDQo+IHRoZSBjaGVjaywgaXQgcHJvY2VlZHMgd2l0aCB0aGUgb2ZmbGluZSBv
cGVyYXRpb24uIEluIHRoZSBjb2RlIGxvZ2ljIG9mIA0KPiAnZGVzdHJveS1yZWdpb24gLWYsJyBh
ZnRlciB0aGUgY2hlY2ssIGl0IHBlcmZvcm1zIGEgZGlzYWJsZSBvcGVyYXRpb24gb24gDQo+IHRo
ZSByZWdpb24uIEZvciB0aGUgJ2Rpc2FibGUtbWVtZGV2IC1mJyBvcGVyYXRpb24sIGFmdGVyIGNv
bXBsZXRpbmcgdGhlIA0KPiBjaGVjaywgaXMgaXQgYWxzbyBuZWNlc3NhcnkgdG8gcGVyZm9ybSBj
b3JyZXNwb25kaW5nIG9wZXJhdGlvbnMgb24gdGhlIA0KPiByZWdpb24oc3VjaCBhcyBkaXNhYmxp
bmcgcmVnaW9uL2Rlc3Ryb3lpbmcgcmVnaW9uKSBiZWZvcmUgZGlzYWJsaW5nIG1lbWRldj8NCj4g
DQpJIHRoaW5rIGl0IGlzIGJldHRlciBmb3IgYSBkaXNhYmxlLW1lbWRldiB0byBqdXN0IHBlcmZv
cm0gdGhlIGNoZWNrIGFuZA0KY29tcGxhaW4sIGluc3RlYWQgb2YgdHJ5aW5nIHRvIHVud2luZCBh
IF9sb3RfIG9mIHRoaW5ncyAtIGkuZS4gb2ZmbGluZQ0KbWVtb3J5LCBkaXNhYmxlIHJlZ2lvbiwg
YW5kIHRoZW4gZGlzYWJsZSBtZW1kZXYuIElmIHRoZXJlIGlzIGFuIGVycm9yDQppbiBvbmUgb2Yg
dGhlIGludGVybWVkaWF0ZSBzdGVwcywgaXQgY2FuIG1ha2UgaXQgaGFyZCB0byB0cmFjZSBkb3du
DQp3aGF0IGhhcHBlbmVkLCBhbmQgd2hhdCBzdGF0ZSB0aGUgc3lzdGVtIGlzIGluLg0KDQpJIGRv
IHRoaW5rIHRoYXQgdGhlIGN1cnJlbnQgLWYgYmVoYXZpb3Igb2YganVzdCB1bmJpbmQgdGhlIGRy
aXZlcg0Kd2l0aG91dCB0aGUgc2FmZXR5IGNoZWNrcyBzaG91bGQgY29tZSB3aXRoIGEgYmlnIGxv
dWQgd2FybmluZyBpbiB0aGUNCm1hbiBwYWdlIGF0IGxlYXN0IGFib3V0IHdoYXQgLWYgd2lsbCBk
bywgYW5kIGhvdyBpdCB3aWxsIHBvdGVudGlhbGx5DQpicmVhayBleGlzdGluZyByZWdpb25zLg0K
