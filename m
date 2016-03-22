Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by ml01.01.org (Postfix) with ESMTP id 3424E1A1FEA
 for <linux-nvdimm@lists.01.org>; Tue, 22 Mar 2016 12:33:24 -0700 (PDT)
Date: Tue, 22 Mar 2016 13:32:12 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [RFC v2] [PATCH 0/10] DAX page fault locking
Message-ID: <20160322193212.GA11164@linux.intel.com>
References: <1458566575-28063-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1458566575-28063-1-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-nvdimm@lists.01.org, NeilBrown <neilb@suse.com>, Wilcox,
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Mar 21, 2016 at 02:22:45PM +0100, Jan Kara wrote:
> [Sorry for repost but I accidentally sent initial email without patches]
> 
> Hello,
> 
> this is my second attempt at DAX page fault locking rewrite. Things now
> work reasonably well, it has survived full xfstests run on ext4. I guess
> I need to do more mmap targetted tests to unveil issues. Guys what do you
> used for DAX testing?

I typically use xfstests for regression testing.  If we can come up with new
generally useful regression tests, especially ones concerning mmap races, that
would be awesome.  I guess it's just a choice between adding them somewhere in
xfstests or somewhere else like with the unit tests in ndctl.

> Changes since v1:
> - handle wakeups of exclusive waiters properly
> - fix cow fault races
> - other minor stuff
> 
> General description
> 
> The basic idea is that we use a bit in an exceptional radix tree entry as
> a lock bit and use it similarly to how page lock is used for normal faults.
> That way we fix races between hole instantiation and read faults of the
> same index. For now I have disabled PMD faults since there the issues with
> page fault locking are even worse. Now that Matthew's multi-order radix tree
> has landed, I can have a look into using that for proper locking of PMD faults
> but first I want normal pages sorted out.
> 
> In the end I have decided to implement the bit locking directly in the DAX
> code. Originally I was thinking we could provide something generic directly
> in the radix tree code but the functions DAX needs are rather specific.
> Maybe someone else will have a good idea how to distill some generally useful
> functions out of what I've implemented for DAX but for now I didn't bother
> with that.
> 
> 								Honza
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
