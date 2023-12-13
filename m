Received: from esa12.fujitsucc.c3s2.iphmx.com (esa12.fujitsucc.c3s2.iphmx.com [216.71.156.125])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F00E71A5AC
	for <nvdimm@lists.linux.dev>; Wed, 13 Dec 2023 08:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="k7oxk+PQ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1702454469; x=1733990469;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=2N/nFBevuK8Zvl1pLfttGS2+yfN/PEfxF1ImrF5twqA=;
  b=k7oxk+PQES3CPYHLmtL1mNwt4+NnuowZIygCSIjPUtrBP7xFHOqBUBmp
   OufS/JMcbXT+gWiQo19EpSljkDkvI9CZ9A47/Q2ewTz8cPoO14Rqi6Hxh
   68F5ZS6ced4uggf/3rZ3mNFIvYdpbqsJDohMIs/MvXD1dZF+eP/kxWwR8
   eihmffHuqIGcQFCQMBmx0ZUDVRcCDC0RVi3xpu8HnmmHocvYjoYxfJ5Jz
   kqEMXNlOqS647iShPA9C19FqMUE7n77AT+LlLmXzWe0CrxwIJulWYZTDl
   e7MpXSsVHDHCw4HSYCwFyNmRrboCpcdkCTJaPONEXk03ry7H1rh0d8TZv
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10922"; a="105749475"
X-IronPort-AV: E=Sophos;i="6.04,272,1695654000"; 
   d="scan'208";a="105749475"
Received: from mail-os0jpn01lp2104.outbound.protection.outlook.com (HELO JPN01-OS0-obe.outbound.protection.outlook.com) ([104.47.23.104])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2023 17:00:52 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=czOPmXabMvyF9C8OmpMojEMWTmshl3v5MgasIY2+5C7k1+zQM00rgM9jEOE2CX8mhaoj24R6kLVT1CVP9+HolwaWwRnVBk7a/4sChdS0uGwqfBu+h8ceR05f2qZvUYwYEgAGOm0dYaJlm7LTTKcD1kfkeGS4sywcUajFE2ZKDl0qLpRuesKA4k2c1s8LLchK+NpY9PJAS5M7EAWTQdD3HwjlhVLjJAYdJpR1YE+bQdAWDne+Xpyh7IGeDwWxh/alSEzluNxSyHNzlBSSwW4coCl6irGNwvSOZuqwkcOb72k9lbrYuKX4GOayTyq/k1Ok8lW3KYUBYqysHLWStY11oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2N/nFBevuK8Zvl1pLfttGS2+yfN/PEfxF1ImrF5twqA=;
 b=M6GrnWfyUGX40yXFl3KiKQDV5/iAfRUAxci5bENZItQMkMo3qisit6aqeGlKzskq+1wfqcZKeNtpvXA1rExCDlhg7H/FL+cfnOB7w/mKm5d+RyZGwLW8y9htNkxlY+c9ycGAqkdQ1b9sXOBk2Y3E9A2585dnW+6ZiPQ4giygNNM3f5msZNSqka9Nfhlzkgugnlkf/Cjo1a0EKzgiaUd1TNa93dZAIVpsGbVlIUeCmL+rbwraxyO/EvoFdD2lOrOq54/+rIruHQkBB4z1l4G8h88flHXpXLBMEnwH2h2E7hnt1NM9zP769wMinidbc6j5rbv7nNucLZ7KZHP3Qy8rLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from OS0PR01MB5442.jpnprd01.prod.outlook.com (2603:1096:604:a6::10)
 by OSZPR01MB9487.jpnprd01.prod.outlook.com (2603:1096:604:1d4::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.26; Wed, 13 Dec
 2023 08:00:48 +0000
Received: from OS0PR01MB5442.jpnprd01.prod.outlook.com
 ([fe80::c96f:52b0:dd4e:8d50]) by OS0PR01MB5442.jpnprd01.prod.outlook.com
 ([fe80::c96f:52b0:dd4e:8d50%6]) with mapi id 15.20.7091.022; Wed, 13 Dec 2023
 08:00:48 +0000
From: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>
To: Alison Schofield <alison.schofield@intel.com>
CC: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, Dan Williams
	<dan.j.williams@intel.com>
Subject: Re: [ndctl PATCH v2 2/2] test/cxl-region-sysfs.sh: Fix
 cxl-region-sysfs.sh: line 107: [: missing `]'
Thread-Topic: [ndctl PATCH v2 2/2] test/cxl-region-sysfs.sh: Fix
 cxl-region-sysfs.sh: line 107: [: missing `]'
Thread-Index: AQHaLM7HYz+XqJvf30eOWT5WBTZdzrCmISsAgAC6LYA=
Date: Wed, 13 Dec 2023 08:00:48 +0000
Message-ID: <6fcd1024-2048-4e5f-9d5d-68cbeb08a0f1@fujitsu.com>
References: <20231212074228.1261164-1-lizhijian@fujitsu.com>
 <20231212074228.1261164-2-lizhijian@fujitsu.com>
 <ZXjIgntHf4qptjwZ@aschofie-mobl2>
In-Reply-To: <ZXjIgntHf4qptjwZ@aschofie-mobl2>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS0PR01MB5442:EE_|OSZPR01MB9487:EE_
x-ms-office365-filtering-correlation-id: a5ff8ca5-de0b-40ea-e242-08dbfbb19e3e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 PMjZ7q/exqSFNrsRS0rdPxUVXOD9dzhKAHVca/IeEHvPuuRkgNq5xZvMPnWbGNlqoqoJToIpIfzjeZSuRXZ0D9KeHefNIoYAQ5QFGciWOQ7t/l1BWP8KoaGR7+aFp5SYbQqjDtwtfq9R7QPIusR/D5RcisGhWELQXul2y4Hy8DrOclOg0ddCOG3CHSC3zdDhGMb7VCQUKqbGD4mTtuUhfI6Th4v+DW379T4t0D0QoYV8+xYpTOCpziXY1tXxNgcrk3fWbB2kse2/OF8Kjh2fpJ/hWAgTLlgwBCEi/dQjyYXTKgJsIA0Pi5hIHsaF8nfxB3cpa6CRGbG81oGlVz5GvR9Xkd69HpDZR1+SEMviZh1vbAFefrBTwIMBWvkQXOKmpNprloujESiG6QuL+Kju6Mw2UnQ8KCvuZtmmqEdqj5zf78qPVQTI6q9u6QTRE5h1wiDc3wXSiYYej9U8rkkRqh2wJrSt6qyUyJ5M7bn16rVr4sTdRXQ1JoY3xO6QCaq8tIpcEbOJSOtLjXWkw/AXfAbjMTxy/AqeKkdCQ0LdfXphVl21eijxXzc3tt0CNydLy9BEbGSYw6mwcnofBWeLhCdKv+ochcLKzHIejiy02G265RLFO/+MKT3lfGlWH5hOGA0ClEkkJv91AkUKAlpZD/uA3aGg4yhKrW5emCJ+k/Ty+3mrnzmkQQHPkJLEIRk5KuY3rUCU82IJOW8ikERL1Q==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5442.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(376002)(346002)(366004)(136003)(230922051799003)(1590799021)(186009)(64100799003)(451199024)(1800799012)(31686004)(38070700009)(1580799018)(76116006)(66946007)(64756008)(91956017)(54906003)(6916009)(66446008)(66556008)(66476007)(82960400001)(31696002)(36756003)(86362001)(85182001)(122000001)(38100700002)(83380400001)(26005)(6512007)(6506007)(2616005)(53546011)(316002)(2906002)(71200400001)(478600001)(6486002)(5660300002)(4326008)(8936002)(8676002)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MXZGMGZVSFRmUldrQlpzQ2gyN3pwR2dGS3N1dVFieUE4eENJNmpxRDNGV2ll?=
 =?utf-8?B?UjgxWUFtNTBmQlFXTTBudlFKMHlmbVBvcis0MlloaUw0ckhQNEFpVmtKVnA0?=
 =?utf-8?B?TkRSd1NxQ1k2L2R5T3RWSTlTNVc0UThFVmtmMEZLZlU2S05ObmR6VUNQNnZV?=
 =?utf-8?B?cEdYT3BPYkJPbUFFcWFwT1h6SUdEdjlta2RxOUZYdVBRUHo0NWoyaDZoVFZs?=
 =?utf-8?B?R1A2VkNQYnhkSHZiWnduclcyb1diR2gyZHZBMjlkM3RPaG5TdXU0WWwwRTFX?=
 =?utf-8?B?VTVLYWM1eE1Hb0crWktzM3BBNng0T2RjaEo1dHBDdFNtaHhZK2FGU3NjVzh5?=
 =?utf-8?B?S09ueGxObWdMblFUbjRMRWtsbTlvVThESHlCaFRRMHhZYUQ0aG5lLzBtaW8w?=
 =?utf-8?B?U1REaHFjajRVcm1zUFl5Z01jU1RLZDdpWW5yVm9IRzBjbGRQeUhqTzFQTHRV?=
 =?utf-8?B?bGliUGRIYm4zcUFzK3BCL3liVkhPMURuakNRcUY5eDVPa29Yc1pablpJU0xh?=
 =?utf-8?B?ckhOTGw1Qkx1cVM1cy81NlJqWlhwMU5Ja3Y1L2dST0p6STFmRkdjTjNEY3oz?=
 =?utf-8?B?ekwxYWJJR2FpMTdZYkYxbitKS1EzaW45ZFRDdktrNndYaGg0WGFjc2FhTXdT?=
 =?utf-8?B?VEVmTDhQU21OaERDZHd3Y2UrMWhiZ3NqNHlEYlZiK0ZxUmwwTWRuOHM0RXR3?=
 =?utf-8?B?cktYUU1IUVZ3ZnFwRU5vak8rZXk1dFBFODJXVWZVa1RpeE5CVGZyZXNMcW5T?=
 =?utf-8?B?aWp6by9WSEk4VS9jUTdza29UdG5wa2RWWXZHcVB0VDZPSy9uRmg1SzMyVDZv?=
 =?utf-8?B?eUNuU3NQSks1SU41Z2ZtL1lheVk4V0lhS1dFa2FqNlpTZ3lmOWw0NTlXbUIr?=
 =?utf-8?B?WWJTeXRZbjU0NzI4RnVETXppR0NYaXpaUGZQOEJjeXd6UGdaTnpzcVR5N3Zy?=
 =?utf-8?B?d2twbWhSV0Nac1FpYlpQaUZwd1FwN3pjWVdIRlFKbkVZUXlHYmlQdGNWd1Yv?=
 =?utf-8?B?RmplZlZHcVF5bUs3RzlMZXVlNXY3T0xiUm9RTWIrcUZtV0s1NTRrWUxqdm4y?=
 =?utf-8?B?TE9MMENzeU85UU1tV3JIV3AvdFZXVkUxRUdaUHJnblgwNkUvUXY2WHJJbEJ0?=
 =?utf-8?B?Zkw0My9ndVM0NTRpY3YzUkE3S2F6RTRBQTRzbHBXT3dZbFdoWWVjZEh4SkFU?=
 =?utf-8?B?UWM1T3lDTkw0L2J0aklXZGxocEh4dDBCZjFZVkdWVGxCMEljaENDLzVoZjBL?=
 =?utf-8?B?OXlNbnRuVzdYcWF0emlWTCtmSWhlek9WaGNlL0tvRGdlWUMvL0g0U3lFWnJR?=
 =?utf-8?B?UDhKdGdSMURBazNxai9VVFlQWkdXRzErMjJ1Y2lWM1NOZyt6aU9nell3eS9Z?=
 =?utf-8?B?bmtZS3BuR21CbUNDbHRucE5QWGlYWUNpR0dhOXVKeEtveVBlckx4R3Qvd2NP?=
 =?utf-8?B?ZEsrZHBCVzJ1LzdkRWFTSVhKVFg0cHlEWXJmbUJhb2RQYlAvd0QyQzEzSXhy?=
 =?utf-8?B?dURMZ3dXem0zVEZlcDIwSmpkT0FDdWFxK09HRGRBWXVqNnBpNHdYSGp1RHVa?=
 =?utf-8?B?NHp4c1pBNWZCdmhUdWV2MWdPU1FyZW1XQVNNUzBlZFROa3luM05aNU8xWWJp?=
 =?utf-8?B?bVY1d2oxYSs1TmpiTmZ3dGVLSis1cFZaekxIZmUrdkFWZmhWTGxGb2UxUURY?=
 =?utf-8?B?SEMyS2JHVHRlWEM5Qk9PUkRqcEJPT3g3bDBaZkZnd2VTUXI5SDJKWVptbldH?=
 =?utf-8?B?OHE5ZG94aTJmdUplVW5iMHpNSGVEdHpDNWhuVFVWb2d5YXpZOGNJUzJTVzB3?=
 =?utf-8?B?OG5sZGV2d2w1b0xIUVpmck1ESmM3UUZLNE5ZVEx4RThZOG1rVWhMQWl0d2Jl?=
 =?utf-8?B?eWtwU2VEVUxkV01ZRW01Z3B0cVVpY2g5bGVRdHV5cmxUWTM1V1BiSmxBcmk5?=
 =?utf-8?B?VHFWOVBBaHlYWFkyNGZMM1Jkd2tHejNyN0F0Wm1JMTdLaVN1RERiVDJLK05L?=
 =?utf-8?B?M3VwdVN0bU1NS0xDWVMwaVZCUjJubWZSVTdkNnU5Z0NjN0lMMGc1MDJGSDJw?=
 =?utf-8?B?czRkRmRWTjVaUkhvQnpjVjJPWDNINzlXdUdMd2NpRmdYVnFIbDNydUVtWDV3?=
 =?utf-8?B?R1hDQVl3SmdPMmhWUk1zSWhSd2VTY1JEb1FoZ1RJUUt6c05lblRjekxEakFS?=
 =?utf-8?B?REE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <286D875E8F1B0541967740F3DF4C1BF0@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	uyQS3Rd+gtIEWxOy1pE6yCWnHbNjQ35mw1dGXLEjamdivCaXKC8SeYUnzVexnKeomWRz4w8+L3JUhqFtTW9i5G1Duird4Ai+ZfJefMOfLWXxOtgTw8kHUR5V98FhMFs9Srw9nMScoytExgm5ezPonVXYlOSY7h203xxudeAZMHeOFkHX2zyGJYQr4oq+miNTrlKbL5FpfkQutLQTnJlxdIu4DbluTkZ4M7FpEe7ekP4ZJptawEnsgdMxK8HIPauLWZSoVPxNEj/LN6dvx6IOgsEcfE8qcWx4qouEbzIdjF+K4kO5whDdOmHiNhOxSQxaKlEaSJVXHVFbaLZt7Bz4b+cTIafAIYBEWsp/Egqb9G+3jTFmVuHkPYYtjwuFU3sSj+5Td06Q4Wh4Deml487iOXbpyxMSejZ1i+U4rs7KS0/npfF5YH41/AV2gTpknJy4SxqX6PnZPwnm//d7LeYTeefl7TpDxnVXXSuGtpBK28wqaDLNajqVxK6aHCr1H5FgZvwbL54O+NYHRF5C9NxpMUP2/GCgQMtUpUWluvAoKonXidixMkZhoenTNP6Iae3qtmz0RMREQvzoBrRonSeQypcO3+xDa1YaIFL+GZcuR8lU44v8LOXV1G/kPvADlzZV
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5442.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5ff8ca5-de0b-40ea-e242-08dbfbb19e3e
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2023 08:00:48.5648
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9PQ5W0Tu+/TjvmzaNMLdmac02N8IGlTvlhP65SzSTDUQcJE2+aB4ab7PoKAtIhc3VXCBJsOexkFsGQahMMLyiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSZPR01MB9487

DQoNCk9uIDEzLzEyLzIwMjMgMDQ6NTQsIEFsaXNvbiBTY2hvZmllbGQgd3JvdGU6DQo+IE9uIFR1
ZSwgRGVjIDEyLCAyMDIzIGF0IDAzOjQyOjI4UE0gKzA4MDAsIExpIFpoaWppYW4gd3JvdGU6DQo+
PiBBIHNwYWNlIGlzIG1pc3NpbmcgYmVmb3JlICddJw0KPiANCj4gV2hhdCdzIGhhcHBlbnMgd2hl
biB0aGF0IHNwYWNlIGlzIG1pc3Npbmc/DQoNCkl0J3MgYSBzeW50YXggZXJyb3IsIHNvDQonWyAk
aWcgLW5lICRyX2lnXScgaXMgYWx3YXlzIGZhbHNlLCBpdCBtYXkgaGlkZSB0aGUgYSByZWFsIGVy
cm9yLg0KDQoNCg0KPiBUaGF0J3MgcGFydGx5IGEgcmVxdWVzdCB0byBhZGQgYW4gaW1wYWN0IHN0
YXRlbWVudCwgYnV0IGFsc28NCj4gZm9yIG15IGVkdWNhdGlvbiBhcyBJJ20ganVzdCBsZWFybmlu
ZyBhbGwgdGhpcyBzaGVsbGNoZWNrDQo+IHN0dWZmIHRvby4NCg0Kc2hlbGxjaGVjayBpcyBhYmxl
IHRvIGluc3BlY3QgdGhpcyBlcnJvci4NCg0KPiANCj4gQlRXIC0gaWYgYW55IG9mIHRoaXMgd2Fz
IGZvdW5kIHVzaW5nIGEgdG9vbCwgcmF0aGVyIHRoYW4NCj4gYnkgaW5zcGVjdGlvbiwgcGxlYXNl
IGluY2x1ZGUgYSBub3RlIG9mIHRoZSB0b29sIHVzZWQuDQoNClRoaXMgdGltZSwgdGhleSBhcmUg
YWxsIGZvdW5kIGJ5IGV5ZXMgOikNCndoZW4gaSdtIGNoZWNraW5nIHRoZSBmdWxsIGxvZyB3aGVu
IGkgbWV0IGFuIGVycm9yLg0KDQoNClRoYW5rcw0KWmhpamlhbg0KDQo+IA0KPiBUaGFua3MsDQo+
IEFsaXNvbg0KPiANCj4+DQo+PiBBY2tlZC1ieTogRGFuIFdpbGxpYW1zIDxkYW4uai53aWxsaWFt
c0BpbnRlbC5jb20+DQo+PiBTaWduZWQtb2ZmLWJ5OiBMaSBaaGlqaWFuIDxsaXpoaWppYW5AZnVq
aXRzdS5jb20+DQo+PiAtLS0NCj4+ICAgdGVzdC9jeGwtcmVnaW9uLXN5c2ZzLnNoIHwgMiArLQ0K
Pj4gICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4+DQo+
PiBkaWZmIC0tZ2l0IGEvdGVzdC9jeGwtcmVnaW9uLXN5c2ZzLnNoIGIvdGVzdC9jeGwtcmVnaW9u
LXN5c2ZzLnNoDQo+PiBpbmRleCA2YTVkYTZkLi5kYjFhMTYzIDEwMDY0NA0KPj4gLS0tIGEvdGVz
dC9jeGwtcmVnaW9uLXN5c2ZzLnNoDQo+PiArKysgYi90ZXN0L2N4bC1yZWdpb24tc3lzZnMuc2gN
Cj4+IEBAIC0xMDQsNyArMTA0LDcgQEAgZG8NCj4+ICAgCWl3PSQoY2F0IC9zeXMvYnVzL2N4bC9k
ZXZpY2VzLyRpL2ludGVybGVhdmVfd2F5cykNCj4+ICAgCWlnPSQoY2F0IC9zeXMvYnVzL2N4bC9k
ZXZpY2VzLyRpL2ludGVybGVhdmVfZ3JhbnVsYXJpdHkpDQo+PiAgIAlbICRpdyAtbmUgJG5yX3Rh
cmdldHMgXSAmJiBlcnIgIiRMSU5FTk86IGRlY29kZXI6ICRpIGl3OiAkaXcgdGFyZ2V0czogJG5y
X3RhcmdldHMiDQo+PiAtCVsgJGlnIC1uZSAkcl9pZ10gJiYgZXJyICIkTElORU5POiBkZWNvZGVy
OiAkaSBpZzogJGlnIHJvb3QgaWc6ICRyX2lnIg0KPj4gKwlbICRpZyAtbmUgJHJfaWcgXSAmJiBl
cnIgIiRMSU5FTk86IGRlY29kZXI6ICRpIGlnOiAkaWcgcm9vdCBpZzogJHJfaWciDQo+PiAgIA0K
Pj4gICAJc3o9JChjYXQgL3N5cy9idXMvY3hsL2RldmljZXMvJGkvc2l6ZSkNCj4+ICAgCXJlcz0k
KGNhdCAvc3lzL2J1cy9jeGwvZGV2aWNlcy8kaS9zdGFydCkNCj4+IC0tIA0KPj4gMi40MS4wDQo+
Pg0KPj4NCj4g
