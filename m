Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99BFD2CCC1
	for <nvdimm@lists.linux.dev>; Wed, 23 Apr 2025 05:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745386666; cv=fail; b=VKzvbPdS2KCKT/goIjGIRG+VaquWmAQc3v8icigwVSLWVvlsa7gkrmXgw2DO0iTeHyHVYzoghz3KeI0/CL4rEp4V6f4KLUvuqApn6UkU45kNs2tU93CsdKNmOByuyvO/umDsLT8e23ARPmPWt3DKdDsatACO0lAoLYA+TCPZHw4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745386666; c=relaxed/simple;
	bh=YLGUuTCiMAvtLoI9czx6SCWKlPMhwL6WwCnLJLNA1M8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=b48H8/jclWLdJKdfhF6dLqF/FB5uxnxo2Rjav6cRSlEHqjCOsU/3rbqSnnGE8QE76OVPRkSDDzFQd1vHRW4Cg3w5J4HOcKqO8VrHA0xqmiDbklxHiRdZ8WTZ/jsGFDnx9owgIncil9Fgw4KayBzMh7K+RQ8NVkcD68bLKJwyRmo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PpiklO5w; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PpiklO5w"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745386665; x=1776922665;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=YLGUuTCiMAvtLoI9czx6SCWKlPMhwL6WwCnLJLNA1M8=;
  b=PpiklO5wBQrs6e6LWmxi5RvcAknJn0lVFV0Kv5aP5c527si8IrNDyHFs
   ba71/k9VeKFFnatntBFt4sdyto/TElHhd1s9Hox8YTExeL+dsLQWSg/a7
   ILw7bZPdhhle64LfcMUPbxlqKrpAAbfCQcYXx1W0iZtEMuUxtlfgZN118
   lcsd6vX3FOSzkRaLMfNDJxFoIIdW9tGU8pA4V2S8ZruMlgKItTIiZplql
   nT7dMokEBtWTFuI09JfyalCdB3hx1/uygYhOQHd9W92K5CPSg3LSJcJaD
   X+0zowv/ERpf6s4zb7UxkNiFywcAXk6OEoZywAoZXZ10YitGLbwpep8up
   A==;
X-CSE-ConnectionGUID: 9IODPnX+Remg43h2qjUKcQ==
X-CSE-MsgGUID: SvKjwolkS1+ztKF49rxF3A==
X-IronPort-AV: E=McAfee;i="6700,10204,11411"; a="46843545"
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="46843545"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2025 22:37:45 -0700
X-CSE-ConnectionGUID: 9ULaPUHsQg+KCRhryuvCEg==
X-CSE-MsgGUID: H+DfwYVqSDC5n6EkYFyukQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="133160273"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2025 22:37:44 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 22 Apr 2025 22:37:43 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 22 Apr 2025 22:37:43 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 22 Apr 2025 22:37:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wlXYKEE9nYHwhlMjUdTNb3cJZ+6mJZy8XJWPQMbub1XyL7S16RLS7iA+9q43W8sdN65UorRdlL6yq3u/lrOswgnIU2Gzx8S2coLuQVqvtrsnja9br3uaqUC6Gj7hGH36+orLWluwyGVbBwMnZifzzQNh0r4msI4/Zaf6BcBuUlzfomC9MW5BRPANNj5Hrqku6+l0mfqcjljMICs+D3LXctHqx/X6qZCFbmOV7HvxKU6IyXKzXXB5JWgVCmJkQxvsqnS+/e1qP9pgJl2uKWkk/7v62kjuXeWVEuhjQkgsJXY6yyh4b3JAx7OedsZvOShW6wjiEIZvR07SwUixOSapmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WV2XYJUI+ETWajOzOBbdJcSL7oM3BOz5yOAQFhlaNEg=;
 b=QtelQ78igksnwPPb55mxLnJaoTzrtNeZMROEPC/Jbr1egNW/R0ddmUCng5H+XPLALOEJJo7Bq89atW9Nhg8MyZoFiE+b5TDKnMLFM040qP/0l8EzojmNfm5x75mQvW3gcQ3B4lISYWetsjRc+dU1CJsnPRejRD1v30zF+aE6HOHoZGEdURIQHeyNCKP2kBz05u8iWB8L5JHi93OsUuNY1EEa7KqcAKeZx1htylIon96kZWZ16qtCDSqXaNKeX+7jD9jRRoTp7gLfO0yL5XXjOb4Q1XtPF8S+iTauznnYHTIphiSz7rRYc7qld/oOKKX9mkZXBHy4aGBajlGZfEg5BA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by PH7PR11MB6882.namprd11.prod.outlook.com (2603:10b6:510:201::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.34; Wed, 23 Apr
 2025 05:37:27 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%4]) with mapi id 15.20.8655.031; Wed, 23 Apr 2025
 05:37:27 +0000
Date: Tue, 22 Apr 2025 22:37:23 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Dan Williams <dan.j.williams@intel.com>, Dave Jiang
	<dave.jiang@intel.com>, <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>
CC: <alison.schofield@intel.com>
Subject: Re: [NDCTL PATCH v5 3/3] cxl/test: Add test for cxl features device
Message-ID: <68087c931a8d3_71fe2941d@dwillia2-xfh.jf.intel.com.notmuch>
References: <20250411184831.2367464-1-dave.jiang@intel.com>
 <20250411184831.2367464-4-dave.jiang@intel.com>
 <6808612be8ffa_71fe29469@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6808612be8ffa_71fe29469@dwillia2-xfh.jf.intel.com.notmuch>
X-ClientProxiedBy: MW4PR03CA0006.namprd03.prod.outlook.com
 (2603:10b6:303:8f::11) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|PH7PR11MB6882:EE_
X-MS-Office365-Filtering-Correlation-Id: c112c594-674a-4c1d-f17a-08dd8228ee74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?LnJRhxWaaiDT3ckhiCxTp/TUEImILj5f4w+ld/T8XKkyGsdsDaw0kQAWGR/x?=
 =?us-ascii?Q?QIMqT09q4IYh7Px9cxRSoX0JCwtBV2LuTJH3SQCwiEk/2SxSc4nI8PPYTg+O?=
 =?us-ascii?Q?B9dKdi+ILuFqgmNm2Ef0M7bkRaHdspu8MjxKxsneMLJ+Bl14HAjL6ARgh6by?=
 =?us-ascii?Q?z8TdAlkRMnfavowiv3u57caDRSpz+LlnubaI74s6SSBqU6NZAbHRT/14HC1m?=
 =?us-ascii?Q?xjdUB79fatRZP2Kur7ZnQWDUmPieLGfAfdg2Lc0nBCUBdvB0c6D4Imty8eqU?=
 =?us-ascii?Q?Kgp3SQwWKx6pqU4PsNrR7DK4zxfZo/ymJPEhqbgHkgkUb11ePRquUzs1HMFu?=
 =?us-ascii?Q?8yGgswosA681LOo+X1c2zHHGjuTC0LMs1v42VUWa3yFJXJD9JZ5OfhIfuDdG?=
 =?us-ascii?Q?oMJhhhoJTyhRiuB1WKJLacR/bLt9YR1EsvHLeWx+/BgInojfvSFy4i0p2R4S?=
 =?us-ascii?Q?BuZWek27eDktipDT220T/JEQutrcGxGYDyaMV2wir8BbJrat0vusH7a+rkaf?=
 =?us-ascii?Q?5bY//T6/KNGq1XZ0oS0t1MiVAGTkhqzR2o3KPUwaEdjmLZ4vtag0NrjTGkLW?=
 =?us-ascii?Q?89SlCF519nVXS29N67V37qjachQXZITrTiCXa7zBQ/Unn/EuxHRDP9kGlySl?=
 =?us-ascii?Q?d9ywx9hoZ71Ym8w6zyQZK230STKhUTzQLm0+TKN+QCpkscS6Z9kb6AOdMjZ7?=
 =?us-ascii?Q?z7Z5olEgR/KmURjVZhQUbKU9LGIb57xeDbpa2CbhCFMd2psN1O3bTCFC1aAq?=
 =?us-ascii?Q?Y8pbrBxxOG8Hi7/VNkf6ucWZuY7vNdvuMuraCXX3Q+pzGHC4tkEOsbMoja1p?=
 =?us-ascii?Q?J25suosUoZOR4EFGFwcR+DHaIvyzI3Nz98MvufqQW6KQZKDl7jgygAbWn0u/?=
 =?us-ascii?Q?wTF7977Jy1nsMIcoTDysjXjPrltoi9iPTIBEECnxogqoFH7UNRliJ6b8hz+p?=
 =?us-ascii?Q?JKmGRVDLEMWnbERZnmuH97TGzlrUZ5zMs3s3tEANFtUnkaw3NuEMWSTj6D8+?=
 =?us-ascii?Q?HU0pUGA9du6tag83F2CBievmvC6k8zzqv9JacDxVCNYrIUNJ7cUitvlLbtqU?=
 =?us-ascii?Q?Tyo7qSJwM7iEhC1czWQ+43wY8fDcnUQkZ9ffUrr5ymC5O53Fc8XdSC7+9m5M?=
 =?us-ascii?Q?zDC0Q2pKaMP7UNQizoc5Wu5P8j+0gzVlnz0Zha+MSdFMPZ9mwvKH3cHQ2glz?=
 =?us-ascii?Q?pSf4MpgXYEiErRZz+Qe9fN1dUcJSz6HeRUYwFX+U4psYXJNaPB7o7OnIMwY1?=
 =?us-ascii?Q?5NVTYRsAtXHnu3OkcoivRDRnUk82YQybeUuv+uJ5la4LW4Pl7oYK6ufW4kRK?=
 =?us-ascii?Q?lVM5UjhS0Vz3qoBTgiqfJtmPGyWOSWf8XmLGuFkJe9s3jiLmJQLJkVjFOTeG?=
 =?us-ascii?Q?3lzh43DH5Ak/Ch8noiDl3CPCutPDEjtai2uxXYVgbbggG5yPU1Cc+6DF2E1T?=
 =?us-ascii?Q?5sKySgObqcY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SWO5rH2ERNI7OmW/2q0CY94AtA1qJSH3K07dhjXGgFPgBEz4fW/3G0QPnjfa?=
 =?us-ascii?Q?MMyakI0udHb+fpkBnS4Zd18T0ckTIqxD3zB7nGXLaASTTVnVX2iU3RAtyZsm?=
 =?us-ascii?Q?oREk5azYqcCLpjazlOtW/AS/sgmZJf7ClIX0EBGKE6RY/aSCigsdQ0JFMT42?=
 =?us-ascii?Q?rI0OnUDWIu2XqhUrgPpVLal5uZ9AhDGQWQJte/clvBV1QPHDJW+QrtnwKu4H?=
 =?us-ascii?Q?VHJ/s+gyLMIQTEgosMWYa/1uaWnSfvkx17gvnb9ThZ1pgCeFyGGtN+YUKlB3?=
 =?us-ascii?Q?Whtf0Wf87Rsu3PiElegc7GW5lmmDXP0MVlixXZzs7qvZq3kIKGQATitYfHBp?=
 =?us-ascii?Q?32mGJqydxQRwOZJuXnj0JznvKzPQSBK0YMnj2Yz/92e/tHe1Gbp9M1MhD5kC?=
 =?us-ascii?Q?3q2zqd9rl0eF69SDExw0BJleOLIQj+BOFriL/vnmcqb2HXUrzFEey2bKXRif?=
 =?us-ascii?Q?ZhIYZyFvTZJjNhBA05I1ZM/fX/9xQwcPxuTRZdTBXtfIS9E4tzr2gX7Q/ow9?=
 =?us-ascii?Q?YBpfNcTkBEc36TwFrNvCdUtPrOdHQs1h75YrDrYooHnDRYX7aiOPPTL6dz4g?=
 =?us-ascii?Q?4T74vk5zpH/8nZ1hXeM9ypVIAB/oYTRYi4kM2W5vFksF+88zS6WfCZ3rxDp+?=
 =?us-ascii?Q?5r/MLl2p2O0Z6PNjEqcMXHqoqbNBCLzTSwqB0jv1PhrGQbBHh60vU4e5/RL4?=
 =?us-ascii?Q?0vvwGOVY6nHJd1uvWcxDk7hdey7VdVohGK2Eafxqc25jf043WmC3MEEunZjP?=
 =?us-ascii?Q?f5yg9MzoCSUp7zfUgkryfwSaga3AbKoWerKdef2cUmvag63K8fJlM8BeJXQv?=
 =?us-ascii?Q?JEDHrPE2IEcKeLsUddL658dqWMVfdNlZIBqZUrQBSyoXOTrTiOlx+o7NSGbd?=
 =?us-ascii?Q?LKnhEnlySO1dR6j16EYj3P+nciI9LLk8+KnES9NAczmNhpHs9VO2N4YdVR3v?=
 =?us-ascii?Q?r4IwoEq/ZPaqAdssqUDJpLaMrWsKAY+QOo+MnJtWkZcQU0gYMGrwJSnqCU7t?=
 =?us-ascii?Q?B4Lobp/Z1kLumWzu1lMEMLE5ljDujSdIuiKl2da1MYTch67qHIPtGtpdlszZ?=
 =?us-ascii?Q?egb3UzAPAM73x96gbKQr4ptr2TqEjkki7/QhVrbXKpSw2fQNpr80MhfmFD/+?=
 =?us-ascii?Q?MPM8/yoQklTXeavv2ZZiyKWNSXPjtzApWMgrdfz3nYMsk73Ol4oFMmxVz4k4?=
 =?us-ascii?Q?XE35GU2jV0ut2O77tEOYnIG4F9P854xD6tztFf+cvxlR/uJTVxWkJIsCH8EK?=
 =?us-ascii?Q?8Aq/quJBZaefZQ+Ml+adCZd0pDa+WoWdUEqqJfKM7shjVqBw0RzgG+NLVxBA?=
 =?us-ascii?Q?GMKse6fndNCEoZGh8KZu+mMWpI9Oc4n7GhEiGd84YJUEC23gOmaFj5F3ITpP?=
 =?us-ascii?Q?H3aCb+Xto6gcUBR3/BeXd6yhKslX2+fDpr/lcQozdMX2bkcaZ9api+mMhs3k?=
 =?us-ascii?Q?ko8vEaV2N92DN141BKaaiMWI/iUbCqbpKzEQb6NLnR6v1AxMxIX3U64XPoe5?=
 =?us-ascii?Q?DaFR+QVbh4XRTxj7K5XDXCRQAbL9aNyriFozQzLlQ/nHO46Bmm4Fw9RCj0o+?=
 =?us-ascii?Q?wa2BGiA3L/Sb1NGKzqJgHYZ8i9iz7voPleouu9nx+XdwhvX8g1LUIyIFhvEq?=
 =?us-ascii?Q?wQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c112c594-674a-4c1d-f17a-08dd8228ee74
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2025 05:37:26.8793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9AH2zYF78oQDAjpT+pzBSaFLLX9iZ8VAaZJUNBzOr69piykoD59hFhqFcExsu9dvF50Av55ntaRXFWokKS0SyBJg14PIHK4VO7MAv+antqs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6882
X-OriginatorOrg: intel.com

Dan Williams wrote:
[..]
> This does not look like typical meson conditional functionality. I would
> expect is to match what happens for conditional "keyutils"
> functionality.  A new "if get_option('fwctl').enabled()" option that
> gates other dependencies.

Recall that the include/uapi/linux/ndctl.h dependency is vendored in
ndctl/ndctl.h. Keep the same policy for all uapi dependencies. I.e. do
not make the ndctl need to reacy to whatever random version of a uapi
header exists ships in the build environment. Just vendor latest kernel
headers like include/uapi/cxl/features.h in the project directly.

Make the option to enable fwctl support for a meson option.
