From: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [RFC v2 11/14] kunit: add KUnit wrapper script and simple output
 parser
Date: Tue, 23 Oct 2018 16:57:47 -0700
Message-ID: <20181023235750.103146-12-brendanhiggins@google.com>
References: <20181023235750.103146-1-brendanhiggins@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20181023235750.103146-1-brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, keescook-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: brakmo-b10kYP2dOMg@public.gmane.org, jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, kieran.bingham-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org, Felix Guo <felixguoxiuping-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org, khilman-rdvid1DuHRBWk0Htik3J/w@public.gmane.org, Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tim.Bird-7U/KSKJipcs@public.gmane.org, linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, julia.lawall-L2FTfq7BK8M@public.gmane.org, kunit-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

The KUnit wrapper script interfaces with the two modules
(kunit_config.py and kunit_kernel.py) and provides a command line
interface for running KUnit tests. This interface allows the caller to
specify options like test timeouts. The script handles configuring,
building and running the kernel and tests.

The output parser (kunit_parser.py) simply strips out all the output
from the kernel that is outputted as part of it's initialization
sequence. This ensures that only the output from KUnit is displayed
on the screen.

A full version of the output is written to test.log, or can be seen by
passing --raw_output to the wrapper script.

Signed-off-by: Felix Guo <felixguoxiuping-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 tools/testing/kunit/kunit.py        | 40 +++++++++++++++++++++++++++++
 tools/testing/kunit/kunit_kernel.py |  3 +--
 tools/testing/kunit/kunit_parser.py | 24 +++++++++++++++++
 3 files changed, 65 insertions(+), 2 deletions(-)
 create mode 100755 tools/testing/kunit/kunit.py
 create mode 100644 tools/testing/kunit/kunit_parser.py

diff --git a/tools/testing/kunit/kunit.py b/tools/testing/kunit/kunit.py
new file mode 100755
index 0000000000000..1356be404996b
--- /dev/null
+++ b/tools/testing/kunit/kunit.py
@@ -0,0 +1,40 @@
+#!/usr/bin/python3
+# SPDX-License-Identifier: GPL-2.0
+
+# A thin wrapper on top of the KUnit Kernel
+
+import argparse
+import sys
+import os
+
+import kunit_config
+import kunit_kernel
+import kunit_parser
+
+parser = argparse.ArgumentParser(description='Runs KUnit tests.')
+
+parser.add_argument('--raw_output', help='don\'t format output from kernel',
+		    action='store_true')
+
+parser.add_argument('--timeout', help='maximum number of seconds to allow for '
+		    'all tests to run. This does not include time taken to '
+		    'build the tests.', type=int, default=300,
+		    metavar='timeout')
+
+cli_args = parser.parse_args()
+linux = kunit_kernel.LinuxSourceTree()
+
+success = linux.build_reconfig()
+if not success:
+	quit()
+
+print('Building KUnit Kernel ...')
+success = linux.build_um_kernel()
+if not success:
+	quit()
+
+print('Starting KUnit Kernel ...')
+if cli_args.raw_output:
+	kunit_parser.raw_output(linux.run_kernel(timeout=cli_args.timeout))
+else:
+	kunit_parser.parse_run_tests(linux.run_kernel(timeout=cli_args.timeout))
diff --git a/tools/testing/kunit/kunit_kernel.py b/tools/testing/kunit/kunit_kernel.py
index 87abaede50513..c1259b174f7d4 100644
--- a/tools/testing/kunit/kunit_kernel.py
+++ b/tools/testing/kunit/kunit_kernel.py
@@ -113,8 +113,7 @@ class LinuxSourceTree(object):
 			return False
 		return True
 
-	def run_kernel(self, args=[]):
-		timeout = None
+	def run_kernel(self, args=[], timeout=None):
 		args.extend(['mem=256M'])
 		process = self._ops.linux_bin(args, timeout)
 		with open('test.log', 'w') as f:
diff --git a/tools/testing/kunit/kunit_parser.py b/tools/testing/kunit/kunit_parser.py
new file mode 100644
index 0000000000000..1dff3adb73bd3
--- /dev/null
+++ b/tools/testing/kunit/kunit_parser.py
@@ -0,0 +1,24 @@
+# SPDX-License-Identifier: GPL-2.0
+
+import re
+
+kunit_start_re = re.compile('console .* enabled')
+kunit_end_re = re.compile('List of all partitions:')
+
+def isolate_kunit_output(kernel_output):
+	started = False
+	for line in kernel_output:
+		if kunit_start_re.match(line):
+			started = True
+		elif kunit_end_re.match(line):
+			break
+		elif started:
+			yield line
+
+def raw_output(kernel_output):
+	for line in kernel_output:
+		print(line)
+
+def parse_run_tests(kernel_output):
+	for output in isolate_kunit_output(kernel_output):
+		print(output)
-- 
2.19.1.568.g152ad8e336-goog
