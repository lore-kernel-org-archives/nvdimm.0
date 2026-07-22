Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D033A33D6E6
	for <nvdimm@lists.linux.dev>; Wed, 22 Jul 2026 00:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784679691; cv=fail; b=X+SsgnnNiOePcf9/OnPRub6dbkLesng+BXEhVw7gRDG6jw8Bfoz493Ai36OnLzGu4bQHDCvg+Z1QBLLoIvYxLqIl4i+lOdLVtp4PHRs19wJuFNiQA/g0DbmMvAyZWeQqLcEXxea7UhqQB76BdnE4KQl/T39qnir4W6lv1QFs3V4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784679691; c=relaxed/simple;
	bh=hZL/FFuN1rQ9XdIJpPSvLpb3Z9tnXbVLErPwxO44CcM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=L7goIMQypLTG3BgKc1exrPpTWq5ljD76NZo52Zr9+tx+W6Z85ckglPzWK1xEiMgxQrvcuqWIO90TPhFR7aBxlGekHCq+IjY677VzpFWt38A/r3gdZNrFIhMJBEvauTeZCl0RZooiWgHeDGm63FPEnLtngyNrcTstjuDK1JGQqxU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WfB4eSiH; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WfB4eSiH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784679688; x=1816215688;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=hZL/FFuN1rQ9XdIJpPSvLpb3Z9tnXbVLErPwxO44CcM=;
  b=WfB4eSiH8fls+exO1WiNnZmjEgYcwnPmWVgS1v2nk6rkxiNmR8nIp4I7
   J+D0qPRuXEScA8D7gALtSDVf4MGMvHOfpJFBjHb+NANzH95qKjp8UQ+zf
   wi1J22bYtRsB4GXdR8bTFJSYIMEmp4jYbwtWvgSTmF5Tid7ja6pcKc5rf
   2uuaiHhxbkmWhaFvF/IDSNB5EVqMhdILn24t2H1XtUekGCHcn2cJzYwrk
   7xodN/fUluFbPjV5HZtp0P1reQeFmlW8a60EHcuRY+nU+M+LHsIyTDRry
   UObbxzA2pG8IqQeuim0EoJAAvkXScpS8oFOxaTnki+TeZ1tuUJhKo2p5q
   g==;
X-CSE-ConnectionGUID: zAh7uWNmQVGTsaYldaBHJA==
X-CSE-MsgGUID: k51PybOjQAWZpmNYfTi/bw==
X-IronPort-AV: E=McAfee;i="6800,10657,11853"; a="85153864"
X-IronPort-AV: E=Sophos;i="6.25,177,1779174000"; 
   d="scan'208";a="85153864"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2026 17:21:27 -0700
X-CSE-ConnectionGUID: SEqJC7g7SW+Cnywiamdq6g==
X-CSE-MsgGUID: Rhw5TcwTTeCnW4LlSPVJcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,177,1779174000"; 
   d="scan'208";a="259888683"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2026 17:21:27 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 21 Jul 2026 17:21:26 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Tue, 21 Jul 2026 17:21:26 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.31) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 21 Jul 2026 17:21:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vHtQTeSyyx5p2DZsP3DVIyufAJE+yDDOLb5YXQY+xzf9F9MWtKOP+0RC40qFOed2I1BdHarEQkWqn/GHWp5mnG6lAOkhJNENl/G6lsaGZZnPoTInBu0Chf//I7ap4nuzVrasoisL8swxz2No3cvJdLuXHFIKaPRPxI8D4mjMsFVlsZvR+B1ZJvh76MGVQPORrCbf/XMydDZ+pIHAzw9N/6oMAouLIEoz8YzfS0pmYIMe74w/mcNdc6hg2qOBfVJK15QRWXYXqykzaMudAmIw39hOnkmmg1vNBAFJ/5Av9yLtiY+K+YnIjSKhUswj88Klc+TnwRNhrfW2rdf5NNzeTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZRpegIbE187kyZLpKPdc4dTRXuIXhZfV4+hCJYDULog=;
 b=ev2hob3rqtuAVBmXPJavZhWJGNw/+8GZpx9RBMhGSxtmR9rD5kka4hU3AUwxNRjJG5U1l8Im/yRZqobKU9IALVIwUmgYM92cPaelbKQKJU5Pn0fB4pNYc5xqZFic+k/dsl24JI4r6d8MwVOyF+gx2XrTj8xi7R0WBBoL0SLlFJp8Td+59/4veU1//McxtJqV1n8JtRURENI5o4pgNhG5UC9jHvaLi5B2yVtb36KPg5qX+OHG6RU5y4ATSPkLz485/RfndUjnu1nUZ5s8kUBetTDqnsYHVAyIKkKRV/LaDkjJtk2Ic4mrDgW1WKkzYXKv3jCbrtXhXI0Anp2sKTar2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by DS0PR11MB7998.namprd11.prod.outlook.com (2603:10b6:8:126::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Wed, 22 Jul
 2026 00:21:23 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%4]) with mapi id 15.21.0223.017; Wed, 22 Jul 2026
 00:21:22 +0000
Date: Tue, 21 Jul 2026 17:21:19 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Richard Cheng <icheng@nvidia.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH] test/cxl-poison.sh: test scanning past fully
 mapped partitions
Message-ID: <amAM_w91VuN_1t6s@aschofie-mobl2.lan>
References: <20260701044205.1589967-1-alison.schofield@intel.com>
 <ak9yQtGEvMWruPhV@MWDK4CY14F>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ak9yQtGEvMWruPhV@MWDK4CY14F>
X-ClientProxiedBy: SJ0PR03CA0338.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::13) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|DS0PR11MB7998:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ad5e47b-b4c1-4942-e4bb-08dee78728e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|23010399003|10067099003|11063799006|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: EZNz6U9Sr8d/4HsvQ0btQEhq4S5IElLI6xDTjuMehVvyRillKNiy8MszFyOSxRMFAf/E7k48EcXAZaRhZ51D+5cmXn8s/nhKHEo1LFaeKgnUR6J3hZe5kWjzzsbqoarbgaRX9HfrOpHw7hiucxY7bETjepqu26S9E1fxXqFUOqH3zLs+IdksXNq066VurPdXjwwkULn5lqzxBKELsFTdmHgtuMkCGCud41B/YGDM9JaoyMAJM11y8jHd0SwnCBLh2Zx6f1BTBE9q0lTLom+HmcrEmUONmhblzRk/HujOy5PCd8dohNqmvEwr3MUaPoi0QIcySil/gAFuZMI+875HItxxyl/ui2Thi8jHSH4vcWcUfU1nEWMre8j9DbHrzhdandPi7wRE4t0dRtxZZwjhu7JaPiPsV+YaMIcPEe275bkwtd029Y41hwyBkXxvOZJufkkVs+BcE7Z+55gwoMepDnknqTKfnDrsZTe4KZ6kOpU4GkSKTHi9tAoPJjddIPToWy7oRh7Y1fYXe4hOKZtS5sE4RL95oKM4h4aq8TW13nSLWLYjT2ZWhXyX8ZpTa9ROIitNZJUoo4IEII3nw2tMkMP62b6tKAccBXg6M03ds2JuFawpiiBR5fEZGm1JSmyiLeGRP8JMFWlUK8hq5hD3FrHilPT6+Dgp/RC7NNWVG+g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(23010399003)(10067099003)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?o25qMhAHPB+rSHYdiOjl7XpUbwrZq++fnsReiG4iiKM8qiy+4pF+wd/J/vXK?=
 =?us-ascii?Q?8ueSOtbjHUjAs0YkV/zK+CCg/iWKXpFFYWDm5s4QOkRFayMYUQNxfqYaisn/?=
 =?us-ascii?Q?/g9FgzxYTorqIM/JGs8Mo5Vu5nRK55eUZ1VKfvPcfbXw1HuQ8j6ePWR2WXxe?=
 =?us-ascii?Q?yAZFeIzgi48sMNWQ9octBKlJTvwnuky1gkpuXD8osgtPubc1ds/hXBBS1dNn?=
 =?us-ascii?Q?em5zfhA6g7tGmrUjVk+g/ZIccTGVfYY+muUcT4UoGpSdYqdQoX9WcUFqD47R?=
 =?us-ascii?Q?y8pAzb/7J5XJoDjjKXsZVE5ErLKMlPY+KIBp2YLFvStca1nZeWSVxernZpsn?=
 =?us-ascii?Q?jDuYhfIKpYvhyANoCAFoYwjfMCk1JkG6JnHUDi1R39pUOCwKdKMWK6w9Ku6Z?=
 =?us-ascii?Q?PAlesizfS6Q7EfdOEKy0cWa5XKSf/8Yk0j7CuEcYhRqPqjzjqk6VosWv0c4F?=
 =?us-ascii?Q?VlgKr1lmkt2YJDKWsTJRWmKwkGTeFpOmA7j5uVf7ZkWhF9VSGphiZPqh890g?=
 =?us-ascii?Q?F6XlGOtHK/yRIhsiKK4x2HQbD9G/r1UsNsCrqmKznXn+wNQYsEDkmZjqfiYF?=
 =?us-ascii?Q?ic5pQf8TY1gRqcvRPN7sg9Eg5DYFTdWna/MZNvxDD64IdfFiK4YvIRwZrUJp?=
 =?us-ascii?Q?raQqLGzWe+fsXCvsbW2//dK6iuAMofY620p0OX4iiKtTiYWGnQs5Lfp6KhK3?=
 =?us-ascii?Q?cDozXGIYK+JZP8zXoRmbjBOJAulG0yNvgwivSHVJeqrXQrOyBFD9mRoW23OR?=
 =?us-ascii?Q?B5859ZPLv43qd6qa5laSyQVRyiFl/fSrhcMm6snQpxEvQnlLuzY+v2j5eU7C?=
 =?us-ascii?Q?0jZ/0eVxF5Hx99h3X/X+xocX8oDzlj/o64uj/hQlKbRcX0pd3h041e4TLXpI?=
 =?us-ascii?Q?K1OoM8TMz9UIb9Xk0u912GkAnUltAwkQRFJH/kyy6EDGibDM4f+zGA2f3Z4Y?=
 =?us-ascii?Q?y47pzmXlkhVXsvYZLT1rPBKJK/E4s/Xg05idvswijmCfLnpCU1wjOlZI3l5a?=
 =?us-ascii?Q?sTHfbs9P0oA+yPwTEqhqoAAV9m0oSwTA5KwEdLZ+svQCf7MTm3fHmKGNdetJ?=
 =?us-ascii?Q?ICMIBbuTsh2Z36oLc11Z34jqY2R0soS/2oZ/FVGw/myuJAXnkwyNpfSCjAre?=
 =?us-ascii?Q?wBOcULJHZQmez7sijbByccemfd/flbWw/0t4/0/WSlr7ZsMrb8bvD/hTH4hO?=
 =?us-ascii?Q?jAnBb1Rqo4xMYAS3eEulaPMn9wpmcEYbKKe6hrRdEbog5oCrcn5WXrM/qLZU?=
 =?us-ascii?Q?Ak8sD0ABbB5UzqcDz37x1Dml++nUWLgcaxOMzzAuu42BGym02OBzx+NOzpF5?=
 =?us-ascii?Q?OoYlIgdyqrYJSdx/hPG5NPBVCRgEw8JwcmERTqFJg1IW/HBfWupLPwVVhFqY?=
 =?us-ascii?Q?VE6/e1jWr432pYtQBXWZmTvv82c0rkYZdaLxPAiOadKVvaCp/9yZq+/ZtT7A?=
 =?us-ascii?Q?970Hjd2EIP5BnzHxJL1mc/8QGj0BqGfVr0hpbXQzn9MqEU71nZJnwd5Rz0CW?=
 =?us-ascii?Q?QQweL/ckbH9HWcvVu2zmqugpp04arg1VqK1KlHFfSbyyXjnRVjoifrzZ+s1x?=
 =?us-ascii?Q?KX/P+Rj31s6riMpVin63OjPxRCg7UYrtNSWUriu3Gz2i05wNDhDKAeIXcLiB?=
 =?us-ascii?Q?HCJtYeggf8BkWa91SNwQt5+pTxXa/UxzvOaNMlzt/W9A8jA2Ul8k+9Mco2JJ?=
 =?us-ascii?Q?YqimvRl/a4Zo5jHiDNX8H2g6via8DJyxHh4linrhwZGBsvuPVm2oGbrwTdNK?=
 =?us-ascii?Q?K+k8l2H9PMXKbGZDB4t6Cjf7h4mXNwQ=3D?=
X-Exchange-RoutingPolicyChecked: Qa4S4COnKvS3oDc5odkmhtxzU07oZ0tRKt/8mGoozlOxeljX750tWeObCkXNd6o1UguWCvSSqNJfC+HW64JaphvlL0ncDEJU9b6TboPz5qz8YNrFYXW1kYcViiFxabxwACfxAPyMcfM/LzZT1biUPVitcMEq19GtXtSf19P+uHnk7rUUYK+M35vXot7gSKl6RLe+yToHLLC0jvmRQMGq8pxBF+4gGgVOq2yM6WioI1AYsoNmYZM36JMftMAg1OWQkfFU98GAteEkJI5YsVx5eT+P1wDCRNn1gXnPXSI7cLKh+sjcqOeFinwgOMDHnwdXJIDGHWqNjw5n4J4QnoCNIg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ad5e47b-b4c1-4942-e4bb-08dee78728e4
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2026 00:21:22.9367
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zJfTWnhMiyh/uYt7X4v0HEPPBvAK1vwc6g5ws1MrbfQwHWiI5sE03PhCgwW1AO9M+SaP8vpSw+Q4fhzp83x7Sn04TvMhS85X1fzcEG/haNg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7998
X-OriginatorOrg: intel.com

On Thu, Jul 09, 2026 at 06:12:17PM +0800, Richard Cheng wrote:
> On Tue, Jun 30, 2026 at 09:42:02PM +0800, Alison Schofield wrote:
> > Listing poison by memdev scans the unmapped tail of every partition.
> > When an earlier partition is fully mapped, its tail is zero length, but
> > the scan must continue to later partitions. A regression caused the
> > scan to stop at the first fully-mapped partition, leaving later
> > partitions unscanned.
> > 
> > Backstop that behavior with a test case that fully maps a memdev's RAM
> > partition so its unmapped tail is zero length, then injects poison into
> > the unmapped PMEM partition that follows. The PMEM poison is only
> > reported if the scan continues past the fully-mapped RAM partition.
> >
> 
> Hi Alison,
> 
> Thanks for this ! I ran it against cxl_test in the following ways.
> 
> On a kernel with the fix [1], the test passes in both run_poison_test passes:
> 1 poison record found after inject at the first pmem DPA, 0 after clear.
> 
> On a kernel without the fix, it fails exactly at the "1 poison records expected, 0 found"
> assertion, so it catches the regression as intended.
> 
> Just one small thing below.
> 
>  
> > Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> > ---
> >  test/cxl-poison.sh | 40 ++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 40 insertions(+)
> > 
> > diff --git a/test/cxl-poison.sh b/test/cxl-poison.sh
> > index 49aa1b68c5c1..a03e08084eb4 100644
> > --- a/test/cxl-poison.sh
> > +++ b/test/cxl-poison.sh
> > @@ -219,6 +219,45 @@ test_poison_by_region_offset_negative()
> >  	clear_poison "$region" "$large_offset" true
> >  }
> >  
> > +# Backstop a driver fix where a fully mapped partition prematurely
> > +# terminated the unmapped poison scan.
> > +test_poison_unmapped_later_partition()
> > +{
> > +	local decoder ram_size pmem_dpa
> > +
> 
> "region" is assigned below but not declared local like the others.
> Does it have any reason for it to not be local var?
> It might be harmless today but tests added after this one will inherit
> a stale global region, if it ever uses one.
> 
> Tested-by: Richard Cheng <icheng@nvidia.com>
> Reviewed-by: Richard Cheng <icheng@nvidia.com>

Thanks!

I made region a local per your suggestion.

Applied to pending for NDCTL v86
https://github.com/pmem/ndctl/commits/pending/
