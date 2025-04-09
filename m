Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A16761D88D7
	for <nvdimm@lists.linux.dev>; Wed,  9 Apr 2025 19:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744225410; cv=fail; b=SqABuQw3VG1CYPy2G42tGyrNPutngc6HnTdoTA+Yxqr8RXd2MEj6j80o8DuzKqgXhGnmBl8DbkCjEht2ame71CNjeIuOQLgle+feVEr3pJAKT/4IRfuVvoKu0wUSpxIoEADG4gh7pVjyqZ1ZFpDYgPEXcxFl61nb5zng6NihFmU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744225410; c=relaxed/simple;
	bh=ZM/Xyh+FKsE+o/fR00gnlZKVDH8kLYhtWgE9hF8JigA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=LAlpadY+wvXfycYrAKIKHD4hxIzU2EsZrV35dGwSlMo9/XXe9AJ0LMOWM8S0Z0Yn3zz+m8lDM8eY5hqSvO5qqBm8BJzupCRDdEcDiiKZNTRr3XqBaJNfBWI7aExwno8X7jOA6wHyFrz8Ejt9w+9FjFbecB72hshEP0WFBf+LJkM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RhfjKqkI; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RhfjKqkI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744225409; x=1775761409;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ZM/Xyh+FKsE+o/fR00gnlZKVDH8kLYhtWgE9hF8JigA=;
  b=RhfjKqkIj77mSMYf4Gt5PjlxIOvOkuUSKT/7q+wWxvDQ9B9cuX8BxvIr
   bKwViKl18/ffnwdoN3CI6gKMCMsmOHK3Irq8fYIJbe/pSBMczmu3CzoyI
   6ZZYb9idYQxZ8rPSHL4Snv4eBvne6aEKaPlgZuW4q3cNSF/yZJZv61v13
   YRHOWYPwwd4i3v6N2GgnciWRdsqQU7t0ECkQ6+NbYrISuqbtE4Lcbd2mb
   6JFZlOBt3Nr4aTe/9W4+NCjc4IrQe6Nh+jJvuPbXxGP9QoZPu2Rh0+0g9
   +QyIGP9ojxhfaiGF1kqQLwOUNPDAPeyq4IpOBNO9KwzgdDNM/jFh1kMdB
   Q==;
X-CSE-ConnectionGUID: j33ceQNMSLm/M800377ybA==
X-CSE-MsgGUID: JVyxONO7RYO61rvXqduySA==
X-IronPort-AV: E=McAfee;i="6700,10204,11399"; a="45611135"
X-IronPort-AV: E=Sophos;i="6.15,201,1739865600"; 
   d="scan'208";a="45611135"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2025 12:03:28 -0700
X-CSE-ConnectionGUID: 4V0saDlCQaGtq07C2/Kepw==
X-CSE-MsgGUID: kJjKmj4UQYKJd0xBfJDCbQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,201,1739865600"; 
   d="scan'208";a="159641961"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2025 12:03:27 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 9 Apr 2025 12:03:26 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 9 Apr 2025 12:03:26 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 9 Apr 2025 12:03:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YE7pQ+33ToiIhIAn0FgyWs4kAFbt5ILUrQ7AWLPwHn68Bd9r549GKmItFkkl/4G1U2gIl8K9o/hc8sYwvnOXw4W/Y0vB858LJb57OYnJJPL1BAZoy6lKhZl+u1i183fWh7ZVvgs+Qjk/AiaqWtFVac6dUA4EQzBU40I/b1w0LkrC84a4cpiNslH2VtmQuDk1Ny7Ci10DB+6I62Xb2d72q7X8ob7LyBLLnWvh46eMAE1IMPbC6No7s3zE8YAK4zkYhpBl4l6vE/1c9ncBeFngQbx8Kf+hWuleyxVX06KOHqFGqAb4RkbggbAHTMQM7HKzB5/bAWxHhty9tcTn5Abi6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w4YAuB1C/xEImELQpbI4dA4ys5rs28/K/ht0Of5CfEQ=;
 b=NjV7WlTMq3mZDjHxlTid+oXnJxn1YD4A8EyfriJJ7GvqIf9KVW2J0Pw+/683ybE8OrzvDKMTckLtwDr4T3/fyDcCBTApsLtx1DfttQ2s/uCjqqOpHlfMRx9DG6tCgPifskHsgvW9CsMHOT/tZlTuUIpW2nv+zzgPXso+yv1U10dJHbe7YlB+ytbzC95VyJHnsf2IYVTCQixqas3k4KkbSeGrNbOnsz7GkV5A2vy7lYC7g/NZZMQp9swvkjh2UFRMv34dGywSfCGoul7BVrIfHkVQg9m+lzi1KXr+bPnY04NmGP8R2u7/KFDCkiu/Fndkn4OBfLYD/coiQu+n8WfTJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by IA4PR11MB9204.namprd11.prod.outlook.com (2603:10b6:208:56d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.22; Wed, 9 Apr
 2025 19:03:24 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%3]) with mapi id 15.20.8606.033; Wed, 9 Apr 2025
 19:03:23 +0000
Date: Wed, 9 Apr 2025 12:03:21 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: David Hildenbrand <david@redhat.com>, Alison Schofield
	<alison.schofield@intel.com>, Alistair Popple <apopple@nvidia.com>
CC: <linux-mm@kvack.org>, <nvdimm@lists.linux.dev>
Subject: Re: [BUG Report] 6.15-rc1 RIP:
 0010:__lruvec_stat_mod_folio+0x7e/0x250
Message-ID: <67f6c479d2338_71fe29477@dwillia2-xfh.jf.intel.com.notmuch>
References: <Z_W9Oeg-D9FhImf3@aschofie-mobl2.lan>
 <322e93d6-3fe2-48e9-84a9-c387cef41013@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <322e93d6-3fe2-48e9-84a9-c387cef41013@redhat.com>
X-ClientProxiedBy: MW4PR04CA0148.namprd04.prod.outlook.com
 (2603:10b6:303:84::33) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|IA4PR11MB9204:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e851f89-7ee3-4f58-6655-08dd779933ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Q7VqPUMgANyMRjXdf9ns/8IRr8tfphITT6P9OsdCNEyvaojXnhTn7lt/kJBq?=
 =?us-ascii?Q?wowQ+7qoopuX+PCnkFI9kvGig7rCD3fyyA4Eo0UrkZ4HnrEnfE32yeTSbD3L?=
 =?us-ascii?Q?IDSCbTl/JDPZgQrySWh4p86NekUm5hvg4e4KvBTruX++QgmzfeLM0BFJwOe9?=
 =?us-ascii?Q?3DSB+47bo1izNvWMvI/4BjuTXFjIqUF1N6+bWHuDg7ENf6iyuJcTruS3Firf?=
 =?us-ascii?Q?B4jW6b9tyCdQX/ETuDMJK0CYIUMLPK1fT5Ygvdj6dsodx9a5OcKdyckQ+NHS?=
 =?us-ascii?Q?WsoA2rzn3CU1i8Y2yqLH9dxR3S4ALT70GuQJQbGr/2cw7m5QM1vtoCHF+gc6?=
 =?us-ascii?Q?KSWMypqjuHU6XxUlEURmlC/K6XJ4Hbq1hckyY0R6GfIFrtbxLZOvBJqBpo1H?=
 =?us-ascii?Q?xtrtn9JrmEg0LXU2V8IyUz6bOfV+tYIWIG9oV3V1Eq2aXKxCpD7PwQ6vRg3w?=
 =?us-ascii?Q?4+yrNFJ+iC9B7dvXLDtaJU2W378tXlxx144QAEjJCbWZR4E/BplNbJfFFOhQ?=
 =?us-ascii?Q?RsRYIvdgUwh2yqei+AxEKppXfXHet40H2m6tMTBXzWJvWx4mKApKDNuETTeT?=
 =?us-ascii?Q?Bg0z82LgroSBlEQDOAOkNDd5lhTOOUv9QoVfQjmC8+1GkveMjxwtJ29dLPAl?=
 =?us-ascii?Q?2V6TJrAA5em/EWy6MHAFuEZ43MGyjIO3ozKz84bfRORJUDaPAISf20i65VW9?=
 =?us-ascii?Q?zfRvjuZ4rf2B/x49iX2AE5VK3Hy6ePQ49ZthPR311LSw6aNjmpwUjBZ073MN?=
 =?us-ascii?Q?i1HbGav4iEIXt5LJmD+peNAN3VS52AePXT3K1gV0Sh6VgFUX6IoPL0aL/6Bc?=
 =?us-ascii?Q?09ayq2lqArcRbpWUuWD2Fr5XmcADVo/WfvsHTt6fo94mHILC72mQ4tOuFD3G?=
 =?us-ascii?Q?KVQ2F/c9w4x5hcIeMiSkaHE8Vvh2sX4yJCjES6KzR+qUAH0KX5ZipnD5B0HS?=
 =?us-ascii?Q?i2OjaI7fRhGF+t2lgJh8XGGJezQMZtDqZ08U7NpnFIqg/Mn8huPCOfobhuwO?=
 =?us-ascii?Q?eQI0R0A+nT56mapgmTv3LWXp4YTC5bGj81mFJ3yu54+y4qx73xfcQNpkKh6S?=
 =?us-ascii?Q?s81SKtWvssa21SSBxz1xMAnVhepAVU02ZQmlVVixsQecyrypfbc8O78uHcBw?=
 =?us-ascii?Q?R+evWY0EOYtAH0IqPCtpBfS71knzehtwExgvGxLjKPRiV6KX5yVFeX3lwvpg?=
 =?us-ascii?Q?HgsdtZt0MqhDUYHA5507y3NLxB+Mj1XpXtc1HPVky2gclGhfUYYZw8pAEBw1?=
 =?us-ascii?Q?95j1rzSJQpU9OXNtTzf0pgKKaLbii9e8+vlYKnPhh/FcsX5kFp4urLSQdB0w?=
 =?us-ascii?Q?bg4NJjbo+bxZ9IzEa28wxi3z/dPNNL3Ro4sFAmIoMyftpLgpHodWJFuGVlrk?=
 =?us-ascii?Q?rqpgpD+NtCGNsbfJLMflIf4ZIV/+OyUIKIkGLwepwiUsMLHF8OnZm1vIH3LN?=
 =?us-ascii?Q?qVwF5d0jwf4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HbRtUjsm/BCbS+VA2kJz7ngCMqo64IbRr2B59y8d1IHWJsjAXtEAmpADLicI?=
 =?us-ascii?Q?blxxIB49uCNiBY+Z3H/zmlEWstaCQ9VpxWakK/tr973RwxnYgKAYU2r9Vo03?=
 =?us-ascii?Q?yAsBayEslldrsgMNaI1POtWrfnL6/Na70HqKT5pzWwtv8V+f4wkh1w/P4zV1?=
 =?us-ascii?Q?6Y2sy7qz73KuC9yHnDzZw/IRro+5JaXxtcrnK+QMAsmalrLHazz4jlbzZeDB?=
 =?us-ascii?Q?vyJAkj5lrgcYfCCKniNu3MJnkvpwff3ehMfht7HuS4lJVWo8QLFV1cK4dNba?=
 =?us-ascii?Q?ajvqt5OW7iC1b8w7xBbj+gXWTvTXtUJ3SPDWsUV5YxyacThJdekLfeK/WOYh?=
 =?us-ascii?Q?srZUG8jNhd3p5vcXRLbTA8fa5WWxTc9iVu3aEKL1hg8Jyq384AKCvdu50tjY?=
 =?us-ascii?Q?kjVezP3Fe2zye4MjfQgK+ItX314lZS2n0xzYghU7fvryM8qBZ0andMdSqeQ2?=
 =?us-ascii?Q?RwTZmFLMUYNJe0YFMXuJ8y5Hy/92SNNXf3xmF+ryvNKCB0B5MwQgvOxZIqbA?=
 =?us-ascii?Q?zHaQfXe+9lQjt4JeFxSg4QI6WPilHUvWB+OgTtz/jtryZ05qreYrAzpimmbs?=
 =?us-ascii?Q?VsVJ7ppIusfDCDXgY+6gvrxxHLwHd81nTOmfe0net4FogZlAjDEwDmiQX6Nu?=
 =?us-ascii?Q?5P46oiJRM93N5bcGOIkKWLHbEK/RIyVsL/fqzALWLqC6fIsN+XORjdDqM9HK?=
 =?us-ascii?Q?zV6BQz/+okRyh6d1VxWG2jjL2oWfY5jw5nIz+a0zphdAhLTQrZRIRpMo0MKz?=
 =?us-ascii?Q?obIlHg98NG2qBoeGtKGx+VLaEIhfsZUgMloTS71wezUong2CnLMgWtWa0iy6?=
 =?us-ascii?Q?50r2BZ3jMNxgTVCifDjRzMbWtMgLQW9EjyZJ9hvokYSdeANdZHeQI25jDccC?=
 =?us-ascii?Q?tdrPcJMdT7zHwMctbvAUW1cEOtBHmcibnUfXpyRTaOly9s49yUPhqpmTUN+8?=
 =?us-ascii?Q?V1+qk6xjUudLZnZ2Z6oqDoTWZ7zJh/Ncykmp1mpaIR5K86u0pFWxALqE/wcj?=
 =?us-ascii?Q?VWeg0ID4nJ36KlxW0s+QQcDLPcPO3Z2Wh+1FxZrQfijUwJNsjklsIDUKU1yz?=
 =?us-ascii?Q?OMDifwQuZKzjj/bmyCpKmkTuB9VLGtte5vB9+kvbRQpqogFSdR2HeK4NDeQV?=
 =?us-ascii?Q?giUS0EMirQxkOq09gf1HBVUeWV8lDTZUZQgotRwSQ2Gm3sgAx3WiuZPkPo1x?=
 =?us-ascii?Q?n6c+8LhqbePl9VJ6qSSEo//Qqf1B4jiZJuJrEMMVlLfPpvVt/SXNfjuXsoHm?=
 =?us-ascii?Q?E6oxPhbDRxp8+pu4QTovJ4JPl/EZtaPgofXNZ/L6vSPhzSXHuXgHYC/BsCAK?=
 =?us-ascii?Q?zGARSMVvc3CLHLszDbY8rnTQAkJJp22KAuQ7uuKHw1NGtpMJhSd7psPcOFcZ?=
 =?us-ascii?Q?VAODPjtj463WiA4aDldJBgI8GrmftohcwZHzmNkZXbT07+OgYJgkZQv4KCJe?=
 =?us-ascii?Q?JHaGl+gevYAdMAdBaDz1yUcAA4VVBupDTSRmNMAhdumQ1I76sUaW4CfOZAfL?=
 =?us-ascii?Q?rZIoz9i8qbTwx79vltmnI12ckINnKthJb0GhmONfhlu93JiuVIVPXomlTFlr?=
 =?us-ascii?Q?4U1nflT/xN83oMSkmq5fGfbY8hsLsn204d5dduuX7nIXNVPT3eaTckwegojv?=
 =?us-ascii?Q?rA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e851f89-7ee3-4f58-6655-08dd779933ae
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2025 19:03:23.8801
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vjmm/6PARI+BfvwdQpuBsgJZPEkJ2EWhQLGXowKjjRr+YS59cA7jFaPiReBsVIRkOgVZhtZEGSwTwEUEiPEq96/j1bkw4oNxR+ASSoBBUNU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9204
X-OriginatorOrg: intel.com

David Hildenbrand wrote:
[..]
> > ^ That's different:  locked|uptodate. Other page flags arriving here are
> > not locked | uptodate.
> > 
> > Git bisect says this is first bad patch (6.14 --> 6.15-rc1)
> > 4996fc547f5b ("mm: let _folio_nr_pages overlay memcg_data in first tail page")
> > 
> > Experimenting a bit with the patch, UN-defining NR_PAGES_IN_LARGE_FOLIO,
> > avoids the problem.
> > 
> > The way that patch is reusing memory in tail pages and the fact that it
> > only fails in XFS (not ext4) suggests the XFS is depending on tail pages
> > in a way that ext4 does not.
> 
> IIRC, XFS supports large folios but ext4 does not. But I don't really 
> know how that interacts with DAX (if the same thing applies). Ordinary 
> XFS large folio tests seem to work just fine, so the question is what 
> DAX-specific is happening here.

So with fsdax large-folios come from large-extents. I.e. you can have
large fsdax folios regardless of whether the filesystem supports large
folios for page-cache mappings. The dax unit tests have an easier time
getting XFS to create large extents than ext4.

> When we free large folios back to the buddy, we set "folio->_nr_pages = 
> 0", to make the "page->memcg_data" check in page_bad_reason() happy. 
> Also, just before the large folio split for ordinary large folios, we 
> set "folio->_nr_pages = 0".

Ah, yes, that is definitely missing in the fsdax case.
