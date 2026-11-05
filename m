Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.150
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793861960;
	b=ldss+I0rkQ+flb+tmEObeOi88XG13rrKP1D59OFGrQE2L9GBA9qt5DVx5QqQUDOyeX6u
	 UXU3S+Lc95tiRYM5T1RvEMJsZ7dAE++5rJzp3fNJKStUc/IV/jQM402Bk/G+Bhk9eEDXU
	 zARr9d3oIvSVPqsT3nwM34Tvy5XikxUP3p1m5Hg8XjQw8hZWt0D1mGwjZcYteW7A5XSwu
	 GwZym6uLu+tyyPOzZNWX3zO8KTrmmhJDnYSde+2LzdPlAJZMnuog+ForoqS9K6k1oq6FJ
	 p7OUWsPD5tUuAF1ktAjfwSQcC0ea09UoQQDFXBaZW9gM6fNyH7esmqjsesX1xEUOHCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793861960;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=8CTBv2FsWWNYoIFrDUziKjer08OPepQNcF8zDvYRVUM=;
	b=IEhyrIyCxljnhGva3K9eC6hPWUk+zUfpoT3vi7UnsbqjioBQ+EttNoz3nQLfmd9t1Nzo
	 DEtAtAQwB2JI1wWGf1OZTYp9zQ5F/3bga253/JltQSMqdNgOWwc7+ZzP2FCwdIWreN/zC
	 tixZsb26s5B3Zt+sMO/I8OjWigRuUrE1vXExKbEtnDG+RHy3195zqsW4hF4igjYJNYOSI
	 WDhL/gqdBzgb3rfvlKcpTnCXasWp8yldnb0a1UjRZOBOz2J0Cyz8D325qOHpld0jSlND/
	 N1TdXtBwFeNVDrEDJuDuPbHLeIgu5Nc3U81rozmbhtc3OEg+cARzMRBS3OiS5Cf4ljQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=l+wnEHJf;
	arc=none smtp.remote-ip=91.218.175.150
Received: from mta0.migadu.com (out-150.mta0.migadu.com [91.218.175.150])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E50606A329
	for <nvdimm@lists.linux.dev>; Thu,  5 Nov 2026 06:59:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 64E50606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=l+wnEHJf
X-Envelope-To: nvdimm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=fD7pQ7iJNJUJ2Lt+Fn/kSJBY5hEsxqJHEyhADQZ0hVw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793861952; v=1; x=1794466752;
 b=l+wnEHJf6Oiyr1JLlLvY1SuR55TOc9qTue71B8BOIDVVCSFo+lpfKq7XMsobufkA1UDFYuZg
 S/4hbx3RQyzDu0U7TxzFT70wLujr3gW8YUSoIvIo9yke829B2TSk5zIlzdtImG9Q4nyXjjfNiiI
 9RSLtJX0JrbHg4jDSxSgZSDo=
X-Envelope-To: nvdimm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id deff676cf379e19e;
	Thu, 05 Nov 2026 06:59:12 +0000
X-Mizu-Trace-ID: deff676cf379e19e
X-Migadu-Flow: FLOW_OUT
From: Mengmeng Zhao <mengmeng.zhao@linux.dev>
To: Jens Axboe <axboe@kernel.dk>,
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
	"Darrick J. Wong" <djwong@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	asml.silence@gmail.com,
	hch@lst.de,
	Anuj Gupta <anuj1072538@gmail.com>
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-mm@kvack.org,
	Li Wang <liwang@kylinos.cn>
Subject: [RFC 0/6] ext4: Add dma-buf read/write support
Date: Thu,  5 Nov 2026 14:58:41 +0800
Message-ID: <20261105065847.196540-1-mengmeng.zhao@linux.dev>
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

This series add dma-buf read/write support for ext4. The dma-buf direct
I/O infrastructure allows dma-buf to be handed to file I/O as an iov_iter,
currently it only supports raw device. To better serve the GPU-NVME direct
access through normal filesystem, prior work for XFS has been discussed
at [1]. We also are interested in this field and working on it[2]. This
patchset is based on Anuj Gupta's patchset as there are common parts at
block/iomap. The base tree is:
https://github.com/anuj7781/linux-kernel/tree/anuj/fs-dmabuf-rfc-v11-desc-v2

Patches 1-5 add dma-buf guards at several common paths at block,
mm/filemap, dax and iomap. Patches 6 add dma-buf support for ext4.

[1] https://lore.kernel.org/linux-xfs/20261016091919.971295-1-anuj1072538@gmail.com/
[2] https://lore.kernel.org/all/20260908131545.105987-1-liwang@kylinos.cn/

Mengmeng Zhao (6):
  block: refuse a dma-buf bio that carries a crypto context
  mm/filemap: refuse dmabuf iterators in the generic read/write copy
    paths
  dax: refuse dmabuf iterators in dax_iomap_rw()
  iomap: refuse dmabuf iterators in iomap_file_buffered_write()
  iomap: refuse dmabuf iterators on contents-encrypted inodes
  ext4: support dma-buf registered buffers for direct I/O

 block/blk-mq.c         |  4 +++-
 fs/dax.c               |  4 ++++
 fs/ext4/file.c         | 33 +++++++++++++++++++++++++++++++++
 fs/iomap/buffered-io.c |  7 +++++++
 fs/iomap/direct-io.c   | 10 ++++++++++
 mm/filemap.c           | 22 +++++++++++++++++++++-
 6 files changed, 78 insertions(+), 2 deletions(-)

-- 
2.43.0

