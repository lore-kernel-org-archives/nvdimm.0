Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E82A135946
	for <nvdimm@lists.linux.dev>; Sat, 12 Jul 2025 00:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752280380; cv=fail; b=BJzSnA+jNkZGf6xDFHYbPTKLx0K7gbLFL8u3JRPVsV05XTlK10lBQzHuve7KJyCpZoDW4O7dj6bGefdTuWVsUi+IYUeM0ZHMLH+rnL/Ar/ouqad6HfOKaRVXtoAm28Zgaqnj8actppq7nRu6ONSYXA39+niDZHDigtkY0s/1rsU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752280380; c=relaxed/simple;
	bh=VvgRHkrGkP2ZaRHvUXtwI41sV0GoVtzwC9uCzkk4wsY=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=SElqhUIoSOa6lHNs+LhqRVIrCP1y+UYGxG6Cz2+3xndLCKrw83D5B+XQ1S5Bo5CP7hqQ0vxAMOSc+5bJ73174q537wv7Uf9J3nBp8lHNCEY9EARtLAAihkhNQjwlj7J9cM3bbmn+59RX4jHreDMOB41sgHMIhKotVIaMmeYGwhw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hf+pYT12; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hf+pYT12"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752280378; x=1783816378;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=VvgRHkrGkP2ZaRHvUXtwI41sV0GoVtzwC9uCzkk4wsY=;
  b=hf+pYT12xC278ehtkGGcq1mREhg0ihau8E9yA+u2GBbvOeP0gI2uvEhr
   oOVnevLlG0zOaxPQxfpGWfubuZPzBF9sp6xUqxUO8M4lZI7gdBrYnn2jL
   Zt6jKbVFvjHiB4rZLUpxauFarxvghZ7YVSSrzcznsCdgkQe1NVXGyke1F
   V4HvTLTFhbRGHCrTpwXLo8sPkMJZ8+6KJLUCyxppVwyv4ortEh+F9QDq+
   gO1eVSd8Q8AB2BQY4UFePuSRXhUaiod4pBkqYLm9D3mDk+ewaluLyKvMT
   qpEApYYYT8XfgtZyYmQoDFGw39Ka/3TrAAxpodtlRT2m0Wwwm2GcVo5Rh
   w==;
X-CSE-ConnectionGUID: qEYABl+iR/CcRCTAW+krzg==
X-CSE-MsgGUID: mAmK4u3GQCSBGO1sele0ag==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="58387948"
X-IronPort-AV: E=Sophos;i="6.16,305,1744095600"; 
   d="scan'208";a="58387948"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 17:32:57 -0700
X-CSE-ConnectionGUID: 9Py8oyclSEeqCnkTbs49GQ==
X-CSE-MsgGUID: 8JhNapcNRZiazTrt8+MM/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,305,1744095600"; 
   d="scan'208";a="180168578"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 17:32:57 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 11 Jul 2025 17:32:56 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Fri, 11 Jul 2025 17:32:56 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.78)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 11 Jul 2025 17:32:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=enW128Mpz65k+CBoDbT4RUm97ZTkebQm6ESlzsBEGCo9qVLQhLTV2WDR1PSxYrk1meFZfK4HUdPszmbnEX05/LIpN9blNWFldkx9LlLgq7cI+cXcJFsrmic+pMBPAJQALr7xVGUWu+6AAhl90QkuYSL4sy7G8sWPtfgB0jm+aS3mFb8a+aRn0O0MAfgcxtaKJzvTilbE5YtYp/hZuH41n89g9qAAHv1CRa/ENYajXHx8tR8wzyf5AAK+3m+gMmuIelPBWU05EzZ5WUnUmr7FBZvyviJ0El68IKM1RPfr5Nh7KZlTdfnXv6kbmG4UC0+7uN8ggGEYN0HoISxHxR4Rdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YHQ8lMtKyMX9cmE/POeiXRN+0cv+kIzIawcn+YgL864=;
 b=u8aUuddEuN+W7VpHsDYKPAIVEo8cy4LW0p58dKzNwW0cx4dp434u6zgQW/eg8VhTvZSMyjtMPVOJ9X94/JcUqbMPdSasJnnYmrR7jgatsfyBnrJotmkBP3ES6hTBfIYoqu4i8UUVsHtqr7NquPBZgO9hEc3uuk6MaUmFmt/B0Uh5HC5LtVns5UMZ6YU6c9Ir59xQoSha4YSLTx5I+vW8JHwy5bJS7lD0xrEhmzStvMxPaxiIhHipuJQyOgJRbH9ADaJwXiVHzhNzP2+D0UmBJwqmG6+FWpXIY0Fo1Ks2ze7Jho+EipBr7uGRFpy30CPtBHJzFqYkdeV5Coq0CVad5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SJ2PR11MB7476.namprd11.prod.outlook.com (2603:10b6:a03:4c4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.26; Sat, 12 Jul
 2025 00:32:53 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%6]) with mapi id 15.20.8901.024; Sat, 12 Jul 2025
 00:32:53 +0000
From: <dan.j.williams@intel.com>
Date: Fri, 11 Jul 2025 17:32:51 -0700
To: <marc.herbert@linux.intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <alison.schofield@intel.com>,
	<dan.j.williams@intel.com>
CC: Marc Herbert <marc.herbert@linux.intel.com>
Message-ID: <6871ad33d0733_1d3d1007e@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <20250611235256.3866724-3-marc.herbert@linux.intel.com>
References: <20250611235256.3866724-1-marc.herbert@linux.intel.com>
 <20250611235256.3866724-3-marc.herbert@linux.intel.com>
Subject: Re: [ndctl PATCH v3 2/2] test: fail on unexpected kernel error &
 warning, not just "Call Trace"
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0202.namprd05.prod.outlook.com
 (2603:10b6:a03:330::27) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SJ2PR11MB7476:EE_
X-MS-Office365-Filtering-Correlation-Id: a3d12123-936d-4d72-ce93-08ddc0dba3c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bmFtVFpWUTgvc3JiOTRGT1lZY2t5SUhQanR0OVhzRC9NSFFkckU2SXBOLzB2?=
 =?utf-8?B?Y3pzcWdiT3JKTDZiY3QxUTZNRlVmaTRaT2VneG0weXpweTBBVnVwemlUUk9m?=
 =?utf-8?B?TVkyUmw4K2NoQ251elhBdkhBRUlyTFo2bENJZjNWSHoxcHdBWkVoMFVxc004?=
 =?utf-8?B?SzBWS00xN3UvQ2V3d1VhUnJ6c0txRSsrRmdHeFZwVGVQUlZVRkNsZmFpdzBR?=
 =?utf-8?B?RURNL3Z0ME9CSHdwQVZxS0EvN1NJYlhONTlzbCt5ODRqRUtZQWhpbHAyZmtG?=
 =?utf-8?B?U0VsVm1jcGRjMDJrQ2YxMHNPMU1yNDlmMGhKRW1XZXRTOW5xMllWelc1dmpq?=
 =?utf-8?B?a3NkVHl4SVVCVXo3d1N3U1hxZjdUejdqUFJrbWJQdHAyUFUzOWxSR01QZHM0?=
 =?utf-8?B?U1p4UUpGdmE0dHVFaHBOZkx6RGllMS8rRHdMaFRpZlFLOEo5UnR3c21mZmRS?=
 =?utf-8?B?Z0VRSGlMVDFwWUxIUlBYeXNNNW9BQm50cGl4RmFpZ1Bhbk1ONXJEN29KdnQv?=
 =?utf-8?B?cTh2RU4ydytnVmo5czh1UVZCcHpHeHJqV0dKaEFJQWc2cDJtb0ZyUkN2eEJZ?=
 =?utf-8?B?bnh2Y3NtQkRmbUs3Sm81dmxUdVN0bDNVNU9rTFZoUmZScFVZSktYSWRjR1FQ?=
 =?utf-8?B?UVd1WlU2cUJBWVF6RTJQV1JJc092YTlVbTJUdWNpbnphWHFuZzg3TXN3aDBW?=
 =?utf-8?B?L2RSY21Zb2d6bi85RW1adHR6M04ySko5SnNZZlYxNWxUS1VJcnlYdHdleFo5?=
 =?utf-8?B?KzJNWnpsbmVUZ3hMaHcrbWE1cS9yejhnZ3VnV3RFTkltaTFDQnBnUWl6U3VZ?=
 =?utf-8?B?Qm9UYUdXYThRZmgyREo0d29FSitOUm5QS3kvNkh2TTdtcHJkS1YzM29KR080?=
 =?utf-8?B?ek03WGZPT2xlaFB2cVVNaHF0ZUZUbkpZSDhMbXZneVo2aE9DeXhHYnZYUElv?=
 =?utf-8?B?bjF5Nzdsc0xBaHpraUREQ25KRTlBKzBRU2djRUNqTHU1bDR5UTE5dlhvNnVF?=
 =?utf-8?B?dHI4M0JKNzRaY0xrRXdVSGZXMnFjY3BBam0xZGVGMEEzL3hEUExNelFlNFZr?=
 =?utf-8?B?L01tMjk2SDRMV0Iwd0diUkNTUTE0S1VPcDRDMWpVa3BOSlJHeHJvWTVYcUE1?=
 =?utf-8?B?dGZQZWR0QVFpTnU2MGNEWjdjbFpUY2FwTlZGYUlGU01jWkZNUGN5QmtvaTZT?=
 =?utf-8?B?c25XZjZieTlUdEZ3OHJBWHhONDBCN002MTR3M2NLUnA0UFFUZkttNkFOM1Iz?=
 =?utf-8?B?a0d2MllucG40b1MvZ0ZEWTFQYWlTbUx4bVlJTjl6UnRKOUJ1MnAzSVFjanBt?=
 =?utf-8?B?L1J4cEtiNFdaTy9KRjIxclFKc0lNdVI4MmhVSlR5N3o5S2JhK2dzOGZxQVpp?=
 =?utf-8?B?UDRvd3JVVzR2ekVQeTFsUHpZYmVHeldYcGdINEhDRUh0UjlmcmIxOWY5amVw?=
 =?utf-8?B?Rmdpa1labFZQMWpnQzE1T0VUUnJ1Q2J0QXJxWFlQcjR3eUc2TjNnckNlSDRQ?=
 =?utf-8?B?WE80OU9QT2wvSHptVXRIdFJNMzRlSkNjay83WEZPd29xSlRuREp5Q0szTC9N?=
 =?utf-8?B?aWl1M2l5Z2VCQXNGcFV3OWlNcnlqMTduSEkwMVpWL0VWb01oTk1Pd1pJcXFE?=
 =?utf-8?B?RlZkZ1RxaExmUVc3QUdJSWd2QkJFakQrbTFwcWhqUG0wd29sckZodmt2UVR1?=
 =?utf-8?B?M2RnZ0RyQjlNNHYzU0xhdU9jcVllYWFHVHZrcFFhczlrVGFoWmdpdExZS1RX?=
 =?utf-8?B?Z0Y4MlpRanExWXl5NkxrSGlqQ0JxZnpsN21WdHlaQll3OEo4SGpIWFgrd1Fl?=
 =?utf-8?B?SmJqbTlzcHFZQ2tjN3k4OGFnd0E2VUQ2N0Fvb2dlaXRYR1hGVVNDUkZoeWxs?=
 =?utf-8?B?VFU1WE0rNXl1aDdxUEYvMXZpNjh1clRKYlE0QWJXZVlLK1E5V0VGWGRpU1Bh?=
 =?utf-8?Q?qCMqxQaVQ3s=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b0N1ZU1iQS94UFQrclkvMTFqTlNUQ2piS002YU5uT3RsaDR0dmxaQkgrSkFT?=
 =?utf-8?B?OHZ2ZUFqMFFmSFdPNVFPdXZxdjM3MWZQMDdYcVlOdFFrWlVmdFRQTVBaWmFR?=
 =?utf-8?B?NlRzUDlqRGgwc25mQ0pZblRoYm5lSHJEQWx6b0N3TU1JaFVOd3dzUDhiRFpY?=
 =?utf-8?B?SmFsR3NwTlIyT0d5aURKQ0x2K2RWRjMrRFBEUmhyOEdRZm9qOCtQOENBVERR?=
 =?utf-8?B?R2Zwdy9zNkN2YnZ1amZmbGthVmo0ZVAwaVdJRkdDUk9Pek1pQkhDd1VuZDNE?=
 =?utf-8?B?eWVVUWVoeXhpTVE5UzAzbTNjUUFZZDQyMHNDQThpQ3NLQk45VERMQVN3ZXN6?=
 =?utf-8?B?dlBGMVdTT0R2dW04M05mRjhrVVlILzFBNjRGdUlhVjV1TjVaWDJDYkI3U1Bv?=
 =?utf-8?B?VVV4UGhDWXUzYnVGZXlsbGxrS1BEdDB0Z2hpSGtOaUdTbHhzK2Q2WEQ2TWhH?=
 =?utf-8?B?YWtqYi9ab3hyRU54RjQ0ZlZHQWl0QWljaWJwY01qNjlWS0pTWUhvREM0cGJF?=
 =?utf-8?B?a083Q2xzd01maE5SbUxjSDBXYVhER216UksydENBd3dmNWZUWTV6SFZTWlEx?=
 =?utf-8?B?VUJuMUZDVnRubkM5L09JWmRSK0xyZzhIbm9VNmpiSTZlaEp2Zjh1TXd4ZWx4?=
 =?utf-8?B?YStRN2xZUElURWs2bytibE5adFdHaW0zaThDdW56TEpDVjFsNHM0Zkk1U1JE?=
 =?utf-8?B?QldtMUhJenBnc25TV2MrcGlIZS9OQmJUS0xjUld4V3RzdW41bWpSYllzOU1r?=
 =?utf-8?B?WWN2VkFHMGVORGNhZGVSMUNpa1g1Zk8zdkNkditSRWpXRnZFZnZPVTNrWnVW?=
 =?utf-8?B?bmNHcnNHOEJlR0pYYzBJTmloTTg0VElTRXpseFNwa1JLUCt4TjNCUDMyRDQv?=
 =?utf-8?B?K3NMU1BkUzlyeUYrS1lJNUtqWWJUcEk5U1Jod1FDM3k1U3RvVUtCWmdROElj?=
 =?utf-8?B?ckJtUDJGcTB2SzkyeklKNzV6Zm43RWR6d3NqWlBIVzNkcnExZElPRm8xSm9E?=
 =?utf-8?B?ZjBzYXZiditXZksrM1NMdks4OHdTbGpwWGtBR1dBYzVielFHNjdqT3ZBbnhN?=
 =?utf-8?B?NmFJR3lXa1NtYUJEZ3JzMDgxdFFUMzUzbGJsS2lhdTRTbzU0U2kxeXhBZzla?=
 =?utf-8?B?MllyMUo2c1F3KzJRdGV2QlBMSURnME5rQW1sbHRhY2Y4Y2h5NUovMzY3RlJI?=
 =?utf-8?B?TFBxQXRqanM1S1F1dnBEMVBkRGgwQkV5RmxCck10MGVPeWlDM2UwLzV4c3FK?=
 =?utf-8?B?NEJjK2tiQ0hDNEFyVGVWell2YW84M2I3MU1JS0k5N2I0dGo5NzY2N1VpbEEr?=
 =?utf-8?B?NW9FalMySnlNUGUvMGlHQTdUUFlyc2lmTGhVN1lSL0xQSXNBZG9kdWpKc09z?=
 =?utf-8?B?ZERTWFo4NHBSVkswbDloVXk2K2tDTHBYbitTZy8rSnFmQlVQempNVVlxU29R?=
 =?utf-8?B?YmRFOCtPUmlkdEJ0VTVzQmRlVkRRdWs2N2lnK0RqQm5Dc1VrSGJ1NU1pcGhY?=
 =?utf-8?B?eE8rSmpZRXpTNWZGUEFLZXUyU0dUZjJxcDc3VTdwK0FkSCtkbVoxcjV0RE02?=
 =?utf-8?B?Nk9jLy9qSVExdEhRbWFmaUhsWndRMUV6ZGJzWTdJKy90aDBQVFFhTFcxYk9j?=
 =?utf-8?B?OU5xV2lFWHBkbnJnbUZQcklmbUF6RVJiQVcxQndvRnlDRGY3UDlwbVM0c0d1?=
 =?utf-8?B?Wmc4RnlQWGRMb1FmMnRBYmJPOW5YYkpBb05xd3dlUlUrTDNNdXd1VndpQlZ2?=
 =?utf-8?B?VVhmeXFLMVE5SnVCeG12Z0Q3UkRxNkxYTmZYcFhwaHY0S1pvbDF4elBDdi9K?=
 =?utf-8?B?SHlGVWIvL3lTOHdDQnNRZEt5YXIwSm0va0pOZm5nRDZRSWlRb1o1Y293bW52?=
 =?utf-8?B?Sk1IUy9UendKSzVtOTFTTDJacUVqeVRtR3VTRjVma0U4WEp0TkN5S0owdXpQ?=
 =?utf-8?B?Y0lGVmJ1Z2tBbVF4VnR5Nk5OWFAvSUhFdzVPQm11S0ZFU2dIK3loaHU3ZDRI?=
 =?utf-8?B?UEdpdGZCdUFVT2lYM1h0L0lJUXFlMG44bjBMWDdZN3VUVURjbjNaN1VkSEFk?=
 =?utf-8?B?YXdXUGVNWFBTd2VSMHBFUXFjaldaZnorbnEzQVcxVEFuUmRGcFNKajR1YUVQ?=
 =?utf-8?B?cTZuYUU1cFg5NFk4Y0lOVkkrTHFmZzBpTk05Z1J4MWZlYXAvcmVDZ2VUS2ow?=
 =?utf-8?B?UXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a3d12123-936d-4d72-ce93-08ddc0dba3c6
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2025 00:32:53.7628
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2SBMX8FjODXKHsjhNHigJSEXJKYmkE7EjZT8QaRwfwo0fSB4dxcoj+br7Z7s7cKoHuRkAkYEYRPftYGcBhhMt+I0d4KWm1vC8sS1ujpEgFg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7476
X-OriginatorOrg: intel.com

marc.herbert@ wrote:
> From: Marc Herbert <marc.herbert@linux.intel.com>
> 
> While a "Call Trace" is usually a bad omen, the show_trace_log_lvl()
> function supports any log level. So a "Call Trace" is not a reliable
> indication of a failure. More importantly: any other WARNING or ERROR
> during a test should make a test FAIL. Before this commit, it does not.
> 
> So, leverage log levels for the PASS/FAIL decision.  This catches all
> issues and not just the ones printing Call Traces.
> 
> Add a simple way to exclude expected warnings and errors, either on a
> per-test basis or globally.
> 
> Add a way for negative tests to fail when if some expected errors are
> missing.

Each subsequent "Add" in a changelog is usually an opportunity to split
the patch into smaller digestable pieces.

> 
> Stop relying on the magic and convenient but inaccurate $SECONDS bash
> variable because its precision is (surprise!) about 1 second. In the
> first version of this patch, $SECONDS was kept and working but it
> required a 1++ second long "cooldown" between tests to isolate their
> logs from each other. After dropping $SECONDS from journalctl, no
> cooldown delay is required.
> 
> As a good example (which initiated this), the test feedback when hitting
> bug https://github.com/pmem/ndctl/issues/278, where the cxl_test module
> errors at load, is completely changed by this. Instead of only half the
> tests failing with a fairly cryptic and late "Numerical result out of
> range" error from user space, now all tests are failing early and more
> consistently; displaying the same, earlier and more relevant error.
> 
> This simple log-level based approach has been successfully used for
> years in the CI of https://github.com/thesofproject and caught
> countless firmware and kernel bugs.
> 
> Note: the popular message "possible circular locking ..." recently fixed
> by revert v6.15-rc1-4-gdc1771f71854 is at the WARNING level, including
> its Call Trace.

This looks promising to me, some comments below.

> 
> Signed-off-by: Marc Herbert <marc.herbert@linux.intel.com>
> ---
>  test/common            | 137 +++++++++++++++++++++++++++++++++++++++--
>  test/cxl-events.sh     |   2 +
>  test/cxl-poison.sh     |   7 +++
>  test/cxl-xor-region.sh |   2 +
>  test/dax.sh            |   6 ++
>  5 files changed, 149 insertions(+), 5 deletions(-)
> 
> diff --git a/test/common b/test/common
> index 74e74dd4fff9..8709932ffbbd 100644
> --- a/test/common
> +++ b/test/common
> @@ -15,6 +15,28 @@ err()
>  	exit "$rc"
>  }
>  
> +time_init()
> +{
> +	test "$SECONDS" -le 1 || err 'test/common must be included first!'
> +	# ... otherwise NDTEST_START is inaccurate

What is this protecting against... that the test makes sure that
NDTEST_START happens before any error might have been produced?

I think the proposed anchors make this easily debuggable, there are no
tests that include test/common late, as evidenced by no fixups for this
in this patch.

> +	NDTEST_START=$(LC_TIME=C date '+%F %T.%3N')
> +
> +	# Log anchor, especially useful when running tests back to back
> +	printf "<5>%s@%ds: sourcing test/common: NDTEST_START=%s\n" \
> +		"$test_basename" "$SECONDS" "$NDTEST_START" > /dev/kmsg

Why is SECONDS here?

Note that there are some non-shell tests in the suite, not for CXL, but
might want to make this consistent by following on with wrapping those
tests in a script.

> +
> +	# Default value, can be overriden by the environment
> +	: "${NDTEST_LOG_DBG:=false}"
> +
> +	if "$NDTEST_LOG_DBG"; then
> +		local _cd_dbg_msg="NDTEST_LOG_DBG: $test_basename early msg must be found by check_dmesg()"
> +		printf '<3>%s: %s\n' "$test_basename" "$_cd_dbg_msg" > /dev/kmsg
> +		kmsg_fail_if_missing+=("$_cd_dbg_msg")
> +	fi
> +}
> +time_init
> +
>  # Global variables
>  
>  # NDCTL
> @@ -143,15 +165,120 @@ json2var()
>  	sed -e "s/[{}\",]//g; s/\[//g; s/\]//g; s/:/=/g"
>  }
>  
> -# check_dmesg
> +# check_dmesg() performs two actions controlled by two bash arrays:
> +# "kmsg_no_fail_on" and "kmsg_fail_if_missing". These list of extended
> +# regular expressions (grep '-E') have default values here that can
> +# be customized by each test.
> +#
> +# 1. check_dmesg() first checks the output of `journalctl -k -p warning`
> +# and makes the invoking test FAIL if any unexpected kernel error or
> +# warning occurred during the test. Messages in either the
> +# "kmsg_no_fail_on" or the "kmsg_fail_if_missing" arrays are expected
> +# and do NOT cause a test failure. All other errors and warnings cause a
> +# test failure.

Is there a mechanism to opt-out of errors and warnings. Sometimes
upstream gets overzealous with chatty dmesg and it would be nice to
quickly check if tests otherwise pass with ignoring messages. Then go
spend the time to track down new messages tripping up the test.

Otherwise I do like that this causes people to be careful in the
messages they add as new warnings and errors are things that distros
debug for customers on a consistent basis.

> +#
> +# 2.1 Then, check_dmesg() makes sure at least one line in the logs
> +# matches each regular expression in the "kmsg_fail_if_missing" array. If
> +# any of these expected messages was never issued during the test, then
> +# the test fails. This is especially useful for "negative" tests
> +# triggering expected errors; but not just. Unlike 1., all log levels
> +# are searched. Avoid relying on "optional" messages (e.g.: dyndbg) in
> +# "kmsg_fail_if_missing".

This feature feels pedantic, not grokking the immediate value. Perhaps
stage this at the end of the series.

> +#
> +# 2.2 to make sure "something" happened during the test, check_dmesg()
> +# provides a default, non-empty kmsg_fail_if_missing value that searches
> +# for either "nfit_test" or pmem" or "cxl_". These are not searched if
> +# the test already provides some value(s) in "kmsg_fail_if_missing".
> +# While not recommended, a test could use check_dmesg() and opt out of
> +# "kmsg_fail_if_missing" with a pointless regular expression like '.'

Is this not captured by modprobe failures?

> +
> +# Always append with '+=' to give any test the freedom to source this
> +# file before or after adding exclusions.
> +# kmsg_no_fail_on+=('this array cannot be empty otherwise grep -v fails')
> +
> +kmsg_no_fail_on+=('cxl_core: loading out-of-tree module taints kernel')
> +kmsg_no_fail_on+=('cxl_mock_mem.*: CXL MCE unsupported')
> +kmsg_no_fail_on+=('cxl_mock_mem cxl_mem.*: Extended linear cache calculation failed')
> +
> +# 'modprobe nfit_test' prints these every time it's not already loaded
> +kmsg_no_fail_on+=(
> +    'nd_pmem namespace.*: unable to guarantee persistence of writes'
> +    'nfit_test nfit_test.*: failed to evaluate _FIT'
> +    'nfit_test nfit_test.*: Error found in NVDIMM nmem.* flags: save_fail restore_fail flush_fail not_armed'
> +    'nfit_test nfit_test.1: Error found in NVDIMM nmem.* flags: map_fail'
> +)
> +
> +# notice level to give some information without flooding the (single!)
> +# testlog.txt file
> +journalctl_notice()
> +{
> +	( set +x;
> +	  printf ' ------------ More verbose logs at t=%ds ----------\n' "$SECONDS" )
> +	journalctl -b --no-pager -o short-precise -p notice --since "-$((SECONDS*1000 + 1000)) ms"

Why is SECONDS here and not NDTEST_START?

> +}
> +
>  # $1: line number where this is called
>  check_dmesg()
>  {
> -	# validate no WARN or lockdep report during the run
> +	local _e_kmsg_no_fail_on=()
> +	for re in "${kmsg_no_fail_on[@]}" "${kmsg_fail_if_missing[@]}"; do
> +		_e_kmsg_no_fail_on+=('-e' "$re")
> +	done
> +
> +	# Give some time for a complete kmsg->journalctl flush + any delayed test effect.
>  	sleep 1

Feels magical. The sleep was only there to make sure that SECONDS rolls
over. If a test has delayed effects there is no hard guarantee that 1
second is sufficient.

> -	log=$(journalctl -r -k --since "-$((SECONDS+1))s")
> -	grep -q "Call Trace" <<< $log && err $1
> -	true
> +
> +	if "$NDTEST_LOG_DBG"; then
> +		journalctl -q -b --since "$NDTEST_START" \
> +			-o short-precise > journal-"$(basename "$0")".log
> +	fi
> +	# After enabling, check the timings in:
> +	#    head -n 7 $(ls -1t build/journal-*.log | tac)
> +	#    journalctl --since='- 5 min' -o short-precise -g 'test/common'
> +
> +	{ # Redirect to stderr so this is all at the _bottom_ in the log file
> +
> +	# Fail on kernel WARNING or ERROR.
> +	if journalctl -q -o short-precise -p warning -k --since "$NDTEST_START" |
> +		grep -E -v "${_e_kmsg_no_fail_on[@]}"; then
> +			journalctl_notice
> +			err "$1"
> +	fi

Per above, add an opt-out for this.

> +
> +	# Sanity check: make sure "something" has run
> +	if [ "${#kmsg_fail_if_missing[@]}" = 0 ]; then
> +		kmsg_fail_if_missing+=( '(nfit_test)|(pmem)|(cxl_)' )
> +	fi
> +
> +	local expected_re
> +	for expected_re in "${kmsg_fail_if_missing[@]}"; do
> +		journalctl -q -k -p 7 --since "$NDTEST_START" |
> +			grep -q -E -e "${expected_re}" || {
> +				printf 'FAIL: expected error not found: %s\n' "$expected_re"
> +				journalctl_notice
> +				err "$1"
> +		}
> +	done
> +	} >&2
> +
> +	# Log anchor, especially useful when running tests back to back

This comment is going to go stale, I do not think it helps with
understanding the implementation.

> +	printf "<5>%s@%ds: test/common: check_dmesg() OK\n" "$test_basename" "$SECONDS" > /dev/kmsg

I like this, I have long wanted anchors in the log for coordinating
messages.

> +
> +	if "$NDTEST_LOG_DBG"; then
> +	    log_stress from_check_dmesg
> +	fi
> +}
> +# Many tests don't use check_dmesg() (yet?) so double down here. Also, this

A comment like this belongs in the changelog, not the code. I don't want
review later patches fixing up the "(yet?)", a comment should help
understand the present, not comment on some future state.

> +# runs later which is better. But before using this make sure there is
> +# still no test defining its own EXIT trap.

> +if "$NDTEST_LOG_DBG"; then
> +    trap 'log_stress from_trap' EXIT
> +fi
> +
> +log_stress()
> +{
> +	printf '<3>%s@%ds: NDTEST_LOG_DBG; trying to break the next check_dmesg() %s\n' \
> +		"$test_basename" "$SECONDS" "$1" > /dev/kmsg
>  }
>  
>  # CXL COMMON
> diff --git a/test/cxl-events.sh b/test/cxl-events.sh
> index 7326eb7447ee..29afd86b8bf8 100644
> --- a/test/cxl-events.sh
> +++ b/test/cxl-events.sh
> @@ -26,6 +26,8 @@ rc=1
>  dev_path="/sys/bus/platform/devices"
>  trace_path="/sys/kernel/tracing"
>  
> +kmsg_no_fail_on+=('cxl_mock_mem cxl_mem.* no CXL window for range')

I want to see the other benefits from this patch before debugging
whether this exclusion needs a fixup somewhere else. So lets break out
the kmsg_no_fail_on mechanism separately from the base dmesg time,
anchors, and err / warn infrastructure.

> +
>  test_region_info()
>  {
>  	# Trigger a memdev in the cxl_test autodiscovered region
> diff --git a/test/cxl-poison.sh b/test/cxl-poison.sh
> index 6ed890bc666c..8b38cb7960b0 100644
> --- a/test/cxl-poison.sh
> +++ b/test/cxl-poison.sh
> @@ -9,6 +9,13 @@ rc=77
>  set -ex
>  [ -d "/sys/kernel/tracing" ] || do_skip "test requires CONFIG_TRACING"
>  
> +# FIXME: this should be in "kmsg_fail_if_missing" but this test seems to
> +# work only once. Cleanup/reset issue?
> +kmsg_no_fail_on+=(
> +    'cxl_mock_mem cxl_mem.*: poison inject dpa:0x'
> +    'cxl_mock_mem cxl_mem.*: poison clear dpa:0x'
> +)

Yeah another fixup that should be done independently from the base test
infra.

> +
>  trap 'err $LINENO' ERR
>  
>  check_prereq "jq"
> diff --git a/test/cxl-xor-region.sh b/test/cxl-xor-region.sh
> index fb4f9a0a1515..d1a58023a61e 100644
> --- a/test/cxl-xor-region.sh
> +++ b/test/cxl-xor-region.sh
> @@ -16,6 +16,8 @@ modprobe -r cxl_test
>  modprobe cxl_test interleave_arithmetic=1
>  rc=1
>  
> +kmsg_fail_if_missing+=('cxl_mock_mem cxl_mem.* no CXL window for range')

Not sure I want to fail this test if we fixup this message.

> +
>  # THEORY OF OPERATION: Create x1,2,3,4 regions to exercise the XOR math
>  # option of the CXL driver. As with other cxl_test tests, changes to the
>  # CXL topology in tools/testing/cxl/test/cxl.c may require an update here.
> diff --git a/test/dax.sh b/test/dax.sh
> index 3ffbc8079eba..0589f0d053ec 100755
> --- a/test/dax.sh
> +++ b/test/dax.sh
> @@ -118,6 +118,12 @@ else
>  	run_xfs
>  fi
>  
> +kmsg_fail_if_missing+=(
> +    'nd_pmem pfn.*: unable to guarantee persistence of writes'

This one is not valuable for this test.

> +    'Memory failure: .*: Sending SIGBUS to dax-pmd:.* due to hardware memory corruption'
> +    'Memory failure: .*: recovery action for dax page: Recovered'

These are useful.

> +)
> +
>  check_dmesg "$LINENO"
>  
>  exit 0
> -- 
> 2.49.0
> 


