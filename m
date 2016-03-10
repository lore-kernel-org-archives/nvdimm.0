Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C5F6B1A1EF9
 for <linux-nvdimm@lists.01.org>; Thu, 10 Mar 2016 11:18:52 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [RFC] [PATCH 0/12] DAX page fault locking
Date: Thu, 10 Mar 2016 20:18:43 +0100
Message-Id: <1457637535-21633-1-git-send-email-jack@suse.cz>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, NeilBrown <neilb@suse.com>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Hello,

this is my first attempt at DAX page fault locking rewrite. It is mostly
just a dump of current status of my git tree so that people can see where I'm
going before weekend. It should be complete but so far it is only compile
tested.

The basic idea is that we use a bit in an exceptional radix tree entry as
a lock bit and use it similarly to how page lock is used for normal faults.
That way we fix races between hole instantiation and read faults of the
same index. For now I have disabled PMD faults since there the issues with
page fault locking are even worse. I think we will need something like
Matthew's multi-order radix tree to fix the races for PMD faults but I
want to have a look at those once locking for normal pages is working.

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
