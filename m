Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0649B354AFB;
	Thu, 22 Jan 2026 20:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769113150; cv=fail; b=R/08e2yFmwlb9xevJrdBScW9lyGpRz6QhVErRjpmzzvueo4VWOOmd4w49nGJyFcsSYSQwDFLL0zTJB/9inDNkOKjFjjgrFxDyhcRqYQ3mhbaKENqxQmIqBQLVDvpNvubqNGnWfBlIvogmW7kFjc4saNd/DJAB+IIEe6RjYUSxUY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769113150; c=relaxed/simple;
	bh=uqxLVOsT8fwjXpwHv7/AXU7JJ/a9pGNbXiV7yUYISs4=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=GJdDyxh9tgS0ABh5sP0bHyHrnA7BLCjX9iJIO5ZjsxHFe6Y6Tg6DAOCwy0v5EyiWmTgFB66EGCA/9oO0YBJdz34kbsM3buXYNOv93RM4oFWrPKNJwOptuakYquVMmDf1jIHOrnleW4YfS/3fDzwmjom1zKWRL2yGGq+w70SIIgo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Hp6ZD3Jo; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Hp6ZD3Jo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769113149; x=1800649149;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=uqxLVOsT8fwjXpwHv7/AXU7JJ/a9pGNbXiV7yUYISs4=;
  b=Hp6ZD3JoiECOT5yKai4/4i+TYQknTEeXoj26i69hbfu45du2wXQbsjVh
   sUwi9Rgn3yJQK7IocgeWC5VkCjOIiiJ/ZR4uGzClXxzlj5PYEBX7DgHcv
   rUAd+obDr376+Em6lcMw07QXj/pVtsTocQ/98+2tQNh+IBcru4bhmpgXq
   WYzq6NI3+iTujllDPgcMI8m/FCkXWphColHAF1ShWwgHhO12KF8Vljpef
   X2sYVog4i2qiAfakPMutKrJC3K4iM3L82H0Qdua0d/6AJ8SOYwuf1alrV
   9Hd35hM1U1Gdpyab2FZ2NG26+grBZ6fWomFGubPCIulrW189ruWbH5iZe
   w==;
X-CSE-ConnectionGUID: KS2TFnTuSuG4mNJtFLqHZw==
X-CSE-MsgGUID: Um4ZlsyGSSqjD5r6ADMzrQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11679"; a="69562104"
X-IronPort-AV: E=Sophos;i="6.21,246,1763452800"; 
   d="scan'208";a="69562104"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2026 12:19:09 -0800
X-CSE-ConnectionGUID: wKo5B8GBRD2gkoSX1h483A==
X-CSE-MsgGUID: L1umEA9lQeCZcv3MfBmm8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,246,1763452800"; 
   d="scan'208";a="210957529"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2026 12:19:08 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 22 Jan 2026 12:19:07 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Thu, 22 Jan 2026 12:19:07 -0800
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.65) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 22 Jan 2026 12:19:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tt2Q0MTwyYax/BDvegVsaJnwl4K0DY3tDOgg0PNitu58/54uzGwP+llPCrjZ97Frhir6xXymGIHMbG16FJE7uSRU85qtv1Sb/D1FpadYbUu4SFz7995MgFzz0DmeGq3aA+xBwVFJPrZQTEg0d/YTBrm4KET3bfkF3KfwZKp1u9ctZPKauSbWYw2hxRF4SYwWAa68BXtvev6Pe5Z0mNAiXkSgnboSIn/pIuuxL5uQ3TSBUCMayophAgZNAnOuxJvsQnezOkYCrOhjjXrxiRy0YV2Jma04L/AwaCkvbi2SQ5T74dCKF8DnLHzoCHTtTVMBJasgvpsgsM63GLtOKtjB/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+K27TfI5aBSLaenw0hKoFcZbtSJqYS0/HmbJWkY3FX4=;
 b=CaxragEgNgZ7lZ+xpbHV7uSng5fmgiNBCoa3SI+5ckG+FRE2QhTMrdj2mYOq4BFaKlPdOVkJv/I7RXbtwvIpdpq7cuZS0Xm7CJvNNkOPJi6J9fITz+uWqyvnfjAHnpuYPv0ZQ3FuVyYT+QsY6ySLvGhGZwpPFwvVwbXWS0hwLq11o4sqnMXbgyMy0T5auOoilBnzUt4ZFuZsKxsYyWB73GEYR7OgH3gNGD/Ujitqn1z9sLZHUCufXIuc+LRD+aGHyNAT17Gpj+3jN3TWN6Tx9fqHqFiB2j7Nm5TddISg8QcdeK59TiR/rBUaswXen9MdpkdvSVpOnMI2YF0kluazYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SN7PR11MB8026.namprd11.prod.outlook.com (2603:10b6:806:2dd::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Thu, 22 Jan
 2026 20:19:00 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%6]) with mapi id 15.20.9542.008; Thu, 22 Jan 2026
 20:19:00 +0000
From: <dan.j.williams@intel.com>
Date: Thu, 22 Jan 2026 12:18:58 -0800
To: kernel test robot <oliver.sang@intel.com>, Dan Williams
	<dan.j.williams@intel.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Alison Schofield
	<alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, "Ira
 Weiny" <ira.weiny@intel.com>, Dan Williams <dan.j.williams@intel.com>,
	<linux-cxl@vger.kernel.org>, Dave Jiang <dave.jiang@intel.com>, "Smita
 Koralahalli" <Smita.KoralahalliChannabasappa@amd.com>,
	<linux-kernel@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<oliver.sang@intel.com>
Message-ID: <69728632c464b_1d33100dd@dwillia2-mobl4.notmuch>
In-Reply-To: <202601211001.82fe0f1b-lkp@intel.com>
References: <202601211001.82fe0f1b-lkp@intel.com>
Subject: Re: [cxl:for-7.0/cxl-init] [dax/hmem, e820, resource] bc62f5b308:
 BUG:soft_lockup-CPU##stuck_for#s![kworker:#:#]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0065.namprd07.prod.outlook.com
 (2603:10b6:a03:60::42) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SN7PR11MB8026:EE_
X-MS-Office365-Filtering-Correlation-Id: 4541b631-ed8c-4718-f5c2-08de59f37aac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?YU42MmdmeWtFdXZZaDhEMUJWV0dUYUdoWmM0Ynl4RzBJc1dUbDJFN01NOXZ3?=
 =?utf-8?B?QTRITTBNMnpUK2pnMVBlelJESjBRcm8vSlVINFNDYzl2ZGhOclZ0RUkzUVM4?=
 =?utf-8?B?bzByVTR2K0ZHQVNReWt4WGNTNUVNemFXVHJ6ZnhwR1RtVXc4QjVZZGVlMHF4?=
 =?utf-8?B?KzEwTmdOWFhqaysrUUJjM1k4WU0wR1RIeFJZaFBBOWZRbk5VckNsZGVsSmp1?=
 =?utf-8?B?T2oxSStpM2Q3U3BrQjh5czg2cUpBdkFRUWNJTjNqRXo3em5GaGVoSjd6UEJ5?=
 =?utf-8?B?SkROWUp6L3ZKcFZVV1pKUFpkK2RVYmtqM3lXNXlsa05KUjJmcGJRN3JNTWNJ?=
 =?utf-8?B?Q2I4RUgrTFN6Z01SZXliT1BRM0JVbDNsd29vOE13YklNOHhlL0VWNG1abVR2?=
 =?utf-8?B?cGpidUhEWlF4c0EycW9wMDFOdDhzUGlHNHRNMVJsdVgrSjI2aVpGM0hWRkkv?=
 =?utf-8?B?ekNqZWRFMkJHVWhXcWhPNFg5eGlzd1hBN1BocFNpTXVBeUtRcUhJaElZcGJU?=
 =?utf-8?B?YWVaWmlHVTZFOVpjZnBqMXlsV2ZMQ2FYRk4zM0RiMjhKdlovMDUrei95UTFU?=
 =?utf-8?B?WXMydkJUNGRLZlVuK1NWMzY4bHE0ZzdtbmJTOFM5ZGVUbWp0ckxzcC8yclJ4?=
 =?utf-8?B?eG0rVlI2QkhuUW90ZFgyVHJYS2xNTGFYemRuSEwwLytOM2RzalJPMEVFQ1RW?=
 =?utf-8?B?NE9qNFAweUlCTVoxdzVlMDI5Yi9vMHd1RnVzeHJWNVNqUEtldHArcGVoTlZm?=
 =?utf-8?B?ZXdrT09IcEZLMlpWUHdlTHQycTBwUjRXLzNZYkc0S2l6Z3FUTEtSeXRqb2Nh?=
 =?utf-8?B?Tm9nUGlLWTVGUGUzSkFHTWtERmJHN0ltQU12cU1BYUZNei9oUGJvc0txVkly?=
 =?utf-8?B?aklySUhrVUlMcWlWN2xOVCtKYm1FVE1XK2FzVUl0cUxWd0lIMThzMHhPUi9G?=
 =?utf-8?B?RFFMRjNjdi9hMXpsNXdmOG5maFFRYzRsYTYxNmoxdGxoWGpDQzdMdFJ6b3lP?=
 =?utf-8?B?SFRnSGJDSDd3TCtVSk5uMVBkaXI5SVdhMTVFVmgyeDZ1Q3l1SkNlQnlieDZT?=
 =?utf-8?B?dmVEYW5TWjFzSVlZMDFRRm9xMzlnQkxRZWJUdzIxa0pqWVRDTFdsVWNJa2xG?=
 =?utf-8?B?YWdrWGxzUEZEelZUU0ZSQjZFTk9hZHZCZEcyVW9ydkZ1d2ZSb1JBZ2hpSG0y?=
 =?utf-8?B?R0Jad3dMV1lORnhHK29kNy9DTUtySWVjeFJKYTl0bU9rSmxuTEhBVHQvZmVu?=
 =?utf-8?B?Mm45MHl6OTgxOVBhVWF6MlpPVjhTUm1PdzFhc3E2c2JBZUZCSjlpdUlxTGZJ?=
 =?utf-8?B?VWc4VGZKWkhVdWd4TWRWSVBManFSVzBKTVBPVU5OMEYxVmtNb25YUVB4S2tq?=
 =?utf-8?B?SEFDRkh0WDROTGxpMHB0bkZjbGJMc2JLTjJrYVdXNXNlRmRCbEhLVFVrZnB3?=
 =?utf-8?B?N2U4RUhUUERsNEVCcHFzWXU3UWM0SGYya1pOQkdiVHd6NWhiZXVLZEZHS280?=
 =?utf-8?B?QUIyeTlLTy9ENzZ0Qjc4dy9CdEI1bHhUWDhmSFYxYnZ5bjBCT3d4Rkc0aUJL?=
 =?utf-8?B?S0hqN0Z2RmEvTXMxcVYwQXhyUzF0bGNWbm5qM0EyaWxVRXBnSWdMOGJ5WXdH?=
 =?utf-8?B?Wm91SWt5ZFQ0aklSK1Vad1JPYjNYNFM5WFZIWnFpYyt6OEJ1bVVYQ1JCWFgy?=
 =?utf-8?B?RzEvUnNQVjNjREV3cVR0dTZCOEkzaXJsZTBOdzBtRVFkRDdXOTJOM0FaSXVO?=
 =?utf-8?B?V3JaSGJTUi8rK2JucncwcGE0RGZqRVFPV1RUcWRkZFdmaW53OXlaUHY5NWhh?=
 =?utf-8?B?T1B5K0JJUGRwcGdxY0dtNjlRTUlQb2VmcW1CdnBhU0cvdUtNdlBzNkxsYUVL?=
 =?utf-8?B?NmYzMGkvVUZLdTNyRVpGM3ZuY3B0a0ZsMGF1RFNDWStNUGowaEI4MnIycHEy?=
 =?utf-8?B?aVhtNm03L3FUTFZDdU5wakxWM2FSVnVQTlB0eHJRS0pnOTNKOVpmVlpJbVBR?=
 =?utf-8?B?WU1YZ01PbkVoUlNUM1c4YTFZb2xXTldycjBBaFc4Mmo5M0tGZlRaVlZaUGQ5?=
 =?utf-8?B?bGVhY3AxdFRPRm1yaHR0YmhTMTFZVzlZZW5OcC9HbHg1a2JqNXFWWlFkZEFZ?=
 =?utf-8?Q?NjOc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YU5XSWdsVHdONWpubmFIN2pIdWQvOWdycEgrVnkzQnNFUmtSQmI4dHJ1WElX?=
 =?utf-8?B?bXowbGJyMGlrdzdhQjBzeEp3Q0l4MTBjTXlwcHVUb0RnS0ZHenJZRmxYS1Ux?=
 =?utf-8?B?ZjRBZFo2d3d5UWhlSE53NWt1VUpmV0lOOWdud3gwbndlYWpCZFMwYk54ckpq?=
 =?utf-8?B?TDJFMmhEYm8zUnlOOGg3WXFpWGU5ZGZVRzc4RzM5ZVVBNXlHdzR5ZVhxNlJq?=
 =?utf-8?B?OTdiQXNYWUJnUjFFdzloWThFMFNLd0NQSE5wYVhOYVBUOEhiemFhTjBYVHJ4?=
 =?utf-8?B?bkJISDJhZ0hqeUFwcktZKzNpamlqc3NlTGk3TTB5SDR3VkV4eTN0SUM5T1NQ?=
 =?utf-8?B?UmltVkJlaGFReVZ5QlNqbmFzVWUxVk5HRGYybVVseEdOZjN3ZDJxZUIwTUx2?=
 =?utf-8?B?K1NwWm1PcDA0V3VCSlBmNE1sVlFJN1BnVVIwQWI5a3M0THNXYjc4SjhUNU52?=
 =?utf-8?B?dHRZMXF5TzBqeUtVaGwxKy9IUWpDQ0tSM0tCSXZ2WWxwZjA0VGFFSXVKbFkx?=
 =?utf-8?B?Tm5zd3J1NXdvbjV2RjBkem1zYWpVMVFqQTNSWVBYT1dkVXFuOWNiNGZ1OUZ1?=
 =?utf-8?B?UzdmODlCQmdpZTB4R3RCZVpCeVR5YkhUSHNhdGVwVWpjejhyZEtQM1dnQTV0?=
 =?utf-8?B?N1p0UVVLem5MRVhORWRoemZic1BIdEhJUFFDR0xBTjBlenJMWXE3cWZkdTFO?=
 =?utf-8?B?K3NvSGdmeU8wRStMUDJVUG5saTNSdmlkV0l3MEluMHY5SDRjVUdmdVl5cE9V?=
 =?utf-8?B?bHZuc1M1alp6SW9UUUlUa2JhN3VYOVN0OGYrYVNRK2cvMDNaZHZwZ1dqT2xD?=
 =?utf-8?B?azFQWjRsTmViS1VpaGJvTm01MCt3SzJYM2RHaGtYajdXRzNzbE5xMmc1aVdH?=
 =?utf-8?B?MnErRWt6THdaUHdjaWpDT2pYTGh2ZGo5RDNYM3lhcVJsWWlTVnhiN1lCTkRx?=
 =?utf-8?B?MkxucHFSSFg3MzZrVVRKaWlBK0ZXYVlMZ1dhVWo0My9GZTlvTnFsRlNISTd6?=
 =?utf-8?B?eUU4Z0wwbVpUUUxVT25EYUM3UEdFZDlrSDRpblNvVHFrdml6Rk5iTVBNNW0v?=
 =?utf-8?B?cmVBRnoyVklocmtOM2o0MjBjanRWRjArZnFVaXlDZXptQlJ6Q3ZENnJHVExR?=
 =?utf-8?B?WmkrMU9rbEE1bURGaGxNMVN5Rm1lYmdqWW5INlNYVS9QL2tHN3E2SWxjeEJI?=
 =?utf-8?B?NFg5b0M1YjNlWkMraDlEY2h0dU1Qd0ZkQmxpZ2ROY2RaRUJQVkhVOGdHTHU0?=
 =?utf-8?B?Tlo3NXFqbUFhM0FPMmU0Q0FIeUZxL2RyWkUrSzV3OGNKRUllbEhxS3kyaDRr?=
 =?utf-8?B?d24yWm1BWUR2VFZ4eUY3TTBrQlE3UkVLZzMvMmExMUMzKzh6UXlLQTNoK09T?=
 =?utf-8?B?YkJMSDEwNC9Uc2dUaytHTTI4S25INC9lMFoxZkFRRWpmWm15MmJIN3lGeEpa?=
 =?utf-8?B?MHdhbXFWYjgrbXB2Z21EamQ3REQyUFliU2hnYzhRaytCbzZudTBqbkYwdFdv?=
 =?utf-8?B?Um4rckdKT1VIeUxxRC85WjQwSW1xbUZtNFFmUG54VzltWFp3NnVKMnJwM0VB?=
 =?utf-8?B?SVBLTmRNQll1M25UT0prSlNVUFZ6SCtaYWJHOVN5NDhsODlwaG8zTG96d3dw?=
 =?utf-8?B?eUJZaCtxTmFXUXQ2b1VnamRLbXhjM3krK1hNYW5PdkVvKzhTWW1kZzJ2Y2pq?=
 =?utf-8?B?WE1WdVVBbGVvdlVKZTQwblBkS2gzekdJMjBGRXRJNVcxL04vejNTYkV0WFRn?=
 =?utf-8?B?TjZLMXFBcUp6ejQxVzhqVU1obm90VEowN3JaNXB2cVdWcG43M0ZHMENuQkdh?=
 =?utf-8?B?K1JTTUVnN2hiMHdKMFdacElNckRRN1B5Rmt6OGJTOGhLREcvMTVONGtYeng2?=
 =?utf-8?B?RFBqSElOdFJjcWZTemdGQk9XWW4yYWIzaTB6WGxXdWM1TktiRlc5eHJNcGY1?=
 =?utf-8?B?Wkl1VFdxdVVQWk1jMVZFTU5NeG9yampHbFFrT0ZCa2pEVzdJNW1IVWVIL054?=
 =?utf-8?B?dDNQemRZeGVOODh6Z2ZqWUpCZDFMeUErbDUwQU1BWk4yVVN5UDErL0ZBUWNF?=
 =?utf-8?B?eDMrQXM4QlJ5YW14R3NISEhVNlo0NTBtaDhZdmF3Qy9PeHdCdERGNzMrWUpn?=
 =?utf-8?B?VUdmT3pKc3VWZ01odVlGTEs4WVB2NVdDQjU0c2hSUS9PTkp5b0RaVE5GeGIz?=
 =?utf-8?B?TFhIdldSRS9vYlU1dzNvdW0rL0dWbzNLbWo4OGxESVRoRXFoNUdEdUx4VnFL?=
 =?utf-8?B?NzlWMjJPRzNEczE5NFBMcmswS3I5WlpWUXRRUEhEbXp1dDdCYzFPRHJyN09D?=
 =?utf-8?B?QVlReWpnU3hPcDhUZFBCNUk2Q0JIVHhEZkZTd2puMmFuNkxzSzVyZVpiTXV4?=
 =?utf-8?Q?EMm/CNWgNqFvqHhk=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4541b631-ed8c-4718-f5c2-08de59f37aac
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 20:19:00.4346
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 260tBKruxHIqh0p/ene2rdGWT8tXa+L2l1dETNtTvBjM2dq5Ph1k4TZJW0/zkzt5di6RGYwwlXyVu3PUCtRTvVyYFOR/5WVkejNSwmoSF4E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8026
X-OriginatorOrg: intel.com

kernel test robot wrote:
> 
> 
> Hello,
> 
> FYI. we don't have enough knowledge to understand how the issues we found
> in the tests are related with the code. we just run the tests up to 200 times
> for both this commit and parent, noticed there are various random issues on
> this commit, but always clean on parent.
> 
> 
> =========================================================================================
> tbox_group/testcase/rootfs/kconfig/compiler/sleep:
>   vm-snb/boot/debian-11.1-i386-20220923.cgz/i386-randconfig-141-20260117/gcc-14/1
> 
> 29317f8dc6ed601e bc62f5b308cbdedf29132fe96e9
> ---------------- ---------------------------
>        fail:runs  %reproduction    fail:runs
>            |             |             |
>            :200          2%           5:200   dmesg.BUG:soft_lockup-CPU##stuck_for#s![kworker##:#]
>            :200          2%           5:200   dmesg.BUG:soft_lockup-CPU##stuck_for#s![kworker:#:#]
>            :200          8%          17:200   dmesg.BUG:soft_lockup-CPU##stuck_for#s![swapper:#]
>            :200          2%           4:200   dmesg.BUG:workqueue_lockup-pool
>            :200          0%           1:200   dmesg.EIP:__schedule
>            :200          0%           1:200   dmesg.EIP:_raw_spin_unlock_irq
>            :200          2%           4:200   dmesg.EIP:_raw_spin_unlock_irqrestore
>            :200          6%          11:200   dmesg.EIP:console_emit_next_record
>            :200          0%           1:200   dmesg.EIP:finish_task_switch
>            :200          3%           6:200   dmesg.EIP:lock_acquire
>            :200          1%           2:200   dmesg.EIP:lock_release
>            :200          1%           2:200   dmesg.EIP:queue_work_on
>            :200          0%           1:200   dmesg.EIP:rcu_preempt_deferred_qs_irqrestore
>            :200          1%           2:200   dmesg.EIP:timekeeping_notify
>            :200          0%           1:200   dmesg.INFO:rcu_preempt_detected_stalls_on_CPUs/tasks
>            :200          0%           1:200   dmesg.INFO:task_blocked_for_more_than#seconds
>            :200         14%          27:200   dmesg.Kernel_panic-not_syncing:softlockup:hung_tasks
> 
> below is full report.

So this is good data, but I do not know what to do with it. The
RCU_STRICT_GRACE_PERIOD feature seems to want to make RCU usage bugs
more detectable, but at the risk of false positives. My concern is that
this patch disturbs 32-bit x86 builds just enough to make the softlockup
detector start getting upset about this rcu_gp::strict_work_handler
workqueue.

So unless this causes actual boot failures all I can assume is that this
is a false positive report. Nothing in this patch is touching workqueues
or object lifetime issues. So I can only assume this is a side effect of
instruction cache layout, or similar.
