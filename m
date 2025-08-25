Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 087F9632
	for <nvdimm@lists.linux.dev>; Mon, 25 Aug 2025 01:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756085828; cv=fail; b=J4sOFLL5/kq/vhIujZhae1fVIrEmDNLqYyJeTGfQ3BOXimMHkkLZiyFukcZZucb6d157qYzfXzM62mImoXL11/xcVDCEr/1t4sI8cPiEAHiyUlhigAyu839JAErUqZHLjDOXUMJ2ZHuSsXXtWodT7i9HeokZC2tFi/BYH/l5QgM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756085828; c=relaxed/simple;
	bh=a4ojuTzXAuGmyCLKd5OvsPCQNJigPSkxvDlxbZA3CSk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=PhPHE4yLH9Ez/EBm1sjL5OgNPohFoKJbVmvnEGBajwxxcIcD3yRrGcTgCqK57Wf4dJdsiNzt6eA+RKnQ5spCxxshPX7oTYDBEmS5ak9vzpeq1FaIRHxCAYOJgw1OCvmgTlOT072ckFzWNN0IBHsrjLLW31Q6rQcyqfGncqOSdaA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XL2tYCVY; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XL2tYCVY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756085826; x=1787621826;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=a4ojuTzXAuGmyCLKd5OvsPCQNJigPSkxvDlxbZA3CSk=;
  b=XL2tYCVYYEPT7sFx/vlaPgjZ5z6vBI1Ieeqm4wz7Oqt73AR1D6cHAhOD
   P1+FoniN6YnGT81DD3mFTnyNW9IW23wiSKSiVLtdRTSbgOBLQSLE1HG2u
   HLtjaMMveDj4i35J0/SPNekt6CLYU96gYMeLt6Sz4wS4LyQgs7x2KTtqj
   uDytQcbOvVnC6DG4T+73a5mgZmvd4u74XxfkfojC4yBU2Odq2Z6zCUTPB
   1cJlYEcVA9UFZpsTixyZ72nnLCNnEP/+No4O04SHTSQEZlzYhlzXdlx87
   FY1ph635V22FYautTdQ9lWzku2J6JN+rGGp7EbsDIv71ODa7j2XseMQOQ
   w==;
X-CSE-ConnectionGUID: YPN3ePybQPG6zh3DVZPxyw==
X-CSE-MsgGUID: LqVKORm+RFCxhMKxSHulaQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11532"; a="58390201"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="58390201"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2025 18:37:05 -0700
X-CSE-ConnectionGUID: QfXotE48RJq66V437NV/yw==
X-CSE-MsgGUID: CEK8bu6ES0SAK9f1aORMjg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="169088512"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2025 18:37:05 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sun, 24 Aug 2025 18:37:04 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Sun, 24 Aug 2025 18:37:04 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.48) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sun, 24 Aug 2025 18:37:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eC9Z1PhoRRDZTNmhtV3h2DtlGpCJu2pmNbGns+m8XY2meqBiVa6VhGK4d/eMIYa6IqNNvq6yyGpsAZ9HaaAUuo7DidZ4kgX+Nuby0DP5HwNhbZnVMaSEzNYLAbo1mP2HMHny6t+5DzE5v0Xyum9Yc62sKJLFG7hnXYYnczpvN+T9w/wA0K3JZKZjRTjMLTojMgrbgnrfsWaeokJe/5iSEQueVjB6zaYM0MdFH4CKwItyACkGj/fbI7eTrg39LfRxWqAlO/JMaKnUq8pha28L3Iih/i7QzmNQkqkO92E78Q7uJYQd/s8xIHfC+DFApgTg8Sz8RWPVUD8GNEe7d/cfhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GpMWMJK0P4PpQrdV3r9oW2vJj0nmu1wTMK4Gvg04szw=;
 b=v1J7B9Acx0egA8tRYZ22UngfJLb9ZlJi/sku67dMCCKcw9mAoOsOOBL499l/xrN8jxj12sqObwctXJVYYE3sWiTojnWfTszZWwbONT90x8Jfeb1k8AO86MCkLerL+W60zte81Z8Qc5hTCeMQu6QFpM52iRJTar1ZEOWsPs3+BDAWYPSDIwlyyxbKHHa3FW2qusXdtr+ICnrEt4lsW5LQtB2VqiyADP1w6KAu/POfkY5ebUu7RiyKfWYvqLk/OgNxNMDC7ZW9rwOOBcMuX8xxuuHlQUKpZIR0G1XBgDMA8odMLGgk7mpjCX8ubJ5pvHc2TKBJdNGXrZVtrC5JSU49kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::80b) by DM3PPF5AD378C3B.namprd11.prod.outlook.com
 (2603:10b6:f:fc00::f24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Mon, 25 Aug
 2025 01:37:02 +0000
Received: from SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 ([fe80::4df9:6ae0:ba12:2dde]) by SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 ([fe80::4df9:6ae0:ba12:2dde%7]) with mapi id 15.20.9052.013; Mon, 25 Aug 2025
 01:37:02 +0000
Date: Sun, 24 Aug 2025 18:36:56 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Marc Herbert <marc.herbert@linux.intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dave.jiang@intel.com>
Subject: Re: [ndctl PATCH] test/common: document magic number
 CXL_TEST_QOS_CLASS=42
Message-ID: <aKu-ODDskusx6k-t@aschofie-mobl2.lan>
References: <20250822025533.1159539-2-marc.herbert@linux.intel.com>
 <aKizZaxYjEJ3g_Rc@aschofie-mobl2.lan>
 <19885c2f-59d8-45d2-9d2a-456d9f4b8304@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <19885c2f-59d8-45d2-9d2a-456d9f4b8304@linux.intel.com>
X-ClientProxiedBy: BYAPR01CA0014.prod.exchangelabs.com (2603:10b6:a02:80::27)
 To SJ5PPF0D43D62C4.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::80b)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PPF0D43D62C4:EE_|DM3PPF5AD378C3B:EE_
X-MS-Office365-Filtering-Correlation-Id: 0873424c-7706-4f5e-c94b-08dde377e1d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?0OiejwHu2yYn7WA+BVPphRt0zAuROfdlrhxhB29itPQrOWq3WJgBlZLTByYK?=
 =?us-ascii?Q?agBocjQYpWLKyZIvcMBYPjummgS57G08a3hyGTQRxxLjKU2KlJDlkdm3mtN5?=
 =?us-ascii?Q?gmKTShE5umk/euzg97dxI5dnqDt8XKUNyxTivppWRB9exrEU1i1DT4KJcAUv?=
 =?us-ascii?Q?OtTPOvKqBhvVbbEQLJpAOaJWXcZaSF1okR0PyTNAgOW9qungz37NP0ahVbvZ?=
 =?us-ascii?Q?84bmZgZticuSWemTj8FJoxh4SbHGxEDtOoaopuxz4dOdnw6hPgWo8u1Mk6ds?=
 =?us-ascii?Q?MMJhmdJzjoqTFDbJLvl6rvV1unyUgo8prNRpW7QsNLiqyc45muoxobMmE8Re?=
 =?us-ascii?Q?p8QZfUZHolGPG7jp1GOJ7OvaFDr/Uf11rudpe6J+GMUF1H+yeWa7l/vAWTFE?=
 =?us-ascii?Q?NPiG+Dt4wzACTtDJgI1RSZZlN80muBZAgET+Q3PmJMN/i9Noaznr7nQNSj6K?=
 =?us-ascii?Q?yPswp4VmmskInYl2KiCOaKcrL6PXuT881sbV+64FyaSr9kXW0ZEqfa8gEiyc?=
 =?us-ascii?Q?dszHmiVsjI0lubt81t5pnXOytxiigzy0veUpIYEwG4BvhFE20t6e0/WysIrt?=
 =?us-ascii?Q?jQ6WH3nx2D9ud0bcOh5f4r+Yz6I6ayuMgmqusCsQ0wlHZR1LppsHEDG1rnG8?=
 =?us-ascii?Q?pgtDQ46oinqfWYkQ3duBhNbBhDo3UOyo7Z0YsvM72F0kim+DtIZ2tMQ1WILj?=
 =?us-ascii?Q?iMobBRIk4ammajD9fs67PtGMpP3C48Q2GtgFIJjyyiqu8+1ceeC148sLz1th?=
 =?us-ascii?Q?hetTnueK8ZkjSsuhLygUQvmi9Qat/X1AXriMizdpNCnVcXpj+CwS5fOU0mFI?=
 =?us-ascii?Q?fY202X4PeKcmVL/J8wQ0ltMgKnEy0fQvTewi7vmLbFb12uA9iAODtFWf+vhi?=
 =?us-ascii?Q?kEuXR8mV5tbvT0luCfxb5aGQMtaIb34MRBZOuZNY0LQutv1FKTR2T41ovOmd?=
 =?us-ascii?Q?TIHqEnfG27DtlgQI3jgAr3FA26jUZ7RcFJ031y227RBz3CFKJAzZNvUUDQ6u?=
 =?us-ascii?Q?+LD723o8UiCwBeIlmHQgujL3UZcQu/OtG9b6l4SeAIT+UuyexLz4MsiO7TIi?=
 =?us-ascii?Q?5+YIOmv3NxfqMqwtX1rgGFWB92xqcpzXroUhFJ9eBsj6EfV22YvU2bInAKH4?=
 =?us-ascii?Q?BqOl49c1DG5YjVrigWZhs4vS3NrGhMzEz825VHxiCojw9AauKLSEQVDxuRGZ?=
 =?us-ascii?Q?/LwxTeHn9gDtxJ7Ngb/Me0kWgc1JIqqPybP1ZM8bqR4gkxb3G4XFqEKZKGvS?=
 =?us-ascii?Q?lt8Du+f3gFWv1kFy4B4TflXPsYj+QuScTU0EnWidEGalvxtoi9jXLI6Jh0Zo?=
 =?us-ascii?Q?Af7amIFhGL+Ext53Tr9dNsTXg63JjrK5va7aS4GHSOvX53pz3CT/177VJsLz?=
 =?us-ascii?Q?Cc3cBRnagrvXClyBNdaaDBw8mN4HiCABJi1ImuLdiMnzy51qxvHeaF9FoC67?=
 =?us-ascii?Q?6q8PmeALbRg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ5PPF0D43D62C4.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1OcNJjHIOGtvOUZUFNT39Sbaz6MfPeAr4Xi+nmmUr1FNAedYjvLLPrAJWkXv?=
 =?us-ascii?Q?zfae1Udf1P1rYnl743LXnyx5XdawEXGx5h5eIN8Fg4GDDbp1J1gxBmASXMg4?=
 =?us-ascii?Q?U53wxkL1V6j2rWdnBfA4TBH6HeZnebL10neI9wewGhcagoqRzFTbBJzRlDm6?=
 =?us-ascii?Q?3dhZ/7cEggy+SBkCxWbQdb4YaZHcr1HHKxyDDHB2Q+2E9EUNTUI8G8Mv/JEP?=
 =?us-ascii?Q?viDs1rD/UYgJGo5ezb707bj0790c8+zVhJHqZ5ch2t26ECijzNJrFBo9Z7+K?=
 =?us-ascii?Q?o6Mc2dySIx1jOZhQzk+QYHwGKfLfomiQfL2QiNlAYiMQ4pggd1u2za9+XOhC?=
 =?us-ascii?Q?Jl/AghHqbphtWIEqNt32GGEVSY9TyhmechKM/w3sKhXP00MG2YEuG2ob1KvK?=
 =?us-ascii?Q?KNEw+dnflviRtivhZy4oC2r2mQkgt5ymYOaZQmEmq1oPJfqkKkK9ZY/X6blV?=
 =?us-ascii?Q?5iP+XnhcjXhKMBzDqlMoUgBNb3fnDUZ6cDsqU+H/y8NRY8aHEhN1AyKqvVo2?=
 =?us-ascii?Q?qyVMixlhsNrZutIYfkWaZUiMfsDspIrxYddguR530nLcZcfi6YYpZqW6gwHI?=
 =?us-ascii?Q?Y01dCCqje7T8dBN+qRvUIHl+6o7sIoKpEk3JMbfOZBnfJRUpE+cy+quLYHfd?=
 =?us-ascii?Q?BDlui7jyF0Avkrw1aNB8ba388+mWYfn0mOaYxDUbv6wm69IFmXpDeRwsxbfP?=
 =?us-ascii?Q?iQj0ll8EC3kg7coss/VvK4HxBDxbaZzjDSPoDLQVSrdvf2chHU6uRvHLB/Aa?=
 =?us-ascii?Q?yuyEOZU6GwRx7dPHnLapD/gaiUYQz9f74oVDN2y7mKuE+rqzrsOFLXdkn179?=
 =?us-ascii?Q?9Z4C9gKJGNHGq2DUbfioF5FyTKab+EmeSDTUC5dy2vFbN697IIhiIt9dooA5?=
 =?us-ascii?Q?tHcZzCbVxod2C2bt1aS3Z3zdEHD5K/yTMpfmgvNAmjjfwYxv9UB+je1eAecc?=
 =?us-ascii?Q?CoSGy8NqdonTR8nt2sUpelIaQiCbTBXQBiAcdF+HC1BPbtSMge11nMRmBCSK?=
 =?us-ascii?Q?a6nLtLx15WFufQhD3TwadR+0qYXbOwCC8lbjOmTE+J5zJDT9Kk0KIy6IEGKu?=
 =?us-ascii?Q?bT3tcM0KHL42WA92wJwRP+xAVYTnk4X5dX8TeCeNx+s6FAXRWlT0Ck2QcCm/?=
 =?us-ascii?Q?BePcQ1/9uigRMTbApNjZQRD6fR3PPyDx2z1x96pWOzIiyyr1WiD9njXna1qu?=
 =?us-ascii?Q?TXx4qaNwBi/ivsdS6LP1426OuB+wZjj67R8kxUzgLR96BEjIEW57P9RuszLE?=
 =?us-ascii?Q?/KeS5NkprcQS05dXW8h7iHOkGvBUUK+JRdfxHeqqDBOCCcvklo1Vhp76uCnO?=
 =?us-ascii?Q?9beh+oV5kLuwSHOgWGIvCyHT7Zn6oJrIU+j0xWBmFFU4r15QCcM6Vj6gCggr?=
 =?us-ascii?Q?+Mc7s51klrLttqGpumYAL7CgJ0G5syFhc6diacStYMx8pF5p2bWq+1dZbpqJ?=
 =?us-ascii?Q?RPRY4vBmx6com9EEN6kf9+jYcz9kW+3kKaUBVlBIxlPsHatXKJuJ2WlmPkyz?=
 =?us-ascii?Q?MqRlq0eh2dv+c2wwUT7S1Jv4vi8mfZ15Q+DEc1FMpn8v+BVwXuRR74cQrsBP?=
 =?us-ascii?Q?xqrFSvCbu8xcmFzvPtgvWEqp0n5O0DQGWO8pX/tGkLUd1ph0F9Y5656O3kNQ?=
 =?us-ascii?Q?vg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0873424c-7706-4f5e-c94b-08dde377e1d0
X-MS-Exchange-CrossTenant-AuthSource: SJ5PPF0D43D62C4.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2025 01:37:02.7633
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HJikUF/2k3D7GVFLWW4Bnw2a2fGY1vUvzVt65LDz38Lx4+VnvSHSiSeFu3zGXGz9Lkz9gnxoFJb1Q4nFrgUg+t992dztYROSoYgGxT//NdU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF5AD378C3B
X-OriginatorOrg: intel.com

On Fri, Aug 22, 2025 at 08:07:12PM -0700, Marc Herbert wrote:
> 
> 
> On 2025-08-22 11:13, Alison Schofield wrote:
> > On Fri, Aug 22, 2025 at 02:55:34AM +0000, marc.herbert@linux.intel.com wrote:
> >> From: Marc Herbert <marc.herbert@linux.intel.com>
> >>
> >> This magic number must match kernel code. Make that corresponding kernel
> >> code much less time-consuming to find.
> > 
> > The 'must match' is the important part. Include that in the comment.
> 
> Good point, will do!
> 
> > Why expect the user to parse a git describe string and go fishing.
> > Just tell them it is defined in the cxl-test module.
> > 
> 
> git knows how to parse back the git describe string; readers don't need
> to parse anything. As explained in the commit message, it's convenient
> because it holds in a single string both the immutable commit ID _and_
> an indication of the minimum kernel version required.
> 
> Why tell users to "go fishing" for the cxl-test module when they can
> find the location directly with a single git command.  This is real: I
> actually wasted a fair amount of time searching for that constant in
> drivers/cxl/ because I assumed the cxl-test driver was there. This
> comment is not meant for experts; if they needed it then it would not
> have been missing for so long.
> 
> Last but not least, code and files move around and get renamed. This
> commit will never change, so it provides an immutable starting point in
> case things change.
> 
> I'll add both, it should still fit on one line.

Marc,

I didn't infer the pain you go on to describe here in the original
commit message. I read this as a trivial patch, and even questioned
(but didn't comment) usage of 'magic number' language on value that
had a define.

ICYMI 
"Describe your problem. Whether your patch is a one-line bug fix or
5000 lines of a new feature, there must be an underlying problem that
motivated you to do this work. Convince the reviewer that there is a
problem worth fixing and that it makes sense for them to read past the
first paragraph."

That's from
https://www.kernel.org/doc/html/latest/process/submitting-patches.html
and ndctl/Contributing.md notes that ndctl follows those guidelines.

There's a lot more guidance at that link, but following the basic 1-2-3,
emphasis on #2 for this patch, will help me review without missing the
point:

1- State current situation
2- State why #1 is lacking, painful, broken, needs enhancing, etc.
3- State how this patch addresses #2.

Perhaps:
[ndctl PATCH] test/common: document the CXL_TEST_QOS_CLASS kernel dependency

1-
The CXL_TEST_QOS_CLASS define lacks documentation about its
kernel counterpart, making it difficult to locate the corresponding
kernel code when debugging or verifying compatibility.

2-
When tests depend on kernel-specific constants, like this one does,
the lack of clear documentation leads to tedious manual searching.

3-
Add a comment that identifies...

May also be worth mentioning that this issue is arising during the
testing of kernels with backported features where test failures
may be due to missing kernel support rather than actual bugs.
If that is indeed what is happening and is part of the pain.

I'll watch for v2.

--Alison

