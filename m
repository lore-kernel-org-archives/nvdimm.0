Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F3A11E2307
	for <nvdimm@lists.linux.dev>; Wed, 29 Oct 2025 02:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761704367; cv=fail; b=Esem3wYuKjbYUR7BtCUBZYiqMbEws4w7nzeYP/StCkL983HF7FutH2eUfbOU138pSGsR9BAgLNSWyh6ARb0Z2oAq4O8+GJuRSdv55qjQPloSuMnxdahMuDIoVFFreIgCZhvF5GvVBipq+xnqOkhqlcwDO6aeI9Zo9qYMIT0JjE8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761704367; c=relaxed/simple;
	bh=mdGBPHEOkxJ/NBKI09X0u0uQtv4O+YJHNHgzTpxtS+8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QU9Esv04SAypeB1fhcfgpxfeQlBXoyuNVEIRPaZDIjRFTNEepfpt+4QSin70Gq8EGJ+L7nmnvOIxj9bTx1hKWL8qs5EhFs/ryviKJa68ecT1ghu/K6pHRjOOndCXaEzYrssgudagB5I0s+N1qwkVXwI4vanyZYky6J5o14VyH8w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hxmaoKnU; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hxmaoKnU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761704365; x=1793240365;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=mdGBPHEOkxJ/NBKI09X0u0uQtv4O+YJHNHgzTpxtS+8=;
  b=hxmaoKnUnF39KUm14DFAZ3VQZTu1FWJNDKwKhQuA6GfRLFAJNJBYltlm
   WLWjSRvqP3IVmvE0LvKjG8qfZGASC2c4thzB9PEhs23/vx5gfT1d+WhU5
   Py9joHETlid7HizXq61EV7JZscBbEbl87r/PpTkmwpZJF3Yaew9ICUHHM
   YC4l6Bd6XsnXLdM7o24aP77/aYcNNEu59IOlkUV6+LsqacbIHEMns1xN5
   OQ79lDt30Ot+C0NAna000o7j/aCn7gAykY99hUZV5efQ2/XdRiMStnAkH
   7LSCmxYXOe31ZwXt/S3LTvb+GYep8dIbCg1voBXwUENCGVUaneEHwVYIY
   Q==;
X-CSE-ConnectionGUID: oV1TOl8HRl+irRI/ewDZPw==
X-CSE-MsgGUID: UMZK/VkxRlW9ZYLOyjcJog==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="67651916"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="67651916"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2025 18:32:43 -0700
X-CSE-ConnectionGUID: Fkd37eqnTfqKWtjapUwpZg==
X-CSE-MsgGUID: UU8JD2c8SAWUQL2nsZXSyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,262,1754982000"; 
   d="scan'208";a="222731547"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2025 18:32:43 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 28 Oct 2025 18:32:41 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 28 Oct 2025 18:32:41 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.37) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 28 Oct 2025 18:32:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ewJfrnErdTPtHX5jSqfO3IvlsA1xQoAb+ljZg9/wz35mTdaUUV99Cq/DuaXOerfxuvsyb2LUORWKeHUjD9fL8QH6auba3rV+ZISF8616lqcHzJeyQKyIp7yAeA1um096BcfMIYZLJoXtHl6VsJWES8pc6PPvoiM7AY7GXfpUWw6Clcx4hrSmnn8qMhkVQSK9ohL2OqXpiWArbvQyEh+VIw8tZdTDsDeh+zULOMNvlQi01FfvG5lwmIlIvws8eXvW+IKYoPWf6rjrQbh56BvH2wJE01UQLgAU36X2vUt+XNGqz9casgVU+re6FSM7C+iA2tLP8aArrKHRcZtk28i0Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jN67K+yQm1PkHCWswdVoidlQNR9/ZI6GapgT6I+rPDA=;
 b=L5Vj6MmojzzgmZi2cKDj+YQZM+GP8XEA81wwUOkY7If9I/SQJ4heaC5G4kJw0XLnzH0g2+GzYc8GcTmLCVv+6GmKUkj4y5fQ4h+/+CDr6ZrHCURsX3wW8iS1SkkeiVJClepCE5aD04gMQ0dAaOiD4iAY/J41Z2u4XzN74WSb/U0RB3yyGyLmuS0BCP94GL1pEi5KyE+4hPcZLyrFVdQ4vCjUmB6s/slf8fSqMTjkndc1YnnoGfz/DzCpSsVBXO4JLnwuSCiyfpMyiC/mKIQfvr7lvtUzxOlx+FmeYX/2kRxYuQXyM1QKBuGAPIpD3oXLxQIq+VdU19raEIWZi0xsuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by PH3PPFA07D87DA6.namprd11.prod.outlook.com (2603:10b6:518:1::d3e) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.12; Wed, 29 Oct
 2025 01:32:39 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee%8]) with mapi id 15.20.9275.013; Wed, 29 Oct 2025
 01:32:39 +0000
Date: Tue, 28 Oct 2025 18:32:35 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<vishal.l.verma@intel.com>
Subject: Re: [NDCTL PATCH v2] cxl: Add support for extended linear cache
Message-ID: <aQFus3miLluq1gBS@aschofie-mobl2.lan>
References: <20251017224031.4186877-1-dave.jiang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251017224031.4186877-1-dave.jiang@intel.com>
X-ClientProxiedBy: SJ0PR13CA0063.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::8) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|PH3PPFA07D87DA6:EE_
X-MS-Office365-Filtering-Correlation-Id: e00c0b04-fc7a-4803-2c9d-08de168b0bcf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?pN7fPjBABJzVXtEa5/31xpd/4ZBaz7lUTOCgNnlmv6SFyWVf2Tj+l+dM5vY7?=
 =?us-ascii?Q?UJrqGAfIXow7k6BiRJfL/puq6hJKsUxlnRDj0NtIL0mdI5H/mhv5elJJiQMP?=
 =?us-ascii?Q?UKqZpMGQjuucYPoyyOko3GaCkZcFuFSxmkrDwnv3wNLKX4lqrl1JXHKq9RaV?=
 =?us-ascii?Q?xmZftcTNbweUtDUmJ2DFaKN4CzQx5+bppC7A98temvfIeO8gPxIK+mO99Z3G?=
 =?us-ascii?Q?26r3hJe1n8yym39mktBoiJrLlmiTtdEwtPlTn8fFLCtrLl9afej+vGjQPdMI?=
 =?us-ascii?Q?3bJlWWcfkKV0pePC8SPv3YWAYy0qVTTRoXxdgCTaoLI2zP1Xe4YDaKuNNoDf?=
 =?us-ascii?Q?JlXqIz3C65T/AbBPysh7ILmFUB+jwAVE/nlGWqCP4nEhDdZUtgbHgg7ZhQqs?=
 =?us-ascii?Q?P8hvjgwGTRiXvcksAXDpFMkmCzxwlr69uhMsht/qw0Kav5lD4yqPqScS/ukd?=
 =?us-ascii?Q?uibD0jFfQi0+/llyqcse9C0mDbK7fdZ7aCxP5hBw7d1B5JSmPjFrzUsbg0W9?=
 =?us-ascii?Q?TEJzykCOamZ95GpTP+9T/i2cRRfJe2qqEe/Jwgz68BfCX1lOnlfnJIrz3TPt?=
 =?us-ascii?Q?GiPleBMBD3olN06tzGIobf5gL7ZR0oTgc5uRWTfhUSLWZqjD0zbqQabckzJ7?=
 =?us-ascii?Q?uVhfydUJ+XDbp036kI9LUvLo6ZAN3pFZ58CcTK63CJ7wwHxgCUWceZxghHh1?=
 =?us-ascii?Q?lO01krEIyj7qx+6s5U1YibDrsKiukqavn7mLGqeYYIPQBrmth7OLSDeKh4Kj?=
 =?us-ascii?Q?fvxa5hcTuXRJWoWTxkkiXW++Fm2Wtc9kn7h2983DLLFW/3ISud3YMq4KZmGg?=
 =?us-ascii?Q?hxgkLVXu6jtzntmW+ArjkH4a9xUkmZqezSoknEaSBnNIPaRMpBjPWiZ2woj1?=
 =?us-ascii?Q?bOoBcWXHtwLEeX/zsPP/DfxOA09WqAzcCL1bRQbrXuVmga5S0DAfoc6a++tp?=
 =?us-ascii?Q?n/XfdihlLcMVBmlC1xGwLBaXqvzXmfGFYyd6rKywY3KhRK45UpYZzKk/yEaD?=
 =?us-ascii?Q?gfTXcUL3KUO2DkIvS5Qjm/+1WlB2I4n7anfcLXQof7+8R3YCeJnGFQlqun6s?=
 =?us-ascii?Q?yqMEMXzX9nKDqOHk1po2wI6LDVNFQD83dORfBlKU2Fnso6Q5GbPSJ5UQsrpm?=
 =?us-ascii?Q?W/z92lMTqfqTMAhm1mNqYjn5cKc4Xp6zjdCsrHTBDdyInxij9cNJtZXoRb3y?=
 =?us-ascii?Q?zO8YPHJ3o7QYfFJQ6mtyzClDHmXm557dzemDHxAVz0azrlK96NM6ZZERIEuV?=
 =?us-ascii?Q?nbkJZPmpooyA5BJRvCbwSQKtZSiRosYiApK7CAVKbP307M+l/CeckDhkJT9J?=
 =?us-ascii?Q?MyJkJaw0cbQKoN2NeH/lMav7WLh3UF9z97SUoDNX71qBQrKQNo2MK1D76Ty2?=
 =?us-ascii?Q?9YPdiQ1253fTgA0AnJhoO6ATV1FQ4xwMQ29lbTRKmMvaIxYISl3H3XROmw2T?=
 =?us-ascii?Q?/d0mSAMozZ4Ovwa7I7tb2pW/uImm8H1w?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CF0B+LO+UbwjFqu4MKq0BCpYIrOc7GGYzCufZcoJOyicpAqK85H3SLitOVSz?=
 =?us-ascii?Q?bgqCLBqY5Kr7lN5oNDp1dhyvBNgvsYZPMo3FcN3L85Y2XnpXsHoaCN2IINba?=
 =?us-ascii?Q?oBLr8mfdn+S8o922qpzrSmA5C2EzZ0x7phcbC+x9u48Kxmnqa/o9tXt7gzN7?=
 =?us-ascii?Q?0VsLu6l/Qw7DhyijZLBe93VDBqVecwl0jTDnQYTddloIn83ybU5YZ6iPXd7d?=
 =?us-ascii?Q?hidecFuj8pQOD87kBLME/4340jNlI5Hxl6jy2Dk7sYQTqTzaRFaRmeIqO1Rm?=
 =?us-ascii?Q?DujgFRAY5bpPX7BVdNW2jzNEi3a+wzWel63QPpTud3rC9UCIHKF07PNpWGIM?=
 =?us-ascii?Q?0YIB8+iTcLBkKdTzKIN3VzKTkpHRSYjcP9DnNQaBZIoYHDEka27NFHLaSPCE?=
 =?us-ascii?Q?2Oz25pVA33xdBf6XIN7jNnKf1vPXAu77npiglAE4n4EZKhTTXDSvvs6TSitJ?=
 =?us-ascii?Q?5LH3HIE/y51veboDX/QnOWLdmaDNegdHUyt/ba8ReyYCYdBT/vjXY87QO2kU?=
 =?us-ascii?Q?YgRMUEI1rQoDV1usXrLabGGE16LIsbA9nuUCKYIRjQt+ddsENyJHPQ5hBGui?=
 =?us-ascii?Q?KngyuQVRh98eDCMuJ0hrIG7ZMZBCQIOoARUsz2N4VsSCUE7Xe8cZSSxY9Zy3?=
 =?us-ascii?Q?xyjYZDspi04zPLBeF0DhLJGpFsdo9oLjk2IYJebpdOGOno/k75PT5yM/GqTk?=
 =?us-ascii?Q?oIsk9P/8FD2Eo+5gfMBpqA0os/qOVxkggfsnk7CeePvXSqVFBiFvf4PPRJfK?=
 =?us-ascii?Q?SNWGF805oTrCkKQFoBODhYGbnPP8Hv3esymHFvAPhiW1ja2PIe0xm0nwvdjj?=
 =?us-ascii?Q?Uu2OIQFD86kyA6SqybO6T/TA/wI0jDeN3NGlJbt0hOp0GGlNxfEJDozYx/W8?=
 =?us-ascii?Q?GtjIxdCLdMV/gwptpNZj2hDky98kMyj0rd2f01i45RVEr9CydCdnG9P6GKaI?=
 =?us-ascii?Q?PxqYq6xupkCZirpf7ol+d++mBfhGyn0x1nvwSh3hMQetKIqhwy1X2lMqRacY?=
 =?us-ascii?Q?ewIEJsGT/5zqVt0I94GUihPxx8VnkEiv++/JLet1mq5PebW7xZQREvBvq+fA?=
 =?us-ascii?Q?3FT5mju2ZCAs65P4lSt3P/uR5pt1QcCCAU0/vzCFTINDIonMafaWw04+sTTI?=
 =?us-ascii?Q?VwUxGBZ5bZif297SKMRkodIs6hIoOheOcyT6z5LRxdfeKLEGYxyqs5bNFTFR?=
 =?us-ascii?Q?VK2NU+SozAK72xF7XJ+uSIzmRtn4rv7vMGpazLb51g4SvrayIz1Y26YzZobB?=
 =?us-ascii?Q?NbtvlM6ggVdVAKXCYCJ2Cgh56sZ9H0h0/Eqm5MgKVRyYUDnWQKdT1IO1VIB2?=
 =?us-ascii?Q?Ovq/sYO0RwIGK+P9354gAmFFFFNbZk+fdXzI/7KNouGuHOSUeEVv2LSnr+AU?=
 =?us-ascii?Q?ChWJkiQfZHIfoq+YdNtQh9zRJuebZQD0V+BgaHWBqtDxSVTgXTphKbuaoCI1?=
 =?us-ascii?Q?LiW28L78MWq1cxEduDXRrizFfT2hQ71JJug6VY8xAfbzxE8NVUZnuoxn2OzL?=
 =?us-ascii?Q?ELuMvc973tGCTrCR4K+jyMmy0e5mTae1l4iQSl+Sx09byVxMqfQdFWW0yh8g?=
 =?us-ascii?Q?cm7C5pSDDRg3xKQe/KXtf0TjAJYkggml12lTZJzfnPgaOSAE9KI0Qamx8Wik?=
 =?us-ascii?Q?dw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e00c0b04-fc7a-4803-2c9d-08de168b0bcf
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2025 01:32:38.9818
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fBEspFyElPYBx/ZGG2F4pyx892/84dcrelPuzl+sPByuBJS17yZFWF+vCEWtX6Lodb8o2FUTz+Gb1ymO36TX5XSEr6nMdmHsGuelI3u7A24=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFA07D87DA6
X-OriginatorOrg: intel.com

On Fri, Oct 17, 2025 at 03:40:31PM -0700, Dave Jiang wrote:
> Add the retrieval of extended linear cache if the sysfs attribute exists
> and the libcxl function that retrieves the size of the extended linear
> cache. Support for cxl list also is added and presents the json
> attribute if the extended linear cache size is greater than 0.

Thanks for adding the man page example. I hadn't realized we had no
example for 'cxl list -R' previously. Now we do.

Reviewed and applied w this note:
[ as: move cxl-list example under "cxl -R" ]

https://github.com/pmem/ndctl/commit/01c90830d65b6b331986f5996dcf6ad73c1579f4

> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
> v2:
> - Add documentation. (Alison)
> ---
>  Documentation/cxl/cxl-list.txt   | 15 +++++++++++++++
>  Documentation/cxl/lib/libcxl.txt |  1 +
>  cxl/json.c                       | 10 ++++++++++
>  cxl/lib/libcxl.c                 | 10 ++++++++++
>  cxl/lib/libcxl.sym               |  5 +++++
>  cxl/lib/private.h                |  1 +
>  cxl/libcxl.h                     |  2 ++
>  7 files changed, 44 insertions(+)
> 
> diff --git a/Documentation/cxl/cxl-list.txt b/Documentation/cxl/cxl-list.txt
> index 0595638ee054..c8fc2252ce04 100644
> --- a/Documentation/cxl/cxl-list.txt
> +++ b/Documentation/cxl/cxl-list.txt
> @@ -409,6 +409,21 @@ OPTIONS
>      ]
>    }
>  }
> +
> +# cxl list -R
> +[
> +  {
> +    "region":"region0",
> +    "resource":277025390592,
> +    "size":549755813888,
> +    "extended_linear_cache_size":274877906944,
> +    "type":"ram",
> +    "interleave_ways":2,
> +    "interleave_granularity":256,
> +    "decode_state":"commit",
> +    "qos_class_mismatch":true
> +  }
> +]
>  ----
>  
>  -r::
> diff --git a/Documentation/cxl/lib/libcxl.txt b/Documentation/cxl/lib/libcxl.txt
> index db41ca788b57..5c3ebd4b786b 100644
> --- a/Documentation/cxl/lib/libcxl.txt
> +++ b/Documentation/cxl/lib/libcxl.txt
> @@ -588,6 +588,7 @@ int cxl_region_get_id(struct cxl_region *region);
>  const char *cxl_region_get_devname(struct cxl_region *region);
>  void cxl_region_get_uuid(struct cxl_region *region, uuid_t uu);
>  unsigned long long cxl_region_get_size(struct cxl_region *region);
> +unsigned long long cxl_region_get_extended_linear_cache_size(struct cxl_region *region);
>  enum cxl_decoder_mode cxl_region_get_mode(struct cxl_region *region);
>  unsigned long long cxl_region_get_resource(struct cxl_region *region);
>  unsigned int cxl_region_get_interleave_ways(struct cxl_region *region);
> diff --git a/cxl/json.c b/cxl/json.c
> index bde4589065e7..e9cb88afa43f 100644
> --- a/cxl/json.c
> +++ b/cxl/json.c
> @@ -994,6 +994,16 @@ struct json_object *util_cxl_region_to_json(struct cxl_region *region,
>  			json_object_object_add(jregion, "size", jobj);
>  	}
>  
> +	val = cxl_region_get_extended_linear_cache_size(region);
> +	if (val > 0) {
> +		jobj = util_json_object_size(val, flags);
> +		if (jobj) {
> +			json_object_object_add(jregion,
> +					       "extended_linear_cache_size",
> +					       jobj);
> +		}
> +	}
> +
>  	if (mode != CXL_DECODER_MODE_NONE) {
>  		jobj = json_object_new_string(cxl_decoder_mode_name(mode));
>  		if (jobj)
> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> index cafde1cee4e8..32728de9cab6 100644
> --- a/cxl/lib/libcxl.c
> +++ b/cxl/lib/libcxl.c
> @@ -585,6 +585,10 @@ static void *add_cxl_region(void *parent, int id, const char *cxlregion_base)
>  	else
>  		region->size = strtoull(buf, NULL, 0);
>  
> +	sprintf(path, "%s/extended_linear_cache_size", cxlregion_base);
> +	if (sysfs_read_attr(ctx, path, buf) == 0)
> +		region->cache_size = strtoull(buf, NULL, 0);
> +
>  	sprintf(path, "%s/resource", cxlregion_base);
>  	if (sysfs_read_attr(ctx, path, buf) == 0)
>  		resource = strtoull(buf, NULL, 0);
> @@ -744,6 +748,12 @@ CXL_EXPORT unsigned long long cxl_region_get_size(struct cxl_region *region)
>  	return region->size;
>  }
>  
> +CXL_EXPORT unsigned long long
> +cxl_region_get_extended_linear_cache_size(struct cxl_region *region)
> +{
> +	return region->cache_size;
> +}
> +
>  CXL_EXPORT unsigned long long cxl_region_get_resource(struct cxl_region *region)
>  {
>  	return region->start;
> diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
> index e01a676cdeb9..36a93c3c262a 100644
> --- a/cxl/lib/libcxl.sym
> +++ b/cxl/lib/libcxl.sym
> @@ -300,3 +300,8 @@ LIBCXL_10 {
>  global:
>  	cxl_memdev_is_port_ancestor;
>  } LIBCXL_9;
> +
> +LIBCXL_11 {
> +global:
> +	cxl_region_get_extended_linear_cache_size;
> +} LIBCXL_10;
> diff --git a/cxl/lib/private.h b/cxl/lib/private.h
> index 7d5a1bcc14ac..542cdb7eec7c 100644
> --- a/cxl/lib/private.h
> +++ b/cxl/lib/private.h
> @@ -174,6 +174,7 @@ struct cxl_region {
>  	uuid_t uuid;
>  	u64 start;
>  	u64 size;
> +	u64 cache_size;
>  	unsigned int interleave_ways;
>  	unsigned int interleave_granularity;
>  	enum cxl_decode_state decode_state;
> diff --git a/cxl/libcxl.h b/cxl/libcxl.h
> index 54bc025b121d..9371aac943fb 100644
> --- a/cxl/libcxl.h
> +++ b/cxl/libcxl.h
> @@ -327,6 +327,8 @@ int cxl_region_get_id(struct cxl_region *region);
>  const char *cxl_region_get_devname(struct cxl_region *region);
>  void cxl_region_get_uuid(struct cxl_region *region, uuid_t uu);
>  unsigned long long cxl_region_get_size(struct cxl_region *region);
> +unsigned long long
> +cxl_region_get_extended_linear_cache_size(struct cxl_region *region);
>  unsigned long long cxl_region_get_resource(struct cxl_region *region);
>  enum cxl_decoder_mode cxl_region_get_mode(struct cxl_region *region);
>  unsigned int cxl_region_get_interleave_ways(struct cxl_region *region);
> 
> base-commit: 38f04b06ac0b0d116b24cefc603cdeb479ab205b
> -- 
> 2.51.0
> 
