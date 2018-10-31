Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BE5AE2116745C
 for <linux-nvdimm@lists.01.org>; Wed, 31 Oct 2018 01:52:13 -0700 (PDT)
Subject: Re: [RFC PATCH] kvm: Use huge pages for DAX-backed files
References: <20181029210716.212159-1-brho@google.com>
 <CAPcyv4gJUjuSKwy7i2wuKR=Vz-AkDrxnGya5qkg7XTFxuXbtzw@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e00c5f69-f4d7-859c-cbde-0392b0a5195c@redhat.com>
Date: Wed, 31 Oct 2018 09:52:04 +0100
MIME-Version: 1.0
In-Reply-To: <CAPcyv4gJUjuSKwy7i2wuKR=Vz-AkDrxnGya5qkg7XTFxuXbtzw@mail.gmail.com>
Content-Language: en-US
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
To: Dan Williams <dan.j.williams@intel.com>, Barret Rhoden <brho@google.com>
Cc: X86 ML <x86@kernel.org>, "Zhang, Yu C" <yu.c.zhang@intel.com>, KVM list <kvm@vger.kernel.org>, rkrcmar@redhat.com, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, zwisler@kernel.org, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On 29/10/2018 23:25, Dan Williams wrote:
> I'm wondering if we're adding an explicit is_zone_device_page() check
> in this path to determine the page mapping size if that can be a
> replacement for the kvm_is_reserved_pfn() check. In other words, the
> goal of fixing up PageReserved() was to preclude the need for DAX-page
> special casing in KVM, but if we already need add some special casing
> for page size determination, might as well bypass the
> kvm_is_reserved_pfn() dependency as well.

No, please don't.  The kvm_is_reserved_pfn() check is for correctness,
the page-size check is for optimization.  In theory you could have a
ZONE_DEVICE area that is smaller than 2MB and thus does not use huge pages.

Paolo
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
