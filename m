Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FD372D3230
	for <nvdimm@lists.linux.dev>; Fri, 19 Sep 2025 21:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758318823; cv=fail; b=ARYnIM36T+kp1DEnyp3QPnj/UMwQ0u/iD51nCVjwTjWekDxsTGdGaLO/rU0uB1LI/SHEjffLAuACJyWeDpcoG8wXGjHAv6trfQGcYPBAl56hXmjlMzl7FnWE+VF70IJ4u7rZqVm1SEjt/p4BGMM9b1bm93vC7Wx2x9sMFSUR4VA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758318823; c=relaxed/simple;
	bh=wnIZoiEzIjB7Z9OgDbKkGcgjmNcBu5+I8vJ4jlz1e7Q=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=uViL2gi+tVDgWqv5DvOB8NrycH+Ox08mvyLBJ+rKKGRhWUmFuT+2D4Ch6b/vBRPzU/uh13763u6V2SOjY6MQqRkAnDdzUtjJl9V4j+zQ0CYeWPHT/MztqlA+B42OH16HRKvPF0Rgn77kbbu93TSmZdRlVkooScNF6A8JGrd7YKs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ldGbtsie; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ldGbtsie"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758318821; x=1789854821;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=wnIZoiEzIjB7Z9OgDbKkGcgjmNcBu5+I8vJ4jlz1e7Q=;
  b=ldGbtsiePwSfH8m4P8UZW3XkeCgejqGkSgGt+ODstvzzmTkBMAvgJHxg
   YM+KYp9qURsmrfrx1tr1ig6a9HkCmPF7ISl5iF0gYoLE9t4WcycESUWjq
   ZLWakYYWU+WUz/f3Bh0Dkr6wKdfYroNyFDv447zYnlGVrhtV1aYjFx6Kl
   R6QO0ErF/qwKWB+MFCmQCqSTnlKgu3INDyMQ654rzYsObO5wNxy8YFMfn
   4u5UzAyCNsFi0sXIxcyv09oHQ4rkEfIONXztVxc3FK4bLqVH9AanmwLi0
   aiRrAERkcdtJ+gGoP6Rjos+Tdjs5iLoQHjbIzvvyEJnCYsc/f+6IqfjTO
   A==;
X-CSE-ConnectionGUID: KfeT0LuLSfqhXdXcPX/sWw==
X-CSE-MsgGUID: R+Yy5w67QJeSw7oa3hpf5A==
X-IronPort-AV: E=McAfee;i="6800,10657,11558"; a="59710636"
X-IronPort-AV: E=Sophos;i="6.18,279,1751266800"; 
   d="scan'208";a="59710636"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 14:53:40 -0700
X-CSE-ConnectionGUID: 7M8ax85gTf+qKE/F1K6eTw==
X-CSE-MsgGUID: 2e2nZAgJTkuOs978G14W1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,279,1751266800"; 
   d="scan'208";a="175060953"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 14:53:41 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 19 Sep 2025 14:53:39 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 19 Sep 2025 14:53:39 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.32) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 19 Sep 2025 14:53:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PmV0106qdnJK6kzcsSdFfsfJHPDU6UwEdprjdNZLFMV5z/cwCPcdxdN7XZpN5WJ5rXigA4UyCzO7vIT49Q/85X+uIbaGkk13FvEcojNDzX1aoix/TkvsPvnDMVhnjuA38lE4CFVf3zdfmII7n4JntDFEC3uCTHiAh1+AXAxKN3kTj0WJya/6ldgJmcH/RtFJdiRV+/rvM9D61ytGZqmB2aEH4I6vUIiqJjPijXT2dWyRVEGjHICzozOnoJONfRGysuM7/mMpuNtSv5NWh342P1tM1IcfSxoCyEL63aIINo6e8/dKrLpNK/5aKmPUxxANniPpkCFCcOrkH/xdv58nig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yDfz+RZQ8amc9TXW2p0rGkqP+6bG8IBzV//6hTwaG1A=;
 b=mZU6t/vd78F27nmMRvI1O/zxqgVSTzteyjrX7saCw7AC/0v5j6ZoI7mQv058FYSgnDTdiJeTIaFLinfnWsYh3SYQLz48qVFWHi55Rv+zE41tsXQ4VrOh07Y5+MQ9fOeb8bHXRhuRmfXSKocNRkx/7dmbl5Tjph4irSOYQ2NDpR9guw0ViOuMEmvXwJ8kiSUS+1s2GBV+PfLkN/jFqxmaubkM+cTIjV3y8DQwvx8S95nMIup44cXl+19/MKgriwMym9SmoPdSkBjh/Wp4Zjvwx2EbPyEzCyDJew77fREc5dRf/JTt0ALO4Qb8cLfDSMOXCGrjBWY711oOrNEDj4MLsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA4PR11MB9131.namprd11.prod.outlook.com (2603:10b6:208:55c::11)
 by MN2PR11MB4536.namprd11.prod.outlook.com (2603:10b6:208:26a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.16; Fri, 19 Sep
 2025 21:53:37 +0000
Received: from IA4PR11MB9131.namprd11.prod.outlook.com
 ([fe80::7187:92a3:991:56e2]) by IA4PR11MB9131.namprd11.prod.outlook.com
 ([fe80::7187:92a3:991:56e2%5]) with mapi id 15.20.9115.020; Fri, 19 Sep 2025
 21:53:37 +0000
Date: Fri, 19 Sep 2025 16:55:35 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Neeraj Kumar <s.neeraj@samsung.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<gost.dev@samsung.com>
CC: <a.manzanares@samsung.com>, <vishak.g@samsung.com>,
	<neeraj.kernel@gmail.com>, <cpgs@samsung.com>, Neeraj Kumar
	<s.neeraj@samsung.com>
Subject: Re: [PATCH V3 04/20] nvdimm/label: Update mutex_lock() with
 guard(mutex)()
Message-ID: <68cdd157cf7be_1a2a17294f1@iweiny-mobl.notmuch>
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
 <CGME20250917134136epcas5p118f18ce5139d489d90ac608e3887c1fc@epcas5p1.samsung.com>
 <20250917134116.1623730-5-s.neeraj@samsung.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250917134116.1623730-5-s.neeraj@samsung.com>
X-ClientProxiedBy: MW3PR06CA0007.namprd06.prod.outlook.com
 (2603:10b6:303:2a::12) To IA4PR11MB9131.namprd11.prod.outlook.com
 (2603:10b6:208:55c::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA4PR11MB9131:EE_|MN2PR11MB4536:EE_
X-MS-Office365-Filtering-Correlation-Id: ec0afc6f-38d4-4510-8f44-08ddf7c6fcf7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?YriqdGYjbsu858VnzvOk8YlVq7w+WP/1oCLHpDGlWXMoyNSjyOzgOv1qnnPz?=
 =?us-ascii?Q?PlqQeeoaxlfpocBEmSQY3K4IMKZBn57dYGUx9yXZD2Hi71acXY9w3eJ01Rv6?=
 =?us-ascii?Q?vIUS7a2F3LANVFg/svQq4vuAr4mHL96ywC/Pi/nCPdG4Mr98BDpZ4SvnNapi?=
 =?us-ascii?Q?cMaCer7ycGx21DEUJR+AhsY0IYi1a2oFx3A6t5MB9klBUH7hIb7JSX4XUSqP?=
 =?us-ascii?Q?jAALwEB4sCpnLblSuPQ2dvQnxMqcxHkpulX6DMtkajcA7aHNYJ3edP7M2Fn3?=
 =?us-ascii?Q?MfqNuDpTuFq7Bu9S7vKIdqsV3Y6IiM3Q3nFYX4+PMoVCUzGRxGqSkALMuD7A?=
 =?us-ascii?Q?gB5U49B636nf1XEAq+5PJrKX8xHAM511izukXikOJaSysoZlfJ2BzWfjWmWb?=
 =?us-ascii?Q?PjNF899f0fcZVzn44//Oj6guv9lG9CsRUKQYqYUoyPUU9ZcQ3mBLvWISvpUG?=
 =?us-ascii?Q?kVf/bbcK3LBqSNBfadDVnAmPnbiY8l0lVStAuwjnpkEyyjMa3Z/2sJ29dChV?=
 =?us-ascii?Q?61i0N94XYCFgNoXvN2SeNKAFpTt9zKzPeRZxkIDyXtZB7PqLXrKMZD8I3KOp?=
 =?us-ascii?Q?m0LhII21lTYOvbG71YFhMxxf+i7SmbR42iuK4pgZUhACM1CI1AQ4q/fKEtXE?=
 =?us-ascii?Q?dMLDo25n6nmNE8eslwI5355uLoutjBm54pitj9p6JAyBIB56SrpwMxRVUfhD?=
 =?us-ascii?Q?AD/01sJJi1tMCZZDFQcQyuw7wrmNS4G0PlkHvDha8xxF0tUhYuVtDbQ3Oxdw?=
 =?us-ascii?Q?qOxjf12Udsz0Cj6kRDLRfQ7wC+yY2v/TWzo90pteql23q1XG3cTnavngJgPJ?=
 =?us-ascii?Q?ajjw6MWZc++aLaZuc9k7KVdiD0edCErlOm+WQ0ZGE7a81iJ9Q5RyezVE7geF?=
 =?us-ascii?Q?XT/VOTjAYbq6e7Mp/9kH4xNLFAvmAc67iIKANjU91dpxLJ3kp0ekvVu7i7sG?=
 =?us-ascii?Q?Dgt/KG/QUmL2rT1EvGgHu0Dx2U7TIeIvUbbQmr4Owt/YKb1+WXU5QD/7mDv1?=
 =?us-ascii?Q?CqOPN5B53mG4aTEX8eLkXHMmrx5+HtiKD8BSjug6RWTKK1xpu3G77DMrtfnk?=
 =?us-ascii?Q?+CJflH3ciKqJ2IH029s3JNoeUZ5JddRPMPyDxHeeMSVvY5rYEsQZ2Up6WM3o?=
 =?us-ascii?Q?5qLsCsjeBc1Zi01K+65o/PUj0yJKOR0VGzFVM1PqUefFV0qy0MBV5OaOgnP7?=
 =?us-ascii?Q?Ohe901jkuFTUESrU4caaPxfCz/M/KmodpaBDeQKggUB0iq1a6oq99H2K3dsc?=
 =?us-ascii?Q?tUgkOdt57g75eLgVPnmV2Q7ecHuvJjZRyDTJgdZHWRg37TLxC+jBzyxMRMci?=
 =?us-ascii?Q?6to8WHM0c3cFubPqdLznct6RnGjwDGvNYGCkaKWDsiAr/eT9DQb8ZBOMGY+9?=
 =?us-ascii?Q?0hc+PGQQPJbvBu/RBiCFapK1JbJVhX/FML/45prtXmfqUgkda+fUEC7vYdfI?=
 =?us-ascii?Q?+hu0Ql0jzK4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR11MB9131.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VUnzjLXlamVzvJZWG9xDweQj6Wgi2ylQvZkN3YR0vuekrOXxFOf7njwd3Y/n?=
 =?us-ascii?Q?K6BzmTSZnlk0aIZ7cCZMFkpIVq0PP5WaznXiNpX6z6sk8I/hojaUyZR0UdwN?=
 =?us-ascii?Q?qIMOgLLfGI2NVJlIDbhRqDRjW1lGyyQy/mHC5XixHQ6xSmvqQ6t6UpJthAxI?=
 =?us-ascii?Q?Tg4vHEwSICLPS7DFaHBtPeZCT3qSw+Mfku6LELBy4nd/+CE666WqeBYhd863?=
 =?us-ascii?Q?ks5GbmpL4n9sWFsC+Y23FytBLDysGxOmUlb8/reWV+5lf6AQZKTXnP8Sw8aH?=
 =?us-ascii?Q?ZGdU0i3CePgHQbbzO0geGR0oMeNdhvTG6fzu7lwc5Cu+golKXQ/Q+XdGku+k?=
 =?us-ascii?Q?UwN8Lg/eBndtlcB8pzD+9o8iuZDauMl6RcHY7toQahONeX4mne9wCpA4oss3?=
 =?us-ascii?Q?vkY3wp+Dg5QYpixqjQ+2CDzGGcKn2ezduRqhx1/W0JMc73F54kdsbbnPQlJH?=
 =?us-ascii?Q?zH5E26yQs8sLfvsDfxyI2eeVhrKg/Xo0H4eW3qhTMTHVghNn0Fdcvw7DJXCe?=
 =?us-ascii?Q?0ygC9yQ5dKoz2WtUBcWVT4wM4hP4mFXapVQd8hHMHbgnWu2+yRMAe86yCIaF?=
 =?us-ascii?Q?rDsrtO0wvqRedstFKE7DdUE5idMfs91fub3lQCwOiD5xBgZ0WdXf6tH7IANQ?=
 =?us-ascii?Q?Sx2ufbMkF0szuf93E8mU1qEdzlwmCf1tn1X0Ay8e6YaRtMSjTd348udN1ax/?=
 =?us-ascii?Q?4qbt/qobR4e/fda/DmP0HjMwVBU9EJnLg725aWbSgecNyyyecmYy7QDH1/0a?=
 =?us-ascii?Q?gCCHje9Q+swpN/FVetJPHxB9+5qq1JWEU0WbIfgaR+U6+8mkdwBpUb5JvsD6?=
 =?us-ascii?Q?tPMkXTuyV3kK/YQV9YUYpcJSwAPit+WAbnETHBVPl5ojOY95thhvL3BQct6k?=
 =?us-ascii?Q?YZdZS7XuOOaRnlGLfkbU9/KDbp3pHJqsaCvVWitYZRGw2jh7PpcXmTl3jKTj?=
 =?us-ascii?Q?wgS+XdADZasSFsYmo4w0Fk1X1t5bkkgEye2c9CTCzf6yJnbWvqVbCe65qeqi?=
 =?us-ascii?Q?zx0xi9hYjA6LIN3eyDiQtNVPS5Ku+8qL9RmRP7tLzrGry8/CBNugV5GJ2dTp?=
 =?us-ascii?Q?2YWiJ38FCUn/xxSx56+lRYZRibLGzMLD7mA7Y064mB4tAdLi0iS4iVh+Ns7K?=
 =?us-ascii?Q?5mBkBJSreADAucqyIncFbnHnygjiI+/7AnAG1NrFOUDUFruiJZaQBly2DZHd?=
 =?us-ascii?Q?LhPsoGuLKNqQIEANO+VuGlysSSUk239ICR+6qpbkWJN5jGr3wZOtENyhiTfv?=
 =?us-ascii?Q?6WLd8l6dOD9gN4fMSH7mXgGbJz/EFEjsFDVMYpVrEAUFTgvWszUnDFgQYv7B?=
 =?us-ascii?Q?07MD2waRkTWk/Sb5r/axV53jeqsFwkEV8xbA0i7lWkwuf5RRJHzqmdz0SfNR?=
 =?us-ascii?Q?JHpn4801pLz6gxlS3smmrWzb/mzzKmJNhy98wc7NK2p9MDze0OvHdHQXPZn0?=
 =?us-ascii?Q?POpD1uAY/BzD1Wc6UlFoyypWf5BHknj49Rw3qZK0nJ6zm27zHIShPYEliUfg?=
 =?us-ascii?Q?kkkVS0AxhmWcG6uDJUqlSKsTkiTWWV+t0a+FN8A+4zATrDAd3DdrM0toZIj6?=
 =?us-ascii?Q?xPRdcygUgL765mUQOwK9X2PS4H3pTVmr5ay9nDNh?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ec0afc6f-38d4-4510-8f44-08ddf7c6fcf7
X-MS-Exchange-CrossTenant-AuthSource: IA4PR11MB9131.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2025 21:53:37.7573
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lD4ZyrRhhti86TNVQr0nYZc6xJB9jsLXW+wM4UyC+12sMU50Q+XY7uEJ2r9bgEL7mUbWRLDYG6qlCe7WPpjDvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4536
X-OriginatorOrg: intel.com

Neeraj Kumar wrote:
> Updated mutex_lock() with guard(mutex)()

You are missing the 'why' justification here.

The detail is that __pmem_label_update() is getting more complex and this
change helps to reduce the complexity later.

However...

[snip]

> @@ -998,9 +998,8 @@ static int init_labels(struct nd_mapping *nd_mapping, int num_labels)
>  		label_ent = kzalloc(sizeof(*label_ent), GFP_KERNEL);
>  		if (!label_ent)
>  			return -ENOMEM;
> -		mutex_lock(&nd_mapping->lock);
> +		guard(mutex)(&nd_mapping->lock);
>  		list_add_tail(&label_ent->list, &nd_mapping->labels);
> -		mutex_unlock(&nd_mapping->lock);

... this change is of little value.  And...

>  	}
>  
>  	if (ndd->ns_current == -1 || ndd->ns_next == -1)
> @@ -1039,7 +1038,7 @@ static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
>  	if (!preamble_next(ndd, &nsindex, &free, &nslot))
>  		return 0;
>  
> -	mutex_lock(&nd_mapping->lock);
> +	guard(mutex)(&nd_mapping->lock);
>  	list_for_each_entry_safe(label_ent, e, &nd_mapping->labels, list) {
>  		struct nd_namespace_label *nd_label = label_ent->label;
>  
> @@ -1061,7 +1060,6 @@ static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
>  		nd_mapping_free_labels(nd_mapping);
>  		dev_dbg(ndd->dev, "no more active labels\n");
>  	}
> -	mutex_unlock(&nd_mapping->lock);

... this technically changes the scope of the lock to include writing the
index under the lock.

It does not affect anything AFAICS but really these last two changes
should be dropped from this patch.

Ira

>  
>  	return nd_label_write_index(ndd, ndd->ns_next,
>  			nd_inc_seq(__le32_to_cpu(nsindex->seq)), 0);
> -- 
> 2.34.1
> 
> 


