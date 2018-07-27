Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8D8C1210C2D6E
 for <linux-nvdimm@lists.01.org>; Fri, 27 Jul 2018 11:30:54 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] ndctl: deprecate undocumented short-options
Date: Fri, 27 Jul 2018 12:30:50 -0600
Message-Id: <20180727183050.13047-1-vishal.l.verma@intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

The inject-smart and monitor man pages refrained from displaying short
options for various arguments (alarms, daemon) due to a lack of a coherent
letter that could be made to relate to the event name. It was expected
that the user will always use the long option for these. Since the
OPT_STRING helper refused to take an empty string for the short option,
we used bogus characters for each of them.

However there is a better way to provide no short options, and that is
by using '\0' for the short option field to OPT_STRING. Replace the
bogus characters with '\0' so that the 'short help' also becomes
consistent with the man pages.

Cc: Cc: QI Fuli <qi.fuli@jp.fujitsu.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/inject-smart.c | 7 ++++---
 ndctl/monitor.c      | 2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/ndctl/inject-smart.c b/ndctl/inject-smart.c
index 006ea2a..edb87e1 100644
--- a/ndctl/inject-smart.c
+++ b/ndctl/inject-smart.c
@@ -73,7 +73,7 @@ OPT_STRING('M', "media-temperature-threshold", \
 	&param.media_temperature_threshold, \
 	"set smart media temperature threshold", \
 	"set threshold value for smart media temperature"), \
-OPT_STRING('x', "media-temperature-alarm", &param.media_temperature_alarm, \
+OPT_STRING('\0', "media-temperature-alarm", &param.media_temperature_alarm, \
 	"smart media temperature alarm", \
 	"enable or disable the smart media temperature alarm"), \
 OPT_STRING('c', "ctrl-temperature", &param.ctrl_temperature, \
@@ -83,7 +83,7 @@ OPT_STRING('C', "ctrl-temperature-threshold", \
 	&param.ctrl_temperature_threshold, \
 	"set smart controller temperature threshold", \
 	"set threshold value for smart controller temperature"), \
-OPT_STRING('y', "ctrl-temperature-alarm", &param.ctrl_temperature_alarm, \
+OPT_STRING('\0', "ctrl-temperature-alarm", &param.ctrl_temperature_alarm, \
 	"smart controller temperature alarm", \
 	"enable or disable the smart controller temperature alarm"), \
 OPT_STRING('s', "spares", &param.spares, \
@@ -92,13 +92,14 @@ OPT_STRING('s', "spares", &param.spares, \
 OPT_STRING('S', "spares-threshold", &param.spares_threshold, \
 	"set smart spares threshold", \
 	"set a threshold value for smart spares"), \
-OPT_STRING('z', "spares-alarm", &param.spares_alarm, \
+OPT_STRING('\0', "spares-alarm", &param.spares_alarm, \
 	"smart spares alarm", \
 	"enable or disable the smart spares alarm"), \
 OPT_BOOLEAN('f', "fatal", &param.fatal, "inject fatal smart health status"), \
 OPT_BOOLEAN('U', "unsafe-shutdown", &param.unsafe_shutdown, \
 	"inject smart unsafe shutdown status")
 
+
 static const struct option smart_opts[] = {
 	SMART_OPTIONS(),
 	OPT_END(),
diff --git a/ndctl/monitor.c b/ndctl/monitor.c
index b97d1ea..c6419ad 100644
--- a/ndctl/monitor.c
+++ b/ndctl/monitor.c
@@ -583,7 +583,7 @@ int cmd_monitor(int argc, const char **argv, void *ctx)
 				"where to output the monitor's notification"),
 		OPT_FILENAME('c', "config-file", &monitor.config_file,
 				"config-file", "override the default config"),
-		OPT_BOOLEAN('x', "daemon", &monitor.daemon,
+		OPT_BOOLEAN('\0', "daemon", &monitor.daemon,
 				"run ndctl monitor as a daemon"),
 		OPT_BOOLEAN('u', "human", &monitor.human,
 				"use human friendly output formats"),
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
