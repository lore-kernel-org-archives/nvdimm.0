Received: from esa4.fujitsucc.c3s2.iphmx.com (esa4.fujitsucc.c3s2.iphmx.com [68.232.151.214])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE50296706
	for <nvdimm@lists.linux.dev>; Thu, 15 May 2025 09:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.151.214
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747299868; cv=fail; b=MeeSHpPeG+R3a79YfdXNADYmuEB/QCD1Qk0rYgK8eOkt0yT6/IarW0xlyHI0jFaS+KS8+WKrkwQgykOOU/gTtHSCwDhgUs2zyFHSXBYNiBzQ62IVIy+ZzWGpQKhVnAagtBlfxaAkYGWEUi+aSfOKJ50B73B4cE+vNpWOLntE9uM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747299868; c=relaxed/simple;
	bh=oxaxXPw9NYhWduBFPpdnmXBrxCNdhICBHuWdtTcWK/8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=S/hO+HBMk9uCq/vgBdhuIreOlzXpBoDZJ8BaXou3gscmqO8Q9ILE6b6n6y/teOGeUcuQAU60JG5N/3+gd0mivO+qq1Iu4fdsS5VxwBvUKJ+GH7q3PSENxrr1lE+lhW3BtP7XNSob7kvYkf2eOqPb17HOw1khBD9ESUIfr1wc5tM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=cVaQ9Agv; arc=fail smtp.client-ip=68.232.151.214
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="cVaQ9Agv"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1747299866; x=1778835866;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oxaxXPw9NYhWduBFPpdnmXBrxCNdhICBHuWdtTcWK/8=;
  b=cVaQ9AgvJJbGKMYueG3Lp+mgpQT59JvIwrs4XafqO/1QwGHUG02apn4F
   6qeIQccMvQQuWrNg8vHFbJW+dLLm+lZb/3di4GzdI/jf3wadrTxnLW/R/
   IFmcsPViLIp16zjRcS5m3MtrM5Vx1DRAJVfb/lKYSkVGJ3eSrhkFYZsWq
   lOh07qX8btn4X3RZ+/oXJurv5F4p3OyRxqvE/FWrIFG9MWUe5lTkWetaT
   4MSTjIAwfC1ieNKcI5GbXBL/jQvQCttUmCbGfu1Nz+PxWHUnuy4Gpk7bI
   LCmoNCrFICdk0BYMxNfc08DIwctyyQ08TVuco/pUkvqyODPBirtsHEYUg
   Q==;
X-CSE-ConnectionGUID: 1PTlCvw1TY+WoLnzmWrvzw==
X-CSE-MsgGUID: 9kp2ssfXS4iLSPGGV2Dagg==
X-IronPort-AV: E=McAfee;i="6700,10204,11433"; a="68461861"
X-IronPort-AV: E=Sophos;i="6.15,290,1739804400"; 
   d="scan'208";a="68461861"
Received: from mail-japaneastazlp17010000.outbound.protection.outlook.com (HELO TY3P286CU002.outbound.protection.outlook.com) ([40.93.73.0])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 18:04:17 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hZMeCc9dxej5Lp9Fhu/wOUsLSyj03HQf3fWD7XvDFt0MOXK5eUk+6jiynt/YPv5SBEQcRnSWm4uhfL2O9g5RycvBgYq5gAZjJcd0gAkf3qgsMyFExYJdCMCDKpkBNZBg94ZxJsdRVGSBsNUTO7Gf95IDkAbfjy9ie+ejg3Ut9lZF0D9w3dStIlO+N+ZJ107k+Wg2GE3LYRYTM7ONOOLL8s3yuWfi7Nh0iWblw8vEf3xN56TvaczVA8QN9jHku5cxWv4ZT9q/wu7T4Q8BR3FeWX/Q94tM3T8stC5c/sorINCGxEoZfmod8aYQJu6duVHj/5BmyfIPU5k9UCRrR/A9JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+F3umtFOr68mQnZQYfdSCQ1AzZKo8pBrXhwxUCbAaYY=;
 b=rh9NUTObG9a/Vl9fMgkxh+d5zZ6ue9dGf8c8eKTMJuNF5LieLtb81IPFcBYmv/nvCXizU8uKj3/t0BDJAnpZ0ofF4dxmyaNDg2nwRGy38v8otq10X7AQlSkKJ++DWTamLq1TlQrTBzoo1bWUff426UCzUP7WAuw+iqw0jtXMUa7CpCK7yzfma1g+549c51HayAM8T0XjCTACAHQg5tP79050TPJUcvmz81Xb6C+TBGw27h5wtMwBpXfNnWx7ZOjpMC87xVx1gVPpGQH+2o2cAy+NUCTT8VxCKvfaN1wtKZPB1yP5oOt+u2J2bR5tqJXY9ZFSBw/DGOEdpD16W+phRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from OS9PR01MB12421.jpnprd01.prod.outlook.com (2603:1096:604:2e2::9)
 by TYCPR01MB5853.jpnprd01.prod.outlook.com (2603:1096:400:b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.32; Thu, 15 May
 2025 09:04:14 +0000
Received: from OS9PR01MB12421.jpnprd01.prod.outlook.com
 ([fe80::6569:be59:abd6:eb0]) by OS9PR01MB12421.jpnprd01.prod.outlook.com
 ([fe80::6569:be59:abd6:eb0%4]) with mapi id 15.20.8722.027; Thu, 15 May 2025
 09:04:13 +0000
From: "Yasunori Gotou (Fujitsu)" <y-goto@fujitsu.com>
To: 'Davidlohr Bueso' <dave@stgolabs.net>, Alison Schofield
	<alison.schofield@intel.com>
CC: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
Subject: RE: [PATCH v4 -ndctl] cxl/memdev: Introduce sanitize-memdev
 functionality
Thread-Topic: [PATCH v4 -ndctl] cxl/memdev: Introduce sanitize-memdev
 functionality
Thread-Index: AQHbmF/9S4EY6oYJJUmO8zEOxl4fELOxxz8AgB+GbACAAnGnMA==
Date: Thu, 15 May 2025 09:04:13 +0000
Message-ID:
 <OS9PR01MB12421FA48385C1611C63CEDE79090A@OS9PR01MB12421.jpnprd01.prod.outlook.com>
References: <20250318234543.562359-1-dave@stgolabs.net>
 <aAkuxAG30M_WxT8d@aschofie-mobl2.lan>
 <20250513194250.2mpidwy452awflf6@offworld>
In-Reply-To: <20250513194250.2mpidwy452awflf6@offworld>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_ActionId=3f9d5efe-a1ab-401d-a821-95f58b5ac2f0;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_ContentBits=0;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Enabled=true;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Method=Privileged;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Name=FUJITSU-PUBLIC?;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_SetDate=2025-05-15T09:03:22Z;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_SiteId=a19f121d-81e1-4858-a9d8-736e267fd4c7;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS9PR01MB12421:EE_|TYCPR01MB5853:EE_
x-ms-office365-filtering-correlation-id: 7fe4704b-4dd6-4009-4fef-08dd938f76c5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|366016|1580799027|38070700018;
x-microsoft-antispam-message-info:
 =?iso-2022-jp?B?alFPQ0VSeTNvK2dldi9rQmVQcHpSVWk4TWw2YjRNQ1NVUHRVbDNrTlVX?=
 =?iso-2022-jp?B?VDl5eGFRUWV5Uy9MRzBuQ1p4VUU5Z3dyWG1GQlljNnBiamlOZWRWREsv?=
 =?iso-2022-jp?B?OVJWZ2NFR095NktiVVo3KzJQRjBFcDViSUpiNU9DSXNNNTBUY3dSclhJ?=
 =?iso-2022-jp?B?d3pOYkpEZnMydlVlRHlYSUxuYlFrY2hIa05yWHl5UkVQL0pOSkpoYkxw?=
 =?iso-2022-jp?B?ZlhEOFNWa3JZOVRNZ3hETkRtSXU4ZmkxVXVKMGVhWktqVGN2cFRCVmdY?=
 =?iso-2022-jp?B?ZUhFUUxJR245QlBOeGozNlBHM2ZkOGYwVUJSb0pRanJYVDVKMXExeEcr?=
 =?iso-2022-jp?B?anM4WHJ1N0FVSXBWNjR0VVZ2VjlnWld4UEdpUHBlaFFyaEczc2JZQ3N6?=
 =?iso-2022-jp?B?alhoR2hBUUZCdjlGeHJGMnlvaHhsUHQ2UW1QU1gzZWxnVEk5MzdLV3h0?=
 =?iso-2022-jp?B?RVNiVjMwMWtvUUFoV2lhVEQ2YzNlS0NGNjlMTWdJcGdESlppWkRDWEdk?=
 =?iso-2022-jp?B?MUUvN3lpY3lRTitkaVpBdlVyMjlCTENoVmhaRmx0cFc4MnZMYTgzRzRS?=
 =?iso-2022-jp?B?dnRDY3h5dmc3QkVBZkZudStxSk9xdDM1RnkzTmFaNXpBREhWMUZUZkRJ?=
 =?iso-2022-jp?B?dGhwT0ZOU1hHenpSZElWY0hjcFBCVEc1dW53Z0tWM25kcDBDdVhxNE55?=
 =?iso-2022-jp?B?SFdiNTltdzBUekViTm1xcU96NDlCcHRsYzhaNzdiZlRGU01hZUlKOUt1?=
 =?iso-2022-jp?B?R2FTQm1KNmE3OVM0RnlkRzFnTGlCOXlFS1RVb3dpZ2RObW45ZUlza3Nv?=
 =?iso-2022-jp?B?Zlljd2lXZ0JDcmxLaisraHNVUjhKMUpvVzJlQWVrbHJGRXdkVzUyMjRv?=
 =?iso-2022-jp?B?bTVaSGNNZmYrTlJZbDkrNmlVVGhLTDI2MURLKzlLaEI2bmUxald2Vmlu?=
 =?iso-2022-jp?B?WlVnd1o1VzdFcHkwcldRVHFMMXpCaTkzdzJGWm01OHZiOE4yelFSMlhn?=
 =?iso-2022-jp?B?Vlk3MGEwMTIyNXB6TUsyL3dpa3pZcUVCcjBNR0dGUmtYRVZqQVl5NDBO?=
 =?iso-2022-jp?B?MExxM3FCU1BSMVJ0d2dldS95WlV2TXdFaGdWcjNac3pjZEpOaEdlMVZQ?=
 =?iso-2022-jp?B?NmY1M0VJS0RnVXpzWXBMeDdIM2VIL3V1ajZzRUxzZlk5TXZMeWV3a2F6?=
 =?iso-2022-jp?B?YlVWT1BGTGRhVXRaRUJYQWlqMUh1TFEwT2NQaFMxQ1hJUGxxbWZaK2Zi?=
 =?iso-2022-jp?B?OG9aQk9vbDVUUTlvN0thV1hUaUVDYmM0N3dXTDIzYllnWnlCRDhRdjk1?=
 =?iso-2022-jp?B?Q2lrSXdFQnNLaUVuYThWRHFHOTZEM1QxUHk4QURRNUVuRExwMmlMeE90?=
 =?iso-2022-jp?B?L2c4WExsYUJFNHR4MXRaMHV3ZnRhbHZ2VmxwSC9QV1ZRVVEvUHFvNHFl?=
 =?iso-2022-jp?B?QWlSeVFEUWVqejdVaDlqYTIvOWFFS0dtMlNpL20vUEdyMFVuWVpYeFF5?=
 =?iso-2022-jp?B?Mk4zbmlZbU5KN0VnK2RxRjVIdjZUUzRxMlBXQVVBNUlleVFidFRKdVFk?=
 =?iso-2022-jp?B?VU5yVHVYQk0vNXNFYnRXdzdoeW1IaW5LaWFYS2czSHVYREszZHJ6cURK?=
 =?iso-2022-jp?B?bWVWUmxFcGVOamc5L2ZSUHpCd2xZcnhzUWJ0YTRxYi9HeWhaS0JRdW5z?=
 =?iso-2022-jp?B?ckZTejg0YnYzcE8zM2ZUdVg0S1lFa3hVNWlGdVhoZyt2dHdOK2FhOW9v?=
 =?iso-2022-jp?B?UjVrQTdicWIwZEl5cDNsdXVsbnlMNjF6RHJody9yY3VpWG9lRGl6Wkg5?=
 =?iso-2022-jp?B?TXhld0ZwQjlaQ2NMVWZQMXM1Vld5Nnhvc0g1Q3Q4RFA2V0owazB1Wmw3?=
 =?iso-2022-jp?B?ekxSdU9JdW1UMVJRMWR3K3ArRzNGVFNEWCs2WCs2VzR3ZHhyWFlMdks0?=
 =?iso-2022-jp?B?WWp1Nlhvay9JRVBMR1lXTDQxQjc0SEdNY0lJRW8zbTRadGowYUZSbGZq?=
 =?iso-2022-jp?B?SHY0Y3N4TEVqMVNUTHpEYnRUZTM2dDJnVVVQQ0pzK3NYc2htbjFwSkZN?=
 =?iso-2022-jp?B?a2JPUXR3UGtzN3A0VDVjT2hYR1FOUHZKQzgxSGVXVmgzaDZOZnpuYUhV?=
 =?iso-2022-jp?B?c1Jabll2R3VJVWV5N2NFOUtGTDBOL0hSOWtWMEk0UXFuQTVJYk1lZExQ?=
 =?iso-2022-jp?B?M1pjc2pFOXZBUWZ3NEl1N3ltOFdwbEtz?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:ja;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS9PR01MB12421.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(1580799027)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-2022-jp?B?eFg5S2tvOUtpcFhNU3daRE9uT1Z6MUFvU3FRME0rZmFJZWo4RXM0OTQ1?=
 =?iso-2022-jp?B?bWlZWkdJMlVNOFAwejVDNkVWV2FHZWN2N2pKaXRIdGRjQkdRVGJZa2R1?=
 =?iso-2022-jp?B?VkpHZ2dPU09udzNOT1ZmbHlFb05ZdjVLRWZXeXQ3Um9NTVVzbmRzWFY2?=
 =?iso-2022-jp?B?NjN0YlJOeWo4WW5VdlpHNFZTNHBCd0JqZE12aHVtQjJXeVg5S09DS3dJ?=
 =?iso-2022-jp?B?QUNKLzJISk1XZ1cxZk93UUovcG9WV2FHTFRIa2UrdHlZOW8wR1dLakFn?=
 =?iso-2022-jp?B?ZS83WmJRN2MwQTNKQzJyRVVlNHI0QXVsQ01PRmw1VTQ5ckNtR24zeGJU?=
 =?iso-2022-jp?B?UkhnM0JwL1IwckpUWFFXTmVXcy9oQmxuVHhjVUFieTZrUzNreDJ1OU9m?=
 =?iso-2022-jp?B?TEtDejhxaHNJSmhiby9BRW1rSlZ0cVpwcHZybXZVZmx6NXdvby9jZkV0?=
 =?iso-2022-jp?B?SU93QXltTm1VRWZNREVycjFxb0s3ZVhwdVNkRlllV2FtSGkvUjBIanlV?=
 =?iso-2022-jp?B?NXNDdjlOOE5jeEZDSEF6S2xSdktRMkpXeThQcmxaOUx3NFZTU0ZuQmtY?=
 =?iso-2022-jp?B?VVRhdWVlYWVpdFhQTUdvSGhjNVVVbkRXc2tlOU8xRzE5Z0N2a1ZldUFK?=
 =?iso-2022-jp?B?QXgxYzgyeEpQMW5MbHMzVmVZVWFoakpTQWo3L1RkakJLTWlEMWdTcGhH?=
 =?iso-2022-jp?B?RS85N2VITW5udjJZMS9zUDRmM3hyRGJ2RTBBdWUvOXM0WGJhMURkSjBo?=
 =?iso-2022-jp?B?QjdYWWZ0eGlDVmdwcFZybEQ3MzBrZG94Q3IvWkNNY0RJcEh1MEFHU2U5?=
 =?iso-2022-jp?B?V3NsV1RJczFUSVJ0NzRtaUozUXJvYkFlSHIrdThIY3pIQlZRRUpieDFU?=
 =?iso-2022-jp?B?b2MyYVhZT1ZIZFU3MFFQSlZwZzB6OWZzZ2RaUitWSXdrak9qdFFtMm8r?=
 =?iso-2022-jp?B?V21PbmhRU1hpVk1hSGR1RTZ4WVpvcDRBd1FUZVA0UjhQY2R6QVN3SjRz?=
 =?iso-2022-jp?B?MUFDelVuenpGcFBVNnlVQjY0U214cndsZlRXNTJjZG44K1hKTjZOR1VL?=
 =?iso-2022-jp?B?T3puSk5ET1pLZnBCRUJXcWJsNktsR2VPb1VUTXZsaTZLRThITFpLSUN0?=
 =?iso-2022-jp?B?THZnd08vR1d4YmxpazZyblVRUEVZTGhLL01VOGRlZEptSFJ0UHZPS2ph?=
 =?iso-2022-jp?B?TlZUSXJBeWxVVDQvbnZvYUFJd1UranlFTExKQURqYlNJZ1hOVUxMMWR2?=
 =?iso-2022-jp?B?b2IvNXhDa0lrbC9nVjlkcnNwaGZLOWZsdVBhTHNMUjREZmhTeG9TQkFp?=
 =?iso-2022-jp?B?VmRqclFqV2Y5QS9lUVNVby8zenp1N3plcE15TW91ak80WnlDeW5rWlIy?=
 =?iso-2022-jp?B?UXNoWnNBMTB4RmQ3TUFBUHh4akVYWW1LMUF6Y0ZnRVZ4WkpEaWRicHdU?=
 =?iso-2022-jp?B?d3VHVE1pbGhXUGMzamVLVXc3OUhxVUhXaGNvaDhGTWhJbHFBYzU3V2xP?=
 =?iso-2022-jp?B?SlczOE1vbkRzREFDSTU3dTFHZkIzcm1MZXhRdTdiWm9USDE1c242SHY5?=
 =?iso-2022-jp?B?ZUxNVlEwRFRDMFk0cTVTVSsxdFN1emM1THUxTENDNVJGZzU1OWR5eHRY?=
 =?iso-2022-jp?B?SlE1NEVpeDJhaS9yM3Nza2U0NW9hUGdKUVNRSTREcXZZMEtwWnU1eEh4?=
 =?iso-2022-jp?B?eVh2cm5nMDVESzBCMDJNd2k1U2xKZmVrOUdsVGtjSExSYXV0ZDBtNHF4?=
 =?iso-2022-jp?B?cHEzL2lXUnVqemUxMzE0MnFza1M1OWlSRGtieEp6SzZOQ0VyTTVaTktr?=
 =?iso-2022-jp?B?Ri8vVGhQT3pQUnFTeldXd1VCWkRoRXVvb3B0TzNVWTJpbFRhVWdXaHdq?=
 =?iso-2022-jp?B?TkU1M0FJeGJLbHUvZWFCcVdmdjl2Mkk2Y0FXdGNjVUhlNE5tREhxTDJ5?=
 =?iso-2022-jp?B?WnVOV2xmdkMzZWtVZnVQVms1bnREY01lRk5wNlBFaGhJQ1BYRmFZYTFB?=
 =?iso-2022-jp?B?bFI0WmlJbDNOOGV0OVdtQmNpVmVISnpOT2VxVUhYdlpuV0N5dW5RK2J1?=
 =?iso-2022-jp?B?RlVZNWxUczdEOUNTeW5CaitRMlJxeTZMYVZtT3ZjTkVOU2dlSzYyc1pV?=
 =?iso-2022-jp?B?S3FrSG11VVhnK0kzdTVyRUNxNFZ6SWJBM1JGdzRMNnBNRGFpOFFXMW5a?=
 =?iso-2022-jp?B?a0dqV0llVGVEWi9vVTdpbXpiNFZqbmVVanBMdkc2UVNBSTQrTWdQaFA4?=
 =?iso-2022-jp?B?TGhWbW1FOEJNeml6eHlhVGFQYURTWHpKVk92Mi96cEN4WTh3ZGtVRDhW?=
 =?iso-2022-jp?B?Z1Z3ZQ==?=
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
	zxvKkIZ+YZ6bbBLXYBa1/US5sNt9J6Ja8rRBWhA5HGN3Es3FtDcHbEaL0hF26Gy2H2JpLEeTdwAUCg7PIO20qGXAal1LkP3Qfo9h8ZWdTqIDR03Eh6Nq/ODefKfHayPypfhG+sZfmG7dz5UAedBBv7LUTctJZKqx/lTg6GJo/b3gYIDOnOQDCmof4Zp/p9ndWOpM6DEoD8+k0Ez4Nf4bpdCFj6VCQm1M9yBf+opT3kb2K+alI5i0s8OJ7sqkUZh55IqXoquHSmp5dXbcV54xOcthO0saYuGCd4VWh1LlIFupyuLTgsIldUfBRCpKSWRs7L6Vp8C5PRfrkJTETstnroWxs/j3B1uROu6Qy29e50FuKwYUyutOO/cGzsKIcaKqOS7P2EIe2Zy/LcEBGpODgFFhmaELESmgpx/eJvjxO3cje2yGkC8Uw4qjFq/b1evhKku/XB2TxSMZ1LsLTUAN2ZOBBsWHOrA2skeLUrfm2nEpFNfL4qSMARjzAWPuB39Ll/2WME5VnfblZrU7WCHfmfFry35ZMw0/RHaXD2aySmxfgjqxjGQC6+nM81/L9Kc1CAQc025vrDYU6p2YmGJRTnj5skV0It54nz/D0biKGqpPoeGB/MZZf8+h9Gsll+dx
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS9PR01MB12421.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fe4704b-4dd6-4009-4fef-08dd938f76c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2025 09:04:13.8590
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ++ZbX8qx2kxaWWE715k6oZDHKIbzYisZdtW0wiN+QNXajaePBT94nFgWkgRIsh1IKmhI5Gel+5CDogBBdb7oQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB5853

Hello David-san,

> >On Tue, Mar 18, 2025 at 04:45:43PM -0700, Davidlohr Bueso wrote:
> >> Add a new cxl_memdev_sanitize() to libcxl to support triggering
> >> memory device sanitation, in either Sanitize and/or Secure Erase, per
> >> the CXL 3.0 spec.
> >>
> >> This is analogous to 'ndctl sanitize-dimm'.
> >>
> >> Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
> >
> >Hi David,
> >
> >Is there anyone you can ping directly to review this one?
> >
> >It's been lingering a bit and I'd want to see a review by someone other
> >than me before merging.
>=20
> Yasunori-san, since you were requesting this (as opposed to just doing a =
trivial
> echo 1 > ...), could you please give this a test/review?

Ah, OK!  I'll test it.
Please wait.

Thanks,
----
Yasunori Goto


>=20
> Thanks,
> Davidlohr
