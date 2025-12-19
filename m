Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B0D272E6D
	for <nvdimm@lists.linux.dev>; Fri, 19 Dec 2025 05:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766120925; cv=fail; b=NhMzLf87OmbZ61ISpa20fkaa1FSG4oyEz0iHOAOV50Kg2qNgOiSGA5miJLNCFcWC153Tfho7/aq4iQkASB9yGiNrzzLsU+tC/3f8rMLwLCsaJRZ/OSIB22FU0kFMOJOxOq8tDc8N516o5w4HdQIWrHEI6QInIU+1PYJoDrrcA0k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766120925; c=relaxed/simple;
	bh=T8u2axos2/c2vvwHpmvKMlzggbUMqHW53PEYWYISoAM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=WKEpIThFosXxKw++ZmcU6i00siL808e+L1JrjhtwdYLvkE8/Fv+pUk9vaBCOIV88Owjec3bITwk1Z/LV2flboexs1X0QL0DH3ReNChtVEiimdZQJDp6kUUPtjPVOIpVZsMl840PiuOr3reIz7K57wOHP6Qm/zxaBIzbZ4cK4X+8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Rh9VVynt; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Rh9VVynt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766120924; x=1797656924;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=T8u2axos2/c2vvwHpmvKMlzggbUMqHW53PEYWYISoAM=;
  b=Rh9VVyntX7R647SuQ60DzwJQlaqiFtjos7NRFoKknKOsMv1gnVrhbskw
   aQUrIoSTb9IrMpw5akVIyey5titD+Xy7+c1iue8mD0bnabXyT09zdt438
   Fi04TDyQUFo2sBv9kTbgvcDyTnMFLgxMx5tuY7YWSXW5eEaXMsY3tOxGF
   ms4e9pmHXwvZvaTdHIOuRvGCNLMYmww2B7Aehd8BVR1JiofjcLuWmOTRz
   83Xwv6Mw6waoFHaPj82zUK7BzaVg7F5Vr0IcEdBZKDP97bBzms7Jpb32v
   D3GYxq6c5wP4+YoSbDzHHcecHMDah7VMcnDxOme5nvPsMGo0ociR8yBTH
   w==;
X-CSE-ConnectionGUID: 6lelHgR1REidqJXwvCrZoQ==
X-CSE-MsgGUID: BWftNg4nSzikC6wLTxF3XA==
X-IronPort-AV: E=McAfee;i="6800,10657,11646"; a="67959545"
X-IronPort-AV: E=Sophos;i="6.21,159,1763452800"; 
   d="scan'208";a="67959545"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2025 21:08:43 -0800
X-CSE-ConnectionGUID: VSZGF16TRNeSRt2fe3BEEg==
X-CSE-MsgGUID: 4a01CJeuQEya/Uqmp94Z1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,159,1763452800"; 
   d="scan'208";a="203284379"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2025 21:08:42 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 18 Dec 2025 21:08:41 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 18 Dec 2025 21:08:41 -0800
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.61) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 18 Dec 2025 21:08:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Av6S0wMBvRuSBoGdHPPhaMD8oy3Lq+X12L9aSS+VxEM8ejejOZ8ROe4COKvIlzwypdIs2/ViMhOH6TD8jZwoAZicss6DzsIZulHd3+J/QmPp83ZBO+b2+f29iD5Cgi/tAIr09wvUE+8kF1M2z4wAOdfsaVfOrhn2RI8JvYHzk9YlL8gZsAa5ParU/UPokJqbT9V0Q4EJhUf4lW3JsRVy1b4WAlBZgHQCoWIocfqU0m2OgG+ffhIvkEC9u0PbiQ4OhyHvkPjbGzuxugzK6nJuljLS3olmdAKao98fTSIZIl5YsBZlLSg7uZJchTqC6F9oG/+xBaUdZagoniVA1d7BlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b+vBMENiHB/YXL8nozqMpVL9aZcn7syK3CM1nB7/nXo=;
 b=LHT+E8JTEtBZUVlpcYKJD9d7uKgZYSN9IPtvARq1v7a7DS5nSGNajAbT1QSsMy3cA/vfvhgoZgSRBDFAgZBW7sj/NvHsszZyDxeBqSojDE+5nJYqwiQgEphziZV/36Q8P1PJ2V2MYJ3DZTM5uDoAGaH+uISIO8YCp5DkR8/Zr/uHO26TRPxzEvjveW8uesnpaa55zWb8sbNKR2eRuOq6SW/qFlwQ6zVz6uhex/nVbheqeXay3Ed2mfvMBU43o13SUckePXmE542Sgu9pcma9btPYpC/79bUOpcoiQhu0MXNL6gHHr2AUNKPAhV0qglhLrghWJ9arbc2YqtGWSKkWRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by PH3PPFEC5C0F28D.namprd11.prod.outlook.com (2603:10b6:518:1::d5c) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Fri, 19 Dec
 2025 05:08:39 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee%8]) with mapi id 15.20.9434.009; Fri, 19 Dec 2025
 05:08:39 +0000
Date: Thu, 18 Dec 2025 21:08:30 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: "Cheatham, Benjamin" <benjamin.cheatham@amd.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>,
	<dave.jiang@intel.com>
Subject: Re: [ndctl PATCH v5 0/7] Add error injection support
Message-ID: <aUTdzjlvdXmh0B1L@aschofie-mobl2.lan>
References: <20251215213630.8983-1-Benjamin.Cheatham@amd.com>
 <aUI13O1UFv4L__yw@aschofie-mobl2.lan>
 <bea48658-5960-4159-bf74-f4ab806189d6@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <bea48658-5960-4159-bf74-f4ab806189d6@amd.com>
X-ClientProxiedBy: BY5PR13CA0021.namprd13.prod.outlook.com
 (2603:10b6:a03:180::34) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|PH3PPFEC5C0F28D:EE_
X-MS-Office365-Filtering-Correlation-Id: 98f1dc0a-3f47-4f10-2272-08de3ebcabbf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?TNet8UyVhekLpLKC2IJJ/tVqob++ITe4kJEGjVj8jsM64bJwOYaWxJofi55F?=
 =?us-ascii?Q?Go7hRHOYnZWWQyKSqdXOH7HEg38NkdCTBTO0LYzWX0JmFLlnISqOyq31s9OD?=
 =?us-ascii?Q?8Ri++c7PH1IOHFYrysv91t+KQU9g0AyHOSjmJC2sk+nOcKDy6crSVx2Q2W38?=
 =?us-ascii?Q?epXarpjaqiSxCIAZL9zYgU2g9Ov0KoeFjgboN5S+Tgke/k7QTJnatdXkZR19?=
 =?us-ascii?Q?NohXz5QHIEWOMWZD8daZfNLOHzJM3bInLwyrgdH8y+sSiolEIsKSvlWzsV+y?=
 =?us-ascii?Q?ZaE6O4S/j6G3qDk1OG2O1xVNqzx+qhc8v0zoX4Wyj3B9waQZ2nUPyDcTJvW5?=
 =?us-ascii?Q?cO7nC6zasloHYaJwRFNysqQlu6kaRy2psP50fDca51XWEbzW4/duoXBL3AE8?=
 =?us-ascii?Q?6HwBn/JxZJGn2luRMv3Jf7JyHOzFYnj1cLtwnppOoZTOXxdDLGWVUTAK3iWF?=
 =?us-ascii?Q?Ii73UZSuQtekYpIw4fjXu8FuOYX3Ryn88UmCvwNyWP0/vWsCuv5ZRI+sR3As?=
 =?us-ascii?Q?BBKjLAPyqGbfaDd9kRNlkRBlb561ZAHDHVFuRBZ1FHrycNYVmp/2CgqxSPqC?=
 =?us-ascii?Q?MmutbsCjkOSJdhi5lREsOpvVkThaU9dhzYD2QoqwG1yef1KAMO0b93qBp+LP?=
 =?us-ascii?Q?dJsV6tIUWWTMwOzGKXAS40jbs6JPZALMBqerz5k4CIhYoghmJ5sqfLzJ86PT?=
 =?us-ascii?Q?Tq34lCNitOnBc34DVjA4YdLsLxyA+M7DLVIvC5X5Dr2JmMenSdYuWWoBhnRw?=
 =?us-ascii?Q?aGlcfXHDV76x2Ka5I/rVB7WSfxiGU7GLIBMuqbB+jJnDTeC4qjRTCkEvrVuv?=
 =?us-ascii?Q?oJNGPEYs/MsVI4jHiSZSrpxuf+NnjIXuU+pR1i6lRAROL/6R8XZiRJNBFLoH?=
 =?us-ascii?Q?Dhv6phdMgn3xY7gT+rL6HP+xMOjwzRYaOePKO0QYQFkTy5U5m9V5FA9KlRsT?=
 =?us-ascii?Q?mJTrqttKvgup6kMYm5ri0++ClEy3Sv6NoEK4AAVrhnlOgDEwJHvpCBLFU/tV?=
 =?us-ascii?Q?qrc1NjKoMkKjjQK7IDWqw3VO7wgHyj5j04og9urKuGkqcwLUff4DXfNTpegW?=
 =?us-ascii?Q?s/Y07P5208JmrYuvCMpKaT5s0W88pg48uNfJdok3qdKsnhq7fbQqGpQNwm5Y?=
 =?us-ascii?Q?VJJByEEdTYQyJb++vfWMRyVm4G9HZxmuzzDejaNdSvPgoxHopXk5FrpWspGf?=
 =?us-ascii?Q?N6Pj5/KpIGGDl0FBlMrvoD0eV12L1wCl7FdYAFwRunqM9H8/cRo3Wx3YQ6Ds?=
 =?us-ascii?Q?aFszSrFIJtA0WS86e7zZP6rHJCuhtDSYV2XTOd4TgyEAkzZisGzQQPq5N4Br?=
 =?us-ascii?Q?EXldDmN3sNMsnMnUFzviLiBIZtcTio9m+MfRc+xXW1rNZcOdaNmVvlXxEm7B?=
 =?us-ascii?Q?Cq3huRkzAF0Dbj0PyLQOigscHdsUYwez4SdT8qX9MVAQm4d4iM8ET/D63c+8?=
 =?us-ascii?Q?eBwQ9M9XleZ9oFEueZGo0f9/1gdhqoCg?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OwnPwtjdr0JNpLMIodGlkhU2lLdiBamqUzu5DWcCsfyY/hkhXk4GCEFXUPmz?=
 =?us-ascii?Q?rabK3HN654NDOgYZRdOPH6qNoYI3nPhdoU/QDgn845E5kz0Cef4dAinBk7vB?=
 =?us-ascii?Q?06BsTGRShW62J/8I/x9HO8Yqy6yuGWIe+37fymC7s6JVEIS3Vi3t+fWBRJHi?=
 =?us-ascii?Q?IE/usNyuK7PmJUjJzsTukFxt0bF1asFCamRhMY6kTWHkIYpgjE6IfwVCmyP0?=
 =?us-ascii?Q?BlCx3yPsh2Uhgcw59nHovCrEnjimCPCv/vr7cHY/wQyIN9sH0x5ku86cbLla?=
 =?us-ascii?Q?kbgL747mEJvIvOAIc/nZ8WFqffXsyEyT1Dr/jidZapfZmn/y1UYAVq4CB++E?=
 =?us-ascii?Q?i/EFoez4vTgT+MxCDUnHbe3SE3RZbrgVUd8/+ymh3hocObxyRpPLrlKUWCie?=
 =?us-ascii?Q?GasxQS7GfpoTtdnFoi8poDbPRnt5bZUQo1I5UfxhJ9Cwce8GXeVRKyweT1fV?=
 =?us-ascii?Q?/qOBRUrnarpzqfItJUFwd+73z3s2Rv+zwumAO5D4dGetXupWBXGQGQaWbuIF?=
 =?us-ascii?Q?pGdgN3PrGi8+j9Dtgr/RfEAreTL+9TS9tT1+rnDP/4C8tlLAQTerDuz4hqsQ?=
 =?us-ascii?Q?p5r5ZeoDT1rJdXEGT05VmqWKJJGdbOCEq9b0cUihSsh76Q5J9gHEoBT2flw1?=
 =?us-ascii?Q?zBoaRWBi9LTECdqqBEHaFMXtLeBWpLQFsxqEksP02ivqkscOZtTj8tCh1uFg?=
 =?us-ascii?Q?858L2OpYGi0Pgr5NEdj4fHdyFXJnOHhbC8A2675dhNBt9Mq4mcQdIFygKM40?=
 =?us-ascii?Q?QqC9pDieANilXh7JLMYwnfoGjVe4C08mnWtjSGBeI8dOgnOuflqboz1NEfe2?=
 =?us-ascii?Q?0YcjlP0kSXDnVxsTTA6E1FMzdE2hH9+ddgCC70Zb+8fa0vQYAAL/HUWVk2mB?=
 =?us-ascii?Q?Hx1cWDnNfsiRDDe3uXjOhb9SZh7mxFc+0cIpMvIPDMvlElrzYRu0I9uxNXBc?=
 =?us-ascii?Q?Ysr2w4PnLk9+Y79itjpNQH0oeH1cl5xWVZwj22ESjizm3hBS5RjaKxR1x4hv?=
 =?us-ascii?Q?59W/+azG1X+aFvOR5wbUFNRX6omE/crA8oIfYKEgvsiWBOmw1jJt2cd6HN3g?=
 =?us-ascii?Q?cPtE3QQbBmeVfvrGvZ5UoPQR5MuCyP/XNRpxuXX3+AXAV+JO8gherSNMyY2Z?=
 =?us-ascii?Q?jiwvq0ScHB+n5OTbDHPT560dYspNBJurp8d0FY7L06BSFfbSf0E1NYevU/4+?=
 =?us-ascii?Q?vd5TjsX5/KWMfGmrIFJQw+0ucD0ME5E+SRl3ADnPZsVKZ5ZM0F2HkUGVwzxL?=
 =?us-ascii?Q?wIksc3Z86S4q9EeXHAnJFnDM/Qp5oQ87a+MyuKiUR7JaHFCdVHJis3jX6H2L?=
 =?us-ascii?Q?LQ5UKs7pPiqOer4czjZL+Z608DTzJFX5bDn0k7qeLvToEFVYD8H2LBJfFTLl?=
 =?us-ascii?Q?o5W585IcsIb3j172Sq/GzUSejky31ZWnkTcGEoIzeEF/eJM7ZYa5AW4g1NvV?=
 =?us-ascii?Q?cVMKBL8Q4WbxRQgTNK4wUyr5J3mNa4MDuWBAVstZDPIt+tcV907d4KKqqmZt?=
 =?us-ascii?Q?opia4hj6MVxMQr+3k06DhNgq7Y/Hu4tTS7G3JrL6qovt7m299qyGS9H7JilI?=
 =?us-ascii?Q?XGlrTaWMj90FkaL+mV4gKSduErgaCi5f672AZEtvCxrnsJwIvNY9kClrxgtm?=
 =?us-ascii?Q?3A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 98f1dc0a-3f47-4f10-2272-08de3ebcabbf
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 05:08:39.0712
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /ezMMBhwlii/QXZv84QTOYTCXsowHkOLw0b1MQaxljYNnJ7KZ+MK0pD9bf9B7J9kDH6x9jtm+LO/kZzCY0Ln0JCqjE7k4thecl3IIx/y1/Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFEC5C0F28D
X-OriginatorOrg: intel.com

On Wed, Dec 17, 2025 at 01:56:35PM -0600, Cheatham, Benjamin wrote:
> On 12/16/2025 10:47 PM, Alison Schofield wrote:
> > On Mon, Dec 15, 2025 at 03:36:23PM -0600, Ben Cheatham wrote:

> > 
> > I have no test for the protocol errors. Is there anything you can
> > share for that?
> 
> I don't have any at the moment. My first idea for one is to modify the CXL test module(s)
> to replace /sys/kernel/debug/cxl/einj_inject with a dummy that prints a message to the dmesg
> then check for that message in the test after running the command. That would somewhat match
> the real use case, but doesn't test any actual error injection. If you think that would
> be useful let me know and I'll put something together.

As you may have guessed from my other comments, I got this running on
real system, and am able to sanity check the cxl-cli commands for the
protocol errors.

Does qemu have support for any of this? 
