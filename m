Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672D97E
	for <nvdimm@lists.linux.dev>; Fri,  5 May 2023 01:18:26 +0000 (UTC)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 344LwpWM000776;
	Fri, 5 May 2023 01:18:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2023-03-30;
 bh=2wYkjBDt1hBOZQJuPalAgsuRCkMbwfLqlGTFy2J9KjI=;
 b=NC9caCb6iQGuv+7gEcCP/YuUwU7qkFLzQj/MgFYyjq6MLp6AbA5dPo9U+6EuWd4itCJn
 33xV1OmiA0J6CaQlHu7ErghWw0c1nlnr5ylGujEEVSgY9eqcikP11eUx2rqopIvELeJ6
 7L0pxYsj/ymBJHRyEmSetLxOKVjRq4uLexSp2JLnBLqkIVQUFMzNAqiK7vDYADLD2AkW
 qEq+1aE1lWTJSXSDIcT8cI6E/p5xCdb8K7eU4e/JM+7kUq3i4a/3czPV2BxgYos5hmYh
 Y/0mubBkoSzjghdXYxTkp8z8tER0A7VoK/V6Dbmbmw2Fl6XQJzZASJuz3SmNljb99z+1 xg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3q8u9d3pkf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 May 2023 01:18:00 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34510RKd009860;
	Fri, 5 May 2023 01:17:59 GMT
Received: from brm-x62-16.us.oracle.com (brm-x62-16.us.oracle.com [10.80.150.37])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3q8sp9rvpe-1;
	Fri, 05 May 2023 01:17:59 +0000
From: Jane Chu <jane.chu@oracle.com>
To: dan.j.williams@intel.com, vishal.l.verma@intel.com, dave.jiang@intel.com,
        ira.weiny@intel.com, willy@infradead.org, viro@zeniv.linux.org.uk,
        brauner@kernel.org, nvdimm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH v3] dax: enable dax fault handler to report VM_FAULT_HWPOISON
Date: Thu,  4 May 2023 19:17:47 -0600
Message-Id: <20230505011747.956945-1-jane.chu@oracle.com>
X-Mailer: git-send-email 2.18.4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-04_15,2023-05-04_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2305050009
X-Proofpoint-GUID: aiXFBile4Qv6bbV8wTMcalz3Cdbuc7eb
X-Proofpoint-ORIG-GUID: aiXFBile4Qv6bbV8wTMcalz3Cdbuc7eb
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

When multiple processes mmap() a dax file, then at some point,
a process issues a 'load' and consumes a hwpoison, the process
receives a SIGBUS with si_code = BUS_MCEERR_AR and with si_lsb
set for the poison scope. Soon after, any other process issues
a 'load' to the poisoned page (that is unmapped from the kernel
side by memory_failure), it receives a SIGBUS with
si_code = BUS_ADRERR and without valid si_lsb.

This is confusing to user, and is different from page fault due
to poison in RAM memory, also some helpful information is lost.

Channel dax backend driver's poison detection to the filesystem
such that instead of reporting VM_FAULT_SIGBUS, it could report
VM_FAULT_HWPOISON.

Change from v2:
  Convert -EHWPOISON to -EIO to prevent EHWPOISON errno from leaking
out to block read(2) - suggested by Matthew.

Signed-off-by: Jane Chu <jane.chu@oracle.com>
---
 drivers/nvdimm/pmem.c | 2 +-
 fs/dax.c              | 4 ++--
 include/linux/mm.h    | 2 ++
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index ceea55f621cc..46e094e56159 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -260,7 +260,7 @@ __weak long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
 		long actual_nr;
 
 		if (mode != DAX_RECOVERY_WRITE)
-			return -EIO;
+			return -EHWPOISON;
 
 		/*
 		 * Set the recovery stride is set to kernel page size because
diff --git a/fs/dax.c b/fs/dax.c
index 2ababb89918d..18f9598951f1 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1498,7 +1498,7 @@ static loff_t dax_iomap_iter(const struct iomap_iter *iomi,
 
 		map_len = dax_direct_access(dax_dev, pgoff, PHYS_PFN(size),
 				DAX_ACCESS, &kaddr, NULL);
-		if (map_len == -EIO && iov_iter_rw(iter) == WRITE) {
+		if (map_len == -EHWPOISON && iov_iter_rw(iter) == WRITE) {
 			map_len = dax_direct_access(dax_dev, pgoff,
 					PHYS_PFN(size), DAX_RECOVERY_WRITE,
 					&kaddr, NULL);
@@ -1506,7 +1506,7 @@ static loff_t dax_iomap_iter(const struct iomap_iter *iomi,
 				recovery = true;
 		}
 		if (map_len < 0) {
-			ret = map_len;
+			ret = (map_len == -EHWPOISON) ? -EIO : map_len;
 			break;
 		}
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 1f79667824eb..e4c974587659 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3217,6 +3217,8 @@ static inline vm_fault_t vmf_error(int err)
 {
 	if (err == -ENOMEM)
 		return VM_FAULT_OOM;
+	else if (err == -EHWPOISON)
+		return VM_FAULT_HWPOISON;
 	return VM_FAULT_SIGBUS;
 }
 
-- 
2.18.4

