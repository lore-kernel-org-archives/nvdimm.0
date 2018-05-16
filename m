Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 479F6203B85BA
 for <linux-nvdimm@lists.01.org>; Wed, 16 May 2018 00:22:17 -0700 (PDT)
Date: Wed, 16 May 2018 09:22:08 +0200
From: Igor Mammedov <imammedo@redhat.com>
Subject: Re: [Qemu-devel] [PATCH 3/3] nvdimm: platform capabilities command
 line option
Message-ID: <20180516092208.4461c748@redhat.com>
In-Reply-To: <20180515230351.GA741@linux.intel.com>
References: <20180427215314.23168-1-ross.zwisler@linux.intel.com>
 <20180427215314.23168-3-ross.zwisler@linux.intel.com>
 <20180510152848.0f99ea07@redhat.com>
 <20180515230351.GA741@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Eduardo Habkost <ehabkost@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, "Michael S . Tsirkin" <mst@redhat.com>, qemu-devel@nongnu.org, Stefan Hajnoczi <stefanha@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 15 May 2018 17:03:51 -0600
Ross Zwisler <ross.zwisler@linux.intel.com> wrote:

> On Thu, May 10, 2018 at 03:28:48PM +0200, Igor Mammedov wrote:
[...]
> 
> > Also an extra patch to for make check that will test setting 'cap'
> > would be nice (an extra testcase in tests/bios-tables-test.c)  
> 
> Hmm...I've been looking at this, and it doesn't look like there is any
> verification around a lot of the ACPI tables (NFIT, SRAT, etc).
as far as I recall NFIT and SRAT are verified against expected template
(limited but at least something)

Following commits can serve as an example:
 e0e5c85 test/acpi-test-data: add ACPI tables for dimmpxm test
 adae91c tests/bios-tables-test: add test cases for DIMM proximity

> I've verified my patch by interacting with a guest with various settings - is
> this good enough, or do you really want me to test the value (which I think
> would just be "do I get out what I put in at the command line") via the unit
> test infrastructure?
It would be better to add test especially for a new code.
The reason for it is to catch regressions down the road,
it also makes easier for maintainer to review/test series.

> Thank you for the review.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
