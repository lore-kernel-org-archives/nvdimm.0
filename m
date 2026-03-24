Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00CD386C09
	for <nvdimm@lists.linux.dev>; Tue, 24 Mar 2026 16:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774369565; cv=fail; b=pxT6mFnolODOJtbPjwG9sTJB78UGpBCV8lrM7mQoEB1oRBSctfJbxA1ngneUwJVRD0esSNbsfslbZJgGv6FDyCMuW1K8g81Nt9bhwu7DFaM0YMzauum9XGTntrcsuKUZ/9oNfQsov2t/+nJ54+ty1LwJWfN4b6zsNpuwtTmiFLg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774369565; c=relaxed/simple;
	bh=+mCrbAmVCCq9ngJ0SL3WO4C8f5At3YXtjGkluInZ6qw=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=edZx7osAK8IWoq7AI0lGq/99RUmU48ul4uX549vspbQugYZajDCsxKMnOb3LS0O54wsA4CDJnVBkW2yxTcz7kV4iJKmq0Hfr2Ekfc1R7xrL7aljUXVPvbKKx75iuKTW2ntcuT/AAgFxfyNI9ttlByPig1mTcx0ot9pqk2tSEsyo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Oj1gJYbM; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Oj1gJYbM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774369564; x=1805905564;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=+mCrbAmVCCq9ngJ0SL3WO4C8f5At3YXtjGkluInZ6qw=;
  b=Oj1gJYbM/WT5psdQKRXZIdlKUN5OTp5zumzcqsF74HyoAaz33sYH7H7p
   do0LbInaS68XL2o/USZ7ynVi1ooM2SdscVcRaG4A/fuc5AOgJ9OusK9zJ
   f9Qbz/uClJ5C6Tyb09CXFVB4x93R1FXhW9SwzC2kILWZn1pn2fGCeDnuf
   ToVeCreHzioUc2JLhWR4cmZDOImkD6vPQ2oLbOQ7xYhzUwkTsqJCvP1nZ
   0tTlNFS8PVMDEvrgJ8mpTRlkOkSN3H5oc+DdEXAucXuR6BOoK9qAzEmZy
   19pzXR5oiqylJaK3gAZdqOhCnSaY3ApSDgkN8QxFoFXKn3SAkAVXyNTC7
   Q==;
X-CSE-ConnectionGUID: oEivR4G6QLSx7EW5WCXdZA==
X-CSE-MsgGUID: cauWeexCSSWzh1shdBBvXA==
X-IronPort-AV: E=McAfee;i="6800,10657,11739"; a="62944626"
X-IronPort-AV: E=Sophos;i="6.23,138,1770624000"; 
   d="scan'208";a="62944626"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2026 09:26:03 -0700
X-CSE-ConnectionGUID: qi6VhFCYS5G7ovKpBhIs9g==
X-CSE-MsgGUID: VHDXiLCsTqCM3dQPZ+V5ow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,138,1770624000"; 
   d="scan'208";a="247993943"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2026 09:26:02 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 24 Mar 2026 09:26:01 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 24 Mar 2026 09:26:01 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.24) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 24 Mar 2026 09:25:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W3L8W9J18+CnCM1Id6rvKRFmVg6FQoTlv7nlNNsXHqqxNzRNTMJ5jz8vd7Vqzvnar7Bgv+6ze3M+PmvQmX74sLQrkBcnT00C7S5lA2h7Lfk7MSTI4d3CrN5LS1vFHUKa3OC4W55N2podg/b2gKjATDS6nun9rmrpZ/QtPiquRVc2juk7cbUk3chtzOIMWhqzHk3ljSpFMgK+wNmha+VsxdB7Y1nFfyPuvgm59bCJWe+OGcyqA7wpbHaK3Ew1eCbYAvmGCtAMD3yPs2HQot4DkBx5cwl1oVSTG1FwsW2tTjWasg2RT8MmjJvJVQr0s8aBd/2b0+FcYlpvFrURRMB17g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Iw/DRGXLkFNLSvfjAOgjC33esmAf0yI4Btxwu2qNH9k=;
 b=KrypgJhPk6jpgKI05FGQ8bQmeu/dy0tIxsOTkDbFvNFa2X/q5AG9ZSQ+osnUuBZcbaP5Tla3oX9qLgDdGPFkFx3yDXrmrV2AjawSoNzR6gAgkI1St19t3+Vz+ct316Yv2XM9KXnFHE72SJbWpwyeVeemV7osVNfpjw7rouS+/2/H0Lw3Ku4YBT5VBvyGTFIenAYJMj000q9e4zoawoNqHNj/d7d28N25XdwuMjrV222qpffsutvZC1ma8iJwaJi0CqCJ7aOreQuIgBGBVvOUSjRCfQlJrC9nvp0dpe44Z51ysZZW2tSlOgFsCumdQ1lJqjxro8rR5PV7+JbvlErBlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by LV3PR11MB8553.namprd11.prod.outlook.com (2603:10b6:408:1b8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.19; Tue, 24 Mar
 2026 16:25:56 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%3]) with mapi id 15.20.9745.019; Tue, 24 Mar 2026
 16:25:56 +0000
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 24 Mar 2026 09:25:53 -0700
To: "Koralahalli Channabasappa, Smita" <skoralah@amd.com>, Dan Williams
	<dan.j.williams@intel.com>, Smita Koralahalli
	<Smita.KoralahalliChannabasappa@amd.com>, <linux-cxl@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-fsdevel@vger.kernel.org>, <linux-pm@vger.kernel.org>
CC: Ard Biesheuvel <ardb@kernel.org>, Alison Schofield
	<alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, "Ira
 Weiny" <ira.weiny@intel.com>, Jonathan Cameron <jonathan.cameron@huawei.com>,
	Yazen Ghannam <yazen.ghannam@amd.com>, Dave Jiang <dave.jiang@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>, Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, "Rafael J . Wysocki" <rafael@kernel.org>, Len Brown
	<len.brown@intel.com>, Pavel Machek <pavel@kernel.org>, Li Ming
	<ming.li@zohomail.com>, Jeff Johnson <jeff.johnson@oss.qualcomm.com>, "Ying
 Huang" <huang.ying.caritas@gmail.com>, Yao Xingtao <yaoxt.fnst@fujitsu.com>,
	Peter Zijlstra <peterz@infradead.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Nathan Fontenot <nathan.fontenot@amd.com>,
	Terry Bowman <terry.bowman@amd.com>, Robert Richter <rrichter@amd.com>,
	Benjamin Cheatham <benjamin.cheatham@amd.com>, Zhijian Li
	<lizhijian@fujitsu.com>, Borislav Petkov <bp@alien8.de>, Tomasz Wolski
	<tomasz.wolski@fujitsu.com>
Message-ID: <69c2bb11a3525_5162110027@dwillia2-mobl4.notmuch>
In-Reply-To: <2960e485-fe26-43b8-a950-9cdb5a090678@amd.com>
References: <20260322195343.206900-1-Smita.KoralahalliChannabasappa@amd.com>
 <20260322195343.206900-4-Smita.KoralahalliChannabasappa@amd.com>
 <69c19a8c66fd3_7ee3100e3@dwillia2-mobl4.notmuch>
 <2960e485-fe26-43b8-a950-9cdb5a090678@amd.com>
Subject: Re: [PATCH v8 3/9] dax/hmem: Request cxl_acpi and cxl_pci before
 walking Soft Reserved ranges
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0158.namprd04.prod.outlook.com
 (2603:10b6:303:85::13) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|LV3PR11MB8553:EE_
X-MS-Office365-Filtering-Correlation-Id: 66e37854-d0da-433d-1abb-08de89c20698
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|1800799024|376014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: GzGLH4jnUeCPCAIU0su+bj+15XDBRQnR8FwI0WRyzPHPIeH9LyAIg7fhFSR3avUAh/YcGdUHa2Scw95fk2sM0chB0Nb2U4H8XECATJBXba8Aj4D0DVecCQRIdi0NfEyYsSCLtOgk/PpWGaG3Iu9HTnROTQK+iHMSDaqvnlXMtaD19EAz38l0USQp46a6rZgXGPnke+b16fxja7C3JXZ4OgtXzZtK+aC4khSSUGpzQgknX6WtqfRnYP4hIuoYbvPqQxeDf5m/JVsbm9WjvzBuIYr8YzMRToTb+j33FdvUMQ1wItXOoOEjngF8bKlk/uXYWgCBHBqguVHVBV8DqCy16PgfDXrCvwkJhx3CCsJhwexu4oABnPYPJkDP/8isWjdk1WWLRFgRM/XlphcMrOjsyE7HagFqKhLDjf9DCZGXm501xMVsyVivjxGd/aBtrsuQnDEI9MwqdlSNU9gDeZU/3g2fObZ5n8HEOm9S3RbUBro2b6+VbJdP7Pm+Za9lOYgm0mHvGCxnFqGFGJkVEGtZmeTIVCgQ9fr7g22h0GCFTKRQKGWmmSrkVF+2TZzac1gCKKOZpY+mDJ4fGx5G3QzEPCuRQjd8QkYIrwM78EPGPXs8bNA/A4+gbzIixOQf33qEXopUb9lsIuZiiWmU/w+mLkVcG6KDKmtKrgqx8bqHlBYrbyGxCAeM4xdNJjnc7/5emb0S5EQHbsQNRkqyH8Fcc3C4CNKPgECJJbN16pYer70=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V2ZaN08zVTk0KzJXcno2bGNPb3lCQkFMY3BsNTVMMzZ0NCtiMFpMSmc0a1ky?=
 =?utf-8?B?ZVg4UHpidzFKYnVad0xYeGZYL21ZSVpNa1BERVRPY3RwSWxjc3ZUZjRFR1Jx?=
 =?utf-8?B?RGh1VHBDY3A2MXE4TDVVZXdOUnRXZCsvREx4ZDQ0WmpyM0h1Qnh4MktKTkRT?=
 =?utf-8?B?TWV4ZFFXaHE1VGhRN2xmSDZ1ckhpSEZ4dFRiWGFwRHROcnhZZ2ZZbWdKSGJ1?=
 =?utf-8?B?RDJRWVc3YUEvWjkzWkNSSkd6UEdmaHBURnNDc1ZlT3d3ZmhkV2c3bzJNOGRq?=
 =?utf-8?B?bTdxb0RrMlZ5cm9nUjVYSzZKWkE1MGhLeURqMUJIM01DWVpZQmk2S1E1Tzcz?=
 =?utf-8?B?b3hiTXQybHRKMEQvdUcvRExXdHN3STNUMVcyQ0ZQOGZETm1wbGdyTFdzYWhu?=
 =?utf-8?B?d1d6a2crSm1TQjRxa3I1TWxnNTcreHhGb2dOQW1DQ0puRnovdmJ4UkFxT25P?=
 =?utf-8?B?SG8wTzFpRWVkYzNyM2loeFBqS2dERkFUQUgwTm43TklOTjhVbjRNSmFLYlJa?=
 =?utf-8?B?V0d0eWJnNWFwK3VaTDhtVkxyS2wwQk9HSHl6TXlSVDYzNkRwejgxZ3BsWExl?=
 =?utf-8?B?b1VNL01TZmJTRUJKZUpPQ3hrMkpFbG1ZdHR5eFZGV3J5aHBOVy9qUzE2S3VN?=
 =?utf-8?B?UVN5OCs4Y015OTY2RUR5Vis0ejAxMUd1RGNOTkZnTllwYTNBRzJUdXlqN2Q0?=
 =?utf-8?B?TUZlc1VsNkt0Q0ZXTnBHSGd4bGZoY25wRm51SHhGV3N2eFluRms1dE1EdWZ3?=
 =?utf-8?B?dlZCOWI5UHBaSHdzREJlbk9pSmF1MnVxd29jWERtZ2hiRnN4M0Nud05LaDlz?=
 =?utf-8?B?eUp1WnZwQllQMFFrMkVDMTJyb1lkOE5VdHJPM2F2WldWQUwxM1JrNnErVStj?=
 =?utf-8?B?N0s0T3dva3dqaVduMWtST2xFM3Vja01BdVJHMGFMUGhubHF4TTQ5bU4wN3pI?=
 =?utf-8?B?SHQxNzVDbzB4c1o0VHV2RFN6QVhNajdWU051MTdRVkltODRiN093YytuUzJS?=
 =?utf-8?B?U3c4ZHIwbXE5YmJNS3UyRnBkZ3hVWmFIVm1IUXJOQ3FaMERndW9FWVNDOUwx?=
 =?utf-8?B?b0JwREg0RjFqMVNYWTg0K0hPZDF0cys4NlBuZnRPVG93T0JOeGFGd3JmdnBh?=
 =?utf-8?B?bXB5VVB5M09IWDhYVm5zWmJITzhIM1lLcmtVaVFnYVlLTzNkUHVJdDE2eWhB?=
 =?utf-8?B?dDNLREZxTFo5b3RYMndhekkrUXYvL3ZnK2JsVUhFVzVsa1FTVElYWkRDUUcw?=
 =?utf-8?B?Q096ZUNYRGR0QXBQUHlpam1xSTR2dEhmOG5jRHI3TkJjYlVTOGYzQi9qOWZ1?=
 =?utf-8?B?UzhhZ1o4aTJDZEU3Q09mTSs1NDlEK1NhaWtFL3JlMTFtb2tkWWNCMFBaTkFD?=
 =?utf-8?B?WXRSQlp1YWRVMVl6WnlBcUJaTjJWNndYbHZuTkl4dVpHL3F2aDFQcFNVVzRT?=
 =?utf-8?B?cXAyZFU3dytZRG42QmhrcEZtRUZZMXhwajZLRm9LeEthR1FZU0VaLzAyTlFt?=
 =?utf-8?B?dExTRnZLVm5nSUQ3dk00RnJ0NVBzRzdpUURoT05lVVhIa3VOaUpOallLM3pV?=
 =?utf-8?B?ZXhrdGlKMnFTSCtyWXJCcHpzSWpJcHBxbllGQndydHBHM1hoeS8yQzY5YjVF?=
 =?utf-8?B?R1VJbWFGZ0doZUxxYlgyc21HUUlydWVER1pmZUd5RVd0amJEYlI1UVFWSVpN?=
 =?utf-8?B?dmxTV3VPMWRrTW9vQTUxOXNJMXhwS0tyK3RWWG13WGFlclBrb3JDbFN5dEdC?=
 =?utf-8?B?RGdqbThYTjJPYWZxaGVGRnNORDdvUmZhdjcvSzBoRTcyTjNsWFY4M3dLZjc4?=
 =?utf-8?B?M0lUa2dLbVVMWGpSTC9FajhVZG9ZTDEwTGhhTWVMNGgzTExnOWpROWNQUkJk?=
 =?utf-8?B?RzFWWStjaGZoYUJjZ3VWZTJvMnNYbmt1N0hXMlhoVkJwV0JIdXoxbVByem1U?=
 =?utf-8?B?ZVROOXgrTUlzMUNjTnBFZnBhRXEwcktDdkIxL29sNUY3NEF2ZG93aENTcTc0?=
 =?utf-8?B?a2h1M1NRVnkzQXNXeUl4cXFHV0R5dFlkdThkSlFieDBwdFdMOE8zZXhSTm1h?=
 =?utf-8?B?M1dWcUc0ZkJRMHpyTWlPVVRFOXJnOVFQR3hzN0FRMU84SmwvV2R4QUlRWkJi?=
 =?utf-8?B?akgyUllmZnFiaDRGWlNhS0xZQlRNZWdHMzhsQ2t3aHhRZ0tHY2txak5tSFE2?=
 =?utf-8?B?cW9BYWxBK3Z3MThEb0MxOG4yNTlIcElHSjI1NlpYcG1DckFkVS9wY3lLdFZo?=
 =?utf-8?B?UDE1U0hubEF4MTd2djR3V2xwUE9VQVdndUJtNDlDbEZGbUd6ZVpJMHVqZlpY?=
 =?utf-8?B?SUdXUXdaaUpPeTR4a1NXaE14YVZHQmJYZEFNYzJKSDFnOU5uUjhnUW1zWFIy?=
 =?utf-8?Q?h2Kr+RVr/gK1ECtg=3D?=
X-Exchange-RoutingPolicyChecked: HyGPa0KW7zFO4h5zRJKsKe1Uscyau/RGAuL/wUGrTR86EWL0adN4LaXqZL5RT9Kf2HRisp7gzZ9mcbSF7+SQAvl2N6pTnSZEBChUkIFgzI4Cv+/kU+nt4xDlagCIDEtkzKrUu2qeK0hAv/dSZjUCSbftgDT+WfQce8YpAQ/YTL4ul6dmbv1OjTeOU+4wAacXaGbFH2p2OYN4A1r0AYkbwmdOlvatEuwkJ9leWfUVRCzs4eRmuqrK4R4haZtMAFoFm9xFrgmbQ2sn2261p45WXlEQi1T5DKLfY2bRvsTcuamshVxRIses4F1mZBwOt+PupwBzD+C525Uu/IfpAQarow==
X-MS-Exchange-CrossTenant-Network-Message-Id: 66e37854-d0da-433d-1abb-08de89c20698
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2026 16:25:56.2338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hjb3pMUTzcH1VWdA2rJkK3v3SGUdd4NdMMkUwwg8L6Ax9FzjJqrS9mgi0MTgOP4pNSS19QTvIhlFR4vie9RIW+Ym4Ind9Oli63vByembQl8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8553
X-OriginatorOrg: intel.com

Koralahalli Channabasappa, Smita wrote:
[..]
> > As I learned from Keith's recent CXL_PMEM dependency fix for CXL_ACPI
> > [1], this wants to be:
> > 
> > depends on DEV_DAX_HMEM || !DEV_DAX_HMEM
> > depends on CXL_ACPI || !CXL_ACPI
> > depends on CXL_PCI || !CXL_PCI
> > 
> > ...to make sure that DEV_DAX_CXL can never be built-in unless all of its
> > dependencies are built-in.
> > 
> > [1]: http://lore.kernel.org/69aa341fcf526_6423c1002c@dwillia2-mobl4.notmuch
> > 
> > At this point I am wondering if all of the feedback I have for this
> > series should just be incremental fixes. I also want to have a canned
> > unit test that verifies the base expectations. That can also be
> > something I reply incrementally.
> 
> Two things on the Kconfig change:
> 
> When DEV_DAX_HMEM = y and CXL_ACPI = m and CXL_PCI = m

Right, this should not be possible. The patch I am testing moves the
optional CXL dependencies to DEV_DAX_HMEM where they belong. I
mistakenly showed them against DEV_DAX_CXL in my comment.

> 1. Regarding switching from >= to || ! pattern:
> 
> The >= pattern disabled DEV_DAX_CXL entirely when DEV_DAX_HMEM = y and 
> CXL_ACPI/CXL_PCI = m. So, HMEM unconditionally owned all ranges - the 
> CXL deferral path is never entered.

That is one of the broken configurations to fix. It should never be
possible to set DEV_DAX_HMEM=y unless CXL_ACPI and CXL_PCI are both
disabled or both built-in.

> When DEV_DAX_HMEM = y and CXL core is built as a module hmem.c calls 
> cxl_region_contains_resource() which lives in cxl_core.ko causing an 
> undefined reference at link time.

Yes, I hit this as well and requires another CXL_BUS dependency.
