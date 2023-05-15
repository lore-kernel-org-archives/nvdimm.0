Received: from esa14.fujitsucc.c3s2.iphmx.com (esa14.fujitsucc.c3s2.iphmx.com [68.232.156.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5B7423D6
	for <nvdimm@lists.linux.dev>; Mon, 15 May 2023 07:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1684135118; x=1715671118;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=pj1GI9/G5CKI6z7BczJOMAB3DDJ42dh7mvF2YYTJZvg=;
  b=eG2dCbd/aZtYsW542IGZfIS2gr/VU+RpjhrZNtNFbcmG5fkIAUHXLSR1
   DxmRN5sgAgtc5CNhAIbMKLnsIW4eB/+L5LpLiDc7f0gfFyGoxrQXWSZQK
   6ypxNHmdKs9cLxbLhtaJy6tEqGwn1w9HzXnX0Kqz8h9hevo+7WlOdZruU
   qjie064+OJ4XZaaaGNAV5s3wmzBKF2OEob5E4PnM4alo24gZUOmrEAHP9
   KnVbVAZWwH4Y41v/qQd6YX5LUDUoJs1PI9Xozq1oJCoKrMJ8NX6kdAfDO
   RCCXm4WNzUl7CGdLYUdcF5igiJ81BCtNqO5Q5yND12cHqMnwMpQ0x21I4
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10710"; a="84045669"
X-IronPort-AV: E=Sophos;i="5.99,275,1677510000"; 
   d="scan'208";a="84045669"
Received: from mail-os0jpn01lp2109.outbound.protection.outlook.com (HELO JPN01-OS0-obe.outbound.protection.outlook.com) ([104.47.23.109])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2023 16:17:26 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n8nH+M2wVpaQsgv+Xi188uyFrYVQ2ZvoxiFUbNe3m985P9QcG+yQVtCJADj/h3h9yCYEzTJZ1tLxxUPTfhFDzTkSeZqIVCbTLRnm03Yw7LTUvHYqA7/2pGPtX2odFp9Wpy8yZeDcxC/0jNFJdid3/Y/DdypEdiTRn9lGjL6x4caBiEjDUullARSZT+g+7kC8hacppTr3cpD45ATpjhWVKVyS2av73X3NtpvPebq2JPMD1gskolRVIbYb7iib8Q/6gUCC87ZUk8TDQB3vwUEBIlsi6gMvajWuTkBdG4wmX//koaOw5sqTasCT2QogaHKb8qSLKXFYr1jN8VliSiJUVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pj1GI9/G5CKI6z7BczJOMAB3DDJ42dh7mvF2YYTJZvg=;
 b=KGgvQSYXOHS8/5ZX1+gL0fMf71fP6B1fT4/21ZErDakv+hatz5qX1P4G9j4G8HqN0JxLljgIduabOtuRYeEhFqB/TpD0AlzM+NC8wZ5qMtnYskqQMR5KN/B6mRLP6WWkwZRS4cDP9XV+J8Ogh91hZx6SfP/RIdc4ErY/vOD4vEoEwLOcBd/gRcKxlNhAAsXnQ4knFMhI26Sw5IwHZWyU9SuBNmwT+s5YyYHlctB4kACZ8DEMuiH4wau35hqXkLycA2eUmbI+TDYcbIjJPm7zV6e/kFN60c8pS24jMibnFqIxZxsnfSaOPtTIW/dzesEfNXVuKVFPDJhjcp+G8tP+OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from OS3PR01MB9499.jpnprd01.prod.outlook.com (2603:1096:604:1c8::5)
 by TYYPR01MB8071.jpnprd01.prod.outlook.com (2603:1096:400:ff::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Mon, 15 May
 2023 07:17:23 +0000
Received: from OS3PR01MB9499.jpnprd01.prod.outlook.com
 ([fe80::a883:7aee:71d:b4a1]) by OS3PR01MB9499.jpnprd01.prod.outlook.com
 ([fe80::a883:7aee:71d:b4a1%3]) with mapi id 15.20.6387.030; Mon, 15 May 2023
 07:17:22 +0000
From: "Xiao Yang (Fujitsu)" <yangx.jy@fujitsu.com>
To: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH 1/6] cxl/monitor: Fix monitor not working
Thread-Topic: [ndctl PATCH 1/6] cxl/monitor: Fix monitor not working
Thread-Index: AQHZhaYtfzXcgqcLVUWtddb6nTB/w69a70eA
Date: Mon, 15 May 2023 07:17:22 +0000
Message-ID: <c7927406-35e1-ab2f-a4f1-6d46309d06e8@fujitsu.com>
References: <20230513142038.753351-1-lizhijian@fujitsu.com>
 <20230513142038.753351-2-lizhijian@fujitsu.com>
In-Reply-To: <20230513142038.753351-2-lizhijian@fujitsu.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS3PR01MB9499:EE_|TYYPR01MB8071:EE_
x-ms-office365-filtering-correlation-id: 607394cc-5d05-433e-5747-08db55146d95
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 KMnwpS/KKK4Mu7Ch44j6XjyAiMAl2i+SiYO6sQtVD9lBnYYLca/K/42Yy/ISwasdpvxJ8WqeU6HEtPNXFcLAeh1AvqOoH9mhEOIpGyxvh9+HgLtRamlmA/J+dqeUhmMkfzZnQJGRc97aXWKf/ZnES5gbRH4Upf2ROtoqaqELYmKWWpuAPPgUSRoF8xpHysyZ4c/S8rgEH7X/uF/WYDoO1ncuqXg0A8VUKJYqXlTc0uv7JOGJ9lTrpFEArerI7C1Wpvd9ncWxndbgfnGW08oY+dnTg9T1KZpvLcw+qRleNDi/1633E+yOFWOVDNKMf/6K8VFat3eAruLP6uiBNGfsVwJFjcnDbomFYuUrUtEUV3k0ILERUnB7K4rHjqLeBYvQMHtLCXgURfUXwZXyK93xYVaWEFb4IMsQbFn5cJtxChm1sSguB80n6OUr6Rdgxe9y9k5mS0SUIIMo7wQqkj0HOE5KYK0nDuxrsivO6gH5e7IqDSov3APuEXfr4eJwwTelysBIwWpBQbx8XySvcy3xODQkpajtak0oFg5ae/XmittB362m5vtR6jg0OwWjyX/8AiKvrV3rSIR3EMmrUTWN9aC8xM8ny4vvtPOwGoSO5i9RanDyJ8i3QJcQ6ct0e3rp9ELeHuVOzTQvPVvE5zdYTptyxSo5xI3dFHDhA+39MJ2WtuENrMXsbqrEz5wxv+6u
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS3PR01MB9499.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(346002)(396003)(136003)(366004)(1590799018)(451199021)(71200400001)(82960400001)(122000001)(38100700002)(2616005)(186003)(26005)(53546011)(83380400001)(2906002)(4744005)(6506007)(6512007)(5660300002)(41300700001)(8676002)(8936002)(85182001)(36756003)(110136005)(31696002)(91956017)(478600001)(6486002)(38070700005)(64756008)(66446008)(66476007)(66556008)(66946007)(76116006)(316002)(86362001)(31686004)(1580799015)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MWdjUDJjL2o3ZVFrY3VGbmtWampXSm92WURweVVIamY4a1RrcGJ2aGxudGFB?=
 =?utf-8?B?ckljaXlaK0RaclZDNDJGL1YwU2NsN3cyRDlvN0lmZ0t5ZTJ3RlJjL2creExv?=
 =?utf-8?B?ZFVvaGgxVTZGNGlpazBqL3U2d1ZUVW12SWZFbGMxbEpzSS9NWnVGUXZqRkZ1?=
 =?utf-8?B?RGRmajN2UHVVV0NTaXU5dmV5L1hTSEVEOWVGbjh0V2pjaTJjdXBoMmlSYjlO?=
 =?utf-8?B?UlI4dUg3eUw4NTZFUVpGQ0hTZlY0cDNQK3RlMUpkVHZLZWFVdEg5RWdCZEhx?=
 =?utf-8?B?RlZ5T1hGTW5US1lpbnhLRC9HbWNabW9kTHhQU2NxYTc4VVNjdktxSkx1K1Nh?=
 =?utf-8?B?VU9hbnVJdXdTbWdGZVY5MHdQR245M1IyTjRMYUVDZEF6dXY3ZlpxSVlybXY0?=
 =?utf-8?B?WDY2M05hR2lOenVWZFJEUTFoMzI3ZHBlZDVaYW94M0UzVnNpbnhab0xvbjZp?=
 =?utf-8?B?ei8xM0MyL2RjeWJvRzNYQU0zUTBKYzNlOUhxNVZFMFpRNmY1dUluSVRoblkz?=
 =?utf-8?B?UHc5NVJtS0RuT1B4YTI0ejBlTEpabFZLS0Q1SXU2NFZzYisrd0JZcHh0K25k?=
 =?utf-8?B?TVdSODZORDBxd2dxZXhjLzZ2UGIrUHRqR0RJRWg2NHBOMFV2N0prSmVDbEN6?=
 =?utf-8?B?NldUU0lnRU9xQnliRGE1ZWhTWisyYVBNd01ZQWplazhHWnNvTFIvZ21tVlJB?=
 =?utf-8?B?Rkh2aklIWGR2eWJpeGZWR3hQRmZXa0tHNTRyeGlLUlc2VkliUmQ1b2Z0cUdO?=
 =?utf-8?B?YTltME95RzQyV3NSQXBzbjBZYmhLRXpjYlI1clJoa3dZbmlqbDg3dVRCM04v?=
 =?utf-8?B?U1dDdnljZElYN1RCK3RtSHRRSkxja1hrL0dkM0I2dy9TVGdIbXE2ZW1lZkpD?=
 =?utf-8?B?WHVOc25WM05jOGplcWY2Zmt1NElyOTNGZEw3MldhV2ZZNWs1QStYUVgzRStD?=
 =?utf-8?B?RkROcEV0SnZ1RFQ3aEpSZVRYZktxdnlFUTFVQS9COFlLa1luSDQ0QlNMMDNO?=
 =?utf-8?B?UGcrc3pjckxUdFZtdEpRMGVJY2JxQWt2TVNWMkdyU0FGV0RVQ3BhSG9jQWhk?=
 =?utf-8?B?LytiMlhUZGtrZmtuem9oMGVNekllcTRBTXpyeDRIbDFiS2FEU01BMW1rampF?=
 =?utf-8?B?UFdQTGVzWmkvdFFKcGJqWHJPVjduR09ITXJOY0NIeUNYV2RnQ1ZmcnlrV0Qw?=
 =?utf-8?B?MnV0UkR1cTNQNVlOQmh0eFUzOTUwb3VvQkR2OWI4cU03ZXhLMU1iMEJzaW1V?=
 =?utf-8?B?QjNES2VaR2xFMEFzb0FQYkwxcjRJbjFoaWxFbEtLV0JmR3N3NUMwOWlCNUNW?=
 =?utf-8?B?U1BqM0IrNVJsRW5SYWpuTkZHK2doa1FiRlZhNmt1OGR2WUI0ejdFQU0wdlpK?=
 =?utf-8?B?clhGRXZPcFNJZ2J2T29MbTQ3N1Y5RGNvcG1vR2hQM29yK01TUng1THRjSkRZ?=
 =?utf-8?B?RCtSUkx3WXZPOUJCdTlmR0M3M3dOQmhtQWhWVjJ3bFdLLzh1QU1XZXFjOGVM?=
 =?utf-8?B?YSs0YlNnUC9hQ1ZMNXVjeUhQQzhVLzZFb2pON0I2VUNlWGNEUHZEWmp3VEYw?=
 =?utf-8?B?QWJ0ck4vWVJwMm1OZHU4TGkrOFZYWC9pL0YvZVVpTEYzQXV3VUQwc1ozbTR2?=
 =?utf-8?B?eUU3eDZpNjcybklZc3BEbExVSWozdTBQYW4vV1F1NlpNSUlLeUxrR3pLVndJ?=
 =?utf-8?B?TndobUtqZk5EYXVPSC9HWTJyZHNjeEJPUDB0TnhaRDdvd2YvVHZXS2psY1ZH?=
 =?utf-8?B?VXFvemJiaUhvY2RWSzVJNmlaN1VZS2NaTGxpUE80ZDcxM3dINjNSRU5rUE84?=
 =?utf-8?B?bXFDaXZFdEs4ZmRvUTV0K2F2RGZrNDJEQVA2S2loSDNhRmliQzhqUjFDZzFB?=
 =?utf-8?B?SERaV3FtcGNUcWErRmkzZEh2dUZRU1U4MVg4QlJOU0RDYTcwbFdTT2czbVpj?=
 =?utf-8?B?WFZLWk91bm1IeVJSdWVPRmk3bDFRWVpNS0JpTHF6SnRXL2VtSGg1VzRxb01K?=
 =?utf-8?B?STZSSzRnc3RsQTJPNTNuQ0RFMGpyTU1NaGxaak9teGZtRDJ4bUthWlZpbkJL?=
 =?utf-8?B?b2cxZ0diczlqQTlQRFROSU54QWQzdlRkZElBZmphS2FQUlp4QTUwQzB3MTFE?=
 =?utf-8?B?K2hrcFRpeDdqanlxL2x6UkdqbHZqblY1bkJweEthSm4vQ2J3eFN1am9ka0NJ?=
 =?utf-8?B?MXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C9991252FF746446BCD46E4B623A8B9F@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1lt7IXu+NMJrDZT9iE01vkBPGyQdomA7YkhFy2DbfZK2iw1NAUgtkpDnZYJGtmI4digkH/M1AEAkrmtG0znAnmQAxi4fFvcLjus+pgfnnQJwDYDasjzEbPmkYkk4Y+pzDt2kNtXx+/Ru2OommS8pXwCmYKKqznP8/mVq4EpFYCSAzNtFa6rvXen9f+vsNarOIc9DR3M6lW6rMTLL35RIc4r6oGrGr/Q1MymON8ZEYk67nNgz1mWa2I6J8RYz9fhVZX0RQM7b+cdQcmXKgSwzDQMMkeg//vjYBdESLBFx7iyzKlZ5rnh4P901HzaTnTPSWZs1TaSt5U2QfYyjcNFAiiraSh+9SCygZJKTMUJ5nxacsFX3Sik2YoTh1TTnC5KaySIbGQwOlYVR3dPGG9/AEvpCrxaKRFSXJY/uNyNDeZ1ZkeKEifFeGGKuAGTwtqqTg1RpaiWbxwh8NtSXI6LecQqs7Tk05x/xo1IhLKElZBEA4r5cJSYUds7zd8k0JHkFMa5aKN2z4q57FXz4y33BQhKWtJOGaEQJskjNKOn2G0iMlahAM9BFFWP8ExtH+1Cu/VteY0T+4qSo6sbITFrpoEZgHysXnp+iPQuWwm/X84jAM8nt2E6FC13/Eoqa+vmiR0v3qMeZq+l8TZkzVAhDlQuzmxQC90RlypWtMkKwnkajmXtWMFw5Oj7iWMs9zPOhjrzYdmxBNkPhBsiRjdve3viFEaRExBkV9RFKiR5WxgqoXA+YAtDMECYivQGzN50crpKvEmvURhyjgBVO/WV6Lg==
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS3PR01MB9499.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 607394cc-5d05-433e-5747-08db55146d95
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2023 07:17:22.9068
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hfSokhEbgBqiFwN3WqdPHZh6j2wgnPdw6Lt9ofd8wiZ+YAlqeutdZPChl5yhVWtVPVJH9Kz5EFqme4xpDkvx+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYYPR01MB8071

T24gMjAyMy81LzEzIDIyOjIwLCBMaSBaaGlqaWFuIHdyb3RlOg0KPiBJdCBsb29rcyB0aGF0IHNv
bWVvbmUgZm9yZ290IHRvIHJld3JpdGUgdGhpcyBwYXJ0IGFmdGVyDQo+IGJhNTgyNWIwYjdlMCAo
Im5kY3RsL21vbml0b3I6IG1vdmUgY29tbW9uIGxvZ2dpbmcgZnVuY3Rpb25zIHRvIHV0aWwvbG9n
LmMiKQ0KSGkgemhpamlhbiwNCg0KSXQncyBmaW5lIHRvIHVwZGF0ZSB0aGlzIHBhcnQuDQoNCj4g
DQo+ICAgIyBidWlsZC9jeGwvY3hsIG1vbml0b3IgLWwgLi9tb25pdG9yLmxvZw0KPiBTZWdtZW50
YXRpb24gZmF1bHQgKGNvcmUgZHVtcGVkKQ0KSSBjYW5ub3QgcmVwcm9kdWNlIHRoZSBpc3N1ZSBh
bmQgY3VycmVudCBjb2RlIGxvb2tzIGdvb2QuDQpEaWQgSSBtaXNzIHNvbWV0aGluZz8NCg0KQmVz
dCBSZWdhcmQNClhpYW8gWWFuZw0KPiANCj4gRml4ZXM6IDI5OWY2OWY5NzRhNiAoImN4bC9tb25p
dG9yOiBhZGQgYSBuZXcgbW9uaXRvciBjb21tYW5kIGZvciBDWEwgdHJhY2UgZXZlbnRzIikNCj4g
U2lnbmVkLW9mZi1ieTogTGkgWmhpamlhbjxsaXpoaWppYW5AZnVqaXRzdS5jb20+
