Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BFC91F9ABC
	for <nvdimm@lists.linux.dev>; Wed,  6 Nov 2024 15:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730906022; cv=fail; b=XKe2qbyuEAHyJlSUu4apVkMep4bBFqFRaNA9j2jpTQScTNyqyqctDHfR6om+JSy9NfrNJpM2oGp0OLbJCMQLXoE8CfPd35pz7MD4u/t+49Yln4EB6PidbWfZCbP1uq+E1e2MTKnbNudqJPwHXd8FyyEVEZcJQ2sOf0H96p5f1qA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730906022; c=relaxed/simple;
	bh=eM5LEyQHViRwYmP6iPdAWwX+hkZz7GhWZsYvlmVWTy0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JMG9LS/w+IJrFVFBNuNM3Hxk3BUaT8paTsqeCCevUIVAglsT9kYDuCkeAIhHmHt5fVRU0/MevC+9G+q9djl8bGgaUWDxIWKSL57sOggTQ63SMKmVsZ0g/ynlKPa4eqrLQGU41tXmcqobWKNbCyLJvGwazP6GWX8ncV+APBuNt9g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FcfFBGBO; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FcfFBGBO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730906020; x=1762442020;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eM5LEyQHViRwYmP6iPdAWwX+hkZz7GhWZsYvlmVWTy0=;
  b=FcfFBGBOsP0X1IOT1weTXG2aLrGMgwrJFw8hPPWlpOvKrfzIGTX0Lycd
   T45I5eTfghh099N4KZq3kMdNfS+hRoTPa2sFa7hccxEgMIG1qK0Y3OuFC
   BvIJEdl+EvbtKPMDbzpadnmZZ+lOCaw5knCsrPBxVXkahOgEbvrKVNX5I
   kqxLoiRt9Y+m1Egd4IH4pmDjsDz0pA/DTofn4H3r34dxLEVjC7vmKVj96
   XqRbcchH+ZxkCGTe4MQTc1zTdF8viUYPbCXDFjttLtINMYgniw51/PFcJ
   MzhYQDRSM62uFmzsvBfuh4sLHF7UyroViRK8x4cXRRIO9vL+w40U324h4
   w==;
X-CSE-ConnectionGUID: yzAcm5SbSnmTEiKrg+f30Q==
X-CSE-MsgGUID: tOWV3Z0uSMCSxhPeivwZNw==
X-IronPort-AV: E=McAfee;i="6700,10204,11248"; a="33551815"
X-IronPort-AV: E=Sophos;i="6.11,263,1725346800"; 
   d="scan'208";a="33551815"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 07:13:39 -0800
X-CSE-ConnectionGUID: hLYg9ivjTgWy3oLGg9OIuA==
X-CSE-MsgGUID: 8nF+chx3QWSN0SanD9ouvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,263,1725346800"; 
   d="scan'208";a="122115252"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Nov 2024 07:13:25 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 6 Nov 2024 07:13:24 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 6 Nov 2024 07:13:24 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 6 Nov 2024 07:13:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MNbuNDvjVFKwJRahWwlP9yc6dQLF8OFRKJILt+pQeLnPjEC6pPHXruDbwzF3K7l80hqkFV8TD5Yqfkou+gPlssVcX3l5nFM/l6zwvmEp6AQEE3aTymQ19Goy4ApPqa5XXiVISvSokQl2DUwm2bHhYc/yocUr/+9BEl+bSqpq5TXAyR2HtI2rC3PMbrRI3rf1EFHpnEr1DuH1cEDkCmztbHGcZgd8mmJEkz5yds5GSxzn18uKR9WrqYVH1DPXR5uBs8Pi4VKGIPxcpIfWf8Kui1na13rUpwo8CqQUalAQilwh/F083oxhYcoqphW6TcElvEHiFkmpHqR11R3u7ojAfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LYq/GguCZsq6hBoiPaOF2YWI4Cp5P5KET4twp/dkHTI=;
 b=Rr0cXrFh2d/AcVf/WBWpUd6SINZoIIvorbleI3hlHUZ4NSO6bQ8GWFoY1oq06x/T7EfmDo3aiM2h5nRt8LzlNIqfFlfx24NfwolXBCeKDUI3lnehT97/1mvUg5r2nw5f/CX1FyQDB/ob++lGDoD4dmwgYVtqhpvCoonieFVJFSipUFQ6H2NBCydIwrH0YwBqR+C19/FfRhYpInH/mWrbhYfK+7c5iiEP5YFcn+FJpv8rL/5vJMaAcFjFXf720PNKI9nzIC8/OHq6j2VirU+BL/B57wgSA+OvWN9ovsN3SfNF0PSHPFr9PAxZV7RILf449L36jNZGVeQqOWq6ZyyPmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA1PR11MB7200.namprd11.prod.outlook.com (2603:10b6:208:42f::11)
 by DS0PR11MB8136.namprd11.prod.outlook.com (2603:10b6:8:159::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.18; Wed, 6 Nov
 2024 15:13:22 +0000
Received: from IA1PR11MB7200.namprd11.prod.outlook.com
 ([fe80::8f47:b4ca:ec7f:d2c0]) by IA1PR11MB7200.namprd11.prod.outlook.com
 ([fe80::8f47:b4ca:ec7f:d2c0%4]) with mapi id 15.20.8137.018; Wed, 6 Nov 2024
 15:13:21 +0000
Message-ID: <3f78e98d-6bf5-4a1b-9352-575b2f4a0ccb@intel.com>
Date: Wed, 6 Nov 2024 23:13:12 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 20/27] cxl/extent: Process DCD events and realize
 region extents
To: <ira.weiny@intel.com>, Dave Jiang <dave.jiang@intel.com>, Fan Ni
	<fan.ni@samsung.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	"Navneet Singh" <navneet.singh@intel.com>, Jonathan Corbet <corbet@lwn.net>,
	"Andrew Morton" <akpm@linux-foundation.org>
CC: Dan Williams <dan.j.williams@intel.com>, Davidlohr Bueso
	<dave@stgolabs.net>, Alison Schofield <alison.schofield@intel.com>, "Vishal
 Verma" <vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>
References: <20241105-dcd-type2-upstream-v6-0-85c7fa2140fe@intel.com>
 <20241105-dcd-type2-upstream-v6-20-85c7fa2140fe@intel.com>
Content-Language: en-US
From: "Li, Ming4" <ming4.li@intel.com>
In-Reply-To: <20241105-dcd-type2-upstream-v6-20-85c7fa2140fe@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYAPR01CA0041.jpnprd01.prod.outlook.com
 (2603:1096:404:28::29) To IA1PR11MB7200.namprd11.prod.outlook.com
 (2603:10b6:208:42f::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR11MB7200:EE_|DS0PR11MB8136:EE_
X-MS-Office365-Filtering-Correlation-Id: db686bcc-8d2b-42ef-3a90-08dcfe758d54
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?a1JubG1iVFVUMXExMHZzeW83NEVBRWJBUk9Tem0weUtPNUJPY3dzbnNxUHE2?=
 =?utf-8?B?ZklwVWozTnFZTitrNWd5TXFQMWpycXdKeHJhMUhNcWFTMjlJQlpQRjFWNzZ5?=
 =?utf-8?B?L0xaYkYwaUtyRkJWeWY5QlIyVUk4djNYUXZrUS9mWGhZdzBQY2NqdFFEUFBG?=
 =?utf-8?B?MmxtdWdNVVFHaVcvUG5kUXlxRmFWakhUMlNQdVFSeHpsbkt6TzVwSUQ3RGRy?=
 =?utf-8?B?R2M5L1ZUTFJidERndWlJcHNzRG9JT3RDUDR5bnYyYWpCcFRsSUExbEhzd2Vt?=
 =?utf-8?B?ZWJkbk9ML0NlUjByRE5vK3piaWQwZ3psZ2hDY1NRQ29xalk1RlVQNWh5aWNK?=
 =?utf-8?B?RWFOc2hGMHBsT1NQcEh0ZGU0Z2swcllXU0Q2ZlRqWjJwcCsycjYvL092STZI?=
 =?utf-8?B?VHM1K3NGYlNRbmpMUEJZT1dyNG1QYWhQbDhmUnRDL0FVK2xvRjlPQUl1V2cy?=
 =?utf-8?B?Q1dkWTBIVkNlY25qdFpIaDIrT1JLYnd1QkxvbVllME9mcVRLN0E1NjcwQUJX?=
 =?utf-8?B?ZXVHSmludlEzeCtGNHFRYjFBS28rTTZSSXBPZVZoTE9jWmx0N0xKQUZWLzlX?=
 =?utf-8?B?NitvbTlReWdoajJvU2J6MUlJcDFwK2t5UFNkcmp0cXlHMVBNVzNPamttVFgy?=
 =?utf-8?B?ZDhhekliK1hVSXZJbU1ZY2syZE1iMFhwN21DTnphQjFLcnRUVC9YWGs5TDZY?=
 =?utf-8?B?bWFCc2I3c1FXS0oyM2IrdDdnYmx6OTJ0TmdzRWhzMVVNYmRWUFhKTmdoM0h0?=
 =?utf-8?B?Ump4alU0QVdyK00rN2VYbTVva2V0VHNubmRZY0VjTW8rU1hqSlZUaHZZejlj?=
 =?utf-8?B?cllWSmhxMk9XWDJCVE81ZmorZTQ4eTV0bnlUcFdnTk5HcmxyVTcxNVlJMVdh?=
 =?utf-8?B?ZWdBa21aOGZwVW5IOVdxbW5YQUtFd0tLY0hJZWg3WUFDbnhuYzhWalNMT2sv?=
 =?utf-8?B?Z3JMYmJzcEVrSFJLZldoTkUxbEFOemF4L3lQSFE2ZVM0SXNzeG8weE1NdkJT?=
 =?utf-8?B?VmRwSXJBN21tazd6bERCRWxMTXhoMG9GQkFiekcwTm0vQ2F4SHh0QWFqMFZR?=
 =?utf-8?B?a0ZlQ3JuamM4REd2T0FqdjZZc0VNRFRuNDdrSks0dWJuQ2k0YlJkcXV6NTVl?=
 =?utf-8?B?TTd6b0lpbmVwRXlzZVpLTzFMa3dYY2hONnhUWnFvZ2RZL0Y1a3VZMTRQcUU1?=
 =?utf-8?B?VnVHcHpGLzdBUGN6M1hzYnRYM1hxMG1leVNNa05ianU4Y2J4bGNDT29JWnBZ?=
 =?utf-8?B?L2NkOWtMS3c2bW5MRzVyY2RJNTRKamxVaXE2QWp6bE04QklGN2g0dWtYS0Zx?=
 =?utf-8?B?clRQV3cyN24vSFdOUzA1REl3VlIwM2FqMHgwWVNrRlJqbXhYTFRMM0xFTjkw?=
 =?utf-8?B?NHVpeEJlREFyemlLaFJreTdVQ3lEUVpKTm1QU1JuZnVGdjZnOVQvam1VSzJp?=
 =?utf-8?B?REQrczJaUHI3V2RHNkNJQ1N4YlM2NEVyamFDc21Da2lDSEpWM1JyQThqTno4?=
 =?utf-8?B?dkdmU0JIQnRFbHdTZWNPSWVPNFlhelo0TWRDUjVBOHdvemhpV2xKWFQzWUdq?=
 =?utf-8?B?ZC9vckVoazlNZllpaktUd3p4ZUplV2l3TzFQcjQxWnk1T3lZb2kzYWR0b3dK?=
 =?utf-8?B?SDM2bHJybnpud0FseFhRL2FKMXNuZjdqcTZ0bUI2Tmx2M2Jrc2E5WE9Hb2Fj?=
 =?utf-8?B?RDQyaThxaiswZFU2L25MMGxxUGcrbnZPV2Nua3FFQm5tb0Z0SWE0dVp0czhs?=
 =?utf-8?Q?BZ9ExVhJZCTrbH0hXzbeu4uuGBra/iowmqgHKD8?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB7200.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VGxseEdGTlFIWVNiV3pjZ2lNOTRWc1pvOHgwSHVxWUE4MTZRUlh0QlgwRTZK?=
 =?utf-8?B?OFN1NXZLZkVUQkdjcS9MKzBsUWdzK2pLbngrdCswTElHVHpJZ0xqYkN2S2xS?=
 =?utf-8?B?VnVJYWF3VExQb1FzNVFoVFBGdmptdFdtWVVJRS9Manh2VUNuWkFOM01DTjIz?=
 =?utf-8?B?WmwxVVU3RWhEeUZ3b0tFendJbDNNNVE1VGtLM0drZkpWczNTenovblY5Y2NU?=
 =?utf-8?B?TURyVUExZFp3ZGZPUjVtL3VVTEo5M0pmblZ2dTc0QUUzMGJpSU1UeDlYRlMy?=
 =?utf-8?B?YWNjZnRUR29OV3Bld1hpcHM0cFlJS3hiRDlqZU92ZVRqVFRBQ2ROTlpOSzJE?=
 =?utf-8?B?ZWVacHhnaVB2dTl6bmhZaUNEYW9VKzdqemJwTzF1WjF3anFhOE9yTGxoYWRH?=
 =?utf-8?B?amR5Tlhqdk41YTN3ZjZNMDFrL1dpek1XeWxnWWYzbVB1bHZwM0UxeWtzZXlW?=
 =?utf-8?B?a1E4UEhUSFdMcEl3MTRFNnUzWGo2cjJFRHBNVEFpaHBBNHZQWVkzVU9kZ0Vt?=
 =?utf-8?B?K0RVdDNCSUxaeS82S3ZST1FCNWtDQnh4U0d3TXV2bGtOU09oMUhQdnZucHBn?=
 =?utf-8?B?Q09UTktSeDUzY01IUmZVZUg2ODltMVJPdk96WU8rWW45Z081Q0tQODFlWFpn?=
 =?utf-8?B?d0ZncHZ3NmtuSC95STFYS2lBNXY0NnJnY2svUGozcFllaDFqb1BKOFJUT1Q3?=
 =?utf-8?B?MEo0ZTFPQXRnNW1kMDZlaG9qZVdrQzlDUUJtOWZkR0RJVXFrem5jbGRkOWNJ?=
 =?utf-8?B?VjNuSXEycWxHeWVlU3R5K0xEbXRiOGloYndzNUlWeVV3NWljVXlzQ3VzdnF5?=
 =?utf-8?B?ZTJTOG9vQmlsQ3pTSjQzbU9DejNOTXdTanpHalFySU1XeVJTbnZ0dVFYVzZ3?=
 =?utf-8?B?NmljdURVU0o4eGIvb1dSNlBlVHR5cHZFMk5sUGpnQVBBOHdSK3pmZnhGck9J?=
 =?utf-8?B?ZG12VzNFWWtUZU5UTGVlVDk5N1FKOWE0TFZKaG1VdzVybVNNbWhTbHFvT0Fx?=
 =?utf-8?B?NGZ3N2RYR0J5Z0VlT0c1SGZTcldiYitDVTBmam04RDlWTEtsQjhWbTJPMnpF?=
 =?utf-8?B?d2ZGS2hTN0hKSDBqd3oxYUd4b2VpZmZUU1VYYzFaVWhvRGkvenlhQXdkM2hY?=
 =?utf-8?B?bWhES3hoUDArbnM5KzNhRSs1SlZaMEV2TTRYV3RLSTdGQ1FOL3lZdnNseER2?=
 =?utf-8?B?dUkyTWR3M2hMeVJQS0NpTkI5SlJSM2wwTDhEZ1F5UTFmM0ljcFA2OUQ0KzZs?=
 =?utf-8?B?OENpbHN1cGJYcjl1VUlCcnp6VUhRMDhZUDhTODNkcGxNc0dnWVlWTSt2amtW?=
 =?utf-8?B?V3U5eVNLWTVXVGZqYnFqUU5OekZxNGpiRCtWbXVHU2lZVTlweFo5dzhEdmc1?=
 =?utf-8?B?T1E1NkdZUjFaeU5NSEF1RlNIYTVoQ2RMRE1OZTZNOWY1bFFMcWxBMnY5cWh1?=
 =?utf-8?B?TjNjSWduNEsvNlJ5U0VPbm9TOXIxVm5uRWxoUEJqMUl4M0hXVm9qdWUwWTFH?=
 =?utf-8?B?aENwelpzRWRKa3ZHemhmUlV5ZGVLcU9idURWbnRheVZWL0ROa1hhNGh4Nlk1?=
 =?utf-8?B?b1R5QjNaZTluN25QRGRLUVhFUDd4eVFHZDRoK3pnR0x6aTVnM052SC9UcFdY?=
 =?utf-8?B?bHlWUFlyanFBTDJRdEw4SUZ5VDFLcVdiaExYM2t0K2ttZ2QwVmIrMHZTU2o0?=
 =?utf-8?B?TStCVTc5Z3JwWWRFSy92eUNwaGd4L1ZObnBvQkxqYW9TZHkzNGVyYjN5Y1g2?=
 =?utf-8?B?MVVDR3cyL0FnUTlYS2FTNWtJVmZ4Rjh4V0tmRFp6UjRiNHFINE1ZQ1Qrb0xD?=
 =?utf-8?B?azZzZ1hnYnVlN1R3QkdzQjdZT3VzZ0JOK0RJNHgrQ3FvcUo4WUgzQk9EbSsy?=
 =?utf-8?B?cFljUHJXZFJsb012dnhUc0FFb3BYem9UWDJIU3l4azQ2Wi9Xc3Exd0RSdFlO?=
 =?utf-8?B?cjZKditINzFQY3ZRU2FxblhnSHgzMFhKSUZnMmdxWXhORlI4Z2V1ZXlseURy?=
 =?utf-8?B?L1I5RFM1cnJkR09Wd2ZLTkNIM21XYk1lNzV2MUJqTXVaRXlZdmNtcWVwNlZ0?=
 =?utf-8?B?cTlDYmZkZ1dQZFVFWGFoSVovelJSWldJNmVpOVB1TVlQQW9kU0JlTWFhVTVm?=
 =?utf-8?Q?2f74eJhWHiKJMEcv+gLO60gtR?=
X-MS-Exchange-CrossTenant-Network-Message-Id: db686bcc-8d2b-42ef-3a90-08dcfe758d54
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB7200.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2024 15:13:21.8594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9+/ROn5Ww3fEifSwILp86pI+VNAVuYaiT93pklVOCPOix/xsb+Bglp08DfrFKZhWdneNCFUUVRPbRpDYhu90UA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8136
X-OriginatorOrg: intel.com

On 11/6/2024 2:38 AM, ira.weiny@intel.com wrote:
> From: Navneet Singh <navneet.singh@intel.com>
>
> A dynamic capacity device (DCD) sends events to signal the host for
> changes in the availability of Dynamic Capacity (DC) memory.  These
> events contain extents describing a DPA range and meta data for memory
> to be added or removed.  Events may be sent from the device at any time.
>
> Three types of events can be signaled, Add, Release, and Force Release.
>
> On add, the host may accept or reject the memory being offered.  If no
> region exists, or the extent is invalid, the extent should be rejected.
> Add extent events may be grouped by a 'more' bit which indicates those
> extents should be processed as a group.
>
> On remove, the host can delay the response until the host is safely not
> using the memory.  If no region exists the release can be sent
> immediately.  The host may also release extents (or partial extents) at
> any time.  Thus the 'more' bit grouping of release events is of less
> value and can be ignored in favor of sending multiple release capacity
> responses for groups of release events.
>
> Force removal is intended as a mechanism between the FM and the device
> and intended only when the host is unresponsive, out of sync, or
> otherwise broken.  Purposely ignore force removal events.
>
> Regions are made up of one or more devices which may be surfacing memory
> to the host.  Once all devices in a region have surfaced an extent the
> region can expose a corresponding extent for the user to consume.
> Without interleaving a device extent forms a 1:1 relationship with the
> region extent.  Immediately surface a region extent upon getting a
> device extent.
>
> Per the specification the device is allowed to offer or remove extents
> at any time.  However, anticipated use cases can expect extents to be
> offered, accepted, and removed in well defined chunks.
>
> Simplify extent tracking with the following restrictions.
>
> 	1) Flag for removal any extent which overlaps a requested
> 	   release range.
> 	2) Refuse the offer of extents which overlap already accepted
> 	   memory ranges.
> 	3) Accept again a range which has already been accepted by the
> 	   host.  Eating duplicates serves three purposes.  First, this
> 	   simplifies the code if the device should get out of sync with
> 	   the host.  And it should be safe to acknowledge the extent
> 	   again.  Second, this simplifies the code to process existing
> 	   extents if the extent list should change while the extent
> 	   list is being read.  Third, duplicates for a given region
> 	   which are seen during a race between the hardware surfacing
> 	   an extent and the cxl dax driver scanning for existing
> 	   extents will be ignored.
>
> 	   NOTE: Processing existing extents is done in a later patch.
>
> Management of the region extent devices must be synchronized with
> potential uses of the memory within the DAX layer.  Create region extent
> devices as children of the cxl_dax_region device such that the DAX
> region driver can co-drive them and synchronize with the DAX layer.
> Synchronization and management is handled in a subsequent patch.
>
> Tag support within the DAX layer is not yet supported.  To maintain
> compatibility legacy DAX/region processing only tags with a value of 0
> are allowed.  This defines existing DAX devices as having a 0 tag which
> makes the most logical sense as a default.
>
> Process DCD events and create region devices.
>
> Signed-off-by: Navneet Singh <navneet.singh@intel.com>
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Co-developed-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
>
> ---
> Changes:
> [Jonathan: include xarray headers as appropriate]
> [iweiny: Use UUID format specifier for tag values in debug messages]
> ---
>  drivers/cxl/core/Makefile |   2 +-
>  drivers/cxl/core/core.h   |  13 ++
>  drivers/cxl/core/extent.c | 371 ++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/cxl/core/mbox.c   | 295 +++++++++++++++++++++++++++++++++++-
>  drivers/cxl/core/region.c |   3 +
>  drivers/cxl/cxl.h         |  53 ++++++-
>  drivers/cxl/cxlmem.h      |  27 ++++
>  include/cxl/event.h       |  32 ++++
>  tools/testing/cxl/Kbuild  |   3 +-
>  9 files changed, 795 insertions(+), 4 deletions(-)
>
[snip]
> +static int cxl_send_dc_response(struct cxl_memdev_state *mds, int opcode,
> +				struct xarray *extent_array, int cnt)
> +{
> +	struct cxl_mailbox *cxl_mbox = &mds->cxlds.cxl_mbox;
> +	struct cxl_mbox_dc_response *p;
> +	struct cxl_extent *extent;
> +	unsigned long index;
> +	u32 pl_index;
> +
> +	size_t pl_size = struct_size(p, extent_list, cnt);
> +	u32 max_extents = cnt;
> +
> +	/* May have to use more bit on response. */
> +	if (pl_size > cxl_mbox->payload_size) {
> +		max_extents = (cxl_mbox->payload_size - sizeof(*p)) /
> +			      sizeof(struct updated_extent_list);
> +		pl_size = struct_size(p, extent_list, max_extents);
> +	}
> +
> +	struct cxl_mbox_dc_response *response __free(kfree) =
> +						kzalloc(pl_size, GFP_KERNEL);
> +	if (!response)
> +		return -ENOMEM;
> +
> +	if (cnt == 0)
> +		return send_one_response(cxl_mbox, response, opcode, 0, 0);
> +
> +	pl_index = 0;
> +	xa_for_each(extent_array, index, extent) {
> +		response->extent_list[pl_index].dpa_start = extent->start_dpa;
> +		response->extent_list[pl_index].length = extent->length;
> +		pl_index++;
> +
> +		if (pl_index == max_extents) {
> +			u8 flags = 0;
> +			int rc;
> +
> +			if (pl_index < cnt)
> +				flags &= CXL_DCD_EVENT_MORE;

Should be 'flags |= CXL_DCD_EVENT_MORE' here.

Other looks good to me.

Reviewed-by: Li Ming <ming4.li@intel.com>


> +			rc = send_one_response(cxl_mbox, response, opcode,
> +					       pl_index, flags);
> +			if (rc)
> +				return rc;
> +			cnt -= pl_index;
> +			pl_index = 0;
> +		}
> +	}
> +
> +	if (!pl_index) /* nothing more to do */
> +		return 0;
> +	return send_one_response(cxl_mbox, response, opcode, pl_index, 0);
> +}
> +
> +void memdev_release_extent(struct cxl_memdev_state *mds, struct range *range)
> +{
> +	struct device *dev = mds->cxlds.dev;
> +	struct xarray extent_list;
> +
> +	struct cxl_extent extent = {
> +		.start_dpa = cpu_to_le64(range->start),
> +		.length = cpu_to_le64(range_len(range)),
> +	};
> +
> +	dev_dbg(dev, "Release response dpa [range 0x%016llx-0x%016llx]\n",
> +		range->start, range->end);
> +
> +	xa_init(&extent_list);
> +	if (xa_insert(&extent_list, 0, &extent, GFP_KERNEL)) {
> +		dev_dbg(dev, "Failed to release [range 0x%016llx-0x%016llx]\n",
> +			range->start, range->end);
> +		goto destroy;
> +	}
> +
> +	if (cxl_send_dc_response(mds, CXL_MBOX_OP_RELEASE_DC, &extent_list, 1))
> +		dev_dbg(dev, "Failed to release [range 0x%016llx-0x%016llx]\n",
> +			range->start, range->end);
> +
> +destroy:
> +	xa_destroy(&extent_list);
> +}
> +
> +static int validate_add_extent(struct cxl_memdev_state *mds,
> +			       struct cxl_extent *extent)
> +{
> +	int rc;
> +
> +	rc = cxl_validate_extent(mds, extent);
> +	if (rc)
> +		return rc;
> +
> +	return cxl_add_extent(mds, extent);
> +}
> +
> +static int cxl_add_pending(struct cxl_memdev_state *mds)
> +{
> +	struct device *dev = mds->cxlds.dev;
> +	struct cxl_extent *extent;
> +	unsigned long cnt = 0;
> +	unsigned long index;
> +	int rc;
> +
> +	xa_for_each(&mds->pending_extents, index, extent) {
> +		if (validate_add_extent(mds, extent)) {
> +			/*
> +			 * Any extents which are to be rejected are omitted from
> +			 * the response.  An empty response means all are
> +			 * rejected.
> +			 */
> +			dev_dbg(dev, "unconsumed DC extent DPA:%#llx LEN:%#llx\n",
> +				le64_to_cpu(extent->start_dpa),
> +				le64_to_cpu(extent->length));
> +			xa_erase(&mds->pending_extents, index);
> +			kfree(extent);
> +			continue;
> +		}
> +		cnt++;
> +	}
> +	rc = cxl_send_dc_response(mds, CXL_MBOX_OP_ADD_DC_RESPONSE,
> +				  &mds->pending_extents, cnt);
> +	xa_for_each(&mds->pending_extents, index, extent) {
> +		xa_erase(&mds->pending_extents, index);
> +		kfree(extent);
> +	}
> +	return rc;
> +}
> +
> +static int handle_add_event(struct cxl_memdev_state *mds,
> +			    struct cxl_event_dcd *event)
> +{
> +	struct device *dev = mds->cxlds.dev;
> +	struct cxl_extent *extent;
> +
> +	extent = kmemdup(&event->extent, sizeof(*extent), GFP_KERNEL);
> +	if (!extent)
> +		return -ENOMEM;
> +
> +	if (xa_insert(&mds->pending_extents, (unsigned long)extent, extent,
> +		      GFP_KERNEL)) {
> +		kfree(extent);
> +		return -ENOMEM;
> +	}
> +
> +	if (event->flags & CXL_DCD_EVENT_MORE) {
> +		dev_dbg(dev, "more bit set; delay the surfacing of extent\n");
> +		return 0;
> +	}
> +
> +	/* extents are removed and free'ed in cxl_add_pending() */
> +	return cxl_add_pending(mds);
> +}
> +
> +static char *cxl_dcd_evt_type_str(u8 type)
> +{
> +	switch (type) {
> +	case DCD_ADD_CAPACITY:
> +		return "add";
> +	case DCD_RELEASE_CAPACITY:
> +		return "release";
> +	case DCD_FORCED_CAPACITY_RELEASE:
> +		return "force release";
> +	default:
> +		break;
> +	}
> +
> +	return "<unknown>";
> +}
> +
> +static void cxl_handle_dcd_event_records(struct cxl_memdev_state *mds,
> +					struct cxl_event_record_raw *raw_rec)
> +{
> +	struct cxl_event_dcd *event = &raw_rec->event.dcd;
> +	struct cxl_extent *extent = &event->extent;
> +	struct device *dev = mds->cxlds.dev;
> +	uuid_t *id = &raw_rec->id;
> +	int rc;
> +
> +	if (!uuid_equal(id, &CXL_EVENT_DC_EVENT_UUID))
> +		return;
> +
> +	dev_dbg(dev, "DCD event %s : DPA:%#llx LEN:%#llx\n",
> +		cxl_dcd_evt_type_str(event->event_type),
> +		le64_to_cpu(extent->start_dpa), le64_to_cpu(extent->length));
> +
> +	switch (event->event_type) {
> +	case DCD_ADD_CAPACITY:
> +		rc = handle_add_event(mds, event);
> +		break;
> +	case DCD_RELEASE_CAPACITY:
> +		rc = cxl_rm_extent(mds, &event->extent);
> +		break;
> +	case DCD_FORCED_CAPACITY_RELEASE:
> +		dev_err_ratelimited(dev, "Forced release event ignored.\n");
> +		rc = 0;
> +		break;
> +	default:
> +		rc = -EINVAL;
> +		break;
> +	}
> +
> +	if (rc)
> +		dev_err_ratelimited(dev, "dcd event failed: %d\n", rc);
> +}
> +
>  static void cxl_mem_get_records_log(struct cxl_memdev_state *mds,
>  				    enum cxl_event_log_type type)
>  {
> @@ -1053,9 +1324,13 @@ static void cxl_mem_get_records_log(struct cxl_memdev_state *mds,
>  		if (!nr_rec)
>  			break;
>  
> -		for (i = 0; i < nr_rec; i++)
> +		for (i = 0; i < nr_rec; i++) {
>  			__cxl_event_trace_record(cxlmd, type,
>  						 &payload->records[i]);
> +			if (type == CXL_EVENT_TYPE_DCD)
> +				cxl_handle_dcd_event_records(mds,
> +							&payload->records[i]);
> +		}
>  
>  		if (payload->flags & CXL_GET_EVENT_FLAG_OVERFLOW)
>  			trace_cxl_overflow(cxlmd, type, payload);
> @@ -1087,6 +1362,8 @@ void cxl_mem_get_event_records(struct cxl_memdev_state *mds, u32 status)
>  {
>  	dev_dbg(mds->cxlds.dev, "Reading event logs: %x\n", status);
>  
> +	if (cxl_dcd_supported(mds) && (status & CXLDEV_EVENT_STATUS_DCD))
> +		cxl_mem_get_records_log(mds, CXL_EVENT_TYPE_DCD);
>  	if (status & CXLDEV_EVENT_STATUS_FATAL)
>  		cxl_mem_get_records_log(mds, CXL_EVENT_TYPE_FATAL);
>  	if (status & CXLDEV_EVENT_STATUS_FAIL)
> @@ -1632,9 +1909,21 @@ int cxl_mailbox_init(struct cxl_mailbox *cxl_mbox, struct device *host)
>  }
>  EXPORT_SYMBOL_NS_GPL(cxl_mailbox_init, CXL);
>  
> +static void clear_pending_extents(void *_mds)
> +{
> +	struct cxl_memdev_state *mds = _mds;
> +	struct cxl_extent *extent;
> +	unsigned long index;
> +
> +	xa_for_each(&mds->pending_extents, index, extent)
> +		kfree(extent);
> +	xa_destroy(&mds->pending_extents);
> +}
> +
>  struct cxl_memdev_state *cxl_memdev_state_create(struct device *dev)
>  {
>  	struct cxl_memdev_state *mds;
> +	int rc;
>  
>  	mds = devm_kzalloc(dev, sizeof(*mds), GFP_KERNEL);
>  	if (!mds) {
> @@ -1651,6 +1940,10 @@ struct cxl_memdev_state *cxl_memdev_state_create(struct device *dev)
>  	mds->pmem_perf.qos_class = CXL_QOS_CLASS_INVALID;
>  	for (int i = 0; i < CXL_MAX_DC_REGION; i++)
>  		mds->dc_perf[i].qos_class = CXL_QOS_CLASS_INVALID;
> +	xa_init(&mds->pending_extents);
> +	rc = devm_add_action_or_reset(dev, clear_pending_extents, mds);
> +	if (rc)
> +		return ERR_PTR(rc);
>  
>  	return mds;
>  }
> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> index a0c181cc33e4988e5c841d5b009d3d4aed5606c1..6ae51fc2bdae22fc25cc73773916714171512e92 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c
> @@ -3036,6 +3036,7 @@ static void cxl_dax_region_release(struct device *dev)
>  {
>  	struct cxl_dax_region *cxlr_dax = to_cxl_dax_region(dev);
>  
> +	ida_destroy(&cxlr_dax->extent_ida);
>  	kfree(cxlr_dax);
>  }
>  
> @@ -3089,6 +3090,8 @@ static struct cxl_dax_region *cxl_dax_region_alloc(struct cxl_region *cxlr)
>  
>  	dev = &cxlr_dax->dev;
>  	cxlr_dax->cxlr = cxlr;
> +	cxlr->cxlr_dax = cxlr_dax;
> +	ida_init(&cxlr_dax->extent_ida);
>  	device_initialize(dev);
>  	lockdep_set_class(&dev->mutex, &cxl_dax_region_key);
>  	device_set_pm_not_required(dev);
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index 486ceaafa85c3ac1efd438b6d6b9ccd0860dde45..990d0b2c5393fb2f81f36f928988412c48a17333 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -11,6 +11,8 @@
>  #include <linux/log2.h>
>  #include <linux/node.h>
>  #include <linux/io.h>
> +#include <linux/xarray.h>
> +#include <cxl/event.h>
>  
>  extern const struct nvdimm_security_ops *cxl_security_ops;
>  
> @@ -169,11 +171,13 @@ static inline int ways_to_eiw(unsigned int ways, u8 *eiw)
>  #define CXLDEV_EVENT_STATUS_WARN		BIT(1)
>  #define CXLDEV_EVENT_STATUS_FAIL		BIT(2)
>  #define CXLDEV_EVENT_STATUS_FATAL		BIT(3)
> +#define CXLDEV_EVENT_STATUS_DCD			BIT(4)
>  
>  #define CXLDEV_EVENT_STATUS_ALL (CXLDEV_EVENT_STATUS_INFO |	\
>  				 CXLDEV_EVENT_STATUS_WARN |	\
>  				 CXLDEV_EVENT_STATUS_FAIL |	\
> -				 CXLDEV_EVENT_STATUS_FATAL)
> +				 CXLDEV_EVENT_STATUS_FATAL |	\
> +				 CXLDEV_EVENT_STATUS_DCD)
>  
>  /* CXL rev 3.0 section 8.2.9.2.4; Table 8-52 */
>  #define CXLDEV_EVENT_INT_MODE_MASK	GENMASK(1, 0)
> @@ -442,6 +446,18 @@ enum cxl_decoder_state {
>  	CXL_DECODER_STATE_AUTO,
>  };
>  
> +/**
> + * struct cxled_extent - Extent within an endpoint decoder
> + * @cxled: Reference to the endpoint decoder
> + * @dpa_range: DPA range this extent covers within the decoder
> + * @tag: Tag from device for this extent
> + */
> +struct cxled_extent {
> +	struct cxl_endpoint_decoder *cxled;
> +	struct range dpa_range;
> +	u8 tag[CXL_EXTENT_TAG_LEN];
> +};
> +
>  /**
>   * struct cxl_endpoint_decoder - Endpoint  / SPA to DPA decoder
>   * @cxld: base cxl_decoder_object
> @@ -567,6 +583,7 @@ struct cxl_region_params {
>   * @type: Endpoint decoder target type
>   * @cxl_nvb: nvdimm bridge for coordinating @cxlr_pmem setup / shutdown
>   * @cxlr_pmem: (for pmem regions) cached copy of the nvdimm bridge
> + * @cxlr_dax: (for DC regions) cached copy of CXL DAX bridge
>   * @flags: Region state flags
>   * @params: active + config params for the region
>   * @coord: QoS access coordinates for the region
> @@ -580,6 +597,7 @@ struct cxl_region {
>  	enum cxl_decoder_type type;
>  	struct cxl_nvdimm_bridge *cxl_nvb;
>  	struct cxl_pmem_region *cxlr_pmem;
> +	struct cxl_dax_region *cxlr_dax;
>  	unsigned long flags;
>  	struct cxl_region_params params;
>  	struct access_coordinate coord[ACCESS_COORDINATE_MAX];
> @@ -620,12 +638,45 @@ struct cxl_pmem_region {
>  	struct cxl_pmem_region_mapping mapping[];
>  };
>  
> +/* See CXL 3.1 8.2.9.2.1.6 */
> +enum dc_event {
> +	DCD_ADD_CAPACITY,
> +	DCD_RELEASE_CAPACITY,
> +	DCD_FORCED_CAPACITY_RELEASE,
> +	DCD_REGION_CONFIGURATION_UPDATED,
> +};
> +
>  struct cxl_dax_region {
>  	struct device dev;
>  	struct cxl_region *cxlr;
>  	struct range hpa_range;
> +	struct ida extent_ida;
>  };
>  
> +/**
> + * struct region_extent - CXL DAX region extent
> + * @dev: device representing this extent
> + * @cxlr_dax: back reference to parent region device
> + * @hpa_range: HPA range of this extent
> + * @tag: tag of the extent
> + * @decoder_extents: Endpoint decoder extents which make up this region extent
> + */
> +struct region_extent {
> +	struct device dev;
> +	struct cxl_dax_region *cxlr_dax;
> +	struct range hpa_range;
> +	uuid_t tag;
> +	struct xarray decoder_extents;
> +};
> +
> +bool is_region_extent(struct device *dev);
> +static inline struct region_extent *to_region_extent(struct device *dev)
> +{
> +	if (!is_region_extent(dev))
> +		return NULL;
> +	return container_of(dev, struct region_extent, dev);
> +}
> +
>  /**
>   * struct cxl_port - logical collection of upstream port devices and
>   *		     downstream port devices to construct a CXL memory
> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> index 863899b295b719b57638ee060e494e5cf2d639fd..73dee28bbd803a8f78686e833f8ef3492ca94e66 100644
> --- a/drivers/cxl/cxlmem.h
> +++ b/drivers/cxl/cxlmem.h
> @@ -7,6 +7,7 @@
>  #include <linux/cdev.h>
>  #include <linux/uuid.h>
>  #include <linux/node.h>
> +#include <linux/xarray.h>
>  #include <cxl/event.h>
>  #include <cxl/mailbox.h>
>  #include "cxl.h"
> @@ -506,6 +507,7 @@ static inline struct cxl_dev_state *mbox_to_cxlds(struct cxl_mailbox *cxl_mbox)
>   * @pmem_perf: performance data entry matched to PMEM partition
>   * @nr_dc_region: number of DC regions implemented in the memory device
>   * @dc_region: array containing info about the DC regions
> + * @pending_extents: array of extents pending during more bit processing
>   * @event: event log driver state
>   * @poison: poison driver state info
>   * @security: security driver state info
> @@ -538,6 +540,7 @@ struct cxl_memdev_state {
>  	u8 nr_dc_region;
>  	struct cxl_dc_region_info dc_region[CXL_MAX_DC_REGION];
>  	struct cxl_dpa_perf dc_perf[CXL_MAX_DC_REGION];
> +	struct xarray pending_extents;
>  
>  	struct cxl_event_state event;
>  	struct cxl_poison_state poison;
> @@ -609,6 +612,21 @@ enum cxl_opcode {
>  	UUID_INIT(0x5e1819d9, 0x11a9, 0x400c, 0x81, 0x1f, 0xd6, 0x07, 0x19,     \
>  		  0x40, 0x3d, 0x86)
>  
> +/*
> + * Add Dynamic Capacity Response
> + * CXL rev 3.1 section 8.2.9.9.9.3; Table 8-168 & Table 8-169
> + */
> +struct cxl_mbox_dc_response {
> +	__le32 extent_list_size;
> +	u8 flags;
> +	u8 reserved[3];
> +	struct updated_extent_list {
> +		__le64 dpa_start;
> +		__le64 length;
> +		u8 reserved[8];
> +	} __packed extent_list[];
> +} __packed;
> +
>  struct cxl_mbox_get_supported_logs {
>  	__le16 entries;
>  	u8 rsvd[6];
> @@ -671,6 +689,14 @@ struct cxl_mbox_identify {
>  	UUID_INIT(0xfe927475, 0xdd59, 0x4339, 0xa5, 0x86, 0x79, 0xba, 0xb1, \
>  		  0x13, 0xb7, 0x74)
>  
> +/*
> + * Dynamic Capacity Event Record
> + * CXL rev 3.1 section 8.2.9.2.1; Table 8-43
> + */
> +#define CXL_EVENT_DC_EVENT_UUID                                             \
> +	UUID_INIT(0xca95afa7, 0xf183, 0x4018, 0x8c, 0x2f, 0x95, 0x26, 0x8e, \
> +		  0x10, 0x1a, 0x2a)
> +
>  /*
>   * Get Event Records output payload
>   * CXL rev 3.0 section 8.2.9.2.2; Table 8-50
> @@ -696,6 +722,7 @@ enum cxl_event_log_type {
>  	CXL_EVENT_TYPE_WARN,
>  	CXL_EVENT_TYPE_FAIL,
>  	CXL_EVENT_TYPE_FATAL,
> +	CXL_EVENT_TYPE_DCD,
>  	CXL_EVENT_TYPE_MAX
>  };
>  
> diff --git a/include/cxl/event.h b/include/cxl/event.h
> index 0bea1afbd747c4937b15703b581c569e7fa45ae4..eeda8059d81abef2fbf28cd3f3a6e516c9710229 100644
> --- a/include/cxl/event.h
> +++ b/include/cxl/event.h
> @@ -96,11 +96,43 @@ struct cxl_event_mem_module {
>  	u8 reserved[0x3d];
>  } __packed;
>  
> +/*
> + * CXL rev 3.1 section 8.2.9.2.1.6; Table 8-51
> + */
> +#define CXL_EXTENT_TAG_LEN 0x10
> +struct cxl_extent {
> +	__le64 start_dpa;
> +	__le64 length;
> +	u8 tag[CXL_EXTENT_TAG_LEN];
> +	__le16 shared_extn_seq;
> +	u8 reserved[0x6];
> +} __packed;
> +
> +/*
> + * Dynamic Capacity Event Record
> + * CXL rev 3.1 section 8.2.9.2.1.6; Table 8-50
> + */
> +#define CXL_DCD_EVENT_MORE			BIT(0)
> +struct cxl_event_dcd {
> +	struct cxl_event_record_hdr hdr;
> +	u8 event_type;
> +	u8 validity_flags;
> +	__le16 host_id;
> +	u8 region_index;
> +	u8 flags;
> +	u8 reserved1[0x2];
> +	struct cxl_extent extent;
> +	u8 reserved2[0x18];
> +	__le32 num_avail_extents;
> +	__le32 num_avail_tags;
> +} __packed;
> +
>  union cxl_event {
>  	struct cxl_event_generic generic;
>  	struct cxl_event_gen_media gen_media;
>  	struct cxl_event_dram dram;
>  	struct cxl_event_mem_module mem_module;
> +	struct cxl_event_dcd dcd;
>  	/* dram & gen_media event header */
>  	struct cxl_event_media_hdr media_hdr;
>  } __packed;
> diff --git a/tools/testing/cxl/Kbuild b/tools/testing/cxl/Kbuild
> index b1256fee3567fc7743812ee14bc46e09b7c8ba9b..bfa19587fd763ed552c2b9aa1a6e8981b6aa1c40 100644
> --- a/tools/testing/cxl/Kbuild
> +++ b/tools/testing/cxl/Kbuild
> @@ -62,7 +62,8 @@ cxl_core-y += $(CXL_CORE_SRC)/hdm.o
>  cxl_core-y += $(CXL_CORE_SRC)/pmu.o
>  cxl_core-y += $(CXL_CORE_SRC)/cdat.o
>  cxl_core-$(CONFIG_TRACING) += $(CXL_CORE_SRC)/trace.o
> -cxl_core-$(CONFIG_CXL_REGION) += $(CXL_CORE_SRC)/region.o
> +cxl_core-$(CONFIG_CXL_REGION) += $(CXL_CORE_SRC)/region.o \
> +				 $(CXL_CORE_SRC)/extent.o
>  cxl_core-y += config_check.o
>  cxl_core-y += cxl_core_test.o
>  cxl_core-y += cxl_core_exports.o
>

