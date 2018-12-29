Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 414432118FF2F
 for <linux-nvdimm@lists.01.org>; Sat, 29 Dec 2018 11:52:59 -0800 (PST)
From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: [GIT PULL] dax fix for 4.21
Date: Sat, 29 Dec 2018 19:52:56 +0000
Message-ID: <b7f5fe8af0fe10a9aeabf4b48a7cf8c126676c24.camel@intel.com>
Content-Language: en-US
Content-ID: <8B71ED7FF2DD1043A6A396D99AE992DF@intel.com>
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
To: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/dax-fix-4.21

...to receive a single fix for an issue you identified on the last dax
fix pull request. While I feel a bit silly sending a single-commit
pull-request there is nothing else queued up for dax this cycle. This
change has shipped in -next for multiple releases.

---

The following changes since commit 7566ec393f4161572ba6f11ad5171fd5d59b0fbd:

  Linux 4.20-rc7 (2018-12-16 15:46:55 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/dax-fix-4.21

for you to fetch changes up to d8a706414af4827fc0b4b1c0c631c607351938b9:

  dax: Use non-exclusive wait in wait_entry_unlocked() (2018-12-21 11:35:53 -0800)

----------------------------------------------------------------
dax fix 4.21

* Clean up unnecessary usage of prepare_to_wait_exclusive()

----------------------------------------------------------------
Dan Williams (1):
      dax: Use non-exclusive wait in wait_entry_unlocked()

 fs/dax.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
