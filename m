Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9012C88
	for <nvdimm@lists.linux.dev>; Tue, 19 Oct 2021 09:49:48 +0000 (UTC)
Received: by mail-pl1-f176.google.com with SMTP id s1so11484258plg.12
        for <nvdimm@lists.linux.dev>; Tue, 19 Oct 2021 02:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+TkWgYayAqA1N78B6sSsdHP9plKG2QD+oGHbJ5CtYzQ=;
        b=m3HHQ244JZcfBV4yayxuPXIIHn8jzm/+dKCpjH1czmAdXvJ7NHYTvwhK+o+sK3DGcw
         15ETtdDsCu686pOq9aka3Q8zHJmQjqkAtyeMDi9B8i10VUrEFz/7g4fCh9iDpu006vfQ
         pfR5e6UU3pjH9x3iVthflT/UVKkT9CQ6MwsmtJdPGCPwosXPZrNxBK51x2y6+6Kvifnk
         U8pA+KQooeflyAx75vEiXJYbWuZn3SI/l1ExvRktEHxcLi/HOEo3qUfJMAJOOJ9w2pod
         5cZ4QrQ9hTh3/s3FF21fdfgWhmIPQjuPbby5htVtd7BILtZ/o1BgTpPfxvKtsoVyKHcY
         29Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+TkWgYayAqA1N78B6sSsdHP9plKG2QD+oGHbJ5CtYzQ=;
        b=1xUBs7t1lv+T0tckIloKqHuNqr62gfAxi9Q5gkxvANdMyxAXX409KGsu/YVV6yWVU4
         nzaaG/CL7Un3gYR2kPVLKTPxMtCjosrGqi5PL3CDWNclMNtDM33kYSIwHJOf0A+yT5CV
         GLlmDQAr37Gii1bdyARnT6D2LBLbWVYuVpN3H4KkfVu1KsZ6Dev7aaHUL/TkWYYWsJR6
         1uI6njIi66Ns5RqywmC7VF1z5haRJP1C2e4iNBEYoyOug+ALOeZxSAlzcjRO4Lks6Ll1
         46Q0PHZ7m9ZPFbFC58WywnlI7akrKJKCCSaj+38Y8CgFVxOuk9kXSO5xMOv5fqguqWSa
         hZxg==
X-Gm-Message-State: AOAM5333JBp5CCxfINyffXp7tYLGit04PCMAAnqi9fjFxkSOHojEGaX/
	UpVs3zEAQ6kEkEPEW0SjLsMByfkJMJjUqA==
X-Google-Smtp-Source: ABdhPJz+uBKC1bVwE9j+5reNsHLMTZxlluW6eNqfAvjnGDcR9LW9FQbF91y4OrG3hB+Y8FrB63TjOQ==
X-Received: by 2002:a17:90b:388a:: with SMTP id mu10mr5506047pjb.0.1634636988444;
        Tue, 19 Oct 2021 02:49:48 -0700 (PDT)
Received: from fedora34.. (125x103x255x1.ap125.ftth.ucom.ne.jp. [125.103.255.1])
        by smtp.gmail.com with ESMTPSA id q8sm2100331pja.52.2021.10.19.02.49.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 02:49:48 -0700 (PDT)
From: QI Fuli <fukuri.sai@gmail.com>
X-Google-Original-From: QI Fuli <qi.fuli@fujitsu.com>
To: nvdimm@lists.linux.dev
Cc: QI Fuli <qi.fuli@fujitsu.com>
Subject: [RFC ndctl PATCH] monitor: Add "run" to call a bash script
Date: Tue, 19 Oct 2021 18:49:37 +0900
Message-Id: <20211019094937.11923-1-qi.fuli@fujitsu.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: QI Fuli <qi.fuli@fujitsu.com>

Currently, ndctl monitor only can write the smart event to log.
If users do not read the log on time or the log analysis tools miss
the smart event information, it will cause huge losses.

For example, if the smart health event dimm-spares-remaining takes
place and users do not back up the data on time, it is largely
possible to lose the data. If a bash script used to back up
can be called, this problem will be avoided.

This patch adds a new argument named "run" to ndctl monitor command
to set a bash script. When a smart event is monitored, the bash
script can be run immediately.

The following is the sample code for implementation. If it makes
sense, I will continue to work on the patch. I will appreciate
any comments.

Signed-off-by: QI Fuli <qi.fuli@fujitsu.com>
---
 ndctl/monitor.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/ndctl/monitor.c b/ndctl/monitor.c
index e944c90..ff4513a 100644
--- a/ndctl/monitor.c
+++ b/ndctl/monitor.c
@@ -38,6 +38,7 @@ static struct monitor {
 	unsigned int poll_timeout;
 	unsigned int event_flags;
 	struct log_ctx ctx;
+	const char *run;
 } monitor;
 
 struct monitor_dimm {
@@ -389,6 +390,8 @@ static int monitor_event(struct ndctl_ctx *ctx,
 		for (i = 0; i < nfds; i++) {
 			mdimm = events[i].data.ptr;
 			if (util_dimm_event_filter(mdimm, monitor.event_flags)) {
+				rc = system(monitor.run);
+				...
 				rc = notify_dimm_event(mdimm);
 				if (rc) {
 					err(&monitor, "%s: notify dimm event failed\n",
@@ -546,6 +549,7 @@ static int parse_monitor_config(const struct config *configs,
 		set_monitor_conf(&param.region, "region", value, seek);
 		set_monitor_conf(&param.namespace, "namespace", value, seek);
 		set_monitor_conf(&monitor.dimm_event, "dimm-event", value, seek);
+		set_monitor_conf(&monitor.run, "run", value, seek);
 
 		if (!monitor.log)
 			set_monitor_conf(&monitor.log, "log", value, seek);
@@ -581,6 +585,8 @@ int cmd_monitor(int argc, const char **argv, struct ndctl_ctx *ctx)
 				"emit extra debug messages to log"),
 		OPT_UINTEGER('p', "poll", &monitor.poll_timeout,
 			     "poll and report events/status every <n> seconds"),
+		OPT_STRING('\0', "run", &monitor.run, "bash script",
+			"run a script when the smart event is monitored"),
 		OPT_END(),
 	};
 	const char * const u[] = {
@@ -598,6 +604,7 @@ int cmd_monitor(int argc, const char **argv, struct ndctl_ctx *ctx)
 		CONF_STR("monitor:dimm", &param.dimm, NULL),
 		CONF_STR("monitor:namespace", &param.namespace, NULL),
 		CONF_STR("monitor:dimm-event", &monitor.dimm_event, NULL),
+		CONF_STR("monitor:run", &monitor.run, NULL),
 		CONF_END(),
 	};
 	const char *prefix = "./";
@@ -646,6 +653,9 @@ int cmd_monitor(int argc, const char **argv, struct ndctl_ctx *ctx)
 		}
 	}
 
+	if (monitor.run && (strncmp(monitor.run, "./", 2) != 0))
+		fix_filename(prefix, (const char **)&monitor.run);
+
 	if (monitor.daemon) {
 		if (!monitor.log || strncmp(monitor.log, "./", 2) == 0)
 			monitor.ctx.log_fn = log_syslog;
-- 
2.31.1

