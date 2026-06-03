Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C4A72627
	for <nvdimm@lists.linux.dev>; Wed,  3 Jun 2026 00:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780445544; cv=fail; b=WXtBDpwhajtjOZH0kKYL2ZThII5saXDlhMWTWKrYKuJcL+musI1eA/94EqSCt/Bo6E92iJJVn7oDv9XBObhJVYHJxCM2xJbxN97c904V6DAdsWvLz45YAlMCA3RRfkvpuPng/3/Mac8/s+6sm5PkfhN/Jw601qJaSER+C0MCtXg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780445544; c=relaxed/simple;
	bh=WtdCoF1jZCYTZD697poAPznjgYjuFQK2eLb3UdE5BKw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=WhEhyTozyn1TUf2K17VW+j5rRdvW9h2xeDx6mXJ1Yz5UB366jO3Al4FLrp8jOQv3CGeag73KArr6YSNllHPspJNo7goJYUKOgk31w3VceAJcrwd4bEv+fLywhLFMnNun0ensGGVD3HYHTosoIF4jWHZXxKjvKuCeXo/5IkKQ1Ck=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Su5Vf4Mr; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Su5Vf4Mr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780445543; x=1811981543;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=WtdCoF1jZCYTZD697poAPznjgYjuFQK2eLb3UdE5BKw=;
  b=Su5Vf4MrAecBImr3sQZgrx7PO2A3w14FqnVHXI99wNuuzFDnlS83fz4M
   25tuAA1PyZ0FdQuKeOqb4cC2AN5XasdYfSkLA1l1ebUL28o3GBsS7dbzv
   Vr+3PlZijKpz0TdRG5fIWbyd1E226DLX9UL5XRts9gFw3Wdv9vQxZzMuV
   6NshRr/8uCZJ7bcLUwhrUY9YY43STTdIdX8+SUMqaChvQvSVvt8Gcp2aY
   XmLNFIppAoh0nRHKRqdboMbxBv6Z7Z8lj40pwr+vQyHSuSnrxKkpyIYSr
   6Yv+/ftwfqBSzI66B03WcDlq0Ns8mazcpPjEq+Th6UIta+bsHZ5Kvo3gP
   w==;
X-CSE-ConnectionGUID: BYcV0xwtQcOC0gULTw7bcQ==
X-CSE-MsgGUID: ueyWvYrHQe67QhzAafoVCA==
X-IronPort-AV: E=McAfee;i="6800,10657,11805"; a="85130738"
X-IronPort-AV: E=Sophos;i="6.24,184,1774335600"; 
   d="scan'208";a="85130738"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 17:12:23 -0700
X-CSE-ConnectionGUID: O0H88s1mREaiRocbtb5JDQ==
X-CSE-MsgGUID: EwHbWD5JTQq9gHy6aHu2bg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,184,1774335600"; 
   d="scan'208";a="244167111"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 17:12:23 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 2 Jun 2026 17:12:22 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 2 Jun 2026 17:12:22 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.51) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 2 Jun 2026 17:12:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LpBrqfgmt1lFL2m7HFiXTRZFlGxXhTBhqftexZFEy+u+lSJDgGq6qw+4/dTsZThtIGjrWhFD8GTK8nvj4UBay8pS181Ysa2w1sH900UmYJAOCZrVu7YKdIStXZI/HtwQY/KEsBVEYZ9nMaWsgNVeH3LYuQBYM4A8vdbf2RIGtLWywmmmtCpEYIaqhZYXJcL7RrxuOYRtJ7G7g8Yi+MKUli6oO6jqVCfjkBMQel7oKreBfGUJuVA6IT9A96xaEQC4VT10LQsQK2j8dBbkfI6GR3tEyCUyyfelO1Bxk4qmB0VVBsEg5DR95tJ0G3QjJsbxEvtLSBE1pIF9xwcZenVj+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=doGXCfWQzu7ICShhx9ei8ybPQhkO0hxIXIuuDClmbnU=;
 b=uPsHjhqvLtc0N/vC79zFRN6T4CRDThUyGyYGi0Wf+htHvabr4Jw8V7NHJIiLfGYqirDsl1g7+JT2TvlNFk+xLH0Wi7JXvL7HVIZFWmJkPxs7QHh+qHuONJft8XmhaBVPEO4uVd8trSh3VQr7LKHK0PzMp+tynGcP+Qwqt8LQ77U1hBrXXLPJa/R6H+HQEr7AaXXXL8Eu3WKgjYJBT1U/SoMHXUnIKUr0fsgxRGpUJDkUXUE787LCdyXHNByW33JkGf5UZibnKuSLMG70Xh7P3xHaeNyJzGqPO4vkBq/os6IZdRrhTROVnQPEg/jTYtEjhCqT6ZxEuMaPn5Ym6TFfzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SA3PR11MB9511.namprd11.prod.outlook.com (2603:10b6:806:47e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.13; Wed, 3 Jun 2026
 00:12:19 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%4]) with mapi id 15.21.0092.006; Wed, 3 Jun 2026
 00:12:19 +0000
Date: Tue, 2 Jun 2026 17:12:14 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: John Groves <john@jagalactic.com>
CC: John Groves <John@groves.net>, Dan Williams <djbw@kernel.org>, John Groves
	<jgroves@micron.com>, Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang
	<dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara
	<jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner
	<brauner@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Ira Weiny
	<iweiny@kernel.org>, Jonathan Cameron <jic23@kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V3 1/9] dax: fix misleading comment about share/index
 union in dax_folio_reset_order()
Message-ID: <ah9xXiWUCJZ3cqwg@aschofie-mobl2.lan>
References: <0100019e79caead2-5795328c-af48-4a93-b147-c11df7446e1a-000000@email.amazonses.com>
 <20260530165029.6601-1-john@jagalactic.com>
 <0100019e79cb6bf6-4b48b7f5-c562-4591-aefe-730561f1b8c6-000000@email.amazonses.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0100019e79cb6bf6-4b48b7f5-c562-4591-aefe-730561f1b8c6-000000@email.amazonses.com>
X-ClientProxiedBy: SJ0P220CA0018.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::28) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SA3PR11MB9511:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f11394c-9a52-4f20-37cf-08dec104c6b7
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|11063799006|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: 1L/w+wKJK5vwU/TPGRvGoTWS+vluGUT0TAWlxnGMmmJAtKOAgJ83CHSjzWxnrn6UCP5fiMn/EDm3sypn6KrZPTLnBYf7NJDp3VemvYnSr/F0r39YadMx0hoZIbtT/wDwda3uoO3GluPqsUKf6Zj62zHu0MXKTCPUGD6G8EibZgs9fTd46vkeuP3btXCO/XbOAYednXO9MX2Soj9z+fmvuySJXxc/pUkaBUP1xtz+ViM1UOW9oMsL0MT2xE8bOMq2tOlb31jAeVScj+cZ4SS+2vBx79tRrEG1ty6W23c7pA5N2at/06ydQWdCGzc2oHKBHO5Klv+gpvE5KfJr6xiD9j8+iFkd5QIb088altCVY60g9Gq4xBPn3rTqPssXH2XCxAWqjCNy/wqLpoeLs6DjR44e83p+tGg+qvq2P9Qo6FHl4wQ51M0AWL8mCPMa1JMZIlKKcanPBaRbHgdM71HsSXW/7v+vSLEg2dspJlcm6x32tDh5kX/Q8fSd8VqzLYavYc7+AnwKo9i/EzaKWeRbryxzN7hfVLwGPIp9ggiZH4N28CGp8c7ixVtxWSbA+jDaU3HEDBCUdZdhBYhrsXQXONmJwHt1deHXecR+5Ox0U/MKc3baDcrabGPZZfe7k9gQqv+qY2nFkxb0wEWe2981wJ+7xBX2N4uZoip2V+hsMzCafNwe//I1lEYfxwQ4kkWd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?32UlPrCLp0VakcyU94u8ghLQlu5i9Py12SFgjlRWFoOwJv3SwJXKFaUwHky0?=
 =?us-ascii?Q?Z7mH3E3Wyr0teL0mPC+euKSrYmB2TJkxaPhE7ytXye8cF+UJj9aauVnpsQVm?=
 =?us-ascii?Q?HCP/5lFZgeesqCoR2NEgXwiLL7XV7Di58+W7WaJxyrvYltMC2BmlnC7PzurM?=
 =?us-ascii?Q?hvy6jfAN4WORmS4ZyqBtmEZro2uwcR91te9AhCf0ivTXrmc9k5xsv40TxG5Y?=
 =?us-ascii?Q?yllAfb5/2ddXFZcQZn3yS/j2BqDA8dGorhggFPn1NcO8eVN8UnS7bbRhKwa4?=
 =?us-ascii?Q?/XUX2S62i4GpOb3zSQ2GZtqxzV4UAecY8akIgpsQh44UK6+vUyokKz/Vj0/2?=
 =?us-ascii?Q?AcBXOtQH/UHT0AhNoyx+wULs+E0Xt+2P3uKN8HhFvW+uGPMO6N2gq1Z/mp+k?=
 =?us-ascii?Q?L1GqL1qcciu0At0q/LM1v20rARhIxzMeStzxA92roe/+miH+oqz7yBrdXkBg?=
 =?us-ascii?Q?U3Ta39WSW29J1Ci6kZG06ATmRAxOW1E9o0ENPo0EFJz34hrIT6IP/Sth3mEc?=
 =?us-ascii?Q?iPbHX7UBkgxqzaow4EPH0ISrXDFzJMqesxI5ffRnIobeMZQI49qPtdl+1L8q?=
 =?us-ascii?Q?mSuYrQgbNJ5FHn/o43DiQOqN+g2ueX0xYZGIDJGscxIhIm85j9ITLitW2Ijo?=
 =?us-ascii?Q?SrS/fZiAegUfwLHa9AxRFXtOF1QIxQajBimLhz0cCofc76DFgc4RkgQWSHLP?=
 =?us-ascii?Q?VJudaoCdH5kPXz9NFniRsGRVylj4AECgol3a5d0Ypoa7Fai8vrfgSQa2jCl7?=
 =?us-ascii?Q?dfeGRAUeiGHJknkYObqyX5XuJk37/HGWxmdFSayUo6RnJ5sVozgDBzb9O0cP?=
 =?us-ascii?Q?BzMfQRVcpKMCaYL2pFkWUpchzNWrwM/BlyIsmLf6qL9txrHeX8TjHUxTf+re?=
 =?us-ascii?Q?cXU2SW9zecMA2GdBoooyZsFBv1wPgKjJkgNZlEKGHSLFWaL0AC8u8CVIPlfZ?=
 =?us-ascii?Q?wbYnw4YSr4gNnFio5fHTY0sWS6z0aFRWFGpBwJvyj+6JAK0vydtvLTIRxNm5?=
 =?us-ascii?Q?q/+F8eEpBoesO2znFCjbOb2BC/zk1eGTP8qJOjp9Ffd5fq9J5dOpoITvmIEt?=
 =?us-ascii?Q?eaV9QbthrqcU8R7CU4p+Re0NM/Qx3gSP2+rBk7b4GWvy6cjtyvBJ9FPkzu5M?=
 =?us-ascii?Q?iw66OkkhWUTiCEzCJV0b3N2OrNtw53n/25E9RZXCx+DVdWUeV2oB2jgslpmm?=
 =?us-ascii?Q?I7EdXx5BZwT+Ss1zqLyzg7xWKXhguiO7e8J3cFR0kn0D3nIVLAJElncHYhSK?=
 =?us-ascii?Q?HhX/3t5aT5anseN4bEWtBS/biWohF7FcjccBK/bXyqLWYQUj3RPcpv7qV0uY?=
 =?us-ascii?Q?IJZCeqDpn1qjFSG1yieeHawgTK9XMCHMN8zrvK1IBTXWOdRu61sq3VUDtxQg?=
 =?us-ascii?Q?GAovXivXaHvSK2SmZdlPHfFwe0RUl/mVqqIwpaeSoONeFLXTg4tfEa0k2N1T?=
 =?us-ascii?Q?/T2rPyq1JQZp0keV0NveuXuZDxH0O2WYXFiCCCTJPgrFhH9FAUJDMNkC1iKD?=
 =?us-ascii?Q?uAdxUE8h7qc0C3JFHHcTbb0mOgMLSxPCTBXGS/71wryZAZlceQuzDR/urDIR?=
 =?us-ascii?Q?0Zc7wdbo21KB3epevJegPQBnuJh9LLFDQ5U/zTVVvyFcg5pT0us9LdSQ8tVi?=
 =?us-ascii?Q?8z3xz9INnWHui+RpHE2mDPi7zVltPYLIVROjAVeMqQhhuMvFkcdskQ37x5/e?=
 =?us-ascii?Q?crlbI3Gi+PTeWbyTMRz3Jp0m/T2RFO8AJwwK8nLW1O/7qVaPBjeYFDoApGHq?=
 =?us-ascii?Q?wriRrhJrIaLEM0dXh1voIHeW0NBpod0=3D?=
X-Exchange-RoutingPolicyChecked: FxL+pb4exQdGTz96SiJTXSB+jA4J/8zmAG+f2XYKUfcUtyv0iYQYC18c+zh9hZBD+g9tIu8i8czqWg+fuAoy3BHjj0kaqmreQLPse8tr8ic1srDossuUB8PljFRVHKS4bPwEFhmzosyeqWILVe43hVG5Kg13p6CkbS8dV+wqyqh5dIiBfcJZSZKrbq7oRlk2DGpU5l7DkF4mRUPsdyKOkS0GnT7SoLCLPCjhOV+4Gu8Yp1O0dTnK4EY73AB2PxsOqflpnNORvA3meS1UqEa8YWygiByfEVfg0VpsR+KMTfVHYN+F5nDmYEoAPOTxbUTBHDlqxfr9nlZOKFZ3ZlFd9Q==
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f11394c-9a52-4f20-37cf-08dec104c6b7
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2026 00:12:19.2513
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8+fClp24Xmi/U3LSBJCFwx30yY1K+t8Cl/XPVAOtfe+a5LgusZEgj6V0Kxh4TJbK5GSbW3k6W0ycY7fhUOyCrKqKEKEiPiTocd4wyNRACgU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB9511
X-OriginatorOrg: intel.com

On Sat, May 30, 2026 at 04:50:35PM +0000, John Groves wrote:
> From: John Groves <John@Groves.net>
> 
> The comment in dax_folio_reset_order() claims that DAX maintains an
> invariant where folio->share != 0 only when folio->mapping == NULL,
> implying folio->share is zero whenever mapping is non-NULL. This is
> misleading because folio->share and folio->index are a union -- for
> non-shared folios with mapping != NULL, reading folio->share returns
> the file page offset (folio->index), which is typically non-zero.
> 
> Reword the comment to accurately describe the union aliasing: the
> assignment clears whichever interpretation of the union word is active
> (index for non-shared folios, share for shared folios), which is correct
> because the folio is being released in either case.
> 
> No functional change -- the code was already correct, only the
> justification was wrong.
> 
> Fixes: 59eb73b98ae0b ("dax: Factor out dax_folio_reset_order() helper")
> 
> Reviewed-by: Jonathan Cameron <jic23@kernel.org>
> Signed-off-by: John Groves <john@groves.net>

Reviewed-by: Alison Schofield <alison.schofield@intel.com>

