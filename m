Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7AEA247280
	for <nvdimm@lists.linux.dev>; Fri, 16 Jan 2026 02:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768530851; cv=fail; b=BrNjnjex3nCp7QARma0CQDzi4u/n6FOGyiBqh4AMdR72y+l9cLiRkn6KyaJTubqsbN8aSTlI3yN8PWa+EnK+p626UdDzU3fDJGd6mkyTHaOZaT8ORL/p8zb1m49pv7J1Mlp+gQtXKj99/A8dxl2ZdY+XR7pkZA4KfeXPrMbWnok=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768530851; c=relaxed/simple;
	bh=DXAiKcnN8yOUKkOhBTkmEO+T7jkV6tAHVUoq3pYKhS4=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=Sdci/mmSeDb4UdaWHz5rPWdcaw3ZgxpnLgOZp/AjBTOKNUG+QmjegamXX2nPNYIFI/svFfLV76xpKJAEVXB7FFZdBHMfq9d7mTgPv6SaPJBQeUFdfb4TAAfMwdACKEkoAUZMPXlh285wVq9JZHx/Lbd8xJ/X877ycnXFm1Zwsy0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BD0bBvuV; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BD0bBvuV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768530849; x=1800066849;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=DXAiKcnN8yOUKkOhBTkmEO+T7jkV6tAHVUoq3pYKhS4=;
  b=BD0bBvuVqsqsbAg4EGX70liDsJRaoRnbjEOYiMWIvrdOPsb7uVjNYSO1
   fGHhHZFgDSSkuEy/8tVUIz0kTFYAbK7zcdiz1gBMi4qd4Xz2wepB4D8Ay
   0a9Epo6soSQ+MY8vC1zOwd7dUcdJDj0wM7LgLc9b3oxOL1sCDPGKOM7Sq
   BfCufjYLA5euoFoM1o3PYr6QalMvEWYJ4grvDsZz8CvillJH9y9Hz/tX4
   OEPEGwKU6jNqsLzISkHmjyrFOs43OJyJZ+e6X4OfwFvTx47DRLeDHkr69
   tVFaDMbFzJZUqjPhQIDLE/njdsHEby9Ilq7O748vxLRWSSNkgP6NFV9bt
   g==;
X-CSE-ConnectionGUID: +QZZQoO7RkGfodDJpvnFxA==
X-CSE-MsgGUID: Mmz8UDTPRyq1naLZcBtgQA==
X-IronPort-AV: E=McAfee;i="6800,10657,11672"; a="69743041"
X-IronPort-AV: E=Sophos;i="6.21,229,1763452800"; 
   d="scan'208";a="69743041"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 18:34:08 -0800
X-CSE-ConnectionGUID: 5uERGgFbRUWB8lwMbbq5MA==
X-CSE-MsgGUID: BWuLkjMQT5m3arQQMwsPtQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,229,1763452800"; 
   d="scan'208";a="242668130"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 18:34:09 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 15 Jan 2026 18:34:07 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 15 Jan 2026 18:34:07 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.64) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 15 Jan 2026 18:34:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=joj4VYGorhHR4wH8G7Db6zrgHqvjgtc+ixqXns/EZ/NKEfNpKvjmTqx91RuEfufbk7blvYUH9i/eRqaLXx3P3iNHg7kmJsJFHxrdzWLkG69B7E6zM3UYpmEPDpAN+edT69sv/MwVed4N8NJXjr9+R6M7UxHNntDFbm+5VJU3+SwINW2UyOxvTmODc/jGiMpD8XoygoKf6Icw/qXFLDaiGFaOhoDuMTdrJ7nc+qQhxv144fQeudRo/lmL7ZlNND7sZjKgJjugEgQ6IbqNMdc6ppgUVbj2lXqOzvsmF4OGnzJqfgVhIjDej2/FYqWROZNVwJSwfZ2jITpZP4J0jLbwvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DXAiKcnN8yOUKkOhBTkmEO+T7jkV6tAHVUoq3pYKhS4=;
 b=af4Gxf3C3eKqZlpfMVnI5QQd9zMypd5y2ocWHFUWq/vI0ki/V5x8/dBmRUiN+bE1tBsxdiRsZpKvEa1Sbzy7+AoP+APyzKwoOu1IgPxwg1expGADzdFLlMR57xMQ5gGsxSamw5oFmEOMajwcSXru9Xqok7nInUPphgqcnB8CZlrGmYUXKaHP57iUahYWtU3LYWrNUNP9OjoSVKR2hMUh0q+a8pFafXSI6WiRpG+D3TU7SL0q6VAbW7OePgGYaF5XFxe9Vxu2CGEY6GOfS45OXq60ZGg3BiaFeH/SUSY8gDgUdm2+5nkXaqhCoDnDGK8fVY8M2MVEScnTiF0zpmDgJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA3PR11MB8118.namprd11.prod.outlook.com (2603:10b6:806:2f1::13)
 by LV3PR11MB8743.namprd11.prod.outlook.com (2603:10b6:408:20e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.4; Fri, 16 Jan
 2026 02:34:05 +0000
Received: from SA3PR11MB8118.namprd11.prod.outlook.com
 ([fe80::b2e3:da3f:6ad8:e9a5]) by SA3PR11MB8118.namprd11.prod.outlook.com
 ([fe80::b2e3:da3f:6ad8:e9a5%2]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 02:34:05 +0000
From: <dan.j.williams@intel.com>
Date: Thu, 15 Jan 2026 18:33:56 -0800
To: Alison Schofield <alison.schofield@intel.com>, <nvdimm@lists.linux.dev>
CC: Alison Schofield <alison.schofield@intel.com>
Message-ID: <6969a3941ec49_34d2a10080@dwillia2-mobl4.notmuch>
In-Reply-To: <20260115221630.528423-1-alison.schofield@intel.com>
References: <20260115221630.528423-1-alison.schofield@intel.com>
Subject: Re: [ndctl PATCH] daxctl: Replace basename() usage with strrchr()
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0208.namprd05.prod.outlook.com
 (2603:10b6:a03:330::33) To SA3PR11MB8118.namprd11.prod.outlook.com
 (2603:10b6:806:2f1::13)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA3PR11MB8118:EE_|LV3PR11MB8743:EE_
X-MS-Office365-Filtering-Correlation-Id: 3cd9c253-3761-4898-80d3-08de54a7b80b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WGMycHhpQlUrTm1obHpiSDBnYkNVbXNOQjhYbGxSZUVVdzJWQUw3bTI0Tmhi?=
 =?utf-8?B?cXRuL3RxYXhKVDI0bkdZU2dLQmFpK3pXSldtQlBYK1VzQUFlVHRxSnkxMW03?=
 =?utf-8?B?ZXBURGtYMHhUOHF3ZDJ1RTVIYVNQYldCTXhOMThCdGV2anNnemlGZXc4Yk5H?=
 =?utf-8?B?alluSnd3SXprVGQvN0ExclBndWVnWjhTUEFTNTNYMGxYRmtmV1I0cXJlQmZa?=
 =?utf-8?B?WFhHdDZ5MGdkOGliZ01GM0IyNDl1MmI2czlRRUJNaFFidHdrRGVMNWgwMmlC?=
 =?utf-8?B?MDlUbHdDckg4MHhxYjl5aDVJYzdBNlplWXNqQWV0bklWNVY4NEk0K0xNU3Vh?=
 =?utf-8?B?RGR0b3lnUHBiUmgwVVVaZGxQelU4eUIxRXo2aU5ENFNZTWp6TytHa1EzZ0NY?=
 =?utf-8?B?SmQwUWMwOCtuVkdDaE51RlBoRnJJVk4xLzZtbEtnQW9wQjBwR04vbHRnVlFi?=
 =?utf-8?B?aC84RTNIMnFud2REcnhGSXRTc3Rvc0tVWEJLaGtCZ0VCdTBNeGdZclEzN0R6?=
 =?utf-8?B?RHFtNlhMQWtaZjlMMFloa3Q1MEFONVFWdTJDNkVqNnpNYXR2OTk4MFMvZ05j?=
 =?utf-8?B?akZKTCtjeXJ1YnByVkVOaFhsRGt1WXZTK2pORHdmdHUxQ2o3N2lCVXNpdG1J?=
 =?utf-8?B?dW85bXlzMEJLUTJxMjdjTzdhYzZJSEttNHZIVFlGY1FHZ21JR3hKTmVxRll6?=
 =?utf-8?B?QlhNamdwWFJjei9DMGNLRkNhdFlkUjE5UVpWUzBFTTVidlBDWE9laWlwYk9N?=
 =?utf-8?B?YjBIWjBONEpGK3pqWVNSUTZlZ01WSUtLVkxCMk4rWXRuTTZJWDVacXpMUlZj?=
 =?utf-8?B?YXpldEtyeTRLa1V4czBOaFMxM2dDYm9hdk9jQWVYcWE4cFFsOFJCc0ZUeUx6?=
 =?utf-8?B?NmJMM0cxb3labDByTFNlQk1QRW5mckprWGV1OU83Q0VYRytwcTZ4cEtuOVpR?=
 =?utf-8?B?WktvbnlncE5zU3FvdEN1L0dPVTRrNUdMemh0cVJIWjdwaUkyYU50bFBURW5U?=
 =?utf-8?B?Z1VyeTlISmt4eGhaaEpkeHM5UGx3NFlnSW9Rc0cwZ2dSRmE4akNvOTdGNEV2?=
 =?utf-8?B?SVdkS09OOWhFU0VKR1A2N0FoL0ZXUU1mUjNBWHgxMmFLNjlZTVJVcWltOVJu?=
 =?utf-8?B?N2pwSUdpWTZWZ3Exa29uQ25nZTE2b3FpampObXJLOVVEd3dCY0llMkJYTjRE?=
 =?utf-8?B?anhRaE93bXlwM0grT0VpRXV1MjlWaWY1eTFtZm82ellGL1lBL1dhdXY3c0sv?=
 =?utf-8?B?THF2aS9xbDQwb2dIVFNCaDVqd052U1FOd3crb2hzWWlpdUUxYmZheUhqTUZB?=
 =?utf-8?B?b3RmcWRnK2lyY0dnWGpRVW5mZ0xqU3EvUzdPdnU0TkJYcDRzNWJwbWdTZzUr?=
 =?utf-8?B?T3VOTW0ydVlxNkRCWFNoYnFBVzhXenBuMmVLN1d6Z1BJMENOcUl6MDZnNmtr?=
 =?utf-8?B?QWNyQW9ONC9VT3NUaDUwdEdvQ25EWThqTjEva01xLytrbWZwUHl5dUxQeEk2?=
 =?utf-8?B?QzFaNVM0ajBkRDB2MjM2Q3dDeE1ia3ZLY3dTRVM4U28zNklGaElhWE9VRVl1?=
 =?utf-8?B?V01ZVm1qYWt4Mm9VcmdEa1FCQ3QvWHBJM3RHUWYxY25udVg0N256dEhqYTFH?=
 =?utf-8?B?MGE0Z0FXQnZPR29oblBhRU1MRTVzV3JpcjZoUEhRQlEraDcwM1hjUkhBOU0v?=
 =?utf-8?B?alpzQ282aTFwV241cmVPbGZSLzRSRlM5cFRnVk9ob0tUT0J3K21wU1VtWFc2?=
 =?utf-8?B?cnpobGxMWXlsaGhmZUxrVVhxbDBmL0g3cGRoZE5nbEhtcEJ6WHFSUldJYU9r?=
 =?utf-8?B?UEV1TU85QzZ0d1ZBc0FnTnVwVG1ObzR4V0Z4b2VmU3RIODNtanpLMVRsV050?=
 =?utf-8?B?aHBrWTJHN3VHUEd1Yk9Na2l0aXdRTGc3WGhLWkppZ0luaWRlY2ZBdE5uVVZR?=
 =?utf-8?B?L3VybHpzZDQ3UGJlTnhEdUJFVG5hV1pmeXJaUFZBaDIwUS9aR1BEVHhRbVZU?=
 =?utf-8?B?WUU3SXViNERDcFd1d3RNZlNPU2FjSE1xNkFqbGhVbVNyS21QRGFGaEJidFds?=
 =?utf-8?B?QVJ5Yk84ZGhEcEVCMnpvTFYxTkdIanZHbjRvdFd4NnBFUjlDK29GRWs5Rmw1?=
 =?utf-8?Q?OVpY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR11MB8118.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RnozTzMydGFqN0JRU3l1SzErMEtza2RnZU9qTGtiSkJFWHF6K2kwd3k5UnFJ?=
 =?utf-8?B?cGVjcDlFcUV5aUUveVZ6U2JkT2hlREd2Q3BPRkNTUC81ck9zc3k0NzZiNlQ3?=
 =?utf-8?B?Z3BtWWZmQ05lbURvcnZXelRMT2UwemxWUy9NL2NEN2pQYjg0OE9aa2JoclJp?=
 =?utf-8?B?K0Y0YmlXZytyeXFrRXJ6bkdOSW9pSmV5NmpMYTdFUjRxS29zbEJGOWgvTVlt?=
 =?utf-8?B?eHdueVh4a09IL0RLRUFLUVVEODdnTzNOTWFibEQ0NnN5YlI4TDVmUW5PVUJi?=
 =?utf-8?B?SzB0Z0QwOEFUZTd1OTMvanlPZUhTRERacnVHNXFEZm5ySHVSYXBNRVBtS2Ry?=
 =?utf-8?B?M2pwbjB6STVJdU9uZWdnNnh3VnU2bnhIajhGNVc4MGVCM1BCTVhUNmVFcnM0?=
 =?utf-8?B?dlliWTRIR0J5eFF1L2V5RUhyakF4RVYwMlFJczhLVWZkZkRJaXZqdXBJV05U?=
 =?utf-8?B?dlpiclgrOHhabkpMdzBCSloxbUJDOG16a3FHcEhSWXJVd3kwNmJnNnV1bzBs?=
 =?utf-8?B?NWw1eFd3WFVtRHJrb2pkQmhIUGpIVndjenJGczhLN2ZYRVlMZnpDUzZHMTZQ?=
 =?utf-8?B?VldKZ2Nya0hsS3o1QWlra0dlQlJnVnB5akgxdVY5OEl0TjZoK2VnWExQOHNR?=
 =?utf-8?B?TlhOQkNmVHB5ejg3dzhSOURqbFRBWDhNb1lnUVhTZDBzT0krdjNzRWk0QTF0?=
 =?utf-8?B?VlNyeUY0aWltbUVmd2R5dzJpV3lBR1RvaXFMSkpYaWVqYURzWFQxQkZ6elRm?=
 =?utf-8?B?SGVvR01BNllMemE4TllTRjJlczkwcVRxc21YMC9HTm80amJ5RkFQeE10dmVJ?=
 =?utf-8?B?WnVsdWg3Y05SbGtrT1BhTGRNRU1TS082Q1FyVVl6U3Y5ZUFCUW9VbUJ6MTBJ?=
 =?utf-8?B?ZWtvQmJyM3hPaDRaNmJ0NVgyYjZJSlZONEdHUExvQjNZQU04czd3ZGlpdGps?=
 =?utf-8?B?aHdHS2c3akwzaHYwQndYWThCVlRaL0NPWWFWRlI2bVkwMnFrYjhtRVU3YStO?=
 =?utf-8?B?aDAvdjFKY1h1enArUWkvSnVYVk4vYWFiT29palFpWlVTaFNoTUxpdzRnN0ZG?=
 =?utf-8?B?NkQ4dWZuSEFqd0xBcVNNbW5GdXJlKzF0NHNya0ZOQ0N5QWFwcTZ1c0N0V2pX?=
 =?utf-8?B?WkFKdHN3UU1CTnRDWFVyQTF5Qjh5cm1iczZCeTBTTVVGd2lrSWxaUklCVkt0?=
 =?utf-8?B?ZlBPdkh2NWZHcGx6dXVNNThVYkpsbW9tUTlRcU8wYmhsYWIya0dISEpWMzVk?=
 =?utf-8?B?VWwzSFRlcitNd3lCUmpNWDIzNzNNTi9aaUxHS1BhTEhpdzZFckU1SkpzV3gw?=
 =?utf-8?B?SEU1LzZ4SUJQMllQRHVTMjAvZkpFVTNqelplQnFYS2R1cnJDMkdHM1RrRjln?=
 =?utf-8?B?N3paNVY5QWtMRkJkd2tGeDF1UkNhNFNoZlh0TjdEVmtrUjlUQmhjUENjUU4w?=
 =?utf-8?B?djFjOWJTVXpTY2hFVXp0dTFaT3BUOTAwcUh3dk95QWhwWjVmbWtadDJ5K2lC?=
 =?utf-8?B?TzF4bDVYeHVJMzh4c3c3UHVjOFFXejVCMVEvRTdoaEVWYllzRWg2NldUN2Ri?=
 =?utf-8?B?WGpmMFh2RzZaYlBBdldCU0xBY3NobEgybVdQS2RrZkxPd09PRHAyTHQ1Nm52?=
 =?utf-8?B?QWhYbEFQSllYMFpIeFJOa2FZNWZPTlh4SnFxajduV3JuWVBzeDNMZmQwVWRr?=
 =?utf-8?B?Wlo3RHd3ZGlLUGN0MGl0cGRjMFR3MmdjcE1UUS9mSzU5MWNTRkR0STZQN2l3?=
 =?utf-8?B?WjlLa2FVTHhqSDkzVkFwbzE3OVI1MEJTU1lBdm9PL0N1NFFReG8xdnlCcGR4?=
 =?utf-8?B?WFRkZ2NpVlgwRHZSaFpWZ3Fnd252NVRhTjd3Uy9EemlpVm1TODVXRmNaVGdp?=
 =?utf-8?B?V3JVaWFkMHFzalRWVTRFSy8rRnlLQnF0Q29QWGhLZ0N6c3hMbCtGWFdVVVMx?=
 =?utf-8?B?dDcwK2ZVNHdjZTVyR1FHYjJtZ1VFbTIwMURtbldUcW5FMnBhMml0OVIybEFI?=
 =?utf-8?B?QW1vaXk4SUMwMUVmNDBnREZJNG9VVGlUMHEyQzhzc0psYkJWV3dZT2d6UHdX?=
 =?utf-8?B?ajNZZm9DbW1veU9uT0FMWkdxOXRpR1ZrNm5DL1prVTJ2YUFCaGlDRDE4VGR4?=
 =?utf-8?B?ZVpjWXNlYWthVDVvaVJZS1hGNjBsbTh5TnRsQXl5NDBMYktyRmh5YkJmQ1Nw?=
 =?utf-8?B?cGxubFZEL3dzOXJHZlBBTkIrc0E4dU1qMWpwOENHNHZtRnpoSXVnazIwSmph?=
 =?utf-8?B?aWRiNHR1bDB6RGV5c05HOExPMXJxNytlQjdrQ0M1S3I2b1ZOU1RFY1ZRL2Yv?=
 =?utf-8?B?SGh5V2J4cHJDMzdIemZIT1RiU1VtWWxYT203SWg5b3c5MzdZbHdyWEs2bmV6?=
 =?utf-8?Q?M/pgCJWj1q/Y2Na8=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cd9c253-3761-4898-80d3-08de54a7b80b
X-MS-Exchange-CrossTenant-AuthSource: SA3PR11MB8118.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 02:34:05.8415
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h96MFQWMzDfko/qpn2ov4pR6PsRA+tg1xhwjpC87Y4iFV2tBJ20Od43ECqraB0oTFFCsms5YYa0isCKmNLxyxi/O3SBFJfr8VRyFTmLjTv0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8743
X-OriginatorOrg: intel.com

Alison Schofield wrote:
[..]
> Rather than conditionally including headers or dealing with platform
> differences, replace both basename() usages with a new implementation
> using strrchar to find the last '/' in the path and return everything
> after it, or the whole string if no '/' is found.

This feels like it wants a helper rather than a new open-coded thing.
For example, devpath_to_devname() is an existing similar helper.

Alternatively, just create a local helper called basename when the
C-library is missing the GNU version.
