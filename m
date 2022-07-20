Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D9E2602F
	for <nvdimm@lists.linux.dev>; Wed, 20 Jul 2022 17:16:55 +0000 (UTC)
Received: from fraeml712-chm.china.huawei.com (unknown [172.18.147.201])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Lp2Lr1N87z67xgN;
	Thu, 21 Jul 2022 01:12:20 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml712-chm.china.huawei.com (10.206.15.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 20 Jul 2022 19:16:53 +0200
Received: from localhost (10.81.205.121) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 20 Jul
 2022 18:16:52 +0100
Date: Wed, 20 Jul 2022 18:16:48 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Ben Widawsky <bwidawsk@kernel.org>,
	<hch@lst.de>, <nvdimm@lists.linux.dev>, <linux-pci@vger.kernel.org>
Subject: Re: [PATCH v2 17/28] cxl/region: Add region creation support
Message-ID: <20220720181648.00004938@Huawei.com>
In-Reply-To: <165784333909.1758207.794374602146306032.stgit@dwillia2-xfh.jf.intel.com>
References: <165784324066.1758207.15025479284039479071.stgit@dwillia2-xfh.jf.intel.com>
	<165784333909.1758207.794374602146306032.stgit@dwillia2-xfh.jf.intel.com>
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
X-Originating-IP: [10.81.205.121]
X-ClientProxiedBy: lhreml754-chm.china.huawei.com (10.201.108.204) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Thu, 14 Jul 2022 17:02:19 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> From: Ben Widawsky <bwidawsk@kernel.org>
> 
> CXL 2.0 allows for dynamic provisioning of new memory regions (system
> physical address resources like "System RAM" and "Persistent Memory").
> Whereas DDR and PMEM resources are conveyed statically at boot, CXL
> allows for assembling and instantiating new regions from the available
> capacity of CXL memory expanders in the system.
> 
> Sysfs with an "echo $region_name > $create_region_attribute" interface
> is chosen as the mechanism to initiate the provisioning process. This
> was chosen over ioctl() and netlink() to keep the configuration
> interface entirely in a pseudo-fs interface, and it was chosen over
> configfs since, aside from this one creation event, the interface is
> read-mostly. I.e. configfs supports cases where an object is designed to
> be provisioned each boot, like an iSCSI storage target, and CXL region
> creation is mostly for PMEM regions which are created usually once
> per-lifetime of a server instance. This is an improvement over nvdimm
> that pre-created "seed" devices that tended to confuse users looking to
> determine which devices are active and which are idle.
> 
> Recall that the major change that CXL brings over previous persistent
> memory architectures is the ability to dynamically define new regions.
> Compare that to drivers like 'nfit' where the region configuration is
> statically defined by platform firmware.
> 
> Regions are created as a child of a root decoder that encompasses an
> address space with constraints. When created through sysfs, the root
> decoder is explicit. When created from an LSA's region structure a root
> decoder will possibly need to be inferred by the driver.
> 
> Upon region creation through sysfs, a vacant region is created with a
> unique name. Regions have a number of attributes that must be configured
> before the region can be bound to the driver where HDM decoder program
> is completed.
> 
> An example of creating a new region:
> 
> - Allocate a new region name:
> region=$(cat /sys/bus/cxl/devices/decoder0.0/create_pmem_region)
> 
> - Create a new region by name:
> while
> region=$(cat /sys/bus/cxl/devices/decoder0.0/create_pmem_region)
> ! echo $region > /sys/bus/cxl/devices/decoder0.0/create_pmem_region
> do true; done
> 
> - Region now exists in sysfs:
> stat -t /sys/bus/cxl/devices/decoder0.0/$region
> 
> - Delete the region, and name:
> echo $region > /sys/bus/cxl/devices/decoder0.0/delete_region
> 
> Signed-off-by: Ben Widawsky <bwidawsk@kernel.org>
> [djbw: simplify locking, reword changelog]
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
V1 comments all addressed so
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

