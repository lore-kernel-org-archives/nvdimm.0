Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1C0A3211DB40F
 for <linux-nvdimm@lists.01.org>; Mon, 11 Mar 2019 08:09:49 -0700 (PDT)
Date: Mon, 11 Mar 2019 08:09:47 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: Hang / zombie process from Xarray page-fault conversion (bisected)
Message-ID: <20190311150947.GD19508@bombadil.infradead.org>
References: <CAPcyv4hwHpX-MkUEqxwdTj7wCCZCN4RV-L4jsnuwLGyL_UEG4A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4hwHpX-MkUEqxwdTj7wCCZCN4RV-L4jsnuwLGyL_UEG4A@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, "Barror, Robert" <robert.barror@intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 07, 2019 at 10:16:17PM -0800, Dan Williams wrote:
> Hi Willy,
> 
> We're seeing a case where RocksDB hangs and becomes defunct when
> trying to kill the process. v4.19 succeeds and v4.20 fails. Robert was
> able to bisect this to commit b15cd800682f "dax: Convert page fault
> handlers to XArray".
> 
> I see some direct usage of xa_index and wonder if there are some more
> pmd fixups to do?
> 
> Other thoughts?

I don't see why killing a process would have much to do with PMD
misalignment.  The symptoms (hanging on a signal) smell much more like
leaving a locked entry in the tree.  Is this easy to reproduce?  Can you
get /proc/$pid/stack for a hung task?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
