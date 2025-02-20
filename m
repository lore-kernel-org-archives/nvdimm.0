Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3D92641C1
	for <nvdimm@lists.linux.dev>; Thu, 20 Feb 2025 19:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740078627; cv=fail; b=LLmDFXAN348f9Y6d/+90Q6p4/4Uimct/PRnwCoy0UUc+7Pf58RO187nl9GnydWFVqGB3Pu7pTEOEWqTQvDyVH45cHZHHddZTuGTopnJphDHMXnW6UIQmhU+43NRWR9DBCGuwVUWwbtoRHNXk3rRlaxmOv5Flh0BRBbDUGZO9w9k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740078627; c=relaxed/simple;
	bh=FYrhRI0BeEFM+LwRY/HfvJDt/AC7nG2p3ZBtUpToL8E=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=iWY9+QkQk16f1J5WVmXhCsMP42HOXHXgebcB8XuRGOA3tFKvUEQsrRxS6klzFHHt4ldo+4XkYU57QDEU1eW92f4prpxrPwDR3rs4E2JDBVkMfdlb7AsA2SdqZ0BCeujKZV63kyAdAJx/+nllIIqYPG7zHBtMXpyFP2aNZOQZR8o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nzUq/TkG; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nzUq/TkG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740078626; x=1771614626;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=FYrhRI0BeEFM+LwRY/HfvJDt/AC7nG2p3ZBtUpToL8E=;
  b=nzUq/TkG1HM0pw4UKNNwgzaWBGRnMVflNp4CnTSq/m96p5UpmYDSPBvl
   EoTzGaCKkNl/pRvoLGlXVC3/pR9P9pnbNL1oc9y+Y5eRjh2KdieBS3q75
   2yxJTOjJR69Bx4eEC5GJAaNhhvxa7CxF9IreUGtK9A8lGfMprCqtHZQ+H
   kQzsXDy35HPyJ6uurbEVOS62/tGo2XQcH+y7q+zMjlhHzLtcCJTeBMqbW
   vtlQ97RTHttIOPKt5Nb2G2EDtcfxQKfRFzDfnZbYtSoCOX1d6pQiDjPzA
   Gb5Xv4q8fG62XgliAYjP29ujXOLZuaD8V8vtQi+fEHCQD+xGbeMMQiHNw
   w==;
X-CSE-ConnectionGUID: Izjwq1X3TY+KRpMvmf0BEQ==
X-CSE-MsgGUID: 8gANtQogTx+AhBnN74i+bw==
X-IronPort-AV: E=McAfee;i="6700,10204,11351"; a="43711535"
X-IronPort-AV: E=Sophos;i="6.13,302,1732608000"; 
   d="scan'208";a="43711535"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2025 11:10:25 -0800
X-CSE-ConnectionGUID: nfFtjIt0SAmP6WSqC8KtyA==
X-CSE-MsgGUID: msF1y0/0QE6ZOkYLD7ppRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="119244589"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2025 11:10:25 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Thu, 20 Feb 2025 11:10:24 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Thu, 20 Feb 2025 11:10:24 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.44) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 20 Feb 2025 11:10:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Br5QTg0Ki6p2JhhtWQvHCkfQ5UlcIyjHs9aS0TIfcnsP3rwVHtjZtuq/R27Syp9zQ04N4gbpSMUP2k35IYMIgy3jk03yPEt1aWzIfLqTpz8WF1iQQ1jM910JV3RPiYf6mNHev58Q5zkgP9wWkAuI3uogDm2XW7jy9ZUi2erbNLxgioZXe4acXybGvXJTXANTRDPwd8m0sikQwOLE0J4ivGnn49weH8nN1K+qzkykQybcxrZCuq3lsNQx2F56qceNQK6zvvrKGB3AJRIJgrIZZInzzkn+iUDg4SpwUinpGKn4dOk4mUiuqRPOWQl/RzEox0qdgwCz8ydXDcvZ5i65HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GLG3vL6MTWjvty4NS4pEi54yMc7n75LkvMMA0QEo1TQ=;
 b=r3dORTmpkwIL9cUbqn2sHoaItuC2QG4bi39eo+GyLL1pVISmK9ND1jffexx4DggjyRoc0embGOazdX27S8s3UMh4nsEF11GOlxrsgUUPVSBA3Jz0/377c7g/GRWvI5MVeCO4BjPMFk3Wmcy04IJBkfk26AIOniTIbAfRTOHPm0pMx0nlo74Ndm21hwn+kJMKygqd4nYWvzNSeN9fOr5AtgkdCgl4f8IkMGN0ufmqESdfiYdi8RFfkAwIMsn8foUfUYU3eUShk4NJGCehoJ04a+Kz531jafjtvVlCbKL3SB67PB0a/iqGl0C3vyxmThyz8vQb8vDDGxVvsfGs7oAzRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by SN7PR11MB7592.namprd11.prod.outlook.com (2603:10b6:806:343::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.19; Thu, 20 Feb
 2025 19:10:20 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%5]) with mapi id 15.20.8445.017; Thu, 20 Feb 2025
 19:10:20 +0000
Date: Thu, 20 Feb 2025 13:10:17 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: <linux@treblig.org>, <dan.j.williams@intel.com>,
	<vishal.l.verma@intel.com>, <dave.jiang@intel.com>, <ira.weiny@intel.com>
CC: <nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>, "Dr. David Alan
 Gilbert" <linux@treblig.org>
Subject: Re: [PATCH 0/2] nvdimm deadcoding
Message-ID: <67b77e191f494_2e189b29458@iweiny-mobl.notmuch>
References: <20250220004538.84585-1-linux@treblig.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250220004538.84585-1-linux@treblig.org>
X-ClientProxiedBy: MW4PR03CA0014.namprd03.prod.outlook.com
 (2603:10b6:303:8f::19) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|SN7PR11MB7592:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c193c15-4bd2-4794-5b30-08dd51e23810
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?toYFSVvMO236S83no5a2df2x3c4QBNS2kyrqxc2M6YTtBQt+cdbenfgeqFq3?=
 =?us-ascii?Q?uA7yQDC3EPn3e5/IkRIBOKYozss5GntwZZspt/HDjlhjHDsc4GMXcrqgmcyw?=
 =?us-ascii?Q?WtPJhe8bZcX3KFjAg4w9dJy9Df3pjpoAVbxFAhdgn4F2AI2ppX7jlXR8lvmn?=
 =?us-ascii?Q?FRRhKkXk5MU635As+Gv2HS09fVT6loT52UoNzmeeR9px4d9gTzwHJADbwUQ4?=
 =?us-ascii?Q?Cx7htPbmBBp2K1F9BkiMtSUT3AYTdILCztZiS2o+vBoDO0T+2/NLqxlMMLUx?=
 =?us-ascii?Q?iTRW/9/2EwbOyEgIpR8LA7bai0LG+vJd2TuwKyn8trryS3dQh0DEQiL6DSh5?=
 =?us-ascii?Q?t7qxqa6SU5FgHSMfvuqcjKLmPgaxthas9upgr0f03i1cVU6I2Qo7y5tkLb4G?=
 =?us-ascii?Q?/39yDzo97ATsHw/NqxYRWqx2xm/ayuYpSZp1F038QlEn4b+omKBbc3+VO+ZY?=
 =?us-ascii?Q?8sC+JWfYJmWW5D6nLHzXAhOwoJVZvnSBvsm23ugB5xtqF3wxBwvN7Zz3ppo4?=
 =?us-ascii?Q?bSUi6rHEwj9WwkYDpltvpJ2A1dKDH229cf1E3gXBOgIYjqdpwsS0kVJmjoyh?=
 =?us-ascii?Q?dl0HpPi7lPyXUULubhbpltnoDRy5M9bQFfzDqIvDW81DRUKdCCCCdDx0CV3b?=
 =?us-ascii?Q?ufEwG89Ise0hyGnKMHKHn7kdrvXWWEiZzCM4MXpggOZGloxKJA7h3aFv/lPN?=
 =?us-ascii?Q?HEL6NT+jQ8EAtMWHYJ9dmKgqnngdFbRYQZoA5ZTtluG345uAZzMpUZE5603S?=
 =?us-ascii?Q?LI72QgTpnK0UFNhqEAcDw5Zugh/hoU8hCryZx++eULRneE6K1ZxnWupaBtOD?=
 =?us-ascii?Q?aX16pVFzxnYT87RZ8kPJ8cHA7REKDuKPmitEMFcvIkj/OzuhsilCQ28ZKPuN?=
 =?us-ascii?Q?PS7TrHBID5PlfjFoDNcWlrQnsh5cL8Hvn0+I1rC2YPU3EBjC4QyT6MkatynH?=
 =?us-ascii?Q?NFaVzvWnhmG4EmOmQKtgjNcao2UomJBvo5+HnKB9f8P8JLDGQZECT6gf/WCx?=
 =?us-ascii?Q?r6n5AAttRuayLSLwa9yu26sNgVL49qw4qvDduxKbwOsAqEWfwdRSLiazh20d?=
 =?us-ascii?Q?W/bFtkBAbGexK7Xun3e2pBJYvuoZlYfwf7WfneodV0Hwd+A0EtXtJtkBqTCs?=
 =?us-ascii?Q?4n4uAxwbh2cJcjMlktiEjaSK756V8disK+5QxN/+F2+rjNHHxJXJfo7Xuv9j?=
 =?us-ascii?Q?e5tZdpJg2li5dwcDUyjstOBTYW2Ew8UlpJoadDLKVvrHUdVvJdgqyl+SYXl9?=
 =?us-ascii?Q?6nqYKxGJ6SQ8YbKyM9UlcntZloi6AUFtd7vwKn7LuYZ64MQpEtPP73swE074?=
 =?us-ascii?Q?4eILU/LQrNqoKKqeYmxn/fPkqNQ2NqHv3Aa6aoOqSNo+Ez4wyp+ChWv0f7Wu?=
 =?us-ascii?Q?1ruVi3qIPKwOo3XlcKlpUGrX7sGn?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BS1D0zKXKRvFt5wA58wLTF1G3hWa3Nx8ax2oHUNN5h0XMa6M6YcbRcE0VBqV?=
 =?us-ascii?Q?rU3nHbYqqFfp363+EczvUCGu762b/KFzC7mRrCERaJHml4811CwTjoz2JXBo?=
 =?us-ascii?Q?S1th2ox/WIOvC+pTXR9Ok3vt+a+BOmu5xhgDeLFJqVCc7fiJKxfOhJDiGJcX?=
 =?us-ascii?Q?3UTN8QKCvFUOOmQcmVm1ecIW/Hli9npJwyHMFfltgr6TdMBV/78RcWQOojko?=
 =?us-ascii?Q?KlzU3+i2m3MnAREcLEOoc4OBPrsSWmYhNzMPg0SRw8yi0c+hXAYEQOQFWasX?=
 =?us-ascii?Q?ExlrEPhUXBec/2UAJDMEzp4C2E81bIXSaiIGBqv789JN6M4gu9x7PaoqW3ff?=
 =?us-ascii?Q?OKgFKKqWerYPTvz+1vMOCKVSK5XyN1+qxwW3aE6jAiOs+EjlT09Pl96GPYth?=
 =?us-ascii?Q?IhUuvpw4gQ2blSKGek0+CmeZ8/SHen++V5mjQVEl+yIFWYRRqHl8cK7s63BP?=
 =?us-ascii?Q?kvo0BRCx12nNquCdaY8zHIJ9WyNfokH06v/6fmWomsXq1ogMwgfAoKURSJd0?=
 =?us-ascii?Q?Ja31GdU06OqapNF1suq8nTIPO4Rob+d0xwj6wltziw9kbetLpwhoLMEXNhiw?=
 =?us-ascii?Q?QdAXAkq9MNB01zTQ82uYszzGONFg8zjmf2fZHduzuklD4ZpAyyj27xqTUnzE?=
 =?us-ascii?Q?HL4wa555DFVwE4rn3PWY0x2qy1QF2rIU1xpopBlb7gNWefU3bH8gF7X1f7RT?=
 =?us-ascii?Q?u6cUC09mORobI2X1twv6Vk8PO8SZXQE9LOR/dpnRgycqf4QEAv+fuYXRFzM2?=
 =?us-ascii?Q?Hx7wirtkIWkEHUPt154ZawjhQjq7Z4qm1DuyS8K1uiG4wwOhMSF42CSOze50?=
 =?us-ascii?Q?j7ZHctQDM/MjSBcK8TuRaHyuE1tLl3p5DASvCt9EvFJgNUzwUnGeriBs19lA?=
 =?us-ascii?Q?+f/UySUkCxxuDFGEEto4T0SqJLpncxYkiMKpql5YeGtafnnEijIP2sUlbNeP?=
 =?us-ascii?Q?1IXTCKrMoZVQqeR3gl9H9xZxPPiQKnHYoKRDfG1WUMxbE7gL/1VxA3lxb7g7?=
 =?us-ascii?Q?esqfOyZ+jPeCwdH19BjgMvv0Pb1AdBXz01ySWHYTBxy/OYKsRVvknr5/J3qF?=
 =?us-ascii?Q?xYR5MQQGpAqPcPQMAAg4f+DcKEra1HkQg3j+lSiJSfDb8xqLhjZ0r/K74mul?=
 =?us-ascii?Q?pyKNfYiwcNgRkA83LfETEl9ZDJ9A/k+7XVM/mVMBxWy8sM+VLFTMJJzZCx6U?=
 =?us-ascii?Q?+R8baPwt53IS5DZEbcUn3w4NZHUi5lSug/l1DL1cbZdh5NkZYtacFueah/d2?=
 =?us-ascii?Q?PAisxQ9hgix0Lhwii0ahAl8ypUjkwLbSzztuo1AC+ug8Gz+jYCO/nEMNKFwz?=
 =?us-ascii?Q?/BhWqHg+myrTYqtcVuDSbPGxa7WvCiU6Ljm3Ial+1taQDyMQiBlAx/kKQx16?=
 =?us-ascii?Q?OhffkbpRKqlOrpcmYSJ7nmfQk3QeVYOxsE/sXbbztiDtWqFBUVPlj/F2ZNPR?=
 =?us-ascii?Q?0927IbXcCnQgyWvwbOM8s829kh6s//rh8Yj0Zl3CHSOU3MhQlIKJ04XMgjSh?=
 =?us-ascii?Q?+M0wTTjYMAtOUABBaLeA55b/MogZM+GuNtaBZj7Os1GZJ5KxeVG4g6lROoVo?=
 =?us-ascii?Q?sN8WpHNsFfdpY90LMrjGXWaHdLpXV7WopLbLrVw/?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c193c15-4bd2-4794-5b30-08dd51e23810
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2025 19:10:20.3019
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RF4M9702coqS24DosYpCPC1K+ftgxyOD2qgc6XujICprk5RKmDJMY7mV+3kAR8IX5lhBlDZzqC2RuazkC77CTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7592
X-OriginatorOrg: intel.com

linux@ wrote:
> From: "Dr. David Alan Gilbert" <linux@treblig.org>
> 
> Hi,
>   A couple of nvdimm dead coding patches; they just
> remove entirely unused functions.
> 
> Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>

For the series.

I'll pick these up for 6.15.

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> 
> 
> Dr. David Alan Gilbert (2):
>   libnvdimm: Remove unused nd_region_conflict
>   libnvdimm: Remove unused nd_attach_ndns
> 
>  drivers/nvdimm/claim.c       | 11 ----------
>  drivers/nvdimm/nd-core.h     |  4 ----
>  drivers/nvdimm/region_devs.c | 41 ------------------------------------
>  3 files changed, 56 deletions(-)
> 
> -- 
> 2.48.1
> 


