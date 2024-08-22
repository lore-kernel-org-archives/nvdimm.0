Received: from esa3.fujitsucc.c3s2.iphmx.com (esa3.fujitsucc.c3s2.iphmx.com [68.232.151.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E9517CA0A
	for <nvdimm@lists.linux.dev>; Thu, 22 Aug 2024 08:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.151.212
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724315314; cv=fail; b=UluZShTJV43RcUWgR8HmWjMMwusK/AYup6VVJUw7MrU0lrgVPSTMFnzxAH2Sg33UZ78mIhmI4tBINXYw4Bsk+JRd5beScE5ftfBmtORo2UlXBt/6l/Gydf6aubpONnpooL7EupOrq8VBNkQS9xSl2Netul2Uvd9ke/UjqDg330c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724315314; c=relaxed/simple;
	bh=0mpLftqUbI39FU2Jblvl2FZ9fZg3EkFga5hIZ+l+Lek=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nYRV7MptG1l36x3s66xMfQjph5eGsHBSD/qzqXfGMJbHyJZ+CxeLb8234huGZc/BIpSmCVKABiFC1vyuJgedBO1xO/KhGIxhgu0YFioU/26IBZvd6s1UFK6N2LHWqlB24dBJsvAr9+qVFBamH2KLqzblVoeaWfk2Ox7hyij1F1U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=gFreHpD+; arc=fail smtp.client-ip=68.232.151.212
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="gFreHpD+"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1724315310; x=1755851310;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=0mpLftqUbI39FU2Jblvl2FZ9fZg3EkFga5hIZ+l+Lek=;
  b=gFreHpD+fchhV6SfKCK8bXg9d1lbcYcCA5fmYkWfNroeIa1CyjckvIo9
   MYpD93fv8xn2uo3v0KoSpLAYlFRRBKbavKSwWG3g9AoNfOnTvY5q2uKz+
   0bX0zplgmHDWBPJ/Cnb5rhPus0dSfOrZqTvXWPpDja9+a7lu6qszD1f4e
   IPP4AuEF8+scNusJI+PRB1GVX1nI8ODkjH/Rywgbid3ghp8arVWyVTwdl
   OAkCr/NyuDChfJrhIzdd15cPMMWf+iejrC+Sg7vaBTaeccl5PvhZZCXtD
   zEKsQZz8jWGrl6D0ReNOwuECnttMQ1x4h0d44Q6r0xPlKu1kHy3iOb1Pe
   w==;
X-CSE-ConnectionGUID: 2wJq5Oe1Qde8WP9T8vVjrA==
X-CSE-MsgGUID: XjZvYZ9mTJqikSZwIudl1Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11168"; a="39886589"
X-IronPort-AV: E=Sophos;i="6.10,157,1719846000"; 
   d="scan'208";a="39886589"
Received: from mail-japaneastazlp17011026.outbound.protection.outlook.com (HELO TYVP286CU001.outbound.protection.outlook.com) ([40.93.73.26])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2024 17:28:20 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ym1+0+OFIypxAAI3zCB0vBUnnKm/lr6fHZnRVpAcdunSqk/TonrOhSl4H5UAYbl6J0/mFFBKXMiLB5QWDTpQgBmCx+NU67AZd0kSCI5Mk70VpKs9FYRWFM7shdIe9LcCigE9/4PshZnLzabHnf67jnQbbEGOwnsruPyGEszWWyKDDlHwgVhjHIgzbTxB/vLMhjlBylt0ULsRpy2V+XSCyxRu4RF1RIC2ErW+L/geMOIX4aV7AqolWDiNXRBpSUhJmCvcLnOUkwbJFZHf9vemj39ctm9+gXqj46HCjNnekyZ/sYjptJj0SlCbTjYuJq8lvRp8yosFH5AmndPlGzGE0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0mpLftqUbI39FU2Jblvl2FZ9fZg3EkFga5hIZ+l+Lek=;
 b=yDi8BwiSMg79MvghX4RVQmlxZkbFYpjTrRPVcFt+tP+0YRkQdgPj9/gjs+JZzs1E2itcHgT06qz4iPAM48B4UPWCexAfUFQ/css96f2haZSOO5Wu+gX/mQsc0XA6NIku1pGL/cPhv009diJKyulDAViEMGNNd5o1oI5LyL6BL2oAMN1ZSE7iLRGL4J5o+ec/jaNgYQLeMVwe9TrD5lFdBrTDtEhlRKhtL9ip62NE07RdrQZN2DLY4vf+P3Q30NIhqd9AvGt+isti81F9l5w64WDlpUyYAYCW3xmOAN5H2e0rA5pWN59OU4g4N1XANMyNcE8xqdHRmJzXpaggpHhhvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from TY1PR01MB1562.jpnprd01.prod.outlook.com (2603:1096:403:6::12)
 by OSRPR01MB12002.jpnprd01.prod.outlook.com (2603:1096:604:22d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.19; Thu, 22 Aug
 2024 08:28:17 +0000
Received: from TY1PR01MB1562.jpnprd01.prod.outlook.com
 ([fe80::d9ba:425a:7044:6377]) by TY1PR01MB1562.jpnprd01.prod.outlook.com
 ([fe80::d9ba:425a:7044:6377%3]) with mapi id 15.20.7897.014; Thu, 22 Aug 2024
 08:28:17 +0000
From: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>
To: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, Alison Schofield
	<alison.schofield@intel.com>
CC: Fan Ni <fan.ni@samsung.com>, Vishal Verma <vishal.l.verma@intel.com>, Dave
 Jiang <dave.jiang@intel.com>
Subject: Re: [ndctl PATCH v3 1/2] daxctl: Fail create-device if extra
 parameters are present
Thread-Topic: [ndctl PATCH v3 1/2] daxctl: Fail create-device if extra
 parameters are present
Thread-Index: AQHat8TisSK/ysMGs0a1vJ4hvay6a7IzauwA
Date: Thu, 22 Aug 2024 08:28:17 +0000
Message-ID: <44be9d98-1e34-469e-b76c-5ed65e4e49b0@fujitsu.com>
References: <20240606035149.1030610-1-lizhijian@fujitsu.com>
In-Reply-To: <20240606035149.1030610-1-lizhijian@fujitsu.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY1PR01MB1562:EE_|OSRPR01MB12002:EE_
x-ms-office365-filtering-correlation-id: 3429466d-f890-482f-553f-08dcc2845faa
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700018|1580799027;
x-microsoft-antispam-message-info:
 =?utf-8?B?WGY0cmp5OG5PditHaUEzSEVIbThnVC9pQlQwaVdhOHg0K1FMKzhXcVdhTmxO?=
 =?utf-8?B?SWg5M204eTdWSEEzakhDc1d0a2k2OEp1QitwWFZQY2d3emF2Qjduek9Vb2Jv?=
 =?utf-8?B?NXZRSGRWRFZXMjlBYU1hbnMrMm5nekRuMEsyUkZQTzFBR0l0V0kxeDNBaTRO?=
 =?utf-8?B?dUVXMTNhNjhoMWZrMVFqWTJtK2swK3dRUDhiNUNJZVp1L0R3QmFQSmEvbkIv?=
 =?utf-8?B?cldhYi9OWFNjbXl0ODZpTE9qb21YVCtGS3dSR09ncUxKRmJsUmdJMzJab3gx?=
 =?utf-8?B?S0o2Y3daNGNjZ3pCZ1UvYTNJNWJYNHFzN1FnT2NTWlpJNm9COFk0ZUhZM3d5?=
 =?utf-8?B?ZlFCaVdIbE8wM3FMa2VqcVVFc2c2MEtteTV4eUFEV2JRRXAyaStQN2lzR0Rl?=
 =?utf-8?B?dDBEMzhHYzhRMG1XWHh1bjBMU29XOGJmYXdRUHRTZlpqYWdwa3lRdGtEZEI0?=
 =?utf-8?B?N0hBRjgrNkZ0bEVtSXRIQkFUeFRJVTN6ZCtxdDZIdXc4SDNNN2FYTDFtcG9K?=
 =?utf-8?B?bWduZk1NTzE2Q2NPVE1tczc3ekVUSjVkQVl5MWZyKzU3ZXdpNjJHOXAzSmVI?=
 =?utf-8?B?UDRGd1NGTzJNUStha3ZBODRwa05KOTc4emlKQTRwTHRLQVhJaEt5UGU4dHhR?=
 =?utf-8?B?NzVtQ3F0UW9vdWNnYkNRd0ZENHZ2L1lIWHZaTU0zb05IdU5pS0p0WkFHd1dG?=
 =?utf-8?B?Zlc3YlFHUnZhYU9NMkVNb05wR2FNK3ViMzdMcWRXSTZ5OTRVSVhTcnJ4MEpr?=
 =?utf-8?B?WWphQWlGQ1ZXZ0o2b0MrSnVrb2hkR1N4YTVxOUJWSmgrMnI0N01RYllZRzFo?=
 =?utf-8?B?Skt1MmlWSGJDZmtob3dRRnRJS1dkZWxLOEkwQzJ3WW1ySWMrUzhVY0hBUHd1?=
 =?utf-8?B?bGdsWUFMN3lUZE1Zdkdmdmh5ZWZQSGVyMmF3RVpWUlFSSFRQL0I4TlZKZnVP?=
 =?utf-8?B?Y09QekdtUS9kQjBiYk15cWQ0NkkzSkdyKyt1MnlNT3NWakd2SngzemxrVWhN?=
 =?utf-8?B?aWxZZE1HdWdnMUhmVkVBMW9wb1F2Ui92S2xIeUV3YlFmTXVJNFRoemdtOFNG?=
 =?utf-8?B?VkNSVmZhNGRteDAvVlRjTElESXdza0ttend5MG1CWGlnaitwemJRMjdzVmZk?=
 =?utf-8?B?ZHp4MjRqSXRyb094bDU4SS9WOXdRbEl6K3JUL3BLdXVDQkd0cWtxcVhOb2dj?=
 =?utf-8?B?ejZ0anhZWlNDeXpHZHIwb0tCMmdXRjVFVXdWMmtRWkVsYkZCbVcxbjQ3YjZ0?=
 =?utf-8?B?Zkh3b25Xd1Yxc1dWSEswd0VRckxuWDJoRmhzeEd4Q3Y3K1hoQ1E3TnVITmU2?=
 =?utf-8?B?dlRNZ2NVYldueE1pbUhiYWc3V3ZhNitkUmZQN3NhNVJmZjNYbVREZzNoU09V?=
 =?utf-8?B?d3lINHh6VjcwaHZ6TytyWmJXaUppOTU0bWwxeUZFZDBIWUtqWTNVWkVJMWVI?=
 =?utf-8?B?RUlJV1ZlNFFPYkpwRGUvQmF5anBrM1Zuc0hRNzA0VnJIenZVZkU2WDRCVlo2?=
 =?utf-8?B?dkMwZUdQNjJkNmQ2bXhzTXU3WjVGWHRWdy95OThmYms5SE5OVHBQMlBYenhh?=
 =?utf-8?B?VVdDMUhBbktTRmN1b3JsTEY3TllReTR3VmpWMHJ5T1VYSUdHdEVDVUdtQytR?=
 =?utf-8?B?bW1JQ3lybVhGNkhlY0pTVXhEc0F2NjBhd2VhUzg0QmdIWGF2bThSUnBsenhC?=
 =?utf-8?B?MXpnc2VmZkZpRSs4cFhJL09ta05kMjVraEUwRkJ2MWtTM3RyZXJOUkprWEJI?=
 =?utf-8?B?OUZhWnc3bUtFbmRXNk0wYm83NzNwZmZ0b2xnVWc5cXJsV0YyZDZ4NjFCWjN0?=
 =?utf-8?B?WnVpbmRxbjVKT210dW5KTjU4L25waXROWVU0d1VLajlSYVBTUWl5TUpCdWJn?=
 =?utf-8?Q?kqFXNWJVizOpT?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY1PR01MB1562.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018)(1580799027);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Q3ExRDdBOStaam9TdDBrb09ZbmhDS3NobU1oZUlianZvOXZ6cVpqVkJST2du?=
 =?utf-8?B?RzFvY0hTV0l1aThydHZoTkFKV0NXOEFob0pDemd1Slp5bTRBYzBLbjhLYzJV?=
 =?utf-8?B?cm1Qc2RCWlpSem43TkxLL2FBa2ZheHRjZFB6ZEhVSU94U3Fwa3hGSVdzYmVW?=
 =?utf-8?B?MWpZbEx6c01OY3ovdGlMSG1VM1FlTEwyUUtLazBKUEFSYUZscTZibWlaTUxm?=
 =?utf-8?B?SVJUSUQvOXp0Ym5sODRvQyt0WXJpZmFlZ3EzSWRNcnc4NXBPbVhkOFUvSlh5?=
 =?utf-8?B?ZjF2QVB3cHV5cVZrSU1LbTBlNldCeTlSODJyb2JxUFMyRGIzaVhQNUEvK0JW?=
 =?utf-8?B?QVY0NGxDeDN4cFNUMlJpdjJSK004U0k1NDFZS0pHV2ZnZWdsVStOZktScDRn?=
 =?utf-8?B?NU8wNEVoV094dGJVUE54bVlnWDh3QVRwRlJFazZLdFpDME9Wb1Z4aEg4U21k?=
 =?utf-8?B?YTRlZ2g1SkFCT29UNnkrNy9ER2Q2Vm95OXFXVWQ1REJMVzFBSEpkSGpRaUht?=
 =?utf-8?B?eHBRS2dZczNpWGtML0xlYjJoZzJTZmFiSm1DVjB3YWErNW92ZVY3N3NzdEZm?=
 =?utf-8?B?RmhPR09VV1JUUUxPcTJ6WWFUS1JYMzFxblg1bjFhYXVOZlM4VUw2MFphMURt?=
 =?utf-8?B?QkpPUTZ5eHhBa3ZwN0c3cmhlZ1pqYWhEWmx1S1VlUUtsenliUXNaRVBPL3dD?=
 =?utf-8?B?Y3NERFM1dk4zUUhKaXBtZ2M5bUFsa2pPMlpQWHprQUJXUFA3VGJpNE5jN0FH?=
 =?utf-8?B?QjlSQjdMWi8zRzZPSjJILzlVeitKMWs3UFgrV0NYZWZIcUtKczJlOGpsd1No?=
 =?utf-8?B?azRUa1B5R0RIL1VWNWpPeTNweElQR0liQUVYTzZ2UjlzK05RUC9hUnNCSWRI?=
 =?utf-8?B?bno4UmlLa05jOXpYanZMNkhGcWltbVBlajM1c2M4blZjeG83QjRDQU1JeSts?=
 =?utf-8?B?dUZSYTdvQkNwL3RhZlNSS0J1cU5ZajZFWVRONGM1dFhSaUdMUWpGajhsVy9m?=
 =?utf-8?B?bzZaMHdFTGhsWktFQml0NlIvSHNqTmlLMHdzaTFsS3RCSEh1UXQwNnVRTXYx?=
 =?utf-8?B?MzVKc09vclFmM3dDS1lycmZaeEpCdnRWREU5RnhTUXhHZmhMOFJpUEdyaC9s?=
 =?utf-8?B?YTcwZk93c2tXMXNzTW1nTThNWktUTTgzYjBQR29tSThLeERFSmVOaEI5SlJB?=
 =?utf-8?B?QVBTUElxeWhXcHNmSkhDWkpXV1RuME0wdnRHQnhNa2U0TDc3cGxsQlloSkpO?=
 =?utf-8?B?V2RTeHpHZlZyZGRubEVHZ0wzd0ptS2YvNXVuRm4wTW02c2ovRjdMUkNqQWt2?=
 =?utf-8?B?V2I2bU9iT05JcFJWb0dHWTN4N3pvSVBkbVZCSTlZYmgyVm0zeDJuNmlNaVAx?=
 =?utf-8?B?SGtxbUdaNm9mY3A5VGxpMUUzSlMwdENUU2o4cS9DUXkyOEw4bitmZkxQNFN4?=
 =?utf-8?B?UGtkL0RUcjhwZ1ZtRlVRZlVwOVNYL1diTC9qRUhkK3IwN0ZLZVJveUxscWxP?=
 =?utf-8?B?RGxRSnVhK1ljcUZpelVKMU83TjB1TGordzFTQlYvT2d1L0I4dmJNRkY1SDYx?=
 =?utf-8?B?N0pGbEs4V2xLZ3VhR2lndEhjNk9yT3lYZ3VZSlVSeVdXemlrczNObFZCNVJT?=
 =?utf-8?B?SkErbUxqTWxPbDBuUFk5d3RtY2QwUnduRmp3bVhTeWI2Unc0RVhuT3JjSmFZ?=
 =?utf-8?B?NGkxdUQ5MktTUlBMa3ArVFpQcVJ3cTVOV3g0OWNLTW56R3ZmdTRQT1AxbVBT?=
 =?utf-8?B?cjVpdUZyNXVzWEk3aUxrYzRNQ2hvbFkybWwxbkhEbDlLams3MGV0ZEdqcVow?=
 =?utf-8?B?QzVKa21nbmkvQzIyZWVtOUZpeUh4MHRSZ2pVa1Vyb29ORmlyRVgzOUJKUHFh?=
 =?utf-8?B?Wk44Znp0R3JjVlR1ZUlLY1cxcXhZdFlZbkVDMzJvNm1rc2FPdEhac3lhRmFL?=
 =?utf-8?B?MWJYQ0NlelZ4SHNCQzZFbTNBVC9mNXBZM0EzNktLdk9CcFVOdndURUJKcnRh?=
 =?utf-8?B?ejJLQ2toeS9qY25MZEFyRURuT0hlVkhBVVNzbHE1QVJDNDlnNUZlYWdwUzZP?=
 =?utf-8?B?T0pQZkg0cEhtMlhRVXhraVBYTTk1NThMeWJqMXpqUmpjTVl1VU5BbXZ2U29i?=
 =?utf-8?B?dG1qK0g5ZFFHNXYyU2hGeGRodXZzTEwwUmdLdUE4Sy9yaUZOVzRmV1NWS0FL?=
 =?utf-8?B?dVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3835EA6F812D814EBAC786643B337B89@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	EoJsJYfbiJDZE5R+zcxM0PoJkjevwqnEA9NOWSNWjc/7M7Bqsfj1vXp92xnVI14t4rS8FelJzakorZyIhhP9jz1bNa2zeWUOsypO1QxWLpdVIGaLQZGNtLtj9KLNCDxVv+RYh0f7+v6h2Ynbs0hjHfmYTUjGcWbnonx/gDxR6awMReENL4H20CmFFBbyw++Xz5Z7oKbCWuLsxj/Bu4WuTkcOdAdJ9FVMcCsRGdNje8l0px3DXfP3zciStrcR2A66WSBfscxZBnbj9vpbW87mzzs+eZPa53JPSRFdKxZVSPJzNsRosuOuLTA5+GZoboO+zQrat4DDk15xW9IjTxNY0i104kMlCeHcp/gTOkXzytAuAlgGUX2y9NNucl2UXh+r0OjtA/WbQWDmetK86BtcFZzkd9X6gNSKlb+up9cZ4r2vK3/9BH0PZot+8ndddfFaOsspblkorSafozcFX8YR3q243G0s2d/ZV8yf5NlrbuTbDKYuATcl7Y4f5+FHgrPwoZ+Jnddrh5BylfOW0r+6WK6ioZmcBbRTO8TlxQMOZ45DmqLLyy2KDdE/83XubVG0XvNdqxreBgZ05CpEEC/gQ0CtIsV7QWz3boKDLwS82c8OdJWqqB2AKZny+Sm5Vcj3
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY1PR01MB1562.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3429466d-f890-482f-553f-08dcc2845faa
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2024 08:28:17.5988
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dxknWl/Li/WDFdh2UsBCLwNnllhG4WlCsxcm93TVblo8CwsyDGMRNhihfYSyK9Zbpxu1ol9rxiL+4G6zC5GUnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSRPR01MB12002

DQpQaW5nLCBJIHRoaW5rIHRoZXNlIDIgcGF0Y2hlcyBzaG91bGQgYmUgaW5jbHVkZWQgaW50byB2
ODANCg0KDQoNCk9uIDA2LzA2LzIwMjQgMTE6NTEsIExpIFpoaWppYW4gd3JvdGU6DQo+IFByZXZp
b3VzbHksIGFuIGluY29ycmVjdCBpbmRleCgxKSBmb3IgY3JlYXRlLWRldmljZSBpcyBjYXVzaW5n
IHRoZSAxc3QNCj4gZXh0cmEgcGFyYW1ldGVyIHRvIGJlIGlnbm9yZWQsIHdoaWNoIGlzIHdyb25n
LiBGb3IgZXhhbXBsZToNCj4gJCBkYXhjdGwgY3JlYXRlLWRldmljZSByZWdpb24wDQo+IFsNCj4g
ICAgew0KPiAgICAgICJjaGFyZGV2IjoiZGF4MC4xIiwNCj4gICAgICAic2l6ZSI6MjY4NDM1NDU2
LA0KPiAgICAgICJ0YXJnZXRfbm9kZSI6MSwNCj4gICAgICAiYWxpZ24iOjIwOTcxNTIsDQo+ICAg
ICAgIm1vZGUiOiJkZXZkYXgiDQo+ICAgIH0NCj4gXQ0KPiBjcmVhdGVkIDEgZGV2aWNlDQo+IA0K
PiB3aGVyZSBhYm92ZSB1c2VyIHdvdWxkIHdhbnQgdG8gc3BlY2lmeSAnLXIgcmVnaW9uMCcuDQo+
IA0KPiBDaGVjayBleHRyYSBwYXJhbWV0ZXJzIHN0YXJ0aW5nIGZyb20gaW5kZXggMCB0byBlbnN1
cmUgbm8gZXh0cmEgcGFyYW1ldGVycw0KPiBhcmUgc3BlY2lmaWVkIGZvciBjcmVhdGUtZGV2aWNl
Lg0KPiANCj4gQ2M6IEZhbiBOaSA8ZmFuLm5pQHNhbXN1bmcuY29tPg0KPiBTaWduZWQtb2ZmLWJ5
OiBMaSBaaGlqaWFuIDxsaXpoaWppYW5AZnVqaXRzdS5jb20+DQo+IFJldmlld2VkLWJ5OiBWaXNo
YWwgVmVybWEgPHZpc2hhbC5sLnZlcm1hQGludGVsLmNvbT4NCj4gUmV2aWV3ZWQtYnk6IERhdmUg
SmlhbmcgPGRhdmUuamlhbmdAaW50ZWwuY29tPg0KPiAtLS0NCj4gVjM6DQo+ICAgIC0gRml4IGNv
bW1pdCBtZXNzYWdlIGFuZCBtb3ZlIHRoZSAnaScgc2V0dGluZyBuZWFyIHRoZSB1c2FnZSAjIEFs
aXNvbg0KPiAgICAtIGNvbGxlY3QgcmV2aWV3ZWQgdGFncywgbm8gbG9naWNhbCBjaGFuZ2VzLg0K
PiANCj4gVjI6DQo+IFJlbW92ZSB0aGUgZXh0ZXJuYWwgbGlua1swXSBpbiBjYXNlIGl0IGdldCBk
aXNhcHBlYXJlZCBpbiB0aGUgZnV0dXJlLg0KPiBbMF0gaHR0cHM6Ly9naXRodWIuY29tL21va2lu
Zy9tb2tpbmcuZ2l0aHViLmlvL3dpa2kvY3hsJUUyJTgwJTkwdGVzdCVFMiU4MCU5MHRvb2w6LUEt
dG9vbC10by1lYXNlLUNYTC10ZXN0LXdpdGgtUUVNVS1zZXR1cCVFMiU4MCU5MCVFMiU4MCU5MFVz
aW5nLURDRC10ZXN0LWFzLWFuLWV4YW1wbGUjY29udmVydC1kY2QtbWVtb3J5LXRvLXN5c3RlbS1y
YW0NCj4gU2lnbmVkLW9mZi1ieTogTGkgWmhpamlhbiA8bGl6aGlqaWFuQGZ1aml0c3UuY29tPg0K
PiAtLS0NCj4gICBkYXhjdGwvZGV2aWNlLmMgfCA1ICsrKystDQo+ICAgMSBmaWxlIGNoYW5nZWQs
IDQgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RheGN0
bC9kZXZpY2UuYyBiL2RheGN0bC9kZXZpY2UuYw0KPiBpbmRleCA4MzkxMzQzMDE0MDkuLjZlYTkx
ZWI0NTMxNSAxMDA2NDQNCj4gLS0tIGEvZGF4Y3RsL2RldmljZS5jDQo+ICsrKyBiL2RheGN0bC9k
ZXZpY2UuYw0KPiBAQCAtNDAyLDcgKzQwMiwxMCBAQCBzdGF0aWMgY29uc3QgY2hhciAqcGFyc2Vf
ZGV2aWNlX29wdGlvbnMoaW50IGFyZ2MsIGNvbnN0IGNoYXIgKiphcmd2LA0KPiAgIAkJCWFjdGlv
bl9zdHJpbmcpOw0KPiAgIAkJcmMgPSAtRUlOVkFMOw0KPiAgIAl9DQo+IC0JZm9yIChpID0gMTsg
aSA8IGFyZ2M7IGkrKykgew0KPiArDQo+ICsJLyogQUNUSU9OX0NSRUFURSBleHBlY3RzIDAgcGFy
YW1ldGVycyAqLw0KPiArCWkgPSBhY3Rpb24gPT0gQUNUSU9OX0NSRUFURSA/IDAgOiAxOw0KPiAr
CWZvciAoOyBpIDwgYXJnYzsgaSsrKSB7DQo+ICAgCQlmcHJpbnRmKHN0ZGVyciwgInVua25vd24g
ZXh0cmEgcGFyYW1ldGVyIFwiJXNcIlxuIiwgYXJndltpXSk7DQo+ICAgCQlyYyA9IC1FSU5WQUw7
DQo+ICAgCX0=
