Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0336633E7
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 20:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769201555; cv=fail; b=qT5gvwsQK/5G4W4LHFlwrrcaAsveAAyIMIrJSDsc25jNEa/Q0mdMW9pWPSau6Vyl/5ei5JbHqI6Z84VGkhCrl+zftCgQcCrrWgnlk7t5h2qV8NNymkd6xGOySgpwAjLOJVPa5gKgBkmDrpO8HqqmYu8v7cRS3lEpnKO5QXOZciI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769201555; c=relaxed/simple;
	bh=eaioJIyOtC6nWhpPsQY97EPX2igc+R4VgXddE++HqGk=;
	h=From:Date:To:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=T+W1e2+ZoVaQAOHQOoeaU5cJ+8VkcsCfGICrTJwaEsZD/EMQ4Msbl5/giDhx/JGnXpTEXo1FkozeI6TETXm1crfkGUucdVWhTRG/eK7pv2zXPa6r9xh65jODfb2z9+gdH+FyIwnBUS2sc+DaN0+Q97uD6XPXnooSyxhlKWnU93Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OLkFAqnu; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OLkFAqnu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769201554; x=1800737554;
  h=from:date:to:message-id:in-reply-to:references:subject:
   content-transfer-encoding:mime-version;
  bh=eaioJIyOtC6nWhpPsQY97EPX2igc+R4VgXddE++HqGk=;
  b=OLkFAqnuvd/Y4s4GBq7kYGTRT2cxMWUPcE4/0/JoV4PmJExTD3MysetI
   T8ZXcB2I+PjK4yGI+S5aJG/TPaKhfmSjQiaPKn4Qmq5O/E9zw1kwlLIm0
   FjqfnBOWXlArPGW9bmrY7Cb6ukp1UbdSI3yYRdXfiUmshJPn06YOtn3aM
   Es2DK0ZuP/YfkfeY14l9JV3htv0yCJJcAB3jKIPC0ZZFe36KB7nel2yUG
   l5uRg3H9yss1aAAYjS9OG7IKAhfIIeQIieM2D2vd7MiCq/LQ6xOrs4tyn
   /FmNBDLxI0jf0QMVGDzRG3CwJ5MY0qwWA7wY7ZoPWAOIFO+o9PrJFQnam
   w==;
X-CSE-ConnectionGUID: gS43dYcaSIGiPB+WRA/99Q==
X-CSE-MsgGUID: 8LvwylulQ3OvImo2F6rCMQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11680"; a="70358062"
X-IronPort-AV: E=Sophos;i="6.21,248,1763452800"; 
   d="scan'208";a="70358062"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2026 12:52:33 -0800
X-CSE-ConnectionGUID: FqPq7ANgSxOpLcLrq3atCQ==
X-CSE-MsgGUID: SMzrXiinRCaDkOKBI3OpUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,248,1763452800"; 
   d="scan'208";a="207464676"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2026 12:52:33 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 23 Jan 2026 12:52:32 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Fri, 23 Jan 2026 12:52:32 -0800
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.18) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 23 Jan 2026 12:52:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KqVY33G/w4HLfbd5UWEsX8SXOqX83aTRR1CZWCtIXSSPqmHQrj3tZ2zjAdwI0IP6vkDAqNBsSneTJb2qcnow4ya/d/XyapX8g1ffNwlNRawH0LY13GL2pt2PCjBeXQ4PBktwVxaQ1f5OGkFihx/54H5KlfaEjA78Vw36FZ8SoLpmaDMlnZoWiRE6T2uxJ5juXoSNLJ8a1oD7RtmtBMvMoelOK22rZ5IImWjuAKVCKITbCu0Q0rkn7j0yLrhPFYrukXtQYyPTxCfNSQa2zH7CoklmtdoVu/Wda6to+Bpyodfdi7t0vpNQsRquB4/O/hx/lOVnQUxo1GTgJkqHyQ8+nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eaioJIyOtC6nWhpPsQY97EPX2igc+R4VgXddE++HqGk=;
 b=D0ZZ1tFeVeje7jfpxd6RtSA++mZO+V4v5i6O5Sc3rfUreGq40s009+2zRVujuJmBRDlQsbHmr63DAPbGKZitgVhmlqo3abC52RJNy5b3zCpFW3/eGYhfwru2yCgqCmf/Xa7HLNuJs82J+v75ECxcGXZpfHq+sNMQVIl6h6MZiYQx4upZ3APP2cUPDAr8TMsY/q1wL4/1Iqrb+1rcUthQO7/G8ayAWaeW0hAUIPZt5ypO5faXuBrDiNFByl7sfyeJSOLVxcupoqRJzdkwxa4/rOPywCfoCRcNFzEEhS9MKqV/O8vgHurIgqwD9wu8aqH9vpg7u/KHGWt4b2vEc8lvLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DM3PPF1B59FAA3B.namprd11.prod.outlook.com (2603:10b6:f:fc00::f0f) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.12; Fri, 23 Jan
 2026 20:52:29 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%6]) with mapi id 15.20.9542.010; Fri, 23 Jan 2026
 20:52:28 +0000
From: <dan.j.williams@intel.com>
Date: Fri, 23 Jan 2026 12:52:26 -0800
To: Jane Chu <jchu314@gmail.com>, <nvdimm@lists.linux.dev>
Message-ID: <6973df8aeebc4_30951003@dwillia2-mobl4.notmuch>
In-Reply-To: <CAPH-rUX0mZRAVJFeKwTcNqB0qhiqmCkuPFQVO2r5Zzo_Joj2sg@mail.gmail.com>
References: <CAPH-rUX0mZRAVJFeKwTcNqB0qhiqmCkuPFQVO2r5Zzo_Joj2sg@mail.gmail.com>
Subject: Re: unsubscribe
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0005.namprd05.prod.outlook.com
 (2603:10b6:a03:254::10) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DM3PPF1B59FAA3B:EE_
X-MS-Office365-Filtering-Correlation-Id: f92904c0-531f-4d81-fdc2-08de5ac15236
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|4022899009;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dE0wRVZVc1o0Q3p5cjNXUWhIQmxRbFowU2QvNUpOV0h3Z3dlNjJaNGhTSmhl?=
 =?utf-8?B?MWN4V2JqRkw3UnZEWURkUWl3b2F2TTBzSDZVMFJyYWM0QW5vRW9BUFhjeHl3?=
 =?utf-8?B?S09QRGFJZ0NmV2MyZURFeStCb05DblNkcWczNE4xN2ZkWUdMMGFKZ2VHWUdR?=
 =?utf-8?B?NkNwVFc0cUxJeFlCaTFTQWFyZ0JoU3p6Z2EycFlUUFZOeDAxVmdkRTlyY3hR?=
 =?utf-8?B?Vmh1aXlLa1JsR2h6ZHlPM1hOOXIwQVRsaUNOMXZNeGc1blFqeVgwdXJWZzRh?=
 =?utf-8?B?OTVWMm5SM29NREtGWmxISTNNYjJXbjZ4dzVMa3l2QzA1T0lnamdoREcvTVcy?=
 =?utf-8?B?eVBKcUJGQlBORWFkVG1jVHFwYVZ2SWM4VklxbUNJMU9qT25PWUdYakQ5SFo0?=
 =?utf-8?B?ZytIUWpjM2pTblQ0WG5uZjBXeVFtU0c3RmhpV0w3R0lXSUJranhzc3JHNzNo?=
 =?utf-8?B?OHF5TjRlRUc4cEtoei9NOXdxajBIdlExQmczRjdnc1ZQNmFiMm42SGhJZzdM?=
 =?utf-8?B?c0Z0N2VUQnh0UGxKaWo1djVyOTdXNitnRFYwTDFHdHVxQ3Rzc2dTaXpCSFN0?=
 =?utf-8?B?WkJWRmJ5MkcvdE5tbDhWT2dXZGh1czRoR0tERjMwT2lJSDBjL1hSQkhqaS8z?=
 =?utf-8?B?cE1rb0lpd1NUN0F6K2l2eDJXWkY3UkFqTEtFT2J4R0VXYllFMFU4ME9qZ2Zm?=
 =?utf-8?B?S2lkaVFlZzVJaVA4K0p4aDRuOWpBQTJscG4zYWhtdkl1My9jVlpNeHlhOEM3?=
 =?utf-8?B?MStQZmIxaU5uRjlON1FlVE1uL3ltMTdvYjE4UGVZMUI5bHE0Z0JOaisyOHJw?=
 =?utf-8?B?akFGemN5ZlZLUjAwS0E0SHptSzU4S2ZHL0F1aWZXUk5jdGx2K3Mwa2YreU15?=
 =?utf-8?B?U1FJNjIxVTJMRDg2LzNibUd0NGE4dFdoWTZZT3VGR1dQRGJSS2FzTTU0SmhG?=
 =?utf-8?B?cnhZSmxIWTE5bXpId2tuVVZSeHJYbklNc3pqSThqRjVDRHg2Y3d1NGovdUQv?=
 =?utf-8?B?cjlHN25HbkZxOXBPUWs3NTBTMXAwUVN5emJ4SFdKVmE3bnhDOGk1bzIyeEN5?=
 =?utf-8?B?ZC92bjlIS0wrZ1IzMGpPYllsNktKVXg5NUFBb2VQelQyMldGTUdLQ3NWM0Zn?=
 =?utf-8?B?ZE9kNERMRmFsaElsR04wWXduRHpsdFNPRklzcUl0bU1SaWw2S1I4SVVEVDRL?=
 =?utf-8?B?WS92OW5FU01CSEhHWWw4aG4yN1RaVG9Ra1FjbmxTc3lXcGRYYUtXN29JVjhx?=
 =?utf-8?B?SjMrOHJCVllKZEh6WkRKYkZ4a1RVMjNFY0xPbGtoZE40blVJaDZjbGZUVlVT?=
 =?utf-8?B?Y042SUJrenhYNFplUGNneEtUUWx5Ymc5dTYwb3Q5SGY0VGpOb2ZHaE5jMDFU?=
 =?utf-8?B?WXNwK2VwS0xabm1BL2RYVllOeDd1T0ZpUVY5dmk1N1FqRXd5d2ZRSjhnNVNY?=
 =?utf-8?B?bHFrN1ZIVUdFc0Nob3ROS1ZvUkR5ZEVCL05tZlNMYUtyeUtJTjBxRU9Lc3po?=
 =?utf-8?B?eFZONkxxK3dsSWUvYnl2aGtzRk8yWjkvVTJpbnFnRitoclp0bzNhN25FaTdK?=
 =?utf-8?B?TFoyaG9VMzhlN3ZPclNSNEFTc2R2LzA3bTd6NDFRb083UklJYWJ2K3ZTQ084?=
 =?utf-8?B?bHdldnlCWEZBRHlCZjJTZDZ6ZGlySGk5cTVGZXc2bFE3Wkd0d09MTXR3R1dY?=
 =?utf-8?B?STBIMEZjcStoNm13U1hFQnliUnUzV0ZVL1lrUEJKWXo3WlRpMGhVS1F3WGhK?=
 =?utf-8?B?QW81QVByN29YcWxFR1g1RFJsSmkzMW4vMUlJdWUvbktHUG5vakhDeUxsczd1?=
 =?utf-8?B?S0h0a2Jkdys2QUh0RTdtUExNOUZFaDlkOWRBUEFsOUdYemZiL0FTM25LeVk3?=
 =?utf-8?B?dkZTbDluRisxenZiSisxbHFCSjhvdDBJa1ZkMjF3RHptYUx6QmtacWlCMW5z?=
 =?utf-8?B?YTk1T1lrNW9xbTZrU2t6OU5ITFBsY3J5NUdqVFNES2YxMjlGWTN0V3R5QTZv?=
 =?utf-8?B?SmowS05UZjl0L05MMzZFcW1Pa2s5cnN1VHpONmZQc01hL0ZvRnJSK0JnN3NP?=
 =?utf-8?B?VDNuS2NZWnhDd09BNHM5ZDFScUFKcVJRRGNKc1BKQnhxWS84M05KakdsaGhl?=
 =?utf-8?Q?WcQA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(4022899009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UXdnbTBPNzMybUVvS05GcHllQXYwMWFyTTBCVjZQQnZJNTA0eUF2bURMU01S?=
 =?utf-8?B?ZWpvaXlNZHZrRE5NZGZLVElzNStpTGRFZEJlbzhXNHUwVHA2WWVJL3JXSWtl?=
 =?utf-8?B?MHJGYnRwQmxNeWxZQi9VNmJkdlFwSUR5K1ZVcmNiWWtkYitodFY0MUNLbmtB?=
 =?utf-8?B?ZEFacnVMME96Y3RORXhOWTBQSFFhRUh1d0ZUcG1xMDdsY3hrM0o4b1JIUEJq?=
 =?utf-8?B?blh0aTQvbjRqM0tEVUlHUEZ4T2czT2ZKU1RjVjZnMXJNS2pTWHdkWVY5STBk?=
 =?utf-8?B?anl0NG5TdGJTWnMybStGRHI5RjVmbUF4WUxLSVkrUHhrYUo0TnFEbWxYR25W?=
 =?utf-8?B?aEtwSEdUM2ovR0dkNExKU2YweXBha3pjTlQyUjBpUHh3QjBGVkRzcjRONlk3?=
 =?utf-8?B?cnlhSzlQdVBPT1FlSFcvK09ZcEZ1UFNVcHA0MDYwamllNS9CS3FMeW5uM3Vq?=
 =?utf-8?B?U2VMdnZXNlc4Z25SMVlwMVhaaFVtT0l6dm10eWFJck9QbG1VYlRxTWFaQUlH?=
 =?utf-8?B?MjZ2MVd2bTY0M3NEYjlGUHFRU0tlTkVkdi9uWEo4Sy9EbVQxb2VtUjd0U0ZV?=
 =?utf-8?B?eGxRYmhKbFVjZXYrSUhHZmplWW5ReWQ3OEZ2cW5WVExBNWswd1RMZDhEQWRG?=
 =?utf-8?B?b3ZSMzJRbUs1T2gvdzJoYnJsN2ZSanIxM0d4S0JMTmRKVlUxMTFYZzRzc2Rs?=
 =?utf-8?B?U0VzVzhLYnN0c3JWTGlPeS9XZ253OE80UW9RRWJqN0JEZnRBUm0rZDVXdlFq?=
 =?utf-8?B?UXoreUVWc0VkR2Rxcy83Z2gxQ1ozTWNpTDEyTHkxdXVpVUFLM0VkbUhxaGM0?=
 =?utf-8?B?WWt0MGhISmNPWm9ZQXA4Y1pNYkFvdlQvRG1pamJNQTN3bjZJU0NLUjBQTlN2?=
 =?utf-8?B?ZXFNL1p5blFuVGJ2ZTBUT0gxQzNjVmRPSkpjMnVnclF1NmR4YW5FTHdJNW45?=
 =?utf-8?B?KytLVmV5VkpINDRPUjlOSTg4OEhmQjJRaHpHQWw2SHI3aTVCN2Q0bU5kNU1p?=
 =?utf-8?B?UjI1RGhrRS9lVDVpaEw4SEk2Njd5cXR1eDFhaCtjMXEzSzZvWnNmZjl4eXZw?=
 =?utf-8?B?M3JtRHY5WS9TT1MvemFjN3JHZnIrWDFaeWFITDNQSWlzVW1BMTBLNm1WY0VJ?=
 =?utf-8?B?eTFnbUFXVzRNZTU4UG1tb0poTC9DWTQyYXc5R05PNnU0RlVmM2lhaDE1cjdu?=
 =?utf-8?B?dyszZm5PaGR5bUFoR0N3YTUrL1ltVXUvVEJSMzJLaE9USzdGbEpmdFRvVXZT?=
 =?utf-8?B?YisyMVI4ZENURHI2OG05KzhOblZ2cGhwelZRSHZTb2gvb3ZtTjFjNGhEZE5q?=
 =?utf-8?B?SWlETGo2dHhnekljbjkyYUVzY2tiVkRzUWwzM2FTdkJvWE8rODBxRjVhTWtI?=
 =?utf-8?B?dmtBU0JIdHV3bFNhRlZ1dGwxNXgzdWo0aC9TcldNcVJTaXpva2s5U3JPUFRT?=
 =?utf-8?B?b2MvcS9RVmh6L012S09yQXdDb0JWa1Y3SGVJQllyTHowQjhhdTQrdEdWdXhR?=
 =?utf-8?B?R1dHZ2Z4QityTzdhNmt3YnVGRmJKZHlnb1gveEwvR21nN3RHbm52RGVySHh0?=
 =?utf-8?B?M25lcDdnTkpFM3BTVHh6aXJXbDEzMllFeGZGMlE4ekxFMVFZSENoU1FHOGJ2?=
 =?utf-8?B?dXNYczRiVDZwNXRJRTRLcHJPcGdPNTNweUl4VXRFSDUva2ZPNWJ2L3JhNXNt?=
 =?utf-8?B?R1NFNDlpMmhKU1ZPZngrY3QvVFJ0SXFKc3B0U2NYa2VHOVRmVTRvSEFjQUJL?=
 =?utf-8?B?RCs2Um5wcEhUY2tIVTZhVld4dzBydU5wMlJvNVk5T1RoeTF2V2VXZXBseW03?=
 =?utf-8?B?STZiRnowRCtLQ3VKQ2lPckorWTZFL0xBZ0ZzTGZ0M0Z6YU5xL0N0ay9PbjNk?=
 =?utf-8?B?SnhnaithVk9RS3VUNzUzdFdXT0Mzb3JleVhMaTM0cFIvMzRBR0ZzSFFwRzJC?=
 =?utf-8?B?QUVEYStlc210UmxlV0c3a0JZcGhrVDh1amZMbVJJM21VTE5JUkFPMEMvd2JD?=
 =?utf-8?B?ZDR2M2NCYUdxZHpkYkJjWGVScHdsSEVpVkpndC9IY3VZa2Q1c1h3V3dTaksr?=
 =?utf-8?B?cDVITE9DTDZZTURmcjhpWmRETm80aUx4QzN6Um5DWTFPNjFIVlhOeDVwZUc2?=
 =?utf-8?B?aHhvOC9UUzhLVTVpeTBLWEs3ZEQ5YU44eGx1Y1hsWlM0SDlWU0VpbWU0OWRl?=
 =?utf-8?B?bS9URVdjTDdjZUdjQUY0NmgzdnFYQnhpTlpybWNtVERyUHBXWEtoV0RER09l?=
 =?utf-8?B?M0VkNDNRNWZVb21CYVZGZ2UzU0V3KzE0VU9mMk8wUG93bGsyUU95MGcwaHJX?=
 =?utf-8?B?Q0JxMnZOU0J3N1dxcy9kNGFKL00yeFRJTnJ5eDJVK3RhQzdTMDZ4V0NWaytW?=
 =?utf-8?Q?nUnWFiCxz6Ze1tPg=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f92904c0-531f-4d81-fdc2-08de5ac15236
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 20:52:28.8772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pbzHikOHy/uan6y2emQ6eugUjIzojvJqk/eXll/ikc+BodiJtk/H9DqTT+KPdtcSslcNyCQid6x8MDwH8e4WQwTK++HvWvqknkOGJj52/j0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF1B59FAA3B
X-OriginatorOrg: intel.com

Jane Chu wrote:
> Please unsubscribe me.

Hey Jane, send a mail here:

nvdimm+unsubscribe@lists.linux.dev

...for that.
