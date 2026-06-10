Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013006.outbound.protection.outlook.com [40.107.201.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE3A331EC1
	for <nvdimm@lists.linux.dev>; Wed, 10 Jun 2026 03:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781063726; cv=fail; b=GiD37tGeVlVK+wuR+ne3CxTI6U3/zjEXBomXXXOdVfB6vaDRV5U2mcQAMlN7EWRUs5LnzRKtYYDI71NWWkKXLBHfHxeOW5C03HEoCxHBCvH1t6U2fYF0VqyJ3kcM5jB+Nlq5hA48nyUelkw9SuPxLIY+bnbjR+/FfOSpYfQYqHA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781063726; c=relaxed/simple;
	bh=PG889xSczhwger89RGRqyRGY+WmVfkKVUm3rPihSotc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=JFl+1yq/8z4eV0i79v7HWDcc6maM6UZBfc2eq9aWLesvo1c0rbnPF4LNHm/9kJb8XUEw0boc9Qw/6nvinmT3QP2hLIC/9ug5ZEm0WDH71C9PTe2jxBIs7urvyCDvsX7N9n/NFoKpUgFuWVUhN4qljfWU7h9m1xGMXWeMzbxNYBg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Zhbla8hz; arc=fail smtp.client-ip=40.107.201.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Zhbla8hz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ut4N+c0lUWf35wi72WxmTfHFRMc1+MhPWe1neKihxC5xmtGMPafkeflv9oy+mLhBfHlBDOz2t65hcp7MNGXJkGLhN5txGl5pLek1/u3qRbBTmpkUnoOwtQznnVHkPdl3yPssNHkhqT6v0whemHnIW+kqkYxPqJf3ZpolyEFUNLvlUN1y135xRTeZREWMSy1rrNSm/J2xyjR87zpMKrTYz2ChCAI+rLRKBcgibB+IvUdB37feRNFyZDsYafjq1hPqwZOkgLewyUYoWjN2IC7M1mj0Y/r3EGxM1PJezm8TldZxn/fCJzSxgGzYo5OAFp4R9YY4ZAs5cjUBNKlD3qZvjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CUVR1TV3yGQ+G4U9cVT+LZIFzuPHAOXTtwM3e2Dz7vU=;
 b=aPiwxnXZs7/80XV8EB5w+lkRLzcjT5n7bTdfkU7I+Gw1oHpx/S5RZIVcq5B4VCfhlFH3mnKuwPc0HngC3oxo3Nyol7rld9BOEvnJyLuv6OtA3Hh2KsCaJRObh/dUt3QLGru+OUVhkLGiJJrgjsRwKNrqVcLuHUN31N0pHpElKxZk2UFf5SvPwoJJxUIwuxEgrDjtcp3HF1MOx5LGMjgPN9Bt3nYRnZB5iYtm1xEcFpRcmT9xGWr2G487RLcX9v8/nD39Xo9624Nn66d6N1iYvZ/f6eWyagpePV4HHhLOmFf1f6+EFa3TzTbjX+G0Ef1/pNFe2HX7B0mGkT7A75Punw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CUVR1TV3yGQ+G4U9cVT+LZIFzuPHAOXTtwM3e2Dz7vU=;
 b=Zhbla8hzD7jSXgKkAyoDtfDrzyRi0XZp2sxngqbgDKlRpooux54T3Zlbeejo8LeAZNC12hqMCevJHjphQDBWVn9xf6JoOIGSKFRZUSiygi2Lp2KC8vBuv86jqfd1uDiDbOWK3gVesOc6rkcBiu96F1LiyBA0ASZ7cqEtzNb1oDTLb0ggdGXmFlqbftFZaiWHar/NMN+etic2i0MAm4W+cdxolFZy6fWt5/pVGByLeh2A0DsTIXhLGNBifrpxMmU7k5cWkVhimTNQx6dsgO/vfagprJ3IWwlB329w8dnTtwCCb3vKRCm3Gr2z8KhtAafWT/WIQZHOeJcxpIAhzMua1w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
 by DS5PPF23E22D637.namprd12.prod.outlook.com (2603:10b6:f:fc00::647) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.13; Wed, 10 Jun
 2026 03:55:19 +0000
Received: from BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8]) by BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8%5]) with mapi id 15.21.0092.011; Wed, 10 Jun 2026
 03:55:18 +0000
Date: Wed, 10 Jun 2026 11:55:12 +0800
From: Richard Cheng <icheng@nvidia.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, Dan Williams <djbw@kernel.org>, 
	Jonathan Cameron <jic23@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>, 
	Ira Weiny <iweiny@kernel.org>, Alison Schofield <alison.schofield@intel.com>, 
	John Groves <John@groves.net>, Gregory Price <gourry@gourry.net>, 
	Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH v6 5/7] cxl/region: Add extent output to region query
Message-ID: <aijfsGSwTAD33KCN@MWDK4CY14F>
References: <20260523095043.471098-1-anisa.su@samsung.com>
 <20260523095043.471098-6-anisa.su@samsung.com>
 <ad25c4ad-b967-46c5-a983-a0c0ceb7d825@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad25c4ad-b967-46c5-a983-a0c0ceb7d825@intel.com>
X-ClientProxiedBy: SI1PR02CA0032.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::12) To BL0PR12MB2370.namprd12.prod.outlook.com
 (2603:10b6:207:47::27)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR12MB2370:EE_|DS5PPF23E22D637:EE_
X-MS-Office365-Filtering-Correlation-Id: 82f1fa85-56cc-4e49-f38a-08dec6a4160c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|7416014|366016|22082099003|3023799007|18002099003|11063799006|4143699003|6133799003|56012099006;
X-Microsoft-Antispam-Message-Info:
	vBQ34pgKWD2YnGStA48hfEs7npUZPprRLc7/rRSqb4x6j3XLED3A1hHhlKbrDL183Pl+h43D3nLh/vbwhFy6hvAJdAL2k9JmIY6fMyLnHAuf7HY6r+KImfe1ZM9R7KLlqwE9xA9+sVPu/Xnn1Y544m+HeLGO9qd3jbJCMnVQH6QkKX1nwgjsUtDheeX2rtNoC3OECMLq1wz+iGvpNgbvA8+bq5nGTcSzWKz18GlVJLgy3wxdQckMOMlUuyMDT/Dq8JWs6TGkZTgBeEKG2o0rL/843jwT2aCXB4D2zxbhjlvR0uc7KuLRKKi6zSsPcGbx6nBsB264MS1/dwp4bUWYBQh0FzMtiIAA9VE3agTUoJkSQrrVRxkP4UtSre5L7+2MhHHY8k3a22pJZO2kILicBZkkcwQ8YGHOhtp0QkVrs6REEcqmbiNEHMSZNYcIjhqJGxPKWF5i18mW9JSJyyNgGLb443Okbu+cx3rtK0fAeOH26ALKf1sgAsuktPLSzru+TqY55wsHrer00PVA4cGJMj60jn3/t2S5dddcEWADB5p5dHOae4sNdrsHxAY4mmCze1ctwJx3P//Pve0CxkeDwOXTcfIyWUxGWIqMVaGey/pxASI72QtOplGwahkXasNCE2zhibvOm/1Xb3bE/wntAKbscDOJV6W1UeLsCE8Tu158mgKE3fWoLLXHBK8A236J
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2370.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(7416014)(366016)(22082099003)(3023799007)(18002099003)(11063799006)(4143699003)(6133799003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ddPn9fVBtaWp/8nM5SdrPdJNw1rRr0GCBg9yWicXzctsAUSaf404KR+zj0Cl?=
 =?us-ascii?Q?ejnO6vy1z6TMGxTeCftEanmYDklWtU0WGOAOodJjbK5QWiiDcYKg48DUOhW7?=
 =?us-ascii?Q?1Q9rQP8pNtwF6H2UqvwFmHgNHlJnN1QKFCkAmARYEPhKce2ZVRqkRB4jeE7/?=
 =?us-ascii?Q?2K8uJzo2AEUrZOW9g6hj2auRJP+hunRoeyio2Tu/LzMm60jA3N1fXqOcBTC/?=
 =?us-ascii?Q?6nLr6RsrRGLVsBAe8cxrZvWP/U/0QuAls8EZrG0AEmdaetRi6D2D9MHMHOrU?=
 =?us-ascii?Q?ZhAomCq9NzOEjsFs/MHb5XC9JkhMrkk4Mcqt9Pv8IZBy6tkyvuPyWs7dW1iG?=
 =?us-ascii?Q?8a8WpgOUM/j9KfRI7bYzd/4nsATnOGhP9V0Yo+ghGftgZgtBISf+fXPmyysq?=
 =?us-ascii?Q?bKqzBSwzCQJ+YwehHqBklHYOQ1I6PJDD3wNIr7U8JbQch9KO/dwNW2GPT/QU?=
 =?us-ascii?Q?gYFe7setg4zZHwFs1Z6uDgnSg56LRbB5o7Pn+fT70yJRFgS1P3gYuKQmgqJl?=
 =?us-ascii?Q?udCkV1WbOcRAZqfs6Gv8sTmUA/sakpwrUkuMDNSYRyU9aaL9Wl219F4LuufU?=
 =?us-ascii?Q?ti750haMpdNNY1zq/SLii3oHgXTWS7vc/YsZgP/hkifmLwrUN1cEKPOI+dpY?=
 =?us-ascii?Q?bz0CWTxK9iLoOIWE9eWeGqHDKmxub2Yhh66Nud9Zhb3cVl6ag+0hIdKgbyFp?=
 =?us-ascii?Q?a8Gz5tnPPlxgPlKe+geNkbc3i3AYFEa5tS1kLY+CR4ABju4ZDs5XoYC8c6xc?=
 =?us-ascii?Q?AiumJoruI4H1NofFLiOf8edoKhZ2zidqE3fd76hfZ/PnVPAMi/Gyhdx51csq?=
 =?us-ascii?Q?b3iheNLkGaQ8CYjCRaDwsF5+TMSq6vRGiKvmTn/QAsuek40a73wdarOvRrKa?=
 =?us-ascii?Q?JEnwGYv3Ql8AbzGrcyweM2HASF4wSG0/8s786WQEma5J5kByE/m9PjRSWuRe?=
 =?us-ascii?Q?cqFDr2zPIlLVHry9JvO1ma3FDjWfCqgnkkxTJOGcIlTr9QM/nJV29ar/biI0?=
 =?us-ascii?Q?D01vTyKPR0roRqhh5UfGjcng3SLCHPG7xRthdZ0k8mds7AIEr7/qbxo2dkYV?=
 =?us-ascii?Q?WbDzmBfFEO5Rr/lCYZ1SbKQ+h+9sIGOx5aBHE3YzJwz6E/2JolHW3sntbTBT?=
 =?us-ascii?Q?qccY0gO6WaO8N1MSqKbt1iBfBJ06dcUZ4IoasaIpQQq+9PufhWEOHT/dsaDo?=
 =?us-ascii?Q?y9qGI1Kc/R/GUjbh9OqpbmRPis07nXF2fMB0iY/ZsskUFRv1gRp3jMo6eqqf?=
 =?us-ascii?Q?G2trkGAcB+OzSDhbC1uXct9ZvjPJp4Z1g1A8S/4Z4dyu+iUIuh+41039RrJ1?=
 =?us-ascii?Q?BYrNzjmLLhuDYfLgfG6gR5PoAY/ziVYHtbI7RRj0cSrJ8FuRfanFSPQ+Mqbk?=
 =?us-ascii?Q?PBWI9gYAwnA0skLxaum9yy2ygiZpF0g3+tTgV/hZ1LtKA+MhGElvxGpHRVSw?=
 =?us-ascii?Q?shqlspXkTeIJhWhLlnc8WZLmGlB8Q2W9frHhQCCvVJ5JrJ93dtS5NaCXdxbW?=
 =?us-ascii?Q?q9H3qQvO51z+3iBvS/kKaFZpUauGU4q7WM6IGWjZRUpa8NnrHBQXYUxX7w8a?=
 =?us-ascii?Q?Xst2JpGrBliS13tCPDBbEQeCDRLWAB8pfb+Ip8BQOkiKL+nAKVLFhIqXp4z5?=
 =?us-ascii?Q?jFUrDmOgx/zZcxX0xZMjPR0xFLn/603+nvzp6zMz+qWp3iyXF5LzSwuFuMKs?=
 =?us-ascii?Q?l8I6MLRphT7zmRNu/VAg9yG1dKCPMH1RG6xqfkjKiOfdrGEx+s2Zq7k6DLRc?=
 =?us-ascii?Q?HC9A4SgnUg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82f1fa85-56cc-4e49-f38a-08dec6a4160c
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2026 03:55:18.4250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t8JqIFIiYHMC2bI/u9iSPDUTLYjENVZBpgxINZMLGoRmLtJ0gH4IexqJuUAN8py1ESOMz+1jyQzYzCHvD1wIog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPF23E22D637

On Mon, Jun 08, 2026 at 05:08:19PM +0800, Dave Jiang wrote:
> 
> 
> On 5/23/26 2:50 AM, Anisa Su wrote:
> > From: Ira Weiny <ira.weiny@intel.com>
> > 
> > DCD regions have 0 or more extents.  The ability to list those and their
> > properties is useful to end users.
> > 
> > Add an option for extent output to region queries.  An example of this
> > is:
> > 
> > 	$ ./build/cxl/cxl list -r 8 -Nu
> > 	{
> > 	  "region":"region8",
> > 	  ...
> > 	  "type":"dc",
> > 	  ...
> > 	  "extents":[
> > 	    {
> > 	      "offset":"0x10000000",
> > 	      "length":"64.00 MiB (67.11 MB)",
> > 	      "tag":"00000000-0000-0000-0000-000000000000"
> 
> I think the code emits "uuid". Update commit log.
> > 	    },
> > 	    {
> > 	      "offset":"0x8000000",
> > 	      "length":"64.00 MiB (67.11 MB)",
> > 	      "tag":"00000000-0000-0000-0000-000000000000"
> 
> same here
> 
> DJ
> 
> > 	    }
> > 	  ]
> > 	}
> > 
> > Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> > 
> > ---
> > Changes:
> > [iweiny: s/tag/uuid/]
> > ---
> >  Documentation/cxl/cxl-list.txt | 29 +++++++++++++++++++++
> >  cxl/filter.h                   |  3 +++
> >  cxl/json.c                     | 47 ++++++++++++++++++++++++++++++++++
> >  cxl/json.h                     |  3 +++
> >  cxl/list.c                     |  3 +++
> >  util/json.h                    |  1 +
> >  6 files changed, 86 insertions(+)
> > 
> > diff --git a/Documentation/cxl/cxl-list.txt b/Documentation/cxl/cxl-list.txt
> > index 193860b..7512687 100644
> > --- a/Documentation/cxl/cxl-list.txt
> > +++ b/Documentation/cxl/cxl-list.txt
> > @@ -426,6 +426,35 @@ OPTIONS
> >  }
> >  ----
> >  
> > +-N::
> > +--extents::
> > +	Append Dynamic Capacity extent information.
> > +----
> > +13:34:28 > ./build/cxl/cxl list -r 8 -Nu
> > +{
> > +  "region":"region8",
> > +  "resource":"0xf030000000",
> > +  "size":"512.00 MiB (536.87 MB)",
> > +  "type":"dc",
> > +  "interleave_ways":1,
> > +  "interleave_granularity":256,
> > +  "decode_state":"commit",
> > +  "extents":[
> > +    {
> > +      "offset":"0x10000000",
> > +      "length":"64.00 MiB (67.11 MB)",
> > +      "uuid":"00000000-0000-0000-0000-000000000000"
> > +    },
> > +    {
> > +      "offset":"0x8000000",
> > +      "length":"64.00 MiB (67.11 MB)",
> > +      "uuid":"00000000-0000-0000-0000-000000000000"
> > +    }
> > +  ]
> > +}
> > +----
> > +
> > +
> >  -r::
> >  --region::
> >  	Specify CXL region device name(s), or device id(s), to filter the listing.
> > diff --git a/cxl/filter.h b/cxl/filter.h
> > index 70463c4..30e7fe2 100644
> > --- a/cxl/filter.h
> > +++ b/cxl/filter.h
> > @@ -31,6 +31,7 @@ struct cxl_filter_params {
> >  	bool alert_config;
> >  	bool dax;
> >  	bool media_errors;
> > +	bool extents;
> >  	int verbose;
> >  	struct log_ctx ctx;
> >  };
> > @@ -93,6 +94,8 @@ static inline unsigned long cxl_filter_to_flags(struct cxl_filter_params *param)
> >  		flags |= UTIL_JSON_DAX | UTIL_JSON_DAX_DEVS;
> >  	if (param->media_errors)
> >  		flags |= UTIL_JSON_MEDIA_ERRORS;
> > +	if (param->extents)
> > +		flags |= UTIL_JSON_EXTENTS;
> >  	return flags;
> >  }
> >  
> > diff --git a/cxl/json.c b/cxl/json.c
> > index e94c809..7922b32 100644
> > --- a/cxl/json.c
> > +++ b/cxl/json.c
> > @@ -1022,6 +1022,50 @@ void util_cxl_mappings_append_json(struct json_object *jregion,
> >  	json_object_object_add(jregion, "mappings", jmappings);
> >  }
> >  
> > +void util_cxl_extents_append_json(struct json_object *jregion,
> > +				  struct cxl_region *region,
> > +				  unsigned long flags)
> > +{
> > +	struct json_object *jextents;
> > +	struct cxl_region_extent *extent;
> > +
> > +	jextents = json_object_new_array();
> > +	if (!jextents)
> > +		return;
> > +
> > +	cxl_extent_foreach(region, extent) {

Every region rendered with the flag, including non-DC RAM/PMEM regions.
They all get a spurious "extents": [].
I would suggest guarding on cxl_extent_get_first(region) != NULL before
adding the key.

What do you think?

Best regards,
Richard Cheng.

> > +		struct json_object *jextent, *jobj;
> > +		unsigned long long val;
> > +		char uuid_str[40];
> > +		uuid_t uuid;
> > +
> > +		jextent = json_object_new_object();
> > +		if (!jextent)
> > +			continue;
> > +
> > +		val = cxl_extent_get_offset(extent);
> > +		jobj = util_json_object_hex(val, flags);
> > +		if (jobj)
> > +			json_object_object_add(jextent, "offset", jobj);
> > +
> > +		val = cxl_extent_get_length(extent);
> > +		jobj = util_json_object_size(val, flags);
> > +		if (jobj)
> > +			json_object_object_add(jextent, "length", jobj);
> > +
> > +		cxl_extent_get_uuid(extent, uuid);
> > +		uuid_unparse(uuid, uuid_str);
> > +		jobj = json_object_new_string(uuid_str);
> > +		if (jobj)
> > +			json_object_object_add(jextent, "uuid", jobj);
> > +
> > +		json_object_array_add(jextents, jextent);
> > +		json_object_set_userdata(jextent, extent, NULL);
> > +	}
> > +
> > +	json_object_object_add(jregion, "extents", jextents);
> > +}
> > +
> >  struct json_object *util_cxl_region_to_json(struct cxl_region *region,
> >  					     unsigned long flags)
> >  {
> > @@ -1126,6 +1170,9 @@ struct json_object *util_cxl_region_to_json(struct cxl_region *region,
> >  		}
> >  	}
> >  
> > +	if (flags & UTIL_JSON_EXTENTS)
> > +		util_cxl_extents_append_json(jregion, region, flags);
> > +
> >  	if (cxl_region_qos_class_mismatch(region)) {
> >  		jobj = json_object_new_boolean(true);
> >  		if (jobj)
> > diff --git a/cxl/json.h b/cxl/json.h
> > index eb7572b..f9c07ab 100644
> > --- a/cxl/json.h
> > +++ b/cxl/json.h
> > @@ -20,6 +20,9 @@ struct json_object *util_cxl_region_to_json(struct cxl_region *region,
> >  void util_cxl_mappings_append_json(struct json_object *jregion,
> >  				  struct cxl_region *region,
> >  				  unsigned long flags);
> > +void util_cxl_extents_append_json(struct json_object *jregion,
> > +				  struct cxl_region *region,
> > +				  unsigned long flags);
> >  void util_cxl_targets_append_json(struct json_object *jdecoder,
> >  				  struct cxl_decoder *decoder,
> >  				  const char *ident, const char *serial,
> > diff --git a/cxl/list.c b/cxl/list.c
> > index 0b25d78..47d1351 100644
> > --- a/cxl/list.c
> > +++ b/cxl/list.c
> > @@ -59,6 +59,8 @@ static const struct option options[] = {
> >  		    "include alert configuration information"),
> >  	OPT_BOOLEAN('L', "media-errors", &param.media_errors,
> >  		    "include media-error information "),
> > +	OPT_BOOLEAN('N', "extents", &param.extents,
> > +		    "include extent information (Dynamic Capacity regions only)"),
> >  	OPT_INCR('v', "verbose", &param.verbose, "increase output detail"),
> >  #ifdef ENABLE_DEBUG
> >  	OPT_BOOLEAN(0, "debug", &debug, "debug list walk"),
> > @@ -135,6 +137,7 @@ int cmd_list(int argc, const char **argv, struct cxl_ctx *ctx)
> >  		param.decoders = true;
> >  		param.targets = true;
> >  		param.regions = true;
> > +		param.extents = true;
> >  		/*fallthrough*/
> >  	case 0:
> >  		break;
> > diff --git a/util/json.h b/util/json.h
> > index 560f845..79ae324 100644
> > --- a/util/json.h
> > +++ b/util/json.h
> > @@ -21,6 +21,7 @@ enum util_json_flags {
> >  	UTIL_JSON_TARGETS	= (1 << 11),
> >  	UTIL_JSON_PARTITION	= (1 << 12),
> >  	UTIL_JSON_ALERT_CONFIG	= (1 << 13),
> > +	UTIL_JSON_EXTENTS	= (1 << 14),
> >  };
> >  
> >  void util_display_json_array(FILE *f_out, struct json_object *jarray,
> 
> 
