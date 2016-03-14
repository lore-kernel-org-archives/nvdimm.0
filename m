Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by ml01.01.org (Postfix) with ESMTP id 673691A1EBF
 for <linux-nvdimm@lists.01.org>; Mon, 14 Mar 2016 14:23:27 -0700 (PDT)
Date: Mon, 14 Mar 2016 17:23:44 -0400
From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH RFC 1/1] Add support for ZONE_DEVICE IO memory with
 struct pages.
Message-ID: <20160314212344.GC23727@linux.intel.com>
References: <1457979277-26791-1-git-send-email-stephen.bates@pmcs.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1457979277-26791-1-git-send-email-stephen.bates@pmcs.com>
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
To: Stephen Bates <stephen.bates@pmcs.com>
Cc: haggaie@mellanox.com, javier@cnexlabs.com, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, sagig@mellanox.com, linux-mm@kvack.org, artemyko@mellanox.com, hch@infradead.org, leonro@mellanox.com, jgunthorpe@obsidianresearch.com
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Mar 14, 2016 at 12:14:37PM -0600, Stephen Bates wrote:
> 3. Coherency Issues. When IOMEM is written from both the CPU and a PCIe
> peer there is potential for coherency issues and for writes to occur out
> of order. This is something that users of this feature need to be
> cognizant of and may necessitate the use of CONFIG_EXPERT. Though really,
> this isn't much different than the existing situation with RDMA: if
> userspace sets up an MR for remote use, they need to be careful about
> using that memory region themselves.

There's more to the coherency problem than this.  As I understand it, on
x86, memory in a PCI BAR does not participate in the coherency protocol.
So you can get a situation where CPU A stores 4 bytes to offset 8 in a
cacheline, then CPU B stores 4 bytes to offset 16 in the same cacheline,
and CPU A's write mysteriously goes missing.

I may have misunderstood the exact details when this was explained to me a
few years ago, but the details were horrible enough to run away screaming.
Pretending PCI BARs are real memory?  Just Say No.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
