Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A96CC21290D20
 for <linux-nvdimm@lists.01.org>; Tue, 11 Jun 2019 19:23:13 -0700 (PDT)
Date: Tue, 11 Jun 2019 22:23:09 -0400 (EDT)
From: Pankaj Gupta <pagupta@redhat.com>
Message-ID: <332155967.34508010.1560306189624.JavaMail.zimbra@redhat.com>
In-Reply-To: <20190611171416.GA1248@redhat.com>
References: <20190611163802.25352-1-pagupta@redhat.com>
 <20190611163802.25352-5-pagupta@redhat.com>
 <20190611171416.GA1248@redhat.com>
Subject: Re: [Qemu-devel] [PATCH v12 4/7] dm: enable synchronous dax
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: rdunlap@infradead.org, jack@suse.cz, kvm@vger.kernel.org, mst@redhat.com, jasowang@redhat.com, david@fromorbit.com, qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org, dm-devel@redhat.com, adilger kernel <adilger.kernel@dilger.ca>, zwisler@kernel.org, aarcange@redhat.com, jstaron@google.com, linux-nvdimm@lists.01.org, david@redhat.com, willy@infradead.org, hch@infradead.org, linux-acpi@vger.kernel.org, linux-ext4@vger.kernel.org, lenb@kernel.org, kilobyte@angband.pl, riel@surriel.com, yuval shaia <yuval.shaia@oracle.com>, stefanha@redhat.com, imammedo@redhat.com, lcapitulino@redhat.com, kwolf@redhat.com, nilal@redhat.com, tytso@mit.edu, xiaoguangrong eric <xiaoguangrong.eric@gmail.com>, cohuck@redhat.com, rjw@rjwysocki.net, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, pbonzini@redhat.com, darrick wong <darrick.wong@oracle.com>
List-ID: <linux-nvdimm@lists.01.org>


> On Tue, Jun 11 2019 at 12:37pm -0400,
> Pankaj Gupta <pagupta@redhat.com> wrote:
> 
> > This patch sets dax device 'DAXDEV_SYNC' flag if all the target
> > devices of device mapper support synchrononous DAX. If device
> > mapper consists of both synchronous and asynchronous dax devices,
> > we don't set 'DAXDEV_SYNC' flag.
> > 
> > 'dm_table_supports_dax' is refactored to pass 'iterate_devices_fn'
> > as argument so that the callers can pass the appropriate functions.
> > 
> > Suggested-by: Mike Snitzer <snitzer@redhat.com>
> > Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
> 
> Thanks, and for the benefit of others, passing function pointers like
> this is perfectly fine IMHO because this code is _not_ in the fast
> path.  These methods are only for device creation.
> 
> Reviewed-by: Mike Snitzer <snitzer@redhat.com>

Thank you, Mike

Best regards,
Pankaj

> 
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
