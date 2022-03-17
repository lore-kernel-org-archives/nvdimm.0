Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A90CF3D79
	for <nvdimm@lists.linux.dev>; Thu, 17 Mar 2022 09:32:54 +0000 (UTC)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22H67vPb022742
	for <nvdimm@lists.linux.dev>; Thu, 17 Mar 2022 09:32:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to :
 date : message-id : mime-version : content-type :
 content-transfer-encoding; s=pp1;
 bh=38WIjNblhQEZgp13ZnPpBD6QNjQZQCBeu2jYZTfCrbI=;
 b=LFD34ZTH/b+T0WYNSRyTEriFeJg7c9f26qMWciHNHdZYPe5nKDGCduesz0FUuKsWCI9Y
 JDflYn7AYMZYDTU5ldDHkuuBHNKERt0IgSwhtIHsZNpPv+xIW51/0+6bXlZAIcjKsTWY
 lYhV+okElHzNP2CKtornQAxY5XTVv7EaZPhdp5okqpES3h7K5fJAWmgrUZRJjXKkZw8k
 HTGrl2cbErH7xow4D3XSJpBe9gqXPZMPk+djqJwfhZvfTOf8/bKxy+Ef/bZNUE6WccJm
 i/reF5BfcVhoZ39SEjM5T6dZhMZRjZyqxPGbtWuOtt/0JIgKCq0aT875aT3vwZVksgH/ jg== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3euv2y6na8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <nvdimm@lists.linux.dev>; Thu, 17 Mar 2022 09:32:48 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
	by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22H9Deic016475
	for <nvdimm@lists.linux.dev>; Thu, 17 Mar 2022 09:32:45 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
	by ppma03ams.nl.ibm.com with ESMTP id 3et95wx8kp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <nvdimm@lists.linux.dev>; Thu, 17 Mar 2022 09:32:45 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
	by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22H9WhYL44630476
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <nvdimm@lists.linux.dev>; Thu, 17 Mar 2022 09:32:43 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 99FD611C04A
	for <nvdimm@lists.linux.dev>; Thu, 17 Mar 2022 09:32:43 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 21EA111C04C
	for <nvdimm@lists.linux.dev>; Thu, 17 Mar 2022 09:32:43 +0000 (GMT)
Received: from [192.168.29.61] (unknown [9.43.89.117])
	by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP
	for <nvdimm@lists.linux.dev>; Thu, 17 Mar 2022 09:32:42 +0000 (GMT)
Subject: [ndctl PATCH] monitor: Fix the monitor config file parsing
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: nvdimm@lists.linux.dev
Date: Thu, 17 Mar 2022 15:02:41 +0530
Message-ID: <164750955519.2000193.16903542741359443926.stgit@LAPTOP-TBQTPII8>
User-Agent: StGit/1.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: bHh1SlE-iIOcrGX1Z8bWYUqjlqZcqOQ4
X-Proofpoint-ORIG-GUID: bHh1SlE-iIOcrGX1Z8bWYUqjlqZcqOQ4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-17_03,2022-03-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 phishscore=0
 malwarescore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 impostorscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203170056

Presently, ndctl monitor is not parsing both the default and user specified
config files. The behaviour is quitely masked with the recent iniparser
parsing code without any signs until you remove the /etc/ndctl.conf.d
directory when the command fails as,

 #ndctl monitor -d nmem0
 iniparser: cannot open /etc/ndctl.conf.d

The error is coming from the libiniparser when the monitor parser is
initialised with MONITOR_CALLBACK type with parse_monitor_config() as the
callback. The configs->key is set to the NDCTL_CONF_FILE for this.
The parse_config_file() compares the filename with the key before
calling the custom callback. The current code calls the
parse_config_prefix() with either the default directory path or the
custom config filepath(i.e -c <XYZ>) while the configs->key is set to
the NDCTL_CONF_FILE. Since both these strings don't match the
NDCTL_CONF_FILE, parse_monitor_config() is not called at all and instead
generic iniparser code path is taken.

The patch sets the config key to the correct filename before the calls to
parse_config_prefix().

The previous behaviour for missing monitor.conf file in the default path
was to ignore and continue. The current callback parse_monitor_config()
reports an error as e889fa5e removed the chunk taking care of this case.

So the patch gets the "current" config directory and checks if the default
monitor.conf file exists, dont attempt to parse if the file is missing.

Fixes: e889fa5ef7ff ("ndctl, monitor: refator monitor for supporting multiple config files")
Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
---
 ndctl/monitor.c |   29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/ndctl/monitor.c b/ndctl/monitor.c
index 3e6a425..54678d6 100644
--- a/ndctl/monitor.c
+++ b/ndctl/monitor.c
@@ -14,6 +14,7 @@
 #include <ndctl/ndctl.h>
 #include <ndctl/libndctl.h>
 #include <sys/epoll.h>
+#include <sys/stat.h>
 #define BUF_SIZE 2048
 
 /* reuse the core log helpers for the monitor logger */
@@ -588,7 +589,7 @@ int cmd_monitor(int argc, const char **argv, struct ndctl_ctx *ctx)
 		"ndctl monitor [<options>]",
 		NULL
 	};
-	const struct config configs[] = {
+	struct config configs[] = {
 		CONF_MONITOR(NDCTL_CONF_FILE, parse_monitor_config),
 		CONF_STR("core:bus", &param.bus, NULL),
 		CONF_STR("core:region", &param.region, NULL),
@@ -604,7 +605,9 @@ int cmd_monitor(int argc, const char **argv, struct ndctl_ctx *ctx)
 	const char *prefix = "./", *ndctl_configs;
 	struct ndctl_filter_ctx fctx = { 0 };
 	struct monitor_filter_arg mfa = { 0 };
-	int i, rc;
+	int i, rc = 0;
+	struct stat st;
+	char *path = NULL;
 
 	argc = parse_options_prefix(argc, argv, prefix, options, u, 0);
 	for (i = 0; i < argc; i++) {
@@ -622,14 +625,20 @@ int cmd_monitor(int argc, const char **argv, struct ndctl_ctx *ctx)
 		monitor.ctx.log_priority = LOG_INFO;
 
 	ndctl_configs = ndctl_get_config_path(ctx);
-	if (monitor.configs)
+	if (!monitor.configs && ndctl_configs) {
+		rc = asprintf(&path, "%s/monitor.conf", ndctl_configs);
+		if (rc < 0)
+			goto out;
+
+		if (stat(path, &st) == 0)
+			monitor.configs = path;
+	}
+	if (monitor.configs) {
+		configs[0].key = monitor.configs;
 		rc = parse_configs_prefix(monitor.configs, prefix, configs);
-	else if (ndctl_configs)
-		rc = parse_configs_prefix(ndctl_configs, prefix, configs);
-	else
-		rc = 0;
-	if (rc)
-		goto out;
+		if (rc)
+			goto out;
+	}
 
 	if (monitor.log) {
 		if (strncmp(monitor.log, "./", 2) != 0)
@@ -687,5 +696,7 @@ int cmd_monitor(int argc, const char **argv, struct ndctl_ctx *ctx)
 out:
 	if (monitor.log_file)
 		fclose(monitor.log_file);
+	if (path)
+		free(path);
 	return rc;
 }


