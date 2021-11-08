Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A9568
	for <nvdimm@lists.linux.dev>; Mon,  8 Nov 2021 14:28:11 +0000 (UTC)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A8C3T6k005635;
	Mon, 8 Nov 2021 14:28:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pp1; bh=lSTa2yRhzii05ncjt0sV0AR36jEu79ZhkD9l63lzGWg=;
 b=mj4SPgj13UsM4pJ+SgMR/XPf+Y4+RWIu7QgaNL+RVLQyLuO88YnXEW4vuXuwCzDALy6A
 QVul3L5ZAbOuGXcpa7b5sJAwio0fawd0B2xFeqmERu3iGfjE+lK7oBqXhV8j0R1JSStZ
 O7gkKQmfUbufI3vAzNIgthD077SwFLgJIbn9Z/sk+sw0vGCnZY6LjtuNQkbqk/hweXC3
 PbTkeGNyNJlaIAYLGIu5vBHydihiYT3sShQwpIrK2tiSCllZpXHrbjZN7F1YSaNKCmrw
 LNrWnw46jTVAt9E+iYSZSLMj2rhSX9CwlWnruzwDFe590TpOJ+RbpjOgerDbflMdo22H /A== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3c6858852x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 08 Nov 2021 14:28:04 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
	by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1A8ENkLZ020048;
	Mon, 8 Nov 2021 14:28:01 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
	by ppma03ams.nl.ibm.com with ESMTP id 3c5hb9y3da-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 08 Nov 2021 14:28:01 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
	by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1A8ERwCJ1966760
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 8 Nov 2021 14:27:58 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 77005A4064;
	Mon,  8 Nov 2021 14:27:58 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 74133A4062;
	Mon,  8 Nov 2021 14:27:57 +0000 (GMT)
Received: from lep8c.aus.stglabs.ibm.com (unknown [9.40.192.207])
	by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Mon,  8 Nov 2021 14:27:57 +0000 (GMT)
Subject: [PATCH v3 0/2] papr: Implement initial support for injecting smart
 errors
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: nvdimm@lists.linux.dev
Cc: aneesh.kumar@linux.ibm.com, sbhat@linux.ibm.com, vaibhav@linux.ibm.com,
        dan.j.williams@intel.com, ira.weiny@intel.com,
        vishal.l.verma@intel.com
Date: Mon, 08 Nov 2021 08:27:56 -0600
Message-ID: 
 <163638167629.400685.8268507373653839032.stgit@lep8c.aus.stglabs.ibm.com>
User-Agent: StGit/1.1+40.g1b20
Content-Type: text/plain; charset="utf-8"
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: UR0a0TwN1AV0jlu1IvHzm_PaopQMD8r1
X-Proofpoint-GUID: UR0a0TwN1AV0jlu1IvHzm_PaopQMD8r1
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-08_05,2021-11-08_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 bulkscore=0 phishscore=0 impostorscore=0 clxscore=1015
 adultscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111080087

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


