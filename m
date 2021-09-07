Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D9B472
	for <nvdimm@lists.linux.dev>; Tue,  7 Sep 2021 15:36:56 +0000 (UTC)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 187FY7wQ170345;
	Tue, 7 Sep 2021 11:36:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pp1; bh=YR0uFKHuchxfPyamNB7isSc1s+WC95FtXW10xNxJKX8=;
 b=IwGJ0MZ8Qa9rJpF/8UV3PRf/b/wVuJMhXQ+fYT1Mvc/x4xpzsnmg5pLr1AIMEJnf5MJv
 u5tJRcUP11/pKZHgilhLUkUTjvXhDmkerf3BTHjSGeXr7S7E6nBHzwLVJ3ienzHJ1KMx
 o4zn5em3wthsSuDukt0B0lDeZBO4CEfugHN08uQBx4NrdXofXj9rwama68mdE5pF2+q8
 QrSizSsUfxL58MC1hkowrWuh0q8O16GnLrpkIcJCUZoOu5Iw3LaA0WXkNniytIg55Ny6
 bY06jQiwcVKEE0F9wVdPMs1QS9TBlJtEWo5nwrqdwliUCrdO5JFoCm6okG4TVlm/kJtI cQ== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3axab30wp9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Sep 2021 11:36:53 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
	by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 187FS9hO030119;
	Tue, 7 Sep 2021 15:36:50 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
	by ppma04fra.de.ibm.com with ESMTP id 3av0e9redy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Sep 2021 15:36:50 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
	by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 187FakTa57147854
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 7 Sep 2021 15:36:46 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 489B011C064;
	Tue,  7 Sep 2021 15:36:46 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3E01211C04A;
	Tue,  7 Sep 2021 15:36:45 +0000 (GMT)
Received: from [172.17.0.2] (unknown [9.40.192.207])
	by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Tue,  7 Sep 2021 15:36:45 +0000 (GMT)
Subject: [PATCH v2 0/3] test:ndtest: Fix various test cases on ndtest
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: nvdimm@lists.linux.dev
Cc: aneesh.kumar@linux.ibm.com, sbhat@linux.ibm.com, vaibhav@linux.ibm.com,
        dan.j.williams@intel.com, ira.weiny@intel.com,
        vishal.l.verma@intel.com
Date: Tue, 07 Sep 2021 15:36:44 +0000
Message-ID: <163102900429.260256.4127745415928272196.stgit@99912bbcb4c7>
User-Agent: StGit/1.1+40.g1b20
Content-Type: text/plain; charset="utf-8"
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Gd9G8i5yAjHMOL3SNCfNSNWpfWY4z702
X-Proofpoint-GUID: Gd9G8i5yAjHMOL3SNCfNSNWpfWY4z702
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-07_05:2021-09-07,2021-09-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 adultscore=0 spamscore=0 lowpriorityscore=0 priorityscore=1501 mlxscore=0
 clxscore=1015 mlxlogscore=480 phishscore=0 impostorscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2108310000
 definitions=main-2109070101

Changes since v1:
Link: https://patchwork.kernel.org/project/linux-nvdimm/cover/162737349828.3944327.12958894438783947695.stgit@lep8c.aus.stglabs.ibm.com/
* Updated patch descriptions

papr_scm[1] and ndtest[2] now support PDSMs for injecting smart errors
that can exercise various libndctl code paths. The following patch
series updates libndctl to support injecting these inject-smart events
to an nvdimm. Since the support for inject-smart is presently limited
to injecting fatal-health and dirty-shutdown the patch-series tweaks
the ndctl tests to only exercise certain applicable tests for PAPR
nvdimms.

The patches to be applied on the series[3] which added the necessary
smart error injection support.

The make check results look like this below on PPC64LE system.

PASS: libndctl
PASS: dsm-fail
FAIL: dpa-alloc
FAIL: parent-uuid
PASS: multi-pmem
PASS: create.sh
FAIL: clear.sh
FAIL: pmem-errors.sh
FAIL: daxdev-errors.sh
PASS: multi-dax.sh
PASS: btt-check.sh
FAIL: label-compat.sh
PASS: blk-exhaust.sh
PASS: sector-mode.sh
FAIL: inject-error.sh
SKIP: btt-errors.sh
SKIP: hugetlb
PASS: btt-pad-compat.sh
SKIP: firmware-update.sh
SKIP: ack-shutdown-count-set
PASS: rescan-partitions.sh
PASS: inject-smart.sh
PASS: monitor.sh
PASS: max_available_extent_ns.sh
FAIL: pfn-meta-errors.sh
PASS: track-uuid.sh
============================================================================
Testsuite summary for ndctl 71.35.gf8b89d5
============================================================================
# TOTAL: 26
# PASS:  14
# SKIP:  4
# XFAIL: 0
# FAIL:  8
# XPASS: 0
# ERROR: 0
============================================================================

[1] : https://patchwork.kernel.org/project/linux-nvdimm/patch/163091917031.334.16212158243308361834.stgit@82313cf9f602/
[2] : https://patchwork.kernel.org/project/linux-nvdimm/patch/163091957728.562.4766998781117968879.stgit@82313cf9f602/
[3] : https://patchwork.kernel.org/project/linux-nvdimm/list/?series=543183

---

Shivaprasad G Bhat (3):
      test/inject-smart: Enable inject-smart tests on ndtest
      ndtest/ack-shutdown-count: Skip the test on ndtest
      test/monitor.sh: Partially skip monitor test on ndtest


 test/ack-shutdown-count-set.c |  4 +++
 test/inject-smart.sh          | 12 ++++++---
 test/libndctl.c               | 46 +++++++++++++++++++++++++++++++++++
 test/list-smart-dimm.c        | 36 ++++++++++++++++++++++++++-
 test/monitor.sh               | 11 ++++++++-
 5 files changed, 103 insertions(+), 6 deletions(-)

--
Signature

