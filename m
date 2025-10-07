Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E95A19EEC2
	for <nvdimm@lists.linux.dev>; Tue,  7 Oct 2025 01:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759799829; cv=fail; b=bcV3FhdW5hQ7lca5Udb/FusrLoVCWlZlAtQFew88WpSDHK7izt6010jVPCZJVBVj592Xer8Z6R0+7x1iVb0lIwc//DryQd9xtV4RHq4tNfASn5C23/XnF6jpwqEBL2CygpeqobaIkOJoS3+LzHUNfrZErGL9RiGd6iYMEk6OntQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759799829; c=relaxed/simple;
	bh=QwkTts8WnbJ4AttHaiNMngbFI6icWhKNsbYx1oWkPgk=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=FBhRNUfJUrWFHPkQ+UFYimnMzeNnPOnQxOrGaykZA+Jtcn6DsDMxuo7VGXbw9Wc9B66+71b2B5q4/OlIsYRAkXCLjcAm8n0t6HI0aZ1/LnytHVzv5o4DSZeZiPpjp2nhw14ArInDrJewDzrTrJn7YphA3yQWON9RBS8iX2gFVPY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TzvePJPw; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TzvePJPw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759799828; x=1791335828;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=QwkTts8WnbJ4AttHaiNMngbFI6icWhKNsbYx1oWkPgk=;
  b=TzvePJPwMkU/cp96T8z1EYT6NL2GvZbZRSQ4rdXFf355nlhc7zTaEqtA
   Fyc8TDytO3WU6P1boBH3jK6F99fQDpVFVnTcZ8LJNxFZuK5qCTciXl+rG
   zIae5Nwb43EBsyI2ZSaUuE5RJ39JEwM2pvlnDsvD1uMH92cBEfxkNBqnR
   nz1iOjJT+suNJYywrXyD6Lh/QsU/MZ4QF+3NEs5QQYtEztanuvd+xv9eR
   njsDYOZFljEVneWPhEP1Jx1z3RZaSH3G7RkH5wlLSS3CiaNCUPa6RhOG2
   3qo/mPXlB8wD/6KT+XYpzIIEQ5MAYXc0HOkaGDNdbYNG7HXFEZcvRAJgg
   A==;
X-CSE-ConnectionGUID: rUcET45bRbmeUCcFHkjsOA==
X-CSE-MsgGUID: 2uz3nDLPTQGZ/nVcvjJw4Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11574"; a="87445539"
X-IronPort-AV: E=Sophos;i="6.18,321,1751266800"; 
   d="scan'208";a="87445539"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2025 18:17:06 -0700
X-CSE-ConnectionGUID: d9YbRe99RGu1Smgb6GtrRA==
X-CSE-MsgGUID: XZ+yDEUwQOGoKh8fpOQTLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,321,1751266800"; 
   d="scan'208";a="217104797"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2025 18:17:06 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 6 Oct 2025 18:17:04 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 6 Oct 2025 18:17:04 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.11) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 6 Oct 2025 18:17:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mv5cBtc6G1gIvHVBf0J97mdzfjq6jDhRYuHnuWQMFUQIVrqcdY2hyV6Ej0cYFdC19UEEiTTkl0/EwShqA6WKiSsfcf5+RuUwoX2VRlJ+GmcWD5D4wSSXiPeOs9Pc1yaAPYNn9ggAP8HJq+0ZIKop5huzFe8ZOA2/4ssBRmSsJUXrK2RT1JA/RkII0E5Sgek8GbznP4oowfqwe9gwiEdZY6f4sHrpsGLhuyafO0DbwqInaRxtSMfey5gz0a+0kmt6ncPjO2kkzeShHJF7NNUL4WIcJkIh2VjrLs74FFU40sn/Uxl1rTRiLI+eF8Kudg9iCH2ffgiwSu7+YDF8ogfqLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RwDHTEBymsPFlWobMw0CW06zJnh4Zpn/sReY/GDOFts=;
 b=WquuaHgcUCkuuy/vBG3oo44NTqRHiClDTG5nURj3xOM19B68crhjIPXWz6su5yWDVd6Xg3NRoUEIYPhjRXLxpQ1J0eIlZdeU8M0FmyYliFVKH08n1rVvKyysEO7TcYnk6x06+ib9dJvFxQB8+2nU+s526+FBosKYopTPmVJqytO8zKB9koV3D3gESiIfHfAoaho9AE3duapD08Rlpz+PzkodI9LPYrFUyl4xrmFjdlHCgL066wApeJp1k5pIEmwdmq8ulSDRnMQ9Drs2rOTMCkAu43UKUGcpTbSRKE+/6JCD64TveMoDJ+CHV7I/UA/wPi0AzkJ2ml0sJp/bXtlQQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DM6PR11MB4546.namprd11.prod.outlook.com (2603:10b6:5:2a7::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Tue, 7 Oct
 2025 01:16:59 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%4]) with mapi id 15.20.9182.017; Tue, 7 Oct 2025
 01:16:59 +0000
From: <dan.j.williams@intel.com>
Date: Mon, 6 Oct 2025 18:16:57 -0700
To: Dave Jiang <dave.jiang@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>
CC: <dan.j.williams@intel.com>, <vishal.l.verma@intel.com>,
	<ira.weiny@intel.com>
Message-ID: <68e46a09c2a07_2980100f3@dwillia2-mobl4.notmuch>
In-Reply-To: <20251007001252.2710860-1-dave.jiang@intel.com>
References: <20251007001252.2710860-1-dave.jiang@intel.com>
Subject: Re: [PATCH] dax/hmem: Fix lockdep warning for
 hmem_register_resource()
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0118.namprd05.prod.outlook.com
 (2603:10b6:a03:334::33) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DM6PR11MB4546:EE_
X-MS-Office365-Filtering-Correlation-Id: dbc77262-4880-4dc5-20ef-08de053f367d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bEtMa0lsMWx3TmkwQXh4Y2k3YXFUZmIwcGJORVN5WW1oVEdENEJ6ZWVnS29J?=
 =?utf-8?B?UitaRWtaaS9BNGIzZTdycWdtbkhKelN1OGh1SXJUTmVUcnpneTFISnh0UTk3?=
 =?utf-8?B?eFZoTUJXNGQzWkRETzlLZTJlN2RuNTZkTWpqMVZObGgyMTQ1dFU2YUVpSThQ?=
 =?utf-8?B?Y2tFTjZ2aUl5S0ZkM2ZLbWtxV2ZRcWJWT1lSakdpRFJrQVEzMk5CTlJqVG1o?=
 =?utf-8?B?RzhTTnhQcnRTZk9ybzZ6NlV6cGxJdHRkSklxcDFOSE41OURCMnFFTCtCZ0JQ?=
 =?utf-8?B?SE5MWGVjMGpRS3lobEVUbTNtb3BOU0ZTU1k3WEFjUGljd2hXOXQxZzdVZHRB?=
 =?utf-8?B?bkdHdDZJdE9YaUdrWFNHemR6enZJKytieUVhZXF4ZmRNRW0wRmdyZ0FzSHZt?=
 =?utf-8?B?ejRUUnBNMkw4K05ReE9JWUVaQkVCQWN5bmEvU3AxV2JNY0IxcmhjRUlkdFh2?=
 =?utf-8?B?YjBiaUl4N1VPaCtKanRtOUJKblJZeTdEN0pPekE3VThoN2pJb3RSNE9pVUtJ?=
 =?utf-8?B?N2VGY3hmdlI3YXVVVmdBUERFVno5RGlZaDVXYk5oSS9ZUGlRTEpnci93dTVZ?=
 =?utf-8?B?RjU1UGF0Z2Z6NkI2VGdaMFNHTHhwd1VSS01HSm1UOHVLSWlXcDRvNHRWc0hm?=
 =?utf-8?B?RHZ4TVpkYlVueW9CUHNaOTBVSUhaSG1zZWtyK3A1aU8vMWVoT0swOEJ2T3JQ?=
 =?utf-8?B?L1lDdkN0VzB5bS9BNVFoZ2UwVXIyZ0JaL0ZKTkNjeHcvWmNtTEtha1NhTmdJ?=
 =?utf-8?B?bjFIRU9DMVBjRnRwcnJYNm5kSktoSm9PbVpxa056aUo5eUp0L2dzQmJTZmFy?=
 =?utf-8?B?YkM2czdKU1dZMXJhb3ZDTmlyZWVKdlh2OGxPRWoxMG5UVmtuSS9jclh4UDRI?=
 =?utf-8?B?dEMwQjI0M2xqRnJ1VkwzS0RPRSszR3AzU2xOQlBEeGJBWnB4TkhLWmxiTnVT?=
 =?utf-8?B?dW90dzByeUFLT3JQK1RXUTRPV3phSUpacnRmTWJRVHVER2hha2VMbG1UT0w5?=
 =?utf-8?B?Mm0vLzRRTSthbDZqekl4TUxteVI4NENHV2NiSEFDejZHL0FrRGt1cVRGOGhC?=
 =?utf-8?B?UnE2d09UMkZUQWRQZTI5Q2hwMEJrVkFUMEJzb1pKbVdSbGhiTFFmOEJrdFFC?=
 =?utf-8?B?ck1IWlhRdis5NWxCZzlZZXpMWjdXdnQ3SEZHNGhZM1kxbXhGaU1uSnVIak9N?=
 =?utf-8?B?bXdCYWdySG5pQ2M2bGpnb3J3QzNDejhxRXhJbzBHc3hxM3BadmJBNjU2eklj?=
 =?utf-8?B?RkxJWndxMnlYejl3T3VKMmxTVXhGNFAwOFRGM2I5ZUJ4VU5UQ3J1cGkwOVc3?=
 =?utf-8?B?WW8yTi9ZWXgrSEtaOEh6WGUrbU91YjQwb3lOeUZXRDhOVm9DTnFVTkNyODUr?=
 =?utf-8?B?T2E3WE9HYTJnMnZKWmZ0NmhHbE5kanh3bjdRS0Vjbk1DaVozZHFaZC9hNEZl?=
 =?utf-8?B?U3hpSjByQ1RsUHh3dXl5Vkk0Q2JkdjZFVTNZaHhCK1EyUDYyaitoODZTdmtK?=
 =?utf-8?B?VFhMZzRWR2JjTFcxTnFWRU1VSXZ5eGpyTSsvelRwRkJKS0FoSkhXQTE4WWNO?=
 =?utf-8?B?amRFNC9mM2hxdVU4cyt6VG5jVTVqREdUOHNCQlFhaXlHdG9Xd2FYelhzL3Ur?=
 =?utf-8?B?a0NiRDVzc3ZBNjlmbzdXTFdDUm1CR2FlcGl3S2JjZkJnT3dxb0RmZHpaRGg2?=
 =?utf-8?B?L21aeU9kT214Y0xZYzBEdDdlTm9xUzdUUUEvU3FlMlB4N2wyLzdzTXFSTytI?=
 =?utf-8?B?TzFZU2V2WXIwWHB5SUN0UThsRFp2VmUzdExtaGNUUnpTaW1pdERTb084THBK?=
 =?utf-8?B?dmpBc1JuYmFEK3pNMW1KYVNoNitpeTZtNGdvenBKS1R6dkdBRnBGZXF1TDJM?=
 =?utf-8?B?UnV3S2xScmEyQ0tNdzJteXlYcG1JaEdDaWllTzJJOTNjSGQvWm1tK2VkUUtz?=
 =?utf-8?Q?4SnleJ5cOz6JnIwyH/dGoRQctqw2fxLW?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R1IzUHlrZUd5bW95UFlrcUJtWmM0L043RTZ6SzZkRHl6ZnZRMm5vN1FiNzlE?=
 =?utf-8?B?aWlDZWxud3FkNjQ3Y01YbnM3ZERkYVFCWWg1dDQ2emZhVEpoU0lWdGUxWmx5?=
 =?utf-8?B?OUVPcGRJeHdRb2RoT3RRQW5kSTlDem9qb1BPSDNiNm1yZGhuQmpuRm5aLzRy?=
 =?utf-8?B?OHIyeWEzd0M4bUhiTFdvU09ONEhnb2ViK1o5c3pleWpjMi9xUzYvSk45dUJp?=
 =?utf-8?B?N0RmcngyQzMzNGhORmZFcUZNN2RVTG5ad3FHbSt3U2hqTWZMMWhQS1pjYUs2?=
 =?utf-8?B?RzlkaHoxZ3k1aHdrQmFDUkl3cUg0bm13UW1QOHVkVlZFdnFVUkFLb25yUXhI?=
 =?utf-8?B?THFaYTdReEZaZG1PUU1UTHM4WWRqS2svY2t2MHpvQUlqTlRNK0RRMVBtby9D?=
 =?utf-8?B?RDdSSlZCVStwSkJqaVZWSWZ0SE4xTU9abjUyWThUV2hwc2ZuQzJybGdiK1RQ?=
 =?utf-8?B?RU03bUR5SnFFbHBVZGR3UCs1cEthakdpUDdnbEN4MDh0TmZyWWNIMXVqMGN0?=
 =?utf-8?B?UTZkZEFIdW8wUFZubEp0WHN1b3UxSzFTQmxsTHNNcnVBbkZkdkkydms1NVcv?=
 =?utf-8?B?aUlwQjhadzFDSWVNVGpid2wzQ2NDY0ppWjJRbVgyUWhjaFNKRk9tcG56UzdP?=
 =?utf-8?B?NUJDeTZ5eTBBdUFDMFFsWlBXNVBvZXl3bUZLVDBMTjE1ZEM1VkxMcE1TNnht?=
 =?utf-8?B?T0hjc2thZjZ2ZE5LazVCUWs2QUN3dEFDd3JNOUMzVm9TSktodnVQc1VOcThB?=
 =?utf-8?B?WHljaml5SVZMa2IrQVkzUE40dlJiL29MNHhSUlg4b3U0MmR6SmpNbTVLdWQy?=
 =?utf-8?B?NTZJalFIU0FySjgvTzRJZGtpalI0RVBzZ1FNNmdBdEtDSllDRXcraHNMQm0y?=
 =?utf-8?B?cEVSTTlrTUxBT2RuNTZaUDcySG5qekUzZ20vdTFFaW5yaFFNNUpqOFJMQXZr?=
 =?utf-8?B?Z3E1MFVybk9sN0F4WTJqU3NMblAyZWxrOU1xNHdLY0tQbWhaU3lyd0RjUWJM?=
 =?utf-8?B?TWtLN0hzS2kxU2NrcUFiUEtpczJzSEhaSGp5VlJoRjJZUmtUOTdnVlVhWFRF?=
 =?utf-8?B?MmJsZElzV04rVDYyOFVVUlRyemdCcXJ3T3lDL1JJSURaVGxOcSt4MXVUeXBm?=
 =?utf-8?B?VWtqMTI5NVNhRlVvMUF1NjI0Q0laS1UzamkrNnh0U29tZ2VUamcyNzIza0pH?=
 =?utf-8?B?TW9qM3RaWHpkSng3SmtLNytVOGJUekgvbkZ3aTBNNWtTdkJsQWlUUC9ORGVl?=
 =?utf-8?B?bjltVHBWcjlXUitWeDVIdHpjb0hDVEF2SnlDaUpnUkk1RHdURG15NGZKMGt3?=
 =?utf-8?B?dloySjZ2REFlTmo3N0pUc29PRkVVVk1naXF2R2tLTU1DNGlqRzBtSUJFRU9i?=
 =?utf-8?B?QmxFSFRDc3FoV0h0eUhBbUVTUXVMU280ejdRSDRPMTRQRHdRVDRmSG1idjFK?=
 =?utf-8?B?THdRQzA3ZEQ1TmlpWng0NGtwdzZiRldJb0FZNi9JZ2R1RmxvZ0ZZcHpIUzBL?=
 =?utf-8?B?ZEpORmQ2Rm9rcklFRTJRd1JKdEhtNzh2MWk1b3NXQXJoVjdFNVUzUzZqK3dG?=
 =?utf-8?B?RlkrMkMwUjFqYnB3YkR1ZVZtVGlmTU5KbmZveFRnYkhyVTlGd1orQWUrejV3?=
 =?utf-8?B?WGlxOUx3azdhYmVURU1FNUpsR3NHQUxmS1pRdTFUMGxMcnNYZXM4aUI2RUpq?=
 =?utf-8?B?TTBaU1hwZldHckJjVWpYVHk1MnB1M1g4WXZRTTlKbWNLOUtFU2VCSDRGZ1lW?=
 =?utf-8?B?UHpDM0JnZFRyTDIxMWxMNGlNellqQk41dmRnN0JQSmFnQVJJMitCVmhvUE9X?=
 =?utf-8?B?bzFNSnpES3M0eHF3UXI5bW9lb21NM3d2UElLL0kvZE83c2FGZGxRaXRaZlNp?=
 =?utf-8?B?eGdMSFVnVHpKU1piWDFOOENzUU5tSFk2WGlrTnU2clJpUG1kT2lHcERRdnhO?=
 =?utf-8?B?OVkyaDkxVzhKMS9YdXJlRW1ZNElmZkJSZFNKRGdTdGJsTjNWbHVRNENIQ3Ew?=
 =?utf-8?B?L3p6SFF0NXEzTVYyUFZxTUtsMWFSVlU2a2FkUFpMQW43WGNFT3VNN01HUVJK?=
 =?utf-8?B?dWZTUEFxVXQwb3JBODVFcUZ1R0ZWcHZQTjVlL3hvSEFQWEZLbU9MQ1F4ZGw1?=
 =?utf-8?B?Qml1VVZwdW5ibG45c3JVY1ZhYzc1cHJTem9ZamtGd0RGWFFQTnY5NHZtV3dn?=
 =?utf-8?B?a1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dbc77262-4880-4dc5-20ef-08de053f367d
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2025 01:16:58.9666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kfLhHWOhghgzimc2aU4gIaG55NoHSa9d5lWHmqjrdalBxqVAl5byPX7c3bRY7cKN3lH8DUU/ArzV0X7Ve9G+uclLhmzblfMrvtwMaG0ieK0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4546
X-OriginatorOrg: intel.com

Dave Jiang wrote:
> The following lockdep splat was observed while kernel auto-online a CXL
> memory region:
> 

The entire spew with timestamps does not need to be saved in the git
history I would trim this to:

---
 ======================================================
 WARNING: possible circular locking dependency detected
 6.17.0djtest+ #53 Tainted: G        W
 ------------------------------------------------------
 systemd-udevd/3334 is trying to acquire lock:
 ffffffff90346188 (hmem_resource_lock){+.+.}-{4:4}, at: hmem_register_resource+0x31/0x50

 but task is already holding lock:
 ffffffff90338890 ((node_chain).rwsem){++++}-{4:4}, at: blocking_notifier_call_chain+0x2e/0x70

 which lock already depends on the new lock.
 [..]
 Chain exists of:
   hmem_resource_lock --> mem_hotplug_lock --> (node_chain).rwsem

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   rlock((node_chain).rwsem);
                                lock(mem_hotplug_lock);
                                lock((node_chain).rwsem);
   lock(hmem_resource_lock);
---

> The lock ordering can cause potential deadlock. There are instances
> where hmem_resource_lock is taken after (node_chain).rwsem, and vice
> versa. Narrow the scope of hmem_resource_lock in hmem_register_resource()
> to avoid the circular locking dependency. The locking is only needed when
> hmem_active needs to be protected.

It is only strictly necessary for hmem_active, but it happened to be
protecting theoretical concurrent callers of hmat_register_resource(). I
do not think it can happen in practice, but it is called by both initial
init and runtime notifier. The notifier path does:

hmat_callback() -> hmat_register_target()

That path seems impossible to add new hmem devices, but it is burning
cycles walking through all the memory ranges associated with a target
only to find that they are already registered. I think that can be
cleaned up with an unlocked check of target->registered.

If that loses some theoretical race then your new
hmem_request_resource() will pick a race winner for that target.

Otherwise, the code *looks* like it has a TOCTOU race with
platform_initialized. So feels like some comments and cleanups to make
that clear are needed.

Really I think hmat_callback() path should not be doing *any*
registration work, only update work.

> Fixes: 7dab174e2e27 ("dax/hmem: Move hmem device registration to dax_hmem.ko")
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  drivers/dax/hmem/device.c | 42 +++++++++++++++++++++++----------------
>  1 file changed, 25 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/dax/hmem/device.c b/drivers/dax/hmem/device.c
> index f9e1a76a04a9..ab5977d75d1f 100644
> --- a/drivers/dax/hmem/device.c
> +++ b/drivers/dax/hmem/device.c
> @@ -33,21 +33,37 @@ int walk_hmem_resources(struct device *host, walk_hmem_fn fn)
>  }
>  EXPORT_SYMBOL_GPL(walk_hmem_resources);
>  
> -static void __hmem_register_resource(int target_nid, struct resource *res)
> +static struct resource *hmem_request_resource(int target_nid,
> +					      struct resource *res)
>  {
> -	struct platform_device *pdev;
>  	struct resource *new;
> -	int rc;
>  
> -	new = __request_region(&hmem_active, res->start, resource_size(res), "",
> -			       0);
> +	guard(mutex)(&hmem_resource_lock);
> +	new = __request_region(&hmem_active, res->start,
> +			       resource_size(res), "", 0);
>  	if (!new) {
>  		pr_debug("hmem range %pr already active\n", res);
> -		return;
> +		return ERR_PTR(-ENOMEM);

Probably does not matter since noone consumes this code, but this is
more -EBUSY than -ENOMEM.
