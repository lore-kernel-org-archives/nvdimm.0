Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com
 [IPv6:2607:f8b0:4864:20::342])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EC04F2117FD5D
 for <linux-nvdimm@lists.01.org>; Wed, 31 Oct 2018 14:16:13 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id c32so15920172otb.8
 for <linux-nvdimm@lists.01.org>; Wed, 31 Oct 2018 14:16:13 -0700 (PDT)
MIME-Version: 1.0
References: <20181029210716.212159-1-brho@google.com>
 <CAPcyv4gJUjuSKwy7i2wuKR=Vz-AkDrxnGya5qkg7XTFxuXbtzw@mail.gmail.com>
 <e00c5f69-f4d7-859c-cbde-0392b0a5195c@redhat.com>
In-Reply-To: <e00c5f69-f4d7-859c-cbde-0392b0a5195c@redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 31 Oct 2018 14:16:01 -0700
Message-ID: <CAPcyv4hqOhCBvYjxY31kc+BD+MraCBtou=MogApp_5wpz3W6Cw@mail.gmail.com>
Subject: Re: [RFC PATCH] kvm: Use huge pages for DAX-backed files
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
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Barret Rhoden <brho@google.com>, X86 ML <x86@kernel.org>, "Zhang," Yu C" <yu.c.zhang@intel.com>, KVM list <kvm@vger.kernel.org>," rkrcmar@redhat.com, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, zwisler@kernel.org, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Oct 31, 2018 at 1:52 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 29/10/2018 23:25, Dan Williams wrote:
> > I'm wondering if we're adding an explicit is_zone_device_page() check
> > in this path to determine the page mapping size if that can be a
> > replacement for the kvm_is_reserved_pfn() check. In other words, the
> > goal of fixing up PageReserved() was to preclude the need for DAX-page
> > special casing in KVM, but if we already need add some special casing
> > for page size determination, might as well bypass the
> > kvm_is_reserved_pfn() dependency as well.
>
> No, please don't.  The kvm_is_reserved_pfn() check is for correctness,
> the page-size check is for optimization.  In theory you could have a
> ZONE_DEVICE area that is smaller than 2MB and thus does not use huge pages.

To be clear, I was not suggesting that a ZONE_DEVICE check would be
sufficient to determine a 2MB page. I was suggesting that given there
is a debate about removing the "reserved" designation for dax pages
that debate is moot if kvm is going to add interrogation code to
figure out the size of dax mappings.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
