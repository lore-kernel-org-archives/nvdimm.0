Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D21917EC
	for <nvdimm@lists.linux.dev>; Wed, 15 Feb 2023 05:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676437626; x=1707973626;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ErJQTO9oihPo5wImMu8lX8LAWSWgMFRKIoSocwJYMKQ=;
  b=cyn8MwM4MLP1rRXSmgJMAdLVtogyKlFd2szShAPZEhXZTb++HQsUbSQl
   QfYy1ZEUSrgTSB31kSmL6G6Noeb2ufW1TnhZBnrvC1eYrLeNyU7qnTonG
   ScLQXuPTos26kjkPvoLfBo5gwgKHsosvmT6oglNl4l13bQxVRnueJ0WuA
   6oxlaBwOk8ro2pxhu0B1Xazck6+tdRLEPXBvvFeTaLVeavgFTparUNjUC
   /Gq94VyplgB4OSjG90OzzJQ6KuVn+U5oMth45q7oFJqTFb9m3u0KAErfY
   QU/LKzT+z8WS6MLdUTSBMJAySmUa6dHSt+6nxCAyyjvvKhuracbY63CpH
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="333483424"
X-IronPort-AV: E=Sophos;i="5.97,298,1669104000"; 
   d="scan'208";a="333483424"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 21:07:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="733140579"
X-IronPort-AV: E=Sophos;i="5.97,298,1669104000"; 
   d="scan'208";a="733140579"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 14 Feb 2023 21:07:01 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 21:07:01 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 21:07:01 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 21:07:01 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 21:07:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gbN+8EbHNL/gY/a+7C9p9Jxc52b7kKD36Qqm1TeBkLFxzGyMm798fI1WAf1ftXWYLxGdXjlMuHZRHRXVreY9EaS7HwAyrDGIMif+SkTbPMmCIo94x/+kmQ+/5OC8iuAWAxshr0lgUh2vpx6f0P6+kAmnPaXhAmKSLKf8a2/WRpQTH8BHh9FcdZxgf89ajaEezO+krLuEIOiGavXQXLXNKlHUHXZAe8dKI0StSuV2qKmqaSPETao7ZmHInK102hLL5w1jsIGSqXwZLz4OWPJBUV1ugNuZF+1gBpfVA6UEJo71OA+c0Uk3Z1JBLArBXofWgMgZd82Kem/7QD5ra8gG9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ErJQTO9oihPo5wImMu8lX8LAWSWgMFRKIoSocwJYMKQ=;
 b=j1ZQNRQAcR164DLOvaVibFcL7Gv+43TvNPZxit0rUiCKDzjDu2v+9HD2L57I5vdzTOk75Zv2jR5liGQ/2oD802XMRTR+UqbttFzWvmtqBq9gfM/AAkF3Kxu/jI2F8icdVMH8GxFp3R53Z8kvbsO14eqqUfzcY9jzlhYhSzYC7sE5np+ygX9eBAQpp1GOrKquMz8vaeILiA/Qu3oa/6GrNsl4ngiHVsKLCxa+tq3S6tvml0QvNDTAdByGYM9cCaKtbXMHO3IHAPc98cBHgpN6W21uHPeF9oF8gRJKYbtxgcUq56baQt5yu1x7pkDW/3KJhWGCir2FrQUCrOy6VMP5Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by SA1PR11MB6920.namprd11.prod.outlook.com (2603:10b6:806:2bb::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Wed, 15 Feb
 2023 05:06:53 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::35af:d7a8:8484:627]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::35af:d7a8:8484:627%5]) with mapi id 15.20.6086.024; Wed, 15 Feb 2023
 05:06:53 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "motin, alexander" <mav@ixsystems.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
CC: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [ndctl PATCH 2/2 v2 RESEND] libndctl/msft: Improve "smart" state
 reporting
Thread-Topic: [ndctl PATCH 2/2 v2 RESEND] libndctl/msft: Improve "smart" state
 reporting
Thread-Index: AQHZJ3Sc7U1iHEteTUCYFpUB4rj8VK7Pp7eA
Date: Wed, 15 Feb 2023 05:06:53 +0000
Message-ID: <b09c7aa27247123c6cc0c6df416831b9c6eb1efe.camel@intel.com>
References: <20230113172732.1122643-1-mav@ixsystems.com>
	 <20230113172732.1122643-2-mav@ixsystems.com>
In-Reply-To: <20230113172732.1122643-2-mav@ixsystems.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR11MB3999:EE_|SA1PR11MB6920:EE_
x-ms-office365-filtering-correlation-id: 0796d500-6610-4bf0-9c15-08db0f127405
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TMwj4qq93OsJw6YKBXDh/1nk/7pukB9pPYngzUzq4FoTF+QuL78y4hPXECNuQAGS7/DvTguyd4Y3y596D5iFXbtn+gBPNuECkENMIR+7IRCQX/IgskgqtsqyvXVVS1cYszZKd8J1L4ckOMUg4OFRXAqyzuqmnjmNy8ptCwk0dSGSNBlMIqKKL+34OuScxcSNZAiYWCxAUUqVP3109Mt0SHaO4owmZ9ym/JrHu8KYpo4xxvBeReynU7dHnRHo4EgMvZJaXFxjE63nUo9deYTmvHakgLdLIOfdZ+cLIGXzha0nJEU9ZxKiOsyRLmB9H0HVn+XtOYd+jNxhTrnfyrnRZvGe89AenAMzLM12yHkuH5M7sADmZvjqopbWb/Vn3NPZpMIWHqZNofzrCiHro6vzJVyLLu48oiQ79SmuCUvrri2gShEJxMmculnY2rTFHRI/9TSAcBiY+JCMmPhYS8EHcQsV1smSpKKH/RTy1ciJ3pfG1ji8XUbYaOFzvGK3GH1d3B/UJtMQfD48gjClhhntbAsG5pMmzGwuK7DVEVBOk7mjOKswzvv50uKsIWi/NclWm1b2eFlrGHdqa8L18N7qclLTC/ndhSjaTt6eDKd1FmWjylVZGe2OufEb7NpCrK5GnVioBD3oKLyMn+zjw2O072cTnf2+OMMHDLctzfM41OtqWTj5or4cba8gNV8kUi2UnZFIlC6+EX2V5+CUsu7vgQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(346002)(136003)(376002)(396003)(366004)(451199018)(86362001)(186003)(66446008)(41300700001)(91956017)(316002)(83380400001)(110136005)(66946007)(2616005)(64756008)(66556008)(66476007)(5660300002)(8936002)(478600001)(8676002)(4326008)(107886003)(6506007)(26005)(36756003)(6512007)(6486002)(76116006)(38070700005)(82960400001)(2906002)(38100700002)(122000001)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RE83Z2p5V1FzZ1RBR1Avb01GN3F3eitPQ0hjWUhyeENDNWxSN2RnS3B0QkRG?=
 =?utf-8?B?bWx6SGwyT2trNXd6bDdIQ2w3Y0VhS1o5SzA3ZXBEUng3Y1c3dmlEeFFqanpn?=
 =?utf-8?B?L0J4NmNmbE4zUysxVTBZb3RRb0lQV3gwRm5VcU1SZnk3UHcrSEpjcHBXMUlE?=
 =?utf-8?B?YU11aThaeFdKb3dsZWMxdmU3bFhLajRZdXEvWHJoZUhqZzFJTFF0SW5sbGVB?=
 =?utf-8?B?UFdZcy9kZEpDQUp0Z0U4Z2tXRTVObWRmZEpxOVVLRUk1MFI3VFVWY2hrbkw2?=
 =?utf-8?B?ZHBjQ1QzYTc3cGUxNGRsZHhzSHp6K012RjhjelpURldhZWZJSW80T3RQaU9M?=
 =?utf-8?B?dzBZSkV3Q1FQcGw4YisyRTRza3lacFFvSENrVFh2RFNNc1lCRXhuWTh0czhT?=
 =?utf-8?B?MENsUisyL3pVL3l3aHRoSVR5Y3podmkrc1Q5L1NtRks5WE9SVVVsRjFzRmF0?=
 =?utf-8?B?SG5CZFpzMnhsMFk3dEtER20rZ3U0MDJIMlQrWUd1Z0Y3Q1hZTkJjVVQ0NkJ6?=
 =?utf-8?B?VkNNaytIbVRKREV2Y2VnVm1UUUV5amEzdVBsTEFKWElYNGYxYytQRjV4Q3hk?=
 =?utf-8?B?V2pBdURkQTdWMTVqQTN5UmVOdzdkeWNKR3VMNXlTeHJFVTExc3NTZmh4aHVG?=
 =?utf-8?B?WEg0aGtyRjVuMExhdTh4ZnNQN0JsNGQ0ZlFkRHlRZE9LVnp1QU1BalplK3BM?=
 =?utf-8?B?SWp4L3RJS3ZIR2RLMVhIbGxOWlJjd1ZaN0UwVmEvZS9BYmlRNkRWdzh2R3RL?=
 =?utf-8?B?Nkp6Rm1ZS0FyUFkrOVY3K0hzZE55ZFdVRDhLQXVVM1d5QU9kdTZQeVJhQjBr?=
 =?utf-8?B?eEZNdUJyQkV3YXNqTitVb0xXOGU2bGhJVFE0eVVMUDVadmVNZmgrT1BGNC9y?=
 =?utf-8?B?QVZPRG1udmptcE9NRkRWNlBLY09MclpFZE9ZeThQWk52T2NpVXdsUmZ5MjJz?=
 =?utf-8?B?Q2kyb290TWJGcXl5dlphVC9sZ0R2eUNtSnBkajFTWGQ1ZFJmYnhzNnVxTTVp?=
 =?utf-8?B?anZIejFleXZGVm9QcnpFb3QrSzJYUEVsaWZCOFdvenJsMEl4MTdLdkh3YTRR?=
 =?utf-8?B?ZXBCb3ZxOTJDVDZ4TDNLVERRRG9SMjVzWU5tcHBrK3FjNWlFVitMdnB5azZX?=
 =?utf-8?B?TGgzR2dRVk93TlZDV0I2MVd1ck5lUjJTUHlYcGJla0dKVi9WNlRocXpnWXBL?=
 =?utf-8?B?NXlmckxsL2NmVkxvUWFHaGtDVWhPMTZ5eHNzNGQralZaSHRhbWRDcWVRdnVz?=
 =?utf-8?B?UnYyTGQwdzBEOUgxNVdYQWcyRStja2FBUEhwVmIrNHVtT2FnUzI4KzJjN3d4?=
 =?utf-8?B?WHAwaDVrQzRhZ0E4dmp6cHBpaUNZb2J5dkJGNHd5VnIySmthUWp1NldVTU9k?=
 =?utf-8?B?M1M1NlIzcnBnNFZFbHp1VWlybHkzcXpZcFIxdGxYcUxVVUF2WE8xdlJ0Y3pu?=
 =?utf-8?B?b3B6Q2hFNWNNR014RVJ6SytobWp1a25qOUlMRWFFbUNUcFd1VWRhRWxEK1lM?=
 =?utf-8?B?d1VUMVg5SGNqN0NOZzY4Zjd3OFZOV1E5VWQ0MFJZU0RHdnI2ak55R25iQzlM?=
 =?utf-8?B?cDZDN2s2V2xZMENXNS9SMEZlUWtrczJhVW9DYzZJRFIramJBbUhvckJPVHZn?=
 =?utf-8?B?SEZXQXBrSGtVaEtmS1ZGUjBVRUlGVHhjUFZacDZVL0tXQ25Nelg0bXNYWDRs?=
 =?utf-8?B?RC9sckozck54VVgxbjdZTERmdCtCOXM3N2ZiajQ3aWpLc21aN0JaZS9XTTA3?=
 =?utf-8?B?Vzd0ZHNSZDAvZkJKdis1eHZkZ0xHcWtjS09kS1F1ZzAwTC9qSlJUcSsvWmNw?=
 =?utf-8?B?UHBaajJMRE1XaXowZkMyZCtOdlFBeVpvT3ZOMWZ0SkwwYlZoblRHYzR2RXVh?=
 =?utf-8?B?NUg0a3VVeno4WldvSVFHMDVnMzBROU9vaWltd1pudXFWWm45M1d1ekkveVVy?=
 =?utf-8?B?aXdwd21GZXBBZjVFSXg3RlpDU0hvVy9mLzAwQy9pMkdyNlVvSXlONWZhVkRR?=
 =?utf-8?B?cERtT2hyVjRucG9NcEJqVVhnS1BZdHBwVk5UTm55TzM0SUZsWWJoNFRKNm1I?=
 =?utf-8?B?YitnVkdxcmwwdVVHRXdIODJJSDUyOVJJaWwreXFYZEgvK1hBOWdienFaSWpq?=
 =?utf-8?B?NFdLeElYQzZIandUb1Z5UThFdXNvakNWcFNTV0tmWFN0aEVnZ1ROajVicnVR?=
 =?utf-8?B?YWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <70749A89BC6D374EAEBF24F54A03C817@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0796d500-6610-4bf0-9c15-08db0f127405
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2023 05:06:53.2784
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j0HnNY1Sdd75wk+EpLn/EVDalZcN7KZANyoZasYR7z8TFdIOVxIaa4YiE+BeqZbH6hkyEEe2ydLPq55GDqUMeL9nUAEZjnGoR2r1ABnqDK4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6920
X-OriginatorOrg: intel.com

W0Ryb3BwaW5nIExpanVuIGZyb20gQ0MgZHVlIHRvIGEgYm91bmNlXQoKT24gRnJpLCAyMDIzLTAx
LTEzIGF0IDEyOjI3IC0wNTAwLCBBbGV4YW5kZXIgTW90aW4gd3JvdGU6Cj4gUHJldmlvdXMgY29k
ZSByZXBvcnRlZCAic21hcnQiIHN0YXRlIGJhc2VkIG9uIG51bWJlciBvZiBiaXRzCj4gc2V0IGlu
IHRoZSBtb2R1bGUgaGVhbHRoIGZpZWxkLsKgIEJ1dCBhY3R1YWxseSBhbnkgc2luZ2xlIGJpdAo+
IHNldCB0aGVyZSBhbHJlYWR5IG1lYW5zIGNyaXRpY2FsIGZhaWx1cmUuwqAgUmV3b3JrIHRoZSBs
b2dpYwo+IGFjY29yZGluZyB0byBzcGVjaWZpY2F0aW9uLCBwcm9wZXJseSByZXBvcnRpbmcgbm9u
LWNyaXRpY2FsCj4gc3RhdGUgaW4gY2FzZSBvZiB3YXJuaW5nIHRocmVzaG9sZCByZWFjaGVkLCBj
cml0aWNhbCBpbiBjYXNlCj4gb2YgYW55IG1vZHVsZSBoZWFsdGggYml0IHNldCBvciBlcnJvciB0
aHJlc2hvbGQgcmVhY2hlZCBhbmQKPiBmYXRhbCBpZiBOVkRJTU0gZXhoYXVzdGVkIGl0cyBsaWZl
IHRpbWUuwqAgSW4gYXR0ZW1wdCB0bwo+IHJlcG9ydCB0aGUgY2F1c2Ugb2YgZmFpbHVyZSBpbiBh
YnNlbmNlIG9mIGJldHRlciBtZXRob2RzLAo+IHJlcG9ydCByZWFjaGVkIHRocmVzaG9sZHMgYXMg
bW9yZSBvciBsZXNzIG1hdGNoaW5nIGFsYXJtcy4KClRoaXMgbG9va3MgbGlrZSB1bm5lY2Vzc2Fy
aWx5IGFnZ3Jlc3NpdmUgd3JhcHBpbmcuIENvbW1pdCBtZXNzYWdlcyBhcmUKdHlwaWNhbGx5IHdy
YXBwZWQgYXQgNzIgY2hhcnMuCgpPdGhlciB0aGFuIHRoYXQgdGhpcyBsb29rcyBmaW5lLgoKPiAK
PiBTaWduZWQtb2ZmLWJ5OiBBbGV4YW5kZXIgTW90aW4gPG1hdkBpeHN5c3RlbXMuY29tPgo+IC0t
LQo+IMKgbmRjdGwvbGliL21zZnQuYyB8IDU1ICsrKysrKysrKysrKysrKysrKysrKysrKysrLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLQo+IMKgMSBmaWxlIGNoYW5nZWQsIDMwIGluc2VydGlvbnMoKyks
IDI1IGRlbGV0aW9ucygtKQo+IAo+IGRpZmYgLS1naXQgYS9uZGN0bC9saWIvbXNmdC5jIGIvbmRj
dGwvbGliL21zZnQuYwo+IGluZGV4IGVmYzdmZTEuLjhmNjZjOTcgMTAwNjQ0Cj4gLS0tIGEvbmRj
dGwvbGliL21zZnQuYwo+ICsrKyBiL25kY3RsL2xpYi9tc2Z0LmMKPiBAQCAtMTE0LDI2ICsxMTQs
MzIgQEAgc3RhdGljIHVuc2lnbmVkIGludCBtc2Z0X2NtZF9zbWFydF9nZXRfZmxhZ3Moc3RydWN0
IG5kY3RsX2NtZCAqY21kKQo+IMKgCj4gwqDCoMKgwqDCoMKgwqDCoC8qIGJlbG93IGhlYWx0aCBk
YXRhIGNhbiBiZSByZXRyaWV2ZWQgdmlhIE1TRlQgX0RTTSBmdW5jdGlvbiAxMSAqLwo+IMKgwqDC
oMKgwqDCoMKgwqByZXR1cm4gTkRfU01BUlRfSEVBTFRIX1ZBTElEIHwgTkRfU01BUlRfVEVNUF9W
QUxJRCB8Cj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgIE5EX1NNQVJUX1VTRURfVkFMSUQ7Cj4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgIE5EX1NNQVJUX1VTRURfVkFMSUQgfCBORF9TTUFSVF9BTEFSTV9W
QUxJRDsKPiDCoH0KPiDCoAo+IC1zdGF0aWMgdW5zaWduZWQgaW50IG51bV9zZXRfYml0X2hlYWx0
aChfX3UxNiBudW0pCj4gK3N0YXRpYyB1bnNpZ25lZCBpbnQgbXNmdF9jbWRfc21hcnRfZ2V0X2hl
YWx0aChzdHJ1Y3QgbmRjdGxfY21kICpjbWQpCj4gwqB7Cj4gLcKgwqDCoMKgwqDCoMKgaW50IGk7
Cj4gLcKgwqDCoMKgwqDCoMKgX191MTYgbiA9IG51bSAmIDB4N0ZGRjsKPiAtwqDCoMKgwqDCoMKg
wqB1bnNpZ25lZCBpbnQgY291bnQgPSAwOwo+ICvCoMKgwqDCoMKgwqDCoHVuc2lnbmVkIGludCBo
ZWFsdGggPSAwOwo+ICvCoMKgwqDCoMKgwqDCoGludCByYzsKPiDCoAo+IC3CoMKgwqDCoMKgwqDC
oGZvciAoaSA9IDA7IGkgPCAxNTsgaSsrKQo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqBpZiAoISEobiAmICgxIDw8IGkpKSkKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoGNvdW50Kys7Cj4gK8KgwqDCoMKgwqDCoMKgcmMgPSBtc2Z0X3NtYXJ0
X3ZhbGlkKGNtZCk7Cj4gK8KgwqDCoMKgwqDCoMKgaWYgKHJjIDwgMCkgewo+ICvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqBlcnJubyA9IC1yYzsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgcmV0dXJuIFVJTlRfTUFYOwo+ICvCoMKgwqDCoMKgwqDCoH0KPiDCoAo+IC3CoMKg
wqDCoMKgwqDCoHJldHVybiBjb3VudDsKPiArwqDCoMKgwqDCoMKgwqBpZiAoQ01EX01TRlRfU01B
UlQoY21kKS0+bnZtX2xpZmV0aW1lID09IDApCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoGhlYWx0aCB8PSBORF9TTUFSVF9GQVRBTF9IRUFMVEg7Cj4gK8KgwqDCoMKgwqDCoMKgaWYg
KENNRF9NU0ZUX1NNQVJUKGNtZCktPmhlYWx0aCAhPSAwIHx8Cj4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgIENNRF9NU0ZUX1NNQVJUKGNtZCktPmVycl90aHJlc2hfc3RhdCAhPSAwKQo+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBoZWFsdGggfD0gTkRfU01BUlRfQ1JJVElDQUxfSEVBTFRI
Owo+ICvCoMKgwqDCoMKgwqDCoGlmIChDTURfTVNGVF9TTUFSVChjbWQpLT53YXJuX3RocmVzaF9z
dGF0ICE9IDApCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGhlYWx0aCB8PSBORF9T
TUFSVF9OT05fQ1JJVElDQUxfSEVBTFRIOwo+ICvCoMKgwqDCoMKgwqDCoHJldHVybiBoZWFsdGg7
Cj4gwqB9Cj4gwqAKPiAtc3RhdGljIHVuc2lnbmVkIGludCBtc2Z0X2NtZF9zbWFydF9nZXRfaGVh
bHRoKHN0cnVjdCBuZGN0bF9jbWQgKmNtZCkKPiArc3RhdGljIHVuc2lnbmVkIGludCBtc2Z0X2Nt
ZF9zbWFydF9nZXRfbWVkaWFfdGVtcGVyYXR1cmUoc3RydWN0IG5kY3RsX2NtZCAqY21kKQo+IMKg
ewo+IC3CoMKgwqDCoMKgwqDCoHVuc2lnbmVkIGludCBoZWFsdGg7Cj4gLcKgwqDCoMKgwqDCoMKg
dW5zaWduZWQgaW50IG51bTsKPiDCoMKgwqDCoMKgwqDCoMKgaW50IHJjOwo+IMKgCj4gwqDCoMKg
wqDCoMKgwqDCoHJjID0gbXNmdF9zbWFydF92YWxpZChjbWQpOwo+IEBAIC0xNDIsMjEgKzE0OCwx
MyBAQCBzdGF0aWMgdW5zaWduZWQgaW50IG1zZnRfY21kX3NtYXJ0X2dldF9oZWFsdGgoc3RydWN0
IG5kY3RsX2NtZCAqY21kKQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJu
IFVJTlRfTUFYOwo+IMKgwqDCoMKgwqDCoMKgwqB9Cj4gwqAKPiAtwqDCoMKgwqDCoMKgwqBudW0g
PSBudW1fc2V0X2JpdF9oZWFsdGgoQ01EX01TRlRfU01BUlQoY21kKS0+aGVhbHRoKTsKPiAtwqDC
oMKgwqDCoMKgwqBpZiAobnVtID09IDApCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oGhlYWx0aCA9IDA7Cj4gLcKgwqDCoMKgwqDCoMKgZWxzZSBpZiAobnVtIDwgMikKPiAtwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaGVhbHRoID0gTkRfU01BUlRfTk9OX0NSSVRJQ0FMX0hF
QUxUSDsKPiAtwqDCoMKgwqDCoMKgwqBlbHNlIGlmIChudW0gPCAzKQo+IC3CoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqBoZWFsdGggPSBORF9TTUFSVF9DUklUSUNBTF9IRUFMVEg7Cj4gLcKg
wqDCoMKgwqDCoMKgZWxzZQo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBoZWFsdGgg
PSBORF9TTUFSVF9GQVRBTF9IRUFMVEg7Cj4gLQo+IC3CoMKgwqDCoMKgwqDCoHJldHVybiBoZWFs
dGg7Cj4gK8KgwqDCoMKgwqDCoMKgcmV0dXJuIENNRF9NU0ZUX1NNQVJUKGNtZCktPnRlbXAgKiAx
NjsKPiDCoH0KPiDCoAo+IC1zdGF0aWMgdW5zaWduZWQgaW50IG1zZnRfY21kX3NtYXJ0X2dldF9t
ZWRpYV90ZW1wZXJhdHVyZShzdHJ1Y3QgbmRjdGxfY21kICpjbWQpCj4gK3N0YXRpYyB1bnNpZ25l
ZCBpbnQgbXNmdF9jbWRfc21hcnRfZ2V0X2FsYXJtX2ZsYWdzKHN0cnVjdCBuZGN0bF9jbWQgKmNt
ZCkKPiDCoHsKPiArwqDCoMKgwqDCoMKgwqBfX3U4IHN0YXQ7Cj4gK8KgwqDCoMKgwqDCoMKgdW5z
aWduZWQgaW50IGZsYWdzID0gMDsKPiDCoMKgwqDCoMKgwqDCoMKgaW50IHJjOwo+IMKgCj4gwqDC
oMKgwqDCoMKgwqDCoHJjID0gbXNmdF9zbWFydF92YWxpZChjbWQpOwo+IEBAIC0xNjUsNyArMTYz
LDEzIEBAIHN0YXRpYyB1bnNpZ25lZCBpbnQgbXNmdF9jbWRfc21hcnRfZ2V0X21lZGlhX3RlbXBl
cmF0dXJlKHN0cnVjdCBuZGN0bF9jbWQgKmNtZCkKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoHJldHVybiBVSU5UX01BWDsKPiDCoMKgwqDCoMKgwqDCoMKgfQo+IMKgCj4gLcKgwqDC
oMKgwqDCoMKgcmV0dXJuIENNRF9NU0ZUX1NNQVJUKGNtZCktPnRlbXAgKiAxNjsKPiArwqDCoMKg
wqDCoMKgwqBzdGF0ID0gQ01EX01TRlRfU01BUlQoY21kKS0+ZXJyX3RocmVzaF9zdGF0IHwKPiAr
wqDCoMKgwqDCoMKgwqDCoMKgwqAgQ01EX01TRlRfU01BUlQoY21kKS0+d2Fybl90aHJlc2hfc3Rh
dDsKPiArwqDCoMKgwqDCoMKgwqBpZiAoc3RhdCAmIDMpIC8qIE5WTV9MSUZFVElNRS9FU19MSUZF
VElNRSAqLwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBmbGFncyB8PSBORF9TTUFS
VF9TUEFSRV9UUklQOwo+ICvCoMKgwqDCoMKgwqDCoGlmIChzdGF0ICYgNCkgLyogRVNfVEVNUCAq
Lwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBmbGFncyB8PSBORF9TTUFSVF9DVEVN
UF9UUklQOwo+ICvCoMKgwqDCoMKgwqDCoHJldHVybiBmbGFnczsKPiDCoH0KPiDCoAo+IMKgc3Rh
dGljIHVuc2lnbmVkIGludCBtc2Z0X2NtZF9zbWFydF9nZXRfbGlmZV91c2VkKHN0cnVjdCBuZGN0
bF9jbWQgKmNtZCkKPiBAQCAtMjA5LDYgKzIxMyw3IEBAIHN0cnVjdCBuZGN0bF9kaW1tX29wcyAq
IGNvbnN0IG1zZnRfZGltbV9vcHMgPSAmKHN0cnVjdCBuZGN0bF9kaW1tX29wcykgewo+IMKgwqDC
oMKgwqDCoMKgwqAuc21hcnRfZ2V0X2ZsYWdzID0gbXNmdF9jbWRfc21hcnRfZ2V0X2ZsYWdzLAo+
IMKgwqDCoMKgwqDCoMKgwqAuc21hcnRfZ2V0X2hlYWx0aCA9IG1zZnRfY21kX3NtYXJ0X2dldF9o
ZWFsdGgsCj4gwqDCoMKgwqDCoMKgwqDCoC5zbWFydF9nZXRfbWVkaWFfdGVtcGVyYXR1cmUgPSBt
c2Z0X2NtZF9zbWFydF9nZXRfbWVkaWFfdGVtcGVyYXR1cmUsCj4gK8KgwqDCoMKgwqDCoMKgLnNt
YXJ0X2dldF9hbGFybV9mbGFncyA9IG1zZnRfY21kX3NtYXJ0X2dldF9hbGFybV9mbGFncywKPiDC
oMKgwqDCoMKgwqDCoMKgLnNtYXJ0X2dldF9saWZlX3VzZWQgPSBtc2Z0X2NtZF9zbWFydF9nZXRf
bGlmZV91c2VkLAo+IMKgwqDCoMKgwqDCoMKgwqAueGxhdF9maXJtd2FyZV9zdGF0dXMgPSBtc2Z0
X2NtZF94bGF0X2Zpcm13YXJlX3N0YXR1cywKPiDCoH07Cgo=
