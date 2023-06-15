Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F7C2E0D8
	for <nvdimm@lists.linux.dev>; Thu, 15 Jun 2023 18:13:38 +0000 (UTC)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35FGJh5d001337;
	Thu, 15 Jun 2023 18:13:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2023-03-30;
 bh=xYCyGNfPOHZLqOm0GIszmAyZZOQztuonNDERUOyQ1Zw=;
 b=jBl6Mew+siqLyuZbie1TYZniuNI//sqUnpFb3ZS5Q082N2+v7e1Q0tCxxv6m5Y+yTGeO
 qn7dtKYZhKak82JZ17pde1+v8FflSCRZtkA4rO0UacF8/N7Mq6oliOPXGI5GRnhaBcHr
 tcec/RLfCJdd4LE4ekhnOZhmzzRVO3xylFkOpiwSKAMeq7sZWD3f+f1imAvKbfa6te6Y
 rrlB5M/NPLnXUZ9L9IV9L5grA2mwqqc0Z8P3J0QrVwHtZBDIv1KgzZ7G2yrZGw4w7UD0
 MROAJfk9cB2lglBrsQajxRVQno1z8H8FGkiEJhCGkqZB3IQ/tPxErOgskTqEcU0GCdQT LQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4fs22qx3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jun 2023 18:13:32 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35FGVOQ8040560;
	Thu, 15 Jun 2023 18:13:31 GMT
Received: from brm-x62-16.us.oracle.com (brm-x62-16.us.oracle.com [10.80.150.37])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3r4fm70g4c-1;
	Thu, 15 Jun 2023 18:13:31 +0000
From: Jane Chu <jane.chu@oracle.com>
To: dan.j.williams@intel.com, vishal.l.verma@intel.com, dave.jiang@intel.com,
        ira.weiny@intel.com, willy@infradead.org, viro@zeniv.linux.org.uk,
        brauner@kernel.org, nvdimm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH v5 0/1] dax: enable dax fault handler to report VM_FAULT_HWPOISON 
Date: Thu, 15 Jun 2023 12:13:24 -0600
Message-Id: <20230615181325.1327259-1-jane.chu@oracle.com>
X-Mailer: git-send-email 2.18.4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-15_14,2023-06-15_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=630 mlxscore=0 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306150157
X-Proofpoint-GUID: xFj82FaAXvE_8ztIlbzaF0GHqAxUaFDn
X-Proofpoint-ORIG-GUID: xFj82FaAXvE_8ztIlbzaF0GHqAxUaFDn
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Change from v4:
Add comments describing when and why dax_mem2blk_err() is used.
Suggested by Dan.

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
 include/linux/dax.h          | 13 +++++++++++++
 include/linux/mm.h           |  2 ++
 7 files changed, 30 insertions(+), 9 deletions(-)

-- 
2.18.4

