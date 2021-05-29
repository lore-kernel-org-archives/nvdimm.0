Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13006D14
	for <nvdimm@lists.linux.dev>; Sat, 29 May 2021 07:39:11 +0000 (UTC)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14T7YM79085792;
	Sat, 29 May 2021 03:39:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=LMk7SrRrXQ/vzbySKtIU8w16pKX+vZ9d3leb2ZMVw6w=;
 b=VmGvIDzD9Pv1XgMjffdR7kWG8uPVjQ6+PLR8nwzaDGevHFaBILSngWp52A1p/y3TDpJx
 ux7dC0wtKR6dalzYolJN4md/+IJGeA+/CWPlnIXNXzKNjxmCL5d1Wl8C4ZIZURnvjh9m
 pVjMx1bkqze7pwO4NkMPQPnzbnezDCdNZOz/CcsAsWIGwTf+CbnVXbqxEwR9fsOrGC9A
 duwiRr0ZHVMK8DJ7xAfyk2vLJGI+97Ten4sAAooBy0MzgnsVG8HEj9314Rv2liNWwJOQ
 IX/Y4AHdtviiYJxywN7reh+s4hqa8ws2I0s1/nSHmvZ3zCKyPjPGj8/39hqdr7Eng+SJ Bw== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
	by mx0a-001b2d01.pphosted.com with ESMTP id 38ugwpgfce-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 29 May 2021 03:39:03 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
	by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 14T7d1Yw021139;
	Sat, 29 May 2021 07:39:01 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
	by ppma06ams.nl.ibm.com with ESMTP id 38ucvh82bh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 29 May 2021 07:39:01 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
	by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14T7cSqj33161590
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 29 May 2021 07:38:28 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 76D1C4C04A;
	Sat, 29 May 2021 07:38:58 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E87A74C040;
	Sat, 29 May 2021 07:38:54 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.199.45.117])
	by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Sat, 29 May 2021 07:38:54 +0000 (GMT)
From: Kajol Jain <kjain@linux.ibm.com>
To: mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org, nvdimm@lists.linux.dev,
        linux-kernel@vger.kernel.org, peterz@infradead.org
Cc: maddy@linux.vnet.ibm.com, santosh@fossix.org, aneesh.kumar@linux.ibm.com,
        vaibhav@linux.ibm.com, dan.j.williams@intel.com, ira.weiny@intel.com,
        atrajeev@linux.vnet.ibm.com, tglx@linutronix.de, kjain@linux.ibm.com,
        rnsastry@linux.ibm.com
Subject: [RFC v3 4/4] powerpc/papr_scm: Document papr_scm sysfs event format entries
Date: Sat, 29 May 2021 13:08:28 +0530
Message-Id: <20210529073828.1542292-5-kjain@linux.ibm.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210529073828.1542292-1-kjain@linux.ibm.com>
References: <20210529073828.1542292-1-kjain@linux.ibm.com>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: sNh9OA4sr30Qm-Df3YfWwKuZHq56W_Ft
X-Proofpoint-GUID: sNh9OA4sr30Qm-Df3YfWwKuZHq56W_Ft
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-29_03:2021-05-27,2021-05-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 bulkscore=0 priorityscore=1501 phishscore=0 clxscore=1015 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 impostorscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105290058

Details is added for the event, cpumask and format attributes
in the ABI documentation.

Signed-off-by: Kajol Jain <kjain@linux.ibm.com>
---
 Documentation/ABI/testing/sysfs-bus-papr-pmem | 31 +++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-papr-pmem b/Documentation/ABI/testing/sysfs-bus-papr-pmem
index 92e2db0e2d3d..2de9c8d2168f 100644
--- a/Documentation/ABI/testing/sysfs-bus-papr-pmem
+++ b/Documentation/ABI/testing/sysfs-bus-papr-pmem
@@ -59,3 +59,34 @@ Description:
 		* "CchRHCnt" : Cache Read Hit Count
 		* "CchWHCnt" : Cache Write Hit Count
 		* "FastWCnt" : Fast Write Count
+
+What:		/sys/devices/nmemX/format
+Date:		May 2021
+Contact:	linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-nvdimm@lists.01.org,
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
+Date:		May 2021
+Contact:	linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-nvdimm@lists.01.org,
+Description:    (RO) Attribute group to describe performance monitoring
+                events specific to papr-scm. Each attribute in this group describes
+                a single performance monitoring event supported by this nvdimm pmu.
+                The name of the file is the name of the event.
+                (See ABI/testing/sysfs-bus-event_source-devices-events).
+
+What:		/sys/devices/nmemX/cpumask
+Date:		May 2021
+Contact:	linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-nvdimm@lists.01.org,
+Description:	(RO) This sysfs file exposes the cpumask which is designated to make
+                HCALLs to retrieve nvdimm pmu event counter data.
-- 
2.27.0

