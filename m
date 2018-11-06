Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: Re: [RFC PATCH] kvm: Use huge pages for DAX-backed files
References: <20181029210716.212159-1-brho@google.com>
 <CAPcyv4gJUjuSKwy7i2wuKR=Vz-AkDrxnGya5qkg7XTFxuXbtzw@mail.gmail.com>
 <e00c5f69-f4d7-859c-cbde-0392b0a5195c@redhat.com>
 <CAPcyv4hqOhCBvYjxY31kc+BD+MraCBtou=MogApp_5wpz3W6Cw@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <30bdd995-ef1c-f869-388c-76434dd2499f@redhat.com>
Date: Tue, 6 Nov 2018 11:22:20 +0100
MIME-Version: 1.0
In-Reply-To: <CAPcyv4hqOhCBvYjxY31kc+BD+MraCBtou=MogApp_5wpz3W6Cw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Barret Rhoden <brho@google.com>, Dave Jiang <dave.jiang@intel.com>, zwisler@kernel.org, Vishal L Verma <vishal.l.verma@intel.com>, rkrcmar@redhat.com, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>, "Zhang, Yu C" <yu.c.zhang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On 31/10/2018 22:16, Dan Williams wrote:
>> No, please don't.  The kvm_is_reserved_pfn() check is for correctness,
>> the page-size check is for optimization.  In theory you could have a
>> ZONE_DEVICE area that is smaller than 2MB and thus does not use huge pages.
> To be clear, I was not suggesting that a ZONE_DEVICE check would be
> sufficient to determine a 2MB page. I was suggesting that given there
> is a debate about removing the "reserved" designation for dax pages
> that debate is moot if kvm is going to add interrogation code to
> figure out the size of dax mappings.

Oh indeed.  And in general it's okay for me to add more ZONE_DEVICE
checks to complement the existing PageReserved checks, if DAX pages are
not going to be reserved anymore.

In some cases, such as the "if (!PageReserved(page)) SetPageDirty(page)"
that Barret noted, it may even be more correct for KVM if DAX pages stop
being reserved.  All this given my very limited knowledge of MM though...

Paolo
