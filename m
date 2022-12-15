Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8EAB18F
	for <nvdimm@lists.linux.dev>; Thu, 15 Dec 2022 20:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671136748; x=1702672748;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=MqxhfzK7dwSx8Bll8pPsFwQv6Nra+IKYKHh76YFlWvI=;
  b=VYNZ9OgIz8wHuC2/VRcPjhbDCt8ik0PLp7WDZbqCtgaaJIeq2renIkBf
   bxTgBNoU1zt7965wEA4ZjeXtsYTux88bUBPt8fd2N7XBicsQDbpZCSP5F
   tZmL5uUm6v4DPd1RzbW1SnaK6xTHOVRuJQECl5X7+tB5ftJ0I0yURpnes
   ASO9Ft6kTtRsl9f3alkzJJ1rCY2N2jVYzh49HeJbtQYGe5oWufWpD7tLy
   jtjkGY8cLurMgSG4wWTQtOiH/Zt4IFxtPjDHxGxHXuWkS5673oM/GqkWZ
   Urgz/GT/gjvAAoxcEQ27p1XtYSlgEijbzy3c7FVq5+a8qUWJEw0Cbagth
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="319968596"
X-IronPort-AV: E=Sophos;i="5.96,248,1665471600"; 
   d="scan'208";a="319968596"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2022 12:39:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="649560141"
X-IronPort-AV: E=Sophos;i="5.96,248,1665471600"; 
   d="scan'208";a="649560141"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 15 Dec 2022 12:39:00 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 15 Dec 2022 12:38:59 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 15 Dec 2022 12:38:59 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 15 Dec 2022 12:38:59 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 15 Dec 2022 12:38:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UPM5mHWdyj+atttPvWkp1XuMDeBq/gVJkTYdMcRVSe1IPNlSduz/RzrgRkBqmNAxBBOB1629B9Y8FtUsX3cYV+mHBw3IF3fWR3TsEIFo+3CIG8zmn028Hd5Ojg1etjXKJEdJK482Wz4wB9FVyNTM/AJwJo/3WfMNMdcDjx+pjAw0sliMXchPtUA1z+hAsk2D+7BycfXxlBMoqGLvmlN7UCkHxvxNSXjqpqcqMktoCxWpkkwS8aOXikwGIWDLMB/2AbReNVKXkeZoQitjkObXL4VsWfoTWbMriK+eXwtp/rcNz/OMjisHi2IzDlupl8fu/Zmn2lgHlKt43NYhn3ASpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7gR+Q8C234bSarm1Owi52UHuZC/Wvt19S/RZGdcwacg=;
 b=HN+JcCweAbNL04HW/EC2bhRE2DQhBz+RiGcLqWSF5CkbXQsa6Tqntl+nA5k4ywwY5FfbzPOhbQHECJdYWhCCyBgQ7umosyCsFHnjg3bnSlnRUA0h1dN6pFPgpsimhG1KK94CS0C5ynISOoZYSEjqvRLDYhukZ+G1rr3p75DuxsxfBOdmqcLVkoZyQsmT9IkDr5rKqOtRaj3jPjDeEZpoyfbVP9B8OZAd+JYAAuBx2lBvsws1hPd4LKeWrP2c8QGQxcIgNyV33cW4h5BIqst+Qpbb4xnTsLm5XUvt23Q6J7Y3DtcEkDzMR3/kA4EVDsWm25KTVXvbccZZ3b/WjJP9bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by PH0PR11MB5192.namprd11.prod.outlook.com
 (2603:10b6:510:3b::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11; Thu, 15 Dec
 2022 20:38:57 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b%9]) with mapi id 15.20.5924.011; Thu, 15 Dec 2022
 20:38:57 +0000
Date: Thu, 15 Dec 2022 12:38:55 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>
CC: <vishal.l.verma@intel.com>
Subject: RE: [ndctl PATCH v2 1/4] ndctl: add CXL bus detection
Message-ID: <639b85df2197a_b05d1294fb@dwillia2-xfh.jf.intel.com.notmuch>
References: <167105505204.3034751.8113387624258581781.stgit@djiang5-desk3.ch.intel.com>
 <167105522584.3034751.8329537593759406601.stgit@djiang5-desk3.ch.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <167105522584.3034751.8329537593759406601.stgit@djiang5-desk3.ch.intel.com>
X-ClientProxiedBy: BYAPR08CA0033.namprd08.prod.outlook.com
 (2603:10b6:a03:100::46) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|PH0PR11MB5192:EE_
X-MS-Office365-Filtering-Correlation-Id: 597af67f-b1b2-40c6-e1e2-08dadedc63a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fuocG8+7X/YhYYrmRIGOTe24oll2nejTihJNGd/s2b47ibjFVWNftZ3sF4Yuh4F1mkV7yBMB1QkLBknrXtk1nrpEenKDzfyf5YYRxq/4lLgm1WXlJMiX4qA+4y+x6Alw0SJYN1MiHT+S1OUhqHh5VKr/iecoPbHDN5n1f3qRMNrZC2NT7t6j3kndrMbVMoqeTUUALxZXcGU+Kappx1uajtGBgclNvnpnFd1hgEXqPYKLdCx6QiOlJiHhN7eEw35IbuwjfrePQqjBoATfuL+HRu7pFbVOQxEGHolhpo3gA+FcV1qepdC0yMEH1k1FH2jiG33YcnXOmE6mhUejZ8ZJfBoY4CzX5aUM/9Km89UJeB14qbML6r8PFn5KI2Fm2w5tlrzdMruen+2gAxI2MlDh8kQU91piXr/lSUtWgc3XOrzMKQNgk6bfiKlU+jBF7dz3BzquJgQwiItsLPqN2LbFB7XJggnP2flX83025Z+AQA0w1Cjc2lZJWMz/2peK3whmywx6hvVQZH6TkHBuo1lwhOrM6UeJdve+NqezjroIkOcguDATvw3kjswYxkFIf6Hh35wG9O3bgfVD5ngncJoyv+yFZ9g1G+18geUWdnu50qXo9djluz3BMAE2Hy2+SGDY6N6B2E35RjjFXQEnvmq5mw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(366004)(136003)(396003)(376002)(451199015)(41300700001)(2906002)(66476007)(6512007)(26005)(6486002)(8676002)(4326008)(478600001)(66556008)(6506007)(86362001)(316002)(107886003)(38100700002)(82960400001)(8936002)(83380400001)(5660300002)(9686003)(186003)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FsU4q9h8d2PsnSP1kvkXF9ihWpiiZvG9o9mN3+3JonXfYPvjoyobe22XiemZ?=
 =?us-ascii?Q?VhJfeVCQZlII7iIcLFLYDnXb8/i77p55ual/Se9yAgWe3CxlQGIQZfNp617r?=
 =?us-ascii?Q?an1amXSDzPSgDsqipyg9uL9CF/ZfVLXRpVuC9HEGRAGObR+tVaexowj0Wq5X?=
 =?us-ascii?Q?cYm0y3OUokmXKT5YzsXYLx4hLmirt1lH/hg2VtYSzIjRb/bMK+PKt3A7okUt?=
 =?us-ascii?Q?PNojAXZC510zIZLBJkL2NkrHJptY6myoLpQk1llAKYCr8INMCpvcWs7M/QYr?=
 =?us-ascii?Q?lqZNsePfouS0vwqI23DiZzza6lZrlqv61aEFhfjJsehNsvDTUbPmsLDqGL49?=
 =?us-ascii?Q?ofZyJQUwVnlvRh4MMK5ZOmrTUr64cdAFLGDSTU5VT0Aua5qQuBCJvDE0mdTx?=
 =?us-ascii?Q?SEDt4pQ51AnIOpOi/Ywir/Nj0sXmnlEKW7JliOZsj55YfRqyn+dAVIGJuOp2?=
 =?us-ascii?Q?9nqv5uH78BkUd+WIkt8FkTXfmeqaih9C5LlolnSzx7VwNMkOeLQyIKGiQXvD?=
 =?us-ascii?Q?QIDj2Mt8ac/W98HRzMSPJVhhip/KDaB10O/oinYXw8Fvu8ih5sPADETta/7a?=
 =?us-ascii?Q?JjxSrGfIHtAGfcVml3nlty86oRuUlyss7RQAyVu/MaL7F+uuXGLPXv4D/LPH?=
 =?us-ascii?Q?iEK4+HTStkfNbHu2gkVFHoO3wUAh4EX+/ucBwOjNaKe+40BhMzJTY2btt8ii?=
 =?us-ascii?Q?rluWKWyYKE28BeByZMrloqwE5BLQCR+MqqV6MiPDHf0qdsYAr3PF8j1BmpCD?=
 =?us-ascii?Q?ufpE98i+q1IsDWCX1i4PBC5b24wTDXREwGRCTwSjAzKhbTIL7pO3fhRQz2MJ?=
 =?us-ascii?Q?Z7njqoI4Y173bWPlJgjmXlBjOiz7AHEjdRVkfNj2jphta2rhjaCLoQUOc3+k?=
 =?us-ascii?Q?e/OuiTWFObNgYKbcYrvUpDkeBEaLPWQ4Gx6UX8qrBiKL5G3Y4oB5vf8RbUza?=
 =?us-ascii?Q?oW0bGXlGbkzJg+TCm9r51YxayY31dwoLxagylEUDrLLgQSdTIr/Nt+03D/H8?=
 =?us-ascii?Q?xgiZrWRMdNTW4qhT1HhtR50p1SSWx/qcup9ISA/whsGvRbyDAU253qi37Fcu?=
 =?us-ascii?Q?7vT6iV0USblX3uWLIMEYgkP2ngaw3r79Q+smuSCCP3ZkEEs4laKoYqRQzZ/x?=
 =?us-ascii?Q?96VJEUYARN52bdB16XNsGBsnL1KQLafuBLnWT+btCrsykYp/fqISP4FLMqIY?=
 =?us-ascii?Q?vQ2cqe+GbZICFFvZIwx/5V+gMuht1EXEiz64hUvbdPfnN46kisB+0qbts6H3?=
 =?us-ascii?Q?wpn/YF09vMn1qU9vmXifxI7SKgZSN1VCmeUt84LYLzRr8Hm9QfFJIDcCQbCy?=
 =?us-ascii?Q?ezFuH7m0SEmsTj9gF7CGcSYVKFQodYXIUzyuwEHoCHWpKZkVFA5kw7eh5JZe?=
 =?us-ascii?Q?N1O+SyRrM5FqzzmP03iqW06k334N5t5xckAOSwgHfrgS03w3NPsabphfy4zC?=
 =?us-ascii?Q?gUzheiDnkUh/GhP1UQg3Y3dIQk0TsUYrRmm8rgDQWFRgaDi6Sm0amX3rVTt9?=
 =?us-ascii?Q?xF7iP3VqPEJlHmh41aM9ns9MYML1ptKx+15l9q0MpoFXXJNKg0qJErybt3Kp?=
 =?us-ascii?Q?tIp3euzQNV8I6F6po4e+Jf8LU/SqmpdHBObddh9AQsSMmLfLP5Ayp95nbUM9?=
 =?us-ascii?Q?Jg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 597af67f-b1b2-40c6-e1e2-08dadedc63a4
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2022 20:38:57.4767
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ggqQCDRbnO5a+FgD4kNx+VAva+Uq/Rud6IGPrQPbAv5rxKuFyUcB2oNfV0OfbSEn+isooIvrdorGgqlex8aik4V7LUb8eK8CI9SdwSt4yrI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5192
X-OriginatorOrg: intel.com

Dave Jiang wrote:
> Add a CXL bus type, and detect whether a 'dimm' is backed by the CXL
> subsystem.
> 
> Reviewed-by: Alison Schofield <alison.schofield@intel.com>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> 
> ---
> v2:
> - Improve commit log. (Vishal)
> ---
>  ndctl/lib/libndctl.c   |   53 ++++++++++++++++++++++++++++++++++++++++++++++++
>  ndctl/lib/libndctl.sym |    1 +
>  ndctl/lib/private.h    |    1 +
>  ndctl/libndctl.h       |    1 +
>  4 files changed, 56 insertions(+)
> 
> diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
> index ad54f0626510..10422e24d38b 100644
> --- a/ndctl/lib/libndctl.c
> +++ b/ndctl/lib/libndctl.c
> @@ -12,6 +12,7 @@
>  #include <ctype.h>
>  #include <fcntl.h>
>  #include <dirent.h>
> +#include <libgen.h>

This new include had me looking for why below...

>  #include <sys/stat.h>
>  #include <sys/types.h>
>  #include <sys/ioctl.h>
> @@ -876,6 +877,48 @@ static enum ndctl_fwa_method fwa_method_to_method(const char *fwa_method)
>  	return NDCTL_FWA_METHOD_RESET;
>  }
>  
> +static int is_ndbus_cxl(const char *ctl_base)
> +{
> +	char *path, *ppath, *subsys;
> +	char tmp_path[PATH_MAX];
> +	int rc;
> +
> +	/* get the real path of ctl_base */
> +	path = realpath(ctl_base, NULL);
> +	if (!path)
> +		return -errno;
> +
> +	/* setup to get the nd bridge device backing the ctl */
> +	sprintf(tmp_path, "%s/device", path);
> +	free(path);
> +
> +	path = realpath(tmp_path, NULL);
> +	if (!path)
> +		return -errno;
> +
> +	/* get the parent dir of the ndbus, which should be the nvdimm-bridge */
> +	ppath = dirname(path);
> +
> +	/* setup to get the subsystem of the nvdimm-bridge */
> +	sprintf(tmp_path, "%s/%s", ppath, "subsystem");
> +	free(path);
> +
> +	path = realpath(tmp_path, NULL);
> +	if (!path)
> +		return -errno;
> +
> +	subsys = basename(path);
> +
> +	/* check if subsystem is cxl */
> +	if (!strcmp(subsys, "cxl"))
> +		rc = 1;
> +	else
> +		rc = 0;
> +
> +	free(path);
> +	return rc;
> +}
> +
>  static void *add_bus(void *parent, int id, const char *ctl_base)
>  {
>  	char buf[SYSFS_ATTR_SIZE];
> @@ -919,6 +962,11 @@ static void *add_bus(void *parent, int id, const char *ctl_base)
>  	else
>  		bus->has_of_node = 1;
>  
> +	if (is_ndbus_cxl(ctl_base))
> +		bus->has_cxl = 1;
> +	else
> +		bus->has_cxl = 0;
> +

I think you can drop is_ndbus_cxl() and just do this:

@@ -981,6 +976,11 @@ static void *add_bus(void *parent, int id, const char *ctl_base)
        if (!bus->provider)
                goto err_read;
 
+       if (strcasestr("cxl", provider))
+               bus->has_cxl = 1;
+       else
+               bus->has_cxl = 0;
+
        sprintf(path, "%s/device/wait_probe", ctl_base);
        bus->wait_probe_path = strdup(path);
        if (!bus->wait_probe_path)
