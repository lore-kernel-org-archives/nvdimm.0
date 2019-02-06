Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1505D2194D3B8
 for <linux-nvdimm@lists.01.org>; Wed,  6 Feb 2019 15:17:10 -0800 (PST)
Date: Wed, 6 Feb 2019 15:17:06 -0800
From: Larry Bassel <larry.bassel@oracle.com>
Subject: question about mmap MAP_PRIVATE on PMEM/DAX/fs files
Message-ID: <20190206231706.GB23860@ubuette>
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
To: linux-nvdimm@lists.01.org
Cc: linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Is mmaping a PMEM/DAX/fs file MAP_PRIVATE supported? Is it something
that people are likely to want to do?

If it is supported, suppose I open a file in PMEM/DAX/fs, mmap it
MAP_PRIVATE, read from the memory mapped file (with memory accesses,
not the read syscall) and take a page fault which the kernel satisfies.

At this time do my page tables for the private mmaped page(s) point to the
PMEM corresponding to the file and the kernel will wait until
the page(s) is/are altered (either by me or someone else) to
copy on write and give me a different page/mapping?

Or does the kernel avoid this by always mapping a copy of the
page(s) involved in the private mmap in the first place?

In either case, is my private copy going to come from PMEM or is it
an "ordinary" page, or is this "random"? Does the program have
any choice in this (i.e. suppose I want to make sure my copied
page is persistent)?

Thanks.

Larry
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
