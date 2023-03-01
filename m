Received: from esa6.fujitsucc.c3s2.iphmx.com (esa6.fujitsucc.c3s2.iphmx.com [68.232.159.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447B0EBC
	for <nvdimm@lists.linux.dev>; Wed,  1 Mar 2023 06:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1677652122; x=1709188122;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=XUvArrgkwruX+GLjHdpxe2BrxoaU0mlhv+xaAAuagPY=;
  b=ZsXFM0MEdN510c3YzN7NIJBQr6ISd/DWkw1kzZ7zvcWA1yqM/5R8XncX
   DXmBh1JyNIyPeIocC+V+qCX9SZbKHfFQkpnbhTL76ZwqYREXeo08H580R
   71Ubqe3XYb5Q0NGjKevgFCL+hgVamRpq9b03Pji1MxXHqcgh3n4V4hrG9
   EBQztyF5Y7vWbhsZ0VLnGv/JtcTKuTzHq1MbzGTMPpW4iMprvV2BAeANH
   VgmoW5/ISwlBsGBlCCDWD3dbRv9lAboePGKXzun9yr7yzLCBAosyS9Jdp
   6fsX2+rI9cJjGFNClw7sGNahdiXAFdJgYQXnj5D2mLJ7ABWdPZJ/fj9A3
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="78205488"
X-IronPort-AV: E=Sophos;i="5.98,224,1673881200"; 
   d="scan'208";a="78205488"
Received: from mail-os0jpn01lp2105.outbound.protection.outlook.com (HELO JPN01-OS0-obe.outbound.protection.outlook.com) ([104.47.23.105])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 15:27:27 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fhTRQAyEqfbyqf/B5aKOi/28g+PmOXulCwaqT/nAis75/yzHpv6SizgQpVoMQcRNnjh9QlxWRlna08htv1t8lb4t4vKTzEYf1BculUrdhQZ29NYJeuzE00cZVm2fCr1z8P1rBvJXYieVjaeyith6w0xWrvwTTmmAE0M2bKf4lqFQNTfk8Dg+VG0Lzqb8r53FcgzjCxPrmt/axQqF0k2DhxptOctWnH4U961m731WgzIhd5wuagrbOBAj4w/SvZaoH6bFhV+he11J8RXuV4KbILblkZipwQ0Dn5U0DnRdhPUlkQ1oLmmYxBS9Hd5m91TB/4CZ7RzQV1vK17wSp35cNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XUvArrgkwruX+GLjHdpxe2BrxoaU0mlhv+xaAAuagPY=;
 b=jMSgo+QFixItuWUyPyXUUOwntScnNKfxzO50Faxa3ETMiVjn+h9yOMNdlz6XKC2ugKbAMSoqe9i+xSZIkNNRfGTPvL07+K+PU+VM/WAUxhBCb0SesdeuG9dkRUK5IgLVsWrM57YypU2be+STaIfJrbjTWJqxnCosOB4ol3BdqiXaX3oyI9NKL6jKyUDpa16ieZ62MZj07xdXzyc2Dz7q530gt1tk40OwDnNeieTzoVX2K7vCnNP+Tk0LI3rEexZHJ99+oZ+Ez+nLtkKUZ/k4V63QuZ1UuhYQTGd2Db+/Hx6yxWR4tg3yWLD2UtzqiYzb8BsTYXxeW+bcaGmxNYx1DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from OS3PR01MB10390.jpnprd01.prod.outlook.com
 (2603:1096:604:1fb::14) by TYCPR01MB10229.jpnprd01.prod.outlook.com
 (2603:1096:400:1ee::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.17; Wed, 1 Mar
 2023 06:27:23 +0000
Received: from OS3PR01MB10390.jpnprd01.prod.outlook.com
 ([fe80::2381:b0a1:7818:ce58]) by OS3PR01MB10390.jpnprd01.prod.outlook.com
 ([fe80::2381:b0a1:7818:ce58%8]) with mapi id 15.20.6134.030; Wed, 1 Mar 2023
 06:27:23 +0000
From: "lizhijian@fujitsu.com" <lizhijian@fujitsu.com>
To: Baoquan He <bhe@redhat.com>
CC: "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "vgoyal@redhat.com" <vgoyal@redhat.com>,
	"dyoung@redhat.com" <dyoung@redhat.com>, "vishal.l.verma@intel.com"
	<vishal.l.verma@intel.com>, "dan.j.williams@intel.com"
	<dan.j.williams@intel.com>, "dave.jiang@intel.com" <dave.jiang@intel.com>,
	"horms@verge.net.au" <horms@verge.net.au>, "k-hagio-ab@nec.com"
	<k-hagio-ab@nec.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "Yasunori Gotou (Fujitsu)" <y-goto@fujitsu.com>,
	"yangx.jy@fujitsu.com" <yangx.jy@fujitsu.com>, "ruansy.fnst@fujitsu.com"
	<ruansy.fnst@fujitsu.com>
Subject: Re: [RFC][nvdimm][crash] pmem memmap dump support
Thread-Topic: [RFC][nvdimm][crash] pmem memmap dump support
Thread-Index: AQHZR0+Bi1lA/ErA5EK0zxLjybbH0K7kbFaAgAESzQA=
Date: Wed, 1 Mar 2023 06:27:23 +0000
Message-ID: <777f338f-09cb-d9f4-fe5f-3a6f059e4b02@fujitsu.com>
References: <3c752fc2-b6a0-2975-ffec-dba3edcf4155@fujitsu.com>
 <Y/4JxQtnmYrZgVwF@MiWiFi-R3L-srv>
In-Reply-To: <Y/4JxQtnmYrZgVwF@MiWiFi-R3L-srv>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS3PR01MB10390:EE_|TYCPR01MB10229:EE_
x-ms-office365-filtering-correlation-id: 544957e4-0e51-4c7f-648c-08db1a1e0509
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 pILbkodvh5BrzV4GGGRumQAXQvhNFYEjmecV4xYYKBq1sr3ovsjp+LqUkuR0Ljnzn2ZnTsiaP+BADsQmETsy1NqSiyDfSwEIxRyrvm5nUjRjhNEhz1WaqyKKEQDtpFdZAuDttg8eL8rLxfljgKlqfEH4jjFpaD9zCnullkd/gnUSKgtDePty50mO12aqgcU6GMpgiqAzyEjndKoVcqJQACdlA/y3p9fK0AxJpCYtT6t/J1zOnZrDZ/Xeiu+mw8HTFZd6PN7jc3W9jAgL8ZFStiPerwQkrDphSQbG7pKfHugfVO8vyb+Ozrn/fKVYS5fi+ttZR7cZfm8N1j0np5rV67XScf6xwTfgUo3UM73Flx4EcCR9AG2DPMZ0a0ou6ZRFb6TjRm02DvU+2kO5kT5dFvJ2fhPpXXNaBrQuqmWw2ZPG54TIEiQGr4FpGzs+V5IgQTHMVZwwtOZXk2lZcx93HOWLCJ9CErXZHkgTFRvOvvO7IuljHL2xmB9ten5ZVK0f9jIUz0NC94cDfltw60yzTySHR7nZ4mLxh1uVWNVJZnO1F10woI2CqeQTmfbb5Q2E/PbbjUzTNnuSdHbr2932IEr9k3lODycu7WUyqa2VxB/mqVPmVkMdIs85X45Y5caC7JDmU7G9yHGorRUeXJzkYHVb6jLEhLTz9vyw1aHf28cWJcdbJz2UVqPF0HKIygcz/AZ/bx6YN1591SdTI+aOUgHdMWmbWFJBf48AJOVz4Y4fgFzcxcxjxISW+RkgNaopcyDnyu28DHrWPkmlLJUkXaQuYPBER6i+EYFVVU7yXQM=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS3PR01MB10390.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(136003)(39860400002)(346002)(366004)(1590799015)(451199018)(2906002)(31686004)(1580799012)(7416002)(26005)(5660300002)(85182001)(66556008)(36756003)(8936002)(66476007)(66446008)(64756008)(76116006)(86362001)(91956017)(66946007)(54906003)(316002)(31696002)(6916009)(8676002)(6486002)(38070700005)(71200400001)(4326008)(478600001)(122000001)(82960400001)(107886003)(38100700002)(6512007)(41300700001)(53546011)(6506007)(186003)(2616005)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?M0VmcmdOZG9GRGJnUTc2akpxV1FZcnlxK1l0UHA2b1d1UzhESE5rTlJ1VHYz?=
 =?utf-8?B?a2hYbG9hNzZoTTNjL2lOSDVwRksvSVJ0UDEzcXd6V3FtaUoxc1NzcGlLTkxO?=
 =?utf-8?B?Z1pFSG9qWDZvVjRSN0hjbmZWc3BKQllJUUpvM3p5ZzJtci9MRXFlWUJSUzRW?=
 =?utf-8?B?MUFtWlpFRm9DYVVjT0hXMEV2SnRJdXpZbGFKRkQ3SDM5NGEwNmtUNGloZ3Jh?=
 =?utf-8?B?LzZBNTdLTFBubWZ1S2J6RFVmc3lOMUM4QnFnN0hNTVc0clN5WXMxTUY5ZVNK?=
 =?utf-8?B?azFDWFNkNW9PV2lhMVYrNWRJdWpXNDBkTVZpQ1pmS09YdVNzR2ViNGQvVjdC?=
 =?utf-8?B?Y2xTckVxbW1xRVJmRkc1RDJkVVNlWGJKcDNDdHBNWEw3amE4V2FLZHBYdmVt?=
 =?utf-8?B?ZWNDcjJEcm01L3RiRk9jMEIrYktBOThYNzE3dzFBVE9iWTY4UHB5Z05UMUo0?=
 =?utf-8?B?MVZDWDlGMmR4YWRBMXd3ejF6dHRxUklJdzBKNnkzUGYyWXNFUi8zQ3prbDNs?=
 =?utf-8?B?V0ZWTWEzVWdDSndmcjArVHQrcmY2ejZqSXEwZjkvTzFOczFwUG1LWjRJQlgv?=
 =?utf-8?B?VTFkK0dpZ0dLSDFPOWRIaGxiamo0bVVDSnNENXg2T3VOeHRZaS9jQjlqWTJ2?=
 =?utf-8?B?OVpmUmFYVFd0eEdRdmw4RU9neld6YXJ1bmJIbUg1Ky9WaUxOaVcwS0gvbVM2?=
 =?utf-8?B?Q0ZDbEh5cHVtd1ZwWDMxTzBNVEt3KzIxbVVlWWpjVjhSTkdpWFR6bmhrNGxr?=
 =?utf-8?B?cGRocGtRdUdkTStDOFBKcTJzbkF5dGlpR2Izd09HM0FXTS9DTzRzdldyUE9j?=
 =?utf-8?B?TjBLTng5QjZtOTZRcDdhNmllSkE2ZEhjT3ozREpvZHNnR0lTT1pXOEVrYUJU?=
 =?utf-8?B?L1dHU2pJdmtjQ3hqR091djhJbk9JYXJ4bFE1QTFrOTdTVVNyNmp1VjBPWGhI?=
 =?utf-8?B?MWp6Ynd2NFk3cmEvWmYya2w0YlZjY2ZMYzc3RkE2VWxVbmZsOHM1SUd4OUZl?=
 =?utf-8?B?Q21IMnVHRTNDSWVmbENpV3VNWVQ0NWt2NUVxTWlmWWNSZUxXK05NNTJBaHRa?=
 =?utf-8?B?b2c4NW5nMEUyTm9qMktuaEVIbXhiT1BQazhDb0o5SUxXY2R3SkRHT3E4NVRt?=
 =?utf-8?B?QjIzeGlzSDF5NlBFTnFObkk1K0NaS1NiSG5UOUJZODVuU0pvY1JmZEk5ZExi?=
 =?utf-8?B?NFhQVjhkKzZjNjdHc3k0eHdCd2pGQ1NiVEJJbU1vOWpYZk9qbnNaMlNYV2d5?=
 =?utf-8?B?K2NVVUVMcGlkTHVwN2YzN21DVlFhRDFxeDREai9DWnpEVVhVQWNmY3hIT3o5?=
 =?utf-8?B?bStMRWowejNUbVRKcHBIckZHNFcydHdnUzZvMExRNHpaekVYYnRpalViY3Yx?=
 =?utf-8?B?Y0ZPZkVJUHpsV1FHQ1VoQlY3M1I2MG9wLzJVdVpjcnJLN3hlckk0Wk5xcXIw?=
 =?utf-8?B?MkMxREE1UER4VXBGUUVMeGJ4VGh2blNsbUZXdDFQTnd5aCtlcHByNTh6MHZ0?=
 =?utf-8?B?UnNpSlR3SzhCOXJDekdiLzdIMk9UaWplS1RhMER3UDRmWWttbjBwelVYRUVm?=
 =?utf-8?B?aGdZNXBmeVByWG5ya0FacHN5aWtWRXNmd3lYRkpIS1VQTGJoTUVKQkpUcVpR?=
 =?utf-8?B?UnhHYTBPbU5DY0tKMFlpa2twZmtsN0RJR2tnYW5WWlI3UWtXaUFWWkg4Sy80?=
 =?utf-8?B?VWwwY280MVJtNWxjcHA0dEZiSDlWTWF3MmN6ZFQ5QWZkSjAwYUtRUm1FMHVW?=
 =?utf-8?B?cU82RXZIdEdTZDhrWFJ4VEgrL0w0UmxzL3NKUVNHS29QMGE2SVlwVGNBUjNO?=
 =?utf-8?B?UkZBdGY5TnZpQTFyWU5taFlWMm50VkpYb2t4S3NmeHNybVVZTnB6eXk2UFM0?=
 =?utf-8?B?M0N1bXFSUUUyaldmUVI4TEw2VXphbUNQNkFyYm1iN3BDc1djbUdZZzBOQ2V0?=
 =?utf-8?B?MUc2WGIrQUNtUWQxR1BPK0hJMHkzemNSMmdNZHFjdlFYcHVtYUdYbmFkd0lp?=
 =?utf-8?B?U1dJSHZEbGRHSUJuYm56czRmeVErWEEwelQyaEduZFhQZFRBYnlrUVByMDNT?=
 =?utf-8?B?ejY3Y2FOeTlOcmxGU3Y1Mm1OU1I1YUdUbmNZeVNwazJtZFNwRUliejNmUjFp?=
 =?utf-8?B?cjczS2w4Y1EzWjY4WmxLOCs3ejhLOWdPT2FITGwxV1lza05hNnVBNFFhRFJB?=
 =?utf-8?B?NEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <441D89AF8BB0FE46BAA2BB01F0376DBF@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	=?utf-8?B?eTJOVkNkRm5mTDRtTHJPaCtBSVRScll4RkUwR25PSkd5S01nN1J4ekkyR3hF?=
 =?utf-8?B?bjVsTGZqQnhNd3NyRTRhRW0vUFhlQ2ZRdVRRSC9ubnIwN2dobUpNNUtsbWxS?=
 =?utf-8?B?Z2RRTTdKdEdNZ0VEWmJIME1tSllWaUZOOWROME5XUTkrdTQ2T0d4bEJ2SGV5?=
 =?utf-8?B?UEc2T3JuZlN0MkNwWWE2eWpFQlVFMnM1SWQ0OXRycmt0TzBBZ0RxOHNvUGlr?=
 =?utf-8?B?UVFoWWNUZGtEV3RUdGF6ZFc5cUJINnBUSzF6eThmcno4UDRYS09nNDc4bVpn?=
 =?utf-8?B?UklDQUNXVm5nbWh0a1BCcUxPRHA0TWVndnkrZWl3K3Y0RjVJcTd6a3p5YlNa?=
 =?utf-8?B?S2VlSDZlMTdPNDdIMGxFajBueUlydjBWbzBqcWRSOTRSZjFWZ2sxSCt3NzQ0?=
 =?utf-8?B?YWl0dVZlcFhqSnN4L3BacGNxYm9WL2Y4YWRYVnFYcGtMS1hvMkVPbG5GS1lJ?=
 =?utf-8?B?czJGYzNpSk1sOUNvUmpOQWFjdXZvb0YyY3BMdDRVY0RPR25pZ0hQMmwzQmw4?=
 =?utf-8?B?c2RkUHBQWU1TK1RwK3pXUDhIVFRoSEFXdzZsYnBzcFl3YmtBL1VDKzVYdXVz?=
 =?utf-8?B?em02S2V3MUJxWFJhNVRHNzExSFZHb1JNQWZKM0RNVk51eERDNlI4STdOY1ZX?=
 =?utf-8?B?aHZNNWhjdjJyRFFwVi9TczdOdFZOUjBlSlBRbUFCcFlaanlSTUp2ekJ0cGI2?=
 =?utf-8?B?MTVLS0NaVDdGMllOUEY4RUJSTW4zWEV0ZFRYV29LTmNSOTI2K2lEbWl1cldX?=
 =?utf-8?B?WDN4K2lXdmwvc1lrbjlvMzllbnVueld4aXNnT0V3amxramVQTWQ2b3FneTM3?=
 =?utf-8?B?bVVLYWxMcFR4T3JaN1R6RXVwM3NvNEcxR1FJMUxSRW1qYmpCTGtuQ2dOWFg1?=
 =?utf-8?B?VTBDRUhKWXN6a2l5cm54NTZJbWYwK2VWaGU4SHZaMzZmM2NhUmZaQVRZeTVo?=
 =?utf-8?B?eEllQWJuYmpkaUZVMDRvTXEvNmtiSXhCWlE3UXh2QjVuSUNXSDdncC9semdD?=
 =?utf-8?B?RHo1SUd5dnNsNlhkTHVlTjFXRXo3YUp1UUd6SlF0MldCU0FlaVVGb3hveWpT?=
 =?utf-8?B?RGUyM1FLRVFBSlFWdFUrZHlmc2VxQTMrVE51L3Y3eVBqNnRvQ2lFZnlseXA2?=
 =?utf-8?B?TFZzRGQwWHlmSzhYamdQNFEvdXovcE5rWXJaRGY3emR1YmYxSkdNbXFxZVZ3?=
 =?utf-8?B?ZXRUaVRrUzhaOVZjMVVTVGhVemczZ3oyaElsTTdCUWF3M3EwVWtERTZzQUoy?=
 =?utf-8?B?WENJbForT3lER3J0TVpRNHNYektDU0c0UDZoYVYxSmlnU1RXUVpaQ3JSd1lJ?=
 =?utf-8?B?SU04bGdUUlZDelFscGQvRThCTjBJWkcrRzlXd0lmUVBNNE5SYUk0ck11Y0s1?=
 =?utf-8?B?REU2RFVuYTZ4bmc9PQ==?=
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS3PR01MB10390.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 544957e4-0e51-4c7f-648c-08db1a1e0509
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2023 06:27:23.8587
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Heem0XRPequoWunam6EDF+AafCXCIgriGWqM3lU67NtplFA1DoCjzqIis8y0ZtP3RkQOyKnfiWkLaZOigtUhEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB10229

DQoNCk9uIDI4LzAyLzIwMjMgMjI6MDMsIEJhb3F1YW4gSGUgd3JvdGU6DQo+IE9uIDAyLzIzLzIz
IGF0IDA2OjI0YW0sIGxpemhpamlhbkBmdWppdHN1LmNvbSB3cm90ZToNCj4+IEhlbGxvIGZvbGtz
LA0KPj4NCj4+IFRoaXMgbWFpbCByYWlzZXMgYSBwbWVtIG1lbW1hcCBkdW1wIHJlcXVpcmVtZW50
IGFuZCBwb3NzaWJsZSBzb2x1dGlvbnMsIGJ1dCB0aGV5IGFyZSBhbGwgc3RpbGwgcHJlbWF0dXJl
Lg0KPj4gSSByZWFsbHkgaG9wZSB5b3UgY2FuIHByb3ZpZGUgc29tZSBmZWVkYmFjay4NCj4+DQo+
PiBwbWVtIG1lbW1hcCBjYW4gYWxzbyBiZSBjYWxsZWQgcG1lbSBtZXRhZGF0YSBoZXJlLg0KPj4N
Cj4+ICMjIyBCYWNrZ3JvdW5kIGFuZCBtb3RpdmF0ZSBvdmVydmlldyAjIyMNCj4+IC0tLQ0KPj4g
Q3Jhc2ggZHVtcCBpcyBhbiBpbXBvcnRhbnQgZmVhdHVyZSBmb3IgdHJvdWJsZSBzaG9vdGluZyBv
ZiBrZXJuZWwuIEl0IGlzIHRoZSBmaW5hbCB3YXkgdG8gY2hhc2Ugd2hhdA0KPj4gaGFwcGVuZWQg
YXQgdGhlIGtlcm5lbCBwYW5pYywgc2xvd2Rvd24sIGFuZCBzbyBvbi4gSXQgaXMgdGhlIG1vc3Qg
aW1wb3J0YW50IHRvb2wgZm9yIGN1c3RvbWVyIHN1cHBvcnQuDQo+PiBIb3dldmVyLCBhIHBhcnQg
b2YgZGF0YSBvbiBwbWVtIGlzIG5vdCBpbmNsdWRlZCBpbiBjcmFzaCBkdW1wLCBpdCBtYXkgY2F1
c2UgZGlmZmljdWx0eSB0byBhbmFseXplDQo+PiB0cm91YmxlIGFyb3VuZCBwbWVtIChlc3BlY2lh
bGx5IEZpbGVzeXN0ZW0tREFYKS4NCj4+DQo+Pg0KPj4gQSBwbWVtIG5hbWVzcGFjZSBpbiAiZnNk
YXgiIG9yICJkZXZkYXgiIG1vZGUgcmVxdWlyZXMgYWxsb2NhdGlvbiBvZiBwZXItcGFnZSBtZXRh
ZGF0YVsxXS4gVGhlIGFsbG9jYXRpb24NCj4+IGNhbiBiZSBkcmF3biBmcm9tIGVpdGhlciBtZW0o
c3lzdGVtIG1lbW9yeSkgb3IgZGV2KHBtZW0gZGV2aWNlKSwgc2VlIGBuZGN0bCBoZWxwIGNyZWF0
ZS1uYW1lc3BhY2VgIGZvcg0KPj4gbW9yZSBkZXRhaWxzLiBJbiBmc2RheCwgc3RydWN0IHBhZ2Ug
YXJyYXkgYmVjb21lcyB2ZXJ5IGltcG9ydGFudCwgaXQgaXMgb25lIG9mIHRoZSBrZXkgZGF0YSB0
byBmaW5kDQo+PiBzdGF0dXMgb2YgcmV2ZXJzZSBtYXAuDQo+Pg0KPj4gU28sIHdoZW4gbWV0YWRh
dGEgd2FzIHN0b3JlZCBpbiBwbWVtLCBldmVuIHBtZW0ncyBwZXItcGFnZSBtZXRhZGF0YSB3aWxs
IG5vdCBiZSBkdW1wZWQuIFRoYXQgbWVhbnMNCj4+IHRyb3VibGVzaG9vdGVycyBhcmUgdW5hYmxl
IHRvIGNoZWNrIG1vcmUgZGV0YWlscyBhYm91dCBwbWVtIGZyb20gdGhlIGR1bXBmaWxlLg0KPj4N
Cj4+ICMjIyBNYWtlIHBtZW0gbWVtbWFwIGR1bXAgc3VwcG9ydCAjIyMNCj4+IC0tLQ0KPj4gT3Vy
IGdvYWwgaXMgdGhhdCB3aGV0aGVyIG1ldGFkYXRhIGlzIHN0b3JlZCBvbiBtZW0gb3IgcG1lbSwg
aXRzIG1ldGFkYXRhIGNhbiBiZSBkdW1wZWQgYW5kIHRoZW4gdGhlDQo+PiBjcmFzaC11dGlsaXRp
ZXMgY2FuIHJlYWQgbW9yZSBkZXRhaWxzIGFib3V0IHRoZSBwbWVtLiBPZiBjb3Vyc2UsIHRoaXMg
ZmVhdHVyZSBjYW4gYmUgZW5hYmxlZC9kaXNhYmxlZC4NCj4+DQo+PiBGaXJzdCwgYmFzZWQgb24g
b3VyIHByZXZpb3VzIGludmVzdGlnYXRpb24sIGFjY29yZGluZyB0byB0aGUgbG9jYXRpb24gb2Yg
bWV0YWRhdGEgYW5kIHRoZSBzY29wZSBvZg0KPj4gZHVtcCwgd2UgY2FuIGRpdmlkZSBpdCBpbnRv
IHRoZSBmb2xsb3dpbmcgZm91ciBjYXNlczogQSwgQiwgQywgRC4NCj4+IEl0IHNob3VsZCBiZSBu
b3RlZCB0aGF0IGFsdGhvdWdoIHdlIG1lbnRpb25lZCBjYXNlIEEmQiBiZWxvdywgd2UgZG8gbm90
IHdhbnQgdGhlc2UgdHdvIGNhc2VzIHRvIGJlDQo+PiBwYXJ0IG9mIHRoaXMgZmVhdHVyZSwgYmVj
YXVzZSBkdW1waW5nIHRoZSBlbnRpcmUgcG1lbSB3aWxsIGNvbnN1bWUgYSBsb3Qgb2Ygc3BhY2Us
IGFuZCBtb3JlIGltcG9ydGFudGx5LA0KPj4gaXQgbWF5IGNvbnRhaW4gdXNlciBzZW5zaXRpdmUg
ZGF0YS4NCj4+DQo+PiArLS0tLS0tLS0tLS0tLSstLS0tLS0tLS0tKy0tLS0tLS0tLS0tLSsNCj4+
IHxcKy0tLS0tLS0tK1wgICAgIG1ldGFkYXRhIGxvY2F0aW9uICAgfA0KPj4gfCAgICAgICAgICAg
ICsrLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0rDQo+PiB8IGR1bXAgc2NvcGUgIHwgIG1lbSAgICAg
fCAgIFBNRU0gICAgIHwNCj4+ICstLS0tLS0tLS0tLS0tKy0tLS0tLS0tLS0rLS0tLS0tLS0tLS0t
Kw0KPj4gfCBlbnRpcmUgcG1lbSB8ICAgICBBICAgIHwgICAgIEIgICAgICB8DQo+PiArLS0tLS0t
LS0tLS0tLSstLS0tLS0tLS0tKy0tLS0tLS0tLS0tLSsNCj4+IHwgbWV0YWRhdGEgICAgfCAgICAg
QyAgICB8ICAgICBEICAgICAgfA0KPj4gKy0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLSstLS0tLS0t
LS0tLS0rDQo+Pg0KPj4gQ2FzZSBBJkI6IHVuc3VwcG9ydGVkDQo+PiAtIE9ubHkgdGhlIHJlZ2lv
bnMgbGlzdGVkIGluIFBUX0xPQUQgaW4gdm1jb3JlIGFyZSBkdW1wYWJsZS4gVGhpcyBjYW4gYmUg
cmVzb2x2ZWQgYnkgYWRkaW5nIHRoZSBwbWVtDQo+PiByZWdpb24gaW50byB2bWNvcmUncyBQVF9M
T0FEcyBpbiBrZXhlYy10b29scy4NCj4+IC0gRm9yIG1ha2VkdW1wZmlsZSB3aGljaCB3aWxsIGFz
c3VtZSB0aGF0IGFsbCBwYWdlIG9iamVjdHMgb2YgdGhlIGVudGlyZSByZWdpb24gZGVzY3JpYmVk
IGluIFBUX0xPQURzDQo+PiBhcmUgcmVhZGFibGUsIGFuZCB0aGVuIHNraXBzL2V4Y2x1ZGVzIHRo
ZSBzcGVjaWZpYyBwYWdlIGFjY29yZGluZyB0byBpdHMgYXR0cmlidXRlcy4gQnV0IGluIHRoZSBj
YXNlDQo+PiBvZiBwbWVtLCAxc3Qga2VybmVsIG9ubHkgYWxsb2NhdGVzIHBhZ2Ugb2JqZWN0cyBm
b3IgdGhlIG5hbWVzcGFjZXMgb2YgcG1lbSwgc28gbWFrZWR1bXBmaWxlIHdpbGwgdGhyb3cNCj4+
IGVycm9yc1syXSB3aGVuIHNwZWNpZmljIC1kIG9wdGlvbnMgYXJlIHNwZWNpZmllZC4NCj4+IEFj
Y29yZGluZ2x5LCB3ZSBzaG91bGQgbWFrZSBtYWtlZHVtcGZpbGUgdG8gaWdub3JlIHRoZXNlIGVy
cm9ycyBpZiBpdCdzIHBtZW0gcmVnaW9uLg0KPj4NCj4+IEJlY2F1c2UgdGhlc2UgYWJvdmUgY2Fz
ZXMgYXJlIG5vdCBpbiBvdXIgZ29hbCwgd2UgbXVzdCBjb25zaWRlciBob3cgdG8gcHJldmVudCB0
aGUgZGF0YSBwYXJ0IG9mIHBtZW0NCj4+IGZyb20gcmVhZGluZyBieSB0aGUgZHVtcCBhcHBsaWNh
dGlvbihtYWtlZHVtcGZpbGUpLg0KPj4NCj4+IENhc2UgQzogbmF0aXZlIHN1cHBvcnRlZA0KPj4g
bWV0YWRhdGEgaXMgc3RvcmVkIGluIG1lbSwgYW5kIHRoZSBlbnRpcmUgbWVtL3JhbSBpcyBkdW1w
YWJsZS4NCj4+DQo+PiBDYXNlIEQ6IHVuc3VwcG9ydGVkICYmIG5lZWQgeW91ciBpbnB1dA0KPj4g
VG8gc3VwcG9ydCB0aGlzIHNpdHVhdGlvbiwgdGhlIG1ha2VkdW1wZmlsZSBuZWVkcyB0byBrbm93
IHRoZSBsb2NhdGlvbiBvZiBtZXRhZGF0YSBmb3IgZWFjaCBwbWVtDQo+PiBuYW1lc3BhY2UgYW5k
IHRoZSBhZGRyZXNzIGFuZCBzaXplIG9mIG1ldGFkYXRhIGluIHRoZSBwbWVtIFtzdGFydCwgZW5k
KQ0KPj4NCj4+IFdlIGhhdmUgdGhvdWdodCBvZiBhIGZldyBwb3NzaWJsZSBvcHRpb25zOg0KPj4N
Cj4+IDEpIEluIHRoZSAybmQga2VybmVsLCB3aXRoIHRoZSBoZWxwIG9mIHRoZSBpbmZvcm1hdGlv
biBmcm9tIC9zeXMvYnVzL25kL2RldmljZXMve25hbWVzcGFjZVguWSwgZGF4WC5ZLCBwZm5YLll9
DQo+PiBleHBvcnRlZCBieSBwbWVtIGRyaXZlcnMsIG1ha2VkdW1wZmlsZSBpcyBhYmxlIHRvIGNh
bGN1bGF0ZSB0aGUgYWRkcmVzcyBhbmQgc2l6ZSBvZiBtZXRhZGF0YQ0KPj4gMikgSW4gdGhlIDFz
dCBrZXJuZWwsIGFkZCBhIG5ldyBzeW1ib2wgdG8gdGhlIHZtY29yZS4gVGhlIHN5bWJvbCBpcyBh
c3NvY2lhdGVkIHdpdGggdGhlIGxheW91dCBvZg0KPj4gZWFjaCBuYW1lc3BhY2UuIFRoZSBtYWtl
ZHVtcGZpbGUgcmVhZHMgdGhlIHN5bWJvbCBhbmQgZmlndXJlcyBvdXQgdGhlIGFkZHJlc3MgYW5k
IHNpemUgb2YgdGhlIG1ldGFkYXRhLg0KPj4gMykgb3RoZXJzID8NCj4+DQo+PiBCdXQgdGhlbiB3
ZSBmb3VuZCB0aGF0IHdlIGhhdmUgYWx3YXlzIGlnbm9yZWQgYSB1c2VyIGNhc2UsIHRoYXQgaXMs
IHRoZSB1c2VyIGNvdWxkIHNhdmUgdGhlIGR1bXBmaWxlDQo+PiB0byB0aGUgcG1lbS4gTmVpdGhl
ciBvZiB0aGVzZSB0d28gb3B0aW9ucyBjYW4gc29sdmUgdGhpcyBwcm9ibGVtLCBiZWNhdXNlIHRo
ZSBwbWVtIGRyaXZlcnMgd2lsbA0KPj4gcmUtaW5pdGlhbGl6ZSB0aGUgbWV0YWRhdGEgZHVyaW5n
IHRoZSBwbWVtIGRyaXZlcnMgbG9hZGluZyBwcm9jZXNzLCB3aGljaCBsZWFkcyB0byB0aGUgbWV0
YWRhdGENCj4+IHdlIGR1bXBlZCBpcyBpbmNvbnNpc3RlbnQgd2l0aCB0aGUgbWV0YWRhdGEgYXQg
dGhlIG1vbWVudCBvZiB0aGUgY3Jhc2ggaGFwcGVuaW5nLg0KPj4gU2ltcGx5LCBjYW4gd2UganVz
dCBkaXNhYmxlIHRoZSBwbWVtIGRpcmVjdGx5IGluIDJuZCBrZXJuZWwgc28gdGhhdCBwcmV2aW91
cyBtZXRhZGF0YSB3aWxsIG5vdCBiZQ0KPj4gZGVzdHJveWVkPyBCdXQgdGhpcyBvcGVyYXRpb24g
d2lsbCBicmluZyB1cyBpbmNvbnZlbmllbmNlIHRoYXQgMm5kIGtlcm5lbCBkb2VzbuKAmXQgYWxs
b3cgdXNlciBzdG9yaW5nDQo+PiBkdW1wZmlsZSBvbiB0aGUgZmlsZXN5c3RlbS9wYXJ0aXRpb24g
YmFzZWQgb24gcG1lbS4NCj4gDQoNCg0KSGkgQmFvcXVhbg0KDQpHcmVhdGx5IGFwcHJlY2lhdGUg
eW91ciBmZWVkYmFjay4NCg0KDQo+IDEpIEluIGtlcm5lbCBzaWRlLCBleHBvcnQgaW5mbyBvZiBw
bWVtIG1ldGEgZGF0YTsNCj4gMikgaW4gbWFrZWR1bXBmaWxlIHNpemUsIGFkZCBhbiBvcHRpb24g
dG8gc3BlY2lmeSBpZiB3ZSB3YW50IHRvIGR1bXANCj4gICAgIHBtZW0gbWV0YSBkYXRhOyBBbiBv
cHRpb24gb3IgaW4gZHVtcCBsZXZlbD8NCg0KWWVzLCBJJ20gd29ya2luZyBvbiB0aGVzZSAyIHN0
ZXAuDQoNCj4gMykgSW4gZ2x1ZSBzY3JpcHQsIGRldGVjdCBhbmQgd2FybiBpZiBwbWVtIGRhdGEg
aXMgaW4gcG1lbSBhbmQgd2FudGVkLA0KPiAgICAgYW5kIGR1bXAgdGFyZ2V0IGlzIHRoZSBzYW1l
IHBtZW0uDQo+IA0KDQpUaGUgJ2dsdWUgc2NyaXB0JyBtZWFucyB0aGUgc2NpcnB0IGxpa2UgJy91
c3IvYmluL2tkdW1wLnNoJyBpbiAybmQga2VybmVsPyBUaGF0IHdvdWxkIGJlIGFuIG9wdGlvbiwN
ClNoYWxsIHdlIGFib3J0IHRoaXMgZHVtcCBpZiAicG1lbSBkYXRhIGlzIGluIHBtZW0gYW5kIHdh
bnRlZCwgYW5kIGR1bXAgdGFyZ2V0IGlzIHRoZSBzYW1lIHBtZW0iID8NCg0KDQo+IERvZXMgdGhp
cyB3b3JrIGZvciB5b3U/DQo+IA0KPiBOb3Qgc3VyZSBpZiBhYm92ZSBpdGVtcyBhcmUgYWxsIGRv
LWFibGUuIEFzIGZvciBwYXJraW5nIHBtZW0gZGV2aWNlDQo+IHRpbGwgaW4ga2R1bXAga2VybmVs
LCBJIGJlbGlldmUgaW50ZWwgcG1lbSBleHBlcnQga25vdyBob3cgdG8gYWNoaWV2ZQ0KPiB0aGF0
LiBJZiB0aGVyZSdzIG5vIHdheSB0byBwYXJrIHBtZW0gZHVyaW5nIGtkdW1wIGp1bXBpbmcsIGNh
c2UgRCkgaXMNCj4gZGF5ZHJlYW0uDQoNCldoYXQncyAia2R1bXAganVtcGluZyIgdGltaW5nIGhl
cmUgPw0KQS4gMXN0IGtlcm5lbCBjcmFzaGVkIGFuZCBqdW1waW5nIHRvIDJuZCBrZXJuZWwgb3IN
CkIuIDJuZC9rZHVtcCBrZXJuZWwgZG8gdGhlIGR1bXAgb3BlcmF0aW9uLg0KDQpJbiBteSB1bmRl
cnN0YW5kaW5nLCBkdW1waW5nIGFwcGxpY2F0aW9uKG1ha2VkdW1wZmlsZSkgaW4ga2R1bXAga2Vy
bmVsIHdpbGwgZG8gdGhlIGR1bXAgb3BlcmF0aW9uDQphZnRlciBtb2R1bGVzIGxvYWRlZC4gRG9l
cyAicGFya2luZyBwbWVtIiBtZWFuIHRvIHBvc3Rwb25lIHBtZW0gbW9kdWxlcyBsb2FkaW5nIHVu
dGlsIGR1bXANCm9wZXJhdGlvbiBmaW5pc2hlZCA/IGlmIHNvLCBpIHRoaW5rIGl0IGhhcyB0aGUg
c2FtZSBlZmZlY3Qgd2l0aCBkaXNhYmxpbmcgcG1lbSBkZXZpY2UgaW4ga2R1bXAga2VybmVsLg0K
DQoNClRoYW5rcw0KWmhpamlhbg0KDQo+IA0KPiBUaGFua3MNCj4gQmFvcXVhbg0KPiA=
