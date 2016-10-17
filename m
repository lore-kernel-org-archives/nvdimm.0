Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22b.google.com (mail-oi0-x22b.google.com
 [IPv6:2607:f8b0:4003:c06::22b])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B6B4F1A1E10
 for <linux-nvdimm@lists.01.org>; Mon, 17 Oct 2016 11:55:54 -0700 (PDT)
Received: by mail-oi0-x22b.google.com with SMTP id d132so223740597oib.2
 for <linux-nvdimm@lists.01.org>; Mon, 17 Oct 2016 11:55:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1476725956.20881.68.camel@hpe.com>
References: <1476465913-25305-1-git-send-email-toshi.kani@hpe.com>
 <20161015075443.GG27872@dastard> <1476725956.20881.68.camel@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 17 Oct 2016 11:55:53 -0700
Message-ID: <CAPcyv4h-5CUs8iApR5=_M_qx1oMuVq5vkyOej6Ci=B5oj-Bs-g@mail.gmail.com>
Subject: Re: [PATCH] DAX: enable iostat for read/write
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
To: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "david@fromorbit.com" <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Oct 17, 2016 at 10:40 AM, Kani, Toshimitsu <toshi.kani@hpe.com> wrote:
> On Sat, 2016-10-15 at 18:54 +1100, Dave Chinner wrote:
>> On Fri, Oct 14, 2016 at 11:25:13AM -0600, Toshi Kani wrote:
>  :
>> > +static void dax_iostat_start(struct gendisk *disk, struct iov_iter
>> > *iter,
>> > +     unsigned long *start)
>> > +{
>> > +int rw = iov_iter_rw(iter);
>> > +int sec = iov_iter_count(iter) >> 9;
>> > +int cpu = part_stat_lock();
>> > +
>> > +*start = jiffies;
>> > +part_round_stats(cpu, &disk->part0);
>> > +part_stat_inc(cpu, &disk->part0, ios[rw]);
>> > +part_stat_add(cpu, &disk->part0, sectors[rw], sec);
>> > +part_inc_in_flight(&disk->part0, rw);
>> > +part_stat_unlock();
>> > +}
>>
>> Why reimplement generic_start_io_acct() and generic_end_io_acct()?
>
> It was modeled after __nd_iostat_start() / nd_iostart_end().  I agree
> that we can use generic_start_io_acct() and generic_end_io_acct() here.
>
> Should we also change the nd interface to use the generic version as
> well?

Yes, sounds good to me.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
