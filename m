Return-Path: <linux-nvdimm-bounces@lists.01.org>
MIME-Version: 1.0
In-Reply-To: <CAPcyv4je93955ou-7nEsfLA49T7PUgfkcweckXA-y8QgThY4zg@mail.gmail.com>
References: <1467102671-593138-1-git-send-email-yigal@plexistor.com>
 <CAPcyv4jQA29oY2e6mVjQ=mEyBRXev3fAn1=2BH_GjzvQN6N4Rg@mail.gmail.com>
 <90bb0807-1fdb-f15e-ff9f-4e7aa7a62ab9@zytor.com>
 <CAPcyv4je93955ou-7nEsfLA49T7PUgfkcweckXA-y8QgThY4zg@mail.gmail.com>
From: Yigal Korman <yigal@plexistor.com>
Date: Wed, 29 Jun 2016 08:12:51 +0300
Message-ID: <CACTTzNa4cW02BRn=4mFoT=Bgd06dxOuu6LSUfaCtiTwfXDa4Gw@mail.gmail.com>
Subject: Re: [RESEND PATCH] x86/mm: only allow memmap=XX!YY over existing RAM
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jun 29, 2016 at 4:09 AM, Dan Williams <dan.j.williams@intel.com> wrote:
>
> On Tue, Jun 28, 2016 at 10:58 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> > On 06/28/16 09:33, Dan Williams wrote:
> >> On Tue, Jun 28, 2016 at 1:31 AM, Yigal Korman <yigal@plexistor.com> wrote:
> >>> Before this patch, passing a range that is beyond the physical memory
> >>> range will succeed, the user will see a /dev/pmem0 and will be able to
> >>> access it. Reads will always return 0 and writes will be silently
> >>> ignored.
> >>>
> >>> I've gotten more than one bug report about mkfs.{xfs,ext4} or nvml
> >>> failing that were eventually tracked down to be wrong values passed to
> >>> memmap.
> >>>
> >>> This patch prevents the above issue by instead of adding a new memory
> >>> range, only update a RAM memory range with the PRAM type. This way,
> >>> passing the wrong memmap will either not give you a pmem at all or give
> >>> you a smaller one that actually has RAM behind it.
> >>>
> >>> And if someone still needs to fake a pmem that doesn't have RAM behind
> >>> it, they can simply do memmap=XX@YY,XX!YY.
> >>>
> >>> Signed-off-by: Yigal Korman <yigal@plexistor.com>
> >>> Acked-by: Dan Williams <dan.j.williams@intel.com>
> >>> Acked-by: Johannes Thumshirn <jthumshirn@suse.de>
> >>> Tested-by: Boaz Harrosh <boaz@plexistor.com>
> >>> ---
> >>
> >> I have some other libnvdimm fixes heading upstream shortly if x86
> >> folks just want to ack this one...
> >>
> >
> > I'm concerned about this.  This would mean that memory not marked as RAM
> > because it is persistent and you don't want the OS to accidentally
> > clobber persistent RAM can't be added.
>
> Ah true.  Specifically you are worried about the case where a
> platform-firmware has mis-marked pmem as reserved memory (or some
> other type) and would like to correct it to be pram.


As I mentioned in the patch, this is still possible by doing memmap=X@Y,X!Y
Also, with fixes in grub and the kernel regarding mis-marking NVDIMMs
this is much less common today.
My purpose was simply to prevent a repeating user error for the common use case.

>
>
> > So it seems like The Wrong
> > Thing.  If all you want is simulated pram then it shouldn't care about
> > addresses in the first place and instead we should just specify it by
> > quantity.
>
> Yes, agree we need an explicit "simulate pram" option independent of
> memmap=, or just continue to educate users that if they try to
> simulate pmem and specify an invalid range they get to keep all the
> broken pieces.

I'd love to have a simpler way to specify simulated pram, but quantity
is not good enough.
For my use case, for example, I need the quantity to be spread evenly
over all NUMA nodes, so just getting a range "somewhere" is not good.
And I can imagine other users that want to pin pram to same socket
where their high speed NIC sits.
So I not sure we can find a better general api than memmap and I not
sure it's worth it.

Thanks,
Yigal
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
