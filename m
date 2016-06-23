From: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/3] daxctl_region_unref: fix a potential null pointer
 dereference
Date: Thu, 23 Jun 2016 15:59:49 -0400
Message-ID: <20160623195950.30968-3-jmoyer@redhat.com>
References: <20160623195950.30968-1-jmoyer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20160623195950.30968-1-jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

Move the assignment of ctx to after the NULL check.

Signed-off-by: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 daxctl/lib/libdaxctl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
index a8ad58d..9d71a29 100644
--- a/daxctl/lib/libdaxctl.c
+++ b/daxctl/lib/libdaxctl.c
@@ -181,7 +181,7 @@ static void free_dev(struct daxctl_dev *dev, struct list_head *head)
 
 DAXCTL_EXPORT void daxctl_region_unref(struct daxctl_region *region)
 {
-	struct daxctl_ctx *ctx = region->ctx;
+	struct daxctl_ctx *ctx;
 	struct daxctl_dev *dev, *_d;
 
 	if (!region)
@@ -190,6 +190,7 @@ DAXCTL_EXPORT void daxctl_region_unref(struct daxctl_region *region)
 	if (region->refcount)
 		return;
 
+	ctx = region->ctx;
 	info(ctx, "region%d released\n", region->id);
 	list_for_each_safe(&region->devices, dev, _d, list)
 		free_dev(dev, &region->devices);
-- 
2.8.2.335.g4bb51ae
