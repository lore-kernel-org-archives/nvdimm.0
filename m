From: Vishal Verma <vishal.l.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [ndctl PATCH v2 1/2] libdaxctl: fix the system-ram capability check
Date: Wed,  4 Sep 2019 19:13:13 -0600
Message-ID: <20190905011314.18610-1-vishal.l.verma@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Cc: Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Brice Goglin <Brice.Goglin-MZpvjPyXg2s@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

When checking a daxctl device for system-ram capability, we needn't look
at the symlink resolution for /sys/bus/dax.../driver/module since the
driver in question may not always have an associated module, and could
be builtin instead.

Change the symlink we resolve to simply '/sys/bus/dax.../driver' and
since that too resolves to '.../kmem' in the system-ram case, the
rest of the check remains unchanged.

This is a pre-requisite to making daxctl-reconfigure-device work
correctly when the target mode's driver might be builtin.

Cc: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Vishal Verma <vishal.l.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

v2: Collect Reviewed-by tags

 daxctl/lib/libdaxctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
index c0a859c..d9f2c33 100644
--- a/daxctl/lib/libdaxctl.c
+++ b/daxctl/lib/libdaxctl.c
@@ -406,7 +406,7 @@ static int dev_is_system_ram_capable(struct daxctl_dev *dev)
 	if (!daxctl_dev_is_enabled(dev))
 		return false;
 
-	if (snprintf(path, len, "%s/driver/module", dev->dev_path) >= len) {
+	if (snprintf(path, len, "%s/driver", dev->dev_path) >= len) {
 		err(ctx, "%s: buffer too small!\n", devname);
 		return false;
 	}
-- 
2.20.1
