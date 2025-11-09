Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF55023C516
	for <nvdimm@lists.linux.dev>; Sun,  9 Nov 2025 22:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762726328; cv=fail; b=WlA4aVnB9mYgpq8Un4NVCl6zfIpJzy/1eU/7E73aMBhcdsZLqTFNkTASmouy3ihRQb/ETUPzqs4aqrRNkxcVmIjs+cJr6Alq83Ll/WJqSSiMwfs9sOB1DYA4SPDhnXFt7BC2mgy4mZOwSevai3RdyOSh8jzRiWFSpgERihdF2Z4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762726328; c=relaxed/simple;
	bh=L39Ro06QLRlGzEb/nzeumO2F8h3Wo0L2g0zP6nO/urA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=DZ1iAQ73x20vNt/fyhbOzyhb5qFuA2ysYSWpuwmxhuqGBLzLe3pruha28UAclLsEllXSdO+f1bgGTj69KvBHUXKgQzUZmJUJ+9HJQ0l1mLuPY/bvxwFkaxgCH+xp+mJKAO8ARhkWTmnUkOpnhrU/MdaWGcCXbLg312jbax8HVaw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ITMhQxcW; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ITMhQxcW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762726327; x=1794262327;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=L39Ro06QLRlGzEb/nzeumO2F8h3Wo0L2g0zP6nO/urA=;
  b=ITMhQxcWAzokdaQCZXIeBaAZKrBnPDkgVwNd9Z6gfgAnp26KGFBd3Pex
   9tcqfm5Fr50xhunyBM3kmcmvVYnqB45/gh6fHS9fVtPKSyn65Ub28g/2V
   T9YHzH0y3BkTB4hxlq64MPJOdYkh3L5ddMbrLsf8WQWa+5zs+oOh2Vs5X
   i7AwvCdjrg006LnGA0FXFTAHAZFRXdPNjmLZxMuK2eiTBXMLIyLhsNAKX
   39FuAxlnI6ztMibBixR5px/nDku0qpMYauxysm+R0q5zhzpP72nG6SJ31
   76arGb9M21/g2csczyVS4n3NFuO0BVuWh3D+ujiG+9BEaOnPzSWkJEBlP
   Q==;
X-CSE-ConnectionGUID: vwY5xqY0QNySV+wL4AOCSA==
X-CSE-MsgGUID: 9Jqy9PtsR8C8gUiuWvOPYQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11608"; a="75395116"
X-IronPort-AV: E=Sophos;i="6.19,292,1754982000"; 
   d="scan'208";a="75395116"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2025 14:12:06 -0800
X-CSE-ConnectionGUID: cTBe6oS7RgeV12BXfLU+/w==
X-CSE-MsgGUID: Q0rqddCBSGWRuMrA7Rb8YA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,292,1754982000"; 
   d="scan'208";a="219255011"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2025 14:12:06 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sun, 9 Nov 2025 14:12:05 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Sun, 9 Nov 2025 14:12:05 -0800
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.5) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sun, 9 Nov 2025 14:12:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OVSYo/VwS/G13bvUl/HMKU5AxQyc5e1iIJ6x88/D/5AQMtGI7q1IdwuNxt260l8lmg00h1YO9l8ZYDc56mNi9VgkYvs2N8Vwp2KSq57+ZStz1qR27O3/38OxRtJFKhKi6KtvCUpBXPNeQhKMK8hA6XdAOEhGDoUhgDt+n2moTK8DdmXGC4IiJdHoLZSYx6i//M8Dfop8tH+awm7vQPEUUkeKD20RU/tk080S70GTeZwpucynx0mheLrPENuioTdM3LhkdFBV0x5kZsHs5Jw1pzgF35wtxeKMCNYx94cepI+bfF0Do02niG2VQurVOiE6GQsPo/A1zOVvPu0cUej8eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UVoBUQqdODw+ITzDeQeNncd84uuSgClBBCkGbtJrHKE=;
 b=S3mNX4li5MsUCXaPg0j1KLUQE55P+5X9X0EQbR7ssuRQsBNKA/c8CLJxUG0bx66MoL0rFKhQ84d8tOnLk+CXQ6Z85VcAMy221avyttg27vHOLFIdxz78TcexGrW8Dgx9oMmOzeBkfULqj0ImBDV0G2y9fzuyXdirMhTFBnlOqMod5hDs9+V6q5IPjswVmy/nMq5wSXEFVJi78vU2Ii4BEZFzcLYAyVjeQa8Wzw6Lcbh+3u5WeeYsWWPo9HBdC1HGmnsGjika0UcZ/4NQn4eKl9Iy/al1PyTKe4lRZH+KnP95Yq+g9DjKVVb3ggDKU7nI1hwzgSSTqUjZ1CQQ/4AREA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by IA0PR11MB8418.namprd11.prod.outlook.com (2603:10b6:208:487::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Sun, 9 Nov
 2025 22:11:58 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee%6]) with mapi id 15.20.9298.015; Sun, 9 Nov 2025
 22:11:57 +0000
Date: Sun, 9 Nov 2025 14:11:54 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Ira Weiny <ira.weiny@intel.com>
CC: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>, Dan Williams
	<dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>
Subject: Re: [PATCH v1 1/1] libnvdimm/labels: Get rid of redundant 'else'
Message-ID: <aRERqoS2aetTyDvL@aschofie-mobl2.lan>
References: <20251105183743.1800500-1-andriy.shevchenko@linux.intel.com>
 <690d4178c4d4_29fa161007f@iweiny-mobl.notmuch>
 <aQ2iJUZUDf5FLAW-@smile.fi.intel.com>
 <690e1d0428207_301e35100f6@iweiny-mobl.notmuch>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <690e1d0428207_301e35100f6@iweiny-mobl.notmuch>
X-ClientProxiedBy: BYAPR06CA0048.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::25) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|IA0PR11MB8418:EE_
X-MS-Office365-Filtering-Correlation-Id: a62f1b3b-8cc1-456b-f472-08de1fdcff85
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?dod6pBvQDY8/5HDYq8V9dTxXg+x2J2uU8LjwNhhsaNhbuMJK6jar2qIr4PPF?=
 =?us-ascii?Q?MAVZMZx7CDCRaE5lFOo2p82MDCpQ13wGYyxCOHtdXMgZRK3xA9fB62tnW3Db?=
 =?us-ascii?Q?Z51FKV1+PBkf9MNsQqSwi7WYmR5AQ3eDsCPMTm9+7jUcEWI63HP/CP9utLCQ?=
 =?us-ascii?Q?32vT8W3ORvbASFtuQ5rS9wQKRYfWjTLXF0X/xqwm0WrwgJO8ju/eAJUDmLe1?=
 =?us-ascii?Q?f8aInjFlvvcrITxCxqpvM+88+4/yINFWnAbfH1fLqrSrYRerVDUqmq2UPx8r?=
 =?us-ascii?Q?/u8iDkKowmOvaZ3OZb7rlcOXYt1aUQP+O/HFCLaz5oPzo/aTmsFUOrlrO3+Y?=
 =?us-ascii?Q?zECqbjJlTxTRcRR0bcZsMGACEs51BugAl3VuC1Z9yv8glHd3yNdY8cigpn3g?=
 =?us-ascii?Q?VqQRgusn44PMJpUEes/viBWfS2AI5IhNq2Orfg9EunsPsPb7EyvnSG9oPTnn?=
 =?us-ascii?Q?CoOBLvq6iJA57iGRQZ9xjtDIxIieYu/PurnVUwvA9m1zXsGAoHc5Ny1/HPS5?=
 =?us-ascii?Q?sjZRo/bSK8U4OTXHUDTIaeLLyQEAM2wxT6CPs/HnvUrDuIhEbp+wfP4AVjyi?=
 =?us-ascii?Q?OMsrM0dvLrUfo6np7djni1ghcgEZcBI2F3S3Q29unwSzYmSy/kDdEQfQQ5Iz?=
 =?us-ascii?Q?s0oq4/VlGGp1eSkrxe8G0Loy2GkSqHI7dQxn7P4mpeu7JBc93UJWVrlG3Igo?=
 =?us-ascii?Q?rNI9/xGfJwLJGBeNIXRK4eedJOCPd2A8WgvAMut70JWr6OYJZBf7aU5Um7A5?=
 =?us-ascii?Q?0mcXWY1cMk+DZFOgD41bdBR2nEA/HpSvSUkZpbuBaKIVHBulKjJUtC2KUpmh?=
 =?us-ascii?Q?zNWtjRsPcvB/IONmyKn0FWKsx9r63+EZ7CQgphJmT3Q+hEIZH4SAxInO4CSK?=
 =?us-ascii?Q?/yKKJcbxS1TGU1AWjKGvAzTaUDvHKQcoo0tHRBmKXKmJ/XCjzFuQRixBuVP6?=
 =?us-ascii?Q?OnbEPCukuJyVoZmKXCHlN8vTlnpvqqp6WpNZM+Z7+Q1vjRpaAh9Uo0oZQ8oS?=
 =?us-ascii?Q?jdQJfTEZQC/gRuR1OngZL+XK4BPVzT9AXuFjYjLyf/jlibHy1Yy27aMGzzE7?=
 =?us-ascii?Q?3ubDAUS4dmn4i5ROGsxrimo8bZL8/SHjps1c0fM2BrcgJU+d+mcnJHfc4G/3?=
 =?us-ascii?Q?amafkpfhqI/WEo5QCxPfU1iEd4bQW31eyEQALsRP5D2mSA2+ieansoqpZedC?=
 =?us-ascii?Q?JyAwPhfaTOBIwv/HtQ/WbUGV9MXwaMl8vcLJQUsCOY2S30nJ09PwNeDZ4nEZ?=
 =?us-ascii?Q?0w3MLoqxRtswASOFlQPLKyThWpZ901l5yNfTFF0DVGXLR6bdGvY0ILaUROo7?=
 =?us-ascii?Q?c3TxP/KRaty+gwmdcNMsz2wJu0TQyysUrMeP4Pu45E9ffhj9q8gjxca/DN8g?=
 =?us-ascii?Q?96cvlBOPUOW7NmPABuJK8vNKY7eS+BPZkUoNZI5iEJNHTpMI6Rgn3nLXTMRJ?=
 =?us-ascii?Q?eL9FCtgMsGqMzCiy9KZpydGiGPP4w8BiIKrRi6j3DKcWmhF1BJB/5w=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wxN3Efwu3MuNFrKCzvCd7jET552wMs6bMuR1EQ+gJ66QlhEchdk/b8ZVpG4F?=
 =?us-ascii?Q?k+Fl9peH5DALbAX0WdkOPI3++rAv3JTqGFzrxjQUhJqMsROJeDq9TurHN6K5?=
 =?us-ascii?Q?rBqGglb2KVbKIl29eAnY1ib0/2OeoMCngDj8vatKQTdFBexD8EFCFOSje6hO?=
 =?us-ascii?Q?PHOvkcHJsdPFfESTM5dZelIhDle4KWIzUyurMzBW1L8qeuqy4f5BoX7lQDU7?=
 =?us-ascii?Q?Ci+2M4kE7IIqjp4m4j1ltHmVbn8AJJmyBoGMs76/SGXnW5soAeXaZpxavMDm?=
 =?us-ascii?Q?MkJW64RrmTtmoGj4pyCb7cYVpZDINjc2rJwBX0sy0XVkL5iAuG1gyR938T5l?=
 =?us-ascii?Q?P5Nto20X14sfo9MhoY8GKXO5KgFrzsSQoeGWmsXDbpIqTvYCJF+g26ateRB7?=
 =?us-ascii?Q?7FDfdLafhy2rnwoDluXwVwhEta6kWAl0DiUHQnH4x9l2IQiBpByaig6ouo97?=
 =?us-ascii?Q?ytwnNKhH9w3rmM1UyLmuB8CzHZQ38ouZYb/wGgTOyFyS13kT41x7F5Ap/upR?=
 =?us-ascii?Q?k1XbajHZLzucoV8ja1+rMSBmwY7KKgGGFQ8nIaH+qbu60wF1kjtNzCcvckpe?=
 =?us-ascii?Q?0JEM+1xCFt8aOLiBdbVeEnxiBxaeBJ/ND0s3O56C61FBAc7d8rHUJFtPKqiB?=
 =?us-ascii?Q?layQBRQeT0moB3OGJWffmwWBo4bSLbjxndfBoswBv8AFRtQ5uWKHWE+xoBJw?=
 =?us-ascii?Q?W6M1SaeAN79QNy34oNIE+zke0nTthwNEqEr3kScSr6NFzQ1416dKpsg407A+?=
 =?us-ascii?Q?Sy+Tgk2FsRrTQYyBLf31v+gApG6BYxC/Hn2MJ1FOrqwQNmP2uOZivOaVIMb6?=
 =?us-ascii?Q?g/W2TIGPEgKxAGbxqSJ6yMx176wsCOylIe/W8ckjG39sTUv+YkOKx6TrWKLs?=
 =?us-ascii?Q?6uW41bthpQKpZHANT2dU5TsCgiRQW+An/vF4iX+YeoSuVLw6mJpCQ6xnJrp9?=
 =?us-ascii?Q?au7LoWv87URoUzeK2wDse59T8UOaJeaVQSpsvJBMnqt7lceRWP/F/g6NAkr/?=
 =?us-ascii?Q?omXJCUEEgXKFHWoyRgNqml95Waq4hRr0vJMDRONOe0+McCVQk9bqqggIPkn5?=
 =?us-ascii?Q?dmqJHlGvkrx9f+SsvwsnegLe2YzhEnVWZPy8G2yXU65Rf4g7A8bfRRNKRvHg?=
 =?us-ascii?Q?QMDFl3DZNk6fMFQi8YvIDD+qbsRLyFPIgaoK7Yq1SNbbIjP3urEvGdk3ysvL?=
 =?us-ascii?Q?MVLI17VQrVwGYD9W82HJEDFep87fJ+KZgrNZdOuaFGfA8IFkiRymWqMaWU0w?=
 =?us-ascii?Q?DtScoFqBiM1sraoibV4C+yX+brTEPyPNkLq1FevZDLhVonV6VUisxAKwwpB0?=
 =?us-ascii?Q?nx1JxY50rqzAY+p/uBqRxv9mUQw6JTvc/95e3eofTRNOzPgx+vyMvzFfIxs1?=
 =?us-ascii?Q?aSycszAL2ak7wdPomCUJ8ackDVI5tOrI10pcigYsCdk2q9fFA5Nym2WaWz4F?=
 =?us-ascii?Q?/VnSnj3PLbkdmH531cDjOpzWNiVTVO0KRb/txK+AP9WrrcGGD7CkqcRNVTkT?=
 =?us-ascii?Q?1l/KwRRAglBuZC2zg7D2oQTLhbKYc1Wy6enLcwL5mKmjKiBmytqx+bfvwIHU?=
 =?us-ascii?Q?eZraJTLmJXSxmyeR59VvSTQr4KSHbMHxr4ZfALXzI/Y4VnqZ/ARS/E9f2uPN?=
 =?us-ascii?Q?Lw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a62f1b3b-8cc1-456b-f472-08de1fdcff85
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2025 22:11:57.7365
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dW2ydL0R+fBzz+tiK2eay67/Dr4lAX88eBh2mCyRUgDlG19y5U1GaRGCqv9qqcvla1LStDtliFFLHDjLiUma0XCmBL6nTEK+r8dGSHf7mlM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8418
X-OriginatorOrg: intel.com

On Fri, Nov 07, 2025 at 10:23:32AM -0600, Ira Weiny wrote:
> 
> Yea putting this in the commit message but more importantly knowing you
> looked through the logic of how claim class is used is what I'm looking
> for.
> 
> Thanks,
> Ira
>

Hi Ira,

Coming back around to this patch after a few days, after initially
commenting on the unexplained behavior change, I realize a better
response would have been a simple NAK.

This patch demonstrates why style-only cleanups are generally discouraged
outside of drivers/staging. It creates code churn without fixing bugs
or adding functionality, the changes aren't justified in the commit
message, it adds risk, and consumes limited reviewer and maintainer
bandwidth.

To recoup value from the time already spent on this, I suggest using
this opportunity to set a clear position and precedent, like:

	"Style cleanups are not welcomed in the NVDIMM subsystem unless
	they're part of a fix or a patch series that includes substantive
	changes to the same code area."

FWIW, if folks are looking to dive into this code, there is a patchset
in review here[1] that adds new functionality to this area. Reviews,
including style reviews, are welcomed.

Regardless of a commit message update or a change to the code, this
one is a NAK from me.

--Alison

[1] https://lore.kernel.org/nvdimm/20250917132940.1566437-1-s.neeraj@samsung.com/


