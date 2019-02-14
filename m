Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com
 [148.163.147.86])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 13EE920886F29
 for <linux-nvdimm@lists.01.org>; Thu, 14 Feb 2019 08:28:59 -0800 (PST)
Received: from pps.filterd (m0150241.ppops.net [127.0.0.1])
 by mx0a-002e3701.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id
 x1EGCqGZ007131
 for <linux-nvdimm@lists.01.org>; Thu, 14 Feb 2019 16:28:58 GMT
Received: from g4t3425.houston.hpe.com (g4t3425.houston.hpe.com
 [15.241.140.78])
 by mx0a-002e3701.pphosted.com with ESMTP id 2qnbg0889j-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Thu, 14 Feb 2019 16:28:58 +0000
Received: from g9t2301.houston.hpecorp.net (g9t2301.houston.hpecorp.net
 [16.220.97.129])
 by g4t3425.houston.hpe.com (Postfix) with ESMTP id 3E7D2AC
 for <linux-nvdimm@lists.01.org>; Thu, 14 Feb 2019 16:28:57 +0000 (UTC)
From: Robert Elliott <elliott@hpe.com>
Subject: [ndctl PATCH 2/2] autoconf: print more possible package names for
 keyutils.h
Date: Thu, 14 Feb 2019 10:34:22 -0600
Message-Id: <20190214163422.15221-2-elliott@hpe.com>
In-Reply-To: <20190214163422.15221-1-elliott@hpe.com>
References: <20190214163422.15221-1-elliott@hpe.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

The distro package names providing keyutils.h are inconsistent, so
print more than just one suggestion:
    keyutils-libs-devel (Red Hat)
    keyutils-devel (SUSE)
    libkeyutils-dev (Ubuntu)

Fixes: 86b078b44275 ("ndctl: add passphrase management commands")
Signed-off-by: Robert Elliott <elliott@hpe.com>
---
 configure.ac | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/configure.ac b/configure.ac
index efbdcde..6c26934 100644
--- a/configure.ac
+++ b/configure.ac
@@ -171,8 +171,7 @@ AC_ARG_WITH([keyutils],
 
 if test "x$with_keyutils" = "xyes"; then
 	AC_CHECK_HEADERS([keyutils.h],,[
-		AC_MSG_ERROR([keyutils.h not found, consider installing
-			      keyutils-libs-devel.])
+		AC_MSG_ERROR([keyutils.h not found, consider installing the keyutils library development package (variously named keyutils-libs-devel, keyutils-devel, or libkeyutils-dev).])
 		])
 fi
 AS_IF([test "x$with_keyutils" = "xyes"],
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
