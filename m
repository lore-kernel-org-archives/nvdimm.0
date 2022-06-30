Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A162F7B;
	Thu, 30 Jun 2022 17:14:37 +0000 (UTC)
Received: from fraeml734-chm.china.huawei.com (unknown [172.18.147.201])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LYlHt5Dw6z6H6sG;
	Fri,  1 Jul 2022 01:12:10 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml734-chm.china.huawei.com (10.206.15.215) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 30 Jun 2022 19:14:34 +0200
Received: from localhost (10.81.200.250) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 30 Jun
 2022 18:14:33 +0100
Date: Thu, 30 Jun 2022 18:14:32 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-pci@vger.kernel.org>, <patches@lists.linux.dev>, <hch@lst.de>
Subject: Re: [PATCH 45/46] cxl/pmem: Fix offline_nvdimm_bus() to offline by
 bridge
Message-ID: <20220630181432.000040a2@Huawei.com>
In-Reply-To: <20220624041950.559155-20-dan.j.williams@intel.com>
References: <165603869943.551046.3498980330327696732.stgit@dwillia2-xfh>
	<20220624041950.559155-20-dan.j.williams@intel.com>
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
X-Originating-IP: [10.81.200.250]
X-ClientProxiedBy: lhreml754-chm.china.huawei.com (10.201.108.204) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Thu, 23 Jun 2022 21:19:49 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> Be careful to only disable cxl_pmem objects related to a given
> cxl_nvdimm_bridge. Otherwise, offline_nvdimm_bus() reaches across CXL
> domains and disables more than is expected.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Fix, but not fixes tag? Probably wants a comment (I'm guessing
it didn't matter until now?)

By Domains, what do you mean?  I don't think we have that
well defined as a term.
