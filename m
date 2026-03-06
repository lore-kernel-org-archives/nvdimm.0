Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97D618FDBD
	for <nvdimm@lists.linux.dev>; Fri,  6 Mar 2026 18:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772821785; cv=fail; b=iE79ZktS59669cCSBCY0sf6lO6yDeMjKrDKe4CcNc/CQWJZpkRNxsVvfJkBn5phVeOwx+VmVkt01cMze3wa11hDWLS3MYqc+aeOy3iZpFJRRzPVVdwA4hPrvJ48dKU7ME8LXchg1wGlHpGoslL/vdwWqJPJg/lrD2jz+zpVCgXY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772821785; c=relaxed/simple;
	bh=Tyv8PAZKYPxS6BV9IgC0g+pwU6ITVconDZF/JQL0Y9o=;
	h=From:Date:Subject:Content-Type:Message-ID:To:CC:MIME-Version; b=OqWSN6nPVv1uoFQMn8xh9QlYQewV7tIQ9qOZ8faxkBOZ/+hNpCI46w4YgGkzY1HJFk7ZV4uSHOjP8iNCMgZmMEWnGuoqCUU7anE78RdY3fcZECpYbejmtNpkm19B/vs/gBINe+TdV4lUjB7WSghjHwPM/fHtEHcdQylwVDUVcAY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IZsGcuqy; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IZsGcuqy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772821783; x=1804357783;
  h=from:date:subject:content-transfer-encoding:message-id:
   to:cc:mime-version;
  bh=Tyv8PAZKYPxS6BV9IgC0g+pwU6ITVconDZF/JQL0Y9o=;
  b=IZsGcuqyZng6Y6urxUdDpQz04co/lt3Naollda/d7lZZJW/sxkZFBbr3
   ab9g/bJNl+pfXaEZsJDIOFyvWL8z/fA4tcHbFrXYzX2jM+dRfu149YU8L
   DR0VoDkaPIMn61Ob/T8Ab4NcVNzq8QJ8mK5e569/wEw7vssw3ztT1x/Kz
   zrsLOHBfpe0MsPGkSlBjX6L+MbK4JILs5Y/2xJ4QlT6PlhEefXoyUs+dT
   5AwlNW2hWUXXDzgMrpix5mdGSnySLr+AyGkO3lya8G2B82+QKq8rMwxPN
   thqr0CC0NkkDc25fQdt33wNf16Mu883xx25l3Ji/Ap9rix3+uFCsp9QjP
   Q==;
X-CSE-ConnectionGUID: lef4T819TjShswC1foLNjA==
X-CSE-MsgGUID: yQ2yh6H+RB2/1aGGBfHU3w==
X-IronPort-AV: E=McAfee;i="6800,10657,11721"; a="77784829"
X-IronPort-AV: E=Sophos;i="6.23,105,1770624000"; 
   d="scan'208";a="77784829"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 10:29:34 -0800
X-CSE-ConnectionGUID: l76odxNmQNePYxgh9fvakg==
X-CSE-MsgGUID: wGdyzXEbRY+pIvHBtDH7SQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,105,1770624000"; 
   d="scan'208";a="217284508"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 10:29:34 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 6 Mar 2026 10:29:33 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 6 Mar 2026 10:29:33 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.58) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 6 Mar 2026 10:29:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HYd8d8xB0m7B8zP6dVGle1rUbCUCVuHLpSPtvrtRgG3i1EvHm0vRxsXWyX72aS+jUNbb9lbdffzjvqxjX2MZpw+t2+E1QnH/Su2bP7ca6O4FEO1jZUkL+MHxL48IiGQSRDlM2M6ZB4KVTP+UXCUywVkeCcYoiH0BWiru7yGzar8Fffb/vs7fCkXl1KOLkgOA+bBkuqbzesgOOYFSLUXW92sNsU1TDjG2Cr2EsWp9ZL54XyG3VzFXQ4NpPl6zyLUUzZqRocrcoBvztfk0S9Sw6o5y/2FcAdLafxx3D463MbiLu5iCzZJ4KNw9meXF/B4byhxU+U+7QaOpNeMeFuCvLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QtUNPBMhAHdawr44Yg0JbQ6wMeH8/XOf2UTKmp6uoXE=;
 b=yQf4pPxWrOyHuRDauYPqkxv6LOt2K2Haj5xbGt+3D4r7SZBNu0XU8dRMANr9ivf00SXvLBqn9Jb8eIhwI0TMOHVZuOEa/No3ac1p9PHh467ZE6aDKXOu0f1eifzHIHkmXz4al+VOpyFeIFfKdwJXBW2tO787fysA9M2811J3IimWB1dPxYA9hRx/HpXT5gjsiQJkt8P8ckf3m4imLYUoGppLgzP+/13YjG19SNBnSTvFOQy/SRVGGml1R8WSyr1bar5pBYkqapAZbLhAJZOkg/3eBvYP4nuVJginLfLHD5GktgCLQLJPPrpt656UPp1xzqAh3c7XVZT0Zal8dqcjBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by PH7PR11MB6449.namprd11.prod.outlook.com
 (2603:10b6:510:1f7::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Fri, 6 Mar
 2026 18:29:25 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::cedb:24cb:2175:4dcb]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::cedb:24cb:2175:4dcb%6]) with mapi id 15.20.9678.017; Fri, 6 Mar 2026
 18:29:25 +0000
From: Ira Weiny <ira.weiny@intel.com>
Date: Fri, 6 Mar 2026 12:33:05 -0600
Subject: [PATCH] nvdimm/bus: Fix potential use after free in asynchronous
 initialization
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260306-fix-uaf-async-init-v1-1-a28fd7526723@intel.com>
X-B4-Tracking: v=1; b=H4sIAOAdq2kC/x2MQQqAIBAAvxJ7bsESLPtKdBBday8WWlFEf2/pO
 DAzDxTKTAWG6oFMJxdek0BTV+AXl2ZCDsLQqtYorQxGvvBwEV25k0dOvKM2trO2D310ESTcMon
 1T8fpfT8mfO5hZAAAAA==
X-Change-ID: 20260306-fix-uaf-async-init-3697998d8faf
To: <nvdimm@lists.linux.dev>, Dan Williams <dan.j.williams@intel.com>, "Vishal
 Verma" <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>
CC: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Dingisoul
	<dingiso.kernel@gmail.com>, Ira Weiny <ira.weiny@intel.com>
X-Mailer: b4 0.15-dev-52d38
X-Developer-Signature: v=1; a=ed25519-sha256; t=1772821988; l=1860;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=Tyv8PAZKYPxS6BV9IgC0g+pwU6ITVconDZF/JQL0Y9o=;
 b=QpzSMj8Dr8bNY7i1LFk7rrC3VZfC0f9VEnBc7uABkH3x2Z1M4EonUX22GE4pQMrz/WFHBsi0i
 A0CIvJj+BkgDXqEm+5iXfgKQtx0RUNnaptWgVOOVC7Ql1mPmDlrfTNV
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=
X-ClientProxiedBy: BY5PR17CA0012.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::25) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|PH7PR11MB6449:EE_
X-MS-Office365-Filtering-Correlation-Id: b4a3db31-1d39-46cb-2622-08de7bae4b61
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info: rYldHgfk0/pLvo0p0O5EQGnvQwTlVHbjLIF+LDm8BXg7tizHiTX6wCLD0KsC3XF/LYAN8KzUGSqc0cl93Elw17ZEOTmRWnXllyi/BSZ/tNejctTNN4h8i1Xmmj2tb6vnJYFEblM9oSrhO9g9wKry/5ypnceCHByi0ef+5SboqJjcOXQcaM+6uSYS3YkxEji+bfHkrR8hL8b8Z9M3bkWAYzrGqsgyEv3ojVQ9upt1wHwc4gfxqLgXgFco5k4kdAHCaaVCW0qvqPZYZA3PM8S9a7m8lCP3lMRSnNm+7R5nNKmi0/F/Q1UMBC5DbuzZAseimffjjRqcGx+iOJNdP9qsnXQFdc5fK4aLO/U3+voRVgo4rSe6Yb5sxdtq8uEPkTmO0Ugl6pn1tG6bxOh9zTl6uKr4o1PR774+4Fc9ovE/dabwfo1iyNCTtJc8r8gq5lcg2lOVtLdBiuUfJVIn76ePZuF1UC2M8qhoTmXmjj2ruHlGj9r1uGolJj5oPFSv2YWqY2wcImAEmstDunJ/TDFSxEdIUw8J+7t9xgXiKo+Rk502GnkCxDGvU0xUjjyKgy3w53uCA2azPJphcsi/YNBQ21/on+3vNTzyBELM1chRKS9+VKOfjGPBMnjEF7qN+ejiNDRCce3n+ATPjATCdgE9Cf3e6ssWKyByKvlwzu7G7pos7KdsuvL1x6CCnJ0jAzMb7FodR9lsdIBDje5HKd6xUCl1yKazHMSrGyg2LB8J06M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MDV0NXkyK0NtQitlWjdWeHFhMXNJaE9zMzYrUUFnMnBjaWFsSHBhc2VXNUtp?=
 =?utf-8?B?ZU5EeGJYUDRzbC92dytKVWZMNW1qbDJFRVp3U2l4UWsrREF0RjkzN3I4dk1u?=
 =?utf-8?B?b1ZBQVJNK0NyR0JqVHlvLzE3L0hReXd0dWFYL3hvUFFncnZDcVc5UmE5QTBi?=
 =?utf-8?B?KzNDOENXSmlRNGlZczMvR0ZwZTdTNzUyMmcxbE83N0NJaGJrV2xydUZtZHBP?=
 =?utf-8?B?dzcrbUFNbGFWVUJ4OHJ5Tk9UMHFSeHA5WE5Na0ZOcXJySmFoUjExcGd1b1Zx?=
 =?utf-8?B?QnpXenhRVzBMM1J4UnRuUGsxcFJZbGtTRHBaNmZla3VDd2J1ZFZtSFI5UXpM?=
 =?utf-8?B?b2F4MmIwdXg3K0p3N0dUSElZTmg1cTFpUjEyaldkQU1nVEFqbzBSeDhlKytu?=
 =?utf-8?B?QXFaMmRzenVvYnJkMkFNNTRmOVRlQVNuNXlhbTNJU1d4WVB6YWYzc1E3Ym9y?=
 =?utf-8?B?YzAyT1F1THBpQWYwbTBiaXE1SU1ZdkdXMDJQcEg5TW5zMS9LWWtpZ1ltVG5j?=
 =?utf-8?B?V0xkVEdPZXk0L25WbzYxek91SzgzdjJCVUtJQklsV0cvSHAwMTUrM0JxMG4x?=
 =?utf-8?B?NUM5dUVaUzRXSE1xN2dWRGFWNVRzVXM2azlDU0hUdmNPazVQRVpVSzlNN0xS?=
 =?utf-8?B?S3YyMHp2QU9pS0h3Rm9PUjJoNExYd2lLbG5hK1J3dW85NDJQcGV1Y0NJWmR0?=
 =?utf-8?B?WmV1NlJGVEN1SkU2NXIzVjEzNFBXYXBPUDlyYXlOcDh3d3pEc0UydjI0cEhq?=
 =?utf-8?B?OStrb1RqUnEwSEJDeUdmd2hWaDY0Y2Yrc084SEwzaXJuMXZTUTJEMkFnYXRh?=
 =?utf-8?B?QW8vMDMrcytMWjFXSzM1NTVaOTlGcFFPY1BFS1FrMFNvWkgvNWRlbi9meTZs?=
 =?utf-8?B?eFhmcHpSaEY3bXlMdEpYcUtCazVJYUdGTHFKcEh1WEw4SktwM24wQ2VuNC9t?=
 =?utf-8?B?SUpoYUpveEc2ckVkdkt3ZmZuUit2eFRYdUtNSmFoTElULzZTbUlZckZSanYz?=
 =?utf-8?B?amRFZjNYZnp4MzlhMVRPTDQ3R1puNFdaaU9rVGNXY0pOUVdXUjc5Q0VNc0wr?=
 =?utf-8?B?bWwrYUIxSTBZRitpcHQ0L3IxMzV3NVpPUERQZm9kcXFLTHpIRmV6N0MzcXRO?=
 =?utf-8?B?RmNkVklvMWtJVnEycHUrekNQZjV0NXpBb0FDM0VyMU5pbU9EL0VIU3VFZ1VJ?=
 =?utf-8?B?UmkrVDhWYTNtQllUdW85ajQxQ0RTdUhjaTIwUjFvWk9JaldqeTd2Q0FyU1BL?=
 =?utf-8?B?V1h6ckhNUkZPZUNrZ1c3d215T2lMQUluSDZpYnRDMWNIOUdndGxHbGZKbFc2?=
 =?utf-8?B?T3lNWnJIa3dmR2EvajlEMnVzdTB4clc1N2lkM3Y4ZnNUNnRYVDE0UDFWNjZG?=
 =?utf-8?B?M2paUU1SVExDMGdWSytCMDlwQk01WGVHWDJ4V3RiclljOHRab2M4YUhGS0ZU?=
 =?utf-8?B?RTcwZ0dubE1BaGtnMGR2RDJSOVlmcDNMbkFPV25sbkpRUmFLODc3endhRGZn?=
 =?utf-8?B?S0ZQeE41aUpYc05UZ1dpU3JUS0Z5emFxNXdSaUdqcWJhRkdNa2FVNXFHZHBX?=
 =?utf-8?B?UjVRNFhXand5a05KUWh1SHBoR1V3UVFjaHZWV1dacHh0VDUweWplbzd6TUdt?=
 =?utf-8?B?bFlSVE9IUGFENTNPZ0RZZHZCZ2FmSmxWcFd0My9Sb2sydXB3WS9kV0hUVGFT?=
 =?utf-8?B?TVBZWUZVYkNEQjFkdSttMFBHbFBoU1Zsbm1EZjBIc2V3TXg4SzVSZUZBWlZl?=
 =?utf-8?B?R2k0dm9iNXhwYzdlUm8rVm9jU1l5R08wSFBjUVRGTjZETVRIRnJlMVc4ME04?=
 =?utf-8?B?VTZVTWhOYmsyZ2JjZDgvYWxuM2hVaUFSNnJjM1dDQ2x1WDJIclhNQW11eWxs?=
 =?utf-8?B?OHk2b2UzQ1B5UXVGTHo2OXpMQ2JzcUQ0RlJmVEUrV1NPeXhtM25qWGNwOGov?=
 =?utf-8?B?MlpZYU44YThwOXdDMGpNN252b2NVMG5mSXNpVVZGSEx1dW1zV1FuRlNDbFdr?=
 =?utf-8?B?cUd1VmIzQktQYUoyeVhGZDRHajhnMFhNTHlIV21FTUh6dURraDU1RS9ZVGpU?=
 =?utf-8?B?V0FNVDRnQi9LMTlWYWdYbElhem15TVlWRGNTU29SclNnVU1ObDI1Z2pyY2U5?=
 =?utf-8?B?WGdTd05FUGtoeHRnTDBuTTUwS1Y3NXFPOHYxTlphdjNLaytZN21BZlhLc0dL?=
 =?utf-8?B?elNhb3ErTFVoNGJsWVNCd1d6OS81Nm9kNkhKSE56MWhBS0tDbTlkV2F1MUJI?=
 =?utf-8?B?aXhsRTVOTFNOTjFDWkt3MmlJQU4yRk5UbVVLQjE0dXNoZzVCc2dVS1JPL3hM?=
 =?utf-8?B?Y3hCendCdTJaNDQ5MGlzczB5YjB6OFRrQWJ0dzdnRDhwbzdSTWRDZz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b4a3db31-1d39-46cb-2622-08de7bae4b61
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2026 18:29:25.3739
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8rPVB6HjJgchQIy3NbKjOOmcH4XK6KusDMYpLZH4PGtfFmCuaio2yMkor/9Y42KZ/jTeSmRmKWwzxEbnfN1jiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6449
X-OriginatorOrg: intel.com

Dingisoul with KASAN reports a use after free if device_add() fails in
nd_async_device_register().

Commit b6eae0f61db2 ("libnvdimm: Hold reference on parent while
scheduling async init") correctly added a reference on the parent device
to be held until asynchronous initialization was complete.  However, if
device_add() results in an allocation failure the ref count of the
device drops to 0 prior to the parent pointer being accessed.  Thus
resulting in use after free.

The bug bot AI correctly identified the fix.  Save a reference to the
parent pointer to be used to drop the parent reference regardless of the
outcome of device_add().

Reported-by: Dingisoul <dingiso.kernel@gmail.com>
Closes: http://lore.kernel.org/8855544b-be9e-4153-aa55-0bc328b13733@gmail.com
Fixes: b6eae0f61db2 ("libnvdimm: Hold reference on parent while scheduling async init")
Cc: stable@vger.kernel.org
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/nvdimm/bus.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index bd9621d3f73c..45b7d756e39a 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -486,14 +486,15 @@ EXPORT_SYMBOL_GPL(nd_synchronize);
 static void nd_async_device_register(void *d, async_cookie_t cookie)
 {
 	struct device *dev = d;
+	struct device *parent = dev->parent;
 
 	if (device_add(dev) != 0) {
 		dev_err(dev, "%s: failed\n", __func__);
 		put_device(dev);
 	}
 	put_device(dev);
-	if (dev->parent)
-		put_device(dev->parent);
+	if (parent)
+		put_device(parent);
 }
 
 static void nd_async_device_unregister(void *d, async_cookie_t cookie)

---
base-commit: c107785c7e8dbabd1c18301a1c362544b5786282
change-id: 20260306-fix-uaf-async-init-3697998d8faf

Best regards,
--  
Ira Weiny <ira.weiny@intel.com>

