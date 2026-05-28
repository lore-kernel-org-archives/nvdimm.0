Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B55142F9D85
	for <nvdimm@lists.linux.dev>; Thu, 28 May 2026 16:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779984009; cv=fail; b=d9VKmoDDhgAwPsn3WCaBSZV+L4/+qVnGBBSA7L3DMK+OKlRrXLPwvqpBlgy8DVXNnxKAvjuVOoVKIRM56/9Yiqxe4Ojs2xdLL5G5FFKAX2dGvneVzCUe+/llBbQEzBM2j5Kt0ANe5ECWKd+/O0xx8pLHLlC6m93RWa5cWWMvPy4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779984009; c=relaxed/simple;
	bh=2lx+f916VkY2+NEP/iidhfMvRas+8ECbuecS1IRofTs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=s/6L6wY1SUkOCSPpOFlm5IWU/V9Bbqjf7y20DmBrvtW5e/gMeVRx5EFY1DW+EY3V8MomMpi9dif5v1NcmBri07k9nA0NejABTklSELDPshpNDU6x/uQFJky4sOSOmIfGwaFAqYPTrMO8C4oyV3xhUttbhU6ZFjiC6XKB9oqd7pg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FIDPbJuq; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FIDPbJuq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779984008; x=1811520008;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=2lx+f916VkY2+NEP/iidhfMvRas+8ECbuecS1IRofTs=;
  b=FIDPbJuqA2Dya3my3o+9w8kLbrQYl1Hh9iiUNPTn3CN5uNt5MQWk79A4
   wI+NfUnH5Si30a8uEl3HalBOc1p/k6xzHHO/dkuQduR7V3sU8lWtJuV5n
   dgJm+yw+WdzrkfnbWwRoEFnbGxHqBh+smg27bkAF+IJ+fGzJTMpVhuQgO
   DM9w7su5872PDReC0uL7sOkkEFIEE5d4UNgM4lPFiGdT0Bl0WGRptf5p8
   ekimfbV4SxtfHFamT4OTczSGzFDbdfDs7QgpJsN0k3C7iM3sT+dIAaWN1
   NI7g2AUWWwel0LYWRlE2Xyq5u4nBCLmy2yK5DtH9u0wGcUB3zt1TnJzZT
   g==;
X-CSE-ConnectionGUID: JRb5PLjUTsa9ST8npnQPcQ==
X-CSE-MsgGUID: xFplCfHOQPS3rojyJsIg7w==
X-IronPort-AV: E=McAfee;i="6800,10657,11800"; a="68364514"
X-IronPort-AV: E=Sophos;i="6.24,173,1774335600"; 
   d="scan'208";a="68364514"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 09:00:07 -0700
X-CSE-ConnectionGUID: nQT+7qtnQPGXHPnBqcqK5w==
X-CSE-MsgGUID: HMyGt5x0QsSFLO4Pejnblw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,173,1774335600"; 
   d="scan'208";a="280697743"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 09:00:07 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 28 May 2026 09:00:06 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 28 May 2026 09:00:06 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.49) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 28 May 2026 09:00:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MzvWrugzO21sNFi6BKoMlpCSQePGwhG9ECOZWqSiIQaHCULXDw4mU7wuIrTmV6f7kmVHDXE1VySXulzNzcJVoTb7on+xnYHnydjFfNwI7ezXR1cSJJQSr81Z4tcMNX/iXKCwVaxYs56SbhlUhs1TOiJuyVP5ZKHoNCo5x/TTxFBaGyX6zNYyY3/soBspNKaCJrcJMpo7Z33iV7G8QKyjmOP+fgUqIgB5uQdiHcZvBM6y8Dv2eUF/3JMfQGv2kTNBB499IQV7uMdx5KLwNSNIH8B4/C2fy/o/C9esI7PNs8BLp1tqqCYnwPflwmUyVuGl8rDEbn2YRbaDn/cx2SghIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5FFnANrJ+mfTepGpyqfb+BqlLTY2ep8tIY752jhdwz8=;
 b=vLZAgL2u7d6zzifEE+ENj2DnzXb31wuVx08/+DvZKOtCP4KtrGyTS+hM9SdqKI+5llM2OnIrg6ECVwY1f1HU+91+Ebs56OlYmMEg+AqblyHGcg0o1ZESzBM9mQWyZm5JMfnNh2DP/WjIEPYm4Khmn3lBiWwkZcjzlOVClF77Vmd6djd6tF2a0WLUiGmlhQ9NoEqvPgNMkUQrVqHrb1Za59wIq43UX/Bkf2t0J/QKyYmoStcZmOVnf1Y9FfA0PrS21Pv8wqUcjB6ulRjHxZto7cX5+O4wCHx/XySRpNdtj/E1xvvkK3nbY5wru+LXzBnhFNvRPEJjjSXdPjBXsAygAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SA1PR11MB9804.namprd11.prod.outlook.com (2603:10b6:806:4d7::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.13; Thu, 28 May
 2026 16:00:04 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%4]) with mapi id 15.21.0071.010; Thu, 28 May 2026
 16:00:04 +0000
Date: Thu, 28 May 2026 08:59:59 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Tomasz Wolski <tomasz.wolski@fujitsu.com>
CC: <smita.koralahallichannabasappa@amd.com>, <dan.j.williams@intel.com>,
	<icheng@nvidia.com>, <linux-cxl@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-pm@vger.kernel.org>, <nvdimm@lists.linux.dev>, <ardb@kernel.org>,
	<benjamin.cheatham@amd.com>, <dave.jiang@intel.com>,
	<jonathan.cameron@huawei.com>
Subject: Re: [PATCH v3] dax/bus: Upgrade resource conflict message to
 dev_err() in alloc_dax_region()
Message-ID: <ahhmf6MR4zg1lVwr@aschofie-mobl2.lan>
References: <20260528064546.23362-1-tomasz.wolski@fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260528064546.23362-1-tomasz.wolski@fujitsu.com>
X-ClientProxiedBy: SJ0PR05CA0075.namprd05.prod.outlook.com
 (2603:10b6:a03:332::20) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SA1PR11MB9804:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b574715-2961-48d5-3652-08debcd22e40
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|11063799006|6133799003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: QYt4692gcKkogniXqA27QZ5qwKBku5AqFK8QGX9xP84OHakDUucgtvDzRVVd+hZML2gisNm8Slc+0GwgSDMaAEWXfq+2uG/QRst70wFLwJ9ha4JFgc+Sy9yERlvV4cCBoHNCpV/68oHiDMBsfY28XJ/qMbGlZp6cz5FLY7QNrsnK2SXb6fwTkuJCGk/udNhg2P22qcgbl9FsUKeKBm3te5z3rWbvbyBHt6HWlTnlqDeBDD+Lh0BXvr5q7rFR3FwiXJh7mqvgj5F0lyBv+KcGzoSrRn8FCuqDkAg17/hEcHulmoyWwrWZtV0gJafz2z9FNO0UcirLab5kDhKWAHVHgeASvd39HXVpcr/I7mhUm+3MQGyqRalT2wItANZiXsXFv0/04gIZ3Iagmel8vG8Ja6hQBJIAe8tEtCglWHbzJxhC8VDupnAUobX3R09pt16KQBnQMZHJx/pI6zhpJI3X3RtZndoj0msJdQ7pXC8mSBIfwhZtJRcquMW2+o11uU2AV7yH74Q8uGBdESyzYZQg3fgYRKVa6KbFu/2ukHA9MEQ1WZCrKwWF88v5NWCcjLbb9ahA9C5++k4VYyeAf805ZmQGdDkgpxXQqCHHfFO+CGIERIoGAScwVmRLSscob/5V+LAHErQ2S4FUsjX5I5PNgYzxeKviZer+wxxLjPTEwxs10Cch8nmnZVZHlVSBdMiffblv66xHy+yf5XpSMbbsYg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(11063799006)(6133799003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K1hwZDl2dEczYWJQSHRoTTIxNmlTQ0YyMjFDV3lDaUNMNWcrdDhmTXBQamZy?=
 =?utf-8?B?clFKSWJpbS8ydE1LRERTKzFjczF2QmhzMm52MDBqMXk1UjlOKzc3cmF2N3Q0?=
 =?utf-8?B?ejlUak9XQXdHc21kN1kwc0cyUVR2OW5VM3g4TkZTT2xVclMwMEtueUE2M0Ux?=
 =?utf-8?B?VVBPODlIMmNoNEJxMGFyVHorRHBLMEhFS0oxYXdsMjI3Tnp2dGd1d2hwbG1m?=
 =?utf-8?B?ZkFnSDZLTHJiRUt1NXl1M2gxZHM0TndXVlpLUkJNSkM4eFcrS1BseDBzTEFY?=
 =?utf-8?B?UVF2dHhkNkkyQ0VZWFhoR2tDOVhoVDZnL3JnTHAyUjRuOCtvdWRKMHh1OTBM?=
 =?utf-8?B?ZitKR3pEamJiVzVreHo2MStINTY2L2VjbXZmbVVZcXRZMU5VY1FvbEFHTmN1?=
 =?utf-8?B?OFpadTdoOU9oUGNMcmhYQncxNU9CRVFuTm1PY1diYzJZRlR5a2NBYUtza2s4?=
 =?utf-8?B?YkVsd2UyTFdCamtidDZ0dDc2QWVBMjYrcmJYRkVyU2lWVFY5VHBoallzN2ZE?=
 =?utf-8?B?QU16Y1BXUlhWT2RWRGlsSTN1N0U0S3Z5dUJKUkZHMGJMQk9PV2tiZUcxVk4y?=
 =?utf-8?B?VU5OWVRLTnE3ZFlGTnNld01zelcvV2VCeHlYNDhFSFRQY2U1aXJja1lpSU5G?=
 =?utf-8?B?bG8zNjF4M1VZMDJ1ODZTVHBna282WCt5OVBZZGtiekxwaklzd0RiOHV6QjFs?=
 =?utf-8?B?SGxWMDhEaGhKc3hKS2kyWW4yMXl2eENVSHNlVUZlVnU3RTd4QWJOdDFacDl5?=
 =?utf-8?B?ZVJuVDBWOEtLbzl0aThPekI4NlV3dDhMM1RMNlpQOWkxQlpZbW5sT2N5VmlE?=
 =?utf-8?B?a0Vub3g0cXhZQTBFbDRKMFhTQmRCTnp1OTlSNDY5SEhwc1lvaGROSG9WdmtS?=
 =?utf-8?B?cDkyaTloS01uY3FjWFdRYUhXa2VtV2pHZmUzeTA5TWZEYVFCdmdSQ3JZMmZ6?=
 =?utf-8?B?ZE5YR3VWbFJ6OEZ6QWxyUDdJMHcxd0NFeUMxek5ZQ3BOVzRtR2hBcEJyL2lD?=
 =?utf-8?B?dDA5MVkyM3pqYnlHV0daL2dUb05QaXd3L1FjRkhFU2tsV2NLM3RrMXpYajdk?=
 =?utf-8?B?cU4zNjdYSHE3ZjE2UFQzQVN1NWVYZmI5YnZZSTdNUTl0REpHakh0LzN6Rk4y?=
 =?utf-8?B?WWR3NzR4NFB6NWNEMEc3aXNIUjVlMVgrQ1dlcHNJR04zU1NKeXlvR3FwOHh6?=
 =?utf-8?B?ZlFBMDFqN2Jla1F1UEU2dndjdXNTbFI3TXR1SVI5alJwbjhwSVlrMWRKejQ4?=
 =?utf-8?B?MExQZEk3OUpPZ0YxaEFkQzBVSlhkWHZqa2pXQzk3bGtaU1d5ZGpmYU9VRUk3?=
 =?utf-8?B?NUtqc3ovaGNhK1QvNUJkUmZhOGxQYXU4WXEwbkpXTlpSWFVvaXl2YWFxdE1X?=
 =?utf-8?B?M3lIL212SENyOVFTY1hsY0MrcHhBSUhDZ0hQa093aG9Nb3JWWXc4SGd6YXZU?=
 =?utf-8?B?WlQ4a1RKcHh0Y1RzbENTNFpkbGREbzYxT0diTEJuQm9SSkd1bHJoWEVNOHBp?=
 =?utf-8?B?d04wTGNxUGN0M1ZveU54djd0eWtXT08rQ216ckYxUUduUGpMSHFqYWpyUTd2?=
 =?utf-8?B?VE5IQXlQb0lVUXRJVm9xOVdqdktXRlptcTU1UVY4b08rRGN3SFFJcDRpSWFi?=
 =?utf-8?B?R0JQRlRCMEFpbTNSU3BjMU1ZRWJqcVRmTnFyM011d3l6VUpGRUFSM2V3Sito?=
 =?utf-8?B?NGdEbkhGdEdBY0FZeXJNeFFjcGFhODNJekxoY3hBVTdObXN0V3ZXTWZLclNn?=
 =?utf-8?B?Z21uRDNtNjgvekRhTlhUbnhsYlY3N004ZkxsenFxZnQxWDBJNFdrSHlYMndI?=
 =?utf-8?B?UndNQytYNitRdWJiL0UzNGNCamwvVHRtWXhvTENEc2M2R2JscjZoNmZ6RkU3?=
 =?utf-8?B?WVFIcWYwQzVoRHVXZk5aUmdXYTlvSDZtekhSTzNwcmVsbjBnWm5Va2pKSUx2?=
 =?utf-8?B?bkpPU2c1K0FGZTc1M1ltR2ZpdTJ0S1NmbVlNSzZEa2RwT2F5cnZpZVBwZ3k0?=
 =?utf-8?B?aHhuNGJzU3p3SGxnb1h5Um82cmlOZm9jOGxMMUtIMXhXanFxSFVSV3VQQVdI?=
 =?utf-8?B?S3pFYmNCNXZuRm13byt1a1hMSkt0dWhhck45cGZReXU0N1Q1YWJBVGhaSDNB?=
 =?utf-8?B?bUp0UlJkSnBaOHFEeDNWQWIvekFRR1ZRWis3NmpSNzFKbU1IclZCNDVFR0M2?=
 =?utf-8?B?RGRmbzNyZjdnWlk0Yko4WDVuM21pTE1sc2VpL1ArTEE1WWtucTFpQkREQklk?=
 =?utf-8?B?RHlpc3ZQdHZCTDY4cFREbFpaWVFnSnFlOFBCcUtWSnFmQ3dvSFU0clJ4Y0dM?=
 =?utf-8?B?T2Vrc2tIdmRNa0dGYkpYRitQcUYzdWY3c0ZoK3dwSTdCSFRVM05mT1JaMUxO?=
 =?utf-8?Q?h82sHDowuG191Ia4=3D?=
X-Exchange-RoutingPolicyChecked: Cxp2KEGftA7Y9RHo7V/6Y3fV/klONnZMolXCetKOI3wfpCUyVrHj9xPCbRP+rEHpes/2DsuP0ewXUdCZTJqGx4wWiFRCVtEcuBerxep+5EAR7Qdu8Z03NZ33DsqngqNJ6j4OiTeYcj2yKdg3o7FMlyp3zmgC1xT8o56OioUAuyp8KFs7uTY09OwQ1SzUNFY74BgPpH/V66k6wNXNwQpHVU5jUzKcqPNTZyx5Qex+1PIpV5cG7P5y6cy18VVpJVQ4/Hvc9rTO414g85+T0mZcUPn2C5Cte8mC19ZRgJ4fDPFXlDwgKcmyR7uRc7xAEecslCH/W+ILhFsBaZ85btbHSQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b574715-2961-48d5-3652-08debcd22e40
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2026 16:00:04.0494
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E/SH7JX5czv0ZVoKhP6A6Ou1Qturodw1WJ6Kek4z9xmTsLthf+han4CcoOXjlJdoFyU+K6ttKaZuxM6F7OOGJAXtC8UvJ/CR4rDgNJIvfwU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB9804
X-OriginatorOrg: intel.com

On Thu, May 28, 2026 at 08:45:46AM +0200, Tomasz Wolski wrote:
> The dax_region resource conflict in alloc_dax_region() indicates a
> serious configuration problem — two subsystems (e.g. dax_hmem and
> dax_cxl) are attempting to register overlapping address ranges. This is
> not a transient or debug-level condition; it represents a genuine
> resource conflict that an administrator needs to be aware of.
> 
> Promote the log level from dev_dbg() to dev_err() so that the conflict
> is visible by default without requiring dynamic debug to be enabled.


Reviewed-by: Alison Schofield <alison.schofield@intel.com>


> 
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Link: https://lore.kernel.org/linux-cxl/69c1a8d1c0fa9_7ee3100a1@dwillia2-mobl4.notmuch/
> Signed-off-by: Tomasz Wolski <tomasz.wolski@fujitsu.com>
> ---
>  drivers/dax/bus.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index 68437c05e21d..cd963eeeef7b 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -672,7 +672,7 @@ struct dax_region *alloc_dax_region(struct device *parent, int region_id,
>  
>  	rc = request_resource(&dax_regions, &dax_region->res);
>  	if (rc) {
> -		dev_dbg(parent, "dax_region resource conflict for %pR\n",
> +		dev_err(parent, "dax_region resource conflict for %pR\n",
>  			&dax_region->res);
>  		goto err_res;
>  	}
> -- 
> 2.47.3
> 
