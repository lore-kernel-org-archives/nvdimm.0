Received: from esa16.fujitsucc.c3s2.iphmx.com (esa16.fujitsucc.c3s2.iphmx.com [216.71.158.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C62F8479
	for <nvdimm@lists.linux.dev>; Mon, 29 Jul 2024 02:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.158.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722220459; cv=fail; b=qKTsu1xdzqbugfD6CSYfTd29ijPwLxTMnQ5wriAGHnzF7/+sWYn3g68Ms82bv8CX6kENd5nsbKo6q+cF3hE4vDA6JzOzOcI0oVCU/Vt3IpTxXACvoRTpOtdrfoCl+U5ii5Ba1FNWY6b/RHWfoimMGHbp7A3fIevg9UPdfQ/1204=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722220459; c=relaxed/simple;
	bh=O/jQ5Ye22liGNq4vLOR/9VicjP+y6i8FgvYS4f3WQdY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tozc+QQNZlDVQOa16i45AUJR1jSNLaIVyO2/oTThqseXu4Q5+1FTqZx1hNw5Qlyw9ToU1wqIq3LCM1lFYF0irTXscap4SyOloMitDHGsKOszF4Na4hwxPmjxm6LEfOQHUf7zgWQbO+tkyWbGoO6+CKcrclY1jtqRZJGFOxi2/Ek=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=O09EfFQU; arc=fail smtp.client-ip=216.71.158.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="O09EfFQU"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1722220456; x=1753756456;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=O/jQ5Ye22liGNq4vLOR/9VicjP+y6i8FgvYS4f3WQdY=;
  b=O09EfFQUNNUq2MrT92vAjXfQpXjPF8j6r06KF4nhKNfRk0mbTc6rAhY3
   9NfthtGPZuRW8kZVH6rnAFo4M8XYNg0xgIDFiobIMTJZyukTkbSbUBB93
   xtrqx+ZE60DLK8ENsAy6wohuAjS4nk+F4c7qrcw58d+bqXPhEAXt7GDZv
   R0v0Vzt9WCNP9K91u3ANczTR/vWiN3PjWSyFOPvlpRGr4xyrRXCHGQzun
   1z45X+yClMNJ8yM66JMtLPXIsKFsP6nWzL4diKTkDt2M9Ij4ulyuZTbSW
   8LRpsgFTt6NoYeEOQWE846+kHIc77Qmv7ELaUu2vKT8T6XPjluBNqi+pP
   g==;
X-IronPort-AV: E=McAfee;i="6700,10204,11147"; a="126438903"
X-IronPort-AV: E=Sophos;i="6.09,245,1716217200"; 
   d="scan'208";a="126438903"
Received: from mail-japaneastazlp17011024.outbound.protection.outlook.com (HELO TYVP286CU001.outbound.protection.outlook.com) ([40.93.73.24])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2024 11:33:03 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CQCoOkXBVCUqVAqn6nrPW10a8OqSiIfKY1Gs3BgQ9giwxiOrOrZ8N2+q8H299+pj3hbim+sub93Le1jX8+6zbWFy9cqwzqcoJbKPXcBH4FA82qID1wqc87qXDOTSs617A4ZUtsBsWEyq9GMcQJsK62tYLSK6E6zV8W2w01kPNHfh2Hc3QX7LXLYP19Qy7HCr3c8EqVgLMzph3CiBJdP+hzldtWdii+/HTmEw3tIsJ1FvAsmnC6Z2FZXbCA38DEFNHUaDUpN55M+ZpXH577hJZ6mCBCmedFP5+jLsN4BfH4Am/PfXn8JqnSE5aZgbT5pTUn6S6K6VjqY6J39LmBujwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O/jQ5Ye22liGNq4vLOR/9VicjP+y6i8FgvYS4f3WQdY=;
 b=OgtASAHoG0TgRrXzvId1k2wuXVQDcbcuYF6MYuI4eUlDgcq4QrCf+f//uXpKB7zyvJy9IByR5oTcVnfwAemq6xZmElUx1DDlp5DAc+U/oRn4Vp1wtESgsLDz9RQ/ZAVznsxoki/zFAfz9ns/iI5qTA+fy71krDRPejIqgNWTfZ+dPjMsP3356/FXwoIy1CBCLCiYZGfZeNYy6zq4p4nBSohzTjLilwbvHVhxEkNEt8qR/D3UlLAOE6UCXkYkn/aRNr+9TSb8I/JxIWudSlWwxsFUSdFPuznlm4qjc/jwiZWlf4chP6vxw4WlgDxcYaoND1u/lct8li87/iNAnvScgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from TY1PR01MB1562.jpnprd01.prod.outlook.com (2603:1096:403:6::12)
 by TYCPR01MB11990.jpnprd01.prod.outlook.com (2603:1096:400:37e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.27; Mon, 29 Jul
 2024 02:33:00 +0000
Received: from TY1PR01MB1562.jpnprd01.prod.outlook.com
 ([fe80::d9ba:425a:7044:6377]) by TY1PR01MB1562.jpnprd01.prod.outlook.com
 ([fe80::d9ba:425a:7044:6377%6]) with mapi id 15.20.7807.026; Mon, 29 Jul 2024
 02:33:00 +0000
From: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>
To: Ira Weiny <ira.weiny@intel.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
CC: "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
	"vishal.l.verma@intel.com" <vishal.l.verma@intel.com>, "dave.jiang@intel.com"
	<dave.jiang@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] nvdimm: Fix devs leaks in scan_labels()
Thread-Topic: [PATCH v2 1/2] nvdimm: Fix devs leaks in scan_labels()
Thread-Index: AQHa2X8zwa9xxtG/iUCzPF4J7ymSb7IJDwoAgAP9NoA=
Date: Mon, 29 Jul 2024 02:32:59 +0000
Message-ID: <7ccc9770-b7e0-4657-a4f6-7c49c3e20866@fujitsu.com>
References: <20240719015836.1060677-1-lizhijian@fujitsu.com>
 <66a3a6b2292cc_1bcf5d29459@iweiny-mobl.notmuch>
In-Reply-To: <66a3a6b2292cc_1bcf5d29459@iweiny-mobl.notmuch>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY1PR01MB1562:EE_|TYCPR01MB11990:EE_
x-ms-office365-filtering-correlation-id: 437cb7d7-dc62-4cb7-bf61-08dcaf76c366
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|38070700018|1580799027;
x-microsoft-antispam-message-info:
 =?utf-8?B?azdDdGVkalo4V0NsSW5jRjJXQytIK0NJSHdSc2tDaGkvTXhPQ1FsRFUzVVFs?=
 =?utf-8?B?ZmUzNXQ2QllJSkRnR0Nsb3Yvd3ZJdFNUNFBoYm5URWMvd1lZcUpod3dkRENJ?=
 =?utf-8?B?M3ZaSW1YYnJNZUhhRjhRblJ5RjZkUGttTk80aGQxLzAzWlVzeUdWZUxsMTA1?=
 =?utf-8?B?U2tUVk9PZksvZlVMMm4yYVVSc1hUMVZkYkM1L3ZsZDEyb2xWMm9IWElVYlpJ?=
 =?utf-8?B?ODBOcUZUYTBOODBDM2RMUlQvUVBiNnYzOEZMZjJaTHFsKzBGT1RaRUVCRDlD?=
 =?utf-8?B?cmJPUXNjOURqczgvQzRBZER5a3p5RjZkWGgrU2h5L3dwaExRekVCYjFTYVJL?=
 =?utf-8?B?YWl0aDBjeU83QXpVbUlUMjNVcTJaNzBwUXk0UHdNZUErSStWL1d4NDIyTzU5?=
 =?utf-8?B?UGN4N0s0ME5CVWtWR09PSHdsMGg0M2wzWjRQOGhQUDM1b2RDRi9TaHl4ZFR2?=
 =?utf-8?B?b3ZzV0VicGNtdHVlaERqVzZsWGx1NEk5Vy9ObEpEZEhjNjUxYjFBNXBCekhI?=
 =?utf-8?B?WjhWZlUwYW9OMFVVVGZRTkcyejBNejM2YmJRcWYrcisvWXdqNUN2MElpNFpN?=
 =?utf-8?B?ZUhucmxUcm12dXAwcUt6SnpvRnVabENydEhaeElybDdLdHMySkdDaUtJOU9z?=
 =?utf-8?B?blpDdzNpWFB5UDZOZ1NselBIdVVZSWhPQWEvUGk3U1JCWGluVmZGamQvNmxk?=
 =?utf-8?B?N3dteTdWbmdTZ3J0dkNTd0cwNVQyUUkyd2IzbW5aZ1NoTFhrNVFGVDBTSzdP?=
 =?utf-8?B?TzdLTGthd2pkUXFWdStwOHpIS0Q3OE9oVWVXL3pFWW5mQ3FFU2Q2Q21CV3VX?=
 =?utf-8?B?b3pQaUNQWm9MYWxTT0xMWEgwakpxY09Ld0tWUFROTU1sTXl1Um5jbWlNZ2V1?=
 =?utf-8?B?WEg4eWM2a2IyeGFQZGdtR0NaeFQ3ZVhYRjB4L1JIZWp6ZnFVR09QZloyS1Zm?=
 =?utf-8?B?TkNQbU9lc2ZKbURqMHJUcG1kY0F4eFpYWTgvb3EvMEIxMW1vY2N4b2FkNGls?=
 =?utf-8?B?UDNIL3FkcjU4K3M5ZmVnUlEyUlVBTTZxUjhHNHNLUUQ4MUp5Qng2Q3BmVC9v?=
 =?utf-8?B?ZHBkR25RVHVlMThpcVh1ZVlTeXB4M1VNWEtQM0VQM21PSzFkcDg4c1l5WlJZ?=
 =?utf-8?B?ZWVPQ0tUL1Y5YTdtQjJnL1prTGMwZnZ6VUx4UDNRRHFCNk00S3hYMjdkQTYx?=
 =?utf-8?B?bFU4VVlWWGlHZWlzY1V2eU91YXNDZUloSkpwS084Vmw4cSszK0paSU42R3Zt?=
 =?utf-8?B?U043aEtPcndmaXBZRkI4TDZGQ0VDbFVYc3Qvb2VQYUYxeXc1bS8wTndhTHFr?=
 =?utf-8?B?R28xTERVWk5FUk1sL0xHcEpXZC9uaG9tejlZRkJ3YVhXaWdIbDVjaDBST0Zy?=
 =?utf-8?B?NzFUZGZOZmVaN1l4b1M2K0FodEcvRnE4OHQ5a0RMSTRESTBYREJxeFliM0lO?=
 =?utf-8?B?QmQ0L2JCL3ZQdmVLSW5rTEErS0JlMDFHUXVFVlNWbnN3OGlJODY5ZXJQQ0ZS?=
 =?utf-8?B?Nk1takZteGIrOTRjT0V5RWZJdGR2UENvcm9FUmxQMHorYVM0a2tXeXdLUTc3?=
 =?utf-8?B?VnhYbmlESDcrblBSbE4yY2VVSkV6aHk3UWk5REdFaTUybTVUcHlHWjFEajJU?=
 =?utf-8?B?ZHZXVndjWXlVeTRMbmJTLzdlL1lWbmM0TnA1emxDZktiNjBBQmxpeDJVT3Vv?=
 =?utf-8?B?cTd0K1NCaGQ4U3BSUFdIV0hzd2o3dFlFTDBPSXdidFNrRlE2MWpZVUVBK2Nl?=
 =?utf-8?B?cWJnVzVXcFY0VHBHUk9USTFKdUVacXhMUXl4dGJISWlqM3RLNFFiOTJxN3M4?=
 =?utf-8?B?SFQvNmQ5SG10elB0SDdnSEtVQjIrTjlqd2poRFhHS1RKbEc5TXlVRyttdThm?=
 =?utf-8?B?ejRvVmJPUklSWHR1RVVHa3dVelBWMHE5eXJ0Q05UbG5PbnFHdnRvY0RYaWl2?=
 =?utf-8?Q?hesQfta226I=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY1PR01MB1562.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018)(1580799027);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?YkFhVVB0OFd4aFFpM1U1SnF6NjY2cTg3WHhabzJRbG8wTjJiNExJYU9TLzZQ?=
 =?utf-8?B?MFpYZXZCdjFqVFRRK2NXMld5cmsxbGFqRjdtQlpwbTh2N0t2RGd5TTJhbDN4?=
 =?utf-8?B?RXpUVkFweGNjQVBCakVnOG1SQnJUM29qOHV0WEF5dDBDeTNlT2x4SlkwdjM2?=
 =?utf-8?B?QmRtNy9pRmMxdk4zRHlpZXh1elhOVkp1TFYvVFdhN2hIR2ZCNlZMdzYvWWp1?=
 =?utf-8?B?YktLYXpFeU1Mak9KaXJQcWNhcFBvd1lGSDc1K1F2bTl4ZnJCWWFJWGhwZm85?=
 =?utf-8?B?Smc0ejZaZS9OVWRCYzgyZ0FlcWNoaU9qcEVBWWk2U3B6MWRieU1KejZ3SkFu?=
 =?utf-8?B?UGxLc2h5eTMxV0xMVFJScE5JUEtsZVNBc3RWSldIcUlTUFR4S044bm1lVk9B?=
 =?utf-8?B?Mmh3WlNuZElReDBxbUJ5R25KY1AyTGx0Yk9nMnMvZFh4RXN4T2hpOVJTSWpK?=
 =?utf-8?B?MGg4K1V3YXFtd0xiMUZhUTJySStSVWVVRGNVaFpWQ2Y2NHdIaG0za0lzU0dB?=
 =?utf-8?B?MlIrdzhjdHlrWUsyYiszSUZZQkp5NzhQMTU2cE4rNENaNU56aHNKdmZjZjdX?=
 =?utf-8?B?QjJaT3VNS3p4bWR5Y05qNTZSME4zZURjaG9HWlQ3ZEtRM09BQkgwQ3lrR0J3?=
 =?utf-8?B?bldtMzdodTdSaWgvb1Fza0hXZWdpbmtiYlc3ODM3TW4rMndrZnliOUtlUUox?=
 =?utf-8?B?bHRNbjYzaVBFdGJSY1hnemNQaW1seDBpRHZzYWJNNzAxTmVwTFByQUVVR0o3?=
 =?utf-8?B?UmNiTU5Rak9wZkdCN3laTkNCTmVrcXVGMVBBNFNnNGNKeWtaeVJ4aDNZL21n?=
 =?utf-8?B?NWU5RENtVzgzZTRVMDAySE40WE94MXFYODJJSTlHL1c5MVMrSHRIZm9HYUl5?=
 =?utf-8?B?d3VuSVJMMlRLSHZFcVdNY25RUTU0OXV2TDRORkM4aVpvSjA1SEZ0T01BbHVS?=
 =?utf-8?B?RFovZExaOUY5YjVjRzFoREN6cTl2TjZ0aHRBS1RHR3NES3pWc2lheWlSN3dy?=
 =?utf-8?B?aWsxNmJZd205MitWck9oUGFrendjYVUwbVBFVXZqTktBWHBaL1hyWEcwTFNp?=
 =?utf-8?B?aFJ5bXBYVUNQcGZkbzEySVJRWDhwZFpZUkgwdTF2VHpCZDZTa2hXSHZvdW5J?=
 =?utf-8?B?dXV0WUtsbWR4U3BhdzVKMUtSMUYxSVMrT1NlSTVpb21ZR1JlMUJxZm43SGJk?=
 =?utf-8?B?SVBQMWhpY25CdkgyeWtTUHlVWDVsOEtzN3BpQUFHUFdkbUVSZ2luUVhPcjdE?=
 =?utf-8?B?aFhZdnBBWTJFb1l2TWd0NzBlSDE3cjZpaytQVVRqaVFRbG1XYTgzeEF6LytN?=
 =?utf-8?B?THE5R3BBZ1Z0VllUOTFnMkF3SCs0UUlCM05XOEIyRnlBRGRiWVdtYkg1SnNp?=
 =?utf-8?B?MUc4bXgvdmNoMVYwZHRzRVhMNTlMUW1xSC9qZ0diR1ZFQ3hGaUM0VEpkT05G?=
 =?utf-8?B?WTRrOFZMeUZxVk55TjRzSTcxMG9MN2NmbG9QaVFTcHpEWWcvdHN0eXprN0Nr?=
 =?utf-8?B?cE9KKzcrRWswRzV4cS9nRDJNRm8zZXdOSTZtc3Y2VGdpamVlRXdtYnhkdUhy?=
 =?utf-8?B?VjBrWlJKQWtveUxyZ2hqTSt0ZkRadXBCTzNLbDh3YVAza3N0cEJieDczMDBz?=
 =?utf-8?B?MU9XUmxrOFEwV0E5TjJiK3BuaUplaDJNRC9QRGpHaE9iNkQ5MVk4cVh1RDNS?=
 =?utf-8?B?WGZrejE1RzNGOTYrNmp0VzZ4RDBFSHBJa01SSGw0d1FLSnRZcGdaa3FNOXhi?=
 =?utf-8?B?Lzk5NVVGQm0vc3FIK01ZK2t3WVVKNFJhaGFYMXFWSlhrSmdRbUZOTE1yalBw?=
 =?utf-8?B?b1V0RklLeTBVYWl0Rm9sak9kd2VYT05ZeFdOaFE1TkhKWW9IYWkwaUZqdFNh?=
 =?utf-8?B?NGc0SkZ4QkhFRDRlbEpsQ2NodXZXVGF2NTdVVkZnK0Q5VFZJMTRzKzEwcG9F?=
 =?utf-8?B?bmFzNXdMVUpoYzZxamNFend6dTdZaW1hQXpuRlRZbXB1YTYxcFlqRU5SN1Bn?=
 =?utf-8?B?Z3FiL3RNV2VrL2QzTUZyVXNzc0pjK3QrSjlaTFhLWFJ2VzdQUUlrQ3BzSEM4?=
 =?utf-8?B?N0dWL29XOXFMamVPekx1RlpCN1RKS2lwQlV1ZlRWQmxXWUdHcEJDM2d2RHpi?=
 =?utf-8?B?a2thZW5oWExYazJ1NlRsWG5yd1lGUWEwa0prRUpTNDN4Skx2b0RyTFF2cmRJ?=
 =?utf-8?B?a0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9C5C142BD2CF5943BF33E30055BDD2FC@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PGFeeLnH3HY/IjsD7b324VB+ULdv65aw28Kt5zMDD7zLKZwmoRP/kRql0g7mYmMUZrOH+E1ygdtV8JTu9csiS91zIguR7nFDV5KApzldAmgEAsBed9p4HLDebUcFE8q9tn9Id1XGobAvrJ7R8Y5ooEvHYLq3k8p6mIV3gk8aRJSwILOZ6zTRt2vzQd3i2j3jL1rfNlrSvBFWRnr9GeYUHY2Tt4GtczHtUsVm930xnMY9psurpQIzEiqibAzoOgjrTnXnFaAbMql9QzcQSPBDd45gyAIeeZqn1j6lFmft8I7GG8LK0ESzr1WgXsXGc1acK45ORcb1YhMxxsRL7n0pI5vTIEA5znYdJisk5I0K70Y3XeKqeDAbANC9UUaEVv4PZxa+nL9nJFav6vrywL+/0pLkTLDlcwZ9kJpVZxylJNSBuIsOAYeaShTGnD/CfLZSysglO3SRqewjj+PifXyDPG0tWL+qoL1EJunwjfnQeJnfCbWXWp6vsfnGoS11TTt1Q7kObfGr9ur/UyZM5pMQ0/eTN+rNxDlZlodR6lVzLd+u4RKwo/CsnrNMdKif2D0zbWEvY1Hidf3Xsw63pdS8kRpF6uozBlH6o60dlgqRl6tZGPf2qhu02NMatjoJMU/6
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY1PR01MB1562.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 437cb7d7-dc62-4cb7-bf61-08dcaf76c366
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2024 02:32:59.8431
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XYQGsWn+ceya526LJIwFNM77wQfC9esJSfY+7dBDSK0Az3NZUA5qLcoaZXLSar7sJjxVeJQby6r6Virv2UXI/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB11990

DQoNCk9uIDI2LzA3LzIwMjQgMjE6MzcsIElyYSBXZWlueSB3cm90ZToNCj4gTGkgWmhpamlhbiB3
cm90ZToNCj4+IFRoZSBsZWFrYWdlIHdvdWxkIGhhcHBlbmQgd2hlbiBjcmVhdGVfbmFtZXNwYWNl
X3BtZW0oKSBtZWV0cyBhbiBpbnZhbGlkDQo+PiBsYWJlbCB3aGljaCBnZXRzIGZhaWx1cmUgaW4g
dmFsaWRhdGluZyBpc2V0Y29va2llLg0KPj4NCj4+IFRyeSB0byByZXN1c2UgdGhlIGRldnMgdGhh
dCBtYXkgaGF2ZSBhbHJlYWR5IGJlZW4gYWxsb2NhdGVkIHdpdGggc2l6ZQ0KPj4gKDIgKiBzaXpl
b2YoZGV2KSkgcHJldmlvdXNseS4NCj4+DQo+PiBBIGttZW1sZWFrIHJlcG9ydHM6DQo+PiB1bnJl
ZmVyZW5jZWQgb2JqZWN0IDB4ZmZmZjg4ODAwZGRhMTk4MCAoc2l6ZSAxNik6DQo+PiAgICBjb21t
ICJrd29ya2VyL3UxMDo1IiwgcGlkIDY5LCBqaWZmaWVzIDQyOTQ2NzE3ODENCj4+ICAgIGhleCBk
dW1wIChmaXJzdCAxNiBieXRlcyk6DQo+PiAgICAgIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAw
IDAwIDAwIDAwIDAwIDAwIDAwIDAwICAuLi4uLi4uLi4uLi4uLi4uDQo+PiAgICBiYWNrdHJhY2Ug
KGNyYyAwKToNCj4+ICAgICAgWzwwMDAwMDAwMGM1ZGVhNTYwPl0gX19rbWFsbG9jKzB4MzJjLzB4
NDcwDQo+PiAgICAgIFs8MDAwMDAwMDA5ZWQ0M2M4Mz5dIG5kX3JlZ2lvbl9yZWdpc3Rlcl9uYW1l
c3BhY2VzKzB4NmZiLzB4MTEyMCBbbGlibnZkaW1tXQ0KPj4gICAgICBbPDAwMDAwMDAwMGUwN2E2
NWM+XSBuZF9yZWdpb25fcHJvYmUrMHhmZS8weDIxMCBbbGlibnZkaW1tXQ0KPj4gICAgICBbPDAw
MDAwMDAwN2I3OWNlNWY+XSBudmRpbW1fYnVzX3Byb2JlKzB4N2EvMHgxZTAgW2xpYm52ZGltbV0N
Cj4+ICAgICAgWzwwMDAwMDAwMGE1ZjNkYTJlPl0gcmVhbGx5X3Byb2JlKzB4YzYvMHgzOTANCj4+
ICAgICAgWzwwMDAwMDAwMDEyOWUyYTY5Pl0gX19kcml2ZXJfcHJvYmVfZGV2aWNlKzB4NzgvMHgx
NTANCj4+ICAgICAgWzwwMDAwMDAwMDJkZmVkMjhiPl0gZHJpdmVyX3Byb2JlX2RldmljZSsweDFl
LzB4OTANCj4+ICAgICAgWzwwMDAwMDAwMGU3MDQ4ZGUyPl0gX19kZXZpY2VfYXR0YWNoX2RyaXZl
cisweDg1LzB4MTEwDQo+PiAgICAgIFs8MDAwMDAwMDAzMmRjYTI5NT5dIGJ1c19mb3JfZWFjaF9k
cnYrMHg4NS8weGUwDQo+PiAgICAgIFs8MDAwMDAwMDAzOTFjNWE3ZD5dIF9fZGV2aWNlX2F0dGFj
aCsweGJlLzB4MWUwDQo+PiAgICAgIFs8MDAwMDAwMDAyNmRhYmVjMD5dIGJ1c19wcm9iZV9kZXZp
Y2UrMHg5NC8weGIwDQo+PiAgICAgIFs8MDAwMDAwMDBjNTkwZDkzNj5dIGRldmljZV9hZGQrMHg2
NTYvMHg4NzANCj4+ICAgICAgWzwwMDAwMDAwMDNkNjliZmFhPl0gbmRfYXN5bmNfZGV2aWNlX3Jl
Z2lzdGVyKzB4ZS8weDUwIFtsaWJudmRpbW1dDQo+PiAgICAgIFs8MDAwMDAwMDAzZjRjNTJhND5d
IGFzeW5jX3J1bl9lbnRyeV9mbisweDJlLzB4MTEwDQo+PiAgICAgIFs8MDAwMDAwMDBlMjAxZjRi
MD5dIHByb2Nlc3Nfb25lX3dvcmsrMHgxZWUvMHg2MDANCj4+ICAgICAgWzwwMDAwMDAwMDZkOTBk
NWE5Pl0gd29ya2VyX3RocmVhZCsweDE4My8weDM1MA0KPj4NCj4+IENjOiBEYXZlIEppYW5nIDxk
YXZlLmppYW5nQGludGVsLmNvbT4NCj4+IENjOiBJcmEgV2VpbnkgPGlyYS53ZWlueUBpbnRlbC5j
b20+DQo+PiBGaXhlczogMWI0MGUwOWExMjMyICgibGlibnZkaW1tOiBibGsgbGFiZWxzIGFuZCBu
YW1lc3BhY2UgaW5zdGFudGlhdGlvbiIpDQo+IA0KPiBXaGF0IGlzIHRoZSBiaWdnZXIgZWZmZWN0
IHRoZSB1c2VyIHdpbGwgc2VlPw0KDQoqVXNlcnMqIGNhbm5vdCB1c2UgdGhpcyBwbWVtIHVudGls
IHRoZXkgemVyby1sYWJlbCB0aGUgZGV2aWNlLg0KSW4gbXkgdW5kZXJzdGFuZGluZywgb25jZSB0
aGUgbGVha2FnZSBvY2N1cnMsIHRoZXJlIGlzIG5vIHdheSB0byByZWNsYWltIHRoZSBtZW1vcnkg
dW50aWwgcmVib290DQoNCg0KPiANCj4gRG9lcyB0aGlzIGNhdXNlIGEgbG9uZyB0ZXJtIHVzZXIg
ZWZmZWN0PyAgRm9yIGV4YW1wbGUsIGlmIGEgdXNlcnMgc3lzdGVtDQo+IGhhcyBhIGJhZCBsYWJl
bCBJIHRoaW5rIHRoaXMgaXMgZ29pbmcgdG8gYmUgYSBwcmV0dHkgbWlub3IgbWVtb3J5IGxlYWsN
Cj4gd2hpY2gganVzdCBoYW5ncyBhcm91bmQgdW50aWwgcmVib290LCBjb3JyZWN0Pw0KPiANCj4+
IFNpZ25lZC1vZmYtYnk6IExpIFpoaWppYW4gPGxpemhpamlhbkBmdWppdHN1LmNvbT4NCj4+IC0t
LQ0KPj4NCj4+IENjOiBJcmEgV2VpbnkgPGlyYS53ZWlueUBpbnRlbC5jb20+DQo+Pj4gIEZyb20g
d2hhdCBJIGNhbiB0ZWxsIGNyZWF0ZV9uYW1lc3BhY2VfcG1lbSgpIG11c3QgYmUgcmV0dXJuaW5n
IEVBR0FJTg0KPj4+IHdoaWNoIGxlYXZlcyBkZXZzIGFsbG9jYXRlZCBidXQgZmFpbHMgdG8gaW5j
cmVtZW50IGNvdW50LiAgVGh1cyB0aGVyZSBhcmUNCj4+PiBubyB2YWxpZCBsYWJlbHMgYnV0IGRl
dnMgd2FzIG5vdCBmcmVlJ2VkLg0KPj4NCj4+PiBDYW4geW91IHRyYWNlIHRoZSBlcnJvciB5b3Ug
YXJlIHNlZWluZyBhIGJpdCBtb3JlIHRvIHNlZSBpZiB0aGlzIGlzIHRoZQ0KPj4+IGNhc2U/DQo+
PiAgICBIaSBJcmEsIFNvcnJ5IGZvciB0aGUgbGF0ZSByZXBseS4gSSBoYXZlIHJlcHJvZHVjZWQg
aXQgdGhlc2UgZGF5cy4NCj4+ICAgIFllYWgsIHRoZSBMU0EgaXMgY29udGFpbmluZyBhIGxhYmVs
IGluIHdoaWNoIHRoZSBpc2V0Y29va2llIGlzIGludmFsaWQuDQo+IA0KPiBOUCwgc29tZXRpbWVz
IGl0IHRha2VzIGEgd2hpbGUgdG8gcmVhbGx5IGRlYnVnIHNvbWV0aGluZy4NCj4gDQo+Pg0KPj4g
VjI6DQo+PiAgICB1cGRhdGUgZGVzY3JpcHRpb24gYW5kIGNvbW1lbnQNCj4+IC0tLQ0KPj4gICBk
cml2ZXJzL252ZGltbS9uYW1lc3BhY2VfZGV2cy5jIHwgOCArKysrKysrLQ0KPj4gICAxIGZpbGUg
Y2hhbmdlZCwgNyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+Pg0KPj4gZGlmZiAtLWdp
dCBhL2RyaXZlcnMvbnZkaW1tL25hbWVzcGFjZV9kZXZzLmMgYi9kcml2ZXJzL252ZGltbS9uYW1l
c3BhY2VfZGV2cy5jDQo+PiBpbmRleCBkNmQ1NThmOTRkNmIuLjI4YzlhZmMwMWRjYSAxMDA2NDQN
Cj4+IC0tLSBhL2RyaXZlcnMvbnZkaW1tL25hbWVzcGFjZV9kZXZzLmMNCj4+ICsrKyBiL2RyaXZl
cnMvbnZkaW1tL25hbWVzcGFjZV9kZXZzLmMNCj4+IEBAIC0xOTk0LDcgKzE5OTQsMTMgQEAgc3Rh
dGljIHN0cnVjdCBkZXZpY2UgKipzY2FuX2xhYmVscyhzdHJ1Y3QgbmRfcmVnaW9uICpuZF9yZWdp
b24pDQo+PiAgIAkJLyogUHVibGlzaCBhIHplcm8tc2l6ZWQgbmFtZXNwYWNlIGZvciB1c2Vyc3Bh
Y2UgdG8gY29uZmlndXJlLiAqLw0KPj4gICAJCW5kX21hcHBpbmdfZnJlZV9sYWJlbHMobmRfbWFw
cGluZyk7DQo+PiAgIA0KPj4gLQkJZGV2cyA9IGtjYWxsb2MoMiwgc2l6ZW9mKGRldiksIEdGUF9L
RVJORUwpOw0KPj4gKwkJLyoNCj4+ICsJCSAqIFRyeSB0byB1c2UgdGhlIGRldnMgdGhhdCBtYXkg
aGF2ZSBhbHJlYWR5IGJlZW4gYWxsb2NhdGVkDQo+PiArCQkgKiBhYm92ZSBmaXJzdC4gVGhpcyB3
b3VsZCBoYXBwZW5kIHdoZW4gY3JlYXRlX25hbWVzcGFjZV9wbWVtKCkNCj4+ICsJCSAqIG1lZXRz
IGFuIGludmFsaWQgbGFiZWwuDQo+PiArCQkgKi8NCj4+ICsJCWlmICghZGV2cykNCj4+ICsJCQlk
ZXZzID0ga2NhbGxvYygyLCBzaXplb2YoZGV2KSwgR0ZQX0tFUk5FTCk7DQo+IA0KPiBJJ20gc3Rp
bGwgdGVtcHRlZCB0byB0cnkgYW5kIGZpeCB0aGUgY291bnQgYnV0IEkgdGhpbmsgdGhpcyB3aWxs
IHdvcmsuDQoNCkkgY2Fubm90IGdldCB5b3VyICpmaXggdGhlIGNvdW50KiA/DQpEb2VzICJmaXgg
dGhlIGNvdW50KiIgbWVhbnMgdG8gZnJlZSB0aGUgZGV2cyBpbiB0aGUgY2FzZSBvZiBlcnJvciBj
YXNlczoNCg0KJCBnaXQgZGlmZg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbnZkaW1tL25hbWVzcGFj
ZV9kZXZzLmMgYi9kcml2ZXJzL252ZGltbS9uYW1lc3BhY2VfZGV2cy5jDQppbmRleCAyOGM5YWZj
MDFkY2EuLjNmYWUwMGEwNWFkNyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbnZkaW1tL25hbWVzcGFj
ZV9kZXZzLmMNCisrKyBiL2RyaXZlcnMvbnZkaW1tL25hbWVzcGFjZV9kZXZzLmMNCkBAIC0xOTcw
LDYgKzE5NzAsMTAgQEAgc3RhdGljIHN0cnVjdCBkZXZpY2UgKipzY2FuX2xhYmVscyhzdHJ1Y3Qg
bmRfcmVnaW9uICpuZF9yZWdpb24pDQogIA0KICAgICAgICAgICAgICAgICBkZXYgPSBjcmVhdGVf
bmFtZXNwYWNlX3BtZW0obmRfcmVnaW9uLCBuZF9tYXBwaW5nLCBuZF9sYWJlbCk7DQogICAgICAg
ICAgICAgICAgIGlmIChJU19FUlIoZGV2KSkgew0KKyAgICAgICAgICAgICAgICAgICAgICAgaWYg
KCFjb3VudCkgew0KKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBrZnJlZShkZXZzKTsN
CisgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZGV2cyA9IE5VTEw7DQorICAgICAgICAg
ICAgICAgICAgICAgICB9DQoNCg0KDQoNCg0KPiBMZXQgbWUga25vdyBhYm91dCB0aGUgc2V2ZXJp
dHkgb2YgdGhlIGlzc3VlLg0KPiANCj4gSXJhDQo+IA0KPj4gICAJCWlmICghZGV2cykNCj4+ICAg
CQkJZ290byBlcnI7DQo+PiAgIA0KPj4gLS0gDQo+PiAyLjI5LjINCj4+DQo+IA0KPiANCj4g
