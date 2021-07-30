Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28CAC3481
	for <nvdimm@lists.linux.dev>; Fri, 30 Jul 2021 19:51:55 +0000 (UTC)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0UhT8q23_1627674386;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0UhT8q23_1627674386)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 31 Jul 2021 03:46:38 +0800
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
	Huang Jianan <huangjianan@oppo.com>,
	Tao Ma <boyu.mt@taobao.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH v2 0/3] erofs: iomap support for uncompressed cases
Date: Sat, 31 Jul 2021 03:46:22 +0800
Message-Id: <20210730194625.93856-1-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

This patchset mainly adds EROFS iomap support for uncompressed cases
I've planed for the next merge window.

The first 2 patches mainly deal with 2 new cases:
1) Direct I/O is useful in certain scenarios for uncompressed files.
For example, double pagecache can be avoid by direct I/O when loop
device is used for uncompressed files containing upper layer
compressed filesystem.

2) DAX is quite useful for some container use cases in order to save
guest memory extremely by using the minimal lightweight EROFS image.
BTW, a bit more off this iomap topic, chunk-deduplicated regfile
support is almost available (blob data support) for multi-layer
container image use cases (aka. called RAFS v6, nydus [1] will support
RAFS v6 (EROFS-compatible format) in the future and form a unified
high-performance container image solution, which will be announced
formally independently), which is also a small independent update.

The last patch relies on the previous iomap core update in order to
convert tail-packing inline files into iomap, thus all uncompressed
cases are handled with iomap properly.

Comments are welcome. Thanks for your time on reading this!

Thanks,
Gao Xiang

[1] https://github.com/dragonflyoss/image-service

changes since v1:
 - mainly resend with commit message & comments update.

Gao Xiang (2):
  erofs: dax support for non-tailpacking regular file
  erofs: convert all uncompressed cases to iomap

Huang Jianan (1):
  erofs: iomap support for non-tailpacking DIO

 fs/erofs/Kconfig    |   1 +
 fs/erofs/data.c     | 342 +++++++++++++++++++-------------------------
 fs/erofs/inode.c    |   9 +-
 fs/erofs/internal.h |   4 +
 fs/erofs/super.c    |  60 +++++++-
 5 files changed, 217 insertions(+), 199 deletions(-)

-- 
2.24.4

