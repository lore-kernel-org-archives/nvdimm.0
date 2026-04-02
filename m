Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A2D1A0712
	for <nvdimm@lists.linux.dev>; Thu,  2 Apr 2026 02:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775098775; cv=fail; b=Za+2t+4qocIPjzNjd5vgCeiK0MuirC+x6/ezJfNNDImwpwcRr+ek8BfjzwnK/On9efA+QcEmpzOtMfucTYwKF0tRsmWnB8JRYsgUutckkeqcmKMmvOyCACTCZdxkjRi6lzF0y4Xurp9zrLTh1w9souyyb/xrzMUcpT7PMcgmGs0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775098775; c=relaxed/simple;
	bh=yCqTscS51ZCBNGxH6azA8WCCoXtyzNG1DODLJUNwmRM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=W/lhNsdnvo4sAJbNstqUaL6wk2tkorU/5cl+FkEr7oQovUNAKXM6IYG0PQuVUqnYTguAzuzz41j2olMfzdsZNOEgqC35sVkg+6df8HNf/g6fJL86M7zCUbcN7LbT1Bk2YVPUdxuuiVOYZ7ysnWxDnA7SAxVmeGz6ep6t0Paw8KQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PrzDSl0E; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PrzDSl0E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775098773; x=1806634773;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=yCqTscS51ZCBNGxH6azA8WCCoXtyzNG1DODLJUNwmRM=;
  b=PrzDSl0EEIVl4kBkMTXr08nQfin8aIgkxMNvydgYAFjvTF3IuBf33J9R
   jC7W4KH9VNpgtkG8BKMQCfCovnA12aq+5x9ih8SWbR02bRZKPWS9amXo0
   B3+riuE7goO4WZC7Tvlci4FBTh23FC0jNC5u3cxOHU0tXLsY99vSL29Vy
   +xPiyepC4trwWOIJOgZdXSp7T47RgjFL3ONP4kl3sFTdN7qYcRyS8NlJV
   YAYGNdE2y3r9qqXVPxUkoF5RefM1wywmNVHKAq0WsKbBLXWILIhFdh/fm
   92qPNwUduiP3lCCghOUFnuyKYfM98ugnW8RAJaCkBqKyt2UbZdPHGdnXA
   w==;
X-CSE-ConnectionGUID: DXHPb0OFRWW5Ey5bqdwTpg==
X-CSE-MsgGUID: EWNaxAY2RMuViGg3bTM/Wg==
X-IronPort-AV: E=McAfee;i="6800,10657,11746"; a="98764863"
X-IronPort-AV: E=Sophos;i="6.23,153,1770624000"; 
   d="scan'208";a="98764863"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2026 19:59:33 -0700
X-CSE-ConnectionGUID: qeGHplEWRcyuVcqljYtdZw==
X-CSE-MsgGUID: MDHjugMyQOekIp0hHvrsZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,153,1770624000"; 
   d="scan'208";a="227109144"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2026 19:59:33 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 1 Apr 2026 19:59:32 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 1 Apr 2026 19:59:32 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.57) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 1 Apr 2026 19:59:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S2U2j2HILA8E6cgxJLJBaDmiDKIAbxwiSvDsO3jswXpGJbH8oNZLaXo/NzUWoyp7VQ1hqIRWAvyeyApdT9MSb3ESHvthnHOkxNthC2w9Ps9we5xsrAtHh9t4jiJjgcYfreBr+lxb22K04UE5vG5TQAP0a5wAava4W3+EbwckY7vv4lxnxsx88oQ3xcVdpxnWV90xcHaVGouZKFArTqZgIFkoxyGCN2JnJ7UciAGfI5OihrUbiydDqWecQeR8C9jP1y3X35ioFUot4MUMPhfaSJpXq+9B0msgHsDPw/3ldAdtA6g7ZcY73Y/tu5oNue5FVg7FUZ3pJnBxx0ChIEmtXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xaJKYdjy1cNa0+e8SFoNRBxpAYR6FCv6QOTcXEBlcfQ=;
 b=GgAP+vNuO5/4Ka9YQgBkBlx++7jTEyfe00RrZP7ixG0tLeF7ag034GfI4A3C8o86Jd2lfqQjCeRhWkODs0w4B2e/lQ+c5N6gFCQEokokJS2rYlc2vICmeLDdQxcPd+jt/8HPGrd9lmmylPlCbZ2wzE7gHIss90+SY09lpz6QezdfukD3T7JlizYxXdWTDFJZbyFJIM7XqWHJ3lGXNHISV0+IKd+7xALzCbk83Y5LhNuM663YQusHqvKu+RIGa0Hl9qeRgDpeZv0hvfxBUy689MK/uzqXcJI1/DRJZtKF4v9KcJt34nGhF0hhMw3Zlm1iv6BMysRjPOgOWslAndyqsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by CYYPR11MB8387.namprd11.prod.outlook.com (2603:10b6:930:c8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.6; Thu, 2 Apr
 2026 02:59:27 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::fa8a:90e4:57d4:8026]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::fa8a:90e4:57d4:8026%6]) with mapi id 15.20.9769.014; Thu, 2 Apr 2026
 02:59:27 +0000
Date: Wed, 1 Apr 2026 19:59:24 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH 3/3] test/mmap.sh: reduce fallocate size from 1GiB
 to 256MiB
Message-ID: <ac3bjLzNp0I_xj-U@aschofie-mobl2.lan>
References: <09ef1cacb6dcb0accae1756561b0f761a764aaba.1775018517.git.alison.schofield@intel.com>
 <f2ab6877b5895a95e2f7eccaa452ab29e6bc3b9c.1775018517.git.alison.schofield@intel.com>
 <2b2e0fe8-d163-43f3-b1b7-71d134b86fb7@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2b2e0fe8-d163-43f3-b1b7-71d134b86fb7@intel.com>
X-ClientProxiedBy: BYAPR05CA0091.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::32) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|CYYPR11MB8387:EE_
X-MS-Office365-Filtering-Correlation-Id: 020dacdf-57a2-4929-0508-08de9063da02
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info: sEiPOrLR/LJi4hBZNp1pcFd5LzRHv5H3sOMbYmuuq8aZ3F2oUYkzBTeJ4ThGhycQ3AOAjW+Ban9AMkf9vzXUzUllIHeTmeffzs7cSieoaJpsjyRB4j70VxtMDxg3pJGKEtUaF56F6tGwX5KobrSi/eKr/fzdhz0Y5jCZ83lKK+3nvWJ3g+nLCBbhuSA+Gm/RiOAGdzA6maFhoVF9QifE82DdKKzvOrqSvoakxN0td5gnt+8TkA4szwplLnh0VUu53auE53pwJZTd3U2+ctTDYDFhp0lIJ2LPueK1wy58YX5zBBh80v1sAHsG/VPpBxiHIdD1hGki5NgBgP76p5QYS7ehLWIR0ZMo1dmCWdueTIdhfiOCuX2RuBOkh0h1fOoCRQQOvSO5cLdwAwyrC72Hk4wYw1SHkCKKK7IDhyfJvSqwKIExVElcCpS0tdu+pmCvnxTQdkZeH4jXpBStRL2Q2MPfSmdDec9eV3lVan+6MeHemu/dbhRmg4Hns9K+BUxh/eaVeGoSz64wbz2QevmrCsHf3i9mtX9aVhKKUd6JO2Efw6UcSwMx3ZeJI6C0He7Ahld3vsLlyiFmI2jc6I2J1c01J5ExBvc7DPxbOMxHHeABU3+EugnOy13OITqg5gK6X36tQaBuPpytB1icjjyoIgLzoZzxBQm18g/FvjgYbPNRSj3RQea55PUv8P5joULCgZ6ImUiJgO2jYkUsJKMqmr8uMLMddtAu17KdPd0N+qw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UERKems5Yjl2UGFKdktMLzh3ejUzV3VEU29FWmRuek9hdU5oVTcvRkxXbEt5?=
 =?utf-8?B?YXZuVGRTaTdRenJNZG16SHBRdC85aVFOMzM5WGVwWFZxTVNqdmpXT3JvaGZO?=
 =?utf-8?B?SjdWMS82T2Vkekl1YTZJL09pNnBsQUJvTzdVR2p0S1JadTA2Sk9FTjZYcDhI?=
 =?utf-8?B?M25Bc1dhS1FpV01BVjVkNXF4bWFQL3hXR1IvNzhHSmF3dkgwQTJEQU9GdEZZ?=
 =?utf-8?B?TGkyUDRYb3lieGVXaG5iVU1LL1E1SXlYRUc5bi8zVjBGeXIzL05RZFFZV3JH?=
 =?utf-8?B?c0s2dmZHZ0V4T1BlU1VYbExleUpWNFJwQUFhTVZDVXdCSTJFUkVvL2pVcml6?=
 =?utf-8?B?QkpUZk1XUmNKSFlmNXNibkpBdGRkRWFNMmRzTDZhVWxWZUllTU1ObnV4UVpa?=
 =?utf-8?B?UkRFS2dSRFFydDh5RGFGNS8wQkZxWUJHZlVYOWFJdEpHS0dkN3NJSitadG5J?=
 =?utf-8?B?K1h0MGlzQ0w4MjVVYnZkTXhhTHZJUXMzWnAxc2d3TFVQZ3ZyL09mS1cvYVAz?=
 =?utf-8?B?bzBSOVB1REl2K1B2V0JmMnZDZmxHQ01teTNITkdBdC84TVBYNVV4Z0dlL0Ja?=
 =?utf-8?B?MGpORTJYc3Z4U2t5Tml6MlZoenNNNXRvYzdMSVllWGQ0bGowUkZwUjJYNTFj?=
 =?utf-8?B?cVYwYVR0WFlweUIxUy9udXEyazVaK0FYeGt1M28wUTBvNVh5MHhVblJ5bnA3?=
 =?utf-8?B?WFI3ZUJadEJhcFBGTkxpY0pGbU04aFhCVW9TcjhJbW1TNG1UM0F0U3RPQ2xY?=
 =?utf-8?B?dnNGM3Y4RTJLMklFY0p3S0tYOWNyTVJkZ0dSaFRJL0ZrRDV2VUZMcjIwNVla?=
 =?utf-8?B?Q1ZuQjd2WWR5UkR0cHoyMkJBbVNTRU96djZYSVAxT3NyMDhBNEdnY3IxVnAz?=
 =?utf-8?B?NlJySWY1dXA4ZGNuWEluUm4vMUJWdVhwQ3NsNDBNRFg2VkZhUXdoVkdDd3Zh?=
 =?utf-8?B?Uys0WWI4WUxGaHhyNCtpamRSMVM1TXc1T2pSMkd3bzhtMlg0cFplamgwenJV?=
 =?utf-8?B?ZU0rMUZHMU9iSFQ0Ym1tTDBaSVJzekRmUytKNkpjUk5VUnRwbXlZM0oxemFt?=
 =?utf-8?B?eHo0WEl3RnI0Y25RY3hLOWl5SHIwQVVqME85SmRMcFRQSTRYMHJ6OEtzbWlm?=
 =?utf-8?B?aktaUksrK0h2OUdybmNDeHJqNDNLQ08xcGZSTEpNZHNNeXlJUFdYazZhY0lV?=
 =?utf-8?B?MENTWXBNRnhFTGpnZkgvUU85aUVudDdMTWpyWVlXdGRpWFpXTmR4LzZWWDgr?=
 =?utf-8?B?eElFSytnOXY1Z2ZCOGVqTVpxWW9xYWlKMkptZWdPN0NpV0srWTQzalBvVUxQ?=
 =?utf-8?B?bWpoRDdmMjhlVzlTMFpEQkpKb3NXUDI2ZUd6Z2dzYUpvNWt1WHMveVVYVWZZ?=
 =?utf-8?B?TnFMZURBQ2NlUWVoeDE0clZBRjAxMDBWbGRYQVJlVHpjVG4zSkVBbVFnY00z?=
 =?utf-8?B?V0JuOVlDcUw5TTZYNnBrVjhlUmM5KzRXcFROQmNUSjBObG94K3BkdzZwTjFZ?=
 =?utf-8?B?R3FNV21XVFF6eDJISFJMY0hOQ2RYU0liUll0Z1hwcnVxbjdXWGNzb2lIcG1z?=
 =?utf-8?B?MW4xOUxBS2M2M3RsMkluZ2RvWjFYaU9PNTViZWU0TzZOVVhDYkovYk5TbnIv?=
 =?utf-8?B?dmRFQVdDVDF0Wnd5VkNtU3JURlI1QW12akx2M1pEbjl1Rms1VVkwMUtiVVFu?=
 =?utf-8?B?dDEzbTBPMlg0b3hiUThVTTJvYXZTR1lWbWNZZGlRQlh0QkxuUzd2cUJ0azAz?=
 =?utf-8?B?cEMyNzU0YmpERE9pQ1VJWHliang1Y0xqSkZpVEpKTUJTVWZ5TTNtTmo3aFlV?=
 =?utf-8?B?dG91eGNCUmZyZTFsQXNWNi82MU9McER5eWZhUmVwekZpVzhxSUZqTWZNRUMz?=
 =?utf-8?B?SUpMblcrelRiWnZZcGFpK05QdDN4MWZndDFXLytLYWVrS3FNWlpXOCtheVJt?=
 =?utf-8?B?Q2J4aGNJbHUrc2ZuNFNtalRrZW9MVjdraG0rQmFIdERjM25CYm5YS3NwaUVr?=
 =?utf-8?B?dDU1ODVOTlg3aUUvaUpXdzhPNU00OTd5QnMvOFl6cWVrQkZ0VEtaMkxxVVEr?=
 =?utf-8?B?b2VBalIrOWszcGZDZkFKcEVORUFBaXk5QkREdzlvSTRBODArUGxTNVpReHcy?=
 =?utf-8?B?cDRac0FTbUVWMmh2NkxBWkRxL2ZhSmp5MThhNFNxN0laMjNPZTEyUWZHZGdn?=
 =?utf-8?B?V0E3eWlkNkRURjRBVDJYT2ZQNjV4Z0pEeTZoVHRyWVh2aUFFTDl5V0xqYUZR?=
 =?utf-8?B?K0VVVVltTlFMWDVFVFhEcjY3aDhicGVjMG1iVjFLN2RMUmRrc0lJQzVsdkpk?=
 =?utf-8?B?Yzc4U3BnN1YxeGkrbXk4aGNmS3ZoQ3c2eXhaaHF4MTg4cVJYcEF4R1gxUWNX?=
 =?utf-8?Q?RA4g0qSq/VroGP4I=3D?=
X-Exchange-RoutingPolicyChecked: c3QhPprByUPF1kVzx9siYD9XQZAr0SWBXCp0PrATqHY1PdsLvchAyv+s0GBPx3vvYf1ojS5McDLRSC44rAW+x31i/y4CG9T6t4yeUOVbozu7FPAyrZH6UwIbpeZLP9haapSLOXWRl+DNFU7sOfWrOmLNEtzQGAMzaLc85zFeTqiseeQhsXVgR7dzXCrny0QQrG/0Uy8y+pxjKHqPKoYH0hvkZKS7Id7rN+3cmRzlNTvJfsH8Q2H/PPM59xQFrery+hzigbtYRpF7c2agFa6F5tbogt5BHNY0Iinvg9dp57V/p3PVuSTnnlNwjMMbWwSSoaz3BHJLDAI/d+GigwO2bA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 020dacdf-57a2-4929-0508-08de9063da02
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2026 02:59:26.9914
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TD9z3OdQDGI+SVU9EPDDzGUk93Vi2CtJz+WqTgyxRHPBk9yL1YyUayj5GcyaBMG/E+hZL3zqdWgDatFvuRBzvbOgxyRmLBUFGN7HJH7e+3Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR11MB8387
X-OriginatorOrg: intel.com

On Wed, Apr 01, 2026 at 03:53:30PM -0700, Dave Jiang wrote:
> 
> 
> On 3/31/26 9:49 PM, Alison Schofield wrote:
> > The mmap test allocates a 1 GiB file and exercises a matrix of mmap
> > flag combinations across ext4+dax and xfs+dax, performing multiple
> > full-range read and write passes for each case.
> > 
> > The coverage of this test comes from the mmap modes and access
> > patterns it exercises (MAP_SHARED vs MAP_PRIVATE, MAP_POPULATE,
> > mlock/munlock, and read-only mappings), not from the size of the
> > mapping itself. These behaviors are not size-dependent, and no test
> > assertions rely on a 1 GiB mapping.
> > 
> > Long CI runtimes prompted a closer look at this test, but the
> > reduction stands on its own merits: a 256 MiB mapping still spans many
> > PMD (2 MiB) DAX mappings and exercises the same access patterns, while
> > avoiding unnecessary work in each test case.
> 
> No excercise of tests against 1GB page?
> 
> DJ

Right on cue, Dave! That is what I need to learn about.

Reducing mmap.sh to 256 MiB would rule out any 1 GiB mapping coverage
in this test. Looking at the mmap test cases, I'm not able to determine
if the 1 GiB was intentional or required for the behaviors under test.

More generally, mmap.sh is not the only case. Several of the DAX tests
use "fallocate -l 1GiB", and I'm trying to understand whether that
size is preserving specific coverage or is just inherited convention.
I’ve appended a quick grep below for reference.

What I need to understand is whether 1 GiB is essential here, and if
so what behavior it is meant to exercise.

In comparing tests, the impact of reducing the file size in mmap.sh
was significant, while the effect in dax-ext4.sh and dax-xfs.sh was
much smaller. That suggests the runtime sensitivity is specific to
how mmap.sh exercises the file, rather than a general property of all
tests using "fallocate -l 1GiB".

In mmap.c, each test case maps the full file and performs full-range
read and/or write passes across the entire mapping with various mmap
flag combinations. That pattern makes the cost scale directly with the
size of the mapping for each case, which would explain why mmap.sh is
particularly sensitive to the file size.

I also tried reducing the 3 full-range iterations in mmap.c to 1 while
keeping the file at 1 GiB. That saved a bit, but mostly suggests that
the cost is tied more to the size of the mapping itself across the
per-case mmap/populate/lock paths than to repeated read/write passes.

I need to understand what coverage we need with DAX and 1 GiB and
make sure that is exercised intentionally rather than incidentally.
(And, yes, I also hope to cut out needless runtime.)


All the DAX unit test fallocates:
ax-ext4.sh:	fallocate -l 1GiB $MNT/$FILE
dax-ext4.sh:	fallocate -l 1GiB $MNT/$FILE
dax-ext4.sh:	fallocate -l 1GiB $MNT/$FILE
dax-ext4.sh:	fallocate -l 1GiB $MNT/$FILE
dax.sh:	fallocate -l 1GiB $MNT/$FILE
dax.sh:	fallocate -l 1GiB $MNT/$FILE
dax.sh:	fallocate -l 1GiB $MNT/$FILE
dax.sh:	fallocate -l 1GiB $MNT/$FILE
dax-xfs.sh:	fallocate -l 1GiB $MNT/$FILE
dax-xfs.sh:	fallocate -l 1GiB $MNT/$FILE
dax-xfs.sh:	fallocate -l 1GiB $MNT/$FILE
dax-xfs.sh:	fallocate -l 1GiB $MNT/$FILE
mmap.sh:fallocate -l 1GiB $MNT/$FILE
mmap.sh:fallocate -l 1GiB $MNT/$FILE

> 
> 
> > 
> > Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> > ---
> >  test/mmap.sh | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/test/mmap.sh b/test/mmap.sh
> > index 7d0053da0e1a..c517d5b0f50b 100755
> > --- a/test/mmap.sh
> > +++ b/test/mmap.sh
> > @@ -59,12 +59,12 @@ rc=1
> >  
> >  mkfs.ext4 $DEV
> >  mount $DEV $MNT -o dax
> > -fallocate -l 1GiB $MNT/$FILE
> > +fallocate -l 256MiB $MNT/$FILE
> >  test_mmap
> >  umount $MNT
> >  
> >  mkfs.xfs -f $DEV -m reflink=0
> >  mount $DEV $MNT -o dax
> > -fallocate -l 1GiB $MNT/$FILE
> > +fallocate -l 256MiB $MNT/$FILE
> >  test_mmap
> >  umount $MNT
> 
