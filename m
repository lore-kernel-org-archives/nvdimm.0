From: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [RFC v2 10/14] kunit: add Python libraries for handing KUnit config
 and kernel
Date: Tue, 23 Oct 2018 16:57:46 -0700
Message-ID: <20181023235750.103146-11-brendanhiggins@google.com>
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
 tools/testing/kunit/.gitignore      |   3 +
 tools/testing/kunit/kunit_config.py |  60 ++++++++++++++
 tools/testing/kunit/kunit_kernel.py | 123 ++++++++++++++++++++++++++++
 3 files changed, 186 insertions(+)
 create mode 100644 tools/testing/kunit/.gitignore
 create mode 100644 tools/testing/kunit/kunit_config.py
 create mode 100644 tools/testing/kunit/kunit_kernel.py

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
diff --git a/tools/testing/kunit/kunit_config.py b/tools/testing/kunit/kunit_config.py
new file mode 100644
index 0000000000000..183bd5e758762
--- /dev/null
+++ b/tools/testing/kunit/kunit_config.py
@@ -0,0 +1,60 @@
+# SPDX-License-Identifier: GPL-2.0
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
index 0000000000000..87abaede50513
--- /dev/null
+++ b/tools/testing/kunit/kunit_kernel.py
@@ -0,0 +1,123 @@
+# SPDX-License-Identifier: GPL-2.0
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
+	def make_olddefconfig(self):
+		try:
+			subprocess.check_output(['make', 'ARCH=um', 'olddefconfig'])
+		except OSError as e:
+			raise ConfigError('Could not call make command: ' + e)
+		except subprocess.CalledProcessError as e:
+			raise ConfigError(e.output)
+
+	def make(self):
+		try:
+			subprocess.check_output(['make', 'ARCH=um'])
+		except OSError as e:
+			raise BuildError('Could not call execute make: ' + e)
+		except subprocess.CalledProcessError as e:
+			raise BuildError(e.output)
+
+	def linux_bin(self, params, timeout):
+		"""Runs the Linux UML binary. Must be named 'linux'."""
+		process = subprocess.Popen(
+			['./linux'] + params,
+			stdin=subprocess.PIPE,
+			stdout=subprocess.PIPE,
+			stderr=subprocess.PIPE)
+		process.wait(timeout=timeout)
+		return process
+
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
+	def build_config(self):
+		self._kconfig.write_to_file(KCONFIG_PATH)
+		try:
+			self._ops.make_olddefconfig()
+		except ConfigError as e:
+			logging.error(e)
+			return False
+		validated_kconfig = kunit_config.Kconfig()
+		validated_kconfig.read_from_file(KCONFIG_PATH)
+		if not self._kconfig.is_subset_of(validated_kconfig):
+			logging.error('Provided Kconfig is not contained in validated .config!')
+			return False
+		return True
+
+	def build_reconfig(self):
+		"""Creates a new .config if it is not a subset of the kunitconfig."""
+		if os.path.exists(KCONFIG_PATH):
+			existing_kconfig = kunit_config.Kconfig()
+			existing_kconfig.read_from_file(KCONFIG_PATH)
+			if not self._kconfig.is_subset_of(existing_kconfig):
+				print('Regenerating .config ...')
+				os.remove(KCONFIG_PATH)
+				return self.build_config()
+			else:
+				return True
+		else:
+			print('Generating .config ...')
+			return self.build_config()
+
+	def build_um_kernel(self):
+		try:
+			self._ops.make_olddefconfig()
+			self._ops.make()
+		except (ConfigError, BuildError) as e:
+			logging.error(e)
+			return False
+		used_kconfig = kunit_config.Kconfig()
+		used_kconfig.read_from_file(KCONFIG_PATH)
+		if not self._kconfig.is_subset_of(used_kconfig):
+			logging.error('Provided Kconfig is not contained in final config!')
+			return False
+		return True
+
+	def run_kernel(self, args=[]):
+		timeout = None
+		args.extend(['mem=256M'])
+		process = self._ops.linux_bin(args, timeout)
+		with open('test.log', 'w') as f:
+			for line in process.stdout:
+				f.write(line.rstrip().decode('ascii') + '\n')
+				yield line.rstrip().decode('ascii')
-- 
2.19.1.568.g152ad8e336-goog
