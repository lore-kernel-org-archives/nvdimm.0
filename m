Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B78772
	for <nvdimm@lists.linux.dev>; Thu,  8 Jul 2021 02:57:44 +0000 (UTC)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1682Yb3U047975;
	Wed, 7 Jul 2021 22:57:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=YaAJbIOt4yyi4yrcpodi1H/EVgAmWLiCwFLM+ixUOfg=;
 b=c+eLSFi6lo3DRAjv/KQC5xokqBxf6eaIHOQxrDiMi532jfYOK393lwpLCmXGoBB+XEKi
 DxQYsxev4C1gua4++DRo/4LC0gjHfk3ODD7HkJYpsGJjfeCXR/LpjSYP3Js3KKDm8b1P
 ZYsRQ9RBIXa85Z2juJinbsCNsPrG0HIj+7qYpIrj7vGhddRsnp3QtO66qMjC++3gBtkA
 RhwbuihhiZ6YceChxDbhXGJd8jfPHDxoDWi/Lygj3M4D4I6j9ReVCUf0TdsOs6Jytq1Y
 oFJer435Im62rXS5Uqnj1fRWbfjlJns2rSrrk+agvsBwdMfMqXm6GGEwNcj5vb8KQZqe 7w== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
	by mx0b-001b2d01.pphosted.com with ESMTP id 39mkpwbg3a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 Jul 2021 22:57:38 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
	by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1682sW9b019446;
	Thu, 8 Jul 2021 02:57:36 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
	by ppma02fra.de.ibm.com with ESMTP id 39jfh892fw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Jul 2021 02:57:36 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
	by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1682vY9M33095976
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 8 Jul 2021 02:57:34 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 114A711C052;
	Thu,  8 Jul 2021 02:57:34 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C11A811C04A;
	Thu,  8 Jul 2021 02:57:32 +0000 (GMT)
Received: from lep8c.aus.stglabs.ibm.com (unknown [9.40.192.207])
	by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Thu,  8 Jul 2021 02:57:32 +0000 (GMT)
Subject: [PATCH REBASED v5 2/2] spapr: nvdimm: Introduce spapr-nvdimm device
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: david@gibson.dropbear.id.au, groug@kaod.org, qemu-ppc@nongnu.org
Cc: qemu-devel@nongnu.org, aneesh.kumar@linux.ibm.com, nvdimm@lists.linux.dev,
        kvm-ppc@vger.kernel.org, bharata@linux.vnet.ibm.com
Date: Wed, 07 Jul 2021 21:57:31 -0500
Message-ID: 
 <162571304881.1030381.2406869533148471546.stgit@lep8c.aus.stglabs.ibm.com>
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
X-Proofpoint-ORIG-GUID: 9Ddrd10YOrg0phoz2b9wBB73ys7kppup
X-Proofpoint-GUID: 9Ddrd10YOrg0phoz2b9wBB73ys7kppup
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-08_01:2021-07-06,2021-07-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 malwarescore=0 spamscore=0 suspectscore=0 impostorscore=0 phishscore=0
 mlxlogscore=856 lowpriorityscore=0 priorityscore=1501 clxscore=1015
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107080011

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
index 4f8931ab15..4dc7c3f147 100644
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
 


