Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E7BE70
	for <nvdimm@lists.linux.dev>; Tue, 18 May 2021 12:04:04 +0000 (UTC)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14IC3d60115358;
	Tue, 18 May 2021 08:03:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Y7Py4PLn2Xa4gLUzgFQ0syP3xHf3zMkOqJFeWIq/rCc=;
 b=OwiJOwGWa8l4OqOo+GXehOQOeHqqDHJ7aBx3OGaMIa5IY/3keCZYaOVvqJe3BF+AF5PV
 suqPNI3FWioKUMeh4CUKMRGx+PWK3T8Ud2WyFtXIMnHPF0QOMO5WhCa9bTkSjlvh3Io2
 1KiSelaYDj9pMaIchlvIRQ+F1h4l02fo/3YHCt4b77I/iA3CFIoSFN+NNrnXY1Ho+RrM
 xytt/icl/aSRBBPhzyA/n4SAYeSuFLTH3vmgbYpCLXBiQdwKfdNiX3peFQ/ZtrhjSwF5
 xgbsRHseGLSxREwPos0eA7DoN/ag/xcV4zrNvjvoliBjP9ecb5IQeBU95vIQUZdocMC/ 1g== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com with ESMTP id 38md080du1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 May 2021 08:03:54 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
	by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14IC3re8116660;
	Tue, 18 May 2021 08:03:53 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
	by mx0a-001b2d01.pphosted.com with ESMTP id 38md080dst-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 May 2021 08:03:53 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
	by ppma01fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14IC20vk018196;
	Tue, 18 May 2021 12:03:51 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
	by ppma01fra.de.ibm.com with ESMTP id 38m1gv0589-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 May 2021 12:03:51 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
	by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14IC3mLN41812326
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 May 2021 12:03:48 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D5F864204C;
	Tue, 18 May 2021 12:03:48 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 931DF4204B;
	Tue, 18 May 2021 12:03:47 +0000 (GMT)
Received: from [172.17.0.2] (unknown [9.40.192.207])
	by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Tue, 18 May 2021 12:03:47 +0000 (GMT)
Subject: [PATCH v5 3/3] spapr: nvdimm: Introduce spapr-nvdimm device
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: david@gibson.dropbear.id.au, groug@kaod.org, qemu-ppc@nongnu.org
Cc: qemu-devel@nongnu.org, aneesh.kumar@linux.ibm.com, nvdimm@lists.linux.dev,
        kvm-ppc@vger.kernel.org, shivaprasadbhat@gmail.com,
        bharata@linux.vnet.ibm.com
Date: Tue, 18 May 2021 08:03:46 -0400
Message-ID: <162133941905.610.8271873318598392825.stgit@4f1e6f2bd33e>
In-Reply-To: <162133924680.610.15121309741756314238.stgit@4f1e6f2bd33e>
References: <162133924680.610.15121309741756314238.stgit@4f1e6f2bd33e>
User-Agent: StGit/0.21
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: R7hDVuiW2Zb2uX5bnprOYpvS0t-OXP_b
X-Proofpoint-GUID: gRCXZ_SrvcqOsgv4VD8cVYQGM-Fvqfpf
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-18_04:2021-05-18,2021-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 impostorscore=0 mlxscore=0 mlxlogscore=932 priorityscore=1501 spamscore=0
 malwarescore=0 lowpriorityscore=0 clxscore=1015 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105180086

If the device backend is not persistent memory for the nvdimm, there is
need for explicit IO flushes on the backend to ensure persistence.

On SPAPR, the issue is addressed by adding a new hcall to request for
an explicit flush from the guest when the backend is not pmem. So, the
approach here is to convey when the hcall flush is required in a device
tree property. The guest once it knows the device backend is not pmem,
makes the hcall whenever flush is required.

To set the device tree property, the patch introduces a new papr specific
device type inheriting the nvdimm device. When the backend doesn't have
pmem="yes", the device tree property "ibm,hcall-flush-required" is set,
and the guest makes hcall H_SCM_FLUSH requesting for an explicit flush.

Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
---
 hw/ppc/spapr_nvdimm.c         |   46 +++++++++++++++++++++++++++++++++++++++++
 include/hw/ppc/spapr_nvdimm.h |    4 ++++
 2 files changed, 50 insertions(+)

diff --git a/hw/ppc/spapr_nvdimm.c b/hw/ppc/spapr_nvdimm.c
index d460a098c0..9a04df4c47 100644
--- a/hw/ppc/spapr_nvdimm.c
+++ b/hw/ppc/spapr_nvdimm.c
@@ -54,6 +54,8 @@ bool spapr_nvdimm_validate(HotplugHandler *hotplug_dev, NVDIMMDevice *nvdimm,
 {
     const MachineClass *mc = MACHINE_GET_CLASS(hotplug_dev);
     const MachineState *ms = MACHINE(hotplug_dev);
+    PCDIMMDevice *dimm = PC_DIMM(nvdimm);
+    MemoryRegion *mr = host_memory_backend_get_memory(dimm->hostmem);
     g_autofree char *uuidstr = NULL;
     QemuUUID uuid;
     int ret;
@@ -91,6 +93,14 @@ bool spapr_nvdimm_validate(HotplugHandler *hotplug_dev, NVDIMMDevice *nvdimm,
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
 
@@ -162,6 +172,21 @@ static int spapr_dt_nvdimm(SpaprMachineState *spapr, void *fdt,
                              "operating-system")));
     _FDT(fdt_setprop(fdt, child_offset, "ibm,cache-flush-required", NULL, 0));
 
+    if (object_dynamic_cast(OBJECT(nvdimm), TYPE_SPAPR_NVDIMM)) {
+        bool is_pmem = false;
+#ifdef CONFIG_LIBPMEM
+        PCDIMMDevice *dimm = PC_DIMM(nvdimm);
+        HostMemoryBackend *hostmem = dimm->hostmem;
+
+        is_pmem = object_property_get_bool(OBJECT(hostmem), "pmem",
+                                           &error_abort);
+#endif
+        if (!is_pmem) {
+            _FDT(fdt_setprop(fdt, child_offset, "ibm,hcall-flush-required",
+                             NULL, 0));
+        }
+    }
+
     return child_offset;
 }
 
@@ -585,7 +610,16 @@ static target_ulong h_scm_flush(PowerPCCPU *cpu, SpaprMachineState *spapr,
     }
 
     dimm = PC_DIMM(drc->dev);
+    if (!object_dynamic_cast(OBJECT(dimm), TYPE_SPAPR_NVDIMM)) {
+        return H_PARAMETER;
+    }
+
     backend = MEMORY_BACKEND(dimm->hostmem);
+#ifdef CONFIG_LIBPMEM
+    if (object_property_get_bool(OBJECT(backend), "pmem", &error_abort)) {
+        return H_UNSUPPORTED;
+    }
+#endif
     fd = memory_region_get_fd(&backend->mr);
 
     if (fd < 0) {
@@ -766,3 +800,15 @@ static void spapr_scm_register_types(void)
 }
 
 type_init(spapr_scm_register_types)
+
+static TypeInfo spapr_nvdimm_info = {
+    .name          = TYPE_SPAPR_NVDIMM,
+    .parent        = TYPE_NVDIMM,
+};
+
+static void spapr_nvdimm_register_types(void)
+{
+    type_register_static(&spapr_nvdimm_info);
+}
+
+type_init(spapr_nvdimm_register_types)
diff --git a/include/hw/ppc/spapr_nvdimm.h b/include/hw/ppc/spapr_nvdimm.h
index 24d8e37b33..fb4e56418e 100644
--- a/include/hw/ppc/spapr_nvdimm.h
+++ b/include/hw/ppc/spapr_nvdimm.h
@@ -13,6 +13,10 @@
 #include "hw/mem/nvdimm.h"
 #include "migration/vmstate.h"
 
+#define TYPE_SPAPR_NVDIMM "spapr-nvdimm"
+OBJECT_DECLARE_SIMPLE_TYPE(SpaprNVDIMMDevice, SPAPR_NVDIMM)
+
+typedef struct SpaprNVDIMMDevice  SpaprNVDIMMDevice;
 typedef struct SpaprDrc SpaprDrc;
 typedef struct SpaprMachineState SpaprMachineState;
 


