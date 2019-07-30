Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com
 [IPv6:2607:f8b0:4864:20::d42])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9B061212E470D
 for <linux-nvdimm@lists.01.org>; Tue, 30 Jul 2019 15:18:13 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id k8so131873880iot.1
 for <linux-nvdimm@lists.01.org>; Tue, 30 Jul 2019 15:15:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190730113708.14660-1-pagupta@redhat.com>
 <2030283543.5419072.1564486701158.JavaMail.zimbra@redhat.com>
 <20190730190737.GA14873@redhat.com>
 <CAPcyv4i10K3QdSwa3EF9t8pS-QrB9YcBEMy49N1PnYQzCkBJCw@mail.gmail.com>
 <20190730220102.GA15604@redhat.com>
In-Reply-To: <20190730220102.GA15604@redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 30 Jul 2019 15:15:30 -0700
Message-ID: <CAA9_cmd8to1108H+osSuyyRriX50-g1YV3YebJ=PNsKbW0NPFw@mail.gmail.com>
Subject: Re: dm: fix dax_dev NULL dereference
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
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Alasdair Kergon <agk@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jul 30, 2019 at 3:01 PM Mike Snitzer <snitzer@redhat.com> wrote:
>
> On Tue, Jul 30 2019 at  5:38pm -0400,
> Dan Williams <dan.j.williams@intel.com> wrote:
>
> > On Tue, Jul 30, 2019 at 12:07 PM Mike Snitzer <snitzer@redhat.com> wrote:
> > >
> > > I staged the fix (which I tweaked) here:
> > > https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.3&id=95b9ebb78c4c733f8912a195fbd0bc19960e726e
> >
> > Thanks for picking this up Mike, but I'd prefer to just teach
> > dax_synchronous() to return false if the passed in dax_dev is NULL.
> > Thoughts?
>
> I considered that too but I moved away from it because I'm so used to
> the various block interfaces requiring the caller pass a non-NULL
> pointer (e.g. request_queue):
>
> $ grep -ri return drivers/md/dm-table.c | grep \&\&
> drivers/md/dm-table.c:        return dev->dax_dev && dax_synchronous(dev->dax_dev);
> drivers/md/dm-table.c:        return q && blk_queue_zoned_model(q) == *zoned_model;
> drivers/md/dm-table.c:        return q && blk_queue_zone_sectors(q) == *zone_sectors;
> drivers/md/dm-table.c:        return q && (q->queue_flags & flush);
> drivers/md/dm-table.c:        return q && blk_queue_nonrot(q);
> drivers/md/dm-table.c:        return q && !blk_queue_add_random(q);
> drivers/md/dm-table.c:        return q && !q->limits.max_write_same_sectors;
> drivers/md/dm-table.c:        return q && !q->limits.max_write_zeroes_sectors;
> drivers/md/dm-table.c:        return q && !blk_queue_discard(q);
> drivers/md/dm-table.c:        return q && !blk_queue_secure_erase(q);
> drivers/md/dm-table.c:        return q && bdi_cap_stable_pages_required(q->backing_dev_info);
>
> I'm fine with however you'd like to skin this cat though.
>
> Just let me know and I'll keep/drop this patch accordingly.

Ok, since you've already got it queued, and there are no other
required "if (!dax_dev)" fixups go ahead with what you have.

    Acked-by: Dan Williams <dan.j.williams@intel.com>

I just reserve the right to go push it down a level if the kernel ever
grows more dax_synchronous() users that do that safety check.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
