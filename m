Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E74F68
	for <nvdimm@lists.linux.dev>; Tue, 16 Nov 2021 05:16:17 +0000 (UTC)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AG1K94r021566;
	Tue, 16 Nov 2021 04:49:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=5VRyKc8Dl36o15virRnUGPJzR7j1xnZTwlYyV+z/rhQ=;
 b=P/EbWKyVeZjbWs54mWp35/Y//TQqQmfPVQJCeGBjpheSONBLem2ZHogi4UyWyhzpNz7m
 1YjjIrrvSp/ieCXWVb0jHZok6b+MAHS26U/p4KVb05mlURqT4Yi44Syu63do35rXWv/F
 /4zmjuwFQ5RJYKN5hz+I8JI8+35z7WZ80lULHxqHW2HK4F1h29qaDx4cmjA42sY6txAN
 3QG6AqftghAXDXztwfbdMXGhZf8i4q11INXvXLO5FxGfXTNAboz3DbWRbw+mcyOC/8FU
 210cnemw8PFsTTpJr2rmZuEvzUsv6VbFeZdk+3oKECHIwVkEEIySHitqU4NyNl7FwlH5 xQ== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3cbv6yam2m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Nov 2021 04:49:33 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
	by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AG4gpSW000905;
	Tue, 16 Nov 2021 04:49:31 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
	by ppma06ams.nl.ibm.com with ESMTP id 3ca4mjkbs4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Nov 2021 04:49:31 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
	by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AG4ga6D64684424
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Nov 2021 04:42:36 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6750542041;
	Tue, 16 Nov 2021 04:49:28 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EE4D642042;
	Tue, 16 Nov 2021 04:49:23 +0000 (GMT)
Received: from li-e8dccbcc-2adc-11b2-a85c-bc1f33b9b810.ibm.com.com (unknown [9.43.127.103])
	by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Tue, 16 Nov 2021 04:49:23 +0000 (GMT)
From: Kajol Jain <kjain@linux.ibm.com>
To: mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org, nvdimm@lists.linux.dev,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        dan.j.williams@intel.com, ira.weiny@intel.com,
        vishal.l.verma@intel.com
Cc: santosh@fossix.org, maddy@linux.ibm.com, rnsastry@linux.ibm.com,
        aneesh.kumar@linux.ibm.com, atrajeev@linux.vnet.ibm.com,
        vaibhav@linux.ibm.com, kjain@linux.ibm.com
Subject: [RESEND PATCH v5 1/4] drivers/nvdimm: Add nvdimm pmu structure
Date: Tue, 16 Nov 2021 10:19:01 +0530
Message-Id: <20211116044904.48718-2-kjain@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211116044904.48718-1-kjain@linux.ibm.com>
References: <20211116044904.48718-1-kjain@linux.ibm.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: yX-pb7aUGxshq-yypgrVADWd6blvxcX9
X-Proofpoint-GUID: yX-pb7aUGxshq-yypgrVADWd6blvxcX9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-15_16,2021-11-15_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 impostorscore=0 adultscore=0 bulkscore=0 spamscore=0 suspectscore=0
 mlxlogscore=959 priorityscore=1501 mlxscore=0 phishscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111160023

A structure is added called nvdimm_pmu, for performance
stats reporting support of nvdimm devices. It can be used to add
device pmu data such as pmu data structure for performance
stats, nvdimm device pointer along with cpumask attributes.

Signed-off-by: Kajol Jain <kjain@linux.ibm.com>
---
 include/linux/nd.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/linux/nd.h b/include/linux/nd.h
index ee9ad76afbba..f5ed4db2d859 100644
--- a/include/linux/nd.h
+++ b/include/linux/nd.h
@@ -8,6 +8,7 @@
 #include <linux/ndctl.h>
 #include <linux/device.h>
 #include <linux/badblocks.h>
+#include <linux/perf_event.h>
 
 enum nvdimm_event {
 	NVDIMM_REVALIDATE_POISON,
@@ -23,6 +24,25 @@ enum nvdimm_claim_class {
 	NVDIMM_CCLASS_UNKNOWN,
 };
 
+/**
+ * struct nvdimm_pmu - data structure for nvdimm perf driver
+ * @pmu: pmu data structure for nvdimm performance stats.
+ * @dev: nvdimm device pointer.
+ * @cpu: designated cpu for counter access.
+ * @node: node for cpu hotplug notifier link.
+ * @cpuhp_state: state for cpu hotplug notification.
+ * @arch_cpumask: cpumask to get designated cpu for counter access.
+ */
+struct nvdimm_pmu {
+	struct pmu pmu;
+	struct device *dev;
+	int cpu;
+	struct hlist_node node;
+	enum cpuhp_state cpuhp_state;
+	/* cpumask provided by arch/platform specific code */
+	struct cpumask arch_cpumask;
+};
+
 struct nd_device_driver {
 	struct device_driver drv;
 	unsigned long type;
-- 
2.26.2

