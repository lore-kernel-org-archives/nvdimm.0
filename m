Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1DD17995
	for <nvdimm@lists.linux.dev>; Thu, 22 Feb 2024 07:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708588765; cv=fail; b=XAKjhQo3lf6xogVchh9vbNioip6MWpG10azHqNlyBGk7bpuUd2JD7HEjfQ2qUGUKv3dh06q0/ESQMCHsbwHNFPxcA7DiRvEYLhLbDWD4hMPP9hW94XPn5K9+NmSBf/FV/vj1BbpHMQ2tq0UJciV0yj6aBDw22fTYydt9RTkKics=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708588765; c=relaxed/simple;
	bh=qDTgJy6TXegcGvkqIb6yZCJc5g45dGQ6QrM0VRFpjUU=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=twT085brXLQovyUiiPeUKlPEjv3G6F2oEn7jsQqJ4WkBXhWOTfutwSqojTiLueQYkm+d55jrW2IJv013E+EvyY5LWXGCmV14cfsuDRxLG5WiBz3/Zs0juMcHL1A3+KmjgWqonSHddKBp7yAqaC2MAZqaML9Xe97HpyP/R0nEXLc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E2jYPAou; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E2jYPAou"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708588762; x=1740124762;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=qDTgJy6TXegcGvkqIb6yZCJc5g45dGQ6QrM0VRFpjUU=;
  b=E2jYPAouLUrbvvB8Jp8092IkU5U4ROJid2B24kY8QH/HCdDNuLzIbfL+
   OEQ8xlKSgIy2LDKJxXDcgRgLgAp2WcQcTaENqPusVscg8Oj69OJ2/ku0O
   lKOP/xkNiHYOZfiNoCDt7hX8trJzL62x01GiYa3lkaOufeRjzgaUy7mSD
   XTLTRnKgdvDfkWpak72jrRIKH7j25qi9skDJvCC8jepbKehdrzrQjyhsI
   6VvWIijlWOuzvtHD/F5epGvJt+aXu2XP4oUDYjkRPOk+WVzWexXC/fPHN
   RlQHgCzJtY0945iCjf+7vtUQJrWV13X904pNbrGwzeMQYIGQ9UMhlqJ0n
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10991"; a="20229107"
X-IronPort-AV: E=Sophos;i="6.06,177,1705392000"; 
   d="scan'208";a="20229107"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2024 23:59:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10991"; a="827509017"
X-IronPort-AV: E=Sophos;i="6.06,177,1705392000"; 
   d="scan'208";a="827509017"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Feb 2024 23:59:19 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 21 Feb 2024 23:59:19 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 21 Feb 2024 23:59:18 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 21 Feb 2024 23:59:18 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 21 Feb 2024 23:59:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yw2HSu2aAJ+9azYUtLP6babdT0C5rjlzy3eQ7HPCcpiOR/XrmHlMOLSNsyTVGvHxErDSk8tk+dduB/3P5pLgz0ACQSSCpNb6QhnVt1O1UDtzsmXEtLVKXNC/OwBBLS9XZMkGVH3egh5M3he6sTmCvHuZYZ3XMjBY4rAHfJR4dzqtmHlXhZUAXrSAgb8HssB4DS5dtPAb8zhvZ4zJZgHn0VeSCtvrjm0iONkzY9Zmi3YPT0rXLEp+0prttAUaG14y5+LZZ3ZW4MjNtmAT3ONdmipCeCH89cirjy1f/uqm3K1p56Uw4THbn6NJ4ZpPJbi/qUEpyWBZet1QR3E7toUQNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qDTgJy6TXegcGvkqIb6yZCJc5g45dGQ6QrM0VRFpjUU=;
 b=SHh/dnHNvKL9YfFoFuzxZHGXtBRh2FDu5aAIPNlDs2cd3JzluKJ5FEb/YAtaMKMrfT4YIrAhW32kKVVBHijlG79NUuvCqozwpTOydRFqrooWAV0B3HHKWGb6CIPS6ZWAYsMeFk5OI8kb0DmuCQq3XrxzdHTyCKvOz2br28SywWBdou07t/P7y7c+l4+Y9cSAvMrWVTYtGwvL51ipo5uz5kXS1tc1YkG6/LBpvYFDtMbdD4N8bCl09Zlmp7pEzfsyvwMriXeN/hYkUeCcFH2PPL3aXyMxiCDOGLirAqCJ/yz3pxhgOTUYLP2pnb4okfsS19j023Z92zTGV3dF8oUrUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by SA2PR11MB4858.namprd11.prod.outlook.com (2603:10b6:806:f9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.21; Thu, 22 Feb
 2024 07:59:16 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::e28a:f124:d986:c1d0]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::e28a:f124:d986:c1d0%5]) with mapi id 15.20.7316.018; Thu, 22 Feb 2024
 07:59:16 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Jiang, Dave" <dave.jiang@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
Subject: Re: [NDCTL PATCH v7 4/4] ndctl: add test for qos_class in CXL test
 suite
Thread-Topic: [NDCTL PATCH v7 4/4] ndctl: add test for qos_class in CXL test
 suite
Thread-Index: AQHaWsuQDbCrvgUh4UO76ILaNpl9J7EWFHYA
Date: Thu, 22 Feb 2024 07:59:16 +0000
Message-ID: <677035a6578df716ff9df5cb83047498919e90ae.camel@intel.com>
References: <20240208201435.2081583-1-dave.jiang@intel.com>
	 <20240208201435.2081583-5-dave.jiang@intel.com>
In-Reply-To: <20240208201435.2081583-5-dave.jiang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|SA2PR11MB4858:EE_
x-ms-office365-filtering-correlation-id: 328f57c2-69a3-4dc4-60ba-08dc337c2aba
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KjQZHXGVLu/gut0hJdeJd1QzroO/MAa7s1Ljm4QrXi5ICpyxT+70ivh8aGxO4TMoD6AIG5lb4a7cKhgJIiYjXDVs/Y2uSRTsXiG6gO05z+KkKc4redlVnqpAmN1o5/FD/hcbOkkWU+74AS8PLhTA7XVwD7E/EOCMVB1iNJMqPMUnohVEWGunxge3LxVvMPxoOwJF0vGinpR56s8vfmKQDNZNkJy62/antu827jmQydy7RNWXAy+6VXnfOGDJFZuaHtNxZoFALPtfr2wXrOluVxst+N6AlsEfn4sy63NVR6rutHV4/I6a2HOo+J3LpS4SDEWH0xq30wy1cKZAnj4CcFUkSNmBzJtroXJlrCdK1+8pxH6VU07+3jeevgksAj2F/CfxykAzIxltiYP6aQgX5nV3xXZn5PZUy1ypTdPKkcbU8v0acmfLMByv5PsKcX3SMncYNU7IWGEx1tXxzxuE6gSj/4/1nNcIS4F7lYuZ4bmsH5Itce60HA9b6MKr3Zvn2JYTw36pCpI5BqS1LSPXm12KPh0BEmZDfa0vGc616BnXqbqEjtj+20qTj8VsHFz2D8WnB8iO8VuTYTRFTYqbsUcPHYGxl9KXNgQMIubd4mBfa8rLnkHp0mIZwKdcpjq9
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dGZiQnNOMHppK0creTh6NGdxRUx3QWRFc25WOWJZZ3FKd24xekpjeWZPWnRE?=
 =?utf-8?B?T2RoOHViOUxmR0RrcTVCQ3JVT3ArUmpkazhLcUdmL01Ob1U4cWVPeWlwUTRL?=
 =?utf-8?B?TVVhTW01Z0VHQkFkazdoTjQza1VieGh0bEZUblF4Z1ZPbmJGdWdSUnJpaklN?=
 =?utf-8?B?RzBPODlPT0FZaHo5UVB3M2dBN3RpUDlQczhCUk42SFA5U3RwNHl6SGVzYzEv?=
 =?utf-8?B?SjJjTFU3SktVa2FKWnlaRmNwMkY0cDJGNlo5NTJsREZselllLzJUdXVQSm9h?=
 =?utf-8?B?alJHeXlGcXdPZnZIZGtYU01hTzdYbksxeHc0QU1KNllZLzA4V2h2aEl6SFQ2?=
 =?utf-8?B?VElYem0rUUNaSmNjWkI1NjFlWGZFM040VjhGcUczbU1UYmVrdVFNbmFzbkNG?=
 =?utf-8?B?V3ZxcU9PVjNBbHRiam51Yi82OXpDU243ckdma2NJbFZxeDdkWGd3NzAvWWxw?=
 =?utf-8?B?UGxIODZKVUZqV2o4czJkL3poUkJ5Y0pmRWRjR2hTQzNCYXREb1F5d1luZE9M?=
 =?utf-8?B?T1V1Zjd1ZFhYNEZNdDBEL000b05sNzB1MjZXYlpNWFQ3ejI0TzZWNDJNUVVW?=
 =?utf-8?B?SmdncmlQNEJwZlh1N1JqK25mZzl6WjRZVWJmV1FaeERTRWlLb0NEb0FOZjNt?=
 =?utf-8?B?Q3ZKYm9adWNKOFd0KzdHNitBUlplM2tZVmVWVUhvZ1BuNjlFQlJRT2Q3amJh?=
 =?utf-8?B?OWxsLzhmUWFTKzFqd0hhUG14V2lEN1d0alV3b2NZRWZOVzlzVlk2MzlQeHAz?=
 =?utf-8?B?WWRUUWVkKytTS1h1TTNwYWtnNGJLYjJwMmdqNHRoSHJSazdCNHEwQjV5SnVv?=
 =?utf-8?B?TEtBdzVYRitteUs5cXBTUmJjYkdnZmVnV2lEL2dIeStMck5DUm1MZm1RT2Y5?=
 =?utf-8?B?aERYUXJKTHpMS2hqSHM2T3hHMVAxdFdmcThNSEJvM3FuZkV3ZFdkVFJBNXYx?=
 =?utf-8?B?YzNSUlVuSDIvNWhSemRTUWd0Unl5eTZaVmwvNjFCQnZwOTFDdDJuVzhOcjd5?=
 =?utf-8?B?Ui9DaGxhcjZqUHBLVUJUUkRwdlNEK0tZMVlIODBoa2drU3ltazVpekRYdXEw?=
 =?utf-8?B?UWNoS210elhvQUh1OHZFUzZUMTRKUjJDaDh3K1FYdmNack9RbGxFVUNaUkly?=
 =?utf-8?B?OFpPbHhBSUpnWWNOSWt6UzV0WHFsZ3FDUGhVdDQ5bGdtak9jZ3RsMzZJTjhy?=
 =?utf-8?B?RXFRZVpvci91dW8zWnZ5ZExBMVZlYnppSVRGMHF0dEkvZUI0TlN5WjBaQzBY?=
 =?utf-8?B?emtoMWJnVnkwbmpQbDJXVmVYaG1idUwvcDR3Tm5kTit1VWJXenFaY3gvSUNP?=
 =?utf-8?B?SlhsNXRLYmd6aFk5aUNrOHZyK2cvMkNSdHQ4dEFsZGcxTGF6bE15TDFXZ0M1?=
 =?utf-8?B?Z2NMdHp6bCtqeHNkbG1JWFQva09BeWMyYURLa2dRcVgwN1E1dzFjKzZzTjJS?=
 =?utf-8?B?NDNYeDJ0Q1hHSis5UThxUmY4WStnd2RaR2E3c3YwaDh3bWQrT0tVZGU5b0R2?=
 =?utf-8?B?SElSRC9Rdk53Qnl3ZUY4eXZQZ0d1THBLb3BmaHNkeS8zNnBXN0dBYStHOTV3?=
 =?utf-8?B?VVZzcnZuYzRnK2JaQkdON0tJcTdVaTBZNGJNSm9IcXNQT002VzVTZ3RsdjZD?=
 =?utf-8?B?eEs3N1l2Ui9MY2g4VlNoNldzYW0xMXhES29IV1k5TzRvY3crMDQ2V0VmaEE2?=
 =?utf-8?B?VTFKRzlXY2ZweEl2NmNsQlFFTWlaYmlmUWNIaERWWlpoYUx2b21sS3Z6VW5H?=
 =?utf-8?B?a1JPbkU5cnVucWwrY1ZZQW5DMTBMQk0xQ25OOGFXNVpwZW8xcXNleDdueHpq?=
 =?utf-8?B?d0dzU0pwM1U1M3ZadDhVdmp3cDNxd2Vac0tUSmhPeFRLSEpuNUlKcmM1d0lx?=
 =?utf-8?B?dkpRck1mRFNPMFRIQVhmY1Joa2lMcDY5bHB2a09CWUROVWIycndKRjltUk9v?=
 =?utf-8?B?ZzRwTHZIZHcvMEJmb045N3labUIyOGdDMEMyYTFWejA5SU5zVWNiOTRkbE9S?=
 =?utf-8?B?VTVMN0U4aitvd2FNckdyZUx2dWh4Z1JTMzVReW1yNDkvRGdqbG5nWTFXK1Qw?=
 =?utf-8?B?U2pEVEtoTTJEcGo5SFZGaUFYUE9FSWkyMEw3WVpoMUJMbHpLRWVKTXJ0WDgz?=
 =?utf-8?B?djFkYTI0RDd2NUpvK0ovd20xdnhFUUt6Wk43blF2K2pYeEQ4TDF4QlRiYXdY?=
 =?utf-8?B?M1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <780EF34019A4FE4685CE62CC395D0DC3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 328f57c2-69a3-4dc4-60ba-08dc337c2aba
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2024 07:59:16.5229
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RUagadg6Ir3vXVMdAlK1l2Fc9h3FnnM8Or47f+UN2Xt4cW3CyzQCk0HLT1ykE2GMvmYrq+85O2/3VDceL2+ZWgOB73I0Hv+4FCpZHH/oAxA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4858
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTAyLTA4IGF0IDEzOjExIC0wNzAwLCBEYXZlIEppYW5nIHdyb3RlOg0KPiBB
ZGQgdGVzdHMgaW4gY3hsLXFvcy1jbGFzcy5zaCB0byB2ZXJpZnkgcW9zX2NsYXNzIGFyZSBzZXQg
d2l0aCB0aGUgZmFrZQ0KPiBxb3NfY2xhc3MgY3JlYXRlIGJ5IHRoZSBrZXJuZWwuwqAgUm9vdCBk
ZWNvZGVycyBzaG91bGQgaGF2ZSBxb3NfY2xhc3MNCj4gYXR0cmlidXRlIHNldC4gTWVtb3J5IGRl
dmljZXMgc2hvdWxkIGhhdmUgcmFtX3Fvc19jbGFzcyBvciBwbWVtX3Fvc19jbGFzcw0KPiBzZXQg
ZGVwZW5kaW5nIG9uIHdoaWNoIHBhcnRpdGlvbnMgYXJlIHZhbGlkLg0KPiANCj4gU2lnbmVkLW9m
Zi1ieTogRGF2ZSBKaWFuZyA8ZGF2ZS5qaWFuZ0BpbnRlbC5jb20+DQo+IC0tLQ0KPiB2NzoNCj4g
LSBBZGQgY3JlYXRlX3JlZ2lvbiAtUSB0ZXN0aW5nIChWaXNoYWwpDQo+IC0tLQ0KPiDCoHRlc3Qv
Y29tbW9uwqDCoMKgwqDCoMKgwqDCoMKgwqAgfMKgwqAgNCArKw0KPiDCoHRlc3QvY3hsLXFvcy1j
bGFzcy5zaCB8IDEwMiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysN
Cj4gwqB0ZXN0L21lc29uLmJ1aWxkwqDCoMKgwqDCoCB8wqDCoCAyICsNCj4gwqAzIGZpbGVzIGNo
YW5nZWQsIDEwOCBpbnNlcnRpb25zKCspDQo+IMKgY3JlYXRlIG1vZGUgMTAwNzU1IHRlc3QvY3hs
LXFvcy1jbGFzcy5zaA0KPiANCj4gZGlmZiAtLWdpdCBhL3Rlc3QvY29tbW9uIGIvdGVzdC9jb21t
b24NCj4gaW5kZXggZjEwMjNlZjIwZjdlLi41Njk0ODIwYzdhZGMgMTAwNjQ0DQo+IC0tLSBhL3Rl
c3QvY29tbW9uDQo+ICsrKyBiL3Rlc3QvY29tbW9uDQo+IEBAIC0xNTAsMyArMTUwLDcgQEAgY2hl
Y2tfZG1lc2coKQ0KPiDCoAlncmVwIC1xICJDYWxsIFRyYWNlIiA8PDwgJGxvZyAmJiBlcnIgJDEN
Cj4gwqAJdHJ1ZQ0KPiDCoH0NCj4gKw0KPiArDQo+ICsjIENYTCBDT01NT04NCj4gK1RFU1RfUU9T
X0NMQVNTPTQyDQo+IGRpZmYgLS1naXQgYS90ZXN0L2N4bC1xb3MtY2xhc3Muc2ggYi90ZXN0L2N4
bC1xb3MtY2xhc3Muc2gNCj4gbmV3IGZpbGUgbW9kZSAxMDA3NTUNCj4gaW5kZXggMDAwMDAwMDAw
MDAwLi4xNDVkZjYxMzQ2ODUNCj4gLS0tIC9kZXYvbnVsbA0KPiArKysgYi90ZXN0L2N4bC1xb3Mt
Y2xhc3Muc2gNCj4gQEAgLTAsMCArMSwxMDIgQEANCj4gKyMhL2Jpbi9iYXNoDQo+ICsjIFNQRFgt
TGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wDQo+ICsjIENvcHlyaWdodCAoQykgMjAyNCBJbnRl
bCBDb3Jwb3JhdGlvbi4gQWxsIHJpZ2h0cyByZXNlcnZlZC4NCj4gKw0KPiArLiAkKGRpcm5hbWUg
JDApL2NvbW1vbg0KPiArDQo+ICtyYz03Nw0KPiArDQo+ICtzZXQgLWV4DQo+ICsNCj4gK3RyYXAg
J2VyciAkTElORU5PJyBFUlINCj4gKw0KPiArY2hlY2tfcHJlcmVxICJqcSINCj4gKw0KPiArbW9k
cHJvYmUgLXIgY3hsX3Rlc3QNCj4gK21vZHByb2JlIGN4bF90ZXN0DQo+ICtyYz0xDQo+ICsNCj4g
K2NoZWNrX3Fvc19kZWNvZGVycyAoKSB7DQo+ICsJIyBjaGVjayByb290IGRlY29kZXJzIGhhdmUg
ZXhwZWN0ZWQgZmFrZSBxb3NfY2xhc3MNCj4gKwkjIGFsc28gbWFrZSBzdXJlIHRoZSBudW1iZXIg
b2Ygcm9vdCBkZWNvZGVycyBlcXVhbCB0byB0aGUgbnVtYmVyDQo+ICsJIyB3aXRoIHFvc19jbGFz
cyBmb3VuZA0KPiArCWpzb249JCgkQ1hMIGxpc3QgLWIgY3hsX3Rlc3QgLUQgLWQgcm9vdCkNCj4g
KwlkZWNvZGVycz0kKGVjaG8gIiRqc29uIiB8IGpxIGxlbmd0aCkNCj4gKwljb3VudD0wDQo+ICsJ
d2hpbGUgcmVhZCAtciBxb3NfY2xhc3MNCj4gKwlkbw0KPiArCQkoKHFvc19jbGFzcyA9PSBURVNU
X1FPU19DTEFTUykpIHx8IGVyciAiJExJTkVOTyINCj4gKwkJY291bnQ9JCgoY291bnQrMSkpDQo+
ICsJZG9uZSA8PDwgIiQoZWNobyAiJGpzb24iIHwganEgLXIgJy5bXSB8IC5xb3NfY2xhc3MnKSIN
Cj4gKw0KPiArCSgoY291bnQgPT0gZGVjb2RlcnMpKSB8fCBlcnIgIiRMSU5FTk8iOw0KPiArfQ0K
PiArDQo+ICtjaGVja19xb3NfbWVtZGV2cyAoKSB7DQo+ICsJIyBDaGVjayB0aGF0IG1lbWRldnMg
dGhhdCBleHBvc2UgcmFtX3Fvc19jbGFzcyBvciBwbWVtX3Fvc19jbGFzcyBoYXZlDQo+ICsJIyBl
eHBlY3RlZCBmYWtlIHZhbHVlIHByb2dyYW1tZWQuDQo+ICsJanNvbj0kKGN4bCBsaXN0IC1iIGN4
bF90ZXN0IC1NKQ0KPiArCXJlYWRhcnJheSAtdCBsaW5lcyA8IDwoanEgIi5bXSB8IC5yYW1fc2l6
ZSwgLnBtZW1fc2l6ZSwgLnJhbV9xb3NfY2xhc3MsIC5wbWVtX3Fvc19jbGFzcyIgPDw8IiRqc29u
IikNCj4gKwlmb3IgKCggaSA9IDA7IGkgPCAkeyNsaW5lc1tAXX07IGkgKz0gNCApKQ0KPiArCWRv
DQo+ICsJCXJhbV9zaXplPSR7bGluZXNbaV19DQo+ICsJCXBtZW1fc2l6ZT0ke2xpbmVzW2krMV19
DQo+ICsJCXJhbV9xb3NfY2xhc3M9JHtsaW5lc1tpKzJdfQ0KPiArCQlwbWVtX3Fvc19jbGFzcz0k
e2xpbmVzW2krM119DQo+ICsNCj4gKwkJaWYgW1sgIiRyYW1fc2l6ZSIgIT0gbnVsbCBdXQ0KPiAr
CQl0aGVuDQo+ICsJCQkoKHJhbV9xb3NfY2xhc3MgPT0gVEVTVF9RT1NfQ0xBU1MpKSB8fCBlcnIg
IiRMSU5FTk8iDQo+ICsJCWZpDQo+ICsJCWlmIFtbICIkcG1lbV9zaXplIiAhPSBudWxsIF1dDQo+
ICsJCXRoZW4NCj4gKwkJCSgocG1lbV9xb3NfY2xhc3MgPT0gVEVTVF9RT1NfQ0xBU1MpKSB8fCBl
cnIgIiRMSU5FTk8iDQo+ICsJCWZpDQo+ICsJZG9uZQ0KPiArfQ0KPiArDQo+ICsjIEJhc2VkIG9u
IGN4bC1jcmVhdGUtcmVnaW9uLnNoIGNyZWF0ZV9zaW5nbGUoKQ0KPiArZGVzdHJveV9yZWdpb25z
KCkNCj4gK3sNCj4gKwlpZiBbWyAiJCoiIF1dOyB0aGVuDQo+ICsJCSRDWEwgZGVzdHJveS1yZWdp
b24gLWYgLWIgY3hsX3Rlc3QgIiRAIg0KPiArCWVsc2UNCj4gKwkJJENYTCBkZXN0cm95LXJlZ2lv
biAtZiAtYiBjeGxfdGVzdCBhbGwNCj4gKwlmaQ0KPiArfQ0KPiArDQo+ICtjcmVhdGVfcmVnaW9u
X2NoZWNrX3FvcygpDQo+ICt7DQo+ICsJIyB0aGUgNXRoIGN4bF90ZXN0IGRlY29kZXIgaXMgZXhw
ZWN0ZWQgdG8gdGFyZ2V0IGEgc2luZ2xlLXBvcnQNCj4gKwkjIGhvc3QtYnJpZGdlLiBPbGRlciBj
eGxfdGVzdCBpbXBsZW1lbnRhdGlvbnMgbWF5IG5vdCBkZWZpbmUgaXQsDQo+ICsJIyBzbyBza2lw
IHRoZSB0ZXN0IGluIHRoYXQgY2FzZS4NCj4gKwlkZWNvZGVyPSQoJENYTCBsaXN0IC1iIGN4bF90
ZXN0IC1EIC1kIHJvb3QgfA0KPiArCQnCoCBqcSAtciAiLls0XSB8DQo+ICsJCcKgIHNlbGVjdCgu
cG1lbV9jYXBhYmxlID09IHRydWUpIHwNCj4gKwkJwqAgc2VsZWN0KC5ucl90YXJnZXRzID09IDEp
IHwNCj4gKwkJwqAgLmRlY29kZXIiKQ0KDQpJbnN0ZWFkIG9mIGFzc3VtaW5nIHRoZSA1dGggZGVj
b2RlciwgY2FuIHdlIHNlbGVjdCBiYXNlZCBvbiBzb21lDQpwcm9wZXJ0eSBvZiB0aGUgZGVjb2Rl
ciBvciBpdHMgcGFyZW50YWdlPyBUaGlzIHdvcmtzLCBidXQgaXQncyBhIGJpdA0Kc2Vuc2l0aXZl
IHRvIGZ1dHVyZSBjeGxfdGVzdCB0b3BvbG9neSBjaGFuZ2VzIHRoYXQgd2lsbCBlYXNpbHkgYW5k
DQoobW9yZSBpbXBvcnRhbnRseSkgc2lsZW50bHkgYnJlYWsgdGhpcyBwYXJ0IG9mIHRoZSB0ZXN0
IChzaW5jZSB3ZSBza2lwDQpidXQgc3RpbGwgcGFzcykuDQoNCj4gKw0KPiArwqDCoMKgwqDCoMKg
wqAgaWYgW1sgISAkZGVjb2RlciBdXTsgdGhlbg0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIGVjaG8gIm5vIHNpbmdsZS1wb3J0IGhvc3QtYnJpZGdlIGRlY29kZXIgZm91bmQsIHNr
aXBwaW5nIg0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybg0KPiArwqDC
oMKgwqDCoMKgwqAgZmkNCg0KSSB0aGluayB0aGVyZSdzIHNvbWUgc3BhY2UvdGFiIG1peGluZyBn
b2luZyBvbiBoZXJlLg0KDQo+ICsNCj4gKwkjIFNlbmQgY3JlYXRlLXJlZ2lvbiB3aXRoIC1RIHRv
IGVuZm9yY2UgcW9zX2NsYXNzIG1hdGNoaW5nDQo+ICsJcmVnaW9uPSQoJENYTCBjcmVhdGUtcmVn
aW9uIC1RIC1kICIkZGVjb2RlciIgfCBqcSAtciAiLnJlZ2lvbiIpDQo+ICsJaWYgW1sgISAkcmVn
aW9uIF1dOyB0aGVuDQo+ICsJCWVjaG8gImZhaWxlZCB0byBjcmVhdGUgc2luZ2xlLXBvcnQgaG9z
dC1icmlkZ2UgcmVnaW9uIg0KPiArCQllcnIgIiRMSU5FTk8iDQo+ICsJZmkNCj4gKw0KPiArCWRl
c3Ryb3lfcmVnaW9ucyAiJHJlZ2lvbiINCj4gK30NCj4gKw0KPiArY2hlY2tfcW9zX2RlY29kZXJz
DQo+ICsNCj4gK2NoZWNrX3Fvc19tZW1kZXZzDQo+ICsNCj4gK2NyZWF0ZV9yZWdpb25fY2hlY2tf
cW9zDQo+ICsNCj4gK2NoZWNrX2RtZXNnICIkTElORU8iDQo+ICsNCj4gK21vZHByb2JlIC1yIGN4
bF90ZXN0DQo+IGRpZmYgLS1naXQgYS90ZXN0L21lc29uLmJ1aWxkIGIvdGVzdC9tZXNvbi5idWls
ZA0KPiBpbmRleCA1ZWIzNTc0OWE5NWIuLjQ4OTJkZjExMTE5ZiAxMDA2NDQNCj4gLS0tIGEvdGVz
dC9tZXNvbi5idWlsZA0KPiArKysgYi90ZXN0L21lc29uLmJ1aWxkDQo+IEBAIC0xNjAsNiArMTYw
LDcgQEAgY3hsX2V2ZW50cyA9IGZpbmRfcHJvZ3JhbSgnY3hsLWV2ZW50cy5zaCcpDQo+IMKgY3hs
X3BvaXNvbiA9IGZpbmRfcHJvZ3JhbSgnY3hsLXBvaXNvbi5zaCcpDQo+IMKgY3hsX3Nhbml0aXpl
ID0gZmluZF9wcm9ncmFtKCdjeGwtc2FuaXRpemUuc2gnKQ0KPiDCoGN4bF9kZXN0cm95X3JlZ2lv
biA9IGZpbmRfcHJvZ3JhbSgnY3hsLWRlc3Ryb3ktcmVnaW9uLnNoJykNCj4gK2N4bF9xb3NfY2xh
c3MgPSBmaW5kX3Byb2dyYW0oJ2N4bC1xb3MtY2xhc3Muc2gnKQ0KPiDCoA0KPiDCoHRlc3RzID0g
Ww0KPiDCoMKgIFsgJ2xpYm5kY3RsJyzCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGxpYm5k
Y3RsLAkJwqAgJ25kY3RsJyBdLA0KPiBAQCAtMTkyLDYgKzE5Myw3IEBAIHRlc3RzID0gWw0KPiDC
oMKgIFsgJ2N4bC1wb2lzb24uc2gnLMKgwqDCoMKgwqDCoMKgwqDCoCBjeGxfcG9pc29uLMKgwqDC
oMKgwqDCoMKgwqAgJ2N4bCfCoMKgIF0sDQo+IMKgwqAgWyAnY3hsLXNhbml0aXplLnNoJyzCoMKg
wqDCoMKgwqDCoCBjeGxfc2FuaXRpemUswqDCoMKgwqDCoMKgICdjeGwnwqDCoCBdLA0KPiDCoMKg
IFsgJ2N4bC1kZXN0cm95LXJlZ2lvbi5zaCcswqAgY3hsX2Rlc3Ryb3lfcmVnaW9uLCAnY3hsJ8Kg
wqAgXSwNCj4gK8KgIFsgJ2N4bC1xb3MtY2xhc3Muc2gnLMKgwqDCoMKgwqDCoCBjeGxfcW9zX2Ns
YXNzLMKgwqDCoMKgwqAgJ2N4bCfCoMKgIF0sDQo+IMKgXQ0KPiDCoA0KPiDCoGlmIGdldF9vcHRp
b24oJ2Rlc3RydWN0aXZlJykuZW5hYmxlZCgpDQoNCg==
