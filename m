Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x230.google.com (mail-oi0-x230.google.com
 [IPv6:2607:f8b0:4003:c06::230])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9E57A21F322DA
 for <linux-nvdimm@lists.01.org>; Wed, 27 Sep 2017 08:51:47 -0700 (PDT)
Received: by mail-oi0-x230.google.com with SMTP id b184so17393696oii.13
 for <linux-nvdimm@lists.01.org>; Wed, 27 Sep 2017 08:55:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170927153918.GA24314@linux.intel.com>
References: <20170925231404.32723-1-ross.zwisler@linux.intel.com>
 <20170925231404.32723-7-ross.zwisler@linux.intel.com>
 <CAPcyv4jtO028KeZK7SdkOUsgMLGqgttLzBCYgH0M+RP3eAXf4A@mail.gmail.com>
 <20170926185751.GB31146@linux.intel.com>
 <CAPcyv4iVc9y8PE24ZvkiBYdp4Die0Q-K5S6QexW_6YQ_M0F4QA@mail.gmail.com>
 <20170926210645.GA7798@linux.intel.com>
 <CAPcyv4iDTNteQAt1bBHCGijwsk45rJWHfdr+e_rOwK39jpC2Og@mail.gmail.com>
 <20170927113527.GD25746@quack2.suse.cz>
 <20170927153918.GA24314@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 27 Sep 2017 08:54:59 -0700
Message-ID: <CAPcyv4gXt673Jz2__t7LwvaFrRGxa5czgoB-b8kdjAfOETAH9Q@mail.gmail.com>
Subject: Re: [PATCH 6/7] mm, fs: introduce file_operations->post_mmap()
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Jan Kara <jack@suse.cz>, Dan Williams <dan.j.williams@intel.com>, Andrew Morton <akpm@linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, "J. Bruce Fields" <bfields@fieldses.org>, Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>, Jeff Layton <jlayton@poochiereds.net>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, linux-xfs@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Sep 27, 2017 at 8:39 AM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> On Wed, Sep 27, 2017 at 01:35:27PM +0200, Jan Kara wrote:
[..]
>> Hum, this is an interesting option. So do you suggest that filesystems
>> supporting DAX would always setup mappings with VM_MIXEDMAP and without
>> VM_HUGEPAGE and thus we'd get rid of dependency on S_DAX flag in ->mmap?
>> That could actually work. The only possible issue I can see is that
>> VM_MIXEDMAP is still slightly different from normal page mappings and it
>> could have some performance implications - e.g. copy_page_range() does more
>> work on VM_MIXEDMAP mappings but not on normal page mappings.
>
> It looks like having VM_MIXEDMAP always set for filesystems that support DAX
> might affect their memory's NUMA migration in the non-DAX case?
>
> 8e76d4e sched, numa: do not hint for NUMA balancing on VM_MIXEDMAP mappings

Addressed separately here:

c1ef8e2c0235 mm: disable numa migration faults for dax vmas
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
