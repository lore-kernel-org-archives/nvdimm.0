Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A3AC1885A5
	for <nvdimm@lists.linux.dev>; Thu, 12 Mar 2026 02:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773282503; cv=fail; b=SbOQ0vgxyh0WZlTK1V4NUueTWtC4UsGle61OvfOLGS/afQJRDAbUJLjdyykUZsPOs/5txUyRn+XxlMzcMDXXHUtM1Vuw9WlQ2O6iVboCYj1BDosybnp/yFRqU7WEhICWNddmNuQ/7WGPLjV7HxO2Aa6XK4axg3d6WMF2dNiZixo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773282503; c=relaxed/simple;
	bh=n2vqzAsQQmMmM+3S1b2u7DT9MhYhQSuobGaXA0IVSNo=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=WxbIAvBRyla1/u8TolG7ofe5rt66GaBTRF8QbAE2ZbhpKuCtHpCtu8wv2pSpaTJYfqbSzBHHnDBYioUp61WUrLPlmq9hVf4vAYyi8QIzpL6DutLus11fL17yt1EwU0/d43Ko7Kaz7AZ0jIIvvYEYqEaBdDDrFy2gyIB6eZc9jD0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Uqk5c+RJ; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Uqk5c+RJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773282503; x=1804818503;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=n2vqzAsQQmMmM+3S1b2u7DT9MhYhQSuobGaXA0IVSNo=;
  b=Uqk5c+RJGSxYHV4LKyNyQ1XVsff4Qs3aFD8Yl4sMk5lPtnAihrgFaiFw
   EJYcXePrMYIu1lH7FvdfTnZzOc1qcjg0hCp5rTYJdunTj+0BGEwdxOUHs
   93puPKhknkA7vah2QYbcLsi5BkuLnmp3Jv5MWmIMxxaJFkBCJ7QOUpaXG
   w16BWD4kyRqGpsQla7E5VLrNFWlPFBp6m1MVopmTduFe+Eqx0z7jHnb0e
   Lan8vnZ+5fVl3nlxo54uKec0QO9j1dP/wcYyR6smwt/tvuuES8FHUaxxd
   E8Xxdsbd3Gv70L4PPc6LVEbLLZukjNrnI2LmkciI8TUNTCBVcmGFGjiay
   Q==;
X-CSE-ConnectionGUID: 89wzXT5tQU2k9BOAggb9mQ==
X-CSE-MsgGUID: iEElWQNNRv6/qybUJmfx+Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11726"; a="74407182"
X-IronPort-AV: E=Sophos;i="6.23,115,1770624000"; 
   d="scan'208";a="74407182"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2026 19:28:22 -0700
X-CSE-ConnectionGUID: CoEM86oASTC0HI4aBWcJ8g==
X-CSE-MsgGUID: Rrb7TLuOR++LzcbLconDBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,115,1770624000"; 
   d="scan'208";a="251166207"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2026 19:28:21 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 11 Mar 2026 19:28:19 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 11 Mar 2026 19:28:19 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.51) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 11 Mar 2026 19:28:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PtD4UopanWNPX8WaaxfXQHHPMnqktn2bQ/rI+rYXL6+dDUrDWdUO+00oZ3OE35iHM/8LMTvIi4PXZXwENvXXE0lvyY8rDh64dNl5aQRugCbOGSqI4exYOhWU6zSdA9XrTH17qIZBRPQqQ81CUkR500klu6+Cy3Gs71h61bR6k6WayUP0o1rD+QCjb2H2ZgHgIkBIOMCy7symXH/n7NKZyTOeVaNRZFNGowTEgEYT2R5zO9VCVZjpiZc6yzcqmOjLQJSHKIrbiMSzAfz0rOcurs9aw5zYOqAOy7PF5GEty7OF79yTf85x8SJpswtAXbSupDRT5EPRnPeCyk2P8FqS3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PRNQPbZ3xzzbp8YyN+qGtir4IJiKjOilPQrmQmNu4Ew=;
 b=YXKtGoffDHFZnYV1DhoOBmYfh479taEIQJbsOQrO0LriP2sR6A+clYlSAFtTweBj8Wuy4n04HPJmPR/Z2sZU08ZRrA+2QW+zkhd8YjFRx4mblIrhq19u9GVBZbp+hwuQMfLbpl6LPejnDYC1UPqeZ9pOEi+xeHvp+3SSk21MEAZOQsJLd12g3GdgUKDQ+xWS99H7G8JJHuQFaPvVAi4AfeMopQD2XPOPYXM48Rb9hvK/FttwPS6mlgisY8mFNIeR2XW9Um/ewv1IRiWwMDFfGygtIvyhOad14k0DdUY2Oidd+qUtKFxih4SWCfCppMI2ekjtv5Q/LZgwWgMjIGAyeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DS4PPF2A0C3F85C.namprd11.prod.outlook.com (2603:10b6:f:fc02::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.4; Thu, 12 Mar
 2026 02:28:17 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%3]) with mapi id 15.20.9700.010; Thu, 12 Mar 2026
 02:28:17 +0000
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 11 Mar 2026 19:28:15 -0700
To: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>,
	<linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-fsdevel@vger.kernel.org>,
	<linux-pm@vger.kernel.org>
CC: Ard Biesheuvel <ardb@kernel.org>, Alison Schofield
	<alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, "Ira
 Weiny" <ira.weiny@intel.com>, Dan Williams <dan.j.williams@intel.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>, Yazen Ghannam
	<yazen.ghannam@amd.com>, Dave Jiang <dave.jiang@intel.com>, Davidlohr Bueso
	<dave@stgolabs.net>, Matthew Wilcox <willy@infradead.org>, Jan Kara
	<jack@suse.cz>, "Rafael J . Wysocki" <rafael@kernel.org>, Len Brown
	<len.brown@intel.com>, Pavel Machek <pavel@kernel.org>, Li Ming
	<ming.li@zohomail.com>, Jeff Johnson <jeff.johnson@oss.qualcomm.com>, "Ying
 Huang" <huang.ying.caritas@gmail.com>, Yao Xingtao <yaoxt.fnst@fujitsu.com>,
	Peter Zijlstra <peterz@infradead.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Nathan Fontenot <nathan.fontenot@amd.com>,
	Terry Bowman <terry.bowman@amd.com>, Robert Richter <rrichter@amd.com>,
	Benjamin Cheatham <benjamin.cheatham@amd.com>, Zhijian Li
	<lizhijian@fujitsu.com>, Borislav Petkov <bp@alien8.de>, Smita Koralahalli
	<Smita.KoralahalliChannabasappa@amd.com>, Tomasz Wolski
	<tomasz.wolski@fujitsu.com>
Message-ID: <69b224bf2fd12_2132100b8@dwillia2-mobl4.notmuch>
In-Reply-To: <20260210064501.157591-9-Smita.KoralahalliChannabasappa@amd.com>
References: <20260210064501.157591-1-Smita.KoralahalliChannabasappa@amd.com>
 <20260210064501.157591-9-Smita.KoralahalliChannabasappa@amd.com>
Subject: Re: [PATCH v6 8/9] dax/hmem, cxl: Defer and resolve ownership of Soft
 Reserved memory ranges
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR03CA0029.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::42) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DS4PPF2A0C3F85C:EE_
X-MS-Office365-Filtering-Correlation-Id: a3ad0378-41d2-41f5-e470-08de7fdf04b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info: zF2cNBZba/cPrlxFqjc9IIAJyc/7eIcGNzf3qWjxN2RKquDTlAiIkRHyOjO4bGQnhXv44u8y5jysO6PCnBcTIaSJdBdN+v4YUQoqujrSKs+fifn2Vb4hugSkGuRAhYw8gYCL9N6A7ZHAiFuIYkk/mZZMYcdEO0Gy9mHEMEn36PF6McNvAg574hPTlpEK3TveHi3Md5GfLkatW68ptubwCZj1hFhPNxFRoBOFO/ucQbAY1/HWGqhH/E+2q54IjCSjifs2g/aFhot8/bsEsdpV+STR5AWJa9g6wJIsyPSVcF9BHxhXT6pIa3E/qmBafbgRn7bvgQkI3jjnnXxWsOZs3lf1P/giARKzycQ5qfQQ7X3oxldIza2PGfaWVH6XgcZQ+0FzjPwdXMJ5KfkRl8cSmatG5XkCbvWB0c/2Q1mAYaBojhB2ny/LxnKLAT+nJKBkqXWmh+Kyts63UNayrMRjitNI+iKMkYEa56KDZ4t9V8YYGJCFC60aoeVQn7ZwtCklJd04BS1hbOtb0IVMRl4817jvaWouk/GjI9lWdHJH+824imuOClcwHRoxhQuzfR0nEACk6t3aZwozua6RHLBT4RcGhUkYeTdzpa8PI9WNscjyvSKvVHkIppv6Cysv370NOjcUx2ITdaypxz265gwmZeRO3vpNK+eXBdcKz3io/gh7xVbZQFnG/heHspsrdsrH6WO6Z6mTVoz/Ecqrx7UwX0hysYnQJtFY/jNZMa+yTPDpRdSt3o5rhhBfwuviZTpp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QU9xM2RpY0dSS3hGL25UN0ZuV015WlkyZWxxbEYybVZhZUV4M0UwZVltam1T?=
 =?utf-8?B?dkdva2QwOThVQUpSWUorYnBNbXB5UHFIMURUZXU4OXR3SkNGaFo5OStGNXYw?=
 =?utf-8?B?TTVTbE0wUXZIM0ttNTZRMXQydG9vUGpwMlk5RWtXb3NJOFJKdTlKUmdLcW9h?=
 =?utf-8?B?Ryt1NFp3VE9jdWh6d2s5K21ISXk1dEl6R1RRRC95TFFnM1dqM280bWEvYy9O?=
 =?utf-8?B?ZTRkeDlONzlYa1JtTU55YTR4dmNDQ0puZzVQS1UvWHBITE1sTHB6ZnhQTHlK?=
 =?utf-8?B?d3NCSUVDOVowZkNCRS9WdkJIVlIwOS9UVXRRRW5KY3d5UjRJNGVSTFlrMDBM?=
 =?utf-8?B?Q01panNjRW91U1NKMkxLY09GeGpFS1h0TFo0TStzTi9vZW01L2h2VE9LNjFy?=
 =?utf-8?B?cjRvZGhIekR0MXBKQjhuandtQzV5YzdBTlloMncxcnBodGlVazk0U09DaE5p?=
 =?utf-8?B?MWU2d0ZCdkVVRGFGRjZrWTh0ZzJkQnI5V0ZpZ25ISXkvVEd2NThnY3Y0TW5a?=
 =?utf-8?B?Uys4dUpMbi8xYjlEL2prRm1kQ2NaN0FQbzFNcEFrT3ZYelA5Q0czTlYrTStH?=
 =?utf-8?B?ekNMeGdtTFVEVytCR0RmNTR4Z3RZa1ZuNlBQc0MxQ3Nvc2xYc1N2VkFlQnFS?=
 =?utf-8?B?VlJGNXJlZHlDVXNQOG9LcGpacUVqOTQ1Zkg0SHZUd0J0VnNRUmNJWWZRYzNo?=
 =?utf-8?B?cy9XTlhQMXdJbWNkbVdmaFBWelNkeFhqQ0NqRGZqZ1BGTUJoUDRYakJLSDIv?=
 =?utf-8?B?YVo1a1hMSDM5WmJRK1FOS1oydHhEVjdJVnVMQm5aMjhkL3NkbytnaXBVVjdh?=
 =?utf-8?B?bmFxUjdRa1N0TDhKVE5LVW8vOHhxRTV0VnRXUk9qL2lXTG1IQlBDV3A1VTVa?=
 =?utf-8?B?RmhSNzN0NG5lNG1kS1VSQWs5RXV1U2VoaS9oNUp1MTZ1WmtQdmFBU01YYzVa?=
 =?utf-8?B?NzcvdWRuNU9wRjZTL2c5OXJLMDRPZFlRN0ZGVWxrK2xnK1ZFMkRUazM4eUk1?=
 =?utf-8?B?ZHdsSU92SDRvYkVUUktuVlIzWUdqd2xDanRZS1pFRk5aMEJQeGZ0Vmd2dXlF?=
 =?utf-8?B?VzB0VXk3OC9jeHFOT283ZGRXajBqeWVtSVlseW5ET2trN1MrVStGaUJoYVlQ?=
 =?utf-8?B?YytXV21FcFAzRWo2VFdKa2xvNFNsVlhIR1pSTWV4VDFiYVNhKzJFU1Y3bWtp?=
 =?utf-8?B?aFkrQWVHdW9aUkF4ZmJqUTNsZ1dmQzZZd1pmeGxDYklXMTBLQWZSSmZOa3Nt?=
 =?utf-8?B?enZpay9XeGhqaTRzYXExM0swZTN4bk1sSlgwRUN1bW9CUjdoQVhreFlMQmZJ?=
 =?utf-8?B?Q0d1OXhPOUk4Mm1NUmxYQVg0cnEwaWVxcWNtdTF2dUhkWmlCTm9RMWR6c2ww?=
 =?utf-8?B?RUF6ZkNMNUwrcG5zdXhRUmMwRjVVNWZFdEpZNERXWnVUNDg2YS9IMC9sMXJw?=
 =?utf-8?B?SnUvQ1hNeXNXSFpKZmxjMDd2NEVsVlMvNW4xaUxqQzJUVllzL3lNMG1Ed3BR?=
 =?utf-8?B?OFNuQnhqUyt6dDlnRUtHR2hoWlpVRi82RDZtMVJWWkszZ2w5aXBBREtFaXF2?=
 =?utf-8?B?Ylh1a2gvd0l1ZHlGcW43OHZ1V2dobFZJWVp4WlBVc3NwUTVvTVVLM0RZNlRH?=
 =?utf-8?B?cVZlaG9EaExxb1JCWE1CWkZIR1YwbG5uNnE2enJSQWFLL1k1VHBjWFBYQkE2?=
 =?utf-8?B?dHNQTERWMUJMV2ovanpRTHMzTGxZQlhYUEJNZ0cxK2hqRUxsZHR2dWdCSXNp?=
 =?utf-8?B?N1dWM20vSis0VGtiS2czS0dueS9POURoWDdoNUc3YXgxSUhkNGRnU08vNEtx?=
 =?utf-8?B?YkpaYWdHb1ZwTkpPY3dXdUNJSUhrbFZpSnBHbHRSQ0RjTWppZGNvWFBBMGkr?=
 =?utf-8?B?WUNJYS9pVEthZUFzZDRPbDAyRkF3OGh2bGd4M1ZoZUhHS20xWTdtRVBNOGZw?=
 =?utf-8?B?NERUeWtqYWdaaGZPTDh6QTFmL3loMWVkMVlhN25NWlNPUHhDdmQ1OEF4aFRG?=
 =?utf-8?B?TG53UGNuVVRuSTVjMlVyU01aRkFtUTB6V2dscnQxb0tXSG51ZnJRR2VlVDZX?=
 =?utf-8?B?UWh2NTk4Vm9LbjNNMkN4MmFuNTZFbjhMSzRiN0xnZk5JTGErYjJVd2lJdUdv?=
 =?utf-8?B?SGMzVzJYZHM0L0RjL1ZaSmdJWkdBS3F3c3NuRFJncldXZHYwRXNNcmRIQ0VE?=
 =?utf-8?B?ZFFSVzEyNjE3ZFhTcXc2QUhCK0JIZzJFdU82MTJJR3BRUzFQMFlvSGlqOWJp?=
 =?utf-8?B?Ny9hUXBmMDhuTVVZRDFPazRmRjlHVnFBL3lMN0NVMTZCcEFjVEJaVHBsV1Zl?=
 =?utf-8?B?QVhQNGIrNkZmd01xZkVIUk5FZ0pUbWRWZzB0bzNUNmpSVER5UExVb0M1ZTBp?=
 =?utf-8?Q?kGF6zqrBfpo86sYE=3D?=
X-Exchange-RoutingPolicyChecked: uAAFQQDOx1kr8HrlFqMw2j7XZ2tPP4N0gDStlO59MXgDiiLVM2LkIQtsv/MWEKUIBd8ZiQCjM2SZeWSXQcqyDQIodoNAsnU1+qmxgwxIxdGO2bmzqVSjFnMy/w5dWZU1IMVxrrMlGnI+ID9GcyevNAWFRM200+dt05Iu5qq2/et8KhAKXWmr9VDxUVy9hJarKIwV5U3/ZU2pHN+fAF2pV5bdAUYmpEBKJdDPINj4QWZ5+E187Jc5JkVpVehZiIzcQAlDiQzvSRq81w9mxi9TEgpmTtGSPQwEt8VwacU0wMqDDHEfss2gyB4Dnl1bYgJ3nrscj/NfYDoKM00fhcqmCA==
X-MS-Exchange-CrossTenant-Network-Message-Id: a3ad0378-41d2-41f5-e470-08de7fdf04b3
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2026 02:28:16.9213
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WuhFjVydp9iv80ooV6MXNZb0N9ztPV5Bifhu2KocQMuopalyPi+T/pFlEKRbtZSgLUOZBZUmARedpCXqoy1VfvYpupRPzQWdbohQGtLbBHk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF2A0C3F85C
X-OriginatorOrg: intel.com

Smita Koralahalli wrote:
> The current probe time ownership check for Soft Reserved memory based
> solely on CXL window intersection is insufficient. dax_hmem probing is not
> always guaranteed to run after CXL enumeration and region assembly, which
> can lead to incorrect ownership decisions before the CXL stack has
> finished publishing windows and assembling committed regions.
> 
> Introduce deferred ownership handling for Soft Reserved ranges that
> intersect CXL windows. When such a range is encountered during dax_hmem
> probe, schedule deferred work and wait for the CXL stack to complete
> enumeration and region assembly before deciding ownership.
> 
> Evaluate ownership of Soft Reserved ranges based on CXL region
> containment.
> 
>    - If all Soft Reserved ranges are fully contained within committed CXL
>      regions, DROP handling Soft Reserved ranges from dax_hmem and allow
>      dax_cxl to bind.
> 
>    - If any Soft Reserved range is not fully claimed by committed CXL
>      region, REGISTER the Soft Reserved ranges with dax_hmem.
> 
> Use dax_cxl_mode to coordinate ownership decisions for Soft Reserved
> ranges. Once, ownership resolution is complete, flush the deferred work
> from dax_cxl before allowing dax_cxl to bind.
> 
> This enforces a strict ownership. Either CXL fully claims the Soft
> reserved ranges or it relinquishes it entirely.

We have had multiple suggestions during the course of developing this
state machine, but I can not see reading this changelog or the
implementation that the full / final state machine is laid out with all
the old ideas cleaned out of the implementation.

For example, I think this has my "untested!" suggestion from:

http://lore.kernel.org/697acf78acf70_3095100c@dwillia2-mobl4.notmuch

...but it does not have the explanation of why it turned out to be
suitable and fits the end goal state machine.

It also has the original definition of "enum dax_cxl_mode". However,
with the recent simplification proposal to stop doing total CXL unwind I
think it allows for a more straightforward state machine. For example,
the "drop" state is now automatic simply by losing the race with
dax_hmem, right?

I think we are close, just some final complexity shaving.

So, with the decision to stop tearing down CXL this state machine only
has 3 requirements.

1/ CXL enumeration needs to start before dax_hmem invokes
   wait_for_device_probe().

2/ dax_cxl driver registration needs to be postponed until after
   dax_hmem has dispositioned all its regions. 

3/ No probe path can flush the work because of the wait_for_device_probe().

Requirement 1/ is met by patch1. Requirement 2/ partially met, has a
proposal here around flushing the work from a separate workqueue
invocation, but I think you want the dependency directly on the dax_hmem
module (if enabled). Requirement 3/ not achieved.

For 3/ I think we can borrow what cxl_mem_probe() does and do:

if (work_pending(&dax_hmem_work))
	return -EBUSY;

...if for some reason someone really wants to rebind the dax_hmem driver
they need to flush the queue, and that can be achived by a flush_work()
in the module_exit() path.

This does mean that patch 7 in this series disappears because bus.c has
no role to play in this mess. It is just dax_hmem and dax_cxl getting
their ordering straight.

Some notes on the implications follow:

> Co-developed-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
> ---
>  drivers/dax/bus.c       |  3 ++
>  drivers/dax/bus.h       | 19 ++++++++++
>  drivers/dax/cxl.c       |  1 +
>  drivers/dax/hmem/hmem.c | 78 +++++++++++++++++++++++++++++++++++++++--
>  4 files changed, 99 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index 92b88952ede1..81985bcc70f9 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -25,6 +25,9 @@ DECLARE_RWSEM(dax_region_rwsem);
>   */
>  DECLARE_RWSEM(dax_dev_rwsem);
>  
> +enum dax_cxl_mode dax_cxl_mode = DAX_CXL_MODE_DEFER;
> +EXPORT_SYMBOL_NS_GPL(dax_cxl_mode, "CXL");
> +
>  static DEFINE_MUTEX(dax_hmem_lock);
>  static dax_hmem_deferred_fn hmem_deferred_fn;
>  static void *dax_hmem_data;
> diff --git a/drivers/dax/bus.h b/drivers/dax/bus.h
> index b58a88e8089c..82616ff52fd1 100644
> --- a/drivers/dax/bus.h
> +++ b/drivers/dax/bus.h
> @@ -41,6 +41,25 @@ struct dax_device_driver {
>  	void (*remove)(struct dev_dax *dev);
>  };
>  
> +/*
> + * enum dax_cxl_mode - State machine to determine ownership for CXL
> + * tagged Soft Reserved memory ranges.
> + * @DAX_CXL_MODE_DEFER: Ownership resolution pending. Set while waiting
> + * for CXL enumeration and region assembly to complete.
> + * @DAX_CXL_MODE_REGISTER: CXL regions do not fully cover Soft Reserved
> + * ranges. Fall back to registering those ranges via dax_hmem.
> + * @DAX_CXL_MODE_DROP: All Soft Reserved ranges intersecting CXL windows
> + * are fully contained within committed CXL regions. Drop HMEM handling
> + * and allow dax_cxl to bind.

With the above, dax_cxl_mode disappears.

> diff --git a/drivers/dax/cxl.c b/drivers/dax/cxl.c
> index a2136adfa186..3ab39b77843d 100644
> --- a/drivers/dax/cxl.c
> +++ b/drivers/dax/cxl.c
> @@ -44,6 +44,7 @@ static struct cxl_driver cxl_dax_region_driver = {
>  
>  static void cxl_dax_region_driver_register(struct work_struct *work)
>  {
> +	dax_hmem_flush_work();

Looks ok, as long as that symbol is from dax_hmem.ko which gets you the
load dependency (requirement 2/).

Might also want to make sure that all this deferral mess disappears when
CONFIG_DEV_DAX_HMEM=n.

>  	cxl_driver_register(&cxl_dax_region_driver);
>  }
>  
> diff --git a/drivers/dax/hmem/hmem.c b/drivers/dax/hmem/hmem.c
> index 1e3424358490..85854e25254b 100644
> --- a/drivers/dax/hmem/hmem.c
> +++ b/drivers/dax/hmem/hmem.c
> @@ -3,6 +3,7 @@
>  #include <linux/memregion.h>
>  #include <linux/module.h>
>  #include <linux/dax.h>
> +#include <cxl/cxl.h>
>  #include "../bus.h"
>  
>  static bool region_idle;
> @@ -69,8 +70,18 @@ static int hmem_register_device(struct device *host, int target_nid,
>  	if (IS_ENABLED(CONFIG_DEV_DAX_CXL) &&
>  	    region_intersects(res->start, resource_size(res), IORESOURCE_MEM,
>  			      IORES_DESC_CXL) != REGION_DISJOINT) {
> -		dev_dbg(host, "deferring range to CXL: %pr\n", res);
> -		return 0;
> +		switch (dax_cxl_mode) {
> +		case DAX_CXL_MODE_DEFER:
> +			dev_dbg(host, "deferring range to CXL: %pr\n", res);
> +			dax_hmem_queue_work();

This case is just a flag that determines if the work queue has completed
its one run. So I expect this something like:

if (!dax_hmem_initial_probe) {
	queue_work()
	return;
}

Otherwise just go ahead and register because dax_cxl by this time has
had a chance to have a say and the system falls back to "first come /
first served" mode. In other words the simplification of not cleaning up
goes both ways. dax_hmem naturally fails if dax_cxl already claimed the
address range.

> +			return 0;
> +		case DAX_CXL_MODE_REGISTER:
> +			dev_dbg(host, "registering CXL range: %pr\n", res);
> +			break;
> +		case DAX_CXL_MODE_DROP:
> +			dev_dbg(host, "dropping CXL range: %pr\n", res);
> +			return 0;
> +		}
>  	}
>  
>  	rc = region_intersects_soft_reserve(res->start, resource_size(res));
> @@ -123,8 +134,70 @@ static int hmem_register_device(struct device *host, int target_nid,
>  	return rc;
>  }
>  
> +static int hmem_register_cxl_device(struct device *host, int target_nid,
> +				    const struct resource *res)
> +{
> +	if (region_intersects(res->start, resource_size(res), IORESOURCE_MEM,
> +			      IORES_DESC_CXL) != REGION_DISJOINT)
> +		return hmem_register_device(host, target_nid, res);
> +
> +	return 0;
> +}
> +
> +static int soft_reserve_has_cxl_match(struct device *host, int target_nid,
> +				      const struct resource *res)
> +{
> +	if (region_intersects(res->start, resource_size(res), IORESOURCE_MEM,
> +			      IORES_DESC_CXL) != REGION_DISJOINT) {
> +		if (!cxl_region_contains_soft_reserve((struct resource *)res))
> +			return 1;
> +	}
> +
> +	return 0;
> +}
> +
> +static void process_defer_work(void *data)
> +{
> +	struct platform_device *pdev = data;
> +	int rc;
> +
> +	/* relies on cxl_acpi and cxl_pci having had a chance to load */
> +	wait_for_device_probe();
> +
> +	rc = walk_hmem_resources(&pdev->dev, soft_reserve_has_cxl_match);
> +
> +	if (!rc) {
> +		dax_cxl_mode = DAX_CXL_MODE_DROP;
> +		dev_dbg(&pdev->dev, "All Soft Reserved ranges claimed by CXL\n");
> +	} else {
> +		dax_cxl_mode = DAX_CXL_MODE_REGISTER;
> +		dev_warn(&pdev->dev,
> +			 "Soft Reserved not fully contained in CXL; using HMEM\n");
> +	}
> +
> +	walk_hmem_resources(&pdev->dev, hmem_register_cxl_device);

I do not think we need to do 2 passes. Just do one
hmem_register_cxl_device() pass that skips a range when
cxl_region_contains_resource() has it covered, otherwise register an
hmem device.

> +}
> +
> +static void kill_defer_work(void *data)
> +{
> +	struct platform_device *pdev = data;
> +
> +	dax_hmem_flush_work();
> +	dax_hmem_unregister_work(process_defer_work, pdev);
> +}
> +
>  static int dax_hmem_platform_probe(struct platform_device *pdev)
>  {
> +	int rc;

This wants a work_pending() return -EBUSY per above.

> +	rc = dax_hmem_register_work(process_defer_work, pdev);
> +	if (rc)
> +		return rc;

The work does not need to be registered every time. Remember this is
only a one-shot problem at first kernel boot, not every time this
platform device is probed. After the workqueue has run at least once it
never needs to be invoked again if dax_hmem is reloaded.

A flag for "dax_hmem flushed initial device probe at least once" needs
to live in drivers/dax/hmem/device.c and be cleared by
process_defer_work().

> +
> +	rc = devm_add_action_or_reset(&pdev->dev, kill_defer_work, pdev);
> +	if (rc)
> +		return rc;
> +
>  	return walk_hmem_resources(&pdev->dev, hmem_register_device);
>  }

The hunk that is missing is that dax_hmem_exit() should flush the work,
and process_defer_work() should give up if the device has been unbound
before it runs. Hopefully that last suggestion does not make lockdep
unhappy about running process_defer_work under the hmem_platform
device_lock(). I *think* it should be ok and solves the TOCTOU race in
hmem_register_device() around whether we are in the pre or post initial
probe world.
