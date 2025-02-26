Received: from esa17.fujitsucc.c3s2.iphmx.com (esa17.fujitsucc.c3s2.iphmx.com [216.71.158.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED0C26E162
	for <nvdimm@lists.linux.dev>; Wed, 26 Feb 2025 07:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.158.34
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740553358; cv=fail; b=a/cmlsslKa5h+V0pbEl0VIw+sdQrqbegto+cB8J9QEWZEpbBAtkY0ZqSnQ52Kg2P7sHp3n/xpKg3KZqdlAq0ThGqb0b+oJrF1jwMN9DAbrQc57axqsOnVVfdon2oPiSD9bSBc8Q+x8S3yKm3bjI3IU+YPPa47xvDbTnhxtmDFtU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740553358; c=relaxed/simple;
	bh=FQrR4CcDKKN6nGHOYSppROA4SE8IPf3Z0TvugZOHDK4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RxtkBkby/zMqLuEVijRUYd8HiQbQzS6K0QSuqdW/l1yan5G6KDpxVygCEqeBTlSXyCbWWZPtCg3n+RYZHROIUzwTrjNXOYP2GGdBe/CAb3BA4oK87VzKwfZb3cYaOntE4L6ohmyS0MFBu5nl6hdpcdleXGUEdh3Vs7Gf0RGVz64=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=dkvjulRb; arc=fail smtp.client-ip=216.71.158.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="dkvjulRb"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1740553356; x=1772089356;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=FQrR4CcDKKN6nGHOYSppROA4SE8IPf3Z0TvugZOHDK4=;
  b=dkvjulRb9g8q66ZF+x+momks7gfquTyFdWjMLnHQrr/3KCXmgMyfj0+U
   MRv5yg7WlnlUT9doly1Bk0wKBdVcmvapWAVjuYAm8FHGgz8I/kPKPk+u4
   0fB4nAA8YW0sCrS4V+/USrmAWOyuwbhSTJzCVtPOZtJOYYSIFI4D5Wjib
   jedwL+Db+ptSp1uBpKOWf4hJRZ1WscRYxLhOTh8sQ7yaALbd1Af/gcRBV
   18I7QxbbZelvUhSPrxubH9VuvkeBd617fQOxFJ3E51WYGFtuK8XZD9YVh
   qLQQsYJy8/UXcK4Ca07bbK5gPIUs48pcGS7xLIPtJNj2RfKAF2Ti3HKPZ
   w==;
X-CSE-ConnectionGUID: eHtgdYxPQrKKzeOp001hLw==
X-CSE-MsgGUID: Jz8PNp0zT7uj+ywh0Nqq/g==
X-IronPort-AV: E=McAfee;i="6700,10204,11356"; a="147579957"
X-IronPort-AV: E=Sophos;i="6.13,316,1732546800"; 
   d="scan'208";a="147579957"
Received: from mail-japanwestazlp17011028.outbound.protection.outlook.com (HELO OS0P286CU010.outbound.protection.outlook.com) ([40.93.130.28])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 16:01:24 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ddn9QO8q4qOsQnRCeghIRuV0lbn1pBEmErUyoPDiG8RKArHQGMvxI8e2EkIzEJL7oTRRTIzOvfAQjrj+ae7FhBhRsIi/zRBguQRNPQ7YySwDBXvRQV4j7FutT4kWNnq0p/AoXAIvMXJypG1eXwMP7y3fLPzTGxXZnJIR4Yt87sIIz5a4bhsQun7R8w6Oo05PQelof/oG1QE4q1NooxG4nxphpU9kEu8xD2Mg8adj1MkaqGxm9+eBKRbBBO7jaRcRadQjf2QZSry/CNA2QMpYqMVg1560r7Eb/vl5Jigky+JiE86s20QYTd1keHDQ2ACs4KZeMTWIpzweTOiqdpKoLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FQrR4CcDKKN6nGHOYSppROA4SE8IPf3Z0TvugZOHDK4=;
 b=L3lo5JcX1Wyj4Lg3LsihcvnhaEjDYd8w/czRqv4kAyUh9hlGXv2+VsylDWHKYRUUovN0mXRmSX2I6Jkuh8/ItYeUC08P3Xrm4hy1xi0h9AYk0JW6Trwhb4x/juP08szGvyzS8O3SdOXIYxYLk6bWO7nRo+XgtqqYRbwmFLba2HSxKYPuFgRXR071vTm2i363AcwCp2fO6MXLTYONi4oe01GOAxRKDGO0nYSV5Qh3LYBLX92vy8gOHsBrJeYcAP90ZRc2Dag2/cI8G8C4VRY30lNzFQdBbU5ibC9/GciAzLCLp3BtTvjJOp1xKqOi4EHVQMqtV1GK3g9rJLYlhxDy2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from TY1PR01MB1562.jpnprd01.prod.outlook.com (2603:1096:403:6::12)
 by TYCPR01MB10277.jpnprd01.prod.outlook.com (2603:1096:400:1d7::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.19; Wed, 26 Feb
 2025 07:01:21 +0000
Received: from TY1PR01MB1562.jpnprd01.prod.outlook.com
 ([fe80::d9ba:425a:7044:6377]) by TY1PR01MB1562.jpnprd01.prod.outlook.com
 ([fe80::d9ba:425a:7044:6377%5]) with mapi id 15.20.8466.016; Wed, 26 Feb 2025
 07:01:21 +0000
From: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>
To: Donet Tom <donettom@linux.vnet.ibm.com>, Alison Schofield
	<alison.schofield@intel.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>
CC: Ritesh Harjani <ritesh.list@gmail.com>, Li Zhijian Jeff Moyer
	<"lizhijian@fujitsu.comjmoyer"@redhat.com>
Subject: Re: [PATCH] [ndctl PATCH v2] ndctl/list: display region caps for any
 of BTT, PFN, DAX
Thread-Topic: [PATCH] [ndctl PATCH v2] ndctl/list: display region caps for any
 of BTT, PFN, DAX
Thread-Index: AQHbg1+ZF2vg7wjuvUeTwE3+Igiy5bNZMbmA
Date: Wed, 26 Feb 2025 07:01:21 +0000
Message-ID: <74c8b6c7-b9f6-465e-95f8-57472d5ccb2a@fujitsu.com>
References: <20250220062029.9789-1-donettom@linux.vnet.ibm.com>
In-Reply-To: <20250220062029.9789-1-donettom@linux.vnet.ibm.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY1PR01MB1562:EE_|TYCPR01MB10277:EE_
x-ms-office365-filtering-correlation-id: 412e11d9-8a45-41d3-4d75-08dd5633601a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|1580799027|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?cVB3WGN4aXhlZkp2SzhTWkxPTjBRZmh6Z2tWSGZReDFBMXpzcTFXZlJsNkl4?=
 =?utf-8?B?Zk1BV3VmNHR3d3MwV25Kb0lvNW0vRXRJOUtNeUNkS0pnUFRKYXhHSFVqeVVz?=
 =?utf-8?B?UmxyYTNoYW5SMTE4ODczb1pVMkl4Q2JaWDFlQ1J4MVNLZVlkL2lhVXduM3pj?=
 =?utf-8?B?WE1MWFJTRVZWUnYrUjJseTFIRUJWeitCdDg3K2QvRUQ4SHBXa0w0d0NDUlVh?=
 =?utf-8?B?OVlxVm5FM0FCb3BCMHNZcXVEOWFtTUI0V2V0K0NvSmk1Z1Nwb3k5SnlnUTVJ?=
 =?utf-8?B?RmJLeFMyd0hMY2hnUzdua1duUkErSkwwWXpHSkkyYkgyYVFpZ2lMNEFEb3NR?=
 =?utf-8?B?ZjVndThXYWNXR0d3b2lEUUVZZTQvcTVkN0FUdmpSTTNLbm1rY1BJVURxaHFT?=
 =?utf-8?B?UEc0eUU5aWR3VGFmRk9IQ2dPWndsMVB0UW5vcm1PZUo0N3ZsZzRjSklhSjBS?=
 =?utf-8?B?dkM2RzFwZGJsN3E0MUI0SndSb2dhZDh1VUlxT2JpRG1MazBSTm5pbWJLRHZk?=
 =?utf-8?B?aFBzOURkVm9HTXlyUFpBeWJJd1VnODBKbHRoV3lzMUxtTTlNWUJobFg4dm1W?=
 =?utf-8?B?Ni9TRUk4MEltRXpuODZNUUVkZlN0cWF2VWdjSE5rQVdOYXpKd0NSM0dmakVX?=
 =?utf-8?B?NUZ6UjhqZ3hySmNycE9zaERKZ3VXLzgxL3RuRFFKdTYyOEp0aG02MGEwZHFt?=
 =?utf-8?B?MU1hVkpORWFXMnd2QVRCWGp3cFdnSlZPNGFURVA5T2hiTzFyR0d2OGhrWlZj?=
 =?utf-8?B?TGxSN3ZoQ0d0V1R2b0dyS09FUGZrTHJHSk0yNVQ3dXowR1QreUJsWWxYZTNB?=
 =?utf-8?B?cm9YNkNRUHp4U013ODZzVWZSMngwR0lDYm1ybkpUVU51ZkMyVEVuakdZQllQ?=
 =?utf-8?B?VVpBK2VBSSt1RG1tVjBXWThLTUlEWWhIYjhQM29HYXBvUWZHdW1SMFliTnhi?=
 =?utf-8?B?c3Y1UkxFV1FIcEZ6QWtBVnJGUW5xd2tBWkh6dGJEQ2xhalNNNEphNXJObGYx?=
 =?utf-8?B?TWxKeTQ2ZVB4YVBLYWpBbDlLbmF2Yk9nR0ZZVmw1ZUxBbzhCZUdJdUFGbkJj?=
 =?utf-8?B?VmVxTkFwTWxVSittSGhLcVVLZ2NSMTNheklQRkR3bmVpVEUxeGJlVGRwMVEw?=
 =?utf-8?B?VE1KRlZDaDV3NDQwczVLLzNKc1FDWHB2bWxhNlpGUUtScndSSVNXU01rS2N1?=
 =?utf-8?B?bTNHTVFQTUFZRGNXT0tzSGswM1pFVGtJVjNoRzJnamZUZEVqekZHcmxIOHVX?=
 =?utf-8?B?bERma2U0NXY1NjVaWExjRGdRaG5ZcGYvVTBRTW9uQzZoZkJkbnBSYVZYWkNq?=
 =?utf-8?B?aURBUEoxUHFydmtFV0tRUUJTdjJHMkNPaHZuc3hZL05ZaHl5aDlIZzA1OEZY?=
 =?utf-8?B?U2sxL2d5VDl3UmNlNEpiRHNLdXViaUwzdzJvNXJ1WHV0bEdyMmU2TnJGc2w5?=
 =?utf-8?B?TGFXRjJWd2M3UE1POG5IYjZFTE9HVDFLbUZSaGNlYWdJQTg3cUlsSXZqUTVQ?=
 =?utf-8?B?eEQxODY4WUNmMDgzRjBLY1B1eGZyTG9xMjJrMVFybmFQM3QvWnFHMWR1MHY4?=
 =?utf-8?B?SEdIRGtpb25JNUxaTjZscVpFSHlOc1hTcm44bGN1WFJoU29zcDd0MU1MdDBG?=
 =?utf-8?B?M2Uzc0ZneEdMU1RKLys5UW1LNHJIUW5ZVks2WnJCMWdrMzVxWWJtWFJ3K2xv?=
 =?utf-8?B?b1JyZXpyb01Vc0dPaEtHQU11bk9MaHYycHFMWlpEQ2I2ZDRIYy9CMzFrZ05M?=
 =?utf-8?B?NWxPZ1hPN0xqSTJPNEdTQUVTRVcyM2FtcVF2NTZ4ZWJMR3dMclE2dzZ4RlJh?=
 =?utf-8?B?aTF4R0F3M2VjYW1SZUxOdlpRcm43QXBBNjloQ1N0Mk9sZ2pmNDhlLzdLenRr?=
 =?utf-8?B?cHJUSGpEVndmRTI1K0MxU3MyUFR1dGE0RmJHVGxGWU51a2Zva3hUNFRTRjUy?=
 =?utf-8?B?V3RZYTkyYThQQ1BQMHNaM1g1djcyZEhuNlV3SGpRY2Exb1JOSkp4S2dlMGF6?=
 =?utf-8?B?dmlPeit2MkdBPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY1PR01MB1562.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(1580799027)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?NDZlVEEvZ004ajI1a20xMG1iSTJQOGQzU1gzYTlLSjI5Y0RQc0FYclZoWjBX?=
 =?utf-8?B?c25GTWJmcE5WU0lsVVhHUWFmeHBDYk1hTWt4MElsNVRpRWE5VXpqeU9DVDEw?=
 =?utf-8?B?OTFhNDRzT0xidUI2NVFNOVlCVWZWd3ViNURueVJ3eWs5STdnM0g4M1VDZWpW?=
 =?utf-8?B?OVlPQUk1ekRTOVYxRXphdk1nQTdZbVNZdDdhRXpSLzd0SE9kajRzbVJVOUFk?=
 =?utf-8?B?eis2VFlSQnVwVHllc3ZhbXZNSmU3bWZwK1VaOE1vVHFRQ2hOODhOdldGdzVL?=
 =?utf-8?B?STNpSGZyaUI5WkZQUjFJN24rRm4rdCttZUVPclhGQWNCemZ5dHFMNzNXZTRZ?=
 =?utf-8?B?UnJGY09yMDQrUERPMVBodVgreGZYSTFTWUtRN3VrSUJ4Vk4xK3paa2o5cnd6?=
 =?utf-8?B?ME9Fb1pCbVdKK010SlloUGt6SzgxVDRNRjl5VXdTVzBseG9ndXFkeEpCU1ZW?=
 =?utf-8?B?M2FSZStzd1djcUhHT2xGNVZxOVFGdG1HUG9STXJkcHFaUHJ3UWx6SCt6ZFVM?=
 =?utf-8?B?MmhaMEVEcFkzWlRSSm5ta2d2a1N2QitWcFBOTGhNQUZGK1ZjTG1FRktXM1Vk?=
 =?utf-8?B?eFhtYTVHMng2NU4ycEk0eTBHaFdFdDVsZ0dJZVF6QTQ3UW5uMUJWd1dud1Bt?=
 =?utf-8?B?cXBic0J4cjlaZy9BQXZSNDFPQ05NRklHamFlbDF1UHNXZ0xVMzNuN3QxcFZx?=
 =?utf-8?B?aDVFVmtNQnFUZHlrc1NjWldFSEFSUjRTL2NyV0k0WHlFaWFycXpEcVpteVhH?=
 =?utf-8?B?RWdWK1FSSE1ycWh1MTlPNHZHblBMa2t4SFA5cWdXem1HYkdpbHhrVmx5VGVz?=
 =?utf-8?B?aS9HMS8zVEt6L1FmUmNmcHJBMEU1YmVVY2l1REFQaTFPYWFDS2VJS1ptYzRX?=
 =?utf-8?B?VVl3ekh2ZURJY013WXhaaEZwcS8xa3UzaVNWeEJFTGdMb1VETHRuQXpOT1FJ?=
 =?utf-8?B?bXozd2RqNUZObVcwQlRxNFlQN0xYdE9pZk00VVRDc2N1L2MwQ0JWaG5PTWtu?=
 =?utf-8?B?cHlHZEhaYjBZc1NVUndMSTJKcEI4RC9CUENrK294MUNOcmkyMG9QMUhrdFF2?=
 =?utf-8?B?SnFhSHJBS1grdDBCNDcrRVoxMTRDT1pEc09OLzdXWnpSTVlxaW8wa0dLcjlZ?=
 =?utf-8?B?Vk0yRTFWanRpN2g1NVNPdHhscEtBOTB6bXNnQk83eGFyN0ltL0VJVWxsNndq?=
 =?utf-8?B?dnlrNy94SnkxZUlGSjdhRjNYVExXeGEwZ3UyZm9GMm9zbk03eGdtd0NheGtU?=
 =?utf-8?B?WDUwUi9rNTViVDJvSHdPWDZwREZoQTBFSkZSZkJmZ29uUVAvTUdZUWNVUnJw?=
 =?utf-8?B?NUdtdW41WGMyNVJGUVBoQ0xDZ0Zjcm5VaHZXTzMwY3FINERURDVLQ3VkS1dT?=
 =?utf-8?B?UktBdTR3Q1RvR3FLdXYxaGVndkEvK0NGbnFPRXNTcVVrbGNGdVRkQ0JsQnZC?=
 =?utf-8?B?SVBUNlU3dUY1eTd1Z1VuZDVuNTlyMlZrSFU3WlYxMk81eTE3WGx6MkhGbTNo?=
 =?utf-8?B?NzJrSTVIajFuUjlnRENEMk82ZGFqZ3Z0V1ZDREx6ZmZKZFAwSkorWUhmbENR?=
 =?utf-8?B?aFE3Y3JoL3dTUDBjSmZlZVplcEloOGRMR09mbzNXMlhUQTZxZjB2VkozaFd5?=
 =?utf-8?B?VlZPU090YWJOTit3S0FQNmc5SGFVYVdXZHNIWTVtUjluVjV3U21XYmZsUFNV?=
 =?utf-8?B?b1JDaUNFMFJnZVV1bmhmRU10NDF0SEd2YUYzVVVtZGtmM2dWcDhkY05jUk5Y?=
 =?utf-8?B?S0g4dHZBazVIcW93cDF4R3p6WVFPYnE1ZlRra0RiZ3NHb3BmRm02TFhMd3hQ?=
 =?utf-8?B?MFJUNEdRN3N0aHBpTGhxSmFCckYveUQraTNjRzhMY1dxRWtMSlB1UklQTmZB?=
 =?utf-8?B?ZXp3SFFJY3VOeFFkTVo3Q0hndzdaWDhCa01BVzJQTzAzcFJXS0xZMDB0cDUx?=
 =?utf-8?B?RVY5UUpPZXgzMzZRTUJyd1ltdm5WRXVRak1EZUsvejB1ZDFiR1JFN3hhTFU0?=
 =?utf-8?B?eDVLejkyZ0JYUElzbzJZekJxakhvcmowUlMzNU1md2lNaEdja3E5WkVVekxS?=
 =?utf-8?B?TFFaTXp4MUFtN0xpWFVSWTRKRm5Wa2xvZFdUNFNONjRmVTZxNG1HaXBQcjkz?=
 =?utf-8?B?ZWd0Q2RCenh5dmZpY001Y3dlZU9IRlVWcEZqS0o4MkNMNEc1bTNRVVNlVEVp?=
 =?utf-8?B?blE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A78ACEC4FE75C54986542C31F90821A2@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KVmJudvl0cCHaJI2k+LclTeZuyfBFrrl1eIfAp2fxubYC97Jb3lTuovCTroerWL+1pzSLOPG7obDXxrweopG9hnZYqbRKLGq8O0pZBhJHF/aw2U8JGi4t/zTmJN+wynZkJxTtU/gcPUtTD1m7up2TP+p2dPhuOpuimYqC0ojzvb6/dMjIfR8vHpBXjpbg1d1Hl1UHJjIHGHaEzj8QhdJkEMfViOuIVsmE0k5EKCNgW0LiKD99ugcbLFE+ujJsvxRoHikDZKOwDRkrHB/R7+GwtSJ5G97qImJxhy1fhZ/qmuyHvZDfc2TUT1DVc9UCng2JuRPhgPYQBDuGy4MfOeJ6osnrKKqo57frD4wgNZuGQjYAAdM7rX4TPoq6g1zxQPGlYl5W769QVBN6RpJofPK/9diBPUo31lQ50n4k4CFDiyw/TSYv2KVwJMUGKdRNRV0fiLjNNHXKsMqJovNSjOf7y0mur84anrwXGV/12l0HI8pmk/4Q9aLMM6/BReog37JyP7dJ51DGn5R9MniKaSPGOHhcH3kA4+H9hfoDIG5gI+IBHYBkWIcRW6L3u0p3LXyO1XXh2SOnR9AOqeoHrAG8H0rNFH0rrNAgfVb8YU/fWFyOmkfSThDVfUjoeZ1hvp6
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY1PR01MB1562.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 412e11d9-8a45-41d3-4d75-08dd5633601a
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Feb 2025 07:01:21.1673
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qRLCNTJUyNVIXDBWOQWkthFhOrqi5L4k8UGUHJQ5ieVAVxyPrD8eMN1kuqgGvdALjORRbitLnPr9jtV2Nmxzpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB10277

DQoNCk9uIDIwLzAyLzIwMjUgMTQ6MjAsIERvbmV0IFRvbSB3cm90ZToNCj4gSWYgYW55IG9uZSBv
ZiBCVFQsIFBGTiwgb3IgREFYIGlzIG5vdCBwcmVzZW50LCBidXQgdGhlIG90aGVyIHR3bw0KPiBh
cmUsIHRoZW4gdGhlIHJlZ2lvbiBjYXBhYmlsaXRpZXMgYXJlIG5vdCBkaXNwbGF5ZWQgaW4gdGhl
DQo+IG5kY3RsIGxpc3QgLVIgLUMgY29tbWFuZC4NCj4gDQo+IFRoaXMgaXMgYmVjYXVzZSB1dGls
X3JlZ2lvbl9jYXBhYmlsaXRpZXNfdG9fanNvbigpIHJldHVybnMgTlVMTA0KPiBpZiBhbnkgb25l
IG9mIEJUVCwgUEZOLCBvciBEQVggaXMgbm90IHByZXNlbnQuDQo+IA0KPiBJbiB0aGlzIHBhdGNo
LCB3ZSBoYXZlIGNoYW5nZWQgdGhlIGxvZ2ljIHRvIGRpc3BsYXkgYWxsIHRoZSByZWdpb24NCj4g
Y2FwYWJpbGl0aWVzIHRoYXQgYXJlIHByZXNlbnQuDQo+IA0KPiBUZXN0IFJlc3VsdHMgd2l0aCBD
T05GSUdfQlRUIGRpc2FibGVkDQo+ID09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT0NCj4gV2l0aG91dCB0aGlzIHBhdGNoDQo+IC0tLS0tLS0tLS0tLS0tLS0tLQ0KPiAgICMgLi9u
ZGN0bCBsaXN0IC1SIC1DDQo+ICAgWw0KPiAgICB7DQo+ICAgICAgImRldiI6InJlZ2lvbjEiLA0K
PiAgICAgICJzaXplIjoxMjg4NDkwMTg4OCwNCj4gICAgICAiYWxpZ24iOjE2Nzc3MjE2LA0KPiAg
ICAgICJhdmFpbGFibGVfc2l6ZSI6MTEyNTc1MTE5MzYsDQo+ICAgICAgIm1heF9hdmFpbGFibGVf
ZXh0ZW50Ijo5NjMwMTIxOTg0LA0KPiAgICAgICJ0eXBlIjoicG1lbSIsDQo+ICAgICAgImlzZXRf
aWQiOjE0NzQ4MzY2OTE4NTE0MDYxNTgyLA0KPiAgICAgICJwZXJzaXN0ZW5jZV9kb21haW4iOiJ1
bmtub3duIg0KPiAgICB9LA0KPiANCj4gV2l0aCB0aGlzIHBhdGNoDQo+IC0tLS0tLS0tLS0tLS0t
LQ0KPiAgICMgLi9uZGN0bCBsaXN0IC1SIC1DDQo+ICAgWw0KPiAgICB7DQo+ICAgICAgImRldiI6
InJlZ2lvbjEiLA0KPiAgICAgICJzaXplIjoxMjg4NDkwMTg4OCwNCj4gICAgICAiYWxpZ24iOjE2
Nzc3MjE2LA0KPiAgICAgICJhdmFpbGFibGVfc2l6ZSI6MTEyNTc1MTE5MzYsDQo+ICAgICAgIm1h
eF9hdmFpbGFibGVfZXh0ZW50Ijo5NjMwMTIxOTg0LA0KPiAgICAgICJ0eXBlIjoicG1lbSIsDQo+
ICAgICAgImlzZXRfaWQiOjE0NzQ4MzY2OTE4NTE0MDYxNTgyLA0KPiAgICAgICJjYXBhYmlsaXRp
ZXMiOlsNCj4gICAgICAgIHsNCj4gICAgICAgICAgIm1vZGUiOiJmc2RheCIsDQo+ICAgICAgICAg
ICJhbGlnbm1lbnRzIjpbDQo+ICAgICAgICAgICAgNjU1MzYsDQo+ICAgICAgICAgICAgMjA5NzE1
MiwNCj4gICAgICAgICAgICAxMDczNzQxODI0DQo+ICAgICAgICAgIF0NCj4gICAgICAgIH0sDQo+
ICAgICAgICB7DQo+ICAgICAgICAgICJtb2RlIjoiZGV2ZGF4IiwNCj4gICAgICAgICAgImFsaWdu
bWVudHMiOlsNCj4gICAgICAgICAgICA2NTUzNiwNCj4gICAgICAgICAgICAyMDk3MTUyLA0KPiAg
ICAgICAgICAgIDEwNzM3NDE4MjQNCj4gICAgICAgICAgXQ0KPiAgICAgICAgfQ0KPiAgICAgIF0s
DQo+ICAgICAgInBlcnNpc3RlbmNlX2RvbWFpbiI6InVua25vd24iDQo+ICAgIH0sDQo+IA0KPiB2
MSAtPiB2MjoNCj4gQWRkcmVzc2VkIHRoZSByZXZpZXcgY29tbWVudHMgZnJvbSBKZWZmIGFuZCBB
bGlzb24uDQo+IA0KPiB2MToNCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzIwMjUwMjE5
MDk0MDQ5LjUxNTYtMS1kb25ldHRvbUBsaW51eC5pYm0uY29tLw0KPiANCj4gRml4ZXM6IDk2NWZh
MDJlMzcyZiAoInV0aWw6IERpc3RyaWJ1dGUgJ2ZpbHRlcicgYW5kICdqc29uJyBoZWxwZXJzIHRv
IHBlci10b29sIG9iamVjdHMiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBEb25ldCBUb20gPGRvbmV0dG9t
QGxpbnV4LnZuZXQuaWJtLmNvbT4NCg0KDQpSZXZpZXdlZC1ieTogTGkgWmhpamlhbiA8bGl6aGlq
aWFuQGZ1aml0c3UuY29tPg0KVGVzdGVkLWJ5OiBMaSBaaGlqaWFuIDxsaXpoaWppYW5AZnVqaXRz
dS5jb20+DQoNCg0KPiAtLS0NCj4gICBuZGN0bC9qc29uLmMgfCAyICstDQo+ICAgMSBmaWxlIGNo
YW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEv
bmRjdGwvanNvbi5jIGIvbmRjdGwvanNvbi5jDQo+IGluZGV4IDIzYmFkN2YuLjc2NDY4ODIgMTAw
NjQ0DQo+IC0tLSBhL25kY3RsL2pzb24uYw0KPiArKysgYi9uZGN0bC9qc29uLmMNCj4gQEAgLTM4
MSw3ICszODEsNyBAQCBzdHJ1Y3QganNvbl9vYmplY3QgKnV0aWxfcmVnaW9uX2NhcGFiaWxpdGll
c190b19qc29uKHN0cnVjdCBuZGN0bF9yZWdpb24gKnJlZ2lvbg0KPiAgIAlzdHJ1Y3QgbmRjdGxf
cGZuICpwZm4gPSBuZGN0bF9yZWdpb25fZ2V0X3Bmbl9zZWVkKHJlZ2lvbik7DQo+ICAgCXN0cnVj
dCBuZGN0bF9kYXggKmRheCA9IG5kY3RsX3JlZ2lvbl9nZXRfZGF4X3NlZWQocmVnaW9uKTsNCj4g
ICANCj4gLQlpZiAoIWJ0dCB8fCAhcGZuIHx8ICFkYXgpDQo+ICsJaWYgKCFidHQgJiYgIXBmbiAm
JiAhZGF4KQ0KPiAgIAkJcmV0dXJuIE5VTEw7DQo+ICAgDQo+ICAgCWpjYXBzID0ganNvbl9vYmpl
Y3RfbmV3X2FycmF5KCk7
