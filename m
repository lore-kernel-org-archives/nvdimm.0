Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by ml01.01.org (Postfix) with ESMTP id 825D61A1F19
 for <linux-nvdimm@lists.01.org>; Thu, 26 May 2016 12:01:05 -0700 (PDT)
Date: Thu, 26 May 2016 13:00:32 -0600
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [GIT PULL] dax-locking for 4.7
Message-ID: <20160526190029.GA13792@omniknight.lm.intel.com>
References: <20160524205219.GA8050@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160524205219.GA8050@linux.intel.com>
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
To: Linus Torvalds <torvalds@linux-foundation.org>, Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, May 24, 2016 at 02:52:19PM -0600, Ross Zwisler wrote:
> Hi Linus, please pull from
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/dax-locking-for-4.7
> 
> ... to receive filesystem DAX locking changes for v4.7.
> 
> These current version of these changes have been under review and test for a
> few weeks, and have appeared in the two most recent linux-next releases
> (next-20160520 and next-20160524).  I've reviewed all of the DAX changes in
> these patches, and Neil Brown has reviewed the patch that introduced the actual
> locking and wait queues.
> 
> This pull request is dependent on Vishal Verma's "dax-misc for 4.7" pull
> request.
> 
> The following changes since commit 40543f62cbdce42633e3fe10923099feee272e1f:
> 
>   dax: fix a comment in dax_zero_page_range and dax_truncate_page (2016-05-18 12:16:58 -0600)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/dax-locking-for-4.7
> 
> for you to fetch changes up to 4d9a2c8746671efbb0c27d3ae28c7474597a7aad:
> 
>   dax: Remove i_mmap_lock protection (2016-05-19 15:28:40 -0600)
> 
> ----------------------------------------------------------------
> Filesystem DAX locking for 4.7
> 
> - We use a bit in an exceptional radix tree entry as a lock bit and use it
>   similarly to how page lock is used for normal faults.  This fixes races
>   between hole instantiation and read faults of the same index.
> 
> - Filesystem DAX PMD faults are disabled, and will be re-enabled when PMD
>   locking is implemented.
> 
> ----------------------------------------------------------------

Hi Linus,

Both this pull request, and mine ([GIT PULL] dax-misc for 4.7) have
minor merge conflicts with your tree. These were caught by linux-next
too (in addition to the one I mentioned in my pull request), but I
neglected to mention this one [1].

[1] https://lkml.org/lkml/2016/5/19/707

I've updated the branch at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm libnvdimm-for-4.7-merge

with the expected resolution of merging both dax-misc-for-4.7 and
dax-locking-for-4.7

Let me know if you run into something odd, and apologies for not giving
an earlier heads up about the conflict.

	-Vishal

> Jan Kara (7):
>   dax: Fix condition for filling of PMD holes
>   dax: Make huge page handling depend of CONFIG_BROKEN
>   dax: Define DAX lock bit for radix tree exceptional entry
>   dax: Allow DAX code to replace exceptional entries
>   dax: New fault locking
>   dax: Use radix tree entry lock to protect cow faults
>   dax: Remove i_mmap_lock protection
> 
>  fs/Kconfig          |   1 +
>  fs/dax.c            | 592 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------------
>  include/linux/dax.h |  16 ++-
>  include/linux/mm.h  |   7 ++
>  mm/filemap.c        |  30 +++--
>  mm/memory.c         |  40 +++----
>  mm/truncate.c       |  62 +++++-----
>  7 files changed, 513 insertions(+), 235 deletions(-)
> 
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
