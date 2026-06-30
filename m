Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78093DDDDE
	for <nvdimm@lists.linux.dev>; Tue, 30 Jun 2026 17:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782841312; cv=fail; b=XbLxfjqwWvtI1nvEJLoOt4zotLDRp8CTyooEbi2X8MSjIMVfa6usOipoKNdx6YDFxS9Pwq6BrHBVP3irveA4wdF15RDG89N21F+QrFBTDxYL8G30xjtgRZdSIC/rkJL5e2n9s51Af5Cepgd6Isk3ZTG6jXXpdVuIENF2uf5akAc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782841312; c=relaxed/simple;
	bh=ifbELq1zNxcz3TGs31VnhJk37ouARAdT3ycaZVNNmO4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=UBlYLXGSLQtWwT92o516KDw7IEM3BIk3RR4Abckf/zXwDOhJ67ifC2AJ2SRjSlG2OmzXbRiyYJqhwJVaddYIcOlgKH4oq4AKSfFY7Hl/UnFp7cfbi5CEFXvH1bXXWSf4Zju4mxr2qrZxUUEWaMTBmbHret1wEbLaVP4li0y3HJc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EYsNrBTD; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EYsNrBTD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782841311; x=1814377311;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ifbELq1zNxcz3TGs31VnhJk37ouARAdT3ycaZVNNmO4=;
  b=EYsNrBTDJHVKH9lHicuIVNgD9bWLUrS3MbfNER4uE9hZCJNtLribKb6z
   In++dIxiuZFRIHyspQqkaUAarot+YNjcLLXF7qzDYyhINvKLfFiayY9k5
   BB05YBQuVQ0zseMIrAtP8HXyQM6irAXzUKzltrB2YDEvyBtn7Cbi9S5dt
   2jo4WvjIOgMdN9yLTRg9VdfI9LS9R1ugGDvWztZY47pzm4ukvL+E+r+Cm
   K7Tn5ibEVR5Gf8Ea76q5QImovM9LOIIJgvP0jW7htGks09MPrB7/PL48Y
   X7K0/qozDIMxi1YBr+gc0qj6XY4aQna70TH6iXNYa3qQA0brOmfZuOhSS
   g==;
X-CSE-ConnectionGUID: e3i0wsklSqWE+tDv4HpgNg==
X-CSE-MsgGUID: 7cp8VgOhR8+tuVb/PN58Qg==
X-IronPort-AV: E=McAfee;i="6800,10657,11833"; a="83434831"
X-IronPort-AV: E=Sophos;i="6.24,234,1774335600"; 
   d="scan'208";a="83434831"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 10:41:50 -0700
X-CSE-ConnectionGUID: aKRXB89vQIWhnrsxgeX5JQ==
X-CSE-MsgGUID: jUHuselVR86j+A2Sud/8wg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,234,1774335600"; 
   d="scan'208";a="247856380"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 10:41:50 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 30 Jun 2026 10:41:49 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Tue, 30 Jun 2026 10:41:49 -0700
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.33) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 30 Jun 2026 10:41:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SPaGJFly6XZvpY5HzyRdgdkRkalxexR83SDgqs15RQS7bbOiMg6mDyTR7xuRs44IeMT5FaCn15gTTDZQdoNkxuS2iMBslBQmTjOWRrjrWeAJQnTUVTEw1Un2cRmjrWe+NklMfLf8Fa7BybC0+MXhmD1W1wZbzO1l6upKWKzzfxluM7a9wirpmCrnC7zkI4YhW7EHDuEXvE5psOHMStVq3vENoG+Fg2o0LJMaVthtxppYicrRk4o0Z9ADkeYoPNLbL3dqYouR23NakTo3e9rARAXIfLgH/OoTWre2tk/ZILbyhrEIyms/OuV5uJnttUdSWpN6l5OjezVh34co2mXQkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cMawMby7+kxKYzqVlHdpaI3IkVI0WVzoHmnkEU+WzXc=;
 b=HRSWSmFOHtRfhjIRRnWyurc/uO0KIqJri4T/Cr6gyvKy2cc6Tz5aTP9leQ8m//JnoD6tvfR1kEeLi88qiKeZzxNT3GF7vpEJ+TIWIq2rOpvALFd23wFWw1aB7g4R6Q7qthpinRBqPrrmBNvkGyanGPW+Z1W0XvVeFWwGgDNluhNV5+FaGT0P1d766Eobh80TaYGybRj3MygNy67dNplFBTOrfv4koblUB12JI5zXJLKIhTFXanPs8EcSjbMrQQtAXgANj09StR7orZKD2j2gxEwzOYcALOa6sTxgWT/FE0PhIqPJ5OCzDyDrGGtYQSCl895RQG3azRw1DuSMFpB6uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by CY5PR11MB6140.namprd11.prod.outlook.com (2603:10b6:930:28::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Tue, 30 Jun
 2026 17:41:41 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%4]) with mapi id 15.21.0181.008; Tue, 30 Jun 2026
 17:41:41 +0000
Date: Tue, 30 Jun 2026 10:41:38 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>
Subject: Re: [NDCTL PATCH v3] cxl: Add CXL type2 accelerator unit test
Message-ID: <akP_0gAUrhi3Aba_@aschofie-mobl2.lan>
References: <20260626170959.1416017-1-dave.jiang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260626170959.1416017-1-dave.jiang@intel.com>
X-ClientProxiedBy: SJ0PR05CA0157.namprd05.prod.outlook.com
 (2603:10b6:a03:339::12) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|CY5PR11MB6140:EE_
X-MS-Office365-Filtering-Correlation-Id: f920a62e-dc91-4586-6c61-08ded6ced819
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|18002099003|22082099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info: qEetd3DL+w2iKMlyEjNzILuFTm+0lMnxEGtw0Yea/vSFSnusbaty8ix71aWK789zaVHvcCZQ2JnsSJDv/ZBCVlR/3fiTNYU8rED2kBUcypHY3WKK+NCoYepoD4G50GJ0PiMKuMz7taquHlUxOB2yeD8ihrK5od8okF2WzKHo9rShKNl+QeH6ipyfC1Z29EbVYhwOXkQXJcxYDT6YtsGaj12Yuth7fYyJBjRvZwp23aY0P/JFClPYm2B34gwTOOIiP54PQM8Mjl6UNnyC7z02tUiNrrTgc5BO+mltUs0LOGkwwiGKssXdFAc0I+04vsi1iIurrC4jk3RezRpJFfUOgxyqmpaP25TZJKypogrninSWNo1u1tvNcJYWNeiI5xKnyu3IPGVizPBM1JCYlGj0K0VoLhB8MCGHlrTXKRDd4HXNTGGOgNJN5BptBqSAZtsCQ1WrKltgHJQmf477aRg1qA/K5wSPavtzPbVgr62s4NgTEFnx/FZgVCb6nQ7gVT+A6g3nSeudJpZvajyL2EGjw7XonJ2FBolfXos94bXTtBBBbq4wOZfGl+xhl8cBg5ZXJ7tWTLy4Wzt0p1RXx4CUStNnk0lQ1Dj4OmGPmk4m23qOgNz+A4x34cDqGDTUaPw768VCO1hmx9467/T27nNaCCf2ufxsogrA00ltHMuKAGQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(18002099003)(22082099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TK/WbNl8nnHE7FlbwBmSNKySkL2gYLpPia2cK4WbpBBUBq8Iv1ID9z3q6hfE?=
 =?us-ascii?Q?Ovq8rItEiPxOz/TbTfj/vMqDbrB1raeg2EHwV4I1BKYPRJO9YtVQx2ZoAZXo?=
 =?us-ascii?Q?iahDiELu6Vwo1PbAVnli3LfPEnJz4LPNCtvwzqG524PYwFAmjNrdPU1ny2qI?=
 =?us-ascii?Q?bvbStNwcxTtLduP4j9IXKWDsqI81lv9mc/DDYVJ8nV9YY/H9dyPeRkFOMt29?=
 =?us-ascii?Q?6L5IFPimJKiMcDMO3W/leduALTG2rOaJmr68XUXV2tCZ4y6Ym/HKOl/c4X26?=
 =?us-ascii?Q?XxRdqMPp6uyvXv9xTspV1RPoKYkvgGQsZ4UxcpyhvLDRFMfHR0nll06/T5Sq?=
 =?us-ascii?Q?9UJEBuHtGRU2B98aCTju2EXr1L6uKoj/7QR0l2ttNQ43xtxY0xNum79T04fq?=
 =?us-ascii?Q?W/Vgy7CW3uUlZaES7eUIk5kgPgTsBADgpFrtgvUVY1cFLXJZ9ldOd8HyFvJp?=
 =?us-ascii?Q?jx4qw7t99Whg3wClBnCS6yE/BLeZVfwKT88KZu4olHpXs7GndhmaJGCLcVen?=
 =?us-ascii?Q?Ji1OpESOc5ZNephWevC5eBjnSvtHWyelaiN+uwyake0To1Qvv7oNKng0MnpI?=
 =?us-ascii?Q?mTFEyNdpxHBkedP/7Pbuja3ACkjIeHjFEJQ9DJVlnkC6eUYJp4FvPtdWfF8W?=
 =?us-ascii?Q?schuo/G8bnrjHjoIO96QSHxDGPiMuP3eswagq2Gk56tMXcXk9m0N/1+xGVK/?=
 =?us-ascii?Q?q59+iBSEjFOYNzZqnX1T0Wo+TV/TKlplOkZrY0KJ/Wri1EYOTM6aEQuULDmf?=
 =?us-ascii?Q?54YxBsTDxogBEdVqi8te1QpnlRPQnaraodZfXVTPLL3H8p92FTEq/wSBr2j0?=
 =?us-ascii?Q?hz2FaxtJNuO4fV1BQ8tne2otIrRER4azA2fH7oDdMlvfTsRLe2KdBuenBQm1?=
 =?us-ascii?Q?dHwqm0+Qrn1lh0HgX8edk+LCO0tcYU3YZU9bCBYSg3+KIii+yqamxoMphY8I?=
 =?us-ascii?Q?bY/RRLtk9vFDbCthBIYwbnbsmDl7Sy6UtbyQs85J0AA+HU0quZFEuAxj05Zm?=
 =?us-ascii?Q?oC2e9IfPTTLR/8WNiM0wjvcuEYvgny3UANkJLRHafazNHX8+zQtXmBlx24vK?=
 =?us-ascii?Q?A6FpQ/n6FcYIjkASLR6sqMXSqINuHwQi/na54oulkRzOUqG8HKW6CIYMjoMi?=
 =?us-ascii?Q?PYKdVQEs5Bs1ExkJ4WjKNa+4gtLs6soeRxIXf2YFWAIX21z1BgURbgPPgzeU?=
 =?us-ascii?Q?gRqDNvbBtxs0Oouw+XBx/cjCJCwZqeBN1BUx19TQ7RZyTYW94+jnadD9/NCd?=
 =?us-ascii?Q?5+Ujq1qRPfhcjJJn0GS7Ks2jr6o4hSqnxwVOfOIwpEfvB7hvYY4hEjh3gTYs?=
 =?us-ascii?Q?S4C0MScVPQgho9DAb7rB6efA79JFi1bPFNGTPjFKAog9AQsIuKiyorW/0l+R?=
 =?us-ascii?Q?GscdRFogIMSK/KyQw8sLfVydPHjDXd843ybck3lUbsOV1UIkYHcacXazrPCd?=
 =?us-ascii?Q?rjMbMJaUIGay2hIdeV1F7mantG7ydENmdbG6WCk76+UPaGDMXd80YJ0TudRm?=
 =?us-ascii?Q?oAwk8dgzTK94cSbZCnQAFDQ/qjLtSfuWMGhmOHQnNrY/y2pT59kSHoOGOQUH?=
 =?us-ascii?Q?cBqI0/opx2fSQRrlgf2MX4qzOqxSgP+mhz3QscoqHD9N+5AOgWw6th4YlRVD?=
 =?us-ascii?Q?7e3dz8k1n7FSrta+ulnqIzvwwZU1vVZ4lp+TlY9OUOD0MMgAk1U34mpuBqFy?=
 =?us-ascii?Q?GyC87HbKKQroyY2xLbQ3iMqbNyaMQY1VfsfwdxVFAFwYPQBLbCtgaHGbVeO9?=
 =?us-ascii?Q?J8SmdmtD4AQvlcDS+yFSRYstmwUeoBg=3D?=
X-Exchange-RoutingPolicyChecked: qgflawHDTykwoIi30+MOhXQR4MT2vHIEnwU2xCQdJuZMEVuoZK2Usrttkp65bUfa/7ntHFRYnqeJnsKlopnDlXqglQsa0Y0FeKUrBNMmKKYgF0yzRoAnDQQpZffTZeeOfKp54/B/NgvPFH7k9pFdqgh7OkZUr+RlH+d1cl1HGPWqXhFWYpidHXpL+0QwwWNEI1aBwjurAvnkYbxyPG6MntM2+R2aNcrgOYd6aE7XyXHxIIgJEjhZ2hFLDKkqvLqLZB32yiMl+2Wic1cpPZ+ongfzTUMqZEceDMmMkaSyDWywAvOKdJa26iS9U5JGncMD5XrlppXg8ch2zjTZZRlBtg==
X-MS-Exchange-CrossTenant-Network-Message-Id: f920a62e-dc91-4586-6c61-08ded6ced819
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2026 17:41:41.2033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ow6jN5tnhicspQiJ3/H/zkI8dbFjMHteUdXL3IQ7IDW8DvG6lUB45KGw3PqPXqc61EBtA/xvNbvGkTwc3FYMqaGCGxUCth8wH1jbTalViwI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6140
X-OriginatorOrg: intel.com

On Fri, Jun 26, 2026 at 10:09:59AM -0700, Dave Jiang wrote:
> CXL type2 hierachy can be setup via the cxl_test. Add a regression test
> unit to CXL CLI to verify the type2 loading/unloading. Test include
> removing the root port and bringing it back, unbinding the type2 mock
> device driver and bringing it back, and checking to see if a region
> can be destroyed and a memdev can be disabled.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>

Thanks!

Applied to pending for NDCTL v86
https://github.com/pmem/ndctl/commits/pending/

