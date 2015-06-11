Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20150609064811.GG9804@lst.de>
References: <20150602001134.4506.45867.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150602001557.4506.57136.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150609064811.GG9804@lst.de>
Date: Thu, 11 Jun 2015 13:12:32 -0700
Message-ID: <CAPcyv4j8pTGZF_4vubPBTRDHwo=JSmq=mnZ5bhMpEhy7uYj7nw@mail.gmail.com>
Subject: Re: [PATCH v5 20/21] tools/testing/nvdimm: manufactured NFITs for
 interface development
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Jens Axboe <axboe@kernel.dk>, Stephen Rothwell <sfr@canb.auug.org.au>, "Rafael J. Wysocki" <rafael@kernel.org>, Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, jmoyer <jmoyer@redhat.com>, linux-api@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 8, 2015 at 11:48 PM, Christoph Hellwig <hch@lst.de> wrote:
> The description fails to mention the hacks how this is archived.  I don't
> think the include hackery and otherwise needed exports are acceptable
> if with an explanation, though.

I've killed the include hackery.

> Really - get your fake hardware into qemu right now and don't bother
> with trying to hack the subsystem like this.

Rest assured that NFIT enabling for QEMU/KVM is well under way, but I
disagree that QEMU is the right place to enable unit tests.  Here is
the updated changelog that appears in "[PATCH v6 20/21]
tools/testing/nvdimm: libnvdimm unit test infrastructure":

---

tools/testing/nvdimm: libnvdimm unit test infrastructure

'libnvdimm' is the first driver sub-system in the kernel to implement
mocking for unit test coverage.  The nfit_test module gets built as an
external module and arranges for external module replacements of nfit,
libnvdimm, nd_pmem, and nd_blk.  These replacements use the linker
--wrap option to redirect calls to ioremap() + request_mem_region() to
custom defined unit test resources.  The end result is a fully
functional nvdimm_bus, as far as userspace is concerned, but with the
capability to perform otherwise destructive tests on emulated
resources.

Q: Why not use QEMU for this emulation?
QEMU is not suitable for unit testing.  QEMU's role is to faithfully
emulate the platform.  A unit test's role is to unfaithfully implement
the platform with the goal of triggering bugs in the corners of the
sub-system implementation.  As bugs are discovered in platforms, or
the sub-system itself, the unit tests are extended to backstop a fix
with a reproducer unit test.

Another problem with QEMU is that it would require coordination of 3
software projects instead of 2 (kernel + libndctl [1]) to maintain and
execute the tests.  The chances for bit rot and the difficulty of
getting the tests running goes up non-linearly the more components
involved.

Q: Why submit this to the kernel tree instead of external modules in libndctl?
Simple, to alleviate the same risk that out-of-tree external modules
face.  Updates to drivers/nvdimm/ can be immediately evaluated to see
if they have any impact on tools/testing/nvdimm/.

[1]: https://github.com/pmem/ndctl
