Received: from esa4.hc1455-7.c3s2.iphmx.com (esa4.hc1455-7.c3s2.iphmx.com [68.232.139.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B4757461
	for <nvdimm@lists.linux.dev>; Fri, 12 May 2023 08:12:15 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="116428798"
X-IronPort-AV: E=Sophos;i="5.99,269,1677510000"; 
   d="scan'208";a="116428798"
Received: from unknown (HELO yto-r2.gw.nic.fujitsu.com) ([218.44.52.218])
  by esa4.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2023 17:11:05 +0900
Received: from yto-m4.gw.nic.fujitsu.com (yto-nat-yto-m4.gw.nic.fujitsu.com [192.168.83.67])
	by yto-r2.gw.nic.fujitsu.com (Postfix) with ESMTP id 0F787DE50D
	for <nvdimm@lists.linux.dev>; Fri, 12 May 2023 17:11:02 +0900 (JST)
Received: from kws-ab2.gw.nic.fujitsu.com (kws-ab2.gw.nic.fujitsu.com [192.51.206.12])
	by yto-m4.gw.nic.fujitsu.com (Postfix) with ESMTP id 5829AD3F03
	for <nvdimm@lists.linux.dev>; Fri, 12 May 2023 17:11:01 +0900 (JST)
Received: from localhost.localdomain (unknown [10.167.226.45])
	by kws-ab2.gw.nic.fujitsu.com (Postfix) with ESMTP id 6E41723409E4;
	Fri, 12 May 2023 17:11:00 +0900 (JST)
From: Li Zhijian <lizhijian@fujitsu.com>
To: nvdimm@lists.linux.dev
Cc: Li Zhijian <lizhijian@fujitsu.com>
Subject: [ndctl PATCH] meson.build: add libtracefs version >=1.2.0 dependency
Date: Fri, 12 May 2023 16:10:26 +0800
Message-Id: <20230512081026.735459-1-lizhijian@fujitsu.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1408-9.0.0.1002-27620.005
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1408-9.0.1002-27620.005
X-TMASE-Result: 10--1.577200-10.000000
X-TMASE-MatchedRID: a4Q7dosAlP4sn4hNIyLkvtMJkd+MUUHPDAyo2i9/A6giB3Nk/d/KP4tU
	W2TdSbkoIvrftAIhWmJQSXzTnhrdGHeeA+rySyNtfOaYwP8dcX59LQinZ4QefCP/VFuTOXUTae6
	hIZpj4MuOhzOa6g8KrR6RZML74K+LbM/5Mzx1TetBA++9372rIAHFTcGO5eXZxUXZ+N1rJUh9PD
	69q1zXjGvIb6cjGBX3lDpNRJjUaz1B+ibYcc4XGhXBt/mUREyAj/ZFF9Wfm7hNy7ppG0IjcFQqk
	0j7vLVUewMSBDreIdk=
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

Compile with libtracefs < 1.2.0(1.0.2 in Fedora33) will get errors:

/usr/bin/ld: cxl/cxl.p/event_trace.c.o: in function `cxl_event_tracing_enable':
/path/to/ndctl/build/../cxl/event_trace.c:238: undefined reference to `tracefs_event_enable'
/usr/bin/ld: /path/to/ndctl/build/../cxl/event_trace.c:242: undefined reference to `tracefs_trace_is_on'
/usr/bin/ld: /path/to/ndctl/build/../cxl/event_trace.c:245: undefined reference to `tracefs_trace_on'
/usr/bin/ld: cxl/cxl.p/event_trace.c.o: in function `cxl_event_tracing_disable':
/path/to/ndctl/build/../cxl/event_trace.c:251: undefined reference to `tracefs_trace_off'
/usr/bin/ld: cxl/cxl.p/monitor.c.o: in function `monitor_event':
/path/to/ndctl/build/../cxl/monitor.c:74: undefined reference to `tracefs_instance_file_open'

Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
---
 meson.build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/meson.build b/meson.build
index 50e83cf770a2..50cb4800ab9b 100644
--- a/meson.build
+++ b/meson.build
@@ -145,7 +145,7 @@ uuid = dependency('uuid')
 json = dependency('json-c')
 if get_option('libtracefs').enabled()
   traceevent = dependency('libtraceevent')
-  tracefs = dependency('libtracefs')
+  tracefs = dependency('libtracefs', version : '>=1.2.0')
 endif
 
 if get_option('docs').enabled()
-- 
2.29.2

