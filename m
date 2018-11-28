From: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [RFC v3 13/19] kunit: improve output from python wrapper
Date: Wed, 28 Nov 2018 11:36:30 -0800
Message-ID: <20181128193636.254378-14-brendanhiggins@google.com>
References: <20181128193636.254378-1-brendanhiggins@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20181128193636.254378-1-brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
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
Cc: brakmo-b10kYP2dOMg@public.gmane.org, jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, kieran.bingham-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org, Felix Guo <felixguoxiuping-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org, khilman-rdvid1DuHRBWk0Htik3J/w@public.gmane.org, Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tim.Bird-7U/KSKJipcs@public.gmane.org, linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, julia.lawall-L2FTfq7BK8M@public.gmane.org, kunit-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

- add colors to displayed output
- add timing and summary

Signed-off-by: Felix Guo <felixguoxiuping-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 tools/testing/kunit/kunit.py        | 27 ++++++++-
 tools/testing/kunit/kunit_parser.py | 93 ++++++++++++++++++++++++++++-
 2 files changed, 115 insertions(+), 5 deletions(-)

diff --git a/tools/testing/kunit/kunit.py b/tools/testing/kunit/kunit.py
index 1356be404996b..0b8e8c20a746e 100755
--- a/tools/testing/kunit/kunit.py
+++ b/tools/testing/kunit/kunit.py
@@ -6,6 +6,7 @@
 import argparse
 import sys
 import os
+import time
 
 import kunit_config
 import kunit_kernel
@@ -21,20 +22,40 @@ parser.add_argument('--timeout', help='maximum number of seconds to allow for '
 		    'build the tests.', type=int, default=300,
 		    metavar='timeout')
 
+parser.add_argument('--jobs',
+		    help='As in the make command, "Specifies  the number of '
+		    'jobs (commands) to run simultaneously."',
+		    type=int, default=8, metavar='jobs')
+
 cli_args = parser.parse_args()
 linux = kunit_kernel.LinuxSourceTree()
 
+config_start = time.time()
 success = linux.build_reconfig()
+config_end = time.time()
 if not success:
 	quit()
 
-print('Building KUnit Kernel ...')
-success = linux.build_um_kernel()
+kunit_parser.print_with_timestamp('Building KUnit Kernel ...')
+
+build_start = time.time()
+success = linux.build_um_kernel(jobs=cli_args.jobs)
+build_end = time.time()
 if not success:
 	quit()
 
-print('Starting KUnit Kernel ...')
+kunit_parser.print_with_timestamp('Starting KUnit Kernel ...')
+test_start = time.time()
+
 if cli_args.raw_output:
 	kunit_parser.raw_output(linux.run_kernel(timeout=cli_args.timeout))
 else:
 	kunit_parser.parse_run_tests(linux.run_kernel(timeout=cli_args.timeout))
+
+test_end = time.time()
+
+kunit_parser.print_with_timestamp((
+	"Elapsed time: %.3fs total, %.3fs configuring, %.3fs " +
+	"building, %.3fs running.\n") % (test_end - config_start,
+	config_end - config_start, build_end - build_start,
+	test_end - test_start))
diff --git a/tools/testing/kunit/kunit_parser.py b/tools/testing/kunit/kunit_parser.py
index 1dff3adb73bd3..d9051e407d5a7 100644
--- a/tools/testing/kunit/kunit_parser.py
+++ b/tools/testing/kunit/kunit_parser.py
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
 import re
+from datetime import datetime
 
 kunit_start_re = re.compile('console .* enabled')
 kunit_end_re = re.compile('List of all partitions:')
@@ -19,6 +20,94 @@ def raw_output(kernel_output):
 	for line in kernel_output:
 		print(line)
 
+DIVIDER = "=" * 30
+
+RESET = '\033[0;0m'
+
+def red(text):
+	return '\033[1;31m' + text + RESET
+
+def yellow(text):
+	return '\033[1;33m' + text + RESET
+
+def green(text):
+	return '\033[1;32m' + text + RESET
+
+def print_with_timestamp(message):
+	print('[%s] %s' % (datetime.now().strftime('%H:%M:%S'), message))
+
+def print_log(log):
+	for m in log:
+		print_with_timestamp(m)
+
 def parse_run_tests(kernel_output):
-	for output in isolate_kunit_output(kernel_output):
-		print(output)
+	test_case_output = re.compile('^kunit .*?: (.*)$')
+
+	test_module_success = re.compile('^kunit .*: all tests passed')
+	test_module_fail = re.compile('^kunit .*: one or more tests failed')
+
+	test_case_success = re.compile('^kunit (.*): (.*) passed')
+	test_case_fail = re.compile('^kunit (.*): (.*) failed')
+	test_case_crash = re.compile('^kunit (.*): (.*) crashed')
+
+	total_tests = set()
+	failed_tests = set()
+	crashed_tests = set()
+
+	def get_test_name(match):
+		return match.group(1) + ":" + match.group(2)
+
+	current_case_log = []
+	def end_one_test(match, log):
+		log.clear()
+		total_tests.add(get_test_name(match))
+
+	print_with_timestamp(DIVIDER)
+	for line in isolate_kunit_output(kernel_output):
+		# Ignore module output:
+		if (test_module_success.match(line) or
+		    test_module_fail.match(line)):
+			print_with_timestamp(DIVIDER)
+			continue
+
+		match = re.match(test_case_success, line)
+		if match:
+			print_with_timestamp(green("[PASSED] ") +
+					     get_test_name(match))
+			end_one_test(match, current_case_log)
+			continue
+
+		match = re.match(test_case_fail, line)
+		# Crashed tests will report as both failed and crashed. We only
+		# want to show and count it once.
+		if match and get_test_name(match) not in crashed_tests:
+			failed_tests.add(get_test_name(match))
+			print_with_timestamp(red("[FAILED] " +
+						 get_test_name(match)))
+			print_log(map(yellow, current_case_log))
+			print_with_timestamp("")
+			end_one_test(match, current_case_log)
+			continue
+
+		match = re.match(test_case_crash, line)
+		if match:
+			crashed_tests.add(get_test_name(match))
+			print_with_timestamp(yellow("[CRASH] " +
+						    get_test_name(match)))
+			print_log(current_case_log)
+			print_with_timestamp("")
+			end_one_test(match, current_case_log)
+			continue
+
+		# Strip off the `kunit module-name:` prefix
+		match = re.match(test_case_output, line)
+		if match:
+			current_case_log.append(match.group(1))
+		else:
+			current_case_log.append(line)
+
+	fmt = green if (len(failed_tests) + len(crashed_tests) == 0) else red
+	print_with_timestamp(
+		fmt("Testing complete. %d tests run. %d failed. %d crashed." %
+		    (len(total_tests), len(failed_tests), len(crashed_tests))))
+
-- 
2.20.0.rc0.387.gc7a69e6b6c-goog
