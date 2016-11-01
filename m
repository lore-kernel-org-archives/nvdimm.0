Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 59A0781D4C
 for <linux-nvdimm@lists.01.org>; Tue,  1 Nov 2016 14:22:15 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/11] ext4: Convert ext4 DAX IO to iomap framework
Date: Tue,  1 Nov 2016 22:06:10 +0100
Message-Id: <1478034381-19037-1-git-send-email-jack@suse.cz>
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
Cc: linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hello,

this patch set converts ext4 DAX IO paths to the new iomap framework and
removes the old bh-based DAX functions. As a result ext4 gains PMD page
fault support, also some other minor bugs get fixed. The patch set is based
on Ross' DAX PMD page fault support series [1]. It passes xfstests both in
DAX and non-DAX mode.

The question is how shall we merge this. If Dave is pulling PMD patches through
XFS tree, then these patches could go there as well (chances for conflicts
with other ext4 stuff are relatively low) or Dave could just export a stable
branch with PMD series which Ted would just pull...

								Honza

[1] http://www.spinics.net/lists/linux-mm/msg115247.html
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
