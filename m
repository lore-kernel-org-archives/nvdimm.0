Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-lf0-x241.google.com (mail-lf0-x241.google.com
 [IPv6:2a00:1450:4010:c07::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DC8591A1E05
 for <linux-nvdimm@lists.01.org>; Mon, 29 Aug 2016 13:48:47 -0700 (PDT)
Received: by mail-lf0-x241.google.com with SMTP id 33so7481179lfw.3
 for <linux-nvdimm@lists.01.org>; Mon, 29 Aug 2016 13:48:47 -0700 (PDT)
Date: Mon, 29 Aug 2016 23:48:42 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH v4 RESEND 0/2] Align mmap address for DAX pmd mappings
Message-ID: <20160829204842.GA27286@node.shutemov.name>
References: <1472497881-9323-1-git-send-email-toshi.kani@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1472497881-9323-1-git-send-email-toshi.kani@hpe.com>
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
To: Toshi Kani <toshi.kani@hpe.com>
Cc: jack@suse.cz, mawilcox@microsoft.com, hughd@google.com, linux-nvdimm@lists.01.org, david@fromorbit.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, adilger.kernel@dilger.ca, kirill.shutemov@linux.intel.com, linux-fsdevel@vger.kernel.org, tytso@mit.edu, akpm@linux-foundation.org, mike.kravetz@oracle.com
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Aug 29, 2016 at 01:11:19PM -0600, Toshi Kani wrote:
> When CONFIG_FS_DAX_PMD is set, DAX supports mmap() using pmd page
> size.  This feature relies on both mmap virtual address and FS
> block (i.e. physical address) to be aligned by the pmd page size.
> Users can use mkfs options to specify FS to align block allocations.
> However, aligning mmap address requires code changes to existing
> applications for providing a pmd-aligned address to mmap().
> 
> For instance, fio with "ioengine=mmap" performs I/Os with mmap() [1].
> It calls mmap() with a NULL address, which needs to be changed to
> provide a pmd-aligned address for testing with DAX pmd mappings.
> Changing all applications that call mmap() with NULL is undesirable.
> 
> This patch-set extends filesystems to align an mmap address for
> a DAX file so that unmodified applications can use DAX pmd mappings.

+Hugh

Can we get it used for shmem/tmpfs too?
I don't think we should duplicate essentially the same functionality in
multiple places.

-- 
 Kirill A. Shutemov
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
