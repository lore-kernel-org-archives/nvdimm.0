Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0CD72
	for <nvdimm@lists.linux.dev>; Mon, 17 May 2021 15:48:43 +0000 (UTC)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14HFXWo6141715;
	Mon, 17 May 2021 11:48:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=yVqtnu7wKs0805mmyAQgAIbU3CZFKrC48wzioRW8sTQ=;
 b=dXZsAs30C5PK6204HrtBpcXE/0JU9RB3bq34IemddRz+Tehy1rj2onXvYgf0b99DFqqE
 1jWNvITgP1MLgle/z1pOvRrj9gnFDm/4WoBlz25SOI9VMZseZ03k5YiskuvhVTWx1ykL
 FFSN50ADKPkuUHbzoDZEcOPpNLyQX7bKnXZnDaqtlysJaJ1qClO6BcYuaPfS3U/mX71K
 bQefwJym2Rf6IbYgJ4D5YJL79Cq3ui/7/CLQVcMcKduwC7hxAN5qWbVGtI7cMkHCX0pz
 ZDh5WMSA35VlHxPFOHsaOGYYztoFwXd1XV7S2THAmyo28xLPyCvkASLTiMEjRzpuka1S 9w== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
	by mx0b-001b2d01.pphosted.com with ESMTP id 38ks6n55td-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 May 2021 11:48:36 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
	by ppma05fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14HFl650031449;
	Mon, 17 May 2021 15:48:34 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
	by ppma05fra.de.ibm.com with ESMTP id 38j5x8gh4d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 May 2021 15:48:34 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
	by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14HFm4bc22151534
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 May 2021 15:48:04 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9A61E52051;
	Mon, 17 May 2021 15:48:31 +0000 (GMT)
Received: from vajain21.in.ibm.com (unknown [9.79.218.122])
	by d06av21.portsmouth.uk.ibm.com (Postfix) with SMTP id D63D95204F;
	Mon, 17 May 2021 15:48:28 +0000 (GMT)
Received: by vajain21.in.ibm.com (sSMTP sendmail emulation); Mon, 17 May 2021 21:18:27 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: linux-nvdimm@lists.01.org, nvdimm@lists.linux.dev
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Ira Weiny <ira.weiny@intel.com>, Santosh Sivaraj <santosh@fossix.org>
Subject: [ndctl PATCH] libndctl/papr: Fix probe for papr-scm compatible nvdimms
Date: Mon, 17 May 2021 21:18:24 +0530
Message-Id: <20210517154824.142237-1-vaibhav@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _ec60BWsjYQdJxQ2RuG9udN6T5dyCZXw
X-Proofpoint-ORIG-GUID: _ec60BWsjYQdJxQ2RuG9udN6T5dyCZXw
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-17_06:2021-05-17,2021-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 phishscore=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 malwarescore=0
 impostorscore=0 mlxlogscore=999 clxscore=1011 priorityscore=1501
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105170108

With recent changes introduced for unification of PAPR and NFIT
families the probe for papr-scm nvdimms is broken since they don't
expose 'handle' or 'phys_id' sysfs attributes. These attributes are
only exposed by NFIT and 'nvdimm_test' nvdimms. Since 'unable to read'
these sysfs attributes is a non-recoverable error hence this prevents
probing of 'PAPR-SCM' nvdimms and ndctl reports following error:

$ sudo NDCTL_LOG=debug ndctl list -DH
libndctl: ndctl_new: ctx 0x10015342c70 created
libndctl: add_dimm: nmem1: probe failed: Operation not permitted
libndctl: __sysfs_device_parse: nmem1: add_dev() failed
libndctl: add_dimm: nmem0: probe failed: Operation not permitted
libndctl: __sysfs_device_parse: nmem0: add_dev() failed

Fixing this bug is complicated by the fact these attributes are needed
for by the 'nvdimm_test' nvdimms which also uses the
NVDIMM_FAMILY_PAPR. Adding a two way comparison for these two
attributes in populate_dimm_attributes() to distinguish between
'nvdimm_test' and papr-scm nvdimms will be clunky and make future
updates to populate_dimm_attributes() error prone.

So, this patch proposes to fix the issue by re-introducing
add_papr_dimm() to probe both papr-scm and 'nvdimm_test' nvdimms. The
'compatible' sysfs attribute associated with the PAPR device is used
to distinguish between the two nvdimm types and in case an
'nvdimm_test' device is detected then forward its probe to
populate_dimm_attributes().

Fixes: daef3a386a9c("libndctl: Unify adding dimms for papr and nfit
families")
Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
---
 ndctl/lib/libndctl.c | 57 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 55 insertions(+), 2 deletions(-)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index bf0968cce93f..0417720ccd7e 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -1757,6 +1757,58 @@ static int populate_dimm_attributes(struct ndctl_dimm *dimm,
 	return rc;
 }
 
+static int add_papr_dimm(struct ndctl_dimm *dimm, const char *dimm_base)
+{
+	int rc = -ENODEV;
+	char buf[SYSFS_ATTR_SIZE];
+	struct ndctl_ctx *ctx = dimm->bus->ctx;
+	char *path = calloc(1, strlen(dimm_base) + 100);
+	const char * const devname = ndctl_dimm_get_devname(dimm);
+
+	dbg(ctx, "%s: Probing of_pmem dimm at %s\n", devname, dimm_base);
+
+	if (!path)
+		return -ENOMEM;
+
+	/* Check the compatibility of the probed nvdimm */
+	sprintf(path, "%s/../of_node/compatible", dimm_base);
+	if (sysfs_read_attr(ctx, path, buf) < 0) {
+		dbg(ctx, "%s: Unable to read compatible field\n", devname);
+		rc =  -ENODEV;
+		goto out;
+	}
+
+	dbg(ctx, "%s:Compatible of_pmem = '%s'\n", devname, buf);
+
+	/* Probe for papr-scm memory */
+	if (strcmp(buf, "ibm,pmemory") == 0) {
+		/* Read the dimm flags file */
+		sprintf(path, "%s/papr/flags", dimm_base);
+		if (sysfs_read_attr(ctx, path, buf) < 0) {
+			rc = -errno;
+			err(ctx, "%s: Unable to read dimm-flags\n", devname);
+			goto out;
+		}
+
+		dbg(ctx, "%s: Adding papr-scm dimm flags:\"%s\"\n", devname, buf);
+		dimm->cmd_family = NVDIMM_FAMILY_PAPR;
+
+		/* Parse dimm flags */
+		parse_papr_flags(dimm, buf);
+
+		/* Allocate monitor mode fd */
+		dimm->health_eventfd = open(path, O_RDONLY|O_CLOEXEC);
+		rc = 0;
+
+	} else if (strcmp(buf, "nvdimm_test") == 0) {
+		/* probe via common populate_dimm_attributes() */
+		rc = populate_dimm_attributes(dimm, dimm_base, "papr");
+	}
+out:
+	free(path);
+	return rc;
+}
+
 static void *add_dimm(void *parent, int id, const char *dimm_base)
 {
 	int formats, i, rc = -ENODEV;
@@ -1848,8 +1900,9 @@ static void *add_dimm(void *parent, int id, const char *dimm_base)
 	/* Check if the given dimm supports nfit */
 	if (ndctl_bus_has_nfit(bus)) {
 		rc = populate_dimm_attributes(dimm, dimm_base, "nfit");
-	} else if (ndctl_bus_has_of_node(bus))
-		rc = populate_dimm_attributes(dimm, dimm_base, "papr");
+	} else if (ndctl_bus_has_of_node(bus)) {
+		rc = add_papr_dimm(dimm, dimm_base);
+	}
 
 	if (rc == -ENODEV) {
 		/* Unprobed dimm with no family */
-- 
2.31.1

