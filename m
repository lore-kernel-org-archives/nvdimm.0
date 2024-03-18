Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C861B55764
	for <nvdimm@lists.linux.dev>; Mon, 18 Mar 2024 17:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710782243; cv=none; b=Or3X58udcFfLFg5KLftWlLT0aKvUHrny98DvSFg/jbD3vqPLNtXAoa1cNTcghKDAIopyRtoQRbZiK+SeRWjhosdvqksQmr0Eh87DdSY4YCPLizjj7rJnj5mXLfnOWAX3QGSn9UMgtFKSH6oFJUtRJwjIk8Ux4bk9NCCzC78WwMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710782243; c=relaxed/simple;
	bh=tsZ3c1RkA/NY35bOtFG5KWzLfBHYEABoJhDbELPd2Eg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nGMEuBd/LJJVLMARA5vi4GnaG2u7+ss1QBJlfaOQZVB/0npj2g0G8S26NJXKc7Li3cMsnkFJ7UUhL9mw8yJj3Qz+EYZteG6YM5jmTNQ3RJqAiCthmQoX0GkYmfvWcbo5+tlB8juzwnWpVVWb4l3qJZeAniyjnKZwxAFLfI/Qa3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kXyTqW22; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kXyTqW22"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710782242; x=1742318242;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=tsZ3c1RkA/NY35bOtFG5KWzLfBHYEABoJhDbELPd2Eg=;
  b=kXyTqW22jpc11oCcW8gxNY2Bm9WU2XIF1+Z19zf+OSsXXRY+uVQnyOJh
   7JXjMsM/VfCOTLCwCs25SeRRQmy7dOVGE5j8c0171zj/DA76nGVWwUa06
   fx+nPv9Xjn7VgpmCEuqH2CumAF2gejDYBP31ODYDHVXeY57pdJzPmrKc5
   /wQjMApX01mUAdCw6alLcCkTeRs61i41J3yYYrIvPxUjO1xV1+ZPuq6k3
   FrOcPysOmNHDjy2x0oQNPeBoNNiqrthSp5xi+6q7T5uvAlQHKQMM+Juby
   JeNPaPrRgpetbpBzoFp8dou8kGnRWJilV1WyXUvN5Xd5rBlzDuo3lHPh3
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11017"; a="5544079"
X-IronPort-AV: E=Sophos;i="6.07,134,1708416000"; 
   d="scan'208";a="5544079"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2024 10:17:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,134,1708416000"; 
   d="scan'208";a="18203985"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.209.83.98])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2024 10:17:21 -0700
Date: Mon, 18 Mar 2024 10:17:19 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Wonjae Lee <wj28.lee@samsung.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Hojin Nam <hj96.nam@samsung.com>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH v11 7/7] cxl/test: add cxl-poison.sh unit test
Message-ID: <Zfh3H6CV/OIHOe05@aschofie-mobl2>
References: <24c1f2ec413f92e8e6e8817b3d4d55f5bb142849.1710386468.git.alison.schofield@intel.com>
 <cover.1710386468.git.alison.schofield@intel.com>
 <CGME20240314040551epcas2p40829b16b09f439519a692070fb460242@epcms2p1>
 <20240315230334epcms2p1d92e47ec32b59ffbb186a0204f9b0866@epcms2p1>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240315230334epcms2p1d92e47ec32b59ffbb186a0204f9b0866@epcms2p1>

On Sat, Mar 16, 2024 at 08:03:34AM +0900, Wonjae Lee wrote:
> alison.schofield@intel.com wrote:
> > From: Alison Schofield <alison.schofield@intel.com>
> >
> > Exercise cxl list, libcxl, and driver pieces of the get poison list
> > pathway. Inject and clear poison using debugfs and use cxl-cli to
> > read the poison list by memdev and by region.
> >
> > Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> > ---
> > test/cxl-poison.sh 137 +++++++++++++++++++++++++++++++++++++++++++++
> > test/meson.build    2 +
> > 2 files changed, 139 insertions(+)
> > create mode 100644 test/cxl-poison.sh
> >
> > diff --git a/test/cxl-poison.sh b/test/cxl-poison.sh
> > new file mode 100644
> > index 000000000000..af2e9dcd1a11
> > --- /dev/null
> > +++ b/test/cxl-poison.sh
> 
> [snip]
> 
> > +# Turn tracing on. Note that 'cxl list --poison' does toggle the tracing.
> 
> Hi,
> 
> I know it's trivial and not sure if I'm understanding the history of
> the patch series correctly, but --poison seems to be an option that
> was suggested before --media-errors. I'm wondering if it's okay to
> leave this comment.

Thanks Wonjae - I appreciate your find. I'll fix it up.
Alison

> 
> Thanks,
> Wonjae
