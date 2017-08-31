Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9520621EB5281
 for <linux-nvdimm@lists.01.org>; Wed, 30 Aug 2017 21:00:58 -0700 (PDT)
Date: Wed, 30 Aug 2017 22:02:55 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [fstests PATCH] generic: add test for executables on read-only
 DAX mounts
Message-ID: <20170831040255.GB17095@linux.intel.com>
References: <20170829213721.GA27686@linux.intel.com>
 <20170829223715.26507-1-ross.zwisler@linux.intel.com>
 <20170830145103.GA10163@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170830145103.GA10163@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Theodore Ts'o <tytso@mit.edu>, Eryu Guan <eguan@redhat.com>, linux-nvdimm@lists.01.org, Randy Dodgen <rdodgen@gmail.com>, fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Aug 30, 2017 at 07:51:03AM -0700, Christoph Hellwig wrote:
> > The above patch fixes an issue with ext4 where executables cannot be run on
> > read-only filesystems mounted with the DAX option.
> > 
> > This issue does not appear to be present in ext2 or XFS, as they both pass
> > the test.  I've also confirmed outside of the test that they are both
> > indeed able to execute binaries on read-only DAX mounts.
> 
> It works for me on XFS.  But I don't really understand why, as the fault
> handler doesn't look very different.
> 
> Maybe the problem is that in ext4_journal_start_sb will fail on
> a read-only fs?
> 
> Even for xfs/ext2 it would seem odd that things like sb_start_pagefault
> just work. 
> 
> > +LS=$(which ls --skip-alias --skip-functions) 2>/dev/null
> > +if [ $? -ne 0 ]; then
> > +	status=$?
> > +	echo "Couldn't find 'ls'!?"
> > +	exit
> > +fi
> 
> These checks all fail for me..

Huh...really?  I'll send out v2 in a second, but if that fails for you as well
can you try and give me a hint as to what's going wrong with the test in your
setup?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
