Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3FB72C11D7
	for <nvdimm@lists.linux.dev>; Wed, 21 Jan 2026 00:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768956206; cv=fail; b=bEeGUutq7KhTyhLWbzIDP3vg5DWsDI4NhtN/1owUIl8xnSAe20EQr+0gaC9w8sDKu6EMJuaeAYbbuWL0PCOPHXnfF0t0yZAHoMcMqzCa+/3LM6Xi5cL5pl5Xd8JvrP+DGXQHZtE2x5wxIPMy6SvqVd5CiCHdRWrazW9CtLPvAn8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768956206; c=relaxed/simple;
	bh=jDSw90oetp1dVHWUuTAUenT9VOHjz1lxJFLeO7yNmTs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Cj4Cjkl+ae0lCIh3I303MUEugQciSdsvqiXi7CHUPORFIAVhKehEVQKHfJ6+6yC9qKzUFXeaqho/uR1rdtFeuaAXIdIupMvnZcxE5WyUMYm7wFP5UW+6P9i7zkl1pDtPXzHiVzsNBpNwtO7WIrsE3AUk/I8dwGkaJDarnrg2sC0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RAdZXmmT; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RAdZXmmT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768956206; x=1800492206;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=jDSw90oetp1dVHWUuTAUenT9VOHjz1lxJFLeO7yNmTs=;
  b=RAdZXmmT/5iaZmuqbb/cfQv3zfHkRyEqclX94eHcowF3iS5JcJb3o1A/
   juACixclKyqDeQm6iN875UUNE7+UWTZ5WIMmHgyfIM1obKkWOxLenipLw
   JY3PPu8WPvcbRhqlxBtOkgVI2ZGUxOIzdZJnVV0ohY0s+Dq/6UoJbn9k8
   4mP4QHFhgAaWh6TWwBQoQIhJw9odBPdVAsQg6cOhRTVFVmoIPpPO+5ePE
   NL2uWCfu0SC6JpMBjzkP5xWX47nVfnJuxEMFsy7lBb4KFI4QzehMiI3A9
   QgMbzZsagDhB4iSYCs0iVF4Kvr34R+CJruAawrKafwAnHtqia4CO6JLje
   A==;
X-CSE-ConnectionGUID: kYbRCIokSBykY5fJ8JVldA==
X-CSE-MsgGUID: bcdT3aovQzm0mmbQop+NPw==
X-IronPort-AV: E=McAfee;i="6800,10657,11677"; a="70151771"
X-IronPort-AV: E=Sophos;i="6.21,242,1763452800"; 
   d="scan'208";a="70151771"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 16:43:25 -0800
X-CSE-ConnectionGUID: nU8gYzJUR3iyZzinu4fLGg==
X-CSE-MsgGUID: bOA6009gTR+N8mIML5oKWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,242,1763452800"; 
   d="scan'208";a="205408144"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 16:43:24 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 20 Jan 2026 16:43:23 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 20 Jan 2026 16:43:23 -0800
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.56) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 20 Jan 2026 16:43:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JpeIZPCf/vV28VjxQKVHQ7CJz0TY1UO+c+glej4k2ETCrvaGaL70v2ytWSQxJx+lA2sVsc0v8Vz0ziyWc344RHsfH/Mk3qD/rEDOOoXHJT8NWnJfBqll/p8sN6r6QzutdoSShmaLWcHko92h1Z4/9rdxMuKSqVqJ7kwhmPv68FW7LIU2vC0bmfwoA+hxG/wH1cls/f6A4ippOlW0iQS6w39z4nbGbHlw2zfTCQVUpeX05Pt/yKN/12WoBQ+bQ1ZQ2vXGV3wOqLaz7livnRQuMhhjO6l0YPKYj7/RuL2hscLZDaTsOoYlyy5LmMBsHvEqwnivekkm+NRPk1QJ4LUHLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FNd6OUr+WJbCMjNyoeQFBe19i9iVJDjD8ZmYBE/+y2s=;
 b=nmYZNyczFMZGMdXvb9073dAAULjXMMHshYay10R4Nv1kuX6KspNV32caLkC4CTe/qwx8hTFUEN7TRCmDZUr8OEravqR5ms488/ZsFrP8HM3+L4brUWByNZecavzq8rJvJ5uq7Z5HIHipofcUk3Fg1rU0dGoAS9MSZC+NEz0RU9fZrDPuVBTjT4wwJoQYQiOz6LFTWCn7xc4lV1Y9BwYdf4weJorbFrwwKniOthGXdiKi91ES9ZHAlzjknAEUM0uU341iY/N0cPzjbgCn8QERuuxwnhPz8WaacDdI1D4fNQPCXAUsT+Lz65b8cX7Jg3R3QpcxWhySudLh5k+MVYVhxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA4PR11MB9131.namprd11.prod.outlook.com (2603:10b6:208:55c::11)
 by CY8PR11MB7946.namprd11.prod.outlook.com (2603:10b6:930:7e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Wed, 21 Jan
 2026 00:43:20 +0000
Received: from IA4PR11MB9131.namprd11.prod.outlook.com
 ([fe80::7187:92a3:991:56e2]) by IA4PR11MB9131.namprd11.prod.outlook.com
 ([fe80::7187:92a3:991:56e2%5]) with mapi id 15.20.9520.011; Wed, 21 Jan 2026
 00:43:20 +0000
Date: Tue, 20 Jan 2026 18:46:25 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Neeraj Kumar <s.neeraj@samsung.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<gost.dev@samsung.com>
CC: <a.manzanares@samsung.com>, <vishak.g@samsung.com>,
	<neeraj.kernel@gmail.com>, Neeraj Kumar <s.neeraj@samsung.com>
Subject: Re: [PATCH V5 09/17] nvdimm/label: Export routine to fetch region
 information
Message-ID: <697021e1bdbd5_1a50d4100d9@iweiny-mobl.notmuch>
References: <20260109124437.4025893-1-s.neeraj@samsung.com>
 <CGME20260109124522epcas5p2ecae638cbd3211d7bdbecacba4ff89f3@epcas5p2.samsung.com>
 <20260109124437.4025893-10-s.neeraj@samsung.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260109124437.4025893-10-s.neeraj@samsung.com>
X-ClientProxiedBy: BYAPR11CA0098.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::39) To IA4PR11MB9131.namprd11.prod.outlook.com
 (2603:10b6:208:55c::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA4PR11MB9131:EE_|CY8PR11MB7946:EE_
X-MS-Office365-Filtering-Correlation-Id: db6a3b0e-3c9d-4bcd-84be-08de588612db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?7B7c6hzxOhCu2/mxCS26TmPIkX2xyRPvzSLO8N5cTnNvrVnNSfhL9FDVGh90?=
 =?us-ascii?Q?2rE9U/YAi467LJfzXjXdibtZyfw3pHwsc4rDyVXL+Ed9SXnExWPtAVh9cuyV?=
 =?us-ascii?Q?w/yz7X2tFwicf+1+MLMWU9AocATdO2p1ksZNyGjjLlCllgS2PfwCyJcVbiW9?=
 =?us-ascii?Q?rtZW9bG3TN//ihr2joCcuuJ7xqQTNRTj6IlmBgJWTfHrFIg7v+e5xag+8sTw?=
 =?us-ascii?Q?w51UjuVDIFv6V0leu+eVGAyLJZx0EYCj5DCnhyDcZ9sAnPHrHlKeH9S+Sngc?=
 =?us-ascii?Q?yCE2c/DBKCCotTGHBJutt2hbgqzL2+nLEhIRjd2hpq61UKQt6Ob/Spj5UMS4?=
 =?us-ascii?Q?e6139UFc+HKwsYHde1OQi9eLGehjBlHSvCMlj28SB+9pSilV06UaNrRa8+Dx?=
 =?us-ascii?Q?yx7vEfqfBVoVX0NoSzE1mDuutZh6NYt8rxcrdO4CxhGpVZw/RcQgjwjmL0SF?=
 =?us-ascii?Q?PWke4aPnXT2S9RYQFM2cgw0pvozrLh01kIAD0pmpLtBAVxsWVDQYCWzZLDFW?=
 =?us-ascii?Q?3sV6jGby6k+h+pZQ4L/lYMUrti46POw7dfxoI1laU/XN6NGbJs873PNi2ARK?=
 =?us-ascii?Q?lg8sGfIuQDoPPLuIWz+ADQqZF1ZYooeVjQSy3F9CI+6IJjWt5Yyni6z2qkLf?=
 =?us-ascii?Q?D3h9PDKbLOJTV+k2aKfXZbudtTr3D6bfKC1mnhJPknmVMM5DP+LSfU7Q1e0j?=
 =?us-ascii?Q?N/McaItqdGjmJP3wq1sN+lxL5G5hTPqwMUCaGSUM96Dig50FewTnKlb+e5lh?=
 =?us-ascii?Q?GMQlEzyvlcY0kQzzgq28JpxUaI60wNNj5YInES+SNivsG49IGoiNDqgLDQnl?=
 =?us-ascii?Q?74P2R5Cdnm0Q5ydTABg+uGkftNWiNnChttXJYEcXEgNSXxPhkXouq2k7xi/l?=
 =?us-ascii?Q?9OK1LLOtzEkGadbTriGPXdZBTYaDBa0tGpKFKyuZgdGXrFAhzhVjcaCa8sPm?=
 =?us-ascii?Q?dMxRP4PPoSxLwwpt85Sw1FQJ1lVcohkjO7hKBXCPH1ZLmtDZCaCKr/H1gOh6?=
 =?us-ascii?Q?iV6/ftvhFSw7rSrSYZvKZTQM1BCTwREEptaaRTbqpzOeqpbpwPOKNj4Rl/BN?=
 =?us-ascii?Q?X/WLrKsM36ohklpvOQO1I6wplMF/YAqqradQSQM965SFGZ3lqHef8LbVdVPg?=
 =?us-ascii?Q?zAmWjoIPmMe00lc5Vtr8UTwq8mP9vZuzfv1VjTnYwzt7bvykezbyWFUIixY5?=
 =?us-ascii?Q?TPgKZuC9z0eOlruwuOKGdhJSB+5mLCPwV74a3nadd8Qq64Tkz5qHubCMZHjT?=
 =?us-ascii?Q?5Gzp5wPtJd1dcq1Ne/TYEWGj/25eNmzPru+yMIREaK7qtLePB8v95822e1Ox?=
 =?us-ascii?Q?nuh4Mh/7kOTWCVulxP6TJYyHHJ0zlA3FHGbmDHI9Sytzjey0znoTaIVqPNVU?=
 =?us-ascii?Q?XmrWSEtO/O+YLyR92OxJsoNcq6cldvd5b+0M8vU5RTgOeRQCRQDdO/DJx8iq?=
 =?us-ascii?Q?PwTmRs1HmfIzmunKorNV/hwg1MtelBM6Fc29umXxKHupOK/00VJFI+mjfV1b?=
 =?us-ascii?Q?xOIWgphRx8MltxtTkEa6SjFuK765a9aFJr2cl7zT1CKz7UOGEQ2JmlfnFPy2?=
 =?us-ascii?Q?k5MULHtNhQGYW62dqmo=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR11MB9131.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?osNTdbL2n47CA+koxFE++DWymp57KUos2Wz+6gDYNhV1Jx4roioa3aq6MOE/?=
 =?us-ascii?Q?TQo5BAf3lk7y2vaLetKbjPNfA6+t17FDS5827jrpgqdSitw9yIVGcRmw54LT?=
 =?us-ascii?Q?hvVkKlIBUA36gVs+vk4dMTwBZSZYiUiI5PIVJxgL7vItGAgbs6JV8C+N6zVU?=
 =?us-ascii?Q?tUwnsPToILKb9x6NwWNGHzqOvX9kql00Bb9e1aXbDI2qwhEZTgqCuT95XC23?=
 =?us-ascii?Q?BZTSUVaPWN10WahPqF4/Zbp7zaYIE3zAjTvEiONOC3XJIapKyn4UuGJwmOJh?=
 =?us-ascii?Q?Jtqn31Lb1MYY+C1o0PjGkZ4bq8vY/rJwIhBFdksbOaxvO9qb3m5CIT86ql75?=
 =?us-ascii?Q?3UGJqV9N0hrjoKsR0TBJRv4iiKcqlJG8welZEkvGfKIqJtYEhqPknQmVfYUI?=
 =?us-ascii?Q?SaMpTgdk/BBiteshC0MwH0g8Ih8uXVms42hKCSKevAfaS9AxMRmtgB/nIztk?=
 =?us-ascii?Q?PO4DCA7wsgQ/nCAkiq492lbysjt5us1OdN6tRpGzod1v7CZEpk8PCydSWagE?=
 =?us-ascii?Q?+BAd6U8FO978uOkBToazIlfBQ0KSKnKEeoE24a+1bAI0lW6Fsm/ltpSzboqi?=
 =?us-ascii?Q?YP20op9MZ4J9ch8QpJVwbWmOSJ4aUE6U8+x3DtSTB5juBfDQJkyC4k2noKvH?=
 =?us-ascii?Q?KM1j9yKV1vB3Lg39gf/E4RfsDX2CWp80rxwlM7eQyb0U+XPuu/OcDq5R8KC1?=
 =?us-ascii?Q?LcJq5QwaVC/qxMjnTVxq0ajOxFcfqd8szwW0vJuu7oWu2iseq7A+wt19AsT+?=
 =?us-ascii?Q?3At2zA+sVbwHxwPEVhqK10Q0aSwzjn7NUY8Xqh0trxkE8zEehnzkNdVJPkoS?=
 =?us-ascii?Q?tTlUPB74a2uG/Ycd+u+CfxegWyyN5UvLfSSBrKrf8MouYqArx26cuff/t9t0?=
 =?us-ascii?Q?mptQY0coZeRmwtadSLzBGDiO07a7EyBHfMNEGL1zrlL01zCX4xTVK2Ndzg9E?=
 =?us-ascii?Q?paOHcIY7Nmws23xEtgelZ9jczn7/izCUqM21gj3KC0Eq4xZaU7DysuSdFJO3?=
 =?us-ascii?Q?tFttU2lTc9iMs/EAJnUzV+bQIkeYXnZT+xM7uiOeUwS6vwDFpIrpsQ9Wr6Ui?=
 =?us-ascii?Q?zPchxvlNeC/uii6FdIlLFqSjMtU+z5AxPtHUtlCrrf3v2TVFMGCY8kpE0m39?=
 =?us-ascii?Q?lvzatkSN3ALuSJNhC0FYW+Mk37SmlFLC8KHZEJH4h5V1zDBTVWlHWdrwqh9k?=
 =?us-ascii?Q?RkhRxJ0cR33OuiCmR1XadVs+/U6waa1fCG5xVUIsnROOEfTXl/+kdod/rOgf?=
 =?us-ascii?Q?lpo28P+bfUfQmKobIJK7Kj45SkvQN+thviKgGpTO9diNLD+ATVAltjcacZxg?=
 =?us-ascii?Q?l2ZWkkb6uEua7UM7iuNH94ivp/0rV0r8P30rIaPE93lOpfsFUduCrYTqEHhF?=
 =?us-ascii?Q?+wrt2DXfH3PZ/2wkR/iFK19JoilsKCqHcOQgw0hG6vwUs9LOa34uHAwS/ZN5?=
 =?us-ascii?Q?UlODXDGYBVhtya62DzXO/7IUqioUqJ2NJz4js0/z3knjvU0kC3Y3Lr6MsQnU?=
 =?us-ascii?Q?dEfQV2XA8i7VKqhOk0/HuxcDzhrbByPLakuBTEaUubvQBjPczCKdjpznxzZn?=
 =?us-ascii?Q?ODmVuXvSdZRFup3RiM10TSBVAEzRTyCD81l8Mz8j+PbiWDZyRwRih6Y9Y09u?=
 =?us-ascii?Q?womtkPCE1lOFqFXqU1LNNG8ISVW7HBkG2HryK/UUI5TPEo7LyA0NbY4zBTIA?=
 =?us-ascii?Q?08pSAhV2B/UZjcLr8dbJ8pFiEmPbzRFoKTg9fjBDoFhiY4qdYPbQxMgLS5zA?=
 =?us-ascii?Q?D69jjoyBFA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: db6a3b0e-3c9d-4bcd-84be-08de588612db
X-MS-Exchange-CrossTenant-AuthSource: IA4PR11MB9131.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 00:43:19.9511
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zNSr43VLjkmck+P3BdmDOopD+Xvjpdg7IY8ys3Ilo6gWbdFobpcgbqe/aYqsBYqTazJlgFXHRdXl/+XYV25QVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7946
X-OriginatorOrg: intel.com

Neeraj Kumar wrote:
> CXL region information preserved from the LSA needs to be exported for
> use by the CXL driver for CXL region re-creation.
> 

Some of the CXL tree patches did not apply cleanly to cxl/next.

Up to this point I ran the nvdimm tests which showed that none of this
broken existing functionality.

Will there be additional nvdimm tests for this?

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

[snip]
