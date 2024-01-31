Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D211FB3
	for <nvdimm@lists.linux.dev>; Wed, 31 Jan 2024 22:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=134.134.136.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706740566; cv=fail; b=PWDCQv6nH4+xgJHU2UeO/YzXWACCoBnSzs5WClRXWR8ndbLBJBV1n+uTAXSWo/tKMPa/J1vM2MkkxxvyKoHhOlbFI+05DzTCMbMHwPTBMkLr4v0euImq9oW3B/LuwjeTwNWeLOC3bUveLfO0CalRsQz9XliloyxQiZNxXGzc0MY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706740566; c=relaxed/simple;
	bh=X8RS7kU81eRFCEEmPedRKt4jo4+PJjg0JUFnKT51o1M=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=hvjDavkMZwXeQ/eHIIqO6Kobu/TptXACEnhaNqKAmVfj9LegTYOvg7LY27oftsJvu01KEyJE4VmOfdQhmtIMMvEekrrC2Y7G6WdkvzCK/AVgsffeDFt3aUgfc5hZ7StP3djffVSfDAN2ULhbn/m9+EBx0w0MmeeRNgAhmdvWOz8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iWgU2kOV; arc=fail smtp.client-ip=134.134.136.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iWgU2kOV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706740562; x=1738276562;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=X8RS7kU81eRFCEEmPedRKt4jo4+PJjg0JUFnKT51o1M=;
  b=iWgU2kOVeabb4Q6hsxtF+CXDKvt0ZJKoX0nSG2RLYq8uvpdz9O7gb6tL
   YL+7wlSWbjFl5y22Je7KS3yWxvYmDZRJsws/N6VxC/IRSDdiILNxh6Dtd
   pjqw7V25vV36Sidef2e2u+TYRqHnvJipRvboSx4twvE4L9Mz2wZ0jwi2I
   dTovkW0SgiFoayLYYId3AUTc16NcuehtaSyFEKjpSPHGsAaRcOZIZR20y
   wjqLPYG/EEg98wsQ5IdMczuhPYedpV5f3a+VZY0Vq7VhRluwDa4odJgSK
   X07r4aE0PrlSKW4dxmyZbV+EBBH2B+FmJKpsGU0n7CfyKxpy9hezDaquV
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="407461710"
X-IronPort-AV: E=Sophos;i="6.05,233,1701158400"; 
   d="scan'208";a="407461710"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2024 14:36:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,233,1701158400"; 
   d="scan'208";a="4229643"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 31 Jan 2024 14:36:00 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 31 Jan 2024 14:36:00 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 31 Jan 2024 14:36:00 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 31 Jan 2024 14:36:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JpCtDylYj2yzfDewwMCfdzjGleL8aoUssonxc5z3oslvH1MW81QMeY6JSuMNdNx+grmO8I+vMyVW3iGt5T1bkyuf/BLDw2fPxXMT0RSP31QvrpRknyf6H6S7omeCBwb9XQ7QbrhqHTjurcAe+/Z1abaaHdFC+7XZvhYECT+SAkpDC+70RchD8LfstUePxdpUB2jBETyPLqzmzzgGOPBfxgmpk37+c+e65goqszDki752VS9OZcO1PSZX4nWK+cfUW5KShdt66CKjVtq3TS5uXFIJj5m3PIe5Lid/XpNCnR6Ywd8Qe8+qZucVKenK72ld/OqxAB8Kkn4z1J1XR1nzKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fqxduj+zNjvwR2f7daRDHlhGszrIFpTARJy6c4Oitgs=;
 b=lxuISl9BPR/GfwQZw6RFavSM/a6R4sFCnv+XnXxRilZ5LVKvHwa3XcgIxnbDgMr+2RfWgQ+Gqxf1lmMBKdoMwL+9PKH/J3/Fmyrr7yCCeMV/7SfFdAnT7a7oJyX1Yv5ZQuA1Qz4BP/cRDMsj2bGWNObjMiwMN+IhDzrunrrnlg2HP9YPOvoYB8ADqHgriTxguSIWpPQ6jsUxTVr8K8Te0fu7sCd5A/wUa4eI4Bio7LCrWTBzUhCv/65S6iCurhweiIIGiUJRSgXeYDCJRhLnxA15BjCx80XHVl3G2ZyUq2GwcdRx4TCDsWYg23E+0n6MmceEr6D9Bpxnt0GRLjeE9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DS0PR11MB8207.namprd11.prod.outlook.com (2603:10b6:8:164::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.23; Wed, 31 Jan
 2024 22:35:58 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6257:f90:c7dd:f0b2]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6257:f90:c7dd:f0b2%4]) with mapi id 15.20.7228.029; Wed, 31 Jan 2024
 22:35:58 +0000
Date: Wed, 31 Jan 2024 14:35:56 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>
CC: <dan.j.williams@intel.com>, <ira.weiny@intel.com>,
	<vishal.l.verma@intel.com>, <alison.schofield@intel.com>,
	<Jonathan.Cameron@huawei.com>, <dave@stgolabs.net>
Subject: RE: [PATCH v2 1/3] cxl: Change 'struct cxl_memdev_state' *_perf_list
 to single 'struct cxl_dpa_perf'
Message-ID: <65bacb4c3a677_37ad294ab@dwillia2-xfh.jf.intel.com.notmuch>
References: <20240130222905.946109-1-dave.jiang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240130222905.946109-1-dave.jiang@intel.com>
X-ClientProxiedBy: MW4PR04CA0358.namprd04.prod.outlook.com
 (2603:10b6:303:8a::33) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DS0PR11MB8207:EE_
X-MS-Office365-Filtering-Correlation-Id: 46fecbb1-2485-4790-ba0b-08dc22acfec3
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bq3zlGvaSscPaVivFzDMSdsFStb6w8eoT3IIpGtIOQs58lzZKCfwisA7+kTaw5ZRVlTcX2oJtmugf8smPo2tmy/x+CGWgAT2L5CHY4tgIMWmqZHIF4wzdcjdz0wJkOkP+OGurOMUJMwLGN/SXs70vgtCT/eqFCWjWdR6ozXTz3zbCknCO+bW3L4WSVSH0UOt0iiabWdHQAfXpSzsTafzXYlUwhzwOl7pyjLSxQH5HlVkrZSAD7qP9Cx6uDNx/UzEOIErVy9vHuP0qnZBIKmtBRVRxBCAY6Qllo+1nFcqJd4BfWzKw7eqYyWbpaoYrjbEUF1uE75OOe2fk715Otwu+v5r4OJoGy+PEohbohBp4RMNrk7BcR3T1VSXEUx17X/1wfRmQ30ldIcAjoyJuoT36ysOg9ee8rjE+2laHC4eG6yc3TK9nwhj3hBjrvFbFSZ3SMJEGUUudv3CB3hA+WL8+n4zMqaXK45Iyypp8aweLQ4T67huB+Q39wN3ecTJi1AlWdoHOjbC8whtKgpOup5YZQYjEvEit0ARMpwN24Ol2bo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(376002)(346002)(39860400002)(366004)(230922051799003)(64100799003)(451199024)(1800799012)(186009)(66946007)(316002)(82960400001)(66476007)(66556008)(2906002)(6512007)(4326008)(8936002)(9686003)(8676002)(86362001)(5660300002)(38100700002)(83380400001)(26005)(966005)(6506007)(41300700001)(6486002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AJv7Q4vOFGv2qwXC+B+47isWvUVhVztwQI16lLeZsJ/mvDbjhDwNz6yb+KqC?=
 =?us-ascii?Q?DuNb0dExPGGzHAl4WawRwyDcL0Sf3jiyiNc2lBqji1uHffpGcEMbIiFfsM5j?=
 =?us-ascii?Q?Q/mOTv2Qh1vyZlBA3FmmLrlSiCfP6PiA/DCEB6EdOZdnJcBD4lYxpsBZLbi1?=
 =?us-ascii?Q?AgrumnueZhYM8/nIaoV+h8l4f+dQMPkRsmC/1ZgG6u5syAkuuNKRug14kXaM?=
 =?us-ascii?Q?WPU/S4sQta53KIUtsixrVpS3CObjvANt+7kq3b+3kXNRteY4Ur07dgCrMP7c?=
 =?us-ascii?Q?yESM3HhSG+bDXFdpDnq6n2hfCnmOYUJ4QEeTC6rRELcQAQO/RJMGqIubKV/E?=
 =?us-ascii?Q?lor4zxu4nKpRsthC3Md995ubOaRtyJk3l4gbXU9o598Nn9dEs6jt7CWXbrS+?=
 =?us-ascii?Q?oZOVqmu6qhlSFufBa2g66xvGLeUl8/1kQjLOsp3XiCObzo8ZoKVJq5w+a9Ix?=
 =?us-ascii?Q?u4GR/74diQ6KwX4jXZK/9T9H6jeQLq91OIPGEG5RmLA6gwnQB8ll8z8H49ux?=
 =?us-ascii?Q?ZaTzP+q2rAnJ7j5S+dXoJMdeqUYCLyAL+bLXPgL3IHhmbS+KPq0kLsr6RxzY?=
 =?us-ascii?Q?eiS78uSYOE/dXO4u2DJqF9WORPWwdUgzS2O7PJ+/C5FDSpqylj3Th1qeJsYj?=
 =?us-ascii?Q?+ISf4sDTjTMLySXliQZXPkX4FQ+fgwqDXMAFvn1BsobTN8QbVZiUubFrprIy?=
 =?us-ascii?Q?8U3vWX+67+DH3aSZzhfktLORPxRgPU/totK/ZzJywmzMAGelIO+dUy7PNZRI?=
 =?us-ascii?Q?8FAOlDw3Mf0UDmRkQrDRfWVYiBnw+O8keDyrH438F7PMztF4Z1uAYjtcqpU6?=
 =?us-ascii?Q?LPBj02lnhtH0wgaiQEFyUxZev/bhbTk6Sfgn8jHKrNITj7G0c7QvEKb3DYYk?=
 =?us-ascii?Q?axe1bPC/4AhNkLCRE/Cbkn8sn6KWivWeYLU9fO8u4nVn4t1sCVsGsXIl0hiJ?=
 =?us-ascii?Q?DZNpChprNrKPgIS2F8/OSnL+slmpPU+Tzp8PIne8W5EMJjjgoVPnRaPNp5fl?=
 =?us-ascii?Q?o9Z+FwzqqjKoiINBHSQ+bbdpFNj+ONap4btMnQxQEe54MtIeWCVNYhPcV2rO?=
 =?us-ascii?Q?Ug/SzGXZ8fNEAwml5ovv7DBZVMwxM74gcTRrIALWR1sWHMkYKaB9crvAl5mj?=
 =?us-ascii?Q?aMWU++AP3Og5crzQiBOZFnvreXHm4+z45eaa/eFo+ELzIrutOnj/gOJ2Ck9B?=
 =?us-ascii?Q?eGTeIf36gErSsxxCn/FtfeFEvg8YzgLJh8ZTlp74tA6mfa2nOpU20jmfe/fy?=
 =?us-ascii?Q?lNHBGNjcaPvO4op2FLVwI5ttmSgq0aNwkl4lJn2XcGQbhb/BkIWBPm4iynu0?=
 =?us-ascii?Q?bfZBwVyjH5jtlzMb7OIkD82Ucr7VJXsKO5uls8LrSo2d2lOE6FqgXdn1PMY0?=
 =?us-ascii?Q?LDkGy3SYvYjpynVz+XPf8hWwMCI/NbQHnCjt89N2juwFdZbOYs2xILBCXdTy?=
 =?us-ascii?Q?OU5Eb3OIrWSEP5ioy+x2Os8RkP5J3xrsP7xEtHNXMChLm9OFWTrM4HCHt8xU?=
 =?us-ascii?Q?ub4GPJwMyBfRlFpPfvQ9S6gSMhXV2q8ZiUFRe7jBJAkZPP6MYFpgZzq7jXtf?=
 =?us-ascii?Q?HyS8LAlGilfbCWnji5eh7qqojH+1Fwfmd98EhH4Q8lC0Zoo5Q2j4AEYTgj/C?=
 =?us-ascii?Q?Jg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 46fecbb1-2485-4790-ba0b-08dc22acfec3
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2024 22:35:58.4767
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CS/xLjQAJLeGLSBMABJkzIf0chBaYCpEb3I1E1y9RSQluKOrbOJLQsQdcFC2rGJLtkb9w7rROo4c5SBvXoLrPUv72/UD2OGzNYF/z8/ymmI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8207
X-OriginatorOrg: intel.com

Dave Jiang wrote:
> In order to address the issue with being able to expose qos_class sysfs
> attributes under 'ram' and 'pmem' sub-directories, the attributes must
> be defined as static attributes rather than under driver->dev_groups.
> To avoid implementing locking for accessing the 'struct cxl_dpa_perf`
> lists, convert the list to a single 'struct cxl_dpa_perf' entry in
> preparation to move the attributes to statically defined.
> 
> Link: https://lore.kernel.org/linux-cxl/65b200ba228f_2d43c29468@dwillia2-mobl3.amr.corp.intel.com.notmuch/
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  drivers/cxl/core/cdat.c | 90 +++++++++++++----------------------------
>  drivers/cxl/core/mbox.c |  4 +-
>  drivers/cxl/cxlmem.h    | 10 ++---
>  drivers/cxl/mem.c       | 25 ++++--------
>  4 files changed, 42 insertions(+), 87 deletions(-)

Oh, wow, this looks wonderful!

I was expecting the lists to still be there, just moved out of 'struct
cxl_dev_state'. Am I reading this right, the work to select and validate
the "best" performance per partition can be done without list walking?
If so, great!

[..]
> diff --git a/drivers/cxl/mem.c b/drivers/cxl/mem.c
> index c5c9d8e0d88d..a62099e47d71 100644
> --- a/drivers/cxl/mem.c
> +++ b/drivers/cxl/mem.c
> @@ -221,16 +221,13 @@ static ssize_t ram_qos_class_show(struct device *dev,
>  	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
>  	struct cxl_dev_state *cxlds = cxlmd->cxlds;
>  	struct cxl_memdev_state *mds = to_cxl_memdev_state(cxlds);
> -	struct cxl_dpa_perf *dpa_perf;
> +	struct cxl_dpa_perf *dpa_perf = &mds->ram_perf;
>  
>  	if (!dev->driver)
>  		return -ENOENT;

This can be deleted since it is racy being referenced without the
device_lock(), and nothing in this routine requires the device to be
locked.

>  
> -	if (list_empty(&mds->ram_perf_list))
> -		return -ENOENT;
> -
> -	dpa_perf = list_first_entry(&mds->ram_perf_list, struct cxl_dpa_perf,
> -				    list);
> +	if (dpa_perf->qos_class == CXL_QOS_CLASS_INVALID)
> +		return -ENODATA;

As long as is_visible() checks for CXL_QOS_CLASS_INVALID there is no
need to add error handling in this _show() routine.

>  
>  	return sysfs_emit(buf, "%d\n", dpa_perf->qos_class);
>  }
> @@ -244,16 +241,10 @@ static ssize_t pmem_qos_class_show(struct device *dev,
>  	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
>  	struct cxl_dev_state *cxlds = cxlmd->cxlds;
>  	struct cxl_memdev_state *mds = to_cxl_memdev_state(cxlds);
> -	struct cxl_dpa_perf *dpa_perf;
> +	struct cxl_dpa_perf *dpa_perf = &mds->pmem_perf;
>  
> -	if (!dev->driver)
> -		return -ENOENT;

Ah, good, you deleted it this time.

> -
> -	if (list_empty(&mds->pmem_perf_list))
> -		return -ENOENT;
> -
> -	dpa_perf = list_first_entry(&mds->pmem_perf_list, struct cxl_dpa_perf,
> -				    list);
> +	if (dpa_perf->qos_class == CXL_QOS_CLASS_INVALID)
> +		return -ENODATA;

This can go.
