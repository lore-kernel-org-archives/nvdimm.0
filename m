Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C29A92A
	for <nvdimm@lists.linux.dev>; Wed, 11 Jan 2023 22:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673477660; x=1705013660;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5uBLHB9cbk7mSKEFflbdc2SuHGQr8PDUw+lPftxj7q4=;
  b=hm/ouNnwm5KiK9E+juz3ioiRGxQnvclS0am+UHDmlgn7hmNyPg0g5XPr
   lKTLzzOBQ5SjOm4KJMj+dQz3Vo6CuoIaB9smyXfm7uhL/+h4VTP4bD08j
   t6UeE6TAC8QDNDE4Op9tIxbvwaPfU9QTRN4VFvvf25F2f6DlxDZ/NpUw9
   wPKSENREqNRK8x2yOjMYg8U7vumiIiWFMbFwKvxzesMWJ/TLGyxvKffz3
   /qMJMfQUn3s6ryCWUb54ThPd5YqIKUf9znRxeGIbXR7DjYynehYxAF5vA
   5EIw5ZWzg1p90d9upqnetqrmPxjX34K/AnQ/YSTRt/JVe8ao59UOThMHv
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="307079407"
X-IronPort-AV: E=Sophos;i="5.96,318,1665471600"; 
   d="scan'208";a="307079407"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2023 14:54:20 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="659551847"
X-IronPort-AV: E=Sophos;i="5.96,318,1665471600"; 
   d="scan'208";a="659551847"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.212.147.120])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2023 14:54:17 -0800
Date: Wed, 11 Jan 2023 14:54:15 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	Dave Jiang <dave.jiang@intel.com>,
	Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH ndctl 4/4] cxl/region: fix a comment typo
Message-ID: <Y78+F14RdTGaPQP4@aschofie-mobl2>
References: <20230110-vv-coverity-fixes-v1-0-c7ee6c76b200@intel.com>
 <20230110-vv-coverity-fixes-v1-4-c7ee6c76b200@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230110-vv-coverity-fixes-v1-4-c7ee6c76b200@intel.com>

On Tue, Jan 10, 2023 at 04:09:17PM -0700, Vishal Verma wrote:
> Fix a typo: s/separted/separated/
> 
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Reviewed-by: Alison Schofield <alison.schofield@intel.com>

> ---
>  cxl/region.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/cxl/region.c b/cxl/region.c
> index 89be9b5..efe05aa 100644
> --- a/cxl/region.c
> +++ b/cxl/region.c
> @@ -103,7 +103,7 @@ static const struct option destroy_options[] = {
>  
>  /*
>   * Convert an array of strings that can be a mixture of single items, a
> - * command separted list, or a space separated list, into a flattened
> + * command separated list, or a space separated list, into a flattened
>   * comma-separated string. That single string can then be used as a
>   * filter argument to cxl_filter_walk(), or an ordering constraint for
>   * json_object_array_sort()
> 
> -- 
> 2.39.0
