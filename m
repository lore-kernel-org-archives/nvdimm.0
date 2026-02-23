Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C9E37AA8A
	for <nvdimm@lists.linux.dev>; Mon, 23 Feb 2026 22:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771887060; cv=fail; b=CqqyXj9QuM0YZb0/i3f2B2dihqUYYC8ygPvFiL6WFQjyTuBzXNBNs2gziMuAlrYXmV7ibIPP8W79BeJwdeS3QjPK3Vskx7pSRGDzMy2lCs1szSSyOneYrMvkHJ7vqfSdJ0fYIESiEVcTudcquDWQryZId+KhPMSpDvczmDtQ50U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771887060; c=relaxed/simple;
	bh=Fpm7hvtSxGQ5rYY21wXbPu27oZ8FsFqgOcittpDQMeI=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=EpQJGwa19UujTbZlvNb9pnHgOwHLJqihNYmNN4fZpSRReEUaHDFbrsjCEfQk0cZBk976SqyYpIjS5CpC3zV8IwWt56FJ4K1aQz8tP6rWao8Q56sv9cdeB0rgdkSLN2MAbO49Opdeb+cGVLgrbqUaa0S+7VC0wk4awgVYcpLg7QY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MU8Pnk2w; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MU8Pnk2w"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771887059; x=1803423059;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=Fpm7hvtSxGQ5rYY21wXbPu27oZ8FsFqgOcittpDQMeI=;
  b=MU8Pnk2weBUJYGFmQtSxVFeQXFOQjUaquVFOkfp+YiPYTa+IERS4rqt+
   4PED4HFXdnXyM/drC8VrEnrgADR8xTFCypept4L84JCZPtY9Ye1/8UdL0
   kDYiSkEAv5mEYE3R4xbqDqOTPyZATAhyg6tUJBhclAGDu3cRm9SmKlkZY
   NoSZjrTvqqhnldiZ7KjmqX30L5BuIRUmfVPgwCfByfzIpi7tBixdHMClv
   RAg8xLLieodBLVg0d3mVepqXVbWQhlvyLWw6sP7C6ZfY5sGxT6piWDotc
   b/pEoXH66YtHLapm+Ah6/C7sxFEE2E6rWz4pfst1GgwQac9bD+3W6O/9T
   g==;
X-CSE-ConnectionGUID: nZZAuZXVRL+hN0li/9aEDg==
X-CSE-MsgGUID: iqRzEN9PSi6mNiKoG6+Jsg==
X-IronPort-AV: E=McAfee;i="6800,10657,11710"; a="76506197"
X-IronPort-AV: E=Sophos;i="6.21,307,1763452800"; 
   d="scan'208";a="76506197"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2026 14:50:59 -0800
X-CSE-ConnectionGUID: 3+oxlcW+RkKtSsnfDao35w==
X-CSE-MsgGUID: OQntlzGdQ1O1flQWBpV02Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,307,1763452800"; 
   d="scan'208";a="213591852"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2026 14:50:57 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 23 Feb 2026 14:50:57 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 23 Feb 2026 14:50:57 -0800
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.59) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 23 Feb 2026 14:50:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qJrV+zNkMXRTtQ24vq37bfDQHM/rV65amwLlNJnqjQqp+J6Pu6JKmQ1r2NdU1fdKdGAKKSHsJbbelgBnnUK65vNvalfLjqI05mizh7+RmCpijEYfuxZrTR68sAD/PMchh1O9KtkvzlP55ka8CPfFf1BoUzq3JVB8xIDV3jOOjoGHI7QTvx595CRgVHkGJuIEjjCOPgZslCAxmgKc30j3DOPZQbE46vjkPcilYLBjlIG3sf8U+FONz0KzVYnZ/r5DWVMODXWWYo/3ewTOc9v9n96VomXZU8XdjPTWaYsIqlneaJFHjG4CLg6loB4FZTasZdXB0m2GOwdhcrs8CSpgLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6aATa1wSBdHQ9m9ybnkqNULkA2xOesb1jXrwSg1KsGs=;
 b=DcS/mVM2k7PnQaqF+WV9Dt8t6/hXk41Ikd51goetxXhVTiJJ9MyFGktWEgFo/Bg2sVaLXvS6vnids6QlClUAJ1t/wfUPnAZPVSBvEkibU6z12uk+1Cf0f/smM5R8q3mqZfVh05mlbl9YNXYqKDe/KUXxWNPNufKkdF77Uwxhtcjiltdnp9yPXMmOfZr8ZhUDCjqWRcshmErzh06jarTNptwpcpw3ZcgSyNDkmEWwc1BJ6rHx4aqtJYDeLOkzBpCRWadv2hq6R823Rl93P5fYgm66VieXrdLIMNMI8ZOwgYfVO7RniHlgsj2+6gUdvZr7v9LgFKqCkZe//h7ORbzUSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SJ5PPF035FE4CB7.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::805) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.16; Mon, 23 Feb
 2026 22:50:52 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%5]) with mapi id 15.20.9632.017; Mon, 23 Feb 2026
 22:50:52 +0000
From: <dan.j.williams@intel.com>
Date: Mon, 23 Feb 2026 14:50:49 -0800
To: Bart Van Assche <bart.vanassche@linux.dev>, Peter Zijlstra
	<peterz@infradead.org>
CC: Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, Boqun Feng
	<boqun@kernel.org>, Waiman Long <longman@redhat.com>,
	<linux-kernel@vger.kernel.org>, Marco Elver <elver@google.com>, "Christoph
 Hellwig" <hch@lst.de>, Steven Rostedt <rostedt@goodmis.org>, Nick Desaulniers
	<ndesaulniers@google.com>, Nathan Chancellor <nathan@kernel.org>, Kees Cook
	<kees@kernel.org>, Jann Horn <jannh@google.com>, Bart Van Assche
	<bvanassche@acm.org>, Dan Williams <dan.j.williams@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, "Alison
 Schofield" <alison.schofield@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>
Message-ID: <699cd9c94943b_2f4a10073@dwillia2-mobl4.notmuch>
In-Reply-To: <20260223220102.2158611-5-bart.vanassche@linux.dev>
References: <20260223220102.2158611-1-bart.vanassche@linux.dev>
 <20260223220102.2158611-5-bart.vanassche@linux.dev>
Subject: Re: [PATCH 04/62] dax/bus.c: Fix a locking bug
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0008.namprd08.prod.outlook.com
 (2603:10b6:a03:100::21) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SJ5PPF035FE4CB7:EE_
X-MS-Office365-Filtering-Correlation-Id: 258156c1-2b60-4c31-bba0-08de732dfec8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?QW9vRExjSCtHOWFSQ29ZR3JOaUdXbTRWNkNZOEl3OWNwck5OcklXYnRDdWRp?=
 =?utf-8?B?Wk1qYWRScDFxMS9OQ3pDUGRUSnBXb25ZcmNiZlE0ZHF5NEtVNFJxRHlwWCtV?=
 =?utf-8?B?UlR4L1VzYVp5Uys0RUZ3OFVqQXlYZ0RneWhrTEt2OUFSUEdKUCtsY2lyWXFB?=
 =?utf-8?B?amxBZ1E1cTY5Rnp2Mzk3dXRnbXQ0RWpOUkkvSVp3b05sdTdrQXBFSFJWRDJG?=
 =?utf-8?B?NW1QV3p2eXYvcG5zcCtrblU4YzdsUGgycmtsV3ZUWTdHQWlZMU1pa1hjemFi?=
 =?utf-8?B?VnhpTkNlN3pzZ3hkS0d3NjFqdVZRNzczQTcrSjhSRGc3TVNodzZrME9JdHJu?=
 =?utf-8?B?b1JqRStpbFpEU1VBSGQ5NHZBd3JJT0xKeFFSWDlMbWlMdkIvQWcwTmhYZWUz?=
 =?utf-8?B?SytmK2FxQk5ITGJ6NUZzRHEzTUcxWVpNVFpqU28yTVVWVHpLTHF2UzhwWkxJ?=
 =?utf-8?B?RjEzR0tXeVBwTngxZXA4TVlKRFM3T0NIWVQvNUxGeHFiK1lnTXB2RWM0VVpv?=
 =?utf-8?B?R09GZWVEYUIvYUJUaEVZVjB6YnJybWJmQ2YzWVh6NllHalpGejU0b0Fqd0M5?=
 =?utf-8?B?NEpWTkFtN3dGaFQ1Ym1nRzA2cTdnZVBLWndsS3YwSG9BamJUMDU4b0ltZ3Az?=
 =?utf-8?B?WVViTnd5U3RXbHpQRVM0TXZMMlFvSzg4N2t1ZTUwd3FvZXB0S1hUYm81Nlpm?=
 =?utf-8?B?UWFSc0ZWY1loMDh0Ukx1OU4xd0VJOHErZFYvWnk2MHRxd0R2NHIxYncrNUhF?=
 =?utf-8?B?RUNkMjRMY213U3dyWWNXTjYzSXVMNzZXV210c2wybDEvS2lrNCtZMlJFNnFt?=
 =?utf-8?B?dmpkRk5oWUhUTkFwZlYxSGZsTElmbFpXNHRyWi9FM3hSdUEyZnpxR0pUUlh4?=
 =?utf-8?B?eUptVjhNek1Ga3JJa0tVOWFVVm9tMzZoZ3JXSzZXWEVVZTQvZlIrSVN4NW5s?=
 =?utf-8?B?QVNKR0xBUExJRVlxcVdpUzRSTGJ5My9saXNmeWFNM20xVjlKbFRUay9zcWFP?=
 =?utf-8?B?aWZxd1VoN1E1Mk5LQzdGYnFKWlY0NkJheVB4cytyVVRlckZNN3JxSHJMMG5C?=
 =?utf-8?B?Z2dKNEN0OEs4K0dVTXJ2TlFQNDFreEVTSU50Q2RYN1N5QklzUWRsYi9tNXBD?=
 =?utf-8?B?YmNidGlOdUxROXlBUmtDMk15V1hFeHA2aUNEazhYMXE0NzdiUlRHTmVvU1B4?=
 =?utf-8?B?d25oQ3RqRzRjL1hVcXYvYi9MVmlURWQrQUlHODAzTFJSRW52TERUcU5NdGEx?=
 =?utf-8?B?SlB4WHk1eGlJZVRxclgvUUVPblhFcEVRTGZRQjlDUFI5cWVEZ1NmY01SZ3Fh?=
 =?utf-8?B?aXdQTCtuTEdPRWwybTJBcUMyVlBSMmNjWkdEY0JXY0g2L3dzWGhFQWFlMGlv?=
 =?utf-8?B?aHlFK3NRWjE4Nm40Z21QUFZkODNFODV3RWF4TC9GcmFkcDdET2lzeFFuS1Bj?=
 =?utf-8?B?K1pqVDlGWG9UbDZyQTh5WVJuZzRnZTFxZnBoMFJDQ1BQMC9HQVNmUzlLYThS?=
 =?utf-8?B?QStJL1NOVWdwQnVSV3c2RzlKeCt2aTFzUjlWM243TjlWNEd4VExJNGxKSGxo?=
 =?utf-8?B?R2VnRXl2bzUvTDFoT2tFMzQyZTZJek9FMGJhVjYwZFZVV3VDdk95YTU2cFdH?=
 =?utf-8?B?WExNV0hWczBLcTlocXJFSHo2Tkc0Q3l3OWdMcDV4UkRqL3dnT0tSSVMzU2d6?=
 =?utf-8?B?cHJkRkw5UjhqaVpUZUhzRjZmUDNFK1ZQU256bTU4MlE5ZEtFUjExVFJuSkFH?=
 =?utf-8?B?RzBCcE53eUt0NXF6YnRnU1Y3WXNNQWxtNkNmZHBFN1QwL20rcjAwVnNONWZX?=
 =?utf-8?B?T1FQZjhsOVVSbFZWazRrL0wyY0R0VXY1Zml1UTVhVnlwZ3VON21hN2l1R3g2?=
 =?utf-8?B?aHF5eE5zZ1NzUXgzMHBLSjFDQ1JJSW0yR0d5TlE1Vnk1VVlVU0IwY1lmaEZi?=
 =?utf-8?B?R080cDNSa1cwalJWS09iKyt0eTVNcUc1Mys2TVpTN2hNZXJ5bXI0dTlyckdL?=
 =?utf-8?B?TE53SDF6bW1oSHN1US9JNUNuYTVFcUtNSXVSRVNmWWtyNU5SeUg4VzBTOUdB?=
 =?utf-8?B?ekFQZEtRNnBBWjF2bDFuNmhVc2dlTzZGbWNFSE14czhRWXNpK1A4cVAyZGUz?=
 =?utf-8?Q?F2wg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?djcwRmFML1BuVVlmRVN6SEVoTjBQekNnVit5eEhzQ3g3a0NSeFlIbTZiWXhJ?=
 =?utf-8?B?bWZBT0Nza1UwTFQwM3daRVRMbHREZmd1eXkyUUNWWkE4dkNhbTBWTkRJQ1ZD?=
 =?utf-8?B?RURYbktWUGxMWjBEUDVOK1VGTWVKeWJxNVFQem1DMHBMQVhHMmRtTlRYK3Vt?=
 =?utf-8?B?ZFJsVWd6N2dVTC8rczNFc2ZXWmVCYTNQY1QvbFpVNkNmSU9mWmJRckRrbUd1?=
 =?utf-8?B?QnRlT3FpUEJ2NzllZEdXQTU1VHVsMEZrajQwVlJlV24zZkxuSGpXcVQ3U2sy?=
 =?utf-8?B?MWZDV3NvWFF6RG1qUmpLWUQvWEdMeUhpTkhxZXZBQXk0TWVKSW0zNkN2VXB5?=
 =?utf-8?B?VnJYc2xqcG1vRExRRG4zMkxROTJyd1dEemVvcElLalZVZmpSUlpsVEluTWEv?=
 =?utf-8?B?MEgwdUpVRzVNYldDWXJFVHRKV0E0VmZ3cTRHUDF4dDdxS3hDNy84V2tBaEFl?=
 =?utf-8?B?Vi80ckdvTHBqeFdlWHBYS0dKZVlRODFocGt4ZERrczhDVGs4bm5LMTdmY1Zw?=
 =?utf-8?B?bXV5Uk00QXh2ckdKNksyS3dlK3lUMkI2NGpCdkJrR1psUC9zb1luNDNZTTFV?=
 =?utf-8?B?amNaemRzNFlMZWpyVXpzYVFoeU5ZSjQrdFJMb2g4aUJtVk1zYVhZelF3MlF3?=
 =?utf-8?B?UllyK3NLR3B0ek1xbWo1UlV4SUVJcWFoN1pETGkydmRlQTVKcm42U1VXZmRi?=
 =?utf-8?B?NEJDRU9GL082ZVJpQitGZUpKVWgvVmFKYTFMT1FtMWNSMlN1WHlVYlg0eElH?=
 =?utf-8?B?MGh4VHJzRVFtemZJdU1OSzVVNUUwNlhnNndzakRYRlhYZUdnM2svb1dkejBV?=
 =?utf-8?B?QzNRZHhHV044Wk8vayszZktzdUpzUjJpVzBYcHZQSDJJVytFOWhGd0ZlNW5h?=
 =?utf-8?B?M1BpVVk2NjMrQ084cWp2YWxWbGJnMmkxengyRFMvNi91WVpkZkV5QWhZeHhL?=
 =?utf-8?B?MFBscGRJaW9ycWFsa3Jjc1dZejYzaWh6Tzhad2t6RldKdW9zenJCbm9NQXJN?=
 =?utf-8?B?TXQ4eW9UeDJWOEZ6enVLbGRrdlFIbzdrSW1STEtzclNhQzB0Rk96QXoybEtz?=
 =?utf-8?B?ZVJwc09yQnVRYS8zM1gxL2lSV1hxVmJKRjQ0MmFhQzBrSVR5OEsvY0xaTnBi?=
 =?utf-8?B?c1R4S09UN2F6MFRKdWh0L2FWMWVWQjBhSmI2NTFqaFFuaTliRFRIZGtpL3ZE?=
 =?utf-8?B?UlZYYW90ZUoyejM5MUwvMWRsKy9XQjhoMFZEdzJ4cFp1WFkxS2hyUkVwQ3hN?=
 =?utf-8?B?RWo2UHZBTmcyd1IrRmp6ajhPQjdWcEx2UzRaK2l0dXlPLzNRWUpYVERiNEFh?=
 =?utf-8?B?d09ZV3Z2QzhEK2IyVTZDd1cxb09XVVR0cnk5cGNWb3pNUGFBWndkUTd3OTBu?=
 =?utf-8?B?RTluS1c1RmhCOGlqNk5iaVVJT2U4OVAwWFdFYXhsVG8xY2hJbUlrNFhnNU0w?=
 =?utf-8?B?MHdRZ1VEclRLS0NEQkxMM3BMU0d6YU1xSXBIT1FZMGplVzlXbm1kUUZQOUJG?=
 =?utf-8?B?aFhPdmNGenhZeTM5QTJtbmFSZnRYTDVoMGRHZEI0cVVqb29ibEV0TURWcnZy?=
 =?utf-8?B?cE1kNHh1blcyRkhhSFIxZS83WVFETlpnM1ExNkhVQmNBcURoeTdqWkEzNFV2?=
 =?utf-8?B?b2Y0cWFHQmZQR0ZQUmFyKzRrVkVicURrZlc0VzdqMlo4VEJ6SUoySmZ0VU1i?=
 =?utf-8?B?c1YvYVVvM1oyYWUrQmJVQnd2cWxkMWc0cXFta2t4UUNXVEtFNFFnRnhMTHUv?=
 =?utf-8?B?ZDNzSDhrU2JHTXlRMXh6K012NUdTdUQ4VHpLQVhka2dBQllnQldvNUt1SHZz?=
 =?utf-8?B?WVJWdVVRa1ZhRlhmNlRJaGh1dHc0VEgvdXdvOWlubnBYdmQ4K3JUMi92RXJB?=
 =?utf-8?B?T1NxbEhGQ2tHRFRZT2JaRVZSVHAwcDZBR0psaXBFUnZXZmxBWmpqZTdvQ3JV?=
 =?utf-8?B?RW9XcGV2UVJPTmdIUHFhQm5TbkwxUVd2YXFwREpxS2Q3SEEvVEhndncvbmth?=
 =?utf-8?B?WlhrVTRTZ0o3YXVpbTVKZ1BvaW90STBVT2lQVkZtTml1VW1FZEJjdE5rWjJR?=
 =?utf-8?B?dVFCaGpuR0dCN0UyTFNsNjVtcW5GUSt1T25KaE1OamdzbWtxNE1OL1hxWjBW?=
 =?utf-8?B?UndMRzU1SlhCZFNKY1l0TDBKdUZCcmxldCtvMUJnQkJQZHZYaTFKaXlEQTY1?=
 =?utf-8?B?TkdDRUtVZVNHUjJOdWFISFBqTzdMcllJMm5qcjEza2dYU1l6OVpXdEF4dndO?=
 =?utf-8?B?Vk9YYmNURW94NTNFWVg2eWkrQmlEWk52eHhEanExdi9hbjZ3QkRQSnJLOURG?=
 =?utf-8?B?WGJpY1ZkSWh4ZGt6Ym9iY2pxYjZYZzRkRm8vdzJJQXVmVUtWanFodXUxbHZu?=
 =?utf-8?Q?L4Z/UQphJ1RnhILE=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 258156c1-2b60-4c31-bba0-08de732dfec8
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2026 22:50:52.0612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LM40yBHoM6CJrfBZtHdLWJHUyKkOQ+QUqh5cFJBr4X7i3ivYdv6tLpDE2N5ACbz92LwPapAV7IJrRRBwluduSLQPhFA0BVnGaWnnRoZMD9w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF035FE4CB7
X-OriginatorOrg: intel.com

Bart Van Assche wrote:
> From: Bart Van Assche <bvanassche@acm.org>
> 
> Only unlock dax_dev_rwsem if it has been locked. This locking bug was
> detected by the Clang thread-safety analyzer.
> 
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Alison Schofield <alison.schofield@intel.com>
> Cc: nvdimm@lists.linux.dev
> Cc: linux-cxl@vger.kernel.org
> Fixes: c05ae9d85b47 ("dax/bus.c: replace driver-core lock usage by a local rwsem")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
