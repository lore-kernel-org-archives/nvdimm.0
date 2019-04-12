Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 663C6211F99AF
 for <linux-nvdimm@lists.01.org>; Fri, 12 Apr 2019 06:12:38 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v5 1/6] libnvdimm: nd_region flush callback support
References: <20190410040826.24371-1-pagupta@redhat.com>
 <20190410040826.24371-2-pagupta@redhat.com>
 <CAPcyv4i1FjBzfcWtzeCvj-giHa9xaX0dMQ==q4LZC_L8VEqkHg@mail.gmail.com>
 <20190412083230.GA29850@quack2.suse.cz>
Date: Fri, 12 Apr 2019 09:12:10 -0400
In-Reply-To: <20190412083230.GA29850@quack2.suse.cz> (Jan Kara's message of
 "Fri, 12 Apr 2019 10:32:30 +0200")
Message-ID: <x494l73z7th.fsf@segfault.boston.devel.redhat.com>
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
To: Jan Kara <jack@suse.cz>
Cc: cohuck@redhat.com, KVM list <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, david <david@fromorbit.com>, Qemu Developers <qemu-devel@nongnu.org>, virtualization@lists.linux-foundation.org, Andreas Dilger <adilger.kernel@dilger.ca>, Ross Zwisler <zwisler@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, David Hildenbrand <david@redhat.com>, Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@infradead.org>, Linux ACPI <linux-acpi@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, Len Brown <lenb@kernel.org>, kilobyte@angband.pl, Rik van Riel <riel@surriel.com>, yuval.shaia@oracle.com, Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, lcapitulino@redhat.com, Kevin Wolf <kwolf@redhat.com>, Nitesh Narayan Lal <nilal@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Xiao Guangrong <xiaoguangrong.eric@gmail.com>, "Darrick J. Wong  <darrick.wong@oracle.com>,  Rafael J. Wysocki  <rjw@rjwysocki.net>, Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Igor Mammedov <imammedo@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

Jan Kara <jack@suse.cz> writes:

> On Thu 11-04-19 07:51:48, Dan Williams wrote:
>> On Tue, Apr 9, 2019 at 9:09 PM Pankaj Gupta <pagupta@redhat.com> wrote:
>> > +       } else {
>> > +               if (nd_region->flush(nd_region))
>> > +                       rc = -EIO;
>> 
>> Given the common case wants to be fast and synchronous I think we
>> should try to avoid retpoline overhead by default. So something like
>> this:
>> 
>> if (nd_region->flush == generic_nvdimm_flush)
>>     rc = generic_nvdimm_flush(...);
>
> I'd either add a comment about avoiding retpoline overhead here or just
> make ->flush == NULL mean generic_nvdimm_flush(). Just so that people don't
> get confused by the code.

Isn't this premature optimization?  I really don't like adding things
like this without some numbers to show it's worth it.

-Jeff
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
