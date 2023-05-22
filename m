Received: from esa6.fujitsucc.c3s2.iphmx.com (esa6.fujitsucc.c3s2.iphmx.com [68.232.159.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77561113
	for <nvdimm@lists.linux.dev>; Mon, 22 May 2023 06:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1684736399; x=1716272399;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=FBBn0R7S3gCrWuWyBTaZUljnr7Cx6VtNeTdWPxnR6Ns=;
  b=ZLn43MtLhnaugpjfkTwPXoodOPVUfbKn9+NMmil/ySNNF0yeSf9nvTwa
   u4k4lTJs9A/TUDCaNUmX0Q6XXUffmwgUt42jTd2ZaLXv5LzyqsXV2Btad
   F55M4cRSU9DFskCarOruvwMzD97Ur5fHcGO1iaqvAtdWzUuBpTyZPumHf
   oXibtbqcNjeSH5YIZf4DyADTpY6AbM2u/H/5g1bX0MV4QZPQIE5uU+cDW
   5ZRlExO4rBorjhpA2tqkgWQxzliAzNiwguz0W+iyfxgSbiAIWaTjdLY7M
   kVIBOgNw6z4PO0s/awXNIL3X7fCwoCJPnhZswvsQgUABJpBGd21Bcd/qZ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10717"; a="85012641"
X-IronPort-AV: E=Sophos;i="6.00,183,1681138800"; 
   d="scan'208";a="85012641"
Received: from mail-tycjpn01lp2172.outbound.protection.outlook.com (HELO JPN01-TYC-obe.outbound.protection.outlook.com) ([104.47.23.172])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 15:18:46 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A6BrTeyytyKCdGL0P8EsbWSUsaUaj1ogPBOwgyPdfU9DdarI4j3zxJ4E3Z0J3TmASOEVo3KXW/citkgor9PMJtp0mM2DohaepGeqjG3AZqfHfOSax6U74WbmGBOcUuF7iiHMhbt6uuhfk1bQiHgfe1Db0UwEkoYyFkRqac9E6vhYWqGgee6iQwIoGW0TGd6V/VAxjTamo+XH/8kxP26pQrrNjb0Hwg1+1LXjCohkEM+m6yTROTRVCDT9gK81V4vI5uBOfpOL7qzxa3p50ErRl1AXapLPkOmsr51xW2MZ+BXaCo8kT9Lo+VylHThZkmv+Z2XtgFhWUfzCigw+kAcv1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FBBn0R7S3gCrWuWyBTaZUljnr7Cx6VtNeTdWPxnR6Ns=;
 b=I7ZFLxa+rMZXcoAH/x6XdgAzbBxOJO1XuMyIghOpibDTJBuP2/YPcx/UPb9GMPaV6AdqbLtu9oKrpKUck+OzEpyIQS0RPhlOuAVuIEJ3j9Wb9J7Ck6xIXhTcNVldIkn56VsPRIDIQDx5fVBHg0Wz86XpDr9ZNXLU1D5eWWJsvcqyJMEqEVl5VctOR0XAiYMJ1HDcUwYSYEqbTHbjku3Z+tkOt9aPdIPnfVKaAL0Lydxc0qVEM37sL5ZwYJaDz1hl6gdWBpmilnCudTNw/sTlhHn20JN+MOmx52cAe56+z1nEUIUSbqYfu3aUG/vlJ2q2r1UEX1G6SXnwiNWawGdM2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from OS7PR01MB11664.jpnprd01.prod.outlook.com (2603:1096:604:247::6)
 by TYYPR01MB8150.jpnprd01.prod.outlook.com (2603:1096:400:ff::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Mon, 22 May
 2023 06:18:43 +0000
Received: from OS7PR01MB11664.jpnprd01.prod.outlook.com
 ([fe80::687d:4884:ec0b:8835]) by OS7PR01MB11664.jpnprd01.prod.outlook.com
 ([fe80::687d:4884:ec0b:8835%7]) with mapi id 15.20.6411.028; Mon, 22 May 2023
 06:18:43 +0000
From: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>
To: Dave Jiang <dave.jiang@intel.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH 4/6] cxl/monitor: always log started message
Thread-Topic: [ndctl PATCH 4/6] cxl/monitor: always log started message
Thread-Index: AQHZhaYe7WItcGixyEWGfQduBRj91q9h53OAgAP3wwA=
Date: Mon, 22 May 2023 06:18:43 +0000
Message-ID: <4bbbf4e3-3d37-9c11-62e1-9cc4152d898c@fujitsu.com>
References: <20230513142038.753351-1-lizhijian@fujitsu.com>
 <20230513142038.753351-5-lizhijian@fujitsu.com>
 <29980935-054d-134a-88b6-b9062e8a1761@intel.com>
In-Reply-To: <29980935-054d-134a-88b6-b9062e8a1761@intel.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS7PR01MB11664:EE_|TYYPR01MB8150:EE_
x-ms-office365-filtering-correlation-id: 5171ac46-4b72-4173-6fc7-08db5a8c64d0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 jG9Gebh+GQQAIs7Yt0dYdeQFcAhCnUHRwyzVeyLhudQd6uvKyrKQ4xFF/SatBilTasluWuQrAPcBlOk5kbx1vU6G77RJw33NpZvaO6qZNvFR5SmQycSUUjIVqVHcW4aCWAM6lK39pR1EdHASoO15NTZc2w2552uBppAKrnGDNmSmhCzqZW3Rkc3ajcFEkr0kRWRmXB/M5Y5QFXdkRnz/5WdBTxlQ+vZk9ogLJ/QWRAdV3noRtdVdoRCRJbVqtP0QuODOEMu9tUbv63GqJ2ndE9z3wVj1hqI8IotKhLY7K7X7tSpr0hfMTgPU4VBT8Oj0OgUm5yNNkWIeUOpXwMNQEqoPReHCl/FEOE9/tWF9j9pk+GyeivvbVDnfVJ6JgS7T75NzA1dr6ZqflB63Dkm8F6SujPULXoz9Vx2Y5MRuX84wPjsG8iUzQBUvtnrzgf7SntsJnm612adduYPxL//xpLWSSy4HdmorF75Zc7vhYiI9PPCMQw1oxcxFLavuCwG68JpNxsh6GHN9hsYwEOseNuFTRkaArypEM+0NAqcv6tTwkXcfJkPItCHDWbPkaTJkF/cBBta7bEvmG48G1YIDOar+GqU/bcvt6v5QC+2QSPONeEBNsllFbNSEwfWhd5uMMxnhS6ufgIXlbxTbIvaBn2HW7Jg5IGKVmGyCwXF6HSNNdRgU85q2VFQAcPhkd5waznpyiD1gJ4Y8K3VJxNHtZQ==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS7PR01MB11664.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(396003)(346002)(366004)(39860400002)(451199021)(1590799018)(8936002)(8676002)(5660300002)(83380400001)(53546011)(186003)(6512007)(6506007)(26005)(2616005)(31696002)(86362001)(122000001)(82960400001)(38100700002)(38070700005)(41300700001)(71200400001)(6486002)(478600001)(64756008)(66446008)(66476007)(66556008)(66946007)(76116006)(91956017)(85182001)(316002)(36756003)(110136005)(4744005)(2906002)(31686004)(1580799015)(15650500001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?VElOUEErRnFGdyttYXdJUUwydEtYemlxaWFXaHJSVld3N3QvUGNuYUVUcHFn?=
 =?utf-8?B?ZGZXWDMzMUdhSVRhRU5iRFZBMzQxK1ZpaktadURMNFpod2s0WkkrZEF0TmVw?=
 =?utf-8?B?WHR5cC85SHVoaGNmT0JOWkh5SUxWakJOYVVHbytJdnB6ZUhZYmpvdDBzTGF6?=
 =?utf-8?B?YUxON0V0TE4wM2h5d0FvNXVqQTBjaDdKVnRKQkx2ekUrSFd1YStON0hsaWRq?=
 =?utf-8?B?K3ZFY0xqNExJVThrMmpFajRTanB4M2tJYXdubkxrK1hlYVUyVTQ1QVIwdXNn?=
 =?utf-8?B?Z0tjNkRvOGFUQmdXYWd0TjJ2ZUZYZy9HMmplRGRHRUNzKy9NdXdWNDE5MFNW?=
 =?utf-8?B?aFh2bVVnZ0g5ZDQrOTlHWG5hQ01naVNtOG5lbXVqcDloTVRSNE8vQVNCaXMy?=
 =?utf-8?B?cUtsMXJxRGJGTE5ocG1lNFJaK0MwNEJwZFNCdThlSHZKOUoybnJ1aFBRbUdZ?=
 =?utf-8?B?dU9ndlpZdktkRkE0aWJlQnVoL1hjbjJzQm42RDYxcFp4ZU5JNW5BOWdIYzJJ?=
 =?utf-8?B?a0loNjd4MXBVYm9pSzFQUVUrUCtORWt3NmF2YXo0dzhEcXp4NWMvVEZnUFVN?=
 =?utf-8?B?SHBlVExBU1h3dHlTcDNmNTJXMVdFNzliUEI5SXdiS0FqdTJIODlwL25FQndQ?=
 =?utf-8?B?QVNHMUdVeUZaS2IrSEwxYUErK0Y3UFk4YUNzY2c5KzRGdkJ1Yk1qNi9xeHI4?=
 =?utf-8?B?eWJJSUJtSUxYcHpub1J5YUFkWnBKbUExVVhaaW5jOXBwcUNDQ255NTY5NVp2?=
 =?utf-8?B?MTJTbnJmekNlUzN0OCtpWG1VWFFidWYrRmNZRWZYSjlsc2lNS1VqNERzbnFR?=
 =?utf-8?B?RWZCSDJnL3RjdG5hN0Z2dy9qcU1vQnRjdnR5VUc0NFVkZFpRcHhKTENkeFdh?=
 =?utf-8?B?b3FhaVptRC9iMGlTWmwydnczaXhaUHRPZTM5czRGSFZ6aTFBQzRYNVFPL2ZJ?=
 =?utf-8?B?a0tFUnFUUlJYWS8wLzdWOTU0RFBoYXJtWmU1djMxakdrNjU1dzcwMFdNT3JG?=
 =?utf-8?B?c1RRd3BCVWhwMUE0UE5NT1BPWFJHK0VtcVBTK1V5WGhoc3A4bVk5c1pMMzA5?=
 =?utf-8?B?RStzaU5PSi84TjdJZDRuQmI4RGwvNVRxNHd2OUQvSmtZclZCS1NRam4rTGpE?=
 =?utf-8?B?SnBwVFVucUdPcVpicGpxandpTnpaaFV6YldFeko2WnE1dWZndVZlZUtuTUcw?=
 =?utf-8?B?djljM2czdHp1Vk00L3JIWXhmZVZnMmNEeHBwVHpQbFZnZWoxR3oxMFBwSEky?=
 =?utf-8?B?RTdGbzIyMkdmTStYYlN2ZmxaZ1NXdFo2bkpWNW81ejY1djN6REFUVVFpem5F?=
 =?utf-8?B?VG0xdTVQS1ZaVGwxMzVqd0RKTTBGZHM2NmpZL25TOHVIZmlMb3JVNnNFR1hY?=
 =?utf-8?B?a0d2bWpRM2FPTGZoelhRWFl3ajRCUlFkaVpEaWF0WFJLelhOVGZPUXgvcm14?=
 =?utf-8?B?Yjc3ZUY5Z0dmL0NObk9IMWhMRlJBalltY3JwVThjdlpaK05EaXMzWFhmNjl2?=
 =?utf-8?B?NjlmR0IvR2EvYnlPZ3dVWU1RcmZUSkh2MGpnZjVtRlZKU0Q5NFcwcmdXbVVT?=
 =?utf-8?B?N2RXMTREVU9QRnltU2JiQ2c4VVFuajkzQ2l6QTBCOGdoWjFtdm4wYW1kMzIx?=
 =?utf-8?B?dUk3cStzZG1GampuQ0lid1Q3S2t6cUJHVVpzVE5jSFEwK1BUWDBrS2gzVVFD?=
 =?utf-8?B?eTlmZzZJYXFwd0xFQkRPYXJhZEthdjM2V1hOdC9tL0hENXU5VTNrY2pROFRT?=
 =?utf-8?B?ZmZTY3VHZldWQStOT0szc3BxVjRWVCtXZ3N2anNKR2lHNWpoeStadHo1U2hK?=
 =?utf-8?B?cHJKTFVYVnA0VHVVTGcwcm5nUUF6NFo2Qm1MTXc4a0JVVmE2TERTTFhYb2cy?=
 =?utf-8?B?Nll2MnB0QlRETmloL05xZ1NydnZvUUdESldtL2JTb29WS2RUNThyWUloWkNo?=
 =?utf-8?B?UTJCUzYvaEJhdXhWWUxTV1g2LytBaHMzRHp0SXJSeGZkUkFDMlpzQ2xaYm1h?=
 =?utf-8?B?SElJVSt5L3BPQU1lUGdiNTRBWk1VZFpxWHhtQjRtZEgyZzhacFBhMzFlZUZu?=
 =?utf-8?B?dzFCQWNXT2xzTkNSNHBvR0dsaHhhNEVxNndXZTN1SG1zUnAyL3NGT3lWNUJY?=
 =?utf-8?B?SjdkeUN1ZGJkbm0rUGd4WlV0QVp6Q1FYbUl5czdCdUxrL2dJMXkrNHk3TUVh?=
 =?utf-8?B?d1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A9655BCDA24B0340B420629025393465@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MswiupN1MsCyaMjY9+6AAAZpF0Dk4g6uQijiGOgfH/h+a9aMXSVvK+X06kk+7VyZo4+NXa1LeEXp3Th4MMZheYKz/WsxRbDG14bQGYIKW2H17mFz+K/iQlbwDYLdk4wcgb4v8k5wfQrGnvUo4JSlNtLZ2BT7/VMue2mJRbmRbG4MJFyxdNQLSWGJJy1LMfntKLllx/r2yzJXiicu/dPGmMZrsvxJt+yZDNiWFKAly32Ldqekk2IM4mfX4mNRwiLh/+dN1V7znn3rCR0Jqgx27Z+l7gVqyV4Hkol/9s+cXNp4+hlRzV+wTUR5o/h86Xj5Vscg3zoqyd/ulKV/Sxq84iE5pjF0LuJdpRDjCP484R5naB3tVJabqrtZBEvRFUilN3jkKtZY+u9DHUd1Co3teftj1RezazBz+rC3aPKvxvlLO7puyfzjDwtRgEYKD0IL/WajP2NwQX9wHspYHz6fikoGA1Qkry6yxVmrb6orivOap/HteexdwEPODIRci5Q2K29aHyMLpNpZFukX8iDaOITFsce5+asAuJTMknuFGouvBhFqW+JCFbvBBcnCuH3UFvwP1KMxAhRnzOfrzkfC6Z4clBoNHEfEOCa076iINS4C85GofdBI42k7CnZwsDTU6sb+TaEeOKIc1Q+8+yMJ64enHtQax1YVJ0VVVRP2K1v8/0sBQjMhXcEvUcIgl47wRB3ae0od9LKIrUbY4RP+iqbFDMgREOxfKgJkdGc+7WXYh2NrPI13Tu2HzJzphFCaQPYyRIaRVRqLmuNU7x3SQMj2kmp2Z/kO9eIR6i1MBo8=
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS7PR01MB11664.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5171ac46-4b72-4173-6fc7-08db5a8c64d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2023 06:18:43.5753
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FgrxzFF7tnkG5tGjr60KXxcU/ItBIK+qjT3xmeVW+hdbJ5Vx3/9spGhijBaSY6hmaBfZeJbTAw6CQtAPBN4Gag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYYPR01MB8150

DQoNCk9uIDIwLzA1LzIwMjMgMDE6NDMsIERhdmUgSmlhbmcgd3JvdGU6DQo+IA0KPiANCj4gT24g
NS8xMy8yMyA3OjIwIEFNLCBMaSBaaGlqaWFuIHdyb3RlOg0KPj4gVGVsbCBwZW9wbGUgbW9uaXRv
ciBpcyBzdGFydGluZw0KPiANCj4gQ29tbWl0IGxvZyB0ZXJzZSBhbmQgbm9uLWluZm9ybWF0aXZl
LiBQbGVhc2UgZGVzY3JpYmUgd2hhdCB3YXMgdGhlIHBhc3QgYmVoYXZpb3IgYW5kIHdoYXQgaXMg
dGhlIG5ldyBiZWhhdmlvci4gVGhhbmsgeW91Lg0KDQpUaGFua3MgZm9yIHlvdXIgY29tbWVudHMs
IGkgd2lsbCB1cGRhdGUgaXQgaW4gVjINCg0KVGhhbmtzDQpaaGlqaWFuDQoNCg0KPj4NCj4+IFNp
Z25lZC1vZmYtYnk6IExpIFpoaWppYW4gPGxpemhpamlhbkBmdWppdHN1LmNvbT4NCj4+IC0tLQ0K
Pj4gwqAgY3hsL21vbml0b3IuYyB8IDIgKy0NCj4+IMKgIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2Vy
dGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPj4NCj4+IGRpZmYgLS1naXQgYS9jeGwvbW9uaXRvci5j
IGIvY3hsL21vbml0b3IuYw0KPj4gaW5kZXggMTM5NTA2YWVkODVhLi42NzYxZjNiYjk3YWYgMTAw
NjQ0DQo+PiAtLS0gYS9jeGwvbW9uaXRvci5jDQo+PiArKysgYi9jeGwvbW9uaXRvci5jDQo+PiBA
QCAtMjA1LDggKzIwNSw4IEBAIGludCBjbWRfbW9uaXRvcihpbnQgYXJnYywgY29uc3QgY2hhciAq
KmFyZ3YsIHN0cnVjdCBjeGxfY3R4ICpjdHgpDQo+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBlcnIoJm1vbml0b3IsICJkYWVtb24gc3RhcnQgZmFpbGVkXG4iKTsNCj4+IMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIGdvdG8gb3V0Ow0KPj4gwqDCoMKgwqDCoMKgwqDCoMKgIH0NCj4+IC3C
oMKgwqDCoMKgwqDCoCBpbmZvKCZtb25pdG9yLCAiY3hsIG1vbml0b3IgZGFlbW9uIHN0YXJ0ZWQu
XG4iKTsNCj4+IMKgwqDCoMKgwqAgfQ0KPj4gK8KgwqDCoCBpbmZvKCZtb25pdG9yLCAiY3hsIG1v
bml0b3Igc3RhcnRlZC5cbiIpOw0KPj4gwqDCoMKgwqDCoCByYyA9IG1vbml0b3JfZXZlbnQoY3R4
KTs=
