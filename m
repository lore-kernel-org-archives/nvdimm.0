Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw0-x22b.google.com (mail-yw0-x22b.google.com
 [IPv6:2607:f8b0:4002:c05::22b])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DF8A32095D9DD
 for <linux-nvdimm@lists.01.org>; Fri, 21 Jul 2017 15:51:05 -0700 (PDT)
Received: by mail-yw0-x22b.google.com with SMTP id x125so29772382ywa.0
 for <linux-nvdimm@lists.01.org>; Fri, 21 Jul 2017 15:53:03 -0700 (PDT)
MIME-Version: 1.0
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 21 Jul 2017 15:53:02 -0700
Message-ID: <CAPcyv4hCymUQ--+h=TNKgfDfk7Zp22kr7HDzXuaUsSE92GYcPA@mail.gmail.com>
Subject: Moving ndctl development into the kernel tree?
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
To: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

Hi Linus,

Would you be open to the ndctl [1] project moving its development into
the kernel tree? The main reasons why I ask are:

* Unit test development can touch both the kernel-side emulated nvdimm
infrastructure in tools/testing/nvdimm/ and the corresponding tests in
tools/ndctl/test/ in the same commit or patch series.

* Like perf, ndctl borrows the sub-command architecture and option
parsing from git. So, this code could be refactored into something
shared / generic, i.e. the bits in tools/perf/util/.

We continue to see updates in the ACPI and UEFI specification for
nvdimm details and one of the capabilities added in ACPI 6.2 that
needs new test development is error injection. I'm also expecting to
merge patches from Oliver this cycle expanding nvdimm support to Open
Firmware / powerpc platforms.

The ndctl project includes GPLv2 utilities (ndctl and daxctl) as well
as LGPLv2.1 libraries (libndctl and libdaxctl).

The coupling of the tests to new libnvdimm sub-system capabilities,
and the architecture specific nature of some nvdimm enabling leads me
to believe ndctl would enjoy some synergies living in the same
repository as the kernel.

[1]: https://github.com/pmem/ndctl
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
