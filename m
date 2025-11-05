Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6F01E0DE8
	for <nvdimm@lists.linux.dev>; Wed,  5 Nov 2025 21:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762379211; cv=fail; b=WeaAOYVMr+aWnZYZEe6CQe6COhQDsMmIAeDfGn0/+mSY7r3QicoVjWwkyljgplafWy6U5pAwWhESEWXx4m6KMbDw/c806cQ3/niUgSOcmqklW5DXrTCdkOZ7hQbRZTcMG1AKyrokQk+6wly0aPU7GCz40U4m9QI1qBXZCf7UHdI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762379211; c=relaxed/simple;
	bh=TmBZHOkaQHaPZMrlne2ko61ha9tRackC3Xs6Ntc0twc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=p3IaR4dxHtBykVdDyUUg7rLpf+GcGrFxICAnNTMDlTXsMH/uir75uOTafrqzQwVwJqzTSfRd+qyfJkolWBDYyhTuKjFMiMhUEUrS/fwas72R55wg1pK6HQQgxfUTBa0BC16k++1t1UhPAlIRS5xh2BwEPQGMZVbsS0QopvqlPUg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i31yvsLE; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i31yvsLE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762379209; x=1793915209;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=TmBZHOkaQHaPZMrlne2ko61ha9tRackC3Xs6Ntc0twc=;
  b=i31yvsLENGOUA5tcGckMPBwn1RnJ2urcxbNCIL5kXB6RBbsO0x8hFnRj
   xW9Lu47sOEpWC+eMU4tsIeUAkX24aX8IY9WVjzTgcAoisszBG0HLtuc7z
   t+Kn3/M5Yjn/hQbcN7PEf2QthRSXW7i277XHc5bKmjT4OVqBcjqHvY7Kj
   LuZVnYdfDdw9xzK+ts/EWGdYoXG9iwC3EIKXiuthZj9MbBLF02+/usxDf
   7QhS11XS1vxU3frF5AHxschnwBNKgiHapF3gtXl4YFRzW+s0KRL/8+nCm
   ZACm31ldxJON7NJHdNc+lBN21E/g+JSUzgJsIQuUCKq8LiKJ7josoFx2S
   Q==;
X-CSE-ConnectionGUID: RIPpv9x+TrCiMuBSeESwqg==
X-CSE-MsgGUID: DfxIZi4KRjaF5c0YHWD7lw==
X-IronPort-AV: E=McAfee;i="6800,10657,11604"; a="81909236"
X-IronPort-AV: E=Sophos;i="6.19,282,1754982000"; 
   d="scan'208";a="81909236"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2025 13:46:49 -0800
X-CSE-ConnectionGUID: 3ZtzAUHrRdiSvL40/JhlzA==
X-CSE-MsgGUID: ZLbFQHJNTwC9iQGbEI0o0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,282,1754982000"; 
   d="scan'208";a="188293391"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2025 13:46:49 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 5 Nov 2025 13:46:48 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 5 Nov 2025 13:46:48 -0800
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.21) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 5 Nov 2025 13:46:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r+iz6AU/4nbJSrqUu4rV4/oQCCW4wNOT+IbJIe7ZL9OklfG63BMKbydzvw22wjlOTTfzR4s+52tlC9KOV6m+/zFSJlmnKN8s4AMjnNLFh5TCOv4+/ywINi3nojP569a7bDMRgfR1NR7n4pHAUJsx06Eejat8YWe7vsJ8WHn1rqfduUCJv8guW2s6WAaJUniVb2nKUTKml3/afs0lYZXdrtBRiCd6vjHyjeEIjZpp9JXi7zbDNV7aLbVw+NsNofIm0PqfPsfc+glRaQ3rlmx/xztETen+3EVOmiaA6BWr9CCXEGTfOdFHf9TNZ/NB4GgMVol2WpR6wjM0KXGSVqvZpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6KNwe9EngCIZgPBfOFeq3TEXKGyr+csH5vrO2oE3E9c=;
 b=FQAL8NkRvRcIiyEIduN5VgABdKmMXVjR+ihAX9VrBL6Egg7um1nQ8IJqxZKnDo25MmyXmT/dzfZo17MopsuZzTUfIA9IxRt9lLVQJNsXr8nzLGkcdSKV0EZkKrhfJjuWMY4CxNzHTLTFnkzxX4k0AoAowUhRpUDfGb+5mLGFJvwwDbJgI09g3CxBbGQAcEajvIYyXtODgQuhj3fHLYT5j/C1gHGWqsIPdVAbOswCPlRpKho9A+fmMUlxXQ1cLYxXZYfQ6TEBrLiE6ZcBn4mY5KBQAr3TNEd4N05do6XvvwBUU7xehXufLrxkdVkuEKhojZwqlzhQdUFMXcSFW2sAGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by DM3PPF4C5964328.namprd11.prod.outlook.com
 (2603:10b6:f:fc00::f1e) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.8; Wed, 5 Nov
 2025 21:46:41 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::8289:cecc:ea5b:f0c]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::8289:cecc:ea5b:f0c%8]) with mapi id 15.20.9275.015; Wed, 5 Nov 2025
 21:46:41 +0000
Date: Wed, 5 Nov 2025 15:49:07 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Marco Crivellari <marco.crivellari@suse.com>,
	<linux-kernel@vger.kernel.org>, <nvdimm@lists.linux.dev>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>, Sebastian Andrzej Siewior
	<bigeasy@linutronix.de>, Marco Crivellari <marco.crivellari@suse.com>,
	"Michal Hocko" <mhocko@suse.com>, Dan Williams <dan.j.williams@intel.com>,
	"Vishal Verma" <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
	"Ira Weiny" <ira.weiny@intel.com>
Subject: Re: [PATCH] nvdimm: replace use of system_wq with system_percpu_wq
Message-ID: <690bc653488eb_28747c10011@iweiny-mobl.notmuch>
References: <20251105150826.248673-1-marco.crivellari@suse.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251105150826.248673-1-marco.crivellari@suse.com>
X-ClientProxiedBy: SJ2PR07CA0014.namprd07.prod.outlook.com
 (2603:10b6:a03:505::7) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|DM3PPF4C5964328:EE_
X-MS-Office365-Filtering-Correlation-Id: c97d0cf3-4294-4565-2db8-08de1cb4cddf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?q15g8am3ZDHQLgd1rI/Z0psnNVbmICciycq+DQV4Tha+bnEO8raLsaqG9CU+?=
 =?us-ascii?Q?4GYQlcQCREfwM6cfNkDRpuQ3Pi9W1xYLH0CxkRWDACF6nTg4ZJ526NvBKQhV?=
 =?us-ascii?Q?UExGFGAeEE25/mO3REzQRzhlRtCq69ajFDBmWlVSdZi2LH4nbuuQL8Ktqt9T?=
 =?us-ascii?Q?rKMq3Di39/u7E0OZvcuIrgACvxfGBFxt68fW5DZLR1JLqLnd1enrp+lXCbgA?=
 =?us-ascii?Q?LkOi1VmPTTXQgET/HZZQKGr+Jm0CG2OA2nsfC0FOErA8DbEeanPjQOmEu512?=
 =?us-ascii?Q?NhjxW7HwtI9dl1UXdbPqu1VEDaF0ix24jtqrz72f5jxB5+g/GvWPxzbkpNGb?=
 =?us-ascii?Q?+fMw3M5bXrWI2ADYpNqhQgjw8+5Iob47f/KGAxUkDQyFuovmv5WC4pUJzuCD?=
 =?us-ascii?Q?/oxQ3u1kedch3DEFJVMfulYMAfxVA3MChkL2/6DBTh+9I8l/+tDv/l4HBYzB?=
 =?us-ascii?Q?GT0mSvUTLNRORjDe7jnPAc/MT8btJlKLz7iRbUEmHEyZ2ajXc5/gJnkHT9Qz?=
 =?us-ascii?Q?a515zBDSYg4oLPy/bmqN/4Hla3l+HAQ94OgnRyzIJxBOg19zsRVH0W7m1RnJ?=
 =?us-ascii?Q?HpMcZuZD5r7rMTXA+D45rq0zJ1BylgBSW/khp4MpF5wTmIOLv9ztJSabtLN+?=
 =?us-ascii?Q?eegsmRp0ecSU9MAU1p0AGoXn31hD4YjyN+A70ug3DOVe5uoHM1C452npX4md?=
 =?us-ascii?Q?LlKmhbGxqfKf2Bdp+gcEgcl9O+8p3GFuYfXPo7Iu6gvEx0dagiHoKsJ9iHMO?=
 =?us-ascii?Q?J7zngePW7leOSQU+k5NubF/FdhXyeb7508AgRnbWW23OOT9ke0aWcbnd2iVV?=
 =?us-ascii?Q?NfqcS/FuIp6HKicP9fjxdOe2VhlfgT+xEt0XtXQ4yJszoIT2qm8ck7LE90uq?=
 =?us-ascii?Q?c2+CP7LzNsX/DKBEawARLX4sTMemZo48KU68/QuaHhwfxoFJ8hIqSGYtx+Ne?=
 =?us-ascii?Q?/RxyeoH5pb9xb3SvsdJ8E4kk4SDgHS9uL+6KPsQr2rnCefAtU1bk1Wi3w4c7?=
 =?us-ascii?Q?AwswS4tJFF50MNzCohokA6PTJ4OhEEMBEwlnZ0pMsyaLKe7FqRJAQumasYdo?=
 =?us-ascii?Q?s1bAkI1dWrYTNfwOjKoeBJu/wwwyZ4N71IYHMXSvrRQZSAgCcWPqHWgNM2S5?=
 =?us-ascii?Q?Pbj3/csCcqrr7XRNmjex+Q6t8okz8luk65UdV+ZDDuB8FVjg9GSIQxLJy6LZ?=
 =?us-ascii?Q?QpDt83bx4T9E3kRLbYPhoX32gJYUau/iynE3wxnTkpiVL4krAfQwa7ULbR/i?=
 =?us-ascii?Q?AJBGLQtGubSGZbbBBuNrhJq+sYk/4OvAS3hDluXK+Z4J/p5kgB8EH8PwPjjd?=
 =?us-ascii?Q?xeLOTTGimatE21H6iIfAKiJD7umZMn8bcfeFV2x8gPqqscvszz74XPG0rvR1?=
 =?us-ascii?Q?WyHP09kwAWVk3ooICcqcKfxNizM9t3rvxPu5vFs2M3Sv5TkXBAbZzvXw3J9a?=
 =?us-ascii?Q?jss0wfIn86WUha+yTJXSdsAAYP/XLZ3I?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LUW+TY+6SxfRB3PwfZ9i8kKK+JLpBdrQWlxeoM9ozsXGmqmMRKkVZE8mBRQJ?=
 =?us-ascii?Q?r5oKM9PyMQuxP1RpuXYXo3tavz7bz8W3p+GSKUfMZfXs0FZoUhFTs9YoWpV/?=
 =?us-ascii?Q?l5xT1l/0kNJS9ITWPi0BuAz9WwTgLq+bMcSfXDkVrSLLoPA4uSpVVSFfbKT4?=
 =?us-ascii?Q?f0VQt4OstOhhXI7uPtqqvwwzG7c6xf9Js8FCjIwa3q7BJPUbDQmaVrDvyrX/?=
 =?us-ascii?Q?a3T0y/vZ82h3D4L2qqFxfIKfAZ/JkPk+4rXF44hkS8fQFrmFQmEJ2MYRCzcy?=
 =?us-ascii?Q?OrEH+Z0P0laBBBltb7M0ZLuO4Vki4aL8JSm8r70RGo4nUlGHOoCQqR+9mCFs?=
 =?us-ascii?Q?K5txdK7Ldv9j+mXxYcEkEWWrUvdxC2S3eeOF3AAl2csPlBXaxnHcLyV2OZxA?=
 =?us-ascii?Q?zBv1YaYaDEDBrddt2dWntuadTEyQvlcdRhhTSd25m5sNwthg3rlgMP0hBuj0?=
 =?us-ascii?Q?YLh0T2YJTVd9X48bQnwCaUwLXzVcJ8SIQbGBp21DShN+bD9gU26ch9Vt+/YP?=
 =?us-ascii?Q?+9Rren2UvIKy1jtUrxHRdkQDAaMuL2ERcWzAf7ziA4ObumYeB0u7YZSIY22G?=
 =?us-ascii?Q?0ihxPs2HkI9YUkOcDZcRGMEtNRFzvVGF7AUBiTr+nYltHpPBeBsjliR0XHr7?=
 =?us-ascii?Q?L5cxZLLzhu6IHS+gZJmSC5OMwhL/1VHjC24Q9uyhAV5t1gQEi5cBCTqtJ49c?=
 =?us-ascii?Q?wspfYQczk4aa7nMChNXixnkNMGGCCnGQ96ZgtKwlQHGdeIUlkdVfa0nhhdYl?=
 =?us-ascii?Q?3sKYV9oz6NzxXNFmhPuTEwGQGmy8dQ4sRWKYqE7x6DK49JwT5DlPNn7YC1ei?=
 =?us-ascii?Q?3ozPgpZxut1yroC3ju3nkSfR4QtfyI8flA4Sah/ezv2h+zdfFsuZNm6NXLDA?=
 =?us-ascii?Q?Tq3L2UhDNZcX8kVFOOIeI4anFJb9vWdCqrfwV33qc4obULZdHeWO+pz8n5rJ?=
 =?us-ascii?Q?rD+MJCeOa/fjRyKA4L39+9502LKGIJ0gxeSs5XmLhPmB//OCPBkNlUx6pN56?=
 =?us-ascii?Q?BHBgH9BV5byvC5IyIAHLMFILiz/jWBi8ylg5wuVQcHBXcvWqCLTYlEGuKa9r?=
 =?us-ascii?Q?rpqwWZ6vddZPD0eSr4wsMDEBAtjZbtrVw5b1wa9WuBLwrzmrGIuhBIGkpKpB?=
 =?us-ascii?Q?G3HXtChCaxqb0sQ3tXQiMON7XrsqsqUjc+7imqWMs159mXHQhIE2D6Fkom6F?=
 =?us-ascii?Q?YYLfYbgyhxUfDCkSNFX4DxzaNejAh0jpetICMLfHPFn3UqJTnH2B5fV36O/t?=
 =?us-ascii?Q?6pWUGr2sp3Wi/mWMBvt5DpwMEWOmuzDuswz5Cp4TKX4A3yRFQRKcNWFMHdRT?=
 =?us-ascii?Q?dfZcA23emVIvWWARI8hCb7wo6P1XZ6rs+kZrsV9rDtC+NuZAAMCnOjgDEukV?=
 =?us-ascii?Q?BbtzeCIiqzR+13qA69s/YU25GwFCPrekWZ3rmx6XyU4AQ0lkBgvl/Yv74SL8?=
 =?us-ascii?Q?4Fi4KUSeaKqv1ZrNvtys/DA2xiKJZIIVsezpM2qwti8uiOiS+gDYDpILP113?=
 =?us-ascii?Q?QvIDCPS1Ut7+eXl659GCUZgaPjkCj19lWuMZlPQXUFhik4QrpUTRkJe4kZ/4?=
 =?us-ascii?Q?xLHDUofOyqBgJUqgO4VAsA/HkNfyGhSMzVUidxtR?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c97d0cf3-4294-4565-2db8-08de1cb4cddf
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2025 21:46:41.0663
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GTpU1pf39UXTgGlEnPdQOD4HdYmh+u9XtxbQqKUvvAdQDadw7AhnrZtkmZh6YwjVWNsxvUvY2dCzbd+EHqLfpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF4C5964328
X-OriginatorOrg: intel.com

Marco Crivellari wrote:
> Currently if a user enqueues a work item using schedule_delayed_work() the
> used wq is "system_wq" (per-cpu wq) while queue_delayed_work() use
> WORK_CPU_UNBOUND (used when a cpu is not specified). The same applies to
> schedule_work() that is using system_wq and queue_work(), that makes use
> again of WORK_CPU_UNBOUND.
> 
> This lack of consistency cannot be addressed without refactoring the API.
> 
> This patch continues the effort to refactor worqueue APIs, which has begun
> with the change introducing new workqueues and a new alloc_workqueue flag:
> 
> commit 128ea9f6ccfb ("workqueue: Add system_percpu_wq and system_dfl_wq")
> commit 930c2ea566af ("workqueue: Add new WQ_PERCPU flag")
> 
> Replace system_wq with system_percpu_wq, keeping the same old behavior.
> The old wq (system_wq) will be kept for a few release cycles.
> 
> Suggested-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>

Queued Thanks,

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

[snip]
