Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EACE91FC8;
	Fri, 24 Jun 2022 03:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656041917; x=1687577917;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6fjM5CEJLI9NuNDC02gzwjelwB6yZ3iOyrgm5Ruo8X8=;
  b=lLhSUsAUlJtK/kuvtp1mnSpyxtxmz2oHGo2a0XN1f0vOe5oH+iPvufq+
   h7mHEwGNAUGfjN0AGabuZYBBdsTRNGeuCwlU68lj7Zi33QjBUzao0MIHt
   Ng2nKhxy1zfZioAVz483Gd6ky38V11mCxVfnCKy9Pb8MsHFafIdGQh555
   ALbcd6HU/K7jyUFrDeECOePq2OF/TXsovEmdtuCAE5EJES0ohNvnUL4xs
   9kBurAH8PiijE4qCPw21DmBjh3q87qzW970AojHqACg1YjI5VnronAHLn
   8mBk+4cfrSOz1D6ys9Moaj3XRuT4zT9C0f0eINXCYbldcU+ikHMJN84sQ
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10387"; a="279679722"
X-IronPort-AV: E=Sophos;i="5.92,217,1650956400"; 
   d="scan'208";a="279679722"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 20:38:36 -0700
X-IronPort-AV: E=Sophos;i="5.92,217,1650956400"; 
   d="scan'208";a="593031487"
Received: from alison-desk.jf.intel.com (HELO alison-desk) ([10.54.74.41])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 20:38:35 -0700
Date: Thu, 23 Jun 2022 20:37:59 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"hch@infradead.org" <hch@infradead.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH 02/46] cxl/port: Keep port->uport valid for the entire
 life of a port
Message-ID: <20220624033759.GA1558591@alison-desk>
References: <165603869943.551046.3498980330327696732.stgit@dwillia2-xfh>
 <165603871491.551046.6682199179541194356.stgit@dwillia2-xfh>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165603871491.551046.6682199179541194356.stgit@dwillia2-xfh>

On Thu, Jun 23, 2022 at 07:45:14PM -0700, Dan Williams wrote:
> The upcoming region provisioning implementation has a need to
> dereference port->uport during the port unregister flow. Specifically,
> endpoint decoders need to be able to lookup their corresponding memdev
> via port->uport.
> 
> The existing ->dead flag was added for cases where the core was
> committed to tearing down the port, but needed to drop locks before
> calling device_unregister(). Reuse that flag to indicate to
> delete_endpoint() that it has no "release action" work to do as
> unregister_port() will handle it.
> 
> Fixes: 8dd2bc0f8e02 ("cxl/mem: Add the cxl_mem driver")
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Alison Schofield <alison.schofield@intel.com>

> ---
>  drivers/cxl/core/port.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
> index dbce99bdffab..7810d1a8369b 100644
> --- a/drivers/cxl/core/port.c
> +++ b/drivers/cxl/core/port.c
> @@ -370,7 +370,7 @@ static void unregister_port(void *_port)
>  		lock_dev = &parent->dev;
>  
>  	device_lock_assert(lock_dev);
> -	port->uport = NULL;
> +	port->dead = true;
>  	device_unregister(&port->dev);
>  }
>  
> @@ -857,7 +857,7 @@ static void delete_endpoint(void *data)
>  	parent = &parent_port->dev;
>  
>  	device_lock(parent);
> -	if (parent->driver && endpoint->uport) {
> +	if (parent->driver && !endpoint->dead) {
>  		devm_release_action(parent, cxl_unlink_uport, endpoint);
>  		devm_release_action(parent, unregister_port, endpoint);
>  	}
> 
