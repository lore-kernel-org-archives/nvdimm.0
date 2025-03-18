Received: from seahorse.cherry.relay.mailchannels.net (seahorse.cherry.relay.mailchannels.net [23.83.223.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE2E36B
	for <nvdimm@lists.linux.dev>; Wed, 19 Mar 2025 06:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.223.161
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742365718; cv=pass; b=mGuwIyZTbYu8ULmuw3ZK7+yXtWmjzYJsmRuVkRQorD1ieTgisddPy/+7n7f4ueFti7H0Gsu+KCkhLUMiFCYEUFFTob5quKicNB5YL90IyP1Rj86JEFGKCMwXnyLSvllDpY/wbzXWx032PxSpcjeyivfImGNbp4EfUxcugfJsctg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742365718; c=relaxed/simple;
	bh=ebHUYbPDbqVHmpuJrI4EFKJ3sb1otkw+wv5k74138ro=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=Z+SoJ8QIgIaSj9rW7ZfB7HGtctKoVoyaMcLpo7n8m5J8maRU0SlS3Uf++HgQUlgSxhFpeWsL3oI3e6Wggdh5AdPIa+uGNIovOk2j1BtUJRw5v+/l4+HBwlKx7dFPux9UaUgXWPBAbaYJXw/aWR4RmqpmEIwXQVqFUptKa+MzNxI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stgolabs.net; spf=pass smtp.mailfrom=stgolabs.net; arc=pass smtp.client-ip=23.83.223.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stgolabs.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 08290844490;
	Tue, 18 Mar 2025 23:46:30 +0000 (UTC)
Received: from pdx1-sub0-mail-a315.dreamhost.com (trex-2.trex.outbound.svc.cluster.local [100.125.202.153])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 72A1E845649;
	Tue, 18 Mar 2025 23:46:29 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1742341589; a=rsa-sha256;
	cv=none;
	b=X0Z8Umd3Jh8j0IDbKbiMwM1cNeDvCavjfd1PTm3xOmVjpfF/YfPuSpzr8BC/i3qYQ6GJhj
	/ps9NcLKTJQrSvk2pZurEMFGUYwCt+RIWW7mNTz/JRCvjfXOL/jN/RXQPHPlzv1rqYPNW/
	Gtta+6oS6Nvj40qtZcj+n3CI6OK8J1Ay5RjoyRBAVqh77/s2x3hk3pZc2sncIBOvCDAw6f
	ompMeh+Z29LJYBnd3lSScdumyVJYmZsg/LdiWVC1+gYK8QlWKR8b1Ol8uvm0vpyB0WlD1A
	321dqSBOD4ZKmJCExVPq8cZYW1G8rAN596JkjZhoriFVDDthjoBxmmKMzGy5PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1742341589;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=9qBW8NAixzngMAuFMF9sv1HDYT5AMQsrCQaj33vudX0=;
	b=rgemTNDYhj51CkxSVaXfHIbQsNctooF5AhZh5NynR4o+yR2dHrrZoxRyW/W23QUYn+e3Pg
	pLpRWeBnKhgArspXZwCMxQ7ZfmBUZRhI7vnxgd0GeAfs3YWhLiFleroLScnG11nIEc9KXP
	IUUnWY0zMNQ8xtqDEzBce9F97yUvuaphdRToaESNLxK+REJofY0DnorALlw8egSXVwkGCH
	49oYTx5t0QoH6YcdH3MLeiYCLxP1otrQrsRHmEOnpuePApkacy9D6YGPijfUfgUO5eEn8I
	zjC5PLmDELhvhSTQE6sVn/NVZxPyLBXOeTpjUTuqBu+hNisHzT9gT05pWPM46g==
ARC-Authentication-Results: i=1;
	rspamd-5bd7b8dc7d-jpjgv;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MC-Copy: stored-urls
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Minister-Spill: 5c20bfb62756c249_1742341589961_2699060779
X-MC-Loop-Signature: 1742341589961:2061857188
X-MC-Ingress-Time: 1742341589960
Received: from pdx1-sub0-mail-a315.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.125.202.153 (trex/7.0.2);
	Tue, 18 Mar 2025 23:46:29 +0000
Received: from localhost.localdomain (ip72-199-50-187.sd.sd.cox.net [72.199.50.187])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a315.dreamhost.com (Postfix) with ESMTPSA id 4ZHT506mlxz54;
	Tue, 18 Mar 2025 16:46:28 -0700 (PDT)
From: Davidlohr Bueso <dave@stgolabs.net>
To: alison.schofield@intel.com
Cc: y-goto@fujitsu.com,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	Davidlohr Bueso <dave@stgolabs.net>
Subject: [PATCH v4 -ndctl] cxl/memdev: Introduce sanitize-memdev functionality
Date: Tue, 18 Mar 2025 16:45:43 -0700
Message-Id: <20250318234543.562359-1-dave@stgolabs.net>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add a new cxl_memdev_sanitize() to libcxl to support triggering memory
device sanitation, in either Sanitize and/or Secure Erase, per the
CXL 3.0 spec.

This is analogous to 'ndctl sanitize-dimm'.

Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
---
changes from v3: added missing cxl-sanitize-memdev.txt to the patch

 Documentation/cxl/cxl-sanitize-memdev.txt | 52 +++++++++++++++++++++++
 Documentation/cxl/cxl-wait-sanitize.txt   |  1 +
 Documentation/cxl/meson.build             |  1 +
 cxl/builtin.h                             |  1 +
 cxl/cxl.c                                 |  1 +
 cxl/lib/libcxl.c                          | 15 +++++++
 cxl/lib/libcxl.sym                        |  1 +
 cxl/libcxl.h                              |  1 +
 cxl/memdev.c                              | 38 +++++++++++++++++
 test/cxl-sanitize.sh                      |  4 +-
 10 files changed, 113 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/cxl/cxl-sanitize-memdev.txt

diff --git a/Documentation/cxl/cxl-sanitize-memdev.txt b/Documentation/cxl/cxl-sanitize-memdev.txt
new file mode 100644
index 000000000000..7a7c9a79b19f
--- /dev/null
+++ b/Documentation/cxl/cxl-sanitize-memdev.txt
@@ -0,0 +1,52 @@
+// SPDX-License-Identifier: GPL-2.0
+
+cxl-sanitize-memdev(1)
+======================
+
+NAME
+----
+cxl-sanitize-memdev - Perform a cryptographic destruction or sanitization
+of the contents of the given memdev(s).
+
+SYNOPSIS
+--------
+[verse]
+'cxl sanitize-memdev <mem0> [<mem1>..<memN>] [<options>]'
+
+DESCRIPTION
+-----------
+The 'sanitize-memdev' command performs two different methods of sanitization,
+per the CXL 3.0+ specification. The default is 'sanitize', but additionally,
+a 'secure-erase' option is available. It is required that the memdev be
+disabled before sanitizing, such that the device cannot be actively decoding
+any HPA ranges at the time.
+
+A device Sanitize is meant to securely re-purpose or decommission it. This
+is done by ensuring that all user data and meta data, whether it resides
+in persistent capacity, volatile capacity, or the label storage area,
+is made permanently unavailable by whatever means is appropriate for
+the media type. This sanitization request is merely submitted to the
+kernel, and the completion is asynchronous. Depending on the medium and
+capacity, sanitize may take tens of minutes to many hours. Subsequently,
+'cxl wait-sanitize’ can be used to wait for the memdevs that are under
+the sanitization.
+
+OPTIONS
+-------
+
+include::bus-option.txt[]
+
+-e::
+--secure-erase::
+	Erase user data by changing the media encryption keys for all user
+	data areas of the device.
+
+include::verbose-option.txt[]
+
+include::../copyright.txt[]
+
+SEE ALSO
+--------
+linkcxl:cxl-wait-sanitize[1],
+linkcxl:cxl-disable-memdev[1],
+linkcxl:cxl-list[1],
diff --git a/Documentation/cxl/cxl-wait-sanitize.txt b/Documentation/cxl/cxl-wait-sanitize.txt
index e8f2044e4882..9391c66eec52 100644
--- a/Documentation/cxl/cxl-wait-sanitize.txt
+++ b/Documentation/cxl/cxl-wait-sanitize.txt
@@ -42,3 +42,4 @@ include::../copyright.txt[]
 SEE ALSO
 --------
 linkcxl:cxl-list[1],
+linkcxl:cxl-sanitize-memdev[1],
diff --git a/Documentation/cxl/meson.build b/Documentation/cxl/meson.build
index 8085c1c2c87e..99e6ee782a1c 100644
--- a/Documentation/cxl/meson.build
+++ b/Documentation/cxl/meson.build
@@ -49,6 +49,7 @@ cxl_manpages = [
   'cxl-monitor.txt',
   'cxl-update-firmware.txt',
   'cxl-set-alert-config.txt',
+  'cxl-sanitize-memdev.txt',
   'cxl-wait-sanitize.txt',
 ]
 
diff --git a/cxl/builtin.h b/cxl/builtin.h
index c483f301e5e0..29c8ad2a0ad9 100644
--- a/cxl/builtin.h
+++ b/cxl/builtin.h
@@ -16,6 +16,7 @@ int cmd_reserve_dpa(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_free_dpa(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_update_fw(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_set_alert_config(int argc, const char **argv, struct cxl_ctx *ctx);
+int cmd_sanitize_memdev(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_wait_sanitize(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_disable_port(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_enable_port(int argc, const char **argv, struct cxl_ctx *ctx);
diff --git a/cxl/cxl.c b/cxl/cxl.c
index 16436671dc53..9c9f217c5a93 100644
--- a/cxl/cxl.c
+++ b/cxl/cxl.c
@@ -80,6 +80,7 @@ static struct cmd_struct commands[] = {
 	{ "disable-region", .c_fn = cmd_disable_region },
 	{ "destroy-region", .c_fn = cmd_destroy_region },
 	{ "monitor", .c_fn = cmd_monitor },
+	{ "sanitize-memdev", .c_fn = cmd_sanitize_memdev },
 };
 
 int main(int argc, const char **argv)
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 63aa4ef3acdc..d9dd37519aa4 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -1414,6 +1414,21 @@ CXL_EXPORT int cxl_memdev_get_id(struct cxl_memdev *memdev)
 	return memdev->id;
 }
 
+CXL_EXPORT int cxl_memdev_sanitize(struct cxl_memdev *memdev, char *op)
+{
+	struct cxl_ctx *ctx = cxl_memdev_get_ctx(memdev);
+	char *path = memdev->dev_buf;
+	int len = memdev->buf_len;
+
+	if (snprintf(path, len,
+		     "%s/security/%s", memdev->dev_path, op) >= len) {
+		err(ctx, "%s: buffer too small!\n",
+		    cxl_memdev_get_devname(memdev));
+		return -ERANGE;
+	}
+	return sysfs_write_attr(ctx, path, "1\n");
+}
+
 CXL_EXPORT int cxl_memdev_wait_sanitize(struct cxl_memdev *memdev,
 					int timeout_ms)
 {
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index 0c155a40ad47..bff45d47c29b 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -287,4 +287,5 @@ LIBECXL_8 {
 global:
 	cxl_memdev_trigger_poison_list;
 	cxl_region_trigger_poison_list;
+	cxl_memdev_sanitize;
 } LIBCXL_7;
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index 0a5fd0e13cc2..e10ea741bf6d 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -79,6 +79,7 @@ bool cxl_memdev_fw_update_in_progress(struct cxl_memdev *memdev);
 size_t cxl_memdev_fw_update_get_remaining(struct cxl_memdev *memdev);
 int cxl_memdev_update_fw(struct cxl_memdev *memdev, const char *fw_path);
 int cxl_memdev_cancel_fw_update(struct cxl_memdev *memdev);
+int cxl_memdev_sanitize(struct cxl_memdev *memdev, char *op);
 int cxl_memdev_wait_sanitize(struct cxl_memdev *memdev, int timeout_ms);
 
 /* ABI spelling mistakes are forever */
diff --git a/cxl/memdev.c b/cxl/memdev.c
index 6e44d1578d03..4a2daab2bbe5 100644
--- a/cxl/memdev.c
+++ b/cxl/memdev.c
@@ -35,6 +35,8 @@ static struct parameters {
 	bool align;
 	bool cancel;
 	bool wait;
+	bool sanitize;
+	bool secure_erase;
 	const char *type;
 	const char *size;
 	const char *decoder_filter;
@@ -160,6 +162,10 @@ OPT_STRING('\0', "pmem-err-alert",                                            \
 	   &param.corrected_pmem_err_alert, "'on' or 'off'",                  \
 	   "enable or disable corrected pmem error warning alert")
 
+#define SANITIZE_OPTIONS()			      \
+OPT_BOOLEAN('e', "secure-erase", &param.secure_erase, \
+	    "Secure Erase a memdev")
+
 #define WAIT_SANITIZE_OPTIONS()                \
 OPT_INTEGER('t', "timeout", &param.timeout,    \
 	    "time in milliseconds to wait for overwrite completion (default: infinite)")
@@ -226,6 +232,12 @@ static const struct option set_alert_options[] = {
 	OPT_END(),
 };
 
+static const struct option sanitize_options[] = {
+	BASE_OPTIONS(),
+	SANITIZE_OPTIONS(),
+	OPT_END(),
+};
+
 static const struct option wait_sanitize_options[] = {
 	BASE_OPTIONS(),
 	WAIT_SANITIZE_OPTIONS(),
@@ -772,6 +784,19 @@ out_err:
 	return rc;
 }
 
+static int action_sanitize_memdev(struct cxl_memdev *memdev,
+				  struct action_context *actx)
+{
+	int rc;
+
+	if (param.secure_erase)
+		rc = cxl_memdev_sanitize(memdev, "erase");
+        else
+		rc = cxl_memdev_sanitize(memdev, "sanitize");
+
+	return rc;
+}
+
 static int action_wait_sanitize(struct cxl_memdev *memdev,
 				struct action_context *actx)
 {
@@ -1228,6 +1253,19 @@ int cmd_set_alert_config(int argc, const char **argv, struct cxl_ctx *ctx)
 	return count >= 0 ? 0 : EXIT_FAILURE;
 }
 
+int cmd_sanitize_memdev(int argc, const char **argv, struct cxl_ctx *ctx)
+{
+	int count = memdev_action(
+		argc, argv, ctx, action_sanitize_memdev, sanitize_options,
+		"cxl sanitize-memdev <mem0> [<mem1>..<memn>] [<options>]");
+
+	log_info(&ml, "sanitize %s on %d mem device%s\n",
+		 count >= 0 ? "completed/started" : "failed",
+		 count >= 0 ? count : 0,  count > 1 ? "s" : "");
+
+	return count >= 0 ? 0 : EXIT_FAILURE;
+}
+
 int cmd_wait_sanitize(int argc, const char **argv, struct cxl_ctx *ctx)
 {
 	int count = memdev_action(
diff --git a/test/cxl-sanitize.sh b/test/cxl-sanitize.sh
index 9c161014ccb7..8c5027ab9f48 100644
--- a/test/cxl-sanitize.sh
+++ b/test/cxl-sanitize.sh
@@ -45,7 +45,7 @@ count=${#active_mem[@]}
 set_timeout ${active_mem[0]} 2000
 
 # sanitize with an active memdev should fail
-echo 1 > /sys/bus/cxl/devices/${active_mem[0]}/security/sanitize && err $LINENO
+"$CXL" sanitize-memdev ${active_mem[0]} && err $LINENO
 
 # find an inactive mem
 inactive=""
@@ -67,7 +67,7 @@ done
 # secounds
 set_timeout $inactive 3000
 start=$SECONDS
-echo 1 > /sys/bus/cxl/devices/${inactive}/security/sanitize &
+"$CXL" sanitize-memdev $inactive || err $LINENO
 "$CXL" wait-sanitize $inactive || err $LINENO
 ((SECONDS > start + 2)) || err $LINENO
 
-- 
2.39.5

