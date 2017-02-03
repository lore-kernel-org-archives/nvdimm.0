From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v4 0/2] mmap dio and DAX
Date: Fri, 3 Feb 2017 14:29:52 +0800
Message-ID: <20170203062952.GZ1859@eguan.usersys.redhat.com>
References: <1484878888-11483-1-git-send-email-xzhou@redhat.com>
 <1484892950-25178-1-git-send-email-xzhou@redhat.com>
 <20170124222855.GA26631@linux.intel.com>
 <20170203055717.acjivw4o4zmxhd64@XZHOUW.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170203055717.acjivw4o4zmxhd64@XZHOUW.usersys.redhat.com>
Sender: fstests-owner@vger.kernel.org
To: Xiong Zhou <xzhou@redhat.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, fstests@vger.kernel.org, jmoyer@redhat.com, linux-nvdimm@ml01.01.org
List-Id: linux-nvdimm@lists.01.org

On Fri, Feb 03, 2017 at 01:57:17PM +0800, Xiong Zhou wrote:

> > I just wanted to let you know that I'm testing with these new xfstests right
> > now, and so far I've been unable to successfully get any PMD faults.  I'm
> > looking into why that is right now, and should hopefully have some changes so
> > we can do both PTE and PMD testing with this set.
> 
> Thank you very much for looking into this!
> 
> Adding a printk msg in dax_iomap_pmd_fault in fs/dax.c shows that
> these 2 cases called this function, so do __radix_tree_insert
> in lib/radix-tree.c with order > 0.  I must have missed something..
> 
> > 
> > Also, it looks like the test number "generic/405" was already used in
> > xfstests/master by this commit:
> > 
> > 66768bc generic/405: test mkfs against thin provision device
> > 
> > So this may need to be generic/406. :)
> 
> Ya, i can update this or Eryu can handle it while applying.

I'll do renumber after patch being reviewed, no need to update patch
only to change the seq number. (Better to use latest tree when writing
new case though.)

Thanks,
Eryu
