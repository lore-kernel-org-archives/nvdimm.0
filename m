Received: from esa12.fujitsucc.c3s2.iphmx.com (esa12.fujitsucc.c3s2.iphmx.com [216.71.156.125])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 300EA31A71
	for <nvdimm@lists.linux.dev>; Thu,  7 Dec 2023 09:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="O+r8y5y7"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1701940115; x=1733476115;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=frhWi2Rw2nndWunqSE85Xu0zZP6ryUG0yQ0vPiGlq2U=;
  b=O+r8y5y7k0Sqr0YcwKANmgUVxp+lvE88qp++LWAlDD5l9A2euJwVLXTP
   G4vOnUBsKL3qlzCXeNHfjEhnwrrD9fNf3xXJeVjLbdipKyYHA3xgIW0Ta
   flYZpEndjdiOf0KEa7f+b9SUejf8o0pi4ZPny5juNqbINOSnlkux1rbhx
   Zy8Yw+aTDwCByj6HlKmPH13qxQQYKHXffZEZeoDnorCjVMyCxb0SvO61K
   W1Bvi6JT3IAEf3CWBnNQjdZ9i0szHagbRpgy6q7ppoeb05F8Qn1EdD5dX
   NGxAxtpySgRlnT9Yyjl0yEGf9tFxyhO1MQKu/N4YQ0zsPG5xDhHHQInBF
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10916"; a="105144840"
X-IronPort-AV: E=Sophos;i="6.04,256,1695654000"; 
   d="scan'208";a="105144840"
Received: from mail-os0jpn01lp2104.outbound.protection.outlook.com (HELO JPN01-OS0-obe.outbound.protection.outlook.com) ([104.47.23.104])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2023 18:07:06 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VThX4u+GY6MRaOU6TtrWkTAMv71PXXFPKz00o657DXaqnmBmtVONXkQRNvHGYYWU3dVuEKAHjC3fHOLupIoKHqyopI2nKpW5M4vCaRe04tbFXmpd5Uk/2FoBNngBL8xx+bGipbwL4m4mHmshkgoKBGHlsoRQYt4S8joa1FZJA4AdtfAtSa3ql8m2zVa5YXwi8tvmkjmffjAmM7LW2xhxTE2tdAHBzk3oNjvd/8DJe5CxOykWMO49F/PLgp4Gz+7c9LoqHlTRvaVWk0an2DlzN1g2AU9J/ChfRYl/zROS8coqW7YhBaVgnaaPPUuLPvnYCXcvYoy7BhjieCTG9vAX/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=frhWi2Rw2nndWunqSE85Xu0zZP6ryUG0yQ0vPiGlq2U=;
 b=nb2C1isFm6Tqq4R/Iyv2i5zyzZQmrbM+fDGyHn2XXL4xa34RpTz9QdO7e3TlLUiXxfZpEEQVGlJYn4MJ9/XOku1ovjl0gRaieHrS2XnXrS6psmMTt/XAdwCTD7apRp7Qb3BhuEzVeOQxufxCKiXoB+l0ACvLU7vfWAv0bM6U65ZZQpUctgsFyoD4SPnbmtyq/LtbAPqcBu3EoeazX/sMsizHgY0HCQDz/d1rS7CuGDalhIvAtda8Q2wAcNG8u/G94QdYJFW91tNsqjKvovO34IcH9CHUR/I81WkJ83y0V6+v+2Jr5Z8vEo1VIH+pEVvpXw1BJMwBYGJDNmKSPD3hzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from OS0PR01MB5442.jpnprd01.prod.outlook.com (2603:1096:604:a6::10)
 by TYCPR01MB11510.jpnprd01.prod.outlook.com (2603:1096:400:37e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.11; Thu, 7 Dec
 2023 09:07:03 +0000
Received: from OS0PR01MB5442.jpnprd01.prod.outlook.com
 ([fe80::c96f:52b0:dd4e:8d50]) by OS0PR01MB5442.jpnprd01.prod.outlook.com
 ([fe80::c96f:52b0:dd4e:8d50%6]) with mapi id 15.20.7046.034; Thu, 7 Dec 2023
 09:07:03 +0000
From: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>
To: Dan Williams <dan.j.williams@intel.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
CC: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH 3/3] test/cxl-region-sysfs.sh: Fix
 cxl-region-sysfs.sh: line 107: [: missing `]'
Thread-Topic: [ndctl PATCH 3/3] test/cxl-region-sysfs.sh: Fix
 cxl-region-sysfs.sh: line 107: [: missing `]'
Thread-Index: AQHaHbUkHGDP6kg2bkaHk00k5icJ+rCc3YWAgADAjAA=
Date: Thu, 7 Dec 2023 09:07:03 +0000
Message-ID: <5d6c09b9-d041-4c6c-b338-f1b4657bfbe9@fujitsu.com>
References: <20231123023058.2963551-1-lizhijian@fujitsu.com>
 <20231123023058.2963551-3-lizhijian@fujitsu.com>
 <6570e9b1524e8_45e0129469@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <6570e9b1524e8_45e0129469@dwillia2-xfh.jf.intel.com.notmuch>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS0PR01MB5442:EE_|TYCPR01MB11510:EE_
x-ms-office365-filtering-correlation-id: da3e6a2f-3e53-4136-3806-08dbf703e115
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 hxVMD1EBkD3VLfmkK46fo4FB9+j5ES/YmPvxIiKRTccL14aiEFS1cq5KeB639P6taBrfPTtQ4wPFgUBM6e2K2U4Y8Au+QJ1DWu+ctE6YpUZw4A03/LDCH0+vDvhRn0wmD2/97KfovBBg3ocoA6Lsj5kCrYoxSdurzBtrmT1I9jr0GW6olCg6Ed/P/5j73RU15uMhy7HFdFPULoZkFJcu5hVlxrJ+1EspqcNLYj6e9wM/zYtrsP76A75jFfvmWXJFt53ZmBbqLAydpllGDHWrGvCO8JEpXuVNfGyC8dB2ln/60utvEwHdT0OO64LvF0PUHp0Klx77SaJCJ4kIxBoZOYb24dTHf5yv12Wfav93b6SP8OFBa8MtvBPsUcDHt6hjxAq9NzvptQZDGcQiFmKnwj4HFPtjYNFSqYdVOJryt0r8neHZ7ie0TnLKDKlvK8vmz7NTBlMN+g++ZdjwKseNPoBU0pNchur37wf/s754fPv6iaTR6cLS5XLSZxaoRVsBHPsIRsjnZyHcJbgmsXV0+hzqD6tV0FQ/TfXIxHnTGYy27yOg7bZAUc6Vwml6eEL/fQRaF2It7aoE+2YxCU+yLLdC0EkG6k3+CK0xbnnI8cNVZP1dZ4GHpwzXMJsqvrm/oBJnjvxxt1yaE8xFn/UOOFyhsTvsZZT/MegXYPQsm83fbm6FwAr2618dBpuh9t7aqd/4kADNYwCC+RgNxXJj16CwDCUHZbwLCOaeimHsV6MRfY26Rhlv6L3AdsftrNWr
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5442.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(346002)(136003)(376002)(39860400002)(230922051799003)(1590799021)(64100799003)(451199024)(1800799012)(186009)(1580799018)(110136005)(316002)(91956017)(66946007)(66556008)(76116006)(64756008)(66476007)(66446008)(6506007)(53546011)(6512007)(26005)(41300700001)(85182001)(71200400001)(36756003)(2616005)(478600001)(6486002)(38100700002)(122000001)(31696002)(86362001)(82960400001)(83380400001)(38070700009)(2906002)(31686004)(5660300002)(66899024)(4326008)(8676002)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dUl5S1AxV09Cc3F1N21TZlR3L21mRVU5L2tpL2M3WDh4RzhwaXBkbXloMHF1?=
 =?utf-8?B?WjE1ZFUyOWNmdmxmMjNReHdweFJva2xLZklhQk5BTVdIdThrZHF3Vk1hNHVY?=
 =?utf-8?B?RENqV3BTS1VLSU5Ecjg5UUNkWFE3TTlIUU9PQjRXbzNhT3ZHNGRVOFdGUkR5?=
 =?utf-8?B?SHlxcWRCYU5OUEhBZDlKTjRsL0VEa0k5MEMvQ0wrVWN6dGZlbmhoSDlqazBH?=
 =?utf-8?B?cC9vbmZaNEJZREdrRUErN3lRVklhY1RTNWtNdWJaN3VaOC9tY20xZ1BoeEtF?=
 =?utf-8?B?ZmQyVzYyYUsxZkVYMzI2ai9xQzZPOHZqY3lIRWdrRGZ0Z21TZVpyV0M3aE5F?=
 =?utf-8?B?djNDTmU1OEZvVjBwcyt0ZDNnY011d0xKdGNWeVRCQk04akhUaHBjcEovTkRJ?=
 =?utf-8?B?WmZqOGtRN2JWWThBMk1uOVVZSnF4MEQ4Yjd0bTRRZUd0Z0Fna1RaL0FhbUlH?=
 =?utf-8?B?bTlyZXhXZHFtU0g3dFY1b3ZUWnIrbEoyYnA1dXV0Q3Z2QytBMkhFZkg5MU9v?=
 =?utf-8?B?bDE4UFlkei9ncGZiSVNkZXgySkFMZnMrTml3UG5lOURQTGdPSHlxUHBKUmV0?=
 =?utf-8?B?SmczS1BoWWYrVkFpUTd3SkdXcFJzR2dSendXbEt4bWFDYU1mbFBqNTJRSHNl?=
 =?utf-8?B?QnRsenhBdnFiU1l0UWdhaUNhREZkdmhDUDMweWhwYnpWdStvbGNkblZZcDZt?=
 =?utf-8?B?Q25OME55UE1pRDZRN0pRb2Z1VGcxenR5RWI2Q0NtY3N2OGhNU2VLa3U2dC8z?=
 =?utf-8?B?eG5IZ29XQzJlTnhpOUEreWxvSTZKdmZUemx5SVRPajYvSWp6c1RJc2R3Y0pX?=
 =?utf-8?B?YWh0R0JPK2V3Wm5TRUlhMGQyZ1c2dE5QTW43Ky9yWnRWcFhjNHR3TGk0UmpQ?=
 =?utf-8?B?OCtHbzlEWjhXOEJnYTdiSXMvcHQ5VVduRi9kMWNpVGVhbDhtV2JoL1NkaWpa?=
 =?utf-8?B?aWxORzdjbFF2RzVYTnM4WEtNaW45ZnZVdE4xNjhDaDlUSjIzMGtTcXFFcXZX?=
 =?utf-8?B?THpHeVE3bGo0NW82ajNCdEh2TFF3cy9oaENyL3FrZkVKVm15K2NOQXhLOXdC?=
 =?utf-8?B?azJLUndGejIyV1JwS2VzOHZoTDI1R0VhQmxMZVpOc0xCYzJCQVdNVVlWYVRu?=
 =?utf-8?B?MEI0Z2tIUmJ1eU5lQ3N6c0tYTlU4YXdHSERjQmtXd2IrMDhFZ2toU0ZWNDlY?=
 =?utf-8?B?eUMrUW92RVIvV2RYSk8zcjZyOTUzYTlscldmbklsbUJsTlpMVGpwU0hVcG55?=
 =?utf-8?B?SWkwd3E5NmRtMmJSb0FqSERCbDRTZ3ZBaTMzcENuRHo2T3FwU2p2aVIvczBO?=
 =?utf-8?B?RFJGT0EvZUhpQnBUSUk2SmFVMFh2dHE2bTh2YzlGdGlWSFNvbW5LWVNDUS9G?=
 =?utf-8?B?R1ovNFVJcWpMVDRkZEtEb1FPTGtCbVlyWUZkc2s5RDBnd2xBclBGYjF4Lzk2?=
 =?utf-8?B?MmIrQ3U2cDY1U1VQV2I3b240YmFpblI4RFFMTitKeGR2aDc1WlBMc1E4dysr?=
 =?utf-8?B?MVhvNVc3N2hZdm1HdVhObTRwNU5GbkZ2SzlJR2FhdmQ1YnlIU3NtNnQrbGhS?=
 =?utf-8?B?MTZKTUZkRUxCT0lkMnIrRmZqaHEwMEV0UmtRbVcrYi8vWm1MYXpGYU5oNm9Q?=
 =?utf-8?B?ay9QRDZ2VTE5UW9IQVJPblU3SjRHNDROSGgxdUtRemlZaU9WVHVROVJ6UWZv?=
 =?utf-8?B?clFkQ2ZMbXJtemJNVzdldXo2R2pEUmdzbTJNTjNJbzl3MnJvVVFGMDNoZUlM?=
 =?utf-8?B?T09Eek5XRncvbUxpcXpYbC9qWXQySCttN1UvYW03NDh2TlpRWHdwQ0FvWUV3?=
 =?utf-8?B?MDQwaFRLRVJTNHZCWCtPaUpDU3p1ckIzKzRLVm9TdjJxTk9oemU5WDNPSXVI?=
 =?utf-8?B?d2paRDM3YS9wRjUvOTVreGEwWjQ2L05SMnpWLzk3UWNHUWZDdk1GcVpXdUth?=
 =?utf-8?B?YkJlaDRoNlZqekxIbVdEcjBHdU9PcWxWOGxnenpjYUVlMFZkazJwaFdYZzlt?=
 =?utf-8?B?aEhjV2t4dmp3eG56SVVKRjlWcnRGUHRyMmZCY1BEWHJSNU5sY0ExdlBsSDhB?=
 =?utf-8?B?VDdTOXdta0pnQU9WMXd5NmFjc2tJMC9KY083U0hmN1FRTHU4ZzdvVWZlNndI?=
 =?utf-8?B?eGthU0gvbmxBdU1TVUI4NE1MTEh0SHgvamE4UnAvUElZdXVSWW0zVnE3bTQ3?=
 =?utf-8?B?bGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <32A2BD8C780AE84298A8F5CAB30C18EE@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	s80x4kKBYOicbePDgaLE7XPBXrMzokogkl8u4GFB+gvJiFWjs3KE/EFJ5LCwV3pniSHkyogugDalz+sd3FC4IXnKXLRzaR79PCxh0Hmt+HVRuRAQ70tBw4m/O9rD3WP33+BRjJ2Y6/EM84U4U6dZHaT1hUzG+M7iM2zYTmjyX9miVFVIy4qcA9I5RLJk4D1hzRkRVeeCr7rhTL6NgU5+JZXR2oaziWmp890dhhxHVkF8KsKlbdp5xJiFwWqWuePGPvjlNzSn/wnMvahwVdlGxaPa6WlrGn9hXg5hlwM1zEDIK9y4NhYAO597yRhg0PqfbFTr0eEJ/8zmqQMWAiJKUmrKjPzGG7UBf7xYwWF5g1TSMNeidwlCl4DGcNkzWUo1Hg9qtqHZgIJYcRoYT72ASyXKI2oiRmXoxTxZRG2PlVMIBRKLSGweKTk2z4fWnt5lyjezKwfUI/cSzyg1A+y8rhdKNMxQnivM8pvihYHMTuk5lBhXKR8zDBnKGsjufo771H07+KdCa2nJS64QqFnEAKWNR6RZC3st5vFD/0XfksXyCVU8G/7/Xr/BUHZ7ooGe0PnHxw5VNH9P0VqoQtsFVRyIMKp2e2IBI3LeRg6A9I2OI0PCDZkM7HN4dAgfq/RF
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5442.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da3e6a2f-3e53-4136-3806-08dbf703e115
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2023 09:07:03.5741
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g+rB8rvBg4p+Q/u3gzyfVIwVY0r3hcSdaJDmBnbaMqUqdyd1IPjjhMQjTnizbp2Of/vc64fq0AIAfdSlOV52jA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB11510

DQoNCk9uIDA3LzEyLzIwMjMgMDU6MzcsIERhbiBXaWxsaWFtcyB3cm90ZToNCj4gTGkgWmhpamlh
biB3cm90ZToNCj4+IFNpZ25lZC1vZmYtYnk6IExpIFpoaWppYW4gPGxpemhpamlhbkBmdWppdHN1
LmNvbT4NCj4gDQo+IFBsZWFzZSBubyBwYXRjaGVzIHdpdGggZW1wdHkgY2hhbmdlbG9ncy4gQ29t
bWVudGFyeSBvbiB0aGUgaW1wYWN0IG9mIHRoZQ0KPiBjaGFuZ2UgaXMgYWx3YXlzIHdlbGNvbWUu
DQo+IA0KPiBPdGhlcndpc2UgY2hhbmdlIGxvb2tzIGdvb2QgdG8gbWUsIGFuZCBJIHdvbmRlciB3
aHkgdGhpcyBlcnJvciBpcyBvbmx5DQo+IHRyaWdnZXJpbmcgbm93Pw0KDQoNCkkgaGF2ZSB0byBz
YXkgY3VycmVudCBjb25kaXRpb24gY2hlY2tpbmcgMSkgZWFzaWx5IGhpZGVzICpCVUcqDQoxKSBb
IGEgLW5lIGIgXSAmJiBlY2hvIE5HDQoNCkluc3RlYWQsIDIpIGFzIGJlbG93IGFyZSBtb3JlIHJl
bGlhYmxlLg0KMikgWyBhIC1lcSBiIF0gfHwgZWNobyBORw0KDQoNCg0KPiANCj4gQWNrZWQtYnk6
IERhbiBXaWxsaWFtcyA8ZGFuLmoud2lsbGlhbXNAaW50ZWwuY29tPg0KPiANCj4+IC0tLQ0KPj4g
ICB0ZXN0L2N4bC1yZWdpb24tc3lzZnMuc2ggfCAyICstDQo+PiAgIDEgZmlsZSBjaGFuZ2VkLCAx
IGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPj4NCj4+IGRpZmYgLS1naXQgYS90ZXN0L2N4
bC1yZWdpb24tc3lzZnMuc2ggYi90ZXN0L2N4bC1yZWdpb24tc3lzZnMuc2gNCj4+IGluZGV4IDg5
ZjIxYTMuLjM4NzgzNTEgMTAwNjQ0DQo+PiAtLS0gYS90ZXN0L2N4bC1yZWdpb24tc3lzZnMuc2gN
Cj4+ICsrKyBiL3Rlc3QvY3hsLXJlZ2lvbi1zeXNmcy5zaA0KPj4gQEAgLTEwNCw3ICsxMDQsNyBA
QCBkbw0KPj4gICAJaXc9JChjYXQgL3N5cy9idXMvY3hsL2RldmljZXMvJGkvaW50ZXJsZWF2ZV93
YXlzKQ0KPj4gICAJaWc9JChjYXQgL3N5cy9idXMvY3hsL2RldmljZXMvJGkvaW50ZXJsZWF2ZV9n
cmFudWxhcml0eSkNCj4+ICAgCVsgJGl3IC1uZSAkbnJfdGFyZ2V0cyBdICYmIGVyciAiJExJTkVO
TzogZGVjb2RlcjogJGkgaXc6ICRpdyB0YXJnZXRzOiAkbnJfdGFyZ2V0cyINCj4+IC0JWyAkaWcg
LW5lICRyX2lnXSAmJiBlcnIgIiRMSU5FTk86IGRlY29kZXI6ICRpIGlnOiAkaWcgcm9vdCBpZzog
JHJfaWciDQo+PiArCVsgJGlnIC1uZSAkcl9pZyBdICYmIGVyciAiJExJTkVOTzogZGVjb2Rlcjog
JGkgaWc6ICRpZyByb290IGlnOiAkcl9pZyINCj4+ICAgDQo+PiAgIAlzej0kKGNhdCAvc3lzL2J1
cy9jeGwvZGV2aWNlcy8kaS9zaXplKQ0KPj4gICAJcmVzPSQoY2F0IC9zeXMvYnVzL2N4bC9kZXZp
Y2VzLyRpL3N0YXJ0KQ0KPj4gLS0gDQo+PiAyLjQxLjANCj4+DQo+Pg0KPiANCj4g
