Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB0B7B
	for <nvdimm@lists.linux.dev>; Wed, 27 Apr 2022 15:38:05 +0000 (UTC)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23RFCtmu012356;
	Wed, 27 Apr 2022 15:38:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=LhQYoSSIMl3yYqHJj5IZUIzcLJVezjRnOeRdRA2nOYI=;
 b=qvKpeoSFLFZK5v6cZo9plMW8S7KgpHLTeXOESI1wgXkzbcK+ALMNuh6xxoNymc+kbSqa
 Ml2QvbRmX9V80/6wMBjv3GEDWu5ikOzO+t/y7o7tNsUcm81GbDUxXItBgPVSKA/W9gv6
 dvx9DvCI/fjh9nhPJWR6GyXqC0rLYBVDYHLyJsOd23IXRkoMZRsVCpAhTYqkjmIvV2mJ
 /wX80QqcShqHzJXEEXLfT//ycM4BmeLcyRyR7Z6JPTibM4BOsMSSroe/ncynF4fF6GAL
 AX+qK411KBIySdTQa5W88976OzNaXlIOzemI3aR2Wy+BoiQP9aLbDKEadEGygWktTUmZ Jg== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fptwjqxbs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 27 Apr 2022 15:38:02 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
	by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23RFSh2S008035;
	Wed, 27 Apr 2022 15:38:01 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
	by ppma03ams.nl.ibm.com with ESMTP id 3fm938x7e7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 27 Apr 2022 15:38:01 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
	by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23RFbw7I48300542
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Apr 2022 15:37:58 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 037DF5204E;
	Wed, 27 Apr 2022 15:37:58 +0000 (GMT)
Received: from li-efb8054c-3504-11b2-a85c-ca10df28279e.ibm.com.com (unknown [9.43.5.136])
	by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 234795204F;
	Wed, 27 Apr 2022 15:37:54 +0000 (GMT)
From: Tarun Sahu <tsahu@linux.ibm.com>
To: nvdimm@lists.linux.dev
Cc: tsahu@linux.ibm.com, dan.j.williams@intel.com, vishal.l.verma@intel.com,
        aneesh.kumar@linux.ibm.com, sbhat@linux.ibm.com, vaibhav@linux.ibm.com
Subject: [PATCH] ndctl/bus:Handling the scrub related command more gracefully
Date: Wed, 27 Apr 2022 21:07:51 +0530
Message-Id: <20220427153751.190286-1-tsahu@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 2z-b93oEg9rLvyrJY2tbvXx4OSnNVWGd
X-Proofpoint-GUID: 2z-b93oEg9rLvyrJY2tbvXx4OSnNVWGd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-27_04,2022-04-27_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1015 impostorscore=0
 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2204270098

For the buses, that don't have nfit support, they use to
return "No such file or directory" for start-scrub/
wait-scrub command.

Though, non-nfit support buses do not support start-scrub/
wait-scrub operation. I propose this patch to handle these
commands more gracefully by returning "Operation not
supported".

Previously:
$ ./ndctl start-scrub ndbus0
error starting scrub: No such file or directory

Now:
$ ./ndctl start-scrub ndbus0
error starting scrub: Operation not supported

Signed-off-by: Tarun Sahu <tsahu@linux.ibm.com>
---
 ndctl/lib/libndctl.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index ccca8b5..8bfad6a 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -938,10 +938,14 @@ static void *add_bus(void *parent, int id, const char *ctl_base)
 	if (!bus->wait_probe_path)
 		goto err_read;
 
-	sprintf(path, "%s/device/nfit/scrub", ctl_base);
-	bus->scrub_path = strdup(path);
-	if (!bus->scrub_path)
-		goto err_read;
+	if (ndctl_bus_has_nfit(bus)) {
+		sprintf(path, "%s/device/nfit/scrub", ctl_base);
+		bus->scrub_path = strdup(path);
+		if (!bus->scrub_path)
+			goto err_read;
+	} else {
+		bus->scrub_path = NULL;
+	}
 
 	sprintf(path, "%s/device/firmware/activate", ctl_base);
 	if (sysfs_read_attr(ctx, path, buf) < 0)
@@ -1377,6 +1381,9 @@ NDCTL_EXPORT int ndctl_bus_start_scrub(struct ndctl_bus *bus)
 	struct ndctl_ctx *ctx = ndctl_bus_get_ctx(bus);
 	int rc;
 
+	if (bus->scrub_path == NULL)
+		return -EOPNOTSUPP;
+
 	rc = sysfs_write_attr(ctx, bus->scrub_path, "1\n");
 
 	/*
@@ -1447,6 +1454,9 @@ NDCTL_EXPORT int ndctl_bus_poll_scrub_completion(struct ndctl_bus *bus,
 	char in_progress;
 	int fd = 0, rc;
 
+	if (bus->scrub_path == NULL)
+		return -EOPNOTSUPP;
+
 	fd = open(bus->scrub_path, O_RDONLY|O_CLOEXEC);
 	if (fd < 0)
 		return -errno;
-- 
2.35.1

