From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: fix dax_dev NULL dereference
Date: Tue, 30 Jul 2019 18:01:02 -0400
Message-ID: <20190730220102.GA15604@redhat.com>
References: <20190730113708.14660-1-pagupta@redhat.com>
 <2030283543.5419072.1564486701158.JavaMail.zimbra@redhat.com>
 <20190730190737.GA14873@redhat.com>
 <CAPcyv4i10K3QdSwa3EF9t8pS-QrB9YcBEMy49N1PnYQzCkBJCw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPcyv4i10K3QdSwa3EF9t8pS-QrB9YcBEMy49N1PnYQzCkBJCw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Pankaj Gupta <pagupta@redhat.com>, device-mapper development <dm-devel@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Alasdair Kergon <agk@redhat.com>, jencce.kernel@gmail.com
List-Id: linux-nvdimm@lists.01.org

On Tue, Jul 30 2019 at  5:38pm -0400,
Dan Williams <dan.j.williams@intel.com> wrote:

> On Tue, Jul 30, 2019 at 12:07 PM Mike Snitzer <snitzer@redhat.com> wrote:
> >
> > I staged the fix (which I tweaked) here:
> > https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.3&id=95b9ebb78c4c733f8912a195fbd0bc19960e726e
> 
> Thanks for picking this up Mike, but I'd prefer to just teach
> dax_synchronous() to return false if the passed in dax_dev is NULL.
> Thoughts?

I considered that too but I moved away from it because I'm so used to
the various block interfaces requiring the caller pass a non-NULL
pointer (e.g. request_queue):

$ grep -ri return drivers/md/dm-table.c | grep \&\&
drivers/md/dm-table.c:        return dev->dax_dev && dax_synchronous(dev->dax_dev);
drivers/md/dm-table.c:        return q && blk_queue_zoned_model(q) == *zoned_model;
drivers/md/dm-table.c:        return q && blk_queue_zone_sectors(q) == *zone_sectors;
drivers/md/dm-table.c:        return q && (q->queue_flags & flush);
drivers/md/dm-table.c:        return q && blk_queue_nonrot(q);
drivers/md/dm-table.c:        return q && !blk_queue_add_random(q);
drivers/md/dm-table.c:        return q && !q->limits.max_write_same_sectors;
drivers/md/dm-table.c:        return q && !q->limits.max_write_zeroes_sectors;
drivers/md/dm-table.c:        return q && !blk_queue_discard(q);
drivers/md/dm-table.c:        return q && !blk_queue_secure_erase(q);
drivers/md/dm-table.c:        return q && bdi_cap_stable_pages_required(q->backing_dev_info);

I'm fine with however you'd like to skin this cat though.

Just let me know and I'll keep/drop this patch accordingly.

Thanks,
Mike
