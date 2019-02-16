Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com
 [IPv6:2607:f8b0:4864:20::344])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8228D208D6124
 for <linux-nvdimm@lists.01.org>; Fri, 15 Feb 2019 18:08:28 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id v62so10982657otb.3
 for <linux-nvdimm@lists.01.org>; Fri, 15 Feb 2019 18:08:28 -0800 (PST)
MIME-Version: 1.0
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 15 Feb 2019 18:08:15 -0800
Message-ID: <CAPcyv4gs7nGnf81Lj-Hf04uhmMb2wxKzi42ajaNVCHty7PAsAQ@mail.gmail.com>
Subject: find_get_entries_tag regression bisected
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
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Balcer,
List-ID: <linux-nvdimm@lists.01.org>

Hi Willy,

Piotr reports the following crash can be triggered on latest mainline:

 EXT4-fs (pmem5): recovery complete
 EXT4-fs (pmem5): mounted filesystem with ordered data mode. Opts: dax
 ------------[ cut here ]------------
 kernel BUG at mm/pgtable-generic.c:127!
 invalid opcode: 0000 [#1] SMP PTI
 CPU: 28 PID: 1193 Comm: a.out Tainted: G        W  OE     4.19.0-rc5+ #2907
 [..]
 RIP: 0010:pmdp_huge_clear_flush+0x1e/0x80
 [..]
 Call Trace:
  dax_writeback_mapping_range+0x473/0x8a0
  ? print_shortest_lock_dependencies+0x40/0x40
  ? jbd2_journal_stop+0xef/0x470
  ? ext4_fill_super+0x3071/0x3110
  ? __lock_is_held+0x4f/0x90
  ? __lock_is_held+0x4f/0x90
  ext4_dax_writepages+0xed/0x2f0
  do_writepages+0x41/0xe0
  __filemap_fdatawrite_range+0xbe/0xf0
  file_write_and_wait_range+0x4c/0xa0
  ext4_sync_file+0xa6/0x4f0

I bisected this regression to commit c1901cd33cf4 "page cache: Convert
find_get_entries_tag to XArray". I suspect another case of pte vs pmd
confusion.

Below is the small reproducer from Piotr, it triggers in a qemu
environment with emulated pmem, but only with ext4 that I can see, but
I did not dig too deep. Let me know if anything jumps out to you. I'll
otherwise take a deeper look in the coming days.


#include <sys/mman.h>
#include <unistd.h>
#include <stdio.h>
#include <fcntl.h>
#include <string.h>
#include <assert.h>

#define MB (1ULL << 20)

int
main(int argc, char *argv[])
{
    int ret;
    int fd;
    off_t size = 2 * MB;

    char *path = argv[1];

    fd = open(path, O_RDWR | O_CREAT | O_EXCL, 0666);
    assert(fd > 0);

    ret = ftruncate(fd, size);
    assert(ret == 0);

    char *addr = mmap(NULL, size, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
    assert(addr != MAP_FAILED);

    memset((char*)addr, '0', 1);

    ret = msync(addr + 4096, 1, MS_SYNC);
    assert(ret == 0);

    close(fd);

    return 0;
}
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
