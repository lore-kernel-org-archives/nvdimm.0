Received: from esa7.fujitsucc.c3s2.iphmx.com (esa7.fujitsucc.c3s2.iphmx.com [68.232.159.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E1C0184F
	for <nvdimm@lists.linux.dev>; Mon,  8 Jul 2024 02:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.159.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720405587; cv=fail; b=Bw15Qy4bNLJewUJT08u2WFrRWr3Wnb68gArrAOMwwLTzuIe6V+IGxn8V0Fz7GDREUqWqL13h5p0otk7fNDV4+UbKx2dgVbcQhcidEawFUVGx8VCRGwQWljNOESi9nquYoK8PLOHG1jXkpZhYHC28awsGbJsQp0UPMLVCWTK3EQo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720405587; c=relaxed/simple;
	bh=PKINuHg1qCIHGZ7Fg6mZ39fQWUZaPyced1E7qUnzWrU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eKA6wW46nbBZvUuyjZyulOkYW1z4pYMnpGq9MauZw8d7E9KJiSz/HUU50RJ7gbiNOF7etL6pKnrF6cs696XKOTYm1jDyhMuOTBkGYfM01LDMIHDXMoFbSlIDCkoGsf622Nfbyq0gAVhR0zZtCkIhsTwhfHusDdsOmUb6LrSA5iU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=qnvjCahm; arc=fail smtp.client-ip=68.232.159.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="qnvjCahm"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1720405584; x=1751941584;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PKINuHg1qCIHGZ7Fg6mZ39fQWUZaPyced1E7qUnzWrU=;
  b=qnvjCahmdwpkDzyaiJv8a9KuRSKojom2nISFG7KdgI5gEyQ6CLsiu1hB
   g0qStLybaKN2IzylxRbEbh1cCKd8AqMSp8+W4hCrYopSY8Yp3jo4iNhMU
   WcUPq4F94qqKtbU2SuG450V4mY0x98Us155+Jqx61NBmPEljoYxDwRT/U
   RS15bB7E9q9gq9K9KAZuRImg2kTO6R1jI+mysq1l8K0PtvlJxmLhrGRWE
   rFFhLg7Y4IcgXawo2NbrCmYEBj53aPktQIQmrGZM99tB8YMxZgug6C1XM
   ZdPM0OesJH87O+yps4LUnwxrAHwchecriHUStvs+7CMU5xJJdYTVx3d/m
   g==;
X-IronPort-AV: E=McAfee;i="6700,10204,11126"; a="124445090"
X-IronPort-AV: E=Sophos;i="6.09,191,1716217200"; 
   d="scan'208";a="124445090"
Received: from mail-japaneastazlp17011026.outbound.protection.outlook.com (HELO TYVP286CU001.outbound.protection.outlook.com) ([40.93.73.26])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2024 11:26:15 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RlSUtza9+HouImVzQb0c2f2ETM+9oGjtMEtM+Ngu6nuf0j9micZNbqmaQdoKXk4ubBPMBWkWud6q856+qVUejICvNQfOrNdyoml5il3tBzy5MAP9F2jMGmZHYEskvL+xXkzvLldkAP3YKjRhoUyaR1a1B2HHZeeHHqk2/SVwFLYmIM+aOEm3a855vyeQbyATcyBGXerYFfulmjQ0/W+RnaGflzFOk5oZ4IcMTa6Q3Ep967eY66JoFxB8JEKSakiT5AbFiee+nriMsTXAqbgzxj8/1qONce6mIs83kZ8TUY3YvT7aVHv6QGHFItxffUl924aJl/ExZiJO4uNj6TTpwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CYq42ueqDPGOO7Az9rkEdXZIK7dmLuwBnNnzDWIkbPQ=;
 b=NUiv2RCoLr6yGAD++ViR5z1z7PiRh02Msx/x6jOYchq0+L8fTL8ikwzGJ0OGqJYj+9v/WszH44+Plc0iV/hT1tVIDbT36eFQUMmlktkVo5KUcTnYvOtkmrFLLw+nhUYiacjQrDM+pj84ACWh/HVNm0375Kc1CamRgQgjXOBXjC1e3pMAv+lMp0/pai57I2DVzyB6MLRQ8ughpke3xUy1Agz/4lVKboCWOIELIzhP8oSHAKcH/JmQxa4aDrU6UeY3HoXu/vOU05vtTu1fuSg5lpEES8KoDIhkqg/c0xCe3AHJevrPyaLbMCCzaYpefKNcv9Xaz7NvlLcPD4DprPdfNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from OSZPR01MB6453.jpnprd01.prod.outlook.com (2603:1096:604:ed::14)
 by TYCPR01MB5997.jpnprd01.prod.outlook.com (2603:1096:400:48::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.30; Mon, 8 Jul
 2024 02:26:12 +0000
Received: from OSZPR01MB6453.jpnprd01.prod.outlook.com
 ([fe80::9ef5:e83:9047:de11]) by OSZPR01MB6453.jpnprd01.prod.outlook.com
 ([fe80::9ef5:e83:9047:de11%4]) with mapi id 15.20.7741.033; Mon, 8 Jul 2024
 02:26:12 +0000
From: "Xingtao Yao (Fujitsu)" <yaoxt.fnst@fujitsu.com>
To: "alison.schofield@intel.com" <alison.schofield@intel.com>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
CC: Dave Jiang <dave.jiang@intel.com>
Subject: RE: [ndctl PATCH v13 7/8] cxl/list: add --media-errors option to cxl
 list
Thread-Topic: [ndctl PATCH v13 7/8] cxl/list: add --media-errors option to cxl
 list
Thread-Index: AQHaz21Vqz5Ht1WaJ06Oyx7XXVIxwrHsGaFw
Date: Mon, 8 Jul 2024 02:26:11 +0000
Message-ID:
 <OSZPR01MB6453378E193594694EFD71BD8DDA2@OSZPR01MB6453.jpnprd01.prod.outlook.com>
References: <cover.1720241079.git.alison.schofield@intel.com>
 <76eb7636d1aab2fecd60d18617828d004adb58d9.1720241079.git.alison.schofield@intel.com>
In-Reply-To:
 <76eb7636d1aab2fecd60d18617828d004adb58d9.1720241079.git.alison.schofield@intel.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_ActionId=b45a622c-383d-496e-984c-8854b6dfa1ab;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_ContentBits=0;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Enabled=true;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Method=Privileged;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Name=FUJITSU-PUBLIC?;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_SetDate=2024-07-08T02:12:17Z;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_SiteId=a19f121d-81e1-4858-a9d8-736e267fd4c7;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OSZPR01MB6453:EE_|TYCPR01MB5997:EE_
x-ms-office365-filtering-correlation-id: 84e9be24-12f0-4cb5-e9fa-08dc9ef5559f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|366016|1580799027|38070700018;
x-microsoft-antispam-message-info:
 =?iso-2022-jp?B?RHROM3dHMlNKWHpnZHVPK2F3dzA2Q1JoT0ZkYjlYRXY0SlVWbmZlL09B?=
 =?iso-2022-jp?B?ZEppeFZLV0lYdmI0d3RJaFhQejV6KzY4NytjRVNFbWIyYWJTWElKdnk3?=
 =?iso-2022-jp?B?eWFQK2xCYldRUGJQRG9QTHBSQXVydy9kSFpFOVp0RlNIaTNTblpjY3c0?=
 =?iso-2022-jp?B?Z2xoaGxuUk1XcXluaDQrWW9PTWZXQUt2QmtvSDVzNnpKV05iVlRaOGhv?=
 =?iso-2022-jp?B?R3pXUDMvdDdaUGVEMWxlS1FuTndpSEJHeG9Zd1B0Z0dFaGxVOGJVMFZj?=
 =?iso-2022-jp?B?TlVNK00vZ3ltQ0Iza2RtWmFoREJ2blZEODdyUi83NHBuRlhVUlY5YXNO?=
 =?iso-2022-jp?B?UWVBMnBKeU5MWGdpdWRZYS9LMU9pMGxpY0k0elAzY1UrQS9qcnJZa1Fw?=
 =?iso-2022-jp?B?dzNacEh2eFNOYnVjc2VsNVkyaWtQdmhXTHovU0hUVFhXb3ZhM3R4QlFr?=
 =?iso-2022-jp?B?OUF0TUFHQUdlbTQ1YlhyRGYyVzdFelh0Q1JJNWlVdFg5cUhHcExkaTVO?=
 =?iso-2022-jp?B?MFZUOXFIdFdDa3g0UGJUL0piY1Q4TWkxMW5ibE1PTEtrem9Mb2FDbkF5?=
 =?iso-2022-jp?B?YWYvSHpFeTRUMm4yUHZMREs3WU1LWmV5UkZMN0I4eUJRVHZCS2lpeElR?=
 =?iso-2022-jp?B?UWRvWTRxZkFsa25ObVJJWDZMSmhUWnBxWjlZWmFISk5aTXM5S09oZmNX?=
 =?iso-2022-jp?B?Q1dPTEE3RXpYN01UNFRxby8rUjUxbnNZSFVkWEtJUUk3Q2crbzBFMnF2?=
 =?iso-2022-jp?B?YUxPV1Rsc2NsaFVuV2NLWWl5S3h5eENLeU9wZ3djaXJIQWhhWnlDNllj?=
 =?iso-2022-jp?B?cjlnb2xkN01Kc1AwTmJOd0lwMGJaMnNZb1ROVDVFRWFZdFVPNkhxVXhV?=
 =?iso-2022-jp?B?aUxmQVNJM3RyZi95R1lUSG1pMWhnVWpqamszdStiMlJ4ZGtHZVgrNVdT?=
 =?iso-2022-jp?B?SytTU1RncVhuMkNSeDlhNnRSTHplMVhpSEFMeWlEclQrNk9GS0ZEbkp3?=
 =?iso-2022-jp?B?YmJIczl3Ti9mNXV2YzM2dVpzLzhDeVZqWTcwd0lzQXNsM3dqTVo3V0Vq?=
 =?iso-2022-jp?B?YlA5QUlHVitRNU9iY3dQSFI5TnFxNXVFa2xOanIvRFJoVVVwTTJOaUlG?=
 =?iso-2022-jp?B?NG82MVNRNEtiNlh4UTJsa0J1SFdkcS9LQjUzcUpvR1NIVS91dGRuMUZC?=
 =?iso-2022-jp?B?S2JMZmdXVFpFUk9nblR6bzI0cEF2TGxxclJaMEp1WThuS2RySVdtQy9v?=
 =?iso-2022-jp?B?dXgwY0N5SVVmTWVIcjZIVmtQeGdDYlpSR2tIcVlpakQ5bXZSSXZmQ0Rp?=
 =?iso-2022-jp?B?emEzaWU1YUpDaWhDTTBxay9saFpES1BSQitOaGlqVVV6ODY4RFJGUGNH?=
 =?iso-2022-jp?B?R0EzNU5Gak9ucjJvTEJiYWpjekRTVlhld0ZSU2ZkRFZMWlZ1SVNFbVh2?=
 =?iso-2022-jp?B?eCtFZWhnTmZXR1ErclpacDF0d1dSYmxhVGZOMGh2NlAxUHFUUXk3a2tZ?=
 =?iso-2022-jp?B?dk9FWjlMY3FJTlRyVDlZVVAwTnB2Rzc0VkRGWjM4ZllPVld4Q0w4QVBp?=
 =?iso-2022-jp?B?amF6SytHM3pXckt5eDIyN2R2akhSRXpmVU5FSGF2ZVJZODNWQmRKQjFF?=
 =?iso-2022-jp?B?ejlOTllOaG1KMmh3NG1GZ1J5dFY0dmsxMjhoWGtWR3V1REdDQlFlWklE?=
 =?iso-2022-jp?B?SklyYUhVeEErZ2lWalg2NmRCY3VONmNmS011Nkp5ZkhYaWRJKzljZ2lU?=
 =?iso-2022-jp?B?T0NwTnUvR2x1MXUrblJaaGcxRVNiZkwrSVpNSFVsSHR1TjJDbXZzS25v?=
 =?iso-2022-jp?B?dElzVEhvZ3pqZDV0VkhMSEc4U1gyWUR6akp2NDJBY200NFlqSVYrbnJv?=
 =?iso-2022-jp?B?aVRUSEsvcVh0WlQxVmdvMXd1S1l6TmRQNStSR2tOeUU4bDN0THE1M0ll?=
 =?iso-2022-jp?B?b28xY2ZlT0tOWjRJTmF3RmQ5V2tOVjQ5bTNqUVVPNXNkbGwrZmNQTTFn?=
 =?iso-2022-jp?B?eTJHZTBSNnpKMElCVDRxRjlwQ3RMRWNHSVh1Snh5dmc0M21jZEIrN29h?=
 =?iso-2022-jp?B?RGxrbkNsNFZWQ1dSaWMzNFZUMUVjQXM9?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:zh-cn;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSZPR01MB6453.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(1580799027)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-2022-jp?B?U21YWCtQUHVGQnJEcnlaeWtQZG1uSExJZ0x3YWU4UWlzNDV0ZkNBMlB1?=
 =?iso-2022-jp?B?OXhyTGduVC9VUjNmVE9PRndyR3AvcmJjNjNIaEUvY0JRSGZQVzNsSHNi?=
 =?iso-2022-jp?B?b1gxcG9UTnlnSmQ4eUh3THpScHN5c0ZPQnZuK2tNYVZLL3VBdzJyVXdH?=
 =?iso-2022-jp?B?UjVwOHBHdEhjOXRpQnhPZWQ0QVhpRXpBR21PZlFtdklsWTlnNm01RVJr?=
 =?iso-2022-jp?B?S1k4ZkExY1M4VGNVVDZzWWd1Z2Ftc1RlMi9GYklsWC9JUlB6K21LTytT?=
 =?iso-2022-jp?B?UVZLdFlBVVptWGtFclFXSERmNmFpYUJISmVjc1pHQWlzUFh1czY0ZXd5?=
 =?iso-2022-jp?B?WGZjUlY3RmFJbmFwcW1vOEVKbmtPSmZKV0Q2Sjd2UkFwL0FxcVR0T2hp?=
 =?iso-2022-jp?B?SzBMZlVsMTVkQzludys2NmxXbnAzTElwR21EMnFjVkVFcU4wK3g2SFpQ?=
 =?iso-2022-jp?B?Tlg5LzZ1UThPWGxHeGI0bUdjNVRaTVhBZ04wWHNkS0lwYVV1TkllTk0v?=
 =?iso-2022-jp?B?cjFGaTNxazQwZExtY1JLZWM4dVZmbHJXM3NYbWQxaVExTXM1dG1QMy9O?=
 =?iso-2022-jp?B?WmRqUUFBejRRSzczbGt6NGtJUSsvcWJJVmF5ZzhvZ2JuM0gzKzFpVDJD?=
 =?iso-2022-jp?B?Q25UOE1EMDcrdEdwWmFVdVBaK2FpT3krWjdwODdhOVVEd1k4akJlUjdW?=
 =?iso-2022-jp?B?NHhrRzQxcmxuREg0WkNBMlFSVVl4bldaRXk2UVlmamtSK3ZGbWluNXNI?=
 =?iso-2022-jp?B?c0djbGlESU9ZejJkcHdBNDZqSXQ0MGZFMXlSMzVhRkI1b0RhazJ4TGZD?=
 =?iso-2022-jp?B?OW1QVEVxenV2TnQxYVgzNXNtcFREUVhRZjlJTEwrdjUvQk5NK3pCRlh5?=
 =?iso-2022-jp?B?SWNEbnVhVkdBV0dqTG1WUDM2am9sOXBkTnc1M2laSDlWUUlqNFFOMVJP?=
 =?iso-2022-jp?B?ZXd5UGxPN08zUkhYOTdLKzltakFBT2c3TEsxaFJ4andBbStRTmVZK2xQ?=
 =?iso-2022-jp?B?YmpLOS84SXY5clQvY0JVZzhtYTdqM2dVWVVBMktXVlhCaDBCaDFsaFIv?=
 =?iso-2022-jp?B?aXRFK0VlZk1qcldueW5rOFVITWQ1VUlEcTh6Wm0vaWV0NnI2VnpjUnBJ?=
 =?iso-2022-jp?B?dU1mRm9zZ3d5WUMyeTVKcHgwTUtiME9hdXJ1ZThwUWxEVDNhczJtcWl2?=
 =?iso-2022-jp?B?RFlIVVBxYy9NQjF2VC9HbDhnSC9IWU9YQ2hLNkxLOEV3SkxuZU5PM3Zn?=
 =?iso-2022-jp?B?SEpaQ2lKK1ExSlA3ZCtoMXRDaGxnb0NKWWtqRDdRcnNJME1vbW1lVnlK?=
 =?iso-2022-jp?B?cEFWS1loN0ZxMStvcERDNG1LTGhXOHhlT1hkZnJ5QmhJdXhJOGVtRk43?=
 =?iso-2022-jp?B?cWFONjFrZ01QcFFpS3JidG1TSWZWSEhzNEhrd2RHSXh1VUFwNFZ3b3lQ?=
 =?iso-2022-jp?B?Skd2VHFVUlNLUWZUeGl2c2gwWUFwd1RNQTRuRExWSW1rclN5VGZxVmxp?=
 =?iso-2022-jp?B?dXpvWDBjdEREamtiUzNuOXNTT3BGUys2bndmaUZERnhEd2ptRS9LamQx?=
 =?iso-2022-jp?B?U3RsSHNobW9HVVJnRjhRK2VaZ2t5YnJBcVJ1Uzd2eXorY3JmNW0zVE1B?=
 =?iso-2022-jp?B?R3ZQUzNuSHZwVGtHYkMwRmVhWWYwd2ZURkk1UGxyRW0yL2t3OGFnUTRp?=
 =?iso-2022-jp?B?dEpPTjdKRDM5bWNUMmFqajFFUnZPWlBSb1k1S2x6THJjL0Q4a3BLd0JV?=
 =?iso-2022-jp?B?VG1WdkMzeUJyZnVEM0diSkJZS1Q2WDI4NEx5R2QyNS84R2U1SmRyVWZI?=
 =?iso-2022-jp?B?MmdTYXh0UFczNHRuSFpScDFuQWtiTE1MWVBKRkxFa0Vwak5KTzJrSWFJ?=
 =?iso-2022-jp?B?TzVkU3lBcnl2MTF4UmdvZkhOcVJOcXdmNEE5bU14cUswYitFWGg2VGln?=
 =?iso-2022-jp?B?UmdKVDBhOGc5Z0gxTXNZZzc5cVprdG5CNDBrWnhtSjdHenppblljSmJz?=
 =?iso-2022-jp?B?T0Fpb21WclZZR1ExRFl4d0Q5MUhyZWh4Sm9sdFVYVVc5WWdvWGM1cC9j?=
 =?iso-2022-jp?B?RExsQTFzZ2cyZUpxMzJKa2VrVC9mdzBHZXI2clE5Q0xZaksyYVEyb25F?=
 =?iso-2022-jp?B?dEliY3crRVU2eUpGWjltcnorckFKUUJOcWFxS3NuaDc3NWgwZThRZDhz?=
 =?iso-2022-jp?B?Vm55bVFnMWowMG1leGZxdUxUWHNHc0VIMVBNeTVjd0U3cExCeFA0ckRi?=
 =?iso-2022-jp?B?MW05cEd2MmdzRGlZQ29DNWE4bGQ1Ti9Da3NTaXcwQnhLU1B1Mi8rcHRS?=
 =?iso-2022-jp?B?ZXB2Qg==?=
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HA6UHjVVsaj7qYmFuedEsyZOnZAedCSGgtC3keHTGOztYiOP01N5wcSYVhrUA7qOviA63pXM2bZM9KqC0alK4FpsmK5B+0ud3xqwdNIrTDKnG3gYSv7vLgUUOgkApWuBMiJUvyYiwT2pE18jl+4n9URpGWtHDjzKcV3Z1W6PPJlYeTbbX0jInxeIZCeUovGyfgz617rsLkjrSe6wa73JM9GqjH1M1ObI4eU9rFW4pZE+ymfp1LpY5mGS11uTAcDIioy/tysH+6x5LdsyBEGgpX+H01t8WtYickSPD391PK72EKFDKTsabCbKy4nsAV0NfsVbT3mK6Wwdvvh9PS19Htuf1TT2NcwavnDxgHY2Ga+Y2lg5p5HmVzKLXu2eqjsHiizPmXxzJHr9/kg2xRiDdrUc+9OwJyDdXv2KwhnaQdPfUbCbYNSONW73wMoEQs0sqNmU2eGodx5eF32ZK+y5x/4Cduxp9+d2k0LBiUsp7eCYo0rVOzAXKCgzUNIgbLPcOumYhrNUSTLTTHr1cJPC+BlnLU08TSiBUsa3L8QYmyO4Ow9NxCXivxcXjdO873VV0IxZZcS/Yjww3pTWZVmuXFCE9NcCovP3XDWNhxG0GyIficUfgP7ARc02/17xt6rD
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSZPR01MB6453.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84e9be24-12f0-4cb5-e9fa-08dc9ef5559f
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2024 02:26:11.9988
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HyKeBPc2HoVRfSU1mRtj18lwp0JkX9/RnD0IgRfJ+drgTYm4NtKhQkTQEksbCv60EHwgnFdn9ByJUJxEd9q2Nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB5997

>  -v::
>  --verbose::
>  	Increase verbosity of the output. This can be specified
> @@ -431,7 +485,7 @@ OPTIONS
>  	  devices with --idle.
>  	- *-vvv*
>  	  Everything *-vv* provides, plus enable
> -	  --health and --partition.
> +	  --health, --partition, --media-errors.
insert  an =1B$B!H=1B(Band=1B$B!I=1B(B  before "--media-errors" may be bett=
er.

Tested-by: Xingtao Yao <yaoxt.fnst@fujitsu.com>
