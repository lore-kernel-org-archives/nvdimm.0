Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6EE25A333
	for <nvdimm@lists.linux.dev>; Wed, 18 Jun 2025 22:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750286735; cv=fail; b=bqGiRULBKqC076C7RzlDXcWnZiYI01mwkFYTqJZ65vWaeGXIF80UOsX/USuRuO76BGsE0rTC+JeScmF7TKCSlshxwc8R04qpdHIvOBF4R3QNjevJbygDAZ+WqBcVpYNLQY76mqmup4oVUJxE/EENqbWj8l93yA4mSv0MIUzHFvk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750286735; c=relaxed/simple;
	bh=8vhTOZbaA3UymWZMWcisF2tVDrkx5r59tBYDi/uc+YQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=SuxZTlz2190hZm8QJCEjEmH8+uqG7gTjPsUwZ2c+WKP44vfvZUcFR8TIDFEu4LYlmKQag4fJF4C2L7MoeSCd+1ijAI6SeMZ55T8TxJLM04gXPWNwAn1OW7W1kmJVTDhld0Oc7R6MKB4hQovbNMC6aWfv/xy3iebBKptZKgkMqIk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=emHctE0u; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="emHctE0u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750286734; x=1781822734;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=8vhTOZbaA3UymWZMWcisF2tVDrkx5r59tBYDi/uc+YQ=;
  b=emHctE0u6WM0MprjgQV0y3266gjMjr1GkUG5oYhGIoCSx1XOzws+xSRR
   3ai3wPDDKypDYo+TE7YhX876SRNjh/ilPFARtK0gbhdxMaTFVrT3sdh/c
   wy3md0xiH382wYJNETYiVx+MolsYnl0alPJVH/RRW4BOVaVJ7XsDc2De4
   HIfQS/xZqqjEpPtVnW+eLiIKFwckqAAkcyxKJ4rRKPDCnIZVrBIVw5X3B
   7v/ZwNiKSLtLLVIxTDjb91Y7+xBArIXCWrur4m4IfXig2q9dcPWMxfoa0
   VCgQh/m6qLJir0d8v2bU34mqh3LBcN5JdLFB4CXpTLgLfGBk3CJ7Ob4Wj
   w==;
X-CSE-ConnectionGUID: 5JfBvyEHRE24UN54dRcj0A==
X-CSE-MsgGUID: AF3pfB00Qa6bifGrbWuvsQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11468"; a="52448894"
X-IronPort-AV: E=Sophos;i="6.16,247,1744095600"; 
   d="scan'208";a="52448894"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 15:45:33 -0700
X-CSE-ConnectionGUID: LK9D6hIJRpKbbQjmgu8D/A==
X-CSE-MsgGUID: MFBSxbkiShCkj1Vf+/08XQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,247,1744095600"; 
   d="scan'208";a="181248709"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 15:45:28 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 18 Jun 2025 15:45:25 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 18 Jun 2025 15:45:25 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.49)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 18 Jun 2025 15:45:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mqen3e1CqF0TcocWz/rO0sbmGqkCfEXu2qNVt5UAXcjnJBDxix2HgBZ3PLecEfE0zzGD83yWfGObcf3bszr6ssHuH1KlIjcX6NzzD01vnZkc/BJ1wSOPQW+i6682w4VUqmYUwPr5RU7vdafAgI4m0oh/GsbuuZP3I3ycc3l9HQP8WLb55gThJyuHjic3yxBmDKCtWuxy6y6MQuc74Dn0M8halV5xxvTFa6OWpEmxFV4VWiaiW98gdqxWX2CFv6V1lRm3Fw7QZBm2rn0dDF+Kl36y/MzcDZ9f95GzeXgYl7LpViGkXKnIocgiTsSz3O5ZbtHG7B1a68fkIgnAkIQGPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G1ePnZWdtzobQhTelWSpj3Th+atZVMTv93zbXjbfDek=;
 b=qM1kWsei8H+Vmzoybrrohtw0/hP230/IswXjwlKYsb/BbH9EgeOBEn1KpqYEOFZRNq42SUi7XrEZLNfFNmnH81xdTelS9qhJpHbhgcrnWN6fgnrFz4iMFn9VHyd7fkHaiPgo/VF+XWSEuAOHEhfDBKUC+GCZEwGW6yDWOvK27fpcPvRx01sxMBlVPvXwkoTYACc+o1giF8CAzYZZHxMMZl+7Ib/4qm97u9nXyXRRppKJDiMV943Noa/edNhnDhM6ZLfax3Xteqzp9oJNK7VPsvY4c5DqQ2khrqhQTTr7QikzKiUbkfVhoXy3REhSEoVfnTqoPVNHBFHkC5t7txEiVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB8794.namprd11.prod.outlook.com (2603:10b6:806:46a::5)
 by PH7PR11MB7606.namprd11.prod.outlook.com (2603:10b6:510:271::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.18; Wed, 18 Jun
 2025 22:45:23 +0000
Received: from SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720]) by SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720%5]) with mapi id 15.20.8835.027; Wed, 18 Jun 2025
 22:45:23 +0000
Date: Wed, 18 Jun 2025 15:45:07 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>
Subject: Re: [NDCTL PATCH] cxl: Add helper function to verify port is in
 memdev hierarchy
Message-ID: <aFNBc0JqMxWT5CMu@aschofie-mobl2.lan>
References: <20250618204117.4039030-1-dave.jiang@intel.com>
 <aFM1iWWREEU_dlyF@aschofie-mobl2.lan>
 <46ea54ab-4e20-47d8-985e-53cb7ebbf33f@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <46ea54ab-4e20-47d8-985e-53cb7ebbf33f@intel.com>
X-ClientProxiedBy: SJ0PR13CA0180.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::35) To SA1PR11MB8794.namprd11.prod.outlook.com
 (2603:10b6:806:46a::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB8794:EE_|PH7PR11MB7606:EE_
X-MS-Office365-Filtering-Correlation-Id: e19c9c03-bdd2-49f0-893a-08ddaeb9cf0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?f+lWOKWwyaDC2g3Q3cjmvIt7pjqmN9R2QeryEH4FUbKOlSmWJVVymlYggJrF?=
 =?us-ascii?Q?VPgIyLt5yHJaxHFe2+jVKsdr6SOFib70QZvydq38N8g1gg46d6EOFWqSqLdC?=
 =?us-ascii?Q?OFOE7peDELcl/0pFNuL6IXy16XnoaPxQEE9KsNsvzGjD6BWNhzapgcXgQxSc?=
 =?us-ascii?Q?gqrbdmmjChscin5HfNTPCnVRYCnt3RwAy+5HOlqvmH6KM3H600yAcKZsqa4u?=
 =?us-ascii?Q?SeLJ8pp4vRzaDLgKIEXD4JzpPZQ8ZhGKHRFT+ugcz4W/M8tLxh5WRYD4dlUC?=
 =?us-ascii?Q?zpdUwt18+PJ8RrQQx0Eralngm4zj1UWM6uetCdPBpMGNVr+WZpr7h5ZRPstU?=
 =?us-ascii?Q?4+nx6c/xNSNAyb2Tk+4cmlU+DSB7IA+bEhklpqQe9WPDTKMks8zhQ95mE2mV?=
 =?us-ascii?Q?jFTNKjJFGtUHvNsJvn2GAIkRJ/LIoZrhftOz3SflHtaBpM+e4DJDVX6bBm+2?=
 =?us-ascii?Q?jjQ75XM97kUqVDE0D9XAdpySq0xOsKpk7Jg9r48dH9qBzdUZ1jsfZTroI1M9?=
 =?us-ascii?Q?jQ9+DZeb40cAfphbYywN+gLKlqdyCg31T0XaKH68a8zpN8AGOaqge9+A88QS?=
 =?us-ascii?Q?LvPPVcRBbzt2REy9oi/UM/FAdC5adrW9nT2uHInrw9+8WL0vFT1KTy8Ry58o?=
 =?us-ascii?Q?HaX5TqjRp/v1ORxzZedL8bOgGBUVlBGolYF1fTE5sh6tYxgrHTgCvpKNKQkg?=
 =?us-ascii?Q?Pq+0hJutA9a/0KqTOaZHwnS9s9k1zEMsrwjTlEZQtYSsXMbdxrKzblu5pcyx?=
 =?us-ascii?Q?9SE1nMW4jYOeDe6a3M0+6y3m20M6phho9wIp+ED4QagyH8nWOWIoYVMY5Nq0?=
 =?us-ascii?Q?OlszF+b9FabpSHP9iZWz1/Rc0c7i8dPX14lrz74gvaH/HvDEertimJIzmbyg?=
 =?us-ascii?Q?2KMHPsHK97sdQwiQwTWYZCqBmAh0a4TqfEVwWs0FDbNUx86wHU/s4if3VfAZ?=
 =?us-ascii?Q?vsRPAgZEetpkzAXTYXbGu+YloZ5JyKNnM/kZfZbfSFthQCkwHGne9/CiISqq?=
 =?us-ascii?Q?M41FjO3yOogsh8Uti4dkOtOpRCiqzgUoL1LIv0mBXuqyHvWUob0poSEvT5Ja?=
 =?us-ascii?Q?RpKqtsT9BfpjRLxE9sj1+7GW+HYR9a0ZJs1uwiFQ4qE0yxYgPm6iwT5w7MGC?=
 =?us-ascii?Q?1fJCi9Mo14tGqQBhwW6LbHyeqMRwofifPPXr7i9WC9m44ND+lZTIslY9RrV4?=
 =?us-ascii?Q?D2elWxfCdJ9RLl4kNFqmZH7jztTTvlGjr7UnbREbIqveVffBIhLMGEfkaVPo?=
 =?us-ascii?Q?nfMU2e09VViKtb76AbB5/56iHqZqsRX191hjNTa7f2bXabKncmEaYzP6369K?=
 =?us-ascii?Q?y1sRbwnH4dLEsuOURcGZS4xSd3iRHT86cHVkOzmwaJsBq8ttk7+Hr478p3jy?=
 =?us-ascii?Q?oHd/HOym8D+4i5Dw0fP6XDSAE7HjSCqlh6i3Pn6AESYsP9nGMmlDTASl4frV?=
 =?us-ascii?Q?FTEQ0nVI5Bg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB8794.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nkA2wRRPiDRJ2VoDLHRLg9i4BNziftD5oyw0EGUvGg2NZwgk3xWfXlD1Lddk?=
 =?us-ascii?Q?U68B1+1D1yLXh6ZX0AeVtnKbQyMjnN4zlT76hxIpccYqwOijZM7OQ30AcDWi?=
 =?us-ascii?Q?nMWQPd+zZ6uPlFtAq4pw7AvZ8moBxBWG18JFtcdh2yzYd5Ji72aTPORMVtJ/?=
 =?us-ascii?Q?YdKpc2qJChncEXk10ISQPr1LfPXZa86mKoh8MVKshROtQdVtFAq8A5Yfztsx?=
 =?us-ascii?Q?kMXJ8tTEohhfowXTsB2NP2Sy6842YVJXn63CwgzOgIrXa4r96eX/W4uyc+XG?=
 =?us-ascii?Q?1ef7cVAzrTLoY0g/lZDo3FSICfgKskTXOPJzFTImDINVAh39Os7tffjgSvrt?=
 =?us-ascii?Q?OGLO/pwcGABw4Jxi6qYl13GY2hOsM8+s6pM0rBvo91vwKo8JWMLxjkO6lAAc?=
 =?us-ascii?Q?OVBTJesTnMuGRsaAXlUrc0MIKHNPpvWbDTIdIot2j3MoCm3OdJbibObQo4hX?=
 =?us-ascii?Q?xoQC817Sp45BBtvY1p8ZrAf8StvpWRMfvcSvlJM8v26loS8pw8xJT7fQVPQf?=
 =?us-ascii?Q?67xz3uhSWtsQpb8bDjgolY5uoGCwhQzQ7yi6w/ETnubhEgMXSVtIlave/Qjs?=
 =?us-ascii?Q?QQNJ4uhxBSi/hU+Wxq6SSZZVBUqB+HkbbjVp6s2xpsUjaq323Z6ksil10M1K?=
 =?us-ascii?Q?n8ixbRXkfyoA3hxXZWrndppc8a2Vf+BbCpRwJGwTMINq6T1qzxpWu9sM4uVw?=
 =?us-ascii?Q?O47Xd5Civ4COP82swNJDMT3v/7zZg0NEf19p9UQbEDBqw0EvD5whq9EpYE1h?=
 =?us-ascii?Q?if/t2Yy0voMgLsP7isckmuCbu4jeQU1ikeeJ6p8lT79qearh5HMydW3FxXd+?=
 =?us-ascii?Q?BLneAe9XE1yzPH/l5m08ikKh48OuPzzJdLW+5uRW7q0HvHMONpxI3pO+O2mM?=
 =?us-ascii?Q?GbxOPv7Jn9hXvGTKiC+E0M3tNNAKhAf1dEiZm6rVkj6OSggVbbJK72XqHKDK?=
 =?us-ascii?Q?/d/FNJ4Rn2B7Dah9+ZuFIfAl7Re7uFAMfutsrDuEnVZ5JJoFlgUmLlj8z84x?=
 =?us-ascii?Q?ncjex9+8EIJ4RnxhvnWEK+wklqKcKMpeKCJj7wdl0Bk/T1cZIiHOH0Nvslt8?=
 =?us-ascii?Q?ZweycpYtTsTPNiPprYRiXh2U2yyhGLGLG6xnq2NUn9zzr3WPJs/S+sRUhCH0?=
 =?us-ascii?Q?rlOS7VNXLOgsUx3YAeRFv4ymVyeCZ7SYMoS7Yt5ngQTjCgZfCHgxyC5US1oM?=
 =?us-ascii?Q?yvj8Obf825T+s1e0o8FDfLC8TgyEZVX4MzxvR4nqf5sXzVxazyeHCX3QrPqK?=
 =?us-ascii?Q?IcmsFpzR/KhJpwqBWXv2nqxaN/TwA8Pdl041zgrTZSkPewHnb4ebBQiLB86c?=
 =?us-ascii?Q?7yXGamZgy6+p8fYvktR4z35lTqJfcPRqEykr3akOWSO/PzD+rTkT1tjimLcl?=
 =?us-ascii?Q?lbbmr1g7ZDiusXTYuNOXBajgQNVD2A1Ttyu0Em4EAhhos9S0TY3xgvggboi/?=
 =?us-ascii?Q?WcmEWbzp0Z+6ttQNWq4/Icz9XhwUvsdcTXv0/SPB9zVnFidLX6PLmwJoeFUX?=
 =?us-ascii?Q?L6XQyrDZqUABdbvPRk0dmRF+sL8pAGixkD+a8+ls5UTMzxA/+XT1LpbDX6Ov?=
 =?us-ascii?Q?w8KIeKOZDl3dsj9zHLcV2YNMsYivIKSreJy42FeP5z4XRfxG6xupBKQx8kwc?=
 =?us-ascii?Q?RQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e19c9c03-bdd2-49f0-893a-08ddaeb9cf0e
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB8794.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2025 22:45:22.9821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gPz0lyD2GSUIlXWAsH2IhTCHF16RRs5BW75E8MW2ebLB6EUzkL3AdnJBYBC7rUSLqZyOMaPR7CMyVxo4JzkjhtvnKOTXhUWLnaDFDPsqxz8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7606
X-OriginatorOrg: intel.com

On Wed, Jun 18, 2025 at 02:58:13PM -0700, Dave Jiang wrote:
> 
> 
> On 6/18/25 2:54 PM, Alison Schofield wrote:
> > On Wed, Jun 18, 2025 at 01:41:17PM -0700, Dave Jiang wrote:
> >> 'cxl enable-port -m' uses cxl_port_get_dport_by_memdev() to find the
> >> memdevs that are associated with a port in order to enable those
> >> associated memdevs. When the kernel switch to delayed dport
> >> initialization by enumerating the dports during memdev probe, the
> >> dports are no longer valid until the memdev is probed. This means
> >> that cxl_port_get_dport_by_memdev() will not find any memdevs under
> >> the port.
> >>
> >> Add a new helper function cxl_port_is_memdev_hierarchy() that checks if a
> >> port is in the memdev hierarchy via the memdev->host_path where the sysfs
> >> path contains all the devices in the hierarchy. This call is also backward
> >> compatible with the old behavior.
> > 
> > I get how this new function works w the delayed dport init that is
> > coming soon to the CXL driver. I'm not so clear on why we leave the
> > existing function in place when we know it will fail in some use
> > cases. (It is a libcxl fcn afterall)
> > 
> > Why not change the behavior of the existing function?
> > How come this usage of cxl_port_get_dport_by_memdev() needs to change
> > to the new helper and not the other usage in action_disable()?
> > 
> > If the 'sometimes fails to find' function stays, how about libcxl
> > docs explaining the limitations.
> > 
> > Just stirring the pot to better understand ;)
> 
> What's the process of retiring API calls? Add deprecated in the doc? Add warnings when called? 

What is wanted here? Should a v2 of the existing cxl_port_get_dport...
be replaced with a v2 that can differentiate btw memdev not probed vs
NULL for dport not found.

I see example of v2 APIs in ndctl/ndctl lib, so doable, but first need
to define what is wanted.

> 
> > 
> > --Alison
> > 
> > 
> >>
> >> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> >> ---
> >>  cxl/lib/libcxl.c   | 31 +++++++++++++++++++++++++++++++
> >>  cxl/lib/libcxl.sym |  5 +++++
> >>  cxl/libcxl.h       |  3 +++
> >>  cxl/port.c         |  2 +-
> >>  4 files changed, 40 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> >> index 5d97023377ec..cafde1cee4e8 100644
> >> --- a/cxl/lib/libcxl.c
> >> +++ b/cxl/lib/libcxl.c
> >> @@ -2024,6 +2024,37 @@ CXL_EXPORT int cxl_memdev_nvdimm_bridge_active(struct cxl_memdev *memdev)
> >>  	return is_enabled(path);
> >>  }
> >>  
> >> +CXL_EXPORT bool cxl_memdev_is_port_ancestor(struct cxl_memdev *memdev,
> >> +					    struct cxl_port *port)
> >> +{
> >> +	const char *uport = cxl_port_get_host(port);
> >> +	const char *start = "devices";
> >> +	const char *pstr = "platform";
> >> +	char *host, *pos;
> >> +
> >> +	host = strdup(memdev->host_path);
> >> +	if (!host)
> >> +		return false;
> >> +
> >> +	pos = strstr(host, start);
> >> +	pos += strlen(start) + 1;
> >> +	if (strncmp(pos, pstr, strlen(pstr)) == 0)
> >> +		pos += strlen(pstr) + 1;
> >> +	pos = strtok(pos, "/");
> >> +
> >> +	while (pos) {
> >> +		if (strcmp(pos, uport) == 0) {
> >> +			free(host);
> >> +			return true;
> >> +		}
> >> +		pos = strtok(NULL, "/");
> >> +	}
> >> +
> >> +	free(host);
> >> +
> >> +	return false;
> >> +}
> >> +
> >>  static int cxl_port_init(struct cxl_port *port, struct cxl_port *parent_port,
> >>  			 enum cxl_port_type type, struct cxl_ctx *ctx, int id,
> >>  			 const char *cxlport_base)
> >> diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
> >> index 3ad0cd06e25a..e01a676cdeb9 100644
> >> --- a/cxl/lib/libcxl.sym
> >> +++ b/cxl/lib/libcxl.sym
> >> @@ -295,3 +295,8 @@ global:
> >>  	cxl_fwctl_get_major;
> >>  	cxl_fwctl_get_minor;
> >>  } LIBECXL_8;
> >> +
> >> +LIBCXL_10 {
> >> +global:
> >> +	cxl_memdev_is_port_ancestor;
> >> +} LIBCXL_9;
> >> diff --git a/cxl/libcxl.h b/cxl/libcxl.h
> >> index 54d97d7bb501..54bc025b121d 100644
> >> --- a/cxl/libcxl.h
> >> +++ b/cxl/libcxl.h
> >> @@ -179,6 +179,9 @@ bool cxl_dport_maps_memdev(struct cxl_dport *dport, struct cxl_memdev *memdev);
> >>  struct cxl_dport *cxl_port_get_dport_by_memdev(struct cxl_port *port,
> >>  					       struct cxl_memdev *memdev);
> >>  
> >> +bool cxl_memdev_is_port_ancestor(struct cxl_memdev *memdev,
> >> +				 struct cxl_port *port);
> >> +
> >>  #define cxl_dport_foreach(port, dport)                                         \
> >>  	for (dport = cxl_dport_get_first(port); dport != NULL;                 \
> >>  	     dport = cxl_dport_get_next(dport))
> >> diff --git a/cxl/port.c b/cxl/port.c
> >> index 89f3916d85aa..c951c0c771e8 100644
> >> --- a/cxl/port.c
> >> +++ b/cxl/port.c
> >> @@ -102,7 +102,7 @@ static int action_enable(struct cxl_port *port)
> >>  		return rc;
> >>  
> >>  	cxl_memdev_foreach(ctx, memdev)
> >> -		if (cxl_port_get_dport_by_memdev(port, memdev))
> >> +		if (cxl_memdev_is_port_ancestor(memdev, port))
> >>  			cxl_memdev_enable(memdev);
> >>  	return 0;
> >>  }
> >>
> >> base-commit: 74b9e411bf13e87df39a517d10143fafa7e2ea92
> >> -- 
> >> 2.49.0
> >>
> >>
> 
