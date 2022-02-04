Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56EA2C9C
	for <nvdimm@lists.linux.dev>; Fri,  4 Feb 2022 08:16:27 +0000 (UTC)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21458Sst010592;
	Fri, 4 Feb 2022 08:16:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=OixyaXcs5sAWtzsGlY7M2Dd5WmlBfOLfMJH1MiO5mJk=;
 b=m5vE5ySLmENMifPYTJ2kwColJr2si5WCKyMN0RFKhdGIV1lq+YMwcwTgUaxwgC6qDVVL
 fSmeBAKuPCZoRv+FuTeCiC6vsMYL1jpWTIZFvc4GMdiYTKPda9b3hrfkg1IdUENLNkZK
 ApMRdTyrdg+5PXzlj9L0JEBF3yH6XQugQjLxFeA98CBw4dQtH5k0YXXLxnWHMvXpLi4U
 oymq5Mc+v73PqjQlmTex1i32+iEKBV5SyRx3wCAQSY8FQDkbfh0rJuPF8KwB2Ze7GlGh
 Tw+FOrjU0BZ+FDxbQK7pw0mlfLC99v6a4g+BYIGNyH5ZYQUBx1/qqTGioyhWb251GAfg eA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3e0qx3r7sa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 04 Feb 2022 08:16:13 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
	by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2147TMcp031968;
	Fri, 4 Feb 2022 08:16:13 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3e0qx3r7rf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 04 Feb 2022 08:16:13 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
	by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21487L2l011142;
	Fri, 4 Feb 2022 08:16:10 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
	by ppma06ams.nl.ibm.com with ESMTP id 3e0r0u2myh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 04 Feb 2022 08:16:10 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
	by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2148G8GD34734460
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 4 Feb 2022 08:16:08 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 08FA952069;
	Fri,  4 Feb 2022 08:16:08 +0000 (GMT)
Received: from ltczzess4.aus.stglabs.ibm.com (unknown [9.40.194.150])
	by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 2686752051;
	Fri,  4 Feb 2022 08:16:06 +0000 (GMT)
Subject: [PATCH v7 3/3] spapr: nvdimm: Introduce spapr-nvdimm device
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: clg@kaod.org, mst@redhat.com, ani@anisinha.ca, danielhb413@gmail.com,
        david@gibson.dropbear.id.au, groug@kaod.org, imammedo@redhat.com,
        xiaoguangrong.eric@gmail.com, david@gibson.dropbear.id.au,
        qemu-ppc@nongnu.org
Cc: qemu-devel@nongnu.org, aneesh.kumar@linux.ibm.com, nvdimm@lists.linux.dev,
        kvm-ppc@vger.kernel.org
Date: Fri, 04 Feb 2022 08:16:05 +0000
Message-ID: 
 <164396256092.109112.17933240273840803354.stgit@ltczzess4.aus.stglabs.ibm.com>
In-Reply-To: 
 <164396252398.109112.13436924292537517470.stgit@ltczzess4.aus.stglabs.ibm.com>
References: 
 <164396252398.109112.13436924292537517470.stgit@ltczzess4.aus.stglabs.ibm.com>
User-Agent: StGit/1.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 4KcBn8NmntadRwrFoSZm96h7bdn7Lqof
X-Proofpoint-GUID: 5doCuF-r_1rvIiORX0cIwdPfgTzS0ZJa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-04_03,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 clxscore=1015 impostorscore=0 adultscore=0
 mlxscore=0 spamscore=0 suspectscore=0 malwarescore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202040041

If the device backend is not persistent memory for the nvdimm, there is
need for explicit IO flushes on the backend to ensure persistence.

On SPAPR, the issue is addressed by adding a new hcall to request for
an explicit flush from the guest when the backend is not pmem. So, the
approach here is to convey when the hcall flush is required in a device
tree property. The guest once it knows the device backend is not pmem,
makes the hcall whenever flush is required.

To set the device tree property, a new PAPR specific device type inheriting
the nvdimm device is implemented. When the backend doesn't have pmem=on
the device tree property "ibm,hcall-flush-required" is set, and the guest
makes hcall H_SCM_FLUSH requesting for an explicit flush. The new device
has boolean property pmem-override which when "on" advertises the device
tree property even when pmem=on for the backend. The flush function
invokes the fdatasync or pmem_persist() based on the type of backend.

The vmstate structures are made part of the spapr-nvdimm device object.
The patch attempts to keep the migration compatibility between source and
destination while rejecting the incompatibles ones with failures.

Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Reviewed-by: Daniel Henrique Barboza <danielhb413@gmail.com>
---
 hw/ppc/spapr_nvdimm.c |  132 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 132 insertions(+)

diff --git a/hw/ppc/spapr_nvdimm.c b/hw/ppc/spapr_nvdimm.c
index ac44e00153..c4c97da5de 100644
--- a/hw/ppc/spapr_nvdimm.c
+++ b/hw/ppc/spapr_nvdimm.c
@@ -34,6 +34,7 @@
 #include "block/thread-pool.h"
 #include "migration/vmstate.h"
 #include "qemu/pmem.h"
+#include "hw/qdev-properties.h"
 
 /* DIMM health bitmap bitmap indicators. Taken from kernel's papr_scm.c */
 /* SCM device is unable to persist memory contents */
@@ -57,6 +58,10 @@ OBJECT_DECLARE_TYPE(SpaprNVDIMMDevice, SPAPRNVDIMMClass, SPAPR_NVDIMM)
 struct SPAPRNVDIMMClass {
     /* private */
     NVDIMMClass parent_class;
+
+    /* public */
+    void (*realize)(NVDIMMDevice *dimm, Error **errp);
+    void (*unrealize)(NVDIMMDevice *dimm, Error **errp);
 };
 
 bool spapr_nvdimm_validate(HotplugHandler *hotplug_dev, NVDIMMDevice *nvdimm,
@@ -64,6 +69,8 @@ bool spapr_nvdimm_validate(HotplugHandler *hotplug_dev, NVDIMMDevice *nvdimm,
 {
     const MachineClass *mc = MACHINE_GET_CLASS(hotplug_dev);
     const MachineState *ms = MACHINE(hotplug_dev);
+    PCDIMMDevice *dimm = PC_DIMM(nvdimm);
+    MemoryRegion *mr = host_memory_backend_get_memory(dimm->hostmem);
     g_autofree char *uuidstr = NULL;
     QemuUUID uuid;
     int ret;
@@ -101,6 +108,14 @@ bool spapr_nvdimm_validate(HotplugHandler *hotplug_dev, NVDIMMDevice *nvdimm,
         return false;
     }
 
+    if (object_dynamic_cast(OBJECT(nvdimm), TYPE_SPAPR_NVDIMM) &&
+        (memory_region_get_fd(mr) < 0)) {
+        error_setg(errp, "spapr-nvdimm device requires the "
+                   "memdev %s to be of memory-backend-file type",
+                   object_get_canonical_path_component(OBJECT(dimm->hostmem)));
+        return false;
+    }
+
     return true;
 }
 
@@ -172,6 +187,20 @@ static int spapr_dt_nvdimm(SpaprMachineState *spapr, void *fdt,
                              "operating-system")));
     _FDT(fdt_setprop(fdt, child_offset, "ibm,cache-flush-required", NULL, 0));
 
+    if (object_dynamic_cast(OBJECT(nvdimm), TYPE_SPAPR_NVDIMM)) {
+        bool is_pmem = false, pmem_override = false;
+        PCDIMMDevice *dimm = PC_DIMM(nvdimm);
+        HostMemoryBackend *hostmem = dimm->hostmem;
+
+        is_pmem = object_property_get_bool(OBJECT(hostmem), "pmem", NULL);
+        pmem_override = object_property_get_bool(OBJECT(nvdimm),
+                                                 "pmem-override", NULL);
+        if (!is_pmem || pmem_override) {
+            _FDT(fdt_setprop(fdt, child_offset, "ibm,hcall-flush-required",
+                             NULL, 0));
+        }
+    }
+
     return child_offset;
 }
 
@@ -397,11 +426,21 @@ typedef struct SpaprNVDIMMDeviceFlushState {
 
 typedef struct SpaprNVDIMMDevice SpaprNVDIMMDevice;
 struct SpaprNVDIMMDevice {
+    /* private */
     NVDIMMDevice parent_obj;
 
+    bool hcall_flush_required;
     uint64_t nvdimm_flush_token;
     QLIST_HEAD(, SpaprNVDIMMDeviceFlushState) pending_nvdimm_flush_states;
     QLIST_HEAD(, SpaprNVDIMMDeviceFlushState) completed_nvdimm_flush_states;
+
+    /* public */
+
+    /*
+     * The 'on' value for this property forced the qemu to enable the hcall
+     * flush for the nvdimm device even if the backend is a pmem
+     */
+    bool pmem_override;
 };
 
 static int flush_worker_cb(void *opaque)
@@ -448,6 +487,24 @@ static int spapr_nvdimm_flush_post_load(void *opaque, int version_id)
     SpaprNVDIMMDevice *s_nvdimm = (SpaprNVDIMMDevice *)opaque;
     SpaprNVDIMMDeviceFlushState *state;
     ThreadPool *pool = aio_get_thread_pool(qemu_get_aio_context());
+    HostMemoryBackend *backend = MEMORY_BACKEND(PC_DIMM(s_nvdimm)->hostmem);
+    bool is_pmem = object_property_get_bool(OBJECT(backend), "pmem", NULL);
+    bool pmem_override = object_property_get_bool(OBJECT(s_nvdimm),
+                                                  "pmem-override", NULL);
+    bool dest_hcall_flush_required = pmem_override || !is_pmem;
+
+    if (!s_nvdimm->hcall_flush_required && dest_hcall_flush_required) {
+        error_report("The file backend for the spapr-nvdimm device %s at "
+                     "source is a pmem, use pmem=on and pmem-override=off to "
+                     "continue.", DEVICE(s_nvdimm)->id);
+        return -EINVAL;
+    }
+    if (s_nvdimm->hcall_flush_required && !dest_hcall_flush_required) {
+        error_report("The guest expects hcall-flush support for the "
+                     "spapr-nvdimm device %s, use pmem_override=on to "
+                     "continue.", DEVICE(s_nvdimm)->id);
+        return -EINVAL;
+    }
 
     QLIST_FOREACH(state, &s_nvdimm->pending_nvdimm_flush_states, node) {
         thread_pool_submit_aio(pool, flush_worker_cb, state,
@@ -475,6 +532,7 @@ const VMStateDescription vmstate_spapr_nvdimm_states = {
     .minimum_version_id = 1,
     .post_load = spapr_nvdimm_flush_post_load,
     .fields = (VMStateField[]) {
+        VMSTATE_BOOL(hcall_flush_required, SpaprNVDIMMDevice),
         VMSTATE_UINT64(nvdimm_flush_token, SpaprNVDIMMDevice),
         VMSTATE_QLIST_V(completed_nvdimm_flush_states, SpaprNVDIMMDevice, 1,
                         vmstate_spapr_nvdimm_flush_state,
@@ -605,7 +663,11 @@ static target_ulong h_scm_flush(PowerPCCPU *cpu, SpaprMachineState *spapr,
     }
 
     dimm = PC_DIMM(drc->dev);
+    if (!object_dynamic_cast(OBJECT(dimm), TYPE_SPAPR_NVDIMM)) {
+        return H_PARAMETER;
+    }
     if (continue_token == 0) {
+        bool is_pmem = false, pmem_override = false;
         backend = MEMORY_BACKEND(dimm->hostmem);
         fd = memory_region_get_fd(&backend->mr);
 
@@ -613,6 +675,13 @@ static target_ulong h_scm_flush(PowerPCCPU *cpu, SpaprMachineState *spapr,
             return H_UNSUPPORTED;
         }
 
+        is_pmem = object_property_get_bool(OBJECT(backend), "pmem", NULL);
+        pmem_override = object_property_get_bool(OBJECT(dimm),
+                                                "pmem-override", NULL);
+        if (is_pmem && !pmem_override) {
+            return H_UNSUPPORTED;
+        }
+
         state = spapr_nvdimm_init_new_flush_state(SPAPR_NVDIMM(dimm));
         if (!state) {
             return H_HARDWARE;
@@ -786,3 +855,66 @@ static void spapr_scm_register_types(void)
 }
 
 type_init(spapr_scm_register_types)
+
+static void spapr_nvdimm_realize(NVDIMMDevice *dimm, Error **errp)
+{
+    SpaprNVDIMMDevice *s_nvdimm = SPAPR_NVDIMM(dimm);
+    HostMemoryBackend *backend = MEMORY_BACKEND(PC_DIMM(dimm)->hostmem);
+    bool is_pmem = object_property_get_bool(OBJECT(backend),  "pmem", NULL);
+    bool pmem_override = object_property_get_bool(OBJECT(dimm), "pmem-override",
+                                             NULL);
+    if (!is_pmem || pmem_override) {
+        s_nvdimm->hcall_flush_required = true;
+    }
+
+    vmstate_register(NULL, VMSTATE_INSTANCE_ID_ANY,
+                     &vmstate_spapr_nvdimm_states, dimm);
+}
+
+static void spapr_nvdimm_unrealize(NVDIMMDevice *dimm)
+{
+    vmstate_unregister(NULL, &vmstate_spapr_nvdimm_states, dimm);
+}
+
+static Property spapr_nvdimm_properties[] = {
+#ifdef CONFIG_LIBPMEM
+    DEFINE_PROP_BOOL("pmem-override", SpaprNVDIMMDevice, pmem_override, false),
+#endif
+    DEFINE_PROP_END_OF_LIST(),
+};
+
+static void spapr_nvdimm_class_init(ObjectClass *oc, void *data)
+{
+    DeviceClass *dc = DEVICE_CLASS(oc);
+    NVDIMMClass *nvc = NVDIMM_CLASS(oc);
+
+    nvc->realize = spapr_nvdimm_realize;
+    nvc->unrealize = spapr_nvdimm_unrealize;
+
+    device_class_set_props(dc, spapr_nvdimm_properties);
+}
+
+static void spapr_nvdimm_init(Object *obj)
+{
+    SpaprNVDIMMDevice *s_nvdimm = SPAPR_NVDIMM(obj);
+
+    s_nvdimm->hcall_flush_required = false;
+    QLIST_INIT(&s_nvdimm->pending_nvdimm_flush_states);
+    QLIST_INIT(&s_nvdimm->completed_nvdimm_flush_states);
+}
+
+static TypeInfo spapr_nvdimm_info = {
+    .name          = TYPE_SPAPR_NVDIMM,
+    .parent        = TYPE_NVDIMM,
+    .class_init    = spapr_nvdimm_class_init,
+    .class_size    = sizeof(SPAPRNVDIMMClass),
+    .instance_size = sizeof(SpaprNVDIMMDevice),
+    .instance_init = spapr_nvdimm_init,
+};
+
+static void spapr_nvdimm_register_types(void)
+{
+    type_register_static(&spapr_nvdimm_info);
+}
+
+type_init(spapr_nvdimm_register_types)


