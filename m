Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22d.google.com (mail-oi0-x22d.google.com
 [IPv6:2607:f8b0:4003:c06::22d])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D5CD62095E537
 for <linux-nvdimm@lists.01.org>; Tue, 26 Sep 2017 06:56:26 -0700 (PDT)
Received: by mail-oi0-x22d.google.com with SMTP id j126so11998253oia.10
 for <linux-nvdimm@lists.01.org>; Tue, 26 Sep 2017 06:59:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170926063234.GA6870@lst.de>
References: <20170925231404.32723-1-ross.zwisler@linux.intel.com>
 <20170925231404.32723-4-ross.zwisler@linux.intel.com>
 <20170926063234.GA6870@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 26 Sep 2017 06:59:37 -0700
Message-ID: <CAPcyv4hKb1PshbjLxyWz2fdj=dK2fi2qgJLFaT9pVnmaOoWV6g@mail.gmail.com>
Subject: Re: [PATCH 3/7] xfs: protect S_DAX transitions in XFS read path
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
Cc: Jeff Layton <jlayton@poochiereds.net>, Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Linux MM <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Sep 25, 2017 at 11:32 PM, Christoph Hellwig <hch@lst.de> wrote:
> We can't just take locking one level up, as we need differnet locking
> for different kinds of I/O.
>
> I think you probably want an IOCB_DAX flag to check IS_DAX once and
> then stick to it, similar to what we do for direct I/O.

I wonder if this works better with a reference count mechanism
per-file so that we don't need a hold a lock over the whole
transition. Similar to request_queue reference counting, when DAX is
being turned off we block new references and drain the in-flight ones.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
