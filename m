Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D5213AEF
	for <nvdimm@lists.linux.dev>; Wed,  5 Jul 2023 20:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688590402; x=1720126402;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=qrSx2wawlP2Rg3WjDhYWRyC9+NCG7S2yFAeDSn+WuOM=;
  b=MGMucDZHgReXWPAoqKIw3z7WBu5tEaWwgBXAysnCFOwgLdIfcFg6tolM
   Jr5hBTlaNMdEGHqbgIfkMFjXW2I950Z8BsbdJrZA66Ufak8X/I4LmV2dz
   nfWFxnQNCUX5LFtJz+EDwkKSB8QG0vTVN6NCYfO+UjTt9r5Dq1Klof+7g
   sqJv2ci9o/lULquWoBtC/pN+p1a1GHEQcduJjF5aonLn6mM/ogP7Zswv8
   Uai0rmldhoe1j/luTgFFFbMFdU6ho2K9bJv9M6AiRW0svMtIgWE/FKMKm
   zLi6zmxaPrbZKXXJ+1d6UOjMSmVMd2nuphz1cKXb/+TB/a5XBjwn/FQCs
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10762"; a="362309082"
X-IronPort-AV: E=Sophos;i="6.01,184,1684825200"; 
   d="scan'208";a="362309082"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2023 13:53:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10762"; a="696590331"
X-IronPort-AV: E=Sophos;i="6.01,184,1684825200"; 
   d="scan'208";a="696590331"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 05 Jul 2023 13:53:21 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 5 Jul 2023 13:53:20 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 5 Jul 2023 13:53:20 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 5 Jul 2023 13:53:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z0uc8prTPfeqIFLLValp1GggMaS3ixF7/UHkWzhhux3zIu9wHPDeqLhnJreoTS0k5QQGj7IQcLYIpcP6FiI3XKoOs6rnoa7I2qnJfW1YtDwAPjijQRnW3sBQhBMv4mghjEt/zFPTyZmwFz0T8wbQtK58mzYFsP9DJ9wwQt9oouKtF4YCcPpIzRz5o0EvjB4JgVFX2YwAHmdEH2qlKmpqg6zXUbii/02crxCaRSjJ8kZboegOtkF7Q1LAr3A2THIqm9x8B3wn+szve/kQPHOyf2CXN1YiOlTS+A/uHStKBh6Rdl4SWCpk5e3DnRaYtbVge4R8CBZbeLcukRWnePMYew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qrSx2wawlP2Rg3WjDhYWRyC9+NCG7S2yFAeDSn+WuOM=;
 b=KguOYsI+z0X2DQVLM/nFgFlyYl7V2Ytvo8m7z/+rTnbCBT1XL3rZd2uFKt/ogj5ywH3KoPqexYGSspEJsR5Okc8L+8A68gra2DmzWrLjKXC0Ezxa5NBv6SNCHqRSDmfvgvKwTSlFb42/AZQRlAa76NTLawXoeWIpiJGb7ugvDZnmAY1XOhPatb9eK8eZoCz0dfV42YHxuw7nSWG2qx0rJK5YeKUEZpBtREoMHyfnwfLnp+hj/pEnDKngt9/YmQeNWTcZQ4JOCKu2PCj6tivYM0ZN5PxeYcaPdaHah7LmuH3SUL71n5hrhRqC5VXv9LIxbz1TwRsIydFLyEL9l7pEZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by IA1PR11MB7821.namprd11.prod.outlook.com (2603:10b6:208:3f0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6544.24; Wed, 5 Jul
 2023 20:53:16 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::8e37:caf2:1d81:631d]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::8e37:caf2:1d81:631d%3]) with mapi id 15.20.6544.024; Wed, 5 Jul 2023
 20:53:16 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "lizhijian@fujitsu.com" <lizhijian@fujitsu.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
CC: "Jiang, Dave" <dave.jiang@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "Schofield, Alison" <alison.schofield@intel.com>
Subject: Re: [ndctl PATCH v3 1/6] cxl/monitor: Enable default_log and refactor
 sanity check
Thread-Topic: [ndctl PATCH v3 1/6] cxl/monitor: Enable default_log and
 refactor sanity check
Thread-Index: AQHZk2ZoIreSFbNtSUiNvW6bENx3vK+r3qEA
Date: Wed, 5 Jul 2023 20:53:16 +0000
Message-ID: <3aed308abaa24becebacb559501c9b1ade9c0597.camel@intel.com>
References: <20230531021936.7366-1-lizhijian@fujitsu.com>
	 <20230531021936.7366-2-lizhijian@fujitsu.com>
In-Reply-To: <20230531021936.7366-2-lizhijian@fujitsu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|IA1PR11MB7821:EE_
x-ms-office365-filtering-correlation-id: 20d60741-ca99-497b-60f5-08db7d99db12
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +EhoG6HqzEcjVGQPkYcMBgOsM7y+5RZXMnNgvhULh+DMyLXq2T4VLdr9bcrmCPTHA2YNlAl5Ez2STjfm5vyzlO5Q5F7Nf8wYGtiZwrbntaI/G+Yfq1d+27q7wRMhzeYW06VQBjtjr03cwVnRZm4wj6Bnyo3PnE2lzspDYvSIBMyJfDQ3lw0QVqQ+BpzAS8PEoCD1gFomlOMK1+KdytcGq+yfsDrjcPdwUDkxzAh8XW+pnnGa1FCdFVrAcwqjuitEvNMel5Ephz1E0HxpD1TcUwp3Hw8slWLhJZYCzKt3oi1NDsUv5MM60Dz9k2Ge8Oqb5m1D3UU6LV2+zoVVEyEqxtCLv/E+SITnKKaxLOMoM6zS9dKqOvf88W1a7O53NBP2UOMqjv293RaQficangm2BUDAJd1mQuxxhKUOctE8vbzf9iew477AYXVtpTGZ56WjykxcXGXVXfyHVXIpbOhfR7Ggpnrj7Myun72k8x9fXoOrC3NBYuQaUQI1+FpMoSFJjsk0TIzL5WR9C3EyCVtSUY+Emlv0mLMP9EpYz/f/YkIWS4t4y0PL6d6rdbdTk6b32b7KPWYmTGVjalcac59SOxoHWSu4+p0/PDPePuy/u4GPSTeL8RkO/f9PHECcgt3w
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(366004)(136003)(376002)(396003)(451199021)(4326008)(316002)(64756008)(86362001)(26005)(66556008)(186003)(66946007)(76116006)(66446008)(6512007)(6506007)(66476007)(107886003)(82960400001)(83380400001)(2616005)(122000001)(2906002)(6486002)(38100700002)(71200400001)(5660300002)(478600001)(8676002)(54906003)(110136005)(41300700001)(38070700005)(8936002)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R1ZrZ1hGWkwvRFNqYUJVaXdLL2ZObWRtS05XdHdnTkNLRUNoR1BseExGT2xy?=
 =?utf-8?B?K0hJY1VDTytURGl5aEs3NzFyYzk3YnhCQmlCNm9Vam4rTlBiRVE2WEpmbVRB?=
 =?utf-8?B?UFFpMTJRNmIxa2dyREtRa3EyNXRTZWwxcGtRLzI4Nzd2aTRaQ0w5QlQyS3lV?=
 =?utf-8?B?cHgrM3BKUXErZitEblp4K0VnOWtTTm1BQ2tYZkp2My9BQ05VTlJVcmpIWjNC?=
 =?utf-8?B?OWI3OFdKR0lyakh1Uzg2REoyeThBcWhGWW1mdHZIcWl3MGxXVTROTDVWMXRY?=
 =?utf-8?B?c21yQ2lTLzBheUNhWWRZcGJOT1BJR3Y1ZU1wRWxlQnhTZ1gxZ3pzajVGdy8x?=
 =?utf-8?B?dytRK0RBTVVIaWtJVnJxTTk0Wlk1cXdxWFkwVFI4SC9ZY08vd3FNVVZDeWJH?=
 =?utf-8?B?U1VFdUdxRkhiTDNMalB3d0NTNmI4V0RaKy8yZnk0Y0Q0eTY2Zm1Udkh2SDFj?=
 =?utf-8?B?Nk5SMjRQaGNkYXpPV01EcFZSY1JBY0tpWEVsMFhhQkpmbjFqaEQzWEdjUGtx?=
 =?utf-8?B?dk54WjV4WXJQVkwzaXM4YjE4S2o2L0xFVzhkTlhCdDkvc0NXSDBpUE5MSGJY?=
 =?utf-8?B?c2RNZkNTTkhFUUNubUR0eDlOUkYyQ0pnd2N0b1NhcXo1ZVZvK2g5bEV0UWIr?=
 =?utf-8?B?Uk5QeDJObDlVSDJWQnF4ZjVZc2drekxva2NrTUo2aFpHWUR5SFlPeitjUVFZ?=
 =?utf-8?B?aldRV3BHU29WdDBLNWNlMjhZT3dwZTVtb0NBaWdsektHRkR2cnZYUGp3SEIz?=
 =?utf-8?B?S1BZNGxsUGk1U0lGZzBnRnNNeEdlY1ZoZTArdWhVVDRHZlVrS1JPd3pNVkww?=
 =?utf-8?B?UXlxc2dPTzdySm9rVFZLV2svdGdnQmltYWhIazZnbFg3YWdZazNPYjNGM1hn?=
 =?utf-8?B?STdvbVpWR2NtaFVHL2w5TXBLQzdPU0JZVXhsRWdvTERsdmRhTXdIdHd4WHI1?=
 =?utf-8?B?OUJGa2VyYThXUkh2azFCcUJpN2ZOaW1kTW5kbWpzNDltNnZjUFBoblFhaFQw?=
 =?utf-8?B?RVZ2ZU41NlgwWWJXZTZubzk5bVMxUnVzY2IwTDFERVpJYTVGaW93SzdPdHVp?=
 =?utf-8?B?RVozVk9nS3FXVWNDVzBaZXJBcUw3MWtLQ05RYTVuellSVCtXem90WEwzUTFD?=
 =?utf-8?B?ZENFQWY3OC9mbVFHS2Z2UCs2SzhJNHhuZWZDQTRHN05YOVlyNS9SNVBoWWQ5?=
 =?utf-8?B?Vjlyb1ZoQkhGRnlJbXBYeCtUVW1qdFVydlhrNHFCbFQ2WUV1aVZ5bVB6OUpr?=
 =?utf-8?B?ZFhGQ01FUG9CT1o0MDZWc3dFaDY0TzVLemQ0SGtjaHd2N1ZvcGFYS1duY09u?=
 =?utf-8?B?dXNjN2hudzM4bGh2SEIrV2k4dmhQbWlkNmdjbnNFTUNHb3B0b2hlYW5taVJp?=
 =?utf-8?B?VEtiSm9PZUEwYlN6N2tlSUthTlBKa1NnQXJjemxKZlk5c0twUjdGU0xWdTVj?=
 =?utf-8?B?Q1ZCUXZYZzBMN0hsTVhtTzN0RXRhU1l4eWFCeUI5QVFqUjRIdkpaQU51bU5s?=
 =?utf-8?B?LzZjMU8xRjV6eGZjdnlVQytISkZrTWZTeW1nK3hTZFU5Q1h0OS8yc1FabkNv?=
 =?utf-8?B?UGtvNjBJemMwNWE5bmtoOXRnS01XaFlwcFNWaWEzRlZyaGVwemg3cnNzalJ5?=
 =?utf-8?B?RlNRaHh3dG93cDB1RFBEdzVqMi9QZWpTbW9mQ3hJR0JJbTh3d3hSbHRZZnJD?=
 =?utf-8?B?bFVuTDRoRnhSdzdqWDBCaTk3aEJkRnBnNWNoclRiN1cyYXg5QlUxZFFHWGtz?=
 =?utf-8?B?ckpIcENVZ2V3Y2FPWGROU2RKQVNRZnBjcktKWkNVbjNncjJoRkJ2aTJ1THFo?=
 =?utf-8?B?OXRqYlB3ODUvdkJSc0tWZ0EvUHF2UWt4cmViK0I0Y0FIbXNncnFCMmFLUGkv?=
 =?utf-8?B?UTJVSVVGdXhhS1NHNXlpeUdCVmhPaGVGN3pYdkIweVdqSStGOE9UNlpCVGtE?=
 =?utf-8?B?V1hQUExMVlM1WFR5R0wwMHZzTGJXci9hMFAzQVN3cFJ3U2Z0N2hYbU8zVG5M?=
 =?utf-8?B?YjIxd1k4VVMzaWVjcWpQanBVSSsyRUJiTU9LWFo1QURyMXQwYUFhalNFVThi?=
 =?utf-8?B?QmdNRFdtV3Z0N3IxVGdhWUZJNkovUXZKdGVZSnFldGpITEROL2wwVjBva0RL?=
 =?utf-8?B?dE51cDNKQUg5NDhIbS9QRDZRK3VlWnpIUDdJTWw4QW9xak9XajRJeWpSZVdS?=
 =?utf-8?B?NHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <76E8BB2501A8B94C8F7F779AAB8576B5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20d60741-ca99-497b-60f5-08db7d99db12
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2023 20:53:16.1615
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aLfhCVgjVYN95NdMfh5lD+5HdsRTIDOpod/LTTGkLbrPbyRbyjZ7kMlzOtCW2rvLTX92cL25dKkIAvsEKdyFTewux+rsxurp8hhnvd78fTU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7821
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDIzLTA1LTMxIGF0IDEwOjE5ICswODAwLCBMaSBaaGlqaWFuIHdyb3RlOgo+IFRo
ZSBkZWZhdWx0X2xvZygvdmFyL2xvZy9jeGwtbW9uaXRvci5sb2cpIHNob3VsZCBiZSB1c2VkIHdo
ZW4gbm8gJy1sJwo+IGFyZ3VtZW50IGlzIHNwZWNpZmllZCBpbiBkYWVtb24gbW9kZSwgYnV0IGl0
IHdhcyBub3Qgd29ya2luZyBhdCBhbGwuCj4gCj4gSGVyZSB3ZSBhc3NpZ25lZCBpdCBhIGRlZmF1
bHQgbG9nIHBlciBpdHMgYXJndW1lbnRzLCBhbmQgc2ltcGxpZnkgdGhlCj4gc2FuaXR5IGNoZWNr
IHNvIHRoYXQgaXQgY2FuIGJlIGNvbnNpc3RlbnQgd2l0aCB0aGUgZG9jdW1lbnQuCgpBdm9pZCB1
c2luZyAnd2UnIGFzIGl0IGNhbiBiZSBhbWJpZ3VvdXMgd2hhdCAvIHdobyBpdCBpdCByZWZlcnJp
bmcgdG8uCkFsc28gZ2VuZXJhbGx5LCB1c2UgYW4gaW1wZXJhdGl2ZSB0b25lIGZvciBjaGFuZ2Vs
b2dzIC0gZS5nLiB0aGUgYWJvdmUKbGluZSBjb3VsZCBqdXN0IGJlICJTaW1wbGlmeSB0aGUgc2Fu
aXR5IGNoZWNrcyBzbyB0aGF0IHRoZSBkZWZhdWx0IGxvZwpmaWxlIGlzIGFzc2lnbmVkIGNvcnJl
Y3RseSwgYW5kIHRoZSBiZWhhdmlvciBpcyBjb25zaXN0ZW50IHdpdGggdGhlCmRvY3VtZW50YXRp
b24uIgoKPiAKPiBQbGVhc2Ugbm90ZSB0aGF0IGkgYWxzbyByZW1vdmVkIGZvbGxvd2luZyBhZGRp
dGlvbiBzdHVmZiwgc2luY2Ugd2UgaGF2ZQo+IGFkZGVkIHRoaXMgcHJlZml4IGlmIG5lZWRlZCBk
dXJpbmcgcGFyc2luZyB0aGUgRklMRU5BTUUgaW4KPiBwYXJzZV9vcHRpb25zX3ByZWZpeCgpLgoK
U2hvdWxkbid0IGJlIHVzaW5nICJJIGRpZCB4eXouLiIgaW4gYSBjb21taXQgbWVzc2FnZSBlaXRo
ZXIgLSBjaGFuZ2UgdG8KaW1wZXJhdGl2ZSwgZS5nLjogIlJlbW92ZSB0aGUgZmlsZW5hbWUgcHJl
Zml4IHR3ZWFraW5nIGluCmZ1bmN0aW9uX2ZvbygpIHNpbmNlIGl0IGlzIHVubmVjZXNzYXJ5LiIK
Cj4gaWYgKHN0cm5jbXAobW9uaXRvci5sb2csICIuLyIsIDIpICE9IDApCj4gwqDCoMKgIGZpeF9m
aWxlbmFtZShwcmVmaXgsIChjb25zdCBjaGFyICoqKSZtb25pdG9yLmxvZyk7CgpVc3VhbGx5IG5v
IG5lZWQgdG8gaW5jbHVkZSBjb2RlIHNuaXBwZXRzIGluIGNoYW5nZWxvZ3MgLSB0aGUgZGV0YWls
cwphcmUgZWFzaWx5IGF2YWlsYWJsZSBpbiB0aGUgYWN0dWFsIGNvbW1pdCBpdHNlbGYuIEluc3Rl
YWQgZGVzY3JpYmUgd2hhdAp5b3UgZGlkIGFuZCB3aHkgaWYgaXQgaXNuJ3QgYW4gb2J2aW91cyBj
aGFuZ2UuCgo+IAo+IFNpZ25lZC1vZmYtYnk6IExpIFpoaWppYW4gPGxpemhpamlhbkBmdWppdHN1
LmNvbT4KPiAtLS0KPiBWMjogZXhjaGFuZ2Ugb3JkZXIgb2YgcHJldmlvdXMgcGF0Y2gxIGFuZCBw
YXRjaDIgIyBBbGlzb24KPiDCoMKgwqAgYSBmZXcgY29tbWl0IGxvZyB1cGRhdGVkCj4gU2lnbmVk
LW9mZi1ieTogTGkgWmhpamlhbiA8bGl6aGlqaWFuQGZ1aml0c3UuY29tPgo+IC0tLQo+IMKgY3hs
L21vbml0b3IuYyB8IDM4ICsrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tCj4g
wqAxIGZpbGUgY2hhbmdlZCwgMjAgaW5zZXJ0aW9ucygrKSwgMTggZGVsZXRpb25zKC0pCj4gCj4g
ZGlmZiAtLWdpdCBhL2N4bC9tb25pdG9yLmMgYi9jeGwvbW9uaXRvci5jCj4gaW5kZXggZTM0Njli
OWE0NzkyLi5jNmRmMmJhZDNjNTMgMTAwNjQ0Cj4gLS0tIGEvY3hsL21vbml0b3IuYwo+ICsrKyBi
L2N4bC9tb25pdG9yLmMKPiBAQCAtMTY0LDYgKzE2NCw3IEBAIGludCBjbWRfbW9uaXRvcihpbnQg
YXJnYywgY29uc3QgY2hhciAqKmFyZ3YsIHN0cnVjdCBjeGxfY3R4ICpjdHgpCj4gwqDCoMKgwqDC
oMKgwqDCoH07Cj4gwqDCoMKgwqDCoMKgwqDCoGNvbnN0IGNoYXIgKnByZWZpeCA9Ii4vIjsKPiDC
oMKgwqDCoMKgwqDCoMKgaW50IHJjID0gMCwgaTsKPiArwqDCoMKgwqDCoMKgwqBjb25zdCBjaGFy
ICpsb2c7Cj4gwqAKPiDCoMKgwqDCoMKgwqDCoMKgYXJnYyA9IHBhcnNlX29wdGlvbnNfcHJlZml4
KGFyZ2MsIGFyZ3YsIHByZWZpeCwgb3B0aW9ucywgdSwgMCk7Cj4gwqDCoMKgwqDCoMKgwqDCoGZv
ciAoaSA9IDA7IGkgPCBhcmdjOyBpKyspCj4gQEAgLTE3MSwzMiArMTcyLDMzIEBAIGludCBjbWRf
bW9uaXRvcihpbnQgYXJnYywgY29uc3QgY2hhciAqKmFyZ3YsIHN0cnVjdCBjeGxfY3R4ICpjdHgp
Cj4gwqDCoMKgwqDCoMKgwqDCoGlmIChhcmdjKQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgdXNhZ2Vfd2l0aF9vcHRpb25zKHUsIG9wdGlvbnMpOwo+IMKgCj4gK8KgwqDCoMKgwqDC
oMKgLy8gc2FuaXR5IGNoZWNrCgpVc2UgdGhlIC8qIGNvbW1lbnQgKi8gc3R5bGUgLSBuZGN0bCBm
b2xsb3dzIHRoZSBrZXJuZWwncyBjb2Rpbmcgc3R5bGUKd2hlbmV2ZXIgYXBwbGljYWJsZS4KCj4g
K8KgwqDCoMKgwqDCoMKgaWYgKG1vbml0b3IuZGFlbW9uICYmIG1vbml0b3IubG9nICYmICFzdHJu
Y21wKG1vbml0b3IubG9nLCAiLi8iLCAyKSkgewo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqBlcnJvcigic3RhbmRhcmQgb3IgcmVsYXRpdmUgcGF0aCBmb3IgPGZpbGU+IHdpbGwgbm90
IHdvcmsgZm9yIGRhZW1vbiBtb2RlXG4iKTsKCkp1c3QgdG8gcmVkdWNlIGNvbmZ1c2lvbiBhYm91
dCB3aGF0ICdzdGFuZGFyZCcgaXMgYW5kIHRvIGVtcGhlc2l6ZSB0aGF0Cml0J3MgYSBrZXl3b3Jk
LCBtYXliZSByZXdvcmQgdGhpczoKCiJyZWxhdGl2ZSBwYXRoIG9yICdzdGFuZGFyZCcgYXJlIG5v
dCBjb21wYXRpYmxlIHdpdGggZGFlbW9uIG1vZGUiCgo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqByZXR1cm4gLUVJTlZBTDsKPiArwqDCoMKgwqDCoMKgwqB9Cj4gKwo+IMKgwqDCoMKg
wqDCoMKgwqBsb2dfaW5pdCgmbW9uaXRvci5jdHgsICJjeGwvbW9uaXRvciIsICJDWExfTU9OSVRP
Ul9MT0ciKTsKPiAtwqDCoMKgwqDCoMKgwqBtb25pdG9yLmN0eC5sb2dfZm4gPSBsb2dfc3RhbmRh
cmQ7Cj4gK8KgwqDCoMKgwqDCoMKgaWYgKG1vbml0b3IubG9nKQo+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqBsb2cgPSBtb25pdG9yLmxvZzsKPiArwqDCoMKgwqDCoMKgwqBlbHNlCj4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGxvZyA9IG1vbml0b3IuZGFlbW9uID8gZGVm
YXVsdF9sb2cgOiAiLi9zdGFuZGFyZCI7CgpJIHRoaW5rIHRoZSBvcmlnaW5hbCAnLi9zdGFuZGFy
ZCcgd2FzIHVzZWQgdGhhdCB3YXkgYmVjYXVzZQpmaXhfZmlsZW5hbWUoKSBhZGRlZCB0aGUgJy4v
JyBwcmVmaXguIE5vdGUgdGhhdCB0aGUga2V5d29yZCB1c2VkIGluIHRoZQpuYW0gcGFnZSBpcyBq
dXN0ICdzdGFuZGFyZCcgLSBzbyBzaG91bGRuJ3QgdGhpcyBqdXN0IGJlIHVzaW5nCidzdGFuZGFy
ZCcgcmF0aGVyIHRoYW4gJy4vc3RhbmRhcmQnLiBTaW1pbGFybHksIGxhdGVyIHdoZW4geW91IHN0
cmNtcCwKdGhhdCBzaG91bGQgYWxzbyBiZWNvbWUganVzdCAnc3RhbmRhcmQnIG9mIGNvdXJzZS4g
Cgo+IMKgCj4gwqDCoMKgwqDCoMKgwqDCoGlmIChtb25pdG9yLnZlcmJvc2UpCj4gwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBtb25pdG9yLmN0eC5sb2dfcHJpb3JpdHkgPSBMT0dfREVC
VUc7Cj4gwqDCoMKgwqDCoMKgwqDCoGVsc2UKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoG1vbml0b3IuY3R4LmxvZ19wcmlvcml0eSA9IExPR19JTkZPOwo+IMKgCj4gLcKgwqDCoMKg
wqDCoMKgaWYgKG1vbml0b3IubG9nKSB7Cj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oGlmIChzdHJuY21wKG1vbml0b3IubG9nLCAiLi8iLCAyKSAhPSAwKQo+IC3CoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZml4X2ZpbGVuYW1lKHByZWZpeCwgKGNv
bnN0IGNoYXIgKiopJm1vbml0b3IubG9nKTsKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgaWYgKHN0cm5jbXAobW9uaXRvci5sb2csICIuL3N0YW5kYXJkIiwgMTApID09IDAgJiYgIW1v
bml0b3IuZGFlbW9uKSB7Cj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqBtb25pdG9yLmN0eC5sb2dfZm4gPSBsb2dfc3RhbmRhcmQ7Cj4gLcKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoH0gZWxzZSB7Cj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqBjb25zdCBjaGFyICpsb2cgPSBtb25pdG9yLmxvZzsKPiAtCj4g
LcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAoIW1vbml0
b3IubG9nKQo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoGxvZyA9IGRlZmF1bHRfbG9nOwo+IC3CoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgbW9uaXRvci5sb2dfZmlsZSA9IGZvcGVuKGxvZywg
ImErIik7Cj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBp
ZiAoIW1vbml0b3IubG9nX2ZpbGUpIHsKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByYyA9IC1lcnJubzsKPiAtwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBlcnJv
cigib3BlbiAlcyBmYWlsZWQ6ICVkXG4iLCBtb25pdG9yLmxvZywgcmMpOwo+IC3CoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGdvdG8g
b3V0Owo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgfQo+
IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgbW9uaXRvci5j
dHgubG9nX2ZuID0gbG9nX2ZpbGU7Cj4gK8KgwqDCoMKgwqDCoMKgaWYgKHN0cm5jbXAobG9nLCAi
Li9zdGFuZGFyZCIsIDEwKSA9PSAwKQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBt
b25pdG9yLmN0eC5sb2dfZm4gPSBsb2dfc3RhbmRhcmQ7Cj4gK8KgwqDCoMKgwqDCoMKgZWxzZSB7
Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoG1vbml0b3IubG9nX2ZpbGUgPSBmb3Bl
bihsb2csICJhKyIpOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAoIW1vbml0
b3IubG9nX2ZpbGUpIHsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoHJjID0gLWVycm5vOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgZXJyb3IoIm9wZW4gJXMgZmFpbGVkOiAlZFxuIiwgbG9nLCByYyk7Cj4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBnb3RvIG91dDsKPiDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoH0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgbW9uaXRvci5jdHgubG9nX2ZuID0gbG9nX2ZpbGU7Cj4gwqDCoMKgwqDCoMKgwqDC
oH0KPiDCoAo+IMKgwqDCoMKgwqDCoMKgwqBpZiAobW9uaXRvci5kYWVtb24pIHsKCg==
