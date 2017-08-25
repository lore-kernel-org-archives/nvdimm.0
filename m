Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x232.google.com (mail-oi0-x232.google.com
 [IPv6:2607:f8b0:4003:c06::232])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 704CD21E47D42
 for <linux-nvdimm@lists.01.org>; Thu, 24 Aug 2017 23:21:35 -0700 (PDT)
Received: by mail-oi0-x232.google.com with SMTP id r9so13541701oie.3
 for <linux-nvdimm@lists.01.org>; Thu, 24 Aug 2017 23:24:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170825053246.GF4800@magnolia>
References: <150362134292.39142.1715377949592729029.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150362134833.39142.12423673180125514125.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170825053246.GF4800@magnolia>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 24 Aug 2017 23:24:10 -0700
Message-ID: <CAPcyv4iXvOV6gHc=VsozHhxCdWDibx64agAk86K-G2-CdHVpuA@mail.gmail.com>
Subject: Re: [PATCH 1/2] xfs: cache dax_device lookup result
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 24, 2017 at 10:32 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Thu, Aug 24, 2017 at 05:35:48PM -0700, Dan Williams wrote:
>> The ->iomap_begin() operation is a hot path, so cache the
>> fs_dax_get_by_host() result to avoid the incurring the hash lookup
>> overhead.
>
> Just out of curiosity (and sorry if this has already been discussed to
> death and I'm merely ignorant) but I was wondering why the daxdev isn't
> simply attached to the block_device?  Is it not a 1:1 mapping?

The motivation was to remove all dax details from the block layer.
However, we still have the QUEUE_DAX flag which defeats that goal.
Hmm, a dax_device is similar to a request_queue as a path to access
capacity, so I think it might make sense to just replace the queue
flag with a full ->dax_dev pointer hanging off the gendisk.

This would also fix the bug I just realized was in these patches
around matching dax_get_by_host() with put_dax(). In fact, if it's
acceptable to hang a dax_dev off a gendisk then we don't need
dax_get_by_host() at all.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
