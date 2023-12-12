Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 959B265A75
	for <nvdimm@lists.linux.dev>; Tue, 12 Dec 2023 20:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ONGXFWqX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702414469; x=1733950469;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=uusJ9+8UuaGHMtZprTGk9r2x8iqdrvgsA6bry3ZX15o=;
  b=ONGXFWqXQyIwd+MoXL2lunv1oMv9+nF27r/g98SDylVgV6x0dolYQJjW
   xnidqGYFKls1PkY/B/4pzU5nzz9JDfhKB2GKhU3B5Eu+dpWurXV5VRmyB
   6sha5ZFDWDxoGGvYqIhzMuOimiF0mJOw+PWJ7S8ReOzVQL0oi1BcQK+uQ
   N7vM9GCZY+Sb3QifSxRpeAtR6bmUEICkRHPV6ZjxrmTvkgBiQhPnzGCR1
   xafzX4J7OByD6a8HgpB02LNo7cWo9GTW0avHjBsCacvysw/lhI7/N8GzN
   2ZMF3t4n98KNhQQSfDqKMdWfFPGcMg8kwfwNg3fS/Q9kDBwurjFr64lCf
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10922"; a="397653808"
X-IronPort-AV: E=Sophos;i="6.04,271,1695711600"; 
   d="scan'208";a="397653808"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2023 12:54:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10922"; a="917414797"
X-IronPort-AV: E=Sophos;i="6.04,271,1695711600"; 
   d="scan'208";a="917414797"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.209.111.12])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2023 12:54:28 -0800
Date: Tue, 12 Dec 2023 12:54:26 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Li Zhijian <lizhijian@fujitsu.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
	Dan Williams <dan.j.williams@intel.com>
Subject: Re: [ndctl PATCH v2 2/2] test/cxl-region-sysfs.sh: Fix
 cxl-region-sysfs.sh: line 107: [: missing `]'
Message-ID: <ZXjIgntHf4qptjwZ@aschofie-mobl2>
References: <20231212074228.1261164-1-lizhijian@fujitsu.com>
 <20231212074228.1261164-2-lizhijian@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231212074228.1261164-2-lizhijian@fujitsu.com>

On Tue, Dec 12, 2023 at 03:42:28PM +0800, Li Zhijian wrote:
> A space is missing before ']'

What's happens when that space is missing?
That's partly a request to add an impact statement, but also
for my education as I'm just learning all this shellcheck
stuff too.

BTW - if any of this was found using a tool, rather than
by inspection, please include a note of the tool used.

Thanks,
Alison

> 
> Acked-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
> ---
>  test/cxl-region-sysfs.sh | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/test/cxl-region-sysfs.sh b/test/cxl-region-sysfs.sh
> index 6a5da6d..db1a163 100644
> --- a/test/cxl-region-sysfs.sh
> +++ b/test/cxl-region-sysfs.sh
> @@ -104,7 +104,7 @@ do
>  	iw=$(cat /sys/bus/cxl/devices/$i/interleave_ways)
>  	ig=$(cat /sys/bus/cxl/devices/$i/interleave_granularity)
>  	[ $iw -ne $nr_targets ] && err "$LINENO: decoder: $i iw: $iw targets: $nr_targets"
> -	[ $ig -ne $r_ig] && err "$LINENO: decoder: $i ig: $ig root ig: $r_ig"
> +	[ $ig -ne $r_ig ] && err "$LINENO: decoder: $i ig: $ig root ig: $r_ig"
>  
>  	sz=$(cat /sys/bus/cxl/devices/$i/size)
>  	res=$(cat /sys/bus/cxl/devices/$i/start)
> -- 
> 2.41.0
> 
> 
