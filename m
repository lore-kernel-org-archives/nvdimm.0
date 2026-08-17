Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7129F1A6817
	for <nvdimm@lists.linux.dev>; Mon, 17 Aug 2026 22:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787006822; cv=fail; b=X7fqBAQWSzrZsaFC87DDZcQNFDtQ6HYlsyXmHk+B88ct4Po1/O0T59YHnM8HdEDsTNb4P17q6gvgbrbztteWaJ5yFi7gu++sN47ZZm9k3rLHLOKuWYR80zVaIaJevCvXZ4H9+1DnXhioDWA59GhZlp0FL8Qx6jVhTmuBUmlbass=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787006822; c=relaxed/simple;
	bh=5Zs7mZBvdjIDxlbpLPM5JakRXxXLqL2JbgGKRPdyNfY=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=diY3KIZ6dCCzNyZuHVHZO+fFq5qHffdwjy/CqcEs8NjdMr6GQVZJMXZdecDuwqkiZx0OM0+ECY5o+YfA5hfs/3pd3rLnPQuklFzeXnKx0zyeDoFqu5zDRX8snFG9G6f/IzLqFdJzliZ3zKFd4BxAK76ePE/PbyHXY2P/R0e2CK8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hEZRcay2; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hEZRcay2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787006820; x=1818542820;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=5Zs7mZBvdjIDxlbpLPM5JakRXxXLqL2JbgGKRPdyNfY=;
  b=hEZRcay2hWJUansemvtLPq0cmT+ZbmOP6Ew/t/zp/kdhwPHWCIS1YCR7
   HZP21Xa244ZwRbvM7gcP1zG7ppmbHwNzcp9+/hx1JbFLSulNlehgpzlAJ
   903Vpr7Sfmr4wzlRa55ZUvtkuYLC1oiKTb7Z7Xe4Mhv90riSx+OXGpkU+
   RZPdYEPfKk0u41cxXjHm5N4Vw02N0CCfxNY+yEbXVszJmVJ/8/8bS5+S8
   g1l8fBGa5+r3425V7IY89UDLQW0e8BKfYT+OSrHSyhDmUHiS990Nx4eYE
   X7z108TzrU4vIw7wqz+1S+kRHDbDSTIe/Ixj1naCov1Cd2Y2SengfqBPA
   Q==;
X-CSE-ConnectionGUID: 0D9v0aCHQxOEiEK0oionmQ==
X-CSE-MsgGUID: YT7x6llsRSe4x2pk6tKkpA==
X-IronPort-AV: E=McAfee;i="6800,10657,11878"; a="98156374"
X-IronPort-AV: E=Sophos;i="6.25,229,1779174000"; 
   d="scan'208";a="98156374"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2026 15:47:00 -0700
X-CSE-ConnectionGUID: YaM5hqUqRL21RNwSTLdGPw==
X-CSE-MsgGUID: qZwA27hiQxyMYqvchUB7bQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,229,1779174000"; 
   d="scan'208";a="270260847"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2026 15:47:00 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 17 Aug 2026 15:46:59 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Mon, 17 Aug 2026 15:46:59 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.50) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 17 Aug 2026 15:46:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VY38A1JffgZvFoRvflvFsRQNVhosoeHgNG0uzqH5aWCcAwfZC5I6S7xGR6qKptMJp80GNY8rjNs2hUx9K5EyVWpLEd1FxbYIRoCoN8kOtr7aV12I7a35+p1vQ4KWhmP066yd9m4GL7LbAxWIhhPZ5cfFzsuj7YelMtcN8RHluef+yYzI0PacQPbgNSXNpMDTC9qy8yqFhoAIMNgIxTH8vwgCkXPYh1E6RT9n3hSf51R3dBDXtAmD0k1cAJ6roijSg0fIUZ5ZeMZrOKfW/G52jnC3iIughz3N6tdbP9mRVSS7YQRzbNtCxo0STcq45VP8+ICfac52l5WBNzUK/57m2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XpuA5lbrYPv8WxxbAPGYy6IKC/Lweur8ODc+/IhGl68=;
 b=Z7mRgqMeWGMcll6k/uhbcawrOCwh2+bJTV6wt2mmZcNeaH3vzi+QqIctuUF99sw2AXob2atj+M5YP4oatAUcjNcBpe194x0POjUZBDypitTvP0RGVzygSw283El7Pr27xmyfgDBJVi4aeOXtglzSJEUrNTyo9wrUzMfIcthiLrPezUs2d5t8ylihTaUCvqk63hY5P/ZJMQHJt28kpL7TLAsrIAXdRzSDuota+ogfxSRJwt+OgeLhmXR19INA9LleyLi09QBI3RpITyo3Uz4dpV7cR+j5LGYSQHQWotAScPG6/1XBWB1FGQsP0JIW1hd4iueinkapc5JjECaF0TCZ4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by PH0PR11MB7470.namprd11.prod.outlook.com (2603:10b6:510:288::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Mon, 17 Aug
 2026 22:46:56 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::e721:90d7:9214:2d53]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::e721:90d7:9214:2d53%6]) with mapi id 15.21.0315.016; Mon, 17 Aug 2026
 22:46:56 +0000
Date: Mon, 17 Aug 2026 15:46:52 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang
	<dave.jiang@intel.com>, Alison Schofield <alison.schofield@intel.com>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] NVDIMM and DAX for 7.3
Message-ID: <aoOPXFhuXrm0tQ6u@aschofie-mobl2.lan>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SJ0PR05CA0135.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::20) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|PH0PR11MB7470:EE_
X-MS-Office365-Filtering-Correlation-Id: 389b791b-b09a-42f7-90a3-08defcb17090
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|18002099003|56012099006|6133799003|10067099003|11063799006;
X-Microsoft-Antispam-Message-Info: 4rxd+DNudBcnKNQaV8Ol4TfWOt3X7InPMJFEGPeaKS/8RSwRyOZSWcofNtBOKhcXLfPUAuA2K3mAzLF1lVWzYlmf1brd5pXr3fegNuhf+gNKlF278JYRwuT6jeoO6eG4PHUWYCcVLD6YpigyiBZa3Y92TMz2yjDZmI4T8P5PXS19308J2ubzPtmLiXGr5mkuSZ4Am72hO99yJZlruLFPxtUZcWHdfvpuJB4Dw/8hFtJkcp3b7MaV95S/6zyBSR60+NVtEvMRWb7JNrnizTcTL6mRWJNhR77cAfBgvrtqeXz7hK+Ycou5LszO90s4rBwOc/5wmSGIMIIzdsVKDigmb3h11pc2ZfDsCOGcknZ0Gsc1mXYBuys4MVVHPbYWqy2KseI0ldb5K3TGwtqzVICerrYF9Kz+jkZLBo2UBkDed/cqRg99r0b5KrUaEN7lCKQoZPOZ7Cb0E7c21gpXLA5ZFnOiYfc/2JaUtV9yWY1L3JMLuK4+qtoehFdnQRX7YMa0Cy86I/83qyrplA1QWndk3oOGNQigcRPklUF9hGuQ0rKCHeh2X08UCHTKX/7lqaPeDSWG6vfSKE+jS/xTRwwqrR4EpKUTzF+V6slp3ct3sio/HACHaIZSH3tDXHRtv8fZdcX8tZHX9f274BLUqWitT8tpMSo6ATxsWKNAftX5kq8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(18002099003)(56012099006)(6133799003)(10067099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2iz+1xm4iH4QcaIwxjZzywJmX4yQsudefEmVDk6zfvZrssYVNzE8gflg0M3h?=
 =?us-ascii?Q?jlhGo6zetA8ZZZZgNydLmLv9QJFy2UUyk9aJwH7d3mPHOyVGZXNkSFy//M17?=
 =?us-ascii?Q?u3MwbJBFmyy8fcxIy/UVB9Byib5hz+anLa/K1c92YkugmMMZs70/NsPO7bBI?=
 =?us-ascii?Q?jvtnf+1CGT1sbqHtJvetVYgPB+aL03HGnmHeU60fygOYrPFj2FmmhhIOVpym?=
 =?us-ascii?Q?t3nGIt77NSA2J9MvUK1VpO+CTXSBY2AHgN8MbhJTh6ABAeLISEcZ49FhOeov?=
 =?us-ascii?Q?Zn831kiJBQmRz7pNeJfSSDo6jTMxqCfcyS4EFtPnUsxDE6WXkb0K47gXZ+3p?=
 =?us-ascii?Q?ts50x2OPt1HGzfFORfH2KI3vlp1+M1DiMyVBMHuHqWyPYt5IZ+gZLXfZb26P?=
 =?us-ascii?Q?nAS4lXWnWdL5T2v36y0u5ylqCSPo/2zcTborlbVHcWSZw16KfMmLQxi3tt4V?=
 =?us-ascii?Q?28eP+3Oo4FsLkwG8ZyFV8L2766RNu1YUaUhXWlvht3xhTPW3YgGWRGvC88Rd?=
 =?us-ascii?Q?yBXlUXUNbKIe+EPLoVoWUF+N4oR6RnKz+qOKc4OSf3oUToqHA6liYvGNCmwf?=
 =?us-ascii?Q?WcTOk+FWrijnhD9Bv/NGj8wtuAtbh3iziy/tg4N8ldN4BZ/fdMUSFQPyi2oQ?=
 =?us-ascii?Q?ap4+XWwduCtOYMTEQ+Nm7/K/SuYgiXDP/5KwvmmOA3mEmcGT9COBBBoJe61P?=
 =?us-ascii?Q?4OPYGa/af+w97GDQ4Eh8xStdyX5suZ0LUCGX/Wf3mpu+9Q0J1TMOzkAdnKP/?=
 =?us-ascii?Q?Hsl9AYcCfP2iE/aenGiWChoq70qxsIo5xxwTEpAtPEvfioyq3S87lU373iMZ?=
 =?us-ascii?Q?CTTIopFumpQFRGSZu/2pY96LrrE5oOsuvntY5Es4Lf7T+P7w+kzAnSYfwEhw?=
 =?us-ascii?Q?AQPlZZ5QKuILb1qOYVvK9yni9fdc0/G6za5oaksTr5BPm4qvRFHNYmlQyn20?=
 =?us-ascii?Q?MyKZJXDnZ/CQizEJ/J2FGLlFdtaaQWORNgpw4dnq6Kb/M23UnA2f8tFNGG7T?=
 =?us-ascii?Q?neCJsFBsSuXY8GSGIWvHfM00N4eqoMLpOOHsnwyGp2JeWUUdOvSi5DUFhx63?=
 =?us-ascii?Q?k3bU+8ENrNN2ZbHQEJK4F1ojmisnyxKR7FUnhAtvZtt4Yjr9oXivmxguEBdI?=
 =?us-ascii?Q?hqLPBfHKdNXQiJkgK8c+wgOJOX9VdFc3ygXPByATUUIJUEx9MnRduj0GkZpt?=
 =?us-ascii?Q?etY3VFXPuvMLwCJLQGcaZcPftNE5yDd85nnFk/JDBrrZsjYnLrrdsl9g3D0o?=
 =?us-ascii?Q?2zJsumDzxKkX3fLbOCwLJznhjRkIMiXpJ7uSl14TL0RrV/8900flZ/8wkBK2?=
 =?us-ascii?Q?eg+Ei2FfqtTQOiIpjtaqZMLicUYWp0oZh3izXbnBz5pp8lym2xWQyZqlseoC?=
 =?us-ascii?Q?jRe8XsZJJc/xGkxhERhw0QkxBxKQhwK8PF4PZgwPvqQYeptkjXSNmVjbQ7V7?=
 =?us-ascii?Q?PD69O8T+UAlK0fU3uQ8oY5GT/e1YVvo6KyPOksMiWQfJasGCoBHKnB1TIzfE?=
 =?us-ascii?Q?rryscRxvR4L8+v7VgmsEZLTrxSPfhuyO5PBBncpQZxK/iRRdAbrsL88xzJ6R?=
 =?us-ascii?Q?h2xjHJYm+4F5qfoQhJqkuPhNO6h3+BoO1qnhTjP4Vc/Sjg1vjgkiXPn7gDKT?=
 =?us-ascii?Q?gH/B2j3xLcONCSOwyHJcnFId7hWNrFJMfX1fhM9zIWJrXZRa71ugtMmGvREV?=
 =?us-ascii?Q?L96drWbYSOTimPWe4ba2r86Tg2l+KMG9ynPmgJ8GhSzjIdlJutEVk/bdE+ed?=
 =?us-ascii?Q?Q2ElIgafzghBmqr0iU0ATJbIJOts+fs=3D?=
X-Exchange-RoutingPolicyChecked: PEfgC4ClQUuO6omM3ASOFpXNT3E/RXqYCJbQ7togw/ClPZEiq1iWpt6MnoUjn1DTdo369wXzJal2IH1CMDrfLVf8WyUbWVjQ4jADusdihNwcjxQ9n/VlKi+ftv2pdQxZ6za+pvogRyv1iVAqpOdPlNeRj6xXthdpwpYki2OKECNHWNiBb43vPSLyVUkB0zYjLm1VRUIB4CsOnvEGHHn3qJvOv23JuL9XXEK6dsssjpxYvZPu2lYJE0U9tmED+3kSv+rhrzDV02Mbuo7OEx/tGA9ogFPZEuQl61gSYaJk6LCqYV0Q1SaSu/CaU/ahyylUfly6Kb06A3ThItciGQ9bVg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 389b791b-b09a-42f7-90a3-08defcb17090
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2026 22:46:56.2989
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: clFV6tUHAD9QQYAj0iv91iOo0hrXWXDI9y+ohuCHSPRsgzUZDBnXgz9rqJo+4DM2p9bw9QSGYMlO2Ji5CgM2nuXeuKXtrbsdhLT8Z/7lxL8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7470
X-OriginatorOrg: intel.com

Hi Linus,

Please pull to receive NVDIMM and DAX changes for 7.3.

Most are DAX preparatory patches for FAMFS support, along with a few
NVDIMM fixes and documentation cleanups.

These have all appeared in -next for 3 weeks.

Thank-you,
Alison

---
The following changes since commit a13c140cc289c0b7b3770bce5b3ad42ab35074aa:

  Linux 7.2-rc3 (2026-07-12 14:16:39 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-for-7.3

for you to fetch changes up to e99cb3ecd8334ca21e01ff9a79a916693f58f1fb:

  nvdimm-btt: clean up kernel-doc warnings (2026-07-30 15:42:58 -0700)

----------------------------------------------------------------
NVDIMM and DAX for v7.3

Documentation cleanup:
nvdimm-btt: clean up kernel-doc warnings
libnvdimm: nd.h: clean up kernel-doc warnings

DAX prepare for FAMFS:
dax: fsdev.c minor formatting cleanup
dax: fix holder_ops race in fs_put_dax()
dax: read holder_ops once in dax_holder_notify_failure()
dax/fsdev: fail probe on invalid pgmap offset
dax/fsdev: use __va(phys) for kaddr in direct_access
dax/fsdev: clear pgmap ops and owner on unbind
dax/fsdev: don't leave a dangling dev_dax->pgmap on probe failure
dax/fsdev: clear vmemmap_shift when binding static pgmap
dax/fsdev: fix multi-range offset in memory_failure handler
dax: fix misleading comment about share/index union in dax_folio_reset_order()

NVDIMM misc fixups:
nvdimm/btt: reject an arena whose nfree is below the lane count
libnvdimm/labels: Bound the on-media label size before the shift
libnvdimm/labels: Prevent integer overflow in __nd_label_validate()

Coccinelle reported cleanups:
nvdimm: ndtest: remove redundant NULL check before vfree()
nvdimm: nfit: remove redundant NULL check before vfree()

----------------------------------------------------------------
Bryam Vargas (3):
      libnvdimm/labels: Prevent integer overflow in __nd_label_validate()
      libnvdimm/labels: Bound the on-media label size before the shift
      nvdimm/btt: reject an arena whose nfree is below the lane count

John Groves (10):
      dax: fix misleading comment about share/index union in dax_folio_reset_order()
      dax/fsdev: fix multi-range offset in memory_failure handler
      dax/fsdev: clear vmemmap_shift when binding static pgmap
      dax/fsdev: don't leave a dangling dev_dax->pgmap on probe failure
      dax/fsdev: clear pgmap ops and owner on unbind
      dax/fsdev: use __va(phys) for kaddr in direct_access
      dax/fsdev: fail probe on invalid pgmap offset
      dax: read holder_ops once in dax_holder_notify_failure()
      dax: fix holder_ops race in fs_put_dax()
      dax: fsdev.c minor formatting cleanup

Mohammad Shahid (2):
      nvdimm: nfit: remove redundant NULL check before vfree()
      nvdimm: ndtest: remove redundant NULL check before vfree()

Randy Dunlap (2):
      libnvdimm: nd.h: clean up kernel-doc warnings
      nvdimm-btt: clean up kernel-doc warnings

 drivers/dax/dax-private.h          |   2 -
 drivers/dax/fsdev.c                | 148 ++++++++++++++++++++++++++-----------
 drivers/dax/super.c                |  54 ++++++++++++--
 drivers/nvdimm/btt.c               |   8 ++
 drivers/nvdimm/btt.h               |   2 +-
 drivers/nvdimm/label.c             |  17 ++++-
 fs/dax.c                           |  12 +--
 include/linux/nd.h                 |   8 +-
 tools/testing/nvdimm/test/ndtest.c |   3 +-
 tools/testing/nvdimm/test/nfit.c   |   3 +-
 10 files changed, 191 insertions(+), 66 deletions(-)
