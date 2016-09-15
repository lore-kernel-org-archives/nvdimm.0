Return-Path: <owner-linux-mm@kvack.org>
Date: Thu, 15 Sep 2016 10:26:15 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 2/3] mm, dax: add VM_DAX flag for DAX VMAs
Message-ID: <20160915082615.GA9772@lst.de>
References: <147392246509.9873.17750323049785100997.stgit@dwillia2-desk3.amr.corp.intel.com> <147392247875.9873.4205533916442000884.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147392247875.9873.4205533916442000884.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-mm@kvack.org, linux-nvdimm@lists.01.org, david@fromorbit.com, linux-kernel@vger.kernel.org, npiggin@gmail.com, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Sep 14, 2016 at 11:54:38PM -0700, Dan Williams wrote:
> The DAX property, page cache bypass, of a VMA is only detectable via the
> vma_is_dax() helper to check the S_DAX inode flag.  However, this is
> only available internal to the kernel and is a property that userspace
> applications would like to interrogate.

They have absolutely no business knowing such an implementation detail.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
