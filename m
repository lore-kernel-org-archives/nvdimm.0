Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6FD87C
	for <nvdimm@lists.linux.dev>; Fri, 25 Feb 2022 14:30:51 +0000 (UTC)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21PCgh34021531;
	Fri, 25 Feb 2022 14:30:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=swFlfkGYEhwI8iLdsimz9iGatD80mf6kulpQ/wbv1tc=;
 b=QRr0Y5fxUk9iuMjf3Ozi7cRvXlX3jbiemTcZzdfa7XouRzGuoHRq1tXzqAOTSzmCN6/r
 lE/jfGuCeW1DFhBSGmpmWiiyIMYUvDcLAN3VIUraHV7xVmRnDP0BjCBBToCG7O/iC3gh
 JFzAKM561iz5YbxRHX8APMLG+T9mShDblBaw5L15E4IaUrFJgWSzbbctq6XrvF2n9YsU
 gbllk9EUcp1kI2uRnCbuBsSR8O4r3QEE6jWpCKvfjUbk42DkLTxtbmvFwQZHZ1RNxyFv
 YfIWoJvguxKBJVfLcEBgsUvdfJhVnStxUz41F3H17ZV8EqTS5+QxGUk9dMph4Xl0DtvW Sg== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3eeyc02u7c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 25 Feb 2022 14:30:50 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
	by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21PER7h2020738;
	Fri, 25 Feb 2022 14:30:48 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
	by ppma06fra.de.ibm.com with ESMTP id 3eaqtk71vm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 25 Feb 2022 14:30:48 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
	by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21PEUj3k47186354
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Feb 2022 14:30:45 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E49554C04A;
	Fri, 25 Feb 2022 14:30:44 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9119D4C04E;
	Fri, 25 Feb 2022 14:30:40 +0000 (GMT)
Received: from li-e8dccbcc-2adc-11b2-a85c-bc1f33b9b810.ibm.com.com (unknown [9.43.81.177])
	by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Fri, 25 Feb 2022 14:30:40 +0000 (GMT)
From: Kajol Jain <kjain@linux.ibm.com>
To: mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org, nvdimm@lists.linux.dev,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        dan.j.williams@intel.com, ira.weiny@intel.com,
        vishal.l.verma@intel.com
Cc: santosh@fossix.org, maddy@linux.ibm.com, rnsastry@linux.ibm.com,
        aneesh.kumar@linux.ibm.com, atrajeev@linux.vnet.ibm.com,
        vaibhav@linux.ibm.com, tglx@linutronix.de, kjain@linux.ibm.com
Subject: [PATCH v7 1/4] drivers/nvdimm: Add nvdimm pmu structure
Date: Fri, 25 Feb 2022 20:00:21 +0530
Message-Id: <20220225143024.47947-2-kjain@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220225143024.47947-1-kjain@linux.ibm.com>
References: <20220225143024.47947-1-kjain@linux.ibm.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: OFNU3knd6033km5CZl3fTTfa9rMDGFYX
X-Proofpoint-GUID: OFNU3knd6033km5CZl3fTTfa9rMDGFYX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-25_08,2022-02-25_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0 priorityscore=1501
 impostorscore=0 clxscore=1015 mlxlogscore=904 spamscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202250084

A structure is added called nvdimm_pmu, for performance
stats reporting support of nvdimm devices. It can be used to add
device pmu data such as pmu data structure for performance
stats, nvdimm device pointer along with cpumask attributes.

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Nageswara R Sastry <rnsastry@linux.ibm.com>
Signed-off-by: Kajol Jain <kjain@linux.ibm.com>
---
Changelog:
v6 -> v7
- Add Acked-by and Tested-by tag from Peter Zijlstra
  and Nageswara R Sastry.

 include/linux/nd.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/linux/nd.h b/include/linux/nd.h
index 8a8c63edb1b2..ad186e828263 100644
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
2.31.1

