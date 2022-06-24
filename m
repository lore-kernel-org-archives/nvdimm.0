Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 350071FC8;
	Fri, 24 Jun 2022 03:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656042550; x=1687578550;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2jvWXqxqmaqnQRPpCuIEFxUoHlta7PtltN07dgU7hUc=;
  b=gVoeOV4Rp4Ves7Wa+S9FzR9YTAskEUCnHanCPFFUoj15BRYfcZgmLWtk
   mTzxWxwjMLuemmf38UMoR6nOZn5bxavdIIyuKvAhxtIRaTDiBXex2SQWE
   A4MH3WMDJytZVbnxiYHpkEWZTNASbAhw93nGkmvVaSpgyBjsbfWjr5b12
   Hs2fucEJxL6qRFoYbisCMJQc31wYZ5ST99rhOqzB+hKagvzPjIc/6VG+J
   nVhepxU+wKYR1+EFJveRsjb+0fRcI21DZ29oNmmNhFaxfH7mN/rBkJRib
   2vaay9heDGt7PWNEyL7Li4ZnCB/NYERWGF3TlbA4EUfaPNEh+sxq3gVii
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10387"; a="263951820"
X-IronPort-AV: E=Sophos;i="5.92,217,1650956400"; 
   d="scan'208";a="263951820"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 20:49:09 -0700
X-IronPort-AV: E=Sophos;i="5.92,217,1650956400"; 
   d="scan'208";a="645083534"
Received: from alison-desk.jf.intel.com (HELO alison-desk) ([10.54.74.41])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 20:49:09 -0700
Date: Thu, 23 Jun 2022 20:48:33 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"hch@infradead.org" <hch@infradead.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH 06/46] cxl/core: Drop is_cxl_decoder()
Message-ID: <20220624034833.GD1558591@alison-desk>
References: <165603869943.551046.3498980330327696732.stgit@dwillia2-xfh>
 <165603874340.551046.15491766127759244728.stgit@dwillia2-xfh>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165603874340.551046.15491766127759244728.stgit@dwillia2-xfh>

On Thu, Jun 23, 2022 at 07:45:43PM -0700, Dan Williams wrote:
> This helper was only used to identify the object type for lockdep
> purposes. Now that lockdep support is done with explicit lock classes,
> this helper can be dropped.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Alison Schofield <alison.schofield@intel.com>

> ---
>  drivers/cxl/core/port.c |    6 ------
>  drivers/cxl/cxl.h       |    1 -
>  2 files changed, 7 deletions(-)
> 
> diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
> index b51eb41aa839..13c321afe076 100644
> --- a/drivers/cxl/core/port.c
> +++ b/drivers/cxl/core/port.c
> @@ -271,12 +271,6 @@ bool is_root_decoder(struct device *dev)
>  }
>  EXPORT_SYMBOL_NS_GPL(is_root_decoder, CXL);
>  
> -bool is_cxl_decoder(struct device *dev)
> -{
> -	return dev->type && dev->type->release == cxl_decoder_release;
> -}
> -EXPORT_SYMBOL_NS_GPL(is_cxl_decoder, CXL);
> -
>  struct cxl_decoder *to_cxl_decoder(struct device *dev)
>  {
>  	if (dev_WARN_ONCE(dev, dev->type->release != cxl_decoder_release,
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index 35ce17872fc1..6e08fe8cc0fe 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -337,7 +337,6 @@ struct cxl_dport *cxl_find_dport_by_dev(struct cxl_port *port,
>  struct cxl_decoder *to_cxl_decoder(struct device *dev);
>  bool is_root_decoder(struct device *dev);
>  bool is_endpoint_decoder(struct device *dev);
> -bool is_cxl_decoder(struct device *dev);
>  struct cxl_decoder *cxl_root_decoder_alloc(struct cxl_port *port,
>  					   unsigned int nr_targets);
>  struct cxl_decoder *cxl_switch_decoder_alloc(struct cxl_port *port,
> 
