Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 698AF28982F
	for <nvdimm@lists.linux.dev>; Tue, 10 Jun 2025 22:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749593067; cv=fail; b=DzquFW6Lh82XBbiXsppAfaROGJnLyKamtKbDAFMWgLnd8r6fve/V11WFlxGRc00cOs0QfZMhegfeUf5jeh9h/4neQOxFxEwZlaDitnSJTgf9saD+IiBBUN2XfTIv5jjhG/CmvT5rNjDSyWAXkgVyc2NWgAmc/I/VIYtIU90aXTo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749593067; c=relaxed/simple;
	bh=vFR1OTE6cQnFazCbqSJaOW0Bq3Q9bf+HuyLvVw9GmmY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=MpdCqXGU/X5dpbTsR9g8/BkV4WREjN0yiN/ZXGLYrk5UodY9jyssvsXY3zeWQMGjRBiNgaZBsalrabm3tT3MB5i0Z7echI36YuRV4Ng3Cz0UdtLa/vwhiQxuR7RRa/zaIqD9PEXHqhEJYtiy5LagnMUqrDh1MW1s7D+VMNdGHnc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Rh/Kb+eV; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Rh/Kb+eV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749593066; x=1781129066;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=vFR1OTE6cQnFazCbqSJaOW0Bq3Q9bf+HuyLvVw9GmmY=;
  b=Rh/Kb+eVvDWhuNbMWWdvC2E4MBKDmCRM9PaP9RjZQk93sspLX58CWknH
   Yh7s4cMGcpet8rutxGwDoPZOOcIsTPsQ6iiTAY3vfJ4Ml6MbPeQ8HV5Pd
   BL+ESukJBTw1sQ919r8fzQ8XKS2eVx1VDRDrKGyWwCzhd0P7KS8ZHtN42
   7mFsalk3JmEJledse4FmKr/1hi2Kb0quGffSFBsEwiFXIiCDGOenbhXZN
   bzS19R/ICgDb20TI5xYcYuZenWg6KNvjWHASPjeeSbngLAFJ31rMTlx83
   /eMawKBqKka2KRLgl3xo12fHUP5x7VIfpxwNBR8u+RfTLEH/jBUvwkov0
   Q==;
X-CSE-ConnectionGUID: M6G1UVqiTAGH/GX1g1sjwQ==
X-CSE-MsgGUID: v4w0w0nKTfWAIgl+Zghp3w==
X-IronPort-AV: E=McAfee;i="6800,10657,11460"; a="62375988"
X-IronPort-AV: E=Sophos;i="6.16,226,1744095600"; 
   d="scan'208";a="62375988"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 15:04:17 -0700
X-CSE-ConnectionGUID: oEq8qhhcQdGIGkpvSCmjjA==
X-CSE-MsgGUID: 5ZplxORdSESQVTIJhwmhmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,226,1744095600"; 
   d="scan'208";a="184142756"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 15:04:17 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 10 Jun 2025 15:04:16 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 10 Jun 2025 15:04:16 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.64)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 10 Jun 2025 15:04:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e/8wLBS6Jjd6WI26OUo9YtY1TEnfiJUMPkmMcpBNHwoR1Yg/ODx3pH6OzdjZHgUdy0htoKPQStkDGN0oMKptsThnnj+0zRPWOikUwqqI4W/7dz1kdWiq7D5Dyjtk715eagntbVhJYj7lzIOcKB3/LJi4ANMkY0BQsIp6GJVkqGYzp/VYpUNoXjq3iWDv8i8V7oLx8Gyd7Yt+fJrYWYgHzBp91dZYvclI2wVuYz0X24Wcn0Ct5o3VTrzlPKHSv3aL2F1akz5B93aE5JEJXrljhU5PWCta5AoNWwM6Ie/Enxv+tomRAf/fHROnRLBFRHoopg/gG8dwPswAmtGS8HC4wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Big5i1e7TBlIdzwPhsWFMizwoPm1COP+qoM4zf4DXlA=;
 b=IxC2EhFx+DBCquUtU6xYD+xgjpFQ0svC5CReAxQj2k+ACPdCOiOFCACx9SqwuMFXJKv+j/HwY5aVhGkId4ILIEEUjvEEbAyt9bigOes2T2wqaQRLHp37yuknNZbDNoUW0yT9K0omZOt4rDkgRu/PtyUxEp8wPx2FWHsKL7OgV/BrXQ80iXTZQc//F+/k9Q6GMVXiE1sXolpVVxt5YNCbQLwp7q10LcCgv4aEZC8dskrxN0GOIbv/uOWjRVXNfnZOQhXLg/G5uIcva7RwoyCqTwBKnaeEVt23OZ+zqdppNT8LZhIwyBP9VfxmBoTzpOq+PM/xc2BXgjxtK9oshOAzqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA4PR11MB9131.namprd11.prod.outlook.com (2603:10b6:208:55c::11)
 by DS0PR11MB8668.namprd11.prod.outlook.com (2603:10b6:8:1b6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.19; Tue, 10 Jun
 2025 22:04:14 +0000
Received: from IA4PR11MB9131.namprd11.prod.outlook.com
 ([fe80::7187:92a3:991:56e2]) by IA4PR11MB9131.namprd11.prod.outlook.com
 ([fe80::7187:92a3:991:56e2%7]) with mapi id 15.20.8813.024; Tue, 10 Jun 2025
 22:04:13 +0000
Date: Tue, 10 Jun 2025 17:05:18 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Drew Fustini <drew@pdp7.com>, Ira Weiny <ira.weiny@intel.com>
CC: Dan Williams <dan.j.williams@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
	<nvdimm@lists.linux.dev>, Oliver O'Halloran <oohall@gmail.com>, Rob Herring
	<robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
	<conor+dt@kernel.org>, <devicetree@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Conor Dooley <conor.dooley@microchip.com>
Subject: Re: [PATCH v3] dt-bindings: pmem: Convert binding to YAML
Message-ID: <6848ac1eb67ed_1c87162946d@iweiny-mobl.notmuch>
References: <20250606184405.359812-4-drew@pdp7.com>
 <6843a4159242e_249110032@dwillia2-xfh.jf.intel.com.notmuch>
 <6846f03e7b695_1a3419294dc@iweiny-mobl.notmuch>
 <aEeUInXN6U40YSog@x1>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aEeUInXN6U40YSog@x1>
X-ClientProxiedBy: MW4PR03CA0235.namprd03.prod.outlook.com
 (2603:10b6:303:b9::30) To IA4PR11MB9131.namprd11.prod.outlook.com
 (2603:10b6:208:55c::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA4PR11MB9131:EE_|DS0PR11MB8668:EE_
X-MS-Office365-Filtering-Correlation-Id: a05ecc3e-f15e-44ca-fb00-08dda86abc38
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?8L+8gTDWgS+jPUl5VNnClNb4Acc14UushDm+LWRGIQgeIVQyoFxRQr1cXfUg?=
 =?us-ascii?Q?YMRCr0d3dy2aNa0o3oNhDZROPkZT2NvCSwh99CAq2A/MavRlRUiTDWeJYV7i?=
 =?us-ascii?Q?jd1dDL39EheDerkId2g7NKjHNMvigqQ4L//Rkb22VrM0vOKpBoocHwjytYCB?=
 =?us-ascii?Q?N5zk9ymwAtS8cauJO/JZ1TD93U3fI7mDElHj/KRpz1uial6FyTC0u1uFReRs?=
 =?us-ascii?Q?upWzjsCvEfPlh2l9CM9OKXLXEVMK9HziRNzkqWV/WH5y3nBhDUQ3gZafc518?=
 =?us-ascii?Q?aICNenhsSkvU4QxLEv6M9CiGQ63Wr0kNsZmD1SMAh/YpS1hMKJ9/JkUJPRDC?=
 =?us-ascii?Q?ZxIXFgja8QiXQrvyxPE2kFXiRBa+A8Y57m1R3g71Yf8Kwck35FyVGvMHhVIV?=
 =?us-ascii?Q?4Xmm1RvoSWySBS3jPFJHSKDBxeFdnxkdw4ySExvJ0/gyBI4bQLDWJkTq0kVl?=
 =?us-ascii?Q?drmgSNyHlgGTaRUAsuFun0sgtRlfL8spcUxJsv3lH+iGY9gH1QH2E5Ax2QYU?=
 =?us-ascii?Q?oV2/K5GzTgvyPDn1CJXmFm8qGz8s6ILXq6HehF7ITyGuofFNmlrRISk68ySO?=
 =?us-ascii?Q?ogFOfV/luBCDw2SQ/FNnGpGI54/CuN1Egl8YvJkucVIP4W3G0lSaCZZqFJcj?=
 =?us-ascii?Q?891NntMMcR6AzzgNXvgiz9tOD0ol491lxFuFwiRuIe9yFoLHLZe5zW22IFGp?=
 =?us-ascii?Q?XaEnOGgfLLlDprG5C443RERLtiDhB4wkyJdsjm8G2haFpTZ7jZy0uj7aVUJf?=
 =?us-ascii?Q?Zm6r4ZlUnR6igxE/MP4et+mLY8fEDQRJyvNEB7mtltmXhihlk6szkw5Z8dI2?=
 =?us-ascii?Q?NkUIrKtWEDN/Pmp0/q6UTKp04JunNeS9pBjKD1tmBDHFTMagKZqy2D9VS/vP?=
 =?us-ascii?Q?Z2KVFlcmY3g/jHfw+0mITlmfHCnxGj+mJTrIi/cjo28cvy27Jj/FCQ2RaAD2?=
 =?us-ascii?Q?M6XCvTzydIgmp3m8i4qtUpmL0QcYSMB5nwatNH00p8H3DEDPTWVEbsF3ctN7?=
 =?us-ascii?Q?1Vkzid/IJV46BBw5et7lMN/o2jxJcoz/xPg4OdeeP4q64Jq4Mrb0GBDmeeyo?=
 =?us-ascii?Q?u/J7UNwYcJb7qa2LieWU2Bjh1t0/ydpCvEKwIUQ4AT+T771Qy1KSnDxhfNtP?=
 =?us-ascii?Q?hgPMTv+JhtQmqIScUZUbW6NytuSQrtIb9wNw8jsNBSdWujzic+NjlIIM5f0H?=
 =?us-ascii?Q?FY/7JGPhLEgf1avFbC84lTnlfiC2YFNa7OZkQVY8Qekvo3+f8oARZeO1t3E6?=
 =?us-ascii?Q?Hpg1NKA8b5cJJAuzT4Ra9RV3nbS/tgf0NyhwNirvFLKhsiMPjSkOB7payKE2?=
 =?us-ascii?Q?LAww8kMfkYLKbvcFScbbBjYhJKGg1rrgenpXAF9D4YlmBK4LRNvZqGQ8QVfV?=
 =?us-ascii?Q?Zj0t5z1BIjb0xP41XnRF9JTM6N9e7mn0OyKcUoKMh9nJfFIodciwLMUvuNxD?=
 =?us-ascii?Q?SXB+YgkSNaI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR11MB9131.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Eq3/vOuvwUGHWZHYWas/RY/uE3MIA6hIZ4RW27GLUTViON+dXhzt98p8CLBo?=
 =?us-ascii?Q?eql62iCeNGcH+ai3BPbIFqJotFccK5dODRiCkoFTBBCLkUOGdk3wkIwa1FXq?=
 =?us-ascii?Q?LXx22fa/cBMI4xrnrfIgTSTH32bPcWBeBzuqTFvanT2G/RlDPbFtsLol4QMc?=
 =?us-ascii?Q?InNeSfzHM00A23kHB8Ya7RSOav5GKFwTh6WHfD00jrwOlTQjzl1aNxQ3DeJ4?=
 =?us-ascii?Q?4N75TCtBSsvUOnWH/j/TOZRzogDzawVGPD4FU1Q+AsrHJ/hyE5PWZYtvzrb4?=
 =?us-ascii?Q?qpv/nylX1W9LWEa1jK0Lurl7bEuPgW8nksnch/N6Dh6UwCe0oy0Tbd8eZLUp?=
 =?us-ascii?Q?9Y1TkW698jyxLVO1opHT8CDh7q/xZne+QMjRoo6QYcUtiTPPoY9Cton3rd5L?=
 =?us-ascii?Q?Wbr3fIkIcDbr4vs5MM9mw9N1z5w9C56HuTKatEpOr12ejpcn3U+ci99fYRFH?=
 =?us-ascii?Q?Ss8HQfG6E7p15a3R668iT8re0wet+p3Qh7dkZ0kqN3uGs04cJ2pMOr5dsK0a?=
 =?us-ascii?Q?DiHiyOqlo5aWE6tYijFk3s5ZlCTkWrftxWeNwPDvH5aaImS45a8tRiAoDild?=
 =?us-ascii?Q?Y+xkv3zI5b0lJj3BE6USPIVvupMxHPCvUyBOtFnjIr9CkNU5VlyWVaPq24lI?=
 =?us-ascii?Q?d3cNGFFXG8U6PdATw2UgfWBJMRsb+oCiAlmf7O2jedSYqHHVkRr3pnvfl4vt?=
 =?us-ascii?Q?LF1n5VeB9Hbxbrt1l4okzvGVN5LE3QV2HB53N0P2VpcwvdiWyJuXrRrEJDeT?=
 =?us-ascii?Q?3c0uQBwFR5LLqdaIuFY+7x6bq93GNFrrWeJ2UdEKPduNi9uMLwU572dRzS2c?=
 =?us-ascii?Q?aYBqACXY4hLjJBIUXZKsgfBhlnZ9FK98dGhJwHCFrvoDJlAd5ESVlPr9rhYe?=
 =?us-ascii?Q?KI5ch969Fq0qWVp4PNo1Jdm7TxdrmpdHBlE7LAcva1/jCMcUSWCSM5pM3Q2F?=
 =?us-ascii?Q?bH72uL/fF7F3JwiwVFoh6zxH6fueG69lHXkhbV48HISECBP4Wq6offiaJGDL?=
 =?us-ascii?Q?gL7rLHhAOCmTyQWwGV0ir4qMeQQ28YprIgEx14aSsP73KYHPlbipKGQDPLQv?=
 =?us-ascii?Q?8B49cyv6vmo8sMrLA9Y2BEgwLoRit3nNumLZ8VN7QZBClpFxpn7phx6S+sxG?=
 =?us-ascii?Q?gn/mpKdwGb2/LJ8PfqwqzOxthPSCdB8tfDc98G71XUtoBiSOU9bGnpsXp7rA?=
 =?us-ascii?Q?Or06NXag8KYrjYADErTPH3FGA7BNPhsVEL7Pi8KcjX91Wi1JCLTMiQVIT93O?=
 =?us-ascii?Q?FbpnGvfYxpo4ZZzoZdI1hZPIFV9SxZnpRYJJOeuS2/ljV9PvRsh1v7u/hYgh?=
 =?us-ascii?Q?08oI0o5BW2yAkdMz+gxo1zsNW13Xo9FIBgkgBlIbHgzZisIxdfRqwtpWZqe4?=
 =?us-ascii?Q?yeb23OlpXmXot45G9iqgOaWwirlNStDIdF1uqJStwO/e9KkfyH4Jyo4X3CUV?=
 =?us-ascii?Q?yS16C5I9MwzsvfcuaJGCAc+QmoExXegkFWCQMSgld4TEjU8Zezf9a/rZEk1/?=
 =?us-ascii?Q?Z6vRQCA7CsbpCc248EE92uS2lgSAv97H0mm0PsktcBu6LDTh9QX6rsEal86L?=
 =?us-ascii?Q?bUcsu2GDaA0jfhgrhVvuCGeIDv52JenznjTpFirx?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a05ecc3e-f15e-44ca-fb00-08dda86abc38
X-MS-Exchange-CrossTenant-AuthSource: IA4PR11MB9131.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 22:04:13.8699
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uD+oc1aDXpFIq4rvbUH0FiAs2wTEpSOG+yMTRjz+7+7Ms4F7izhoywFwlPFLUMIrC0wa8bXUSEhfFZn+9i897g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8668
X-OriginatorOrg: intel.com

Drew Fustini wrote:
> On Mon, Jun 09, 2025 at 09:31:26AM -0500, Ira Weiny wrote:
> > Dan Williams wrote:
> > > [ add Ira ]
> > > 
> > > Drew Fustini wrote:
> > > > Convert the PMEM device tree binding from text to YAML. This will allow
> > > > device trees with pmem-region nodes to pass dtbs_check.
> > > > 
> > > > Acked-by: Conor Dooley <conor.dooley@microchip.com>
> > > > Acked-by: Oliver O'Halloran <oohall@gmail.com>
> > > > Signed-off-by: Drew Fustini <drew@pdp7.com>
> > > > ---
> > > > Dan/Dave/Vishal: does it make sense for this pmem binding patch to go
> > > > through the nvdimm tree?
> > > 
> > > Ira has been handling nvdimm pull requests as of late. Oliver's ack is
> > > sufficient for me.
> > > 
> > > Acked-by: Dan Williams <dan.j.williams@intel.com>
> > > 
> > > @Ira do you have anything else pending?
> > > 
> > 
> > I don't.  I've never built the device tree make targets to test.
> > 
> > The docs[1] say to run make dtbs_check but it is failing:
> > 
> > $ make dtbs_check
> > make[1]: *** No rule to make target 'dtbs_check'.  Stop.
> > make: *** [Makefile:248: __sub-make] Error 2
> 
> I believe this is because the ARCH is set to x86 and I don't believe
> dtbs_check is valid for that. I work on riscv which does use device tree
> so I use this command:
> 
> make ARCH=riscv CROSS_COMPILE=riscv64-linux-gnu- dtbs_check

Yea I'm not set up for a cross compile.

> 
> 
> > 
> > 
> > dt_binding_check fails too.
> > 
> > $ make dt_binding_check
> >   SCHEMA  Documentation/devicetree/bindings/processed-schema.json
> > Traceback (most recent call last):
> >   File "/usr/bin/dt-mk-schema", line 8, in <module>
> >     sys.exit(main())
> >              ~~~~^^
> >   File "/usr/lib/python3.13/site-packages/dtschema/mk_schema.py", line 28, in main
> >     schemas = dtschema.DTValidator(args.schemas).schemas
> >               ~~~~~~~~~~~~~~~~~~~~^^^^^^^^^^^^^^
> >   File "/usr/lib/python3.13/site-packages/dtschema/validator.py", line 373, in __init__
> >     self.make_property_type_cache()
> >     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^^
> >   File "/usr/lib/python3.13/site-packages/dtschema/validator.py", line 460, in make_property_type_cache
> >     self.props, self.pat_props = get_prop_types(self.schemas)
> >                                  ~~~~~~~~~~~~~~^^^^^^^^^^^^^^
> >   File "/usr/lib/python3.13/site-packages/dtschema/validator.py", line 194, in get_prop_types
> >     del props[r'^[a-z][a-z0-9\-]*$']
> >         ~~~~~^^^^^^^^^^^^^^^^^^^^^^^
> > KeyError: '^[a-z][a-z0-9\\-]*$'
> > make[2]: *** [Documentation/devicetree/bindings/Makefile:63: Documentation/devicetree/bindings/processed-schema.json] Error 1
> > make[2]: *** Deleting file 'Documentation/devicetree/bindings/processed-schema.json'
> > make[1]: *** [/home/iweiny/dev/linux-nvdimm/Makefile:1522: dt_binding_schemas] Error 2
> > make: *** [Makefile:248: __sub-make] Error 2
> > 
> > How do I test this?
> 
> dt_binding_check should work on x86. Maybe you don't have dtschema and
> yamllint installed?
> 
> You should be able to install with:
> 
> pip3 install dtschema yamllint
> 
> And run the binding check with:
> 
> make dt_binding_check DT_SCHEMA_FILES=pmem-region.yaml
> 
> You should see the following output:
> 
>   SCHEMA  Documentation/devicetree/bindings/processed-schema.json
>   CHKDT   ./Documentation/devicetree/bindings
>   LINT    ./Documentation/devicetree/bindings
>   DTEX    Documentation/devicetree/bindings/pmem/pmem-region.example.dts
>   DTC [C] Documentation/devicetree/bindings/pmem/pmem-region.example.dtb

Thanks that worked!

I'll get a PR set up,
Ira
