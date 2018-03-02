Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22f.google.com (mail-oi0-x22f.google.com
 [IPv6:2607:f8b0:4003:c06::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B77EB223522A6
 for <linux-nvdimm@lists.01.org>; Fri,  2 Mar 2018 14:15:31 -0800 (PST)
Received: by mail-oi0-x22f.google.com with SMTP id c83so8152467oib.1
 for <linux-nvdimm@lists.01.org>; Fri, 02 Mar 2018 14:21:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180302221020.GA30722@lst.de>
References: <151996281307.28483.12343847096989509127.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180302221020.GA30722@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 2 Mar 2018 14:21:40 -0800
Message-ID: <CAPcyv4gKyvkHY_qQTYvd8wrLpaXXciJyWZY+9T7Q_Eg-Zuxpgw@mail.gmail.com>
Subject: Re: [PATCH v5 00/12] vfio, dax: prevent long term filesystem-dax pins
 and other fixes
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
To: Christoph Hellwig <hch@lst.de>
Cc: Jane Chu <jane.chu@oracle.com>, Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, KVM list <kvm@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Alex Williamson <alex.williamson@redhat.com>, Gerd Rausch <gerd.rausch@oracle.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Mar 2, 2018 at 2:10 PM, Christoph Hellwig <hch@lst.de> wrote:
> I really don't like these IS_DEVDAX and IS_FSDAX flags.  We should
> stop pretending DAX is a global per-inode choice and get rid of these
> magic flags entirely.  So please convert the instances inside the
> various file systems to checking the file system mount options instead.
>
> For the core ones we'll need to differentiate:
>
>  - the checks in generic_file_read_iter and __generic_file_write_iter
>    seem to not be needed anymore at all since we stopped abusing the
>    direct I/O code for DAX, so they should probably be removed.
>  - io_is_direct is a weird check and should probably just go away,
>    as there is not point in always setting IOCB_DIRECT for DAX I/O
>  - fadvise should either become a file op, or a flag on the inode that
>    fadvice is supported instead of the nasty noop_backing_dev_info or
>    DAX check.
>  - Ditto for madvise
>  - vma_is_dax should probably be replaced with a VMA flag.
>  - thp_get_unmapped_area I don't really understand why we have a dax
>    check there.
>  - dax_mapping will be much harder to sort out.
>
> But all these DAX flags certainly look like a major hodge podge to me.

They are indeed a hodge-podge. The problem is that the current
IS_DAX() is broken. So I'd like to propose fixing IS_DAX() with
IS_FSDAX() + IS_DEVDAX() for 4.16-rc4 and queue up these wider reworks
you propose for the next merge window.

Acceptable?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
