Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A7B9921256BDF
 for <linux-nvdimm@lists.01.org>; Tue, 14 May 2019 03:02:53 -0700 (PDT)
Date: Tue, 14 May 2019 06:02:48 -0400 (EDT)
From: Pankaj Gupta <pagupta@redhat.com>
Message-ID: <919431491.28558886.1557828168896.JavaMail.zimbra@redhat.com>
In-Reply-To: <cd5572ac-14d0-f872-6321-c522daa70f49@redhat.com>
References: <20190510155202.14737-1-pagupta@redhat.com>
 <20190510155202.14737-3-pagupta@redhat.com>
 <f2ea35a6-ec98-447c-44fe-0cb3ab309340@redhat.com>
 <752392764.28554139.1557826022323.JavaMail.zimbra@redhat.com>
 <86298c2c-cc7c-5b97-0f11-335d7da8c450@redhat.com>
 <712871093.28555872.1557827242385.JavaMail.zimbra@redhat.com>
 <cd5572ac-14d0-f872-6321-c522daa70f49@redhat.com>
Subject: Re: [PATCH v8 2/6] virtio-pmem: Add virtio pmem driver
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
To: David Hildenbrand <david@redhat.com>
Cc: cohuck@redhat.com, jack@suse.cz, kvm@vger.kernel.org, mst@redhat.com, jasowang@redhat.com, david@fromorbit.com, qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org, adilger kernel <adilger.kernel@dilger.ca>, zwisler@kernel.org, aarcange@redhat.com, jstaron@google.com, linux-nvdimm@lists.01.org, willy@infradead.org, hch@infradead.org, linux-acpi@vger.kernel.org, linux-ext4@vger.kernel.org, lenb@kernel.org, kilobyte@angband.pl, riel@surriel.com, yuval shaia <yuval.shaia@oracle.com>, stefanha@redhat.com, pbonzini@redhat.com, lcapitulino@redhat.com, kwolf@redhat.com, nilal@redhat.com, tytso@mit.edu, xiaoguangrong eric <xiaoguangrong.eric@gmail.com>, darrick wong <darrick.wong@oracle.com>, rjw@rjwysocki.net, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, imammedo@redhat.com
List-ID: <linux-nvdimm@lists.01.org>


> >>
> >> I think you should do the same here, vdev->priv is allocated in
> >> virtio_pmem_probe.
> >>
> >> But maybe I am missing something important here :)
> > 
> > Because virtio_balloon use "kzalloc" for allocation and needs to be freed.
> > But virtio pmem uses "devm_kzalloc" which takes care of automatically
> > deleting
> > the device memory when associated device is detached.
> 
> Hehe, thanks, that was the part that I was missing!

Thank you for the review.

Best regards,
Pankaj
> 
> --
> 
> Thanks,
> 
> David / dhildenb
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
