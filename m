Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0EB8B21B00DC1
 for <linux-nvdimm@lists.01.org>; Thu, 16 Nov 2017 13:24:06 -0800 (PST)
Date: Thu, 16 Nov 2017 14:28:15 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [fstests PATCH v3] generic: add test for DAX MAP_SYNC support
Message-ID: <20171116212815.GA27448@linux.intel.com>
References: <CAOQ4uxh25JmAv3DjCp11fAfpHVP=d2sp+=Gk4SxYfBtmOgaUPw@mail.gmail.com>
 <20171025204704.3382-1-ross.zwisler@linux.intel.com>
 <20171025215638.GA30335@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20171025215638.GA30335@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Jan Kara <jack@suse.cz>, Eryu Guan <eguan@redhat.com>, Mike Snitzer <snitzer@redhat.com>, linux-nvdimm@lists.01.org, Josef Bacik <jbacik@fb.com>, Amir Goldstein <amir73il@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, fstests <fstests@vger.kernel.org>, linux-raid@vger.kernel.org, dm-devel@redhat.com, Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ext4 <linux-ext4@vger.kernel.org>, Shaohua Li <shli@kernel.org>, Alasdair Kergon <agk@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Oct 26, 2017 at 08:56:38AM +1100, Dave Chinner wrote:
> On Wed, Oct 25, 2017 at 02:47:04PM -0600, Ross Zwisler wrote:
> > Add a test that exercises DAX's new MAP_SYNC flag.
> > 
> > This test creates a file and writes to it via an mmap(), but never syncs
> > via fsync/msync.  This process is tracked via dm-log-writes, then replayed.
> > 
> > If MAP_SYNC is working the dm-log-writes replay will show the test file
> > with 1MiB of on-media block allocations.  This is because each allocating
> > page fault included an implicit metadata sync.  If MAP_SYNC isn't working
> > (which you can test by fiddling with the parameters to mmap()) the file
> > will be smaller or missing entirely.
> > 
> > Note that dm-log-writes doesn't track the data that we write via the
> > mmap(), so we can't do any data integrity checking.  We can only verify
> > that the metadata writes for the page faults happened.
> > 
> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> .....
> > --- /dev/null
> > +++ b/src/t_map_sync.c
> > @@ -0,0 +1,92 @@
> > +#include <errno.h>
> > +#include <fcntl.h>
> > +#include <stdio.h>
> > +#include <stdlib.h>
> > +#include <string.h>
> > +#include <sys/mman.h>
> > +#include <sys/stat.h>
> > +#include <sys/types.h>
> > +#include <unistd.h>
> > +
> > +#define MiB(a) ((a)*1024*1024)
> > +
> > +/*
> > + * These two defines were added to the kernel via commits entitled
> > + * "mm: Define MAP_SYNC and VM_SYNC flags" and
> > + * "mm: introduce MAP_SHARED_VALIDATE, a mechanism to safely define new mmap
> > + * flags", respectively.
> > + */
> > +#ifndef MAP_SYNC
> > +#define MAP_SYNC 0x80000
> > +#endif
> > +
> > +#ifndef MAP_SHARED_VALIDATE
> > +#define MAP_SHARED_VALIDATE 0x3
> > +#endif
> 
> Autoconf rules for detecting supported functionality, please...

Yep, that's better.  As you've suggested down below I'm adding this
functionality to xfs_io instead, and I've added autoconf rules there.

> > +
> > +void err_exit(char *op)
> > +{
> > +	fprintf(stderr, "%s: %s\n", op, strerror(errno));
> > +	exit(1);
> > +}
> > +
> > +void mark_log(char *logwrites_name, char *mark_name)
> > +{
> > +	char command[256];
> > +
> > +	snprintf(command, 256, "dmsetup message %s 0 mark %s",
> > +			logwrites_name, mark_name);
> > +
> > +	if (system(command))
> > +		err_exit("mark_log");
> > +}
> > +
> > +int main(int argc, char *argv[])
> > +{
> > +	int page_size = getpagesize();
> > +	int len = MiB(1);
> > +	int i, fd, err;
> > +	char *data;
> > +
> > +	if (argc < 4) {
> > +		printf("Usage: %s <file> <logwrites_name> <mark_name>\n",
> > +				basename(argv[0]));
> > +		exit(0);
> > +	}
> > +
> > +	fd = open(argv[1], O_RDWR|O_CREAT|O_TRUNC, S_IRUSR|S_IWUSR);
> > +	if (fd < 0)
> > +		err_exit("fd");
> > +
> > +	ftruncate(fd, len);
> > +
> > +	data = mmap(NULL, len, PROT_READ|PROT_WRITE,
> > +			MAP_SHARED_VALIDATE|MAP_SYNC, fd, 0);
> > +	if (data == MAP_FAILED)
> > +		err_exit("mmap");
> 
> As I say to all these sorts of one-off test prgrams: please add the
> new MAP_SYNC flag to xfs_io rather than writing a one-off
> test program to set it and write some data.
> 
> And if we're going to be adding special custom tests just because
> we need to insert dm-log marks, add that functionality to xfs_io,
> too.
> 
> That way we can create complex custom dm logwrite tests without
> needing one-off test programs for them all...

Yep, that was a better path.  I've got things working - need to clean up and
I'll send out soon.

> > +#! /bin/bash
> > +# FS QA Test No. 466
> > +#
> > +# Use md_log_writes to verify that MAP_SYNC actually syncs metadata during
> 
> dm_log_writes?

Fixed.

> > +# We should see $SCRATCH_MNT/test as having 1MiB in block allocations
> > +du -sh $SCRATCH_MNT/test | _filter_scratch | _filter_spaces
> 
> Perhaps stat -c %b $SCRATCH_MNT/test ?

Maybe, but doesn't the output of 'stat -c %b' depend on the block size the
filesystem is using?  I think to use stat I'd have to check both %b and %B,
and account for different block sizes, or do some shell math.  I think it may
be easier to just use du.

Thank you for the review, sorry for the delayed response.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
