Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C11B81F3D31
	for <nvdimm@lists.linux.dev>; Sun, 13 Apr 2025 22:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744584727; cv=fail; b=RiaFHLldZqkbSZX+LWWPOoqAgl3wEaEG/S4FS+UiTNfe+c28VVxI0zPT8MVVtMTqy516CCPuiwKOGpCdwtdhrXWYiICvbR2BG1IgIo/txSU8Z7V+wMgErd7g2Kkr4fsOuTVSI7z8MIgObOtjarITNlOVFtRua4rwYTK8+k7z970=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744584727; c=relaxed/simple;
	bh=I4hV71hOvjOspfYk0aPxzUTtPYw5QAMg7ynPu+boSlw=;
	h=From:Date:Subject:Content-Type:Message-ID:References:In-Reply-To:
	 To:CC:MIME-Version; b=X9FTxZzhBrpk6E2rNEsXBzbaNDE+398Qo74c4HE+AXVcvrDVtSgEsFpgL9pi/GwiKH17s5yMuCzcJqBaUyskMDJcmCaWHjYiMxwSwcy3U/K3jCtChX6wSERYC8QIyuxj1luwhadsijuS6CXRnAhjveOqmzTgtkIG6MyC1rcMCAE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nRCriQeS; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nRCriQeS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744584726; x=1776120726;
  h=from:date:subject:content-transfer-encoding:message-id:
   references:in-reply-to:to:cc:mime-version;
  bh=I4hV71hOvjOspfYk0aPxzUTtPYw5QAMg7ynPu+boSlw=;
  b=nRCriQeSJmcpv2I7wXiX98rQaDu/aAmzsRzkKCliTesTL1J5Qc9GZmnC
   fiOfYi6xU+k0QdfWXZwkC6bNC8CjXIuM/y8cNWaajki9RlaOODrrBRU9E
   b+Lsfr3XN3xdZanwmhJsA2lJ0KKSe1M3xcUialyZxZgB1EK13pVb3pkqs
   hMjeSiJe2CY2jkSmPm06ZAJNU11+uvvV5A9DjcgZULZoT36kJ99tH7swZ
   0V6RHcreO77tHitWIMCMr4yegYK5SertCzxrZob7eDouo4voc68Zyq7L1
   3ozPVOBneU8Hp3GnvTPWKUKgTU+NAJzBOhVj8MN+LbH+POPO84TGeTkRc
   Q==;
X-CSE-ConnectionGUID: mvaNDcF4RhWi3iAX66OXeQ==
X-CSE-MsgGUID: 93EU6PtbRWme9YCQJuOfXw==
X-IronPort-AV: E=McAfee;i="6700,10204,11402"; a="45280920"
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="45280920"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2025 15:52:04 -0700
X-CSE-ConnectionGUID: r3hxRt6/T2unMfPH1JfjjQ==
X-CSE-MsgGUID: LsSwU6+oRpSPyz9S6AFDMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="129657482"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2025 15:52:03 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Sun, 13 Apr 2025 15:52:02 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sun, 13 Apr 2025 15:52:02 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 13 Apr 2025 15:52:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pM/b3wRSEVPTKVKnkPc79uHWwAPyUQGsho0i0yVHBk/LmUFf1I6tv8NaD9nfGGPYroq2weck/V9pac95oEo2VPV1G57TuzAP7LjBYUkBgq1Dqau2+gzau0R8aIJAX3NrpEeL0Qp4DRa+niQJo6VbkpTS9zNdO60N1ItyKTPSwJ/a2jSNvT22wUQTNi+qgSUp5ggC4ozJJssbApKbLDhgH54FmnLW7BphirdaEgh+f4Hj1JP1gcXJ3fLGREL0oQZVwnGonO4NoAws+ornw0qajgi/ECZnm0xfeF5YdxnQ+hEMPdDr9YB0+wE7mH4YRdtrz1d1zMmvRsRCupelvcFxhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a/GNGXtpj/hr3QtK7ujbvV1FA1d76rRqvbSPhLn3p38=;
 b=WX9VI3Y8Y8v79eWLnsDSEH8DKgQuiuYbMiPYTQqQGtAJ/8l5uw+95G6NkiV/tYgYzBG10j8+729O4jDzx5hnh7doz62TArDT6uvHaF6ibnNYQe/jnadV9PijW2US3EWDu1ZWgE7Oc3WaZmvtGMgSMDWr38EAeHy4Mow5HjAQK2uoZVqHSGW8tQFP3mna3GSp22m8eJ9tmziG/cqpHE5vwLGLZTOxff3NxDHVjQmzyesJ4xRUI2CSXwyO2K61XuTvkX12DrHvDKGFU8gTUACjYTCNQAZqeHT/qRhR5OUbZjZoq8qYOfCme7woDBQHOSv9ubvjPLxOF6r/htfSuuHwjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW4PR11MB6739.namprd11.prod.outlook.com (2603:10b6:303:20b::19)
 by DM4PR11MB6042.namprd11.prod.outlook.com (2603:10b6:8:61::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.28; Sun, 13 Apr
 2025 22:51:57 +0000
Received: from MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24]) by MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24%4]) with mapi id 15.20.8606.033; Sun, 13 Apr 2025
 22:51:57 +0000
From: Ira Weiny <ira.weiny@intel.com>
Date: Sun, 13 Apr 2025 17:52:17 -0500
Subject: [PATCH v9 09/19] cxl/pci: Factor out interrupt policy check
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20250413-dcd-type2-upstream-v9-9-1d4911a0b365@intel.com>
References: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>
In-Reply-To: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, "Jonathan
 Cameron" <Jonathan.Cameron@huawei.com>
CC: Dan Williams <dan.j.williams@intel.com>, Davidlohr Bueso
	<dave@stgolabs.net>, Alison Schofield <alison.schofield@intel.com>, "Vishal
 Verma" <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	<linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Li Ming <ming.li@zohomail.com>
X-Mailer: b4 0.15-dev-c25d1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1744584735; l=2242;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=I4hV71hOvjOspfYk0aPxzUTtPYw5QAMg7ynPu+boSlw=;
 b=OSXoDp9OrvabwhRjCQQxUU7QdFJTUEigulwgAulz8q2Z4G3jHv58yquDPvV6PQ3Zc97iAdS7h
 SoBRvDF1Sq/CU1fNHJd+273EBhAsp+88JJtvwQauTdtOmKA1Jzo3vgN
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=
X-ClientProxiedBy: MW4PR03CA0227.namprd03.prod.outlook.com
 (2603:10b6:303:b9::22) To MW4PR11MB6739.namprd11.prod.outlook.com
 (2603:10b6:303:20b::19)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB6739:EE_|DM4PR11MB6042:EE_
X-MS-Office365-Filtering-Correlation-Id: d8b96218-9bd6-4755-3933-08dd7addcae4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MHBmSnEwaEtJbmlFc2NtZmVpcnZQOGkwSnpYdDVpL0ZmRnBTWWxUaHNJZjk5?=
 =?utf-8?B?Rm4xUUdIWDBXMlJHb0VwRHVnOXVTYVBzQktWU1Q2TDAzb2xQNE4zOUFIVmN2?=
 =?utf-8?B?VmNCRk02bzNQYU5acEZ6NkJxSDVRRVpJRTRRSkJLTURzVFV4bEtuZEFBWWJp?=
 =?utf-8?B?dlpVRFkyYkxEVi9oVDl5NDBPVUZmWWp2UVZPU3FtK2gxNURZVWRlRnE2a05R?=
 =?utf-8?B?eklON1ZCYVI3K0V6RlVPVGI2MS9jYU8xaHpUL01JbUsrQ00rTTN2dk82L1F2?=
 =?utf-8?B?Y294MnUwaTl4azIxdTZRMVVsQ1d0aFVRSHZNRTZMcExjL0dnT1Rzc1BBSno4?=
 =?utf-8?B?L0ZjOVVZa3BUYytwTDEwQi9WaUI2MkZwYVBic1BxV3NXT3NadVZBdlZhVEMy?=
 =?utf-8?B?akZnMmx0TXE5YWhwZTF3dk80QWN4NThYbStoZkdPMThGT0ZFbGtnNis1OXc5?=
 =?utf-8?B?V20rSWE5dVk0Q0VvajhKOFNCYmJnMzhjMm9DS0lHMTYrY2YvelI4eHpyNTJy?=
 =?utf-8?B?TUh4SDhWRHZsWk0zZWxadzRvUktRWWxDTnBSV0FQcUo0czY3R1JHNW9hdVpX?=
 =?utf-8?B?MEN3VnUrTVFLNTFudlhkMi9RbjFvUHBnUGdNTlF2TVhkbURYaHI4bjVvT1gv?=
 =?utf-8?B?Q05EQTNjZmRoZ0JDallKb3Npdzh4d2F2WmFtM3FqRW1vUmNBT1VWWWJjUGdj?=
 =?utf-8?B?WFNXM1hCTk9WaTh1ZlpWZVMvS0c4TERjNEdVejhRTURoOVdlV2E0Z3U1MXZV?=
 =?utf-8?B?VWw1dDZTK1RXYnk3Y1FuM2dJSTBES0Z6UElFdjA1UlpHRWpoMU1xdzdsSEFj?=
 =?utf-8?B?ZWlIeWpLVTg5MHVjUDZMK044dG5YNi9ydDArSzZ5TWVpWE1ybTF5NnUrUWZ4?=
 =?utf-8?B?bGMvdUxPZUV2SGtvYWpwcVpEcUJKaGNlejFpUzIzYjA2aG5DRS9NalpSVFJS?=
 =?utf-8?B?cWo0a0ZlWm9ObDJaOW9qUW5YdytqSDd5SHJjUHA1V1dXUlI3OGdwWnY3ajdQ?=
 =?utf-8?B?cVdTanZCVGdmTW92bkhEaEdrbkV2L1RQYXJ6SmFOdHlaSXA4M2phTzVDZjk2?=
 =?utf-8?B?L1pJYm0xYzdjSzdrRkE4U2dqa3AvL08yMzl1SUdvNnN0QnFtV3NOZ1dIeHZJ?=
 =?utf-8?B?TFovWklaK1ZIbzZQR0ZjRnQzK00rYmZ3cVh4azdQcWZpZmI2WFF3RzNQTVdY?=
 =?utf-8?B?K0pOSC82Y25WQTRMUVNDQVBvS1BXaVBOVDhPWmRtOW9ZcllnYnh6S2ZKTjg1?=
 =?utf-8?B?NUc5aTlTNWEvQ1NWL1daS0l3c0xseGlhdjR1VzViVnBCTklaWTdDNUtPenBw?=
 =?utf-8?B?bjh1NEZLTERPcVdobnFFZGNFK2lGT0tkQVA5L3hLTm0yWEQ5RVhqQ0ZGRVVw?=
 =?utf-8?B?ckZkZlo1SXdaQXdqUUJOZUxtYURkejBWUUpySGtpOGo4WmhuVEpTaEx5ODg3?=
 =?utf-8?B?SEkrRWViVlpGN3JYSzNUMmRoNUNUNXFiZU1DRzlZN2ZNSVNTaDVZVXB2VXNP?=
 =?utf-8?B?YWhWNy9PaFRBVzFJUDZCZ05KcU01akk0TS96R0lKY0NRWGpsMUE2UHUweGNX?=
 =?utf-8?B?V2gva1h0ODB3THdVS1JrY2pMQktweGFIdVM4Zk5iRTZYUFhrekppQ0wvSmlF?=
 =?utf-8?B?eWJvYlRJZ0Y1WUZmb1pMb0d0alpzaFQ3Q2hmS1lrcmp2TVZvKzVWNmY2Qy9j?=
 =?utf-8?B?ZTYrYjZmZFRnaVNTYkVIL1lNRkNZd1lTbmRYd1BMekNwNlBMMmQzQUEwTWRX?=
 =?utf-8?B?QVlPRGV6QzZ4UTFiWmVYRWR2RERzd2gvVFhmSXV4Y0gwcFd5UDhUVEt6YjJM?=
 =?utf-8?B?M3g4YU80dXUvdU15ZDdWYVhGZlo5UThDcXNnUTFaeWpNcnM0SU5ONkprcTJp?=
 =?utf-8?B?SExGTDFwN3hTMU1ZUGRVTDhscFlGaUpZU3lMWnpjUnZQcFZyOFZQQSt4ZzNx?=
 =?utf-8?Q?5uHPMEUlK38=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6739.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Rk9JTkh1NTlIWlAzdWFnaTVsbnRqZWw1THlDR3ZGbThXVXF6NCtYZzNQNnQw?=
 =?utf-8?B?ODI3ZkhHWnNHSlV4YnJrcUNhMXdRWEVhejFla0F0V2ljdVYwbjFhTUhLQ3Rw?=
 =?utf-8?B?OTZQR01LNWFCL3o1cUZJSFBBZHo4YTh2bzJmMWZrKzdROVo2aDNUellpeUpj?=
 =?utf-8?B?ZXZ6ZVYvNjc5UU1vd2o1aXNqZW1OdGg5MGt5dGpiYk02Vy9VSEQzRXZ4eGpW?=
 =?utf-8?B?T3ViU2Uxcnl1bnRtMUVvaUlKV2JoRThrSE1jVGVkSkFtVFM4NnBnL1owSWxv?=
 =?utf-8?B?OWRKdmErMEdUV2VHODBtbk1KdTRwcGlFbnR3MlZLN1pGck1wUDkyU2JvVlN3?=
 =?utf-8?B?UW9PcEJhT3FvbjdHeit1Z1llcUlua2JEL2tiQUlWKzB0M3FJUmQ2RmMvUGFl?=
 =?utf-8?B?azY2M1lPSCtFQzNxSlp6VDE2SDNScGxpcmNVR3A5OEdMWE1ybEFFR05RMVBJ?=
 =?utf-8?B?RHJNN3ZIUzNvdkJiY1pvaXczcFd2U1p0bys0WVVvaEpLb0JMT21ndHdqZERZ?=
 =?utf-8?B?YlFuNEVtcjZFVmpvMXIveVhXWk8velljcDl4RHdka2hYUUlwd0c2MG1leFdF?=
 =?utf-8?B?VWxMNm1MV2NzSmtGbGFuVkltTnhnRjVoOU5GVnJiRlVjYlBUb2JzQ2pNeVYw?=
 =?utf-8?B?bmlyNzFXempsNVErUkN4bnpybHhyQU5obEc3YVhtSHJkYTBWcHR4aTNvRmwz?=
 =?utf-8?B?S1pWd0YwRkg3NktEU0NOUGQvZmhJd01ncFByeGZsZ3BZOTRZR3hZNXVBZVVt?=
 =?utf-8?B?dG1nN04vdzlxQi9heVBKZnlpSUl0R1U2alV2V0FOeEZpR0llTW5GNUtXSWVz?=
 =?utf-8?B?dmtqODBmbERHQ0pVV25Db1V4dlhYZVozS1JnNGkwRUNBZWpZRGtWZkNEWC9a?=
 =?utf-8?B?UFQ2ekFUWDk4SHNCOXN3M241bG14SkxvQ3lORnJsMFc1SFIxKzJNUTJ5VFV3?=
 =?utf-8?B?T3pBTzN6dUxJQ2VlWnlLM01Fbkt3WnJncTJOQk1aUnd4dnJKdEcreE1ORHBQ?=
 =?utf-8?B?UUZFN1QxcWJsYU5meXNvUHJ0L3BGeEdLYlV1eFA3M29RREFIMzFLSEg3M214?=
 =?utf-8?B?dGdpMURFaFc4dXVIYUtlTU1EU2I1RTJ1YTQyU1h6NXJBZ0tiWXlxbkUyalJt?=
 =?utf-8?B?TEJIRVNDWjg5eVZXUUo5SWViaHZGYlUvZjdWVHJma1Y1czdPWDdaTmFJSVpM?=
 =?utf-8?B?a3AraVhmRDB0SVFlQTE5MlZqanU2VDFmakdxUGkvY3FEa1RNSEk2Vml1NC96?=
 =?utf-8?B?NmlJMmhDYkVkeHE1MitUVml0TnhQbUxuWUdkbUJ2NVR2L2JlL2JEd2NvUyti?=
 =?utf-8?B?b1dwUjVpRG5yTFZxdW5ONExsQkpSTFl6bkozUUt1U2NJbmNUa0NiT1plOVlF?=
 =?utf-8?B?ZWtQNG5RSHFXMm16N1BTaFMrd1RhaUtUYnUvYXZaL0NUamNnQVVvNmNWdjRY?=
 =?utf-8?B?aU0xais2SnVmSklqQVR1c05xcmVPVWNib09rQUNhY3ZmTS82SE9lNUdVQjF0?=
 =?utf-8?B?R2R1STVEZ0xXYjc4OHlIUEZoOE5DMmJvNUJOUFExQzA1YVdMdTZsQUhCd1NK?=
 =?utf-8?B?RVZGejdVVUF6cWdlM2hrMFZqZGMwdFdMSTkvL0V6TUNFOW05YTdibkRQbjVI?=
 =?utf-8?B?UUhCeFpaT2h2UHhGN3E0VXRYSkNVTUlPU25QVXNBNVRtQUdEcTRJRWV3VUpM?=
 =?utf-8?B?UEphYlRJU3FwangvMks1b0pCdHkrYzFBSXlERTZnVkhhUzZHTkhEYk1ZM3Fy?=
 =?utf-8?B?cURpUC9McFVPSFEydkM5OHFheEs2R2svdUhLR3Y2bmV1VUlqdGNVaTc2aHBY?=
 =?utf-8?B?cGY2TFBkbURhMDZpUVZnY2pRaVBzQkx6V3Y3bnEzb1FLbWhQd2FzWXhMdnJZ?=
 =?utf-8?B?ZEJOSmhJWUIxZjREVjNyd05PS0tsVGhUQ3lTN2hMRHMxcEtyTEJabFU4SWh3?=
 =?utf-8?B?Q2xiZm9xVjVxeVdNVFA0ejZ2SjdUOTIvRUMweGVmY1N2YzdtNmRVUFU5VWYw?=
 =?utf-8?B?ZUZibVNZaHB5ZDcxVzRkUUpIcTJpQi9mQ2I1RTNxZUJPbkZSVXA4eUxoVFNG?=
 =?utf-8?B?eW9scCszWVZ6d0djWWIrNkdxUytlQ3d5bkJpVFRDcGRodHRHamRWM3h3Mmdt?=
 =?utf-8?Q?CZKmXwjg/iq48r4n6tyFhSXW5?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d8b96218-9bd6-4755-3933-08dd7addcae4
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6739.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2025 22:51:56.9538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TA69BM0KOA1HMaZ9Sn/WWD7aKXQ5F30ADnuICwpiAXgoqrU4tZSLAFRYCbQwNLULiYGeTcQ/eVEXzdDIi+7GfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6042
X-OriginatorOrg: intel.com

Dynamic Capacity Devices (DCD) require event interrupts to process
memory addition or removal.  BIOS may have control over non-DCD event
processing.  DCD interrupt configuration needs to be separate from
memory event interrupt configuration.

Factor out event interrupt setting validation.

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Fan Ni <fan.ni@samsung.com>
Reviewed-by: Li Ming <ming.li@zohomail.com>
Link: https://lore.kernel.org/all/663922b475e50_d54d72945b@dwillia2-xfh.jf.intel.com.notmuch/ [1]
Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/cxl/pci.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index 308b05bbb82d..36d031d66dec 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -755,6 +755,21 @@ static bool cxl_event_int_is_fw(u8 setting)
 	return mode == CXL_INT_FW;
 }
 
+static bool cxl_event_validate_mem_policy(struct cxl_memdev_state *mds,
+					  struct cxl_event_interrupt_policy *policy)
+{
+	if (cxl_event_int_is_fw(policy->info_settings) ||
+	    cxl_event_int_is_fw(policy->warn_settings) ||
+	    cxl_event_int_is_fw(policy->failure_settings) ||
+	    cxl_event_int_is_fw(policy->fatal_settings)) {
+		dev_err(mds->cxlds.dev,
+			"FW still in control of Event Logs despite _OSC settings\n");
+		return false;
+	}
+
+	return true;
+}
+
 static int cxl_event_config(struct pci_host_bridge *host_bridge,
 			    struct cxl_memdev_state *mds, bool irq_avail)
 {
@@ -777,14 +792,8 @@ static int cxl_event_config(struct pci_host_bridge *host_bridge,
 	if (rc)
 		return rc;
 
-	if (cxl_event_int_is_fw(policy.info_settings) ||
-	    cxl_event_int_is_fw(policy.warn_settings) ||
-	    cxl_event_int_is_fw(policy.failure_settings) ||
-	    cxl_event_int_is_fw(policy.fatal_settings)) {
-		dev_err(mds->cxlds.dev,
-			"FW still in control of Event Logs despite _OSC settings\n");
+	if (!cxl_event_validate_mem_policy(mds, &policy))
 		return -EBUSY;
-	}
 
 	rc = cxl_event_config_msgnums(mds, &policy);
 	if (rc)

-- 
2.49.0

