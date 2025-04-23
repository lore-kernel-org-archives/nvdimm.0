Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF1F289359
	for <nvdimm@lists.linux.dev>; Wed, 23 Apr 2025 18:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745432276; cv=fail; b=n2qd3ATU5fVDNbum+cWdnlKJlF5+iUcrM6B+/rUhLpBV9LW46MuVJ7ZjAnjP3QD7pw7ETFw4TsTyFUbPAGLZrVI+o/mgriWcbwLG8EibTXnyfqwzrzd5lwr38HB3nviSOpkRdnALaGfk5BQga10B9+WDeNrk8LdoryJFY5StaYw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745432276; c=relaxed/simple;
	bh=QSTz87egF5PsIUS6ZqyHUERVuWHJU1xmripoZ6UhAQw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GfYhJBrT8saUhN4cHHZ79xLHCEr4nLTFHNPHwfx6IPr/cLT0jE20YMbC01lXUAvRViWw5cwZLLI25/BQ38bs3G+8rStWOrnAt9XVaJVKK1HoiFjPgN/mybi01AiVMik6rlQN8Gkx0wqcmUtTEbF/5uKH6xTZ3TCkq1xTYj6ICLo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PG0BeD6t; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PG0BeD6t"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745432273; x=1776968273;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=QSTz87egF5PsIUS6ZqyHUERVuWHJU1xmripoZ6UhAQw=;
  b=PG0BeD6tBQavESFMiZ/nyu3205VwNtpY+vrcx6AGOhhxD3bVEYLNCZil
   rdDqBRD5aEKlAcC9qGcxKbaRc+O+kiirltMctapmrODJb1ya6591o9iL2
   QCx2aT+D93tj7+oMl0zK7CVRkktODDmKF+xQb4/UA6/6ZTh/YkDvTPos1
   SkFPj3gnJE76o8ywZGtJZneY7bjdlqeFXaFRAH57/ioHdmIMYhx/C/jnI
   ekekyCsGkfPi7u7l3dmlQc6YSWS3XNR92PhCyG8zQd8RYf9XCa3dZ7jSb
   nTBgI7y0+U5+UEhpTSaIeEVTmUI/uYN6VISRHDOLn5x5YPTxtUqc2isGV
   g==;
X-CSE-ConnectionGUID: 1MoKhiuIRcibxmZ7WJHeFw==
X-CSE-MsgGUID: PxY2aWkYSbCxD+GxUFVFXw==
X-IronPort-AV: E=McAfee;i="6700,10204,11412"; a="50706163"
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="50706163"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 11:17:52 -0700
X-CSE-ConnectionGUID: ZXePOZSaQaCtOvLvg0db3Q==
X-CSE-MsgGUID: uvwwllAFTO6hL9qfMu2QvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="132136986"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 11:17:53 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 23 Apr 2025 11:17:51 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 23 Apr 2025 11:17:51 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 23 Apr 2025 11:17:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jgql4IlnM8Q1C3WFLAEXEck6X/TcGY0NjLQpAMciJImw55mWc/PLbEd9VECFTtIXHI2rm6Z/6JHispzHG3IFh/mngSnOEwNPG3ITqYkTX9BJhYsf80sGIDd8WIn8CXV4E82eEZ9GqewUc3/qFKgU9RsKmFpwXB64xk4iZYJGeN9QV688TY7RL4+2fAt+VEyqyxU04Pbn51oBVYN25r4trsQr6JZCS6bYcajbTmkOwk1sIY9juBo2C902wWaf3PaOcntA060g86rnnDRDIjMtGxNtQkcFDOrlgIOM8fnGk23Bli5PcsDk/fh5qb997UZIubMFYD3AurpF+ya9ip09Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+v6B8g+7jN3k+GEmPxLH6fYNAWWu6ETuL8dXW7TQy28=;
 b=AJ3GCEr23shhQmZh8m0fNBQHwd5KNtj2siWfJLkhUE5YcWsZ4jaOWSa5eUzhI+WtkrjGzSQEf6fdytofOlMf5bq/US7ckNf9ZODtXkjpka9t0zFYlkiAXjXpB5zhAeQKJbu5HrwwL98m5GpcM6+b0w4eJ0TPpKJBWBIVxenn7x5hUbtqnHIxMPbSCX8t6fOcvs0A8U+zFZWvOhGA8BbsojBMu1CB33t450UdBzkxZ4FiYYdgg5uT5frnyAe/0IPEk/Ea9GBV5DuxhmbE5xfhRd69/DX558CyePTC0o0aJtNMnyDNRAuN9uYl3QGFuSQuq6T7shbO4oYt1heLHDDWxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB8794.namprd11.prod.outlook.com (2603:10b6:806:46a::5)
 by SA1PR11MB8857.namprd11.prod.outlook.com (2603:10b6:806:46b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.35; Wed, 23 Apr
 2025 18:17:44 +0000
Received: from SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720]) by SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720%5]) with mapi id 15.20.8678.021; Wed, 23 Apr 2025
 18:17:44 +0000
Date: Wed, 23 Apr 2025 11:17:40 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Davidlohr Bueso <dave@stgolabs.net>
CC: <y-goto@fujitsu.com>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>
Subject: Re: [PATCH v4 -ndctl] cxl/memdev: Introduce sanitize-memdev
 functionality
Message-ID: <aAkuxAG30M_WxT8d@aschofie-mobl2.lan>
References: <20250318234543.562359-1-dave@stgolabs.net>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250318234543.562359-1-dave@stgolabs.net>
X-ClientProxiedBy: MW4P222CA0014.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::19) To SA1PR11MB8794.namprd11.prod.outlook.com
 (2603:10b6:806:46a::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB8794:EE_|SA1PR11MB8857:EE_
X-MS-Office365-Filtering-Correlation-Id: 56453d16-4c02-4163-c9da-08dd82932484
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?YStMTldiUEpIUU9WUGE0MkxlVnpaS2dpMnpUMDJFaHRIbW5HamlVbnpaS25X?=
 =?utf-8?B?SHdTcTF2TWZrajgvOEMvQlppZ09ZVm5raTd3SnZ4bHVacDZ4TVpaZHg2ZndO?=
 =?utf-8?B?SkdCb2R6NmFCT080K1luQ0VqVXFvdGYwNHZ2L3dzZTBWN0RkeUs3WmxpWjlz?=
 =?utf-8?B?UGZrdk9FNXIrdDQwK1Rlc1hKb2htWjdYZkt3WGpRZmE0UXA4NVdwdmxxK0c2?=
 =?utf-8?B?UUx6cENKaFNKTU05Y2lXdGRtcjhVR0Z2eFhsaFlkZ28xMDFBQWFmYlBIdURG?=
 =?utf-8?B?NEZzc25vK0FyeHQyb3JObEptdTVRWHdLMGhlcFpTWnF4Q2hxcU9oSzZ5aVhX?=
 =?utf-8?B?MHA4V0UxcEFMdkFoSVlEZWp0SWVRVFVxeE9mV3REV3E2VG84eXMrUHlIUkJs?=
 =?utf-8?B?ZHBVaXZSaXNNOWFpVy9SeFU3SElkM09taHpZeGxHTXZNeE1BRjBzOW1wUmo2?=
 =?utf-8?B?OFQ0MnBDdG56MkE0aXR4d0E3aG5FaTZ4eHBCenF1WlRmZU45ZnBOQWE0VE12?=
 =?utf-8?B?NzBobzZSbXZSU0FKbjcyTlUzVERneSsxc1BwL04vZ0s4bmY4RG4vcWhRM2ly?=
 =?utf-8?B?d1pUMHhkS0VvY0NXYVN3OTFQbDVucTZLeW5GZFR4ODdGemhKdGZTSWhyekZw?=
 =?utf-8?B?eFJsZmFaam1YeWgwdUlXRGF0UVlOeGZaSXBvNktkcFZWZ3J4b1hYLzBjemcy?=
 =?utf-8?B?d0FUdDN4S1VOaE5MTFJYajZBLzNXcXhEczZBb3hmWnA2TFZReUNMUmt4WWl5?=
 =?utf-8?B?VzQyQU1VOVF3UXhRRXVaTDZjNjVvL3dUOWFlbWtvTmxkQytLQUpNbGVoYk9G?=
 =?utf-8?B?aGtvTkdieE1sODRWeEFHaFYxemIyb2t3NEloUjA1TkEzY3dDK3J3b01hUFR3?=
 =?utf-8?B?cjI2V29McFNiT3VKL3RIK0NHTTlxSkw0VkNEdEJqb1N3UldvdEdMREgrZXdo?=
 =?utf-8?B?d1dBVVdWdXhwbXVBc3FKNE9tZjBlKzk5bEZTVWR5VndhSkpsM3dhdmwwMzZx?=
 =?utf-8?B?TkFsTUZNWUhKb2pEMXZaeDdLWUZUbk1PUlAwOWFFKzF1cDNKWmUreml5bmsy?=
 =?utf-8?B?UXpUeTgxVTlCa0xSMzRVbTAzQldoWEhQSnVYdEo3K3NIbXdyS0NqQUVLdWk4?=
 =?utf-8?B?Um1RbjlLSFFqUWFDdElXUUJidEd3dlZmZVBuM2ROOE45ejJFN0hxeUowQ2lY?=
 =?utf-8?B?ZnZIbSs5eVg4enNXODEzY1lKK1BCc29LbFVSalY2OGlDRjQ3R2VoYVRJMXkr?=
 =?utf-8?B?UnRLa3YvWVFoMTBZWFFuSUZNVHNCNytDbDI4cjR4WmE4bFVtYU5zWG00YVBJ?=
 =?utf-8?B?OURLL2pTRmdlUGhlQmo0cXJRL2cyKzhUK0JqZlNpcGFRS3lGOFJ5Mlp5a29Q?=
 =?utf-8?B?UVM3TDIrcGJwTElIT0VnbGV2aWxldWNIRjhadk5IeVJITStyNGlmM3RVMCs5?=
 =?utf-8?B?RFlrY1N1YWpUMnZiNUg0V0pqRXVZSTA1bXcxN2RFZ0twc3VSaEw3OU5uQ2E3?=
 =?utf-8?B?eVZjQkljS1lJQ1Q4QnBqZzAzNWs5QXh1STFxRTN3M0xhZEZML2JPSWxHUjZm?=
 =?utf-8?B?R3Z5RENCMkt2aG1jcW5SNXJQWEh6TGpHTndCNFV5T3JRRjkxditHNzhyUGlV?=
 =?utf-8?B?ODlpR1cvVHBUUy9ISzFQdCs0WGNHR29Ca2pqdTgza3h2ejRFWFlUcnBNTEs4?=
 =?utf-8?B?ZWExclFqb0YxcFQrRU96Wlg1NWF3MkxsTlU1L05MMlpuSWVtWkczZWJvdStE?=
 =?utf-8?B?Ung3Qk5WTi82eUJJWWo0WVc1bVR0N05sZDlXTDNsejZOR2ZiT3I4RDh5RHlF?=
 =?utf-8?B?SzRiUFhwL0x6ZUNpbjhOTG1DSGM0aFNQd2xJeUxJWWNYeEY4dFRUTkJOU0dh?=
 =?utf-8?B?TU9uOHhLVTJyWEJaN2JzaW4rL05pcElId2JONHFmK0dxSm1kOW9vTVMvVU9R?=
 =?utf-8?Q?cJNUKaeG1K8=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB8794.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZU9NeGtkaXd4VmptRVpqZFRCS3pTWHRld2ZtZlNGaVZUQkNIMHFLTlgxUkNO?=
 =?utf-8?B?M2FqTFhQV1lscUhjTE9zczNKSjZJRW51STNOK3kvV0VXeFBZSkV2ZVZXcU5y?=
 =?utf-8?B?dHBFUGxUcjBUdHZFTlZyMGlvaWNqVmo0RHl5UWxCY3lpT2RDMEJPcDBRNDNC?=
 =?utf-8?B?R0VTVjh1QVE2RHNnVlhqYVEwSCtwNlQ5TWltY25kdjNSZWFteXd5czVwKzc1?=
 =?utf-8?B?b1lWOEhRSVpobFZVbVMxY1VwN293V1JYQTk3UTRBYXZBRmNsL1pvWFhqMmxk?=
 =?utf-8?B?UHQ3REJHZlVZNm9tY05yZUNCSGJkRjRBR3NEYTg2UzluRUVTU1pXNm5NZGVL?=
 =?utf-8?B?d29TM2VhVVJWRHBYb05aZkplQW56aU1LVmV2dE9RN2xSRzg5R0MrVFdIWktr?=
 =?utf-8?B?UU5xcXhUWHp1Yjg1aUtsYnp0bllEbGNNeVYwTGdIS0F6bXRidzFORDVsNVcx?=
 =?utf-8?B?bjV5R29tMDVlQTUrbEMzNUxMeCtzK1ROS2JMSENMRXF5MDY5dWcydXgrNFB6?=
 =?utf-8?B?UGQzUHNoTnZzRktzcGNkdW16WkpuakpvUUdWYWgyQVlTbkdYUENWWkJMSWlL?=
 =?utf-8?B?WVBoZEF0dGdVMUhCdGJPQ2hZWWtJSmQ5R3hEMFYvR3kvN2gvS1ZKdGx0Zzl4?=
 =?utf-8?B?WXRTV3NrcTRGYkFnS05rbmVTRGhNUDZmMWtpSjFUOTdROGUvVk45RGVFcjhK?=
 =?utf-8?B?RU1HdGZmUEk4ZmgrWXJDT2VBOXJOK3lFcW0zdmNoU0ZjUGRaRkZDMmVTSlQ3?=
 =?utf-8?B?NU9MejEralRzdGQ2b3crMnZnZkVaVkIrU2lvZFRFNlp1aVg5amY3YXVwWkpn?=
 =?utf-8?B?eUh4WXM3NGNTN1laTjFyQmczNFV3Y3pPL1BxOE00bCsxUXNpSEVtTFhHL1Zy?=
 =?utf-8?B?QVJPSUQwbXBwTHJuR2RLaG93K0Z4LzFiZm5XYUl6K3A1V3dHRGN4TzFuOVFa?=
 =?utf-8?B?SFFUSGFOTXFtbVN1SklJK0tXSTVINUdrWmIxQW81WU9zNUZhTThwUGtRajBC?=
 =?utf-8?B?cTVoRzVObXQyalptWEhod3hUcGxxTEpscGZRZ003dllzWHBXUDBVMnhzeHFm?=
 =?utf-8?B?b3JhVlpaWTE2Mm1TazJGUDZlaG9VLzRRMVFHbUthUXRJcUF3UnNWZEM0aXl4?=
 =?utf-8?B?UVJJb011RUlvQytvcEJDdlBIbFJhWUlpQzYvTEhoLzdnOVBPdmxXNDlxd2Uw?=
 =?utf-8?B?d0c3eFc0VXArbzRDMWtpalJLdnBNdWFwRXhpWUxDODJ4ekNJWW1sUzM0M1dW?=
 =?utf-8?B?ZFVIbm1XZlN1VzhNSHNCVVkzVy9VazVFVWdMaEJIZFpOMnhReTlRRG56YTZo?=
 =?utf-8?B?L1pXa01rRWpwc0RHRmlaLzJvTmZ4TVdGeWU2N2t5alNkdXVFMUNPN3I0ZlR2?=
 =?utf-8?B?NllZWHUvazc5a3BVV0o5akZpWklleXRXVXJkTVo0dEI4cFcyVldPTnlLNzBJ?=
 =?utf-8?B?T3UwYzZudi8wTzJBRW02aEtTaVMrWFZpbE1IT3lSVkdDSGlVNjBiYVI4MURC?=
 =?utf-8?B?NC85anVmRy9qendyNkhZbGxSS2tBVFE4VUcrcS9iMExScjV6SllOdVM3SjhL?=
 =?utf-8?B?VGgyME02ZEd3ZG1LeE4rZFdiNFZ2Y2w2SjVZUXVCTXl6L2ZoWStFZlVvQ1Qv?=
 =?utf-8?B?SDZEQW5DRElsRU05cGU1a3RCMjh5MFFESFBhQk14Yzk2bjBUcW1adFI1Zkpy?=
 =?utf-8?B?WW15SFZMV2Joc2JOK3NWU25iSDBtTXpWUE5XbFNCTUxSNU84Z3AyVFNTS21C?=
 =?utf-8?B?OU1nNHFuaFZYZ0UzTFhVWUhhQjIwWXFkRHRwZGI4b0NHbnp0YWR3UmpTWEk2?=
 =?utf-8?B?amVSMlhSVFNUck5NamxMUm1TUW5qc0ozUUJTZnVTQWQ5anRZaUk3K1VtNEhj?=
 =?utf-8?B?NkJEd0syRTdzNFpSOE9Ed20yWmxmUlRNb0pMcHM2UGxla2Z5NUJrRHVrV2xJ?=
 =?utf-8?B?U2FTU2RzMkYwdk1tRzNKaVcrZTMwSTkyNTNQdFZTdUJPVmpIRDFQcU5zdllt?=
 =?utf-8?B?ZHlmc3YrS2hOSUthSmZPR3JHanViRTZNTGZpTk5ZZHNHRFNDb0luc2FRUHcx?=
 =?utf-8?B?a2dITEhIdXJVTFhmbTJKR2haUTZYZzdPM2VnVkJMR2tXWW1hNG1xT3VBWnZF?=
 =?utf-8?B?T0Q4UFltb2ZJdHlJWVJLUEVzL3U5OE8rY3UwVXkrcGxOdTY1SmFpS2w1U1Z0?=
 =?utf-8?B?cFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 56453d16-4c02-4163-c9da-08dd82932484
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB8794.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2025 18:17:44.4907
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qdEozGuhDpKnxb6913yxDlTGf/EE8MBPjZQ5s/p+RehBHEqC6MgTqbirrfV96FLJI1Zo8ypS2u6vGdYeyI/VT+ywQsIfhixXzMIL5uOn1H8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8857
X-OriginatorOrg: intel.com

On Tue, Mar 18, 2025 at 04:45:43PM -0700, Davidlohr Bueso wrote:
> Add a new cxl_memdev_sanitize() to libcxl to support triggering memory
> device sanitation, in either Sanitize and/or Secure Erase, per the
> CXL 3.0 spec.
> 
> This is analogous to 'ndctl sanitize-dimm'.
> 
> Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>

Hi David,

Is there anyone you can ping directly to review this one?

It's been lingering a bit and I'd want to see a review by someone other
than me before merging.

--Alison



> ---
> changes from v3: added missing cxl-sanitize-memdev.txt to the patch
> 
>  Documentation/cxl/cxl-sanitize-memdev.txt | 52 +++++++++++++++++++++++
>  Documentation/cxl/cxl-wait-sanitize.txt   |  1 +
>  Documentation/cxl/meson.build             |  1 +
>  cxl/builtin.h                             |  1 +
>  cxl/cxl.c                                 |  1 +
>  cxl/lib/libcxl.c                          | 15 +++++++
>  cxl/lib/libcxl.sym                        |  1 +
>  cxl/libcxl.h                              |  1 +
>  cxl/memdev.c                              | 38 +++++++++++++++++
>  test/cxl-sanitize.sh                      |  4 +-
>  10 files changed, 113 insertions(+), 2 deletions(-)
>  create mode 100644 Documentation/cxl/cxl-sanitize-memdev.txt
> 
> diff --git a/Documentation/cxl/cxl-sanitize-memdev.txt b/Documentation/cxl/cxl-sanitize-memdev.txt
> new file mode 100644
> index 000000000000..7a7c9a79b19f
> --- /dev/null
> +++ b/Documentation/cxl/cxl-sanitize-memdev.txt
> @@ -0,0 +1,52 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +cxl-sanitize-memdev(1)
> +======================
> +
> +NAME
> +----
> +cxl-sanitize-memdev - Perform a cryptographic destruction or sanitization
> +of the contents of the given memdev(s).
> +
> +SYNOPSIS
> +--------
> +[verse]
> +'cxl sanitize-memdev <mem0> [<mem1>..<memN>] [<options>]'
> +
> +DESCRIPTION
> +-----------
> +The 'sanitize-memdev' command performs two different methods of sanitization,
> +per the CXL 3.0+ specification. The default is 'sanitize', but additionally,
> +a 'secure-erase' option is available. It is required that the memdev be
> +disabled before sanitizing, such that the device cannot be actively decoding
> +any HPA ranges at the time.
> +
> +A device Sanitize is meant to securely re-purpose or decommission it. This
> +is done by ensuring that all user data and meta data, whether it resides
> +in persistent capacity, volatile capacity, or the label storage area,
> +is made permanently unavailable by whatever means is appropriate for
> +the media type. This sanitization request is merely submitted to the
> +kernel, and the completion is asynchronous. Depending on the medium and
> +capacity, sanitize may take tens of minutes to many hours. Subsequently,
> +'cxl wait-sanitize’ can be used to wait for the memdevs that are under
> +the sanitization.
> +
> +OPTIONS
> +-------
> +
> +include::bus-option.txt[]
> +
> +-e::
> +--secure-erase::
> +	Erase user data by changing the media encryption keys for all user
> +	data areas of the device.
> +
> +include::verbose-option.txt[]
> +
> +include::../copyright.txt[]
> +
> +SEE ALSO
> +--------
> +linkcxl:cxl-wait-sanitize[1],
> +linkcxl:cxl-disable-memdev[1],
> +linkcxl:cxl-list[1],
> diff --git a/Documentation/cxl/cxl-wait-sanitize.txt b/Documentation/cxl/cxl-wait-sanitize.txt
> index e8f2044e4882..9391c66eec52 100644
> --- a/Documentation/cxl/cxl-wait-sanitize.txt
> +++ b/Documentation/cxl/cxl-wait-sanitize.txt
> @@ -42,3 +42,4 @@ include::../copyright.txt[]
>  SEE ALSO
>  --------
>  linkcxl:cxl-list[1],
> +linkcxl:cxl-sanitize-memdev[1],
> diff --git a/Documentation/cxl/meson.build b/Documentation/cxl/meson.build
> index 8085c1c2c87e..99e6ee782a1c 100644
> --- a/Documentation/cxl/meson.build
> +++ b/Documentation/cxl/meson.build
> @@ -49,6 +49,7 @@ cxl_manpages = [
>    'cxl-monitor.txt',
>    'cxl-update-firmware.txt',
>    'cxl-set-alert-config.txt',
> +  'cxl-sanitize-memdev.txt',
>    'cxl-wait-sanitize.txt',
>  ]
>  
> diff --git a/cxl/builtin.h b/cxl/builtin.h
> index c483f301e5e0..29c8ad2a0ad9 100644
> --- a/cxl/builtin.h
> +++ b/cxl/builtin.h
> @@ -16,6 +16,7 @@ int cmd_reserve_dpa(int argc, const char **argv, struct cxl_ctx *ctx);
>  int cmd_free_dpa(int argc, const char **argv, struct cxl_ctx *ctx);
>  int cmd_update_fw(int argc, const char **argv, struct cxl_ctx *ctx);
>  int cmd_set_alert_config(int argc, const char **argv, struct cxl_ctx *ctx);
> +int cmd_sanitize_memdev(int argc, const char **argv, struct cxl_ctx *ctx);
>  int cmd_wait_sanitize(int argc, const char **argv, struct cxl_ctx *ctx);
>  int cmd_disable_port(int argc, const char **argv, struct cxl_ctx *ctx);
>  int cmd_enable_port(int argc, const char **argv, struct cxl_ctx *ctx);
> diff --git a/cxl/cxl.c b/cxl/cxl.c
> index 16436671dc53..9c9f217c5a93 100644
> --- a/cxl/cxl.c
> +++ b/cxl/cxl.c
> @@ -80,6 +80,7 @@ static struct cmd_struct commands[] = {
>  	{ "disable-region", .c_fn = cmd_disable_region },
>  	{ "destroy-region", .c_fn = cmd_destroy_region },
>  	{ "monitor", .c_fn = cmd_monitor },
> +	{ "sanitize-memdev", .c_fn = cmd_sanitize_memdev },
>  };
>  
>  int main(int argc, const char **argv)
> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> index 63aa4ef3acdc..d9dd37519aa4 100644
> --- a/cxl/lib/libcxl.c
> +++ b/cxl/lib/libcxl.c
> @@ -1414,6 +1414,21 @@ CXL_EXPORT int cxl_memdev_get_id(struct cxl_memdev *memdev)
>  	return memdev->id;
>  }
>  
> +CXL_EXPORT int cxl_memdev_sanitize(struct cxl_memdev *memdev, char *op)
> +{
> +	struct cxl_ctx *ctx = cxl_memdev_get_ctx(memdev);
> +	char *path = memdev->dev_buf;
> +	int len = memdev->buf_len;
> +
> +	if (snprintf(path, len,
> +		     "%s/security/%s", memdev->dev_path, op) >= len) {
> +		err(ctx, "%s: buffer too small!\n",
> +		    cxl_memdev_get_devname(memdev));
> +		return -ERANGE;
> +	}
> +	return sysfs_write_attr(ctx, path, "1\n");
> +}
> +
>  CXL_EXPORT int cxl_memdev_wait_sanitize(struct cxl_memdev *memdev,
>  					int timeout_ms)
>  {
> diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
> index 0c155a40ad47..bff45d47c29b 100644
> --- a/cxl/lib/libcxl.sym
> +++ b/cxl/lib/libcxl.sym
> @@ -287,4 +287,5 @@ LIBECXL_8 {
>  global:
>  	cxl_memdev_trigger_poison_list;
>  	cxl_region_trigger_poison_list;
> +	cxl_memdev_sanitize;
>  } LIBCXL_7;
> diff --git a/cxl/libcxl.h b/cxl/libcxl.h
> index 0a5fd0e13cc2..e10ea741bf6d 100644
> --- a/cxl/libcxl.h
> +++ b/cxl/libcxl.h
> @@ -79,6 +79,7 @@ bool cxl_memdev_fw_update_in_progress(struct cxl_memdev *memdev);
>  size_t cxl_memdev_fw_update_get_remaining(struct cxl_memdev *memdev);
>  int cxl_memdev_update_fw(struct cxl_memdev *memdev, const char *fw_path);
>  int cxl_memdev_cancel_fw_update(struct cxl_memdev *memdev);
> +int cxl_memdev_sanitize(struct cxl_memdev *memdev, char *op);
>  int cxl_memdev_wait_sanitize(struct cxl_memdev *memdev, int timeout_ms);
>  
>  /* ABI spelling mistakes are forever */
> diff --git a/cxl/memdev.c b/cxl/memdev.c
> index 6e44d1578d03..4a2daab2bbe5 100644
> --- a/cxl/memdev.c
> +++ b/cxl/memdev.c
> @@ -35,6 +35,8 @@ static struct parameters {
>  	bool align;
>  	bool cancel;
>  	bool wait;
> +	bool sanitize;
> +	bool secure_erase;
>  	const char *type;
>  	const char *size;
>  	const char *decoder_filter;
> @@ -160,6 +162,10 @@ OPT_STRING('\0', "pmem-err-alert",                                            \
>  	   &param.corrected_pmem_err_alert, "'on' or 'off'",                  \
>  	   "enable or disable corrected pmem error warning alert")
>  
> +#define SANITIZE_OPTIONS()			      \
> +OPT_BOOLEAN('e', "secure-erase", &param.secure_erase, \
> +	    "Secure Erase a memdev")
> +
>  #define WAIT_SANITIZE_OPTIONS()                \
>  OPT_INTEGER('t', "timeout", &param.timeout,    \
>  	    "time in milliseconds to wait for overwrite completion (default: infinite)")
> @@ -226,6 +232,12 @@ static const struct option set_alert_options[] = {
>  	OPT_END(),
>  };
>  
> +static const struct option sanitize_options[] = {
> +	BASE_OPTIONS(),
> +	SANITIZE_OPTIONS(),
> +	OPT_END(),
> +};
> +
>  static const struct option wait_sanitize_options[] = {
>  	BASE_OPTIONS(),
>  	WAIT_SANITIZE_OPTIONS(),
> @@ -772,6 +784,19 @@ out_err:
>  	return rc;
>  }
>  
> +static int action_sanitize_memdev(struct cxl_memdev *memdev,
> +				  struct action_context *actx)
> +{
> +	int rc;
> +
> +	if (param.secure_erase)
> +		rc = cxl_memdev_sanitize(memdev, "erase");
> +        else
> +		rc = cxl_memdev_sanitize(memdev, "sanitize");
> +
> +	return rc;
> +}
> +
>  static int action_wait_sanitize(struct cxl_memdev *memdev,
>  				struct action_context *actx)
>  {
> @@ -1228,6 +1253,19 @@ int cmd_set_alert_config(int argc, const char **argv, struct cxl_ctx *ctx)
>  	return count >= 0 ? 0 : EXIT_FAILURE;
>  }
>  
> +int cmd_sanitize_memdev(int argc, const char **argv, struct cxl_ctx *ctx)
> +{
> +	int count = memdev_action(
> +		argc, argv, ctx, action_sanitize_memdev, sanitize_options,
> +		"cxl sanitize-memdev <mem0> [<mem1>..<memn>] [<options>]");
> +
> +	log_info(&ml, "sanitize %s on %d mem device%s\n",
> +		 count >= 0 ? "completed/started" : "failed",
> +		 count >= 0 ? count : 0,  count > 1 ? "s" : "");
> +
> +	return count >= 0 ? 0 : EXIT_FAILURE;
> +}
> +
>  int cmd_wait_sanitize(int argc, const char **argv, struct cxl_ctx *ctx)
>  {
>  	int count = memdev_action(
> diff --git a/test/cxl-sanitize.sh b/test/cxl-sanitize.sh
> index 9c161014ccb7..8c5027ab9f48 100644
> --- a/test/cxl-sanitize.sh
> +++ b/test/cxl-sanitize.sh
> @@ -45,7 +45,7 @@ count=${#active_mem[@]}
>  set_timeout ${active_mem[0]} 2000
>  
>  # sanitize with an active memdev should fail
> -echo 1 > /sys/bus/cxl/devices/${active_mem[0]}/security/sanitize && err $LINENO
> +"$CXL" sanitize-memdev ${active_mem[0]} && err $LINENO
>  
>  # find an inactive mem
>  inactive=""
> @@ -67,7 +67,7 @@ done
>  # secounds
>  set_timeout $inactive 3000
>  start=$SECONDS
> -echo 1 > /sys/bus/cxl/devices/${inactive}/security/sanitize &
> +"$CXL" sanitize-memdev $inactive || err $LINENO
>  "$CXL" wait-sanitize $inactive || err $LINENO
>  ((SECONDS > start + 2)) || err $LINENO
>  
> -- 
> 2.39.5
> 
