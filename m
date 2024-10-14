Received: from esa15.fujitsucc.c3s2.iphmx.com (esa15.fujitsucc.c3s2.iphmx.com [68.232.156.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F551448C7
	for <nvdimm@lists.linux.dev>; Mon, 14 Oct 2024 06:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.156.107
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728888987; cv=fail; b=YvkTMHSvzlAZ6nZTNHdVmxKA4XD9v/d2ObSB3SAyPAA0/0q2eNDHKWkS5eFFP4y/qO2znmxZvVRquRy+Z8uei/MWwrTaNpnmS1kUP3COegfs1HDolCxqYDMdfY6gq4cj5gja/KJ5G77eLMPs2wlbxgnRCm2PAj9RcVVB+VzIl40=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728888987; c=relaxed/simple;
	bh=XbDnggU1KlGnGo44z+cmZ9khhDatjsHvo2meVCNqaLo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ltd11F37dt2193fbJ3qKal94InZ6eZ2ybPMemXJjGHrdIzsuFmg2kNElQuNw6PoC5m3e/uP8VmLE9o64kJLZx5ZaB7kUkPwW8i40WqzscSPpL1VvbU1BDZW1/kr2gcBtbXdfVQDPFePDU0wdP5Lnhu4tI6yjUeTJzCD2qGL1OGA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=JsFX/HC3; arc=fail smtp.client-ip=68.232.156.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="JsFX/HC3"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1728888985; x=1760424985;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=XbDnggU1KlGnGo44z+cmZ9khhDatjsHvo2meVCNqaLo=;
  b=JsFX/HC3tETl0oyLeNb0IeMWCw70E+ya+mCnjjGvXgNHHi/POJ0r+ZJS
   ilK7Z85XrlidLO00ou7pslXdLb3RzY3iz+DkrUfepc7kcfDh99ZINVoK0
   r/v55yzpOWzKkzBil2G3NAyq9pmt8rw2aqEH6sNJBaSdL+VGYkVxbSTYs
   ICpfBvWtescffdwmAqG1mOTfUwGQHQghwaFRKJNHVzCGkuvbPmKfTxSyV
   FGygCpgpiDqtqbhUb0iUbtdV2bsh/Y0zg0kILI5/uLsy0G4lyjD9cSpc/
   azmStqkykqr8Zj1Nn+RXq7IdUez95LQKWgylDmgHUO3fEXmUmSKLzmeDW
   Q==;
X-CSE-ConnectionGUID: nxPC6N2PR8C4LWuwbgvyhw==
X-CSE-MsgGUID: 9zXiyqbgSTm92GLJVb/PUw==
X-IronPort-AV: E=McAfee;i="6700,10204,11224"; a="134013731"
X-IronPort-AV: E=Sophos;i="6.11,202,1725289200"; 
   d="scan'208";a="134013731"
Received: from mail-japanwestazlp17011029.outbound.protection.outlook.com (HELO OS0P286CU010.outbound.protection.outlook.com) ([40.93.130.29])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2024 15:56:16 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LK/Gw19gbgY+WxkA1X9+4zqz3LXmht9hEsNVf7jHOfwOdt7xu5q9hz2/z7xtC56IbLcJy44srIfE4F00QN1SeLUkVK3lRy9BVlGJTMWXjfMYSC/neAxgo04GPRIvyIuB5PtoJhKzmYEClvN1JdWmyc4+HRnbCUAQJ6hVe7lMSjlj2qb8vRqOMAhDpaV+OSiomJdRaJniQfX5j2UdruFyxDtwSupFLDBvya+BH9B7zoQGF3tYdFVRPqAnCkIESHLBnBufvMMrvZ71Vqx9BlFb5qEOUtE44QFom74MvfblAjDplALMQlGdwl4MCUHWhGoDFsQ/0SdgiKm9eLM5h0W6SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XbDnggU1KlGnGo44z+cmZ9khhDatjsHvo2meVCNqaLo=;
 b=ERNBrol+qH2U1S058sXCj0cwzhKQDRTyPb6hhbfEqkSdEh1UcoTK557BfsL9WagVPtVDwHOnOfijJx8wmPVq79a2mhWD6paDf7oS4UOdzLZpvOh2OyefLjF+RdU1AexYXeFv0z3KOyCto4E/mhrlrttNMGWdOFyMjRAhNIXwzTgEcWQsGLRRFhvR6XdZ57OAOYMLLhtPG9BIDX36uY++Ku8UZa8/PZpaBJ0lEyV2g/9qWawpl40LZOI/zZD77rRaoFenJC98vJLASmdUcl1DiFM9dysHvE4buYQli7qYosXWDxO+ShxUA83KLqgQivMI+OO26TWEkrG5fweTlqhMsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from TY1PR01MB1562.jpnprd01.prod.outlook.com (2603:1096:403:6::12)
 by TY3PR01MB11039.jpnprd01.prod.outlook.com (2603:1096:400:3b4::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.24; Mon, 14 Oct
 2024 06:56:13 +0000
Received: from TY1PR01MB1562.jpnprd01.prod.outlook.com
 ([fe80::d9ba:425a:7044:6377]) by TY1PR01MB1562.jpnprd01.prod.outlook.com
 ([fe80::d9ba:425a:7044:6377%5]) with mapi id 15.20.8048.020; Mon, 14 Oct 2024
 06:56:13 +0000
From: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>
To: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
CC: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH] test/security.sh: add missing jq requirement check
Thread-Topic: [ndctl PATCH] test/security.sh: add missing jq requirement check
Thread-Index: AQHbHgVI7HXzgYOTWUOkm06HHQ+zkrKF0EOA
Date: Mon, 14 Oct 2024 06:56:12 +0000
Message-ID: <254daa12-810b-4b2c-a927-0d12094ecc4d@fujitsu.com>
References: <20241014064951.1221095-1-lizhijian@fujitsu.com>
In-Reply-To: <20241014064951.1221095-1-lizhijian@fujitsu.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY1PR01MB1562:EE_|TY3PR01MB11039:EE_
x-ms-office365-filtering-correlation-id: c2799c40-7c92-47b5-f2ec-08dcec1d4aa2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|1580799027|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?M1cvekd4Qy95M3QrQVVLOW1OY2tXUjFqY2pESjB0SXZhWFZ1Y05TZDczSUcr?=
 =?utf-8?B?ckR1UVI4UkwzNTcvL1hoVWNUK1diMTYwTkRzQnVxdUQvMzcrUWYvSjlkVnRN?=
 =?utf-8?B?akNBL1JmYk9oK2phNDRyYU9GdnU0bGNPRnRON1VGcmN1NjFINU5SRlRRRkVQ?=
 =?utf-8?B?amp0dGN6L29pbmZSU2NkaEhaVWJGSUw0dEFabkZoYVVVb3kyS0t2R3M3K0hD?=
 =?utf-8?B?eUlvelFoOXhhVHFrbWM3NjJkTWtDMml2YXFZTUovc2hGWEdibUcreU4xaWhZ?=
 =?utf-8?B?QXlGL0htdXRLOTFORzhieHdYOVI5R0hwWk55b0pibG9hdG5TbTBqeWxJZ0xk?=
 =?utf-8?B?WWl1bkk0aGNrYnprcDJZdWhQcU1ZS3kzMUhaM2dDU0tPUUszS0dLKzc0blp5?=
 =?utf-8?B?a1dmNmc1cUdIZUk5YmZmR2ZZRnFOS1dLR3lkUytwU1JFVlRvbzlPY0ZuN056?=
 =?utf-8?B?TXdvQUZDVG1GUGduaDBWRzFIOGt0SnMxZjBvRXhHNkYxSjZ1dTJhSEZNdWx4?=
 =?utf-8?B?d1ozZEZNWkI4VExSRGNrNEczZGFOYnN4R2hmWlpMY1BraFJaZk1ML2gyR2JT?=
 =?utf-8?B?QjByYUFSTDgyV2FLWTJUdG9WclVBSUVrd3ZhY291T1d3akRIWFRHV2gyTSty?=
 =?utf-8?B?L0tJNmNRUk9LL2JEYnpPQVl1c3FZQXJudUxXdGdFall2Q0hBNml3ZXVYSTQx?=
 =?utf-8?B?SFpIbW9oSmFXME81aTl0aWljUTFOd0Q0aTFTMndxVmx3TmtpTXJxQWMvdE5j?=
 =?utf-8?B?cnZGbDI3aml5YlNYN08rVVBSQ3NEeHFnelpYdDFSdHQzN2tpVG5iQ2hzM3h0?=
 =?utf-8?B?MWJKRi9VaXQwUHladk0rL21mZGliU1hxQ3pTNGdockUwTndxdzZ0U2taVWdr?=
 =?utf-8?B?UXlnd3Q5Um9uVlk3aFVwTldHYmc3T0F2emQrQ1ZYMk5iVmpNNGNFbWdxMkQ4?=
 =?utf-8?B?dUt4ZmM2cDVqSFBONWlXUEhFOU81bitXYjdJQ00raXZmZFJmNVliR2h3TTF4?=
 =?utf-8?B?aDlxLzgzdDgrYllMMVJzQnJHbE55U2dZRDVvN3l4K2FUbDBsYjQxV1JuUHFp?=
 =?utf-8?B?L3VTNHRrNG1PeFZualpQbEVxZE03R3V3ZHFROW9rUVZvejgrc242YUtRbFVR?=
 =?utf-8?B?aW9OSHBYdWh1TGdtRFloWlVyakY1WFNnd1l3ZUh6QUZHUmxaRWk4b1FjSW1r?=
 =?utf-8?B?SCs5RU5qSmJmSW9xUldJL2E5WGJiMElPVkFlUWtuTEZ2MitmQkErSDNPSGM4?=
 =?utf-8?B?dUZ3M0hVc2JxVWhGditLK0lYWHVvTC9EZG0zMXBGTmEvQ25wZkd6Z3JlMVJs?=
 =?utf-8?B?bnl6M0lLb2dVYkxyRFRHZkZSVHI4RG56T2dYemRVYmt3VzZ5Z1YzeTVEaW5R?=
 =?utf-8?B?VTkremNVZUQ1c0E4TnJVRHlKTFZPZmtxOERaanNZS0JsMk85aXl3MS8yYlg3?=
 =?utf-8?B?QXdXdVF1NmllSUJVaDVBOGwydEZDeUJ2U09nTmRCSHptSlhMNGJMYVpzams1?=
 =?utf-8?B?V1dDUC82U3NSVm5TZ2lOWisrckZyeCtIZ3p5S3Jlb3paTHNzb1pSV3ZUTVpj?=
 =?utf-8?B?Tm5PNWhqYTdRTm5FZzRHcFIxRTJNSkVnSnQ2cTdVZFRrZ2ZuMmJGaHQ1UG8v?=
 =?utf-8?B?d1BGbmJDWHBQc29yWHFQbFJWZVlyVnpVK1hTK05kY2s1UjRTbU85ZzNQSXRr?=
 =?utf-8?B?RmpoelArTG85MS9HVXZXY1J0TThZVXBmN2JPNnA0cm0vTnlTdjJ2RUlXNGFx?=
 =?utf-8?B?MHFqd0hrMHRJOS92WFpjY0lRSS9ZUXlLUE02K29zaWoySVlnZmcvOExwSlZB?=
 =?utf-8?Q?I2/G/S5cpEKqUmeNJJShs7UJqW9D40EssgSSk=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY1PR01MB1562.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(1580799027)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?blFkR0U0NVdxNVJYcEx3TG8xczZIVHVUYUNNc2o0UGNVcHQxMWVHK0tVeGhr?=
 =?utf-8?B?UnFKcDRGK0NYYlJVeWU2K3dtdHN4aFJBQnlEVWpuUlRMWG9pUkpiZHpPVjFm?=
 =?utf-8?B?Rm5ac3JCc2QzVm9xT2w4K29EUUErV3JWVjc0aFkrOFVXYVFrTjFnM0Z0UnBq?=
 =?utf-8?B?S0tvYVE2Vmg0L2lJclhmVGFIL0VDbnU2TFBYUWNUOXdhQ1h2ajFCVGRjRENp?=
 =?utf-8?B?Q0xHeGQ3RnZXSVZOZzNsZnBWOUJVeTVwaWMxNk1uYi9XOFhSQW1wN2ZPQUR0?=
 =?utf-8?B?SUtJZG1DN1lGYncwOS9oU200bkNJYXVTbTd4NUJmYk45cy82V2JSWmc2Y01a?=
 =?utf-8?B?VW5CY1VCSmpyNkpDbGhJRUxzektadURqbUx0NDFpS2hIN1kxeWdobHF1TE4r?=
 =?utf-8?B?WTNLZXFCL0tCNlpiUHBYUjBMZlEveTZtOENxZXhXaVNLNUxqN3lNK3dnNTc1?=
 =?utf-8?B?V0RnN1cyS0ZlZVBWZzZTY1p0WFpjVW1HWWtsMVpLZzBpNVh4UWNhNE9LMHJK?=
 =?utf-8?B?M0UyOW9TbEVxekh4VEVUaER0TS85UmUxcWx0MmpKQWRtL0lEKzB2emFCcW8x?=
 =?utf-8?B?a1V0QjZWOVBpNDlqMUpvWEFrV0g2U0NvM1FjdXdveWkvVkhQRDBJRXgrbVNO?=
 =?utf-8?B?NjFFTjF2eDlnT1U3OW45eXV3WmxZd2dWaTJzdzJxL3ovUFJ0cCtLbHU2WHpK?=
 =?utf-8?B?NlhMZjB4ejVjSWNYOVRQQXp3YjNNM1c5VEo3TkxmVkVzbDhSQi9KOXRmOFEw?=
 =?utf-8?B?cXIxeHZKempkUUtvU28xdjdDdnNaYzNZQ0hxMEpIaW4yczVRV2g1UUVNdUxx?=
 =?utf-8?B?TThJSm9MQlMyMUgwd2M1cTZ2WE1OWlk1eEh3WDhta0dKY0ZlNkpSa0NjT3Az?=
 =?utf-8?B?cExYMVZrdjJJRjZ2TjJlMGhCcDEwNjFBSzMvNVphemgreW1VSG5XZGs5Qm5j?=
 =?utf-8?B?dzg0TWRFT0greGFzNWd1dzlKT0UwYWdkeUJVK0dKVEpLS201YXlObk1GS2Fn?=
 =?utf-8?B?TGZCcU1FaG16Z3Q3Wkh2dEYxWW5QNWdIQ0lIWWc3UzV6Z0tXYnMvSE9hOVFE?=
 =?utf-8?B?bk5tNWNZbFZFaEJpSGpxNzBkZGxoSzhMVTNFQzJhNXhrZTQ5T1N0VUxjWitM?=
 =?utf-8?B?ZmFtODREQmVWdWJveEtPbTdnaVJ4OVNwaXBheFNOdjI0a3FNSFZPWUlaMHVT?=
 =?utf-8?B?bUU4N0JQdGpPZ1NlSXM3ajkyaGFVZy9kaGE1c3JtNEVLblVjSGNEQ3Z1Kytq?=
 =?utf-8?B?WGFpbU0wY3N0ZzhkeUo0c1B2b2hjVkRjY1lBcnRGMFc2d3h5K3BEc3RmMmxV?=
 =?utf-8?B?b0FXVUZ1UEwyMWpkZzBnVFhsT3k1d1Vod1hBVVpGeVc1YU1JVTJzeGJBek42?=
 =?utf-8?B?Tmsrbmh0RE9hZGlvVTFDUmVCNUpvbXgrbExuVzF0WVBaeDdMMityQUZkQ2Y5?=
 =?utf-8?B?WWhsWFJWNVgrWUlpTVNHbW1xUXdEdUdZeENSa2VwR2k5dHJMQmtwbEJnQ0Zr?=
 =?utf-8?B?aXMvQWhEOXFIZ3A4c2JQQjE2RnBZTlR6SkxkQWQwUjFaeUhSdDIyNHdYMzlH?=
 =?utf-8?B?MFNvSStSTzhHQnhwR0lwY2U1Wkp5em5ickY2dVo2SzZIWWNZWVpUVmN3TUly?=
 =?utf-8?B?MDBFZG1IR21tSG5UZ2ZHdCtoYlcxSDYxRjgvamdqd3pjT1NBR21WME1lSFhZ?=
 =?utf-8?B?cmhyMWxHeVg1SVN6MHN0enY2Y2hwU3l1bTJvWkkvcGl3T09rMGo1Sy9iYmxr?=
 =?utf-8?B?NHlaTjZGM2tSUjAzOTExUnZ6elZDOVd0YVZkMGQ4VnBrdDQ1UE5odXY2Z1BM?=
 =?utf-8?B?bXJnaElTeGQvR25XdXFwQm00VkZuM2ZYQ1lDZEpscFhNeENCQWRMd2Z6MUcv?=
 =?utf-8?B?T0VVRVVXTHBGTGpDZXpqbXpqSzBBcnpuL0dSVnhYOXFwTWV5VWJvQm1jU2lH?=
 =?utf-8?B?TWJGY2hkelNSTW1GZmZFdDRhNERPT05xaTQ5UG5vNTdZTEZnRmRhTVluZVR4?=
 =?utf-8?B?RTM2NGg5QlFYQkEyRXlPdHhVei9ycm9KMk9EWDh3anIwMU5JUjRac2YrM0ZB?=
 =?utf-8?B?OXFXeGpqOFlYZTRSZXhJQmt0R2Qyc1orNFkzUHJ1UXJNb1EzZlN0ZWhnYmZG?=
 =?utf-8?B?VzUrYXAzMnFEeEVzQWRYbmxUSHFUdXVvaEhoT2dUM1Y0NnQ1TVVtZkRQVDFQ?=
 =?utf-8?B?dmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <960B31CC1AF17045B10DE14ADC6E5F19@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	eYfqU9WWQ02DgmGBydvjDZNrUM7YiDV2+vigDJcw1fBO3gw4noAP90pHEH5zeSVGiUXHoVMPX/BimJTRZTR0VoxDOeMbWPiSGj72WYbuhf6SrakGDkswnbSDXy95myT/6xuzgjyTlVd/fixTKXx05NgZWdpVnrzsGWuBFZKtzrnWi2YGjEaY/YhaadRgKiwrbKVr6PxsPIhSOZVVq/exUeQ8dSZeqT6OgDl3MJWDQlOZzi2ZxVesxp5UEQ83w24AcKeOZxh8FwfnGSSA03BxCK1gmKiXyshjQq4ViDmslBNAYK/tTd23t4ZE/nvMV8P2tr42qtdG3isjabQ1r/yRpxAyOSsDTfelaZvTX4Q5uLyBQee9+PS8phEGL+221COBdnk0Y/I2Fu1oKKaLOR9nfV7jyjOMQmTKTjpPrEQugCJfFmeGQjD4Vm1k89t51R06ohzHPxcWW7b4aaLnwNxF1bDLtw7ln1JX1JqHt7jajnYxiJlgvh41sHXAketx57T8qQhB7OzkxYIvSQI707UeqUCN3VZj1ofLTIOEB88PU00MMqBS9/67jkPsWwgq8AJhc/uKUxHRuH0RQL2Y6HZ4JAlfKDNvXzX7iCKmYcFG8OwlEKNX0yVYl1ivT4rgj55D
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY1PR01MB1562.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2799c40-7c92-47b5-f2ec-08dcec1d4aa2
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2024 06:56:12.9971
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gw3qojK1HmxPOSvQm0+H0zlbh0pXopDq1i7YDN3RpImzSSkbTxhTyqfpuOtnb0a9ncv2SRJKT4x6pkpLeivodw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY3PR01MB11039

DQoNCk9uIDE0LzEwLzIwMjQgMTQ6NDksIExpIFpoaWppYW4gd3JvdGU6DQo+IEFkZCBqZCByZXF1
aXJlbWVudCBjaGVjayBleHBsaWNpdGx5IGxpa2Ugb3RoZXJzIHNvIHRoYXQgdGhlIHRlc3QgY2Fu
DQo+IGJlIHNraXBwZWQgd2hlbiBubyBqZCBpcyBpbnN0YWxsZWQuDQoNCkZpeCBhIHR5cG8NCnMv
amQvanENCg0KDQoNCj4gDQo+IFNpZ25lZC1vZmYtYnk6IExpIFpoaWppYW4gPGxpemhpamlhbkBm
dWppdHN1LmNvbT4NCj4gLS0tDQo+ICAgdGVzdC9zZWN1cml0eS5zaCB8IDEgKw0KPiAgIDEgZmls
ZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL3Rlc3Qvc2VjdXJp
dHkuc2ggYi90ZXN0L3NlY3VyaXR5LnNoDQo+IGluZGV4IGY5NTRhZWMzZTI1YS4uZDNhODQwYzIz
Mjc2IDEwMDc1NQ0KPiAtLS0gYS90ZXN0L3NlY3VyaXR5LnNoDQo+ICsrKyBiL3Rlc3Qvc2VjdXJp
dHkuc2gNCj4gQEAgLTIyMCw2ICsyMjAsNyBAQCBlbHNlDQo+ICAgZmkNCj4gICANCj4gICBjaGVj
a19wcmVyZXEgImtleWN0bCINCj4gK2NoZWNrX3ByZXJlcSAianEiDQo+ICAgDQo+ICAgdWlkPSIk
KGtleWN0bCBzaG93IHwgZ3JlcCAtRW8gIl91aWQuWzAtOV0rIiB8IGhlYWQgLTEgfCBjdXQgLWQu
IC1mMi0pIg0KPiAgIGlmIFsgIiR1aWQiIC1uZSAwIF07IHRoZW4=
