Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A0072BE653
	for <nvdimm@lists.linux.dev>; Fri, 19 Sep 2025 21:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758318050; cv=fail; b=UFqktuiysJPiRWrWDolKkqaVX+jppdSahlwz/YOpUkoRGDb/vF+bmZ53xkhYKi7FULCtDzv8ZrGWga0KDeH1Uj35jJZAebYjAnaIGw4+QU+R8UKN1qQVUBIryyqfgK4zJmmZKLD91SeG3fq8ZvwWQ/wzYWzUAhczNv7ghpFeWB4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758318050; c=relaxed/simple;
	bh=HpvkBFMpaecGMYNzIH16qsCaPLxp9rvD714lhf8wI3Y=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=JPK6+nNLde6nKCc+a0hy+QNKduPlOKlAq3uEmBnIfoPZJ9nwxnH8r87XxNzvaI4l8WCcTnJqOI1L0xYhEpgC7odZJx/3jOBsJ6oQPRwyng1Z5L1We1Q5NHnM8NVGpXVUqTE07alijM6MtgDhMrEe77QYW6zppexahyhPU30PmH8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DMAyucuC; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DMAyucuC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758318048; x=1789854048;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=HpvkBFMpaecGMYNzIH16qsCaPLxp9rvD714lhf8wI3Y=;
  b=DMAyucuCpOD4FkHljGEO/IlliBUZjVXjmqRagGyaZ5ODYxZzMDFcnHLT
   MwmlH5McRNEUT5D55/3M+n/eims0R2wDWU0uWNmkr3w7oJsSdlxTeoXOg
   UkSn62Df6Hq3PmmaigrHdWw7Rtvkfpk+lFFNBSSQUOoPJfB/ncrgf6/pE
   KH2WrUaA04m1XN77j5llXuU0E2od3y4+FP6IYI7ogGnPNPyL3i84Be0CZ
   utRoJGItDnxDabhbNhj/wic0y8Xrljo/suiODFrRHeUYY38Fmc/NEtQ0e
   Wl/yNDnDLtaXJYlgHi861gRenofx2Siw/wDbTvlwBS55atQFOW25rn7Sy
   g==;
X-CSE-ConnectionGUID: TYI66O0IR9K/CZ7A9r0Fyg==
X-CSE-MsgGUID: QXPpAshfR9WrI0Wh0g6M0Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11558"; a="72039716"
X-IronPort-AV: E=Sophos;i="6.18,279,1751266800"; 
   d="scan'208";a="72039716"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 14:40:48 -0700
X-CSE-ConnectionGUID: m5kDq3aOQKuBtsFezjZgMw==
X-CSE-MsgGUID: rR3MTwsgQu2UA7yF/iUwuw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,279,1751266800"; 
   d="scan'208";a="175181658"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 14:40:48 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 19 Sep 2025 14:40:47 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 19 Sep 2025 14:40:47 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.0) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 19 Sep 2025 14:40:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UUAiSNT+6/6sh8cF5WojC4kGOW9pVOd/hXXfLUbG8MUl4cxeacmphZU7KR3w3HveJh5TAmjSw1pmJwfhIMDEkWgyADLYXsAvdbRFRGPr+Mt7CHOx45Z331lz6hlcu5kecEpcxZVilt0dJWpo9pQlS725M4NDVKR1dIOY0UzKYYhr1fK8xTVhsnG+utTWoIVRHsH1SZEj9VGbBphrEfoSt+1yFzPpeq5riUXiQy9+R7KsfrjsINvoWeRQZ1HFCM9XmlW1qYdCSgbHhp1nT+ILEb4rHs499kRpShrpYeqhQckyfdZFpX2mVcwBgMXzMK2Ni8k/HpirMASQeTzLnlOVlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x9i1HH2uBXYQnZUgvhv6Fu+0yr/a0EmsenPp15TC0fY=;
 b=r3zkqmOdz8UVH3I44//hRBmIoQ7M5FyjXffmAP021UVx6j1LsJ4R9AnLdR38rvYmKun5TidOi8HxXFFUWcAsJ+hMMJnfvedMp9NmcMNCh5O/XO/RRRFU1wrB4AhrW9sUnqdPFvHhhPPUoUOst1jriaL9szi2CbjesPGcQqAmm9DUXQvUfpleGANq0+YHjabkURI1GVqKibhO2l5vOd71KJ55zY6lNrKKrngjLxw5kHvk7EvITLjoBkNftiZG70XXze8rYP0YphU93eKPSStNB8ouuApAwAMFZN4CZW32qSam1H9DkPUobtwO3tkKWozS/GJu6Ebr6LjC7NR9JmQuMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA4PR11MB9131.namprd11.prod.outlook.com (2603:10b6:208:55c::11)
 by IA1PR11MB6468.namprd11.prod.outlook.com (2603:10b6:208:3a4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Fri, 19 Sep
 2025 21:40:44 +0000
Received: from IA4PR11MB9131.namprd11.prod.outlook.com
 ([fe80::7187:92a3:991:56e2]) by IA4PR11MB9131.namprd11.prod.outlook.com
 ([fe80::7187:92a3:991:56e2%5]) with mapi id 15.20.9115.020; Fri, 19 Sep 2025
 21:40:43 +0000
Date: Fri, 19 Sep 2025 16:42:41 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Neeraj Kumar <s.neeraj@samsung.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<gost.dev@samsung.com>
CC: <a.manzanares@samsung.com>, <vishak.g@samsung.com>,
	<neeraj.kernel@gmail.com>, <cpgs@samsung.com>, Neeraj Kumar
	<s.neeraj@samsung.com>
Subject: Re: [PATCH V3 03/20] nvdimm/label: Modify nd_label_base() signature
Message-ID: <68cdce51eb03a_1a2a17294ee@iweiny-mobl.notmuch>
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
 <CGME20250917134134epcas5p3f64af9556015ed9dfb881f852ea854c4@epcas5p3.samsung.com>
 <20250917134116.1623730-4-s.neeraj@samsung.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250917134116.1623730-4-s.neeraj@samsung.com>
X-ClientProxiedBy: MW4P222CA0021.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::26) To IA4PR11MB9131.namprd11.prod.outlook.com
 (2603:10b6:208:55c::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA4PR11MB9131:EE_|IA1PR11MB6468:EE_
X-MS-Office365-Filtering-Correlation-Id: b82f5bcc-1ce9-4a41-1153-08ddf7c52fb0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?SADcQbKnH/kysgNr65xmMsxCw9iPSJRq7KM4pTZiCqPcP5Zb3EMQZqgKnJVg?=
 =?us-ascii?Q?aShkSi/bQkBKW/DDIJN6oww4onxOTjo7wApGOygGNpXBZ7jHTOUGnD0o9Tqs?=
 =?us-ascii?Q?n1awNjdJ5Tk+/tDePAQyF6JpOi8MzhfIg+SZQZb2JHyl+7quoJ8W0FWbNW4V?=
 =?us-ascii?Q?EbqtfJBSYdZtsRkTvBzf1ZuMmRTTG9AwK4KA8dgrkspfQt9ZMODu/8DddRwm?=
 =?us-ascii?Q?SJh08q5Ep2BHV1cuKoROF7d2XfNh7rs5E6hWKNUCgsWHmOScDuxnU9pTmTIz?=
 =?us-ascii?Q?ifPOThXQhB2aVbCMo0ig/DpaysljVpLHmeVb3k292LSq2Qf9m8Jjxpu0KMiY?=
 =?us-ascii?Q?5AypGX5pXQRZ7PexjJbfJ6RQnXgAmQwyi9d2YEmDna0/+1BEDCarGKZABPPL?=
 =?us-ascii?Q?FdeM89UpMPgL0ofuzeN5wZKkhIWFDeoUMyhP9JjkVUskUHrFOmb/ODTQheuY?=
 =?us-ascii?Q?Sz+OFHGbr1/Qrph8d7HIvfivA+z0vzU0f8VEVyAHN+Dwu8WdyPFkt7FxTxL9?=
 =?us-ascii?Q?Mq+LE3p/dbEYtKpPO/6T9ZzTQTj4oeJcZ41jYzT092TF8zmoobdZz6JiUFRv?=
 =?us-ascii?Q?arUebgKGDd3aW64dipKFQtYiWwwIlVWIaFU/8CW2Skj6MJzMWkiXUuTicZ7o?=
 =?us-ascii?Q?iEPiq65aZSMhUa/TfFcf/YtwvA9yIWyy5ixyUmLeRbMsUcShA3M1t0OO/Dk4?=
 =?us-ascii?Q?rx21V5B9i1QFaaTNFlJypu/jpboFenJSaXVI5Sqi/xuMFnMnwTcJDJZ+tn6F?=
 =?us-ascii?Q?atoJ5gorzt0NQvahKcGUBJJFlyAQZtME5nR2nkla5ayRVYRd6KkeQzILCCj/?=
 =?us-ascii?Q?HgLyGacslcIG1mIrEz4FwBmzQoME0mQkaB5nDcrXH2Z34pGSYhKX6w/S+zg8?=
 =?us-ascii?Q?tyO97aYDO8UFXSrGiCBjCxQ1RIUQq83jK90frlI4OsnX+GkA7ONwyDfTVm1q?=
 =?us-ascii?Q?1X8GW35kW9KXb+TDl+wS9Da7DixQj4HSSW59tLvaGNI1Nog8yQx3olXVKGlf?=
 =?us-ascii?Q?XJSq1oUGjmDulvnOthBKPhTlYi1NEFWDTa9Czi8Xjiqn9JfvARmJYEDuGsak?=
 =?us-ascii?Q?ONG1CvuCJKIfxq+IKE2Jnc23SDL7ijeJAp+99vTHhBAQYO3hU5CyNUOFyg/k?=
 =?us-ascii?Q?YXzQ7E5eGkVOM+7ZmBi/TrWVcamWQkgYT7OVQQDJg1G0Kj13G+G8bHlBICzy?=
 =?us-ascii?Q?AKn792z7YdiUHOPfE3r79OhLv5WyxXysz6Uh4G2ZUUv5dXSf9v34r4v+ijnY?=
 =?us-ascii?Q?ADSFxBGvTBxzRo0xswUH/TxOvG6YzRhtFnrckLISKiNzGudZ59K6fe1qCca0?=
 =?us-ascii?Q?NPg5Odskfj0bs4mteqsvH61FxFw6FQ0jtvGZZLqhSjuwFrkIalf5WWkW1wHo?=
 =?us-ascii?Q?8DtJ2xEiJuOKOiU7lQ0+697higEPp8YMEtAOfZUdaHqSbWfczw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR11MB9131.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tkKJc294dBmg1/WNck1x1c5bx2NvmXMOWOBYmSt7ZrJT7CR8Je7KcudnuqhN?=
 =?us-ascii?Q?83odlIhl07ZCIbOLgQYWW0LVAOTnB3i1jssWDq5itAWPp/mlFLz72lpIeHJE?=
 =?us-ascii?Q?5tVIz+559k0XcSv+Sa0MANco6X+y44EWPWtDk++EPWe0sqhP7coYej1X8W43?=
 =?us-ascii?Q?+6COqjixqJ1H2FjRJRjA+aFQtWyv5EBPYdJ3agtQshcmXyBpO7UDwqmaJCro?=
 =?us-ascii?Q?2FSrtLV+1TQRBi6rM0hGz5QjqGaB4BGN0dJAsAXQZf7S/gnmU2HUf0sYn872?=
 =?us-ascii?Q?7SN8NV3Xo7qPzk4Z1kHGSl3d5tFETTCkG32QxPxStVyABcUziFcx/4ENPAYR?=
 =?us-ascii?Q?Q2zTfFhEzacKNg2NxpnZ/6Evx8qvQORqRtu9ka9MlA4ptDCuH5t3zNZcd16f?=
 =?us-ascii?Q?FHzrapshSagIoGdWSyq6nwi9fKXdrQSlFI+e8PwP8qyOYugLsCV975eyVCyR?=
 =?us-ascii?Q?+hy5dLyFV3A1m1bl3KP8/+XD16/Oiykl2Hyua40KDI4YKf7om4U3JVLjhCW7?=
 =?us-ascii?Q?5CzQ9QlYriVJQ/DRIlYP3UV33eD1FIDYXsyiCKX0vSzBckElMBfpos0g5lHZ?=
 =?us-ascii?Q?484UeTWMXBlj46u4Uuv1vsIVR9+D0yvmzxkL7B7l//aW/KxfyjklCINL19DF?=
 =?us-ascii?Q?Cp0BhiBViGFAxQQZpFKW7+DgthDeD0I0l7LwYJ1K7Wd8zNb3ZmxMxjuD1lqH?=
 =?us-ascii?Q?gbhXba34EuTMqGmz3tsYXLL4gzwQ0SqKKFntfIwkd4IqLzAIU6TaSxxcG00J?=
 =?us-ascii?Q?Cl0FXnlL/K0s1ye8eJxMQw3Sn4fvJka3z1DFdLbUpbwvvsf2f0ESsYXV6BBU?=
 =?us-ascii?Q?Z7CNPoCVHN/J/4Tbo3oGYA4+tQxX+EHXYsWGaS59zlQJZY8atJP9+HY4BbV5?=
 =?us-ascii?Q?GFkbtjmod7/k3KtVrCF9a1NtHRWdTBAAMcX/P74bQBDsuo9u9HWr0IZ61Zbj?=
 =?us-ascii?Q?922Xi6n4Zyy6atN31A9vqwZLUEEi/6Ol/uImBdrRpQuOM9hThht5+K7zyuOc?=
 =?us-ascii?Q?Q6FqT7MPbBuHgAFOVMXuf8KnsyS7M0QCoS/QQUKf7TOoIiBYsAsmDL0y4uKF?=
 =?us-ascii?Q?F7KWmEfIm3HrDn8jVw52ZQRggnEeZiBbeqKO/my+7ch5N9J2tEqo4Nmtorq+?=
 =?us-ascii?Q?3ow5As8w2ALmkvnXzq8cTsBAsY+3u0ImsUtJDKw1vPQKN108h80Nqu92+JOG?=
 =?us-ascii?Q?K3V4Q+sOnZdCcwpiL/8uzHtGZdmU9ydoPqw9D6g0YvtZqW1KNSTxe+f2Fthq?=
 =?us-ascii?Q?NGIjYxWCXCvL3LJFJlNdIEH/zo7mZ59DA3s6Qm8/DS8JcCWV02DPuqoyGODH?=
 =?us-ascii?Q?bBuQK7CPUEwUZBQfNV4U3TnDBArAY7SsTvsBrNaQEPwarEMq9dvt83G/VvCe?=
 =?us-ascii?Q?Ka54tdzoYjv7CFrBAkpWkuTIwP9Y7Mwr2BPJt0wKNlgjuHSM2Y2EFNcIa8ee?=
 =?us-ascii?Q?hTnx5IT7glIgSWx6kmYX63kbcxjf67J+zeGa2vl4vdTn6yvUP8Zw6D7TAHZI?=
 =?us-ascii?Q?pYXgopztRcRiUHhGUGsjfq+tiAJw8ZP0TzJJqjCylnD5e7zPFusyQnxXccwK?=
 =?us-ascii?Q?pxgcaDjq3ggoxAEWFD25+RfjeDkmgxhtwoAER/h+?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b82f5bcc-1ce9-4a41-1153-08ddf7c52fb0
X-MS-Exchange-CrossTenant-AuthSource: IA4PR11MB9131.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2025 21:40:43.9227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I+9aOqenPJHgTMkjsIc3M/CvMhpRo1H5YzFR/O5cDOrgwkRg9FHmq6JS4ev5YUZhKd/9fGrUje6d/CQmXkdW4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6468
X-OriginatorOrg: intel.com

Neeraj Kumar wrote:
> nd_label_base() was being used after typecasting with 'unsigned long'. Thus
> modified nd_label_base() to return 'unsigned long' instead of 'struct
> nd_namespace_label *'
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>

Acked-by: Ira Weiny <ira.weiny@intel.com>
