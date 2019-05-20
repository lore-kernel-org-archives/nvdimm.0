Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9F4722125F1D6
 for <linux-nvdimm@lists.01.org>; Sun, 19 May 2019 20:47:43 -0700 (PDT)
Date: Sun, 19 May 2019 23:47:42 -0400 (EDT)
From: Pankaj Gupta <pagupta@redhat.com>
Message-ID: <68418388.29774907.1558324062441.JavaMail.zimbra@redhat.com>
In-Reply-To: <1902045958.29774859.1558323977950.JavaMail.zimbra@redhat.com>
References: <20190514145422.16923-1-pagupta@redhat.com>
 <20190514145422.16923-3-pagupta@redhat.com>
 <c06514fd-8675-ba74-4b7b-ff0eb4a91605@google.com>
 <1954162775.29408078.1558071358974.JavaMail.zimbra@redhat.com>
 <5e27fa73-53f5-007a-e0c1-f32f83e5764f@google.com>
 <1902045958.29774859.1558323977950.JavaMail.zimbra@redhat.com>
Subject: Re: [Qemu-devel] [PATCH v9 2/7] virtio-pmem: Add virtio pmem driver
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
To: Jakub =?utf-8?Q?Staro=C5=84?= <jstaron@google.com>
Cc: jack@suse.cz, kvm@vger.kernel.org, mst@redhat.com, jasowang@redhat.com, david@fromorbit.com, qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org, adilger kernel <adilger.kernel@dilger.ca>, smbarber@google.com, zwisler@kernel.org, aarcange@redhat.com, linux-nvdimm@lists.01.org, david@redhat.com, willy@infradead.org, hch@infradead.org, linux-acpi@vger.kernel.org, linux-ext4@vger.kernel.org, lenb@kernel.org, kilobyte@angband.pl, riel@surriel.com, yuval shaia <yuval.shaia@oracle.com>, stefanha@redhat.com, pbonzini@redhat.com, lcapitulino@redhat.com, kwolf@redhat.com, nilal@redhat.com, tytso@mit.edu, xiaoguangrong eric <xiaoguangrong.eric@gmail.com>, cohuck@redhat.com, rjw@rjwysocki.net, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, imammedo@redhat.com, darrick wong <darrick.wong@oracle.com>
List-ID: <linux-nvdimm@lists.01.org>


> 
> 
> > On 5/16/19 10:35 PM, Pankaj Gupta wrote:
> > > Can I take it your reviewed/acked-by? or tested-by tag? for the virtio
> > > patch :)I don't feel that I have enough expertise to give the reviewed-by
> > > tag, but you can
> > take my acked-by + tested-by.
> > 
> > Acked-by: Jakub Staron <jstaron@google.com>
> > Tested-by: Jakub Staron <jstaron@google.com>
> > 
> > No kernel panics/stalls encountered during testing this patches (v9) with
> > QEMU + xfstests.
> 
> Thank you for testing and confirming the results. I will add your tested &
> acked-by in v10.
> 
> > Some CPU stalls encountered while testing with crosvm instead of QEMU with
> > xfstests
> > (test generic/464) but no repro for QEMU, so the fault may be on the side
> > of
> > crosvm.
> 
> yes, looks like crosvm related as we did not see any of this in my and your
> testing with Qemu.

Also, they don't seem to be related with virtio-pmem.

Thanks,
Pankaj
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
