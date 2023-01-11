Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44ED17EA
	for <nvdimm@lists.linux.dev>; Wed, 11 Jan 2023 22:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673477549; x=1705013549;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0+miRoWk1/XBQzLnm9tE5na0Pmf8+9CnqdL7nH6BRZk=;
  b=UfulRVMvcRmt+X9zkfD6f+ceOsJ6vRxs0Kp911F95ZSEdLrVNiegMZU2
   /6YwlASnEFFcJPm8NkmVfZx/YoNAbeeDG0bhijqtHgvBKsBS3TKfHeZMQ
   lR6iGCPeVuoCndCnl391abCb01QErVtnxahvtMsuwbpVtA8xFFmSp/0lJ
   97dt4KW0SHJx21cdx1qsjstjCNaHW8wxG4tcY6wSORJ/9aekXeSiOvwc0
   21TmPW7pgQcz99K9BhkgP5c0shpAK/JcX9xqRCvk3gmkkKpztdwu9XsXv
   bgO61scRIVPyPZL+b/WF8XhFctloQ0PREKmhW2uv9sAArX0e8QV6g9JO5
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="385871843"
X-IronPort-AV: E=Sophos;i="5.96,318,1665471600"; 
   d="scan'208";a="385871843"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2023 14:52:29 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="799993332"
X-IronPort-AV: E=Sophos;i="5.96,318,1665471600"; 
   d="scan'208";a="799993332"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.212.147.120])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2023 14:52:28 -0800
Date: Wed, 11 Jan 2023 14:52:26 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	Dave Jiang <dave.jiang@intel.com>,
	Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH ndctl 2/4] cxl/region: fix a resource leak in to_csv()
Message-ID: <Y789qoHN9jkSAdTW@aschofie-mobl2>
References: <20230110-vv-coverity-fixes-v1-0-c7ee6c76b200@intel.com>
 <20230110-vv-coverity-fixes-v1-2-c7ee6c76b200@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230110-vv-coverity-fixes-v1-2-c7ee6c76b200@intel.com>

On Tue, Jan 10, 2023 at 04:09:15PM -0700, Vishal Verma wrote:
> Static analysis reports there can be a memory leak in to_csv as an exit
> path returns from the function before freeing 'csv'. Since this is the
> only errpr path exit point after the allocation, just free() before
> returning.
> 
> Fixes: 3d6cd829ec08 ("cxl/region: Use cxl_filter_walk() to gather create-region targets")
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Reviewed-by: Alison Schofield <alison.schofield@intel.com>


> ---
>  cxl/region.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/cxl/region.c b/cxl/region.c
> index bb3a10a..9a81113 100644
> --- a/cxl/region.c
> +++ b/cxl/region.c
> @@ -146,8 +146,10 @@ static const char *to_csv(int *count, const char **strings)
>  		return NULL;
>  	for (i = 0; i < *count; i++) {
>  		list = strdup(strings[i]);
> -		if (!list)
> +		if (!list) {
> +			free(csv);
>  			return NULL;
> +		}
>  
>  		for (arg = strtok_r(list, which_sep(list), &save); arg;
>  		     arg = strtok_r(NULL, which_sep(list), &save)) {
> 
> -- 
> 2.39.0
