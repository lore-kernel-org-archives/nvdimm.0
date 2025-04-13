Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13FA1C860E
	for <nvdimm@lists.linux.dev>; Sun, 13 Apr 2025 22:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744584744; cv=fail; b=RJ2eMktrICYDlYK75IJN+IZfLbDsbI7rJ78cvZ1pGDO37/+BNNGzdCTKi6H2gYxgi4qk47x5wNDyMblkdxTRF4/7M8IHLpTST67tzHIONX8S6ZghWWyHpd9nM8EtSQHFgrBKaoWVyAK/nDIGzxr7OUwaFAmAHTjOWE8rRF1BCbM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744584744; c=relaxed/simple;
	bh=dbpnUt0Rj32jPB+ZTtMa+10bARM2SLtI6QbpS09VtA4=;
	h=From:Date:Subject:Content-Type:Message-ID:References:In-Reply-To:
	 To:CC:MIME-Version; b=LI9YBL0Xm3gnjr+TB2kH2BN8cQ1aIoo/k6wZ1xc07rD0Ww1F4H/wpIEvKZIPNG4hSKPDFU4hoDtcmQvRKcAjVYWo3Ar9C1BfuEfeFPYyEIjCFlvjZm/59yHaTQ1/mwyRcFocxk0VfQ1np/Pke1XN4yv3SuojJ0fbN5qN5sybmdE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GJYc0G8V; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GJYc0G8V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744584742; x=1776120742;
  h=from:date:subject:content-transfer-encoding:message-id:
   references:in-reply-to:to:cc:mime-version;
  bh=dbpnUt0Rj32jPB+ZTtMa+10bARM2SLtI6QbpS09VtA4=;
  b=GJYc0G8Vn31qDmzTRX1gjW3/oRORbCrDpA8SxIRLdcUtweUqCGJ2qW2d
   YbuwOtCTxINDVnRebqZldpk+XmlrW2YOXRnCwI2OMCMO+BU7H/XEeTxDI
   m4K1vdLwd3cGqIXXiryF/+eySdtWJgbB4sPigbMSdgFT5vNJz6gJ5V4Il
   ld5HTXZooyL+2PCtUWmfeU6ywkLgqip8ahDRpJSm6cC3n+KoDx9TZvYwo
   tDdiCpMiFb6sl6jLK2n+tni1gAkoVpmIkCNoJlyo3KBBaI/d4DACiPw9F
   BuWlz12YCGHEyx2iFk7hzhYysQzbNJE2gCWrPB40az1EGFnqAHUamqAoc
   g==;
X-CSE-ConnectionGUID: d2L/evoRQnKASEo0IMTwbw==
X-CSE-MsgGUID: G1ru5EZeQ3iEzIF/3y+9Cg==
X-IronPort-AV: E=McAfee;i="6700,10204,11402"; a="71431138"
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="71431138"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2025 15:52:20 -0700
X-CSE-ConnectionGUID: QGOhIkznRJiD28s1okWoEA==
X-CSE-MsgGUID: f8EH6ZhjSjGuw8Fi6920eA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="134405570"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2025 15:52:21 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Sun, 13 Apr 2025 15:52:20 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sun, 13 Apr 2025 15:52:20 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.43) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 13 Apr 2025 15:52:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LdHooYh1JpyfT8w0EiR6oyCluqFXITWnC20fw1Ol+/8kLpwP7TsFAe4zAVsiLvbGOc/oor+Xi8FWNgnVmjEDHJ+mEg0D3ziYKlohjMiwUZqB+cjZnW3qdRkfEaJZhyuXp0SyJsD/e1eJjeWHts7X8lq4vlPpUWTQNuFDA0ETns0PF4i9lmZf+ut04SbrSALvwiGSsNjsuV5htkAyr5cDVQOaImwgJyvQQUqQnbHsGBR4HntlAVGCQlmQEkiqpRNX7wCkhn1EpD6z6kjf+JGRq7cOLwTDJhwgHBweG2Bquz8IwTQzN0VPILQs/lOZuCUIU6O0HLB37Dne0c4emKHyoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wNoAbBBYNS2LHiqzwRXuIEpkmfzCc69lB2/JkZ8R22g=;
 b=NekB3uZiYnJh9pjEKc4rnOaiVonv5oyAT1bQSCafD++ZLOxBAiZgCHqA5/9uSsDpX57QBASXnHFHW59YB2yww435NrBD7RWtux4n58dpVNeCW6ncaON9XMfRURpTsN6/MqzWesmOOmjUrLyCX+j0heDl6owPwhX0G3ZB0orolfJc20R8TjdSVLSwaglvWyCG+3d3mho54Qh3kfDYIRZDaNPZs+SU5MjhG6hFBiuCsnQnFOU7ocD7ABAcWEaxuFVYUzn14V6mQ9ISHlaN+DRGaLfZFZ9pYN/PYmc7UIDKDaA9Vtb+Sqit7g7Vkg1e0zFhxVrUQjMnLOGuSg6j1FyETQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW4PR11MB6739.namprd11.prod.outlook.com (2603:10b6:303:20b::19)
 by PH7PR11MB7003.namprd11.prod.outlook.com (2603:10b6:510:20a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.33; Sun, 13 Apr
 2025 22:52:09 +0000
Received: from MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24]) by MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24%4]) with mapi id 15.20.8606.033; Sun, 13 Apr 2025
 22:52:09 +0000
From: Ira Weiny <ira.weiny@intel.com>
Date: Sun, 13 Apr 2025 17:52:24 -0500
Subject: [PATCH v9 16/19] cxl/region: Read existing extents on region
 creation
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20250413-dcd-type2-upstream-v9-16-1d4911a0b365@intel.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1744584735; l=8457;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=dbpnUt0Rj32jPB+ZTtMa+10bARM2SLtI6QbpS09VtA4=;
 b=70LGskBUS72k14zEP1Njc047eMZ4tEAL0gJfSp2jak5WU2AlIXmrrUYBAsAkY9W4FefcUPLLg
 2SacYrWNvLpAk1H9F7j78oUDfgSc1+GfOT/QkEwP4WDjJWW7AndDprC
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
X-MS-Office365-Filtering-Correlation-Id: e84c113a-2d07-40ec-c33e-08dd7addd229
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Q2tycUM2SlpNMVlPOU9aMTNrbUEraStxSkUzYVB0WUI2UThqaThWcU41L3hN?=
 =?utf-8?B?WGQ3SnFKNFc5NGdYUjMxYThKUmxaanFmS2ZicFBJcjhkSWtLSmMzak1XemZy?=
 =?utf-8?B?bzdSZGM5TGNVNlhkME41aDhWSTF6bnFwaU42cnJlYnFDY0d6N3hEaDFqMit2?=
 =?utf-8?B?d3NQN3RITm5UV0g4dk5IOHp5M1JWSkdwQmc1NXlsUHBIaUptR3lRY0l1UXd6?=
 =?utf-8?B?NCtocXozbHJvNkRmQlJoMnN1OEJKWE51TXVmcExXMmwyR2s3eFZMVDFKcHlv?=
 =?utf-8?B?ZEhFSXNIMk5aQnpTR3pZbGpadkJJUXAxNG01MC8wT01MNmtyNldrckNwSUVl?=
 =?utf-8?B?NzhIYmZ4Y0crRTlyWkZKVnNUWjhGQWFDcUhScEFvS2x1Z1R3S0Q5SzRMWFBY?=
 =?utf-8?B?WVhCZTFnNGREcitrNmhvZGtOYlRnUkt3SGhoU0RZemQzUXo1cEJqNVRlbmRk?=
 =?utf-8?B?WWJZZzhUNmd6bFdZdm9ucDF3TytqSnBGdjI4TS8vb0UxK1VZa2RhSVZTRHZC?=
 =?utf-8?B?Q0c4OXZlRzZjMURySmJpTXhQeXhFTkV4NnpPejBjQ0hxZXRQOHl3aFRkbkxV?=
 =?utf-8?B?VTd6aGROc2Y2aS9lWHcvUGNheWVlZ2tES2F0SWg0M3hNK2o5OUJha1NBQ0Ev?=
 =?utf-8?B?cnNkZlpEZ2VWdXVwOXNtcWtaVWRNT1F1SXUydUpxbzRaRU1sZ2poeTZ0cTFX?=
 =?utf-8?B?SFZIejAvWkd6TnlHQ3l5RCs3N2NhSXBlRHhlME5XSG1hbEVWaFNsNEZwYXdF?=
 =?utf-8?B?Vyt1RTQrTlJYYmlTdHBkeWJiblR4dG05azhtTTF1T21SK3N2U00vcFIwaHlH?=
 =?utf-8?B?d2FGYUFKa3Z4ZC8wQlpiSGdWQldGMGMwL2lTUElwOTMxSWRBNVl4d2ZIRXMv?=
 =?utf-8?B?R2NHSWdzQXJubzhpYldUTHNXREFpb3FldkZtUzhIcXdYVXNVOG9mZ2ptTklN?=
 =?utf-8?B?R3hYdXA0WjVJSnZpUUg2S3ZUa2JhV3hxS0RnZ2d5RDVENVc5aW4vM08zQUxN?=
 =?utf-8?B?cHI4aFhwUUZjSHdmNklEWnRzTm5jM3NLdkZSSVRJdjlUajlaRUpGQnN6Mk14?=
 =?utf-8?B?aGJpb3BUTnNGQ1lYZ0xoZkw1RlhlbTJpMHU3K0UvU3B5SkM0N2o4aUJ1U3Z0?=
 =?utf-8?B?aFhITnBhc1F6dWkxaXhlSkZ5V2Zwby82KzFVdnJKbVpRazlZY3ZSeVhJTk85?=
 =?utf-8?B?VW01MmNCbXF6aFRSRTlPKzhvU0RmdGVDc2dDSUJHSHROSDRRWnc4MmJPV056?=
 =?utf-8?B?K0lPUFdsS1k0WURpVjBYSHliWGF0SGdha01PcWRBSjZPdjhFdHlRVnZySUJI?=
 =?utf-8?B?Zldsdzl6ZVEwWStzQ3ZvV2hFY2JubTdFVUdOVGNsWnI5bnB4ZzNmQU1OU1VO?=
 =?utf-8?B?ZFh3SmQ5aFA0MWZKMEdPbDFwK0dOb2lDTWM3bHFTRjhQVTR0RWhESXNKeXIr?=
 =?utf-8?B?a215Q2ZMTkVmQW5jeHNNaWpOSThycWVmL0VkdU4xWkVVT255cTRMZnl4cHFw?=
 =?utf-8?B?LzVXWk5UL2lKdHo4b0QrNnNDcndwQXQyb0Q4czRiRnVCVSs5ajk1elVFN0Uw?=
 =?utf-8?B?VDJzWjZuUGZORE5selcyVHhIQ1JnVTBNUGdmK1Fmb0NOamxuT0I2ak4xVDFQ?=
 =?utf-8?B?N1JQcTAvMHZvSEFLOFVpcThkZE5pR0FkN0d6R0p0YlFBY2wyL3NvYmNtR0Qw?=
 =?utf-8?B?Q05IQ21LN1VScVVNTDRyZC90QUNyNlh5VWpqNFdyRTdQNG12d2NrTUs1dTVv?=
 =?utf-8?B?OFNYUHlwaThOR0M5cko3Q2NSL3c2YVQveEVKcGZoR3lpOEkxckNULzk2dzFU?=
 =?utf-8?B?VkZ0bzlmbVpyeE4rNDBkYjJ5MmpvbXNhQ2ZHbGhra1pFS2tGeVBZVEtDMGMw?=
 =?utf-8?B?MVY1WWNpdFR2NEtEeDBRak84VmYreE8rOERtQVJJRWZ1R2c9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6739.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N2hJcVpxSlNUK1U5Mlk5bjRpNDRmamp0WXdFOWEyNXQ4SUJSMjR4ZGJnb2g0?=
 =?utf-8?B?dkJuNUg4VEc3bG03eFBNaXpnM2EwOURnYnZMRXRNbVpqY3VoeWpnR29UTEpj?=
 =?utf-8?B?RzYrRGhXTWVnVmNaN3dtZzNZMGJlSDg0SUl4NWV6a001Rno1dlhGWW1lSFpj?=
 =?utf-8?B?b2VwVVpJNHptdnBaeEtIYVdiL1lWUnBGMkJJQmFjQjVzMGl1RzFxbUViRzNJ?=
 =?utf-8?B?YVlZcUV0MjBQOVhaVlFTS3RWaXpiSi9oZ2tEeDNwSThtSi9qUFk3QlhxRWpy?=
 =?utf-8?B?cXhMbFVxdE5MUjZyVFhldkN6Nm5od3EraW9HUktkdTBCTW02TkhUZmlNSG4w?=
 =?utf-8?B?V2JZYTZWamhxNzFwOWxvMm5adldZRlFUYlorOWJXc3BBN0MwdzJzR3UyQjF5?=
 =?utf-8?B?WGRTUmxzZDYwSXZFTFBZUG5WcXlZdzA1c21UeTBwYnNzdExhQVI2MFhNUUlu?=
 =?utf-8?B?VnZQbzEzQ1BHbmdiZGxnMHZRYmZnM1oyWnNxdDVxdFU4NGNuZERZa0FsZlVp?=
 =?utf-8?B?NzNOUmlZZUVLNDUwUlBua2pPSjJwVnhkS0pyM3d3QjMrZFRmb3pUU2hsM2Vx?=
 =?utf-8?B?QWdNZmhjckZjR1BYZlpjSyt6Y0ptNHBCMEJNMEJ2M1hzR0RQVHJWa2RzSlJr?=
 =?utf-8?B?SUNDRkkyTVBlOUlaRnhXSy9VUFJPaEVHS2xaYzdlL21vYWZIZ0hSM2dpVEpK?=
 =?utf-8?B?aTFKektCRXRJWU5CRjQxSDczWDJGQ29UaHBJL0lvZjJPTFRhWWxTOFZjalJk?=
 =?utf-8?B?K1V5QWFmKzdyUHFtWldKSTVjUG1PcnNFUmRieXJRUGRBZE1qbTF1cFVtT01y?=
 =?utf-8?B?cUZJbEhOa3BTdnY0OUE5aHF2NGdRVUJwMjhnbjdaWGlPSUdSQVZkOWIvaXdY?=
 =?utf-8?B?YkpaYmkrYTJZendFck9kK25sMlVUelVHdkFvUEtlVFlmbGJKMlVHRFRSdGMw?=
 =?utf-8?B?NUlycHNYd29wbzRndVlxNEx3VEFjMDQxdnN2S0lUT25ncW4ySzFUdllVckht?=
 =?utf-8?B?dWdEZm5OVkZsTUxGb0gxNmZYNk1rbm5Ia3k0YUVSbDVzbC9NaktoVWt1ZFJh?=
 =?utf-8?B?bFNWaXdqQkw2aUVhZzBrOHR2YzkvYjRwelZIeHdCek53SUovNEJpZlR0UGVP?=
 =?utf-8?B?VTRNV0ZWUmY0ZnhyM2RhSDA5REZrNTVRVkoxNTdNQmNTb0hpYnc5VTBlUGFP?=
 =?utf-8?B?eVpKQndhaVg3cW51QVNRemM4SkRud1dIWmlSK1psNDVsVDZRRjdmRm1iYkZB?=
 =?utf-8?B?ZStwR2NQSGVlV0VyQ2FvSThkT2xuOGNscExqNjFOTSs3RWM5ejlSS2p0L242?=
 =?utf-8?B?N1lnTnhLcUVYOElUdjNpQ2pEb1FLWWMxcllTT0RySEtNd3JDcVdPZnlyWkU2?=
 =?utf-8?B?eTJCRElHM00wUWpJeUMySFA2K1pzWHpBSTd2WDFkalYyYnVab2Q1SGhBbmhk?=
 =?utf-8?B?WndOTU9PenlubjdvQmw3TkdVRjIvZkxsanFJaU9wTG85K3FPYW1EbzQ5cGhj?=
 =?utf-8?B?d1VIV1NpVU43UjV4aXdRYnUyRHhHbzVPYTJhVndaOW5zZVZ4NCtheGRCZDhI?=
 =?utf-8?B?Zm9xdFBoZERuTGpvbUt1N0dGb0dsNWpuYXprQ3IvUjV4ZEJ1RTJUSFdPbElz?=
 =?utf-8?B?ak8vRXF4OGF2NTgwN1UwTDlhMWVRR1d6OHBFb2p2TnVkamJKQ3ZJZVF5MGRa?=
 =?utf-8?B?VndvZmpSSCtFNmxYTnFtYkduSkhVNzdQU0lMbXNQdEs0TnRsUktQbXllNENO?=
 =?utf-8?B?OHZlaytVbzUzT3hJM0M4NWh3OTM2MHZrRWNCa0xDOTdacHA5ejdvWHhtWG5Z?=
 =?utf-8?B?SzhpMEN1NTBabnNyZkRwM256VHZVR0NaQ1p0blNpdklmNTZPRVNyRk8xU2Rl?=
 =?utf-8?B?dFFEUHQzUWJCOFVpR0loWHdoU0Z4YXBDazFTNHNyS0lXVFVtb2c5L0dnRmlr?=
 =?utf-8?B?ZXExK3JKYng3SWw3bnFvWnZOLzRZNkhBbVNjRGpKbVV6eVZ6QlVUYUNNMjlZ?=
 =?utf-8?B?cCt4SEZhb3J3L3VkTVFtbVR1RFJ6cE5ieGViSzg2S3BrdVNNNndOekJIazZZ?=
 =?utf-8?B?WUZzUnpmVVkyMFk2dGttNVBpV2ZQN0JLSGxVYkhJNTJubTFnWUZGdDc3MWFS?=
 =?utf-8?Q?GG3yzjp9l7NTbu4W4dwrcC0vd?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e84c113a-2d07-40ec-c33e-08dd7addd229
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6739.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2025 22:52:09.2099
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9SwpEwJbiZKm8gFKf9HBl0LfA8NclD6Fy4yMdD2qe3q9xKLlG5XoOFZLiWfH5SW3ehEDhp2R8jquq+CHGahIhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7003
X-OriginatorOrg: intel.com

Dynamic capacity device extents may be left in an accepted state on a
device due to an unexpected host crash.  In this case it is expected
that the creation of a new region on top of a DC partition can read
those extents and surface them for continued use.

Once all endpoint decoders are part of a region and the region is being
realized, a read of the 'devices extent list' can reveal these
previously accepted extents.

CXL r3.1 specifies the mailbox call Get Dynamic Capacity Extent List for
this purpose.  The call returns all the extents for all dynamic capacity
partitions.  If the fabric manager is adding extents to any DCD
partition, the extent list for the recovered region may change.  In this
case the query must retry.  Upon retry the query could encounter extents
which were accepted on a previous list query.  Adding such extents is
ignored without error because they are entirely within a previous
accepted extent.  Instead warn on this case to allow for differentiating
bad devices from this normal condition.

Latch any errors to be bubbled up to ensure notification to the user
even if individual errors are rate limited or otherwise ignored.

The scan for existing extents races with the dax_cxl driver.  This is
synchronized through the region device lock.  Extents which are found
after the driver has loaded will surface through the normal notification
path while extents seen prior to the driver are read during driver load.

Based on an original patch by Navneet Singh.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Fan Ni <fan.ni@samsung.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes:
[0day: fix extent count in GetExtent input payload]
[iweiny: minor clean ups]
[iweiny: Adjust for partition arch]
---
 drivers/cxl/core/core.h   |   1 +
 drivers/cxl/core/mbox.c   | 109 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/cxl/core/region.c |  25 +++++++++++
 drivers/cxl/cxlmem.h      |  21 +++++++++
 4 files changed, 156 insertions(+)

diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index 027dd1504d77..e06a46fec217 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -22,6 +22,7 @@ cxled_to_mds(struct cxl_endpoint_decoder *cxled)
 	return container_of(cxlds, struct cxl_memdev_state, cxlds);
 }
 
+int cxl_process_extent_list(struct cxl_endpoint_decoder *cxled);
 int cxl_region_invalidate_memregion(struct cxl_region *cxlr);
 
 #ifdef CONFIG_CXL_REGION
diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index de01c6684530..8af3a4173b99 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -1737,6 +1737,115 @@ int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
 }
 EXPORT_SYMBOL_NS_GPL(cxl_dev_dc_identify, "CXL");
 
+/* Return -EAGAIN if the extent list changes while reading */
+static int __cxl_process_extent_list(struct cxl_endpoint_decoder *cxled)
+{
+	u32 current_index, total_read, total_expected, initial_gen_num;
+	struct cxl_memdev_state *mds = cxled_to_mds(cxled);
+	struct cxl_mailbox *cxl_mbox = &mds->cxlds.cxl_mbox;
+	struct device *dev = mds->cxlds.dev;
+	struct cxl_mbox_cmd mbox_cmd;
+	u32 max_extent_count;
+	int latched_rc = 0;
+	bool first = true;
+
+	struct cxl_mbox_get_extent_out *extents __free(kvfree) =
+				kvmalloc(cxl_mbox->payload_size, GFP_KERNEL);
+	if (!extents)
+		return -ENOMEM;
+
+	total_read = 0;
+	current_index = 0;
+	total_expected = 0;
+	max_extent_count = (cxl_mbox->payload_size - sizeof(*extents)) /
+				sizeof(struct cxl_extent);
+	do {
+		u32 nr_returned, current_total, current_gen_num;
+		struct cxl_mbox_get_extent_in get_extent;
+		int rc;
+
+		get_extent = (struct cxl_mbox_get_extent_in) {
+			.extent_cnt = cpu_to_le32(max(max_extent_count,
+						  total_expected - current_index)),
+			.start_extent_index = cpu_to_le32(current_index),
+		};
+
+		mbox_cmd = (struct cxl_mbox_cmd) {
+			.opcode = CXL_MBOX_OP_GET_DC_EXTENT_LIST,
+			.payload_in = &get_extent,
+			.size_in = sizeof(get_extent),
+			.size_out = cxl_mbox->payload_size,
+			.payload_out = extents,
+			.min_out = 1,
+		};
+
+		rc = cxl_internal_send_cmd(cxl_mbox, &mbox_cmd);
+		if (rc < 0)
+			return rc;
+
+		/* Save initial data */
+		if (first) {
+			total_expected = le32_to_cpu(extents->total_extent_count);
+			initial_gen_num = le32_to_cpu(extents->generation_num);
+			first = false;
+		}
+
+		nr_returned = le32_to_cpu(extents->returned_extent_count);
+		total_read += nr_returned;
+		current_total = le32_to_cpu(extents->total_extent_count);
+		current_gen_num = le32_to_cpu(extents->generation_num);
+
+		dev_dbg(dev, "Got extent list %d-%d of %d generation Num:%d\n",
+			current_index, total_read - 1, current_total, current_gen_num);
+
+		if (current_gen_num != initial_gen_num || total_expected != current_total) {
+			dev_warn(dev, "Extent list change detected; gen %u != %u : cnt %u != %u\n",
+				 current_gen_num, initial_gen_num,
+				 total_expected, current_total);
+			return -EAGAIN;
+		}
+
+		for (int i = 0; i < nr_returned ; i++) {
+			struct cxl_extent *extent = &extents->extent[i];
+
+			dev_dbg(dev, "Processing extent %d/%d\n",
+				current_index + i, total_expected);
+
+			rc = validate_add_extent(mds, extent);
+			if (rc)
+				latched_rc = rc;
+		}
+
+		current_index += nr_returned;
+	} while (total_expected > total_read);
+
+	return latched_rc;
+}
+
+#define CXL_READ_EXTENT_LIST_RETRY 10
+
+/**
+ * cxl_process_extent_list() - Read existing extents
+ * @cxled: Endpoint decoder which is part of a region
+ *
+ * Issue the Get Dynamic Capacity Extent List command to the device
+ * and add existing extents if found.
+ *
+ * A retry of 10 is somewhat arbitrary, however, extent changes should be
+ * relatively rare while bringing up a region.  So 10 should be plenty.
+ */
+int cxl_process_extent_list(struct cxl_endpoint_decoder *cxled)
+{
+	int retry = CXL_READ_EXTENT_LIST_RETRY;
+	int rc;
+
+	do {
+		rc = __cxl_process_extent_list(cxled);
+	} while (rc == -EAGAIN && retry--);
+
+	return rc;
+}
+
 static void add_part(struct cxl_dpa_info *info, u64 start, u64 size, enum cxl_partition_mode mode)
 {
 	int i = info->nr_partitions;
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index eeabc5a6b18a..a43b43972bae 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -3196,6 +3196,26 @@ static int devm_cxl_add_pmem_region(struct cxl_region *cxlr)
 	return rc;
 }
 
+static int cxlr_add_existing_extents(struct cxl_region *cxlr)
+{
+	struct cxl_region_params *p = &cxlr->params;
+	int i, latched_rc = 0;
+
+	for (i = 0; i < p->nr_targets; i++) {
+		struct device *dev = &p->targets[i]->cxld.dev;
+		int rc;
+
+		rc = cxl_process_extent_list(p->targets[i]);
+		if (rc) {
+			dev_err(dev, "Existing extent processing failed %d\n",
+				rc);
+			latched_rc = rc;
+		}
+	}
+
+	return latched_rc;
+}
+
 static void cxlr_dax_unregister(void *_cxlr_dax)
 {
 	struct cxl_dax_region *cxlr_dax = _cxlr_dax;
@@ -3231,6 +3251,11 @@ static int devm_cxl_add_dax_region(struct cxl_region *cxlr)
 	dev_dbg(&cxlr->dev, "%s: register %s\n", dev_name(dev->parent),
 		dev_name(dev));
 
+	if (cxlr->mode == CXL_PARTMODE_DYNAMIC_RAM_A)
+		if (cxlr_add_existing_extents(cxlr))
+			dev_err(&cxlr->dev, "Existing extent processing failed %d\n",
+				rc);
+
 	return devm_add_action_or_reset(&cxlr->dev, cxlr_dax_unregister,
 					cxlr_dax);
 err:
diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index 63a38e449454..f80f70549c0b 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -600,6 +600,27 @@ struct cxl_mbox_dc_response {
 	} __packed extent_list[];
 } __packed;
 
+/*
+ * Get Dynamic Capacity Extent List; Input Payload
+ * CXL rev 3.1 section 8.2.9.9.9.2; Table 8-166
+ */
+struct cxl_mbox_get_extent_in {
+	__le32 extent_cnt;
+	__le32 start_extent_index;
+} __packed;
+
+/*
+ * Get Dynamic Capacity Extent List; Output Payload
+ * CXL rev 3.1 section 8.2.9.9.9.2; Table 8-167
+ */
+struct cxl_mbox_get_extent_out {
+	__le32 returned_extent_count;
+	__le32 total_extent_count;
+	__le32 generation_num;
+	u8 rsvd[4];
+	struct cxl_extent extent[];
+} __packed;
+
 struct cxl_mbox_get_supported_logs {
 	__le16 entries;
 	u8 rsvd[6];

-- 
2.49.0

