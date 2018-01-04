Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 08EC321F833DF
 for <linux-nvdimm@lists.01.org>; Thu,  4 Jan 2018 10:59:56 -0800 (PST)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Thu,  4 Jan 2018 12:01:27 -0700
Message-Id: <20180104190137.7654-3-logang@deltatee.com>
In-Reply-To: <20180104190137.7654-1-logang@deltatee.com>
References: <20180104190137.7654-1-logang@deltatee.com>
Subject: [PATCH 02/12] pci-p2p: Add sysfs group to display p2pmem stats
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Keith Busch <keith.busch@intel.com>, =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Attributes display the total amount of P2P memory, the ammount available
and whether it is published or not.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 Documentation/ABI/testing/sysfs-bus-pci | 25 ++++++++++++++++
 drivers/pci/p2p.c                       | 51 +++++++++++++++++++++++++++++++++
 2 files changed, 76 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
index 44d4b2be92fd..7b80ea77faca 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci
+++ b/Documentation/ABI/testing/sysfs-bus-pci
@@ -323,3 +323,28 @@ Description:
 
 		This is similar to /sys/bus/pci/drivers_autoprobe, but
 		affects only the VFs associated with a specific PF.
+
+What:		/sys/bus/pci/devices/.../p2pmem/available
+Date:		November 2017
+Contact:	Logan Gunthorpe <logang@deltatee.com>
+Description:
+		If the device has any Peer-to-Peer memory registered, this
+	        file contains the ammount of memory that has not been
+		allocated (in decimal).
+
+What:		/sys/bus/pci/devices/.../p2pmem/size
+Date:		November 2017
+Contact:	Logan Gunthorpe <logang@deltatee.com>
+Description:
+		If the device has any Peer-to-Peer memory registered, this
+	        file contains the total ammount of memory that the device
+		provides (in decimal).
+
+What:		/sys/bus/pci/devices/.../p2pmem/published
+Date:		November 2017
+Contact:	Logan Gunthorpe <logang@deltatee.com>
+Description:
+		If the device has any Peer-to-Peer memory registered, this
+	        file contains a '1' if the memory has been published for
+		use inside the kernel or a '0' if it is only intended
+		for use within the driver that published it.
diff --git a/drivers/pci/p2p.c b/drivers/pci/p2p.c
index aa465ac9273d..03330c7b5e6d 100644
--- a/drivers/pci/p2p.c
+++ b/drivers/pci/p2p.c
@@ -28,6 +28,53 @@ struct pci_p2p {
 	bool published;
 };
 
+static ssize_t size_show(struct device *dev, struct device_attribute *attr,
+			 char *buf)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	size_t size = 0;
+
+	if (pdev->p2p->pool)
+		size = gen_pool_size(pdev->p2p->pool);
+
+	return snprintf(buf, PAGE_SIZE, "%zd\n", size);
+}
+static DEVICE_ATTR_RO(size);
+
+static ssize_t available_show(struct device *dev, struct device_attribute *attr,
+			      char *buf)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	size_t avail = 0;
+
+	if (pdev->p2p->pool)
+		avail = gen_pool_avail(pdev->p2p->pool);
+
+	return snprintf(buf, PAGE_SIZE, "%zd\n", avail);
+}
+static DEVICE_ATTR_RO(available);
+
+static ssize_t published_show(struct device *dev, struct device_attribute *attr,
+			      char *buf)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", pdev->p2p->published);
+}
+static DEVICE_ATTR_RO(published);
+
+static struct attribute *p2pmem_attrs[] = {
+	&dev_attr_size.attr,
+	&dev_attr_available.attr,
+	&dev_attr_published.attr,
+	NULL,
+};
+
+static const struct attribute_group p2pmem_group = {
+	.attrs = p2pmem_attrs,
+	.name = "p2pmem",
+};
+
 static void pci_p2pmem_percpu_release(struct percpu_ref *ref)
 {
 	struct pci_p2p *p2p =
@@ -54,6 +101,7 @@ static void pci_p2pmem_release(void *data)
 	percpu_ref_exit(&pdev->p2p->devmap_ref);
 
 	gen_pool_destroy(pdev->p2p->pool);
+	sysfs_remove_group(&pdev->dev.kobj, &p2pmem_group);
 	pdev->p2p = NULL;
 }
 
@@ -82,6 +130,9 @@ static int pci_p2pmem_setup(struct pci_dev *pdev)
 	if (error)
 		goto out_pool_destroy;
 
+	if (sysfs_create_group(&pdev->dev.kobj, &p2pmem_group))
+		dev_warn(&pdev->dev, "failed to create p2p sysfs group\n");
+
 	pdev->p2p = p2p;
 
 	return 0;
-- 
2.11.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
