Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A0DF3FC1
	for <nvdimm@lists.linux.dev>; Tue, 24 Aug 2021 09:51:42 +0000 (UTC)
Received: by mail-pl1-f176.google.com with SMTP id j2so7491336pll.1
        for <nvdimm@lists.linux.dev>; Tue, 24 Aug 2021 02:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ex53nSYjngYSyxpThYpQZDnvKgvgMewbuv3AG4+XhFY=;
        b=bbfxcwkSw5bRZJP8w2KHYHRReSxlR+iL1tgbM3XD3OJtG8z+zkvhMoifFXc38Dt/UL
         cRbRn3YHIQVxiJzXuzCAQmnjRvz0mBwfYswBiX/byisQqQmUZeGzDjWt+EKkhJWsQTtK
         FEr2X3EwhdX2crI/fsMuHCmvNS9KzlDYNZTiM4YFqzcyu6fAXoMFhZrDJHPhNHgOSOM+
         EQZbpJix1j/kB03QDegM77r65Tj0Tv83IvqOAWrLOItgqWvmNf2pdPiiq5C8wWd/419c
         D6Bs1iP/nS6n43IQ7OQC//qx6w6ovaZzXmu5/8a9lh2gk8XOOXUa/85kJHEI6gX4G5aN
         WY9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ex53nSYjngYSyxpThYpQZDnvKgvgMewbuv3AG4+XhFY=;
        b=BmnWvL7P+fdGiveJRd5nrz6WeJXB0GQ3m+5Ki6FSUIBt1AU+unqUgzZBnmLeWi8wrt
         1sD40gGoSknUNzZwt5sd2nD2tWUrpekhO56M6P0Xecpu//BDpusxC8WYiKbxYjQshmsz
         EVeQzmeZWsC5xQ+3tmM/cZv0BSUQrRcNUZ5KS5UPxn4QPb0PqnHjxf6drvmDUVqUDgcI
         sxEEXRtMC5Dj/n6qAu0lYB2nfnzE6vi2gkdn2CkM4uBbPX0p7DbFfoNqAVNGX0Bh4qOD
         DvZyxRmDnPXVj120RJc6hS0l1D4y5v7Be3cBUTwn6KPsc+juHUTeNwqTk17nhV14jDhU
         ltsg==
X-Gm-Message-State: AOAM530FONFLXdx+YYABM8wmEJbtZYjGpczNu+APgm41sCY7W6t/XgwT
	QiBgLWy4vpB/VLUqxRr9Y/MB1p+sDEvudw==
X-Google-Smtp-Source: ABdhPJwbGWdYtyr87+mqMDJJEBcB8NrSBxpdTt681NjpcnsJoKVpdQSENFiewWydpSqdEuxPe/gUgQ==
X-Received: by 2002:a17:902:7682:b029:12d:3a69:c6cb with SMTP id m2-20020a1709027682b029012d3a69c6cbmr32741008pll.65.1629798702667;
        Tue, 24 Aug 2021 02:51:42 -0700 (PDT)
Received: from localhost.localdomain (125x103x255x1.ap125.ftth.ucom.ne.jp. [125.103.255.1])
        by smtp.gmail.com with ESMTPSA id l19sm1873881pjq.10.2021.08.24.02.51.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 02:51:42 -0700 (PDT)
From: QI Fuli <fukuri.sai@gmail.com>
X-Google-Original-From: QI Fuli <qi.fuli@fujitsu.com>
To: nvdimm@lists.linux.dev
Cc: QI Fuli <qi.fuli@fujitsu.com>
Subject: [ndctl PATCH v2 4/5] ndctl, config: add the default ndctl configuration file
Date: Tue, 24 Aug 2021 18:51:05 +0900
Message-Id: <20210824095106.104808-5-qi.fuli@fujitsu.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210824095106.104808-1-qi.fuli@fujitsu.com>
References: <20210824095106.104808-1-qi.fuli@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: QI Fuli <qi.fuli@fujitsu.com>

Install ndctl/ndctl.conf as the default ndctl configuration file.

Signed-off-by: QI Fuli <qi.fuli@fujitsu.com>
---
 configure.ac      |  2 ++
 ndctl/Makefile.am |  4 +++-
 ndctl/ndctl.conf  | 56 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 61 insertions(+), 1 deletion(-)
 create mode 100644 ndctl/ndctl.conf

diff --git a/configure.ac b/configure.ac
index 42a66e1..9e1c6db 100644
--- a/configure.ac
+++ b/configure.ac
@@ -172,8 +172,10 @@ AC_SUBST([systemd_unitdir])
 AM_CONDITIONAL([ENABLE_SYSTEMD_UNITS], [test "x$with_systemd" = "xyes"])
 
 ndctl_confdir=${sysconfdir}/ndctl
+ndctl_conf=ndctl.conf
 ndctl_monitorconf=monitor.conf
 AC_SUBST([ndctl_confdir])
+AC_SUBST([ndctl_conf])
 AC_SUBST([ndctl_monitorconf])
 
 daxctl_modprobe_datadir=${datadir}/daxctl
diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index 1caa031..fceb3ab 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -43,7 +43,7 @@ keys_configdir = $(ndctl_keysdir)
 keys_config_DATA = $(ndctl_keysreadme)
 endif
 
-EXTRA_DIST += keys.readme monitor.conf ndctl-monitor.service
+EXTRA_DIST += keys.readme monitor.conf ndctl-monitor.service ndctl.conf
 
 if ENABLE_DESTRUCTIVE
 ndctl_SOURCES += ../test/blk_namespaces.c \
@@ -74,6 +74,8 @@ ndctl_SOURCES += ../test/libndctl.c \
 		 test.c
 endif
 
+ndctl_configdir = $(ndctl_confdir)
+ndctl_config_DATA = $(ndctl_conf)
 monitor_configdir = $(ndctl_confdir)
 monitor_config_DATA = $(ndctl_monitorconf)
 
diff --git a/ndctl/ndctl.conf b/ndctl/ndctl.conf
new file mode 100644
index 0000000..04d322d
--- /dev/null
+++ b/ndctl/ndctl.conf
@@ -0,0 +1,56 @@
+# This is the default ndctl configuration file. It contains the
+# configuration directives that give ndctl instructions.
+# Ndctl supports multiple configuration files. All files with the
+# .conf suffix under {sysconfdir}/ndctl can be regarded as ndctl
+# configuration files.
+
+# In this file, lines starting with a hash (#) are comments.
+# The configurations should be in a [section] and follow <key> = <value>
+# style. Multiple space-separated values are allowed, but except the
+# following characters: : ? / \ % " ' $ & ! * { } [ ] ( ) = < > @
+
+[core]
+# The values in [core] section work for all ndctl sub commands.
+# dimm = all
+# bus = all
+# region = all
+# namespace = all
+
+[monitor]
+# The values in [monitor] section work for ndctl monitor.
+# You can change the configuration of ndctl monitor by editing this
+# file or use [--config-file=<file>] option to override this one.
+# The changed value will work after restart ndctl monitor service.
+
+# The objects to monitor are filtered via dimm's name by setting key "dimm".
+# If this value is different from the value of [--dimm=<value>] option,
+# both of the values will work.
+# dimm = all
+
+# The objects to monitor are filtered via its parent bus by setting key "bus".
+# If this value is different from the value of [--bus=<value>] option,
+# both of the values will work.
+# bus = all
+
+# The objects to monitor are filtered via region by setting key "region".
+# If this value is different from the value of [--region=<value>] option,
+# both of the values will work.
+# region = all
+
+# The objects to monitor are filtered via namespace by setting key "namespace".
+# If this value is different from the value of [--namespace=<value>] option,
+# both of the values will work.
+# namespace = all
+
+# The DIMM events to monitor are filtered via event type by setting key
+# "dimm-event". If this value is different from the value of
+# [--dimm-event=<value>] option, both of the values will work.
+# dimm-event = all
+
+# Users can choose to output the notifications to syslog (log=syslog),
+# to standard output (log=standard) or to write into a special file (log=<file>)
+# by setting key "log". If this value is in conflict with the value of
+# [--log=<value>] option, this value will be ignored.
+# Note: Setting value to "standard" or relative path for <file> will not work
+# when running moniotr as a daemon.
+# log = /var/log/ndctl/monitor.log
-- 
2.31.1

