Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com
 [213.167.242.64])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 59CC4211963EE
 for <linux-nvdimm@lists.01.org>; Thu, 29 Nov 2018 05:54:07 -0800 (PST)
Subject: Re: [RFC v3 11/19] kunit: add Python libraries for handing KUnit
 config and kernel
References: <20181128193636.254378-1-brendanhiggins@google.com>
 <20181128193636.254378-12-brendanhiggins@google.com>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <841cf4ae-501b-05ae-5863-a51010709b67@ideasonboard.com>
Date: Thu, 29 Nov 2018 13:54:00 +0000
MIME-Version: 1.0
In-Reply-To: <20181128193636.254378-12-brendanhiggins@google.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Reply-To: kieran.bingham@ideasonboard.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Brendan Higgins <brendanhiggins@google.com>, gregkh@linuxfoundation.org, keescook@google.com, mcgrof@kernel.org, shuah@kernel.org
Cc: brakmo@fb.com, jdike@addtoit.com, dri-devel@lists.freedesktop.org, linux-kselftest@vger.kernel.org, frowand.list@gmail.com, robh@kernel.org, linux-nvdimm@lists.01.org, richard@nod.at, knut.omang@oracle.com, Felix Guo <felixguoxiuping@gmail.com>, joel@jms.id.au, khilman@baylibre.com, Tim.Bird@sony.com, linux-um@lists.infradead.org, rostedt@goodmis.org, julia.lawall@lip6.fr, kunit-dev@googlegroups.com, linux-kernel@vger.kernel.org, daniel@ffwll.ch, mpe@ellerman.id.au, joe@perches.com
List-ID: <linux-nvdimm@lists.01.org>

Hi Brendan,

Thanks again for this series!

On 28/11/2018 19:36, Brendan Higgins wrote:
> The ultimate goal is to create minimal isolated test binaries; in the
> meantime we are using UML to provide the infrastructure to run tests, so
> define an abstract way to configure and run tests that allow us to
> change the context in which tests are built without affecting the user.
> This also makes pretty and dynamic error reporting, and a lot of other
> nice features easier.


I wonder if we could somehow generate a shared library object
'libkernel' or 'libumlinux' from a UM configured set of headers and
objects so that we could create binary targets directly ?


> kunit_config.py:
>   - parse .config and Kconfig files.
> 
> kunit_kernel.py: provides helper functions to:
>   - configure the kernel using kunitconfig.
>   - build the kernel with the appropriate configuration.
>   - provide function to invoke the kernel and stream the output back.
> 
> Signed-off-by: Felix Guo <felixguoxiuping@gmail.com>
> Signed-off-by: Brendan Higgins <brendanhiggins@google.com>
> ---
>  tools/testing/kunit/.gitignore      |   3 +
>  tools/testing/kunit/kunit_config.py |  60 +++++++++++++
>  tools/testing/kunit/kunit_kernel.py | 126 ++++++++++++++++++++++++++++
>  3 files changed, 189 insertions(+)
>  create mode 100644 tools/testing/kunit/.gitignore
>  create mode 100644 tools/testing/kunit/kunit_config.py
>  create mode 100644 tools/testing/kunit/kunit_kernel.py
> 
> diff --git a/tools/testing/kunit/.gitignore b/tools/testing/kunit/.gitignore
> new file mode 100644
> index 0000000000000..c791ff59a37a9
> --- /dev/null
> +++ b/tools/testing/kunit/.gitignore
> @@ -0,0 +1,3 @@
> +# Byte-compiled / optimized / DLL files
> +__pycache__/
> +*.py[cod]
> \ No newline at end of file
> diff --git a/tools/testing/kunit/kunit_config.py b/tools/testing/kunit/kunit_config.py
> new file mode 100644
> index 0000000000000..183bd5e758762
> --- /dev/null
> +++ b/tools/testing/kunit/kunit_config.py
> @@ -0,0 +1,60 @@
> +# SPDX-License-Identifier: GPL-2.0
> +
> +import collections
> +import re
> +
> +CONFIG_IS_NOT_SET_PATTERN = r'^# CONFIG_\w+ is not set$'
> +CONFIG_PATTERN = r'^CONFIG_\w+=\S+$'
> +
> +KconfigEntryBase = collections.namedtuple('KconfigEntry', ['raw_entry'])
> +
> +
> +class KconfigEntry(KconfigEntryBase):
> +
> +	def __str__(self) -> str:
> +		return self.raw_entry
> +
> +
> +class KconfigParseError(Exception):
> +	"""Error parsing Kconfig defconfig or .config."""
> +
> +
> +class Kconfig(object):
> +	"""Represents defconfig or .config specified using the Kconfig language."""
> +
> +	def __init__(self):
> +		self._entries = []
> +
> +	def entries(self):
> +		return set(self._entries)
> +
> +	def add_entry(self, entry: KconfigEntry) -> None:
> +		self._entries.append(entry)
> +
> +	def is_subset_of(self, other: "Kconfig") -> bool:
> +		return self.entries().issubset(other.entries())
> +
> +	def write_to_file(self, path: str) -> None:
> +		with open(path, 'w') as f:
> +			for entry in self.entries():
> +				f.write(str(entry) + '\n')
> +
> +	def parse_from_string(self, blob: str) -> None:
> +		"""Parses a string containing KconfigEntrys and populates this Kconfig."""
> +		self._entries = []
> +		is_not_set_matcher = re.compile(CONFIG_IS_NOT_SET_PATTERN)
> +		config_matcher = re.compile(CONFIG_PATTERN)
> +		for line in blob.split('\n'):
> +			line = line.strip()
> +			if not line:
> +				continue
> +			elif config_matcher.match(line) or is_not_set_matcher.match(line):
> +				self._entries.append(KconfigEntry(line))
> +			elif line[0] == '#':
> +				continue
> +			else:
> +				raise KconfigParseError('Failed to parse: ' + line)
> +
> +	def read_from_file(self, path: str) -> None:
> +		with open(path, 'r') as f:
> +			self.parse_from_string(f.read())
> diff --git a/tools/testing/kunit/kunit_kernel.py b/tools/testing/kunit/kunit_kernel.py
> new file mode 100644
> index 0000000000000..bba7ea7ca1869
> --- /dev/null
> +++ b/tools/testing/kunit/kunit_kernel.py
> @@ -0,0 +1,126 @@
> +# SPDX-License-Identifier: GPL-2.0
> +
> +import logging
> +import subprocess
> +import os
> +
> +import kunit_config
> +
> +KCONFIG_PATH = '.config'
> +
> +class ConfigError(Exception):
> +	"""Represents an error trying to configure the Linux kernel."""
> +
> +
> +class BuildError(Exception):
> +	"""Represents an error trying to build the Linux kernel."""
> +
> +
> +class LinuxSourceTreeOperations(object):
> +	"""An abstraction over command line operations performed on a source tree."""
> +
> +	def make_mrproper(self):
> +		try:
> +			subprocess.check_output(['make', 'mrproper'])
> +		except OSError as e:
> +			raise ConfigError('Could not call make command: ' + e)
> +		except subprocess.CalledProcessError as e:
> +			raise ConfigError(e.output)
> +
> +	def make_olddefconfig(self):
> +		try:
> +			subprocess.check_output(['make', 'ARCH=um', 'olddefconfig'])
> +		except OSError as e:
> +			raise ConfigError('Could not call make command: ' + e)
> +		except subprocess.CalledProcessError as e:
> +			raise ConfigError(e.output)
> +
> +	def make(self, jobs):
> +		try:
> +			subprocess.check_output([
> +					'make',
> +					'ARCH=um',
> +					'--jobs=' + str(jobs)])

Perhaps as a future extension:

It would be nice if we could set an O= here to keep the source tree
pristine.

In fact I might even suggest that this should always be set so that the
unittesting could live along side an existing kernel build? :

 O ?= $KBUILD_SRC/
 O := $(O)/kunittest/$(ARCH)/build


> +		except OSError as e:
> +			raise BuildError('Could not call execute make: ' + e)
> +		except subprocess.CalledProcessError as e:
> +			raise BuildError(e.output)
> +
> +	def linux_bin(self, params, timeout):
> +		"""Runs the Linux UML binary. Must be named 'linux'."""
> +		process = subprocess.Popen(
> +			['./linux'] + params,
> +			stdin=subprocess.PIPE,
> +			stdout=subprocess.PIPE,
> +			stderr=subprocess.PIPE)
> +		process.wait(timeout=timeout)
> +		return process
> +
> +
> +class LinuxSourceTree(object):
> +	"""Represents a Linux kernel source tree with KUnit tests."""
> +
> +	def __init__(self):
> +		self._kconfig = kunit_config.Kconfig()
> +		self._kconfig.read_from_file('kunitconfig')
> +		self._ops = LinuxSourceTreeOperations()
> +
> +	def clean(self):
> +		try:
> +			self._ops.make_mrproper()
> +		except ConfigError as e:
> +			logging.error(e)
> +			return False
> +		return True
> +
> +	def build_config(self):
> +		self._kconfig.write_to_file(KCONFIG_PATH)
> +		try:
> +			self._ops.make_olddefconfig()
> +		except ConfigError as e:
> +			logging.error(e)
> +			return False
> +		validated_kconfig = kunit_config.Kconfig()
> +		validated_kconfig.read_from_file(KCONFIG_PATH)
> +		if not self._kconfig.is_subset_of(validated_kconfig):
> +			logging.error('Provided Kconfig is not contained in validated .config!')
> +			return False
> +		return True
> +
> +	def build_reconfig(self):
> +		"""Creates a new .config if it is not a subset of the kunitconfig."""
> +		if os.path.exists(KCONFIG_PATH):
> +			existing_kconfig = kunit_config.Kconfig()
> +			existing_kconfig.read_from_file(KCONFIG_PATH)
> +			if not self._kconfig.is_subset_of(existing_kconfig):
> +				print('Regenerating .config ...')
> +				os.remove(KCONFIG_PATH)
> +				return self.build_config()
> +			else:
> +				return True
> +		else:
> +			print('Generating .config ...')
> +			return self.build_config()
> +
> +	def build_um_kernel(self, jobs):
> +		try:
> +			self._ops.make_olddefconfig()
> +			self._ops.make(jobs)
> +		except (ConfigError, BuildError) as e:
> +			logging.error(e)
> +			return False
> +		used_kconfig = kunit_config.Kconfig()
> +		used_kconfig.read_from_file(KCONFIG_PATH)
> +		if not self._kconfig.is_subset_of(used_kconfig):
> +			logging.error('Provided Kconfig is not contained in final config!')
> +			return False
> +		return True
> +
> +	def run_kernel(self, args=[]):
> +		timeout = None
> +		args.extend(['mem=256M'])
> +		process = self._ops.linux_bin(args, timeout)
> +		with open('test.log', 'w') as f:
> +			for line in process.stdout:
> +				f.write(line.rstrip().decode('ascii') + '\n')
> +				yield line.rstrip().decode('ascii')
> 

-- 
Regards
--
Kieran
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
