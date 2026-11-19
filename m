Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=192.198.163.9
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795120137;
	b=pEG1aFyc4BCcxdagoFdfxd1jTGSk1vLwPlIc56Q9TScQxpqxI/Px0u/6GMxxIDZeHLFn
	 t2ZR/sbPW5kLHh6n79JG6eYHpb7e4XIlG8gE7uIBf9GwqUhet6nTW+1X5qGD5L+xs6xlt
	 FZ29MjcB3bF+rIB0pKtAIIf/+rFY6V5GSwTPopV39/6xXIzYGyyRPcBKL3KYsuh9/Sf2C
	 1c/SEzaFdhRVGX13HTUXSH1Q41kVhAwTU/mEDzNw17ULNUvOwE81R3w6COok4ASxk3mFu
	 FlbezLJlHuEWL9A4mddrnVvL8345cJKRm2iNHKpoJLALeNGOTYl2sFvfCqvO8TXGMUg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795120137;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:DKIM-Signature:Received:Received:Date:From:To:CC:Subject:
	 Message-ID:References:Content-Type:Content-Disposition:In-Reply-To:
	 X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=lB82aht1j/garI+NMv7MmpPqM8h/2vCufBrDPPKlMts=;
	b=BKxGCTvsrQ5ZbdCM/bHMSZTyyCtrgNVplBpfaUdNwN0qDS1LN7HvEhpWiYYxsdliJcjK
	 EKBmDzRNb1HtABdixlfBn1hplAGEuUOxpuT1EmZ29ToXQanzD0xLvVMHlMq9qsNeWf/c4
	 ByUuoz5niulWa0HrxvB+bnXSmmq7SLnSX1vcAJRQtz3w5tqaOwbz4t9Z49DSC4MiCBjlT
	 +D3RYi7H1tnXnQDfN25oUITtjwWiOlzxuLA24orBmV34AF1w4pb7Dg4Vhv5jR1SwFadku
	 z2tpiHGzYJjoPTgO9LfnXqDERN0tEUHodcrC5zecOdggWEzTPsPW484NnETAE27fGWA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=kIi6F6H8;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=EaBaSKnR;
	arc=pass header.oldest-pass=0 smtp.remote-ip=192.198.163.9
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53795606A32A
	for <nvdimm@lists.linux.dev>; Thu, 19 Nov 2026 20:28:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 53795606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=kIi6F6H8;
	dkim=pass (1024-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=EaBaSKnR
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795120138; x=1826656138;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=GhdjKyrXr0pbS7LZ3pukDoqRkg08tn5gGn4OL8maEfY=;
  b=kIi6F6H8SwVwBy4kHAJoGefOBasCgc9qVsS2g5LHoXt6HoFEy4Sx52wv
   2fG3n+Hp4ig+4TVRMV6t58QgdqTI9s5Vn3+z7SVmGqdTsfHKLmYZ1Sx2F
   asXbH5V54seztK8/G+50qesPW++ysueUjl6saUxEyJBQni/PBvUjZ+WEu
   XRpDI3L3ZjeyDKOvHQxjsFjq+sryE/tsUq48ncXRqRnnoNhT0b4dhsyA6
   h50/nPW0rTCqi1/d+zRNvO00OvWOrN9ZfCGAreHk/60fLuaUtH1MIL1Mu
   BdIv/SaR8P5psJvXSV9MLDTQH7Eyj+spsQpSGTZl0nSCD3L8/4/+JRT4v
   g==;
X-CSE-ConnectionGUID: SVuk5RYFQamucelqnpUcVQ==
X-CSE-MsgGUID: 0JDnteBfTPqVBIiSnQiwtA==
X-IronPort-AV: E=McAfee;i="6800,10657,11971"; a="3872878"
X-IronPort-AV: E=Sophos;i="6.27,221,1787036400"; 
   d="scan'208";a="3872878"
Received: from fmviesa013.fm.intel.com ([10.60.135.153])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2026 12:28:57 -0800
X-CSE-ConnectionGUID: g7jiXL5xRvK6WZUEqJp5Ag==
X-CSE-MsgGUID: t15ZTq7qQJe1TCMChITJOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,221,1787036400"; 
   d="scan'208";a="12503728"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa013.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2026 12:28:56 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 19 Nov 2026 12:28:55 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Thu, 19 Nov 2026 12:28:55 -0800
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.16) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 19 Nov 2026 12:28:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qow04Cqk8T/TXM+7pawKOl/jdXcK6E53OesBpIsAI5Yhe8Sj52UcwP3MtsmkSKucRBWO9Y91CuyCncSaTSqvD+PF4ZNt5Rq2jQk0bJknfDiNdQnxLdkY65Qk6NQdcQR1ogvKuEjEUQyIAUdYgs90XRMLUSWZrRN4U5BG5uDYa7pjTGoGE/ZPXc65/nNyXIWWLaMR9S9nLAZ+MFg7TvJHqw1W2TSOwvo1hd9koJpEq1ualgQ61H4wqk9jsnh4GgzEkhOB08DFKR2joNEuh2ER9r/AY69wsr4kvpzoKD4iDSiBRq3WJniIfrmO9D0Qrz8nB8Vz/W3OP7lGE7clNy2aLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lB82aht1j/garI+NMv7MmpPqM8h/2vCufBrDPPKlMts=;
 b=RZIP/1bTRoZuzbADEMgzL/t0/w/DLFzyEYer4jSHhvVFBVF1HPvi68Y0e4cxJCrewNKnREowF6kfRGeg/HV9tCxiLXY/q7lUcI+kajlnDQfDsYpNAhS2VyaW1omxVznCtcoqZyoTkzBrUybBasmt7g4FY3r8CyQBPqGycP/hglKfrau7E6eWYQE/CDdDsFcd632Ag7NOsuhO7ac7O+qdGeZ72qIxcWdPH3iIaU88Z8R5uheJb46odkQ6hXg4etafAQGb8SKfXybU13R9tyATp6HuDS5Pp82gVlyMpqxaexch7nl+ISoa9GDv434zFwCBhUMUFa821mjydy6AEGtLGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lB82aht1j/garI+NMv7MmpPqM8h/2vCufBrDPPKlMts=;
 b=EaBaSKnRnhImeRXibPR5+PtvKA6obpFhvK3ZuqySZOJbC40hS1IeBsluqFDDiAfKddXb5m4rRuJ4FfDeOzyln9L198AaZpyQF+xv+cBjtUN261r+DokmHr1dhwa2QwbclIaFnS0GAuwVkc8sGplPKttXCxRpm9pzVPVRECpnbig=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by LV2PR11MB9598.namprd11.prod.outlook.com (2603:10b6:408:379::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.10; Thu, 19 Nov
 2026 20:28:53 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0615.013; Thu, 19 Nov 2026
 20:28:52 +0000
Date: Thu, 19 Nov 2026 12:28:48 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: YeeLi <seven.yi.lee@gmail.com>
CC: <nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH 2/2] ndctl/filter: parse the current token in
 util_*_filter
Message-ID: <av9cAB4OckjjCQF_@aschofie-mobl2.lan>
References: <20261117062808.4004617-1-seven.yi.lee@gmail.com>
 <20261117062808.4004617-3-seven.yi.lee@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261117062808.4004617-3-seven.yi.lee@gmail.com>
X-ClientProxiedBy: MW4PR04CA0337.namprd04.prod.outlook.com
 (2603:10b6:303:8a::12) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|LV2PR11MB9598:EE_
X-MS-Office365-Filtering-Correlation-Id: 362c848d-e1bc-45d0-2d1f-08df467bb95a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|10067099003|4143699003|11063799006|56012099006|261021121427099003|261022105027099003|261022113327099003|261022075727099003|261028144727099003|261102123227099003|261026140227099003|261009223027099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info: dH+2Y12fJ8T2g+AuX4EMfSChZ4N/SmV3TjXIpyP/g5BS2BgcDhz6y/Qce1cts66tJvNMPjLevHHz3fgWo1OySqiJ29kAl78ws95HnPnAv/6m46lrN7vctKWSKwIQiLyqqlFeJP9LtqBpH7Mlk5lBQ+IjemPh+ocjvjLTiv4OgQ9vS3drbt7QaNXuMSAjE7jY30IIKX4fMlX6gSzPUUv2itFIgS28jLkjdbEDvvJF7ZOcbyitNIBaxfB/qsL2X0BEYVssNAjTZG+g+OvBB1uQvpNHtwYwtDIGP5N39f1UG4/pX7X4rtyxcqzu+fj7DqlHhyPyAfL9QUDpT4Df0dybyLxeFp1oGaoiyuUY/sGla0O8FMkhluPON5hdFo8L9QRKkSwmMAnSKNmHnkPd/pkYyuWXvdsTo56bxoqwhJAJJyxmYt/nZGesNkMVRd9G9Da5DW1nRiCORelaYMBHJtY+gVIX9gUmkb8ZKJxZ1eT5hBwBPweBGiT83Jl/Pj6IU3ePIUAtLNle2B0r97thETEeg9W3+Z5pW/9sY4Fq37KvWxGeKDhN9OYVR3wVIHk0ln/DSPGWwijXjhC6/1/+uFCSa3c8skfkP7yRrpjFB4yIjFEkgxFCXcy8sq+gxH6I4wQKewIJ4xfByTQygGj3iwjrSPfa8A5LX06iogNwg4mX9l4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(10067099003)(4143699003)(11063799006)(56012099006)(261021121427099003)(261022105027099003)(261022113327099003)(261022075727099003)(261028144727099003)(261102123227099003)(261026140227099003)(261009223027099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ju8y9ANlZVQIqaxVCnFNUna3nHocj5rzKwjvlxpktO8nqlYrHeeQXpUA5p7S?=
 =?us-ascii?Q?obnPycW6YAUl4j3Wd8x8zv42D5ihpZZAXkpEZWDtR0Qlz2EOgpip8WqZT1fC?=
 =?us-ascii?Q?gM/vrKmN2Ab+rDusH6/HqGlSsEN07awMfbbjftG9LOxLuJiI3FnIAIdVpRPH?=
 =?us-ascii?Q?db/ZdXcfIzv5jSrkjABGdkLDL1MOFw4KiM+hBPahSra5Qvqfpzxx++raB76y?=
 =?us-ascii?Q?Uv2TIuBYCdqzkJxOj1U/ZOjJK5BN68UeNCfLUdKN8cRKDGzlE5H7XNG5Xw65?=
 =?us-ascii?Q?Sq3NoBkkS3IffXGCLQRVhTQuNyNZmlKyT1PibjiYOX0NDaYfETusSJ9FKvII?=
 =?us-ascii?Q?zSSCuPucz4Dktu1RiMSRRFRHtr5ibJzbcR3LqFtAP3/zj9muvoqb/YepzHhq?=
 =?us-ascii?Q?fBHFxJocj0YLpk+H3flGpucLIjlwGCrE/bahRg6JxOFH1nH2pu+JUaIuFVSX?=
 =?us-ascii?Q?BXJRtn6rJFJH9TB+bxM7EltjX8ZU8UIqzAinaz+UjtxmkKTnAPNlHa077xfW?=
 =?us-ascii?Q?nTE/UUAexGLh2LC5VF4fvboJEu0oj4TggMukno/PFeHh/NmE0jnlqNyr6H0m?=
 =?us-ascii?Q?Nqs63k34uXxhtb9MpYiOwdcOwR8/zxQOyCC9ObDADl5MUZv+9XphOG9GKJ7t?=
 =?us-ascii?Q?TUZbJisq/beGeLE2mpbCbluQmJGXg3ay2tM0aF7jSxda0q8zLbbqJzNZYmQ8?=
 =?us-ascii?Q?zCCP7QwwlsoXwx1g1mVr/LHCXKQhnXfAc9yfzi+23tg38w/10Sm/YXPQgdgJ?=
 =?us-ascii?Q?n/gBbFhe3eGeC0NkDmcsB2l/dLlsYsBRFBqEnB9hARiEwuBx+L72atLdLUbI?=
 =?us-ascii?Q?AQaP3QsllH3PoGt7l1+Mjm1lMTfEBn3eMWnIntpX6PTku+jy0pZiRjH8fkTD?=
 =?us-ascii?Q?KypJXCYZo5aM73L7MrQn+GrzYXFJ+IEmliZDqw6Io1XRdf4bTFR+aHZ5mFBY?=
 =?us-ascii?Q?k+dFGLKH1ARJrYbE+qNAVDAU+H94wTZHKywOv6tgPGnGeR5PRJm/Yqq15QX4?=
 =?us-ascii?Q?4dJU1yhvYNwRiztL80gbQy6BeuULCD3eJ3R6ttkETxVSmA5EIqdkhsSbK9yc?=
 =?us-ascii?Q?d25ivzAbR9kQNSjrxMvCb2Xlg4AfydM3U4PMxLdQhdo3flek3RnPe/Jy0015?=
 =?us-ascii?Q?Q+DC/xD4uT1ph68QZ4pcD2zQ6PAd52FB+qI6H1nTcpNm5gaYdQL6o8sDv67O?=
 =?us-ascii?Q?Ydu5W/BCY6EUY8EvEonkqwuv9sxGuSpiJ0mMl/dfOP+bvaWoPyFJn0hhPlny?=
 =?us-ascii?Q?AvP8YbACPX0IizsPntLkytcohzavsCNCuNAUPV2nqQsUY4eIQcW5mLGJWVjA?=
 =?us-ascii?Q?A8mmW4kXwEPjPv+w3CCw2GLvMFypOpu8Jz9ODB6KhxuTupEUcKGr0bJTCMrH?=
 =?us-ascii?Q?Y8kE4+Pkx6VxWfv1LcIp1HFZ0Qdb+758TcRkQN0vUCZUu0Xqa2aVpEozKDfs?=
 =?us-ascii?Q?CsRrA4f7JyscYyRR326NzVpGJ24PGPbrWRpu6H5SLz0hjorEe4GK39cdpOeN?=
 =?us-ascii?Q?BpIX+g/GOVosfaFhif0ymX9drjkg6JFaSWA2cJMyXzFbftitMXPJsxdcLG+m?=
 =?us-ascii?Q?FU+3S+OAQ7DmiRa6ki17M8ee96BB+9fL1NGfAvdB4zSDXxXjXMa+wobdPVlM?=
 =?us-ascii?Q?1i99LFgG/ZrPqJrQSGU1Wb097O5U96vcgwQ1W5qzsa82qSttymAsHu1aqLgt?=
 =?us-ascii?Q?q423Nt5dEvsDVhUaYFEhvxmyq/iaHtdJ7UoTTo7zNt1VKuk4i410gLcCzRwZ?=
 =?us-ascii?Q?BqEcqTQn1qWSO5IUFQhNMrO1riy1R7M=3D?=
X-Exchange-RoutingPolicyChecked: 0z0HQiFbtQ5F0TGr64DVJnuytrdAruhUU21V5wkTDpu71x/Emh6OujM/HGRotllaBSVQ5kK1cnJ19uBPacnddkVUp75seguI49/1BzscxgXmw0JNcZk/FS75VRVttSA+Oi+HQ81KqiyRF5o6rFWP3dbUMM6GTbMKED0fY2i9n4Kl9EhjbbDG4y+4o3acPAruDqI+CG8cgyvqAqO5461KVi4fqIyUJA8ej7X70sv+fto/LOuylpaYsg2KiZ/V23VBKdpwrNff40hWo1Kza33vxhrQ8256Fj2yfjN0UlL6G7+EC6jiDduAFsxXEeZ6I36nr4Qh+9D8zgPv3u6R0+s1DA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 362c848d-e1bc-45d0-2d1f-08df467bb95a
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 20:28:52.4935
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fg03ooZuI+CVKgIiIMBfMyTgubD+++J9G/LdUmwcGsYNZVEyRNYCmyF608RziYmkuV2DaEsWR0oHCH4JRBm3kMHYX8yiT9CK4gbYhGmOilM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB9598
X-OriginatorOrg: intel.com

On Tue, Nov 17, 2026 at 02:28:08PM +0800, YeeLi wrote:
> From: yeeli <seven.yi.lee@gmail.com>
> 
> util_bus_filter(), util_region_filter() and util_dimm_filter() split
> the identifier string with strtok_r(), but then parse "ident" instead
> of the current token "name" with strtoul().  ident is the start of
> the strdup()ed buffer, so every iteration parses the first token
> again.
> 
> A numeric list therefore only matches its first entry.  For example,
> with a dimm whose id is 1:
> 
>     util_dimm_filter(dimm, "0 1")    -> no match
>     util_dimm_filter(dimm, "1")      -> match
> 
> The same happens for --bus, --region and --dimm lists; name lists
> such as "nmem0 nmem1" still work because they take the string
> comparison path.
> 
> Reproduce with a small harness that calls util_dimm_filter() with a
> dimm named nmem1 and id 1:
> 
>     "0 1"    -> no match (expected match)
>     "0 2 1"  -> no match (expected match)
> 
> Parse the current token with strtoul(name, ...), and compare the end
> pointer with name when checking for a failed conversion.
> 
> Tested on the target test system with harnesses for all three
> functions: the original code fails for "0 1" and "1 0" as expected,
> and the patched code matches for numeric lists, hex ids, name lists,
> "all" and rejects trailing junk.
> 
> The bus and region helpers have had the same bug since 56b6e85
> ("ndctl: refactor bus and region filtering to utility routines").
> 
> Fixes: 4c9185d60c0b ("ndctl, list: add 'filter by dimm' capability")
> Signed-off-by: yeeli <seven.yi.lee@gmail.com>
> ---

Thanks for the patch!

Applied to pending for NDCTL v86
https://github.com/pmem/ndctl/commits/pending/

I updated the commit log upon applying with this note:
[ as: updates to commit log - fixes tag, drop 56b6e85 note, add
      names-after-a-number impact ]

Fixes tag: before c70adc3cf6bf ("ndctl, filter: refacor
util_<obj>_filter() to support multiple space-seperated arguments"),
each filter took a single identifier, so strtoul(ident) was correct.
That commit added the strtok_r() loop to all three functions and kept
parsing ident, so it introduced the bug, and one tag covers bus,
region and dimm. For the same reason I dropped the paragraph saying
the bus and region helpers had the bug since 56b6e85.

Names after a number: once the first token is numeric, every later
token is compared against that number, so a name that follows it
never matches either. For example, "ndctl list -D -d '14 nmem15'"
lists only nmem14. I added a sentence about this to the impact
paragraph.

-- Alison

