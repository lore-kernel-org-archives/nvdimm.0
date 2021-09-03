Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D613FC9
	for <nvdimm@lists.linux.dev>; Fri,  3 Sep 2021 05:10:50 +0000 (UTC)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 18354SRr060741;
	Fri, 3 Sep 2021 01:10:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=9KfUvzYgAT3H6qM2KQ85LLSVJMiL9yuP9cnvQZGOeGU=;
 b=mGlBJyPlBGStHzwZ35Parhmdi88hAWs8x1t7coWTGd6SXUbLnHx2CdHmruC2QxTeAaks
 hb/4j5VA0G16m6TqI21PHXHd96ibh4qg2RDq3wf9K1xHAqkToLiqigkMFInQDhOUFWlP
 A+GTvGteRkZIEpAJ3W+A8KGEajZPGGaODA6uTQ9K55Vhl7bT77bLNT7no4iS75vLBxef
 lDVmwwAZpI68kjkERKN8O/0WLHmt+nHzGx3Wp2aCCkLLH9T22n2BVUWNPqdBfxPo0sqF
 akMKugzlFTtGvk8R3GjUkcuXTrnD+Afoomk879e2EaCLIHRpuPPAVPgxVF0WDyBzOkh0 ng== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3aucqu8ptw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Sep 2021 01:10:31 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
	by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18357Jx7027003;
	Fri, 3 Sep 2021 05:10:29 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
	by ppma05fra.de.ibm.com with ESMTP id 3au6psjnxs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Sep 2021 05:10:29 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
	by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18356JbZ59048196
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 3 Sep 2021 05:06:19 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5527E42052;
	Fri,  3 Sep 2021 05:10:25 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1A8174204C;
	Fri,  3 Sep 2021 05:10:21 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.43.127.78])
	by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Fri,  3 Sep 2021 05:10:20 +0000 (GMT)
From: Kajol Jain <kjain@linux.ibm.com>
To: mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org, nvdimm@lists.linux.dev,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        dan.j.williams@intel.com, ira.weiny@intel.com,
        vishal.l.verma@intel.com
Cc: maddy@linux.ibm.com, santosh@fossix.org, aneesh.kumar@linux.ibm.com,
        vaibhav@linux.ibm.com, atrajeev@linux.vnet.ibm.com, tglx@linutronix.de,
        kjain@linux.ibm.com, rnsastry@linux.ibm.com
Subject: [RESEND PATCH v4 1/4] drivers/nvdimm: Add nvdimm pmu structure
Date: Fri,  3 Sep 2021 10:39:11 +0530
Message-Id: <20210903050914.273525-2-kjain@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210903050914.273525-1-kjain@linux.ibm.com>
References: <20210903050914.273525-1-kjain@linux.ibm.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0wxz1PkiS_Umng3agSmwxgoKeXbB8m8b
X-Proofpoint-GUID: 0wxz1PkiS_Umng3agSmwxgoKeXbB8m8b
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-03_01:2021-09-03,2021-09-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 phishscore=0 adultscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 impostorscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2108310000
 definitions=main-2109030031

A structure is added, called nvdimm_pmu, for performance
stats reporting support of nvdimm devices. It can be used to add
nvdimm pmu data such as supported events and pmu event functions
like event_init/add/read/del with cpu hotplug support.

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Madhavan Srinivasan <maddy@linux.ibm.com>
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
2.26.2

