Received: from esa12.hc1455-7.c3s2.iphmx.com (esa12.hc1455-7.c3s2.iphmx.com [139.138.37.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 870F51774C
	for <nvdimm@lists.linux.dev>; Thu, 11 May 2023 07:38:22 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="95802003"
X-IronPort-AV: E=Sophos;i="5.99,266,1677510000"; 
   d="scan'208";a="95802003"
Received: from unknown (HELO oym-r1.gw.nic.fujitsu.com) ([210.162.30.89])
  by esa12.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 16:37:10 +0900
Received: from oym-m1.gw.nic.fujitsu.com (oym-nat-oym-m1.gw.nic.fujitsu.com [192.168.87.58])
	by oym-r1.gw.nic.fujitsu.com (Postfix) with ESMTP id DA151C1484
	for <nvdimm@lists.linux.dev>; Thu, 11 May 2023 16:37:08 +0900 (JST)
Received: from kws-ab2.gw.nic.fujitsu.com (kws-ab2.gw.nic.fujitsu.com [192.51.206.12])
	by oym-m1.gw.nic.fujitsu.com (Postfix) with ESMTP id 0B0961570C
	for <nvdimm@lists.linux.dev>; Thu, 11 May 2023 16:37:08 +0900 (JST)
Received: from localhost.localdomain (unknown [10.167.226.45])
	by kws-ab2.gw.nic.fujitsu.com (Postfix) with ESMTP id 356BC23406AA;
	Thu, 11 May 2023 16:37:07 +0900 (JST)
From: Li Zhijian <lizhijian@fujitsu.com>
To: nvdimm@lists.linux.dev
Cc: Li Zhijian <lizhijian@fujitsu.com>
Subject: [ndctl PATCH] rpmbuild.sh: Abort script when an error occurs
Date: Thu, 11 May 2023 15:36:57 +0800
Message-Id: <20230511073657.706429-1-lizhijian@fujitsu.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1408-9.0.0.1002-27618.006
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1408-9.0.1002-27618.006
X-TMASE-Result: 10--3.112100-10.000000
X-TMASE-MatchedRID: w/VW/btTjlMdKunVoZzJfxlxrtI3TxRkltF+xW+zhUjMB0kPsl40w8YH
	4yY++5KbKqrQ7lLcMnyREZKGpLMFWS/7QU2czuUNfOaYwP8dcX4Z9kiZvd+oBFQuGn5b9r2ZGuZ
	6ecEUKf3i8zVgXoAltsYlDcGKIsCCC24oEZ6SpSmcfuxsiY4QFKUE62PDBEOUOgdlHLkT2kUM5G
	/jExC4iaOkSsepCmPuWuHRfVDnK67vq5uAyLZAOJzibi28ID28jOMKzCDqObAO6UbIpXfCtJsNE
	GpLafrrLM/nEDLP056e+TDiyH/49wxfkLAfkNNSaAZk0sEcY14=
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

Abort early so that the real error message can be noticed easily.
==========================
$ ./rpmbuild.sh
Found CMake: /usr/bin/cmake (3.18.4)
Run-time dependency libtraceevent found: NO (tried pkgconfig and cmake)

../meson.build:147:2: ERROR: Dependency "libtraceevent" not found, tried pkgconfig and cmake

A full log can be found at /path/to/ndctl/build/meson-logs/meson-log.txt
FAILED: build.ninja
...

Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
---
 rpmbuild.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rpmbuild.sh b/rpmbuild.sh
index d9823e5eda61..d952f96aa8c1 100755
--- a/rpmbuild.sh
+++ b/rpmbuild.sh
@@ -10,7 +10,7 @@ if ./git-version | grep -q dirty; then
 	exit 1
 fi
 if [ ! -f $spec ]; then
-	meson compile -C build rhel/ndctl.spec
+	meson compile -C build rhel/ndctl.spec || exit
 	spec=$(dirname $0)/build/rhel/ndctl.spec
 fi
 ./make-git-snapshot.sh
-- 
2.29.2

