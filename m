Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D922F3A
	for <nvdimm@lists.linux.dev>; Thu,  6 Apr 2023 23:01:51 +0000 (UTC)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 336MRxvo013858;
	Thu, 6 Apr 2023 23:01:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2022-7-12;
 bh=QYrH7mgx9goRgDjZnqA63zjuyrkGvo4AdK4TauLX8A8=;
 b=yh3NYsUNBCzx4Q8vjpGLqFRWbYQ5hFX50BLsXK9/Uu9UVlREaO9zmtHBpd62mWwKNsGP
 c9ApWwfJzcG1EmXGV2OkMBQTroGMtt/3wITD98lNZsn4LzO56DPy47qtUQ5eVtoCI3sN
 suG7bmYEEwyu951tHNqHTl9a4+uzNVZYlAWSjrtf4qVy2GPYXVQcN/7gO3o2CckN2+M/
 luIG0rr/RzAd3czsh9hufvo5Yl4UKHP88qJtCUajemi7yt745+beXEH6r+Gkrs01rH0J
 GtRFZAYMALVSDs4oJ0j6t9C/0P0lNkS9mQH21ToI78pK95dP0nxrHVYaBAvYD8LBR2ZS 7w== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ppbd442q2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Apr 2023 23:01:34 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 336KlH5P009090;
	Thu, 6 Apr 2023 23:01:33 GMT
Received: from brm-x62-16.us.oracle.com (brm-x62-16.us.oracle.com [10.80.150.37])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3ppt3kqpt4-1;
	Thu, 06 Apr 2023 23:01:33 +0000
From: Jane Chu <jane.chu@oracle.com>
To: dan.j.williams@intel.com, vishal.l.verma@intel.com, dave.jiang@intel.com,
        ira.weiny@intel.com, willy@infradead.org, viro@zeniv.linux.org.uk,
        brauner@kernel.org, nvdimm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH v2] dax: enable dax fault handler to report VM_FAULT_HWPOISON
Date: Thu,  6 Apr 2023 17:01:27 -0600
Message-Id: <20230406230127.716716-1-jane.chu@oracle.com>
X-Mailer: git-send-email 2.18.4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-06_12,2023-04-06_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 suspectscore=0 spamscore=0 malwarescore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304060200
X-Proofpoint-ORIG-GUID: nMaMTcFEj8i5h-91hzIIjnDqo_X59Jn0
X-Proofpoint-GUID: nMaMTcFEj8i5h-91hzIIjnDqo_X59Jn0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

When dax fault handler fails to provision the fault page due to
hwpoison, it returns VM_FAULT_SIGBUS which lead to a sigbus delivered
to userspace with .si_code BUS_ADRERR.  Channel dax backend driver's
detection on hwpoison to the filesystem to provide the precise reason
for the fault.

Signed-off-by: Jane Chu <jane.chu@oracle.com>
---
 drivers/nvdimm/pmem.c | 2 +-
 fs/dax.c              | 2 +-
 include/linux/mm.h    | 2 ++
 3 files changed, 4 insertions(+), 2 deletions(-)

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
index 3e457a16c7d1..c93191cd4802 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1456,7 +1456,7 @@ static loff_t dax_iomap_iter(const struct iomap_iter *iomi,
 
 		map_len = dax_direct_access(dax_dev, pgoff, PHYS_PFN(size),
 				DAX_ACCESS, &kaddr, NULL);
-		if (map_len == -EIO && iov_iter_rw(iter) == WRITE) {
+		if (map_len == -EHWPOISON && iov_iter_rw(iter) == WRITE) {
 			map_len = dax_direct_access(dax_dev, pgoff,
 					PHYS_PFN(size), DAX_RECOVERY_WRITE,
 					&kaddr, NULL);
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

