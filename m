Return-Path: <SRS0=QPk9=H7=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.7 required=3.0 tests=BAYES_50,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 435E4C433DB
	for <linux-nvdimm@archiver.kernel.org>; Mon,  1 Mar 2021 17:26:02 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D785365236
	for <linux-nvdimm@archiver.kernel.org>; Mon,  1 Mar 2021 17:26:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D785365236
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 84C97100EBB71;
	Mon,  1 Mar 2021 09:26:01 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2607:f8b0:4864:20::432; helo=mail-pf1-x432.google.com; envelope-from=fukuri.sai@gmail.com; receiver=<UNKNOWN> 
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 1DF39100EBB6E
	for <linux-nvdimm@lists.01.org>; Mon,  1 Mar 2021 09:25:59 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id e3so7974848pfj.6
        for <linux-nvdimm@lists.01.org>; Mon, 01 Mar 2021 09:25:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wSJSHjBP/MrwTOKYNfMuona+Wiq8HuKha5xRx7ucc30=;
        b=CDIvKUee7lKRs0CLpi/RDMAegmAdwsx2rU0gBnwPVQ9RkYBRaf3O2s0AFHrCcxSs1u
         G9OCbepzySuc6mo6JW9ISGrFY9VmDyqax7qNKcvxDLEoS3qeeoXyusmhUhfd8th8DkpW
         UPQSU5flbBRo3BBfGR5N8OPRzgG4bvqyUHMlWX/nVeKaVmO1Q/Re+R8zWklJbmK8LvG+
         +Uc9omcGJowcuUNyrgEQ8I52kaCfxrHxEccvCx5YG+8qMpLOOe92DfYNrQG77y/6QA6i
         yhfRKdSrD/T2CSEs5cJEpk28KRp5bp9PKVhNgkLz0oXs9Nh2K9kDQMEsbWKaKIcdpn3L
         GBhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wSJSHjBP/MrwTOKYNfMuona+Wiq8HuKha5xRx7ucc30=;
        b=es71S2fGZBY8ylRD1qY5gyxkN6fZtORXOe7VW01VqvVbrWH8MGFYsX/gaAYs9/8bM3
         KBAWKo9MqYAM5x+GiyDNE6qmSXcC1wsMzzoTv4OsaSMtzYmUuVMu8ZgJVEOUHhmHRMNg
         WiPmsinb5M3nV1oTpSf2RPr825p9NdmpKkIq0AjJPhqpRNzqUc6wBPOAKa6KGngxFen3
         5Woi26haMsK/6HQrO0YGVUoZigLvOQYfWNIJeodmZoCV+GbSNyvf9LvNiNtkM8o9r4jB
         BKXDNNFkaavJk04SX6M4ZsqxhQFBs1C1awWvl9ftuxrOqRnDH/tv8pmWUNvtEbubH93U
         ZFag==
X-Gm-Message-State: AOAM531TUHDacJvWh4Wsrx9ICgpiiDG1F7T7wNPBk/vXx42zn3x155tW
	ZeexKLmcUHbPCKmPRsMXIlaZY4vvyZNhNkJB
X-Google-Smtp-Source: ABdhPJw1kgK/xieyOyvYEwTpslBFvrGyzLd1fJ/vIU84SVx5q+FSYHV8kq3pzVyaZCm+PUoACPBcAw==
X-Received: by 2002:aa7:9707:0:b029:1ee:8ad4:7840 with SMTP id a7-20020aa797070000b02901ee8ad47840mr7615449pfg.32.1614619558319;
        Mon, 01 Mar 2021 09:25:58 -0800 (PST)
Received: from localhost.localdomain (softbank126036163236.bbtec.net. [126.36.163.236])
        by smtp.gmail.com with ESMTPSA id r186sm13622079pfr.124.2021.03.01.09.25.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 09:25:57 -0800 (PST)
From: QI Fuli <fukuri.sai@gmail.com>
X-Google-Original-From: QI Fuli <qi.fuli@fujitsu.com>
To: linux-nvdimm@lists.01.org
Subject: [ndctl PATCH 2/2] ndctl/test: add checking the presence of jq command ahead
Date: Tue,  2 Mar 2021 02:25:40 +0900
Message-Id: <20210301172540.1511-2-qi.fuli@fujitsu.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210301172540.1511-1-qi.fuli@fujitsu.com>
References: <20210301172540.1511-1-qi.fuli@fujitsu.com>
MIME-Version: 1.0
Message-ID-Hash: ISKELA6B4UGT5OJFGJERWZESHDIYDUS2
X-Message-ID-Hash: ISKELA6B4UGT5OJFGJERWZESHDIYDUS2
X-MailFrom: fukuri.sai@gmail.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: QI Fuli <qi.fuli@fujitsu.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/ISKELA6B4UGT5OJFGJERWZESHDIYDUS2/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Due to the lack of jq command, the result of the test will be 'fail'.
This patch adds checking the presence of jq commmand ahead.
If there is no jq command in the system, the test will be marked as 'skip'.

Signed-off-by: QI Fuli <qi.fuli@fujitsu.com>
Link: https://github.com/pmem/ndctl/issues/141
---
 test/daxdev-errors.sh           | 1 +
 test/inject-error.sh            | 2 ++
 test/inject-smart.sh            | 1 +
 test/label-compat.sh            | 1 +
 test/max_available_extent_ns.sh | 1 +
 test/monitor.sh                 | 2 ++
 test/multi-dax.sh               | 1 +
 test/sector-mode.sh             | 2 ++
 8 files changed, 11 insertions(+)

diff --git a/test/daxdev-errors.sh b/test/daxdev-errors.sh
index 6281f32..9547d78 100755
--- a/test/daxdev-errors.sh
+++ b/test/daxdev-errors.sh
@@ -9,6 +9,7 @@ rc=77
 . $(dirname $0)/common

 check_min_kver "4.12" || do_skip "lacks dax dev error handling"
+check_prereq "jq"

 trap 'err $LINENO' ERR

diff --git a/test/inject-error.sh b/test/inject-error.sh
index c636033..7d0b826 100755
--- a/test/inject-error.sh
+++ b/test/inject-error.sh
@@ -11,6 +11,8 @@ err_count=8

 . $(dirname $0)/common

+check_prereq "jq"
+
 trap 'err $LINENO' ERR

 # sample json:
diff --git a/test/inject-smart.sh b/test/inject-smart.sh
index 94705df..4ca83b8 100755
--- a/test/inject-smart.sh
+++ b/test/inject-smart.sh
@@ -166,6 +166,7 @@ do_tests()
 }

 check_min_kver "4.19" || do_skip "kernel $KVER may not support smart (un)injection"
+check_prereq "jq"
 modprobe nfit_test
 rc=1

diff --git a/test/label-compat.sh b/test/label-compat.sh
index 340b93d..8ab2858 100755
--- a/test/label-compat.sh
+++ b/test/label-compat.sh
@@ -10,6 +10,7 @@ BASE=$(dirname $0)
 . $BASE/common

 check_min_kver "4.11" || do_skip "may not provide reliable isetcookie values"
+check_prereq "jq"

 trap 'err $LINENO' ERR

diff --git a/test/max_available_extent_ns.sh b/test/max_available_extent_ns.sh
index 14d741d..343f3c9 100755
--- a/test/max_available_extent_ns.sh
+++ b/test/max_available_extent_ns.sh
@@ -9,6 +9,7 @@ rc=77
 trap 'err $LINENO' ERR

 check_min_kver "4.19" || do_skip "kernel $KVER may not support max_available_size"
+check_prereq "jq"

 init()
 {
diff --git a/test/monitor.sh b/test/monitor.sh
index cdab5e1..28c5541 100755
--- a/test/monitor.sh
+++ b/test/monitor.sh
@@ -13,6 +13,8 @@ smart_supported_bus=""

 . $(dirname $0)/common

+check_prereq "jq"
+
 trap 'err $LINENO' ERR

 check_min_kver "4.15" || do_skip "kernel $KVER may not support monitor service"
diff --git a/test/multi-dax.sh b/test/multi-dax.sh
index e932569..8496619 100755
--- a/test/multi-dax.sh
+++ b/test/multi-dax.sh
@@ -9,6 +9,7 @@ rc=77
 . $(dirname $0)/common

 check_min_kver "4.13" || do_skip "may lack multi-dax support"
+check_prereq "jq"

 trap 'err $LINENO' ERR

diff --git a/test/sector-mode.sh b/test/sector-mode.sh
index dd7013e..54fa806 100755
--- a/test/sector-mode.sh
+++ b/test/sector-mode.sh
@@ -6,6 +6,8 @@ rc=77

 . $(dirname $0)/common

+check_prereq "jq"
+
 set -e
 trap 'err $LINENO' ERR

--
2.29.2
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
