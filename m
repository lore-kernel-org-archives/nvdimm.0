Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg0-x244.google.com (mail-pg0-x244.google.com
 [IPv6:2607:f8b0:400e:c05::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5CA2321C91254
 for <linux-nvdimm@lists.01.org>; Tue, 25 Jul 2017 07:29:28 -0700 (PDT)
Received: by mail-pg0-x244.google.com with SMTP id v190so14659528pgv.1
 for <linux-nvdimm@lists.01.org>; Tue, 25 Jul 2017 07:31:30 -0700 (PDT)
Date: Tue, 25 Jul 2017 17:31:20 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH v5 1/5] mm: add vm_insert_mixed_mkwrite()
Message-ID: <20170725143120.fyjcxwsoff34vqoj@node.shutemov.name>
References: <20170724170616.25810-1-ross.zwisler@linux.intel.com>
 <20170724170616.25810-2-ross.zwisler@linux.intel.com>
 <20170724221400.pcq5zvke7w2yfkxi@node.shutemov.name>
 <20170725080158.GA5374@lst.de>
 <20170725093508.GA19943@quack2.suse.cz>
 <20170725121522.GA13457@lst.de>
 <20170725125037.GH19943@quack2.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170725125037.GH19943@quack2.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, linux-doc@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jul 25, 2017 at 02:50:37PM +0200, Jan Kara wrote:
> On Tue 25-07-17 14:15:22, Christoph Hellwig wrote:
> > On Tue, Jul 25, 2017 at 11:35:08AM +0200, Jan Kara wrote:
> > > On Tue 25-07-17 10:01:58, Christoph Hellwig wrote:
> > > > On Tue, Jul 25, 2017 at 01:14:00AM +0300, Kirill A. Shutemov wrote:
> > > > > I guess it's up to filesystem if it wants to reuse the same spot to write
> > > > > data or not. I think your assumptions works for ext4 and xfs. I wouldn't
> > > > > be that sure for btrfs or other filesystems with CoW support.
> > > > 
> > > > Or XFS with reflinks for that matter.  Which currently can't be
> > > > combined with DAX, but I had a somewhat working version a few month
> > > > ago.
> > > 
> > > But in cases like COW when the block mapping changes, the process
> > > must run unmap_mapping_range() before installing the new PTE so that all
> > > processes mapping this file offset actually refault and see the new
> > > mapping. So this would go through pte_none() case. Am I missing something?
> > 
> > Yes, for DAX COW mappings we'd probably need something like this, unlike
> > the pagecache COW handling for which only the underlying block change,
> > but not the page.
> 
> Right. So again nothing where the WARN_ON should trigger.

Yes. I was confused on how COW is handled.

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
 Kirill A. Shutemov
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
