Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE5F2FB2
	for <nvdimm@lists.linux.dev>; Tue, 28 Sep 2021 12:47:51 +0000 (UTC)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18SCCXSq003391;
	Tue, 28 Sep 2021 08:47:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=5VRyKc8Dl36o15virRnUGPJzR7j1xnZTwlYyV+z/rhQ=;
 b=eI17a/lntV9hUR5sTP5xRChuBievGN4wCaFc8xtzenya5d1jUscSJKQqhaBGso1Cx3fu
 Ez1/TjBX2PY1EkkyHmRgGpNifw50uKBgQZuFQxQY1hqEl1ujS0fxXFuS5BgxpCn2twi6
 woGK9TS74acjzDwsYvDYqrw5FkBotcsfUU1l50upsoizTl//Z0wANg1hZJ6APk3gtDX+
 jYlYGNr1O7UmjyzbpTepyHou2PrW++9rbPfARuCEDtJOEzMF/UOpeMSdS3AQLuAlJCi2
 sLUInm6WUjpTvXIY5hRhAU1BA3knmv//e15BuF1eK/eAhTuyUQSkvuklKWNE+NbCJGEl ug== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3bbws67qs8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Sep 2021 08:47:40 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
	by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18SChGSU030281;
	Tue, 28 Sep 2021 12:47:38 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
	by ppma06ams.nl.ibm.com with ESMTP id 3b9u1je205-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Sep 2021 12:47:38 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
	by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18SClYXQ38535482
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Sep 2021 12:47:34 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AA559AE053;
	Tue, 28 Sep 2021 12:47:34 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 46E71AE057;
	Tue, 28 Sep 2021 12:47:29 +0000 (GMT)
Received: from li-e8dccbcc-2adc-11b2-a85c-bc1f33b9b810.ibm.com.com (unknown [9.43.50.245])
	by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Tue, 28 Sep 2021 12:47:28 +0000 (GMT)
From: Kajol Jain <kjain@linux.ibm.com>
To: mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org, nvdimm@lists.linux.dev,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        dan.j.williams@intel.com, ira.weiny@intel.com,
        vishal.l.verma@intel.com
Cc: maddy@linux.ibm.com, santosh@fossix.org, aneesh.kumar@linux.ibm.com,
        vaibhav@linux.ibm.com, atrajeev@linux.vnet.ibm.com, tglx@linutronix.de,
        rnsastry@linux.ibm.com, kjain@linux.ibm.com
Subject: [PATCH v5 1/4] drivers/nvdimm: Add nvdimm pmu structure
Date: Tue, 28 Sep 2021 18:17:24 +0530
Message-Id: <20210928124724.146614-1-kjain@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: HAHvwjJwGIWBr1H_Knf9nIx9bPsTcCfk
X-Proofpoint-GUID: HAHvwjJwGIWBr1H_Knf9nIx9bPsTcCfk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-28_05,2021-09-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 mlxlogscore=954 impostorscore=0 lowpriorityscore=0 clxscore=1015
 spamscore=0 mlxscore=0 adultscore=0 bulkscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109280071

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

