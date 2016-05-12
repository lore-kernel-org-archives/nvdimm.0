Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1D2871A1F4A
 for <linux-nvdimm@lists.01.org>; Thu, 12 May 2016 09:29:34 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/7 v4] DAX page fault locking
Date: Thu, 12 May 2016 18:29:13 +0200
Message-Id: <1463070560-1979-1-git-send-email-jack@suse.cz>
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
To: linux-nvdimm@lists.01.org
Cc: Ted Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Hello,

this is my fourth attempt at DAX page fault locking rewrite. The patch set has
passed xfstests both with and without DAX mount option on ext4 and xfs for
me (including new xfstests for stressing DAX mmap behavior). Also all tests
are passing for Ross now. All the patches except for PMD fault handling ones
got reviewed by Ross so I think they are in a reasonably good shape. For now
I'm not aware of any outstanding issues so can we merge the patches through
NVDIMM tree please?

Changes since v3:
- split patch set into three - ext4 bits, cleanups & easy fixes, this part
- fixed missed wakeups on exceptional entry locks (Ross)
- fixed misaccounting of number of used entries in a radix tree node
- fixed bad interaction with workingset code
- other minor changes based on review comments

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

								Honza
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
