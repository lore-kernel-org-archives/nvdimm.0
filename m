Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89ACD3FCA
	for <nvdimm@lists.linux.dev>; Sun, 22 Aug 2021 20:30:58 +0000 (UTC)
Received: by mail-pj1-f47.google.com with SMTP id n13-20020a17090a4e0d00b0017946980d8dso17248421pjh.5
        for <nvdimm@lists.linux.dev>; Sun, 22 Aug 2021 13:30:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/3zXirtye3zGCxHNCsVbPjqEs0jJVuY2N98o8Afa5Cw=;
        b=HzP6P0kio6MyXxia2TZD6JJgsHXBwxT7GrrX3jdTPLPjWLeGW99aueobOFbUx/Z1rg
         JO6x1j5RzK8LBQovmN8CJbxjo0DmU1Vg19YV7KXIHnjuJKxSAwOx0hVNE4RJYHNk9ybx
         mDQ5xYkuG7NqjJu/We/OXsFZUe8Sdub3pMY5RNE/7MYNMDyVnRG7pPBMBySj7BiP5a9v
         OEHZIil0j97ms2nxNdGcRQEpgp0uFK+rPcgDJgeceFuoVveHIeQ4+l+gDzEGoi+eqQJX
         ymfrdoQ061ZupBl0MndafUCej6l6nBHMwNVs0phqgQKV9b1874yFc6GfcIfGE8FWKtKH
         gGlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/3zXirtye3zGCxHNCsVbPjqEs0jJVuY2N98o8Afa5Cw=;
        b=pOnMk0rDt+H8VCBaWZcT4WX4nZWIXZQaGcoRbIFq2cyPyuKTt00vkHNvN52DEuqJ6p
         hjwIXKB9oNBPbUf/IM3OeBoY/z5xONmepy7U+ifEqpsS4PWX+UF6vX6ufZ2pIk6pqqvy
         7/JFlOG2zW/7WJ4Urh58sIP16ITu0fVBUl7bIWnwwiy74PmA7SYJs1FMA1Ue+5c9uDuH
         FOUJJNehMl49mZdEk1abxLowMbmiuOUAOch1cWkVpDF9oNUGi/XI5oFpyVUOFMLNGRSv
         dSiDHdXtZFgoORgDPMu9Pk0WtSD5tGRrT05GLll2Ng78cX1ypIRlL6tO4G10Wp2R1IYk
         Au2g==
X-Gm-Message-State: AOAM530JN9IcsPNAX9ieoKN6BiSMUa0B6fDQLjPdVMX1/7hAbkQ0E13b
	ioXQBhNvuvUpoQGe+qziDqwGhte0dnbCKA==
X-Google-Smtp-Source: ABdhPJyn3BxaNrFX//vSS2DydoE1vq+wR7DDD6Mg6XUXugRHhc8MtHAgtB1y+82yPD4zy/XCGHW+nA==
X-Received: by 2002:a17:90a:1282:: with SMTP id g2mr16741926pja.230.1629664258189;
        Sun, 22 Aug 2021 13:30:58 -0700 (PDT)
Received: from localhost.localdomain (125x103x255x1.ap125.ftth.ucom.ne.jp. [125.103.255.1])
        by smtp.gmail.com with ESMTPSA id n30sm13587804pfv.87.2021.08.22.13.30.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Aug 2021 13:30:57 -0700 (PDT)
From: QI Fuli <fukuri.sai@gmail.com>
X-Google-Original-From: QI Fuli <qi.fuli@fujitsu.com>
To: nvdimm@lists.linux.dev
Cc: QI Fuli <qi.fuli@fujitsu.com>
Subject: [ndctl PATCH 4/5] ndctl, config: add the default ndctl configuration file
Date: Mon, 23 Aug 2021 05:30:14 +0900
Message-Id: <20210822203015.528438-5-qi.fuli@fujitsu.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210822203015.528438-1-qi.fuli@fujitsu.com>
References: <20210822203015.528438-1-qi.fuli@fujitsu.com>
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
index 0000000..4b3eb7e
--- /dev/null
+++ b/ndctl/ndctl.conf
@@ -0,0 +1,56 @@
+# This is the default ndctl configuration file. It contains the
+# configuration directives that give ndctl instructions.
+# Ndctl supports multiple configuration files. All files with the
+# .conf suffix under "sysconfdir/ndctl/" can be regarded as ndctl
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

