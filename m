Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 89B6122198F63
 for <linux-nvdimm@lists.01.org>; Thu, 21 Dec 2017 08:26:13 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/2 v2] ext4: Fix ENOSPC handling for DAX faults
Date: Thu, 21 Dec 2017 17:30:53 +0100
Message-Id: <20171221163055.3943-1-jack@suse.cz>
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
To: linux-ext4@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org, Ted Tso <tytso@mit.edu>
List-ID: <linux-nvdimm@lists.01.org>

Hello,

these two patches fix handling of ENOSPC during DAX faults. The problem is
that currently running transaction may be holding lots of already freed
blocks which can be reallocated only once the transaction commits. Standard
retry logic in ext4_iomap_end() does not work for DAX page fault handler
since we hold current transaction open in ext4_dax_huge_fault() and thus
retry logic cannot force the running transaction and as a result application
gets SIGBUS due to premature ENOSPC error.

Changes since v1:
* Made error passed back from dax_iomap_fault() explicitely be only the error
  from ->iomap_begin()

Comments are welcome.

								Honza
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
