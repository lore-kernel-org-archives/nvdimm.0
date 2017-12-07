Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5110321B02820
 for <linux-nvdimm@lists.01.org>; Thu,  7 Dec 2017 14:54:05 -0800 (PST)
Date: Thu, 7 Dec 2017 15:58:37 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [fstests PATCH v5 2/2] generic: add test for DAX MAP_SYNC support
Message-ID: <20171207225837.GA25831@linux.intel.com>
References: <20171206003744.28587-1-ross.zwisler@linux.intel.com>
 <20171206003744.28587-3-ross.zwisler@linux.intel.com>
 <20171207103657.GF2749@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20171207103657.GF2749@eguan.usersys.redhat.com>
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
To: Eryu Guan <eguan@redhat.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, Amir Goldstein <amir73il@gmail.com>, Dave Chinner <david@fromorbit.com>, fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Dec 07, 2017 at 06:36:57PM +0800, Eryu Guan wrote:

> Now we have two _require rules to test log_writes dm target:
> _require_log_writes 	# _notrun explicitly when MOUNT_OPTIONS contains dax
> _require_log_writes_dax	# _notrun if log-writes target doesn't support dax
> 
> I think we can merge the two into one, i.e. extend _require_log_writes
> to check dax support status only when
> - MOUNT_OPTIONS contains dax, or
> - dax is given as a param explicitly, e.g. _require_log_writes dax
> 
> So old kernels that don't support dax log-writes still _notrun, and new
> kernels that have dax log-writes support could run all log-writes tests,
> like generic/455 and generic/457, in dax environment.
> 
> (I did a quick test with generic/45[57] on v4.15-rc2 kernel, 455 always
> fails due to md5sum mismatch, not sure where the problem is yet; 457 is
> _notrun, perhaps due to there's no dax support on reflink XFS.)

I looked in to generic/455 md5sum mismatch, and it is expected with the
current DAX support found in dm-log-writes.  The issue is that we snoop I/O,
but we *don't* snoop the data written by mmap().

For DAX mmaps, the sync calls msync()/fsync() don't cause writes to the block
driver of flushed page cache pages as they would in the page cache case.
Instead the user writes directly into the persistent memory, and all we see is
a flush call.  For us to properly handle mmap() writes we'll need to catch the
flush happening in dm-log-writes, iterate through the flushed data and copy it
into the dm-log-writes log.

I actually had this implemented in my initial version of the DAX support for
dm-log-writes, but by the time I was ready to merge the DAX flush path had
been removed from DM.  See
commit c3ca015fab6d ("dax: remove the pmem_dax_ops->flush abstraction")
for more info.

I can look at adding some level of flush support back into DM so we can handle
this case.  Until/unless that happens, though, I think we should continue to
make users specifically request DAX+dm-log-writes support that lacks mmap()
data verfication capabilities via _require_log_writes_dax.

Thank you for the feedback.  I'll post an updated patch that takes care of the
rest of your comments.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
