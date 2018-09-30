Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5E5A12115F535
 for <linux-nvdimm@lists.01.org>; Sat, 29 Sep 2018 19:17:01 -0700 (PDT)
From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: [GIT PULL] filesystem-dax fix for 4.19-rc6
Date: Sun, 30 Sep 2018 02:16:57 +0000
Message-ID: <1538273814.24243.65.camel@intel.com>
Content-Language: en-US
Content-ID: <574EDF985B944848B7B3A62FF722AB64@intel.com>
MIME-Version: 1.0
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
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi Greg, please pull from...

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdimm-fixes2-4.19-rc6

...to receive one more urgent fix for 4.19-rc6.

---

The following changes since commit 6bf4ca7fbc85d80446ac01c0d1d77db4d91a6d84:

  Linux 4.19-rc5 (2018-09-23 19:15:18 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdimm-fixes2-4.19-rc6

for you to fetch changes up to f52afc93cd018fe6910133a05d44671192d1aeb0:

  dax: Fix deadlock in dax_lock_mapping_entry() (2018-09-27 10:56:15 -0700)

----------------------------------------------------------------
filesystem-dax for 4.19-rc6

Fix a deadlock in the new for 4.19 dax_lock_mapping_entry() routine.

----------------------------------------------------------------
Jan Kara (1):
      dax: Fix deadlock in dax_lock_mapping_entry()

 fs/dax.c | 1 +
 1 file changed, 1 insertion(+)

commit f52afc93cd018fe6910133a05d44671192d1aeb0
Author: Jan Kara <jack@suse.cz>
Date:   Thu Sep 27 13:23:32 2018 +0200

    dax: Fix deadlock in dax_lock_mapping_entry()
    
    When dax_lock_mapping_entry() has to sleep to obtain entry lock, it will
    fail to unlock mapping->i_pages spinlock and thus immediately deadlock
    against itself when retrying to grab the entry lock again. Fix the
    problem by unlocking mapping->i_pages before retrying.
    
    Fixes: c2a7d2a11552 ("filesystem-dax: Introduce dax_lock_mapping_entry()")
    Reported-by: Barret Rhoden <brho@google.com>
    Signed-off-by: Jan Kara <jack@suse.cz>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/fs/dax.c b/fs/dax.c
index f32d7125ad0f..e4ef8af31aa6 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -447,6 +447,7 @@ bool dax_lock_mapping_entry(struct page *page)
                        xa_unlock_irq(&mapping->i_pages);
                        break;
                } else if (IS_ERR(entry)) {
+                       xa_unlock_irq(&mapping->i_pages);
                        WARN_ON_ONCE(PTR_ERR(entry) != -EAGAIN);
                        continue;
                }
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
