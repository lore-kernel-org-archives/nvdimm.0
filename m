Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA8733F23C3
	for <nvdimm@lists.linux.dev>; Mon,  9 Feb 2026 19:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770665878; cv=fail; b=lMCfGvy9+fuN5GUjoXZxJQeb2aPF3ZGrAimI1YdcHUm/Cc75202Bl2rjd4tQlTAaEULkqZhD58D4HM4iRY+XiRoBEoKyxlPQBjIz/+iDx8X8IcXZhPqVQMQ4upoI+Dtr2ChPSBpzPU9WuH3JE1jBmUuNohILTuYH0o50fYYC4XA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770665878; c=relaxed/simple;
	bh=W0xE5SbSrrexQU4UvWAq+VnxW4R29WtDtXoIcOQ/1Kg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=PaXTgungEgzvKEWe7XmCCHxiOQ7W8qLK77k1cTZjM7cUTNh8QVQAZDglc8UOqgf5YjDbNJE0QcJ4LXeDXS3TEGvzNsrIISgOWxV7aRTTRaO/8yHdajewbA3FwNLXEXO9W62pe7QTjipoeVb+LyU1lm4YYlUeyhKnsrWV496UaaM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HYgXHiug; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HYgXHiug"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770665878; x=1802201878;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=W0xE5SbSrrexQU4UvWAq+VnxW4R29WtDtXoIcOQ/1Kg=;
  b=HYgXHiug3e/hwWNFjpNu3hGVVxSERlkZ1gG1r4+RtU2OhGxOPcXLIYP3
   dFGrOCFuvpJ7k9VW/iLF/XkRAAAFlBn024SKvAcKsmoMRWo/7A+UBIugE
   4RGyFzGaUDcmeVdoGs0H0dY+gjN40wWGhVD8Qf2A90WBQb0KEK+6UsPeI
   iapEarr/dJmQelgj65IRRvY8xuIgRNOY02r1en77rPmiqqIVoogdSoTza
   4p9++8RzPjY8HKl0P1lbLYwwiZAG7WQuwOIaZnwCF8rpIQknwp0+TzMUx
   yaM9sY32Sy8NbLHJ7AThqWS10pUIdXqgYHufbtvshmqdOxQ+gGCxQkbPd
   Q==;
X-CSE-ConnectionGUID: XmYHgpzLTyGiL1/sTQij2g==
X-CSE-MsgGUID: oFYiMApMR9mIHNrjmCQ89g==
X-IronPort-AV: E=McAfee;i="6800,10657,11696"; a="71682025"
X-IronPort-AV: E=Sophos;i="6.21,282,1763452800"; 
   d="scan'208";a="71682025"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 11:37:57 -0800
X-CSE-ConnectionGUID: J02KcXrITWOiSITXt9k+KA==
X-CSE-MsgGUID: a5VbdikGQJWxZbMXHT9rdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,282,1763452800"; 
   d="scan'208";a="216187934"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 11:37:57 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 9 Feb 2026 11:37:56 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 9 Feb 2026 11:37:56 -0800
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.23) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 9 Feb 2026 11:37:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GSRJGjxLq5jrB6ZMXBOk55ZC2jThHFVgptGaNXO4Ok4gh8mp/ZU55AkeoegKkUI3w57F7FM5W8nCxaDT09qQk/vEswNDpnr/hegS7kxvNDAUJ8r0oTj6kRRHzpsz3Ganl1UwZpXgTuOiEk+gyo1lkfROEsusCHZUAI0IrXs2ATNMpK9QkmCPsKEsioax9iiXwfbt/SOoItY3UdeKtQjoeHyHwNuVMX6T0rt9tLo/zRf1gUMOFJyp8/uZ37UlaAlkoz0El+6RZdfIyxqannY6NKdSAV4XdfEKvVgQIgFw8ccqANQt8/wgrdhmmRmtD67QOzeZy5VFya89sAqxkqXQoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dufpVQ2I3CO/PCZhKQksLmgCNJYl5K9V8cKDlYq1Qi8=;
 b=GrbpR3TjNmJgtB5DUZIIx9uoH3yCHB1i9ei/5pKTGE+JrP1nKqjEB/z+nNqc9eKDSLsudljvnbdzGVHThq9t5pQuXo6CbZCquHSpUfQKRLtyJa9l4CcCDxYWihCK931B7L67QTzpL2xCG5ru2h7A/hbqiG/w6BzMevncNKhd2yd1QNODEkqFO7enu6EtEjYmZU3EAIR1tHQ8leyvfL43rs4bftUKjWQSZskyVSNzZo1tYLhiihMLJlpteA1qlsHAJ4scskekOsD+rBLmV6adZFKanOViPr92Rg/wLUv/o8wC9AMNUXWRik/JLJa5uYr7IKiqN0yHO0QRDYObJmCZAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by CY5PR11MB6488.namprd11.prod.outlook.com
 (2603:10b6:930:30::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.19; Mon, 9 Feb
 2026 19:37:46 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::1340:c8fe:cf51:9aa2]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::1340:c8fe:cf51:9aa2%2]) with mapi id 15.20.9587.017; Mon, 9 Feb 2026
 19:37:46 +0000
Date: Mon, 9 Feb 2026 13:41:10 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Alison Schofield <alison.schofield@intel.com>, <nvdimm@lists.linux.dev>
CC: Alison Schofield <alison.schofield@intel.com>
Subject: Re: [ndctl PATCH 1/2] util/sysfs: save and use errno properly in
 read and write paths
Message-ID: <698a385672ae7_c11ee10097@iweiny-mobl.notmuch>
References: <b74bfd8623fcfc4cf1078991b22b8c899147f5fb.1768530600.git.alison.schofield@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <b74bfd8623fcfc4cf1078991b22b8c899147f5fb.1768530600.git.alison.schofield@intel.com>
X-ClientProxiedBy: BYAPR02CA0029.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::42) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|CY5PR11MB6488:EE_
X-MS-Office365-Filtering-Correlation-Id: 424e7b52-91da-4c65-6160-08de6812b34c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?VbUkzvWQqqhONSdZvbck2JdgsdVeiWGLHRnpt6lNA+KEGb2ZxWZlx63K5kOC?=
 =?us-ascii?Q?MmGQgeA/Tk8jWsti/HxqEWYkyAu0OVA47yrXJx6OmS5FIYORrqwl+EIQr+74?=
 =?us-ascii?Q?P+MXQ88V5E1/tOcc7VMAna57WbE9x+CFmTA9t20xoRTwVf7IQlbQHgk+MMkx?=
 =?us-ascii?Q?pjTtkfoqDVGm+BNMcrlQjhVuNawnmAfkgsUfn8BcWsga9G2os62+DMkEHqqr?=
 =?us-ascii?Q?//8RKMHfd08/3jyXdEEfz5FuTs3Ijygn5hljkJhLJ5Ui+nuGfYrYvwjQwDGd?=
 =?us-ascii?Q?9uI4ncgrDPpU5x2miA7cfhzqFav/L1Od2tmxYlQ4my470NG3iJEJ70A1lpdE?=
 =?us-ascii?Q?Jg9djJjpstLID7WR1eFB9lEJCzrysfnoOTTICEv5QXY8kCx6lBx2PwdYl+o4?=
 =?us-ascii?Q?bDUS7J3Rzf6c5aqgQaR1CMhkfQ073xjOBXtVqkqOqJ+cLOK12gXdXlPj4jYr?=
 =?us-ascii?Q?LNt1Lm//v8KcKAmfbD4pyn6jiys9D7T/UaJJUhNvI2cWnt+Zh8Rff3LGFDzs?=
 =?us-ascii?Q?t2/vrUIwMYSR2cH2O6eUMnp0lLF7TZnKYP50oB7qabiWJ045wyDQUzjguOCq?=
 =?us-ascii?Q?/Ug5hXfeSV/PkE7K6E4YXqyXdOeDm0Oby8pZB0ukmQJrSly3VgEh1HJCP1oe?=
 =?us-ascii?Q?Jv2cmoTXQWa7BPKakaV5sL2c10b1C0chgqKEVcoqg42HZUOwMJtBGBiaXc3x?=
 =?us-ascii?Q?Hpk8tsF+O+0ZQyW3pWxIt4HaAJ7fsvE7H9YiW3hlr70TjeXF/VObvG1Cdudn?=
 =?us-ascii?Q?uaP+47pzAj+iKnTj1JzKcTOTtDnrlWwt8nXMcpDOzFmPe5H5MfPqA7uPTyKN?=
 =?us-ascii?Q?CIB8iWL2ILZNOXx4nbkl7CEASP7g/TK9wj3vOs+hlY9KIfDpimIwba34qzbu?=
 =?us-ascii?Q?C1LfHYOV+QG8O82wzmzGTuYzCfuahmsS4JvaijWHSppR8DM+Ct2Lvwqnxf1B?=
 =?us-ascii?Q?yp0/CxdoWj5iF48V9+O2E+HbYNlK/kBjMUXT27tn8vxH3FuZsVPkt424aeqd?=
 =?us-ascii?Q?1IAlYIGvT9FpcQp3S60HItZa8Ja7zFVXUfBVFGDaqrXJsJsw4TXVnPz8usxl?=
 =?us-ascii?Q?Pw3a+GjFeOaob4m8T+MccTyK7n3yMTADnc28eFOWXH6JVtdMKYbYEXNZii/y?=
 =?us-ascii?Q?PzkjETF9fgLr82hHeWHM2sJl9GQATbiguISyfrI78Xl49muZDrAfoEHU3KFL?=
 =?us-ascii?Q?+zYbayZb+phe7ooqkE6fUdb/mpaIuYYLgUawwves8g6iA9gkC9svEtKmVf46?=
 =?us-ascii?Q?iRaljyfAGUW6IuZRRs1BM2ebL8p4s7rECfrSx6tOzzKJ53Y1HS2APqEVu3Kp?=
 =?us-ascii?Q?y8QBlJz+pWW4DMmdzJ/Smzd+4p/lxEL/ZF4WcjCNK+Y+8RZDIYil0TmE8cZy?=
 =?us-ascii?Q?4DVCFdTkbJJVhcZnOIZmrbfGkMPu63XTL84JC0ojoDvsUcYBxEavqf7M+82K?=
 =?us-ascii?Q?rqaL7waELUDoXDguFTMrNBROWMiAEbOIXtmUoDHvd/7zkjxFb6UWfYvm9Ffh?=
 =?us-ascii?Q?CjxJyA1X+PItO4KicB5JsbykK1Kl9xJMnn1NVN+IayxZr3wM5qqF3Wg5oXdQ?=
 =?us-ascii?Q?nguVpmjxNu38bIPQ8Wg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?czxIaLzgvmeTSx4eOsLR49EveS5FDSuXLNIalZmsnipim5fQ4E3lHbT6Od0U?=
 =?us-ascii?Q?2O/NyJKe6WdpBwHxh4RdHKDz3zHaVVO8e4ig9IIACgpFxYrwxJnbi5leRu54?=
 =?us-ascii?Q?HPtPjsO9VsATQ4pY3CwSgfHJi0TeiHMa20H3+yeoboY311K67cwtgnsGY+VE?=
 =?us-ascii?Q?xRlnavNKdlyd1ZRQ0JjsCd7Qti7dqb5MosEi7ZnVi5qamymTH9sTzzvE2ixX?=
 =?us-ascii?Q?JAdwNfVW6PDAzqsnooTiP8mLj2R4jHTZPSl294T/2fGknOLkgP/QJ6F4qqnI?=
 =?us-ascii?Q?LuKZ/XTYnd1jVH8Hyu0UuGKobkizlmUTrfa/0EGp8KgKrhld6+ylohA4bxc1?=
 =?us-ascii?Q?LyOociNuyZsni2Tbljd93kTuY5Xtf5MX4DgWXFAbAeXnSEFW9KSUEq6n3t4s?=
 =?us-ascii?Q?KqDf2REVFCaLrvy+JOW3ZfsP3QtmrpAwPvLIZfEpX1h+8FXBzu1792ZrGaGF?=
 =?us-ascii?Q?MFG4BVe7jue4rDF7lOuYNOzS5cWzZn05pqtNJBro/jAbbFfsHRZdraaihxvM?=
 =?us-ascii?Q?u9bqfUxSW8XBBV+UMJ4KW004FYBoJqWjmLVMsGD/NRlfjBDVLtNPiVm/w6ML?=
 =?us-ascii?Q?wgA4cK/bCCdzpEuW76Y3JbkUHJsxoG/pioFJSRRvpPeEkJog0A5JRYDQgrOw?=
 =?us-ascii?Q?+dV41EU2kpH4AECb0DI97fzOcfFSZ1EPijeLyQ294WSZ6+SfVof4Q29MBGnL?=
 =?us-ascii?Q?pF7vCwgCPyaBtFOj5lvJKKTXjiEqvb7iF7GZpS4kWIcVeGpgqFFNBR2ZduwZ?=
 =?us-ascii?Q?PlJCJpJ94loStzY+X8Dyde+6EhYzUCPPNyqe/CWzphmcwo5xfK4p858mXxpT?=
 =?us-ascii?Q?qZR7O7ImQN29QpMCBQni4iMnhoFrbt5X91dZ9QX5lujfI/3l6G1lAzccVeJD?=
 =?us-ascii?Q?ayT3PWJJnAy5YwDoss61EPrA+c3Q5Bx9Xx+J5Ya2+KQ+9+lQYgEzPaid066k?=
 =?us-ascii?Q?NgahhDZn8M75sxTv7LVwKph5qW+x+O+2YMk8bCVfD8SQkHsDzDhD1koEt+Z4?=
 =?us-ascii?Q?oz9dbzJauy6X/0+YuZnld+H41G+HQuc94zKYh8eZTNagKdQ+6iZ9bbi0tUBy?=
 =?us-ascii?Q?zTDORdgiLSDg5tdDMfsz4deSeryQsnyUDi6QwJVCfjmLVuChusyQA4UUpaCd?=
 =?us-ascii?Q?oBtP9e9jVFfQ3GI3AeNtA/4Lh9uvCiTwhOSO1Vit1g2zOoFNs7K6qGb3ybGB?=
 =?us-ascii?Q?e24jCP1CmKOSbUgxiicOzHO3XN9evHC5NQzd1j98nVQ2HYkcxoCwMBV6M/5L?=
 =?us-ascii?Q?92hNmbc8FX3z+GsPl4L5P2He55spI+tSqqzrWG6r+8qg6X/dOA28SPUQwjrl?=
 =?us-ascii?Q?cC4yd+c5jc9vGy8y+KozTQodImoBB2mw+YHvKeDKjkn1E98K8UK8P8myJLT0?=
 =?us-ascii?Q?F2bexnJgF2bPzLO/DhbBhiQtnVZuXy5TcM4qHImvfmSlnd3tnfxdoDjEOQ+G?=
 =?us-ascii?Q?d0SosgMwrQEMeq0RGnZQ0aDo0lbGwBqPzN1OjgYh7WuMDVxxKITPF+hxpzhX?=
 =?us-ascii?Q?OYQCQhniKJjdnUd6UH37+tuNmn9fILu2Dg2eKIwOV8pcrr5GI4KOjv4P4YvK?=
 =?us-ascii?Q?Czd8BGkRqAVRf9nr1350oleXDD5u6s3oIpOH1ZnN62lrZnZw6nnXX/Y5mPk5?=
 =?us-ascii?Q?A96xLulfMGOXfyYBkdBCfijHQlm+HE33P/hgOySfdYHRG2n+1bUjIlimbYjX?=
 =?us-ascii?Q?kj42IlEfrek4kvDJQwrbCPlyvZ1wUwnbtiDmMBV9JPS73Z2vqdczp0/F6iYx?=
 =?us-ascii?Q?A6rmtlAygg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 424e7b52-91da-4c65-6160-08de6812b34c
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2026 19:37:46.1156
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9PQCWZ3XeWCattJbmh5wWpmAf9ZIDYguwVuuHc0BSiuIaIzooHy43PR5NkECq3p6ED/JSAIOYwrXdwZdgD7imQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6488
X-OriginatorOrg: intel.com

Alison Schofield wrote:
> The close() system call may modify errno. In __sysfs_read_attr(),
> errno is used after close() for both logging and the return value,
> which can result in reporting the wrong error. In write_attr(),
> errno is saved before close(), but the saved value was not used
> for logging.
> 
> Without this fix, if close() modifies errno, users may see incorrect
> error messages that don't reflect the actual failure and the function
> may return the wrong error code causing the calling code to handle
> the error incorrectly.
> 
> Save errno immediately after read() in __sysfs_read_attr(), matching
> the existing write_attr() pattern, and use the saved values for both
> logging and return paths.
> 
> Found while preparing a patch to expand the log messages in sysfs.c
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

[snip]
