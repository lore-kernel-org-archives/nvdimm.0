From: "Cheng-mean Liu (SOCCER)" <soccerl-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: [PATCH] NVDIMM: Reduced-the-ND_MIN_NAMESPACE_SIZE-from-4MB-to-4KB
Date: Thu, 11 Jan 2018 18:49:17 +0000
Message-ID: <MWHPR21MB074927A9495B1E121D7C8DF2A6160@MWHPR21MB0749.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

In the case of emulated NVDIMM devices in the VM environment, there
are scenarios that NVDIMM device with much smaller sizes are desired, for example, we might
use a single enumerated NVDIMM DAX device for representing each container layer, which in some
cases could be just a few KBs size.The current ND_MIN_NAMESPACE_SIZE is 4MB. To avoid wasting
address and inefficient zero padding for meeting this 4MB min requirement, the proposed change is to
reduce it to 4KB, a single page size, is a size good for all platforms.

Two patches are included in this request :

1. A patch for Linux kernel changes
2. A patch for ndctl project to keep it in sync with the Linux kernel header file


>From 29e173c32661d976cda073438979991167ee13fc Mon Sep 17 00:00:00 2001
From: Cheng-mean Liu <soccerl-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Date: Thu, 11 Jan 2018 10:06:13 -0800
Subject: [PATCH] reduced the ND_MIN_NAMESPACE_SIZE from 4MB to 4KB

Signed-off-by: Cheng-mean Liu <soccerl-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
include/uapi/linux/ndctl.h | 2 +-
1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/ndctl.h b/include/uapi/linux/ndctl.h
index 3f03567631cb..e63c201ed1ef 100644
--- a/include/uapi/linux/ndctl.h
+++ b/include/uapi/linux/ndctl.h
@@ -263,7 +263,7 @@ enum nd_driver_flags {
};
 enum {
-              ND_MIN_NAMESPACE_SIZE = 0x00400000,
+             ND_MIN_NAMESPACE_SIZE = 0x00001000,
};
 enum ars_masks {
--
2.11.0



>From 2bf3e2bbfae81ab50d141571414c0e6556bc0e0c Mon Sep 17 00:00:00 2001
From: Cheng-mean Liu <soccerl-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Date: Thu, 11 Jan 2018 10:02:52 -0800
Subject: [PATCH] reduced the ND_MIN_NAMESPACE_SIZE from 4MB to 4KB

Signed-off-by: Cheng-mean Liu <soccerl-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
ndctl/ndctl.h    | 2 +-
test/dpa-alloc.c | 6 ++++++
2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/ndctl/ndctl.h b/ndctl/ndctl.h
index 5e6905c..8c14d90 100644
--- a/ndctl/ndctl.h
+++ b/ndctl/ndctl.h
@@ -263,7 +263,7 @@ enum nd_driver_flags {
};
 enum {
-              ND_MIN_NAMESPACE_SIZE = 0x00400000,
+             ND_MIN_NAMESPACE_SIZE = 0x00001000,
};
 enum ars_masks {
diff --git a/test/dpa-alloc.c b/test/dpa-alloc.c
index d13cf5d..ba3deed 100644
--- a/test/dpa-alloc.c
+++ b/test/dpa-alloc.c
@@ -237,6 +237,12 @@ static int do_test(struct ndctl_ctx *ctx, struct ndctl_test *test)
                                uuid_unparse(namespaces[i].uuid, uuid_str);
                               size = ndctl_namespace_get_size(victim);
+
+                             rc = ndctl_namespace_disable_invalidate(victim);
+                if (rc) {
+                                             fprintf(stderr, "failed to disable %s\n", uuid_str);
+                                             return rc;
+                             }
                               rc = ndctl_namespace_delete(victim);
                               if (rc) {
                                               fprintf(stderr, "failed to delete %s\n", uuid_str);
--
2.11.0
