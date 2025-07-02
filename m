Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E831B2D3749
	for <nvdimm@lists.linux.dev>; Wed,  2 Jul 2025 16:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751474707; cv=fail; b=py8KbN7YGnyrSqLBaJhem1s8LChy9X/MmvmsyigBM/BVJGhkSuxUpIpKXCIJI3sRs+V11nerKcJYlx+uBrogP6Hl7IxmhYdLYi4gzEVM8MTuDWEo3b91VkPGlRGDICRt7ssilvdAHl5d2m7W5QX860UBJDVqBHIs6Is3arKEYxg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751474707; c=relaxed/simple;
	bh=od5cYdnGrEHT1TpSUSBg7DbIKOO45i+ZnwFAZ/xpW1Q=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bSW5aPtNInxCcdWoq0Qx3+eaSOv8SqzJmLXrVNNvcE5tKmRcXNjs2FyD+aRvbNfsEgJT/5ZaFNfveO+yryESdPsfhXeTgLC7SjQekt6bE+Eleb6ZWJvDWD6aetFfu/zZIDRgdWZ3VE02pMt1ch6AHofAVe8L5LJfMdBOy0zg+7k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VVwAw0uf; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VVwAw0uf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751474706; x=1783010706;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=od5cYdnGrEHT1TpSUSBg7DbIKOO45i+ZnwFAZ/xpW1Q=;
  b=VVwAw0ufg8B99AbVfwebXbdKY5ylOPjCqcrh9TnmoPB4D0qtRXmCo+rY
   T++1rDC6gMmqlSMkduCQwZO/Qx26SMaPVWJc48v2mXy4I7vZ6yjOgo8sd
   KFbPzl58wAbVJWT3Yq07zbTD/PhiSGu5n8xfLMSfmfH3KBc/FvulB+BjW
   uxTsLeZ5AyTHSLUbeaKMYlprVDD600Zyvkj4eQoX7oZUHrTyfhefO4UbS
   iO1Ji/hy18C4tGHxav5ow2/KQx9Aye3FqgwPIGKvMQDs4NOyVBxgW39xT
   0epAH40Gzotnz+8fuGBvpTuyfONybo7UO1OtTVNIkivM8C8HlKMKNFLI6
   g==;
X-CSE-ConnectionGUID: RH+bPgXiSPyH77S1krGJfQ==
X-CSE-MsgGUID: /5grk5olTSyDCkZungr1Ew==
X-IronPort-AV: E=McAfee;i="6800,10657,11482"; a="71354910"
X-IronPort-AV: E=Sophos;i="6.16,281,1744095600"; 
   d="scan'208";a="71354910"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 09:45:06 -0700
X-CSE-ConnectionGUID: ZXajFt9ySxetSI5xtIgN4g==
X-CSE-MsgGUID: 0Z8cLEBLSTK5s2uwTHjV6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,281,1744095600"; 
   d="scan'208";a="153764994"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 09:45:05 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 2 Jul 2025 09:45:04 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 2 Jul 2025 09:45:04 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.59) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 2 Jul 2025 09:45:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F0eOVfbDkpVcb6QqOLShGZgPzZ4xXQ6gmoH9eWFmgLIyCHaDYVsLu7ZytqZpDTqN8YS7VUzWLzqQNUxgRZyRTFa8qeoE5At6hGwzeqPzZ2dvUI0Xs5JwH1dL9rmg9JPRqBKq9Af826fYSOv5e08IDynlUqIz8TYv0edNMVgrSzE1naXx8VeI/vP1tAUtGF06B3QfxmGuG0tyK+FhkvRb0lWFA+55aTH1G9k7z4zl4F6kKKa3Q5vBoFWNjIfQ/nSJ9zh+x8JU57xfwxGqQRNb3HV01h7Qp3UalodO7jHQbaGJp4WXuVX5bUKGs3yuoRy+QMhvUQgmMRXH8V+dliUb+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oc0n1wW5gzg2IbabmoRZr2xIc1s8TmrBJ2ERpMhxg9s=;
 b=GF0ksdJorZQvpHD1rJ9UiVrIlSPQVeoRafjZRLCWn+VFByNOKh4TnEuY/c9wjJ5KO8eVAYNek4kXXoVLmRxEruHp2IImP3+MnzgsnCFlR3/9BjfkuqCZG9WZRlz3VFnocodGsE3QukUnIxei57gNSWkbC5Y7Dq/K9VpjVLpkq/7MRAlr+SF8Qzz7BfHr9INhMQCq55+KTGchk8WwtBmr/fs0HZzjJvSZhDPCmcHxk+e/LuDLCoAnGOfuK0c4EHlTy78tD3vgp5+sxWHxqSqd4H0l/7IphHbrfxPBIr8PWzpP6TM+v7J+U7CCR+tkEpVcO/FS1Ximl8ucVKAG6M6qmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by PH0PR11MB5109.namprd11.prod.outlook.com (2603:10b6:510:3e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.32; Wed, 2 Jul
 2025 16:45:02 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::8254:d7be:8a06:6efb]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::8254:d7be:8a06:6efb%7]) with mapi id 15.20.8769.022; Wed, 2 Jul 2025
 16:45:02 +0000
Date: Wed, 2 Jul 2025 09:44:59 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Yi Zhang <yi.zhang@redhat.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>, Dave Jiang
	<dave.jiang@intel.com>
Subject: Re: [ndctl PATCH V2] Various typos fix in Documention/, cxl/,
 ndctl/, test/, util/ and meson.build
Message-ID: <aGViCzgmAQLaGnLR@aschofie-mobl2.lan>
References: <20250702041837.2677896-1-yi.zhang@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250702041837.2677896-1-yi.zhang@redhat.com>
X-ClientProxiedBy: SJ0PR03CA0285.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::20) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|PH0PR11MB5109:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c307981-8e82-46c0-4eee-08ddb987ca56
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?UKP6Kbz8DPmYOuIozIZb1zM2UlrH/heuQE3S7p/hiZYLlvWyibihgGsfn0Fe?=
 =?us-ascii?Q?Q/+4bIvW5nQhT0OERyKvf30O3FEKlbgImmN/g7ahIgTfxiw6ETtW00uFBpMA?=
 =?us-ascii?Q?JdlayS4n1ohqXB7Bd6iJIq41xM35A/eKBsWOc9IUVmR+Ttg6C6HTWyZLSSg0?=
 =?us-ascii?Q?YsJ+Dd/QqdRvNN+tpEKy+nLCZt5JikVq/D7oy4tI7BmQfOKXUS7IAcUzwLZh?=
 =?us-ascii?Q?WikVtd19NBHrGE6uLhfPx26FovDV5/s91zjm4h3N6tup9rugbP78XM3BTlOy?=
 =?us-ascii?Q?vWZH15wyynGbnvwxnCfta7I7BCtDsn53PHkpFA3fecKvTpHC2iuCNnnaZQDr?=
 =?us-ascii?Q?7sXaphhHNcwRNtGOFzVso7xLKOvtdhJLRA30BMs8IOJFYwBUdeLsTfUFZ4co?=
 =?us-ascii?Q?SdzGnprBqcBLqlabuEy77d7k6oAMm0RlyPJhzJjSZ+LIgbCOJBV+0xJ0mpC/?=
 =?us-ascii?Q?v9E0pi7zf9DlvJTpKo5WMkU9Pc+1bPFBDjAMw8rwxnOvkNN11fLXKS7Ymr42?=
 =?us-ascii?Q?+lWLjRnuyz8lB3KHrytgdRU0QR1eqWHit6ocl/gLMfNAZqPk61rquWv77iYD?=
 =?us-ascii?Q?h2PkOruex3MR3CIF+esEZPmRaYyBpn0iF9kAR/QZNb/R51/OUInP2H1sw8q2?=
 =?us-ascii?Q?psWbxB497OFvQIVGOyggUzS6rifvVtCIDFxf+j7eafaz10UegMiK2IS65sfQ?=
 =?us-ascii?Q?MSyRaDKDIVLkVWOyIsZJHLzl1A95cG7Z5WuOL8Zhq4CEYA0mbQWE0m3KGoWU?=
 =?us-ascii?Q?0pQ8NDWq6J6svgSVS6UQ9SAtWrV0zb1p4GqcJMViNiBzNlN1KaGGXz6biwt9?=
 =?us-ascii?Q?3/4PG7J3LQwU5I5ee9ow7PXr9b/QyjewIH6MIm7ffwDZMW5qeNoRZmp8RwSH?=
 =?us-ascii?Q?tlKsBClQNgfPPbMERD4SocDl124abSEQZqfsvoBAThX0+VrVyhph4lf9R/lZ?=
 =?us-ascii?Q?WqsBB+QqX05fXOu1N58FCHFV05R773/tfun+CxTXZj9tlrbPMCcZ13dZkLX2?=
 =?us-ascii?Q?n4o8GUiEWvSZPiRVzNnyL7vFFMH8TBOiWUexnjxqojk/94TiRFgOaVnclUJy?=
 =?us-ascii?Q?w5b7t31WU+p40l6UNAL0wBPhC2tuhCs3KWSGnphPYq8BVs9vO+cBfT+ftQRf?=
 =?us-ascii?Q?vlQOKpKndiQ8db6EK2hBaA2XydhVsZJGtdkvyMOFWmPsKBvOF3uuPK2tQi2z?=
 =?us-ascii?Q?hrG5j7EueWj5485VVRtlseHiS2BDcHLqojmeY/oYLpYCMV9cFB1U8yzTkDp2?=
 =?us-ascii?Q?XbJiD/JHomhFfPk8bHg9cdZ3FElboRcfz0slXcU5vO0eayIjOaZrnlzmRcxg?=
 =?us-ascii?Q?oxWGqCaxaZud7NKDZCM/LBFuOv9l2XHCr09FxWrDXCHdDRRLw5h5nqKCcUSd?=
 =?us-ascii?Q?eEyLy4LoEvAPp42RbZKgZG+9EjFBm12CzN8SKywGKDl8yZyWAxTGwkYa0HUV?=
 =?us-ascii?Q?plrkg4EmH7Q=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?y2+hSHQe0wuCbCAcoEB6+zgWUzWTIiqAvY2BoqulbZCEPqPLF7nePYQ0wV4o?=
 =?us-ascii?Q?FKYpNbcj7+9jyE70nZXsRaNrzU9WiILcJTJBxjSjPXvQfU9DzDaNzKjVO26x?=
 =?us-ascii?Q?OmMl+kQ71N6yvgR7TihGiU7LBuZGcxXInLvjQFXa2J1zjfWYC4nhyo7+LZel?=
 =?us-ascii?Q?ZEgXojm+VSVqTMtM8iO/beTQ5KckSB4t6cpBX7ZScjLDqjRkZucq+c2ZLhsv?=
 =?us-ascii?Q?jj8eyp+E4gLh0cpI/12Fe+nL9U8Da+yrq8/ZlliO7NQU43pOSjPTF1IZ5jbY?=
 =?us-ascii?Q?t0x4FNWmzHH8vmnBQ2EmgMjqlD/ivZp9pTbcNcTF1z9sQxwyEYN+AWEkrmK2?=
 =?us-ascii?Q?iaqIY/3PUm20IiZw14UULaxoRLBWJVnxY539sbuLgdi8eOTfn/UQ4OP/6m0d?=
 =?us-ascii?Q?eI7VChwwX0NGbN7kThyOXf2pz8GkJITxyA2ofD5tQuHUavnt6gXU3NR81GcX?=
 =?us-ascii?Q?F3E1RAfdjrHIHM8H3eIYYUTFms5/+HL5HxhUlrGeI8T49CtA44YsAcjkV5zV?=
 =?us-ascii?Q?qVbYdiUDGt0mC+Ajeqp6+pRG6G3eJ4I165p1aNmQ1d44z46X/LCZiGubvuRo?=
 =?us-ascii?Q?GlODijGlO/zb42KyP9bp3vndsWeHFgf+UEooUvtJcKV1h5FNUWcgNoelX4HC?=
 =?us-ascii?Q?2gmBVqIYkCZyuko/bO2tdQ7dAJS8ILRas6iIJCZrnmjrpUrowruy07NH/rsE?=
 =?us-ascii?Q?KyNWaxS1O4Uchxee5bZKbyNVznAdXl84pk/QZIMxgj1JXCEZRHMZv611ZTcp?=
 =?us-ascii?Q?nQLgpewjUKx138l4mXka/pFLMhE7Lhl4n9pqXVXo/Mu7GwQyQuYJfHm/+2Od?=
 =?us-ascii?Q?sJuCdUBQ1Ldci0N9sD/a9nOYmfPoh+e3BFb4fB/9BKJlCSTn2hWs2Jdo8gyJ?=
 =?us-ascii?Q?YVRUgi4A9RbOYrAYsQRKlrUPMGnIlT03I+pF0HdE3QLUqsLAw+VY27TX0trL?=
 =?us-ascii?Q?e8rx96kSJOSkBOkyzzZ+0gU6Y+bKHuXR1Fm6Hv/U3LfvPLGG7EUS/XhL5AlU?=
 =?us-ascii?Q?kEqxp4xVZoQoZpt/E55h/ZjuL+w5Xk9jWMDwv+2C98R2lL1yF5V256MjNmgR?=
 =?us-ascii?Q?KYfJK2cLxfOmj7eTcUdve27BHaxxLT1TLFj6oWPY5WImeW/J/D+5ie0VATP4?=
 =?us-ascii?Q?ZxAINfofMocg5ku7INgKVYyJN3NW71ArGgiKAV6RlenP8IGzQGm0ZFJt7asV?=
 =?us-ascii?Q?hiXsvR+no9Y5OISiNzwWrebHwA4sZ3q0ZPO9UMGsEyAqsi5FyzrbXta9Yoy9?=
 =?us-ascii?Q?yhDB9DgFI6TyXo3CRyX/IINTO/CySI7h1fWPP8ktp2WsZozPmypu+DjAoUnm?=
 =?us-ascii?Q?igWggHdhg+4VsAcTZoF75ek00SBLZEO7x9cHNRXZGDFr96GRJNW+wMEKV/FN?=
 =?us-ascii?Q?Yh88JKvgD1W8joX46wodrB/eXAZa8kTa/ixGtHMwQoMceQipajWPblAog7dE?=
 =?us-ascii?Q?89oBX4bkrwiWBsjGxRbfeEQpkOYtB1ZWGq1a0K+5U7w5ExhqHNJbZ1v0bIXh?=
 =?us-ascii?Q?5WK1gPRbytA4SoRviMC43JM2bBNMqG4ET/oSXKOfxNrZg5WUqE48jDcbn/gO?=
 =?us-ascii?Q?VTX4MZKaokxLR5tAI/uana/0hLV3vMxuO1tWXQyFK2e3fmyyoSttp37Yfgjf?=
 =?us-ascii?Q?+A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c307981-8e82-46c0-4eee-08ddb987ca56
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2025 16:45:02.4526
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6R6QYhIuDpw132CMh2MX1hqkyhDvMqX2vM4WtUuhDea3eDCHxH9oq5WdpUu0fDoS8caB+279bdmouDqUfWXbJTO4jYSmfOspEawCI9mHz4I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5109
X-OriginatorOrg: intel.com

On Wed, Jul 02, 2025 at 12:18:37AM -0400, Yi Zhang wrote:
> Most of them caught by https://github.com/codespell-project/codespell
> 
> s/divdes/divides
> s/hiearchy/hierarchy
> s/convereted/converted
> s/namepace namespace/namespace
> s/namepsaces/namespaces
> s/oher/other
> s/identifer/identifier
> s/happend/happened
> s/paritition/partition
> s/thats/that's
> s/santize/sanitize
> s/sucessfully/successfully
> s/suports/supports
> s/namepace/namespace
> s/aare/are
> s/wont/won't
> s/werent/weren't
> s/cant/can't
> s/defintion/definition
> s/secounds/seconds
> s/Sucessfully/Successfully
> s/succeded/succeeded
> s/inital/initial
> s/mangement/management
> s/optionnal/optional
> s/argments/arguments
> s/incremantal/incremental
> s/detachs/detaches
> 
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Yi Zhang <yi.zhang@redhat.com>
> ---
> changes from v1:
> - Add reviewed-by tag
> - Add more details about the typos and how they were caught

Hi Yi Zhang - This update does not address my feedback on v1.
Please check that and ask about what isn't clear.
-- Alison

snip 
