Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 by ml01.01.org (Postfix) with ESMTP id CBBBF1A1DFA
 for <linux-nvdimm@lists.01.org>; Tue, 28 Jun 2016 14:42:35 -0700 (PDT)
Date: Tue, 28 Jun 2016 15:41:59 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 0/3 v1] dax: Clear dirty bits after flushing caches
Message-ID: <20160628214159.GB15457@linux.intel.com>
References: <1466523915-14644-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1466523915-14644-1-git-send-email-jack@suse.cz>
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
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jun 21, 2016 at 05:45:12PM +0200, Jan Kara wrote:
> Hello,
> 
> currently we never clear dirty bits in the radix tree of a DAX inode. Thus
> fsync(2) or even periodical writeback flush all the dirty pfns again and
> again. This patches implement clearing of the dirty tag in the radix tree
> so that we issue flush only when needed.
> 
> The difficulty with clearing the dirty tag is that we have to protect against
> a concurrent page fault setting the dirty tag and writing new data into the
> page. So we need a lock serializing page fault and clearing of the dirty tag
> and write-protecting PTEs (so that we get another pagefault when pfn is written
> to again and we have to set the dirty tag again).
> 
> The effect of the patch set is easily visible:
> 
> Writing 1 GB of data via mmap, then fsync twice.
> 
> Before this patch set both fsyncs take ~205 ms on my test machine, after the
> patch set the first fsync takes ~283 ms (the additional cost of walking PTEs,
> clearing dirty bits etc. is very noticeable), the second fsync takes below
> 1 us.
> 
> As a bonus, these patches make filesystem freezing for DAX filesystems
> reliable because mappings are now properly writeprotected while freezing the
> fs.
> 
> Patches have passed xfstests for both xfs and ext4.
> 
> So far the patches don't work with PMD pages - that's next on my todo list.

Regarding the PMD work, I had a go at this a while ago.  You may (or may not)
find these patches useful:

mm: add follow_pte_pmd()
	https://patchwork.kernel.org/patch/7616241/
mm: add pmd_mkclean()
	https://patchwork.kernel.org/patch/7616261/
mm: add pgoff_mkclean()
	https://patchwork.kernel.org/patch/7616221/
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
