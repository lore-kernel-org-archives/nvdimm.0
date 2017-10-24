Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CDB1B21CEB14A
 for <linux-nvdimm@lists.01.org>; Tue, 24 Oct 2017 12:26:41 -0700 (PDT)
Date: Tue, 24 Oct 2017 13:30:22 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 2/2] dm log writes: add support for DAX
Message-ID: <20171024193022.GA4251@linux.intel.com>
References: <20171020052404.13762-1-ross.zwisler@linux.intel.com>
 <20171020052404.13762-2-ross.zwisler@linux.intel.com>
 <20171024192222.GB22902@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20171024192222.GB22902@redhat.com>
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, Josef Bacik <jbacik@fb.com>, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Shaohua Li <shli@kernel.org>, Alasdair Kergon <agk@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Oct 24, 2017 at 03:22:23PM -0400, Mike Snitzer wrote:
> On Fri, Oct 20 2017 at  1:24am -0400,
> Ross Zwisler <ross.zwisler@linux.intel.com> wrote:
> 
> > Now that we have the ability log filesystem writes using a flat buffer, add
> > support for DAX.  Unfortunately we can't easily track data that has been
> > written via mmap() now that the dax_flush() abstraction was removed by this
> > commit:
> > 
> > commit c3ca015fab6d ("dax: remove the pmem_dax_ops->flush abstraction")
> > 
> > Otherwise we could just treat each flush as a big write, and store the data
> > that is being synced to media.  It may be worthwhile to add the dax_flush()
> > entry point back, just as a notifier so we can do this logging.
> > 
> > The motivation for this support is the need for an xfstest that can test
> > the new MAP_SYNC DAX flag.  By logging the filesystem activity with
> > dm-log-writes we can show that the MAP_SYNC page faults are writing out
> > their metadata as they happen, instead of requiring an explicit
> > msync/fsync.
> > 
> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> 
> I've picked this up, please see:
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-4.15/dm&id=ae613bbb0144e84cb3c0ebfa9f4fd4d1507c2f0e
> 
> I tweaked the header and tweaked a couple whitespace nits.  Also
> switched version bump from 1.0.1 to 1.1.0.
> 
> Thanks,
> Mike

Sure, your tweaks look fine.  Thanks!
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
