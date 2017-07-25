Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A9BDE21C91255
 for <linux-nvdimm@lists.01.org>; Tue, 25 Jul 2017 05:13:22 -0700 (PDT)
Date: Tue, 25 Jul 2017 14:15:22 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5 1/5] mm: add vm_insert_mixed_mkwrite()
Message-ID: <20170725121522.GA13457@lst.de>
References: <20170724170616.25810-1-ross.zwisler@linux.intel.com>
 <20170724170616.25810-2-ross.zwisler@linux.intel.com>
 <20170724221400.pcq5zvke7w2yfkxi@node.shutemov.name>
 <20170725080158.GA5374@lst.de> <20170725093508.GA19943@quack2.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170725093508.GA19943@quack2.suse.cz>
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
Cc: Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, linux-doc@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, "Kirill A. Shutemov" <kirill@shutemov.name>, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jul 25, 2017 at 11:35:08AM +0200, Jan Kara wrote:
> On Tue 25-07-17 10:01:58, Christoph Hellwig wrote:
> > On Tue, Jul 25, 2017 at 01:14:00AM +0300, Kirill A. Shutemov wrote:
> > > I guess it's up to filesystem if it wants to reuse the same spot to write
> > > data or not. I think your assumptions works for ext4 and xfs. I wouldn't
> > > be that sure for btrfs or other filesystems with CoW support.
> > 
> > Or XFS with reflinks for that matter.  Which currently can't be
> > combined with DAX, but I had a somewhat working version a few month
> > ago.
> 
> But in cases like COW when the block mapping changes, the process
> must run unmap_mapping_range() before installing the new PTE so that all
> processes mapping this file offset actually refault and see the new
> mapping. So this would go through pte_none() case. Am I missing something?

Yes, for DAX COW mappings we'd probably need something like this, unlike
the pagecache COW handling for which only the underlying block change,
but not the page.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
