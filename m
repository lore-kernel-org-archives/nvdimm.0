Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1FB1531DA;
	Wed, 21 Aug 2024 20:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724272672; cv=fail; b=ZWmhAHvfROxb6RPjx3AHajzCDJGT38niPW2AJO3/80IMAzUFoduV2Kbz80yNCpNQ2Ke3nfD0XssiE4cgHLQ6vByiDgOvg+TqeTvud+dsjY0KY0pptYK75okIJNUiR45Jq++p81ZXLLpl62poS/Cyl/Grbb3IDgsXo6cuq445MQU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724272672; c=relaxed/simple;
	bh=z0/f+qxgC1LtxSap++ZjXMb0q30jVk+yjL1S6WYZKco=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Vj3iGu6mdikVijCGiUivHCbB5c0e3/CKJNguHAtQnDZNxd/Xvw9hVF1m+DpuoWpZQ9xglz2fU5onLM1YE7j5M2QgUlPmnNLJn70lsZghHdc991c9J/RpruuTeNks8/499PqEwofq8k4RbT4sRe+6UnIfahQfJD6V7LWuIMNR3h0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fJR06Qd7; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fJR06Qd7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724272670; x=1755808670;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=z0/f+qxgC1LtxSap++ZjXMb0q30jVk+yjL1S6WYZKco=;
  b=fJR06Qd7fMjOtHhVGWVt4ilkkU1G35KH7UOfujudF3hZRXdYZ+D+UwyH
   6XX7hmJDZAQKmM7rnv4BqglgQDDfGoL79jUDn+KfC6npNEsko/DBG7bbK
   oTYOlAvN/x1NfcKVcZWInluKqR3RzFB5kP0GXXwHptqeXbrTI4BOC8vt4
   PLxlech87i7Aa5p8bC1Frx2I9FSLxjBQWpdQZbCCxpD+VbYQG/UKAks+z
   0R4IPDpy/NdLB16KtH0kIRTccIbIERcH2SZNM4XvMLIMOV2TBPVpRyWsr
   BjraH4SS/7lvmRp6MCFRIoOYRVQ6PIXdPjwliFWe3q26vHGipX0j1WffH
   A==;
X-CSE-ConnectionGUID: Q8qUqvdqRuaulUSAZZMrJA==
X-CSE-MsgGUID: q+Vi1ufFQWmB60gvSvZEkw==
X-IronPort-AV: E=McAfee;i="6700,10204,11171"; a="22527688"
X-IronPort-AV: E=Sophos;i="6.10,165,1719903600"; 
   d="scan'208";a="22527688"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2024 13:37:48 -0700
X-CSE-ConnectionGUID: G48Ji0c7TRiWUNEf8Z3fDQ==
X-CSE-MsgGUID: XbaHF4XURpK4rDBjfIXGAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,165,1719903600"; 
   d="scan'208";a="61206966"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Aug 2024 13:37:49 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 21 Aug 2024 13:37:47 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 21 Aug 2024 13:37:47 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.46) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 21 Aug 2024 13:37:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xA4oJRCrmh8YA84SolU+A74aOfUnRtXu5dz3dVoBHTNX9vgZ3ar6pCQZWyN1ctR/1IYn9WTLc1yhVxs0XbMrM9WdREwCqOY6kG//5m04uJO3KWdqIMyINDXscvq3oMpgY9YeWGrJQkhkJUbRjvFTxDLcoNP4qVIqD+qulalY3nimf1BctxmCqUnKvlR+gSK2/ajoGofUsrKfP0Yd21nXTBIVryY9hJ6YL7wyPzVW05cQikyaCmomQahuUYC+fNxtsEXYLw8Q3kITMoW1pCoLsMxEbAxbGDkaYAYPFiDcGYuMTjALk1EpM5SJNkLmYRyYDWBdnWVJPOo6uZXZIutdzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4iTkhDMRL4g7P+SGZlF7sVoOUDqQJZyT/LGwF2PuvxQ=;
 b=NSm0032MyILd8eJe/ljA2cmYbANKVplxKeb8QQHh9iwMCzRMkZAp8lonnrIMxSCDHV+dUcwE9l+HvHV2c2Lxz+MbhtQPhGAGYN+T49F9TJehxh54tspcT2ssSQW2goS5tZaQ4p9akcYOLKUDWomEK+XRPxDjKAujO+FRp/utVCT5bJb5q8BNw5/PwqEEuGY54HakMH8kZYe90L0LJ8gdRlPZlzhERfvric8JpdARpBopxZgIrzTmtP01ePljkkidYwIcQGLzc89FNbBd7zi1vxoPcarf7R7YnFuyctKmQDhiAzlDbsslZ1V2DntDJSy4ENe8kWG9GClE8QCP6Wcs6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by MW4PR11MB7054.namprd11.prod.outlook.com (2603:10b6:303:219::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.18; Wed, 21 Aug
 2024 20:37:45 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%6]) with mapi id 15.20.7897.014; Wed, 21 Aug 2024
 20:37:45 +0000
Date: Wed, 21 Aug 2024 15:37:41 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Philip Chen <philipchen@chromium.org>, Dave Jiang <dave.jiang@intel.com>
CC: Pankaj Gupta <pankaj.gupta.linux@gmail.com>, Dan Williams
	<dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, "Ira
 Weiny" <ira.weiny@intel.com>, <virtualization@lists.linux.dev>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] virtio_pmem: Check device status before requesting
 flush
Message-ID: <66c6501536e2e_1719d294b1@iweiny-mobl.notmuch>
References: <20240820172256.903251-1-philipchen@chromium.org>
 <46eacc01-7b23-4f83-af3c-8c5897e44c90@intel.com>
 <CA+cxXhnrg8vipY37siXRudRiwLKFuyJXizH9EUczFFnB6iwQAg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+cxXhnrg8vipY37siXRudRiwLKFuyJXizH9EUczFFnB6iwQAg@mail.gmail.com>
X-ClientProxiedBy: MW4P222CA0021.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::26) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|MW4PR11MB7054:EE_
X-MS-Office365-Filtering-Correlation-Id: c9d378a7-d686-41d6-7ce8-08dcc2211c7b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZnJIZC85aTlNYVEzOW0yTnFnSWNtTlM4ZW9HZ0hleHB4Q25hTDVFNGoxTFpy?=
 =?utf-8?B?QkVIZmxiak9XWkNBR3VyS0pROExSSEZSQ2JNUHh1czZ0elBGVzRNUnNPdHAy?=
 =?utf-8?B?N0ozaGJWMlBNWUhENUtHWitsUHpIcXNqdjdCNWdTTHBQeU1jWDRQWVVhNkVJ?=
 =?utf-8?B?ZHN0UERGcGdiTFI1MlpnM0JUQS9HbHpKMEpNYlRHQ0d0OSs2Q2k0WFQ0Qkhi?=
 =?utf-8?B?dVZkNEdHa2xNVTBXTm5lV1c2SThsbkg2aHJEQ0xyaDk4ZXlNOElqcXFmYmtO?=
 =?utf-8?B?Q3Y3dEJWeGFmSUVWYnFDSkZDWHNnMWsyanZIWVpOTjZJZ3dqTW5LcGNqbUU0?=
 =?utf-8?B?aE4vbUFuSHJPcnN1NnVBM3draUw0TW9vOWZsbUVkQ0FVcndCWk5ad1BsR0Nv?=
 =?utf-8?B?T1M4cW5aU1JIZ1FVNWxtcWJ3ZnhBN0ljQlhiUlBMRkR0N2xoNzRMWU4yeHBz?=
 =?utf-8?B?bXlab1JDRzdCZkJKQjZnQkN4cGZiUjBKVnJud1k3cG9TSFlLR2lPV2xNZ05j?=
 =?utf-8?B?OVB6ZnVyalM3QUp5UDFDSWNqWW9kNTR2d2xNOGZkU0J5VUJhTFlLWDRKNFdC?=
 =?utf-8?B?LzJlaUIycm5OZUg0aVNyYWY3SjVBOGVQNmpXZHFmN2Vnc0Q3OTdFQjhmUnht?=
 =?utf-8?B?NnhUMFFsYmxEeXlkaEhmNjYvN012Zm5aYTYyc0dnMytUdzlvWmhLd0VCY1dk?=
 =?utf-8?B?czlCVGtTUXdZd0V5QnIrN3dlT0VHL28yYmVjSEtlM2w0RXNxNlBSMzQvTUhD?=
 =?utf-8?B?RDVwWFhldVJURmJCbUt5TllkM1EzTGFKbHovRFhDL1ZlcWFlcXRlZm4wVmFi?=
 =?utf-8?B?amRrUnJQeFVSUzF4UDF0LzN2NGZxenUzOEVrL0E1djhicTZ1L2M4Q2Q1NjZr?=
 =?utf-8?B?ckRJK3hTMHh3MGZ3aTRlRGY3SGltTTdzLzFvaWdPd1dVeGRjVkR5T3VPQVhi?=
 =?utf-8?B?eFlsVmZNQ21GdFc4N3N1emY5Z3l3TmNTY2tHcDJoREliVnNRYmQ5bksyT3Jo?=
 =?utf-8?B?d2NPRnA0WjdjcElVUlJFaEtHbC9aMVYrTnY3VDk4MEdpL2t5T1hwRFRLM3pa?=
 =?utf-8?B?c21rOWh6UEpPcENSSXVFdFlkU1hpOVMxK1A3ayt5K2hwa3VaVzZhLzd0U1dx?=
 =?utf-8?B?WDNnM0EvL0FDeFRqcFl0cncxWCtWL1pBeFlJQUYySGxDQkE5aTJucmtWWjZr?=
 =?utf-8?B?SllIeTN4YVQ2TVdsTnpZVTVjK21mdnBwZDB1TGN0UHBIR2hEVHIzUFJ1OVlY?=
 =?utf-8?B?bzIxekFKdGxpVDk5QkJHT1huZUhHUlVCUDFCNXk2R2ZtWGFjZ3JYVmtqS2xs?=
 =?utf-8?B?ZVRyeVdQVEhCaFNYNzdScmhBODRvN1M4N1lIY1Y5MmduNXZyMlo4bEU5TE83?=
 =?utf-8?B?TjZ1enpKMzZPSk5RZ1VDS05ZSUZDenlEUlhTc3N2TkZYR0srQ3JqL0c0MS9U?=
 =?utf-8?B?Q01KS045clVVWlR0TFpaemVKd1RHQWlJNlRpMURQVFF5OUhEeWNXVUVKV2JY?=
 =?utf-8?B?ZkI2NFlqWDRIODZ3d29pUXcwbTVna0QxK0RZMjI4U2wwQ1BTQmFOVE1sd0p0?=
 =?utf-8?B?NjgrQW9ZOHVmMUlQUDgrc29zR2s1dnZONU4vd1dYK2E1WEhPUXZiT1N0NTdz?=
 =?utf-8?B?a0l4NUo0Q29aeUZqY1pvS2d3WDM3bkVtTEJYTGdGdGJoSGFyQWhpYk1HTjRR?=
 =?utf-8?B?S045OVVJc3hML3ZJQzFkSE5yY3ZZbGtJREpBVDRPU3FGQWtmSmdmYWlFWk1F?=
 =?utf-8?B?N28yS0lGSGdlWTZJV2pRRVZ1N3NpNDVQK2JHVTJBYXErakI2UkFlYU5ENW5J?=
 =?utf-8?B?ejNNMWQxeEJtOFE4dUthQT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VS80enpnbEg0TnpsdmdTVENwaFREdXpSR2dkaUJXY1RKOXljZ2FPcldqWVNO?=
 =?utf-8?B?NE9uM2JsRnNLZi9vMm1xTmJhUmFFTDgvMHhma3FxYjUzazhZMGxaMUNyQ1ox?=
 =?utf-8?B?K3BTcHY5aGZZOWFuWFNLQ0RMRy9oQTcwbERXWnRUNWtPYTYrWXVSbFY4Ym9L?=
 =?utf-8?B?clk2S0dxRlNscXNCUU5lRVdyY2xZNmcvQkNTL0piWGVKODdvK1hjYkNnejNL?=
 =?utf-8?B?aFJzTjNzY2RNOGRqZFJUWmllUk45TUZ4ZHFLUmVtWVZ6cjJWdkFKZW9Qajc3?=
 =?utf-8?B?WWZQdVhpK3dDTDRpWEhXbHNmVUdkdjdiQ0Y4NU05UzlBQTJOZ0tERzBMRHBV?=
 =?utf-8?B?YjdYc2hVVWR0RU8wUEEzWjhsdWhidkoyRnp0ektKQWdxS1RvSTlVL0F6ckJT?=
 =?utf-8?B?OFg1T2J5YUVBTUNKcWdhTGRxM0NhZDVCSkV3STdHL3FoUmQ0Z2N0M1dPRS9z?=
 =?utf-8?B?M3EyRVZFOFloYUc5RmFlN1diTTVCek5SQ0hHRjVSWWdDYXRPSjNqUitFSytt?=
 =?utf-8?B?elpqbm5CeitOQW9nZnNiOTZkeXRuMUxxNTNaTWNzNnZNeHlwb3ZIUm55ZlR2?=
 =?utf-8?B?Q2c5L3JKR1JCS0xKZmVIaG1KWnpOdk5mUU52ZG9kM1cwTjAzVjlOOWJuTEdT?=
 =?utf-8?B?bzlRSlpWSDBTZm43YStBcEd0Rm9LYnBseVNsWFloRFdhMmJ6eGUrY1ZUWE84?=
 =?utf-8?B?OFBuNXRSWSs2V01XS1h4b3QwbmgyQ3lObzg2ejhKV3U0VkR5K3BPQVdZK1NK?=
 =?utf-8?B?NklNTWNmRXRtT3dMNy83QThJTnh5SVE0Z21DR01TdkxXcTBpbHhkYUI2a3JN?=
 =?utf-8?B?YjB0V1RkU0VKS0pMWGF2cDN4bm0rdTZ3dmhFK1ZVeVVyNisyMG4yTDhpNG4w?=
 =?utf-8?B?MVo5cUJPbC9oYmJSdXhNa1NBMGxDd2krRkRRVDJVd3R6NG9mRjVkaS9JQlMr?=
 =?utf-8?B?NEMvRlBYN0Rad29SL1ZXelg2TU1zWFZNWXAzZXdlZUJ0Y3YvazFVU1FPQ2xR?=
 =?utf-8?B?K3pnOEtBbmVmQjQxcWRJb1JBWW82Z2hvaGg4cHE2TW1rOG9CdGhEY3FXWVBK?=
 =?utf-8?B?MlJGS0k3RDUvM0xCdS9aSXNwUVczU1FDQWFzVmlJQmRSVHNUaElNTUN6a0xj?=
 =?utf-8?B?bkRKckhXcVhFNjIvTWJsd2FQeHN3RDBiS2pOSTdQcHlqbER6OGFXTGpzRWdM?=
 =?utf-8?B?c2pKbytwMWVPMHNGcW50RVhHbTdyL3pZUGNaaklUdDJrZzVLWExhdTlCamsr?=
 =?utf-8?B?ciszOU1tY1RaSlVlbUllczBXQWNMbUJia0VtTE01TnJGWldiTkJVK01zU1ha?=
 =?utf-8?B?eG5jTENQQkM1Unp6cGErZlhqN2ZmV0VGUGhocHBZQTBDdlNBb0ppbXBFRWNt?=
 =?utf-8?B?SmdhVnJHOXk4c3VrKzZUSWxHemFhRzJGdGV6cDFKcXVTWUR6MGdxczErWFdZ?=
 =?utf-8?B?SXA4ZFVSM2Y5UkV2UU1QQjJaVGltY0U0Ty9DVmJoU0ptZ2lSZFhGSXBIdmFl?=
 =?utf-8?B?MW1Zc2dsY2lWT3lVdnVvYkYvWUtHL3p2Zkt4ekp2RTZBcXQ5a3paR29aT2tu?=
 =?utf-8?B?NGJ3S3kvNVFXQ0hNRG90bWNIZWhhN3BoT0ZXbFNadEs5dEJPcUZRdjRFMWll?=
 =?utf-8?B?eEw3T3VXUWtiSUlhcU51TXdzYnREQmlPdnhzaGRSTjdrNXQ4ZldtcWZHZ05l?=
 =?utf-8?B?aXVQRlVYWVc1RU9aSDhLMnhrYTJzbGZNbDFhMS8zRXBqaGdzdmdsWFZYdERZ?=
 =?utf-8?B?WVlPZXUweDhRb1ZvUmZEZ3MwRUlYcUF0THo1b2tqVW03Nk1KT0EwN1Fpd1R6?=
 =?utf-8?B?TDBNVzQ0alVjMDNVVFByTWh1VDVCTHZZU2lQOXdnQUpITEt3LzRBb2pydmM3?=
 =?utf-8?B?b0VvcEkxOUxVVW15a2x6L1JyelFOMy8xaFZLU1RRTUlUL1hiQko5eFFQOVRx?=
 =?utf-8?B?ZjFycXVMcjlNaGUvbFZNTlFMS28wdHF2ekJCR1o5U1hyUWJCUUl1WCtjNmFi?=
 =?utf-8?B?Wi9BeG81OC9sR2ZON0ljNm50Q3FlcThFZTlyVVNSYjRNRmJGdk8wd29sMS8w?=
 =?utf-8?B?OE1rYVptSWhHOWVsNEQvRmZWRkZYQlhobW9XVUxuZXNBZzkrTHF2RXBiVm5s?=
 =?utf-8?Q?mTFNd/WxRCyOmEz0tYxg/TBkH?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c9d378a7-d686-41d6-7ce8-08dcc2211c7b
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2024 20:37:44.9311
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OcccsVJZlfFSFsQb6npC1xQxdF5hFkhPR1qlihkvpRmX7G91TMvKL1LCHlTqKfUkesmsr0fvk5P7b8/lXUtWUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7054
X-OriginatorOrg: intel.com

Philip Chen wrote:
> Hi,
> 
> On Tue, Aug 20, 2024 at 1:01 PM Dave Jiang <dave.jiang@intel.com> wrote:
> >
> >
> >
> > On 8/20/24 10:22 AM, Philip Chen wrote:
> > > If a pmem device is in a bad status, the driver side could wait for
> > > host ack forever in virtio_pmem_flush(), causing the system to hang.
> > >
> > > So add a status check in the beginning of virtio_pmem_flush() to return
> > > early if the device is not activated.
> > >
> > > Signed-off-by: Philip Chen <philipchen@chromium.org>
> > > ---
> > >
> > > v2:
> > > - Remove change id from the patch description
> > > - Add more details to the patch description
> > >
> > >  drivers/nvdimm/nd_virtio.c | 9 +++++++++
> > >  1 file changed, 9 insertions(+)
> > >
> > > diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
> > > index 35c8fbbba10e..97addba06539 100644
> > > --- a/drivers/nvdimm/nd_virtio.c
> > > +++ b/drivers/nvdimm/nd_virtio.c
> > > @@ -44,6 +44,15 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
> > >       unsigned long flags;
> > >       int err, err1;
> > >
> > > +     /*
> > > +      * Don't bother to submit the request to the device if the device is
> > > +      * not acticated.
> >
> > s/acticated/activated/
> 
> Thanks for the review.
> I'll fix this typo in v3.
> 
> In addition to this typo, does anyone have any other concerns?

I'm not super familiar with the virtio-pmem workings and the needs reset
flag is barely used.

Did you actually experience this hang?  How was this found?  What is the
user visible issue and how critical is it?

Thanks,
Ira

> 
> >
> > > +      */
> > > +     if (vdev->config->get_status(vdev) & VIRTIO_CONFIG_S_NEEDS_RESET) {
> > > +             dev_info(&vdev->dev, "virtio pmem device needs a reset\n");
> > > +             return -EIO;
> > > +     }
> > > +
> > >       might_sleep();
> > >       req_data = kmalloc(sizeof(*req_data), GFP_KERNEL);
> > >       if (!req_data)


