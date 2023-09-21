Received: from esa14.fujitsucc.c3s2.iphmx.com (esa14.fujitsucc.c3s2.iphmx.com [68.232.156.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B5B625
	for <nvdimm@lists.linux.dev>; Thu, 21 Sep 2023 02:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1695265166; x=1726801166;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=3mOlLe30jV9m069Mt0Un+oD3AFN4epaQPZ65sD08C3U=;
  b=L/feImi9Z2MFEJhVuse4TKXf/e7fuib2OU4hIstVUnGe4ix5FYLmNiLb
   uEuLVqFLthY25WnFUS6yG5nqhCGiV933pFeMZ+6r8D7rFScM+dvHeXUCZ
   Z6lMhHXMVlKc4jozqUpvIfgoFWEY5RogKo1xeF48H49KQSMZH8qkkfv7A
   nurIv2RDT2L0YOflXJ3Cx2a4i5uosBzhate+HdpP7Hob0RJI2hfNrwd9x
   XGjICZqNvkr4/EMuDvSD22L7X9JNmGknRNt/zFkPf+B6NoJJCcgWO44+p
   OQLb4HgcCS8QfafhEQ3VGtSAAUOaYqHLxNZXCxo0IvOh58OKcXVB/cpRR
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10839"; a="95683924"
X-IronPort-AV: E=Sophos;i="6.03,164,1694703600"; 
   d="scan'208";a="95683924"
Received: from mail-os0jpn01lp2104.outbound.protection.outlook.com (HELO JPN01-OS0-obe.outbound.protection.outlook.com) ([104.47.23.104])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2023 11:58:11 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T/WrJBy6sCnpNcc/ykJNyWfOyWX7elAhkfYTfCTGhHyXBjEgwvSQJF4CpOJXlIUqTVMlhS47fFh4yjG2AUTcUTDB5tcHwkvyeByvoka5NEEaxBixy+M/Bn2Az1MjJUsMzM5NsfQbtrdPjKz3YZTioljIC2hb4th4aZ8Fk6xwEpAQtYxUQ4Ze2uR7KXMZEe5EG473C5Ab28wxHTuBK9p/Y8zKxLIx1ajsMJWH49IgP4LRcdM8/1NrXysWbEKY0VBd0Fhh3ous0pjIha5UK4bg2+eapf/OpX7Kyi6TAFd86XUSUngPkW9cBdQ1q3OmfSF78oCVhFKPDpU7aLAtkBY6qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3mOlLe30jV9m069Mt0Un+oD3AFN4epaQPZ65sD08C3U=;
 b=FrzME0CVLIa+O/zxvNEiTP14YySSb2KOvpW2odU54hTjEGmQt71k5StlQvGNUJtBmW0iJ6mNB9kofSVxLICNMLo1uNmIMSloNu+Hk5QY6DNI8erKCQrApwLAzlrITTOsMveqYCSpU91YxIbCs+feg2JHUm1+MShP7DVkgAavA9aQSZY4N42KF/0iRi6VIB7qbCM1+92aKfbi5ILSRvBsmzlHDTJSxzU2gsZiB0jaudWqtECrdFgYbMk06XLRyPmBuLWlzIkzun9rikpPSYzWdpcfojgCjZwMBoQewUV7WYLu7YJsbRYsENDLXsS2TPsP43wciSQGlty69Orrj29/vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from OS7PR01MB11664.jpnprd01.prod.outlook.com (2603:1096:604:247::6)
 by TYVPR01MB11263.jpnprd01.prod.outlook.com (2603:1096:400:365::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.20; Thu, 21 Sep
 2023 02:58:08 +0000
Received: from OS7PR01MB11664.jpnprd01.prod.outlook.com
 ([fe80::1a61:2227:a0de:2c53]) by OS7PR01MB11664.jpnprd01.prod.outlook.com
 ([fe80::1a61:2227:a0de:2c53%4]) with mapi id 15.20.6813.018; Thu, 21 Sep 2023
 02:58:08 +0000
From: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>
To: Dave Jiang <dave.jiang@intel.com>, "vishal.l.verma@intel.com"
	<vishal.l.verma@intel.com>
CC: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "Xiao Yang (Fujitsu)"
	<yangx.jy@fujitsu.com>, "Quanquan Cao (Fujitsu)" <caoqq@fujitsu.com>
Subject: Re: [NDCTL PATCH v2] cxl/region: Add -f option for disable-region
Thread-Topic: [NDCTL PATCH v2] cxl/region: Add -f option for disable-region
Thread-Index: AQHZ7BXszuLF52YeCUOYeLszqnUgI7AklrcA
Date: Thu, 21 Sep 2023 02:58:08 +0000
Message-ID: <a5f7fc5c-82a0-de3a-fe7d-f95e07e35ad8@fujitsu.com>
References: <169525064907.3085225.2583864429793298106.stgit@djiang5-mobl3>
In-Reply-To: <169525064907.3085225.2583864429793298106.stgit@djiang5-mobl3>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS7PR01MB11664:EE_|TYVPR01MB11263:EE_
x-ms-office365-filtering-correlation-id: 6c153007-9f4d-41cd-b869-08dbba4e958e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 yrqmj4/woZ9WixcF9xYbTQrmQabZdrWdffao1LtcVQ2ozK8m2Lq66ri3mc0iI3t1l/sWfoDywhV1bJKFhWRDtBpoRfsBF5k3WfZWTW6fJKDwsQCAm6ivS+Bm7/v6R0rZMaoKA0VDcsocEsgFTmJd5COPn9pvr28EvAuSw7gF+YIc8BfBXe5Hjo5o8RoNcP+1lk6/DaI4d8sZu9+5FuXLInFbO8zCnjBbSf+6ngzSwgp7KjjN/zQWMlAQe3bVsqomzKMgPTvnkvsLuMMuj4YK8W/6GSiIKv3Fl8P81XS86q2LHkLTobSW3x4HAXMZsMqiD7xTigV3mzIC2Ya/q5O8coFBox5VmV38jSraXLYFYfWGTnhkij9Be/18DRq6qqr4cDCxM11E25wNWft8G1juDQYYl9ueXXdEe4CIf3P6Ja0I7sSdg1W67pMwbUYbXf0aRtv910nJfu8qAkFzZnuETLJ0bW3/3aFOuVWJQ5T0KrNL/cjnhC0xvAtb7YXRK5pldToXVvaCJNMbJcYEM/SeTZxFqPfhLYTRvScmQszZWgVGsXUe1RcaO9kObAlk+3MffKGyJ9YNw9BG1yp941eWBaBiQOVP9a0bZPTZEjPEZMMs23+eUnESAEIilMldUNaJkf2QV9h+peRFGu9Xp4QaLfBMBTBGgcAtewPZC9VV76AaGK1GDCOVmPB6MMOab9celNR/WooOw7o5s/AvMY7SxQ==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS7PR01MB11664.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(396003)(136003)(376002)(39860400002)(186009)(1590799021)(451199024)(1800799009)(54906003)(316002)(76116006)(91956017)(110136005)(66556008)(66476007)(66446008)(1580799018)(64756008)(26005)(66946007)(36756003)(107886003)(2616005)(83380400001)(85182001)(122000001)(53546011)(6506007)(6512007)(6486002)(71200400001)(86362001)(82960400001)(31696002)(38100700002)(38070700005)(478600001)(2906002)(31686004)(4326008)(41300700001)(8676002)(8936002)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?M2ZOUW0waE1CMWpWb1BOSHE1ZGh0TmNMMlNZUUVvc2Y3cEZiRnNCenBXRTl0?=
 =?utf-8?B?VDhyc1Rpb2h3d25kRW1EaDFERTBkZVo0RDUvSlhFeTVnMk1QREtHSWRXenVP?=
 =?utf-8?B?bnNtUVNac3B1YlVWcklqbnVLcEN4R1VBbFVldXZyZVRDUnM2cVA2VWhWVmJp?=
 =?utf-8?B?VGJaZm13VUdEWnNFZ3ZRMUdLTXMyUDFsU2N4M0J2WG0rL2ZadWpxVTh5MEFH?=
 =?utf-8?B?OExLU3k2bnlWcVZ1MmtqTW16MCtMUityQ3E5b3FYTzdEamE0U20xM3A5SzNL?=
 =?utf-8?B?Q3dYdy8ySXFlY0M0NTVMTWxxWm84V04wQWVqQ0oxZ2hGYWQ4eDJqODl6eFNF?=
 =?utf-8?B?a2g5dFNhaDJld054YktmRjZnZXhmQ3J2c0JxRDdKZ2ZmeTJyTjNwVVdMQVdF?=
 =?utf-8?B?Qk1YcFZhUmpZWmVINUZxam9Qd3p1VXdMNW1UZlhoeEVGZUlQdkN0Q05oOVBz?=
 =?utf-8?B?Q1FadDI0S2xZTVhUbFdrdlNvdTk3ZllvUUtybVZ3alg0T3JxMEl5Y1hoZCtp?=
 =?utf-8?B?UXRqWWF3S1dONmtFdm90ZXhVenRtY0FFM0g4WlpwdTZxV0dEUHVjTHFsOHgy?=
 =?utf-8?B?NXFUUW5CV1Y3d0FvWGNPZWg1VkJ1SnlwTTRqdHM1bzhyWG1xU0VzZEhVeFFH?=
 =?utf-8?B?czJQamtpZVN2LzdJQzc1QURUekxiREtNeU11SWNrdWhCWUFKY0UyN0kyMUJX?=
 =?utf-8?B?M1BMaXMvNjFTY0VxcmNXWUxxQzdnNkxCUWI2bWEza2hoSVFNMmJCZzhpSE56?=
 =?utf-8?B?Q1l2a0s2MjUxYnpmMzViaG5tVEVuTTVZcEE2RnVMbXFoSlBGdllZOXJSWGsx?=
 =?utf-8?B?QnJETGxKT3E2OS9jWFoxOWRXc2s1eFEwWW9VbXJjYm1qWWhBTmNlSndpUnNB?=
 =?utf-8?B?ZGNiWmVIbkJ2Wk94V1htd1Y3U1o3Q01DR2hGbjFNMDBNNm5iaitjRjFQRlNa?=
 =?utf-8?B?djBpTVF0dmFaVmtiTy9GN1gvZ0RVQWY5c2NxSUJVWFFKU1VKVlphWU9TOHJ3?=
 =?utf-8?B?dmhYeEx3WHJFcy9nZVZQUU9WTDN3TWg2VmhCU0w0U3E5Y1FHeFMwR29FRWVz?=
 =?utf-8?B?VTZHblFVYU0xUElrNldaNm1RUnUrcFVMaUhNbW5ORHdYOTB1TzlUNHJXZ2wz?=
 =?utf-8?B?ZGZoZEMyNG9yV0gyV2tEZXNQUnVhb1cweXQ4WDZVK3hTWUQrc003ei9rNGRB?=
 =?utf-8?B?TjdXcUVpVlpPenluMy8rTW4zaVd4VGlVeERsMjJ4NXBaUElSREJDK0pISzd1?=
 =?utf-8?B?eUN4TWJONXBEYTl6ZEtleDhEUVpsaTZ3SDM3amtCQjNFN0RNNEo4UEtLZFY0?=
 =?utf-8?B?NnV3NmZWVXA4NUNiU3VVS0wvSHNqandDMDhVUTVjUFdBVTFBNVd4Vk5HREtl?=
 =?utf-8?B?UnV4ZTUxcitDS2Z2N3ZaTlJxZ2NjMkpUcFBqN3hkVFlQanhKY2o0K05jdyth?=
 =?utf-8?B?ZWtIZzVrUFhkUHYzRXVMVXY2WFVLNmVLYlA3cDZNTTNUa0N1ekJZTGZFV0do?=
 =?utf-8?B?bWpoUzk5VS9KOWx3NWZ4dXpTSHhjYS93L1k2RE5rTm5ad2VpZnRxblovRmpZ?=
 =?utf-8?B?Uzg4QldldkpkR0Q2bmxOWkgrVEVCdDNtSzZ2RmRnempnNS8rbzlmOG1peDlO?=
 =?utf-8?B?TXVhTEZjVVNRWXkreVNJUXZ1T09kS3pVaFRyUS9FeUZkaXIyVDA2YkVjYVBr?=
 =?utf-8?B?WW5nQXNFOXBDd3BhdmZEa2JJMHNyRGhOakIxVCtKOEY4Y1ZYcU9uY2JzYk1p?=
 =?utf-8?B?Q3FSbjB5b0djS2RCSjRhcnRvcmxoakw0bnFiUnloNGRKRk1EeFNJaHovTm5h?=
 =?utf-8?B?aGRPR3NsWEY2bnZ0NE54QkNzWFlhbXY2WFZxVHlUTzVESmhoK3lxZ0wwQXdt?=
 =?utf-8?B?R09haDF1dG8zT1hhbU4xem1YeXpNV0svS0JTQklWVzVGTWpFV2JERmp2ZE0y?=
 =?utf-8?B?RGJTeFJwb1lGdHJqdzRTRXZoQlFvLzVWTnB1aUo1NXAralJCTHd4cFlDbFdV?=
 =?utf-8?B?R3RrcFIxeWJEaXV6OUFjVXN2cW5vVHJyNjJTM3Y5NWVOY08wc3FkaWNLVWl4?=
 =?utf-8?B?L3hVY1JKUmhDaldBNlpaY0pleG1YcTZEK296ajVWVWczMXJta25QSmdLMjJj?=
 =?utf-8?B?bEtJajM2allmMGVDS2RRNEFRaXJJdXp0MzhFeVRhY2xJVm9OVk4xdDVzcG5l?=
 =?utf-8?B?eHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8D449E7906147B479FD15D5BA2D26863@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	B6cFzI/Ze+7CQIz3wD/LhjMlCV8x2z77QJ3YLotjUyA8j6qIQIc8roydV9pT79DXzRroV+TkSKEU2I2dc9KmXniiNfohRH7gAa059fKBikuV1Rk/GJDHbUrsNPQs3387D0gq/ad0vcmv5y8pikObgzPSipRkBCr9JRGZyzEwu219aSkKd4iPExQ+Yj0VVswopEYD14HY0r3kFz+23cgLN75qIWRN53fYPU1IQSxOX2Vz9DAKccxeLoYFSPHhO5XHXfqBx16Rj43Ft0E5vQgKrfcI4OkWHJmLNnbAEzMBgVGV0HtQKk3ZuzQa/a4P654V3/yDsGNlnYc/K9KhQiEM6NZUvyIp3ZVjqNOO/gW+3KVD336A+C+Qg/En3/Bv9zhrEqZRtrie1CkL8l16hoxdkUwq6CmkjkwvH/ABJOHhjLlDJSrWgdb3T8ZwEluLyj2sORl3E5zo+fiZxt6cCcDiDvoMrmac06y7THT0KqgTj7Icl4OTiKadUHiEw5TP+Wdc6Czv/4dFTnC7YuMSDG48ZMSiucIofvMCT04dSqAbs1PVw+hs4jyzx4psKSDprhdywZBqzDWuaNZGqdZi+pPsXgFtK5YmD2cpT1u2zLKSOalQI3E/XxzFcyZVNwsX9jqRv5S8VSfsV0Hr5bGSAkLEeMkgmyLNxGNa1cEKNBMKaiyMeDCJas6Wom2FIiX88cFU0gWLEbnElTq1XrYK9jtub99nIwMgQXyhackmBLMZjCT2LrpdZAwBEolCF7rF8UV5ZkeVoLMzs4xKWn6Hb76dxS2mb9sv/gHOq5/A04TiwuFcLH9SU9lPLH9xQVJoy8YasYoqj6j8tnNVieLH8WqADw==
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS7PR01MB11664.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c153007-9f4d-41cd-b869-08dbba4e958e
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Sep 2023 02:58:08.1881
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zLrZhV4TTE4zMBzQBjg1LxO6upR6HanYpN1tzY2EIqJTkMd99WR+uxaJhtEzGu98UzLRquIa2i/DdftSXU/5nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYVPR01MB11263

RGF2Ze+8jA0KDQpGb3JnaXZlIG1lIGZvciBub3QgaGF2aW5nIGEgbmV3IHRocmVhZCwgSSdkIGFz
ayBhIHBvc3NpYmxlIHJlbGV2YW50IHF1ZXN0aW9ucyBhYm91dCBkaXNhYmxlLW1lbWRldg0KV2Ug
bm90aWNlZCB0aGF0IG9ubHkgLWYgaXMgaW1wbGVtZW50ZWQgZm9yIGRpc2FibGUtbWVtZGV2LCBh
bmQgaXQgbGVmdCBhDQoiVE9ETzogYWN0dWFsbHkgZGV0ZWN0IHJhdGhlciB0aGFuIGFzc3VtZSBh
Y3RpdmUiIGluIGN4bC9tZW1kZXYuYy4NCg0KTXkgcXVlc3Rpb25zIGFyZToNCjEuIERvZXMgdGhl
ICphY3RpdmUqIGhlcmUgbWVhbiB0aGUgcmVnaW9uKHRoZSBtZW1kZXYgYmVsb25ncyB0bykgaXMg
YWN0aXZlID8NCjIuIElzIHRoZSB3aXRob3V0IGZvcmNlIG1ldGhvZCB1bmRlciBkZXZlbG9waW5n
ID8NCg0KTXkgY29sbGVhZ3VlcyhpbiBDQydzKSBhcmUgaW52ZXN0aWdhdGluZyBob3cgdG8gZ3Jh
Y2VmdWxseSBkaXNhYmxlLW1lbWRldg0KDQpUaGFua3MNClpoaWppYW4NCg0KT24gMjEvMDkvMjAy
MyAwNjo1NywgRGF2ZSBKaWFuZyB3cm90ZToNCj4gVGhlIGN1cnJlbnQgb3BlcmF0aW9uIGZvciBk
aXNhYmxlX3JlZ2lvbiBkb2VzIG5vdCBjaGVjayBpZiB0aGUgbWVtb3J5DQo+IGNvdmVyZWQgYnkg
YSByZWdpb24gaXMgb25saW5lIGJlZm9yZSBhdHRlbXB0aW5nIHRvIGRpc2FibGUgdGhlIGN4bCBy
ZWdpb24uDQo+IFByb3ZpZGUgYSAtZiBvcHRpb24gZm9yIHRoZSByZWdpb24gdG8gZm9yY2Ugb2Zm
bGluaW5nIG9mIGN1cnJlbnRseSBvbmxpbmUNCj4gbWVtb3J5IGJlZm9yZSBkaXNhYmxpbmcgdGhl
IHJlZ2lvbi4gQWxzbyBhZGQgYSBjaGVjayB0byBmYWlsIHRoZSBvcGVyYXRpb24NCj4gZW50aXJl
bHkgaWYgdGhlIG1lbW9yeSBpcyBub24tbW92YWJsZS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IERh
dmUgSmlhbmcgPGRhdmUuamlhbmdAaW50ZWwuY29tPg0KPiANCj4gLS0tDQo+IHYyOg0KPiAtIFVw
ZGF0ZSBkb2N1bWVudGF0aW9uIGFuZCBoZWxwIG91dHB1dC4gKFZpc2hhbCkNCj4gLS0tDQo+ICAg
RG9jdW1lbnRhdGlvbi9jeGwvY3hsLWRpc2FibGUtcmVnaW9uLnR4dCB8ICAgIDcgKysrKw0KPiAg
IGN4bC9yZWdpb24uYyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgIDQ5ICsrKysrKysr
KysrKysrKysrKysrKysrKysrKysrLQ0KPiAgIDIgZmlsZXMgY2hhbmdlZCwgNTUgaW5zZXJ0aW9u
cygrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vY3hs
L2N4bC1kaXNhYmxlLXJlZ2lvbi50eHQgYi9Eb2N1bWVudGF0aW9uL2N4bC9jeGwtZGlzYWJsZS1y
ZWdpb24udHh0DQo+IGluZGV4IDZhMzlhZWU2ZWE2OS4uOWI5OGQ0ZDg3NDVhIDEwMDY0NA0KPiAt
LS0gYS9Eb2N1bWVudGF0aW9uL2N4bC9jeGwtZGlzYWJsZS1yZWdpb24udHh0DQo+ICsrKyBiL0Rv
Y3VtZW50YXRpb24vY3hsL2N4bC1kaXNhYmxlLXJlZ2lvbi50eHQNCj4gQEAgLTI1LDYgKzI1LDEz
IEBAIE9QVElPTlMNCj4gICAtLS0tLS0tDQo+ICAgaW5jbHVkZTo6YnVzLW9wdGlvbi50eHRbXQ0K
PiAgIA0KPiArLWY6Og0KPiArLS1mb3JjZTo6DQo+ICsJQXR0ZW1wdCB0byBvZmZsaW5lIGFueSBt
ZW1vcnkgdGhhdCBoYXMgYmVlbiBob3QtYWRkZWQgaW50byB0aGUgc3lzdGVtDQo+ICsJdmlhIHRo
ZSBDWEwgcmVnaW9uIGJlZm9yZSBkaXNhYmxpbmcgdGhlIHJlZ2lvbi4gVGhpcyB3b24ndCBiZSBh
dHRlbXB0ZWQNCj4gKwlpZiB0aGUgbWVtb3J5IHdhcyBub3QgYWRkZWQgYXMgJ21vdmFibGUnLCBh
bmQgbWF5IHN0aWxsIGZhaWwgZXZlbiBpZiBpdA0KPiArCXdhcyBtb3ZhYmxlLg0KPiArDQo+ICAg
aW5jbHVkZTo6ZGVjb2Rlci1vcHRpb24udHh0W10NCj4gICANCj4gICBpbmNsdWRlOjpkZWJ1Zy1v
cHRpb24udHh0W10NCj4gZGlmZiAtLWdpdCBhL2N4bC9yZWdpb24uYyBiL2N4bC9yZWdpb24uYw0K
PiBpbmRleCBiY2Q3MDM5NTYyMDcuLmY4MzAzODY5NzI3YSAxMDA2NDQNCj4gLS0tIGEvY3hsL3Jl
Z2lvbi5jDQo+ICsrKyBiL2N4bC9yZWdpb24uYw0KPiBAQCAtMTQsNiArMTQsNyBAQA0KPiAgICNp
bmNsdWRlIDx1dGlsL3BhcnNlLW9wdGlvbnMuaD4NCj4gICAjaW5jbHVkZSA8Y2Nhbi9taW5tYXgv
bWlubWF4Lmg+DQo+ICAgI2luY2x1ZGUgPGNjYW4vc2hvcnRfdHlwZXMvc2hvcnRfdHlwZXMuaD4N
Cj4gKyNpbmNsdWRlIDxkYXhjdGwvbGliZGF4Y3RsLmg+DQo+ICAgDQo+ICAgI2luY2x1ZGUgImZp
bHRlci5oIg0KPiAgICNpbmNsdWRlICJqc29uLmgiDQo+IEBAIC05NSw2ICs5Niw4IEBAIHN0YXRp
YyBjb25zdCBzdHJ1Y3Qgb3B0aW9uIGVuYWJsZV9vcHRpb25zW10gPSB7DQo+ICAgDQo+ICAgc3Rh
dGljIGNvbnN0IHN0cnVjdCBvcHRpb24gZGlzYWJsZV9vcHRpb25zW10gPSB7DQo+ICAgCUJBU0Vf
T1BUSU9OUygpLA0KPiArCU9QVF9CT09MRUFOKCdmJywgImZvcmNlIiwgJnBhcmFtLmZvcmNlLA0K
PiArCQkgICAgImF0dGVtcHQgdG8gb2ZmbGluZSBtZW1vcnkgYmVmb3JlIGRpc2FibGluZyB0aGUg
cmVnaW9uIiksDQo+ICAgCU9QVF9FTkQoKSwNCj4gICB9Ow0KPiAgIA0KPiBAQCAtNzg5LDEzICs3
OTIsNTcgQEAgc3RhdGljIGludCBkZXN0cm95X3JlZ2lvbihzdHJ1Y3QgY3hsX3JlZ2lvbiAqcmVn
aW9uKQ0KPiAgIAlyZXR1cm4gY3hsX3JlZ2lvbl9kZWxldGUocmVnaW9uKTsNCj4gICB9DQo+ICAg
DQo+ICtzdGF0aWMgaW50IGRpc2FibGVfcmVnaW9uKHN0cnVjdCBjeGxfcmVnaW9uICpyZWdpb24p
DQo+ICt7DQo+ICsJY29uc3QgY2hhciAqZGV2bmFtZSA9IGN4bF9yZWdpb25fZ2V0X2Rldm5hbWUo
cmVnaW9uKTsNCj4gKwlzdHJ1Y3QgZGF4Y3RsX3JlZ2lvbiAqZGF4X3JlZ2lvbjsNCj4gKwlzdHJ1
Y3QgZGF4Y3RsX21lbW9yeSAqbWVtOw0KPiArCXN0cnVjdCBkYXhjdGxfZGV2ICpkZXY7DQo+ICsJ
aW50IHJjOw0KPiArDQo+ICsJZGF4X3JlZ2lvbiA9IGN4bF9yZWdpb25fZ2V0X2RheGN0bF9yZWdp
b24ocmVnaW9uKTsNCj4gKwlpZiAoIWRheF9yZWdpb24pDQo+ICsJCWdvdG8gb3V0Ow0KPiArDQo+
ICsJZGF4Y3RsX2Rldl9mb3JlYWNoKGRheF9yZWdpb24sIGRldikgew0KPiArCQltZW0gPSBkYXhj
dGxfZGV2X2dldF9tZW1vcnkoZGV2KTsNCj4gKwkJaWYgKCFtZW0pDQo+ICsJCQlyZXR1cm4gLUVO
WElPOw0KPiArDQo+ICsJCWlmIChkYXhjdGxfbWVtb3J5X29ubGluZV9ub19tb3ZhYmxlKG1lbSkp
IHsNCj4gKwkJCWxvZ19lcnIoJnJsLCAiJXM6IG1lbW9yeSB1bm1vdmFibGUgZm9yICVzXG4iLA0K
PiArCQkJCQlkZXZuYW1lLA0KPiArCQkJCQlkYXhjdGxfZGV2X2dldF9kZXZuYW1lKGRldikpOw0K
PiArCQkJcmV0dXJuIC1FUEVSTTsNCj4gKwkJfQ0KPiArDQo+ICsJCS8qDQo+ICsJCSAqIElmIG1l
bW9yeSBpcyBzdGlsbCBvbmxpbmUgYW5kIHVzZXIgd2FudHMgdG8gZm9yY2UgaXQsIGF0dGVtcHQN
Cj4gKwkJICogdG8gb2ZmbGluZSBpdC4NCj4gKwkJICovDQo+ICsJCWlmIChkYXhjdGxfbWVtb3J5
X2lzX29ubGluZShtZW0pICYmIHBhcmFtLmZvcmNlKSB7DQo+ICsJCQlyYyA9IGRheGN0bF9tZW1v
cnlfb2ZmbGluZShtZW0pOw0KPiArCQkJaWYgKHJjKSB7DQo+ICsJCQkJbG9nX2VycigmcmwsICIl
czogdW5hYmxlIHRvIG9mZmxpbmUgJXM6ICVzXG4iLA0KPiArCQkJCQlkZXZuYW1lLA0KPiArCQkJ
CQlkYXhjdGxfZGV2X2dldF9kZXZuYW1lKGRldiksDQo+ICsJCQkJCXN0cmVycm9yKGFicyhyYykp
KTsNCj4gKwkJCQlyZXR1cm4gcmM7DQo+ICsJCQl9DQo+ICsJCX0NCj4gKwl9DQo+ICsNCj4gK291
dDoNCj4gKwlyZXR1cm4gY3hsX3JlZ2lvbl9kaXNhYmxlKHJlZ2lvbik7DQo+ICt9DQo+ICsNCj4g
ICBzdGF0aWMgaW50IGRvX3JlZ2lvbl94YWJsZShzdHJ1Y3QgY3hsX3JlZ2lvbiAqcmVnaW9uLCBl
bnVtIHJlZ2lvbl9hY3Rpb25zIGFjdGlvbikNCj4gICB7DQo+ICAgCXN3aXRjaCAoYWN0aW9uKSB7
DQo+ICAgCWNhc2UgQUNUSU9OX0VOQUJMRToNCj4gICAJCXJldHVybiBjeGxfcmVnaW9uX2VuYWJs
ZShyZWdpb24pOw0KPiAgIAljYXNlIEFDVElPTl9ESVNBQkxFOg0KPiAtCQlyZXR1cm4gY3hsX3Jl
Z2lvbl9kaXNhYmxlKHJlZ2lvbik7DQo+ICsJCXJldHVybiBkaXNhYmxlX3JlZ2lvbihyZWdpb24p
Ow0KPiAgIAljYXNlIEFDVElPTl9ERVNUUk9ZOg0KPiAgIAkJcmV0dXJuIGRlc3Ryb3lfcmVnaW9u
KHJlZ2lvbik7DQo+ICAgCWRlZmF1bHQ6DQo+IA0KPiA=
