Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43AF72C9C
	for <nvdimm@lists.linux.dev>; Fri,  4 Feb 2022 08:15:56 +0000 (UTC)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21468A32007858;
	Fri, 4 Feb 2022 08:15:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=YCSNDDeQhoWa23xDFTvJwuKtGpwFr4tkRf4S+dgP0Jc=;
 b=lUXQ68J4n/IYBbcoOGpTmcjD+YcR10AA9xgXTfbNgIzSIO4y2yuwgylb8hXo6Mle/u+5
 OkzNSy81CjFQ8aj3IsOOFyK9c9hkqUYaIq7nLOLCE0bORr8cpv6I0x55jjNL/oDr4UBJ
 AgauCZsPalY447dBuOoLXXyAaVdGDPxvvixLPpWMDRbvTCHnLR1Z2JwyzxKcl8lFUgea
 DysxuoNEUnlySIL9y45vu+JR7LpVGlwBWzc8hvz9qVdH/C4ogNalaShtAeXdh9HOWpI5
 thYvR7a9P+MFZea3vNJHCBboBjw5+3rW//b2aTe926g9O3SUTB2/x4uN6cyfZyq+adNO Fw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3e0qx2fv85-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 04 Feb 2022 08:15:48 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
	by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2148AVuH012513;
	Fri, 4 Feb 2022 08:15:48 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3e0qx2fv76-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 04 Feb 2022 08:15:48 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
	by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21488nWn009465;
	Fri, 4 Feb 2022 08:15:45 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
	by ppma03fra.de.ibm.com with ESMTP id 3e0r0n2gfd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 04 Feb 2022 08:15:45 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
	by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21485m9u29426044
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 4 Feb 2022 08:05:48 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 688C211C069;
	Fri,  4 Feb 2022 08:15:43 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A006F11C04C;
	Fri,  4 Feb 2022 08:15:41 +0000 (GMT)
Received: from ltczzess4.aus.stglabs.ibm.com (unknown [9.40.194.150])
	by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Fri,  4 Feb 2022 08:15:41 +0000 (GMT)
Subject: [PATCH v7 1/3] nvdimm: Add realize,
 unrealize callbacks to NVDIMMDevice class
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: clg@kaod.org, mst@redhat.com, ani@anisinha.ca, danielhb413@gmail.com,
        david@gibson.dropbear.id.au, groug@kaod.org, imammedo@redhat.com,
        xiaoguangrong.eric@gmail.com, david@gibson.dropbear.id.au,
        qemu-ppc@nongnu.org
Cc: qemu-devel@nongnu.org, aneesh.kumar@linux.ibm.com, nvdimm@lists.linux.dev,
        kvm-ppc@vger.kernel.org
Date: Fri, 04 Feb 2022 08:15:41 +0000
Message-ID: 
 <164396253158.109112.1926755104259023743.stgit@ltczzess4.aus.stglabs.ibm.com>
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
X-Proofpoint-ORIG-GUID: FTn_GEAKGRn2JviMVNUxD0M1Ovk7t1VL
X-Proofpoint-GUID: KHCQnqJ6KheW7OsuPa3t8TCmqmjqvV3a
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-04_03,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 priorityscore=1501 clxscore=1015 phishscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202040041

A new subclass inheriting NVDIMMDevice is going to be introduced in
subsequent patches. The new subclass uses the realize and unrealize
callbacks. Add them on NVDIMMClass to appropriately call them as part
of plug-unplug.

Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Acked-by: Daniel Henrique Barboza <danielhb413@gmail.com>
---
 hw/mem/nvdimm.c          |   16 ++++++++++++++++
 hw/mem/pc-dimm.c         |    5 +++++
 include/hw/mem/nvdimm.h  |    2 ++
 include/hw/mem/pc-dimm.h |    1 +
 4 files changed, 24 insertions(+)

diff --git a/hw/mem/nvdimm.c b/hw/mem/nvdimm.c
index 7397b67156..59959d5563 100644
--- a/hw/mem/nvdimm.c
+++ b/hw/mem/nvdimm.c
@@ -181,10 +181,25 @@ static MemoryRegion *nvdimm_md_get_memory_region(MemoryDeviceState *md,
 static void nvdimm_realize(PCDIMMDevice *dimm, Error **errp)
 {
     NVDIMMDevice *nvdimm = NVDIMM(dimm);
+    NVDIMMClass *ndc = NVDIMM_GET_CLASS(nvdimm);
 
     if (!nvdimm->nvdimm_mr) {
         nvdimm_prepare_memory_region(nvdimm, errp);
     }
+
+    if (ndc->realize) {
+        ndc->realize(nvdimm, errp);
+    }
+}
+
+static void nvdimm_unrealize(PCDIMMDevice *dimm)
+{
+    NVDIMMDevice *nvdimm = NVDIMM(dimm);
+    NVDIMMClass *ndc = NVDIMM_GET_CLASS(nvdimm);
+
+    if (ndc->unrealize) {
+        ndc->unrealize(nvdimm);
+    }
 }
 
 /*
@@ -240,6 +255,7 @@ static void nvdimm_class_init(ObjectClass *oc, void *data)
     DeviceClass *dc = DEVICE_CLASS(oc);
 
     ddc->realize = nvdimm_realize;
+    ddc->unrealize = nvdimm_unrealize;
     mdc->get_memory_region = nvdimm_md_get_memory_region;
     device_class_set_props(dc, nvdimm_properties);
 
diff --git a/hw/mem/pc-dimm.c b/hw/mem/pc-dimm.c
index 48b913aba6..03bd0dd60e 100644
--- a/hw/mem/pc-dimm.c
+++ b/hw/mem/pc-dimm.c
@@ -216,6 +216,11 @@ static void pc_dimm_realize(DeviceState *dev, Error **errp)
 static void pc_dimm_unrealize(DeviceState *dev)
 {
     PCDIMMDevice *dimm = PC_DIMM(dev);
+    PCDIMMDeviceClass *ddc = PC_DIMM_GET_CLASS(dimm);
+
+    if (ddc->unrealize) {
+        ddc->unrealize(dimm);
+    }
 
     host_memory_backend_set_mapped(dimm->hostmem, false);
 }
diff --git a/include/hw/mem/nvdimm.h b/include/hw/mem/nvdimm.h
index bcf62f825c..cf8f59be44 100644
--- a/include/hw/mem/nvdimm.h
+++ b/include/hw/mem/nvdimm.h
@@ -103,6 +103,8 @@ struct NVDIMMClass {
     /* write @size bytes from @buf to NVDIMM label data at @offset. */
     void (*write_label_data)(NVDIMMDevice *nvdimm, const void *buf,
                              uint64_t size, uint64_t offset);
+    void (*realize)(NVDIMMDevice *nvdimm, Error **errp);
+    void (*unrealize)(NVDIMMDevice *nvdimm);
 };
 
 #define NVDIMM_DSM_MEM_FILE     "etc/acpi/nvdimm-mem"
diff --git a/include/hw/mem/pc-dimm.h b/include/hw/mem/pc-dimm.h
index 1473e6db62..322bebe555 100644
--- a/include/hw/mem/pc-dimm.h
+++ b/include/hw/mem/pc-dimm.h
@@ -63,6 +63,7 @@ struct PCDIMMDeviceClass {
 
     /* public */
     void (*realize)(PCDIMMDevice *dimm, Error **errp);
+    void (*unrealize)(PCDIMMDevice *dimm);
 };
 
 void pc_dimm_pre_plug(PCDIMMDevice *dimm, MachineState *machine,


