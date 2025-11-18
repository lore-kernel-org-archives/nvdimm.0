Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F06930F535
	for <nvdimm@lists.linux.dev>; Tue, 18 Nov 2025 21:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763502367; cv=fail; b=aqM9XsP3bufLEP1zzaS5qvDlM6jNYDjkGZylMbVC5TxID80RVMVoe02LUALkc74s1Piq1zrCbZdaGEARpyA6XPL+ES8bwGkl24rvMroyNAapFv/zVmqvYEgapLetbRBiUzcYo1tIRug9tQk0DV2ULotvKaOQj/FzuUNqJWbnZo4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763502367; c=relaxed/simple;
	bh=u4uLNKTBxByM0S5SNZvvn3YtzVj2Radif+WUwREBN4Q=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jIq3S/HY0l92zklEVtoEdakffs3G4hNE5WhYU6QQNBufX5YKjD5UPAYE0MKgJa8lEAsjjI6DuJYKTLzAN1OOQHTq6TzbgvW7lvTvKNIKfwQlnrcV5UjCW7TaymnmuXpjvS1OK1x6ukU1o/UFvu/1e7glFOPjCIiwoHRH7Jug0j4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ODuyHLCT; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ODuyHLCT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763502366; x=1795038366;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=u4uLNKTBxByM0S5SNZvvn3YtzVj2Radif+WUwREBN4Q=;
  b=ODuyHLCT3wpmu4oIkelgx8E6dVLsBalUkoX8aFbz+kDPgJfNCf+PgoGH
   ZQUjfNgbYXFa42DnwUG0huWsEd9h4Eu9Cn0MyJn9spkwuhq+4NCWWQue5
   eiT02RY9lQzIF9Q7qYVSnSztPuEtoZjMOnDQQpjrsO7A7+2nO3Bg4D79e
   KuIBFppE5m0TR3yx9hfm03LpL3aBhg7Y23Ukv4RjADRqkhxCesAkSiygf
   OHDYnyKgK+l3y9qoGOPkvUern6FENW/+prFPfFk6h6MdwSBot53oU32kJ
   8F6UIw0UeQn70qSE5E33ujjIf5BJIivNNn4tabtomkK49j+gfZ226FN2c
   A==;
X-CSE-ConnectionGUID: w66UafHYTLebsKyixiEKeA==
X-CSE-MsgGUID: U8OO8xshQtioHhzUry6HZQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11617"; a="53109528"
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="53109528"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 13:46:05 -0800
X-CSE-ConnectionGUID: tZwhqt0kQM+fOtW5dVemuQ==
X-CSE-MsgGUID: MQn1OtmZRcemFHsPduzEoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="195336276"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 13:46:06 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 18 Nov 2025 13:46:04 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 18 Nov 2025 13:46:04 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.23)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 18 Nov 2025 13:46:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XWFHFRNPgFX1Ad0UakD424NJZa9iOrr0GnV6oOQlh9iNY+qhNYYNY8N7hmb2eSH4Ai9SqhhHHWAgOy6G05DZsFxa3G8vhJZKCq2K8aDZ2nbskWbJTmwD7Yj7kcQiRfdZaArk5CZaJQ4P/aoUr360kHG/gD+SqXxOuErizioPhmDW7jYm0xQBUB3Hnm22WxVh7nOGeRLeXeW3wot2R0gwlPY1HsP2dlvagWLrIZyKfnuSgnlmdDM7v03H6MGbdF1OPVU7VQrAUHK+mzZ2pHJ0gTcxIWN3hLAwuwvuhMXPwePZebzZ6q07bUXkBlFSacFjDOtBhp0SUHjL8Jh/cxKy9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9byK+qkhl//aW6M1v4hzs3ZmQt03y9xVhEOtiryvR4I=;
 b=QkW+tMLwe9zBrehRTuXMlKab2Bx3AgWovs6MajmkzrOqyf6dW8m0rncsE2gIxSgPwgH1stMoSL/+a0AJV7H7rcP0G0SG6Z7bphyoozk1ggDGibu2LJnCanzAbWdhsChWOvvtflCmjLW669IgR8kk2a0BPAqu1NcszL2IddIz0Nv9d2r6tB1tjvZbTwNS6JLG9HyaHJAMSm83Eb/VdNnGuUpn5SPEpm32ZAoUo65u2OYfwaT8bsKFdCv+DVx8nXzN1kNXKXus41AlotkB5rnUdbwvGtMtXVdjat3ognStzF2AKSOUmV8vR6qgApGsIBb5X+DZ/+fkhGW77hy9gzbBtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by SJ5PPF3A51834D3.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::821) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.19; Tue, 18 Nov
 2025 21:46:03 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::8289:cecc:ea5b:f0c]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::8289:cecc:ea5b:f0c%8]) with mapi id 15.20.9320.021; Tue, 18 Nov 2025
 21:46:02 +0000
Date: Tue, 18 Nov 2025 15:48:28 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Michal Clapinski <mclapinski@google.com>, Dan Williams
	<dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>
CC: Pasha Tatashin <pasha.tatashin@soleen.com>,
	<linux-kernel@vger.kernel.org>, Michal Clapinski <mclapinski@google.com>
Subject: Re: [PATCH v3 5/5] dax: add PROBE_PREFER_ASYNCHRONOUS to the dax
 device driver
Message-ID: <691ce9acae44c_7a9a10020@iweiny-mobl.notmuch>
References: <20251024210518.2126504-1-mclapinski@google.com>
 <20251024210518.2126504-6-mclapinski@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251024210518.2126504-6-mclapinski@google.com>
X-ClientProxiedBy: SJ0PR03CA0276.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::11) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|SJ5PPF3A51834D3:EE_
X-MS-Office365-Filtering-Correlation-Id: d715af15-d201-41e9-76f7-08de26ebde7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?vTt5SCwVNHBFzI3KCk9ai5YWFEm2r0KCSgNuwbfAvvwkREWx8azlDF14fz6/?=
 =?us-ascii?Q?hgYe1VCWPk7SUdp9F2AtdPZ8AFskPOLB5zc+yAxl0j5bf6Lg2KKTYyVWGzu/?=
 =?us-ascii?Q?y8i1V6FuzqS51Vz2LDanK3QDPv2Uk/bZErdtwvAYEBUsNCQwrgXW6VzTJvlY?=
 =?us-ascii?Q?n9h3gZXb0EURAa9L/CzTOZudH397mElU++mZ41ITh8XAH26jHAS9XKiS2Xnb?=
 =?us-ascii?Q?bX6YNuZFq0t5KS0oAqUzhVLWooq1Tcht3bAMg08mxk/LGwpsokymdlX5ERRk?=
 =?us-ascii?Q?nQMGjBV4S2jie/eVnSzXcvw3D1p6gQZ7ZAHQdaKXTXzLqmkSToG1jBhwtDCz?=
 =?us-ascii?Q?JpxUucHJ3lshR1lqBRyYNx21GLR1ZJN6pY26O/sF4DY7MdWurgwiLHq+Dc67?=
 =?us-ascii?Q?qaZua77AMjcZkMo3S2w/p5NBWUwChrpCkklRyvs7EIdnU55/kigqLLcrCsuq?=
 =?us-ascii?Q?ldXG4LxBkHKRABQ3INoIkd6546+sEDZOYz8cYcjfB19AvdFgq039nH5iCvQ5?=
 =?us-ascii?Q?leAxOAblAitIFCzfrC6vhpL8TpMdLlZGqdJ4I/OPAmP5I1yjnh+pB3aADyQZ?=
 =?us-ascii?Q?Fiq0ZOPsrBC6hlhebcdLWgBn5k7IJwJQZip8+Tze9h/EMKUJ8qyRF9Se4iW2?=
 =?us-ascii?Q?zTAdDNh2q7G/ujyCgCL86x7NpXhoT5b/O9eSLMtCzoliQvU32wg4BEXe/7c4?=
 =?us-ascii?Q?N3DoWpOXY7LWsiMPR8c782cO07sRgbVw2vFaaIuuIupkSYdcHlXLhd+astzh?=
 =?us-ascii?Q?Qaw/xi8FhDnVI8kcMYs9cnNLmq4DEB7/vVFk4bhfykl9NE7K6nMrdzzlZ3pH?=
 =?us-ascii?Q?wIs+ldIS772YA2UucTiPDHqNqfInM1t9gMlsMslRQqFeWCaB8zo7OeLxj9Fa?=
 =?us-ascii?Q?G34u1LefYPZ2RYfO975jlyu0NuRakzRIavMiCQAidM6Babn64uU+V2ayXDar?=
 =?us-ascii?Q?kY75QOFB4x52bNRK8AfL4Ku9bNi/CZKBnsuRLR4ZPjiDJ2oQwM8OZV5f3/V0?=
 =?us-ascii?Q?6rv5P4f2u8snxxMkZtQYi43yZQnvEVC3Dj0uaf7EYK8mJV1bzobGG+E+79H3?=
 =?us-ascii?Q?6a9frVeaovMkp5FP8eNm3QxxVONlLq3K2mhS5FILjiDi/U8k7NbXo4Z7Zk5v?=
 =?us-ascii?Q?gMYMvpHzWI2FgZwiL8tBUSVWKse9vH/sZWW/KFIQ7RvCoRunDKeQPeIN0q1f?=
 =?us-ascii?Q?5exUN/656z+d0grQ2WEr24J8FCJeJmy3F/Og+Kps5oCbt3tkldk58Ge5D/fe?=
 =?us-ascii?Q?7e7sdftOJdtogygelvH/n3+f3kbNpQ9S82iGmqyWorG4bXVJ+DRqX0AfV1az?=
 =?us-ascii?Q?8CDn/5n06M+YESSuoC9H2K2YoJg+eWHNGoxr6rDKO8kQaBk8+YdbvANeSzGD?=
 =?us-ascii?Q?ZgGq3QyAEM2QbNa1nREF7u0st08KdiRQbMckht1wRAxzEE4kRz33LUAqoojx?=
 =?us-ascii?Q?FYkEjfb0VCUFVF0Bo7t7urDk2S/Svnvg?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0j6nhD+6o5gzMz1ZUZQwxnOGeyYFU0qPiKWC2c4Wsv+hV5s6tMVbN8cdbTi3?=
 =?us-ascii?Q?dnDOjGiKE2CX8tiEDmb7yQliBOQudAFyUBHNe4H6jU9NGUfu381iHhpNAcXo?=
 =?us-ascii?Q?DoF1Fjr55S8x8Ux5EIPca+Qts3rrhSzwQUp/ZPwuEp2y5jofXQGIhkE1lp0N?=
 =?us-ascii?Q?RDTRdT85bdpMlf3uMrtf+1o94nHQrJP4UX1dbZhulWtotsJqlXfn1Vsgps3R?=
 =?us-ascii?Q?tiKsfnYQ0tQfkfD5ZUk+QU1vVP8NwtbFidpLjJ4I9oJawW1WNkM+R/wrgJgS?=
 =?us-ascii?Q?KpsPpxGQmRAEOWmhG+a1EfewBKTh9c19qWHbFt3/+MuUUa9F7V9XUPAkB1IM?=
 =?us-ascii?Q?Gr/fAb3gsUE0yOxm8LUC3iCKY9j8R1+gEo+rt5bgmiQbsxRrrjy1eTIbeIpM?=
 =?us-ascii?Q?TD5xoKDykji9Rf1rdQx+GQpsoNqnr2WMePEqSroKjLXqOTfgQtFdPIN3Jw0y?=
 =?us-ascii?Q?fy7eOQd8rW5zr5fIPMFsDACd8A1ENVPpFgfh4/2sFZOHX16BuU1eKHUzHnGZ?=
 =?us-ascii?Q?5d1FrI/FOewBO5cTyAD9D6yWxeuoRKBZ+H1YoK0BY3f+i9mjvbun2wroDfJI?=
 =?us-ascii?Q?6LOWUOvpvspme29JPkrurBjIyknunl3V3f4OeB0RG3TuENEAc+AcK5XCMcDy?=
 =?us-ascii?Q?eY6NQNwFshhqJWtRfFSEhhghoADMws/vcsCOScT39n+c+FlBrDwiBp1qzAid?=
 =?us-ascii?Q?pv9b9iG0xYgT9RdtbNej4sEk570V3sg6zSKXi3Yt46GwEd+ei50MXCfRJ5X6?=
 =?us-ascii?Q?WlXxduo7aIq/NxQadQ20AtnNjaoWMQNUrVd0LXe2UkMe5ncAwaluZ/ND1tsT?=
 =?us-ascii?Q?ageeO2EW5kEvJR0Z6t13S5pA3uwBHE/oCcei+JRvKxjpqPjbSoVCuv5wkbT5?=
 =?us-ascii?Q?awfW+esfius1Jycud6xC+vXsoyGhxG0gOyKeCHAxu599LDBojTpqImyJiZ5y?=
 =?us-ascii?Q?mccq8p0/ya9nxOI9PgCWvEHBYIY+o54WXaCM3RZvB7ZHN5Ci9Us5nrBQuMv0?=
 =?us-ascii?Q?v8RunnXYpM15n8Vmw8kH9GnHNtTWDkwS60cCplA8pHBTasuO4hvzzyO83BJ0?=
 =?us-ascii?Q?W6iez02VnqYg1t6ve/326wm6IiAUwe7+Cd6hP/Ar/511GQ2drQks0MMKr5cQ?=
 =?us-ascii?Q?x91oYer+2u8Kmy00HQhUqLVXCWcdmCokFiBV81DeZ2pUwwbvdX/9a9joPuPE?=
 =?us-ascii?Q?g95ut+lqzZRuKIsxrOWXxbgfwD0fTQD+OxoIKU2YhImVi7kcbtlIqV39E4fw?=
 =?us-ascii?Q?Ob9jikwjZpY3M2MnYdXucNCcv2nwKgD0xSNfY0HRjZFS03FTVUD5lMwM2qC+?=
 =?us-ascii?Q?1R9f7XWt1noocLLOSauB4QQ2E1C95azfoq3hxPJSpSy9HeaJKpLAvHQdknlX?=
 =?us-ascii?Q?8YiGRdjs5G3i4KmnwiQnH8082Ee/e1zZJexET/fZV/3SGEm4lhwFssEMYujk?=
 =?us-ascii?Q?iHQNZMLqGHsoc6XdpYAP4jTrFlWsC/jcoY1/NN/dteHMuvQI6CpHbNftHYPT?=
 =?us-ascii?Q?2a0fNdIUtZUOBqU4Bl+1dCqqQovFTYBv82yiHtKnlsaMC0LXJ3x5Jqy2PuyA?=
 =?us-ascii?Q?RXOdCYUeKRN7xxPy5GAruTbVUQyr1B29xtk4Wazw?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d715af15-d201-41e9-76f7-08de26ebde7e
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2025 21:46:02.8424
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rn9AExvK+5lqLIMhS26bZaOyQMuFpit0yUYzxE+ahl3Iu8MUOu4LeTo1VRz8qRM2T7uZAdyG9pmTOcl+XTkRPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF3A51834D3
X-OriginatorOrg: intel.com

Michal Clapinski wrote:
> Signed-off-by: Michal Clapinski <mclapinski@google.com>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>

Sorry for the delay.  I picked up this series but I find that this breaks
the device-dax and daxctl-create.sh.

I was able to fix device-dax with a sleep, see below.

I'm not 100% sure what to do about this.

I don't want to sprinkle sleeps around the tests.  daxctl-create.sh also
randomly fail due to the races introduced.  So not sure exactly where to
sprinkle them without more work.

Could dropping just this patch and landing the others achieve most of what
you need?

Ira

diff --git a/test/device-dax.c b/test/device-dax.c
index 49c9bc8b1748..817c76b0a88b 100644
--- a/test/device-dax.c
+++ b/test/device-dax.c
@@ -246,6 +246,7 @@ static int __test_device_dax(unsigned long align, int loglevel,
                goto out;
        }

+sleep(1);
        sprintf(path, "/dev/%s", daxctl_dev_get_devname(dev));
        fd = open(path, O_RDONLY);
        if (fd < 0) {
