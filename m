Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 222EE168
	for <nvdimm@lists.linux.dev>; Wed,  5 Jan 2022 22:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641422552; x=1672958552;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pBPCdKRKFZm5tjwVZgt/5jpVd5HZycDSrA5Ak0dj/RU=;
  b=SuhcqbfJUTkcuJDv9ZsO60VvlpsN3cI2HtOensuqsdvd0Sr5GQGG2jwb
   MWRZfzbpE40eRCjnAHY1OXHXMXuDYQ34k8cxw7r3ydrnAjvUTVfB4YIET
   gK4fR2GCuyaN7tbfCmRBDh7N3kP4ETHRvLCdexBmZTjYAmHv/gacqg22S
   XNYqbidjOPotwzlFC+736InzNfRRNX/4odRRKnBeFv3nqzrn9HtFPXkr5
   R81QuFOfTlnot9XzeNPy2Mh2E++ipaVCN18B240tsSdPPRMEwg0VaWePd
   YosIezagGzVJhKrFbjoNWTdE41ku+toSz+CD/7VYPiHLEcMsCDL8+ZJS/
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="229872653"
X-IronPort-AV: E=Sophos;i="5.88,265,1635231600"; 
   d="scan'208";a="229872653"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 14:42:31 -0800
X-IronPort-AV: E=Sophos;i="5.88,265,1635231600"; 
   d="scan'208";a="526732509"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 14:42:31 -0800
Date: Wed, 5 Jan 2022 14:42:31 -0800
From: Ira Weiny <ira.weiny@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: nvdimm@lists.linux.dev, Dan Williams <dan.j.williams@intel.com>
Subject: Re: [ndctl PATCH] ndctl: add repology graphic to README.md
Message-ID: <20220105224231.GB95811@iweiny-DESK2.sc.intel.com>
Mail-Followup-To: Vishal Verma <vishal.l.verma@intel.com>,
	nvdimm@lists.linux.dev, Dan Williams <dan.j.williams@intel.com>
References: <20220105001823.299797-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220105001823.299797-1-vishal.l.verma@intel.com>
User-Agent: Mutt/1.11.1 (2018-12-01)

On Tue, Jan 04, 2022 at 05:18:23PM -0700, 'Vishal Verma' wrote:
> Add a graphic/badge from repology showing the packaging status of ndctl
> with various distros.
> 
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> ---
>  README.md | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/README.md b/README.md
> index 89dfc87..4ab4523 100644
> --- a/README.md
> +++ b/README.md
> @@ -4,6 +4,9 @@
>  Utility library for managing the libnvdimm (non-volatile memory device)
>  sub-system in the Linux kernel
>    
> +<a href="https://repology.org/project/ndctl/versions">
> +    <img src="https://repology.org/badge/vertical-allrepos/ndctl.svg" alt="Packaging status" align="right">
> +</a>
>  
>  Build
>  =====
> 
> base-commit: 57be068ef6aaf94c4d9ff0c06bd41a004e4ecf2c
> -- 
> 2.33.1
> 
> 
