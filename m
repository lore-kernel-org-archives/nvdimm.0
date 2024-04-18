Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA4F4C69
	for <nvdimm@lists.linux.dev>; Thu, 18 Apr 2024 00:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713401731; cv=fail; b=qCOLuZg1WvwqNNcNiOP7+eYuRoXDZcB5zMxGZcZ5kXWof9Ctrmo2f3wn+HTtGM511ApuF/6vTci5v5udgL0csPAH3ig+J5e6cun1Vhj8fAiBhYUIaO0qPAtCW8OftNmf1PS1dkNFQKmLsmSArM5G9TZKYaBZsW5jaabCPnR5LDU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713401731; c=relaxed/simple;
	bh=N9tnu05jeuwEF4nULSWKMxw1JuNVgymW4PbL+JzHKPU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HWABfVfAky84AdVp4DOG/HEf6GbOdpKLUz91bfNe1GOqt5vhep797M4Jf3aGe98/Q0VcgYLRHbwC7UD4VDqqwYkJe/GCY743feAZ1Y5BVGTNLjphAx8C8mz00QnajMkOVi1KS5eJsyLmPtavqHVG5KpbgetBJuPsj9foNEMVYbs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y6hn//RS; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y6hn//RS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713401728; x=1744937728;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=N9tnu05jeuwEF4nULSWKMxw1JuNVgymW4PbL+JzHKPU=;
  b=Y6hn//RSGwTU5e02+/Zv12Pzt4CZzPWLCDbSqw+cHZYkjmltJbPMqvpj
   fB1MngUgNeog1831wfYqmxC51LDm7KOpyLo5LRKm/H0GmagGE4/FAEPmv
   im2mrTkqtCyAIP+1hrdsCCt+E2nTHjvTMzLLLL/kYF5djUWXXuP9sTkzS
   vCp0RUhQkMUWoUBQcdcjxlVuGhl2lN7g9F/PY5sMHvX2tP5/keGQkN1RS
   h2b9QDH9MKPezYhfQuRleP1VqiNnjD6kuH5mSoHueQZDoJvk7LlhMQPHz
   yF43y4otAMxZUfM0rID1TSJHHYF0wfkFJWn+kfcCqXahmazYTmLmOvugv
   w==;
X-CSE-ConnectionGUID: j1NfmCk2QEGJzLCm8Nb58Q==
X-CSE-MsgGUID: d64gvwiNQXmyJMiG7Gvftg==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="34318747"
X-IronPort-AV: E=Sophos;i="6.07,210,1708416000"; 
   d="scan'208";a="34318747"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2024 17:55:28 -0700
X-CSE-ConnectionGUID: hcxBDIrTSzuq/3rYF6ddcw==
X-CSE-MsgGUID: hsklRJEGSSqSu8tqFFpLtA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,210,1708416000"; 
   d="scan'208";a="27430742"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Apr 2024 17:55:28 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 17 Apr 2024 17:55:27 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 17 Apr 2024 17:55:27 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 17 Apr 2024 17:55:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DSBFWeSmkdyR6GzM2HJZ0ukLNk4Xsz0McoEvZrzfbu3jdNTO1wvVe4Qp/PlwKG84vExyr95DpNueT7nnQapIvEZ2hxBAEVbcczDVno7RlM+QV9q7oLKfhq5pcCbbY3o/V0pB9iKSjOIk1z0h0xCwgmmH6Q1ncIVK6yClJtr0CwR4k00UAW05wZmqIT45746Tk1tzbkaWivoJ6P4sD66CxGhnP66B3BVHrExcwczZ+5yAWdv/ZK/7hCFjvihSrc7coNcn/aQ/JgxVhkDkeoHQWZ0tEHxR2l17XnaSVL61zErCwUsIsu8jaJnqGtDYWxbNADjfzmRKHowlfhPgJMkfoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N9tnu05jeuwEF4nULSWKMxw1JuNVgymW4PbL+JzHKPU=;
 b=alDkBVryLSAKv1ySWyfTAIyJVWoa/FXp2E/KVv8yJp/5cV4oObVeJHo31c5N04XFVQwSRIblMnUvtUhQ5pKJrfW6zVlNQhNeJYoc4fcqo6Vcqza6DttkGQXdc7p4PQAhp1n6QqAXgXyUDmF36UQUuwDBi9e2j7qFOS08aahr/0cFtj9kCbWArk301j4Xb2vC+/gGfoscM72revqRptYr69hjuWQjcwq8S/fydPhxpIT/10hsiQF+q+EtihbL2KKBO4sZyaGMhIx5AJjswQaRK3WGfX9U7wt/plBz3G8sndRtmillHoc/kRPjTLNh6m1d3hCMFIFcIYpQPFXdxasOfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by PH8PR11MB6879.namprd11.prod.outlook.com (2603:10b6:510:229::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.37; Thu, 18 Apr
 2024 00:55:19 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::ed72:f69c:be80:b034]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::ed72:f69c:be80:b034%4]) with mapi id 15.20.7472.037; Thu, 18 Apr 2024
 00:55:19 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Jiang, Dave" <dave.jiang@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
CC: "Williams, Dan J" <dan.j.williams@intel.com>, "Lee, Wonjae"
	<wj28.lee@samsung.com>
Subject: Re: [NDCTL PATCH v2] ndctl: cxl: Remove dependency for attributes
 derived from IDENTIFY command
Thread-Topic: [NDCTL PATCH v2] ndctl: cxl: Remove dependency for attributes
 derived from IDENTIFY command
Thread-Index: AQHaYCpxcsQMHuC8h0WK2Q8LtsG9ILFtldIA
Date: Thu, 18 Apr 2024 00:55:19 +0000
Message-ID: <769ecd8ee591fac68f45b40f73c5b76c0d35f63f.camel@intel.com>
References: <20240215161620.2739089-1-dave.jiang@intel.com>
In-Reply-To: <20240215161620.2739089-1-dave.jiang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.4 (3.50.4-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|PH8PR11MB6879:EE_
x-ms-office365-filtering-correlation-id: 4af29843-4e75-4bc1-9643-08dc5f42382a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ss2Egvyj8KzB0tUXKxXhublSFs9Wa72KA6dVoreYZM8OH0DpU3N+tolwhJ95uOMEcQmvbsgbfMOwqAW6cf/CsCnFdCqvYiP5togZIBBdKwJXS664BORw2WpJQ3d9znh7B0TvOixfFChDVkKsT5GAxmyETmJwdci9VkjftjNCFwW+QLQhbWBc3rTc4d5R0T5H07thCHeLp9vkjtr3YySjzMSetEW/23hi8xiNsaSXoFFTWfhCdJr11CsT0v0Qx1i4XnsSCwX58y+h83rgV7rWdaIQhTmnkuYJvpkhTDAoAQzcfoHxC88fkBG9wlGmXFIX5WM9UUy8lkbqNJgcLwDO9O/m87CUqamQCEgFUTxUOTxuAZdwv2le15uL51sRou9N76Gdz819T7RzRm6FB+OfQpF21kZYvTmARkoutgEGvBBegpvu8wGBNmmrsSKILYYG+yuQwmNIUZEzfa+KudQayEr7qBNhfhJKgkdzrvzteXdx2QTpayIKCgQjrfUUdQAgS2F3txwE4Ljfa6wTE1+KHCcDhnKyjEGmtaaic8vskAPrgQqdjfPVzBeQB6oFCMQwfKzW/WE3zjKvxKIWi9z3dP8/tCsLhvSAYhn9IwKLaOoGlpmFpXftBJFxdXtJt9S6QI1W8+jtwcKhxjfY6d55k0aYE3MGg6epz/rpAA0GiSZPRnZc+r9qQLcmhOCBOjpSBoraE+NS80cJc+LswuVbrJt0C/6PXlupFGLDbwHV/3A=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OXFJbHJCaGVKMDZpZGNXeWtNc0ZHaG11UExBTFNWQThiVVFxOTk0RmN3WE1T?=
 =?utf-8?B?VzFVREtKcXFQbzQrMEd0ZzhjbFQ4bFJOb2tTdmtYNlRYSzhVaGpNZ1B5UVYw?=
 =?utf-8?B?ejdxWmh6NkVBODJQQWorSi9DYnB5MEJNZHF6MjBoMkpKZXBPalFHKy9VdHVR?=
 =?utf-8?B?WEN6Wjh0ektaVHlRL2lib2ZlN1ZjbEVXYWd2ZDVqTnIwdnV6aVFHM2VOK01Z?=
 =?utf-8?B?SGpOSVA1dmxKd04rTldsb0M4OVZYU25XdEZ1NGE0ME5mV1RLbWVWeHpuR2RK?=
 =?utf-8?B?UjE0cnVYVUNFNGNjS054RkhjZnJZdVdXWDJSbEUraWNaZkdzT3I2QUc2cTJo?=
 =?utf-8?B?RzIzM01VRW5KdFlUTW82aWlJTjFoRDhmdyt6RHBhdWlPZTkwalNlYzlyWDVP?=
 =?utf-8?B?amNHVm1xTlNab3BSaTdGMWtHcnFsYUN4TDdmSTdhUWhOWkNaVUhLZG80Z3cw?=
 =?utf-8?B?THdSNDA2VzhoZGlXdmtLdVRBK0VJc1V4V1lYamIzblVXTTFQU1laaTl3OFpp?=
 =?utf-8?B?M28rM2xQU1BUS1BLSHVGTkVqaTVZTXZEbVdJYVJRTVNUQzZOdTRybis3THFY?=
 =?utf-8?B?OUpkcGZEbFhrbUdkYWNXZE5qUzlWd0V2ZWc4bEZVQjlwbzhFamlCa3FwWEtl?=
 =?utf-8?B?STFIMDI1ZTluS29pcVBOQUd0ZlFEOHRnTEdXRVY1Z2xPWWFRdG9SSDdQcDkw?=
 =?utf-8?B?UmdYT3I0OUxXbExQaklSclVlSHdVMUZHV29GRVNiN1FWMnlBR2ZzRDVzQ3NO?=
 =?utf-8?B?TERYaXUxNzNFbTk5NWZxNXUrYjc3NGVtK1VpOGdhVEZKbTJyclBTbE5oUStv?=
 =?utf-8?B?Y1FVM2FRamdEVzlKdzgyczZBeFJpL1ZxMW10VlFDeDFQT2FaUGEvOWRyeFlH?=
 =?utf-8?B?VTJIYzllOWsrY29BUDBzQ2sycDFPaElmaTF1WGIwcU5sNWpyZXRwWmFuSkk0?=
 =?utf-8?B?MHJOVUZ2V2t6OU5OeTJ6WlpYWE0vaWZnUStMMGkwU2dGSlBlSzNyT24ycUU0?=
 =?utf-8?B?TUI0WWNSbGR4S05XTW5MRjk3RHZ1bVBnQWs4bkNjM05yS0wyN3pSRTdjczky?=
 =?utf-8?B?RnRxLzJIQTE0czdzbXN1TEtqVk9TOHdCNUQ4MitMRXRKSElBS1NPSjhER2xZ?=
 =?utf-8?B?RVRrTWdkeUlWalV5by84ZERnZU96U1JCeGd5QnVPUm91bnF5ZFNHY1dSUzMr?=
 =?utf-8?B?ZVhkeDV2UVZxVHJzUjNqQ3RWUzR0MmhMaFpkRk1ybmlKbUNMRllndStNN04v?=
 =?utf-8?B?MEx4NUUvblZPalJtSHZKRmJYSC9aUS9lZVRlUTg4REpydzZXcnBHaVVMZWM2?=
 =?utf-8?B?Q2pXL1U5ZE84SnNMMStpTmllTC81TmgreTJXZXJ3N2VZbHBXRDd4bXRRODBU?=
 =?utf-8?B?Tk1Nd1dobWYyVW1PUmFuNU9kNGZXSXVXeFhPalB4eGQzQmNRU3hSMXhDeE4z?=
 =?utf-8?B?WjJqWEFDV2xScnhPVHFlMzhCVlRaYTNWM1RJaDJCM2RKNUVKUm9SakdTdU9N?=
 =?utf-8?B?S1lsdFdDL0RoeDNaeWRRREtiM3hhNm5aNzQ0alh6TjZqUUV1ZmtORDgwdHZN?=
 =?utf-8?B?SE10bVZ2M1VvcG50SEFvSTlVOGZ2Y1VjT3ZwR3VOcjZneGZucVdnVHh1L0xK?=
 =?utf-8?B?bHVNN2greXVOM0F6bVJSTGZycTl0aXowZ3FVK2svdjU2MlFmKzhoaEszcVk2?=
 =?utf-8?B?MkJ3K3lzdlYrN0Z3RFVuSFdLbzdFekRnV3BKRlFIK1NNRkdkMmVRV2tVeHlF?=
 =?utf-8?B?bHhpK0lNL05hOFRTdWJlN3VEdDYyRjY3VkdBTFpxb2VJUGVxdW95S2lZbFdx?=
 =?utf-8?B?L1ZRUko5NTZPQ3U5S0o5VmphaHlmYk5Od1U0cVhmRTNJOW92dXZNZG9oTFBQ?=
 =?utf-8?B?Rmt3cE8xck9zZk9YSjFnNUJVQlp2dFQyR2EzSGhrSEQvRURXcEQ2OUxlcE9w?=
 =?utf-8?B?ZURJalQwcDQySkZCeEF0Nm1CL2d0cFhIcGtzd25zWTdrMlNnTHhvNS9GQWtH?=
 =?utf-8?B?anB3QVFPNDhhaVJYOUJVc1c2QXp3UGd0aktFSUNsUWV3YTgvZnc2MzgxdCs4?=
 =?utf-8?B?VmxMNitUanBWVGVHdUNFb3BwL2dCTnVWbGF4OTVSdGd4YkQwOVpPa0dSOFBj?=
 =?utf-8?B?bktYM0tlL2JYOTc2djFucnladThIMWdwdkVVL3ZGaWdEVHE5UzZmckpVVzA3?=
 =?utf-8?B?SUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1E62EEB79B6E134FA90C81A07037942C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4af29843-4e75-4bc1-9643-08dc5f42382a
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2024 00:55:19.3951
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tA1UxKuI09SnLjpw82uyH6cSvlM6qSoSYJjg4bIhGcyN6V1Mb72zRkit/bWfYcXxASRAa/soaZ4Rwfg5NddTsiW476SOP/t/snp58XuC420=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6879
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTAyLTE1IGF0IDA5OjE2IC0wNzAwLCBEYXZlIEppYW5nIHdyb3RlOg0KPiBB
IG1lbWRldiBtYXkgb3B0aW9uYWxseSBub3QgaG9zdCBhIG1haWxib3ggYW5kIHRoZXJlZm9yZSBu
b3QgYWJsZSB0byBleGVjdXRlDQo+IHRoZSBJREVOVElGWSBjb21tYW5kLiBDdXJyZW50bHkgdGhl
IGtlcm5lbCBlbWl0cyBlbXB0eSBzdHJpbmdzIGZvciBzb21lIG9mDQo+IHRoZSBhdHRyaWJ1dGVz
IGluc3RlYWQgb2YgbWFraW5nIHRoZW0gaW52aXNpYmxlIGluIG9yZGVyIHRvIGtlZXAgYmFja3dh
cmQNCj4gY29tcGF0aWJpbGl0eSBmb3IgQ1hMIENMSS4gUmVtb3ZlIGRlcGVuZGVuY3kgb2YgQ1hM
IENMSSBvbiB0aGUgZXhpc3RhbmNlIG9mDQo+IHRoZXNlIGF0dHJpYnV0ZXMgYW5kIG9ubHkgZXhw
b3NlIHRoZW0gaWYgdGhleSBleGlzdC4gV2l0aG91dCB0aGUgZGVwZW5kZW5jeQ0KPiB0aGUga2Vy
bmVsIHdpbGwgYmUgYWJsZSB0byBtYWtlIHRoZSBub24tZXhpc3RhbnQgYXR0cmlidXRlcyBpbnZp
c2libGUuDQo+IA0KPiBMaW5rOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvMjAyMzA2MDYx
MjE1MzQuMDAwMDM4NzBASHVhd2VpLmNvbS8NCj4gU3VnZ2VzdGVkLWJ5OiBEYW4gV2lsbGlhbXMg
PGRhbi5qLndpbGxpYW1zQGludGVsLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogRGF2ZSBKaWFuZyA8
ZGF2ZS5qaWFuZ0BpbnRlbC5jb20+DQo+IC0tLQ0KPiB2MjoNCj4gLSBBZGQgbGFibGUgc2l6ZSBj
aGVjayBmb3IgYWN0aW9uX3dyaXRlKCkuIChXb25qYWUpDQo+IC0tLQ0KPiDCoGN4bC9saWIvbGli
Y3hsLmMgfCA0OCArKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0NCj4gwqBjeGwvbWVtZGV2LmPCoMKgwqDCoCB8IDE4ICsrKysrKysrKysrKystLS0tLQ0KPiDC
oDIgZmlsZXMgY2hhbmdlZCwgMzkgaW5zZXJ0aW9ucygrKSwgMjcgZGVsZXRpb25zKC0pDQo+IA0K
PiBkaWZmIC0tZ2l0IGEvY3hsL2xpYi9saWJjeGwuYyBiL2N4bC9saWIvbGliY3hsLmMNCj4gaW5k
ZXggMTUzN2EzM2QzNzBlLi5mODA3ZWM0ZWQ0ZTYgMTAwNjQ0DQo+IC0tLSBhL2N4bC9saWIvbGli
Y3hsLmMNCj4gKysrIGIvY3hsL2xpYi9saWJjeGwuYw0KPiBAQCAtMTI1MSwyOCArMTI1MSwzMCBA
QCBzdGF0aWMgdm9pZCAqYWRkX2N4bF9tZW1kZXYodm9pZCAqcGFyZW50LCBpbnQgaWQsIGNvbnN0
IGNoYXIgKmN4bG1lbV9iYXNlKQ0KPiDCoAltZW1kZXYtPm1pbm9yID0gbWlub3Ioc3Quc3RfcmRl
dik7DQo+IMKgDQo+IMKgCXNwcmludGYocGF0aCwgIiVzL3BtZW0vc2l6ZSIsIGN4bG1lbV9iYXNl
KTsNCj4gLQlpZiAoc3lzZnNfcmVhZF9hdHRyKGN0eCwgcGF0aCwgYnVmKSA8IDApDQo+IC0JCWdv
dG8gZXJyX3JlYWQ7DQo+IC0JbWVtZGV2LT5wbWVtX3NpemUgPSBzdHJ0b3VsbChidWYsIE5VTEws
IDApOw0KPiArCWlmIChzeXNmc19yZWFkX2F0dHIoY3R4LCBwYXRoLCBidWYpID09IDApDQo+ICsJ
CW1lbWRldi0+cG1lbV9zaXplID0gc3RydG91bGwoYnVmLCBOVUxMLCAwKTsNCj4gwqANCj4gwqAJ
c3ByaW50ZihwYXRoLCAiJXMvcmFtL3NpemUiLCBjeGxtZW1fYmFzZSk7DQo+IC0JaWYgKHN5c2Zz
X3JlYWRfYXR0cihjdHgsIHBhdGgsIGJ1ZikgPCAwKQ0KPiAtCQlnb3RvIGVycl9yZWFkOw0KPiAt
CW1lbWRldi0+cmFtX3NpemUgPSBzdHJ0b3VsbChidWYsIE5VTEwsIDApOw0KPiArCWlmIChzeXNm
c19yZWFkX2F0dHIoY3R4LCBwYXRoLCBidWYpID09IDApDQo+ICsJCW1lbWRldi0+cmFtX3NpemUg
PSBzdHJ0b3VsbChidWYsIE5VTEwsIDApOw0KPiDCoA0KPiDCoAlzcHJpbnRmKHBhdGgsICIlcy9w
YXlsb2FkX21heCIsIGN4bG1lbV9iYXNlKTsNCj4gLQlpZiAoc3lzZnNfcmVhZF9hdHRyKGN0eCwg
cGF0aCwgYnVmKSA8IDApDQo+IC0JCWdvdG8gZXJyX3JlYWQ7DQo+IC0JbWVtZGV2LT5wYXlsb2Fk
X21heCA9IHN0cnRvdWxsKGJ1ZiwgTlVMTCwgMCk7DQo+IC0JaWYgKG1lbWRldi0+cGF5bG9hZF9t
YXggPCAwKQ0KPiAtCQlnb3RvIGVycl9yZWFkOw0KPiArCWlmIChzeXNmc19yZWFkX2F0dHIoY3R4
LCBwYXRoLCBidWYpID09IDApIHsNCj4gKwkJbWVtZGV2LT5wYXlsb2FkX21heCA9IHN0cnRvdWxs
KGJ1ZiwgTlVMTCwgMCk7DQo+ICsJCWlmIChtZW1kZXYtPnBheWxvYWRfbWF4IDwgMCkNCj4gKwkJ
CWdvdG8gZXJyX3JlYWQ7DQo+ICsJfSBlbHNlIHsNCj4gKwkJbWVtZGV2LT5wYXlsb2FkX21heCA9
IC0xOw0KPiArCX0NCj4gwqANCj4gwqAJc3ByaW50ZihwYXRoLCAiJXMvbGFiZWxfc3RvcmFnZV9z
aXplIiwgY3hsbWVtX2Jhc2UpOw0KPiAtCWlmIChzeXNmc19yZWFkX2F0dHIoY3R4LCBwYXRoLCBi
dWYpIDwgMCkNCj4gLQkJZ290byBlcnJfcmVhZDsNCj4gLQltZW1kZXYtPmxzYV9zaXplID0gc3Ry
dG91bGwoYnVmLCBOVUxMLCAwKTsNCj4gLQlpZiAobWVtZGV2LT5sc2Ffc2l6ZSA9PSBVTExPTkdf
TUFYKQ0KPiAtCQlnb3RvIGVycl9yZWFkOw0KPiArCWlmIChzeXNmc19yZWFkX2F0dHIoY3R4LCBw
YXRoLCBidWYpID09IDApIHsNCj4gKwkJbWVtZGV2LT5sc2Ffc2l6ZSA9IHN0cnRvdWxsKGJ1Ziwg
TlVMTCwgMCk7DQo+ICsJCWlmIChtZW1kZXYtPmxzYV9zaXplID09IFVMTE9OR19NQVgpDQo+ICsJ
CQlnb3RvIGVycl9yZWFkOw0KPiArCX0gZWxzZSB7DQo+ICsJCW1lbWRldi0+bHNhX3NpemUgPSBV
TExPTkdfTUFYOw0KPiArCX0NCj4gwqANCj4gwqAJc3ByaW50ZihwYXRoLCAiJXMvc2VyaWFsIiwg
Y3hsbWVtX2Jhc2UpOw0KPiDCoAlpZiAoc3lzZnNfcmVhZF9hdHRyKGN0eCwgcGF0aCwgYnVmKSA8
IDApDQo+IEBAIC0xMjk5LDEyICsxMzAxLDExIEBAIHN0YXRpYyB2b2lkICphZGRfY3hsX21lbWRl
dih2b2lkICpwYXJlbnQsIGludCBpZCwgY29uc3QgY2hhciAqY3hsbWVtX2Jhc2UpDQo+IMKgCWhv
c3RbMF0gPSAnXDAnOw0KPiDCoA0KPiDCoAlzcHJpbnRmKHBhdGgsICIlcy9maXJtd2FyZV92ZXJz
aW9uIiwgY3hsbWVtX2Jhc2UpOw0KPiAtCWlmIChzeXNmc19yZWFkX2F0dHIoY3R4LCBwYXRoLCBi
dWYpIDwgMCkNCj4gLQkJZ290byBlcnJfcmVhZDsNCj4gLQ0KPiAtCW1lbWRldi0+ZmlybXdhcmVf
dmVyc2lvbiA9IHN0cmR1cChidWYpOw0KPiAtCWlmICghbWVtZGV2LT5maXJtd2FyZV92ZXJzaW9u
KQ0KPiAtCQlnb3RvIGVycl9yZWFkOw0KPiArCWlmIChzeXNmc19yZWFkX2F0dHIoY3R4LCBwYXRo
LCBidWYpID09IDApIHsNCj4gKwkJbWVtZGV2LT5maXJtd2FyZV92ZXJzaW9uID0gc3RyZHVwKGJ1
Zik7DQo+ICsJCWlmICghbWVtZGV2LT5maXJtd2FyZV92ZXJzaW9uKQ0KPiArCQkJZ290byBlcnJf
cmVhZDsNCj4gKwl9DQo+IMKgDQo+IMKgCW1lbWRldi0+ZGV2X2J1ZiA9IGNhbGxvYygxLCBzdHJs
ZW4oY3hsbWVtX2Jhc2UpICsgNTApOw0KPiDCoAlpZiAoIW1lbWRldi0+ZGV2X2J1ZikNCj4gQEAg
LTQ1NDMsNiArNDU0NCw5IEBAIHN0YXRpYyBpbnQgbHNhX29wKHN0cnVjdCBjeGxfbWVtZGV2ICpt
ZW1kZXYsIGludCBvcCwgdm9pZCAqYnVmLA0KPiDCoAlpZiAobGVuZ3RoID09IDApDQo+IMKgCQly
ZXR1cm4gMDsNCj4gwqANCj4gKwlpZiAobWVtZGV2LT5wYXlsb2FkX21heCA8IDApDQo+ICsJCXJl
dHVybiAtRUlOVkFMOw0KPiArDQo+IMKgCWxhYmVsX2l0ZXJfbWF4ID0gbWVtZGV2LT5wYXlsb2Fk
X21heCAtIHNpemVvZihzdHJ1Y3QgY3hsX2NtZF9zZXRfbHNhKTsNCj4gwqAJd2hpbGUgKHJlbWFp
bmluZykgew0KPiDCoAkJY3VyX2xlbiA9IG1pbigoc2l6ZV90KWxhYmVsX2l0ZXJfbWF4LCByZW1h
aW5pbmcpOw0KPiBkaWZmIC0tZ2l0IGEvY3hsL21lbWRldi5jIGIvY3hsL21lbWRldi5jDQo+IGlu
ZGV4IDgxZjA3OTkxZGEwNi4uMDhiNmFhNTAxNzVmIDEwMDY0NA0KPiAtLS0gYS9jeGwvbWVtZGV2
LmMNCj4gKysrIGIvY3hsL21lbWRldi5jDQo+IEBAIC00NzMsMTAgKzQ3MywxMyBAQCBzdGF0aWMg
aW50IGFjdGlvbl96ZXJvKHN0cnVjdCBjeGxfbWVtZGV2ICptZW1kZXYsIHN0cnVjdCBhY3Rpb25f
Y29udGV4dCAqYWN0eCkNCj4gwqAJc2l6ZV90IHNpemU7DQo+IMKgCWludCByYzsNCj4gwqANCj4g
LQlpZiAocGFyYW0ubGVuKQ0KPiArCWlmIChwYXJhbS5sZW4pIHsNCj4gwqAJCXNpemUgPSBwYXJh
bS5sZW47DQo+IC0JZWxzZQ0KPiArCX0gZWxzZSB7DQo+IMKgCQlzaXplID0gY3hsX21lbWRldl9n
ZXRfbGFiZWxfc2l6ZShtZW1kZXYpOw0KPiArCQlpZiAoc2l6ZSA9PSBVTExPTkdfTUFYKQ0KDQpJ
bmNvbnNpc3RlbmN5IGJldHdlZW4gVUxMT05HX01BWCBoZXJlIGFuZCBVTE9OR19NQVggYmVsb3cu
IFRoaXMgc2hvdWxkDQphY3R1YWxseSBiZSBTSVpFX01BWCBjb25zaWRlcmluZyB0aGUgcmV0dXJu
IHR5cGUuDQoNClNpbWlsYXJseSwgd2hlbiBzZXR0aW5nIGxzYV9zaXplIGluIGFkZF9jeGxfbWVt
ZGV2KCkgYWJvdmUsIGluIHRoZQ0KJ2Vsc2UnIGNhc2Ugd2hlcmUgdGhlIHN5c2ZzIGF0dHIgd2Fz
IGFic2VudCwgd2Ugc2hvdWxkIHVzZSBTSVpFX01BWC4NCg0KSW4gdGhlIGVycm9yIGNhc2UgZm9y
IHN0cnRvdWxsKCksIGl0J3MgcHJvYmFibHkgZmluZSB0byBsZWF2ZSB0aGUgY2hlY2sNCmZvciBV
TExPTkdfTUFYIHNpbmNlIHRoYXQgaXMgdGhlIG1heCB2YWx1ZSBzdHJ0b3VsbCgpIHdpbGwgcmV0
dXJuLCBhbmQNCndlJ3JlIGVycm9yaW5nIG91dCBhdCB0aGF0IHBvaW50IGFueXdheS4gSSBzdXBw
b3NlIHRoZSByaWdodCB0aGluZyB0bw0KZG8gdGhlcmUgd291bGQgYmUgdG8gdXNlIHNzY2FuZigp
IHdpdGggJXp1IHRvIHBhcnNlIGl0IGNvcnJlY3RseSBmb3INCnNpemVfdCAob2YgY291cnNlIHRo
aXMgaW5jb3JyZWN0bmVzcyBwcmVkYXRlcyB0aGlzIHBhdGNoLi4pDQoNCj4gKwkJCXJldHVybiAt
RUlOVkFMOw0KPiArCX0NCj4gwqANCj4gwqAJaWYgKGN4bF9tZW1kZXZfbnZkaW1tX2JyaWRnZV9h
Y3RpdmUobWVtZGV2KSkgew0KPiDCoAkJbG9nX2VycigmbWwsDQo+IEBAIC01MDksNiArNTEyLDkg
QEAgc3RhdGljIGludCBhY3Rpb25fd3JpdGUoc3RydWN0IGN4bF9tZW1kZXYgKm1lbWRldiwgc3Ry
dWN0IGFjdGlvbl9jb250ZXh0ICphY3R4KQ0KPiDCoAlpZiAoIXNpemUpIHsNCj4gwqAJCXNpemVf
dCBsYWJlbF9zaXplID0gY3hsX21lbWRldl9nZXRfbGFiZWxfc2l6ZShtZW1kZXYpOw0KPiDCoA0K
PiArCQlpZiAobGFiZWxfc2l6ZSA9PSBVTE9OR19NQVgpDQo+ICsJCQlyZXR1cm4gLUVJTlZBTDsN
Cj4gKw0KPiDCoAkJZnNlZWsoYWN0eC0+Zl9pbiwgMEwsIFNFRUtfRU5EKTsNCj4gwqAJCXNpemUg
PSBmdGVsbChhY3R4LT5mX2luKTsNCj4gwqAJCWZzZWVrKGFjdHgtPmZfaW4sIDBMLCBTRUVLX1NF
VCk7DQo+IEBAIC01NDcsMTEgKzU1MywxMyBAQCBzdGF0aWMgaW50IGFjdGlvbl9yZWFkKHN0cnVj
dCBjeGxfbWVtZGV2ICptZW1kZXYsIHN0cnVjdCBhY3Rpb25fY29udGV4dCAqYWN0eCkNCj4gwqAJ
Y2hhciAqYnVmOw0KPiDCoAlpbnQgcmM7DQo+IMKgDQo+IC0JaWYgKHBhcmFtLmxlbikNCj4gKwlp
ZiAocGFyYW0ubGVuKSB7DQo+IMKgCQlzaXplID0gcGFyYW0ubGVuOw0KPiAtCWVsc2UNCj4gKwl9
IGVsc2Ugew0KPiDCoAkJc2l6ZSA9IGN4bF9tZW1kZXZfZ2V0X2xhYmVsX3NpemUobWVtZGV2KTsN
Cj4gLQ0KPiArCQlpZiAoc2l6ZSA9PSBVTExPTkdfTUFYKQ0KPiArCQkJcmV0dXJuIC1FSU5WQUw7
DQo+ICsJfQ0KPiDCoAlidWYgPSBjYWxsb2MoMSwgc2l6ZSk7DQo+IMKgCWlmICghYnVmKQ0KPiDC
oAkJcmV0dXJuIC1FTk9NRU07DQoNCg==
