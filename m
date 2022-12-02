Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57EF24C71
	for <nvdimm@lists.linux.dev>; Fri,  2 Dec 2022 15:58:33 +0000 (UTC)
Received: from frapeml100007.china.huawei.com (unknown [172.18.147.201])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4NNyFj2yL0z67njv;
	Fri,  2 Dec 2022 23:55:21 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 frapeml100007.china.huawei.com (7.182.85.133) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 2 Dec 2022 16:58:30 +0100
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 2 Dec
 2022 15:58:30 +0000
Date: Fri, 2 Dec 2022 15:58:29 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Alison Schofield
	<alison.schofield@intel.com>, Robert Richter <rrichter@amd.com>,
	<terry.bowman@amd.com>, <bhelgaas@google.com>, <dave.jiang@intel.com>,
	<nvdimm@lists.linux.dev>
Subject: Re: [PATCH v6 06/12] tools/testing/cxl: Make mock CEDT parsing more
 robust
Message-ID: <20221202155829.0000332c@Huawei.com>
In-Reply-To: <166993043433.1882361.17651413716599606118.stgit@dwillia2-xfh.jf.intel.com>
References: <166993040066.1882361.5484659873467120859.stgit@dwillia2-xfh.jf.intel.com>
	<166993043433.1882361.17651413716599606118.stgit@dwillia2-xfh.jf.intel.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.76]
X-ClientProxiedBy: lhrpeml100002.china.huawei.com (7.191.160.241) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected

On Thu, 01 Dec 2022 13:33:54 -0800
Dan Williams <dan.j.williams@intel.com> wrote:

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
 A comment inline on possible improvement elsewhere, but otherwise seems fine.
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>


> ---
>  tools/testing/cxl/test/cxl.c |   10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/cxl/test/cxl.c b/tools/testing/cxl/test/cxl.c
> index facfcd11cb67..8acf52b7dab2 100644
> --- a/tools/testing/cxl/test/cxl.c
> +++ b/tools/testing/cxl/test/cxl.c
> @@ -320,10 +320,12 @@ static int populate_cedt(void)
>  	return 0;
>  }
>  
> +static bool is_mock_port(struct device *dev);
> +
>  /*
> - * WARNING, this hack assumes the format of 'struct
> - * cxl_cfmws_context' and 'struct cxl_chbs_context' share the property that
> - * the first struct member is the device being probed by the cxl_acpi
> + * WARNING, this hack assumes the format of 'struct cxl_cfmws_context'
> + * and 'struct cxl_chbs_context' share the property that the first
> + * struct member is cxl_test device being probed by the cxl_acpi
>   * driver.
Side note, but that requirement would be useful to add to the two
struct definitions so that we don't change those in future without knowing
we need to rethink this!

Beyond that dark mutterings about reformatting lines above the change made
and hence making this patch noisier than it needs to be...
 
>   */
>  struct cxl_cedt_context {
> @@ -340,7 +342,7 @@ static int mock_acpi_table_parse_cedt(enum acpi_cedt_type id,
>  	unsigned long end;
>  	int i;
>  
> -	if (dev != &cxl_acpi->dev)
> +	if (!is_mock_port(dev) && !is_mock_dev(dev))
>  		return acpi_table_parse_cedt(id, handler_arg, arg);
>  
>  	if (id == ACPI_CEDT_TYPE_CHBS)
> 

