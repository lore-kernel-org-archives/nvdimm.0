Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0FD541A1F60
 for <linux-nvdimm@lists.01.org>; Wed, 11 May 2016 02:39:25 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/4] ext4: DAX fixes
Date: Wed, 11 May 2016 11:39:07 +0200
Message-Id: <1462959551-28622-1-git-send-email-jack@suse.cz>
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
To: Ted Tso <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Hi!

These are ext4 patches that were originally part of my DAX locking patch
series. They stand on their own so I'm submitting them independently and since
they are non-trivial, I'd like them to be merged through ext4 tree.  The rest
of the DAX locking series depends on these patches so whichever tree is going
to merge them will have to pull the ext4 tree to get these patches.  They
didn't change since the last posting of the DAX locking series (except for
minor fixup due to patch reordering).

Ted, can you please queue these patches for the coming merge window? Thanks!

								Honza
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
