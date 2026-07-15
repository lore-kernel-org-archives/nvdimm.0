Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AAC642BC50
	for <nvdimm@lists.linux.dev>; Wed, 15 Jul 2026 00:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784073748; cv=fail; b=MTaOwrGqSnm61Z1XrfELvKZk7Fiwn77QYnQuRP5p+Kwqf4R0/W9LxzQZ0vukx2dL43KziydZMdqluupdj8smHekQOKXo3RP+bE47zNNzZ+3SvV2MluMv5oYWPPu7mo87lPuJR6YDr7zWZZ3pJEFH4w2SpDbofA+1Gny9q1v2Y24=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784073748; c=relaxed/simple;
	bh=INBjtwYyx9EiSt/ICncjqkUkxp212a6DA3706Yf/ugo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Wqi7qecqWbUmYmQtlQIFi7a4t7+bXguS8yhuTCgTB48BZ3FcuxbXtkQ2UFv9jiMBh7cnIEhjb8zjkkISWjzOrCqw1QKmKK4vFZqALkj/0i0yi5oIUQgz/4r5NJb9kprU27s6jpj6zmclPc9kkzjtvDrKOxTlG/WuGlgz6jmFxKo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dAyThzsH; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dAyThzsH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784073746; x=1815609746;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=INBjtwYyx9EiSt/ICncjqkUkxp212a6DA3706Yf/ugo=;
  b=dAyThzsHEtOOwwEtYafvdCAL54XLXkFpG9JTeCoc/5aaGAOX7wfpMLDr
   7P85T20SscezyXN6Tj8s6oLEd/pUuwN/O0tJSWBd1339E7OeBYOuclJ1d
   CkPcwFK3KKWcBLJkV8Z8T1/qpYIMZ4DyEzv/S42b/fq67s5ZzARKl+SuA
   QqXOLkB1Hmf/hClSOmhD8mM7x+RSNb3491op7CEU/nqC7q/YQT2aoSzvl
   dmWc/RudEBBVCj9CUUvVlfxwYsmLeMbIT/nb2LYYy0AmSxc7rSdI3i5wD
   8hWoTHcBJ6ABOm34X7YlHWQ+GFBf5p7rG0RlcRwoOhwdhIS/OHxVXJw7j
   g==;
X-CSE-ConnectionGUID: N42yV6QcQDylU7mmjONCsw==
X-CSE-MsgGUID: +3hoWXbcS3G7o25n622LsQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="84560176"
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="84560176"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 17:02:26 -0700
X-CSE-ConnectionGUID: VfTVqzM6QAqMHyDCuA2IAg==
X-CSE-MsgGUID: E+oNVOZVSV6N9XsDMKICdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="259836944"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 17:02:26 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 14 Jul 2026 17:02:25 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Tue, 14 Jul 2026 17:02:25 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.59) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 14 Jul 2026 17:02:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=inN2zg4rTXuh85WQVdQmzaHMoBBdRiYlvY/8KSfulwBEVdmQhuZ373Ifn1/1ncOdYTokeAKv03P1WV4+2z10COvtiQohTVbt/JMX5n/PGEiCQMdUd4ZwDNM1Cv7c6Gyq+X+PjUuvXqWSWH8kxv+w9tD+ZGJ3ucBYh1nYix0owLFj0os72CFJP/Q8A4uaJFdZecwBUyS/xVT9ATtAZknM7NnUNIQbidxWm8V06JCBOMmkvnSCOTGusrJN+d7Knpqy8/5o2HzZcNzppbhxQa92DXeTqaWzoj4zU10EVB2lNYEbcQGAJzGASFrdiavUFA52u+0n5RTE1dbGAPsyhNFktA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PSqr8050aEgx0D3OUqOLyxoXeOUAt9t/DUzh6RpNFbE=;
 b=qyfU3wrts3Q5xjxTyOX23+YghETr1CZgvhFWWIBlAYhGwAzsK2iia8XOMEdcXG+AOfhPIPW0R25/xbeChCUFvZ0evJ9pEBXT24vKRiJZvdPhSnI2aZvgJYDQRfiRQXujgbLgZR/q7FH2B3hXNQwXMYHwkFDhHdOi/Ujy19ioIUSBtlWtadAs+ANawJvTa1p8SG/NF38+MjUJr81FwsZ5tDT9dhDDixri0hFQ8iHb0UNtOItL50epTuwcfJP30+nC+H0meRcoYF9trlPMTK8/L7RaNFMQjDBXSt6yPyT1yLxVTEg2gpKXFBPhjE6YUe0EANGn8Jx9/0EY/WUg/MO0bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by BY1PR11MB8056.namprd11.prod.outlook.com (2603:10b6:a03:533::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.10; Wed, 15 Jul
 2026 00:02:22 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%4]) with mapi id 15.21.0223.008; Wed, 15 Jul 2026
 00:02:22 +0000
Date: Tue, 14 Jul 2026 17:02:19 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: <hexlabsecurity@proton.me>
CC: Dave Jiang <dave.jiang@intel.com>, Dan Williams <djbw@kernel.org>, "Vishal
 Verma" <vishal.l.verma@intel.com>, Ira Weiny <iweiny@kernel.org>,
	<nvdimm@lists.linux.dev>, David Laight <david.laight.linux@gmail.com>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 0/2] libnvdimm/labels: two on-media validation fixes
 in __nd_label_validate()
Message-ID: <albOCzbzdYCHK0O6@aschofie-mobl2.lan>
References: <20260624-b4-disp-d8279485-v3-0-cdb6cab28b41@proton.me>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260624-b4-disp-d8279485-v3-0-cdb6cab28b41@proton.me>
X-ClientProxiedBy: SJ0PR03CA0154.namprd03.prod.outlook.com
 (2603:10b6:a03:338::9) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|BY1PR11MB8056:EE_
X-MS-Office365-Filtering-Correlation-Id: 728f7be8-70e3-4d46-397d-08dee204589c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|11063799006|5023799004|3023799007|18002099003|22082099003|56012099006|6133799003;
X-Microsoft-Antispam-Message-Info: 00MjE0uDVKaCmr9cQLEbRBfWhucSycmQHnZUeI4oziZmSG6Z6eWp6gb+OW/TCY1yjNhw3EAPbdHjpjt/NSIuSAHBwcUVWaid+xLbFLhqL1j5P+hFteHZZixMstvNfsiCd/5T70zdrpRWFqKwHFN/QiGyA9DoxW+Sm2nvSWuoO5lCpyW/mWJmILNFbzHGFFhTY/XYfpKAcpNsfSt7rmn6CpDnGvlY0Y4qyZNlyTSODr3vHDvTBtLhdQWtMjNVjJFSOc419oHs56MpTqM8OCrrRJHSLXJzGDseI9K6NocK5NVhHGxamGlOX0ZPa/o1UXh6j2WJBXb3MRFZ4d62r3uieegvE5leW4ockOC7htDzH49iIU6gz2vCq+skPnE6ZQsla6y+WYKtSjysUphOneaPEMeBki4SLVoWOU2sjyAhFe55JfVehS2BPiVEa/w0OOGHURFCehIPMf+vXcHGHEl3kk5hrymkJxSO3bo3s9MCsaftbC7aEngRgheTtHaZWGNiVhVIeBiQkqFwVG9ANDP3dAUPLQtuncCnn6fXa5VezG/KrmLw2UKhMx9VDHoU2CWnOCbBkZWzUaF6dXLK6g9k+1vA6rN49R3StBe5grPAE65XgmHBxLuYBW3oLTE1G9NjjisGST+scfKEThswNYRNyRxNskJ0gmB+9BcktODnXT4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(11063799006)(5023799004)(3023799007)(18002099003)(22082099003)(56012099006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UPHUVe3UjIcfnwtechBITH9d0LwzxYGcIZkvGwDuij3WwbVNi5+bRV6L5IIa?=
 =?us-ascii?Q?1g8B/JuM+vwYEJJOVN8P1c8d5lwQ0K4mRpLFbxArKG+Bx/WOmDt0PxtxInUm?=
 =?us-ascii?Q?6C3TSyJrNcQ6hyA4vmbqNbkdReWWwb7Q0Fbqi/ZgdKlLKrnFmxgOs7UcmYWF?=
 =?us-ascii?Q?qjlEbvNsz+Z4R2ALLRpVy974/0BJlVfdL2R26HDZ1lga6TyjxwIeUWJybL6O?=
 =?us-ascii?Q?Ji83aYiGtEMEm0JkacMyCHT6cRSMMaCwkPj1jjxggSZGInglvEx2mkuCnAkc?=
 =?us-ascii?Q?OgWao/cOnCPU9MYcD601e/VUxgZ4nT2g0sfDv/3nHQlAi+YZzaQP4jxkcJVP?=
 =?us-ascii?Q?mjw19Om0q3h/rzrcfgwjGwH2RWyfw2MUOy/en4NGKiVR8fOohodjkS7Ml2DJ?=
 =?us-ascii?Q?gRDd6hhTaglTA+v2z9bvH4CZ1dO4ak+3ps52Ay7fl2Jzam7koF6vv0e+e4yC?=
 =?us-ascii?Q?JBnX0VVC8pgasLONEffUEPwcmkEO6lOx4Rs3HCyYeFA32ow9u/JcTqVHsyzN?=
 =?us-ascii?Q?bZWRmnICTObf+KTXEr+nKdypgwsLaCjVeDoZSBhTLf3iZH6bZD+2okZujRIg?=
 =?us-ascii?Q?LxIPNeJCXQdvaBqwKnzJPuqSjFY/jsD614sUTSllmXd9cQ7ps1XT/7IKI+74?=
 =?us-ascii?Q?lK2eSAsoK0ABn/PSsBpzqf4RUqUh7xzszEQ05juEePGVNP1bblmIUaDBz+5A?=
 =?us-ascii?Q?nMvzl0tj78AmqAaSaOQ3R4ALriWvzEZ0X6z7PA/eEvS3/cjvW0so91hbz3rq?=
 =?us-ascii?Q?WPsnMSQKkUHAPwDtTIXgSOFoKDcsZVbB1t6sEdkcw2WydQF0w7cqn0Jv7EkR?=
 =?us-ascii?Q?pZDEHojpTCOjzUvBAjA6/c6wE7LbBLYDoSKPyHjNsJ/C4sHsKhIs1crlXvL4?=
 =?us-ascii?Q?xqPpMAPkp0GdvmqqSRLIp5q5eW6/8JgzZ+Aujqz6GyV5lfrnWiiKxoEcQpjx?=
 =?us-ascii?Q?i9O9H7BvI5E78sSt0fXEx5reCqb6dOO/IQemE54m9Z4+IyeMfzaxZYFP/sE+?=
 =?us-ascii?Q?Vh9hCjnfC2pZKqsJPEod1vSFcSGnVKw4pMQvmyGZ5jGxtniW7hWc8dKJ59B2?=
 =?us-ascii?Q?xP+gVVOHsiDalUzSXsHE0lpt9vIZU9T+gES6vn26mLIMK5eERsyVGiP0tsxr?=
 =?us-ascii?Q?dfxux7sTt6RcBot1+FtoSoVftqNBsL2d2iYOSpMYR2TlOG9sTkYdkdCE2ue4?=
 =?us-ascii?Q?xun72xKxDBYCaMrMxL+I6VUWdHbaC7xwVEYGOzZVsUq3qXXW/WJOaAZNT/AI?=
 =?us-ascii?Q?kiMf1ZNC/XcGeH72q3K2JbDoAXnQz/KsEpcFi/rP4fNW1I6bTKAn4tiyqOAR?=
 =?us-ascii?Q?VHo76tdzHAj4pE7abiXlXbzFnJOYmP+pBgPEiM1RFpUbwvRDimXLU1WqCdEB?=
 =?us-ascii?Q?i0nMiOYL+r0RQKw9A5xqrxj/xm3/kRDZviRwcrQb2BY0sQwLDJDBer3Q8EFp?=
 =?us-ascii?Q?pUMo6K06J6GlkprEQb71e3MSJaGbYTfzjzjCQGmIQQ2X7DFSLa/dZ3TWdZEX?=
 =?us-ascii?Q?QhUgwWdld59hasBkLXSMhoORFvq+megM/ZwpLCE0WVR774UJ51IOa+RvVM78?=
 =?us-ascii?Q?MlkrULiVqTru1+RYJIah+Iw2URREx+Q3hpO0mQTtUg03wmadilB6K+2NbdwU?=
 =?us-ascii?Q?Mjqt2UGow3ZQwP3d9ofPAM+b2RhsWoNTBOR66kjZCtumhehhlhuL2h1/dxIA?=
 =?us-ascii?Q?Bac9HV6ez7KTqEe2jBQJeox+9O3gVYfqB9gi3wx9H99qS4lR7JaKyT3T61Vl?=
 =?us-ascii?Q?kbj0adn+nn2tKG/Ow6jCiIElEWSFo7g=3D?=
X-Exchange-RoutingPolicyChecked: MEzaYX7TDn/AbHFR2mJ6ukvjlkP1yEbakiNYvfPcbL1ZJBuhes57AR4uAt87UmZ5KD1/fnWI9LQmw2KTfuh9l32EjF6Av6LAH97KjH20GnY/MhObm4aT4rZ52W99KMvMD4j0KniaAi/GxkthkEcj2KMXQd+MatwRmBIBWBwsxDccG83UirBEHh4B1B3c68u9o1VmHq7IoLu5HTQ3TtBghM4EkvmHy7nkav9RJ8l1dGXfs44oQGafg2tvotLQPIUlvgm0QTtG6inBzhGp4fOsxkWxCy7P8HC3tR+q+5OIN+kJI9voToI6TsQGovU/ehs41sKrR/OX79OCsba3yctbMA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 728f7be8-70e3-4d46-397d-08dee204589c
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2026 00:02:22.8646
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8j7vJa7xqWrym8pNEeTQOnY1a49P3/9b69876eWJf6bVHmamfNnREEE9gpwgsNxQYrPbnF1Pdmuawr7sFmB92oAe3JjB3j+Ao2XdMVPAbxY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8056
X-OriginatorOrg: intel.com

On Wed, Jun 24, 2026 at 01:03:44AM -0500, Bryam Vargas via B4 Relay wrote:
> __nd_label_validate() reads several index fields straight from the label
> storage medium.  This series fixes two of them.
> 
> Patch 1 (the original report): the bound multiplies the on-media nslot by the
> label size in 32 bits, which wraps, so a crafted nslot passes the config_size
> check and then drives an out-of-bounds memset in nd_label_data_init().
> Evaluate the product in 64 bits.  Tagged for stable.
> 
> Patch 2: the v1.2 label size is computed as 1 << (7 + labelsize), where
> labelsize is a u8 from the medium; a value of 24 or more makes the shift
> undefined.  Reject labelsize > 1 before the shift.
> 
> v3: Drop the "cap nslot at 64K" patch from v2.  A closer reading -- and the
>     Sashiko AI review -- showed it was wrong on both counts: the allocation in
>     nd_label_data_init() is kvzalloc(config_size), not nslot-derived, so the
>     cap shrinks nothing; and the kernel itself writes nslot =
>     nvdimm_num_label_slots() on init, which exceeds 64K once config_size is
>     above ~8.4MB, so the cap would reject a freshly-formatted large device on
>     the next probe -- a self-brick.  Patch 1's exact 64-bit bound already
>     closes the overflow.  Replaced it with the labelsize-shift fix the same
>     review surfaced.
>     v2: https://lore.kernel.org/all/20260623-b4-disp-1f2c537a-v2-0-59af73f1f090@proton.me/
>     v1: https://lore.kernel.org/all/20260620-b4-disp-7f43b155-v1-1-0cfd8017f7a0@proton.me/
> 
> Verified -m64 and -m32: patch 1's 64-bit bound agrees with an exact
> divide-based check, and an out-of-tree module mirroring nd_label_data_init()
> reproduces the KASAN slab-out-of-bounds write unpatched and is clean when
> patched.
> A boundary truth table confirms the self-brick the v2 cap would have caused
> (kernel nslot > 64K for config_size > ~8.4MB) and that rejecting labelsize > 1
> removes the undefined shift while keeping the two valid sizes.  Harness
> available on request.
> 
> A negative ndctl test (test/label-compat.sh) will follow separately, per
> Alison's suggestion.  With the nslot cap dropped it now covers two vectors
> rather than one: an oversize nslot for patch 1 and an oversize labelsize for
> patch 2.
> 
> Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>

Applied to libnvdimm-for-next:
https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git/

