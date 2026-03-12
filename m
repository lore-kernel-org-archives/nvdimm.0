Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB641A6832
	for <nvdimm@lists.linux.dev>; Thu, 12 Mar 2026 00:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773275400; cv=fail; b=VCQ8KJ9gl5zzYRlDcH40ol/7GLH8yfOIHnnEVRIrs/tq2bmpaLnCtqoe9662VLxBGmeteQYl7hP8GzGLmJeA7N7ly99EaAgby6ec/cY9NK1JSs9a13zW/JBrRC0Y143BQOHRc9whK+ESeGR8TRUyvADJaT9SBDhuvkD1B65yixU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773275400; c=relaxed/simple;
	bh=fBs6wQaGq9nquOWFG416YKvBvswpeujmXqx6jnvR6HQ=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=UC7xEfq+IiVj29JjhcDVDanAhgBKBKHLzPOv3VsXmfCZWTvehp8Fx8/ZXoDp5gs0g7B3NKkOOuKitcs89wpNQ41K3yV+AD3zKRi3UA78BaC87UL4hvbGbhDY1W+ajXe/7NTmCRGPjvm3LwNAMXib+J79N6PCDd+RtaRUW6av+40=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O5z6gDQ7; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O5z6gDQ7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773275398; x=1804811398;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=fBs6wQaGq9nquOWFG416YKvBvswpeujmXqx6jnvR6HQ=;
  b=O5z6gDQ7chpI6Hwmxqzbt1GG+RQMRMN72PnE/nxkuWX3xthwUFWcI2yJ
   iNIudKgo25xLdJFhcLxcPbv2m9gO4VYeJAn1//1pMyWQLBc29TGiC89yn
   Wb+p6wRJxlikeWm7/fZVyFdJcR3dGtyXj7zSxbanZriH2JfColMzzKA8/
   a6BZT7BIba/hgrFDLuYOOeuaMTqIKQuYf+yZBzpkpZScTTq6jOCYs/v2Q
   OmNIPqAdU2pgMMATOXvvdyWmyBnbH3hYW6SUJ0oBRfCs+pIvb/ziz1Bd4
   7A2pkHTz67A1ZODZqh2kUK2LbjIQerAA8y5rxqBMvQ2bIOGw6US2fImcr
   w==;
X-CSE-ConnectionGUID: df18mkTvRmG8C1HFfvBXzA==
X-CSE-MsgGUID: rxpYUuuFQAyYKj1ox4vK6g==
X-IronPort-AV: E=McAfee;i="6800,10657,11726"; a="91931936"
X-IronPort-AV: E=Sophos;i="6.23,115,1770624000"; 
   d="scan'208";a="91931936"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2026 17:29:58 -0700
X-CSE-ConnectionGUID: hbSDL8ZKTWC7E2Lh9LPsRA==
X-CSE-MsgGUID: dpB45uSWSneQndkC4NE8YQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,115,1770624000"; 
   d="scan'208";a="217247644"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2026 17:29:57 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 11 Mar 2026 17:29:57 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 11 Mar 2026 17:29:57 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.52) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 11 Mar 2026 17:29:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U8ZQSH5HbxqoqBmdne0t+psEDvoEtyk4kl/1kvkspKlUiHrVe/fTfa+QtXQunTmV6k/dsx7VigFYmuTOQlt5RybFY28q+5W7YHG5yAvUru98S83RL6MOLsHDE1rcUtQ2MPGSpSg+oeqVoieneOkSPwEkBPUwVxTxFUZZDzOffHavWLeQ3GY5Z5Kfu52042nyFcktw6Le71qXxdnRA/u0Q4lPG7O9DERdyCUH8FvI6Uq+XLc2odVacXBB66i/mMJyjyPitKXFnFHQuxO6Z6ynJBVhmHG2JiTyvmJX0+b63GWzzMKs2L/bRYpU4oYpZZtDk5rD3H2ge5jEaI8enMRawA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7oPWyNZCwOdOHUZV3Wq87Bn4fnME72HM2AsSeoNKXEE=;
 b=FqE5DqldPAf1MpruGvdRnKr/oS4Zqv0qjqkkgbVVcGpdiPAL3rCNUrUxvhrd+79ABoPjQQ6KrSLQ3pjwdwgfpcPiWNkGVrpzydl8pwSmL5E8QKn5UtLmRAgBT2fdv1xSB/duYXQCW5aJtyv8PRjcwdiFD2jkusY0SJozyBPCA0rP/dPkFU8nBJ/T9uMqbM8AxMeU2Jzhla4twBdL/ddmow8bw2q5VeJevG3jbNyCglqffTIPE7k6kKlyr/XHFYf/57HfelJqKZDCRkxv5GZzP5pBtLPRst8jMADFWVyRWyOLmrnL3Ctx7vAHUA8JDAxI0+NaN6soz4uSPw6K83XqTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by CH3PR11MB8774.namprd11.prod.outlook.com (2603:10b6:610:1cd::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.4; Thu, 12 Mar
 2026 00:29:54 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%3]) with mapi id 15.20.9700.010; Thu, 12 Mar 2026
 00:29:54 +0000
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 11 Mar 2026 17:29:52 -0700
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
Message-ID: <69b20900be8df_213210055@dwillia2-mobl4.notmuch>
In-Reply-To: <20260210064501.157591-7-Smita.KoralahalliChannabasappa@amd.com>
References: <20260210064501.157591-1-Smita.KoralahalliChannabasappa@amd.com>
 <20260210064501.157591-7-Smita.KoralahalliChannabasappa@amd.com>
Subject: Re: [PATCH v6 6/9] cxl/region: Add helper to check Soft Reserved
 containment by CXL regions
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0104.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::45) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|CH3PR11MB8774:EE_
X-MS-Office365-Filtering-Correlation-Id: d0bdc7cd-6b60-4375-f2ed-08de7fce7b4c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|18002099003|7053199007|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info: HKwGvPXmoeU+xRNTKxlqQljB/So6KFYYLhJASsTfPTjWAS6UDW41dwRDNod+AXsGE9uUZW2umU3UmsH4e9j5z99c1dVFrDbp7+BmVaY62tA+SfZCqxw6DYNRGSVfkewToqUJmlThhF0Ofyn+TGxWg35679lDdHIH5Sg0HOkNIYLkLUcE2kr3coSEVnGjEqI+ahZ3Yyd1F6Lr3VdrR2SEbc15QTOO0xx0iVM1vx2y8v0Cx0ss/5PgHWjwBH4NOrxuZ/MyIOFnHT3SpRIfkU/7IR31Xib7p85VEyyfrwKX3xWJH/2MW0FWbZPsY3dzSHUeOlwTGNY9BaLxKRgyuOKyHNVA3MlDNjO9Cm38l+OpvFJPlYBo1t/oY1HwdtV8YtRnQibuGwNXu6IippQJdvXCOVgW4/HmwdqyF1Ff6e5nSjSSJbf0or3gOqzSPdo3AZ8IT+5u/swF381pQUGQ+nHC4iAZ/hyIkG5T7dagQP4CatYYAnVia3kFtVcUPhkmROpZx74ze3kg3KnSrH/B+XzZsxKnpKqh16KV+Io59SznkHdAdbRtF9he4ZHXHwoHNpYVs+vtC9nAak7GWj01KSN0FMBSaSVxaqxlbQ33JnjM0fNOzk87VedNAnOaie2xYGMU7Xh8H73sHmgXKtCD04kg98rM4QoAgrwnYNF8g+G1tO3vldUU632gqAfKb+YL/uTNZH3f4Wxt3SlMESoW8KzgeudEg205QdjHsEl0HTV7IB0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(18002099003)(7053199007)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YXJWK3liUEZ0RDAxZGhycHlSQU1wbC9TbXFSVDdzS2F6dUVFY05Td241bzln?=
 =?utf-8?B?cnQ3ejRMcWdRMDZHNWFieTZUVEhUOWJDWHBIVFFmUi9kc3VBck9HdmFLR0RD?=
 =?utf-8?B?YkRjZDF4cUI3WlRqYURFVXFJOWVJSjRkUzc1bHlvRmhSN2d5V0JDRC9xUUFt?=
 =?utf-8?B?bENsT3JkTU8xdUlYVlNmNWZxSHVrM0phL3EzOFFjQkp6U2t5M0ZxaEJ2MHFk?=
 =?utf-8?B?MVBrM0xNR3VxY0czVlhwQ283b0ErZWROdUpnaU1LQ1BNOUp1dEdUNmJYd0FR?=
 =?utf-8?B?bkxqQysvZVg3S0VnZFZuNGoyQnZOVkxTbGJnNWlNbnFlMmdEMW1kb1N2Q3Nq?=
 =?utf-8?B?Yk5LTFBJVTVpU2w1bmR2ZGRLc3U0RXZBSzh6OXNqWGo3QXA1OXI3bDZ2Y1Bq?=
 =?utf-8?B?S0EzOGRpMkQ5ak5laG9xQ1ZBNkFhSjVHL3I2dlYvVzZ0Q1ArQklrMWFsK3B1?=
 =?utf-8?B?ellmM21nalJPUURNb1RzNGxhdWVGV2dtNUtYMkFmY2tEQngyQW42VjhSV0p4?=
 =?utf-8?B?UFk0Z0lQcndZNEFrT29ud0tydHlLQWt5RXdwb0Z5eGtaY1U3SGFDeWxXMnE5?=
 =?utf-8?B?bGpidVFnc1JtajJXeXFFdW5FeWtrMU5ldkxGU1BaRWsveW1URCsreklzU1Bw?=
 =?utf-8?B?SlNURXN3U3dScVM5NDNhWjZITG0vUVdhbWhsUzVYN0w0eUtKeElhSERTZEww?=
 =?utf-8?B?UTk2T0Joa3hBY2g0cXM2NkRwOVlkN2JPWE5CZ2xUdXlwZkRYWjRUSUZyeTJV?=
 =?utf-8?B?UEVqdDI0Y2Z4elErZXJMSTJzUTNrYUNxaWlTVldxNmM0amk0MStSV3pPejFv?=
 =?utf-8?B?SXRMZTd3Q3pWeFE3T3p1TUYybksvMFVvbHQvK1RpZ0FYSG50VnZBcm5qaU1Q?=
 =?utf-8?B?aXA2TW1GemZTTFkvbVE2czhYbVdxNGxlWVRkTGlxUmZuM3FSdjZodDFVT1dS?=
 =?utf-8?B?V1dXQjhnd2VtMkQwWDRnTVlEZ0lvTkNnS0FJblVDanJ6RUVvSFVCak9ZS3F0?=
 =?utf-8?B?SHBqM2FwZVhrN0RZZWpqL09JblVKTkhneTRpQnFtSEhVYzhKV0l2U2hIeHd5?=
 =?utf-8?B?V3BaVTZPZXg1K2czdDhGTnhqQUZSLzFIRVpkSnI3KzRxNDBZelF3WTl0MXZR?=
 =?utf-8?B?S0hBeDdhQU4vcWRheFhiODNmMXpiejFJaDFPWXFRSWZkbjZ3bXpLdEZyV3BO?=
 =?utf-8?B?OUhLSEg2OFJnTXBsbW5tK3oxUkdtVjlpVU5kOENxelNUT2dldDF2eFVSa3hK?=
 =?utf-8?B?K3Vkd2d6S2U4MkdXNW1DTXlVaXBIa3YvSnlKcFlBbTBxZjhNRG9zQTJtTWJC?=
 =?utf-8?B?d01UNjU2dkQxc1U1azVacG14U05keVBDZ3M1YXVVWGtNQ2xkM08zSWZHdEcv?=
 =?utf-8?B?cEdCQmc1cXp3SGRmUzZlRVd2NzZnUHd1ZHdhNFR5UXFPVG44Qmp3b2FxUVJo?=
 =?utf-8?B?TWZZWDF6M3hzQzB6aHBjaWJYL2tPNGltalJtMllaZllXcG5qK09xRjBGenJ3?=
 =?utf-8?B?RnVjYnYwV2dRWk1RMDV3aFFyek51cDQwN0g0QzNIclZWbnpiY2dsdW1jamE0?=
 =?utf-8?B?YmFlUTR5OW4xeTJwRytXV3AvYTBsVks1YkxRa2xVSHU5Q3Q0bkRqV25FMHJo?=
 =?utf-8?B?N2hDemVtYXZMc0g4b05GNkJ3K3hxa24xTTJaVTdtZkVNVjhRUC9PbVl1a3hR?=
 =?utf-8?B?cWcyUFF6SjJISzJ2RURURTlGV2ovQ2JITzBWaTVCZ2J5UDdKdTFQMjhSeStn?=
 =?utf-8?B?QTJjaDV6cGdyeFFQa1M1RHZCa3lpQVV2VUJhUHBtdk95UE5MVDlxTGl6L29s?=
 =?utf-8?B?bGtINTZJRDBxRE1mVjkrYWJic0V5anNXVUZRdGpqVGZlaU1wUVlHR3dpclJV?=
 =?utf-8?B?NUZ5VmFKb1VDa09FSWJady9LcG9LZWQ2WTdydGdoMEthS1k0THgvdXMrd21j?=
 =?utf-8?B?eUVZYWhIRjFhWlgvVWlpVS8zQklVdGtXOVRaOUdvams3SWY1SUEyL0xsYk96?=
 =?utf-8?B?bVFwWlJyditPZGpieTJYQ3c3WWU4S0lqQXJXVHd1T1piOUhQai9URHI3VDFE?=
 =?utf-8?B?S1BqVUU0TnNhSENKS1hJbzlpaG4zNENXTytlL0VDVGIxaHR5V2JzaEpGbkov?=
 =?utf-8?B?cGhjQUZCbG1kZVJGM2Q1ZVFYN1VSbkJoZjBkOG9sZ3I3bndROHVEMnNhSVB5?=
 =?utf-8?B?YVBsSURtSy92VGs2ZDJ3T1I5cDFYYUh5dWdnRS9DUUVmd0hMWHVpS2FORytP?=
 =?utf-8?B?YllqTGl2dHJDYlhNTkNHV1VvWGVRV1BvZDVwZU5wYzdTeERaUlIrYkFqQU1m?=
 =?utf-8?B?NzlkS0ZYZUpKMDlFSzdja0dpTHAzOGVoREpzZ2hWVHpsbUloOFVUUGp6bEk4?=
 =?utf-8?Q?jzvsHeIxOra7P1/k=3D?=
X-Exchange-RoutingPolicyChecked: HHHY6pw99AajhALuWgC8UrXnseaa3Iyh0ko5HeDUKG5Sc0fhQpQLhfAtlacaFNL56GtlWbG4Mw0ijio8sBQ8EcK5ADBWCdPuFuhTZ4Do++4Zro2QMltdA2zKQ8rpwlwIhi3momMGrWnbnr1j2DTS7TQG8+AxbxckdsvetFwQl9Za2bK/XlXlnETic8AABjDdJKkrBgR8i7y9HlSgTgcdNKnoo3kHTu0agE3gKXQ/D7zGHMm08oEBfXHgpCV3wCbzlEKZ9wgoXN2yENqyG+hMJ870yF22C1mQG7UsGf9H63TOa3L8vSMfmbWaOjWCYu0li6HFzSRCj0PW69OGEhinfg==
X-MS-Exchange-CrossTenant-Network-Message-Id: d0bdc7cd-6b60-4375-f2ed-08de7fce7b4c
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2026 00:29:54.3502
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SVo5kDsPBCDVsjDQScjVN9EyfZKXDp0ljNQGwh2lKy0pWLUi1TzkQzj2TJmiotoiBPpep9nQpVDzZWqwVAMoTfYZZBgOXmLojTH1tFaS6ys=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8774
X-OriginatorOrg: intel.com

Smita Koralahalli wrote:
> Add a helper to determine whether a given Soft Reserved memory range is
> fully contained within the committed CXL region.
> 
> This helper provides a primitive for policy decisions in subsequent
> patches such as co-ordination with dax_hmem to determine whether CXL has
> fully claimed ownership of Soft Reserved memory ranges.
> 
> Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  drivers/cxl/core/region.c | 30 ++++++++++++++++++++++++++++++
>  include/cxl/cxl.h         | 15 +++++++++++++++
>  2 files changed, 45 insertions(+)
>  create mode 100644 include/cxl/cxl.h
> 
> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> index 45ee598daf95..96ed550bfd2e 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c
> @@ -12,6 +12,7 @@
>  #include <linux/idr.h>
>  #include <linux/memory-tiers.h>
>  #include <linux/string_choices.h>
> +#include <cxl/cxl.h>
>  #include <cxlmem.h>
>  #include <cxl.h>
>  #include "core.h"
> @@ -3875,6 +3876,35 @@ static int cxl_region_debugfs_poison_clear(void *data, u64 offset)
>  DEFINE_DEBUGFS_ATTRIBUTE(cxl_poison_clear_fops, NULL,
>  			 cxl_region_debugfs_poison_clear, "%llx\n");
>  
> +static int region_contains_soft_reserve(struct device *dev, void *data)
> +{
> +	struct resource *res = data;
> +	struct cxl_region *cxlr;
> +	struct cxl_region_params *p;
> +
> +	if (!is_cxl_region(dev))
> +		return 0;
> +
> +	cxlr = to_cxl_region(dev);
> +	p = &cxlr->params;
> +
> +	if (p->state != CXL_CONFIG_COMMIT)
> +		return 0;
> +
> +	if (!p->res)
> +		return 0;
> +
> +	return resource_contains(p->res, res) ? 1 : 0;
> +}
> +
> +bool cxl_region_contains_soft_reserve(struct resource *res)
> +{
> +	guard(rwsem_read)(&cxl_rwsem.region);
> +	return bus_for_each_dev(&cxl_bus_type, NULL, res,
> +				region_contains_soft_reserve) != 0;
> +}
> +EXPORT_SYMBOL_GPL(cxl_region_contains_soft_reserve);

To be specific, this function is simply
"cxl_region_contains_resource()", there is nothing "soft reserve"
specific about this implementation.

With that rename you can add:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
