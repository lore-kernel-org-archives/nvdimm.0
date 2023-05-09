Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE012104
	for <nvdimm@lists.linux.dev>; Tue,  9 May 2023 05:47:42 +0000 (UTC)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 348NxdMe024126;
	Tue, 9 May 2023 05:47:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2023-03-30;
 bh=50u2xjNWdhe8Y8dEnyMSIRqp+jBEMtcSls+BAFjd/Vk=;
 b=DD9G7sGFFb5aqhSUmCAmi7UB79Qh0bmg8nVZ7OfuO9VDJC/QxuOFjoLAdfTd6ZaexgsU
 UkG9Anckr1HQ2BRuJuEIKQ2dDuUj28Yc3TgU5ZuREjO91lVjJq/75aqp/1lkhh3ZTaDJ
 OshpJaqQoduqZsKindLXXbrpwsKQJekBRgEIzVHL9w56WieizzH+HumGiJ/CO/lrtqdP
 q40hthDLjxLSCNHoWX6uTQtrnL80LLmkDvInLPjW8geV5k6BZy59PmvL6FrOaWXXSlmv
 Xjm8tUFId5RBUo5dxmo1Fz/DZ6Z1GBvhkXPc23JAkOIeRWkF8lOuYER+J1kp0vAl1WsV Rw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qf77c0we1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 May 2023 05:47:25 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3495JB4T001645;
	Tue, 9 May 2023 05:47:24 GMT
Received: from brm-x62-16.us.oracle.com (brm-x62-16.us.oracle.com [10.80.150.37])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3qf82v5m4u-1;
	Tue, 09 May 2023 05:47:24 +0000
From: Jane Chu <jane.chu@oracle.com>
To: dan.j.williams@intel.com, vishal.l.verma@intel.com, dave.jiang@intel.com,
        ira.weiny@intel.com, willy@infradead.org, viro@zeniv.linux.org.uk,
        brauner@kernel.org, nvdimm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH v4 0/1] dax: enable dax fault handler to report VM_FAULT_HWPOISON 
Date: Mon,  8 May 2023 23:47:13 -0600
Message-Id: <20230509054714.1746956-1-jane.chu@oracle.com>
X-Mailer: git-send-email 2.18.4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-09_02,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=751 malwarescore=0
 adultscore=0 mlxscore=0 bulkscore=0 suspectscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305090043
X-Proofpoint-GUID: HsApzT22YVGaDpzF_HEaS5RLcoOczj-A
X-Proofpoint-ORIG-GUID: HsApzT22YVGaDpzF_HEaS5RLcoOczj-A
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Change from v3:
Prevent leaking EHWPOISON to user level block IO calls such as
zero_range_range, and truncate.  Suggested by Dan.

Change from v2:
Convert EHWPOISON to EIO to prevent EHWPOISON errno from leaking
out to block read(2). Suggested by Matthew.

Jane Chu (1):
  dax: enable dax fault handler to report VM_FAULT_HWPOISON

 drivers/dax/super.c          |  5 ++++-
 drivers/nvdimm/pmem.c        |  2 +-
 drivers/s390/block/dcssblk.c |  3 ++-
 fs/dax.c                     | 11 ++++++-----
 fs/fuse/virtio_fs.c          |  3 ++-
 include/linux/dax.h          |  5 +++++
 include/linux/mm.h           |  2 ++
 7 files changed, 22 insertions(+), 9 deletions(-)

-- 
2.18.4

