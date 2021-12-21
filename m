Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58DF2C82
	for <nvdimm@lists.linux.dev>; Tue, 21 Dec 2021 14:40:15 +0000 (UTC)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BLETZrQ014834;
	Tue, 21 Dec 2021 14:40:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pp1; bh=AB0fqcNQRxq46wjYMBbBuQEJl1oJPOy5doQkI5bfeR4=;
 b=rpWyeWp+w1X82YD9hnjB4oXlMf/daKQRyiwfh6jx4sq536+FEsis0ypKZ6VR/UyiejDw
 PcesMftXWu2omZdA0WbpfUq8WS0bKq/2BGQOSOb2mfLUn5h7aHE5Ztgsp2fWgRY832zH
 1lmsKxSm/bxg5mR+dgbdRiGy63pupjDinH7P1MAsZETdtquW6B4kMAEgw8WnBPVi78Br
 rkc1ZHQDzJniDmZ8w7y8Z5pLLTmRsZsuP98paf+xgG8vqbQOBmuCMF96/iXTbuMSEQO+
 BMk1eT73M65us5vmKoNmbY0NcJPgnBpg/Twos2cktY+7Hpc3iQ2TvcljKRC/aBIci9aM OA== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
	by mx0b-001b2d01.pphosted.com with ESMTP id 3d3gr307sh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Dec 2021 14:40:07 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
	by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BLEcVEn032156;
	Tue, 21 Dec 2021 14:40:04 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
	by ppma05fra.de.ibm.com with ESMTP id 3d1799ddx1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Dec 2021 14:40:04 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
	by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BLEe1UG44302604
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Dec 2021 14:40:01 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EA2D652054;
	Tue, 21 Dec 2021 14:40:00 +0000 (GMT)
Received: from lep8c.aus.stglabs.ibm.com (unknown [9.40.192.207])
	by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id EC97B52050;
	Tue, 21 Dec 2021 14:39:59 +0000 (GMT)
Subject: [ndctl REPOST PATCH v3 0/2] papr: Implement initial support for
 injecting smart errors
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: nvdimm@lists.linux.dev
Cc: aneesh.kumar@linux.ibm.com, sbhat@linux.ibm.com, vaibhav@linux.ibm.com,
        dan.j.williams@intel.com, ira.weiny@intel.com,
        vishal.l.verma@intel.com
Date: Tue, 21 Dec 2021 08:39:59 -0600
Message-ID: 
 <164009759905.743207.9222152578609029206.stgit@lep8c.aus.stglabs.ibm.com>
User-Agent: StGit/1.1+40.g1b20
Content-Type: text/plain; charset="utf-8"
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: KRhpwQtvSxFO80GnBUiHzQaT0MULi4lK
X-Proofpoint-ORIG-GUID: KRhpwQtvSxFO80GnBUiHzQaT0MULi4lK
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-21_04,2021-12-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 spamscore=0 phishscore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 clxscore=1011
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112210068

From: Vaibhav Jain <vaibhav@linux.ibm.com>

Changes since v2:
Link: https://lore.kernel.org/nvdimm/163102311841.258999.14260383111577082134.stgit@99912bbcb4c7/
* Removed redundant comments as suggested by Ira.
* Added the Reviewed-by: Ira tag

Changes since v1:
Link: https://patchwork.kernel.org/project/linux-nvdimm/cover/20210712173132.1205192-1-vaibhav@linux.ibm.com/
* Minor update to patch description
* The changes are based on the new kernel patch [1]

The patch series implements limited support for injecting smart errors for PAPR
NVDIMMs via ndctl-inject-smart(1) command. SMART errors are emulating in
papr_scm module as presently PAPR doesn't support injecting smart errors on an
NVDIMM. Currently support for injecting 'fatal' health state and 'dirty'
shutdown state is implemented. With the proposed ndctl patched and with
corresponding kernel patch [1] following command flow is expected:

$ sudo ndctl list -DH -d nmem0
...
      "health_state":"ok",
      "shutdown_state":"clean",
...
 # inject unsafe shutdown and fatal health error
$ sudo ndctl inject-smart nmem0 -Uf
...
      "health_state":"fatal",
      "shutdown_state":"dirty",
...
 # uninject all errors
$ sudo ndctl inject-smart nmem0 -N
...
      "health_state":"ok",
      "shutdown_state":"clean",
...

The corresponding kernel patch [1] is being reviewed and not merged to the tree.

Structure of the patch series
=============================

* First patch updates 'inject-smart' code to not always assume support for
  injecting all smart-errors. It also updates 'intel.c' to explicitly indicate
  the type of smart-inject errors supported.

* Update 'papr.c' to add support for injecting smart 'fatal' health and
  'dirty-shutdown' errors.

[1] : https://patchwork.kernel.org/project/linux-nvdimm/patch/163091917031.334.16212158243308361834.stgit@82313cf9f602/
---

Vaibhav Jain (2):
      libndctl, intel: Indicate supported smart-inject types
      libndctl/papr: Add limited support for inject-smart


 ndctl/inject-smart.c  | 33 ++++++++++++++++++-----
 ndctl/lib/intel.c     |  7 ++++-
 ndctl/lib/papr.c      | 61 +++++++++++++++++++++++++++++++++++++++++++
 ndctl/lib/papr_pdsm.h | 17 ++++++++++++
 ndctl/libndctl.h      |  8 ++++++
 5 files changed, 118 insertions(+), 8 deletions(-)

--
Signature


