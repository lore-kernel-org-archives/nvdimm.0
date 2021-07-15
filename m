Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7947168
	for <nvdimm@lists.linux.dev>; Thu, 15 Jul 2021 22:36:38 +0000 (UTC)
Received: by linux.microsoft.com (Postfix, from userid 1096)
	id 78C8120B6C14; Thu, 15 Jul 2021 15:36:38 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 78C8120B6C14
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1626388598;
	bh=9/Bqa4eOrfdzbB9ODvgnTNZ736Ji7S/0BoMYLEjPLt8=;
	h=Date:From:To:Cc:Subject:From;
	b=jWxiZza4LTdrqT1Tw98NAvjSfKdh5KNEiIX62W17JyKoGc/llQyRs08wV2EDv1ap7
	 xF1QsBhWgQX6B25otNbTsPhBo82Ma7go9NV/Doiqtx7LQwVFnOke9Wzmm6T3bWWc7I
	 xDVEEGoGYR5QJOVhWd3ezJ2aN5YTNUJB8knY/vlk=
Date: Thu, 15 Jul 2021 15:36:38 -0700
From: Taylor Stark <tstark@linux.microsoft.com>
To: dan.j.williams@intel.com, vishal.l.verma@intel.com,
	dave.jiang@intel.com, ira.weiny@intel.com
Cc: nvdimm@lists.linux.dev, apais@microsoft.com, tyhicks@microsoft.com,
	jamorris@microsoft.com, benhill@microsoft.com,
	sunilmut@microsoft.com, grahamwo@microsoft.com,
	tstark@microsoft.com
Subject: [PATCH v2 2/2] virtio-pmem: Set DRIVER_OK status prior to creating
 pmem region
Message-ID: <20210715223638.GA29649@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)

Update virtio-pmem to call virtio_device_ready prior to creating the pmem
region. Otherwise, the guest may try to access the pmem region prior to
the DRIVER_OK status being set.

In the case of Hyper-V, the backing pmem file isn't mapped to the guest
until the DRIVER_OK status is set. Therefore, attempts to access the pmem
region can cause the guest to crash. Hyper-V could map the file earlier,
for example at VM creation, but we didn't want to pay the mapping cost if
the device is never used. Additionally, it felt weird to allow the guest
to access the region prior to the device fully coming online.

Signed-off-by: Taylor Stark <tstark@microsoft.com>
---
 drivers/nvdimm/virtio_pmem.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
index 43c1d835a449..ea9e111f3ea1 100644
--- a/drivers/nvdimm/virtio_pmem.c
+++ b/drivers/nvdimm/virtio_pmem.c
@@ -91,6 +91,11 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
 
 	dev_set_drvdata(&vdev->dev, vpmem->nvdimm_bus);
 
+	/* Online the device prior to creating a pmem region, to ensure that
+	 * the region is never touched while the device is offline.
+	 */
+	virtio_device_ready(vdev);
+
 	ndr_desc.res = &res;
 	ndr_desc.numa_node = nid;
 	ndr_desc.flush = async_pmem_flush;
@@ -105,6 +110,7 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
 	nd_region->provider_data = dev_to_virtio(nd_region->dev.parent->parent);
 	return 0;
 out_nd:
+	vdev->config->reset(vdev);
 	nvdimm_bus_unregister(vpmem->nvdimm_bus);
 out_vq:
 	vdev->config->del_vqs(vdev);
-- 
2.32.0

