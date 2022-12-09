Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 465A063C5
	for <nvdimm@lists.linux.dev>; Fri,  9 Dec 2022 17:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670606550; x=1702142550;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=T9ePHBbfndet6IJFOw3hqXLWdF7iDgwrNdxu3KHt15g=;
  b=b0w4FWy4Qj9iQjFtoaW1g+acritlt45edoP51ZcOaBTM9j+bDnXIs3iw
   t4yl5VKhBIKbnjxIHgUiG6vH/DmsUF9WvMwrN7tlYfNfd2kHXx5yeEebu
   zKQk51Q0uIyOTv6kH06gyUrgPQDMFGWMGcRKIqfSuGQ9+OJOHCYauX1rW
   RT/qLa7UXacbt//PhND/GnJxWnjnNtO3avKYwnJAjgGcKii36p0/vLIOD
   puCR4xKZhK9MTtHVedvvabMnvWvDg6SArX7VY3kSQl0RRGUsTQQ0xqb75
   ZeoFUY/R3RMexAd4Xemxvf3aZF0o0Dtn7BHr/4DlAG1rPgdENw18VjVOZ
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10556"; a="344544505"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="344544505"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2022 09:22:29 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10556"; a="789779049"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="789779049"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.212.227.125])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2022 09:22:29 -0800
Date: Fri, 9 Dec 2022 09:22:27 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-cxl@vger.kernel.org, vishal.l.verma@intel.com,
	nvdimm@lists.linux.dev
Subject: Re: [ndctl PATCH v2 04/18] ndctl/clang-format: Fix space after
 for_each macros
Message-ID: <Y5Nu0wD/6I29aUqN@aschofie-mobl2>
References: <167053487710.582963.17616889985000817682.stgit@dwillia2-xfh.jf.intel.com>
 <167053490140.582963.14276565576884840344.stgit@dwillia2-xfh.jf.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167053490140.582963.14276565576884840344.stgit@dwillia2-xfh.jf.intel.com>

On Thu, Dec 08, 2022 at 01:28:21PM -0800, Dan Williams wrote:
> Copy the approach taken in the kernel via:
> 
> commit 781121a7f6d1 ("clang-format: Fix space after for_each macros")

On a related note - 'cxl_mapping_foreach' seems to be missing from
.clang-format. Perhaps it is in another patch I haven't seen yet.

This patch -
Reviewed-by: Alison Schofield <alison.schofield@intel.com>

> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  .clang-format |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/.clang-format b/.clang-format
> index f372823c3248..448b7e7211ae 100644
> --- a/.clang-format
> +++ b/.clang-format
> @@ -1,6 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0
>  #
> -# clang-format configuration file. Intended for clang-format >= 6.
> +# clang-format configuration file. Intended for clang-format >= 11.
>  # Copied from Linux's .clang-format
>  #
>  # For more information, see:
> @@ -157,7 +157,7 @@ SpaceAfterTemplateKeyword: true
>  SpaceBeforeAssignmentOperators: true
>  SpaceBeforeCtorInitializerColon: true
>  SpaceBeforeInheritanceColon: true
> -SpaceBeforeParens: ControlStatements
> +SpaceBeforeParens: ControlStatementsExceptForEachMacros
>  SpaceBeforeRangeBasedForLoopColon: true
>  SpaceInEmptyParentheses: false
>  SpacesBeforeTrailingComments: 1
> 
