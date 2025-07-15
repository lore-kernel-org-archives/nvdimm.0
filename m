Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB4A1DF98D
	for <nvdimm@lists.linux.dev>; Tue, 15 Jul 2025 18:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752603352; cv=fail; b=PAaYWlMr95JBbsLSjTuruwFQYr+PFPmCwl5w7ipKarfJx6K2gYjuUuEinqzz9NLoBE+QUlyeZlYwu/Zmn/Tzh0HuRcKst2nWqOScuooP4DIA5gy1WqDv2jAJA92AFY8BOWQseEjHASDVbaoO0mFTuhB4dl+RhjJCo863rndlBSM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752603352; c=relaxed/simple;
	bh=KfeFDjHVhu2LqWELOYesJLEdQkywglXQBMteRO+3oJU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=KB0OdHHLC+VdApUdfmE6OcJ7ItOhdqqLe25VOXarrXnwrCdJ5tATibKcJr6fCOx6g8PmyWkfIlOt6e76cweXEJ8ZztcwcYHvuTb1dRvLbOs9gMnt8C7PU1QcrK21diCIdFLJz3gSH8Nsre7UI8gAMXKcTJYqnrcMNkp25GrMnAw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ixiZ1BvH; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ixiZ1BvH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752603351; x=1784139351;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=KfeFDjHVhu2LqWELOYesJLEdQkywglXQBMteRO+3oJU=;
  b=ixiZ1BvH4Q8SmzUw+0ZGI+kxsh/IkDuQgy2MW1bV+IMnPGFEtQWn84xd
   TN0EJWDHZlzLr/x+dRXnKfQ8xexr/vWbhyctl1TXtNXa/knWMRwTIUseg
   AsSPzR2Y7Z/flO5m3bRQg8ANHRmesQxU7dAntFTO6iyTutyjbfkjsy7a6
   iUfJR2/f1ue2FBCBW3iT/BHhp2WuqKJ2ahF239JMBR+2zqf4SAVU7WfEn
   ehiFa7cyBw6LPdGtb2oyWJn1tayys30Q+womDwiDlwdkRvtC7A8ORL7nd
   mAofNhCQ1pdGEZ5lThFU2PHw+dneDPw9CXv0jTauL8ttH1/4fY7Tlf5oy
   g==;
X-CSE-ConnectionGUID: cYLqkq7ZRxC+nI7N96WhwA==
X-CSE-MsgGUID: RtbTFpw2SkCIg31X7U9QiA==
X-IronPort-AV: E=McAfee;i="6800,10657,11493"; a="54811253"
X-IronPort-AV: E=Sophos;i="6.16,313,1744095600"; 
   d="scan'208";a="54811253"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 11:15:50 -0700
X-CSE-ConnectionGUID: +6+TWqgHSKeJcEXcCsMsWQ==
X-CSE-MsgGUID: hbxU0UjBSeeCsi3cyh7+Ww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,314,1744095600"; 
   d="scan'208";a="157095036"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 11:15:49 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 15 Jul 2025 11:15:49 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Tue, 15 Jul 2025 11:15:49 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.87)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 15 Jul 2025 11:15:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mV/d3GMGO11tCLv1BWri4OlG0cQQpiTP+p6WbxoZh9C9rS+i5vtNN/JTsyi4Tw9Sdho5d8XE++31G/rIhJPPUF2Z1u3RE2DryEHwVwV0/Kv9c7avN/keNfOpac80g9QjGGBiUIJan8FMbKLf7Y2uZT2uXQEA3sr3rhKIDAiTZhxAjf/RZW0tDz/TnYw/705ztKren5gkCwkqrh2no9cqRGJdmWaPi2+NTEzM3hTxWyz8mMdUp1vuPhyCX7XdpHWuV1Kflgq/s8pnPaFZ8ke6mRg9eYUUVmsjFXFA+ht6oFvUn4TU8KbmrLJSd/J2NORdQPtLCGhu9FdGl9CjQRq3Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BE8ZNKUeYOHwrF3fPGMgmkDSMrsNeheY5Fxenf2fMUg=;
 b=W4kbGVyOdwjH473jjky0vgN2uKnSDjhlUtHKyHgIBPTaNdnle/fggHBSMYKuo5/8zUbtIPK+EXP9RzADpL1C5K7889y0dlhXDCPD5BlC7N8JwHQko8/A7rE4+3HH342z0F6pu/mfK12i3Po5TD4AiypToA8vzp/e8epQYHOAGSxcUk70Ig9CUJM/muXteQ9Lx0hflNgSi6cNw8xMRHSAFe/1BjurlIa9LI4KGPcLv1U0MjKKc6BYpMnCtj+FBbqrruspfqK+WkiJTLsF+10w9SAJZf22OztHV2Rab9yHQ+otFWqC2G78HcLewdU5klLaLuycdFIJGw8yorpVzdBhqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by IA1PR11MB6444.namprd11.prod.outlook.com (2603:10b6:208:3a7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.21; Tue, 15 Jul
 2025 18:15:47 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::8254:d7be:8a06:6efb]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::8254:d7be:8a06:6efb%7]) with mapi id 15.20.8769.022; Tue, 15 Jul 2025
 18:15:47 +0000
Date: Tue, 15 Jul 2025 11:15:39 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
CC: "Jiang, Dave" <dave.jiang@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
Subject: Re: [NDCTL PATCH v2] cxl: Add helper function to verify port is in
 memdev hierarchy
Message-ID: <aHaaywJPRTteMWZf@aschofie-mobl2.lan>
References: <20250711223350.3196213-1-dave.jiang@intel.com>
 <4da519268938070b448f56d55535f0e3ea4585b0.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4da519268938070b448f56d55535f0e3ea4585b0.camel@intel.com>
X-ClientProxiedBy: SJ0PR03CA0170.namprd03.prod.outlook.com
 (2603:10b6:a03:338::25) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|IA1PR11MB6444:EE_
X-MS-Office365-Filtering-Correlation-Id: 894ad685-8ae1-4956-5b68-08ddc3cb9f08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?VydLQ3rM81HVmzLmVlUDPM+OsZfAW9ti3QxxWRk7AJiR65HeKW4S9iFR0o?=
 =?iso-8859-1?Q?spie9e+TSSqUunCEdDlHRm5NDn/wlE2nVnNjk2WlTZjfsBuvsq47ZRO+Fe?=
 =?iso-8859-1?Q?tXZWfGYvingFMLWkYxgGnvhv1xyLCpK52CAr6TgzScduyBB6GHAp+FtHI8?=
 =?iso-8859-1?Q?2O3MRJ0tp56W/Vk/qdzRqf9ii82mHVVnQEOETYQ39Q/o3u9Lry3A6z1JtY?=
 =?iso-8859-1?Q?fj1wAz/sNx2o5MV5OmVAcDI87J7w8JQoLmcqIXDqYfxHJhP59rgTRxgB5Q?=
 =?iso-8859-1?Q?GVYEG+bxNvGDG9un61KQB1hUtE49xw5J1B1SKfuJWSDss5pabqvGdVlHYu?=
 =?iso-8859-1?Q?yn/qtQrVkwLlhLlBSIICR7FBfSoXTYkxZl0eBKxSuN3Jp60QafdAHw2a3p?=
 =?iso-8859-1?Q?kR7eyRMI7BrfHQnJ3/D/HiE6Ybwf/KZ9l9KefeNPZTo80phyC5sETH7G4t?=
 =?iso-8859-1?Q?Amhf4LYiG4m8zqM/ygxBcWAkv1bP72EbL5jYE+K6zapgU2AtTQfeu7fmhQ?=
 =?iso-8859-1?Q?V+CI9ORYCq6P9z0tZmU/0qEJMSIU4wS80bU0NU4q5QdMb2fIy9dTAivKfF?=
 =?iso-8859-1?Q?Gl8D/pvqYZpxWZRGqfQaZwZ5iYBWa9NOZDTfYw6KLYPPIabFsRi2UWU6cV?=
 =?iso-8859-1?Q?H0dr9NoIdhcqFSCplz8jkuZA1gz9KqxRgkHQJmhvZdIIV7CvkBmecva8Tb?=
 =?iso-8859-1?Q?oZzup67IzMjwRH6c3cZzu7o6JERLyenyIhBiIEXgyX4025rFPXW+isNM6G?=
 =?iso-8859-1?Q?lrNn/qRut7EcNELLARcnlZIveWabxTtK0NuZqf2Q4DepQuNvByVH1IPkn4?=
 =?iso-8859-1?Q?JUU/RbsiSzqaF4k8hF1cDyzF0V+MFR18vAwmUNPlsxwNj1kTAB9SJcsa52?=
 =?iso-8859-1?Q?JEc746P/X6sqaHirenQwkpQKDnZ6XMrKuwcHXksmSeD3gnXJ42V9BnKWlL?=
 =?iso-8859-1?Q?YNw2ca4QaNs4paPCJffJk7EkBFfu8RhCd+Jyy8qr3Xb/pO90ls9DEok14H?=
 =?iso-8859-1?Q?4WxAHyGjmXtGcXRo7gedYFRW9YLpIvnmRuYGvS94ppHCzpf2uZHbyupBy7?=
 =?iso-8859-1?Q?HeyKYtX1XXLz/WHmDRGW/6e/Cg5IlnycbsLebQH1aYghRYbEYCsDv6cGi+?=
 =?iso-8859-1?Q?nUPMUMmDC/pr7PcUgmH1sUdW1ej3OBIfUY3Ay+x6Ggisis8mSUiM4YCATy?=
 =?iso-8859-1?Q?7r44PAFEt64dFsscZLYfPYDfefKnN6q0rupJXwJP01EnhnQ8+frSVpat6V?=
 =?iso-8859-1?Q?IsagFaqwS6JwnSR1fJvDlIa3vV8caBJWIIJliMb2yJqRPB/ZT7Ef+jRRIo?=
 =?iso-8859-1?Q?hR2Kir+SXGZLSajVR6E+1i2axknCiBGXaR5WOuHNqvKtO8nLMy/dSWlbYq?=
 =?iso-8859-1?Q?UQxpfVGB69b4CcSQKW/t/TwsrSqA27ihzPagxPf9p5aUC1hdEu1SQ+2qn6?=
 =?iso-8859-1?Q?VeGK2FOFp/mivzcaOsLna4j7X51DpoC8FCIrHdmI1alup2ost7s5GadRJ4?=
 =?iso-8859-1?Q?o=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?acA/QadxLYYRok8fi1YaO9U1JioTdfhCuF45X6x7oRmJLwjwwEb5MjpqkO?=
 =?iso-8859-1?Q?rBAnGfIiqZICHemPNDx0oCVEXDAol0qy8RITGdJ9S9YDVbqrQVLyuIIBGv?=
 =?iso-8859-1?Q?/PwpvsH+OHfutrgH5bpRjbl02EVwY7G7bW5waCVVS4skpmvCUkpnV6GqCy?=
 =?iso-8859-1?Q?DQ0vT468m92OFhu3z9RZGAe02zaV3mPT+jVD39ryJ23Ayn5Cdd7np7KrSZ?=
 =?iso-8859-1?Q?nLDjps9GbAdJBM4NQ5wq3Ay7WIJVG30aF0QGa2wPjOlIO53LBcp9fmjWJF?=
 =?iso-8859-1?Q?gp+QEXTRAzhmBg/RW3MPNXEGRJBBC4+rry03LU1bu2YC8OVA+nVNyW5J7S?=
 =?iso-8859-1?Q?jarOr/2sl4u6rE/PGt5TBkmTX329riIOCxWUgrcdoCJ9aCRsz6tiP+XcV5?=
 =?iso-8859-1?Q?cDgJLJHS1tWbFM/GK2qKBfPGzZdaeqPevPxmlSbfbmjAj/aqqNqW86QFOQ?=
 =?iso-8859-1?Q?6Jk3dWmlTxrQ+jWfYY0LFdlsdPySZ3XQwcuKKs2ze+qGwWEXS7sbW2/okG?=
 =?iso-8859-1?Q?n8p7xgktIgYogCDPu2NSsI5Nsny2y4J8wiSK8dj0pOBW2mPzNHVjCw80+g?=
 =?iso-8859-1?Q?3tB7HJg3deQRkIpkTsgnWHL6uUJbTBQcSYXD1eUmsNGiGRQUDHT/mjMSwt?=
 =?iso-8859-1?Q?9xB/Rc4rN2K48t6HjwUEh35Qc2hba4Jd8qWa9gv/oVzG45FtgS2tCZr1RY?=
 =?iso-8859-1?Q?KNRb7SzvN4nNKO04aqe5hE9W43tFyGjf0RTrKjkNlYxRkOQUwBMoQEknS0?=
 =?iso-8859-1?Q?pnCjUqF0TC0gAVUAeHklR9tgrQ7I0izhWvm+QIbYvZkZwFta0X88dGS+XX?=
 =?iso-8859-1?Q?OoBjfY0JCMnEF5upI5k4YG9P6/OxHd3hdfgcwZzPQ479YqidoLDNJ6lM6I?=
 =?iso-8859-1?Q?6tN9bsInJsw5m/WGkpOayO6IldovEZRoC3cMKG9MxxP4BC4nMfTWUaXYzt?=
 =?iso-8859-1?Q?OihC90Rpdpv+6rfXfUc4MrzcklgRG9pBS+XlCJRSVIKFIcnH97jsNYYbxn?=
 =?iso-8859-1?Q?mdLbyKItLOzKxZolPwqC7Xf6CUL33IndY15ZQNdTrt+dvQwQUoFKSbt63u?=
 =?iso-8859-1?Q?cKFM09GXoHHGYWhqb4Vln8qSqlqRrJAXir4UUHkzfVr+QdbTZIUES83Ktt?=
 =?iso-8859-1?Q?NLwsVYpxhTJ3DMmW8W3iCQpiYki76THwg83ieE8OFYgM1HTTWhVpG7A05M?=
 =?iso-8859-1?Q?gpty839ZyfHpnj5M7B1LNY07GfBGiG6W5AMhksB/bRJlkW5h4ay9aSyPSd?=
 =?iso-8859-1?Q?mfmYQx2T99DZx1lH9QnATbF1dVtcs+46vDthVHvXPSplgqqEXpp/WYjrUc?=
 =?iso-8859-1?Q?qcvtSzw9dEijesRZhD38ETXkVaymhHb1vI4XJyDgibKnMn/b0xYKNZKfmy?=
 =?iso-8859-1?Q?8N2eoVxSeD0E2CI+ik5nW1i3zWNPOEyBidQBic6EWTXrL1GZ2RaTGKWUPQ?=
 =?iso-8859-1?Q?2/TYn8wyXpREr3onAfznwk5LFwijdb5q9skcU0iWlEbS0fAN6/eTqd/4jZ?=
 =?iso-8859-1?Q?j6GDv1BUgo7QSBUOJg/27NoSQ8dPyI6JVL0t78ylxPZY95u1Cwg6ir/ksk?=
 =?iso-8859-1?Q?PmBepnRvGLwpIh+9lpviIVZDoILDJigVKzLG42MBbmZZ+cbzdyFCBZHk7l?=
 =?iso-8859-1?Q?Qb5eNUfvWEGvwlE1hQD6C/2unVhkiBWw3rYUuy1iLgYCA8mpU5p72jsw?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 894ad685-8ae1-4956-5b68-08ddc3cb9f08
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2025 18:15:47.2850
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7iNsNe4DnnxeTRfxpTq0uGN8bjFu6brL8twZbx1GmO6a4Qj2t7a0oJkVl4iCcfeMrTXiXCF01q0Z1L8UinI99c6YRyezRzosxiQRMSuVfxg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6444
X-OriginatorOrg: intel.com

On Mon, Jul 14, 2025 at 03:27:23PM -0700, Vishal Verma wrote:
> On Fri, 2025-07-11 at 15:33 -0700, Dave Jiang wrote:
> > 'cxl enable-port -m' uses cxl_port_get_dport_by_memdev() to find the
> > memdevs that are associated with a port in order to enable those
> > associated memdevs. When the kernel switch to delayed dport
> > initialization by enumerating the dports during memdev probe, the
> > dports are no longer valid until the memdev is probed. This means
> > that cxl_port_get_dport_by_memdev() will not find any memdevs under
> > the port.
> > 
> > Add a new helper function cxl_port_is_memdev_hierarchy() that checks if a
> 
> Stale commit message - since the actual helper is called
> cxl_memdev_is_port_ancestor() ?

Sure, I can fix that up the commit log when applying.

Vishal - Can you comment on how to handle the existing library call that
now behaves differently? Here we have a comment to add to the docs. I'm
not clear that is crisp enough. Prior to this patch it would only return
NULL if dport not found. Now it returns NULL if dport not found, or memdev
not bound.

For cxl-cli - we never used the dport, so the new call suffices. If 'other'
library users, were using it similarly, then the suggestion is to switch
to the new call. But that usage is not a given - maybe they wanted the
actual dport.

So - asking for your library rules expertise on the options here.

> 
> > port is in the memdev hierarchy via the memdev->host_path where the sysfs
> > path contains all the devices in the hierarchy. This call is also backward
> > compatible with the old behavior.

I guess it's backward compatible, if user was only checking for
existense:

	if (cxl_port_get_dport_by_memdev())
		then do this

but not if they were doing this: dport = cxl_port_get_dport_by_memdev();

BTW - I'm also OK with fixing this up for cxl-cli by adding and using
the new helper, and then coming around with another patch dealing 
with the existing library call for our 'other' library users.

-- Alison


> > 
> > Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> > ---
> > v2:
> > - Remove usages of cxl_port_get_dport_by_memdev() and add documentation to explain
> >   when cxl_port_get_dport_by_memdev() should be used. (Alison)
> > ---
> >  Documentation/cxl/lib/libcxl.txt |  5 +++++
> >  cxl/filter.c                     |  2 +-
> >  cxl/lib/libcxl.c                 | 31 +++++++++++++++++++++++++++++++
> >  cxl/lib/libcxl.sym               |  5 +++++
> >  cxl/libcxl.h                     |  3 +++
> >  cxl/port.c                       |  4 ++--
> >  6 files changed, 47 insertions(+), 3 deletions(-)
