Received: from esa4.fujitsucc.c3s2.iphmx.com (esa4.fujitsucc.c3s2.iphmx.com [68.232.151.214])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B17178CCD
	for <nvdimm@lists.linux.dev>; Thu, 25 Jul 2024 08:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.151.214
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721896457; cv=fail; b=n8fOALJzksjVelnPKdmZKZkVRJiIHEw6cMoYE9OJsMZ+6vxgG+Z+BhqAsvJvqxYvVhY2N2gFV0g0rNvyOJZbuSIHdZw1Ga7QsDz1jNt7tSDGWRBVHMroS4TYuUeiySoyA4vj/aFB7NGgNawGffCML3O8zD4rNJyKuuil/MTBrcw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721896457; c=relaxed/simple;
	bh=dlPE+nISf6szJMk3zlkeMAVdOjSf3d1mTit+C76lwvw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IEv3YE/GufOysNHdleM7xcdEsNlVkyUs0qaHVzO6ZNDcRXOoICVdxn4RBP0nRJutuDM4MOng6oH5IJ/+1RD2CI36ohqJMpbaVIY/IdzVVdUIisQipm2BVPa1kfCO1L9eVpBgjOR+720fLrppXJ8ouFVlkd7Vnrzxe0Qoilq35ss=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=lzbuH5Bi; arc=fail smtp.client-ip=68.232.151.214
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="lzbuH5Bi"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1721896453; x=1753432453;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dlPE+nISf6szJMk3zlkeMAVdOjSf3d1mTit+C76lwvw=;
  b=lzbuH5BiOjQd73sADZvktBEYoUTyewI9CjyleWhSwONUPspGKVRrCT/e
   Tc5n/Xi0BO4N1lmQmN4soKqAulvx7DaU/ceq+Eh7ITXxNUoEoNAGGM0GZ
   8GpQfgKlGXPTN7XfeuWxG9tboo2aCNgqNuvfqWSNpuAiCp3C33TANB7S1
   sBNF0XUWMxMVYC7K+Y5vUO9h8oWfjYQAoMOyxCAiVtNJjG0r/2o9LKSfS
   Ca1618OsXc4XNVaZVoCoJy0T6OIpSzx2LQDaddrexfokFW2CqWfVrIMqW
   IVGMGnSrB1Zgiy241AWS/TpTX0BC/TL3WuYkDIUnmPwsQ/UFnBJnYsO42
   Q==;
X-IronPort-AV: E=McAfee;i="6700,10204,11143"; a="39190325"
X-IronPort-AV: E=Sophos;i="6.09,235,1716217200"; 
   d="scan'208";a="39190325"
Received: from mail-japanwestazlp17010007.outbound.protection.outlook.com (HELO OS0P286CU011.outbound.protection.outlook.com) ([40.93.130.7])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2024 17:34:10 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OV/jf2QdaxMrVIubwSPbmL156VuaYWU/fXLqpPQpSfkM3K7nXVByLcSkffzsyfcgs6Zltf4YY/BrX/XneFBXN9vXKOgLIhXXj60dFLxIxSXneHm62e7aIpG3B8bD9RfzOXlb1Xjp95nGTOjEW7l0lS8yBz7Gak6rICjhQ3twfRlWMr+svbiFX6Zt5s2uJCQ51HfTrCfi/meQOZf3d8kGDC22ddhs3vW9kTKmjF40QvuYYoCViNZ3otJWsiY79EUZnxxRUFJ6QErvBtVhWir+xicCzCKpHZHdrH9f3rp1JBhllmx9IWmyQk1czVBkx7gOfxqWxAQYb0HKgdsfc6wcYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h+PMM9e7lf4b2xQ8KGAJZIfpDoYUQW47lCwXwn/LFFU=;
 b=ESUzF5iR1Fw/ydZYWlbbzQEDoMYJ4UcyKb33dfmAc5mzDLhkM2Iek7Svp9NsbNRSllLm8VOHKKifMdMeV+WGgy4SVZCKRtK5yiTsN+I+xDuGk47TOrXaOqtw86r/y3JHK0ZUYJaeH+0gKyr6yM3E/18RQoStd/Wm5XPTDYSWd0SQY/w8SWYMT+EOaEAPgDkgUJ8XgeTdoAdxXr4WDp6IIngA8fAQM0KkoYP/1BUYDsa2PIOlc7sjgl4ZnkNtR0pVzS3p7qhDtaLT9yENMnNry4Pv593398vibHVW7ZYgMOPl4rlXZ0NfpWv5MPNOWRYWPL8DkofSNYupRRUfGeU5gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from TYCPR01MB6464.jpnprd01.prod.outlook.com (2603:1096:400:7e::7)
 by TYVPR01MB11201.jpnprd01.prod.outlook.com (2603:1096:400:365::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.28; Thu, 25 Jul
 2024 08:34:05 +0000
Received: from TYCPR01MB6464.jpnprd01.prod.outlook.com
 ([fe80::882:d445:280b:8484]) by TYCPR01MB6464.jpnprd01.prod.outlook.com
 ([fe80::882:d445:280b:8484%4]) with mapi id 15.20.7784.020; Thu, 25 Jul 2024
 08:34:05 +0000
From: "Xingtao Yao (Fujitsu)" <yaoxt.fnst@fujitsu.com>
To: "alison.schofield@intel.com" <alison.schofield@intel.com>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
CC: Dan Williams <dan.j.williams@intel.com>
Subject: RE: [ndctl PATCH] cxl/list: add firmware_version to default memdev
 listing
Thread-Topic: [ndctl PATCH] cxl/list: add firmware_version to default memdev
 listing
Thread-Index: AQHa3mSje7pTvFW/30aoBpJ7KPWfLbIHHXAg
Date: Thu, 25 Jul 2024 08:34:05 +0000
Message-ID:
 <TYCPR01MB6464C9F0B39C19CD9A7387F38DAB2@TYCPR01MB6464.jpnprd01.prod.outlook.com>
References: <20240725073050.219952-1-alison.schofield@intel.com>
In-Reply-To: <20240725073050.219952-1-alison.schofield@intel.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_ActionId=ba258be0-0cd1-42f1-a8ec-5b37de26de93;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_ContentBits=0;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Enabled=true;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Method=Privileged;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Name=FUJITSU-PUBLIC?;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_SetDate=2024-07-25T08:32:04Z;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_SiteId=a19f121d-81e1-4858-a9d8-736e267fd4c7;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYCPR01MB6464:EE_|TYVPR01MB11201:EE_
x-ms-office365-filtering-correlation-id: be2b178e-8e54-4896-91ff-08dcac848b5a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|38070700018|1580799027;
x-microsoft-antispam-message-info:
 =?iso-2022-jp?B?a1dTTTlTQ3BzNkx6YVA2Q2MzWmhIbEVxVm1wQmtBRzY2cHBJUWRBNkpF?=
 =?iso-2022-jp?B?QWlGc2xDelBIVmdPZ2F0THBoUEpCZ09yaWM1OHo1c2VLU3FtR25BSWYr?=
 =?iso-2022-jp?B?NmZLUU1uRkVJSEIxSTR0SmprY1RDNDdjZ1gvV0h6NjVlbENoNzQxYWlN?=
 =?iso-2022-jp?B?TlE5R0lXVnd6b1lJbFlMUU1PcFVqVHhEdFVudGdmT1pmVkV1V2dXaXhQ?=
 =?iso-2022-jp?B?OFduWEtnVHVSMWlDMlhIcG1JWjB1alBmcW5TZjNkOWJ6REZTNk4wL0x0?=
 =?iso-2022-jp?B?ZDhKeFE0bnZmWXRKRGFMLzFqT0FjSjcrQU1lb3Zla2ZhdUhGQ1dBQkNJ?=
 =?iso-2022-jp?B?SGd2NFpoK2prWFpZT25iUWNjY1ljRXl0TEh0SEFMZzVzNi83V3QvUHZ0?=
 =?iso-2022-jp?B?VjhBRnZjemRJcTM1SnF4MktxUGdMSUM5eGdhaUpMZXZSTDZFVWVVblJF?=
 =?iso-2022-jp?B?eFRoY1FobUpLNkh3Sno3VVJnbXlTNWZnVUhMMU5KN3hkOUt2TWhSL1k0?=
 =?iso-2022-jp?B?Z1NVNDdpSDd0SldUVmpzVFFBU2pJS3ZiSXZQSTd5RHNzWDVvQ1duN0l5?=
 =?iso-2022-jp?B?YXBIVTdQa1RnN1lOdzFVN3RWaFkxSHp0aldJTUQ4N1d4T1B0bDQ3bUpB?=
 =?iso-2022-jp?B?bG8xRW1RRG1UbS92Z2toVXp5SEtLWTluVEVMRDF6M082U29TbEs0UWxv?=
 =?iso-2022-jp?B?MjZiaVprNC9tbDREaUsxclhla05TZFJqVEhZME4wWUdTTTdmTFNnaGJm?=
 =?iso-2022-jp?B?SHZiVjV4RURVZGF4Mmc1ZEtpeGMxRW16VUFvL24rdEI3QWpocFg4N2Zh?=
 =?iso-2022-jp?B?bDROb3lESm10RzgxMGQvbVlaRDQ5R1QvL3dUTnlpeUsvc3djeEt4aUlC?=
 =?iso-2022-jp?B?TjBkRXgySjd4ZHZHT21TVFJ2QXFPckxHcnJtSkJlVEhvRDh2VlU1Skxu?=
 =?iso-2022-jp?B?djJGcUhZSXFsUW9hNWJDOUFHM2FZOWlwemhaamFBVVJNSXI1bHdUYWlT?=
 =?iso-2022-jp?B?SWkyWk1JVWE2K200ZlM5MzluSUo5R2I0L0M5MHlTL0RMeVNtTktoRVh4?=
 =?iso-2022-jp?B?Q3FWSnJ5Y3JPdlJ2SlRBOGplTXhoV3dHM2dkNXNBMy9wSWxuV25Pekdz?=
 =?iso-2022-jp?B?WFZpc200Znl2NEVwY0UrZ2lzcDJGK3NUOWJIWVA3ZWY5MDBRQUV3RENM?=
 =?iso-2022-jp?B?UURWbU83eGczZitwbXRubGNUVng5NDNZK3REUDA4ZkJjWUF5L0R5R29q?=
 =?iso-2022-jp?B?bmpqMGZtVHhGeGhoUmxnLzZqMWNySnFmVVN0eHR1Z1F6U3N5ekFxakFm?=
 =?iso-2022-jp?B?UTdSeWU5TFg3TXpVOGtpL1pUVEJiUFJMam1YTFV0ZXgzU3F1ZXJBVFRj?=
 =?iso-2022-jp?B?WWJWT1ljWjRjb29CMmJ3WXhYZDlBaXcxelJTOXpoWjJGOFdiSDNlRDJr?=
 =?iso-2022-jp?B?OXc1aWlpeE4wZUM4UWxtaFlyQVowbENORGxnQzhBVWtxRFl2elFybjBC?=
 =?iso-2022-jp?B?MFI3YWlsVm5HeFRGWlBWTVdJM25RNjJiaTVYenF5WFpwVndqMXRwQWdr?=
 =?iso-2022-jp?B?RUx1SE5oMjd2djNsNkZ4cmE3d0UzVnFrNnltY01TdTJ1QWdLZVl2bEJ4?=
 =?iso-2022-jp?B?LzdQVGJHWkZwc2RNTVpqWkgrbUFEVjFVaml5bzBmdXhrY1NFbWt3Y0dW?=
 =?iso-2022-jp?B?aTJoa1Y5QVY5N21EbjVJbVBUdWZvcm1zVkJLK0VVUHlQZGh2UlUvWXFP?=
 =?iso-2022-jp?B?SGpBbkJVSThVMXdwRmY5WHRtc3BRMXUxUERkeHNhZlloNXh3VVBiRDhW?=
 =?iso-2022-jp?B?L05WbnQvbDUwaUpkZkFSWDRHMUNab1E5WXNvaWdNeUJEODlhRFZaK1Uw?=
 =?iso-2022-jp?B?Z3UvcGpWNTZuVk5naVZ1Q2dwU0tyNC9hSUNwUHpTZGFNU0owWEM3MzV2?=
 =?iso-2022-jp?B?VitnbmVZQzYwcWRYdURFakFtQTNEVjFEQVE2MDU3T1RxeXFad0wwZ0pX?=
 =?iso-2022-jp?B?UlJQK01zUkZwM3ZtTUVBNjFTQWJXNHRLSFBkVzQxTjlhSHBLLzBhOGQv?=
 =?iso-2022-jp?B?NFQ1Nlk3Z0NsWUNuU0NvMmR0bk5OWDA9?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:zh-cn;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB6464.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018)(1580799027);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-2022-jp?B?K0p6MElKVXl4Y1dzRHhmZHEyZGVJK2NOcmgxQ2FFNjBud1FKbkxkU0R1?=
 =?iso-2022-jp?B?OXIyaVRPZXNLcjJyVjBRV3pXK3VNN0Z1dGw0UVBOb25nN0tEVzBnM1JP?=
 =?iso-2022-jp?B?WVJIaFpZMXlKSEJqeGJvMnZGOG5CeHhtcnpHdG9TaHkyd3ZES2VkMitY?=
 =?iso-2022-jp?B?NStPTDF3TkIwcTR5and6SXRNWnZwY1ZpdFo3TVAwSkhIVFlZbmUvMHZF?=
 =?iso-2022-jp?B?aTN3NG14WExqUnNsYnY1MHBOcjR5YjNJT1NnTVFDaUhzeDRIY3FUWEJq?=
 =?iso-2022-jp?B?VEV5cVlGL1BSOHJQdkNib3BTODJaQWZBajBGU0YwR0dNU2R6SHU0ak5M?=
 =?iso-2022-jp?B?V1dkRlBNQUhlMkFkeWZTMjY0SVJRYXN6ZG05SUFicGg0TFd6WlBwTkZk?=
 =?iso-2022-jp?B?T0F5dmlsaHptM1NJY2NiZnRHNFFybEY2MmhmRTVEdDNyR1lzMElPcGpv?=
 =?iso-2022-jp?B?MzFNM1JtbHp2aWp3dEkzZlRnbHZSb0ZKQ1htelBKMnRFU0VjOFc2czQ0?=
 =?iso-2022-jp?B?K2VIbXNmNHB4VXNYcjlrSS9JeEJEUmZuL09mWUdUM0RTUlNDY2RXR0FZ?=
 =?iso-2022-jp?B?U3JkK2VPWjZrOEg5ZzhsdjF4T1RRS2xOSkh4ZzBpY3dva1AyM3AzUGh3?=
 =?iso-2022-jp?B?RzluR3Zxb0dkZjg3OURoak92ZmZDdkVIcFk2elFvRVVLQy9ZbEhta3pJ?=
 =?iso-2022-jp?B?YklGRXEyemozU3hGcE8yNmtrL3ZBRUUvMWJUdGhRVEdoSWRncms0YWt4?=
 =?iso-2022-jp?B?MnhxeEVSLzk5VUJadnFlTVQ0ZkpnTWo1OXdBY1QvSDdjdmt4a2xJaHFo?=
 =?iso-2022-jp?B?WVNCdnZRTjJlU2o3ODd2U0t1blUvUjhXU0hYUVRtNlFXd0pRcWF4dWhD?=
 =?iso-2022-jp?B?dWJlZDBydE05eU5HUjFwYlhROUVsSzdGVEFsaXVjbmUxVUk3cThxeWhj?=
 =?iso-2022-jp?B?UTVJTkd5Rmp2R0JadzExOEJoNk1rYjlDd3JDYmRFd3l2UjJlLzZwUnFk?=
 =?iso-2022-jp?B?SWQ1cFIxQXhNejA1cWRxZ1dObXBwYm55TDNaaHdveVVCbG43TTMzL29X?=
 =?iso-2022-jp?B?akl6bzRmYlk5RERWbERnS0g5c01Ba1Q1Y3dwNFVWdHEvbm05Z2UyOVNC?=
 =?iso-2022-jp?B?NUhNQW1GejVCTElFQXB6OG5KclJhUlgyRU9jVjB1cHZLakIxSTBBendx?=
 =?iso-2022-jp?B?TE15NmsxaVp0bjRuWnFsa1FicFBIZTZYOHprcGJqNWR0NEcyNkhucUh4?=
 =?iso-2022-jp?B?UmZScGREU0w1Qk1lSzlSWkJnSWt3WkNWaWV5eGt5Vm12WUVoRnFHQm1y?=
 =?iso-2022-jp?B?R3dqdGkxVThnK3hseDU5TDZZMnRzNXVOMFN5T0hsNDBCV0poN0RlcllS?=
 =?iso-2022-jp?B?OGpnNkZVT1NUVUFlSHBwbFJ6Y3dJMUdiVlU5TXZzTzlBMk9ac29FRjhr?=
 =?iso-2022-jp?B?NXVHclE4aU9iWTllTnBkUmJTYzA0RW9NaWk0ZzIzSzBWdUxiZ3FWK2RQ?=
 =?iso-2022-jp?B?bnNzWVIwOFhMa1BjMUVtNEFZOHFXdis5dFpNSkJ1NnphSGozalBPUmxr?=
 =?iso-2022-jp?B?dzk4MEZ4bEhFK2xzN0E0ckJVNGJ4UjFtSHFPTVkrR1BFbTUvcUhvaWZo?=
 =?iso-2022-jp?B?Y3dXdlZGY054R1U2OThuZHk4Qk1HMEZRY0k2bytUek9jNUtqZ2JyMUJq?=
 =?iso-2022-jp?B?REk2Q0xjSlRkWU43a1daeDlFeHVwc2RUcEsrN2J4emc3TzErZEM1d1RC?=
 =?iso-2022-jp?B?L2pNTWxJeXFIMzNYM0tmVEhPUlpGYUxmMjZxWktubTU1dy9YeW00dkc2?=
 =?iso-2022-jp?B?ZE83S2twWW5LaEEvVlNQNVBjM2l1R1NvekduRUJsclNGSmFmUjh6WGI3?=
 =?iso-2022-jp?B?NzdUaE1hV3RLNXFjVzRvZllOb2tQNk10cTdtcUgycnlDcngwUlFSMUVv?=
 =?iso-2022-jp?B?Umh2a3dpUkcreFBaMnJ4SWpOUTBZSUMvUVZOUnF6M2NzL3IxMHNDNEhr?=
 =?iso-2022-jp?B?Y1cwTFEzWHN2bVFrRHZoS21BaXZyRSsxNXlyaEtISTNucWwrWm5RaklH?=
 =?iso-2022-jp?B?c00zeUxycXB6TVVyM3poR2VIMGlvSVl4aGY3QkZUbUYraWRnYnFlVlFE?=
 =?iso-2022-jp?B?NU5KTmluaXAzZkY2Vm11U05jalBFdGxCOGdialUwZGJ5eWcxYTJ6d2dp?=
 =?iso-2022-jp?B?NkFJQ0pSN2FtUlY0QzVWSHA4V3ZaRlk3RmJGSzRScmpoTkdTTnJheldO?=
 =?iso-2022-jp?B?TG0zQW9PcFg3VHZobmlhTHYxRXowcEJLKy9sdXlKYWdaM05nYjZaUzdJ?=
 =?iso-2022-jp?B?Ymp2eQ==?=
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
	pJ87L4anG1njpmTg8GVHUSZtRirg9oItfIi+mvzEHKQ6SarCPNuPvtPYptOu1smKIBWRIPxZN8YBaDS8zKuLlc5co7sisGhsVSohrQxygl8sZ2HWrTNwwaLvgR9ui64IAsWDsIQtbjrv8FS11E13MZWC2Hgm6FOfySy9B2c+7PJ+SHkvYoSWOJKRLvRJzANuJWD2/o3dpWP4yZMbj8rOxDWdKgs2Bmevebr3cpADHRTRXejm9nQRDsVcFSjmcZFNbp1qKvtWRRhYlA5ffOdw7jXV7SwdrIOWfZbYvqA/w8cqqBMxHGXK4fWoVx0xNGY+MF7hUSfaQkXxjvsV1oJgnhPtofoTTxeZs3Tja2X7t8rbeyjFqLaD53pb5JmfAXXySFKxfO23p0io8JqMCS7k86STaRQFuRuipxbnfWyBiYnWWx9UCMw8Za4acuJvM90gsyNUty6WybN4todWoOw6LDwz/hnr0XqYPNlOhE+um95KJzBj3c7YuMMty1Ia2yynAtOHGxFOqQmm38xOC087GrblOuSSC2bQjwjnxnrFq+rYQSskKGD9BQN3ShA7mqey6Foluhhnbwr5Q9t3bd1TOHAHXVLj4AxdXG3D+fzGBXxAvU+PjFWMrr7ahEB7+O+T
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB6464.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be2b178e-8e54-4896-91ff-08dcac848b5a
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2024 08:34:05.3258
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ehiV1Z2Jt/z69NOVNQXSLjwNjluY8QdGA0MyPQTZf7HguFIoqV4AGjWQDxQINiPQQ03i0j6FlP4g2iEJelKVqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYVPR01MB11201

Reviewed-by: Xingtao Yao <yaoxt.fnst@fujitsu.com>
Tested-by: Xingtao Yao <yaoxt.fnst@fujitsu.com>

> -----Original Message-----
> From: alison.schofield@intel.com <alison.schofield@intel.com>
> Sent: Thursday, July 25, 2024 3:31 PM
> To: nvdimm@lists.linux.dev; linux-cxl@vger.kernel.org
> Cc: Alison Schofield <alison.schofield@intel.com>; Dan Williams
> <dan.j.williams@intel.com>
> Subject: [ndctl PATCH] cxl/list: add firmware_version to default memdev l=
isting
>=20
> From: Alison Schofield <alison.schofield@intel.com>
>=20
> cxl list users may discover the firmware revision of a memory
> device by using the -F option to cxl list. That option uses
> the CXL GET_FW_INFO command and emits this json:
>=20
> "firmware":{
>       "num_slots":2,
>       "active_slot":1,
>       "staged_slot":1,
>       "online_activate_capable":false,
>       "slot_1_version":"BWFW VERSION 0",
>       "fw_update_in_progress":false
>     }
>=20
> Since device support for GET_FW_INFO is optional, the above method
> is not guaranteed. However, the IDENTIFY command is mandatory and
> provides the current firmware revision.
>=20
> Accessors already exist for retrieval from sysfs so simply add
> the new json member to the default memdev listing.
>=20
> This means users of the -F option will get the same info twice if
> GET_FW_INFO is supported.
>=20
> [
>   {
>     "memdev":"mem9",
>     "pmem_size":268435456,
>     "serial":0,
>     "host":"0000:c0:00.0"
>     "firmware_version":"BWFW VERSION 00",
>   }
> ]
>=20
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---
>  cxl/json.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>=20
> diff --git a/cxl/json.c b/cxl/json.c
> index 0c27abaea0bd..0b0b186a2594 100644
> --- a/cxl/json.c
> +++ b/cxl/json.c
> @@ -577,6 +577,7 @@ struct json_object *util_cxl_memdev_to_json(struct
> cxl_memdev *memdev,
>  	const char *devname =3D cxl_memdev_get_devname(memdev);
>  	struct json_object *jdev, *jobj;
>  	unsigned long long serial, size;
> +	const char *fw_version;
>  	int numa_node;
>  	int qos_class;
>=20
> @@ -646,6 +647,13 @@ struct json_object *util_cxl_memdev_to_json(struct
> cxl_memdev *memdev,
>  	if (jobj)
>  		json_object_object_add(jdev, "host", jobj);
>=20
> +	fw_version =3D cxl_memdev_get_firmware_version(memdev);
> +	if (fw_version) {
> +		jobj =3D json_object_new_string(fw_version);
> +		if (jobj)
> +			json_object_object_add(jdev, "firmware_version", jobj);
> +	}
> +
>  	if (!cxl_memdev_is_enabled(memdev)) {
>  		jobj =3D json_object_new_string("disabled");
>  		if (jobj)
> --
> 2.37.3
>=20

