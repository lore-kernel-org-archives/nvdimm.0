Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C66A33FD
	for <nvdimm@lists.linux.dev>; Thu,  8 May 2025 02:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746670491; cv=fail; b=Sz7Qty7m7HpVVzI0ReyCC9v//LDW6qTDxo7D08Ne4GmZe90WrkaSW1TywtydLmIomnvxKB6Mv2LkUCMWQ6bmWsQgCH57vv5hTUJSKJiIHik8KDn6f6Qlw7LZBkpn8uSUP1PXg2BkIbaPhtThC92R2lCs12/PcGR0bHJp0TBujIE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746670491; c=relaxed/simple;
	bh=90jWswMCGSbXZ26sFAfwPKSV9ElHzOWOZbj8qjoiRO4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=MPnJ+8XwRq66G8ii4gN/oVdq47ISjjnZfShJuuwPn0AWrzuSc7l9DvOUicMduV/g7ONj9FrH2xQTtza50Z01fLYHEA+KKSjqxCoehW9U2XMiVudTgUVKVGmyec+TkrD62hi4kBkLRcy/Tk0BorjNAkkFAQqHJTbtADiW5ZwpRz4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DM0G4x0b; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DM0G4x0b"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746670490; x=1778206490;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=90jWswMCGSbXZ26sFAfwPKSV9ElHzOWOZbj8qjoiRO4=;
  b=DM0G4x0bYrVEQJ5X8Tae1kylwGY1s4vUUUZI9aJVmThMMtc48ko8kT/V
   CCbFTptq1ZSolP/5YeMbisj/TqAaUSUYwsTr1G0NlIoiFTRtqucpbjqHt
   dFmvww+hEUwoSDVcHpkQ3LdBZguVETLa8puGUuzEkPCUcO355TxrPLErS
   MjluYI6NNTwA03i+cxHmkEG7olJ590M+9G4EjLpPKgMzc+q/yDm083N1U
   OeREnBPa81UVXaCzPKVzAsEvdOzodnnT5IZdAto2EXo0d35tP1qMKCBy6
   RhN6OP/UTK1ouh1eAwJn3c98BVDBHq78BI53A/EG4LNDysPkuNd5qvihi
   Q==;
X-CSE-ConnectionGUID: ebgzumpxTneaLUOhiEZrNQ==
X-CSE-MsgGUID: iNwUUJbYSV2tIkDbzVn+6Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11426"; a="65964383"
X-IronPort-AV: E=Sophos;i="6.15,271,1739865600"; 
   d="scan'208";a="65964383"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 19:14:49 -0700
X-CSE-ConnectionGUID: T/h/Y9gASeuMKihqFx/umg==
X-CSE-MsgGUID: FHhCVMCESyKVjal+XUtVzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,271,1739865600"; 
   d="scan'208";a="136538800"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 19:14:49 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 7 May 2025 19:14:48 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 7 May 2025 19:14:48 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 7 May 2025 19:14:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w+ZE7vRfvFBhZN5+Uzon+Z1s+ZZhiuGyi5LrzYHPfnuniMcSipCbT3xGT5jceDCZ5RAwQV0I8bEgqRFnwN6MUaknuIQkUdVt/9O+ZF6W4zazT2WkPVSjzL+nIg2hjDPt1FbJCkLWyav2siepVkj5LM9Ex4Y51h6+twi/GrKwc/p30ztlWAiVtOkhQmEIqmHGGjjaPvqMmrCddKhZLSHo54QOFS13R0WKVSWuRBnSBNV0H8SEZtA/aV9ek4NNxMjGn/9Yob78UCcrFAM4voDBbHVqI8dj2LgxjeZ4OV1cm+itgE8aNt2VqKlkUIYly5eR9D4lEtuGo55fQeLtaEnRGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NTET3XIIzHtkmZPK3eWZK8UytAOvEe/8IZLBJ0YDwB4=;
 b=oC4BYbcPjMVZXuiv3zSQcJUEzaJO800GrkAuKk/NejSStbgazBYPeMIQMCZ37RR7Ds8bmIHJorHV/YToZKeUK3kJ+giOzwVNPZKLIJwyfva+v6OqzwjyLuislN8igDDklI1+K9VvtMz5IWkZ3+/m0+0wsuxABgL8un+0XVQfpP/axrIto/K9x/xBjDzzvjsjjGaWwpuS3ttIBBWq2hX+Z2dzRnxrDb7H2O2DYEq7VJDMi3LRllN6VDpsgLEV8fu/xTm0/w04j2nOnOl1SMAuzpzW4uQ9zBT2cGBabV6t/VSNoaxWEjlXf2Fz0dwHkXxbavxuFqtTvAvxEbJJESiI/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB8794.namprd11.prod.outlook.com (2603:10b6:806:46a::5)
 by IA1PR11MB8198.namprd11.prod.outlook.com (2603:10b6:208:453::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.35; Thu, 8 May
 2025 02:14:35 +0000
Received: from SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720]) by SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720%5]) with mapi id 15.20.8722.020; Thu, 8 May 2025
 02:14:35 +0000
Date: Wed, 7 May 2025 19:14:32 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: <marc.herbert@linux.intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH] test/meson.build: add missing
 'CXL=@0@'.format(cxl_tool.full_path()),
Message-ID: <aBwTiAv3D0R95sLq@aschofie-mobl2.lan>
References: <20250507161547.204216-1-marc.herbert@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250507161547.204216-1-marc.herbert@linux.intel.com>
X-ClientProxiedBy: MW4PR04CA0173.namprd04.prod.outlook.com
 (2603:10b6:303:85::28) To SA1PR11MB8794.namprd11.prod.outlook.com
 (2603:10b6:806:46a::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB8794:EE_|IA1PR11MB8198:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ad861f0-1a31-44a1-cca8-08dd8dd613ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?c3bgnb42frofHM94WOfF8nUwEYbx9ltHhN3kZYKgS5Xd+4q3HwU9OXa5iZfE?=
 =?us-ascii?Q?+yrO3fek4/BbfLuwhsMwxwwJApviEFShAQ1+Sj8oiNTC3boNgHhVuCejiIDk?=
 =?us-ascii?Q?ZqJu+hOop3Z/aEIj8QNacrXyAo/58gkrK+LTWNIifW2nC4/mo2nwB6Gy71wQ?=
 =?us-ascii?Q?qNP6MMQnyxjZKp+jnrGsDFzBoeBBEP8d1jYzmvEYFcYnf3e49uCxo9SHJ7Us?=
 =?us-ascii?Q?/HhJT24wyaXnYyP5Z8b0ukJih8fbfuJnahltlInjq08qaBSUYcoVeIVqU3Gg?=
 =?us-ascii?Q?5n5hKT/aKgeL2gdvRbcifq6/AnE7TXxVqfS3Vm50LtUadi933uy3hbwpYik2?=
 =?us-ascii?Q?RYhjQvpdCp4XF1T47CYdMedwgZO3NumobuNp/bp5VZgv+euh/31Medw5Kq4+?=
 =?us-ascii?Q?abxZCTSg+d+QbyWl0vpbXdSOYK+HPLWXO8okWdFYNwDKMKiqtURZVTkVlwWT?=
 =?us-ascii?Q?IoL2AsllzNfb/hMEPBhv+TAFLuswNYRixIoqRd3q/5MOX9ASThpX+FCGQs8w?=
 =?us-ascii?Q?Q4GQnMGpN2VmWwZdreynsSBluh0s40bxeIupjSfaLHxX+Q45bt52buIcqBKu?=
 =?us-ascii?Q?C61BY0NQpU2i4H6ezdbkAJZlrmkOlBnwr5qsl/RevxSNHYSCe29yFpdiSjYH?=
 =?us-ascii?Q?M+Tr5psfXORksU8KoCKlHObsoMtHxwDJJgopp2iCb+iMuZ72OqeqGHir/PcN?=
 =?us-ascii?Q?YSBHwgdCUpK1+2XGMVfMuGtc9Qpvw4BwXLkeNhxzlum/YbzJnijUVlqd4SqL?=
 =?us-ascii?Q?pvTRAzd0YAj6fOoeuk5ZrNgZtHj9aVKhA7NrjdwRw5bLYXpotyYiW223w/VS?=
 =?us-ascii?Q?TtylFNVQUFRPqIJmfvHLRJhy+GFYHebkEcsrmHgWArjioEbPG2U8CsjnqZ/8?=
 =?us-ascii?Q?V7d6s4euGAET8IBDYp6vHYL5/soKqndzcjmisK2VwqUo/1sjfz78eV7mT9/e?=
 =?us-ascii?Q?XZOcFRbhLjw+8kMaQOp7BRkX1vf1xRykqlrrhL9dZnIh//TVLGa23xWeFDXG?=
 =?us-ascii?Q?79H7pfjRCFhm6J2nKhfk9KhpOTbGnxTKlBXq0dznraAhVn0sDulnJVXJvng5?=
 =?us-ascii?Q?HB+e+OSBvRcQkxCZmpzy/l0O1MvFajYo2ZHLG0qaxAMWb7DKVllrU8OmQDGt?=
 =?us-ascii?Q?ruyXlpx6Cc/Qa/NpKpoDYCeNAPThAkrJwRYj8Rh6IpK0TyCHIS6bOq4wsT5N?=
 =?us-ascii?Q?YAxBfmqNYSxzk7od6Pb7JVHp2MSablSXkRoMsAlTgv1zBkPJvW7HOjf5uTyg?=
 =?us-ascii?Q?wAe39/yYIKtc8ACfOOIjUTWojsiTxDm4bfUpIsa6JgSK+X2jt1kH4jItDf15?=
 =?us-ascii?Q?1ae+PzyvUWwbLttWUxnbCf46h4mRjuHckYtN3BXIFg6uCUsbAERPAudnvF2c?=
 =?us-ascii?Q?UL1tw0bI/jwGSNFcs27h8BkHAUOT6odzPiN9JTJRa2i5xMS8m5KRVNg4qAeI?=
 =?us-ascii?Q?81MuvBzdhy8=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB8794.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CQXi+3laELj9xDRSquPe5Zdw/122w5qqCcm3XIhuZtoVtWV2EMeZUIZ+atyp?=
 =?us-ascii?Q?8cc0XEfa9+DlyeBwmR10LkYXd2vk1hzPp9u7J50k1ZcT3rBXF0Vu1faoVlzV?=
 =?us-ascii?Q?1dsnWHENJrapMU+SmLhwUEoFwp8W8oORcBqVVZ5TSo2QdJ4XbmITl5GJzBLK?=
 =?us-ascii?Q?lV68VFP3JiOodkLyXrM4CnesvbKTkuYbxpdeKpPnqKF6r6+ORYZfZcLbFLIg?=
 =?us-ascii?Q?atW/jVui9BIwkPP+0YHApvE2ALAGXd1h4a+cZDlEs0laQOjso46NZQ+Q/QT8?=
 =?us-ascii?Q?XJYSB44TVfezv+1ouZ5CWLCgXCP6F2/e6lb7UJTbKmubQHI41QA3LpAcSz98?=
 =?us-ascii?Q?UFujiYvww31uA4ufbDLxo15stM5rYWElodBUlHOTY3UCqNzJLzZlZZScarrc?=
 =?us-ascii?Q?J/4RMV/fY9oLKYZdiK0IDDaUq/ZvrCpiAsD5mMVkKKY+gfBbeyQOHCtIZFHW?=
 =?us-ascii?Q?x4zLkYFj4n2Pd4VaYHP8wZGtIA0aKFgEXBOwCz9I5pxGf8+KthXU84ZlmVcG?=
 =?us-ascii?Q?gMkr+Z7uOn8j14MCDn03MI9xoWrqRrigCMdn1bkBuCwO14cjQ0JysRa4svDz?=
 =?us-ascii?Q?xX6VVI0X7SSq/S5SgEPqtE5p6LtFPE4nqc1vs1SeDr4ufXAWBG0/ZULA8m0W?=
 =?us-ascii?Q?/XrgW2w6HB4bKVx5eAawOjPow34WiMGSiDyqiW/YYzi8WjKQbD8+QUYeWxpA?=
 =?us-ascii?Q?FgH2vTy2fhqqRqzsgdy9IswAA2LkI69aXY9lGLQkWCMOIsAlMQ5Sc6ui03c3?=
 =?us-ascii?Q?AAvqABsvkzRbk1eWYf5Png8u9U6F/XNJ/FSE2Uavoliz0ozxQNLbLEIRXMbm?=
 =?us-ascii?Q?TYMlcsyYeSEzIREiz3Av+GPOxABKPPTvR2I/kh3YNNKpndV84dSh5czLzOui?=
 =?us-ascii?Q?jOPyUpuNQcWL2zkgqegcwjjuihp+e39Ps3qDtzzNqgwggK8hAsFS4Pr2xHAx?=
 =?us-ascii?Q?88a8IXEWZLkLmCkx6XPNm/YRUU0xJU5MekXXlD+dFyWlXHav9NpEx+jmYA1y?=
 =?us-ascii?Q?/FcRfS9Vhx1M/yqw68+Yy2nuvY0/PT7x++7nOln3RE1dLVktVkpWEq8D15Md?=
 =?us-ascii?Q?jUkwftQhd9caWe50n55YbPyNR3ZuMxHCeb4HZKn4lJ8+HkX1/nADqF1vXpot?=
 =?us-ascii?Q?3V3OgSWmfU2dHY1gMe+dzlXpNOgamEWS5c4WMz5PlxT3uNjSGAf9a8pNdlFo?=
 =?us-ascii?Q?Zk1KS5xJguz5u9crIHIPXXOV+A8tIXPhRFxo6eQY0QV1unVIt5ZzOn3D/cPU?=
 =?us-ascii?Q?pc9hQkjYgndA4W8Cs9ncQiHfO1sXSafIu6J0w/YjqsAMIQUSaK1I2wLgisw6?=
 =?us-ascii?Q?Yas8gZ+4yohPehTnYp4aw+qTRr0+ALtqOiP13msXOYRfARcOpIWO862NMM5s?=
 =?us-ascii?Q?pmindQkav05L9Pg0ZS7GSdmgSmbkJrcI8PCI4Q04WjVPy+eh7VAl5v+Kbdt/?=
 =?us-ascii?Q?dz1hJKuqrZYChVGonmAHoMnEnDpmbRhPhp3HvQOko02qG/qgUPoCKukYjx9E?=
 =?us-ascii?Q?oEITElXxrMYWp3l6m5YRJkisG6ssLR2LZOu+CwTGtgFqIAfNEHaiNfo/KfLr?=
 =?us-ascii?Q?9TqEDcJ0QMLXS13JcHACcopYLoSTfyN1y+c5pzZ/FgjbOSVGcvg26PQzWujx?=
 =?us-ascii?Q?sw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ad861f0-1a31-44a1-cca8-08dd8dd613ea
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB8794.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2025 02:14:35.4510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GIcuqSMLTm5NYo7kgzG3AJcjF0zZ7l9vDVp+9OqcjEFtiFosZ8D1JCXXDzTRze3H885Eyf5ExTjhrOCuq++kFjl9CXT/Ssujt9NfaPKcyJY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8198
X-OriginatorOrg: intel.com

On Wed, May 07, 2025 at 04:15:15PM +0000, marc.herbert@linux.intel.com wrote:
> From: Marc Herbert <marc.herbert@linux.intel.com>
> 
> This fixes the ability to copy and paste the helpful meson output when a
> test fails, in order to re-run a failing test directly outside meson and
> from any current directory.
> 
> meson never had that problem because it always switches to a constant
> directory before running the tests.
> 
> Fixes commit ef85ab79e7a4 ("cxl/test: Add topology enumeration and
> hotplug test") which added the (failing) search for the cxl binary.
> 
> Signed-off-by: Marc Herbert <marc.herbert@linux.intel.com>
> ---

Thanks for the patch and welcome to ndctl !
(where you get 3 replies to your first patch in less than a day :))

Please update and send a v2. Then there will be no
[as: updated commit msg and log] polluting the final commit.

Prefer commit msg:
test: set the $CXL environment variable in meson.build

Thanks!
Alison


>  test/meson.build | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/test/meson.build b/test/meson.build
> index d871e28e17ce..2fd7df5211dd 100644
> --- a/test/meson.build
> +++ b/test/meson.build
> @@ -255,6 +255,7 @@ foreach t : tests
>      env : [
>        'NDCTL=@0@'.format(ndctl_tool.full_path()),
>        'DAXCTL=@0@'.format(daxctl_tool.full_path()),
> +      'CXL=@0@'.format(cxl_tool.full_path()),
>        'TEST_PATH=@0@'.format(meson.current_build_dir()),
>        'DATA_PATH=@0@'.format(meson.current_source_dir()),
>      ],
> -- 
> 2.49.0
> 
> 
