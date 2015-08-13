Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v5 5/8] visorbus: switch from ioremap_cache to memremap
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 12 Aug 2015 20:12:30 -0400
Message-ID: <20150813001230.17702.65969.stgit@otcpl-skl-sds-2.jf.intel.com>
In-Reply-To: <20150813000250.17702.28409.stgit@otcpl-skl-sds-2.jf.intel.com>
References: <20150813000250.17702.28409.stgit@otcpl-skl-sds-2.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-nvdimm@lists.01.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, mcgrof@suse.com, hch@lst.de, Benjamin Romer <benjamin.romer@unisys.com>, David Kershner <david.kershner@unisys.com>, ross.zwisler@linux.intel.com
List-ID: <linux-nvdimm@lists.01.org>

In preparation for deprecating ioremap_cache() convert its usage in
visorbus to memremap.

Cc: Benjamin Romer <benjamin.romer@unisys.com>
Cc: David Kershner <david.kershner@unisys.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/staging/unisys/visorbus/visorchannel.c |   16 +++++++++-------
 drivers/staging/unisys/visorbus/visorchipset.c |   17 +++++++++--------
 2 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/unisys/visorbus/visorchannel.c b/drivers/staging/unisys/visorbus/visorchannel.c
index 20b63496e9f2..19c4a78a3617 100644
--- a/drivers/staging/unisys/visorbus/visorchannel.c
+++ b/drivers/staging/unisys/visorbus/visorchannel.c
@@ -21,6 +21,7 @@
  */
 
 #include <linux/uuid.h>
+#include <linux/io.h>
 
 #include "version.h"
 #include "visorbus.h"
@@ -36,7 +37,7 @@ static const uuid_le spar_video_guid = SPAR_CONSOLEVIDEO_CHANNEL_PROTOCOL_GUID;
 struct visorchannel {
 	u64 physaddr;
 	ulong nbytes;
-	void __iomem *mapped;
+	void *mapped;
 	bool requested;
 	struct channel_header chan_hdr;
 	uuid_le guid;
@@ -93,7 +94,7 @@ visorchannel_create_guts(u64 physaddr, unsigned long channel_bytes,
 		}
 	}
 
-	channel->mapped = ioremap_cache(physaddr, size);
+	channel->mapped = memremap(physaddr, size, MEMREMAP_WB);
 	if (!channel->mapped) {
 		release_mem_region(physaddr, size);
 		goto cleanup;
@@ -113,7 +114,7 @@ visorchannel_create_guts(u64 physaddr, unsigned long channel_bytes,
 	if (uuid_le_cmp(guid, NULL_UUID_LE) == 0)
 		guid = channel->chan_hdr.chtype;
 
-	iounmap(channel->mapped);
+	memunmap(channel->mapped);
 	if (channel->requested)
 		release_mem_region(channel->physaddr, channel->nbytes);
 	channel->mapped = NULL;
@@ -126,7 +127,8 @@ visorchannel_create_guts(u64 physaddr, unsigned long channel_bytes,
 		}
 	}
 
-	channel->mapped = ioremap_cache(channel->physaddr, channel_bytes);
+	channel->mapped = memremap(channel->physaddr, channel_bytes,
+			MEMREMAP_WB);
 	if (!channel->mapped) {
 		release_mem_region(channel->physaddr, channel_bytes);
 		goto cleanup;
@@ -167,7 +169,7 @@ visorchannel_destroy(struct visorchannel *channel)
 	if (!channel)
 		return;
 	if (channel->mapped) {
-		iounmap(channel->mapped);
+		memunmap(channel->mapped);
 		if (channel->requested)
 			release_mem_region(channel->physaddr, channel->nbytes);
 	}
@@ -241,7 +243,7 @@ visorchannel_read(struct visorchannel *channel, ulong offset,
 	if (offset + nbytes > channel->nbytes)
 		return -EIO;
 
-	memcpy_fromio(local, channel->mapped + offset, nbytes);
+	memcpy(local, channel->mapped + offset, nbytes);
 
 	return 0;
 }
@@ -262,7 +264,7 @@ visorchannel_write(struct visorchannel *channel, ulong offset,
 		memcpy(&channel->chan_hdr + offset, local, copy_size);
 	}
 
-	memcpy_toio(channel->mapped + offset, local, nbytes);
+	memcpy(channel->mapped + offset, local, nbytes);
 
 	return 0;
 }
diff --git a/drivers/staging/unisys/visorbus/visorchipset.c b/drivers/staging/unisys/visorbus/visorchipset.c
index bb8087e70127..e3c55ccf929b 100644
--- a/drivers/staging/unisys/visorbus/visorchipset.c
+++ b/drivers/staging/unisys/visorbus/visorchipset.c
@@ -119,7 +119,7 @@ static struct visorchannel *controlvm_channel;
 
 /* Manages the request payload in the controlvm channel */
 struct visor_controlvm_payload_info {
-	u8 __iomem *ptr;	/* pointer to base address of payload pool */
+	u8 *ptr;		/* pointer to base address of payload pool */
 	u64 offset;		/* offset from beginning of controlvm
 				 * channel to beginning of payload * pool */
 	u32 bytes;		/* number of bytes in payload pool */
@@ -401,21 +401,22 @@ parser_init_byte_stream(u64 addr, u32 bytes, bool local, bool *retry)
 		p = __va((unsigned long) (addr));
 		memcpy(ctx->data, p, bytes);
 	} else {
-		void __iomem *mapping;
+		void *mapping;
 
 		if (!request_mem_region(addr, bytes, "visorchipset")) {
 			rc = NULL;
 			goto cleanup;
 		}
 
-		mapping = ioremap_cache(addr, bytes);
+		mapping = memremap(addr, bytes, MEMREMAP_WB);
 		if (!mapping) {
 			release_mem_region(addr, bytes);
 			rc = NULL;
 			goto cleanup;
 		}
-		memcpy_fromio(ctx->data, mapping, bytes);
+		memcpy(ctx->data, mapping, bytes);
 		release_mem_region(addr, bytes);
+		memunmap(mapping);
 	}
 
 	ctx->byte_stream = true;
@@ -1327,7 +1328,7 @@ static int
 initialize_controlvm_payload_info(u64 phys_addr, u64 offset, u32 bytes,
 				  struct visor_controlvm_payload_info *info)
 {
-	u8 __iomem *payload = NULL;
+	u8 *payload = NULL;
 	int rc = CONTROLVM_RESP_SUCCESS;
 
 	if (!info) {
@@ -1339,7 +1340,7 @@ initialize_controlvm_payload_info(u64 phys_addr, u64 offset, u32 bytes,
 		rc = -CONTROLVM_RESP_ERROR_PAYLOAD_INVALID;
 		goto cleanup;
 	}
-	payload = ioremap_cache(phys_addr + offset, bytes);
+	payload = memremap(phys_addr + offset, bytes, MEMREMAP_WB);
 	if (!payload) {
 		rc = -CONTROLVM_RESP_ERROR_IOREMAP_FAILED;
 		goto cleanup;
@@ -1352,7 +1353,7 @@ initialize_controlvm_payload_info(u64 phys_addr, u64 offset, u32 bytes,
 cleanup:
 	if (rc < 0) {
 		if (payload) {
-			iounmap(payload);
+			memunmap(payload);
 			payload = NULL;
 		}
 	}
@@ -1363,7 +1364,7 @@ static void
 destroy_controlvm_payload_info(struct visor_controlvm_payload_info *info)
 {
 	if (info->ptr) {
-		iounmap(info->ptr);
+		memunmap(info->ptr);
 		info->ptr = NULL;
 	}
 	memset(info, 0, sizeof(struct visor_controlvm_payload_info));

