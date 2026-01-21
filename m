Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EEF1298CDE
	for <nvdimm@lists.linux.dev>; Wed, 21 Jan 2026 00:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768955723; cv=fail; b=IEr7m1laUV9Muk54kOcXaJVOpL2v4oeX2wF8yJxKeZGYSjA9zwEgfxWRYf86KD9KQWm2IAmr9PMQOUP+mFKhJjs1oXNRT8mBm870U7vjWQ3JaPpQnJngyJSIhTWR4/TsWYUc4Ah4mtp46NJ2Uail+azLeJNU8luxaHieYw+bJ5k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768955723; c=relaxed/simple;
	bh=jLjcPdWXvtlNQL7zfobK4eJRP+farieCE6gNK2mSgnM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Un+l9lPdTEnKcMWfkNmnhxEd21g6WhIqi7zHnYp+W3oBNkBURfsnfRbA1BT3hdFxTSm7diuDffEkkxLbXZXP23iRyIDqvL9F9nEYwK6lGcicmIxgWdJ/xvBIhYMIfGfVfo7ujL8Cu6qnYdicC19hVFo8MQ/mKwdwwaonrwdR9Rw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ePByy0S2; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ePByy0S2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768955721; x=1800491721;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=jLjcPdWXvtlNQL7zfobK4eJRP+farieCE6gNK2mSgnM=;
  b=ePByy0S2G+uz3YGDa+jkDLwb7nm7w1JiTlV20WldmBdbn0MkWtyAlJJB
   X7/xgPYWzhfr6YvuAY3e4lw65dqT+W/U72+d6ANWuQDaOBdZQ2tk8KFU/
   d/OQ9cXcOaGfYBi1IQcQ1KH7OPuCby4bxfej/6kzur9YVx3Z3E11TbFTE
   iwbLDrSI2Aab6fvlJ6UgOwUoA56ZSJ43jt+nMZ79+G5OshqWKjRgVVx3U
   z+egotOTsnwrMxR3SUKu4j4fNoP2kyyY7969+MCBYZxI0FMxC6XwFEER0
   BoBToeLkGiGUBVieVFg7yCMTaI5VRS52DDHloDHVrh62ERqEIJPgK89Sr
   Q==;
X-CSE-ConnectionGUID: GSWZYqiES5+SF49p8o854g==
X-CSE-MsgGUID: 6fRl7pIoRJuAQ4g4NSCY2Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11677"; a="87755477"
X-IronPort-AV: E=Sophos;i="6.21,242,1763452800"; 
   d="scan'208";a="87755477"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 16:35:21 -0800
X-CSE-ConnectionGUID: A/Iq7rs1QPeq8bFv0R1VGw==
X-CSE-MsgGUID: SowD3uoITGGts/Xv9ixlGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,242,1763452800"; 
   d="scan'208";a="206188461"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 16:35:20 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 20 Jan 2026 16:35:19 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 20 Jan 2026 16:35:19 -0800
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.67) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 20 Jan 2026 16:35:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BJ5CpER8aLGRKh8j3gUKaLKGdULqbLL7flGHiR1w9EPylujyCqmnM5WC8XRI54q4D3n50gHgqLkTieBs+fjLkKZc7njt6Tv85+NWBHPjP13qW/s8UJ24H6wSixn19NwYX1nExC8IULnG4OIidN14NkHYV8pk8edp14RnGIqXuEYcnh7msKH1JOUfq9OqbY26o5CnXw/+QGVQ8gkZz8ca9HgEVhp6a7ZOuG5WDUCk4SLB5cZ2fHAdJNlGa6kOWdnLrEuVz9Z0kKFPO+rnIjAbWuPKmjhI8yhoIIa+h2SUyFtGCeIbISLLDF2yhmn79XcXUrD+D+7SZuanY2i0J+XLGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z5jNCdIclB8ZtvOa9rG0ScVB/JqE9Hr88+Jcn1FZL9A=;
 b=hPg3ovZAcLTQkYKN/l5Jk4pT7tpQRs8Avglr43qkDFz+1uEMegv76r3CBMxnC2K/zrCzJ5m7SHWGooHuUUVcUOJFFj+bOG02s4rW67q0MydMtLVmZGMh1CUq2ifhAlxjUqLkI+b4HaGoIYPrIR6xY982ZwkuOwtFderf56MOLY94DqJLbb49z4IwwheGoFwSqecAqAGwdXfSMu+oAxSpMtBxZKx2kdQjgrSaOTnL02VRrNW8iVs7Y1s4SUhk49T4QSL7X7qnyVsbFX9yFr40FLCoN/UnfkXFhtx1LLuNXW9K35GmsawglJozdCrU5HjGJNYg/S1eCtNZ8YcxyfG9+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA4PR11MB9131.namprd11.prod.outlook.com (2603:10b6:208:55c::11)
 by MW4PR11MB6957.namprd11.prod.outlook.com (2603:10b6:303:22a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 00:35:06 +0000
Received: from IA4PR11MB9131.namprd11.prod.outlook.com
 ([fe80::7187:92a3:991:56e2]) by IA4PR11MB9131.namprd11.prod.outlook.com
 ([fe80::7187:92a3:991:56e2%5]) with mapi id 15.20.9520.011; Wed, 21 Jan 2026
 00:35:06 +0000
Date: Tue, 20 Jan 2026 18:38:17 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Neeraj Kumar <s.neeraj@samsung.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<gost.dev@samsung.com>
CC: <a.manzanares@samsung.com>, <vishak.g@samsung.com>,
	<neeraj.kernel@gmail.com>, Neeraj Kumar <s.neeraj@samsung.com>
Subject: Re: [PATCH V5 04/17] nvdimm/label: Include region label in slot
 validation
Message-ID: <69701ff9472f3_1a50d4100e2@iweiny-mobl.notmuch>
References: <20260109124437.4025893-1-s.neeraj@samsung.com>
 <CGME20260109124512epcas5p4a6d8c2b9c6cf7cf794d1a477eaee7865@epcas5p4.samsung.com>
 <20260109124437.4025893-5-s.neeraj@samsung.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260109124437.4025893-5-s.neeraj@samsung.com>
X-ClientProxiedBy: SJ0PR13CA0180.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::35) To IA4PR11MB9131.namprd11.prod.outlook.com
 (2603:10b6:208:55c::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA4PR11MB9131:EE_|MW4PR11MB6957:EE_
X-MS-Office365-Filtering-Correlation-Id: e1333627-5969-420d-c925-08de5884ecb6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?80ZSrQeGeCtcyIEW6EN26GQK4m2TJWnV8OoKfXqClhExELqvjBVkHrrgcSbH?=
 =?us-ascii?Q?HSImVN8nixv51VuRyjeW0CgNwbeVHOxTE9HwgFAWsVZkJ/rZ7jDfbWUC1RTa?=
 =?us-ascii?Q?Yfd0S2KuZaLe63y4GgT65s+/v5OI72QGSA6s4alhWPLUq/NEvgK376mp2gqM?=
 =?us-ascii?Q?epypfnM2zLiz81ODiiVciWySpwWz4JEd/YtAcfOwru928fUQL+lDCCuarxrR?=
 =?us-ascii?Q?fEzZ6keTvoQ0w8uDw42JodaiXgbIZdcUdpyFfE3SbXE3dFlKb8rw7US0/+0m?=
 =?us-ascii?Q?brDXpnvhZtZcZgE863W9K6Lkdii+CqLtOKD01CC1c2NNb802x1lssUhjcsoG?=
 =?us-ascii?Q?ptvD77WOQH3fXeMwjQc6jBB0DCQtRpzDceJCXqt6Je/EZZETVVlFvd+lRW52?=
 =?us-ascii?Q?tUi0wvjvcsoU/v/M9pZjt4cpE2p0r4kKMoevuKE94rVzg6AWKN2l940//cSQ?=
 =?us-ascii?Q?x4YgXFzMObDGn0jBoUEsTHma9X65HX8FeN4nBSsnm/oaWYZtPJZVIYehCTzZ?=
 =?us-ascii?Q?dcITXcU2GlFPzU40AMDOlUD/7/GumGTNuYsUjXdu6ScaRzAqLiCRnWO5OP7R?=
 =?us-ascii?Q?I9c+pJomwB1aqKF5JwiNtQkA1jsb4BUO8+Wyp13lYSgKN4qUD/yK5REHbkPj?=
 =?us-ascii?Q?26vs8e9OpFObhSUiOUwVYqHEudIMo8bVz2uK+5Yq8ZOiLIqQJJ8RPEhtwntR?=
 =?us-ascii?Q?l/PhWDJlVePnKD9l6rqmuaUoCKEHovoswjuh8Ky8FfCGg5f5hDA2LastUjia?=
 =?us-ascii?Q?7QsNbkSD3pIREQktzBwqVnR5uYidbtU5nbDQyslOasjRHpJzkrtTL/5hUWhr?=
 =?us-ascii?Q?e1wcnem6RYX/2aSklrsbU9CNx/fBjj41PBjCdeCWbxeMhxFXicZncr+waU0F?=
 =?us-ascii?Q?6m4fQQj4pW+tBBedAlAkiOewDZZnNxNRVfoq/OhMzs8LfkQkZIUhGu2Sz4ya?=
 =?us-ascii?Q?8AoLIuoL/d1jdJJxjSNEZjfkcJPHTJmr1t0uYbvhpDc4Ys8Xf6quIJRyE9vc?=
 =?us-ascii?Q?FMZvH0mi2DguAPnzux8+v3nOfREfMfOW+CaQ0DrSMCeQ2sLdc5nNxbkVNkMo?=
 =?us-ascii?Q?LffUFa4UyQOM27ujsmH1Tv3l//8cFM80XndIkoSR8Uei07FIr2w5z4/ox80e?=
 =?us-ascii?Q?Qe0tvuYBDfOzX+FayODp82m4iZdCMhqSLCdt5YNhj3FKfbekybI6cJAgmJf8?=
 =?us-ascii?Q?nt1iZ+QYRpWI2J57RW7lDfWJRAs0uD7SjHpqg6hzrmfAsBsQVcooCvrG98OQ?=
 =?us-ascii?Q?Lfs6mh9ryx9L89d5l1+FGslR4sM1SL+nd1BMlbI94+4rmjxCW6wdWcMCBtOE?=
 =?us-ascii?Q?h/rqM5WI3rx9qERcVep0rHwz0cuD+ws/mrlB6FW9USh8XOzBsyf5sEdbVCNT?=
 =?us-ascii?Q?V/AamA5PECdUlen+aC5qDtZUCF8HebFeHyhkpzF1G/Q3te5lEC9n3xmNKfFo?=
 =?us-ascii?Q?jZXIk1q7PKyL8frZQox+X2pFkGa48FrgpEzND9S8gabLuB1lpb03Z2e1hFWL?=
 =?us-ascii?Q?CSIQv7kZEjH5qTqoDEfRlTBYSx8q15ETLB/UCr7IK+u0n8gehT6X5lezquau?=
 =?us-ascii?Q?Y12zF06gUfy7yYOxcaM=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR11MB9131.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xLR57wR3tPYXlE+UNuYIz87enILRPxgxpzRRP57LwiCQyfTnMm+cVHy4qGnH?=
 =?us-ascii?Q?btF/n8fnzUp/4QTC48sbsMOzs4Ft9w/cCGylAo3Tg/DmlXWq7i+01LpP9zGf?=
 =?us-ascii?Q?0weSTjluLiVt9rC2QlZoMp5ZL6kbi7CR0TVDYj1RBYdAcwQBmaW5naArzFWU?=
 =?us-ascii?Q?lDe8vSEqf7zA+yA4NUuJR0GeTvKPGxOo8yG+YhO4sZvIP2xhhwsmmg487wOC?=
 =?us-ascii?Q?k4RpNquTLcA+aTf3Y85YpkOcM94fg/D72b9q+n7XVVVsZZXKLuyntNNC8Pns?=
 =?us-ascii?Q?if2mxQzIVZRUJYp6/RIBmHkoD2t86LZcd9S3IKn9oJVY1CpQRGVTPkIabE5k?=
 =?us-ascii?Q?XCaq5PiDhsQgxd0i8XR+GjW1jxzkSBzswbvhzngeBKWfudgfK6F9XchAAndn?=
 =?us-ascii?Q?RpRi+XtKd08IaBiJDIo1DgTKMsM4MBicXC4UZbLQCn0G6ObAp+ofF4NB/umf?=
 =?us-ascii?Q?bJsKfUzZRhV1ipdU1eLx/hQJEG2ofCeG4zq/kuwhRTz5IBnIHT7DMTydNK4G?=
 =?us-ascii?Q?IzBKLil4j4H3W6PROdYS9PcvjQhACGPZMXIkyLPDNkrD/q9yLuEQADq/h0pi?=
 =?us-ascii?Q?IyBQuT+3bgfeH9qzSoxLsC2PThGTOu5jqPswqWvVnPcIsqTTKlQlsKNRgbQX?=
 =?us-ascii?Q?ab2GaPWHdd5BNc485FGAzGRVYwTBVuJD0pkZZDiszziWI6+TVI/+4fAboYmR?=
 =?us-ascii?Q?EnUB8pIyGQCQsBDkvb0cJ/Uiw27AQPV7Y0qpEw/sKovi9J28g9UB/TwO3bfb?=
 =?us-ascii?Q?Ta5RzBAYjj21f3Db8a9Q0SKkVZPpUv347iKHuA+Ceywqq+PpLsq3TU7BoPU2?=
 =?us-ascii?Q?0c5IDwQ6IbO1vW8CEmR6cRbONRpl9WfLfxveLUEeE/04po8cKm/sg2mXJB/b?=
 =?us-ascii?Q?f3kPWIPLFW5B2+aqQDUOK2hmDDPLRnlleJPH2/zbK5KWZmTvNnX8B/fqY1dB?=
 =?us-ascii?Q?OpFO9eFbWjB/68vBMID+MesTXB6KcI+lKty0LNsZ4Qqgip7pEc1tB6lsV6ja?=
 =?us-ascii?Q?UmyUHe8G6qhKJ5aD11Tv1GlIdgPc14Tige3OqjtgRmeYNDbqigHjv61nhNck?=
 =?us-ascii?Q?QAGCDHVeSY39TaAczby97KYwIdS1l+mOCy7yijaYreMVzyKa+b0D6RxXLkjr?=
 =?us-ascii?Q?p08O4Vq5plm6POoq06GcuBlzeQ+s48WOxXLUXkTSVgsYcd74t/GyntHyIlt3?=
 =?us-ascii?Q?Vhv5BChXv6amt0GnKQSRQB8KCX8mX8M2Jv0hWggPn64XGX+XaH/AOjvLMsIb?=
 =?us-ascii?Q?HQ55Z5DesJHIIcmx5gYUDwSPfFxO0LIVxhbIIoQoQQd4nrxLMORx4IUoAYVB?=
 =?us-ascii?Q?a7PwwrofnH6+N2xQKDwb23efyQTSaPzI6RqIE/vcWH3w6qjoKFdlP+FQ85Ae?=
 =?us-ascii?Q?Zo4yCCZxFPUMsLSNc27EB3UtvyBN7Zv7v5i3jlzHVJF4AkZPL7U71H2HpFwR?=
 =?us-ascii?Q?XQs1KetYBKjh6hcekGvehmCF/v4NKUF8FcEmgDvpwm0Y7lUgTMiuQdRvr5oL?=
 =?us-ascii?Q?cCmBmG/VURkEntzcbzeiPPN8Noxp9uo+EpO0qvaXSS3SavXB+fsMjq59xr6j?=
 =?us-ascii?Q?8l5P7thZTyFv1OrtpuVDpuDt9PZUCqovyad+DImt4pHUWyIOWXlvMvbwYQOe?=
 =?us-ascii?Q?rXSK/FxTVK28HytQLtfEZMQGomHff/aaMPx7p7gV5Qp5kV86tcSMJnwwMuQE?=
 =?us-ascii?Q?CN+civFy1l0EgEMnwamLGZcceErmraoh9qicewgY7urYzMbS3tnNF1x6e7OH?=
 =?us-ascii?Q?DXLBr7L5Jw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e1333627-5969-420d-c925-08de5884ecb6
X-MS-Exchange-CrossTenant-AuthSource: IA4PR11MB9131.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 00:35:06.5449
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ovNTGsoatL3gYQMBC9ocK4jL35BAzaBfRl+jVu4sx/jeZx25Qtmh91Uzq7+4rayS8gb8VsImKBomk8+9Clmsdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6957
X-OriginatorOrg: intel.com

Neeraj Kumar wrote:
> Prior to LSA 2.1 Support, label in slot means only namespace
> label. But with LSA 2.1 a label can be either namespace or
> region label.
> 
> Slot validation routine validates label slot by calculating
> label checksum. It was only validating namespace label.
> This changeset also validates region label if present.
> 
> In previous patch to_lsa_label() was introduced along with
> to_label(). to_label() returns only namespace label whereas
> to_lsa_label() returns union nd_lsa_label*
> 
> In this patch We have converted all usage of to_label()
> to to_lsa_label()
> 

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

[snip]
