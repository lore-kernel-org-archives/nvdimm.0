Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7B51F3FEB
	for <nvdimm@lists.linux.dev>; Sun, 13 Apr 2025 22:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744584757; cv=fail; b=EiwpNkwmz5eH/ITVhWLW5ihsmofNb2bNxqEp364LvyxZeiG3tWFGWYRZ7We7G0CgGlTN2i2c+hyVR7MbT7jRPTowmhyX3iL9xySvvtGfPZtLnoadJadgPXUJpbXW6dWBP9lmrI7OUF+pCJ0DqAwjBQUyYOtDKQFZEwwAM1b4qRQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744584757; c=relaxed/simple;
	bh=4QxktrWxnejqz2TUfcmWO6HRceAt1/3c56ZBgEUdUaI=;
	h=From:Date:Subject:Content-Type:Message-ID:References:In-Reply-To:
	 To:CC:MIME-Version; b=DmVYoSBFlnqtZNJhjhrBs4sHz8g254EuFgW+3X1J40VPDgbB9UV3fknu6wp/SBrt+2EqhfwHlaL69jCedxRiltrjw35FQo3w0HAI8sp5+s8NN17cWJC22+0C4N/matvg/D7NuRCsdZ1U7E7i1ux4tQadILkn1Rr6d/6nwGgp63E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gzCWUHOo; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gzCWUHOo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744584756; x=1776120756;
  h=from:date:subject:content-transfer-encoding:message-id:
   references:in-reply-to:to:cc:mime-version;
  bh=4QxktrWxnejqz2TUfcmWO6HRceAt1/3c56ZBgEUdUaI=;
  b=gzCWUHOo9wYeIXeBMvuOMzBpZ7lv6UWdJTZHKxZ0oWz8KgeXA3bcMxnr
   5hOUslJJn4Oc1MLHNKrlsAaBbC3xB2z5MwWlTsZ2wMF7WHHKiEViu9uso
   RMGHoDSZfTry6mkeYnoNBVGL9IDGKbZhtAqVSA/Y0TymZoAzvu9BLtAcq
   4K9eM1PkkorPEs6LSzprdbav5Nl0PFuIHhRskettpd/5yJ4wczaDPdgbA
   lveI8q4h+aeBtoyoB3vlV3xJe+Mhi0PEVZ+94Cid60RZdxTH+x+kDFWdT
   xy3HRFhZf39a2CMxPmtCr8vAwcuRtekLKX53z8TXkfv1tsGXsSiyu4zvj
   A==;
X-CSE-ConnectionGUID: 8g+T8kqoRHCDx9cnBQjkng==
X-CSE-MsgGUID: RAM0OeLTRPi9k9SfW59zoQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11402"; a="45280960"
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="45280960"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2025 15:52:35 -0700
X-CSE-ConnectionGUID: hucgneI/QBy8+4zmjQaRCw==
X-CSE-MsgGUID: 42k62g37RrK55hw3QiNPzA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="129657634"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2025 15:52:35 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Sun, 13 Apr 2025 15:52:34 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sun, 13 Apr 2025 15:52:34 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 13 Apr 2025 15:52:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pa2G21XfKcJlz/lYAe7jXxcoEBrGy+x6wRpJ2eTHZZHWkYb8ftLIkj8QaYFC9wQQHUb+TAK9fUtGm+UZ8nyNo+0KIbYpBm4bLF2Wa2eeWEeSrBAdesR9DjQ2Gg4+MLVVbJh84qLXEshow+iOTfXTE1U0MwJSN1xhXea5iI9KDfiI2lts4e+iApiTMG6cJh50pj4IVEooiydw/XVG8hSC7DSc1L+rrqTe+sqY4HM/fGmiFiXPSmn49+JC3QsQRJdrV/6lsT59F6g1rDfyKUFqPmnQEX+KpnCCyX/dE2lCd+jos3gcTglMkUNV9bbuy3Akn1RM18DehMZFsyeQAG4KEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MvYgRMhAktNXF4t/3pfUAOXXg8C+qZBgHgfffXR6mRU=;
 b=oLGmzMkDhxuJRsxN22dijTAcd+1BV5bSF97qISlJRnmAezbYOFYl9eQ25HSr+htClXSKh+XB6ZxLp17oGErknFK8a1zL7nscXUDlAjsRpuaR5TMulwA2TfRCGDiI7jNLDoP6K4CzDiXuTE0p1TWgKPskUZqX9/c3BmWo1vYuaOtIbzW/xZxYJynuY1X5PVb8vkDqYB8choKDnCTfgzHiZsDTYpW5X6w2eddFRhhqRoFdYHsuuSCdXxcfRy7neiDoGzlGzGHX+t5lv2uQPJS7jh4/qbgqD6M3afnl1YjHPK/5z5jNJqsp+FFipT9efqoDfdAqdcUz5oOE9UzpB9rMog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW4PR11MB6739.namprd11.prod.outlook.com (2603:10b6:303:20b::19)
 by PH7PR11MB7003.namprd11.prod.outlook.com (2603:10b6:510:20a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.33; Sun, 13 Apr
 2025 22:52:04 +0000
Received: from MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24]) by MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24%4]) with mapi id 15.20.8606.033; Sun, 13 Apr 2025
 22:52:04 +0000
From: Ira Weiny <ira.weiny@intel.com>
Date: Sun, 13 Apr 2025 17:52:21 -0500
Subject: [PATCH v9 13/19] cxl/region/extent: Expose region extent
 information in sysfs
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20250413-dcd-type2-upstream-v9-13-1d4911a0b365@intel.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1744584735; l=4964;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=4QxktrWxnejqz2TUfcmWO6HRceAt1/3c56ZBgEUdUaI=;
 b=KXsGvbveT4s3jlccnLfPtcpIne+PH6RDv1qMtHp9JjK0/d5oC6VwfYnbnUeflSx+a8NH3ma80
 338X1M1ZU7mCB8fIijUF6yGiBMv2LLb6V6KkQqxWnWE7f7mHaSathc1
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
X-MS-Office365-Filtering-Correlation-Id: 434ae3cb-3d29-4c63-ebd5-08dd7addcf28
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WGw2elVjY3M4c1VrbUZ1YWJBTVRDODJtT1ZHZVFYQjVpaU9ENFFYZlZYZUVO?=
 =?utf-8?B?WTVlbTdhRER4dTA3T1NNVW9OUnZ2Ti9GTVRlV0lULzBoZW9RbC9ucnIxOEpa?=
 =?utf-8?B?YXNCaks2YmhIcjkxaE5JdTlINVJWZmIzeElIUWZ0TGlPdEpZakgxTVZmTTlh?=
 =?utf-8?B?ajF0a0NxTUNmSjFNKzNRNGFpUmNjUjhnemE2WXJBcUJGNVgxb052RVN6ejhW?=
 =?utf-8?B?TmdQRExhalFrVkFVUVFFeFdwWGpFTmIvSnl3MUtPUVRMZC9XS2pLdFhjNGFu?=
 =?utf-8?B?WWRTUlMwZVl4ZldrYXFJY2J0bXdiakVBSitSMjBDNzRRcTVBb0VBOE9UTDBx?=
 =?utf-8?B?d3ZneGpHM1o1dUVyNXVEZ0lQT3Mrd1hqREhNWCtkRGhoSnpxS1kyQ0Fjb1c1?=
 =?utf-8?B?akxwY0NyMFBuTC8wOWtqRU9NU3NWa3BoTkxxVzZha0I1ZzJIc2ZZaGlQcUdB?=
 =?utf-8?B?dFhLYm0vNFUvcWFYejQ4VWZxR3VtWnZQc3hpZ1lWUlo3Wm9IR2RlMXlvQUM1?=
 =?utf-8?B?REt6V251Ukd1TjB1aFBFdTFDTmp0L3NUKzVqaThucE4yVElwMUQvSE9aRnlL?=
 =?utf-8?B?YU94NnRIZFRVejY3YzBlYjE0REo1NWxBNkVVSk9MK1FIWkFFaHM4QWdrY0Yv?=
 =?utf-8?B?UE5kZHg5UkE2NCtBRnU1eDR0eXYzT2lZWjlGSUR1cUN0N1pRNUdwcVplcWZt?=
 =?utf-8?B?UkJKWm1zbjVBcmFKUlFSUHFEL3ZMUUNYaHRZaExscCtEU1Y0c3VVMFNock9M?=
 =?utf-8?B?UTM1eEFuK3RCZ0F2c1BIbFZzRXVOVDRyaG9TbWczM3FXSkU3WkMzNG0rVWVZ?=
 =?utf-8?B?TGxEMVdYVTBXRzJkZk5xVm9KY0UzYzZIV3JjVnVsd3psQ05GT2JMeXlVVG1R?=
 =?utf-8?B?dWZRL21SN2tMRjM0L1ZFb2toZzhobStOR1Zad3RkWHNUSjZMLzlYUnhDQlBT?=
 =?utf-8?B?TE5YaWNjRGZUMlNYSW1GTkxXUEFEODhWM0sra01sUXpvV0VWVUw4ZlJINkY4?=
 =?utf-8?B?NjZOSG9WOXNKWlNNakhQaElTS244K2lsMUVBT2JRY283QTgvL2RoenhrWUZU?=
 =?utf-8?B?ajR3N1ZqaW9NYitBWFpFUEZ2eEtNWE9NSDI0THVlNkJVeWJpcFB2OXd1clcr?=
 =?utf-8?B?Y3dXWVltOTQvNlB6TndwdXNHSkh5MUhYTlBIRjM2S2l3SVlnbjFQVVMzc1R2?=
 =?utf-8?B?eis1TGhGNEdCNU1GTFY5aTFnZTU2aFpWZXY3VVdoSGx5Ni83bzk1KzlWYTVF?=
 =?utf-8?B?MjFPYTVjSWhhaWdmWmtoR2IxUTZ0c3RYeXE0eFpqaDBSRGZndXhaQVN5aEJI?=
 =?utf-8?B?eWgvSnlLbG5UcDZhWVMvdVZrTzR4ZVZkV2kzWnNXUGl6cTNyaEx1ejRDQ0No?=
 =?utf-8?B?ZzUwK1pmN1hNWVd1NGw3QnJCcUF3SnI1RnNQdGw1SHBYZC9Bc3ErOE5HSktz?=
 =?utf-8?B?ajZlRENuRy9zeEc5dUp4RzFTcWZhaXpOb2xFcmZYS05aQVFidFNjNm5WUnEy?=
 =?utf-8?B?dVBtbEt5Q0hOamNhbjduY2QwSEVZUXNXN2J6eGdTRkJFUFFzYjgrWmhpcUd0?=
 =?utf-8?B?c3krUGhzSGppV1BFcDBXNXpYQ05QeDBRVUQwemNaVmtjWXNFZDRaM2pHWjg4?=
 =?utf-8?B?MEhJSGRkWmQ3K2tLMmRvSzVqaVdmNVM3bUxON0Z2Vis2VzNkVnpJSUdsSExt?=
 =?utf-8?B?OEk0ckdIOUtYL2ZNZkdGZ0RaYUkrVVdXZURCcmhOTXhWSWd5UmZvOTV5MWJZ?=
 =?utf-8?B?TzlhSXh1SmJHT2UySmVZWEJESGxuOWJkQ3ZUOHRGemtqNk1HMzl0VlNGUkta?=
 =?utf-8?B?ZjJFRHA3Wml3eUxHa0o2eG42RUdrRUhQbkY1TVB5VnRZaWVkNDVseHA3cFkw?=
 =?utf-8?B?VTNzcXBUYkpSSTVybVFkMkhiZmpZeDhoQWFpTU0wTlpEbGFndTU3TUN6T3FX?=
 =?utf-8?Q?ZtaG0xIk2ZQ=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6739.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TEtVbW1NaUg5Z2U1VDh4Tmc3UnR0OFpKR2M0czhnWlV3dzlGYTdLQ3I1WHNL?=
 =?utf-8?B?RTFCc0tCbENNb255WVZVSUM4a3JSNDFhdjRSeWhrM2krRVh0Kzc0OERGb2py?=
 =?utf-8?B?Qk1td1J5Y21RYWFNdXVkZU9vOEU5Q2dOM2JIakRsQUh3dk4xVGhVMFk3QlE4?=
 =?utf-8?B?NzUvM0kvZ0lLblU5eitXYjdZaW9EZ0x0ODByTHk3L0Z1dmNFazMraXVWRFJa?=
 =?utf-8?B?VHJiN0x6RzhwOEQ2UUJKZk5nR1FPaU1tUktMS1pwZkJyNCtKRlQwZU1MWlox?=
 =?utf-8?B?WHNzUnJLL3RiMkZUMzRUMzcwWXdhYmV3c2dNcWpSTWo5bTRMRWNJeEZQaTJE?=
 =?utf-8?B?RHFObnQ4dVFxWjhPeEtPNkFsQUMwN3p0NWRIbkcvQzJMblNsUFgzdC9uUzdP?=
 =?utf-8?B?c3FJVVNaZmFsMzR5OVNXK2NiM2Zka1lMc0xTRzVVVGttWDBWMk84S1owS2hO?=
 =?utf-8?B?ZGxVc3lRVTBSTTFqbnVNMU4zNGlGeHVwUE5UbjhIK25CaC9iNmFvVGZSbkpV?=
 =?utf-8?B?RzhINlpEV2trTzh6YnVjRWwxeDUxTnROWnhPWmVJNWwzOHhOQTgxdDR5cExW?=
 =?utf-8?B?ZXBnWVBzTnFEcGNiWkRHSjJmUnNZOGpUZjZDb2NqU1htWTBaMlVvcEdlOVhN?=
 =?utf-8?B?TXoya1FZYUlTelg4Kyt5clJhVWFsMjFqUWI0dmxkQ25qU1Y2bFBHMzg5T0Vr?=
 =?utf-8?B?YmYrN25wemdYaW83SkxERGFwekhLSm5Qc3ZDVjROZURNVDFVMVNRdGk5V09v?=
 =?utf-8?B?RFNDZnBLa2IwbTdHdmhXb1p3elYxNzJ1ZkdUdGFyaWgxU3I4dUV5TGYzbVMw?=
 =?utf-8?B?a08rYTh5V1VmSkp6bXh3QUpXdDI4SGRoemxjSGRoSFdsRTJyNnlaV3p5S3NH?=
 =?utf-8?B?VDZqdmdFazRtOHdtM0ViMWJhYlMzK3dDekJ5eGpzbEQ4QTlSVGlNeVR4TjY3?=
 =?utf-8?B?T294M1Z1aWpubG0wbXpvR0pkOThnQ2pnWEcwcldRaVJSN2hTbExlUHBQUE1R?=
 =?utf-8?B?dFFScTlUR1IvQTd3U1NvSDhiaXVBaTYzK2wzeTlKWVo5S1BpU244NDFpd0da?=
 =?utf-8?B?WVNrMVZDaE5uZ0dnNWRUU3pBa2dmZ2RyQmFrdURycE0wV2FTV1puS3dNWGw1?=
 =?utf-8?B?eVVFMWxLYTZFbWd3M2dQWmlvaTBIRDBvRDR3SFovczdwR2FGS0wyYkpLblZx?=
 =?utf-8?B?czkyQWFNcElwMk1XV3dSdXRsRXFVaU11UzBJbHJpWjluYmFmanhjK09wcUph?=
 =?utf-8?B?TGdMdkRFZnZMTjJSeDVDOFdQWjhvM3gvRUlmRlVDMEdJQW9tV2taVWJSZ1lh?=
 =?utf-8?B?OGlucEJqS3laWk1hekV5bC9aMnpLTWNwdnZDcy93N0VlQTlxVlo2K0FhZW53?=
 =?utf-8?B?cWM2cWJ2VlZTU0NXNHVQdFBTU1Bvd0dXcmRha3lPNTRjL014aElhL3g2UmNY?=
 =?utf-8?B?cWN5Ri9UbEtGSXNEWlJTNFJuZ0tXL0Nubk5zbVIyVXN6NEZSbTJZTGNJYW52?=
 =?utf-8?B?L29idFpYVWN1NmxYWmJkVEozQ2diU05telhqYmtJc1E2NlpKbDJOSmYra3I3?=
 =?utf-8?B?NkhNYUNkYjZnM1JseGhVUVR2SmpLNWg4SXZZNk41V2E1Qkd4ZEJzZVVWcjUy?=
 =?utf-8?B?Z1h4emZ2dk5nemNhMExxZ0gzZ1BqN1J0VnIvaUZ4YzhTVitJS2I0OC9ka3dv?=
 =?utf-8?B?ZC92SmxqVnZBNW1XNzdZeFJ6R0RXcHFwSXR4Nlp2VEtBbnk0V3BDWkFJTzEx?=
 =?utf-8?B?cm1kUWprV3dvN3lvTnYwWTdOSVJFWWduS1VkVjQ2dkhrdkNLaWxFQ2p1OFpu?=
 =?utf-8?B?RWZTSExvY1FRTzFEcWlHdHUraVV2b2Q4MzUvOTdBQU9LVm1TYUZrRmFiVUg5?=
 =?utf-8?B?K1g1ekR4dEIzam5aeFdQcXN4MitBNzRBQ3RRWG1hYUNXbkY2dlMyZDdQa25K?=
 =?utf-8?B?cUNpTVdlNXpnRFNrNzBudCsxUGxzb2s5UWF2WTZDc1lMRXI0cXlzY3FKdXQx?=
 =?utf-8?B?WmZtNjF0VzlTMDkvd1NSNGthaTZhMEZoNElJQVFySWFwdS81eEl5T2szSzNR?=
 =?utf-8?B?K3BtYTljRjJyVThiblRwK3hKMFdvZis5S2IycUZVVndtZXZyVEU1QitReVY5?=
 =?utf-8?Q?8awORSq61wSnwAN+0VXOF8v+h?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 434ae3cb-3d29-4c63-ebd5-08dd7addcf28
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6739.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2025 22:52:04.0304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0rCIlEwUDPezvvAkC8bcyapHq1+fOHAk+9iBIzRE0fxCZQm16TwgyxPcNeJdfsG1v1Z3DYniFRHO6sZ4B+bZtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7003
X-OriginatorOrg: intel.com

Extent information can be helpful to the user to coordinate memory usage
with the external orchestrator and FM.

Expose the details of region extents by creating the following
sysfs entries.

        /sys/bus/cxl/devices/dax_regionX/extentX.Y
        /sys/bus/cxl/devices/dax_regionX/extentX.Y/offset
        /sys/bus/cxl/devices/dax_regionX/extentX.Y/length
        /sys/bus/cxl/devices/dax_regionX/extentX.Y/tag

Based on an original patch by Navneet Singh.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Fan Ni <fan.ni@samsung.com>
Tested-by: Fan Ni <fan.ni@samsung.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes:
[iweiny: rebase]
[iweiny: s/tag/uuid/ throughout the code]
[iweiny: update sysfs docs to 2025]
---
 Documentation/ABI/testing/sysfs-bus-cxl | 36 ++++++++++++++++++++
 drivers/cxl/core/extent.c               | 58 +++++++++++++++++++++++++++++++++
 2 files changed, 94 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
index 2e26d95ac66f..6e9d60baf546 100644
--- a/Documentation/ABI/testing/sysfs-bus-cxl
+++ b/Documentation/ABI/testing/sysfs-bus-cxl
@@ -639,3 +639,39 @@ Description:
 		The count is persistent across power loss and wraps back to 0
 		upon overflow. If this file is not present, the device does not
 		have the necessary support for dirty tracking.
+
+
+What:		/sys/bus/cxl/devices/dax_regionX/extentX.Y/offset
+Date:		May, 2025
+KernelVersion:	v6.16
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		(RO) [For Dynamic Capacity regions only] Users can use the
+		extent information to create DAX devices on specific extents.
+		This is done by creating and destroying DAX devices in specific
+		sequences and looking at the mappings created.  Extent offset
+		within the region.
+
+
+What:		/sys/bus/cxl/devices/dax_regionX/extentX.Y/length
+Date:		May, 2025
+KernelVersion:	v6.16
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		(RO) [For Dynamic Capacity regions only] Users can use the
+		extent information to create DAX devices on specific extents.
+		This is done by creating and destroying DAX devices in specific
+		sequences and looking at the mappings created.  Extent length
+		within the region.
+
+
+What:		/sys/bus/cxl/devices/dax_regionX/extentX.Y/uuid
+Date:		May, 2025
+KernelVersion:	v6.16
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		(RO) [For Dynamic Capacity regions only] Users can use the
+		extent information to create DAX devices on specific extents.
+		This is done by creating and destroying DAX devices in specific
+		sequences and looking at the mappings created.  UUID of this
+		extent.
diff --git a/drivers/cxl/core/extent.c b/drivers/cxl/core/extent.c
index 6df277caf974..3fb20cd7afc8 100644
--- a/drivers/cxl/core/extent.c
+++ b/drivers/cxl/core/extent.c
@@ -6,6 +6,63 @@
 
 #include "core.h"
 
+static ssize_t offset_show(struct device *dev, struct device_attribute *attr,
+			   char *buf)
+{
+	struct region_extent *region_extent = to_region_extent(dev);
+
+	return sysfs_emit(buf, "%#llx\n", region_extent->hpa_range.start);
+}
+static DEVICE_ATTR_RO(offset);
+
+static ssize_t length_show(struct device *dev, struct device_attribute *attr,
+			   char *buf)
+{
+	struct region_extent *region_extent = to_region_extent(dev);
+	u64 length = range_len(&region_extent->hpa_range);
+
+	return sysfs_emit(buf, "%#llx\n", length);
+}
+static DEVICE_ATTR_RO(length);
+
+static ssize_t uuid_show(struct device *dev, struct device_attribute *attr,
+			 char *buf)
+{
+	struct region_extent *region_extent = to_region_extent(dev);
+
+	return sysfs_emit(buf, "%pUb\n", &region_extent->uuid);
+}
+static DEVICE_ATTR_RO(uuid);
+
+static struct attribute *region_extent_attrs[] = {
+	&dev_attr_offset.attr,
+	&dev_attr_length.attr,
+	&dev_attr_uuid.attr,
+	NULL
+};
+
+static uuid_t empty_uuid = { 0 };
+
+static umode_t region_extent_visible(struct kobject *kobj,
+				     struct attribute *a, int n)
+{
+	struct device *dev = kobj_to_dev(kobj);
+	struct region_extent *region_extent = to_region_extent(dev);
+
+	if (a == &dev_attr_uuid.attr &&
+	    uuid_equal(&region_extent->uuid, &empty_uuid))
+		return 0;
+
+	return a->mode;
+}
+
+static const struct attribute_group region_extent_attribute_group = {
+	.attrs = region_extent_attrs,
+	.is_visible = region_extent_visible,
+};
+
+__ATTRIBUTE_GROUPS(region_extent_attribute);
+
 static void cxled_release_extent(struct cxl_endpoint_decoder *cxled,
 				 struct cxled_extent *ed_extent)
 {
@@ -44,6 +101,7 @@ static void region_extent_release(struct device *dev)
 static const struct device_type region_extent_type = {
 	.name = "extent",
 	.release = region_extent_release,
+	.groups = region_extent_attribute_groups,
 };
 
 bool is_region_extent(struct device *dev)

-- 
2.49.0

