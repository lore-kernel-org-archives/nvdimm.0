Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E753D71
	for <nvdimm@lists.linux.dev>; Fri, 15 Jul 2022 18:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657910130; x=1689446130;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=N9NBIZYuYzM/aSFiIDvd8XEfPZWza8mvu6ffUggDh7A=;
  b=VPP+SLlhueXg48gWbBqrbijgnwR/Y1GVEnLl4184W53yz/lxAO2i2bVx
   sbOv0KZoblXs1g2XjGoCj/4WnU8W5508zjqc+JhHTPzRZuX5FVzDmqlT0
   c58hp68S2ZawOY1v5oUDyjtOwBbSZxERP88hfttg0liPJf/W3U53l3fl2
   hDvq0gHqJ0aj3nAhBH4qadDiQbN3F67F2VI57rUUozRRElGcAtm1s2IUk
   DSEM9OGSaf10hLKcLryFNI4fZyQ6wRPMul11rSqW8zNKUtOnWQjV1ZNcc
   QhIzh3USDqdjrgHdXlP+2IGSHZ1KKofwFWLCMDpjhbKMKVLZg7sRqsuX2
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10409"; a="283432878"
X-IronPort-AV: E=Sophos;i="5.92,274,1650956400"; 
   d="scan'208";a="283432878"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2022 11:35:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,274,1650956400"; 
   d="scan'208";a="686060027"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by FMSMGA003.fm.intel.com with ESMTP; 15 Jul 2022 11:35:29 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 15 Jul 2022 11:35:29 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 15 Jul 2022 11:35:29 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 15 Jul 2022 11:35:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RfC4GMLDNSiy/X5RXvR8bvQleHMMKk9+6PWF5RAkRjHZuEZmWD7tYeafYbQMbY1ZlR5S+Ah7poravNLTJTX8slVb72PHdoCr6aElUJwraz6BEcUdHcHuOs7oMGmDUXORYk7+pHLlbgRh13hxE8DuTP2Vs01ACwsdhA8fdLVUw/xXXxYi4Qaw+I40NEyXnHdzt+XLvI8px2MFZ1L4BheaTj3r1Z9Dt6x4oCForggqtaycOUwHUSB/W0SkUXFPxS3QhwRSWZW3lQVTjJEYA7wJeTutNqZjHvYlwrgXG2RZsZRZVwoY35WccN9S1WlPcezbhlPYFmQzVkiOEo/rlRHOvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JAefavJA1Z53KuaPFG2yS7J7/prtrRjtLswUeyAU+Pg=;
 b=ByvE/jS3fdhdqJMIAwyDqnrJM8tPBfYDzZdKvAu1LKOO43l528xz4sa9jok79eR5kKa13MmniVwYRzJgOoydbaNtZ+RYMv3n9GtIAziycrEoVRTzXvSC807fic8U9qNrWn1LiyZn0BKDOfmS40jr1iu1fkCz6H6WLcramH+7UXmzBCglMDtCO4JJTxZXDx+Eicxba/2IVRE9lb94F0mEyTlGdczbFN01U+nJqgC5wr9XJdV8sYSoGyVT8BJrbesdbXOPP0VuLVd8gtik4AkwHhtoCYdW+kdpE4MzKWBSxNy9vwojNwTzesaZS8VzkFpPL7SahtNpM0T+mWBDx0z/NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by SA2PR11MB4891.namprd11.prod.outlook.com
 (2603:10b6:806:11e::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20; Fri, 15 Jul
 2022 18:35:26 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf%11]) with mapi id 15.20.5438.018; Fri, 15 Jul
 2022 18:35:26 +0000
Date: Fri, 15 Jul 2022 11:35:24 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>
CC: <nvdimm@lists.linux.dev>, Dan Williams <dan.j.williams@intel.com>, "Alison
 Schofield" <alison.schofield@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	"Dave Jiang" <dave.jiang@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
Subject: RE: [ndctl PATCH 4/8] cxl-cli: add region listing support
Message-ID: <62d1b36c21061_242d294b3@dwillia2-xfh.jf.intel.com.notmuch>
References: <20220715062550.789736-1-vishal.l.verma@intel.com>
 <20220715062550.789736-5-vishal.l.verma@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220715062550.789736-5-vishal.l.verma@intel.com>
X-ClientProxiedBy: BYAPR11CA0096.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::37) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 860a99e9-23c3-4c36-2ec1-08da6690c947
X-MS-TrafficTypeDiagnostic: SA2PR11MB4891:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cI5E1fX5Ra6wksvIlYPtMkgytTY7/cuYgvwG7kHjE8OYa5DDPR8Y0QaeXNBtPauHEF6b8H2a6bMNDVb/72psbkpc6n5BlNNvsERdBYXUtlpde/B80SOYA3ZuJfHGbSHkHv1ynvg7npX8VgU8hSeoQqxvMmiay5HZ7O81eRAEl819hjW1g5Ebg4xLIsMM1KSIehMNlrHXJS2WrOak96eCjr8sI0lyslyxLZDT+r7tfcdJogdOIBgme4bzBbEX54BMs2uEGwmubopJ8I6y7eaDzKbTQ4kuzqKxQnjRE1HFPxlvkktgP873gLx3cIOOY9ChTMYr9yVDSJMAYkidGgScNBmVXYWj5SKmHuAkKr+2WIhxU85wg1nR8oSisIuwGparaZ8frrTSmyfk0z+a9Zw0PKEb2qW9kXl8HlVMIteE5qQ/NBS//wlxJTurtky05E7CZ2N9YqRFV3Kj8XH1kGu55+8Mbx40wDFRHiGlGq+5inoOqntka2+hOXahk/zMZystD3TVizYKWZgvbWq6012VwNz4pXKIStFSd13nYDVXKMR5YEzUeWO7zKk8l4W0JSAcVTun6zSq9l6ZujLZ3hn2VL9PHXPgEiX27YBfZDBYoI6SDlj8CyFu8lqlAD/OhERVDXdhkqPmQfSSQQo+7ZLIZAgrskPntaw6X3UqwBS1wdaOh4n7Lq19rZytX5KBFROmT/WJi3cRxGRe7S5BXvP9GNEO5bdDXBh7qxG5CJ/zpA+WOG17OuqBta9tN/MrcJeK57bB2q9dzzt+XOtpm/67Uq623V3Ab+lyUsdeTUtDdZXTTwrpoMvKLOhYyDLKz71t
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(346002)(376002)(396003)(366004)(136003)(83380400001)(82960400001)(6512007)(66946007)(8676002)(107886003)(6486002)(478600001)(8936002)(86362001)(186003)(9686003)(6506007)(54906003)(316002)(66476007)(38100700002)(4326008)(66556008)(30864003)(26005)(5660300002)(2906002)(41300700001)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4+RVxSBvSFhOKT0P4Wx5oNIZd6e2yZLoVMYLX4iylMH+4OVKwnNMQGp7yPuX?=
 =?us-ascii?Q?+LqVOkEAu+1bhKyds+g/T1FlXeHTMK0xR5LXatnVYARCLk4ADGrpOqq4WK8r?=
 =?us-ascii?Q?2rvSf+t7OCDs+WI8T9e0QBVNWsA+ue4m7/8jDZs+lhouN0C2Lqv6/UqSu3l+?=
 =?us-ascii?Q?E2gPFv88pDtPB1gFndHEENN4oZOZDxHp+FUNfWElU00aMdWoLqNP7PFHMLRT?=
 =?us-ascii?Q?hyHHZ4faHquScYUdSHu4Q87EK9EuQhGP5txglgmTqXtjudOqjV3sHcLhO3tw?=
 =?us-ascii?Q?RLsvRyOUxedVy3Nfm3v0RAnTcktyJ1Q6jNMRcM83IOwAd3aE620himDcvBhN?=
 =?us-ascii?Q?o9j1OmSSSWBFmoYjZxTNj5DbmdQVTW6oYgGMQa3nXfOIoF6ReMRp78BiWaCS?=
 =?us-ascii?Q?HLOmgockstbpxHbHgI5fFlYD9fWWcRwFRy1vsjM4zwsR5BCDVH8IaGM0AUld?=
 =?us-ascii?Q?CkvhtAIoqdTFNo1erz0g66y9bSxyHeQYpkSnZjihIXQXnEJfDi2RphTV/7oW?=
 =?us-ascii?Q?DVhQh+RW1uQh0QB4zUPjs9taGiIdNcgCflrvJhQSyCOkDba6dTI/r4rkHs1R?=
 =?us-ascii?Q?URfDtOVRtXiJqR4cAt82a4F0IsWVr/DcTUpIEp3drMdX3fR54KIXSqSVlufu?=
 =?us-ascii?Q?CaZCBugtWKl0dpN99vpf8l+5p2aNAueq2Ox1kPOV9V3vsNZcAgOGl4PCiYey?=
 =?us-ascii?Q?Akvc8MzVRmk4iJhl2zbk3+ApKzohqvV357BgKMi1/oXwYRwlQWuzlDMetYr5?=
 =?us-ascii?Q?B8nwKvljE7k8/Eg8jjt/1W7YBkcD/3RvN81yWtqHUZBwVA/lxYXKSFnwS1b6?=
 =?us-ascii?Q?G3WgJMjsVlcrPuSe04Mzd3NCmaMgC0e0C1GpqfT9r0DHp8XQN6EWVOZKwB5U?=
 =?us-ascii?Q?cs9rROGIPJRnSzDBR9L79qpRMcgZ3wa4dz9SGUqirH32m3qe39XX8FuOQthv?=
 =?us-ascii?Q?pKuENgUrnlHc19i3cek8jp4RQEsva5Cp+4Y+CxmFIuoeoeXzD801vMiocrqQ?=
 =?us-ascii?Q?h5BWZR66Z8YzIzXhPo/IA5JyFq3zG+DpC9Ox24b8yHh7n02OqeYy/Iu+z6jC?=
 =?us-ascii?Q?QzVbH/bXDIW91UAV2Gmb3GT8mXneF8fIuDWeP/HXvOhSdHVoTOVtVhNL5eG0?=
 =?us-ascii?Q?cfxY3XRF7dLJEkNHJLbuIBTr9oWtsbsWuJlGV5Q7cgt3UIp1scN90fVuDOJT?=
 =?us-ascii?Q?dDlsxelHmrpL+nqUeDIcauomaxYuyH5hLuCl4q+F1Bk0vD1vGboD7XcK3Dk5?=
 =?us-ascii?Q?W1nQDt0JMZk/YHyWrw7m8ePgdbI0mEOvH7B5jLD/00Enng1Nr+VGU4DjfzPC?=
 =?us-ascii?Q?J9RA4SV8jVgvU61i4ubLEbnQzhbD7VMSUgXZuLppP9HzzRrQ7WS8ux2a78OP?=
 =?us-ascii?Q?615rhCo5tHCeNU+MMTTX17/HZpOocBwlZ/pgmRhIFpbCo+ZRfOxEMxQ6JZ9X?=
 =?us-ascii?Q?vlcJ+HafkuKCQSIziv3+bxYQfzRri/bPap2TQsyUgttNRLo4tMuNDV0DO9eJ?=
 =?us-ascii?Q?7imMz6CkCUKlLcRLiThN1egpQmdYTjzFS14wX31s5oywLTe/Nrrhc+KraFpJ?=
 =?us-ascii?Q?M3mw/sRVUxV3m1j0ujvxo2+lndq5zjPR0qIQ99qRzMSWjrnHfi5rKZcCPFLE?=
 =?us-ascii?Q?nw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 860a99e9-23c3-4c36-2ec1-08da6690c947
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 18:35:26.6899
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y4aiXv30C6OFgmGHJgBUIj5bhA8MJBp0OSp9IfKL2z+7Lwkx9Lb6YhWM3vvW0tfUS2DbLZYW9tC7UYjcWEiyJLD8WtBtYC/G8FCsWi83Wcc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4891
X-OriginatorOrg: intel.com

Vishal Verma wrote:
> Add cxl_region -> json and cxl_mapping -> json emitter helpers, and
> teach cxl_filter_walk about cxl_regions. With these in place, 'cxl-list'
> can now emit json objects for CXL regions. They can be top-level objects
> if requested by themselves, or nested under root-decoders, if listed
> along with decoders. Allow a plain 'cxl list' command to imply
> '--regions'.
> 
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  Documentation/cxl/cxl-list.txt |  13 +++-
>  cxl/filter.h                   |   4 ++
>  cxl/json.h                     |   5 ++
>  cxl/filter.c                   | 121 +++++++++++++++++++++++++++++---
>  cxl/json.c                     | 123 +++++++++++++++++++++++++++++++++
>  cxl/list.c                     |  25 ++++---
>  6 files changed, 265 insertions(+), 26 deletions(-)
> 
> diff --git a/Documentation/cxl/cxl-list.txt b/Documentation/cxl/cxl-list.txt
> index f6aba0c..2906c2f 100644
> --- a/Documentation/cxl/cxl-list.txt
> +++ b/Documentation/cxl/cxl-list.txt
> @@ -309,8 +309,9 @@ OPTIONS
>  
>  -T::
>  --targets::
> -	Extend decoder listings with downstream port target information, and /
> -	or port and bus listings with the downstream port information.
> +	Extend decoder listings with downstream port target information, port
> +	and bus listings with the downstream port information, and / or regions
> +	with mapping information.
>  ----
>  # cxl list -BTu -b ACPI.CXL
>  {
> @@ -327,6 +328,14 @@ OPTIONS
>  }
>  ----
>  
> +-R::
> +--regions::
> +	Include region objects in the listing.
> +
> +-r::
> +--region::
> +	Specify the region name to filter the emitted regions.
> +
>  --debug::
>  	If the cxl tool was built with debug enabled, turn on debug
>  	messages.
> diff --git a/cxl/filter.h b/cxl/filter.h
> index c913daf..609433c 100644
> --- a/cxl/filter.h
> +++ b/cxl/filter.h
> @@ -13,9 +13,11 @@ struct cxl_filter_params {
>  	const char *port_filter;
>  	const char *endpoint_filter;
>  	const char *decoder_filter;
> +	const char *region_filter;
>  	bool single;
>  	bool endpoints;
>  	bool decoders;
> +	bool regions;
>  	bool targets;
>  	bool memdevs;
>  	bool ports;
> @@ -33,6 +35,8 @@ struct cxl_memdev *util_cxl_memdev_filter(struct cxl_memdev *memdev,
>  struct cxl_port *util_cxl_port_filter_by_memdev(struct cxl_port *port,
>  						const char *ident,
>  						const char *serial);
> +struct cxl_region *util_cxl_region_filter(struct cxl_region *region,
> +					    const char *__ident);
>  
>  enum cxl_port_filter_mode {
>  	CXL_PF_SINGLE,
> diff --git a/cxl/json.h b/cxl/json.h
> index 9a5a845..eb7572b 100644
> --- a/cxl/json.h
> +++ b/cxl/json.h
> @@ -15,6 +15,11 @@ struct json_object *util_cxl_endpoint_to_json(struct cxl_endpoint *endpoint,
>  					      unsigned long flags);
>  struct json_object *util_cxl_decoder_to_json(struct cxl_decoder *decoder,
>  					     unsigned long flags);
> +struct json_object *util_cxl_region_to_json(struct cxl_region *region,
> +					     unsigned long flags);
> +void util_cxl_mappings_append_json(struct json_object *jregion,
> +				  struct cxl_region *region,
> +				  unsigned long flags);
>  void util_cxl_targets_append_json(struct json_object *jdecoder,
>  				  struct cxl_decoder *decoder,
>  				  const char *ident, const char *serial,
> diff --git a/cxl/filter.c b/cxl/filter.c
> index e5fab19..ae95e2e 100644
> --- a/cxl/filter.c
> +++ b/cxl/filter.c
> @@ -585,6 +585,41 @@ util_cxl_memdev_filter_by_port(struct cxl_memdev *memdev, const char *bus_ident,
>  	return NULL;
>  }
>  
> +struct cxl_region *util_cxl_region_filter(struct cxl_region *region,
> +					    const char *__ident)
> +{
> +	char *ident, *save;
> +	const char *name;
> +	int id;
> +
> +	if (!__ident)
> +		return region;
> +
> +	ident = strdup(__ident);
> +	if (!ident)
> +		return NULL;
> +
> +	for (name = strtok_r(ident, which_sep(__ident), &save); name;
> +	     name = strtok_r(NULL, which_sep(__ident), &save)) {
> +		if (strcmp(name, "all") == 0)
> +			break;
> +
> +		if ((sscanf(name, "%d", &id) == 1 ||
> +		     sscanf(name, "region%d", &id) == 1) &&
> +		    cxl_region_get_id(region) == id)
> +			break;
> +
> +		if (strcmp(name, cxl_region_get_devname(region)) == 0)
> +			break;
> +	}
> +
> +	free(ident);
> +	if (name)
> +		return region;
> +	return NULL;
> +
> +}
> +
>  static unsigned long params_to_flags(struct cxl_filter_params *param)
>  {
>  	unsigned long flags = 0;
> @@ -672,37 +707,79 @@ static struct json_object *pick_array(struct json_object *child,
>  	return NULL;
>  }
>  
> +static void walk_regions(struct cxl_decoder *decoder,
> +			 struct json_object *jregions,
> +			 struct cxl_filter_params *p,
> +			 unsigned long flags)
> +{
> +	struct json_object *jregion;
> +	struct cxl_region *region;
> +
> +	cxl_region_foreach(decoder, region) {
> +		if (!util_cxl_region_filter(region, p->region_filter))
> +			continue;

Ah, this also wants util_cxl_region_filter_by_{bus,port,memdev,decoder},
but that can be a follow-on patch.

> +		if (!p->idle && !cxl_region_is_enabled(region))
> +			continue;
> +		jregion = util_cxl_region_to_json(region, flags);
> +		if (!jregion)
> +			continue;
> +		json_object_array_add(jregions, jregion);
> +	}
> +
> +	return;
> +}
> +
>  static void walk_decoders(struct cxl_port *port, struct cxl_filter_params *p,
> -			  struct json_object *jdecoders, unsigned long flags)
> +			  struct json_object *jdecoders,
> +			  struct json_object *jregions, unsigned long flags)
>  {
>  	struct cxl_decoder *decoder;
>  
>  	cxl_decoder_foreach(port, decoder) {
> +		const char *devname = cxl_decoder_get_devname(decoder);
> +		struct json_object *jchildregions = NULL;
>  		struct json_object *jdecoder;
>  
> +		if (p->regions && p->decoders) {
> +			jchildregions = json_object_new_array();
> +			if (!jchildregions) {
> +				err(p, "failed to allocate region object\n");
> +				return;
> +			}
> +		}
> +
> +		if (p->regions && cxl_port_is_root(port))
> +			walk_regions(decoder,
> +				     pick_array(jchildregions, jregions),
> +				     p, flags);
>  		if (!p->decoders)
> -			continue;
> +			goto put_continue;

I think this wants to follow the same "walk_children" pattern as
walk_child_ports() where once its determined that the decoder is not
going to be emmitted jump to walk_children: and see if any children of
the decoder are to be emitted. Then cond_add_put_array_suffix()
automatically handles the "json_object_put(jchildregions)" if it ends up
being empty.

I.e. no need to change all these instances of 'continue' to
'put_continue()'.

>  		if (!util_cxl_decoder_filter(decoder, p->decoder_filter))
> -			continue;
> +			goto put_continue;
>  		if (!util_cxl_decoder_filter_by_bus(decoder, p->bus_filter))
> -			continue;
> +			goto put_continue;
>  		if (!util_cxl_decoder_filter_by_port(decoder, p->port_filter,
>  						     pf_mode(p)))
> -			continue;
> +			goto put_continue;
>  		if (!util_cxl_decoder_filter_by_memdev(
>  			    decoder, p->memdev_filter, p->serial_filter))
> -			continue;
> +			goto put_continue;
>  		if (!p->idle && cxl_decoder_get_size(decoder) == 0)
> -			continue;
> +			goto put_continue;
>  		jdecoder = util_cxl_decoder_to_json(decoder, flags);
>  		if (!decoder) {
>  			dbg(p, "decoder object allocation failure\n");
> -			continue;
> +			goto put_continue;
>  		}
>  		util_cxl_targets_append_json(jdecoder, decoder,
>  					     p->memdev_filter, p->serial_filter,
>  					     flags);
> +		cond_add_put_array_suffix(jdecoder, "regions", devname,
> +					  jchildregions);
>  		json_object_array_add(jdecoders, jdecoder);
> +		continue;
> +put_continue:
> +		json_object_put(jchildregions);
>  	}
>  }
>  
> @@ -782,7 +859,7 @@ static void walk_endpoints(struct cxl_port *port, struct cxl_filter_params *p,
>  		if (!p->decoders)
>  			continue;
>  		walk_decoders(cxl_endpoint_get_port(endpoint), p,
> -			      pick_array(jchilddecoders, jdecoders), flags);
> +			      pick_array(jchilddecoders, jdecoders), NULL, flags);
>  		cond_add_put_array_suffix(jendpoint, "decoders", devname,
>  					  jchilddecoders);
>  	}
> @@ -869,7 +946,8 @@ walk_children:
>  				       flags);
>  
>  		walk_decoders(port, p,
> -			      pick_array(jchilddecoders, jportdecoders), flags);
> +			      pick_array(jchilddecoders, jportdecoders), NULL,
> +			      flags);
>  		walk_child_ports(port, p, pick_array(jchildports, jports),
>  				 pick_array(jchilddecoders, jportdecoders),
>  				 pick_array(jchildeps, jeps),
> @@ -894,6 +972,7 @@ int cxl_filter_walk(struct cxl_ctx *ctx, struct cxl_filter_params *p)
>  	struct json_object *jbusdecoders = NULL;
>  	struct json_object *jepdecoders = NULL;
>  	struct json_object *janondevs = NULL;
> +	struct json_object *jregions = NULL;
>  	struct json_object *jeps = NULL;
>  	struct cxl_memdev *memdev;
>  	int top_level_objs = 0;
> @@ -936,6 +1015,10 @@ int cxl_filter_walk(struct cxl_ctx *ctx, struct cxl_filter_params *p)
>  	if (!jepdecoders)
>  		goto err;
>  
> +	jregions = json_object_new_array();
> +	if (!jregions)
> +		goto err;
> +
>  	dbg(p, "walk memdevs\n");
>  	cxl_memdev_foreach(ctx, memdev) {
>  		struct json_object *janondev;
> @@ -964,6 +1047,7 @@ int cxl_filter_walk(struct cxl_ctx *ctx, struct cxl_filter_params *p)
>  		struct json_object *jchildports = NULL;
>  		struct json_object *jchilddevs = NULL;
>  		struct json_object *jchildeps = NULL;
> +		struct json_object *jchildregions = NULL;
>  		struct cxl_port *port = cxl_bus_get_port(bus);
>  		const char *devname = cxl_bus_get_devname(bus);
>  
> @@ -1021,11 +1105,20 @@ int cxl_filter_walk(struct cxl_ctx *ctx, struct cxl_filter_params *p)
>  					continue;
>  				}
>  			}
> +			if (p->regions && !p->decoders) {
> +				jchildregions = json_object_new_array();
> +				if (!jchildregions) {
> +					err(p,
> +					    "%s: failed to enumerate child regions\n",
> +					    devname);
> +					continue;
> +				}
> +			}
>  		}
>  walk_children:
>  		dbg(p, "walk decoders\n");
>  		walk_decoders(port, p, pick_array(jchilddecoders, jbusdecoders),
> -			      flags);
> +			      pick_array(jchildregions, jregions), flags);
>  
>  		dbg(p, "walk ports\n");
>  		walk_child_ports(port, p, pick_array(jchildports, jports),
> @@ -1038,6 +1131,8 @@ walk_children:
>  					  jchildeps);
>  		cond_add_put_array_suffix(jbus, "decoders", devname,
>  					  jchilddecoders);
> +		cond_add_put_array_suffix(jbus, "regions", devname,
> +					  jchildregions);
>  		cond_add_put_array_suffix(jbus, "memdevs", devname, jchilddevs);
>  	}
>  
> @@ -1057,6 +1152,8 @@ walk_children:
>  		top_level_objs++;
>  	if (json_object_array_length(jepdecoders))
>  		top_level_objs++;
> +	if (json_object_array_length(jregions))
> +		top_level_objs++;
>  
>  	splice_array(p, janondevs, jplatform, "anon memdevs", top_level_objs > 1);
>  	splice_array(p, jbuses, jplatform, "buses", top_level_objs > 1);
> @@ -1069,6 +1166,7 @@ walk_children:
>  		     top_level_objs > 1);
>  	splice_array(p, jepdecoders, jplatform, "endpoint decoders",
>  		     top_level_objs > 1);
> +	splice_array(p, jregions, jplatform, "regions", top_level_objs > 1);
>  
>  	util_display_json_array(stdout, jplatform, flags);
>  
> @@ -1082,6 +1180,7 @@ err:
>  	json_object_put(jbusdecoders);
>  	json_object_put(jportdecoders);
>  	json_object_put(jepdecoders);
> +	json_object_put(jregions);
>  	json_object_put(jplatform);
>  	return -ENOMEM;
>  }
> diff --git a/cxl/json.c b/cxl/json.c
> index ae9c812..1508338 100644
> --- a/cxl/json.c
> +++ b/cxl/json.c
> @@ -524,6 +524,129 @@ struct json_object *util_cxl_decoder_to_json(struct cxl_decoder *decoder,
>  	return jdecoder;
>  }
>  
> +void util_cxl_mappings_append_json(struct json_object *jregion,
> +				  struct cxl_region *region,
> +				  unsigned long flags)
> +{
> +	struct json_object *jobj, *jmappings;
> +	struct cxl_memdev_mapping *mapping;
> +	unsigned int val, nr_mappings;
> +	const char *devname;
> +
> +	nr_mappings = cxl_region_get_interleave_ways(region);
> +	if (!nr_mappings || (nr_mappings == UINT_MAX))
> +		return;
> +
> +	if (!(flags & UTIL_JSON_TARGETS))
> +		return;
> +
> +	jmappings = json_object_new_array();
> +	if (!jmappings)
> +		return;
> +
> +	cxl_mapping_foreach(region, mapping) {
> +		struct json_object *jmapping;
> +		struct cxl_decoder *decoder;
> +		struct cxl_memdev *memdev;
> +
> +		jmapping = json_object_new_object();
> +		if (!jmapping)
> +			continue;
> +
> +		val = cxl_mapping_get_position(mapping);
> +		if (val < UINT_MAX) {
> +			jobj = json_object_new_int(val);
> +			if (jobj)
> +				json_object_object_add(jmapping, "position",
> +						       jobj);
> +		}
> +
> +		decoder = cxl_mapping_get_decoder(mapping);
> +		if (!decoder)
> +			continue;
> +
> +		memdev = cxl_ep_decoder_get_memdev(decoder);
> +		if (memdev) {
> +			devname = cxl_memdev_get_devname(memdev);
> +			jobj = json_object_new_string(devname);
> +			if (jobj)
> +				json_object_object_add(jmapping, "memdev", jobj);
> +		}
> +
> +		devname = cxl_decoder_get_devname(decoder);
> +		jobj = json_object_new_string(devname);
> +		if (jobj)
> +			json_object_object_add(jmapping, "decoder", jobj);
> +
> +		json_object_array_add(jmappings, jmapping);
> +	}
> +
> +	json_object_object_add(jregion, "mappings", jmappings);
> +}
> +
> +struct json_object *util_cxl_region_to_json(struct cxl_region *region,
> +					     unsigned long flags)
> +{
> +	const char *devname = cxl_region_get_devname(region);
> +	struct json_object *jregion, *jobj;
> +	u64 val;
> +
> +	jregion = json_object_new_object();
> +	if (!jregion)
> +		return NULL;
> +
> +	jobj = json_object_new_string(devname);
> +	if (jobj)
> +		json_object_object_add(jregion, "region", jobj);
> +
> +	val = cxl_region_get_resource(region);
> +	if (val < ULLONG_MAX) {
> +		jobj = util_json_object_hex(val, flags);
> +		if (jobj)
> +			json_object_object_add(jregion, "resource", jobj);
> +	}
> +
> +	val = cxl_region_get_size(region);
> +	if (val < ULLONG_MAX) {
> +		jobj = util_json_object_size(val, flags);
> +		if (jobj)
> +			json_object_object_add(jregion, "size", jobj);
> +	}
> +
> +	val = cxl_region_get_interleave_ways(region);
> +	if (val < INT_MAX) {
> +		jobj = json_object_new_int(val);
> +		if (jobj)
> +			json_object_object_add(jregion,
> +					       "interleave_ways", jobj);
> +	}
> +
> +	val = cxl_region_get_interleave_granularity(region);
> +	if (val < INT_MAX) {
> +		jobj = json_object_new_int(val);
> +		if (jobj)
> +			json_object_object_add(jregion,
> +					       "interleave_granularity", jobj);
> +	}
> +
> +	if (cxl_region_is_committed(region))
> +		jobj = json_object_new_boolean(true);
> +	else
> +		jobj = json_object_new_boolean(false);
> +	if (jobj)
> +		json_object_object_add(jregion, "committed", jobj);
> +
> +	if (!cxl_region_is_enabled(region)) {
> +		jobj = json_object_new_string("disabled");
> +		if (jobj)
> +			json_object_object_add(jregion, "state", jobj);

This is more a comment about a future patch than something to change
here...

A region's relationship with being "disabled" is complicated. Because
disabled regions can still be enabled in every practical sense. Think of
BIOS enabled regions mapped into "System RAM". So I'm wondering if this
listing should have a "fixed" flag for those cases and skip emitting
"disabled" when a region is fixed.

Similarly the p->idle check in walk_regions() would only apply to
non-fixed regions, basically treat fixed regions as "never idle /
disabled".

> +	}
> +
> +	util_cxl_mappings_append_json(jregion, region, flags);
> +
> +	return jregion;
> +}
> +
>  void util_cxl_targets_append_json(struct json_object *jdecoder,
>  				  struct cxl_decoder *decoder,
>  				  const char *ident, const char *serial,
> diff --git a/cxl/list.c b/cxl/list.c
> index 1b5f583..88ca9d9 100644
> --- a/cxl/list.c
> +++ b/cxl/list.c
> @@ -41,7 +41,10 @@ static const struct option options[] = {
>  	OPT_BOOLEAN('D', "decoders", &param.decoders,
>  		    "include CXL decoder info"),
>  	OPT_BOOLEAN('T', "targets", &param.targets,
> -		    "include CXL target data with decoders or ports"),
> +		    "include CXL target data with decoders, ports, or regions"),
> +	OPT_STRING('r', "region", &param.region_filter, "region name",
> +		   "filter by CXL region name(s)"),
> +	OPT_BOOLEAN('R', "regions", &param.regions, "include CXL regions"),
>  	OPT_BOOLEAN('i', "idle", &param.idle, "include disabled devices"),
>  	OPT_BOOLEAN('u', "human", &param.human,
>  		    "use human friendly number formats"),
> @@ -58,7 +61,7 @@ static const struct option options[] = {
>  static int num_list_flags(void)
>  {
>  	return !!param.memdevs + !!param.buses + !!param.ports +
> -	       !!param.endpoints + !!param.decoders;
> +	       !!param.endpoints + !!param.decoders + !!param.regions;
>  }
>  
>  int cmd_list(int argc, const char **argv, struct cxl_ctx *ctx)
> @@ -92,18 +95,14 @@ int cmd_list(int argc, const char **argv, struct cxl_ctx *ctx)
>  			param.endpoints = true;
>  		if (param.decoder_filter)
>  			param.decoders = true;
> -		if (num_list_flags() == 0) {
> -			/*
> -			 * TODO: We likely want to list regions by default if
> -			 * nothing was explicitly asked for. But until we have
> -			 * region support, print this error asking for devices
> -			 * explicitly.  Once region support is added, this TODO
> -			 * can be removed.
> -			 */
> -			error("please specify entities to list, e.g. using -m/-M\n");
> -			usage_with_options(u, options);
> -		}
>  		param.single = true;

Previously this only got set if numa_list_flags() had transitioned to
non-zero. I don't think it matters for this patch, but it reminds me
that I need to go move this under the "if (param.port_filter)" check.

> +		if (param.region_filter)
> +			param.regions = true;
> +	}
> +
> +	/* List regions by default */
> +	if (num_list_flags() == 0) {
> +		param.regions = true;
>  	}
>  
>  	log_init(&param.ctx, "cxl list", "CXL_LIST_LOG");
> -- 
> 2.36.1
> 
