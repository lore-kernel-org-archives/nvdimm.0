Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5777083C
	for <nvdimm@lists.linux.dev>; Fri, 29 Aug 2025 00:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756428359; cv=fail; b=A4UVw3rZu6QUvGSE3z1ujFNL1hiXFy30Kj8HA8uVni23oeej3X8SunjVjahn7sTnSDxqT+1ZfmNPg9C2CR1RoRjQ1PqbYciq91G2ZLcqU3vkV5lV+BTuYS/3qtxy7dygQJlvvpIQKUlbkSGAx0t0BP3nSuZdjttQq4Huw3/YTds=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756428359; c=relaxed/simple;
	bh=zmbA7d3e5WWyj/GYXUiaZdL3MNAalbvJ+XlW2cC1SSE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jfz6xwAuc3xVgeNHIATdAjbiFSsUOmKqagTFwWBd915ylrFNs8KRxlVHVZLPjK5fEPEa5CA9ntlE9oP/7gramDEkff1fXujjOrGLsiG2gHpa3c6EVCkCIJdYkgEV9tQi3ordfpw21gJmUWxIFZz/K5CcY0buv4js+UHsEaciu4s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eljtRH1S; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eljtRH1S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756428357; x=1787964357;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=zmbA7d3e5WWyj/GYXUiaZdL3MNAalbvJ+XlW2cC1SSE=;
  b=eljtRH1SUyH6+3hGt/og7R0lq9xOdl3giXUUMygQr+q4k7AcllVRkupy
   hEUfMHizIQGg1ujxZE9uO8CljImplNxN72CuAnnVhbGqjyf8jwnnmyp0X
   AeRktuzk95lQ93VrXByQPfgoEci0U9brytePmRthZe1x7+UFAjUDenIRh
   4jUvWy57F07NGu5Dzvq+9OVxoONYN6STpoX5DUni6YjZL6xeMxTxHraHY
   R7Vd5Lrbo3CPXT5bGqxR8Ben4W98HQiJyGvDzZIywSzOhsGt/pPJjLXjb
   mWCj134E++4PK9LDGcx3460xvVn8+NavE5oykefbH+V2vRk/zatxxPYl/
   w==;
X-CSE-ConnectionGUID: +cD/0y3yTLOxEBnhjkr0+Q==
X-CSE-MsgGUID: Vn9GxLSdT/mZFFwNZEdGhw==
X-IronPort-AV: E=McAfee;i="6800,10657,11536"; a="57738513"
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="57738513"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 17:45:56 -0700
X-CSE-ConnectionGUID: bdu8e8diRU65YBMoM+MV8w==
X-CSE-MsgGUID: YjISaN4tQa2z6XOyx2H4iQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="174626621"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 17:45:56 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 17:45:55 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 28 Aug 2025 17:45:55 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.75)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 17:45:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eLRIvV5zKJ95SXs/ib9FirBmnwXioVn2jSNxylI5kFIulW0gza4hseKxyvEfdsarg4NOWkOPmhMhMLjtOhlAA1pcRFk9TbWsgr98yVfslhMNIbwgiVZB3iXmA78iDTuqZFnBfc2LHmvxItjTGURxshGHpmvDZS9oHx0H7rENhkmFryzwR/agXs3PkRD2Ik5I5FQ94nMgINGiJZDehwtgq2rOE3TYGr7A+K3qbZeIsFqHC0PQnmOhIJv/l4tvyyBVpTSacXHqWM5xugUwiOCc878a6zmCoqS0Aoc2KaxsszONw0BBKLoe6u/wlQf8XTMeTs4VJTa/KUMu2mFA9W61ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k+9ILtX8tL3hpDeGUW0t8K2KJEefr91ZxTlfGpWbJ/U=;
 b=wLTaUrAcmmaqFy1UnJjfXRAMAoe65RDLS2eilGmQWNWCpvsfC1gxaIZkDR9LL0QMCt0ki5R5iUD01eUQg/wJI30aLJqeI7qf4MffQTUTUNEpkCjM+sAFEVdZL9CB3qpPsCPpHxYTQKfNDa/NlGsoXdNcxv2fnCnJwB5VVZ0pcdEwHhe8Tc3SMRWCnhtADe1EWA+n5MlAB4LxTr2+2HNsNFnu6307NV0OpjvN2Ei+AfZ1XBLk0fh3pHKPhMF3u3zBvF1GXaO5iQjA89tZJUvj5g6aVNlksJka7xxJN1tF75rAKKuBRVy6/EKXXMMmen3YxjVuuRVKUUXfSSmfE9eysw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by PH0PR11MB5175.namprd11.prod.outlook.com
 (2603:10b6:510:3d::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.17; Fri, 29 Aug
 2025 00:45:44 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::bbd5:541c:86ba:3efa]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::bbd5:541c:86ba:3efa%7]) with mapi id 15.20.9052.019; Fri, 29 Aug 2025
 00:45:43 +0000
Date: Thu, 28 Aug 2025 19:47:31 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Mike Rapoport <rppt@kernel.org>, Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, "Vishal
 Verma" <vishal.l.verma@intel.com>, Michal Clapinski <mclapinski@google.com>
CC: <jane.chu@oracle.com>, Mike Rapoport <rppt@kernel.org>, Pasha Tatashin
	<pasha.tatashin@soleen.com>, Tyler Hicks <code@tyhicks.com>,
	<linux-kernel@vger.kernel.org>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH 1/1] nvdimm: allow exposing RAM carveouts as NVDIMM DIMM
 devices
Message-ID: <68b0f8a31a2b8_293b3294ae@iweiny-mobl.notmuch>
References: <20250826080430.1952982-1-rppt@kernel.org>
 <20250826080430.1952982-2-rppt@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250826080430.1952982-2-rppt@kernel.org>
X-ClientProxiedBy: MW4P221CA0016.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::21) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|PH0PR11MB5175:EE_
X-MS-Office365-Filtering-Correlation-Id: f9063487-1937-4072-773e-08dde69562c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?t+g6/MWeXYtCj1R8vO1g9YtEwQMOxhPXWbyGrdgRPUzoT3CklMtj2ugq5AOY?=
 =?us-ascii?Q?vo1ZunBPCbasqjzPypcQy9EQ2WPw/77VO0MXSRYGp8P9weYQyAcoAmxM9npp?=
 =?us-ascii?Q?jN3BbRGH6hq+0ngB9tZOG4Q6M9LEzeTqtaBs4aJ4lTSe+kITXCoyaAF+EpeA?=
 =?us-ascii?Q?NESuuW6PInOQ84jSbGpBxHOSrKdrlVjtebsTIMxCsjFuP969odEj4pV/9dVN?=
 =?us-ascii?Q?E4appbfB8NdQx0eXe1Rk1BYWXBuEaI8uUJddPU+wKSsNyrcg1uv3rGOqPrf5?=
 =?us-ascii?Q?t3D3z8oRNhRThb66mLblZ/FHGp18rXCvdDyS54GQSPovEertCYyQQPoFMuXt?=
 =?us-ascii?Q?2Nqo3FFv0e7teDXau1+o22cpHNXChA3xZrnFAg+7iDzUZwsSVL/dMunnBXXk?=
 =?us-ascii?Q?9PtJ/FKeveNe19UPWPpzmHMTdEGfM034DwnEgLSl9aok5WcD4ly52b1Z6c1q?=
 =?us-ascii?Q?bcPfLa9NpetNnLq2fuPO9zXoQnyTpmxpsPlAipbv7I4uAeq34esYB/54cMUG?=
 =?us-ascii?Q?c/kbLAqkXDo+N41qSGWNtRgxKUgU62+l6Dvs0pJqp1jIcYkXMaZ6CHXuxwe2?=
 =?us-ascii?Q?XhGyVZWynq9fZ4Pu17TuNPQBtRqQhHhsRxAeq3g50squk+L+1XDiAAnJwkpl?=
 =?us-ascii?Q?9YjZvSBdFfzqmeIGQUkd5QrKzCfieiFZop/OTOtdD6xkU7Bpg+Vp5ryoo81a?=
 =?us-ascii?Q?61qAV1OZ+aNTHznZth1SlGb4lrw+L46AkbCCPw50qgv/bAiZxYgd5V+8ZOS0?=
 =?us-ascii?Q?6MyrwUHFP9/faIWQuaP6kKe0SNyEplNX9ASg4A5TZH3rg1XXKSq6lfTU66Wf?=
 =?us-ascii?Q?wjIFam8SO2v0WSF+hRETJpL+aC9aTtPuuKLasB1LixbV8jL+mzIukm5vPvl+?=
 =?us-ascii?Q?WuOzkE8gGUAX91Al6IvlQww+DTxo5lV6+HZFlRqKvPWaX9flf2AodjB82HVl?=
 =?us-ascii?Q?lgvjetzuZa0vmFDKLqJsGqyY+xVgoMpMvEFdGHrkxrdhfqeVHmIi9TokQeuV?=
 =?us-ascii?Q?Pk0qhPaeOm2VfAjoWiCKIbLjl9KJCug31DKAuz1BDKaDUs9WrmcAW9Y/1VDT?=
 =?us-ascii?Q?sL7AlBYjcMvWXIwJcaYf9pqOI9mAzqn7agu3Xtvh5++MKWF3SCY9Lgi9cO6U?=
 =?us-ascii?Q?DY3rlmgizHdj48h+sujpMkW96xxdM89mt1towS+K64IcJL1fkOflHdWXw06r?=
 =?us-ascii?Q?zgLTumkD7v3Ylr1NSVLd/V6BSUZ1kTBeHuf0BVqTn5tZQAfDE5fi/pSAH5j7?=
 =?us-ascii?Q?/ytI8N/LWDfvsjq0KL3ch7qLbPlnuIX6BdGpU2sxH51A32DCVW1HqlpMmchm?=
 =?us-ascii?Q?qPdfBFrc9d12OZiTaCgaFZ0JNUfI1qoLyqTLA1N1EkMABaVmF980Fp7T1Woa?=
 =?us-ascii?Q?KeexYT5gYqC2NZ4Pq4g8tr5iCKe4BV4bbULkMrukqc7/VY5EOLFGVV8s//sU?=
 =?us-ascii?Q?q3IHimGgeIw=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dqReupXdqM+y0ljb+JwMBo8PJLcOruxfVETxvnI32wiClUGQDTbjeN+2BAgs?=
 =?us-ascii?Q?FjmnqROir66W7Z8VkyoKT1FCwpEc/dqzJx9oRTpHnVa6Q6XAADWlWW+WTnVU?=
 =?us-ascii?Q?+zL0HcgJWv9wTCuQNmBS/aGQHguwK8+gtAC+SBUMKh2yAiEsIwWqhqwQdtnr?=
 =?us-ascii?Q?ouEspVxEhXWEuhokmpAMIlnTyFcCLT7eE5IR5XV5yPoiPDjFTrvsUnVODzfV?=
 =?us-ascii?Q?zp84BQktPfkbi8n+SVpbkmw+WuEKWBQkUE5L22wTTGVgc10bO5Ef/GmrILI1?=
 =?us-ascii?Q?kOOM4Mz+17Oqi+8dMGotvT8gWReaMmfY1Y2eABweQAVINfsH0XSr8lPQnjKb?=
 =?us-ascii?Q?BpDkDQNVmfOqE0R7AvoCjtZWrCHIeCUFpxXpT4BbobnIzjR3AKTQ3mLs10+3?=
 =?us-ascii?Q?JHNR8rjBOL53mWQB7juI0MiRhb/mek5a4y7/sV6s7vRn/XAwqpq+s0tsS2sN?=
 =?us-ascii?Q?y0b+yT6KgEgVCLixhuddDM6X3XsFyB1CrubR6SX0qchAAKOWmuf8kYaa6P3P?=
 =?us-ascii?Q?m5rtJlHs9a1m/oKYukfZByxDUXj7yp4DZOkq5RWWj9g54dyEt4DZL5eHxr70?=
 =?us-ascii?Q?+fpngvj21SoHnAwsEVwmV6gC3qTXbTR+3SNtf/A7vMFKNv5Fxb+CSsNDvsXj?=
 =?us-ascii?Q?KFTC6QdeqBaKmsoAWb6g6xL7mvir0hO3+L8xoBSSwEv916MvLrOSG4xGnHZo?=
 =?us-ascii?Q?SQWVPlNEkTNZVJ5Bnixj33JzG9ZDLansMLnDxGsJQ0aCd234Gk+bnpj0cUs5?=
 =?us-ascii?Q?pBK0m5fvWTw9H2VZU8iWc5OK2pNJvQmcGHGphM5EQCCfQtj+PIR+VaJnQv7h?=
 =?us-ascii?Q?glCeUioPSCDsTBtYLqj0icVJDL8Ak2UvgV1AqswkFahFvwNnf9G2n796l4n9?=
 =?us-ascii?Q?3mqYS52GEp0i9QGURxsoq+Q14B0AcGy6yMqVPMw7xfJ0Q1Q9vMY7XxFBQmvt?=
 =?us-ascii?Q?D6yvSzNE34Co3r9K1xSiZw1TwLewno1DsdO+nMm2Bjq2lSPTsyhW91xW3JcG?=
 =?us-ascii?Q?G47TfbNxGHXKCFInItHWk/saqH8xfSYZEPm0uyWQ43CwyLHFX61b/SxtxQVb?=
 =?us-ascii?Q?k6iyhbJi+sBO1rvTLFzmfWtou1wV0XgRt9JoQdkvmMjESc+Fw9YsjL1O1yhs?=
 =?us-ascii?Q?sjdJc+mLBeOseazKzvPC0DosbYHf9hd0/yY/Gfb4Q9S5ISaAryFZwzKhCgS2?=
 =?us-ascii?Q?VxWwBWP1wyEBuieveoY5mxpEXTS077QfCtbj6p0QzaST5gTBfN5aYuwZRjCv?=
 =?us-ascii?Q?Guafc2by854iVwuR85RpZ7ZSpMDwEjqHVVbUnV6NnKxLRTFG6KhZCYVq2sRY?=
 =?us-ascii?Q?iSim+H/h3Q1sZyYUJzx262hzvpwoMWvPp1E+0IHX6ZWPF6QEnNfow0+2onB3?=
 =?us-ascii?Q?OsDT+/DEuKXyL0Nt33XVXRy+qG4JNJ2Is4lsN23PWq0xlBD9DJTlUqq5Qua5?=
 =?us-ascii?Q?EB6TpiWqcTb6noh5plSzuFlvwDLrFQ61VDGJroikd6WYt+OTckdJMFMczTv2?=
 =?us-ascii?Q?NNYjNmyFguPRS92DQTDnWWlUfR0vOLbqebLOQh+/z4bMsLvKYMQPdAlYS9dD?=
 =?us-ascii?Q?5dyXMm8JCoYzCMZL8gGlAfrV/qbg9aqsgnHp8IJTAU2GAYvpmVDIbdEGmWOi?=
 =?us-ascii?Q?bw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f9063487-1937-4072-773e-08dde69562c0
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 00:45:43.9360
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xdx6QIxPHWcJxQKmysUXQjnzeJkkFg/YXVY0D6vZgXrypijW2F2TravK5NfFDreiQ1QMXefDAjFNge0gI6QRaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5175
X-OriginatorOrg: intel.com

+ Michal

Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> There are use cases, for example virtual machine hosts, that create
> "persistent" memory regions using memmap= option on x86 or dummy
> pmem-region device tree nodes on DT based systems.
> 
> Both these options are inflexible because they create static regions and
> the layout of the "persistent" memory cannot be adjusted without reboot
> and sometimes they even require firmware update.
> 
> Add a ramdax driver that allows creation of DIMM devices on top of
> E820_TYPE_PRAM regions and devicetree pmem-region nodes.

While I recognize this driver and the e820 driver are mutually
exclusive[1][2].  I do wonder if the use cases are the same?

From a high level I don't like the idea of adding kernel parameters.  So
if this could solve Michal's problem I'm inclined to go this direction.

Ira

[1] https://lore.kernel.org/all/aExQ7nSejklEeVn0@kernel.org/
[2] https://lore.kernel.org/all/20250612114210.2786075-1-mclapinski@google.com/

> 
> The DIMMs support label space management on the "device" and provide a
> flexible way to access RAM using fsdax and devdax.
> 
> Signed-off-by: Mike Rapoport (Mircosoft) <rppt@kernel.org>
> ---
>  drivers/nvdimm/ramdax.c | 281 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 281 insertions(+)
>  create mode 100644 drivers/nvdimm/ramdax.c
> 
> diff --git a/drivers/nvdimm/ramdax.c b/drivers/nvdimm/ramdax.c
> new file mode 100644
> index 000000000000..27c5102f600c
> --- /dev/null
> +++ b/drivers/nvdimm/ramdax.c
> @@ -0,0 +1,281 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2015, Mike Rapoport, Microsoft
> + *
> + * Based on e820 pmem driver:
> + * Copyright (c) 2015, Christoph Hellwig.
> + * Copyright (c) 2015, Intel Corporation.
> + */
> +#include <linux/platform_device.h>
> +#include <linux/memory_hotplug.h>
> +#include <linux/libnvdimm.h>
> +#include <linux/module.h>
> +#include <linux/numa.h>
> +#include <linux/slab.h>
> +#include <linux/io.h>
> +#include <linux/of.h>
> +
> +#include <uapi/linux/ndctl.h>
> +
> +#define LABEL_AREA_SIZE	SZ_128K
> +
> +struct ramdax_dimm {
> +	struct nvdimm *nvdimm;
> +	void *label_area;
> +};
> +
> +static void ramdax_remove(struct platform_device *pdev)
> +{
> +	struct nvdimm_bus *nvdimm_bus = platform_get_drvdata(pdev);
> +
> +	/* FIXME: cleanup dimm and region devices */
> +
> +	nvdimm_bus_unregister(nvdimm_bus);
> +}
> +
> +static int ramdax_register_region(struct resource *res,
> +				    struct nvdimm *nvdimm,
> +				    struct nvdimm_bus *nvdimm_bus)
> +{
> +	struct nd_mapping_desc mapping;
> +	struct nd_region_desc ndr_desc;
> +	struct nd_interleave_set *nd_set;
> +	int nid = phys_to_target_node(res->start);
> +
> +	nd_set = kzalloc(sizeof(*nd_set), GFP_KERNEL);
> +	if (!nd_set)
> +		return -ENOMEM;
> +
> +	nd_set->cookie1 = 0xcafebeefcafebeef;
> +	nd_set->cookie2 = nd_set->cookie1;
> +	nd_set->altcookie = nd_set->cookie1;
> +
> +	memset(&mapping, 0, sizeof(mapping));
> +	mapping.nvdimm = nvdimm;
> +	mapping.start = 0;
> +	mapping.size = resource_size(res) - LABEL_AREA_SIZE;
> +
> +	memset(&ndr_desc, 0, sizeof(ndr_desc));
> +	ndr_desc.res = res;
> +	ndr_desc.numa_node = numa_map_to_online_node(nid);
> +	ndr_desc.target_node = nid;
> +	ndr_desc.num_mappings = 1;
> +	ndr_desc.mapping = &mapping;
> +	ndr_desc.nd_set = nd_set;
> +
> +	if (!nvdimm_pmem_region_create(nvdimm_bus, &ndr_desc))
> +		goto err_free_nd_set;
> +
> +	return 0;
> +
> +err_free_nd_set:
> +	kfree(nd_set);
> +	return -ENXIO;
> +}
> +
> +static int ramdax_register_dimm(struct resource *res, void *data)
> +{
> +	resource_size_t start = res->start;
> +	resource_size_t size = resource_size(res);
> +	unsigned long flags = 0, cmd_mask = 0;
> +	struct nvdimm_bus *nvdimm_bus = data;
> +	struct ramdax_dimm *dimm;
> +	int err;
> +
> +	dimm = kzalloc(sizeof(*dimm), GFP_KERNEL);
> +	if (!dimm)
> +		return -ENOMEM;
> +
> +	dimm->label_area = memremap(start + size - LABEL_AREA_SIZE,
> +				    LABEL_AREA_SIZE, MEMREMAP_WB);
> +	if (!dimm->label_area)
> +		goto err_free_dimm;
> +
> +	set_bit(NDD_LABELING, &flags);
> +	set_bit(NDD_REGISTER_SYNC, &flags);
> +	set_bit(ND_CMD_GET_CONFIG_SIZE, &cmd_mask);
> +	set_bit(ND_CMD_GET_CONFIG_DATA, &cmd_mask);
> +	set_bit(ND_CMD_SET_CONFIG_DATA, &cmd_mask);
> +	dimm->nvdimm = nvdimm_create(nvdimm_bus, dimm,
> +				     /* dimm_attribute_groups */ NULL,
> +				     flags, cmd_mask, 0, NULL);
> +	if (!dimm->nvdimm) {
> +		err = -ENOMEM;
> +		goto err_unmap_label;
> +	}
> +
> +	err = ramdax_register_region(res, dimm->nvdimm, nvdimm_bus);
> +	if (err)
> +		goto err_remove_nvdimm;
> +
> +	return 0;
> +
> +err_remove_nvdimm:
> +	nvdimm_delete(dimm->nvdimm);
> +err_unmap_label:
> +	memunmap(dimm->label_area);
> +err_free_dimm:
> +	kfree(dimm);
> +	return err;
> +}
> +
> +static int ramdax_get_config_size(struct nvdimm *nvdimm, int buf_len,
> +				    struct nd_cmd_get_config_size *cmd)
> +{
> +	if (sizeof(*cmd) > buf_len)
> +		return -EINVAL;
> +
> +	*cmd = (struct nd_cmd_get_config_size){
> +		.status = 0,
> +		.config_size = LABEL_AREA_SIZE,
> +		.max_xfer = 8,
> +	};
> +
> +	return 0;
> +}
> +
> +static int ramdax_get_config_data(struct nvdimm *nvdimm, int buf_len,
> +				    struct nd_cmd_get_config_data_hdr *cmd)
> +{
> +	struct ramdax_dimm *dimm = nvdimm_provider_data(nvdimm);
> +
> +	if (sizeof(*cmd) > buf_len)
> +		return -EINVAL;
> +	if (struct_size(cmd, out_buf, cmd->in_length) > buf_len)
> +		return -EINVAL;
> +	if (cmd->in_offset + cmd->in_length > LABEL_AREA_SIZE)
> +		return -EINVAL;
> +
> +	memcpy(cmd->out_buf, dimm->label_area + cmd->in_offset, cmd->in_length);
> +
> +	return 0;
> +}
> +
> +static int ramdax_set_config_data(struct nvdimm *nvdimm, int buf_len,
> +				    struct nd_cmd_set_config_hdr *cmd)
> +{
> +	struct ramdax_dimm *dimm = nvdimm_provider_data(nvdimm);
> +
> +	if (sizeof(*cmd) > buf_len)
> +		return -EINVAL;
> +	if (struct_size(cmd, in_buf, cmd->in_length) > buf_len)
> +		return -EINVAL;
> +	if (cmd->in_offset + cmd->in_length > LABEL_AREA_SIZE)
> +		return -EINVAL;
> +
> +	memcpy(dimm->label_area + cmd->in_offset, cmd->in_buf, cmd->in_length);
> +
> +	return 0;
> +}
> +
> +static int ramdax_nvdimm_ctl(struct nvdimm *nvdimm, unsigned int cmd,
> +			       void *buf, unsigned int buf_len)
> +{
> +	unsigned long cmd_mask = nvdimm_cmd_mask(nvdimm);
> +
> +	if (!test_bit(cmd, &cmd_mask))
> +		return -ENOTTY;
> +
> +	switch (cmd) {
> +	case ND_CMD_GET_CONFIG_SIZE:
> +		return ramdax_get_config_size(nvdimm, buf_len, buf);
> +	case ND_CMD_GET_CONFIG_DATA:
> +		return ramdax_get_config_data(nvdimm, buf_len, buf);
> +	case ND_CMD_SET_CONFIG_DATA:
> +		return ramdax_set_config_data(nvdimm, buf_len, buf);
> +	default:
> +		return -ENOTTY;
> +	}
> +}
> +
> +static int ramdax_ctl(struct nvdimm_bus_descriptor *nd_desc,
> +			 struct nvdimm *nvdimm, unsigned int cmd, void *buf,
> +			 unsigned int buf_len, int *cmd_rc)
> +{
> +	/*
> +	 * No firmware response to translate, let the transport error
> +	 * code take precedence.
> +	 */
> +	*cmd_rc = 0;
> +
> +	if (!nvdimm)
> +		return -ENOTTY;
> +	return ramdax_nvdimm_ctl(nvdimm, cmd, buf, buf_len);
> +}
> +
> +static int ramdax_probe_of(struct platform_device *pdev,
> +			     struct nvdimm_bus *bus, struct device_node *np)
> +{
> +	int err;
> +
> +	for (int i = 0; i < pdev->num_resources; i++) {
> +		err = ramdax_register_dimm(&pdev->resource[i], bus);
> +		if (err)
> +			goto err_unregister;
> +	}
> +
> +	return 0;
> +
> +err_unregister:
> +	/*
> +	 * FIXME: should we unregister the dimms that were registered
> +	 * successfully
> +	 */
> +	return err;
> +}
> +
> +static int ramdax_probe(struct platform_device *pdev)
> +{
> +	static struct nvdimm_bus_descriptor nd_desc;
> +	struct device *dev = &pdev->dev;
> +	struct nvdimm_bus *nvdimm_bus;
> +	struct device_node *np;
> +	int rc = -ENXIO;
> +
> +	nd_desc.provider_name = "ramdax";
> +	nd_desc.module = THIS_MODULE;
> +	nd_desc.ndctl = ramdax_ctl;
> +	nvdimm_bus = nvdimm_bus_register(dev, &nd_desc);
> +	if (!nvdimm_bus)
> +		goto err;
> +
> +	np = dev_of_node(&pdev->dev);
> +	if (np)
> +		rc = ramdax_probe_of(pdev, nvdimm_bus, np);
> +	else
> +		rc = walk_iomem_res_desc(IORES_DESC_PERSISTENT_MEMORY_LEGACY,
> +					 IORESOURCE_MEM, 0, -1, nvdimm_bus,
> +					 ramdax_register_dimm);
> +	if (rc)
> +		goto err;
> +
> +	platform_set_drvdata(pdev, nvdimm_bus);
> +
> +	return 0;
> +err:
> +	nvdimm_bus_unregister(nvdimm_bus);
> +	return rc;
> +}
> +
> +#ifdef CONFIG_OF
> +static const struct of_device_id ramdax_of_matches[] = {
> +	{ .compatible = "pmem-region", },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, ramdax_of_matches);
> +#endif
> +
> +static struct platform_driver ramdax_driver = {
> +	.probe = ramdax_probe,
> +	.remove = ramdax_remove,
> +	.driver = {
> +		.name = "e820_pmem",
> +		.of_match_table = of_match_ptr(ramdax_of_matches),
> +	},
> +};
> +
> +module_platform_driver(ramdax_driver);
> +
> +MODULE_DESCRIPTION("NVDIMM support for e820 type-12 memory and OF pmem-region");
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Microsoft Corporation");
> -- 
> 2.50.1
> 


