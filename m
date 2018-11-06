From: Barret Rhoden <brho@google.com>
Subject: Re: [RFC PATCH] kvm: Use huge pages for DAX-backed files
Date: Tue, 6 Nov 2018 16:17:20 -0500
Message-ID: <20181106161720.4a0ecc11@gnomeregan.cam.corp.google.com>
References: <20181029210716.212159-1-brho@google.com>
        <20181106160553.5a8025ed@gnomeregan.cam.corp.google.com>
        <13b9a5a5-6773-131e-8014-f1b1bc975794@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <13b9a5a5-6773-131e-8014-f1b1bc975794@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, Ross Zwisler <zwisler@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org, yu.c.zhang@intel.com, yi.z.zhang@intel.com
List-Id: linux-nvdimm@lists.01.org

On 2018-11-06 at 22:16 Paolo Bonzini <pbonzini@redhat.com> wrote:
> Yes, iter.gfn is the gfn inside the loop and iter.level is the level
> (1=PTE, 2=PDE, ...).  iter.level of course is unusable here, similar to
> *levelp in transparent_hugepage_adjust, but you can use iter.gfn and
> gfn_to_hva.

Great, thanks!
