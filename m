Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456644A0E
	for <nvdimm@lists.linux.dev>; Thu, 11 Aug 2022 20:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660249377; x=1691785377;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Mzy9cto0+P7FvSG6iExx1lOI29v1O3bSGvl8gNd3kbg=;
  b=H9RYiNdnvUH9ADwsKmS2s4FOP3EpvZK9Bk0KTb0blAEqG0aC78/yYMSU
   W0JKiigCQdRiGMgeaZtmamcExaCw6XCwO1lJa8rQ9iUAg0jId991fjQX3
   Pli/rDLyRp/pGl5yf9O0Cefd0PPyp+6aiH+YHbOzc1OZIp796wuVBuvav
   LNBw+IVMZKSP/DqqEzowrfMTAxLGtsOCiD4b7OC+OENgW2rptPsU7DYv9
   iAARojCwtxX+ZY9ESk7fJWtpPQFSdBhrEZwe5UTqrwCQnM3z1Bwvjh76j
   lbEYucOZygmq8lf52G3JZAl3XTAzPUruDo+N8sy//txhIkEVasmdRVG37
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10436"; a="317420638"
X-IronPort-AV: E=Sophos;i="5.93,230,1654585200"; 
   d="scan'208";a="317420638"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2022 13:22:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,230,1654585200"; 
   d="scan'208";a="665534930"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga008.fm.intel.com with ESMTP; 11 Aug 2022 13:22:56 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 11 Aug 2022 13:22:55 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 11 Aug 2022 13:22:55 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Thu, 11 Aug 2022 13:22:55 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Thu, 11 Aug 2022 13:22:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ctEQXI9O9plFwgrmFgcKQEdkeQXi8HrV2Yxqo8FyVwMwfuY5jUc2bnny4sDXUzL+XIBGjtIumpC8RCxwX6h+zHlO69JpYjLUDm8lw0BTsPO31iygXEyCz90Va6Vq3cTx8k8ps4VYnodaGOB7sv2B38ozOhhLLTB1Y3nEXSAD/zl7M0OCzgGW70wJrt1KeacJLjFJlV8JIUIoaRZzeA4fTkVKIMDjy7DIdFz84EAYXCZM9AM7Eer0QDJMBTYgtuTNQ9dSwQBS7+DoosY39MCzGOHFjUCSzznE3T9pHu32vtBmqn3hsoKy36iweApU+Snf/9Vt7rlFUqNDOzXjKwqqMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CoTqE5vjeaAlwbPTyN/uq2K8mQ+dM65SwCHwIHuqH9I=;
 b=ZtdviTqFyUHTDv/OGNDzIxUypbgqsqCGHJN23xdfbpZwfVw3iUGF9RMwp386uV4Mxo3YhZ49fr5scInRgsXHepRJ5Ajy/euaRsd7vPy7DoIf4J62GXrqvi1EGvzsXOH1FB6avbJ5l3v5JT2uFMC3EvrS13mep7MQqzcsmz6rtOrRCPTVNlPYHGChEnh+bEUxvWVZODhzcnZh69yluTRP2+efC790NbUpTASOWm7pT8m2HcMBwl3yKwpUQrEmmwBN2rAzUjqIfeZr93k/qv5OKgwa+Dn3Y/68c19Fqd+VWz6kxIVjjyP9/0r0TTd51P3C6Aw3Gv8PIaiAl8x1xh/T2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by DM8PR11MB5637.namprd11.prod.outlook.com
 (2603:10b6:8:33::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Thu, 11 Aug
 2022 20:22:48 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::9847:345e:4c5b:ca12]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::9847:345e:4c5b:ca12%6]) with mapi id 15.20.5504.024; Thu, 11 Aug 2022
 20:22:48 +0000
Date: Thu, 11 Aug 2022 13:22:45 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>
CC: <nvdimm@lists.linux.dev>, Dan Williams <dan.j.williams@intel.com>, "Alison
 Schofield" <alison.schofield@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
Subject: RE: [ndctl PATCH v2 10/10] cxl/decoder: add a max_available_extent
 attribute
Message-ID: <62f56515c9f10_3ce68294ea@dwillia2-xfh.jf.intel.com.notmuch>
References: <20220810230914.549611-1-vishal.l.verma@intel.com>
 <20220810230914.549611-11-vishal.l.verma@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220810230914.549611-11-vishal.l.verma@intel.com>
X-ClientProxiedBy: SJ0PR13CA0003.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::8) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f6da09a0-b769-439e-30a9-08da7bd741c3
X-MS-TrafficTypeDiagnostic: DM8PR11MB5637:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OHwflW9W7S1vfkJPIV6WuahcYn9JCdK+SS1ejhiQgLCoMK8eu6O13Lr60Rx9be1wbNxahXRQAVJolZ/+H31bnpnZn9hlBaL3zMmvon0aBwuqjr4TizXZLtFw73jAc7TmNfAefHQ3nIfoouE5ppz/xiGJ36LnGg7/ztOoHbuDtW+KWavH57AHETi28JVAU4Y3mRi/V2lQzfvF3aopd92LMoNLbGMRCLOUBD7MAcSw1wPYC7TgeaiTlKlXhNKGJN5GCgzs/Q8/xAXOfEvYTQdIicUdNNHRItUN5Cq9NhPX0dsSfL0oqeckyjnV4OR1sMAePqzlEfugqvwn2ZhbK99Ej+4VVuacxVgNh7WXqTkjvPsWat36XV9ikHD+FfqUt0eYOGh/IXk3nOHe/6qu/tw4Oud76IcWJFdXUt8EGRVjiEfTjI6IJHy+tqzHWSn3cWPLE1cDfjqudQnxv/paC3k0JmzJUhfiINH8OeKQ0rGxtgJthqx5XWWiaTcGNuFFneD7j+sEdiXvTR+inNGB1cl/YmZmaVs/YPl85mvOEKDyKiafdKKpFjrjiuUi0z2To1/oHLNhi+FVdI6IBlXIgTK0y1EziYkkyCQr1S5MNG7D7j0Sx/ZGtQpc5a2VY20R9E839ipv6Kz6wMb8h+ygAzEuGNQb1UW+KrrF18DK44GhHeK3EfJWNA9dpBhCGaEA+4/GsuEwC/owzZLmP5wFCahAinO4FjniErpqMGR2toQd0sT8C1IjF6ph/D/zNf0sU1s4UJ0IUoGAyfHZvvL+8qJq+dA51EP43alXNBp4VARebIk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(376002)(39860400002)(346002)(136003)(366004)(2906002)(8936002)(5660300002)(26005)(86362001)(82960400001)(66476007)(186003)(9686003)(41300700001)(6506007)(6512007)(6666004)(478600001)(107886003)(83380400001)(38100700002)(316002)(4326008)(8676002)(66556008)(6486002)(66946007)(54906003)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?r2v78+kpQ7KSyIkZnOqzqLsgdYnddv5Y2O17vJJOx+ERQ9Mm89ugiWUhDEZN?=
 =?us-ascii?Q?34xBadcwtgCWmLinJdKzsYKBWLaGMEYPlF5PvcUqaHdzKRN17UJ2JPdTpSUM?=
 =?us-ascii?Q?T4BZ0CMtQRVWA+rK+zkAe/oACiBSG4Hp4cinF8U8UwtpDDGz/qS3CJmezdBW?=
 =?us-ascii?Q?6REwhFKmL1O8/GApdMiLIh0QUB4nWPaoDr30ZQ3Xl/Z3qoRln/D3N//ifvhL?=
 =?us-ascii?Q?S7oy0r7V/haFNDwDE3t6s0OrQpjHpg3JGWjtWrvG7ETx4qWtVOf9PehYHDZY?=
 =?us-ascii?Q?LrELanpUxZHx3M7tnCwiPLxiOf0TOAkEogcl9k/EHQGKwvhyXhCbDyoUOCIA?=
 =?us-ascii?Q?1PsvvrF/VVtKDkS+TzLZGtPHYNSgJSVfms4afAhqb+wVd7Slkbez4BjdesfY?=
 =?us-ascii?Q?+M4FdYH7JmtwUvev7lKfdqtrh6KoAfH6pd2iDwHQAERAsWj4qVeEv8J6y9Me?=
 =?us-ascii?Q?r3MYVbgbkm/eItAHuBF3NfeIEnMeCevSISp8iNoj0Sf2fXYcdTj6Vh9fsie8?=
 =?us-ascii?Q?T0hfmhsYZw+72BTr+JgMKgj4Mkg85Jb8+zQzC7rICK+cTd2X8Czm7Pzba+ff?=
 =?us-ascii?Q?mzVB3rwSB7zftOL8Rf77MKuF69SA+PGUOa5iXOTHK1DnT6ZmzBbMO1IGPtZ4?=
 =?us-ascii?Q?NWayiP+at+yiBFPqn0BlyNLsGB3FsfvZuCGXDJd3tCpYuZdfl2kqqdYbMrUG?=
 =?us-ascii?Q?nSPcncGixbC+orElyxWi4Z9/gp/lh/3k4hV8BMDqu7FxBuQqUoGW/T4Tg4fX?=
 =?us-ascii?Q?ElNvoyMbrb6efU4d2mMMjoMaflsw7G0SqqtMfm4MZfWM1cbqUcrmdP3sKJMs?=
 =?us-ascii?Q?kk9JYH8s48/T3lsUcKb4JYOyetlJKPsDboubQy5wTKL1wWYJa/3jHI5sMuy7?=
 =?us-ascii?Q?Y0ZwvuX87xU7Lh30V8zaKKkh0Sh3Hx8D0g7q4gi0CUIfpGjSVJ2VlE1PTm+a?=
 =?us-ascii?Q?0aGZGWtNzyRfvIXv0QAe8/fLg9TA7Eq5wk+DqfrI4VRFtfl0acU21b6PW365?=
 =?us-ascii?Q?6+hRIYApxe29TJj1t5mBIh2AP3lZ67Oi6CFR8K8ljl0V7FwTeOlJbiLF1OYF?=
 =?us-ascii?Q?czGdal+/ONLG8O3cHF4G0Z76T4+v+LfIOsQNEBQFUWv97ohtlhCtpF1C9Xah?=
 =?us-ascii?Q?cr+tIDPgXZlUnZ6KM2M2Ul5GR/1MoRZ6r3S2vv5b2OUf8oNExG7j0vsGN7Ti?=
 =?us-ascii?Q?6LdTy4HkL2wJxnwkHThDF7j8lXuPtaJlfW588veXtKSv4OG+GL55U6TOHk1n?=
 =?us-ascii?Q?s7JZmLFHisOc39+vki2T7dkP/lA7UJZBj4l1zlIhh17TokTq6FjH8ZH8NEe8?=
 =?us-ascii?Q?O6hFeNQcVuMYxnqMOdH6sg1UGBIHd3iSjgi6M/SNVsR55dOduhcBy82J6Icq?=
 =?us-ascii?Q?4APMI/QoLBl72wki25V/twUJQ3hMlaCJezZEKpmeD6/s/L1ggdhuT9G9C3Xd?=
 =?us-ascii?Q?BDl+fRmrNdBOggmfaPX/6lBhz9O5tXBB22LzxJ15JyJWDFQ7ZhFVK58MOyam?=
 =?us-ascii?Q?N01A+K6WF/wBUOvRApiIr7vO12/uA6WMglDvpN0aVtDQnXxDmCdXDgCCHtx8?=
 =?us-ascii?Q?nIaK7VXDWaaCyUEfdB9WvBxFQpOovZvWyHp57CcFS6abyyHwdE9dvB8bUP3v?=
 =?us-ascii?Q?sw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f6da09a0-b769-439e-30a9-08da7bd741c3
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2022 20:22:47.9873
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /8Pnnci4G/Z1tvoZJOCIfvnl2kM3SSXkOmz5HlX3YoPFoP1NUmgYRnsbhPtYytCFf7++dds6Y8Pkg80MrJtIXh3c4hwbe6PizZoqXODpjIc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR11MB5637
X-OriginatorOrg: intel.com

Vishal Verma wrote:
> Add a max_available_extent attribute to cxl_decoder. In order to aid in
> its calculation, change the order of regions in the root decoder's list
> to be sorted by start HPA of the region.
> 
> Additionally, emit this attribute in decoder listings, and consult it
> for available space before creating a new region.
> 
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  cxl/lib/private.h  |  1 +
>  cxl/lib/libcxl.c   | 86 +++++++++++++++++++++++++++++++++++++++++++++-
>  cxl/libcxl.h       |  3 ++
>  cxl/json.c         |  8 +++++
>  cxl/region.c       | 14 +++++++-
>  cxl/lib/libcxl.sym |  1 +
>  6 files changed, 111 insertions(+), 2 deletions(-)
> 
> diff --git a/cxl/lib/private.h b/cxl/lib/private.h
> index 8619bb1..8705e46 100644
> --- a/cxl/lib/private.h
> +++ b/cxl/lib/private.h
> @@ -104,6 +104,7 @@ struct cxl_decoder {
>  	u64 size;
>  	u64 dpa_resource;
>  	u64 dpa_size;
> +	u64 max_available_extent;
>  	void *dev_buf;
>  	size_t buf_len;
>  	char *dev_path;
> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> index b4d7890..3c1a2c3 100644
> --- a/cxl/lib/libcxl.c
> +++ b/cxl/lib/libcxl.c
> @@ -446,6 +446,11 @@ CXL_EXPORT int cxl_region_delete(struct cxl_region *region)
>  	return 0;
>  }
>  
> +static int region_start_cmp(struct cxl_region *r1, struct cxl_region *r2)
> +{
> +	return ((r1->start < r2->start) ? -1 : 1);

I think you want 'equal' case too, right?

val = r1->start - r2->start;
if (val > r1->start)
	return -1;
if (val < r1->start)
	return 1;
return 0;

> +}
> +
>  static void *add_cxl_region(void *parent, int id, const char *cxlregion_base)
>  {
>  	const char *devname = devpath_to_devname(cxlregion_base);
> @@ -528,7 +533,7 @@ static void *add_cxl_region(void *parent, int id, const char *cxlregion_base)
>  			return region_dup;
>  		}
>  
> -	list_add(&decoder->regions, &region->list);
> +	list_add_sorted(&decoder->regions, region, list, region_start_cmp);
>  
>  	return region;
>  err:
> @@ -1606,6 +1611,74 @@ cxl_endpoint_get_memdev(struct cxl_endpoint *endpoint)
>  	return NULL;
>  }
>  
> +static int cxl_region_is_configured(struct cxl_region *region)

s/int/bool/

> +{
> +	if ((region->start == 0) && (region->size == 0) &&
> +	    (region->decode_state == CXL_DECODE_RESET))
> +		return 0;
> +	return 1;

That can be squished to just:

	return region->size && region->decode_state != CXL_DECODE_RESET;

...becase region->start == 0 is a valid state for a configured region.


> +}
> +
> +/**
> + * cxl_decoder_calc_max_available_extent() - calculate max available free space
> + * @decoder - the root decoder to calculate the free extents for
> + *
> + * The add_cxl_region() function  adds regions to the parent decoder's list
> + * sorted by the region's start HPAs. It can also be assumed that regions have
> + * no overlapped / aliased HPA space. Therefore, calculating each extent is as
> + * simple as walking the region list in order, and subtracting the previous
> + * region's end HPA from the next region's start HPA (and taking into account
> + * the decoder's start and end HPAs as well).
> + */
> +static unsigned long long
> +cxl_decoder_calc_max_available_extent(struct cxl_decoder *decoder)
> +{
> +	struct cxl_port *port = cxl_decoder_get_port(decoder);
> +	struct cxl_ctx *ctx = cxl_decoder_get_ctx(decoder);
> +	u64 prev_end = 0, max_extent = 0;
> +	struct cxl_region *region;
> +
> +	if (!cxl_port_is_root(port)) {
> +		err(ctx, "%s: not a root decoder\n",
> +		    cxl_decoder_get_devname(decoder));
> +		return ULLONG_MAX;
> +	}
> +
> +	/*
> +	 * Preload prev_end with decoder's start, so that the extent
> +	 * calculation for the first region Just Works
> +	 */
> +	prev_end = decoder->start;
> +
> +	cxl_region_foreach(decoder, region) {
> +		if (!cxl_region_is_configured(region))
> +			continue;
> +
> +		/*
> +		 * Note: Normally, end = (start + size - 1), but since
> +		 * this is calculating extents between regions, it can
> +		 * skip the '- 1'. For example, if a region ends at 0xfff,
> +		 * and the next region immediately starts at 0x1000,
> +		 * the 'extent' between them is 0, not 1. With
> +		 * end = (start + size), this new 'adjusted' end for the
> +		 * first region will have been calculated as 0x1000.
> +		 * Subtracting the next region's start (0x1000) from this
> +		 * correctly gets the extent size as 0.
> +		 */

Not sure if I prefer this block comment, or just seeing prev_end being
done with -1 math and max_extent doing the + 1 because it's a size...

The latter seems more idiomatic to my eyes, but I'll leave it up to you.

> +		max_extent = max(max_extent, region->start - prev_end);
> +		prev_end = region->start + region->size;
> +	}
> +
> +	/*
> +	 * Finally, consider the extent after the last region, up to the end
> +	 * of the decoder's address space, if any. If there were no regions,
> +	 * this simply reduces to decoder->size.
> +	 */
> +	max_extent = max(max_extent, decoder->start + decoder->size - prev_end);
> +
> +	return max_extent;
> +}
> +
>  static int decoder_id_cmp(struct cxl_decoder *d1, struct cxl_decoder *d2)
>  {
>  	return d1->id - d2->id;
> @@ -1735,6 +1808,8 @@ static void *add_cxl_decoder(void *parent, int id, const char *cxldecoder_base)
>  			if (sysfs_read_attr(ctx, path, buf) == 0)
>  				*(flag->flag) = !!strtoul(buf, NULL, 0);
>  		}
> +		decoder->max_available_extent =
> +			cxl_decoder_calc_max_available_extent(decoder);
>  		break;
>  	}
>  	}
> @@ -1899,6 +1974,12 @@ cxl_decoder_get_dpa_size(struct cxl_decoder *decoder)
>  	return decoder->dpa_size;
>  }
>  
> +CXL_EXPORT unsigned long long
> +cxl_decoder_get_max_available_extent(struct cxl_decoder *decoder)
> +{
> +	return decoder->max_available_extent;
> +}
> +
>  CXL_EXPORT int cxl_decoder_set_dpa_size(struct cxl_decoder *decoder,
>  					unsigned long long size)
>  {
> @@ -2053,6 +2134,9 @@ cxl_decoder_create_pmem_region(struct cxl_decoder *decoder)
>  		return NULL;
>  	}
>  
> +	/* Force a re-init of regions so that the new one can be discovered */
> +	free_regions(decoder);

You do not need to free them, the re-init will do dup detection and
*should* just result in the new one being added. In fact, you probably
do not *want* to free them as that could cause problems for library
users that were holding a 'struct cxl_region' object before the call to
cxl_decoder_create_pmem_region().

With the above fixes folded in you can add:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
