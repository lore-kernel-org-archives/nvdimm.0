Received: from esa22.fujitsucc.c3s2.iphmx.com (esa22.fujitsucc.c3s2.iphmx.com [68.232.150.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39225101C6
	for <nvdimm@lists.linux.dev>; Mon, 10 Jul 2023 13:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1688994405; x=1720530405;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=M/3Yv6Bke0JFExA0fTdcUUXFudZwu83H0AAN+lIijdE=;
  b=ECkw7HszmLGYogJAfJYQkjZTfgo2XgFDOr+oiCJhlxdLteYRBz6OSKq+
   l0Ad8HROwhmI0eE0XiRGU47P7/+YQYSgoRRir8Tp0JBoaOU40W5X27VAu
   476QgZAaKxk5Il0AgVIvGsYbzpikefZgh3UjOivxemiPgugXFiHiKwInP
   rJj9ApFA3RzAtzyyhAw0ZhhE2oymphTNwR2tx/hMwCWFsSAk1BL0Vd43k
   EX2qkoWc6r5AfjMoR6lCvIkax5BTr2jP632XvcIfitzXEXAlR8J2ruiOD
   fTPdL0dehlcJ+YmxtwnUt/VN6gymM6pa0FOK8q1NRuQ9UbZiaDndUwTeE
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10767"; a="97555879"
X-IronPort-AV: E=Sophos;i="6.01,194,1684767600"; 
   d="scan'208";a="97555879"
Received: from mail-os0jpn01lp2108.outbound.protection.outlook.com (HELO JPN01-OS0-obe.outbound.protection.outlook.com) ([104.47.23.108])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2023 22:06:41 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VNjmjO1nTdyllRN6txKzOO+4WDOmULdfUQ8b3cp6Qa7OeAfA0cO8wKze9bDHaKPcqm/pAEVjxwSYWsfttkuozi+pw2fk92dPhf/5h4Knc4GCIMddagjSpaqF7ZUYesIIrqvln/BUAGSJl3ZoEdlCVsmFBr6/fvVnRAvQkKcZTIJCLa1WjMfDvKLukXdZcS2CZuto1tuhCoJa26dbbHivMJjFLllM79Bs2UDrYz9pMi5iVbBPP5H5K+IN/RvTpoiD3RzC9h3VrotOCPomEeDgVJUBo2S5EJODitTXJSkrKfHrWLII0m8dmtCcBJRHB+bqxaWNx4WV5uiAp2MM6sWyyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M/3Yv6Bke0JFExA0fTdcUUXFudZwu83H0AAN+lIijdE=;
 b=Ri6MvI6Ml3MRMJr61D4HRjLsZ/cwHR+prY+oUPTaXVtq6B734puCdQWn5Fy0TUfcGw2i/pp/WTdpIFpjjAfYKwfGS06+8d+LPQLOyDCRhzese9VPOVjiPeS/T5hkbDk40LCu56P19ZSdd6rB0imLYY8TORw/cvsd30ST2O8+RL4UGP0i6kkE361ieEMadC+j8GwRWcZgWgjwKlfm+BiqreOJvwSswqJM3Wz8pdFdSArEXpbToJwu8AYVx3SCtUjzCAgVuRUuHMDII6jeO48k0DMxopi4f84cf7ZXdjg7aduOzKnWrYxaPxlOUDpGIs3t+/qDUOxTp7Dt1uWabJBZpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from OS7PR01MB11664.jpnprd01.prod.outlook.com (2603:1096:604:247::6)
 by TYVPR01MB11200.jpnprd01.prod.outlook.com (2603:1096:400:364::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.30; Mon, 10 Jul
 2023 13:06:37 +0000
Received: from OS7PR01MB11664.jpnprd01.prod.outlook.com
 ([fe80::6d6e:460b:60f2:8d91]) by OS7PR01MB11664.jpnprd01.prod.outlook.com
 ([fe80::6d6e:460b:60f2:8d91%7]) with mapi id 15.20.6565.028; Mon, 10 Jul 2023
 13:06:37 +0000
From: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>
To: Alison Schofield <alison.schofield@intel.com>
CC: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"dave.jiang@intel.com" <dave.jiang@intel.com>
Subject: Re: [ndctl PATCH v3 0/6] cxl/monitor and ndctl/monitor fixes
Thread-Topic: [ndctl PATCH v3 0/6] cxl/monitor and ndctl/monitor fixes
Thread-Index: AQHZk2ZevVkcGUpVn0aSoZllGqanDa+sEPmAgAcm74A=
Date: Mon, 10 Jul 2023 13:06:37 +0000
Message-ID: <9caa0da9-4ca0-fa65-6619-6750c04ecb1f@fujitsu.com>
References: <20230531021936.7366-1-lizhijian@fujitsu.com>
 <ZKYCdf2RP3+3BMhi@aschofie-mobl2>
In-Reply-To: <ZKYCdf2RP3+3BMhi@aschofie-mobl2>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.1.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS7PR01MB11664:EE_|TYVPR01MB11200:EE_
x-ms-office365-filtering-correlation-id: 12def40f-f10f-4e0b-6847-08db81467eb6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 0BVrRQRXLdWQCQvyMTNcqo3+4WkOcItEsHyH9+pFmzWQS2ORP1InjdYa6pvYgEsV73rgr0ULouihKlUUqCXaFHQ9NEeZJr5+SCI0jmmpqZuS3Am7ycqy5FNf22TuwlW9XfZ6tdFtaIiAqhVAM47sZo3eu824lh+2xpHq+ZzpusbutsUTRA4eBN2eEJ0lcGPACpeSCEXxYA64KPA06VLDaG+uaxk14CPtte5/2Bzjtg3i33iP8T/h/ZwjBnpm14Mq52loDDl3LeNwF6Au5TkYyRLNLBGg9q/YzWiS+faORBv9c58FI47vWUvPOzr9b8ISM8ZGLnO697N5xmLfKoMu6rM+9Tlq04ylhd2zvCP3E4UkItDc3CBgsanulsE8KpeMl2hIAeyPIL70bKHeODHxmzin/qTNYKVcQCCLG5rd+dVFAEzE/9zL6oDLyAxHrf2U2HZGDoFGdIFYJIV5E2sYE8CbtmSDQtDy5tr7oUY645RqZ/pE8/TEwyiBes0/wp4G67SLq45cgZKkO20DLxzEhBiKTOYi+Cpa2OKIX/n6jVOXOqHowO4YQ255sstWVylQbnAqunOw17LtvI1yEtw+sf5/3TJZk+CZqjm9Bst0m1p4X3fvEeKEq0Ro0ryulaKBE2RwOXTw6uiBxcHQWfXvXhUC3bP3kRUPBc8y6JDJvokmY7bp7meaujHtzQxzePeti+OLA8RZuqBFXxSenPmkdQ==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS7PR01MB11664.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(396003)(39860400002)(346002)(136003)(1590799018)(451199021)(86362001)(31696002)(38100700002)(38070700005)(82960400001)(31686004)(1580799015)(36756003)(85182001)(71200400001)(6486002)(54906003)(76116006)(91956017)(122000001)(26005)(6506007)(186003)(6512007)(2616005)(5660300002)(2906002)(66556008)(316002)(478600001)(66946007)(8936002)(66476007)(8676002)(83380400001)(4326008)(6916009)(64756008)(66446008)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?NnNNZWRSYnE1NlJ5S2s1emR5VUpVeC9KY3poenZWV2tMUHkzbjQ0RkpGYUxJ?=
 =?utf-8?B?WHo5SzEwSW42QkE4Mm40S1JYVStWYXhxdFN6OURvcVBFTlRVRU1OcXJrdEdx?=
 =?utf-8?B?ZVJ4SXArcXZNeXNPbnJacnBoR0pVYlp0dEljQ0t4RW5ETXBKdTJJM3FKanVl?=
 =?utf-8?B?SE15czkxT2poYXIyQW9rV0pYS1JRTm9KS05uRm1oWDZxU0o3RlROWmY4WXdz?=
 =?utf-8?B?UnpVOEZEK2JTSFNCaFN4ZHYzbzhybHRkYkR6b2JTVmJHWCsyNnFtMXlzSkQ1?=
 =?utf-8?B?aHFWa1NkTjlaVjVnT2ZDVWhYM1VrZ3pEQ3c3RmgrY284aXRHV2FTQU9BWlBp?=
 =?utf-8?B?RDJBekFaWTU0dnBLRDcvK2JBTTJjbFFjazN5QU9HdU8vNzFKUG9GcHFDNXoy?=
 =?utf-8?B?cnJuWkN4aW9CMGhhVVY1d0t2RThwOTgvTnJLUEhSYlgyejgrQWNRQmkxc0Iw?=
 =?utf-8?B?ek13UFNUYlBXNERxNUIxS0lia202cU0zazZPTVZoWmVUdFl3UTdaRmZoT0lK?=
 =?utf-8?B?VmtKd0lpUC8yV2VQS2NXak9TS0F3SExBQUpWTEtTTEt4SXVVK1lnRFE0dWNG?=
 =?utf-8?B?cG9YY1gzRG10aVI0ejl2dmJaek1oancvWC90bWtNc1JIdFBaRjNLT0Myancv?=
 =?utf-8?B?cGFTNFM3T0t0emNJTDJMRjBhUW8zWkVic0FJRkt5cFk4YkthVUVWL3huQ1hW?=
 =?utf-8?B?Si9xTWdaU0tnalpyWUh3Z29TYVY1RmJsSFNDdzJieFNIeGU3YU5tbVBNNFpr?=
 =?utf-8?B?WEw2UzJQR2RqSk5SczRnWDBnR1NDbjJmQ0FZSFh6cU1pd1RraG8wTS9ralNa?=
 =?utf-8?B?RDlXYzhGd1FFcVBzdVFTa2tsYW9xbkRHRU5hV3ZObkxhMDdrMTlTVkE3bVU0?=
 =?utf-8?B?a2h6WW1TSWRvSFlFL21vWG5uQjJuRmQ2b2x3bzJXdi9FbnpLK21kL0VIM3ds?=
 =?utf-8?B?aW9uemlzUFBHekhaK0ZFQjR2YUpsN3JsdWJSL2t5OFF5K3BiYUZuSlg2dUl2?=
 =?utf-8?B?SjBvQmx2TVJ4a2dLTjFLWGI1eWhqWTZLTlkvdEhOb0RPS0RLeTVvcGlWNDgz?=
 =?utf-8?B?akF5SHMweFNwQkJEMFdUL29uWDErSytPS0pSTHBneWJsWlVYdDNoenlDbldt?=
 =?utf-8?B?clZpWmFaeDdtVHJzdUtiaWgyWUs0QzFnaTFzRzliQ3RzY2pYb3liR3Jwcm9o?=
 =?utf-8?B?bEFsdHdDNVhIbVU5VHBTTHBGWGN6ZWZSMDZ2cmxZTk01SEFjeC9IVGxXTUZq?=
 =?utf-8?B?VGVkL2Y0VUJwRXhScCtOaVU5YTRUVVk4WWlQOTNxWHNpbWpSdzFOZ3dwZjJm?=
 =?utf-8?B?dlBoWkRKZXUxZ203dHA3dSs3QUJOaWN6MzYzeS9sNUxKRG4rZGZiQndsaENr?=
 =?utf-8?B?b214NTdWZmVaWGR4cFVNSUYrSXVqU0FnUnFsVnV2YmRobjdISUxDbTltdWNE?=
 =?utf-8?B?MGtLMTZHN1c3M21VR01aS1RzRUF2a1RLa1g5V1RXYktKY250UVRkdzVKbTR0?=
 =?utf-8?B?UStIT0kwNXE2VDMyM24rbTIzMCt5NkI2ZTZqWENpMWtWY054RXBRVXlsN3d3?=
 =?utf-8?B?b3RjTXBzcWFZUFBMM014OWhRdXA2QzZIZjRxdFplajRlblZFNlRVRTVQSm1o?=
 =?utf-8?B?SlF4ZmlPdXBMb3I0Wm0vODlxUEhtNHN5NHJoZlZHZlA2cWExQWFVY0lHa3V1?=
 =?utf-8?B?Y05aTTZCdzduVHFmRTFra0JyUDJRcnZiYjd0WEIyUnJCZC9JSFNtNUdZN1ZP?=
 =?utf-8?B?KzJYTUlaZUlQc0VPL2Nja1hlZmxRRzFEREo3VGlOejFjVjNDbFdpdlZCS2dm?=
 =?utf-8?B?RFU0SzJiYzFvY2JOOXFXVE9Ibk9DN2xkdDBYTVR6cUVleXYvbWYrUUMwdE1v?=
 =?utf-8?B?ejdONE5zTFp3cnlMZmxSaUhlR0J0aU1McmxiNmM2R1B1NHJITFAzSW0yRjJJ?=
 =?utf-8?B?QTAxOGxXWXRHM0pDVmd3SjZNQ1k4clJlczBua0J0aVdudGhBT3gzWThjNWFF?=
 =?utf-8?B?enRudG1Ucmt5Z2p1c201MVZ5MUo2eGJUQ1h0OUQreU9DNjByM0xNZjJadzRj?=
 =?utf-8?B?TGt2VnlnVW1BdmNqdEQ0cWg0ODNjOVNGTUJoN1ZUSEljRERGUlh6dVRSdXVH?=
 =?utf-8?B?NlFTZHJNcUdtRm9xODFBaHNtRnVyeThSTmhFNENya2hPMVI1QnpTK2dzSWJy?=
 =?utf-8?B?UkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7C902A8761BAF941AEDC0DB7FAF865BD@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	IgAcpcDhyzVcb7kgrMtht2/DveljKg1zZGFK/hqfNWtf5iRwLzjKeBVr6uS1sQMxqa2fJT6Y9zJai89lQBs5tbDqc6dSbZUb1lJRqc9C1XnveBYuG8/TzgQnnzCo84V3oAwvq0qSVMRpMJdUGole+7xsCXDfeUJx/0gsKNOosy96tPD2j5wMM+5QikCbwpF5bSYqP2fKH2KxeZqtjFcLHgiJGD3yOBu+CTbkooPvgo+WQ4cZZhCSVyN0MVCHbRrJ1dravJ/NWwHyIpCiI4dyGtCHGGSmOYo1bW4CBVK4UZQKHxvfrzmizfcMo0ICV9NZJ6AmkCdEqYVdtWNOCSGjPOsB4VwwaSzoMXmQ0x5R4/BVtBSCE+NwyYAKZk43Jd0QxfO6tnzvFqln3WA9TZmoWVKXQta2ed7JlcZzeYfILfmx0yp4DQY16jfmoPyjYVG4wk/pICQ7JC4FN9cgK3unsDTpN07hg/b+bWhGE8xROwcIA5HnDlxxwMoBoraqA++q71YR5J7GYUc7ZbmuvyDsMXk9bI2wU4rGfDVoSt7CZRlw0t0JPrAccwodSusgybFfi16d6760Ss5aOUiw2R4RHZ9XCgdFLyyQLbKPcrxKf6vEFcLpVAVoYOTZlYmat2BY4nsIo0BfDmsb825u856KzS++B1o+fH++RQv/4Xny45rgO4oEjQ7QzXainIRVtrJnoSJO5qEZazMc/5Lv+hsXYKIzslSV7vLa21/QoE4guUy35dCjLNitj5/yZ0YCjGfdP9toblSGCTegIQr1an0B9EC1bBf45YNiM0UTAHu3u/mabIdXUuronZLExkt3XaGnEGXAZO2FW8TChGugrPnsgw==
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS7PR01MB11664.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12def40f-f10f-4e0b-6847-08db81467eb6
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2023 13:06:37.6507
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZlitgyUZYcGcEkk6c2hm/jShaQmV9gN62q1L2Jor3P8HihdI9nNPIno0kfXknE6K0sgKFgaO0eO/ii1CaFzXKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYVPR01MB11200

DQoNCm9uIDcvNi8yMDIzIDc6NTMgQU0sIEFsaXNvbiBTY2hvZmllbGQgd3JvdGU6DQo+IE9uIFdl
ZCwgTWF5IDMxLCAyMDIzIGF0IDEwOjE5OjMwQU0gKzA4MDAsIExpIFpoaWppYW4gd3JvdGU6DQo+
PiBWMzoNCj4+IC0gdXBkYXRlIGNvbWl0IGxvZyBvZiBwYXRjaDMgYW5kIHBhdGNoNiBwZXIgRGF2
ZSdzIGNvbW1lbnRzLg0KPj4NCj4+IFYyOg0KPj4gLSBleGNoYW5nZSBvcmRlciBvZiBwcmV2aW91
cyBwYXRjaDEgYW5kIHBhdGNoMg0KPj4gLSBhZGQgcmV2aWV3ZWQgdGFnIGluIHBhdGNoNQ0KPj4g
LSBjb21taXQgbG9nIGltcHJvdmVtZW50cw0KPj4NCj4+IEl0IG1haW5seSBmaXggbW9uaXRvciBu
b3Qgd29ya2luZyB3aGVuIGxvZyBmaWxlIGlzIHNwZWNpZmllZC4gRm9yDQo+PiBleGFtcGxlDQo+
PiAkIGN4bCBtb25pdG9yIC1sIC4vY3hsLW1vbml0b3IubG9nDQo+PiBJdCBzZWVtcyB0aGF0IHNv
bWVvbmUgbWlzc2VkIHNvbWV0aGluZyBhdCB0aGUgYmVnaW5pbmcuDQo+Pg0KPj4gRnVydHVyZSwg
aXQgY29tcGFyZXMgdGhlIGZpbGVuYW1lIHdpdGggcmVzZXJ2ZWQgd29yZCBtb3JlIGFjY3VyYXRl
bHkNCj4+DQo+PiBwYXRjaDEtMjogSXQgcmUtZW5hYmxlcyBsb2dmaWxlKGluY2x1ZGluZyBkZWZh
dWx0X2xvZykgZnVuY3Rpb25hbGl0eQ0KPj4gYW5kIHNpbXBsaWZ5IHRoZSBzYW5pdHkgY2hlY2sg
aW4gdGhlIGNvbWJpbmF0aW9uIHJlbGF0aXZlIHBhdGggZmlsZQ0KPj4gYW5kIGRhZW1vbiBtb2Rl
Lg0KPj4NCj4+IHBhdGNoMyBhbmQgcGF0Y2g2IGNoYW5nZSBzdHJuY21wIHRvIHN0cmNtcCB0byBj
b21wYXJlIHRoZSBhY3VycmF0ZQ0KPj4gcmVzZXJ2ZWQgd29yZHMuDQo+Pg0KPj4gTGkgWmhpamlh
biAoNik6DQo+PiAgICBjeGwvbW9uaXRvcjogRW5hYmxlIGRlZmF1bHRfbG9nIGFuZCByZWZhY3Rv
ciBzYW5pdHkgY2hlY2sNCj4+ICAgIGN4bC9tb25pdG9yOiByZXBsYWNlIG1vbml0b3IubG9nX2Zp
bGUgd2l0aCBtb25pdG9yLmN0eC5sb2dfZmlsZQ0KPj4gICAgY3hsL21vbml0b3I6IHVzZSBzdHJj
bXAgdG8gY29tcGFyZSB0aGUgcmVzZXJ2ZWQgd29yZA0KPj4gICAgY3hsL21vbml0b3I6IGFsd2F5
cyBsb2cgc3RhcnRlZCBtZXNzYWdlDQo+PiAgICBEb2N1bWVudGF0aW9uL2N4bC9jeGwtbW9uaXRv
ci50eHQ6IEZpeCBpbmFjY3VyYXRlIGRlc2NyaXB0aW9uDQo+PiAgICBuZGN0bC9tb25pdG9yOiB1
c2Ugc3RyY21wIHRvIGNvbXBhcmUgdGhlIHJlc2VydmVkIHdvcmQNCj4gSGksDQo+DQo+IFBhdGNo
ZXMgMyAmIDYgbWFrZSB0aGUgc2FtZSBjaGFuZ2UgaW4gMiBkaWZmZXJlbnQgZmlsZXMsIHdpdGgN
Cj4gbmVhciBpZGVudGljYWwgY29tbWl0IGxvZ3MuIFBsZWFzZSBjb25zaWRlciBjb21iaW5pbmcg
dGhlbSBpbnRvDQo+IG9uZSBwYXRjaCwgcGVyaGFwcyBzb21ldGhpbmcgbGlrZToNCj4NCj4gbmRj
dGw6IHVzZSBzdHJjbXAgZm9yIHJlc2VydmVkIHdvcmQgaW4gbW9uaXRvciBjb21tYW5kcw0KDQpP
a2F5LCBpdCBzb3VuZHMgZ29vZCB0byBtZSA6KQ0KDQpUaGFua3MNClpoaWppYW4NCg0KPg0KPiBU
aGFua3MsDQo+IEFsaXNvbg0KPg0KPj4gICBEb2N1bWVudGF0aW9uL2N4bC9jeGwtbW9uaXRvci50
eHQgfCAgMyArLS0NCj4+ICAgY3hsL21vbml0b3IuYyAgICAgICAgICAgICAgICAgICAgIHwgNDUg
KysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLQ0KPj4gICBuZGN0bC9tb25pdG9yLmMgICAg
ICAgICAgICAgICAgICAgfCAgNCArLS0NCj4+ICAgMyBmaWxlcyBjaGFuZ2VkLCAyNiBpbnNlcnRp
b25zKCspLCAyNiBkZWxldGlvbnMoLSkNCj4+DQo+PiAtLSANCj4+IDIuMjkuMg0KPj4NCg==
