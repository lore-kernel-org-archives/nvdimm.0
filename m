Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x231.google.com (mail-oi0-x231.google.com
 [IPv6:2607:f8b0:4003:c06::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D09E421C8F608
 for <linux-nvdimm@lists.01.org>; Sun, 18 Jun 2017 19:03:35 -0700 (PDT)
Received: by mail-oi0-x231.google.com with SMTP id p66so14120366oia.0
 for <linux-nvdimm@lists.01.org>; Sun, 18 Jun 2017 19:04:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170618083702.GB26456@lst.de>
References: <149703982465.20620.14881139332926778446.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149703983692.20620.3787021839815275819.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170618083702.GB26456@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 18 Jun 2017 19:04:56 -0700
Message-ID: <CAPcyv4hMThgvV6mejT57d_PHbHzVZ3BWyGwFWOx5J40X=2NwDg@mail.gmail.com>
Subject: Re: [PATCH v3 02/14] dm: add ->copy_from_iter() dax operation support
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
To: Christoph Hellwig <hch@lst.de>
Cc: Mike Snitzer <snitzer@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, dm-devel@redhat.com, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Jun 18, 2017 at 1:37 AM, Christoph Hellwig <hch@lst.de> wrote:
>> +size_t dax_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
>> +             size_t bytes, struct iov_iter *i)
>> +{
>> +     if (!dax_alive(dax_dev))
>> +             return 0;
>> +
>> +     if (!dax_dev->ops->copy_from_iter)
>> +             return copy_from_iter(addr, bytes, i);
>> +     return dax_dev->ops->copy_from_iter(dax_dev, pgoff, addr, bytes, i);
>> +}
>> +EXPORT_SYMBOL_GPL(dax_copy_from_iter);
>
> Can you remove the fallbacks after this series so that we have
> a clean abstraction?

You mean update all implementations to register copy_from_iter() as
their default op rather than workaround a NULL op in the core? Yeah, I
can do that.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
