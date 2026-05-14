Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A8603A719B
	for <nvdimm@lists.linux.dev>; Thu, 14 May 2026 22:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778796881; cv=fail; b=JpKaKsbgXBhUUpxZlQ8K2ItdUW+pQLuUjGRxMeRmOzY7K4Ae+pqOm6KoUFUS97hxL7192idvEhMFQAeLfqqoTC5WKfGhUi4QM1HPXTrapSItHmj6yBpRednDC0JcO3DoJ0wyQedal9lP87+gOVbjzrfJ63g1gZx0JPhlQgsXu2I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778796881; c=relaxed/simple;
	bh=RwALxYw4x9j5Isz19wZNeh3psw40uLQcZ1aacvZldx8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=R17VAI1t1J2bOEKAvuxuKvbIxVfFTXSK84aPhnR9I9HzbmS/USU2xnICb+8/NR/XGe9AwaG950PqSEb18SVbepsB7j0RuHsMfnuyFubVypTYqdLbWs8+/HSJMKMpRf3SxiEgMMwVwiWUSDw7P4rWpR0/uhlqbLV4MXxakxuuvF0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QVsy1GRF; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QVsy1GRF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778796878; x=1810332878;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=RwALxYw4x9j5Isz19wZNeh3psw40uLQcZ1aacvZldx8=;
  b=QVsy1GRFWu2/BK+Jz4St22hUwlIoNYkmTAQBASy36whakXcejzpLSWS4
   JphKQnX8Y/5AV31eBZ0xmDyKV12pqmL6hs1k/2QLQMI5MT5AiCED2xpsC
   +GLSm0+50E6xp/gl+VMO4IFYCJVm2J3svHR4wuoIBxOqvd+SYhHC5WOjS
   u3/nIZ2JsZ69ronNrMojWmDzDWkCcOry3wbhKZzHf9KR6QwtAQqTMRP8z
   nPFn4lFHXuMsBfoz+++xtxebnNzreXN7lrfMQajo870DK4WjW6uG5fLHl
   b9oyuGoGE9A4I2Sax3i7l8NK2A1hN1jcWNe70VeiJoeIVNTQ6PiVqiJUX
   A==;
X-CSE-ConnectionGUID: 3cUSV1/uRz+3zT2GpIvryg==
X-CSE-MsgGUID: JrI8757kQKq4KIIoz8/XJA==
X-IronPort-AV: E=McAfee;i="6800,10657,11786"; a="83364612"
X-IronPort-AV: E=Sophos;i="6.23,235,1770624000"; 
   d="scan'208";a="83364612"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2026 15:14:38 -0700
X-CSE-ConnectionGUID: YH7Bp+nhS8SdMm0z/hziwg==
X-CSE-MsgGUID: 3buqFVdwTGOGrLO0O+gOtA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,235,1770624000"; 
   d="scan'208";a="238619864"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2026 15:14:39 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 14 May 2026 15:14:38 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 14 May 2026 15:14:38 -0700
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.46) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 14 May 2026 15:14:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bZL0UqDcpMwSw602vn6YGkFp/TOUeC81gAXkRdcXNyaXY3huDduen5WR8sVza0Uo5PJh0Kh1wu2woj9vuXmUp0kHyQ9/CUpIa5q6cRJDUXBe2O6VJ4WnU+jJDVa1kO4uS2SdevtR9hCGB1J2kPixMyAH4ejUzgrucIPM6nQyZNxXt9R7d/exyECCEjlhpTGC3VY/YktTJpLzJAHfKzW/BMTya7T5lfsiIQIXx4CquMHqQPTv+0U3T7O08lIcMVnm25+N5ckSYtq/2KRj2cR2xSI56yZtii8v+CwnJvmsVWRcpHMdQ6V1V4D1Cq7fpvUJjHTMqBY3PUE/DlVmMgCJ5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fueEYwodbsZHrGmmEuMDdJC1adM7oqdPA+znE4yxbIo=;
 b=fqbg+iIWiZ/qmq+/b3BhZuhGICnukBf95C+JQXRwToB7h0EwOfpDZ4BFqn+IZrKKT7DBnSxdPSS1GS0ZOBu1FmzQUQN29XIiBFqmtSprP+/tpm/TYdnYzT696Jxa2OA8f45O/0mCeDDAcOZ/3fBV0ff1Th0DruH0PbddY2lAWLToqo/IIG3pp6QqPTTpH2e6VEq9ly3H7llcfSYjKYxM8XWQyXnPG/RUCj7YZuR9Hqg5hnT1lfrd3wbmB2DtpGvEJagG3fUU/QY07Sxq977dx5pKkzK9IBP+g//e/v7xjMAc6cwnhrNjTfxyGHaNqOceAFyxWh+ZZW/KgRL+TzLz3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by IA3PR11MB9183.namprd11.prod.outlook.com (2603:10b6:208:57e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.12; Thu, 14 May
 2026 22:14:36 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%8]) with mapi id 15.20.9891.021; Thu, 14 May 2026
 22:14:36 +0000
Date: Thu, 14 May 2026 15:14:33 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Chen Pei <cp0613@linux.alibaba.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>, <guoren@kernel.org>
Subject: Re: [ndctl PATCH 1/2] daxctl: fix kmod reference leak on
 probe-insert failure
Message-ID: <agZJSW_PcLiAlD3b@aschofie-mobl2.lan>
References: <20260514063234.86439-1-cp0613@linux.alibaba.com>
 <20260514063234.86439-2-cp0613@linux.alibaba.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260514063234.86439-2-cp0613@linux.alibaba.com>
X-ClientProxiedBy: BYAPR08CA0019.namprd08.prod.outlook.com
 (2603:10b6:a03:100::32) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|IA3PR11MB9183:EE_
X-MS-Office365-Filtering-Correlation-Id: b45585b2-19b9-4d26-5a62-08deb2062f25
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|18002099003|22082099003|11063799003|4143699003|56012099003;
X-Microsoft-Antispam-Message-Info: zPKzXFxXgfVJwG2qjdkMwsp9IUiSisYy21Dthac4B4q8W3qO3KZTIXgHX5BY1OVy97KyzBAym6why1Hdb99azyiobzC06isZ0OgePtUU9iryxgyqZk55fBLxlSS13cpoX/NMpI22r9cXSmm9AJ7IeDpfRf+3roUUgIVVzLNeEeBJ5QdnsSxzSuwWdmoQzjY0gdOj2YRkq6P1FjFMcdDQgjqptYGjgtqoXWiD9ymFP9m+r9ZJbBBvegZjlUeCZcdal2qg52DMm9U17B596sLWW+VhkwDc1GYoTJ4sS7V7rAf3djDYnPOL1XrB7jztHAKot7NmCuZwoPnEHP0YRHiP5zaXcNsJ83GWJeZFpXBWyFWi90Sefew/Df2j/reslhB2wnvGSDdZfnvnLFPckakJ+BpL9bYrSssB4wU54oCyF82as/mO0SdOwgmaxIFWJSOpmFcXmQXnQ1JHJLkMRcnqUTn/BSgsd+Ie67t+fDeKR+8gGum0vqpvo9aSsHVNGGgUOFClNZQ4RtmJWg6mv29ip5qy/NmXr4u/AidESKxoSSY5xjmGSa5ML3qBhZcO69OmvOrenwZ1AL7fsOSMnUAfqRzAEWLpByMqNoaA4yLJDGnaVo6bH9Wj49lAXx+Tp3upohtA1KTHVsePXF1qAxW7Lc4z5CzZbndmajEL+OIK4nhiDH2eqdWngZxZjugxWhQH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(18002099003)(22082099003)(11063799003)(4143699003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8amp7ue2IcDT0l+wlK0m2JG9vQTNgEfjbjfLhS4pVuhtA0S3PrZCQvYh0vLq?=
 =?us-ascii?Q?95ZtNBk+woqKa4HHue2DMh6D139N/VXpgvCPMgaOwoVqG1tCt2X7I9w5i4jI?=
 =?us-ascii?Q?QC++pfg57ZUrEUANv+vQK2jY6z5ErZqFM3Rz8rR8ZCKMyQaT0itJIXpCg4H5?=
 =?us-ascii?Q?DlT/VChsUsV7csGLY36+OtKcqLBvYRwIty2fpDL2sY0q3I89dgmwNq2OKp5J?=
 =?us-ascii?Q?xgrqgBSJO7Yj0vy9W+k06eeKXgxOqQ5xjfs+UZcF8IC+Uio4qVTsuOVbzOSN?=
 =?us-ascii?Q?xeXvxb6E+1EsmsPD4NjyiFvqFeyJWlizIOaSNVTsX8diia1urHLhP65uwDAy?=
 =?us-ascii?Q?jn1WIlzcmCXdcfUoAQ1EUtohmg+Zd0zL0Fb0I9sp5L2X0C+GUQ9Yh1vH2ptS?=
 =?us-ascii?Q?c9j+u/ZxgEfab+uZ/vC8yvbvuCc7qeMrlUDpL4vf1X1btyPqIO1RVyCstqcv?=
 =?us-ascii?Q?9Gb0g55kf8ztkMtPMjbPx6G0w3M3lyqbbNPYwGxMA+C9aaM1VNTOmF0RhoWc?=
 =?us-ascii?Q?1DRyjlR7M1VeivxvkIT14qLUAQeRxKsIQHbTVBkcgclZClh+LfOtCrwyEZRz?=
 =?us-ascii?Q?/h2HIjZdT/xyGBA+QSiPDRfOOu6mcu8hKazUiYB5i/7w40GcVbtMm9wvlj6O?=
 =?us-ascii?Q?4uHuvmjElDet29BL3HTGmiviS7naItbeiUHVZA4nhYG9cti7S/bat5aBL85a?=
 =?us-ascii?Q?zxtyupbbjQiZPOMus38Iw6AqNUpVvgGJAFYzkH+X8W/xNekpKiR5jS12a6gV?=
 =?us-ascii?Q?A6oCmVxCzdHmVG1jLa+g32CCMxeko/Hph75yi2arif17Yje7trBLGIq3RDG1?=
 =?us-ascii?Q?+WtrivI3Qf/LJPHEsTXaWUcmJd0E7qdN8cub4lRuy3SmN72lJIwtT+ila7FZ?=
 =?us-ascii?Q?5qh7ZRQcjzpDg5x1aPNQy4LawQ+kwrpP7/f+HH5SBtxy/zqxdxS1tLDDwNj9?=
 =?us-ascii?Q?ljc/zTLLMrpK2wIKWNT/UPC5PpqaopWisiYpr9gBP8DUaWX3B3Qw1dLlTJ1n?=
 =?us-ascii?Q?OOuWpF9XN1hSbEn9iiT4t9w5CsZzGy30EreQFj3GT/LwLG6qmMEul1SOAX+9?=
 =?us-ascii?Q?/zVIJ8cD/yrYsTHjbMHxpjLiRFoPS33+p36WY+5HT/J82CeadbxwoxDwjl2U?=
 =?us-ascii?Q?yBME/Jzm9DnA+BYVfnjHBjRoe/DxNCWmWrhBdEkHqFu3nfuGUFawJPM04QSC?=
 =?us-ascii?Q?dK8BwjZb7wUaS02p7xkLUAWN41bAKerYpRXiqso1N34auT1tzdiOMqH0TlyD?=
 =?us-ascii?Q?/naAA3DSEiEOBM/qPLZW13dy1WOxBrxOBMvxxQ1tEFqzSdX3Zd6G9DQIrrcU?=
 =?us-ascii?Q?J0eijRWN9zaNoUQo/+IrpFpyrAH6K//T5Bl8bNuC+KeSuE4BKzeQyaq9hKkU?=
 =?us-ascii?Q?ADMOudEOVGuhssPSIUHPaAwH4z+QibUKBsg+rxUIwiXazpo/F4SQ3CbosU6L?=
 =?us-ascii?Q?GRmkgJ8CHSK+t7wHG5cMq+DikPtyXTkHBF17pJljcZ3NM7AhhZHC5ocG7B44?=
 =?us-ascii?Q?sP75fBAt8toSuEJjhgLRZ7EW8RaYN1nja5gCQmEIYwpXodpkZXlI0OD7jkhZ?=
 =?us-ascii?Q?Zk6ltrgRE6gxvvkvEc+ylpfUOQk0qKnxUFTDdEzEmYgR8w8vlVTfnuqf7FGi?=
 =?us-ascii?Q?4sufgqstWxDNHQxPCjNOp1b5LQMMv8FFhOQq91bpUnLFv+BacZSo+vHDqUYl?=
 =?us-ascii?Q?eEwMwu6zbrIyYJnZZQWyhI0URVvc/LbEJw6AT7tHbl60SOBUvtwko6QrIRCi?=
 =?us-ascii?Q?JujgrhKySIPwiqDa3XTts5MG41Z2JkU=3D?=
X-Exchange-RoutingPolicyChecked: B0gYnNsfhvOCjwHa4rsBg7dQAHhjg8Xq9/VeD8/QW+UBLgGOAr/EH6vjbHeZmAtWwBi19tzEHxpC+F9+me2XnP/1hnFNcTs9da+WCCRVYgaMJSTDKqINZ+/YRoeJZonTNJ2d3h861747P2jkESVAffjmIoI6oY1dWmgL5LmQDh66FzdoWHvWg8ZSzzsHcQYVVzDXuHwYPjYOScvRLzU4A9li+bf5i2SFDchdbUQBHBSosW0ZK0ODype8ZamzsGRqP9VBIvrZzru2sLktaAgo0QUb6fP9VH6riNhUOeGicsEjmLoSUkP3LnJBD1maQmc2uugRCq8mFQNXEGDfsFK16w==
X-MS-Exchange-CrossTenant-Network-Message-Id: b45585b2-19b9-4d26-5a62-08deb2062f25
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2026 22:14:36.4771
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lg5e47+feqL8rS8J4IweZ9YJKZBo4OsJEX0iRYDbd+hlqAzq7K0YfXlrOx8P0A8nUalz1eV6ULljzROUpIziYZpIlzxjkvRfMOzvAnnuAio=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9183
X-OriginatorOrg: intel.com

On Thu, May 14, 2026 at 02:32:33PM +0800, Chen Pei wrote:
> daxctl_insert_kmod_for_mode() obtains a kmod reference via
> kmod_module_new_from_name() and only stores it in dev->module after a
> successful kmod_module_probe_insert_module() call. On the failure path
> the local reference was returned without being released, leaking one
> reference per failed enable attempt.
> 
> Drop the reference before returning the error code.

Thanks!
Reviewed-by: Alison Schofield <alison.schofield@intel.com>

