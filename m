Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38CB7259B
	for <nvdimm@lists.linux.dev>; Mon, 25 Apr 2022 19:13:49 +0000 (UTC)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23PHsswA013182;
	Mon, 25 Apr 2022 19:13:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=i+qmVCLhzZwXxQ5R7RoUVkhd0nTazNWR6sDZMyDQ2y0=;
 b=JF+zirTdp3q5zwlT6HmPAGfll7hDmiIzDKzGJ1ktBmAu6ZBTNMSFRVLYeBRv+Wgo1IjL
 EHEs+Bjwrg3kwTyB5tNVcRWlL3kuZ6ILEM7+Ppveg2QEZy7t0f2t6FMqOzDQVlGofHcz
 KO1/Qe/oNEyYb7KsmRYncjhFvufCjnOEeofdCzBTEYWY7DVAUC0XtfNV4FtiK+NWsY6R
 zdGahgyi7bGLFOSj6GObNYUy+Mt6IJyu65SksWGShGwcz/u3tcKcidHnGbT+vmgJqvHp
 0Gk2t4C95htwfJF13uZYbf7Ltt2AlXGYU7bKjen3J2uI11AxhVDHWhvQlEBdnLOfv+Rv +w== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
	by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3fns00waf5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Apr 2022 19:13:45 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
	by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23PJASEd029939;
	Mon, 25 Apr 2022 19:13:44 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
	by ppma03fra.de.ibm.com with ESMTP id 3fm938taep-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Apr 2022 19:13:44 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
	by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23PJDeaM30998850
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Apr 2022 19:13:40 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ACC035204F;
	Mon, 25 Apr 2022 19:13:40 +0000 (GMT)
Received: from li-efb8054c-3504-11b2-a85c-ca10df28279e.ibm.com.com (unknown [9.43.7.86])
	by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id B11EF5204E;
	Mon, 25 Apr 2022 19:13:37 +0000 (GMT)
From: Tarun Sahu <tsahu@linux.ibm.com>
To: nvdimm@lists.linux.dev
Cc: tsahu@linux.ibm.com, dan.j.williams@intel.com, vishal.l.verma@intel.com,
        aneesh.kumar@linux.ibm.com, sbhat@linux.ibm.com, vaibhav@linux.ibm.com
Subject: [PATCH v2 0/2] ndctl/namespace:Fix and improve write-infoblock
Date: Tue, 26 Apr 2022 00:43:27 +0530
Message-Id: <20220425191329.59213-1-tsahu@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: s476xHn13dXBWosZJrPkNGwdtxDW4Opf
X-Proofpoint-ORIG-GUID: s476xHn13dXBWosZJrPkNGwdtxDW4Opf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-25_10,2022-04-25_03,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=556 adultscore=0 suspectscore=0 clxscore=1015 impostorscore=0
 spamscore=0 mlxscore=0 bulkscore=0 phishscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204250085

This series resolves some issues with write-infoblock command and provide support to write-infoblock for sector mode namespace

write-infoblock command has issues regarding updating the align, uuid, parent_uuid. In case of no parameter passed for it, this command used to overwrite the existing values with defaults.

In PATCH 1/2 these parameters will be set to their original values, incase, values hasn't been passed in command arguments

write-infoblock command doesn't have support for sector/BTT mode namespaces. They can be converted to fsdax, but can not be written being in sector mode.

In PATCH 2/2, It creates a functionality which write infoblock of Sector/BTT namespace. Currently only uuid, parent_uuid can be updated. In future, Support for other parameters can easily be integrated in the
functionality.

---
v2:
  Updated the commit message (rephrasing) in patch 1/2
  Moved the ns_info struct to namespace.c from namespace.h
  put the results after --- to avoid long commit message
  
Tarun-Sahu (2):
  ndctl/namespace:Fix multiple issues with write-infoblock
  ndctl/namespace:Implement write-infoblock for sector mode namespaces

 ndctl/namespace.c | 307 +++++++++++++++++++++++++++++++++-------------
 1 file changed, 224 insertions(+), 83 deletions(-)

-- 
2.35.1

