Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8001F429C
	for <nvdimm@lists.linux.dev>; Sun, 13 Apr 2025 22:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744584768; cv=fail; b=jXq2ZVs67sBkb2XJzs7zn2uvwRFI722XVc5uw0A8YN72DUWzp4HLR9c+nOKATi19fMC6NMF/CVfa8CznnW7J+aIMT1JOAVNPBNPdp2NuPW2M496nP99aOLpRpiCmQemKS8y2FQnE0CUvFd/B+JtsmEMEGTAy0B0p2inQmXCKVEw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744584768; c=relaxed/simple;
	bh=vCsTE83fdNfeVNuwKX2KWw7xMLNX9HXu9+6894nCXTY=;
	h=From:Date:Subject:Content-Type:Message-ID:References:In-Reply-To:
	 To:CC:MIME-Version; b=JR9XkwWWiwjxuqKMqma50GlE27Uw2oKOwIjIq8k5g+Z89/Y7QsLn32C/WKIJSKnioVj6Z6Urnb4VSX6di2S9BsEaNsuYSKhWL2sCax1zTWS9Fh9n3H9x/9ufId3uOCc6r8wwh6tMxgeMiCzan2v9KPNf3Ax6g0NpMsEM6GJ/jJk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZawyZVti; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZawyZVti"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744584766; x=1776120766;
  h=from:date:subject:content-transfer-encoding:message-id:
   references:in-reply-to:to:cc:mime-version;
  bh=vCsTE83fdNfeVNuwKX2KWw7xMLNX9HXu9+6894nCXTY=;
  b=ZawyZVtiodKRzBMIjz1bpEuqtm5W6PUEpG647YgzwUzBseWvWDUsqYHK
   ONs0o6wlDzKUCQqfjip+KRpEQRg/vM/nKaPwFd3wWQdsi/iLDX4HErrfs
   g3HYC42oCOiGkAaY1qon9xjB90PRo05rQAZD/b5tdDXX5sJyAuwmA9Da2
   RprQe524eB/8vqtvIve8VIP0WzNFEnq7D+0BsoHeGNU5U7G18zagPLEvB
   zZ2AiSilLQkdD3ZjXOzsBM4GjRLkPTRmp3oXMobmJ28j0qK32PxkE1AYw
   6Q9PxOo+gWEWOwhiKvTCE4GX1tI2CPhw/EiyiF2gc05AWnK3y5/BoREIE
   A==;
X-CSE-ConnectionGUID: SL6BZ4YITLmmBR1OqyIpig==
X-CSE-MsgGUID: CQ6Pr88oRimpbrE0/NX9hw==
X-IronPort-AV: E=McAfee;i="6700,10204,11402"; a="71431167"
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="71431167"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2025 15:52:46 -0700
X-CSE-ConnectionGUID: F2G9Je9rTn+w8FxK6WfK1g==
X-CSE-MsgGUID: HBGtTI9aTxeMZWogxlrECw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="134405604"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2025 15:52:46 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Sun, 13 Apr 2025 15:52:45 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sun, 13 Apr 2025 15:52:45 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 13 Apr 2025 15:52:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IC2v5MEbGQ+8ubPCDsFY5wd2vpVQ6A6BwWQSIvOA9EHAa3PMKFD5MvG/IYOm2i7oEhrtaSMCqhHuDL9EuxwAiyI7Aom4cdoNJFxVMAfV+JFbNZPDdiO4UdUtp7pnbM50Zv6AH5xYFRn7szXObGBo1/evFuRKDPYsqJVjOQMnWuDXkETwVsdQ6Sm5PwBpfkET2MY9rfyluyhQaF9fde2/gEhO3KTMt4u1/8IvK9pHnM479/ytyIe7wTbPqWgBfmelaNmm0auXt8EhhVEVivV1xt7mDWLg2jY5xfK5dRpNrkL0ZpoOocvq/4KT7WW66LoC6iG9TUcshIEAwBzCiMKhig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eOKhk80tXgP6EzR0094AIo7xPG4XqMMt8BhS/YWgFlo=;
 b=SJsKqJ4ccay4Xhy8/M3JT5nggnTxtiQVGxB3lyuxL2jfu7CJ7TckI2lJOZHWIc5SPa+Fnq+0hdI04RT8mpEwAmcAxCBhYsMo80J+4ZBHr0hq+k03Hl5/RgBMrDwRc5PnWmj3lx5mBKtMeV/gYiTj15XXNN2A8AjhD5MvyOAjSSMYcTyF7l4c9aIl4Akf67QaLenmPqxRJctgob7p9LckkJuusN9umUJIcE92MrSQF3EBfRPoRT8xJxA+Ob3l6Jg3EWVu/b8w0ICZuaCQjJ3jMiEy86zVLDS271n15hclRqI3GVdLFJtdCfJruCxQYMfv+9kdx8iLIrBCgKi3XAdt9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW4PR11MB6739.namprd11.prod.outlook.com (2603:10b6:303:20b::19)
 by PH7PR11MB7003.namprd11.prod.outlook.com (2603:10b6:510:20a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.33; Sun, 13 Apr
 2025 22:52:41 +0000
Received: from MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24]) by MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24%4]) with mapi id 15.20.8606.033; Sun, 13 Apr 2025
 22:52:41 +0000
From: Ira Weiny <ira.weiny@intel.com>
Date: Sun, 13 Apr 2025 17:53:02 -0500
Subject: [ndctl PATCH v5 5/5] cxl/test: Add Dynamic Capacity tests
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20250413-dcd-region2-v5-5-fbd753a2e0e8@intel.com>
References: <20250413-dcd-region2-v5-0-fbd753a2e0e8@intel.com>
In-Reply-To: <20250413-dcd-region2-v5-0-fbd753a2e0e8@intel.com>
To: Alison Schofield <alison.schofield@intel.com>
CC: Vishal Verma <vishal.l.verma@intel.com>, Jonathan Cameron
	<jonathan.cameron@Huawei.com>, Fan Ni <fan.ni@samsung.com>, Sushant1 Kumar
	<sushant1.kumar@intel.com>, Dan Williams <dan.j.williams@intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, Ira Weiny <ira.weiny@intel.com>
X-Mailer: b4 0.15-dev-c25d1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1744584788; l=29343;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=vCsTE83fdNfeVNuwKX2KWw7xMLNX9HXu9+6894nCXTY=;
 b=jDbeHZLOJUkkCjWKhriHP+21cJvAfQpDmP5nx+giMDTc/dgfrr/63aW/mqXrmmQATy2xpneIM
 dZ/pII65z5rDA3N7S74t/os6JqY50HASXQYzu0cVLB3m3gXunkfYScY
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=
X-ClientProxiedBy: MW2PR2101CA0016.namprd21.prod.outlook.com
 (2603:10b6:302:1::29) To MW4PR11MB6739.namprd11.prod.outlook.com
 (2603:10b6:303:20b::19)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB6739:EE_|PH7PR11MB7003:EE_
X-MS-Office365-Filtering-Correlation-Id: e3376a59-4b85-4f7a-4907-08dd7adde586
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VmhBdlRXSmNBWFpndWNPbkRKa3h4NEVRNERNc2g1M29RL1RwRHJKdXRBLzV0?=
 =?utf-8?B?SnJuY2NsNW44em0wU3o0Z3V6eGhNdVQxeHByb2J3a2pCbDNoL3o2NDNqc1RM?=
 =?utf-8?B?dHczamd5Rkg5Y3lOdzhyT1haN040UGd3blNZd2NQenQzQitUdjBQQkhPeUNm?=
 =?utf-8?B?aHNtZk9rdEhRUlVWM3RyMTQxZFZObEdzM3hTdWpWL0tVSzF2NHk1djFNcFJZ?=
 =?utf-8?B?YjVGSHlvckZmY0FBdXFOcENrbkJwSU8vejR1eUV3VnE3bGhnaCtYUW1TZWNZ?=
 =?utf-8?B?QmlvSStvcm0wNCtOSWhxMzVYZXVIUUFNYnBtYlBkYzBFUFFkdzVUczhKVlcy?=
 =?utf-8?B?VFRJNmMxUkZYNnAxZkp4akdQL2lYcCtNcVJrdkZZL1gyT1VRU1k1NzZqVmdW?=
 =?utf-8?B?ZDJSeXpSSlpvRlZVLytMQ1dOcjN6cXh6QlVuR2UrMnpGdXRYSDFkUEJTRUhP?=
 =?utf-8?B?aWt2TWZ6bWpsUzA1RVdxTWpXVkhYekxCWmNPTjU3a1NSaDhCc3RGN0J4ejJq?=
 =?utf-8?B?TFNSYUNmL0tzbUJYc3ZKOTlBV1ArMWVBMHdueDlMTFJLV0ovUTZra2dKbk5E?=
 =?utf-8?B?SVh1bzJoL29CeVdSVFIrSi9kV2pNZ25LTmFaN2x3OE9DZmRYWGsyeXJraS9J?=
 =?utf-8?B?KzRyOFR1NXJQQW9JWkJYNm5WbkRTa3hTOWJFZlpnV3BFUWdzcmNDS2dHSjVH?=
 =?utf-8?B?QjRWSHRVT1FFZnBoNnhsbFBXemFYa3JWT1IxcGxJc1ZxNkZRQ0k2dmtDY1RR?=
 =?utf-8?B?UzcvcVpSUWhOM01Zd0xxWVNQR0RlV2VZQU1taDRyLzV5Uk1LdG4waDNwQUdH?=
 =?utf-8?B?bU5JODk4SHNJV0tmNlNNdEpHcUh1dkVDWFd0SFpHRjlocDIzQ3JDUUhzQUxj?=
 =?utf-8?B?SXliY0dGUEdud0pYWmljS1lZeDJ4c3NDTXdiajFONlZuazFzV2lPYnRDRjR5?=
 =?utf-8?B?c3d0T0RBZ1BDbEpkZFNuY3cxRlR5UTNQdUpIZ0VTTDhrU2Z1OXdDS1pTTVVv?=
 =?utf-8?B?ZDhiK3ltT2FESHVpK3NudkZFQ3BlMnExeUMwTjFDdG1oRVVkd3BUcElvL3Nr?=
 =?utf-8?B?SEE3LzY3anhCT3diWTM5a2huSWlycHRwdE1Zcm1VcXNnSzhXOWYzbWxmZnJG?=
 =?utf-8?B?UFplLzRBZExiL3BiRkF5MjF1MVkxU01OTkJIamJqZUM0VU9YVjJvZk9KTXVy?=
 =?utf-8?B?UEZoa0pTMXkxRFBNRzdaUG1ieEpKTmduKy9NbTlkSEtBN01ncjFLdGsxaUJ5?=
 =?utf-8?B?aGNaQ0VJQWNmWjJPTVIzc2VEQVc3eWg3czJwQk9xYnhQN1FIWTFDS1lSL2RR?=
 =?utf-8?B?TW9EY2NLMHZnTUZGNGRGb2pwY2NLMWtic094Rkt2NDREdjk1Ry85S095MUYv?=
 =?utf-8?B?aEVlSnAwK2lWcWZYU3VRYlFHUlhvdG90V3dXMHRNN3dkcU1xdzVBaVF6bTVR?=
 =?utf-8?B?VDlYeTBSdDZCMVJON2xrTDZGL3M0Rm8vc2RSNWJwK2FISFJPMXhGQmJsNStx?=
 =?utf-8?B?TVF4VGpMUlVSOFZnQVJSWWFRUThSWFVsZTRRL1I1MDk0TkVVZitpYysyR0tm?=
 =?utf-8?B?M3dsdWRuNGczdzRpZ0t4TG5ocGEyZTltdnRQdVpFYWdYVnhHeldXditzS1VX?=
 =?utf-8?B?K0JUK1R1VlJDZlQvU2J1NXpiNHBnMjJndjFPdFBIM3pMSU92WDQ1MVJobVZU?=
 =?utf-8?B?aVhUbDJjUlgxWmNsTEZvTTROQmRGZWs3S3EzSHgzblQrTktncUlmYkpOZktj?=
 =?utf-8?B?dmwvWmRsU2FTUENScHRlUjlwK2VlWjNwSjN6VnhZRHBiNHdPa2VJT25DblBo?=
 =?utf-8?B?RUVPSVhXOS9vMXZGNVVrTVE4TjBKeFhhUTNzWGN1V08wdHVva2RYcTNNWFJu?=
 =?utf-8?B?eWY3TnVVL2JIeTN3aHpLekthU2RQd0d6bE9HTThxUVhKRTd6QjBObmF0M1Ry?=
 =?utf-8?Q?gHeU3OEHcN4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6739.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VnRIWTVERU1JbnpaZnMrRG9VMU5FNXpDYnFMaTYwNk1YcmtHVkdsMWJ5RUtL?=
 =?utf-8?B?aDA0MlZxOVYzcXdZSGlzVHpxb2VSbEd6UktnRHZZY2ljN2hKanprcVRRUjl6?=
 =?utf-8?B?TW1OUnI2ZnhEN3c3SVZOeGo1VitoSzRPdVoxTnNvKzRkYjJFMXc4QncyUkpF?=
 =?utf-8?B?d2dkMkZvT2hpNGNQVlFJK01lRFpJUTY1bVhLbFVkWUVVUUMxdjV4WllEVzZr?=
 =?utf-8?B?N1ZXb244c2tleHBSVW42Z3BTVWt3YUwyZy9IdjIrK3IwSVpaM09DVXB6UXRy?=
 =?utf-8?B?bkU3YmJwSldVMEd2QTRxNlVXMUJqaEE2dG5sWXZYb0QxQlpXdnNVZjFZNWVl?=
 =?utf-8?B?aEJmc2NzamdyWk55TFVYK3d6blZqditLeU9NNlBPaCsxcVphWEF2RXJBTEw5?=
 =?utf-8?B?eFpyeGJKa0IwUzdpYkhPSFV0L3NPRndBMlA2V3J4QUIrazFMWWlmUjd6Vkp0?=
 =?utf-8?B?TWxoUmg4bDRTcmRPZE9kcXdTK0tvdUtjL00yMjFEWHdXbkl6aXpkeGRzek9n?=
 =?utf-8?B?MVVrQkZRMndFekVObno2NmtuZVdEMTRjK2Njbkl4NVMrMUR5TGhwZDJxYkxL?=
 =?utf-8?B?QlJNbk1xNWdzaitkdTFJMGVjMzZjM1pRaERWRFI5b2hSTHZBS2o1WjMvS29u?=
 =?utf-8?B?eW44VVJZamRqQUd3Wi9EMVQzRGhUYU56UVZSUmNkZUU5TVJRdlZ3Vi8yU3Br?=
 =?utf-8?B?b0Z6YzA5Z3RoN0hpSWp2UWhDY0ZzVFZmUGFHNlBnRWxWUmpsSmFqYzNkWHUw?=
 =?utf-8?B?Q0hXdFJGQ0dYR2k0WmVCSG41M094STVSVW56Tjl3ZmljOGUrODZWL0RzLy9u?=
 =?utf-8?B?emcxcGJxc0pLY1NLdWRLUEo3Q3JSSzhpbkMvcUFjdnhoK1FOY2Y5VWUyczJC?=
 =?utf-8?B?OTBhWDR4RUk1QTZENEw3ZnFrVHZnY0RRRDhwQm1JbUg5T3ZBRzlIVVhYRy9F?=
 =?utf-8?B?dzRVcUZsM0FIZFRSNGtRSStmMVZnYkJtTFVYVUJ6bldINlRCTEdFWE43b2E1?=
 =?utf-8?B?MGY1Vnh3UnA1VjhNUWlWc2RTU01ydS9WNXBmSXlNRVVTTWZ3ZTV3cXBXVkhU?=
 =?utf-8?B?NVhiTWRpUytINGlNbE1kU3V1RVE1dmxvam4ydHhqZDVYZTdWU2tvbGQxcDRM?=
 =?utf-8?B?SVpJSnN1SjVobXlOMmNqRnVmMjFuQ1RkVTlhS2o3TzArUmVjaysxT01NQTVH?=
 =?utf-8?B?ZmdncTNicExOUnllWGgxVUpQd2hzL0RIUjl3SzBoRzB2R0c5aUsyNnBGTFRN?=
 =?utf-8?B?amh6Y1NNK2NkRmcyYzkxL1drQTEwcnZad1NVYkVWaVd5clByNnhFaUZOazlK?=
 =?utf-8?B?aEdRVk9zdTNyUXdMWWFGS1NEbnFWZkgyM3Y4QmdDdUJsUC9jVElCNmxqdlc5?=
 =?utf-8?B?Q29jTzlXU1ZzUElCcHJnZmNucTI4a2JEU1lwR1pQZ2pFaS9ib3dtckNXTXln?=
 =?utf-8?B?cGNZbGQ0VGhheGRrK2loN0NmWmtXMllGSmUxdER5WjVuWk1JMGQ1eEhSL3F3?=
 =?utf-8?B?ck9seXhHL0FOVnhKZ2JOQ2lsMFpTdWpwaHFFcDJ3Q2o0WHNVZHYrR0NWL1N5?=
 =?utf-8?B?UEQ1YnlLMHVOaDM2SGFjTWV5SlViWFJFN2JNTFRjNmlMUmpmVXBkYVV2UTdo?=
 =?utf-8?B?VXhxSWZGSHJHb1hKcDFsSFc3c3NCVG5MM2lFT0Zvcit5NnpHRFNSRU5GRDdj?=
 =?utf-8?B?dDAxQkhCNGpVcFFNTjU2YVRRNGFBMk9hSTBYbmZKcTloZ0tjWWhZcnFITzQ4?=
 =?utf-8?B?enB2OHpuQTR2emJBWWsvaVRMRlJTN3crNU4velJoOWN6WG42cEltdDZPdmpW?=
 =?utf-8?B?cXk1Q09ZU2F2RmJFazR3VWFLejV4cnltM3FDT1FEUkJaN0tPT1ZaeFcxKzdr?=
 =?utf-8?B?Mmt4Q0dKb0JzMVpBWGJxSC9SNloyUDRnbmVveEc4bjFqVXRsTlBjRGMrS1NH?=
 =?utf-8?B?OTFOVjBuYlA2MHdTMmpiWXBPbmRpS0YwZ0p4ZzZyWU5nYkw4UkZibERpdEJv?=
 =?utf-8?B?U2s0R1VNZzlJOW5maHBhSGhMampxS1VwT0tkV1VLMEFZaDJuaUNYVHBIVGkw?=
 =?utf-8?B?N2p4YmZiTUpxOXpLd1BpK2JoVld4T2ltRFJvWWFodktEK0hJdVJmVTQvaHhz?=
 =?utf-8?Q?VZKO/JkAjoyo7XKKm/2S/9A5j?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e3376a59-4b85-4f7a-4907-08dd7adde586
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6739.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2025 22:52:41.5482
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4UjiXWa32eojzNvKpTuRG1adQY59z1PTgUaFvSMopSNg3cMf/jsGVYunjDZWHLEALZfGvDhqcDVvB0tS9d5k/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7003
X-OriginatorOrg: intel.com

cxl_test provides a good way to ensure quick smoke and regression
testing.  The complexity of DCD and the new sparse DAX regions required
to use them benefits greatly with a series of smoke tests.

The only part of the kernel stack which must be bypassed is the actual
irq of DCD events.  However, the event processing itself can be tested
via cxl_test calling directly into the event processing.

In this way the rest of the stack; management of sparse regions, the
extent device lifetimes, and the dax device operations can be tested.

Add Dynamic Capacity Device tests for kernels which have DCD support.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes:
[iweiny: Fix checks for dax devices]
[iweiny: Fix documentation on tests]
[iweiny: remove second DCD partition testing; use only dynamic_ram_a]
---
 test/cxl-dcd.sh  | 863 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 test/meson.build |   2 +
 2 files changed, 865 insertions(+)

diff --git a/test/cxl-dcd.sh b/test/cxl-dcd.sh
new file mode 100644
index 000000000000..c83d5e4f172a
--- /dev/null
+++ b/test/cxl-dcd.sh
@@ -0,0 +1,863 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2024 Intel Corporation. All rights reserved.
+
+. "$(dirname "$0")/common"
+
+rc=77
+set -ex
+
+trap 'err $LINENO' ERR
+
+check_prereq "jq"
+
+rc=1
+
+dev_path="/sys/bus/platform/devices"
+cxl_path="/sys/bus/cxl/devices"
+
+# a test extent tag
+test_tag=dc-test-tag
+
+#
+# The test devices have 2G of non DC capacity.  A single DC reagion of 1G is
+# added beyond that.
+#
+# The testing centers around 3 extents.  Two are "pre-existing" on test load
+# called pre-ext and pre2-ext.  The other is created within this script alone
+# called base.
+
+#
+# | 2G non- |      DC region (1G)                                   |
+# |  DC cap |                                                       |
+# |  ...    |-------------------------------------------------------|
+# |         |--------|       |----------|      |----------|         |
+# |         | (base) |       |(pre-ext) |      |(pre2-ext)|         |
+
+dra_size=""
+
+base_dpa=0x80000000
+
+# base extent at dpa 2G - 64M long
+base_ext_offset=0x0
+base_ext_dpa=$(($base_dpa + $base_ext_offset))
+base_ext_length=0x4000000
+
+# pre existing extent base + 128M, 64M length
+# 0x00000088000000-0x0000008bffffff
+pre_ext_offset=0x8000000
+pre_ext_dpa=$(($base_dpa + $pre_ext_offset))
+pre_ext_length=0x4000000
+
+# pre2 existing extent base + 256M, 64M length
+# 0x00000090000000-0x00000093ffffff
+pre2_ext_offset=0x10000000
+pre2_ext_dpa=$(($base_dpa + $pre2_ext_offset))
+pre2_ext_length=0x4000000
+
+mem=""
+bus=""
+device=""
+decoder=""
+
+# ========================================================================
+# Support functions
+# ========================================================================
+
+create_dcd_region()
+{
+	mem="$1"
+	decoder="$2"
+	reg_size_string=""
+	if [ "$3" != "" ]; then
+		reg_size_string="-s $3"
+	fi
+
+	# create region
+	rc=$($CXL create-region -t dynamic_ram_a -d "$decoder" -m "$mem" ${reg_size_string} | jq -r ".region")
+
+	if [[ ! $rc ]]; then
+		echo "create-region failed for $decoder / $mem"
+		err "$LINENO"
+	fi
+
+	echo ${rc}
+}
+
+check_region()
+{
+	search=$1
+	region_size=$2
+
+	result=$($CXL list -r "$search" | jq -r ".[].region")
+	if [ "$result" != "$search" ]; then
+		echo "check region failed to find $search"
+		err "$LINENO"
+	fi
+
+	result=$($CXL list -r "$search" | jq -r ".[].size")
+	if [ "$result" != "$region_size" ]; then
+		echo "check region failed invalid size $result != $region_size"
+		err "$LINENO"
+	fi
+}
+
+check_not_region()
+{
+	search=$1
+
+	result=$($CXL list -r "$search" | jq -r ".[].region")
+	if [ "$result" == "$search" ]; then
+		echo "check not region failed; $search found"
+		err "$LINENO"
+	fi
+}
+
+destroy_region()
+{
+	local region=$1
+	$CXL disable-region $region
+	$CXL destroy-region $region
+}
+
+inject_extent()
+{
+	device="$1"
+	dpa="$2"
+	length="$3"
+	tag="$4"
+
+	more="0"
+	if [ "$5" != "" ]; then
+		more="1"
+	fi
+
+	echo ${dpa}:${length}:${tag}:${more} > "${dev_path}/${device}/dc_inject_extent"
+}
+
+remove_extent()
+{
+	device="$1"
+	dpa="$2"
+	length="$3"
+
+	echo ${dpa}:${length} > "${dev_path}/${device}/dc_del_extent"
+}
+
+create_dax_dev()
+{
+	reg="$1"
+
+	dax_dev=$($DAXCTL create-device -r $reg | jq -er '.[].chardev')
+
+	echo ${dax_dev}
+}
+
+fail_create_dax_dev()
+{
+	reg="$1"
+
+	set +e
+	result=$($DAXCTL create-device -r $reg)
+	set -e
+	if [ "$result" == "0" ]; then
+		echo "FAIL device created"
+		err "$LINENO"
+	fi
+}
+
+shrink_dax_dev()
+{
+	dev="$1"
+	new_size="$2"
+
+	$DAXCTL disable-device $dev
+	$DAXCTL reconfigure-device $dev -s $new_size
+	$DAXCTL enable-device $dev
+}
+
+destroy_dax_dev()
+{
+	dev="$1"
+
+	$DAXCTL disable-device $dev
+	$DAXCTL destroy-device $dev
+}
+
+check_dax_dev()
+{
+	search="$1"
+	size=$(($2))
+
+	result=$($DAXCTL list -d $search | jq -er '.[].chardev')
+	if [ "$result" != "$search" ]; then
+		echo "check dax device failed to find $search"
+		err "$LINENO"
+	fi
+	result=$($DAXCTL list -d $search | jq -er '.[].size')
+	if [ "$result" -ne "$size" ]; then
+		echo "check dax device failed incorrect size $result; exp $size"
+		err "$LINENO"
+	fi
+}
+
+# check that the dax device is not there.
+check_not_dax_dev()
+{
+	reg="$1"
+	search="$2"
+	result=$($DAXCTL list -r $reg -D | jq -r '.[].chardev')
+	if [ "$result" == "$search" ]; then
+		echo "FAIL found $search"
+		err "$LINENO"
+	fi
+}
+
+check_extent()
+{
+	region=$1
+	offset=$(($2))
+	length=$(($3))
+
+	result=$($CXL list -r "$region" -N | jq -r ".[].extents[] | select(.offset == ${offset}) | .length")
+	if [[ $result != $length ]]; then
+		echo "FAIL region $1 could not find extent @ $offset ($length)"
+		err "$LINENO"
+	fi
+}
+
+check_extent_cnt()
+{
+	region=$1
+	count=$(($2))
+
+	result=$($CXL list -r $region -N | jq -r '.[].extents[].offset' | wc -l)
+	if [[ $result != $count ]]; then
+		echo "FAIL region $1: found wrong number of extents $result; expect $count"
+		err "$LINENO"
+	fi
+}
+
+
+# ========================================================================
+# Tests
+# ========================================================================
+
+# testing pre existing extents must be called first as the extents were created
+# by cxl-test being loaded
+test_pre_existing_extents()
+{
+	echo ""
+	echo "Test: pre-existing extent"
+	echo ""
+	region=$(create_dcd_region ${mem} ${decoder})
+
+	# | 2G non- |      DC region                                        |
+	# |  DC cap |                                                       |
+	# |  ...    |-------------------------------------------------------|
+	# |         |                   |----------|         |----------|   |
+	# |         |                   |(pre-ext) |         |(pre2-ext)|   |
+	check_region ${region} ${dra_size}
+	# should contain pre-created extents
+	check_extent ${region} ${pre_ext_offset} ${pre_ext_length}
+	check_extent ${region} ${pre2_ext_offset} ${pre2_ext_length}
+
+	dax_dev=$(create_dax_dev ${region})
+	ext_sum_length="$(($pre_ext_length + $pre2_ext_length))"
+	check_dax_dev ${dax_dev} $ext_sum_length
+	destroy_dax_dev ${dax_dev}
+
+	remove_extent ${device} $pre_ext_dpa $pre_ext_length
+	# |         |                                        |----------|   |
+	# |         |                                        |(pre2-ext)|   |
+	remove_extent ${device} $pre2_ext_dpa $pre2_ext_length
+	# |         |                                                       |
+	# |         |                                                       |
+	check_extent_cnt ${region} 0
+	destroy_region ${region}
+	check_not_region ${region}
+}
+
+test_remove_extent_under_dax_device()
+{
+	# Remove the pre-created test extent out from under dax device
+	# stack should hold ref until dax device deleted
+	echo ""
+	echo "Test: Remove extent from under DAX dev"
+	echo ""
+
+	region=$(create_dcd_region ${mem} ${decoder})
+	check_region ${region} ${dra_size}
+	# | 2G non- |      DC region                                        |
+	# |  DC cap |                                                       |
+	# |  ...    |-------------------------------------------------------|
+	# |         |                                                       |
+	# |         |                                                       |
+
+	
+	inject_extent ${device} $pre_ext_dpa $pre_ext_length ""
+	# |         |                   |----------|                        |
+	# |         |                   |(pre-ext) |                        |
+	check_extent ${region} ${pre_ext_offset} ${pre_ext_length}
+
+	dax_dev=$(create_dax_dev ${region})
+	# |         |                   |----------|                        |
+	# |         |                   |(pre-ext) |                        |
+	# |         |                   | daxX.1   |                        |
+	check_extent_cnt ${region} 1
+	remove_extent ${device} $pre_ext_dpa $pre_ext_length
+	# In-use extents are not released.
+	check_dax_dev ${dax_dev} $pre_ext_length
+
+	check_extent_cnt ${region} 1
+	destroy_dax_dev ${dax_dev}
+	# |         |                   |----------|                        |
+	# |         |                   |(pre-ext) |                        |
+	check_not_dax_dev ${region} ${dax_dev}
+
+	check_extent_cnt ${region} 1
+	# Remove after use
+	remove_extent ${device} $pre_ext_dpa $pre_ext_length
+	# |         |                                                       |
+	# |         |                                                       |
+	check_extent_cnt ${region} 0
+	destroy_region ${region}
+	check_not_region ${region}
+}
+
+test_remove_extents_in_use()
+{
+	echo ""
+	echo "Test: Remove extents under sparse dax device"
+	echo ""
+	remove_extent ${device} $base_ext_dpa $base_ext_length
+	check_extent_cnt ${region} 2
+	remove_extent ${device} $pre_ext_dpa $pre_ext_length
+	check_extent_cnt ${region} 2
+}
+
+test_create_dax_dev_spanning_two_extents()
+{
+	echo ""
+	echo "Test: Create dax device spanning 2 extents"
+	echo ""
+
+	region=$(create_dcd_region ${mem} ${decoder})
+	check_region ${region} ${dra_size}
+	# | 2G non- |      DC region                                        |
+	# |  DC cap |                                                       |
+	# |  ...    |-------------------------------------------------------|
+	inject_extent ${device} $pre_ext_dpa $pre_ext_length ""
+	check_extent ${region} ${pre_ext_offset} ${pre_ext_length}
+	# |         |                   |----------|                        |
+	# |         |                   |(pre-ext) |                        |
+	inject_extent ${device} $base_ext_dpa $base_ext_length ""
+	check_extent ${region} ${base_ext_offset} ${base_ext_length}
+	# |         |--------|          |----------|                        |
+	# |         | (base) |          |(pre-ext) |                        |
+
+	check_extent_cnt ${region} 2
+	dax_dev=$(create_dax_dev ${region})
+	# |         |--------|          |----------|                        |
+	# |         | (base) |          |(pre-ext) |                        |
+	# |         | daxX.1 |          | daxX.1   |                        |
+
+	echo "Checking if dev dax is spanning sparse extents"
+	ext_sum_length="$(($base_ext_length + $pre_ext_length))"
+	check_dax_dev ${dax_dev} $ext_sum_length
+
+	test_remove_extents_in_use
+
+	destroy_dax_dev ${dax_dev}
+	check_not_dax_dev ${region} ${dax_dev}
+
+	# In-use extents were not released.  Check they can be removed after the
+	# dax device is removed.
+	check_extent_cnt ${region} 2
+	remove_extent ${device} $base_ext_dpa $base_ext_length
+	remove_extent ${device} $pre_ext_dpa $pre_ext_length
+	check_extent_cnt ${region} 0
+	destroy_region ${region}
+	check_not_region ${region}
+}
+
+test_inject_tag_support()
+{
+	echo ""
+	echo "Test: inject without/with tag"
+	echo ""
+
+	region=$(create_dcd_region ${mem} ${decoder})
+	check_region ${region} ${dra_size}
+
+	inject_extent ${device} $pre_ext_dpa $pre_ext_length ""
+	check_extent ${region} ${pre_ext_offset} ${pre_ext_length}
+	inject_extent ${device} $base_ext_dpa $base_ext_length "ira"
+
+	# extent with tag should be rejected
+	check_extent_cnt ${region} 1
+	remove_extent ${device} $pre_ext_dpa $pre_ext_length
+	check_extent_cnt ${region} 0
+
+	destroy_region ${region}
+	check_not_region ${region}
+}
+
+test_partial_extent_remove ()
+{
+	echo ""
+	echo "Test: partial extent remove"
+	echo ""
+
+	region=$(create_dcd_region ${mem} ${decoder})
+	check_region ${region} ${dra_size}
+
+	# | 2G non- |      DC region                                        |
+	# |  DC cap |                                                       |
+	# |  ...    |-------------------------------------------------------|
+
+	inject_extent ${device} $base_ext_dpa $base_ext_length ""
+	# |  ...    |-------------------------------------------------------|
+	# |         |--------|                                              |
+	# |         | (base) |                                              |
+
+	dax_dev=$(create_dax_dev ${region})
+
+	# |  ...    |-------------------------------------------------------|
+	# |         |--------|                                              |
+	# |         | (base) |                                              |
+	# |         | daxX.1 |                                              |
+
+	partial_ext_dpa="$(($base_ext_dpa + ($base_ext_length / 2)))"
+	partial_ext_length="$(($base_ext_length / 2))"
+	echo "Removing Partial : $partial_ext_dpa $partial_ext_length"
+
+	# |         |    |---|                                              |
+	#                  Partial
+
+	remove_extent ${device} $partial_ext_dpa $partial_ext_length
+	# In-use extents are not released.
+	check_extent_cnt ${region} 1
+
+	# |  ...    |-------------------------------------------------------|
+	# |         |--------|                                              |
+	# |         | (base) |                                              |
+	# |         | daxX.1 |                                              |
+
+	destroy_dax_dev ${dax_dev}
+	check_not_dax_dev ${region} ${dax_dev}
+
+	# |  ...    |-------------------------------------------------------|
+	# |         |--------|                                              |
+	# |         | (base) |                                              |
+
+	# Partial results in whole extent removal
+	check_extent_cnt ${region} 1
+	remove_extent ${device} $partial_ext_dpa $partial_ext_length
+	# |         |    |---|                                              |
+	#                  Partial
+	check_extent_cnt ${region} 0
+
+	# |  ...    |-------------------------------------------------------|
+	destroy_region ${region}
+	check_not_region ${region}
+}
+
+test_multiple_extent_remove ()
+{
+	# Test multiple extent remove
+	echo ""
+	echo "Test: multiple extent remove with single extent remove command"
+	echo ""
+
+	region=$(create_dcd_region ${mem} ${decoder})
+	check_region ${region} ${dra_size}
+
+	# | 2G non- |      DC region                                        |
+	# |  DC cap |                                                       |
+	# |  ...    |-------------------------------------------------------|
+
+	inject_extent ${device} $pre_ext_dpa $pre_ext_length ""
+	inject_extent ${device} $base_ext_dpa $base_ext_length ""
+	# |  ...    |-------------------------------------------------------|
+	# |         |--------|          |-------------------|               |
+	# |         | (base) |          | (pre)-existing    |               |
+
+	check_extent_cnt ${region} 2
+	dax_dev=$(create_dax_dev ${region})
+
+	# |  ...    |-------------------------------------------------------|
+	# |         |--------|          |-------------------|               |
+	# |         | (base) |          | (pre)-existing    |               |
+	# |         | daxX.1 |          | daxX.1            |               |
+
+	partial_ext_dpa="$(($base_ext_dpa + ($base_ext_length / 2)))"
+	partial_ext_length="$(($pre_ext_dpa - $base_ext_dpa))"
+	echo "Removing multiple in span : $partial_ext_dpa $partial_ext_length"
+	#                |------------------|
+	#                  Partial
+	remove_extent ${device} $partial_ext_dpa $partial_ext_length
+
+	# |  ...    |-------------------------------------------------------|
+	# |         |--------|          |-------------------|               |
+	# |         | (base) |          | (pre)-existing    |               |
+	# |         | daxX.1 |          | daxX.1            |               |
+
+	# In-use extents are not released.
+	check_extent_cnt ${region} 2
+
+	destroy_dax_dev ${dax_dev}
+	check_not_dax_dev ${region} ${dax_dev}
+
+	# |  ...    |-------------------------------------------------------|
+	# |         |--------|          |-------------------|               |
+	# |         | (base) |          | (pre)-existing    |               |
+
+	# Remove both extents
+	check_extent_cnt ${region} 2
+	#                |------------------|
+	#                  Partial
+	remove_extent ${device} $partial_ext_dpa $partial_ext_length
+	# |  ...    |-------------------------------------------------------|
+	check_extent_cnt ${region} 0
+
+	destroy_region ${region}
+	check_not_region ${region}
+}
+
+test_destroy_region_without_extent_removal ()
+{
+	echo ""
+	echo "Test: Destroy region without extent removal"
+	echo ""
+	
+	region=$(create_dcd_region ${mem} ${decoder})
+	check_region ${region} ${dra_size}
+	inject_extent ${device} $pre_ext_dpa $pre_ext_length ""
+	inject_extent ${device} $base_ext_dpa $base_ext_length ""
+	check_extent_cnt ${region} 2
+	destroy_region ${region}
+	check_not_region ${region}
+}
+
+test_destroy_with_extent_and_dax ()
+{
+	echo ""
+	echo "Test: Destroy region with extents and dax devices"
+	echo ""
+	region=$(create_dcd_region ${mem} ${decoder})
+	check_region ${region} ${dra_size}
+	check_extent_cnt ${region} 0
+	inject_extent ${device} $pre_ext_dpa $pre_ext_length ""
+	
+	# | 2G non- |      DC region                                        |
+	# |  DC cap |                                                       |
+	# |  ...    |-------------------------------------------------------|
+	# |         |                   |----------|                        |
+	# |         |                   |(pre-ext) |                        |
+
+	check_extent_cnt ${region} 1
+	dax_dev=$(create_dax_dev ${region})
+	# |         |                   |<dax_dev> |                        |
+	check_dax_dev ${dax_dev} ${pre_ext_length}
+	destroy_region ${region}
+	check_not_region ${region}
+
+	# | 2G non- |      DC region                                        |
+	# |  DC cap |                                                       |
+	# |  ...    |-------------------------------------------------------|
+	# |         |                                                       |
+
+	region=$(create_dcd_region ${mem} ${decoder})
+	check_region ${region} ${dra_size}
+	check_extent_cnt ${region} 0
+	destroy_region ${region}
+	check_not_region ${region}
+}
+
+test_dax_device_ops ()
+{
+	echo ""
+	echo "Test: Fail sparse dax dev creation without space"
+	echo ""
+	region=$(create_dcd_region ${mem} ${decoder})
+	check_region ${region} ${dra_size}
+	inject_extent ${device} $pre_ext_dpa $pre_ext_length ""
+
+	# | 2G non- |      DC region                                        |
+	# |  DC cap |                                                       |
+	# |  ...    |-------------------------------------------------------|
+	# |         |                   |-------------------|               |
+	# |         |                   | (pre)-existing    |               |
+
+	check_extent_cnt ${region} 1
+
+	# |         |                   | daxX.1            |               |
+
+	dax_dev=$(create_dax_dev ${region})
+	check_dax_dev ${dax_dev} $pre_ext_length
+	fail_create_dax_dev ${region}
+
+	echo ""
+	echo "Test: Resize sparse dax device"
+	echo ""
+
+	# Shrink
+	# |         |                   | daxX.1  |                         |
+	resize_ext_length=$(($pre_ext_length / 2))
+	shrink_dax_dev ${dax_dev} $resize_ext_length
+	check_dax_dev ${dax_dev} $resize_ext_length
+
+	# Fill
+	# |         |                   | daxX.1  | daxX.2  |               |
+	dax_dev=$(create_dax_dev ${region})
+	check_dax_dev ${dax_dev} $resize_ext_length
+	destroy_region ${region}
+	check_not_region ${region}
+
+
+	# 2 extent
+	# create dax dev
+	# resize into 1st extent
+	# create dev on rest of 1st and all of second
+	# Ensure both devices are correct
+
+	echo ""
+	echo "Test: Resize sparse dax device across extents"
+	echo ""
+	region=$(create_dcd_region ${mem} ${decoder})
+	check_region ${region} ${dra_size}
+	inject_extent ${device} $pre_ext_dpa $pre_ext_length ""
+	inject_extent ${device} $base_ext_dpa $base_ext_length ""
+
+	# | 2G non- |      DC region                                        |
+	# |  DC cap |                                                       |
+	# |  ...    |-------------------------------------------------------|
+	# |         |--------|          |-------------------|               |
+	# |         | (base) |          | (pre)-existing    |               |
+
+	check_extent_cnt ${region} 2
+	dax_dev=$(create_dax_dev ${region})
+	ext_sum_length="$(($base_ext_length + $pre_ext_length))"
+
+	# |         | daxX.1 |          |  daxX.1           |               |
+
+	check_dax_dev ${dax_dev} $ext_sum_length
+	resize_ext_length=33554432 # 32MB
+
+	# |         | D1 |                                                  |
+
+	shrink_dax_dev ${dax_dev} $resize_ext_length
+	check_dax_dev ${dax_dev} $resize_ext_length
+
+	# |         | D1 | D2|          | daxX.2            |               |
+
+	dax_dev=$(create_dax_dev ${region})
+	remainder_length=$((ext_sum_length - $resize_ext_length))
+	check_dax_dev ${dax_dev} $remainder_length
+
+	# |         | D1 | D2|          | daxX.2 |                          |
+
+	remainder_length=$((remainder_length / 2))
+	shrink_dax_dev ${dax_dev} $remainder_length
+	check_dax_dev ${dax_dev} $remainder_length
+
+	# |         | D1 | D2|          | daxX.2 |  daxX.3  |               |
+
+	dax_dev=$(create_dax_dev ${region})
+	check_dax_dev ${dax_dev} $remainder_length
+	destroy_region ${region}
+	check_not_region ${region}
+}
+
+test_reject_overlapping ()
+{
+	echo ""
+	echo "Test: Rejecting overlapping extents"
+	echo ""
+
+	region=$(create_dcd_region ${mem} ${decoder})
+	check_region ${region} ${dra_size}
+	inject_extent ${device} $pre_ext_dpa $pre_ext_length ""
+
+	# | 2G non- |      DC region                                        |
+	# |  DC cap |                                                       |
+	# |  ...    |-------------------------------------------------------|
+	# |         |                   |-------------------|               |
+	# |         |                   | (pre)-existing    |               |
+	
+	check_extent_cnt ${region} 1
+
+	# Attempt overlapping extent
+	#
+	# |         |          |-----------------|                          |
+	# |         |          | overlapping     |                          |
+
+	partial_ext_dpa="$(($base_ext_dpa + ($pre_ext_dpa / 2)))"
+	partial_ext_length=$pre_ext_length
+	inject_extent ${device} $partial_ext_dpa $partial_ext_length ""
+
+	# Should only see the original ext
+	check_extent_cnt ${region} 1
+	destroy_region ${region}
+	check_not_region ${region}
+}
+
+test_two_regions()
+{
+	echo ""
+	echo "Test: create 2 regions in the same DC partition"
+	echo ""
+	region_size=$(($dra_size / 2))
+	region=$(create_dcd_region ${mem} ${decoder} ${region_size})
+	check_region ${region} ${region_size}
+	
+	region_two=$(create_dcd_region ${mem} ${decoder} ${region_size})
+	check_region ${region_two} ${region_size}
+	
+	destroy_region ${region_two}
+	check_not_region ${region_two}
+	destroy_region ${region}
+	check_not_region ${region}
+}
+
+test_more_bit()
+{
+	echo ""
+	echo "Test: More bit"
+	echo ""
+	region=$(create_dcd_region ${mem} ${decoder})
+	check_region ${region} ${dra_size}
+	inject_extent ${device} $pre_ext_dpa $pre_ext_length "" 1
+	# More bit should hold off surfacing extent until the more bit is 0
+	check_extent_cnt ${region} 0
+	inject_extent ${device} $base_ext_dpa $base_ext_length ""
+	check_extent_cnt ${region} 2
+	destroy_region ${region}
+	check_not_region ${region}
+}
+
+test_driver_tear_down()
+{
+	echo ""
+	echo "Test: driver remove tear down"
+	echo ""
+	region=$(create_dcd_region ${mem} ${decoder})
+	check_region ${region} ${dra_size}
+	inject_extent ${device} $pre_ext_dpa $pre_ext_length ""
+	check_extent ${region} ${pre_ext_offset} ${pre_ext_length}
+	dax_dev=$(create_dax_dev ${region})
+	# remove driver releases extents
+	modprobe -r dax_cxl
+	check_extent_cnt ${region} 0
+}
+
+test_driver_bring_up()
+{
+	# leave region up, driver removed.
+	echo ""
+	echo "Test: no driver inject ok"
+	echo ""
+	check_region ${region} ${dra_size}
+	inject_extent ${device} $pre_ext_dpa $pre_ext_length ""
+	check_extent_cnt ${region} 1
+
+	modprobe dax_cxl
+	check_extent_cnt ${region} 1
+
+	destroy_region ${region}
+	check_not_region ${region}
+}
+
+test_driver_reload()
+{
+	test_driver_tear_down
+	test_driver_bring_up
+}
+
+test_event_reporting()
+{
+	# Test event reporting
+	# results expected
+	num_dcd_events_expected=2
+
+	echo "Test: Prep event trace"
+	echo "" > /sys/kernel/tracing/trace
+	echo 1 > /sys/kernel/tracing/events/cxl/enable
+	echo 1 > /sys/kernel/tracing/tracing_on
+
+	inject_extent ${device} $base_ext_dpa $base_ext_length ""
+	remove_extent ${device} $base_ext_dpa $base_ext_length
+
+	echo 0 > /sys/kernel/tracing/tracing_on
+
+	echo "Test: Events seen"
+	trace_out=$(cat /sys/kernel/tracing/trace)
+
+	# Look for DCD events
+	num_dcd_events=$(grep -c "cxl_dynamic_capacity" <<< "${trace_out}")
+	echo "     LOG     (Expected) : (Found)"
+	echo "     DCD events    ($num_dcd_events_expected) : $num_dcd_events"
+
+	if [ "$num_dcd_events" -ne $num_dcd_events_expected ]; then
+		err "$LINENO"
+	fi
+}
+
+
+# ========================================================================
+# main()
+# ========================================================================
+
+modprobe -r cxl_test
+modprobe cxl_test
+
+readarray -t memdevs < <("$CXL" list -b cxl_test -Mi | jq -r '.[].memdev')
+
+for mem in ${memdevs[@]}; do
+	dra_size=$($CXL list -m $mem | jq -r '.[].dynamic_ram_a_size')
+	if [ "$dra_size" == "null" ]; then
+		continue
+	fi
+	decoder=$($CXL list -b cxl_test -D -d root -m "$mem" |
+		  jq -r ".[] |
+		  select(.volatile_capable == true) |
+		  select(.nr_targets == 1) |
+		  select(.max_available_extent >= ${dra_size}) |
+		  .decoder")
+	if [[ $decoder ]]; then
+		bus=`"$CXL" list -b cxl_test -m ${mem} | jq -r '.[].bus'`
+		device=$($CXL list -m $mem | jq -r '.[].host')
+		break
+	fi
+done
+
+echo "TEST: DCD test device bus:${bus} decoder:${decoder} mem:${mem} device:${device} size:${dra_size}"
+
+if [ "$decoder" == "" ] || [ "$device" == "" ] || [ "$dra_size" == "" ]; then
+	echo "No mem device/decoder found with DCD support"
+	exit 77
+fi
+
+# testing pre existing extents must be called first as the extents were created
+# by cxl-test being loaded
+test_pre_existing_extents
+test_remove_extent_under_dax_device
+test_create_dax_dev_spanning_two_extents
+test_inject_tag_support
+test_partial_extent_remove
+test_multiple_extent_remove
+test_destroy_region_without_extent_removal
+test_destroy_with_extent_and_dax
+test_dax_device_ops
+test_reject_overlapping
+test_two_regions
+test_more_bit
+test_driver_reload
+test_event_reporting
+
+modprobe -r cxl_test
+
+check_dmesg "$LINENO"
+
+exit 0
diff --git a/test/meson.build b/test/meson.build
index 476f4ba6c97c..a2ed28c5eab1 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -195,6 +195,7 @@ cxl_sanitize = find_program('cxl-sanitize.sh')
 cxl_destroy_region = find_program('cxl-destroy-region.sh')
 cxl_qos_class = find_program('cxl-qos-class.sh')
 cxl_poison = find_program('cxl-poison.sh')
+cxl_dcd = find_program('cxl-dcd.sh')
 
 if feat_hdrs_exist
   cxl_features = find_program('cxl-features.sh')
@@ -232,6 +233,7 @@ tests = [
   [ 'cxl-destroy-region.sh',  cxl_destroy_region, 'cxl'   ],
   [ 'cxl-qos-class.sh',       cxl_qos_class,      'cxl'   ],
   [ 'cxl-poison.sh',          cxl_poison,         'cxl'   ],
+  [ 'cxl-dcd.sh',             cxl_dcd,            'cxl'   ],
 ]
 
 if feat_hdrs_exist

-- 
2.49.0

