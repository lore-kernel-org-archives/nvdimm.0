Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DC146211616B3
 for <linux-nvdimm@lists.01.org>; Tue,  2 Oct 2018 07:45:48 -0700 (PDT)
Date: Tue, 2 Oct 2018 07:45:47 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Problems with VM_MIXEDMAP removal from /proc/<pid>/smaps
Message-ID: <20181002144547.GA26735@infradead.org>
References: <20181002100531.GC4135@quack2.suse.cz>
 <20181002121039.GA3274@linux-x5ow.site>
 <20181002142010.GB4963@linux-x5ow.site>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20181002142010.GB4963@linux-x5ow.site>
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
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, mhocko@suse.cz, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Oct 02, 2018 at 04:20:10PM +0200, Johannes Thumshirn wrote:
>     Provide a F_GETDAX fcntl(2) command so an application can query
>     whether it can make use of DAX or not.

How does an application "make use of DAX"?  What actual user visible
semantics are associated with a file that has this flag set?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
