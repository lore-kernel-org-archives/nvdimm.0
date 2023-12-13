Received: from esa5.fujitsucc.c3s2.iphmx.com (esa5.fujitsucc.c3s2.iphmx.com [68.232.159.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19ABC4418
	for <nvdimm@lists.linux.dev>; Wed, 13 Dec 2023 08:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="xVqh4jAU"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1702454633; x=1733990633;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=vjWEC8YG/2OhQB6zSaC8XJTG6y5FZYUBhpZUDad26jU=;
  b=xVqh4jAUMHMivmZWb3LFLXd1eGO6xrcSdM8nTbqKIqXxCJUEVI677+qv
   jqUX/Blx7bslc4S+5CpMdG9EetTZe/A4SHVoexpF3zEtky+P7bD7EIFPX
   qaarcT5Spn0EVZPg4X1yc3RhypoGw9QIrzNULCxE2o+wA0oq34QjlhGXw
   axl+9Qj2tcAsg+KCH9q+M/VXcg1KjUj8D5ChYrzqFe1AyZi0VwBKBD8Nb
   IINdhhZoXuJexcvRbQL7Ef+0X9SzLW6vvFcUdkl06p9ku9ah5s/NFf6PW
   gpHQslu1TJxw6nfD5/pM5V/tDmSOjmKgnnA76DfJXXuQ+MyejFOJzEceA
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10922"; a="105910651"
X-IronPort-AV: E=Sophos;i="6.04,272,1695654000"; 
   d="scan'208";a="105910651"
Received: from mail-os0jpn01lp2105.outbound.protection.outlook.com (HELO JPN01-OS0-obe.outbound.protection.outlook.com) ([104.47.23.105])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2023 17:02:40 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Swb5XnOpfsi/8UfXkhOvwN5+pWw/lXfaiO6GITcCbRCK58OCJiE6NPkwg+xaIxX1ByC/kZhaY/iIHU3BROEsn627MNAJWMCTw3gkF5n/Lb65gtuWtfhoWfhQ/srR7Tsn5qQzmmUWccA+1p0t9bNwXB/8979TXTgTBvylAfLBizJHZlc9JrzmWifsuc/Wsj46G71ah8OYYn6fziwjfiNiI7/1mGzlZ55yJykwU2jCBLE/4WFOJoFMqiLU9PED7WWmHF8gs0vwqhpaH/nLMUI+X7QrC6W9C73UPPeh6SxzXtuDLS70oqyQYa9Yo8D90AWtg/zktBqa1K7jka/38CIs6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vjWEC8YG/2OhQB6zSaC8XJTG6y5FZYUBhpZUDad26jU=;
 b=YmNSEnkdmyLHmwAAaWfBC9IRJXTkIyG4J/xEABaHmXbR4vS4ZrlHrBSK2etQlxNy29NkDL682Yu0+7Kc3KbxArKptaKcnDicKK5QwUb7AT3RhYWQWNHSKHAB/A1wQP99ZaVA7372tNNKn2Td9YLtLM2FqMhSh/XvpMBeb+TUQOORku6GfgZSB/BcT+CojqLZpJuDgPdT2beTccNyLA7qusn8dvJa8osOGDH8wbJ1SA3cPYDM5D/wOUqGC7FTN+aBjkX8GEuTMRxDPL9hByJoHCBEbaL2v2Nm9KobLWXJJEFXTvMiH2le+Q2cKR8p113IX8BsnEOcpCt8JJSskiv/qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from OS0PR01MB5442.jpnprd01.prod.outlook.com (2603:1096:604:a6::10)
 by OSZPR01MB9487.jpnprd01.prod.outlook.com (2603:1096:604:1d4::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.26; Wed, 13 Dec
 2023 08:02:37 +0000
Received: from OS0PR01MB5442.jpnprd01.prod.outlook.com
 ([fe80::c96f:52b0:dd4e:8d50]) by OS0PR01MB5442.jpnprd01.prod.outlook.com
 ([fe80::c96f:52b0:dd4e:8d50%6]) with mapi id 15.20.7091.022; Wed, 13 Dec 2023
 08:02:37 +0000
From: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>
To: Alison Schofield <alison.schofield@intel.com>
CC: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH v2 1/2] test/cxl-region-sysfs.sh: use '[[ ]]'
 command to evaluate operands as arithmetic expressions
Thread-Topic: [ndctl PATCH v2 1/2] test/cxl-region-sysfs.sh: use '[[ ]]'
 command to evaluate operands as arithmetic expressions
Thread-Index: AQHaLM7H6OP42odAnkCeeNKLgoR9/bCmIF4AgAC7fAA=
Date: Wed, 13 Dec 2023 08:02:37 +0000
Message-ID: <dc7e023d-6e93-44f9-a9c2-c24dc5eabab6@fujitsu.com>
References: <20231212074228.1261164-1-lizhijian@fujitsu.com>
 <ZXjH1o1rq/Un/X0w@aschofie-mobl2>
In-Reply-To: <ZXjH1o1rq/Un/X0w@aschofie-mobl2>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS0PR01MB5442:EE_|OSZPR01MB9487:EE_
x-ms-office365-filtering-correlation-id: 9692b7ac-6481-43da-917b-08dbfbb1df6b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 Xo1INPyLsC06/x5J6ok5EZabQpwmfD82E3bj0GO4wKfgNKdus9+1jxwD1NliYi5aoXB/rq1lJiQP9Tw6MMlnS4vO0BJOmpyoi2MROY77pfbCpGVNJAvNqqyDFvbbvlbrX2k/HN9/9J2BRc/PclBu5avNV7OO6SHCfJks7Fn9N8w9a4hhNwIZ4ZskHmsthj0J+pj74FbLTL18/TJ5FTky/W0AQ8R3FvDLGdH2zZUktyFecf1XsrRvAo3rpxk7wrFpTTgejVNyxaNnsPh/odfIGZh1WxFj1OWLpqsk6bXkfm7IznK4l8CcBDv91IoaQo+oGRlcRHTZCBBUtA8VDEYKGTkkRRIlpdPKmBYbzGLKbfGpLW7zajij3gSzDDS1QJP3t92cRpeGfC9DtDcB4MMGYBdcPOqwzP6SWv8MM/R0/vJIsYcrLARk+8Ixi/du6d1kXId9GrlBOsMK+mSA25WFlo5yU1lxP0ohP9vy855LXE+PLnHA1GtyWIaGUDZPMS8EfYrHZd5ErIaMW2P3lvMVtHjtyPyGazi7L7ErPdG+B1gvn11E/+G40xH2vsYi7kZ7NiWkxD3w8gHWrH1yNljW9pu4JskVoZrzqyE7pht50d+hLZttI0sRdQQxT/cxlAj7sUTXFpi0/P5aVx18sSGLse/qB4w69iTz/QhguxwXrq/ls4zZVRbDP7rXkOtiQuioI249wBrbNS7uKLkxLXh3/Q==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5442.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(376002)(346002)(366004)(136003)(230922051799003)(1590799021)(186009)(64100799003)(451199024)(1800799012)(31686004)(38070700009)(1580799018)(76116006)(66946007)(64756008)(91956017)(54906003)(6916009)(66446008)(66556008)(66476007)(82960400001)(31696002)(36756003)(86362001)(85182001)(122000001)(38100700002)(83380400001)(26005)(6512007)(6506007)(2616005)(53546011)(316002)(2906002)(71200400001)(478600001)(6486002)(5660300002)(4326008)(8936002)(8676002)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?R2syd2cvRWtYcW9VdWFaT0hGMGczNVlBcjVLYVQ0K01sbzIwYkUvN1lKZ1hJ?=
 =?utf-8?B?WmpqbThuTkN4UjZxOExmQi9Kd1hmWVR6V2JFeWdWZlZPZ21UeS9wQUs5cGhP?=
 =?utf-8?B?TFc4TmIrYWlSK1djTitmZmY5SUpHak1DTGpQM0VrN0pMSW5NNU1LM2V0MnZT?=
 =?utf-8?B?RWdEVzJjSmwyRXZVSUF2STVUMzFUMjlKQjRKbitaM1NUZ0VOSGhWR0d6ZVFI?=
 =?utf-8?B?dTB5Vy9QRkJjbUsyQTQrQmQvNXQrMDNCVTI5bUc1UEdYUW5oTmJjQ2k4MVJY?=
 =?utf-8?B?MGhqa253bzkvWm5oajVieHpMc01XcEozOTZqOWNNUEhWZ2xOY0xMMGdDSDk1?=
 =?utf-8?B?a0VuaFZ1VjRjZThXZitaNVhiMkZwOS8zYUNaOVpkMDUraUx6SEpIakRZOUlD?=
 =?utf-8?B?SXZ3S1NQVWRsTDlMWk5MMFFCcEhMZ2x6SndmMzVBV3hxUVVXZXJOVVJyK1Vl?=
 =?utf-8?B?R2ExbExhMDRUTUlubG9EdERxaFdmUE5qUzVDZ1J3RGpnb05FVmZUZzdwMlVt?=
 =?utf-8?B?NDVIcmlnOWVpNjQ1T1RJTE1lQ084UVhSWmVpN29xVEpyTnpRSFpzdkxaYWpr?=
 =?utf-8?B?VUtHYnlFRmpGOStxUkR6N0xMTWxzOGRYbU5ta2JLM2pmdGdlUURrY0xtdGt5?=
 =?utf-8?B?UXJ3bW56a3ZvcEZWRzJnODBOczdaRzluZlRhNWhTSHAvSFBDZTRoN1pGakow?=
 =?utf-8?B?QzI1dmVwd3FlcXVsYnNRZXAwQUVOK3JvbFJMR1Q2S215SVpXcUpoRmtmS3lo?=
 =?utf-8?B?YldUQnQzYW9TNlNYSTRzQ2E3SU5hcUI0WEowc2dnVldzT25ITnlvbWpsOVI1?=
 =?utf-8?B?VE1BZ1dWUFhtZFFOMy9hd0I4NFhQN01pZ1EvcnNRdnhjQWUrT3FzZ2JOQSto?=
 =?utf-8?B?aE5TRkFLNFgvS0FzQit3TU5VQlFlY1pDaHRGMUF2SVZXdjhrdGlucEVaTXBC?=
 =?utf-8?B?QzBaUG9RZXFuMVRTRW5QTmEwUnN1Uy9HeXlsSzJFemszV0c5cWFLcWlFZkRY?=
 =?utf-8?B?R2g3cWdUTG54cWNQa2hKdnJzYXVtZEtjekNXUTE3ZVQ5ZUJiRnJCdTBCSDJY?=
 =?utf-8?B?TG5Zd0hia09IN3VtdkIzMmNkT1hHb2dlUEdBekd0eVVzdGxWN1RwbElrSExp?=
 =?utf-8?B?SGVpTHl3VGJORFBnTmxXd21HdENSUXk3alN4L3VhWmN4Wmh6WFg3aXBhVkZH?=
 =?utf-8?B?eE1BNjZldXQya2xIVUtwZXlJZzVpTGlIZWdyY2lmK05NUHlwbjYrK1EvNnFT?=
 =?utf-8?B?djJJRGdSTmFodzhCYXFwWTA1SUdQRWtLYTRrOWJ6Vjd0ZGdUU1VGSVV4MlhK?=
 =?utf-8?B?TXpsNXBsR1RzM2FFMzN1bHdjUGtkamVrMjdqbVU4bmVTTWNQaHJVVmNxc055?=
 =?utf-8?B?QkFlazZFTkM5WUZ3MnJjdDVoNStoMkxEY0hQbCtOUjhSdGc0Wk5JbFAvWXkx?=
 =?utf-8?B?MzJra2NucUlTVmZIRGY3WWxLeHd0Q2JFQWJFSjNRSVdUVTZxaHR5SVNZd2pV?=
 =?utf-8?B?eStwQmtRYmhwc0tzaitmTGFQSlRtZnluQTlCSUZGdGVRRXhqRG4yRk45eXlK?=
 =?utf-8?B?eUxVUk8xbTU1L3l2OE52VG9Ed3pvcTY0M0VNa2lwT0lVZlllMG5LVFFjeUZt?=
 =?utf-8?B?cjdJTGs5SDVzdWZ2blVicEF4bGsyQTVIcGNPbDMxQjA5QkpYNFZvYjRqeUxy?=
 =?utf-8?B?S0V1azJSTDg3ZmhhTkZvMzhMUW9qZUg4aUFEcHcxUWQvSkJ1QWhwTjVobGJp?=
 =?utf-8?B?dG1KY3pUK2crWnh5MW9TWUpKNVVjWHdtUVBMVXQ1ZTNyZmc4bWdudWh4bVRO?=
 =?utf-8?B?bUJHQzJyY09BVDZ1dVhTUHB6dGJ2S2E5YmZibmU0OTlWYjA4QjB5eHNOeG1w?=
 =?utf-8?B?VVg3WWVpSnZkYXMxRW9kcHpoVU0xVTVyL3RWUmJzbWMweWF5TmlLRTNiUzA0?=
 =?utf-8?B?S0MvSlI5a01QS0VCU2k0M2tTazlTenNlRHdzSFdnMUVyU2EzbWhkWlFzQURM?=
 =?utf-8?B?L3A4ZytkYmlubGQ3U3hPcStxdTJTWXBZU3VKOVNUM1J2c0hrb2ozc0hXT2pB?=
 =?utf-8?B?dVpBd1lmZ1YrYnlRcVMrZW81MmZPYUZndHNlbmtNVWlGTVNlamlTd0pXWjBP?=
 =?utf-8?B?aHdxaFhKRFpFZXpiUjY0a2o4YnNQSXhHQmJLbG04bGdVSHZWaVp6endkdVNL?=
 =?utf-8?B?WUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <578A8961B479C242A5E81E7551C7C7CD@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KK13CMHLNK3FEfWCXzL/S6v8bMY9otNcCLHlYICkVt8pP1/EGFIIbaeVhFNjNTA231qMMinOaZuhMoProD/oxSf6FQTHp1Y5UAz9piVXZqlH0nzxKsScBiFk9XhnzFUSyRQx1Vv+5bpSgyYu9TFPLX3g7JL4YnDAW5VjYmQTMaQxCtqMO8QPE1brebr9qaVBATlhuJvcZ+XA8vMXLYI2UqJJXiv/6Eg1eBL4yeKUMniwWNYWQ2JkIFXJKgeGl3hk6WjQjlnVLBiteYdEEUAehv+5i16iiP6PeLS8TfsYOOtVpZTj76pYTD9zD9PLMxnzfgS95u1oovogD7HupuQxNvun0+q6BctEQoQlfQYCar8HgEBz6F88l53Fww5kaGfBVpRfFoBhsr+c6yHFL8Gpeh09uHHXUd/FfmUHhQJvyVmiPLWxBTpWoJmArWftxXY3QoJmkC+Jp8yoMgPrjJeNmL/D6kQBpuGGdLn46cx9S6Dyr0zygoxb19UcU7lJ9+OjFmR+5ZK48qD1OKVaS6hrpw4qkYq0LcpkP7hM4iOGFAigiRS62rKSqjRa9h+IjeNeILHd2FonzFGhpBRFpAud1YYtnrrdYEwKb/59TLLU4XnO1FL8b3HdLY5DQVa5NBrO
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5442.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9692b7ac-6481-43da-917b-08dbfbb1df6b
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2023 08:02:37.9002
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E3TpS32+xzXVs4fVuJJ5AvoffLPpL+zmV+kiWYQjlX69oJXBzzgLXKi2G7Z6cd3j2laU36hnYyjwHmvAo/iEqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSZPR01MB9487

DQoNCk9uIDEzLzEyLzIwMjMgMDQ6NTEsIEFsaXNvbiBTY2hvZmllbGQgd3JvdGU6DQo+IE9uIFR1
ZSwgRGVjIDEyLCAyMDIzIGF0IDAzOjQyOjI3UE0gKzA4MDAsIExpIFpoaWppYW4gd3JvdGU6DQo+
PiBJdCBkb2Vzbid0IHdvcmsgZm9yICdbIG9wZXJhbmQxIC1uZSBvcGVyYW5kMiBdJyB3aGVyZSBl
aXRoZXIgb3BlcmFuZDEgb3INCj4+IG9wZXJhbmQyIGlzIG5vdCBpbnRlZ2VyIHZhbHVlLg0KPj4g
SXQncyB0ZXN0ZWQgdGhhdCBiYXNoIDQuMS80LjIvNS4wLzUuMSBhcmUgaW1wYWN0ZWQuDQo+IA0K
PiBTbywgd2hlbiB2YWxpZGF0aW5nIHRoZSBlbmRwb2ludCBkZWNvZGVyIHNldHRpbmdzIHRoZSBy
ZWdpb25fc2l6ZSBhbmQNCj4gcmVnaW9uX2Jhc2Ugd2VyZSBub3QgcmVhbGx5IGJlaW5nIGNoZWNr
ZWQuIFdpdGggdGhpcyBzeW50YXggZml4LCB0aGUNCj4gY2hlY2sgd29ya3MgYXMgaW50ZW5kZWQu
DQo+IA0KPiBQbGVhc2UgaW5jbHVkZSBzdWNoIGFuIGltcGFjdCBzdGF0ZW1lbnQuDQoNCg0KTm8g
cHJvYmxlbSwgdGhhbmtzDQoNCg0KDQo+IA0KPiBBbGlzb24NCj4gDQo+Pg0KPj4gUGVyIGJhc2gg
bWFuIHBhZ2UsIHVzZSAnW1sgXV0nIGNvbW1hbmQgdG8gZXZhbHVhdGUgb3BlcmFuZHMgYXMgYXJp
dGhtZXRpYw0KPj4gZXhwcmVzc2lvbnMNCj4+DQo+PiBGaXggZXJyb3JzOg0KPj4gbGluZSAxMTE6
IFs6IDB4ODAwMDAwMDA6IGludGVnZXIgZXhwcmVzc2lvbiBleHBlY3RlZA0KPj4gbGluZSAxMTI6
IFs6IDB4M2ZmMTEwMDAwMDAwOiBpbnRlZ2VyIGV4cHJlc3Npb24gZXhwZWN0ZWQNCj4+IGxpbmUg
MTQxOiBbOiAweDgwMDAwMDAwOiBpbnRlZ2VyIGV4cHJlc3Npb24gZXhwZWN0ZWQNCj4+IGxpbmUg
MTQzOiBbOiAweDNmZjExMDAwMDAwMDogaW50ZWdlciBleHByZXNzaW9uIGV4cGVjdGVkDQo+Pg0K
Pj4gU2lnbmVkLW9mZi1ieTogTGkgWmhpamlhbiA8bGl6aGlqaWFuQGZ1aml0c3UuY29tPg0KPj4g
LS0tDQo+PiBWMjogdXNlICdbWyBdXScgaW5zdGVhZCBvZiBjb252ZXJzaW9uIGJlZm9yZSBjb21w
YXJpbmcgaW4gVjENCj4+IC0tLQ0KPj4gICB0ZXN0L2N4bC1yZWdpb24tc3lzZnMuc2ggfCA4ICsr
KystLS0tDQo+PiAgIDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25z
KC0pDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL3Rlc3QvY3hsLXJlZ2lvbi1zeXNmcy5zaCBiL3Rlc3Qv
Y3hsLXJlZ2lvbi1zeXNmcy5zaA0KPj4gaW5kZXggODYzNjM5Mi4uNmE1ZGE2ZCAxMDA2NDQNCj4+
IC0tLSBhL3Rlc3QvY3hsLXJlZ2lvbi1zeXNmcy5zaA0KPj4gKysrIGIvdGVzdC9jeGwtcmVnaW9u
LXN5c2ZzLnNoDQo+PiBAQCAtMTA4LDggKzEwOCw4IEBAIGRvDQo+PiAgIA0KPj4gICAJc3o9JChj
YXQgL3N5cy9idXMvY3hsL2RldmljZXMvJGkvc2l6ZSkNCj4+ICAgCXJlcz0kKGNhdCAvc3lzL2J1
cy9jeGwvZGV2aWNlcy8kaS9zdGFydCkNCj4+IC0JWyAkc3ogLW5lICRyZWdpb25fc2l6ZSBdICYm
IGVyciAiJExJTkVOTzogZGVjb2RlcjogJGkgc3o6ICRzeiByZWdpb25fc2l6ZTogJHJlZ2lvbl9z
aXplIg0KPj4gLQlbICRyZXMgLW5lICRyZWdpb25fYmFzZSBdICYmIGVyciAiJExJTkVOTzogZGVj
b2RlcjogJGkgYmFzZTogJHJlcyByZWdpb25fYmFzZTogJHJlZ2lvbl9iYXNlIg0KPj4gKwlbWyAk
c3ogLW5lICRyZWdpb25fc2l6ZSBdXSAmJiBlcnIgIiRMSU5FTk86IGRlY29kZXI6ICRpIHN6OiAk
c3ogcmVnaW9uX3NpemU6ICRyZWdpb25fc2l6ZSINCj4+ICsJW1sgJHJlcyAtbmUgJHJlZ2lvbl9i
YXNlIF1dICYmIGVyciAiJExJTkVOTzogZGVjb2RlcjogJGkgYmFzZTogJHJlcyByZWdpb25fYmFz
ZTogJHJlZ2lvbl9iYXNlIg0KPj4gICBkb25lDQo+PiAgIA0KPj4gICAjIHZhbGlkYXRlIGFsbCBz
d2l0Y2ggZGVjb2RlcnMgaGF2ZSB0aGUgY29ycmVjdCBzZXR0aW5ncw0KPj4gQEAgLTEzOCw5ICsx
MzgsOSBAQCBkbw0KPj4gICANCj4+ICAgCXJlcz0kKGVjaG8gJGRlY29kZXIgfCBqcSAtciAiLnJl
c291cmNlIikNCj4+ICAgCXN6PSQoZWNobyAkZGVjb2RlciB8IGpxIC1yICIuc2l6ZSIpDQo+PiAt
CVsgJHN6IC1uZSAkcmVnaW9uX3NpemUgXSAmJiBlcnIgXA0KPj4gKwlbWyAkc3ogLW5lICRyZWdp
b25fc2l6ZSBdXSAmJiBlcnIgXA0KPj4gICAJIiRMSU5FTk86IGRlY29kZXI6ICRpIHN6OiAkc3og
cmVnaW9uX3NpemU6ICRyZWdpb25fc2l6ZSINCj4+IC0JWyAkcmVzIC1uZSAkcmVnaW9uX2Jhc2Ug
XSAmJiBlcnIgXA0KPj4gKwlbWyAkcmVzIC1uZSAkcmVnaW9uX2Jhc2UgXV0gJiYgZXJyIFwNCj4+
ICAgCSIkTElORU5POiBkZWNvZGVyOiAkaSBiYXNlOiAkcmVzIHJlZ2lvbl9iYXNlOiAkcmVnaW9u
X2Jhc2UiDQo+PiAgIGRvbmUNCj4+ICAgDQo+PiAtLSANCj4+IDIuNDEuMA0KPj4NCj4+
