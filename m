Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05A863A544F
	for <nvdimm@lists.linux.dev>; Wed, 13 May 2026 05:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778650509; cv=fail; b=PvCd2Rwch3e/WmNdsLD418DXtrXDayX+1+iyCAqv7yu59sdPRYEoQnnnJ3BMSEhGPwTfT5/X0xMjmPgJQC6F+Ekhdej7rr8NJ5e4pT0F5w66yImkPD4RsqRwyWhNHcYh2Zclbc/O479FBcNs0JMgLkA3sWXhCaxj2cLalYH0Rn8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778650509; c=relaxed/simple;
	bh=R0eE4o8/j7oQEz4/1snZLbrlxWD90/ehzTy6tXvNCg4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=cc4VeNUhyr00JRrX2o3F5OK6THFk+xJIsTDpYfyREgzKPp/ky4HApnVWAbKUGpsEZfPp5zBrU+rxiTroWhcbRmk1WlugWPU7O/7T3sHmrGrN2HKflyGXhPqRwTH63grhiWvEaXHeOuCtfajsRHHtsmx2wKlMb79rxdMTSFYIjVs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kzQA+A5N; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kzQA+A5N"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778650508; x=1810186508;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=R0eE4o8/j7oQEz4/1snZLbrlxWD90/ehzTy6tXvNCg4=;
  b=kzQA+A5NFY7ZdCJS4shL96T2/ZKZAZGS4W96/KKvvP6q57pQPvafyYuR
   +xYe7t1FW874SvOlJLYC1nFXlnb3mLlvLGlGOu7UR/ROq3LgfKvNEDGGa
   JMcMrhfzHC4Fjl2FuB31oC/jcZUneJMTFs7YugYpZFwR8TGlVTmD+x9zh
   5XOBf0rfMVd6qdXXr4W8PMA34+VyHF2u0lhW4gy3ybEdHbFqLSYuytgXB
   Fg1lCwPe8pJxaPi2E2k0T4peVWB3Gxbkj2cUxCIX7d06OFb/P0ADXLVc2
   /RMM40VWR4Sfyodpiuptkp7PMHmPpKMyXek8Kf7eO05BHDWY7oEQkmiKk
   g==;
X-CSE-ConnectionGUID: djdJx5c4SB6sXeGwbxtGTw==
X-CSE-MsgGUID: 7Sd33luVTdGzk74d/0UIbQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11784"; a="83183703"
X-IronPort-AV: E=Sophos;i="6.23,232,1770624000"; 
   d="scan'208";a="83183703"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2026 22:35:07 -0700
X-CSE-ConnectionGUID: cfVRWrmuQHGakh1qlGu1RA==
X-CSE-MsgGUID: pxQOeQMSTw6G3ymNMG0liw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,232,1770624000"; 
   d="scan'208";a="242332884"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2026 22:35:08 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 12 May 2026 22:35:06 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 12 May 2026 22:35:06 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.64) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 12 May 2026 22:35:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HJb6hHrE0ogL76s9Nif3gzamgu7ZaKYinGRGqoU1l36M1O8aLFiSa+Jqc4szOzQ8h7R+ZexsCIwN9K0B8BtBt67Td/rLbAx7hwGQDZSZHAEeBziVdg01Rh7rLaD7T2QhhMqGDDYqGieAi4fGYdBGPxP9jljK9HuB2/L9AzOlCTXDH41t5WW7DYTXLUAWey0FZuXIk/9fNURyUb4PJpQOJQxgedC+AQd9GIAAIyRoVRaP9vHX7Ac+LNS/ikHSDkGTk//vDDAaTEGe95HLgxlHTm2UfGUotNPmowU/a57U7JvuEJOy99bH/ls4nm1gea95Rl9cPS3/5L17xH7ivF7cRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iAb9F6soX+SV9KuzxyAgvR9NM1BOuxaTYYY4symY4XM=;
 b=CROeZ1KutvFmVbn9xv+8Db3x1mdSlIkzyURtc6A+T4OCZf2wzDfsqJnDRVBPq9icYVPEPaEtZzrJ9D+SHdUjoekGcnYvUXcLur3avXafohJwAqceMz9MA1WtbZvet+B9nCDZ+SbOjR1DioVmrg3i4s3qvApDjNanL68H2iBSWZbbUztQ12ul3JRLCO1BEFFdU5ajHl/o1GH9GIN2UmTmPV++DDScWSssBoNxktMKK+ipZDTLXNMcniD8OqXe7yddXl49COp3KLe9wlU53XV78QJT3+vNXB6G5f1r3G8wmnSYkHLcgqU4Rc0o5f4fxZYWWATo0AgGRjBkrwQyhHNgFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by PH0PR11MB5111.namprd11.prod.outlook.com (2603:10b6:510:3c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Wed, 13 May
 2026 05:34:44 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%8]) with mapi id 15.20.9891.021; Wed, 13 May 2026
 05:34:44 +0000
Date: Tue, 12 May 2026 22:34:39 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: John Groves <john@jagalactic.com>
CC: John Groves <John@groves.net>, John Groves <jgroves@fastmail.com>, "Dan
 Williams" <djbw@kernel.org>, John Groves <jgroves@micron.com>, Vishal Verma
	<vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, "Jonathan
 Cameron" <Jonathan.Cameron@huawei.com>, Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>, "venkataravis@micron.com"
	<venkataravis@micron.com>, "dev.srinivasulu@gmail.com"
	<dev.srinivasulu@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>
Subject: Re: [PATCH V5 2/2] Add test/daxctl-famfs.sh to test famfs mode
 transitions:
Message-ID: <agQNb6f_G2lTL-2b@aschofie-mobl2.lan>
References: <0100019ddf064477-8322b695-f2d8-481c-9fcd-8b16fc97ad4d-000000@email.amazonses.com>
 <20260430153413.84181-1-john@jagalactic.com>
 <0100019ddf06ce8f-c323d9cd-333b-4076-9717-7c80dbed7620-000000@email.amazonses.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0100019ddf06ce8f-c323d9cd-333b-4076-9717-7c80dbed7620-000000@email.amazonses.com>
X-ClientProxiedBy: SJ0PR05CA0033.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::8) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|PH0PR11MB5111:EE_
X-MS-Office365-Filtering-Correlation-Id: 478a8c34-743d-4a28-0076-08deb0b1566d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|11063799003|22082099003|18002099003|56012099003|3023799003;
X-Microsoft-Antispam-Message-Info: 2vUzfTvF5b9RMMWpWhyPMkLz5jsO9iVS8hJGTtO620SjaBvEiystR08LHsm6e8Awr+8wcM1z2BmS+iU3txbTdB1xtlhHbTiHbGIhNnizCsFJ8pvqJ16MSjy6olMSoPCGEICxTdcow2O5thgK8JPaqFyHqv2ayZBrbkn+9FVRnTg6ALYrQcFInjqcr9b2s6WZYOoIx2gZVQTrXboZAdVfv6xD9SBVsfrTYb+QEEgdZzImYSUFm7QG8CLi4HF1CXABsGraOIM/cURa03sHRAE1GNxhp82dAJDGkoPhjyh1TWFU04qsxxE/E1J1/TNOcstjBxEKbRn+vStqsnzCZshvucbGjWXlAQ2mFoeQdoAemj+vV1RfGclZ3KHhSU3bPwmCkTsV2YUgzM2BYdFTXRm4d3buSmZxW+GTGKMqrfPhifUEdRiiAqIBDFxrKMlaULx68hkVgANH5dqnUfHbs9QP+i517a0xgVh0mK1tZPRfLfGNnpylMWpqfHBJEpslBXFZqu5QmkxbzUmG87iE9t0v7ySd9rFbl6on1y4Hufy/zhytRdMxHUTesjnOkyIPb4A/3a/a3afbjIZ0b69y/6lZxU4F110jeZPLv28D+B9TAF7Qf+7CE8IRgLpKqTX1+Fn/1zcvoHAKuEMdIQ7MVSImIepImcdVPo1UiYs6563nQ8TsHTVznInBZ7+OxtPjFPom
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(11063799003)(22082099003)(18002099003)(56012099003)(3023799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7knvpZECUU9yBJukul3vzwczF+aKhy3dSZ9lNtT0p2mDaDSumzwTQ8I9Wnr1?=
 =?us-ascii?Q?Mln0rz44upNG5MiUXDZ2Fw3oGevZU67BBPV3RO2Oc73nwmX4I/p/LXx/pqji?=
 =?us-ascii?Q?wEsSbxqbSt78dD6SOER4NNa8WjP86N2imW8NBg2V1onTDtBq7lMLftJWL+A7?=
 =?us-ascii?Q?/uDUEdjvJL7/Fu5cxyHmTPVnJ4J8x+ilFg9lF1eOg8JSz2menlOd4wENoAmR?=
 =?us-ascii?Q?c4BRZX46f2ErynT9/qbixDHpFj2L+chQXJEMz6g9VC2BBlow47j3ZD/qK/Bz?=
 =?us-ascii?Q?Eo86KWZvy97HGhwAoFIkcdHD6Up9yhtcmUajc2tmeDTCoz9YA8nSz3nWRjze?=
 =?us-ascii?Q?/q7thFH/pf1HnJQe1DkN2Ottp4YqjUP+aQ5JhbbwJHrpihaVWubPQzVPJkqS?=
 =?us-ascii?Q?WxTguKM/ha9gg8Nk/r5aZcG1iHUW3MZxGJT2cfDBgp11K21csz40qZA8jk4I?=
 =?us-ascii?Q?HJ2PZu4j4G2oKsk3aLM4g3dr4c3z1sYgAsmUI1N9SuwvHRBJYFpFTSI20yxD?=
 =?us-ascii?Q?ur7DOiekzx4Q8Qb6+UCXGkz3ZAKdzI+O69IreC5HLlJgAdULPbdN9XgiStyy?=
 =?us-ascii?Q?Di2v9hnu8Ipcaji+S3KCJwe4cT5B+/oKeK+1isgGVb9qg9Nno8ZiFhDJNBNa?=
 =?us-ascii?Q?jnzh3ZQAZRj1fh4gCA9pUY2z0uSeQhXa4EkO+rVTymq1S6yY8Q1q/XB+1Nbm?=
 =?us-ascii?Q?y09bXowAlYb+vtv3oqYpOFMPzkEvdEs3UPY2hadWv5ovVb18L7n6z6QacyQ/?=
 =?us-ascii?Q?BUa2yjOjVUv9Pf2m7OswkcNxEV+KZ0xPGBSpNBOYF3M3qUsRE2PLiu3rg3uZ?=
 =?us-ascii?Q?2qrTGUuYYMEhCtB8BOwdDUL7BOLLRSc2xA3W07vSh3Yu9It/sTY4r0uJ7dGA?=
 =?us-ascii?Q?HM4N9KRTsGeQrBg4VRu8wW0V8IhEYi/Q5CBJHv++PPR0dwbmJUYTMpXHZ6fm?=
 =?us-ascii?Q?76E3r5vuY9NR/Qx2SVTi1uNNF+3BXbtRcZ2zfPccrZfjep6yO6LnAA36JABe?=
 =?us-ascii?Q?TKIzPSKOFJCgn3p1XxVXtdTOk2vLNB8KXJQw1B01XWudU9Vs1yWDZklWlPOg?=
 =?us-ascii?Q?f7tKHDtv7rqZmWOFHO/GO+ksmskfVvuO2HUVqGWctFItv0OJzFyIOV4TEjq0?=
 =?us-ascii?Q?Uo8MLBmta5OZkBxfRPzC4iTYcN4VSY1QEa9Y+96xCHlpf73XNoJRpHZx2XUU?=
 =?us-ascii?Q?2TwfqCoOQ6dBz4VVdLycGiTOUMNG1c5lNqqpA3kpLAWsfuc68UUjos4bOoyL?=
 =?us-ascii?Q?a4TowQxSFgEGnGDBCqidzavqAaipABC0FU6HSXuVVzh7xl8dre64t+aHMn/o?=
 =?us-ascii?Q?KGoky63CJcLlJ25eieJr7AmQRWMllqMSy8lclvx2q8RClQXfZf87XOVxMfsF?=
 =?us-ascii?Q?/J1YAPhXuKFJs6DoA/p76wW5ijo/H67DmZYOdHxiKRlP/p6+dsMtvu9ClHvg?=
 =?us-ascii?Q?BQOZCTCARb4IvarrX4k2Q7mzYpGJcJHgIKL7jTDkJYkcaLQVkwP9mpKMJKnp?=
 =?us-ascii?Q?LjHGmdsY2WyMkBKP0kjDw9s2NHitdU2Fgbvk/nMidhPqQrVmZF4rP9VJ/M31?=
 =?us-ascii?Q?xhd12M9pu8vaEm23cMgcDM8gsY+/a24bB8U7WO7eZ0iKLZ7cPAKebdJi6piR?=
 =?us-ascii?Q?CKLjSSSw5mlglfQLdezsN55IQ/P41HJNdI966Sy/N1G0aVa5FPxPfxDYzrZt?=
 =?us-ascii?Q?CxMoF7KU7Au+pigIpPOIEoQLBzAutcUSYfFRtI3pHQdNdAY8rKcBd1GXaaVy?=
 =?us-ascii?Q?nVxNZrN1OvKth+YS5Sim0frO+FuoJpA=3D?=
X-Exchange-RoutingPolicyChecked: Ri7dHq932fC4JxAGsRjNjWZDyF4csewZQpzxXyNl7jUeCQjDGysDtENmfyQoxXxnKbqBbOiNWfUn0eexAahCOBgddflrA+ezEigDfXRthx/kbFRIkVIFmcE38YVeFjx8Mof3FIiSwiL/KcProKUeBeNQbkaCOHAUT6TBoa/qvgd5QYuY/pcXHCBw95KRe+Js7lCiL6zKswYsO/8X7mVjsj9GrRCkbER6GijbjFM9gal0IplQNWRQP7vXt73+nfe/sRwkKJ3IPUKoPHWFY8hn9SM7RPozQ47h92yFWnvv4F4+DIE5dauNwHVo7kJIiMvL4KJVG/G/YTzIbsGFX1jxXw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 478a8c34-743d-4a28-0076-08deb0b1566d
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2026 05:34:44.1408
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TqBn4kL81yfzvFHPJw7G0thgaM5MXX1zXf0SI+LQkxf/LxAJ9BHfSUCHFmg5vWykRPj9P8Tl8Xwx6rdgO9laBhoKRR6cNMKtfq9Kw2dYgfk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5111
X-OriginatorOrg: intel.com

On Thu, Apr 30, 2026 at 03:34:18PM +0000, John Groves wrote:
> From: John Groves <John@Groves.net>

Hi John,

Thanks for the famfs mode-transition test. As promised, I took a look
at how we can make it work as a unit test in an NDCTL test environment.

The main blocker is the device-selection assumption:
    region_id="$("$DAXCTL" list -R |
        jq -r ".[] | select(.path | contains(\"cxl_acpi.0\")) | .id")"

and then the test grabs whatever happens to be the first dax device on
that region. That works in your QEMU setup but not in the ndctl unit-test
model. NDCTL tests here are always tied to one of the emulated backends
(nfit_test or cxl_test) and build their own test device from a known
starting state. They don't scan for "an existing dax device" because there
is no such thing in a fresh `meson test` run. Whatever is there may be
leftover state from something else.

So the test as written will either skip (no dax device found) or get
tangled up with whatever prior test left the system in. Traditionally
DAX has used nfit for its emulated backing, but CXL is a reasonable
choice too. I've prepared both examples and appended to the end of
this message.

test/daxctl-famfs-nfit.sh
    ACPI.NFIT-backed testdev with full devdax/famfs/system-ram coverage

test/daxctl-famfs-cxltest.sh
    cxl_test-backed testdev with devdax/famfs only, plus the 
    system-ram -> famfs rejection via -N

The cxl_test version cannot exercise kmem onlining because the memory
has no real DRAM backing.

My preference is the nfit version since it exercises the full transition
matrix end-to-end, but if FAMFS is primarily a CXL story the cxl_test
version is the equivalent. And of course, there is no lock-down here,
ie. we can start with nfit and then when DCD support comes around and
that is in cxl-test, we can switch completely to CXL or use both nfit
and CXL. But - you do need to pick a lane to start in.

Beyond selecting a backend, both versions were also aligned with the
existing test style:
- Drop per-step narration as set -x logs commands
- Only emit failure path messages
- Replaced printf with echo 
- Suppress reconfigure-device JSON output with >/dev/null.
- Remove restore-to-original-mode cleanup logic; rely on fixture
  teardown instead.
- Use err helpers for traps and cleanup
- Extend ensure_devdax_mode to handle system-ram start state
- Add check_dmesg "$LINENO" at test completion.

Both versions have been tested, but please verify that the exact
coverage and transition matrix still match what you want after my
editing.

Please post the selected version as part of the next revision of
this series

Patches appended below...

-- Alison

======

test/daxctl-famfs-nfit.sh: test famfs mode transitions on nfit_test

Exercise devdax <-> famfs <-> system-ram transitions and JSON mode
reporting on a dax device backed by the emulated ACPI.NFIT bus.

nfit_test was chosen because its pmem ranges have real DRAM backing, so
kmem onlining of the system-ram mode works normally and the full matrix
of transitions can be tested end-to-end.
---
 test/daxctl-famfs-nfit.sh | 215 ++++++++++++++++++++++++++++++++++++++
 test/meson.build          |   4 +-
 2 files changed, 218 insertions(+), 1 deletion(-)
 create mode 100755 test/daxctl-famfs-nfit.sh

diff --git a/test/daxctl-famfs-nfit.sh b/test/daxctl-famfs-nfit.sh
new file mode 100755
index 000000000000..57302795c89f
--- /dev/null
+++ b/test/daxctl-famfs-nfit.sh
@@ -0,0 +1,215 @@
+#!/bin/bash -Ex
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2025 Micron Technology, Inc. All rights reserved.
+#
+# Test daxctl famfs mode transitions and mode detection, targeting a
+# nfit_test-backed dax device.
+#
+# nfit_test-backed dax devices have real DRAM backing, so kmem onlining
+# works normally. This test exercises the full matrix of transitions
+# between devdax, famfs, and system-ram.
+
+rc=77
+. $(dirname $0)/common
+
+trap 'cleanup $LINENO' ERR
+
+testbus=""
+testdev=""
+daxdev=""
+
+cleanup()
+{
+	# Best-effort return to devdax so destroy-namespace can succeed.
+	if [[ -n $daxdev ]]; then
+		"$DAXCTL" reconfigure-device -f -m devdax "$daxdev" 2>/dev/null || true
+	fi
+	[[ -n $testdev ]] && reset_dev
+	err "$1"
+}
+
+check_fsdev_dax()
+{
+	modinfo fsdev_dax &>/dev/null && return 0
+	grep -qF "fsdev_dax" "/lib/modules/$(uname -r)/modules.builtin" 2>/dev/null && return 0
+	do_skip "fsdev_dax module not available"
+}
+
+check_kmem()
+{
+	modinfo kmem &>/dev/null && return 0
+	grep -qF "kmem" "/lib/modules/$(uname -r)/modules.builtin" 2>/dev/null && return 0
+	do_skip "kmem module not available"
+}
+
+find_testdev()
+{
+	testbus="$ACPI_BUS"
+
+	# Ensure the bus has labels, like align.sh / daxctl-devices.sh rely on.
+	"$NDCTL" disable-region -b "$testbus" all
+	"$NDCTL" init-labels -f -b "$testbus" all
+	"$NDCTL" enable-region -b "$testbus" all
+
+	testdev=$("$NDCTL" list -b "$testbus" -Ni | jq -er '.[0].dev | .//""')
+	[[ $testdev ]] || do_skip "no victim device on $testbus"
+}
+
+setup_dev()
+{
+	test -n "$testbus"
+	test -n "$testdev"
+
+	"$NDCTL" destroy-namespace -f -b "$testbus" "$testdev"
+	# x86_64 memory hotplug can require up to a 2GiB-aligned chunk of
+	# memory. Create a 4GiB namespace, so enough space is left after
+	# alignment for kmem + online.
+	testdev=$("$NDCTL" create-namespace -b "$testbus" -m devdax -fe "$testdev" -s 4G | \
+		jq -er '.dev')
+	test -n "$testdev"
+
+	daxdev=$("$NDCTL" list -n "$testdev" -X | jq -er '.[].daxregion.devices[0].chardev')
+	test -n "$daxdev"
+}
+
+reset_dev()
+{
+	"$NDCTL" destroy-namespace -f -b "$testbus" "$testdev"
+}
+
+daxctl_get_mode()
+{
+	"$DAXCTL" list -d "$1" | jq -er '.[].mode'
+}
+
+save_online_policy()
+{
+	saved_policy="$(cat /sys/devices/system/memory/auto_online_blocks)"
+}
+
+restore_online_policy()
+{
+	echo "$saved_policy" > /sys/devices/system/memory/auto_online_blocks
+}
+
+unset_online_policy()
+{
+	echo "offline" > /sys/devices/system/memory/auto_online_blocks
+}
+
+ensure_devdax_mode()
+{
+	local mode
+	mode=$(daxctl_get_mode "$daxdev")
+
+	case "$mode" in
+	devdax)      return 0 ;;
+	famfs)       "$DAXCTL" reconfigure-device -m devdax "$daxdev" >/dev/null ;;
+	system-ram)  "$DAXCTL" reconfigure-device -f -m devdax "$daxdev" >/dev/null ;;
+	*)
+		echo "unexpected starting mode: $mode"
+		return 1
+		;;
+	esac
+
+	[[ $(daxctl_get_mode "$daxdev") == "devdax" ]]
+}
+
+test_famfs_mode_transitions()
+{
+	ensure_devdax_mode
+
+	# devdax -> famfs
+	"$DAXCTL" reconfigure-device -m famfs "$daxdev" >/dev/null
+	[[ $(daxctl_get_mode "$daxdev") == "famfs" ]]
+
+	# famfs -> famfs (re-enable in same mode)
+	"$DAXCTL" reconfigure-device -m famfs "$daxdev" >/dev/null
+	[[ $(daxctl_get_mode "$daxdev") == "famfs" ]]
+
+	# famfs -> devdax
+	"$DAXCTL" reconfigure-device -m devdax "$daxdev" >/dev/null
+	[[ $(daxctl_get_mode "$daxdev") == "devdax" ]]
+
+	# devdax -> devdax (re-enable in same mode)
+	"$DAXCTL" reconfigure-device -m devdax "$daxdev" >/dev/null
+	[[ $(daxctl_get_mode "$daxdev") == "devdax" ]]
+}
+
+test_json_output()
+{
+	ensure_devdax_mode
+	[[ $("$DAXCTL" list -d "$daxdev" | jq -er '.[].mode') == "devdax" ]]
+
+	"$DAXCTL" reconfigure-device -m famfs "$daxdev" >/dev/null
+	[[ $("$DAXCTL" list -d "$daxdev" | jq -er '.[].mode') == "famfs" ]]
+
+	"$DAXCTL" reconfigure-device -m devdax "$daxdev" >/dev/null
+}
+
+test_error_handling()
+{
+	"$DAXCTL" reconfigure-device -m famfs "$daxdev" >/dev/null
+
+	# Invalid mode must be rejected
+	if "$DAXCTL" reconfigure-device -m invalidmode "$daxdev" &>/dev/null; then
+		echo "FAIL: invalid mode should be rejected"
+		return 1
+	fi
+
+	"$DAXCTL" reconfigure-device -m devdax "$daxdev" >/dev/null
+}
+
+# Full system-ram transitions (real backing, so online_pages() works).
+# Turns auto-online off so daxctl drives onlining explicitly.
+test_system_ram_transitions()
+{
+	save_online_policy
+	unset_online_policy
+
+	ensure_devdax_mode
+
+	# devdax -> system-ram (no-online)
+	"$DAXCTL" reconfigure-device -N -m system-ram "$daxdev" >/dev/null
+	[[ $(daxctl_get_mode "$daxdev") == "system-ram" ]]
+
+	# system-ram -> famfs must be rejected
+	if "$DAXCTL" reconfigure-device -m famfs "$daxdev" &>/dev/null; then
+		echo "FAIL: system-ram -> famfs should be rejected"
+		restore_online_policy
+		return 1
+	fi
+
+	# system-ram -> devdax -> famfs
+	"$DAXCTL" reconfigure-device -f -m devdax "$daxdev" >/dev/null
+	[[ $(daxctl_get_mode "$daxdev") == "devdax" ]]
+	"$DAXCTL" reconfigure-device -m famfs "$daxdev" >/dev/null
+	[[ $(daxctl_get_mode "$daxdev") == "famfs" ]]
+
+	# Full online cycle: devdax -> system-ram (with online) -> devdax.
+	"$DAXCTL" reconfigure-device -m devdax "$daxdev" >/dev/null
+	"$DAXCTL" reconfigure-device -m system-ram "$daxdev" >/dev/null
+	[[ $(daxctl_get_mode "$daxdev") == "system-ram" ]]
+	"$DAXCTL" reconfigure-device -f -m devdax "$daxdev" >/dev/null
+	[[ $(daxctl_get_mode "$daxdev") == "devdax" ]]
+
+	restore_online_policy
+}
+
+check_fsdev_dax
+check_kmem
+
+rc=1
+
+find_testdev
+setup_dev
+
+test_famfs_mode_transitions
+test_json_output
+test_error_handling
+test_system_ram_transitions
+
+ensure_devdax_mode
+reset_dev
+
+check_dmesg "$LINENO"
diff --git a/test/meson.build b/test/meson.build
index 56aed9cc3c9d..d765fd99a4b1 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -218,6 +218,7 @@ if get_option('destructive').enabled()
   daxctl_devices = find_program('daxctl-devices.sh')
   daxctl_create = find_program('daxctl-create.sh')
   daxctl_famfs = find_program('daxctl-famfs.sh')
+  daxctl_famfs_nfit = find_program('daxctl-famfs-nfit.sh')
   dm = find_program('dm.sh')
   mmap_test = find_program('mmap.sh')
 
@@ -235,7 +236,8 @@ if get_option('destructive').enabled()
     [ 'device-dax-fio.sh', device_dax_fio, 'dax'   ],
     [ 'daxctl-devices.sh', daxctl_devices, 'dax'   ],
     [ 'daxctl-create.sh',  daxctl_create,  'dax'   ],
-    [ 'daxctl-famfs.sh',   daxctl_famfs,   'dax'   ],
+    [ 'daxctl-famfs.sh',        daxctl_famfs,       'dax' ],
+    [ 'daxctl-famfs-nfit.sh',   daxctl_famfs_nfit,  'dax' ],
     [ 'dm.sh',             dm,		   'dax'   ],
     [ 'mmap.sh',           mmap_test,	   'dax'   ],
   ]
-- 
2.37.3

=========

test/daxctl-famfs-cxltest.sh: test famfs mode transitions on cxl_test

Exercise devdax <-> famfs transitions and JSON mode reporting on a dax
device backed by the emulated cxl_test bus.

cxl_test was chosen as an alternative to nfit_test for callers who want
the famfs unit test to run against a CXL-backed dax device. Note that
cxl_test emulated memory has no real DRAM backing, so this test avoids
code paths that online memory through kmem; only the userspace-side
rejection of system-ram -> famfs is exercised (via -N, which skips
online_pages()).
---
 test/daxctl-famfs-cxltest.sh | 139 +++++++++++++++++++++++++++++++++++
 test/meson.build             |   4 +-
 2 files changed, 142 insertions(+), 1 deletion(-)
 create mode 100755 test/daxctl-famfs-cxltest.sh

diff --git a/test/daxctl-famfs-cxltest.sh b/test/daxctl-famfs-cxltest.sh
new file mode 100755
index 000000000000..aa85946c42ee
--- /dev/null
+++ b/test/daxctl-famfs-cxltest.sh
@@ -0,0 +1,139 @@
+#!/bin/bash -Ex
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2025 Micron Technology, Inc. All rights reserved.
+#
+# Test daxctl famfs mode transitions and mode detection, targeting a
+# cxl_test-backed dax device.
+#
+# NOTE: cxl_test backs its "memory" with a gen_pool region carved from high
+# iomem space above iomem_resource.end. There is no real DRAM behind those
+# pfns. Therefore this test does NOT exercise any code path that calls
+# online_pages() on cxl_test memory. In particular there is no "-m system-ram"
+# that runs without -N, and no explicit 'daxctl online-memory'.
+#
+# The 'system-ram -> famfs rejection' case below uses -N so that add_memory()
+# runs but online_pages() does not. The rejection itself is a userspace-only
+# check in reconfig_mode_famfs() (refuses when daxctl_memory is present), so
+# it does not depend on the memory being onlined and is safe here.
+
+rc=77
+. $(dirname $0)/common
+
+trap 'err $LINENO' ERR
+
+modprobe -r cxl_test
+modprobe cxl_test
+
+rc=1
+
+daxdev=""
+
+check_fsdev_dax()
+{
+	modinfo fsdev_dax &>/dev/null && return 0
+	grep -qF "fsdev_dax" "/lib/modules/$(uname -r)/modules.builtin" 2>/dev/null && return 0
+	do_skip "fsdev_dax module not available"
+}
+
+find_daxdev()
+{
+	region_id="$("$DAXCTL" list -R |
+		jq -r ".[] | select(.path | contains(\"cxl_acpi.0\")) | .id")"
+	[[ $region_id ]] || do_skip "Unable to find a CXL region"
+
+	daxdev=$("$DAXCTL" list -D -r "$region_id" |
+		jq -er '.[0].chardev | .//""')
+	[[ $daxdev ]] || do_skip "Unable to find a DAX device"
+}
+
+daxctl_get_mode()
+{
+	"$DAXCTL" list -d "$1" | jq -er '.[].mode'
+}
+
+ensure_devdax_mode()
+{
+	local mode
+	mode=$(daxctl_get_mode "$daxdev")
+
+	case "$mode" in
+	devdax)      return 0 ;;
+	famfs)       "$DAXCTL" reconfigure-device -m devdax "$daxdev" >/dev/null ;;
+	system-ram)  "$DAXCTL" reconfigure-device -f -m devdax "$daxdev" >/dev/null ;;
+	*)           err "$LINENO" ;;
+	esac
+
+	[[ $(daxctl_get_mode "$daxdev") == "devdax" ]]
+}
+
+test_famfs_mode_transitions()
+{
+	ensure_devdax_mode
+
+	# devdax -> famfs
+	"$DAXCTL" reconfigure-device -m famfs "$daxdev" >/dev/null
+	[[ $(daxctl_get_mode "$daxdev") == "famfs" ]]
+
+	# famfs -> famfs (re-enable in same mode)
+	"$DAXCTL" reconfigure-device -m famfs "$daxdev" >/dev/null
+	[[ $(daxctl_get_mode "$daxdev") == "famfs" ]]
+
+	# famfs -> devdax
+	"$DAXCTL" reconfigure-device -m devdax "$daxdev" >/dev/null
+	[[ $(daxctl_get_mode "$daxdev") == "devdax" ]]
+
+	# devdax -> devdax (re-enable in same mode)
+	"$DAXCTL" reconfigure-device -m devdax "$daxdev" >/dev/null
+	[[ $(daxctl_get_mode "$daxdev") == "devdax" ]]
+}
+
+test_json_output()
+{
+	ensure_devdax_mode
+	[[ $("$DAXCTL" list -d "$daxdev" | jq -er '.[].mode') == "devdax" ]]
+
+	"$DAXCTL" reconfigure-device -m famfs "$daxdev" >/dev/null
+	[[ $("$DAXCTL" list -d "$daxdev" | jq -er '.[].mode') == "famfs" ]]
+
+	"$DAXCTL" reconfigure-device -m devdax "$daxdev" >/dev/null
+}
+
+test_error_handling()
+{
+	"$DAXCTL" reconfigure-device -m famfs "$daxdev" >/dev/null
+
+	# Invalid mode must be rejected
+	if "$DAXCTL" reconfigure-device -m invalidmode "$daxdev" &>/dev/null; then
+		err "$LINENO"
+	fi
+
+	"$DAXCTL" reconfigure-device -m devdax "$daxdev" >/dev/null
+}
+
+test_system_ram_rejects_famfs()
+{
+	ensure_devdax_mode
+
+	# -N: bind kmem without onlining memory
+	"$DAXCTL" reconfigure-device -N -m system-ram "$daxdev" >/dev/null
+	[[ $(daxctl_get_mode "$daxdev") == "system-ram" ]]
+
+	if "$DAXCTL" reconfigure-device -m famfs "$daxdev" &>/dev/null; then
+		err "$LINENO"
+	fi
+
+	"$DAXCTL" reconfigure-device -f -m devdax "$daxdev" >/dev/null
+	[[ $(daxctl_get_mode "$daxdev") == "devdax" ]]
+}
+
+check_fsdev_dax
+find_daxdev
+
+test_famfs_mode_transitions
+test_json_output
+test_error_handling
+test_system_ram_rejects_famfs
+
+check_dmesg "$LINENO"
+
+modprobe -r cxl_test
diff --git a/test/meson.build b/test/meson.build
index d765fd99a4b1..ae5477408617 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -219,6 +219,7 @@ if get_option('destructive').enabled()
   daxctl_create = find_program('daxctl-create.sh')
   daxctl_famfs = find_program('daxctl-famfs.sh')
   daxctl_famfs_nfit = find_program('daxctl-famfs-nfit.sh')
+  daxctl_famfs_cxltest = find_program('daxctl-famfs-cxltest.sh')
   dm = find_program('dm.sh')
   mmap_test = find_program('mmap.sh')
 
@@ -237,7 +238,8 @@ if get_option('destructive').enabled()
     [ 'daxctl-devices.sh', daxctl_devices, 'dax'   ],
     [ 'daxctl-create.sh',  daxctl_create,  'dax'   ],
     [ 'daxctl-famfs.sh',        daxctl_famfs,       'dax' ],
-    [ 'daxctl-famfs-nfit.sh',   daxctl_famfs_nfit,  'dax' ],
+    [ 'daxctl-famfs-nfit.sh',     daxctl_famfs_nfit,     'dax' ],
+    [ 'daxctl-famfs-cxltest.sh',  daxctl_famfs_cxltest,  'dax' ],
     [ 'dm.sh',             dm,		   'dax'   ],
     [ 'mmap.sh',           mmap_test,	   'dax'   ],
   ]
-- 
2.37.3



