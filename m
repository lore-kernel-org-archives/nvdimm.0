Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A7648C1
	for <nvdimm@lists.linux.dev>; Wed,  9 Mar 2022 18:22:24 +0000 (UTC)
Received: from fraeml702-chm.china.huawei.com (unknown [172.18.147.226])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KDLBS6h5Vz67SnY;
	Thu, 10 Mar 2022 02:21:52 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml702-chm.china.huawei.com (10.206.15.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Wed, 9 Mar 2022 19:22:21 +0100
Received: from localhost (10.47.72.217) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Wed, 9 Mar
 2022 18:22:20 +0000
Date: Wed, 9 Mar 2022 18:22:17 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <gregkh@linuxfoundation.org>, <rafael.j.wysocki@intel.com>, "Alison
 Schofield" <alison.schofield@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>, Ben Widawsky
	<ben.widawsky@intel.com>, <linux-kernel@vger.kernel.org>,
	<linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH 03/11] cxl/core: Remove cxl_device_lock()
Message-ID: <20220309182217.00006bf5@Huawei.com>
In-Reply-To: <164610294604.2682974.11169622387063183603.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164610292916.2682974.12924748003366352335.stgit@dwillia2-desk3.amr.corp.intel.com>
	<164610294604.2682974.11169622387063183603.stgit@dwillia2-desk3.amr.corp.intel.com>
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
X-Originating-IP: [10.47.72.217]
X-ClientProxiedBy: lhreml733-chm.china.huawei.com (10.201.108.84) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Mon, 28 Feb 2022 18:49:06 -0800
Dan Williams <dan.j.williams@intel.com> wrote:

> In preparation for moving lockdep_mutex nested lock acquisition into the
> core, remove the cxl_device_lock() wrapper, but preserve
> cxl_lock_class() that will be used to inform the core of the subsystem's
> lock ordering rules.
> 
> Cc: Alison Schofield <alison.schofield@intel.com>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Cc: Ira Weiny <ira.weiny@intel.com>
> Cc: Ben Widawsky <ben.widawsky@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Makes sense, but perhaps the description should call out that after
this patch it's not just a wrapper remove, but rather the lock
checking is totally gone for now?

Otherwise this looks fine to me. FWIW
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
