Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8834C22135D4A
 for <linux-nvdimm@lists.01.org>; Tue,  6 Mar 2018 13:34:56 -0800 (PST)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH] ndctl, test: add a unit test for partition
 rescanning
Date: Tue, 6 Mar 2018 21:41:08 +0000
Message-ID: <1520372466.24924.82.camel@intel.com>
References: <20180305235655.9927-1-vishal.l.verma@intel.com>
 <CAPcyv4gDVp7pHWRgcBaOgyULT_Z+cohD6qfw5X-YmZ2-dOuthg@mail.gmail.com>
In-Reply-To: <CAPcyv4gDVp7pHWRgcBaOgyULT_Z+cohD6qfw5X-YmZ2-dOuthg@mail.gmail.com>
Content-Language: en-US
Content-ID: <3EDE8437006AEB47A05C6E6217B8E39A@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "Dokupil, Dariusz" <dariusz.dokupil@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


On Tue, 2018-03-06 at 13:34 -0800, Dan Williams wrote:
> On Mon, Mar 5, 2018 at 3:56 PM, Vishal Verma <vishal.l.verma@intel.co
> m> wrote:
> > pre-4.16 kernels had a bug where BTT partitions wouldn't come up on
> > driver probe because we were adding a zero-sized disk. Add a unit
> > test
> > that creates partitions, and cycles the namespace to ensure the
> > partitions are automatically brought up. This performs the test for
> > raw,
> > memory, and sector modes.
> > 
> > Reported-by: Dariusz Dokupil <dariusz.dokupil@intel.com>
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> > ---
> >  test/Makefile.am          |   3 +-
> >  test/rescan-partitions.sh | 106
> > ++++++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 108 insertions(+), 1 deletion(-)
> >  create mode 100755 test/rescan-partitions.sh
> > 
> > diff --git a/test/Makefile.am b/test/Makefile.am
> > index 749055c..496a663 100644
> > --- a/test/Makefile.am
> > +++ b/test/Makefile.am
> > @@ -20,7 +20,8 @@ TESTS =\
> >         hugetlb \
> >         btt-pad-compat.sh \
> >         firmware-update.sh \
> > -       ack-shutdown-count-set
> > +       ack-shutdown-count-set \
> > +       rescan-partitions.sh
> > 
> >  check_PROGRAMS =\
> >         libndctl \
> > diff --git a/test/rescan-partitions.sh b/test/rescan-partitions.sh
> > new file mode 100755
> > index 0000000..6dd289b
> > --- /dev/null
> > +++ b/test/rescan-partitions.sh
> > @@ -0,0 +1,106 @@
> > +#!/bin/bash -Ex
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright(c) 2018 Intel Corporation. All rights reserved.
> > +
> > +[ -f "../ndctl/ndctl" ] && [ -x "../ndctl/ndctl" ] &&
> > ndctl="../ndctl/ndctl"
> > +[ -f "./ndctl/ndctl" ] && [ -x "./ndctl/ndctl" ] &&
> > ndctl="./ndctl/ndctl"
> > +[ -z "$ndctl" ] && echo "Couldn't find an ndctl binary" && exit 1
> > +bus="nfit_test.0"
> > +json2var="s/[{}\",]//g; s/:/=/g"
> > +dev=""
> > +size=""
> > +blockdev=""
> > +rc=77
> > +
> > +trap 'err $LINENO' ERR
> > +
> > +# sample json:
> > +#{
> > +#  "dev":"namespace5.0",
> > +#  "mode":"sector",
> > +#  "size":"60.00 MiB (62.92 MB)",
> > +#  "uuid":"f1baa71a-d165-4da4-bb6a-083a2b0e6469",
> > +#  "blockdev":"pmem5s",
> > +#}
> > +
> > +# $1: Line number
> > +# $2: exit code
> > +err()
> > +{
> > +       [ -n "$2" ] && rc="$2"
> > +       echo "test/rescan-partitions.sh: failed at line $1"
> > +       exit "$rc"
> > +}
> > +
> > +check_min_kver()
> > +{
> > +       local ver="$1"
> > +       : "${KVER:=$(uname -r)}"
> > +
> > +       [ -n "$ver" ] || return 1
> > +       [[ "$ver" == "$(echo -e "$ver\n$KVER" | sort -V | head -1)"
> > ]]
> > +}
> > +check_min_kver "4.16" || { echo "kernel $KVER may not contain
> > fixes for partition rescanning"; exit "$rc"; }
> 
> I have a proposal for kernel version checks going forward. How about
> tests that fail the kernel version check return SKIP / PASS, and
> kernels that pass the kernel version check return FAIL / PASS for the
> test. This way we don't bail out early on backport kernels that could
> otherwise pass the test.
> 
> Thoughts?

So do you mean, for example, if a kernel version check fails, don't
skip immediately. Instead continue to run the test, and if something
actually fails, then return with a SKIP.

And conversely, for a kernel version that passes the included check, no
other condition can return a SKIP?  (What about something like missing
packages?)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
