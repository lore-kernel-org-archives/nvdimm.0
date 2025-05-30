Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FE711514F6
	for <nvdimm@lists.linux.dev>; Fri, 30 May 2025 03:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748574407; cv=fail; b=Rt/vE4DQr39yQmFrrHSfIuO3akAOrazO1MRfPY+QKEatt/HS5Ev0kNUgCewdEkQq72nMXqFn5SXZtSzPmDUdYRsNVAUNQr5YZk4bZAx/hT3Gmr0dAFYkAlu3OzO3AtPMsi57CDbemCZsu9GvFxoMDm1Tlmen8omjsVf2ykBC8k4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748574407; c=relaxed/simple;
	bh=BjnPN1ebf8NJ7oy42OMNlPaS8m69LW6LZjKvVaZeb3c=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=sMcLuRQSNyBAJa7f7NA1H4ou12o1U75rHgfYsYFT6N0vVaHw1yuYwJmVndF/RHI4WCUkk6+ztF88r2tMucXS0BbI8uzHDYmNMzYQAkl8cPnMmbYr3gazSfTBC3rQhef7WT+AFoKS9c4GVGL7INOUBHI8ySxv9dDQRDxKWpYrz3k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RtPCOjBy; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RtPCOjBy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748574405; x=1780110405;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=BjnPN1ebf8NJ7oy42OMNlPaS8m69LW6LZjKvVaZeb3c=;
  b=RtPCOjBy8Gzr407pIsBWPAB7wDU8YzO6ThDCmxbID1kEgQyLWttVVyWt
   ms/2la8hhnJ4KC3a17f2qKLyvQdJZQx4gGLz+iUlQQdgJnGo5F+IfrzJB
   Vahe7hZ+1FupNRpGL+a0vh6Ntb1JwSXPhHD7xq8K+0P5UKWw+dNJi65RF
   oVMsuG7CZFd1erG2kLSvg82vyRNt6H7T6DGYb7HD1u7uVh4FPPEuxUbe8
   OU3AkTAoRB+Jm2YdErpzXQ+uJZ4duvlhDdnEOwoY2Up3JDPuV3kYVSyWd
   D4Zu6pS7urPxTYFnEASGzn0M8mSEftDFBL0Xr7Hbf/MYrTfVaY8fipNJJ
   w==;
X-CSE-ConnectionGUID: K6L0DZqpQt+FJa6D3ysL8g==
X-CSE-MsgGUID: nswUHz3yQimsguEe4sUdWg==
X-IronPort-AV: E=McAfee;i="6700,10204,11448"; a="50582076"
X-IronPort-AV: E=Sophos;i="6.16,194,1744095600"; 
   d="scan'208";a="50582076"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2025 20:06:44 -0700
X-CSE-ConnectionGUID: 87OOw9bjSNKmWJ7QD93Eng==
X-CSE-MsgGUID: k9JkCkm+S06WIySqaYY78A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,194,1744095600"; 
   d="scan'208";a="144732196"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2025 20:06:44 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 29 May 2025 20:06:43 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 29 May 2025 20:06:43 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.53)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Thu, 29 May 2025 20:06:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dJhUS4hA3U1I1q3h9fBowETAln/xt6WffGyF0XPFVEAgptU40ilsHq/veEZDvBkJDM6GyRGgBQSiMW0Pz9lkSF/AV+dGGQJfmYR8IiaVZmZuCN8igNjpR1cO/KHng7Hta8sYCC10MEUCiWodyBUcK2upqYMsHFJzVqeNefBvHzbMp432Jt53Z7FcP2ZuwO6Q+IItrdT4gvJnG1rOqxf/12qyMnNAkTGKCtbCJldHZh8wFA1IBEoJWFksa3mbSiY00T4Go46V7lD39IjVtjsYRS6aqNJZBkaiO3D+cXOaKCx4ek2tNEc1uhhOQnIsqL0J/lOR91sPjh9B5gsymt2ytw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aUCwdJpsA9GzQjHPIreroB5UTyw+ULUaBpvA7kx0oSU=;
 b=n0ezzr/kspkz0IVVILzIDnzKR0IJ7rxYic+ApGSr4OiZ4q3m8we/e9svKqqHFlcd81Jv5tJl01chflEhltruWEGdfs0AH2eoWz2SVIIYhLiYlS99Sxr6tc7Ny0AdO8R05xDdV1Gf+sHfwnFMcfS13JrOtqqBYQIcyVddYcKVW1fySDVGCaYNNVqcb69GHxEQFiTTWUHiTPqa+gPJAVbDI7evVsHGIlELf+oCHoGLlqay/hHbPiuXTnCykI6Ek5AKK2D2CaDt8H9eB4k9yMIAyhe3TYMoHhmhuOg4Pa9YuEYCBNj3YByBFMQIS5y0od3AGJjivhnlcBXq80ASLdgT8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB8794.namprd11.prod.outlook.com (2603:10b6:806:46a::5)
 by DM3PPFE94346F35.namprd11.prod.outlook.com (2603:10b6:f:fc00::f59) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.26; Fri, 30 May
 2025 03:06:14 +0000
Received: from SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720]) by SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720%5]) with mapi id 15.20.8769.025; Fri, 30 May 2025
 03:06:14 +0000
Date: Thu, 29 May 2025 20:06:11 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>, Linux Trace Kernel
	<linux-trace-kernel@vger.kernel.org>, <nvdimm@lists.linux.dev>, Dan Williams
	<dan.j.williams@intel.com>, Shiyang Ruan <ruansy.fnst@fujitsu.com>, "Darrick
 J. Wong" <djwong@kernel.org>, Ross Zwisler <zwisler@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] fsdax: Remove unused trace events for dax insert
 mapping
Message-ID: <aDkgo81JQykBKCY6@aschofie-mobl2.lan>
References: <20250529152211.688800c9@gandalf.local.home>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250529152211.688800c9@gandalf.local.home>
X-ClientProxiedBy: BYAPR01CA0017.prod.exchangelabs.com (2603:10b6:a02:80::30)
 To SA1PR11MB8794.namprd11.prod.outlook.com (2603:10b6:806:46a::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB8794:EE_|DM3PPFE94346F35:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d1be733-c86c-48cf-1cdb-08dd9f26f00e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?1P1htbqwr5s/LWoat9VywQnbAMXTZ/5lcFop3EsptLunq/T8zUuFC4ry62p2?=
 =?us-ascii?Q?i/CwU52hKlq/M1mi0sGT7nFny4ihJ8WxG0Z9hfyS/L7wL/nonz6qwySN8oh2?=
 =?us-ascii?Q?ZtDOHEF0S64Hyy/QHjtFxrX/zPTI037h8iIh9IzNbIkI8weAHT0h5CPXIh5Z?=
 =?us-ascii?Q?E7IXY45ZW/UhT+oWLAimeCVOgCqKbY/zUFqD6KT0QXpAIYTMOpoMqDoLVeu1?=
 =?us-ascii?Q?sD2dMp7pJ5uSQoFRbzyyTdiDn44hSQF7QjN4RgKDrkbZteQta7BnvvSwegPt?=
 =?us-ascii?Q?BowXXO8+W4ul0XAgfzTeUGDDF66ZnBbS8TMth2FENNQDuVepewpB7qXVJeY6?=
 =?us-ascii?Q?ukyJcAUc8kCzm5pCoTilowpon41o1zyzwfPt8PRGwYeAAxju+Iz06WfgywrR?=
 =?us-ascii?Q?xZmiCdzv7bosu0L9Op7PTuKrPCSTBOmlkS4keUkpalQRM0X/hg4EOcDbRgil?=
 =?us-ascii?Q?FvokIgmaKXKSnLSmnzqszsUj6dXvKH5e1lS9FM6NmYwDcKZ5csBfeYMpVMQL?=
 =?us-ascii?Q?LrLApCQSU8mYUFETsabgCuOapk15mXW2zFYAcyVJxqDk8IZwBcluh8loKZZ+?=
 =?us-ascii?Q?8/qxOJT4ldOijcg5ua51yMqZhYiS10bkdAMazhGqeoBspxI3kG3lkHyTCYAF?=
 =?us-ascii?Q?2BSvOwZzyp1RMHItCcPIJoisDiVMYNiqr/m21E0qI4uaNOwkgY7Rs8rSRO5Q?=
 =?us-ascii?Q?DUIQ3lXX5Qhgo0F3DL8crBTmdWVagxRs3RllgDN2/kpFwJOLeftFeC5zaGQ1?=
 =?us-ascii?Q?68zGymvfIp652mM9y9E02pESj8kEwIkh7cDiWpeNU1psuKA4yI84Wam9tBuA?=
 =?us-ascii?Q?WH9gDHAiUjmSrxjFwv8U7mejV5ZcXlxGGHRW99nupIgl/jVgx0yyiddaRafy?=
 =?us-ascii?Q?GWmkU4f8klt+PC87P3B7NQD6LLoiKyS6SIU14KgVbHIjYDDatWAtDsLHoNCQ?=
 =?us-ascii?Q?cdW6b6vKf0uj/mce+aemSrsRF48Mnif3hZgyiZw2GgZYrL1veCGyf9zJPozh?=
 =?us-ascii?Q?s66gAXQQeCQNFG5DgggXPRObIEHGLQceGL0UDlDIVZfff9bIFxfZFDH04T9d?=
 =?us-ascii?Q?sn7CGSysR3IHY688ZYj78axDBwPR2HaLx9rc/lEDxoYrLPVn0sBNXP1KrEEE?=
 =?us-ascii?Q?ANkoIvt/XKNYv1OklyX8iyHBQWm73/i2vG7smMpKsS+kF0W3TiVw/qvvwyJk?=
 =?us-ascii?Q?yBKDYXoxrkIrorRAbQTzorAVPuWoz2NTI77158r3w8SnHVI5vuZOzVA8Ls23?=
 =?us-ascii?Q?VL5b92/H4CUE1GyJj0IoVWihDQmpBw2nVCHST017ZF6oeZZAS1VVhPDXN19g?=
 =?us-ascii?Q?hXZWKVqc3WG08AJw1HGI9Ci23VunyV5keJ5T1qqDt38GUKJFE42T/xO9nolq?=
 =?us-ascii?Q?OYYVEZjpq2BTveIxHJK9Kbz18TNSCIbryil/KFkbd4giOFqcP2bbzEYDInmW?=
 =?us-ascii?Q?+jmRvUtTzOVQX8ITaZbDY8rHTnSDDqG8?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB8794.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BfBW/R2/efjdBj2Fci8DmdBeZ8jZGEJuYu/fGqwtwaVr8dkS5xcnpIaPEjE9?=
 =?us-ascii?Q?LItVnYqKq0odv+Kua3/C1mLZx/iM7zlQGVlco1GzwbjK7wEYysmiWdI+rS46?=
 =?us-ascii?Q?aG+If7In/vARQLFAbwKWvBKn3O2CMTIZ3TRPJCWxYzk3LULl2po4eekWM8Nr?=
 =?us-ascii?Q?SBJz9Sg/pOlVhAgcE7l83wM/B+CBYFASVrH4LWp50hlv24Wr1CGvomz1l3z7?=
 =?us-ascii?Q?Ekpg3a4Zw9P1PmvnFma9zHEMQ+QUGRuIic21V5zwM5/h0aQltmuiRkiylhwF?=
 =?us-ascii?Q?0IxdDLPayASxEn7CUeuubxFne/lHNPP6Bma4qw2NCUcfR4HJd/wp3DwzFTQc?=
 =?us-ascii?Q?IQSHPrUkug/+aty32h/oy/ijlD4W3gIfD3ifFo/JQD7PvlclzEMRDIGC3gAk?=
 =?us-ascii?Q?TCjnEuoJzhEvu56bZz4n/SE9w+vxmxffR74DoE7MV0n61mMa9nxUjUoPBwl2?=
 =?us-ascii?Q?oirDtAh7uwrA8lda8xe6Ir1zKQVgpzoJF8qqsPkrPUm9pYY9yxBT/V9g3fWE?=
 =?us-ascii?Q?bSu5X3u5MMCRovQgTJiKjM9LGxIY11XyMqEgRPd0JPI+0SSa3SjYiMo9mCbP?=
 =?us-ascii?Q?+mJqk40efjmVHc38jRL20CjrFbxg8oX39gRL+CgVckTCtdtxAKwOJUB0eeEY?=
 =?us-ascii?Q?NLSfw4aaYKaihALe2URgoZh4q3KoBsM37CTwb/hx0bFU4OdKmwPjUk9r8AmS?=
 =?us-ascii?Q?lJBEwdjTiybO2C7U08DAsaqFGTPQ8FeWKbb9GAh32l7Ov7h2F6r5iAYXcmJT?=
 =?us-ascii?Q?cMHbfrDmgUHMY5ezViak07w8+DSarGdiQy9rUaMCzPdofF6tJxmCa0/wee0E?=
 =?us-ascii?Q?tu5CDgj3atBF8l5lo8lzAp4jALQa8BF/1i+R1meFuo4H9p1EO03IE4uwip7t?=
 =?us-ascii?Q?7KfIl0GMYvNqsjAN3m6/UdoYUoRb2rqYwUvwWwuTTNkoQ1OHrVYUOuX1/wSE?=
 =?us-ascii?Q?TgH00pqoFXB+oSYgiOxRgXx464/Pxa/VUgtAU/M/yWHpuPq2VHdvvYYiZ84b?=
 =?us-ascii?Q?9L5OJ6S8T1VO7pjfQ5ENikmryq1g0Xy8ZmR0lGepaxDHCsERqja8CtWc1QOP?=
 =?us-ascii?Q?ApdSVgOuAEVfAYjr0DglyP/BC/BHttI1KcPSfFWUKIg497fdBy4EKwOhQE3P?=
 =?us-ascii?Q?WVCLOn+Hc0slp1Gq3zZPWJmPsQCwUydUwWxmhQknhvt97VULhGz8//5Li4SH?=
 =?us-ascii?Q?Wp/+E73hRwADmCbdrpR3e3n4k2ZgxZ2PoARZxEGUTSdbrRAx3t/4Qz0+S2dB?=
 =?us-ascii?Q?7hil7ZETQ5XnsMODJSsvEHzEQX676eFsHo3heEv4JyvAz+pc5oCJY6RuhsqU?=
 =?us-ascii?Q?mPI9g2DLr8AJK0crBJu2/89ZYldNQoYfcN4nc+79Xnid85n5dljkI6+CAFnh?=
 =?us-ascii?Q?ugR2XpqTR2p5/aN6641kKaKvdM6d92oDLY2vmvZ5rsuceFMv1Q7OFb2PUGRS?=
 =?us-ascii?Q?b78nzEHi0Zs89Ri2g088YHWRR2ZcukO5cUtxBpHNaATR42TSTWN5g8ZjONiQ?=
 =?us-ascii?Q?myZJSGEFT0LJDMrhFWVmnLNQiOgTnEuggiiGr/dtK6Xm/EEgxS07GQZtPf2E?=
 =?us-ascii?Q?AYRh0vUERZVVAFnZ1TgA4kLWxxCXsAdylrbxMXOFVITzYWaGaggcP0oF5m6z?=
 =?us-ascii?Q?7A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d1be733-c86c-48cf-1cdb-08dd9f26f00e
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB8794.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2025 03:06:14.3960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AYVaeKKiy2NFTZE8/SK+vBMSYuiomRaHcG1+fyWty78GsaswgEXWic6sgiuz3bKSCLJY+UomtixSLr7YzYxk3HiWkdFub4jIQFlyRUiaSVk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFE94346F35
X-OriginatorOrg: intel.com

On Thu, May 29, 2025 at 03:22:11PM -0400, Steven Rostedt wrote:
> From: Steven Rostedt <rostedt@goodmis.org>
> 
> When the dax_fault_actor() helper was factored out, it removed the calls
> to the dax_pmd_insert_mapping and dax_insert_mapping events but never
> removed the events themselves. As each event created takes up memory
> (roughly 5K each), this is a waste as it is never used.
> 
> Remove the unused dax_pmd_insert_mapping and dax_insert_mapping trace
> events.

Reviewed-by: Alison Schofield <alison.schofield@intel.com>

> 
> Link: https://lore.kernel.org/all/20250529130138.544ffec4@gandalf.local.home/
> 
> Fixes: c2436190e492 ("fsdax: factor out a dax_fault_actor() helper")
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
> Changes since v1: https://lore.kernel.org/all/20250529150722.19e04332@gandalf.local.home/
> 
> - Removed dax_insert_mapping too
> 
>  include/trace/events/fs_dax.h | 78 -----------------------------------
>  1 file changed, 78 deletions(-)
> 
