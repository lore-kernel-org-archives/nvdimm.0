Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A262871
	for <nvdimm@lists.linux.dev>; Thu, 17 Jun 2021 13:26:46 +0000 (UTC)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15HD3NDZ040656;
	Thu, 17 Jun 2021 09:26:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=XrVmuxPC+7CjQdBkXScnrwxqvgsRdcPl7q37VT9+fZk=;
 b=RUdXWYtXWl87m1VJyjc01K1XNangE4Bu/elUP4qWHMvCb0+rEjLkNUPwLY8JBK2nSAqT
 TrD/WcntFItKe79StWBWXF07pFBe5L/humuD0eToZrP7Pp9dv/lrNyumVn/wIYCJEuy1
 tDTGhBTaYfPZPHrb2WITNgmQS8W2bWlfxZRnR1y1ToFRYm79lzYmlcy62977ZWWUWRuB
 NTy3NxuPa8qMdclwqcsYY0vBfcQWBR6sqn+RfEz6yoHjC0kJzn4hea1yd8JObLdYWuQR
 OXGPb+5ueC6yPFqKJQdls8hw4Fd0lsLeQMKpbra7JbUcJbpDUy1+nGZB4z6hDg7GR1p4 sA== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3985y1b0qu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 17 Jun 2021 09:26:35 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
	by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15HDDG30031742;
	Thu, 17 Jun 2021 13:26:32 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
	by ppma02fra.de.ibm.com with ESMTP id 3966jph0d2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 17 Jun 2021 13:26:32 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
	by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15HDPNvr35586446
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Jun 2021 13:25:23 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CDC71AE045;
	Thu, 17 Jun 2021 13:26:29 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 822F4AE04D;
	Thu, 17 Jun 2021 13:26:26 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.199.36.139])
	by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Thu, 17 Jun 2021 13:26:26 +0000 (GMT)
From: Kajol Jain <kjain@linux.ibm.com>
To: mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org, nvdimm@lists.linux.dev,
        linux-kernel@vger.kernel.org, peterz@infradead.org
Cc: maddy@linux.vnet.ibm.com, santosh@fossix.org, aneesh.kumar@linux.ibm.com,
        vaibhav@linux.ibm.com, dan.j.williams@intel.com, ira.weiny@intel.com,
        atrajeev@linux.vnet.ibm.com, tglx@linutronix.de, kjain@linux.ibm.com,
        rnsastry@linux.ibm.com
Subject: [PATCH v3 1/4] drivers/nvdimm: Add nvdimm pmu structure
Date: Thu, 17 Jun 2021 18:56:14 +0530
Message-Id: <20210617132617.99529-2-kjain@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210617132617.99529-1-kjain@linux.ibm.com>
References: <20210617132617.99529-1-kjain@linux.ibm.com>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: mq_Xhj4ZbxFpBBLmBCL8djMo0ZO0LnqG
X-Proofpoint-GUID: mq_Xhj4ZbxFpBBLmBCL8djMo0ZO0LnqG
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-17_10:2021-06-15,2021-06-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 suspectscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 mlxscore=0 clxscore=1015 bulkscore=0 lowpriorityscore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106170085

A structure is added, called nvdimm_pmu, for performance
stats reporting support of nvdimm devices. It can be used to add
nvdimm pmu data such as supported events and pmu event functions
like event_init/add/read/del with cpu hotplug support.

Tested-by: Nageswara R Sastry <rnsastry@linux.ibm.com>
Signed-off-by: Kajol Jain <kjain@linux.ibm.com>
---
 include/linux/nd.h | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/include/linux/nd.h b/include/linux/nd.h
index ee9ad76afbba..712499cf7335 100644
--- a/include/linux/nd.h
+++ b/include/linux/nd.h
@@ -8,6 +8,8 @@
 #include <linux/ndctl.h>
 #include <linux/device.h>
 #include <linux/badblocks.h>
+#include <linux/platform_device.h>
+#include <linux/perf_event.h>
 
 enum nvdimm_event {
 	NVDIMM_REVALIDATE_POISON,
@@ -23,6 +25,47 @@ enum nvdimm_claim_class {
 	NVDIMM_CCLASS_UNKNOWN,
 };
 
+/* Event attribute array index */
+#define NVDIMM_PMU_FORMAT_ATTR		0
+#define NVDIMM_PMU_EVENT_ATTR		1
+#define NVDIMM_PMU_CPUMASK_ATTR		2
+#define NVDIMM_PMU_NULL_ATTR		3
+
+/**
+ * struct nvdimm_pmu - data structure for nvdimm perf driver
+ *
+ * @name: name of the nvdimm pmu device.
+ * @pmu: pmu data structure for nvdimm performance stats.
+ * @dev: nvdimm device pointer.
+ * @functions(event_init/add/del/read): platform specific pmu functions.
+ * @attr_groups: data structure for events, formats and cpumask
+ * @cpu: designated cpu for counter access.
+ * @node: node for cpu hotplug notifier link.
+ * @cpuhp_state: state for cpu hotplug notification.
+ * @arch_cpumask: cpumask to get designated cpu for counter access.
+ */
+struct nvdimm_pmu {
+	const char *name;
+	struct pmu pmu;
+	struct device *dev;
+	int (*event_init)(struct perf_event *event);
+	int  (*add)(struct perf_event *event, int flags);
+	void (*del)(struct perf_event *event, int flags);
+	void (*read)(struct perf_event *event);
+	/*
+	 * Attribute groups for the nvdimm pmu. Index 0 used for
+	 * format attribute, index 1 used for event attribute,
+	 * index 2 used for cpusmask attribute and index 3 kept as NULL.
+	 */
+	const struct attribute_group *attr_groups[4];
+	int cpu;
+	struct hlist_node node;
+	enum cpuhp_state cpuhp_state;
+
+	/* cpumask provided by arch/platform specific code */
+	struct cpumask arch_cpumask;
+};
+
 struct nd_device_driver {
 	struct device_driver drv;
 	unsigned long type;
-- 
2.27.0

