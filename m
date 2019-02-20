From: Dexuan Cui <decui-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: [ndctl PATCH v2 3/4] ndctl, lib: implement ndctl_dimm_get_cmd_family()
Date: Wed, 20 Feb 2019 05:11:10 +0000
Message-ID: <PU1P153MB01696E7773E8C8129D8CCE8BBF7D0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
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
To: Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vishal Verma <vishal.l.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Michael Kelley <mikelley-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, "qi.fuli-LMvhtfratI1BDgjK7y7TUQ@public.gmane.org" <qi.fuli-LMvhtfratI1BDgjK7y7TUQ@public.gmane.org>, Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org


Let's export the family info so we can do some family-specific
handling in ndctl/monitor.c for Hyper-V NVDIMM.

Signed-off-by: Dexuan Cui <decui-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 ndctl/lib/libndctl.c   | 5 +++++
 ndctl/lib/libndctl.sym | 1 +
 ndctl/libndctl.h       | 1 +
 3 files changed, 7 insertions(+)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 48bdb27..1186579 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -1550,6 +1550,11 @@ NDCTL_EXPORT struct ndctl_dimm *ndctl_dimm_get_next(struct ndctl_dimm *dimm)
 	return list_next(&bus->dimms, dimm, list);
 }
 
+NDCTL_EXPORT unsigned long ndctl_dimm_get_cmd_family(struct ndctl_dimm *dimm)
+{
+	return dimm->cmd_family;
+}
+
 NDCTL_EXPORT unsigned int ndctl_dimm_get_handle(struct ndctl_dimm *dimm)
 {
 	return dimm->handle;
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index cb9f769..470e895 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -38,6 +38,7 @@ global:
 	ndctl_bus_wait_probe;
 	ndctl_dimm_get_first;
 	ndctl_dimm_get_next;
+	ndctl_dimm_get_cmd_family;
 	ndctl_dimm_get_handle;
 	ndctl_dimm_get_phys_id;
 	ndctl_dimm_get_vendor;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index 0debdb6..cb5a8fc 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -145,6 +145,7 @@ struct ndctl_dimm *ndctl_dimm_get_next(struct ndctl_dimm *dimm);
         for (dimm = ndctl_dimm_get_first(bus); \
              dimm != NULL; \
              dimm = ndctl_dimm_get_next(dimm))
+unsigned long ndctl_dimm_get_cmd_family(struct ndctl_dimm *dimm);
 unsigned int ndctl_dimm_get_handle(struct ndctl_dimm *dimm);
 unsigned short ndctl_dimm_get_phys_id(struct ndctl_dimm *dimm);
 unsigned short ndctl_dimm_get_vendor(struct ndctl_dimm *dimm);
-- 
2.19.1
