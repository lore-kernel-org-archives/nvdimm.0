Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8185302CC0
	for <nvdimm@lists.linux.dev>; Thu, 25 Sep 2025 15:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758815765; cv=fail; b=Ab05xIUgWNkBTzLQac6Rx2oXOPXADqw2hKjtlZZP3SQOCY0CLgYifdDrOsueAsgqiNF4XigYOPXTtGrIsFSdWCc5nquRIGBHlUs4wJTlqJonA3WKTZQs+KtRbRksKbAtP/Ml5z3F+54JNm2rc3984f83op3XcNAHp3LlIxe7xGc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758815765; c=relaxed/simple;
	bh=2qNFFRkQC+Dunt+6SdnkgcQKAMzCaZlgNVGwjwyZnL4=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=fElif3nHkvt4kqItKGVfcNQ4CyMHrlnf+dzOU8Jm7coYjAIgadYoj7K6hVi/oVpOq5dFxkLCfgA3XULYdQbBT7ytLONByl/gsF/+uD0CMA6THXATspRLLjXFWOuSTXDHCnFu0EM78X3poJTNIu1VWwElQDk0QtjqGg2H1eFdceI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OR/DCRjJ; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OR/DCRjJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758815764; x=1790351764;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=2qNFFRkQC+Dunt+6SdnkgcQKAMzCaZlgNVGwjwyZnL4=;
  b=OR/DCRjJXU6xKU+49bj24mbkjft9Qco4KXTbK8mGu1xkQ+yqXq7fXSfP
   CUfu5Uws2hnpsGLDJ2b2ToANVh4KpFeLEeeNem+vRoC5bTG5y+EWkXm6q
   KlRykeeX8x/fiV0TwY3KiwGgiKVtBDUg8WwEMMGFIFBshSGm0hzn4fUNJ
   0563vIdGzsHpBQwHWxUpHZ64zT7xoVzBKLMscbS9q4mzIrGv0+dGO6JOP
   dUD7gEIW5xngG6+HFTgXBaQHCQbK577NvOHMWhfKA2yqnIqyr1+WWpUSr
   dsMdPnPIB8YPntV1vajAd8HvXagAdATPGA3a/fWlF7j+HIbg2Fqv+V0GO
   g==;
X-CSE-ConnectionGUID: cfxKOkFjQbalOmIi9yqBvA==
X-CSE-MsgGUID: Gec0wXx9TtC8XY96YIYlfg==
X-IronPort-AV: E=McAfee;i="6800,10657,11564"; a="71758841"
X-IronPort-AV: E=Sophos;i="6.18,292,1751266800"; 
   d="scan'208";a="71758841"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 08:55:59 -0700
X-CSE-ConnectionGUID: S4T/HNHmQV6kPeX/xPKXeQ==
X-CSE-MsgGUID: 4pTQf3YqQZmHMrmGq1ZuyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,292,1751266800"; 
   d="scan'208";a="181757220"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 08:55:58 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 25 Sep 2025 08:55:57 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 25 Sep 2025 08:55:57 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.52) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 25 Sep 2025 08:55:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IOCKzu4DeydL7GY35MmCyDDbB9PHKBvq8M8H9T8OlhvftcC7GJG+I+RrmjgRhLpQ2x2UUhX3Zp/zSUqmUt5o+XqYOVmEaJTXz3LNVXdocIS2IO2qnT9ycNPLNtrmym1t/70w31Smnb05jWlDWism0mXw/tXDMG7ZC4GeOpcgIfR1bBhIh/7EShSUPkJqD+cA8Fko+mLBOE4JGibfxzjeWROzCRe7qDm0u9kZwKS32+W/OzSDj3u6UiJpvetaKM9bj8kSHSInTxC8WD0zBhmxlIyr0ETCCFUK9mhy7TeoZQZwjwGYMcFTc8WftBFlXJuuZsW3SBJnjqaLVkupf8qm4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=34/I3DZccnZ0oQI5ilwye1CFpm7qxAMx4ZeTePDq6tQ=;
 b=h6q+SWsFVrnhi9mfEEIgtWvoCLo0yJuTvLDviBZhSh+LaTQODc6t7gnlxva8T2khDWldm06j92XPedXmwpA6rjL4LL87ci/9knl9EaWPDbBZYeMwApRhLXc4VINYwFnWKn6RNQnF5mvMTkfqBMDknX1LF+fvcLJDc2d+8aBhwDWvO4JHO9a3CvrmZElgMAp1kjUHsaf/bubtCHFcEPpnqla5nad+YPz2u+SEi7JWx1SqcLfr32NQ0yAspNj6zD4W1dpLqmM99ulDaKY66lO+JxhS46NizVj0dPVdfYBDLxli547yJljbs9y4URmGPLCo+YEiE06wOvDI8/OZKRDU0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DM4PR11MB6214.namprd11.prod.outlook.com (2603:10b6:8:ac::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9160.9; Thu, 25 Sep 2025 15:55:53 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%2]) with mapi id 15.20.9160.008; Thu, 25 Sep 2025
 15:55:52 +0000
From: <dan.j.williams@intel.com>
Date: Thu, 25 Sep 2025 08:55:50 -0700
To: Alison Schofield <alison.schofield@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>
CC: Alison Schofield <alison.schofield@intel.com>, Dan Williams
	<dan.j.williams@intel.com>, Andreas Hasenack
	<andreas.hasenack@canonical.com>, Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>
Message-ID: <68d56606e8dd2_10520100b5@dwillia2-mobl4.notmuch>
In-Reply-To: <20250925075438.148935-1-alison.schofield@intel.com>
References: <20250925075438.148935-1-alison.schofield@intel.com>
Subject: Re: [ndctl PATCH v3] cxl/list: remove libtracefs build dependency for
 --media-errors
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0137.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::22) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DM4PR11MB6214:EE_
X-MS-Office365-Filtering-Correlation-Id: c12e9330-8492-444f-9e1f-08ddfc4c015e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VW5UMUdnUWpVL1FjcHRwL2IzZ2hHak8rRS9JVHBPZDhobU5HU01Zak1HSUh5?=
 =?utf-8?B?UGdEdjlMMTJtRmxEN2FtcEFIK0s3ZjlKS0RBcVUxU25vT1JoamkxOWZHWnkw?=
 =?utf-8?B?Q1RXTDg3cVBUQnZEMTdmMVUycCtoVzhtZ3JNQkFrZ001RWxSUXdUMENHeW1S?=
 =?utf-8?B?UFJheWFFd3BwSFZFcyt1bS9Oa3FhbXRSNDZ4dlJHUnZNOURkVEZJek1YRU00?=
 =?utf-8?B?WENrTGQ2N1pmMmNvb242ZTZITk1SRkhSS1o1SFNQb244VUc2cVowb2owTi9a?=
 =?utf-8?B?V0lHa3pOYWc5ZkpPTTJacW5tQnNNN1loUnAxa0daVWFaUnZmT21IbnVCWG5T?=
 =?utf-8?B?Um1ueGkwbmdtL1BvMUNkbXJYa0RGS1BuL1FkQlhYWHUyd1h3aW9zUm5CWHFT?=
 =?utf-8?B?NWFmRllmVTRadUxQWGFXeWNBVTMzVjBqMWY5andITFF5YVJRYlVpTkpHcTh0?=
 =?utf-8?B?R0N2VnovZW9XQi9WV1pWNk9qRFk5MTJqNEhOOUtnMHRCWVlvMSt4NHR6QjZz?=
 =?utf-8?B?eDZXQ0tjNHF6SXR5c3dHTVBDUjdBSFcrbUR5V2U2aGNZclVheTNtdm1BS2Jr?=
 =?utf-8?B?NXJCQXJTYW1RUTF1dEttcEkrQUJwbGRPZ1doMUUwbHArRXdxR0dUWndvSUQx?=
 =?utf-8?B?bkZLdzB6UHZFa2xFUU9lTGRYa2N1MGozQkVxaE55Q3NBYWZjNXFFbEJsa2lE?=
 =?utf-8?B?RkY3Zy9DYUFtclJhcVFwV0grSnBIOEVrMHpSMFFHQzloREFabVpGUlgwLzNv?=
 =?utf-8?B?eVcwQkFGRXZjelQ2b0VreWtEakdLMmMxSnhGQmN4UGJBcnhVSm1kU2w0MlM5?=
 =?utf-8?B?NU5YYTliQXZYNmx2eERmcnplQzdhZDJlODBHeE1lYWNCSFFETDVLbGd0R0x6?=
 =?utf-8?B?SElHY1AvaWlnRnFrMi9KUE9DSXVYOXlhdm1veW5hdVg3TGRLZDdqMzB3S085?=
 =?utf-8?B?YXphdzN2c3U5TXUwZThIVHlzR0pidzFCOXMyRW1iQkxmaE5oOUg4dlNmYVlm?=
 =?utf-8?B?R3c0TWV6MWpHUWI3Q2N6ODVyMzlUSFcvSjJtR1krS2YxS1NYRjA2Nk5XbEJm?=
 =?utf-8?B?VlRKcWZzeTV6amRNL003NHorcW16OHJjbU1ncU9sZVloYmUvUG1VYk83T2lo?=
 =?utf-8?B?SURwTFY4WW1GQTkyMmk4ZERMV2xtM0wwRTlmYm1SOGtCb2lPT3BjNFRLRnpD?=
 =?utf-8?B?VlNHUzZKdjB1dlZwWG1OTUpzdFFwRCtYMlNva2NCbHN1ZWxTQUhqVWtkZFFM?=
 =?utf-8?B?N21NcU5KUVNTNUFSbHpycnJTK3dlc3VvTjRSS1M5YTBUNVV3T3NtWGJ2TWFs?=
 =?utf-8?B?bjVMYzVxOXAxUS9ReXdiMFN1ZUgrYmNJZm9kYk5LNCt3T3NJSVliazBjVXNW?=
 =?utf-8?B?K0pacXRWR3VkZFdWcTNaZmpKUVN4Wlh3SVBPZXFtc0FycE1KMkorRGd5SS81?=
 =?utf-8?B?S3YvVi93aGVsdGF3dFk4M0JKNjJLaGdYekxiUDhQUmgxUkh2UmNsT2R1bXg2?=
 =?utf-8?B?eFYwbjN5dGZqdVQ2QzVpSGJmREMzTTN3MnNuc0VFcW8wZEloUlZ3d0M5T1Vw?=
 =?utf-8?B?anREOUxHSUJGODJjb0tNSmxGMVNFRklZZTZSbUNUTE16VlJONGJ6VDdMaFFH?=
 =?utf-8?B?bFpGVU1UQktqVEladU1pUFNQczl2dXE0VVBtY2xxUnV4TzVKTEYrM3ViOE51?=
 =?utf-8?B?dkJDOG1lUDNLVll5SDRvNUttWFlERGNRdE5vaVJsUTdycmxpd1BiUlVjeDJY?=
 =?utf-8?B?VUdkcHBBbklwYTM0Q0RmL1BGQXlwTHlCaE9SUkdTMDJBbXJRUWlOQ0xreHVW?=
 =?utf-8?B?ME41KzMwQ1AwSFdBNVB1ZVFUTWFUTkl2cUY1a20xQjRhckU5bkpzSG9KaUNP?=
 =?utf-8?Q?8+g0XqixqCAYa?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?STdPYjNJR3NHL2JkblpzWWlIeFBmeTVldG1DMmJuZmEzYit2QlZVaFMvMitT?=
 =?utf-8?B?WVJNZ0ZWcldoOG1XUnRlOFJtdnBKTmN0NGw2QTEzSFNOeEdlL1pDM3Jldmd1?=
 =?utf-8?B?VENEUkFNZ0prL1BhdnRtbElickxKVkxxUUVhYzdiRjFHNTRLaG1ZWUFCTGZO?=
 =?utf-8?B?RG9YVWs4TUFyLzdibExxZk9YU3dndHVBNENSQmllUThVRHdtaFNjRTg5Z1Ny?=
 =?utf-8?B?WkFXazQ4bkx5ZkJKaVRqYXBRNVpSVGtGWWZJTXV2OTF6WGJDa0xha05DU1hP?=
 =?utf-8?B?azBlM01vQ212NTBUV2tzUVVZa2xtTEhmbWF5b1lXUHJYaU5NWG53Q0tVdHdk?=
 =?utf-8?B?VUU5Q1BoeUxPRjd6VitqeUFrRWVJd0RNMGdFQXd4aVk0N1diMmRwcVI0ZlBB?=
 =?utf-8?B?OEZrU1J5MTVHRWlFVzU0d3FxQXZiL004N0pkZWJseHc4UThReUtpRUMzYkRQ?=
 =?utf-8?B?MDFlMTl1NVUxdTdwNUZEd2UxeENrdFdlNkZENGdLcHo3WHQxQTJZTFdoZW5j?=
 =?utf-8?B?bXN3SE5VSEhad0FOa0tjVGpTNWNqaEVxZEpqbjNvTUpvNW9oUlRSaVlMUGly?=
 =?utf-8?B?dFhVb2ROcm9nb0oyTzFuR1F1T0k5TS9vVmVKbW9vTHdHUUtlNm5NTEVra2p0?=
 =?utf-8?B?U0N4Njd2S09CSUNTMUVIbkQxcG4wRVZTMStMeXBGY1ErWXEyYTVubjc3V2N3?=
 =?utf-8?B?b0FhQlduY3NUWEtIb1YwalJPemlldVlNdFBYRUxRNjlhRzJWVjc1RUxpejdI?=
 =?utf-8?B?NWx3VzVLektqRHlXblhKUUtLNTlWTUJtQzhsZ2RBeWloSW12NVJqenhWdXp6?=
 =?utf-8?B?MjVMVXdlZHZHdHJ3SnVKZ1puMHlXaWVTSzNyNFg0dURPMEJFbG1LRjI3OUVt?=
 =?utf-8?B?aGQ4bFR1TzRCenBpNHJmbjR1ZG9QUU9UWmh6VmVaeks2VXdGRmVucStRYXdV?=
 =?utf-8?B?QmVXQ2pQcFkvVFk1STRhN01IUmpWNm8yMVRlclBjWjBGUWVJb3dzK2MyU1NM?=
 =?utf-8?B?YTVTVmFZWGQ3Z3dzRXZxTElTSk1oWnFHdmthZUNTc3BuNXJ6VG1zeCtlRUs3?=
 =?utf-8?B?S1hZbTVNWkgyeVlNYm9zNEpRTktiemtnTnFqa3VWTmpGK0lYWjdSWW4zTHRF?=
 =?utf-8?B?L0drbXJzWTRMbm9seGhIcmVBYVBEekNaZDhyVUE4T1lSQ2loc29aYWRscCtY?=
 =?utf-8?B?c3F0U2dQSkZtR2wzK01CbVhvSWtqYVNQdWFXMDNHdVJWazJxcHlaVzBzK2lV?=
 =?utf-8?B?T2tNOW1FendsSXBZRS93V0NkdVNudGFXbGJJdnBZaHptQ0wwbDhjRE1ON2RB?=
 =?utf-8?B?NEsyTlQ4bVFQeHYvQVI0bC9tL3dEN0Q5QWNxYXo3SHZBRFZ6M3NYMHdJdStY?=
 =?utf-8?B?aGpjSFdScnRsNEtYbTNQL010UUZHbysvVHU5ZENOUm50R2hidEFhbXlhKzBr?=
 =?utf-8?B?cUVwdUo2Mkhsc3dZSkJwOTh5UGE5dUZmS0RaUFZZZklwVWJucWxvUk9tSncw?=
 =?utf-8?B?am5Dc21DeStrUzVCeFg0d3AwK09nTmZxaENBaEJLeDlXV3oxR1ZsK2J1YS9H?=
 =?utf-8?B?SnRsMm5HZnVpenZPWXJoeW9VMzRvM2tPeGxZREdvN2hBZmo3V25NSk5uQ1hj?=
 =?utf-8?B?dklkU3d0cURqa1VyNHVaczlHWGlPRC9LQUIrTndBZnhJU256Z1BZbG91Qms3?=
 =?utf-8?B?bk1wajcyN2VLdTJhTnpIeVozdDlGNyszUHZzV2M1NHdZQm1rWDlBc1RFQWJl?=
 =?utf-8?B?VktzdEFQRVNWVmJGNVJJa2Z2aHZsbm9KR05HdUVrRFRUdGZiZ2wyOGM0UmF6?=
 =?utf-8?B?dUJZZUNlTk56cGhvaHNUdEpEMy8yanNIT3lQNWNveENIcGtrTWlZN2VMYTBP?=
 =?utf-8?B?a3k0Qmc5WDRLTVZSYWVaUnBXaTIvczY3SzlrMVMxK3JVOUVUeksxKzRRb3ZF?=
 =?utf-8?B?QlJYOFVxWVV3WStBQXpDRWFtbEE1RWRPQ1BydGE1Zk4xMDF1b2wwQVlCWkw1?=
 =?utf-8?B?RllONFEwSnFWbk0vV1dyQWtoaS9qcTNuY2pzaEFzZnlEeWNreEo2aWJOcXU3?=
 =?utf-8?B?M2RHT25ESy9RYTZyNElyU0ROVDVnN2NWa0tiTzFkYjBKQnRPdmI3VGNONDZu?=
 =?utf-8?B?NFA2RGYzMzFEU1k0WTZqbDEyQ2Z0ZDBxZWJZTkR3NzV5VXR0RFJLZ21ScTZR?=
 =?utf-8?B?Rmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c12e9330-8492-444f-9e1f-08ddfc4c015e
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2025 15:55:52.9082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EbwRNm4Y7ku0YJOkj3zx5npOxq8V8gI8QB23nVvjG1aZ4JSQP+AYugC7ivjKtMbFtW2B/KxF5fjyucq+vGiAg97RR3iZsF0h4zAfGUDCqlQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6214
X-OriginatorOrg: intel.com

Alison Schofield wrote:
> When the --media-errors option was added to cxl list it inadvertently
> changed the optional libtracefs requirement into a mandatory one.
> Ndctl versions 80,81,82 no longer build without libtracefs.
> 
> Remove that dependency.
> 
> When libtracefs is disabled the user will see a this message logged
> to stderr:
> 	$ cxl list -r region0 --media-errors --targets
> 	cxl list: --media-errors support disabled at build time
> 
> ...followed by the region listing including the output for any other
> valid command line options, like --targets in the example above.
> 
> When libtracefs is disabled the cxl-poison.sh unit test is omitted.
> 
> The man page gets a note:
> 	The media-error option is only available with -Dlibtracefs=enabled.
> 
> Reported-by: Andreas Hasenack <andreas.hasenack@canonical.com>
> Fixes: d7532bb049e0 ("cxl/list: add --media-errors option to cxl list")
> Closes: https://github.com/pmem/ndctl/issues/289
> Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Link: https://lore.kernel.org/r/20250924045302.90074-1-alison.schofield@intel.com
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---
> 
> Changes in v3:
> - Remove ifdef's from .c files (Dan)
>   Move ifdef chunk in json.c to a new conditionally compiled json_poison.c.
>   Move ifdef notice message to !ENABLE_LIBTRACEFS stub in event_trace.h.

Looks great, I appreciate the ifdef reorganization effort.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
