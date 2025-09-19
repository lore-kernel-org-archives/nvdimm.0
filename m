Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9482D4B68
	for <nvdimm@lists.linux.dev>; Fri, 19 Sep 2025 21:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758319122; cv=fail; b=djCS5CYvUL2BLRGgDpfqtAaU5/sKb14jSrM+9+uw7m0dpt4zzoJKL5QxTZLGB4bFo+gxbJa8eqZbZtecHSi9BrFedLD3TnV93T7Z9LTuDiXugyz28hKqPmzga6sqIMkUr3TUq/WD/mQ20zOW0HSXVmNZqQh4RWciPKgonCaO1aA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758319122; c=relaxed/simple;
	bh=u8mMHXT7rX9VaP4j4YOW/GDQtBk8kyAATny3jIElGn8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=V/FLFiiNSPxqIqBV9Kx80wiIgqIZo6/W+XV5A21kngWL3Aks8EZ1tDzHWFNtZVjRMuHRZs4N/eClTbGl/eABsM0xOE18SfvP69bb6aBqGd3xZYbvH5PHW+44qafmVdDPct9ekkqx3Ca42BXK2iQDpTgi+t7Botg+jmZIqUMMZQU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WQFl79Ps; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WQFl79Ps"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758319120; x=1789855120;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=u8mMHXT7rX9VaP4j4YOW/GDQtBk8kyAATny3jIElGn8=;
  b=WQFl79PsIqi1Lus7pz6agZhisBRcnnObdv7JJIpHgtJsTOVIEiE3fdu5
   ZmS3k43VDRyevS8fa0oQJoTnaJrknyO9RVKS3a4X7R+Xm3A/VeNy+5qMd
   CHTFbgkHcb0lI+Uns1fNTO2LoJoV/v2utldgqlhrNfM9rt7gf5p/OAFo0
   t0HECJQYpYeSgYOPMeLtSzQFsAC9Va5xwbFkbm4cXYxwXUi11XgpYXdgk
   6WSOSRPebvb8S17KWOAuH9yWkl7YQYWq1w9UHry0gkzCXXiD8FdAiSDW+
   jLkZb+DryUKxl81b/bvFKPplyQM3yuakR0hSe8Psw3x/7FmeChGs0wwvA
   Q==;
X-CSE-ConnectionGUID: wldF2NLOSh2tZE5QVvkkaA==
X-CSE-MsgGUID: IWfLAmOpSzuMXY/Yi9iTBA==
X-IronPort-AV: E=McAfee;i="6800,10657,11558"; a="78112721"
X-IronPort-AV: E=Sophos;i="6.18,279,1751266800"; 
   d="scan'208";a="78112721"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 14:58:39 -0700
X-CSE-ConnectionGUID: KMWhxsEjR52fT04h9b8Ssw==
X-CSE-MsgGUID: yEoubORVQ3CLvQxh9G0nkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,279,1751266800"; 
   d="scan'208";a="206686088"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 14:58:38 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 19 Sep 2025 14:58:37 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 19 Sep 2025 14:58:37 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.69)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 19 Sep 2025 14:58:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a1ssT8z75NMerlGPxl8LtWtEqAmPVDeeg1mJJgYLV69aHKKTADagM+myyZ958jZb20PsekP+qdelekcwSZkLTkzerSbQ7pQpW7B8+L2YqdJZCVoBz07Zg/frF9MRbvchPYcJWZ/7rjtwU9/qQNegXCm63lTMx4Yfu+8iUaQYp6ruMDoi96SZ9+gMLXRq/F0a45mtzrSC703RVca8EtBm99mcWvZ4DcySqe+P3psS5F3+j83bU4AXz3FrDM6WKVvqtYO+n6atr/+kbH3zCmgyFcOlzI5YbazR7comTBhBt0En5iXl0riXI3eXv4+21AaIS1RB34MYBEEb4xed/2CFiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Do0H/gK4dG43PA4Xf533vn7upeG26XpTqbrMGnpK3cA=;
 b=qGy9eVvcGtfaYsT87JaPREtsCfCV3hlvXKQDQOX3vFCu16SLc3h+KvASRJHZS/JnJXVqSOcp58URJlr+yAs4sntlYh+XDhLxQv8Y6iMvZChNXcQluxzDl62Iit2Z/ug7RmhKy9zsZoaZw6ybyHIAIaWfeJ1iesQQ+fX4fXD7yNjmPJ+k/mT33YLc44acxvLtDsjGKWrnXejfe8rWm6pgnCi+PW3imQbwWyYGAycevMYrNfyC6k2eoQxhRn2ZzNWxSKg8sREg1NTo+X1v7PHp6+Wjkllf3EQzsAhTlMkXVQOuu7br0jX4lhslJAQrGx8WcDUa0I4gFVyO7/bUUcAlag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA4PR11MB9131.namprd11.prod.outlook.com (2603:10b6:208:55c::11)
 by SA2PR11MB5147.namprd11.prod.outlook.com (2603:10b6:806:118::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.17; Fri, 19 Sep
 2025 21:58:35 +0000
Received: from IA4PR11MB9131.namprd11.prod.outlook.com
 ([fe80::7187:92a3:991:56e2]) by IA4PR11MB9131.namprd11.prod.outlook.com
 ([fe80::7187:92a3:991:56e2%5]) with mapi id 15.20.9115.020; Fri, 19 Sep 2025
 21:58:35 +0000
Date: Fri, 19 Sep 2025 17:00:33 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Neeraj Kumar <s.neeraj@samsung.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<gost.dev@samsung.com>
CC: <a.manzanares@samsung.com>, <vishak.g@samsung.com>,
	<neeraj.kernel@gmail.com>, <cpgs@samsung.com>, Neeraj Kumar
	<s.neeraj@samsung.com>
Subject: Re: [PATCH V3 05/20] nvdimm/namespace_label: Add namespace label
 changes as per CXL LSA v2.1
Message-ID: <68cdd281bd9bf_1a2a1729410@iweiny-mobl.notmuch>
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
 <CGME20250917134138epcas5p2b02390404681df79c26f7a1a0f0262b8@epcas5p2.samsung.com>
 <20250917134116.1623730-6-s.neeraj@samsung.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250917134116.1623730-6-s.neeraj@samsung.com>
X-ClientProxiedBy: MW4PR04CA0342.namprd04.prod.outlook.com
 (2603:10b6:303:8a::17) To IA4PR11MB9131.namprd11.prod.outlook.com
 (2603:10b6:208:55c::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA4PR11MB9131:EE_|SA2PR11MB5147:EE_
X-MS-Office365-Filtering-Correlation-Id: 051c672c-0c5c-48b2-eb8b-08ddf7c7ae94
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Ly9Cgxp4qIQkVzsBjQK2HgFoXALru5Jdc69kBN/2NtNzAR8N5aJBhvTi5NQL?=
 =?us-ascii?Q?RNQaJabMJ0PQR0equ3Yf5tAVcDR3u/yEoJrSPlH4Zmywjf1KOvfd1QyRAsZp?=
 =?us-ascii?Q?hVRNDQEFAY1DLUvlJ5FuXzSA4QbPRG/1uYtEFc6TpalaS5X5XQLoFhMu5o67?=
 =?us-ascii?Q?KYF952EHo4op7GnNls5cyyXJXx5DRJUe5XhlQbCB2X3T6ws/eg7FuE8dQKL8?=
 =?us-ascii?Q?reBS9z0pACcWSTBhm8Y3nxYk4C1FJy1pfCKnjRSqPAgtViZni31gkxcSum/8?=
 =?us-ascii?Q?wkhzOX2LJD57AKaDRk0XWmowyyR3z5y3AcdZdeLeO5T/nyavZM2FFfEMSl6L?=
 =?us-ascii?Q?LSpF0cnq93G8/wyT6+1vm9OyVRFkDXW/iGdKuFCLv5RbqCRinGX1ZzbWo2h3?=
 =?us-ascii?Q?SV41LaxGUzFLmdqXjPrz4UhLdjPFCZnoBZ8L3b5ju2vK2DaJdvciMm/1ybQf?=
 =?us-ascii?Q?Ier6TqCWJUl6byTgCRm1DbiDbV7zoV9f8EuakFdBnzh+YoLIxFtoZYt5rqsB?=
 =?us-ascii?Q?X07v3ngXAEVZZJxc3tIMHvOLtWpK++lzTExQdhQurFcC+o6R8cs++5kl1sBv?=
 =?us-ascii?Q?i/6LMuIHRyewzzMiN351fBeCs4o/wKNCKzOG9SEGsMv1XacxvudbhKdnpF+y?=
 =?us-ascii?Q?f5OonOaPQDosvIWu+LYSKPja/ZlsscJV18DcAYI+YGyvFlUBWcUmX0M5LXI5?=
 =?us-ascii?Q?dcBvWnFH2duwr5GnY3wVv3xNPxuOT8t4n5QlmH8l5LNbMInR7FKGstO/xbGD?=
 =?us-ascii?Q?tLEGWhSJQd80/ix1sCZyNbOxw9mpYk1XiMb3rWBWpiprZcsoA2qz888ObPED?=
 =?us-ascii?Q?abs/lO63pMA0LSKFXFjG8W97O7FK3tsRYa0Hyq/MOKDzB8ZUvhxHzliZRvdG?=
 =?us-ascii?Q?9dSt5d8Y3Z/S1TvRP2itNTswAzHX9G3hgD6ZhsF+/mwtdf21L+Ia/F8dN56a?=
 =?us-ascii?Q?w71cDUovAZDeGPqtyw+ZI8xQ/UyqBFf1HbEfTjhy+rVaB5KHhbX+wSIk7D0z?=
 =?us-ascii?Q?PstnoUP9LhG9KKs/gAuXnS3ysMhq2NrX31GZusAL1HGiHgNhFo2u0n1WqNU8?=
 =?us-ascii?Q?8LFyQjPTDW+XXCcoDh2Jt6OhZuzWA6UDhUU+dOHQs3lRNjYEyHLB1HK3BrM9?=
 =?us-ascii?Q?0LFsifoCNCQuo7XOAzTTVF0YO/NEMQZ2eqICWXm62H4Jlyw/NIIvnOAQLr78?=
 =?us-ascii?Q?TcJBNljnXWhd1Zxj2xD487wsgcyM8CjwwYvx2Y/m0lCX7I15EYb8jwsewz0r?=
 =?us-ascii?Q?pVF5b7YkbJsPUCw7uIEpkP34+wXR1Pe5Q3Xt24L9wQbHkpIHVikiuCwxEChk?=
 =?us-ascii?Q?JAxG3GfeM9DFByXuojxyj0RFEsteTjI25ffX30xx4uxyA3Z782wlL3sAO3KX?=
 =?us-ascii?Q?Ekk8TnKQfn9Lv6A+kjfHqZFr+UTGg9lDeElcI+/ENwT8QCLvcw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR11MB9131.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?w9SlZWFu3epXcnAFZ8JF028T840nX/qPzCy+t7SD+hw0H68RCgaROqSnX/or?=
 =?us-ascii?Q?1PmyYBogFe3aMvyXwpM7n5ihhkEJWTa2IajFw1zxz/DePnE0dE7SJZIADB44?=
 =?us-ascii?Q?MiWasK1b4gquH6RHq2f2hVzwFIWLTxrqwWgqFW9oSCui73S/LlcoaOAb1Xnx?=
 =?us-ascii?Q?j1x4JjsZJRK6OL1OsSefJzlNSR4LcnbYKz5NzyPVHeAUCIjs4kZ7irQIXttc?=
 =?us-ascii?Q?j07tq4Qxl+AxatgSmHrxDLkKuvoem/wApPMEZW6/0LHeqRe4tQSenZ6WOQsc?=
 =?us-ascii?Q?sX+JFFIGrqBbLRSCmLw8PyLMBDX6CFnhc/w2i6jUtd+quGwTved0zUdmZaFv?=
 =?us-ascii?Q?vFyUes6rmOw84GH4NGnVfboJoS6sjKMZYncZN6tsoOssuHE0ItEFRwJSOHtj?=
 =?us-ascii?Q?ALWpkV/zQHuM714Z/P7Z5MVUq2Vyw1+9yHzU2gDsAizhYoVml5/0BxfT6jjd?=
 =?us-ascii?Q?h02WSaHIqBEzwgkRYV8mjS0E7lhMcZwkM1O7XDJHBf9AjGvldjNCvmPpupMn?=
 =?us-ascii?Q?Xbh2AToh/MDZCkQF5ONa+dNzVMxC6zQtV/bxCdk6F2LrTf4TUCJoADx2qA5C?=
 =?us-ascii?Q?Pj53Oo66nrII5TyxoXlloBIpYOJcSnpWBGR7sMWx2AKWUyi9vsOeGnSaoQhH?=
 =?us-ascii?Q?GC7nuSpfnu1uRdqMvVkI87I5n5j9/HMMp5/TBWuwx1T5SkEgWEINC+xjSsUT?=
 =?us-ascii?Q?CJoFsQjhbXoUiSPp/vR7D/8gWE9tDco/coIbPizcllyYBOb+4/9oA/XG29JB?=
 =?us-ascii?Q?p5suEdRnf9MHWpEwDnNqopWjXvUWpB0JWlZ+udF9577AWCXuTqJDu1KIzn3S?=
 =?us-ascii?Q?QRU3t6RfiHnqAP9En+yeK1OBciovo7fm9ZG4Tfe+jewREiEnzDWNOZOOXXTZ?=
 =?us-ascii?Q?dhTePkg2K5kKeTnshjSqgN261pQgxM3ET0YPkXbFcNjvnhTvrWQ4IV4FrvSy?=
 =?us-ascii?Q?dzMACNGb8VkE0/wshDn+zzAzNCsM4XsrdHM329YrVDR0uNmQTR21X9krRP1W?=
 =?us-ascii?Q?+FNkMfap4sfJk6rFSToH4tOn5K+Hur0tuBMrOYNfyicBuB5tGKhTeRHPv7Y+?=
 =?us-ascii?Q?O4T2YYYppP3b+HKjvVxhH/1mOxxw3mvTnkPMFhC7wLpHbP5/t5+Muu1eTNn4?=
 =?us-ascii?Q?mKWKvQsd39Fq8vN4FJf6J8Iexl0zc0mRXcfXIfEnklDLeMzzKosU3hi8U17d?=
 =?us-ascii?Q?KxkEDsF8gwcbSjL1hQKtESPXL9PHSe/4Q1zVl3B7qWrzGnT+zMaZhkPSZDtc?=
 =?us-ascii?Q?91zEAcQ3t5TTrdfms880emgnSrbMuIizJ1h1CkrXQGb8o3Hsv+1vX27bPXcc?=
 =?us-ascii?Q?Gnti6axrAcMV4gbfkIQAmMpjQaZ8kEAqheHTEj9p1o70/buKlHnaeLFt+uhI?=
 =?us-ascii?Q?uPqsBPRCxCAkH41VzZjJTrOEGG+UKhVdP7u0i9KIvA8MZ3kDOxLEDzmJ3Wlz?=
 =?us-ascii?Q?igBfzIboNa6pvokx5PqnuaWEM6W+KJhdPRPqnCjEhwdnG7BHUtXoNCucNyTq?=
 =?us-ascii?Q?is535LIZ5QFV/+pn91ywIMxkDPz/WrXYTqwTwCkhyBhC6I3NOpMg6BKyhvub?=
 =?us-ascii?Q?KpXnRbNWk/60ciA0Il2VhPaA/nwkMPDo7vwelNDX?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 051c672c-0c5c-48b2-eb8b-08ddf7c7ae94
X-MS-Exchange-CrossTenant-AuthSource: IA4PR11MB9131.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2025 21:58:35.8237
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mEbVi+e9vhy66myQcE45uoUdoWsg7eiMaZ/Za/YVO2hbYH3sojR2C8VAuv3pgdVnO3bnpiOnSDlUsKKeP2WKqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5147
X-OriginatorOrg: intel.com

Neeraj Kumar wrote:
> CXL 3.2 Spec mentions CXL LSA 2.1 Namespace Labels at section 9.13.2.5
> Modified __pmem_label_update function using setter functions to update
> namespace label as per CXL LSA 2.1

Again I'm curious as to why?

Is it to be able to use the setter's later?  I see a call to
nsl_set_type() added later in the series but then deleted in an even later
patch.  (??)

I don't have time ATM to really follow this through but giving a why in
the commit message may have made this a simple patch to review.  Now I'm
not clear if it is ok or not.

Ira

> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
> ---
>  drivers/nvdimm/label.c |  3 +++
>  drivers/nvdimm/nd.h    | 23 +++++++++++++++++++++++
>  2 files changed, 26 insertions(+)
> 
> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
> index 3235562d0e1c..182f8c9a01bf 100644
> --- a/drivers/nvdimm/label.c
> +++ b/drivers/nvdimm/label.c
> @@ -924,6 +924,7 @@ static int __pmem_label_update(struct nd_region *nd_region,
>  
>  	nd_label = to_label(ndd, slot);
>  	memset(nd_label, 0, sizeof_namespace_label(ndd));
> +	nsl_set_type(ndd, nd_label);
>  	nsl_set_uuid(ndd, nd_label, nspm->uuid);
>  	nsl_set_name(ndd, nd_label, nspm->alt_name);
>  	nsl_set_flags(ndd, nd_label, flags);
> @@ -935,7 +936,9 @@ static int __pmem_label_update(struct nd_region *nd_region,
>  	nsl_set_lbasize(ndd, nd_label, nspm->lbasize);
>  	nsl_set_dpa(ndd, nd_label, res->start);
>  	nsl_set_slot(ndd, nd_label, slot);
> +	nsl_set_alignment(ndd, nd_label, 0);
>  	nsl_set_type_guid(ndd, nd_label, &nd_set->type_guid);
> +	nsl_set_region_uuid(ndd, nd_label, NULL);
>  	nsl_set_claim_class(ndd, nd_label, ndns->claim_class);
>  	nsl_calculate_checksum(ndd, nd_label);
>  	nd_dbg_dpa(nd_region, ndd, res, "\n");
> diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
> index 158809c2be9e..e362611d82cc 100644
> --- a/drivers/nvdimm/nd.h
> +++ b/drivers/nvdimm/nd.h
> @@ -295,6 +295,29 @@ static inline const u8 *nsl_uuid_raw(struct nvdimm_drvdata *ndd,
>  	return nd_label->efi.uuid;
>  }
>  
> +static inline void nsl_set_type(struct nvdimm_drvdata *ndd,
> +				struct nd_namespace_label *ns_label)
> +{
> +	if (ndd->cxl && ns_label)
> +		uuid_parse(CXL_NAMESPACE_UUID, (uuid_t *) ns_label->cxl.type);
> +}
> +
> +static inline void nsl_set_alignment(struct nvdimm_drvdata *ndd,
> +				     struct nd_namespace_label *ns_label,
> +				     u32 align)
> +{
> +	if (ndd->cxl)
> +		ns_label->cxl.align = __cpu_to_le32(align);
> +}
> +
> +static inline void nsl_set_region_uuid(struct nvdimm_drvdata *ndd,
> +				       struct nd_namespace_label *ns_label,
> +				       const uuid_t *uuid)
> +{
> +	if (ndd->cxl && uuid)
> +		export_uuid(ns_label->cxl.region_uuid, uuid);
> +}
> +
>  bool nsl_validate_type_guid(struct nvdimm_drvdata *ndd,
>  			    struct nd_namespace_label *nd_label, guid_t *guid);
>  enum nvdimm_claim_class nsl_get_claim_class(struct nvdimm_drvdata *ndd,
> -- 
> 2.34.1
> 
> 


