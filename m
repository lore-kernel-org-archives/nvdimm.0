Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 39A8581CE2
 for <linux-nvdimm@lists.01.org>; Tue,  1 Nov 2016 15:45:50 -0700 (PDT)
Date: Tue, 1 Nov 2016 16:45:50 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 0/11] ext4: Convert ext4 DAX IO to iomap framework
Message-ID: <20161101224550.GA2314@linux.intel.com>
References: <1478034381-19037-1-git-send-email-jack@suse.cz>
 <20161101221235.GB9920@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20161101221235.GB9920@dastard>
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
Cc: linux-fsdevel@vger.kernel.org, Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Nov 02, 2016 at 09:12:35AM +1100, Dave Chinner wrote:
> On Tue, Nov 01, 2016 at 10:06:10PM +0100, Jan Kara wrote:
> > Hello,
> > 
> > this patch set converts ext4 DAX IO paths to the new iomap framework and
> > removes the old bh-based DAX functions. As a result ext4 gains PMD page
> > fault support, also some other minor bugs get fixed. The patch set is based
> > on Ross' DAX PMD page fault support series [1]. It passes xfstests both in
> > DAX and non-DAX mode.
> > 
> > The question is how shall we merge this. If Dave is pulling PMD patches through
> > XFS tree, then these patches could go there as well (chances for conflicts
> > with other ext4 stuff are relatively low) or Dave could just export a stable
> > branch with PMD series which Ted would just pull...
> 
> I plan to grab Ross's PMD series in the next couple of days and I'll
> push it out as a stable topic branch once I've sanity tested it.  I
> don't really want to take a big chunk of ext4 stuff through the XFS
> tree if it can be avoided....

Yea, we also need to figure out how to get Jan's "dax: Clear dirty bits after
flushing caches" set merged, which is mostly MM stuff and I think will go
through akpm's tree?  That set is also based on my PMD stuff.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
