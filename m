Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com
 [IPv6:2607:f8b0:4864:20::341])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0A486212966F3
 for <linux-nvdimm@lists.01.org>; Thu, 27 Jun 2019 11:30:05 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id x21so3268046otq.12
 for <linux-nvdimm@lists.01.org>; Thu, 27 Jun 2019 11:30:05 -0700 (PDT)
MIME-Version: 1.0
References: <156159454541.2964018.7466991316059381921.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190627123415.GA4286@bombadil.infradead.org>
 <CAPcyv4jQP-SFJGor-Q3VCRQ0xwt3MuVpH2qHx2wzyRA88DGQww@mail.gmail.com>
In-Reply-To: <CAPcyv4jQP-SFJGor-Q3VCRQ0xwt3MuVpH2qHx2wzyRA88DGQww@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 27 Jun 2019 11:29:53 -0700
Message-ID: <CAPcyv4jjqooboxivY=AsfEPhCvxdwU66GpwE9vM+cqrZWvtX3g@mail.gmail.com>
Subject: Re: [PATCH] filesystem-dax: Disable PMD support
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
To: Matthew Wilcox <willy@infradead.org>
Cc: Seema Pandit <seema.pandit@intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>, Robert Barror <robert.barror@intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 27, 2019 at 9:06 AM Dan Williams <dan.j.williams@intel.com> wrote:
>
> On Thu, Jun 27, 2019 at 5:34 AM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > On Wed, Jun 26, 2019 at 05:15:45PM -0700, Dan Williams wrote:
> > > Ever since the conversion of DAX to the Xarray a RocksDB benchmark has
> > > been encountering intermittent lockups. The backtraces always include
> > > the filesystem-DAX PMD path, multi-order entries have been a source of
> > > bugs in the past, and disabling the PMD path allows a test that fails in
> > > minutes to run for an hour.
> >
> > On May 4th, I asked you:
> >
> > Since this is provoked by a fatal signal, it must have something to do
> > with a killable or interruptible sleep.  There's only one of those in the
> > DAX code; fatal_signal_pending() in dax_iomap_actor().  Does rocksdb do
> > I/O with write() or through a writable mmap()?  I'd like to know before
> > I chase too far down this fault tree analysis.
>
> RocksDB in this case is using write() for writes and mmap() for reads.

It's not clear to me that a fatal signal is a component of the failure
as much as it's the way to detect that the benchmark has indeed locked
up.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
