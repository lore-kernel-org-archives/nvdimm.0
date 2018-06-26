Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4AF6C211F8869
 for <linux-nvdimm@lists.01.org>; Tue, 26 Jun 2018 10:47:32 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: [ANNOUNCE] ndctl v61
Date: Tue, 26 Jun 2018 17:47:15 +0000
Message-ID: <1530035210.27147.29.camel@intel.com>
Content-Language: en-US
Content-ID: <6955866F6DB0FB4CADEAEDD57AF2CCBC@intel.com>
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

https://github.com/pmem/ndctl/releases/tag/v61

This release incorporates functionality up to the 4.18 kernel, and
a number of bug fixes and improvements.

Highlights include a fix to the error injection APIs to inject fewer
bytes of errors per sector, support for building documentation with
asciidoctor in addition to asciidoc, multi-arrgument support for
util_<obj>_filter, and a new OPTION_FILENAME in option parsing. Unit
test updates include cleanups to unit test scripts refactoring out a
lot of common boilerplate, MADV_HWPOISON tests, and a new test for
capacity vs label locking.

Shortlog:
Dan Williams (10):
      ndctl: warn on variables declared after statement
      ndctl: hide null uuids
      test: add a MADV_HWPOISON test
      test: Add device-dax MADV_HWPOISON test
      ndctl: autoconf detect BUS_MCEERR_AR
      ndctl, list: Add controller temperature
      ndctl, test: Update libndctl test for controller temperature valid
      ndctl, test: Disable poison tests for now
      ndctl, test: Update tests for capacity vs namespace-label locking
      ndctl, Documentation: Add namespace 'theory of operation'

Dave Jiang (1):
      ndctl: remove warnings when -O0 is used with -D_FORTIFY_SOURCE=2

Masayoshi Mizuma (5):
      ndctl, test: add common helper functions for test scripts
      ndctl, test: cleanup test scripts
      ndctl, test: Add NFIT_TEST_BUS[01] variable and some helper funtions
to common
      ndctl, test: cleanup test scripts
      ndctl: add a test file to .gitignore

QI Fuli (4):
      ndctl, filter: refacor util_<obj>_filter() to support multiple space-
seperated arguments
      ndctl, filter: fix "keyword 'all' is ignored" in util_<obj>_filter()
      ndctl, util: add OPTION_FILENAME to parse_opt_type
      ndctl, list: add controller temperature threshold and alarm

Takashi Iwai (3):
      Documentation: fix title and section markers
      Documentation: Add the support for asciidoctor
      Documentation: add asciidoctor-extensions.rb to .gitignore

Vishal Verma (19):
      ndctl, documentation: add inject-smart to the Makefile
      ndctl: fix ABI breakage due to rename of fw_info_get_updated_version
      libndctl, ars: add an API to retrieve clear_err_unit
      libndctl, inject: inject fewer bytes per block by default
      libndctl, inject: add 'v2' APIs for inject and uninject
      ndctl, inject-error: add a --saturate option
      libndctl: fix potential buffer overflow in write_cache APIs
      libndctl: improve debug prints in wait_for_scrub_completion
      libndctl, test: fix a couple of unchecked returns
      configure: add -Wunused-result and -D_FORTIFY_SOURCE=2 to cflags
      ndctl: fix libtool versioning
      ndctl, test: fix sector-mode.sh to work with label support
      ndctl, list: display the 'map' location in listings
      ndctl: refactor validation of the ars_status command
      ndctl, ars: don't invalidate the user-provided command
      ndctl: add an api for getting the ars_status overflow flag
      ndctl: Update README.md for code blocks
      ndctl, contrib: Add helper scripts for new release
      ndctl, test: remove an unused variable assignment
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
