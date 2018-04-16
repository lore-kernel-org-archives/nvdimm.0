Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-lf0-x244.google.com (mail-lf0-x244.google.com
 [IPv6:2a00:1450:4010:c07::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6369E2244E40C
 for <linux-nvdimm@lists.01.org>; Mon, 16 Apr 2018 11:28:43 -0700 (PDT)
Received: by mail-lf0-x244.google.com with SMTP id d20-v6so23542432lfe.3
 for <linux-nvdimm@lists.01.org>; Mon, 16 Apr 2018 11:28:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180416182146.GC12686@bombadil.infradead.org>
References: <20180414155059.GA18015@jordon-HP-15-Notebook-PC>
 <CAPcyv4g+Gdc2tJ1qrM5Xn9vtARw-ZqFXaMbiaBKJJsYDtSNBig@mail.gmail.com>
 <20180416174740.GA12686@bombadil.infradead.org>
 <CAPcyv4hUsADs9ueDfLKvcqHvz3Z4ziW=a1V6rkcOtTvoJhw7xg@mail.gmail.com>
 <20180416182146.GC12686@bombadil.infradead.org>
From: Souptick Joarder <jrdr.linux@gmail.com>
Date: Mon, 16 Apr 2018 23:58:40 +0530
Message-ID: <CAFqt6zZ9BJXjBxjJy06fOTZo8ybVYg3YOQjGbdaWK0NoAhzofg@mail.gmail.com>
Subject: Re: [PATCH] dax: Change return type to vm_fault_t
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
To: Matthew Wilcox <willy@infradead.org>
Cc: Linux MM <linux-mm@kvack.org>, Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Apr 16, 2018 at 11:51 PM, Matthew Wilcox <willy@infradead.org> wrote:
> On Mon, Apr 16, 2018 at 11:00:26AM -0700, Dan Williams wrote:
>> On Mon, Apr 16, 2018 at 10:47 AM, Matthew Wilcox <willy@infradead.org> wrote:
>> > On Mon, Apr 16, 2018 at 09:14:48AM -0700, Dan Williams wrote:
>> >> > -       rc = vm_insert_mixed(vmf->vma, vmf->address, pfn);
>> >> > -
>> >> > -       if (rc == -ENOMEM)
>> >> > -               return VM_FAULT_OOM;
>> >> > -       if (rc < 0 && rc != -EBUSY)
>> >> > -               return VM_FAULT_SIGBUS;
>> >> > -
>> >> > -       return VM_FAULT_NOPAGE;
>> >> > +       return vmf_insert_mixed(vmf->vma, vmf->address, pfn);
>> >>
>> >> Ugh, so this change to vmf_insert_mixed() went upstream without fixing
>> >> the users? This changelog is now misleading as it does not mention
>> >> that is now an urgent standalone fix. On first read I assumed this was
>> >> part of a wider effort for 4.18.
>> >
>> > You read too quickly.  vmf_insert_mixed() is a *new* function which
>> > *replaces* vm_insert_mixed() and
>> > awful-mangling-of-return-values-done-per-driver.
>> >
>> > Eventually vm_insert_mixed() will be deleted.  But today is not that day.
>>
>> Ah, ok, thanks for the clarification. Then this patch should
>> definitely be re-titled to "dax: convert to the new vmf_insert_mixed()
>> helper". The vm_fault_t conversion is just a minor side-effect of that
>> larger change. I assume this can wait for v4.18.

The primary objective is to change the return type to
vm_fault_t in all fault handlers and to support that
we have replace vm_insert_mixed() with vmf_insert_
mixed() within one fault handler function.

Do I really need to change the patch title ?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
