Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D50A92D
	for <nvdimm@lists.linux.dev>; Wed, 22 Feb 2023 21:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677101122; x=1708637122;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=FLdWA+I/1SISWmXX8/wzVnFQg7+7EZhCJpy6wqkg0A4=;
  b=EJsYDJQ3inRUWT8pNSf3OUrnwP2IrMx0wFJitjpynRZ0/Qi2l6YSbkTu
   QLXGpasiSGZdu0tITb7OtNzVPGS+RZz+TknMLZq2tvXwLwAuqjj3GKWwz
   LpFadGDR7Z2O+E1pP4s4dk5ndEnRPrqwAouTeMyhbZen8+liYt5gUYKal
   8HwgY4nC5JWH6buAlUeVBd1ymxXi0d7ZIBJxQoOVN7FS4bPoQAub5+kcz
   ieGa0k38xnLHu+jWNkvp00IcS9mIpdC/zimGXz5Td4kMVZHKHyPTEmhJM
   b2OeB1De80DkqsHJ+qdVoJ8s0q0RW6RzOjd0SCDb2eiz1cbRPUHaOsMDz
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10629"; a="419270045"
X-IronPort-AV: E=Sophos;i="5.97,319,1669104000"; 
   d="scan'208";a="419270045"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2023 13:25:22 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10629"; a="674249026"
X-IronPort-AV: E=Sophos;i="5.97,319,1669104000"; 
   d="scan'208";a="674249026"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.212.50.122]) ([10.212.50.122])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2023 13:25:21 -0800
Message-ID: <345cdc01-dbb2-fac9-ccfb-d18d50be375d@intel.com>
Date: Wed, 22 Feb 2023 14:25:21 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.6.0
Subject: Re: [PATCH ndctl] ndctl.spec.in: Add build dependencies for
 libtraceevent and libtracefs
Content-Language: en-US
To: Vishal Verma <vishal.l.verma@intel.com>, linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev
References: <20230222-fix-rpm-spec-v1-1-e6d8668ea421@intel.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20230222-fix-rpm-spec-v1-1-e6d8668ea421@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/22/23 1:20 PM, Vishal Verma wrote:
> The cxl-monitor additions pull in new dependencies on libtraceevent and
> libtracefs. While the commits below added these to the meson build
> system, they neglected to also update the RPM spec file. Add them to
> the spec.
> 
> Fixes: 8dedc6cf5e85 ("cxl: add a helper to parse trace events into a json object")
> Fixes: 7b237bc7a8ae ("cxl: add a helper to go through all current events and parse them")
> Cc: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>


> ---
>   ndctl.spec.in | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/ndctl.spec.in b/ndctl.spec.in
> index 35c63e6..0543c48 100644
> --- a/ndctl.spec.in
> +++ b/ndctl.spec.in
> @@ -31,6 +31,8 @@ BuildRequires:	keyutils-libs-devel
>   BuildRequires:	systemd-rpm-macros
>   BuildRequires:	iniparser-devel
>   BuildRequires:	meson
> +BuildRequires:	libtraceevent-devel
> +BuildRequires:	libtracefs-devel
>   
>   %description
>   Utility library for managing the "libnvdimm" subsystem.  The "libnvdimm"
> 
> ---
> base-commit: 835b09602cdcae8d324eeaf5bb4f17ae959c5e6d
> change-id: 20230222-fix-rpm-spec-2edf5a7fc25b
> 
> Best regards,
