Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5AEF521A07AA1
 for <linux-nvdimm@lists.01.org>; Sun, 18 Jun 2017 01:44:38 -0700 (PDT)
Date: Sun, 18 Jun 2017 10:45:57 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 13/14] filesystem-dax: gate calls to dax_flush() on
 QUEUE_FLAG_WC
Message-ID: <20170618084557.GD26456@lst.de>
References: <149703982465.20620.14881139332926778446.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149703989611.20620.6907872165215640212.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <149703989611.20620.6907872165215640212.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, x86@kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, dm-devel@redhat.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 09, 2017 at 01:24:56PM -0700, Dan Williams wrote:
> Some platforms arrange for cpu caches to be flushed on power-fail. On
> those platforms there is no requirement that the kernel track and flush
> potentially dirty cache lines. Given that we still insert entries into
> the radix for locking purposes this patch only disables the cache flush
> loop, not the dirty tracking.
> 
> Userspace can override the default cache setting via the block device
> queue "write_cache" attribute in sysfs.

NAK.  Please stop using the block infrastructure for dax values.  Have
your own flag and sysfs file in the dax infrastructure and only propagate
it to the block layer for the block devices using dax.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
