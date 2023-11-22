Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C8D5E0BC
	for <nvdimm@lists.linux.dev>; Wed, 22 Nov 2023 19:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WYJjUrZ8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700681933; x=1732217933;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3ba4BV9/y7lLHWtaWLnBmV2Ql1F46iegua2DKW3jtdE=;
  b=WYJjUrZ8BJYTY+Vhzau7vK1USdtiyaAEDRm34wGNU8csxC/vM9gC9gdT
   3u7pc78D7mgJ1DO8TxT3Aj2UNtwX72moaWL0EtUjYZcvcJR0aNJbOWjvm
   sU5PCCSKhR5sO9O28wt8t+7e+aWw6YyoR7vvp3WUpCUt2whiOBIec14xM
   /mJ9D7GKTZdfo7jhlyMCWMg4+Hu7hSySyhDh6bIVPyG8JAru/n4kXvo9i
   dfut16YdOhxJPsEv5YqWSDI6OPnNZizqVWElfEV/2RPWIbr2mLUiT2kzW
   cFkmC445y4q17ZsyAtlk5g78rXjQ0rIAlOVUM8T9PLrGybhanlfyb++Fc
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10902"; a="396049286"
X-IronPort-AV: E=Sophos;i="6.04,219,1695711600"; 
   d="scan'208";a="396049286"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2023 11:38:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10902"; a="760459262"
X-IronPort-AV: E=Sophos;i="6.04,219,1695711600"; 
   d="scan'208";a="760459262"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.209.4.129])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2023 11:38:52 -0800
Date: Wed, 22 Nov 2023 11:38:50 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH] cxl/test: replace a bad root decoder usage in
 cxl-xor-region.sh
Message-ID: <ZV5YyhveHLovpyIV@aschofie-mobl2>
References: <20231122025753.1209527-1-alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231122025753.1209527-1-alison.schofield@intel.com>

On Tue, Nov 21, 2023 at 06:57:53PM -0800, alison.schofield@intel.com wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> The 4-way XOR region as defined in this test uses a root decoder that
> is created using an improperly defined CFMWS. The problem with the
> CFMWS is that Host Bridges repeat in the target list like this:
> { 0, 1, 0, 1 }.
> 
> Stop using that root decoder and create a 4-way XOR region using an
> x2 root decoder that supports XOR arithmetic.
> 
> The test passes prior to this patch but there is an interleave check [1]
> introduced in the CXL region driver that will expose the bad interleave
> this test creates via dev_dbg() messages like this:
> 
> [ ] cxl_core:cxl_region_attach:1808: cxl decoder17.0: Test cxl_calc_interleave_pos(): fail test_pos:4 cxled->pos:2
> [ ] cxl_core:cxl_region_attach:1808: cxl decoder18.0: Test cxl_calc_interleave_pos(): fail test_pos:5 cxled->pos:3
> 
> Note that the CFMWS's are defined in the kernel cxl-test module, so a
> kernel patch removing the bad CFMWS will also need to be merged, but
> that cleanup can follow this patch. Also note that the bad CFMWS is not
> used in the default cxl-test environment. It is only visible when the
> cxl-test module is loaded using the param interleave_arithmetic=1. It is
> a special config that provides the XOR math CFMWS's for this test.
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a3e00c964fb943934af916f48f0dd43b5110c866
> 


Fixes: 05486f8bf154 ("cxl/test: add cxl_xor_region test")


> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---
> 
> Vishal - I'm hoping you will merge this in ndctl v79 even though the
> exposure with the kernel doesn't happen until kernel 6.7. This way
> users of cxl-test are not learning to ignore the interleave calc
> warnings.
> 
> Also, hopefully I have not introduced any new shell issues, but
> I know this unit test has existing warnings. Can we do a shell
> cleanup in a follow-on patchset across the CXL tests?
> (and not last minute for your ndctl release)
> 
> 
>  test/cxl-xor-region.sh | 14 +++++---------
>  1 file changed, 5 insertions(+), 9 deletions(-)
> 

snip

> 
