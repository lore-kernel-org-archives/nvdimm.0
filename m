Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F331F2F0C76
	for <nvdimm@lists.linux.dev>; Fri, 24 Oct 2025 23:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761347141; cv=fail; b=U5LUiV57Iz0x9JFID9mv86Zz4h+v1CMAV+tEr+FUeUs5KzscQW6+G4hpwPVtFIaVS2H91d/Yi/TcCV+xJwcx08ekeMLTgwjX428jxZn0n2WUevxhVAOKj40Jn9gPETiQX65JAcNUEX+RHmbsNoHA1mq5pHvLj6AColXRlhcPmzk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761347141; c=relaxed/simple;
	bh=JsE4Hso3v9bmkhCmZBEM9IZ2ArCQCLzkVQh1sUaOlXs=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=QOgU8XUaFKw2BXiaNNmDyTbLThzlrQBmlhf0NNC8WZk2OqQjF5ZIMP5ySSbjk04jhQ7BDTBP07xgefjDinLit11abPNx4SUS3zg6/8RbLz7aDgHWxcxlXOgkFGnOrAiQTl6HWhe2oK12hXTDWFRCc/ZpOs2iV/+uuA/tEKjBcc0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eBmRGCm6; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eBmRGCm6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761347140; x=1792883140;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=JsE4Hso3v9bmkhCmZBEM9IZ2ArCQCLzkVQh1sUaOlXs=;
  b=eBmRGCm6vo52xqH4hGrs21h9u/jbwmBKW1fc/z+yZo4Hhu/gKTwEBm7z
   aNKEsx5uy0C5IKiG+zgJ2/wmGBqQYO5LW0cj0dC2gQCBCpRqMN5ejw9ts
   fSZQYKLcYTsTPrmyFAf4sb6Xtb9v3FNhz1Nm9oTzUhRQRuIepRI6q99Fj
   hMhLH+XNF4mw9WomFCKEcAx89gFYyCwY3i+fHGraGMRVVjHBIljf9u89F
   GgRv+HTJN5hBQtp6BeFewpRVhGY0jsH+udiT7a6sXmcGxNCz0NSkawizw
   WK2Kk6BlpWGduWLtau3DzxA1l5wdl2/z6AFRDoA04/KWlyl6vDGgihog7
   g==;
X-CSE-ConnectionGUID: hO7+DnoiRj+quzSL1PwipA==
X-CSE-MsgGUID: 7yb+8nvVThi777maagQPaw==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="63625136"
X-IronPort-AV: E=Sophos;i="6.19,253,1754982000"; 
   d="scan'208";a="63625136"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2025 16:05:39 -0700
X-CSE-ConnectionGUID: yoRrl42YSWSxN7hnSZHm7Q==
X-CSE-MsgGUID: ZG4UhXAqSnWJRq0FyxFC4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,253,1754982000"; 
   d="scan'208";a="189669298"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2025 16:05:35 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 24 Oct 2025 16:05:33 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 24 Oct 2025 16:05:33 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.31) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 24 Oct 2025 16:05:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QvqgZm3HOhy0b35/qQQoAKCajPHxCpzC7fo8sf2bdcfPj+UMMtmP/B/P3IG0vvQnUTck51r9Z05YpDwVJSGW8cd+CqMlhFx8CNVWPH9t5OZ1lvU/+eSyrtoizPkPasnZni/exnhtfXee8SVfI3eYP6UF+u7M7GBn83ea3NgtsciwUf6DLxnKcJLFU+OpQuffODCq9B+2R7XmfnOgARLUyJEppQk7MkS9vn71LFm27bVKkjYawH6x1OMWTID/jeCNtF5KAP9lHq4GihBU3G4+XfjA0xKmBMnqchq0qP990qkGEH+2TLimrBZMOXiq1pupW6biw/hEPIm26dj5SxL86g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9iM0YRBtoyn2pKxG3of2/6alE0dsswzD5GYdRIyPAUQ=;
 b=S4kSeW9UmB8585Os226qG1j1LGq6CgFUJgOoX9ZnWiX183ojsPXq1I1WkIdP57shxlHYurvSke2dB9ly0UVvoUJc0FoYzdva36yXxs67SgpqTLgEVwiaarZP8PwXfVtYswwJ9ro7dHtWZZJs0m8x6HW6R2UAESIRfmD6Y/aRlqXkR8Yf3hbBsM7ZPqQaPRF1d4cOHInB+Xk3tHE5kOY4lc9HvBLwfpCNZvJjEv+ghyzGonIH07Ty28CGNUhGSkIdGLpbpGtr415PkwvyTPX2RjYc8YtBpo901FRHpjNF6zY8Y+uW2tEMpG8imtJQYX8t1cV0kW9Gm6ivuyxEc2zHOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by CY8PR11MB7267.namprd11.prod.outlook.com (2603:10b6:930:9a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Fri, 24 Oct
 2025 23:05:31 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%5]) with mapi id 15.20.9253.011; Fri, 24 Oct 2025
 23:05:31 +0000
From: <dan.j.williams@intel.com>
Date: Fri, 24 Oct 2025 16:05:29 -0700
To: Michal Clapinski <mclapinski@google.com>, Dan Williams
	<dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>
CC: Pasha Tatashin <pasha.tatashin@soleen.com>,
	<linux-kernel@vger.kernel.org>, Michal Clapinski <mclapinski@google.com>
Message-ID: <68fc063946fc4_10e21003@dwillia2-mobl4.notmuch>
In-Reply-To: <20251024210518.2126504-1-mclapinski@google.com>
References: <20251024210518.2126504-1-mclapinski@google.com>
Subject: Re: [PATCH v3 0/5] dax: add PROBE_PREFER_ASYNCHRONOUS to all the dax
 drivers
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0111.namprd03.prod.outlook.com
 (2603:10b6:a03:333::26) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|CY8PR11MB7267:EE_
X-MS-Office365-Filtering-Correlation-Id: 400f625b-1a73-4674-1bc1-08de1351d47a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NFNldmxrTmVkcklxU3R2d1h2cGFoQnRLTnBEQ0RYR3FzL0taU0NEaWZjeXZn?=
 =?utf-8?B?QW5tc09XTHA1bFNwL2FGTlVnRkFuWjJRc0hiUXR3WHpRa0U5bWhPTTdxUTlL?=
 =?utf-8?B?T2NnUjNwMDBSUkovdXNBK0JRL3RJek9URkhjNzhFU1pZMDZnWVhHelNtUlFL?=
 =?utf-8?B?NzlnYTBPRmx2b3FjK3Vld1VCaDBMQW1CdEN2Rm9YS2pzVUhiOGhjTzh4aXdp?=
 =?utf-8?B?ekF3bjdZZDF0T0pYQWw5ZjFXbnNkR0RwQ2MrVlY3b0hRbHlwQ2RERVZ3RXJH?=
 =?utf-8?B?OUR3eFhQNUVuamYreitCSlVMRTlvcFdBb1BvbXJxajIrWmhMd2V2NG1aczRw?=
 =?utf-8?B?ZlhwbW1YUkhtd3I5Y3J3VGk0OHZaUDFwd2tYK1hFblFyak8xTFFHYk5KaTJj?=
 =?utf-8?B?RzlPc3JjdVhoTGZxNGNSRUsyVDdJMHFEdGR4NkJwVUVzYldrcGdweGNrZmlD?=
 =?utf-8?B?NFdEZ1EwZ3R5K1pycERvOHltVCtwTW5NOGhPZ2pWVWhCWEVEUFFScVBTRzJj?=
 =?utf-8?B?dlNhaU5kMlR1alFRYXE0RXpDV2pka3V2NW5PeldFWGl0Ukd4RXFXQ0JXTXRq?=
 =?utf-8?B?Qm1CRGxYLzVrZ1JSMmQzT2xQdVZRUFFiWG1BZkpRWHlnRWRtRDlDVGpSam44?=
 =?utf-8?B?emx2OEcxYmdIYUVBRTArZFgyWlU2UFhCdC9GaUliazBBOUljeWl5V0xscm5G?=
 =?utf-8?B?dEVMY216TEtyM2kzY1VjVVlzREpSMEw0Z2M4K0NKQUw2WWU5RWgyY3FhUC9W?=
 =?utf-8?B?T2p0QW5BVmR6Q1F3TmYwUlNIOE51c085NzNYTmRDc0JmcVE0aWxtZElqV3VW?=
 =?utf-8?B?dnNtR3k4eURuUHdoNmpIMTZzSEd3alhmWkpnOUViMExRRVZudDZ1Q1B2dDcy?=
 =?utf-8?B?ZXY5QXZKZkFwVWpOek1vd2NHZS9zN1B3ZmxMalROMzREQnNOc29vNmQxaGgx?=
 =?utf-8?B?UXVuam90VVNpTzZQUkZmL0VPQlNvMEFHYVZWV2Q3djllS2hhN1Y3THlVeFk2?=
 =?utf-8?B?SzdaSGx0MlcrcTVwek1MRFVNb3pSMUdMazdDWFFRL2t0K3RSckRON3JTSmhM?=
 =?utf-8?B?c1l2MmxzWC9rWS8yTmZ1SVdpaWV4YjNPRDRwTjBYNFV0S2lQZ1lYNy9GQUhh?=
 =?utf-8?B?Zm9VZC9KTldISlF5b1lzNjZWSmtNWFUyV09vMWlnZzVJa2pSU25qYUNPTWts?=
 =?utf-8?B?czJGMUF0Ky84MXIxQVNLandiaFRPQ0M1WDFVRUkydkFldk5KTDgvRVhYUVE2?=
 =?utf-8?B?eWpHS1RzbnJlVUl1bVViUXc5aHp3ckxjdjVaUTFsbXVXaVJKNjd0ZnJXTnd1?=
 =?utf-8?B?MEhKc09UUkdMaEoybUNGU3RucWVYNWJsL2Q0ZVhiWksxSzRlTzFXMmphazc4?=
 =?utf-8?B?dzVKbHBuVm9zNW5NMmcwbmErczRuWWYzZGFQZHFSSjdZczJnQVcwOFA2RzV2?=
 =?utf-8?B?Yk8wUTNhVVFqRkpLdm94TVE1QXNxYll0NUpkSm16V1RYQnNxWG04aDN5NzNx?=
 =?utf-8?B?K29LeGJ2S3dQcFptZ3hEaGFzWHMrOU9BUE9xQ3E0V0lMMnhNdkhlNmRzSnJY?=
 =?utf-8?B?YVVRL1lOcWZYOWE0cEhzUDl5OXJsU2I2NFJNSml3bUszRjAvWlFEbmczUU1U?=
 =?utf-8?B?eWRwMXc4VDFNY21UdkJsbHFrVmdIaWRSNDZkK2ErdjcreFhzQzVZZjZFdlpO?=
 =?utf-8?B?a1pXMk9GQjB5S2hpWWViTlpTSnB0a3FEVTI2OEZjRDE1TEV4VWthUTBTd2pH?=
 =?utf-8?B?clFEcDJROEU1bVhBMVVOR3Q0UW81R296dWdxWjZMTnlrVlFFa0M1YWhtamxC?=
 =?utf-8?B?VTBjS0tjSFFkRjdzWi8wWkQ4elFHcXRnbU9hbXFBRUI4aEY2NUw0UnRkN2FK?=
 =?utf-8?B?ME11QUZJQ3JyQnY0MzRpL3YxY2RFWVN4K0c4TmVWOE9TU0hPOGw2S25TcFJP?=
 =?utf-8?Q?0XHz8+FJLcHEoRemZ7Ptri8HiTIkjwin?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y0kxTGdoUG9PSWxyMWh1K2lFZCs4OFBydkhQNW1CREY0RjV6QzhnSnlNZ05U?=
 =?utf-8?B?RWJvQUwrY1BnTTJka0c5c0VlZDV2aExzUTk4anU5Q2dDU2RMN3EwZzR2NGIv?=
 =?utf-8?B?MWFuUk5rSjN0eDlJTkZDQk55NVNWaHBtZVFqUGtEQW54ZTJQeGUyMVE4Z0Rw?=
 =?utf-8?B?VnBpMUE1RU5WSDc1ak14cXZJNGYvbUphYmhjeUxwWjE4a2cwd3JheStGSWNH?=
 =?utf-8?B?bWc5cUpSdHRTeFdWcGtJSjU3R1VVTnFBTUZvYXU0eFBIbXM0MUFkcHNFbEQz?=
 =?utf-8?B?Q0pRNnZwL3R6ZjJLZDlmQm5sL1VyR1NRWHA0V3RTaUZCNTNUbSt5NjVHTGhJ?=
 =?utf-8?B?di9IYXFCK2x6dmVQTjUzYUFHaWF3VGluNWkwcmJpTzFoWC9jK1lRcm5rdFpD?=
 =?utf-8?B?LzM2Mm9YdFpQZ2p6Ymp3L0J6cmY0akVuWEJ1MkVMbUhmQ3hUUEdwUUxHSlp4?=
 =?utf-8?B?YVFUWnpSK2J6WGJwai9vMVkzdGFxbXJXZ3Q3N1VHSk0xdlZUbWZCaU0reG9B?=
 =?utf-8?B?cFpCdis2RDdaMy9abkMzTkw4cEdCY09hcGpsUEJNTm1Vb0EzUkdYZXJJY1gz?=
 =?utf-8?B?bEJLY2RGQ09kVmtvRjhBbTdtNjFjR1E1MWxhcS9MWmRHNnpMOGR5SEVBUWIw?=
 =?utf-8?B?VGxJNlRjSDhzU2x4OVZFTkJDaXA2NnFTelJ1MEJtcllXSGxZNlg4MEZhVHFx?=
 =?utf-8?B?MXBDZDdraDEvUGVuQ1RwcTVjTE81dUJMWW9LNS8ySHBOZkxxcGpnUEpCRVcx?=
 =?utf-8?B?bEFUcHpMclVtZGdHZnJ5WHkyTVhYQTVCQmM0dEtsLyszcDBVenZyempRaThS?=
 =?utf-8?B?TDlkK1NWcFNoREthNEdXYWlqZFVsR1FzbC9VeGVKbkVIam1GZmdpVCs0c05Z?=
 =?utf-8?B?alRkMi9lai9zYlY1TURjcjY5djIxTXJyUmFNQ09NbkdRQ2k5K2IvcU02ZG9o?=
 =?utf-8?B?cjNiNXhPTkFzS2xhU2ZsYnJhdU9OTk5iWUlneVU5NGpIOXdLTlpHYWxVc3Zo?=
 =?utf-8?B?MTJWcmYwUmYyenZnL3g4RmQ2UGhlV1B0bVVLOTM1Tk1uVEQzNjc1KzBKMHBX?=
 =?utf-8?B?ZFlNcHFxZE5ZWWFBOVhYUWRZYWllYmUxdUVjWHQyb05RMmhFMXRxQUV5SEVi?=
 =?utf-8?B?eUVPZ2JuNjBCQ1VWMk5YWmdqUWx4SGtIYnk4ZEl0WEppd2ErOTlLdXV5VVpx?=
 =?utf-8?B?RFRkQlFvV29WNHVJOXBYNXM4THptRWkvY0p2VE9JMXdXMStxU0NId09PRU1z?=
 =?utf-8?B?QzJ0RjZ3YytVYWY2WDlhejBPdy9ERERqQ1ZxMDliZDQ4YUE0VVp6VVhvMDhG?=
 =?utf-8?B?M0N3U0dZOUNnclJkUmlZLzR0dlNNZldSVGFTcnp4dkJGaExyRXMvOEtBMTBK?=
 =?utf-8?B?U1Y5RktZd0JvOU9nTnVxZHNpSUY4UDRaN2d4ZXNnRUhwdVNIcWNESkcvMEUr?=
 =?utf-8?B?VE00YTlPMXZJdmJMeWhzZGxvc0UybmNKTHF2a1RGZXBhZG1DTnZxMWw4RHZH?=
 =?utf-8?B?RWEwbEt1aStHU2UydnVmSVY0a2twR3hQRUdJTkNwWDQzdzZOY0xjbCtXU3Zs?=
 =?utf-8?B?QUVJak1wVFJRbTBlZGUrN3lOazNHdFBPWGdhSmEwZ0JSc0VESXF4TnNCcVVC?=
 =?utf-8?B?T2JZUlpFaE04ZTF3dU5XYVJJaDZmelo5WWZtUWlKV0F1anZqNlluaTQzdFh0?=
 =?utf-8?B?NUdkazh2SmJKSkNyZnVEUGZRMTQyQnJXMDBnMWg1cU5FY2FORkZ1cEh2emVZ?=
 =?utf-8?B?aTZZYzBZdFRlK3N0U1V4OFVrNmNUYWdTbEdsZTFjTlp4bkUzdlZwcFFZSEV0?=
 =?utf-8?B?RktNQ3BLSk9zNUNQSGhqZzRFb2c2RWoxQXFJRnoxa1lXUzBLNkVLM1VjVDQ2?=
 =?utf-8?B?SC9zZ2ZxQStZYThWSWZJVHdNa2xtQkdITmNqT2lRNThlbzhlcjJYcTZtZ2wr?=
 =?utf-8?B?TE15ZUNFeVNxYnhheFlxNjU2SUxEZmFXQXlDS3hYM2QycVR6TmZBMWFEQm96?=
 =?utf-8?B?UHRiVUVqbXE2b1MzS0JUTU9aR3I1ZEVJZ3hMdGgrUUQ0ZG9JeDBmOEtZUVBa?=
 =?utf-8?B?T2V3Sm04L2FvRXB5OVF5N0VpdlVCa2FsSHBLaVdRNThISHkxL2VrRUJ4UUR6?=
 =?utf-8?B?em9pYk56b1U4aXhIRURFRHd3cEMzV2FyR2dRbmk1dlRQWmhGaVJtUnRZYmFl?=
 =?utf-8?B?OHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 400f625b-1a73-4674-1bc1-08de1351d47a
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2025 23:05:31.2750
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OtnEF0HDfdvUwY/tZKY+9r3qa0v99OtprsuvK8z/p4cE9kpTiyJVTYgVmH26wq+LuAWNFIzwmwSIu8i5vHYg/TmOI2hnyOtf1VOmXFXjvt0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7267
X-OriginatorOrg: intel.com

Michal Clapinski wrote:
> Comments in linux/device/driver.h say that the goal is to do async
> probing on all devices. The current behavior unnecessarily slows down
> the boot by synchronously probing dax devices, so let's change that.
> 
> For thousands of devices, this change saves >1s of boot time.
> 
> Michal Clapinski (5):
>   dax: add PROBE_PREFER_ASYNCHRONOUS to the pmem driver
>   dax: add PROBE_PREFER_ASYNCHRONOUS to the kmem driver
>   dax: add PROBE_PREFER_ASYNCHRONOUS to the cxl driver
>   dax: add PROBE_PREFER_ASYNCHRONOUS to the hmem drivers
>   dax: add PROBE_PREFER_ASYNCHRONOUS to the dax device driver

Looks good, thanks for the split.
