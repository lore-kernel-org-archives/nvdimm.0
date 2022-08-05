Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001AB7C
	for <nvdimm@lists.linux.dev>; Fri,  5 Aug 2022 18:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659724287; x=1691260287;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=gksYhu4DrOeiyA3vrt79easJGYSeCik8yE+hJMgqndo=;
  b=Hmi7v5W7fiMqCFc1rcSiKQHrmYGIfKDJqV8w3C9k0Wyijm1hg2CDF3tc
   2gcg1tZO/HWNjYhvDOlvhVIHtKo/sUYsozepZe6UWR3ulmsgUdoe6XJaG
   inpMdgjDrriRE6VqCSnBSKxmQbdiFNzt4esLlUy+go5gexy1a/QLMSFw2
   Ar4HVdC6h4yTsQ4leuQPeYiiXXq7r98RbeXWFiqqhIPdVPBAH6pE88QI8
   +E7yEicCtsn/SfHiT/MVn0Zu4H6RZZknolk8Jg8PcREmENZoGEE9iNkcX
   h7EzVP3t/j4pbK8H7nx0zltnsOj3DE8K4c1D+cz13L3wBrjDX//EVOs0o
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10430"; a="289021002"
X-IronPort-AV: E=Sophos;i="5.93,216,1654585200"; 
   d="scan'208";a="289021002"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2022 11:31:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,216,1654585200"; 
   d="scan'208";a="632103887"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga008.jf.intel.com with ESMTP; 05 Aug 2022 11:31:26 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 5 Aug 2022 11:31:25 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Fri, 5 Aug 2022 11:31:25 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Fri, 5 Aug 2022 11:31:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QWSIEJxu/vIn3alww2X+seByIZ4gr48gqATL14ZDaxxzzahvPPbzq84jcTUh3ftfXdjZQ6rPdf1F4I8LX1Zjc4rSxtgxpkDdhODy38YodPFeLdkXFtnJM67Ui0nkmQlFoqxU07AXFDP+gyeBAVcbG7uglliiu9KrFZJwJO5MVPLsO/7wQVot3gbPdva+C0g3NeuiQ9PSo4XmpzITWcX3pb7QpctQ7UQHVqwlvQXKR9Idj3XBLALWMq/IRm8d2jDn4EgQ8mAuk3aZYXtQX75Sb2wXY15Cxui1EjIV5yVnj46l4w58py0TYmL8kO+d0uJ95SkMp+AWecba6LMECRk0pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iKeGxhlCKLOv18ctfV2ij4Q62A0JJb8gSg3crhWPj+o=;
 b=Atjc1efY3ym3jTJdUdKzUM1YB+5K7Pf4QcdKdGu0eW/wwoJQAdv+VRTkYkAflVRF1DoLjxM/hDrK5hjISNWBl0ldm8Dg/O0UAYksDbZQhgdSu7ZjUDPaudTgSP0YmbyeD4Me6IX6i0hOXeBkXTEzLdMCHPKH0ECONa+V3Px7TJOrMbPhH8EhsgroUW0RzyEgYaMbiAYeg3GlpO8H8NtX8CHaDe5PQNUdhkHv+KRCOqnLtMfAhB8oWgdDNZc+tBWvq6snmnBxqL7VJGtwuthG5RVcZ10gp1aKeVfkFEYhbUpr79YawRuZZnqCQ0YRs8SM9hFA+eFq5blnTew3/KHCPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6311.namprd11.prod.outlook.com (2603:10b6:8:a6::21) by
 DM6PR11MB4459.namprd11.prod.outlook.com (2603:10b6:5:1de::27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5482.15; Fri, 5 Aug 2022 18:31:23 +0000
Received: from DM4PR11MB6311.namprd11.prod.outlook.com
 ([fe80::b965:e89c:548f:d058]) by DM4PR11MB6311.namprd11.prod.outlook.com
 ([fe80::b965:e89c:548f:d058%4]) with mapi id 15.20.5504.015; Fri, 5 Aug 2022
 18:31:23 +0000
Date: Fri, 5 Aug 2022 11:31:17 -0700
From: Ira Weiny <ira.weiny@intel.com>
To: Bo Liu <liubo03@inspur.com>
CC: <dan.j.williams@intel.com>, <vishal.l.verma@intel.com>,
	<dave.jiang@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dax: Check dev_set_name() return value
Message-ID: <Yu1h9QB2eTqg6eWn@iweiny-desk3>
References: <20220805053319.3865-1-liubo03@inspur.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220805053319.3865-1-liubo03@inspur.com>
X-ClientProxiedBy: BY5PR17CA0018.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::31) To DM4PR11MB6311.namprd11.prod.outlook.com
 (2603:10b6:8:a6::21)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7bf1ad94-7240-4fc8-7b73-08da7710b2db
X-MS-TrafficTypeDiagnostic: DM6PR11MB4459:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k7N1XaqLx4l9394VmCEeRRTGvATlH4WFmWGzV4dPsYj26ZY0Gq+MuFyw4DUS/XWvtuLZXtPhdSvTYNG4GB2LEcp+zhkuvk9b7YxeVwED+0vnPp/mpWgl/V9BB2LRBzHOUkB1XaiYYdbVSL+8tkuSYZyOlCb8qI+zh41PhawTLkLRExMyCeCNgCyXKzB7aK8QIhhjbHcIsG02JPyJCEXuOFOZPZ/iH+A+wSIr+2/U3ylJtPHUKnPxlnmMZRaXjobtHouwEZBHvbZmT0ZVAK94pZUSFGxECRBWGV6Duv1fX8GXAko5LrLyvN+2g7DmiUBxbzwyeb6zTuFr1BfiigyN49y1dZbtgCYHEUz2swkubrdYhOFj0UXDpq8MrH6pPrTWUdwmhOt4MYmOV7RFoFccf3DDcyzzD70PQFSrbVuEu7RdQyX0FXWhXinCVxa+mf1NRPgOJaRayBg1Qorz49ujliOvuBuiU5vs1+PGR4JGsQhQpljv8DVzR7EL4dD9wi0keviTsJFrcU3KIc6IzDxFf7WO6lyK0XZMxDR7Nuo4SWsKdCyCGhziufRRs78Llk6lFZdyQGVEnpKA9VBtKhSaSNKt1pNziVi7thnfkuBHXiEZHWtljhtVr0X1lxTuroKyHq3lKL7muaMO56DDQUIW8bZTShkVG931KRa3UDx64p/q15uVNUye2Kjyb8Fn+8Sj5y1WgFCImNHbIZSXorRlsKQbt/VhUHqDcF9Sk1G4hf0CHG9RlMJEtwPO4r7DA/2b
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6311.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(39860400002)(396003)(366004)(346002)(136003)(376002)(44832011)(6512007)(478600001)(83380400001)(186003)(5660300002)(33716001)(6666004)(6486002)(66946007)(316002)(4326008)(66476007)(6916009)(86362001)(8676002)(8936002)(66556008)(26005)(2906002)(41300700001)(9686003)(6506007)(38100700002)(82960400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Lyr46r7FibknfuXUNE5vynw0tUGIFTWCkEw4d/L9r1QjNB7zS+H+BXkRFdhV?=
 =?us-ascii?Q?FcIYC0SEf7/cWQ0FKg96kBBlQFUcoqx3ZA5WpzWGkP5JxWqffkImKXkTweSS?=
 =?us-ascii?Q?o/ET9BKcR2QCum8OpZ9UxEJOSkMVY6oeDJAVPG8qzmRUXU8mvvMFlMg4kSeK?=
 =?us-ascii?Q?n2j8Wn0ca1WaBe0+6Yq33/Hz/4L5j7Wc9TiRyRme9SeubRSQbxvaUwmgAxBE?=
 =?us-ascii?Q?IGdJimga5QdAViQeJ+3qys4qjzzwRiEBY/sIMKYJm9UhHKEXYry4tJkBITEB?=
 =?us-ascii?Q?fKhSu+Ao059h+QRPDsbBH15fg/1f2pRnWAEg4yaVtRhvjCGjKeUbfzTN9M8o?=
 =?us-ascii?Q?UzQvFQ2apdiQe1fmO38sPCcJja4IKBI28gW1lNerq/nGYpUCIlPVHHaTTDju?=
 =?us-ascii?Q?EF9qh1nFlYf0pG8zHRfiIGtyl/ucKi+zZe+ev6E4yNaDQ5xLBZQXos4hBtsk?=
 =?us-ascii?Q?whd4Cs1ZitBX6zk82zJMoq2QDCEkI7yjEa7frsK0J2O0yJPcv6dAfUh3IRF7?=
 =?us-ascii?Q?v/iOTIrGykVdTpsrriAoxsdoHg3A9prKyYBCOsCqCKFpQtmKGf41XwoSl15l?=
 =?us-ascii?Q?fn/n3TrHzBwhy/Uea1TFqUmSazYrLP2G41NKxXLHLC65UtZ99Smlc1AuTOuS?=
 =?us-ascii?Q?GuBf6LlSThoysDRWtFKTHbfHTGBnDaEM/98IPpPgdlce2yS/fa4AOw0JD3nu?=
 =?us-ascii?Q?OIazY8Vp7smfatpweb9rqv4oYqwD+nXBPFhJS54GY5Ue0a/zlXj+LVkjy3BE?=
 =?us-ascii?Q?WjbHUnLUVWnjF0RAgV6VR+7wSsZTtOsxBBGP6RO+O3mw9uYTJIvzxHnRpAKt?=
 =?us-ascii?Q?lv3iaRiol0lqUe2d5WpeXsR0ae66bitSA9U1e2BvZSktLSEsQ3TU4MrABraO?=
 =?us-ascii?Q?FyBDONleMmRYQjcKsUv3z2nCz0Qqz9kB+6fazd+XaADcgQGp2Dlbqzzbvxd4?=
 =?us-ascii?Q?IzpsDjw8Ctyv0rlijPz0RlyCuDsO7EDLyTcldMdIO9wkb6zI7k7yoIOyWhkB?=
 =?us-ascii?Q?wUQgX8XhP3etRRNx91Um3r7Wq0qMF0NDoNx+uAum0rhRGHyxWNH/uLj3X3y+?=
 =?us-ascii?Q?j0IMC5EgasHA9Vjvr7iUtz7XhwLFGcHkWUmLFFvLr/WdGm/pAGlmRm/TZ00A?=
 =?us-ascii?Q?q83nxv3VIKmyo7tv+L3j63dTfRbp4xR0hiejc4C8fR91Gbjy1Scuj06Nj8CU?=
 =?us-ascii?Q?WpTexIRosKrfhXUT0sesIE2SFEIZe10/i14rxXKMP50gjvxkbjrrPI+jCy3w?=
 =?us-ascii?Q?KQ88gkhL8wCE4MlQt3dm1o6Lv7EWlTKXnBjw3Thb2qO+KB4MU/lfHKZlA3RJ?=
 =?us-ascii?Q?ksG6SQ7evb3xrAzUMYxnZw9PbixfPeAbNvehWxVVXdZqAyOT2UruKI1rHK37?=
 =?us-ascii?Q?9uSBvX1rUDW7233Is55YdpxDjGIPNsdjrHjj1R8VfBv+KvB95iG1nHEXIOWX?=
 =?us-ascii?Q?MaJ5/GmgQtP15B7OQTDLlThkUDUsqEHPc0/2wEm/0Tl79AfwcCTkri/7Z9Bg?=
 =?us-ascii?Q?dNMuVsVQLw4azptupnh02MdNg37iKu6yugYwrMjb1iKLc7of3F/DAPl+YOrN?=
 =?us-ascii?Q?N1fyHPNNslSGSQrJIs2IbgdOOgSNgk0i5dV+LNKM?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bf1ad94-7240-4fc8-7b73-08da7710b2db
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6311.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2022 18:31:23.2600
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3y8OB1mJGnvgqvHM2R8e7Wk1B4Uz4Kpi7VSoexiX2K1Niz+gORY79NwZnX4efrNd0Utp+mG3f91kxLOzhWRKyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4459
X-OriginatorOrg: intel.com

On Fri, Aug 05, 2022 at 01:33:19AM -0400, Bo Liu wrote:
> It's possible that dev_set_name() returns -ENOMEM, catch and handle this.

Did this cause a bug or some other problem when the name was not set?

I think it is an ok change but without digging into the code I'm not clear why
you did this.

Ira

> 
> Signed-off-by: Bo Liu <liubo03@inspur.com>
> ---
>  drivers/dax/bus.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index 1dad813ee4a6..36cf245ee467 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -765,7 +765,12 @@ static int devm_register_dax_mapping(struct dev_dax *dev_dax, int range_id)
>  	device_initialize(dev);
>  	dev->parent = &dev_dax->dev;
>  	dev->type = &dax_mapping_type;
> -	dev_set_name(dev, "mapping%d", mapping->id);
> +	rc = dev_set_name(dev, "mapping%d", mapping->id);
> +	if (rc) {
> +		kfree(mapping);
> +		return rc;
> +	}
> +
>  	rc = device_add(dev);
>  	if (rc) {
>  		put_device(dev);
> @@ -1334,7 +1339,9 @@ struct dev_dax *devm_create_dev_dax(struct dev_dax_data *data)
>  	dev_dax->region = dax_region;
>  	dev = &dev_dax->dev;
>  	device_initialize(dev);
> -	dev_set_name(dev, "dax%d.%d", dax_region->id, dev_dax->id);
> +	rc = dev_set_name(dev, "dax%d.%d", dax_region->id, dev_dax->id);
> +	if (rc)
> +		goto err_range;
>  
>  	rc = alloc_dev_dax_range(dev_dax, dax_region->res.start, data->size);
>  	if (rc)
> -- 
> 2.27.0
> 
> 
