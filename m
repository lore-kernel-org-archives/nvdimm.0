Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CCAA61A2270
 for <linux-nvdimm@lists.01.org>; Mon, 18 Apr 2016 14:35:51 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [RFC v3] [PATCH 0/18] DAX page fault locking
Date: Mon, 18 Apr 2016 23:35:23 +0200
Message-Id: <1461015341-20153-1-git-send-email-jack@suse.cz>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Hello,

this is my third attempt at DAX page fault locking rewrite. The patch set has
passed xfstests both with and without DAX mount option on ext4 and xfs for
me and also additional page fault beating using the new page fault stress
tests I have added to xfstests. So I'd be grateful if you guys could have a
closer look at the patches so that they can be merged. Thanks.

Changes since v2:
- lot of additional ext4 fixes and cleanups
- make PMD page faults depend on CONFIG_BROKEN instead of #if 0
- fixed page reference leak when replacing hole page with a pfn
- added some reviewed-by tags
- rebased on top of current Linus' tree

Changes since v1:
- handle wakeups of exclusive waiters properly
- fix cow fault races
- other minor stuff

General description

The basic idea is that we use a bit in an exceptional radix tree entry as
a lock bit and use it similarly to how page lock is used for normal faults.
That way we fix races between hole instantiation and read faults of the
same index. For now I have disabled PMD faults since there the issues with
page fault locking are even worse. Now that Matthew's multi-order radix tree
has landed, I can have a look into using that for proper locking of PMD faults
but first I want normal pages sorted out.

In the end I have decided to implement the bit locking directly in the DAX
code. Originally I was thinking we could provide something generic directly
in the radix tree code but the functions DAX needs are rather specific.
Maybe someone else will have a good idea how to distill some generally useful
functions out of what I've implemented for DAX but for now I didn't bother
with that.

								Honza
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
