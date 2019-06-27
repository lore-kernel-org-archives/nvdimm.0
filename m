Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C083821297063
 for <linux-nvdimm@lists.01.org>; Thu, 27 Jun 2019 05:34:16 -0700 (PDT)
Date: Thu, 27 Jun 2019 05:34:15 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] filesystem-dax: Disable PMD support
Message-ID: <20190627123415.GA4286@bombadil.infradead.org>
References: <156159454541.2964018.7466991316059381921.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <156159454541.2964018.7466991316059381921.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Seema Pandit <seema.pandit@intel.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Robert Barror <robert.barror@intel.com>, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jun 26, 2019 at 05:15:45PM -0700, Dan Williams wrote:
> Ever since the conversion of DAX to the Xarray a RocksDB benchmark has
> been encountering intermittent lockups. The backtraces always include
> the filesystem-DAX PMD path, multi-order entries have been a source of
> bugs in the past, and disabling the PMD path allows a test that fails in
> minutes to run for an hour.

On May 4th, I asked you:

Since this is provoked by a fatal signal, it must have something to do
with a killable or interruptible sleep.  There's only one of those in the
DAX code; fatal_signal_pending() in dax_iomap_actor().  Does rocksdb do
I/O with write() or through a writable mmap()?  I'd like to know before
I chase too far down this fault tree analysis.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
