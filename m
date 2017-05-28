Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CA3FC21A16EC7
 for <linux-nvdimm@lists.01.org>; Sun, 28 May 2017 03:20:37 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 19/22] nvme: switch to uuid_t
Date: Sun, 28 May 2017 13:20:05 +0300
Message-Id: <20170528102008.30276-20-hch@lst.de>
In-Reply-To: <20170528102008.30276-1-hch@lst.de>
References: <20170528102008.30276-1-hch@lst.de>
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
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>, linux-block@vger.kernel.org, Mimi Zohar <zohar@linux.vnet.ibm.com>, Steven Whitehouse <swhiteho@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/nvme/host/fabrics.c | 8 ++++----
 drivers/nvme/host/fabrics.h | 2 +-
 drivers/nvme/host/fc.c      | 3 +--
 drivers/nvme/target/nvmet.h | 1 +
 include/linux/nvme-fc.h     | 3 +--
 include/linux/nvme.h        | 3 ++-
 6 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/nvme/host/fabrics.c b/drivers/nvme/host/fabrics.c
index 990e6fb32a63..c190d7e36900 100644
--- a/drivers/nvme/host/fabrics.c
+++ b/drivers/nvme/host/fabrics.c
@@ -58,7 +58,7 @@ static struct nvmf_host *nvmf_host_add(const char *hostnqn)
 
 	kref_init(&host->ref);
 	memcpy(host->nqn, hostnqn, NVMF_NQN_SIZE);
-	uuid_be_gen(&host->id);
+	uuid_gen(&host->id);
 
 	list_add_tail(&host->list, &nvmf_hosts);
 out_unlock:
@@ -75,7 +75,7 @@ static struct nvmf_host *nvmf_host_default(void)
 		return NULL;
 
 	kref_init(&host->ref);
-	uuid_be_gen(&host->id);
+	uuid_gen(&host->id);
 	snprintf(host->nqn, NVMF_NQN_SIZE,
 		"nqn.2014-08.org.nvmexpress:NVMf:uuid:%pUb", &host->id);
 
@@ -395,7 +395,7 @@ int nvmf_connect_admin_queue(struct nvme_ctrl *ctrl)
 	if (!data)
 		return -ENOMEM;
 
-	memcpy(&data->hostid, &ctrl->opts->host->id, sizeof(uuid_be));
+	uuid_copy(&data->hostid, &ctrl->opts->host->id);
 	data->cntlid = cpu_to_le16(0xffff);
 	strncpy(data->subsysnqn, ctrl->opts->subsysnqn, NVMF_NQN_SIZE);
 	strncpy(data->hostnqn, ctrl->opts->host->nqn, NVMF_NQN_SIZE);
@@ -454,7 +454,7 @@ int nvmf_connect_io_queue(struct nvme_ctrl *ctrl, u16 qid)
 	if (!data)
 		return -ENOMEM;
 
-	memcpy(&data->hostid, &ctrl->opts->host->id, sizeof(uuid_be));
+	uuid_copy(&data->hostid, &ctrl->opts->host->id);
 	data->cntlid = cpu_to_le16(ctrl->cntlid);
 	strncpy(data->subsysnqn, ctrl->opts->subsysnqn, NVMF_NQN_SIZE);
 	strncpy(data->hostnqn, ctrl->opts->host->nqn, NVMF_NQN_SIZE);
diff --git a/drivers/nvme/host/fabrics.h b/drivers/nvme/host/fabrics.h
index f5a9c1fb186f..29be7600689d 100644
--- a/drivers/nvme/host/fabrics.h
+++ b/drivers/nvme/host/fabrics.h
@@ -36,7 +36,7 @@ struct nvmf_host {
 	struct kref		ref;
 	struct list_head	list;
 	char			nqn[NVMF_NQN_SIZE];
-	uuid_be			id;
+	uuid_t			id;
 };
 
 /**
diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index 5b14cbefb724..96b983bb44bd 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -878,8 +878,7 @@ nvme_fc_connect_admin_queue(struct nvme_fc_ctrl *ctrl,
 	assoc_rqst->assoc_cmd.sqsize = cpu_to_be16(qsize);
 	/* Linux supports only Dynamic controllers */
 	assoc_rqst->assoc_cmd.cntlid = cpu_to_be16(0xffff);
-	memcpy(&assoc_rqst->assoc_cmd.hostid, &ctrl->ctrl.opts->host->id,
-		min_t(size_t, FCNVME_ASSOC_HOSTID_LEN, sizeof(uuid_be)));
+	uuid_copy(&assoc_rqst->assoc_cmd.hostid, &ctrl->ctrl.opts->host->id);
 	strncpy(assoc_rqst->assoc_cmd.hostnqn, ctrl->ctrl.opts->host->nqn,
 		min(FCNVME_ASSOC_HOSTNQN_LEN, NVMF_NQN_SIZE));
 	strncpy(assoc_rqst->assoc_cmd.subnqn, ctrl->ctrl.opts->subsysnqn,
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index cfc5c7fb0ab7..8ff6e430b30a 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -21,6 +21,7 @@
 #include <linux/percpu-refcount.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
+#include <linux/uuid.h>
 #include <linux/nvme.h>
 #include <linux/configfs.h>
 #include <linux/rcupdate.h>
diff --git a/include/linux/nvme-fc.h b/include/linux/nvme-fc.h
index e997c4a49a88..bc711a10be05 100644
--- a/include/linux/nvme-fc.h
+++ b/include/linux/nvme-fc.h
@@ -177,7 +177,6 @@ struct fcnvme_lsdesc_rjt {
 };
 
 
-#define FCNVME_ASSOC_HOSTID_LEN		16
 #define FCNVME_ASSOC_HOSTNQN_LEN	256
 #define FCNVME_ASSOC_SUBNQN_LEN		256
 
@@ -191,7 +190,7 @@ struct fcnvme_lsdesc_cr_assoc_cmd {
 	__be16	cntlid;
 	__be16	sqsize;
 	__be32	rsvd52;
-	u8	hostid[FCNVME_ASSOC_HOSTID_LEN];
+	uuid_t	hostid;
 	u8	hostnqn[FCNVME_ASSOC_HOSTNQN_LEN];
 	u8	subnqn[FCNVME_ASSOC_SUBNQN_LEN];
 	u8	rsvd632[384];
diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index b625bacf37ef..e400a69fa1d3 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -16,6 +16,7 @@
 #define _LINUX_NVME_H
 
 #include <linux/types.h>
+#include <linux/uuid.h>
 
 /* NQN names in commands fields specified one size */
 #define NVMF_NQN_FIELD_LEN	256
@@ -843,7 +844,7 @@ struct nvmf_connect_command {
 };
 
 struct nvmf_connect_data {
-	__u8		hostid[16];
+	uuid_t		hostid;
 	__le16		cntlid;
 	char		resv4[238];
 	char		subsysnqn[NVMF_NQN_FIELD_LEN];
-- 
2.11.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
