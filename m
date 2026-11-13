Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.164
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794553608;
	b=RX9EwGFslXmof8HfAouXg1x+TCQUYPutPsN03D6ssgPMX8Ee5YtUV8wT3p43b43JHHFa
	 EHeUi+/GX7WdJsJCexWqiHutTVbTmgx8JyCkXeIpynrgN98QYKxAzbefMUO6N6TU95qlw
	 YdGyiYiDLNXt2hsPR71VOvOy7EW8EO7RXuNOD2xbFDb1mab33MM4vxF62Q1GnDSYSJWBK
	 b6GC6PkdW239Kom+pU592dEnl88Js8pqpHcJZGfDdZ/8Bgqn7jp+WX+Wv1hyRfYn8M4Qo
	 PBwYg08J/JcatCmqoOVtSupzY9ySUfQ4au2yT6Jklipo9xXmaQ8NrIqh7hO8E8AlPNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794553608;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=tz/3kHKfP5O1F2qPHz5sww7BaOT1KLvA0dXNCk/OZIk=;
	b=o4X6H0x7LAVjW3YTjbcAX76Mzx+NFOCEi6ncIiX8Hcbg40+2zMhP4seaWtIMzQEif4P3
	 FQIp9ABZVkG1weUWyc9VE88E0qTSDR8HB9XuWMnUCQGMLtaj1nCNnUQ8ug/Hl47Vruma8
	 3/2TX803KUGPQhQ9Sah1VKgRD5TikoLCmAOHxSzUeynRKMJBK5CFjHhzM/n/yR/XkrfLN
	 mVFPrrsYP90BR5ECMhqyfssnPagbV0qMz8yw9SmYS2Y5YKmkcW9hP0bHVxoXRsGM91O0r
	 okP+YxEQV/U1v1BhRt/l+FLt9nXzWrQM2qfz0UXsFgVBwqF6g1UKYqb1NOHP/98zRZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=HCTOAUYa;
	arc=none smtp.remote-ip=91.218.175.164
Received: from mta0.migadu.com (out-164.mta0.migadu.com [91.218.175.164])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F923606A333
	for <nvdimm@lists.linux.dev>; Fri, 13 Nov 2026 07:06:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2F923606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=HCTOAUYa
X-Envelope-To: nvdimm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=ERnLBl8wC0u2PnoqT3bHbS7adfW2xOd+NgxfHeJjTDM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794553605; v=1; x=1795158405;
 b=HCTOAUYaFgw7pCqA4CZGypARO6Cef0gopMDQw7f6zI2rbiMuJl8KzhnkRlN0iwFGKh7n+YMh
 gge6Au3wmDjj1hQpAyFgYcykBgleRShCzVf2vlcrK6iyhYtm8lcHnemvKUZZsebFB9ivJLTQnOp
 MRCIeO5ZTYWLXWEeDd/W4vFs=
X-Envelope-To: nvdimm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 089f84f20e46ec29;
	Fri, 13 Nov 2026 07:06:44 +0000
X-Mizu-Trace-ID: 089f84f20e46ec29
X-Migadu-Flow: FLOW_OUT
From: Mengmeng Zhao <mengmeng.zhao@linux.dev>
To: Christoph Hellwig <hch@lst.de>,
	Anuj Gupta <anuj1072538@gmail.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	christian.koenig@amd.com,
	Philipp Stanner <phasta@kernel.org>,
	Dan Williams <djbw@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	tytso@mit.edu,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	asml.silence@gmail.com,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	Li Wang <liwang@kylinos.cn>,
	Mengmeng Zhao <zhaomengmeng@kylinos.cn>
Subject: [RFC PATCH v2 0/8] ext4: Add dma-buf read/write support
Date: Fri, 13 Nov 2026 15:06:13 +0800
Message-ID: <20261113070621.273953-1-mengmeng.zhao@linux.dev>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mengmeng Zhao <zhaomengmeng@kylinos.cn>

This series adds dma-buf read/write support for ext4. The dma-buf direct
I/O infrastructure allows dma-buf to be handed to file I/O as an iov_iter,
but currently it only supports raw block devices. To better serve the
GPU-NVMe direct access through normal filesystems, prior work for XFS has
been discussed at [1]. We are also interested in this field and working on
it [2].

The series is based on v7.4-rc2 (7475ea8b5861), which already contains
the common dma-buf direct I/O infrastructure, so it no longer depends on a
separate base tree.
Patches 1-2 carry the block and iomap prerequisites from Nitesh Shetty and
Anuj Gupta:
- bdev_init_dma_buf_io_ctx in patch 1 was moved to block/bdev.c as
suggested by Christoph.
- iomap_file_init_dma_buf_io_ctx from that series is not carried. ext4
calls bdev_init_dma_buf_io_ctx directly, and the capability check is
handled by FMODE_CAN_DMABUF_IO.

The design is:
- FMODE_CAN_DMABUF_IO marks files that can be the target of dma-buf I/O;
  a filesystem sets it at open time for inodes whose data can be reached
  without the page cache.
- dma_buf_io_ctx_create() refuses files that lack the flag and checks the
  current f_flags for O_DIRECT at registration.
- As F_SETFL can clear O_DIRECT afterwards, the paths that would fall back
  to buffered or copied I/O still need per-I/O checks in the callers.
- DAX is rechecked per I/O because it can be enabled after open.
- iomap must not ask for a buffered fallback on behalf of a dma-buf
  iterator: -ENOTBLK would be refused by the callers and would turn a
  failure into a successful transfer of zero bytes.

Patch 3 keeps the buffered fallback out of dma-buf I/O, patches 4-7 add
the refusals on the common paths and the capability flag, and patch 8
enables ext4.

Known limitation: 
1. A dma-buf read that reaches a hole or an unwritten
extent fails as a whole, even when an earlier mapped extent was already
transferred into the buffer, so the caller does not learn how much of the
dma-buf was filled.  Reporting the prefix instead would return a short
read, which callers cannot tell apart from the end of the file, and both
the buffered and the direct path normally hide holes by zero-filling.
Probing the mapping before submitting anything would fix it, but that
belongs to the common iomap series.

2. A refused dma-buf I/O reaches the caller as -EOPNOTSUPP through
iomap_dio_set_error(), which also emits an fserror notification even
though no I/O was submitted.  The report could be limited to requests
that did submit a bio, since iomap_dio_bio_iter() accounts dio->size at
submission time, but that changes what fserror users see for every iomap
filesystem, so this version leaves it as it is and asks the fserror
maintainers.

Testing:
- io_uring dma-buf suite (udmabuf + REGISTER_BUFFERS_UPDATE + READ_FIXED /
  WRITE_FIXED) against ext4 on a PCIe NVMe namespace, all passed.
- xfstests -g quick on ext4 devices: 689 tests ran, 11 reported  failures,
  all of them environment related, no failure is attributable to this 
  series.

[1] https://lore.kernel.org/linux-xfs/20261016091919.971295-1-anuj1072538@gmail.com/
[2] https://lore.kernel.org/all/20260908131545.105987-1-liwang@kylinos.cn/

Changelog:
==========
RFC v2:
- Rebased onto v7.4-rc2 and dropped the dependency on a separate base
  tree; the block and iomap prerequisites are patches 1-2.
- Added patch 3, which reports why a dma-buf direct I/O could not be done
  instead of asking for a buffered fallback that the callers refuse.
- Split the block changes: patch 4 only factors the integrity check
  into a helper, and patch 5 refuses a dma-buf bio in the inline
  encryption fallback, which is where the data pages are walked
  instead of in blk_mq_submit_bio(). (Christoph)
- Dropped the mm/filemap and iomap_file_buffered_write() guards; the
  refusals now happen in the callers that would fall back to buffered
  or copied I/O. (Christoph)
- Added the FMODE_CAN_DMABUF_IO flag and use it to check whether a bdev or
  a filesystem can do dma-buf I/O. (Christoph)

RFC v1:
- https://lore.kernel.org/all/20261105065847.196540-1-mengmeng.zhao@linux.dev/

Mengmeng Zhao (6):
  iomap: don't ask for a buffered fallback for dma-buf iterators
  blk-mq: factor out a dma-buf bio refusal helper
  blk-crypto: refuse dma-buf bios in the fallback path
  fs: add FMODE_CAN_DMABUF_IO and require it for dma-buf I/O contexts
  dax: refuse dma-buf iterators in dax_iomap_rw()
  ext4: support dma-buf registered buffers for direct I/O

Nitesh Shetty (2):
  block: factor out bdev_init_dma_buf_io_ctx()
  iomap: add dma-buf direct I/O guards

 .../filesystems/iomap/operations.rst          |  3 ++
 block/bdev.c                                  | 14 ++++++
 block/blk-crypto.c                            |  8 ++++
 block/blk-mq.c                                | 24 ++++++----
 block/fops.c                                  | 12 +----
 drivers/dma-buf/dma-buf-io.c                  | 13 ++++--
 fs/dax.c                                      |  4 ++
 fs/ext4/ext4.h                                | 11 +++++
 fs/ext4/file.c                                | 44 +++++++++++++++++--
 fs/iomap/direct-io.c                          | 41 +++++++++++++++--
 include/linux/blkdev.h                        |  8 ++++
 include/linux/fs.h                            |  8 +++-
 12 files changed, 159 insertions(+), 31 deletions(-)


base-commit: 7475ea8b58616b33c04afb976cf0fbaad9dd63fb
-- 
2.43.0

