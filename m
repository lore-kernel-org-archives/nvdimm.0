Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com
 [IPv6:2607:f8b0:4864:20::344])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CDEFF2194EB75
 for <linux-nvdimm@lists.01.org>; Tue, 16 Jul 2019 20:04:40 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id l15so23399564otn.9
 for <linux-nvdimm@lists.01.org>; Tue, 16 Jul 2019 20:02:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190712051610.15478-1-pagupta@redhat.com>
 <20190712101021-mutt-send-email-mst@kernel.org>
In-Reply-To: <20190712101021-mutt-send-email-mst@kernel.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 16 Jul 2019 20:02:00 -0700
Message-ID: <CAPcyv4joSgj7ok4DfW3tWQGavRDP8kp7oQRH8DgkG=0eWgNn1g@mail.gmail.com>
Subject: Re: [PATCH v3] virtio_pmem: fix sparse warning
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
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Cornelia Huck <cohuck@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, yuval shaia <yuval.shaia@oracle.com>, virtualization@lists.linux-foundation.org, lcapitulino@redhat.com
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jul 12, 2019 at 7:11 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Fri, Jul 12, 2019 at 10:46:10AM +0530, Pankaj Gupta wrote:
> > This patch fixes below sparse warning related to __virtio
> > type in virtio pmem driver. This is reported by Intel test
> > bot on linux-next tree.
> >
> > nd_virtio.c:56:28: warning: incorrect type in assignment
> >                                 (different base types)
> > nd_virtio.c:56:28:    expected unsigned int [unsigned] [usertype] type
> > nd_virtio.c:56:28:    got restricted __virtio32
> > nd_virtio.c:93:59: warning: incorrect type in argument 2
> >                                 (different base types)
> > nd_virtio.c:93:59:    expected restricted __virtio32 [usertype] val
> > nd_virtio.c:93:59:    got unsigned int [unsigned] [usertype] ret
> >
> > Reported-by: kbuild test robot <lkp@intel.com>
> > Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
>
> Pls merge - I assume nvdimm tree?

Yes, I'll push this with the rest to Linus tomorrow morning.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
