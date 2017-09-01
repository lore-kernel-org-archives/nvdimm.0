Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm04.jp.fujitsu.com (mgwkm04.jp.fujitsu.com [202.219.69.171])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1DD5F21E70D2F
 for <linux-nvdimm@lists.01.org>; Thu, 31 Aug 2017 18:45:10 -0700 (PDT)
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local
 (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
 by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 96714AC00DB
 for <linux-nvdimm@lists.01.org>; Fri,  1 Sep 2017 10:47:49 +0900 (JST)
Received: from G01JPEXCHKW17.g01.fujitsu.local
 (G01JPEXCHKW17.g01.fujitsu.local [10.0.194.56])
 by g01jpfmpwkw01.exch.g01.fujitsu.local (Postfix) with ESMTP id D34DB692767
 for <linux-nvdimm@lists.01.org>; Fri,  1 Sep 2017 10:47:48 +0900 (JST)
From: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Subject: [RFC patch 3/4]ndctl: nvdimmd: notify/monitor the feathers of over
 threshold event
Date: Fri, 1 Sep 2017 01:47:47 +0000
Message-ID: <0DEDF3B159719A448A49EF0E7B11E3222756C910@g01jpexmbkw01>
Content-Language: ja-JP
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
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Nvdimmd.service is the unit file of systemd for nvdimmd service.

Sign-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>

---
nvdimmd/Makefile        | 4 ++++
nvdimmd/nvdimmd.service | 7 +++++++
2 files changed, 11 insertions(+)
diff --git a/nvdimmd/Makefile b/nvdimmd/Makefile
index 3908e5d..df7eb46 100644
--- a/nvdimmd/Makefile
+++ b/nvdimmd/Makefile
@@ -1,5 +1,6 @@
 CC		= gcc
 LIBS		= -ludev -luuid -lkmod
+DEST		= /usr/bin
 OBJS		= ../ndctl/lib/.libs/libndctl.o ../daxctl/lib/.libs/libdaxctl.o ../util/.libs/sysfs.o ../util/.libs/log.o ../ndctl/lib/.libs/libndctl-smart.o
 IDIR		= -I../ -I../ndctl
 PROGRAM	= nvdimmd
@@ -11,5 +12,8 @@ libnvdimmd.o:	libnvdimmd.c
 			$(CC) -o libnvdimmd.o $(IDIR) -c libnvdimmd.c
 nvdimmd.o:	nvdimmd.c
 			$(CC) -o nvdimmd.o $(IDIR) -c nvdimmd.c
+install:	nvdimmd nvdimmd.service
+			install -s nvdimmd $(DEST)
+			cp nvdimmd.service /usr/lib/systemd/system/
 clean:
 			rm -rf *.o $(PROGRAM)
diff --git a/nvdimmd/nvdimmd.service b/nvdimmd/nvdimmd.service
new file mode 100644
index 0000000..0b96aaa
--- /dev/null
+++ b/nvdimmd/nvdimmd.service
@@ -0,0 +1,7 @@
+[Unit]
+Description=Nvdimm Daemon
+
+[Service]
+Type=forking
+ExecStart=/usr/bin/nvdimmd
+ExecStop=/usr/bin/kill ${MAINPID}

--
QI Fuli <qi.fuli@jp.fujitsu.com>


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
