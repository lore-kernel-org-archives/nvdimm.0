Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E40286D70
	for <nvdimm@lists.linux.dev>; Tue,  6 Jan 2026 04:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767674519; cv=fail; b=kSnrX/8fKTZJPCWQ0O3sNMfTESRR2wQCzloEfaxFbrlqCqjA/dP4R8KE28hThEzjSAHpvGd5Taa1K9s5KXnSdTCetfl94YLvDOzTbg3N7X0PwniBN91LV65JCVnds4dbfPow9t2/Sqed8jbEdo7rKybvx+wq3r+ahXnIqc+1gFE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767674519; c=relaxed/simple;
	bh=DE8+deSOsIHNdczc/8QLrhIOPHdsDh8j+TcN8GlZrmQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=eZUaBZlLQ4ylY4TZ3vULngR5JyJB2th396Q0lXGez87RzMkUK8/jAl/bzFGY/a8PZ4qm0JnC5ODoGkPaQFrjYZ7KwUEd+5TytAaMhnOjb40bIVc7ZPIDx+6Yiq3qvBMbr87T/NZ93rAW/Ss5HXUWHZICUMXgkcvre/z2fU7LBKI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bAhbl+4k; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bAhbl+4k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767674518; x=1799210518;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=DE8+deSOsIHNdczc/8QLrhIOPHdsDh8j+TcN8GlZrmQ=;
  b=bAhbl+4kl0QWfEybSd6A8pmcPJ64ngjQg8Q/McyujkBTgjcAtFYFysa3
   /Su4OlXzvSz4GWr9lRDd/R8tbD8CZHQXBnlY1QZv9RjDpVy8snCJRX+U0
   zt5U3wIhOj4tuzFLxZNGkB3yIxHOS4mt/YfP4z8p0M8t2w4iZJLVi+pj3
   Q3xPqYtu3zu2KFeqEgnEp5E9SILGTWr1xhgsb5IEaaaqNhL1YU2q4lTv9
   GKGQHNoAKMmLvDneljwLmi+9XsHWjHFR+CU3kmrnUnzbg7k4rrTiPP3IE
   iBAWdKbfcv4OrEV5STFN/K9tJw4+sje9ViuQzj51aQOCnhbt8D+uiC1pU
   A==;
X-CSE-ConnectionGUID: lv4s528cSMSJgPapkrVZCA==
X-CSE-MsgGUID: +KCb4YdaTu2wbdlkknZUhw==
X-IronPort-AV: E=McAfee;i="6800,10657,11662"; a="80155038"
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="80155038"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2026 20:41:57 -0800
X-CSE-ConnectionGUID: wHUNtxZ1TAmPZBnshFdYPA==
X-CSE-MsgGUID: T+rILir6SHio97xbYkX15A==
X-ExtLoop1: 1
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2026 20:41:57 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 5 Jan 2026 20:41:56 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 5 Jan 2026 20:41:56 -0800
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.13) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 5 Jan 2026 20:41:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JRgOycgfGSBFh1HAdeDeulkRjpZfLN7xtKINIblviVG8zKA2+WWJkZrdmSrIj0xLA9bPQloxKYyqT2fZaD3t+RmOFcn7ca59/Yctm+5wXQ/1uEizpaWkIwCCgUuMh3RnXjLu6/KP02/wU3HSJLbcGkac2guoMvOUmLBOLyn5tsWIJuca3V7TubTLySBh0d/RilCU+AfTHM/hSaZQ8k7pbbxNyW6n1ilyawTApRfJFdnCOpX9qRnb6qCQd0aiYKA7kn826+hSd4U7NKdp705kvkc+XM7+LuEMh2GdkxKzVQLnOhf5c6132Ga5F47vhIT/bn8pshfDlTJFrqGK6pTA2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kUxU1JmGmvuCbXRfc9xGJXkOMAmL+COU6aIcZbVODcc=;
 b=gYG6SoH9Y6A280VktZf/g8HcK/JnP7P5dQzfoymZbkjZ5xz7nI1cBIg7E+QKH3D0rmclGe+1/sONiDOvBjiNZeN5wti6+lzVWC87OKsXuurzN8+R8lf4VHMwLYVPpD4e9qSGw4AMIZONLcIUGskfl1x4sSavqfeLQWm3hi4cU8nlqVqnQjgfyKH6Vj3Fix2oFWzAFsbEvaAI+YHeq4TqXdTK5qGTXpoYkZXyrCZ59u+qLD/YHuvjLiegQ82PkOBaKJxdsVk2dxKUcu0/0BL7TtMjmm+Ukt+pzImf2pg9htBFiZ34amy+rmeCds+BXpH7GYDid0q7M3smb3tFpm9/jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by DM3PPF58BF5162C.namprd11.prod.outlook.com (2603:10b6:f:fc00::f23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Tue, 6 Jan
 2026 04:41:48 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee%8]) with mapi id 15.20.9478.004; Tue, 6 Jan 2026
 04:41:48 +0000
Date: Mon, 5 Jan 2026 20:41:45 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: "Cheatham, Benjamin" <benjamin.cheatham@amd.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>,
	<dave.jiang@intel.com>
Subject: Re: [PATCH v5 7/7] Documentation: Add docs for inject/clear-error
 commands
Message-ID: <aVySiXDQTKGrQY1_@aschofie-mobl2.lan>
References: <20251215213630.8983-1-Benjamin.Cheatham@amd.com>
 <20251215213630.8983-8-Benjamin.Cheatham@amd.com>
 <aUTaIPvIeILjEnnI@aschofie-mobl2.lan>
 <3eae10e0-0203-4cce-b060-88c69b2e2f41@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3eae10e0-0203-4cce-b060-88c69b2e2f41@amd.com>
X-ClientProxiedBy: SJ0PR03CA0073.namprd03.prod.outlook.com
 (2603:10b6:a03:331::18) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|DM3PPF58BF5162C:EE_
X-MS-Office365-Filtering-Correlation-Id: bdd3e61d-f06a-4771-9222-08de4cdde735
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?OdwByBayH983wFiyPhMJ3i95sLQvhFnW6xjsXTvhI0DdRbVRCz6UHobMAulG?=
 =?us-ascii?Q?yif9AcquKMjx7H6ZygJadiJU/auZK3HwQkSf+SOUYfgP/qir4yNBveSBT+6b?=
 =?us-ascii?Q?60FVPwV0O6zEzLcx1mXV0OabVzPLqLmoxl+8ZAh3RfHt3NJX0BrcX4+RdAP6?=
 =?us-ascii?Q?0AubMHZKWM432W0l+zRM+f8D/k+7+t4bKFiZeKPbcy9WYXPb+lJTu/BeSkpb?=
 =?us-ascii?Q?wAKL/8pI8TYRuY5qr5jf0ChmdtDDlibwCBRa9sN6lk3ZfH/7a0XPdFt6C9F8?=
 =?us-ascii?Q?ro4b8x15Vl8Lt9+eKZJvJkfMmV7IAGrqP9VvmVz/sOjwuj2trFJsajRxTVdn?=
 =?us-ascii?Q?KAHL/po3nlSvGAEWT1AwfpWYUysHedjLEmSU3EiQtJxft/AzNAYMcDstIKWd?=
 =?us-ascii?Q?oQOIXiOzHh1sQf4bcOSndXDRFi0xdgwicF/HoY5Sp9tuJPqLunUU7+FMPSFN?=
 =?us-ascii?Q?g9uHTDe2ehg0Usn/2JKHnsgyRzMKfGiF9cAeCeMufyS8ITXDWxFFo167UjSO?=
 =?us-ascii?Q?UvDxQnkB8XQsWJxF28kcB2hmneJL2Qby+aZiQ4U5UYnY11tojOLwNDIKCm7M?=
 =?us-ascii?Q?JHDjG1dInxvahaqMCu9fnJ8xxqaxAHeYfkAsaNxAiqXjobfivdTwyihjr7eg?=
 =?us-ascii?Q?aYp6fDKW7B0hz6wZk8isAJ6gVFRhTXdp6Gwyt/Lae7mp+cSs8JnwMtS8M2hC?=
 =?us-ascii?Q?h+q1RF1HHw9mZpPUpqepPuQcbnSMNWn1T7kz8m7NjqOf9q/uIYekDduKglSj?=
 =?us-ascii?Q?KsYdzuC3MYB0tBdIuynkep09MaYPQEhDbo73ZhDnZQ+rJGWBaUvARv3XJY5n?=
 =?us-ascii?Q?xyyiQxklpOSdnqmr3eBiOxtHDqvVpH6nf0+/4CunCDnWyuoM9757jKW9iK1T?=
 =?us-ascii?Q?CfTo5ACC+NoLEBZy4H2kVOlNmGUQE/yACedI4oqakA+XzuTxqJkL1oK2Af9B?=
 =?us-ascii?Q?p0i/s8WnurMqGuI4RgyITaaOr2ukBsFF8FAj2mJUcgwR12TQvTTl3f1nonX3?=
 =?us-ascii?Q?jtH8ggmI1mWlUtf8dQvRiQv//LOV5YD4wpQU+a/HV8PYIExFW5Tn/klCl5X4?=
 =?us-ascii?Q?i80sSWTOx84GF8tLVLOV9MTemWcbmfX0Ntd0o1Wf3rtGopSFm4YNDmb+6JBw?=
 =?us-ascii?Q?i80EhemZl+VC80GRVNWKY3C0Mz5cBRDEaI3G70zutm3jIomGzhNK6RcQN5sE?=
 =?us-ascii?Q?cEQuYHTcf2ImaVVp8ltMODvb2f1nJYaU8ucBAhtgfp/kqpPlqLPFBgYeV6lP?=
 =?us-ascii?Q?pz5H/f4itmksc6SBtIg6e+zojJc3UkkLSWGWar+kuS1yfK6/YVhaNXFwO2Ih?=
 =?us-ascii?Q?g/nxgr21qBalBMIv0X7nYquC5kFk76Usn8E2AHP1x8EFGCJ/cNIYRWt+tYT2?=
 =?us-ascii?Q?3rB+GavMs3O62MjwbNi3qi5w93KDXN3o3RMwFuxNb3FxZH8pgA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eqfYFELJf6VLWa/htcyNskNTCVtm6xkgVpVU2/S8Gz8Rqx9DMtIgCs8bNjwm?=
 =?us-ascii?Q?09IlHDQlzKqHhPhEF0zvKi5eeMuAHiIiFnWyfIlUMG1gywSsPOg4eIiZNHhS?=
 =?us-ascii?Q?8K5EUehzyv8WpDUv0KYHysPMvcnAd27NzRaf5LhH4UZXrFA+FxvkNIF8u86z?=
 =?us-ascii?Q?MFOmQzzLt3k9PB1Rz/jZXBI0Z80LWISg704Jje8J2uiS9KaLxLS1Fy+Ep+rU?=
 =?us-ascii?Q?hdVkfQvzypRJobIt7IqluLL7EHkXF6KFleBbpwhb8ij6DywintLt1aNYHLQ4?=
 =?us-ascii?Q?ZL5rFgZbOBjlwrhU7oc1V3fH2ZpmWsYCAHJUwupZU2VBfet19Hz7BubF4wjz?=
 =?us-ascii?Q?r9G/+jFDwIkJiLxQ1y9NN8glYKlKPiy0HjPmqkCJxiKz9YkHLxcq62AHjaR2?=
 =?us-ascii?Q?aWXTrd7mFYH5ADknEL4zJ0Xn+1MLHg0AXKhPltglHQ900WOe3lJZUdx+eOOf?=
 =?us-ascii?Q?fDoLaSlxCRRNtedbdWyGcAmc7Zae21r0l2m2mcwDqNIjTLXxk1Km8UEoGYv4?=
 =?us-ascii?Q?MIgre03huAjmO1+wq6qQm7rzRAU1m7M3l258HzcwGIhePQ0BGXbe389EAVB7?=
 =?us-ascii?Q?5mC2mvNO0h5nGh9HfFuIQJ43BENo3M2AQydYQA0weFU3ZPwExDrqHQAJaxi5?=
 =?us-ascii?Q?9I273LaTgPvk4mNiTqEA16+yODv3Z/cyPCr7Lln4WmwTsMXrL3DSOfQn4Hcr?=
 =?us-ascii?Q?iJ4c8Qd+bPyjOYBgNr+Pg8iB+UijJ9RlnSZv6Yo0kr5ZImVv2y/LJ+Y9E6NS?=
 =?us-ascii?Q?P2GA0c9LikjrPwcuOx2caE6ff8U7AVEuZhhTru/gGA3++ZfkjG8ixbT/57+A?=
 =?us-ascii?Q?KkdQ+5FqQqzjBkaRC6HDADGCPcbVcjnmxnXS24g/Sat+VVAdtNowDZ55by9K?=
 =?us-ascii?Q?h2gPUw+AjLdAwBqf86HrLrdfEwWbjiuxqSiks078TP4tYQFtSQuo+AOt+wKd?=
 =?us-ascii?Q?HbL7BoqiUgk+R4AFE2kc41WWySaKYKcZ/JZJ4vmYXlSDIL9QFjyG/MlfmfVA?=
 =?us-ascii?Q?tzBJo7YBQwGlWtZqKzD6iz9Rta9PAv/FqOR/De99loE9laJDb7rt25j7V046?=
 =?us-ascii?Q?JBzyKCtDcCa4gJ3m7ezP/Da1oWqH6AHj5RyIVpUEPKvnGuZbSQtG6YqJeciR?=
 =?us-ascii?Q?N1Y8UzOsUs3Kg86QrPqxKwnd2NBg3qSVqL/AxEqCQ/gkSbpUKwIUSCTM9X5a?=
 =?us-ascii?Q?mBhY6SUYN6VJZdTOO5wDxb11QP2mDFOVZmT0oI5CxP5sR7MZKHVZYvAnf7zj?=
 =?us-ascii?Q?wplqDCThV69ZZLXRwHBzzzl5EASU/S9S+bXYmJQrPW+phSQYNLWItFYtrMmM?=
 =?us-ascii?Q?akGuOI8cBx5+d3Kvw1V5SaBoW16qAXLYYBcDAOpAO2lPmeukEfnOrd4dowGV?=
 =?us-ascii?Q?c4OchHXhm3BEBG9+2JDv1EP6hquzSqgnaan0TonP6A+Ge1N0ZvnlveDQaVOe?=
 =?us-ascii?Q?mGoSoiHEUJarUmdltRohDFdc3kOlVe6sxiDB3OPNCv4ZxEAgd5zzzeeUc7z2?=
 =?us-ascii?Q?f5KzI3itYvTWqTaquVQow5EgPKaZ5EjocoJULHgcIOKDuNoeNJTNkwKpL5lf?=
 =?us-ascii?Q?fj9+MK3GYbYi4vWOXoL72qR08rm86kEqspM8u+PBlQjexFV8UpmGB96mUKPv?=
 =?us-ascii?Q?l7W/c8RFTIWYK+tMJSN5T0TGrP6scxJl5h90ckFAOcFezu/M8kyfEImhREXz?=
 =?us-ascii?Q?6CUjem01kVrZMJxarPswWhXnLZIoJZLBCLNn1LuHivJPTRgXTERTsegIdj1W?=
 =?us-ascii?Q?enrR8opNkj4X6wfBYIftlryTs8DJ384=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bdd3e61d-f06a-4771-9222-08de4cdde735
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 04:41:48.6165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kXb/WWNfztVnw4Wbnv9+by5AuegRKdEy60i4VmMtH6FDCixpIInkrOdwnDbmf5DTiU8NFDd/ZOYoWsAMmud6ALR37kDidcsyDYMYLnK1hZ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF58BF5162C
X-OriginatorOrg: intel.com

On Mon, Jan 05, 2026 at 03:13:03PM -0600, Cheatham, Benjamin wrote:
> 
> 
> On 12/18/2025 10:52 PM, Alison Schofield wrote:
> > On Mon, Dec 15, 2025 at 03:36:30PM -0600, Ben Cheatham wrote:
> >> Add man pages for the 'cxl-inject-error' and 'cxl-clear-error' commands.
> >> These man pages show usage and examples for each of their use cases.
> >>
> >> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> >> Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>
> >> ---
> >>  Documentation/cxl/cxl-clear-error.txt  |  67 +++++++++++++
> >>  Documentation/cxl/cxl-inject-error.txt | 129 +++++++++++++++++++++++++
> >>  Documentation/cxl/meson.build          |   2 +
> >>  3 files changed, 198 insertions(+)
> >>  create mode 100644 Documentation/cxl/cxl-clear-error.txt
> >>  create mode 100644 Documentation/cxl/cxl-inject-error.txt
> > 
> > snip
> > 
> >> diff --git a/Documentation/cxl/cxl-inject-error.txt b/Documentation/cxl/cxl-inject-error.txt
> >> new file mode 100644
> >> index 0000000..e1bebd7
> >> --- /dev/null
> >> +++ b/Documentation/cxl/cxl-inject-error.txt
> >> @@ -0,0 +1,129 @@
> >> +// SPDX-License-Identifier: GPL-2.0
> >> +
> >> +cxl-inject-error(1)
> >> +===================
> >> +
> >> +NAME
> >> +----
> >> +cxl-inject-error - Inject CXL errors into CXL devices
> >> +
> >> +SYNOPSIS
> >> +--------
> >> +[verse]
> >> +'cxl inject-error' <device name> [<options>]
> >> +
> >> +Inject an error into a CXL device. The type of errors supported depend on the
> >> +device specified. The types of devices supported are:
> >> +
> >> +"Downstream Ports":: A CXL RCH downstream port (dport) or a CXL VH root port.
> >> +Eligible CXL 2.0+ ports are dports of ports at depth 1 in the output of cxl-list.
> >> +Dports are specified by host name ("0000:0e:01.1").
> > 
> > How are users to find that dport host?
> 
> The user needs to know beforehand at the moment. More below.
> 
> > 
> > Is there a cxl list "show me the dports where i can inject protocol errors"
> > incantation that we can recommend here.
> > 
> > I ended up looking at /sys/kernel/debug/cxl/ to find the hosts.
> > 
> > Would another attribute added to those dports make sense, be possible?
> > like is done for the poison injectable memdevs?  ie 'protocol_injectable: true'
> 
> Which ports support error injection depends on the CXL version of the host. For CXL 1.1
> hosts it's any memory-mapped downstream port, while for 2.0+ it's only CXL root ports
> (ACPI 6.5 Table 18-31).
> 
> The kernel adds a debugfs entry for all downstream ports regardless of those requirements IIRC.
> Having the extra entries doesn't break anything since the platform firmware should reject invalid
> injection targets, but it does add an extra hurdle for the user.
> 
> I think what I'll do here is submit a kernel patch to clean up the extra entries (needed to be done anyway)
> and add a 'protocol_injectable' attribute for the downstream port when a debugfs entry exists. I'll probably
> send out the kernel patch at the same time as v6.
> 
> Let me know if any of that sounds unreasonable or you'd rather I do something else!

Ben,

That sounds good. I knew that using sysfs to help me figure out how
to use the cxl-cli command was a bad sign ;)

Don't hold back on examples in the man pages docs. 

Thanks!
Alison



> 
> Thanks,
> Ben
> > 
> > 
> >> +"memdevs":: A CXL memory device. Memory devices are specified by device name
> >> +("mem0"), device id ("0"), and/or host device name ("0000:35:00.0").
> >> +
> >> +There are two types of errors which can be injected: CXL protocol errors
> >> +and device poison.
> >> +
> >> +CXL protocol errors can only be used with downstream ports (as defined above).
> >> +Protocol errors follow the format of "<protocol>-<severity>". For example,
> >> +a "mem-fatal" error is a CXL.mem fatal protocol error. Protocol errors can be
> >> +found with the '-N' option of 'cxl-list' under a CXL bus object. For example:
> >> +
> >> +----
> >> +
> >> +# cxl list -NB
> >> +[
> >> +  {
> >> +	"bus":"root0",
> >> +	"provider":"ACPI.CXL",
> >> +	"injectable_protocol_errors":[
> >> +	  "mem-correctable",
> >> +	  "mem-fatal",
> >> +	]
> >> +  }
> >> +]
> >> +
> >> +----
> >> +
> >> +CXL protocol (CXL.cache/mem) error injection requires the platform to support
> >> +ACPI v6.5+ error injection (EINJ). In addition to platform support, the
> >> +CONFIG_ACPI_APEI_EINJ and CONFIG_ACPI_APEI_EINJ_CXL kernel configuration options
> >> +will need to be enabled. For more information, view the Linux kernel documentation
> >> +on EINJ.
> >> +
> >> +Device poison can only by used with CXL memory devices. A device physical address
> >> +(DPA) is required to do poison injection. DPAs range from 0 to the size of
> >> +device's memory, which can be found using 'cxl-list'. An example injection:
> >> +
> >> +----
> >> +
> >> +# cxl inject-error mem0 -t poison -a 0x1000
> >> +poison injected at mem0:0x1000
> >> +# cxl list -m mem0 -u --media-errors
> >> +{
> >> +  "memdev":"mem0",
> >> +  "ram_size":"256.00 MiB (268.44 MB)",
> >> +  "serial":"0",
> >> +  "host":"0000:0d:00.0",
> >> +  "firmware_version":"BWFW VERSION 00",
> >> +  "media_errors":[
> >> +    {
> >> +      "offset":"0x1000",
> >> +      "length":64,
> >> +      "source":"Injected"
> >> +    }
> >> +  ]
> >> +}
> >> +
> >> +----
> >> +
> >> +Not all devices support poison injection. To see if a device supports poison injection
> >> +through debugfs, use 'cxl-list' with the '-N' option and look for the "poison-injectable"
> >> +attribute under the device. Example:
> >> +
> >> +----
> >> +
> >> +# cxl list -Nu -m mem0
> >> +{
> >> +  "memdev":"mem0",
> >> +  "ram_size":"256.00 MiB (268.44 MB)",
> >> +  "serial":"0",
> >> +  "host":"0000:0d:00.0",
> >> +  "firmware_version":"BWFW VERSION 00",
> >> +  "poison_injectable":true
> >> +}
> >> +
> >> +----
> >> +
> >> +This command depends on the kernel debug filesystem (debugfs) to do CXL protocol
> >> +error and device poison injection.
> >> +
> >> +OPTIONS
> >> +-------
> >> +-a::
> >> +--address::
> >> +	Device physical address (DPA) to use for poison injection. Address can
> >> +	be specified in hex or decimal. Required for poison injection.
> >> +
> >> +-t::
> >> +--type::
> >> +	Type of error to inject into <device name>. The type of error is restricted
> >> +	by device type. The following shows the possible types under their associated
> >> +	device type(s):
> >> +----
> >> +
> >> +Downstream Ports: ::
> >> +	cache-correctable, cache-uncorrectable, cache-fatal, mem-correctable,
> >> +	mem-fatal
> >> +
> >> +Memdevs: ::
> >> +	poison
> >> +
> >> +----
> >> +
> >> +--debug::
> >> +	Enable debug output
> >> +
> >> +SEE ALSO
> >> +--------
> >> +linkcxl:cxl-list[1]
> >> diff --git a/Documentation/cxl/meson.build b/Documentation/cxl/meson.build
> >> index 8085c1c..0b75eed 100644
> >> --- a/Documentation/cxl/meson.build
> >> +++ b/Documentation/cxl/meson.build
> >> @@ -50,6 +50,8 @@ cxl_manpages = [
> >>    'cxl-update-firmware.txt',
> >>    'cxl-set-alert-config.txt',
> >>    'cxl-wait-sanitize.txt',
> >> +  'cxl-inject-error.txt',
> >> +  'cxl-clear-error.txt',
> >>  ]
> >>  
> >>  foreach man : cxl_manpages
> >> -- 
> >> 2.52.0
> >>
> 
