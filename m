Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2062.outbound.protection.outlook.com [40.107.92.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385517E
	for <nvdimm@lists.linux.dev>; Wed,  2 Aug 2023 01:25:46 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Grw3c+GuwPnSIyx4MMyss6fk8CwIuMNJvMx1GegPpK2OsPecW6K4Qy94GErwSVg1OEMTvibEmX0Fc1aMSvYOFgb+QRJ6e0cj3OT5YewQV4DOAv7aSgOB5mKkvCiS9iwGsCLq0I8lu5C8YYwlxAdY1Mo/tOivLCHleCi83ZGD0xRioFtZNP1IKwTl2QtpSJf2Kch5ycd/XYg0TMq91QXMYXxezdR2zz5r+dEBFAA309K/qjFA9HB6Vai2pm2OoOeB9M7qfWYpLOLpEvBucXhPh2pFjA19zzQqEzuTxtOwnVBaByrEgEaQQuXgBIwYKzhpCZPkQtPYyOSjjIClXagzuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5hQPm/DfLvbENaXEHXzOQfKVH7MbemggWTJd+A3ZH2s=;
 b=LLQC+l29kI3K9pV4lCLTrx1j/xVtuRyJ1zrePLzwzvlHq1SjPoJCnFaK87inVvNRUqa+H8+FCzs0B3e3bwrYkvDordPAs/VbU9UBKBl3Qgtjl2kl4woER9sxL4VYzRwrsNwNR+p7F4ZefTJ0d1DKHcf2hyTtI6GeeLbOVkG8ztd8oE9av5h7joxKc0TEQZglA/IOiJZyTKTpvZxaX6pmy5oZd5TqxS12I//VKHalE9y7FVRSDi24HwTG45MUCRzUvS3C7q5zXyJb7+m+pNUqKHZqYpsB7QP7cjo78C7KNSWAgG+9VBN+//pRSrTVFy+qSaIewStILL6ivUcw9cUtNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5hQPm/DfLvbENaXEHXzOQfKVH7MbemggWTJd+A3ZH2s=;
 b=qU1mP59OJ6fFc1oHW42/Php6GhFHdtQdd5pWC7fyPqQrHeyioX+FEs8/dher9/X1tzOVi6Jt6n/owcyAPTE5jsYK1H1Dx8ta9WJvWjIsxA1+J4xOdE3IYotR4GRnxF/zhLXuOiSRN38IJzVqS/5xcmZ/IA1chNF33N9jIZ9/TK2WHTK4SpX6DcufXW91SuMpD7+TOMF5VStsQXqLByX7wOguz4fj1KEDxVfWOoaBa0pf7mF9oX+RmsjimdUL8TB8/BHHOCKLnLsC5CE+oDBXPxWqMtF4E/kgTQF6x8vjvsY7EalRkJi3aSTePEI4SjmH4LsMkewep9iagiBRlYCppw==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by DS0PR12MB7996.namprd12.prod.outlook.com (2603:10b6:8:14f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.44; Wed, 2 Aug
 2023 01:25:44 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::c3cf:2236:234b:b664]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::c3cf:2236:234b:b664%4]) with mapi id 15.20.6631.045; Wed, 2 Aug 2023
 01:25:44 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Jeff Moyer <jmoyer@redhat.com>, Christoph Hellwig <hch@lst.de>
CC: Chaitanya Kulkarni <chaitanyak@nvidia.com>, "dan.j.williams@intel.com"
	<dan.j.williams@intel.com>, "vishal.l.verma@intel.com"
	<vishal.l.verma@intel.com>, "dave.jiang@intel.com" <dave.jiang@intel.com>,
	"ira.weiny@intel.com" <ira.weiny@intel.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
Subject: Re: [PATCH V2 1/1] pmem: set QUEUE_FLAG_NOWAIT
Thread-Topic: [PATCH V2 1/1] pmem: set QUEUE_FLAG_NOWAIT
Thread-Index: AQHZxADrXE+/yvq5u06qlYmjeW0Jd6/Vjqw1gAALsYCAAB0cXoAAgQeA
Date: Wed, 2 Aug 2023 01:25:43 +0000
Message-ID: <0a2d86d6-34a1-0c8d-389c-1dc2f886f108@nvidia.com>
References: <20230731224617.8665-1-kch@nvidia.com>
 <20230731224617.8665-2-kch@nvidia.com>
 <x491qgmwzuv.fsf@segfault.boston.devel.redhat.com>
 <20230801155943.GA13111@lst.de>
 <x49wmyevej2.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49wmyevej2.fsf@segfault.boston.devel.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|DS0PR12MB7996:EE_
x-ms-office365-filtering-correlation-id: 09f06450-173e-4aae-2da6-08db92f7643d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 B7fv61RxKv/CDplmv98hhMYs1ixhyZ08C2e8k97lPLz4PlGstRJcW4ZtJeRjk+u8ezHuqKKYUI9s9e5B44KAJTbMzN7jSXu4afV7FcfYmureeWzacSSAyG/4xNtmkf9ga+IUhNmrvzNQzmC0nAbsFQ3QYnJM4nASMcZV0iuOATtdzbeqRvQ6LA3KtGUacVIz6lyUNIQ9boEsY8zhCohTlkv2oqIzdD9knwVNh45nyqtBA2n2eRlESe+RqZCT9m0U4xPjnqfihP1hAH1M4fz/9bIwsjbZnuyNqfN1oMXvR2Ln6j82/qyxp3k4fxeaq9V2328tcWdek8zyYfcp6fztsW9ESlSW1HV2x6sA0Hp6zTQGUx0z9PCSauQ/KxZnYkYjxa/qvMaoF+Rsn6LyBQspvuI5HkoK3Z+8lkPPXv2s86mUgu6BId/PNJVEJwr1FdAc6p/zUmnFVcTJvaj+YFpu/l2uEENRHPacbLTLcw5CnyMmDPB3mUhDJpfIduBe2qdn+IKpdAqG8b/ub9xhsydxEgIgKJEvMZd5lEjiNovBURn4dzWKoNC0GwjjZ+QAXAikPwHfiav5yGoxRm4ebocdsvIKdeYyOQ01UGjZJ5wvy01lEVLYkgF/FHJ4ZJ0+cuOlNqSMqatDGMztVLNVRoxKeInNRJFxKNqgfCK6o3LpXuzQpPTQmvJDrelMyoPZe3Bx
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(136003)(396003)(366004)(376002)(451199021)(38070700005)(8676002)(8936002)(31686004)(36756003)(6486002)(41300700001)(478600001)(2616005)(2906002)(83380400001)(26005)(316002)(31696002)(186003)(86362001)(6506007)(76116006)(5660300002)(38100700002)(122000001)(91956017)(6512007)(54906003)(53546011)(4326008)(110136005)(71200400001)(66556008)(64756008)(66446008)(66476007)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RFJsamdQOWdzZGE4aG8vWGxHMXNWTXpoRUYzdE9MbnhycTlMeGlJNGpIN21z?=
 =?utf-8?B?YWNMczZGM2I2R25ZUStFcFdyRzZ4V21iaitoWTkvQ1ZSOTIvNXVsbnhBQ2lx?=
 =?utf-8?B?V3VKbW53eDFoc3o0TnVXVG8rUzdBLzFzQUYvdFpLWDZPaXNFY2pFWE9KcWJu?=
 =?utf-8?B?ZzNSTFpQUmNPWS81TmpzU3ZsSTJoaEwzamVXZTVTZDAvN1JMaHZWVkljdGhL?=
 =?utf-8?B?WTErbUg4cld5RmVmT0FKYkdGdkw4Q3JFUzhaYUlua29xb2R0MElMaE0yVitF?=
 =?utf-8?B?TlN4NVg2Qm5ROWxWdnh4WW9TWjZiZGVLN2RFU3kvTm0zVVVXZ1A0Z2YyT2px?=
 =?utf-8?B?emg3NmhmVTZmVGFCcUt5S0VPeDQwUEIzZkszS1lQcXM0U1hKZjUzdVlqcUN6?=
 =?utf-8?B?SDFERnorcGNLVHJjSW9XMitEc205N3dyUCtmQkpaS0pBZTlZMzlBZnZQK0pR?=
 =?utf-8?B?czYxS2FLNHhFZDBaZVF4RmNyd0dvcUVaSFpUQ3pGZGZWYXZWRHpJQVhQRytU?=
 =?utf-8?B?d2tVdTJSZHdqVTdZMmF6elpROGtBeHFJZzdDL1padEdzZTgxa1YyZE9FVnJS?=
 =?utf-8?B?b3BvWnFRMis1R3hLUjJueWFyYjRVOHVKM2J4WHhRdy9xQS9GQmdWRm0xNGNE?=
 =?utf-8?B?ZTI1MGlXNlpJRmMySU9XNXpLNTNaV1lyRkxNelpqeFpxTy9QdjBRemhuYW8x?=
 =?utf-8?B?U3F3UXZBM0NOalFSb0pwbmc5Q01Xa2FhVXlwY205UDNTdG5SRFg2WnQwNEhq?=
 =?utf-8?B?K1djK3lqUnNHQjJCcnZxbnJZMjEvR1hzT2pBalZMTFlaVHlOTXo3REN5VFlR?=
 =?utf-8?B?NDRjb2NLVDBtbzBVZU1pdGZRRHRvTGZOZnVoM2JreTdZMmFxYTlqNmFkOXFj?=
 =?utf-8?B?OVVhbjVKVDBCdzRHc2p0cm5JTUd2blBidDBOOTkyUzhib2toVkhBWkQ2TWYy?=
 =?utf-8?B?RWZLMmpLc1Y4RWdPQ2RmMlNaaVRuMmk2V1R3aXcxZ0ZvSzl1QTE4d1djTHlC?=
 =?utf-8?B?RFJKK1lwcW1TTmJhMUZxY2l5dFJTMTNwczdsTzdqMVNPY25GWWgwOFh3a0ZR?=
 =?utf-8?B?dE0yZVZXQWU3enhXbjRjbFhlQ1hkcmZhUk10bkE4Y0lsZW1ZWmNyd3hyMDU3?=
 =?utf-8?B?USthT2JOOUVQcWtuTytUbXJTWjBvYkJQdGd0RzQxM1ZRWExVTEZMdkpXYTQ0?=
 =?utf-8?B?bGd2Y2Z4L01CRU5BbE9hbzRnZkFVRmljdGNlcnBpY0tCSy9mUGFkd1dJb0Fk?=
 =?utf-8?B?SnBQeEpuVE8zYlYrNUx4MG8yWFV0ZUtWVHBaSVp0QU9wRVJ3eXF4ck9Gc3RQ?=
 =?utf-8?B?UXBhSVJ4NmtRQ3J4YWl0ZU95QmI3RHZ2N0s1VHRmYzVGV2VNZGduczBGb0FU?=
 =?utf-8?B?ZDBmb0tvTm03SHQwVk1wSzJLUktxdGlESEQwc05PTkp3NXhaQmZzOWFEZTVV?=
 =?utf-8?B?STVpZWRvVVV6YmJkTzJEYUtsWjVWU3doTTgzK1NQd2xER0cyMXZRaytDbFdk?=
 =?utf-8?B?NDF4MkRHemU5MjlZUUVnZktwWm1kVW9ONXJ5ckJBWHpMK2NINHVISmZUTWpP?=
 =?utf-8?B?blVzdHdIOGJyc2Q4bGw5OUN2L0g3bncrMk10L09SaitURlhkVnhtMDRzVWlk?=
 =?utf-8?B?d0c1Q3V2UVpEZm5jR3R3QXJXQVNVTm9aaHlQMEdoRm0wU0d2dXprLzBpQ0hu?=
 =?utf-8?B?aUttdHJUNmd4VkVyY1htb0JaUFIrc1I3Q0dIVU5MbHRjbGh2Q0ErZitHT3l3?=
 =?utf-8?B?Q0ZuWG1rbUx2OHE4U2MxeVZ5bERmUDJxN004SExBZU0wNGF3WEZjMHIySWlY?=
 =?utf-8?B?VXd2eVl2anZCNWp3UkFvMU1xZ25meDE4bTRFUlJOcTZjcEFQVWhERTZrL3NF?=
 =?utf-8?B?eDMwMm9Ib2tYaU42a1ZIT1hxMDhFVkNEQTFpZXQ3MVRnOS9IMWV4bW42Qk04?=
 =?utf-8?B?aFJKQ3BqVGVxY0FCaEJUSEo4RXl6RjVaNFhQUGswY3c3SG91TnNDNE9QQzFp?=
 =?utf-8?B?aDlQSFZ1V2VkOWRqaG4xRThGSEVveWd6TWNRejk0ZlYySGllSmxhQVdITkN5?=
 =?utf-8?B?V2F2RGUwUEVMa015dEN3VFc5RXZGaVl2eU5kWlVaWEhnNU85V0gxOEFBTWNK?=
 =?utf-8?Q?Oz/w09AwLIok9A+p7Vz30oqSM?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DD7F344D9D3E42488E40542487B43363@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09f06450-173e-4aae-2da6-08db92f7643d
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2023 01:25:43.9040
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gJV13TWzra2iyjzk5jUzEN7aMCOrAEhyHunomvmOOrSJG5SlGPipYnb9d8miaTXsmfDqB/gBUtoZb1V3m/gYdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7996

T24gOC8xLzIzIDEwOjQ5LCBKZWZmIE1veWVyIHdyb3RlOg0KPiBIaSwgQ2hyaXN0b3BoLA0KPg0K
PiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4gd3JpdGVzOg0KPg0KPj4gT24gVHVlLCBB
dWcgMDEsIDIwMjMgYXQgMTE6MjM6MzZBTSAtMDQwMCwgSmVmZiBNb3llciB3cm90ZToNCj4+PiBJ
IGFtIHNsaWdodGx5IGVtYmFycmFzc2VkIHRvIGhhdmUgdG8gYXNrIHRoaXMgcXVlc3Rpb24sIGJ1
dCB3aGF0IGFyZSB0aGUNCj4+PiBpbXBsaWNhdGlvbnMgb2Ygc2V0dGluZyB0aGlzIHF1ZXVlIGZs
YWc/ICBJcyB0aGUgc3VibWl0X2JpbyByb3V0aW5lDQo+Pj4gZXhwZWN0ZWQgdG8gbmV2ZXIgYmxv
Y2s/DQo+PiBZZXMsIGF0IGxlYXN0IG5vdCBzaWduaWZpY2FudGx5Lg0KPiBJZiB0aGVyZSBoYXBw
ZW5zIHRvIGJlIHBvaXNvbmVkIG1lbW9yeSwgdGhlIHdyaXRlIHBhdGggY2FuIG1ha2UgYW4gYWNw
aQ0KPiBkZXZpY2Ugc3BlY2lmaWMgbWV0aG9kIGNhbGwuICBUaGF0IGludm9sdmVzIHRha2luZyBh
IG11dGV4IChzZWUgdGhlIGNhbGwNCj4gY2hhaW4gc3RhcnRpbmcgYXQgYWNwaV9leF9lbnRlcl9p
bnRlcnByZXRlcigpKS4gIEknbSBub3Qgc3VyZSBob3cgbG9uZyBhDQo+IERTTSB0YWtlcywgYnV0
IEkgZG91YnQgaXQncyBmYXN0Lg0KDQpmb3IgdGhpcyBjYXNlIEkgY2FuIGFkZCBiaW8tPmJpb19v
cGYgJiBSRVFfTk9XQUlUIGNoZWNrIGFuZCByZXR1cm4NCndpdGggYmlvX3dvdWxkYmxvY2tfZXJy
b3IoKSB0aGF0IHdpbGwgdGFrZSBjYXJlIG9mIGJsb2NraW5nIGNhc2UgZS5nLg0Kc29tZXRoaW5n
IGxpa2UgdGhpcyB1bnRlc3RlZCBhcyBhIHByZXAgcGF0Y2ggZm9yIHdyaXRlIHBhdGggOi0NCg0K
bGludXgtYmxvY2sgKHBtZW0tbm93YWl0LW9uKSAjIGdpdCBkaWZmDQpkaWZmIC0tZ2l0IGEvZHJp
dmVycy9udmRpbW0vcG1lbS5jIGIvZHJpdmVycy9udmRpbW0vcG1lbS5jDQppbmRleCBkZGQ0ODVj
Mzc3ZWIuLmVmZjEwMGY3NDM1NyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbnZkaW1tL3BtZW0uYw0K
KysrIGIvZHJpdmVycy9udmRpbW0vcG1lbS5jDQpAQCAtMTc5LDEyICsxNzksMTYgQEAgc3RhdGlj
IGJsa19zdGF0dXNfdCBwbWVtX2RvX3JlYWQoc3RydWN0IA0KcG1lbV9kZXZpY2UgKnBtZW0sDQoN
CiDCoHN0YXRpYyBibGtfc3RhdHVzX3QgcG1lbV9kb193cml0ZShzdHJ1Y3QgcG1lbV9kZXZpY2Ug
KnBtZW0sDQogwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBz
dHJ1Y3QgcGFnZSAqcGFnZSwgdW5zaWduZWQgaW50IHBhZ2Vfb2ZmLA0KLcKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHNlY3Rvcl90IHNlY3RvciwgdW5zaWduZWQg
aW50IGxlbikNCivCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBz
ZWN0b3JfdCBzZWN0b3IsIHVuc2lnbmVkIGludCBsZW4sIHN0cnVjdCBiaW8gKmJpbykNCiDCoHsN
CiDCoMKgwqDCoMKgwqDCoCBwaHlzX2FkZHJfdCBwbWVtX29mZiA9IHRvX29mZnNldChwbWVtLCBz
ZWN0b3IpOw0KIMKgwqDCoMKgwqDCoMKgIHZvaWQgKnBtZW1fYWRkciA9IHBtZW0tPnZpcnRfYWRk
ciArIHBtZW1fb2ZmOw0KDQogwqDCoMKgwqDCoMKgwqAgaWYgKHVubGlrZWx5KGlzX2JhZF9wbWVt
KCZwbWVtLT5iYiwgc2VjdG9yLCBsZW4pKSkgew0KK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgaWYgKGJpbyAmJiBiaW8tPmJpX29wZiAmIFJFUV9OT1dBSVQpIHsNCivCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBiaW9fd291bGRibG9ja19lcnJvcihiaW8p
Ow0KK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiBC
TEtfU1RTX0FHQUlOOw0KK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfQ0KIMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBibGtfc3RhdHVzX3QgcmMgPSBwbWVtX2NsZWFyX3BvaXNv
bihwbWVtLCBwbWVtX29mZiwgbGVuKTsNCg0KIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBpZiAocmMgIT0gQkxLX1NUU19PSykNCkBAIC0yMTcsNyArMjIxLDcgQEAgc3RhdGljIHZvaWQg
cG1lbV9zdWJtaXRfYmlvKHN0cnVjdCBiaW8gKmJpbykNCiDCoMKgwqDCoMKgwqDCoCBiaW9fZm9y
X2VhY2hfc2VnbWVudChidmVjLCBiaW8sIGl0ZXIpIHsNCiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgaWYgKG9wX2lzX3dyaXRlKGJpb19vcChiaW8pKSkNCiDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJjID0gcG1lbV9kb193cml0ZShwbWVtLCBi
dmVjLmJ2X3BhZ2UsIA0KYnZlYy5idl9vZmZzZXQsDQotwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGl0ZXIuYmlfc2VjdG9yLCBidmVj
LmJ2X2xlbik7DQorwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIGl0ZXIuYmlfc2VjdG9yLCBidmVjLmJ2X2xlbiwgYmlvKTsNCiDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZWxzZQ0KIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmMgPSBwbWVtX2RvX3JlYWQocG1lbSwgYnZlYy5idl9w
YWdlLCANCmJ2ZWMuYnZfb2Zmc2V0LA0KIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGl0ZXIuYmlfc2VjdG9yLCBidmVjLmJ2X2xl
bik7DQpAQCAtMjk3LDcgKzMwMSw3IEBAIHN0YXRpYyBpbnQgcG1lbV9kYXhfemVyb19wYWdlX3Jh
bmdlKHN0cnVjdCANCmRheF9kZXZpY2UgKmRheF9kZXYsIHBnb2ZmX3QgcGdvZmYsDQoNCiDCoMKg
wqDCoMKgwqDCoCByZXR1cm4gYmxrX3N0YXR1c190b19lcnJubyhwbWVtX2RvX3dyaXRlKHBtZW0s
IFpFUk9fUEFHRSgwKSwgMCwNCiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBQRk5fUEhZUyhwZ29mZikgPj4gU0VDVE9S
X1NISUZULA0KLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCBQQUdFX1NJWkUpKTsNCivCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgUEFHRV9TSVpFLCBO
VUxMKSk7DQogwqB9DQoNCiDCoHN0YXRpYyBsb25nIHBtZW1fZGF4X2RpcmVjdF9hY2Nlc3Moc3Ry
dWN0IGRheF9kZXZpY2UgKmRheF9kZXYsDQoNCg0KPj4+IElzIHRoZSBJL08gZXhwZWN0ZWQgdG8g
YmUgcGVyZm9ybWVkDQo+Pj4gYXN5bmNocm9ub3VzbHk/DQo+PiBOb3QgbmVzc2VjYXJpbHkgaWYg
aXQgaXMgZmFzdCBlbm91Z2guLg0KPiBDbGVhciBhcyBtdWQuICA6KSBJdCdzIGEgbWVtY3B5IG9u
IHBvdGVudGlhbGx5ICJzbG93IiBtZW1vcnkuICBTbywgdGhlDQo+IGFtb3VudCBvZiB0aW1lIHNw
ZW50IGNvcHlpbmcgZGVwZW5kcyBvbiB0aGUgc3BlZWQgb2YgdGhlIGNwdSwgdGhlIG1lZGlhDQo+
IGFuZCB0aGUgc2l6ZSBvZiB0aGUgSS9PLiAgSSBkb24ndCBrbm93IG9mZi1oYW5kIHdoYXQgdGhl
IHVwcGVyIGJvdW5kDQo+IHdvdWxkIGJlIG9uIHRvZGF5J3MgcG1lbS4NCg0KQWJvdmUgc2NlbmFy
aW8gZGVwZW5kcyBvbiB0aGUgc3lzdGVtIGFuZCBJJ20gbm90IHN1cmUgaWYgd2UgY2FuIA0KZ2Vu
ZXJhbGl6ZSB0aGlzDQpmb3IgYWxsIHRoZSBkZXBsb3ltZW50cy4gSW4gY2FzZSB3ZSBlbmQgdXAg
Z2VuZXJhbGl6aW5nIGFib3ZlIHNjZW5hcmlvIA0KdGhlbiB3ZQ0KY2FuIGFsd2F5cyBhZGQgYSBt
b2RwYXJhbSB0byBkaXNhYmxlIG5vd2FpdCBzbyB1c2VyIGhhcyB0b3RhbCBjb250cm9sIA0Kd2hl
dGhlcg0KdG8gZW5hYmxlIG9yIGRpc2FibGUgdGhpcyBhbiBpbmNyZW1lbnRhbCBwYXRjaCAuLg0K
DQpGb3IgdGhlIGRlcGxveW1lbnRzIHRob3NlIGFyZSBub3Qgc3VmZmVyaW5nIGZyb20gdGhlICJt
ZW1wY3kgb24gcG90ZW50aWFsbHkNCnNsb3cgbWVtb3J5IiB0aGlzIHBhdGNoIHNob3dzIGNsZWFy
IHBlcmZvcm1hbmNlIHdpbiB3aXRoIGVuYWJsaW5nIE5PV0FJVA0KZm9yIGlvX3VyaW5nIC4uDQoN
Ci1jaw0KDQoNCg==
