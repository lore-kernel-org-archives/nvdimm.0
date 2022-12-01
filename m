Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A5B10782
	for <nvdimm@lists.linux.dev>; Thu,  1 Dec 2022 21:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669931851; x=1701467851;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=YuLGJY/W/2CbAUBIRBk7hrWz1SyxVSdB4NS2xcnKGoo=;
  b=ewjLvGk1q0Ca4c/28RD+Z3ETLbPmoaZaA27MzZY46GCNL5aQ+JJmyw0m
   vW5hpYomrWp3y0+EWQO2ASRNUzA1X3EO45PttjeTU7u8TkconjGTJXbkK
   WXJsXHZfJUWMGgC68UkWSNdc01LM+/InP5igBq1DfGSKa4h3BqCv2q8dd
   FkbZf8kWTyXMs6zfRq4AZU8OEKsHyoG0yt2GN4K0AOq56vW5E/fgE0dcC
   GOKyz64ZRVnG+NAG03ACz9BF9Xsl4p9iT/NFPGT4+KqLjcFvPDSwfXVX0
   dxO7jLTFowKF1EQ08JWnrsobFYJkDGp9h4CHErbzn6gTiKDO7twQLLaTg
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="295502647"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="295502647"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 13:57:30 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="638543510"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="638543510"
Received: from djiang5-mobl2.amr.corp.intel.com (HELO [10.212.66.184]) ([10.212.66.184])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 13:57:29 -0800
Message-ID: <bfaeb182-7b80-2330-1649-e2433de076f3@intel.com>
Date: Thu, 1 Dec 2022 14:57:28 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.5.0
Subject: Re: [PATCH v6 06/12] tools/testing/cxl: Make mock CEDT parsing more
 robust
Content-Language: en-US
To: Dan Williams <dan.j.williams@intel.com>, linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>,
 Robert Richter <rrichter@amd.com>, terry.bowman@amd.com,
 bhelgaas@google.com, nvdimm@lists.linux.dev
References: <166993040066.1882361.5484659873467120859.stgit@dwillia2-xfh.jf.intel.com>
 <166993043433.1882361.17651413716599606118.stgit@dwillia2-xfh.jf.intel.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <166993043433.1882361.17651413716599606118.stgit@dwillia2-xfh.jf.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 12/1/2022 2:33 PM, Dan Williams wrote:
> Accept any cxl_test topology device as the first argument in
> cxl_chbs_context.
> 
> This is in preparation for reworking the detection of the component
> registers across VH and RCH topologies. Move
> mock_acpi_table_parse_cedt() beneath the definition of is_mock_port()
> and use is_mock_port() instead of the explicit mock cxl_acpi device
> check.
> 
> Acked-by: Alison Schofield <alison.schofield@intel.com>
> Reviewed-by: Robert Richter <rrichter@amd.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>   tools/testing/cxl/test/cxl.c |   10 ++++++----
>   1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/cxl/test/cxl.c b/tools/testing/cxl/test/cxl.c
> index facfcd11cb67..8acf52b7dab2 100644
> --- a/tools/testing/cxl/test/cxl.c
> +++ b/tools/testing/cxl/test/cxl.c
> @@ -320,10 +320,12 @@ static int populate_cedt(void)
>   	return 0;
>   }
>   
> +static bool is_mock_port(struct device *dev);
> +
>   /*
> - * WARNING, this hack assumes the format of 'struct
> - * cxl_cfmws_context' and 'struct cxl_chbs_context' share the property that
> - * the first struct member is the device being probed by the cxl_acpi
> + * WARNING, this hack assumes the format of 'struct cxl_cfmws_context'
> + * and 'struct cxl_chbs_context' share the property that the first
> + * struct member is cxl_test device being probed by the cxl_acpi
>    * driver.
>    */
>   struct cxl_cedt_context {
> @@ -340,7 +342,7 @@ static int mock_acpi_table_parse_cedt(enum acpi_cedt_type id,
>   	unsigned long end;
>   	int i;
>   
> -	if (dev != &cxl_acpi->dev)
> +	if (!is_mock_port(dev) && !is_mock_dev(dev))
>   		return acpi_table_parse_cedt(id, handler_arg, arg);
>   
>   	if (id == ACPI_CEDT_TYPE_CHBS)
> 
