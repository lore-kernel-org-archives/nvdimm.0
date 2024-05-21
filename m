Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F316A1494A0
	for <nvdimm@lists.linux.dev>; Tue, 21 May 2024 18:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716316898; cv=fail; b=druY8YIEfYj0lvBrsXgTTNhdp1gLG0uIeiNykHHQ1G/lMY/mk/yK6ujMR3Ih4ZiUrbCybO5ky5oqeTC7bEpjlF60msRlTM9aAB9A1/dXprofKqqY1K1i0sq649RTjm7DEHFIXKdoUblFGwQW43rbCM/DO1QZa1tF7f8MDx+sVww=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716316898; c=relaxed/simple;
	bh=nlGIUCbucXvKhQer48HHYqBp2BGQH1iKIGkZsHWbNbo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jjVAfNfPh1iENSslfDXJqR3rh5omDT4DYV+096FTlr6/3zRzso8Z5gOXZ3AL8PxjHeX0Dl4ftMJbOCzw6Df4IAeijC7oRKGob+oTzyarKK1Q/mryPvP0G5oZQfJv+41LrsAC8exDQRI+QVpp/Q67JQCaLM9g7a3XSLsfkLmZm8c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N49a8HIA; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N49a8HIA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716316897; x=1747852897;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=nlGIUCbucXvKhQer48HHYqBp2BGQH1iKIGkZsHWbNbo=;
  b=N49a8HIAx2Cbe31g7ZQKeZDvN/rqoqiRHDVx4g/Adsg0Yiss+6HpxV6b
   9oH+tIEoL2lrkFXikLJsV5VVOXz6rhlIyY2zKUJPyC5dEXmIKRX0t+Q+C
   L4z//gE1geAHOVflICmhnx285cCD6XCi0Wz88vNUncDOK/VLY/FdDTsZV
   VobIq+srDed+DdFQTFL+R7cCTc0o/08W3vA11zv9+ip5s7I76Ewhp3U7t
   t/09XRd28Qy7JRpNN4wukbHjwrtPD6g1NMGNYDVyOIjTCZd6MyBLvh9Hg
   PQLgaAW4lagnBro6oKTf87agcpr2hkM166F1T/+T3SOUMLmTim4pKwmht
   Q==;
X-CSE-ConnectionGUID: XOGo4voyRuSxPGciB1r8ZA==
X-CSE-MsgGUID: bogkeQrdRzer9y1+tlHuCA==
X-IronPort-AV: E=McAfee;i="6600,9927,11079"; a="37913691"
X-IronPort-AV: E=Sophos;i="6.08,178,1712646000"; 
   d="scan'208";a="37913691"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2024 11:41:36 -0700
X-CSE-ConnectionGUID: FRv9g2X5QmSDHtdapumYyQ==
X-CSE-MsgGUID: uBBkmSIsS+u5OaV/W8uURw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,178,1712646000"; 
   d="scan'208";a="33039095"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 May 2024 11:41:34 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 21 May 2024 11:41:34 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 21 May 2024 11:41:34 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 21 May 2024 11:41:34 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 21 May 2024 11:41:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IDRRFMtg6U7CIvLF4OGXlUb4fvvT9p8cIvVZKoXUGYwjLeIRLZlEG/GlUxInoL1jKeyYDk3K+9SjIUg0mSm4uHBd9Mf6EvEL9aQFcazyaD8jgxFBUtQ80Z28WRpqV+ABeeco40+XwroJwK2DDIkC4gdCUFC+f21lSpJ9WHIzb4CLxTyZ+wmrr0WmHhdrBq1nvQ5m+rdxdIHkQiQbP19/5Gj+NRyZNVHkxVURTnUZcRGMn2Y8QZbRrdUk7xrcE5ylZMIG4vEcDYSDc4/3dd9zDy0GqFJblpuxq7HPsQpYoxkg1XGuKbXNTupxDfynvp0FenppJTvlfMJ6EajHrZKtAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nlGIUCbucXvKhQer48HHYqBp2BGQH1iKIGkZsHWbNbo=;
 b=bOukH6YrlQNWY9h2hupmSlqHC+zpuVqRjoQuzmJPnsI+06al/nHw4Bgk6ZgfeUbl1hCHWHc+Q89Ht6f8UtU688IZbYqz6it4Pf1vWJ58Zd8rESy+erEtvbaEETKDvixZ3m+eVDGoHP8mKLFoU80BPRteJZ8PdbrJIUn9dy85rZwr/kMgrSPl5kNJ0KmREGt15DbrPHluf93mZ1E1t1/zXZ1AqmzM69FykflTX4bqgtpJl05uX2PbB1rWW/AfNGI7OE4a8q1wX+1lIfV1gye/oKR8ZY4YSLtTXvLcnSFZeCLfmOka9PJwGXUhXbA372jEglQT1D1kX4h94xy5PisgOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SA2PR11MB4953.namprd11.prod.outlook.com (2603:10b6:806:117::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.36; Tue, 21 May
 2024 18:41:32 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%6]) with mapi id 15.20.7587.030; Tue, 21 May 2024
 18:41:31 +0000
Date: Tue, 21 May 2024 11:41:29 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Dongsheng Yang <dongsheng.yang@easystack.cn>, Jonathan Cameron
	<Jonathan.Cameron@huawei.com>
CC: John Groves <John@groves.net>, Dan Williams <dan.j.williams@intel.com>,
	Gregory Price <gregory.price@memverge.com>, <axboe@kernel.dk>,
	<linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH RFC 0/7] block: Introduce CBD (CXL Block Device)
Message-ID: <664cead8eb0b6_add32947d@dwillia2-mobl3.amr.corp.intel.com.notmuch>
References: <8f373165-dd2b-906f-96da-41be9f27c208@easystack.cn>
 <wold3g5ww63cwqo7rlwevqcpmlen3fl3lbtbq3qrmveoh2hale@e7carkmumnub>
 <20240503105245.00003676@Huawei.com>
 <5b7f3700-aeee-15af-59a7-8e271a89c850@easystack.cn>
 <20240508131125.00003d2b@Huawei.com>
 <ef0ee621-a2d2-e59a-f601-e072e8790f06@easystack.cn>
 <20240508164417.00006c69@Huawei.com>
 <3d547577-e8f2-8765-0f63-07d1700fcefc@easystack.cn>
 <20240509132134.00000ae9@Huawei.com>
 <a571be12-2fd3-e0ee-a914-0a6e2c46bdbc@easystack.cn>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a571be12-2fd3-e0ee-a914-0a6e2c46bdbc@easystack.cn>
X-ClientProxiedBy: MW4PR04CA0332.namprd04.prod.outlook.com
 (2603:10b6:303:8a::7) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SA2PR11MB4953:EE_
X-MS-Office365-Filtering-Correlation-Id: 88ee82a5-e36b-4257-8731-08dc79c5a21e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UVlxb1B1eGpQWUtTU28rRVdjemZiQ1VvOHlMWFV3clRKa2dvbko2Y05rcWZw?=
 =?utf-8?B?RnZydTcwcVBYb2IraFE2QVN5WU1HU01mSnZjZHNyYjV2cGFKbTMwTFcvR0pG?=
 =?utf-8?B?cHYvNDA5QklRWlB1Q1BCSHdmRVZ4L2lhVmVBaGhnV0NkZEMvUFN2NTU3UHhk?=
 =?utf-8?B?TERmalpueHFobVB6L0UxeHJZYko4V3pBblppeWUrdGJ6OE9xMTNKM3ZQQ1JO?=
 =?utf-8?B?VEoweHBldmw5SHlhc1cxQm5kMU5DRlhCS2M3ZlYxUXZnSXUrd0wyRGNnS01M?=
 =?utf-8?B?bkN2S2NlbkprQmhnNm9ZRkt2Y1VPK25tbHFPd0wyU1hoVEk2NDBIT1NLR3pv?=
 =?utf-8?B?YVpmcEgvY1hXdURPa2ZWYzRLdnZTM0dxQWJSNVFERXVNTFdCREw3NDZYWDI4?=
 =?utf-8?B?QWVKMnY1TzFzTlFXUEFPOGVpZlVsNEJVcXk0U1hqTFQ3RjJ4MHdFY2pQL051?=
 =?utf-8?B?U1cwWlRRZWNuaFk1eTlPNE5rZnlaaXZxenZ1amZwbGhKMmc2TDR3M3hLeTgz?=
 =?utf-8?B?SzhCWUViSk9YTzc0cENDRmJ0WnJ0bzc5N09KcTgyQXNtYkM1VzY2SitRVWNi?=
 =?utf-8?B?UnNVcFRXOTRlZW1IY0Y4dVFNTngrRkhRejlmc0V2RTFBbERXYnRkdkxSZ254?=
 =?utf-8?B?d0F5dHptWm05a3JReEIvTDN0RmtpUTFGOXNsV3c2a0hGSzhGQldLZHFmVVVj?=
 =?utf-8?B?QnJNUzc1QXhZSXJFdG52TXFsMW1zb1crNnBidGxHam5hOUxGSWxsOG9RQjBX?=
 =?utf-8?B?NnlsSnJ6RmFaR1R0MDQ5emlkNW11c3lCZ3NOL3RXVUhsbE9jS2xGMjVSK2tl?=
 =?utf-8?B?TzUzYThxUlQydGgxMnhLN05kbEx2NHVLcG52YlN4V2RZeEZHZlZTdnhFS2xB?=
 =?utf-8?B?UlhFSzFnVEMxcGMrQVJaREJwclE5R3FxUVJRVWlTL0tqb3Zic1pGZXpCb29h?=
 =?utf-8?B?b0o3YUZVNFZ0OHg4Ly9HWnNVZmRPUmFmQUdnODJKMSsyNHhEN3RYdWZMUTd2?=
 =?utf-8?B?MjZlUkNJK2d0V2x6REQ5UmoxMWg2Z1BTZlVFM1h1SFA2YmtDYmhubUxneXJm?=
 =?utf-8?B?aEN2MGdsVGVXcUkybzdsUmtPQ1BJSVJMQ2w1WXQ4VmRYcnZOakI5WDVzVm5V?=
 =?utf-8?B?dWNkTVVhMm93UWtNN3A5a0FpQTg3T1FETngrSFdHUzlYMHMzajk2SnF1VFVT?=
 =?utf-8?B?d2lFbE93a09HdHBrdkRPSVRnTU05Q0NEcjBWaTVJT01rbW1yWjQzbDVqK294?=
 =?utf-8?B?eGhBaHRIM1ZCeFMrak13eUF0NGZXK2dwOVZrTUxWVUtnNnJZSEdlYnViVktV?=
 =?utf-8?B?V0lsWUttWXByNGpkTHlnbmJQR3cyV2NPRVlLa3FQaFRIMlNFcDN2eEdldjhV?=
 =?utf-8?B?MlZMVmdnZEdGTVY5ZVlFL0dpaVF1cWxpSmlWc0xyZTdjbHQxZWFxblZBd1Zm?=
 =?utf-8?B?SzdrSkJNcEFJSHdEZU8wd0JjT2l4aTRBeWlIR29TeGlqUjNTRVNWK0FxZGxi?=
 =?utf-8?B?MUN0eGlMcnVnTWJ6eTFLeDZNd2VVdklnelZqWE4vSUpnV0tFbnJmZm9uVUpM?=
 =?utf-8?B?MUVBVzJHZ2RJdDJpRTd6Y0QrOUZmOGEvekpWVzFQTHRKdXYwSHkzaHRKTDF4?=
 =?utf-8?B?RUo1UUtPOS9BRjRFN2QrSGh6QkFWVGppMGZNYlRTRmRSalJtbElBWGMwQ3pU?=
 =?utf-8?B?WXF1Qk51QkNMcndFMytLRnJLNy90Vmk3SzBMeVZ3TmRaWHpmeCswSHp3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VzZpZWs2N3ZIb3ZJZ3pPRUQwbEZIdDQ0eEFybGdUYmtYVkVHOGJIYjhITmhu?=
 =?utf-8?B?QmREMXhQUzN1Z2VmM08yUE1ZL3I0cUs0S2E2NTQ2clpPMDJlMi9iak1ENng0?=
 =?utf-8?B?NVlTZko3em5JV1JuVlRRK2UvZk96dk9KdjNNVW5hU2R2NllqdnZGN2VYVzk2?=
 =?utf-8?B?N05lM2toR0pmU3ltdDk2M1Z1LzhKenpFZ3Z3d3o0ZE9HTmpJbXVRT0tKK0tB?=
 =?utf-8?B?SWdPQVVYaldpanBnTjd1K1VjU3A0L0Q1SE9MMjRZdms1bTcxUDk1aFZLZXVF?=
 =?utf-8?B?UWNjdG01NW4xR2pUalZJUEN4cTgrUXVDMXZ1QzJaMkJ2YmpGRzZMdDh0aFly?=
 =?utf-8?B?NkNRN3lXajArams5djNzakRPeHlPcEZtbEExcDdpT3QraFd2WjM4dDJlSjQ0?=
 =?utf-8?B?eHR0WHNOeHo2aWdkMlhwRWdGZHBiMmtRWVRQaElKK3Q2RVFSVEI5aTFHK0FL?=
 =?utf-8?B?ZnBhdWtMR1AvVXFjdDZZMHVYMFlucm5pN0ZaMkZ4RkFSaVVnVit0UGREKzk0?=
 =?utf-8?B?OUwraUZMR2VaQTBmMDd4eXJxdTN1RlBGa0o2UmRRdnFrdzNqdFBnN0FVdUQ5?=
 =?utf-8?B?SlFNeVpLejVvSU8yZk1UNll3Z3ZRRVgrczVTR0Q5SjVYRTRqcEdlWUZMTGJR?=
 =?utf-8?B?clZzUFJ6bGtLZUgwWGwwekx2QVQxVDFFeWV1QUxZakxOOFJBbkhLdVdJRlZI?=
 =?utf-8?B?bE1NQ3BnQXhLWS83aWpjb051UjdNcCtDLzhuajRZYUg3ZlRadkwvUER0aEQ3?=
 =?utf-8?B?Q2JYUXJTcXBvTTlud2pUemlRL0lUcU1zdU9wZExEYndQWkFCQmVXblVhdGpE?=
 =?utf-8?B?NTBwaG9MelNMNE9NK3lRWHZWTmJ3TEUzQWppd3BQR3VpaHpaZ0ExR0NabjdZ?=
 =?utf-8?B?THpnTjN2ZUNaZkk4UzlvTHg0REx6M0lkUEZSdEtLV3NENFpML1lXd3lhSlA3?=
 =?utf-8?B?UzFaS21PczNCWDY4V3phc2RTZ1F0eFFieGk0MGIvRHVWN0pDVXdMa2k3Y0Vt?=
 =?utf-8?B?ZHNJR05mMDdHR1RQQjJUbEF1MUd4THJsNHdCWk9CbHAxV2RDc0tPUDJYRmdv?=
 =?utf-8?B?L3d5cUI5ZUtuT1Vtei9mZlNWcHBkQU5CSWhNMlVLRUJnZW1KRTlEN3hUTEs1?=
 =?utf-8?B?Q3VQL2FEem5kSnJqS1Q5WGNIcStHZmJramFOazRHLzh3NWJJUG9Vc1FRTWhH?=
 =?utf-8?B?OWJJMFJWVXRDTVI2V1RFWUxvWHV3VER1VnpSZW5hdHk5Ulh5Umw3UE1sRklu?=
 =?utf-8?B?ZFVZaWY2WUcxbjRCTnllZUt4Y3A5UGNSSWRuVzZ2Nk92UjUzaCtNQWtnTHVQ?=
 =?utf-8?B?L1NmWEFaa3BoOU1BcmZURkRqMFBxRDluQjU3eG9wZ1JSNHpac3ZOazZtTkUx?=
 =?utf-8?B?bndRS0twVVpQK2R2N0dEV0RtL3puYWxNTHBEOUV0OEx0V3p2RHU3NTl4OGlC?=
 =?utf-8?B?NjZQWG9NU1YzOHNsNVJwMXVYT2UyWmNIc0p1WVI1aElXem9oLzkzemZ1VHZB?=
 =?utf-8?B?RHlKdG93WkNXNWQyNVZWSkhQMlFXSHBuNW5zRVRtUHY5WXBBSFVMRXlhVmhq?=
 =?utf-8?B?Z1hGc2wyYSswSEFod0czNktmTWdqNkNOUjc3cUk1QWJlc2RrV0pna0VzY2VB?=
 =?utf-8?B?UnMzUjRRZndNZy9SN1ltRlo0RU5ITDkycjVhd0JUZFE2bnFVWTF0N1RkazBK?=
 =?utf-8?B?dllnM09kckVwQ1poeU5oaytZSTR3V2E4MGF1dkhXbWhsK3NCREJTWm5rSC9X?=
 =?utf-8?B?OHdvRkp4RXkyOGFKa3lwZWQvcHdkaVVaNzRtdmdURTdnVXkwQVJVdkgzRW9v?=
 =?utf-8?B?V1d4VGplM09wZks3bHQvOXl6Vm1hUWd3cTk5SmljREExbVBuZmNrd3U5OEFK?=
 =?utf-8?B?R3V3V2FCOXZrS0VnVTVMWm9PYXo1ZmlWVGQ4VXZkWHBRbVdIZHByL2tRS25F?=
 =?utf-8?B?ZGxjWXhoS1NTczk2UDdIOEhGcTIzS0RFSEc0QkliVjltQVZtcWFVWkRjaWdj?=
 =?utf-8?B?K05aVzhOY1FPTzFxTUFSZDhNdEx5V2hTdzdkUGR3SzA0OVQvbUdVNURBd2lC?=
 =?utf-8?B?MzN1U2YxZXVMNEFqTkwwY0VHWGtHTmtWY1JkRnpTMm1TVnBIRXRjZEtuTGwr?=
 =?utf-8?B?NkU4UUtBTmdWM05BaUdabjY0SXBrekRkNGJuaXhXQ1c0c0Zwc3JrS3FVQmhi?=
 =?utf-8?B?eUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 88ee82a5-e36b-4257-8731-08dc79c5a21e
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2024 18:41:31.7001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wYIw724p4ah8Ki+za/rvg0YpVgMXqFKFKrDmhMpK6nFnju9cGKeTEaWU/ZDnrNOsXYasmfIOMS6UCB2ELpHE+vQhSzhgJNcBc3Cp4aZ/bLM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4953
X-OriginatorOrg: intel.com

Dongsheng Yang wrote:
> 在 2024/5/9 星期四 下午 8:21, Jonathan Cameron 写道:
[..]
> >> If we check and find that the "No clean writeback" bit in both CSDS and
> >> DVSEC is set, can we then assume that software cache-coherency is
> >> feasible, as outlined below:
> >>
> >> (1) Both the writer and reader ensure cache flushes. Since there are no
> >> clean writebacks, there will be no background data writes.
> >>
> >> (2) The writer writes data to shared memory and then executes a cache
> >> flush. If we trust the "No clean writeback" bit, we can assume that the
> >> data in shared memory is coherent.
> >>
> >> (3) Before reading the data, the reader performs cache invalidation.
> >> Since there are no clean writebacks, this invalidation operation will
> >> not destroy the data written by the writer. Therefore, the data read by
> >> the reader should be the data written by the writer, and since the
> >> writer's cache is clean, it will not write data to shared memory during
> >> the reader's reading process. Additionally, data integrity can be ensured.

What guarantees this property? How does the reader know that its local
cache invalidation is sufficient for reading data that has only reached
global visibility on the remote peer? As far as I can see, there is
nothing that guarantees that local global visibility translates to
remote visibility. In fact, the GPF feature is counter-evidence of the
fact that writes can be pending in buffers that are only flushed on a
GPF event.

I remain skeptical that a software managed inter-host cache-coherency
scheme can be made reliable with current CXL defined mechanisms.
