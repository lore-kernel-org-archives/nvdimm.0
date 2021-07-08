Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FFC72F80
	for <nvdimm@lists.linux.dev>; Thu,  8 Jul 2021 02:57:45 +0000 (UTC)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1682WcIJ040566;
	Wed, 7 Jul 2021 22:57:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=xTolbnPclvjSKICHqt43IXDMVoLg6T/a7Ux5EZe4YzU=;
 b=Wq1Lr5xMOWlrVfNt63ZCIPLM5Fat7bHTTF+OkERZw0xc4aze1SyvM5CLIPPZDVtltllB
 LjnbP/WQrJ2+E92aVK29uoE2svUpZBoEy4b+mPrAtjxCVkjZMIlMY3MnR8us0oCKQljH
 cGtoASK+scl3GpH6UGVOKn3wOssh/Oi6Jhypdd3nQ5w9JMXm3ZMNd9L+C82uGY9zqyQg
 7svNti52g0VXxUmmwlSO1gvwcW3SHfwhcCRBI+tPn+XjKX2ELowVWBpGqgqSN8vWsVAE
 zxwcweyIFYhlVhEB05gAEk1gBNhS2REhsGEsj6iScxOay/JVqb6Ph3e86/sWkh6oMXD4 1g== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
	by mx0a-001b2d01.pphosted.com with ESMTP id 39m5q37898-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 Jul 2021 22:57:28 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
	by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1682tKfF028212;
	Thu, 8 Jul 2021 02:57:26 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
	by ppma03ams.nl.ibm.com with ESMTP id 39jfh8syvp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Jul 2021 02:57:26 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
	by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1682vNhc20054460
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 8 Jul 2021 02:57:23 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A34934204B;
	Thu,  8 Jul 2021 02:57:23 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 596B242042;
	Thu,  8 Jul 2021 02:57:22 +0000 (GMT)
Received: from lep8c.aus.stglabs.ibm.com (unknown [9.40.192.207])
	by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Thu,  8 Jul 2021 02:57:22 +0000 (GMT)
Subject: [PATCH REBASED v5 1/2] spapr: nvdimm: Implement H_SCM_FLUSH hcall
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: david@gibson.dropbear.id.au, groug@kaod.org, qemu-ppc@nongnu.org
Cc: qemu-devel@nongnu.org, aneesh.kumar@linux.ibm.com, nvdimm@lists.linux.dev,
        kvm-ppc@vger.kernel.org, bharata@linux.vnet.ibm.com
Date: Wed, 07 Jul 2021 21:57:21 -0500
Message-ID: 
 <162571303048.1030381.13893352223345979621.stgit@lep8c.aus.stglabs.ibm.com>
In-Reply-To: 
 <162571302321.1030381.15196355582642786915.stgit@lep8c.aus.stglabs.ibm.com>
References: 
 <162571302321.1030381.15196355582642786915.stgit@lep8c.aus.stglabs.ibm.com>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 6qXvmxqb_7OOEX8tEyF6bu7gSX6r5dyc
X-Proofpoint-GUID: 6qXvmxqb_7OOEX8tEyF6bu7gSX6r5dyc
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-08_01:2021-07-06,2021-07-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 bulkscore=0 clxscore=1015 impostorscore=0 priorityscore=1501 spamscore=0
 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107080011

The patch adds support for the SCM flush hcall for the nvdimm devices.
To be available for exploitation by guest through the next patch.

The hcall expects the semantics such that the flush to return
with one of H_LONG_BUSY when the operation is expected to take longer
time along with a continue_token. The hcall to be called again providing
the continue_token to get the status. So, all fresh requests are put into
a 'pending' list and flush worker is submitted to the thread pool. The
thread pool completion callbacks move the requests to 'completed' list,
which are cleaned up after reporting to guest in subsequent hcalls to
get the status.

The semantics makes it necessary to preserve the continue_tokens and
their return status across migrations. So, the completed flush states
are forwarded to the destination and the pending ones are restarted
at the destination in post_load. The necessary nvdimm flush specific
vmstate structures are added to the spapr machine vmstate.

Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
---
 hw/ppc/spapr.c                |    6 +
 hw/ppc/spapr_nvdimm.c         |  240 +++++++++++++++++++++++++++++++++++++++++
 include/hw/ppc/spapr.h        |   11 ++
 include/hw/ppc/spapr_nvdimm.h |   13 ++
 4 files changed, 269 insertions(+), 1 deletion(-)

diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
index 4dd90b75cc..546d825dde 100644
--- a/hw/ppc/spapr.c
+++ b/hw/ppc/spapr.c
@@ -1622,6 +1622,8 @@ static void spapr_machine_reset(MachineState *machine)
         spapr->ov5_cas = spapr_ovec_clone(spapr->ov5);
     }
 
+    spapr_nvdimm_finish_flushes(spapr);
+
     /* DRC reset may cause a device to be unplugged. This will cause troubles
      * if this device is used by another device (eg, a running vhost backend
      * will crash QEMU if the DIMM holding the vring goes away). To avoid such
@@ -2018,6 +2020,7 @@ static const VMStateDescription vmstate_spapr = {
         &vmstate_spapr_cap_ccf_assist,
         &vmstate_spapr_cap_fwnmi,
         &vmstate_spapr_fwnmi,
+        &vmstate_spapr_nvdimm_states,
         NULL
     }
 };
@@ -3014,6 +3017,9 @@ static void spapr_machine_init(MachineState *machine)
     }
 
     qemu_cond_init(&spapr->fwnmi_machine_check_interlock_cond);
+
+    QLIST_INIT(&spapr->pending_flush_states);
+    QLIST_INIT(&spapr->completed_flush_states);
 }
 
 #define DEFAULT_KVM_TYPE "auto"
diff --git a/hw/ppc/spapr_nvdimm.c b/hw/ppc/spapr_nvdimm.c
index 91de1052f2..4f8931ab15 100644
--- a/hw/ppc/spapr_nvdimm.c
+++ b/hw/ppc/spapr_nvdimm.c
@@ -22,6 +22,7 @@
  * THE SOFTWARE.
  */
 #include "qemu/osdep.h"
+#include "qemu/cutils.h"
 #include "qapi/error.h"
 #include "hw/ppc/spapr_drc.h"
 #include "hw/ppc/spapr_nvdimm.h"
@@ -30,6 +31,7 @@
 #include "hw/ppc/fdt.h"
 #include "qemu/range.h"
 #include "hw/ppc/spapr_numa.h"
+#include "block/thread-pool.h"
 
 /* DIMM health bitmap bitmap indicators. Taken from kernel's papr_scm.c */
 /* SCM device is unable to persist memory contents */
@@ -375,6 +377,243 @@ static target_ulong h_scm_bind_mem(PowerPCCPU *cpu, SpaprMachineState *spapr,
     return H_SUCCESS;
 }
 
+static uint64_t flush_token;
+
+static int flush_worker_cb(void *opaque)
+{
+    int ret = H_SUCCESS;
+    SpaprNVDIMMDeviceFlushState *state = opaque;
+
+    /* flush raw backing image */
+    if (qemu_fdatasync(state->backend_fd) < 0) {
+        error_report("papr_scm: Could not sync nvdimm to backend file: %s",
+                     strerror(errno));
+        ret = H_HARDWARE;
+    }
+
+    return ret;
+}
+
+static void spapr_nvdimm_flush_completion_cb(void *opaque, int hcall_ret)
+{
+    SpaprMachineState *spapr = SPAPR_MACHINE(qdev_get_machine());
+    SpaprNVDIMMDeviceFlushState *state = opaque;
+
+    state->hcall_ret = hcall_ret;
+    QLIST_REMOVE(state, node);
+    QLIST_INSERT_HEAD(&spapr->completed_flush_states, state, node);
+}
+
+static const VMStateDescription vmstate_spapr_nvdimm_flush_state = {
+     .name = "spapr_nvdimm_flush_state",
+     .version_id = 1,
+     .minimum_version_id = 1,
+     .fields = (VMStateField[]) {
+         VMSTATE_UINT64(continue_token, SpaprNVDIMMDeviceFlushState),
+         VMSTATE_INT64(hcall_ret, SpaprNVDIMMDeviceFlushState),
+         VMSTATE_UINT32(drcidx, SpaprNVDIMMDeviceFlushState),
+         VMSTATE_END_OF_LIST()
+     },
+};
+
+static bool spapr_nvdimm_states_needed(void *opaque)
+{
+     SpaprMachineState *spapr = (SpaprMachineState *)opaque;
+
+     return (!QLIST_EMPTY(&spapr->pending_flush_states) ||
+             !QLIST_EMPTY(&spapr->completed_flush_states));
+}
+
+static int spapr_nvdimm_post_load(void *opaque, int version_id)
+{
+    SpaprMachineState *spapr = (SpaprMachineState *)opaque;
+    SpaprNVDIMMDeviceFlushState *state, *next;
+    PCDIMMDevice *dimm;
+    HostMemoryBackend *backend = NULL;
+    ThreadPool *pool = aio_get_thread_pool(qemu_get_aio_context());
+    SpaprDrc *drc;
+
+    QLIST_FOREACH_SAFE(state, &spapr->completed_flush_states, node, next) {
+        if (flush_token < state->continue_token) {
+            flush_token = state->continue_token;
+        }
+    }
+
+    QLIST_FOREACH_SAFE(state, &spapr->pending_flush_states, node, next) {
+        if (flush_token < state->continue_token) {
+            flush_token = state->continue_token;
+        }
+
+        drc = spapr_drc_by_index(state->drcidx);
+        dimm = PC_DIMM(drc->dev);
+        backend = MEMORY_BACKEND(dimm->hostmem);
+        state->backend_fd = memory_region_get_fd(&backend->mr);
+
+        thread_pool_submit_aio(pool, flush_worker_cb, state,
+                               spapr_nvdimm_flush_completion_cb, state);
+    }
+
+    return 0;
+}
+
+const VMStateDescription vmstate_spapr_nvdimm_states = {
+    .name = "spapr_nvdimm_states",
+    .version_id = 1,
+    .minimum_version_id = 1,
+    .needed = spapr_nvdimm_states_needed,
+    .post_load = spapr_nvdimm_post_load,
+    .fields = (VMStateField[]) {
+        VMSTATE_QLIST_V(completed_flush_states, SpaprMachineState, 1,
+                        vmstate_spapr_nvdimm_flush_state,
+                        SpaprNVDIMMDeviceFlushState, node),
+        VMSTATE_QLIST_V(pending_flush_states, SpaprMachineState, 1,
+                        vmstate_spapr_nvdimm_flush_state,
+                        SpaprNVDIMMDeviceFlushState, node),
+        VMSTATE_END_OF_LIST()
+    },
+};
+
+/*
+ * Assign a token and reserve it for the new flush state.
+ */
+static SpaprNVDIMMDeviceFlushState *spapr_nvdimm_init_new_flush_state(
+                                                      SpaprMachineState *spapr)
+{
+    SpaprNVDIMMDeviceFlushState *state;
+
+    state = g_malloc0(sizeof(*state));
+
+    flush_token++;
+    /* Token zero is presumed as no job pending. Handle the overflow to zero */
+    if (flush_token == 0) {
+        flush_token++;
+    }
+    state->continue_token = flush_token;
+
+    QLIST_INSERT_HEAD(&spapr->pending_flush_states, state, node);
+
+    return state;
+}
+
+/*
+ * spapr_nvdimm_finish_flushes
+ *      Waits for all pending flush requests to complete
+ *      their execution and free the states
+ */
+void spapr_nvdimm_finish_flushes(SpaprMachineState *spapr)
+{
+    SpaprNVDIMMDeviceFlushState *state, *next;
+
+    /*
+     * Called on reset path, the main loop thread which calls
+     * the pending BHs has gotten out running in the reset path,
+     * finally reaching here. Other code path being guest
+     * h_client_architecture_support, thats early boot up.
+     */
+    while (!QLIST_EMPTY(&spapr->pending_flush_states)) {
+        aio_poll(qemu_get_aio_context(), true);
+    }
+
+    QLIST_FOREACH_SAFE(state, &spapr->completed_flush_states, node, next) {
+        QLIST_REMOVE(state, node);
+        g_free(state);
+    }
+}
+
+/*
+ * spapr_nvdimm_get_flush_status
+ *      Fetches the status of the hcall worker and returns
+ *      H_LONG_BUSY_XYZ if the worker is still running.
+ */
+static int spapr_nvdimm_get_flush_status(SpaprMachineState *spapr,
+                                         uint64_t token)
+{
+    int ret = H_LONG_BUSY_ORDER_10_MSEC;
+    SpaprNVDIMMDeviceFlushState *state, *node;
+
+    QLIST_FOREACH_SAFE(state, &spapr->pending_flush_states, node, node) {
+        if (state->continue_token == token) {
+            goto exit;
+        }
+    }
+    ret = H_P2; /* If not found in complete list too, invalid token */
+    QLIST_FOREACH_SAFE(state, &spapr->completed_flush_states, node, node) {
+        if (state->continue_token == token) {
+            ret = state->hcall_ret;
+            QLIST_REMOVE(state, node);
+            g_free(state);
+            break;
+        }
+    }
+exit:
+    return ret;
+}
+
+/*
+ * H_SCM_FLUSH
+ * Input: drc_index, continue-token
+ * Out: continue-token
+ * Return Value: H_SUCCESS, H_Parameter, H_P2, H_LONG_BUSY
+ *
+ * Given a DRC Index Flush the data to backend NVDIMM device.
+ * The hcall returns H_LONG_BUSY_XX when the flush takes longer time and
+ * the hcall needs to be issued multiple times in order to be completely
+ * serviced. The continue-token from the output to be passed in the
+ * argument list of subsequent hcalls until the hcall is completely serviced
+ * at which point H_SUCCESS or other error is returned.
+ */
+static target_ulong h_scm_flush(PowerPCCPU *cpu, SpaprMachineState *spapr,
+                                target_ulong opcode, target_ulong *args)
+{
+    int ret;
+    uint32_t drc_index = args[0];
+    uint64_t continue_token = args[1];
+    SpaprDrc *drc = spapr_drc_by_index(drc_index);
+    PCDIMMDevice *dimm;
+    HostMemoryBackend *backend = NULL;
+    SpaprNVDIMMDeviceFlushState *state;
+    ThreadPool *pool = aio_get_thread_pool(qemu_get_aio_context());
+    int fd;
+
+    if (!drc || !drc->dev ||
+        spapr_drc_type(drc) != SPAPR_DR_CONNECTOR_TYPE_PMEM) {
+        return H_PARAMETER;
+    }
+
+    if (continue_token != 0) {
+        goto get_status;
+    }
+
+    dimm = PC_DIMM(drc->dev);
+    backend = MEMORY_BACKEND(dimm->hostmem);
+    fd = memory_region_get_fd(&backend->mr);
+
+    if (fd < 0) {
+        return H_UNSUPPORTED;
+    }
+
+    state = spapr_nvdimm_init_new_flush_state(spapr);
+    if (!state) {
+        return H_HARDWARE;
+    }
+
+    state->drcidx = drc_index;
+    state->backend_fd = fd;
+
+    thread_pool_submit_aio(pool, flush_worker_cb, state,
+                           spapr_nvdimm_flush_completion_cb, state);
+
+    continue_token = state->continue_token;
+
+get_status:
+    ret = spapr_nvdimm_get_flush_status(spapr, continue_token);
+    if (H_IS_LONG_BUSY(ret)) {
+        args[0] = continue_token;
+    }
+
+    return ret;
+}
+
 static target_ulong h_scm_unbind_mem(PowerPCCPU *cpu, SpaprMachineState *spapr,
                                      target_ulong opcode, target_ulong *args)
 {
@@ -523,6 +762,7 @@ static void spapr_scm_register_types(void)
     spapr_register_hypercall(H_SCM_UNBIND_MEM, h_scm_unbind_mem);
     spapr_register_hypercall(H_SCM_UNBIND_ALL, h_scm_unbind_all);
     spapr_register_hypercall(H_SCM_HEALTH, h_scm_health);
+    spapr_register_hypercall(H_SCM_FLUSH, h_scm_flush);
 }
 
 type_init(spapr_scm_register_types)
diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
index f05219f75e..1684d72546 100644
--- a/include/hw/ppc/spapr.h
+++ b/include/hw/ppc/spapr.h
@@ -12,10 +12,12 @@
 #include "hw/ppc/spapr_xive.h"  /* For SpaprXive */
 #include "hw/ppc/xics.h"        /* For ICSState */
 #include "hw/ppc/spapr_tpm_proxy.h"
+#include "hw/ppc/spapr_nvdimm.h"
 
 struct SpaprVioBus;
 struct SpaprPhbState;
 struct SpaprNvram;
+struct SpaprNVDIMMDeviceFlushState;
 
 typedef struct SpaprEventLogEntry SpaprEventLogEntry;
 typedef struct SpaprEventSource SpaprEventSource;
@@ -248,6 +250,11 @@ struct SpaprMachineState {
     uint32_t numa_assoc_array[MAX_NODES + NVGPU_MAX_NUM][NUMA_ASSOC_SIZE];
 
     Error *fwnmi_migration_blocker;
+
+    /* nvdimm flush states */
+    QLIST_HEAD(, SpaprNVDIMMDeviceFlushState) pending_flush_states;
+    QLIST_HEAD(, SpaprNVDIMMDeviceFlushState) completed_flush_states;
+
 };
 
 #define H_SUCCESS         0
@@ -328,6 +335,7 @@ struct SpaprMachineState {
 #define H_P7              -60
 #define H_P8              -61
 #define H_P9              -62
+#define H_UNSUPPORTED     -67
 #define H_OVERLAP         -68
 #define H_UNSUPPORTED_FLAG -256
 #define H_MULTI_THREADS_ACTIVE -9005
@@ -542,8 +550,9 @@ struct SpaprMachineState {
 #define H_SCM_UNBIND_MEM        0x3F0
 #define H_SCM_UNBIND_ALL        0x3FC
 #define H_SCM_HEALTH            0x400
+#define H_SCM_FLUSH             0x44C
 
-#define MAX_HCALL_OPCODE        H_SCM_HEALTH
+#define MAX_HCALL_OPCODE        H_SCM_FLUSH
 
 /* The hcalls above are standardized in PAPR and implemented by pHyp
  * as well.
diff --git a/include/hw/ppc/spapr_nvdimm.h b/include/hw/ppc/spapr_nvdimm.h
index 764f999f54..24d8e37b33 100644
--- a/include/hw/ppc/spapr_nvdimm.h
+++ b/include/hw/ppc/spapr_nvdimm.h
@@ -11,6 +11,7 @@
 #define HW_SPAPR_NVDIMM_H
 
 #include "hw/mem/nvdimm.h"
+#include "migration/vmstate.h"
 
 typedef struct SpaprDrc SpaprDrc;
 typedef struct SpaprMachineState SpaprMachineState;
@@ -21,5 +22,17 @@ void spapr_dt_persistent_memory(SpaprMachineState *spapr, void *fdt);
 bool spapr_nvdimm_validate(HotplugHandler *hotplug_dev, NVDIMMDevice *nvdimm,
                            uint64_t size, Error **errp);
 void spapr_add_nvdimm(DeviceState *dev, uint64_t slot);
+void spapr_nvdimm_finish_flushes(SpaprMachineState *spapr);
+
+typedef struct SpaprNVDIMMDeviceFlushState {
+    uint64_t continue_token;
+    int64_t hcall_ret;
+    int backend_fd;
+    uint32_t drcidx;
+
+    QLIST_ENTRY(SpaprNVDIMMDeviceFlushState) node;
+} SpaprNVDIMMDeviceFlushState;
+
+extern const VMStateDescription vmstate_spapr_nvdimm_states;
 
 #endif


