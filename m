From: Brendan Higgins <brendanhiggins@google.com>
Subject: [RFC v3 16/19] arch: um: make UML unflatten device tree when testing
Date: Wed, 28 Nov 2018 11:36:33 -0800
Message-ID: <20181128193636.254378-17-brendanhiggins@google.com>
References: <20181128193636.254378-1-brendanhiggins@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181128193636.254378-1-brendanhiggins@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, keescook@google.com, mcgrof@kernel.org, shuah@kernel.org
Cc: joel@jms.id.au, mpe@ellerman.id.au, joe@perches.com, brakmo@fb.com, rostedt@goodmis.org, Tim.Bird@sony.com, khilman@baylibre.com, julia.lawall@lip6.fr, linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, linux-kernel@vger.kernel.org, jdike@addtoit.com, richard@nod.at, linux-um@lists.infradead.org, daniel@ffwll.ch, dri-devel@lists.freedesktop.org, robh@kernel.org, dan.j.williams@intel.com, linux-nvdimm@lists.01.org, kieran.bingham@ideasonboard.com, frowand.list@gmail.com, knut.omang@oracle.com, Brendan Higgins <brendanhiggins@google.com>
List-Id: linux-nvdimm@lists.01.org

Make UML unflatten any present device trees when running KUnit tests.

Signed-off-by: Brendan Higgins <brendanhiggins@google.com>
---
 arch/um/kernel/um_arch.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/um/kernel/um_arch.c b/arch/um/kernel/um_arch.c
index a818ccef30ca2..bd58ae3bf4148 100644
--- a/arch/um/kernel/um_arch.c
+++ b/arch/um/kernel/um_arch.c
@@ -13,6 +13,7 @@
 #include <linux/sched.h>
 #include <linux/sched/task.h>
 #include <linux/kmsg_dump.h>
+#include <linux/of_fdt.h>
 
 #include <asm/pgtable.h>
 #include <asm/processor.h>
@@ -347,6 +348,9 @@ void __init setup_arch(char **cmdline_p)
 	read_initrd();
 
 	paging_init();
+#if IS_ENABLED(CONFIG_OF_UNITTEST)
+	unflatten_device_tree();
+#endif
 	strlcpy(boot_command_line, command_line, COMMAND_LINE_SIZE);
 	*cmdline_p = command_line;
 	setup_hostinfo(host_info, sizeof host_info);
-- 
2.20.0.rc0.387.gc7a69e6b6c-goog
