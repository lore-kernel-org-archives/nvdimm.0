Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7695239E79
	for <nvdimm@lists.linux.dev>; Mon, 12 Jan 2026 23:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768260812; cv=fail; b=bm3yty5l3NN44Cqg8JG1eDPcGTsIC0+DWjThjXPyMKWhOyaFvIHN6fgrELT6l9wqJWEtCiz//5pTNfRaqPa39WkhcsjLHkQr6J5ALVEmgpclB8XICgAIKZRQ8RBxALXoA2ENsdAMr2L7n5idOAGDXl2VqbJs0BHd51mOpsB+i9s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768260812; c=relaxed/simple;
	bh=yilaLXvriMU5/nJd21QKJZKPy5cAu9W+V1gVuWf0uwM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=qZc2qGLqt3l0Q3W7aCS6hV5WMMTk3EFjOz1P4BavjR8oXN2Pq4PhG/222pfwkegt9gwuaDBwihWnoC2A5Lpb46R1r5wNAUcUJpVqBWSAj+nlVCSFIUhLSVFc4RxQ3H09lWHpr5p1+2F0etsF7FvZBd1ugVTMRJ7GqmMSigS0yOs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ktSY6LWT; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ktSY6LWT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768260810; x=1799796810;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=yilaLXvriMU5/nJd21QKJZKPy5cAu9W+V1gVuWf0uwM=;
  b=ktSY6LWT7+GUpfTpog1zpw8Hpb2il16uXtDMO+yeIs3o1/Q7zxvMsciY
   lexSWOzCczdchgYkSsSzz3kOyZLiShY6EN5H87V4boOdpP6HVpcbn6s23
   6xVs8z2JpHZtsIUDta9YNOwZF75FJDmRSGz0iol7iXl4QE3vIfDM9vRXp
   TFETriRjRmTbNFRHBJx/Imqe4Nc3zF1Z+PEmcHNyBM6ofNU1dZmNTnPnU
   HQlQUOnViFBCUo8YNdF1rfS1kfZRjzackxtFKV+SjUUaNbnEnIcZ0pD2w
   ddEAGzQVBUMgmwixNVSRTJM+Lfg8YUjLbYhL87t+Qnj0OumcG3aMjOWOj
   g==;
X-CSE-ConnectionGUID: 13GorfCNS9ybD1eVdDmZUg==
X-CSE-MsgGUID: RaZUf+x4Suy6sduKIIXycQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11669"; a="68750945"
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="68750945"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 15:33:24 -0800
X-CSE-ConnectionGUID: ZwKXcq1NR9mJuG04l+oLuw==
X-CSE-MsgGUID: 2v+Bd9JVRY6Gprk+VgtEYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="208378304"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 15:33:25 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 12 Jan 2026 15:33:23 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 12 Jan 2026 15:33:23 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.37) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 12 Jan 2026 15:33:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vMnqJvIjAjqiP1gvCzayRPoSVVeefdZJFA5/zI6ISxhPrvsYRYinQ2ks9z9xHn2eEl9P6HqZ8A4xMTyD4sTQb1c8hZXXvlTOzPIBq7HQ8HDpMCgbiKSPh6O9Na3+oHKo0x4TN8eTuT35XEgnrKv32i6LKlIBryG/1wVjL4OFp5u7GfdqFmAg58f9FGZSNoWhcvcAOFBtMilFi6nF4oEFD/8oygvZQOOZTaRzQP5flOzft++bVPeW5Eu5e0Bd2Kfnh9TVJoxBHZRraZtviVv60FGYqxGrcMLm7dzXnp3QkV5AWBzHOsl/RWPXHiqDwPDzowVacji2IkPpoha36ZneYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+uv2YZWocVtRiRrM2LKeSbukGNMIqcRT9Ghai0QtfFk=;
 b=p3GI7E6WKA9cnC1tVw0El/Y6NE+gd3iYdWb6Ph9qm5S97Ju1tTkDX9yX9/LSVdB1mDZUhvOoB8SOYngE/25mhTKlSNu0SPEWqrfrDqSejezmK0ajjLz6/iAPviA3jn2A3DJx1eIDNUIIO7O4l/wYvYS6Pa9DpsZWnsHhWie/FL3t63CBgDff1n3NG51m2uJ4vAokR/toJ1sqNWAYyfmsdTJDOOnNWeDPC4BnnuR7RtiC3/RnLBe4UkN1trDIHpKEra4ZUh8FTvHTQ5EkeOTB118E72xJvWGnCFjecrjlrBoQu+zPpfKIf74pdZ91jAcE8ZRxh6odpx+vIEj5ksA0Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA4PR11MB9131.namprd11.prod.outlook.com (2603:10b6:208:55c::11)
 by CY8PR11MB7685.namprd11.prod.outlook.com (2603:10b6:930:73::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 23:33:21 +0000
Received: from IA4PR11MB9131.namprd11.prod.outlook.com
 ([fe80::7187:92a3:991:56e2]) by IA4PR11MB9131.namprd11.prod.outlook.com
 ([fe80::7187:92a3:991:56e2%5]) with mapi id 15.20.9499.005; Mon, 12 Jan 2026
 23:33:21 +0000
Date: Mon, 12 Jan 2026 17:36:27 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: =?utf-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>,
	<dan.j.williams@intel.com>
CC: Mike Rapoport <rppt@kernel.org>, Ira Weiny <ira.weiny@intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, Vishal Verma <vishal.l.verma@intel.com>,
	<jane.chu@oracle.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, "Tyler
 Hicks" <code@tyhicks.com>, <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>
Subject: Re: [PATCH 1/1] nvdimm: allow exposing RAM carveouts as NVDIMM DIMM
 devices
Message-ID: <6965857b34958_f1ef61008b@iweiny-mobl.notmuch>
References: <aLFdVX4eXrDnDD25@kernel.org>
 <CAAi7L5eWB33dKTuNQ26Dtna9fq2ihiVCP_4NoTFjmFFrJzWtGQ@mail.gmail.com>
 <68d3465541f82_105201005@dwillia2-mobl4.notmuch>
 <CAAi7L5esz-vxbbP-4ay-cCfc1osXLkvGDx5thijuBXFBQNwiug@mail.gmail.com>
 <68d6df3f410de_1052010059@dwillia2-mobl4.notmuch>
 <CAAi7L5dWpzfodg3J4QqGP564qDnLmqPCKHJ-1BTmzwMUhz6rLg@mail.gmail.com>
 <68ddab118dcd4_1fa21007f@dwillia2-mobl4.notmuch>
 <CAAi7L5cpkYrf5KjKdX0tsRS2Q=3B_6NZ4urNG6EfjNYADqhYSA@mail.gmail.com>
 <6942201839852_1cee10044@dwillia2-mobl4.notmuch>
 <CAAi7L5e0gNYO=+4iYq1a+wgJmuXs8C0d=721YuKUKsHzQC6Y0Q@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAi7L5e0gNYO=+4iYq1a+wgJmuXs8C0d=721YuKUKsHzQC6Y0Q@mail.gmail.com>
X-ClientProxiedBy: BYAPR08CA0010.namprd08.prod.outlook.com
 (2603:10b6:a03:100::23) To IA4PR11MB9131.namprd11.prod.outlook.com
 (2603:10b6:208:55c::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA4PR11MB9131:EE_|CY8PR11MB7685:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a08154d-171b-4c8d-b533-08de5232f8c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?eUF4RmlDWm1QQkxIVzlPcmplMndTQ0pNaFc5QTBTTFhnMm01MXQxUjJhV2du?=
 =?utf-8?B?SmlQaExlRVQ3TEFRejdUankxV25iWk96eklEdmNiQ1VmMXgxbzhOeUJvbEdG?=
 =?utf-8?B?YkZvVTFQN3hYVTlsMmdtYWM3QTZvVXpCSVZsb1Q5SjZKdFQyaWJNeTliUjVr?=
 =?utf-8?B?OUh4ZXIvZ0kvcUVVZitaTU04OGFHTnlOSnBiYjN5Zzgwb0xxOWtkNitnNVl0?=
 =?utf-8?B?TklzbUNOVE5HT2JJeUNvUHowUkxSWTYzQUpxeHhBL0FIN01GZlBoNEJqLzFz?=
 =?utf-8?B?bnkvL2lyMzFwQTY0MExXWUZBQ3Y1WStxRHZLcHllZTRNQWEwbXpKdU85MlJq?=
 =?utf-8?B?ckptYmlrMVVQZkUrMUN5UHN6b0RuS3g4L2FHdFlSMC9NZFpNTmJDd2QwNGZM?=
 =?utf-8?B?S1VzNU1uMWlNbVRiMkxjYTY2c2Q0U0JNMWVWWHQ2cGF2YW56cHRBQmY3U1gy?=
 =?utf-8?B?YkhBc1hDRFQ5NVNlUDBQMXpwWXVONTlkR1RXamVZNVhLMEhwZzcyMUNKdlFn?=
 =?utf-8?B?My9OSGMzVlEwYkhBMXhHMms2eW9JcCsxRnc5VGpTb0N3Z0tOZVVhRWNxM3hs?=
 =?utf-8?B?NnBidmhxdnFDcDNJamRpWm5mQVNac1VIcXRoSWthTHlneDBkU0tjVG5PVjAy?=
 =?utf-8?B?TXRuR2g0YXZMVHNZVWh5N0dHMTVPQmIrNjRkZmxSeDV1dFBOL2J5UXNkODlF?=
 =?utf-8?B?R2lWQ1F1Y1E5T0s0VzdiR1dWbnJjKzdzOWp6NzlUbjNrZ3hOWVZVUk9iSTdW?=
 =?utf-8?B?VWFHUERtSjl3T0hJQW9OUnlSQTl1dkxoWHBKM1MyaGpMWDg0UHFadEJOeWp5?=
 =?utf-8?B?RTNySFVQK2Z1MlhLZXB1bFkvNGJlYWIvNDlYWHFTUEZCNUhoZ0J4TFhUci9h?=
 =?utf-8?B?cVpoOW04Y0l5TlFucmVWY1NlRmNZR29TelRyU3NhVlRvSXNMeHQyNzBxRnR0?=
 =?utf-8?B?ck8wMktkRnJUSG5KNklVaEVJTkhjbzZoK0RhdVRyWXFyMStCS1cxOGdsb0lh?=
 =?utf-8?B?ZmxPNDFJekhYRVNqTHpyaE1VZEtHc0lEK05ueWx4WVA0eDZJRkZMSDRpaUFC?=
 =?utf-8?B?RmUyMjZQRmRDNlJ2andlMzVDeFo0cFZkQi9YZXZpWGpKMFNBSTZzeXB4TzZF?=
 =?utf-8?B?eHd0K0FMcWtnR1BNSTZDelFxZjErUmNGWjFzWnFoVk9KL1FLcWptSUdsSDRk?=
 =?utf-8?B?aG5uNUcxQ0FQYlR0SXM4aURqUFdQaWlxOUl3U2U2Qk9tSVJpZExrS3dpL2Nk?=
 =?utf-8?B?UlNsUExvQ3lSUXE5bjJVSVNVYnRGQnBEQnI5N2ZRWWZscUVtRTZmMmNjT01J?=
 =?utf-8?B?UUdkcjZEM204SzhMelRZYlozYVhyc0s0QURXK0xJVWJEQUNtRVFwa2JZWTRi?=
 =?utf-8?B?dS9LQUFSY2lWYTVJR0ZUM1pmV2FSWU8xV0pKQ3dpM2VoWXBtenB2VW9CRGV4?=
 =?utf-8?B?TDBtYjRueHh6VEdWZEtmRW8xR0hUT05rc0ZkWmxiNHlZN3VOY29zN3FaQ2hB?=
 =?utf-8?B?eVhPbUpxVTR5cDdhMzN1eUNpS3dBd2EyY1JDaVFmWVhzZ01pVHJadGNXczVx?=
 =?utf-8?B?V096c2wzTkI0UE10cWNoRkxpM25CUzlucUlZS0NQRUpvaXA4dnpWdGlRaHM2?=
 =?utf-8?B?ZGdKc0hwaU5VRG9rOGNDK1pySlM0aUdQamFUN3BPbUVkakJxdm1QTndHRGxQ?=
 =?utf-8?B?TFI1aFBRdExJV0tMcU5CRk95b2paTVp0Q3JuaWgrYXlUQlg0VkhGUlhsNjZx?=
 =?utf-8?B?TWY5bTU4cE5ORGh3ZGk4cFlUUzdZWE8rK1FTOFhPaitLV3FOK0lIMHhpK2tL?=
 =?utf-8?B?UnRFS3d5SzFQZDNPWmNNU0lNbDVMTUpMZ3JUa2Z4ZzAraW5mVndEZGlBdXBR?=
 =?utf-8?B?TUY0K0ZwWkNGY1JoVEVhWDg5bFQwNm9HN1RWSXFlbVNzMXE2TWZyV1lxQ2tB?=
 =?utf-8?Q?sivrtqCzvmybHSkJ5Co34VDa4PGFkBIC?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR11MB9131.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QzhUL29tQXNETUxVNGhTdy8zMDUvRlo4VDFlWDlFTEIvWW9OY1YwMkZKcDNy?=
 =?utf-8?B?VjRNYnFxOWkyc0xkaVdvdU41MlAvamJoQXhqUzBJeTgyMm1RQTYweDM2ZGRO?=
 =?utf-8?B?SHFaL09GeVJHbjVKazRWSlpPcGcwTzVZRURKcjR6WVVia2hGWEdNMUxrWTZD?=
 =?utf-8?B?b0RDTnRocWx0MlRIL2NVTjJnaFdPYWl4dUxCcHRJbXlQN3o3QXZCLytzMVU5?=
 =?utf-8?B?M0NpajJGa0ZjZ245Tlo4eCt3eHBBL0U2aWo5OWRKQ1gvSjV6Yjh1TUFseG1J?=
 =?utf-8?B?aGFOL1NjU0tBZEh0THZNYzJrU3lHcG9oNHpva0JNSHFlRHk0MzIwNjVLaVNj?=
 =?utf-8?B?VGkzWVh2V2YxMUE4a2VMSDVaM0RVN2xiOFk0VVM5NVNTRkxvaXZyUnRSL09I?=
 =?utf-8?B?TWdOZTVLYzhPV3ZzWGtINGMrQVBON3VtNGRxaU9wNkNlRHpXZUVKREdnTmRz?=
 =?utf-8?B?TXltN0wzWXJBRll0WWp0V1hKWlJXM2NlQ2hsc0kxMmNiV3J2ME16bHdrMTZz?=
 =?utf-8?B?RktYYndmcDZ2SGVGMGpvRHZXY0xmZWl6aTU5K1NuclE5ZUUxNXlQMCtCblBG?=
 =?utf-8?B?cGxyc0pZdUNmeE1qQTkrYTBac0lRZy9qYUphQmk4N2hQeUZDQkFRaTJHbXpr?=
 =?utf-8?B?L1h5dVQrMmpmakFaR2dBOHZ0c21RVlFJb3M2TUlpdko5eVFIL05XZE95RXNm?=
 =?utf-8?B?T2NVT1pkRXhyc1NLSmduWE54dFZ4RGYyamFQZUdmd2hvd1l5WW03YUdRQ3VC?=
 =?utf-8?B?TFMzdTFTUytxSVJCSUlWN1g3K2V2N25lSlUzTjJhMVZNZlJTYzZleGpWcFYx?=
 =?utf-8?B?bTltUHR1aHFNV0taMDdKQzZyMFZ3ZWNzaXBJcndNUVp0UEVPTHpkVnVaTllr?=
 =?utf-8?B?NXNKWnJ4TVBrU0U5UFRJNVFuYWZmYUZ2KzZNUDlwZU52VkRmOWdNK2lsRTJp?=
 =?utf-8?B?MjBRcUlNcFV0c2dkNEFFWXM4Q1JWamNWL0hMcEFFM2VqTWN5UEdGNXczZC9y?=
 =?utf-8?B?QytzSlZPNUVtMUFCV3lMNXBOVEpXR3lqT0NwQUc4a0xRc245MmhIc1J0bWZh?=
 =?utf-8?B?NGRYTDdaQk81bS9HNWFxbHF0czMvMXF6bDFRajZjczA3aUIvdWJYSnBka2ZH?=
 =?utf-8?B?SGZmRndRWWQ1SUdSUFhGUW93a1ozcEs4TFNvRDNlN3pDQkpwdzl2T2tnVFdY?=
 =?utf-8?B?dG1uejVkdUxEUTFKMi9aWWNjMHdiMGRTbE1pSVJHVnFDWFU3eTd4UEFMM0Zv?=
 =?utf-8?B?WkVTbjAzL1hXS0lqNU5Jd05RRmYzVjRxMjhzMm8yS2lxRnFQbWJkYS9ZdnVT?=
 =?utf-8?B?TXpEcXIzZlN3R1lIelNES3lkWGVYSTNJZVgyTFRpejFjNjBPdHRjci8ydERQ?=
 =?utf-8?B?aHZ6dkVpRW1QajFKNXQxNkQ2REo1NlpWaXUwbHhkV2RaMkxqU2dJN3pidU85?=
 =?utf-8?B?c1F0ZXQ4UnhOQjZQdkpHVTMrSnpQNmRpbGJSekllTnJFRDkxSkNsL3B3N2dm?=
 =?utf-8?B?WEx5NVZsT2w2UjRXdW5KWXFLbjRTZ2NpalZET2xGZG5QcUlFSTlyVTR5NkN3?=
 =?utf-8?B?Smk5NEJadm1mNXRDaVl6ZUhXQ2lSdjJlYy9IWE1oeElyOE5WUE9WTVRwZWVk?=
 =?utf-8?B?dnEvcXdxTHVpSGV2aHdzWmtWQ1RiQUpmYk9hWE9SVStabExreXZXNHdMVFY5?=
 =?utf-8?B?dXUybWlRYUpRQS80aVpva3FYRmFYTjQzbTJFYlJVM2Q4STlKcExnNWlEalc2?=
 =?utf-8?B?WjdrZFdUTHpReGZ4czVYc1pjcUVscWluczVOUHhkaHhZZlRUUnRMT2JCZ2M0?=
 =?utf-8?B?cXVhdDBoWGJ6TGtyRFdLOStMc1l1djdQWDUvREVIeC9lOUQ2LzE2d1lVUFRZ?=
 =?utf-8?B?d2ZFL3dEVk9IcnZ0MFdjcERSdnJzV3dLWEc0R2U5NW1HYzJ2SmxYQUFzc2lF?=
 =?utf-8?B?QU9hSDduaStOeFVEVGlKQnBOYWxaMVA1SjlzYTN6UDEwSUdSSWN1a2prMGZJ?=
 =?utf-8?B?QVdJelV4K3RQU2FoV1pJa09SYWlNM1RjN256eldSS1hISmRHdzZBcEpzdm9X?=
 =?utf-8?B?aXJxclUxVW54bTJxemtJT3VMMXFVL0FBOTNzMmlDbU5Ua0FZTWc4bStnbjNO?=
 =?utf-8?B?QjE4dm5DSjQwakRkcVZUcGtqSFhJdWpuUTcrRERjK2NiTllJRERtUjhXQnhD?=
 =?utf-8?B?a1U4SHBiL2RXTk5wVXF0UVc0bDRyL292ZTllZGQ0NCtkS0tUV3NBTm5DaElR?=
 =?utf-8?B?b2kxdkNTZy94eGJ4ZnZsQlhPKzRVNnBYam1uQjVLd1ArTlZEdzFMempOdnQ2?=
 =?utf-8?B?bWRNMVZlZ3pjL0NLTmlqUEZRN2NaMmFEKytRYTJnSVlONkY3MitIZz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a08154d-171b-4c8d-b533-08de5232f8c9
X-MS-Exchange-CrossTenant-AuthSource: IA4PR11MB9131.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2026 23:33:21.1019
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pCUSvdkgHyzCd8N5v32ElypvrCLQJPIsCGpFCdYNem7+QafiMXNzY27l6m/NjrToprEqvEKfcT++gn6vge7wCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7685
X-OriginatorOrg: intel.com

Michał Cłapiński wrote:
> On Wed, Dec 17, 2025 at 4:14 AM <dan.j.williams@intel.com> wrote:
> >
> > Michał Cłapiński wrote:
> > [..]
> > > > Sure, then make it 1280K of label space. There's no practical limit in
> > > > the implementation.
> > >
> > > Hi Dan,
> > > I just had the time to try this out. So I modified the code to
> > > increase the label space to 2M and I was able to create the
> > > namespaces. It put the metadata in volatile memory.
> > >
> > > But the infoblocks are still within the namespaces, right? If I try to
> > > create a 3G namespace with alignment set to 1G, its actual usable size
> > > is 2G. So I can't divide the whole pmem into 1G devices with 1G
> > > alignment.
> >
> > Ugh, yes, I failed to predict that outcome.
> >
> > > If I modify the code to remove the infoblocks, the namespace mode
> > > won't be persistent, right? In my solution I get that information from
> > > the kernel command line, so I don't need the infoblocks.
> >
> > So, I dislike the command line option ABI expansion proposal enough to
> > invest some time to find an alternative. One observation is that the
> > label is able to indicate the namespace mode independent of an
> > info-block. The info-block is only really needed when deciding whether
> > and how much space to reserve to allocate 'struct page' metadata.
> >
> > -- 8< --
> > From 4f44cbb6e3bd4cac9481bdd4caf28975a4f1e471 Mon Sep 17 00:00:00 2001
> > From: Dan Williams <dan.j.williams@intel.com>
> > Date: Mon, 15 Dec 2025 17:10:04 -0800
> > Subject: [PATCH] nvdimm: Allow fsdax and devdax namespace modes without
> >  info-blocks
> > MIME-Version: 1.0
> > Content-Type: text/plain; charset=UTF-8
> > Content-Transfer-Encoding: 8bit
> >
> > Michał reports that the new ramdax facility does not meet his needs which
> > is to carve large reservations of memory into multiple 1GB aligned
> > namespaces/volumes. While ramdax solves the problem of in-memory
> > description of the volume layout, the nvdimm "infoblocks" eat capacity and
> > destroy alignment properties.
> >
> > The infoblock serves 2 purposes, it indicates whether the namespace should
> > operate in fsdax or devdax mode, Michał needs this, and it optionally
> > reserves namespace capacity for storing 'struct page' metadata, Michał does
> > not need this. It turns out the mode information is already recorded in the
> > namespace label, and if no reservation is needed for 'struct page' metadata
> > then infoblock settings can just be hard coded.
> >
> > Introduce a new ND_REGION_VIRT_INFOBLOCK flag for ramdax to indicate that
> > all infoblocks be synthesized and not consume any capacity from the
> > namespace.
> >
> > With that ramdax can create a full sized namespace:
> >
> > $ ndctl create-namespace -r region0 -s 1G -a 1G -M mem
> > {
> >   "dev":"namespace0.0",
> >   "mode":"fsdax",
> >   "map":"mem",
> >   "size":"1024.00 MiB (1073.74 MB)",
> >   "uuid":"c48c4991-86af-4de1-8c7c-8919358df1f9",
> >   "sector_size":512,
> >   "align":1073741824,
> >   "blockdev":"pmem0"
> > }
> 
> Thank you for working on this.
> 
> I tried it an indeed it works with fsdax. It doesn't seem to work with
> devdax though.
> 
> $ ndctl create-namespace -v -r region1 -m devdax -a 1G -M mem -s 1G
> libndctl: ndctl_dax_enable: dax1.0: failed to enable
>   Error: namespace1.1: failed to enable
> 
> failed to create namespace: No such device or address
> 
> $ dmesg | grep dax
> [...]
> [   29.504763] dax_pmem dax1.0: could not reserve metadata
> [   29.504766] dax_pmem dax1.0: probe with driver dax_pmem failed with error -16
> [   29.506553] probe of dax1.0 returned 16 after 1815 usecs
> [...]
> 
> I think the dax_pmem driver needs to be modified too.

Michał

Did yall have a suggestion on how?  I lost track of this thread over the
holidays and so I'm not sure where this stands.

Ira
