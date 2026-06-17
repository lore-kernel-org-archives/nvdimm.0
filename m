Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7FEA1A0712
	for <nvdimm@lists.linux.dev>; Wed, 17 Jun 2026 07:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781680231; cv=fail; b=pV9KE2Ro6G01akrpPGiwlIeqQ/XODjbi2RZ6shaWgmcJzdJ16jf9fZtGDtf9D6rJ/QqLBJKQ/CY/j5O248AOUJpFGKZpGIODeeVru+NzIX3Q5llbBvgjI7IHnouWoL9B+HIy3sQOlm6GqH9Bvk68zOqF0s4FLpQ84wmCgwvnXOM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781680231; c=relaxed/simple;
	bh=v60NDLyap+Rsfe0wsPzbOhULHVbCOkZ6lhiDGjyFVrY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=YmJzc7okYXSOMlEbRuWu4xhtiYrMEGJN8aqip6tos3zCUDzOAQdoQ1Vz7N1HF5PgHdvnrmhyzqUH2UqqudBldJW1srEGhTUOnGKhqaENVMLM7hn6t1r/L40/94WO6CImZJuc5FZ+CkRF0kcjz5J6+D8crEhO92bHktkuZn+JM9Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IRgt2cKH; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IRgt2cKH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781680229; x=1813216229;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=v60NDLyap+Rsfe0wsPzbOhULHVbCOkZ6lhiDGjyFVrY=;
  b=IRgt2cKHFHTG4IrnYP24pC88u8jFUGfXvEhKAEnVV+7Cu3u9uyhyTzn5
   3zh5uaUtimoQPyE4D9ayBA7u7gGZcY34COV8Q5JqUORYHEMzyu62C28vd
   d46IthA2XK5Mkals/y4f5hY2moaE2n/6tqECiIJa5f4uvivsVfnYeMv2v
   gnsNgxo6yebSHGm/EWeWlUhhhsCi3b+8OZwAYSi8WFWacmE3uBa3ya348
   UljyhIedz19CtC1Zpzj35ig97s0e1aIZzko0RRFckvlhWE++ApoHhpk+C
   uuol4Xq9wrjBw50pLmQxcoiXd/X5PKoYubk4HWmlHuKjRb1PNXwA9LlLB
   Q==;
X-CSE-ConnectionGUID: t5Ih/rljSaimOg7Ua9YWTg==
X-CSE-MsgGUID: 0Bon9ik0Smqp3zFEBr2lPg==
X-IronPort-AV: E=McAfee;i="6800,10657,11819"; a="82474776"
X-IronPort-AV: E=Sophos;i="6.24,209,1774335600"; 
   d="scan'208";a="82474776"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2026 00:10:24 -0700
X-CSE-ConnectionGUID: J/EJTEyKQCmNPLmQIXTGEw==
X-CSE-MsgGUID: 9V3gfpxlTLKc2dX/EW4e9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,209,1774335600"; 
   d="scan'208";a="248067921"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2026 00:10:25 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 17 Jun 2026 00:10:24 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 17 Jun 2026 00:10:24 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.35) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 17 Jun 2026 00:10:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sRduJDCmck+hK/mI4CyWMNd0Raj1HnEpvNy/6H7mUh1U6l6rxLORwPmKcZN/DDP75O3gQkqfNOoIsOtxxsUAOZbq1WiaEz+EufK1UlfLobaJq7/+4Gad9KOb2q69uvf3c5BprGFGP+yKKbOc+UW+HGqSKLwbmBwVKOD72AM7NHTFG6upuDJW2Thi7ksLLgn5DbcY2rbVVCa+BYDoR23V92Js2O4TnsIIeYBRfmqTjyiBFJNuJeGNbWleTDXY1W1mBCzaIjDz1YzkHb+pI0TUsJVDiR1x8uOqHc5LJ0OHqJNAHSOKJNdR8dN8zFHqL3qt8NZMMz40pzy+2iZ8jBYLYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ggDOZTBpD3/rHtLisb73lFgf8LFHyds5MOsFhTUL2rk=;
 b=B6YCka9zMoQCmqr6NpaDVH8eEuH2TGKkIcK9ay4RcK48VF7Njr+wJ3HC+RyzoqwrPFWe8cwYndY7S0F1z5kkcVg95wlHpFnu1014Ng6DhfIk3GOAaNXkdr7gwaeva8wqCni1SPqLYeqREQoM6dbiSvlQQiomTatwUjBpph8r/45BPuiFCGMq2fY2P48W5i9bQjInUZOEUU6I0kOL1YUp6QAnMzWzlSYitTkpo2odY399IYV06jzZGcU2etMJmRwOZIefW395yOsWHjepLOXap4AyU/XEeLwhaI+Lu6u7I3iT2nkr0IIR6Q6RL/lShaEfCKOa1qhl9SyzllQds7Ayqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by IA4PR11MB9279.namprd11.prod.outlook.com (2603:10b6:208:561::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.18; Wed, 17 Jun
 2026 07:10:16 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%4]) with mapi id 15.21.0139.009; Wed, 17 Jun 2026
 07:10:16 +0000
Date: Wed, 17 Jun 2026 00:10:07 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Anisa Su <anisa.su887@gmail.com>
CC: <linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, Dan Williams <djbw@kernel.org>, Jonathan Cameron
	<jic23@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>, Dave Jiang
	<dave.jiang@intel.com>, Ira Weiny <iweiny@kernel.org>, John Groves
	<John@groves.net>, Gregory Price <gourry@gourry.net>, Anisa Su
	<anisa.su@samsung.com>
Subject: Re: [PATCH v6 0/7] ndctl: Dynamic Capacity additions for cxl-cli
Message-ID: <ajJITxBewsUuQGzp@aschofie-mobl2.lan>
References: <20260523095043.471098-1-anisa.su@samsung.com>
 <aiJh7vcs2u1fMDX4@aschofie-mobl2.lan>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aiJh7vcs2u1fMDX4@aschofie-mobl2.lan>
X-ClientProxiedBy: SJ0PR13CA0028.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::33) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|IA4PR11MB9279:EE_
X-MS-Office365-Filtering-Correlation-Id: bf4e8e03-4832-4ca6-9562-08decc3f7b9b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024|23010399003|6133799003|56012099006|3023799007|5023799004|4143699003|11063799006|13003099007|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: UZ80/HxZ6Sd7n9o9D4Wbr+kzGXl8xL9E8i2wXj1yDSZGeFP7D5RzrOZo8m0yFknE4/76Q5cnLNBUCdBvUGGKG2XsB/GETW9Biro0Jy18nmxoaC1xujyQ6P/drygGD6cIU7Kv+WXTstaWrbGvFU618Tl+sqyot2DOGbZwqNYYLIq0M5+M+AKtkfRi+T60Ip5zjhIAWJjDV/p3SsT2hdMYOc37ercUEbQPhqXdhrQ8Cq1LamfxBqmkR/Vd+xAzVx+tGzwcXZeTCuqs7s/qUvB9kPoqnl3ga5tECa817zX66hi1N9Cokc93gFO2mqWcGuM68AS5NfwDsupdotYGiGi8yEWPnskCF4+FIpeT6XfbuD5hawyY9za5zn7Ff0gl4M7Tk6h4p2CtiA9g9TFJ6ahTv2KaI+MuikdKn30ww32w+szVvjHSnV4bXQ60XAOYCANgvOzg4hUYk6V2RP2Mjrd4PwJ2XaiBiuIfiYvK1Xs5a56phl0rzQSFaMU46RntlnknHfZ3PSQsKvP2TXVZ9ZmYGJlDa7amlKZ61y+6/GgtIvZ5vxZl9SVdk3OrXZIyllymatcFRzpzzlYBi1CMCnzhlCQ1e0kXhqL1/+Z4ExnLdbvFjWlj9qnj+66psyustvgS8yR884CRC0K7SnbA0klZNA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(23010399003)(6133799003)(56012099006)(3023799007)(5023799004)(4143699003)(11063799006)(13003099007)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NG5JK2lUTXM1VTl2ZUFyT1B6VGVpc05tMFFQdmRza291N0FGWk9nT3ArK0hU?=
 =?utf-8?B?WHdnK2pmZWIveVRlTlhsOElPYm5UOE00bEcwemZWZ2hKd0hxaW5jbmVDQWhr?=
 =?utf-8?B?WHkwakRUd3p5SG1mZGRId1p4UWFxMFJBbGFOMU1JNElIV3p0YTlpL0lya2c1?=
 =?utf-8?B?eWVudjhSTXJFL2Y1cGlUSDJuQUptUzlPdUJmMW9rOFBGdjZXSjNRTjF4SUhZ?=
 =?utf-8?B?QzJXNW9EaEY0Y1M2a3prZDAvcEVLZGhnVE04VUtYV05PODlCbzZ0QXIva1Z6?=
 =?utf-8?B?WjNDbzg3ZzA0TXUyd3BrSVBmOElGNXg1bVBlSUtKTTNvakJBSHZYVGN4Q3pJ?=
 =?utf-8?B?S0N0c1VZTGx5bXFOdUZKTDFqQWgwRDROc2piQlNucHFCVUEvbDNiTi94NXdE?=
 =?utf-8?B?U0lNd2g0VWZsbTFBMTZTdnYxWXFpd3l5cVZYU1FyaGZTSTNlRzVUUm52b3pM?=
 =?utf-8?B?Wjd2MmRyL0VEZWN6OHo5UEVxVE0vbHJvVWtldFhGdzAyRTVHOWw3dTdJWVZX?=
 =?utf-8?B?cXFCZlFnNXZyOThwQ05QY0wrVFMya1RZbFJrUmxBekFoUjUxcHhKUVhmOEpE?=
 =?utf-8?B?RmYwamJEZ2RJWFJwNmsvTThYaHdRWFRjcThwYVFjQk1XSkxxWnJBN0tHV2FR?=
 =?utf-8?B?ckNGNXFHVUgvQmNTUkVqRCtxbE8xSUZOVDhyR0JCa3llUDN5bldjNW50aktR?=
 =?utf-8?B?aGZWTXRWazlXUGM4OGlFUWl2akQrM1FMYzJvaHJjaWR3OVF6QzhWdzhXa29F?=
 =?utf-8?B?R0twR1BwVlFlNGx4Q2pRbnhqZk1CWnlJQ0plVU5wUXRDS1J5ZlV5cFh3eHZk?=
 =?utf-8?B?RklkbDFtQ0V0cThnT0VzQVp2cXZiSTBKbUI2WHc5ajJQUlhYWGFkL0d5YVl6?=
 =?utf-8?B?bTN2OVhETWdOT0FudER1T0xsMTgzdjJsSHl3akc5RUdrUDdFVE02TlZQRkE0?=
 =?utf-8?B?em0vTHBXdGhCczAwaWpEZ2hweUVRWVNoUXFlcGo5WVdFVlpPMHRscmlzZ3dh?=
 =?utf-8?B?R25JNk5YVDJWSlJxQVNOeTlPc0JaQllwMjJiMVRqUUJyelArSlVRSGJsYnA2?=
 =?utf-8?B?R2hzdlIxdW1JNlpWUHhWcWJLNnovelo3MzkzMk03V1VGUlJjbjM1c3Qwazlq?=
 =?utf-8?B?QmNwODFYUWVYMC9jSWxMWjJESHAxNEdyd1ZKOXdiRjF4bEJDZEFER0dGNHhk?=
 =?utf-8?B?bjNjbk8wTXN5SGFTYURuMVlEMU9idHoyZzg5VXkrVm9qYkp3K3NtdlFncDRI?=
 =?utf-8?B?b3dYWnF0aGtKSVFUOWlvc2FVSWErZTZqM2pOcjNMYzVBZXh5b3R0U0tWaWtL?=
 =?utf-8?B?MnZ3TUR3ckVkWEdUVk1SaGZkVm1vM09DQlQ2M0NibStRS1RvcFh5UWV3YWFX?=
 =?utf-8?B?dmhYL2FqU0MzbFZGYnNDbDhEKzBuN0dvQktQRTNWZjByaStoVEthRTFrRE5j?=
 =?utf-8?B?c3gwbXRwL1JpVVpRMjFJL05yUUZNanlMYk8xNkdZcWg1UjJVaGIzTmlCcjNW?=
 =?utf-8?B?dkYwWTZyRFFsZ2hyVHV6R2NJMlNZMUN2OFJlRzcyV0YyQ2xnaUpGazJEbGRi?=
 =?utf-8?B?QWMwcVhIUmtSZFRNUVl2SDNYVkh1SVNjbFlocGlZaXVDZGVQUDVrZG1KYmhI?=
 =?utf-8?B?UUhrRldWcFEwMFJjaXVMWFVDV0UvZHVlU3l6bEpCeDk0blJOaG5pM1BqMEJ6?=
 =?utf-8?B?WUMrSWwwa2ZiRFlKR3M2VTNHeGprdyswK1JJdmFPUmM3NEdkdjYwdGs2eXc0?=
 =?utf-8?B?TiswdjkvZE0wU3phWGJ0emw2SEx0TWtCd3dVYnhucGhhcnNza2J4dWwxcG9n?=
 =?utf-8?B?MVVwL1VuQUNaWW80TmtSSmlOd0p1Y1NvVnlEdmhoWHJ6MGFCZnV4Z1g5MnRl?=
 =?utf-8?B?QmY1aHpGaUlRMjVWbE5WMVBmV21VSXc0UmFhQXFFa2lmdGtBT0kraFpPWFF1?=
 =?utf-8?B?dld3RSs1ekE5UEtYeXVQUGFQMVBqWFB5OTJiTWVZNVhBRGJGTlhSbkVRUzVp?=
 =?utf-8?B?cktlZFJGMG52akMwVGE1NHl2N0V4dmtzMEV4V2V5Z0wveVlXTTc5dFVZVCth?=
 =?utf-8?B?QlNWTUhmWWk4TGN1MzhpbVliWGtBWEZ5L09CWG9DT2N4K0pYamQzNnlRd0NU?=
 =?utf-8?B?NlRkYkxGSUlDd0lTU3ZkQ29MMElZYkdVM2xyUE5PU1dGb2YwbFpQV0RuL21B?=
 =?utf-8?B?TDgwQXpwWVRLN3UzOFFBL2Jxc1QxRjZJZytwVkgrNHJMMk5BM1hUZ2NHK09i?=
 =?utf-8?B?QklUbXpmQTRlL3lXcWEzSm5yb1pkQ1JMRGVZYlZ0K0dtRUdqSEEvVE5pazJw?=
 =?utf-8?B?NU5scmhLV1Z2SWJTOFYybXViVXR0ZEJPY2M2WjZPMm5rbWNIWWJhRnowdi90?=
 =?utf-8?Q?wtIFmkzF/Lsn4ijQ=3D?=
X-Exchange-RoutingPolicyChecked: jsWKVOEM12tELvYK+VOJ9YFxkl1pnFpKRm6yUjl4Lf9ceY8nBeq7CJmcHU1eOtVXIW3mPizyy6N6Xx5WM173lPj6VTxDyG6zhdeAHtU33TduDXPWcl7px5AvXjq26/S06Y7Pkc7HP5G8uCKONrshZhqp6i0VZlk+l8ryMSR6cNMpWi+FWsqdPnzf4Jml+/S/ba9Ju0AQvInpZ24bJtdi8b6PZ72uXoM8oPiUmIsI8wmf2uBq5GUREYgl1FyI6r8SiAKUepPZ7P85nbimHA+FQUj9RObMdTt7PovVYsQzcNgb5ULaWOd2naLeEBp4K2B6hn0wQgwcBrxADRc89NbmMg==
X-MS-Exchange-CrossTenant-Network-Message-Id: bf4e8e03-4832-4ca6-9562-08decc3f7b9b
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2026 07:10:16.6372
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: no3XwSDW749ZhSFJHHa0XB4VI3i8e8bCWyXd+oK+vHGCtYE7MfrHsnm0xo2WYkSTQXO9/CwcLenFz0lzdjqSkRgClKCwDTu+VutuyfGq2/M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9279
X-OriginatorOrg: intel.com

On Thu, Jun 04, 2026 at 10:43:10PM -0700, Alison Schofield wrote:
> On Sat, May 23, 2026 at 02:50:35AM -0700, Anisa Su wrote:
> > CXL Dynamic Capacity Device (DCD) support has continued to evolve in the
> > upstream kernel since Ira's v5 posting [1].  The kernel side has settled
> > on a uuid-driven claim model for sparse DAX devices: dax_resources carry
> > the tag delivered with each extent, and userspace selects which ones to
> > claim by writing a UUID to the dax device's sysfs 'uuid' attribute (or
> > "0" to claim a single untagged resource).  Size on a sparse region is
> > determined by the claim, not requested up-front.
> > 
> > This series brings cxl-cli and daxctl in line with that model and
> > extends cxl_test to exercise the new paths end-to-end.
> 
> Hi Anisa,
> 
> I just now picked this up with the kernel side and took it for a quick
> test drive. Based on what's been touched, first meaningful finding is
> all the DAX unit tests pass, and then for CXL unit tests, all but these
> 2 pass: cxl-security.sh and cxl-dcd.sh
> 
> Please let me know if there are known problems with either of those
> before I explore further.

Hi Anisa,

Good news, DCD exposed a long hidden bug that made cxl-security.sh
fail. It is not an issue w DCD patches.

Found that DCD set changes which mock memdev the test happens to
land on, and that's enough to uncover a latent hex/decimal bug in
CXL nvdimm code. We use to always land on id '1', but now this patch:

tools/testing/cxl: Add DC Regions to mock mem data

reorders the sorted dimm list, so the test selects a dimm with
serial 10 (0xa), and there's the hex/decimal mismatch.

The renumbering is harmless in itself but it just changed the
serial the test exercises and tripped over the old bug.

I'll send a separate fixup patch for the hex/dec cleanup.

(No answer on cxl-dcd.sh yet)

-- Alison

> 
> Question below about dependency....
> 
> > 
> > The corresponding kernel patchset is here:
> > https://lore.kernel.org/linux-cxl/cover.1779528761.git.anisa.su@samsung.com/T/#t
> > 
> > Picked up unchanged from v5 (Ira):
> > 
> >   libcxl: Add Dynamic RAM A partition mode support
> >   cxl/region: Add cxl-cli support for dynamic RAM A
> >   libcxl: Add extent functionality to DC regions
> >   cxl/region: Add extent output to region query
> > 
> > New in v6:
> > 
> >   daxctl: Add --uuid option to create-device for DC DAX regions
> >     - Plumbs writes to the new dax 'uuid' sysfs attribute through a new
> >       daxctl_dev_set_uuid() helper (LIBDAXCTL_11).
> >     - --uuid is mutually exclusive with --size; pass "0" to claim a
> >       single untagged dax_resource.  An unmatched UUID surfaces ENOENT
> >       from the kernel and leaves the device at size 0.
> >     - Documents the option in the man page.
> > 
> >   cxl/test: Add Dynamic Capacity tests (rewritten on top of Ira's
> >   original patch to track the post-redesign kernel)
> >     - Routes untagged claims via --uuid "0" so daxctl exercises the
> >       kernel uuid_store path; tagged claims use real UUID strings.
> >     - Asserts that for DC regions, size-grow returns -EOPNOTSUPP (real grow is
> >       --uuid only) and that tag reuse across More-chains is rejected
> >       by the cross-More uniqueness gate.
> >     - Adds coverage for the new validators: test_uuid_no_match,
> >       test_uuid_no_match_seed_intact, test_uuid_show,
> >       test_cross_more_uniqueness, test_alignment_rejection.
> >     - Sharable-partition coverage (test_shared_extent_inject,
> >       test_seq_integrity_gap) is routed at runtime to a dedicated mock
> >       memdev that tools/testing/cxl stamps with serial 0xDCDC, so a
> >       single cxl_test module load exercises both regimes.
> >     - Localizes positional-arg assignments in every helper so functions
> >       no longer clobber caller globals (the previous behavior leaked
> >       the sharable memdev into later tests).
> >     - test_reject_overlapping arithmetic now lands an actual overlap
> >       inside the DC region (the prior math landed past the end).
> > 
> > Depends on the kernel DCD/sparse-DAX series; without it the new tests
> > will skip and 'cxl list -r N -Nu' will simply report no extents.
> 
> What is this dependency- DCD/sparse-DAX series ?
> 
> > 
> > The branch is also available at:
> > 
> >   https://github.com/anisa-su993/anisa-ndctl/tree/dcd-2026-05-21
> > 
> > Based on pmem/pending commit:
> > 
> >   bbd403a test/cxl-sanitize: avoid sanitize submit/wait race
> > 
> > [1] https://lore.kernel.org/nvdimm/20250413-dcd-region2-v5-0-fbd753a2e0e8@intel.com/
> > 
> > ---
> > Changes in v6:
> > - anisa: New patch — daxctl --uuid option + daxctl_dev_set_uuid() helper
> > - anisa: Rewrite cxl/test DCD tests against the post-redesign kernel
> >          (uuid sysfs claim, tag-group atomic release, cross-More
> >          uniqueness, alignment rejection, DC size-grow refusal)
> > - anisa: Rebase onto bbd403a (pmem/pending)
> > - Link to v5: https://lore.kernel.org/nvdimm/20250413-dcd-region2-v5-0-fbd753a2e0e8@intel.com/
> > 
> > Changes in v5:
> > - iweiny: Adjust all code to view only the dynamic RAM A partition
> > - Alison: s/tag/uuid/ in region query extent output
> > - Link to v4: https://patch.msgid.link/20241214-dcd-region2-v4-0-36550a97f8e2@intel.com
> > 
> > Anisa Su (1):
> >   daxctl: Add --uuid option to create-device for DC regions
> > 
> > Ira Weiny (6):
> >   ndctl: Dynamic Capacity additions for cxl-cli
> >   libcxl: Add Dynamic RAM A partition mode support
> >   cxl/region: Add cxl-cli support for dynamic RAM A
> >   libcxl: Add extent functionality to DC regions
> >   cxl/region: Add extent output to region query
> >   cxl/test: Add Dynamic Capacity tests
> > 
> >  Documentation/cxl/cxl-list.txt                |   29 +
> >  Documentation/cxl/lib/libcxl.txt              |   33 +-
> >  Documentation/daxctl/daxctl-create-device.txt |   12 +
> >  cxl/filter.h                                  |    3 +
> >  cxl/json.c                                    |   67 +
> >  cxl/json.h                                    |    3 +
> >  cxl/lib/libcxl.c                              |  181 +++
> >  cxl/lib/libcxl.sym                            |    9 +
> >  cxl/lib/private.h                             |   14 +
> >  cxl/libcxl.h                                  |   21 +-
> >  cxl/list.c                                    |    3 +
> >  cxl/memdev.c                                  |    4 +-
> >  cxl/region.c                                  |   27 +-
> >  daxctl/device.c                               |   72 +-
> >  daxctl/lib/libdaxctl.c                        |   44 +
> >  daxctl/lib/libdaxctl.sym                      |    5 +
> >  daxctl/libdaxctl.h                            |    1 +
> >  test/cxl-dcd.sh                               | 1267 +++++++++++++++++
> >  test/meson.build                              |    2 +
> >  util/json.h                                   |    1 +
> >  20 files changed, 1771 insertions(+), 27 deletions(-)
> >  create mode 100644 test/cxl-dcd.sh
> > 
> > 
> > base-commit: bbd403a03fa2a1551c1a10bbf78f32027c718758
> > -- 
> > 2.43.0
> > 
> 
