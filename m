Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-io0-x242.google.com (mail-io0-x242.google.com
 [IPv6:2607:f8b0:4001:c06::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E60412034A88F
 for <linux-nvdimm@lists.01.org>; Fri, 27 Oct 2017 04:38:30 -0700 (PDT)
Received: by mail-io0-x242.google.com with SMTP id 97so12069301iok.7
 for <linux-nvdimm@lists.01.org>; Fri, 27 Oct 2017 04:42:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171027064854.GE3666@dastard>
References: <150846713528.24336.4459262264611579791.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171020074750.GA13568@lst.de> <20171020093148.GA20304@lst.de>
 <20171026105850.GA31161@quack2.suse.cz> <1509061831.25213.2.camel@intel.com>
 <20171027064854.GE3666@dastard>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 27 Oct 2017 13:42:16 +0200
Message-ID: <CAA9_cmdx7T2jnfw6TvL0_3ytfs-h-X06uF3_7Ex-YP12YKpwng@mail.gmail.com>
Subject: Re: [PATCH v3 00/13] dax: fix dma vs truncate and remove 'page-less'
 support
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
To: Dave Chinner <david@fromorbit.com>
Cc: "mhocko@suse.com" <mhocko@suse.com>, "jack@suse.cz" <jack@suse.cz>, "benh@kernel.crashing.org" <benh@kernel.crashing.org>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>, "bfields@fieldses.org" <bfields@fieldses.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "paulus@samba.org" <paulus@samba.org>, "Hefty, Sean" <sean.hefty@intel.com>, "hch@lst.de" <hch@lst.de>, "mawilcox@microsoft.com" <mawilcox@microsoft.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "mpe@ellerman.id.au" <mpe@ellerman.id.au>, "jgunthorpe@obsidianresearch.com" <jgunthorpe@obsidianresearch.com>, "dledford@redhat.com" <dledford@redhat.com>, "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "jlayton@poochiereds.net" <jlayton@poochiereds.net>, "gerald.schaefer@de.ibm.com" <gerald.schaefer@de.ibm.com>, "darrick.wong@oracle.com" <darrick.wong@oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

[replying from my phone, please forgive formatting]

On Friday, October 27, 2017, Dave Chinner <david@fromorbit.com> wrote:


> > Here are the two primary patches in
> > the series, do you think the extent-busy approach would be cleaner?
>
> The XFS_DAXDMA....
>
> $DEITY that patch is so ugly I can't even bring myself to type it.


Right, and so is the problem it's trying to solve. So where do you want to
go from here?

I could go back to the FL_ALLOCATED approach, but use page idle callbacks
instead of polling for the lease end notification. Or do we want to try
busy extents? My concern with busy extents is that it requires more per-fs
code.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
