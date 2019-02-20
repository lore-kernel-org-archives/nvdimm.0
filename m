From: Dexuan Cui <decui-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: [ndctl PATCH v2 4/4] ndctl, monitor: support NVDIMM_FAMILY_HYPERV
Date: Wed, 20 Feb 2019 05:11:40 +0000
Message-ID: <PU1P153MB01691E80896E9EAA0C8245EDBF7D0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
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


Currently "ndctl monitor" fails for NVDIMM_FAMILY_HYPERV due to
"no smart support".

NVDIMM_FAMILY_HYPERV doesn't use ND_CMD_SMART to get the health info.
Instead, it uses ND_CMD_CALL, so the checking here can't apply,and it
doesn't support threshold alarms -- actually it only supports one event:
ND_EVENT_HEALTH_STATE.

See http://www.uefi.org/RFIC_LIST ("Virtual NVDIMM 0x1901").

Let's skip the unnecessary checking for NVDIMM_FAMILY_HYPERV, and make
sure we only monitor the "dimm-health-state" event and ignore the others.

With the patch, when an error happens, we log it with such a message:

{"timestamp":"1550547497.431731497","pid":1571,"event":
{"dimm-health-state":true},"dimm":{"dev":"nmem1",
"id":"04d5-01-1701-01000000","handle":1,"phys_id":0,
"health":{"health_state":"fatal","shutdown_count":8}}}

Here the meaningful info is:
"health":{"health_state":"fatal","shutdown_count":8}

Signed-off-by: Dexuan Cui <decui-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 ndctl/monitor.c | 42 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 35 insertions(+), 7 deletions(-)

diff --git a/ndctl/monitor.c b/ndctl/monitor.c
index 43b2abe..43beb06 100644
--- a/ndctl/monitor.c
+++ b/ndctl/monitor.c
@@ -265,31 +265,59 @@ static bool filter_region(struct ndctl_region *region,
 	return true;
 }
 
-static void filter_dimm(struct ndctl_dimm *dimm, struct util_filter_ctx *fctx)
+static bool ndctl_dimm_test_and_enable_notification(struct ndctl_dimm *dimm)
 {
-	struct monitor_dimm *mdimm;
-	struct monitor_filter_arg *mfa = fctx->monitor;
 	const char *name = ndctl_dimm_get_devname(dimm);
 
+	/*
+	 * Hyper-V Virtual NVDIMM doesn't use ND_CMD_SMART to get the health
+	 * info. Instead, it uses ND_CMD_CALL, so the checking here can't
+	 * apply, and it doesn't support threshold alarms -- actually it only
+	 * supports one event: ND_EVENT_HEALTH_STATE.
+	 */
+	if (ndctl_dimm_get_cmd_family(dimm) == NVDIMM_FAMILY_HYPERV) {
+		if (monitor.event_flags != ND_EVENT_HEALTH_STATE) {
+			monitor.event_flags = ND_EVENT_HEALTH_STATE;
+
+			notice(&monitor,
+				"%s: only dimm-health-state can be monitored\n",
+				name);
+		}
+		return true;
+	}
+
 	if (!ndctl_dimm_is_cmd_supported(dimm, ND_CMD_SMART)) {
 		err(&monitor, "%s: no smart support\n", name);
-		return;
+		return false;
 	}
 	if (!ndctl_dimm_is_cmd_supported(dimm, ND_CMD_SMART_THRESHOLD)) {
 		err(&monitor, "%s: no smart threshold support\n", name);
-		return;
+		return false;
 	}
 
 	if (!ndctl_dimm_is_flag_supported(dimm, ND_SMART_ALARM_VALID)) {
 		err(&monitor, "%s: smart alarm invalid\n", name);
-		return;
+		return false;
 	}
 
 	if (enable_dimm_supported_threshold_alarms(dimm)) {
 		err(&monitor, "%s: enable supported threshold alarms failed\n", name);
-		return;
+		return false;
 	}
 
+	return true;
+}
+
+static void filter_dimm(struct ndctl_dimm *dimm, struct util_filter_ctx *fctx)
+{
+	struct monitor_dimm *mdimm;
+	struct monitor_filter_arg *mfa = fctx->monitor;
+	const char *name = ndctl_dimm_get_devname(dimm);
+
+
+	if (!ndctl_dimm_test_and_enable_notification(dimm))
+		return;
+
 	mdimm = calloc(1, sizeof(struct monitor_dimm));
 	if (!mdimm) {
 		err(&monitor, "%s: calloc for monitor dimm failed\n", name);
-- 
2.19.1
