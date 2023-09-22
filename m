Received: from esa3.fujitsucc.c3s2.iphmx.com (esa3.fujitsucc.c3s2.iphmx.com [68.232.151.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0483E377
	for <nvdimm@lists.linux.dev>; Fri, 22 Sep 2023 01:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1695346048; x=1726882048;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=CmCtlp+DK2mSXjjjCNXMNNjmDwlfCCOXGB4VkqQWkAk=;
  b=PnyeX9flUtxJf535cK6ehaBTbdcQJ30dA7aPictts28FMfWqd+e2wQlU
   O5uDtUppw3lAlutj15uk9DiohJdAzYXAH7xMyzoNRXrNCgYSiop0tFno8
   IwqhjGEto4T2IUff0jQ0e3ym1obtsMcOQ7U3RH3iuywK8Eu1C3dsQMox6
   B0zpEyD9/9vJ8BGRxIeX3fBfdBj0P4Z4rOGfwVY0g7kvKg2cL4hkQDBQP
   itrTWxh96ij5LuS7ZIGxAOOxSgM9kOp0xpiMIKEOiMAa2hKLwDRWejD6o
   1ilIfjcZy738Gcs2Cz8MA4K3Bs3EfIWi6THR2icfu9MeSmjdmXdYQ1PyU
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10840"; a="7278844"
X-IronPort-AV: E=Sophos;i="6.03,167,1694703600"; 
   d="scan'208";a="7278844"
Received: from mail-os0jpn01lp2112.outbound.protection.outlook.com (HELO JPN01-OS0-obe.outbound.protection.outlook.com) ([104.47.23.112])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2023 10:26:15 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FBASSuWPCViAblum+XJ4ozrAcVua6afO4SHWENU1jv1Vas84B8JTVCXhdq+Xus+K9EHQphYwgU9RhwoU2GbYz0Qd8XO2AycZctpubxEp+TqXB5+nnhpgihq8e+og1q09F63aZiTqzmrESBi62HGFuSUl0gpoP9MdFW8hwVjC8DjZ0CBMIrXFlY/eI4y5RGPHnp0iwzVtdULZHG5MMcGAylinLZCc18UVlF2Qvjp/Ta/ApXSEdUP1uT6qWjBGwM06uCV33mU+SDJFkdsFMW5KsT69DeuSUPbVPRCko6H8eSc5uSWGRDzfn6D/EkTYszCWSt02wJnk3iPWOPx8s4gS5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CmCtlp+DK2mSXjjjCNXMNNjmDwlfCCOXGB4VkqQWkAk=;
 b=HC96YccJSURfaKMan0VfDLmtgUArVNUK1hn0Qi4j/fOUTC4DMQLy//D9h0HCyhYrvFdxOD0VhNWMssyCVkCPofNajLe/RAYcTWYSBwdBxyVHfHuhCbMWTfQ1Lc0h76llVMt6J4Uo+t/ZAH088JHkjJ8jrcKV2GMMlEK+XE4Gedd4ho7S5Eq0dSWtnk2gXDCyxomF+vFoCjEoq1bwTiMdBqawjkD01f/S54Q26U5POh4gRuv00p0X5/uehdVZPUqgWsxt9LQJJBMDjpWFJz/2Lmcr0XRTdnL4Lx/wLDPVLxuhmoFUXmOyhVv82bzxiPfeYV1SmWfBBFyhuFSK9JU/QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from OS7PR01MB11664.jpnprd01.prod.outlook.com (2603:1096:604:247::6)
 by TYCPR01MB11708.jpnprd01.prod.outlook.com (2603:1096:400:388::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.23; Fri, 22 Sep
 2023 01:26:12 +0000
Received: from OS7PR01MB11664.jpnprd01.prod.outlook.com
 ([fe80::1a61:2227:a0de:2c53]) by OS7PR01MB11664.jpnprd01.prod.outlook.com
 ([fe80::1a61:2227:a0de:2c53%4]) with mapi id 15.20.6813.017; Fri, 22 Sep 2023
 01:26:12 +0000
From: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>
To: Dave Jiang <dave.jiang@intel.com>, "vishal.l.verma@intel.com"
	<vishal.l.verma@intel.com>
CC: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "Xiao Yang (Fujitsu)"
	<yangx.jy@fujitsu.com>, "Quanquan Cao (Fujitsu)" <caoqq@fujitsu.com>
Subject: Re: [NDCTL PATCH v2] cxl/region: Add -f option for disable-region
Thread-Topic: [NDCTL PATCH v2] cxl/region: Add -f option for disable-region
Thread-Index: AQHZ7BXszuLF52YeCUOYeLszqnUgI7AklrcAgAFVVQCAACNPgA==
Date: Fri, 22 Sep 2023 01:26:11 +0000
Message-ID: <37dc1c06-8f3e-2f24-2ac5-93adf93a5b1c@fujitsu.com>
References: <169525064907.3085225.2583864429793298106.stgit@djiang5-mobl3>
 <a5f7fc5c-82a0-de3a-fe7d-f95e07e35ad8@fujitsu.com>
 <11b727a2-0f86-64f9-cafb-a08e7e60bd39@intel.com>
In-Reply-To: <11b727a2-0f86-64f9-cafb-a08e7e60bd39@intel.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS7PR01MB11664:EE_|TYCPR01MB11708:EE_
x-ms-office365-filtering-correlation-id: 789f703e-627f-437f-3474-08dbbb0ae84e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 5IpuAVXGyNOIloEX05VduObu8a3egQqie7ZMgGZ4pmQqVpNcy2fvU/HjNfZT7Fjnd79a+Pt6kSoqYZSnsv3Rm8ylOS6arDGkNbnYOCSMTKt9lKiwPqetxykrxDgSxZ5nwVDf7UujzNjPkJ0qr05FWE/ZCegHAY0/BwF0LqbT2k92y81FqE8m/LW700thK52SQuWg1gxsBZ5rKVr3zdIxmdpEwhmzHwoJgLzOAACCgam7CNR0xkkM3FfX0w0WqviFi/+NbWcNKn5Tu9BdeuR23g09pGyKIKksgc8uer+IE6vwNjPT9rTgLbD8QjJcb8JVBDXofqSv9LWNc9P8l/wL8aG/nW0TI48IymLdMSdp/qhoqndTpwVtiIVwkgeH2Fsr8UBpxEirYNeNe+Zymdapsbi/HMRqLhuDc6suSwHm/tT1mf8tc0Ova8aWYOfgyCjNtGS4TB/oC2+e8RFhL94r2WMklaMkiVvgaiCKn45DLXOjfjeWZEJC13qd3V/WvRfRRWk7k2i5w+rE7SizdkjfJ61/Ki60dSfqrmd+gpuTDED9s8v/R5JlVwpMYKo/4aeyvgWyidwwS93v/c6advnJBcJ6cH8bS0Vc/klAJg/t23FuOE1FzN4ti94dkcgAYqMFLmItOUWt2CQIq2AdKS7Kw4FpeQ0yRUwfL+FIDg919S12+0EhTgOdQz59WeSB/fwlrhtNmbT9PgeIgHcxCQGI6A==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS7PR01MB11664.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(346002)(376002)(136003)(396003)(1590799021)(1800799009)(186009)(451199024)(122000001)(6512007)(53546011)(82960400001)(6486002)(6506007)(1580799018)(26005)(71200400001)(2616005)(107886003)(36756003)(41300700001)(85182001)(316002)(64756008)(54906003)(76116006)(66946007)(66556008)(66476007)(66446008)(110136005)(91956017)(2906002)(86362001)(31696002)(8936002)(31686004)(8676002)(5660300002)(4326008)(38100700002)(38070700005)(478600001)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?alBiaHdTbk9pMkkxbHFkcGgwSVlpdlZybUs1US9KNHVKbDBOcGgxOTI1djJJ?=
 =?utf-8?B?NGdJM2FSK0ZWYTVVNmZHb3hkWUt1N2t5VjArR2xlL1FqVHhtS1lvSldVaHg3?=
 =?utf-8?B?UVdSOXJ4NE00elF2UlViUk5JWGEyWjhwTEo5OTM3KytoSE1CNUFSUkpDVXNk?=
 =?utf-8?B?Q3BxVzIyYkdZYUxBVlhOVEcyM0pNcEM5QS9McFhpR1ZldVA0TmdaL1IybVVN?=
 =?utf-8?B?bXFPdEc4ZWxONnlTREd6QzMvbjlldlJ2Ri9vTUpqa3YzU2Y0ck10c3p1WVUw?=
 =?utf-8?B?UHdTdHZ5NS95cEl3Zy9sczVVdXJMbTdKY3Q3bmo5Tis0dVRQL3Ywc0dsbEY5?=
 =?utf-8?B?clpXdTJvdGFsd01Da05FZEFBTFIyS01vQzZhU0hNQy9BTE12NForNEt1VndQ?=
 =?utf-8?B?K0FlYTZZdnpCajBTWFdCMU05c1FubXNJMFExait0WlVSM2xuZi9lZWdNL3I4?=
 =?utf-8?B?N29LdHUzQ3ZLcExGcW1iZkc0MUk2RU9IZDN5VDFxYmU0N0JCaTl4QWErcVlz?=
 =?utf-8?B?MzVxZi9PQVVIYzh0NW9SdlJ4Z1ZsUFRqRllXRG9qdi9OOFhDWU83ZVIydytj?=
 =?utf-8?B?UmVvNzRGNWFndWh1L29KejYzWFJ4MGcrVnhVQzFPcDB2OE8xbGR4d2Z2M2g5?=
 =?utf-8?B?dmg4MlVzdGFYZWdYSmpBWEhmVTdVWTVpaFhpeDVlRmMxRzFhWFFyN2RKSmxM?=
 =?utf-8?B?aE5EWlg4NWVxZWpBaHh4Qm1QSzArZldvOXJFZnByQzdEV1hUVHZRdWF1Tk90?=
 =?utf-8?B?NzFzSWhNa0RhZkdUbXpUbjVpS1J6cytHaWQxTGRuZk8xaElnVm51cWZKb3VX?=
 =?utf-8?B?ejhpTmpWL2tEOTVvM1RpdDlNRVZmNnIwTmxVOTBFK0JrZ2ZRVWZvZkNmMmNz?=
 =?utf-8?B?enAybEJtQUgyMUFqbFBpOHhHaEljTXpyZjh3ZmRSMFFoVmNxMVlUaUd1UkJD?=
 =?utf-8?B?Y3VqV0xUQ1JGT0Zwd0dzZXZNelhqMHM1dHFPTkpwOVRLYUNlSSt5cGxIV1V0?=
 =?utf-8?B?a1lBclcxZmNVWnJaYURhMU5UcGZJRHJIVlRTaVk2NW54cTFtS0c3dnBENG5j?=
 =?utf-8?B?N0ExcWJoOCtleHdJYTRGaE54NEZ3K293S0VSUWpmODNjeFdCaHZ5Nnc4djEx?=
 =?utf-8?B?bUdCN0ZQTm82UXlKWlhaYjdBUEFvQ05YZElNcUxiKzJxZ1hNbFprQVFPaTVN?=
 =?utf-8?B?bFRQb0djU2F5YTFiV2w1VnE0a3JSeTE4bXF6VDdXTjFqZnVJY1RadW9BaHVx?=
 =?utf-8?B?TGNRVSs5d2FJK1BRUVdEVGRwdFNzYm9NWG9qNGsraHJhb3dteHFyc21MaWxp?=
 =?utf-8?B?c0tmK0J4bVg3RW94dTAvdDBGNnVHVVEwa1FiRFAvVzlFQnlXN3VQNkJaNGxO?=
 =?utf-8?B?ek5YTXd2TWRuTjJHd2dTZStSbm1xSUpXZ3A2ZHovZHprQ29HQ1pzSHFIN2Vj?=
 =?utf-8?B?R3didkxVZG5oa0p6R3Z3aDdPbU9Zb2RrcE84aHVEZ3dSZ2V2Yk1wenlVUzcw?=
 =?utf-8?B?dFF3UmZCV3RrWEVHSjlqVkU5V21qMnQ3MVZnb3lqYVZKcDZGSTJvdU05VkhT?=
 =?utf-8?B?ZHUwMjg5MmpIY1hKQUU3eCtscjZXd3ozdDdmY2pWalUzT0FscllTVC92RW5O?=
 =?utf-8?B?ekxBR2s2THN1OEtqYmhhR3RYZjFTSGVWUUp5bHhkcXZJUVE1ZllOQkVnbTBv?=
 =?utf-8?B?WStJZU5HbXo4bzB3V1NCWDVXdEFKZE1zb1JPd0g1cG5jWVNDTHZSSHJZYXlj?=
 =?utf-8?B?eENERmViZUNVN2JvR3NweG54Y2RLY3dHS0xKTm1HNnBHR29reVVqTzVzRS9V?=
 =?utf-8?B?T0NQcXlzUWM2OXZoUGtuclVyaVNlaG1NOGI4TmdSbkxlRTdCcmdZM0FIRzQy?=
 =?utf-8?B?ZHI2UXprS3Q2NGtEZHBLTEtWTnVIdjdoak1FNlJUN3RselRQWkx6YnpoZ09t?=
 =?utf-8?B?L3N2REdRL0F0OFJQZTQxUnpzUTQyV3FYQUNKTk9wNVgySGpLUGpwblIyZTFw?=
 =?utf-8?B?ajlxU1plTE1QWFpCWnJNaVdCYkw3SHdDWFlraUIyZGtBZ1YyY3RvOUNQZVRP?=
 =?utf-8?B?STI1Vy8wb1hKUHFUb3g3cGhZZHpnM3o0TDM1a1RMa0toVDNRRmUzdWZNVWlP?=
 =?utf-8?B?aUpDblBHTE1XY1Q1bnNXOEdYSm5JeEcwNlhzU3VIZ1FzcklSanpqWkMxeUt1?=
 =?utf-8?B?YkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7E340B072C712940914578C1FB7C8FA3@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lMROoY1tYi+mVynaOMM77OUYVgArI0mIRi5+GlIsm3wOogisPuW7LBnN2Uz4p/adCiCbgujIXOAnpdhdSmWLcYJqI2hmt1DqMnqVh+JulMGPsLzr/76LY+h3vuE6wO785+tfijyTE5kYvcTA2DataJGM7+x4OTiNwNahoTWpuAXKaCf7+EdrpImi8Mubul0yWl5AJg+VP1czx0td5Wg0IQDGa1aMKRRpPuofPwv+PuPpCk7u/51UIp58cnON15am8FVgD/Ssy7SqILzJOZYG3REEjOja9lf3R88JUOvwhB930HPWE89EyzA9fU+0FNY9cVEyUDgLVi+VhtCLPpu2/zGPr2/miz5MahU5rkV4snBLW0KUtQGt7apHfQZRwdLri/EjIWuGcyb4UwJtCJz7YzaAowxJAwVM/6QndaEtSpezKl1u5t3ruFRjpjjZUWxCCGoeBnbykbhmmK3jSI0oGW7RYybaXFWq8C7yCUgK3/y2S+0+5UBTA7rFIGB0EOXmoTDwtANWr2XcsUxWI7mPTiZTJqA5mPIOpU3Dz7ufrCLIqxNFF1lUMaBPnzVisfHyepR58RSaZYgWYIXWARl5QyEStKQnoX1LILPE7113z4UpMBf/II3Ckg4t5Wt23t/xQMOJ2Kp9RGLeHvVIGSZPdO+16hZBAX6bi3zWN+aeFInj243UJwuDZ3xKM6xy/pqnTIzU3biOiocFg/K2W512ucAR14bQydL9lGFuIkakpW2dnHckicivQ0ym2XAzoH7vq0izl26ZK4DgnQ4D4bRQKfYiCvDTX+kNhYGMp7uVLnELQ4SFTSXJvazIYEOz6ZejfvwFU2h5J7/GYZhvn7sdMQ==
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS7PR01MB11664.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 789f703e-627f-437f-3474-08dbbb0ae84e
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2023 01:26:12.3995
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tn38ZVfmqR0Vjn9gMHfNRK/6woCc3qe8TL29u4SedlYTjC801m3TaA82jvDRcZ70oyuLQWFGqaMDrVOw19DKlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB11708

DQoNCk9uIDIyLzA5LzIwMjMgMDc6MTksIERhdmUgSmlhbmcgd3JvdGU6DQo+IA0KPiANCj4gT24g
OS8yMC8yMyAxOTo1OCwgWmhpamlhbiBMaSAoRnVqaXRzdSkgd3JvdGU6DQo+PiBEYXZl77yMDQo+
Pg0KPj4gRm9yZ2l2ZSBtZSBmb3Igbm90IGhhdmluZyBhIG5ldyB0aHJlYWQsIEknZCBhc2sgYSBw
b3NzaWJsZSByZWxldmFudCBxdWVzdGlvbnMgYWJvdXQgZGlzYWJsZS1tZW1kZXYNCj4+IFdlIG5v
dGljZWQgdGhhdCBvbmx5IC1mIGlzIGltcGxlbWVudGVkIGZvciBkaXNhYmxlLW1lbWRldiwgYW5k
IGl0IGxlZnQgYQ0KPj4gIlRPRE86IGFjdHVhbGx5IGRldGVjdCByYXRoZXIgdGhhbiBhc3N1bWUg
YWN0aXZlIiBpbiBjeGwvbWVtZGV2LmMuDQo+Pg0KPj4gTXkgcXVlc3Rpb25zIGFyZToNCj4+IDEu
IERvZXMgdGhlICphY3RpdmUqIGhlcmUgbWVhbiB0aGUgcmVnaW9uKHRoZSBtZW1kZXYgYmVsb25n
cyB0bykgaXMgYWN0aXZlID8NCj4+IDIuIElzIHRoZSB3aXRob3V0IGZvcmNlIG1ldGhvZCB1bmRl
ciBkZXZlbG9waW5nID8NCj4+DQo+PiBNeSBjb2xsZWFndWVzKGluIENDJ3MpIGFyZSBpbnZlc3Rp
Z2F0aW5nIGhvdyB0byBncmFjZWZ1bGx5IGRpc2FibGUtbWVtZGV2DQo+IA0KPiBaaGlqaWFuLA0K
PiBTbyB0aGlzIHdhcyB0aGVyZSBiZWZvcmUgdGhlIHJlZ2lvbiBlbnVtZXJhdGlvbiBzaG93ZWQg
dXAgYWNjb3JkaW5nIHRvIERhbi4gTm93IGFuIHVwZGF0ZSB0byBjaGVjayBpZiB0aGUgbWVtZGV2
IGlzIHBhcnQgb2YgYW55IGFjdGl2ZSByZWdpb24gc2hvdWxkIGJlIGFkZGVkLiBFaXRoZXIgeW91
IGd1eXMgY2FuIHNlbmQgYSBwYXRjaCBvciBJIGNhbiBnbyBhZGRlZCBpdC4gTGV0IG1lIGtub3cu
IFRoYW5rcyENCg0KVW5kZXJzdG9vZCwgdGhhbmtzIGZvciB5b3VyIGluZm9ybWF0aW9uLCBwbGVh
c2UgZ28gYWhlYWQgOikNCkkgYmVsaWV2ZSBvdXIgZ3V5cyBhcmUgd2lsbGluZyB0byB0ZXN0IGl0
Lg0KDQpUaGFua3MNClpoaWppYW4NCg0KPiANCj4gDQo+Pg0KPj4gVGhhbmtzDQo+PiBaaGlqaWFu
DQo+Pg0KPj4gT24gMjEvMDkvMjAyMyAwNjo1NywgRGF2ZSBKaWFuZyB3cm90ZToNCj4+PiBUaGUg
Y3VycmVudCBvcGVyYXRpb24gZm9yIGRpc2FibGVfcmVnaW9uIGRvZXMgbm90IGNoZWNrIGlmIHRo
ZSBtZW1vcnkNCj4+PiBjb3ZlcmVkIGJ5IGEgcmVnaW9uIGlzIG9ubGluZSBiZWZvcmUgYXR0ZW1w
dGluZyB0byBkaXNhYmxlIHRoZSBjeGwgcmVnaW9uLg0KPj4+IFByb3ZpZGUgYSAtZiBvcHRpb24g
Zm9yIHRoZSByZWdpb24gdG8gZm9yY2Ugb2ZmbGluaW5nIG9mIGN1cnJlbnRseSBvbmxpbmUNCj4+
PiBtZW1vcnkgYmVmb3JlIGRpc2FibGluZyB0aGUgcmVnaW9uLiBBbHNvIGFkZCBhIGNoZWNrIHRv
IGZhaWwgdGhlIG9wZXJhdGlvbg0KPj4+IGVudGlyZWx5IGlmIHRoZSBtZW1vcnkgaXMgbm9uLW1v
dmFibGUuDQo+Pj4NCj4+PiBTaWduZWQtb2ZmLWJ5OiBEYXZlIEppYW5nIDxkYXZlLmppYW5nQGlu
dGVsLmNvbT4NCj4+Pg0KPj4+IC0tLQ0KPj4+IHYyOg0KPj4+IC0gVXBkYXRlIGRvY3VtZW50YXRp
b24gYW5kIGhlbHAgb3V0cHV0LiAoVmlzaGFsKQ0KPj4+IC0tLQ0KPj4+ICAgIERvY3VtZW50YXRp
b24vY3hsL2N4bC1kaXNhYmxlLXJlZ2lvbi50eHQgfCAgICA3ICsrKysNCj4+PiAgICBjeGwvcmVn
aW9uLmMgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICA0OSArKysrKysrKysrKysrKysr
KysrKysrKysrKysrKy0NCj4+PiAgICAyIGZpbGVzIGNoYW5nZWQsIDU1IGluc2VydGlvbnMoKyks
IDEgZGVsZXRpb24oLSkNCj4+Pg0KPj4+IGRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL2N4bC9j
eGwtZGlzYWJsZS1yZWdpb24udHh0IGIvRG9jdW1lbnRhdGlvbi9jeGwvY3hsLWRpc2FibGUtcmVn
aW9uLnR4dA0KPj4+IGluZGV4IDZhMzlhZWU2ZWE2OS4uOWI5OGQ0ZDg3NDVhIDEwMDY0NA0KPj4+
IC0tLSBhL0RvY3VtZW50YXRpb24vY3hsL2N4bC1kaXNhYmxlLXJlZ2lvbi50eHQNCj4+PiArKysg
Yi9Eb2N1bWVudGF0aW9uL2N4bC9jeGwtZGlzYWJsZS1yZWdpb24udHh0DQo+Pj4gQEAgLTI1LDYg
KzI1LDEzIEBAIE9QVElPTlMNCj4+PiAgICAtLS0tLS0tDQo+Pj4gICAgaW5jbHVkZTo6YnVzLW9w
dGlvbi50eHRbXQ0KPj4+ICAgIA0KPj4+ICstZjo6DQo+Pj4gKy0tZm9yY2U6Og0KPj4+ICsJQXR0
ZW1wdCB0byBvZmZsaW5lIGFueSBtZW1vcnkgdGhhdCBoYXMgYmVlbiBob3QtYWRkZWQgaW50byB0
aGUgc3lzdGVtDQo+Pj4gKwl2aWEgdGhlIENYTCByZWdpb24gYmVmb3JlIGRpc2FibGluZyB0aGUg
cmVnaW9uLiBUaGlzIHdvbid0IGJlIGF0dGVtcHRlZA0KPj4+ICsJaWYgdGhlIG1lbW9yeSB3YXMg
bm90IGFkZGVkIGFzICdtb3ZhYmxlJywgYW5kIG1heSBzdGlsbCBmYWlsIGV2ZW4gaWYgaXQNCj4+
PiArCXdhcyBtb3ZhYmxlLg0KPj4+ICsNCj4+PiAgICBpbmNsdWRlOjpkZWNvZGVyLW9wdGlvbi50
eHRbXQ0KPj4+ICAgIA0KPj4+ICAgIGluY2x1ZGU6OmRlYnVnLW9wdGlvbi50eHRbXQ0KPj4+IGRp
ZmYgLS1naXQgYS9jeGwvcmVnaW9uLmMgYi9jeGwvcmVnaW9uLmMNCj4+PiBpbmRleCBiY2Q3MDM5
NTYyMDcuLmY4MzAzODY5NzI3YSAxMDA2NDQNCj4+PiAtLS0gYS9jeGwvcmVnaW9uLmMNCj4+PiAr
KysgYi9jeGwvcmVnaW9uLmMNCj4+PiBAQCAtMTQsNiArMTQsNyBAQA0KPj4+ICAgICNpbmNsdWRl
IDx1dGlsL3BhcnNlLW9wdGlvbnMuaD4NCj4+PiAgICAjaW5jbHVkZSA8Y2Nhbi9taW5tYXgvbWlu
bWF4Lmg+DQo+Pj4gICAgI2luY2x1ZGUgPGNjYW4vc2hvcnRfdHlwZXMvc2hvcnRfdHlwZXMuaD4N
Cj4+PiArI2luY2x1ZGUgPGRheGN0bC9saWJkYXhjdGwuaD4NCj4+PiAgICANCj4+PiAgICAjaW5j
bHVkZSAiZmlsdGVyLmgiDQo+Pj4gICAgI2luY2x1ZGUgImpzb24uaCINCj4+PiBAQCAtOTUsNiAr
OTYsOCBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IG9wdGlvbiBlbmFibGVfb3B0aW9uc1tdID0gew0K
Pj4+ICAgIA0KPj4+ICAgIHN0YXRpYyBjb25zdCBzdHJ1Y3Qgb3B0aW9uIGRpc2FibGVfb3B0aW9u
c1tdID0gew0KPj4+ICAgIAlCQVNFX09QVElPTlMoKSwNCj4+PiArCU9QVF9CT09MRUFOKCdmJywg
ImZvcmNlIiwgJnBhcmFtLmZvcmNlLA0KPj4+ICsJCSAgICAiYXR0ZW1wdCB0byBvZmZsaW5lIG1l
bW9yeSBiZWZvcmUgZGlzYWJsaW5nIHRoZSByZWdpb24iKSwNCj4+PiAgICAJT1BUX0VORCgpLA0K
Pj4+ICAgIH07DQo+Pj4gICAgDQo+Pj4gQEAgLTc4OSwxMyArNzkyLDU3IEBAIHN0YXRpYyBpbnQg
ZGVzdHJveV9yZWdpb24oc3RydWN0IGN4bF9yZWdpb24gKnJlZ2lvbikNCj4+PiAgICAJcmV0dXJu
IGN4bF9yZWdpb25fZGVsZXRlKHJlZ2lvbik7DQo+Pj4gICAgfQ0KPj4+ICAgIA0KPj4+ICtzdGF0
aWMgaW50IGRpc2FibGVfcmVnaW9uKHN0cnVjdCBjeGxfcmVnaW9uICpyZWdpb24pDQo+Pj4gK3sN
Cj4+PiArCWNvbnN0IGNoYXIgKmRldm5hbWUgPSBjeGxfcmVnaW9uX2dldF9kZXZuYW1lKHJlZ2lv
bik7DQo+Pj4gKwlzdHJ1Y3QgZGF4Y3RsX3JlZ2lvbiAqZGF4X3JlZ2lvbjsNCj4+PiArCXN0cnVj
dCBkYXhjdGxfbWVtb3J5ICptZW07DQo+Pj4gKwlzdHJ1Y3QgZGF4Y3RsX2RldiAqZGV2Ow0KPj4+
ICsJaW50IHJjOw0KPj4+ICsNCj4+PiArCWRheF9yZWdpb24gPSBjeGxfcmVnaW9uX2dldF9kYXhj
dGxfcmVnaW9uKHJlZ2lvbik7DQo+Pj4gKwlpZiAoIWRheF9yZWdpb24pDQo+Pj4gKwkJZ290byBv
dXQ7DQo+Pj4gKw0KPj4+ICsJZGF4Y3RsX2Rldl9mb3JlYWNoKGRheF9yZWdpb24sIGRldikgew0K
Pj4+ICsJCW1lbSA9IGRheGN0bF9kZXZfZ2V0X21lbW9yeShkZXYpOw0KPj4+ICsJCWlmICghbWVt
KQ0KPj4+ICsJCQlyZXR1cm4gLUVOWElPOw0KPj4+ICsNCj4+PiArCQlpZiAoZGF4Y3RsX21lbW9y
eV9vbmxpbmVfbm9fbW92YWJsZShtZW0pKSB7DQo+Pj4gKwkJCWxvZ19lcnIoJnJsLCAiJXM6IG1l
bW9yeSB1bm1vdmFibGUgZm9yICVzXG4iLA0KPj4+ICsJCQkJCWRldm5hbWUsDQo+Pj4gKwkJCQkJ
ZGF4Y3RsX2Rldl9nZXRfZGV2bmFtZShkZXYpKTsNCj4+PiArCQkJcmV0dXJuIC1FUEVSTTsNCj4+
PiArCQl9DQo+Pj4gKw0KPj4+ICsJCS8qDQo+Pj4gKwkJICogSWYgbWVtb3J5IGlzIHN0aWxsIG9u
bGluZSBhbmQgdXNlciB3YW50cyB0byBmb3JjZSBpdCwgYXR0ZW1wdA0KPj4+ICsJCSAqIHRvIG9m
ZmxpbmUgaXQuDQo+Pj4gKwkJICovDQo+Pj4gKwkJaWYgKGRheGN0bF9tZW1vcnlfaXNfb25saW5l
KG1lbSkgJiYgcGFyYW0uZm9yY2UpIHsNCj4+PiArCQkJcmMgPSBkYXhjdGxfbWVtb3J5X29mZmxp
bmUobWVtKTsNCj4+PiArCQkJaWYgKHJjKSB7DQo+Pj4gKwkJCQlsb2dfZXJyKCZybCwgIiVzOiB1
bmFibGUgdG8gb2ZmbGluZSAlczogJXNcbiIsDQo+Pj4gKwkJCQkJZGV2bmFtZSwNCj4+PiArCQkJ
CQlkYXhjdGxfZGV2X2dldF9kZXZuYW1lKGRldiksDQo+Pj4gKwkJCQkJc3RyZXJyb3IoYWJzKHJj
KSkpOw0KPj4+ICsJCQkJcmV0dXJuIHJjOw0KPj4+ICsJCQl9DQo+Pj4gKwkJfQ0KPj4+ICsJfQ0K
Pj4+ICsNCj4+PiArb3V0Og0KPj4+ICsJcmV0dXJuIGN4bF9yZWdpb25fZGlzYWJsZShyZWdpb24p
Ow0KPj4+ICt9DQo+Pj4gKw0KPj4+ICAgIHN0YXRpYyBpbnQgZG9fcmVnaW9uX3hhYmxlKHN0cnVj
dCBjeGxfcmVnaW9uICpyZWdpb24sIGVudW0gcmVnaW9uX2FjdGlvbnMgYWN0aW9uKQ0KPj4+ICAg
IHsNCj4+PiAgICAJc3dpdGNoIChhY3Rpb24pIHsNCj4+PiAgICAJY2FzZSBBQ1RJT05fRU5BQkxF
Og0KPj4+ICAgIAkJcmV0dXJuIGN4bF9yZWdpb25fZW5hYmxlKHJlZ2lvbik7DQo+Pj4gICAgCWNh
c2UgQUNUSU9OX0RJU0FCTEU6DQo+Pj4gLQkJcmV0dXJuIGN4bF9yZWdpb25fZGlzYWJsZShyZWdp
b24pOw0KPj4+ICsJCXJldHVybiBkaXNhYmxlX3JlZ2lvbihyZWdpb24pOw0KPj4+ICAgIAljYXNl
IEFDVElPTl9ERVNUUk9ZOg0KPj4+ICAgIAkJcmV0dXJuIGRlc3Ryb3lfcmVnaW9uKHJlZ2lvbik7
DQo+Pj4gICAgCWRlZmF1bHQ6DQo+Pj4=
