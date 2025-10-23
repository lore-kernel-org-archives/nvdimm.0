Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23BB233033F
	for <nvdimm@lists.linux.dev>; Thu, 23 Oct 2025 14:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761231297; cv=fail; b=GbrQuiBtrsmYHu9mN8XDbq2iJHLQHAplcoJlqoiJqMASVVXuWECH3g2tdZW3cjnrzIkr2iV5wG7Q1wWkzNer/RS3OyOyW3uBGtlgcJ9z8a+muw5nbItoXMLyWkLj7dXrVA2CfODC5gMU0U4Ti7YEuDDk9YIwgJVLasm8H283kD8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761231297; c=relaxed/simple;
	bh=Awvw2FlS2fUQ9TfSCg259rQipCskIz6UXOLYeaSMsEw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bHB8FcnEHwcFYictseIjFFmAC1Vz3rIHfHX+uTHMejrfOYCd4FQS6J+fQMXEtHzfn8Vl4EaYp0jpZOv1TjoOebD/egRmsumMWKGLoPAyrOXa8QUJowW7ZLwxbh9cJK40H2we02kAGuQ5ztfL14wW9napc06vBWmX3VEFQ300DMc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L8446SnE; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L8446SnE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761231296; x=1792767296;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=Awvw2FlS2fUQ9TfSCg259rQipCskIz6UXOLYeaSMsEw=;
  b=L8446SnEhYGAeV/sg6WOIgyJBImWXyFZ8fCQrlkC8FnLmIoLGZF3EqWc
   /SEqhmWpp/mcBhpqHSPBh0BPpd0D5hIN44jGpSwIJHA5JdmYgqD3Bf8ra
   YYAUhxfjbFTmrkRKJhZOf3vb9jlfQdWvLAxwQ6I/DhwJEgUSffsZIXkoz
   QEAuP2SnBHBKG5wviqf+pglhhA/fy5DUczCfztDDOG4Zsq+VcuFZe5Hx5
   n2uDjxs7G9RMXUzlqN7k36RE1ivlOl3V7flsyKDfPji2fU5pQbimM28Kd
   G63FVx/Ce+rpjW0eKN/3AdKSHkY5w749ilu8MmJrVIOVIcl557+glIQAA
   A==;
X-CSE-ConnectionGUID: fGr0lLXMSjGM/KTD20qF8w==
X-CSE-MsgGUID: k4vf1N8DS+aKKKM6mgT7cA==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="74519771"
X-IronPort-AV: E=Sophos;i="6.19,250,1754982000"; 
   d="scan'208";a="74519771"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 07:54:55 -0700
X-CSE-ConnectionGUID: dx8uS5tCR7iNgA2Wt3XZQw==
X-CSE-MsgGUID: PqoNkOuUQyWwl560VS9ryg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,250,1754982000"; 
   d="scan'208";a="183781574"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 07:54:55 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 23 Oct 2025 07:54:53 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 23 Oct 2025 07:54:53 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.36)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 23 Oct 2025 07:54:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nmwqyqrku3J/vv9mpmffW8F/yj/kqgRm4avpNEpUxR7YRGvJsUQv9nODSJG0V8QJ3GKl1DUZpFBpgWwEAqH6wa+j7tIQJpc//N2K0pv8QerXL0flc8f/azy/V8g/6bB3hOo5arEG8XgRPZOKPoO4f9cTd5YH0T+cqznGYrNMRK9eP1RVYdHf39sd2aXOafh5UafXrOoRuH543bX4mxrMHCFMyrhu+Dlp2rFsWiic39UbBjKL6Hn+9OJqXE3miQCWvxgDbSfh0199o+ADvCLWGRDoSRtSLX7cchxc6UU6viTbleDlBD2AhqRBHkJrTyx+Y+/oB1eCtQlizzF3UkchwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xhC0uW15c7vqhAeYABokwM513NE5okOpITgnXqrAjiM=;
 b=GRIhMHAhxPqfRXyzcjwmhlxnWDMlCIXvj7NXhoYAJEG5nvBze6jBx5oKXbd6ylgjAW+U/KfZr6vyUfkja63JNZHxWXo3MtA3LM1f/3y9CLfHBTB19bJQUJKBciz1Hvtoa6bx2/ceP51Tqm5GB7CdrKdjVjG2+RBtfwBSXOBOGr1Eo1beaj9LivqgSUSzVsoFCvyIV/YOIiU2aCyX4AQYyu0t1AGMQSUvDaJsttgoGIiTugk3sgrbvJhqEiXbR8JnRdvT5i3+LWukJnXmg1SsWFfNaEKiyPENY52iBGkt44TfcgQ29INszoPDkDXe4wxnWnrfCVRZ1O+DrszQWeHDoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by MW3PR11MB4761.namprd11.prod.outlook.com
 (2603:10b6:303:53::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.17; Thu, 23 Oct
 2025 14:54:51 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::8289:cecc:ea5b:f0c]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::8289:cecc:ea5b:f0c%8]) with mapi id 15.20.9253.011; Thu, 23 Oct 2025
 14:54:51 +0000
Date: Thu, 23 Oct 2025 09:57:08 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: <dan.j.williams@intel.com>, =?utf-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?=
	<mclapinski@google.com>
CC: Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang
	<dave.jiang@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] dax: add PROBE_PREFER_ASYNCHRONOUS to the pmem driver
Message-ID: <68fa4244ca3a5_1870d210024@iweiny-mobl.notmuch>
References: <20251002131900.3252980-1-mclapinski@google.com>
 <68f96adc63d_10e9100fc@dwillia2-mobl4.notmuch>
 <CAAi7L5eY898mdBLsW113c1VNdm9n+1rydT8WLLNJX86n8Q+zHQ@mail.gmail.com>
 <68f9a61ccc6b1_10e9100e5@dwillia2-mobl4.notmuch>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <68f9a61ccc6b1_10e9100e5@dwillia2-mobl4.notmuch>
X-ClientProxiedBy: BY5PR16CA0018.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::31) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|MW3PR11MB4761:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a0e5235-a055-48a8-bf85-08de12441eb4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RHU0Y3NLbWZ5UXlpcktEYmtPaXA2NW4zeGZCVU5zV1FocjFIY0pIcHJQMFpt?=
 =?utf-8?B?MW5uS1k1TldQSkhsdmx6TlZqUmlBQ3hDV2daOUVMT0JmR293cXNXbHFZSUFX?=
 =?utf-8?B?aFg1cUpaeVNTSmNtQjhkV0ZGQVBFeU5Wdis5TnJ6Z25wNW55UzBJWmxRcDF6?=
 =?utf-8?B?dzQ4bjYxcGJ4UU5oQTVOR2RYcmN6VGc2ZVJ0UG9EVXAzTzNQdC81czAwN0hx?=
 =?utf-8?B?UmRranhWZkpyZFdjY1VTY0FwK3MrcUpqL3RUTk9XNXVXeUtsaWFDOS9NRy9r?=
 =?utf-8?B?dXY1bklJYmJDTS8vZ3FnWXNZMmNYTk9XL1NzNFhvRnVPY0UzOEpEdDR1QW5P?=
 =?utf-8?B?LzVqOEFaUmM0eUkzei9nbWp6cm9MM1Y5QU50bTlDNityOWNRRDhzTGhTRDVV?=
 =?utf-8?B?WmZTV05QV3UzK0F4ZElVbHpTRVUxd0NhWWRHUlZNNnhpTkRMcUxiajJxTlpP?=
 =?utf-8?B?WVJLZ2o3cFRrdVRVWm5qTm1kcEU4czNXMi9raXY3YXRscnBySTdJTGF2RXBR?=
 =?utf-8?B?dS92UW9FdlZVdHkyazBMaklaRDNKY1o0VVZOeWFFMHpEdGptaHB2ejdGWnJD?=
 =?utf-8?B?dVJqVU15M3hNNmhuMk1Td2hHWk4wVmVpTTJDdWdheXl4R2hRcjQ5RUQwNUxm?=
 =?utf-8?B?YWdUL1JrcnZSS0hmbWlBblpibnFHbURBaHZzVmpQNlpLLzNaY1BMb2Q0UGZJ?=
 =?utf-8?B?d05uVnp5RFRYYlpyd2tqdEtkVU5XTTFkOUJITlJFMCtUMlBDaXBoWm1HQWZw?=
 =?utf-8?B?MDZiL2NMTUk0VEIvcWlrYVE5QTJvd1gzN25HMlpsTjJWK0hXNlgwcnBpMVZw?=
 =?utf-8?B?TUtaNzVBN1RTMG9kUzR5cElpK1ZXS1lUcWRSSW9hQ1JncU5WeDlUSHpVaWVo?=
 =?utf-8?B?aGpMTzlIOUMzYXpxYm54a3gwek1DTFhNV1RsTXZISW9KZHgyRlJDMjFMbXpx?=
 =?utf-8?B?VzhlRVc3YlQ0THN5dExJS2JBU2VuZ2lCOU9GYk1JMEc4N0dTN3FqMUtSbndZ?=
 =?utf-8?B?YTVWcXJvc3NzWUJndllWNVNvRnFLaDJ5MWgraU1EK0hMYXdMVUNGNm01QkNC?=
 =?utf-8?B?cldMdGxtcnorcUNuTUlWMnpNdHpTYXc0UmRWU056TFFhVG5hMUlKeVV1WHZk?=
 =?utf-8?B?MjdiVFFQYjQwZGh3NjJQVDc3SXRKSkdzdGNXNFhLb1BWeDBPdmdYODFqZ3ZB?=
 =?utf-8?B?QTRsTE03a0dGQ2M4dEg3c1dDNlNJVFJSQnE5Q00wbkFwY3lDRk9vS1pVVDBO?=
 =?utf-8?B?SE8zbkEwUUN3dUpIb3d1WEErTndIYmdTRjlTVFlDVUNqa01IRXhka2JDc0M4?=
 =?utf-8?B?ZUFUbC94UUI5RG9ENmdUdU02bzR6TFlFTXJaTG9QUStRWnlUVkNhdVRBQ1pk?=
 =?utf-8?B?bXpzakZKTWN4Yy9NUFd0N2hZL0UvM284d1lqSkRvdGJIMnEwbnd1N2dCemJ2?=
 =?utf-8?B?WVllaHk4cVZ2N0xVemdCUjRvazA5Vll1Tk1CT1h1NDV2dWF1cENqaGpSWDVw?=
 =?utf-8?B?cE13ZUhGTjk0SkZiTVJIRjVILy9ybzI1aHJrbWxvS291dkprVDNlTS9tOVpM?=
 =?utf-8?B?RUNlcVhKLzNEZ0IwMTVoMWI5N3JyaXNnbkxqVlI1TWYwYTV0R0dvWUh2dTZt?=
 =?utf-8?B?MFlDQUJQSlZwMHpjWlFuelBSOFdYR0dKM2wvWkc5RDFDRHVXOHdjMzRjMVk5?=
 =?utf-8?B?YncxOXhmZmsxU2FPM2E3RGpSRmFIbElaV3pmTERicHlwNjlncHd5dmhrVDZt?=
 =?utf-8?B?M3lHQk1YNlRZL2VRR3FtbUl6YUhETUU2SDZBbUZZZmF2MWFKOG5qaUQzQkFa?=
 =?utf-8?B?MlBqY3ZhOVNpY0hwaGJ6cThXanFMT3IrdjI5eGk0V09PaGN0WmN2K0lYYkVx?=
 =?utf-8?B?Z3YvR214cXhjMGVHM1lqemZJbzVLelRTa3FKejFZUVdQb0lmVEtsNVE3b2Rq?=
 =?utf-8?Q?32Y8PPB/YK/HpVXh65dKertp5e4oM9cL?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y2EraVpzK25wVk9UYUZqZ3NzM253UmRnUEwvQXcrT2FWMVFZSnVFbnJGN3RT?=
 =?utf-8?B?bGZGblFOTTBYYmJMZUJIM2Vyam9abHpHVHlQWUhFaHJGbW9NeWF0TjR2bWhh?=
 =?utf-8?B?UlJ2T1pROGEreEdvTFF0L09ESUhMcnp3NElyd3NwdG50REhQZzI3dmJwb3Ji?=
 =?utf-8?B?VXhpWTFLVVoybnZqTWNoSk5NeC9Rb1huRTg4cFNZUGNPaWV0NHdncTYzVWJS?=
 =?utf-8?B?bEdsd0F5bjhybExOUHQ2VlZLNFpmY25sdC9xV3N5N1dSOEViV1ZTekhSRjVj?=
 =?utf-8?B?L3U3M1drTmNoZ2I0T1VTaDcrU2lLSm1ZeFFramtqWVE3TDZsOGx4UmlXaXNX?=
 =?utf-8?B?THdFYkU2eG5sTGU1SDMrVWkzWWkwaWowYlp0OWRDaGRJZHdwZXovOEV1MDhy?=
 =?utf-8?B?UHdOWWZKSTVrdnFPNzdvVlN6ckUvajRjTjljdTBqS0tXaE9ta3Y0V0puY0tB?=
 =?utf-8?B?K1cyT1RVblZnaTlYdVhNeWplSVJJWE5FUEZ0Y29OV3Y4OGxDa3lkanFKWFI3?=
 =?utf-8?B?dkNsQ2RZdzZTdFIwV2NoM0VqYWZ1cytwYmY3WE9ZYjU4ZllGSGZLTElyMnJt?=
 =?utf-8?B?YlB6OVpFRVZFWEJPZm50RkVSZFQ1K0ZSYVV6MDluNFQ0ZHpYSEM4Vmgyanlj?=
 =?utf-8?B?K0g2SjI3aEVHTFhYcnFvUVpDakcrbVFIaUJhbG1xVVowTzIvbTkrUmhjUmUz?=
 =?utf-8?B?TUxVek1HREJjUTc2dVloMlJkNDEzMFRiY1I5TkYrdjZ5dVA5U1EraW95UmpL?=
 =?utf-8?B?MUd1OWJWMWh4MWZ5M2xEcWRTNFg5LzFaY1lwVTBHNDJRNXFIeFhUd2NPSGZy?=
 =?utf-8?B?U3YvQk1RM2Uwb1NQSlM5Nkd6bXlkVzhKSmdaeUcwQUNHc0NWWFo3dFUyaFZD?=
 =?utf-8?B?OS9zWldiTkNpS1M3QUl1OUM0V3ViWEtXc2FWMVpkRkM3aDA1SngwM2FtU0V1?=
 =?utf-8?B?WWtpVWlxY21RQlJnMFhOL3RybkpCS1FJc3ArZ3pDTmhZYzgrWGU3YkE0bnVx?=
 =?utf-8?B?VGJhKzhwUHNOZmlGcGhrRTVTeCs2aUNUaGpKWlBRd0VUb1JsenJyUlhHdjFE?=
 =?utf-8?B?YWFuK1pkbjBtMDEvWEwrenVBM29BNkd5Rmxyd2hhRDVlTm1qS1RsNGlqejcy?=
 =?utf-8?B?UFhuNkQyMGV4bWoza1VCSDh1enFqUm0xcDhleFZRVnQxMjlJQ0FaL3hKYVpJ?=
 =?utf-8?B?Q1JvWnpBRkhKODlkbzByM0J5SFduS1J2SDhheG5iYjF5M2J2d3F0Y2hEc3kr?=
 =?utf-8?B?K2ZEbkZxWGZvNXpmUCtUeUpNNVdid2pEWUlQd0JqK09qQkZiTkhCMmV1eldq?=
 =?utf-8?B?ZHlSOGdPRldjYzlBazYwUFQ2cFdMQWNZdEZ4V1J6bDJRRU1VM1pVSURHNTly?=
 =?utf-8?B?WW9XekhJcTM3ckE1ekxJKzRmcWtibUt5a2dTZ01aR1lMMitINnVJYzRreVRD?=
 =?utf-8?B?YVI1dEFnaitaL2p5VmpydWpUaG5Hc0wzc044OFdLNjVxTmhIVlZsbEVHVUlp?=
 =?utf-8?B?ZWs5M3BaVWJtMnQ5WjgvaTVkOE11TjROdVVpSFdqcW9iVmdCYjBGdUxNdmMw?=
 =?utf-8?B?S1NEaHByQ21DSHBra01LQTFCRDRmMWtmODlYTDJzOGQ1VmY2bGtiUTZIZHRV?=
 =?utf-8?B?WmZVbVVYV2xOWm1HZTdiZ3pVZitpREFjaFNQNTFyTUxhNkE0TzlhMU5HcERW?=
 =?utf-8?B?NU5GYndRbGc1bitraUdNSHdoUkdidUJpSDBqdzkzWkoyTTFvalZGWE96b25W?=
 =?utf-8?B?OHdOcFk3SGkxQUhnemhtamlUdURINVFKZGxlcFc4UWNqZ0ltV3Byd211M1pM?=
 =?utf-8?B?NWw3bW41cTdndjB3ZVN5TDRvS00xK294NEtCdWc2N2MzYUZlK0d0eGIremht?=
 =?utf-8?B?ci8yc3NGSS8zWVdEV2U0ZzhLakhBZmJ3dTl4NHM3QVk3ajB0cmhDTEF6ajh5?=
 =?utf-8?B?OUxYQU40bkRJOHNQWmJWZUwraXAvMkg0MkhOS2dDY2U0RFRyT2tiVERLOURq?=
 =?utf-8?B?T08vUm9wVmNOeS9TSDFYS3NPeFhodmJJTVlBT0pTWllrUGxzaEowdEY3Y09p?=
 =?utf-8?B?bEVKQit0eGJGUWtualVPUm9NVlRFeU5rQmUyVVluQ2hPS0pQSWs5R0ROTVA1?=
 =?utf-8?Q?1hz00RdUe8MsQpBP6pRRu+77+?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a0e5235-a055-48a8-bf85-08de12441eb4
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 14:54:51.7703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /hyMnCC2Qg5g5R2sCeona4Vv5kpaG72OCiFPMM7JnuM+DOrMxRNkY/slt2UgplmdSBqsVtSf1Enmtd8GNfBOKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4761
X-OriginatorOrg: intel.com

dan.j.williams@ wrote:
> Michał Cłapiński wrote:
> [..]
> > > However, I believe that falls back to synchronous probing if the driver
> > > is loaded after the device has already arrived. Is that the case you are
> > > hitting?
> > 
> > Yes. I use all pmem/devdax modules built into the kernel so loading
> > them is in the critical path for kernel boot.
> > I use memmap= with devdax. So first, the pmem device is created
> > asynchronously, which means loading the nd_e820 module is always fast.
> > But then, the dax_pmem driver is loaded. If the dax device has not yet
> > been created by the async code, then loading this module is also fast.
> > But if the dax device has already been created, then attaching it to
> > the dax_pmem driver will be synchronous and on the critical boot path.
> > 
> > For thousands of dax devices, this increases the boot time by more
> > than a second. With the patch it takes ~10ms.
> > 
> > > I am ok with this in concept, but if we do this it should be done for
> > > all dax drivers, not just dax_pmem.
> > 
> > Will do in v2.
> 
> Sounds good, include that detail above and I'll ack / poke Ira to pick
> it up.

Yea if you send to me I'll pick it up.  Sorry I did not see this before.

Ira
