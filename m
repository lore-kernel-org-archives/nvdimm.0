Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=198.175.65.20
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793987262;
	b=i6EFzi89nHb4CuR4VRy0AXiFJqUH4TqVFqAsJW3/pfLfky/BSYXJo0cvt/l/IQPpe4lt
	 HlIjsTAbGkOPtnWEK98my+Z3XrJB25DpJbt8wp9PANCGeWNDckTwnAOo/b7kt8bQrQltC
	 ffhR7O0huHuP1ZHXsNsZ2l6i7XQYcDC1RD+s+BJMd1Urv47NQ/rU9+MBc4u85yA6nmrEo
	 0ptSsZRJz+FqJg3wNmlhHOnTDwjxkHx/ijt0ivTeAU0ZeXJX8XzFMmcFolM84CI2WhR+M
	 7dLtlowVqu3aLx29W+9R7Eltf8n2YNlpf/XDBCOgBEWhh8GbJHO0DD5N+rpJau7B9Bw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793987262;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:Received:Received:Date:From:To:CC:Subject:Message-ID:
	 References:Content-Type:Content-Disposition:In-Reply-To:
	 X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=iPE485Pu/2Pqd5xkzfMQetgWlNFMJE/Jegi9raJDG8g=;
	b=OpwgD+NNRGygbFq1rneQ8umSE8HbFMxi8JZEaIJ9xw8BKN2BgHQdEqQYAw5TcZ/jf1Oo
	 nRRaCPJlWBKI+CBmIdk0rdQRNTO/R6Nq6bpqdoVOuDwQJtk3dOuy867ARZAVC9P6WVuBz
	 yZj/kFfIk250XNPiCP0Vxy0pUUDrjdHspW9ZBhKSqqz0SiU6L+A1xoNOBNeBev3r7g3xB
	 bTYBxNNzPCk/jNyJmjKSwRu11TKiSu0RB+ajwZGNtvAK4O03fWEfh+L4feItlxbezQOin
	 fniXsE2cSrUnoPwGmn3T7kASrAqQq2bByfiJM04EhjBfsXcwAR8LQv+pPrf5Ovwu7lA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=m0A4+Zho;
	arc=fail smtp.remote-ip=198.175.65.20
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52768606A32E
	for <nvdimm@lists.linux.dev>; Fri,  6 Nov 2026 17:47:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 52768606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=m0A4+Zho
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793987261; x=1825523261;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=zt6W3Sm/YNg2l2tUzH099YdcCmSm+sFlymmcTkkgi7c=;
  b=m0A4+Zhoo6/v9IhuyOSS1zQXjMKJtgQUQzTt615yonMYCoGgHBDiVMtq
   uxVLzwz7GQu2p1cUmpsGp5OWeEwjyIiGi3HYlmaCjlFslpu63uC/V6LtH
   wX3TFAaCzCkK+i9faQHSAnsl6WezQCCUEP1AxrK9KRd/761Esze5zkfEB
   93zryf/PaRH9K5pJS/7LW3qw7Sjf08hp+sSQUWArj5p1dA3ws2XX1B2wd
   KUp/Fi6V+xeCpTMAzVwo+FwfJ3eEfoM7DnsyKl+Lz3keA0HHNi8RxJ5/Q
   ffd77Jp8fiMQJoNI6+as5K8jUgYqK2RfQm35V/8M3TIVjUFBjao6Y2cux
   A==;
X-CSE-ConnectionGUID: 0gzf8YUoQDufYSCQyIBOTQ==
X-CSE-MsgGUID: GCsvtYlTTqii2qEiDPh57w==
X-IronPort-AV: E=McAfee;i="6800,10657,11958"; a="2835521"
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="2835521"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2026 09:47:40 -0800
X-CSE-ConnectionGUID: TPaMxZ4eSCC8BjEi0gP3SQ==
X-CSE-MsgGUID: 8h9eP0TlTsC91/merXyvsQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="7381864"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2026 09:47:40 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Fri, 6 Nov 2026 09:47:40 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Fri, 6 Nov 2026 09:47:40 -0800
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.21) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Fri, 6 Nov 2026 09:47:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R4JyAY2R70pIc3c5U5mPglJhrc0EyhsQqSNoQLkVDoOQCxESN9z5JKgL8L4xLOdrBt8/dRfk2Q5cKN13zCJNyCUayi65otqOKZvaYDJOMeD+CJYdkM2C93UmK6P62lId+wqKcBwMAR+Di4vXWW2LddeQQyugCx74rgAHw2NQw7NAv/IIlUHB4ZjNkA9HQMKUjDHgEu1odMuWZf5FtmuEdjI2MzzOThPNmktUQ4DnUfl80AeLiyH0Z3xezktoGU5stSmsrQYye/rG3VkVSkXNmHM6yVxkFDFBlpXwzl9OaI75KBFmOjNu+2/JK6GKpMjEcaAGLBAhxrRhfpbbvW/idQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iPE485Pu/2Pqd5xkzfMQetgWlNFMJE/Jegi9raJDG8g=;
 b=BdX0GlWXn1IwzSmpq4AnNYKmZvedSWGi7/FZKj49wDzG4TphtX7Tw9IQiCNQgrT/tz5tx2PMQsPDfvZFxt9qtPfqApRJbK+bDJVTDT8LYvWpV2aB8dNmXwOkJqLY2Q3cmn9El5PMQ9xodZqHqjRFRAP/fdrTooziEcrE+9A/qZYEAoIWV/E4VcoEPlLewW9gYgMEI2I+7LiIWjM5EquTYYvQcMqF5uwqin+RwTWj70paI/fvkowWK1NoX59rK5xsIRoaQBrENHXYXqFu+Aai8cT+MKkg0ZX5blYQy8uyerS+OmIzE1gIzoCMiREh1JXUDPnQAp5+Xtpsz69g439gIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SJ0PR11MB4816.namprd11.prod.outlook.com (2603:10b6:a03:2ad::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Fri, 6 Nov
 2026 17:47:37 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0592.010; Fri, 6 Nov 2026
 17:47:36 +0000
Date: Fri, 6 Nov 2026 09:47:33 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, Dave Jiang <dave.jiang@intel.com>
Subject: Re: [ndctl PATCH] test/cxl-destroy-region.sh: create RAM regions
 explicitly
Message-ID: <au4StZ9SWXaIXm0B@aschofie-mobl2.lan>
References: <20261106014848.938714-1-alison.schofield@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20261106014848.938714-1-alison.schofield@intel.com>
X-ClientProxiedBy: MW4PR03CA0067.namprd03.prod.outlook.com
 (2603:10b6:303:b6::12) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SJ0PR11MB4816:EE_
X-MS-Office365-Filtering-Correlation-Id: 38bc8e57-971e-4347-4457-08df3c2e0b49
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|260925022911599003|260925021311599003|260925021911599003|11063799006|56012099006|261022105027099003|261009223027099003|261026140227099003|261026121527099003|261028144727099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: Sq9hyV4x6pzupE3DXlqtJm73pWGjwz+QKZsmavsWriRqsQPijvq6cUPXbIwihO8Ma0jjRBsEiSaldZo5K4qn2ePmWxLFy59AhJu1t0cjIYh+8SADPvbyM60/kFJJvLfkoeDrG8FK0mRdNmcq/5f4xdIVG0tjn0po+FGz2xwuAOeIczGWidKEQ2CrEDXGIRlFmXPF7b8UzjAksBtT+DZEbAiRlMqkZ8PLaQykai2uEpt/AkVkwiaOD0bCtnrTnm8prTfmHioG9b6OVdnpzl+I7i3hq90inYzPMYddoOLNH8JXFYcNs4O5mdP/R3nnVq1Wt9OiFUB7nvhIWZmwJbv00j/wJp/9hzCmj9zzLZjurB+5kugtfGswPBT0nTS/18A9pu0GB32NK07rIFOyI0UuoRpOgaDLZ+ZBMT3BGDPMxBilZCB5z1qWzLt3jXPV1EkyL+YnTvLZGb2BxO72sUJ7Mrd6pSx8h/e2fleZmLRcjsBK/ZULNsynAdan5XBuF3cjC+lMUAbOvvGwzm6Ef5nco6eQK8MHwrl126zivKLt/wStWJdOzbTu13nI7KeMCawBtRgKROdS6Ty9jQDs38EtX5eYDM+V3uvTS1z8mzIzsFj3XfLB4rflAR7FHkVxFOKh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(260925022911599003)(260925021311599003)(260925021911599003)(11063799006)(56012099006)(261022105027099003)(261009223027099003)(261026140227099003)(261026121527099003)(261028144727099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Sr155ln6BNEkvtzHwFVroi1ymT9IMI51YvCMOQw2N3E8vGv8VKZcTtbP4rgn?=
 =?us-ascii?Q?jztYe4qKYYRTFgwyhVdJ+d0iz5pNTZEGdZ10yVXXVTAg+bd9mdnTEjUPAof2?=
 =?us-ascii?Q?j2SatpU2+7sTU4AJ+/lgTo1PI66R4Khwo+l2d9Nk71/ZgKWwDjxdP6Xk8DGO?=
 =?us-ascii?Q?4IS0SGLUSV585srtt8NsD/hxd4Czpdoeu2mQeGQ/7dd8H2Ty0dAVOf0huy4P?=
 =?us-ascii?Q?ILvSxA7CSUcIPu3EhAyz6FNiurs8FXCbwALrqJlGLwItecsP3+LKbMw0Za+n?=
 =?us-ascii?Q?PN85MxuTUjyj9DC5NPzXlisYEWvBwIe7NJr/qRRLl56AmTrtcR5uO0eJaYv5?=
 =?us-ascii?Q?VxVlEn2Pf4/5n2cvKkqJGBYNkdE4HNK+PxijM8zCA4uSlYK1zEF6FMkyZvBQ?=
 =?us-ascii?Q?iLzxaZBvb3twIS5JJt1sRpLYCehfcU3jfsjtyaHRPceifPt27AGou0opMU9m?=
 =?us-ascii?Q?YyWp2za+Ha+9Z1HhXf+TWrsjkn7BiNGBasRw6b8CETecUy/OZBypOS1cE0Uq?=
 =?us-ascii?Q?+k/SO5M9UuYR5viBal7NYknMhB9/vwqM36cIQ8pgHoLtzT1PYQCTFhk8yVUb?=
 =?us-ascii?Q?zPap3EHUl+ZRcH4CJPuSYh6I037QUaptpu2nhSyndsHvfYvmq80vBDj34tDl?=
 =?us-ascii?Q?/miaoWVYotDcXdZUENnupHlSkhdZHWSknwcB81+DE1Z4c/3dt7YwfTc9UMiw?=
 =?us-ascii?Q?xg2Fwl81O+aW8MM7jsgK+ioV6KurO6GzPTMTZcJ1TyQjnQ9e8CWrrDtsRguQ?=
 =?us-ascii?Q?cpFx7sQIscRryFBTIkmgtiL+O+NHLILJfeZpvRQZVcRGWTjKJiq4ir2GCSr9?=
 =?us-ascii?Q?Z+7WCrc4TucrQxKoV0MqErpj9reYOlljAw8CKFAE4yMgdPWvESNI8zg022qO?=
 =?us-ascii?Q?o2NJ6QfvpoGGCyEvmjzoNTWN+lxs92hUSALx8zXS+02O3hJDtWoHJ7tQJGsu?=
 =?us-ascii?Q?Ljtiigs7m523QIHM99G98V58yadHeQPTFuA3avivc16TLku95YjRIM00hlk6?=
 =?us-ascii?Q?d4wRQJ4HqNOEG3IbIhHTJ+mU7sCRILHDvZsrVkEV8APhLetQga41ZhfwCXq2?=
 =?us-ascii?Q?0CzMr/Ubi87shQ1UV3lom03A2h21OUQSaGnWRFAuIxfjsbOpLNuBg9j3LFWA?=
 =?us-ascii?Q?J47Fa4LchQATHHJyxrAwN48MHpb4R39N7PcVyKLVbXs8ewmdEBXHC7QHaht3?=
 =?us-ascii?Q?FN/388fEIF++WHGnYwHYr1zoJbV//swpD/3/NEzLkdk8mFLL8/1YaLidWIu4?=
 =?us-ascii?Q?sUGbS+afVc4W+pVtf6jZNKzQch8Of5KBufC9+samopEhK9z4gQY7pk91IUxD?=
 =?us-ascii?Q?l0B0+S14JnLzhBrsGzhcv7Vlb3EGBEkUmCzO67Q09QwPA1IeI3b79cyqV9Xx?=
 =?us-ascii?Q?q4S9kNRHUSWIhZ8DUDTWYIWF9nBiJlipxS+nu4ieh17osaY0v6qGRCudZB4j?=
 =?us-ascii?Q?uIlU6tBy4iEJ/dBZcocmhHtkpgttsMM2WBv8ax6Ge3Vojp8AZEmqqXdmPlM+?=
 =?us-ascii?Q?BamZlMicWi/m7Dk6feinvaIXtVxsXk1q4nRQNLV7+XaCMT+vwZ5eQ4Lor3y3?=
 =?us-ascii?Q?/65eJrtaqHxdy9rfDjOJscuX32UAr93V2Kziiss/PvlvcJ3cpqOAKC91MOQe?=
 =?us-ascii?Q?KBXf1UWrpclmqNPH5+aHSPq26XYFuDwOOZMeN8ETM4djP8/y7j63NviLUFck?=
 =?us-ascii?Q?UlwkHYq5ekfAmBavGm2Y+idkMSD6mxtwjoTo2ufDUo8jRk0BHyqLSXvYF4rB?=
 =?us-ascii?Q?TETM4yGz6dOyBYX/fjfnJWXT/iLLH20=3D?=
X-Exchange-RoutingPolicyChecked: f8oFv1b7rkNbzSTQKXl43x5pXgV2u9MOw8+wXy8N+YVGTCB7ZSVDtvVWbRB5MOHszY26z4oypvIcP7WrkWY3QurMcyahvemk4aYJvM3Xy/ItpLNvlRtVngAZQ6ZCD1V0snzc5ZhpSBgw+nTf1nm3ppbkY9/Fil9nncNDtlTbORwmFmQ+JfEPAcNMA9zIiihpyZ80IXw7kmXLIfVO08GIdqNNBwB7x7xSPwD64qTMgJXt3LeRAL4O5+hAhs+q3keOAgTWRAjzBYvQvKEZW2pqQpp79fO2l2yZlaEdkoK+L+G2CtPPjXyx6g3FMg3raQBrdWcJRFmHl5+E4h1dZDEnog==
X-MS-Exchange-CrossTenant-Network-Message-Id: 38bc8e57-971e-4347-4457-08df3c2e0b49
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2026 17:47:36.7341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rpZEH7L14QnEux3zfKf731RQYswPMYItt3DMPL8hG/g8tjIYEHkRRR1sO+pp4mU1O471g3lTGxqsQQ2drzVwpAU6uB0uLBQBIlgVAHTEWlU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4816
X-OriginatorOrg: intel.com

On Thu, Nov 05, 2026 at 05:48:46PM -0800, Alison Schofield wrote:
> The test creates regions it expects to be RAM without passing a type.
> create-region defaults to pmem when the root decoder supports both RAM
> and PMEM, so the test fails when it picks such a decoder.
> 
> cxl_test has one such decoder. Whether the test picks it depends on the
> memdev order, which changes when other CXL devices, such as QEMU-emulated
> ones, are present.
> 
> Use the '-t ram' option so both checks create RAM regions regardless of
> which decoder is selected.
> 
> This issue appeared while the CXL kernel patch[1] was being tested. It
> changes the cxl_test created x1 volatile window to one that support both
> RAM and PMEM.
> 
> [1] https://lore.kernel.org/linux-cxl/89e8d2cfde4f1054f37a4f48f2b206a7f05108f7.1793850480.git.alison.schofield@intel.com/
> 
> 
> Reported-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Applied 
https://github.com/pmem/ndctl/tree/pending

