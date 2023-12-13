Received: from esa16.fujitsucc.c3s2.iphmx.com (esa16.fujitsucc.c3s2.iphmx.com [216.71.158.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14764418
	for <nvdimm@lists.linux.dev>; Wed, 13 Dec 2023 07:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="r+pUbOvN"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1702453847; x=1733989847;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Ha1XLziJkYBIXHwBYK+ffN4gznqDb1ECvaJsEdbCYGU=;
  b=r+pUbOvNNBRrOx1kfiWUqFxmxPfkJG+lQ0+AXLr7VdXDXU1kz6+CsEyL
   NCpsiEU00Pu12CEJEWRXVKMGKPaDVCGP/PxDw8KNYFE4t/9dX9htrQghA
   L9Mqb+GR8UJpKc36FN+cO4iYxAhI8uzqxQvCwdbwEC9cjLdVcvmbAjPIO
   uk3x9SrFQ89Qiu0ZLgNzsXLaBvmAqJme3nF5mdkYimOayudGYdGv2FT1X
   xgnPWLnXekEpHnxrdVwbo7+u7+0Sn3DlvZi5DsEHS6N2oJvpf2aIizaLp
   aqdp6oGXKXK52iam/Rqmk6TA1jraqKk7FbrCHB4I9NVwB66456IkUImr2
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="105556915"
X-IronPort-AV: E=Sophos;i="6.03,238,1694703600"; 
   d="scan'208";a="105556915"
Received: from mail-os0jpn01lp2104.outbound.protection.outlook.com (HELO JPN01-OS0-obe.outbound.protection.outlook.com) ([104.47.23.104])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2023 16:50:37 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jLusojSA1suKQSuM9nJjw+5KIAvYd/8eMh6VFZX8TRn0ns9c/4kbpBKU3NuDXUfqYA3FeWhYT1pAyI+ZhW1Rd2mkRrSviNzGYLUVIlrairLOwyG0oqRAPFipsMTpRPZVYN6hQCiyovKGMwRUCGEFkhb8KygsUO2yySFfJnwB60/Oins5p4nQCvL3hBifXo9KZe3i6dlMNmzBaq5wxOtDeWvYjQkcv2Fz1Pt+SEdHWaT6wnwonuiIaLHeHCUX0KDhrNRg/BTonNiifuCpbSqS4NaBnCBvOsdqw6q52sGVvelaTKsWXiXH1/nnul+FrZ0K4Cp7mYjgj8pe0lI+Y6i3JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ha1XLziJkYBIXHwBYK+ffN4gznqDb1ECvaJsEdbCYGU=;
 b=lE8rkEVSbHiwG0qsU5pX/X8NO/ZHkAk/GtsH5C1YY+DcWrCZOPyzs9h55oTThLyMf/Aa36aeD8bo9rrNK17Enm7oP9es2wKQY58tgEvVUy8WzWfV0Vau0YDU6oS4XSEr2yKfFpOOTHfNx8I5YOUX9uSMDTYc5S4vp7B/4NW7zOiac3CauNoyQfTRO7AOAy2+8hQgDMsKhzG5CweOsGcelNCuu5WnoiyM95Ajx+ucmwB8OMlpCK+CeCwSdOmBCgcD73rm7I54vWgIRW/D3+00yiktybkUSV1PEzrOJwgDah9QWnaI7m5fMo5LjfgG52uImd/9vj5hy2E9IAkWhjtJCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from OS0PR01MB5442.jpnprd01.prod.outlook.com (2603:1096:604:a6::10)
 by TYTPR01MB10954.jpnprd01.prod.outlook.com (2603:1096:400:3a0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.26; Wed, 13 Dec
 2023 07:50:32 +0000
Received: from OS0PR01MB5442.jpnprd01.prod.outlook.com
 ([fe80::c96f:52b0:dd4e:8d50]) by OS0PR01MB5442.jpnprd01.prod.outlook.com
 ([fe80::c96f:52b0:dd4e:8d50%6]) with mapi id 15.20.7091.022; Wed, 13 Dec 2023
 07:50:31 +0000
From: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>
To: Dan Williams <dan.j.williams@intel.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
CC: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH v2 2/2] test/cxl-region-sysfs.sh: Fix
 cxl-region-sysfs.sh: line 107: [: missing `]'
Thread-Topic: [ndctl PATCH v2 2/2] test/cxl-region-sysfs.sh: Fix
 cxl-region-sysfs.sh: line 107: [: missing `]'
Thread-Index: AQHaLM7HYz+XqJvf30eOWT5WBTZdzrCmQGGAgACYFwA=
Date: Wed, 13 Dec 2023 07:50:31 +0000
Message-ID: <68e56559-d69c-4209-bb8d-cc5561b67fb5@fujitsu.com>
References: <20231212074228.1261164-1-lizhijian@fujitsu.com>
 <20231212074228.1261164-2-lizhijian@fujitsu.com>
 <6578e2b1609e9_a04c5294d3@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <6578e2b1609e9_a04c5294d3@dwillia2-xfh.jf.intel.com.notmuch>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS0PR01MB5442:EE_|TYTPR01MB10954:EE_
x-ms-office365-filtering-correlation-id: 0f280845-b0f1-4d9e-3142-08dbfbb02ea6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 5O941vgflhQWOGuvgUuAhCta5yAlbndo/ysKcdBrf+5oHN7B5oF5RcWKZ5Tf7TAb7tNdHBcxPRr9hu6sRjxss0HzxZ4XZnzSWSxmMYnarharRfhU0wbmiKtgcpFy2aele3fMNI/1Qs8xCxGKNRe2GHYgM9GxLdNdBTQjKGGg8IpUafxUlmPvVeANiBPpTzGuYNHHlc8oPnl6+kzDPzDcqfivhG5TJ1/KJz0WIeA8FevCxbTZUeXHe2vfrXU9mkR+s/mQVtUiISFuW9JX+yK8nk1AQZ/38FqFDvvbtrYUx204SG2VcD0AviwPx68pEUTfm/Xt3kY0+yh+ccv3Ig1wevVpgN5c46HkNrdNLj7wEhDKngg1Zj2wRYlCrbD2zC7643RLsbhhniDbPBpqPhW/TPtmOIUuwkby81E2fVHa35tCUG+zim/NjuNwOpT7/yUWjwb484gigmYZ/q6X1Z+7iVZek8BDkKAnbr0Dskp8ZCGvSFjvoQPfpGBbPO+e+LAv/fhUjKvakzMMrsshmXAHYtWtwO2PTDtAjGk/sMW13TMWadNc16sBjbMfO3kgBtMErH+OX3EoEhjuVwxAAq0fneLEBYiy5T3Pfhp5R33lJ46cXX6zmdZvA3qoFXrZOCm99R2/WV2xTObD2CsUHi90pT32zJaQauHr+6HYOXhlR7MrZzK3dAA0blpIbyEGSShBE8mgwl5aTpY22nM94Q87Kw==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5442.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(136003)(346002)(396003)(39860400002)(230922051799003)(451199024)(1800799012)(1590799021)(186009)(64100799003)(1580799018)(26005)(86362001)(83380400001)(6506007)(53546011)(6512007)(2616005)(122000001)(38100700002)(8676002)(8936002)(5660300002)(4326008)(41300700001)(478600001)(2906002)(6486002)(71200400001)(110136005)(316002)(66556008)(91956017)(64756008)(66446008)(76116006)(66946007)(36756003)(31696002)(66476007)(85182001)(82960400001)(38070700009)(31686004)(66899024)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Ym9DZTFPSUVBNnR5ci9peWpFV0x5R21IL2lKMEcxSDlkbFpSOU8yaDQ2dkhU?=
 =?utf-8?B?SHBCTUUwckxNeWFrdytiTlE3VWFTN09Zc3R0UGNGd3FJRm4wQmh3TDdYNlJS?=
 =?utf-8?B?Q00ybU40M05XbjlnelA4dEhkUllpWmQ1S2p4UVdSbWZFS1lmT2lObGpSYlVH?=
 =?utf-8?B?OXlOSWNPSGxUeGlPQ01oemlWbnd5cmtHbDRQOFhteUxQelVrRXJPMTFEd00w?=
 =?utf-8?B?WnAwTHdmRll1SGlLL3g2NU11QVdUTFYreUVOSnNVQTNHeEFTUFdMTVkzVzBU?=
 =?utf-8?B?bkVOZSt4ME5zYlYwaEdOUCtGUjdieTljeEF3TnZIejdYYXNyZForME9VUVVL?=
 =?utf-8?B?Yk1JWTRnb29jdDlWRXNKNmxxTTFWVzR6d3Rha2lQTnNZR3VWT3R4RlNGRm5F?=
 =?utf-8?B?SHJXN1hNb0loZXVKSFdrZDNBdTBhRjVHbWxnNTFtNTZidFRuS21VdjJIdHRB?=
 =?utf-8?B?L05qL0ozUzJFRUxiZ0k1TVdVRXNOdzVsYzg3U1c5c2daZC95MGdkbVZwa3BY?=
 =?utf-8?B?SXgxM1BsMFY1bElUWmk2NWpmR043WEkvMEY3Q2xtcVp5UndVdjBCZVZuT3Y5?=
 =?utf-8?B?TlZsUkFqZE1HQTRDNWRlMWNxcXRqeHY2bW8rZzFGMnVTTUZEMFpSQlk4WDhX?=
 =?utf-8?B?NnpiZVdNdVRIVmJaNTFwbzQ0b2F0Y2lGSk13U0Nsb3AvekxtMWQ0SG5LMTBo?=
 =?utf-8?B?d3RWZk82ZmE1ZXVtamJ2c3lFY3FlNlVIMThJeVUvblNoamljTGlUT3hxVy9T?=
 =?utf-8?B?ZkNMMTVlaDZjZkR2UitiMjAyZm1LZmJBZ3RlSTdGeHZiV09XKzFUL2xDNDhx?=
 =?utf-8?B?U3BwRVRqZ0FKNVBPcnVFZXBCeVc5RlZZWXQ4c1NxREo1M0Q0MysycmVGcS9u?=
 =?utf-8?B?SWYrRk5ZaWNaT3pKTE9jSFNWbHVqc2VNWUZHZXVnNWl5NGlYQWtkYUIxazVS?=
 =?utf-8?B?MXNkNE0vQ3R4SHhDdmg0bUp0NW9VNlAzM0ZrV2t1VzdkUENIOFR5WE0zWDJU?=
 =?utf-8?B?OWxGazlTaTVWMVgyR2V0MmlnSGg3aDI1QzI1NGszN2ZjaHFaNWpxK2F5cE9O?=
 =?utf-8?B?V0c2UjR0bUwwUGN0QXFwME5sUTVZc0dQMEc2WW16RWVYNnF6U1AxcUZ6TzI2?=
 =?utf-8?B?Y1NPcmlCYmNmTHJjSC9SbVdzaXZXWndvREpoemVsM012VHlKTlNDNkN5a0Vj?=
 =?utf-8?B?SjBZcy9wVUVGMjJXbEdMdUtoTUtlVG1LdnVJVmlyZDV5TGI0eGIwVThoc3dT?=
 =?utf-8?B?NHdOVjh2ZmZoNTdVN040R25LdUQ4K0xwRHU3UmhDMWFnandKL3lTMStVMStl?=
 =?utf-8?B?cnRQZVRqcFlxYXQzVU4wUEVQU2JjM09FZlJENkMzaDVObjNETEc0UWVMOHlh?=
 =?utf-8?B?MVRRT3FiQVJNeHptdEV1NW0yUVEwNnpRbzhmcUxZb0xZTnhRblZWbm9QbTlt?=
 =?utf-8?B?eW5BUm9PK3JQS01McHpqM05GTFZOZEhmaEU3bGRBNUtCTTRJTWRmVTRzUUJQ?=
 =?utf-8?B?engrYkRtQ3EwTTAzaFR0V2htVDk0VVJocGxUeUZlRG9rUkpkWEhVS2NuY05o?=
 =?utf-8?B?ZTNVYnM3aVJSVjF6c2pMOW9kZ2VnS3ptWTI3L3hKSE1jajNGeFZHUmxLbDIv?=
 =?utf-8?B?MlNBMURac1dYMndndE1OTFh4Z3pBem5HcmVJdkt0SXliSFdkQ1oveklCNmlO?=
 =?utf-8?B?aE56UlYrQmdRTWl0NEdrVjJyZXBJYUNpZXZZa1pOc1BUandQbmNnUkdlUEtS?=
 =?utf-8?B?SmxocHQyU25ybS9rWWEzTHVtZi9ZWXFWaVlNdXh4S2hCTjlGRnpKdFhuZ3dB?=
 =?utf-8?B?RlI5MlM4UVNQZlNTWEdXZ0NFalVCOHNudlRobUdRTUk3enpNSzlnME9CL00w?=
 =?utf-8?B?NzA1VG8xUi9tU3YxbnVmVXlHVmFNNDdXT3VJRTdqTUNzTytUQWJlUGdwRVZW?=
 =?utf-8?B?Y1Z4OWNCRU5PZG1JOU9iWEU4aG02V0pLZ0JqclhvTUlPcVlVSGFidHdKV2R4?=
 =?utf-8?B?eXZaa1pwV3ZwaGxtVnJqb2RyMm9sYjR3VzErT0pKK2hqZTlUcEtqRmpDNnEx?=
 =?utf-8?B?ZWxpa2pxdGhtS1FsUUo0T0M0SW5jblpHelJOWEdDRGlEM3FJSmg4K1RRTEc3?=
 =?utf-8?B?VnR5Sk8wUDFRRWpiTWdQdjlacFUzeERIN1ZwNHBPSHlYeG5qVkdEMjJ6SXkz?=
 =?utf-8?B?K1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <717D2B12E50470478679E5EAFF88FC22@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	EBMPv9xUh+Cw7m63guV5pqvoXwBYvf8QPfuiFqOKJv+M3Tw1vpPbBSH6Qhml5iKgbSELoScfn7MCq5bnphjxwp9uCfCwz8obmCgmBeq40GVUtQkeThbllGpg0TzCiE3vYLGqAM86zkvZY1FXtXNT6JLjS2fYtpPH4YucdP+RXEGw4uynruudx18nzIX9Sp0CkgJiCsEF57bBgc6VOGbmBndykEu0f5dIEz58fCyW4tIrQSFwn3ku5BJ5noQYT7CuuVZe55ViOeFdjEYzRsL1S5aoaVKmMCi2kEzI3gIYPT68TTnac/sHmt5kgrt0J9VYOpV6jWCdRo2FN2fV+ztUQH8X3e1kPshE5Ui2AeCXxAY2zgOKyup/MIvsJy9ameNeP90PSg7nXkF1ODdCLGWXT/0rRMha9Vnz3SahR1aFhe/JsuQKNjIVKdi9lvvf+MCRAVC9T5loDoaMVpirtgYiojCrKN2XBn+NvpvUxfjO0cWCIaIds2Ysh5nxb/CAst959LqsXTgaOlX7717Ck8kmdBUpdcs3QGfr7fB0ZM2uD9Um0408EMx7tOZVJUwEIDOItgZl2M4ueWnweKm/WUMmRmqbPq0a5QFvZapoLvNL/Ge803oj651CfvHYUELIk7/3
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5442.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f280845-b0f1-4d9e-3142-08dbfbb02ea6
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2023 07:50:31.8240
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mYy1s+qnwXSHAFFzKOrYuD4s8NdpgKueX9zI9xXFwLevhr3tu0tSWc6LTZXIB56zkm0t3Los7wFtfyigVu2voA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYTPR01MB10954

DQoNCk9uIDEzLzEyLzIwMjMgMDY6NDYsIERhbiBXaWxsaWFtcyB3cm90ZToNCj4gTGkgWmhpamlh
biB3cm90ZToNCj4+IEEgc3BhY2UgaXMgbWlzc2luZyBiZWZvcmUgJ10nDQo+Pg0KPj4gQWNrZWQt
Ynk6IERhbiBXaWxsaWFtcyA8ZGFuLmoud2lsbGlhbXNAaW50ZWwuY29tPg0KPiANCj4gWW91IGFk
ZGVkIG15IEFjayB3aXRob3V0IGFkZHJlc3NpbmcgdGhlIGZlZWRiYWNrLg0KDQpJJ20gc29ycnkg
YWJvdXQgdGhhdC4gSSB0aG91Z2h0IHRoaXMgZml4KHN5bnRheCBlcnJvcikgaXMgdG9vIHNpbXBs
ZSB0byBzYXkgbW9yZS4NCg0KDQo+IA0KPiAiQ29tbWVudGFyeSBvbiB0aGUgaW1wYWN0IG9mIHRo
ZSBjaGFuZ2UgaXMgYWx3YXlzIHdlbGNvbWUuIg0KPiANCj4gUGxlYXNlIGluY2x1ZGUgYSBzZW50
ZW5jZSBvbiBob3cgdGhpcyB0cmlnZ2VyZWQgZm9yIHlvdSBhbmQgc29tZQ0KPiBhbmFseXNpcyBv
ZiB0aGUgd2h5IGl0IGhhcyBub3QgdHJpZ2dlcmVkIHByZXZpb3VzbHkuIE90aGVyd2lzZSAiQSBz
cGFjZQ0KPiBpcyBtaXNzaW5nIGJlZm9yZSAnXSciIGRvZXMgbm90IGFkZCBhbnkgaW5mb3JtYXRp
b24gdGhhdCBjYW4gbm90IGJlDQo+IGRldGVybWluZWQgYnkgcmVhZGluZyB0aGUgcGF0Y2guDQo+
IA0KPiBBIHVzZWZ1bCBjaGFuZ2Vsb2cgZm9yIHRoaXMgd291bGQgYmUgc29tZXRoaW5nIGxpa2U6
DQo+ID4gQ3VycmVudGx5IHRoZSBjeGwtcmVnaW9uLXN5c2ZzLnNoIHRlc3QgcnVucyB0byBjb21w
bGV0aW9uIGFuZCBwYXNzZXMsDQo+IGJ1dCB3aXRoIHN5bnRheCBlcnJvcnMgaW4gdGhlIGxvZy4g
SXQgdHVybnMgb3V0IHRoYXQgYmVjYXVzZSB0aGUgdGVzdCBpcw0KPiBjaGVja2luZyBmb3IgYSBw
b3NpdGl2ZSBjb25kaXRpb24gYXMgYSBmYWlsdXJlLCB0aGF0IGFsc28gaGFwcGVucyB0bw0KPiBt
YXNrIHRoZSBzeW50YXggZXJyb3JzLiBGaXggdGhlIHN5bnRheCBhbmQgbm90ZSB0aGF0IHRoaXMg
YWxzbyBoYXBwZW5zDQo+IHRvIHVuYmxvY2sgYSB0ZXN0IGNhc2UgdGhhdCB3YXMgYmVpbmcgaGlk
ZGVuIGJ5IHRoaXMgZXJyb3IuDQoNCg0KdGhhbmtzLCBpdCdzIGEgcHJldHR5IGdvb2QgY2hhbmdl
bG9nLg0KDQp3aWxsIHVwZGF0ZSBpbiBWMy4NCg0KDQpUaGFua3MNClpoaWppYW4=
