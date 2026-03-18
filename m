Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2D503793C5
	for <nvdimm@lists.linux.dev>; Wed, 18 Mar 2026 21:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773869289; cv=fail; b=LeZwDvcEyi36zd3QY+bTorlfs4GYLfHYRAROTxZxRknTkupIpIpWbvw9b5jNqPjaNta+dlezdwdiz108pWOYrYT/kgQQRGIpQC9GOOTkjZULmdB41u2cg2M2Ge5a/WFfqC6ZSfeia7DgaITMyre6f2nKOWa1pr+cPV1XUz9sXeM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773869289; c=relaxed/simple;
	bh=Z5qk+ks+90b2AVjf2EWVCFJc7gJVYz5gRrgL08Pu3u8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=lmd3l3GUUFIM7z6s6o911yBZryYcGBKAJT9DDkDIdRFU9nKzpe6hrotRJlHViGTW7jnGIpOn2Ro58gLAmKGhIQ7QNkZ3irnybV4/intWbT9+GhwmdPqqc2akEXwkj4BeJVdiVXxxwy4yzTWBEM+5tE8uiWIVCmYwrDpieFiZXSI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TCpfc2eZ; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TCpfc2eZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773869288; x=1805405288;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Z5qk+ks+90b2AVjf2EWVCFJc7gJVYz5gRrgL08Pu3u8=;
  b=TCpfc2eZ+MLRbhjsVExBSdngHYdFRT31VaEO0IkcUc3AQMgAHqDQRYZ7
   Y74l9cSoDFRyDjXktFztfpYKp/QBMbfoNhqZE2EXQDp6St8BEoxBJPzXu
   bwCjYOS48NY674Ma25Q6ZVyvY9Pu6rQ9euv9RuaELwidtNN68LZMEZrdG
   Pibp2URRZa53Y38Zava6as4q29Ggtd7n1JXiIdj+5KW+znxU73Fgg7Mhe
   zbWwSpR5WVUfybPJN4lCX21gw0RXNDXqx9AjGIFXlF2KVx2xQcrbboF0b
   loXMkUeb5c3mS2zY0lbpcDHQpUrLms4YWUVA2+8QbRQFlt/b/vbEbwipu
   w==;
X-CSE-ConnectionGUID: xIQUui/LR4G3qfoBV1p1gA==
X-CSE-MsgGUID: UbfpUWuZTsWyALj3AID5LQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11733"; a="100395073"
X-IronPort-AV: E=Sophos;i="6.23,128,1770624000"; 
   d="scan'208";a="100395073"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2026 14:28:07 -0700
X-CSE-ConnectionGUID: juHgK9avRzaHsFLVgNeqzg==
X-CSE-MsgGUID: xxT/WWp2QluwRfXexQloRQ==
X-ExtLoop1: 1
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2026 14:28:05 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 18 Mar 2026 14:28:05 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 18 Mar 2026 14:28:05 -0700
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.61) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 18 Mar 2026 14:28:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e6oOQe4bKsTCr/MlIGa7zPDRu/hXEKOVkmgeDwcHxgkJL7czWIvx1+PVm+RlhnhyJ+4SB4foF0Rr9rM+Jsh3z2cs2LajHXgAq8m3kyOzyRxaPNIlw9jgPHM7rbqgw4HjnNcHCsyhFmRs7WJ8iSJFDVsgMTw1YJ7DGepy2vsNXtrHzCanDrO73YP7rpQ6gJZ00hNSR/YHy6qskUv4/vlfaJQmeva8Y2vbGsfHgKjLqqlOcEQJ7bxvxd8G3AUqJaL4zuAhSaoR43YBhYFwl2IxRKg5uGjJ69Pt4+EtpCANEsedSWD27BZ6BLIPqbIWBYGDNWsP793OZiCeTi6rtOKZTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Bo3FlpbkaZU/1M+TxJ0f0NqO26pCVxFuUb5/hNAkU4=;
 b=J7vsNEk8Wbn8bE6xSeWgltdcNBcy2rYoNDNGx/PJwVefl5gLvGQLAs5goSFXmyztRM9Bxz1653an7gixaXH5BJZVkDNNtFE6T/4aJO9FNwo+op63qhAx3P58WBYqIZfCwh4zcyIPT8h+YrFF6TXdWsHgH1MgtUQu+nO1MWvPUhNjvybqALFbAdwlAz+GtboEcmPsTNyjcfN/p9+TBpZ9XOTjppR1PreUOHCuSps4brZGMcad7oYT1AqyUDqYWVfTh3jvHkbEBhEFbJcKl8MzTDZyphybx1nXyRUGTnAanPrD0kRkXBX/JP5hqZEmGZRx5PawVXpRLEsoTCH9n7SPuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SA2PR11MB4987.namprd11.prod.outlook.com (2603:10b6:806:113::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Wed, 18 Mar
 2026 21:28:01 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::3979:c00f:fdca:b895]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::3979:c00f:fdca:b895%4]) with mapi id 15.20.9723.018; Wed, 18 Mar 2026
 21:28:01 +0000
Date: Wed, 18 Mar 2026 14:27:51 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>,
	<linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-fsdevel@vger.kernel.org>,
	<linux-pm@vger.kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Vishal Verma
	<vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>, Jonathan Cameron
	<jonathan.cameron@huawei.com>, Yazen Ghannam <yazen.ghannam@amd.com>, "Dave
 Jiang" <dave.jiang@intel.com>, Davidlohr Bueso <dave@stgolabs.net>, "Matthew
 Wilcox" <willy@infradead.org>, Jan Kara <jack@suse.cz>, "Rafael J . Wysocki"
	<rafael@kernel.org>, Len Brown <len.brown@intel.com>, Pavel Machek
	<pavel@kernel.org>, Li Ming <ming.li@zohomail.com>, Jeff Johnson
	<jeff.johnson@oss.qualcomm.com>, Ying Huang <huang.ying.caritas@gmail.com>,
	Yao Xingtao <yaoxt.fnst@fujitsu.com>, Peter Zijlstra <peterz@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Nathan Fontenot
	<nathan.fontenot@amd.com>, Terry Bowman <terry.bowman@amd.com>, "Robert
 Richter" <rrichter@amd.com>, Benjamin Cheatham <benjamin.cheatham@amd.com>,
	Zhijian Li <lizhijian@fujitsu.com>, Borislav Petkov <bp@alien8.de>, "Tomasz
 Wolski" <tomasz.wolski@fujitsu.com>
Subject: Re: [PATCH v6 3/9] cxl/region: Skip decoder reset on detach for
 autodiscovered regions
Message-ID: <absY10LzUqb3vK7A@aschofie-mobl2.lan>
References: <20260210064501.157591-1-Smita.KoralahalliChannabasappa@amd.com>
 <20260210064501.157591-4-Smita.KoralahalliChannabasappa@amd.com>
 <69b1e0aacb9d0_2132100c5@dwillia2-mobl4.notmuch>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <69b1e0aacb9d0_2132100c5@dwillia2-mobl4.notmuch>
X-ClientProxiedBy: SJ0P220CA0023.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::21) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SA2PR11MB4987:EE_
X-MS-Office365-Filtering-Correlation-Id: 42be1614-d73b-4059-28f5-08de85353b49
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|22082099003|18002099003|7053199007|56012099003;
X-Microsoft-Antispam-Message-Info: u1JOAgRKCSMU1OsxIYmFpCqnsyjaqdnyWDB/z31BIt92dT7vHpSmXygsxGhwO5U4qqtmp2rhDh/y+FrJQwjAloZyKe/SeUmWVGH02xliaTqeQgMJtoRncT8sS4X0N8BBMjgrB3NwkS8MhSNwOQyImFuXCmKNsj14n2fyiZ4YUVD98EpAHGwKolgtEWwUEBJEoESEucX6ymnAANAnYCwK7L2n8fschBGVrtErN5ujFWK3LeOhIdbJWk67a2NbcwXlyO5cvZxK5dtLaSmj2NLfUSHqiN31rfXPwm395o+y5IB6WfQ9Bs9d+IiZk7QDwEu4h+dQu3H1ce+afcVGa7j2YFqsbaO5pKgMOKatLBMkqxyXG2shbPJOA2M8J3jaP37JM3r4lxNGL5znvvTOcesb8rXF1AicaXV7yBGLS16Jdb9xJGvfnUU1ImJqLKqx1YJTPsx94NURz+PBSBJ9MYmfQkta/q8TcdO+QVeTwL7F6dlceJTptaGpSK+OdKNSWRfZVawJ9KSsPPWTwZ/NYzOY4FBg9X0pVMAOKbV5vlFTPM/Y0KWsdW6zCWhpI1Zgpyjlo7r0P6zHxI+K8CHtovOreCpBigV8tmPp4uLxvno3Gd9Ehrz9nnI54s7TrKKlvgyBg7GjHvanOfAycQAOA0+lk+lcS9xGlJj3ymZrk8UbFCHom/Og8N86p5TNCQWkCeMtmTI/9gf8cDDUdUHO7lzNy8aowm9IYsktv0Gf0Xxl3us=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(22082099003)(18002099003)(7053199007)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?obYkNARo8gXq31zSG5dsaMB/NnPKxpsQWYRsi0uy/0Y17LY66xCuXr4IASIj?=
 =?us-ascii?Q?s6MCWnuRGjIsGxFgVXKrDxUizhmQLpvYmtNu86hH5GmgQPdtQrpBUZdsKGY3?=
 =?us-ascii?Q?O+OQOaPxv+2DI9cU5PDkCdbdY6ToIkxkTvgKGVyb+7v4BoaMJ2ZHnDPa4ijz?=
 =?us-ascii?Q?vfE00nvqOPNdVRKK7KtSlDValQOCNgItFgFamSeZG5lGFWeq3BXZp8JacJR4?=
 =?us-ascii?Q?p6PmBXgaBPCNCAuPR75xTCyeQpbV7gLEJ87fzcfmI3N+te/0pSwDxXw+OJc4?=
 =?us-ascii?Q?As3bf6zos9cJXZ+TumMGJlZPccpjRfyrE4lmz4M2Vb6gBs+6k9Iejxh7m9Ai?=
 =?us-ascii?Q?dv97NaspKknarbmbFrSoub8borj4haxeeGa8WuTgQx6F950V2Y2G6wq7ayQJ?=
 =?us-ascii?Q?b9IDJi3eFChdlBHngC4HmmBgV6MKdm9VWFr/FNZLYj2dkD2UL56KzSM0Tds7?=
 =?us-ascii?Q?VsRy7J3g/o5MxZtlXjfSYdcculCFE8VlzfWXns6eFeTC0OwmzPczkHna6TnQ?=
 =?us-ascii?Q?fGsq7VnbtXBRA5ECz/rK3X74vHTCSbNOniOIlsKCl2NBt5QEhAnBjvmLjjNU?=
 =?us-ascii?Q?cjg+aV3RydLXrBDGETS7UpQSgaM996TkO+A5aG23rCPebkXQw0uq8fft0W5n?=
 =?us-ascii?Q?Vl+gtKGJwdHCZUtdt4jHlZhhlktoHWv6YMc4tusvcpP0gwUHcHi4U450ddPU?=
 =?us-ascii?Q?KkkCzRB6WVwNTRsNQvSI1+Hu0vDrx/V1YLPzsxNjqZqiHqAK+mWUFpNcydJn?=
 =?us-ascii?Q?g9bGpvp6sAQnx+ecQrF9LrtPIF67m/VQECx2KYkrTPM3tcRRaHAmy/YtT2hy?=
 =?us-ascii?Q?H9i/uo1yqmZ6SxfKG9FjIciI5amUaXDlZhqgjvt/AXchynxfKKI7AFfJuvsh?=
 =?us-ascii?Q?u7+rhp9ZnTKRv/Mh0nCwZQgqE+crMeoKYoo9xsCPIKk8/DTut1CX+9bOYPiz?=
 =?us-ascii?Q?iH2bA1uq+FH/uk+cjQoyJl/O9aRH2gyXIblStCGlpJZGlnpYl0Ce5KbNHeoA?=
 =?us-ascii?Q?S3NGUKcb+UZPWswYTbHWpPeMfxjBWVYdwga5ng0W1UNISw+6YIK10itO2XS0?=
 =?us-ascii?Q?lETtWSHggv0IBTp/mGOr+aM+ohJt10OvDaHUtODGnrOkNvPWA9g8KT3cLlom?=
 =?us-ascii?Q?W3TYcX3+L4VN8Yg/lWKqUkfUIBjc29MQmrEtTyKGpcxhd2kCDQdzJmPrHZIy?=
 =?us-ascii?Q?CzGpb8XjtKuPFvSBfkt9qNvQkohZgvmpwZ+aKnZkoyCxa0yG03jLg2thHKef?=
 =?us-ascii?Q?vsLIdjiGGRUpgQ7X5SZMQ6m2QDUKjMI7PY1NB+RzUSr8RhphBXeGfF3DuPkF?=
 =?us-ascii?Q?aTHmFjblNdDgBatBWCzDIMdDEhczyZQPaUZ7L2sAeNjhagB3eQBliywjP/Fq?=
 =?us-ascii?Q?fx033wRuSqjOMF7wYqcq1+W2FY+1plAHoQMf0ZSjbAN/v4La4I4dx10+2E5j?=
 =?us-ascii?Q?3GxPjNi0D3A9a5u5whx+3ITYxlVlqu+nCaft/vTEqy63i9GsaHdRCXcw8TIv?=
 =?us-ascii?Q?HnCGNy+RMQy2+devitXG7YSqx09bG1+YTMJtKBexZKAY00vHBiOOWNcIyIzK?=
 =?us-ascii?Q?HdW8rnRi98BY5vS/4XofBS0dDbiJqrmRX1rFOJ8S8/MDj1raD0vFa7p0MO6T?=
 =?us-ascii?Q?a1o1nzwwSGrrFM81qHW5s6ZvZk8S1NChFmshprirXgfaZaCODj1/KBCLVsao?=
 =?us-ascii?Q?iTsI4x6K1txMwvkR3dZWFDsL317pFM2i4XSDtXZbt8yHZvBLxRvUe4l8zC+h?=
 =?us-ascii?Q?aH/A45+YjuJP+J7Q2TYwC9IjIpcvQIQ=3D?=
X-Exchange-RoutingPolicyChecked: Vo//rPwMS/tgNN8kdVoeB4A3qaN0i7Avtaterc9ont8K4AA4t3HpaG1qChCeZTPHYouZcdXOH9kfV48HQe97xsWw8SQwYgKWEWKQT0a//53bWzCb1VnWAPQp69IDyac59UrctgUjHlGXdumjmkaIpVBMlFQuABGt1PG32qQ8Mnr03bM0LhKy7zRWL7FyTJFjeG/SmFS3GI9MqW9QcQ7lwzrErm2mgaXkXipFSjJEVYdubb14ghUHLxtj1jrofKY7l6sXUamnq3PDSw18fRu4l3CIgKBxV74wCHiqcf9gaV5Cl2ZHvcjcs44/99foVAMpiwLM1Iaswbf+X5CBTgrncQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 42be1614-d73b-4059-28f5-08de85353b49
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2026 21:28:00.9679
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3IKz5eFfMstsFf1paEi8sJXO2B+IuxL1PeXWj6brV49AJpDdAgX8IQEHDhBpzIDBrACGsfhsS7s6RYAr+dosWnqaLBJK9VPGYhZsPQHXacA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4987
X-OriginatorOrg: intel.com

On Wed, Mar 11, 2026 at 02:37:46PM -0700, Dan Williams wrote:
> Smita Koralahalli wrote:
> > __cxl_decoder_detach() currently resets decoder programming whenever a
> > region is detached if cxl_config_state is beyond CXL_CONFIG_ACTIVE. For
> > autodiscovered regions, this can incorrectly tear down decoder state
> > that may be relied upon by other consumers or by subsequent ownership
> > decisions.
> > 
> > Skip cxl_region_decode_reset() during detach when CXL_REGION_F_AUTO is
> > set.
> > 
> > Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
> > Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> > Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> > Reviewed-by: Alejandro Lucero <alucerop@amd.com>
> > ---
> >  drivers/cxl/core/region.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> > index ae899f68551f..45ee598daf95 100644
> > --- a/drivers/cxl/core/region.c
> > +++ b/drivers/cxl/core/region.c
> > @@ -2178,7 +2178,9 @@ __cxl_decoder_detach(struct cxl_region *cxlr,
> >  		cxled->part = -1;
> >  
> >  	if (p->state > CXL_CONFIG_ACTIVE) {
> > -		cxl_region_decode_reset(cxlr, p->interleave_ways);
> > +		if (!test_bit(CXL_REGION_F_AUTO, &cxlr->flags))
> > +			cxl_region_decode_reset(cxlr, p->interleave_ways);
> > +
> >  		p->state = CXL_CONFIG_ACTIVE;
> 

Hi Dan,

> tl;dr: I do not think we need this, I do think we need to clarify to
> users what enable/disable and/or hot remove violence is handled and not
> handled by the CXL core.

I'm chiming in here because although this patch is no longer needed for
this series, it has become a dependency for the Type 2 series. So this
follow-up focuses on the hot-remove, endpoint-detach case where
preserving decoders across detach is still needed for later recovery.

Some inline responses to you, and then a diff is appended for a
direction check.

> So this looks deceptively simple, but I think it is incomplete or at
> least adds to the current confusion. A couple points to consider:
> 
> 1/ There is no corresponding clear_bit(CXL_REGION_F_AUTO, ...) anywhere in
> the driver. Yes, admin can still force cxl_region_decode_reset() via
> commit_store() path, but admin can not force
> cxl_region_teardown_targets() in the __cxl_decoder_detach() path. I do
> not like that this causes us to end up with 2 separate considerations
> for when __cxl_decoder_detach() skips cleanup actions
> (cxl_region_teardown_targets() and cxl_region_decode_reset()). See
> below, I think the cxl_region_teardown_targets() check is probably
> bogus.

Rather than repurposing CXL_REGION_F_AUTO, this splits decode-reset policy
from AUTO. A new region-scoped CXL_REGION_F_PRESERVE_DECODE flag is introduced
and cleared on explicit decommit in commit_store(). AUTO remains origin/assembly
state.

This does still leave two cleanup decisions:
1) decode reset (now keyed off PRESERVE_DECODE)
2) target teardown (still using existing AUTO behavior)

No change to cxl_region_teardown_targets() in this step.

> 
> At a minimum I think commit_store() should clear CXL_REGION_F_AUTO on
> decommit such that cleaning up decoders and targets later proceeds as
> expected.

This point is addressed by clearing CXL_REGION_F_PRESERVE_DECODE instead.
Explicit decommit is treated as destructive and disables decode preservation
before unbind/reset.

> 
> 2/ The hard part about CXL region cleanup is that it needs to be prepared
> for:
> 
>  a/ user manually removes the region via sysfs
> 
>  b/ user manually disables cxl_port, cxl_mem, or cxl_acpi causing the
>     endpoint port to be removed
> 
>  c/ user physically removes the memdev causing the endpoint port to be
>     removed (CXL core can not tell the difference with 2b/ it just sees
>     cxl_mem_driver::remove() operation invocation)
> 
>  d/ setup action fails and region setup is unwound

Agreed. This change targets 2b, 2c.

>  
> The cxl_region_decode_reset() is in __cxl_decoder_detach() because of
> 2b/ and 2c/. No other chance to cleanup the decode topology once the
> endpoint decoders are on their way out of the system.

Agreed. The reset remains. Proposed change only makes it conditional on
explicit region policy rather than AUTO.

> 
> In this case though the patch was generated back when we were committed
> to cleaning up failed to assemble regions, a new 2d/ case, right?
> However, in that case the decoder is not leaving the system. The
> questions that arrive from that analysis are:
> 
> * Is this patch still needed now that there is no auto-cleanup?

Not for this Soft Reserved series, but yes for Type2 hotplug.

> 
> * If this patch is still needed is it better to skip
>   cxl_region_decode_reset() based on the 'enum cxl_detach_mode' rather
>   than the CXL_REGION_F_AUTO flag? I.e. skip reset in the 2d/ case, or
>   some other new general flag that says "please preserve hardware
>   configuration".

I looked at using and expanding the cxl_detach_mode enum and rejected as
not the right scope. The current detach mode is attached to an individual
detach operation, whereas preserve vs reset decision applies to the region
decode topology as a whole. If we expand detach mode for this region
wide policy, then may risk inconsistent handling across endpoint of the
same region. Just seemed wrong place. I could be missing another reason
why you looked at it.

> 
> * Should cxl_region_teardown_targets() also be caring about the
>   cxl_detach_mode rather than the auto flag? I actually think the
>   CXL_REGION_F_AUTO check in cxl_region_teardown_targets() is misplaced
>   and it was confusing "teardown targets" with "decode reset".

Agreed that this is a separate question and didn't touch that here.

> 
> All of this wants some documentation to tell users that the rule is
> "Hey, after any endpoint decoder has been seen by the CXL core, if you
> remove that endpoint decoder by removing or disabling any of cxl_acpi,
> cxl_mem, or cxl_port the CXL core *will* violently destroy the decode
> configuration". Then think about whether this needs a way to specify
> "skip decoder teardown" to disambiguate "the decoder is disappearing
> logically, but not physically, keep its configuration". That allows
> turning any manual configuration into an auto-configuration and has an
> explicit rule for all regions rather than the current "auto regions are
> special" policy.
> 
> It is helpful that violence has been the default so far. So it allows to
> introduce a decoder shutdown policy toggle where CXL_REGION_F_AUTO flags
> decoders as "preserve" by default. Region decommit clears that flag,
> and/or userspace can toggle that per endpoint decoder flag to determine
> what happens when decoders leave the system. That probably also wants
> some lockdown interaction such that root can not force unplug memory by
> unbinding a driver.

As a step in the direction you suggest, AND  aiming to address Type2
need, here is what I'd like a direction check on:

Start separating decode-reset policy rom CXL_REGION_F_AUTO:
- keep CXL_REGION_F_AUTO as origin / assembly semantics
- introduce CXL_REGION_F_PRESERVE_DECODE as a region-scoped policy
- initialize that policy from auto-assembly
- clear it on explicit decommit in commit_store()
- use it to gate cxl_region_decode_reset() in __cxl_decoder_detach()

The decode-reset decision is factored through a small helper,
cxl_region_preserve_decode(), so the policy can be extended independent
of the detach mechanics. Maybe overkill in this simple case, but I
wanted to acknowledge the 'policy' direction.

Compiled but not yet tested, pending a direction check:

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 42874948b589..f99e4aca72f0 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -432,6 +432,12 @@ static ssize_t commit_store(struct device *dev, struct device_attribute *attr,
        if (rc)
                return rc;

+       /*
+        * Explicit decommit is destructive. Clear preserve bit before
+        * unbinding so detach paths do not skip decoder reset.
+        */
+       clear_bit(CXL_REGION_F_PRESERVE_DECODE, &cxlr->flags);
+
        /*
         * Unmap the region and depend the reset-pending state to ensure
         * it does not go active again until post reset
@@ -2153,6 +2159,12 @@ static int cxl_region_attach(struct cxl_region *cxlr,
        return 0;
 }

+/* Region-scoped policy for preserving decoder programming across detach */
+static bool cxl_region_preserve_decode(struct cxl_region *cxlr)
+{
+       return test_bit(CXL_REGION_F_PRESERVE_DECODE, &cxlr->flags);
+}
+
 static struct cxl_region *
 __cxl_decoder_detach(struct cxl_region *cxlr,
                     struct cxl_endpoint_decoder *cxled, int pos,
@@ -2185,7 +2197,8 @@ __cxl_decoder_detach(struct cxl_region *cxlr,
                cxled->part = -1;

        if (p->state > CXL_CONFIG_ACTIVE) {
-               cxl_region_decode_reset(cxlr, p->interleave_ways);
+               if (!cxl_region_preserve_decode(cxlr))
+                       cxl_region_decode_reset(cxlr, p->interleave_ways);
                p->state = CXL_CONFIG_ACTIVE;
        }

@@ -3833,6 +3846,7 @@ static int __construct_region(struct cxl_region *cxlr,
        }

        set_bit(CXL_REGION_F_AUTO, &cxlr->flags);
+       set_bit(CXL_REGION_F_PRESERVE_DECODE, &cxlr->flags);
        cxlr->hpa_range = *hpa_range;

        res = kmalloc_obj(*res);
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 9b947286eb9b..e6fbbee37252 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -532,6 +532,16 @@ enum cxl_partition_mode {
  */
 #define CXL_REGION_F_NORMALIZED_ADDRESSING 3

+/*
+ * Indicate that decoder programming should be preserved when endpoint
+ * decoders detach from this region. This allows region decode state to
+ * survive endpoint removal and be recovered by subsequent enumeration.
+ * Automatic assembly may set this flag, and future userspace control
+ * may allow it to be set explicitly. Explicit region decommit should
+ * clear this flag before destructive cleanup.
+ */
+#define CXL_REGION_F_PRESERVE_DECODE 4
+
 /**
  * struct cxl_region - CXL region
  * @dev: This region's device


