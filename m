Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D53C621F2E176
 for <linux-nvdimm@lists.01.org>; Tue, 17 Apr 2018 07:41:03 -0700 (PDT)
Date: Tue, 17 Apr 2018 22:40:59 +0800
From: Xiong Zhou <xzhou@redhat.com>
Subject: ioctl FIBMAP for dax gone in v4.17-rc1
Message-ID: <20180417144059.nwbbynhgq3k3i63q@XZHOUW.usersys.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
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
To: linux-fsdevel@vger.kernel.org
Cc: sandeen@sandeen.net, fstests@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>


Hi,

FIBMAP ioctl call to file in pmem dax mountpoint, both xfs
and ext4, starts to fail on v4.17-rc1 Linus tree.

+fibmap: Invalid argument

Pass on v4.16.
Pass on non-dax mountpoint.

We got these in v4.17-rc1:
6e2608d xfs, dax: introduce xfs_dax_aops
fb094c9 ext2, dax: introduce ext2_dax_aops
5f0663b ext4, dax: introduce ext4_dax_aops

And we don't have ->bmap call in these aops, which may lead
to the ioctl call failure.

Do we have any plan of adding/supporting it ?

xfstests generic/223 covers this issue. If we are not going
to support this call for dax, we need to fix the testcase.

Thanks,
Xiong
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
