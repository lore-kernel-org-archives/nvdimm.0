Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CDD9156677
	for <nvdimm@lists.linux.dev>; Tue, 22 Jul 2025 21:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753218334; cv=fail; b=Hro4JEfbWXNIvKejza+52Q8qAVbVQ1Jdh+Dcr7n++TWmZtFYR5iTLYT8Ju87c7VyQHkKjaAwCNbhtsFMiWowXCqsuZg1BQkjDWDo5frah0/gWixJ322CdcAmfdz3a4SMxuuvtRRs1ZJ2uuDvzG9Jf4UXDTAVViEzE0/3AHxONn0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753218334; c=relaxed/simple;
	bh=DW8kqcvhjAeU9N8Xo4WCcjH8uZZBWQveoZsPatp8kz4=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=quYai1T8nMHWfqSYWjTJH5OwcMDfCuNDcPFXPFplMC1wiytHlLgHO8btT8C+QCyqR09s1Bkj3MyTq5N7ukXdYy4aE6cCLb5WjpP3uGN6NrAI1mWFrwDuDOfkpccrrD9V2KXWweCY+EBRs0/guMnS6IQ7uU7L0jBVNXRpTt6A18E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kis2pYTQ; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kis2pYTQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753218331; x=1784754331;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=DW8kqcvhjAeU9N8Xo4WCcjH8uZZBWQveoZsPatp8kz4=;
  b=kis2pYTQkSFHQBYVUeIdSGRlWW2JOiPeL9eAshU8OCxLKKERiqVOMGCO
   hem4hW/yjbKbRSvZ9YMD/H5F4GUONt9gaLuemS9nfZbUCf4025SU5AuS5
   1MeG12Zr5uaSePYvT2boOO0EdoBS5rMoSFVDIP61bZZPfL4nfqpHRxni0
   EZvVwsArTGyROQBc4tpb5cphQkgtREuNExlFez7POoQ2Ce3+JyIA88yjc
   voo14s8L13dGOuIt7NMTDzX5h3OZoHZ+UHBRba735qF1Z4IyJueZMuqGn
   0liu8D7yDU1L7TB5ll2Hm0AgNq6Ss7Zn5uEE5Ph0TgKhqzU9FjqnOvM9R
   w==;
X-CSE-ConnectionGUID: tGwusSRfRzeaZHlOmvWBWg==
X-CSE-MsgGUID: PAtHpOFHT6KXU/ERpd4ilQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11500"; a="66553973"
X-IronPort-AV: E=Sophos;i="6.16,332,1744095600"; 
   d="scan'208";a="66553973"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2025 14:05:18 -0700
X-CSE-ConnectionGUID: YSrzNrkFQzGmFp7VnQEAew==
X-CSE-MsgGUID: 5L5C5neRRZSFb7n55gciFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,332,1744095600"; 
   d="scan'208";a="159801119"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2025 14:05:14 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 22 Jul 2025 14:04:06 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Tue, 22 Jul 2025 14:04:06 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (40.107.212.86)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 22 Jul 2025 14:04:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hBTJ/YJosaOb0tALmyk7IZcniGvTSgCJxeKmyRy5mj5dstI+oAUq6C+Vd1FWo3hndGSuzvEknaishLOZyfqHI1oZZ/OhBXTDznbOEUi3WtGka7peNLDhUOlMEJIKBPj5PhSl5V83O3TI2y6bSMeiye/WJHlCog0c55DBs9Abzs6/iN5NZOWOP3MusPo6FhNFYREdKuZ0WxaSWiXXEzXTEGYPIjfsTUYg59cEoF3P/X2e/MMWZbaq9vyavRpM8TEw0jEQw1tct0Rw6zfgTrb889nvWJJKN657iww4p5SJi/skhEJRNazrrSrhpWTnpadkR3a+39PtXMpHu6xQKnRRrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jMWrBiJ0yRnQgOpXcjagbZTcoxUZ9OvpeYRsiqDs5+E=;
 b=iszGCSze9duiF/vpUuzXX/lBSwv/Il9HYPjCQvu2urxv0ftKaElaVj2+YtxHJR4PBcTNGPpIePGHZb+5OMGbg8KvczdQU6Q25ToTNqjmLEgWf/p/IkEILBctR8tbWShOMmnNgsdp0yKzvNVM69rclYv0MeW14T7asyU9TWgDjmKpWE99oHcSZ4i+F1Eg5vk3qGTH307LIMV+8a3ktGsLLd8Q7PHVjxzbzwWVXw1AMAD+K8Qw7RHhLgN2qBzxqUVLf4YIWNzSqz4qcmWimrCajf34jVs/y9pKUVwvpDilWm3Q30kRta0V6Sl/VFU9EiHtpwxbAxE9G09UosLkPVRDRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SA0PR11MB4526.namprd11.prod.outlook.com (2603:10b6:806:96::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Tue, 22 Jul
 2025 21:04:03 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%6]) with mapi id 15.20.8943.029; Tue, 22 Jul 2025
 21:04:03 +0000
From: <dan.j.williams@intel.com>
Date: Tue, 22 Jul 2025 14:04:00 -0700
To: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>,
	<linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-fsdevel@vger.kernel.org>,
	<linux-pm@vger.kernel.org>
CC: Davidlohr Bueso <dave@stgolabs.net>, Jonathan Cameron
	<jonathan.cameron@huawei.com>, Dave Jiang <dave.jiang@intel.com>, "Alison
 Schofield" <alison.schofield@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>, Dan Williams
	<dan.j.williams@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara
	<jack@suse.cz>, "Rafael J . Wysocki" <rafael@kernel.org>, Len Brown
	<len.brown@intel.com>, Pavel Machek <pavel@kernel.org>, Li Ming
	<ming.li@zohomail.com>, Jeff Johnson <jeff.johnson@oss.qualcomm.com>, "Ying
 Huang" <huang.ying.caritas@gmail.com>, Yao Xingtao <yaoxt.fnst@fujitsu.com>,
	Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@linuxfoundation.org>,
	Nathan Fontenot <nathan.fontenot@amd.com>, Smita Koralahalli
	<Smita.KoralahalliChannabasappa@amd.com>, Terry Bowman
	<terry.bowman@amd.com>, Robert Richter <rrichter@amd.com>, Benjamin Cheatham
	<benjamin.cheatham@amd.com>, PradeepVineshReddy Kodamati
	<PradeepVineshReddy.Kodamati@amd.com>, Zhijian Li <lizhijian@fujitsu.com>
Message-ID: <687ffcc0ee1c8_137e6b100ed@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <20250715180407.47426-2-Smita.KoralahalliChannabasappa@amd.com>
References: <20250715180407.47426-1-Smita.KoralahalliChannabasappa@amd.com>
 <20250715180407.47426-2-Smita.KoralahalliChannabasappa@amd.com>
Subject: Re: [PATCH v5 1/7] cxl/acpi: Refactor cxl_acpi_probe() to always
 schedule fallback DAX registration
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0076.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::21) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SA0PR11MB4526:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f204127-783e-4870-f27d-08ddc9634997
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?c0hjeDdkL01SLytQbWY4bEZpeGxsNllSejJkNWxYTUN1Z0xQWVc0ejdYZkFW?=
 =?utf-8?B?L3M2dE93UDhmVDdiZjg0aWptYzNKOVhJclprTWdjNmpmeTFBT3RTZ0FvWDk3?=
 =?utf-8?B?a2h2akpYYlhoT3dxandwcVUzUGR6QUFGZmx2bGhoejhmekxPd1BnNEpzdlFB?=
 =?utf-8?B?eUtmSWZjVUxBTEpzYXowb0drUHExNDloRmdMbTByVlpIYzBkMEt1TllYL3k1?=
 =?utf-8?B?bGNpeit2eHZFVXJWak1BMWdCb0pSTVNRR29NbEZCbmJwa3lQMjk3Y0IvQ2Jj?=
 =?utf-8?B?RG1Ecmo5bVJtdW5WV1hQWWZJZkwvYnV0NUtvbGIwZU8wZCtCUnJjMTNBU1RF?=
 =?utf-8?B?aGtTanhWTGMxSkJMcHFxZmIzbHI3SHF0SUw4eGNnMERDeG9saUprQnQ5bHg4?=
 =?utf-8?B?RDNkYktOZmlxVTFqeXhNL1MyemlQb0o2YzlVYTVpV1l0QXpKb2xOMzFjWmow?=
 =?utf-8?B?bzlpRjN1VVd6NVdmYlhaYUFJMFloMUpGZFNkQW9icjF4ejNkZU1LMWkrbERD?=
 =?utf-8?B?eFB3WVV6am44ME55RFpuWkRSRXFmMnYvUVBiQ2ZBM1BycXpyUk5rMTJXaUlG?=
 =?utf-8?B?dzhMaVJEZFUwa2MyeEM4NmhXektSbStPQ25ZWEJZRm1SZzV5SHczamZCNysw?=
 =?utf-8?B?L1Y1c09mZ2ZRSzR2a1l0RitOd0lQWVlIRWtBK3ZvTkdhN3ZVNTJ2eVZIRHUv?=
 =?utf-8?B?SkQ4YmM5ZGphd2piQnJBT25sY1lLZnRhYWpZVXJ4ejQ3THJDOE5WNkFBTEhu?=
 =?utf-8?B?YnIybGdEcHltNWpzVEhBdjhOUDMrVGdIVEVoaWgwa0NDS1BlNjRKaVJzVitr?=
 =?utf-8?B?ZEtWbUZPUHAvY0tUaUFNc25QejAvTk5nTitmSkhIeXllWmwxa1EyY0ZZYklZ?=
 =?utf-8?B?Z0RJLzdOL1VEY1JKV3RjL0U5ZHlhdzFzTHF1eGhuaXR6SEVnZzdTZFlXZEMr?=
 =?utf-8?B?eEttYzNlWlU3ZFM3UnprS3lkY05GZ0RIc2EzQmFZTWc4T1ZsWmxPVXluRk1i?=
 =?utf-8?B?aHZUTkFjaEJrR1JqTS80UmhlbnkrWVk3WDM1b2krQWYxVDBsSEFDOEtjWHZV?=
 =?utf-8?B?dHFRa3ByT2V4MGlqNk5jdWoyR0RxUFpubG96eFMyb1lLODJUWjMrOS84aUF0?=
 =?utf-8?B?dU9zYjduY1o0bHNiMEU4aU14cFpTUXVTS0ZURElXNy9jSUY4MmdjU21lVlBN?=
 =?utf-8?B?VlV6RlRtV1JXcHR4YjVEdkU5RS9xd3J0VzZBNy9Hb1dmWjhEWnk1Q084ajZk?=
 =?utf-8?B?UXdsVjlkUE41cHZLVCtFc2VDdi9zbFZwejZqUzN0bnRHMkNidm5yblhPb0JC?=
 =?utf-8?B?UUE3V05waENYbGNGNmJKWW5VbmMveHVrSC9ndCt1aWtQRktzbHV6ZFhDMDZY?=
 =?utf-8?B?K0w1QTNzbis0ZUxLYTZVSkxJSlRjOENCYkpOK21mdmpmODJIa2ljNjNxT3Vj?=
 =?utf-8?B?QS9Ya3YxRGYyY3lYK1YvdmlldmM0ZXhGT0NHM0NDRGNzc1VoTzR1MEhLNWc4?=
 =?utf-8?B?UEV5UnZIV1I4WnJNc01PSmZwOFZDd2lITEZleDdKOVVoVnJhMU16YURpWnhY?=
 =?utf-8?B?SDhVQ0E3ak1wSGNXeUIzejZqaVV5QnN6NTdvQXVHUzB5TGNQRmtYYkJ2dXpL?=
 =?utf-8?B?N2JFTjdRQ1pGRVhGVWthRWZscTFxc21NYk5RbzhzSSs2TXFJamJKcXN2c1c5?=
 =?utf-8?B?QUVkZlE2SCtqZlhycitvWjZDeFQ4dzdtMzRlRlBhRWFJdjFpZ1ArU3gwYjBB?=
 =?utf-8?B?clFTa2s1MHlGaHZHVjRyOTRkSFpPb05VbU05MlRFT2FRajZQd0VBam1IVUxo?=
 =?utf-8?B?YmYrUHpQRGl1cE02TGNiNzR2cnpRTTB6YnJGdnBnWXNjVVBqSTFvUlRDSHFM?=
 =?utf-8?B?YmVudkdJNEk2QnpraTNwSm90Zk5ib0ZPS1NQNE1jamg2TkNmU0paclZCaXBD?=
 =?utf-8?Q?wj0ZKazyhdo=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eWdIaWNQN0Rub3dMOUFXd3VPVnRQM2tqUk02NVR4R3o3RWNMUUhPTzBiNDNz?=
 =?utf-8?B?R1owbDZGMHMzUGlHbVY4dmJvRUVxUGJzYjZVTlZLdGsxUnV2MVhVQ3FsOEtS?=
 =?utf-8?B?TFJBRm9kUmVLa2paWnlXNHE3SlB4dzFucUNyWGVYbkhrdVFndCtKYkVBakx0?=
 =?utf-8?B?bnV4eWIrREI2UVNxRys1TXZCV3ZWS1RKNm1JRVFWcnJod2dsRFVIMU12NDcx?=
 =?utf-8?B?VElkS2NmZjdlbUFBQnNsVmpJUnF1d1lna1R3UGZ0a3dFTHhkVXVzdEJ2WnV4?=
 =?utf-8?B?M21lWDUxSXRZNGQ0Y2FtU0l5eXF4L0NYNGhnYUxyVmpYWDRSUzVhNjRpYVhW?=
 =?utf-8?B?cGxrWmpnSFBNcWpiUk5pdHQ5Q2dyeHlDdEVCZlBHbWNBVjVrZytKREcyMTg1?=
 =?utf-8?B?SmpsYlQyaHRSZFplREtzb3BtUGRWdWJjQVBmT09OS2NBbHZHbWQ4WE52YWM2?=
 =?utf-8?B?KzMvTDZJakJHMVdUQVVmL3BWNFR0ZDhnT1pGYUhrWTVvTERkUmZmOGhqREF3?=
 =?utf-8?B?SFBBVTdMRkxwbU5FdGxScmJqYVdVT1ZZVU5FT3RweThUSURBZlZPRk5RNEpT?=
 =?utf-8?B?QnRlR0xuZ1RZeS9oSGp1d2UxYVJDcnhTanBmNWRaYUZjK1lxcEROTUIwbXla?=
 =?utf-8?B?NTd4djBmbXYra3IxbytGY1ZmL2ExK0VaM1A1TU8zWHBsakRDR2MxNkFsMExh?=
 =?utf-8?B?TUYyUmtkRnJpaHZnNm5mNFllbnUwZ1RlK0tQL3ZidE5rcGJ6a3hiUzhRUmdR?=
 =?utf-8?B?dGhWZ0lDZVgwMDNLQzJnTCs5RC9yUTRYWmcrN21QWmxVeFRvUFU3Q2Ivbk1w?=
 =?utf-8?B?cGdvcUtFWXdKTVVHcVMzdDI2Vnd5NUJLV09XWFMvbGNyZ0k2TVU4QVQrb0RS?=
 =?utf-8?B?UzZ1VWhNMG1iRWh0Mmxod1praW5SVkVuQXpaajg0MGtvQ0UzeURoVGljNzRo?=
 =?utf-8?B?eHhvaUVLVmo0dFI4andGNUtHUEpBd21mYml1Mm4rQVlabUpZV1ZocWJ3ZStB?=
 =?utf-8?B?Y0QzUGI3eFN6MGs0MmQ5cGd2MS96NTVPc1lHY1VCWWRaa3dNbVdGaEljbWRu?=
 =?utf-8?B?dUJpMmc2S0hCU1NOS2YxM1I1OHpZNHlXdnN3SVRmOGxKSXlLa3B6c2dHejJz?=
 =?utf-8?B?YzZsdFNpYUJNb1U3TytUdUFtK1V5TlBWZXU4OWppV0pmWFZHajNsS25XZFM1?=
 =?utf-8?B?OTR3VHJ2L3FxR0RCTEJzSnpRTzcrV2o3cEVMUTVoMDJKaEtaK0ttbFh4SFhJ?=
 =?utf-8?B?M011dE1nWE53bFVyZHA3YVVZWWlkbFdQcjE3Mk9tWUJtNFpOMTVSYXdzWHls?=
 =?utf-8?B?QmlydGVRMStzbk9OdlF2WXhDb3RjRGZkYklGUFU5eUovWnRiS2E4QUV6WXVs?=
 =?utf-8?B?SlltOVRtdW8vaUNnTklKRXJPRmVhK0d6WmJjUmVRa05JbWhid3grWjBUQ2M3?=
 =?utf-8?B?MlpiWEg2cTd6ejdaWWtVTTdNYldiWlRqNDUwRjRPVWgvUDFhQTdaZ2krT3FR?=
 =?utf-8?B?TFlJdERaZjh1di9Kcmk2bStGK0ZQWTc3ZUdLVkt1azMrNXI2cDVxTEcwQmQw?=
 =?utf-8?B?c3hqRU9UWGYveW5Bb1dGckpjYk9HWHB6S2g1NWNvdzRSY2k4R2d0UUVGbGFQ?=
 =?utf-8?B?NHBnYmVocmIyMUlhSmFhekFJRHo2V3dacnBtMGV5ZGtaSWk3NENCU3ZIa0Rw?=
 =?utf-8?B?Um4yNURSRmtEU25LRzYwT29wd1FKSXBvSzhEQ2QwVzB3S1h1TjBWOUswdXRJ?=
 =?utf-8?B?RUhwUkJ5Nkt3NXQ2bnM3clZqangzVE9rKzR0WGkyU2p5T3ZKQ0pUaU5UNkUw?=
 =?utf-8?B?eTNVWVdZdUdTSHRtN3VSOUc5NEZISHdDM3NRZ3ltNm5YOGFCblgwQ1dlYTQ1?=
 =?utf-8?B?ZXVXWm0yNzQwdVQ1UDc0cUJYNlNGb3ZZdFJ2aENsSkxJMWl5Qm54aEoxeGVy?=
 =?utf-8?B?VHlJSjRIM1hzRWVlOGxWNGZuSWVsaFFPZEdFRmx6SEdjZXgvSEpuVWZJUzVr?=
 =?utf-8?B?WkIzcVhSeDM5NWsxWUhFSjdzY2VwZkM4VW5WaTNvVkM1czQ3bTdBK1l1WXhW?=
 =?utf-8?B?RlcrOW9zbkZZQStqS0RkalgrVEpWVDZ6TlEyVjdpQ29NMTFEV3pZKzY1OWF1?=
 =?utf-8?B?WnNHcTNLNENCOXA4ZUpFYkRnNENCOUtzSVBjOGpMVFJqOUl5L2NZUmJVaStF?=
 =?utf-8?B?a3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f204127-783e-4870-f27d-08ddc9634997
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2025 21:04:03.2236
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wQCRkLRP9TZZRd9NyeOhc9yOTbYx4ca0JWqRB72+AjHBZ0kHvP+suyxkPUwiN6uccKqzTfnQvsCzJK35tDRN1+UzGZl0CNPegyi0esKebX4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4526
X-OriginatorOrg: intel.com

Smita Koralahalli wrote:
> Refactor cxl_acpi_probe() to use a single exit path so that the fallback
> DAX registration can be scheduled regardless of probe success or failure.

I do not understand why cxl_acpi needs to be responsible for this,
especially in the cxl_acpi_probe() failure path. Certainly if
cxl_acpi_probe() fails, that is a strong signal to give up on the CXL
subsystem altogether and fallback to DAX vanilla discovery exclusively.

Now, maybe the need for this becomes clearer in follow-on patches.
However, I would have expected that DAX, which currently arranges for
CXL to load first would just flush CXL discovery, make a decision about
whether proceed with Soft Reserved, or not.

Something like:

DAX						CXL 
						Scan CXL Windows. Fail on any window
                                                parsing failures
                                                
                                                Launch a work item to flush PCI
                                                discovery and give a reaonable amount of
                                                time for cxl_pci and cxl_mem to quiesce

<assumes CXL Windows are discovered     	
 by virtue of initcall order or         	
 MODULE_SOFTDEP("pre: cxl_acpi")>       	
                                        	
Calls a CXL flush routine to await probe	
completion (will always be racy)        	

Evaluates if all Soft Reserve has
cxl_region coverage

if yes: skip publishing CXL intersecting
Soft Reserve range in iomem, let dax_cxl
attach to the cxl_region devices

if no: decline the already published
cxl_dax_regions, notify cxl_acpi to
shutdown. Install Soft Reserved in iomem
and create dax_hmem devices for the
ranges per usual.

Something like the above puts all the onus on device-dax to decide if
CXL is meeting expectations. CXL is only responsible flagging when it
thinks it has successfully completed init. If device-dax disagrees with
what CXL has done it can tear down the world without ever attaching
'struct cxl_dax_region'. The success/fail is an "all or nothing"
proposition.  Either CXL understands everything or the user needs to
work with their hardware vendor to fix whatever is giving the CXL driver
indigestion.

It needs to be coarse and simple because longer term the expectation is
the Soft Reserved stops going to System RAM by default and instead
becomes an isolated memory pool that requires opt-in. In many ways the
current behavior is optimized for hardware validation not applications.

> With CONFIG_CXL_ACPI enabled, future patches will bypass DAX device
> registration via the HMAT and hmem drivers. To avoid missing DAX
> registration for SOFT RESERVED regions, the fallback path must be
> triggered regardless of probe outcome.
> 
> No functional changes.

A comment below in case something like this patch moves forward:

> 
> Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
> ---
>  drivers/cxl/acpi.c | 30 ++++++++++++++++++------------
>  1 file changed, 18 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
> index a1a99ec3f12c..ca06d5acdf8f 100644
> --- a/drivers/cxl/acpi.c
> +++ b/drivers/cxl/acpi.c
> @@ -825,7 +825,7 @@ static int pair_cxl_resource(struct device *dev, void *data)
>  
>  static int cxl_acpi_probe(struct platform_device *pdev)
>  {
> -	int rc;
> +	int rc = 0;
>  	struct resource *cxl_res;
>  	struct cxl_root *cxl_root;
>  	struct cxl_port *root_port;
> @@ -837,7 +837,7 @@ static int cxl_acpi_probe(struct platform_device *pdev)
>  	rc = devm_add_action_or_reset(&pdev->dev, cxl_acpi_lock_reset_class,
>  				      &pdev->dev);
>  	if (rc)
> -		return rc;
> +		goto out;

No, new goto please. With cleanup.h the momentum is towards elimination
of goto. If you need to do something like this, just wrap the function:

diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
index a1a99ec3f12c..b50d3aa45ad5 100644
--- a/drivers/cxl/acpi.c
+++ b/drivers/cxl/acpi.c
@@ -823,7 +823,7 @@ static int pair_cxl_resource(struct device *dev, void *data)
 	return 0;
 }
 
-static int cxl_acpi_probe(struct platform_device *pdev)
+static int __cxl_acpi_probe(struct platform_device *pdev)
 {
 	int rc;
 	struct resource *cxl_res;
@@ -900,6 +900,15 @@ static int cxl_acpi_probe(struct platform_device *pdev)
 	return 0;
 }
 
+static int cxl_acpi_probe(struct platform_device *pdev)
+{
+	int rc = __cxl_acpi_probe(pdev);
+
+	/* do something */
+
+	return rc;
+}
+
 static const struct acpi_device_id cxl_acpi_ids[] = {
 	{ "ACPI0017" },
 	{ },
