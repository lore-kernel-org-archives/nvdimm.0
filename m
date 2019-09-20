Return-Path: <SRS0=rtTk=XP=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 090CBC49ED7
	for <linux-nvdimm@archiver.kernel.org>; Fri, 20 Sep 2019 23:51:52 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CCEE22073F
	for <linux-nvdimm@archiver.kernel.org>; Fri, 20 Sep 2019 23:51:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="Alfuq4xK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CCEE22073F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from [127.0.0.1] (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 8E888202ECFD3;
	Fri, 20 Sep 2019 16:50:46 -0700 (PDT)
Received-SPF: Pass (sender SPF authorized) identity=mailfrom;
 client-ip=2607:f8b0:4864:20::d49; helo=mail-io1-xd49.google.com;
 envelope-from=3t16fxq4kdhwgwjsifsmnllnsxlttlqj.htrqnsz2-s0inrrqnxyx.56.twl@flex--brendanhiggins.bounces.google.com;
 receiver=linux-nvdimm@lists.01.org 
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com
 [IPv6:2607:f8b0:4864:20::d49])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 45A41202ECFBD
 for <linux-nvdimm@lists.01.org>; Fri, 20 Sep 2019 16:50:45 -0700 (PDT)
Received: by mail-io1-xd49.google.com with SMTP id k14so4172834iot.14
 for <linux-nvdimm@lists.01.org>; Fri, 20 Sep 2019 16:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=MYcfIKSKU50yEk2GBsBM2m5RiXljhL+2ZE7FFRNNMnA=;
 b=Alfuq4xKcjyE/lvI9+hnlObqPY31tSqFtCXmQsJDgKBbZcMDdLd/Xe7IG+dh2opFqi
 NkyEiOKdCjZbdWPC1fBNLUcaNtEJgBGm/C9KYrpwSGMN9kJJghCA0tF/hzhbo3QAqnOy
 G1qrxWya38IKA9aT9DrUpNHS8ofpmZs1hUked/PR+nRiVaU1VfXljtUe111C/R7on8zn
 6GrH2up+ee3CPMMeu4c4xDYF5+vRDtfCDix7aXc4nXc5AUTjcX3VMvg69w2RWR9+CCLb
 ZYb5QuoRRzIn5CjL5tKk6cztEmTrCtopo7An4Qopbv5QmyKSNuCyNb6EPWl43WB8ctZa
 XW0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=MYcfIKSKU50yEk2GBsBM2m5RiXljhL+2ZE7FFRNNMnA=;
 b=O6/pSjmuPVVDSpSFkE6xfRDTYW3ilB1c1a9/jNL0YZGZ5kHA2O5MFbmOZHvvop3ZzR
 Yufdhvr9b71v6uWzRaVtPv/AYfaaeNtBTDyhhGny96qwFc20Rk2gpf55QLCAfydSVR4W
 FsBNvxs6fM1EEBPwO97MfsIqShPna9nke0fWqNEDCQ4bAHBb116nssYJUbkI/ECwG2D/
 zm+2pXF6YqY7linG2usjJsL54rCG4oPg7vVVa/aaiHAgX2mvalUIKBZa4kc4i82qxCn9
 wseHp8J3YEdb9225Ghe6lnpA4IGcf6n7phzgRkAMHYonIqsjiekq1treeOIsg5bLFDFI
 KkaQ==
X-Gm-Message-State: APjAAAXYPK5/ynoUJlbUqU7hP7/j/PgyYKr0+WZtVENRo/yR9tjlhYen
 h4bnYtVRvPcqD1IpQLLeVtEdQESR9f/6Y9bjaFRsWw==
X-Google-Smtp-Source: APXvYqwe7HUQbxjHZ88C3/yd7hKPs7v0fuapQiwWc6yF6cIi7fKh2+NHXnkd9elywqPPfmZXvk//qq7AcofxgzfIeJsK2w==
X-Received: by 2002:ac8:7502:: with SMTP id u2mr5779140qtq.216.1569021623093; 
 Fri, 20 Sep 2019 16:20:23 -0700 (PDT)
Date: Fri, 20 Sep 2019 16:19:20 -0700
In-Reply-To: <20190920231923.141900-1-brendanhiggins@google.com>
Message-Id: <20190920231923.141900-17-brendanhiggins@google.com>
Mime-Version: 1.0
References: <20190920231923.141900-1-brendanhiggins@google.com>
X-Mailer: git-send-email 2.23.0.351.gc4317032e6-goog
Subject: [PATCH v16 16/19] MAINTAINERS: add entry for KUnit the unit testing
 framework
From: Brendan Higgins <brendanhiggins@google.com>
To: frowand.list@gmail.com, gregkh@linuxfoundation.org, jpoimboe@redhat.com, 
 keescook@google.com, kieran.bingham@ideasonboard.com, mcgrof@kernel.org, 
 peterz@infradead.org, robh@kernel.org, sboyd@kernel.org, shuah@kernel.org, 
 tytso@mit.edu, yamada.masahiro@socionext.com
X-BeenThere: linux-nvdimm@lists.01.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Cc: pmladek@suse.com, linux-doc@vger.kernel.org, amir73il@gmail.com,
 Brendan Higgins <brendanhiggins@google.com>, dri-devel@lists.freedesktop.org,
 Alexander.Levin@microsoft.com, linux-kselftest@vger.kernel.org,
 linux-nvdimm@lists.01.org, khilman@baylibre.com, knut.omang@oracle.com,
 wfg@linux.intel.com, joel@jms.id.au, rientjes@google.com, jdike@addtoit.com,
 dan.carpenter@oracle.com, devicetree@vger.kernel.org,
 linux-kbuild@vger.kernel.org, Tim.Bird@sony.com, linux-um@lists.infradead.org,
 rostedt@goodmis.org, julia.lawall@lip6.fr, kunit-dev@googlegroups.com,
 richard@nod.at, torvalds@linux-foundation.org, rdunlap@infradead.org,
 linux-kernel@vger.kernel.org, daniel@ffwll.ch, mpe@ellerman.id.au,
 linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>

Add myself as maintainer of KUnit, the Linux kernel's unit testing
framework.

Signed-off-by: Brendan Higgins <brendanhiggins@google.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Stephen Boyd <sboyd@kernel.org>
---
 MAINTAINERS | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index a50e97a63bc8..e3d0d184ae4e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8802,6 +8802,17 @@ S:	Maintained
 F:	tools/testing/selftests/
 F:	Documentation/dev-tools/kselftest*
 
+KERNEL UNIT TESTING FRAMEWORK (KUnit)
+M:	Brendan Higgins <brendanhiggins@google.com>
+L:	linux-kselftest@vger.kernel.org
+L:	kunit-dev@googlegroups.com
+W:	https://google.github.io/kunit-docs/third_party/kernel/docs/
+S:	Maintained
+F:	Documentation/dev-tools/kunit/
+F:	include/kunit/
+F:	lib/kunit/
+F:	tools/testing/kunit/
+
 KERNEL USERMODE HELPER
 M:	Luis Chamberlain <mcgrof@kernel.org>
 L:	linux-kernel@vger.kernel.org
-- 
2.23.0.351.gc4317032e6-goog

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
