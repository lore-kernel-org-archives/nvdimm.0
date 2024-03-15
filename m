Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C572D26B
	for <nvdimm@lists.linux.dev>; Fri, 15 Mar 2024 02:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710470184; cv=none; b=UfE9DppKCMWXMBgVBiU5mPli9RMrBmDZ4u9YDOD5/MFmNX4zwBKyYbmq8y5q8MkQfb0n0W+C82cWpY83P8nwsVrDYGMSpZSrJstoazQ6FvA2eMVre+22R/AnRyAWOF9Nq1zL3P7waqcArqBkR0LlZmWsSvI8/DIzI9O/8JaaACs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710470184; c=relaxed/simple;
	bh=Sm8qxJD8KM64f2yxuVlH6igjQVTmrCN8zTO5M6eWJ7w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S7vGTBWFcEo3D0RuFTVa/m95OhAXp3nZANQMast8VMKod+GsXzF66s0b+LtoYtnlIS/6/1Is/z+E0jbwwr0uSmT/c9AnNwfb5I6Ehbp77QRIhYK3zsF//OFBxUEKfjRXl+A+cPHBG42h49CVMCxTGIAv7WX7oPrWSQ8/ZfebINY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ix8Jvl2E; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ix8Jvl2E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710470182; x=1742006182;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=Sm8qxJD8KM64f2yxuVlH6igjQVTmrCN8zTO5M6eWJ7w=;
  b=ix8Jvl2Eb4V0eZyyS91oia817M4QXmeMWkLY87B9KGkjnTsTN1/2AWHd
   Hl6G7HTi3gblg5x2V6FrHuqh9uDtGr7P3MF3+hjL+XN9m8iR5g4ioKISC
   DP/lpMqRwIfXJRYN6EHaGZzx++5uvtTXV/SakZKuvVPvXSUgUADyGFvZj
   U0lKfQGnP0Q2uTacAbJxKzECGZX/KzL572D55YEQLewCkY/jNR5Ngrs49
   Ynii28S36qWzgQ9M9XndMStiIBqhic4BJBULKTftIisTyzuiV2SE22K0c
   fI1k9kgUf4L1O7cNll8Ia6z4XFkALsl6zROSF4yOfTn5N6GvywCvnZ55C
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11013"; a="5925051"
X-IronPort-AV: E=Sophos;i="6.07,127,1708416000"; 
   d="scan'208";a="5925051"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 19:36:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,127,1708416000"; 
   d="scan'208";a="12549626"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.209.72.214])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 19:36:22 -0700
Date: Thu, 14 Mar 2024 19:36:20 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Wonjae Lee <wj28.lee@samsung.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Hojin Nam <hj96.nam@samsung.com>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH v11 6/7] cxl/list: add --media-errors option to cxl
 list
Message-ID: <ZfO0JPhdY6dp+nnq@aschofie-mobl2>
References: <a6933ba82755391284368e4527154341bc4fd75f.1710386468.git.alison.schofield@intel.com>
 <cover.1710386468.git.alison.schofield@intel.com>
 <CGME20240314040548epcas2p3698bf9d1463a1d2255dc95ac506d3ae8@epcms2p4>
 <20240315010944epcms2p4de4dee2e69a2755aeab739152417d65b@epcms2p4>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240315010944epcms2p4de4dee2e69a2755aeab739152417d65b@epcms2p4>

On Fri, Mar 15, 2024 at 10:09:44AM +0900, Wonjae Lee wrote:
> alison.schofield@intel.com wrote:
> > From: Alison Schofield <alison.schofield@intel.com>
> >
> > The --media-errors option to 'cxl list' retrieves poison lists from
> > memory devices supporting the capability and displays the returned
> > media_error records in the cxl list json. This option can apply to
> > memdevs or regions.
> >
> > Include media-errors in the -vvv verbose option.
> >
> > Example usage in the Documentation/cxl/cxl-list.txt update.
> >
> > Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> > ---
> > Documentation/cxl/cxl-list.txt 62 +++++++++++++++++++++++++++++++++-
> > cxl/filter.h                    3 ++
> > cxl/list.c                      3 ++
> > 3 files changed, 67 insertions(+), 1 deletion(-)
> >
> > diff --git a/Documentation/cxl/cxl-list.txt b/Documentation/cxl/cxl-list.txt
> > index 838de4086678..6d3ef92c29e8 100644
> > --- a/Documentation/cxl/cxl-list.txt
> > +++ b/Documentation/cxl/cxl-list.txt
> 
> [snip]
> 
> +----
> +In the above example, region mappings can be found using:
> +"cxl list -p mem9 --decoders"
> +----
> 
> Hi, isn't it '-m mem9' instead of -p? FYI, it's also on patch's
> cover letter, too.

Thanks for the review! I went with -p because it gives only
the endpoint decoder while -m gives all the decoders up to
the root - more than needed to discover the region.

Here are the 2 outputs - what do you think?

# cxl list -p mem9 --decoders -u
{
  "decoder":"decoder20.0",
  "resource":"0xf110000000",
  "size":"2.00 GiB (2.15 GB)",
  "interleave_ways":2,
  "interleave_granularity":4096,
  "region":"region5",
  "dpa_resource":"0x40000000",
  "dpa_size":"1024.00 MiB (1073.74 MB)",
  "mode":"pmem"
}

# cxl list -m mem9 --decoders -u
[
  {
    "root decoders":[
      {
        "decoder":"decoder7.1",
        "resource":"0xf050000000",
        "size":"2.00 GiB (2.15 GB)",
        "interleave_ways":2,
        "interleave_granularity":4096,
        "max_available_extent":"2.00 GiB (2.15 GB)",
        "volatile_capable":true,
        "qos_class":42,
        "nr_targets":2
      },
      {
        "decoder":"decoder7.3",
        "resource":"0xf110000000",
        "size":"2.00 GiB (2.15 GB)",
        "interleave_ways":2,
        "interleave_granularity":4096,
        "max_available_extent":0,
        "pmem_capable":true,
        "qos_class":42,
        "nr_targets":2
      }
    ]
  },
  {
    "port decoders":[
      {
        "decoder":"decoder9.0",
        "resource":"0xf110000000",
        "size":"2.00 GiB (2.15 GB)",
        "interleave_ways":1,
        "region":"region5",
        "nr_targets":1
      },
      {
        "decoder":"decoder13.0",
        "resource":"0xf110000000",
        "size":"2.00 GiB (2.15 GB)",
        "interleave_ways":1,
        "region":"region5",
        "nr_targets":1
      }
    ]
  },
  {
    "endpoint decoders":[
      {
        "decoder":"decoder20.0",
        "resource":"0xf110000000",
        "size":"2.00 GiB (2.15 GB)",
        "interleave_ways":2,
        "interleave_granularity":4096,
        "region":"region5",
        "dpa_resource":"0x40000000",
        "dpa_size":"1024.00 MiB (1073.74 MB)",
        "mode":"pmem"
      }
    ]
  }
]

> 
> Thanks,
> Wonjae
