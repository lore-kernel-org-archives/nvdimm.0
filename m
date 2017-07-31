Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com
 [66.111.4.25])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3348B21D19940
 for <linux-nvdimm@lists.01.org>; Mon, 31 Jul 2017 09:00:41 -0700 (PDT)
Message-Id: <1501516968.579311.1058393288.0714478A@webmail.messagingengine.com>
From: Colin Walters <walters@verbum.org>
MIME-Version: 1.0
In-Reply-To: <150135741519.35318.16765137368329971936.stgit@dwillia2-desk3.amr.corp.intel.com>
Subject: Re: [PATCH 1/3] fs, xfs: introduce S_IOMAP_IMMUTABLE
References: <150135740948.35318.10730072114996910905.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150135741519.35318.16765137368329971936.stgit@dwillia2-desk3.amr.corp.intel.com>
Date: Mon, 31 Jul 2017 12:02:48 -0400
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
To: Dan Williams <dan.j.williams@intel.com>, darrick.wong@oracle.com
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, luto@kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Jul 29, 2017, at 03:43 PM, Dan Williams wrote:
> An inode with this flag set indicates that the file's block map cannot
> be changed, no size change, deletion, hole-punch, range collapse, or
> reflink.
> 
> The implementation of toggling the flag and sealing the state of the
> extent map is saved for a later patch. The functionality provided by
> S_IOMAP_IMMUTABLE, once toggle support is added, will be a superset of
> that provided by S_SWAPFILE, and it is targeted to replace it.
> 
> For now, only xfs and the core vfs are updated to consider the new flag.

Quite a while ago I started a request for O_OBJECT:
http://www.spinics.net/lists/linux-fsdevel/msg75085.html
A few months ago I was thinking about that more and realized
it'd likely be more palatable to land as an inode flag, like
you're doing here.

Now, S_IOMAP_IMMUTABLE would be quite close to the semantics
I want for ostree, except we also want to disallow
changes to the inode uid, gid or mode.  (Extended attributes are 
a whole other story; but I'd like to at least disallow changes to the
security. namespace).

The goal here is mostly about resilience to *accidental* changes;
think an admin doing `cp /path/to/binary /usr/bin/bash` which
does open(O_TRUNC), which would hence corrupt all hardlinks.

S_IOMAP_IMMUTABLE would give a lot of great protection against
those types of accidental changes - most of them are either going
to be open(O_TRUNC) or O_APPEND.   Since you're touching various
write paths here, perhaps we can also add
S_CONTENTS_IMMUTABLE or something at the same time?

If this lands as is - I'm quite likely to change ostree to use it;
any objections to that?  As mentioned in the thread, there are several
other cases of "content immutable" files in userspace, such as
QEMU "qcow2", git objects.  And really the most classic example is
/etc/sudoers and the need for a special "visudo" program to really
ensure that editors don't do in-place overwrites.

But it'd be great if we can use this push to also land "content immutabilty"
or however we decide to call it.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
