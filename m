Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A4F851A1F60
 for <linux-nvdimm@lists.01.org>; Wed, 11 May 2016 02:59:22 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/7 v4] DAX cleanups and fixes
Date: Wed, 11 May 2016 11:58:46 +0200
Message-Id: <1462960733-29634-1-git-send-email-jack@suse.cz>
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

Hi!

This is another part of the series that implements new DAX page fault locking.
This part contains easy DAX cleanups and fixes that were already reviewed and
are rather obvious so they could be merged right away. They mostly remove
dead unused code. The patches didn't change since the last posting of the DAX
page fault locking series except for some added Reviewed-by tags.

Since DAX error handling patches depend on these I assume they will get merged
through NVDIMM tree.  These patches depend on ext4 fixes from the series "ext4:
DAX fixes". The dependency is mostly functional (these patches remove zeroing
from DAX code and ext4 was depending on this zeroing until the above series
fixed that) so NVDIMM tree should be merged after ext4 tree to avoid breaking
ext4 DAX support.

								Honza
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
