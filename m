Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 256C536A018
	for <nvdimm@lists.linux.dev>; Wed, 11 Feb 2026 21:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770843959; cv=fail; b=rJt/5F9XTggFbYyfqSp9d9iFE9HPwK8pRSPN6CzAguXt1ndQ+pl37sZwmfb2L8pfkkGQ2IKJHCOEccIqcgPKZLkFJkXzBcBp04FkOzTs2GUEP24Sf5LLddvuzmsLI/t/QA7Fl8BZu/UvBmBJqoGeiL6a+Zoq3eJ1k8kW2WAXKXs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770843959; c=relaxed/simple;
	bh=/THtQFm/pgGPMibwPbpqoIfe6JWF+g1M+7XYr3yqFsU=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=rOiSsQIqBQ8f1+UyqGA8ErWAXcJIGGNaREBhDvIkeYlO6gxVltKGN+zu1fLyPQxKixGVlFoGL62dMRylNViVYD9gqR1NpR8M+7EflhffdeKnAZq4/N9KAegaRvjz9aR5LXFlFNUDoYJ8KZuqZY7N27x9FHeWgHY1tosxFZNgXxo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W52tu5zS; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W52tu5zS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770843957; x=1802379957;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=/THtQFm/pgGPMibwPbpqoIfe6JWF+g1M+7XYr3yqFsU=;
  b=W52tu5zSkeAma6CocbpYXbRdHj4cujzH70XlP3hKLcZe7luCHgULB8gP
   0Myv/LospX7XMkpBSMmrv+6eCt8WIkpKEGepg2HnChRysf1SPk7Cd0act
   8TTvyZZDTde+jWBnmtQn3R6Y79dFvMM/Ol5N9XeJ3G5i1TOHQ/VK1e2Js
   w2Yc2f4QcuZn+q2lRtg9ck9NaO3RvdE4p9YbUxK/aoObA6BaPdZAvIrc4
   yWLdvOmKZgVDH3PyDotGglfT4/6DUJdhBwP830er/+z2GOS4O8hoK8gbh
   osw522oJlkNKLSUzIzelFlT0N+WynqVjyKi/qDlgZYXZVK8KV7E8G96EM
   A==;
X-CSE-ConnectionGUID: W+C9WMkDSReO9tNjn1Jt+Q==
X-CSE-MsgGUID: Opn4xE24RVehsdIJ5CBM1g==
X-IronPort-AV: E=McAfee;i="6800,10657,11698"; a="72072725"
X-IronPort-AV: E=Sophos;i="6.21,285,1763452800"; 
   d="scan'208";a="72072725"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2026 13:05:56 -0800
X-CSE-ConnectionGUID: EZo62We/STaJ7ZK7pMRLRg==
X-CSE-MsgGUID: Qpsw6P/QThajjeLGcrXzoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,285,1763452800"; 
   d="scan'208";a="216861430"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2026 13:05:56 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 11 Feb 2026 13:05:55 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 11 Feb 2026 13:05:55 -0800
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.34) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 11 Feb 2026 13:05:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ovsnL3RcA+tYwUN1LgyW0rJoVR4rushSts3Z5Xe+hUh79zCjWapqIeTWbA2jOVwJ6Wu0ML6b97wMgo9cgCy97OePmCLUHSGVDDHb2+phLUqadSyav6YkcH/2bMAWDX+IiQYat2s/bVFoAoMv/PUBHJNDCPTuDTFkZ0l2IWta7na2COKxb7BxOtju3adrRUxYUzK1SSlrCYNdUjbpyX9jpeG/KOVgjHifE3acNSGD06QSgJjVfksjwaUdviZnC86bQxL3h7BFGNHyz1GV/9COusWDGChLVdhel5VQnX3Wv3pRcRd6Xk/VlXG7i/0SDnKPrlnXP1u/OYEiIEa/n7S/oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7rwx/UXpvFd0tpFRxbqAglkJrv21VJNx4eNN0hqG9R4=;
 b=iwZrsRTJtHnUxkYBSYrIsuMeeuu8Uo9ztOoNHp5nEosx+ATRdwwwNQepF5eckP79Eyquo7JUKerP87W5DGnYId+qI2mFnQ+0rjNZHdm2+xmMsNrRTdsEyhPKkceWMVjybBEn1CXZaIXPMPxUzwitGUuvM2pEiqHOYUbJHwlyFqVueR744cZkrfTVyiAXrBT3M7KpKfLSJxHDPeQRARWnf3YjDV9k7A6dvZmSkDoE9BIaBf4DpwAph0Czf5o8fh7l69tz72/gfhPWnqQP5bkvTtzQ1X7XTs7qzLvAQUB1z09s17syl8cmScHPu0qQet9oM/QmsoULfJidEifJ/dAGiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by BL1PR11MB5955.namprd11.prod.outlook.com
 (2603:10b6:208:386::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.15; Wed, 11 Feb
 2026 21:05:52 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::1340:c8fe:cf51:9aa2]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::1340:c8fe:cf51:9aa2%2]) with mapi id 15.20.9587.017; Wed, 11 Feb 2026
 21:05:52 +0000
Date: Wed, 11 Feb 2026 15:09:16 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <nvdimm@lists.linux.dev>, Davidlohr Bueso
	<dave@stgolabs.net>, "Jiang, Dave" <dave.jiang@intel.com>, Li Chen
	<me@linux.beauty>, Pankaj Gupta <pankaj.gupta.linux@gmail.com>, "Michael S.
 Tsirkin" <mst@redhat.com>
Subject: [GIT PULL] NVDIMM and DAX for 7.0
Message-ID: <698ceffc62269_10ad1610081@iweiny-mobl.notmuch>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SJ0PR03CA0214.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::9) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|BL1PR11MB5955:EE_
X-MS-Office365-Filtering-Correlation-Id: 4287ea39-2990-4b18-82dd-08de69b156e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?ULtNkAxQndDl/XMiMfphOlxmFKVng5zvf/MpuJYGa6QY2jV0L/jDsw3DfsPW?=
 =?us-ascii?Q?WQf9zB0j5YG5WnUj6rXQqrXS664KlEILXHounMN96oEkm98ojhEfEo9Sqstr?=
 =?us-ascii?Q?7SvKBEEBxVuKZbzjuoxx9sGeMu24XTFpkrmOeZGLVl+cu3SEL+36yNv8V5IO?=
 =?us-ascii?Q?cwNDxYGAT95zkzpFGXqeRaUNWWH+w+QMMM2tTdnd+q+X+ROJlXZyLqnlS75W?=
 =?us-ascii?Q?i9AV0LY3VCoGuxRnoVP+JXDuNYSJKlXroiFa/pIkdLcaYZjdfohAc0FtzT1x?=
 =?us-ascii?Q?tbgXqQ8tv46PvNrxICYCvcLS35LpLYA8RSVhLBrbCkGmWAngfHK9jb0BFJ6o?=
 =?us-ascii?Q?swqQLSF6Fxd8DAk/OUXmG8MWygRWfOVIGcacG55fc7I7yPfgpFmPX874lbjC?=
 =?us-ascii?Q?BhETgrCdJxtYqlc5L3hnIkKEcFCCj7i5NSrbbrn/9c3qM07cC3cn+lWO3UmL?=
 =?us-ascii?Q?XxIri9FlFhRyA63Crac/ODnOD46fXQb4iZ2ya0OQZ7WepWoy3P9C4ce89JbR?=
 =?us-ascii?Q?5pZX4D4x4wFVDIymoQimlQ248MypzVdqpRzALS87oetlE0MURjXe8PCUuLTw?=
 =?us-ascii?Q?bTz2e+1zMWq5rL2PhFbrc/86vPF79IC3cOK5vyZmHdtV48D6yngiz70KMgpP?=
 =?us-ascii?Q?+LZjHDcUXuzDYn2JeH10LGOyCv4qfQlR6h66DiL3wqOmmqjRIh+Y5p/g7kMM?=
 =?us-ascii?Q?HBFmWtp+kOQU1v3SGFtBQfgJsCGnoIqZAsz9uR+UbogDvG2ROT4VXk7KpVpB?=
 =?us-ascii?Q?s3ebBMRFFczGFj8U1C0ACrTMhErO9pXLK6Ip2Ueed8rodGPjN6WYRh2u0mfD?=
 =?us-ascii?Q?VyI1hpmBofprayZgwf963bDXJfpxy7GdBeSAtHJkxNOYYiEczx5OgmbrnuZD?=
 =?us-ascii?Q?ZWCGCE8Rzw+MqpIIDQmb0o2HVu6KKQnjKMIfJYNk3XUIHWlCc7cr7dvLetg+?=
 =?us-ascii?Q?x1d5VdtI0+YbUHbpQdkSzi9x9TOU2y7CPZzDX8nJ1V8weTgQ8bXWuEeoX43H?=
 =?us-ascii?Q?n+s4w5nBIX8fEZhO4n5HHk7SDhVIYJq4A8BN4Qo4L3pq1HZ9vRTBwKH31rQJ?=
 =?us-ascii?Q?1CI+a5vFL8TaUld1qPj3LpkSVaHoGAxdwWEszgnj098mIrj4A/ZVoociBp2I?=
 =?us-ascii?Q?b+XM/yRRunt+Vy0oFR2W8hYtTKucXHfghFhCRHzhzSHJ+hD7pQp+17Cn0qW6?=
 =?us-ascii?Q?+THQsveY+CQossz/jVbij2O94Ytw79llCF9XEY8hrwrQ2oOmLL/sU3KtmaKL?=
 =?us-ascii?Q?nb+H1s4NFgSCVshz62oeCVOC1bt/mp1dJgOZTsm+fPfZT/E63akvvNydvUwI?=
 =?us-ascii?Q?q6sx5kyQ3Xtv8ccNCCF8eM9fPyTWO82YQJciybAVinaDLXcxtjj4aJblQE1H?=
 =?us-ascii?Q?UVSuGTwA+5uiyyKHSqKFGUfQ6tJEpAEgD5mD5XEqNlp3IIjgmW1xA/x4FE62?=
 =?us-ascii?Q?sbDcTOoMi9AnB9SA7VM6sXgBKqbYAFaA2hlVZmR8RCIzE5vbL/UhthLERtRf?=
 =?us-ascii?Q?MtVUJyqEJl/vAiPtdb/YD8WWLuBUwJK5QlxeSidEMC5XciQGfd7F0UTcfPGb?=
 =?us-ascii?Q?xd5vC2gpIkneyG2nPRs=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?apxncGIhIWdA9d6uNna1EPjXjkwOr/Qc9rM1bx/nAYbTyEFtaObIHJtPGie4?=
 =?us-ascii?Q?a6SFQq2zpQz3005mEmBctY0ue9A5FfPGgYu3dJObQxzIwLY21yg10SQ1QLUe?=
 =?us-ascii?Q?wfdV4uFhdWJZltv4mxGv5v2Pijjz+KReZoirZqrn0Tdtsjg2XI6aN7XIEHYC?=
 =?us-ascii?Q?g9ceOClbMlm5e4MYtIBKGDnwmMO3seFty1Fbe6by44g2/kQCKCeNUJQAUTLj?=
 =?us-ascii?Q?KW3TCr4g8qT8IScxDmNovWhffA1wXVpoRn4GR74KG0jCxm6OimS1f9otlMK7?=
 =?us-ascii?Q?M+hYu5BzjbTSL7zc3ygzBwnTr7esJgvNFIQz84iuwtCUnePgL0bSZdkBB9M2?=
 =?us-ascii?Q?GSIwn5U+DYjsjnAAddQmG2rjHCGP3V4NiT4qdJRynzpqNn5f5M5pnGVQ5DAv?=
 =?us-ascii?Q?aPKn130oOAL3bUlZXZNE++G3/yIYa+zEJ2KOm2kY0+7MaRLKzp04cRyyhiK3?=
 =?us-ascii?Q?uMiKSF2W7ktkLmJIsV5W7gpwbDThmxnt3jNBVJx42CWdaspFi8yiYVus8+AT?=
 =?us-ascii?Q?m7GeR3TDjZA+1npHVdYiRW2/eLGb6PKhWHBbl2MSqc2AWepv+wW1jq4I0/MP?=
 =?us-ascii?Q?23Xeqf9GmKdMeZGy+yJLi3yT130A5lwMBPVqKWWhpy70SNHxmyJ5TMgt6z4T?=
 =?us-ascii?Q?Goxti+f8s0FsFaGnnbjqgQ+UMM+jHjLStQzF8Us0n7Ze7JhFALZrr+J82Q+U?=
 =?us-ascii?Q?rV7V2uwgXO5Pzl6PvTbmhIqnbLiY2D1aIIZmJOJR2k1OYi5HnsM+aQ741CoV?=
 =?us-ascii?Q?xg/9qRWpaZEDmdvhGyTMzGbsnBuJwKfSwIXkMBaoo1iSJ6/E+I44OqejMS15?=
 =?us-ascii?Q?RDfrzGwEGtpMDxvzQ9LQkjWF47kMY1fmjaR0sm1SjpVaBGN2PMa60kQVkixi?=
 =?us-ascii?Q?2Y718w74RWN2mFqYMLWH30kmLWYqggaLmt4ihjICmbLqAw1AQSiD1stlEWTV?=
 =?us-ascii?Q?zN8aaV6DjV1Fa41g4AcWI2cofjecaM1UiE0mxKm9yNKcaX9Nqo4lLsujnUTR?=
 =?us-ascii?Q?EQFuV4e/o54nc4CCBEi2lfc796S7sv8N2JYhV/9sL32T809UiT/QFIzVFVLP?=
 =?us-ascii?Q?2SU1fYJk2p+wNf4LXMzYumbHURyclscuXoBWl/SqE9L92cQsKjhMX6pPTvGH?=
 =?us-ascii?Q?abDK5lic3qhCMTz4LzPhJ3D5jVxMDfVXZ/T+KohCCNo3rnPY8IukkZkghRrH?=
 =?us-ascii?Q?3S3vddv/hdRe085Ad/sl8nwhWC2S4L0VIC8ibERXCm1cYfGDx5FTthS43CmG?=
 =?us-ascii?Q?cQSkpZ8U3sAfmgK84yyldILJterFgD9JLkb//ZhBj8vC9goyt28iWHBd68Zy?=
 =?us-ascii?Q?HLAPVkErOAB1vkyOhsrnnh8LP6pfXwhelWP2c3eQG89k7YaJ02A8Mu4MIK/l?=
 =?us-ascii?Q?5UGTEceO4kRHmrWOKskQs6bmGmlrFZaG8hLSaBjnjLh+FDNxaweZPD5Xo6JF?=
 =?us-ascii?Q?6iItrW0eXb7Ej8Sf3ZNWzKLfeUFhLClq2rPbOgVdj/c5Fq58X4zewVLL1iJT?=
 =?us-ascii?Q?0crA2nBRHlDfGqraZZftXogHkZFhX0w7gSiIm8IbHXb6CkRQYxyoBurSNtk9?=
 =?us-ascii?Q?zOa3UF4Ay6MXQFdEETTWOnBMfqlB+2p1cRnUjh16XJehgevQ7hY5Q4RTgWut?=
 =?us-ascii?Q?iOOn7H2bvt+d8KV5UFrEFMBlrPfh9bkEZNSxpH9uFvr/m3hArFNTYjQssgJV?=
 =?us-ascii?Q?p5Ev0koaxn09+e6c/+ZdRTSXrU6/yoKv0nWLmIy3fJH8qg8KnbzCOScB3dAR?=
 =?us-ascii?Q?B+dDfpWJWQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4287ea39-2990-4b18-82dd-08de69b156e4
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2026 21:05:52.3699
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +JBMLw1B+zLBXPKe/G6RGc0kkDl8oWqJjUNC7OFdVpkli4PZD++NL/BD6nD8/w5CgUQgA/wfUwEDvwpA9I5TvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5955
X-OriginatorOrg: intel.com

Linus,

Pleas pull from...

  git@gitolite.kernel.org:pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-for-7.0

... to get changes for 7.0 for the nvdimm tree.

There is a kmap conversion and a bug fix this go around.  The bug fix was only
reported in the last rc so it got added here.

These have soaked in linux-next for a week without issues.

Thank you,
Ira Weiny

---
The following changes since commit 63804fed149a6750ffd28610c5c1c98cce6bd377:

  Linux 6.19-rc7 (2026-01-25 14:11:24 -0800)

are available in the Git repository at:

  git@gitolite.kernel.org:pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-for-7.0

for you to fetch changes up to a9ba6733c7f1096c4506bf4e34a546e07242df74:

  nvdimm: virtio_pmem: serialize flush requests (2026-02-04 13:16:40 -0600)

----------------------------------------------------------------
Updates for the 7.0 release

	* nvdimm: virtio_pmem: serialize flush requests
	* drivers/nvdimm: Use local kmaps

----------------------------------------------------------------
Davidlohr Bueso (1):
      drivers/nvdimm: Use local kmaps

Li Chen (1):
      nvdimm: virtio_pmem: serialize flush requests

 drivers/nvdimm/btt.c         | 12 ++++++------
 drivers/nvdimm/nd_virtio.c   |  3 ++-
 drivers/nvdimm/pmem.c        |  8 ++++----
 drivers/nvdimm/virtio_pmem.c |  1 +
 drivers/nvdimm/virtio_pmem.h |  4 ++++
 5 files changed, 17 insertions(+), 11 deletions(-)
