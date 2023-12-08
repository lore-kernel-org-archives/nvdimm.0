Received: from esa3.fujitsucc.c3s2.iphmx.com (esa3.fujitsucc.c3s2.iphmx.com [68.232.151.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C447111A3
	for <nvdimm@lists.linux.dev>; Fri,  8 Dec 2023 09:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="HbaA6F9N"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1702026767; x=1733562767;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=V09b3G9cXFiVneJV1fDEoH7Z3vUEHJ/fMRZqab+JX3k=;
  b=HbaA6F9N3bk/xX+5LjFtXbjBgHkK4X5VlH9J/IO2uxMklkJlJMlwaHyS
   ReW2WJco0DkorzCI+Q+L7ie8Z3CXBEdZizfjhpFHxMg4qUG45Otk28VlS
   kM+jYHyBaXnWO4h/nYDL2kuOHp4Ktd5JI/Sz/xDKiOhlFmeHh7doCFWAj
   fjvDZW4G66VMjIgB348OcAbzAbWQabM693B4y/jnpb03gjgGYOulnPrHl
   oE13R2hHmkHyvLZZOZbCBmaeZV+7sNKg95O2p/AQnl3R+ox1Eqp25A8oD
   UWhrv+PosJVzMT/vObn2q8WoEgyazFhbJcNCSXy9jnGvXL+drtLtUWeye
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10917"; a="16278676"
X-IronPort-AV: E=Sophos;i="6.04,260,1695654000"; 
   d="scan'208";a="16278676"
Received: from mail-tycjpn01lp2168.outbound.protection.outlook.com (HELO JPN01-TYC-obe.outbound.protection.outlook.com) ([104.47.23.168])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2023 18:11:31 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jr2BZXwgTbNHZoFxhC6jrQ7E0rg9tNfjeCCvnPVUQYv3Kpz8EGnkv/5GrjwerjvXjrd/G4my8PG+5bIOMbgUtyvq5tMCKGDSAUGoJryZ/FI9QV6GGmjqK/S9tRfXqvW698IU49pIwZaWe0Bdd79nFSFG+2B3ZecVFyfhieDX4kWCxhg/YR6kaR9990ojx1gobI2DgEOLMPrt7VY1qrKMy0irz8HLj8CrET0z3MUsZgum5OQohYOm1/O8XrvvV5uEr6wY+lyLjZU/mC0LErKrdn1iQ/HzhNgYDBSOO5fGsi9xDLcwg7VznqR9a21nB/m2cWKPVNhBZLhvyVzlq+rX+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V09b3G9cXFiVneJV1fDEoH7Z3vUEHJ/fMRZqab+JX3k=;
 b=gRQXEe36omblFfFupBnBd1RrKJeugYxbhvYnWboNl29Iq5v+3G2WJ+uUTaIThqyXIy2xKw3ma+D+CiUB1CmkKE+gt2+Qby+IdpPcMwkLFaqw/iSPAnjbKHGmHPBxILe/o19uAnmNe4utFeFwGpLTQWQH8eHkRG0nTLi+mEjl/UbZekgXrYZTWa6TELT8RiBEYimm7O0QhGaDhyAFwJJIzscmHRbT63MA1hHPlv9JrMWqqTnQIECcqvaFniQbU7vqx0sKsKz6B4I9fCOyQbJJH6SHxEAhl2KebTjRX/bpOgsoixSr6hFx+aLZI8cuWaONNiisQn2ml0MLWcscgEKxEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from OS0PR01MB5442.jpnprd01.prod.outlook.com (2603:1096:604:a6::10)
 by TYCPR01MB10776.jpnprd01.prod.outlook.com (2603:1096:400:294::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.17; Fri, 8 Dec
 2023 09:11:28 +0000
Received: from OS0PR01MB5442.jpnprd01.prod.outlook.com
 ([fe80::c96f:52b0:dd4e:8d50]) by OS0PR01MB5442.jpnprd01.prod.outlook.com
 ([fe80::c96f:52b0:dd4e:8d50%6]) with mapi id 15.20.7091.017; Fri, 8 Dec 2023
 09:11:28 +0000
From: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>
To: Vishal Verma <vishal.l.verma@intel.com>, Andrew Morton
	<akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, Oscar
 Salvador <osalvador@suse.de>, Dan Williams <dan.j.williams@intel.com>, Dave
 Jiang <dave.jiang@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, Huang Ying <ying.huang@intel.com>, Dave Hansen
	<dave.hansen@linux.intel.com>, Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>,
	Michal Hocko <mhocko@suse.com>, Jonathan Cameron
	<Jonathan.Cameron@Huawei.com>, Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v10 3/3] dax/kmem: allow kmem to add memory with
 memmap_on_memory
Thread-Topic: [PATCH v10 3/3] dax/kmem: allow kmem to add memory with
 memmap_on_memory
Thread-Index: AQHaEUtZ1NKhFe25UkKLway4Tbtt2rCfSnKA
Date: Fri, 8 Dec 2023 09:11:28 +0000
Message-ID: <5cc325c9-c872-4cd5-be98-61b14ecac9ad@fujitsu.com>
References: <20231107-vv-kmem_memmap-v10-0-1253ec050ed0@intel.com>
 <20231107-vv-kmem_memmap-v10-3-1253ec050ed0@intel.com>
In-Reply-To: <20231107-vv-kmem_memmap-v10-3-1253ec050ed0@intel.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS0PR01MB5442:EE_|TYCPR01MB10776:EE_
x-ms-office365-filtering-correlation-id: 8815c81c-67b0-4ac1-816f-08dbf7cda966
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 d0GJbNvC0bhP8hLHaBrdiIkJ8gywGvm97ngFWPJSPYYHbHfHZxATB/u+gOFd5/1cF4c29SiGCL+SI2hK/D6bErIyO9ZjF4wXJfBOwQhit8S510vlWUCJSEiVTKf40zh+YG2HVP8XtfbPqk0dzbU9L5Kv3dgAry/okJOlgvTTlYypIcOMEq6HItZ4wudLRp6Xug8jTdplvF1INO/19M+0L6+nM0PRxYfPx1kcl8pRdyGpor9vMo5HUGF80C2e+rtc/zxnUxG5OPljcU/Smls9YNwdSnINF1XIUJSwSsAbPoFizRKTWxMQPXw27rdonB9hhWo8KTxqBN6TXCJs2Ic2ZwrpBqstker4N1PJEfB01vlPYher0EVxq7H2OWs464y+S0VsCOFBQNWw6AAUP3X/rvcwWpk+0Rjave5qRbdw3rKrDljaRsvfAm3AoCLk1SBZuVPOBZS9qFCpL8WnndJcpH2f1M+3ImBO7NDu/QPCuahkeorfdfLOVd+iXc4vB0IsQw8g10Ol4eIAAGaPdRxqkiezrZbGAe+jXqf4K4ThTIKafl2Yirdvjnedparv1RzupkPjoaPbr6yFBLUOfBTFXK37rwRzgtlXuFY9qOEOIB2bpxQh01ki97ljlk2OhgL2cV5Sra5QQvvPg81tySWP5nAIGstPwEnVJs28f8mXOXAD2geM++MhQNjyB/rWdvMB+bZUP5uC79vtSF+1sV6nnQ==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5442.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(136003)(346002)(396003)(376002)(230922051799003)(186009)(1590799021)(451199024)(1800799012)(64100799003)(83380400001)(85182001)(36756003)(1580799018)(41300700001)(2906002)(82960400001)(7416002)(38070700009)(6506007)(6512007)(31686004)(31696002)(6486002)(478600001)(53546011)(64756008)(76116006)(54906003)(66946007)(66556008)(91956017)(66476007)(110136005)(66446008)(86362001)(316002)(122000001)(2616005)(4326008)(8676002)(8936002)(71200400001)(26005)(38100700002)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MnkydHhiUTd1TmdIakVtbmVoaXV1K0NZSkpsMUxxb1NycU1Fd2t4YUxNRUZ2?=
 =?utf-8?B?V3F3VnJTWkZlNkZZYUdPUEJYYTdteEJmelJoTHJ1bzg5UWUwMGd6WC9XWDd4?=
 =?utf-8?B?OU9UcU5BQzNZNVNMWEg3UVVWejNiSHVCMDVzMnREcGNYSi9XL0RYSXA2d0dQ?=
 =?utf-8?B?UExtc3paQllQandPa3ROcDBDWURQcnMyRzkxcE5SaUxkaWpzdndXdUhRMmpK?=
 =?utf-8?B?Yk9GcXdjSnJ4VkxjUytnVlI0aXZJNVQ5QW05SmlRT0VjWVVINnFFR0dtU3Ev?=
 =?utf-8?B?YU1DbGdZL0JXYVF4b045UlNZcWdHcGVUeWtOeitEVXJUNVA2L2VxTUFYS2hn?=
 =?utf-8?B?RkF6MWhuY1luRmExczZBeFVXYkJCY0xMRGRuaHlCSVFRRjN2Tk1nQUMxWDZr?=
 =?utf-8?B?a0d5TEtOZEVDWVkvRHZmN0FvbjBMV2Q2eXhwSmV2ajU0enp3d0Z1dlRGS1lu?=
 =?utf-8?B?TndLWE5TYU54N3hOT3JraUJSZWdSUEU1azdVN1E3NWgvRzJMZTF3YloyU0g1?=
 =?utf-8?B?ZytFdENvRVJJOTNDRG9jYkVzWHBjeWUwVVgwS1hRQmM5MjdkM1hJbHQvU2VR?=
 =?utf-8?B?UE9wN1NuSko3SnBjSnVBa3JhcWpLaythTG5BU1hsOVA3dFlqRE0wRld3eVl4?=
 =?utf-8?B?R0pSMHAwOE9LR1J5R24wc2xEWGw3MW9jRnhNRm1NZ3pjbldQRXVXVkg1VVE2?=
 =?utf-8?B?U3lReG1rQ3NuWHhlVDFtc1huZE84RFZvT3JnSFhxanUvWG85TlpnTkFkazM2?=
 =?utf-8?B?c2w4M0hZRUxyemNXRlB1TU5xcVAvRmFzM1NUZXpiK2xYclJaN014UE90OVBN?=
 =?utf-8?B?UlRPcTlCNEZ1RUw2QlVtY3RoQjMwWGc1cnJZV2lteFhJL2d6a2h3OVhnUU1x?=
 =?utf-8?B?M2VONHBMQlpJUWY0QzR2QzJrSW1LNDBLU1NwdzlSNkxDcHNDaFFwT1B4d2xz?=
 =?utf-8?B?STdUN0xPRWdiWXp3NnU2UDBib0hsOTNDcGVTL3J2ekxFZHcxcGtIS3Ruampy?=
 =?utf-8?B?VjNVNTUrRGlrMDBseXVSSjRkOFlRK1l0eHdQVERLMkZOb3pXamFTOVJ5cnRI?=
 =?utf-8?B?VDhlMERLaWpLSnExRUYxWHVzTzB3ZFRpaGQ4Y0MxbzVXVkpGMFBHK085Z1VL?=
 =?utf-8?B?WnlvNlh1My8yc3JkL3dwQkxQbTF5ZVYxbjh2dkdDeElrb2RkcXB2ODdPaE1R?=
 =?utf-8?B?ZVRUTU1rSlRibDVyeE10L3M0RW45RjA4ZTZSZXFERXVqK3NyN2M0Z2w0b3lU?=
 =?utf-8?B?SXowbjgyUy85UForSW9BV09URndCTWp2U1FtZ3dML0ZUMjBqZ0VlRHRYUEZv?=
 =?utf-8?B?TVhuVXA2VHNqU3BhZS9jUEVXc0FpYkNZYzZIaStHN0c1aWNyaGoxY0FRS2ln?=
 =?utf-8?B?K3BuNXE0ZWE0Y0NNNFVHcHlSdlYrMGo3SVI0dUdNWFVNZEhXbXN0cXZhYWVi?=
 =?utf-8?B?MG12c1dPUGNGVUlPWGtGcmhwUzhjcVJ2T1dleGlnUVNoTDkvK2tha0dYRVFI?=
 =?utf-8?B?YWdwQlRCRmtzbGxFbFJWNW0walpiUnpoT2JJUWZ2bXltVGFOT2tObVh3UVBS?=
 =?utf-8?B?T05nbVhPZDJMSW0vZzJwcmtXY1lLb1V6NlVTUTJjNGxRYUFJQzVrS1NVT0hN?=
 =?utf-8?B?Q0x5eDhqOVJ2eDYwTzdEUWZGZExndHRhdXRCT0N6cSsrbXpkM2gvUFdTNkZI?=
 =?utf-8?B?aFFMeEY4eXBVK20yYUhLOEJUTHUzbzJ6NmVwcThaengvWjd0M2Zadm1veWM0?=
 =?utf-8?B?Z3B5dDVtV1A4VW5WbmE5V3BSbTkwQy9IQXZjOURqUHFKeXVKZ1J0d0FKaUts?=
 =?utf-8?B?a3FyeDBYZGh2NDhrYjd0dHAxQkhjWFoyMmNBeHFMZTNieDFhanA0L3dKWGg0?=
 =?utf-8?B?ZjFMcEZ1MW1MZHFuQ2NQUnRpWjZtYmFKUDZRVGRjTnV1dHdjTWk4aDU3Q25W?=
 =?utf-8?B?TTBsZDM4blROM1BLTmVKblo2aEozSTU5Zmk4anREeWdXMzlwQXhiU2VKZnF1?=
 =?utf-8?B?TG1jN0txcEZRSkVVZU1zOUhPQWhUeG45TWhxNWFRVm9ocjM0TWw4WTRqM3Rl?=
 =?utf-8?B?YUlqeUpBV3hGUnBLSkdrR1YxbnFtRnBUTlJ4Wk5zeEFMR0Zma0xNUlNPM0ZO?=
 =?utf-8?B?amErb2JXNEVMcGNRQVJ4Q01ERC92NGM3SkNUUFQ5ck5zSDVRcnFSbkhDUUl5?=
 =?utf-8?B?YXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <478B18DB462C9C4B8147B95972DE8583@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MkW6LpzW2F0fQb/JQFxYVwn8Ysw5fadoHSQR5PDtOZpwbVAoOQfJvai1hjMWcb0fNqGzws0CLpDCmazx98e5T59NeACBhRl8i6nEs1BfL60cr2PNPw9agHCNn/HvHkShYD8gJyLELnPB6cz4AoWk5kV+x2EgU8hvv774lZ13p7Hh8bSNjyXWw8ErkyNnbXBV49pN7IRbpF9MUFzFFMl1yqNiMDRl6pTjC+3rgVcwWySZ9I+9CUaFdSRKPDv5eiDH1ihVz5UmgQEWSVdB7jBvuVQfIMOBoheNyEeHKA9vktPRUx9CzPE8yulPufGTQ09j9XdkCg15/b9RVz+9JTo7gfuxyHbB/vae1jzJBTW82/+LWafk6GSJxkF4en78RppKLySijk3wB2vAgreZ0TO72Ll727WF0jSeJbaIre64ZW8vxsOU5Q/igsleu8Y0wkUlzvPou75CaLDm9kGc8V3BNtBgLm84NQyAn+1aUcZzJ4j4g3SCFhL7JrNe5ocfpG4WFptsVtUE9a9Y9XmeoWf2oduHOB7UtTBRTpIF0Gp+WwCCDAphnMtXCVXvBKufm19AsBb6UPB1fBSBzjc7uqaWILlubvasHP0Z2igmkR4//XT0iBfvFf6+2ii3vF+kYHMi
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5442.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8815c81c-67b0-4ac1-816f-08dbf7cda966
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2023 09:11:28.5455
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QOk+/SN+reXP/Y7HkC00uarCWdn51KSj0BKk81F3jmifemitZYlFdQgZpWBKjQZjWlo7bB+c+TBX1W1ucQiJ5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB10776

DQoNCk9uIDA3LzExLzIwMjMgMTU6MjIsIFZpc2hhbCBWZXJtYSB3cm90ZToNCj4gTGFyZ2UgYW1v
dW50cyBvZiBtZW1vcnkgbWFuYWdlZCBieSB0aGUga21lbSBkcml2ZXIgbWF5IGNvbWUgaW4gdmlh
IENYTCwNCj4gYW5kIGl0IGlzIG9mdGVuIGRlc2lyYWJsZSB0byBoYXZlIHRoZSBtZW1tYXAgZm9y
IHRoaXMgbWVtb3J5IG9uIHRoZSBuZXcNCj4gbWVtb3J5IGl0c2VsZi4NCj4gDQo+IEVucm9sbCBr
bWVtLW1hbmFnZWQgbWVtb3J5IGZvciBtZW1tYXBfb25fbWVtb3J5IHNlbWFudGljcyBpZiB0aGUg
ZGF4DQo+IHJlZ2lvbiBvcmlnaW5hdGVzIHZpYSBDWEwuIEZvciBub24tQ1hMIGRheCByZWdpb25z
LCByZXRhaW4gdGhlIGV4aXN0aW5nDQo+IGRlZmF1bHQgYmVoYXZpb3Igb2YgaG90IGFkZGluZyB3
aXRob3V0IG1lbW1hcF9vbl9tZW1vcnkgc2VtYW50aWNzLg0KPiANCj4gQ2M6IEFuZHJldyBNb3J0
b24gPGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmc+DQo+IENjOiBEYXZpZCBIaWxkZW5icmFuZCA8
ZGF2aWRAcmVkaGF0LmNvbT4NCj4gQ2M6IE1pY2hhbCBIb2NrbyA8bWhvY2tvQHN1c2UuY29tPg0K
PiBDYzogT3NjYXIgU2FsdmFkb3IgPG9zYWx2YWRvckBzdXNlLmRlPg0KPiBDYzogRGFuIFdpbGxp
YW1zIDxkYW4uai53aWxsaWFtc0BpbnRlbC5jb20+DQo+IENjOiBEYXZlIEppYW5nIDxkYXZlLmpp
YW5nQGludGVsLmNvbT4NCj4gQ2M6IERhdmUgSGFuc2VuIDxkYXZlLmhhbnNlbkBsaW51eC5pbnRl
bC5jb20+DQo+IENjOiBIdWFuZyBZaW5nIDx5aW5nLmh1YW5nQGludGVsLmNvbT4NCj4gUmV2aWV3
ZWQtYnk6IEpvbmF0aGFuIENhbWVyb24gPEpvbmF0aGFuLkNhbWVyb25AaHVhd2VpLmNvbT4NCj4g
UmV2aWV3ZWQtYnk6IERhdmlkIEhpbGRlbmJyYW5kIDxkYXZpZEByZWRoYXQuY29tPg0KPiBSZXZp
ZXdlZC1ieTogIkh1YW5nLCBZaW5nIiA8eWluZy5odWFuZ0BpbnRlbC5jb20+DQo+IFNpZ25lZC1v
ZmYtYnk6IFZpc2hhbCBWZXJtYSA8dmlzaGFsLmwudmVybWFAaW50ZWwuY29tPg0KDQoNClRlc3Rl
ZC1ieTogTGkgWmhpamlhbiA8bGl6aGlqaWFuQGZ1aml0c3UuY29tPiAgIyBib3RoIGN4bC5rbWVt
IGFuZCBudmRpbW0ua21lbQ0KDQoNCg0KDQo+IC0tLQ0KPiAgIGRyaXZlcnMvZGF4L2J1cy5oICAg
ICAgICAgfCAxICsNCj4gICBkcml2ZXJzL2RheC9kYXgtcHJpdmF0ZS5oIHwgMSArDQo+ICAgZHJp
dmVycy9kYXgvYnVzLmMgICAgICAgICB8IDMgKysrDQo+ICAgZHJpdmVycy9kYXgvY3hsLmMgICAg
ICAgICB8IDEgKw0KPiAgIGRyaXZlcnMvZGF4L2htZW0vaG1lbS5jICAgfCAxICsNCj4gICBkcml2
ZXJzL2RheC9rbWVtLmMgICAgICAgIHwgOCArKysrKysrLQ0KPiAgIGRyaXZlcnMvZGF4L3BtZW0u
YyAgICAgICAgfCAxICsNCj4gICA3IGZpbGVzIGNoYW5nZWQsIDE1IGluc2VydGlvbnMoKyksIDEg
ZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2RheC9idXMuaCBiL2RyaXZl
cnMvZGF4L2J1cy5oDQo+IGluZGV4IDFjY2QyMzM2MDEyNC4uY2JiZjY0NDQzMDk4IDEwMDY0NA0K
PiAtLS0gYS9kcml2ZXJzL2RheC9idXMuaA0KPiArKysgYi9kcml2ZXJzL2RheC9idXMuaA0KPiBA
QCAtMjMsNiArMjMsNyBAQCBzdHJ1Y3QgZGV2X2RheF9kYXRhIHsNCj4gICAJc3RydWN0IGRldl9w
YWdlbWFwICpwZ21hcDsNCj4gICAJcmVzb3VyY2Vfc2l6ZV90IHNpemU7DQo+ICAgCWludCBpZDsN
Cj4gKwlib29sIG1lbW1hcF9vbl9tZW1vcnk7DQo+ICAgfTsNCj4gICANCj4gICBzdHJ1Y3QgZGV2
X2RheCAqZGV2bV9jcmVhdGVfZGV2X2RheChzdHJ1Y3QgZGV2X2RheF9kYXRhICpkYXRhKTsNCj4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvZGF4L2RheC1wcml2YXRlLmggYi9kcml2ZXJzL2RheC9kYXgt
cHJpdmF0ZS5oDQo+IGluZGV4IDI3Y2YyZGFhYWE3OS4uNDQ2NjE3YjczYWVhIDEwMDY0NA0KPiAt
LS0gYS9kcml2ZXJzL2RheC9kYXgtcHJpdmF0ZS5oDQo+ICsrKyBiL2RyaXZlcnMvZGF4L2RheC1w
cml2YXRlLmgNCj4gQEAgLTcwLDYgKzcwLDcgQEAgc3RydWN0IGRldl9kYXggew0KPiAgIAlzdHJ1
Y3QgaWRhIGlkYTsNCj4gICAJc3RydWN0IGRldmljZSBkZXY7DQo+ICAgCXN0cnVjdCBkZXZfcGFn
ZW1hcCAqcGdtYXA7DQo+ICsJYm9vbCBtZW1tYXBfb25fbWVtb3J5Ow0KPiAgIAlpbnQgbnJfcmFu
Z2U7DQo+ICAgCXN0cnVjdCBkZXZfZGF4X3JhbmdlIHsNCj4gICAJCXVuc2lnbmVkIGxvbmcgcGdv
ZmY7DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2RheC9idXMuYyBiL2RyaXZlcnMvZGF4L2J1cy5j
DQo+IGluZGV4IDE2NTliNzg3YjY1Zi4uMWZmMWFiNWZhMTA1IDEwMDY0NA0KPiAtLS0gYS9kcml2
ZXJzL2RheC9idXMuYw0KPiArKysgYi9kcml2ZXJzL2RheC9idXMuYw0KPiBAQCAtMzY3LDYgKzM2
Nyw3IEBAIHN0YXRpYyBzc2l6ZV90IGNyZWF0ZV9zdG9yZShzdHJ1Y3QgZGV2aWNlICpkZXYsIHN0
cnVjdCBkZXZpY2VfYXR0cmlidXRlICphdHRyLA0KPiAgIAkJCS5kYXhfcmVnaW9uID0gZGF4X3Jl
Z2lvbiwNCj4gICAJCQkuc2l6ZSA9IDAsDQo+ICAgCQkJLmlkID0gLTEsDQo+ICsJCQkubWVtbWFw
X29uX21lbW9yeSA9IGZhbHNlLA0KPiAgIAkJfTsNCj4gICAJCXN0cnVjdCBkZXZfZGF4ICpkZXZf
ZGF4ID0gZGV2bV9jcmVhdGVfZGV2X2RheCgmZGF0YSk7DQo+ICAgDQo+IEBAIC0xNDAwLDYgKzE0
MDEsOCBAQCBzdHJ1Y3QgZGV2X2RheCAqZGV2bV9jcmVhdGVfZGV2X2RheChzdHJ1Y3QgZGV2X2Rh
eF9kYXRhICpkYXRhKQ0KPiAgIAlkZXZfZGF4LT5hbGlnbiA9IGRheF9yZWdpb24tPmFsaWduOw0K
PiAgIAlpZGFfaW5pdCgmZGV2X2RheC0+aWRhKTsNCj4gICANCj4gKwlkZXZfZGF4LT5tZW1tYXBf
b25fbWVtb3J5ID0gZGF0YS0+bWVtbWFwX29uX21lbW9yeTsNCj4gKw0KPiAgIAlpbm9kZSA9IGRh
eF9pbm9kZShkYXhfZGV2KTsNCj4gICAJZGV2LT5kZXZ0ID0gaW5vZGUtPmlfcmRldjsNCj4gICAJ
ZGV2LT5idXMgPSAmZGF4X2J1c190eXBlOw0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9kYXgvY3hs
LmMgYi9kcml2ZXJzL2RheC9jeGwuYw0KPiBpbmRleCA4YmM5ZDA0MDM0ZDYuLmM2OTY4MzdhYjIz
YyAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9kYXgvY3hsLmMNCj4gKysrIGIvZHJpdmVycy9kYXgv
Y3hsLmMNCj4gQEAgLTI2LDYgKzI2LDcgQEAgc3RhdGljIGludCBjeGxfZGF4X3JlZ2lvbl9wcm9i
ZShzdHJ1Y3QgZGV2aWNlICpkZXYpDQo+ICAgCQkuZGF4X3JlZ2lvbiA9IGRheF9yZWdpb24sDQo+
ICAgCQkuaWQgPSAtMSwNCj4gICAJCS5zaXplID0gcmFuZ2VfbGVuKCZjeGxyX2RheC0+aHBhX3Jh
bmdlKSwNCj4gKwkJLm1lbW1hcF9vbl9tZW1vcnkgPSB0cnVlLA0KPiAgIAl9Ow0KPiAgIA0KPiAg
IAlyZXR1cm4gUFRSX0VSUl9PUl9aRVJPKGRldm1fY3JlYXRlX2Rldl9kYXgoJmRhdGEpKTsNCj4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvZGF4L2htZW0vaG1lbS5jIGIvZHJpdmVycy9kYXgvaG1lbS9o
bWVtLmMNCj4gaW5kZXggNWQyZGRlZjBmOGY1Li5iOWRhNjlmOTI2OTcgMTAwNjQ0DQo+IC0tLSBh
L2RyaXZlcnMvZGF4L2htZW0vaG1lbS5jDQo+ICsrKyBiL2RyaXZlcnMvZGF4L2htZW0vaG1lbS5j
DQo+IEBAIC0zNiw2ICszNiw3IEBAIHN0YXRpYyBpbnQgZGF4X2htZW1fcHJvYmUoc3RydWN0IHBs
YXRmb3JtX2RldmljZSAqcGRldikNCj4gICAJCS5kYXhfcmVnaW9uID0gZGF4X3JlZ2lvbiwNCj4g
ICAJCS5pZCA9IC0xLA0KPiAgIAkJLnNpemUgPSByZWdpb25faWRsZSA/IDAgOiByYW5nZV9sZW4o
Jm1yaS0+cmFuZ2UpLA0KPiArCQkubWVtbWFwX29uX21lbW9yeSA9IGZhbHNlLA0KPiAgIAl9Ow0K
PiAgIA0KPiAgIAlyZXR1cm4gUFRSX0VSUl9PUl9aRVJPKGRldm1fY3JlYXRlX2Rldl9kYXgoJmRh
dGEpKTsNCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvZGF4L2ttZW0uYyBiL2RyaXZlcnMvZGF4L2tt
ZW0uYw0KPiBpbmRleCAzNjljNjk4Yjc3MDYuLjQyZWUzNjBjZjRlMyAxMDA2NDQNCj4gLS0tIGEv
ZHJpdmVycy9kYXgva21lbS5jDQo+ICsrKyBiL2RyaXZlcnMvZGF4L2ttZW0uYw0KPiBAQCAtMTIs
NiArMTIsNyBAQA0KPiAgICNpbmNsdWRlIDxsaW51eC9tbS5oPg0KPiAgICNpbmNsdWRlIDxsaW51
eC9tbWFuLmg+DQo+ICAgI2luY2x1ZGUgPGxpbnV4L21lbW9yeS10aWVycy5oPg0KPiArI2luY2x1
ZGUgPGxpbnV4L21lbW9yeV9ob3RwbHVnLmg+DQo+ICAgI2luY2x1ZGUgImRheC1wcml2YXRlLmgi
DQo+ICAgI2luY2x1ZGUgImJ1cy5oIg0KPiAgIA0KPiBAQCAtOTMsNiArOTQsNyBAQCBzdGF0aWMg
aW50IGRldl9kYXhfa21lbV9wcm9iZShzdHJ1Y3QgZGV2X2RheCAqZGV2X2RheCkNCj4gICAJc3Ry
dWN0IGRheF9rbWVtX2RhdGEgKmRhdGE7DQo+ICAgCXN0cnVjdCBtZW1vcnlfZGV2X3R5cGUgKm10
eXBlOw0KPiAgIAlpbnQgaSwgcmMsIG1hcHBlZCA9IDA7DQo+ICsJbWhwX3QgbWhwX2ZsYWdzOw0K
PiAgIAlpbnQgbnVtYV9ub2RlOw0KPiAgIAlpbnQgYWRpc3QgPSBNRU1USUVSX0RFRkFVTFRfREFY
X0FESVNUQU5DRTsNCj4gICANCj4gQEAgLTE3OSwxMiArMTgxLDE2IEBAIHN0YXRpYyBpbnQgZGV2
X2RheF9rbWVtX3Byb2JlKHN0cnVjdCBkZXZfZGF4ICpkZXZfZGF4KQ0KPiAgIAkJICovDQo+ICAg
CQlyZXMtPmZsYWdzID0gSU9SRVNPVVJDRV9TWVNURU1fUkFNOw0KPiAgIA0KPiArCQltaHBfZmxh
Z3MgPSBNSFBfTklEX0lTX01HSUQ7DQo+ICsJCWlmIChkZXZfZGF4LT5tZW1tYXBfb25fbWVtb3J5
KQ0KPiArCQkJbWhwX2ZsYWdzIHw9IE1IUF9NRU1NQVBfT05fTUVNT1JZOw0KPiArDQo+ICAgCQkv
Kg0KPiAgIAkJICogRW5zdXJlIHRoYXQgZnV0dXJlIGtleGVjJ2Qga2VybmVscyB3aWxsIG5vdCB0
cmVhdA0KPiAgIAkJICogdGhpcyBhcyBSQU0gYXV0b21hdGljYWxseS4NCj4gICAJCSAqLw0KPiAg
IAkJcmMgPSBhZGRfbWVtb3J5X2RyaXZlcl9tYW5hZ2VkKGRhdGEtPm1naWQsIHJhbmdlLnN0YXJ0
LA0KPiAtCQkJCXJhbmdlX2xlbigmcmFuZ2UpLCBrbWVtX25hbWUsIE1IUF9OSURfSVNfTUdJRCk7
DQo+ICsJCQkJcmFuZ2VfbGVuKCZyYW5nZSksIGttZW1fbmFtZSwgbWhwX2ZsYWdzKTsNCj4gICAN
Cj4gICAJCWlmIChyYykgew0KPiAgIAkJCWRldl93YXJuKGRldiwgIm1hcHBpbmclZDogJSNsbHgt
JSNsbHggbWVtb3J5IGFkZCBmYWlsZWRcbiIsDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2RheC9w
bWVtLmMgYi9kcml2ZXJzL2RheC9wbWVtLmMNCj4gaW5kZXggYWUwY2IxMTNhNWQzLi5mM2M2YzY3
Yjg0MTIgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvZGF4L3BtZW0uYw0KPiArKysgYi9kcml2ZXJz
L2RheC9wbWVtLmMNCj4gQEAgLTYzLDYgKzYzLDcgQEAgc3RhdGljIHN0cnVjdCBkZXZfZGF4ICpf
X2RheF9wbWVtX3Byb2JlKHN0cnVjdCBkZXZpY2UgKmRldikNCj4gICAJCS5pZCA9IGlkLA0KPiAg
IAkJLnBnbWFwID0gJnBnbWFwLA0KPiAgIAkJLnNpemUgPSByYW5nZV9sZW4oJnJhbmdlKSwNCj4g
KwkJLm1lbW1hcF9vbl9tZW1vcnkgPSBmYWxzZSwNCj4gICAJfTsNCj4gICANCj4gICAJcmV0dXJu
IGRldm1fY3JlYXRlX2Rldl9kYXgoJmRhdGEpOw0KPiA=
