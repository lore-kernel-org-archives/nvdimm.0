Received: from esa4.fujitsucc.c3s2.iphmx.com (esa4.fujitsucc.c3s2.iphmx.com [68.232.151.214])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B249CA6E
	for <nvdimm@lists.linux.dev>; Mon,  9 Oct 2023 09:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="ck6mlOzW"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1696844482; x=1728380482;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hpIwsdDrg6JtCSLJcalchgfYYNnilnLLvhGnQBnRcis=;
  b=ck6mlOzW+iGsnWa2uHS5BtzB5Yr0clZGiT1/Tj/UH/JwlAFiD9g043yh
   J0smY53yxsZA42TbqFNpuc8Kpq1BKlJGk2lDFOHZ0NMTsFkcsmPLGiwfG
   lerienEBvojclD1B09zT0DlZxPiL3BFVN0xLXapGod84o2e0k+xRCx1C5
   mXYt0UNHxm7bEwDs0FuUTGIlBJ2VyZL+/OwOVQNUCCPJHtpgXEHw5wsgf
   tgc9DnvbIQV3qHTs9tmC/5yKj55kxUiHlvuMoaRRUZqmHvSQtv9vkpX7U
   WJFEVTJp7En0K73wFr3X+9AfIxtLLmEhbsIsH4USJybkMN7g699VauSJ7
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10857"; a="11374714"
X-IronPort-AV: E=Sophos;i="6.03,210,1694703600"; 
   d="scan'208";a="11374714"
Received: from mail-os0jpn01lp2104.outbound.protection.outlook.com (HELO JPN01-OS0-obe.outbound.protection.outlook.com) ([104.47.23.104])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2023 18:40:08 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QRMoGBkG9Ew61qUEDSAhygEKDS8veC40vbj6Y4sFq2yWGYRvzHuPViDTQfjPXl3fobMhq4YQiXTaobq8qc1PVMDYvOYfmPTKSW7alzrcqX6DwNqlZTbkmHapXFaNqHVO2R/K6Aq9AKoYXzBwJmAsVi0PT4r+ZKvYm96lq58j8DJlhgaYGFWHQi8SSxbomjiyKuZ5KztOHZnltP2hQjF+BCE3HXwNddPPl8peAx6vzzHNtuYXtzp9dYJijTZMNlEMlNy/r/HdVFSUte4YiwbExrGAdDs03ZFpTai1xS25EWQg0kKePE3doVT2ZtNL3KmlfdE2zimLP1mTrKnRzU0wqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hpIwsdDrg6JtCSLJcalchgfYYNnilnLLvhGnQBnRcis=;
 b=g2xCVBEaH0fpYLfO0hxLpRI4ByE49+Xbf/e1KtvfM1+zkePYkmJ5fxAz6Ghw9TRiViPPZrfBnJIX++WMXGRTLrP20CW3Uq+GThFPza01PllT9UpcxCZOHKhTZdLGanO8Qhbd0bo1khPrSPaBKzp0Ra6vca8MI6BgaOzMAEjkhEaIWFyW5bWOt0AigN+zVuFRRAIY0EN5yWHjAbDrAUExuXmC8h1Loqo+xak8y6JcRllmv2drwfuCNDbtGv2G0vDhFFKBHkAH2Kg+ZSDroJX94FWxMnZAINTRBmqNaIDKMzv13I5XH7T29F5QCgIawbAEYFY54/qTEdoIQjSIcan4kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from TYCPR01MB10023.jpnprd01.prod.outlook.com (2603:1096:400:1eb::7)
 by OSRPR01MB11423.jpnprd01.prod.outlook.com (2603:1096:604:233::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.36; Mon, 9 Oct
 2023 09:40:05 +0000
Received: from TYCPR01MB10023.jpnprd01.prod.outlook.com
 ([fe80::deb2:2f3a:1a57:2722]) by TYCPR01MB10023.jpnprd01.prod.outlook.com
 ([fe80::deb2:2f3a:1a57:2722%3]) with mapi id 15.20.6863.032; Mon, 9 Oct 2023
 09:40:05 +0000
From: "Xiao Yang (Fujitsu)" <yangx.jy@fujitsu.com>
To: "Xiao Yang (Fujitsu)" <yangx.jy@fujitsu.com>, "vishal.l.verma@intel.com"
	<vishal.l.verma@intel.com>, "fan.ni@gmx.us" <fan.ni@gmx.us>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
CC: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
Subject: RE: [PATCH v2] daxctl: Remove unused memory_zone and mem_zone
Thread-Topic: [PATCH v2] daxctl: Remove unused memory_zone and mem_zone
Thread-Index: AQHZy/Fxj+S4xknHZ0GGKBhwY0un3rBBkTKg
Date: Mon, 9 Oct 2023 09:40:05 +0000
Message-ID:
 <TYCPR01MB10023F98F51B2AFE3E6B65A0E83CEA@TYCPR01MB10023.jpnprd01.prod.outlook.com>
References: <20230811011618.17290-1-yangx.jy@fujitsu.com>
In-Reply-To: <20230811011618.17290-1-yangx.jy@fujitsu.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ActionId=ab63174e-e8a2-4a32-b2f4-4e56e5a7dff4;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ContentBits=0;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Enabled=true;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Method=Standard;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Name=FUJITSU-RESTRICTED?;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SetDate=2023-10-09T09:39:47Z;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SiteId=a19f121d-81e1-4858-a9d8-736e267fd4c7;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYCPR01MB10023:EE_|OSRPR01MB11423:EE_
x-ms-office365-filtering-correlation-id: 8d5a6236-9b77-412e-9d0a-08dbc8abb804
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 jGqjtYsr2azUAelkD4Mu+pPTrcXZFJ6JsM5ZP/naol169I/HfYrooXG9PQTbZcaauHLAwO4EX4tcM5R99djBXeX2XZ9rNsEd6wFFChQVJAQlumBvkcRSSk0nhRB69I+UNIxRBLeuKcdt1bCEZI/d7vGnb3lEmeH5EMxht1HL7nyLR3wHgTIfSpzJBbFWKOoOfrahfNrG+Uru4p1RUgQQee0iJnCDlF6CVMWyPCrVxpIi796qOhRGUPLzRnpSGAqLfR0Jvb4iyd0GOPURLnlodtLfsJ6/NLuxodb9tGPXOF97H7+SQCk1/JB5TyJRXeso6WHsBbl7pLl1sFXg9OXPD/SkVrpAS28eMm0QA62d1C5YgUOuqtbFtixvX6n0ER+6N/rfergfdCwSZogr6raprDdgHB7WCVRx/DDAmyZeZXdgtfiK9qCw6JccH0GBq1MAh5A3XyV2D5serWBCvmZw6aaf/mPxM0IzwbmmniDL1J++k19FzjScHbK4ohp7CTr4VrYefG1TVkN/DgHHuX1hoaSlE7sBAHu5ljTg6A4nLiVCQ/MVztg+OxtzBoeZmd+iUbh1Bjl8ukMK9wd7r5Qcy/sedrzYVaY1dCsm6XHpdVEL5ZHck1BRvl/6LdXjHHvrqWXLZN52pL3SmyD87TMen1eNi8wCulY1b9y7NaXO2wk=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB10023.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(396003)(366004)(376002)(346002)(39860400002)(230922051799003)(451199024)(186009)(1590799021)(1800799009)(64100799003)(2906002)(1580799018)(33656002)(53546011)(9686003)(26005)(86362001)(85182001)(6506007)(71200400001)(7696005)(478600001)(83380400001)(122000001)(82960400001)(38070700005)(38100700002)(55016003)(64756008)(66446008)(66476007)(316002)(66946007)(66556008)(110136005)(76116006)(5660300002)(4326008)(8676002)(8936002)(41300700001)(52536014)(520744002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?gb2312?B?OVFYL2RQYmZRTkNCTzlSeDFONlo0VmF2NzFsWXBqZk9nNi9jNzl0cUJHVkl6?=
 =?gb2312?B?S3Fhc3NrTFhNSGZRczFlREJnSkFJbXprTzJrQXRHamxnVlN0R0JPQXluTWRY?=
 =?gb2312?B?QjAwOEZLbFIrZHQvZHIraUJhMHFBSWdqWGlFL0d5TzRYbWYxSE4zbENHRlp0?=
 =?gb2312?B?VWE2bi9oUFpoZ0hVN3lKaXc1WXluRzM0OS9XaC9kcVJhdkhlS2hwWTlXUTRp?=
 =?gb2312?B?NE14aERSakcwblkxenI0TDNzcjhOVUd6bmZQVEdBQU0zUVQvMTh0OExEMW9Y?=
 =?gb2312?B?QlQxVVFzcUUrRWN5bkNqcjNrRTZmcjhCSzFFVFJ1aGo5aUt0c2ZHMUFiKzJp?=
 =?gb2312?B?ZHVwSFJqcnJQVDg2TytpK09OWDVEaHlrUy92WTl1eEdMcTI0TUw0MmF1cEEx?=
 =?gb2312?B?ckczWktDNjcwVjl1djZ4bmFLeUIyTjFtY2NlRVJxVlU1TVpHQ0ZVV0lsUDdz?=
 =?gb2312?B?TnFXa0l1QlEwcjBtalJqeHhYdng2c1p1dzdreE16VzZGRjBPZDRhTUw3cWVw?=
 =?gb2312?B?Vit1ejNONk12TVM4eERZNml0ZGdRMGVyWkp0T3NocWJIdHp6Y0JpeDNLSXM2?=
 =?gb2312?B?ZkdYZC9ZY2xSQ05MeVJjdFBzYlQ4WG4wOTc4SS82dnRzQlJRc3FsQXpjVU9R?=
 =?gb2312?B?OFduR3F5RkJmL0RnTHBOb1hkRGl3UUoyMDVrdTlBdkJYL0NEQ2tNWFoySU5D?=
 =?gb2312?B?NnRyZE14bGlNY2Vtdk1WTXpXZGlJeTZpc0k0N294TGRUY0c2bmZlclhXUS9y?=
 =?gb2312?B?YWI5b3RKVzlrdTZiQkl5UithWU0zTlBxbU9WaVhJTjArZkd4Q1FoRkVVTU9w?=
 =?gb2312?B?SHIyMDNTOVJDWG9hSXVTcFJQbHdnRmdPMWNwdXRGTlZ6STFncTdrR3Q0L2JC?=
 =?gb2312?B?N2tTWUJDcGdVb0h0cjlDb2owTVluR1ByUjZnRVhySTVpeHFDajdISk82cHdX?=
 =?gb2312?B?alN4azE4SERudkFEblorSWFNQlQ5b3N4NHNBZUR0eWhMb2VkRnN5cEUxcyth?=
 =?gb2312?B?aHpZVVlhZyszVlorQjdQWHZxK1l5OTF0dnJJemNYNE54K3VLUGtNMzM4eWJv?=
 =?gb2312?B?dUVUR3dRVzRlM3NJdGF1Y1RzSi9FSFkvM0lPWm4yNnVQVkY5TkR6MDBNSG5C?=
 =?gb2312?B?aTQ1L1RqaHJrWklpenhuNGZSSVFNTFcrMDluQkVDRnd6aElYdUh3TGpOZ1RO?=
 =?gb2312?B?K3hRYmUyNXdDL1pSUjJUeTFscktnOWlpM2wvcEFPQXRRY0NUQy80STJSbjhJ?=
 =?gb2312?B?QkQvaldicWI5eHdkSldmejR4ZjJaWWczeUZHOHJQcGJuQm5rNHhIbXBtaE5P?=
 =?gb2312?B?N2M5VkZYem9pdDRKVXQ2WTdLbC9QUFM4MlhyczVlMFhNUHlKbDVhakF1RnhO?=
 =?gb2312?B?a1Y2a2VHSENJUTRJdk56K3g1SWRkNkNzQkhXaHhJakQ2aGdoSkdvT2Rzdkxt?=
 =?gb2312?B?cFVVOCtRYVNPTjRzSUNyZmF1eTVGSWRpa1Y5eWNEaWtHWkV0eUVoQUJrZURJ?=
 =?gb2312?B?Nm1Ga3pseHdVVjV1TC9uaTZtTmxBbS9aVURIWTNFRUN3VDBnZGEwQ3pwTWIz?=
 =?gb2312?B?a2tyMGxYcGg4YUlpV2NGSGJna0JkVnM3OUxYTHJFYUpuMWtMUXZrbnRDVzkr?=
 =?gb2312?B?dVhzSTc0ZmQxTjhzdm5pTWNXeDhuamNpVWxEcFF2a2pOZHJzU3RjS2ZKcEtj?=
 =?gb2312?B?Vk4rdDNUSS8zUEtOeXBwZE5KRE42RVBGaDUrMkk3Z3pieFMwOC9YVEY4cjFp?=
 =?gb2312?B?bDJ3TTBsRWcxTVRmZENhdnBHNnk3WjVSREtaTjFrbHVvVnYrTzIveDV5MDl6?=
 =?gb2312?B?ZnYvblRuYk1JdG83ejFpOW9aQzFkZXVXT0RIMVM0VkFYcnVDcUIzRDVVaVVY?=
 =?gb2312?B?S0FTMktaajc5czhHZm91aDVqRlBocWVEMWM1Z1pXOEhGMytqQ1JXbFVOdm8w?=
 =?gb2312?B?V2VmeWNSSXBmSnMwZW9nRnRFZmpYcXF4eEFUZnVGd25XOEhENkJyM3d4dFNj?=
 =?gb2312?B?MFR4TzdwKzlRQUNqVFl0WllZbVZxd04xTmhsMHRHdjdBd0tZVENrSWJuMXhv?=
 =?gb2312?B?d3duSGNMY2VaRWxHNTZ0am5WeWVNVVp2eVVhZE1GZ0dvdy9nZ0JFQlA0ems2?=
 =?gb2312?Q?j7CsUFNhx/YTmixC3aHZ0QCBM?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	d8Mm3+L9k9MmxXuPgnm8eKSw+EbYcZpddgpqog0dZ6j0Pa5hzelkUZbm3lM7dvmfvQwnNeEiRucsqM2LbWQZnN4jxyOWGZz8H38/p7nERhgPIgGaaz+f2KIN9Z6+HKVPeS0/tJ/6bNNuPETmQyPB7OwdZTO77iSNY+Vo4aOIof5Ub4PbnzG4dzq2zRTkjbvVEOJ7kerjUXuHQ8AxrUvKvhbxYOiLjzYt8Z/DNH/buNMs+NEjdXutbA9lD8PbKsNx5virvDls/WNKP7609iHA28yZ7lIG42olrqrGRX03bter6gqZyfRTm/HWqsjfctbI5qgY06iIDo/bHZFr+aCQj20cKWhbQLU8DFhT9tzuBXHgObn6O2PumjKz4UZCk6RVxWEDumIUHHIG/Dl3qmsmps7NZpob4D4nMzFYaIc+E7Ez366FVI+tA7kldEcT4NRudxkpbC5ZkcGekTvutSkdJGvNriBDfY20x62zsqyWChAmgUPhCvoULtgySG3QZyk0arUezVWNUw22C/2jB9fVjmaXoqFeIPrFnD8Cm8rVi7StL2E1jWTUJx0vAle27aeCA2NwIsI+GTZf+bi/fziHv6L4uYCep3F0L7GFAOj2SrBFX/Ea67+rja+VaJmFoQgnGYj/XmsKjfzECGauFyo9BtwCW89BVNH8SndbxsTPQNGg00rcBZXzqJiItuEhCyw7sNoiTh+pqSkpWWqJNxNGfeS1JC1Z3TVuRxFXsr2WvQLYULyyhw8NWH3EjyB3Cmlyftme3EdEZAqU1uSXHqTlcEx9j9L2n4L767Xs/yK1MKbVhpDDQaagSIWRWuzfs5GSyjFKUrvG5GHNZVPzSLdzJwAqWNU2r6NwH0fdN0AI+Ic=
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB10023.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d5a6236-9b77-412e-9d0a-08dbc8abb804
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2023 09:40:05.4747
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tTWfykR0DQCFN8F+xeYxX8itCUCEks9M+V1u07lpSKdk7D2gpLI+kg1BOM9GGgf8it10xUbYO7spKcNDKE+UBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSRPR01MB11423

UGluZy4gXl9eDQoNCi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQpGcm9tOiBYaWFvIFlhbmcg
PHlhbmd4Lmp5QGZ1aml0c3UuY29tPiANClNlbnQ6IDIwMjPE6jjUwjExyNUgOToxNg0KVG86IHZp
c2hhbC5sLnZlcm1hQGludGVsLmNvbTsgZmFuLm5pQGdteC51czsgbnZkaW1tQGxpc3RzLmxpbnV4
LmRldg0KQ2M6IGxpbnV4LWN4bEB2Z2VyLmtlcm5lbC5vcmc7IFlhbmcsIFhpYW8v0e4gz/4gPHlh
bmd4Lmp5QGZ1aml0c3UuY29tPg0KU3ViamVjdDogW1BBVENIIHYyXSBkYXhjdGw6IFJlbW92ZSB1
bnVzZWQgbWVtb3J5X3pvbmUgYW5kIG1lbV96b25lDQoNClRoZSBlbnVtIG1lbW9yeV96b25lIGRl
ZmluaXRpb24gYW5kIG1lbV96b25lIHZhcmlhYmxlIGhhdmUgbmV2ZXIgYmVlbiB1c2VkIHNvIHJl
bW92ZSB0aGVtLg0KDQpTaWduZWQtb2ZmLWJ5OiBYaWFvIFlhbmcgPHlhbmd4Lmp5QGZ1aml0c3Uu
Y29tPg0KLS0tDQogZGF4Y3RsL2RldmljZS5jIHwgMTEgLS0tLS0tLS0tLS0NCiAxIGZpbGUgY2hh
bmdlZCwgMTEgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kYXhjdGwvZGV2aWNlLmMgYi9k
YXhjdGwvZGV2aWNlLmMgaW5kZXggZDJkMjA2Yi4uODM5MTM0MyAxMDA2NDQNCi0tLSBhL2RheGN0
bC9kZXZpY2UuYw0KKysrIGIvZGF4Y3RsL2RldmljZS5jDQpAQCAtNTUsMTIgKzU1LDYgQEAgc3Rh
dGljIHVuc2lnbmVkIGxvbmcgZmxhZ3M7ICBzdGF0aWMgc3RydWN0IG1hcHBpbmcgKm1hcHMgPSBO
VUxMOyAgc3RhdGljIGxvbmcgbG9uZyBubWFwcyA9IC0xOw0KIA0KLWVudW0gbWVtb3J5X3pvbmUg
ew0KLQlNRU1fWk9ORV9NT1ZBQkxFLA0KLQlNRU1fWk9ORV9OT1JNQUwsDQotfTsNCi1zdGF0aWMg
ZW51bSBtZW1vcnlfem9uZSBtZW1fem9uZSA9IE1FTV9aT05FX01PVkFCTEU7DQotDQogZW51bSBk
ZXZpY2VfYWN0aW9uIHsNCiAJQUNUSU9OX1JFQ09ORklHLA0KIAlBQ1RJT05fT05MSU5FLA0KQEAg
LTQ2OSw4ICs0NjMsNiBAQCBzdGF0aWMgY29uc3QgY2hhciAqcGFyc2VfZGV2aWNlX29wdGlvbnMo
aW50IGFyZ2MsIGNvbnN0IGNoYXIgKiphcmd2LA0KIAkJCQlhbGlnbiA9IF9fcGFyc2Vfc2l6ZTY0
KHBhcmFtLmFsaWduLCAmdW5pdHMpOw0KIAkJfSBlbHNlIGlmIChzdHJjbXAocGFyYW0ubW9kZSwg
InN5c3RlbS1yYW0iKSA9PSAwKSB7DQogCQkJcmVjb25maWdfbW9kZSA9IERBWENUTF9ERVZfTU9E
RV9SQU07DQotCQkJaWYgKHBhcmFtLm5vX21vdmFibGUpDQotCQkJCW1lbV96b25lID0gTUVNX1pP
TkVfTk9STUFMOw0KIAkJfSBlbHNlIGlmIChzdHJjbXAocGFyYW0ubW9kZSwgImRldmRheCIpID09
IDApIHsNCiAJCQlyZWNvbmZpZ19tb2RlID0gREFYQ1RMX0RFVl9NT0RFX0RFVkRBWDsNCiAJCQlp
ZiAocGFyYW0ubm9fb25saW5lKSB7DQpAQCAtNDk0LDkgKzQ4Niw2IEBAIHN0YXRpYyBjb25zdCBj
aGFyICpwYXJzZV9kZXZpY2Vfb3B0aW9ucyhpbnQgYXJnYywgY29uc3QgY2hhciAqKmFyZ3YsDQog
CQkJYWxpZ24gPSBfX3BhcnNlX3NpemU2NChwYXJhbS5hbGlnbiwgJnVuaXRzKTsNCiAJCS8qIGZh
bGwgdGhyb3VnaCAqLw0KIAljYXNlIEFDVElPTl9PTkxJTkU6DQotCQlpZiAocGFyYW0ubm9fbW92
YWJsZSkNCi0JCQltZW1fem9uZSA9IE1FTV9aT05FX05PUk1BTDsNCi0JCS8qIGZhbGwgdGhyb3Vn
aCAqLw0KIAljYXNlIEFDVElPTl9ERVNUUk9ZOg0KIAljYXNlIEFDVElPTl9PRkZMSU5FOg0KIAlj
YXNlIEFDVElPTl9ESVNBQkxFOg0KLS0NCjIuNDAuMQ0KDQo=
