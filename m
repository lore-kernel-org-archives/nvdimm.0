Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F593A8FE
	for <nvdimm@lists.linux.dev>; Mon, 27 Nov 2023 18:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dhSlfABh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 105E4C433C7;
	Mon, 27 Nov 2023 18:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701108472;
	bh=VmWltUnQ033NBruTeO5YsP0tKYa2s0map218WBSqCck=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dhSlfABhtkyEQMnHNILIKU+Tv/uGqkBBAZtkHOEJH779dqR3UXKXi6sZvwlg+fWcC
	 uuoKOVrkq8GXDMs4ksCSZufx7d6vmP99Mt3d38/Py2JuAumIdauHYUJsHjWDIso2mS
	 wLZUAQ2DfU/EFzhFCZt+eK5xKb4Obg1vgW+9ExO8=
Date: Mon, 27 Nov 2023 18:07:49 +0000
From: Greg KH <gregkh@linuxfoundation.org>
To: Dave Jiang <dave.jiang@intel.com>
Cc: Yi Zhang <yi.zhang@redhat.com>, nvdimm@lists.linux.dev,
	dan.j.williams@intel.com, vishal.l.verma@intel.com,
	ira.weiny@intel.com
Subject: Re: [PATCH] ndtest: fix typo class_regster -> class_register
Message-ID: <2023112729-aids-drainable-5744@gregkh>
References: <20231127040026.362729-1-yi.zhang@redhat.com>
 <8d6fd371-e664-47ab-b8fe-c7d8d0137b4a@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d6fd371-e664-47ab-b8fe-c7d8d0137b4a@intel.com>

On Mon, Nov 27, 2023 at 10:00:14AM -0700, Dave Jiang wrote:
> 
> 
> On 11/26/23 21:00, Yi Zhang wrote:
> > Fixes: dd6cad2dcb58 ("testing: nvdimm: make struct class structures constant")
> > Signed-off-by: Yi Zhang <yi.zhang@redhat.com>
> 
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> > ---
> >  tools/testing/nvdimm/test/ndtest.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/tools/testing/nvdimm/test/ndtest.c b/tools/testing/nvdimm/test/ndtest.c
> > index fd26189d53be..b8419f460368 100644
> > --- a/tools/testing/nvdimm/test/ndtest.c
> > +++ b/tools/testing/nvdimm/test/ndtest.c
> > @@ -924,7 +924,7 @@ static __init int ndtest_init(void)
> >  
> >  	nfit_test_setup(ndtest_resource_lookup, NULL);
> >  
> > -	rc = class_regster(&ndtest_dimm_class);
> > +	rc = class_register(&ndtest_dimm_class);
> >  	if (rc)
> >  		goto err_register;
> >  

Ick, sorry about that, obviously this test isn't actually built by any
bots :(

I'll go queue this up now,

greg k-h
