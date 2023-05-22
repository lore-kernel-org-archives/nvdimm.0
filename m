Received: from esa15.fujitsucc.c3s2.iphmx.com (esa15.fujitsucc.c3s2.iphmx.com [68.232.156.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4FCEB8
	for <nvdimm@lists.linux.dev>; Mon, 22 May 2023 06:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1684735748; x=1716271748;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=RaKmrv00oLu0HRVwyd4wO0C3LWwO3wLdgKdIFly1dYA=;
  b=DzDxlBNGUs+lkT//iwrLN94/RZskQigUj7oP5mnxaWDBoBFFER7IczxB
   Mg0Ai+zreHAsqZetOlUpYQERx6oShpIodpiZMiW0jLiSyUJVwCmz7bepv
   0kR88usR8BrNexbxsRInHh8cMULYRMfvpYo/+PHt+ljhXiQoOOmiyytDk
   RrO78nAym5mtzW82v4WGFoL5NkutYGqXfiurPschqCSQizmgUSe++CFFh
   FwUZc0E2dEN/rvyzpPVvzExMin6kK3ClMhcSdbIT7P6Hb8GaDItMR/Rzs
   OL5g2GAq42IZfzEBtAPj6FMMDFj3RAQmHITAZEjq0enDKtGhYdwA+cMWR
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="85015582"
X-IronPort-AV: E=Sophos;i="5.98,286,1673881200"; 
   d="scan'208";a="85015582"
Received: from mail-tycjpn01lp2171.outbound.protection.outlook.com (HELO JPN01-TYC-obe.outbound.protection.outlook.com) ([104.47.23.171])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 15:08:59 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gd/sua+7+p3Om2X3nwAM4YKhBjrVEaxRLs9Mq8hdqG6oE3oYU/io531seaDELesiA7SoXQyEhnK0SYeYrIW14XlRODIcDYMjmsBCLeg3kPvvQ7pSXGlKkOxzpfX/Gi8U1KyOk488t9EtfGRP4/AcScHd3XREpftg5AxuRyXx85F46dO6BrTEgPiN2UKGlrYNA3vi3/QiJ6oHu2mOekmgxt4bIj9rZmAk62csEkv8YEsg0IlN0I3NjB7scTUFFNniVDGNJG6gBKiH2hlnhKHQiDNKbKGuBgg8MA+PNiMWEKuuRXBiBVv+NhzpR5UNFth0RbrkjwrDES8kCxYaLO+2Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RaKmrv00oLu0HRVwyd4wO0C3LWwO3wLdgKdIFly1dYA=;
 b=Wj2DeGFKOxZ1MZxXpEtNcjrXTR9/ttTzVgXx+jCKPI/oKQpoF+8JSXqJ2+iMDsY2qoU1kdrv62oU+7gIdblzJM3ZTAhhA7EoGyFOkoNaw3mwYQv9PcZTHzbj9CkuukmW2BJas7sBcItZfm6FO4yqfvOFMffE+HC19nJE6VczVR7yHZju5KQRER3EIB3QIDeap2kq1z0nHsgGcSKiWoTIzaNjO8AlP7YphyDuXFhhGLlt+P1bnB9J+WymsfSRoXrffwKDlz8wlu/BN1+SIuXazAXkQbOFCNViD1m82FsODD8v3yP1vmqIJRet6byfCTvo0dmD1H9YKs3unc2BxSuGGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from OS7PR01MB11664.jpnprd01.prod.outlook.com (2603:1096:604:247::6)
 by TYVPR01MB11212.jpnprd01.prod.outlook.com (2603:1096:400:36b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Mon, 22 May
 2023 06:08:55 +0000
Received: from OS7PR01MB11664.jpnprd01.prod.outlook.com
 ([fe80::687d:4884:ec0b:8835]) by OS7PR01MB11664.jpnprd01.prod.outlook.com
 ([fe80::687d:4884:ec0b:8835%7]) with mapi id 15.20.6411.028; Mon, 22 May 2023
 06:08:55 +0000
From: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>
To: Dave Jiang <dave.jiang@intel.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
CC: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH 2/6] cxl/monitor: compare the whole filename with
 reserved words
Thread-Topic: [ndctl PATCH 2/6] cxl/monitor: compare the whole filename with
 reserved words
Thread-Index: AQHZhaYdERPBKVInv0ysTsZMeLy4xK9h5CKAgAP4VwA=
Date: Mon, 22 May 2023 06:08:55 +0000
Message-ID: <875487b1-6495-851e-ba63-28c722d1470f@fujitsu.com>
References: <20230513142038.753351-1-lizhijian@fujitsu.com>
 <20230513142038.753351-3-lizhijian@fujitsu.com>
 <e4ebdde3-e51a-be42-135f-f0b3d78259b0@intel.com>
In-Reply-To: <e4ebdde3-e51a-be42-135f-f0b3d78259b0@intel.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS7PR01MB11664:EE_|TYVPR01MB11212:EE_
x-ms-office365-filtering-correlation-id: d357ee5a-5c7c-4f90-b877-08db5a8b0678
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 9Db6MaugUIBsl1H18ISo/QdBo+YgRVPatVyZ9YhpfdPkKJYdzFbv0ZENsZuz/WCvKcgceMTDjNcFXcb5YexbI/uaWPdevnfBkIB0SILhl2v62oLbzbEDCzWWIrvXQCXydR0fUcA8vnIrEgPyAfNIqveKxG75Ve+20NquSnWFsTUQNy60TwZuZPu5GCBSWRgz6oQ2BuoVksp36vWMCoJ1wuF6rH2kbINb3OGl0SdVdNfn030OzYIpesLaLuwmz0ev5bt5XpP5Tqur7l6TYkEouVoRgrZNytik+kfGUFKabrGewf87uy2qtL4Afgysvl/EACNB35nIg6a2qYTXBbKcw2fuK6iyKHSfMtgyO8T/bc5OoSiKwXWj3guwuiOOsEMTlVEPURmtwjZR4uhECldiSnJ6hEC3RxFvDJDgBgQc56u21i6kzTR/vsN9QIakLVPz4S/exgFMknXArIppIk1W7p9mFenzWCue5OBlefMMfRJeRdW61GP3RcUgvGGf8MJQ1wKfpweAVbHYTCP46yAvFafLnZrrXd+u64ed6WysFD+myB7rR+qRkSm26TGKn2Ig226ZxYYTBuHKM6VAsBJaXQZqJpoDYXLejqBS5+a8XkeZl3S4Va8P7U9Bb8aWuwuT5zY/aAAB9vyqiO2bh0GqqOzBCX5MXqhP4/RMrYWjTed82je21YjtPQkc/rS7wku3gM3Y3xY0AS2zVLevXD7xpw==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS7PR01MB11664.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(396003)(346002)(366004)(39860400002)(451199021)(1590799018)(8936002)(8676002)(5660300002)(83380400001)(53546011)(186003)(6512007)(6506007)(26005)(2616005)(31696002)(86362001)(122000001)(82960400001)(38100700002)(38070700005)(41300700001)(71200400001)(6486002)(478600001)(64756008)(66446008)(66476007)(66556008)(66946007)(76116006)(91956017)(4326008)(85182001)(316002)(36756003)(110136005)(2906002)(31686004)(1580799015)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?UEhIOGh3cHE5bE5kZFR3dGJrMkNydnNsY1o1WVpuZ3NPL3ZBQWU3THFOUlNE?=
 =?utf-8?B?MGJQZXJab3NXaVRUVnZmd21VNmNMNG93czNHTlp2ZlJTN2IzbytvY0h4QzFP?=
 =?utf-8?B?a2JjVVhEblE2clBkTG8rU0R3QjU5enR6TE4rL3RYbmNHeEdzOCttL2lwQnRS?=
 =?utf-8?B?Q3FuRE1Cc0tUNnM0Z3llempybElkZlI2V1RVbDRWME14WGJHR3hvc0p1UWhY?=
 =?utf-8?B?QkRLUW16MmhVcmdXQ0kveEd0d0NLcDh4bU5QcW41dkNhSjQ1bWg4Z2lqeVRn?=
 =?utf-8?B?aytNVXNRWFJQKzYzb2JzNmhkZ1laUUJQRWZhQVFWTnJheWJiS0hrbUtRWnF0?=
 =?utf-8?B?Y2U0OWJDZU4rZTdOTmNoT2VqKzdDc1RSN0VpRXpQOTNIS1FNTlNWUS9YdkxQ?=
 =?utf-8?B?aDhPdXg3NmYzODBuTG1sRXBGVFBncVU3NFprTVRaSTB5WHM4VHBpM2Urdkgz?=
 =?utf-8?B?eGR0MWlRUHJ3MWVNcXljUGdqbGF0V0ovT3U4RzBSNDFhRkQ2bEYrSUpva2px?=
 =?utf-8?B?OENzRkJhcnltNk9hYnQzbTJyWXlCZFVJaXZabml2a3lPalIxczNMSHFUQm1q?=
 =?utf-8?B?MnJzQUt1a3dvdkQxcHdNMUh6amZVbXZRYmM5ekJzR2IvekJUeXNHeFZ5cVJh?=
 =?utf-8?B?VnR6ZUZlTXpsNHQ0cGpFdmlOSms4Q1lPSk1UVitScFZEaDl0ZWo2TzVhTjE0?=
 =?utf-8?B?ZkNqTHJVN1dIS294ZW5hNkljMHV6N0ZpM2g2eXY2ZFV0WTRDMjBySXU0Qjdj?=
 =?utf-8?B?Q0tLRWEreUMwUENUSW9VekFCa0xXSjNpYXZEdkRSMEZWV3hhQkZVOUttVkF5?=
 =?utf-8?B?QURHc2hKQWlGUlYyL0xSbUJuRVVGVFA3ZzVPdzJpUFF1RHpHMHRMaW5hcXBj?=
 =?utf-8?B?bWwrbGhpanZvVTVVZlY3SnYyWWlsQmgySFBOdlJpTmZVVmJNcW9sdlJjakI2?=
 =?utf-8?B?Q0JVOWhvRTZ3c3N1ZmZVcnFZZUk4bnVMK2dFTHpVV0lUeGFPNGhXK09Za2I4?=
 =?utf-8?B?aGViREJNaVlYRU51STZFOVRVaDA4bTkzTnJZVk1CekQ3VW1WWjlyQ0FaSVRt?=
 =?utf-8?B?L2Fwcm9nQ1VHdzNTY0w3bDJvNTd0YnliRlhaL1lkdVIxYUtjeUpFeXVhN2dE?=
 =?utf-8?B?by9CU3lPcjhWSkF0NFkwYlZKNUROTG41NTk4bW5kUHMzbE14YTgzVTMzb2xC?=
 =?utf-8?B?T2JLOHFwWk5GTFJ0V0FWV3l0T25KZjNvNEM5ZHM0NFJqN2dSSWlXL3hxY2dz?=
 =?utf-8?B?ek5ZMjZkcGFxa1BEQ0xyUHB1N1NYY1p2TmlUQW54NkRpMnVGZXcwbkhnYVQy?=
 =?utf-8?B?VEN4SXliV1FNQUNtSU41UXA5bGwrOW5seC8vblNhMitzUm5VenJDdjZ0Znpz?=
 =?utf-8?B?Yld2VDdWMHdvWUlqTi9xY3YvREJiWld6aFEyMFZqaXQ1SVpzUVRjclJNc3NT?=
 =?utf-8?B?cURMYVFsbmF0cjdDUkdaK3J6ejRQdmRjQU1IaU9XMnhQUXVZL0FQYVhoSUdD?=
 =?utf-8?B?RjZhdXFIZzJ0NHVVUHUyWmJYZGU2RzcwWE9VVXFHWXdqaFJKSGhjbmwyVFlp?=
 =?utf-8?B?VkNmSGFpc21rcU9rRmlabjRnV2REVU16SzQwSTN2MGRiaTZUWkQxNG9VMCs5?=
 =?utf-8?B?UEVTWGRIbmk3QXljK00yN2xXT0dXSFk3eE9BQlBQd2tOcFRwTzFIOENoTm1J?=
 =?utf-8?B?OHBIY0oyVW8rL2pKbEdIUE5KbmpSbWprRkRyUEVnY21rV0phdklrZlZ0T01n?=
 =?utf-8?B?MWIrQXhmdTQvaStwY2pBSEFiTklCTTV5WE9XN1cxTmJYUHJUbmdOc0REK2RV?=
 =?utf-8?B?SjI1emFyVHJxbjFVV2J4ZEl0eU1VWjllOHNnY0tWblpnYThMbG4vMVI1WGk1?=
 =?utf-8?B?ZUlCSGk3dUZiRlFSZi9rcXZQREw5VjdNUVNuOEhyN2hCQzQzLzNONktpNXcx?=
 =?utf-8?B?OTJnSHdObC9uM09oakFpUnJVWm9WQzlsTjR3QjEzNmhvWEhYcENsVDlMZ2hw?=
 =?utf-8?B?am51bE1DaFBVcHBDb0dOdlBXaU1PN1o4eFVUaHJxdmxJZnJCVVdmaDNFSzJz?=
 =?utf-8?B?bTArUmZyUHNCVXNhNlR3akFxRE52bys3Lzg0cW5jTEp1OUxyWHpXWkJOMDdD?=
 =?utf-8?B?dkRpVUY5dUtDOHhOaEtYbW5VSU4yWk9KYXZ1VTZKMWtYa2lqSm1Ybkh6bEdq?=
 =?utf-8?B?Z2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <033D439277208A45955EC2F1ADA724D0@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	CIR9d0GXVUeHmlOIj61TBBoLOPmWr/x71aviFrEL4N8FRN7gfbL3t4VHfMUd6jijCWibGA+SanbySHO8c69Wg70g9LqXWtaSiYVtIXLmn3Tjx+Qz1LTEm8H9SMFo7ZeruwkKuUpAX33wEdUBO2hzVj5u7HRtZ0yFnS2dgV0VaBohJrcpVjPZjilrGWwqyyY7qfW4RpPlZv/Akoh9svLDEurzWQSyzGUAc4I5sqEsXBIfHOfKNFrjzGZAdMFC2YtWj3D3THDVyDpc46dnWYlspm5BF3WxlNgoFP11h68W7bMj8cg/12GdEKWbT80qLXtUNtKYRtBHTyix88j31K47AEDTeFWxxf9qRN8W8xg7rfDWA3zhoqGkae+7oVLrxBsrBwEAEk8qk8k68XrzIKilC2vzKCh/yy5Na8fyZYrpypdESlvIQrCeI1JTOpWLgNnvabYvoMKlAZVpZiGLiueRrPsnqUHNcyCzZWQzWoqT6KU4ASyF/CITg+kI/pzd1jgrIWcxWodjLo3I5y0Od/Qt8ANYeb9jRNFyJ0baCqm4d+b+A3M+vXSU3cali/6/nfCQ0FJWV+V3HnsGw0fxmG30wxzQMuolt2aptQ+CVu073LCayEHakGi1GTtSgsKdw07kxjct7C4drJCbWxH9+wjqL/K7fk+2LPfmlYh4LJVUhTlCGR8ha45Eu3cd+wR6UKn7CeLxY/kngbEwjm5SHt8XnqUrhCBv9Xmuzs7wKw4tD4zfZBRgepf4E1V7/7i9JFEe2KtwlQ7XTCEhr7DQiAV3oQZEC7jb/dUVigky5rfWFmQWd9YQo3FzypI9mwh+UR6pRFiFf1AUeJNR02YHTNswdw==
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS7PR01MB11664.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d357ee5a-5c7c-4f90-b877-08db5a8b0678
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2023 06:08:55.8146
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x9xHuNKJcH2k9j/DCJx/hbEEiz1FtLcMxzD20C5ySldb3VYGeTqo8ZI7sfl3uZwh6F/iYTftDJfIWW/YStjyPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYVPR01MB11212

RGF2ZQ0KDQoNCk9uIDIwLzA1LzIwMjMgMDE6MzEsIERhdmUgSmlhbmcgd3JvdGU6DQo+IA0KPiAN
Cj4gT24gNS8xMy8yMyA3OjIwIEFNLCBMaSBaaGlqaWFuIHdyb3RlOg0KPj4gRm9yIGV4YW1wbGU6
DQo+PiAkIGN4bCBtb25pdG9yIC1sIHN0YW5kYXJkLmxvZw0KPj4NCj4+IFVzZXIgaXMgbW9zdCBs
aWtlbHkgd2FudCB0byBzYXZlIGxvZyB0byAuL3N0YW5kYXJkLmxvZyBpbnN0ZWFkIG9mIHN0ZG91
dC4NCj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBMaSBaaGlqaWFuIDxsaXpoaWppYW5AZnVqaXRzdS5j
b20+DQo+PiAtLS0NCj4+IMKgIGN4bC9tb25pdG9yLmMgfCAzICsrLQ0KPj4gwqAgMSBmaWxlIGNo
YW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPj4NCj4+IGRpZmYgLS1naXQg
YS9jeGwvbW9uaXRvci5jIGIvY3hsL21vbml0b3IuYw0KPj4gaW5kZXggNDA0MzkyOGRiM2VmLi44
NDJlNTRiMTg2YWIgMTAwNjQ0DQo+PiAtLS0gYS9jeGwvbW9uaXRvci5jDQo+PiArKysgYi9jeGwv
bW9uaXRvci5jDQo+PiBAQCAtMTgxLDcgKzE4MSw4IEBAIGludCBjbWRfbW9uaXRvcihpbnQgYXJn
YywgY29uc3QgY2hhciAqKmFyZ3YsIHN0cnVjdCBjeGxfY3R4ICpjdHgpDQo+PiDCoMKgwqDCoMKg
IGlmIChtb25pdG9yLmxvZykgew0KPj4gwqDCoMKgwqDCoMKgwqDCoMKgIGlmIChzdHJuY21wKG1v
bml0b3IubG9nLCAiLi8iLCAyKSAhPSAwKQ0KPj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
Zml4X2ZpbGVuYW1lKHByZWZpeCwgKGNvbnN0IGNoYXIgKiopJm1vbml0b3IubG9nKTsNCj4+IC3C
oMKgwqDCoMKgwqDCoCBpZiAoc3RybmNtcChtb25pdG9yLmxvZywgIi4vc3RhbmRhcmQiLCAxMCkg
PT0gMCAmJiAhbW9uaXRvci5kYWVtb24pIHsNCj4+ICsNCj4+ICvCoMKgwqDCoMKgwqDCoCBpZiAo
c3RyY21wKG1vbml0b3IubG9nLCAiLi9zdGFuZGFyZCIpID09IDAgJiYgIW1vbml0b3IuZGFlbW9u
KSB7DQo+IA0KPiBUaGUgY29kZSBjaGFuZ2UgZG9lc24ndCBtYXRjaCB0aGUgY29tbWl0IGxvZy4g
SGVyZSBpdCBqdXN0IGNoYW5nZWQgZnJvbSBzdHJuY21wKCkgdG8gc3RyY21wKCkuIFBsZWFzZSBl
eHBsYWluIHdoYXQncyBnb2luZyBvbiBoZXJlLg0KPiANCg0KDQpPa2F5LCBpIHdpbGwgdXBkYXRl
IG1vcmUgaW4gdGhlIGNvbW1pdCBsb2cuIHNvbWV0aGluZyBsaWtlOg0KDQogICAgIGN4bC9tb25p
dG9yOiB1c2Ugc3RyY21wIHRvIGNvbXBhcmUgdGhlIHJlc2VydmVkIHdvcmQNCiAgICAgDQogICAg
IEFjY29yZGluZyB0byBpdHMgZG9jdW1lbnQsIHdoZW4gJy1sIHN0YW5kYXJkJyBpcyBzcGVjaWZp
ZWQsIGxvZyB3b3VsZCBiZQ0KICAgICBvdXRwdXQgdG8gdGhlIHN0ZG91dC4gQnV0IGFjdHVhbGx5
LCBzaW5jZSBpdCdzIHVzaW5nIHN0cm5jbXAoYSwgYiwgMTApDQogICAgIHRvIGNvbXBhcmUgdGhl
IGZvcm1lciAxMCBjaGFyYWN0ZXJzLCBpdCB3aWxsIGFsc28gd3JvbmdseSB0cmVhdCBhIGZpbGVu
YW1lDQogICAgIHN0YXJ0aW5nIHdpdGggYSBzdWJzdHJpbmcgJ3N0YW5kYXJkJyB0byBzdGRvdXQu
DQogICAgIA0KICAgICBGb3IgZXhhbXBsZToNCiAgICAgJCBjeGwgbW9uaXRvciAtbCBzdGFuZGFy
ZC5sb2cNCiAgICAgDQogICAgIFVzZXIgaXMgbW9zdCBsaWtlbHkgd2FudCB0byBzYXZlIGxvZyB0
byAuL3N0YW5kYXJkLmxvZyBpbnN0ZWFkIG9mIHN0ZG91dC4NCiAgICAgDQogICAgIFNpZ25lZC1v
ZmYtYnk6IExpIFpoaWppYW4gPGxpemhpamlhbkBmdWppdHN1LmNvbT4NCiAgICAgLS0tDQogICAg
IFYyOiBjb21taXQgbG9nIHVwZGF0ZWQgIyBEYXZlDQoNCg0KVGhhbmtzDQpaaGlqaWFuDQoNCg0K
DQo+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBtb25pdG9yLmN0eC5sb2dfZm4gPSBsb2df
c3RhbmRhcmQ7DQo+PiDCoMKgwqDCoMKgwqDCoMKgwqAgfSBlbHNlIHsNCj4+IMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIGNvbnN0IGNoYXIgKmxvZyA9IG1vbml0b3IubG9nOw0KPiA=
