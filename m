Received: from esa15.fujitsucc.c3s2.iphmx.com (esa15.fujitsucc.c3s2.iphmx.com [68.232.156.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C191614A4E2
	for <nvdimm@lists.linux.dev>; Mon, 19 Aug 2024 06:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.156.107
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724047520; cv=fail; b=An3EkqFbGvH1bDsVlcdKHkBiXaTmfqC6LGo4K2WOs1SKXzfkajfXtGlUiYHdPhl5PS99kF8aG/qTSZQx2pkynE5P25yk/fjmPzHjk7N/Wj5ZqHwTnQtoBwredGMuCSTRmZFbnqUd+W+HITAqMDI1Xa8xd20GSIXMbMYsE1qdaaw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724047520; c=relaxed/simple;
	bh=SerTpHLLZdaZ61+lRIpZ94EAsJ6ZJu+/J5DuNKiOhjY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iuP0+d7Eb8x5zrSiRX/hXxj+0a4kysKgXVIEy6hUL8YbyVBPS4sDIf7gJ3bxVdXSoVCVpQLwOfqMyLpPUGb7cRaltcC9p6vgOYxomdH3C0++v8P71GJ9PzEp7oVvPKhh/4du9KxETJ7syLMpg0f5HPK1e4wLMjAhUw+LdZTV/Uc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=Y94B4Cel; arc=fail smtp.client-ip=68.232.156.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="Y94B4Cel"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1724047518; x=1755583518;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=SerTpHLLZdaZ61+lRIpZ94EAsJ6ZJu+/J5DuNKiOhjY=;
  b=Y94B4CelZTk9xiRW9d16WwTTKZgJjgmucoicd6L+0yCARyAScCrrR9AN
   V59up11vyDNOeOtB1ITEcal0C01rxa06jAkp0sbDIWK1brvaIsw2tduPy
   z4oijyp2g8C1+M/me9VLVFclb5jx4KgS8aYE1NfVcKyxPIiRvRQ7sqmrY
   nRT6YWFZFY/xotVFxB4IUYkrvNqcLAMusBmBuIDCdLMR0IgtI9gpZ96kI
   FBWWN94WzHnDToWt9p9x6+vJ/470jogPGVGujArT8B/VxbBRQI5sCpqTT
   ECwEr+M0euBmlBMhQ3inWhMPiOP8QzukFoccZ55J2tSaUOMeP3gSyyqCW
   A==;
X-CSE-ConnectionGUID: 9tV3lUwaSK6toCTD7m3N0g==
X-CSE-MsgGUID: LMjr4JsBTZSHms0yGMSWSA==
X-IronPort-AV: E=McAfee;i="6700,10204,11168"; a="128659134"
X-IronPort-AV: E=Sophos;i="6.10,158,1719846000"; 
   d="scan'208";a="128659134"
Received: from mail-japaneastazlp17011028.outbound.protection.outlook.com (HELO TYVP286CU001.outbound.protection.outlook.com) ([40.93.73.28])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2024 15:04:06 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=odckHILnYiLnt/ppenkayXH9S1JZT55ws5TdEZGmFF02+hDmd3pAs21FSJkkwU254ft7hTHlyD6I6TLHOvgCC50khkNiEARQfwKTPx2Fg5vNJwxbpnWP/+DqCw4vvFR7JpHFEQd5rebD+jwYDu9muxJ3asCYUFuNV6f5EtQCgBZ+CWDS/BoAIr4s/ijqW4wdfvwE77QlQlstYaHTjAZ4A4nFX0+UtyXm87threGgsvQx848XmPEnC+dspMXTKoAA4Z/lxyvJ+F12zQ0hc/jg6S6Pw8X0qLVSzTQZkKVO0CrkEwvF+pRd80ARdACZ6cMuOtTThCBuXz7zoMzWrnP2og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SerTpHLLZdaZ61+lRIpZ94EAsJ6ZJu+/J5DuNKiOhjY=;
 b=BW819WqP821CT3Pw92de56um7Z8fJcC8nWPqOjcynORchPuC78esMiobJwbtwDcmbOeDtbAloBNnqVRhQUZhz+mlM51TqxxuH/WDkafU77bbvz04vBDTzfvqK97WRI/CDUL9GOUdtZ97DpNPgELnw6nOcMHb/hkNPcnHjoENYeF8HChyyocVa/hpspUTZubI0QtLk2T5ojc6XUypevAQtygOCbHHiBteeMeBIVDGqSSOojD4YQAjjD4HcGzWHIm9SSQfhN0awpPc2a110lO9ZIMz0jYS1tISFhIiwt4EdnjuwU/RCaYbIabdhsPek2t1zmjWpjNO/6rTleh2oAaRjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from TY1PR01MB1562.jpnprd01.prod.outlook.com (2603:1096:403:6::12)
 by TYYPR01MB13317.jpnprd01.prod.outlook.com (2603:1096:405:164::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21; Mon, 19 Aug
 2024 06:04:03 +0000
Received: from TY1PR01MB1562.jpnprd01.prod.outlook.com
 ([fe80::d9ba:425a:7044:6377]) by TY1PR01MB1562.jpnprd01.prod.outlook.com
 ([fe80::d9ba:425a:7044:6377%3]) with mapi id 15.20.7875.019; Mon, 19 Aug 2024
 06:04:02 +0000
From: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>
To: Dan Williams <dan.j.williams@intel.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
CC: "vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
	"dave.jiang@intel.com" <dave.jiang@intel.com>, "ira.weiny@intel.com"
	<ira.weiny@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] nvdimm: Fix devs leaks in scan_labels()
Thread-Topic: [PATCH v2 1/2] nvdimm: Fix devs leaks in scan_labels()
Thread-Index: AQHa2X8zwa9xxtG/iUCzPF4J7ymSb7IfpsOAgAAEvACADpyvgA==
Date: Mon, 19 Aug 2024 06:04:02 +0000
Message-ID: <342511df-d321-4a77-b76a-77f3844d7fa3@fujitsu.com>
References: <20240719015836.1060677-1-lizhijian@fujitsu.com>
 <66b69a6fc5710_257529458@dwillia2-xfh.jf.intel.com.notmuch>
 <66b69e681ea7a_25752943c@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <66b69e681ea7a_25752943c@dwillia2-xfh.jf.intel.com.notmuch>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY1PR01MB1562:EE_|TYYPR01MB13317:EE_
x-ms-office365-filtering-correlation-id: d68b50f5-81ae-4676-5d41-08dcc014b9d0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|38070700018|1580799027;
x-microsoft-antispam-message-info:
 =?utf-8?B?MXl3L24ra1Zvd3JtTUMxWWt5YnVVOE9zVTd6dWNCVnRxSkcxQ2NkcVc0czkz?=
 =?utf-8?B?WTNQckZiY294ZjN3Y2EwYUR2MjJCL2U2eUtnMCtXdENFYTRFZmdyaWFkYTdC?=
 =?utf-8?B?NlYzTno4MFRBeGRxUTdsNEdaSjhFcUlSZUtMZ2NhaDVCZ0NzM0xnU2wzSFdq?=
 =?utf-8?B?RVg0ODdhSlAweDgzeURnMU9md2dLSTRiWnFUdnEzNFdPTjJHUWJOUUxFK3F1?=
 =?utf-8?B?eUcreWRJckNMUzA0aEhLSVhESzBJajJnMlY1MFNEdHdVT3hiN3F3WGFzbVky?=
 =?utf-8?B?ak9qVjRweWY1L0hERnRkcXVMd05nbWJaQTdzeGkraTBzUGg0YjUzWk5Mb1VF?=
 =?utf-8?B?TWc0WGRBSEFIZlBoRFdHaEdleFJFVUo4QWJuc3hwemdpT1RYR1czS1dZQjdO?=
 =?utf-8?B?MEdKbW9JWDU0SlR6OHU5MExKbXZWc0hJU2ZXZytMVkI3YzZGcS8xOU1MOWNN?=
 =?utf-8?B?a2kreUVvTGlkVEpqSUtzQjdUWk0xeVZnWXV6aVcxb0RtcEwvQ0w0YUU2aG5K?=
 =?utf-8?B?VXI1d1UxZlRsT3ZoTmIyZ2lUYmtNZUd4TVdBU2diWE1QYXFjWjQ1N3IzVGs2?=
 =?utf-8?B?UFNKeTNvem1NQ0dYdERQdDRzZ1ZuZTZRMXpVbG9tN1J2R2d3NkgvUXl1VEpD?=
 =?utf-8?B?NG9PVlJnS3RWTlJyS2oxVVNrVlVNR3RxWTgrVVVLY2NsTE5GYmFZeDJIbWJU?=
 =?utf-8?B?d1AzQlVOZDdPd0JEVkhPSTlkbC9VZXo5anBWMHZuaWI5NmkycTdSYm9odUVN?=
 =?utf-8?B?ZmQvRFBuSTdvZWZjMTBnL2FsckdudE5ZMTdMMkFnVktGOWhDakJWL1dLQ0dN?=
 =?utf-8?B?S3AzTTkvQVUrd01YbVpMMk5mbGJuNFpzcFVoajhtbmNFNERXZVRSVWFaZ1RY?=
 =?utf-8?B?V3dYUnd0WUhSQTd4dVpERTFwaitqalpHRGJydnB2U0w3NWFzeTdqUFkyL1Q1?=
 =?utf-8?B?N1VRNnFlT2FTQnMzR0ptcXFVVzFtOExpSEJCNjNEK3lTbncyVlJGb0duOUt3?=
 =?utf-8?B?aVFSYmozSzIrNEFMbFIvbTFTWEVTNWVXSlp5cjFkNHc0TGdwVzVlWmxtbDRO?=
 =?utf-8?B?a0cwUEh0ckw0UzRnUW1iODNwd1pObHlTMGR1dmNEMDhuZWRmYjlJNjdTVlF0?=
 =?utf-8?B?N1ZZTGlwWjlmeGNqN3pYUVNvd2FOWmRDaFVWTllCbldhTWRHQ0pNazRQU0pY?=
 =?utf-8?B?ODVhTGZwVUk5QVJoQUl4cEd3YndCb1BTMDNJZU9XRS9SbCtML3QzMmN5VXNl?=
 =?utf-8?B?amdHOUxaVTRJV2xCOEFRbURRZzBQdXFqWGlNN2xRY2F0VUhmZFcxUllYMlA2?=
 =?utf-8?B?UFhkSmtOZDh2c0JkTGNEWTF6YkREU1R3RWEwMndSR3lOVEduUGlZYWtiZmhv?=
 =?utf-8?B?cW1VOU01RkNLT0pubnovWXNTSFM3U2prLzIzZkgyN01jTm45UGIyKzJaVjVF?=
 =?utf-8?B?THR3Z3pUeWZvTHdNRjVqYUd3L2xMdmhHZ2U4ZkJMWXdkWlN6OWMyUzFON0Rk?=
 =?utf-8?B?RWJ2UkVFZEc2VEo2ZHlqejlOYTExT2JVTFFnZk84TFd0RUE1WFpNTy9lVVJt?=
 =?utf-8?B?RkhFRFArS29jTUgwdGk0QnZMdkRQQlJyZDBuMjRnb2Uwdm13YXdaVldoamJF?=
 =?utf-8?B?eFEzUmlFaEdHbVF3ZGc2NXpLQzJxK1Y4WGg3WCtzd2YzWGVndms1cVNWRE9y?=
 =?utf-8?B?aFRzczVNUlUwd09LWmxrS2gzOU9vdWQ1a25TYTMzdjVGYlc2YThRR0M5Q2Uv?=
 =?utf-8?B?OUhiVlFWVitHQzg3TU9wOUN0VG5nd21tYXQ4ZGVOMUxJMkwrWWYzdmZvaWEw?=
 =?utf-8?B?MFZJdTNFR0NTbmhBRENHZHRYbldOM0ZCSzJ6SEtXbC9XSnFNLy9EQ3NSbEd2?=
 =?utf-8?B?VWFyK3VBMHR5SUNmdnJJU1kyKzYvVjZiSHRhT091UEs0Znd6ajF2TWVIRU5q?=
 =?utf-8?Q?s1wRQ0L6B0Y=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY1PR01MB1562.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018)(1580799027);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?UFB0U3V5eVlKbGh6OUxkaFdzWlBndU1FdlUvMTJua2E4RXhOYzF6TWhaOHdr?=
 =?utf-8?B?TFAvTDBiNkR5WGNOeHRWYWtWVG16bXBBcjFDditxbTlSR3pqSXBxZlIwRFpn?=
 =?utf-8?B?RnZEVVI5NlkxR0V2c1NBcmtqQklRaEV1SmtiK3ZCUFRrYjhFSjBhdDdzemZJ?=
 =?utf-8?B?a2V0SFQ0c09obHU5WDhhemtUVngzK1I3TVgwY0s3bThIdjQ1ODBNdk1Od3dJ?=
 =?utf-8?B?Y1hBVlhTSko0d1dWUy9FbzZ5VXljbzZkRjhmWlBLVnBxK1JrYjZPbDNvbXBG?=
 =?utf-8?B?dUhSdXdpSmNVbDkvRU9vRmlpWk1uRlVXVXM2RjBQc0hJZFQ3Y0V4L3cwV0sr?=
 =?utf-8?B?ZkZkeFJ1Q3paNlplcWJIR2pvUko5RFhRam1qTXV3a3ovZTR1Y1drYmlpTTZn?=
 =?utf-8?B?Uy9sWUtQQXZOTGNURUxuR0ZrTlR0STkzVTAweHRjR0NNNHRycStUV3NuUStv?=
 =?utf-8?B?YUJqNUNLcEtQZWxzRG9INGU1bFEzaU53RHVnekVUS3ZUL1c5dGdDR3Z4SExk?=
 =?utf-8?B?aGV6Q09FSUZGczFLMzBsTkkxTlk3MVdMYUFPcG42bEx2NmszTHVxcVdZNnZl?=
 =?utf-8?B?WGpqdmVIY1ZTNG5sZmlSV3dVM1BSR0hkZEhNZ2lQOUNhT1k4MDNhU0NVL2sw?=
 =?utf-8?B?YXJkNHg4aWlQbW11aDd0NlM2cjdMRUphOVdjVm50K083MTVRWkVRSFQwSVd5?=
 =?utf-8?B?Q2l5RnNaNExucjRJUHJ6RzMyK3FGUzRwaTJrK2JyTFpLLzlESUdhT1QrdlZi?=
 =?utf-8?B?dXRsUjhVVjhWbktrMzJCRlltd1Uvc29DYkRSQlg2RnlRTDN5aE16emNEdlBO?=
 =?utf-8?B?aTJpZnEyOXJhUG1QUDFueWVDMEhTRzJWNGhSL2lCRXlmYlRNRjEzTGxZTkU3?=
 =?utf-8?B?N1IxcmF6RDVLZ1MrZ0tSTXRacEpCSmFuSk9EQS96OUlGOHEycW1vTHowRHl1?=
 =?utf-8?B?N1ZYMFJHdlZwUjBGQ0Z3L0FTVGppZktpbklnc0l0N1QzK1JzdGxUWnIyWUVV?=
 =?utf-8?B?enhBbUwxMlN1am5ZWUF0YU4wd2VZM3Q4bTljcklEbERxbDdCQnR6cjFzQ2gy?=
 =?utf-8?B?cjRMZEhUa1o4cjdOc2pJb0VyaFFGVTdvaUFrOWFkZ3lWZ1AxcExXNzFKdE9a?=
 =?utf-8?B?QkhieGFPWGdJMWpva0lUeG02eGNvczJyY1d3ckNmTGYrN3RxOG80TVdtSXd2?=
 =?utf-8?B?V1lDajhXS0JhN054aUVjQUlENXV6MGY4R2tsUnljZElZYlA5RjFGMXhmRjZO?=
 =?utf-8?B?UFFSTXoram1MOEVQN0xydWNCaW9qTHg0NHpiYm5YNW9FK0RRS3YwWVlsb0xL?=
 =?utf-8?B?R0dsdUlSbnAxMDJ2Y2lwUE8rRkhvV1B6WXhlc0NqSGRLczJGRFFrcXlEcUxH?=
 =?utf-8?B?aVFGMGh1Uml5b3Q0YmpZSnJYVFpsUGdHRVZJNjA1aC9JUCtaUjJISWZuQXgr?=
 =?utf-8?B?Q2Y2YVppYUoxV2lmbWpnSzV1Q2p4UEZPTFhFMXZuY3c1RHlhanhULzBRYnp2?=
 =?utf-8?B?ME1oWmdEWEU1WHNLclNVRk5SVy9jRkQydWtWM1pabmwvR2t0RXM4bU9ydngw?=
 =?utf-8?B?WS80NmVoYUFIY0tXcng3dzRnT3RrMFY4d3hySGdlZ0U1YThxY21oQ2hvUEpu?=
 =?utf-8?B?SklQVmY1VnM0dWY3bTBaNzRGNWdVRDFSbE5sMFN0VjVPKzFrbEFWNmtRTVVM?=
 =?utf-8?B?Vys5SnZGNlRHTWVhQ3JPU3lGWUt0akx4Wlg1TmFvcklJdFlwWXpVclBUZ0Nw?=
 =?utf-8?B?VFZBRkpRbjBWTTFXcXd6enBRbll5TUpMRmgyeEhTL3U0L0JpNmVxYlJnQm1I?=
 =?utf-8?B?VGZBY0RxQzROdjdPQjNSQnNCQnFEdDJjMHR0TTBxcFB2b05pL3ByNDFRdXMz?=
 =?utf-8?B?SkFQbFRrVmIwNlZQYUxkME9YQmg0SHZzZHFzaGRYb01UWDNBUi9lWmVTeko0?=
 =?utf-8?B?VytDZ0ZwRkdjYWlRS2tRbE9NUjcxTngzYmZoZXVDaHBJeWR4YldCaDlISmwx?=
 =?utf-8?B?ZE5GdTdKZGNJMmV6RXBCb2VGSUM1ZDV6N2RjL1RlWlBsdnpWaVF3ZjVRa1Qw?=
 =?utf-8?B?UXJoaVdtcFJsWXAySUpSM0VxUklHTU9PUWxYRUh6cUsyYU5TY3pqcjRGNHhx?=
 =?utf-8?B?WmdvZHhHRWRxVit3U21Kc1BQMlNqSFd5RStHQjBRa1c2Qk5JdGpxR1R6Mnkx?=
 =?utf-8?B?U1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EE48EE3E95AEE94780883525ED867A82@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vAAbTXhUitvRTO9VI5k5YRiHoA1s2NCt4eRqX2hCWuq4huvGmIm/h2MuKKw/aUywpHIVR2xBc8bq8bOQwCV+rwzFdmPGwOC+DjOlpQChchhxn1k5Qtppy0WlW/NKiXmteoniY2pgmqX6uE76O3F+U8Y30Uw9af1ZXbfdUWju5km3QSN8fpsys7JRFMHDRQ7WFa6xfTPKBHcKVowsXCC2PVfUCYPJQsyKIn3GLKEg+qh5+OKpjsuOhxqygdRPJU4A+ClhP3GWHtyFs955wWvW7fGMmRhx7k0sAJTJiRe8PE3BIDGgP24VDwQxAJhKVe13DDC5a4SkNFsj/Iv9VKNbAydvmuApHV7gKqB8Qlbx5a5RvcoZJVZ5q7FHPTCSauS45xnIU8MBs/dQP+C+uG/etyB4mJp5ay07+lanI0zniRGXXHtDQsKbRdbO8QM/goB3BHsHWt5fXqB0XWpYxPcsIxQBEWOrj243CkhcVT+r6sLoF05V4NRlZMt/ScZ8rvelF+osxn24w78bUHA9zUhMC9oGdC4jI2MYI0MUgOeO+rktVJx4q/eZP1Fnf6+ZQ+FCBtE8TeGjqBdc49oFlmyre9J2IaBGE8ptxTyJ00f7Szc6bMda1tR7jSqlkuQnEU7z
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY1PR01MB1562.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d68b50f5-81ae-4676-5d41-08dcc014b9d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2024 06:04:02.8609
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d/PB34zPNSlKG/qWOalRVwqwIHQX8mN9MtWw3uGBOZNiovWJ5zKtiLs1nh5t1Qi1duk9Awad5RjAU4eTgFqaPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYYPR01MB13317

DQoNCk9uIDEwLzA4LzIwMjQgMDY6NTUsIERhbiBXaWxsaWFtcyB3cm90ZToNCj4gRGFuIFdpbGxp
YW1zIHdyb3RlOg0KPiBbLi5dDQo+PiBAQCAtMjAzNiwxMiArMjAzOCwxMCBAQCBzdGF0aWMgc3Ry
dWN0IGRldmljZSAqKnNjYW5fbGFiZWxzKHN0cnVjdCBuZF9yZWdpb24gKm5kX3JlZ2lvbikNCj4g
DQo+IC4uLm9mIGNvdXJzZSB5b3Ugd291bGQgYWxzbyBuZWVkIHNvbWV0aGluZyBsaWtlOg0KPiAN
Cj4gaWYgKCFjb3VudCkgew0KPiAJa2ZyZWUoZGV2cyk7DQo+IAlyZXR1cm4gTlVMTDsNCj4gfQ0K
DQpJdCBzZWVtcyB3ZSBkb24ndCBuZWVkIHRoaXMgY2xlYW51cCwgaW4gdGhlIGNvdW50PTAgY2Fz
ZSwgd2Ugd291bGQgcmVhY2ggYGVycmAgdG8gZnJlZSBkZXZzLg0KDQpUaGFua3MNClpoaWppYW4N
Cg0KDQo+IA0KPiAuLi5oZXJlLCBJJ2xsIGxlYXZlIHRoYXQgdG8geW91IHRvIGZpeCB1cCBhbmQg
dGVzdC4NCj4gDQo+PiAgICAgICAgICByZXR1cm4gZGV2czsNCj4+ICAgDQo+PiAgICBlcnI6DQo+
PiAtICAgICAgIGlmIChkZXZzKSB7DQo+PiAtICAgICAgICAgICAgICAgZm9yIChpID0gMDsgZGV2
c1tpXTsgaSsrKQ0KPj4gLSAgICAgICAgICAgICAgICAgICAgICAgbmFtZXNwYWNlX3BtZW1fcmVs
ZWFzZShkZXZzW2ldKTsNCj4+IC0gICAgICAgICAgICAgICBrZnJlZShkZXZzKTsNCj4+IC0gICAg
ICAgfQ0KPj4gLSAgICAgICByZXR1cm4gTlVMTDsNCj4+ICsgICAgICAgIGZvciAoaSA9IDA7IGRl
dnNbaV07IGkrKykNCj4+ICsgICAgICAgICAgICAgICAgbmFtZXNwYWNlX3BtZW1fcmVsZWFzZShk
ZXZzW2ldKTsNCj4+ICsgICAgICAgIGtmcmVlKGRldnMpOw0KPj4gKyAgICAgICAgcmV0dXJuIE5V
TEw7DQo+PiAgIH0NCj4+ICAg
