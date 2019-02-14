From: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [RFC v4 11/17] kunit: tool: add Python wrappers for running KUnit
 tests
Date: Thu, 14 Feb 2019 13:37:23 -0800
Message-ID: <20190214213729.21702-12-brendanhiggins@google.com>
References: <20190214213729.21702-1-brendanhiggins@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20190214213729.21702-1-brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: keescook-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kieran.bingham-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org, frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: brakmo-b10kYP2dOMg@public.gmane.org, pmladek-IBi9RG/b67k@public.gmane.org, amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Alexander.Levin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Felix Guo <felixguoxiuping-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, wfg-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org, jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tim.Bird-7U/KSKJipcs@public.gmane.org, linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, julia.lawall-L2FTfq7BK8M@public.gmane.org, kunit-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org, khilman-rdvid1DuHRBWk0Htik3J/w@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

From: Felix Guo <felixguoxiuping-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

The ultimate goal is to create minimal isolated test binaries; in the
meantime we are using UML to provide the infrastructure to run tests, so
define an abstract way to configure and run tests that allow us to
change the context in which tests are built without affecting the user.
This also makes pretty and dynamic error reporting, and a lot of other
nice features easier.

kunit_config.py:
  - parse .config and Kconfig files.

kunit_kernel.py: provides helper functions to:
  - configure the kernel using kunitconfig.
  - build the kernel with the appropriate configuration.
  - provide function to invoke the kernel and stream the output back.

Signed-off-by: Felix Guo <felixguoxiuping-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
Changes Since Last Version
 - Added support for building and running tests in an external
   directory.
 - Squashed with most other kunit_tool commits, since most did not
   represent a coherent new feature.
---
 tools/testing/kunit/.gitignore      |   3 +
 tools/testing/kunit/kunit.py        |  78 +++++++++++++++
 tools/testing/kunit/kunit_config.py |  66 +++++++++++++
 tools/testing/kunit/kunit_kernel.py | 148 ++++++++++++++++++++++++++++
 tools/testing/kunit/kunit_parser.py | 119 ++++++++++++++++++++++
 5 files changed, 414 insertions(+)
 create mode 100644 tools/testing/kunit/.gitignore
 create mode 100755 tools/testing/kunit/kunit.py
 create mode 100644 tools/testing/kunit/kunit_config.py
 create mode 100644 tools/testing/kunit/kunit_kernel.py
 create mode 100644 tools/testing/kunit/kunit_parser.py

diff --git a/tools/testing/kunit/.gitignore b/tools/testing/kunit/.gitignore
new file mode 100644
index 0000000000000..c791ff59a37a9
--- /dev/null
+++ b/tools/testing/kunit/.gitignore
@@ -0,0 +1,3 @@
+# Byte-compiled / optimized / DLL files
+__pycache__/
+*.py[cod]
\ No newline at end of file
diff --git a/tools/testing/kunit/kunit.py b/tools/testing/kunit/kunit.py
new file mode 100755
index 0000000000000..7413ec7351a20
--- /dev/null
+++ b/tools/testing/kunit/kunit.py
@@ -0,0 +1,78 @@
+#!/usr/bin/python3
+# SPDX-License-Identifier: GPL-2.0
+#
+# A thin wrapper on top of the KUnit Kernel
+#
+# Copyright (C) 2019, Google LLC.
+# Author: Felix Guo <felixguoxiuping-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
+# Author: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
+
+import argparse
+import sys
+import os
+import time
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
+parser.add_argument('--jobs',
+		    help='As in the make command, "Specifies  the number of '
+		    'jobs (commands) to run simultaneously."',
+		    type=int, default=8, metavar='jobs')
+
+parser.add_argument('--build_dir',
+		    help='As in the make command, it specifies the build '
+		    'directory.',
+		    type=str, default=None, metavar='build_dir')
+
+cli_args = parser.parse_args()
+
+linux = kunit_kernel.LinuxSourceTree()
+
+build_dir = None
+if cli_args.build_dir:
+	build_dir = cli_args.build_dir
+
+config_start = time.time()
+success = linux.build_reconfig(build_dir)
+config_end = time.time()
+if not success:
+	quit()
+
+kunit_parser.print_with_timestamp('Building KUnit Kernel ...')
+
+build_start = time.time()
+
+success = linux.build_um_kernel(jobs=cli_args.jobs, build_dir=build_dir)
+build_end = time.time()
+if not success:
+	quit()
+
+kunit_parser.print_with_timestamp('Starting KUnit Kernel ...')
+test_start = time.time()
+
+if cli_args.raw_output:
+	kunit_parser.raw_output(linux.run_kernel(timeout=cli_args.timeout,
+						 build_dir=build_dir))
+else:
+	kunit_parser.parse_run_tests(linux.run_kernel(timeout=cli_args.timeout,
+						      build_dir=build_dir))
+
+test_end = time.time()
+
+kunit_parser.print_with_timestamp((
+	"Elapsed time: %.3fs total, %.3fs configuring, %.3fs " +
+	"building, %.3fs running.\n") % (test_end - config_start,
+	config_end - config_start, build_end - build_start,
+	test_end - test_start))
diff --git a/tools/testing/kunit/kunit_config.py b/tools/testing/kunit/kunit_config.py
new file mode 100644
index 0000000000000..167f47d9ab8e4
--- /dev/null
+++ b/tools/testing/kunit/kunit_config.py
@@ -0,0 +1,66 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Builds a .config from a kunitconfig.
+#
+# Copyright (C) 2019, Google LLC.
+# Author: Felix Guo <felixguoxiuping-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
+# Author: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
+
+import collections
+import re
+
+CONFIG_IS_NOT_SET_PATTERN = r'^# CONFIG_\w+ is not set$'
+CONFIG_PATTERN = r'^CONFIG_\w+=\S+$'
+
+KconfigEntryBase = collections.namedtuple('KconfigEntry', ['raw_entry'])
+
+
+class KconfigEntry(KconfigEntryBase):
+
+	def __str__(self) -> str:
+		return self.raw_entry
+
+
+class KconfigParseError(Exception):
+	"""Error parsing Kconfig defconfig or .config."""
+
+
+class Kconfig(object):
+	"""Represents defconfig or .config specified using the Kconfig language."""
+
+	def __init__(self):
+		self._entries = []
+
+	def entries(self):
+		return set(self._entries)
+
+	def add_entry(self, entry: KconfigEntry) -> None:
+		self._entries.append(entry)
+
+	def is_subset_of(self, other: "Kconfig") -> bool:
+		return self.entries().issubset(other.entries())
+
+	def write_to_file(self, path: str) -> None:
+		with open(path, 'w') as f:
+			for entry in self.entries():
+				f.write(str(entry) + '\n')
+
+	def parse_from_string(self, blob: str) -> None:
+		"""Parses a string containing KconfigEntrys and populates this Kconfig."""
+		self._entries = []
+		is_not_set_matcher = re.compile(CONFIG_IS_NOT_SET_PATTERN)
+		config_matcher = re.compile(CONFIG_PATTERN)
+		for line in blob.split('\n'):
+			line = line.strip()
+			if not line:
+				continue
+			elif config_matcher.match(line) or is_not_set_matcher.match(line):
+				self._entries.append(KconfigEntry(line))
+			elif line[0] == '#':
+				continue
+			else:
+				raise KconfigParseError('Failed to parse: ' + line)
+
+	def read_from_file(self, path: str) -> None:
+		with open(path, 'r') as f:
+			self.parse_from_string(f.read())
diff --git a/tools/testing/kunit/kunit_kernel.py b/tools/testing/kunit/kunit_kernel.py
new file mode 100644
index 0000000000000..07c0abf2f47df
--- /dev/null
+++ b/tools/testing/kunit/kunit_kernel.py
@@ -0,0 +1,148 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Runs UML kernel, collects output, and handles errors.
+#
+# Copyright (C) 2019, Google LLC.
+# Author: Felix Guo <felixguoxiuping-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
+# Author: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
+
+
+import logging
+import subprocess
+import os
+
+import kunit_config
+
+KCONFIG_PATH = '.config'
+
+class ConfigError(Exception):
+	"""Represents an error trying to configure the Linux kernel."""
+
+
+class BuildError(Exception):
+	"""Represents an error trying to build the Linux kernel."""
+
+
+class LinuxSourceTreeOperations(object):
+	"""An abstraction over command line operations performed on a source tree."""
+
+	def make_mrproper(self):
+		try:
+			subprocess.check_output(['make', 'mrproper'])
+		except OSError as e:
+			raise ConfigError('Could not call make command: ' + e)
+		except subprocess.CalledProcessError as e:
+			raise ConfigError(e.output)
+
+	def make_olddefconfig(self, build_dir):
+		command = ['make', 'ARCH=um', 'olddefconfig']
+		if build_dir:
+			command += ['O=' + build_dir]
+		try:
+			subprocess.check_output(command)
+		except OSError as e:
+			raise ConfigError('Could not call make command: ' + e)
+		except subprocess.CalledProcessError as e:
+			raise ConfigError(e.output)
+
+	def make(self, jobs, build_dir):
+		command = ['make', 'ARCH=um', '--jobs=' + str(jobs)]
+		if build_dir:
+			command += ['O=' + build_dir]
+		try:
+			subprocess.check_output(command)
+		except OSError as e:
+			raise BuildError('Could not call execute make: ' + e)
+		except subprocess.CalledProcessError as e:
+			raise BuildError(e.output)
+
+	def linux_bin(self, params, timeout, build_dir):
+		"""Runs the Linux UML binary. Must be named 'linux'."""
+		linux_bin = './linux'
+		if build_dir:
+			linux_bin = os.path.join(build_dir, 'linux')
+		process = subprocess.Popen(
+			[linux_bin] + params,
+			stdin=subprocess.PIPE,
+			stdout=subprocess.PIPE,
+			stderr=subprocess.PIPE)
+		process.wait(timeout=timeout)
+		return process
+
+
+def get_kconfig_path(build_dir):
+	kconfig_path = KCONFIG_PATH
+	if build_dir:
+		kconfig_path = os.path.join(build_dir, KCONFIG_PATH)
+	return kconfig_path
+
+class LinuxSourceTree(object):
+	"""Represents a Linux kernel source tree with KUnit tests."""
+
+	def __init__(self):
+		self._kconfig = kunit_config.Kconfig()
+		self._kconfig.read_from_file('kunitconfig')
+		self._ops = LinuxSourceTreeOperations()
+
+	def clean(self):
+		try:
+			self._ops.make_mrproper()
+		except ConfigError as e:
+			logging.error(e)
+			return False
+		return True
+
+	def build_config(self, build_dir):
+		kconfig_path = get_kconfig_path(build_dir)
+		if build_dir and not os.path.exists(build_dir):
+			os.mkdir(build_dir)
+		self._kconfig.write_to_file(kconfig_path)
+		try:
+			self._ops.make_olddefconfig(build_dir)
+		except ConfigError as e:
+			logging.error(e)
+			return False
+		validated_kconfig = kunit_config.Kconfig()
+		validated_kconfig.read_from_file(kconfig_path)
+		if not self._kconfig.is_subset_of(validated_kconfig):
+			logging.error('Provided Kconfig is not contained in validated .config!')
+			return False
+		return True
+
+	def build_reconfig(self, build_dir):
+		"""Creates a new .config if it is not a subset of the kunitconfig."""
+		kconfig_path = get_kconfig_path(build_dir)
+		if os.path.exists(kconfig_path):
+			existing_kconfig = kunit_config.Kconfig()
+			existing_kconfig.read_from_file(kconfig_path)
+			if not self._kconfig.is_subset_of(existing_kconfig):
+				print('Regenerating .config ...')
+				os.remove(kconfig_path)
+				return self.build_config(build_dir)
+			else:
+				return True
+		else:
+			print('Generating .config ...')
+			return self.build_config(build_dir)
+
+	def build_um_kernel(self, jobs, build_dir):
+		try:
+			self._ops.make_olddefconfig(build_dir)
+			self._ops.make(jobs, build_dir)
+		except (ConfigError, BuildError) as e:
+			logging.error(e)
+			return False
+		used_kconfig = kunit_config.Kconfig()
+		used_kconfig.read_from_file(get_kconfig_path(build_dir))
+		if not self._kconfig.is_subset_of(used_kconfig):
+			logging.error('Provided Kconfig is not contained in final config!')
+			return False
+		return True
+
+	def run_kernel(self, args=[], timeout=None, build_dir=None):
+		args.extend(['mem=256M'])
+		process = self._ops.linux_bin(args, timeout, build_dir)
+		with open('test.log', 'w') as f:
+			for line in process.stdout:
+				f.write(line.rstrip().decode('ascii') + '\n')
+				yield line.rstrip().decode('ascii')
diff --git a/tools/testing/kunit/kunit_parser.py b/tools/testing/kunit/kunit_parser.py
new file mode 100644
index 0000000000000..6c81d4dcfabb5
--- /dev/null
+++ b/tools/testing/kunit/kunit_parser.py
@@ -0,0 +1,119 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Parses test results from a kernel dmesg log.
+#
+# Copyright (C) 2019, Google LLC.
+# Author: Felix Guo <felixguoxiuping-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
+# Author: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
+
+import re
+from datetime import datetime
+
+kunit_start_re = re.compile('printk: console .* enabled')
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
+def parse_run_tests(kernel_output):
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
2.21.0.rc0.258.g878e2cd30e-goog
