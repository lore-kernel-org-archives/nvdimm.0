From: Pankaj Gupta <pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/3] nd: move nd_region to common header
Date: Fri, 31 Aug 2018 19:00:16 +0530
Message-ID: <20180831133019.27579-2-pagupta@redhat.com>
References: <20180831133019.27579-1-pagupta@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20180831133019.27579-1-pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org
Cc: kwolf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, xiaoguangrong.eric-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org, niteshnarayanlal-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ross.zwisler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, stefanha-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, imammedo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, nilal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, eblake-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

This patch moves nd_region definition to common header
include/linux/nd.h file. This is required for flush callback 
support for both virtio-pmem & pmem driver.

Signed-off-by: Pankaj Gupta <pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/nvdimm/nd.h | 39 ---------------------------------------
 include/linux/nd.h  | 40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+), 39 deletions(-)

diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 98317e7..d079a2b 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -123,45 +123,6 @@ enum nd_mapping_lock_class {
 	ND_MAPPING_UUID_SCAN,
 };
 
-struct nd_mapping {
-	struct nvdimm *nvdimm;
-	u64 start;
-	u64 size;
-	int position;
-	struct list_head labels;
-	struct mutex lock;
-	/*
-	 * @ndd is for private use at region enable / disable time for
-	 * get_ndd() + put_ndd(), all other nd_mapping to ndd
-	 * conversions use to_ndd() which respects enabled state of the
-	 * nvdimm.
-	 */
-	struct nvdimm_drvdata *ndd;
-};
-
-struct nd_region {
-	struct device dev;
-	struct ida ns_ida;
-	struct ida btt_ida;
-	struct ida pfn_ida;
-	struct ida dax_ida;
-	unsigned long flags;
-	struct device *ns_seed;
-	struct device *btt_seed;
-	struct device *pfn_seed;
-	struct device *dax_seed;
-	u16 ndr_mappings;
-	u64 ndr_size;
-	u64 ndr_start;
-	int id, num_lanes, ro, numa_node;
-	void *provider_data;
-	struct kernfs_node *bb_state;
-	struct badblocks bb;
-	struct nd_interleave_set *nd_set;
-	struct nd_percpu_lane __percpu *lane;
-	struct nd_mapping mapping[0];
-};
-
 struct nd_blk_region {
 	int (*enable)(struct nvdimm_bus *nvdimm_bus, struct device *dev);
 	int (*do_io)(struct nd_blk_region *ndbr, resource_size_t dpa,
diff --git a/include/linux/nd.h b/include/linux/nd.h
index 43c181a..b9da9f7 100644
--- a/include/linux/nd.h
+++ b/include/linux/nd.h
@@ -120,6 +120,46 @@ struct nd_namespace_blk {
 	struct resource **res;
 };
 
+struct nd_mapping {
+	struct nvdimm *nvdimm;
+	u64 start;
+	u64 size;
+	int position;
+	struct list_head labels;
+	struct mutex lock;
+	/*
+	 * @ndd is for private use at region enable / disable time for
+	 * get_ndd() + put_ndd(), all other nd_mapping to ndd
+	 * conversions use to_ndd() which respects enabled state of the
+	 * nvdimm.
+	 */
+	struct nvdimm_drvdata *ndd;
+};
+
+struct nd_region {
+	struct device dev;
+	struct ida ns_ida;
+	struct ida btt_ida;
+	struct ida pfn_ida;
+	struct ida dax_ida;
+	unsigned long flags;
+	struct device *ns_seed;
+	struct device *btt_seed;
+	struct device *pfn_seed;
+	struct device *dax_seed;
+	u16 ndr_mappings;
+	u64 ndr_size;
+	u64 ndr_start;
+	int id, num_lanes, ro, numa_node;
+	void *provider_data;
+	struct kernfs_node *bb_state;
+	struct badblocks bb;
+	struct nd_interleave_set *nd_set;
+	struct nd_percpu_lane __percpu *lane;
+	int (*flush)(struct nd_region *nd_region);
+	struct nd_mapping mapping[0];
+};
+
 static inline struct nd_namespace_io *to_nd_namespace_io(const struct device *dev)
 {
 	return container_of(dev, struct nd_namespace_io, common.dev);
-- 
2.9.3
