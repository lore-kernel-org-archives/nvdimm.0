Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26882CA1
	for <nvdimm@lists.linux.dev>; Tue,  1 Feb 2022 10:52:57 +0000 (UTC)
Received: from fraeml741-chm.china.huawei.com (unknown [172.18.147.206])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Jp1qj6zX4z67QKq;
	Tue,  1 Feb 2022 18:48:17 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml741-chm.china.huawei.com (10.206.15.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 1 Feb 2022 11:52:55 +0100
Received: from localhost (10.202.226.41) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Tue, 1 Feb
 2022 10:52:54 +0000
Date: Tue, 1 Feb 2022 10:52:53 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Ben Widawsky <ben.widawsky@intel.com>,
	<linux-pci@vger.kernel.org>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v5 16/40] cxl/core/port: Use dedicated lock for decoder
 target list
Message-ID: <20220201105253.00002f23@Huawei.com>
In-Reply-To: <164367209095.208169.1171673319121271280.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164316562430.3437160.122223070771602475.stgit@dwillia2-desk3.amr.corp.intel.com>
	<164367209095.208169.1171673319121271280.stgit@dwillia2-desk3.amr.corp.intel.com>
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

On Mon, 31 Jan 2022 15:35:18 -0800
Dan Williams <dan.j.williams@intel.com> wrote:

> Lockdep reports:
> 
>  ======================================================
>  WARNING: possible circular locking dependency detected
>  5.16.0-rc1+ #142 Tainted: G           OE
>  ------------------------------------------------------
>  cxl/1220 is trying to acquire lock:
>  ffff979b85475460 (kn->active#144){++++}-{0:0}, at: __kernfs_remove+0x1ab/0x1e0
> 
>  but task is already holding lock:
>  ffff979b87ab38e8 (&dev->lockdep_mutex#2/4){+.+.}-{3:3}, at: cxl_remove_ep+0x50c/0x5c0 [cxl_core]
> 
> ...where cxl_remove_ep() is a helper that wants to delete ports while
> holding a lock on the host device for that port. That sets up a lockdep
> violation whereby target_list_show() can not rely holding the decoder's
> device lock while walking the target_list. Switch to a dedicated seqlock
> for this purpose.
> 
> Reported-by: Ben Widawsky <ben.widawsky@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

