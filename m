Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ECD51DA609
	for <nvdimm@lists.linux.dev>; Wed,  4 Sep 2024 13:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725458116; cv=fail; b=XA8pK4VA7u1r1qRXyVK5aOurRygm0rOb6wN+RSIYiyMJoblCJeM4dcRJx5KYgHZXPulsKZxEmigb1YoLws51K9DEvU/++PDbnRyIouzMyL3JX6BVcXLqEBlYBCqzNDESRwlGkUgz8rte2z/TsaE48sU/0KWvRwx42VVBInJGcVQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725458116; c=relaxed/simple;
	bh=XujzhAKJ9k3gz4RAOrfQl8ss5/cDZBAdoMsQqKPLQWM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=JNmQks2NJrTfE6n/K/EXFfiItCMTWuE6uvtVhbGV5eXbu8QfAZbSo6in5ujBI7y4H/eXgeFtRL7zmo1eP83ypKRzJSj6R/C0v+JI2S8a5aRvU4X6/doKOx0V8pDljJA5tnik98eyJgV9B4gXhgHGMp9MNOw66mC/JUJher5YzBI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cWCRgg7R; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cWCRgg7R"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725458111; x=1756994111;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=XujzhAKJ9k3gz4RAOrfQl8ss5/cDZBAdoMsQqKPLQWM=;
  b=cWCRgg7RIjy3izW2NoHNacU9ZTmd5ZbRaTsoVlCG7vI/Kd1tenhMAToQ
   6trlAQKRKkmqJVfej6LFuwyx9ZniPWREpwo8+bSWr69/6Q328j3QXpDQ9
   sS1vykmf+wbffe8+aGsvhBnuK8mpf8zY6WWBSMcIRdIGMmTHhAo+XREv9
   SNr87zvXCFmObs+QPwuDs1QAlBG6/C5EiE8E16zyolSGBKRFGGCMA/WZI
   cP7bAwVCrfSj6QoQXQElESCcb1jzDARTM/Uo1oVwslUG74rZGtFuGNxU8
   gD+zgzGcVvPsERlfscwww9HgFlNDY3dDY3t4K/BoXHAE+hRS7Htv8KBfp
   w==;
X-CSE-ConnectionGUID: ahBe+zSZRTSbLvhcbXKVxA==
X-CSE-MsgGUID: gq0ARRGARSCimnIzfqIzTA==
X-IronPort-AV: E=McAfee;i="6700,10204,11185"; a="23630101"
X-IronPort-AV: E=Sophos;i="6.10,202,1719903600"; 
   d="scan'208";a="23630101"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2024 06:51:02 -0700
X-CSE-ConnectionGUID: QQoV7YhVRQiyuZANZgN8XA==
X-CSE-MsgGUID: PtLCSSo/RzyZncVOKkhh5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,202,1719903600"; 
   d="scan'208";a="64969445"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Sep 2024 06:51:02 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 4 Sep 2024 06:51:01 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 4 Sep 2024 06:51:00 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 4 Sep 2024 06:51:00 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 4 Sep 2024 06:51:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zk+pC1OCFad4/za1pNl6WmY/5AdCnnvbyufkgLOTF7uB+vQfO8PYEhjVsDiC/R2OVPxYgd0sINjKbuULoGPI8XZxshsBubuJ7WhNu36th4Y54NmDRvvgzfLKFNCQgFRJgI/YWsucvrwQVQyWXskrfS6y6wBOB00PrlAMhfEsUN1vwFbZ0W8j6irZbPZa6Cc/Ialxszguw9H1KnIJYo9LYFhECf79ggSUFNOGUGrrixiTGEuMszUyWlXIjBe4I/ISipMmEtx5purBy1oUzlEo3+J3iOAoMDlTSuJGUg6EtYbKKe9XCoBIIx718zNSKSncpH0ac+uvow/kbCL9WXsunQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OlIPwjLlaxE39e+nW1XFJ+woBCcimxTOBk+NBNsPgV8=;
 b=Bqaq9MfgA//oNPPo6lC4lzqnLbmEljTkZ+MpNVgMnJlmkcBOzXsP2xuV+Uz4DspNCajMe2Xft/Et2H3kF3nezp6vGeak/NgRVCGUTHaeCd4ls6SlaYzNLEIz+opifnas/lwBcRcCxH0reXPAx9xSjBiKP6JlUR4ICEwbFP3Pqj440qHIcVQiLUcFvPFJ5EqFaELbaw3l33p3yM67TYM+efcD0Lqkhw7tDxp5NnthmbLaijgv5phrgI/N5Sou5IH6088dLnwuOfoEALDKvhyC8RJKG7QPpx1kCNseGdtJ9vAgtE7EC/42pBeLwQhmz3qCVK4LN1ux1GmlqY0mjedTMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by BL3PR11MB6481.namprd11.prod.outlook.com (2603:10b6:208:3bc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.28; Wed, 4 Sep
 2024 13:50:58 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%6]) with mapi id 15.20.7918.024; Wed, 4 Sep 2024
 13:50:58 +0000
Date: Wed, 4 Sep 2024 08:50:54 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Rob Herring <robh@kernel.org>, Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>, Oliver O'Halloran <oohall@gmail.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
CC: <nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] nvdimm: Use of_property_present() and
 of_property_read_bool()
Message-ID: <66d865bec41f1_1e915829465@iweiny-mobl.notmuch>
References: <20240731191312.1710417-26-robh@kernel.org>
 <CAL_JsqKC5S_-vJjdYEsoFHAQiQvymVDE4_moy5g_p7YEfAmDLA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL_JsqKC5S_-vJjdYEsoFHAQiQvymVDE4_moy5g_p7YEfAmDLA@mail.gmail.com>
X-ClientProxiedBy: MW4P222CA0028.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::33) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|BL3PR11MB6481:EE_
X-MS-Office365-Filtering-Correlation-Id: 0591cef5-10ee-4032-f95a-08dccce89aee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?QlBNUTk3RlR2aFhzQUNTNTRDVVlSdVJWckVFLzdvQm96MmNPMzE3YzNVY29m?=
 =?utf-8?B?MjZndUs2MjNyN1FwcTIwbTFlcGdXY1dnOVpCaUUwR1lsVTdBckpRTGg0YTBX?=
 =?utf-8?B?cWMzOStZcVNIbXQxL2hNM01zL3pPV2ZteWI3cHR5ZzRLUVE1YlRpUDZmTDJV?=
 =?utf-8?B?YjlTQWlncEJPeUhMRkNUNDZ4QWErOU1PcTFnankxckhpUHVSNUdNbFZDTFR6?=
 =?utf-8?B?c0x1V01UejFVSm5uWm5nL21VY3NpRVl5RldjV2s4MWppZmlFMGp5MitCODBR?=
 =?utf-8?B?Rldxdnd0Mmh6aUR5WEZLNHhQN3NZTDI1UkNFME9CVElyaFl4ckszLzc1MFFZ?=
 =?utf-8?B?UG92TXVlenJZb0trUkk1citaSXJPMjhaU01iRnVUMmxDbTdOUEZRMXBkR1la?=
 =?utf-8?B?dVFhOWVldFVTTmlzZHVsWlk1RWRZbUdXTWtVeklFRFZNQ3BVNDVyK0h3NjNE?=
 =?utf-8?B?eGJmeVQ2U3EzM0IzQXV2b1RPNHl6OGY3Rmo5RUlRRUpvR3RNaE1zYzJxSi9q?=
 =?utf-8?B?T21HdHFMN2hFQkpZbjBrT2RzbTdyMUhpZHgraUd3LzREbkxseXNEQUllOTA4?=
 =?utf-8?B?Mk1ESXZRT2dEOStic1hFUnMxN1FTWGpEY29CbjA0MFVic3JFQ01iY3NKL1Rp?=
 =?utf-8?B?Z2xKSGQ5TUJ4elpGdGJ3c2R2S0ZJd2ljNEl1RDRoYmRFWHpXdkdKZGFKcUd0?=
 =?utf-8?B?QklSOTEvWlpyUXNDV1pEUUQ3REFIRzN1dkE2b04yTEQ0MEozaDFlNWcrRVN4?=
 =?utf-8?B?U285QmR3aXVwVWp5Y3dQVlQ4NVlUN3JDVXBYTis2b3VteWRXR1RHcEM1OUhR?=
 =?utf-8?B?UHk5T0gvR0xtN2pQeTY5MG5DYis5cFh5cHBSNHFFaFFNKzBDY1U2VWZyM3FC?=
 =?utf-8?B?bXdQMEs3Q3NWR3I4RHBJU3l3Qkl6dmFOT0pnb3BUZ0VBdGFiSWJLT2hIMWRj?=
 =?utf-8?B?cXZHMG1DQ3JhWC9ZUFAweWJXYU41MU9oaDZRTmt0NDRub1FxWHZmQnNUV1ov?=
 =?utf-8?B?SEk5dVpaY2ZrRDE1RWNrMWdIWUVYeWdHYytNRU5uTGxBQ2cxV0ZnUWJxYUUx?=
 =?utf-8?B?YklQU29OTjc2MEpSUnAxV1Q2SVNMVldFbGoyenBSUmZaL0dROTdJaTI2RVF1?=
 =?utf-8?B?dzJNM0dUQU03eTBFdTRtVjJSRjg1NVR5YnNzUTVtMmFGRHVvcHV1bFk0S1o2?=
 =?utf-8?B?ZkduajNiQ3pRTTI4dWkrYXFWZy91d1o2ZVUzVHI2dnY2MmU5aHY3RW5lWENE?=
 =?utf-8?B?RmxGSVBmTWo4bVNvcDZneW9GL09ncUNKdEI0QTdtVit6ZitHL3ZnSjNiZ1VV?=
 =?utf-8?B?SmlUb2t6eWpQWEZ0a2ZOWEhlSkpuMnFLMTlHL3c2NlNIdDVsSFo2bFpSU0ta?=
 =?utf-8?B?YmZxOTFGVUNyK0I5RGo3ZGRobUw2eFlpTENrTnA0ZkVRMjdLZ3A1REFzeUNu?=
 =?utf-8?B?VGl1dDJiMXpZODRiY3VFTWFHTFFSbG1sQjVsa3JobjRBQU5XTysyV24vT0VI?=
 =?utf-8?B?RytyNUdYTEUrVlN6SXU2WjR6T1VUeVZ1QzFXY1RKM2JaNTlkNkFsMnZGUzlS?=
 =?utf-8?B?Q3lSWjk3eUhjNnFQdml2Uk1EMU9Xd0tYbjl4Mlk4KzlPYUdRYnlrangrWTBp?=
 =?utf-8?B?QmMwYkxwMk1sMEgxTFM4aUpIQnZhTjlsQk1ZcFIyZXBReW9Pc3ltOXgvWGtY?=
 =?utf-8?B?Q0NvYnB1TCt1MlowNFd0NmtOVlVQRzF5eEp3b0hrTGtrQjl4K2MzSFBDMU1S?=
 =?utf-8?B?cWtwSDl0SENpVHpxSjM1amJHRjgwN3BYZ3ZPTnVYT3lkVWlhY3kyREx3T1cr?=
 =?utf-8?B?RnFTTUNTaFdYT1loWHhPQT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NEpFb0NtVWszUmxwSk9Renp6T0VSUVFZWDNoejZWUnZnVTdDZXBhODl4R0dB?=
 =?utf-8?B?aFQxU3A2QjNJbVdDakUwaFIxeXFiNitCazl4T0tFOGFYZVNhTGJrWXZPUXpu?=
 =?utf-8?B?S2FYNG5lcU1lWUtaSDJRdEFHOVZvYktGbFBmdWltcEljdTdmYmo5dmFtVGVk?=
 =?utf-8?B?dTlUbU0yWGh2enNFdjRxV1h5MW1uK1FJNHZCc3pNY0FxZCtOenNEbjk4TUdB?=
 =?utf-8?B?OSt6c0RLRkF2d2NpT2p2RnJ6NEZ3Q1NvQzkzcHBOQS9WUkgwdTJsZXVLdE5V?=
 =?utf-8?B?bmxKL3FXLzVNUHUxSXZKV3E5c2xJU0ExT01yVXA1U1ZoZzZ2VlZwdUVVYWRr?=
 =?utf-8?B?SlNDZXpGOUFkMWFWeC81dXRGeG5odDhjQ1Z0ZllpTnFjdlZJYnVGSi9GNVk3?=
 =?utf-8?B?NGpjanB2TWQvdlBHbjVVazdvR09Kb2JpU3ZSRGxvWk93ODF5Mm5aamowd2tP?=
 =?utf-8?B?RzdjQW9nT2dqV1dQWDBOSFdnNW9XZFZkV2lDUHR2dVROTUtGclh6cHBkTGR6?=
 =?utf-8?B?WGR5R29veHFNR2F3ZHBERk51QWtBWmJsQVUzNFYwN2Z1b0U3aVBHVVJsTHpm?=
 =?utf-8?B?Rng2TkQzRXRiMTZhaGNPUitZcWM5Y2JSY0dSZS9SZHNkdXZQRGFDa3dpL2M3?=
 =?utf-8?B?TDV5TWtLcTBZbHVsV29FQzNHU2ttT3I3b3ZYNnBsY0hESVpIcWNLR1A0Sk41?=
 =?utf-8?B?bGkzcmFhTnJiOFUvd0Y4N2Y2QlBMUEZiODAxL1kweEFvOVFFTVQrYkdjS25Q?=
 =?utf-8?B?R1JITDl3MXJtRUdBMkxjVi85N0V3WXQwQzJUV1JmSE14ZDV6Vnp2dnJ0WUgv?=
 =?utf-8?B?VUtSSVM0MjFMWWQ2ZW1WM3lhWVMyVEp0dkw3RERQZTZJUVpFNElBd2wxVXU5?=
 =?utf-8?B?ZE9uR2VaQllTWjZ3OUl0MHA4UU1VRnVrc1crZUVQVkh5R2tpMjlpdGZSRzk0?=
 =?utf-8?B?cnp6RzBOdVFZZTVkOVp2dTFCSTJXZTc5SFVZUExiK1FNaHpXZE51T3M5Ry9L?=
 =?utf-8?B?a2M0ek9UVThLOGhYeXZyQ2dLaFVSMDQzRitxbXEyNFBFOHdoWEpJZEE0TnZ0?=
 =?utf-8?B?OVRhYlFWcU9CZkNQa3pMMEU0Y3NPZTdUVjBGU1hrTkh6U1dXTE92R3VzdzNH?=
 =?utf-8?B?dFNZSmh4Q1VWZzZYMytSYjhZbDRFUlhLQnhUK1RQcFFPcytUelYvb2hoYVdt?=
 =?utf-8?B?WTRRanZ6RFNkKzBURit1ZGRxMjlyeElGZVFFRnMxNGFRMldNakZFdHREanVO?=
 =?utf-8?B?TytQSktuQlZRTUxwelNsUHFmVW12WGVKWkpVWDNMM1EyZ3o4b2JFc0t5eG01?=
 =?utf-8?B?RzBMc2JKazFWSGpreFladHcxZjhHcnhDQ050RU4zOEVNRTZuSVJGMDBtRUxX?=
 =?utf-8?B?dVplT0Q2cjJBVlBKaThvbmY0WXUwT3hwV05SdWV4N0tuTmQ4YXQweUIra3dC?=
 =?utf-8?B?Ky80b0xNc09wQTlxVVExdlNCanlnS1ZEdjc1V09sY2RZbTEyb3lXQ05CSkVq?=
 =?utf-8?B?VGJ3WkJ1dXlOSEdERjl5ZnhYRlBFU0V4aHp4Zy83Rm1RRThtVzdiNWVZbXNn?=
 =?utf-8?B?QTJSMHB6NzMrMi8wWXhpZk9Jdit2MFdZUjJpYTlsM3haUk9tTXFLTjUyaVpl?=
 =?utf-8?B?dzNoalJud1BRYzYxbXRtZ0h5b0ZjNFpMSk9LaUZRYktCZjZZQjNLL2ZvZWpE?=
 =?utf-8?B?THAraTZBcnhGNkdqWFE0UVVVdFVET2pxcmk3Sm5pR2RNaWpYSTBOYkZUeFhJ?=
 =?utf-8?B?V2pwK3lZVGM4WjFyNE1pQ2txM0VoZnRVUHJZQVRXQnBxdE0vaTQ0RTVSR1hr?=
 =?utf-8?B?TForNk9UTGNFZHcyTEYrbnFwVEVjVkJ3MDZYZ2lFVmpCYVArbVh3V3J3WHpK?=
 =?utf-8?B?aHp4Z2tDNzdJNjBrNm9PRVU4Zk5JbEwxNHVmRFRBdE96Rm5acktGRDQvOXVw?=
 =?utf-8?B?WjROOG93TEZ5ZWpDc0pnKzhORTgrMzZXUUZqOWZFdStHb1Q2RzNsUGJpcVZP?=
 =?utf-8?B?VnJMUmVCb0trQTFkZCtUNW1EakJLYWx3M1FSa3Vyc0g4UDIxS1hsTE5zQlg0?=
 =?utf-8?B?VnRiTDd1SVE2OElLME5WNklqczZIeDgrNXl5S0ZPYUphMk03Z3ZUelM1aTAx?=
 =?utf-8?Q?GEdhkGd89r+v7lHWPmc2vcZsH?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0591cef5-10ee-4032-f95a-08dccce89aee
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2024 13:50:58.6047
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6trTFllDpaWdjsGbbNQladSZgXYP1XN8eMFOk7WQmD0BIYHLqWr4jY5Ko7GP9cMt6do/hcB91pqh95toClOZXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6481
X-OriginatorOrg: intel.com

Rob Herring wrote:
> On Wed, Jul 31, 2024 at 2:14 PM Rob Herring (Arm) <robh@kernel.org> wrote:
> >
> > Use of_property_present() and of_property_read_bool() to test
> > property presence and read boolean properties rather than
> > of_(find|get)_property(). This is part of a larger effort to remove
> > callers of of_find_property() and similar functions.
> > of_(find|get)_property() leak the DT struct property and data pointers
> > which is a problem for dynamically allocated nodes which may be freed.
> >
> > Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
> > ---
> >  drivers/nvdimm/of_pmem.c | 2 +-
> >  drivers/nvmem/layouts.c  | 2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> Ping

It is soaking for 6.12.

https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git/log/?h=libnvdimm-for-next

Thanks,
Ira

> 
> > diff --git a/drivers/nvdimm/of_pmem.c b/drivers/nvdimm/of_pmem.c
> > index 403384f25ce3..b4a1cf70e8b7 100644
> > --- a/drivers/nvdimm/of_pmem.c
> > +++ b/drivers/nvdimm/of_pmem.c
> > @@ -47,7 +47,7 @@ static int of_pmem_region_probe(struct platform_device *pdev)
> >         }
> >         platform_set_drvdata(pdev, priv);
> >
> > -       is_volatile = !!of_find_property(np, "volatile", NULL);
> > +       is_volatile = of_property_read_bool(np, "volatile");
> >         dev_dbg(&pdev->dev, "Registering %s regions from %pOF\n",
> >                         is_volatile ? "volatile" : "non-volatile",  np);
> >
> > diff --git a/drivers/nvmem/layouts.c b/drivers/nvmem/layouts.c
> > index 77a4119efea8..65d39e19f6ec 100644
> > --- a/drivers/nvmem/layouts.c
> > +++ b/drivers/nvmem/layouts.c
> > @@ -123,7 +123,7 @@ static int nvmem_layout_bus_populate(struct nvmem_device *nvmem,
> >         int ret;
> >
> >         /* Make sure it has a compatible property */
> > -       if (!of_get_property(layout_dn, "compatible", NULL)) {
> > +       if (!of_property_present(layout_dn, "compatible")) {
> >                 pr_debug("%s() - skipping %pOF, no compatible prop\n",
> >                          __func__, layout_dn);
> >                 return 0;
> > --
> > 2.43.0
> >


