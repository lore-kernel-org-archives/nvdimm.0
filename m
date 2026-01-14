Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B1A30ACFF
	for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 21:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768425582; cv=fail; b=u/egUwOxKmTnTrpD6ieemp+92qKdNC8/Ef6jpJuZqYeth4hqRs7hH8g7RZQcQqxokflWw6rgCtp2B3tqbigqi2Nvp3qrV9exdbK5jhAd9Yh+Ft6QnwLitDjr7J36X83ldweIb9by7eI9g7iCNY6+2FRkkU2O8UPvjceW0OEEC4Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768425582; c=relaxed/simple;
	bh=jJzdCCLoBzuaYkziHFsroJRpk+B6eigAzlrYgJD7LOQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=hGvWOdMC4+D6nDsqOxU5331ViVcWmlLbTegCVJvg4UgBKG1QEsRobtUvpzz6h1W+CoBv0WNYQSCz4aUuNHgWHRFteGvK4ZEgNPBf6Fjm6YQKaUkaWbuBPhQJL233997fjGBzNXzcICj/4/wK/5Sk64GL3NztaE91UboEzOnkKzg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RHCRonFJ; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RHCRonFJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768425581; x=1799961581;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=jJzdCCLoBzuaYkziHFsroJRpk+B6eigAzlrYgJD7LOQ=;
  b=RHCRonFJvyoLT3/180NVPYJstX1SJ9DjGFCnNOGnbi3MzumyNuZzpSjK
   0WcZXuKPrV3gDDnao7OXaNThI6DVZkgWP8na0wWvVWExdJzBvso8a3AGU
   /kRMcqcxbz4WCZOWKSqXno8rbbzv5eB+HaWntawUpVzgmTF+NqFV5xq4q
   QH5Nx0y5NKjDEFgU1NFwxAdC8XDUrvFKf7l/78oktefeCOofe1njR11Gy
   olBviLZ7WMDzbs09SlsTqnzlNwp0vWW1yTa5eiT9p7SCtxxjZ6OsIpI/M
   U0HMh3d0nYJ56CXbEeSKlXHDsk2R9s8b+muYsZuhdTiqCNw8xcrOLfMhz
   w==;
X-CSE-ConnectionGUID: +tHEgWoIToGAg5G+fJXYGA==
X-CSE-MsgGUID: zR20KHBdSIKwL4ajcgnDxA==
X-IronPort-AV: E=McAfee;i="6800,10657,11671"; a="72316657"
X-IronPort-AV: E=Sophos;i="6.21,226,1763452800"; 
   d="scan'208";a="72316657"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 13:19:41 -0800
X-CSE-ConnectionGUID: tNCzqdY4Rum/LlYptzJuSg==
X-CSE-MsgGUID: P422JQSbRp+Q9jI12KQTrw==
X-ExtLoop1: 1
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 13:19:41 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 14 Jan 2026 13:19:39 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 14 Jan 2026 13:19:39 -0800
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.62) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 14 Jan 2026 13:19:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HqcOtowRwAxrz93V8K/k7P3S5q3daJv8ZDVnCdVVrpCObkm2CZ+Sqd3oP97Hz9IkNw2O6BxyA8TC5atP30+BemZsSgMh2NNP0O5dkwJo/ef/ht+uVUYH1GyIyngHsBFz6H0DtHb9swpAjpcyvm/IqOZrK4NM4ur1k+pN6V9kJCQftatZ37TQBdvdlvO29gW0s3PDo5Tr4H0Sdr8wfhtrxUn7aLxFETsMMqxHlrVOpEJ43qttQ3MSiNNwFvwMc6ORbMeF9mKFKISI92lNtVeC2lo21HXeM+gkTUEcvpvf1sVoARioB6OdS+w9LnfIpLZHhHwO0N7j86oFqV5uT+4X4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1DMCQJui/48+Q+go4U7SGeohR71UsoO0HH80KOfcHBg=;
 b=nZvTmDzbAcU19GP2PYoYTuDv0rSPQO8feLdEarhEB7SClwrS/ozsKHcuPXx0RicEzgXkWBYHu7CiJ0pJ7VJ8u7TeyaoUdW3BfLHYIf2LEDjnIKnVifyUNFFVQIKcbyyzwNIc5XM0STZimZCzCKOTV42CTjdf14CysT5D+edCIq+zyvrgwCz9A7NXssO7oqc1Q9F19wBwyHWTYVjOPKM98yEdZLmn/8R6sT67oZ9TEyjVem1zgeXqyBXqyvzrLC5/WdTIYF1Hl5qA5GwrOcv/gs2E+hhJZLCIqxmOK+TU/jrAnPTdJvxC7kJXxGo7P7AxiZBq6sydW1ZKJNFP/ekoCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA4PR11MB9131.namprd11.prod.outlook.com (2603:10b6:208:55c::11)
 by DS0PR11MB7261.namprd11.prod.outlook.com (2603:10b6:8:13d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Wed, 14 Jan
 2026 21:19:38 +0000
Received: from IA4PR11MB9131.namprd11.prod.outlook.com
 ([fe80::7187:92a3:991:56e2]) by IA4PR11MB9131.namprd11.prod.outlook.com
 ([fe80::7187:92a3:991:56e2%5]) with mapi id 15.20.9499.005; Wed, 14 Jan 2026
 21:19:38 +0000
Date: Wed, 14 Jan 2026 15:22:45 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Neeraj Kumar <s.neeraj@samsung.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<gost.dev@samsung.com>
CC: <a.manzanares@samsung.com>, <vishak.g@samsung.com>,
	<neeraj.kernel@gmail.com>, Neeraj Kumar <s.neeraj@samsung.com>
Subject: Re: [PATCH V5 01/17] nvdimm/label: Introduce NDD_REGION_LABELING
 flag to set region label
Message-ID: <696809254d6c2_1183cf100af@iweiny-mobl.notmuch>
References: <20260109124437.4025893-1-s.neeraj@samsung.com>
 <CGME20260109124455epcas5p469d54be9ab7a1801b80922404647d371@epcas5p4.samsung.com>
 <20260109124437.4025893-2-s.neeraj@samsung.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260109124437.4025893-2-s.neeraj@samsung.com>
X-ClientProxiedBy: SJ0PR03CA0147.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::32) To IA4PR11MB9131.namprd11.prod.outlook.com
 (2603:10b6:208:55c::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA4PR11MB9131:EE_|DS0PR11MB7261:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f2822c3-1132-4977-487e-08de53b29f87
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?89tb1WIG6qAFOtGMQHyGJH6Aft5ucD2T9iMTSfpdOk+TUSVK8ZkKIFBSTZNM?=
 =?us-ascii?Q?bcIMl1n9hwYionRkaamwJBIVwFXFOteiH25dXY4K/bfpDXyuDwYXl4ytsNQf?=
 =?us-ascii?Q?F3nmG3WYXDliQ+kvYWg++p4/9nnsLFgaUq93BRsftaFCqkyfGKDamxVDQUTh?=
 =?us-ascii?Q?V6JSZPs4KtqXLGW1/ZjZfSzMiNQPAuV9fqvq3uU1kFQYDEBzqiaPE59+YHdZ?=
 =?us-ascii?Q?yfNVQUmM78iwPU0YaZeP4jDACP0wkRoT5NCNoYpyTRvLvsSqLt+dWtJTiX+y?=
 =?us-ascii?Q?fmgk4UmtkB6XbToMHGOOySJEKFfEDFu9N5aTXrTOieNsnpfosTFrH/Bn/x2Y?=
 =?us-ascii?Q?2bIEEfMgBz6274YcIfLq2qpDQwe/UOYb9gaAExIykAjnIemvGxSC8Ne2mjLk?=
 =?us-ascii?Q?EkCJYQ8VXGr5yQVghiYf6TFz5iYEHOaI+3ewDdHZ+ovk/fS2XsBwpNEkc2ed?=
 =?us-ascii?Q?tAQLQ6eIYfQy1q7cd1pgg8Jnd5dMmfhCx07Ho4hKvw0urUz1NVWvwhwie7+M?=
 =?us-ascii?Q?QZF1trMY9Lzqh563iqk2zHQr8N91JUR3j40Gity/j6jSPURrsCY1ZBqbK1O4?=
 =?us-ascii?Q?pku+UtkBPxHIhICmp4f6inXQAm3u10nBVhZ04Qqqa0MOtVXqe1kaqDcj5vQp?=
 =?us-ascii?Q?muIE6CZTOf4XybSCLh9/axKjzPkMJnRJa+b9jH2hl1DQBRacsGiWSElKRKkv?=
 =?us-ascii?Q?N0PuGGogX4Qwf6dRVwLkwAD1lSSR4iEKVuA1WH/2dwoXhMYlmnBH1p5QdyRj?=
 =?us-ascii?Q?zrKhFrXkMacnBMCSjKUGcIN8jMLJzd8dui690nrD6r1AYUOZKlZuGwTpKj2v?=
 =?us-ascii?Q?Tz2XAIHcYXUo0tO+2/9WasylHuy+nhO2OwauvHhy0bvS+4vN0yAeMB656yEl?=
 =?us-ascii?Q?iAg2b39K98pd3ADJaNA+EFbVVGpdOLKxphFIzZEvUPoZsCAPpZJDj3f4PQPB?=
 =?us-ascii?Q?dZ97ztsaUb0ZPFfivYT82oHxJgb0OqqbR+t+xppIZf4sXF9bXwJikmIK0j5p?=
 =?us-ascii?Q?//u0hHnkhaPJTv4XXB4wHx9sjNSVaEa7/wGetHvlkQhRQyvLhT7SFKZZc+ir?=
 =?us-ascii?Q?cDo73Qa00oCSuhQFkOyeK61FQeLmjlvItIDEb8PdzqPZlXNMvWGkaPt2YoLc?=
 =?us-ascii?Q?7CRjlY8wY1AK51z96Z8peHbZnMW2eZxQchbHA5Uqot/aH9kKbCtrxJMlTsWY?=
 =?us-ascii?Q?7cSEuz9qU8BCggvV+kftC29znBFpaa+JeLCwbRj5/s78QeQbmzdDzniRE683?=
 =?us-ascii?Q?gWu5qYISropEiUudnWcOEDGvr/J2vB58a5rKI/fRpnhdIsVmd6ge6CIWjMdF?=
 =?us-ascii?Q?h7x7r0Uj4OODheGvx+gwEAqdPJpjtBwhwkks4pz5KkD9F5+c4B+WUTDCUmI6?=
 =?us-ascii?Q?Zm1D2ky7rSSB8LBf3nsbJNb0pRaxb4kHWORCWcz5xTST0r7mUuLVlDLdKhkt?=
 =?us-ascii?Q?o50NfO7bq2vWNl+O/0oTwWO/2SU8qXEWbauD2PneJnjG+XJsg8UlpaDsFrzL?=
 =?us-ascii?Q?Q8OVlaOuSX8RM2GJxcZ7vosZgkI4lQxauxKxP3ed0X/gTudrEcpfdDlQRBSA?=
 =?us-ascii?Q?NsSlTwSmNKVCpJlPYDA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR11MB9131.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?n+Z8Olr4h9Zygw6M3/J28G65qvj93iizriJIBQBO7DPfuuRgJSvUVKB+0Ham?=
 =?us-ascii?Q?k4kVpG5WHMJAFeHYdwm3/2sZvENSWjcwqwkc8LSVzjUNmfGm7nE6T0Hrvf6s?=
 =?us-ascii?Q?LRRk1F0jr+RrpJ+k6dc9q/Gu/9m6QX/OgmWEbHtHBGlowX2FDMUIR0I6WK5r?=
 =?us-ascii?Q?fvRWLNHg85NI5VyChVltILZ/MuFPJ6G/sRoYg/2Y4MT4F6CI38tzIRTaX+aQ?=
 =?us-ascii?Q?Smdl1HbVP8qjZFtCjKABzYY15zxX7AU5qu0uzpP/84ntU0Zbj7htUOOWqKjg?=
 =?us-ascii?Q?pM4UIs2NSTwhtU+3C36YhYNvBIFdGoqrFSLpTaMdR+jYAS/+rX45ueXydfI2?=
 =?us-ascii?Q?aym63dbfKRbeHS9w3Gu8/1GU8724tcWB6HA5902fnxslVIWu9JVGBPC/eLiB?=
 =?us-ascii?Q?1347biBJUsPxgLhkEhhHtKcTocpmg4JTdQHSOIHjmA+2Y5/XwtBuAeanhQBN?=
 =?us-ascii?Q?QJRV4yyEjxuN0RiEAl+Cw1dcNwDPLtqzNISuBWETGOAr1qcKkE/rLkWNDDRI?=
 =?us-ascii?Q?xrELr0bbD3NW8BSEk8PLZ7SttWGuoM+whC8MEk3Us9rNb7go4YnVdl9DdZ3r?=
 =?us-ascii?Q?6MSrXuUaGVORU30mIziChyKX+AbiZFw6Z/l/kAbkYXaRJcQ/noWx323mJJrA?=
 =?us-ascii?Q?T97VdJNXQNXYx2lOUviyY6VQS+ZSGEqE/UBH9mj/Ga7tK9N/KDxyOayn2xAK?=
 =?us-ascii?Q?fMoFnF/VlHA2hj9lzLiZfrtKC9RK5S5Swb53D1DccSxSZV1bbVhYHIFUqG41?=
 =?us-ascii?Q?3iBE4gDA5jhHF6DLwZMNrPuTzJkC2De9F/PHdAO5Trj1Ohj5UfVIWLJxCWVc?=
 =?us-ascii?Q?/7IbShp0EsEu8HBz9AAsR/Wz4MCjDdlHo2uqhJuYnskeceCVJi1ZsbA7hBGr?=
 =?us-ascii?Q?wB5LQN9eOMrOhlVR1mk+f5andRfhFgfHAyWFNMAk74pO2BrABrWq1cwSTdIj?=
 =?us-ascii?Q?BILcbat+XzNoY8ko+AUD+00RHYmpx8g/S81gFLINrTaWX2n2OLbgBdVVFwJx?=
 =?us-ascii?Q?vaL2XH5VPrQZ0A4WxyF5Rz5DX+WcGI2Y2Ge+0eZ15Z412jnckpW1bx4Bvem/?=
 =?us-ascii?Q?9gDumr2JQWjsHBP3NsG3ftMCOtGNnpUAFmQ8DGe+JEGRzTPG1QZQ1xYzso4V?=
 =?us-ascii?Q?CrKGUGqas9uEKltcIdR72hIQRGFmNSInBxQZj0teG1pkgv7QoqbEkKR1/etL?=
 =?us-ascii?Q?Ga+umjfxfqkTP7CPg2uAmn4iCFMuIY2pn4675KtjV5d+8NnEpIxy+0kGVvgm?=
 =?us-ascii?Q?GagGb3nvS0QhkXJfvLDdrMp3857LUF2ng/sPzkwlN3VWOeEO6wQd7RvEdj6n?=
 =?us-ascii?Q?KQW5BJwBVtwxC+FmoCdaCs7PupsHDNU7y/99eJxhYbCBxkHPF1xogXdDOMo1?=
 =?us-ascii?Q?OXODqYw0S6Jd2EWIOOekyzVGQoHUSAZIMwWXeWLVbw+wlBO2jjTn/nxzHiL5?=
 =?us-ascii?Q?VAFE+YBRKOVVw2f/QNks8qWd8s5aV/qdge6tM8OagRhaik4rP6IT5LpXCNmu?=
 =?us-ascii?Q?fswAVkC/amh4E1U0bX/l03RWOJ/Skp2c7q5fN9HskFffSmidpnbwLqSuyGow?=
 =?us-ascii?Q?JUCjh0Ee1DmiS8BRfV/YmJAPCtcBkd9kXyjrSqEOTD2QpwBtoaNDuoIeb6NW?=
 =?us-ascii?Q?5M0pkydgQ2Gm4DNf8x/123DFuc/A/CQ9KBQrrsltMR4CHo04dtS2QxuKQi5A?=
 =?us-ascii?Q?POL8qgVw5M8VjRe9giidXeu9x3matK8w2qS3oV//5qFnK+sWqNw2ED9P0bD8?=
 =?us-ascii?Q?R7Gu0oX8ew=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f2822c3-1132-4977-487e-08de53b29f87
X-MS-Exchange-CrossTenant-AuthSource: IA4PR11MB9131.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2026 21:19:38.0207
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hzuKQSj5Djx9fqfqedJ4Xxgch/pOAcUYZ1MVSNJe/CO851ChFNUqF3gfXb85LrO7vZtdYyMDUV/UKYVPNphQDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7261
X-OriginatorOrg: intel.com

Neeraj Kumar wrote:
> Prior to LSA 2.1 version, LSA contain only namespace labels. LSA 2.1
> introduced in CXL 2.0 Spec, which contain region label along with
> namespace label.
> 
> NDD_LABELING flag is used for namespace. Introduced NDD_REGION_LABELING
> flag for region label. Based on these flags nvdimm driver performs
> operation on namespace label or region label.
> 
> NDD_REGION_LABELING will be utilized by cxl driver to enable LSA 2.1
> region label support
> 
> Accordingly updated label index version
> 
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

[snip]
