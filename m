Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E175321F833DC
 for <linux-nvdimm@lists.01.org>; Thu,  4 Jan 2018 10:59:56 -0800 (PST)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Thu,  4 Jan 2018 12:01:29 -0700
Message-Id: <20180104190137.7654-5-logang@deltatee.com>
In-Reply-To: <20180104190137.7654-1-logang@deltatee.com>
References: <20180104190137.7654-1-logang@deltatee.com>
Subject: [PATCH 04/12] pci-p2p: Clear ACS P2P flags for all client devices
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

When the ACS P2P flags are set in the downstream port of the switch,
any P2P TLPs will be sent back to the root complex. The whole point of
the P2P work is to have TLPs avoid the RC seeing it may not support
P2P transactions or, at best, it will perform poorly. So we clear these
flags for all devices involved in transactions with the p2pmem.

A count of the number of requests to disable the flags is maintained.
When the count transitions from 1 to 0, the old flags are restored.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 drivers/pci/p2p.c   | 144 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 include/linux/pci.h |   2 +
 2 files changed, 143 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/p2p.c b/drivers/pci/p2p.c
index 87cec87b02e3..617adaa905d2 100644
--- a/drivers/pci/p2p.c
+++ b/drivers/pci/p2p.c
@@ -227,6 +227,89 @@ static struct pci_dev *find_parent_pci_dev(struct device *dev)
 }
 
 /*
+ * The ACS flags for P2P Request Redirect and P2P Completion Redirect need
+ * to be disabled in the downstream port of each device in order for
+ * the TLPs to not be forwarded up to the RC.
+ */
+#define PCI_P2P_ACS_FLAGS (PCI_ACS_RR | PCI_ACS_CR)
+
+static int pci_p2pmem_disable_acs(struct pci_dev *pdev)
+{
+	int pos;
+	u16 ctrl;
+	struct pci_dev *downstream;
+
+	downstream = pci_dev_get(pci_upstream_bridge(pdev));
+	if (!downstream) {
+		dev_err(&pdev->dev, "could not find downstream port\n");
+		return -ENODEV;
+	}
+
+	device_lock(&downstream->dev);
+	if (downstream->p2p_acs_requests++)
+		goto unlock_and_return;
+
+	pos = pci_find_ext_capability(downstream, PCI_EXT_CAP_ID_ACS);
+	if (!pos)
+		goto unlock_and_return;
+
+	pci_read_config_word(downstream, pos + PCI_ACS_CTRL, &ctrl);
+
+	downstream->p2p_old_acs_flags = ctrl & PCI_P2P_ACS_FLAGS;
+
+	if (downstream->p2p_old_acs_flags)
+		dev_info(&pdev->dev, "disabling p2p acs flags: %x\n", ctrl);
+
+	ctrl &= ~PCI_P2P_ACS_FLAGS;
+
+	pci_write_config_word(downstream, pos + PCI_ACS_CTRL, ctrl);
+
+unlock_and_return:
+	device_unlock(&downstream->dev);
+	pci_dev_put(downstream);
+	return 0;
+}
+
+static int pci_p2pmem_reset_acs(struct pci_dev *pdev)
+{
+	int pos;
+	u16 ctrl;
+	struct pci_dev *downstream;
+
+	downstream = pci_dev_get(pci_upstream_bridge(pdev));
+	if (!downstream)
+		return -ENODEV;
+
+	device_lock(&downstream->dev);
+
+	/* Only actually reset the flags on a 1->0 transition */
+	if (!downstream->p2p_acs_requests)
+		goto unlock_and_return;
+
+	if (--downstream->p2p_acs_requests)
+		goto unlock_and_return;
+
+	pos = pci_find_ext_capability(downstream, PCI_EXT_CAP_ID_ACS);
+	if (!pos)
+		goto unlock_and_return;
+
+	pci_read_config_word(downstream, pos + PCI_ACS_CTRL, &ctrl);
+
+	ctrl &= ~PCI_P2P_ACS_FLAGS;
+	ctrl |= downstream->p2p_old_acs_flags;
+
+	if (downstream->p2p_old_acs_flags)
+		dev_info(&pdev->dev, "resetting p2p acs flags: %x\n", ctrl);
+
+	pci_write_config_word(downstream, pos + PCI_ACS_CTRL, ctrl);
+
+unlock_and_return:
+	device_unlock(&downstream->dev);
+	pci_dev_put(downstream);
+	return 0;
+}
+
+/*
  * If a device is behind a switch, we try to find the upstream bridge
  * port of the switch. This requires two calls to pci_upstream_bridge:
  * one for the upstream port on the switch, one on the upstream port
@@ -340,6 +423,10 @@ int pci_p2pmem_add_client(struct list_head *head, struct device *dev)
 			ret = -EXDEV;
 			goto put_client;
 		}
+
+		ret = pci_p2pmem_disable_acs(client);
+		if (!ret)
+			goto put_client;
 	}
 
 	new_item = kzalloc(sizeof(*new_item), GFP_KERNEL);
@@ -363,6 +450,9 @@ EXPORT_SYMBOL_GPL(pci_p2pmem_add_client);
 
 static void pci_p2pmem_client_free(struct pci_p2pmem_client *item)
 {
+	if (item->p2pmem)
+		pci_p2pmem_reset_acs(item->client);
+
 	list_del(&item->list);
 	pci_dev_put(item->client);
 	pci_dev_put(item->p2pmem);
@@ -383,6 +473,7 @@ void pci_p2pmem_remove_client(struct list_head *head, struct device *dev)
 {
 	struct pci_p2pmem_client *pos, *tmp;
 	struct pci_dev *pdev;
+	struct pci_dev *p2pmem = NULL;
 
 	pdev = find_parent_pci_dev(dev);
 	if (!pdev)
@@ -392,9 +483,16 @@ void pci_p2pmem_remove_client(struct list_head *head, struct device *dev)
 		if (pos->client != pdev)
 			continue;
 
+		if (!p2pmem)
+			p2pmem = pci_dev_get(pos->p2pmem);
+
 		pci_p2pmem_client_free(pos);
 	}
 
+	if (p2pmem && list_empty(head))
+		pci_p2pmem_reset_acs(p2pmem);
+
+	pci_dev_put(p2pmem);
 	pci_dev_put(pdev);
 }
 EXPORT_SYMBOL_GPL(pci_p2pmem_remove_client);
@@ -412,6 +510,10 @@ void pci_p2pmem_client_list_free(struct list_head *head)
 {
 	struct pci_p2pmem_client *pos, *tmp;
 
+	pos = list_first_entry_or_null(head, struct pci_p2pmem_client, list);
+	if (pos && pos->p2pmem)
+		pci_p2pmem_reset_acs(pos->p2pmem);
+
 	list_for_each_entry_safe(pos, tmp, head, list)
 		pci_p2pmem_client_free(pos);
 }
@@ -440,6 +542,40 @@ static bool upstream_bridges_match_list(struct pci_dev *pdev,
 	return ret;
 }
 
+static int bind_clients(struct pci_dev *p2pmem, struct list_head *clients)
+{
+	int ret;
+	struct pci_p2pmem_client *pos, *unwind_pos;
+
+	ret = pci_p2pmem_disable_acs(p2pmem);
+	if (ret)
+		return ret;
+
+	list_for_each_entry(pos, clients, list) {
+		ret = pci_p2pmem_disable_acs(pos->client);
+		if (ret)
+			goto unwind;
+
+		pos->p2pmem = pci_dev_get(p2pmem);
+	}
+
+	return 0;
+
+unwind:
+	list_for_each_entry(unwind_pos, clients, list) {
+		if (pos == unwind_pos)
+			break;
+
+		pci_p2pmem_reset_acs(unwind_pos->client);
+		pci_dev_put(unwind_pos->p2pmem);
+		unwind_pos->p2pmem = NULL;
+	}
+
+	pci_p2pmem_reset_acs(p2pmem);
+
+	return ret;
+}
+
 /**
  * pci_p2pmem_find - find a p2p mem device compatible with the specified device
  * @dev: list of device to check (NULL-terminated)
@@ -450,11 +586,13 @@ static bool upstream_bridges_match_list(struct pci_dev *pdev,
  *
  * Returns a pointer to the PCI device with a reference taken (use pci_dev_put
  * to return the reference) or NULL if no compatible device is found.
+ *
+ * The P2P ACS flags on all applicable PCI devices will be cleared and
+ * reset when the client is removed from the list.
  */
 struct pci_dev *pci_p2pmem_find(struct list_head *clients)
 {
 	struct pci_dev *pdev = NULL;
-	struct pci_p2pmem_client *pos;
 
 	while ((pdev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, pdev))) {
 		if (!pdev->p2p || !pdev->p2p->published)
@@ -463,8 +601,8 @@ struct pci_dev *pci_p2pmem_find(struct list_head *clients)
 		if (!upstream_bridges_match_list(pdev, clients))
 			continue;
 
-		list_for_each_entry(pos, clients, list)
-			pos->p2pmem = pdev;
+		if (bind_clients(pdev, clients))
+			continue;
 
 		return pdev;
 	}
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 047aea679e87..cdd4d3c3e562 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -435,6 +435,8 @@ struct pci_dev {
 #endif
 #ifdef CONFIG_PCI_P2P
 	struct pci_p2p *p2p;
+	unsigned int p2p_acs_requests;
+	u16 p2p_old_acs_flags;
 #endif
 	phys_addr_t rom; /* Physical address of ROM if it's not from the BAR */
 	size_t romlen; /* Length of ROM if it's not from the BAR */
-- 
2.11.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
