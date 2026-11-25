Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.70.43.20
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795627018;
	b=XzSDoyWnQcACX/63SrC3zu+LKxJboja8VxqkTFbmLtYj+YQNcb7WGrcgWn+8nAk3xn8Y
	 BaGjr4D52W7lVOgopKuhKxgZVjuOO6+oKFCvltF/+skdgMyLI8dwwQyoRijD7pE2KexM3
	 g7R9Ejud2HFK9L4oIw1PdN8OP7RvkQQgvDZvzC60PT1fyQCBoaKVbwVFvNgNJ6rn03iWg
	 MkqIvEhK1/GCgR2celGXRinBexM1ea73UABQto3ajlooiMSR1oA3MzHHNy+zOCqRjpMis
	 SlpuvZveqZ9aDAmenjYqOrg55o+yK+SIzS2M+h5fTdmYH//LGCvuDWjlVW8Y3NsTwQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795627018;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 Feedback-ID:X-Pm-Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=306Y2BAJ0mk9ljp12eAtknlDVkrB39bi49HCqrOE2pE=;
	b=FyEdn8cdBq5UqJKUvctnLef2f1OqsVliOVVCc9W4/rmxD3ekUcpw6CLb9qWZy64Qi7CH
	 7t6IVPb4dDEMkOw0qjZYTs50FlAioNaYlqiivzv9b4D3W3ciDtqBkEypR3lxVfGlpdSYN
	 2iCorunys3U/XG3f4uCo0lQeywF9Vs2lI9zQH4lSyFgpNTqsbhHv+7VmM0OaCuVFjVNj6
	 SNIglal8AHA208NjoEoxQ7NRxNqAOLwuLXfprDihVzmSmrqjYM9ugg0djHMsh/EDfQXA9
	 7rbufLf8EpWudPu6MLniApT1cFN5Gq7rSgLF1KYdZXYrZMcrcbUlFzFx7guo4m0EHpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=a7snv.com;
	spf=pass smtp.mailfrom=a7snv.com;
	dkim=pass header.d=a7snv.com header.i=@a7snv.com header.a=rsa-sha256 header.s=protonmail header.b=Isn+fec1;
	arc=none smtp.remote-ip=185.70.43.20
Received: from mail-4320.protonmail.ch (mail-4320.protonmail.ch [185.70.43.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8935606A323
	for <nvdimm@lists.linux.dev>; Wed, 25 Nov 2026 17:16:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C8935606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=a7snv.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=a7snv.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=a7snv.com header.i=@a7snv.com header.a=rsa-sha256 header.s=protonmail header.b=Isn+fec1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=a7snv.com;
	s=protonmail; t=1795627004; x=1795886204;
	bh=306Y2BAJ0mk9ljp12eAtknlDVkrB39bi49HCqrOE2pE=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=Isn+fec1ecOxy1pHM8uYQ2tCVBhQsV3SY7qVL+OD6TT25GSpjBygkLsgXcAooSS/z
	 f4TztsrhUXRHoYkbUDWzk/wrbiOCgFnPZ2aWMuDVIfaJvhypaK7JiWeFt2PHvIJkad
	 zl6zmCNft9hgo+9H6dSp3r3d31vWneEExVaLfCv950INz1tUBSV1mw464DWNqU3p/y
	 lpq7RNBIwC/hwanegqotjj68CdEsDhlwHHjDfipBcm2B/InGkFFeZYjtGOjUIxM5pE
	 dmhet2534yuefhIkBSmvCHG5Zplu/DngDDKHbgeYvEIrDUQp0GJ8kxYzIEQa9Mn1W1
	 A7UrtyIBBesPA==
Date: Wed, 25 Nov 2026 17:16:25 +0000
To: Mengmeng Zhao <mengmeng.zhao@linux.dev>
From: Yun Wang <arsenova@a7snv.com>
Cc: hch@lst.de, anuj1072538@gmail.com, anuj20.g@samsung.com, nj.shetty@samsung.com, axboe@kernel.dk, sumit.semwal@linaro.org, christian.koenig@amd.com, phasta@kernel.org, djbw@kernel.org, willy@infradead.org, jack@suse.cz, viro@zeniv.linux.org.uk, brauner@kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, ojaswin@linux.ibm.com, ritesh.list@gmail.com, yi.zhang@huawei.com, asml.silence@gmail.com, corbet@lwn.net, skhan@linuxfoundation.org, rdunlap@infradead.org, liwang@kylinos.cn, zhaomengmeng@kylinos.cn, mcgrof@kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-doc@vger.kernel.org, linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org
Subject: Re: [RFC PATCH v2 2/8] iomap: add dma-buf direct I/O guards
Message-ID: <20261125171600.4053585-1-arsenova@a7snv.com>
Feedback-ID: 235448903:user:proton
X-Pm-Message-ID: 37ce9f54f53aabca1ce9dc5fb89af8077900c77a
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 13, 2026 at 03:06:15PM +0800, Mengmeng Zhao wrote:
>  static int iomap_dio_hole_iter(struct iomap_iter *iter, struct iomap_dio=
 *dio)
>  {
> -=09loff_t copied =3D iov_iter_zero(iomap_length(iter), dio->submit.iter)=
;
> +=09loff_t copied;
> +
> +=09/* zero-filling walks the data pages */
> +=09if (iov_iter_is_dmabuf_map(dio->submit.iter))
> +=09=09return -EOPNOTSUPP;

This also fails reads that run past EOF.  The filesystem maps the range
beyond the last block as a hole too, so a dma-buf read that starts
before EOF and ends past the last block of the file fails as a whole,
while the same O_DIRECT read into user memory returns the bytes up to
EOF.

I found it while testing the series for fastsafetensors' dma-buf copier
[1], which loads model weights from NVMe into GPU memory with READ_FIXED
into registered dma-bufs.  I ran v2 on top of v7.4-rc2 in a QEMU guest
with an emulated NVMe namespace, reading into udmabufs.  With a
5000-byte file on ext4 with 4 KiB blocks, reading [4096, 12288):

  READ_FIXED into a registered udmabuf -> -EOPNOTSUPP
  O_DIRECT pread() into user memory    -> 904

It fails the same way whether the read is the first one on the buffer,
is issued inline once the map exists, or is forced to io-wq with
IOSQE_ASYNC.

Reading a file in fixed-size chunks hits this on the last chunk unless
the file size is a multiple of the chunk size.  With 1 KiB blocks it
also breaks the copier's normal pattern, 4 KiB-aligned reads up to
round_up(i_size, 4096): the last read fails.

Nothing past EOF is reported to the caller anyway: __iomap_dio_rw()
reverts the iterator to i_size and iomap_dio_complete() truncates the
result to it.  So a hole that starts at or after EOF can be stepped
over; a hole inside the file still needs zeroes and still fails.
Something like this on top of the series, or folded into this patch:

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 83fda6973bb9..2de6d379f811 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -596,9 +596,20 @@ static int iomap_dio_hole_iter(struct iomap_iter *iter=
, struct iomap_dio *dio)
 {
 =09loff_t copied;
=20
-=09/* zero-filling walks the data pages */
-=09if (iov_iter_is_dmabuf_map(dio->submit.iter))
-=09=09return -EOPNOTSUPP;
+=09if (iov_iter_is_dmabuf_map(dio->submit.iter)) {
+=09=09u64 length =3D iomap_length(iter);
+
+=09=09/* zero-filling walks the data pages */
+=09=09if (iter->pos < dio->i_size)
+=09=09=09return -EOPNOTSUPP;
+=09=09/*
+=09=09 * Past EOF there is nothing to zero: the read is truncated to
+=09=09 * i_size before it is reported, so step over the hole.
+=09=09 */
+=09=09iov_iter_advance(dio->submit.iter, length);
+=09=09dio->size +=3D length;
+=09=09return iomap_iter_advance(iter, length);
+=09}
=20
 =09copied =3D iov_iter_zero(iomap_length(iter), dio->submit.iter);
=20

Signed-off-by: Yun Wang <arsenova@a7snv.com>

With it, the read above returns 904 with the right data in all three
cases.  Holes and unwritten extents inside the file still return
-EOPNOTSUPP, including a hole that straddles EOF after the file was
extended with ftruncate().

The rest of the series behaved as the cover letter describes in that
setup, with 4 KiB and 1 KiB blocks: registration on an O_DIRECT file,
reads into arbitrary offsets of the buffer, reads through a dup()ed fd,
-EBADF through another file's slot, -EINVAL when registering a buffered
fd, -EOPNOTSUPP after F_SETFL clears O_DIRECT and success again once it
is set back, WRITE_FIXED including a write that extends the file, and a
clean e2fsck afterwards.  I have not run it on real NVMe hardware or
xfstests yet.

This report and the reproducer below were drafted with the help of an
AI coding assistant (Claude Opus 5.5); the fix is mine.

[1] https://github.com/foundation-model-stack/fastsafetensors/issues/139

Thanks,
Yun

Reproducer.  It needs /dev/udmabuf and a filesystem with this series
on an NVMe namespace:

  head -c 5000 /dev/urandom > /mnt/f && sync
  ./dmabuf_eof_read /mnt/f 4096 8192             # first read on the buffer
  ./dmabuf_eof_read /mnt/f 4096 8192 warm        # map exists, inline issue
  ./dmabuf_eof_read /mnt/f 4096 8192 warm async  # IOSQE_ASYNC

// SPDX-License-Identifier: GPL-2.0
/*
 * Read a file range into a udmabuf that is registered against the file as
 * an io_uring fixed buffer, and compare with an O_DIRECT pread() of the
 * same range into user memory.
 *
 *   dmabuf_eof_read <file> <offset> <length> [warm] [async]
 *
 *   warm   first read [0, 4096) through the same buffer, so the dma-buf ma=
p
 *          exists and the measured read can be issued inline (nonblocking)
 *   async  set IOSQE_ASYNC on the measured read (issue it from io-wq)
 *
 * Exits 0 when READ_FIXED returns what pread() returns and the bytes match=
.
 * Needs /dev/udmabuf, and a kernel and filesystem with io_uring dma-buf
 * registered buffers.  The UAPI bits are declared locally because they are
 * newer than most installed headers.
 */
#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <sys/syscall.h>
#include <unistd.h>
#include <linux/udmabuf.h>

#define IORING_OFF_SQ_RING=09=090ULL
#define IORING_OFF_SQES=09=09=090x10000000ULL
#define IORING_ENTER_GETEVENTS=09=09(1U << 0)
#define IORING_REGISTER_BUFFERS2=0915
#define IORING_REGISTER_BUFFERS_UPDATE=0916
#define IORING_RSRC_REGISTER_SPARSE=09(1U << 0)
#define IORING_RSRC_UPDATE_EXTENDED=09(1U << 1)
#define IO_REGBUF_TYPE_DMABUF=09=092
#define IORING_OP_READ_FIXED=09=094
#define IOSQE_ASYNC=09=09=09(1U << 4)

struct sqe {
=09uint8_t opcode, flags;
=09uint16_t ioprio;
=09int32_t fd;
=09uint64_t off, addr;
=09uint32_t len, rw_flags;
=09uint64_t user_data;
=09uint16_t buf_index, personality;
=09int32_t splice_fd_in;
=09uint64_t addr3, pad2;
};

struct cqe {
=09uint64_t user_data;
=09int32_t res;
=09uint32_t flags;
};

struct sq_offsets {
=09uint32_t head, tail, ring_mask, ring_entries, flags, dropped, array, res=
v1;
=09uint64_t user_addr;
};

struct cq_offsets {
=09uint32_t head, tail, ring_mask, ring_entries, overflow, cqes, flags, res=
v1;
=09uint64_t user_addr;
};

struct params {
=09uint32_t sq_entries, cq_entries, flags, sq_thread_cpu, sq_thread_idle;
=09uint32_t features, wq_fd, resv[3];
=09struct sq_offsets sq_off;
=09struct cq_offsets cq_off;
};

struct rsrc_register {
=09uint32_t nr, flags;
=09uint64_t resv2, data, tags;
};

struct rsrc_update2 {
=09uint32_t offset, flags;
=09uint64_t data, tags;
=09uint32_t nr, resv2;
};

struct regbuf_desc {
=09uint32_t type, flags;
=09uint64_t size, uaddr;
=09int32_t dmabuf_fd, target_fd;
=09uint64_t resv[6];
};

_Static_assert(sizeof(struct sqe) =3D=3D 64, "io_uring_sqe");
_Static_assert(sizeof(struct cqe) =3D=3D 16, "io_uring_cqe");
_Static_assert(sizeof(struct params) =3D=3D 120, "io_uring_params");
_Static_assert(sizeof(struct rsrc_register) =3D=3D 32, "io_uring_rsrc_regis=
ter");
_Static_assert(sizeof(struct rsrc_update2) =3D=3D 32, "io_uring_rsrc_update=
2");
_Static_assert(sizeof(struct regbuf_desc) =3D=3D 80, "io_uring_regbuf_desc"=
);

struct ring {
=09int fd;
=09struct params p;
=09char *rings;
=09struct sqe *sqes;
};

static void die(const char *what)
{
=09perror(what);
=09exit(2);
}

static void ring_init(struct ring *r)
{
=09size_t sq_size, cq_size;

=09memset(r, 0, sizeof(*r));
=09r->fd =3D syscall(SYS_io_uring_setup, 4, &r->p);
=09if (r->fd < 0)
=09=09die("io_uring_setup");
=09sq_size =3D r->p.sq_off.array + r->p.sq_entries * sizeof(uint32_t);
=09cq_size =3D r->p.cq_off.cqes + r->p.cq_entries * sizeof(struct cqe);
=09/* SQ and CQ rings share one mapping (IORING_FEAT_SINGLE_MMAP) */
=09r->rings =3D mmap(NULL, sq_size > cq_size ? sq_size : cq_size,
=09=09=09PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE, r->fd,
=09=09=09IORING_OFF_SQ_RING);
=09r->sqes =3D mmap(NULL, r->p.sq_entries * sizeof(struct sqe),
=09=09       PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE, r->fd,
=09=09       IORING_OFF_SQES);
=09if (r->rings =3D=3D MAP_FAILED || r->sqes =3D=3D MAP_FAILED)
=09=09die("mmap ring");
}

/* one READ_FIXED from slot 0; addr is the byte offset into the dma-buf */
static int read_fixed(struct ring *r, int fd, off_t off, size_t len,
=09=09      uint64_t buf_off, uint8_t sqe_flags)
{
=09uint32_t *sq_tail =3D (uint32_t *)(r->rings + r->p.sq_off.tail);
=09uint32_t sq_mask =3D *(uint32_t *)(r->rings + r->p.sq_off.ring_mask);
=09uint32_t *sq_array =3D (uint32_t *)(r->rings + r->p.sq_off.array);
=09uint32_t *cq_head =3D (uint32_t *)(r->rings + r->p.cq_off.head);
=09uint32_t *cq_tail =3D (uint32_t *)(r->rings + r->p.cq_off.tail);
=09uint32_t cq_mask =3D *(uint32_t *)(r->rings + r->p.cq_off.ring_mask);
=09uint32_t tail =3D *sq_tail, idx =3D tail & sq_mask, head;
=09struct cqe *cqe;
=09int res;

=09memset(&r->sqes[idx], 0, sizeof(struct sqe));
=09r->sqes[idx].opcode =3D IORING_OP_READ_FIXED;
=09r->sqes[idx].flags =3D sqe_flags;
=09r->sqes[idx].fd =3D fd;
=09r->sqes[idx].off =3D off;
=09r->sqes[idx].addr =3D buf_off;
=09r->sqes[idx].len =3D len;
=09r->sqes[idx].buf_index =3D 0;
=09sq_array[idx] =3D idx;
=09__atomic_store_n(sq_tail, tail + 1, __ATOMIC_RELEASE);
=09if (syscall(SYS_io_uring_enter, r->fd, 1, 1, IORING_ENTER_GETEVENTS,
=09=09    NULL, 0) < 0)
=09=09die("io_uring_enter");
=09head =3D *cq_head;
=09if (head =3D=3D __atomic_load_n(cq_tail, __ATOMIC_ACQUIRE)) {
=09=09fprintf(stderr, "no completion\n");
=09=09exit(2);
=09}
=09cqe =3D (struct cqe *)(r->rings + r->p.cq_off.cqes) + (head & cq_mask);
=09res =3D cqe->res;
=09__atomic_store_n(cq_head, head + 1, __ATOMIC_RELEASE);
=09return res;
}

int main(int argc, char **argv)
{
=09struct rsrc_register reg =3D { .nr =3D 1, .flags =3D IORING_RSRC_REGISTE=
R_SPARSE };
=09struct regbuf_desc desc =3D { .type =3D IO_REGBUF_TYPE_DMABUF };
=09struct rsrc_update2 up =3D { .flags =3D IORING_RSRC_UPDATE_EXTENDED, .nr=
 =3D 1 };
=09struct udmabuf_create create =3D { .flags =3D UDMABUF_FLAGS_CLOEXEC };
=09int fd, ufd, memfd, dmabuf, res, warm =3D 0, async =3D 0, i;
=09unsigned char *view, *host;
=09size_t length, size;
=09ssize_t expect;
=09struct ring r;
=09off_t offset;

=09if (argc < 4) {
=09=09fprintf(stderr, "usage: %s <file> <offset> <length> [warm] [async]\n"=
,
=09=09=09argv[0]);
=09=09return 2;
=09}
=09for (i =3D 4; i < argc; i++) {
=09=09if (!strcmp(argv[i], "warm"))
=09=09=09warm =3D 1;
=09=09else if (!strcmp(argv[i], "async"))
=09=09=09async =3D 1;
=09}
=09offset =3D strtoll(argv[2], NULL, 0);
=09length =3D strtoull(argv[3], NULL, 0);
=09size =3D (length + 4095) & ~4095UL;
=09if (size < 4096)
=09=09size =3D 4096;

=09fd =3D open(argv[1], O_RDONLY | O_DIRECT);
=09if (fd < 0)
=09=09die("open");

=09/* the reference: the same range read into user memory */
=09if (posix_memalign((void **)&host, 4096, size))
=09=09die("posix_memalign");
=09expect =3D pread(fd, host, length, offset);
=09if (expect < 0)
=09=09die("pread");

=09/* a udmabuf over a sealed memfd */
=09memfd =3D memfd_create("dmabuf-eof", MFD_ALLOW_SEALING);
=09if (memfd < 0 || ftruncate(memfd, size) ||
=09    fcntl(memfd, F_ADD_SEALS, F_SEAL_SHRINK))
=09=09die("memfd");
=09view =3D mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED, memfd, 0);
=09if (view =3D=3D MAP_FAILED)
=09=09die("mmap memfd");
=09ufd =3D open("/dev/udmabuf", O_RDWR);
=09if (ufd < 0)
=09=09die("open /dev/udmabuf");
=09create.memfd =3D memfd;
=09create.size =3D size;
=09dmabuf =3D ioctl(ufd, UDMABUF_CREATE, &create);
=09if (dmabuf < 0)
=09=09die("UDMABUF_CREATE");

=09/* a ring with one sparse buffer slot holding the dma-buf */
=09ring_init(&r);
=09if (syscall(SYS_io_uring_register, r.fd, IORING_REGISTER_BUFFERS2, &reg,
=09=09    sizeof(reg)) < 0)
=09=09die("IORING_REGISTER_BUFFERS2");
=09desc.dmabuf_fd =3D dmabuf;
=09desc.target_fd =3D fd;
=09up.data =3D (uint64_t)(uintptr_t)&desc;
=09if (syscall(SYS_io_uring_register, r.fd, IORING_REGISTER_BUFFERS_UPDATE,
=09=09    &up, sizeof(up)) < 0)
=09=09die("register dma-buf");

=09if (warm) {
=09=09res =3D read_fixed(&r, fd, 0, 4096, 0, 0);
=09=09if (res !=3D 4096) {
=09=09=09fprintf(stderr, "warm-up read returned %d\n", res);
=09=09=09return 2;
=09=09}
=09}
=09memset(view, 0xa5, size);
=09res =3D read_fixed(&r, fd, offset, length, 0, async ? IOSQE_ASYNC : 0);

=09printf("READ_FIXED into dma-buf (%s, %s): %d%s%s, O_DIRECT pread(): %zd\=
n",
=09       warm ? "map ready" : "first read", async ? "IOSQE_ASYNC" : "inlin=
e",
=09       res, res < 0 ? " " : "", res < 0 ? strerror(-res) : "", expect);
=09if (res !=3D expect)
=09=09return 1;
=09if (res > 0 && memcmp(view, host, res)) {
=09=09printf("data differs\n");
=09=09return 1;
=09}
=09return 0;
}

