Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8619C63C5
	for <nvdimm@lists.linux.dev>; Fri,  9 Dec 2022 17:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670607204; x=1702143204;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/A3KsIMCe74beAVlMvCqaK1etpJOcbenQ1p54SYoeAI=;
  b=iBGZUJxDUTDIC2wXCRWMbsrBqN1Jk7TuqwkGON6Qb5ySjwIu+tKYKOjF
   nrjotjE8kQF4fGsHSQkbi506TzZrHThVhd8mI859WicfaSkFjpVXvXynK
   DnJNU6qZ9mPNrc2oLhyCEi/TkZgW4/+qrn1cTfb8+SN5NbyLgzKYfVCx7
   cuzRyN+XypRy8AS3CmQY9hA36TFlmUtokDJndaTaFhLsupExtFaL5YiNf
   G1hKrcZRtoBnK6fAkjWkau2cOesZ9E5l7brFUeGiMIUr+/MzNawFEqkrv
   YnFo9IEi9aJVt1qq6s1d6R0wMCHeEdXMblFyLdGFvPiseaQpipQBSLMPh
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10556"; a="316213925"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="316213925"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2022 09:33:23 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10556"; a="625180929"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="625180929"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.212.227.125])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2022 09:33:23 -0800
Date: Fri, 9 Dec 2022 09:33:22 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-cxl@vger.kernel.org, vishal.l.verma@intel.com,
	nvdimm@lists.linux.dev
Subject: Re: [ndctl PATCH v2 15/18] cxl/Documentation: Fix whitespace typos
 in create-region man page
Message-ID: <Y5NxYqD7Bgo2nT0W@aschofie-mobl2>
References: <167053487710.582963.17616889985000817682.stgit@dwillia2-xfh.jf.intel.com>
 <167053496662.582963.12739035781728195815.stgit@dwillia2-xfh.jf.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167053496662.582963.12739035781728195815.stgit@dwillia2-xfh.jf.intel.com>

On Thu, Dec 08, 2022 at 01:29:26PM -0800, Dan Williams wrote:

Missing SOB and commit log

The diff - 
Reviewed-by: Alison Schofield <alison.schofield@intel.com>

> 
> ---
>  Documentation/cxl/cxl-create-region.txt |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/cxl/cxl-create-region.txt b/Documentation/cxl/cxl-create-region.txt
> index 6b740d5b8d96..e0e6818cfdd1 100644
> --- a/Documentation/cxl/cxl-create-region.txt
> +++ b/Documentation/cxl/cxl-create-region.txt
> @@ -28,7 +28,7 @@ be emitted on stderr.
>  EXAMPLE
>  -------
>  ----
> -#cxl create - region - m - d decoder0 .1 - w 2 - g 1024 mem0 mem1
> +#cxl create-region -m -d decoder0.1 -w 2 -g 1024 mem0 mem1
>  {
>    "region":"region0",
>    "resource":"0xc90000000",
> 
