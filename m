Return-Path: <SRS0=iZWN=XH=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA0C8C5ACAE
	for <linux-nvdimm@archiver.kernel.org>; Thu, 12 Sep 2019 03:53:23 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A0296214D8
	for <linux-nvdimm@archiver.kernel.org>; Thu, 12 Sep 2019 03:53:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A0296214D8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from [127.0.0.1] (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id B04E9202E2901;
	Wed, 11 Sep 2019 20:53:28 -0700 (PDT)
Received-SPF: Pass (sender SPF authorized) identity=mailfrom;
 client-ip=134.134.136.20; helo=mga02.intel.com;
 envelope-from=vishal.l.verma@intel.com; receiver=linux-nvdimm@lists.01.org 
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4D34A202C80B7
 for <linux-nvdimm@lists.01.org>; Wed, 11 Sep 2019 20:53:26 -0700 (PDT)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
 by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 11 Sep 2019 20:53:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,492,1559545200"; d="scan'208";a="268958277"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
 by orsmga001.jf.intel.com with ESMTP; 11 Sep 2019 20:53:20 -0700
Received: from fmsmsx117.amr.corp.intel.com (10.18.116.17) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 11 Sep 2019 20:52:50 -0700
Received: from fmsmsx113.amr.corp.intel.com ([169.254.13.68]) by
 fmsmsx117.amr.corp.intel.com ([169.254.3.133]) with mapi id 14.03.0439.000;
 Wed, 11 Sep 2019 20:52:50 -0700
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "joe@perches.com" <joe@perches.com>, "Williams, Dan J"
 <dan.j.williams@intel.com>, "Jiang, Dave" <dave.jiang@intel.com>, "Busch,
 Keith" <keith.busch@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [PATCH 11/13] nvdimm: Use more common logic testing styles and
 bare ; positions
Thread-Topic: [PATCH 11/13] nvdimm: Use more common logic testing styles and
 bare ; positions
Thread-Index: AQHVaRWKbif/DxojQEGXHgNOmHirzacn3kSA
Date: Thu, 12 Sep 2019 03:52:49 +0000
Message-ID: <706f6af6a6571a3bb2d35ec332fa572a990cbc48.camel@intel.com>
References: <cover.1568256705.git.joe@perches.com>
 <d6aa5b66936f2e0f132e893e10494aae6b74e886.1568256708.git.joe@perches.com>
In-Reply-To: <d6aa5b66936f2e0f132e893e10494aae6b74e886.1568256708.git.joe@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.30.5 (3.30.5-1.fc29) 
x-originating-ip: [10.254.21.217]
Content-ID: <9B343DDA310A65479EFFA2A81A767489@intel.com>
MIME-Version: 1.0
X-BeenThere: linux-nvdimm@lists.01.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>,
 "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>

On Wed, 2019-09-11 at 19:54 -0700, Joe Perches wrote:
> Avoid using uncommon logic testing styles to make the code a
> bit more like other kernel code.
> 
> e.g.:
> 	if (foo) {
> 		;
> 	} else {
> 		<code>
> 	}
> 
> is typically written
> 
> 	if (!foo) {
> 		<code>
> 	}
> 

A lot of times the excessive inversions seem to result in a net loss of
readability - e.g.:

<snip>

> diff --git a/drivers/nvdimm/region_devs.c
> b/drivers/nvdimm/region_devs.c
> index 65df07481909..6861e0997d21 100644
> --- a/drivers/nvdimm/region_devs.c
> +++ b/drivers/nvdimm/region_devs.c
> @@ -320,9 +320,7 @@ static ssize_t set_cookie_show(struct device *dev,
>  	struct nd_interleave_set *nd_set = nd_region->nd_set;
>  	ssize_t rc = 0;
>  
> -	if (is_memory(dev) && nd_set)
> -		/* pass, should be precluded by region_visible */;

For one, the comment is lost

> -	else
> +	if (!(is_memory(dev) && nd_set))

And it takes a moment to resolve between things such as:

	if (!(A && B))
	  vs.
	if (!(A) && B)

And this is especially true if 'A' and 'B' are longer function calls,
split over multiple lines, or are themselves compound 'sections'.

I'm not opposed to /all/ such transformations -- for example, the ones
where the logical inversion can be 'consumed' by toggling a comparision
operator, as you have a few times in this patch, don't sacrifice any
readibility, and perhaps even improve it. 

>  		return -ENXIO;
>  
>  	/*
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
