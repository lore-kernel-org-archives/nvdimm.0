Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 95C552194EB77
 for <linux-nvdimm@lists.01.org>; Mon, 22 Apr 2019 08:51:49 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v5 1/6] libnvdimm: nd_region flush callback support
References: <20190410040826.24371-1-pagupta@redhat.com>
 <20190410040826.24371-2-pagupta@redhat.com>
 <CAPcyv4i1FjBzfcWtzeCvj-giHa9xaX0dMQ==q4LZC_L8VEqkHg@mail.gmail.com>
 <20190412083230.GA29850@quack2.suse.cz>
 <x494l73z7th.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4jrNHqW3FuGkeo==ZoJr7LKahCv4_esnokfy7enek8=2Q@mail.gmail.com>
 <20190418161833.GA22970@infradead.org>
 <CAPcyv4jPOF_+R6U17J_+88+X8LC-LSPCugA6gbKxuphuuFB2gg@mail.gmail.com>
Date: Mon, 22 Apr 2019 11:51:35 -0400
In-Reply-To: <CAPcyv4jPOF_+R6U17J_+88+X8LC-LSPCugA6gbKxuphuuFB2gg@mail.gmail.com>
 (Dan Williams's message of "Thu, 18 Apr 2019 11:14:59 -0700")
Message-ID: <x497ebm82d4.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
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
Cc: cohuck@redhat.com, Jan Kara <jack@suse.cz>, KVM list <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, david <david@fromorbit.com>, Qemu Developers <qemu-devel@nongnu.org>, virtualization@lists.linux-foundation.org, Andreas Dilger <adilger.kernel@dilger.ca>, Ross Zwisler <zwisler@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, David Hildenbrand <david@redhat.com>, Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@infradead.org>, Linux ACPI <linux-acpi@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, Len Brown <lenb@kernel.org>, kilobyte@angband.pl, Rik van Riel <riel@surriel.com>, yuval shaia <yuval.shaia@oracle.com>, Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, lcapitulino@redhat.com, Kevin Wolf <kwolf@redhat.com>, Nitesh Narayan Lal <nilal@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Xiao Guangrong <xiaoguangrong.eric@gmail.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Igor Mammedov <imammedo@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

Dan Williams <dan.j.williams@intel.com> writes:

> On Thu, Apr 18, 2019 at 9:18 AM Christoph Hellwig <hch@infradead.org> wrote:
>>
>> On Thu, Apr 18, 2019 at 09:05:05AM -0700, Dan Williams wrote:
>> > > > I'd either add a comment about avoiding retpoline overhead here or just
>> > > > make ->flush == NULL mean generic_nvdimm_flush(). Just so that people don't
>> > > > get confused by the code.
>> > >
>> > > Isn't this premature optimization?  I really don't like adding things
>> > > like this without some numbers to show it's worth it.
>> >
>> > I don't think it's premature given this optimization technique is
>> > already being deployed elsewhere, see:
>> >
>> > https://lwn.net/Articles/774347/
>>
>> For one this one was backed by numbers, and second after feedback
>> from Linux we switched to the NULL pointer check instead.
>
> Ok I should have noticed the switch to NULL pointer check. However,
> the question still stands do we want everyone to run numbers to
> justify this optimization, or make it a new common kernel coding
> practice to do:
>
>     if (!object->op)
>         generic_op(object);
>     else
>         object->op(object);
>
> ...in hot paths?

I don't think nvdimm_flush is a hot path.  Numbers of some
representative workload would prove one of us right.

-Jeff
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
