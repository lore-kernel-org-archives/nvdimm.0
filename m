Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16EC2BA45
	for <nvdimm@lists.linux.dev>; Fri, 21 Nov 2025 00:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763685981; cv=fail; b=lk8ndQVAt6YlRXwABCMYNd5mz9bvduxIIMrlrUTQqkeEP+mIWC6XcuaeAzPaJjklGs10EOlPVcq0yzk/f7VcGUI/+8aNs6nhe8+06jkVHZEHDZAEQMQ5Tjmah+B1Wmfotn6QH6iRy1SLr0bhFKSo5w6WWATuyO2yDpWR+8VAxb8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763685981; c=relaxed/simple;
	bh=jeud/MaskYF0FEMdZoeqLGsWeOoJRemWSeUyXEVR7mI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=T1WGA6Ujfq1xp0ZgkWAl7LPNN+xz9cvoKTMhFUfOiTeR/ubfOSE3SWaq8lW/5G+/Lp2wGDHpoGUNksiN2RIHnSDAvJhzRFoehYZ/RBmnjkynIPc2/KMXqMER39T3LdfDiJSN5Er/+vJvJcRrUaNctAT6aDuAUji8vsTFycF1dEA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gVz99vJM; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gVz99vJM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763685980; x=1795221980;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=jeud/MaskYF0FEMdZoeqLGsWeOoJRemWSeUyXEVR7mI=;
  b=gVz99vJM1yWVlU8GvtWkry8VoRZNwNmbg8Zg/szSLcbEp6N7RwpyGkgg
   8EJodrIdWXlmMwSpljpCtXwWFZ1sTEybmv7398enRUpQI4FynDTW7eSW9
   fhQ9khqsVsazhpjz0z2PTIwCsk2aYVtNTqN4qxRjvY+WwJ8t5BwVE423v
   zsCM5vAlok0bH1D1YyqE6ekCd2KDGmgrxkEohmqafCJnx4lmEvguKF3kR
   Wbx+5MlmNr0O3lXRDSgvgRgaygOaue5vIbWsgcmoN6trOBoliTLgLBqER
   cnjULJ4v02fUhokQqf2n3/mGXgSi/d82DI3zPoq/SN7aJWvWt5R7OhJVU
   g==;
X-CSE-ConnectionGUID: rLYQZOrxS0+p4+areHNP6w==
X-CSE-MsgGUID: 4WHFUk/pTU+qi1wn2mPyZw==
X-IronPort-AV: E=McAfee;i="6800,10657,11619"; a="77135983"
X-IronPort-AV: E=Sophos;i="6.20,214,1758610800"; 
   d="scan'208";a="77135983"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 16:46:19 -0800
X-CSE-ConnectionGUID: a/V4Yh9NRgqZ63AIS4c28Q==
X-CSE-MsgGUID: d9ciqjSVQJSuhXJltGyxmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,214,1758610800"; 
   d="scan'208";a="191626016"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 16:46:20 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 20 Nov 2025 16:46:18 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 20 Nov 2025 16:46:18 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.19) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 20 Nov 2025 16:46:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pkI8wpBMKhFr7GNGGY/k1mYCXQ9M7REFL17pErle6zVukKj7Kw9kCjBLuwY9GPLh4gxde8UG6Vtpgj0jsEF7BoZILyMnzu9CMzCpbearb+i/zXnMK+x822M3c54dIfJCEcpVh1eTyCB686ha+1oHsY0F+VbIMdp2/WvlMF+yhIyl2bdpR3R8PmaemNGp4QtaM6ayGkK3vGy44eQi1S5peROtqB38OwCUTDh4iRocmrh26HdS3CvyF5YKH4G2va6biIE4zPoVTNyRdBrm/oUrhZ7qy6icpjG64iJz+AKAf2nlbTU7lHNllCnId8oPeQeW25PDR/cuOmotPUuXMbxrfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8mIipi1XWYSFiU/eYrfMlmf11J960/Owqw/hJyIAyoo=;
 b=Xc82EkXgs+leSlT9fo6wl0M/kQFvKXN1JPaEePp6D8jFYBy9FMbLdRXCGyfaLo1G0q/NRW9faSLPgYaAVfdElXFNBB1dHCiCriq3A7lqJj3o4uHWgjEmlJ8yPsiHEGrgBk79+k9CSQpoW8hDhcT+IYMmTX4P8HPsl1GCXTGMdWYdhhpbfEPsL55H+ED7LgfgCGGjwWlKgVhmtT6xGGbkTjb6LIBax8DWpVC/rzKEzovTQVVO80tj7X6r2uslkbePpCEQv4mUlL+2sdp3gbeo2fj/Uwy+2fcZVsmWCZaRN6/NobMuafJookjtsvXHS7prb8PKnLq4w4oS5p6oK2F53w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA4PR11MB9131.namprd11.prod.outlook.com (2603:10b6:208:55c::11)
 by LV1PR11MB8841.namprd11.prod.outlook.com (2603:10b6:408:2b2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.11; Fri, 21 Nov
 2025 00:46:13 +0000
Received: from IA4PR11MB9131.namprd11.prod.outlook.com
 ([fe80::7187:92a3:991:56e2]) by IA4PR11MB9131.namprd11.prod.outlook.com
 ([fe80::7187:92a3:991:56e2%5]) with mapi id 15.20.9343.011; Fri, 21 Nov 2025
 00:46:13 +0000
Date: Thu, 20 Nov 2025 18:48:40 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: =?utf-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>, "Ira
 Weiny" <ira.weiny@intel.com>
CC: Dan Williams <dan.j.williams@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
	<nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>, Pasha Tatashin
	<pasha.tatashin@soleen.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 5/5] dax: add PROBE_PREFER_ASYNCHRONOUS to the dax
 device driver
Message-ID: <691fb6e8ee45e_50899100a7@iweiny-mobl.notmuch>
References: <20251024210518.2126504-1-mclapinski@google.com>
 <20251024210518.2126504-6-mclapinski@google.com>
 <691ce9acae44c_7a9a10020@iweiny-mobl.notmuch>
 <CAAi7L5foTbvvskLxKW50T49bdUBbedoxQHifZ-4NJYf+Fv7YvA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAi7L5foTbvvskLxKW50T49bdUBbedoxQHifZ-4NJYf+Fv7YvA@mail.gmail.com>
X-ClientProxiedBy: SJ0PR03CA0002.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::7) To IA4PR11MB9131.namprd11.prod.outlook.com
 (2603:10b6:208:55c::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA4PR11MB9131:EE_|LV1PR11MB8841:EE_
X-MS-Office365-Filtering-Correlation-Id: fdf0ddcc-cb2b-48d3-adc4-08de28975ecd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?clBKYndnVjBzckQ4cHA2UnhCM2ozRkdwYjJsSDFwZGRHb2xxYVVBQlJ6WVhh?=
 =?utf-8?B?RVZGR1BXUE5LNXJnOFlKVHkzN3B6Mk5QcVpwdVNjRUpKQ243SWZucVNnUHJS?=
 =?utf-8?B?Y0xzZWJkWHU5S3NOMkxLZHFZOVQxajNualN0cUJudVUxczFXS0syelBiUUFS?=
 =?utf-8?B?azFxdXZ3VUYxMkpaWUZYRmNhaHd6Q1QrMjl6bG9nbFoxbmdxMWd0ZWgzSEtM?=
 =?utf-8?B?LzE3clUzM3M4V0lDRHVvSTFGVmtOdkF2MVRCSkNmRFJHZVNQdGhSaHI0VkY1?=
 =?utf-8?B?eG4zeW5qUGVTOVZQM2p6WEhkcmdlRk54QUxXZ0p1VjluTXdZckNvckt1cjNH?=
 =?utf-8?B?QkY5VnphQW9RSk9OMmVNYkYyTDhna0JZdnZkNnJkaVJFZXU3cEUyd2kweGRE?=
 =?utf-8?B?L3NhQTJpWHlCSm9obGF2L3RBV0xKR2p0S2txc0hLakJEKzdpeEVVQTRZdXU2?=
 =?utf-8?B?dWdJdUVqUGhJNUJ4dk4vWGM3dU5yYnNPU3VYYk9CVmhnSmUrYXFKL3Q0V0JP?=
 =?utf-8?B?cFNObWFwMll0R2c3eUVFdHRVWXh3ZjVZYjh6S0ltNGVEMStBamRjRHV2dnBH?=
 =?utf-8?B?eDdCdFVoTjljT1pyZUFKTGtrcEFvbWVHS3krK215Z0Z6ZHVYZ0JiOWVWeFhw?=
 =?utf-8?B?aDNSK0JzWWJNenRtdDRPTHh2ZjMwdFhzbHhhS3RNWDlzbWVTZk1BK0lQbHV2?=
 =?utf-8?B?Tzd2U1doNWE1N29kdWJZUXUvb2s4OTZDOW5wMjlhRDlnaTZqY0s2ajdydS92?=
 =?utf-8?B?STYyVlU4N3FCTW1WVlNncVo5Yi9Rc05ZdjhsSVNqTDB2c2l0R2Z6MmlMTGpl?=
 =?utf-8?B?OHl4Ti9IUEJMRFF0cDdVZ1ZzKzQrZUNVN2VvYkNXTzhXRkJXWWJQU25XVGtI?=
 =?utf-8?B?ZXVUUFNha2VLb2Z1UkJxcWdpczN6SkM0OURLTG1icXZKMEhTSll6bGNaSGFn?=
 =?utf-8?B?d3JzY2RzZFJ2T3dCS3gwTDNFNWI4VUtwa1BKTWpBaVV2MlV2R2Y0dkphYkMy?=
 =?utf-8?B?YlJUSE1iWUkrUitVR1RSR3BFbDRzTHlmeWNHZEp0cTNDODFjUGJwLzlnWW0r?=
 =?utf-8?B?TURZdzEzejUwRjJlampwNzlRUlpZYzBxcjVWbnBMRTc0SzFGRGtIYmZpcFlC?=
 =?utf-8?B?QlZBTnhTUWVhREN5blZmWjlJYXF4elhqbnBFa05TOGw2WDMySmxORWtRM25q?=
 =?utf-8?B?bVoxRFhibXVQN2ZKZWwvY0VhT2F2YUY2L0I1ZlRTTWE0bFkxSVdIWjlBMGJs?=
 =?utf-8?B?MDRva0VxSS9xQ0FwTmF1VUVtK1hjN0FyUnJHblFMZy9DSnNIaTRjc2RYQUts?=
 =?utf-8?B?ZUluTW5UbEdjMVJSajM0U2pHZnpLR2FQa0VrbWRCdjNZZ2RWUzRueUNoRVkw?=
 =?utf-8?B?eFZCV1hFWTM3cnFSV05HQURuRysvcmJteWZ4RlJES0E0MFRXaVh4NE5CcGNy?=
 =?utf-8?B?M2ZJMTNuMzR6T3FSVE5UWFl3VWpmN2ZySEY4K0Y2YWtmbVUvN1JXSlFnSHh0?=
 =?utf-8?B?QkJRZ01yVkFhbVdFaUdPeHRWVzJMVjN5b0RDelZ5SENYUzVaYytuTTRoSmp4?=
 =?utf-8?B?bkdQS0dzUTA0NXhuaHA1SWpDN0YyaVorZEpaVCtLYk0wREwvMFpjODRxS0JJ?=
 =?utf-8?B?TVlIZFJvdHBKakdYR0xvZk1XTDRNdGFoTW83eW83T25tRE80ZU9pTW83YWJx?=
 =?utf-8?B?R1NPMmRDeUVFLzJsR1h2ZXMrMGRIWkJwN1pELzRYMmF2cXVZMllnZitIZ1h2?=
 =?utf-8?B?ejRzekxOY2tIREtvOUVhYU91S1FTZEhyMDhCOHZVSFpnVmNJd3B4VmtIY05o?=
 =?utf-8?B?SmxGcm5YbFVjbE15SG1Odk45U3dRT2xPR2N1M3ZuZG00NUdkSG4wOFFBSURS?=
 =?utf-8?B?SzFqem8rZHJZZ1RteWMvRU9LYzBmR2lMWllkUkN3a0Y2bzV5U2JPajdaTEFD?=
 =?utf-8?Q?LoznyHtWU+c+DxFqLVT2Lq2w1ZMNL8On?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR11MB9131.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U05HS1pBZEd0L2ZmMCt5MnI2azJ6dWpqY2IvWnU1Q2wrdlFzM0M5eDJCa2Ur?=
 =?utf-8?B?TTB5ZmdrdWtlTHJaN1hXMEx4bnloZUZEWVh0RXVBbEF1NU9WK28rMEZCNnZH?=
 =?utf-8?B?QmJoSW1BMmdqOHE2OGhqbmEwVXlJeVNTUllpZ2lTYnprTWkxdXdRRUhCdG01?=
 =?utf-8?B?RGZEZURPSmpyR3R5WHdsYm5LbmhCSG4rY09RQ1FhL0lzN1ljOExPSDFWb3hK?=
 =?utf-8?B?UlJZR1NlZGEvYjVWM2tkK1k0MFdSd3pXNUdidUhrbVR4MmFlY2RDU3pIN2pt?=
 =?utf-8?B?MjFiaWJkT1dkeEY5TzhWeENPOENZTU56Rm5ac1RMWkVpcTJSMFpqdnhaeS9P?=
 =?utf-8?B?RXlqdUVMeWlaSFkwWkNiZVpXV2xkVzE3S2ZkbWppTlhWb25WRTVIc0ROWTUx?=
 =?utf-8?B?U1pGRzBYcDJQOFhtbHA0WE13OEFtRURvKzVDRGlnbEhLbUw4alZHV25zbzN6?=
 =?utf-8?B?S1N0Y0RBdThqRUFhd0pLMktxRTAzczBZR2lVTVArb2VrcVQxTWYrT2Y2eFFY?=
 =?utf-8?B?ZHRGSjB5UWxPTU1WN1FjY0Z2ai93TTdQeGliUGE2ZUtUOXNZdzNZMnloVUR5?=
 =?utf-8?B?MmxLMStzUlBCUWhVdStIMENsNHIxV01UNWdHd1QyVzdTcWVpUzhSWHVVMm9O?=
 =?utf-8?B?VFBEOFhTb0VSZ3g5YUYzQURzSFNhY3k5NURsZmFuMFI1WjI2R3lYV2RWQStt?=
 =?utf-8?B?aVdiQTdaUWNoRzFRR25WYmViVHZlZHpIcWErZUZ6MnFZc2tuSytyTkREbWNI?=
 =?utf-8?B?VDJ0eGJ1V0RGZVBYZVhMTjFRdFpmUXVKcXowYjAwMVBTYXFZYnMvZXVRbWtF?=
 =?utf-8?B?Mm40ckhlUTZiK0RBQnZPYnRZNHM4N0toOHJ6S1p5Ukxjengvbng4bmtDclhU?=
 =?utf-8?B?RHdZb21pTVcyUW1WOW5aTFRsa0hxcjNsRnF6ZUduZGl6TDc2Y3ZZT3hGdGE0?=
 =?utf-8?B?N2dtbkE1NU5qdjhHZU1ONlMxemVzTkgvTjR2RitsYVl3V09lT1R5SUNKOFd4?=
 =?utf-8?B?ODB6akVwN0Z6N1h5WEJ0bHdUNXEvS21HZW0yTXpUSzVBR29IRzI3MVRUd2lS?=
 =?utf-8?B?dmZYa0VBcTk4K1ZmZ2dNRXpFbnlLUzliTzBLbi9KOFI2MWw5S0Ewa3FDaWNF?=
 =?utf-8?B?UnplQUVPMUJMY0sySlp0OFFTMElmRnFjMlpIVkRBeGNEOTdTZythaEdsUTcx?=
 =?utf-8?B?b2EwcTFqb0Y0V1MxbW9BR3FRL3BkSkg2b0xlTTY1cmlNaitqWjczdDg3ZDAx?=
 =?utf-8?B?UnpPZUxJaU5QeDVwdVJFaGFnTkowd0dGSzVWamVrVmFxbnR5QzRxQ29tWXN3?=
 =?utf-8?B?QkR1dVVSNnlnUjY2MXZYbEM4c0FjV2JtcjI2M05JVVJyNXhmQXI3Z3RZU21i?=
 =?utf-8?B?dHJCV2J6SnBSaG5HNjFNRlZXbWlZeXhvVjhpK3BCTzFtUXdlL09BRUhKYzND?=
 =?utf-8?B?L0NOdld6bWo0b3dTbStwbzA5VlY4Vmp2QnRVRW5Ja1FQaUJhb3pwVDdXd2M2?=
 =?utf-8?B?eWIrVzAxTkJFeWVUUm45eXB4RVlaZXVUWnJ4bG1EU0EyVzJPOFJJdE5FWHQr?=
 =?utf-8?B?RkZDZG9Xc0FNeVFBa0o5bnpnbkJyeW1QaGtCeDIzWTVuZ3dCZS9KdjBwRHJs?=
 =?utf-8?B?Y2JscEgzREE5NVpjNktWdE5BWnFENmtFTGwzdUY5MkZQWitjTFRrOS9xV3lN?=
 =?utf-8?B?TFl3cDZockdjU1ZLbkhRQUM1S0hSc0hqbC9NUVpidnhMZFFNbitGUENTU25t?=
 =?utf-8?B?Ly9vbDAyNkY2TUNEVHBKcXFZVFh3MUpQQXNld0VHK3IyWGY2cGJkSk5FN3ZJ?=
 =?utf-8?B?UkN2UGR0WEh3dkNQTnVCTjlDOGpHdDdYS1gyWEV5d21rc1dCMWFqR1lNWlhI?=
 =?utf-8?B?RGI0M0gxUDJFZEtQSTAxdmN3eGFqQXkySlhGRlM2VnBObEFmcm14b1V4TUtT?=
 =?utf-8?B?VGE1WVdWcUM5YUlwSnNBa2s1Y2lpQ3I4MVc5YWZyVCs4NDFRWEQrNFh2UUVv?=
 =?utf-8?B?Umo4K3ZlcU1WdU5Wb2hTRloyVjI0c2oxYkZBY1NpZWRmeFd6MVl2M2dURUlQ?=
 =?utf-8?B?QS9EYzV6bi9PcGZscElEODhOZ2x3S1R5bTRDekFoRUIrRGgxY3JkR3ZGQ2lw?=
 =?utf-8?Q?sCWEbAVsiqww0k4U6vXQte/AU?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fdf0ddcc-cb2b-48d3-adc4-08de28975ecd
X-MS-Exchange-CrossTenant-AuthSource: IA4PR11MB9131.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 00:46:13.1848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QKZeZ0VvfQve80T9Q9CjEW7OnTCUPbwPjNUaUMTOQegsf8taBssjjVovnSW0YGUFCEQumSBiXPW5FQcwVskQIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV1PR11MB8841
X-OriginatorOrg: intel.com

Michał Cłapiński wrote:
> On Tue, Nov 18, 2025 at 10:46 PM Ira Weiny <ira.weiny@intel.com> wrote:
> >
> > Michal Clapinski wrote:
> > > Signed-off-by: Michal Clapinski <mclapinski@google.com>
> > > Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> >
> > Sorry for the delay.  I picked up this series but I find that this breaks
> > the device-dax and daxctl-create.sh.
> >
> > I was able to fix device-dax with a sleep, see below.
> >
> > I'm not 100% sure what to do about this.
> >
> > I don't want to sprinkle sleeps around the tests.  daxctl-create.sh also
> > randomly fail due to the races introduced.  So not sure exactly where to
> > sprinkle them without more work.
> 
> I see 2 possible solutions here:
> 1. Modify the tests to just poll for the devices to appear.
> 2. Modify ndctl to poll for the devices to appear before returning.
> 
> What do you think about those?

Yes those would be correct ways fix to the tests.  But I do wonder if
there are any real codes which might break with this.

The real issue is the incompatibility of changing the behavior and having
an older ndctl start failing either the tests or code written to
libdaxctl/daxctl.

In this case I'm not seeing a good way around this other than trying to
make a good documentation update to indicate that the ndctl needs to be
updated for the tests at a minimum.  If we get reports of failures from
real users though it will need to be reverted.

> 
> > Could dropping just this patch and landing the others achieve most of what
> > you need?
> 
> No, device-dax is the only one I actually care about.

I was afraid you would say that...  :-/  ;-)

I'm going to drop this patch while I coordinate with Alison on updating
ndctl.  If we can get a fix next week to ndctl I can throw it back in for
the merge.  I think it has enough testing to work that way.  Otherwise it
will have to land in 6.20 after ndctl is fixed up.

Ira
