Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149FE376
	for <nvdimm@lists.linux.dev>; Wed,  7 Dec 2022 01:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670375558; x=1701911558;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=tTDolpY4Ce7RQrse+cbawkAa49rrImTGPAZ8Jd/hQ4E=;
  b=XWuLvbzwyhE3J/7FXhKJ3jByUGp3017b0Raixz8iiIi2Xqu1IRmvs1fe
   r0lLP9+IJPTe0lNJ2tURIzM4HJaqYEFYs7gayEreZ+VO3WVFGdsXtMuUq
   kGyXWH6q4dZnSLcK6+OtZwu4vzR1Hjv9UvTVlLQV7IJ2adaQIQimNaizw
   ADcMau/Z3LpLm3fl3ku236nZ4oa/CAFzw+B4kSLg6WX0ZHvVwypxlxI8g
   W2EZm/t3gIexuI7ev00Ims92aYz99HXnXr5gt9G/XZJDHnDt0Q0y9gwD+
   69UIAZY+TCv+UGmIf0q+e9hW5at9IYHryDAKduDpVbY2jIuEYBDBf4xTu
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10553"; a="317916738"
X-IronPort-AV: E=Sophos;i="5.96,223,1665471600"; 
   d="scan'208";a="317916738"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2022 17:12:36 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10553"; a="709877452"
X-IronPort-AV: E=Sophos;i="5.96,223,1665471600"; 
   d="scan'208";a="709877452"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.209.118.190])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2022 17:12:35 -0800
Date: Tue, 6 Dec 2022 17:12:33 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: nvdimm@lists.linux.dev, Dan Williams <dan.j.williams@intel.com>,
	linux-cxl@vger.kernel.org
Subject: Re: [PATCH ndctl 1/2] clang-format: Align consecutive macros and
 #defines
Message-ID: <Y4/ogRA0SybTSQ0p@aschofie-mobl2>
References: <20221206-vv-misc-v1-0-4c5bd58c90ca@intel.com>
 <20221206-vv-misc-v1-1-4c5bd58c90ca@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206-vv-misc-v1-1-4c5bd58c90ca@intel.com>

On Tue, Dec 06, 2022 at 03:46:23PM -0700, Vishal Verma wrote:
> Add AlignConsecutiveMacros: true so that blocks of consecutive #defines
> can be neatly aligned.
> 
> Cc: Dan Williams <dan.j.williams@intel.com>
> Reported-by: Alison Schofield <alison.schofield@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---

Thanks Vishal!
Reviewed-by: Alison Schofield <alison.schofield@intel.com>


>  .clang-format | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/.clang-format b/.clang-format
> index b6169e1..9ea49bf 100644
> --- a/.clang-format
> +++ b/.clang-format
> @@ -13,6 +13,7 @@ AccessModifierOffset: -4
>  AlignAfterOpenBracket: Align
>  AlignConsecutiveAssignments: false
>  AlignConsecutiveDeclarations: false
> +AlignConsecutiveMacros: true
>  #AlignEscapedNewlines: Left # Unknown to clang-format-4.0
>  AlignOperands: true
>  AlignTrailingComments: false
> 
> -- 
> 2.38.1
