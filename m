Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68981199230
	for <nvdimm@lists.linux.dev>; Sun, 13 Apr 2025 22:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744584724; cv=fail; b=WhyvYMKmZrNIWeHEksmf7IAYONPAC5WYBfkK/9sLcLCMeFEAifgh1lS+GTH4Df/XTmiVDRwbTGmDuPBDbetXP67ZJYoVp6xDOtuaToCRry1Hru/F7YfmtnokaY/Ldak54SgHxx6t+2fsmTjxxOFCw59xtX7KYAtoB/0fD2bW8UE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744584724; c=relaxed/simple;
	bh=QWIUOdTsybkdMzgUkQnUMwA8ER+kALdCrOEkHqc97M0=;
	h=From:Date:Subject:Content-Type:Message-ID:References:In-Reply-To:
	 To:CC:MIME-Version; b=vGHilzZb0SkPfN48RWdvtPgaerQ70S7BE8NFJz+RPRhwAuk3hDT6v0j+UkoqsuvolXvBcHZ6AFVqvMKV+BwpwKM2rC2XKuec1YR3d/maudVzSEE2b0NlDY+1aME06EgwKSnUFAWxuPTmm5kPsjX87vOkT/M58T1gt7MNL78Fa7c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d15mz+r+; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d15mz+r+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744584723; x=1776120723;
  h=from:date:subject:content-transfer-encoding:message-id:
   references:in-reply-to:to:cc:mime-version;
  bh=QWIUOdTsybkdMzgUkQnUMwA8ER+kALdCrOEkHqc97M0=;
  b=d15mz+r+xUwzBS6sFU3K2pRkPiYzCXrMAU+kyVQPFhAv8pMedSOrq72T
   gN+EKh7UsiJI953JeguqWETuN1dJbNAeGGnDGHgFTmX1Qf2ckICCOf//c
   OCfHapnpZNRB6z6UvPpDCsJYVRea60aQHeo4emglCFKnbOTGAsrnFjnAw
   7W3EYAs4B3C6iuVsqD8aQz9CFj7wWHrCVKfHNliLcYYTKyzXTjW/j7qEf
   bwECXv9dcf7hClXj+2iyN1948UKN8ykpLLzKeT2bPPgfm/Df8lWr5bViM
   ZgDVmyb4z5PCH1jEFUWLkbGB0E0n/PI1zLM0B+b+KClq3CsfyGi/lX9yM
   Q==;
X-CSE-ConnectionGUID: +4DdVGUmQgy4vfaCq277Nw==
X-CSE-MsgGUID: 1Rbobwu6SZ6vcl1l2lPM5A==
X-IronPort-AV: E=McAfee;i="6700,10204,11402"; a="45280896"
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="45280896"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2025 15:52:00 -0700
X-CSE-ConnectionGUID: xV8WZal4TcSenoAGXnnouA==
X-CSE-MsgGUID: jwunai7NSvWhWqVLmlkJkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="129657436"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2025 15:52:00 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Sun, 13 Apr 2025 15:51:59 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sun, 13 Apr 2025 15:51:59 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 13 Apr 2025 15:51:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ULAItf1T2IQmu6+PeAAh3UhxpOXxsZdw2axXLN0AqE+s8w8s6pIKbKLr59xtfcqV/xM4eA2mnsUaws1+wUHUlnZf+GWj4pLwpx9sgRghqFvf7w6haRSsZHgNxcfMt5q8yYNh/IqWuj2TLqUBH8ZsDcLwtR0Ozn3c4NEVmZaFdJMjSYSIbU4qX9/CPwRtVVTiI0IsUSm1tUXXztwFS1WjJo0yeqJfPar3UpSXk8tzqgGPVm/lYRc2Uwfyr4p0qeWKHNy3nll2Bodq6NXsbKfrK+EqyEouLJYZPckgC9fOI3Sqb9RMJXvXtQRN4tSay9myNvByrDZbCZBFQjUcfhYo9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XRCSEVRqzMVLB9sUkTAqkxwHRS2MdCyEZXOrYPgN78Q=;
 b=xetbZdd/lvK62NBnL0hkUa4YP5Wc/4KUUJ2QFfuUY/ggDWIZOJmxDSx0SWnTmMNsYMB2u8X0VcyU5/QMZudp5hLYlIVJ8R4mmbl4IPWWbUsq1T5RmMAk7nvF+Cc73KQnm85VG/tDMupSdngjhrXqOjlZEGTxFIJzb7fnO2Ov4aLJr55xO4pGBZqjLP5g9Jzm+tHI47yMVEwQp8z82YrO/4KCQz1TSu6BKxVtX03+d4SDTzkDnH7KrM8XyxR0mJyPPz2UQ4EEjnIi1eKPmdlfDunpETQOV+rXkeyRyHPuEpQsR3UXBSfMSSdV+YZCN9HWYzG/o9+8FoaiVJqSaT+wkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW4PR11MB6739.namprd11.prod.outlook.com (2603:10b6:303:20b::19)
 by DM4PR11MB6042.namprd11.prod.outlook.com (2603:10b6:8:61::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.28; Sun, 13 Apr
 2025 22:51:48 +0000
Received: from MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24]) by MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24%4]) with mapi id 15.20.8606.033; Sun, 13 Apr 2025
 22:51:48 +0000
From: Ira Weiny <ira.weiny@intel.com>
Date: Sun, 13 Apr 2025 17:52:12 -0500
Subject: [PATCH v9 04/19] cxl/core: Enforce partition order/simplify
 partition calls
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20250413-dcd-type2-upstream-v9-4-1d4911a0b365@intel.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1744584735; l=6891;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=QWIUOdTsybkdMzgUkQnUMwA8ER+kALdCrOEkHqc97M0=;
 b=3xtF7gtSQBOSRiRuM4Pmou0rdAEf9ybrI8OOhE/D44AoGI4QrLYY9hv+/tlyPnGPaZITIvnzy
 zsQIqH6chMFDryjPBTBQ3WeHnzsUBEQiETeCCbhnYaVncOZgFSxDbQd
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
X-MS-Office365-Filtering-Correlation-Id: cde2e068-9156-4a3a-6ff7-08dd7addc611
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Z3RsbGg4TERVNFh3QlNQYWdJMUFpa2w4WXdrM0RiQXhyVm5EWTNmMklBMmJF?=
 =?utf-8?B?UThLVmJKL1c4RTZUMUJYL2FiSk01TFFSZUMwQThjMkJRL2tKVmhYTnJyaEFR?=
 =?utf-8?B?VC8vbGRtelhyRW5ZT0VZVkpiNGprM2IyVk8rNW5qRDFXY2gzS2hUYmJPYnM1?=
 =?utf-8?B?Vy9iYnV6NGlyVkQ5b2tFSEZOTHI2V3BPZ3gwcjV1ejl1OXppOWpMNkhvZjZC?=
 =?utf-8?B?Q3NrVllaeXlmUS9qc05WYzVOYWpTUGRFbjlkZmtBUFZQRTlBUVMrVWF3Wndl?=
 =?utf-8?B?MHJNbms5b1R0YmJVeERMM3FSdkNhdzFCZE9kRGNzNDY3MVRsNzliUitibDZ1?=
 =?utf-8?B?aERqNUd1NzhiT3FDai9zWFBMaTFoSzZ4V1pKM1NFaGpTMjk0ZEtSeExXR1Yr?=
 =?utf-8?B?cTAyU01kZ1ZuS2R4emFNdURpNHllc0NocXZwRlFtN1lIa1ZhRlBaeTFXMWVF?=
 =?utf-8?B?SnlBZGY1eVc4T3YxWmwwSjFJUDFSSDBMU2tXL2J4M0pGQVo2d3p2d2xIMFow?=
 =?utf-8?B?RURsbDZ1aDNHKzZ6SGx5SFB5a2tQSnZLam90a2tSZFkzVkxYdXpDZkFBRVMx?=
 =?utf-8?B?SUxNT1hlOTBxZ25sVy93Ky9BQjdlRWdzWU1MSEZ2V1o3TFozZjhIMWRNeVdZ?=
 =?utf-8?B?Wjl6akFHOUJGY0paSU5GekN0YzNGNUJZa3FpY3h3Q1IvMDlsaVF2TUVsZy83?=
 =?utf-8?B?WVFQdG80Ky9YY0JGbnVjVHpkc1d3WDUxQlNDc0hmcVEraGpraUwyN0VWSFkr?=
 =?utf-8?B?TlczR3VOOEU4ZTkxZitmWEhVZmJRc3VFU3JvdEwvNC8zeEhRL0J4Zjg3dnMy?=
 =?utf-8?B?QUtOaFB3Si96ZHF1cC9pZ3E3ejJrUk5uSUNZY1lQNi84bldRTGlKTlBIN3Jr?=
 =?utf-8?B?czVXWFJSZVJYRG51R0toVnlEdjluakVyZWJZM2p0MXNCOFpnRFd3MXJWUHdB?=
 =?utf-8?B?NW9ZVUJycWxpc3prNUtpVzJ0ekJ4SEVhV05SUVRtdGVsS2Fnd3RpZ211TU94?=
 =?utf-8?B?YktDanFvRlNQZW90QUZiV0VJeDdFTFdoSDRyaE1tZnprK1lUaVhQOFpDaDc0?=
 =?utf-8?B?eCtLaGg4czVBQzgzL3hOTmp5WERVeDRrWWpLVGNnT3pvdGlsWDdiUjYrbnBV?=
 =?utf-8?B?bGlPTldIK2pQeEFCYnpVSTl0VFVuSmhIeklOdDVPbXRaVitqNFBaNzQxMlRE?=
 =?utf-8?B?SktkUlNvZm5CNlJqc1VVL1ZXNHJmbnYyOThTanJ5RHNHY0dLSnFLenJOTE1Z?=
 =?utf-8?B?dGVRdTIvNjNSZkVkd2gyR0lJRDh0ZnZZMUZ6b2dlL0w4aE9XMUJtK1NxbVlZ?=
 =?utf-8?B?ZGFIeE5XNXdhNmxjUkxnZlBacTJxcjJvQzBVc0hTYWZwbndzRkxtNWM0MHkr?=
 =?utf-8?B?d1drOWdHSUs4Qnc5UGM2WVVjbEZsa2tKdURybjFVZUd0Y09meEdxZElRb0tq?=
 =?utf-8?B?OWFVUE1YU05rOWE4bW1QWGlDOTBiS2pYM1ZyODVuZitiSER2N3dKNUw4eThL?=
 =?utf-8?B?cnNSODRUQkMzLzdra0VyY25QZlhWK2xrZHVFOHQvcjhldzBRMW9MVUxnYlRF?=
 =?utf-8?B?ci9JeDVHUXQ3T2Jva1JlYUpCbnFhQVJsS0RTdDhjVm9nQnViY3BQUlJaMWxa?=
 =?utf-8?B?eCtwallnUmpBNlNwWjdHQTJaSHJCV2dJNHR3ZytTcDIyVzduUmlKZ1BPZENz?=
 =?utf-8?B?dVQydWNHaWtZWHA3U0Nzdlc2MStXVXBMVlVWUTJtWCs1SmNsVklDSlA1WXJE?=
 =?utf-8?B?TEsyVEtjNnBIcG0vYysyWFZORXNLZzNRMnY3NDZ0Wlc2TmJnUVFEMzZOWVhH?=
 =?utf-8?B?SFZXeE5RdVBBRGtZQkFIdU9OaHNtL2hqVUh0UFhmWGRmQjJCTkxzTWRIUEo5?=
 =?utf-8?B?WXp1em5OTGRTd1p5K29CdmhmK25HV2tJN2c4d21kSG92b2hXQW5QZDlzTlkr?=
 =?utf-8?Q?JEPU82XVzzU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6739.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NzB4VHVkQUFmVmVzTEJTQS9HTjNaRmZqVkN1MWE3Nnlia3JOTzY1Ykh4QW9k?=
 =?utf-8?B?ejlGa05BaDFQaU5zYlEySmhvejFPaXQ4YUVaWnRXRWc0R2JIWVVCN0ptTXlk?=
 =?utf-8?B?SjlRSWE2UVBoLzFXL2EzMHpxUE9HRnpiZmgyY09BK25sLzZxWXZib2xrc21C?=
 =?utf-8?B?c3REL2Jrd3lrd1V4OW5qNFpMRVpDcUVWcG04blBQTmc5MWxKck5QTlJzSWtj?=
 =?utf-8?B?TkUyTGpVZHVteVlxRXhaZHpGOUh3UE9ybno4RFhUMlFwMTdvUEtwRUFlMStD?=
 =?utf-8?B?aXdxK1dzNHFvMFoyUkRMemFBWXFJakQ5WFA3dGlFdHF5OXR6SVprTjJCNk9K?=
 =?utf-8?B?dGgycGhuQ3NBdS8vM2xhb0NrVUhWWU9rS2U5eWhpSUpWcERHT0tuT29jOG9n?=
 =?utf-8?B?Y0dha05yNzBGOWFHTWpYUG5Rb2ZFTEV2amxOa2poNWdqcmI0VHpMYURLNDNC?=
 =?utf-8?B?QzRoa1dlSDZWcTBhOXFUL1EzUnBxZmo1cFVzQzkxRkJMRDB5RzMwZjN5SnFK?=
 =?utf-8?B?UUVTRWg1dEZjOU81Ui9zeGlSem9yVURQbkl3K0N0UG15Y0lCVjdsb0lYSXdL?=
 =?utf-8?B?Z3NHZ3J0NlgzYVhTWHFiSDhhc2ZpWEp5RUVXR09paEgxVlJrUFIvU0RLekh6?=
 =?utf-8?B?VFp3T0hhV1hsbHdZRzkzeFQ1c0wrdEpKeENaMldEQUh6RG5pUnhxSzdlMTJG?=
 =?utf-8?B?Ui9OcXpYaUZNeWNtUzlxQUR0T0FQTXN2K1Y1U1k0Ynd1QXNCcUwwYmlTQ3d4?=
 =?utf-8?B?dmdqOTJ0VTRxMnpWaFVrd0pFSkhrZmhSQjFxdTQyeVJlQkdHdlJwcTRpRGpq?=
 =?utf-8?B?Y2JQWnNaems0S2E0WXFUcWNaSHJDV3RYQzJ2aERqTm5lM1VLbU9JSSsxbGdV?=
 =?utf-8?B?OWhPOU4yKzJQUFFvNitJSDEyZWlaM0VLM0VGZ3Q2cjZJdDVaUkJKYkFKdmZj?=
 =?utf-8?B?MmFXMG1ONmx6akd0NUpoMW8zMUVuTHhvTmltdm9wdEovRy9rMGk5V1JoRVhH?=
 =?utf-8?B?WW9JNXF0MEZPTzg0UVBYdjgyRjVSYm5qVGNhQm1MNmttU3NwOG9aek9Xd3h1?=
 =?utf-8?B?UFBCeVVtd1JmSGtwazFTNHB2czJQTVpsZ0o4KytCUlRuY0MxQVpVQ29oaDZV?=
 =?utf-8?B?QUR4YUZoc2dqMXFoKzBGUUlPdDJ0elNMd2RBOFI3Vkl5L0NMM3JtUFk3NXhu?=
 =?utf-8?B?VnlxajFqT21iN25XQmxLbE1mNHRwZzAwdkJialdSVEZFZkVoTDc0K05hUlZF?=
 =?utf-8?B?VWZncjJla0NrNHlSM1lvMVphZGhuN1ZXVVRmSlJsdzB4U0IzbzlqWjIyT2sr?=
 =?utf-8?B?eWRBTS8vT2M0VVJQejlkRXc3RlUrNXBXNDZ4VFN4bXNlV0lXOFhMd2MrU3ph?=
 =?utf-8?B?bW5leXdkRW5NdWNLNnNhaExXeHpjUDVyYTBFNFFFb3pGeXhMcitMLzB1akhB?=
 =?utf-8?B?Q0xUUmU4YzlqRHMxb1h3eUxNOGhSUzArdkRIc1pxWEZkUk0wVnlnaGxQRWdn?=
 =?utf-8?B?enZzejQyM2t4V2phV2ZyRnluNFk4QVBsVFFpUDUyQURSeEQ4aFdIak9rN3h2?=
 =?utf-8?B?WWl4a0V5TkRaT2g0ZFEyb2xjYWV1RllrMkVBSWxENVg3TThoNHo4dGx1Nzk1?=
 =?utf-8?B?TFdOaGZYa29WcmVnSk5zVkExcVBXUytVVFY2RXFTVnl1VWt0QXMyYS95YVNC?=
 =?utf-8?B?c1kwcVJGVzV1T01rU3VramxUcUVJNTdScENiSjI5bWt5cWc5eUlzY2JNWUpa?=
 =?utf-8?B?ZGlKWUxmdE0yVlhLZEp3ZnpuN1NOcWRaVmJxVDJ5SU5RRE5lNnYrTDU5NXFO?=
 =?utf-8?B?UnpGWjJ1V3NiYm5lV2tzejMwbDlXV1Zpa0N3U1dReC9nNU9YMEVKVDNDTSth?=
 =?utf-8?B?RkhBUG9Uc2tFc29taDJONytTc1ppUUVuNHcvYWQ2Mk1XZjNtcWNpM3dYT3BV?=
 =?utf-8?B?NktkTitYMXA4czhUSHl5M25hYjhOWTZ1SWxjdno0TXY0eUVYK1FydFZyV0FW?=
 =?utf-8?B?M0tNcFJhSTlhNWRQb2p5c2ppdUI4N2VJWThUcGhqVnRPT3dkZ1RPbEdQcVRG?=
 =?utf-8?B?eThXWEliVWdLUitTczJtZU1MMWNKWk9IL3pCbVlsaGMzM09uUkpNQlpXaFh4?=
 =?utf-8?Q?hFi9ygGlUxA0tWh7gUm4RHoHB?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cde2e068-9156-4a3a-6ff7-08dd7addc611
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6739.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2025 22:51:48.8167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pOB0zDvmq8rRIT6CZVl4SsF+r8siwZkL4OwBQhdjgKKpHL3OtGMSizu7+ivivNqP9CCq7t0WBHOw3PgYjNJG1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6042
X-OriginatorOrg: intel.com

Device partitions have an implied order which is made more complex by
the addition of a dynamic partition.

Remove the ram special case information calls in favor of generic calls
with a check ahead of time to ensure the preservation of the implied
partition order.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/cxl/core/hdm.c    | 11 ++++++++++-
 drivers/cxl/core/memdev.c | 32 +++++++++-----------------------
 drivers/cxl/cxl.h         |  1 +
 drivers/cxl/cxlmem.h      |  9 +++------
 drivers/cxl/mem.c         |  2 +-
 5 files changed, 24 insertions(+), 31 deletions(-)

diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
index c5f8a17d00f1..92e1a24e2109 100644
--- a/drivers/cxl/core/hdm.c
+++ b/drivers/cxl/core/hdm.c
@@ -470,6 +470,7 @@ static const char *cxl_mode_name(enum cxl_partition_mode mode)
 int cxl_dpa_setup(struct cxl_dev_state *cxlds, const struct cxl_dpa_info *info)
 {
 	struct device *dev = cxlds->dev;
+	int i;
 
 	guard(rwsem_write)(&cxl_dpa_rwsem);
 
@@ -482,9 +483,17 @@ int cxl_dpa_setup(struct cxl_dev_state *cxlds, const struct cxl_dpa_info *info)
 		return 0;
 	}
 
+	/* Verify partitions are in expected order. */
+	for (i = 1; i < info->nr_partitions; i++) {
+		if (cxlds->part[i].mode < cxlds->part[i-1].mode) {
+			dev_err(dev, "Partition order mismatch\n");
+			return 0;
+		}
+	}
+
 	cxlds->dpa_res = DEFINE_RES_MEM(0, info->size);
 
-	for (int i = 0; i < info->nr_partitions; i++) {
+	for (i = 0; i < info->nr_partitions; i++) {
 		const struct cxl_dpa_part_info *part = &info->part[i];
 		int rc;
 
diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
index a16a5886d40a..9d6f8800e37a 100644
--- a/drivers/cxl/core/memdev.c
+++ b/drivers/cxl/core/memdev.c
@@ -75,20 +75,12 @@ static ssize_t label_storage_size_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(label_storage_size);
 
-static resource_size_t cxl_ram_size(struct cxl_dev_state *cxlds)
-{
-	/* Static RAM is only expected at partition 0. */
-	if (cxlds->part[0].mode != CXL_PARTMODE_RAM)
-		return 0;
-	return resource_size(&cxlds->part[0].res);
-}
-
 static ssize_t ram_size_show(struct device *dev, struct device_attribute *attr,
 			     char *buf)
 {
 	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
 	struct cxl_dev_state *cxlds = cxlmd->cxlds;
-	unsigned long long len = cxl_ram_size(cxlds);
+	unsigned long long len = cxl_part_size(cxlds, CXL_PARTMODE_RAM);
 
 	return sysfs_emit(buf, "%#llx\n", len);
 }
@@ -101,7 +93,7 @@ static ssize_t pmem_size_show(struct device *dev, struct device_attribute *attr,
 {
 	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
 	struct cxl_dev_state *cxlds = cxlmd->cxlds;
-	unsigned long long len = cxl_pmem_size(cxlds);
+	unsigned long long len = cxl_part_size(cxlds, CXL_PARTMODE_PMEM);
 
 	return sysfs_emit(buf, "%#llx\n", len);
 }
@@ -407,10 +399,11 @@ static struct attribute *cxl_memdev_attributes[] = {
 	NULL,
 };
 
-static struct cxl_dpa_perf *to_pmem_perf(struct cxl_dev_state *cxlds)
+static struct cxl_dpa_perf *part_perf(struct cxl_dev_state *cxlds,
+				      enum cxl_partition_mode mode)
 {
 	for (int i = 0; i < cxlds->nr_partitions; i++)
-		if (cxlds->part[i].mode == CXL_PARTMODE_PMEM)
+		if (cxlds->part[i].mode == mode)
 			return &cxlds->part[i].perf;
 	return NULL;
 }
@@ -421,7 +414,7 @@ static ssize_t pmem_qos_class_show(struct device *dev,
 	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
 	struct cxl_dev_state *cxlds = cxlmd->cxlds;
 
-	return sysfs_emit(buf, "%d\n", to_pmem_perf(cxlds)->qos_class);
+	return sysfs_emit(buf, "%d\n", part_perf(cxlds, CXL_PARTMODE_PMEM)->qos_class);
 }
 
 static struct device_attribute dev_attr_pmem_qos_class =
@@ -433,20 +426,13 @@ static struct attribute *cxl_memdev_pmem_attributes[] = {
 	NULL,
 };
 
-static struct cxl_dpa_perf *to_ram_perf(struct cxl_dev_state *cxlds)
-{
-	if (cxlds->part[0].mode != CXL_PARTMODE_RAM)
-		return NULL;
-	return &cxlds->part[0].perf;
-}
-
 static ssize_t ram_qos_class_show(struct device *dev,
 				  struct device_attribute *attr, char *buf)
 {
 	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
 	struct cxl_dev_state *cxlds = cxlmd->cxlds;
 
-	return sysfs_emit(buf, "%d\n", to_ram_perf(cxlds)->qos_class);
+	return sysfs_emit(buf, "%d\n", part_perf(cxlds, CXL_PARTMODE_RAM)->qos_class);
 }
 
 static struct device_attribute dev_attr_ram_qos_class =
@@ -482,7 +468,7 @@ static umode_t cxl_ram_visible(struct kobject *kobj, struct attribute *a, int n)
 {
 	struct device *dev = kobj_to_dev(kobj);
 	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
-	struct cxl_dpa_perf *perf = to_ram_perf(cxlmd->cxlds);
+	struct cxl_dpa_perf *perf = part_perf(cxlmd->cxlds, CXL_PARTMODE_RAM);
 
 	if (a == &dev_attr_ram_qos_class.attr &&
 	    (!perf || perf->qos_class == CXL_QOS_CLASS_INVALID))
@@ -501,7 +487,7 @@ static umode_t cxl_pmem_visible(struct kobject *kobj, struct attribute *a, int n
 {
 	struct device *dev = kobj_to_dev(kobj);
 	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
-	struct cxl_dpa_perf *perf = to_pmem_perf(cxlmd->cxlds);
+	struct cxl_dpa_perf *perf = part_perf(cxlmd->cxlds, CXL_PARTMODE_PMEM);
 
 	if (a == &dev_attr_pmem_qos_class.attr &&
 	    (!perf || perf->qos_class == CXL_QOS_CLASS_INVALID))
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index a9d42210e8a3..4bb0ff4d8f5f 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -482,6 +482,7 @@ struct cxl_region_params {
 	resource_size_t cache_size;
 };
 
+/* Modes should be in the implied DPA order */
 enum cxl_partition_mode {
 	CXL_PARTMODE_RAM,
 	CXL_PARTMODE_PMEM,
diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index 96d8edaa5003..a74ac2d70d8d 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -453,14 +453,11 @@ struct cxl_dev_state {
 #endif
 };
 
-static inline resource_size_t cxl_pmem_size(struct cxl_dev_state *cxlds)
+static inline resource_size_t cxl_part_size(struct cxl_dev_state *cxlds,
+					    enum cxl_partition_mode mode)
 {
-	/*
-	 * Static PMEM may be at partition index 0 when there is no static RAM
-	 * capacity.
-	 */
 	for (int i = 0; i < cxlds->nr_partitions; i++)
-		if (cxlds->part[i].mode == CXL_PARTMODE_PMEM)
+		if (cxlds->part[i].mode == mode)
 			return resource_size(&cxlds->part[i].res);
 	return 0;
 }
diff --git a/drivers/cxl/mem.c b/drivers/cxl/mem.c
index 9675243bd05b..b58b915708f9 100644
--- a/drivers/cxl/mem.c
+++ b/drivers/cxl/mem.c
@@ -152,7 +152,7 @@ static int cxl_mem_probe(struct device *dev)
 		return -ENXIO;
 	}
 
-	if (cxl_pmem_size(cxlds) && IS_ENABLED(CONFIG_CXL_PMEM)) {
+	if (cxl_part_size(cxlds, CXL_PARTMODE_PMEM) && IS_ENABLED(CONFIG_CXL_PMEM)) {
 		rc = devm_cxl_add_nvdimm(parent_port, cxlmd);
 		if (rc) {
 			if (rc == -ENODEV)

-- 
2.49.0

