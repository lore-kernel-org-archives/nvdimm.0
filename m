Return-Path: <SRS0=J3Ox=GJ=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_50,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F267C433E0
	for <linux-nvdimm@archiver.kernel.org>; Wed,  6 Jan 2021 14:43:57 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1306E23100
	for <linux-nvdimm@archiver.kernel.org>; Wed,  6 Jan 2021 14:43:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1306E23100
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 70E61100EBB67;
	Wed,  6 Jan 2021 06:43:56 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=195.135.220.15; helo=mx2.suse.de; envelope-from=msuchanek@suse.de; receiver=<UNKNOWN> 
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id C41D2100ED4AF
	for <linux-nvdimm@lists.01.org>; Wed,  6 Jan 2021 06:43:53 -0800 (PST)
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 40B7FAF5B;
	Wed,  6 Jan 2021 14:43:52 +0000 (UTC)
From: Michal Suchanek <msuchanek@suse.de>
To: linux-nvdimm@lists.01.org
Subject: [PATCH ndctl] dimm: re-fix potential fd leakage in dimm_action()
Date: Wed,  6 Jan 2021 15:43:43 +0100
Message-Id: <20210106144343.22099-1-msuchanek@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Message-ID-Hash: BQS24TJJE7B7HYOGVU5UWSO3FAUVC6XV
X-Message-ID-Hash: BQS24TJJE7B7HYOGVU5UWSO3FAUVC6XV
X-MailFrom: msuchanek@suse.de
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Michal Suchanek <msuchanek@suse.de>, Zhiqiang Liu <liuzhiqiang26@huawei.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/BQS24TJJE7B7HYOGVU5UWSO3FAUVC6XV/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

There are cases not covered by the original fix and cases added by the
latter patch.

Also there is one case of usage added without returning from the
function.

Fixes: ff434d87ccbd ("dimm: fix potential fd leakage in dimm_action()")
Fixes: 41a7e24af5db ("ndctl/dimm: Auto-arm firmware activation")

Signed-off-by: Michal Suchanek <msuchanek@suse.de>
---
 ndctl/dimm.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index 09ce49e1d2ca..1c177b5494ec 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -1333,12 +1333,15 @@ static int dimm_action(int argc, const char **argv, struct ndctl_ctx *ctx,
 	if (param.arm_set && param.disarm_set) {
 		fprintf(stderr, "set either --arm, or --disarm, not both\n");
 		usage_with_options(u, options);
+		rc = -EINVAL;
+		goto out_close_fout;
 	}
 
 	if (param.disarm_set && !param.disarm) {
 		fprintf(stderr, "--no-disarm syntax not supported\n");
 		usage_with_options(u, options);
-		return -EINVAL;
+		rc = -EINVAL;
+		goto out_close_fout;
 	}
 
 	if (!param.infile) {
@@ -1351,13 +1354,15 @@ static int dimm_action(int argc, const char **argv, struct ndctl_ctx *ctx,
 			if (!param.arm_set && !param.disarm_set) {
 				fprintf(stderr, "require --arm, or --disarm\n");
 				usage_with_options(u, options);
-				return -EINVAL;
+				rc = -EINVAL;
+				goto out_close_fout;
 			}
 
 			if (param.arm_set && !param.arm) {
 				fprintf(stderr, "--no-arm syntax not supported\n");
 				usage_with_options(u, options);
-				return -EINVAL;
+				rc = -EINVAL;
+				goto out_close_fout;
 			}
 		}
 		actx.f_in = stdin;
@@ -1425,7 +1430,8 @@ static int dimm_action(int argc, const char **argv, struct ndctl_ctx *ctx,
 		if (count > 1) {
 			error("write-labels only supports writing a single dimm\n");
 			usage_with_options(u, options);
-			return -EINVAL;
+			rc = -EINVAL;
+			goto out_close_fin_fout;
 		} else if (single)
 			rc = action(single, &actx);
 	}
-- 
2.26.2
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
