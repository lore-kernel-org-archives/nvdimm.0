From: Pankaj Gupta <pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [RFC v2 2/2] pmem: device flush over VIRTIO
Date: Wed, 25 Apr 2018 16:54:14 +0530
Message-ID: <20180425112415.12327-3-pagupta@redhat.com>
References: <20180425112415.12327-1-pagupta@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20180425112415.12327-1-pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: kwolf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, xiaoguangrong.eric-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org, niteshnarayanlal-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ross.zwisler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, stefanha-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, imammedo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, marcel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, nilal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

This patch adds functionality to perform 
flush from guest to hosy over VIRTIO 
when 'ND_REGION_VIRTIO'flag is set on 
nd_negion. Flag is set by 'virtio-pmem'
driver.

Signed-off-by: Pankaj Gupta <pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/nvdimm/region_devs.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index a612be6..6c6454e 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -20,6 +20,7 @@
 #include <linux/nd.h>
 #include "nd-core.h"
 #include "nd.h"
+#include <linux/virtio_pmem.h>
 
 /*
  * For readq() and writeq() on 32-bit builds, the hi-lo, lo-hi order is
@@ -1074,6 +1075,12 @@ void nvdimm_flush(struct nd_region *nd_region)
 	struct nd_region_data *ndrd = dev_get_drvdata(&nd_region->dev);
 	int i, idx;
 
+       /* call PV device flush */
+	if (test_bit(ND_REGION_VIRTIO, &nd_region->flags)) {
+		virtio_pmem_flush(&nd_region->dev);
+		return;
+	}
+
 	/*
 	 * Try to encourage some diversity in flush hint addresses
 	 * across cpus assuming a limited number of flush hints.
-- 
2.9.3
