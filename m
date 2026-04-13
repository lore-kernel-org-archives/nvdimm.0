Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E955C19DF55
	for <nvdimm@lists.linux.dev>; Mon, 13 Apr 2026 22:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776120130; cv=fail; b=sKsiWD0SvgSl/OQzZl6qm9614DZKsPFow4fOxqDIgIsPbDenflCnWv5WkDWMFeVbOMmv5LXJ7Rj8iATte+lKzdtvXs2a0afMtNwVe466uE5PTSfudyQuZLp5RlHg2TZus00USbDeX1F6quh80kNRPWbAweM/Hhgy1iRf1p3VVKc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776120130; c=relaxed/simple;
	bh=X2Vj1lWBLtR94DK9uPj7iBhkO7fn9+IA9cfET6e4nFM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XF0EVUb+TOamPiNuMfCabc79PckW4on5cp4Oph08rnHihjEDyrnVqjlstv+nJzkZ8PPK1wOuC/5UDBI0+EbgHikRpzChoq2Fq7H9+Zd0Z6vcD+LxLL4qTZIaidHW4GWhnnk67LS/cmAKf4l0EmbTCKLndcyO9SWpEzKYUrlrdVE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Lelaw2S6; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Lelaw2S6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776120128; x=1807656128;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=X2Vj1lWBLtR94DK9uPj7iBhkO7fn9+IA9cfET6e4nFM=;
  b=Lelaw2S6byRrBAYBrrHGe9C7YKFaL/Bw2RIYETK/NoEY+ivrzvHYwsQG
   WjzmdhSkooj3fCAsQwKepjn3tFpmlHNyFkOdpaXj0nuIBZAeigmV/PHnj
   g3ykDgSvg7kForch/OGVLwdZ9kCmayOHGOpwsLfx08pirb4AmvXlAnUYP
   4Z89IZX1JL1qtIRfSSroI3nYjal+61mj287gKEXh/BXy3xtgcKtIv7DDP
   FtIiJlg803yCH+9Ca2ro1LwdnJBj2xEAKQPat8za+25LXrAU55Yvb7wLo
   7qf7mH1n5SBcZjdKHRL1VdUP07aawW++HdU/74tNA+YQWmfw3LxOnMpVT
   Q==;
X-CSE-ConnectionGUID: S3rd0YIYSeO4xs/a2uTUcw==
X-CSE-MsgGUID: f2a6L9o0TfO5Cxh+mLKl1Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11758"; a="80657961"
X-IronPort-AV: E=Sophos;i="6.23,178,1770624000"; 
   d="scan'208";a="80657961"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2026 15:41:58 -0700
X-CSE-ConnectionGUID: C6PfZMzLSfqdQqmtQkxwdw==
X-CSE-MsgGUID: AlkjIz9ISs2iYn/b0q2P7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,178,1770624000"; 
   d="scan'208";a="229040078"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2026 15:41:55 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 13 Apr 2026 15:41:55 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 13 Apr 2026 15:41:55 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.69) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 13 Apr 2026 15:41:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LGpwByPstLFPDj+s3PtSVSgo7n5C/IB9FnaNOgmaTY5Mz9ZXRe6G0jEd2LX3y6O00oaTEqw0vYMbO8EhOaMLcfzqWNXX/AZ+5emVB17ITL51F2PVLHV1Ti2f4VCPB6mWoKDdP34io3y1NKMhf5QHS0LozN1wnx1vYPgMqyDI2U/gJrzxlFTd0cepptgEGimRE1USm6BBgzYH6uVCvYB+i4B3sTyLgR5DFZ/VH0bJz25KeTth9vwsZGfsbY+DP2bPWhAppNz6mQksxQDHuJxoARMnKUxI8dyTvRfU9soisUox/IB0XjfsPwmFTiNiayyqjycDtlJq7qYWwyEnnUGSqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qp1vg88KMXBuJV8NRS7UGVsCcpP1cFftZKfEI1Yy//c=;
 b=Y+UrFPz3kdAl5gc8HF0fX2GvROmehlRRmjUmf0TsvQZI47Pns2AMOL3wJ+YJffKWsRvMfrtbcnjtQQcL2tbJSQZ1sjidwgv/TF2soyS9GCVY/aF9L0qfYbVqtAf5K9VNbiZxUHu5jR1B63qPtVoniGnp+dlwbE4DiuUthUq7eY/u5tm6KDBQ/U28MTLCbjIr8LsO/z95dZ8sKSwgrnvKJDTUD5tEpCOs7DiiGTTK2Ti54GDC6G3nEeeZ56FbtEwoQkDd4EgOBMqKtBJMDYEARGwvV3MRwoZd3vkA3u5d/I9/b4hZ3sj2NdS58XZpbk8KrqFDtSh6HkzfF3DFct1i2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by PH7PR11MB8121.namprd11.prod.outlook.com (2603:10b6:510:234::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Mon, 13 Apr
 2026 22:41:43 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%8]) with mapi id 15.20.9818.017; Mon, 13 Apr 2026
 22:41:42 +0000
Date: Mon, 13 Apr 2026 15:41:36 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: John Groves <john@jagalactic.com>
CC: John Groves <John@groves.net>, Miklos Szeredi <miklos@szeredi.hu>, "Dan
 Williams" <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>,
	"John Groves" <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, Shuah
 Khan <skhan@linuxfoundation.org>, Vishal Verma <vishal.l.verma@intel.com>,
	"Dave Jiang" <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, David
 Hildenbrand <david@kernel.org>, Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>, Amir Goldstein <amir73il@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Stefan Hajnoczi
	<shajnocz@redhat.com>, "Joanne Koong" <joannelkoong@gmail.com>, Josef Bacik
	<josef@toxicpanda.com>, "Bagas Sanjaya" <bagasdotme@gmail.com>, Chen Linxuan
	<chenlinxuan@uniontech.com>, James Morse <james.morse@arm.com>, Fuad Tabba
	<tabba@google.com>, "Sean Christopherson" <seanjc@google.com>, Shivank Garg
	<shivankg@amd.com>, "Ackerley Tng" <ackerleytng@google.com>, Gregory Price
	<gourry@gourry.net>, "Aravind Ramesh" <arramesh@micron.com>, Ajay Joshi
	<ajayjoshi@micron.com>, "venkataravis@micron.com" <venkataravis@micron.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V10 0/8] dax: prepare for famfs
Message-ID: <ad1xIOhiX30NrmbD@aschofie-mobl2.lan>
References: <20260327210311.79099-1-john@jagalactic.com>
 <0100019d311bed04-dbb67b48-c55d-4e6a-962a-a0f8b714f2e7-000000@email.amazonses.com>
 <acrpbBt5UsWEiEbm@aschofie-mobl2.lan>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <acrpbBt5UsWEiEbm@aschofie-mobl2.lan>
X-ClientProxiedBy: BYAPR08CA0016.namprd08.prod.outlook.com
 (2603:10b6:a03:100::29) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|PH7PR11MB8121:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b03c999-0f58-4a3a-2804-08de99add597
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info: 4g6nVTlgyYlE8IAAeIzBfG2Qnb/eTmK6GlcZFjpCNtSevdGy3skxx+j97KQNsjpnimC+5WCbdS3x1haXp3I1zM690uwEuqHVmivigvgb+ry6jeDNd0m2mRJtj5jUTCakU0itLIaMmxZk9x2DKG/B4m9GoP8EQoVQmqbQMXPPOh5vbpd6faQRy1SJWB35ZOfPUxTKxCMYOzWCZfNC0rLrXowKtRton9LWOfe69N1XrF48O7ZwC+YaEQ3dFBw3tWOn4kb7NJK8n9xaklyqp3Is2ZBFKzYfzOdKd5ckONwg3oTxtyhbk06te31g4wm+kPAnBqrn7dlSBbNoRrilzTnchRQcfSBufqBZxUu1CoK/iPp3HXm01G7z7fxKPf1VLvRHgFahNay+nTahd2gy0CxpGHZFT968mdGxwJhC790qiLVLi9uT26VymWtI+YWomrGC616ldM7mFUGcmXVj+uMuQc+FQf6E7q6FMIH+uZ8gM99TL/qj4udDYcmoo6+PzHmf7Kn4l+5WnMVYi/b/3L0INBnErDE0PaHVUqJWKD+xd4YdhkOG3cLlo+Qwh0L2ufpRvovNbToAkFIEs7jF1+0ci+PA9HkFiy29BOv/vfPxBMCbRq0kpoy6yIES13/ODSGEQOzHejj7Quv4F3gf2EcYUZ0i73hcPjUUkTvrxj7r7M76r2Pr3XTgwWr1720CxSKdUZf4BKoONLDMpGG3G0w8YMvRFQKVQBVhxAs673/ikfU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7KpV3tzmTnjnpxJzTPPQD7o2jJVSE4xycxoSmfkYp1dqc3/QJmiM9wBEQwRj?=
 =?us-ascii?Q?/1maFxVAtZaaqLO5JcjdCXVB1ak7WvfLb6qMygmclMk69hqiYSrabJzluxe3?=
 =?us-ascii?Q?RDZ071yS/usRoO7TYlqzrlSek+8TsrMZLt+/NCfWxqXxsORBX8xglz6qVTWR?=
 =?us-ascii?Q?uUk+3URoR9h1iKQP1nYZxaLJAeepWIuuynfw979RN1boH6LOGnMrbuvfKCHi?=
 =?us-ascii?Q?Efm82Y6pqCBqnxHTeIKTVkD755sZkGbbWHqKCRQ3B1wqEo6QF7LfViO6mwl4?=
 =?us-ascii?Q?gGfeG3X345t5G+9CH5uRwebPMroG566xaGyrHvXFPjSxBoCq1EuN6ZnSdRoy?=
 =?us-ascii?Q?UUUPlF7QUSd+KPXLcDmBwU9cJnJ7QBhf4LauAf8A6PgDRjjT1rhGdBZ/xrYV?=
 =?us-ascii?Q?bTCxEqA0a4PDpjyf39S3w0gtE9ICqsAOkV5VRinaBXU5uxCPj9BRfE/jr9SD?=
 =?us-ascii?Q?fGkrM7OTBOjQvxmgdeEj6/kvK5NT4Hmhv4olDfyiwtHDlijgGelaU2ZlxBm3?=
 =?us-ascii?Q?Z3//yYoBcYL0yqpKaQxp1BIsDajWgBiK9rUEta3CzVezLJ+aPMTE51fdNZdC?=
 =?us-ascii?Q?5cvCLjo/CKMAaVuv2B1Qi51K4YF0AdXeD0m7pqYwbKhgU/+pJ3JfsI1s9QWJ?=
 =?us-ascii?Q?pu/h6qSGDD3yY00r5LaDPoi8ztE2lAUhyiUGGl460xQnvDggi/gyFKxNAHGI?=
 =?us-ascii?Q?HZHvoF5+6RQHEAg1vdVRPMN7ZqTII0Oi9QB599blj3BB2w9gH71XoPEqmCV/?=
 =?us-ascii?Q?VdUDG8GmxNEsJf19TSMUxpZcLD4F9/ZCmsoCUG/Lvf5/lp9hIPec2NRgBqcr?=
 =?us-ascii?Q?DDsJbbrhekg/OI5+cUKimIl60o09e9arKAzjLZklAz//+qo1/fJTSkRVR6XP?=
 =?us-ascii?Q?aNGr9PczuPgBbeFb+YLbdG3mWLRWGZTct9gfVyHcAZKtTRHt2jP/iNh19F9b?=
 =?us-ascii?Q?l0zrUm3+xb3DcN8rKRAsWZ3yiABKObZlmXiZbo5JQGdWS5xsBpWqvZ2QRsHm?=
 =?us-ascii?Q?zztHL4VKDIarle9h6GIiNiarvooEpLPlbwOzBEUiFyVyyENANBOtRq0jZpcq?=
 =?us-ascii?Q?lXkXcAGTuF3rbqdTcjPKQw8S1O6gDUYsxBw22MfxZqyEIC3TWaN/BAV3AQTf?=
 =?us-ascii?Q?LJC50j6cSFG2T+ak4niwSfXxK+3j7+aPLvlKpNelGrqbMHgGHn0gPAVpi9SD?=
 =?us-ascii?Q?GyuUKStBJGOuGd6AjLytXJwWs3G3wFYSwM1XcWOK44FXXydBobQZV6dMw6fy?=
 =?us-ascii?Q?9bExVQaU9+OVJMc2TOkLsfN7jTwWsusMl8sY/yZ9uXU3DnlyzYsgDIfryjk2?=
 =?us-ascii?Q?LCWb4gMp7XRCF8hcG/XXNFuy4xrm7N0OjJCwvyUEIvvcA9TKHWO7yuaYRdfx?=
 =?us-ascii?Q?9A/rf87HCghrJxX8kPXb5uO48b/TGCvmMuni073OLTnkHPUzcfifj7rrDXm1?=
 =?us-ascii?Q?lg1SzQoUnZdVzaZvkG4ioohEpFxgo7Jukbl12Dp8RxTpNJPRW4w9/MUwKG0w?=
 =?us-ascii?Q?+zb5kQlA6UjlOhCr0WTekjpZvLwjjSV2VCW4xBKG8+JvwB5TnBxXknifx+EP?=
 =?us-ascii?Q?M9fwGa99BukQ2vCHCekvZU61B+c4bL4HyK7C7rXieMbqzNwEJ9zljJdn9Dxv?=
 =?us-ascii?Q?2qviX0qThvFTiJtUTVQtLe/adyYh7LGKhx57+clbQVa99M7FgUuFMg9l/Ge3?=
 =?us-ascii?Q?JsQFhkl752za2wwoN6ssem/z7xTwX3Q7G6jqJ3t7Pep6gsSYB/pvQHIKI04q?=
 =?us-ascii?Q?zunMUScuty8D37Wd+v/OP0wmnJ+eP7k=3D?=
X-Exchange-RoutingPolicyChecked: ntGKRD0oz7Szc12NNZKCDyXhBaUwyrN8Uy4B3fkjerhTG+CkihlSDPDYke1WjNHOyJWI0an3u1hdKtDp2+sSHg2GbiBA2TgKt88n6fWTwmy1RoRMz0DQiKhFyNbhQ4Au7wd5fqIqTziJ0XlglfT+Nn7ygqM+hCacG+sjD0gaNvRzILb7vNUHq0swi/U7Mdxil9Uq3XIN+3y3B19dhXjDYnW7M+RMCYdJRgALV/Ixznfd3XXCkT1MHVL6mb9tnk6QiKXGqR526G8ti/RO3fFaaTKyeRBydTezoaNpRb5EG6WUHSoI04TWUzR0KSoGu+nJ9huGGM4OD5nalHQNFbPnAg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b03c999-0f58-4a3a-2804-08de99add597
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2026 22:41:42.7885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I8Oh0ZhG2UGue5RIBCKwJknxESu0k6iei1kStvjJ2spHy5RIm0BzdGDyW/lkaP8yEftfwcbjuJE5PNjQLDA/9Qmi9N3jozsEpu/XP5BpgNM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8121
X-OriginatorOrg: intel.com

On Mon, Mar 30, 2026 at 02:21:48PM -0700, Alison Schofield wrote:
> On Fri, Mar 27, 2026 at 09:03:26PM +0000, John Groves wrote:
> > From: John Groves <john@groves.net>
> > 
> > This patch series along with the bundled patches to fuse are available
> > as a git tag at [0].
> > 
> > Dropped the "bundle" thread. If this submission goes smoothly, I'll update
> > the fuse patches to v10 (very little change there as yet).
> > 
> > Changes v9 -> v10
> > - Minor modernizations per comments from (mostly) Jonathan
> > - Minor Kconfig simplification
> > - bus.c:dax_match_type(): don't make fsdev_dax eligible for automatic binding
> >   where devdax would otherwise bind
> > - dax-private.h: add missing kerneldoc comment for field cached_size in
> >   struct dev_dax_range (thanks Dave)
> > - fsdev_write_dax(): s/pmem_addr/addr/ (thanks Dave)
> > - include/linux/dax.h: remove a spuriously-added declaration of inode_dax()
> >   (thanks Jonathan)
> > 
> > Description:
> > 
> > This patch series introduces the required dax support for famfs.
> > Previous versions of the famfs series included both dax and fuse patches.
> > This series separates them into separate patch series' (and the fuse
> > series dependends on this dax series).
> > 
> > The famfs user space code can be found at [1]
> > 
> > Dax Overview:
> > 
> > This series introduces a new "famfs mode" of devdax, whose driver is
> > drivers/dax/fsdev.c. This driver supports dax_iomap_rw() and
> > dax_iomap_fault() calls against a character dax instance. A dax device
> > now can be converted among three modes: 'system-ram', 'devdax' and
> > 'famfs' via daxctl or sysfs (e.g. unbind devdax and bind famfs instead).
> > 
> > In famfs mode, a dax device initializes its pages consistent with the
> > fsdaxmode of pmem. Raw read/write/mmap are not supported in this mode,
> > but famfs is happy in this mode - using dax_iomap_rw() for read/write and
> > dax_iomap_fault() for mmap faults.
> > 
> 
> Here's what I found:
> 
> famfs-v10 on 7.0-rc5 + ndctl v84:
> 	dax suite all pass 13/13, so no regression appears
> 
> famfs-v10 on 7.0-rc5 +
> (ndctl v84 w https://github.com/jagalactic/ndctl/tree/famfs
> top 3 patches + edit daxctl-famfs.sh to use cxl-test:
> 
> 	existing dax suite keeps passing
> 	daxctl-famfs.sh oops w the new test at # Restore original mode"
> 	seems easy to repoduce, maybe cannot go back to system-ram???

My stack trace differed from Ira's.  I hit:

[   88.991865] probe of dax0.0 returned 0 after 2371506 usecs
[   88.996717] page: refcount:0 mapcount:1 mapping:0000000000000000 index:0x0 pfn:0x3ff028000
[   88.997592] BUG: unable to handle page fault for address: ffffc9000f4c8033
[   88.998256] #PF: supervisor read access in kernel mode
[   88.998728] #PF: error_code(0x0000) - not-present page
[   88.999254] PGD 80a067 P4D 80a067 PUD 193e067 PMD 79baf067 PTE 0
[   88.999799] Oops: Oops: 0000 [#1] SMP NOPTI
[   89.000253] CPU: 5 UID: 0 PID: 1476 Comm: daxctl Tainted: G           O        7.0.0-rc5+ #182 PREEMPT(full) 
[   89.001092] Tainted: [O]=OOT_MODULE
[   89.001630] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
[   89.002345] RIP: 0010:is_free_buddy_page+0x39/0x60
[   89.002816] Code: 00 00 00 48 c1 fe 06 eb 0a 48 83 c1 01 48 83 f9 0b 74 30 44 89 c0 48 89 fa d3 e0 83 e8 01 48 98 48 21 f0 48 c1 e0 06 48 29 c2 <80> 7a 33 f0 75 d9 48 8b 42 28 48 39 c8 72 d0 b8 01 00 00 00 e9 ce
[   89.004504] RSP: 0018:ffffc9000f4cf828 EFLAGS: 00010286
[   89.005039] RAX: 0000000000007a80 RBX: ffffc9000f4cf8a0 RCX: 0000000000000009
[   89.005674] RDX: ffffc9000f4c8000 RSI: ffffff7c003d33ea RDI: ffffc9000f4cfa80
[   89.006350] RBP: ffffc9000f4cf838 R08: 0000000000000001 R09: 00000000ffefffff
[   89.007000] R10: ffffc9000f4cfa38 R11: ffff888376ffe000 R12: ffffc9000f4cfa80
[   89.007673] R13: ffffc9000f4cf9a0 R14: 0000000000000006 R15: 0000000000000001
[   89.008395] FS:  00007f3fbca2e7c0(0000) GS:ffff8881fa75f000(0000) knlGS:0000000000000000
[   89.009156] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   89.009715] CR2: ffffc9000f4c8033 CR3: 000000012f638003 CR4: 0000000000370ef0
[   89.010447] Call Trace:
[   89.010767]  <TASK>
[   89.011083]  ? set_ps_flags.constprop.0+0x3c/0x70
[   89.011559]  snapshot_page+0x2ca/0x330
[   89.011974]  __dump_page+0x2e/0x380
[   89.012362]  ? up+0x5a/0x90
[   89.012704]  dump_page+0x16/0x50
[   89.013108]  ? dump_page+0x16/0x50
[   89.013489]  __get_pfnblock_flags_mask+0x6f/0xd0
[   89.013958]  get_pfnblock_migratetype+0xe/0x30
[   89.014412]  __dump_page+0x15b/0x380
[   89.014816]  dump_page+0x16/0x50
[   89.015210]  ? dump_page+0x16/0x50
[   89.015587]  __set_pfnblock_flags_mask.constprop.0+0x6f/0xf0
[   89.016195]  init_pageblock_migratetype+0x39/0x60
[   89.016692]  memmap_init_range+0x165/0x290
[   89.017205]  move_pfn_range_to_zone+0xed/0x200
[   89.017688]  mhp_init_memmap_on_memory+0x23/0xb0
[   89.018223]  memory_subsys_online+0x127/0x1a0
[   89.018693]  device_online+0x4d/0x90
[   89.019149]  state_store+0x96/0xa0
[   89.019552]  dev_attr_store+0x12/0x30
[   89.019975]  sysfs_kf_write+0x48/0x70
[   89.020381]  kernfs_fop_write_iter+0x160/0x210
[   89.020876]  vfs_write+0x261/0x500
[   89.021311]  ksys_write+0x5c/0xf0
[   89.021701]  __x64_sys_write+0x14/0x20
[   89.022180]  x64_sys_call+0x1cb7/0x2010
[   89.022640]  do_syscall_64+0xb1/0x560
[   89.023096]  entry_SYSCALL_64_after_hwframe+0x71/0x79
[   89.023615] RIP: 0033:0x7f3fbc901c37
[   89.024050] Code: 0f 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 48 89 54 24 18 48 89 74 24
[   89.025768] RSP: 002b:00007ffdbdf63c68 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
[   89.026517] RAX: ffffffffffffffda RBX: 00007ffdbdf64228 RCX: 00007f3fbc901c37
[   89.027280] RDX: 000000000000000f RSI: 00007f3fbcb554de RDI: 0000000000000004
[   89.027934] RBP: 00007ffdbdf63ca0 R08: 0000000000000000 R09: 0000000000000073
[   89.028610] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[   89.029337] R13: 00007ffdbdf64260 R14: 0000000000414da0 R15: 00007f3fbcb9b000
[   89.030051]  </TASK>
[   89.030364] Modules linked in: cxl_test(O) cxl_acpi(O) cxl_pmem(O) device_dax(O) fsdev_dax kmem dax_pmem(O) nd_pmem(O) dax_cxl nd_btt(O) nd_e820(O) nfit(O) cxl_mock_mem(O) cxl_mem(O) cxl_port(O) cxl_mock(O) libnvdimm(O) nfit_test_iomap(O) cxl_core(O) fwctl [last unloaded: cxl_pmem(O)]
[   89.032575] CR2: ffffc9000f4c8033
[   89.032960] ---[ end trace 0000000000000000 ]---
[   89.033460] RIP: 0010:is_free_buddy_page+0x39/0x60
[   89.033948] Code: 00 00 00 48 c1 fe 06 eb 0a 48 83 c1 01 48 83 f9 0b 74 30 44 89 c0 48 89 fa d3 e0 83 e8 01 48 98 48 21 f0 48 c1 e0 06 48 29 c2 <80> 7a 33 f0 75 d9 48 8b 42 28 48 39 c8 72 d0 b8 01 00 00 00 e9 ce
[   89.035645] RSP: 0018:ffffc9000f4cf828 EFLAGS: 00010286
[   89.036235] RAX: 0000000000007a80 RBX: ffffc9000f4cf8a0 RCX: 0000000000000009
[   89.036910] RDX: ffffc9000f4c8000 RSI: ffffff7c003d33ea RDI: ffffc9000f4cfa80
[   89.037588] RBP: ffffc9000f4cf838 R08: 0000000000000001 R09: 00000000ffefffff
[   89.038310] R10: ffffc9000f4cfa38 R11: ffff888376ffe000 R12: ffffc9000f4cfa80
[   89.039008] R13: ffffc9000f4cf9a0 R14: 0000000000000006 R15: 0000000000000001
[   89.039710] FS:  00007f3fbca2e7c0(0000) GS:ffff8881fa75f000(0000) knlGS:0000000000000000
[   89.040506] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   89.041129] CR2: ffffc9000f4c8033 CR3: 000000012f638003 CR4: 0000000000370ef0
[   89.041836] note: daxctl[1476] exited with irqs disabled
 


> 
> Let me know if you need more info.
> 
> -- Alison
> 
> 
