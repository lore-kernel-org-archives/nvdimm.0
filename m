Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qk0-x242.google.com (mail-qk0-x242.google.com
 [IPv6:2607:f8b0:400d:c09::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7B9E52034C09D
 for <linux-nvdimm@lists.01.org>; Mon, 23 Oct 2017 10:30:29 -0700 (PDT)
Received: by mail-qk0-x242.google.com with SMTP id o187so22968880qke.7
 for <linux-nvdimm@lists.01.org>; Mon, 23 Oct 2017 10:34:12 -0700 (PDT)
Date: Mon, 23 Oct 2017 13:34:09 -0400
From: Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH 2/2] dm log writes: add support for DAX
Message-ID: <20171023173408.z6gog67bdp5s7jzy@destiny>
References: <20171020052404.13762-1-ross.zwisler@linux.intel.com>
 <20171020052404.13762-2-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20171020052404.13762-2-ross.zwisler@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, linux-nvdimm@lists.01.org, Josef Bacik <jbacik@fb.com>, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Shaohua Li <shli@kernel.org>, Alasdair Kergon <agk@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Oct 19, 2017 at 11:24:04PM -0600, Ross Zwisler wrote:
> Now that we have the ability log filesystem writes using a flat buffer, add
> support for DAX.  Unfortunately we can't easily track data that has been
> written via mmap() now that the dax_flush() abstraction was removed by this
> commit:
> 
> commit c3ca015fab6d ("dax: remove the pmem_dax_ops->flush abstraction")
> 
> Otherwise we could just treat each flush as a big write, and store the data
> that is being synced to media.  It may be worthwhile to add the dax_flush()
> entry point back, just as a notifier so we can do this logging.
> 
> The motivation for this support is the need for an xfstest that can test
> the new MAP_SYNC DAX flag.  By logging the filesystem activity with
> dm-log-writes we can show that the MAP_SYNC page faults are writing out
> their metadata as they happen, instead of requiring an explicit
> msync/fsync.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> ---

Ok this is just my ignorance of how DAX works shining through, but do we need a
new flag to indicate this is DAX data?  You are logging it like it's just normal
data going to a certain sector, is that good enough?  If it is then hooray this
looks fine to me, I'm just slightly confused.  Thanks,

Josef
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
