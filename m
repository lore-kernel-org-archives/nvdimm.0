Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263A73239;
	Tue, 28 Jun 2022 17:02:14 +0000 (UTC)
Received: from fraeml712-chm.china.huawei.com (unknown [172.18.147.201])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LXW8S0MWKz6GD42;
	Wed, 29 Jun 2022 01:01:28 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml712-chm.china.huawei.com (10.206.15.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 28 Jun 2022 19:02:11 +0200
Received: from localhost (10.202.226.42) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 28 Jun
 2022 18:02:10 +0100
Date: Tue, 28 Jun 2022 18:02:09 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Ira Weiny <ira.weiny@intel.com>,
	<hch@infradead.org>, <alison.schofield@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-pci@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH 12/46] cxl/mem: Convert partition-info to resources
Message-ID: <20220628180209.00001ca1@Huawei.com>
In-Reply-To: <165603878921.551046.8127845916514734142.stgit@dwillia2-xfh>
References: <165603869943.551046.3498980330327696732.stgit@dwillia2-xfh>
	<165603878921.551046.8127845916514734142.stgit@dwillia2-xfh>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.29; i686-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.42]
X-ClientProxiedBy: lhreml712-chm.china.huawei.com (10.201.108.63) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Thu, 23 Jun 2022 19:46:29 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> To date the per-device-partition DPA range information has only been
> used for enumeration purposes. In preparation for allocating regions
> from available DPA capacity, convert those ranges into DPA-type resource
> trees.
> 
> With resources and the new add_dpa_res() helper some open coded end
> address calculations and debug prints can be cleaned.
> 
> The 'cxlds->pmem_res' and 'cxlds->ram_res' resources are child resources
> of the total-device DPA space and they in turn will host DPA allocations
> from cxl_endpoint_decoder instances (tracked by cxled->dpa_res).
> 
> Cc: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
LGTM

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
