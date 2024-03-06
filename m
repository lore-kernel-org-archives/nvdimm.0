Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5651CD3C
	for <nvdimm@lists.linux.dev>; Wed,  6 Mar 2024 23:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709768200; cv=fail; b=Z+Z0KATTNwxLFtX+DS02oTnygcHyvjRmyDyj60Ux011YbjXtmrfe0nWNnNwzmOkLisKOrtiiTV1EF1h2yUAJiyScXszg6mIc2BNgXDbI48ZUyfvb6FkWCq0HlVbvAtas6er99Vqf2/uhl42oq3MzV5tBXc21OfHEl51vedM1p80=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709768200; c=relaxed/simple;
	bh=IMklQjOru1xJkwIOXAWVDoZQmMNhjzoKcPGl9vAtws4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=mqoKnPw2FXBkuUSKmoNr3oQsnt0peGdCCnDNoE51qc/Ixe6APm3R1JDjqZXnO8HI8hfr0eAssgAitmDKPTa618UiX2aYJCko2uR0ShXGp6jMkwOt9X3d1Rt+CXoswuJpdcCwb6RckEiGSCxaAtPpubZw5QxPi1bzWpeDOHrwtSU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d4QA9/T4; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d4QA9/T4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709768199; x=1741304199;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=IMklQjOru1xJkwIOXAWVDoZQmMNhjzoKcPGl9vAtws4=;
  b=d4QA9/T4K3vob4X6uAVOyMqszMC24Imn7x6n2czpvA33+28RnLhcqyj9
   ligdUoLMVeRv4bYMJUo9zUnpC9C7e4dX5C13+Q6IuknZ5MlcqGeC5O1Nx
   TNjYsU9X0ViI92DJQPQYUCXro98NNSwt1ihvlsFCWxpxTjVloxRJOuhu1
   3c+tSeQh/Dvi+ikXir9Ezr2uaXKnXUvyS6xcUNE5YPKkggXybxKv8Ssn1
   gMfBmIALw3FgWQmlb+LjglCnvLHoFxITaGT5MFk3U96px5K/Q3o5qm9Di
   tZL7x4FTHzdHiPBJ3qcUmyEHc/GC7o+mX4aOI6RlLKSIuNHMHsYuO1udx
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11005"; a="8230653"
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="8230653"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 15:36:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="40808295"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Mar 2024 15:36:39 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Mar 2024 15:36:37 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Mar 2024 15:36:36 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 6 Mar 2024 15:36:36 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 6 Mar 2024 15:36:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mo4SwyK9+3knpwCis7pJFxM6O34RW0w6hkkrNitydumw5xJvyaRwOz5S7GKjhhOwscjQNNAW1AOq4NVOn969+wE8A3ymWWTdx62nLitWRcJfcpSrVLGoR1zjYRMNkkbgpgh0CPjHLlMdI4YerDAUgiZC9oAtsVtrpkc1VS4W5v3f23tQ+eLNUZqwbMD6EDzjFd1sYgmr60S06kEl7qh+mU/nvphimvg+zRKTFX+Jd5N9EdEY8/dVocoVvUeVur6P0ExFTInXQXQZzgt5AeaejkASjTzG5uU+HHgDCpD6uPernYvXrKXFw6jVOZhwuf3YHICRBUc4qMZRQ+uLI6mXJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N+8gDwqmx9HBNTHeK/kupwJFytgzEVI7jsgNu3vzX4o=;
 b=KPtrcrnMKCd19yUzMkubAa8seBJ5CaTgLwEwy7QyeTFlbWKc0DvkUpVzZqT/NyPQMzRM3a+75oaoHYHhcHlPB6D4Elb3591sIP0zN8pm2BgiVUlTM5jghZiRX3TnrTwvt01z7bbbq7caS5Sw59CVVZKs4wE4YT3Ai+Ju0hW7kGh6pKZQD7TLRJuxSgPJAlwI9bR1H9u26KU280UW6XX9t+p6K1CxU64cIPKLEEQFW/YHwXsoWPL+UD8vdxXUfzq1JTM4JmMgpEdZwexuU4wNleMq3ppxkp5ZzY/7zBPhaTFKhZ9T8R5ha0I4pdrEV66BgxFifUoxeFvJqqYxLSvSfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.23; Wed, 6 Mar
 2024 23:36:34 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::82fd:75df:40d7:ed71]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::82fd:75df:40d7:ed71%4]) with mapi id 15.20.7362.019; Wed, 6 Mar 2024
 23:36:34 +0000
Date: Wed, 6 Mar 2024 15:36:32 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: <alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
CC: Alison Schofield <alison.schofield@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>, Dave Jiang <dave.jiang@intel.com>
Subject: Re: [ndctl PATCH v10 3/7] cxl/event_trace: add a private context for
 private parsers
Message-ID: <65e8fe00756cd_12713294f2@dwillia2-mobl3.amr.corp.intel.com.notmuch>
References: <cover.1709748564.git.alison.schofield@intel.com>
 <6e975df49a62cdb544791633fdd1a998a0b60164.1709748564.git.alison.schofield@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6e975df49a62cdb544791633fdd1a998a0b60164.1709748564.git.alison.schofield@intel.com>
X-ClientProxiedBy: MW4PR03CA0073.namprd03.prod.outlook.com
 (2603:10b6:303:b6::18) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|PH0PR11MB5832:EE_
X-MS-Office365-Filtering-Correlation-Id: 404a0ce6-25b2-4718-5bf2-08dc3e364276
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MRSwMx+ZgKADwxwwECSWXLhGEOjnL1Imx81haRcFYeETXPNoUukCxFlBF2ggQyesZ5sRMn5l2HyOvEicKUZwtyczfWAa2QFLMAhlegeUvLAGlbgaezCqXrL/CBJKm2r15AdCH4v0GiulsFbrzRQcDXvryps6pS1RAGhmVwPdq0oRwHIstvmqbGCnPp0xkT3x2iNxrbE8kbZuE09NXomzKX/5mn761vvhILjP5useuLVJcFzYPfrtt9KigeZnaifsLi6ExroEtCF8bimiffpaKhEzxPfM1Ty+cXZXTHMUMXEoe/Z7nsjbE+/GMS+4Lx8eh6t4IOQAM+gp1M8p96cV7F3j5Wsmf6IAM6yLmRAuD5BbBN0sYbzcnJY2eQSQ+5B2V95QTg86FZgRrpBB64BBpSREL7Pton3HG60seV5FPVLv80yv0qXQTcMaNFW4u5VCW4khB+VPcL5+v5OqrcNhytRdpMOxZY+0av7+mRUb1Bw+8eNIjMjARHLpzPFunTMG9lywgg1B70qeOE7gi5B1n/IUamEXZEnZBOpEYT8PLDYTl8weEj/Nqx3xcMFjKHA+vjgX9g9ZLSJArhhNoFU3iAqm4i9I44o0knTuIa/IOJ0qJq2xgaCREFhsu1trnvAY4Qtm1uFxUHTID2+WurOyFPMXuxyNsh69BSHB8z7wO6Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WvXD+R0aEqsiMaSOvZptOEl1kRbWPVWXnVlflbX+IdF31ZJE3aQPKCkRmy2e?=
 =?us-ascii?Q?NXCyKZ68zo4GW8PpW+1o/GEisiMJkjXaKsJ5m2DDMWx05NEgp12NOtZXr6cM?=
 =?us-ascii?Q?ZXRmaKbdoo9zQ2Q4jVRGE3De9occmcJYE8f19hEN5JE5wbRS0xqFWiLhXEb0?=
 =?us-ascii?Q?rR7pA005wxmBNTcObL+Xmsqzt7v5A0Z8DVSs19cEnqax/qGYWlVFxOCONvF1?=
 =?us-ascii?Q?cLBium9Lz3lAXstxlMh1o4XtmGz1dObzxzVNO0hwwbng2eATGQukX2c6eI9D?=
 =?us-ascii?Q?Clh6tnAb9hz8Xklc04r04b+VvHA8crR4KwtFh+OG7+Nys88Ua+wkc+Pf2Hxe?=
 =?us-ascii?Q?xWMRofG2sqni0SFDlqCnUCPdN7j3uBafFbx35N8oujlmR0cyLMPurcwxBxlJ?=
 =?us-ascii?Q?dkkahNHsOcJW8GGe6QaPHwza30MZocEySbpUqPj94p2Labhh9xO3FcOkKF9x?=
 =?us-ascii?Q?Z6q32jLMa+MNrVuTTMV9NRqQw73WTVR+JIMdGgwrNOuYBzBtLTZKgUatxAnc?=
 =?us-ascii?Q?FlslZAF1+o3dMmvv5UgVs0xAy9OJh2TkCqsEYNjkunhrAjT3naMIHljKsh9R?=
 =?us-ascii?Q?KxQLosL64jWiw0jJcnmsuqBmSS3K9GMAoKFLeGEWmgrc1VsKFfU03YSUT1LI?=
 =?us-ascii?Q?nBldKxsdM0cXqVj6w7HI+w+lvP1WI6ZIII6IhVChXtV0LQGFCsqOCILA0GH2?=
 =?us-ascii?Q?cq7kE59+ruDpqJooD3jxmYKpxkRLneUWGMRyUdjzxQAhvf9KPdZQMAcedGbr?=
 =?us-ascii?Q?4s8BD4k1U0/6wjHGTMw4Fy1OKk9MEZHdypockuDmkMfCjj6wKHrNPi1bPivq?=
 =?us-ascii?Q?YU9hpik3Ezuz/1BEkSL3vQ84zm2+e61gZlHnpBmInILDVfNcbMLRrxGp8Cmi?=
 =?us-ascii?Q?V4E8p0mx4Y08Gs1ZaDdR0pWlaBqZ+g4sLjXIrX83ImvhtdeFmm4ljEeS7P1J?=
 =?us-ascii?Q?xHgPc4BPseOOOehD0UvOprGKsitsYye4BGL4Ey88gHC3gcu+kaHrEyj/uXtS?=
 =?us-ascii?Q?7aKgzAh0K75vC7eaJOgn+uerF/E6JWgVq4myRWduSABvscOyYnDweLGFbSBe?=
 =?us-ascii?Q?Dx1f9928fZ7UHbQMmyeTiddEhr9uOU4/rdkIARUgcsE8OvBPgmXtB8YRIhrq?=
 =?us-ascii?Q?Ddx/ggCAGnq/jnFqkXU4aVzUlkL0AzkjohZJ9XXG4mwnzfetZKoHSSXVjfb1?=
 =?us-ascii?Q?GLEZojpg+DBcYhUuzFIVG2oRsk4BeKfO50xrIEDN2C10JXevbF3maXdRlboy?=
 =?us-ascii?Q?FNElL+M9lBuWPkskuSrcJpURTEdzMXynj5dnJnh/TzjdYC8AH8/D1lYumX6c?=
 =?us-ascii?Q?k6gTYymILAWyealg9vPodpIrtWqTJA/V3l+oodRLIYYnNfyhfzRbHyTe1N4I?=
 =?us-ascii?Q?VOh7vXsQi//jqVMLoMhzchsux6DFVeFw2fypZQoTkVi0vbMsv77kCutsBH9W?=
 =?us-ascii?Q?hEmU/A9219eW2QEGjX3sZ+SeM6Y6DSJ6HySIEV6zqUWLbVhraqB0McM6LfNv?=
 =?us-ascii?Q?CHSOg824RtBztazPQkVTV/FGrcXlpjcZKE224o5YgWe7my95C9h+taDOffuG?=
 =?us-ascii?Q?SzzMB5ZR+AM5YUWufBsOfedO4IzsJZUmkzYjnofFhbil0m5ENC119jYqamgT?=
 =?us-ascii?Q?BA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 404a0ce6-25b2-4718-5bf2-08dc3e364276
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2024 23:36:34.5071
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fqEUFDxoG25xsGXsppVb7OqhK7qIKaHPkiwo73rjZvgbvhRaLKCBTyzI9QxhuXTuAFKOL0thBtlJ0JpnyIUdp+NUsG5nWDxmH2Z4vZqLehY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5832
X-OriginatorOrg: intel.com

alison.schofield@ wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> CXL event tracing provides helpers to iterate through a trace
> buffer and extract events of interest. It offers two parsing
> options: a default parser that adds every field of an event to
> a json object, and a private parsing option where the caller can
> parse each event as it wishes.
> 
> Although the private parser can do some conditional parsing based
> on field values, it has no method to receive additional information
> needed to make parsing decisions in the callback.
> 
> Add a private_ctx field to the existing 'struct event_context'.
> Replace the jlist_head parameter, used in the default parser,
> with the private_ctx.
> 
> This is in preparation for adding a private parser requiring
> additional context for cxl_poison events.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  cxl/event_trace.c | 2 +-
>  cxl/event_trace.h | 3 ++-
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/cxl/event_trace.c b/cxl/event_trace.c
> index 93a95f9729fd..bdad0c19dbd4 100644
> --- a/cxl/event_trace.c
> +++ b/cxl/event_trace.c
> @@ -221,7 +221,7 @@ static int cxl_event_parse(struct tep_event *event, struct tep_record *record,
>  
>  	if (event_ctx->parse_event)
>  		return event_ctx->parse_event(event, record,
> -					      &event_ctx->jlist_head);
> +					      event_ctx->private_ctx);

Given ->parse_event() is already a method of an event_ctx object, might
as will pass the entirety of event_ctx to its own method as a typical
'this' pointer.

You could then also use container_of() to get to event_ctx creator data
and skip the type-unsafety of a 'void *' pointer. However, I say that
without having looked to see how feasible it is to wrap private data
around an event_ctx instance.
