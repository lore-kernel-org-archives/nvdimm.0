Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wm0-x242.google.com (mail-wm0-x242.google.com
 [IPv6:2a00:1450:400c:c09::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 49D761A1FB9
 for <linux-nvdimm@lists.01.org>; Thu, 14 Apr 2016 20:20:18 -0700 (PDT)
Received: by mail-wm0-x242.google.com with SMTP id y144so2573564wmd.0
 for <linux-nvdimm@lists.01.org>; Thu, 14 Apr 2016 20:20:18 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 15 Apr 2016 11:20:16 +0800
Message-ID: <CADJHv_sawA8SXviUX6My5MKeqWMLbWLG=DrM7RCgrjkjGj2f5Q@mail.gmail.com>
Subject: binary execution from DAX mount hang since next-20160407
From: Xiong Zhou <jencce.kernel@gmail.com>
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
To: hughd@google.com, Linux-Next <linux-next@vger.kernel.org>
Cc: Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hi, all

Since tag next-20160407 in linux-next repo, executing binary
from/in DAX mount hangs.

It does not hang if mount without dax option.
It hangs with both xfs and ext4.
It does not hang if execute from a -t tmpfs mount.
It does not hang on next-20160406 and still hangs on 0414 tree.

# ps -axjf
...
S+       0   0:00  |       \_ sh -x thl.sh
R+       0  42:33  |           \_ [hl]
..
# cat thl.sh
mkfs.ext4 /dev/pmem0
mount -o dax /dev/pmem0 /daxmnt
cp hl /daxmnt
/daxmnt/hl
# cat hl.c
void main()
{
        printf("ok\n");
}
# cc hl.c -o hl

Bisecting commits between 0406 and 0407 tag, points to this:

d7c7d56ca61aec18e5e0cb3a64e50073c42195f7 is the first bad commit
commit d7c7d56ca61aec18e5e0cb3a64e50073c42195f7
Author: Hugh Dickins <hughd@google.com>
Date:   Thu Apr 7 14:00:12 2016 +1000

    huge tmpfs: avoid premature exposure of new pagetable

Bisect log and config are attatched.

Thanks,
Xiong
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
