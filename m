Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD7C23E347
	for <nvdimm@lists.linux.dev>; Wed, 22 Oct 2025 23:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761175770; cv=fail; b=nTAbUZwJLfleSlQmKc4mtwFhdcVCq6CmIvZNYZDlJ1qUS7p5QS8uJm7gNa6AbHV5y0/HkazR/BjdB/iaeGXOMXHygbeMBK3D/EeRtb64lYZnqMU1kndewTyFlo465pslMUkutWg5F6gdsiqmbzDsQfFiQFsV0G53+L/J5pbP3RM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761175770; c=relaxed/simple;
	bh=VNkAhqDEjBti7wDrS/MvqKmPQ06a9hPEwZj/a+l6+8M=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=sGKA3jH8IlP3s8G+jwLQoVtDVzziJnWF4ZJB4Dnwyg7217KyKCz4KM1qmKav3zg0GE6P3bgfsKwsOWd2fjCyXhyLBJslCWTlFuJmv+rg13YUDHa8doEQttBY+kbCm72IIDMGaJ6fpijV8/FnUroGKK5qJq6n/J9Yab2e66k0Reg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YWgKXmvt; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YWgKXmvt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761175769; x=1792711769;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=VNkAhqDEjBti7wDrS/MvqKmPQ06a9hPEwZj/a+l6+8M=;
  b=YWgKXmvtzkWooXKY6fAjhH/NyhODpd3ekO7tBppF93+olfcRR/+ROy1P
   S8S5Y37FRClwPSi3gFL+tsCl2u7E5/4MCrcDlE4wye0Gpk1TKLKSqqM3Z
   s5s3LZwhNsVuie+ujMzbt0OKIaF78WFd02vHaP41s0wynDOaThzJs6UYP
   aIL+TmZXF74N6HWavpzxthQlJG0sdC2kWkVJ9b4NJ64Lj2iJB625Yo0aF
   PzAynp4kGXvuQ8bK7OtMEM+mI306Bzu0tCEcWKfEnN9gwB0SrOcAxsnk1
   b6lhJjlsKl3VZ/sXa7WZCpwSo9qIRmX0ETcc5b3pbrcjiIGw7s/ChXuz9
   Q==;
X-CSE-ConnectionGUID: o/R9/DyWTRC1l4c2wrQzGg==
X-CSE-MsgGUID: Nl/9iPEQSQO8D0aI7pJH7g==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="74454641"
X-IronPort-AV: E=Sophos;i="6.19,248,1754982000"; 
   d="scan'208";a="74454641"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 16:29:28 -0700
X-CSE-ConnectionGUID: TyELROxNRga+l2fnK8DENg==
X-CSE-MsgGUID: u8CN34pdRQqvYqbuAQz7iw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,248,1754982000"; 
   d="scan'208";a="183703988"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 16:29:28 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 22 Oct 2025 16:29:27 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 22 Oct 2025 16:29:27 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.41) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 22 Oct 2025 16:29:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D8m+XfM7nni8Xecg8GLto6/BGJyq9jGtqL5wMDcQpJ1anH6g62zuSQvfRvdR93POrYRgi1UTc6fStyJuHKehNHSxWZWQczQtDzXuOK5iSFAznGzqRHY4bt0oXYJZMSPS5vQPtBt3wFe4OyZRxv3r0pk4uF6qJU7znNhLoMpbUDM7YLh7ZnWvnFK9WASsRPZO7SM8l/SO/kH71EofExAKg7ptvKcv4oFbbmkF5zC1J9pSyZ3Rb/f6v+PzPv38LzSNX2J5k0jq1eU/ZcjFf9UhpXgLRbbmhjvagjAUR+cN95H3l69JuVI7yZ8x4hHOnJoktxX1L5HlLxdaubImCJQIbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5giVHNiUCtmi9PH12ryvx8B3M9eC+iBWtL7P3Je1KVQ=;
 b=vhPq2FV9TO0bjnlvElGey6IkFEWbcuYA3or1OQkgHaggzt7o5iJhc0NzW1Xn604JVpOef5ABDmVBIXm44S6rPtoI2IsHmpFaVfwAHiiwgHR4QS9aMVZaZoIJtIoWRY7nefbnAslHu3jUEaIh6tEfZ1q0Mn8OvmC2puT+0UK4lbclEJFtc6iaY4Qw2uibg631QLADgqYnFqUW/veT6Lfo2x3MHL5I6G0/suXXpVg58MHH5Bn1ZjSA3ANmShzVCn/XCXxD6rdoAPZbvM9FwDHwYFXN2S4CUw2hooiQvQdstdA95Z4+Q/UZzMA7YaNjZHANbU2pFK37AnKUi7dnFmw+ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SJ2PR11MB7575.namprd11.prod.outlook.com (2603:10b6:a03:4ce::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Wed, 22 Oct
 2025 23:29:25 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%5]) with mapi id 15.20.9253.011; Wed, 22 Oct 2025
 23:29:25 +0000
From: <dan.j.williams@intel.com>
Date: Wed, 22 Oct 2025 16:29:23 -0700
To: Mike Rapoport <rppt@kernel.org>, <dan.j.williams@intel.com>
CC: Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	"Vishal Verma" <vishal.l.verma@intel.com>, <jane.chu@oracle.com>,
	=?UTF-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, Tyler Hicks <code@tyhicks.com>,
	<linux-kernel@vger.kernel.org>, <nvdimm@lists.linux.dev>
Message-ID: <68f968d34154f_10e9100e0@dwillia2-mobl4.notmuch>
In-Reply-To: <aPjujSjgLSWsAtsb@kernel.org>
References: <20251015080020.3018581-1-rppt@kernel.org>
 <20251015080020.3018581-2-rppt@kernel.org>
 <68f2da6bd013e_2a201008c@dwillia2-mobl4.notmuch>
 <aPjujSjgLSWsAtsb@kernel.org>
Subject: Re: [PATCH v2 1/1] nvdimm: allow exposing RAM carveouts as NVDIMM
 DIMM devices
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0292.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::27) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SJ2PR11MB7575:EE_
X-MS-Office365-Filtering-Correlation-Id: 613b6f68-9bd7-435c-ca8e-08de11c2d640
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Vnl1akU0V2o5ckJ6ck1QVEFibnVnMU1mUVlVUUxmbGhsMS9JY1dveFJtekJX?=
 =?utf-8?B?U1dpcFRXYml5ZTdpMklZQlVoVHJLai8rdjNtNlVENndUZjJ6Zk9ZYWVHVWZW?=
 =?utf-8?B?ajNVdFRyd0I5VGc2eERjQVR2YjlIOC9RdHFkZGdrV3N5UTAyY1J0MVRsUEpM?=
 =?utf-8?B?SjkyUVV4cnpkT2JFRGpDR1lKdE1OV3BVdmZDMWcrR1k2L2VVT2lwTFY2OUhp?=
 =?utf-8?B?Q1NIckkwNUxHMDhMZ0JUb21BTm9HdUNQME0zMkFSSE9rVlBWSksvVHRMUUVB?=
 =?utf-8?B?c01WZ2ZveDlKWVhuMEdiS3dzTm0yUlg1eUJrWWJFUmZDTXFrelJGZExqQ0s4?=
 =?utf-8?B?bGg0UGNTZGZBR0c3aFBXcjRCM3BwVGpUeHZsOHVweUs1QjBlakVURldJeFhx?=
 =?utf-8?B?eGFlWjdRK1FqNFR1N3paeHhraFhzV0s3eXJ4OXR3eHFUcVBBZXNWVFlxTzdt?=
 =?utf-8?B?cWV2cmw5eUxPc0lMVnlsRjZrakhTVjZOendhUmJlTVVZdUQ2cXhzUkV6bnNJ?=
 =?utf-8?B?em96T3VFdWNYSjFibGJwVGpzSXQvQ21CNldIUFEreEl4dSsvRWZtS0szb3c0?=
 =?utf-8?B?ZzBjQ1l2akhsbkNBVXp2OVhhM3NodGRpbUNrM281SURLNDkzQU1TNlJXbUh0?=
 =?utf-8?B?Vmt5RkVLY2xvRzZQV3A0VzBvRzF4NFFVRXUwNlIwK1VVMVdUak5sTk1MN3Yv?=
 =?utf-8?B?L054ZjZ1NDMwR3pId0ZpTmhGVGdCQUcrMEhoM1QrRTduMmp5NE1wYTExM0FK?=
 =?utf-8?B?UmhReHFGUWUyL0gxYWNUaDNZbU1mY3RWNm1CQzhNVWc2Q3hxMVZMejNHUXdH?=
 =?utf-8?B?ZkMvZHdBeFZIdWNkTVI0SWhWclpkNkJSSWJzdlFUK1ZmeE9xWnJSbHBrbHJV?=
 =?utf-8?B?YlUvc2xCZnd0S0Vlc09qOG9mNDVhdFl6Y3RNRXJTQUF4RDhDRjJNbEh3eG1C?=
 =?utf-8?B?ajViQUNubHpkaEV5MVJGVFhSMjhhRlJJZldJTU9KMTQ1eWplajcyM0ZRamFH?=
 =?utf-8?B?RDJtUHJyYmZYYUpyNTI1QXF3ZmY1ZVFlTTVsSHo1bDNLQWRJc3VFa2VzZlhL?=
 =?utf-8?B?K0t1U2E2RFlpZnRhaDN1MzdXTXRjS1RKcUtWdWYyOGxoK1YrTHZFSXpTN2x0?=
 =?utf-8?B?RkZiUC9PdkJ1VytPNjBKUjNlc1lzOXJnVjlSd3lidE9vZm9NM1V3T1grcncw?=
 =?utf-8?B?SFZ3aEEzOFBlTmVTSEdtamhmT1hDS3ZVUHV1Y1NXVWJmZzhPcXIvaUdVMkxQ?=
 =?utf-8?B?d0dKa3pmV0x3cHl6dHh5VytOVGt2dHlBcG1JM01GbXNnak1SQzN6Y0RGTnE1?=
 =?utf-8?B?ejgwL2c5dTVUSjBNb2pnb0ZMWEZzejZJS0NSYVlUWXBSR2hNbUpJS1JkODEx?=
 =?utf-8?B?MHpGUUtOMy8ycW9rYmdEdkNscTY1dS9ocnZ6RVVMazduQVNMU0tZMnNKR0tC?=
 =?utf-8?B?VkhSQW4yd0RCY3FhZDVXdnNYNnFBa28rdzFUZ1NMSHcydXFwWGJKM0RCNElt?=
 =?utf-8?B?T1JDZXN3WE9VOTBab3RjaERuZFRWdHhnYS94NThmVlFFOEMremUxOGxiWmtU?=
 =?utf-8?B?cm84NmtzTmFsUHBRbTA4cDQwa3FSbXRtV0pJZHdYajIvOHdDUnE2aHFOZW9x?=
 =?utf-8?B?VU1TR3JxbmlaZXl5ckxKZTBXTkFmajdxOWNLbkJUY3JCUE9nQXFJYy9KSzB4?=
 =?utf-8?B?OElPVjhBY1U3UlpLbEtKeTRpckh5N2h1MVFZZ29VcldZT2IvQmtINENKT2J0?=
 =?utf-8?B?dTBkWHd6TTZtS2JxZURyNDByM2tyQkZjUTJkRGNrZnBiRmlYc0ViVlRKWTVi?=
 =?utf-8?B?aGdiSWsvMGM3VXdRRFRseENIdWltTzFXZWlQQjdtQXA2akxjd1hZaXRVVlpZ?=
 =?utf-8?B?b1FjbHVYd1JQMm92TWFFWXJXQjFtZGtkMURUVENZVzBYQVR6a2Q0NmVQZU1z?=
 =?utf-8?Q?6vZg5Nlwe9/7VPTWIi0L0kA011J3E5Fn?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y1pFRWdhTDEyaE9idTJXV2d1NUtBdFV3Ym1qTHFQTW02a1JvN2NEM28yNTd0?=
 =?utf-8?B?RTV0T2VpN0NXYnBTU3k0T2I5SFowSzdzOCtIay9VeVRrWGVrRm1sVVhUNlFy?=
 =?utf-8?B?L2xKOFREN0NqQllhMDdabVZXS3N3NzJ1K2NJMERoeHJsSUg5Rk9LbjVwb0Qz?=
 =?utf-8?B?YnptTXZsRWJNMmZCNHk2SUZ5dkN0UjRRa1FLeGFCbjc1WkZhci91OHBSWisr?=
 =?utf-8?B?S3I2UzJEVm9nWGxMSk1vUzAwK0h0NzUyVXNaeWQrQzEzQy83WklMc2ljTGN5?=
 =?utf-8?B?aElaYUs1bmxhYmN0dUN5dUV3QWI2WFR4Mit3MkFWaURiQi9hdFpFdkIxWHNr?=
 =?utf-8?B?c29jV0wxOThQOTRHMXp1VmJsd2p4R1hwaXVHMEJrZDFPR0FIODd5aWVPdFls?=
 =?utf-8?B?ZWN4cGFzZGlHOHh1MFl2SGxJcm9Rd0JHcVdSRzY2ZnFqQ3RHSmxwT0xqOHdl?=
 =?utf-8?B?dXNrUG5RbFhuY2w0SEs2TFZsZFAyZHBNVDBKb3pNY2dORXdRSFh5d0FNQk1W?=
 =?utf-8?B?UHo3UmZPSjVwdGgvaWdLbFQrek9PdVVMelNyd1E2Mkd3dGNlVThKOFllUU00?=
 =?utf-8?B?SlZ3M2VXaFNZVVV4Nm9ZbXVXeVlacUs1RmdnQW5WUHlsWWJJYlJZZTBmWlN3?=
 =?utf-8?B?L2wra2N2WHp3aWVTbml4YkxTbHNHSkZWNXpFMzgxR2lTd1Q5OFNDam96aTBL?=
 =?utf-8?B?YitmdUpmam1UdlErMHpWMEIvdWRmSm5kYnhCWXhoaU0xNElOenFoQ2dQekgv?=
 =?utf-8?B?bDMvdzFEZDBOa1ZaWGJzdHRkQWNua2l4K3ZlQ016dlROZDVtNUkzUWMrdno3?=
 =?utf-8?B?NmJVNVVLQ2VLMnBlRkV4d00zano3b0VSc1BVTk1NTGEvUnFBVm1xOHJRbnRl?=
 =?utf-8?B?NW9TWVFUR2xYb2dUWHRkZWVCZmFYTGxmZitHZ0prRG04MDFYZnB2c2dSZjNM?=
 =?utf-8?B?VFYxbkdoRU03UGpvbS9aL2dadklDU0NGTzZrVndCblVwdDRRVFFVaVZ2aTlP?=
 =?utf-8?B?QUdieEFZVXVSN0Fjd2R1RUR3UE8yNGNoZXpBNXQybGowM1pBMTVUdFhIdnZW?=
 =?utf-8?B?R3hScHdjVS9Eb2hwZUFvN21NdjJNd1V6TW9DemFsTnBGeDZkSDFkNnE0TnhD?=
 =?utf-8?B?U2R2TEFObHg2NVFWc0lZbERvZUV3VG00T1o3TjFXZWFBVVI3aWRFRWhkYlpQ?=
 =?utf-8?B?L0tuek8xQW1sbDNxRkNsUlJtempDS2c0YTc4Z240ZjJpOUh2bzAwV0ZYay9w?=
 =?utf-8?B?ZjZvQ1YzZjdmUTNONEFHNVIrdFJTNFZsdXFUYjZyV3Bkd1FjUEZhMFJTL0Rm?=
 =?utf-8?B?blp5d1UvY0RreWFKNVlqbzUvdVdqeVJIRFJNZ0wvRkxla3VwSkg4YkxmKzdL?=
 =?utf-8?B?alRZWEJDd0RRT0Z4aStHRVIwTXo0VkFPUXVpOCtZT2UxSHFMdldRbEpBbEk2?=
 =?utf-8?B?cUpxbnBZMEg4UzFNY1pNTm9ZRzhodDRnNEJsL0luL21LQmR5RU5Qc0JyOW9q?=
 =?utf-8?B?Rkl5TXJHNTFCRGhUWGpMZUx4d1pYbXNhZ3RSSTJIbDRyWjZPaG9Eb1N1Qktm?=
 =?utf-8?B?cHN4cVlVMGNiLzZoQ1lvRUNBcXlGb1F6SE9lWUxJNjQzTlBvOWJVRFhlMlB1?=
 =?utf-8?B?MzE4ampnODZhamxYczBkZkhRZzY2YlR5ZkRMaFRPVlF5ckRqajZtN0x0NlZ1?=
 =?utf-8?B?MWNBV2o2TGlYZG8wN2dNMkgwc3hSUmNSRTU2enVyNFAwcThtdUU3d3dvTXJR?=
 =?utf-8?B?OXBlN2NMSm1JUmN2TVBwMWdhRmdJZFBVYnJvNkcyek9zYmlvbjJiUEpPN1d6?=
 =?utf-8?B?VWVsWXR3aS81K0ZLYUVqazUwdzUra1NwOHVvb25Kb0x2eGE0T2xrSjdNbzJM?=
 =?utf-8?B?VlVCVCtjT3BOY2VMeXJOOXkvOE5sOWNOdHF5ZkIwRGVuaHM0aFREVllQWGE2?=
 =?utf-8?B?c3c1UWJtR08ySXZWZ0hlOTdYVi9tNUdzVlNjRFhZaUxYT0x4V3c4MDJxS0Rj?=
 =?utf-8?B?UUlaMHllRll4dFA5d2lsSUtQVTRpdHJJTlBMdG1rOFdzVjhWb0Yxd2s4bE9N?=
 =?utf-8?B?ajYzTGxraTBrbzRyemZiMTc5T0lBS1pNR0xoNkl2WFM5djdaVmE5NU14QmhU?=
 =?utf-8?B?dHpiSlpKWlBQVlYySi9VWWxyU2NtS2FCQXc0c2YyUVpkMGt1KzNYaERNQjBx?=
 =?utf-8?B?V1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 613b6f68-9bd7-435c-ca8e-08de11c2d640
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2025 23:29:25.0715
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nJOEQZZUAZ1jyJ0LMcbEPQD0m46MxBebOwZhg0dcW3dYmcMEMtsAbehH7GH2kvnnEdng5UxUiYRkSuN9KIiDBuWRKeM8I36U7uDo7n7oRqM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7575
X-OriginatorOrg: intel.com

Mike Rapoport wrote:
[..]
> > > +config RAMDAX
> > > +	tristate "Support persistent memory interfaces on RAM carveouts"
> > > +	depends on OF || X86
> > 
> > I see no compile time dependency for CONFIG_OF. The one call to
> > dev_of_node() looks like it still builds in the CONFIG_OF=n case. For
> > CONFIG_X86 the situation is different because the kernel needs
> > infrastructure to build the device.
> > 
> > So maybe change the dependency to drop OF and make it:
> > 
> > 	depends on X86_PMEM_LEGACY if X86
> 
> We can't put if in a depends statement :(

Ugh, yeah, whoops.

> My intention with "depends on OF || X86" was that if it's not really
> possible to use this driver if it's not X86 or OF because there's nothing
> to define a platform device for ramdax to bind.
> 
> Maybe what we actually need is
> 
> 	select X86_PMEM_LEGACY_DEVICE if X86
> 	default n
> so that it could be only explicitly enabled in the configuration and if it
> is, it will also enable X86_PMEM_LEGACY_DEVICE on x86.
> With default set to no it won't be build "accidentailly", but OTOH cloud
> providers can disable X86_PMEM_LEGACY and enable RAMDAX and distros can
> build them as modules on x86 and architectures that support OF. 
> 
> What do you think?

Perhaps:

    depends on X86_PMEM_LEGACY || OF || COMPILE_TEST

...because it is awkward to select symbols that has dependencies that
may be missing, and it shows that this driver has no compile time
dependencies on those symbols.

[..] 
> With how driver_override is implemented it's possible to get fireworks with
> any platform device :)

True.

> I'll add a manual check for of_match_node() to be on the safer side.

Sounds good.
