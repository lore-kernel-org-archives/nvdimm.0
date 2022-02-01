Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B89E2CA1
	for <nvdimm@lists.linux.dev>; Tue,  1 Feb 2022 10:49:28 +0000 (UTC)
Received: from fraeml744-chm.china.huawei.com (unknown [172.18.147.200])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Jp1mh0wMMz67xMM;
	Tue,  1 Feb 2022 18:45:40 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml744-chm.china.huawei.com (10.206.15.225) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 1 Feb 2022 11:49:24 +0100
Received: from localhost (10.202.226.41) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Tue, 1 Feb
 2022 10:49:24 +0000
Date: Tue, 1 Feb 2022 10:49:22 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Ben Widawsky <ben.widawsky@intel.com>,
	<linux-pci@vger.kernel.org>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v4 11/40] cxl/core/port: Clarify decoder creation
Message-ID: <20220201104922.000022ad@Huawei.com>
In-Reply-To: <164366463014.111117.9714595404002687111.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164298417755.3018233.850001481653928773.stgit@dwillia2-desk3.amr.corp.intel.com>
	<164366463014.111117.9714595404002687111.stgit@dwillia2-desk3.amr.corp.intel.com>
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
X-Originating-IP: [10.202.226.41]
X-ClientProxiedBy: lhreml733-chm.china.huawei.com (10.201.108.84) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Mon, 31 Jan 2022 13:33:13 -0800
Dan Williams <dan.j.williams@intel.com> wrote:

> From: Ben Widawsky <ben.widawsky@intel.com>
> 
> Add wrappers for the creation of decoder objects at the root level and
> switch level, and keep the core helper private to cxl/core/port.c. Root
> decoders are static descriptors conveyed from platform firmware (e.g.
> ACPI CFMWS). Switch decoders are CXL standard decoders enumerated via
> the HDM decoder capability structure. The base address for the HDM
> decoder capability structure may be conveyed either by PCIe or platform
> firmware (ACPI CEDT.CHBS).
> 
> Additionally, the kdoc descriptions for these helpers and their
> dependencies is updated.
> 
> Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
> [djbw: fixup changelog, clarify kdoc]
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

