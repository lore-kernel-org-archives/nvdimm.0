Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E437F
	for <nvdimm@lists.linux.dev>; Mon,  2 May 2022 07:06:20 +0000 (UTC)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2426mcf7021386;
	Mon, 2 May 2022 07:06:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=e9YfE7/Qr/pwsbNfg6MLtIszClbNX9utfANnrXiLPEk=;
 b=p+KEYnSLTEWfEzYXY1OWcYwNiH+F6hiAJsJhqKGb++jOxAmxI0SfR7oiIcht+xvZ3A0D
 So5VDKbUNmc6UzqVU6WH2AWfcB2Al8me0V3ASer18kehR9ZjXQt+1fWeLWMAAd/DtCYB
 UC+KlxoHoKdS4/BkyCfrSofD8uqJl0gVtVwVgB+FP6H226KOPygsIbqqjwY834hi5+MR
 OA+cL7vhst+AL+8TdIq3rK5DAGlXLVjZssgsQRL+lL7CngCvieIcPrsk4B38sPwdUERd
 +0kRss99jxo/pCoR3ONar5hmNJBLLYo0kOFhxbdZyJLoG/+jZ1j9eCvRZhYxyrLt08to hQ== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
	by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3fsf66vbdh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 May 2022 07:06:11 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
	by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 242739DP021400;
	Mon, 2 May 2022 07:06:09 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
	by ppma04ams.nl.ibm.com with ESMTP id 3frvr8t9e8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 May 2022 07:06:09 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
	by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 242766H746268740
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 2 May 2022 07:06:06 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 386F8A4064;
	Mon,  2 May 2022 07:06:06 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 380A0A4054;
	Mon,  2 May 2022 07:06:01 +0000 (GMT)
Received: from li-efb8054c-3504-11b2-a85c-ca10df28279e.ibm.com.com (unknown [9.43.15.16])
	by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Mon,  2 May 2022 07:05:59 +0000 (GMT)
From: Tarun Sahu <tsahu@linux.ibm.com>
To: nvdimm@lists.linux.dev
Cc: tsahu@linux.ibm.com, dan.j.williams@intel.com, vishal.l.verma@intel.com,
        aneesh.kumar@linux.ibm.com, sbhat@linux.ibm.com, vaibhav@linux.ibm.com
Subject: [PATCH v2] ndctl/bus:Handling the scrub related command more gracefully
Date: Mon,  2 May 2022 12:34:54 +0530
Message-Id: <20220502070454.179153-1-tsahu@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: gVqvqRWttXoUIK1G64jYSHHASjncDZZC
X-Proofpoint-ORIG-GUID: gVqvqRWttXoUIK1G64jYSHHASjncDZZC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-02_02,2022-04-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 clxscore=1015 impostorscore=0 spamscore=0 mlxlogscore=999
 mlxscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205020054

The buses, that don't have nfit support, return "No such file or
directory" for start-scrub/wait-scrub command.

Presently, non-nfit support buses do not support start-scrub/
wait-scrub operation. This patch is to handle these commands
more gracefully by returning" Operation not supported".

This patch is tested on PPC64le lpar with nvdimm that does
not support scrub.

Previously:
$ ./ndctl start-scrub ndbus0
error starting scrub: No such file or directory

Now:
$ ./ndctl start-scrub ndbus0
error starting scrub: Operation not supported

- Invalid ndbus
$ sudo ./ndctl start-scrub ndbus5
error starting scrub: No such device or address

Signed-off-by: Tarun Sahu <tsahu@linux.ibm.com>
Reviewed-by: Vaibhav Jain <vaibhav@linux.ibm.com>
Tested-by: Vaibhav Jain <vaibhav@linux.ibm.com>
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

