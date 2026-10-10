Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D482A397E96
	for <nvdimm@lists.linux.dev>; Sat, 10 Oct 2026 02:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791600619; cv=fail; b=i3T5N5KM2rJfvay8rIHKPCyDhIv58tk2iPQghOa9EPMdRUgI2xLX23hDSVfcXKh6WPx8lTdx8EpwmjpOYGECt147oqGjiHbpp/rDca0UDdkOjrXypOTvOWBRLbS93HGyUmc6TGZ4AKGsBwSxmMQNLaDbgszQxoPqiTJYN7mCvVM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791600619; c=relaxed/simple;
	bh=Nm1Ta0YC8zatAt3Pn9rpnmTK7Jkd98q3hReazIhKvd4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=hzZmpN++N/jwtY27SU2BLZMCoyYSSm3L22LcC5O68TGLnM01fLdn2mD4fltInfH6RjyFG2YB3962Xr/rKqdrxWDXUOVuIhzODz4YL+nhnUNt6kkCNnZXlxK+L7o8z9hREH2i6NprFl8nY6FGqXmorqfGkBlTaP1DdYYa8vPCmk8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z5aNw0gu; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z5aNw0gu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791600618; x=1823136618;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Nm1Ta0YC8zatAt3Pn9rpnmTK7Jkd98q3hReazIhKvd4=;
  b=Z5aNw0guvrB405wNQRwBRyIZlOhyolmNJujf4jHKveCjfa2EZqjD3mzB
   DJwB5gKiHBlULy4OX8Z4kHGPjw44UQ7B/5GezRjjiNDqWq1qpImNmG4Wo
   XLMt+DbsWSVkiFin1RdzstpOM74kKO+ijMezJ5bwxqDnGNnnnPDEme5sn
   Eio47FisQSpCXaIJYGLfYbVWAN5MdsXX6fk3kekam04kmeyH3uew7AlSw
   6F1ramd2heozvPQVlcfVXUGVvCXig+Wg9AjBwzL54h3OC2ytIDrV4cSjx
   +G9SgXjgczchAg9Iy9FGGTcZ/ebRDsBoLuHrF2TditGhA//UUOPN0xu4Q
   Q==;
X-CSE-ConnectionGUID: h/0Gjei0Tfy5Y0vX3vDHnw==
X-CSE-MsgGUID: 236QzQzITM6xJd0BoStJcQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11930"; a="306355"
X-IronPort-AV: E=Sophos;i="6.27,149,1787036400"; 
   d="scan'208";a="306355"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2026 19:50:18 -0700
X-CSE-ConnectionGUID: xLx41SfURAe/gPhf+lwhig==
X-CSE-MsgGUID: LODY19njTGSSE6dKmCdRmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,149,1787036400"; 
   d="scan'208";a="2259967"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa012.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2026 19:50:18 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 9 Oct 2026 19:50:16 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Fri, 9 Oct 2026 19:50:16 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.37) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 9 Oct 2026 19:50:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mEXDuYX6A+NioRtxzT8G/kxDrwUe1XzKrmi/KWay9uxq15KqI6NVMzFcgk1V3uDs1XM1OxE1mQX891VL4NdMk3c2mGIuIf+sSHdE94VkLJOnRvXkLeBwVwwB9xq85Y1oEhiot4+to//FVir9T9d7BtacmlWmTjyJMskuab75Lg5YJcwynxyaniDkhoqHHA4iteksepf18Y0guiJZopMk12cgzmv33DdOpMfgXSvjQ6n1lvDJwjoxOa4xD9fIuB8EQYkxp4GjGt6RCYnb5a0Zu8XsaUCEPgc3Lux3/pKQNZ7M9W1k1adsdL2U0rI/p2H77CE8gwN3dPA68Hf9I1oQWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U19MCTdU8YQ9KjI/snJ7FlK6Bxb5K0A50X7wmMqmGn4=;
 b=UNamlrbEDIjVcaQ+V0iXa/ujSrXInJDtKfPKjfKj/+jfQX4o66In6YCX2OwKgoN0zRXU2y7+r2vsCpPzoqwlENg+1KxXy1XhjcpuqnYXM/Da6ZHHky/3QINChJdvcGtJKyMxX1UP7LfkbqpiiR/IuZsKpEq0QwFAY24DmQljSVX2KIqflNedxFPQBcibup+p9rW4BDs0cwKvBYV16AqAcLHesVXdhwld7k5M+EoO04F1AeecgUU18gPqAWatH+hmEE2GmXbvExjfk7AUI8oiGmMaCnVH4SvIiv0JZYt1c2pJsyoPVRCXrhAWpXSFIsVZWhN8XSBQFuBAR//JO/mwww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by IA3PR11MB053507.namprd11.prod.outlook.com (2603:10b6:208:620::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.18; Sat, 10 Oct
 2026 02:49:25 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0496.017; Sat, 10 Oct 2026
 02:49:25 +0000
Date: Fri, 9 Oct 2026 19:49:09 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Samuel Moelius <sam.moelius@trailofbits.com>
CC: Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	"Guangshuo Li" <lgs201920130244@gmail.com>, "open list:LIBNVDIMM:
 NON-VOLATILE MEMORY DEVICE SUBSYSTEM" <nvdimm@lists.linux.dev>, open list
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] nvdimm: ndtest: reject wrapped config-data offsets
Message-ID: <asmnpa6IfSO6kFlT@aschofie-mobl2.lan>
References: <20260605005341.2051848-1-sam.moelius@trailofbits.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260605005341.2051848-1-sam.moelius@trailofbits.com>
X-ClientProxiedBy: SJ0PR05CA0105.namprd05.prod.outlook.com
 (2603:10b6:a03:334::20) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|IA3PR11MB053507:EE_
X-MS-Office365-Filtering-Correlation-Id: d43f38dc-85e0-4e28-d8c4-08df26791867
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|6133799003|10067099003|22082099003|18002099003|261009223027099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info: dH0SG6vofrT+sGoUWr+EovBPIv1jYxe+iENUxhZNMujX96MkWkYiKY/I/8IVulI89tdLewk88PvNjEvTp1eUcne0afkThjhEFFUenRgcO+Yd/aooxUIGElOnBv0row87J7sUGLJ3FJHaENBT2jVkKQqgmh33TH2j6MwgwlOq1GrYV/S1Q/toPrPWLybO5e+Ggp+KrcxFQtbLcqMDwPS0q0rokh47cuEl4nHjxuEifdtHIz2WudQ77mggGIR5mBvjMOTbSYFAJuE5L6ZMWImkSytTX+SivHXRCC5aVoCbI3oInATJqptxU4KIWOrzGVOEuEtNB0gxSXH0baESU0CxaCfLDxC0zd5VSxjSl+/ihaRGAhQaSbIRxMB9Ur9EUVPSmYuU08/Ncnu9dczB/zaCnqpxGSiKYZwBTMm9z4XVlIsLSETH5pIy1WpWlCbuiPQVQPyDPPI95OC+fUvhFPZ5GYioFRnQUPYYPiktFXY4Paec6g3WoLlqGOSwoKqZn7s3Txa/0hRdMsZNAg1kjVLdsVcrKx3IJQkKyM22VJ8GudjvfLYpR+iLcnv2zH8GqVLX6pFn3E/QXK715fdr86xmBfySW7hqYz4EnaKwc/pqLmxlFdizlC4RphI0tDUdCD+ZrOTrnJUonwlPFA6Nrockyy18QXCjm4pCL5//xOczxoU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(6133799003)(10067099003)(22082099003)(18002099003)(261009223027099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RYwAUYhG8odv0Mzog0kLRkAdIEAKYlnML7Rz/Rq9f14HvoStgV1V2q5Zu9wg?=
 =?us-ascii?Q?19CEYWz0K14Kwu6vlwYIGsgQv1RFXzc0osv6/8tkaQt9RWn7yGHpjTAw9LCS?=
 =?us-ascii?Q?f8ZHaAMwkd9rtB7+tdqgEsza5NT+poZGC59b2aWgkOkZ/mZzdXtBEYoBKrgK?=
 =?us-ascii?Q?Yq8av70xxsaDp4/nipW8Bc9tOC/nN2lkMfacYcDV3fn4vHxr1o1m+HyjIQPy?=
 =?us-ascii?Q?P2SVOyneFUZRHpht0s/5WjZCqoRcAbH1eQXVh5DR21nHwIgoiK1q1ND0fGnu?=
 =?us-ascii?Q?LzJJtDpWhL3eTkiuksdu3ylkxtx0MCQzRmYSizNYzYlJ1bI9aqCRxEQDngiy?=
 =?us-ascii?Q?yVb9VvE94EpG9ehh1zx1siRZyeF1i4iDKdVEDx+zudbdcRDWXpkfppPrY0bU?=
 =?us-ascii?Q?wTvilQ8rQiMy7NLD51R7i0sAn7lbRKF4ibHnK5ZTifr9K+JFl9bWdRrwF9Go?=
 =?us-ascii?Q?TyRAyktwcjlQ9nIpLvRjN7UH4KrVl3MeGIRP+obP1uz4hmigjexd4Np1lF5L?=
 =?us-ascii?Q?HNkGBjtKXNkPAY6xJ+xcfLBs3MTW6o1hxcmSFkOA4DSjGXhI+w9xcPjEbGGv?=
 =?us-ascii?Q?BPYD3LbB4lD6NFq0hnClM6t4nm7bSwMYqBi2edp5FeC48hNNf/HMntmIIZx+?=
 =?us-ascii?Q?TCh038/1rBFnl+Dhyss7qVssFeNf1jtQXAsqorxKdKWU4/bpWKgskwzacq2X?=
 =?us-ascii?Q?lJ0t/aZ3dLnJCRFRUBYQMoqYoU8mPWwjxeHTWdb+unqdnZX87IdU3hhrdYak?=
 =?us-ascii?Q?r+2eQi6c3ZDk1XAP+nWMOM3LKDLrirnERUNpoHVxXyX7cq2PiHQo1Dx1pNGm?=
 =?us-ascii?Q?rAIDOZKGwGkjILx9ZYmfj5I4Otr+YoQhq6Yr+s+bICMtw59Ss83R3RBc1dRL?=
 =?us-ascii?Q?PuUypK5oOZLfz73mhc1HoLZBLo9DnglKKUxMjucl9dTKoSHXHpQUXcsgiNFA?=
 =?us-ascii?Q?3tb4FkpPg4AfOa/CSlgFeVTXuKenM1RqFJrH8v0WmJd6rk5llW2i3H1RTKXC?=
 =?us-ascii?Q?kKR5wkGUAJi2FQ3VMqN2r3FtKyymbdu/pFkk7BZhMK6XoY4xujpE6W6FEyNV?=
 =?us-ascii?Q?LkXCd5M7cJsfaMLItRRESbjnG3DfwA5aatHOjnS9Yox2VsnabU/7N/WtxRd2?=
 =?us-ascii?Q?BrBwXkbkNLazk29usOLTMSc0zqT00NSEOnJ9R1zOIrZk7PdPCpqOwUZ+8teW?=
 =?us-ascii?Q?AasHHfyv3xoXuyFY9TAMNDXxpRJdnx2NNo5JkXWFLAwpVcw0iCsZ5Sr5jSGn?=
 =?us-ascii?Q?nrqA7pFUY9gJTDAXJ//KwfWS0KFBkCRsFC7mpNsWI316D9zseWuRSA1o/fEg?=
 =?us-ascii?Q?odjFtnqNxmWEN4YfTKIl+JEVQyKcCwtkXMbVgsInrhVRTdRUBEMV+LTUFJVk?=
 =?us-ascii?Q?7QhcJI/89KO1iUsSYjBSvKomrXbTnld1lC6nWI+7gXJB5fJT2B4L2V7MWxCa?=
 =?us-ascii?Q?Cyux+JQSdhVz6hR7uaYAcq/nbs4Ro90W+B5oBRsy8y/o0GpneX/i3uDp/HEi?=
 =?us-ascii?Q?THcnYZFz9Mym7BRmhfy2U+lOS2Nto9HjnFzeVUYEIdYk/iYQCCKv4BwbNK52?=
 =?us-ascii?Q?R6o5uo+LxJZ7PQkDFc8eEHXUxdZiIIZEm9xJWNyU3653Xu3R2EJm2f6vIVHE?=
 =?us-ascii?Q?XkmcGZHhcQMd2lMXB5sFckV/I70kUZtY5VtnvWceWOyqSzpqtsSReV4jgPP8?=
 =?us-ascii?Q?9A9LD+pq1LjF1Jfx9R46Yq3U47e7M8jv8QEFE84ew89t+3tQtvUZGqju61ec?=
 =?us-ascii?Q?iSNGBmd9Nn3WO4I8DOpKEVzDM+mYJ4c=3D?=
X-Exchange-RoutingPolicyChecked: ia576vsjj9TMAm+YDvE8F4+ySCknXWjCi7gUWnvbv6mBBOVk4tpF2h4I4GdFZ6YLi9yNsy1ygVu+Khk4H5JtWU4Vq09GDetpWLV7nzkj37hiT5R9svuj/cMGGWbXi0GGUrt5fRHZWeFokHIYTicZIaxIMq4s9xEULMxp8A3jvzog7zCWB+Xp7hlYPDDBujbKBfJjufjotVUpW6fuhkQjVhxyvB9Dq4egLdGFKeFSiPDQodnFKQOVP2jY14OZeOJ6TSVxZRf13Y0/+r7tn+Lh4EqdmfWQy4m4/Tsl35ThRUMCjkTswYEHafp253rs/fYNCGbh+FMMLKg+tas33j9X+A==
X-MS-Exchange-CrossTenant-Network-Message-Id: d43f38dc-85e0-4e28-d8c4-08df26791867
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2026 02:49:25.4046
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LO63LUAux6q/1ZHMpwBr2NYoE7az40pQM9yPN88PocOzy3Nz/iTqsy4pSJCBUCVA1WdWaAhCJqJ64D1x0P1h5A70G8K2ho0YOBfN7OexBMc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB053507
X-OriginatorOrg: intel.com

On Fri, Jun 05, 2026 at 12:53:36AM +0000, Samuel Moelius wrote:
> The ndtest provider validates get/set config-data requests by adding the
> ioctl-provided offset and length and comparing the result against
> LABEL_SIZE. That addition can wrap, so an offset such as U32_MAX with a
> one-byte length passes validation and then copies from or to
> label_area + U32_MAX.
> 
> Validate the command buffer shape, then validate the offset first and
> validate the length against the remaining label area so wrapped ranges
> are rejected before the copy. Report the rejection through the command
> status field so the DIMM ioctl ABI returns a nonzero command status
> instead of faulting.

Hi Samuel,

Sorry Samuel I just found this one hiding in the backlog today.
Some comments inline -

Also wondering about testing of this?

-- Alison

> 
> Assisted-by: Codex:gpt-5.5-cyber-preview
> Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
> ---
>  tools/testing/nvdimm/test/ndtest.c | 20 ++++++++++++++++++--
>  1 file changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/nvdimm/test/ndtest.c b/tools/testing/nvdimm/test/ndtest.c
> index 8e3b6be53839..1df93f5e4cb6 100644
> --- a/tools/testing/nvdimm/test/ndtest.c
> +++ b/tools/testing/nvdimm/test/ndtest.c
> @@ -207,9 +207,15 @@ static int ndtest_config_get(struct ndtest_dimm *p, unsigned int buf_len,
>  {
>  	unsigned int len;
>  
> -	if ((hdr->in_offset + hdr->in_length) > LABEL_SIZE)
> +	if (buf_len < sizeof(*hdr) || hdr->in_length > buf_len - sizeof(*hdr))
>  		return -EINVAL;
>  
> +	if (hdr->in_offset > LABEL_SIZE ||
> +	    hdr->in_length > LABEL_SIZE - hdr->in_offset) {
> +		hdr->status = -EINVAL;
> +		return 0;


This reports the failure thru the cmd status but waht about the
in-kenrel callers? nvdimm_[get|set]_config_data() check cmd_rc
not the status field. Would an out of range request appear to
succeed on those paths?  Can we preserve the error for those
callers?


> +	}
> +
>  	hdr->status = 0;
>  	len = min(hdr->in_length, LABEL_SIZE - hdr->in_offset);

At this point I think min is redundant. hdr->in_length is guaranteed
to fit in the remaining label area.


>  	memcpy(hdr->out_buf, p->label_area + hdr->in_offset, len);
> @@ -221,10 +227,20 @@ static int ndtest_config_set(struct ndtest_dimm *p, unsigned int buf_len,
>  			     struct nd_cmd_set_config_hdr *hdr)
>  {
>  	unsigned int len;
> +	u32 *status;
>  
> -	if ((hdr->in_offset + hdr->in_length) > LABEL_SIZE)
> +	if (buf_len < sizeof(*hdr) + sizeof(*status) ||
> +	    hdr->in_length > buf_len - sizeof(*hdr) - sizeof(*status))
>  		return -EINVAL;
>  
> +	status = (void *)hdr + sizeof(*hdr) + hdr->in_length;

Will that status filed be naturally aligned?  Should this use
put_aligned()?



> +	if (hdr->in_offset > LABEL_SIZE ||
> +	    hdr->in_length > LABEL_SIZE - hdr->in_offset) {
> +		*status = -EINVAL;
> +		return 0;
> +	}
> +
> +	*status = 0;
>  	len = min(hdr->in_length, LABEL_SIZE - hdr->in_offset);

Like above, min is needless.


>  	memcpy(p->label_area + hdr->in_offset, hdr->in_buf, len);
>  
> -- 
> 2.43.0
> 
> 
