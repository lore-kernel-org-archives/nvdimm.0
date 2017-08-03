Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg0-x243.google.com (mail-pg0-x243.google.com
 [IPv6:2607:f8b0:400e:c05::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7E08B2095D9DD
 for <linux-nvdimm@lists.01.org>; Thu,  3 Aug 2017 00:47:44 -0700 (PDT)
Received: by mail-pg0-x243.google.com with SMTP id l64so797460pge.2
 for <linux-nvdimm@lists.01.org>; Thu, 03 Aug 2017 00:49:55 -0700 (PDT)
From: Steven Swanson <swanson@eng.ucsd.edu>
Subject: [RFC 15/16] NOVA: Performance measurement
Date: Thu, 03 Aug 2017 00:49:53 -0700
Message-ID: <150174659344.104003.4768103912078807362.stgit@hn>
In-Reply-To: <150174646416.104003.14042713459553361884.stgit@hn>
References: <150174646416.104003.14042713459553361884.stgit@hn>
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
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
Cc: Steven Swanson <steven.swanson@gmail.com>
List-ID: <linux-nvdimm@lists.01.org>

Signed-off-by: Steven Swanson <swanson@cs.ucsd.edu>
---
 fs/nova/perf.c  |  594 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nova/perf.h  |   96 ++++++++
 fs/nova/stats.c |  685 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nova/stats.h |  218 ++++++++++++++++++
 4 files changed, 1593 insertions(+)
 create mode 100644 fs/nova/perf.c
 create mode 100644 fs/nova/perf.h
 create mode 100644 fs/nova/stats.c
 create mode 100644 fs/nova/stats.h

diff --git a/fs/nova/perf.c b/fs/nova/perf.c
new file mode 100644
index 000000000000..35a4c6a490c3
--- /dev/null
+++ b/fs/nova/perf.c
@@ -0,0 +1,594 @@
+/*
+ * BRIEF DESCRIPTION
+ *
+ * Performance test routines
+ *
+ * Copyright 2015-2016 Regents of the University of California,
+ * UCSD Non-Volatile Systems Lab, Andiry Xu <jix024@cs.ucsd.edu>
+ * Copyright 2012-2013 Intel Corporation
+ * Copyright 2009-2011 Marco Stornelli <marco.stornelli@gmail.com>
+ * Copyright 2003 Sony Corporation
+ * Copyright 2003 Matsushita Electric Industrial Co., Ltd.
+ * 2003-2004 (c) MontaVista Software, Inc. , Steve Longerbeam
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include "perf.h"
+
+/* normal memcpy functions */
+static int memcpy_read_call(char *dst, char *src, size_t off, size_t size)
+{
+	/* pin dst address to cache most writes, if size fits */
+	memcpy(dst, src + off, size);
+	return 0;
+}
+
+static int memcpy_write_call(char *dst, char *src, size_t off, size_t size)
+{
+	/* pin src address to cache most reads, if size fits */
+	memcpy(dst + off, src, size);
+	return 0;
+}
+
+static int memcpy_bidir_call(char *dst, char *src, size_t off, size_t size)
+{
+	/* minimize caching by forwarding both src and dst */
+	memcpy(dst + off, src + off, size);
+	return 0;
+}
+
+static const memcpy_call_t memcpy_calls[] = {
+	/* order should match enum memcpy_call_id */
+	{ "memcpy (mostly read)",  memcpy_read_call },
+	{ "memcpy (mostly write)", memcpy_write_call },
+	{ "memcpy (read write)",   memcpy_bidir_call }
+};
+
+/* copy from pmem functions */
+static int from_pmem_call(char *dst, char *src, size_t off, size_t size)
+{
+	/* pin dst address to cache most writes, if size fits */
+	/* src address should point to pmem */
+	memcpy_mcsafe(dst, src + off, size);
+	return 0;
+}
+
+static const memcpy_call_t from_pmem_calls[] = {
+	/* order should match enum from_pmem_call_id */
+	{ "memcpy_mcsafe", from_pmem_call }
+};
+
+/* copy to pmem functions */
+static int to_pmem_nocache_call(char *dst, char *src, size_t off, size_t size)
+{
+	/* pin src address to cache most reads, if size fits */
+	/* dst address should point to pmem */
+	memcpy_to_pmem_nocache(dst + off, src, size);
+	return 0;
+}
+
+static int to_flush_call(char *dst, char *src, size_t off, size_t size)
+{
+	/* pin src address to cache most reads, if size fits */
+	/* dst address should point to pmem */
+	nova_flush_buffer(dst + off, size, 0);
+	return 0;
+}
+
+static int to_pmem_flush_call(char *dst, char *src, size_t off, size_t size)
+{
+	/* pin src address to cache most reads, if size fits */
+	/* dst address should point to pmem */
+	memcpy(dst + off, src, size);
+	nova_flush_buffer(dst + off, size, 0);
+	return 0;
+}
+
+static const memcpy_call_t to_pmem_calls[] = {
+	/* order should match enum to_pmem_call_id */
+	{ "memcpy_to_pmem_nocache", to_pmem_nocache_call },
+	{ "flush buffer",	    to_flush_call },
+	{ "memcpy + flush buffer",  to_pmem_flush_call }
+};
+
+/* checksum functions */
+static u64 zlib_adler32_call(u64 init, char *data, size_t size)
+{
+	u64 csum;
+
+	/* include/linux/zutil.h */
+	csum = zlib_adler32(init, data, size);
+	return csum;
+}
+
+static u64 nd_fletcher64_call(u64 init, char *data, size_t size)
+{
+	u64 csum;
+
+	/* drivers/nvdimm/core.c */
+	csum = nd_fletcher64(data, size, 1);
+	return csum;
+}
+
+static u64 libcrc32c_call(u64 init, char *data, size_t size)
+{
+	u32 crc = (u32) init;
+
+	crc = crc32c(crc, data, size);
+	return (u64) crc;
+}
+
+static u64 nova_crc32c_call(u64 init, char *data, size_t size)
+{
+	u32 crc = (u32) init;
+
+	crc = nova_crc32c(crc, data, size);
+	return (u64) crc;
+}
+
+static u64 plain_xor64_call(u64 init, char *data, size_t size)
+{
+	u64 csum = init;
+	u64 *word = (u64 *) data;
+
+	while (size > 8) {
+		csum ^= *word;
+		word += 1;
+		size -= 8;
+	}
+
+	/* for perf testing ignore trailing bytes, if any */
+
+	return csum;
+}
+
+static const checksum_call_t checksum_calls[] = {
+	/* order should match enum checksum_call_id */
+	{ "zlib_adler32",  zlib_adler32_call },
+	{ "nd_fletcher64", nd_fletcher64_call },
+	{ "libcrc32c",     libcrc32c_call },
+	{ "nova_crc32c",   nova_crc32c_call },
+	{ "plain_xor64",   plain_xor64_call }
+};
+
+/* raid5 functions */
+static u64 nova_block_parity_call(char **data, char *parity,
+	size_t size, int disks)
+{
+	int i, j, strp, num_strps = disks;
+	size_t strp_size = size;
+	char *block = *data;
+	u64 xor;
+
+	/* FIXME: using same code as in parity.c; need a way to reuse that */
+
+	if (static_cpu_has(X86_FEATURE_XMM2)) { // sse2 128b
+		for (i = 0; i < strp_size; i += 16) {
+			asm volatile("movdqa %0, %%xmm0" : : "m" (block[i]));
+			for (strp = 1; strp < num_strps; strp++) {
+				j = strp * strp_size + i;
+				asm volatile(
+					"movdqa     %0, %%xmm1\n"
+					"pxor   %%xmm1, %%xmm0\n"
+					: : "m" (block[j])
+				);
+			}
+			asm volatile("movntdq %%xmm0, %0" : "=m" (parity[i]));
+		}
+	} else { // common 64b
+		for (i = 0; i < strp_size; i += 8) {
+			xor = *((u64 *) &block[i]);
+			for (strp = 1; strp < num_strps; strp++) {
+				j = strp * strp_size + i;
+				xor ^= *((u64 *) &block[j]);
+			}
+			*((u64 *) &parity[i]) = xor;
+		}
+	}
+
+	return *((u64 *) parity);
+}
+
+static u64 nova_block_csum_parity_call(char **data, char *parity,
+	size_t size, int disks)
+{
+	int i;
+	size_t strp_size = size;
+	char *block = *data;
+	u32 volatile crc[8]; // avoid results being optimized out
+	u64 qwd[8];
+	u64 acc[8] = {0, 0, 0, 0, 0, 0, 0, 0};
+
+	/* FIXME: using same code as in parity.c; need a way to reuse that */
+
+	for (i = 0; i < strp_size / 8; i++) {
+		qwd[0] = *((u64 *) (block));
+		qwd[1] = *((u64 *) (block + 1 * strp_size));
+		qwd[2] = *((u64 *) (block + 2 * strp_size));
+		qwd[3] = *((u64 *) (block + 3 * strp_size));
+		qwd[4] = *((u64 *) (block + 4 * strp_size));
+		qwd[5] = *((u64 *) (block + 5 * strp_size));
+		qwd[6] = *((u64 *) (block + 6 * strp_size));
+		qwd[7] = *((u64 *) (block + 7 * strp_size));
+
+		// if (data_csum > 0 && unroll_csum) {
+			nova_crc32c_qword(qwd[0], acc[0]);
+			nova_crc32c_qword(qwd[1], acc[1]);
+			nova_crc32c_qword(qwd[2], acc[2]);
+			nova_crc32c_qword(qwd[3], acc[3]);
+			nova_crc32c_qword(qwd[4], acc[4]);
+			nova_crc32c_qword(qwd[5], acc[5]);
+			nova_crc32c_qword(qwd[6], acc[6]);
+			nova_crc32c_qword(qwd[7], acc[7]);
+		// }
+
+		// if (data_parity > 0) {
+			parity[i] = qwd[0] ^ qwd[1] ^ qwd[2] ^ qwd[3] ^
+					qwd[4] ^ qwd[5] ^ qwd[6] ^ qwd[7];
+		// }
+
+		block += 8;
+	}
+	// if (data_csum > 0 && unroll_csum) {
+		crc[0] = cpu_to_le32((u32) acc[0]);
+		crc[1] = cpu_to_le32((u32) acc[1]);
+		crc[2] = cpu_to_le32((u32) acc[2]);
+		crc[3] = cpu_to_le32((u32) acc[3]);
+		crc[4] = cpu_to_le32((u32) acc[4]);
+		crc[5] = cpu_to_le32((u32) acc[5]);
+		crc[6] = cpu_to_le32((u32) acc[6]);
+		crc[7] = cpu_to_le32((u32) acc[7]);
+	// }
+
+	return *((u64 *) parity);
+}
+
+#if 0 // some test machines do not have this function (need CONFIG_MD_RAID456)
+static u64 xor_blocks_call(char **data, char *parity,
+	size_t size, int disks)
+{
+	int xor_cnt, disk_id;
+
+	memcpy(parity, data[0], size); /* init parity with the first disk */
+	disks--;
+	disk_id = 1;
+	while (disks > 0) {
+		/* each xor_blocks call can do at most MAX_XOR_BLOCKS (4) */
+		xor_cnt = min(disks, MAX_XOR_BLOCKS);
+		/* crypto/xor.c, used in lib/raid6 and fs/btrfs */
+		xor_blocks(xor_cnt, size, parity, (void **)(data + disk_id));
+
+		disks -= xor_cnt;
+		disk_id += xor_cnt;
+	}
+
+	return *((u64 *) parity);
+}
+#endif
+
+static const raid5_call_t raid5_calls[] = {
+	/* order should match enum raid5_call_id */
+	{ "nova_block_parity", nova_block_parity_call },
+	{ "nova_block_csum_parity", nova_block_csum_parity_call },
+//	{ "xor_blocks", xor_blocks_call },
+};
+
+/* memory pools for perf testing */
+static void *nova_alloc_vmem_pool(size_t poolsize)
+{
+	void *pool = vmalloc(poolsize);
+
+	if (pool == NULL)
+		return NULL;
+
+	/* init pool to verify some checksum results */
+	// memset(pool, 0xAC, poolsize);
+
+	/* to have a clean start, flush the data cache for the given virtual
+	 * address range in the vmap area
+	 */
+	flush_kernel_vmap_range(pool, poolsize);
+
+	return pool;
+}
+
+static void nova_free_vmem_pool(void *pool)
+{
+	if (pool != NULL)
+		vfree(pool);
+}
+
+static void *nova_alloc_pmem_pool(struct super_block *sb,
+	struct nova_inode_info_header *sih, int cpu, size_t poolsize,
+	unsigned long *blocknr, int *allocated)
+{
+	int num;
+	void *pool;
+	size_t blocksize, blockoff;
+	u8 blocktype = NOVA_BLOCK_TYPE_4K;
+
+	blocksize = blk_type_to_size[blocktype];
+	num = poolsize / blocksize;
+	if (poolsize % blocksize)
+		num++;
+
+	sih->ino = NOVA_TEST_PERF_INO;
+	sih->i_blk_type = blocktype;
+	sih->log_head = 0;
+	sih->log_tail = 0;
+
+	*allocated = nova_new_data_blocks(sb, sih, blocknr, 0, num,
+					  ALLOC_NO_INIT, cpu, ALLOC_FROM_HEAD);
+	if (*allocated < num) {
+		nova_dbg("%s: allocated pmem blocks %d < requested blocks %d\n",
+						__func__, *allocated, num);
+		if (*allocated > 0)
+			nova_free_data_blocks(sb, sih, *blocknr, *allocated);
+
+		return NULL;
+	}
+
+	blockoff = nova_get_block_off(sb, *blocknr, blocktype);
+	pool = nova_get_block(sb, blockoff);
+
+	return pool;
+}
+
+static void nova_free_pmem_pool(struct super_block *sb,
+	struct nova_inode_info_header *sih, char **pmem,
+	unsigned long blocknr, int num)
+{
+	if (num > 0)
+		nova_free_data_blocks(sb, sih, blocknr, num);
+	*pmem = NULL;
+}
+
+static int nova_test_func_perf(struct super_block *sb, unsigned int func_id,
+	size_t poolsize, size_t size, unsigned int disks)
+{
+	u64 csum = 12345, xor = 0;
+
+	u64 volatile result; // avoid results being optimized out
+	const char *fname = NULL;
+	char *src = NULL, *dst = NULL, *pmem = NULL;
+	char **data = NULL, *parity;
+	size_t off = 0;
+	int cpu, i, j, reps, err = 0, allocated = 0;
+	unsigned int call_id = 0, call_gid = 0;
+	unsigned long blocknr = 0, nsec, lat, thru;
+	struct nova_inode_info_header perf_sih;
+	const memcpy_call_t *fmemcpy = NULL;
+	const checksum_call_t *fchecksum = NULL;
+	const raid5_call_t *fraid5 = NULL;
+	timing_t perf_time;
+
+	cpu = get_cpu(); /* get cpu id and disable preemption */
+	reps = poolsize / size; /* raid calls will adjust this number */
+	call_id = func_id - 1; /* individual function id starting from 1 */
+
+	/* normal memcpy */
+	if (call_id < NUM_MEMCPY_CALLS) {
+		src = nova_alloc_vmem_pool(poolsize);
+		dst = nova_alloc_vmem_pool(poolsize);
+		if (src == NULL || dst == NULL) {
+			err = -ENOMEM;
+			goto out;
+		}
+
+		fmemcpy = &memcpy_calls[call_id];
+		fname = fmemcpy->name;
+		call_gid = memcpy_gid;
+
+		goto test;
+	}
+	call_id -= NUM_MEMCPY_CALLS;
+
+	/* memcpy from pmem */
+	if (call_id < NUM_FROM_PMEM_CALLS) {
+		pmem = nova_alloc_pmem_pool(sb, &perf_sih, cpu, poolsize,
+							&blocknr, &allocated);
+		dst = nova_alloc_vmem_pool(poolsize);
+		if (pmem == NULL || dst == NULL) {
+			err = -ENOMEM;
+			goto out;
+		}
+
+		fmemcpy = &from_pmem_calls[call_id];
+		fname = fmemcpy->name;
+		call_gid = from_pmem_gid;
+
+		goto test;
+	}
+	call_id -= NUM_FROM_PMEM_CALLS;
+
+	/* memcpy to pmem */
+	if (call_id < NUM_TO_PMEM_CALLS) {
+		src = nova_alloc_vmem_pool(poolsize);
+		pmem = nova_alloc_pmem_pool(sb, &perf_sih, cpu, poolsize,
+							&blocknr, &allocated);
+		if (src == NULL || pmem == NULL) {
+			err = -ENOMEM;
+			goto out;
+		}
+
+		fmemcpy = &to_pmem_calls[call_id];
+		fname = fmemcpy->name;
+		call_gid = to_pmem_gid;
+
+		goto test;
+	}
+	call_id -= NUM_TO_PMEM_CALLS;
+
+	/* checksum */
+	if (call_id < NUM_CHECKSUM_CALLS) {
+		src = nova_alloc_vmem_pool(poolsize);
+
+		fchecksum = &checksum_calls[call_id];
+		fname = fchecksum->name;
+		call_gid = checksum_gid;
+
+		goto test;
+	}
+	call_id -= NUM_CHECKSUM_CALLS;
+
+	/* raid5 */
+	if (call_id < NUM_RAID5_CALLS) {
+		src = nova_alloc_vmem_pool(poolsize);
+		data = kcalloc(disks, sizeof(char *), GFP_NOFS);
+		if (data == NULL) {
+			err = -ENOMEM;
+			goto out;
+		}
+
+		reps = poolsize / ((disks + 1) * size); /* +1 for parity */
+
+		fraid5 = &raid5_calls[call_id];
+		fname = fraid5->name;
+		call_gid = raid5_gid;
+
+		if (call_id == nova_block_csum_parity_id && disks != 8) {
+			nova_dbg("%s only for 8 disks, skip testing\n", fname);
+			goto out;
+		}
+
+		goto test;
+	}
+	call_id -= NUM_RAID5_CALLS;
+
+	/* continue with the next call group */
+
+test:
+	if (fmemcpy == NULL && fchecksum == NULL && fraid5 == NULL) {
+		nova_dbg("%s: function struct error\n", __func__);
+		err = -EFAULT;
+		goto out;
+	}
+
+	reset_perf_timer();
+	NOVA_START_TIMING(perf_t, perf_time);
+
+	switch (call_gid) {
+	case memcpy_gid:
+		for (i = 0; i < reps; i++, off += size)
+			err = fmemcpy->call(dst, src, off, size);
+		break;
+	case from_pmem_gid:
+		for (i = 0; i < reps; i++, off += size)
+			err = fmemcpy->call(dst, pmem, off, size);
+		break;
+	case to_pmem_gid:
+		nova_memunlock_range(sb, pmem, poolsize);
+		for (i = 0; i < reps; i++, off += size)
+			err = fmemcpy->call(pmem, src, off, size);
+		nova_memlock_range(sb, pmem, poolsize);
+		break;
+	case checksum_gid:
+		for (i = 0; i < reps; i++, off += size)
+			/* checksum calls are memory-read intensive */
+			csum = fchecksum->call(csum, src + off, size);
+		result = csum;
+		break;
+	case raid5_gid:
+		for (i = 0; i < reps; i++, off += (disks + 1) * size) {
+			for (j = 0; j < disks; j++)
+				data[j] = &src[off + j * size];
+			parity = src + off + disks * size;
+			xor = fraid5->call(data, parity, size, disks);
+		}
+		result = xor;
+		break;
+	default:
+		nova_dbg("%s: invalid function group %d\n", __func__, call_gid);
+		break;
+	}
+
+	NOVA_END_TIMING(perf_t, perf_time);
+	nsec = read_perf_timer();
+
+	// nova_info("checksum value: 0x%016llx\n", csum);
+
+	lat  = (err) ? 0 : nsec / reps;
+	if (call_gid == raid5_gid)
+		thru = (err) ? 0 : mb_per_sec(reps * disks * size, nsec);
+	else
+		thru = (err) ? 0 : mb_per_sec(reps * size, nsec);
+
+	if (cpu != smp_processor_id()) /* scheduling shouldn't happen */
+		nova_dbg("cpu was %d, now %d\n", cpu, smp_processor_id());
+
+	nova_info("%4u %25s %4u %8lu %8lu\n", func_id, fname, cpu, lat, thru);
+
+out:
+	nova_free_vmem_pool(src);
+	nova_free_vmem_pool(dst);
+	nova_free_pmem_pool(sb, &perf_sih, &pmem, blocknr, allocated);
+
+	if (data != NULL)
+		kfree(data);
+
+	put_cpu(); /* enable preemption */
+
+	if (err)
+		nova_dbg("%s: performance test aborted\n", __func__);
+	return err;
+}
+
+int nova_test_perf(struct super_block *sb, unsigned int func_id,
+	unsigned int poolmb, size_t size, unsigned int disks)
+{
+	int id, ret = 0;
+	size_t poolsize = poolmb * 1024 * 1024;
+
+	if (!measure_timing) {
+		nova_dbg("%s: measure_timing not set!\n", __func__);
+		ret = -EFAULT;
+		goto out;
+	}
+	if (func_id > NUM_PERF_CALLS) {
+		nova_dbg("%s: invalid function id %d!\n", __func__, func_id);
+		ret = -EFAULT;
+		goto out;
+	}
+	if (poolmb < 1 || 1024 < poolmb) { /* limit pool size to 1GB */
+		nova_dbg("%s: invalid pool size %u MB!\n", __func__, poolmb);
+		ret = -EFAULT;
+		goto out;
+	}
+	if (size < 64 || poolsize < size || (size % 64)) {
+		nova_dbg("%s: invalid data size %zu!\n", __func__, size);
+		ret = -EFAULT;
+		goto out;
+	}
+	if (disks < 1 || 32 < disks) { /* limit number of disks */
+		nova_dbg("%s: invalid disk count %u!\n", __func__, disks);
+		ret = -EFAULT;
+		goto out;
+	}
+
+	nova_info("test function performance\n");
+	nova_info("pool size %u MB, work size %zu, disks %u\n",
+					poolmb, size, disks);
+
+	nova_info("%4s %25s %4s %8s %8s\n", "id", "name", "cpu", "ns", "MB/s");
+	nova_info("-------------------------------------------------------\n");
+	if (func_id == 0) {
+		/* individual function id starting from 1 */
+		for (id = 1; id <= NUM_PERF_CALLS; id++) {
+			ret = nova_test_func_perf(sb, id, poolsize,
+							size, disks);
+			if (ret < 0)
+				goto out;
+		}
+	} else {
+		ret = nova_test_func_perf(sb, func_id, poolsize, size, disks);
+	}
+	nova_info("-------------------------------------------------------\n");
+
+out:
+	return ret;
+}
diff --git a/fs/nova/perf.h b/fs/nova/perf.h
new file mode 100644
index 000000000000..94bee4674f2e
--- /dev/null
+++ b/fs/nova/perf.h
@@ -0,0 +1,96 @@
+/*
+ * BRIEF DESCRIPTION
+ *
+ * Performance test
+ *
+ * Copyright 2015-2016 Regents of the University of California,
+ * UCSD Non-Volatile Systems Lab, Andiry Xu <jix024@cs.ucsd.edu>
+ * Copyright 2012-2013 Intel Corporation
+ * Copyright 2009-2011 Marco Stornelli <marco.stornelli@gmail.com>
+ * Copyright 2003 Sony Corporation
+ * Copyright 2003 Matsushita Electric Industrial Co., Ltd.
+ * 2003-2004 (c) MontaVista Software, Inc. , Steve Longerbeam
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/zutil.h>
+#include <linux/libnvdimm.h>
+#include <linux/raid/xor.h>
+#include "nova.h"
+
+#define	reset_perf_timer()	__this_cpu_write(Timingstats_percpu[perf_t], 0)
+#define	read_perf_timer()	__this_cpu_read(Timingstats_percpu[perf_t])
+
+#define	mb_per_sec(size, nsec)	(nsec == 0 ? 0 : \
+				(size * (1000000000 / 1024 / 1024) / nsec))
+
+enum memcpy_call_id {
+	memcpy_read_id = 0,
+	memcpy_write_id,
+	memcpy_bidir_id,
+	NUM_MEMCPY_CALLS
+};
+
+enum from_pmem_call_id {
+	memcpy_mcsafe_id = 0,
+	NUM_FROM_PMEM_CALLS
+};
+
+enum to_pmem_call_id {
+	memcpy_to_pmem_nocache_id = 0,
+	flush_buffer_id,
+	memcpy_to_pmem_flush_id,
+	NUM_TO_PMEM_CALLS
+};
+
+enum checksum_call_id {
+	zlib_adler32_id = 0,
+	nd_fletcher64_id,
+	libcrc32c_id,
+	nova_crc32c_id,
+	plain_xor64_id,
+	NUM_CHECKSUM_CALLS
+};
+
+enum raid5_call_id {
+	nova_block_parity_id = 0,
+	nova_block_csum_parity_id,
+//	xor_blocks_id,
+	NUM_RAID5_CALLS
+};
+
+#define	NUM_PERF_CALLS	\
+	 (NUM_MEMCPY_CALLS + NUM_FROM_PMEM_CALLS + NUM_TO_PMEM_CALLS + \
+	  NUM_CHECKSUM_CALLS + NUM_RAID5_CALLS)
+
+enum call_group_id {
+	memcpy_gid = 0,
+	from_pmem_gid,
+	to_pmem_gid,
+	checksum_gid,
+	raid5_gid
+};
+
+typedef struct {
+	const char *name;                              /* name of this call */
+//	int (*valid)(void);            /* might need for availability check */
+	int (*call)(char *, char *, size_t, size_t); /* dst, src, off, size */
+} memcpy_call_t;
+
+typedef struct {
+	const char *name;                              /* name of this call */
+//	int (*valid)(void);            /* might need for availability check */
+	u64 (*call)(u64, char *, size_t);               /* init, data, size */
+} checksum_call_t;
+
+typedef struct {
+	const char *name;                              /* name of this call */
+//	int (*valid)(void);            /* might need for availability check */
+	u64 (*call)(char **, char *,                        /* data, parity */
+			size_t, int);          /* per-disk-size, data disks */
+} raid5_call_t;
diff --git a/fs/nova/stats.c b/fs/nova/stats.c
new file mode 100644
index 000000000000..cacf76f0d16d
--- /dev/null
+++ b/fs/nova/stats.c
@@ -0,0 +1,685 @@
+/*
+ * NOVA File System statistics
+ *
+ * Copyright 2015-2016 Regents of the University of California,
+ * UCSD Non-Volatile Systems Lab, Andiry Xu <jix024@cs.ucsd.edu>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#include "nova.h"
+
+const char *Timingstring[TIMING_NUM] = {
+	/* Init */
+	"================ Initialization ================",
+	"init",
+	"mount",
+	"ioremap",
+	"new_init",
+	"recovery",
+
+	/* Namei operations */
+	"============= Directory operations =============",
+	"create",
+	"lookup",
+	"link",
+	"unlink",
+	"symlink",
+	"mkdir",
+	"rmdir",
+	"mknod",
+	"rename",
+	"readdir",
+	"add_dentry",
+	"remove_dentry",
+	"setattr",
+	"setsize",
+
+	/* I/O operations */
+	"================ I/O operations ================",
+	"dax_read",
+	"cow_write",
+	"inplace_write",
+	"copy_to_nvmm",
+	"dax_get_block",
+	"read_iter",
+	"write_iter",
+
+	/* Memory operations */
+	"============== Memory operations ===============",
+	"memcpy_read_nvmm",
+	"memcpy_write_nvmm",
+	"memcpy_write_back_to_nvmm",
+	"handle_partial_block",
+
+	/* Memory management */
+	"============== Memory management ===============",
+	"alloc_blocks",
+	"new_data_blocks",
+	"new_log_blocks",
+	"free_blocks",
+	"free_data_blocks",
+	"free_log_blocks",
+
+	/* Transaction */
+	"================= Transaction ==================",
+	"transaction_new_inode",
+	"transaction_link_change",
+	"update_tail",
+
+	/* Logging */
+	"============= Logging operations ===============",
+	"append_dir_entry",
+	"append_file_entry",
+	"append_mmap_entry",
+	"append_link_change",
+	"append_setattr",
+	"append_snapshot_info",
+	"inplace_update_entry",
+
+	/* Tree */
+	"=============== Tree operations ================",
+	"checking_entry",
+	"assign_blocks",
+
+	/* GC */
+	"============= Garbage collection ===============",
+	"log_fast_gc",
+	"log_thorough_gc",
+	"check_invalid_log",
+
+	/* Integrity */
+	"============ Integrity operations ==============",
+	"block_csum",
+	"block_parity",
+	"block_csum_parity",
+	"protect_memcpy",
+	"protect_file_data",
+	"verify_entry_csum",
+	"verify_data_csum",
+	"calc_entry_csum",
+	"restore_file_data",
+	"reset_mapping",
+	"reset_vma",
+
+	/* Others */
+	"================ Miscellaneous =================",
+	"find_cache_page",
+	"fsync",
+	"write_pages",
+	"fallocate",
+	"direct_IO",
+	"free_old_entry",
+	"delete_file_tree",
+	"delete_dir_tree",
+	"new_vfs_inode",
+	"new_nova_inode",
+	"free_inode",
+	"free_inode_log",
+	"evict_inode",
+	"test_perf",
+	"wprotect",
+
+	/* Mmap */
+	"=============== MMap operations ================",
+	"mmap_page_fault",
+	"mmap_pmd_fault",
+	"mmap_pfn_mkwrite",
+	"insert_vma",
+	"remove_vma",
+	"set_vma_readonly",
+	"mmap_cow",
+	"udpate_mapping",
+	"udpate_pfn",
+	"mmap_handler",
+
+	/* Rebuild */
+	"=================== Rebuild ====================",
+	"rebuild_dir",
+	"rebuild_file",
+	"rebuild_snapshot_table",
+
+	/* Snapshot */
+	"=================== Snapshot ===================",
+	"create_snapshot",
+	"init_snapshot_info",
+	"delete_snapshot",
+	"append_snapshot_filedata",
+	"append_snapshot_inode",
+};
+
+u64 Timingstats[TIMING_NUM];
+DEFINE_PER_CPU(u64[TIMING_NUM], Timingstats_percpu);
+u64 Countstats[TIMING_NUM];
+DEFINE_PER_CPU(u64[TIMING_NUM], Countstats_percpu);
+u64 IOstats[STATS_NUM];
+DEFINE_PER_CPU(u64[STATS_NUM], IOstats_percpu);
+
+static void nova_print_alloc_stats(struct super_block *sb)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct free_list *free_list;
+	unsigned long alloc_log_count = 0;
+	unsigned long alloc_log_pages = 0;
+	unsigned long alloc_data_count = 0;
+	unsigned long alloc_data_pages = 0;
+	unsigned long free_log_count = 0;
+	unsigned long freed_log_pages = 0;
+	unsigned long free_data_count = 0;
+	unsigned long freed_data_pages = 0;
+	int i;
+
+	nova_info("=========== NOVA allocation stats ===========\n");
+	nova_info("Alloc %llu, alloc steps %llu, average %llu\n",
+		Countstats[new_data_blocks_t], IOstats[alloc_steps],
+		Countstats[new_data_blocks_t] ?
+			IOstats[alloc_steps] / Countstats[new_data_blocks_t]
+			: 0);
+	nova_info("Free %llu\n", Countstats[free_data_t]);
+	nova_info("Fast GC %llu, check pages %llu, free pages %llu, average %llu\n",
+		Countstats[fast_gc_t], IOstats[fast_checked_pages],
+		IOstats[fast_gc_pages], Countstats[fast_gc_t] ?
+			IOstats[fast_gc_pages] / Countstats[fast_gc_t] : 0);
+	nova_info("Thorough GC %llu, checked pages %llu, free pages %llu, average %llu\n",
+		Countstats[thorough_gc_t],
+		IOstats[thorough_checked_pages], IOstats[thorough_gc_pages],
+		Countstats[thorough_gc_t] ?
+			IOstats[thorough_gc_pages] / Countstats[thorough_gc_t]
+			: 0);
+
+	for (i = 0; i < sbi->cpus; i++) {
+		free_list = nova_get_free_list(sb, i);
+
+		alloc_log_count += free_list->alloc_log_count;
+		alloc_log_pages += free_list->alloc_log_pages;
+		alloc_data_count += free_list->alloc_data_count;
+		alloc_data_pages += free_list->alloc_data_pages;
+		free_log_count += free_list->free_log_count;
+		freed_log_pages += free_list->freed_log_pages;
+		free_data_count += free_list->free_data_count;
+		freed_data_pages += free_list->freed_data_pages;
+	}
+
+	nova_info("alloc log count %lu, allocated log pages %lu, alloc data count %lu, allocated data pages %lu, free log count %lu, freed log pages %lu, free data count %lu, freed data pages %lu\n",
+		alloc_log_count, alloc_log_pages,
+		alloc_data_count, alloc_data_pages,
+		free_log_count, freed_log_pages,
+		free_data_count, freed_data_pages);
+}
+
+static void nova_print_IO_stats(struct super_block *sb)
+{
+	nova_info("=========== NOVA I/O stats ===========\n");
+	nova_info("Read %llu, bytes %llu, average %llu\n",
+		Countstats[dax_read_t], IOstats[read_bytes],
+		Countstats[dax_read_t] ?
+			IOstats[read_bytes] / Countstats[dax_read_t] : 0);
+	nova_info("COW write %llu, bytes %llu, average %llu, write breaks %llu, average %llu\n",
+		Countstats[cow_write_t], IOstats[cow_write_bytes],
+		Countstats[cow_write_t] ?
+			IOstats[cow_write_bytes] / Countstats[cow_write_t] : 0,
+		IOstats[cow_write_breaks], Countstats[cow_write_t] ?
+			IOstats[cow_write_breaks] / Countstats[cow_write_t]
+			: 0);
+	nova_info("Inplace write %llu, bytes %llu, average %llu, write breaks %llu, average %llu\n",
+		Countstats[inplace_write_t], IOstats[inplace_write_bytes],
+		Countstats[inplace_write_t] ?
+			IOstats[inplace_write_bytes] /
+			Countstats[inplace_write_t] : 0,
+		IOstats[inplace_write_breaks], Countstats[inplace_write_t] ?
+			IOstats[inplace_write_breaks] /
+			Countstats[inplace_write_t] : 0);
+}
+
+void nova_get_timing_stats(void)
+{
+	int i;
+	int cpu;
+
+	for (i = 0; i < TIMING_NUM; i++) {
+		Timingstats[i] = 0;
+		Countstats[i] = 0;
+		for_each_possible_cpu(cpu) {
+			Timingstats[i] += per_cpu(Timingstats_percpu[i], cpu);
+			Countstats[i] += per_cpu(Countstats_percpu[i], cpu);
+		}
+	}
+}
+
+void nova_get_IO_stats(void)
+{
+	int i;
+	int cpu;
+
+	for (i = 0; i < STATS_NUM; i++) {
+		IOstats[i] = 0;
+		for_each_possible_cpu(cpu)
+			IOstats[i] += per_cpu(IOstats_percpu[i], cpu);
+	}
+}
+
+void nova_print_timing_stats(struct super_block *sb)
+{
+	int i;
+
+	nova_get_timing_stats();
+	nova_get_IO_stats();
+
+	nova_info("=========== NOVA kernel timing stats ============\n");
+	for (i = 0; i < TIMING_NUM; i++) {
+		/* Title */
+		if (Timingstring[i][0] == '=') {
+			nova_info("\n%s\n\n", Timingstring[i]);
+			continue;
+		}
+
+		if (measure_timing || Timingstats[i]) {
+			nova_info("%s: count %llu, timing %llu, average %llu\n",
+				Timingstring[i],
+				Countstats[i],
+				Timingstats[i],
+				Countstats[i] ?
+				Timingstats[i] / Countstats[i] : 0);
+		} else {
+			nova_info("%s: count %llu\n",
+				Timingstring[i],
+				Countstats[i]);
+		}
+	}
+
+	nova_info("\n");
+	nova_print_alloc_stats(sb);
+	nova_print_IO_stats(sb);
+}
+
+static void nova_clear_timing_stats(void)
+{
+	int i;
+	int cpu;
+
+	for (i = 0; i < TIMING_NUM; i++) {
+		Countstats[i] = 0;
+		Timingstats[i] = 0;
+		for_each_possible_cpu(cpu) {
+			per_cpu(Timingstats_percpu[i], cpu) = 0;
+			per_cpu(Countstats_percpu[i], cpu) = 0;
+		}
+	}
+}
+
+static void nova_clear_IO_stats(struct super_block *sb)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct free_list *free_list;
+	int i;
+	int cpu;
+
+	for (i = 0; i < STATS_NUM; i++) {
+		IOstats[i] = 0;
+		for_each_possible_cpu(cpu)
+			per_cpu(IOstats_percpu[i], cpu) = 0;
+	}
+
+	for (i = 0; i < sbi->cpus; i++) {
+		free_list = nova_get_free_list(sb, i);
+
+		free_list->alloc_log_count = 0;
+		free_list->alloc_log_pages = 0;
+		free_list->alloc_data_count = 0;
+		free_list->alloc_data_pages = 0;
+		free_list->free_log_count = 0;
+		free_list->freed_log_pages = 0;
+		free_list->free_data_count = 0;
+		free_list->freed_data_pages = 0;
+	}
+}
+
+void nova_clear_stats(struct super_block *sb)
+{
+	nova_clear_timing_stats();
+	nova_clear_IO_stats(sb);
+}
+
+void nova_print_inode(struct nova_inode *pi)
+{
+	nova_dbg("%s: NOVA inode %llu\n", __func__, pi->nova_ino);
+	nova_dbg("valid %u, deleted %u, blk type %u, flags %u\n",
+		pi->valid, pi->deleted, pi->i_blk_type, pi->i_flags);
+	nova_dbg("size %llu, ctime %u, mtime %u, atime %u\n",
+		pi->i_size, pi->i_ctime, pi->i_mtime, pi->i_atime);
+	nova_dbg("mode %u, links %u, xattr 0x%llx, csum %u\n",
+		pi->i_mode, pi->i_links_count, pi->i_xattr, pi->csum);
+	nova_dbg("uid %u, gid %u, gen %u, create time %u\n",
+		pi->i_uid, pi->i_gid, pi->i_generation, pi->i_create_time);
+	nova_dbg("head 0x%llx, tail 0x%llx, alter head 0x%llx, tail 0x%llx\n",
+		pi->log_head, pi->log_tail, pi->alter_log_head,
+		pi->alter_log_tail);
+	nova_dbg("create epoch id %llu, delete epoch id %llu\n",
+		pi->create_epoch_id, pi->delete_epoch_id);
+}
+
+static inline void nova_print_file_write_entry(struct super_block *sb,
+	u64 curr, struct nova_file_write_entry *entry)
+{
+	nova_dbg("file write entry @ 0x%llx: epoch %llu, trans %llu, pgoff %llu, pages %u, blocknr %llu, reassigned %u, updating %u, invalid count %u, size %llu, mtime %u\n",
+			curr, entry->epoch_id, entry->trans_id,
+			entry->pgoff, entry->num_pages,
+			entry->block >> PAGE_SHIFT,
+			entry->reassigned, entry->updating,
+			entry->invalid_pages, entry->size, entry->mtime);
+}
+
+static inline void nova_print_set_attr_entry(struct super_block *sb,
+	u64 curr, struct nova_setattr_logentry *entry)
+{
+	nova_dbg("set attr entry @ 0x%llx: epoch %llu, trans %llu, invalid %u, mode %u, size %llu, atime %u, mtime %u, ctime %u\n",
+			curr, entry->epoch_id, entry->trans_id,
+			entry->invalid, entry->mode,
+			entry->size, entry->atime, entry->mtime, entry->ctime);
+}
+
+static inline void nova_print_link_change_entry(struct super_block *sb,
+	u64 curr, struct nova_link_change_entry *entry)
+{
+	nova_dbg("link change entry @ 0x%llx: epoch %llu, trans %llu, invalid %u, links %u, flags %u, ctime %u\n",
+			curr, entry->epoch_id, entry->trans_id,
+			entry->invalid, entry->links,
+			entry->flags, entry->ctime);
+}
+
+static inline void nova_print_mmap_entry(struct super_block *sb,
+	u64 curr, struct nova_mmap_entry *entry)
+{
+	nova_dbg("mmap write entry @ 0x%llx: epoch %llu, invalid %u, pgoff %llu, pages %llu\n",
+			curr, entry->epoch_id, entry->invalid,
+			entry->pgoff, entry->num_pages);
+}
+
+static inline void nova_print_snapshot_info_entry(struct super_block *sb,
+	u64 curr, struct nova_snapshot_info_entry *entry)
+{
+	nova_dbg("snapshot info entry @ 0x%llx: epoch %llu, deleted %u, timestamp %llu\n",
+			curr, entry->epoch_id, entry->deleted,
+			entry->timestamp);
+}
+
+static inline size_t nova_print_dentry(struct super_block *sb,
+	u64 curr, struct nova_dentry *entry)
+{
+	nova_dbg("dir logentry @ 0x%llx: epoch %llu, trans %llu, reassigned %u, invalid %u, inode %llu, links %u, namelen %u, rec len %u, name %s, mtime %u\n",
+			curr, entry->epoch_id, entry->trans_id,
+			entry->reassigned, entry->invalid,
+			le64_to_cpu(entry->ino),
+			entry->links_count, entry->name_len,
+			le16_to_cpu(entry->de_len), entry->name,
+			entry->mtime);
+
+	return le16_to_cpu(entry->de_len);
+}
+
+u64 nova_print_log_entry(struct super_block *sb, u64 curr)
+{
+	void *addr;
+	size_t size;
+	u8 type;
+
+	addr = (void *)nova_get_block(sb, curr);
+	type = nova_get_entry_type(addr);
+	switch (type) {
+	case SET_ATTR:
+		nova_print_set_attr_entry(sb, curr, addr);
+		curr += sizeof(struct nova_setattr_logentry);
+		break;
+	case LINK_CHANGE:
+		nova_print_link_change_entry(sb, curr, addr);
+		curr += sizeof(struct nova_link_change_entry);
+		break;
+	case MMAP_WRITE:
+		nova_print_mmap_entry(sb, curr, addr);
+		curr += sizeof(struct nova_mmap_entry);
+		break;
+	case SNAPSHOT_INFO:
+		nova_print_snapshot_info_entry(sb, curr, addr);
+		curr += sizeof(struct nova_snapshot_info_entry);
+		break;
+	case FILE_WRITE:
+		nova_print_file_write_entry(sb, curr, addr);
+		curr += sizeof(struct nova_file_write_entry);
+		break;
+	case DIR_LOG:
+		size = nova_print_dentry(sb, curr, addr);
+		curr += size;
+		if (size == 0) {
+			nova_dbg("%s: dentry with size 0 @ 0x%llx\n",
+					__func__, curr);
+			curr += sizeof(struct nova_file_write_entry);
+			NOVA_ASSERT(0);
+		}
+		break;
+	case NEXT_PAGE:
+		nova_dbg("%s: next page sign @ 0x%llx\n", __func__, curr);
+		curr = PAGE_TAIL(curr);
+		break;
+	default:
+		nova_dbg("%s: unknown type %d, 0x%llx\n", __func__, type, curr);
+		curr += sizeof(struct nova_file_write_entry);
+		NOVA_ASSERT(0);
+		break;
+	}
+
+	return curr;
+}
+
+void nova_print_curr_log_page(struct super_block *sb, u64 curr)
+{
+	struct nova_inode_page_tail *tail;
+	u64 start, end;
+
+	start = BLOCK_OFF(curr);
+	end = PAGE_TAIL(curr);
+
+	while (start < end)
+		start = nova_print_log_entry(sb, start);
+
+	tail = nova_get_block(sb, end);
+	nova_dbg("Page tail. curr 0x%llx, next page 0x%llx, %u entries, %u invalid\n",
+			start, tail->next_page,
+			tail->num_entries, tail->invalid_entries);
+}
+
+void nova_print_nova_log(struct super_block *sb,
+	struct nova_inode_info_header *sih)
+{
+	u64 curr;
+
+	if (sih->log_tail == 0 || sih->log_head == 0)
+		return;
+
+	curr = sih->log_head;
+	nova_dbg("Pi %lu: log head 0x%llx, tail 0x%llx\n",
+			sih->ino, curr, sih->log_tail);
+	while (curr != sih->log_tail) {
+		if ((curr & (PAGE_SIZE - 1)) == LOG_BLOCK_TAIL) {
+			struct nova_inode_page_tail *tail =
+					nova_get_block(sb, curr);
+			nova_dbg("Log tail, curr 0x%llx, next page 0x%llx, %u entries, %u invalid\n",
+					curr, tail->next_page,
+					tail->num_entries,
+					tail->invalid_entries);
+			curr = tail->next_page;
+		} else {
+			curr = nova_print_log_entry(sb, curr);
+		}
+	}
+}
+
+void nova_print_inode_log(struct super_block *sb, struct inode *inode)
+{
+	struct nova_inode_info *si = NOVA_I(inode);
+	struct nova_inode_info_header *sih = &si->header;
+
+	nova_print_nova_log(sb, sih);
+}
+
+int nova_get_nova_log_pages(struct super_block *sb,
+	struct nova_inode_info_header *sih, struct nova_inode *pi)
+{
+	struct nova_inode_log_page *curr_page;
+	u64 curr, next;
+	int count = 1;
+
+	if (pi->log_head == 0 || pi->log_tail == 0) {
+		nova_dbg("Pi %lu has no log\n", sih->ino);
+		return 0;
+	}
+
+	curr = pi->log_head;
+	curr_page = (struct nova_inode_log_page *)nova_get_block(sb, curr);
+	while ((next = curr_page->page_tail.next_page) != 0) {
+		curr = next;
+		curr_page = (struct nova_inode_log_page *)
+			nova_get_block(sb, curr);
+		count++;
+	}
+
+	return count;
+}
+
+void nova_print_nova_log_pages(struct super_block *sb,
+	struct nova_inode_info_header *sih)
+{
+	struct nova_inode_log_page *curr_page;
+	u64 curr, next;
+	int count = 1;
+	int used = count;
+
+	if (sih->log_head == 0 || sih->log_tail == 0) {
+		nova_dbg("Pi %lu has no log\n", sih->ino);
+		return;
+	}
+
+	curr = sih->log_head;
+	nova_dbg("Pi %lu: log head @ 0x%llx, tail @ 0x%llx\n",
+			sih->ino, curr, sih->log_tail);
+	curr_page = (struct nova_inode_log_page *)nova_get_block(sb, curr);
+	while ((next = curr_page->page_tail.next_page) != 0) {
+		nova_dbg("Current page 0x%llx, next page 0x%llx, %u entries, %u invalid\n",
+			curr >> PAGE_SHIFT, next >> PAGE_SHIFT,
+			curr_page->page_tail.num_entries,
+			curr_page->page_tail.invalid_entries);
+		if (sih->log_tail >> PAGE_SHIFT == curr >> PAGE_SHIFT)
+			used = count;
+		curr = next;
+		curr_page = (struct nova_inode_log_page *)
+			nova_get_block(sb, curr);
+		count++;
+	}
+	if (sih->log_tail >> PAGE_SHIFT == curr >> PAGE_SHIFT)
+		used = count;
+	nova_dbg("Pi %lu: log used %d pages, has %d pages, si reports %lu pages\n",
+		sih->ino, used, count,
+		sih->log_pages);
+}
+
+void nova_print_inode_log_pages(struct super_block *sb, struct inode *inode)
+{
+	struct nova_inode_info *si = NOVA_I(inode);
+	struct nova_inode_info_header *sih = &si->header;
+
+	nova_print_nova_log_pages(sb, sih);
+}
+
+int nova_check_inode_logs(struct super_block *sb, struct nova_inode *pi)
+{
+	int count1 = 0;
+	int count2 = 0;
+	int tail1_at = 0;
+	int tail2_at = 0;
+	u64 curr, alter_curr;
+
+	curr = pi->log_head;
+	alter_curr = pi->alter_log_head;
+
+	while (curr && alter_curr) {
+		if (alter_log_page(sb, curr) != alter_curr ||
+				alter_log_page(sb, alter_curr) != curr)
+			nova_dbg("Inode %llu page %d: curr 0x%llx, alter 0x%llx, alter_curr 0x%llx, alter 0x%llx\n",
+					pi->nova_ino, count1,
+					curr, alter_log_page(sb, curr),
+					alter_curr,
+					alter_log_page(sb, alter_curr));
+
+		count1++;
+		count2++;
+		if ((curr >> PAGE_SHIFT) == (pi->log_tail >> PAGE_SHIFT))
+			tail1_at = count1;
+		if ((alter_curr >> PAGE_SHIFT) ==
+				(pi->alter_log_tail >> PAGE_SHIFT))
+			tail2_at = count2;
+		curr = next_log_page(sb, curr);
+		alter_curr = next_log_page(sb, alter_curr);
+	}
+
+	while (curr) {
+		count1++;
+		if ((curr >> PAGE_SHIFT) == (pi->log_tail >> PAGE_SHIFT))
+			tail1_at = count1;
+		curr = next_log_page(sb, curr);
+	}
+
+	while (alter_curr) {
+		count2++;
+		if ((alter_curr >> PAGE_SHIFT) ==
+				(pi->alter_log_tail >> PAGE_SHIFT))
+			tail2_at = count2;
+		alter_curr = next_log_page(sb, alter_curr);
+	}
+
+	nova_dbg("Log1 %d pages, tail @ page %d\n", count1, tail1_at);
+	nova_dbg("Log2 %d pages, tail @ page %d\n", count2, tail2_at);
+
+	return 0;
+}
+
+void nova_print_free_lists(struct super_block *sb)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct free_list *free_list;
+	int i;
+
+	nova_dbg("======== NOVA per-CPU free list allocation stats ========\n");
+	for (i = 0; i < sbi->cpus; i++) {
+		free_list = nova_get_free_list(sb, i);
+		nova_dbg("Free list %d: block start %lu, block end %lu, num_blocks %lu, num_free_blocks %lu, blocknode %lu\n",
+			i, free_list->block_start, free_list->block_end,
+			free_list->block_end - free_list->block_start + 1,
+			free_list->num_free_blocks, free_list->num_blocknode);
+
+		nova_dbg("Free list %d: csum start %lu, replica csum start %lu, csum blocks %lu, parity start %lu, parity blocks %lu\n",
+			i, free_list->csum_start, free_list->replica_csum_start,
+			free_list->num_csum_blocks,
+			free_list->parity_start, free_list->num_parity_blocks);
+
+		nova_dbg("Free list %d: alloc log count %lu, allocated log pages %lu, alloc data count %lu, allocated data pages %lu, free log count %lu, freed log pages %lu, free data count %lu, freed data pages %lu\n",
+			 i,
+			 free_list->alloc_log_count,
+			 free_list->alloc_log_pages,
+			 free_list->alloc_data_count,
+			 free_list->alloc_data_pages,
+			 free_list->free_log_count,
+			 free_list->freed_log_pages,
+			 free_list->free_data_count,
+			 free_list->freed_data_pages);
+	}
+}
diff --git a/fs/nova/stats.h b/fs/nova/stats.h
new file mode 100644
index 000000000000..766ba0a77872
--- /dev/null
+++ b/fs/nova/stats.h
@@ -0,0 +1,218 @@
+/*
+ * NOVA File System statistics
+ *
+ * Copyright 2015-2016 Regents of the University of California,
+ * UCSD Non-Volatile Systems Lab, Andiry Xu <jix024@cs.ucsd.edu>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+
+/* ======================= Timing ========================= */
+enum timing_category {
+	/* Init */
+	init_title_t,
+	init_t,
+	mount_t,
+	ioremap_t,
+	new_init_t,
+	recovery_t,
+
+	/* Namei operations */
+	namei_title_t,
+	create_t,
+	lookup_t,
+	link_t,
+	unlink_t,
+	symlink_t,
+	mkdir_t,
+	rmdir_t,
+	mknod_t,
+	rename_t,
+	readdir_t,
+	add_dentry_t,
+	remove_dentry_t,
+	setattr_t,
+	setsize_t,
+
+	/* I/O operations */
+	io_title_t,
+	dax_read_t,
+	cow_write_t,
+	inplace_write_t,
+	copy_to_nvmm_t,
+	dax_get_block_t,
+	read_iter_t,
+	write_iter_t,
+
+	/* Memory operations */
+	memory_title_t,
+	memcpy_r_nvmm_t,
+	memcpy_w_nvmm_t,
+	memcpy_w_wb_t,
+	partial_block_t,
+
+	/* Memory management */
+	mm_title_t,
+	new_blocks_t,
+	new_data_blocks_t,
+	new_log_blocks_t,
+	free_blocks_t,
+	free_data_t,
+	free_log_t,
+
+	/* Transaction */
+	trans_title_t,
+	create_trans_t,
+	link_trans_t,
+	update_tail_t,
+
+	/* Logging */
+	logging_title_t,
+	append_dir_entry_t,
+	append_file_entry_t,
+	append_mmap_entry_t,
+	append_link_change_t,
+	append_setattr_t,
+	append_snapshot_info_t,
+	update_entry_t,
+
+	/* Tree */
+	tree_title_t,
+	check_entry_t,
+	assign_t,
+
+	/* GC */
+	gc_title_t,
+	fast_gc_t,
+	thorough_gc_t,
+	check_invalid_t,
+
+	/* Integrity */
+	integrity_title_t,
+	block_csum_t,
+	block_parity_t,
+	block_csum_parity_t,
+	protect_memcpy_t,
+	protect_file_data_t,
+	verify_entry_csum_t,
+	verify_data_csum_t,
+	calc_entry_csum_t,
+	restore_data_t,
+	reset_mapping_t,
+	reset_vma_t,
+
+	/* Others */
+	others_title_t,
+	find_cache_t,
+	fsync_t,
+	write_pages_t,
+	fallocate_t,
+	direct_IO_t,
+	free_old_t,
+	delete_file_tree_t,
+	delete_dir_tree_t,
+	new_vfs_inode_t,
+	new_nova_inode_t,
+	free_inode_t,
+	free_inode_log_t,
+	evict_inode_t,
+	perf_t,
+	wprotect_t,
+
+	/* Mmap */
+	mmap_title_t,
+	mmap_fault_t,
+	pmd_fault_t,
+	pfn_mkwrite_t,
+	insert_vma_t,
+	remove_vma_t,
+	set_vma_read_t,
+	mmap_cow_t,
+	update_mapping_t,
+	update_pfn_t,
+	mmap_handler_t,
+
+	/* Rebuild */
+	rebuild_title_t,
+	rebuild_dir_t,
+	rebuild_file_t,
+	rebuild_snapshot_t,
+
+	/* Snapshot */
+	snapshot_title_t,
+	create_snapshot_t,
+	init_snapshot_info_t,
+	delete_snapshot_t,
+	append_snapshot_file_t,
+	append_snapshot_inode_t,
+
+	/* Sentinel */
+	TIMING_NUM,
+};
+
+enum stats_category {
+	alloc_steps,
+	cow_write_breaks,
+	inplace_write_breaks,
+	read_bytes,
+	cow_write_bytes,
+	inplace_write_bytes,
+	fast_checked_pages,
+	thorough_checked_pages,
+	fast_gc_pages,
+	thorough_gc_pages,
+	dirty_pages,
+	protect_head,
+	protect_tail,
+	block_csum_parity,
+	dax_cow_during_snapshot,
+	mapping_updated_pages,
+	cow_overlap_mmap,
+	dax_new_blocks,
+	inplace_new_blocks,
+	fdatasync,
+
+	/* Sentinel */
+	STATS_NUM,
+};
+
+extern const char *Timingstring[TIMING_NUM];
+extern u64 Timingstats[TIMING_NUM];
+DECLARE_PER_CPU(u64[TIMING_NUM], Timingstats_percpu);
+extern u64 Countstats[TIMING_NUM];
+DECLARE_PER_CPU(u64[TIMING_NUM], Countstats_percpu);
+extern u64 IOstats[STATS_NUM];
+DECLARE_PER_CPU(u64[STATS_NUM], IOstats_percpu);
+
+typedef struct timespec timing_t;
+
+#define NOVA_START_TIMING(name, start) \
+	{if (measure_timing) getrawmonotonic(&start); }
+
+#define NOVA_END_TIMING(name, start) \
+	{if (measure_timing) { \
+		timing_t end; \
+		getrawmonotonic(&end); \
+		__this_cpu_add(Timingstats_percpu[name], \
+			(end.tv_sec - start.tv_sec) * 1000000000 + \
+			(end.tv_nsec - start.tv_nsec)); \
+	} \
+	__this_cpu_add(Countstats_percpu[name], 1); \
+	}
+
+#define NOVA_STATS_ADD(name, value) \
+	{__this_cpu_add(IOstats_percpu[name], value); }
+
+

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
