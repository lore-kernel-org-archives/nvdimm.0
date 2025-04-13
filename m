Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2EED1A5B89
	for <nvdimm@lists.linux.dev>; Sun, 13 Apr 2025 22:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744584744; cv=fail; b=q6O8NPszz2tH8RIoIElwewk2Rwp3WCPcX+K/65g+P2iLwa6syal5yH0yDqGwkhOaJPUm1XCmDbo4CdRqnrVtUCiPmQhaQJYFGX7kBCv8QqFzsht30du4qezeFsdeNqcYhGXVCGeZKRQ8wl2L6tbN1Yfs1sKyco+aFVhRaPnxsN4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744584744; c=relaxed/simple;
	bh=ObXjYpSXhyIOJclFZabMVwT7Iw3oZ5eWVtgb3/GUyCU=;
	h=From:Date:Subject:Content-Type:Message-ID:References:In-Reply-To:
	 To:CC:MIME-Version; b=Mh1O3g0ejq4P+vPd/bXDzvftJI4E8kPDRU2BKKnjtVTsKrEqZncDP1q7vgwOqyHMVI5RMt2gpLhaD1ePiM3LFMwv/Jz8qNms9dbzPmirpiVfHWhFOu0s2JzoYZ2mIH9QxEUuo33HYtTlEmyDAHZovdr4rZTg6luS2omvt8VpjdQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=heGP9f7o; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="heGP9f7o"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744584742; x=1776120742;
  h=from:date:subject:content-transfer-encoding:message-id:
   references:in-reply-to:to:cc:mime-version;
  bh=ObXjYpSXhyIOJclFZabMVwT7Iw3oZ5eWVtgb3/GUyCU=;
  b=heGP9f7oul1v85wN0FHpMAvhgHKcBsryqOAQ5cgIL5hd7fcE330FRYzI
   3H9AUx9b0eEhvlXqtPloe+fRATzGv8zp2cJNLawDOJzmtgVup/EOdeO6u
   bs5dTtzPMbtE6eKKPi4D08Wy17Z9aETWw5vLy8YwXf9Hof3knAVz6Duju
   ZALGz1NDhF+atlWLk31w/aNaoDTIkqI2KZvRTauz6k30g2GRZMrp3k+gM
   UoyizCV90Kdp/nkSVfgPHE7iSvzsyz0Esb3tZrpOm5u7Gdb62NcaYtCMD
   tTY8JTpXyjnYs9kfyMGLorRWIJUzNBztbIAIt1qdG2migX3IGuYWEuVII
   w==;
X-CSE-ConnectionGUID: zwbzGrVmTK+OLbrkY6Ia6g==
X-CSE-MsgGUID: /G6KWr+iSb+MyPv2xkmPxA==
X-IronPort-AV: E=McAfee;i="6700,10204,11402"; a="45280945"
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="45280945"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2025 15:52:21 -0700
X-CSE-ConnectionGUID: 16kwmHiDQC6UNkrmnfJrhQ==
X-CSE-MsgGUID: CRdSWK5pSWi/agsQajn9RA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="129657624"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2025 15:52:21 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Sun, 13 Apr 2025 15:52:20 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sun, 13 Apr 2025 15:52:20 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 13 Apr 2025 15:52:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=keMmtVMywCKOCDsuiNgbnq+gsDFcJo8UEkPouXWK3dC5Gv3EmBnJ0MhohN5M1V5ii2J5u3Z0Oa25dYwsKJsXXYFU2taetWPVQhDnnV9zLnOpWc+BCtv5VHHVkid/2V3IvfNjoUo9WLzFde9nPAWzCCTcvMxrh5ZahgpdVMGl0dEelVqND9zZPmlcdDQd703x1NfYTopDTPG4Xu/AZHdJPAEF2wT94kwCpBeoKAIJfNlg7Exr/JOUgJ36ea6fOzLzaCnJhY8syeFE3cpqu3Aq5elYAQ/BvDo6xjswCtMMIcJpEUnbwUbA5sRPPFlwZyTzsPcQunZBeiQdjj08MWZb6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rnp5qmlW0f1okaqStrG2jxKpSYTSKZide7t8m+Fd8ww=;
 b=gV78LOJbqc+uXBxEalRuNG1xa4o/vReZkA3KH0iaNEcI2D9DdCcaBRP4i65mLT3qKXcJOw2nOzWYehKwm6RNujTR1jfuPnfel+i9hpSRyvMySdwPmrccOJOqJForiJo9aJlyQhsH0IqeW0If9D3kAbzrQEbBYvIqe0+i/nw6xKXNBj191P7EU+JkSfNM+cm0wDKZmQWOPVJ6EtsZMwx2K2LU1VjdNDj44SthXkbjadM1zoU89PMKeUlu1XIaFPcVbYOV1L0yZ+dLKO74H1th/z4rEETRyn/kNPmHwRxi7v+MNFrVrQ/WDYNYM1tUrTSV/+mSw8vrhskBQojibIHdbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW4PR11MB6739.namprd11.prod.outlook.com (2603:10b6:303:20b::19)
 by DM4PR11MB6042.namprd11.prod.outlook.com (2603:10b6:8:61::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.28; Sun, 13 Apr
 2025 22:51:44 +0000
Received: from MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24]) by MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24%4]) with mapi id 15.20.8606.033; Sun, 13 Apr 2025
 22:51:43 +0000
From: Ira Weiny <ira.weiny@intel.com>
Date: Sun, 13 Apr 2025 17:52:09 -0500
Subject: [PATCH v9 01/19] cxl/mbox: Flag support for Dynamic Capacity
 Devices (DCD)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20250413-dcd-type2-upstream-v9-1-1d4911a0b365@intel.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1744584735; l=4586;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=ObXjYpSXhyIOJclFZabMVwT7Iw3oZ5eWVtgb3/GUyCU=;
 b=2CkaSSQAtgE6kCVfvIHhyyHvMDIIb4PkrgLRXi9PTyvh6B5OOscV117iFWBWpzulQYXQ15+ZB
 TLulNVfBTcJAn/0JcJ3cT3iGXIzqAZRZ7GQBpjinDbm3LUrrtKt0G4d
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
X-MS-Office365-Filtering-Correlation-Id: 21404f0d-096c-4e56-bda3-08dd7addc322
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?empBWlhQRE1CQkdmbzBHY3dpUjl0VmhiMTNLUUhWcHUrekFuRktHaCtBbWVY?=
 =?utf-8?B?RVFsNFVtZFU1dzBMZTJRVkYyL1EwMmdpTXpyZmhQcnNOUFBWQ29GMm96dlJS?=
 =?utf-8?B?MmpCZzR5S0laTFhHWE15VytaVFdCY2JVWUs2OVU2UWIwSHk3dE0zSG5SdUpB?=
 =?utf-8?B?U1QrajhhYUtWekgzSkptL1g1cHRWTEl6aXlIbmRlQkp3VG1PQ0ZXRGd0R0Zs?=
 =?utf-8?B?OS9FNnF5Yy9lTDV6d0tFVHAwT3pKRy9rN00zanZBc2JGZGI4QWtpZDRzR2tk?=
 =?utf-8?B?RE1GcFlnR1dOL0pZU0hqYnp5cm5jVzFaZEZvcGVJVWk2b05vYTllZGE3WUty?=
 =?utf-8?B?Zm1jdkpCc1ByY2VqcWtqVTRiODhQZ2lURW1UZGM0WUozZnJ5aHRQZGd1QVB5?=
 =?utf-8?B?dWFuTWRCbnBNNS94Y3VPclUxZWw1eXBCaTNBdEJpZ0F5SW5sN3o1YkNXbTF0?=
 =?utf-8?B?a2Q5NTVWT1lBa2ttWk1wWnhlMjc1Nk9IM21RQngvNHpZU2dRZHd0amVsM2I4?=
 =?utf-8?B?TW8rSVhFbXMra1dicHA2ejYrU3R3QnhBcGZLdFhLbDNsM0xsdkZNcHhNWVJK?=
 =?utf-8?B?a2l1RWdIZE5vekVKbGRlSHNpRTA0c0t5ZTNpa1lBU3ZqenBWZEVqQ241aXlH?=
 =?utf-8?B?eUVuQlAyRHVhdi9uU3hiZWVGS043ZTBBcDdoVEhNMXdUYTAxc3ljcis5d0xw?=
 =?utf-8?B?LzgwN2VVRnJpVjIxaVE1V0ppU3ZIYVJNY3E0NVdhclJWSitKQ3pkVnhvMEVF?=
 =?utf-8?B?SGNaRmc5L0ExR01FcGxFcjN1M0dzM0hvVHFBWi9QMTFOZUllNEkvcmFFY3pr?=
 =?utf-8?B?L3k2V1A3dDRTN1pFL3BiQjN0TTJRVko4Y1pUaUpmcmp0REtoeXVuM3RmcERu?=
 =?utf-8?B?UDUxa01UWjBndXFQeVBndllxUTg1cFlBTC84bE56bWh0RVdwMEhRSXFUdndw?=
 =?utf-8?B?SUVmYWVKUjJ4dmUwTFc4MVJzZlZYY1JEakplcC9uQW5oNk4yaytqTElGMzVP?=
 =?utf-8?B?bUl6OWFPb1lVRHo1Ymk5NFhsK1dIZmI3ZDJJMnRKeDBMRkZqd0F5b2lwd1c4?=
 =?utf-8?B?TWhWZWQwOVVYbHNzUkpaMFo1bVk5VVNhYVBHVXZBWEVnY3NJQTc0dDBSR1Ux?=
 =?utf-8?B?K0NLVVNPNFhpRGdlYVRGajlldWo4bG9tS1l6MWpaRXhDSnZvYWw2TDZCSGsz?=
 =?utf-8?B?Z3h0YlBFaGd5S2pOVFJuN3VDUlFUUWtQb09Ub0daTnJKT0gzMkE2UURtMnM0?=
 =?utf-8?B?M2N5Z1FxenV2cEpySTFpVnRyL3JKR1Y0SVp2QUdSWUtQWStWN0tldEowY0ZR?=
 =?utf-8?B?YUxVMFVQN0lrVndmWUNWcnVHR1l4ZlNLS3RUNVVKUS93eEpmZE56OE1MRllU?=
 =?utf-8?B?V2ZrRG83cUxwN1VmbUxBd1V6Szc5djQvYjhKVU92MDcrMm56TmlMd2ZCWnpD?=
 =?utf-8?B?TGJKSHFESC9aK0FlbStMdjhIOW9VYTFCWHdFNjdzd0FXdkVpbkJUdGUwb2py?=
 =?utf-8?B?VnhXNERVaFJBRHRXNlpYc1RUNDVHUURpYW1aVU83RGRhd1VSMkhvVDR5Zk5V?=
 =?utf-8?B?UnpJUng2cmRYajlwZE9KSHhaMlVJS2hmYisvVVVyVGQ3a1JNQ3NlczNHSU9B?=
 =?utf-8?B?UGNyeGNMRWs2bkZKcDFaKzJWTC8xQ3VnVExtejhieFdnSUpDNjVBMUdoM3Vv?=
 =?utf-8?B?cWMyRUpWLzVleEtzM25VRG9qdWxMOFlQNnUySWROcDNoSGxLOHpvTEpIOHRG?=
 =?utf-8?B?SDVrSHRSOCtXOUwxeHZkY2Yxb3BLYlVJNlZGK01VdTZRKytiZm5HMWoydGs5?=
 =?utf-8?B?L3lBVWZjdUI2aDJSNG1PV2l2dXk0S1NHVERvcC9WeUpNM2w4aUo4U0k3ejdY?=
 =?utf-8?B?UnBoaDI3dk9KQWtINzd0MDc1ZVpPU3R0cnZ3d2s1dm9ObTBQcmxBZjk5Q1Ay?=
 =?utf-8?Q?OoHUrFbrR6Y=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6739.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VGkzeTJCbVVYemY3UjhlekZSbmlHbVJCZkgrNzdmWXpkTFYxUjNhb1huV2hE?=
 =?utf-8?B?VGFGcmZUU0MxWncveXlQNzFUQkR1UTdaaERCbndoNDMrNHB3dzFyNXdoSXRt?=
 =?utf-8?B?Z3ZLdEM3UHZ3T0YrazEzWGpLVzdjM21LK2hXczVXVEorTXNzdGtFYUtLMDd6?=
 =?utf-8?B?V0hrdllFTFdVNzR6ZEpRemFPNmxhWCtBNEI3K1lUYlpaQ2NacmhVOFFvaHhW?=
 =?utf-8?B?QzcvVmFJM3dPWndQNmRLUzl1UTcvZHltVDBhTHlCSnNUUE1MaGRQeXhVYVdL?=
 =?utf-8?B?cjRoNVlseFB6Y3g5OE5CZDhvMllXSGJDYVppTVliTVBvNlBtTmxsa2dLdlNT?=
 =?utf-8?B?ZFBCeXJ5bnMzWFlOcnhDSXZwYmZJKzE5ajEyeGdianhuaU9qaEFTRzhDclk4?=
 =?utf-8?B?THFiTXdVY1IxQTRZQ0lwdENWYUVSR1FFcndPSWk0dzNpREFqeTRyMHdCandV?=
 =?utf-8?B?K3NZRlJXak84ZnJFWG1KUTZBQllOYmpuU29zZm1jZGUySlFTMjRTUkkrZXA3?=
 =?utf-8?B?dnMyWUJIM2tySGNZZGduSjNiaGF3bTFyWVNWVWkxYUFqN0tGZHJBWHhpdSsx?=
 =?utf-8?B?WEw5Mi9UTzJZQW5uVW1KYURUNm9iUnZYbEhvUkRGS1pZaDFDZ3Zwa0JIeExB?=
 =?utf-8?B?VmhCVExVN2tiTExpWUxkWW1oR2NXSStzUGxTNTN5VDhaNDU5NFJmZE54aVJ5?=
 =?utf-8?B?Nzh3QThoU3dWUE5FTkdNejB6Z2tVOEE0TUFvSnIyWURCK1ptRjlyeXVhcy9O?=
 =?utf-8?B?dWk3NzdxODI1UTVKZUgyL21VTHd3SkhCQXNHdzRTRi9VdzlzaWF3MWxOU1Yw?=
 =?utf-8?B?ZjN4SHBTMlRhRkJKL1BjNS9ROHh2dUFFdWVhQ21Ga01XZ0dWK2IwdzRKdVZ0?=
 =?utf-8?B?SXZ2d2JWUkpXNGVzcG5UUDFzTjJyZmh2eHlnNDF3MHJYYnF4dmVhcDNvTHdT?=
 =?utf-8?B?QnR5YWlmanJ0VFl0eGE1YVZIdHlZdC9RbFlzVFI4MzhLUWVFRWNUdUc4a05H?=
 =?utf-8?B?YjI3TmFlSG1BeCsrcjlZZkxXTm1uN1lRKzBPU2JvNldDUzhGSk5HSnR1MHlH?=
 =?utf-8?B?a0hORzRvRWgvTXVFdkowRTY5YTFBdUZ3UWxudGtkdmRiaEdsdkRMTDRBTnkz?=
 =?utf-8?B?eWpFQnloNWp6dDM3OTlSbGN4M2x6eGNjaWVzdkZ4dVFBTkZGd3dxZ0NTbldi?=
 =?utf-8?B?Z1ZmQXZKa0lJbDhXcWlhRUxVNzRhSzVsZDM1aHcvOFBHODZrRUJmUFVMZlRl?=
 =?utf-8?B?cHNKK2ptcTY1d1BmLzFzb2hpOCtFcThoUGtBTjJvTVNKWFVIRHFNcDZFZGt2?=
 =?utf-8?B?Nm9qS29ycW1NOXRxRlNlZU1ydnRwcGJVT1RhTkNWZzlzTUZFdUY0SkdZcmVB?=
 =?utf-8?B?Z29ZN3RqVE44YUt5d0tHQkpSN3VrbFVPa0lEdWtmbTR2MmNPeHR6NU1vTU9o?=
 =?utf-8?B?S2hLeXJMbVNNMk1JNWpQM1Q2YSt2WlF4OUcwSHlwbGhZYVUyTTI4V1RKOVcr?=
 =?utf-8?B?YVFnTDV2VEEvQndRT3lqY0NNNXBUR0dBL3BVWitKdS9CdklPOU8wSzY5c1lj?=
 =?utf-8?B?MDVqZG4ydnQ2TTVIU0xFQVJ2M3lDT0JxMk5jUE5vNWNQS3RmK3EzUE5sQ21L?=
 =?utf-8?B?eitGRTVnUi9aTUJod0lKR3diQ1M0YUkwMXVxVXhKQ3kxbjB3TUplbG9TZytr?=
 =?utf-8?B?RjFJdElEM25TYVhIZDMrbDZiWFYzb0d1d3FtbFFUMzdkS1RraTgxWnNBWENQ?=
 =?utf-8?B?NHRYcWFVVUZCbXVzLzhrYkl3Umx2T0QrNWIvKzV4ZER3c21sTC9ROW54N0Ew?=
 =?utf-8?B?Z3EzYUQwWGxFaDdkTklqZVgzUCsrSzdvNHpZSXR1WDZ0Y2w0WkVrQTNIM2NX?=
 =?utf-8?B?VklJU0dTNkducHB0VmdodTFBQUpIZFlHcWROKzNxRXdOckhRREROK2lFRXln?=
 =?utf-8?B?SDJUTkQrTzhuS1NFc0dsYmcwYUZiT3JoU3NSblVKeStTMjRuS0k3cWpDc1M3?=
 =?utf-8?B?MGlKclo3VnIyYm1tdWR0elU0ekdSL3BIL25oazZxOG5LWWh5VjNjV2VoQ01x?=
 =?utf-8?B?bzFxVjErbXJ5UHN4dllWMUwva1pSNW4yY2RCaDh0MDlBRDVYenBmTzNZTStr?=
 =?utf-8?Q?PcBQKZ4TYtCUvhlyp9XBL3GrE?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 21404f0d-096c-4e56-bda3-08dd7addc322
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6739.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2025 22:51:43.9083
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3DTvJt7lzTMXsv5u+7CPJkCiXHKbu1G0+/zYed5TkaqxDo/u8TByoTtjv/mCxapPQNXBg51pRI0e+tJEjAl37Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6042
X-OriginatorOrg: intel.com

Per the CXL 3.1 specification software must check the Command Effects
Log (CEL) for dynamic capacity command support.

Detect support for the DCD commands while reading the CEL, including:

	Get DC Config
	Get DC Extent List
	Add DC Response
	Release DC

Based on an original patch by Navneet Singh.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes:
[iweiny: rebased]
[iweiny: remove tags]
[djbw: remove dcd_cmds bitmask from mds]
---
 drivers/cxl/core/mbox.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/cxl/cxlmem.h    | 15 +++++++++++++++
 2 files changed, 59 insertions(+)

diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index d72764056ce6..58d378400a4b 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -165,6 +165,43 @@ static void cxl_set_security_cmd_enabled(struct cxl_security_state *security,
 	}
 }
 
+static bool cxl_is_dcd_command(u16 opcode)
+{
+#define CXL_MBOX_OP_DCD_CMDS 0x48
+
+	return (opcode >> 8) == CXL_MBOX_OP_DCD_CMDS;
+}
+
+static void cxl_set_dcd_cmd_enabled(struct cxl_memdev_state *mds, u16 opcode,
+				    unsigned long *cmd_mask)
+{
+	switch (opcode) {
+	case CXL_MBOX_OP_GET_DC_CONFIG:
+		set_bit(CXL_DCD_ENABLED_GET_CONFIG, cmd_mask);
+		break;
+	case CXL_MBOX_OP_GET_DC_EXTENT_LIST:
+		set_bit(CXL_DCD_ENABLED_GET_EXTENT_LIST, cmd_mask);
+		break;
+	case CXL_MBOX_OP_ADD_DC_RESPONSE:
+		set_bit(CXL_DCD_ENABLED_ADD_RESPONSE, cmd_mask);
+		break;
+	case CXL_MBOX_OP_RELEASE_DC:
+		set_bit(CXL_DCD_ENABLED_RELEASE, cmd_mask);
+		break;
+	default:
+		break;
+	}
+}
+
+static bool cxl_verify_dcd_cmds(struct cxl_memdev_state *mds, unsigned long *cmds_seen)
+{
+	DECLARE_BITMAP(all_cmds, CXL_DCD_ENABLED_MAX);
+	DECLARE_BITMAP(dst, CXL_DCD_ENABLED_MAX);
+
+	bitmap_fill(all_cmds, CXL_DCD_ENABLED_MAX);
+	return bitmap_and(dst, cmds_seen, all_cmds, CXL_DCD_ENABLED_MAX);
+}
+
 static bool cxl_is_poison_command(u16 opcode)
 {
 #define CXL_MBOX_OP_POISON_CMDS 0x43
@@ -750,6 +787,7 @@ static void cxl_walk_cel(struct cxl_memdev_state *mds, size_t size, u8 *cel)
 	struct cxl_mailbox *cxl_mbox = &mds->cxlds.cxl_mbox;
 	struct cxl_cel_entry *cel_entry;
 	const int cel_entries = size / sizeof(*cel_entry);
+	DECLARE_BITMAP(dcd_cmds, CXL_DCD_ENABLED_MAX);
 	struct device *dev = mds->cxlds.dev;
 	int i, ro_cmds = 0, wr_cmds = 0;
 
@@ -778,11 +816,17 @@ static void cxl_walk_cel(struct cxl_memdev_state *mds, size_t size, u8 *cel)
 			enabled++;
 		}
 
+		if (cxl_is_dcd_command(opcode)) {
+			cxl_set_dcd_cmd_enabled(mds, opcode, dcd_cmds);
+			enabled++;
+		}
+
 		dev_dbg(dev, "Opcode 0x%04x %s\n", opcode,
 			enabled ? "enabled" : "unsupported by driver");
 	}
 
 	set_features_cap(cxl_mbox, ro_cmds, wr_cmds);
+	mds->dcd_supported = cxl_verify_dcd_cmds(mds, dcd_cmds);
 }
 
 static struct cxl_mbox_get_supported_logs *cxl_get_gsl(struct cxl_memdev_state *mds)
diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index 3ec6b906371b..394a776954f4 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -216,6 +216,15 @@ struct cxl_event_state {
 	struct mutex log_lock;
 };
 
+/* Device enabled DCD commands */
+enum dcd_cmd_enabled_bits {
+	CXL_DCD_ENABLED_GET_CONFIG,
+	CXL_DCD_ENABLED_GET_EXTENT_LIST,
+	CXL_DCD_ENABLED_ADD_RESPONSE,
+	CXL_DCD_ENABLED_RELEASE,
+	CXL_DCD_ENABLED_MAX
+};
+
 /* Device enabled poison commands */
 enum poison_cmd_enabled_bits {
 	CXL_POISON_ENABLED_LIST,
@@ -472,6 +481,7 @@ static inline struct cxl_dev_state *mbox_to_cxlds(struct cxl_mailbox *cxl_mbox)
  * @partition_align_bytes: alignment size for partition-able capacity
  * @active_volatile_bytes: sum of hard + soft volatile
  * @active_persistent_bytes: sum of hard + soft persistent
+ * @dcd_supported: all DCD commands are supported
  * @event: event log driver state
  * @poison: poison driver state info
  * @security: security driver state info
@@ -491,6 +501,7 @@ struct cxl_memdev_state {
 	u64 partition_align_bytes;
 	u64 active_volatile_bytes;
 	u64 active_persistent_bytes;
+	bool dcd_supported;
 
 	struct cxl_event_state event;
 	struct cxl_poison_state poison;
@@ -551,6 +562,10 @@ enum cxl_opcode {
 	CXL_MBOX_OP_UNLOCK		= 0x4503,
 	CXL_MBOX_OP_FREEZE_SECURITY	= 0x4504,
 	CXL_MBOX_OP_PASSPHRASE_SECURE_ERASE	= 0x4505,
+	CXL_MBOX_OP_GET_DC_CONFIG	= 0x4800,
+	CXL_MBOX_OP_GET_DC_EXTENT_LIST	= 0x4801,
+	CXL_MBOX_OP_ADD_DC_RESPONSE	= 0x4802,
+	CXL_MBOX_OP_RELEASE_DC		= 0x4803,
 	CXL_MBOX_OP_MAX			= 0x10000
 };
 

-- 
2.49.0

