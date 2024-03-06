Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07EC51AAA5
	for <nvdimm@lists.linux.dev>; Wed,  6 Mar 2024 23:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709769246; cv=fail; b=pw4YofAFgGco8/nfMMNqNLyrYOS7PvWwoOSBDVk3I48+AT9WIG7mERkAHsrbvWy0c/1L54lfg7Nn/MGl9sN1F3m/eeO13SdsJj27tw1Oh3O8pgqU+BEQW9bZHZwfDXsoOZI/AGb1DmhItGlVdT4rCqQaC3o+NvehPnt9DcABUo8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709769246; c=relaxed/simple;
	bh=Y2kED/mOy0qcHOxGZJr7OjB6gfSn3yV/l4rni8LYKds=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=KtTKZSEEAf3XcJ2Rbo3ZSaMuAYdvjI9yTOWUqAwUBFpNsaxqY6yInDN8YCcyx1jLnvJn5QJvG7S1AJKthy3zRJbYkZOh/L+cTmz8+XYD243HM1XiHe8/1KchQ9LxbeI4jjnftRK0EgqPf1OOSl2HHogeon3KNj41p+ZTYso9NiU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n+B+aqBR; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n+B+aqBR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709769244; x=1741305244;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Y2kED/mOy0qcHOxGZJr7OjB6gfSn3yV/l4rni8LYKds=;
  b=n+B+aqBRWThNdK+oFHMzfXV65IGvr+E2G7/sWr8NT5b6zPjLFA8tPj3E
   7rw/CD3JHDSPhAPdNkiZYh36+QdPUz2bEorKSzvBCHhgJvgDYdjl/pBT0
   aNS5nGNDmiT6uFrvslI2F9leZ6vDQqFmkXAl6Ayy1WZC43zI6Kufbbvuy
   epDsj0I6UXvUl6ZPVTsHrXgZWRbgH9YZyMn3SbvrIVVY/9Fg5TieBDDa/
   KmJridbj/7PQ8AppjT3zVmwT38IYoq8pyRIAeRXyRFn/OUeMjD56ZLyMC
   mqOSwFYub+ylnisyCG/UIq6sUNGl1g6UJKg9J5o1NycbjU75dZKwkSb17
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11005"; a="8237971"
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="8237971"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 15:54:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="9844023"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Mar 2024 15:54:03 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Mar 2024 15:54:02 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Mar 2024 15:54:01 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 6 Mar 2024 15:54:01 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 6 Mar 2024 15:54:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R6Wgp+njwbEEYUUk+H5ovHTd/u9uJMHab8g5XRcvhlPcoj3NQvdr14LVoC8jQm/xSR5qkvOXgwZ9kqaVPNsk/bILOYgYR2k5IIXLq7UBMUucQ0rvd3E9U9d3HPjuGwIPf3vYqTPtjr4QWeUPbQFYOW3c8HOYulWrAEbHwYsVrGdRIqYXoROHDs2xRlUCx/aGIce5izwwSecaDvi9+ak/WfXHiuxOdFz1dDLQdYelPRpof8OJNKMabeo4agnjV7ZUZm8eCpbEsq9x+vlyF7TsIPWXMbSi4WYDF+64saPWXucr54T1OjW80L75U2WupWGnG4/LZIPnvi+BowtFZz9d5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7J4TkU6+T1u/tQr07CTuEG5MhMjeB9Mib3G05gqdmzg=;
 b=Oi0CZX0B993Fo2aYd5WdWtV/lLQTSgu2asTo8hn2esFhaOyOVUFR2fecVBB1zUSxDJRbPADdvtuX9EN8UnGv6VMOU0y0cko8u2rn20LnYbst6Em0deGWJuwNKjbBw6PwOKiImCytVdurIUfLNEbCQek61rARSINL4H7rdYYvt5O4bo1ELiPnkEgrvRG2Lc7gRZv7QFEJUd4Oc+FATmDaG6ms0sP/MywzsZXvMrmIf6Pn9XJPh/AF1v86UZpoCb7jgAxwiE36jprmkt0KcwRFXSEZXFltw12XeVbDeFTcACCz7vF6Aga5yAaj/yhTquagSAVV64gTGHB9tLeziK3THQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by MN2PR11MB4518.namprd11.prod.outlook.com (2603:10b6:208:24f::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.6; Wed, 6 Mar
 2024 23:53:59 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::82fd:75df:40d7:ed71]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::82fd:75df:40d7:ed71%4]) with mapi id 15.20.7362.019; Wed, 6 Mar 2024
 23:53:59 +0000
Date: Wed, 6 Mar 2024 15:53:57 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: <alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
CC: Alison Schofield <alison.schofield@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>, Dave Jiang <dave.jiang@intel.com>
Subject: Re: [ndctl PATCH v10 4/7] cxl/event_trace: add helpers to retrieve
 tep fields by type
Message-ID: <65e902155a5b4_12713294e2@dwillia2-mobl3.amr.corp.intel.com.notmuch>
References: <cover.1709748564.git.alison.schofield@intel.com>
 <3d264f1fe4c92a90eabf9cd3365a2dc69caacc4e.1709748564.git.alison.schofield@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3d264f1fe4c92a90eabf9cd3365a2dc69caacc4e.1709748564.git.alison.schofield@intel.com>
X-ClientProxiedBy: MW4PR03CA0225.namprd03.prod.outlook.com
 (2603:10b6:303:b9::20) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|MN2PR11MB4518:EE_
X-MS-Office365-Filtering-Correlation-Id: 48ad91c1-dc18-4be5-eac1-08dc3e38b15a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 99MCqNNCt5sPNGTa8I5ZdYJ9Uc7SZXI8QlQtixbn+guDS44hrsu+h/p+f1nHH1DeaWZsUoRRZe5+U55pxvXfuBP8dKKcs2W9vGMDqaPUzL3ZFE5hbwmVyJYeOXhb7wfh/2O+LS3ajoymoER/8rBK9ZLLcNRQ4y776KLN6n5ykXki3BUSgNnp0LNyBKmLuWT/qJ3i7mMpbxH/DsXeqy63OslyCebU5pSKAFmjDWaGXhXBwULO4AC0eU6VIcYfx32zuxZKju1kdfWzKjoIsFV9K8vbmpSWvb2bcPNr/15goqiqq/NNEK2X+BTa7zOm3CF6osoJRHrGPnzBx1gj+a8wOrRVDChocWpV+EqSzTYJo3MtYZn/EmzrXaX5cDAxG/FTHo28B+JTVdLLRf9UiTPIqNX0Q8ctk2FzT0kc2/I28IzD/1ME+d0c9aJKvpHPjGBTvFmOkhwmVzwC3lJlSF1T/9v4W08wFZJSftSMSrNCccyMHBR15OsIrzKR/vFxDbPaHwPYOZES4LPcLl2fZdNamEV0Tu3rxNGxZe2iC71q2pjgxhg3mQAS085sdUr+pqA4wu50heYG8OAuJoJ43UBcRwVT8ztOJbSFbSaAaHbCX/1uj4nQ7OfMVbBrKghozzViCtm+IFKmxyb04Ecyukv4JUyOnt8cXf8hyBpEq2AXVB4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YAdFlnPW5zaN3txB81kB6dYWjpc5pIAc+pbBbgyT9zHMs2/LEycaJXd3UsYJ?=
 =?us-ascii?Q?rBVEYfCXrN2I175Kn8Mn2yVNK6yOflbdaHQIYfSZiKq5HY/mbBh2nMARr2+x?=
 =?us-ascii?Q?xFF/n7CldEeNj5D1vG1hlOgVM+b13Ilv0Qyvxa55BZFaepr/PsxIJSV7QFLn?=
 =?us-ascii?Q?C3GeINB+7F1+Yg7bWBL6yf+L2/kJF7Fc3wbAJ+WjloeFLM9XolUMJZ3ynk3L?=
 =?us-ascii?Q?5RhEBWkoSQxUDBsHa94xaiRgYj326rbp+P9HczSnc4TnEmRAu1EiXLvZUT6K?=
 =?us-ascii?Q?9Ay9gNyAXH8D6z+uo4ykMOdm6jqRjhNkSB2bDEBJ+csoOhcj5J1v1Det35WI?=
 =?us-ascii?Q?xajT3hfEgV796pww+9AF0VUozYQn47xA/X7iVILsMbqq/xMe+J84rCU25eBz?=
 =?us-ascii?Q?dKKpojhms7ekm9RQNHkqw7dhixKUuvTRmWWPwVY2Gc0178suUXpbjzksjWEA?=
 =?us-ascii?Q?36RyD7RFDxs2QvxD4/d47eWs10R+NDGhy6tVm2ZjBF2gPHlffU/dW5NM0gNn?=
 =?us-ascii?Q?ZOj0KvP+g4sGp9rmSx5uzATwom5vv2yeSRMO92vChxu3rvD8MfMOYll/0o61?=
 =?us-ascii?Q?uitipseevFnKuB5j3SmhqHBDj/7P6STazN9ea0s7X9bY0enXJne0UyeTBra9?=
 =?us-ascii?Q?fNJSviiuoTSldzwMZdycT5DiytAuHB6m8/d5D75MWY3E/4ulqMEzbL//1b4B?=
 =?us-ascii?Q?9+1TauLaAz8JWvzI6LDkcJZTuGhRP1feV8G7sHaNRHefqdzyY2ae0ZHD3lYC?=
 =?us-ascii?Q?nIKfAqzS4+n8C5aXfqyvEPuAq6FrPbxZv9u7kZmJJL0igQKzXmVpCCTaaqho?=
 =?us-ascii?Q?4TvePynKi4kSRhCXsQNDsNthk9gHxKLY9/nzcLEhrc88rK3wSCZAM1gqUlxK?=
 =?us-ascii?Q?0/FWgcJCqyuddxRa5Ha3AbdxZ36LUxiyq0dqjeO+/G9aHgfEgYlcypP8S5ig?=
 =?us-ascii?Q?4K/RKThXFbvcuELRrytgJak7ELBaiLWKmkdfK3GI5cNsic5d3HdzMEKvn8Og?=
 =?us-ascii?Q?XBYGem0w2Gu7eUfsFw6j9qp9dQnQA5a7prVKkI1vrZcKR+PciuvjoljqgAer?=
 =?us-ascii?Q?PVTCZ4AtN/GRe13imzwxzcxQ8k13T/rforplTyypD3ZAMugDTQEIhEt4QHM9?=
 =?us-ascii?Q?fNvaC+nNE5jdDowz3bG3CJwhJ75t2ZPfo64DPTXYLCkcuZLy+nTUj3iBi7vE?=
 =?us-ascii?Q?omh2JLm9374dvE8Gd9J4Ml16hjsw6nzbacidQlZgB2ArMbl1LTL4pqzLBw6P?=
 =?us-ascii?Q?HNTasQm7m0UkxQ0oZyuWPiGkNBqX1o+sjzQIwIAWUI17ITMRRls267gdU/s6?=
 =?us-ascii?Q?9gDc0x/NyF5rabX6JMSDTpB9BvlaiB1vEEHAKKijsW0SMVJXhIblbw2WtKE1?=
 =?us-ascii?Q?3klm5npOO2bumPx3exD1huRhzzi0V+b4iUYhLzviXu4PntGiE90NsyfVVxQb?=
 =?us-ascii?Q?+db8hBNJ/0TbGgrlEHKDQGNvp8EWtDYf9AlLK6RQvhv8ig7B4ude0DHgxmzq?=
 =?us-ascii?Q?VSKgVle1mZN1DaumJJqs2Tg2FfO4wQ0Xzd2CHtTsnWj7/sLx9ByYICvyR03U?=
 =?us-ascii?Q?2ddS01/CujH+LZR0XJJOiyKljzdV/IjazDOj9mWch8brgxt4BK02Djv7vNJF?=
 =?us-ascii?Q?wQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 48ad91c1-dc18-4be5-eac1-08dc3e38b15a
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2024 23:53:59.6187
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TAneGOWU6/mXJr147AslhqCXPiSJ82yAGuYxzHdAvRaCgZxVzUgzV0IeAJjZqfm1NPnhVjbLmhBXfXHt8RkRElcVAIRQHBN2/XmFVfWx+pk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4518
X-OriginatorOrg: intel.com

alison.schofield@ wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> Add helpers to extract the value of an event record field given the
> field name. This is useful when the user knows the name and format
> of the field and simply needs to get it.
> 
> Since this is in preparation for adding a cxl_poison private parser
> for 'cxl list --media-errors' support, add those specific required
> types: u8, u32, u64, char*
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  cxl/event_trace.c | 75 +++++++++++++++++++++++++++++++++++++++++++++++
>  cxl/event_trace.h | 10 ++++++-
>  2 files changed, 84 insertions(+), 1 deletion(-)
> 
> diff --git a/cxl/event_trace.c b/cxl/event_trace.c
> index bdad0c19dbd4..6cc9444f3204 100644
> --- a/cxl/event_trace.c
> +++ b/cxl/event_trace.c
> @@ -15,6 +15,81 @@
>  #define _GNU_SOURCE
>  #include <string.h>
>  
> +static struct tep_format_field *__find_field(struct tep_event *event,
> +					     const char *name)
> +{
> +	struct tep_format_field **fields;
> +
> +	fields = tep_event_fields(event);
> +	if (!fields)
> +		return NULL;
> +
> +	for (int i = 0; fields[i]; i++) {
> +		struct tep_format_field *f = fields[i];
> +
> +		if (strcmp(f->name, name) != 0)
> +			continue;
> +
> +		return f;
> +	}
> +	return NULL;
> +}

Is this open-coded tep_find_field()?

> +
> +u64 cxl_get_field_u64(struct tep_event *event, struct tep_record *record,
> +		      const char *name)
> +{
> +	struct tep_format_field *f;
> +	unsigned char *val;
> +	int len;
> +
> +	f = __find_field(event, name);
> +	if (!f)
> +		return ULLONG_MAX;
> +
> +	val = tep_get_field_raw(NULL, event, f->name, record, &len, 0);
> +	if (!val)
> +		return ULLONG_MAX;
> +
> +	return *(u64 *)val;
> +}

Is this just open-coded tep_get_any_field_val()?

> +
> +char *cxl_get_field_string(struct tep_event *event, struct tep_record *record,
> +			   const char *name)

Return a 'const char *'?

> +{
> +	struct tep_format_field *f;
> +	int len;
> +
> +	f = __find_field(event, name);
> +	if (!f)
> +		return NULL;
> +
> +	return tep_get_field_raw(NULL, event, f->name, record, &len, 0);

Is this guaranteed to be a string? ...and guaranteed to be NULL
terminated?

