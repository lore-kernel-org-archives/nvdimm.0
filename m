Received: from out4436.biz.mail.alibaba.com (out4436.biz.mail.alibaba.com [47.88.44.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A811C2FB6
	for <nvdimm@lists.linux.dev>; Mon, 12 Jul 2021 12:03:10 +0000 (UTC)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0UfXFBmR_1626091362;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0UfXFBmR_1626091362)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 12 Jul 2021 20:02:48 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	LKML <linux-kernel@vger.kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Liu Bo <bo.liu@linux.alibaba.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Liu Jiang <gerry@linux.alibaba.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH v2 0/2] erofs: dio/dax support for non-tailpacking cases
Date: Mon, 12 Jul 2021 20:02:39 +0800
Message-Id: <20210712120241.199903-1-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

This patchset mainly adds preliminary EROFS iomap dio/dax support
for non-tailpacking uncompressed cases.

Direct I/O is useful in certain scenarios for uncompressed files.
For example, double pagecache can be avoid by direct I/O when
loop device is used for uncompressed files containing upper layer
compressed filesystem.

Also, DAX is quite useful for some VM use cases in order to
save guest memory extremely by using the minimal lightweight EROFS.

Tail-packing inline iomap support will be handled later since
currently iomap doesn't support such data pattern, which is
independent to non-tailpacking cases.

Comments are welcome. Thanks for your time on reading this!

Thanks,
Gao Xiang

changes since v1:
 - allow 'dax=always' and 'dax=never' to keep in sync with ext4/xfs

Gao Xiang (1):
  erofs: dax support for non-tailpacking regular file

Huang Jianan (1):
  erofs: iomap support for non-tailpacking DIO

 fs/erofs/Kconfig    |   1 +
 fs/erofs/data.c     | 142 +++++++++++++++++++++++++++++++++++++++++++-
 fs/erofs/inode.c    |   9 ++-
 fs/erofs/internal.h |   4 ++
 fs/erofs/super.c    |  60 ++++++++++++++++++-
 5 files changed, 212 insertions(+), 4 deletions(-)

-- 
2.24.4

