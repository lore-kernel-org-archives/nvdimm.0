Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22e.google.com (mail-oi0-x22e.google.com
 [IPv6:2607:f8b0:4003:c06::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 384C821A04823
 for <linux-nvdimm@lists.01.org>; Tue, 11 Apr 2017 13:10:23 -0700 (PDT)
Received: by mail-oi0-x22e.google.com with SMTP id f22so9789815oib.2
 for <linux-nvdimm@lists.01.org>; Tue, 11 Apr 2017 13:10:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <x49r30yg116.fsf@segfault.boston.devel.redhat.com>
References: <149159694856.26101.16830021017958812113.stgit@dwillia2-desk3.amr.corp.intel.com>
 <x49r30yg116.fsf@segfault.boston.devel.redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 11 Apr 2017 13:10:22 -0700
Message-ID: <CAPcyv4gr2NPrCC3hr8g6aM-N=SQPkmbmpKWw0byvRj2iYgMVjQ@mail.gmail.com>
Subject: Re: [PATCH] libnvdimm: fix btt vs clear poison locking
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Apr 11, 2017 at 1:08 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Dan Williams <dan.j.williams@intel.com> writes:
>
>> As a minimal fix, disable error clearing when the BTT is enabled. For
>> the final fix a larger rework of the poison list locking is needed.
>
>> @@ -243,7 +243,15 @@ static int nsio_rw_bytes(struct nd_namespace_common *ndns,
>>       }
>>
>>       if (unlikely(is_bad_pmem(&nsio->bb, sector, sz_align))) {
>> -             if (IS_ALIGNED(offset, 512) && IS_ALIGNED(size, 512)) {
>> +             /*
>> +              * FIXME: nsio_rw_bytes() may be called from atomic
>> +              * context in the BTT case and nvdimm_clear_poison()
>> +              * takes a sleeping lock. Until the locking can be
>> +              * reworked this capability depends on !BTT or BROKEN.
>> +              */
>> +             if ((!IS_ENABLED(CONFIG_BTT) || IS_ENABLED(CONFIG_BROKEN))
>> +                             && IS_ALIGNED(offset, 512)
>> +                             && IS_ALIGNED(size, 512)) {
>
> I don't like that you've disabled clear error just because the btt
> driver was enabled.  Can't you do something like this, instead?

Ooh, yes we can and that's much better.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
