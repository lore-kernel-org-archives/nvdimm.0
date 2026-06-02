Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF91308F2A
	for <nvdimm@lists.linux.dev>; Tue,  2 Jun 2026 00:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780360843; cv=fail; b=Hoa0/na8OSFCDlQZNNh3kxTL09ZUEGnAXAV4XGtg7ZNBolqMxAyzshSyj4J5ZYcEnPbXhJGIRD46fX0U65M5jq21u0f7Sn5Lhld6fP77HWFyrqFKBs0yUIMxN8ArTqbxPTBBySrUMuBJJNLxZr9k9rtekgncsmZo4pJoxn/1sSQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780360843; c=relaxed/simple;
	bh=hKOP5JC2dN91Cy+qVJdLoILgKAk+eJREUnDYHrfC9ys=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Ww46g+bDfHOsFo4zfTTkerNtfuqzdg7LK0ISQoV/whS/s4jlE+ESDR+30cbehQ4qw4behbJ85b6IPH2+mSeAQr+wrhrTdB4om86DPxKrHbInSGqYmC5EZUbvHkPqVv8B6anWOQWXf5162EKOuhd8hIRgVspfSmKsmxPBcOXSDJM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FUgTnyTB; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FUgTnyTB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780360842; x=1811896842;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=hKOP5JC2dN91Cy+qVJdLoILgKAk+eJREUnDYHrfC9ys=;
  b=FUgTnyTBNSvzV0WEVrh3fuGBpsJnweyxvn8Dge7rfmcaXTRM+9VXPEp7
   Uf7Y01eenIDYtJPHK95IzMgoZ/OURWSpbjPUpxmT4BPxb9cvNH7r/8fNA
   wul5bydLBqRIjIVeojry8EeX2NlRbckcnh3YY+5ZgyVYWKAkbfpK2Sv9k
   q9DAgSRhphdhuZuWn+eLAbjBnDPb8P9nKW+ynNyYxXYwZD/47T22tcawD
   aH/QlwU+XnFFxl3ocjY0f3FxHaAZxbLKLKWbnQI7AJt+i7DOlPW4rODLG
   WsHt1ysjNaOODMBZMhzr/KhjXehFnLfobJ19DkTIfJQYfClf4mRGRhSjH
   g==;
X-CSE-ConnectionGUID: tIXdvTPTT/u6AN44s3tT9A==
X-CSE-MsgGUID: jSG6oPZYRFmvN/T8RRKzjw==
X-IronPort-AV: E=McAfee;i="6800,10657,11804"; a="80860357"
X-IronPort-AV: E=Sophos;i="6.24,182,1774335600"; 
   d="scan'208";a="80860357"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 17:40:41 -0700
X-CSE-ConnectionGUID: OWw+7yqWQQyjA3Bh3IwPXQ==
X-CSE-MsgGUID: I21Fb3ksQPqVptdHTTH+7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,182,1774335600"; 
   d="scan'208";a="248824641"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 17:40:41 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 1 Jun 2026 17:40:40 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 1 Jun 2026 17:40:40 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.71) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 1 Jun 2026 17:40:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i1QaoWyWvoXjhxK9nyoK2eckDPyCgaGrRcviRwEkQj0yaeW5S+oybYprriO033wI0scyvsubtnctHc+ZLRIpKtM8+DLCfTowj1X/TXmwCOLV4XIT3sUg9YaGP24kMqfzUAOLkckSJY6xjY7YHMkMwGo7b8T01c0m+7jnhUXQIw5p7obcUOs9FBZPK7+Iy+BprcqmEJVGhl5sMg/ImDQVAAmVcjmh7m4QfFdRmUs+9RjY6qC3ZXLbRMXDQ78LVpV4PhW+YMCw5UVluXy4Aea2yLRVUVLG2GlIUgfMxiFY3sP6R2Ije97/7hU0NfPDOjxfrvKrgVqa2E5F/LRTo0FCgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=llbUUaYODFbxjkiR6zoDwsr5dzMIG7TOk3t63txv/54=;
 b=e+jMHJqBVTmPVNEcJgFSgq2Fsl2IGZfTbC1yXAr8NczNhw74igZsuKDyW62aLGrVTY/KMAg0zI1Wi3ddYSNbbTpIeXnKx3Y6nM4QLaYYFTjVis8n46lsPRjNUupBP4yO8OhxHLaA3ISQ2lONefUGG44S6IrmkCSUwwXpSer5ewIRdG4IuQ0OJI0JUa4imxJHJbz6W7zLGgacvWHraVWCVoqai/BYR0BPkGgEicZbwaXuGfHHkpvyGpCSfXRjSTmEOTj+lACZhcmBY7nQ88kwp4k8nuNtzi70qH02IEyUAZ1oFYBxz5Is7VL+dExYoGZQhQdzlIZOIbrCGDOiXrhRDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by DSVPR11MB9891.namprd11.prod.outlook.com (2603:10b6:8:45a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.16; Tue, 2 Jun 2026
 00:40:39 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%4]) with mapi id 15.21.0071.010; Tue, 2 Jun 2026
 00:40:39 +0000
Date: Mon, 1 Jun 2026 17:40:35 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Tomasz Wolski <tomasz.wolski@fujitsu.com>
CC: <smita.koralahallichannabasappa@amd.com>, <dan.j.williams@intel.com>,
	<icheng@nvidia.com>, <linux-cxl@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-pm@vger.kernel.org>, <nvdimm@lists.linux.dev>, <ardb@kernel.org>,
	<benjamin.cheatham@amd.com>, <dave.jiang@intel.com>,
	<jonathan.cameron@huawei.com>
Subject: Re: [PATCH v3] dax/bus: Upgrade resource conflict message to
 dev_err() in alloc_dax_region()
Message-ID: <ah4mgyJZsEcsYiu3@aschofie-mobl2.lan>
References: <20260528064546.23362-1-tomasz.wolski@fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260528064546.23362-1-tomasz.wolski@fujitsu.com>
X-ClientProxiedBy: SJ2PR07CA0015.namprd07.prod.outlook.com
 (2603:10b6:a03:505::28) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|DSVPR11MB9891:EE_
X-MS-Office365-Filtering-Correlation-Id: fba127b9-bfc4-4e92-cabe-08dec03f9174
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|22082099003|18002099003|11063799006|6133799003|56012099006;
X-Microsoft-Antispam-Message-Info: IXXNQNeUL0AuCQgMPXSyCF+0snTGGoQemMfd8O0OwYw+2a5sSIUHdUYtogZWdSW2OfZaerGH6Z7yx38ieV3j4MUhFmf861iatTgIN55dUjml8QHdljFuxyU/S6nqjtZB9lkq3KQ7hboDI5/L3A+f/eRMWH+TyWcaXawUcgEP1nqnWzjKi8iPCtxDLc87tgam9yAkv9ZzxHjAcmujgdE2DeTqvZnK8Mavrpki9gdWueYXC/Bw/CA8TXNLWPogZYNq453fZ6q/Qnl4qL0zrEOATahJLOMr127SGO7A2Q1php4OXsnaRG1UG+FGr8IPmt+0AFxTn417YAHaOI/mr5NarpOLex0ABfoYDU2mkJb0v2MlC6kkEDeM5eiylPeV6c7vRAKFQiKf42iwrCrg8+KnzcT8dPKAjZRk4eF7rMVRq0LusHhLzqZCXbLZpZxEe/DTtIBNo5tDL3t4DsyboZlkVLvF7KFtQ0ASCwao2S/y/cmPnDCTORKvmGO7xmeI8lh7rbQR8eYsS7dpy4LoSlRK6DMM8V3Wr+AECxp07EiKLGIL42Rphurf+8LxDAjWYnExjwzItxzET9OFwaqwiU/T/aavHkMheAgkN1zDJw6DcOtUYLenYciLMLGCcp0QLL4WOTyDM9RRscQ9yQX3sOJgv6gyp3gw9vr6TH20kT8wthxIusPmW9yWKhlXcf2xblcatgseYnEqzKlehJa2zJZl2w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(22082099003)(18002099003)(11063799006)(6133799003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S2VCUXlvUXp5YmUrZ0pTeTBicXVkTmlGOEVVZXU2NXkzZmoxbzdiaFhMZC9J?=
 =?utf-8?B?UXFTclZvRmhEKzFpNmFjUVVFL3F0bmcybTEzb2krMm9ESGxhdWV1TnM4bEQ2?=
 =?utf-8?B?Z216U2UwMUNZNW5Xa0NKNERmb2dSRytWczlrQ0dwQ3cvbFUzNzlCQ3Z5Y1J6?=
 =?utf-8?B?N2ErNDJVbW5naVRTaWVGSEFDaVk4bW5rWHo0NjhpMzNGNkRJUjR6UFJuc1ND?=
 =?utf-8?B?QUZXQXl5YzBETFUvYVpYTXM5UGdZVTl4MU00VXB6ZWh4TW9jem9TR2wxcEF0?=
 =?utf-8?B?c3J1WU5KR3N2bVJvNHY1d05jZGRHVTAwanhvRXhsMkZuM3BqdzdNWlNsU3J5?=
 =?utf-8?B?SjJURGx4ZDVOY2RNOE1LTGJLaTNhbGVEZHFzMHY4WEd6dU90MFlDRExjT2gr?=
 =?utf-8?B?dGJvU0VrU1J0THliQTl6VXNoa29vckRIMENUUm8xY2NwWHVDeFM1T1NOYUN5?=
 =?utf-8?B?MXVYVU5HUTNydHpDSm84T003Ny9vMEw3dkwySGpyb21YaVVlZU9ZVXg0MkUy?=
 =?utf-8?B?bzg4ZFdhWlN2M0Q0ditBY3Q5UnZ2VnNHeXBBSnlqbFN4OVo4NlNyRHVYWEVN?=
 =?utf-8?B?dzVqb2xwZE5ib1dtRGZNQWhzYjZBWmRUdTJsQlZqLzNnazFVb1U4MjllSmRR?=
 =?utf-8?B?dXBrbmx5NjB5QWt0bDdUMXdHL3ZsV1hWNU5IMFp0NFRzNEVvTit6Z2dzZEg5?=
 =?utf-8?B?UWF2b0xlZnc1RHhIZDZUbzFuVTI1K2lSandmOCtSMVMzclpiWC9CVFVnaTZY?=
 =?utf-8?B?L2NjaENwTWQ5cVZaOXFxRnAzN0pkWGpoVEhyNHNGbllMVXErRE9DUCsvcmtQ?=
 =?utf-8?B?TDZzUlAyN0p4ZGdXUlBLY0JDc0kxM0I5clM4dFNMWjd1d2tzUlNqYm9QT3FP?=
 =?utf-8?B?SDNYcVFrQzdxcElPZWJvamZlaGxZMFBpNTdtZzF5cVVwQ1ZiSEFZdzNSWE4z?=
 =?utf-8?B?aTgzb3hSOEFvajdTa0dvQVg4YWtXZ1BuVlRJdHQxQWNtNzYzR016M2VCT0hG?=
 =?utf-8?B?UTJVOVpYZFdKd0I4VXc0YzlXVGdhekV3WkZyVUF4djJPb1I0a1dnZm5WSmdF?=
 =?utf-8?B?bEZYNmloeklhVTFwNzduYmF1YmRrdXFsN1lrTFd6eEgxYWFKaUZHZEdoVGFl?=
 =?utf-8?B?K0tZcFRKemJmN084dzNRQXg5Z004RWtHaTd2WS8vaUJoYXZhKzRnR2lxSFR5?=
 =?utf-8?B?ekp0MlB4YnBVaWI0OFhwUUY2V0Flb0cyU2l3WTFuOTlsZVRncjVYcmF6UzB6?=
 =?utf-8?B?bnhoME9hbkMxblVVTzJyTW1PWVJxaXlydFJ4WEJhVzBRTGJLdlBlOFQvZCt3?=
 =?utf-8?B?TTFPRjA2NzJjYWN5TmNFbEpFWmlIcnFMMDF4VlkvaVgrUFBxTm9kWXNvRjNh?=
 =?utf-8?B?N2ZyNWV4QU5KcUN5RUFUaHBDQzF4NzJHblcveXJEK3cyM0dzNmRDbzFINVlr?=
 =?utf-8?B?eW5uZFN4bWFuTlVNMlg1MHlGVnZJRk5ZUHd4dlpOWnVpamJaZW5mTkRSTTVo?=
 =?utf-8?B?Q0xLaWdIWmRFTjhLbk1UaWF5K05pWlczcU9uanBKWjVWQUkySVBHaTlCRk9R?=
 =?utf-8?B?eDYwOXpWUTV2cFdXT3ZDVzBneksyTWRRTnZDdVc4S1NBYUErMTNoWWs3cG8y?=
 =?utf-8?B?Qm5aWTJscVptak1INndQWmtrRkdZdDV1K1FBaTRTcld1aHFTc1hjY3paYkNj?=
 =?utf-8?B?dG9DNG4rdC9iUkVTZURxQWFKM1NHNGJPRko1OVhzb0E5dDM5VFl2VnRtZ0p3?=
 =?utf-8?B?aVE3K2JVelM4eTNNNGUxR2JIajFNWHdFYXRnV1BjSk93VEV5NmVkL3AvS3lm?=
 =?utf-8?B?U3lBOTRwRXE1TDNjS24vdTMrWWdDREJYRUtXS243UGJIY3dmdCtuQTh3MmRD?=
 =?utf-8?B?RGVzbE9LbllaT0Z3bFdyam8vTXFKaEZwUFFaRUp0N3dyWnhkV2hvRk12VjE3?=
 =?utf-8?B?eVlRS2xyTnNucDhFOVJRTysxRUNPclJoczBsOTl6Szl1MG1oaWR1MGZDdEZ3?=
 =?utf-8?B?Q2pDdVlKU0J2dk1UanJIRis2Z1UxYXVMTVZ4eDZtV3YxV1diVjY3cW41c0ZW?=
 =?utf-8?B?UTIwNXJRaXRma2lMSDExbXpnSUIyN1l6alNCcmxKQkxPTngzRndYZGpMdkFD?=
 =?utf-8?B?QUdCU05qbWNIK0VnK1kzTW1DbTJaRFM2ZTVUVmFxayt3TUJSdlR6aFo4eWh4?=
 =?utf-8?B?YldQeHpkUENhNVcyNnNBbFFpb2ZSYVd2WUFPb1l3UVIvcnAwY0hKUW9VMGVG?=
 =?utf-8?B?M2FvdnRBTXpKVXhyU3dqdmo0WmljdDlNVCswdmVEZ1hIUnRCc3hNaFB6R0lr?=
 =?utf-8?B?L1RQSHhIVG4yc3JxM0JVTFJ0VS9kQXVuM0laQnErZTJrQytWbzE1L3VsbVlK?=
 =?utf-8?Q?2hYsejwo+XnYLNN4=3D?=
X-Exchange-RoutingPolicyChecked: cvwAwa52G2ThOBK2LYXkmJwKK6SlRcXxuC/yWtbp18do+VMn6PQ+1cahrwpcTgGFmh8zFOlrI7GkMIYx0cVOT+AG2nmGa3MoGUfuL/CNoUKYeSRSMD2g4M0SGZUqlEmQKa+6VSkyWqHRi9ClxYAKlOTearNzLPjvinCXwXdA8YZKNr6lF/DYXWIbCcU3t4ZlnyE+ZrnUQ/jgscFeZ3Nq6LvBhJU+3EC2nHJOkdT0If8Y1kl6qpHplUs+/9D/vLrIPvRGigqTYNg0rno9MCgpqauO6Jx/aIeXvXcMaabFZlnM8hsyYcoGMuYseWCCoRlT8+n5gpc0JWGT4JsbtWRb8g==
X-MS-Exchange-CrossTenant-Network-Message-Id: fba127b9-bfc4-4e92-cabe-08dec03f9174
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2026 00:40:39.0526
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cZNLYmcYyikvxqvI0dlmSPpopHAyUCaH/KWuiZ430Aish16RbPFMHfxegqApLjqPqTuwzcfxkSoS8HZwrgE66t0q50fJCAsloQCUahbCwiM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR11MB9891
X-OriginatorOrg: intel.com

On Thu, May 28, 2026 at 08:45:46AM +0200, Tomasz Wolski wrote:
> The dax_region resource conflict in alloc_dax_region() indicates a
> serious configuration problem — two subsystems (e.g. dax_hmem and
> dax_cxl) are attempting to register overlapping address ranges. This is
> not a transient or debug-level condition; it represents a genuine
> resource conflict that an administrator needs to be aware of.
> 
> Promote the log level from dev_dbg() to dev_err() so that the conflict
> is visible by default without requiring dynamic debug to be enabled.
> 
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Link: https://lore.kernel.org/linux-cxl/69c1a8d1c0fa9_7ee3100a1@dwillia2-mobl4.notmuch/
> Signed-off-by: Tomasz Wolski <tomasz.wolski@fujitsu.com>
> ---

Applied to nvdimm/nvdimm.git (libnvdimm-for-next)
https://git.kernel.org/nvdimm/nvdimm/c/cd1a8d788763


