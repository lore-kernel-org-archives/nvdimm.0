Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 088F919C558
	for <nvdimm@lists.linux.dev>; Sun, 13 Apr 2025 22:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744584725; cv=fail; b=NakTxLkhTvNWZLvcCeHCgKX9ryGaNWcQ56TTv6xGqC4NzY/2rfoT6mBV7g2mUL8BBXC21xWOTgsYPnN+nlARJz0T1YZQRzVk1uUvc9fAFuPcigglDpFvBVRS99ivIt0Pxewkq7XTPlpAlDB4jesNLg3EIu7qymfoWAXv2+xAFTU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744584725; c=relaxed/simple;
	bh=TdJg89owSQ09YHez2+5qf+RnBC3Budv6uZ6C5fSYAY0=;
	h=From:Date:Subject:Content-Type:Message-ID:References:In-Reply-To:
	 To:CC:MIME-Version; b=CD3EGM4xodYY9pisEb4dxl5SLlZ1hBqoW5eVe3szNo9MZ+Dqxy6/5usnH1+l+RpnrtcusbGAFEPn/Zc9vUOWgEJDyemP5vG1YNQCG4XCfQ2l8DRzsy0Xr/9P+DmvLnibC5hhjAWzKfhBXF5Oxa9cnZJCEmdJoJbGOjL9FUFpDgU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hYffbEKi; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hYffbEKi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744584723; x=1776120723;
  h=from:date:subject:content-transfer-encoding:message-id:
   references:in-reply-to:to:cc:mime-version;
  bh=TdJg89owSQ09YHez2+5qf+RnBC3Budv6uZ6C5fSYAY0=;
  b=hYffbEKi645vUf6v/TvdkYDXgLoDUDOQZAgmh+Wo3pmQm6ELarjJWlWm
   6mbYHJIjE3mMbQnm5xY3lumZCpQodAicKSwTYDZVvKI5zzYKay06/Dlep
   mGvaTsXDeWdUUL3XLyweywKACgpIIr5f/7oK+oAs8Db8Dmj/5oA3W7+Ui
   z74qYPU7YwFlwbbMaGRO6vcWMXX5A4Tk0p6suvQXpL9NIT6ACkJI/vgVT
   7DfIwWZoexlET8sn8CI62z+0RR3/gEBJGl8Wa2SgHMzU41LT5SdzI8haZ
   873X4PvsgftixXO1SBXkJliIKJK1HYu6QBDfsg1iaN3snRgwZIbRl0UPY
   A==;
X-CSE-ConnectionGUID: QdHIq2jmRjyC6UW/tlhxXA==
X-CSE-MsgGUID: kYkqfBkjTJaMARwq8THesg==
X-IronPort-AV: E=McAfee;i="6700,10204,11402"; a="45280901"
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="45280901"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2025 15:52:01 -0700
X-CSE-ConnectionGUID: cw9qAucuTI2MxsEE9TmFfw==
X-CSE-MsgGUID: R7Vezj7yQ8ijVOd8oT602Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="129657443"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2025 15:52:00 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Sun, 13 Apr 2025 15:52:00 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sun, 13 Apr 2025 15:52:00 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 13 Apr 2025 15:51:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eBQaFRjOMLZaAKTugbGzGxbqDEMSIEevlin4ZoQ69Skwzg6WfIihHzEvfS1cIL4KmSGF+Q8QRiPyErSo7m/cotiDMaSLS8vnHQIeEFY7aODDnhmv3X5TNywPa0ucv6AAh522BH8qcRMsM7Ij54Ah8YZ0k//s7CDP0lrujKNrGjaZ3BzCn+dzPSiIVqOBm3k2owyeOGWdJCezV/Q2ohVo/KwcwazS0aDlWmvn8ffA91V0UXK/P1M0bH/pqzWUEkE8fyx+msAnxfCdxDgK10W3HlbzqPbmKtcHK5WffLVGcCCULalo8xr/oyqO/eGS5dLJLns8//u6GsnyTlf6Y0HDBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zpWif/CnuOIudWRzPn5nWqW7axZb6SRcXPd+Zv+hJJo=;
 b=M1BjPQ1leSW9dUq652ZbZIWjq+EN5BjJE6osGwBIy5mRoqa/99l31NF/M1AYaMgwzKYKRsV6A8PiLCvH5zFTYAKZ8TeA3crMQmDKEKraOKTLc/ne93pRNVqQy2f+n2FsEfzo2yg6aZRgEQH4RNVGEMDbdcNKf7IF5M7yy/0g1S8w0ewLeEtyNpIs9djoRAWw80ZHOg2QTfu/1m3lBbJeQnNL8b7HtiBwRHENw2BVkbmxie4vBaav8qjgrthZ1VnFaIM14KC5Km3R1wjYdeUxmDyCMy2NUWNWSUmXLVMXAkgjYpVYzVyYqI/pV4+hxzNhpIpyFU9ktdjKUypQlc+EGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW4PR11MB6739.namprd11.prod.outlook.com (2603:10b6:303:20b::19)
 by DM4PR11MB6042.namprd11.prod.outlook.com (2603:10b6:8:61::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.28; Sun, 13 Apr
 2025 22:51:50 +0000
Received: from MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24]) by MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24%4]) with mapi id 15.20.8606.033; Sun, 13 Apr 2025
 22:51:50 +0000
From: Ira Weiny <ira.weiny@intel.com>
Date: Sun, 13 Apr 2025 17:52:13 -0500
Subject: [PATCH v9 05/19] cxl/mem: Expose dynamic ram A partition in sysfs
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20250413-dcd-type2-upstream-v9-5-1d4911a0b365@intel.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1744584735; l=5374;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=TdJg89owSQ09YHez2+5qf+RnBC3Budv6uZ6C5fSYAY0=;
 b=bYaZ8kzJIjb8F8TRq5BXse1Q94wKep+lL9bHykZ8N+OJ0h4nKYHFt6wGA7a7K6RPoLilfcLqD
 R47OVHjjVT4BOdGO4lMq24TVqNMRpIdQCV7KvHoihEDvEA3JoSLld4q
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
X-MS-Office365-Filtering-Correlation-Id: 22ed960e-0423-4f3c-0fa4-08dd7addc71e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?YzBrdHZsWHM4OTROci9LSGhObXMyVG44WDROY055R2xIa0N2R3poSi9JOEpn?=
 =?utf-8?B?Q2xMMFBpTUZRTlJnQnB0bjZpMElJRUcxSnQzK1ZRTDFFV0Y5dXhUai9UNlJY?=
 =?utf-8?B?b1lBaUNlcnRZUFVmY1VSK01xeHBmRTZnNnpsUG5VWjE5UkVveDhHSThhVldF?=
 =?utf-8?B?UXJmM0E2Y05sM2c2bEZST1E1bGtLa1p0d01CSC83UmlKVlRZNXFnd1RQM1Rz?=
 =?utf-8?B?YlIwMit4TUJBb1UybWtyeG1RbldRclRIb1lNL29nRDEyaWVYWUVxMUUyZWhS?=
 =?utf-8?B?b3ZUWjNIR2M1WDI1OFhqc3BEYU1aTVQySCsxdFh2bnBKUXRsWllVS0FLMzNs?=
 =?utf-8?B?NkR1bUh6RXFxRDBsejBUV2NmSW9paDdzNHJkSTlnZlFudk9ZREU1Z0x2Wndk?=
 =?utf-8?B?WVZDOEgyNlU1c2tIS1ZTMXpEcXFpWGo1NHlDZDZPeWdmSUcrUDFVenoxL0FO?=
 =?utf-8?B?WWtwUnRBZElJalNONkw5NldJVmtkZTA4T2didS91eWhKRnd3Tjd5dnZLWkhZ?=
 =?utf-8?B?bkd2Qk9vSTNicllBN3pyTHp5WmlYYjdkWHZYRUdHUERLWU4wVmw3MFc5dkND?=
 =?utf-8?B?ZWFlWnpDbE9FMGRMcGZXZFhJL20wRkN3bXlOcGFIM3RYdDY2T241UEFCTWQz?=
 =?utf-8?B?U3RFcEdtWmM5c1JuL2xIQmozV3IwNlQ2bFFvNkRiaXNQTG9qTUNIdkJNZlFj?=
 =?utf-8?B?NkV5bDlPQ3VDcXJaa1c0VWJpbjNwZlArbzFJVFlDVjNMZWZEakk4WkJ3UmVQ?=
 =?utf-8?B?bnR2QW4wbm5EUWZMUHg4dm02My9qdTZkcTM3NTI2ZzhjaEl6WXFlMG5mRGJm?=
 =?utf-8?B?RkdMekVyanRJVlBic24vbTM2K0RSb2Z1czhBVnRCUkNiTlBReVVkb3pTcHE1?=
 =?utf-8?B?dkE0anhMcy9vUEJqNlBYRjBqaW11SHdmUTNEWk1ndWhLT2h1VjhRaUs4VGtK?=
 =?utf-8?B?Yk5yd2F0d3VjVVZuNkxqNjRTR0V3MXJYZmlhMEV4Rk90TlM5QUs1K2EyRUNW?=
 =?utf-8?B?Z2d3RTJ2UzNCaGRUN1p6RUplQWFhTytseVpNM2w5MGExWDQ4YjRCdGtTZFhy?=
 =?utf-8?B?L2xwRWt0d0ptOW1ucDBZNTQ3QTY3NHkybWN0bHoyQXVZa0IwVWFjck0xdWxX?=
 =?utf-8?B?S3VOM2NDSFNWUmE2cTlkM2NmU09MbWtsdnlOdnRGYkVDcVlOeHlDNkNCaDRo?=
 =?utf-8?B?S1hXSUFzN2hKR1prOUs3WDFCb1IrckNRbWNOWUdCaUprRmNTSjJ4aWM5ZEFG?=
 =?utf-8?B?L2pSNjRzV00rOUxwTS9ZMWFoZmR0OWlyTktKcXZCb2hDc2N1UlFGSGVlUnpx?=
 =?utf-8?B?dFZOYlg4eFFYNHdDUHY4Z043UUNsRnRFWE4vRTZxSGZ4NDhFUkpnK0hsQVY4?=
 =?utf-8?B?L21QRHJtSCtvYzMzTkFVSU1nc3NhS1hFNEV5Ukdod2I5SUJRVmswc2E3QWZl?=
 =?utf-8?B?WWNjeVJFSnpKRmszVTlGcFBCcTZsUjRVbG04Q2VCZk1ndnVaNFVkcExPRUtV?=
 =?utf-8?B?QWd5WnZrR3pIcjN0amhyWnF4QmJFUGIxYTRvT0hFdkFYZzFlcTczd0pjMTNt?=
 =?utf-8?B?SVY3MWZXWG1KL1dtcEFuS3pWa1dYUkJPeGY1TGxMSnV5cUhHNmN3cW1wcEdK?=
 =?utf-8?B?UzYxaFRLZU5rOElzTnBySUZ3SE10WUhtRU1yZWxhMk5VVGJOSkQ4UGdqMjda?=
 =?utf-8?B?dFR6WEJpYjBLR082UkN5NUp5bFlITVlPdEg3M3ZjYjAwUk92OVNTWStnQW81?=
 =?utf-8?B?cnNrRTUyaXNZeWRCaFIxcm5iOWFaczdDZ0FLSlY4MTN6MlYyN0E5MC9FQ2Zr?=
 =?utf-8?B?SVJvaUlVZW0yamJsN1JtL29NcDcrL3plcVY5SUY2N2Mra3JrRzZpNFFRaktt?=
 =?utf-8?B?T0JDUmh2TU91MnpTRVdGWUxFTGR1MWRNQlRaZ2o1akk5aS95UzZyQnpSRHY2?=
 =?utf-8?Q?OrtUc/+5Hyc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6739.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aEIvNit2bjdBc2tVeUVzcC9JV1BOanB3ZW5IM1FMVVprWWVWdkZWYVBQbWRo?=
 =?utf-8?B?TEowQ0doMnVXaityNDZvOFcwb0VZVktjc05KUjFxTlk5bU9hTlJuMTdidjNU?=
 =?utf-8?B?aWNhWFpPM0xoWGl4elFJY1pNV2wzMFZaajJtTE45dUs4amxlNUlaWERvR2VO?=
 =?utf-8?B?eXVqdDRSQmsvMHVlZy8wUkM1bFhXbFlLMEwxL1NibFFWaEY3SE1FaHFBMXIr?=
 =?utf-8?B?R0hNeWpJbjRBRlJhT3dqd0JDYWZOY2tGY1ZjcWM0aDJ4YXEwdHBKOXBxZVcr?=
 =?utf-8?B?SzBLYUdTRjQrRmt1Z01pdlVwVy9ndWpxRUVvM0RaNkM3V2xsNHBaeG5BQUda?=
 =?utf-8?B?SUJIV2hPVVgwQUVpeGdlSEFhc2FpKzhORXlWeDdnWDBlcWoxN2Fvbm13VmpH?=
 =?utf-8?B?Z3JhdWlxVCtYWDdmSkJZcWdsUGVZRmJTVTc1encwUitPZjNWVXcxOE5lT3Bp?=
 =?utf-8?B?MkRiZUd4STU4ZWdiYWpSdzE3NDBzck1hV3ZTMVI0RnQ1Y2p6VUNFSE43Wlhk?=
 =?utf-8?B?SHovUndTRWl0bW5qYVRJMHBtRksrMVFaMHVlQzVNeW8rNm1JTVpsWjdJTnps?=
 =?utf-8?B?S3E2SnlSRG9TNlRFRGxpUTEwVWZmNEwxUURDcTh2d05jMFNLQzFPQXUraUtU?=
 =?utf-8?B?TThvcm5YelFkU0xaMEVsSksxa1d3RzB0UktVSEVmYU5rZG9TM0tDT3ZPNlM2?=
 =?utf-8?B?OGxsTCs2RHRqZ1o2ZUhCTFZmVmIxSTRjSFZ2TjJRNzB6YUdwc2swT2V5c2lQ?=
 =?utf-8?B?TWlvRTVSazNRVFZPYk12TXR2emhqSXVhb3VHdUVYT3ZQWjBjSDhUMlpCTEpE?=
 =?utf-8?B?YVMvaW9rMG9OTVV4QWlRTndwcU43dEMxZEE2MVRRNVcyWTBnSE9XQ0VsbFVU?=
 =?utf-8?B?VWJLMnQ0ZDdNN3h1YzhNZEpyNWlqaEhEdEM1UHdPTkFiRENlV1FpaCtkNTJ0?=
 =?utf-8?B?clh3SWYyenNZK1FDQ1I5cUlkZlhJQW9UWDBGS1g1TzMrb3orNmkwd2txYmJB?=
 =?utf-8?B?VDQ5TTlJbzIyVTNEdmxDMWJMQlFibXJkVGZ1VUlYUlp4ZXV4RXhqR0JCTHpO?=
 =?utf-8?B?YlZ1VVByekxzK3JUVEU5NWZDTW1MRXJKRGxIVVZLMFA4YkJzVXp5Z01FNDF4?=
 =?utf-8?B?Z2E0SGV0bHdLRWlVV2tWUm9CQ05TMzhaK0F5R2xsMHpURU9xWFgvWnR0WlVx?=
 =?utf-8?B?WklGRHEyc0ZQaWlvQnZmOXpjbVZxaUh5elNac1NFZTNRY2g1RjgyRm1YUE96?=
 =?utf-8?B?U2VWNmhsWFZMWmcwOFVYY3JmUWR6ckowSm1lRXBYTFh1OVBqeDlMbTZYakMr?=
 =?utf-8?B?cFFJQUpkTU5nRzI3OEgyQThWSjRaZWJOSXN1OVRvQkIzTVZQdkRYTzVPcTBm?=
 =?utf-8?B?S0ZNUjAwK3I2NUJrdTJmVEVqQStHMnZhTjZlbWVkMkxVNDd5Y2lKMUhISHJn?=
 =?utf-8?B?Z09BdXpsdTUyTDJxaEpqR1M4OVRpOFNZeG52bTBFOTBReUxsUHhLYWRwYW5C?=
 =?utf-8?B?by9zZHZ3RHpiUDVBN01tN084elVIQ3hSVGRWSE5RRUU3Q09Bc1Z2NTdCK3N2?=
 =?utf-8?B?dWtiMlNCOEhVdTZpbVlqVklsUFIyOHBRY2RMc2JXNUVkMVdvZ0lFSldZOHVH?=
 =?utf-8?B?SzJuaGpCb1VodytSY0FhTklVS3oxVTBxaHJmY2pETUpvRUxBRlhuU2ZJRmow?=
 =?utf-8?B?TUdXTmVWR1lHSlBpRUxtRng0a0QrWXRQR3JaRkhGWHZPSGhheGJBOWdFU0hr?=
 =?utf-8?B?eUVJZWI5K2lBcmg4M1lYWG5zNUNzOTd1RGxDZjM5VldZOTZjZDhOMG9XTFF2?=
 =?utf-8?B?MXRvOHNTNUFueTFFZ281MU03NmFuRUQ2Y3hxR2ppam0yVUp6VFN6Um9pb213?=
 =?utf-8?B?elJ3U3pUOTRLTC9MeUtmNVVacGZseVhOVENHT01IazNkQVhELys0SVVRVUhk?=
 =?utf-8?B?ZTQ1U2FrUlZzeW9jZmNvVTYxeENtQmdZTVhPWHFYQzF0NEYzSGdGck5MN2hj?=
 =?utf-8?B?dFJvVGszYWF2ZHpBOVdDN3VvZysxZTUyeDBOTEZKdXY3Znk5RTVnTVhCRTM5?=
 =?utf-8?B?dHhlN0pTK25OS3VHNmV5Ymo0MUtjOEpSU00vZ1BaMzVkUDJrK2ZyS0FpZGhN?=
 =?utf-8?Q?JEwShftjc9ycBc2hlNWziK7Hd?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 22ed960e-0423-4f3c-0fa4-08dd7addc71e
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6739.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2025 22:51:50.5782
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s89zLihhIQAAQ/wHPymdfRXuw1qTU4e5TIr+nG/ncRTMlKTlWrno2qPgke8hv7OqQaJ2o673ztDowHLCyV9ZKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6042
X-OriginatorOrg: intel.com

To properly configure CXL regions user space will need to know the
details of the dynamic ram partition.

Expose the first dynamic ram partition through sysfs.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes:
[iweiny: Complete rewrite of the old patch.]
---
 Documentation/ABI/testing/sysfs-bus-cxl | 24 ++++++++++++++
 drivers/cxl/core/memdev.c               | 57 +++++++++++++++++++++++++++++++++
 2 files changed, 81 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
index 99bb3faf7a0e..2b59041bb410 100644
--- a/Documentation/ABI/testing/sysfs-bus-cxl
+++ b/Documentation/ABI/testing/sysfs-bus-cxl
@@ -89,6 +89,30 @@ Description:
 		and there are platform specific performance related
 		side-effects that may result. First class-id is displayed.
 
+What:		/sys/bus/cxl/devices/memX/dynamic_ram_a/size
+Date:		May, 2025
+KernelVersion:	v6.16
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		(RO) The first Dynamic RAM partition capacity as bytes.
+
+
+What:		/sys/bus/cxl/devices/memX/dynamic_ram_a/qos_class
+Date:		May, 2025
+KernelVersion:	v6.16
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		(RO) For CXL host platforms that support "QoS Telemmetry"
+		this attribute conveys a comma delimited list of platform
+		specific cookies that identifies a QoS performance class
+		for the persistent partition of the CXL mem device. These
+		class-ids can be compared against a similar "qos_class"
+		published for a root decoder. While it is not required
+		that the endpoints map their local memory-class to a
+		matching platform class, mismatches are not recommended
+		and there are platform specific performance related
+		side-effects that may result. First class-id is displayed.
+
 
 What:		/sys/bus/cxl/devices/memX/serial
 Date:		January, 2022
diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
index 9d6f8800e37a..063a14c1973a 100644
--- a/drivers/cxl/core/memdev.c
+++ b/drivers/cxl/core/memdev.c
@@ -101,6 +101,19 @@ static ssize_t pmem_size_show(struct device *dev, struct device_attribute *attr,
 static struct device_attribute dev_attr_pmem_size =
 	__ATTR(size, 0444, pmem_size_show, NULL);
 
+static ssize_t dynamic_ram_a_size_show(struct device *dev, struct device_attribute *attr,
+			      char *buf)
+{
+	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
+	struct cxl_dev_state *cxlds = cxlmd->cxlds;
+	unsigned long long len = cxl_part_size(cxlds, CXL_PARTMODE_DYNAMIC_RAM_A);
+
+	return sysfs_emit(buf, "%#llx\n", len);
+}
+
+static struct device_attribute dev_attr_dynamic_ram_a_size =
+	__ATTR(size, 0444, dynamic_ram_a_size_show, NULL);
+
 static ssize_t serial_show(struct device *dev, struct device_attribute *attr,
 			   char *buf)
 {
@@ -426,6 +439,25 @@ static struct attribute *cxl_memdev_pmem_attributes[] = {
 	NULL,
 };
 
+static ssize_t dynamic_ram_a_qos_class_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
+	struct cxl_dev_state *cxlds = cxlmd->cxlds;
+
+	return sysfs_emit(buf, "%d\n",
+			  part_perf(cxlds, CXL_PARTMODE_DYNAMIC_RAM_A)->qos_class);
+}
+
+static struct device_attribute dev_attr_dynamic_ram_a_qos_class =
+	__ATTR(qos_class, 0444, dynamic_ram_a_qos_class_show, NULL);
+
+static struct attribute *cxl_memdev_dynamic_ram_a_attributes[] = {
+	&dev_attr_dynamic_ram_a_size.attr,
+	&dev_attr_dynamic_ram_a_qos_class.attr,
+	NULL,
+};
+
 static ssize_t ram_qos_class_show(struct device *dev,
 				  struct device_attribute *attr, char *buf)
 {
@@ -502,6 +534,29 @@ static struct attribute_group cxl_memdev_pmem_attribute_group = {
 	.is_visible = cxl_pmem_visible,
 };
 
+static umode_t cxl_dynamic_ram_a_visible(struct kobject *kobj, struct attribute *a, int n)
+{
+	struct device *dev = kobj_to_dev(kobj);
+	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
+	struct cxl_dpa_perf *perf = part_perf(cxlmd->cxlds, CXL_PARTMODE_DYNAMIC_RAM_A);
+
+	if (a == &dev_attr_dynamic_ram_a_qos_class.attr &&
+	    (!perf || perf->qos_class == CXL_QOS_CLASS_INVALID))
+		return 0;
+
+	if (a == &dev_attr_dynamic_ram_a_size.attr &&
+	    (!cxl_part_size(cxlmd->cxlds, CXL_PARTMODE_DYNAMIC_RAM_A)))
+		return 0;
+
+	return a->mode;
+}
+
+static struct attribute_group cxl_memdev_dynamic_ram_a_attribute_group = {
+	.name = "dynamic_ram_a",
+	.attrs = cxl_memdev_dynamic_ram_a_attributes,
+	.is_visible = cxl_dynamic_ram_a_visible,
+};
+
 static umode_t cxl_memdev_security_visible(struct kobject *kobj,
 					   struct attribute *a, int n)
 {
@@ -530,6 +585,7 @@ static const struct attribute_group *cxl_memdev_attribute_groups[] = {
 	&cxl_memdev_attribute_group,
 	&cxl_memdev_ram_attribute_group,
 	&cxl_memdev_pmem_attribute_group,
+	&cxl_memdev_dynamic_ram_a_attribute_group,
 	&cxl_memdev_security_attribute_group,
 	NULL,
 };
@@ -538,6 +594,7 @@ void cxl_memdev_update_perf(struct cxl_memdev *cxlmd)
 {
 	sysfs_update_group(&cxlmd->dev.kobj, &cxl_memdev_ram_attribute_group);
 	sysfs_update_group(&cxlmd->dev.kobj, &cxl_memdev_pmem_attribute_group);
+	sysfs_update_group(&cxlmd->dev.kobj, &cxl_memdev_dynamic_ram_a_attribute_group);
 }
 EXPORT_SYMBOL_NS_GPL(cxl_memdev_update_perf, "CXL");
 

-- 
2.49.0

