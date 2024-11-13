Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D937715AAC1
	for <nvdimm@lists.linux.dev>; Wed, 13 Nov 2024 22:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731535575; cv=fail; b=ftask0EOuxifDTFAL6ijjYFhmmD7GMJRNclkmrKryyzgsWDfvUDbt3cJAR7bTIwU9ke53moc52KSBPujFTp3FrwweZj6Ccid9l3ox6arwIotyedYckPlGFyInMZHIu1+0ZxrStKMp4LbfqB0+iXp5F9e/7L3Y6Fo9gVsv0E5UOM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731535575; c=relaxed/simple;
	bh=jAVEKgCVfl8Rjf59qt/8JJl0Pq1HmMZatkghQCB/Gak=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Gtzr1BNbw30y0tPM6O1bA0Rp9R/8FI0vUCs6BBUPcfcFPi32ECssTzDsZ3Ys7OcM3+V6Y2qH6pJY20sOMX13MGvxQ8OCGG9pUxiaCpRwuzL936tn2ukz6WbegWSbHKREpE5tSkx7scVPSbnxRYFtG2oMgkRYtN9UaaU3CC0+UAU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dyY6nIwE; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dyY6nIwE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731535574; x=1763071574;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=jAVEKgCVfl8Rjf59qt/8JJl0Pq1HmMZatkghQCB/Gak=;
  b=dyY6nIwEozF5K9vPBqTsLjxrIHG/ZrEnCzr9nzCdaVEBajIbD+FIOUxt
   XgPi0qWenid9oRyH7euglJyWdcFpwAGTk32t7UHmmOTHZI0EH8ZmSyBQq
   ljEKhV6hMAVJ+rBZEXwEJPhdl+evSndFZWGoyacge4h7CkA1Ayg8UzAgX
   a2Svo2jWxgWR/8ExXkJ8v808MDli24hMZP740np3NRDItGIm3CMjRwyJQ
   xhmT1AqiokqKlYYHahhE9rx6MesLpY4qPEfO9tG9zbhcpVTVSyhN0mo+T
   mdt5BAXHYt32Y0kcQqHSblBd8R7/5xrXZkP4reH0KA/bZc7geMRacYkwx
   w==;
X-CSE-ConnectionGUID: 3vyvqVc7SIOsG4FAk+9ilw==
X-CSE-MsgGUID: wCBrETQMSZuKR105Mc5HyQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="53994755"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="53994755"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2024 14:06:13 -0800
X-CSE-ConnectionGUID: eCgoFX18RgWFy4VuelC5lw==
X-CSE-MsgGUID: mOA8kPFBQg+Xp9dj9QVt0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,152,1728975600"; 
   d="scan'208";a="88396432"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Nov 2024 14:06:13 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 13 Nov 2024 14:06:12 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 13 Nov 2024 14:06:12 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 13 Nov 2024 14:06:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CvVcZB/Encm9cIdsaivvQ0ykQUpdXuO3rFcYPwVJcnQx4uECO5Zn7BXo+1/w6mCDbuUV3SLcQABe+Db6Xl4yF8AWCnYVI4Es52KczP9WK4Witv4hXJA9nPA6jAE6b0ZDvS2ndNWkiE0QOLS6CtpekiVBNRXNqUXRY1tnMPcmVjgxqv+bydLhdwPU8ZYha7zddfgR3ZS+r4oPwLea2SK5AE3LHbZYstOZpFhc2Ptd1F7aZyxzagUGR8zm28SqLzLOcq8Mu5a3NdNwd9l/PNyU8X9WkDbLXuIMva4AYLLSojz+jHyx4PwdLeidk3F9tXWfxxC6X0x3E1+xLodathZy+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ee6NQaQ+hPzzbMVtCJp1gOR8Y9if+kqLGoQIFjpllUY=;
 b=p5w+o2IbON9WQ6Po3WdYTWaLtoxGG5PZfoN9CsRhwBU/lcorbA34ZPuR0kdLMGVI3QHP2iJxKnkms4sxAjaPTWhhZedxeIlaFUS9nIhrZRsyFBmFyOmMdU2QnTVWkCAe7y6WquD+ySiljtaMds8EyO6i4JY4YUrTEaAiTJ+btyFdgn0b57IJ47Y1xcN+xCIcpgwXXm0R5P+NwV5IDETEvJz7GrVbKXrVW3AdsCQt1bhc3qMnOAXxyI70ZS7cLcO4oh/JtkFZKx3PhRqMMCscTYLmOcOc2iiSiTga4SXehAYj6fOn8ZFYpabud2FJGdFfQmNNKiMq2donf9lOAKw9Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by MN2PR11MB4535.namprd11.prod.outlook.com (2603:10b6:208:24e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.26; Wed, 13 Nov
 2024 22:06:05 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%5]) with mapi id 15.20.8137.027; Wed, 13 Nov 2024
 22:06:05 +0000
Date: Wed, 13 Nov 2024 14:06:02 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Jeff Moyer <jmoyer@redhat.com>, Dan Williams <dan.j.williams@intel.com>
CC: Keith Busch <kbusch@kernel.org>, Ira Weiny <ira.weiny@intel.com>, "Keith
 Busch" <kbusch@meta.com>, <vishal.l.verma@intel.com>, <dave.jiang@intel.com>,
	<nvdimm@lists.linux.dev>
Subject: Re: [PATCH] btt: fix block integrity
Message-ID: <673522ca9efe6_214c294b8@dwillia2-xfh.jf.intel.com.notmuch>
References: <20240830204255.4130362-1-kbusch@meta.com>
 <6734f81e4d5b9_214092294be@iweiny-mobl.notmuch>
 <ZzT8O_yvAVQDj2U6@kbusch-mbp>
 <673519f07bf7c_214c29470@dwillia2-xfh.jf.intel.com.notmuch>
 <x49bjyipzup.fsf@segfault.usersys.redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <x49bjyipzup.fsf@segfault.usersys.redhat.com>
X-ClientProxiedBy: MW4PR03CA0245.namprd03.prod.outlook.com
 (2603:10b6:303:b4::10) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|MN2PR11MB4535:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f723133-ce18-4fd6-3637-08dd042f5e74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?AvD4tjYzxaYjaXeQ/Nk3IDydWVGIn9ZD9IIrd5ilcb8f/Az9UfnvuWuYkUgk?=
 =?us-ascii?Q?H/UFduWKerhffEqyYn6zete8qm5jO73iiK3E33j5kghxrEr7iR6Go/0tErKd?=
 =?us-ascii?Q?m/feuw2NKFxgZ8tiqfneOfWj7zY+lkRtIi4DVC7anexvi/zV7JNBoTJg2yhr?=
 =?us-ascii?Q?1be9cnLWjgS9VIxFPLLMl3Xl0+GfqVHkKN8d9ra8TiQUCFJauO/iHresculh?=
 =?us-ascii?Q?1uRVvaaklCUbrU5li64HfSL8Kp/2b6m0bsrHLp3ImG3nLv6wjKuR4TLiTLHB?=
 =?us-ascii?Q?AV5L5LmMtEHROHLhntGe6sxE8vX0T70NPTawT9UQuGz7n9uL9rtG9EBFY5OP?=
 =?us-ascii?Q?KKpRATzPypn6vWxuAHG1kl8+hNOijRYLwR1RULf1N3cHmakjmcWS+TwZeOAo?=
 =?us-ascii?Q?rzHggLWtR5Eh5dH5hpXfDqvoGY2+aWcJHQF+xRVbBy5emBitndB/yGbmJHni?=
 =?us-ascii?Q?JKYGUb3OI1EBdAUJASYLW7ZrTbMJ4S6OcemFB4oA4iJjbBWiHfA8MGSi96x8?=
 =?us-ascii?Q?YEWvtMnVnx+p3Uzlx0/981XIFORcgJywzqGnuGTuxdcMJ8gRkGN7D98g87ch?=
 =?us-ascii?Q?uJQCrQTa0huPOBj3gAh28sdl4qAiUarlzM910tV4NzcKYB2rGohUyvJMeZpU?=
 =?us-ascii?Q?phCQYBa2MheQkHIF0o/GayErMaBeFFrjlBrZTjbHbTdX+arjq5/8qwBX8X8N?=
 =?us-ascii?Q?7+AFDAoovuvUhrwDUHvIfIJ3b/8OcfYsh79Ff0W1yWz+fc4hMda8h5u4DO8B?=
 =?us-ascii?Q?0U6j4e2HAeOtyQiaTzhdjt+ElU389aZF2ZqxFTGSTrk6Uu153f/fgSLQNX0G?=
 =?us-ascii?Q?ykDfZZFrtVILuTsrPP021GRbo3qTMFc2t8BXEUWxm7IktwEMklsu8/ZAUrrk?=
 =?us-ascii?Q?I7LFL7IyLX64gz/XwM4X1c6x812yBUJnEmQrWCkfbhDUp8BD3f2Hs2Ss+ils?=
 =?us-ascii?Q?igV6MDFheQ1u9SlOj/HXaX/6LA9g2Wfz6LcFc5gP8o92qTUVYrbtPRIJ9P1v?=
 =?us-ascii?Q?Mrm3umG52GaiiS2q3gDxaE0Wkdw/6memFn9mbpWVAJsQgifO9v7kY7g80eQU?=
 =?us-ascii?Q?IlI75QGw2BFgkYvnWNtxuxbYiIflSv37WKh/JixgRVddFYZHjaTR07DOWF1y?=
 =?us-ascii?Q?CSNGxIPU0kC0K5vUAM54g86IHL7Ffijuqx23U9TSpuwrhKhWCpW1f9pLXqtV?=
 =?us-ascii?Q?NhhgysxAVVg4ZvSl6O6+ef9zaK4eED+Q68IYO6aE9rtNMG8/lGKWKGKGUTfU?=
 =?us-ascii?Q?fqSDbpsx7w7TEsoZwrAywAQ8uTmVZG8Rs9pKPPZEdrDBGu25jig3RjfEsHOt?=
 =?us-ascii?Q?h/U3XWXL+DqnFkkWk0rPfvIM?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fK7atjPGh5SJHRWK9QIYMKGXatbR6naqkvZ33bUKl2FOwxyHvpw4CR9sMn8J?=
 =?us-ascii?Q?qNl5/s4nJSAKRfw7Vg2ECJzsRrq8z6nsZQPjazl6QgvP9ayNEvHfoD8M8QVf?=
 =?us-ascii?Q?yU2AA1VBbNUnSCA+3lm21WIt5up7zHQOrJYui1wjdvi3+L8uXZE1iOIbkTBh?=
 =?us-ascii?Q?tIevaywIqd+3IFU/TG9Q2FtB4e31V0LSs/OiAt6hRLekTZUo/qPEy5SKh7Tw?=
 =?us-ascii?Q?gsk5vOz2+GjaXqeHwaNcOLQ55Xu7S++/V1z+Ug3gw6qoW1v9QwtLzkG5wEUZ?=
 =?us-ascii?Q?x4VJlWqVZUnSuTv8QNu0mfzm61kJgaCeXcizrE3yy2E+dMNsdqMamwWtW33v?=
 =?us-ascii?Q?Gkr4Txo0WKp8Cmrh6gg1p8lcOHftDsKgOaoL/hYMKb9tLe/yG3zBAC9HW7uW?=
 =?us-ascii?Q?s5BnA95JojGU15Y3HWiI6EC3w2V/DGLFfeJjjw3pCiXQdGXLazjIzZ47SEzs?=
 =?us-ascii?Q?FqyRYsbFDbQS0RSLasdX2AiOK61LzNlq4+t0VgD6ZQsaLVZVs6LDS3lQc0bJ?=
 =?us-ascii?Q?hj5m1sD8l1vkD9FfUM/9bPgHocBLrzDRJPKRiffMTWU7sm/fIhn4CePSP3gH?=
 =?us-ascii?Q?HqMU/K1qoqBaBufUNTVY+JYvU0QFE0jBbCprggjjnLqew7NzRJtC0BcvrEX5?=
 =?us-ascii?Q?Pf9c5tyxgKzPOb2HdSPqeXdVxjS/SM434nbPJZsvk34wgqSx5q98oJG/d+8/?=
 =?us-ascii?Q?VmubpORYbJty8kkkr7+MLK03Djii5f4GK0PJyKecVaF06FPhdGPJjzmYUfQP?=
 =?us-ascii?Q?4EHUo/XuN4PmLfs6U2OuJ1sNFmDoVLONamFgvtTqhCvfuKFH+jQ++Xt0f9I+?=
 =?us-ascii?Q?cdP2h81CBKoHDWguDWXbarvMuHys2QKpGrGjmrXCWKxIqbMb3rcyUUIdAKe7?=
 =?us-ascii?Q?tPsb64faj79OHVfkbl7qUfq4dtH/pYB/y4olt3KA/iVb4SNQn1IRU5bQ9GJY?=
 =?us-ascii?Q?2EcZeHIrAuzIhEKo7rRuTQ4bNiq5j8N9aJDvR2AQ6BRxULXK4aO4kWkO+r4P?=
 =?us-ascii?Q?2fHVZyC0oAUTYLXMOCRGhEBxAEYjeXb6JE6MdaVS9Rat2ADE8vNBbRMJA+3O?=
 =?us-ascii?Q?c/WKP/BBp8WA6z7HIyVCroS7JNBvdP35nFOZkQp6vKNxQVgop/dYBIBmNddJ?=
 =?us-ascii?Q?Va/ausowctUkd5R9Vw8sYYVF8IfVzlhk9BwvSF01QDh4ONK8fS/q3ZNRhcSH?=
 =?us-ascii?Q?uc+hVAawg2YWoh4Xw0wuKZgy2ptis4Hg+dNQK9Y1rxmdwJhQzYAQvvt9HseJ?=
 =?us-ascii?Q?ew5LLesL1FvAJDVmHLqQCd/ojUft9t/uLCj+hSSLbCVxS1dJkkLC90poc/lI?=
 =?us-ascii?Q?SekxB8lKzN6KB5eIKcjfUlSw0Gwa4EU3VfUbFXa2b5ecLP73Q222+L/7b3Ui?=
 =?us-ascii?Q?P4T44WjqU22TPhYUc62Z3MfEhj7oHKSSk/jHSaV3Ys2rrQlLpAjqDH0O5bDl?=
 =?us-ascii?Q?FwPQx5oCeXffEJPeZb592VU9e52P60j4pjS0oVB7X6Uf6Up0JXZG/1qIKBeq?=
 =?us-ascii?Q?/tqdzoXjtNrueFxKKS1XwPejxW+3qI5AjX6sG0hXkmFncQn/KNdCbQ3JSsiL?=
 =?us-ascii?Q?g7vgHFesAZrRiAk5Zfqk3DObwMOU6tTzuv0ai3MZz3wPhLhFAF+0+FWtgjYJ?=
 =?us-ascii?Q?9w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f723133-ce18-4fd6-3637-08dd042f5e74
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2024 22:06:05.2981
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hul6zoVVh/6UD5llkx92Xy64Y0wNAZITiTF11wtwewngA/EDLjeV01lzet1UfvhZFmkBy7xHNQ0n3T8eFUBGAPQM5WPOvV/X3H/rIiHqz8k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4535
X-OriginatorOrg: intel.com

Jeff Moyer wrote:
> Dan Williams <dan.j.williams@intel.com> writes:
> 
> > Keith Busch wrote:
> >> On Wed, Nov 13, 2024 at 01:03:58PM -0600, Ira Weiny wrote:
> >> > Keith Busch wrote:
> >> > > From: Keith Busch <kbusch@kernel.org>
> >> > > 
> >> > > bip is NULL before bio_integrity_prep().
> >> > 
> >> > Did this fail in some way the user might see?  How was this found?
> >> 
> >> I think this means no one ever used block integrity with btt. :)
> >> 
> >> I found this purely from code inspection because I was combing through
> >> bio_integrity for a completely unrelated problem. I was trying to make
> >> sense of how other drivers use it, and this one didn't make any.
> >>  
> >> > I think the code is correct but should this be backported to stable or
> >> > anything?
> >> 
> >> Up to you! It's not fixing a regression since it appears to have never
> >> worked before. You can also just delete support for it entirely if no
> >> one cares to use this feature.
> >
> > I think most people are just hoping that filesystem metadata checksums
> > are catching torn writes and not using btt. For the few that do not have
> > a checksumming filesystem and are using btt I only expect they are using
> > 512 or 4K sector sizes and not the sizes with integrity metadata. For
> > the ones that are using the odd sizes with integrity metadata they
> > obviously do not care about the integrity data being transferred since
> > that never apparently worked.
> >
> > My vote is delete the integrity support, but keep the odd sector size
> > support for compatibility.
> 
> More generally, does anyone use btt?  Should we start the deprecation
> process for it?

True, I think it is worth starting the deprecation process and see who
screams. It is easy enough to revive if there are still users out there
that have not since moved back to NVME for storage.
