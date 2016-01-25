Return-Path: <owner-linux-mm@kvack.org>
Date: Mon, 25 Jan 2016 12:05:21 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [LSF/MM ATTEND] Persistent Memory, DAX
Message-ID: <20160125190521.GA27042@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: owner-linux-mm@kvack.org
To: lsf-pc@lists.linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-nvdimm@lists.01.org, linux-mm@kvack.org
List-ID: <linux-nvdimm@lists.01.org>

Hi,

I would like to attend LSF/MM this year.  I believe I could contribute to the
following discussions:

Persistent Memory Error Handling from Jeff Moyer:
http://www.spinics.net/lists/linux-mm/msg100560.html

Huge Page Futures from Mike Kravetz:
http://www.spinics.net/lists/linux-mm/msg100646.html

Block & Filesystem Interface from Steve Whitehouse:
http://www.spinics.net/lists/linux-fsdevel/msg93552.html

This past year I have been working on the PMEM persistent memory driver and on
DAX.  Both of these will be impacted by the persistent memory error handling
that will be the subject of Jeff's talk.  DAX currently supports PMD pages and
will probably soon support PUD pages.  Much of my work in DAX has been related
to huge pages, mostly around error handling.

Thanks,
- Ross

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
