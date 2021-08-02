Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A81348A
	for <nvdimm@lists.linux.dev>; Mon,  2 Aug 2021 07:40:50 +0000 (UTC)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1727YcRL088949;
	Mon, 2 Aug 2021 03:40:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=eoTJEvz+JydVpcyo3wyKqaG3a7A5ENI2Xhcr/Kl0uXY=;
 b=gMEXa56QaoRSpZyYDaKXx55VeLP5SECgfxnl83QrKEkcgMHZCLfBPD982dnRE/HGjgoC
 tOEIMBYIOa+SFYrJhaPAyRida3UjC2So0Rr43KbC/90uAxOkKAJZgiEAVMALyfEyxkLe
 lGhUBLGoj9hSZni9IxbygeMQiWopz49by9xhlAIwJ8R28O+KAq19uiw2q7kzhllxgIz7
 jhfLVU50tssZzwSrkO/O9x/sIR2U7ZP1jeFAF9HGDX1lr6wpsMFJLg8gvHebkxg9h5nW
 332+WoY49HiDKtMQAD7peE7bj14u7RZmeLr8TlX1jo8ZxDiNbsZgIaMzT2GIFSD6IhZs ew== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
	by mx0b-001b2d01.pphosted.com with ESMTP id 3a5m019e8r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Aug 2021 03:40:40 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
	by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1727dBuZ004695;
	Mon, 2 Aug 2021 07:40:39 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
	by ppma03fra.de.ibm.com with ESMTP id 3a4x58kkwq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Aug 2021 07:40:38 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
	by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1727eYks30212496
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 2 Aug 2021 07:40:34 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 586DEA405D;
	Mon,  2 Aug 2021 07:40:34 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AE6DCA4040;
	Mon,  2 Aug 2021 07:40:29 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.199.36.88])
	by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Mon,  2 Aug 2021 07:40:29 +0000 (GMT)
From: Kajol Jain <kjain@linux.ibm.com>
To: mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org, nvdimm@lists.linux.dev,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        dan.j.williams@intel.com, ira.weiny@intel.com,
        vishal.l.verma@intel.com
Cc: maddy@linux.ibm.com, santosh@fossix.org, aneesh.kumar@linux.ibm.com,
        vaibhav@linux.ibm.com, atrajeev@linux.vnet.ibm.com, tglx@linutronix.de,
        kjain@linux.ibm.com, rnsastry@linux.ibm.com
Subject: [PATCH v4 4/4] powerpc/papr_scm: Document papr_scm sysfs event format entries
Date: Mon,  2 Aug 2021 13:09:29 +0530
Message-Id: <20210802073929.907431-5-kjain@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210802073929.907431-1-kjain@linux.ibm.com>
References: <20210802073929.907431-1-kjain@linux.ibm.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: EN59ABGtaZ000sASuNIwNFJwXfnEYNRA
X-Proofpoint-GUID: EN59ABGtaZ000sASuNIwNFJwXfnEYNRA
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-02_01:2021-08-02,2021-08-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 mlxlogscore=999 lowpriorityscore=0 clxscore=1015 priorityscore=1501
 mlxscore=0 malwarescore=0 phishscore=0 bulkscore=0 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108020053

Details is added for the event, cpumask and format attributes
in the ABI documentation.

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Tested-by: Nageswara R Sastry <rnsastry@linux.ibm.com>
Signed-off-by: Kajol Jain <kjain@linux.ibm.com>
---
 Documentation/ABI/testing/sysfs-bus-papr-pmem | 31 +++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-papr-pmem b/Documentation/ABI/testing/sysfs-bus-papr-pmem
index 95254cec92bf..4d86252448f8 100644
--- a/Documentation/ABI/testing/sysfs-bus-papr-pmem
+++ b/Documentation/ABI/testing/sysfs-bus-papr-pmem
@@ -61,3 +61,34 @@ Description:
 		* "CchRHCnt" : Cache Read Hit Count
 		* "CchWHCnt" : Cache Write Hit Count
 		* "FastWCnt" : Fast Write Count
+
+What:		/sys/devices/nmemX/format
+Date:		June 2021
+Contact:	linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, nvdimm@lists.linux.dev,
+Description:	(RO) Attribute group to describe the magic bits
+                that go into perf_event_attr.config for a particular pmu.
+                (See ABI/testing/sysfs-bus-event_source-devices-format).
+
+                Each attribute under this group defines a bit range of the
+                perf_event_attr.config. Supported attribute is listed
+                below::
+
+		    event  = "config:0-4"  - event ID
+
+		For example::
+		    noopstat = "event=0x1"
+
+What:		/sys/devices/nmemX/events
+Date:		June 2021
+Contact:	linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, nvdimm@lists.linux.dev,
+Description:    (RO) Attribute group to describe performance monitoring
+                events specific to papr-scm. Each attribute in this group describes
+                a single performance monitoring event supported by this nvdimm pmu.
+                The name of the file is the name of the event.
+                (See ABI/testing/sysfs-bus-event_source-devices-events).
+
+What:		/sys/devices/nmemX/cpumask
+Date:		June 2021
+Contact:	linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, nvdimm@lists.linux.dev,
+Description:	(RO) This sysfs file exposes the cpumask which is designated to make
+                HCALLs to retrieve nvdimm pmu event counter data.
-- 
2.26.2

