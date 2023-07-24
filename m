Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46EFDDC8
	for <nvdimm@lists.linux.dev>; Mon, 24 Jul 2023 21:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690233425; x=1721769425;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=HbnFXk4geg38JyHxzVQhkXiCCbyfRaiDEGLCaTIsuCo=;
  b=ZMnaKcdThg4ekv34sGI38wEwNq6MSS7T1UagTlylFLZw8semjk9Tmexx
   woDwgdaRuyFhTgoMDsqFDCN3ZmBTG8bQ1Ycef2qTex3F0+SHams75UjGH
   wyKzTA85h+9AJlRhHaknpQhGhspEFnVBlfm64TSyQh5miImyHU+4Zl1Fh
   M7O7kx9wKDdE1loNL/btKEZsbyr1QK+I0S0iqsvATvbw5vKLsv+Sd2MWu
   Lns+2oj10KKV+cRDW96B4YhPmnQT8OcjiHw/62YJJfyMJ1GtpXHAxBJB9
   MRXv1Zes/ijJkPXlPTghA1Vz8oedIqHiY/s/wcT8AuMX4EfglJ9Y5pMgs
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10781"; a="433798927"
X-IronPort-AV: E=Sophos;i="6.01,228,1684825200"; 
   d="scan'208";a="433798927"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2023 14:17:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10781"; a="703033923"
X-IronPort-AV: E=Sophos;i="6.01,228,1684825200"; 
   d="scan'208";a="703033923"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 24 Jul 2023 14:17:02 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 24 Jul 2023 14:17:02 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 24 Jul 2023 14:17:02 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 24 Jul 2023 14:17:02 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 24 Jul 2023 14:17:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aP71/s9SSF4ULfQdhjKsWkPLXU/yxtaKAMHsq8taz6ueyDxchfLpsCLMgJrio6wMl3CYUMC6ItK3s1Qk8zQIEXbuvM/Kru/ZRUCoWww8eON1J5RBdkxkVnHvN7OAzRgikTc1QoP/y6sy9LvulxIUYja7oPoFXluES0cexTc919LXMQ9eLJ9b3hhalqJbrxseybqoGmAhyLtxy/ewDmermyraczAyGP1RrQSMES3Ah3d2QihOALj9gc1BrNLS/gSWXtztAaliBJsYiPrBZJwG6upHGV2o6N95tXIRBhtXUo/5hBJd4xSVFlCKmFWZgINEZJ3NbXXZgs/7s6fqBSmPrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HbnFXk4geg38JyHxzVQhkXiCCbyfRaiDEGLCaTIsuCo=;
 b=KKdNVBaj0pgfh7zDv24CgHTxy2c6t5FsBSOMuTn3YNe8qlOG8TjtCsdcWvARDOisy53NYH6v4mXs44YGTMl65Av6zT55KzTHKEH6I7BlBWovf9/4oVZoqPPd5M7uFUOYcNgVncReIsOS9jdUhygpiIwF6EantrSfhBQALxW0/U2dZb9JMqFxvH9T4ad5urg/OKlilDDRnlXoqr5F9cUWao4VKC0nZDM93htkt9kiMDGWCORKarHIlmTKXE2+afJigTeDvi/Z+WHEujHtFTUhub2ldzAzJNWEkiD4jaM3+mtXQywolISWAoIICjNkyreovCYrnf5BX190Ggx/ecQj9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by SA1PR11MB6869.namprd11.prod.outlook.com (2603:10b6:806:29c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.30; Mon, 24 Jul
 2023 21:16:59 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::e527:d79c:2bb3:e370]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::e527:d79c:2bb3:e370%2]) with mapi id 15.20.6609.032; Mon, 24 Jul 2023
 21:16:59 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "yangx.jy@fujitsu.com" <yangx.jy@fujitsu.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
CC: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
Subject: Re: [NDCTL PATCH] cxl/region: Always use the correct target position
Thread-Topic: [NDCTL PATCH] cxl/region: Always use the correct target position
Thread-Index: AQHZq2WYV+4sC9Wz3EeQGEbvgBUSM6+xYGCAgBgxMAA=
Date: Mon, 24 Jul 2023 21:16:59 +0000
Message-ID: <7920fe6383b1e4e53a3ea21845abaad3137a570f.camel@intel.com>
References: <20230630151245.1318-1-yangx.jy@fujitsu.com>
	 <697878b5-ecea-3172-695c-db9191548216@fujitsu.com>
In-Reply-To: <697878b5-ecea-3172-695c-db9191548216@fujitsu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|SA1PR11MB6869:EE_
x-ms-office365-filtering-correlation-id: a6e2fa29-b078-410c-f07a-08db8c8b5138
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2Y0fBd7b/tM9bBrdrykwHc7cEGv8+I0/ob/67WNKMD4X4ushLX8uPff4PJaKcnRYFGiD0HlbP7ascdTc/d/cpkvJMzM5cOfSVfSP1s3ErAfaNBJONzxcIj2PmLMr6IhZk8mhPJcpQQRzIIFVlJJK0qMAnYuMHy0OgL3d4DzMB3muA6wAq+r8AG2TADNWBkFsaVG8namoxPs+L3CgQgn1PkT+OvxVBr9D2/kAQEa+voVokaj6pp6LZKFR/TeqXXn8OT0sds8p8oh3Q+Ucgajhc0TKRlqIesRytLX+VOrNogPOODG97lM5aFAKtPvsVwIosUn43vBsdb4brBNGmhg5ywm+FxNPMd4Wmu/GGh5zXuiIVpXFqLejgjZ6rD4u0oRQSrbUhuYBVwyAi77v4xanaMKH72d8A7yl/SOtJCvTVsGANWorX1d0yVzXXw2ZR+1XAu2R/vpojBIpn6JV7qIxaOARIRGePhMvYgvt2qhH/S9FMS++7nQqgUaZFR+Eye3Zd9W8HCGVRQhKeg/V3q5gVhFLE5xhTrFUIWEX6Bl2nSFKfns6a9Cb5w2B+vX6bPG9+3TzsyDOTsGfY0MQ9SwRY6uEV614cWlq6zezIQKDSyuwt2dUtwlL2jmRsAWWeoAu
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(376002)(39860400002)(136003)(346002)(451199021)(53546011)(6506007)(41300700001)(186003)(83380400001)(26005)(478600001)(71200400001)(2616005)(6512007)(38070700005)(2906002)(6486002)(36756003)(86362001)(5660300002)(64756008)(66476007)(66946007)(76116006)(122000001)(4326008)(66446008)(66556008)(8936002)(8676002)(316002)(82960400001)(38100700002)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V2J5UTlZekw1WGZqWHNyZmJJZElPdzl2c1MydUdubzdwY2NTSGFjaHJPdEdi?=
 =?utf-8?B?c2FVVnB2ZXl1TGdIZG9BVTFHaDh5Y2xjdFBDRUlJWVVsREtFY2ZRQlEwY2VP?=
 =?utf-8?B?UzVwSlBpWU1kRENWclh5aEVTQkFsdTd6eTI5VlZSOFkxMmN5SEZIeEhobVVw?=
 =?utf-8?B?ekhvZGRYWi96RVRzanpWeUVsdnVvWk5UWi9yWVRjb3VFeTYzRzh2REluek9X?=
 =?utf-8?B?UnMvczhEL3FJcWYvYitNZFROcytPYVRzSFhkdDRTOVV1TFAwdy9uMEdySWcy?=
 =?utf-8?B?Y1ZEV1hyRGI1QzJ4d1JtL3FQZm03OUJ3V3lWY2tsSUg4NFFaSWRab3NjWFcy?=
 =?utf-8?B?ckRIaVNsaGovS05NYldZWnBoaUVhMkZzOFI0WUt2RnR5bzhBVURudTZCd2k2?=
 =?utf-8?B?QUsrSkRxUzJXMEdXb25xczROUWNlK3ZaclI4bmV4Y25mRFRDN2RnbDUyeFNM?=
 =?utf-8?B?eEwrMmtQWW0yMjltQ1RmWDVtUlRUTmo2c0dQM1BVTDZNWHdrV0hBMUYra1Bn?=
 =?utf-8?B?bWtsMTFvMmNZVjFJd0FVMlZsc0QzN2R1Y1paMzBGU21NaGxQS3RiY2tBMDFv?=
 =?utf-8?B?Q01HcW5lbElRTi9LdDBIVHFoQ3ZNNDdWS1k3U0lSZkdpK3RRS1FLcHQ3VG9r?=
 =?utf-8?B?V3dTNkpiOEJEUUdMcjFXcERkSTB4RnczRFBCZlVLZUEwUk96QlJvakk4SGxY?=
 =?utf-8?B?TitLQkhONC8zR3lOcGRod2ZEdEcwUFFqbzNkZHB2NUFJdG5mSzBmUmFBb1ZC?=
 =?utf-8?B?eVpBdE5Zd3RvMVFBZmRiWm03WU9jRWJNblJLK3hKWnB0bXFUY1pzaHB4dnNL?=
 =?utf-8?B?Zno4UXZhR041eFRyd00vUWVOWkFjS3hyMGM0VE5xOUFZVnQ0aEs1QXIzWkh0?=
 =?utf-8?B?NU5XR2QrOXhCN0NoazRZWVg3alBtRm1MZXpyeVo1dGNaNmFCMVVhbFROZU1G?=
 =?utf-8?B?TkZSL3pFa2xsV2JyZ0xVUFpNSytVVFpjWkt2dWRTWUxFTU1TRHNLZHd1UmxG?=
 =?utf-8?B?cmVoekJtNElSakZ6YUxBTVNuQ1dGNmN4V016dGdFQzZPVHphN2ptQ2plS3RF?=
 =?utf-8?B?NlhBc3Z4WmNvOUZZTUdhbUtQTmJmUkQxd0VIN2NaTVJyS2tHdkRxRlgyUmli?=
 =?utf-8?B?cDNKRm0wMDErWlhMM1R4SWZLMXJ0QTMwZG83Q3VjaTZMUkF3L3JGWmh3REhO?=
 =?utf-8?B?M0pvQlp5WlN0REZhZHUwbm11TXEvUmIzTmRXdGJLQ3JCWEpWcDBLOE9ldkdk?=
 =?utf-8?B?SkJrWGV1S2t0WWU3azNLWHVua0p2NmdXeWdZbkZ5dWUzeHFmNUJtMlBEL0lI?=
 =?utf-8?B?N1dRelA1RDc4QjQrdThiMXZ3Rm53Qjg3TS95Z1p1ZnpTYnN0OXg5dXR0UnB2?=
 =?utf-8?B?MFhiSHZrK29QYjl3RFpjZFNlSGVnTnlhWEQ0VHNKbzRNVXVoZ1orYVgwSzZt?=
 =?utf-8?B?RnJJZnp1TWpaV0JSajdlVktxUWlVSG04cmhMYkppcXg4Rkc1QTdOeGhYYkFj?=
 =?utf-8?B?VDFGdlA1VWlGT3Rlem1qeFJTT3lPZzhsbE1lZ3pUd0NPY2hRQ245WHgyT2NC?=
 =?utf-8?B?THAwSlRzWEN2ZU9jK1NsYVJPeE9naEhMdUNjMUpQcmRZMDBFNVYwZzJlUUUw?=
 =?utf-8?B?QXV3NkFuY1BSZjcydHY1UEMvT2lwbWpHV2xmbjZidjRHVXAxa0tncjkxZUx6?=
 =?utf-8?B?NUxJUWNjVk8yTzBhdWdSaUphWmMzQ3plMXM0ckZ6SGlNOWtHa2FKYVkyUDRV?=
 =?utf-8?B?WEF0d2Z5UnJYTXd5b0N4NHJReTk2Wmw2WGx1L0Y5TU1PWUN0MTVkWkVYOSt5?=
 =?utf-8?B?T0FhNzY1U3Frd0QxZnNaSWNPY2plS3FDam1SYzFUNXNtMVgyMUFMVGpwcGFw?=
 =?utf-8?B?Rm1xYTh4QWF6UStMZ25XYjNCZkR3WlY1UUlnTjhHM0Nkb29Ma3pHQnh3VWNn?=
 =?utf-8?B?WmNpOWRCaTlRRkoyblRqeHZMNzg5RmttVmNPOEFNTHlsWU9KNjNzNC9EblpB?=
 =?utf-8?B?Vk4ySGJxNUN5R1M3LzE3NEJmTFRyYXNTMXpLbXJDcDB2cnd2aXBUUkl0Vk5p?=
 =?utf-8?B?US9YT0ZmOHRGa0oyTFc5Q3N0bmtFUG1qMEJnWWlWKzNzd2JaaE04Ui8yZ3JL?=
 =?utf-8?B?UkorMmRPeVk4cFdFaFhrcmUvZ0t3di80aDlIQTk5RDFvU1N6RzB1eTZ6bTlB?=
 =?utf-8?B?VEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9C1E8D308D73874E84EA3FD03820FFBD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6e2fa29-b078-410c-f07a-08db8c8b5138
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2023 21:16:59.3612
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ko2wXhj0PeLZpElrOfJ4tZ+Mh5y28UmY6TbjIzxFqU3PVC9ddoGQqzuhmJQtIiya9WZCuOVwbkt6x6cOnMLVk4CAl2OsK+7IhtWtz46wpUU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6869
X-OriginatorOrg: intel.com

T24gU3VuLCAyMDIzLTA3LTA5IGF0IDE5OjUwICswODAwLCBYaWFvIFlhbmcgd3JvdGU6Cj4gSGkg
YWxsLAo+IAo+IEtpbmRseSBwaW5nLgo+IAo+IFRoaXMgcGF0Y2ggY2FuIG9ubHkgZml4ZXMgdGhl
IGNhc2UgdGhhdCAyIHdheSBpbnRlcmxlYXZlIGlzIGVuYWJsZWQgCj4gYWNyb3NzIDIgQ1hMIGhv
c3QgYnJpZGdlcyBhbmQgZWFjaCBob3N0IGJyaWRnZSBoYXMgMSBDWEwgUm9vdCBQb3J0Lgo+IFBT
OiBJbiBvdGhlciB3b3JkLCB0aGlzIHBhdGNoIGlzIHdyb25nIHdoZW4gMiB3YXkgaW50ZXJsZWF2
ZSBpcyBlbmFibGVkIAo+IGFjcm9zcyAyIENYTCBob3N0IGJyaWRnZXMgYW5kIGVhY2ggaG9zdCBi
cmlkZ2UgaGFzIDIgQ1hMIFJvb3QgUG9ydHMuCj4gCj4gSSBhbSB0cnlpbmcgdG8gZmluZCBhIGJl
dHRlciBzb2x1dGlvbi4gSWYgeW91IGhhdmUgYW55IHN1Z2dlc3Rpb24sIAo+IHBsZWFzZSBsZXQg
bWUga25vdy4KCkhpIFhpYW8sCgpUaGUgY3VycmVudCBiZWhhdmlvciBpcyB0aGF0IGlmIGEgbGlz
dCBvZiBtZW1kZXZzIGlzIHN1cHBsaWVkIG9uIHRoZQpjb21tYW5kIGxpbmUsIHRoZW4gdGhhdCBv
cmRlcmluZyBpcyBob3cgdGhlIHRhcmdldHMgYXJlIGFzc2lnbmVkLiBUaGUKcGxhbiBpcyB0byBl
dmVudHVhbGx5IGFkZCBhIG1vZGUgd2hlcmUgY3hsLWNyZWF0ZS1yZWdpb24gaXMgYWxsb3dlZCB0
bwpyZW9yZGVyIHRoZSBtZW1kZXZzIHRvIGZpdCB0aGUgdGFyZ2V0IHJ1bGVzLiBUaGlzIHNob3Vs
ZCBmaXggdGhlIGlzc3VlCnlvdSBhcmUgaGl0dGluZywgYnV0IHRoYXQncyBhIGJpZ2dlciBwaWVj
ZSBvZiB3b3JrLiBGb3Igbm93IHRoZQp3b3JrYXJvdW5kIGlzIHRoYXQgaWYgdGhlIGF1dG9tYXRp
YyBvcmRlcmluZyBmYWlscyAoYW5kIGl0IGlzbid0Cmd1YXJhbnRlZWQgdG8gd29yayksIGZpZ3Vy
ZSBvdXQgdGhlIHJpZ2h0IG9yZGVyaW5nIGV4dGVybmFsbHkgKHVzaW5nCmN4bC1saXN0KSBhbmQg
ZmVlZCB0aGUgY29ycmVjdCBvcmRlciB0byBjeGwtY3JlYXRlLXJlZ2lvbi4KCj4gCj4gQmVzdCBS
ZWdhcmRzLAo+IFhpYW8gWWFuZwo+IAo+IE9uIDIwMjMvNi8zMCAyMzoxMiwgWGlhbyBZYW5nIHdy
b3RlOgo+ID4gY3JlYXRlX3JlZ2lvbigpIHVzZXMgdGhlIHdyb25nIHRhcmdldCBwb3NpdGlvbiBp
biBzb21lIGNhc2VzLgo+ID4gRm9yIGV4YW1wbGUsIGN4bCBjcmVhdGUtcmVnaW9uIGNvbW1hbmQg
ZmFpbHMgdG8gY3JlYXRlIGEgbmV3Cj4gPiByZWdpb24gaW4gMiB3YXkgaW50ZXJsZWF2ZSBzZXQg
d2hlbiBtZW0wIGNvbm5lY3RzIHRhcmdldDEocG9zaXRpb246MSkKPiA+IGFuZCBtZW0xIGNvbm5l
Y3RzIHRhcmdldDAocG9zaXRpb246MCk6Cj4gPiAKPiA+ICQgY3hsIGxpc3QgLU0gLVAgLUQgLVQg
LXUKPiA+IFsKPiA+IMKgwqAgewo+ID4gwqDCoMKgwqAgInBvcnRzIjpbCj4gPiDCoMKgwqDCoMKg
wqAgewo+ID4gwqDCoMKgwqDCoMKgwqDCoCAicG9ydCI6InBvcnQxIiwKPiA+IMKgwqDCoMKgwqDC
oMKgwqAgImhvc3QiOiJwY2kwMDAwOjE2IiwKPiA+IMKgwqDCoMKgwqDCoMKgwqAgImRlcHRoIjox
LAo+ID4gwqDCoMKgwqDCoMKgwqDCoCAibnJfZHBvcnRzIjoxLAo+ID4gwqDCoMKgwqDCoMKgwqDC
oCAiZHBvcnRzIjpbCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoCB7Cj4gPiDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgImRwb3J0IjoiMDAwMDoxNjowMC4wIiwKPiA+IMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCAiaWQiOiIwIgo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqAgfQo+ID4gwqDCoMKgwqDC
oMKgwqDCoCBdLAo+ID4gwqDCoMKgwqDCoMKgwqDCoCAibWVtZGV2czpwb3J0MSI6Wwo+ID4gwqDC
oMKgwqDCoMKgwqDCoMKgwqAgewo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICJtZW1kZXYi
OiJtZW0wIiwKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAicmFtX3NpemUiOiI1MTIuMDAg
TWlCICg1MzYuODcgTUIpIiwKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAic2VyaWFsIjoi
MCIsCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgImhvc3QiOiIwMDAwOjE3OjAwLjAiCj4g
PiDCoMKgwqDCoMKgwqDCoMKgwqDCoCB9Cj4gPiDCoMKgwqDCoMKgwqDCoMKgIF0KPiA+IMKgwqDC
oMKgwqDCoCB9LAo+ID4gwqDCoMKgwqDCoMKgIHsKPiA+IMKgwqDCoMKgwqDCoMKgwqAgInBvcnQi
OiJwb3J0MiIsCj4gPiDCoMKgwqDCoMKgwqDCoMKgICJob3N0IjoicGNpMDAwMDowYyIsCj4gPiDC
oMKgwqDCoMKgwqDCoMKgICJkZXB0aCI6MSwKPiA+IMKgwqDCoMKgwqDCoMKgwqAgIm5yX2Rwb3J0
cyI6MSwKPiA+IMKgwqDCoMKgwqDCoMKgwqAgImRwb3J0cyI6Wwo+ID4gwqDCoMKgwqDCoMKgwqDC
oMKgwqAgewo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICJkcG9ydCI6IjAwMDA6MGM6MDAu
MCIsCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgImlkIjoiMCIKPiA+IMKgwqDCoMKgwqDC
oMKgwqDCoMKgIH0KPiA+IMKgwqDCoMKgwqDCoMKgwqAgXSwKPiA+IMKgwqDCoMKgwqDCoMKgwqAg
Im1lbWRldnM6cG9ydDIiOlsKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgIHsKPiA+IMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCAibWVtZGV2IjoibWVtMSIsCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgInJhbV9zaXplIjoiNTEyLjAwIE1pQiAoNTM2Ljg3IE1CKSIsCj4gPiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgInNlcmlhbCI6IjAiLAo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
ICJob3N0IjoiMDAwMDowZDowMC4wIgo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqAgfQo+ID4gwqDC
oMKgwqDCoMKgwqDCoCBdCj4gPiDCoMKgwqDCoMKgwqAgfQo+ID4gwqDCoMKgwqAgXQo+ID4gwqDC
oCB9LAo+ID4gwqDCoCB7Cj4gPiDCoMKgwqDCoCAicm9vdCBkZWNvZGVycyI6Wwo+ID4gwqDCoMKg
wqDCoMKgIHsKPiA+IMKgwqDCoMKgwqDCoMKgwqAgImRlY29kZXIiOiJkZWNvZGVyMC4wIiwKPiA+
IMKgwqDCoMKgwqDCoMKgwqAgInJlc291cmNlIjoiMHg3NTAwMDAwMDAiLAo+ID4gwqDCoMKgwqDC
oMKgwqDCoCAic2l6ZSI6IjQuMDAgR2lCICg0LjI5IEdCKSIsCj4gPiDCoMKgwqDCoMKgwqDCoMKg
ICJpbnRlcmxlYXZlX3dheXMiOjIsCj4gPiDCoMKgwqDCoMKgwqDCoMKgICJpbnRlcmxlYXZlX2dy
YW51bGFyaXR5Ijo4MTkyLAo+ID4gwqDCoMKgwqDCoMKgwqDCoCAibWF4X2F2YWlsYWJsZV9leHRl
bnQiOiI0LjAwIEdpQiAoNC4yOSBHQikiLAo+ID4gwqDCoMKgwqDCoMKgwqDCoCAicG1lbV9jYXBh
YmxlIjp0cnVlLAo+ID4gwqDCoMKgwqDCoMKgwqDCoCAidm9sYXRpbGVfY2FwYWJsZSI6dHJ1ZSwK
PiA+IMKgwqDCoMKgwqDCoMKgwqAgImFjY2VsbWVtX2NhcGFibGUiOnRydWUsCj4gPiDCoMKgwqDC
oMKgwqDCoMKgICJucl90YXJnZXRzIjoyLAo+ID4gwqDCoMKgwqDCoMKgwqDCoCAidGFyZ2V0cyI6
Wwo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqAgewo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
ICJ0YXJnZXQiOiJwY2kwMDAwOjE2IiwKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAiYWxp
YXMiOiJBQ1BJMDAxNjowMCIsCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgInBvc2l0aW9u
IjoxLAo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICJpZCI6IjB4MTYiCj4gPiDCoMKgwqDC
oMKgwqDCoMKgwqDCoCB9LAo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqAgewo+ID4gwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgICJ0YXJnZXQiOiJwY2kwMDAwOjBjIiwKPiA+IMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCAiYWxpYXMiOiJBQ1BJMDAxNjowMSIsCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgInBvc2l0aW9uIjowLAo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICJpZCI6IjB4
YyIKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgIH0KPiA+IMKgwqDCoMKgwqDCoMKgwqAgXQo+ID4g
wqDCoMKgwqDCoMKgIH0KPiA+IMKgwqDCoMKgIF0KPiA+IMKgwqAgfQo+ID4gXQo+ID4gCj4gPiAk
IGN4bCBjcmVhdGUtcmVnaW9uIC10IHJhbSAtZCBkZWNvZGVyMC4wIC1tIG1lbTAgbWVtMQo+ID4g
Y3hsIHJlZ2lvbjogY3JlYXRlX3JlZ2lvbjogcmVnaW9uMDogZmFpbGVkIHRvIHNldCB0YXJnZXQw
IHRvIG1lbTAKPiA+IGN4bCByZWdpb246IGNtZF9jcmVhdGVfcmVnaW9uOiBjcmVhdGVkIDAgcmVn
aW9ucwo+ID4gCj4gPiBTaWduZWQtb2ZmLWJ5OiBYaWFvIFlhbmcgPHlhbmd4Lmp5QGZ1aml0c3Uu
Y29tPgo+ID4gLS0tCj4gPiDCoCBjeGwvcmVnaW9uLmMgfCA0ICsrKy0KPiA+IMKgIDEgZmlsZSBj
aGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKPiA+IAo+ID4gZGlmZiAtLWdp
dCBhL2N4bC9yZWdpb24uYyBiL2N4bC9yZWdpb24uYwo+ID4gaW5kZXggMDdjZTRhMy4uOTQ2YjVm
ZiAxMDA2NDQKPiA+IC0tLSBhL2N4bC9yZWdpb24uYwo+ID4gKysrIGIvY3hsL3JlZ2lvbi5jCj4g
PiBAQCAtNjY3LDYgKzY2Nyw4IEBAIHN0YXRpYyBpbnQgY3JlYXRlX3JlZ2lvbihzdHJ1Y3QgY3hs
X2N0eCAqY3R4LCBpbnQgKmNvdW50LAo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqBzdHJ1Y3QganNvbl9vYmplY3QgKmpvYmogPQo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKganNvbl9vYmplY3RfYXJyYXlfZ2V0X2lkeChwLT5tZW1k
ZXZzLCBpKTsKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgc3RydWN0IGN4bF9t
ZW1kZXYgKm1lbWRldiA9IGpzb25fb2JqZWN0X2dldF91c2VyZGF0YShqb2JqKTsKPiA+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgY3hsX3RhcmdldCAqdGFyZ2V0ID0gY3hs
X2RlY29kZXJfZ2V0X3RhcmdldF9ieV9tZW1kZXYocC0+cm9vdF9kZWNvZGVyLAo+ID4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgbWVtZGV2KTsKPiA+IMKgIAo+
ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBlcF9kZWNvZGVyID0gY3hsX21lbWRl
dl9maW5kX2RlY29kZXIobWVtZGV2KTsKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgaWYgKCFlcF9kZWNvZGVyKSB7Cj4gPiBAQCAtNjgzLDcgKzY4NSw3IEBAIHN0YXRpYyBpbnQg
Y3JlYXRlX3JlZ2lvbihzdHJ1Y3QgY3hsX2N0eCAqY3R4LCBpbnQgKmNvdW50LAo+ID4gwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgdHJ5KGN4bF9kZWNvZGVy
LCBzZXRfbW9kZSwgZXBfZGVjb2RlciwgcC0+bW9kZSk7Cj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoH0KPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgdHJ5KGN4
bF9kZWNvZGVyLCBzZXRfZHBhX3NpemUsIGVwX2RlY29kZXIsIHNpemUvcC0+d2F5cyk7Cj4gPiAt
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmMgPSBjeGxfcmVnaW9uX3NldF90YXJnZXQo
cmVnaW9uLCBpLCBlcF9kZWNvZGVyKTsKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqByYyA9IGN4bF9yZWdpb25fc2V0X3RhcmdldChyZWdpb24sIGN4bF90YXJnZXRfZ2V0X3Bvc2l0
aW9uKHRhcmdldCksIGVwX2RlY29kZXIpOwo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqBpZiAocmMpIHsKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoGxvZ19lcnIoJnJsLCAiJXM6IGZhaWxlZCB0byBzZXQgdGFyZ2V0JWQgdG8gJXNc
biIsCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgZGV2bmFtZSwgaSwgY3hsX21lbWRldl9nZXRfZGV2bmFtZShtZW1kZXYp
KTsKCg==
