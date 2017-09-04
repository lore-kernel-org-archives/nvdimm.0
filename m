Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22b.google.com (mail-oi0-x22b.google.com
 [IPv6:2607:f8b0:4003:c06::22b])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D2DC821E3EA89
 for <linux-nvdimm@lists.01.org>; Mon,  4 Sep 2017 08:52:46 -0700 (PDT)
Received: by mail-oi0-x22b.google.com with SMTP id t75so6691815oie.3
 for <linux-nvdimm@lists.01.org>; Mon, 04 Sep 2017 08:55:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170904102619.GA1761@quack2.suse.cz>
References: <150445955491.4453.8477796864040491127.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170904102619.GA1761@quack2.suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 4 Sep 2017 08:55:33 -0700
Message-ID: <CAPcyv4jECxVyHcxTx_HqVd6KzM_j69DSzw_sRJt-GYmwWGkWaw@mail.gmail.com>
Subject: Re: [PATCH] dax: fix FS_DAX=n BLOCK=y compilation
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
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, kbuild test robot <fengguang.wu@intel.com>, Christoph Hellwig <hch@lst.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Sep 4, 2017 at 3:26 AM, Jan Kara <jack@suse.cz> wrote:
> On Sun 03-09-17 10:25:55, Dan Williams wrote:
>> The 0day kbuild robot reports:
>>
>> >> drivers//dax/super.c:64:20: error: redefinition of 'fs_dax_get_by_bdev'
>>     struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev)
>>                        ^~~~~~~~~~~~~~~~~~
>>    In file included from drivers//dax/super.c:22:0:
>>    include/linux/dax.h:76:34: note: previous definition of 'fs_dax_get_by_bdev' was here
>>     static inline struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev)
>>                                      ^~~~~~~~~~~~~~~~~~
>>
>> Protect the definition of fs_dax_get_by_bdev() in drivers/dax/super.c
>> with an ifdef.
>>
>> Fixes: 78f354735081 ("dax: introduce a fs_dax_get_by_bdev() helper")
>> Cc: Jan Kara <jack@suse.cz>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: Darrick J. Wong <darrick.wong@oracle.com>
>> Reported-by: kbuild test robot <fengguang.wu@intel.com>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>
> OK, or you could have both !DAX and DAX implementations in
> include/linux/dax.h as inline together? It would look a bit more logical to
> me. But I don't care much. So
>
> Reviewed-by: Jan Kara <jack@suse.cz>

My motivation for not doing that is to avoid including blkdev.h from dax.h.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
