Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 68A0E2115F52A
 for <linux-nvdimm@lists.01.org>; Fri,  8 Jun 2018 09:21:36 -0700 (PDT)
Date: Fri, 8 Jun 2018 19:21:34 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [Qemu-devel] [qemu PATCH 2/5] acpi: "make check" should fail on
 asl mismatch
Message-ID: <20180608191941-mutt-send-email-mst@kernel.org>
References: <20180607223111.27792-1-ross.zwisler@linux.intel.com>
 <20180607223111.27792-2-ross.zwisler@linux.intel.com>
 <20180608020724-mutt-send-email-mst@kernel.org>
 <5352d2fb-9244-78b0-4f4b-2818359a4425@redhat.com>
 <20180608153402.GA27156@linux.intel.com>
 <20180608185714-mutt-send-email-mst@kernel.org>
 <CAFEAcA943cBfMbjBJcheTWAL+mWa4vu5uL62LvKXS4agd+ZRMA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAFEAcA943cBfMbjBJcheTWAL+mWa4vu5uL62LvKXS4agd+ZRMA@mail.gmail.com>
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
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Thomas Huth <thuth@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Qemu Developers <qemu-devel@nongnu.org>, Stefan Hajnoczi <stefanha@redhat.com>, Igor Mammedov <imammedo@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 08, 2018 at 05:14:09PM +0100, Peter Maydell wrote:
> On 8 June 2018 at 16:59, Michael S. Tsirkin <mst@redhat.com> wrote:
> > The expected value tests are a debugging aid. They do not catch bugs and
> > aren't designed to. In particular the comparisons do not even run if
> > IASL isn't installed.
> 
> If they're not actually tests to catch bugs, maybe we shouldn't
> be running them in "make check" ?
> 
> thanks
> -- PMM

We are running tests to do basic things like verifying the
checksum of the tables. Failure on these causes make check to fail.

As long as we have the tables anyway, and assuming IASL is installed
(which most people who do not work on ACPI would not have) we compare to
the expected set, that is often helpful for debugging.

-- 
MST
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
