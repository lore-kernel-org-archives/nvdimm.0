Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F4427B331
	for <nvdimm@lists.linux.dev>; Fri, 26 Sep 2025 18:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758912327; cv=fail; b=lSoN3oRzNgpHfIYhm5ANMAdWGZDhOuyn1ehBKCdWoSd9gN8WlhY0Lt6UvQqwDKr6U+YLybGbsfAF5nd1OrOHIvGnArpiMQUHLFSW6+pcg0iNLm9zPDQ17jAB+yEHtjPOP6gOCfGt5f2pOKHuD0ifgzOasYNLqNKlwCOTMEVQ1mk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758912327; c=relaxed/simple;
	bh=srdQJIL084Tpz7Rp/QIgPJvDhEIM89xb/L2BDTtRgw8=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=icdnLyvqfHntOVFNrrpCzkYjyR75mnQMWfhMTH2sLYSPgCI7uRfAbIAfZD2zGfaEqT7hEtH2etaFHsN+RF+yWTSEbJ0gZ8YDq5/ThAFFeMNG28womC9vb3zNLVG6oCVsiyVbLdTB3QmjIjZ7BA7BoOl5qtNcRGNrYlRFQaKUu+0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kx8GEON8; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kx8GEON8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758912325; x=1790448325;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=srdQJIL084Tpz7Rp/QIgPJvDhEIM89xb/L2BDTtRgw8=;
  b=kx8GEON8HeQPSg6k9oeQgvk40Nj9oYxdjfl0YDD9+/H6ASCYu0TeB9Zm
   ZnQqT+PGDts+gW56S3EAdqGwzErLozInEUWAw/12GUoo4H2EMCdfse3PR
   RlR7TCgDE1Fbt7aaFhgqHFjcI8VZEWOnr2HYB8pGDeHf9WbYEUescVpZw
   T/m8iom7YRGZ+EfWcNphF3YiqmNF2zO+R9OJ5SGmEoGP+sKfAl3DwPSbz
   ZtwS00T6ioJbgQmhekKfa93Dak/B1fkaHGBAwGGFhwqYUlxdIpioI7s/L
   5szrDCtJ0yZGvQJpMm+jY/H5s8WIDYe5XRtrrHpd/IvA95f1EgRmO13k8
   A==;
X-CSE-ConnectionGUID: RbHbpqfIQgOK2+L1zbpbKw==
X-CSE-MsgGUID: nZf+YfQETKWilDFDVZZJww==
X-IronPort-AV: E=McAfee;i="6800,10657,11565"; a="72612087"
X-IronPort-AV: E=Sophos;i="6.18,295,1751266800"; 
   d="scan'208";a="72612087"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2025 11:45:25 -0700
X-CSE-ConnectionGUID: TsF5d0arRfiikxJjpZ3BHg==
X-CSE-MsgGUID: HIv5R+H/RL2UMy8Qm2ZlCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,295,1751266800"; 
   d="scan'208";a="181702238"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2025 11:45:25 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 26 Sep 2025 11:45:23 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 26 Sep 2025 11:45:23 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.28) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 26 Sep 2025 11:45:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fJf3sDOKmK7SLEjfyD8oM3gQqbPVq2uofePk3uB9c5vptF19CNWMB7co9f+1mjAyruSsTPMyVZpUNqIyVizaMndT8gl2QkBN5jM7upF51h8Erv6ESCQ+4eZsuLKDFU5wgFw+cIRfJyf56LGkzcZPaGv/HEPgrip+w1GGcbypHyCGpU8nSgdLBiB0hEhME7pPZcny+l2geBZwCyx5/EXFky2C7AITWdpyUwZ+SjAziRo4aSjgVJDBFpUmlOkXNGly4oIM2uc3b9eOSCPpXFTI/G2mXfuYbovtuZLG3p8tti2l1SS91p3U5MYrOGYD/WDSGyUEANxDHy5zPsuMdtjDwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=srdQJIL084Tpz7Rp/QIgPJvDhEIM89xb/L2BDTtRgw8=;
 b=eC9WDSEAsTsw0mCmumoHOHnZsrMLZhGmoR/i0HRKkVKPs6Wj4f43yq191zR+X5IcZPnP4PHD9iV6XfxOX2pocjmj7g30X8SDtO7zezdwsgpgi2rdxUi9WHrp0Q0uL5Ego8QRC5XxQibSREcXiJNJwPw3wt8NpVnHoE/K6YaepXpC4+jzXScnJk5jXF/rMSsS9T+bGWuNCmDmWsYGSiW62OZctFx/41nlW/DE3TE0mSRR7Wz6tXNWhXN/eZM14U1plR8QMrSXc0pR3dU8UMKfYDJ6ua1qXaXaKE32RpPIkPU+cd4s1dpjkuT8TZ4t2Lgd8so/uMfp+0Ox78/l44nDDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by CH3PR11MB7274.namprd11.prod.outlook.com (2603:10b6:610:140::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.10; Fri, 26 Sep
 2025 18:45:21 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%2]) with mapi id 15.20.9160.008; Fri, 26 Sep 2025
 18:45:20 +0000
From: <dan.j.williams@intel.com>
Date: Fri, 26 Sep 2025 11:45:19 -0700
To: =?UTF-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>,
	<dan.j.williams@intel.com>
CC: Mike Rapoport <rppt@kernel.org>, Ira Weiny <ira.weiny@intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, Vishal Verma <vishal.l.verma@intel.com>,
	<jane.chu@oracle.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, "Tyler
 Hicks" <code@tyhicks.com>, <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>
Message-ID: <68d6df3f410de_1052010059@dwillia2-mobl4.notmuch>
In-Reply-To: <CAAi7L5esz-vxbbP-4ay-cCfc1osXLkvGDx5thijuBXFBQNwiug@mail.gmail.com>
References: <20250826080430.1952982-1-rppt@kernel.org>
 <20250826080430.1952982-2-rppt@kernel.org>
 <68b0f8a31a2b8_293b3294ae@iweiny-mobl.notmuch>
 <aLFdVX4eXrDnDD25@kernel.org>
 <CAAi7L5eWB33dKTuNQ26Dtna9fq2ihiVCP_4NoTFjmFFrJzWtGQ@mail.gmail.com>
 <68d3465541f82_105201005@dwillia2-mobl4.notmuch>
 <CAAi7L5esz-vxbbP-4ay-cCfc1osXLkvGDx5thijuBXFBQNwiug@mail.gmail.com>
Subject: Re: [PATCH 1/1] nvdimm: allow exposing RAM carveouts as NVDIMM DIMM
 devices
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MW4P223CA0016.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::21) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|CH3PR11MB7274:EE_
X-MS-Office365-Filtering-Correlation-Id: 405fffe2-b9a1-403c-e04a-08ddfd2cd864
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MlF5YWtRdzBmRU1QekJSaUNDYkFSalA3NE4yYWNqaUZXYTFCU04xTG9KUU9r?=
 =?utf-8?B?SlVuOG1WVG5VZ0xrZXl0Q29mdTNjWkM3RGZ5dXJCMy9LaDh0RzZqS2lyQUov?=
 =?utf-8?B?Z2x6NDBnbFFRRW1EVlhBaXl4QllNQ3kyWHVPYTBCbkZqb25rUFhXbHB5SjEx?=
 =?utf-8?B?ME16Tzl6LzQyMklhZlZVV0ZwT2hUb1RkbTZvWGhaZkljc0ZOTlNINEdMTU1P?=
 =?utf-8?B?dEFWdFlrREtTeFl2Z3FmN3BWZHBCKzJtMGgyOXpwUHd6cVV6RkxYNys4c2kv?=
 =?utf-8?B?ZzF0OU1SQmt5TzFzZTNCVTArM25MbS90dGtxNCtTTmhYYjVXaVFjclh2aFpn?=
 =?utf-8?B?aHdITFIyNHRIb2VRYWJsOUk1WmFWZ0ZTNDhLK0tSVlJpQkZQOU4wRzZ0VTI2?=
 =?utf-8?B?eFA1ZXlLdkFFQm9IQ0gwTVZMQk91Zkd5anViNVFwb0kvMGpPQk9XTzNKN1hM?=
 =?utf-8?B?RnREYSs4aUhIajhWZksvL1BhcVdqdS9OZGFHdWVuQU4yaDhVVzVramRjKzcw?=
 =?utf-8?B?cTZ6VFRueVUzNGFCODlDWit0TG81MG5jK2hOaU5EeHM0MVFBYmxldTBZZUhy?=
 =?utf-8?B?Yjg5VjhwTThsbERuRGhSaVhxYVdIVkpTWm96KzhXOThOQmhkc2pwZDFNWEk4?=
 =?utf-8?B?VzVhb2tsQm5UUElQUi9MWFRiQnB5RVBNWXlCc2hRYTYzaC9zUGRmRHlEWHk3?=
 =?utf-8?B?WkI2QW9VeUh0ZEhsd0locVpxNlY3Q0J3MXc5N0JqR2wrSVlWK0VwU0RqSDVZ?=
 =?utf-8?B?eVNLdjZUYytvOXFQZTJxeW5lbCsxYVd5NjhYRlhHRG53TGFFVk1SSmhXekh2?=
 =?utf-8?B?cGVjVUVrMStQbzJRUHArV2d0YkhvYUN0SVFQY1dxV2R1OTFBQVVFVEtUUTJJ?=
 =?utf-8?B?UTh3YXJFYmlJVks2RlBQYllhbThhbGYzbTl3dXZWRFlKQUJEYVA3aS9CNGhC?=
 =?utf-8?B?U3dacGR6Y3VCNThockkvR3RSbFhybWtwRU10RHRvL24xTk5EQWVZL20vb0RN?=
 =?utf-8?B?d3Z4YVo4d29xejByaDd5a2o5b2NMVEFmYzZXWGVkOVJYaUVHTUdQdUtTQ3Nh?=
 =?utf-8?B?a3lyQ1lpUUhCY3lwZUx6WWJXU0IyenM4TVVFcmZxTVRzdEtLWGVFZENGa0RJ?=
 =?utf-8?B?b2VzdlkzOVpaNlBCdWxDb1NKT3FMcmZzQTk2bEg2STJ3Q1JNSHBVNXA3Zkpv?=
 =?utf-8?B?UjJKZTlYR1JxWk00cEdEU0dDMndqTlJGdnNQaEZGdWlqdUlyWnVkc1d3MVJk?=
 =?utf-8?B?MzVQaVA1cm5nbURCMXo0NEo0b3J0dFVRZEJ1a2tRclZiQTZqS21Vclh0d2Nq?=
 =?utf-8?B?RWlnUVRzTnVzVUp3RG5tUnFyWmdCUU9hUFRHSmsxUGJmcGUyUVNEWGpWcFlP?=
 =?utf-8?B?TFdFWFRNKzZXaHBWbElEdFZHdHBBdysvbjZLeG8wMnVoYjl1OVlPWS9zeFVW?=
 =?utf-8?B?WXpZWlFjT292YWRMNk16bWpnd2drcU1LYmZIOUpRYnFMSVdNbi9sN3hnd202?=
 =?utf-8?B?dSs4RUozQXBZeWp1Ym1BTEdpd29ZQUZkTW9BY3EyaStsQ2RacEhIbHp3ZWZS?=
 =?utf-8?B?eG1INXFWanliWXVGdXh5Yk5iWXdCWGJGeWtlVVVTUTRzbjRPQkFBZkJKUTJB?=
 =?utf-8?B?NXJPbDljVCtLb0EzQmZkYUp2VDZUcnJ6dnNSYVgzeUFtTEpSRTY3aXBZMTcz?=
 =?utf-8?B?djFiUGNKbURXYy9EV08xY0VqTVlzdkpFRW1ncFVYaEJFTjQzVWV3MTkxUjlT?=
 =?utf-8?B?cjBKa2l0Q3dNZ3RMZ29FQm5tVHJOQk9pVFprbnl4TEJkQk9LK0pLS1NvOFpN?=
 =?utf-8?B?eE92bVBqSnlmb2p3czFWTE5kUjA1MjNDZ0FjSndEbnlzdzhZT05LY0lGa0o1?=
 =?utf-8?B?dDg4b1REZ3M2ZHBFR2tKSUtzVy90dFg1elUxdURDTEo4UkUxVXNhRlFVQ0RX?=
 =?utf-8?Q?t3kZOrEyQAu1NTJnSFmBgy6k94JZGAvb?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OVdFY2hmYy80OXljb3Z1UXkrazFxbjBYWGpWaXY4bVFwVStxRWl3T0xYS1dt?=
 =?utf-8?B?TklkdmpZMTNTVjg2OHpmV0tCTGZ1VlZRT0VnVjNTditrQzVreUtaeHl6eW52?=
 =?utf-8?B?bG5GR0E0clQ4VE1SV1pGZEpwSnYxZzZpeERlSThiQkFQUGIzMFUrbDE4d1g4?=
 =?utf-8?B?cDQ0VXJjdFlVczd6TjJTQXBPWnpHSElXZXVUZVRod290eWZ4K1psaERZY0VQ?=
 =?utf-8?B?Ry9rdmNzOFpmZVVEanlpRERNbitPaDI3eTRaZ1BqSlhNdVNUUWpxaUNWKysv?=
 =?utf-8?B?TnpLUEhwdTcyTlNJYnV0b0xGM201aHZrRWFUajJoQzNienZyWEhJYnZZT0x5?=
 =?utf-8?B?T1ppV2JRMG9DYksvZWdNUHhETjFpdk5pdzZXZzErWit6WjNmc1lyWS9BMThv?=
 =?utf-8?B?LzArVkFORjFiaS96b3NVdS84bFh0U2VNUmIvUDYxT1Z6WmY2UmFQQ1N0Z2Rr?=
 =?utf-8?B?L0U1Y0VhK1hMc2xCcmo5MWFISlJtbGhtY2RoZmdpM1BtWXNUTUVNdjJrR1R1?=
 =?utf-8?B?d0EvbE1DVjFCbWpNNlBPQXNNNDF4RG1xSGcwL1gyODFmcjJaN0ZqS1NMNVpM?=
 =?utf-8?B?cnd1eFlyMm83NEZsTktjZnowNTlFeVdFOFo3YUhQZXFHZlBrVEk0Yi96bVdU?=
 =?utf-8?B?dFk2cVlLTytkbjdtWlVzZEpZRmFCb3Fta0VidFRGU2M5Ylp1UEEzU1lpRkdo?=
 =?utf-8?B?RHdOK2xINlg2b3VSY2RrWVNnOUFQVkxESWY4WTBYRVExdEtZWENzNXQ4MmxO?=
 =?utf-8?B?L0pmaTc3Nk05cXhyMWVlN2VDVmFzWE1sOGpMTFpjM3ZiTC8yYWthVEtJWXRx?=
 =?utf-8?B?cWlkcVFxYmV1bFU5SVIrb3NFUS9jY0RrWHpzL3dicnJVRVJVOG5lb3JxSFhV?=
 =?utf-8?B?L3JsQmRHeGJkUlhEdHVzemNIbVZlWDZvZSs5UWxzd3lydm9laUNJOHBOMmRy?=
 =?utf-8?B?NHF2MkhYZ0ZlUU85U2hmaGwvNTlkeVludHVCMTk1c09RK3VZZ0tqc08vT3dM?=
 =?utf-8?B?R0FYdlFSbXhYTUZXTW9BMkFjOGZESG11a1RUejFhMEJWRy8zVlpEMUhCcDJx?=
 =?utf-8?B?SVQ1VFdrK1l2dHdFMGtvcnorVHFGR2hmM25qdHl2eGJFU0xkOThZRjZ1OVRx?=
 =?utf-8?B?QXIvc2RTQXR3azhPRW91TWRvOXNIcWNJT0pCNUtzRVNkdWRQOS9QMTVFUXRK?=
 =?utf-8?B?SGRGYzhkc3RvSUE2ZFhmNXBkcy9vYXZ5dFpmV0oyWUNEQWNUTm4yVnJ2SVZm?=
 =?utf-8?B?QXp6WVRlYVhUdFpiSlBYOWhwN2U4a0YwR1NDV0x1ei81ZEd0UGVCcWMxalhF?=
 =?utf-8?B?TS9wS0s4YlBkUmFJcmxHNWhWVlNDVVJhL0dZZ1dOdDB4ZjF0UDRTM2FDVFU0?=
 =?utf-8?B?THoxNUtzSDE3YStxTW5zTU5GdTcyL1lMQm1pOHhDMDVLWENyTlhrekNMS1Nk?=
 =?utf-8?B?UHNXQ3FyRWZlNUQrZmlaTHpIVVRqWlFiS0xPYnNGUmlDUEU2SjVvSGorWUth?=
 =?utf-8?B?MkdZdG1UK2xRNEZWZlRCTHBGRVo4M0UyNUtocWVwWVVXNFM2ekp6Ym5taDFv?=
 =?utf-8?B?eE9YTDF1b2tldUVoRlgvNk9mYXdLS0Zrank2Vy84cW9aTFBpV3JZd25KNU1t?=
 =?utf-8?B?cEI5WGxvdVpOWjVMRXBZaGVvT1JRR0tUcjZnSzZWbDVKbTB4VHB1R2J0L0Q4?=
 =?utf-8?B?SjdMNnBHK1NQbFV1L0FZZS9adHV0bDRBRldNSk9jcUcxMHlqMk9PcFhNRnhE?=
 =?utf-8?B?RjJnOUQ1TTcraVhJUEZTV1BRY1RBZ25qTzNrRHppM2pYbVgxcGNOeFR4V2Zq?=
 =?utf-8?B?Rm1zL0tpYi96VkVuZXE3eThYZ1dzZGpZYnFrdFplNjZhRXg5M0paSG94L0Vi?=
 =?utf-8?B?d2JjQnhGeWJUOU5qOUx6cklXbEl3Q2toeFJuMUd4K2l3YlI0MmxNR3FsKzJS?=
 =?utf-8?B?WGVCYkx6MFBzWTBQRFdCQlptSTJsUG1tMzZPRWMxQzVjcHhWZE1kT3paTUUy?=
 =?utf-8?B?YzdUenFjS3NTSE5QZjFOVEN5WjRhc09SSCt3b2VySHBEYm1Odzc2QzRhWWMx?=
 =?utf-8?B?dXBvSEtIVncrSFJaK29qckZwNkZEVXpiMXU0S2V0akIwNWhNcFdJa3NCWUIz?=
 =?utf-8?B?TWNvR3VmTUNYUUNVUHRodTI1VC8wV050N29ZRVhkM2kxT1E4U0Vwak13OW5Q?=
 =?utf-8?B?Q2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 405fffe2-b9a1-403c-e04a-08ddfd2cd864
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2025 18:45:20.8839
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iOfqVqyGvHlY5D+6hVXBsoBREpqy4lpUpKxa4VwPte4lEF878Y9wbqhtyhQrjaendGyahCmOSHXUVvkOyptJPjsEZrbhm2bH8kpiecrr6U0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7274
X-OriginatorOrg: intel.com

Micha=C5=82 C=C5=82api=C5=84ski wrote:
[..]
> > As Mike says you would lose 128K at the end, but that indeed becomes
> > losing that 1GB given alignment constraints.
> >
> > However, I think that could be solved by just separately vmalloc'ing th=
e
> > label space for this. Then instead of kernel parameters to sub-divide a
> > region, you just have an initramfs script to do the same.
> >
> > Does that meet your needs?
>=20
> Sorry, I'm having trouble imagining this.
> If I wanted 500 1GB chunks, I would request a region of 500GB+space
> for the label? Or is that a label and info-blocks?

You would specify an memmap=3D range of 500GB+128K*.

Force attach that range to Mike's RAMDAX driver.

[ modprobe -r nd_e820, don't build nd_820, or modprobe policy blocks nd_e82=
0 ]
echo ramdax > /sys/bus/platform/devices/e820_pmem/driver_override
echo e820_pmem > /sys/bus/platform/drivers/ramdax

* forget what I said about vmalloc() previously, not needed

> Then on each boot the kernel would check if there is an actual
> label/info-blocks in that space and if yes, it would recreate my
> devices (including the fsdax/devdax type)?

Right, if that range is persistent the kernel would automatically parse
the label space each boot and divide up the 500GB region space into
namespaces.

128K of label spaces gives you 509 potential namespaces.

> One of the requirements for live update is that the kexec reboot has
> to be fast. My solution introduced a delay of tens of milliseconds
> since the actual device creation is asynchronous. Manually dividing a
> region into thousands of devices from userspace would be very slow but

Wait, 500GB Region / 1GB Namespace =3D thousands of Namespaces?

> I would have to do that only on the first boot, right?

Yes, the expectation is only incur that overhead once. It also allows
for VMs to be able to lookup their capacity by name. So you do not need
a separate mapping of 1GB Namepsace blocks to VMs. Just give some VMs
bigger Namespaces than others by name.=
