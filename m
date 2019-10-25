Return-Path: <SRS0=R6EX=YS=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9144ACA9EA0
	for <linux-nvdimm@archiver.kernel.org>; Fri, 25 Oct 2019 17:55:56 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 59DA621D7F
	for <linux-nvdimm@archiver.kernel.org>; Fri, 25 Oct 2019 17:55:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 59DA621D7F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from new-ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 8C6E4100EEBBA;
	Fri, 25 Oct 2019 10:57:08 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=192.55.52.151; helo=mga17.intel.com; envelope-from=d.scott.phillips@intel.com; receiver=<UNKNOWN> 
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 2D19D100EEBB5
	for <linux-nvdimm@lists.01.org>; Fri, 25 Oct 2019 10:57:06 -0700 (PDT)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Oct 2019 10:55:53 -0700
X-IronPort-AV: E=Sophos;i="5.68,229,1569308400";
   d="scan'208";a="201881012"
Received: from dsp-dsk1.jf.intel.com ([10.54.70.6])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 25 Oct 2019 10:55:53 -0700
From: D Scott Phillips <d.scott.phillips@intel.com>
To: Dan Williams <dan.j.williams@intel.com>,
	David Howells <dhowells@redhat.com>,
	Dexuan Cui <decui@microsoft.com>,
	Jerry Hoemann <jerry.hoemann@hpe.com>,
	stuart hayes <stuart.w.hayes@gmail.com>,
	Toshi Kani <toshi.kani@hpe.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	linux-nvdimm@lists.01.org
Subject: [PATCH] uapi: Add the BSD-2-Clause license to ndctl.h
Date: Fri, 25 Oct 2019 10:55:53 -0700
Message-Id: <20191025175553.63271-1-d.scott.phillips@intel.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Message-ID-Hash: 43QW6AI6ZFU3O72QADQ2TGPLYWA75LJU
X-Message-ID-Hash: 43QW6AI6ZFU3O72QADQ2TGPLYWA75LJU
X-MailFrom: d.scott.phillips@intel.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: linux-kernel@vger.kernel.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/43QW6AI6ZFU3O72QADQ2TGPLYWA75LJU/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Allow ndctl.h to be licensed with BSD-2-Clause so that other
operating systems can provide the same user level interface.
---

I've been working on nvdimm support in FreeBSD and would like to
offer the same ndctl API there to ease porting of application
code. Here I'm proposing to add the BSD-2-Clause license to this
header file, so that it can later be copied into FreeBSD.

I believe that all the authors of changes to this file (in the To:
list) would need to agree to this change before it could be
accepted, so any signed-off-by is intentionally ommited for now.
Thanks,

Scott

 include/uapi/linux/ndctl.h | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/include/uapi/linux/ndctl.h b/include/uapi/linux/ndctl.h
index de5d90212409..dd9718bc9401 100644
--- a/include/uapi/linux/ndctl.h
+++ b/include/uapi/linux/ndctl.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: ((LGPL-2.1 WITH Linux-syscall-note) OR BSD-2-Clause) */
 /*
  * Copyright (c) 2014-2016, Intel Corporation.
  *
@@ -9,6 +10,32 @@
  * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
  * FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for
  * more details.
+ *
+ * This -- and only this -- header file may also be distributed under
+ * the terms of the BSD Licence as follows:
+ *
+ * Copyright (C) 2014-2016, Intel Corporation.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY AUTHOR AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL AUTHOR OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE.
  */
 #ifndef __NDCTL_H__
 #define __NDCTL_H__
-- 
2.23.0
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
