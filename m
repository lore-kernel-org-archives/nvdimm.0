Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1533670
	for <nvdimm@lists.linux.dev>; Thu,  8 Jul 2021 10:32:32 +0000 (UTC)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 168A3iG0194568;
	Thu, 8 Jul 2021 06:06:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=A49S95tmR3GVP6Q6S6022eDQiX0sJlLNSCU2qT+kHik=;
 b=nXHvHue75LTuVS6M5a0LEDiW/vNAeYVnOXI92YBDEBtNIOiEQbpAtOZB2fTS1djHSNx7
 cB94JtrVK2pEZ3sLg/+1RFYxAbQMK52tDjqJOQY44MQSdbsp0OHjNVMbWYjt547ZKv85
 GZoQcMeTQ4w7Z5MVQf+e5oUuNSvJmpZQx5xAtL+xJfx9pWCQ4DjOFOgBIuJZWBBEVhBF
 Ni5j3ngSPc17SAbBn43lRE/lsdBybmaQGYbYnsLsEzOmDSPC3/YQw9owx8syI2mX8Z9p
 Dut++cHv7VnlPawjFyZui7ifOLLe5+3PrLvvRXjPNLrqNl74vfc0gJg1VPILDQArgCeB zA== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
	by mx0a-001b2d01.pphosted.com with ESMTP id 39n2875f65-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Jul 2021 06:06:19 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
	by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 168A2FtC011710;
	Thu, 8 Jul 2021 10:06:17 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
	by ppma02wdc.us.ibm.com with ESMTP id 39jfhckhbp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Jul 2021 10:06:17 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
	by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 168A6GML11862440
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 8 Jul 2021 10:06:17 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7DF4BAEA1B;
	Thu,  8 Jul 2021 10:06:13 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5508113B2DA;
	Thu,  8 Jul 2021 10:01:07 +0000 (GMT)
Received: from skywalker.ibmuc.com (unknown [9.85.73.37])
	by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
	Thu,  8 Jul 2021 10:01:07 +0000 (GMT)
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
To: nvdimm@lists.linux.dev, dan.j.williams@intel.com,
        Vishal L Verma <vishal.l.verma@intel.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: [PATCH] ndctl: Avoid confusing error message when operating on all the namespaces
Date: Thu,  8 Jul 2021 15:31:04 +0530
Message-Id: <20210708100104.168348-1-aneesh.kumar@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _GYFkQcOQxY6zlBuk9WQIuzqTvqx-mlc
X-Proofpoint-ORIG-GUID: _GYFkQcOQxY6zlBuk9WQIuzqTvqx-mlc
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-08_04:2021-07-06,2021-07-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 impostorscore=0
 mlxscore=0 priorityscore=1501 malwarescore=0 suspectscore=0 spamscore=0
 phishscore=0 lowpriorityscore=0 mlxlogscore=977 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107080055

With only seed namespace present, ndctl results in confusing error messages as
below.

ndctl# ./ndctl/ndctl  enable-namespace all
error enabling namespaces: No such device or address
enabled 0 namespaces

ndctl# ./ndctl/ndctl  disable-namespace all
disabled 3 namespaces

ndctl# ./ndctl/ndctl  destroy-namespace all -f
  Error: destroy namespace: namespace1.0 failed to enable for zeroing, continuing

  Error: destroy namespace: namespace1.1 failed to enable for zeroing, continuing

  Error: destroy namespace: namespace0.0 failed to enable for zeroing, continuing

destroyed 0 namespaces
ndctl#

With the patch we get
ndctl# ./ndctl/ndctl  disable-namespace all
disabled 0 namespaces

ndctl# ./ndctl/ndctl  enable-namespace all
enabled 0 namespaces

ndctl# ./ndctl/ndctl  destroy-namespace all -f
destroyed 0 namespaces
ndctl#

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
---
 ndctl/namespace.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index 0c8df9fa8b47..c52daeae562a 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -2205,8 +2205,15 @@ static int do_xaction_namespace(const char *namespace,
 				return rc;
 			}
 			ndctl_namespace_foreach_safe(region, ndns, _n) {
-				ndns_name = ndctl_namespace_get_devname(ndns);
 
+				if (!strcmp(namespace, "all")
+						&& !ndctl_namespace_get_size(ndns)) {
+					if (!*processed && rc)
+						rc  = 0;
+					continue;
+				}
+
+				ndns_name = ndctl_namespace_get_devname(ndns);
 				if (strcmp(namespace, "all") != 0
 						&& strcmp(namespace, ndns_name) != 0)
 					continue;
-- 
2.31.1

