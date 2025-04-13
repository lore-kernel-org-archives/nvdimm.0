Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9A11E5B70
	for <nvdimm@lists.linux.dev>; Sun, 13 Apr 2025 22:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744584727; cv=fail; b=ZVATsUQX6/4Uv+PSqCg192d5AMj9oWCB1qiBPKq5MlLbtymGBegl1kqA7ySMBvW9e5XWqVk2/M3uXJA/y/hny98jmsI+1tjREWmwfs011jpUOQYsEDF0ZQFRjcSnUN8etaxNgoOEtXbNc4GMgR2msgoKG4fo3uX7uZLkSmv6DaY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744584727; c=relaxed/simple;
	bh=Ue9nxkCBAbAQFWbu0CQ3m+slfJ5d9+PWGNBQeO6mizY=;
	h=From:Date:Subject:Content-Type:Message-ID:References:In-Reply-To:
	 To:CC:MIME-Version; b=cn6Rn04ET9egIYjKjxedgVDn+qCQ5QKmTtTu0PvyelP+t0gV4F2kCSeTVM4dETaqvNhU3J5tnMnHzEcA8rxFbL7EdGOPOigD3U/Dbi0484QoVyojIoBUFMMmQa5FMfBTXInZM/qT+dau7KSZsvambTtz47viEYYVi2fUwUjjlQE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CvekO5WV; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CvekO5WV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744584725; x=1776120725;
  h=from:date:subject:content-transfer-encoding:message-id:
   references:in-reply-to:to:cc:mime-version;
  bh=Ue9nxkCBAbAQFWbu0CQ3m+slfJ5d9+PWGNBQeO6mizY=;
  b=CvekO5WVAuh5vDJfqah554r+9vaU7Lg/6DdiKn1u5sZALBNqqhY/hk+5
   vVNss2h0p7laJZia64xbwibScY6FFZ9Y1nOXZJjyKvR5/Ye0ExhQtwC3H
   NgqJHpvQiJb3iRlirMpZCHMLViXapC22GTtuYyskepViU1whIab+l2ujr
   incRoHfRO1nBE7kL7SB7KVTVkS+T00J0hoF9bmX4CYo/FrrnJB08M6lKF
   o6iboZeiXDl4N4DESWPw9HBP9OkiFJrYKSPwSzceQ9sKW/rQ+Bpthxrb1
   93PDzSlevLhwnpTsmo9Vn6y2T6KuioWBGr7u8/EILqPxxKm2gsnc+42Xp
   w==;
X-CSE-ConnectionGUID: dolVbyvIQS6JmBgDATUbKg==
X-CSE-MsgGUID: m94c6+QeQ/WxyKoL7cvvrg==
X-IronPort-AV: E=McAfee;i="6700,10204,11402"; a="45280911"
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="45280911"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2025 15:52:02 -0700
X-CSE-ConnectionGUID: G/R6Q/J1REeJWdnJ3PK/FA==
X-CSE-MsgGUID: zcLim1KxSfS87+lZuIhUrg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="129657463"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2025 15:52:02 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Sun, 13 Apr 2025 15:52:01 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sun, 13 Apr 2025 15:52:01 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 13 Apr 2025 15:52:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UnYaRK2K5joiLzCXU0ypa4E9N4OwIWcVmCTCtTjC5ZfPatbfoA9dGT5YmVZrtZGWoRC5+vdWiEZp5OAc6xpLefcMTNtLZmrScgmlJWiSjyBe9NCn5meGRVhdutAWEexDfPn2yCteusFGyciBTfBIaq0gEMv+Y/RUIgFSQbWG6mh2geCjBLB2k+Xdl+Kv9DnYgtdEtwfUR4MhGmncduY0ddOv4cWaUWCjhRph6ySETtEPBi1f4gWpfXd4Qik+GSceRbNsOt/xTAejjkBfG3bYqmYXycvU0j13tUaokO1ulnF2+DleF53/K8nB03Y0im5MDjG4tJKZEtC6XbHyTEGNWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YXIxguaIDgMBQhxvppqbWNbriOR5oVLyqgq47Upy2I8=;
 b=C8k2gxPizLy3UFq6q6jO8+lZgGvdpkSYXtRhmAEDXy3yfvNSMZo+2O+H8jzL8Fs4U273UmaDi29qnnovouhOkWnp/r9G6RBcPsbnPmAwHsUim+8ikN6fJUB+dLucgb3aNEJhVIyoWSjeL1AMWvrHI22GeElJK/BsQngEB50AHJ7AIIS4AfdBevIA0ivJ6NkPXoj1cmhaQuGVT3mv3NdkhFMFbB1wIyynLbhQz2bmwvmsHbGbNorzR6hwIKRVm9YQ+r7KA4olVW0nj+rdPKix4/2mcmvqfgZx84F+3txKfVsKx+V/OxC6/a3qD6rIfGYMuzxBZ607VH1VnE1fzCCwKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW4PR11MB6739.namprd11.prod.outlook.com (2603:10b6:303:20b::19)
 by DM4PR11MB6042.namprd11.prod.outlook.com (2603:10b6:8:61::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.28; Sun, 13 Apr
 2025 22:51:53 +0000
Received: from MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24]) by MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24%4]) with mapi id 15.20.8606.033; Sun, 13 Apr 2025
 22:51:53 +0000
From: Ira Weiny <ira.weiny@intel.com>
Date: Sun, 13 Apr 2025 17:52:15 -0500
Subject: [PATCH v9 07/19] cxl/region: Add sparse DAX region support
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20250413-dcd-type2-upstream-v9-7-1d4911a0b365@intel.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1744584735; l=10968;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=Ue9nxkCBAbAQFWbu0CQ3m+slfJ5d9+PWGNBQeO6mizY=;
 b=tngxmK7sPNauggRF7uFSLXG+oUAuWS0LuNdDUKS4cOUwk3n8EByXRCtN5zVBrkFzpz7Y7IVMP
 cWCd+/VxCJMBlj15chVHMOGxulh4Bcy8If4whOwQEiQPDJBOhTmTGId
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
X-MS-Office365-Filtering-Correlation-Id: 049bf665-13bd-48e2-f354-08dd7addc8ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VWNnQ21VNGJuUWY4OXl4VytjblhGS21SMmlISEM5d0ZyUDIyZDhKcDhkM1FI?=
 =?utf-8?B?MmZMbjgxaDhCejR4LytmZDAyanNwSDM0cU5YNnVZMXk2OU82TGFMQzlKMEFt?=
 =?utf-8?B?dzR3QWZlaXdQd0hDdjZhNXBFZEFZL25IUlhxTWkvQlczMGx2V0FSWlhWaXpI?=
 =?utf-8?B?cUhWN0R0cWRub2t0b3VmTXJXUUZVZEgyck5QQkJOcVdIdlR6U29sRVUxcXVp?=
 =?utf-8?B?aFhlaVYxSE40UkhoNytEWGZ3OWdWSGtSYisxMFM5Z2lYSUMzY2dmclFJbS9K?=
 =?utf-8?B?SUxwbG00WW5oS1QxblgyQldqdDhadi90U0dSQVVFUGdrdGdjdWpyVG5uVHhW?=
 =?utf-8?B?a044OEZ2dW1MV2ZjWkdkQnFKSExlemxGVko3YzVvSmdYMXBQb0FNQ3RnTWtP?=
 =?utf-8?B?OWcrbzBZY0FKS0N0Vnh6NEVRSW10QlgrTkxVL1I0SjlCNkRhNnlFS2VlQ2pn?=
 =?utf-8?B?Ynd3dXRzYUVkYytKV3UrdEs5cDU5TFNDTTE5UWVzUmJ5ZURBdnIwSUpqMytY?=
 =?utf-8?B?dFk5L0hxN2Zsd1puckJoZVI1ZitvamhtclM1ZU0ya2Jyb1JFTG9NeEgvZGxZ?=
 =?utf-8?B?bXRuWXozT1Q4dm5pbkFLVE1FVWlsVVZOV1FXc1RVM0hUWEJUckJ1RDFoYnBa?=
 =?utf-8?B?bVBvd3g0WndRMHljT014WEJOb2kwbnVJS3ZEdFg0NVBJdlJRTmRtbnU0MFp1?=
 =?utf-8?B?OFhGWWZIRlFqcmk5dy9JNWtWYWYzbHV4am1EQy9zZ0E0eEViMEE5Z0ZVSG1O?=
 =?utf-8?B?ZDkyUEM2Mmo2OEZqa1FoYkNLNVZmSTlZU2RoQ3FhQ0Vxd0U4V09MZHRSdmVj?=
 =?utf-8?B?VGZORnQ5Q2JJVExwaVNUT1BOUittc05JbTJ6UThValNLZ0cxejYxZHhpUisx?=
 =?utf-8?B?elFQamFMWnJmc09JVVZoWk90SGVYVVh6MzJRWGlqL0FJTkNSTWtqQXVXSzVO?=
 =?utf-8?B?L1dzSXlwVW5CcTU5L1FiL2pONWp1WHg3YjJvYnNRVTJZNUI1ODBvYkdBOFBz?=
 =?utf-8?B?YTFaOEtMVWNOTVY2ZnA0SUtib0RTT1NUMERWTlpkeWxzeE9vUFlmOFNrRmdm?=
 =?utf-8?B?VWFWUmpLYVB0M0ZCZkRzUExlRTExaDdHL0V3OUM2S0dQZ05sVk5aSEZqMkVM?=
 =?utf-8?B?dW8ydzVtL3ROSWZsUnY3QVR5TVM0Uis5dTNxUnpDc1NWTmpVZmN5cUd3eTQv?=
 =?utf-8?B?akJhZ013WEpSTjgwWHVjVDBWTC9ENHdCeU1kd1hkcTEvNjc4NjFmTTNFcU9N?=
 =?utf-8?B?aldIZ0JpTXJlM1R1MzJQSFpVc1hNVHdZZmZaQk1LSTZsemthWk1WOEVUbHJL?=
 =?utf-8?B?bE9CNS9YdjNDTmtmMFBHN0Rtci9ESnMvMk5YeWxNdG9tOEpEVUZOS2kzMW1E?=
 =?utf-8?B?Mjl4OUd6WHRmNEtEaGQrWEU1T3lSOFhlaGdha2xIZWhGU2lPeXFSa1RZSm1N?=
 =?utf-8?B?VFRtcUh5Y1FYdEMwUGg2MnFkMWwyZFAydFB1dERLdytrWmI0WUNsdlRic1ZC?=
 =?utf-8?B?M0oyVCtEMXBLMTd4OUNMbmZqczFnS0RqWXdXRUxNeDFGNjJvOGlQdkFQdWNt?=
 =?utf-8?B?UXJWbkg0SkVzSE1tUFZEL09JaWZVMmxvd1pzOU02Mk9yeVRYTUdRWFNZUW83?=
 =?utf-8?B?Z1d6dEJCSUs4WnQrVDhuU0xFYmx5QlNkUXdBV204dzBjU25ld3p4bDVtemFJ?=
 =?utf-8?B?eHBKSUd4UUljSmphdnR6ZCthcEFPbHdwalp6T1RVb2cvT3ZpMjBIeUFUK25z?=
 =?utf-8?B?VzlpaHFSQVZVTzd4T09kckd5alhoNm95NFVUZ01KNndmbXF4aExaNHF5cVVH?=
 =?utf-8?B?K3QzOEVSYXpVV3hnZEd1UDc4ZHFsSnp2M1RTWXg4ZjFxQUdxTHRheXo1N2Fs?=
 =?utf-8?B?UXp6WFFPRVVVYU5kb25iWExXN2pyVElqekYzWk1NMDBTenM3UFdTb1d1S3pR?=
 =?utf-8?Q?v9vjj2abAUg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6739.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NGhwZmtvZUdVQm53dDRwdk50TVoxWUxhaEhZb3kvZi9ReENEUTlOWDUwS0lo?=
 =?utf-8?B?QUwxcytPbnN1YzZlRE1CV2F0ZjhGWDdQUHRIdUljYjBzYml0VGY4OG9YaU0w?=
 =?utf-8?B?c29EOWpvUmpQOVk4bllKaTdQUDZVVmJCTFR3NndGY2FockRhajVOcGRSYndN?=
 =?utf-8?B?aS9zeUJCSklqdWNrTkkzbm92MXUxMkVyTnFXcFUxRWxRU1o3ODJ1WlRQYXl5?=
 =?utf-8?B?UVNabmd4dVVaRXp4a09udUoyMEJOVTJuZGJ2aXVyN0p0SkhTSSswVDRnMExy?=
 =?utf-8?B?bkwxbGJ1UGFwMElYSFpReEU2cGJLeXlsU1pUQ21wb3laYkczSlZBaU5GNDYw?=
 =?utf-8?B?Y3g1Q2U5TGRaSmhwMlJrTVhRVU0vRkFlbXNiOXVHVDJpS0haSzBlWVBFWmw5?=
 =?utf-8?B?Qk95UzZPb3FSUUlSOHZaa3FFRVlMSHg5c1RtdjErcjc0eHBxcFgyYk9tUmZk?=
 =?utf-8?B?TU12Vlg4Q1NhTEw0eE9nL2xsZ20rNHBtNkRIRW5aQW4wLzJyQWE3UHJPTExV?=
 =?utf-8?B?WU8xY0hVbmJTUnRpREV6cU1xQTE2RTZ3YXFkVklNWjBUYk9UQ1JJOE5YOFQ0?=
 =?utf-8?B?akQ1Mi9DcTh3ams5clpYSU9mUXR0MXdBRTBDMXNaRjcxTXNrbml5dGlMdkdF?=
 =?utf-8?B?NGtZVFhua2JBNE1iaW96N3daSWs4ZEJTYUliQ3pzVGY0SkdwUWhQUVFpc1Zq?=
 =?utf-8?B?TThJaHNoNGJaa2pkcFNIc0wrVndsdVpHRmczZ09hSEdmQmloQkZZWVNZVmFF?=
 =?utf-8?B?Nk1iS2RFS0E1OGUrUGU1bUxZKzE5ZDFWTVNXc2JnelVXWUFaeVVDdHV1WW5H?=
 =?utf-8?B?RFd2eExmcENGSTJyRDZCUXhsK211WHVNekdkNVVOVnRZVFo1Y3d2bXN3UmFj?=
 =?utf-8?B?RkR1Uk4wQ01sRExLQW85dFFNcFI0Q3IyU01zaUl3djRDSWxScmRBM3dTM1h5?=
 =?utf-8?B?VFVxQk13NzErNEs2cUdkSFBLdStRSnRZOHBLTm9vQ2NHZjBMY01XSDFLODJI?=
 =?utf-8?B?S0lPVm1tQmxyLzRPU1BZeDd4VnA0ZGo1TXV3ek4wVXRNYlpoS01FbFowOEoz?=
 =?utf-8?B?YmdRV3pYYTl3elExNEpHQjNJYm1Fb1hYeHF5ZFZoVC80Mmp5VUtGK1ZpRm8y?=
 =?utf-8?B?TGNyaWlDems5dEhtQTdMZE9jd0dMZURKOHpodTNpMDFsS05PWmtoc1R1bGhK?=
 =?utf-8?B?ckFHT3lQVmtHVXBPYVVsUVE2emtNMWRibEJvYkdVSkYvWG9VMVlGb1lQNDFL?=
 =?utf-8?B?RnhSSnlmbm9pbWlmcjJJQUx3QU9MQ3FJWEpoYUxWY2NJOVJQMExkYStmQmht?=
 =?utf-8?B?TmQxQW1nN0RVUUovc2tRcUtmUWU4QVhDamh1QU1sbm9pejRmcDZ0aVRSNDFn?=
 =?utf-8?B?YXVTamVoVnNtRDBtRjF0NFc4NEM1MllsbXZUb2xmWXFGR1Q2RElFZXl5T3BI?=
 =?utf-8?B?dmljWnpmb0RKaDBsbjA4cktLMW1nbHU1NTY0Q1dJY3RnYThGMnpHQ2ppYkc4?=
 =?utf-8?B?WndKK0F3OU5ncEpxMWZtSzd2bmtCaEFWdCtWaXJBa3BDaEZxSzNvcllzMmxN?=
 =?utf-8?B?cTVrVm91WjZBK1dSd0hZenhPa1JocmlKMktDQ3BSdFUyWXJqWWxvVnZFelZx?=
 =?utf-8?B?THhkeElVelgwOEVsaENqZ0h4MVF5VkFGbEhsS1h2cVY3aTZYT3ZtV0FtYlEv?=
 =?utf-8?B?TWFyOWZMaTgvRW1OZjA3bnIveHNVMTQ4bWwrdU1lRWZjdytjSEpqUzZsOFhu?=
 =?utf-8?B?OE12OTZUbDhLT0JJR29TOGpNUHZYNVNKK3pqdDhVYmE4VkxpcVdidkFaY1du?=
 =?utf-8?B?Y2pyNkRFNWFLeFhEeHpIYzVZS1JGYXZ3SlZjYUt4c2s5Z0orRWlVZk1wVWQ0?=
 =?utf-8?B?MWc2OXZTU1cxSVRiUDZDSTh4T04yQWsySWM3ZUNtUFR1eVRXUzBNQ1d1RUx3?=
 =?utf-8?B?eWR5ejI5MnJDSFl5dndqckNSMTRERElsK2xZME84TW9jZ25rM1Q4RStHSmxV?=
 =?utf-8?B?eXIxV0NibUY3QWNoakR1MWJDeU5rNFZLOXBDRlBUeGR0NU5XaWlFYkZqMVRx?=
 =?utf-8?B?SlZJdjg5R2haeTA3WXFsMlh5dkNSTXVLUHo1UHNiNVdWY24rb1d0ak9sK0Fa?=
 =?utf-8?Q?/N/MbFn4QBtlX7d0kLlW/+OYn?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 049bf665-13bd-48e2-f354-08dd7addc8ed
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6739.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2025 22:51:53.5872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AmZ2zILsHNw2NLrMFaEVkCnLh79qg+VHw66fMAv48+kxaIW4CUHsnFfIQvIuqOFduBJPEt6afMYl9zcwaRQG8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6042
X-OriginatorOrg: intel.com

Dynamic Capacity CXL regions must allow memory to be added or removed
dynamically.  In addition to the quantity of memory available the
location of the memory within a DC partition is dynamic based on the
extents offered by a device.  CXL DAX regions must accommodate the
sparseness of this memory in the management of DAX regions and devices.

Introduce the concept of a sparse DAX region.  Introduce
create_dynamic_ram_a_region() sysfs entry to create such regions.
Special case dynamic capable regions to create a 0 sized seed DAX device
to maintain compatibility which requires a default DAX device to hold a
region reference.

Indicate 0 byte available capacity until such time that capacity is
added.

Sparse regions complicate the range mapping of dax devices.  There is no
known use case for range mapping on sparse regions.  Avoid the
complication by preventing range mapping of dax devices on sparse
regions.

Interleaving is deferred for now.  Add checks.

Based on an original patch by Navneet Singh.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes:
[iweiny: adjust to new partition mode and new singular dynamic ram
         partition]
---
 Documentation/ABI/testing/sysfs-bus-cxl | 22 +++++++++----------
 drivers/cxl/core/core.h                 | 11 ++++++++++
 drivers/cxl/core/port.c                 |  1 +
 drivers/cxl/core/region.c               | 38 +++++++++++++++++++++++++++++++--
 drivers/dax/bus.c                       | 10 +++++++++
 drivers/dax/bus.h                       |  1 +
 drivers/dax/cxl.c                       | 16 ++++++++++++--
 7 files changed, 84 insertions(+), 15 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
index b2754e6047ca..2e26d95ac66f 100644
--- a/Documentation/ABI/testing/sysfs-bus-cxl
+++ b/Documentation/ABI/testing/sysfs-bus-cxl
@@ -434,20 +434,20 @@ Description:
 		interleave_granularity).
 
 
-What:		/sys/bus/cxl/devices/decoderX.Y/create_{pmem,ram}_region
-Date:		May, 2022, January, 2023
-KernelVersion:	v6.0 (pmem), v6.3 (ram)
+What:		/sys/bus/cxl/devices/decoderX.Y/create_{pmem,ram,dynamic_ram_a}_region
+Date:		May, 2022, January, 2023, May 2025
+KernelVersion:	v6.0 (pmem), v6.3 (ram), v6.16 (dynamic_ram_a)
 Contact:	linux-cxl@vger.kernel.org
 Description:
 		(RW) Write a string in the form 'regionZ' to start the process
-		of defining a new persistent, or volatile memory region
-		(interleave-set) within the decode range bounded by root decoder
-		'decoderX.Y'. The value written must match the current value
-		returned from reading this attribute. An atomic compare exchange
-		operation is done on write to assign the requested id to a
-		region and allocate the region-id for the next creation attempt.
-		EBUSY is returned if the region name written does not match the
-		current cached value.
+		of defining a new persistent, volatile, or dynamic RAM memory
+		region (interleave-set) within the decode range bounded by root
+		decoder 'decoderX.Y'. The value written must match the current
+		value returned from reading this attribute.  An atomic compare
+		exchange operation is done on write to assign the requested id
+		to a region and allocate the region-id for the next creation
+		attempt.  EBUSY is returned if the region name written does not
+		match the current cached value.
 
 
 What:		/sys/bus/cxl/devices/decoderX.Y/delete_region
diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index 15699299dc11..08facbc2d270 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -5,6 +5,7 @@
 #define __CXL_CORE_H__
 
 #include <cxl/mailbox.h>
+#include <cxlmem.h>
 
 extern const struct device_type cxl_nvdimm_bridge_type;
 extern const struct device_type cxl_nvdimm_type;
@@ -12,9 +13,19 @@ extern const struct device_type cxl_pmu_type;
 
 extern struct attribute_group cxl_base_attribute_group;
 
+static inline struct cxl_memdev_state *
+cxled_to_mds(struct cxl_endpoint_decoder *cxled)
+{
+	struct cxl_memdev *cxlmd = cxled_to_memdev(cxled);
+	struct cxl_dev_state *cxlds = cxlmd->cxlds;
+
+	return container_of(cxlds, struct cxl_memdev_state, cxlds);
+}
+
 #ifdef CONFIG_CXL_REGION
 extern struct device_attribute dev_attr_create_pmem_region;
 extern struct device_attribute dev_attr_create_ram_region;
+extern struct device_attribute dev_attr_create_dynamic_ram_a_region;
 extern struct device_attribute dev_attr_delete_region;
 extern struct device_attribute dev_attr_region;
 extern const struct device_type cxl_pmem_region_type;
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index e98605bd39b4..b2bd24437484 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -334,6 +334,7 @@ static struct attribute *cxl_decoder_root_attrs[] = {
 	&dev_attr_qos_class.attr,
 	SET_CXL_REGION_ATTR(create_pmem_region)
 	SET_CXL_REGION_ATTR(create_ram_region)
+	SET_CXL_REGION_ATTR(create_dynamic_ram_a_region)
 	SET_CXL_REGION_ATTR(delete_region)
 	NULL,
 };
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index c3f4dc244df7..716d33140ee8 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -480,6 +480,11 @@ static ssize_t interleave_ways_store(struct device *dev,
 	if (rc)
 		return rc;
 
+	if (cxlr->mode == CXL_PARTMODE_DYNAMIC_RAM_A && val != 1) {
+		dev_err(dev, "Interleaving and DCD not supported\n");
+		return -EINVAL;
+	}
+
 	rc = ways_to_eiw(val, &iw);
 	if (rc)
 		return rc;
@@ -2198,6 +2203,7 @@ static size_t store_targetN(struct cxl_region *cxlr, const char *buf, int pos,
 	if (sysfs_streq(buf, "\n"))
 		rc = detach_target(cxlr, pos);
 	else {
+		struct cxl_endpoint_decoder *cxled;
 		struct device *dev;
 
 		dev = bus_find_device_by_name(&cxl_bus_type, NULL, buf);
@@ -2209,8 +2215,13 @@ static size_t store_targetN(struct cxl_region *cxlr, const char *buf, int pos,
 			goto out;
 		}
 
-		rc = attach_target(cxlr, to_cxl_endpoint_decoder(dev), pos,
-				   TASK_INTERRUPTIBLE);
+		cxled = to_cxl_endpoint_decoder(dev);
+		if (cxlr->mode == CXL_PARTMODE_DYNAMIC_RAM_A &&
+		    !cxl_dcd_supported(cxled_to_mds(cxled))) {
+			dev_dbg(dev, "DCD unsupported\n");
+			return -EINVAL;
+		}
+		rc = attach_target(cxlr, cxled, pos, TASK_INTERRUPTIBLE);
 out:
 		put_device(dev);
 	}
@@ -2555,6 +2566,7 @@ static struct cxl_region *__create_region(struct cxl_root_decoder *cxlrd,
 	switch (mode) {
 	case CXL_PARTMODE_RAM:
 	case CXL_PARTMODE_PMEM:
+	case CXL_PARTMODE_DYNAMIC_RAM_A:
 		break;
 	default:
 		dev_err(&cxlrd->cxlsd.cxld.dev, "unsupported mode %d\n", mode);
@@ -2607,6 +2619,21 @@ static ssize_t create_ram_region_store(struct device *dev,
 }
 DEVICE_ATTR_RW(create_ram_region);
 
+static ssize_t create_dynamic_ram_a_region_show(struct device *dev,
+						struct device_attribute *attr,
+						char *buf)
+{
+	return __create_region_show(to_cxl_root_decoder(dev), buf);
+}
+
+static ssize_t create_dynamic_ram_a_region_store(struct device *dev,
+						 struct device_attribute *attr,
+						 const char *buf, size_t len)
+{
+	return create_region_store(dev, buf, len, CXL_PARTMODE_DYNAMIC_RAM_A);
+}
+DEVICE_ATTR_RW(create_dynamic_ram_a_region);
+
 static ssize_t region_show(struct device *dev, struct device_attribute *attr,
 			   char *buf)
 {
@@ -3173,6 +3200,12 @@ static int devm_cxl_add_dax_region(struct cxl_region *cxlr)
 	struct device *dev;
 	int rc;
 
+	if (cxlr->mode == CXL_PARTMODE_DYNAMIC_RAM_A &&
+	    cxlr->params.interleave_ways != 1) {
+		dev_err(&cxlr->dev, "Interleaving DC not supported\n");
+		return -EINVAL;
+	}
+
 	cxlr_dax = cxl_dax_region_alloc(cxlr);
 	if (IS_ERR(cxlr_dax))
 		return PTR_ERR(cxlr_dax);
@@ -3539,6 +3572,7 @@ static int cxl_region_probe(struct device *dev)
 	case CXL_PARTMODE_PMEM:
 		return devm_cxl_add_pmem_region(cxlr);
 	case CXL_PARTMODE_RAM:
+	case CXL_PARTMODE_DYNAMIC_RAM_A:
 		/*
 		 * The region can not be manged by CXL if any portion of
 		 * it is already online as 'System RAM'
diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index fde29e0ad68b..d8cb5195a227 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -178,6 +178,11 @@ static bool is_static(struct dax_region *dax_region)
 	return (dax_region->res.flags & IORESOURCE_DAX_STATIC) != 0;
 }
 
+static bool is_sparse(struct dax_region *dax_region)
+{
+	return (dax_region->res.flags & IORESOURCE_DAX_SPARSE_CAP) != 0;
+}
+
 bool static_dev_dax(struct dev_dax *dev_dax)
 {
 	return is_static(dev_dax->region);
@@ -301,6 +306,9 @@ static unsigned long long dax_region_avail_size(struct dax_region *dax_region)
 
 	lockdep_assert_held(&dax_region_rwsem);
 
+	if (is_sparse(dax_region))
+		return 0;
+
 	for_each_dax_region_resource(dax_region, res)
 		size -= resource_size(res);
 	return size;
@@ -1373,6 +1381,8 @@ static umode_t dev_dax_visible(struct kobject *kobj, struct attribute *a, int n)
 		return 0;
 	if (a == &dev_attr_mapping.attr && is_static(dax_region))
 		return 0;
+	if (a == &dev_attr_mapping.attr && is_sparse(dax_region))
+		return 0;
 	if ((a == &dev_attr_align.attr ||
 	     a == &dev_attr_size.attr) && is_static(dax_region))
 		return 0444;
diff --git a/drivers/dax/bus.h b/drivers/dax/bus.h
index cbbf64443098..783bfeef42cc 100644
--- a/drivers/dax/bus.h
+++ b/drivers/dax/bus.h
@@ -13,6 +13,7 @@ struct dax_region;
 /* dax bus specific ioresource flags */
 #define IORESOURCE_DAX_STATIC BIT(0)
 #define IORESOURCE_DAX_KMEM BIT(1)
+#define IORESOURCE_DAX_SPARSE_CAP BIT(2)
 
 struct dax_region *alloc_dax_region(struct device *parent, int region_id,
 		struct range *range, int target_node, unsigned int align,
diff --git a/drivers/dax/cxl.c b/drivers/dax/cxl.c
index 13cd94d32ff7..88b051cea755 100644
--- a/drivers/dax/cxl.c
+++ b/drivers/dax/cxl.c
@@ -13,19 +13,31 @@ static int cxl_dax_region_probe(struct device *dev)
 	struct cxl_region *cxlr = cxlr_dax->cxlr;
 	struct dax_region *dax_region;
 	struct dev_dax_data data;
+	resource_size_t dev_size;
+	unsigned long flags;
 
 	if (nid == NUMA_NO_NODE)
 		nid = memory_add_physaddr_to_nid(cxlr_dax->hpa_range.start);
 
+	flags = IORESOURCE_DAX_KMEM;
+	if (cxlr->mode == CXL_PARTMODE_DYNAMIC_RAM_A)
+		flags |= IORESOURCE_DAX_SPARSE_CAP;
+
 	dax_region = alloc_dax_region(dev, cxlr->id, &cxlr_dax->hpa_range, nid,
-				      PMD_SIZE, IORESOURCE_DAX_KMEM);
+				      PMD_SIZE, flags);
 	if (!dax_region)
 		return -ENOMEM;
 
+	if (cxlr->mode == CXL_PARTMODE_DYNAMIC_RAM_A)
+		/* Add empty seed dax device */
+		dev_size = 0;
+	else
+		dev_size = range_len(&cxlr_dax->hpa_range);
+
 	data = (struct dev_dax_data) {
 		.dax_region = dax_region,
 		.id = -1,
-		.size = range_len(&cxlr_dax->hpa_range),
+		.size = dev_size,
 		.memmap_on_memory = true,
 	};
 

-- 
2.49.0

