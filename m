Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.126
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795688610;
	b=U2X9Jr64Ctct51vuQMENJiR90o+KUgwpeeW9fe7b5VapUfEvA8hqDTVAT6ZHDnh61Avf
	 8MFRh1t6GNQE6mvUvCLohZMp0Hk+YBZ3UnKB1xoU18lhpRRg3rjXUeRc2u+Q2vQHHwNxD
	 H6ZXDdrXJoQebZMMKkLbCu5qSBVlk1FK02v8G0ZtNNGqpc/s0lyHHG4FYNb9E6Jo+RS27
	 DdPj0JDAKA4K8T942fz4U5dqn9XlWIl99Mb6rRT/ym0N9DniqrLHpTX7Ycamyz+x7N33l
	 n4pHoAqgLC3zl20a6bT1c4Q2e5YvpPMcjFtRxM7tccUXXtZFHeN+YhZy8otorg3WGnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795688610;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=Djjd1SsMnHYhF1VCm8h+rLsGfSQLvywA+Lvp0R6m6sE=;
	b=rdNyg8gG+1V1xiud5ejsi6tgVcPkETnE1uSpmp+BnfXxMI7mjn+WpXGGg4PoexcuBAsO
	 Gj6N00V0ahnFOYYj+bTmAKQjm6mVFlJWb6xGKVO3T1x65jHUC7NKhUYvYqOddIfgSKtmC
	 COaA1YtTTO8ZZmJyr2DJ6w831h5H0nRgLtgPkyzsF9hfy82focrzi2EQRN+8iaOZp0iY4
	 bFZNVlw+2DDhRZav2QT+35RpOYJfeY/H1oLMvw9bIbE40oo5yQeGz6wWtF2lNE/Zv1bFD
	 ZBS2l/15BCm2G24oAgc+SYYb0vuoxb4jGKcN7VVdhgJrBDotF0RouX+wJutuPRW4cKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=l9AqAR9u;
	arc=none smtp.remote-ip=91.218.175.126
Received: from mta0.migadu.com (out-126.mta0.migadu.com [91.218.175.126])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE69606A31E
	for <nvdimm@lists.linux.dev>; Thu, 26 Nov 2026 10:23:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7BE69606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=l9AqAR9u
X-Envelope-To: nvdimm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=SE31xivb4Of1jeX735no3fJM75rqVpEISS9wXSOvIas=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795688607; v=1; x=1796293407;
 b=l9AqAR9u+/WktkK8Ufk+89zPdDwdnfu3yMpOqTNJajQnxkN46LfFVJJ0twZovbWmwUcN6Ytm
 H4OCMyxgV5X0LKk1x6UH17JqW/mL+Rt0FHCQ8StH+GTaYe+qijjpdPT5Rdibpg0rkkQUoxDCbKS
 GOZKsXZdPB+5OxchguUycy94=
X-Envelope-To: nvdimm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 433cdf8521d10379;
	Thu, 26 Nov 2026 10:23:26 +0000
X-Mizu-Trace-ID: 433cdf8521d10379
X-Migadu-Flow: FLOW_OUT
Message-ID: <bff85d7b-84dd-4f4a-91c1-7f5c9ef2e51a@linux.dev>
Date: Thu, 26 Nov 2026 18:23:06 +0800
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 2/8] iomap: add dma-buf direct I/O guards
To: Yun Wang <arsenova@a7snv.com>, Anuj Gupta <anuj1072538@gmail.com>,
 Nitesh Shetty <nj.shetty@samsung.com>
Cc: hch@lst.de, anuj20.g@samsung.com, axboe@kernel.dk,
 sumit.semwal@linaro.org, christian.koenig@amd.com, phasta@kernel.org,
 djbw@kernel.org, willy@infradead.org, jack@suse.cz, viro@zeniv.linux.org.uk,
 brauner@kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 libaokun@linux.alibaba.com, ojaswin@linux.ibm.com, ritesh.list@gmail.com,
 yi.zhang@huawei.com, asml.silence@gmail.com, corbet@lwn.net,
 skhan@linuxfoundation.org, rdunlap@infradead.org, liwang@kylinos.cn,
 zhaomengmeng@kylinos.cn, mcgrof@kernel.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-ext4@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org
References: <20261125171600.4053585-1-arsenova@a7snv.com>
From: Mengmeng Zhao <mengmeng.zhao@linux.dev>
In-Reply-To: <20261125171600.4053585-1-arsenova@a7snv.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 11/26/26 01:16, Yun Wang wrote:
> On Fri, Nov 13, 2026 at 03:06:15PM +0800, Mengmeng Zhao wrote:
>>  static int iomap_dio_hole_iter(struct iomap_iter *iter, struct iomap_dio *dio)
>>  {
>> -	loff_t copied = iov_iter_zero(iomap_length(iter), dio->submit.iter);
>> +	loff_t copied;
>> +
>> +	/* zero-filling walks the data pages */
>> +	if (iov_iter_is_dmabuf_map(dio->submit.iter))
>> +		return -EOPNOTSUPP;
> 
> This also fails reads that run past EOF.  The filesystem maps the range
> beyond the last block as a hole too, so a dma-buf read that starts
> before EOF and ends past the last block of the file fails as a whole,
> while the same O_DIRECT read into user memory returns the bytes up to
> EOF.
> 
> I found it while testing the series for fastsafetensors' dma-buf copier
> [1], which loads model weights from NVMe into GPU memory with READ_FIXED
> into registered dma-bufs.  I ran v2 on top of v7.4-rc2 in a QEMU guest
> with an emulated NVMe namespace, reading into udmabufs.  With a
> 5000-byte file on ext4 with 4 KiB blocks, reading [4096, 12288):
> 
>   READ_FIXED into a registered udmabuf -> -EOPNOTSUPP
>   O_DIRECT pread() into user memory    -> 904
> 
> It fails the same way whether the read is the first one on the buffer,
> is issued inline once the map exists, or is forced to io-wq with
> IOSQE_ASYNC.
> 
> Reading a file in fixed-size chunks hits this on the last chunk unless
> the file size is a multiple of the chunk size.  With 1 KiB blocks it
> also breaks the copier's normal pattern, 4 KiB-aligned reads up to
> round_up(i_size, 4096): the last read fails.
> 
> Nothing past EOF is reported to the caller anyway: __iomap_dio_rw()
> reverts the iterator to i_size and iomap_dio_complete() truncates the
> result to it.  So a hole that starts at or after EOF can be stepped
> over; a hole inside the file still needs zeroes and still fails.
> Something like this on top of the series, or folded into this patch:
> 
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index 83fda6973bb9..2de6d379f811 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -596,9 +596,20 @@ static int iomap_dio_hole_iter(struct iomap_iter *iter, struct iomap_dio *dio)
>  {
>  	loff_t copied;
>  
> -	/* zero-filling walks the data pages */
> -	if (iov_iter_is_dmabuf_map(dio->submit.iter))
> -		return -EOPNOTSUPP;
> +	if (iov_iter_is_dmabuf_map(dio->submit.iter)) {
> +		u64 length = iomap_length(iter);
> +
> +		/* zero-filling walks the data pages */
> +		if (iter->pos < dio->i_size)
> +			return -EOPNOTSUPP;
> +		/*
> +		 * Past EOF there is nothing to zero: the read is truncated to
> +		 * i_size before it is reported, so step over the hole.
> +		 */
> +		iov_iter_advance(dio->submit.iter, length);
> +		dio->size += length;
> +		return iomap_iter_advance(iter, length);
> +	}
>  
>  	copied = iov_iter_zero(iomap_length(iter), dio->submit.iter);
>  
> 
> Signed-off-by: Yun Wang <arsenova@a7snv.com>
> 
> With it, the read above returns 904 with the right data in all three
> cases.  Holes and unwritten extents inside the file still return
> -EOPNOTSUPP, including a hole that straddles EOF after the file was
> extended with ftruncate().
> 
> The rest of the series behaved as the cover letter describes in that
> setup, with 4 KiB and 1 KiB blocks: registration on an O_DIRECT file,
> reads into arbitrary offsets of the buffer, reads through a dup()ed fd,
> -EBADF through another file's slot, -EINVAL when registering a buffered
> fd, -EOPNOTSUPP after F_SETFL clears O_DIRECT and success again once it
> is set back, WRITE_FIXED including a write that extends the file, and a
> clean e2fsck afterwards.  I have not run it on real NVMe hardware or
> xfstests yet.
> 
> This report and the reproducer below were drafted with the help of an
> AI coding assistant (Claude Opus 5.5); the fix is mine.
> 
> [1] https://github.com/foundation-model-stack/fastsafetensors/issues/139
> 
> Thanks,
> Yun
> 
> Reproducer.  It needs /dev/udmabuf and a filesystem with this series
> on an NVMe namespace:
> 
>   head -c 5000 /dev/urandom > /mnt/f && sync
>   ./dmabuf_eof_read /mnt/f 4096 8192             # first read on the buffer
>   ./dmabuf_eof_read /mnt/f 4096 8192 warm        # map exists, inline issue
>   ./dmabuf_eof_read /mnt/f 4096 8192 warm async  # IOSQE_ASYNC
> 
> // SPDX-License-Identifier: GPL-2.0
> /*
>  * Read a file range into a udmabuf that is registered against the file as
>  * an io_uring fixed buffer, and compare with an O_DIRECT pread() of the
>  * same range into user memory.
>  *
>  *   dmabuf_eof_read <file> <offset> <length> [warm] [async]
>  *
>  *   warm   first read [0, 4096) through the same buffer, so the dma-buf map
>  *          exists and the measured read can be issued inline (nonblocking)
>  *   async  set IOSQE_ASYNC on the measured read (issue it from io-wq)
>  *
>  * Exits 0 when READ_FIXED returns what pread() returns and the bytes match.
>  * Needs /dev/udmabuf, and a kernel and filesystem with io_uring dma-buf
>  * registered buffers.  The UAPI bits are declared locally because they are
>  * newer than most installed headers.
>  */
> #define _GNU_SOURCE
> #include <errno.h>
> #include <fcntl.h>
> #include <stdint.h>
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <sys/ioctl.h>
> #include <sys/mman.h>
> #include <sys/syscall.h>
> #include <unistd.h>
> #include <linux/udmabuf.h>
> 
> #define IORING_OFF_SQ_RING		0ULL
> #define IORING_OFF_SQES			0x10000000ULL
> #define IORING_ENTER_GETEVENTS		(1U << 0)
> #define IORING_REGISTER_BUFFERS2	15
> #define IORING_REGISTER_BUFFERS_UPDATE	16
> #define IORING_RSRC_REGISTER_SPARSE	(1U << 0)
> #define IORING_RSRC_UPDATE_EXTENDED	(1U << 1)
> #define IO_REGBUF_TYPE_DMABUF		2
> #define IORING_OP_READ_FIXED		4
> #define IOSQE_ASYNC			(1U << 4)
> 
> struct sqe {
> 	uint8_t opcode, flags;
> 	uint16_t ioprio;
> 	int32_t fd;
> 	uint64_t off, addr;
> 	uint32_t len, rw_flags;
> 	uint64_t user_data;
> 	uint16_t buf_index, personality;
> 	int32_t splice_fd_in;
> 	uint64_t addr3, pad2;
> };
> 
> struct cqe {
> 	uint64_t user_data;
> 	int32_t res;
> 	uint32_t flags;
> };
> 
> struct sq_offsets {
> 	uint32_t head, tail, ring_mask, ring_entries, flags, dropped, array, resv1;
> 	uint64_t user_addr;
> };
> 
> struct cq_offsets {
> 	uint32_t head, tail, ring_mask, ring_entries, overflow, cqes, flags, resv1;
> 	uint64_t user_addr;
> };
> 
> struct params {
> 	uint32_t sq_entries, cq_entries, flags, sq_thread_cpu, sq_thread_idle;
> 	uint32_t features, wq_fd, resv[3];
> 	struct sq_offsets sq_off;
> 	struct cq_offsets cq_off;
> };
> 
> struct rsrc_register {
> 	uint32_t nr, flags;
> 	uint64_t resv2, data, tags;
> };
> 
> struct rsrc_update2 {
> 	uint32_t offset, flags;
> 	uint64_t data, tags;
> 	uint32_t nr, resv2;
> };
> 
> struct regbuf_desc {
> 	uint32_t type, flags;
> 	uint64_t size, uaddr;
> 	int32_t dmabuf_fd, target_fd;
> 	uint64_t resv[6];
> };
> 
> _Static_assert(sizeof(struct sqe) == 64, "io_uring_sqe");
> _Static_assert(sizeof(struct cqe) == 16, "io_uring_cqe");
> _Static_assert(sizeof(struct params) == 120, "io_uring_params");
> _Static_assert(sizeof(struct rsrc_register) == 32, "io_uring_rsrc_register");
> _Static_assert(sizeof(struct rsrc_update2) == 32, "io_uring_rsrc_update2");
> _Static_assert(sizeof(struct regbuf_desc) == 80, "io_uring_regbuf_desc");
> 
> struct ring {
> 	int fd;
> 	struct params p;
> 	char *rings;
> 	struct sqe *sqes;
> };
> 
> static void die(const char *what)
> {
> 	perror(what);
> 	exit(2);
> }
> 
> static void ring_init(struct ring *r)
> {
> 	size_t sq_size, cq_size;
> 
> 	memset(r, 0, sizeof(*r));
> 	r->fd = syscall(SYS_io_uring_setup, 4, &r->p);
> 	if (r->fd < 0)
> 		die("io_uring_setup");
> 	sq_size = r->p.sq_off.array + r->p.sq_entries * sizeof(uint32_t);
> 	cq_size = r->p.cq_off.cqes + r->p.cq_entries * sizeof(struct cqe);
> 	/* SQ and CQ rings share one mapping (IORING_FEAT_SINGLE_MMAP) */
> 	r->rings = mmap(NULL, sq_size > cq_size ? sq_size : cq_size,
> 			PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE, r->fd,
> 			IORING_OFF_SQ_RING);
> 	r->sqes = mmap(NULL, r->p.sq_entries * sizeof(struct sqe),
> 		       PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE, r->fd,
> 		       IORING_OFF_SQES);
> 	if (r->rings == MAP_FAILED || r->sqes == MAP_FAILED)
> 		die("mmap ring");
> }
> 
> /* one READ_FIXED from slot 0; addr is the byte offset into the dma-buf */
> static int read_fixed(struct ring *r, int fd, off_t off, size_t len,
> 		      uint64_t buf_off, uint8_t sqe_flags)
> {
> 	uint32_t *sq_tail = (uint32_t *)(r->rings + r->p.sq_off.tail);
> 	uint32_t sq_mask = *(uint32_t *)(r->rings + r->p.sq_off.ring_mask);
> 	uint32_t *sq_array = (uint32_t *)(r->rings + r->p.sq_off.array);
> 	uint32_t *cq_head = (uint32_t *)(r->rings + r->p.cq_off.head);
> 	uint32_t *cq_tail = (uint32_t *)(r->rings + r->p.cq_off.tail);
> 	uint32_t cq_mask = *(uint32_t *)(r->rings + r->p.cq_off.ring_mask);
> 	uint32_t tail = *sq_tail, idx = tail & sq_mask, head;
> 	struct cqe *cqe;
> 	int res;
> 
> 	memset(&r->sqes[idx], 0, sizeof(struct sqe));
> 	r->sqes[idx].opcode = IORING_OP_READ_FIXED;
> 	r->sqes[idx].flags = sqe_flags;
> 	r->sqes[idx].fd = fd;
> 	r->sqes[idx].off = off;
> 	r->sqes[idx].addr = buf_off;
> 	r->sqes[idx].len = len;
> 	r->sqes[idx].buf_index = 0;
> 	sq_array[idx] = idx;
> 	__atomic_store_n(sq_tail, tail + 1, __ATOMIC_RELEASE);
> 	if (syscall(SYS_io_uring_enter, r->fd, 1, 1, IORING_ENTER_GETEVENTS,
> 		    NULL, 0) < 0)
> 		die("io_uring_enter");
> 	head = *cq_head;
> 	if (head == __atomic_load_n(cq_tail, __ATOMIC_ACQUIRE)) {
> 		fprintf(stderr, "no completion\n");
> 		exit(2);
> 	}
> 	cqe = (struct cqe *)(r->rings + r->p.cq_off.cqes) + (head & cq_mask);
> 	res = cqe->res;
> 	__atomic_store_n(cq_head, head + 1, __ATOMIC_RELEASE);
> 	return res;
> }
> 
> int main(int argc, char **argv)
> {
> 	struct rsrc_register reg = { .nr = 1, .flags = IORING_RSRC_REGISTER_SPARSE };
> 	struct regbuf_desc desc = { .type = IO_REGBUF_TYPE_DMABUF };
> 	struct rsrc_update2 up = { .flags = IORING_RSRC_UPDATE_EXTENDED, .nr = 1 };
> 	struct udmabuf_create create = { .flags = UDMABUF_FLAGS_CLOEXEC };
> 	int fd, ufd, memfd, dmabuf, res, warm = 0, async = 0, i;
> 	unsigned char *view, *host;
> 	size_t length, size;
> 	ssize_t expect;
> 	struct ring r;
> 	off_t offset;
> 
> 	if (argc < 4) {
> 		fprintf(stderr, "usage: %s <file> <offset> <length> [warm] [async]\n",
> 			argv[0]);
> 		return 2;
> 	}
> 	for (i = 4; i < argc; i++) {
> 		if (!strcmp(argv[i], "warm"))
> 			warm = 1;
> 		else if (!strcmp(argv[i], "async"))
> 			async = 1;
> 	}
> 	offset = strtoll(argv[2], NULL, 0);
> 	length = strtoull(argv[3], NULL, 0);
> 	size = (length + 4095) & ~4095UL;
> 	if (size < 4096)
> 		size = 4096;
> 
> 	fd = open(argv[1], O_RDONLY | O_DIRECT);
> 	if (fd < 0)
> 		die("open");
> 
> 	/* the reference: the same range read into user memory */
> 	if (posix_memalign((void **)&host, 4096, size))
> 		die("posix_memalign");
> 	expect = pread(fd, host, length, offset);
> 	if (expect < 0)
> 		die("pread");
> 
> 	/* a udmabuf over a sealed memfd */
> 	memfd = memfd_create("dmabuf-eof", MFD_ALLOW_SEALING);
> 	if (memfd < 0 || ftruncate(memfd, size) ||
> 	    fcntl(memfd, F_ADD_SEALS, F_SEAL_SHRINK))
> 		die("memfd");
> 	view = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED, memfd, 0);
> 	if (view == MAP_FAILED)
> 		die("mmap memfd");
> 	ufd = open("/dev/udmabuf", O_RDWR);
> 	if (ufd < 0)
> 		die("open /dev/udmabuf");
> 	create.memfd = memfd;
> 	create.size = size;
> 	dmabuf = ioctl(ufd, UDMABUF_CREATE, &create);
> 	if (dmabuf < 0)
> 		die("UDMABUF_CREATE");
> 
> 	/* a ring with one sparse buffer slot holding the dma-buf */
> 	ring_init(&r);
> 	if (syscall(SYS_io_uring_register, r.fd, IORING_REGISTER_BUFFERS2, &reg,
> 		    sizeof(reg)) < 0)
> 		die("IORING_REGISTER_BUFFERS2");
> 	desc.dmabuf_fd = dmabuf;
> 	desc.target_fd = fd;
> 	up.data = (uint64_t)(uintptr_t)&desc;
> 	if (syscall(SYS_io_uring_register, r.fd, IORING_REGISTER_BUFFERS_UPDATE,
> 		    &up, sizeof(up)) < 0)
> 		die("register dma-buf");
> 
> 	if (warm) {
> 		res = read_fixed(&r, fd, 0, 4096, 0, 0);
> 		if (res != 4096) {
> 			fprintf(stderr, "warm-up read returned %d\n", res);
> 			return 2;
> 		}
> 	}
> 	memset(view, 0xa5, size);
> 	res = read_fixed(&r, fd, offset, length, 0, async ? IOSQE_ASYNC : 0);
> 
> 	printf("READ_FIXED into dma-buf (%s, %s): %d%s%s, O_DIRECT pread(): %zd\n",
> 	       warm ? "map ready" : "first read", async ? "IOSQE_ASYNC" : "inline",
> 	       res, res < 0 ? " " : "", res < 0 ? strerror(-res) : "", expect);
> 	if (res != expect)
> 		return 1;
> 	if (res > 0 && memcmp(view, host, res)) {
> 		printf("data differs\n");
> 		return 1;
> 	}
> 	return 0;
> }
> 
Hi Yun,

Thanks a lot for testing the series against fastsafetensors, and for the
detailed report, reproducer, and fix!

You are completely right — this is a real oversight in patch 2/8.
I reproduced it and validated your fix on real NVMe (nvme-pci, ext4 4KiB
blocks, udmabuf) and passed the tests. 

Since Anuj is currently consolidating the XFS and ext4 dma-buf work
(along with the cross-file registration sharing updates) into a unified
series, I fold your diff into this patch and send a seperated V3 version
with your Co-developed-by and Signed-off-by (if you're okay with that)[1]. 

Hi Anuj, please make sure to include Yun's fix above when you put the 
unified series together. 

Thanks again, Yun, for the thorough testing across 4 KiB and 1 KiB
block sizes and all the edge cases!

[1] https://lore.kernel.org/all/20261126100721.313677-1-mengmeng.zhao@linux.dev/

Best regards,
Mengmeng

