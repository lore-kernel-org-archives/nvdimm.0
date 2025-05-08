Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B40622A4CA
	for <nvdimm@lists.linux.dev>; Thu,  8 May 2025 13:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746711290; cv=fail; b=SlW7AZQBLf2uPxN/trJ2w1jgg8k0VCLmkgxWtE2R11Y8LxWPKxjJrAKF75/fg9WXejMt24i8ctbceemDBpwnIBgMZgHtXbc/gq11iWzi9LnaWB1y2XUEEkZ2bIpaM5d0I30xgGa3cWOtHFysXEEKHjmcm+Jd4K/QgdYKEUCDlu4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746711290; c=relaxed/simple;
	bh=/x2IIfVjaIzmFNvG728C5I63pwnPKbtQAQxwejWUSiU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=iboyXO4Nd1BWGEMllpmD5vKMtNXey4lZvDjPuUMQmCiI/VtQ42OZuj16oMA4zUhGgynhfZBBtXQvs/KOieAxTZoOmL+cRQPHBajYdqp2GWs8s4vaL4/AwVS3D8a4/YcsnD7Gq/EMWJZx66PRrCQEI1zzjogbVXRSJcMNbL+PUgE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YfbTnJED; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YfbTnJED"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746711287; x=1778247287;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=/x2IIfVjaIzmFNvG728C5I63pwnPKbtQAQxwejWUSiU=;
  b=YfbTnJEDF4CQc+4MndIqpvxkkv4icHhQ4jLFPwAZswAgTjA4zL3+MKAo
   25h2kdfuM0VFieGhGjOMM/vrmQ13CGOjc8RJr0HcJf+70fO0JkoR8ayuq
   RJOMxnEBa0ZtSnAegPM8pN7TlyJ4dlM4CZEREBqtrEoCVlEP4lMch7Vwd
   kU1opQic+NyE77YZep7G8yhtiLJgs2Me2vQbG4z4FAlu5cOEUOF4NpacX
   RLgwawg28rx65xCGwL4SX7Dw9/QQ3RvCbio0ZJatGRFr+MMle761WGi8a
   yW4QlvwWHiQFrY2C/biJBSLA7jv1D6libMN8cjDCjT8B3ScxV2d4ZgcqW
   Q==;
X-CSE-ConnectionGUID: x/yy7eDKTWGYIooRWP7zfQ==
X-CSE-MsgGUID: 3dJBsAGjToyOZf7jbmS4NA==
X-IronPort-AV: E=McAfee;i="6700,10204,11426"; a="66029769"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="66029769"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 06:34:47 -0700
X-CSE-ConnectionGUID: itlNUD4XRnO3IAKGb0cv6g==
X-CSE-MsgGUID: 5BUscXdoTO2rzhNh09qJsw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="141192903"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 06:34:46 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 8 May 2025 06:34:46 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 8 May 2025 06:34:46 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 8 May 2025 06:34:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b+m7lrCi+ZUDDzTK+G0IhdncDJlOKUgPfEaqmFbNHQA9kek/lJkdwsXblQdI6FUam6egB0CKvJ6Hv0tBAfqawii6RNVrkU0GVB9LK8OAV+N1h6JRK0H7nWQQuz6DlDM0ra74/BvQMCjqJoo1QZ06jtVijb4GFZF5CbEonNOelGHlOoJsxDHGvKdHSDcI+ebJT2iC50f2OTUGjthuwcKlNYwi/MzQCLeUhnoJMnVI5N/HW7GzPKjXjCvs/4c5VDTT4bbyX5xGJpzO2L2MMicANvEjARNBz3rGuGIEKIFwozE2Og8hjg6r2N+dZBwAw+Tuyvfi7wqRulf6d3ak9DUN2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SHhvGi7yy449fkQcH5c/KWcAJ2XQZQPD9H8jVVrsOFU=;
 b=CIhYZfnCVMkCaBF2/mPPtgSgmr67oswAoxFPVeUi0WhsZhjR2EtLYuKA7Jc6ml32XGy+2FsoLmCKHYUg/A6/SqsAMdxMQQo4dgRJ+5/IXO98h3hFEvJaIHp8ZYOA4CFp5+R1F7bIfyLYdoWuLhU31a0+EXknzr69gLC4xfXRPKLetrJn4i8MvuiAoNZCMzTkiYt96AkM+UrILFA2rcmADLHdJ87mR4T60L0a/hSa3497QnJAhPXCVxtRAXvHm/4iUKKmv+Hk9cbGCEIepKKNHBm4wrQzo87T5XlEAC/fn0U8h/RcH00W7E6D176pXAm41RCJbGFBrQTVrpXTow6CXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by SJ0PR11MB4911.namprd11.prod.outlook.com (2603:10b6:a03:2ad::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.23; Thu, 8 May
 2025 13:34:20 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%5]) with mapi id 15.20.8699.026; Thu, 8 May 2025
 13:34:20 +0000
Date: Thu, 8 May 2025 08:35:05 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Fan Ni <nifan.cxl@gmail.com>, Ira Weiny <ira.weiny@intel.com>
CC: Dave Jiang <dave.jiang@intel.com>, Jonathan Cameron
	<Jonathan.Cameron@huawei.com>, Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>, Alison Schofield
	<alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>,
	<linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 02/19] cxl/mem: Read dynamic capacity configuration
 from the device
Message-ID: <681cb309a86e5_2d40892946f@iweiny-mobl.notmuch>
References: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>
 <20250413-dcd-type2-upstream-v9-2-1d4911a0b365@intel.com>
 <aBubH5ZDVPEE8N98@lg>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aBubH5ZDVPEE8N98@lg>
X-ClientProxiedBy: MW4PR04CA0127.namprd04.prod.outlook.com
 (2603:10b6:303:84::12) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|SJ0PR11MB4911:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e64030e-a806-47ca-e005-08dd8e3509b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?C16/RHa5fOhZSmtH2YVUwPVxr85K3jLSryk6/Pnxens92yu6Xa/f4PUVmTyX?=
 =?us-ascii?Q?dR61VpiZT8E+ZLyui0NqcFXBYkmtmCMH/O0mDpXRnmTdKyX53VpTT3tvmv52?=
 =?us-ascii?Q?k+fanQdwh8zESCOp5VnJw157WgJt+4A8w6YJPH+040c7WKDbRbfDX9fwrCnc?=
 =?us-ascii?Q?amGN4nWVy2+uWDVxWCWtOsmRV/ug0hoLH8NXLxY1t/208N7/NQQxlbgFbPQf?=
 =?us-ascii?Q?tuR2iNBg/On0/qUr5IK5onYIfbP4j98r3iuThoIXLZ8aIZzZ5u5m8W4AmCqK?=
 =?us-ascii?Q?zwpFT0bSsnnXMx+CsRQcCkMw+WXXLm+yf3WLOxhlj0YhGhdqKSdnebJ5IyVu?=
 =?us-ascii?Q?2Tf6McYkn8GiNwSfWj4fr1h0xO42s/gX8kg/Ddju1AYYiN1jg1jjXGusOM10?=
 =?us-ascii?Q?ux4O3DhNrodRYbRT/Xn++71aNlnNhHSYcKdO5zWV7kcAITyy3+wj+VKHMPZ5?=
 =?us-ascii?Q?W1gHLnma/5RsiYn/hbaOHQVCgk8Sip4J6W8XNG5GYNcqXwYBO2bGFew48MH1?=
 =?us-ascii?Q?bYjNNHrAu8Ny6Hlyt1obKCwZvs7F3330lhmKBzD6KxDC0xEv5wL1ajV5wMir?=
 =?us-ascii?Q?/kfkZPlUz9g8GW2wvfOABGWNPh6OS1KrTlEzJXObgV/bEzil689zOg5YdZFq?=
 =?us-ascii?Q?/i+viUBIUTNzwthIWCzHuMmCXjAbtwUn2woJOFX36BcgFxIB4B/9AxSh2vYN?=
 =?us-ascii?Q?jeIcQaGtzhWlsZaBAvLI+4xvyZYRIzubpgsTVI/XeE3W0eY8/mfYusALiapR?=
 =?us-ascii?Q?Pma5GUjdFJikK0oAf4e0g7ZsKxQhYUASJZp3sCDBFzSJxmJWPuZR/p6QKwwP?=
 =?us-ascii?Q?Ak+Bqem70z5oWHA3DwPSDgh4GnfUrvmsIO7XwFspN/Zd/Xr33AJrw11glYmv?=
 =?us-ascii?Q?W2w1VFVgTsbu2dH+ygoKLPLt7gQZg5cAKNJvbLuKmtT1LsSHp7S1IYo0SC9k?=
 =?us-ascii?Q?ocTMhT9hLROTb4fNh41ujzR0eZCws6g95BokYfqaitbIGzFaalxHJ8OMcQRC?=
 =?us-ascii?Q?NNKlg4ah6SCBoIsJh0IfyIINS0+P7t6Q61Qyf0zL9AgWCSrqr/CeLuFAApQD?=
 =?us-ascii?Q?gjBoM20vuDVVp4HBcVW03wz2ShOPb9kNxpzGllcet3nbv70Etze0qoKpBRD8?=
 =?us-ascii?Q?knnKBUymANVe2FOlc/ciu0V4BZxZmacot5iUfZLOw3KFluNcv3S87b3BT5mY?=
 =?us-ascii?Q?Unei8fD9EvOdOB/GDmG0rvkh+Eivbk019T7o6QxYpV/4TsZaSr7FXRQn6xf1?=
 =?us-ascii?Q?kkvTsL0Zs7dl/8fFGwqB3/0LQzNgzC0s/P0g7Fpcv42GHVY1swuR9I0Gi4RY?=
 =?us-ascii?Q?WHPcV+WXRtN3wal1xRsMgLgP/tMatxTmNxQk0lnOzPTWGGOni4DyP37HAkyg?=
 =?us-ascii?Q?moWz9nOx+dGg6IiUD6D6nhdaKhIk8t7DxCFGr+7QrwNy0YBho/9OpqnBEHgq?=
 =?us-ascii?Q?AeXAFwVQD1A=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xdrSLF4iHDJXk5SO2lfUxuuMghVVAQCKzkJ45gomAupdATuydX7hym9Vq5fv?=
 =?us-ascii?Q?clwCR8Xl5otmAcmwKivNVbCOq1KdbkGZeJjpI7IytILh2HdViFduzbD0tUF8?=
 =?us-ascii?Q?hkXlJZtZnlqngMabi5UZ6QVONB4lHfK4TF/8/mKCq9itjtHxRLNS1O418Nl/?=
 =?us-ascii?Q?KMuzkBvfRiu04PsVQqSc/xqlYjBB46HZ8P1xGZmRSptJLGvgxSAGpoIWCngP?=
 =?us-ascii?Q?SGhTa3/Wct08z+mgyFAHZaLeT9LHzM0P+QoPXPMuhRSRo1Vkmh266YBEZqGi?=
 =?us-ascii?Q?yiHl/uj4FV4cIiYVk+giM+Z7eXCQA9Yu1DqKQmFvE1rFUDEVaMbiGXH0Wy3K?=
 =?us-ascii?Q?J/FXHaAFmdWPpBs4Q4rnSLgCUrWWq6jW2l0eqLkDcmrCGcl0dgbNGPPChy8W?=
 =?us-ascii?Q?b5INZ5auCvNcngHL64tkgNNIjJV02QUyIv4PHXU1zSVn3OoCii7pNBVQ6afS?=
 =?us-ascii?Q?xL4RYxVrxxLqTMLBZJy9C3GqKkGql+YYhpCz+UbhJka3K203Nrk9MZgo1wr2?=
 =?us-ascii?Q?0QvGOyKj8dDPx+VvuZksgr1DpXqj+NsuoMUTnSWlLWJEeLG332FUvanCutjd?=
 =?us-ascii?Q?/99Wn4EXpfpCP91EeOBLglK4HJ+ssyzaGa31TGtLZdlBY7j+O4ac5gd7O7h0?=
 =?us-ascii?Q?vIs1z3aweUvyEo4AFS4Da2r2Ybm/kjt+LeVAJKwgFRV8lrLgsA0bjlt1sSIi?=
 =?us-ascii?Q?syWGbVeUOzL4sTVvebxwdWV92BkeEKzSt73mMDwl4IsaTqloDxi5wZkGUNCK?=
 =?us-ascii?Q?Rjkk5XpapAPZuMYb0YBDSOlDAJM7E9Kd5iK2fCd7CnSQ31WqtxivCdFwTChO?=
 =?us-ascii?Q?/dBJ9jmvrcN+1zSm/1h/+12mqfjq4H0UDZPu8ZgO9j+fQqHxMXcBjPjArxGa?=
 =?us-ascii?Q?Ggq9k24ewxTgjMwAHcWMVozhrNvJPZDmrUEKMuPe0vHXBt4FH9XgS6Q2mC7A?=
 =?us-ascii?Q?Q4aM+aFM9Hd5S6dapxz8AubF2fUsRtFm2zgG+P83YYU3jxjRlsSriw1K+UJC?=
 =?us-ascii?Q?ICEKQnmV9aCnPVwlgc1Mcfndptz1zPhAFKyCFuLTsfL3B8GI8bIYQgcYTBDt?=
 =?us-ascii?Q?zwzITthZF0E2VXrMKNWdQbTBkLHQYZSYYLVXf4imnsNNMDCcq3N+U5nVsMHX?=
 =?us-ascii?Q?dwp6oGcnaAFxQvi24hygsFFEx9rlZnSvg9299ncAW5BAmUFM7rUzo6hQtgYI?=
 =?us-ascii?Q?0inB5EAtvUOjhwpd741NQHtzwkDdObVHQfSL9gStqj6Vldm2lb6kzRpBf7WL?=
 =?us-ascii?Q?Y4Lo5XDR5JAyD0B1E493nYauEN3uqZVGE6L8Reb6xS7DSKPkcXZmZ9OAHOeR?=
 =?us-ascii?Q?KxIdvGGSQBxbt7bfyT793Cr+AsPLxynqMiurlyED1ZEtQ+EcMWgaePhQLeLz?=
 =?us-ascii?Q?1ORXDym9M5dXSfQDFZNL/y7JBMRNj8nXfvE6m/i9B79iaRQy3mlMbejhbuah?=
 =?us-ascii?Q?osYXkxHYgfkDwT6kePQXobkZZbiuKOUasVwW+HPmrHZi1SOoftOnfw46SvWX?=
 =?us-ascii?Q?s7tQe05w/wRFa6y57H4ckgQO83G6m3UE2euA3SSPgWYzjfEo6V9wMWpaR/LM?=
 =?us-ascii?Q?JjuiZrmW08VhhFvItwczxi/oRazoon/B3o5fIXIV?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e64030e-a806-47ca-e005-08dd8e3509b5
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2025 13:34:20.6359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wmdQP1lf96q62VFl1KdCtcGZwRyrcQqqWTVXGi0v1xvjduHPw9lyXDFNeS/th4FOX8TkKkbVkLmIpT+uArIHcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4911
X-OriginatorOrg: intel.com

Fan Ni wrote:
> On Sun, Apr 13, 2025 at 05:52:10PM -0500, Ira Weiny wrote:
> > Devices which optionally support Dynamic Capacity (DC) are configured
> > via mailbox commands.  CXL 3.2 section 9.13.3 requires the host to issue
> > the Get DC Configuration command in order to properly configure DCDs.
> > Without the Get DC Configuration command DCD can't be supported.
> > 
> > Implement the DC mailbox commands as specified in CXL 3.2 section
> > 8.2.10.9.9 (opcodes 48XXh) to read and store the DCD configuration
> > information.  Disable DCD if an invalid configuration is found.
> > 
> > Linux has no support for more than one dynamic capacity partition.  Read
> > and validate all the partitions but configure only the first partition
> > as 'dynamic ram A'.  Additional partitions can be added in the future if
> > such a device ever materializes.  Additionally is it anticipated that no
> > skips will be present from the end of the pmem partition.  Check for an
> > disallow this configuration as well.
> > 
> > Linux has no use for the trailing fields of the Get Dynamic Capacity
> > Configuration Output Payload (Total number of supported extents, number
> > of available extents, total number of supported tags, and number of
> > available tags).  Avoid defining those fields to use the more useful
> > dynamic C array.
> > 
> > Based on an original patch by Navneet Singh.
> > 
> > Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> > 
> > ---
> > Changes:
> > [iweiny: rebase]
> > [iweiny: Update spec references to 3.2]
> > [djbw: Limit to 1 partition]
> > [djbw: Avoid inter-partition skipping]
> > [djbw: s/region/partition/]
> > [djbw: remove cxl_dc_region[partition]_info->name]
> > [iweiny: adjust to lack of dcd_cmds in mds]
> > [iweiny: remove extra 'region' from names]
> > [iweiny: remove unused CXL_DYNAMIC_CAPACITY_SANITIZE_ON_RELEASE_FLAG]
> > ---
> >  drivers/cxl/core/hdm.c  |   2 +
> >  drivers/cxl/core/mbox.c | 179 ++++++++++++++++++++++++++++++++++++++++++++++++
> >  drivers/cxl/cxl.h       |   1 +
> >  drivers/cxl/cxlmem.h    |  54 ++++++++++++++-
> >  drivers/cxl/pci.c       |   3 +
> >  5 files changed, 238 insertions(+), 1 deletion(-)
> ...
> >  /* Set Timestamp CXL 3.0 Spec 8.2.9.4.2 */
> >  struct cxl_mbox_set_timestamp_in {
> >  	__le64 timestamp;
> > @@ -845,9 +871,24 @@ enum {
> >  int cxl_internal_send_cmd(struct cxl_mailbox *cxl_mbox,
> >  			  struct cxl_mbox_cmd *cmd);
> >  int cxl_dev_state_identify(struct cxl_memdev_state *mds);
> > +
> > +struct cxl_mem_dev_info {
> > +	u64 total_bytes;
> > +	u64 volatile_bytes;
> > +	u64 persistent_bytes;
> > +};
> 
> Defined, but never used.

Shoot...  That was from a previous version of work on type2...

Thanks for the catch!
Ira

[snip]
