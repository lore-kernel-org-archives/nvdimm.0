Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 869071A314E
	for <nvdimm@lists.linux.dev>; Sun, 13 Apr 2025 22:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744584725; cv=fail; b=gZno8HhAfvcxqKVtHgBh/sBYnlOJhjqyZcbkP3YhQsUYhYVsbjPNtrs4YIk/i52R8zcqBXeD8jPxsGm4LkNSAFuJPSBJWY0hunmo/5X6KK3dQfaHoYMe4N+FDGx7ldWkAn8+ZC/qoTGR8MeuKkxJBerb2SDr8Ww7G1Hcuf0ld+c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744584725; c=relaxed/simple;
	bh=ubkszuk8OOj91HHaqwNgXvdiZweiDuzDaFgiJyN6lDo=;
	h=From:Date:Subject:Content-Type:Message-ID:References:In-Reply-To:
	 To:CC:MIME-Version; b=n085m+kwF4tySG8e5ZGylGl0KANmlJPizYWzJ57GwbdcwXTB/R9dWzaAJrZQnCBAKinYIEWVoKh+DU//XLYi0GCm+D5/fE7gomIKFLBkSPicM5/U+DXZ3vzh50wLa73s1sMzju/Ug49xOCs9IK8deUCavdTCWZXD7cqPxg7FZuk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aUK0rlOs; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aUK0rlOs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744584724; x=1776120724;
  h=from:date:subject:content-transfer-encoding:message-id:
   references:in-reply-to:to:cc:mime-version;
  bh=ubkszuk8OOj91HHaqwNgXvdiZweiDuzDaFgiJyN6lDo=;
  b=aUK0rlOshktwjIYx0iSfbYu8lHU6qfL3U32+EKSGTM7j75ujoevPrAYU
   cuKnPDFCYfQdCg11rTALXCnapLWEJbZgAEFJKcT00vMj7VpRAbP6vNrg4
   h7omMhAfauBeQn/IDxXJtq/aDqZoZYU7KO53qfaQXqxApQCjxschDRcvc
   zNXXJ7CgZ2gp/6VaCZzS3d4BIA95PCctoJDhI3SMb0xkZpgWPBLc4n/9o
   cRUDvzey2mB/keU81wYTdVEjcobYAljhn44JTbk/ZOUk8zCQc2ca1PeCL
   I+vqIOSI300U0oI1D6nHsJCsN0mDZqGq3FB1IbjGOlpoDGvy/OUZgw+80
   w==;
X-CSE-ConnectionGUID: PFmHxcsIRMqmLBm61JSSPw==
X-CSE-MsgGUID: LJ3wwJtrTt+VOCjHo9cPMA==
X-IronPort-AV: E=McAfee;i="6700,10204,11402"; a="45280906"
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="45280906"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2025 15:52:02 -0700
X-CSE-ConnectionGUID: Xh9v8XCLSDC5H+iLXuSEHg==
X-CSE-MsgGUID: tplrpwWXRu+e+PeQyBnsDw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="129657453"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2025 15:52:01 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Sun, 13 Apr 2025 15:52:00 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sun, 13 Apr 2025 15:52:00 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 13 Apr 2025 15:52:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jZ87yonip5Zz+nSBkTMAQ1A08Ic1A3xjIjSc+uwBUMC8Z7Xye9uCtHgbOo9Mai970eCbCvDJGY5RRUd9Vywp09NCrF+wIlPZdrxL5isKZu8grSflZpD3VTz3RaxDOhh21qQLamZa6qB4F4wgPtapo99XTEf/KySYhxAYixEcAD8Dsq4YIOLtV3Zv156F8uZ71UfU9hHQhNngDbgSMIkEb3Bf8PBiyeLLlcvq1OJ0Y4PKcbzW9V3xP6CdFX71D7Ua7vlhhHpCF8Aof8GJtDWSbtVGtlj7Tcuffngv6oD1ghNwTr3Fp3bT9nl+KWOGOWHZ7HmNzBlHL9bKD55vnKlucg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rQK0+O4GqSKPKOs9Sr/fszqYqvtsWCSqVUxvStUxO3E=;
 b=AzmljhdD6N+PfDkBOMNznhWXnGuM723cqfxOdsr9HWTfHBwiEzT9AuLvN5f5FLZFjV27p9Q/DUPtdT1PrflKuUpdgFT3ZIoGTCcxRXqsUAAL00FVMziaTLxlx2en2lCqsS9tyoNo7C8mg+1dMj7FZn8nC6GaohBLeh4yf4h+PaFVIJiDbjLHj9+o6Ynx+d5dva3JyIaPU2AtP+XVtLTgAD9thGBK8Ytl7ePOEWzWly0uZhhvI7V/pwTuRZaPV6i0QaDR5+65iPRUZPceNnTqZsp6PuTnMRG/4lStrW2oq/3NWfbWMwE3LxNeFX1VBVoEeqGErFIqwtCJRy9f72wrVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW4PR11MB6739.namprd11.prod.outlook.com (2603:10b6:303:20b::19)
 by DM4PR11MB6042.namprd11.prod.outlook.com (2603:10b6:8:61::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.28; Sun, 13 Apr
 2025 22:51:52 +0000
Received: from MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24]) by MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24%4]) with mapi id 15.20.8606.033; Sun, 13 Apr 2025
 22:51:52 +0000
From: Ira Weiny <ira.weiny@intel.com>
Date: Sun, 13 Apr 2025 17:52:14 -0500
Subject: [PATCH v9 06/19] cxl/port: Add 'dynamic_ram_a' to endpoint decoder
 mode
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20250413-dcd-type2-upstream-v9-6-1d4911a0b365@intel.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1744584735; l=3257;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=ubkszuk8OOj91HHaqwNgXvdiZweiDuzDaFgiJyN6lDo=;
 b=PqrpuoOgqfEFIv5Kmfg2/Jpcf6p/+KUEk1ohlJOdVsWF+mMLc/Dtjg2VYYzjPMSOZX5GjI+pY
 XENW8xJ4pD/BPaI+4OsCHUdn12rI5HJccuek6nFn/yuQs+M8l0hIKy2
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
X-MS-Office365-Filtering-Correlation-Id: d62e3194-dadb-4df5-6767-08dd7addc807
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZVlHWFFPQjhYS21pOVYrMkVUT0lyL1ZKc0E4YjMxTHFsZGpBVUtmT2hDOFFM?=
 =?utf-8?B?RTlXaFl2OThZazduSXRMMGNnV0Z0TFJYQitFSzRoWWJOTDloOWROTnp3Q29O?=
 =?utf-8?B?TnpRUkxBL3A3UW1IWVlUSGdURFo4aEx1eDJ6OUt3VmtGK0x4TzlkdzNnYmov?=
 =?utf-8?B?eElRcG9kdkdxMjZKcEVpQnFxUWo2M2lPUWNlUnlsc2JuT3dhemFoQ2xxMWNO?=
 =?utf-8?B?SFFRWG54aGRwZmdYSzFaMER4ZkVWclEyRDBwYnNXQnNxeHF3YTRHTDNNZDJW?=
 =?utf-8?B?djkrcFZkOUNxN2UzdVBkaVFEVDA0aGpmc21HNCsyVDAyVi9jdGs0WU5RdXNn?=
 =?utf-8?B?aXdUZ2o4ZUtEQWhZRUxyMUpiR0ZrT3p1STdYOUtCTTdIeElUaDhPMFZhVXA5?=
 =?utf-8?B?amlENDhFYnU3cnVFZGVhc1pEemxXZ28zdElHM3Y0TlU4d3QyTkNqeVZzTHl4?=
 =?utf-8?B?djA0NnlqQkExS2g4VVhocmRkanE5bElCOFNPS0tCTFR0ZWVOcG5LOXYyTXZU?=
 =?utf-8?B?WnpMTVp4aEFadnZUWkhKV3RUUFcxQ0FuczdUbm9sZXhYVTB0ZXg4WHVkWGhL?=
 =?utf-8?B?ajBCU2VQLzNqU04yaGVobFNvRUFpNlB6TDlHamp1V01yWEEwcXB2ZDVLVnhM?=
 =?utf-8?B?L3lCaGtWbWpBWERQSWhDY0ZHQms1TkY1ZktjY0FqR2QybGhPNmQ4WXcwaWNk?=
 =?utf-8?B?UnFmM01xcmxPWDVpRXhUV2Z6ems4WHl0VjhaYzI2Zm5pek5hSHJuTmtEWDln?=
 =?utf-8?B?WkdDWU5VVTNtcTM1TDdoV3BYK0RCR3REUUlzSEFVSkx1R0ZER1duL0I1MnFv?=
 =?utf-8?B?a0paK3dyRm9PKzdCT3cwYTdRT1VBZEczemhMTFFUM3lmM0h0WU1kT2x1UXg4?=
 =?utf-8?B?c0M0SDRFR0xlSk1UMFBPMStyVWg5a2hKQlpUZXhVQlgyNTlUQWJESGl2cWM0?=
 =?utf-8?B?TTU0dTVtUW1ydEJjNlh1cnNQdTA3ejFFMXRKVWpWSGwyUXVVc0dzR2Z0Tm9i?=
 =?utf-8?B?RVZKdUJpL3dqc1dxbmYzU2VHaE1qcXFESUJob1VzSEhPaXFLbjNIcHhHbXJv?=
 =?utf-8?B?ZWh4NFFzUHNrYnVhWFQvMHl1ZithUEQ2SUpQYlVXSnBTTnkxRUNqdEVIUWpu?=
 =?utf-8?B?SHNVUm1pcGNBWVZvSEZ2T29ZWFB6NGNsZVMrbGtRUG1TVkJkcS9CNlRxT1pW?=
 =?utf-8?B?UmxlTEJsSGlJcmN5Q2ZpUlRxeVBBVm5PZ0c5KzFPYWFnS1o2ZlNwc3owL1hz?=
 =?utf-8?B?WHVrU2lZbWJOK2l6WnMzTnhOaGJXUWtDbHpjaXNiVE9sS2lHamJCYlFkREdz?=
 =?utf-8?B?TmxjYnJpUFpmbjd6YlhSRnVSSkJSWU5EV0JvbXdoUjVZbnpVaGIwYWRRbVpv?=
 =?utf-8?B?WExYWnlpdkt0UEJTK3NtampJaWhyQlExZWVhOC9VVEJsK2l0M2pvVUlMZ0hy?=
 =?utf-8?B?aTFac0JCUzJjeElDYlNsbXVPNlVGWGRDN0drUGxrMm1KSUt4eFV6SnpVQ0xG?=
 =?utf-8?B?ZXZOSWhlNS9WREZyOTNFdTdTY3drSUJVbU0vTWl2WFVXR0JRWmV4YUdCTWt4?=
 =?utf-8?B?RjBvRzRkZHdlWUZ1RVk1bHdYUzY2K0JWNFRPZHZKYUVMLzNCRmVaaHRwOC9R?=
 =?utf-8?B?UURCRnRpN0FRekFKVnJZOVJGMnhhTFNidUJyYVBSNEJIZW5tZURPaUE3b3lC?=
 =?utf-8?B?MEJldndmREZiYStrZERTbVhuMTNZc1lzajAveDcyUEVZS0JsNWhVZWNDVXpR?=
 =?utf-8?B?VWlCQXZIOVYzSU1ab2xvbE1tKzU1VVE2TFBMUlF6SUVaZXdlcURVdzNXeWxQ?=
 =?utf-8?B?b3pnRmczZ3ppTUFUUWhtWno5TU5EOEdMakNMY1NTTCtaMjRyUnJvbm1ucWxh?=
 =?utf-8?B?bVhZWU05Ymg5TUdVTXV3SVp2VHhCNkh6K09xd3dhb21RcUt1Tm5laXYvSE9o?=
 =?utf-8?Q?HF7R/bei6Zo=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6739.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M0luSm80MWhBRXZXZ0tPRTR5MUZsOXgvZ3dhc0lmcDJ1T0ZoQytwQTVqV1Vr?=
 =?utf-8?B?RllOYitxaVZOV0lDMkVVVERXakZhbG85V1BBUmdIVW03YXhES3dpYm5Jd1kr?=
 =?utf-8?B?WU5EYUY4TDJhei9oTndYNW5XZ1F1c2JUcmpTKzhTNU9WRXJQYURjVGc1N1k3?=
 =?utf-8?B?aGhJZXpZemhWTkxRQ2NFQ3ZlOGtXL3JpR0dhY2EwWUxSczZTend5NW5Lem5S?=
 =?utf-8?B?TnVsZTk1b3hRdmFRNEFwU1dLazU4QmdheWdHbVdiSVF3d0xUMEtaUnZaeGxn?=
 =?utf-8?B?MWxWVmtPNkp6bGxrajVHamJ4cmdIYXBuWk81R0QwNm42Qm1HczUrTkNYQ05M?=
 =?utf-8?B?Tmk2R052dWJnUDBYWEpNMTNUNTN1TVBxVjcwbTlDUTc0aEltOENJem16NVBi?=
 =?utf-8?B?SDlDTWlvUlRQTUhrVXF4SUFCcU1RZWwya0VtLzhoOExRK2kxOUJVOUtIa1Yy?=
 =?utf-8?B?bFN6cUVuY0tHQWI3MW1GMk1RRGdsOXl4SXphTWtLR2d3MlN6Q2Jmb2NEczhO?=
 =?utf-8?B?MjhpWU40bVpiU25GWklBWm82RG40N2NseDF5b20wUVlaOHd4UG5rSVJ1QUd5?=
 =?utf-8?B?YUQrYU5KY2ZKbk9ibEdrYUtCN0o2SEhuUlhlVjVaVHR4cklDVDdHSlltSFNr?=
 =?utf-8?B?MDAyZ2lyckpNS2FrYXJvR0E0Y2pvckpQS0IwMkZvMjgzUGR1MnF0c2V0MHBp?=
 =?utf-8?B?MEREQ1liYWZuUGVlaWYvWnhwVzJnTnBtMHBBVFBLd2gyTVA4b1YzeUpUd1Rn?=
 =?utf-8?B?WWNybmdVOWdqWnhiaUNKMmJ4ZTAyUE1UNWtraXplS3VLUnFSemFLNnlEN3dw?=
 =?utf-8?B?RmlyZGRxc0hsSUVVZUQyZW5veENoN2pvckFPNmM1QUkyYXJLQm55TldsaUV4?=
 =?utf-8?B?dU9OTmdycEc3dFBCWC9yY0NadHdpNWR3VUhsSkdsc2xZb0twckxjUGpCYmZj?=
 =?utf-8?B?TXJvdVppWWtHUTRYM2pSZkowZEc2czNTNFM4cm1Xc0c2bGZ3eTVTOTJDaXNU?=
 =?utf-8?B?VWtlTUlxaDMya0JRSkcvN3J0eHdaRjVvYTlPbHVaVW53M3ozL2dkbjBlcDRq?=
 =?utf-8?B?ZkpJbUxHRFFtY3VicnlXVGxTL21QdXRzd0hCeFNRelpWeVlSU1hwOFNNWXVt?=
 =?utf-8?B?UUQ5bDd4SUM0MkhiKzBMQjRvMkg0ekF0UURxdE8rdlNmUVNDSWR0NlFxRDRD?=
 =?utf-8?B?ZDJPdXZSaUcwWjhCZVI2SzdUTzU2em9XV2pSYlBmU0tTakRPME9PYVRNazZH?=
 =?utf-8?B?a1JPbEY5R2ZCSW9kZldNUSt4UDlIUS9lbFlZWmUzK2JkQkdkM2V2MWJSeHN2?=
 =?utf-8?B?Z2xocWJJRW9VcmxRK3hrSVdNNVNSVm4zY1BrcnBibDh1cDd2MVBqNzJ3NzhT?=
 =?utf-8?B?V3Zyc1YvRlZ5Z1l1VTdmNmg0a0d3NTJhNjkxZ3M5NWlETjd5MUw3MTlvMzF2?=
 =?utf-8?B?cGprOHVIQVlXemFSUW1PeUwzdmpQbHUwNTdkZzJCcGd1RCt4OFc1SEVabUdW?=
 =?utf-8?B?QmlMWWdLK0dRTjBFSDBON0MrYldXeitpcU00emhlNGs3WFBSdWJoUWZSUWF4?=
 =?utf-8?B?WDY3dnlqRkNqY3BmaXMwRGx3bDZrcHR1L2pEejFDYWE2ZE9FWDhodDFxOVhR?=
 =?utf-8?B?UUlZdzdiMDRvclUrN2U2T25pNUh1NTNHQ2ZHTkJ0b2VmWitXdGd0bDRmeDlq?=
 =?utf-8?B?ekZjNUFzbll4K2xKd2FNaHV1NVBBakZCYmV0eDczQ2k2L1hjRUNIMGVFai9R?=
 =?utf-8?B?Z2IzK1UxbXB2Q2xRUUx4Uk9nSmRIZTNPc09nN09sMXhUdU5iNXNLSUtiRkN2?=
 =?utf-8?B?QXhJeVRPckNFQkEzSitIbmVJWm01NHY2SW9adGVGYUYrY291UlNtSjFEdUZy?=
 =?utf-8?B?eFREZjdsbHJ2endIaTFFKzRUdE9rQ2Vpd25TQjdRMlZ5U2xhdFVmSGE4N0Z1?=
 =?utf-8?B?MkE1WEZ2UWEydTFELzlSY2Zvb2NCc2Zmc3lCeE9NTncydnV5WlhqQUE1Zmxx?=
 =?utf-8?B?ZmFaNUpheldWbWNJVnlNMkZkVTNWczZGVEZsWFB4OW8rbjZTU081VXhwYzRO?=
 =?utf-8?B?WGNiRXlxWTE5ekM3ekx2N2ZVTVQvM0dxNDlzMkMyNDdzT0JucUprUUtSTm51?=
 =?utf-8?Q?75Si/VnDXYEkxb3gqT7GcTb8p?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d62e3194-dadb-4df5-6767-08dd7addc807
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6739.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2025 22:51:52.0536
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vCzSVqp9hV1BqoZUQxT3PydRuagBpIaCVKOdyh+ZaSk8XeRan1Or+kWfSL81p0FPIWLz31bCYAribZPavJOy5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6042
X-OriginatorOrg: intel.com

Endpoints can now support a single dynamic ram partition following the
persistent memory partition.

Expand the mode to allow a decoder to point to the first dynamic ram
partition.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes:
[iweiny: completely re-written]
---
 Documentation/ABI/testing/sysfs-bus-cxl | 18 +++++++++---------
 drivers/cxl/core/port.c                 |  4 ++++
 2 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
index 2b59041bb410..b2754e6047ca 100644
--- a/Documentation/ABI/testing/sysfs-bus-cxl
+++ b/Documentation/ABI/testing/sysfs-bus-cxl
@@ -358,22 +358,22 @@ Description:
 
 
 What:		/sys/bus/cxl/devices/decoderX.Y/mode
-Date:		May, 2022
-KernelVersion:	v6.0
+Date:		May, 2022, May 2025
+KernelVersion:	v6.0, v6.16 (dynamic_ram_a)
 Contact:	linux-cxl@vger.kernel.org
 Description:
 		(RW) When a CXL decoder is of devtype "cxl_decoder_endpoint" it
 		translates from a host physical address range, to a device
 		local address range. Device-local address ranges are further
-		split into a 'ram' (volatile memory) range and 'pmem'
-		(persistent memory) range. The 'mode' attribute emits one of
-		'ram', 'pmem', or 'none'. The 'none' indicates the decoder is
-		not actively decoding, or no DPA allocation policy has been
-		set.
+		split into a 'ram' (volatile memory) range, 'pmem' (persistent
+		memory), and 'dynamic_ram_a' (first Dynamic RAM) range. The
+		'mode' attribute emits one of 'ram', 'pmem', 'dynamic_ram_a' or
+		'none'. The 'none' indicates the decoder is not actively
+		decoding, or no DPA allocation policy has been set.
 
 		'mode' can be written, when the decoder is in the 'disabled'
-		state, with either 'ram' or 'pmem' to set the boundaries for the
-		next allocation.
+		state, with either 'ram', 'pmem', or 'dynamic_ram_a' to set the
+		boundaries for the next allocation.
 
 
 What:		/sys/bus/cxl/devices/decoderX.Y/dpa_resource
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 0fd6646c1a2e..e98605bd39b4 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -125,6 +125,7 @@ static DEVICE_ATTR_RO(name)
 
 CXL_DECODER_FLAG_ATTR(cap_pmem, CXL_DECODER_F_PMEM);
 CXL_DECODER_FLAG_ATTR(cap_ram, CXL_DECODER_F_RAM);
+CXL_DECODER_FLAG_ATTR(cap_dynamic_ram_a, CXL_DECODER_F_RAM);
 CXL_DECODER_FLAG_ATTR(cap_type2, CXL_DECODER_F_TYPE2);
 CXL_DECODER_FLAG_ATTR(cap_type3, CXL_DECODER_F_TYPE3);
 CXL_DECODER_FLAG_ATTR(locked, CXL_DECODER_F_LOCK);
@@ -219,6 +220,8 @@ static ssize_t mode_store(struct device *dev, struct device_attribute *attr,
 		mode = CXL_PARTMODE_PMEM;
 	else if (sysfs_streq(buf, "ram"))
 		mode = CXL_PARTMODE_RAM;
+	else if (sysfs_streq(buf, "dynamic_ram_a"))
+		mode = CXL_PARTMODE_DYNAMIC_RAM_A;
 	else
 		return -EINVAL;
 
@@ -324,6 +327,7 @@ static struct attribute_group cxl_decoder_base_attribute_group = {
 static struct attribute *cxl_decoder_root_attrs[] = {
 	&dev_attr_cap_pmem.attr,
 	&dev_attr_cap_ram.attr,
+	&dev_attr_cap_dynamic_ram_a.attr,
 	&dev_attr_cap_type2.attr,
 	&dev_attr_cap_type3.attr,
 	&dev_attr_target_list.attr,

-- 
2.49.0

