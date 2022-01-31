Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECFD62C80
	for <nvdimm@lists.linux.dev>; Mon, 31 Jan 2022 23:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643672863; x=1675208863;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=VTX+qg1zSqMYZJOMVnJMK11n6omzSFDS/8BFYIJOcI8=;
  b=ZpYajfXTYT411s2x5uWcaSV8IXx5+pPYDSYrSv/ytCnmaryLOMwnGd18
   lwB/3DkBwfw5AVs0LDi3KkbfgfNRfvUnfT2xA8R/odRd4Kb4dtkirXb6v
   1KJVcNZpgy0H9ARw5Rn5NUNyvLrUUEsNmCK7dKJmmNarC29EgMehcEyrF
   tvSh1P7n4Tjn1MyuHqHjUeia4oeg3407ADKXdbgXwkQBpFujcA1GNjRIr
   jzto2auAZgoo/PPqwvFIvNePY5xzngI38Y7nx8U6GPlR9lgQsmfty3AH6
   3y9V80RubGC3kaavub7MsH8KvTt2+bUnft3efNdz4zwhZVi+8b3NjiefG
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10244"; a="310886022"
X-IronPort-AV: E=Sophos;i="5.88,332,1635231600"; 
   d="scan'208";a="310886022"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 15:47:42 -0800
X-IronPort-AV: E=Sophos;i="5.88,332,1635231600"; 
   d="scan'208";a="675902526"
Received: from sssheth-mobl1.amr.corp.intel.com (HELO intel.com) ([10.252.130.247])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 15:47:41 -0800
Date: Mon, 31 Jan 2022 15:47:40 -0800
From: Ben Widawsky <ben.widawsky@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-cxl@vger.kernel.org, linux-pci@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: [PATCH v3 19/40] cxl/port: Up-level cxl_add_dport() locking
 requirements to the caller
Message-ID: <20220131234740.bzg63pqyf2wl3din@intel.com>
References: <164298411792.3018233.7493009997525360044.stgit@dwillia2-desk3.amr.corp.intel.com>
 <164298422000.3018233.4106867312927858722.stgit@dwillia2-desk3.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164298422000.3018233.4106867312927858722.stgit@dwillia2-desk3.amr.corp.intel.com>

On 22-01-23 16:30:20, Dan Williams wrote:
> In preparation for moving dport enumeration into the core, require the
> port device lock to be acquired by the caller.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/cxl/acpi.c            |    2 ++
>  drivers/cxl/core/port.c       |    3 +--
>  tools/testing/cxl/mock_acpi.c |    4 ++++
>  3 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
> index ab2b76532272..e596dc375267 100644
> --- a/drivers/cxl/acpi.c
> +++ b/drivers/cxl/acpi.c
> @@ -342,7 +342,9 @@ static int add_host_bridge_dport(struct device *match, void *arg)
>  		return 0;
>  	}
>  
> +	device_lock(&root_port->dev);
>  	rc = cxl_add_dport(root_port, match, uid, ctx.chbcr);
> +	device_unlock(&root_port->dev);
>  	if (rc) {
>  		dev_err(host, "failed to add downstream port: %s\n",
>  			dev_name(match));
> diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
> index ec9587e52423..c51a10154e29 100644
> --- a/drivers/cxl/core/port.c
> +++ b/drivers/cxl/core/port.c
> @@ -516,7 +516,7 @@ static int add_dport(struct cxl_port *port, struct cxl_dport *new)
>  {
>  	struct cxl_dport *dup;
>  
> -	cxl_device_lock(&port->dev);
> +	device_lock_assert(&port->dev);
>  	dup = find_dport(port, new->port_id);
>  	if (dup)
>  		dev_err(&port->dev,
> @@ -525,7 +525,6 @@ static int add_dport(struct cxl_port *port, struct cxl_dport *new)
>  			dev_name(dup->dport));
>  	else
>  		list_add_tail(&new->list, &port->dports);
> -	cxl_device_unlock(&port->dev);
>  
>  	return dup ? -EEXIST : 0;
>  }
> diff --git a/tools/testing/cxl/mock_acpi.c b/tools/testing/cxl/mock_acpi.c
> index 4c8a493ace56..667c032ccccf 100644
> --- a/tools/testing/cxl/mock_acpi.c
> +++ b/tools/testing/cxl/mock_acpi.c
> @@ -57,7 +57,9 @@ static int match_add_root_port(struct pci_dev *pdev, void *data)
>  
>  	/* TODO walk DVSEC to find component register base */
>  	port_num = FIELD_GET(PCI_EXP_LNKCAP_PN, lnkcap);
> +	device_lock(&port->dev);
>  	rc = cxl_add_dport(port, &pdev->dev, port_num, CXL_RESOURCE_NONE);
> +	device_unlock(&port->dev);
>  	if (rc) {
>  		dev_err(dev, "failed to add dport: %s (%d)\n",
>  			dev_name(&pdev->dev), rc);
> @@ -78,7 +80,9 @@ static int mock_add_root_port(struct platform_device *pdev, void *data)
>  	struct device *dev = ctx->dev;
>  	int rc;
>  
> +	device_lock(&port->dev);
>  	rc = cxl_add_dport(port, &pdev->dev, pdev->id, CXL_RESOURCE_NONE);
> +	device_unlock(&port->dev);
>  	if (rc) {
>  		dev_err(dev, "failed to add dport: %s (%d)\n",
>  			dev_name(&pdev->dev), rc);
> 

Since I really don't understand, perhaps an explanation as to why you aren't
using cxl_device_lock would help? (Is it just to get around not having a
cxl_device_lock_assert())?
