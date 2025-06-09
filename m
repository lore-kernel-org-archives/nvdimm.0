Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76EE745BE3
	for <nvdimm@lists.linux.dev>; Mon,  9 Jun 2025 14:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749479458; cv=fail; b=tCEP04zN2YEXhG8VkOItvbjLhuAndMVuOfCCKwaQXcp1djesu5+tUeOU3gbNz2AHbEjWG36FVd2PEjoVGN106rQsR7UXLnt9DyhSsqA2vbMBrFgGO8zhaaIKuVbW6JLvWd1pIHbrSlouLC4gATSh56Op/Xd11lUjGw0J/o71nHI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749479458; c=relaxed/simple;
	bh=oLNU6u0bX2oGWjRTyKOAFFP4mm3ivv1TtUCZRCH+Gng=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GxquFiBaO7H5tA10nQMnvzAFvTpIlloebnmoXlT8/LKOjplY1WqHf+4dvx5nJZEtZdYacJZLshMI3Zswe/Q+Z2WzV0uQrlO6Tq5YEmkmynfzrDeI34c3QtkyAu/p/YHMTVRH11PYH9eHlQKLPxV3VzVbwpVAphm74MQVcoLqaJA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HncZ2h+V; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HncZ2h+V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749479456; x=1781015456;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=oLNU6u0bX2oGWjRTyKOAFFP4mm3ivv1TtUCZRCH+Gng=;
  b=HncZ2h+VK+YEH3DSuCJaMNnn9j3MsrKvAYeIZuNmZ/DUZZT+LPyIIHFa
   6SLFXz84OLTW3ZoMJBsVH+s+a9Usa3xy3vSsA/d7dbBnnR+PkTozG28+U
   55pdC4HUVm89D/KBt3EaMivfTPdpArjLAtFoFdLjQE+WGnyUkfDXucO8q
   AyOdk92WZYnBmU3f9E+FFWrjKXBvp22HF7tgFL/FHPhPvayAqrGUEagdH
   6+dGG+LtZNeiP/rqs+aK0T/UdadKH8hT2YRYcPcfu7lPl2Djtm6ZCKFbT
   Wnk5zJbw4GMbJltpelbZVr0NCnZuKQgQFadld2HUXLnOF2fqrEaIYs52I
   Q==;
X-CSE-ConnectionGUID: e88v0kHQSJuWk5j3JVPMVg==
X-CSE-MsgGUID: avFjOZboQSykORtDjNw2xA==
X-IronPort-AV: E=McAfee;i="6800,10657,11459"; a="51642286"
X-IronPort-AV: E=Sophos;i="6.16,222,1744095600"; 
   d="scan'208";a="51642286"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2025 07:30:55 -0700
X-CSE-ConnectionGUID: dtLmMVVwQwaDOPHodrgIZw==
X-CSE-MsgGUID: 7VwojqfGRR2JmujC5v/vIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,222,1744095600"; 
   d="scan'208";a="177437429"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2025 07:30:54 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 9 Jun 2025 07:30:53 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 9 Jun 2025 07:30:53 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (40.107.96.52) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Mon, 9 Jun 2025 07:30:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HTrUWuQT0CDmfFu6u4IfXPu9SovqKVukrL0pDUksKzTQOD5qFM0fQ/KxRDCpTY00lG5CXxsN/FRv7xZAa8cc01J97lLTuGU1igjdTp2Ue6WC1Ms0jozBTZb+eLO2jO51L+ZNqWId7Y20Za2MVuJ9e93dn5hbDZU4+xeJjLDEG8zHA5/56e/5zMrmPNdIJpLomfL5nE4Em1ZtFy6swif1FNbwWQ+h5+srkSs6Amb5Nmrn726/RlBDw8LwXa2S7cma8n7HobUOo93ut6uK+DmSFi95UkeMrzblAC8Pi2xhGaHX8FmMzjQBHDlq4f+VM4oV6pABa1+i4lT38fIaPowF1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VYWYGXqgWe9dBFUd6L7IjPpLsLVVErGvQBc+p9qhkcc=;
 b=s/9P7YnIVBsw2TIEzZbjg1rvTs5hlNPkXvIOCppdbbtjigtzmEI5FGh1V1U/0N4nEsLvXuJGK77EIrHPJUtTEw/YewqUVvXh2c6e6tF4lfwczYPQnKTdAWqspr7TZCF14n7+xOyNpEc2OoGM5wHFk4eIbK7iwCDQKpbboy5gLpMqLAGJG0Foj01iqPcXbMSyF5LrYNoy5XcEunplwPtInbBGwfusNgSmmhUr9I56GYMfe1aaAoszSaCvAwUpJYOUcNdpON3x5D9y9MnTo8RsmHAteKMbZCylX5tiKofb/1lpIh5FoWfljRjd13B6kNDJ126I/AIvbmDmte94WRfPHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA4PR11MB9131.namprd11.prod.outlook.com (2603:10b6:208:55c::11)
 by CY5PR11MB6511.namprd11.prod.outlook.com (2603:10b6:930:41::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.26; Mon, 9 Jun
 2025 14:30:23 +0000
Received: from IA4PR11MB9131.namprd11.prod.outlook.com
 ([fe80::7187:92a3:991:56e2]) by IA4PR11MB9131.namprd11.prod.outlook.com
 ([fe80::7187:92a3:991:56e2%7]) with mapi id 15.20.8813.024; Mon, 9 Jun 2025
 14:30:23 +0000
Date: Mon, 9 Jun 2025 09:31:26 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Dan Williams <dan.j.williams@intel.com>, Drew Fustini <drew@pdp7.com>,
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
	<nvdimm@lists.linux.dev>, <ira.weiny@intel.com>
CC: Oliver O'Halloran <oohall@gmail.com>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>,
	<devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Drew Fustini
	<drew@pdp7.com>, Conor Dooley <conor.dooley@microchip.com>
Subject: Re: [PATCH v3] dt-bindings: pmem: Convert binding to YAML
Message-ID: <6846f03e7b695_1a3419294dc@iweiny-mobl.notmuch>
References: <20250606184405.359812-4-drew@pdp7.com>
 <6843a4159242e_249110032@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6843a4159242e_249110032@dwillia2-xfh.jf.intel.com.notmuch>
X-ClientProxiedBy: MW2PR16CA0016.namprd16.prod.outlook.com (2603:10b6:907::29)
 To IA4PR11MB9131.namprd11.prod.outlook.com (2603:10b6:208:55c::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA4PR11MB9131:EE_|CY5PR11MB6511:EE_
X-MS-Office365-Filtering-Correlation-Id: bbcf0e14-c864-4493-6a1c-08dda7622af2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Jm4GE9NH+qsynC/mq/eV+sjoLaHXKs5CtQzqe2t/muQRp82rqhSNXvbPhWUQ?=
 =?us-ascii?Q?WhYpJ4qJXRWVbv1bXrzk4AeXOTC+MKn3PGxi5M6DWnDFwnyjf5Vc9FdSqb2U?=
 =?us-ascii?Q?iV3kKdcILCVPeLpxiGZrLe8G7bZg8zt9Uggp8/rWbYPD6ykX8W4OO3rfP6KO?=
 =?us-ascii?Q?Ab+jCYD1baDlP1qpL41OjN+3t45MuWgVKT0riJs2+lbiq9uIxCZ83Fgms9MA?=
 =?us-ascii?Q?6tfa6gI8IKEuNqd8q+Z2zlJcAKubLOMTG8xmBskwmFiT3Ic76s1auV9JX16a?=
 =?us-ascii?Q?ArJkcuxYaIZFYYcnaJg7AkXcyUOvcvLyusaXyJezP6CnkONWk7yGKNGWvXgR?=
 =?us-ascii?Q?xYVjLAYSlr+TXzx76iBePLI4SP9wVpK90O0tXPKCSj99i8hvCilHRu9mDNg+?=
 =?us-ascii?Q?40Gn7FPS33Xmn9/da/GnvWDl41oM3ygV8Gn0lpcBgBMsQCoAUFuZUPxC+fl6?=
 =?us-ascii?Q?lRnEpDAV2+IeETb27P8DRMBT91PGL032ea+VVXmpli7a/CvrPxRGeNelibL4?=
 =?us-ascii?Q?VOWWxzMzW3K0iPryIwSii3gzVe+3YwBm0J3n/BbAT90D+3G6flgD8gF80esP?=
 =?us-ascii?Q?xJqrYezsP5NP+/vtFIBSCdr7rqZQtiTevYIZ5fdUbpCcXz8PE1CeCEoqUx+w?=
 =?us-ascii?Q?hpK7yS02Olg2Vk5kbMsG1MBbVilwROI3Z5Xm0Wvux3ZOH1O15wMntEiur/Px?=
 =?us-ascii?Q?9GUYxVRTgjVQ1+yNJvcdmn5CUYxvWlMHZT7/6Jy12hyKQNhsxK1s35vSOaAS?=
 =?us-ascii?Q?gENNXWvN1MjP8QGutatrieWYxQMvwrOEXLqCv0vi7L8FUcW2f7KngrR0QKKY?=
 =?us-ascii?Q?2P0LGjqbh0U7qK8g4hiDoEofmJWd9OEl2CuslZhGB00Uh6+xhY8U7zhCyTo1?=
 =?us-ascii?Q?vvG1o38XeH2ZDSNxkvXdBUDQxNb9cf83rcKOeUYMxoIt8Gcv7PRea+fp+w5r?=
 =?us-ascii?Q?PaDNNw2pogZPCRYe8fknQy45nSmTmL+YqH8AqDGxTa9J2ykEJUdxEWv7UooO?=
 =?us-ascii?Q?mNvSdrBDPESv8VSrV0F+ATfaaeCFMWryrwgLBMervt6lSiw4VXKIdjVBpeVI?=
 =?us-ascii?Q?WcHYDPgaBO8A58E+xO+tRpQv6wcgob+F6HIJDR07v0iGF24W+QBoPgF4XnWD?=
 =?us-ascii?Q?eUkxNkUw/kvI4niKNQz7T8naooDbpqJtzvmCVBvA5lm178Pga2bQ4ttVYXfw?=
 =?us-ascii?Q?ETL3Z6NCn70dRXF95NAWVgb34YsOZNAQy6oph2qRfaY8WDD2ePnC4P8fMV8r?=
 =?us-ascii?Q?fnL+ALcFQyA+xExvdT5yuQYI/hRJVEz7QJ4j9ACTkdTvFBKqZwCog3G7rWP9?=
 =?us-ascii?Q?+U6lqn7+uKir/o676dNVAip077hF47nsr9JuYtn1mGmRxW8J598PKtrclvHL?=
 =?us-ascii?Q?bhV681atKfbjCWIACVqVOv6QnIcN5S2BWnq3Uy4yE2CRnNqtAzciwfvMtWzD?=
 =?us-ascii?Q?gwOtNA4hOzw=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR11MB9131.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UdVKCMw2YyIsaTbcr7+FL3HCQfz1KgMFXVzM8mxJpbkAPlkR22aeZTD/j0W+?=
 =?us-ascii?Q?5vyicwK793x6EpXfVHM44fSyN3fHiH9iHgrVRztQJ92XLenETK3NaoxNzk8f?=
 =?us-ascii?Q?7wIDzzBGKqoovfiegQCzM8kf9o8FhGSVNEhytAVZsfvq/IX6VVdIBIdb48Ai?=
 =?us-ascii?Q?T6BiWNPJ9PA1j06fWnXZcecjZZ5UOh0l/r4vidXuHHruhRT38aL8+CYVoPI3?=
 =?us-ascii?Q?6bHTXPuj+U6D4Vc2gx4SLfV0+Yp/BCUQ2J55eBGa3eJQgJmxV3M+nafqMkdN?=
 =?us-ascii?Q?nZN231RmSaIWSkpxxs3D2mxJV1t9E5MXPEp+E/RbJemOH1nPLSz+/QBFfkA7?=
 =?us-ascii?Q?7d3RarYKZRmE9s0pC8b/EAdawvu37341fjWyaVGZ78QwwRVz+Xz/pGlwUhUy?=
 =?us-ascii?Q?vpKeQq+VAqiIkVTgNFSD90GoSJhnFTHrNBqblBqvfIIp1T8SPdtCO9Z3+x1o?=
 =?us-ascii?Q?AXgN1kTD7hSPDitZIQPfarGjDP+tMr2Jiegl8ftGXGH2hMv2vq1l7giaZMzU?=
 =?us-ascii?Q?wSy7OIETpFJgYRig2tG611fETthPe1Wi/XwRYLqcu5hOyzf0hHMJVztAs5gw?=
 =?us-ascii?Q?3cp1Es9nzsoez0P/DPlaGx434p91RjA9sGLxVf7nnJO6h+a7+PXa9cDCugO9?=
 =?us-ascii?Q?WNaLw2yewyq6se/1zeaHjAi49HM2b3VzA/MV35954e/a9oDJtZSB0LSbt+5y?=
 =?us-ascii?Q?fGShBNeNk5mI4GJsySuVz57rJ4zHsoUMdcONFLh3bN3DZnS4vD45BKYczPWr?=
 =?us-ascii?Q?zit4lhlYuVHwsgCz3tx2kw0IPUprefr2ULxtn9fBbB6fOVdLq/Q6xYOD22VR?=
 =?us-ascii?Q?8hJ651pqoRRjEhbDZvmldLS4P1BNHOfYVgUHZWk94B4JfxW1mD2FFEr+I2ZE?=
 =?us-ascii?Q?e195NdyZfRLc9ZWh6TSScq78iVAcB6Y04XQAzDqxGvSE6bJWNIggRHy66UmV?=
 =?us-ascii?Q?/vwqEdHvR8e/9e8emSSs1MxuXgKroZOEYz3ehjHLzWNtySyILJaHJ2eYvAOe?=
 =?us-ascii?Q?A7SaKNXXVbiimKhffYmKzcPQlXiuU+RV3Zo1tiUaXvI31Z6SO68aIVwBLs8l?=
 =?us-ascii?Q?W9ZJdcKXmvpao6C9uoqAO5J8SaLzHDDd31aE/5IBdBbmKoZEtzCaRVqfmpWr?=
 =?us-ascii?Q?SdKIJ1/B/eJJtLzCOGgyYzTZlfej9+iYFE16kPE/VVOB463JBAz6KMDG/AoS?=
 =?us-ascii?Q?+kNM09RZEzbxsc4p+3XmXWyrJSlPrFO1ur3207nW4SJQoNdaOSAulA2rnPR7?=
 =?us-ascii?Q?+AXmSHxTkQOk6fWkD6vdgffN+6f4mJLZR54NJaMfUEBVUwPwHAxNocq5Vzbz?=
 =?us-ascii?Q?wLHlf+Qrw7IpLgrXYbfogB/V2C851UsWFlnrgVY4l0Gig+uDc6kfWaFnpY39?=
 =?us-ascii?Q?ZJx8GCxNA7SktEA7Rt6qZjtBG+xnyWHduxmQl3eWalVauCzniVHMcofR0+qs?=
 =?us-ascii?Q?0CDryq0P2n4qs7i6QfIhxr+WyPgw52U2iNrvjkyn0GpmeTVBstXbNsn8GxST?=
 =?us-ascii?Q?4zDJFyKTai8+DMiBW0SH90IQivAf7jE2pwhHZa+Ui4Q2rycg9fYYhDAEBi6x?=
 =?us-ascii?Q?/LW7yuZZUpuoUXhSuY8nZeM01nOlIVjcKuGokgNp?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bbcf0e14-c864-4493-6a1c-08dda7622af2
X-MS-Exchange-CrossTenant-AuthSource: IA4PR11MB9131.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2025 14:30:22.9503
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XrZ5h5JJAUsw2WBsYgYqTvyM+HPhSdE6dOWM0dXewHI7Jtr7KF/2tgErGHklHjSnoI0W2RsGRhGMkVIyEC5LUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6511
X-OriginatorOrg: intel.com

Dan Williams wrote:
> [ add Ira ]
> 
> Drew Fustini wrote:
> > Convert the PMEM device tree binding from text to YAML. This will allow
> > device trees with pmem-region nodes to pass dtbs_check.
> > 
> > Acked-by: Conor Dooley <conor.dooley@microchip.com>
> > Acked-by: Oliver O'Halloran <oohall@gmail.com>
> > Signed-off-by: Drew Fustini <drew@pdp7.com>
> > ---
> > Dan/Dave/Vishal: does it make sense for this pmem binding patch to go
> > through the nvdimm tree?
> 
> Ira has been handling nvdimm pull requests as of late. Oliver's ack is
> sufficient for me.
> 
> Acked-by: Dan Williams <dan.j.williams@intel.com>
> 
> @Ira do you have anything else pending?
> 

I don't.  I've never built the device tree make targets to test.

The docs[1] say to run make dtbs_check but it is failing:

$ make dtbs_check
make[1]: *** No rule to make target 'dtbs_check'.  Stop.
make: *** [Makefile:248: __sub-make] Error 2


dt_binding_check fails too.

$ make dt_binding_check
  SCHEMA  Documentation/devicetree/bindings/processed-schema.json
Traceback (most recent call last):
  File "/usr/bin/dt-mk-schema", line 8, in <module>
    sys.exit(main())
             ~~~~^^
  File "/usr/lib/python3.13/site-packages/dtschema/mk_schema.py", line 28, in main
    schemas = dtschema.DTValidator(args.schemas).schemas
              ~~~~~~~~~~~~~~~~~~~~^^^^^^^^^^^^^^
  File "/usr/lib/python3.13/site-packages/dtschema/validator.py", line 373, in __init__
    self.make_property_type_cache()
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^^
  File "/usr/lib/python3.13/site-packages/dtschema/validator.py", line 460, in make_property_type_cache
    self.props, self.pat_props = get_prop_types(self.schemas)
                                 ~~~~~~~~~~~~~~^^^^^^^^^^^^^^
  File "/usr/lib/python3.13/site-packages/dtschema/validator.py", line 194, in get_prop_types
    del props[r'^[a-z][a-z0-9\-]*$']
        ~~~~~^^^^^^^^^^^^^^^^^^^^^^^
KeyError: '^[a-z][a-z0-9\\-]*$'
make[2]: *** [Documentation/devicetree/bindings/Makefile:63: Documentation/devicetree/bindings/processed-schema.json] Error 1
make[2]: *** Deleting file 'Documentation/devicetree/bindings/processed-schema.json'
make[1]: *** [/home/iweiny/dev/linux-nvdimm/Makefile:1522: dt_binding_schemas] Error 2
make: *** [Makefile:248: __sub-make] Error 2

How do I test this?

Ira

[1] https://docs.kernel.org/devicetree/bindings/writing-schema.html
