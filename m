Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AABAA461
	for <nvdimm@lists.linux.dev>; Mon, 28 Nov 2022 18:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669659640; x=1701195640;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NLDi8d0jli8L2v1N6DYnjREatDJezrYUfs6aH31bPc4=;
  b=HsxeeX9k+UW9cC3MXbcoX3ysiWSVQQP+Urhg8MNrhWCnr4Nt6kptJ+B9
   rvdprhncR9ozdNQQRjlUFLU+jOC1rT25Yh9I4XFDFTMVYt3cx3W3DQ5af
   hFxneVex9qiIuFVPwnzkRjknP70iMHBXKYoRaz3W9aIDJqZqRrnoAVRGJ
   da28x6idEWnd98MN5xaX9NHrlX6NBdpThtllWZMzgyD9MZEHEBYEkjh9i
   X9/7j7iedgYiLetc23U5C1iHotCXqNjwrW1i67q7DgKbLL97rvd4G39yJ
   MpLPldHsiWp4jSq3Ko+VV5Wy33LVf9kZ8ZzmYqi0p0mJvoZYYyFZhWD+l
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="377061560"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="377061560"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 10:20:39 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="712071276"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="712071276"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.209.3.241])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 10:20:39 -0800
Date: Mon, 28 Nov 2022 10:20:37 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-cxl@vger.kernel.org, rrichter@amd.com, terry.bowman@amd.com,
	bhelgaas@google.com, dave.jiang@intel.com, nvdimm@lists.linux.dev
Subject: Re: [PATCH v4 06/12] tools/testing/cxl: Make mock CEDT parsing more
 robust
Message-ID: <Y4T79QhJR2WzwEgY@aschofie-mobl2>
References: <166931487492.2104015.15204324083515120776.stgit@dwillia2-xfh.jf.intel.com>
 <166931491054.2104015.16722069708509650823.stgit@dwillia2-xfh.jf.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166931491054.2104015.16722069708509650823.stgit@dwillia2-xfh.jf.intel.com>

On Thu, Nov 24, 2022 at 10:35:10AM -0800, Dan Williams wrote:
> Accept any cxl_test topology device as the first argument in
> cxl_chbs_context. This is in preparation for reworking the detection of
> the component registers across VH and RCH topologies. Move
> mock_acpi_table_parse_cedt() beneath the definition of is_mock_port()
> and use is_mock_port() instead of the explicit mock cxl_acpi device
> check.

I'll ACK this change, alhtough I don't appreciate the code move and modify
in the same patch. It hides the diff.

The commit msg seems needlessly vague. Why not state what was done?
Something like: 'Accept any topology device in cxl_chbs_context'

> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  tools/testing/cxl/test/cxl.c |   80 +++++++++++++++++++++---------------------
>  1 file changed, 40 insertions(+), 40 deletions(-)
> 
> diff --git a/tools/testing/cxl/test/cxl.c b/tools/testing/cxl/test/cxl.c
> index facfcd11cb67..42a34650dd2f 100644
> --- a/tools/testing/cxl/test/cxl.c
> +++ b/tools/testing/cxl/test/cxl.c
> @@ -320,46 +320,6 @@ static int populate_cedt(void)
>  	return 0;
>  }
>  
> -/*
> - * WARNING, this hack assumes the format of 'struct
> - * cxl_cfmws_context' and 'struct cxl_chbs_context' share the property that
> - * the first struct member is the device being probed by the cxl_acpi
> - * driver.
> - */
> -struct cxl_cedt_context {
> -	struct device *dev;
> -};
> -
> -static int mock_acpi_table_parse_cedt(enum acpi_cedt_type id,
> -				      acpi_tbl_entry_handler_arg handler_arg,
> -				      void *arg)
> -{
> -	struct cxl_cedt_context *ctx = arg;
> -	struct device *dev = ctx->dev;
> -	union acpi_subtable_headers *h;
> -	unsigned long end;
> -	int i;
> -
> -	if (dev != &cxl_acpi->dev)
> -		return acpi_table_parse_cedt(id, handler_arg, arg);
> -
> -	if (id == ACPI_CEDT_TYPE_CHBS)
> -		for (i = 0; i < ARRAY_SIZE(mock_cedt.chbs); i++) {
> -			h = (union acpi_subtable_headers *)&mock_cedt.chbs[i];
> -			end = (unsigned long)&mock_cedt.chbs[i + 1];
> -			handler_arg(h, arg, end);
> -		}
> -
> -	if (id == ACPI_CEDT_TYPE_CFMWS)
> -		for (i = 0; i < ARRAY_SIZE(mock_cfmws); i++) {
> -			h = (union acpi_subtable_headers *) mock_cfmws[i];
> -			end = (unsigned long) h + mock_cfmws[i]->header.length;
> -			handler_arg(h, arg, end);
> -		}
> -
> -	return 0;
> -}
> -
>  static bool is_mock_bridge(struct device *dev)
>  {
>  	int i;
> @@ -410,6 +370,46 @@ static bool is_mock_port(struct device *dev)
>  	return false;
>  }
>  
> +/*
> + * WARNING, this hack assumes the format of 'struct cxl_cfmws_context'
> + * and 'struct cxl_chbs_context' share the property that the first
> + * struct member is cxl_test device being probed by the cxl_acpi
> + * driver.
> + */
> +struct cxl_cedt_context {
> +	struct device *dev;
> +};
> +
> +static int mock_acpi_table_parse_cedt(enum acpi_cedt_type id,
> +				      acpi_tbl_entry_handler_arg handler_arg,
> +				      void *arg)
> +{
> +	struct cxl_cedt_context *ctx = arg;
> +	struct device *dev = ctx->dev;
> +	union acpi_subtable_headers *h;
> +	unsigned long end;
> +	int i;
> +
> +	if (!is_mock_port(dev) && !is_mock_dev(dev))
> +		return acpi_table_parse_cedt(id, handler_arg, arg);
> +
> +	if (id == ACPI_CEDT_TYPE_CHBS)
> +		for (i = 0; i < ARRAY_SIZE(mock_cedt.chbs); i++) {
> +			h = (union acpi_subtable_headers *)&mock_cedt.chbs[i];
> +			end = (unsigned long)&mock_cedt.chbs[i + 1];
> +			handler_arg(h, arg, end);
> +		}
> +
> +	if (id == ACPI_CEDT_TYPE_CFMWS)
> +		for (i = 0; i < ARRAY_SIZE(mock_cfmws); i++) {
> +			h = (union acpi_subtable_headers *) mock_cfmws[i];
> +			end = (unsigned long) h + mock_cfmws[i]->header.length;
> +			handler_arg(h, arg, end);
> +		}
> +
> +	return 0;
> +}
> +
>  static int host_bridge_index(struct acpi_device *adev)
>  {
>  	return adev - host_bridge;
> 
