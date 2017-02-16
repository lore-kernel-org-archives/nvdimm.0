Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 36E52820F7
 for <linux-nvdimm@lists.01.org>; Thu, 16 Feb 2017 13:58:04 -0800 (PST)
Subject: [PATCH v2 2/2] mm: validate device_hotplug is held for memory hotplug
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 16 Feb 2017 13:53:58 -0800
Message-ID: <148728203880.38457.1158394701925100383.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <148728202805.38457.18028105614854319884.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <148728202805.38457.18028105614854319884.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: akpm@linux-foundation.org
Cc: Michal Hocko <mhocko@suse.com>, linux-nvdimm@lists.01.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org, Ben Hutchings <ben@decadent.org.uk>, Vlastimil Babka <vbabka@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

mem_hotplug_begin() assumes that it can set mem_hotplug.active_writer
and run the hotplug process without racing another thread. Validate this
assumption with a lockdep assertion.

Cc: Michal Hocko <mhocko@suse.com>
Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reported-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/base/core.c    |    5 +++++
 include/linux/device.h |    1 +
 mm/memory_hotplug.c    |    2 ++
 3 files changed, 8 insertions(+)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 8c25e68e67d7..3050e6f99403 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -638,6 +638,11 @@ int lock_device_hotplug_sysfs(void)
 	return restart_syscall();
 }
 
+void assert_held_device_hotplug(void)
+{
+	lockdep_assert_held(&device_hotplug_lock);
+}
+
 #ifdef CONFIG_BLOCK
 static inline int device_is_not_partition(struct device *dev)
 {
diff --git a/include/linux/device.h b/include/linux/device.h
index 491b4c0ca633..815965ee55dd 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -1135,6 +1135,7 @@ static inline bool device_supports_offline(struct device *dev)
 extern void lock_device_hotplug(void);
 extern void unlock_device_hotplug(void);
 extern int lock_device_hotplug_sysfs(void);
+void assert_held_device_hotplug(void);
 extern int device_offline(struct device *dev);
 extern int device_online(struct device *dev);
 extern void set_primary_fwnode(struct device *dev, struct fwnode_handle *fwnode);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index b8c11e063ff0..1635a2a085e5 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -126,6 +126,8 @@ void put_online_mems(void)
 
 void mem_hotplug_begin(void)
 {
+	assert_held_device_hotplug();
+
 	mem_hotplug.active_writer = current;
 
 	memhp_lock_acquire();

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
