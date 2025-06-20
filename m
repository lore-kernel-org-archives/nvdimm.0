Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA7D2DF3CF
	for <nvdimm@lists.linux.dev>; Fri, 20 Jun 2025 20:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750450764; cv=fail; b=gVvJB2GtsQq/UkUz8pSKMKlM0AFALHXZump81jT6a7ZTf8m246DqyfxU0FCwpEoQSrWNkqJaPFqo2oic9HSiJY/WRKCNnnyFgtlB2SeqeNrMfsJSKxFjcWe7ZRv3jFwno4X73lbt0P9R0iyLZS1ZPD5wANVNZMD9BnDQ9Ha838I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750450764; c=relaxed/simple;
	bh=/lBkmRxRXuUUlT2FGnBB7hY8Xez2hyTgQ6HA4mjUhb0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=PBi6wr9NigLyc82WmH5jNIfpupdMfrEDdHvTlTf4mK8bsv7dCMs2jvOD8el2Q/kd2TDpkAtkoYMoB6R4qsYJ31bmnMixBFoATxpUfIJmr9rV7/EamyHEv4/59n6pm1SQh0vPf2qWlrNdyF5OgLInlCr7TmZDqcGSNK1FgG4E22c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YFPWzt/e; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YFPWzt/e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750450762; x=1781986762;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=/lBkmRxRXuUUlT2FGnBB7hY8Xez2hyTgQ6HA4mjUhb0=;
  b=YFPWzt/eV33u3nmLIb6Tp0tAcyKmXE7EQlRvw4jVA0AuAOB+2OaOXY1c
   tzpyDH09olmK3wwxBo46OXSJZGo6PW+Xir73iTdD5YW9987EfUDZFk9nO
   8Qxua45t0VZwwT6c9lNh1wJiw4D+WexFRBbGBi/z1/KCgx+8OWd/WY/FS
   yzq6B7JLncDgQYFzgJCK1znKirNsE7xidboL+WjUcmDjk3uoCUtWF9ZsZ
   IjQX6RgxS55FpL0vNnMJpGEjn8GTjJt6uNkpTXZ38o/jadHwXhUvR7KpR
   jept66JJDx2m1HrALWOqV6hJZ0zROSxih7w+ovPLkEbcGCgxrSiZZiXtT
   g==;
X-CSE-ConnectionGUID: JfBHtFFGQSK5w+rL4Jywrw==
X-CSE-MsgGUID: akJmmCP1Qg+0VuD/reW8mQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11469"; a="70292340"
X-IronPort-AV: E=Sophos;i="6.16,252,1744095600"; 
   d="scan'208";a="70292340"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2025 13:19:21 -0700
X-CSE-ConnectionGUID: yWqlltS2Tp+03TEtSrodRA==
X-CSE-MsgGUID: wXLlFjIvQOq0hiZbfZObaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,252,1744095600"; 
   d="scan'208";a="151543459"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2025 13:19:22 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 20 Jun 2025 13:19:21 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Fri, 20 Jun 2025 13:19:21 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (40.107.96.82) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 20 Jun 2025 13:19:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rf6nukfuX3zrtW50jPJ/35SDtBp8VrDxuiEZuEJNQRNUeCZSKHTuk2oSJa1bTJdejzgMmYv4bDBXugMN1x8R4Vji0+U1NDpX4+sYsiEGnttMH1oUz6rtQDXe1XoXE+aPwHLAzUYTP7P7ZwlidQIR3WeGGKNvjM6sUGiWwPa9njO6/wX1WM4M/6yuUMWivpIANU8q35sGn7XTA8PBlmWyvLrIHOU3js9orPpSMu1clk2N16xRXNmXzeyotF8duI6UcMTGp+vXtt63Th9iV3hg2AFsilMpCK9Og5wp9zA0u+Ayuggvir7985GzEGnaccGWMsJXrVsZbbfWAjCfxP3Urw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CVHRsSGcnVycsiWTdg6OyrV5cPqLciITwxPhJmE/1SA=;
 b=hKqEntayRAnDalKZlZsSzUPlz/wftly3RAin8N/ZNK6CCoUshNI/UjeNYqkhaC1E1bzFJ5IYhtJyyt/dEE0vJIPNnwpPlsQEJKCZGyFpJm2UdmyypomnD9KTr+3/gI2/sxdAf25noM/P/v0AN5iIvR7dflA67eNgBL6SJ1d8qOSE3D0mMxmjq46soF558h/h+OGZnszdvrlSlmJu5G1MgRH8GcEnS5XxLucpDhIR4JEEytY5HdVdXZ40X76hZzlzHY88icnchdRu2dVL3zo4Byey7BmFjKcw2e08gVHRI5b9nPul5mBclQKI1lqlVwgcrU+FijkygTFogQ89kbaGSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB8794.namprd11.prod.outlook.com (2603:10b6:806:46a::5)
 by DM6PR11MB4595.namprd11.prod.outlook.com (2603:10b6:5:2ac::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.21; Fri, 20 Jun
 2025 20:19:19 +0000
Received: from SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720]) by SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720%6]) with mapi id 15.20.8857.022; Fri, 20 Jun 2025
 20:19:18 +0000
Date: Fri, 20 Jun 2025 13:19:15 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
CC: "Williams, Dan J" <dan.j.williams@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH 3/5] test: Fix dax.sh expectations
Message-ID: <aFXCQ-Xemscm0vYk@aschofie-mobl2.lan>
References: <20250618222130.672621-1-dan.j.williams@intel.com>
 <20250618222130.672621-4-dan.j.williams@intel.com>
 <aFNimwh65aJIg-BF@aschofie-mobl2.lan>
 <7562edbc163fd8953b2b84e4df3f728697fa0c6a.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7562edbc163fd8953b2b84e4df3f728697fa0c6a.camel@intel.com>
X-ClientProxiedBy: SJ0PR13CA0075.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::20) To SA1PR11MB8794.namprd11.prod.outlook.com
 (2603:10b6:806:46a::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB8794:EE_|DM6PR11MB4595:EE_
X-MS-Office365-Filtering-Correlation-Id: ad4fe883-191a-46e1-2fd8-08ddb037bc4a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?iRg2MA7zoiWUeKZ8Jb52TqgsKZipnpYH1LNfxLPpTnMEtL4bUwb8f8gq+y?=
 =?iso-8859-1?Q?IL+w7uu/Oksw+UvJuVSrMKW15Kap07UwithqqUPNaUamMTRsONqjhUTr7j?=
 =?iso-8859-1?Q?Ug3RUr3tsPOCfILQNylcQ9fbcoNSpoWkdm21yzRnKH9jEmzTh2VTE7f+xC?=
 =?iso-8859-1?Q?oHHHKUf9bxPbRj+ZvsiE4R6HbBGmQzYmC4QOnD9BOiBuNuBAdRlf2TO3e1?=
 =?iso-8859-1?Q?gQB8rhnWEmz8PSvQPJcOIL9TYH+AZP5slCbvvxxar/Jpviu1gWJTQRBpf2?=
 =?iso-8859-1?Q?fB/VXrNKFZ5gryj1UiSCDj2O/cGJwm7v9jSX33Q644w1PAPqGHHYh7Pwpn?=
 =?iso-8859-1?Q?UeGQBRbxnpWun895moYP3G+qNn04GIAfv+MeDZV6hD2H7gJ8/EwJ9gehr7?=
 =?iso-8859-1?Q?BMX6eu12+Fggm3CdWWCYGjzUN8PZJn/QYpa64IdbZ6cGiz3lfH5Yaby+ul?=
 =?iso-8859-1?Q?4WjOuJpW5ZPbZkEN91JDomqV6KekfkumhKLsAa/jrk0IDVQ/F3CNzOJeCo?=
 =?iso-8859-1?Q?UfqRkVrkcBr+vuIlFYIRs6KetaVhiXNEFIQfQImHX9HItKZJUcofjbJ0Ij?=
 =?iso-8859-1?Q?P8VJ74c2c7F46cmwY78pU8MP9WQLl7hqWsJBykcfvbb/ySakQKzIr2qVfj?=
 =?iso-8859-1?Q?xL8HOQCLtBynPG6J6f8wcLYAbdHlFv4MKGqfH5kqSWOwXpsUCthl/S4fnD?=
 =?iso-8859-1?Q?K86EJaqSMQyY5ltrOByqBOe9DpgPs9Rk153agC7JDJNR4bmyhCDUJMc15e?=
 =?iso-8859-1?Q?baP4uM5Nt2pKRmJxq/MpjwtlXuKw/krbpnuT2FHQXOwpZZ6TswA+i9HhJz?=
 =?iso-8859-1?Q?ipbrIV7x1oRU0CFkYh3iWyaksyCBqPjtso6iI2hifMCa+0m6KOE5HP7YdX?=
 =?iso-8859-1?Q?Y7FyRl1ChlcLtS0uDtuTSG6YQvTpLalyDV2Vj8NeM/caxw6QCW6Wkt6i0q?=
 =?iso-8859-1?Q?GgNAly+sIR9+xbcr9ZnQ1+VmA4DshSWLWGqhAARL1u5Kalpj20qGPiI8h3?=
 =?iso-8859-1?Q?o4Dd7nr51f9De/ytb2uf0sLmrNKdtCUnO3xO3a6mx6EG6mn+D0/R8JkQzy?=
 =?iso-8859-1?Q?9z9D813aSec7+gj5cCfq7NSda+26IgYecygyg+tJJ7JfWxFuLNSl7qtG8Q?=
 =?iso-8859-1?Q?Lsh6JJdcQAbta2QUB+H/Ub5aIZzd6fMnXb0P9bAyxJ+ZOjLb11y2XX3UI3?=
 =?iso-8859-1?Q?fOreslCndSZnbpWTXgj8NJqOItMlFuewuLY1OyOcR+7QdNgSe/OtEbgTW1?=
 =?iso-8859-1?Q?8A74RmNL1tIAtX/o11aV+82InA0MP+3tp86sH6LUrI6euvXI6DJJXCNwEI?=
 =?iso-8859-1?Q?Ng9Umr9Bp+Co9Gt03/kssbcNZ1muYZPXB6CF+RXX7nf8WJOniDAeYtkfHu?=
 =?iso-8859-1?Q?iDPKwhc3W+DCLZUAxQOHqCwtcGkei2vnIZfMvvuvLFmeh8P3Jj11u+OA9E?=
 =?iso-8859-1?Q?J7bzDBH0dUtgo6Mk6d/NRg+O+2IJS5qUvJTMkrHv8sU9hmtCIsnj/3BE5z?=
 =?iso-8859-1?Q?w=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB8794.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?gR7WKEmG2crYdJRuRzCrZEbrp/OVO0vZZ6GMAJl+B26qT/FLNkTuaQ4wCR?=
 =?iso-8859-1?Q?10U8lcUDaILgPZ9GPh77Mjs4xAzXzF3OKpDi5atvdxe0fq1sOSDhOwvMgX?=
 =?iso-8859-1?Q?vUXLUYY5nM7sQV30NHXQ7TGISWILFAmoGESswkcvTJtQaIJG0Tjgk5pNYy?=
 =?iso-8859-1?Q?ZjKN+t397NDoWGDdp63KlwKpvISemby4l9WHbZgwuoh6IBGvogrBqCHT6C?=
 =?iso-8859-1?Q?EACeapTOWqtKKEvmQHAak/ZsN9DMDupXjAApkHTjZKqBDNVN4Z2BaGv1YD?=
 =?iso-8859-1?Q?BAMl9YZGxT7x5vO0l/dN23S6ILHUJzIsWcJ0gn88A3K0OhTSVs2EgtyMgx?=
 =?iso-8859-1?Q?kJlD9ebOogLvS5cwS/ri5xFSqpUSdeKLlBJTZw0NhIylCNODBlh6NybKYz?=
 =?iso-8859-1?Q?wS63SUGP2Ju9hmauFz7oZOUXCOWa0JZBnA0wO/H0+eOi1dLRcdS8DhvTgV?=
 =?iso-8859-1?Q?8P+2R2jkOODdHx0ZujWM+nCJ0CZO5eUgk2RPWtsE0BE6lKnNw+GrShonDI?=
 =?iso-8859-1?Q?fm+nY+h+w6V8YY0aY99oT9jMlowr9cz1Xfzm/cSj7qw8nSWWVkU37A8tRq?=
 =?iso-8859-1?Q?atwlr0XJScB11TVR9h+X2ZNbZVsjTfsmXmLkqVfysCpn/nzQOA/4nTke9Q?=
 =?iso-8859-1?Q?yR2T3K93V0K2WI/94QSf8AuTENL/8hL95zUsy3+JAFNU1clxTYd58fxkEr?=
 =?iso-8859-1?Q?eKhR3cetRiUs1ji7hgkCvzoMjsD5X+7KA8MDptc8XCJAfpCih0S6R2ja15?=
 =?iso-8859-1?Q?VPahIcd1ic0ZCLGTSrMhy/9+7W36zCCnJFB0e3nXB+FiMqMxj3rQcEdJwO?=
 =?iso-8859-1?Q?gLHxR0A3QdL+iY1aM/YDKBvSGYnheYYzdfLV2WfEtmsMB5cZf616GZc+0G?=
 =?iso-8859-1?Q?58TyxEKZG6fmiNKxVx9sUYK6NHhajPnCGo2GGQiSkzOYYAK0AnMiMv8kNH?=
 =?iso-8859-1?Q?59658kD+Kx7i+CClJbzoD/3rSAQ6sLxH2UB/Lm9cTb4gW30cPQsszPPlWc?=
 =?iso-8859-1?Q?CvtqrZSVP7be+T6FpuUcn4XYRiWPGFcd+sPHCYtZmSu3R36weLVZZc5I1e?=
 =?iso-8859-1?Q?Fq7jv/+kATBtN3ziRQ+PYvXDvqZzw8lazqeXyRfX0FEzvhDZZ2LgRCQjXQ?=
 =?iso-8859-1?Q?Jg52RJmVpS/4w/Mp++mpJzufPr8pAS6xHn04HdvK6JWMF1egOLMn3J/WEx?=
 =?iso-8859-1?Q?CJb8Uc8elkxT4G/zU41MX4m/9DHU1yHt1W9Ki5M3QQv9DLNpqGVlTKQaQo?=
 =?iso-8859-1?Q?CPr97JL8N0/NXuaP8WUc2JONAlnLV2dr+1TtiRcQDjA7TB3lI8NhFIglBj?=
 =?iso-8859-1?Q?U6z14SD7K9u27eJG+RPUwtWzy3XUZqiGPk0gQdfFbdNtrs5zHR7GgMkseZ?=
 =?iso-8859-1?Q?Cw5jAGQQEotHRUNuOZ1iYTvl+NQNDtFBz5JwE1+0vejelVWolPnAqAXe9q?=
 =?iso-8859-1?Q?e7BoC0uaue10p4gqmDfsbsjnwuBRhwqDjChzmP+Zt3S3FdjjvBt1o4IOs2?=
 =?iso-8859-1?Q?44wtN+Pqxejv3zbh/CMceDLyTlJQuqwAQINw8JWdxx8nlhvArnXAIrOsPQ?=
 =?iso-8859-1?Q?u1qQVVa4CgayfKQXZXhdn3EllwDwmDVX10igQBld7bvZvrHLVLSf+TpcWX?=
 =?iso-8859-1?Q?vGGWEJlDETZNKFrMnQoDEyAMONqErW2GXf8GX/muH2UP78rJMU+QKMbQ?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ad4fe883-191a-46e1-2fd8-08ddb037bc4a
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB8794.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2025 20:19:18.8065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n3lf4Dc8rOqrNwcDrTHeoO6bnIh2mt2nnw6nin0GVB8SbvYbdfBJVX49uvkZW4tV1bBM80HM1ldzVnuJqAhOdqTjRxbaH2RGYgQnXDfniLQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4595
X-OriginatorOrg: intel.com

On Fri, Jun 20, 2025 at 01:11:00PM -0700, Vishal Verma wrote:
> On Wed, 2025-06-18 at 18:06 -0700, Alison Schofield wrote:
> > On Wed, Jun 18, 2025 at 03:21:28PM -0700, Dan Williams wrote:
> > > With current kernel+tracecmd combinations stdout is no longer purely trace
> > > records and column "21" is no longer the vmfault_t result.
> > > 
> > > Drop, if present, the diagnostic print of how many CPUs are in the trace
> > > and use the more universally compatible assumption that the fault result is
> > > the last column rather than a specific column.
> > > 
> > > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > > ---
> > >  test/dax.sh | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/test/dax.sh b/test/dax.sh
> > > index 3ffbc8079eba..98faaf0eb9b2 100755
> > > --- a/test/dax.sh
> > > +++ b/test/dax.sh
> > > @@ -37,13 +37,14 @@ run_test() {
> > >  	rc=1
> > >  	while read -r p; do
> > >  		[[ $p ]] || continue
> > > +		[[ $p == cpus=* ]] && continue
> > remove above line
> > >  		if [ "$count" -lt 10 ]; then
> > >  			if [ "$p" != "0x100" ] && [ "$p" != "NOPAGE" ]; then
> > >  				cleanup "$1"
> > >  			fi
> > >  		fi
> > >  		count=$((count + 1))
> > > -	done < <(trace-cmd report | awk '{ print $21 }')
> > > +	done < <(trace-cmd report | awk '{ print $NF }')
> > replace above line w
> > 	done < <(trace-cmd report | grep dax_pmd_fault_done | awk '{ print $NF }')
> 
> Very minor nit, but since you're already using awk, no need to grep
> first, instead you can use awk's 'first part' to do the filtering - 
> 
>   done < <(trace-cmd report | awk '/dax_pmd_fault_done/{ print $NF }')
> 
> You can stick any regex between the /../ and it will only act on lines
> matching that.

Thanks Vishal! I hope to remember that for 'next time' I see grep and awk used
together. Not rev'ing this one.



