Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D1F20F081
	for <nvdimm@lists.linux.dev>; Sun, 13 Apr 2025 22:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744584759; cv=fail; b=b7XZt5knskk3AY0z8xS5icob4ig39P4FHQURQ426WMjT6sJmlEam/t3OeZnm25s7egxIE+do4chE+AYS//AL17rGeCHhOsqDRQ0EaWURvCWGgo9Ebk3GCVEdyaxGCqdkYXUmFoEr6V09nPOThszsvi7GpinkEV4ab//CJtAjm3g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744584759; c=relaxed/simple;
	bh=hIzly7Huia2oFq0h25HsM1O8AIHB+uENrUA+sLPFMr8=;
	h=From:Date:Subject:Content-Type:Message-ID:References:In-Reply-To:
	 To:CC:MIME-Version; b=m9OVFa2F6gk5/vB68+5sY25C992Ojac18u9Fa2IMTjw+xed3+Xe6Ib+x3U+N7W/Dz7ysEhHDDs0yZC/+Md3HKENkNfRhl9oxL5JyR3AjK6ygSfxLdRPBCHJ6iL/guBl9B9SqoNZT6RNfNBTzRhtt32b7H3pUm/RNGi1ForLAIQ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZXPAOmXy; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZXPAOmXy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744584758; x=1776120758;
  h=from:date:subject:content-transfer-encoding:message-id:
   references:in-reply-to:to:cc:mime-version;
  bh=hIzly7Huia2oFq0h25HsM1O8AIHB+uENrUA+sLPFMr8=;
  b=ZXPAOmXyBkcz01K3A0ywjHp/w40fyERRFn0UaTUCu5sCnW8SYKEyFoWq
   yeyStHYSWYvPY1PexYWej5SRtemydUmlq8KAmjHY4A0azOIzMmQlcjO6a
   Zfmkvgv5YMmxqL0jXWR7SKiYGAdEYuWRUls+sc/Ns6b3akq8gNJTmZSxj
   I5yEiRiLwI1rlXCglBkoEU/d4gHGDYonKX1velyLXGzSh19Si4VP+YNS6
   Bm+rCXgN/LwB3goA5+1v3C1RC+b+A/bz4ggb+piCkCWX9ehci0tYp5gqR
   L+22CSOxpT4JH+nmQNpgqlAv26aRGH9wX4BRC0xShaucH7aRmHXZyTtcy
   Q==;
X-CSE-ConnectionGUID: mM3HhavFSjCqnBbcWIijrQ==
X-CSE-MsgGUID: 9HF1OwZ5RPa6tjipgfH2/A==
X-IronPort-AV: E=McAfee;i="6700,10204,11402"; a="45280971"
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="45280971"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2025 15:52:37 -0700
X-CSE-ConnectionGUID: 3NXhHjWVT9ykHcVjpKcyBw==
X-CSE-MsgGUID: OF3/jx1rT7+eL1hkcNEzkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="129657636"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2025 15:52:37 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Sun, 13 Apr 2025 15:52:36 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sun, 13 Apr 2025 15:52:36 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 13 Apr 2025 15:52:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MK+u93b3Rji4AgMikp6ENX6Au4cRzs3ZzoVuZbP8cdyMd5kPaw7ux27GmoTe/NdQABOBRUZlYMnIesaADb9RsKfPH8+d/LQd7qx74dfANbwdE3eKF9268z32cxdQ2Yxngi7oV6V7LCaAi6R5/NfuBHXqL52aLr8nY+ep7JpaxlhC4eY3IorUiTQMcsTg5nIfEF7cVBfNPCUO1gZS9ezkrTkrtIBgiH2SsqITY76p+Djmr/i3JjMImHFm2ufIN/ThTrL5/5ef67d22Y1MiTZTpXoYX4hYqKeDavA1VSWCPx/0NscOAKInO4cpHap3dGdBQeN9DDicNNsMLozSr2b2RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zNDIWhxO6Oq0+ekZCjsNilh5/+781UpnrG4oEYvajM4=;
 b=oVx0pn2Eh9pCCR4Ds47ykeCaWews/GHIgqlzXnE7CxFf/I8i0X1b3wI2uXSP9w/7p4QT3Gl16KyTA2DKyjTH9Z6aV2o3z3Dv8ILeNl8HLywlxpzUaMAvB3Hp+MhIIk9y2dmdtZQ3SHQgmpgnMdHca77bEsE4uj4QZQh+BNvOUZpNXTtM6GIKuGwtHRwsThVakpmNcDLJSh+p7InUVM7C8wljlqknCUThwigpdQKyONzxP9xX/ue17VxkIKr1kMnTuHmD1Q47qEvBez4y9eRRX54mQzKrPj3m8rRYyAWqwI4Eed7l2WtjYx7uhdXliqpTqc/e1IWOIwLUvxDY2vakig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW4PR11MB6739.namprd11.prod.outlook.com (2603:10b6:303:20b::19)
 by PH7PR11MB7003.namprd11.prod.outlook.com (2603:10b6:510:20a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.33; Sun, 13 Apr
 2025 22:52:12 +0000
Received: from MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24]) by MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24%4]) with mapi id 15.20.8606.033; Sun, 13 Apr 2025
 22:52:12 +0000
From: Ira Weiny <ira.weiny@intel.com>
Date: Sun, 13 Apr 2025 17:52:26 -0500
Subject: [PATCH v9 18/19] tools/testing/cxl: Make event logs dynamic
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20250413-dcd-type2-upstream-v9-18-1d4911a0b365@intel.com>
References: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>
In-Reply-To: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, "Jonathan
 Cameron" <Jonathan.Cameron@huawei.com>
CC: Dan Williams <dan.j.williams@intel.com>, Davidlohr Bueso
	<dave@stgolabs.net>, Alison Schofield <alison.schofield@intel.com>, "Vishal
 Verma" <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	<linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>
X-Mailer: b4 0.15-dev-c25d1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1744584735; l=15739;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=hIzly7Huia2oFq0h25HsM1O8AIHB+uENrUA+sLPFMr8=;
 b=qpQkHpLuBE/2dAlhrUlSTLqrdxOrBEnFofzVUxY1p4gvHMRQH8V5CQTE1T7WkoNyRwDkIGx5k
 8k2ldon1HX8B8v5vWbPzhgPiHnVFeWtN5qX1ArR8P9Xe++yTahE/EA1
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
X-MS-TrafficTypeDiagnostic: MW4PR11MB6739:EE_|PH7PR11MB7003:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a124e87-aaa0-43df-a72d-08dd7addd42b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dlBMbjloUGVPNCtZdXdIblE1STh2RG54RE4vNFNtZTlDNHQrRlZSbVFzeDJK?=
 =?utf-8?B?WjR0ekJBeDExYVNjTjE1aldONVN4cWZtVUV0dzh1amlqV1J2M0lnS3h6M0NT?=
 =?utf-8?B?dnM5akNtaXdyNmkvWmNPWVBtT2l4endTYTRNYWRUcEFUNHNLaHNSeXBPcUFa?=
 =?utf-8?B?Q0YyYllnMXI0TzBMdi8yZEhaa2V3Y3BoL1hJNVpjbWV2ckxoNThrZExzT2hU?=
 =?utf-8?B?cGZDVEF5UXpuYkFRTlk0MEVMMDB3dHFRd0l4ci9NcWt6dmFxUWNBUXBuR2dE?=
 =?utf-8?B?NStkTlpQTEJjbXMrTGN2MTM2SmxiMDBvSm5TMEptRDZodUVVbXV3QnNpVW5u?=
 =?utf-8?B?RFRRcmJjMm9ObFJDU1RGekJwc000SEFwaFlLZVJ6WnRNZGJqbmZOYVUreWdC?=
 =?utf-8?B?dWx3enNZbzlkR05xbHovanpja0luMjR3U0llWHRBcGxoYkg3WFFwVFdxL09P?=
 =?utf-8?B?YVFubmpaZ25QRTJWYjF2SUlvSENpeGtJaFVQUzVlZ3BQU3RwRmp6a04yUXEy?=
 =?utf-8?B?TlhTU25kV0JmSXVzMy9BUXlWQmYxTGZsem9jQitEMXVlMmFqVTg2dkxlMDg5?=
 =?utf-8?B?ZzlPUHFwN2VVajV3Q1hDWDQ1cUR0akdSb05vVEZVYi9FakxqTDdEc0dQcWlH?=
 =?utf-8?B?UWNSRk1zQllZK1FyTXZDKzhKbjVDNXpFR3RhQlYzeCtUdUhvdzJ1THhqczYv?=
 =?utf-8?B?TG5CNlRsV0RoYnlwN0xHMTFOeTd3SFRRbE56dVVCNFp5dVV2c3VObXpHN1h4?=
 =?utf-8?B?aXlsR2JJNTEwa1FxeDJ4Q2oxWE5kYWJjSnBjaWxPZ2NIeFdacVhpRU5kZEJ0?=
 =?utf-8?B?NG90L21MRnBkL0lKcEY2VzdOSTErbVg4UWVkMDJHbGZzUko1N0dTK2p2Vzlw?=
 =?utf-8?B?MmVWdXBBWmljSUlRS243cnRmZytwZG5CQjZvb1N2QjYya3RnU0U5ekVsRWxa?=
 =?utf-8?B?UGZMcXpaaFFrSE9XSDZWOEdHSEN1cDNUekVZMWlzQWg5ak1QV0YzUFh1QSs0?=
 =?utf-8?B?KzRzdWdXekVNaXErTEJqNHJjWnhaNTBBTmpUY0NlVi9IazhYQnNTM1FLM2dl?=
 =?utf-8?B?L1FBMGlJUHp1dEpaMDRUNUdWTU1hMmpWU3BVNkc3ZlVuZlorVTY1ZVdGYWVq?=
 =?utf-8?B?ZWcxRFZCaU85TjJxZ3BuanJYNmJCTjhPOHpYZzMzT3JEVGNISkREMEhWNHlM?=
 =?utf-8?B?SW5ONGhkcmUxanVHeVRzc0hwTmpTVDd6dlRkK25vYmNVMlYxV0VZWHVOUTRu?=
 =?utf-8?B?M3MwZ3lpYWtMYVBnTWlTUUJ3cmJJUVhlR3QvV3B3ZmZZVlpKWWt1V0NkZjZP?=
 =?utf-8?B?UUVFYU4wQ0tYZEMyQ2VGTVA3eDR2VjBIUG0yZzY5NUY3R3gydFNBYmQvdWZi?=
 =?utf-8?B?Z0lwaXB2RitnU1IyZjZpa1ZzR21qSlg3VkpsRk1Na2FBZVN3a0hyaVJBMnJn?=
 =?utf-8?B?MG81Y0h1VEh4azBSWkhPakFWMG92THhGaVdnUXFNek1HSTFRa1V3UTR0Z25D?=
 =?utf-8?B?cERzVDIxbUR5NU1sMWJlY1VoOFNXaGg2ZDZHMmJUUWF3dkY0dFRIdVBJRk40?=
 =?utf-8?B?dkg1RERpckFCWTQwQmtzdDJyMTZZa0ZFajljS1dYWTlsbGoyWm9yMUNLeXFO?=
 =?utf-8?B?dERXeFU2R1pHMzR2VkJnbC9ITEFGb0FxVEQ5aGhGVnk2Q3JoQzRJSUxlNGRs?=
 =?utf-8?B?OFVuSG5qYjAxUUNwR0FUN0w5dldhUkU1STVLcFZVa1drd0R4Y3NPRGZXc3dk?=
 =?utf-8?B?K0p2cFAzSTZKa3dUa2hybC9venNvbExiZW43a2NFVTc1K0YzZlIvcXJqQTFJ?=
 =?utf-8?B?eSthQzV0S04wN0tMOE5HQWhRSnZSZWwvdGNqQll0ZW1vRzRSVGhSMWxqdmlo?=
 =?utf-8?B?Nk1Bb3hGSWppY1BWck9jSk1Nb0lMRE00TnZ4MExwYU9ING1sWFB3VHNkUnBI?=
 =?utf-8?Q?LwF76e4GgaU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6739.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aDdUS2hPU3VTUWJ2c3Z3VlMxMTB2QllPZmVXczJqUXFjNkVhazZsYUhvNFJY?=
 =?utf-8?B?dXN1THMvakZ0TzhrbHIwTW5EeCtQejdLQVdLWU5aMWJtcmx0TEppUlVsTUl6?=
 =?utf-8?B?ZzV6UWI1dDFoeWRyOURCb0NNd3IvVEhZQStuYjlJODBLN0dyT2MxZlRlVlhJ?=
 =?utf-8?B?UHRHYVVCMXhZSXY4d1Ewc0pKMjNwSDlwdXNqNE5DWU10T1Vlcm1NNDA2R0Rk?=
 =?utf-8?B?NkY3QXJNMTJiK0NQZk95SjZvdWxHQjI4TnNYNFBjM05YQjRDVkVldklPWEFU?=
 =?utf-8?B?L2d6ekQrdExySzNrejMxTDNTbFNuRG8ycFByTDBibnNCZGZkT3MrdTE5RFND?=
 =?utf-8?B?QzR1bmExazd5Z3BINTdxdWxHRnJrM0dDZFRoOGNNZ1ViQi9vd0JnMXp3cHJw?=
 =?utf-8?B?U3JsR2t5SXZmTkFEcEMvR0JHT0lwS2lxKzRMNFNvRGIwQ0Vib1JIYXlaQklE?=
 =?utf-8?B?V3JXREEwNTFBU3BlQXgxdzBQWnJxRkVVbngvdTdQWm9jM3Q4dlRaNHBOeExS?=
 =?utf-8?B?eVZKSWdGcEt1QnhCSDBzODAzY081UTV1YnFack9mRU1lLzdEZTN1cWtsRDh3?=
 =?utf-8?B?dHFJbjBvbzhzM0k1N2g3bGF6RTZUUkppL3NQUlFrQ1E2eWNQUGZVdzUxeUlk?=
 =?utf-8?B?VVY3dnZrUXg3cWhnZjIzUWQyM2R1Z202S1hoZ2pweEZrd2hscHMxQlRkayt4?=
 =?utf-8?B?TnpBakgxTlVoMnpPZnFKN2JNaGJQdTZ5SHd3TzlIbi83VDNkK2syQm5wV0tD?=
 =?utf-8?B?Q0lyTUMwemZSMWhDTE5Fakx1alRad1ZTeXU5SDBidVc4TUN3M1NFVEhNVHFO?=
 =?utf-8?B?ZkVzNWFBcjBpRVF0Sy9kUHAvUmRNQzl1anovVGlEcGtiRWJsRmpnMHRzOGV1?=
 =?utf-8?B?bGUvaGlUV0xVdGwwRkwzRTJSenJzOUIyM3FJM2Z1c3QyNTZnNUJvUW9Zc2o5?=
 =?utf-8?B?Q2JjanZmVkFjbnR4TTlmY1Y2c1BkUmh5a09GaEdRZVN0VkhzS09ISG11MGhL?=
 =?utf-8?B?TlJTVTlBV1d2Y2VFb1YrWmtZcUJRR0RXSW1rOVZSbWMrTDUrUW9CWDJBVG1q?=
 =?utf-8?B?eFVabGd4L3VNdS9kUTBNak9uTHpLOC9JaVR3UVRzVkZYK0VDZm1CNDFKQ3Q2?=
 =?utf-8?B?dHByY3VEa2tPQUdzYmgzd0VJSkdOdFJYckFYc1dBdmJiOWtXcTZBK0c3dmtq?=
 =?utf-8?B?TUFWWDFMZExUbVNXbmNvU21naTdXTENZQjlJVWpMMEVWOUQzczBQOHIvQytN?=
 =?utf-8?B?REZOU29CeUhpVEhDcmN4NzgzMmpFVHJ6eHVyVVFjVlh5ZHdSLzZ0cUtBYnJB?=
 =?utf-8?B?VGJ3bTFpUXZoVnViMUVsN1lDa3JPeXBuSU55ZUxzTVFDdXMyWXI0UnRvSndo?=
 =?utf-8?B?MlF2ZUpWOVJZOG5VbzJwdzBNSDhEcElYTWhqWkZKaklkekNjenFyVDE5a0Rs?=
 =?utf-8?B?QmdxUldJVmE5MVlKNldzU2pkc1NYQ3FNZzVUbXA4dWdGSWN0cytOeEpBS1Z2?=
 =?utf-8?B?amNsaGh0TG42L0pQQ1BublVSSXgzc000a2VQd1o2WW5lM0Z3NVFqSW1OU0xZ?=
 =?utf-8?B?QlJhM2xzSHdvYzllSkhpM1QwalZUeXppdXltbllYUzdOcXBJamw3MmdZR1RC?=
 =?utf-8?B?NVRaNWsxeXFSY3JRUnZ0eTJ6d05yMzFKN0JHUkxZN0VTK3I0TElPMGo0dXNx?=
 =?utf-8?B?bnE4Qi9ldU15T2YvS0tTS2tMZk5FT1Q0eVNiaFBMNkhnRlFDVEJHVE5SZFRz?=
 =?utf-8?B?WkRaWmprNE9qWDArV0Z0anhzT2ZVK05IWElxZXVaT0tFQUsxcFFrOE5zWFRa?=
 =?utf-8?B?dHFEM2pTMVgvRDhCVmYyWUh4TUkzK2sxTzNnaVZrWHV4TVMwZEliTkgzNUpT?=
 =?utf-8?B?UU1xd1hyTVN0MDJzRTNOWnNQUnp1aGtZaFo3ekNua3JBaC95b0VGbkNQYTdq?=
 =?utf-8?B?Sy9uTjQ0NTVLUVRnTTJJbENRYUlDV3JUSDFSMDRnS0t0QmFSaDE0L3hGNTU4?=
 =?utf-8?B?ZjBDY0JXc29tbWw3REhUS0hSTjJCeHVoRWJzZDByNlltV1FLUnFzL1A5NnM0?=
 =?utf-8?B?cjZHTFh5L3R2UWRCUUZmbno0S3Q4RFpOYm9WQ1RWVk1Na0g2RjhFd3JHa3Jk?=
 =?utf-8?Q?VqFQHYJgF30XRCl5FWVZzh848?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a124e87-aaa0-43df-a72d-08dd7addd42b
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6739.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2025 22:52:12.5974
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1EIAslxKlp+yIFy6Tr0DqWm1oYAjhht0I2aJq7x15uGrKvUiJA/CltdeAaDzaG+3CoRJDOvZV8yPMyzPWbs1Eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7003
X-OriginatorOrg: intel.com

The event logs test was created as static arrays as an easy way to mock
events.  Dynamic Capacity Device (DCD) test support requires events be
generated dynamically when extents are created or destroyed.

The current event log test has specific checks for the number of events
seen including log overflow.

Modify mock event logs to be dynamically allocated.  Adjust array size
and mock event entry data to match the output expected by the existing
event test.

Use the static event data to create the dynamic events in the new logs
without inventing complex event injection for the previous tests.

Simplify log processing by using the event log array index as the
handle.  Add a lock to manage concurrency required when user space is
allowed to control DCD extents

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes:
[iweiny: rebase to 6.15-rc1]
---
 tools/testing/cxl/test/mem.c | 268 ++++++++++++++++++++++++++-----------------
 1 file changed, 162 insertions(+), 106 deletions(-)

diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
index f2957a3e36fe..a71a72966de1 100644
--- a/tools/testing/cxl/test/mem.c
+++ b/tools/testing/cxl/test/mem.c
@@ -142,18 +142,26 @@ static struct {
 
 #define PASS_TRY_LIMIT 3
 
-#define CXL_TEST_EVENT_CNT_MAX 15
+#define CXL_TEST_EVENT_CNT_MAX 16
+/* 1 extra slot to accommodate that handles can't be 0 */
+#define CXL_TEST_EVENT_ARRAY_SIZE (CXL_TEST_EVENT_CNT_MAX + 1)
 
 /* Set a number of events to return at a time for simulation.  */
 #define CXL_TEST_EVENT_RET_MAX 4
 
+/*
+ * @last_handle: last handle (index) to have an entry stored
+ * @current_handle: current handle (index) to be returned to the user on get_event
+ * @nr_overflow: number of events added past the log size
+ * @lock: protect these state variables
+ * @events: array of pending events to be returned.
+ */
 struct mock_event_log {
-	u16 clear_idx;
-	u16 cur_idx;
-	u16 nr_events;
+	u16 last_handle;
+	u16 current_handle;
 	u16 nr_overflow;
-	u16 overflow_reset;
-	struct cxl_event_record_raw *events[CXL_TEST_EVENT_CNT_MAX];
+	rwlock_t lock;
+	struct cxl_event_record_raw *events[CXL_TEST_EVENT_ARRAY_SIZE];
 };
 
 struct mock_event_store {
@@ -194,56 +202,65 @@ static struct mock_event_log *event_find_log(struct device *dev, int log_type)
 	return &mdata->mes.mock_logs[log_type];
 }
 
-static struct cxl_event_record_raw *event_get_current(struct mock_event_log *log)
-{
-	return log->events[log->cur_idx];
-}
-
-static void event_reset_log(struct mock_event_log *log)
-{
-	log->cur_idx = 0;
-	log->clear_idx = 0;
-	log->nr_overflow = log->overflow_reset;
-}
-
 /* Handle can never be 0 use 1 based indexing for handle */
-static u16 event_get_clear_handle(struct mock_event_log *log)
+static u16 event_inc_handle(u16 handle)
 {
-	return log->clear_idx + 1;
+	handle = (handle + 1) % CXL_TEST_EVENT_ARRAY_SIZE;
+	if (handle == 0)
+		handle = 1;
+	return handle;
 }
 
-/* Handle can never be 0 use 1 based indexing for handle */
-static __le16 event_get_cur_event_handle(struct mock_event_log *log)
-{
-	u16 cur_handle = log->cur_idx + 1;
-
-	return cpu_to_le16(cur_handle);
-}
-
-static bool event_log_empty(struct mock_event_log *log)
-{
-	return log->cur_idx == log->nr_events;
-}
-
-static void mes_add_event(struct mock_event_store *mes,
+/* Add the event or free it on overflow */
+static void mes_add_event(struct cxl_mockmem_data *mdata,
 			  enum cxl_event_log_type log_type,
 			  struct cxl_event_record_raw *event)
 {
+	struct device *dev = mdata->mds->cxlds.dev;
 	struct mock_event_log *log;
 
 	if (WARN_ON(log_type >= CXL_EVENT_TYPE_MAX))
 		return;
 
-	log = &mes->mock_logs[log_type];
+	log = &mdata->mes.mock_logs[log_type];
+
+	guard(write_lock)(&log->lock);
 
-	if ((log->nr_events + 1) > CXL_TEST_EVENT_CNT_MAX) {
+	dev_dbg(dev, "Add log %d cur %d last %d\n",
+		log_type, log->current_handle, log->last_handle);
+
+	/* Check next buffer */
+	if (event_inc_handle(log->last_handle) == log->current_handle) {
 		log->nr_overflow++;
-		log->overflow_reset = log->nr_overflow;
+		dev_dbg(dev, "Overflowing log %d nr %d\n",
+			log_type, log->nr_overflow);
+		devm_kfree(dev, event);
 		return;
 	}
 
-	log->events[log->nr_events] = event;
-	log->nr_events++;
+	dev_dbg(dev, "Log %d; handle %u\n", log_type, log->last_handle);
+	event->event.generic.hdr.handle = cpu_to_le16(log->last_handle);
+	log->events[log->last_handle] = event;
+	log->last_handle = event_inc_handle(log->last_handle);
+}
+
+static void mes_del_event(struct device *dev,
+			  struct mock_event_log *log,
+			  u16 handle)
+{
+	struct cxl_event_record_raw *record;
+
+	lockdep_assert(lockdep_is_held(&log->lock));
+
+	dev_dbg(dev, "Clearing event %u; record %u\n",
+		handle, log->current_handle);
+	record = log->events[handle];
+	if (!record)
+		dev_err(dev, "Mock event index %u empty?\n", handle);
+
+	log->events[handle] = NULL;
+	log->current_handle = event_inc_handle(log->current_handle);
+	devm_kfree(dev, record);
 }
 
 /*
@@ -256,7 +273,7 @@ static int mock_get_event(struct device *dev, struct cxl_mbox_cmd *cmd)
 {
 	struct cxl_get_event_payload *pl;
 	struct mock_event_log *log;
-	u16 nr_overflow;
+	u16 handle;
 	u8 log_type;
 	int i;
 
@@ -277,29 +294,38 @@ static int mock_get_event(struct device *dev, struct cxl_mbox_cmd *cmd)
 	memset(cmd->payload_out, 0, struct_size(pl, records, 0));
 
 	log = event_find_log(dev, log_type);
-	if (!log || event_log_empty(log))
+	if (!log)
 		return 0;
 
 	pl = cmd->payload_out;
 
-	for (i = 0; i < ret_limit && !event_log_empty(log); i++) {
-		memcpy(&pl->records[i], event_get_current(log),
-		       sizeof(pl->records[i]));
-		pl->records[i].event.generic.hdr.handle =
-				event_get_cur_event_handle(log);
-		log->cur_idx++;
+	guard(read_lock)(&log->lock);
+
+	handle = log->current_handle;
+	dev_dbg(dev, "Get log %d handle %u last %u\n",
+		log_type, handle, log->last_handle);
+	for (i = 0; i < ret_limit && handle != log->last_handle;
+	     i++, handle = event_inc_handle(handle)) {
+		struct cxl_event_record_raw *cur;
+
+		cur = log->events[handle];
+		dev_dbg(dev, "Sending event log %d handle %d idx %u\n",
+			log_type, le16_to_cpu(cur->event.generic.hdr.handle),
+			handle);
+		memcpy(&pl->records[i], cur, sizeof(pl->records[i]));
+		pl->records[i].event.generic.hdr.handle = cpu_to_le16(handle);
 	}
 
 	cmd->size_out = struct_size(pl, records, i);
 	pl->record_count = cpu_to_le16(i);
-	if (!event_log_empty(log))
+	if (handle != log->last_handle)
 		pl->flags |= CXL_GET_EVENT_FLAG_MORE_RECORDS;
 
 	if (log->nr_overflow) {
 		u64 ns;
 
 		pl->flags |= CXL_GET_EVENT_FLAG_OVERFLOW;
-		pl->overflow_err_count = cpu_to_le16(nr_overflow);
+		pl->overflow_err_count = cpu_to_le16(log->nr_overflow);
 		ns = ktime_get_real_ns();
 		ns -= 5000000000; /* 5s ago */
 		pl->first_overflow_timestamp = cpu_to_le64(ns);
@@ -314,8 +340,8 @@ static int mock_get_event(struct device *dev, struct cxl_mbox_cmd *cmd)
 static int mock_clear_event(struct device *dev, struct cxl_mbox_cmd *cmd)
 {
 	struct cxl_mbox_clear_event_payload *pl = cmd->payload_in;
-	struct mock_event_log *log;
 	u8 log_type = pl->event_log;
+	struct mock_event_log *log;
 	u16 handle;
 	int nr;
 
@@ -326,23 +352,20 @@ static int mock_clear_event(struct device *dev, struct cxl_mbox_cmd *cmd)
 	if (!log)
 		return 0; /* No mock data in this log */
 
-	/*
-	 * This check is technically not invalid per the specification AFAICS.
-	 * (The host could 'guess' handles and clear them in order).
-	 * However, this is not good behavior for the host so test it.
-	 */
-	if (log->clear_idx + pl->nr_recs > log->cur_idx) {
-		dev_err(dev,
-			"Attempting to clear more events than returned!\n");
-		return -EINVAL;
-	}
+	guard(write_lock)(&log->lock);
 
 	/* Check handle order prior to clearing events */
-	for (nr = 0, handle = event_get_clear_handle(log);
-	     nr < pl->nr_recs;
-	     nr++, handle++) {
+	handle = log->current_handle;
+	for (nr = 0; nr < pl->nr_recs && handle != log->last_handle;
+	     nr++, handle = event_inc_handle(handle)) {
+
+		dev_dbg(dev, "Checking clear of %d handle %u plhandle %u\n",
+			log_type, handle,
+			le16_to_cpu(pl->handles[nr]));
+
 		if (handle != le16_to_cpu(pl->handles[nr])) {
-			dev_err(dev, "Clearing events out of order\n");
+			dev_err(dev, "Clearing events out of order %u %u\n",
+				handle, le16_to_cpu(pl->handles[nr]));
 			return -EINVAL;
 		}
 	}
@@ -351,25 +374,12 @@ static int mock_clear_event(struct device *dev, struct cxl_mbox_cmd *cmd)
 		log->nr_overflow = 0;
 
 	/* Clear events */
-	log->clear_idx += pl->nr_recs;
-	return 0;
-}
-
-static void cxl_mock_event_trigger(struct device *dev)
-{
-	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
-	struct mock_event_store *mes = &mdata->mes;
-	int i;
+	for (nr = 0; nr < pl->nr_recs; nr++)
+		mes_del_event(dev, log, le16_to_cpu(pl->handles[nr]));
+	dev_dbg(dev, "Delete log %d cur %d last %d\n",
+		log_type, log->current_handle, log->last_handle);
 
-	for (i = CXL_EVENT_TYPE_INFO; i < CXL_EVENT_TYPE_MAX; i++) {
-		struct mock_event_log *log;
-
-		log = event_find_log(dev, i);
-		if (log)
-			event_reset_log(log);
-	}
-
-	cxl_mem_get_event_records(mdata->mds, mes->ev_status);
+	return 0;
 }
 
 struct cxl_event_record_raw maint_needed = {
@@ -510,8 +520,27 @@ static int mock_set_timestamp(struct cxl_dev_state *cxlds,
 	return 0;
 }
 
-static void cxl_mock_add_event_logs(struct mock_event_store *mes)
+/* Create a dynamically allocated event out of a statically defined event. */
+static void add_event_from_static(struct cxl_mockmem_data *mdata,
+				  enum cxl_event_log_type log_type,
+				  struct cxl_event_record_raw *raw)
+{
+	struct device *dev = mdata->mds->cxlds.dev;
+	struct cxl_event_record_raw *rec;
+
+	rec = devm_kmemdup(dev, raw, sizeof(*rec), GFP_KERNEL);
+	if (!rec) {
+		dev_err(dev, "Failed to alloc event for log\n");
+		return;
+	}
+	mes_add_event(mdata, log_type, rec);
+}
+
+static void cxl_mock_add_event_logs(struct cxl_mockmem_data *mdata)
 {
+	struct mock_event_store *mes = &mdata->mes;
+	struct device *dev = mdata->mds->cxlds.dev;
+
 	put_unaligned_le16(CXL_GMER_VALID_CHANNEL | CXL_GMER_VALID_RANK |
 			   CXL_GMER_VALID_COMPONENT | CXL_GMER_VALID_COMPONENT_ID_FORMAT,
 			   &gen_media.rec.media_hdr.validity_flags);
@@ -524,43 +553,60 @@ static void cxl_mock_add_event_logs(struct mock_event_store *mes)
 	put_unaligned_le16(CXL_MMER_VALID_COMPONENT | CXL_MMER_VALID_COMPONENT_ID_FORMAT,
 			   &mem_module.rec.validity_flags);
 
-	mes_add_event(mes, CXL_EVENT_TYPE_INFO, &maint_needed);
-	mes_add_event(mes, CXL_EVENT_TYPE_INFO,
+	dev_dbg(dev, "Generating fake event logs %d\n",
+		CXL_EVENT_TYPE_INFO);
+	add_event_from_static(mdata, CXL_EVENT_TYPE_INFO, &maint_needed);
+	add_event_from_static(mdata, CXL_EVENT_TYPE_INFO,
 		      (struct cxl_event_record_raw *)&gen_media);
-	mes_add_event(mes, CXL_EVENT_TYPE_INFO,
+	add_event_from_static(mdata, CXL_EVENT_TYPE_INFO,
 		      (struct cxl_event_record_raw *)&mem_module);
 	mes->ev_status |= CXLDEV_EVENT_STATUS_INFO;
 
-	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &maint_needed);
-	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
-	mes_add_event(mes, CXL_EVENT_TYPE_FAIL,
+	dev_dbg(dev, "Generating fake event logs %d\n",
+		CXL_EVENT_TYPE_FAIL);
+	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &maint_needed);
+	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL,
+		      (struct cxl_event_record_raw *)&mem_module);
+	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
+	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL,
 		      (struct cxl_event_record_raw *)&dram);
-	mes_add_event(mes, CXL_EVENT_TYPE_FAIL,
+	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL,
 		      (struct cxl_event_record_raw *)&gen_media);
-	mes_add_event(mes, CXL_EVENT_TYPE_FAIL,
+	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL,
 		      (struct cxl_event_record_raw *)&mem_module);
-	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
-	mes_add_event(mes, CXL_EVENT_TYPE_FAIL,
+	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
+	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL,
 		      (struct cxl_event_record_raw *)&dram);
 	/* Overflow this log */
-	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
-	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
-	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
-	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
-	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
-	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
-	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
-	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
-	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
-	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
+	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
+	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
+	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
+	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
+	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
+	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
+	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
+	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
+	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
+	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
 	mes->ev_status |= CXLDEV_EVENT_STATUS_FAIL;
 
-	mes_add_event(mes, CXL_EVENT_TYPE_FATAL, &hardware_replace);
-	mes_add_event(mes, CXL_EVENT_TYPE_FATAL,
+	dev_dbg(dev, "Generating fake event logs %d\n",
+		CXL_EVENT_TYPE_FATAL);
+	add_event_from_static(mdata, CXL_EVENT_TYPE_FATAL, &hardware_replace);
+	add_event_from_static(mdata, CXL_EVENT_TYPE_FATAL,
 		      (struct cxl_event_record_raw *)&dram);
 	mes->ev_status |= CXLDEV_EVENT_STATUS_FATAL;
 }
 
+static void cxl_mock_event_trigger(struct device *dev)
+{
+	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
+	struct mock_event_store *mes = &mdata->mes;
+
+	cxl_mock_add_event_logs(mdata);
+	cxl_mem_get_event_records(mdata->mds, mes->ev_status);
+}
+
 static int mock_gsl(struct cxl_mbox_cmd *cmd)
 {
 	if (cmd->size_out < sizeof(mock_gsl_payload))
@@ -1685,6 +1731,14 @@ static void cxl_mock_test_feat_init(struct cxl_mockmem_data *mdata)
 	mdata->test_feat.data = cpu_to_le32(0xdeadbeef);
 }
 
+static void init_event_log(struct mock_event_log *log)
+{
+	rwlock_init(&log->lock);
+	/* Handle can never be 0 use 1 based indexing for handle */
+	log->current_handle = 1;
+	log->last_handle = 1;
+}
+
 static int cxl_mock_mem_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -1766,7 +1820,9 @@ static int cxl_mock_mem_probe(struct platform_device *pdev)
 	if (rc)
 		dev_dbg(dev, "No CXL Features discovered\n");
 
-	cxl_mock_add_event_logs(&mdata->mes);
+	for (int i = 0; i < CXL_EVENT_TYPE_MAX; i++)
+		init_event_log(&mdata->mes.mock_logs[i]);
+	cxl_mock_add_event_logs(mdata);
 
 	cxlmd = devm_cxl_add_memdev(&pdev->dev, cxlds);
 	if (IS_ERR(cxlmd))

-- 
2.49.0

