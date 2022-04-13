Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B1723C6
	for <nvdimm@lists.linux.dev>; Wed, 13 Apr 2022 03:53:13 +0000 (UTC)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23D2g39d019275;
	Wed, 13 Apr 2022 03:53:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=13nSWFUDW0JuOBGWU81AHuQjKCONk7Io7weBANkFIH4=;
 b=Ly6W3ZhBgE9FCzGGO9M+4GoLbHnsxBdzLKIbd+fUo7q2LFDxU6ElrdrBQh+P986zH7pk
 En4vRn2/nrebu1NlLNQkbRH/5Rv+9VJYnGWcVkgQXmofEWTql10P8PR7jVDRqazxZ+GS
 ZSwTckeH9RgUmfkErUJfvfpcXD/e4r3rr6QbcIcuCdtz1WSY4AQphqzwKSSFq1OeCSkh
 9R1ri+1btySLbYGdSo4X3l5TPUJMk8cP8jU3KpRtGYXCu0q34rfdoZZMI4W1/tyt+4/v
 AWlOA6ihJIY3+RJkijDM6TFhjzoDjjAYHv9wJP6D/RgxtyrnNLru0HndPLGB6q92V+9p ig== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3fdny5h130-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Apr 2022 03:53:12 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
	by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23D3ljfX012811;
	Wed, 13 Apr 2022 03:53:10 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
	by ppma04fra.de.ibm.com with ESMTP id 3fb1s8vxpk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Apr 2022 03:53:10 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
	by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23D3eaBh47710490
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Apr 2022 03:40:36 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3BC6642041;
	Wed, 13 Apr 2022 03:53:07 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8DC9C4203F;
	Wed, 13 Apr 2022 03:53:04 +0000 (GMT)
Received: from li-efb8054c-3504-11b2-a85c-ca10df28279e.ibm.com.com (unknown [9.43.41.9])
	by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Wed, 13 Apr 2022 03:53:04 +0000 (GMT)
From: Tarun Sahu <tsahu@linux.ibm.com>
To: nvdimm@lists.linux.dev
Cc: tsahu@linux.ibm.com, dan.j.williams@intel.com, vishal.l.verma@intel.com,
        aneesh.kumar@linux.ibm.com, sbhat@linux.ibm.com, vaibhav@linux.ibm.com
Subject: [PATCH 2/2] ndctl/namespace:Implement write-infoblock for sector mode namespaces
Date: Wed, 13 Apr 2022 09:22:52 +0530
Message-Id: <20220413035252.161527-3-tsahu@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220413035252.161527-1-tsahu@linux.ibm.com>
References: <20220413035252.161527-1-tsahu@linux.ibm.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: DuLRhkeIEq4aYmJZzJwy28Eo_6oSi313
X-Proofpoint-ORIG-GUID: DuLRhkeIEq4aYmJZzJwy28Eo_6oSi313
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-12_06,2022-04-12_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 clxscore=1015
 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0 bulkscore=0
 spamscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204130018

Following to the previous patch in this series,
once the namespace info has been collected in ns_info,
while writing to the infoblock for sector mode, it can be
written with original infoblock values except the ones that
have been provided by parameter arguments to write-infoblock command.

Currently, this patch allows only uuid and parent_uuid to be
changed, In future support for other values can be implemented
easily by adding condition inside write_btt_sb() function, which
has been created to write BTT sector mode specific namespace.

$ ./ndctl read-infoblock namespace0.0 -j
[
  {
    "dev":"namespace0.0",
    "signature":"BTT_ARENA_INFO",
    "uuid":"7296ebd6-7039-4d02-9ed9-ac5f351ff0e4",
    "parent_uuid":"46850d31-8fb5-4492-b630-9f3cd7b77500",
    "flags":0,
    "version":"2.0",
    "external_lbasize":4096,
    "external_nlba":8380160,
    "internal_lbasize":4096,
    "internal_nlba":8380416,
    "nfree":256,
    "infosize":4096,
    "nextoff":0,
    "dataoff":4096,
    "mapoff":34326196224,
    "logoff":34359717888,
    "info2off":34359734272
  }
]
read 1 infoblock

$ ./ndctl write-infoblock namespace0.0 \
>	--uuid "d0b19883-0874-4847-8c71-71549590949c"
wrote 1 infoblock

$ ./ndctl read-infoblock namespace0.0 -j
[
  {
    "dev":"namespace0.0",
    "signature":"BTT_ARENA_INFO",
    "uuid":"d0b19883-0874-4847-8c71-71549590949c",
    "parent_uuid":"46850d31-8fb5-4492-b630-9f3cd7b77500",
    "flags":0,
    "version":"2.0",
    "external_lbasize":4096,
    "external_nlba":8380160,
    "internal_lbasize":4096,
    "internal_nlba":8380416,
    "nfree":256,
    "infosize":4096,
    "nextoff":0,
    "dataoff":4096,
    "mapoff":34326196224,
    "logoff":34359717888,
    "info2off":34359734272
  }
]
read 1 infoblock

Signed-off-by: Tarun Sahu <tsahu@linux.ibm.com>
---
 ndctl/namespace.c | 52 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index 4555a63..82f370b 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -247,6 +247,7 @@ static int set_defaults(enum device_action action)
 			break;
 		case NDCTL_NS_MODE_FSDAX:
 		case NDCTL_NS_MODE_DEVDAX:
+		case NDCTL_NS_MODE_SECTOR:
 			break;
 		default:
 			if (action == ACTION_WRITE_INFOBLOCK) {
@@ -2008,6 +2009,50 @@ static int write_pfn_sb(int fd, unsigned long long size, const char *sig,
 	return 0;
 }
 
+static int write_btt_sb(const int fd, unsigned long long size, struct ns_info *ns_info)
+{
+	int rc = 0;
+	uuid_t uuid, parent_uuid;
+
+	// updating the original values which are asked to change,
+	// rest will be unchanged
+	if (param.uuid) {
+		rc = uuid_parse(param.uuid, uuid);
+		if (rc) {
+			pr_verbose("Failed to parse UUID");
+			return rc;
+		}
+		memcpy(((struct btt_sb *)(ns_info->ns_sb_buf + ns_info->offset))->uuid,
+				uuid, sizeof(uuid_t));
+	}
+	if (param.parent_uuid) {
+		rc = uuid_parse(param.parent_uuid, parent_uuid);
+		if (rc) {
+			pr_verbose("Failed to parse UUID");
+			return rc;
+		}
+		memcpy(((struct btt_sb *)(ns_info->ns_sb_buf + ns_info->offset))->parent_uuid,
+				parent_uuid, sizeof(uuid_t));
+	}
+
+	if (pwrite(fd, ns_info->ns_sb_buf + ns_info->offset, sizeof(struct btt_sb),
+			       ns_info->offset) < 0) {
+		pr_verbose("Unable to write the info block: %s\n",
+				strerror(errno));
+		rc = -errno;
+	}
+
+	if (pwrite(fd, ns_info->ns_sb_buf + ns_info->offset, sizeof(struct btt_sb),
+				size - sizeof(struct btt_sb)) < 0) {
+		pr_verbose("Unable to write the info block: %s\n",
+			strerror(errno));
+		rc = -errno;
+	}
+	return rc;
+}
+
+
+
 static int file_write_infoblock(const char *path, struct ns_info *ns_info)
 {
 	unsigned long long size = parse_size64(param.size);
@@ -2055,6 +2100,10 @@ static int file_write_infoblock(const char *path, struct ns_info *ns_info)
 	case NDCTL_NS_MODE_DEVDAX:
 		rc = write_pfn_sb(fd, size, DAX_SIG, ns_info);
 		break;
+	case NDCTL_NS_MODE_SECTOR:
+		if (ns_info->mode == NDCTL_NS_MODE_SECTOR)
+			rc = write_btt_sb(fd, size, ns_info);
+		break;
 	case NDCTL_NS_MODE_UNKNOWN:
 		switch (ns_info->mode) {
 		case NDCTL_NS_MODE_FSDAX:
@@ -2063,6 +2112,9 @@ static int file_write_infoblock(const char *path, struct ns_info *ns_info)
 		case NDCTL_NS_MODE_DEVDAX:
 			rc = write_pfn_sb(fd, size, DAX_SIG, ns_info);
 			break;
+		case NDCTL_NS_MODE_SECTOR:
+			rc = write_btt_sb(fd, size, ns_info);
+			break;
 		default:
 			rc = -EINVAL;
 			break;
-- 
2.18.1

