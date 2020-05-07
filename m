Return-Path: <SRS0=mksC=6V=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EA82C47257
	for <linux-nvdimm@archiver.kernel.org>; Thu,  7 May 2020 18:53:20 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0520B2495D
	for <linux-nvdimm@archiver.kernel.org>; Thu,  7 May 2020 18:53:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="FSQeULZO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0520B2495D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id ADA63117F2780;
	Thu,  7 May 2020 11:51:20 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=198.145.29.99; helo=mail.kernel.org; envelope-from=gustavoars@kernel.org; receiver=<UNKNOWN> 
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 4FD5B117E5ADE
	for <linux-nvdimm@lists.01.org>; Thu,  7 May 2020 11:51:19 -0700 (PDT)
Received: from embeddedor (unknown [189.207.59.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id 8828424960;
	Thu,  7 May 2020 18:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588877598;
	bh=qD1YTu45POQi4xsMj+gdlSVCGKp5j89OYm2p2pPtKh4=;
	h=Date:From:To:Cc:Subject:From;
	b=FSQeULZOf97JknZWY5LLJLQT/B28yD4GV5UeqoNuLVRKkxweMPCE3bj9Ix6zBiXZG
	 SkK2rXUmNi8iocLO2FpUJfFio+NqcvdSBhbGk6cfmwEwR3nhnNDUrEwSblam8VUPu8
	 tKEbXqXjoojLcnrP4v7c2q3FxuHkngwmGz6OeIH8=
Date: Thu, 7 May 2020 13:57:44 -0500
From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>
Subject: [PATCH] tools/testing/nvdimm: Replace zero-length array with
 flexible-array
Message-ID: <20200507185744.GA14974@embeddedor>
MIME-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Message-ID-Hash: NXBJ3SLK7FN5RUTE2QHOPYQ7NWLDF33Q
X-Message-ID-Hash: NXBJ3SLK7FN5RUTE2QHOPYQ7NWLDF33Q
X-MailFrom: gustavoars@kernel.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/NXBJ3SLK7FN5RUTE2QHOPYQ7NWLDF33Q/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The current codebase makes use of the zero-length array language
extension to the C90 standard, but the preferred mechanism to declare
variable-length types such as these ones is a flexible array member[1][2],
introduced in C99:

struct foo {
        int stuff;
        struct boo array[];
};

By making use of the mechanism above, we will get a compiler warning
in case the flexible array does not occur last in the structure, which
will help us prevent some kind of undefined behavior bugs from being
inadvertently introduced[3] to the codebase from now on.

Also, notice that, dynamic memory allocations won't be affected by
this change:

"Flexible array members have incomplete type, and so the sizeof operator
may not be applied. As a quirk of the original implementation of
zero-length arrays, sizeof evaluates to zero."[1]

sizeof(flexible-array-member) triggers a warning because flexible array
members have incomplete type[1]. There are some instances of code in
which the sizeof operator is being incorrectly/erroneously applied to
zero-length arrays and the result is zero. Such instances may be hiding
some bugs. So, this work (flexible-array member conversions) will also
help to get completely rid of those sorts of issues.

This issue was found with the help of Coccinelle.

[1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
[2] https://github.com/KSPP/linux/issues/21
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 tools/testing/nvdimm/test/nfit_test.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/nvdimm/test/nfit_test.h b/tools/testing/nvdimm/test/nfit_test.h
index db3c07beb9d1..b5f7a996c4d0 100644
--- a/tools/testing/nvdimm/test/nfit_test.h
+++ b/tools/testing/nvdimm/test/nfit_test.h
@@ -51,7 +51,7 @@ struct nd_cmd_translate_spa {
 		__u32 nfit_device_handle;
 		__u32 _reserved;
 		__u64 dpa;
-	} __packed devices[0];
+	} __packed devices[];
 
 } __packed;
 
@@ -74,7 +74,7 @@ struct nd_cmd_ars_err_inj_stat {
 	struct nd_error_stat_query_record {
 		__u64 err_inj_stat_spa_range_base;
 		__u64 err_inj_stat_spa_range_length;
-	} __packed record[0];
+	} __packed record[];
 } __packed;
 
 #define ND_INTEL_SMART			 1
@@ -180,7 +180,7 @@ struct nd_intel_fw_send_data {
 	__u32 context;
 	__u32 offset;
 	__u32 length;
-	__u8 data[0];
+	__u8 data[];
 /* this field is not declared due ot variable data from input */
 /*	__u32 status; */
 } __packed;
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
