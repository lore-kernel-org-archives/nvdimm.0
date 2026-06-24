Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455E1E555
	for <nvdimm@lists.linux.dev>; Wed, 24 Jun 2026 00:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782261585; cv=fail; b=XNX6eLe/Ev1Pke7VChRAi1wEEgvIhng2mymANnRnsUDvmzXrqWn7MDTGLUlib0DBNTCPozSm7gS8jD7CBeOWuMV2xqWhIWnMhQdmrRk7sAz8dAvwjj5cBweyOPLvSucteMK6hUy0vfM49TRlZGDp8gK7D2PVrUmALL4h7GFK6q4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782261585; c=relaxed/simple;
	bh=MQBDasiNurMUtCGvoWL+dPW6L+k08Q8g6shXCxadblA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=s0CAH4UU6YXxSHne5X0bzjlZ/omqW+HwaXLTxRQ2ElpuTZ2vxPK1rMcYMOeGjnz9b2mWwg0sI0WncVDGafqUH2FDz94N0AlNZzTzSlLLsF8AD5Yds6xja/1XNDpJuRCDDhS9sWQXGAptuuHIs/I7LyBmYqr+FDAOdAPoyG62lmk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S/rtLZTI; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S/rtLZTI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782261582; x=1813797582;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=MQBDasiNurMUtCGvoWL+dPW6L+k08Q8g6shXCxadblA=;
  b=S/rtLZTIn+HMHTnW4RfIaliu6pFvZGzTbDckpQLj8Q53ILIfJvPT/VN7
   eIsDrJ657bF6Hu4Rguom9UBtRBL4YpSrjsyLIWQFz11Tm6MrrBEDb6Iti
   Ah9etCKT9Om17Ikbuldegu4qLg/vYtWGnM5rMY9DdwoFqDqlIdHBSNt3g
   9XRSMugV5xi30YfDPyI6KFpx7SLRJNvcFdIUe07kavYMWmhraC3/9M10T
   R4ZEVfcbwW1S3Wsi3cRGXa5ADIM4Yufdro9bBfnTU7yGaSrkkfW1+7C6u
   frWfoN2U4KTo/nzyYiQYpotBdDfDeXaxJqYqahNczWj5TW1wvTIk+s4Sx
   g==;
X-CSE-ConnectionGUID: q+peswpOQOqFZVrT+wEqmw==
X-CSE-MsgGUID: Soyvg9QHRiiLIg6o99QhEA==
X-IronPort-AV: E=McAfee;i="6800,10657,11826"; a="81990517"
X-IronPort-AV: E=Sophos;i="6.24,221,1774335600"; 
   d="scan'208";a="81990517"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2026 17:39:10 -0700
X-CSE-ConnectionGUID: juvCpjVoQeuuGsNQ9PzuUg==
X-CSE-MsgGUID: HFG1qvdASsSEv73NAA/XtQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,221,1774335600"; 
   d="scan'208";a="287798597"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2026 17:38:39 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 23 Jun 2026 17:38:37 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 23 Jun 2026 17:38:37 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.51) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 23 Jun 2026 17:38:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YYTZR1oADWU2n+L7VwXZzxFzcF4NWU1kSICJ0f6eCa96SJQE14R+ZDyPH2sm2iTjpdg9xG48Km/3yqeNfdheLszchyNE21NVxBZ+pHceyKn4qJrRdoW+xSFO3Lg8NCkV8jJCg160zaVHmyE+pB5G9nBf5ciUdZzoLxSnQSthSGqTXizU2WObjLF404OZ2rgIp2d0boIejDr1D+UjLE7WinFhyZ1xT6CVzwthIaYeD54L0PFVyuc8YqgoDevnk9QQPz2PVLDHl4PGLOZHl67iX6eoQVOAkPZ8PV8lu5sc4UOhXH4UqVoCh/qMfocS26S/YyqgUj3v8aQ0VgEhB+lFYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IOxrt2XTJQCP0vIhI1bzvkkQ+BoChxDpqO5RT7uMUQw=;
 b=xhQz84xwa6riABcGqXPZ95GXoOCRuvIDHrFnkt8Q1Gr/objf2zyCHngrrpcdAv3eg8F+I1FuT3wys3qlyfeES96+pHIZMkiCnmmPHlYncCwSAKJTsKjpsIlT/+nsSAOAxMUdDQuhGdjxdFj5GJ6yvmMqTmWPFeWItCWM2bM32k/ojngwBpzFcFG8efiGQECYo4XbB2btnLjK6T1lmNIy62uWISQa/J6MBuFRRx3Ti946mtsgRhHhW9djyKmERqWvasDlG19ug9SGV+54zMZPiwjlrcH7hM4aOng+YQjd0IwK3eXAJQK3/O9Myuyxp7wuqcSecnEJpaYhzb/oLTCsPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by CH3PR11MB7274.namprd11.prod.outlook.com (2603:10b6:610:140::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.20; Wed, 24 Jun
 2026 00:38:33 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%4]) with mapi id 15.21.0139.009; Wed, 24 Jun 2026
 00:38:33 +0000
Date: Tue, 23 Jun 2026 17:38:29 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: <hexlabsecurity@proton.me>
CC: Dave Jiang <dave.jiang@intel.com>, Dan Williams <djbw@kernel.org>, "Ira
 Weiny" <ira.weiny@intel.com>, Vishal Verma <vishal.l.verma@intel.com>,
	<linux-kernel@vger.kernel.org>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH] libnvdimm/labels: Prevent integer overflow in
 __nd_label_validate()
Message-ID: <ajsnBZAnSOEYU6hU@aschofie-mobl2.lan>
References: <20260620-b4-disp-7f43b155-v1-1-0cfd8017f7a0@proton.me>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260620-b4-disp-7f43b155-v1-1-0cfd8017f7a0@proton.me>
X-ClientProxiedBy: SJ0PR13CA0084.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::29) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|CH3PR11MB7274:EE_
X-MS-Office365-Filtering-Correlation-Id: c30620ff-8a5b-48d3-f27b-08ded188eb81
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|11063799006|56012099006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: 5stAsBcOok2VWP/wQTuIJuwFjNUyDR6PfPuRvjzxX5KoHoxzRaAwN/+hBwN73ychNZ8wRbr73E9DLRL/xdK7XiJkBqXDfdj7VUG6cuc2IJj/9XJKXkpOtSbwy/Eru/7dAwFVZEGrcdYVvlb862h9bw1faiSM+EkgkyFol5MsEU/DZAL7sicIN04AGdH9gm+5K8JVn/IUXNkaLwEBTTJkSFCWZKTCplpU4E7xZa9kJcbXJ8wjnpYn8E0ixIKh/t0+UAIwdRfPG38SrmcOa2VRYpq4u15xRj75k3pQcnXiRgn/bT+UGnq3/OHM/5NCLmSa1C4JqeKLK7DI4hberfSEHarWcQ+AwIV1xbXPhRjO9vUalwA1ab8P7LvP9oyGFifXdwl+N4WH+j5QAD2FZMX8gC314sa60Pteh/sd2qUsOrx4GyOnfSNTPP56t3Zq9JJvA9t4cZCmCtMKK4GhkQjN2Lg5QBGUBMw8T8iHXih88S+TU0+G8rybANnKR345daWLB2hGgFoES6+0ZF5SPTOhJ1Vpuu2okexy9K2WC5o5KYQCd9K2DLv6UiwX3MfhlBYdCptkMq6Ezb1TgXOoYHmuNBOvmYdhOWFhNa+KF1LC/Up4dnnvfHnoQ8kl89fQGX0tQx/VTEZSqJ2XbU/zXLTBW9MXdKnT0xYqfGlf4wrtiKo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(11063799006)(56012099006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OTXKD5mvg0Fkz9cPm6NE9AsDKfk+VftfUYalW11ME8bnOBnzIQhRrdqsvcsf?=
 =?us-ascii?Q?TuRxMZt2u2c+OK9pJPuCGYC2AQzhp3seKn8I4Fi60BQcufLgd6/KMJfhUjwf?=
 =?us-ascii?Q?KDf8jYJcg8dFbW+CIUovr2u8cDv0qyh9cm/crNhARLtcuXqqMC7iFyDxIDhf?=
 =?us-ascii?Q?HLda9TSAz4uAH/Ijn1FOigp1sK8dfr23w5ZLFCyzNUj2i1AefJN3+pbOMxnE?=
 =?us-ascii?Q?DY0rdoznlnRsJlfeukOdmKBivRPG2caFk8Tjp9sfqtp+J7FQP7gcnPjNv+wo?=
 =?us-ascii?Q?PvmhO1WARTuXAvl+pEHjidrwhV5aNuSwGK8yptBzKJ3R0SW9KWn2vK/mpF7J?=
 =?us-ascii?Q?fENC3uomHMNUUheJr2YGbersuG69iyFYUgxJqvTpxJA8FsPHSGgKK0Fs3vq4?=
 =?us-ascii?Q?K+HQEMqfQkxVOEBxc04vznNkJNOToBkIq0TpljZcERWXxisDtHqe1if6Hv/S?=
 =?us-ascii?Q?5etUlmht2+M1IinSvlRiN7Cnj0p7a8H5EDVaGd4a82FxFLpnx7tjjSBLgd/k?=
 =?us-ascii?Q?u4294N1m/0cceXlRfjSSQcv8k9wRLNxOxs29pjSEj7GoSwllMPzNEr2QzKPK?=
 =?us-ascii?Q?7JS4tyyIOL7turAJIP2+fkrNlNlSi1rqQeA1NUJZg6oW4seKPqjYODnx9Dmq?=
 =?us-ascii?Q?ek4KuJNOs2gyPUDqnLfGpNqgJWXFtlmaVr/jNcEuf/27TkfOq5h3kIJLUBnH?=
 =?us-ascii?Q?L6GXsa6dYkyZhLcEa3imm4+4f0O1NjPLi4Wnm6KvCuIm9KV5DpKF0/YdEPzj?=
 =?us-ascii?Q?vX/6XCWdwXV80E+L2is9jpkUBfW6379IeJ5kRRq8Il+JatNWAyJ1EHWuX/KN?=
 =?us-ascii?Q?D4YGn/bc8ZOOIBcnJsWuf2I4bCaaJ6u/BzuI7D+wMq6fKvaaffm5v3AIHQ8j?=
 =?us-ascii?Q?hOXZOyzlkzxrMDxDg1+sU9pEUiqdAHaBB27yfmPKWku2AXtVIL4hPnmWSKJf?=
 =?us-ascii?Q?PxFKtz4DlSbtALblBXQ3UUM+7Xf1oTlkB5L0tlHdkQhIptZBZIwxBXCrsY8s?=
 =?us-ascii?Q?W2xCODg19/nZE/SinQAsXh03Apd0nLiYBbrNHi5+Ua50AQzsLYuGzOpm878a?=
 =?us-ascii?Q?j5cTNS0uEfm4Bidy6MVxEBVTWV2pk8GYWrr/VRWRigVCU6zXxa9a+sHEmobu?=
 =?us-ascii?Q?9LVzkLr7P8O2ayhvGC7AP+eAMiudcg2zbf6m1b4gHcWU1QUBlNNGKsi0FPci?=
 =?us-ascii?Q?XPYzS8kvGmN0Y++WsqdHLsrSPT0poD0xizsgriKoi8Qq3bnhrzaB1pDgaktj?=
 =?us-ascii?Q?56uJcSMMrGIEDyAH8k/I73nw7XUC7kbWg8Th1uAJm16/+Fz1GLcPqa7xWBq7?=
 =?us-ascii?Q?zGU/ZxpXFm53/9GYbLpyI+kq8vicM4DfSwDmy7k/6Nb2k6tBQBF76tuaMYoq?=
 =?us-ascii?Q?V4b3wQXY9q0cMi4nnOqYXmaukETVOebjDD/etNHF432gGwpkCTDtTwUINGGf?=
 =?us-ascii?Q?8yBG9cfSFz7XietbGB0Jnkw7XordJoIg+0ehyNWVeAhGZiG9vzRxWT+dmi8x?=
 =?us-ascii?Q?HtbSbFD18GZofKVzC6jX9lL3mJ9YyDPyD/TJNzarX4myxtWO5PCX9c+7++2K?=
 =?us-ascii?Q?CV1g8H7MDiDLvMb0zGvn2YrCzvx8+qNIfDXwusYEngR+5XgY2Y4de+c8c2hO?=
 =?us-ascii?Q?BICOQPWa3DisiN0lzQZnhf75RaeVXv/O99LPW9i8BJKH/BS95w4wHFPeq7EX?=
 =?us-ascii?Q?7TcelP6Q5Ya2FEMR/gu33CJ8HD+TVkdoWjGK4v3iux0bHdw0T1WzAGStVijp?=
 =?us-ascii?Q?7IUVq+48Uj91PKB9/VWPZNnW5eESu2A=3D?=
X-Exchange-RoutingPolicyChecked: Y8Uiz0tRyJdgED1559w+vTvTu89K7zdFn1Cl2ebboplsHHwVFLHXuldvrnKPS4ms9nANtGJhtXyfoc5wnVwpvjvS0HbsGIY/PznOWxndUQSYirR71SVM3W7aagS1u1oPiSkSmqcQ9KmAqH/+QicaIrp7mq2mlcocL8oGLd7Gtj/z4svLkW/C1SBI15iaWhwS3+dU786iA6GCtKMF96sRfL0HGWmW3Sz6AygjmrReNmUAaVRdW4kuhbf9JE7Lr9E2rZZwWyrBaZJwgY6WPWvtIPO3tdtATEhcce/HwY5DxVUkkB06jTxqq0ZcjpvMdJS31hxQdDujBonETNl0xDZ4ug==
X-MS-Exchange-CrossTenant-Network-Message-Id: c30620ff-8a5b-48d3-f27b-08ded188eb81
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2026 00:38:33.2976
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2itRQ++95Wx7mfvwzjPRCp02pBi94kSdachy3FRhiduhRUASzkDmPQFz5Xs44lfX3nKpq3Pxhl9vsLgDNUNussHgcXm5X3XmMvEt1PXsFFQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7274
X-OriginatorOrg: intel.com

On Sat, Jun 20, 2026 at 03:54:39PM -0500, Bryam Vargas via B4 Relay wrote:
> From: Bryam Vargas <hexlabsecurity@proton.me>
> 
> The on-media namespace index field nslot is a u32 read from the DIMM
> label storage area.  __nd_label_validate() bounds it against the config
> area size, but sizeof_namespace_label() returns unsigned, so the product
> nslot * label_size is evaluated in 32-bit and wraps modulo 2^32 before
> the comparison.  A crafted nslot passes the bound and is then used as the
> loop trip count in nd_label_data_init(), whose memset() walks off the end
> of the config_size buffer: an out-of-bounds write.
> 
> The field is not trusted -- it comes from the medium, or from userspace
> via ND_CMD_SET_CONFIG_DATA.  Evaluate the product in 64-bit so the bound
> check is exact; conforming labels are unaffected.

Hi Bryam,

LGTM. The (u64) cast looks like the right minimal fix.

Reviewed-by: Alison Schofield <alison.schofield@intel.com>

wrt the new, or 2nd patch to bound nslot and cap config_size,that
you and David are discussing, when you say folding them into a v2,
that would be 2 separate patches, in a series, not on squashed patch.
Either way, separate or in series is OK by me.

I'd like to see a regression test added to the ndctl test suite.
You can add the case to test/label-compat.sh. It already inits labels
on the nfit_test bus and writes index/label blobs with write-labels,
then enable-region drives the path through __nd_label_validate(), which
is exactly what you're touching. Today it only covers conforming blobs,
so the truncation path has never been exercised. Which explains why
this has sat since 2017.

I think you can scope it as a single negative test case that covers
both patches with an oversize nslot. Don't worry about the config_size
cap. The nfit_test fixes config_size at SZ_128K, so it isn't testable
from userspace.  Ask if you want any support with that.

-- Alison


> 
> Fixes: 564e871aa66f ("libnvdimm, label: add v1.2 nvdimm label definitions")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
> ---
> The check was safe when introduced: 4a826c83db4e ("libnvdimm: namespace
> indices: read and validate") multiplied by sizeof(struct
> nd_namespace_label), a size_t, so the product was 64-bit.  564e871aa66f
> replaced that with sizeof_namespace_label(), which returns unsigned, when
> the label size became a runtime value -- narrowing the product to 32 bits.
> 
> The sibling multiply in sizeof_namespace_index() uses an nslot derived
> from config_size (nvdimm_num_label_slots()), not the on-media field, so it
> cannot overflow and is left unchanged.
> 
> Reproduced with an out-of-tree module that mirrors nd_label_data_init() --
> kvzalloc(config_size), the __nd_label_validate() bound check, and the
> memset loop -- since the defect is the wrapped arithmetic into the memset,
> not the DIMM-probe plumbing:
> 
> Build A (without this patch), nslot = 0x02000000, 128-byte labels:
>     the u32 product wraps to 0, the index is accepted, and the loop's
>     memset() writes past the kvzalloc'd buffer ->
>       right of the config_size region -> panic.
>   Build B (with this patch): the 64-bit product exceeds config_size, the
>     index is rejected, the loop never runs -> clean.
>   Control (legitimate small nslot): writes stay in bounds -> clean.
> 
> BUG: KASAN: slab-out-of-bounds, Write of size 128, 0 bytes to the
> ---
>  drivers/nvdimm/label.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
> index 4218e3ac4a2a..ec12ce72cfe2 100644
> --- a/drivers/nvdimm/label.c
> +++ b/drivers/nvdimm/label.c
> @@ -202,7 +202,7 @@ static int __nd_label_validate(struct nvdimm_drvdata *ndd)
>  		}
>  
>  		nslot = __le32_to_cpu(nsindex[i]->nslot);
> -		if (nslot * sizeof_namespace_label(ndd)
> +		if ((u64)nslot * sizeof_namespace_label(ndd)
>  				+ 2 * sizeof_namespace_index(ndd)
>  				> ndd->nsarea.config_size) {
>  			dev_dbg(dev, "nsindex%d nslot: %u invalid, config_size: %#x\n",
> 
> ---
> base-commit: 8e65320d91cdc3b241d4b94855c88459b91abf66
> change-id: 20260620-b4-disp-7f43b155-92b84c904c08
> 
> Best regards,
> -- 
> Bryam Vargas <hexlabsecurity@proton.me>
> 
> 
> 
