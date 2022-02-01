Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132812C9C
	for <nvdimm@lists.linux.dev>; Tue,  1 Feb 2022 21:58:03 +0000 (UTC)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 211JwXrw018791;
	Tue, 1 Feb 2022 21:57:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Wzl7IQyk6X1VKIuUJLLU2T+BgAT6JHlG7QVrMHFOGfY=;
 b=sSaT3VHyG5C4cMZw0SIbRn/HdPVrtz5PhziMekSbUpbgdSpn6I6iGjwDQVpwRwyX1ngu
 Xn8cNCezGEUpoQCE32KyLoaun9hA/B8+V+2C/6ZL5S9rvVCvyvICQemkm+MbPlXK6nfW
 M2uQg4gUGlIlmj8aBdxFrQFmGlii6pqajSP7SCzXHerBZWG92EGGDO8lJ0ar/CeHRLRb
 GNHdXNny7naRhOykdmFfog3QBGTwI+i+CdrUPpn1R3d7a/C1+c4X/g+1hV0/aiXWTjyq
 fuxiACTp71emeaDy3NQLha240wqzzH1Yg5Yft2o7/T2lhzvV1KLAmTGP3yaievgX9hqd NA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3dybg91xej-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 01 Feb 2022 21:57:52 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
	by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 211LoHvK020470;
	Tue, 1 Feb 2022 21:57:52 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3dybg91xe0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 01 Feb 2022 21:57:51 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
	by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 211LlAVh029321;
	Tue, 1 Feb 2022 21:57:49 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
	by ppma06ams.nl.ibm.com with ESMTP id 3dvvujgcaq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 01 Feb 2022 21:57:49 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
	by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 211LvkCs45613316
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 1 Feb 2022 21:57:46 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AC979A404D;
	Tue,  1 Feb 2022 21:57:46 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DF45CA4040;
	Tue,  1 Feb 2022 21:57:44 +0000 (GMT)
Received: from [10.88.2.5] (unknown [9.40.194.150])
	by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Tue,  1 Feb 2022 21:57:44 +0000 (GMT)
Subject: [PATCH v6 1/3] nvdimm: Add realize,
 unrealize callbacks to NVDIMMDevice class
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: clg@kaod.org, mst@redhat.com, ani@anisinha.ca, danielhb413@gmail.com,
        david@gibson.dropbear.id.au, groug@kaod.org, imammedo@redhat.com,
        xiaoguangrong.eric@gmail.com, david@gibson.dropbear.id.au,
        qemu-ppc@nongnu.org
Cc: qemu-devel@nongnu.org, aneesh.kumar@linux.ibm.com, nvdimm@lists.linux.dev,
        kvm-ppc@vger.kernel.org
Date: Tue, 01 Feb 2022 21:57:44 +0000
Message-ID: <164375265999.118489.14958665170590335290.stgit@82dbe1ffb256>
In-Reply-To: <164375265242.118489.1350738893986283213.stgit@82dbe1ffb256>
References: <164375265242.118489.1350738893986283213.stgit@82dbe1ffb256>
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
X-Proofpoint-ORIG-GUID: o1XBhjBYsn-U2AUoF9Q5Q_cKxtiCxhy4
X-Proofpoint-GUID: SpZvGwIYEFxG2nAHBVjke4-qmlkcxuWP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-01_10,2022-02-01_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 impostorscore=0 adultscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202010118

A new subclass inheriting NVDIMMDevice is going to be introduced in
subsequent patches. The new subclass uses the realize and unrealize
callbacks. Add them on NVDIMMClass to appropriately call them as part
of plug-unplug.

Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
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


