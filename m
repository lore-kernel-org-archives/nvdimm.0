Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF653803FD
	for <nvdimm@lists.linux.dev>; Tue, 21 Apr 2026 19:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776799985; cv=fail; b=Q7UUdYPHUK6+Yv9lEC/lsIK9xATekLxphgdZT9wAVtbeP1ExysRhYERtXg8BSNhjj0oem92kRmsw8IFPgVUkmrVNu2SWqq+ZCFWYezfzcE3Uu4/wv+fbMbrNvngAAEc7ght7/Lf2ItgRy3NOovRecvLph0Tmg4XrprLEF4CES2Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776799985; c=relaxed/simple;
	bh=gxfrzisktGl+wV7XLS4G4ZtcvNJ0JC+gaiIOX3DAO0k=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=TcGEoqUbpfro92c/yTHZ4GsGZHMwyH/raETLI+q9vn+rTMcSKPHKMuTTm/2w6W98ZN3q0s+gIIfF/SDnw6y+6wPkXSCm7fPxR/oYqkgOLZZ72nDiL4JORV7WBgoupxdx5/tAeLKiri9Kpm4L7I+OsC/hApYGzkvi7MPa8o/+3ZY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HogsH+0U; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HogsH+0U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776799984; x=1808335984;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=gxfrzisktGl+wV7XLS4G4ZtcvNJ0JC+gaiIOX3DAO0k=;
  b=HogsH+0Utvu+YwMNke0ucRMwluxQz2Ctj/eIsNaG2g8f32OGVllPv5tu
   NMuPhyGK3U0ZGpIu77uglIH704dz0QKjvs/jq6S+c8kn4VBSRdAuSKcys
   r68Aj9YQzLJqkgPHmha9C3KoPnnN7UEE0IBvEorEspUwWkC2ONfNW+rAm
   68Rq9PGeQOUwIfKYC7SXvBd6S1SvTXe6Xppu9RRNoaOo331nfbasbaG+Z
   ffMRSAbi/Eg8DUndihYt0SVitbbBaiWMVsfr1WXNiROstFdIWJHVL92Lx
   rbJk5lZ+gmhbw2agqHhrHLb47gaP8AiBn7aoODMjxV6yBBDHPksxhNu6U
   w==;
X-CSE-ConnectionGUID: VBD22xdbSf+w8AG8SUFchw==
X-CSE-MsgGUID: A0hV7wikRvirfi6o/klyzg==
X-IronPort-AV: E=McAfee;i="6800,10657,11763"; a="77659256"
X-IronPort-AV: E=Sophos;i="6.23,192,1770624000"; 
   d="scan'208";a="77659256"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2026 12:33:02 -0700
X-CSE-ConnectionGUID: 0RkFpf9fSKyy+YEk+mSMiw==
X-CSE-MsgGUID: EWv31os0RBCrW/fe1veFoA==
X-ExtLoop1: 1
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2026 12:33:00 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 21 Apr 2026 12:32:59 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 21 Apr 2026 12:32:59 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.64) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 21 Apr 2026 12:32:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mecnpuXaX4FfVmHu1SKeodteQ7GjS05hbr4fDGP84Ay3xJuklzCH7iNRMeAnsWsXSr7J4RIsDtz44KNlcMxQrdc5JJ5CjzIMs0ZVgLe+6T5ICgISwcFUQ+SpvAI0rszObUlvAaZcQFbQ15KolDEMHWt5AjEzYPmGCyd7JUSzS5JP1vCV7sIcMagF/l1avebz0+YK12y3bTU5g1vRYuqaibGWmMpD4NZQp6BFcMNy2t8SAI5eNzW6jO4CEbwxjHr0u231KwadwpvnSUCuRvOiWW1DBsJzLszL82szq0cQPSbOV00A3QEO8oXPB2zv3UXYjmZVmXI3dC386kzJeLky5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x9846YIEYRS3lCMn27sYyeCi9o5G7F2uMCbU4q9pw1s=;
 b=imA2HTP4zCzP1DdYQHywY0rUngIeZWMkYFuwDk3/PMVARgh4rKEzAjf360g+WYKm1V9JHDboIKoWKYJSlpHq5vjxfzT98treHBFL+fnFFV2w5CO5dYSJuCF5o7s2c9SoHtV6VwQ1C4UDk1HAJvuvD6XLwiKxs1Qtc9ErnXHw9sxf+m7blS6FJ7ccYYRIAzOMdtIQEDWLQ743NHNGD6OxKsIQo1RnwYNs2hP1UI3rCQrhc26tXdW6T2ORodCX9tBj+KNVNgGX2NFsT10URdF9LEOb//zkZIEhQ/9tcALdhI6AkVvoo80glfctuFQDWHGi+8/VUWEv3d2n6tOgVG7xZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by DS0PR11MB9454.namprd11.prod.outlook.com
 (2603:10b6:8:28c::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.16; Tue, 21 Apr
 2026 19:32:54 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::9618:33dd:29ce:41d1]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::9618:33dd:29ce:41d1%6]) with mapi id 15.20.9818.017; Tue, 21 Apr 2026
 19:32:54 +0000
Date: Tue, 21 Apr 2026 14:35:48 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: John Groves <John@groves.net>, Dan Williams <djbw@kernel.org>, "Alison
 Schofield" <alison.schofield@intel.com>, John Groves <jgroves@micron.com>,
	Dave Jiang <dave.jiang@intel.com>, Jonathan Cameron <jic23@kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>
Subject: [GIT PULL] DAX for 7.1
Message-ID: <69e7d1949ebcc_7d12a10098@iweiny-mobl.notmuch>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: MW4PR03CA0058.namprd03.prod.outlook.com
 (2603:10b6:303:8e::33) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|DS0PR11MB9454:EE_
X-MS-Office365-Filtering-Correlation-Id: 4169324a-6086-4ae5-8743-08de9fdcc8de
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info: 5m2DPrR0j3dt4AXVGEmqb3GEhE813pn3PXhV4aGeyNjaW7peACkbJYOsrtReR5EWUWn6wUck0y2kRPGgcAS7aIuVfdXT4sG1CmjDbc7VYlY/QBoyfq2ye/T6tQbs62EIizpjUcWXMVcMHLo+cVSdQwlgQRprH3c0Me1CqXiOEALzD6g6TvXuiXsylJQvfGlFETyTzZXmgtth5nMoKchIUcTcvByAJgTgfzbfaWft+fpotzDs7A/P5ExKFMlHyyDuR5FjOBW1c6SxTISX3ArYbrCjunPIbzXQlc4Mwx1g/rPI1dnCPRuCFYWEhXTG7Fxt0XXoeqYay/PL95gGUFj6onSTEC2rH1wTdGMRG9wVwlKQfMeEh07Cqmc0SHiXY5o5EETpYK2I6KnfpJ91wexA1f2UGRMU5pxPsawUwWhcNgW4GjagUUEaQk/ZqP0no2+Mimo/mrIN59iV0KmCCi+VW5ULh7IiXR7vtXjW7HVYTzuqJIeo0uF9MT52nqOfnw6QYwHT5C79ng47DujGH/Nv2GLha7Ga0WT4rAXyyn9ws76VlpvGDVA56CM5MAcuaJxrWMVxVTENHMzeCZnIfoPjubd63H+LAvC3Mf9ZVuQkDsInb/AigvoJWNswfRVmAmROOYWVp/ydI7GqXSxRKs7sNz4CWKbIc0mzuFydtePEg3IkmHTWZXuOJEm7No08KJUlqWvTmtK60rrrvbFBWgamLg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?M8Xfqew//+s726QW+yzxY2gyIAgBo5XJMw5LYS26/qCfethyHtz1Db/o8Ob4?=
 =?us-ascii?Q?rJ0siMH+WGHnxaVOLMc6vNiqQSgCtZcKASjULEWssxDm5+C1dPhel1CoXx42?=
 =?us-ascii?Q?BNYk6UcwshvrH//WR33RchrxUHc6FF3PCZ0YXnEgdYLzRnzTxLu8bjXhshtt?=
 =?us-ascii?Q?SbTN8OXs2D15vi97f1xr96gCxiAzdddwY1zgre9ATnypSQakYSbfwQxCBwX6?=
 =?us-ascii?Q?MvqOZpDGX5aYJ5e0rr9M2/MafXCUb5/egU5MsZ0fGbZ+tcryAsEjHdFVNkNY?=
 =?us-ascii?Q?rBxNYLZQTD6x+i0XzsGD0mFzCGp9jFtNFb6YfbVCZCf565poaYMs7AgD6kzd?=
 =?us-ascii?Q?kTcJSeqUCNOoKc1yZxelKUf53+QGi68aFugB12FE4Ctjy7tPu6faF/49uM6p?=
 =?us-ascii?Q?j0EN3477bdof5QitlTuc8eYtb078N8Va5KtCe/h25UhYLK3oMp2w1mp0osp4?=
 =?us-ascii?Q?osx8CmlAEJe2mi1jrLk8uXYxerrNp6IIO2J/fdX16nloKaelbjKJpwKgJ7fW?=
 =?us-ascii?Q?KdEyZrmexUsrL8dKdiLMfnWwJXObctmC1lGRb4tDlrcxXwKvz3XNX5npgfPM?=
 =?us-ascii?Q?+7FJ2zfWaWtWDE6eECthFn10XvTpjEU+irtrju19r/98nv5EMpFHohGkrOti?=
 =?us-ascii?Q?899OeHrjbNxIq6jB74tsUgznZ0a6sNiI2iN1eNawLPfJbMMIQQFImfoOAcQT?=
 =?us-ascii?Q?A/op57XBh3Dkf6Aq0cXrcCovdhiAea2CRLCjoa+MPhl68JBqca995pc8gBkq?=
 =?us-ascii?Q?AUMUnhh/ieYTIBkilMssBtX6QN8fvO2nkbqmfH+XHMBSP7RBQSyy+KMx7yA2?=
 =?us-ascii?Q?AXgP22mLo5i6PaCHbwMJt3pXSY0rzchEhONiFGmq4B2J+y76PIyOzqx9dmiC?=
 =?us-ascii?Q?/mA54sYta1dmY9UGBjV8LLWLHd489a0fumymqbhMMuNHURT62d1p1D4NISFh?=
 =?us-ascii?Q?mZ+NtUBte0BqqF/q98vjUTGZ5m2h4rtr3/dyw6NmKjF03JrbqMM9zQD1x6Ya?=
 =?us-ascii?Q?ciu6azycj2nnol1JUWMBCAsc4HRzktIN+bO/YWFi6aEsxdK4pVGgGuxXb50/?=
 =?us-ascii?Q?jnx/E1KZIuLJfpQ8VNZJTHmJhYBIv7TjdYdpek3d9Kd4qrQ3HFTeKu6Hp2Z9?=
 =?us-ascii?Q?Td9tdoLB2zoBP9bVCwG28UqPFwy0daLttWlBjAaWouE4Mk/pK6e4HSosyY3V?=
 =?us-ascii?Q?LwfdLt/ak/VqECm5Dms95VBA90euHtk7DFC+p2wCCkny+2ixKRRDNwiO8bDG?=
 =?us-ascii?Q?H+Qhu5xgVxFwwwzpbXVRfFaB+HXSBtMv+NS0/+3Prl/mqJV5AD5U/PKYMmN1?=
 =?us-ascii?Q?jnIYWchRKSWNIFAgkKPVO6EIg3tfKrkqikMAQDW0Lyqqvlal4QGRX/85dwv8?=
 =?us-ascii?Q?zTGN4FaJmU2tYdXubplhisNZ+8rfu88vn20MBECnQlWLIfuONSrhDn5fNTwq?=
 =?us-ascii?Q?ahVMEaWcyZjrhOaKNoGLQUZwZTIcpEZ5T/Mm0Rxfok32zVS+EZ3Nya7vfQwr?=
 =?us-ascii?Q?MX5m8zWH1yZYmmlGPbLc7Lu6m9yE+e77AD5IDrKAqIMwn5OX+HX9CMyqg9ll?=
 =?us-ascii?Q?+DgMxhR/z/6qIu4J4zXoBG+Eqepto6WuDhuVsbkV4XQInQ2Dam7mKFKVkUZ9?=
 =?us-ascii?Q?5i8gSVtRWGhXzDc9esZgl/GWucJAhVso+YKF31eO7NAGSQUbxGXpJH/EwOM6?=
 =?us-ascii?Q?w+iZw5kzHBxXfY7JYOlUik28EtlBCQNdus7WKVeToql9OvveqSJ5c6rsY8bn?=
 =?us-ascii?Q?/xI6F4gFqA=3D=3D?=
X-Exchange-RoutingPolicyChecked: DzYSHaLZWvPVMOJ5uB4wvhSlcTnbJPXHXW6c1IcehxkiyEb3kX4rh9l5Fi9Jrwb1jlRqSbV3gniElF0HnvWaKpOUNcOCPxiqjV15Wt8h6vIGMDfvaHfFR38r30mwTbfY3XV+Gq0Cnox97ifeNSJpGjnNjTMXf7Ix/8KiC+RqFfhBNKNM1BuJLFSlmWq0CMSJIKHfCTgsM54+fsUA3BdWJVjLE5Qn/UCY/l3ONCXOZ213H20IAOAwuQIbtJwSw5BRDQDP9IJJEM5uLWNaoyRI0TosLS2Z8ItzDYAOpAFCqQvf5smc2gI842QxJzdKeCZxeyHvvFzEvl2csUmBLr73uA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 4169324a-6086-4ae5-8743-08de9fdcc8de
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2026 19:32:54.6793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K2xUraPQcAtSiJP+S+UMG4HD5seHk5QS+zKtXgDdrmAAS4fH9qiUe+LANbVZ8v2o/jmpIzLbPhnMslEJUiUYGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB9454
X-OriginatorOrg: intel.com

Hi Linus,

Please pull from:

  git@gitolite.kernel.org:pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-for-7.1

To get changes for the dax subsystem for 7.1.

This was delayed from last week due to the issue fixed in the last patch.  It
has now soaked in linux-next over the weekend.

The series adds DAX support required for the upcoming fuse/famfs file
system.[1]  The support here is required because famfs is backed by devdax
rather than pmem.  This all lays the groundwork for using shared memory as a
file system.

There have been some late breaking change requests to famfs.  As such it looks
like it will not land in this cycle.  However, this work will be used
regardless of the outcome of the changes being discussed.  Those changes are
well above the code uses between dax and fuse.  Therefore, I'm moving forward
landing this so that the famfs work can proceed less encumbered.

Finally, there was a small merge conflict fixed in linux-next.[2]  The fix
there is correct.

Thanks,
Ira

[1] https://lore.kernel.org/all/0100019d43e5f632-f5862a3e-361c-4b54-a9a6-96c242a8f17a-000000@email.amazonses.com/
[2] https://lore.kernel.org/all/ac0bwb8BPmZ1_aoT@sirena.org.uk/

---

The following changes since commit 7aaa8047eafd0bd628065b15757d9b48c5f9c07d:

  Linux 7.0-rc6 (2026-03-29 15:40:00 -0700)

are available in the Git repository at:

  git@gitolite.kernel.org:pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-for-7.1

for you to fetch changes up to 45df9111692c62d5f09fc4345ae36dae31024797:

  dax/fsdev: fix uninitialized kaddr in fsdev_dax_zero_page_range() (2026-04-13 14:15:15 -0500)

----------------------------------------------------------------
dax changes for 7.1

The new FUSE file system requires some DAX changes.

	* dax/fsdev: fix uninitialized kaddr in fsdev_dax_zero_page_range()
	* dax: export dax_dev_get()
	* dax: Add fs_dax_get() func to prepare dax for fs-dax usage
	* dax: Add dax_set_ops() for setting dax_operations at bind time
	* dax: Add dax_operations for use by fs-dax on fsdev dax
	* dax: Save the kva from memremap
	* dax: add fsdev.c driver for fs-dax on character dax
	* dax: Factor out dax_folio_reset_order() helper
	* dax: move dax_pgoff_to_phys from [drivers/dax/] device.c to bus.c

----------------------------------------------------------------
John Groves (9):
      dax: move dax_pgoff_to_phys from [drivers/dax/] device.c to bus.c
      dax: Factor out dax_folio_reset_order() helper
      dax: add fsdev.c driver for fs-dax on character dax
      dax: Save the kva from memremap
      dax: Add dax_operations for use by fs-dax on fsdev dax
      dax: Add dax_set_ops() for setting dax_operations at bind time
      dax: Add fs_dax_get() func to prepare dax for fs-dax usage
      dax: export dax_dev_get()
      dax/fsdev: fix uninitialized kaddr in fsdev_dax_zero_page_range()

 MAINTAINERS               |   8 ++
 drivers/dax/Kconfig       |   5 +
 drivers/dax/Makefile      |   2 +
 drivers/dax/bus.c         |  22 ++-
 drivers/dax/bus.h         |   3 +
 drivers/dax/dax-private.h |   4 +
 drivers/dax/device.c      |  23 ---
 drivers/dax/fsdev.c       | 349 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/dax/super.c       | 107 +++++++++++++-
 fs/dax.c                  |  74 +++++++---
 include/linux/dax.h       |  19 ++-
 11 files changed, 566 insertions(+), 50 deletions(-)
 create mode 100644 drivers/dax/fsdev.c
