Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D65FC39FEB
	for <nvdimm@lists.linux.dev>; Fri, 29 Mar 2024 18:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711737919; cv=fail; b=OUtGCGQD/3AaziXYyQdvOknditjGQezN6BK3sK4etoKrJQHYvLCobZQ+cCfo8ktZjvWceL7Agl+M5Z9gz7nD+Fczl1bW+kDe7SQllB03WxmDCYCkAe7EReimqheaHbaENmwwdpv5HoBugkv+O3c98m5Gdet1e8mlmQGjAHEhN5g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711737919; c=relaxed/simple;
	bh=mZDQbGVCajlnxx9eKJQqMIjCrEnJ0faWw94n5taZmpU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=J9pwMkoAF8vlQNqgRw7er/RvtvPexzZZSWV5IfEAj7p4nEwTrGj+ECqTqa/HJIcDLvFPOx6W3p4oHhivSJcyiKbD23ABumFXyk+IKz5t1nYkXdCK7T6T/IXde44FFfuizr6rUTevxSzk2ZpfMwrXs/OhrJbrIIq5BfDFJT9O31U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G2TLVodM; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G2TLVodM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711737917; x=1743273917;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=mZDQbGVCajlnxx9eKJQqMIjCrEnJ0faWw94n5taZmpU=;
  b=G2TLVodMUAROY7JxNVx6FpK8V7DO5A05NeARN5Wp6BEYXLzlq085v06L
   vh0fiY6Kbumh2Mm7a1VWvj9x8hlyXP7x5dRswxnXnxkL0hU5Toqn0qiQv
   FkhndFCSQCqgMh4CaecK/Vdsa7O12rl4pLRHpI+ImGdrSUSyDQ66YS5+3
   BbSkbVHknOta+Z40BAuOuLMVeMSWySflVE0j8+l5uCb4aMBDdhUvv6gBN
   vBMUFJefe4T5Mrq8VkPrIPAroG0vjUZ486BkVIRP1QcJ1Yri3/vOhl3aV
   T3sGzbsa5+RuD/N+FrsgBji/6g4ZEh5Zt8928tLxpypwoDtFmX66EUAoD
   Q==;
X-CSE-ConnectionGUID: CQXDNracSPyYg22EAiMnzQ==
X-CSE-MsgGUID: luJ3d462QKeciqXMLBDH+Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11028"; a="6768966"
X-IronPort-AV: E=Sophos;i="6.07,165,1708416000"; 
   d="scan'208";a="6768966"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2024 11:45:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,165,1708416000"; 
   d="scan'208";a="17455789"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 Mar 2024 11:45:15 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 29 Mar 2024 11:45:14 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 29 Mar 2024 11:45:14 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 29 Mar 2024 11:45:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EdDz+sPJ8TJeMUYeSmB7Fc0+a+64A4MySIeGvKlPJiifna6EloWGIbVDJ5J0IFZC98o1bfk5//kE1Ahi6x3QI2l3es8TtqgBGkAlHxfa6InhrNVzZSbGD660z4Css9wgDW9FzM24XlSYdOALoX4SDEovoeKDlYReiH7jmlOsPx+vkcvXzD0rMbqcBD+NPrIVHbUkSqtM4gAOWTVviTJba79n1iazBWLmzVDanlY9jUYDp6IW3UW8mG1p5ubCLmDtShObi1BLPOby3rsWWg1DDEo/pfu51W0/yM7LccBt0aLB7wRyD5qggvYd/D3/4aUWhinLpUeaTUFGWfhEF2hEGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fDPhPAIUTnn1+7h/5O0RXlYypECIpvnf7TNMgrhH/N0=;
 b=jIvW31UThqVbgDdL5y12hgSH4+1YZkCBG8DHG1TiIVtu3jVO8G8g+9nCbCZ0gAtEFO7w3z8mjYTEXCEWc2DckH5lER/IhKGwXNnXUsIJsrkHDwv0BWDuTje3cfPw2oAQvTprHDQ1n/bwDv1lPbdcKJnXB1ZnUy99oFUGsX/K9oMond3/VIk8tXfZOVwAImer4rjxw/32mJfRuhog5JhRHZcAUpaVX/cIqQzLZJcHNtDrlcKfN7nArXnhVkfCyCUST9Q7sWLXLQALzhozqOfRcBzt8U25ffUfvWR+RE61jIcG05MMGWDriZg3pg2BZHL54nRvmYEat2WsYmqC61SwlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DS0PR11MB7383.namprd11.prod.outlook.com (2603:10b6:8:133::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.41; Fri, 29 Mar
 2024 18:45:10 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::82fd:75df:40d7:ed71]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::82fd:75df:40d7:ed71%4]) with mapi id 15.20.7409.031; Fri, 29 Mar 2024
 18:45:08 +0000
Date: Fri, 29 Mar 2024 11:45:05 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>, "Dan
 Williams" <dan.j.williams@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Ira Weiny
	<ira.weiny@intel.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Benjamin Tissoires
	<benjamin.tissoires@redhat.com>, Yi Zhang <yi.zhang@redhat.com>,
	<nvdimm@lists.linux.dev>, <kernel@pengutronix.de>
Subject: Re: [PATCH] ndtest: Convert to platform remove callback returning
 void
Message-ID: <66070c31d03b3_4a98a29465@dwillia2-mobl3.amr.corp.intel.com.notmuch>
References: <c04bfc941a9f5d249b049572c1ae122fe551ee5d.1709886922.git.u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c04bfc941a9f5d249b049572c1ae122fe551ee5d.1709886922.git.u.kleine-koenig@pengutronix.de>
X-ClientProxiedBy: MW4PR04CA0301.namprd04.prod.outlook.com
 (2603:10b6:303:82::6) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DS0PR11MB7383:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rsa/fiZTvPa3l+TVyTe8jEoqvh+y5GGFh8IQFubZs5ShdQoJePbI4Qj5acYOKVqk+HtcNXlLz/VrJlew8apphE6KQWgqfwpldP3Bcm+33jAVCpWgaxC09wFuJPe8MFAqVohKKqjXGx+Fy4Rn9I68x+YmQBWikEAJ1+82cUA47hQhPE5YUcaoQg0sI3PAfgFjvDtFYWqaJOKYOMM082Pj+K72KDb9BmC54H81PGx64dfElkBQcMWvbqAAE//f53s3PL4QclriZ+g3sIThCn8mNbDYB0dvghwwWZ0P74b6nDB4T3ZdtsIW/uyv+Yno0r2pJnY33xVoAPkh1jLtfLug+0fNzdSDAbPrKK4lLB4A8V7o93CEaFDVDkKTqGPNbofR/HYWM+fAQbj0LJqg33KYPNyJm7UDxOhQUjESQgRXn+wKFvWzestSq1Bo557hv7WSj+PDgM/86oI5SBkDEuCbQCbqb4LqBfwWnpQSaewX056J8KtGDIUbt16gUpgUhJ5gCSjx7vnYK7U2p7dmbekc+uXkAj/YE8KGewOjIlfRe2Mm7bl+92xeHvLR+ZoftCjRTEdfbzmVkTfCdJeq67a5jP5qMCYzF+kM7k95KyEkd/qgFlcyD8VLGqmDExC2JnFjXaBd0ZZCeAzDyMaa+6Yhci4qiLsBH1D0Pm46pwWpLAY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?r1WTUV+B6ysFoBdsOR3H3Ak+QNWWF1ZdfVh4x1d2CHx9EmQA/bufaJfGRo?=
 =?iso-8859-1?Q?uNlT4xdQvZZINXh1ulN8PogcXJp+oTIC4Gmqog592+3ZtY8EG0XpnrOBRm?=
 =?iso-8859-1?Q?pMeZgo7M2bscQxJfvExVmB+nKsOstFj+TxJDQnDt6Q1IvWISYewT2gfznE?=
 =?iso-8859-1?Q?fWm6PGFtCzsg2xD86Rk1BLsjxlKzTaicYZWBN1gH2BlbtpqsV2W+uIII+S?=
 =?iso-8859-1?Q?8fIZFlyzBhvDTMEriGbLGX4fyercS7UFr05amuvSlOpztIU6g7cBgyn1Hc?=
 =?iso-8859-1?Q?mlOR2tqIEmthjhdIlC+6vgB8d0bHB8odczUsDa4QI2y6BSrfm933pP+qpK?=
 =?iso-8859-1?Q?VWRWOp2V+LipxzNEBffnfIu+mvDxIQ0UVSwo+VxvdAWEnbmdYzOQ/FA20m?=
 =?iso-8859-1?Q?ePa1jZrnxDvcRV9m7mxXyEaBaAwFYeBt7fvOf/WoigAOKc3zEuw9e3ymtN?=
 =?iso-8859-1?Q?Xq5THUoQV3dwXa5ciVV6ia99j0k6wM0C9t66LtrCxEgaAGQ+EysxYmNozE?=
 =?iso-8859-1?Q?hkzZM71BW7F/EUDHCpb6KKJ64yHUDAllvNaH7yN7DOXk1VwDFvfCPH/hM6?=
 =?iso-8859-1?Q?TIqLg7jwAyGAQt1kPHAw9LVYLgbErZOMgijlOXLv3176NPcbPYDW8UBSx3?=
 =?iso-8859-1?Q?Z9xiUqzdt3VXcOQ4qS0i7gutrMbeNa0Cbz0S28/FYIm7vGbABsDLakmOAX?=
 =?iso-8859-1?Q?qSEe8ULo9q9stxVaq2zRjQw1mBj1tNB2AwFBoN7+nOjBLAnGfXJ3DVz90K?=
 =?iso-8859-1?Q?/N0gMLyvlmc0sVvL8aCwsCJ/M5Uzl06+SJtByHd8P3o0A+QfxsHFcDd0CP?=
 =?iso-8859-1?Q?KRShRZZIH0QMBJL4RklwFIl3sKDFCjd4ae1dwXu91s3UO19ZmIi1nWULZQ?=
 =?iso-8859-1?Q?MiFZpxDY2uPe0S5cJ0pgAGQoLnJ15QAUcCiRpX8MtqnI1+gGl+jLbgo1TI?=
 =?iso-8859-1?Q?VTjRJPpEvccLjclv1DQJ19Nfvdad2mfSJ/o8mzIfwRd1qmPZW+v8Z+agNf?=
 =?iso-8859-1?Q?mzLB6aNUhRMWzteZSdQ1GIZcj47Vo9EcYrxHH9U2YN3n3sUG7bJ3zXDVdG?=
 =?iso-8859-1?Q?BRm0UFbo4YE5IB3rfiAgHo5UgVIcSaqw+LDv8G5G/3Fzyz7ia7x2lzv+vV?=
 =?iso-8859-1?Q?0ey4IPVkHVbLAofbf1PxytYwe/QpWAfxG03TAvHhROiHjZ4hhRjBmUIyRu?=
 =?iso-8859-1?Q?eGeowIKifdENGVVXNr1FmJB07HlRW/cMvY8sxld4boW5sm6nMfXSuLTI04?=
 =?iso-8859-1?Q?Ib+kdRX3HLhJlJ04+CoiADdGxK259HmIdhe0S0C/AJFwmTWSRyfsXS5CcT?=
 =?iso-8859-1?Q?TyQufo9nETc2m0wgpelWro2SKUt1uC0xdH+JHCJ7xDvhcgxztjJfXSns/8?=
 =?iso-8859-1?Q?2MbiyyVTQ+vcIhuYQzLl9SuEbDClod58JTSDuSMjJec+UiRwTZdmGPAXTj?=
 =?iso-8859-1?Q?qbLtHTmjBJWKgaIlqnP1QlYQNgeIGDdhmDzQZMoRsTeB9bh3A2LIDy9Jh9?=
 =?iso-8859-1?Q?LuO4qWk0SDgsd3vJe52f+/SEp6LWSwmdLUi63iBrcoozC3MJ2Q4Uj/tM1m?=
 =?iso-8859-1?Q?M8UKHcl8YkteMEVRbyX5A4aI9BEfKj08YWNyculbMqjyDUrsmz5EEsZv4q?=
 =?iso-8859-1?Q?XZAfZD0SGdHHS2sAiqYcc6mF/mZj+CtyG4+SjtJ5NrrdOhhaSi1TssUA?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c89de08-4072-463b-1964-08dc50205b4a
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 18:45:08.1654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G3IuUNPvYj8n1ajDCzR7z/SALMwJbeGTfYMyhhe+r/l7xd8GRhoYMei98geINgBBzps2Cp3h7fCkzhJSM9HqKHH8IPGGPccGZ3kA1ytKRi0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7383
X-OriginatorOrg: intel.com

Uwe Kleine-König wrote:
> The .remove() callback for a platform driver returns an int which makes
> many driver authors wrongly assume it's possible to do error handling by
> returning an error code. However the value returned is ignored (apart
> from emitting a warning) and this typically results in resource leaks.
> 
> To improve here there is a quest to make the remove callback return
> void. In the first step of this quest all drivers are converted to
> .remove_new(), which already returns void. Eventually after all drivers
> are converted, .remove_new() will be renamed to .remove().
> 
> Trivially convert this driver from always returning zero in the remove
> callback to the void returning variant.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
