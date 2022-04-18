Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A2CA29
	for <nvdimm@lists.linux.dev>; Mon, 18 Apr 2022 17:10:00 +0000 (UTC)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23IEkpsu011941;
	Mon, 18 Apr 2022 17:09:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pp1; bh=5r+dvWk6z+oYjnXfj1ZG5MSk+ta9M9kYVoUqAhK5x8E=;
 b=MnoJo5+Tb1o3JwUED8qt+gNPREqRxSK4lXsYFNPGwifgg2uyPEe82o0c6dOb9v3ZGQbY
 OYqmWQVLnWAfnKbQFqqyVCj6CI7h4foa6bhpVNx6X8eKvX/RvwdT5wN5fQd63qLI96W3
 iaqSBxShHRzoBVLK3ImOc6B91KQ/OmFWOnWKM0+u/caPskXJww+FALbRdjONmxkwmyQF
 KCA8fMPR2hVtlDfPePGBCK4ivqvDoXAGtdr+YtEaw/rzgI4q2wY4NMDmclqZqH8gFO8W
 n695DoURUGOH588SjwecKjJVtPYPY3th8Jl8xSzsMBrmKChc1uMvZ/7CxyMse7F0ijnB NQ== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3fg7vn9367-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 18 Apr 2022 17:09:58 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
	by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23IH2xqX002748;
	Mon, 18 Apr 2022 17:09:56 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
	by ppma02fra.de.ibm.com with ESMTP id 3fgu6u0vpq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 18 Apr 2022 17:09:56 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
	by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23IHA3Nw8520250
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Apr 2022 17:10:03 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7DDDC4C046;
	Mon, 18 Apr 2022 17:09:52 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8E4014C040;
	Mon, 18 Apr 2022 17:09:51 +0000 (GMT)
Received: from lep8c.aus.stglabs.ibm.com (unknown [9.40.192.207])
	by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Mon, 18 Apr 2022 17:09:51 +0000 (GMT)
Subject: [RFC ndctl PATCH 0/9] test: Enable PAPR test family by default
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: nvdimm@lists.linux.dev, dan.j.williams@intel.com, vishal.l.verma@intel.com
Cc: aneesh.kumar@linux.ibm.com, sbhat@linux.ibm.com, vaibhav@linux.ibm.com
Date: Mon, 18 Apr 2022 12:09:50 -0500
Message-ID: 
 <165030175745.3224737.6985015146263991065.stgit@lep8c.aus.stglabs.ibm.com>
User-Agent: StGit/1.1+40.g1b20
Content-Type: text/plain; charset="utf-8"
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: bquv_UGRz7-FB5k75POO6hY-c7HL2wBA
X-Proofpoint-GUID: bquv_UGRz7-FB5k75POO6hY-c7HL2wBA
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-18_02,2022-04-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 mlxscore=0
 phishscore=0 suspectscore=0 bulkscore=0 lowpriorityscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 mlxlogscore=878 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204180101

It is possible to have tests run over multiple test families if
the respective modules can be loaded/unloaded serially on a test to
test basis. The kernel patch [1] separated out the PAPR specific
ndtest module on its own as "ndtest.ko".

So with [1], we have two family specific modules(nfit_test & ndtest)
which can be loaded one after the other and have the test results
in one go without a need for kernel recompilation with different
kernel configs.

The series ensures all the known failures/unsupported/irrelevant tests
to be skipped on ndtest to avoid all "known" chances of false negatives.
This is achieved using a skip file containing the list of tests to be
skipped on the given platform. The PAPR specific tests to be skipped
are updated in the skip_PAPR.js file.

A meson config option(-Dtest-families=INTEL,PAPR default) is added.
One can just limit the tests to INTEL or PAPR alone if required.

An example run would look like,
===========================================
 1/72 ndctl:ndctl+INTEL / libndctl                       OK              2.79s
 2/72 ndctl:ndctl+INTEL / dsm-fail                       OK              0.70s
 3/72 ndctl:ndctl+INTEL / create.sh                      OK              0.80s
 4/72 ndctl:ndctl+INTEL / clear.sh                       OK             15.04s
 5/72 ndctl:ndctl+INTEL / pmem-errors.sh                 OK             14.97s
 6/72 ndctl:dax+INTEL / daxdev-errors.sh                 OK             12.33s
 7/72 ndctl:dax+INTEL / multi-dax.sh                     OK              0.67s
 8/72 ndctl:ndctl+INTEL / btt-check.sh                   OK             16.20s
 9/72 ndctl:ndctl+INTEL / label-compat.sh                OK              0.82s
10/72 ndctl:ndctl+INTEL / sector-mode.sh                 OK              1.01s
11/72 ndctl:ndctl+INTEL / inject-error.sh                OK             14.52s
12/72 ndctl:ndctl+INTEL / btt-errors.sh                  OK             24.01s
13/72 ndctl:ndctl+INTEL / hugetlb                        OK              0.09s
14/72 ndctl:ndctl+INTEL / btt-pad-compat.sh              OK              1.78s
15/72 ndctl:ndctl+INTEL / firmware-update.sh             FAIL           10.33s   exit status 1
>>> TEST_PATH=/home/sbhat/code/ndctl/build/test NDCTL_TEST_FAMILY=INTEL DAXCTL=/home/sbhat/code/ndctl/build/daxctl/daxctl NDCTL=/home/sbhat/code/ndctl/build/ndctl/ndctl MALLOC_PERTURB_=181 DATA_PATH=/home/sbhat/code/ndctl/test /home/sbhat
/code/ndctl/test/firmware-update.sh

16/72 ndctl:ndctl+INTEL / ack-shutdown-count-set         OK              0.26s
17/72 ndctl:ndctl+INTEL / rescan-partitions.sh           OK              7.84s
18/72 ndctl:ndctl+INTEL / inject-smart.sh                OK              1.89s
19/72 ndctl:ndctl+INTEL / monitor.sh                     OK             13.22s
20/72 ndctl:ndctl+INTEL / max_extent_ns                  OK              1.10s
21/72 ndctl:ndctl+INTEL / pfn-meta-errors.sh             OK             14.62s
22/72 ndctl:ndctl+INTEL / track-uuid.sh                  OK              0.78s
23/72 ndctl:ndctl+INTEL / pmem-ns                        FAIL            0.26s   (exit status 237 or signal 109 SIGinvalid)
>>> TEST_PATH=/home/sbhat/code/ndctl/build/test MALLOC_PERTURB_=140 NDCTL_TEST_FAMILY=INTEL DAXCTL=/home/sbhat/code/ndctl/build/daxctl/daxctl NDCTL=/home/sbhat/code/ndctl/build/ndctl/ndctl DATA_PATH=/home/sbhat/code/ndctl/test /home/sbhat
/code/ndctl/build/test/pmem-ns

24/72 ndctl:dax+INTEL / sub-section.sh                   SKIP            0.15s   exit status 77
25/72 ndctl:dax+INTEL / dax-dev                          SKIP            0.03s   exit status 77
26/72 ndctl:dax+INTEL / dax-ext4.sh                      SKIP            0.05s   exit status 77
27/72 ndctl:dax+INTEL / dax-xfs.sh                       SKIP            0.05s   exit status 77
28/72 ndctl:ndctl+INTEL / align.sh                       SKIP            0.09s   exit status 77
29/72 ndctl:dax+INTEL / device-dax                       SKIP            0.04s   exit status 77
30/72 ndctl:dax+INTEL / revoke-devmem                    OK              0.03s
31/72 ndctl:dax+INTEL / device-dax-fio.sh                SKIP            0.06s   exit status 77
32/72 ndctl:dax+INTEL / daxctl-devices.sh                SKIP            0.07s   exit status 77
33/72 ndctl:dax+INTEL / daxctl-create.sh                 SKIP            0.02s   exit status 77
34/72 ndctl:dax+INTEL / dm.sh                            FAIL            0.12s   exit status 1
>>> TEST_PATH=/home/sbhat/code/ndctl/build/test NDCTL_TEST_FAMILY=INTEL DAXCTL=/home/sbhat/code/ndctl/build/daxctl/daxctl NDCTL=/home/sbhat/code/ndctl/build/ndctl/ndctl MALLOC_PERTURB_=115 DATA_PATH=/home/sbhat/code/ndctl/test /home/sbhat
/code/ndctl/test/dm.sh
35/72 ndctl:dax+INTEL / mmap.sh                          SKIP            0.05s   exit status 77
36/72 ndctl:ndctl+INTEL / security.sh                    SKIP            0.38s   exit status 77
37/72 ndctl:ndctl+PAPR / libndctl                        OK              2.63s
38/72 ndctl:ndctl+PAPR / dsm-fail                        OK              1.41s
39/72 ndctl:ndctl+PAPR / create.sh                       OK              1.06s
40/72 ndctl:ndctl+PAPR / clear.sh                        SKIP            0.12s   exit status 77
41/72 ndctl:ndctl+PAPR / pmem-errors.sh                  SKIP            0.16s   exit status 77
42/72 ndctl:dax+PAPR / daxdev-errors.sh                  SKIP            0.08s   exit status 77
43/72 ndctl:dax+PAPR / multi-dax.sh                      OK              1.03s
44/72 ndctl:ndctl+PAPR / btt-check.sh                    OK             17.13s
45/72 ndctl:ndctl+PAPR / label-compat.sh                 SKIP            0.26s   exit status 77
46/72 ndctl:ndctl+PAPR / sector-mode.sh                  OK              1.26s
47/72 ndctl:ndctl+PAPR / inject-error.sh                 SKIP            0.20s   exit status 77
48/72 ndctl:ndctl+PAPR / btt-errors.sh                   SKIP            1.42s   exit status 77
49/72 ndctl:ndctl+PAPR / hugetlb                         OK              0.16s
50/72 ndctl:ndctl+PAPR / btt-pad-compat.sh               OK              3.06s
51/72 ndctl:ndctl+PAPR / firmware-update.sh              SKIP            0.90s   exit status 77
52/72 ndctl:ndctl+PAPR / ack-shutdown-count-set          SKIP            0.09s   exit status 77
53/72 ndctl:ndctl+PAPR / rescan-partitions.sh            OK              8.11s
54/72 ndctl:ndctl+PAPR / inject-smart.sh                 OK              1.37s
55/72 ndctl:ndctl+PAPR / monitor.sh                      OK              7.63s
56/72 ndctl:ndctl+PAPR / max_extent_ns                   OK              1.41s
57/72 ndctl:ndctl+PAPR / pfn-meta-errors.sh              SKIP            0.14s   exit status 77
58/72 ndctl:ndctl+PAPR / track-uuid.sh                   OK              1.07s
59/72 ndctl:ndctl+PAPR / pmem-ns                         OK              0.54s
60/72 ndctl:dax+PAPR / sub-section.sh                    SKIP            0.27s   exit status 77
61/72 ndctl:dax+PAPR / dax-dev                           SKIP            0.04s   exit status 77
62/72 ndctl:dax+PAPR / dax-ext4.sh                       SKIP            0.35s   exit status 77
63/72 ndctl:dax+PAPR / dax-xfs.sh                        SKIP            0.39s   exit status 77
64/72 ndctl:ndctl+PAPR / align.sh                        SKIP            0.46s   exit status 77
65/72 ndctl:dax+PAPR / device-dax                        SKIP            0.04s   exit status 77
66/72 ndctl:dax+PAPR / revoke-devmem                     OK              0.04s
67/72 ndctl:dax+PAPR / device-dax-fio.sh                 SKIP            0.32s   exit status 77
68/72 ndctl:dax+PAPR / daxctl-devices.sh                 SKIP            0.40s   exit status 77
69/72 ndctl:dax+PAPR / daxctl-create.sh                  SKIP            0.48s   exit status 77
70/72 ndctl:dax+PAPR / dm.sh                             SKIP            0.48s   exit status 77
71/72 ndctl:dax+PAPR / mmap.sh                           SKIP            0.50s   exit status 77
72/72 ndctl:ndctl+PAPR / security.sh                     SKIP            0.22s   exit status 77


Ok:                 37
Expected Fail:      0
Fail:               3 # Not from PAPR family
Unexpected Pass:    0
Skipped:            32
Timeout:            0
===========================================
Note the meson suite string here "ndctl+INTEL|PAPR" indicating the
test family.

The first 6 patches in the series move the code with little/no change
to current behaviour in isolation while fixing existing bugs in
preparation for running the tests for INTEL and PAPR families one
after the other. The last 3 patches fix the known failures on ndtest
and they depend on the kernel patch [2]. These 3 patches are repost of
previously posted patches with rebase. The last patches are included
here in this series for completeness.

The patches are posted on github repos below
Kernel - https://github.com/shivaprasadbhat/linux/tree/ndtest-runall
ndctl  - https://github.com/shivaprasadbhat/ndctl/tree/ndctl-test-all

References:
[1] - https://patchwork.kernel.org/project/linux-nvdimm/patch/165025849452.2974989.6131145460098517848.stgit@lep8c.aus.stglabs.ibm.com/
[2] - https://patchwork.kernel.org/project/linux-nvdimm/patch/165027233876.3035289.4353747702027907365.stgit@lep8c.aus.stglabs.ibm.com/

---

Shivaprasad G Bhat (9):
      test/common: Ensure to unload test modules
      test: core: Fix module unload failures
      test: Unload the nfit module during cleanup
      test: Introduce skip file to skip irrelevant tests
      test: Assign provider name based on the test family
      test: Enable PAPR test family tests after INTEL family tests
      test/libndctl: Enable libndctl tests on ndtest
      test/inject-smart: Enable inject-smart tests on ndtest
      test/monitor.sh: Partially skip monitor test on ndtest

 meson.build                     |  10 +++
 meson_options.txt               |   2 +
 ndctl/bat.c                     |   4 +-
 ndctl/test.c                    |   4 +-
 test.h                          |  10 ++-
 test/ack-shutdown-count-set.c   |  17 ++--
 test/btt-check.sh               |   3 +-
 test/btt-errors.sh              |   3 +-
 test/btt-pad-compat.sh          |   3 +-
 test/clear.sh                   |   4 +-
 test/common                     |  57 ++++++++++++-
 test/core.c                     | 140 +++++++++++++++++++++++++++++++-
 test/create.sh                  |   4 +-
 test/dax-dev.c                  |   2 +-
 test/dax-pmd.c                  |   2 +-
 test/daxdev-errors.sh           |   6 +-
 test/device-dax.c               |   2 +-
 test/dsm-fail.c                 |  33 +++++---
 test/firmware-update.sh         |   3 +-
 test/inject-error.sh            |   3 +-
 test/inject-smart.sh            |  17 ++--
 test/label-compat.sh            |   4 +-
 test/libndctl.c                 |  60 ++++++++++++--
 test/list-smart-dimm.c          |  33 +++++++-
 test/max_available_extent_ns.sh |   3 +-
 test/meson.build                |  59 ++++++++------
 test/monitor.sh                 |  14 +++-
 test/multi-dax.sh               |   4 +-
 test/pfn-meta-errors.sh         |   3 +-
 test/pmem-errors.sh             |   3 +-
 test/pmem_namespaces.c          |  29 +++----
 test/rescan-partitions.sh       |   3 +-
 test/revoke-devmem.c            |   2 +-
 test/sector-mode.sh             |   4 +-
 test/security.sh                |   3 +-
 test/skip_PAPR.js               |  32 ++++++++
 test/track-uuid.sh              |   3 +-
 37 files changed, 447 insertions(+), 141 deletions(-)
 create mode 100644 test/skip_PAPR.js

--

