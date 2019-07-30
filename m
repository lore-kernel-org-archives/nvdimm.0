Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com
 [IPv6:2607:f8b0:4864:20::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6B998212E4B76
 for <linux-nvdimm@lists.01.org>; Tue, 30 Jul 2019 14:35:25 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id s184so49031126oie.9
 for <linux-nvdimm@lists.01.org>; Tue, 30 Jul 2019 14:32:54 -0700 (PDT)
MIME-Version: 1.0
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 30 Jul 2019 14:32:42 -0700
Message-ID: <CAPcyv4hJcRY3aop4jgH8NLsz1A8HH7sH6gnGs02Wy8A=p5o=jg@mail.gmail.com>
Subject: [GIT PULL] dax fix for v5.3-rc3
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm dax-fix-5.3-rc3

...to receive a manual fixup I happened to drop. I re-fetched the
patch from the mailing list after integrating the git message-id
support to generate a "Link:" tag [1], but then did not re-apply the
fixup. This now matches what I tested and went into yesterday's -next.

[1]: https://lists.linuxfoundation.org/pipermail/ksummit-discuss/2019-July/006608.html

---

The following changes since commit 609488bc979f99f805f34e9a32c1e3b71179d10b:

  Linux 5.3-rc2 (2019-07-28 12:47:02 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm dax-fix-5.3-rc3

for you to fetch changes up to 61c30c98ef17e5a330d7bb8494b78b3d6dffe9b8:

  dax: Fix missed wakeup in put_unlocked_entry() (2019-07-29 09:24:22 -0700)

----------------------------------------------------------------
dax fix 5.3-rc3

- Fix a botched manual patch update that got dropped between testing and
  application.

----------------------------------------------------------------
Jan Kara (1):
      dax: Fix missed wakeup in put_unlocked_entry()

 fs/dax.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

diff --git a/fs/dax.c b/fs/dax.c
index a237141d8787..b64964ef44f6 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -266,7 +266,7 @@ static void wait_entry_unlocked(struct xa_state
*xas, void *entry)
 static void put_unlocked_entry(struct xa_state *xas, void *entry)
 {
        /* If we were the only waiter woken, wake the next one */
-       if (entry && dax_is_conflict(entry))
+       if (entry && !dax_is_conflict(entry))
                dax_wake_entry(xas, entry, false);
 }
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
