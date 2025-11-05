Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6193287258
	for <nvdimm@lists.linux.dev>; Wed,  5 Nov 2025 19:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762370185; cv=fail; b=YYV6LGPjUlSgsWlbld+pGBrug2XF+nlESf+pRfo2D83Y7pnPF6XKYKJVRy5CjpHZMj87t4FLINmADF0X90S6UkigWvTSguIsAUVInxzpR+oGz5HcERasLFKp98qyEdO72KthVcM8LKJSPdEMZ9+BJ4FIFhnN+Ii9I5q+03li7fM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762370185; c=relaxed/simple;
	bh=As7k2M3SGRRD1x/dy2vqbkKn6/+s7Ck5dMuy5llf99s=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Chgwci/++Lq34ngPepY9q2wQgQEqip7QZv73qmKzrEUfUXHg/DtLGasfBvjnibCxbV5WAd3N7Rr9RdZQiloKyaSVpeV16GcSc4VeXDOdk8mGet/wn402ZJCAkgM/IAatY04zC/GV4hrVVowoyda8Y/8XbmtDY/k99Nls+ftcK9o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Lu8jM5fp; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Lu8jM5fp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762370184; x=1793906184;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=As7k2M3SGRRD1x/dy2vqbkKn6/+s7Ck5dMuy5llf99s=;
  b=Lu8jM5fpjRjDRxZz6pqoV1vKAJE2c4oRBV+m9FGPm3v1SHD3jRE+Yymy
   alM2yMMHW+TmmHJXPHWFZYXKrg7Z6jxbkpoRUu5CvqhhuxEOH4bhkxE2u
   beLaqY8V7uUgKDjwdOArWAtkIHrR6ebRan32y/Qflyil9b7Gr1JASL2XX
   TKr2SnCmxdJL+Su+J9bBV0KElrikQAQG5EFoFGiRA9uwLRQ8LZplP2wlq
   CK8Aa1QSn2dlL9kIPaiUp4oFQUb9zhdba9F2lol90YCkM9kuN3jvDMpK4
   p8Hz+P1Sp1DuKtthG5nagi1xr57DrlnUV7BYoI/mWCNGHfIVhySAwA+0w
   A==;
X-CSE-ConnectionGUID: +9h5vusRR5WXQJMeCnbvGQ==
X-CSE-MsgGUID: SHDcf0BNQiarXNht55xkEA==
X-IronPort-AV: E=McAfee;i="6800,10657,11604"; a="67111370"
X-IronPort-AV: E=Sophos;i="6.19,282,1754982000"; 
   d="scan'208";a="67111370"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2025 11:16:23 -0800
X-CSE-ConnectionGUID: YOxFiSjbScKQI7wpudYsYw==
X-CSE-MsgGUID: IFhiUnOBTN+nChZqdp/MQg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,282,1754982000"; 
   d="scan'208";a="187705696"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2025 11:16:23 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 5 Nov 2025 11:16:22 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 5 Nov 2025 11:16:22 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.3) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 5 Nov 2025 11:16:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bbSv+Hx/ecdKENAjtG7lygMkUtqWXXNh8oBT/9X56K0pnT9Eu/g49NQaYVkozbH6Q9nOatUE/LId6kVKz2FhY2lLiq1Dv6F/Gk+2K9YidrbD4LWe68xI1eqvE34a9WFjm/ey0SOELyerTb6m2wIM/YnjJhIxx1bzBweWkuIcuhSDGn5y4Ou0tKfG48f7AeXsilZvxt11f97b2BiaoA1kdR3FBP/+GjUICZJx8AeHPuBgn3SLEeh+wn4O1eVLmqhnQW3+8OxrZATTwyO9gfwgrjxVEvIUQ0GWT0LH1CslYUnCUx0x2P7sbgG5mrEIJkR67aLEiwxPu5mAGF4cZFToCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HskZJHd688IOy11IliyC9F7CKxnqopiwMqM6mGS/idk=;
 b=li/ds1T6aNC1di4ZduFv/PdqgyrxXAjkDGCX1P1y1dXIwOsv4YLZpWu83kXOTQck/ujmHW0ZhCbh+z7bhnQ3uNGiO64dL4H4Aju1B3ncTuLLjPmg3mmeLz9bST64zH+zlKkM6ul5cQ5Neq8C4hDoKt0r7IXpF60RgEWtKfAfS3YMdasM6UcrpHdahKfHopEeiP9PxREJhKkTEY+++PVeXxeRZrBpj6Hx0WMiO6MWsrU4qhzwWfxolvDKLQzM2Z2f/+G8talWQCPgg/LTURlrl6wPPsn42ySLaEibsDNQoLXEWynJC3+yUMRws+9cNtr096/FogHoWycLjigaUu60qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by DM4PR11MB6041.namprd11.prod.outlook.com
 (2603:10b6:8:60::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.14; Wed, 5 Nov
 2025 19:16:19 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::8289:cecc:ea5b:f0c]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::8289:cecc:ea5b:f0c%8]) with mapi id 15.20.9275.015; Wed, 5 Nov 2025
 19:16:19 +0000
Date: Wed, 5 Nov 2025 13:18:46 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Ira Weiny
	<ira.weiny@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>
CC: Dan Williams <dan.j.williams@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>
Subject: Re: [PATCH v1 1/1] libnvdimm/labels: Get rid of redundant 'else'
Message-ID: <690ba316b541c_2848c61001f@iweiny-mobl.notmuch>
References: <20251105183743.1800500-1-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251105183743.1800500-1-andriy.shevchenko@linux.intel.com>
X-ClientProxiedBy: BYAPR07CA0048.namprd07.prod.outlook.com
 (2603:10b6:a03:60::25) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|DM4PR11MB6041:EE_
X-MS-Office365-Filtering-Correlation-Id: 44bebb96-a564-4fd9-dfaa-08de1c9fccd5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?sM+vx8973k3tRLgZ0er0fQ6Rk570TPdD+GERnH3S19PbFamN2G7TO0rE9ic8?=
 =?us-ascii?Q?meIRqi9FCHIiIPTRngozDYBAszw8TflrU1duPveh0nonGscdwzCDQS134V0n?=
 =?us-ascii?Q?G9fX7Zw957nN/aYuWWszDzo4qugcOaj+S38Kxdg7kor4mBRWrNRohJ1wJHeN?=
 =?us-ascii?Q?8nPdk2tsdhyrxA5n862KfIguoEuaIHeugbs27rFsK5xaILhbJftDQ0xLdEQS?=
 =?us-ascii?Q?fPit7fOgjn4hbpTtp106kVwTmOC0J7OQWNUFo1aWJmo3G3eC2LDkk9VKLdkW?=
 =?us-ascii?Q?KA0M8BSf2VgidnGrJHLEXg3xWLZzYyEMzTEMYn8Smd5CGPLGVu/XyjsP2hEb?=
 =?us-ascii?Q?w6qIr7VoKeghsF6GzCFjMvsyB6jY3Xe4TiiKFfQbLQcjKqjLVfAiYxDANi5J?=
 =?us-ascii?Q?aGbMuv7DucsoPtOgR2BS+OEwldvG5xGW6q8kMpRtsbOBCajt8ciMzQ37tnrF?=
 =?us-ascii?Q?D7rvso7imrU4IrGy/6uFT3jeFbDiZELaaXENwiSp8Fj5iuCfHaBM/bRMYQRY?=
 =?us-ascii?Q?7AYbn7UrB93AFkd8sUTnEUPYM27PnAjJckvfeVHi2ZmTFyQPBwMQIYC7ReAo?=
 =?us-ascii?Q?AqxcYWAFXO8JHwB9OKy0TWXqZ6w9Hy+lT4863hc5XKka5g7Pkvy23Moezagy?=
 =?us-ascii?Q?y7nfh5SkvImPX+JokrobL2t/g+RZ41aGCkf0EGo1qc8t/nrpvtK60k5JZAus?=
 =?us-ascii?Q?BeSqkm1CqGAxiU0YJiUZiThgCp0hBZavhAwhnsyNnYfuEomsghTZDTHgbcyn?=
 =?us-ascii?Q?WGmkFQU6hA2taYTATEdLmb6VUDYmLGRZ1moNNT4qF5zV/vSi0oSYsInpGYkn?=
 =?us-ascii?Q?lTadOG6opolhTGzvjYvO+rzUPBCoeUATFXLRIZkVw/OUoaxAqr5UgrrSOmHn?=
 =?us-ascii?Q?A9GgsUq6dEu8JHmx+YYLuJXvKFQ6PT574T0EoVpqX53d74CM1/J71pzTeuND?=
 =?us-ascii?Q?iqGq3bd0zLj4+qDAd4pmQRz04NcFjINrg5A7LUQPLpbwbYN9s19iJvZgd+4z?=
 =?us-ascii?Q?0lRbVHIiPRz3E4AJS5W1B+KSuRWQFo3fHbDzrpoqjFQrL24qU6bOQoZZ1T+O?=
 =?us-ascii?Q?oVfzEs7R8BkRfFZGx/wQIX0DY2OebKaWjSRNndF5O3pfs3TRZtBH18smoG1k?=
 =?us-ascii?Q?Xih4kvPl2wpyDmNvFsf/8tO3b6ist1ll4SELblQCK/n1+LOU8ZVB4wZgFM0c?=
 =?us-ascii?Q?NF+rQGn4Lj8Nwb7HnddZ+BRB94e6P1I/W30gQ+fuYLSAYI1s/w/2itlly0bA?=
 =?us-ascii?Q?PZpyn5M9PNP5m2sMasS88kyEQqKP+4aUbNZoIBqsqSF+Lr6Nnw9AMRKm+Pbi?=
 =?us-ascii?Q?ztJ05ezMb4y2hBrUhv0j6hj3JOo/blizXPuD6L5uKYyIjl7VDwLt0FrvV2r+?=
 =?us-ascii?Q?BAnntjmJHmjsgP0bmotAaFxo5x7h4u5o6rPi3dcUSo9nF6bSpvKerGuWT6sy?=
 =?us-ascii?Q?SjThLPURu88KyHZte2hhn+cZV9X5Zg5D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GzjbTMb1hb8pdlDS71zz/oMEFhmSFOn4BPpXyn9AFDiqQHzKjAPp0PhB+00L?=
 =?us-ascii?Q?lmsRhkfkn0azCYYtyiDdMWMFq+HsqvaPwITicF/WixvHAy4EeJ2kmWwh9Kx5?=
 =?us-ascii?Q?9JDaktUGCCwwx2pHIrV9+U7ufyjJUWzAnWiqJ2j7eS1Y9AJ7844ypHQCr7kP?=
 =?us-ascii?Q?DrLHABQccP4ONvAM1OMDvMUbVSsdywtxB+LjyKHv3lAZWVDS3pkqJ33qz6tA?=
 =?us-ascii?Q?Lq8draoGPY/yL6SQMXIWooU6heGysLBieiwLHQaPrNejWUS8BZfFo2HPUURU?=
 =?us-ascii?Q?rHm5qLT4Mfl7LIef7XLHyj+okyNFSjIqWvLNIwAOh5ZBGfcDaidLJPmBFQ4Z?=
 =?us-ascii?Q?YXgfvisEL+JCy7eQjstwlZl1euMEjKER2BicBCrm9QOFoHzUx1eLShMS3s6G?=
 =?us-ascii?Q?FBxnUaduv9s+bt2rDFCfjR04eWQwz9hHo8KxDA6grwUogWBI2uR8vrfyaZoo?=
 =?us-ascii?Q?BmjJDuITik74uvQUrv3JTBCdFN2w4yquTKcORtUFbKBTDx/lsHV9JTN3nx2h?=
 =?us-ascii?Q?+DyrpoDaP3+NZ8OeZlPAKwdXDEreVLvQ0XS5a+8h2EuAk0O62fv9lHAACcHP?=
 =?us-ascii?Q?cGAG9zBLxT73B0NyMSRVMLQgo0+JiYN3OoPi1MuBbVJiSZBgs5v9uTh97iI8?=
 =?us-ascii?Q?SZZTamGbpyJK6y11WjkI+bMYOaugZM69fpXjrPTWQR8NUdvMI7t3ZHVtYa4J?=
 =?us-ascii?Q?yp+Fq33h9CmMFwIRo/Oqh1nh59MHnPklCZ509mIRdpoiDKyRETbuknspCc7P?=
 =?us-ascii?Q?0iB9aVkmevRqHg00aJq+tIlZzRUuyfAZynTOIYJmg29I72HfFYuZ46irwM8j?=
 =?us-ascii?Q?8sTliHB14+pBhIEHxYB556WK/568lRCyA3JOHmYiRc2NASNgh4SuFM8erkSf?=
 =?us-ascii?Q?gp6UrkQzbRfjMFI/VSGVghdqfkmhDrtO5ORxy9I61aNi38GZty73Rh/5BErU?=
 =?us-ascii?Q?yVqaAgQw1zMiebfFxY3uM2vQj/TdNlVo/U/8qi4uKQ5omea3pK1U+7ugntSr?=
 =?us-ascii?Q?Fb09bIjEa6T6mzmgV30J/sSStJ1CiykUJixk2hlXPI9K6bMND1G5xTyiR+w1?=
 =?us-ascii?Q?D5X6D2yfqvXpZJSzcgePT5tzpdz1ZbOC28mi9QqyTnYlqBlXKm40+Zwxgrkb?=
 =?us-ascii?Q?Ic5+sCsAFkKXWgFSsITT6YAWcY7nSWCujC6pW+FztnT8UiNjlvZu7xjEyEa6?=
 =?us-ascii?Q?pNR8SAcmDjGh+RKREZC7l6P2yN22SvwDrtuWHsKo+5/NrXi6KQxbX1AYsTBw?=
 =?us-ascii?Q?cVN8nXPMSPpfiq8fU0cXi8+kg6GDEe8DfgRT4VN64q3PN5New/GwvpGWR2bH?=
 =?us-ascii?Q?/17O3ZAdvH9d9n8qt5D/tT1puUejXQ2wlSL/Ac/Q4JhVoQRQDC7Jpp0LkZnA?=
 =?us-ascii?Q?S+Q6HzuJfgNDciF5ZcvDefuxgRZOeIgCFBUAhzuyTco6Ah4WcvEv+Tk18t9p?=
 =?us-ascii?Q?Cz64rhiltpG/EFfCmNQU8cwQxiL12ZID+JTYwhpt9d8//oLl23xkDLK8GEeI?=
 =?us-ascii?Q?5/n904RnGYBqJAP+8C9cEugCPO33I2uOs67lK3FJWXYkWLg4bN4qcI9aPcbr?=
 =?us-ascii?Q?awDAV1CyCR6nuQ6fCnKhUQdMQ70fetYCHyBol33y?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 44bebb96-a564-4fd9-dfaa-08de1c9fccd5
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2025 19:16:19.6968
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FJHLbjNe0cddbDLfUUD5XjlNqEJ7S0WzOBY9SxPT5OwHQM3dRZ08qjZjDE1ZU6vpvZTj/aXWz95+nU6vqRPl6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6041
X-OriginatorOrg: intel.com

Andy Shevchenko wrote:
> In the snippets like the following
> 
> 	if (...)
> 		return / goto / break / continue ...;
> 	else
> 		...
> 
> the 'else' is redundant. Get rid of it.

What is the reason for this change?  This results in 0.6% code size
reduction.  Is that really worth this effort?

Ira

[snip]
