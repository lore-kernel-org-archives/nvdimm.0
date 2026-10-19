Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=198.175.65.11
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1792428959;
	b=I8rwSx4x9KLIhPvIXnw3yMDZ/5fhHuH1Ne3bSJ2ArJSjAEoOUiRzxmuktWckCYaVuvqD
	 89sn/BsWFcP5L0ngvCbKu/njhzkrUoDVxRWQLM/OtDdjy/57vszM3kI+HtBQiGJaFuRka
	 xH+uf5KP+zjjbBb9LOPuvWpvSf3+FIExtEDiE79XNq1OgK+z7U4eV9WUSy4wCDGmqORcJ
	 Ogxvg6BNgdoRocE8XxBEnaJlpOhtnnOnX9LMD7J/AjteCAIYIjRiTfXXBTZBEB2z+C0IP
	 cZzfP6JFOJ6/E14vn/WHERFNudnbJQwu6R372aBrRi/T4yXvUVhmLiKEs7PSuN5as9w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792428959;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:Received:Received:Date:From:To:CC:Subject:Message-ID:
	 References:Content-Type:Content-Disposition:In-Reply-To:
	 X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=Lq4tL2q3ry6aj1VAed0YhMF/CkeGnnGiAyVLLYHctSA=;
	b=sxXcikawF0mnoyBFLBVVriU3mXfoYLEsLUfUu5+P2r76CqDJRF4wZRs/Pv/mCMvfRh3C
	 2ofo9DAXc5z/3wYkZ2On14MxszL28nlaflQ2SmUhhhzV6EoL1MT7wJwNJWNockkAv6YDg
	 5UglOERib/Cc1S0Lk/4seRGNMfzqientUyRJT7DesRRxHmLyQ/I3W9RkTjsqjgXxSxkMM
	 914sJfvAUqt7FCaKCwH/Xi5SeP0bRfmx7MY6g6fG/ccl+0JdXZ/JKfiVfqk+LHeFQngi6
	 bfEn7TnUvx8q7YadzZAQT1mDUxjbIByR5MEVZxu1AblBT/xt20a/TNXnPJYtn8bnx3g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=MZSWZNNQ;
	arc=fail smtp.remote-ip=198.175.65.11
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CFB5606A323
	for <nvdimm@lists.linux.dev>; Mon, 19 Oct 2026 16:55:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7CFB5606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=MZSWZNNQ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792428958; x=1823964958;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ouMNOflgKTvYjcl2Rb6AygeZS+LQZsIxL9yKxxoBuV4=;
  b=MZSWZNNQ8smxltju0aL58iCqdq596/5LKQuGnomHIFEfiY2MKqFZIt2I
   SCWhQRAvCxW/89ZkgATArbWLVYSqbWToEmCtcjo3/o2YFvmEVic96AgSv
   eG6A7UHC/xyShFHIlf8hjYwil48hqqNWZAa7OXS8MabAp3XnMvVeVcIdU
   QSRubleTMai7+diWx+V5hcPWLbaUd6IlkIz2/CbqkvXu7X5k9s/qKISvF
   aA8kX8lS8YRfloAR8kNM4dJJkF9VGfJWZXGvwG4fkn/cPatQaoXGVbaBJ
   nL7VrcMtBUI9bcy1QN5YYy4708NeSilS6BO2aSx2jjTdov9jX5fE3Cmbp
   w==;
X-CSE-ConnectionGUID: JBt27glRShegVWh3D9SZOQ==
X-CSE-MsgGUID: r+JyS9peRyuxQw2+z5XUKw==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="1003407"
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="1003407"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 09:55:57 -0700
X-CSE-ConnectionGUID: Wi23obOpR8WrS0k/xyNmFg==
X-CSE-MsgGUID: tPdjfiaPR6qd+dUZTUCLDw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="2581616"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 09:55:57 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 19 Oct 2026 09:55:56 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Mon, 19 Oct 2026 09:55:56 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.23) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 19 Oct 2026 09:55:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k65Qa3PyIHwn4OYAhD5Wiq/p1/502wSSe4Xurc8bs2yliRSIrLQ7p0Nfy574/VEAQ+bo+rhOd6BvggycaTybZrfQf4BOFYMdrPDbRzFRDKekd6eeW6ks44a0qzLs2pJYzU2HC4dUbX/MnhAyP/w0TORNZHKDIPFoDD2hdfl8uYJgLr4j4txBPlBIkXLRp5af4uBLzwWv9J9/4xAXBj6tm9fy1QfZobzCyupYRHhRmvn7wPXQiJJ1xKSyDHwyJ0PDDQDq3ezA26IRwOVi30uDpLU9YCEJI/3n1cXkQhC07BAKTWmHKYJKpMLZFyXVuBHmrc67pqbACIDgx/dBWNuUfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lq4tL2q3ry6aj1VAed0YhMF/CkeGnnGiAyVLLYHctSA=;
 b=ptHqA6cESqPjUxg5NB6Gnprfc5CU9aWynhx9SxLLx5PStbb4FogjwONdZZ1T7DK/phDSl67cHucTSP9hus/+8C+QMGZ0vPL0Atz1Sx95F/gWYoeBRS3OMle0Q2z1P+1cfGMF9Cr5j81qL6rZAjqjilK8gS7jWy0t/PYASYepWt3iH32k43zRCavPItsyTFCsmtrryroi192UUDyI1SUdwOgiklTPr+5JpwVXOC4Z3W8VqwvQbdv3C2YnSygbgVDArPuzNbPwMdu7WwVpjsyXeNlOOQYYynZkPAo0+tVfg+xUK2hLVdbxQfTOqG+z86qSzuX/tHVtUmIoPt/MOwnKQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by DSVPR11MB9892.namprd11.prod.outlook.com (2603:10b6:8:45c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Mon, 19 Oct
 2026 16:55:47 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0522.017; Mon, 19 Oct 2026
 16:55:47 +0000
Date: Mon, 19 Oct 2026 09:55:42 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: <jianyungao89@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>, Jan Kara
	<jack@suse.cz>, "Darrick J. Wong" <djwong@kernel.org>, Alexander Viro
	<viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, "Dan
 Williams" <djbw@kernel.org>, Matthew Wilcox <willy@infradead.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, Shiyang Ruan <ruansy.fnst@fujitsu.com>,
	"open list:FILESYSTEMS (VFS and infrastructure)"
	<linux-fsdevel@vger.kernel.org>, "open list:FILESYSTEM DIRECT ACCESS (DAX)"
	<nvdimm@lists.linux.dev>
Subject: Re: [PATCH v3] dax: fix wrong error code returned from
 dax_dedupe_file_range_compare()
Message-ID: <atZLjjje9Ao_pErh@aschofie-mobl2.lan>
References: <20261015143426.17620-1-jianyungao89@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20261015143426.17620-1-jianyungao89@gmail.com>
X-ClientProxiedBy: MW4PR03CA0105.namprd03.prod.outlook.com
 (2603:10b6:303:b7::20) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|DSVPR11MB9892:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c818dc4-7cb4-4aa2-d489-08df2e01d24b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|23010399003|1800799024|261009223027099003|10067099003|56012099006|22082099003|18002099003|11063799006;
X-Microsoft-Antispam-Message-Info: Wc7zVQxLEHWzcITW96tpKYZoEXn5nOktFfQwbXdLxeY6LjxRolBCMCPWvNWP1wklAjP/NrQgI6mBb3Ne3YJMNSVKjDt7Cbs+9s71Vtp4oDRACFgnPfPsucQAFE30eihRjOp3QEF7cwJ+Q3zo+4oFRJqVyRo+3Lejf3IFqn1YTuOzzsHcdjb0VANTbud6uxjJlLDXM3xtC8hgvow2OXfoCwvGV5c4WWv28FEhYiNOpBV/sv1oD3PvM55XUKCwX+mzt96+Nnyw1fEobZABh3oYFKHo0TyTl1onSddwNGVm2Z8iJM4PtS7pdi8Wqn3qC4tzDXPFB7Iee9OHQdJ5YTBHlbsT0ry3tNhCHojdhFdmF51zsnFkLVlhIjHpSzrcqgp/j5tWJgCzixUNwiTbS6qu/JdF03HXrDkAUtUyRu5RWd4eXcEv9TsF6YC6LX6baJg0eKMbmtLbS44/oB+uKEt7KVreK3EUWKktJQdg17PSoSpCq+LtcjVH++Dse4K4si/Xzh9H+wLvNyiN1LH7zv79RaRoxg1dEInTEgnmZVDEWgvmsBrfwpPwMPxuzBWycX7Pn72KhnNFLfK6qOwgQF/HiHYLKs4Xcs4DV0LW1MRhdLFrf9ulgyy3Mq8PJD7rEzHu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(23010399003)(1800799024)(261009223027099003)(10067099003)(56012099006)(22082099003)(18002099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?a7AAEjXxP4GYfwiFK5VdVH9NE//4bh1n6LrTd3JyWTM9NO2fxpXWXchpYa0v?=
 =?us-ascii?Q?zPY5e5t1rUlGpNSPTa1GP3U+P9vGtRPj91TLaHAe8v6So+MoFI1mJD1BpbxU?=
 =?us-ascii?Q?GNqrWY7cK3SlIl9o/Cz7O5eokoCFWeqJ2SEw11eTYUNedWK4FyVHOsoc4qhd?=
 =?us-ascii?Q?wvTmOaUbj1UYFZ+8OccuvIbfgvIT7odio3VG4dX5PwsjR95eKCIJzcglkxUq?=
 =?us-ascii?Q?RGR4NqFPRKKqoUb2DHQca5myJoDd4sKQUfaBHxQOIQW2lmbmKzODWSguLE1H?=
 =?us-ascii?Q?G1Z3FU8/XwSJl7SN6HmJYossiYwq5R1tye4a305Pr2KTf9VGm0a/M0GPdMQI?=
 =?us-ascii?Q?unIm9W2NHQo2i1bCA7Lp0M7at9ofwgHjEfBOl82oqhgO5VIn8oVB2DIvrmPt?=
 =?us-ascii?Q?OanuJN2iTXeVbmvdggUA1m99DEMiwUU5o/T6nESJFrbQlcflsrEeUpM5UyXV?=
 =?us-ascii?Q?/zALF0ttTFLbKZcb7UJKvJdtS3pednC0ePJGblx+vmaeaK7mDwA6Y/47DXsf?=
 =?us-ascii?Q?Ea56UfM1jMgDAc0AXYzJzE8k+ZXBe9Vuz6xMeKDz1n0dqDY0CZ+huyZarVjF?=
 =?us-ascii?Q?w3VvyxeTk6Ie0Trko9bJWzL6172hrUSCIxqQC9tqTFXB6lmf8CtjqI8Qe1jQ?=
 =?us-ascii?Q?1RR7zRstpEegBe4+tQVtUeHad9WnBwS9ORVfmW7fTdFP3hlth+1PGhjr6oUJ?=
 =?us-ascii?Q?1rVSvtluKSePqiupoL8xACuKnphNyI5ZUtbC/OxkDEcz3ntwRLkVJlADavGA?=
 =?us-ascii?Q?SKLLxsGzkEITJY43phPorXyBZ45wnxnGdVBKbvEvhptxdpkQ7YaXYiVk/jfX?=
 =?us-ascii?Q?Qi8fMkIVCO6m7PvfgmLlwjHS1YTYEfOpYRRGSmqvLAJ2gnhl/2DytRRTq1/k?=
 =?us-ascii?Q?xOKBVMnRSj2dVExcS6j/ntpHUt0CRnRFOxE/EMzUWir4StWHleaeXSRfIDFK?=
 =?us-ascii?Q?RblYgldu9/GjrZwjGbqOH9Qvhb7G71cFB+xKFM6e8iHmK1rTgDZ+ck3rWKwP?=
 =?us-ascii?Q?8+TVghmBfKNCs6pEd+SHmf3P24XTLbuibo1gSpONUR+yNctXEhLDzRCWR9Bm?=
 =?us-ascii?Q?LOVIu0flXk5Mku8/7/4AcyCHJayB3aONe1zB2jcp4XRdIWz94mBqmf2urTfW?=
 =?us-ascii?Q?/3CzPtvT6JorpHrqZL5MVOhYYl+YPr5upinNvKecVR0Q1HfglGzHZExf3Wnd?=
 =?us-ascii?Q?0R+TZddHHicPeLsy/b37gveOk7WzJjMGoF55Wj0JhioB+pnE30g9+A+JsJEv?=
 =?us-ascii?Q?NnZggMy+Ys/hiYzAxB+x0jN0DFPOeX7UYqdRIJmIUiXXfxMs95JphwRJuGJG?=
 =?us-ascii?Q?+scrLxBaFtWGa9+Udzxo7ziFjlQ6+lmLZOrO72uc5CXREbDu396zzFnxEHXN?=
 =?us-ascii?Q?GinVXFB2x9YJFDDlmZ1skNAPiXqfTrhwByLHlUznOFdzWxjXjw+EPbsNbcGC?=
 =?us-ascii?Q?3v++30iy8zulXZ6ab8lKxTyNxso/kHRtNuHL3bCA/xeF2odGD+n4jv4ZQfIk?=
 =?us-ascii?Q?hBTS/V4GpFb9eHpWcoM16QnezW/t8KT2lax3WqagwQ7nZFhcHUwskw/cTl6Q?=
 =?us-ascii?Q?OqD8ROfZuHLhE39odb9s/SD7d9GaAlIOy1uM3KetzkrKSdS7NmBIUduwGx/g?=
 =?us-ascii?Q?OY7qLWq0xSjCjgKp3W0leBWvtx2cQ+eHid4MgbJs4Nj49G1cTUa9ZIMt6SXA?=
 =?us-ascii?Q?MqNYRVnKpDQ/cCIRf5FwK0OAT7PwKKy2zRmJXt3Ews2CTlByAPztI9kavk70?=
 =?us-ascii?Q?skeqtAkvJKPqurHpGp0dw9m55J08SZA=3D?=
X-Exchange-RoutingPolicyChecked: g+reueLvLfR2jXWiuSiYxbrPBzWRJs8GZ0Se3rlsyiQ2LzChIOZRdO/LxfKSKTeJ0hQ9wnHOJMVA8qk5HLNEID6VS5oX3naDHD6ZZsrU/lV8pcy/IE1Ni9R/e/0QfEa2i/pQhxeGr8WepqL4MYuvhx++C4csSaUNoXGPcPDJDmnWRz7Z+NB/rU1WW0CVPuiFKl8PNfZvD3qlBMVvwOc6Ej6sfHKZwGtTO95shmpy7nNTrNHxWbL3mLc25MSEN4IuSfjnNfFrgKWOWDtQP4d+QhhTmHy8OseivG2QCl60hrYiQySDUsQpIld53k45Nj6MdZUCgnH3IVcnGG9KOGlZJg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c818dc4-7cb4-4aa2-d489-08df2e01d24b
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2026 16:55:46.9921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ASe2cEfA+zggEiRoDaWYQBik9VdiF7vcBhSyvG0EFlvi6IuL6M7T1rY3ZQYv8rL3yHWajfMlvkEEyzKC3tgo5D5zQXLMsxAQQ8X5W/heMp8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR11MB9892
X-OriginatorOrg: intel.com

On Thu, Oct 15, 2026 at 10:34:25PM +0800, jianyungao89@gmail.com wrote:
> From: Jianyun Gao <jianyungao89@gmail.com>
> 
> When dax_range_compare_iter() returns a negative error code (e.g. -EIO),
> dax_dedupe_file_range_compare() incorrectly returns 'ret' which holds the
> positive return value from iomap_iter() indicating more iterations remain.
> This positive value leaks to the caller, where vfs_dedupe_file_range()
> interprets it as success (bytes_deduped = len), causing userspace to
> incorrectly believe deduplication completed.
> 
> Return 'status' instead to propagate the actual error code.
> 
> Fixes: 0e79e3736d54 ("fsdax: dedupe: iter two files at the same time")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Applied to libnvdimm-for-next:
https://git.kernel.org/nvdimm/nvdimm/c/9b036546a02c
