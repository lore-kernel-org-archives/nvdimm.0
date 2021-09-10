Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3793FC4
	for <nvdimm@lists.linux.dev>; Fri, 10 Sep 2021 08:38:31 +0000 (UTC)
Received: from fraeml709-chm.china.huawei.com (unknown [172.18.147.226])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4H5Tjw6YDpz67Zm1;
	Fri, 10 Sep 2021 16:36:20 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml709-chm.china.huawei.com (10.206.15.37) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Fri, 10 Sep 2021 10:38:29 +0200
Received: from localhost (10.52.123.213) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Fri, 10 Sep
 2021 09:38:28 +0100
Date: Fri, 10 Sep 2021 09:38:26 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <vishal.l.verma@intel.com>,
	<nvdimm@lists.linux.dev>, <ben.widawsky@intel.com>,
	<alison.schofield@intel.com>, <ira.weiny@intel.com>
Subject: Re: [PATCH v4 04/21] libnvdimm/labels: Fix kernel-doc for label.h
Message-ID: <20210910093826.00007845@Huawei.com>
In-Reply-To: <163116431381.2460985.6990754901097922099.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <163116429183.2460985.5040982981112374615.stgit@dwillia2-desk3.amr.corp.intel.com>
	<163116431381.2460985.6990754901097922099.stgit@dwillia2-desk3.amr.corp.intel.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; i686-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.52.123.213]
X-ClientProxiedBy: lhreml710-chm.china.huawei.com (10.201.108.61) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Wed, 8 Sep 2021 22:11:53 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> Clean up existing kernel-doc warnings before adding new CXL label data
> structures.
> 
> drivers/nvdimm/label.h:66: warning: Function parameter or member 'labelsize' not described in 'nd_namespace_index'
> drivers/nvdimm/label.h:66: warning: Function parameter or member 'free' not described in 'nd_namespace_index'
> drivers/nvdimm/label.h:103: warning: Function parameter or member 'align' not described in 'nd_namespace_label'
> drivers/nvdimm/label.h:103: warning: Function parameter or member 'reserved' not described in 'nd_namespace_label'
> drivers/nvdimm/label.h:103: warning: Function parameter or member 'type_guid' not described in 'nd_namespace_label'
> drivers/nvdimm/label.h:103: warning: Function parameter or member 'abstraction_guid' not described in 'nd_namespace_label'
> drivers/nvdimm/label.h:103: warning: Function parameter or member 'reserved2' not described in 'nd_namespace_label'
> drivers/nvdimm/label.h:103: warning: Function parameter or member 'checksum' not described in 'nd_namespace_label'
> 
> Reported-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
LGTM
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> ---
>  drivers/nvdimm/label.h |   10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/nvdimm/label.h b/drivers/nvdimm/label.h
> index 31f94fad7b92..7fa757d47846 100644
> --- a/drivers/nvdimm/label.h
> +++ b/drivers/nvdimm/label.h
> @@ -34,6 +34,7 @@ enum {
>   * struct nd_namespace_index - label set superblock
>   * @sig: NAMESPACE_INDEX\0
>   * @flags: placeholder
> + * @labelsize: log2 size (v1 labels 128 bytes v2 labels 256 bytes)
>   * @seq: sequence number for this index
>   * @myoff: offset of this index in label area
>   * @mysize: size of this index struct
> @@ -43,7 +44,7 @@ enum {
>   * @major: label area major version
>   * @minor: label area minor version
>   * @checksum: fletcher64 of all fields
> - * @free[0]: bitmap, nlabel bits
> + * @free: bitmap, nlabel bits
>   *
>   * The size of free[] is rounded up so the total struct size is a
>   * multiple of NSINDEX_ALIGN bytes.  Any bits this allocates beyond
> @@ -77,7 +78,12 @@ struct nd_namespace_index {
>   * @dpa: DPA of NVM range on this DIMM
>   * @rawsize: size of namespace
>   * @slot: slot of this label in label area
> - * @unused: must be zero
> + * @align: physical address alignment of the namespace
> + * @reserved: reserved
> + * @type_guid: copy of struct acpi_nfit_system_address.range_guid
> + * @abstraction_guid: personality id (btt, btt2, fsdax, devdax....)
> + * @reserved2: reserved
> + * @checksum: fletcher64 sum of this object
>   */
>  struct nd_namespace_label {
>  	u8 uuid[NSLABEL_UUID_LEN];
> 

